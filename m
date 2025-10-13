Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD5D6CCD18E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463548E0060; Mon, 13 Oct 2025 11:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4140B8E0009; Mon, 13 Oct 2025 11:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A568E0060; Mon, 13 Oct 2025 11:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2199D8E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:50:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA268C053C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:49:59 +0000 (UTC)
X-FDA: 83993526918.05.7D9EA70
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 30455C0010
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:49:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K4nr1sr7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760370597; a=rsa-sha256;
	cv=none;
	b=1kcKD1li6Q7RGM1qcuzq5m4bxMbqLV+6c8p4S2Ryw16J8AOd9Q0pJZI6fMnQk4Ti8sQtj4
	lC0MJ1fR2ZeNsFOUXn13wiohw5otYaI0Ao5MH3g/QSSfYqHIllPYLewYsvzoUinv7tsAar
	P1Swh1fqx+qRJvy82PmDB5TLz0d44SU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K4nr1sr7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760370597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBtzVCMtBjg29Q+0bM2iI60bYXDGfP4ERe4mSdYo3XE=;
	b=JXziBARmoFYEXTbe8b6zJRvISiJk49/cbpB3SwAAXlUb/rrDdDFY9+dtMqlzlDDELnQ71z
	pDzxUHHe9UHSfwMrJDuYojjKvO0M1itPLVzE+Em+QaHDcf51wIL7OBLfTby963VXbXLs3J
	KCqfIk8nByXLXh6ieG7hWpi8WvbQc3Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760370596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XBtzVCMtBjg29Q+0bM2iI60bYXDGfP4ERe4mSdYo3XE=;
	b=K4nr1sr7s6abAxQFmyBjHfi1/MvSKmuXkoIh+bDd4f4yw67vktZ02sR1DVe5elgkAPGoYk
	VE7RmTR1vN/rxKw6675ofQXxi+CGpxT9eccPDL0Q1OYFwNThMKr1o6cyMbxn12Jtss1w3Y
	vbyIpiaqUZSOc7FJymzh81ANVqFNjAo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-Ma8UjMDdMZiLSowUsRJCGg-1; Mon, 13 Oct 2025 11:49:55 -0400
X-MC-Unique: Ma8UjMDdMZiLSowUsRJCGg-1
X-Mimecast-MFC-AGG-ID: Ma8UjMDdMZiLSowUsRJCGg_1760370594
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee888281c3so5314065f8f.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:49:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760370594; x=1760975394;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XBtzVCMtBjg29Q+0bM2iI60bYXDGfP4ERe4mSdYo3XE=;
        b=WW7zOBrXydAMs9ajLgwFu6n9uXODHN1ICytRb58+VByL/0cP6Rw2CLSdSuv7PH1LbU
         kg9iWVFKhRrOglBWwOBQ+QX3EmaZ/Y/LLqv6aBOuNyrI6wyg/F8durcZZeE9k0QIpc1/
         swwBWzeC1zpn2hFtRShQNDPtJE94Znxd0bF2Mt2z2YB199c/6ghVdDOiBBh0APGMYYJq
         nV9n2v4oUHzbXt1XpT1qrVvX+gZ8Lbi56rkw5lYv23kHeh9kfySaFCn9aBAlwfIB+gwq
         vehxS589xHu/kqbDNTr6vwbDTBt2CE8W4mKJMXiE3vqtSPz6ynRSfBxg/NFFDnBuEk2v
         ibyw==
X-Forwarded-Encrypted: i=1; AJvYcCU/kMtpGy1b/NrX8eqQwYt4oAXdAMrSGbLqnruN/QtgVQD+CDHHtLkMhDiyufCLtH7FhlzroyklrQ==@kvack.org
X-Gm-Message-State: AOJu0YzLdQV8gkNN6oCoFuDnQUcP1GZo7TcRqJllCZJ9kSfsUpBthBgi
	lwu5PXxeCz0T4g2qi1ZCnzrG1pnA53JXB9t0ghrKJw6sZdGDUkCQpQLDTkmcczz0tuOI79lkw+I
	QDJaM3Zmu0EbJoViZv1DUbJIjg4vW7q3qgxmJDVfvrv96PKwNDX7a
X-Gm-Gg: ASbGncuyKY9xEH2BqX3rkhBESZjV+baoYwSb7nSc+yFTy9NzDbx2q92OZorZlRvLkwU
	0Zl1l+Jrd9TB1zdeAgMi4OKsVztuFeLdRrP5+5rMNi+5OZ/N+GY8ykr1hy/j4HWK5zUdz/+G2zP
	AvCFFP1bjQH3ODxCzXR3B1lRX/J06AMYlbdJkA3cqCfY0F5DdXdYXEew2W9RDM7MlHV1mVCJeu5
	e8Zkveldt4dU8pmliwg0psQGr0JCwi64nyPw1zLCDsm5gmXUmJjoVmU4FJk5X1lOYlDImAvevTi
	E1X07m1Lw5HVTjsMzrSuOEBTPnXbg5uHTZKfXL3IS+gMApukJ0XtTVLG5WD2oZfUIuQmkLDZhaW
	j5yU=
