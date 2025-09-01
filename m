Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E539CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747D68E0065; Mon,  1 Sep 2025 10:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71F3D8E0006; Mon,  1 Sep 2025 10:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E95B8E0065; Mon,  1 Sep 2025 10:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 430A38E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:01:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 080801608A2
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:01:01 +0000 (UTC)
X-FDA: 83840842722.15.5D2018B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6FAD880013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:00:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BM3Z3K6Q;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756735258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lx0LFME7B3AUa2/+kLMyCPk/GuDX6f91CgTqDnBJCDI=;
	b=fuhWawbKMgv/etSV7MX8FZLe9lskl3Q6C+iWLR7TYBQeRvW82bIr2Y9mnMkMUX6tyGeQ9s
	lQO0zPz3NeqrbxztgimCH7Hb+/mJilpwLjbJClcXc0Ff2vv1+6/y0874e8jD9DjtjuUEiF
	pNrJa+S1WjJ5AhPuWCGtf5xi9aqAuws=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BM3Z3K6Q;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756735258; a=rsa-sha256;
	cv=none;
	b=m+HB2SwC2AZt9H3Le3rMOywanCRR84jamcAhu2eyhGDgOy9Xf0PauaNNaBCCcSpxAWAcZK
	gRJSp6b2XIlBUHhOZI2vafWHcysaiQmUtwKPTjWvteqd+eQO+1uzOz4hf7JAXG2EQ8L9Bv
	AgxlDPjVg9CPRZ7x+zgsG+qsBmvC8NI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756735257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lx0LFME7B3AUa2/+kLMyCPk/GuDX6f91CgTqDnBJCDI=;
	b=BM3Z3K6QOwpmfwV92fM5pbdsAwGEZ1zD/hUkJLATCROKzd6tdsanT2MzKQlTRdrHvXals6
	yV5/E1bAj5LGFDj+6qcC2+MWSp6dyITNO86q27JpGPIpdJ5GPdKmw7EmYFI9QfQa/7MUOm
	WEXLY1Q5kWCEPTScZIO3aiPP+ysVTrw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-T9ldc76XO_q-ppyMaCbIjg-1; Mon, 01 Sep 2025 10:00:56 -0400
X-MC-Unique: T9ldc76XO_q-ppyMaCbIjg-1
X-Mimecast-MFC-AGG-ID: T9ldc76XO_q-ppyMaCbIjg_1756735255
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b8b7d66adso6300955e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 07:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756735255; x=1757340055;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lx0LFME7B3AUa2/+kLMyCPk/GuDX6f91CgTqDnBJCDI=;
        b=XUsFZTxSD8NTr4Zy6F0HD6A4/Ckn1xOPWcCemCJTiqDFmkWkh0l2CP7J5DLWnP3K/z
         zSRe0PJ91PMfHR+Rk1bpMxwGHZy0+z9xLuMvax6Vuxbo7vIBV0U1xTTUJKYFERtbcEUX
         PJelniPm9C737JPWkB6xs2RqKKM6aFGfeHNRhlkVEvZKsF3ZYQ/ht/Zc3IOit130Xbgc
         3XeUT5fF+u9ppqLdzDLzb8MvVhnJ1M8/Pel74dmBjztETYm7XpGpTRMHVw7uQhL+Y2qL
         CT0ZPf+REueUmPQF7MeaO1ls/hVYwG03geUrubzk0Cf/5NRd44CZhNia2+7ZaXouAoDY
         72gQ==
X-Forwarded-Encrypted: i=1; AJvYcCVotKUabiBk8y0i8a17cyufMWMQk0lpeh/gfeTNoQUiLKZNE6D7GtK77073+MEpHBkqTuyf3so0og==@kvack.org
X-Gm-Message-State: AOJu0YxQgyZ+bN9DDrKI0LBOPV2OVloPK+F1eNcJkW3eIm/ilBZAbF1/
	Rj1gt3nlc+gYdsAUF/h8yzhrc0qd2VaKhUJ5Ogsu3iw7EHkd3/8KPmtglPPhkKtLkaOvCfxPtgu
	xKxP4+cyewGOa73uWyayhC6rJ7MC3JCnfpMG2/T1mhltBubbarp1d
X-Gm-Gg: ASbGncumUyHd7mIfyuX8yG/dm+A5PoKDwkcgEbLtHZ72hqdHg+Dq1X0vmexVsrLJAMT
	nQxC5l7dp3Bsocyi24rZaYZ8kDLY3AlWwJ696z1P5bbf9rTA72u2oLSVZd4vz7ZLPQixF91LRX0
	cIihkcluASEhfGDZrnuAh2Gy7esflDveZb8SnGuahTXBn3fzbE9ydjvdqDy0UC2sOco+9Pgx+7z
	VvMOHRs5rzXEyRSruROMiEVAClZNWxpjZV+4jSIMkXQfyrRvDJ12Z/0Yho4nB6lWSWXiaUwLmwQ
	3DAnLjybk4eQHpARelrbO09ldjEdZalFm41ZFjcawW/IpyB5o1Q319ZD2CHhAupRttH6FJBAkfq
	KqtZsoGXXzZVWFtkOSLwaorMX6a7bW/qAQvmXz7K10Ge0Qu0qFy6zgl05SL7w2CALZFo=
X-Received: by 2002:a05:600c:19ca:b0:45b:8b76:c734 with SMTP id 5b1f17b1804b1-45b8b76c9aemr51288535e9.17.1756735255027;
        Mon, 01 Sep 2025 07:00:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKtDnpo7zdRn5kM2ivYNaIbBCzDVyMQFOSKKHTd6+Sf3l6DZcgbqTIv+QNYIMEkOQcJ2hrog==
