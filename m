Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 815F2CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1DF38E0005; Thu, 16 Oct 2025 15:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCEC28E0002; Thu, 16 Oct 2025 15:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD598E0005; Thu, 16 Oct 2025 15:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B9D848E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:35:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E9F4C0381
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:35:20 +0000 (UTC)
X-FDA: 84004981200.24.1433965
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id D22D340009
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:35:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RrAsCB4L;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760643318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mzf2KOoxYTwPszQZbnCr3w1S1PHGYisO4oTStjZPcT8=;
	b=tYRXGU4MMyP8wn956vMgf3hGE43g7/6Nf6FykryZizcB0DcaHoYUI693MVfAbTlhuXGjLG
	de+37eIhc8csCKpZDAChEnHS4c9GdlG8NqffPdWGYRRSHf2aO/4noFFysSMpicmq3bFgyY
	T03FmamlJtFX4NfTtbtI80HKp+Q35dQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RrAsCB4L;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760643318; a=rsa-sha256;
	cv=none;
	b=dOGdRAr4cONrhfhPFPMsaCneoNK1UlmX51eJcGrwPKf5MhPIBjSnMXlic41/J2aFm+Q+tf
	jjyFlemOLd4OgpeQghPSxzR+9AuCjOk6OkY3AR2xW4qIe8pcW7fT914yHw+XdhTeQZj3kp
	nSdWiEkPDyfxgUt5HulhHZbVYcP0/oM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760643317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Mzf2KOoxYTwPszQZbnCr3w1S1PHGYisO4oTStjZPcT8=;
	b=RrAsCB4LVrPxrkaEHyp8r/Pfsh7Q7n2NmKcwgbKJOomrair7zux3cEJhVp90KjUK5oo/3w
	C8u6QhiQnWXNJY/Adz5sS915IlnJ2+jxHNyN+qR4eGXdRZfF+yaoOP8eUvsylKrSXn9TrA
	NRwK75k2D+T6XKYaUqyKPExcVNWXopY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-rMKN3qw9PwWChW7McxLOaA-1; Thu, 16 Oct 2025 15:35:16 -0400
X-MC-Unique: rMKN3qw9PwWChW7McxLOaA-1
X-Mimecast-MFC-AGG-ID: rMKN3qw9PwWChW7McxLOaA_1760643315
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47111dc7c5dso7421115e9.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760643315; x=1761248115;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mzf2KOoxYTwPszQZbnCr3w1S1PHGYisO4oTStjZPcT8=;
        b=PniSGxsAE8t4+HGk5xhYYpU7pygL+IAuD+uHR2oINoZ+kopVSi454b1cRYbLaVBOB9
         i9AMm4h5HlejzeOgXC6Oo+3GbSDJv3Lgb+CyehKnuhIiCZmAC7SgXN02dc7Z5s7x/WsX
         xC3TBtOVbcOH5xIcjeXrQO5ssZDopyDter2llFvJlukFfFlXNQcTdgZXOWw094pm1Qo5
         H50b48JMCHJuPZEFBU3BbtmoJtC1+3sw534c5ewvXaKLi9+81ptqjcMo/DwvaDidyFAF
         qNYkS5n/jI2pSrB3Rj0b8yykEDBxfGaq4U7snkejyV7BAz0dhIlctMx87RGzn1OJgJMd
         DPZw==
X-Forwarded-Encrypted: i=1; AJvYcCWHvuiYX9DDnI0s5glzVXayAL7bXOIUl0f3xxRGUxQ3PiBShD8VyFxr7bt4XOrAE7qrlAQnliqy1Q==@kvack.org
X-Gm-Message-State: AOJu0Yzi0PVUeUJcR5KPrZOFRQ0AS9kd2gBjP10GVccBZdIWiNH6EoKe
	9SDG7Hdqq6Z6wp+izqegA5pxxohVrMTjoUHCBzYykSFpNIn+Pg66TzBY17RVJ2D+NF8ZbkOfqA5
	4rRWWGC9uhdt55mZBe12vmrH+GT11OB7Hi9oQ2oXOGa+1lk4FJUgt
