Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE6ECAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 10:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 316CC8E001E; Wed,  8 Oct 2025 06:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE9A8E0005; Wed,  8 Oct 2025 06:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD918E001E; Wed,  8 Oct 2025 06:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 091768E0005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 06:26:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B5BEF1A0460
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:25:59 +0000 (UTC)
X-FDA: 83974566438.13.B8C8860
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4EC88140003
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:25:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gSXNGhcY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759919157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNni03cCLoKxNAy1iFCW07A1GVi+OBHHW77MJibUk4s=;
	b=T9JDmRxawBz1hcwZeoktlCTPdcYmdVe0FGM3ARX/A7PgLG5VopPeyMhQFwEufO/xdJyxqi
	+UmSKskNKbIpZ13AROiMUXUfXq2Cqwef6VgB0rCVDDpUnyIdOfuKqoI7L+BvNzXURWUy6Z
	p/k8ds9f0BDjdEYNFcxCCK1iJ/+Pu1E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gSXNGhcY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759919157; a=rsa-sha256;
	cv=none;
	b=kTvM9hgtirC7cCGVfGi1fkyW7oBVDSReORX9mDHBPEUcssVO3rIlNIBZNzSwzdntOrc/u6
	uXVPa2epe40EQLIMUw2DB+vpMgG2ijTI4DZwm0mMKPNhAXesGgUhaHlUjChzlGPK4zfXrL
	YGCIn3aPycQCZW67JYVfgMYDKWqrguA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759919156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iNni03cCLoKxNAy1iFCW07A1GVi+OBHHW77MJibUk4s=;
	b=gSXNGhcYfrPnHrFQ0MqjAEHWI/E8xV5iq8bqwAfk3aE8y5KRgGe3rSVgEhMvrzcBhjUrKA
	FikG/zgo83nkHGsMD89RE9TxBCrvTZ4FVbV2aQ6xcv7Ysq9xCMYj6rFnX/rJZZP4kSocMo
	TL+LI7cLq61CaZ4gRPnMpuEHPz6MBcQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-TZyGLWfrN0eudnGUJp_-YA-1; Wed, 08 Oct 2025 06:25:53 -0400
X-MC-Unique: TZyGLWfrN0eudnGUJp_-YA-1
X-Mimecast-MFC-AGG-ID: TZyGLWfrN0eudnGUJp_-YA_1759919152
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ed9557f976so4912693f8f.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 03:25:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759919152; x=1760523952;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iNni03cCLoKxNAy1iFCW07A1GVi+OBHHW77MJibUk4s=;
        b=oPRcna8JaC9C3hv4r5FvVtgH2+YpzksYGtKdhh8nRzPSGWk+NKKo0+eAXUJgmhikVT
         YdEkTfmhQke3yOOBeXmbyrnUGP3XadR3ib64BSMGIu8fvNpl/8MZK/RKs7XInlj4viNc
         i9Suw5IOIDZ/Er0Pg0etkqsJAu9yRrGvkKQn+qkTBccvIFr3w24ybUw/FTej/IDzeGSk
         WN21IeGU1+d1y7WimlUGmOCS3ACzmFTJAhbMV5itnDKIWZDCMWCP7gOBuqh4/bN8MBhX
         r6w5LYohkLmEwOysvZTtB0lE2Y3MZKGUANEoyUewgL98tQzQQVcpfQuGwVtFs3i2Hmiw
         sHSg==
X-Forwarded-Encrypted: i=1; AJvYcCW4fyhNOXLvBHWoL3IoY0HDz0jxDGIZE7B+4VMZczl5MbI8wH9o3vqDyUD8upufwnC/7+eIb1UMqQ==@kvack.org
X-Gm-Message-State: AOJu0YyRCbsgE01n4L5q7zZeC57oM4785mYW++03xaoo0jBPkFEJgN99
	s8sjfUQZPDlYJ1Ie6rrlnGTT6eqgLChugklu2gH9cwMR4RONT1f5NGm6ZyMkltw2je7aY3sKI+3
	30IejD/vd184U2dv1huaXRkE0EJIpuN+7Ui+kIcXtQubPzlX45eG7yrfxYxFs
X-Gm-Gg: ASbGncu7TDR8Hyh/KJnAV1sjCP/S7XUhp6TODGDKrjN/PK1axUFRuXknqFCBZ1rbIu3
	nRAgjQDUC1oKAaKHJ6JThYqW3jMo+mN6mBB1x3J8avNoloNPUwF6ioB8Ezq/Md5gheHJqZKiAwN
	f41+FGubMGkPTNOS/u6DTC12b/AnXhIsUATjoIJ8+1PDKD2pnZbfxPwvvlWDkRP1JntJ9eCVs8w
	ZmwJ82SM39gcVS/vZNWLuRzaULahG1tPLSdpg5eqUjRZl0OBIgQvxkA3SOlb+kCE4TpsRx9qC01
	oACikQdpmNkoU4A1eLKafXvZGIMtVlwHb4yegfrVjSEksf8ZVTuvpSp3RQCcJAEdU+AM3Os4IEd
	OH2qeEb2K
