Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E50CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7EE18E0003; Thu, 16 Oct 2025 15:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56148E0002; Thu, 16 Oct 2025 15:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D8D8E0003; Thu, 16 Oct 2025 15:33:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACFE48E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:33:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 678091A041F
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:33:53 +0000 (UTC)
X-FDA: 84004977546.01.14BF388
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 11D00C000D
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:33:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z3v/PwPU";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760643231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5k258mGUTXr57SH1nKnjEgecOQG7w002Lx/0nyjvVDw=;
	b=giVhOIq+iKArQnkFLMqT10wqS/ajNbWsj9tSdEDHxK9Y7yUjJq0Q5NZ71XR8GfELxQFrko
	N/6u3BfZCKC4Q+f5Lr+uaqa/A9pvz1yRRG0QQP1v/OThQ8YkMzY5laaj4aoZtlHQ9sIfhP
	1jI7hw+QUl/bopvXrT7LhT6yxu5QKaI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Z3v/PwPU";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760643231; a=rsa-sha256;
	cv=none;
	b=T8ppM5YGBcoxD5Mg8RYmtEMpTNy2LJ7eAJfwCOvYLq338kDjNN9jbNCA2rgzr0BAOz6umo
	d+TNChtT9lvchLyAKBMsWAhJ4sBYe5cFQL+GKx3+9hW/MUTS3yT3ZTXMBDi4MSqDXdDyob
	zIpr9tWbO9PTZ267wntWRdBfA89vmaM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760643230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5k258mGUTXr57SH1nKnjEgecOQG7w002Lx/0nyjvVDw=;
	b=Z3v/PwPU8JFq2MTNh0v31WDIx27jkY54ZmLMDPCareOEqtlZxvB520uXX3fydm3oluxxUV
	Qw+Ptdacn1K3Wmw7WMxPehMIvFAterfIuKrPnhaO+Uxu05pd4wmZNp/L8196Rl9+O9Eg9k
	pn9o6+umbq+wL4HKzkE+OfCOgSrrBjc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-uxa8vyT5PLyBrhML0t6WNQ-1; Thu, 16 Oct 2025 15:33:47 -0400
X-MC-Unique: uxa8vyT5PLyBrhML0t6WNQ-1
X-Mimecast-MFC-AGG-ID: uxa8vyT5PLyBrhML0t6WNQ_1760643226
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ecdf7b5c46so748614f8f.2
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:33:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760643226; x=1761248026;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5k258mGUTXr57SH1nKnjEgecOQG7w002Lx/0nyjvVDw=;
        b=IwESd/0qjmGuUukMshlHJ96QGobJcpB5QMmpyIx0hWoFTNXAa3Bv5mm6DdSIwzBFvp
         OwSt4tIpNx7aSkc55cAdt25IXSNMMw8I/J+/IqyVAnN4FNs/ii/GaBXSG7BjFEat2fcn
         2N9tUyuuZbJF53KhlKovzPpCumiZX6rNT7NuKArXqJrm/N/5FgDmo8Mreurv8MTZi5UY
         XABvFPO/WKEQrF4WP1yhSA4zUt/oVY7uxskCUQj5cTf87JjKSpT4zNKDuC0ntmKnIKnr
         lSFgb4gxdWzurKXV41qVNJGt20U1gLzQQSjKJD55PzQTNEETugDWjrfFHaTUcUVDYms4
         XFBg==
X-Forwarded-Encrypted: i=1; AJvYcCUSoxB+keeIehCi2G4Np5W4GexWLDEhJOxdH1fBqFkowCEncCUiOuVARmGs99bxg1/toEjaXECz3g==@kvack.org
X-Gm-Message-State: AOJu0YwRd8Bzyw9eNaZImC5cKIXq5kRibV/Ia7X2hqNvWNlI5ezJg0gJ
	4PBcaf4j5hQH1XoezlWIadClgmiixMbNyj4ZVE7djRmhphuYS2RQIbL+rNJd1Ft6ok9q0OIv3TB
	ypdOXFHj/XYqvW6pkzXnzcIn180fUHzNweg9AzqYxdIQGq/N5v3wN
X-Gm-Gg: ASbGncsHi7E45alZbnM65B200sW93sTL7N0LvBlyZtiT9voiSUh27wjmazU70PX49D+
	VOHmVHN/SbZOP8etOMJXTAjtBmydHvvEaBZVs47pNbTnmVWLWh7E7NpFC5ZDrknvOvj42af7EN5
	U8kRX1a8nnlAY8DWkPg2nSQNPgVDRuBg3zKSBbSPPKK04B1Hw7PVQ6/YpLyNp7om4t8Xn+y06XD
	pI0KZ7nKKwG9OlYc8I75aEBGYm6F4Ixx+BjtDHjNwm+empEIlZymdD36E6wsd8N9fJRyGstzaDl
	iR715Vq0ndX+73WUkzIsztrZ1zTnaIqQxueUdg6X+bfNbvISxJSHHhOIyP+O9CDIEjoJA4P123F
	IonXZCiv0kNVpc+pKIddebMmYwafSpDgxTVSgOfQ2BMErZo27VRH1MUSZrZ3uEgMa4yWgbT7a4j
	3fe9UcrPno+2ObIlT1fYt3Ph5+xXg=
X-Received: by 2002:a05:6000:25c6:b0:3ee:1294:4784 with SMTP id ffacd0b85a97d-42704db5d28mr907031f8f.37.1760643225865;
        Thu, 16 Oct 2025 12:33:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfcc8Stm51iYuGklKchoOX+xG5epa3pMdO3lfWEiLBnXCqovN2Px+K7w/7mGkDHX2bMpQSYw==