X-Received: by 2002:a05:6000:420a:b0:3ee:114f:f89f with SMTP id ffacd0b85a97d-42666ac6b77mr13298496f8f.15.1760370594018;
        Mon, 13 Oct 2025 08:49:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWdTSOhw0wUv3GtI1YkmplafYwWr/4bjDfkMOFQu3Y9EMYNaTjbzF4fdFGvFWQrXn6/fBGoQ==
X-Received: by 2002:a05:6000:420a:b0:3ee:114f:f89f with SMTP id ffacd0b85a97d-42666ac6b77mr13298455f8f.15.1760370592665;
        Mon, 13 Oct 2025 08:49:52 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb4982c10sm187784515e9.5.2025.10.13.08.49.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 08:49:52 -0700 (PDT)
Message-ID: <3b1dbaa5-d617-4b9c-b49c-94b46ad69672@redhat.com>
Date: Mon, 13 Oct 2025 17:49:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: mprotect: always skip dma pinned folio in
 prot_numa_skip()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-2-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251013121536.2373249-2-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EqAH_qGR09LnDJT1tVrR2dF2SMvVPEqadpGbWFp6C-E_1760370594
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m7nu9pyg3ob86gyu918bh65cr5g3saq3
X-Rspamd-Queue-Id: 30455C0010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760370597-422236
X-HE-Meta: U2FsdGVkX19sMjS1PASyTIgND5nNBoVBWKqRyOt4TNec5zkSy6XlIXSkwgITOsi9ss6W33w4/4C9BS54ppVOH9aAQICDkxOFDuMgPmDW9J4YT0UGEydYkdFcp6ovqp89p3x21YyXlGzkvQBcivQqEfkmxJRxr4Ct0lax+xFJU+ZaXF34wRzxAS4wqedRcCdGpQAbKyMZqWnYH/rVt2p8YPItY++hxVsN6pptL5vN55zGNYzXqMNqRfa4YZ6eFOGcNDZr/w5I4yImCEZGXn1+3k6eoNuYgNIgT1BfGwjzdjz7PnGVIQPRGYkZU5McWfMqArjIvISrDdtw3xdwvTrFxLzHym2+2XX4rk7bUdQufov3393oFpCQ9ixuQt+egZDY4BqGs3sPewrS+dDUmOlh6s3gmuvQtOCPLSWuCMPKPM6nCNC0XU5CgCO9ylK5pKNpJX2Z3zpbjgM+oWxBBiU0fwDm1pVC7qUixcEYtXl59/NhEE2WMh3sKpsrGbfqV8mAQCxW1ciDvx6llB7IkJ6i8VRNQ5kepDbHE2H7Y+1xjnXMLCFgLLiX621uGmBBeZrWcia28VSAdDXU9nBYIN2SYZXR6zZTPqei/bGMWxbzCrcro9EZLRSXqCRys/9HKpRD+wepctIBSN5EQ8omNczsWgcnL+If2AObPPDRQInp8gEIwNPisuIMeZKy86STBNxWuIF+sVyCeyzHhIv8YUjKqDQCH35zbOVrU4Qbvi+UxN0WDgYFM2+MVq8e+R9TO4kJ0ZM2EGl6QtuvF9BhQbwa9hkUDNuaec82yS+xrz4ql2RfgK98EyrBn3KCkQpEshG6ymbtAP9Ftvw1Rb2/r9S7zfhNy+lPTOLgAu6jAnNC6fXMKZMm1K4NtVOKrs1FvBZeyLi4UrxguT5FXMmMKySmyL7wwq//j5GhcszTR9oEP141NQ4w5mEkTsy+boQMFfXDQIBIp8jrfAmbGUNWrAP
 ZIcocR41
 Q3XC8zZAx1YHOaYF/YH+xfHE4PvB8QDzyZAfNMH75vO2URKmpowO0K7upS52BL2viWi0LTlN/nDTNsbNh1jSQlJbtnhZ5sUYiB1cRIQtjkOjDFD7j4oHZ4b0kBXoQX1GGdBdCNqeJrNVR5x3N4dYRlGIly4FMuF9QgNMysWrS14h/MTJdsCs74qBn7c+Ogs3hHUxvALcD+r46Hop9C16XL1F65g1M+pw7sW4yOIO7zkBG2H11inf2PosYglS3rKxVKC0h+QtlslesqUqXwxy+5BcHdQfjg6O6iprvVZ92Xbxg+/LLTpCm3zolPEugV++0CsT+ANxDGq6jiAZlsnFyFHobLFftUppsWiyykNW21fFs36pqIpPJvvkciBGPzOeneLAjSNKJBmH8ixDpcZOfpUZNzFarjrT6h7w6v31cmFsK+JaK+S5rOtJxeuX6PivhzjxkhkvhjbMMjs19FiBKEbgSNyiRCTuUIKMGzjITsFBgola1n1JAwyk/HaBFvJ4wPkphutfh6HgAYsGJ5Fcqr/rQqafdPWcIge2c5eVKe6qtATkH6YQShzFmQbCoGeuV1+qe/feaiTMsepNFn2bQIUOPptjl+JbR6XUF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 14:15, Kefeng Wang wrote:
> If the folio(even not CoW folio) is dma pinned, it can't be
> migrated, so always skip pinned folio to avoid a waste of cycles
> when folios migration.

Right. It's a historical artifact from pre-anon-exclusive days.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