X-Gm-Gg: ASbGncul2wDkxNPWyRKfrYG5fA5C8AzsljmIHiSEtRIMOzE+4vfaT5d+zqPkUjun32y
	WUpDbiQ8yrrXJKQEfVjKnc1O7RNgXFFpX+mv+IbfJZW5G83Wa2Ua+kLtSrLscH2i+dua2qWNWjX
	/T0z1RVIcfzA516PcleajvJ2ZI7YjP4v0o9V/q3au0AEVIGGRilQbpacK+HNrBdP37ARYdiSztE
	fpAaY6owX+fTULnXL4y6CWCtspm77cBD3ClH9eZb48kCbWLB9jJaJukAOXvZFISKHPBTqiyvIEo
	NsGcPp7eYhS67zuHz4dPzOntzzMo/eaNUsCYVBKI3WYZE6YUtgZruGoarGmUNrFqFCuUWSx6r9L
	9QcD82OhyMKIssIknAy5t12jVgWKXC5SqT1+7yQIAjG23YGENnG0wLmRX0n3D9cM9fRc7WxHQuS
	p7PfCvInewlbGX5jUjjTv42Pyq06g=
X-Received: by 2002:a05:600c:548c:b0:45d:5c71:769d with SMTP id 5b1f17b1804b1-4711726289cmr12476805e9.8.1760643314695;
        Thu, 16 Oct 2025 12:35:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHM6TLgln996pR3E0IOQ8FhCXzoWThxFAhFVfWLmNgeZg4GR6X6l66UDma89Hxbe82/HUeJxw==
X-Received: by 2002:a05:600c:548c:b0:45d:5c71:769d with SMTP id 5b1f17b1804b1-4711726289cmr12476595e9.8.1760643314233;
        Thu, 16 Oct 2025 12:35:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710f2ab58bsm26257825e9.10.2025.10.16.12.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 12:35:13 -0700 (PDT)
