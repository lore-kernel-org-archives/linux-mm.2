Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF3FACD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 18:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2DDE6B0088; Wed,  6 May 2026 14:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04BF6B008A; Wed,  6 May 2026 14:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A8D6B008C; Wed,  6 May 2026 14:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D09B96B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:34:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BAFD1C0A84
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:34:53 +0000 (UTC)
X-FDA: 84737846466.16.128C04A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2F1A21C0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:34:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FMVoTlaT;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778092491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7QTr1jCxOp/gsoLdmeTkxZFcNRoA5to1Y5n8ppLv4s=;
	b=B4LTGZys0HRTdy5mqQ7sCLQunNZFjeVufrHb01sH92dt8LYUKW91mTEu1yyfRW3lgcTFI1
	HDFb5Sk1xxBQX5flMQu5HBSakUl6MxVrGQDwXZFLiZXYK7H/Xm4bIBYV8AxuNZYVBdYy2I
	kvb2eV6NuvrfoGAyl/x1rdGrpODrV+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778092491; a=rsa-sha256;
	cv=none;
	b=kZr7HFtW2VVAt0ZC1pAn/lA5VgVUktjCgxORMcA/1/wBBbGPzTOIXQAtyPMTIEcRBIsCdB
	pj5Qz75NlrGabeha/XZNBSw41seEcqcFRCw/F9LCCixpDoMiISR5T91jPAbRJeS6LJzMgI
	6EVcB3cmj0sIOEt2bKOPMAlZvTV9XCI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FMVoTlaT;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778092490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q7QTr1jCxOp/gsoLdmeTkxZFcNRoA5to1Y5n8ppLv4s=;
	b=FMVoTlaTyPnprxFbgpBHowREJLOlEn4MOOffn1Rj4Wr8xRgch5qabKQy+rMpPoF9RkDwK8
	FfIxELGHKC2++JjIQJDnfHOQUXP1wHEvz9sX5gLw98JLjWwZ6zwxeJ7fo/9CwUEQTp4lIA
	qh3Igx74gRSCYfFSj6hF9fvrug4edTU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-zvmBUMuXPHKw9OsOZuID2g-1; Wed, 06 May 2026 14:34:49 -0400
X-MC-Unique: zvmBUMuXPHKw9OsOZuID2g-1
X-Mimecast-MFC-AGG-ID: zvmBUMuXPHKw9OsOZuID2g_1778092489
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8b7a1ea06bfso88023026d6.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 11:34:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778092489; x=1778697289;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7QTr1jCxOp/gsoLdmeTkxZFcNRoA5to1Y5n8ppLv4s=;
        b=gWhluo0eKgpw5hoLqgnq4ei6LwpQ9l9dILTk9iK1XAZaXgcfVK/pRoyvZPsI9Xt05P
         mBEBGcQ+GomHQpc1P9HEEGi03McR7phNBGRGvC16dYE11vZ2iFyfaA9DUqfDvss4IZ+C
         Fm58adsyDcXslP7OjDheNlMQf1KpXLKJskq2Rcj6CTlrTR/jRwvzzy4SQVvq+iRMiLp9
         VbiRx4rfs7Z/g+IohucWuOPxXe9IP5+pfhUVMlahdC8fs/YItnhdG80kcwd3rr/uy+bS
         xUpRUiLEaIZD6tPC98jt1izvLDRUi512jhWbJeEuX9mGkww+4y8I7vGjfS+1vyX3F0vg
         iIWg==
X-Forwarded-Encrypted: i=1; AFNElJ9P5yjmliy0PQbegTRLbNvC//5GASCkDhKtdtJ9lR/w8ceHuQj2w5QQK/Hrh6nqmfOfk37qJLDF4g==@kvack.org
X-Gm-Message-State: AOJu0Yz8SfLj17mrqfOZtpnE/gdXdkXU75LuJRAVXAQxDsEK//kg6h1Q
	keOUvYempbpWIRHRI4OOV9+B25oCH/mI19fzqyvWcirUphjHOk6TLxFIDciRpgZwz+ltd1JYeRR
	bfKoOStNeV26yjHyqD3WPSn0K5Y+8VQ+c2IGRq+Bpo1owuFgTi+p1
X-Gm-Gg: AeBDievbNimWRj7tHTYYayyH+oUjBgp5t2kTeSxM+AVzNjNFuZL76Xnnjo1oxL8Z1CV
	qOlSpoYk07il7S9lw7jyEuKmRd9huddVHEy0uhSzCZ2zR8FyGwQfjanabppD97nR5OTjFHZHi1p
	ef9Am+Ei0r4NoSZ77QqZ/iSkiy7cFYMBtTjiFScUhCwYSeHYv6Rga6AsVxXAtVLoJsbka/LT29E
	Bd3difCiRWh9jxc7GN+CjtYNV6klz92KAwy7NyhOLtsOFeVpaFuCsx30NelafP0NCRBCETgCJWW
	lZ5Yo54bbM0s+hMwG/ykCfphW05ujtI9P6Z7ZqniqmvOJeTBKoq29O3zz/+tJvfCKAqASzEFJnX
	bGITAOG1UrZaxb5gCptHxtwpUrdHfi6clGfjubu0Zn4yTbYGYh1OqcpVmOY23JvfOXq0xED5DAH
	zrJm3lnK6RgtJwJeTejqNFo6s=