X-Received: by 2002:a05:6000:1887:b0:3eb:7f7d:aefb with SMTP id ffacd0b85a97d-4266e8de95amr1808503f8f.53.1759919152125;
        Wed, 08 Oct 2025 03:25:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNJ7WIcGiUsbhNPfzekdhhO4y7C0sfjWAwPmH1BooPn1e7YhqMEXDmldhm8SRwWWNQWwAtgg==
X-Received: by 2002:a05:6000:1887:b0:3eb:7f7d:aefb with SMTP id ffacd0b85a97d-4266e8de95amr1808480f8f.53.1759919151732;
        Wed, 08 Oct 2025 03:25:51 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f011bsm29758943f8f.46.2025.10.08.03.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 03:25:51 -0700 (PDT)
Message-ID: <77e6300f-dde7-4790-9c4c-6b3e7d40516f@redhat.com>
Date: Wed, 8 Oct 2025 12:25:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm, swap: rename helper for setup bad slots
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Ying Huang <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-2-74860ef8ba74@tencent.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-2-74860ef8ba74@tencent.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xU_ahfNIXlGSDzlttXDkpFqEjMG5jsPrZ4Qd3ww88Yk_1759919152
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EC88140003
X-Rspamd-Server: rspam03
X-Stat-Signature: zwp11waz5tcc94uxg5td5ajtp4jue486
X-HE-Tag: 1759919157-413693
X-HE-Meta: U2FsdGVkX18RBOuLZ5/NV5IBducX4tIFnPQw01y/jdEmJxXCEv0Bq8pyQkUXIjL9cS2IBRjcwd+qoYame5C2zNRQ+0XuUAdoHfSQiH6KWYBteSmQJAKyCQtaFIXmyuP4ZnBSg0626MkFeU6kWJ0kkCJRsPRpz9Hq02e+ovgVgOLFSdhepcQKQJSAThSp1f14I2Ta+GLvYQalCyI8CXfAPgt6gZVsYnoTaD28oVpmN8EFoGV7B8u2y6hL5X5MKE20j3+w+XTNOMst4pZ//tsS8QNUXGPQZNGAQ6xRA1guR12Ugy51g5rEtBZxRV6pkx8bRTGtAg28klAnnnqXZiyprmjJ7ZI9s38NlWBQU5Px6vAVs7HUcTzOaG6vwbQE4xBpQZPV5WJN3pRwsaho2EfBh7OCBbyRCIDZCefhqDz1cvOA4a3g6hy1zrPSGgX0G9dBXPFmK718hb4oHuejCCK0rxeyjtRPvsLYm/9ChPFD6JSmxBFevIs1QUQPs1JJuzk8yH6GL3Y8mcEDLuZEPLARoIZd/Ql3gNtm7d6XJbRWvtkjaYBDb+0Xt/+xyhMNY0DReg4dqyX24PLZecYcIKzsK5hEAMFKDlrIs/TMejuR1lo1jC8PaXywTUz5wqDMpVGevn6RbVgGkO0lYPw/Z7hcFDiGlJtlW0xy7xfqV7/Dlt2xFPtcnLUKu2XoBLwFquo5JxUjRaZbpBWQ64rqK4Zzenox/7ttLe7MB8oOPDmv89O2OqRrx9r75z4oLJqweX5aX2utuWvQdwQQ7yB8+bZr3cECRIrta98TtmWW+GaQfY9u9U8PAXnUF06blXgUj7jwh42+Ulf/jrPPpI4ll/iuyFyAfddKzywplAxqyPGuIHHSA17fyC3/8sG1PkGVUQC83VYfUUQD3Xd9TdfhcBbkrXCwbirZt/SKR4YspAnEMjr6/JkklQO5ydZvJxx/BFWR+y0VsPnIfPNMK2rYTzl
 F60QC5zl
 HdtUUUjwzPqo7dYEfRC4wzsMclw0ub52ZEobxrjQ+3YAhjueylNNWRB9p2BZ9OJho2PDZ7mRnxwCqdK2LO40DKCM5IhobKvjnjXzaraMTy5Ah4Rl+QysA0bsL2ygnjlUOhEQLYl6DOhyX7kxTAaV2/T+izQ0332SxfH9h2v1KNf0L+YhfH2v57rXRvF51xQIVKvrK37KSRo6/e6CRoE5o+jJpPbEpS2Bk6KXVGJ+FNntfbhG3cjrnSRVxuIv/3c3NRF8HMc9oPFP89Ddf5D4j7eYdTHNjyoTaqRPn8ZsnLGra3DaL9Ux2IkuPWJ5LHS4BZkdAbSJ7V1Gbu2si5bualsq/LG4j/tgUpzGIE/RcOgieqQevpx3fOZwNV/nw7kuzQ6LnPcz6AOyqNnZztWSaNch/Fd8DFbSzEYE9tB4vt/PAWfhMuvuYM6s1mA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.10.25 22:02, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The name inc_cluster_info_page is very confusing, as this helper is only
> used during swapon to mark bad slots. Rename it properly and turn the
> VM_BUG_ON in it into WARN_ON to expose more potential issues. Swapon is
> a cold path, so adding more checks should be a good idea.
> 
> No feature change except new WARN_ON.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