Message-ID: <e62bad6a-bd49-48d9-aa2d-9e2022f829b3@redhat.com>
Date: Thu, 16 Oct 2025 21:35:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 6/7] mm: Introduce deferred freeing for kernel page
 tables
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
 <20251014130437.1090448-7-baolu.lu@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014130437.1090448-7-baolu.lu@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: c2gSOdXLnyosjBrj_x7gWEXEbNkc69w0XZyoys-laFw_1760643315
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D22D340009
X-Stat-Signature: gacrxmd3umbay8rtr6b9kpo81jzgqmei
X-Rspam-User: 
X-HE-Tag: 1760643317-39681
X-HE-Meta: U2FsdGVkX18RtCL+LJ/A+wsk9vFpnUEvdy9qUB0kwI6lNcYYnuDowo4IKCIQRlNApWvlPxiwAF7hNXXXyhSwzDFnEYnFDN4ezyTVuRKJGFfJMwBoNatMfG+cG9VH5c49EMJXQ5u0X80reYUQEc66PzYATZZWUjaaR/+N9Pr6rPS682x0BE8nMonBRnxi+O6XfHHV0rffw+FbcjHHKEPhgzIqglFOo48vsrbDmCjEM7NtzQQTC2h4d5TClUZZnBqfWyv6KGPtAteMd/YZ7B9H3IkRB1y0zbyLwVjl+DfeEKUnzg8rxVU5JwEaDkAbXoPpfscbtzOIGtmt83nJPT/1/0KFQJHEZx+fJAjSuYq200r5l1PGuVn4kKduMaDdHwcoPS7h7yxZQxBNzTdttjc1CXL9RszVYGaFHedz+B9rK05HgrZQwiyIfxxE3MXBi8sQ4Fc/OEuBa7+L2Xcp3/4bQfdYox1EqTIuR0nc8u1zARQ1EvkV2oBGsOl+J/vg43Ngf8i4dzrFQVpEUOi6y4CIfYgoXYIO0kUWrdRm9w6d6jRJGsF9/ce2BVNqlyksUDSoTFc69uvcUYozhQ3sApnVWpsKArQVWb5ewKxPcQ9kfVunKkMPpClB5NoIKKDP7uVHVi+L+s2Mug5Y5A/+7BYXulmQw2MPaLM5EgGbCc5+MffQFNrq4VHAm2tdooC55wq2SVBcEaUDEutqS6WH241EJmgsM1gzbH7D8UWLOscz5EztZedzKLBKQn98ByRxWkgFG44qiXYU9ZOlA0sgxhtzCHS2MkY2/oZ9UHatlOYIPE7+mMXAmQEjH01HCS20UgRKLmUgNdOuxsRn9d4AsPxAWN3dqzf9ecd6JXCw62No8BjmP3ZqRzZK7Nj4+xUO+RS/BgdNPDqTYmPUe4oyoej4Ck8gG4gTpNf05P5z6GBzmP4AZAlCRgAuIKcUbYFnMAnGTguQNMHQamorO5pQsAC
 T3jqlf3R
 kNFRx++/Xba3Y0LtUzyG2IHXIyADnQz5d3KOnASAn+RYtMPmVK+aGX4A7wbuWDx51NMooKqKqvHybCRMp1uW7vNk+961y6EEgtu/Kmr7hIc45x0kJ5ijTlIBkGHfR56vZfOwMPuwx4Hpf5eIZKfdubkc7NFm/A2jaIsdmHYXBz9TNTIFiVdiKUBSucyKlS3r6KaC1s6BA3UXmD2XvZ/SHYGuBZGAks7DR/Ya9hDVZhMdv9XMmUmABgMFzqErCR5dJTmY3AUx6clbP/WqiLwGSUE+eJ9ja0KMdOeDz1ElvjddIcEaM0P95ZWTWiXVjmnzhZHx1LXfzDCCFUfSDxvCfb6bj9QAgi0iXvRkyHX1CsvuCLdpewzuFo+bSyW047p89fWYcRBBRuI5nIKcVEyTI3eEKwjgzaHdED5U44uOp6NXaxoxCdL2bOhhzPDXclHruVk4jtyDcKt2rbwll7/BnrsP1Nb4kixy6MF0P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 15:04, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This introduces a conditional asynchronous mechanism, enabled by
> CONFIG_ASYNC_KERNEL_PGTABLE_FREE. When enabled, this mechanism defers the
> freeing of pages that are used as page tables for kernel address mappings.
> These pages are now queued to a work struct instead of being freed
> immediately.
> 
> This deferred freeing allows for batch-freeing of page tables, providing
> a safe context for performing a single expensive operation (TLB flush)
> for a batch of kernel page tables instead of performing that expensive
> operation for each page table.
> 
> On x86, CONFIG_ASYNC_KERNEL_PGTABLE_FREE is selected if CONFIG_IOMMU_SVA
> is enabled, because both Intel and AMD IOMMU architectures could
> potentially cache kernel page table entries in their paging structure
> cache, regardless of the permission.

See below, I assume this is patch #7 material.

> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   arch/x86/Kconfig     |  1 +
>   mm/Kconfig           |  3 +++
>   include/linux/mm.h   | 16 +++++++++++++---
>   mm/pgtable-generic.c | 37 +++++++++++++++++++++++++++++++++++++
>   4 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index fa3b616af03a..ded29ee848fd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -279,6 +279,7 @@ config X86
>   	select HAVE_PCI
>   	select HAVE_PERF_REGS
>   	select HAVE_PERF_USER_STACK_DUMP
> +	select ASYNC_KERNEL_PGTABLE_FREE 	if IOMMU_SVA

That should belong into patch #7, no?

-- 
Cheers

David / dhildenb