X-Received: by 2002:a05:6000:25c6:b0:3ee:1294:4784 with SMTP id ffacd0b85a97d-42704db5d28mr907016f8f.37.1760643225439;
        Thu, 16 Oct 2025 12:33:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57cc0esm36868337f8f.6.2025.10.16.12.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 12:33:44 -0700 (PDT)
Message-ID: <54a30819-25e2-4835-80c7-5631237b8e9a@redhat.com>
Date: Thu, 16 Oct 2025 21:33:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/7] x86/mm: Use 'ptdesc' when freeing PMD pages
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
 <20251014130437.1090448-4-baolu.lu@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014130437.1090448-4-baolu.lu@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nX29wlFhw1hU2fW7nkLJ1p7zvXTPlnl4cGvZ8gqYOp0_1760643226
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 11D00C000D
X-Rspamd-Server: rspam03
X-Stat-Signature: g4rqhi9xzro33aqpbtoj4xfugx3bhp5z
X-HE-Tag: 1760643230-44105
X-HE-Meta: U2FsdGVkX1+0Leb825pnuiqB2UXkyrobILqiWPzlsC4m/49us07iPN3ZXVQLkGZd5yxC6KAKSxXTVO7CuLfdlpPyRzBCiQNF/yrL4m/OgH2Ua4OShXrhZXU4DduCyOpxncTVvpgFs1kDbOjQ0KErfTJ/RDJiyxTNhqeqQG3SxGrLqAV4MPll3QOQneTfyI3udDGWYPXW0O5A4zaN2mUNsN/t5U2ZRtt98ZICkG97P9mLw0VMrkThW6b3RlXaQbrSOModfTLUrXiC8naqh+CCuIqDZ8ACUdQ2bKnindGZeXzHTvut+AgpdHZtb38KjLoSkIOhOy12e2RYlkVCGLu4g8B2mrMmw6yCyDjLqNW9I7CfDIPt8EWGxjBjOU0esRsHGO5E3NdNWgmV0GUAIcL4vD68VsAr/s2UvTmLXhKGpdnDnqmFse9Rrvql6gW18WSyA0JVe4QgGGxFbWR12u8HTzhzR6T3km+1nV0rO9huJSTWm8vJSeBrCY+9ZCcsUJLJ3Km+R3EAogHojZFSWS0Ja69GkvKI47dy3tl2IK94AvXRDwdmeSoAlOxEsRqlMvMKhBzoSnOrmnpVI/j0DL7kYG2vvQIF6OdIz4F2e62WzTVHkN9cWebU4le57ntf+vetNhvYQ5suD1LQhaExAXOGbv5m4mpGelTXU11i0qVW7/QmRuii4DscC60oz1FbGXZ68RFUiL76Ax3DrGo/VMq/0Dd8a8ulChQNw9TZVnWHO9uJ31tR+mZ4sQ0BPK4EJqA5K5+Owk5l1xakfrmUSqAPPB4vbt7+Ni2jtZqhmEZr0Ymwekw/8k3SOUjN/ihrzI7F7KlCmbLvMewvqnSp04sJnNQPf4o3QDbLJwZy1L4I/L+i2aDVLXZkknDsuwldgAkoudm/BR7Csgfn/VdnOYAtxxmSI4LBdgPSA8oZsYE5Eafdp4XZ83ulYty7VLX/sSNeXZsKUQIT1w8/w7dtfIU
 9SXdfi/k
 7pEl8WMkdBHotMjkoVhBereD9XMymYC61HJIJFs2JHdZWlrE=
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
> There are a billion ways to refer to a physical memory address.
> One of the x86 PMD freeing code location chooses to use a 'pte_t *' to
> point to a PMD page and then call a PTE-specific freeing function for
> it.  That's a bit wonky.
> 
> Just use a 'struct ptdesc *' instead. Its entire purpose is to refer
> to page table pages. It also means being able to remove an explicit
> cast.
> 
> Right now, pte_free_kernel() is a one-liner that calls
> pagetable_dtor_free(). Effectively, all this patch does is
> remove one superfluous __pa(__va(paddr)) conversion and then
> call pagetable_dtor_free() directly instead of through a helper.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   include/linux/mm.h    |  6 ++++--
>   arch/x86/mm/pgtable.c | 12 ++++++------
>   2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 15ce0c415d36..94e2ec6c5685 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3203,8 +3203,7 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
>   	((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd))? \
>   		NULL: pte_offset_kernel(pmd, address))
>   
> -#if defined(CONFIG_SPLIT_PMD_PTLOCKS)
> -
> +#if defined(CONFIG_SPLIT_PMD_PTLOCKS) || defined(CONFIG_X86_64)

Yeah, that is weird. I'd have thought we can simply move this out of
the ifdef? The CONFIG_X86_64 stuff certainly has to go one way or the other.

As PTE tables always fit in a single page, pgtable_page(pte) is sufficient.

PMD tables can exceed a single page on some archs, so we have to find 
the first page first that we can then cast.

Can't immediately see why that causes compile issues.

>   static inline struct page *pmd_pgtable_page(pmd_t *pmd)
>   {
>   	unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
> @@ -3215,6 +3214,9 @@ static inline struct ptdesc *pmd_ptdesc(pmd_t *pmd)
>   {
>   	return page_ptdesc(pmd_pgtable_page(pmd));
>   }
> +#endif


-- 
Cheers

David / dhildenb