X-Received: by 2002:a05:6214:f2f:b0:8bd:75d1:afa3 with SMTP id 6a1803df08f44-8bd75d1afc5mr12613656d6.7.1778092488597;
        Wed, 06 May 2026 11:34:48 -0700 (PDT)
X-Received: by 2002:a05:6214:f2f:b0:8bd:75d1:afa3 with SMTP id 6a1803df08f44-8bd75d1afc5mr12612666d6.7.1778092487925;
        Wed, 06 May 2026 11:34:47 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b53c1dc606sm184831366d6.31.2026.05.06.11.34.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 11:34:47 -0700 (PDT)
Message-ID: <a3acf91d-3207-4a32-a115-e0f037024095@redhat.com>
Date: Wed, 6 May 2026 14:34:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: (sashiko review) Re: [PATCH v4 9/9] mm: thp: always enable mTHP
 support
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <f67da00a825da9097b5faf2f390ad344450b88be.1777663129.git.luizcap@redhat.com>
In-Reply-To: <f67da00a825da9097b5faf2f390ad344450b88be.1777663129.git.luizcap@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _JoDRHkL_4GB5WRVDuxgQF0hKtElLr6UZhzIeC3_ECw_1778092489
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2F1A21C0005
X-Stat-Signature: i5jikcmzucw8aaoc1kuz4o9sbuaba4cs
X-Rspam-User: 
X-HE-Tag: 1778092491-352380
X-HE-Meta: U2FsdGVkX18IuflcK4sl2OBVCDemLZTZVKLBnR/mQK0uwbI8maYprLKlM2vy6ydTcBY5tP7LX1+UZA7IlUIjMSzYfl5per8DGdjNy6KK8PSzfe3jk7AtY8HaRLO5fKGUMAP1OuJGIDTNDR86IRuT9VjBlUUhHZNSr7z6k39L33EdHr771J3mOiZ9SHqaHP5OnnW4obqiuT9/rBpT5w7SgH6tksR3vUos7QX2T08MMyC6dDLWEDBNsJ/AbVZHwWAuyO547qc6hVO1S4lOnF1Femx/C1lgy7I74+R5gwN8x4nfb8w20vyriql9EvHivA/V0w6XuWnvl+BBx8sTpJYrbJt/6y1GfE4zZIwAJt8YEoojLy8WpV8yM+sBtIMo0eLd42WCqeBJ6hgbiX9eten6qakQpjQk5r3f+71KJ68gn0PgJbSGKaeovO4l4mRkQYJqBbtrI8+YvKF2b0nj7u5pPIyL0N8gEck1EocAXQr1XeSYYcj7x/4i5/3IEZL2fCrywIZiyGLdgv8TNQp0C5rTTbsywqu30MRg34lsphKwOii/I1n5SgW4a2LAIGn75QiNb5K/BrGmspNx9G9Hh9Ti32pPjFPMv7RE7QqE3sREGAstqzpKdlIds4jZxqOdLCWzMR8YJ9cTfL63/E/9X7vfQC3s+7Panmv81U6iwgiwfcDhWzPV4jVOUWIam8VOc4H0f+VXGtl9hpV07PabW4TXlnmxUK+WSRUHRoLkO4kqSUF1K4FqpnhYOVwLT9fnLno4xIXSHF9O+dagT2saV8jZEeAzu6p0N4jjwAWGRtbJkhBQLZwnFxG9K1JieB7nzSL4+iJ3L4OEUAtLgyXggRcKKrpRp9CzK+Nnr3UNguS6L4e/+m1HhPzaZwCfdR4aH8sX+xdSWRhMh3sfakxvZHuj7oldywkwIHfxJKIwApaS/bz4AcpeljsJkEDB0WIcAGkBA+SJO7RH4X/rk6tk0fM
 n1KCycDs
 yBoWFDKty+/HFEUrirS6ysNHMTZfnSzCrU5s2Q578+AypRsLUd7fPkTp3A+OUYRu/ZUsFrZTYi1agmu+g5FHrdWHHY95cR+8YLFadct+BhuMOhYY0IIb78YwMzusodbpYleV4ri0WshL9MOc+nz4aUH/0o9yY9h+tvLqXmyQ+TVQypel/I99TjK5q47h2d1yltT0V3m3TeK2c19S+OkEY86iRuOEcndN+nI672E5RNPP+ETl6uDJPdnBOXALsyvavUhRTHQRZD9SP4AOnHHIn6NXKwZwrpL5ZjP+Xb1Sg4ZEAXGvuELxy/EoPFRMmcOaezH/ITmvAa0a9D3klceZr/fv0kvbwJft0KIXxYHB3MbJc9Vrx8g7aH7XYoyqIzpKu3FXA06jzsMoSMmGSGGcEPJDmvUnzozdatW6z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-01 15:18, Luiz Capitulino wrote:
> If PMD-sized pages are not supported on an architecture (ie. the
> arch implements arch_has_pmd_leaves() and it returns false) then the
> current code disables all THP, including mTHP.
> 
> This commit fixes this by allowing mTHP to be always enabled for all
> archs. When PMD-sized pages are not supported, its sysfs entry won't be
> created and their mapping will be disallowed at page-fault time.
> 
> Similarly, this commit implements the following changes for shmem in
> shmem_allowable_huge_orders():
> 
>   - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>     considered
>   - Filter out PMD and PUD orders from allowable orders when
>     PMD-sized pages are not supported by the CPU
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   mm/huge_memory.c | 23 ++++++++++++++++++-----
>   mm/shmem.c       | 14 +++++++++-----
>   2 files changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 32254febe097..c1765c8e3dc6 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -126,6 +126,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	else
>   		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>   
> +	if (!pgtable_has_pmd_leaves()) {
> +		/*
> +		 * The CPU doesn't support PMD-sized pages, assume it
> +		 * doesn't support PUD-sized pages either.
> +		 */
> +		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +	}
> +
>   	orders &= supported_orders;
>   	if (!orders)
>   		return 0;
> @@ -133,7 +141,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	if (!vma->vm_mm)		/* vdso */
>   		return 0;
>   
> -	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
> +	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>   		return 0;
>   
>   	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
> @@ -848,7 +856,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>   	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>   	 * constant so we have to do this here.
>   	 */
> -	if (!anon_orders_configured)
> +	if (!anon_orders_configured && pgtable_has_pmd_leaves())
>   		huge_anon_orders_inherit = BIT(PMD_ORDER);
>   
>   	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
> @@ -870,6 +878,14 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>   	}
>   
>   	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
> +	if (!pgtable_has_pmd_leaves()) {
> +		/*
> +		 * The CPU doesn't support PMD-sized pages, assume it
> +		 * doesn't support PUD-sized pages either.
> +		 */
> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +	}
> +
>   	order = highest_order(orders);
>   	while (orders) {
>   		thpsize = thpsize_create(order, *hugepage_kobj);
> @@ -969,9 +985,6 @@ static int __init hugepage_init(void)
>   	int err;
>   	struct kobject *hugepage_kobj;
>   
> -	if (!pgtable_has_pmd_leaves())
> -		return -EINVAL;
> -
>   	/*
>   	 * hugepages can't be allocated by the buddy allocator
>   	 */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index a48f034830cd..23893c2bc2dd 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1840,16 +1840,19 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>   	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
>   	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
> -	unsigned int global_orders;
> +	unsigned int global_orders, filter_orders = 0;
>   
> -	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
> +	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>   		return 0;
>   
> +	if (!pgtable_has_pmd_leaves())
> +		filter_orders = BIT(PMD_ORDER) | BIT(PUD_ORDER);
> +
>   	global_orders = shmem_huge_global_enabled(inode, index, write_end,
>   						  shmem_huge_force, vma, vm_flags);
>   	/* Tmpfs huge pages allocation */
>   	if (!vma || !vma_is_anon_shmem(vma))
> -		return global_orders;
> +		return global_orders & ~filter_orders;

"""
Could this lead to unintended truncation of the order masks?

Because filter_orders is declared as an unsigned int, assigning the result
of BIT() causes an implicit downcast from unsigned long.
"""

If I'm checking this right, the maximum bit number we can get to is 22
on arm64. So, we're safe. That being said we should be consistent with
the return type for both filter_order and global_orders. I'll change it.

NOTE: I'm skipping the other comment from Sashiko which is about the
same issue.

>   
>   	/*
>   	 * Following the 'deny' semantics of the top level, force the huge
> @@ -1863,7 +1866,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	 * means non-PMD sized THP can not override 'huge' mount option now.
>   	 */
>   	if (shmem_huge == SHMEM_HUGE_FORCE)
> -		return READ_ONCE(huge_shmem_orders_inherit);
> +		return READ_ONCE(huge_shmem_orders_inherit) & ~filter_orders;
>   
>   	/* Allow mTHP that will be fully within i_size. */
>   	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
> @@ -1874,6 +1877,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	if (global_orders > 0)
>   		mask |= READ_ONCE(huge_shmem_orders_inherit);
>   
> +	mask &= ~filter_orders;
>   	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
>   }
>   
> @@ -5457,7 +5461,7 @@ void __init shmem_init(void)
>   	 * Default to setting PMD-sized THP to inherit the global setting and
>   	 * disable all other multi-size THPs.
>   	 */
> -	if (!shmem_orders_configured)
> +	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
>   		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
>   #endif
>   	return;