X-Received: by 2002:a05:600c:19ca:b0:45b:8b76:c734 with SMTP id 5b1f17b1804b1-45b8b76c9aemr51287845e9.17.1756735254313;
        Mon, 01 Sep 2025 07:00:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm239195655e9.5.2025.09.01.07.00.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 07:00:53 -0700 (PDT)
Message-ID: <5ff7c9bc-1722-4d8a-ad2e-8d567216a4e4@redhat.com>
Date: Mon, 1 Sep 2025 16:00:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/12] mm: constify various inline test functions for
 improved const-correctness
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-11-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901123028.3383461-11-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SCYZTICIo3W3N8hT49-2YezyjK8yzW8zEifxnhKa4BY_1756735255
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6FAD880013
X-Stat-Signature: gp6dwm6ee4nqux1e8f8zjbis3z7twkzi
X-Rspam-User: 
X-HE-Tag: 1756735258-542025
X-HE-Meta: U2FsdGVkX1+PHCkex+PEKc1MknC+GYYOBdA+QNd7n+ASF177Xy2vptaZsSuxhkhLln1oiwwlCbbfD6YIBDhnrP5eNk/M8+15OjYwfpeijuF6iGt8pedoUVN8kZC1d8NnEhLZ5qqNldpYr9tepA3rr7rpbwKiFEEK8TpgBhdQxWe6grnKjpEa/ZxelRbPVkH5kdPBp9dQo6whlsVt+fzdt11x0ZwcYfzNEkRZjkFgj2qOKjTurhK/uXIop+f+RfCbVwc3+scyxmtCYJmpm+wBBRZpSaYu2M073/4sVSKu41sXstO9NKV24I62cgwHqgRz2wHOUJRN9UrLwbcb9YSt0Ca9a3gZtMSGrR5wQxvZEXU8fCMxATy0y9zWEigYmJDCb3hrsMT4rdTVRwPwkqelZke717OmlKIFRgSt0Epb8Yf8nEp8Zk+dGIbKeIBA5XlbC7/kqu+wdLX9xabiQ6WnijRMPwZZTP3W1/51HYW9oVL2wAS9sF/lIOfUF24PErdgo0bA+tQ9DoTO+liXmUWUfb+CPmQJow6/9qiIO7Ew8/aMvoWRtXS9Pg7WWX4CORH6VcJAWpG4B05rEGb6lbZsZzyO6FAe4HijRZ04wC7KXjlMQ1nOcm7I+D1Y7DEv4EkD0+2u941OTXB2iG5HaZSQJmhkrYeCDDGLmNvZMh4MgpHKMAdX19W7OyeHydNSJW7X5Tw3k1ljP59m+Juiui6NyPyjvpQ3lJF92lPLKegrb7u+wSa9LSC+e1j9dmZYa2cnn25Uj9djUI1nn1dNyuVvcN1cb7m7BKcxJ/+CK0KswD3PYdJ6CRda1iPAWaVYBXoNPCHoPn/wvAdEh7Du/e51ht1NRNPQeCUfzRXZTXKIG/HVzKgn7WD8gnY5PCd0mW5mtd/K+6cP93a9pRnV1Hd6OsexFaDgP2NcIcQNULwH+jfwc3LRWf+09u3SuQXd50m8o5E6oR/9BXkeY7H2/BJ
 eR9pteHe
 IMNGz/n9hqoYwo1tmZI2JVHclR8/cd5g/z4QBnQRvXngwkpZSYGId5PxD4NJFGpPmg4H356lxlu1iilH1c/Vegw5LrMd/RdUHbptzcFSMiv+rbm/ht+P5JZHNvKmEFDBeLVbs0UbGZpdsyWgTVHMy1KtoPtqKQe/W8Nsw821BEvKJEtzgW8igYTEgCJ63AltHcfx8DypGnW1NXemC0KdKQfdICquPLSqUixGwdBaUU2oHAfgPpV0VmF++JHa1IeG3JUZsCaUJnoo/dZQ5Bw1s3igSYsKEAxOItdfd+z4DeeMENhVxxB84wa1KfJdbzzayL1LWfYdPO5dRD2Z6mPyziTG25hvsg6GJP+3pwbwW0uji0FSda3HJFsLcC9phJVebeVP5At7z1F2BuHRryAnOxKLV5QmejR4PZD5CsYzYmA05TReSFqycvkTCxdkqBlwQjX8sPBIyqaEyUjve+gpx2lNhjli9q4KK61K9fv8mmNcwav5JdZmaKH3P4cpo/ESMDrorF4tm2j+FSh6TxPtTWHrBwevR8TyP16NQImqoe7gIpx0GQmn+pwMpgHqRV1iuso7cd/kwrLmbYnhdDBIIFmxlaMkuG/3x5zL/bRBhhqgTPHGF0EQZPRg66+xsrLeWoyy5loGnEjxeOLw9jGZJVTuZ9By1L7csiojv+43it+Lm49o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:30, Max Kellermann wrote:
> We select certain test functions from mm_inline.h which either invoke
> each other, functions that are already const-ified, or no further
> functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> One exception is the function folio_migrate_refs() which does write to
> the "new" folio pointer; there, only the "old" folio pointer is being
> constified; only its "flags" field is read, but nothing written.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

Also some getters hiding (and functions that actually implement logic -- 
folio_migrate_refs())

[...]

>   
> -static inline int folio_lru_gen(struct folio *folio)
> +static inline int folio_lru_gen(const struct folio *folio)

*const ?

-- 
Cheers

David / dhildenb


