Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 964A1CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 12:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB0A46B0010; Thu, 11 Sep 2025 08:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88616B0023; Thu, 11 Sep 2025 08:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77CE8E0002; Thu, 11 Sep 2025 08:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B47B76B0010
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:32:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8406D11A2B5
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:32:04 +0000 (UTC)
X-FDA: 83876906568.29.3B46C1C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2CD2840011
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:32:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NFOBYwhF;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757593922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZ/dKjdNPUwkhNSr1770dlxLEN21cVc1KkcKofFrXz0=;
	b=GC39nFwOwFKvscRrZ0GyRpuAo0IWM5khutFdkd7cjP7hKW3QI/h9pQRVPhfXlUyAz6BToA
	rBoYNEX7KJZlJqlvn9pVxVWe5BkO/UzuIlco0T7x7GEE/SZ21qXtVoi9KuvfwhrG4A9wPg
	hXYFDOcoKz2GtZhVeVXGrWPsF9aauCA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NFOBYwhF;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757593922; a=rsa-sha256;
	cv=none;
	b=az3Uh1zz6FjcF6Ly/klfPaC37QYsbN5Ufv1VrQAI8SEYyPUeuYi/YUXAWq5uTr2/gNicOC
	3xHG5qa6+kANvzxX2wfwO7MjvPGD++Stxu20sdlDF320MLo9/+C+Lp/hz5b7gtIjfTybS3
	kKAzqKfnQM0ytig6BRDLUYoeTbcHREo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757593921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iZ/dKjdNPUwkhNSr1770dlxLEN21cVc1KkcKofFrXz0=;
	b=NFOBYwhFpNogN+ZFqqJjwXoQgeexe/SZBdBQbCsG0m+NzYREJjcePPLRI9U7bQwjha/jmU
	d5SJ3kYINdhC2ws4Y6o9AE2Zj/K3L7VCF9NX895A2No8GwrV0Bo6YVXxb4Y/2mRuZr5hvm
	PWDDOj1idnIgIJlOLAxLGXKqq4yCtrU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-2etPPD_bP2m00xRBuBFh5A-1; Thu, 11 Sep 2025 08:32:00 -0400
X-MC-Unique: 2etPPD_bP2m00xRBuBFh5A-1
X-Mimecast-MFC-AGG-ID: 2etPPD_bP2m00xRBuBFh5A_1757593919
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b467f5173so4576285e9.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:32:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757593919; x=1758198719;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iZ/dKjdNPUwkhNSr1770dlxLEN21cVc1KkcKofFrXz0=;
        b=pe5gsRInBJxfGapp10XiEaysPLEt/bZVh+HtQttM9HhaxFu+Y8Df8N05/oU/RvNj8G
         9yu7NlY+N3O88Bgb+7ltZUlbfdsjink/toP378ggyfJ6yunGSXoStEuOWN79jibHBmYF
         oxL2Zyt/l9lOaAW7wlmTVzmtf1TRl6G1G4ZzbWbPhXgCJMl//OuP5rFurYyZnMdru8lR
         d9fw03YvyliwqK942cpDry1J41IV/GDCftWlD9ujojkqMQx17J2HpR1bPnJdVue5uW75
         DItZ54oq/inckvRWFHi0u/Ave3DXvjZGtJ1xCVDeKXA19d88Cue+1RlOxlYPTpypM1RQ
         3q5A==
X-Forwarded-Encrypted: i=1; AJvYcCXeonKxgtbck7aBdhNzNJeP/u/ztNrFqxYDuw6ii2LnAz4I0n8W8tVuCbL6iZSMgVJnPkiGMBJgjg==@kvack.org
X-Gm-Message-State: AOJu0YxEwnjU+Hdi7mqiEZx/mIDHiZ1fhxlXDSU+GvHfOIQQLLt5KKOr
	ekIhvWQsEa6m3WpikdDuEZtDQccqdSAKxSQoc0LMz/OKnRjuwNfsTviuB0Fx5kJEW9tvEiIPoqU
	DhBu5p98lTe+32QVhD/CKscpUZSmGdkfqwXNG7gnXpJg7Sd/9IPzT
X-Gm-Gg: ASbGncuJI5eESBRUjiV/Eis/drEr6GyYAVjqjQkKi3jcWyhgYa5bwIQBTerPL/5TArx
	kF+5unSf6Rymr4XO0V3sLE3s2AvqnU5yNE3049xSCpYAkXxh5WUm8IiJj2eAAB304zWj5OJlsX2
	6nV909h/fAdgKWULGCEk4IOzQWphSZTh9rXPCIqhz+NimFTjXVgbY+ZUaQl49wXXCau3aq5TLSf
	eGnbdVyTqIVULqsaU5P8t6VzRB4OhrTxbqx3A7d3W7JvOIOzCjdFTgVNfdlbiNIbLNg7ugpE1Hp
	eLYUfRInApe8OYQaKM39SWXTI8pVHP7AXaRjc5DEvaaLlye19vGbQIrvj94kIKgqTnZGfeI9DqE
	OafQJW4x3oDCwG4KSAXTOPeOTXnxQDYv/J7us5jv3U0vmWu9GQh99gyoqxh0OYs5PKlg=
X-Received: by 2002:a05:600c:4ed0:b0:45d:e28c:8741 with SMTP id 5b1f17b1804b1-45de712289emr112180895e9.29.1757593919019;
        Thu, 11 Sep 2025 05:31:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHd4mRSBLCLqoev+zql1DYyEm0c6qzJysTW8hMJhXGcJ/8jyY32AGr1Sgj5WO1lPdl0WHC3+w==
X-Received: by 2002:a05:600c:4ed0:b0:45d:e28c:8741 with SMTP id 5b1f17b1804b1-45de712289emr112178675e9.29.1757593915557;
        Thu, 11 Sep 2025 05:31:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e015bf73csm12934595e9.11.2025.09.11.05.31.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 05:31:54 -0700 (PDT)
Message-ID: <ca592d4a-3e91-48ea-970e-a5ff12f215be@redhat.com>
Date: Thu, 11 Sep 2025 14:31:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 04/15] mm/huge_memory: implement device-private THP splitting
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-5-balbirs@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908000448.180088-5-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LP9CBmyy6zI2b9WTUDvnGmHIILWCT8VIEzr9v8JvFks_1757593919
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2CD2840011
X-Stat-Signature: 1nkq6gjq7411hmeudapz9w9q6o7dbho1
X-HE-Tag: 1757593922-43160
X-HE-Meta: U2FsdGVkX19arZeJRvkNrUfoibKuN3GFptvC/Z1kIAuLZlfC+ehvwaMHV6WqKcc6/SWZeknn5gkjoywjkN4WqlbYHCiI+koIxV1wGz/dLxppB1chjvJA0HRa26EtD5SbRJ1Y5nnD/wAnGg3WkQuPRD/Q3KbBth6cynxScc4GU3LXyUjalpEz+gvCNQdV8ac/I1GNjEhe3QYrwv5w34sem7OkVWof3BJREo54GP+bGsDXgY5G5ycGSKQJeYO74xYe1SliB971LCTnbh3GcP1qhziOkx3wbz4nDNml1ztVwz4fiCSVlN8kVrr6Q68O0XAlKsdUzXI5kosa+NHWlblJ+C1RZ9ok2fgO2qy+zMw0FFXgy19evIBv9q61NYjk3HvCZLHCKULbh9PVg5jyIdsYyEZG+hAFrHT7Ra2usG2oF10tHIKylmtngvtnrZ6QzDpH4tVUn/dM+o4ixG0e2Cu7NgoD5PLbKHO07koxxcw5BLNIZsr0pV+8cypXkcg513aaUWn9UbyEzZulpuEeYXO6/qjq8qJq56B6Pd3b1NtU8rLJpMSMf5mMYJECieoJkfGnEPpOesE37n0YDcnawjzxpt68Mg9/LFoQb9TBrCBuSYw/UXJns+OR8Pr98e+QDuaoI/b4x4tFV5iY1LEQyQffMDbuDksN8PMph66c80ea/K4J4JK+2DB3+kZW0FHhWXKgk0yTud+mH7DIfDIdB8jZF8AYFabmu4eED683gNyX+T5Bk0wMP/Cz1QbJwZhtyY2Mo9ku3h9gAgVbXMQm6SfLNeUeNzc96AGuUP1PIiX9ROCTa25hsgbjFQfS0d1zPz7d93TD0ToR/ZkPH6MLvUOL6SggYstQJ9rTU0rYNJSKg67wB3jiVYh+4f/xxMNg20jUupq78afXAJwXS3v00l0vbz0ZpRxvhGHhxoH1SGbudbxvwF3llR7sTNzIwPPHgJDlUeUyiCYDvvRTKQOneLZ
 FWbQy8wn
 s3Qok+2y4FwYFQLzmW1X8AxnQAASBEq33NTUO2KmDvdHUOuESCUWyQd2G8b9WZdpSez0uwFlCTxT6XyfWub0O6pGMCQqxE4z30T4YsCGV7sgTdC6Ibj2lPv2+ICHN2R2XGwv3Xpl7ajAgVYjEw2P6MnCUpPQ0nDEiokaB0ljl3EA3Ad92SGxXs9/IDYNZA1JTn1qIt3bBKj1s2wWJV/s3wsTKkltKvEvML6ZiEnVQWisWsQ3D4rILg7q+ObDp3LLpD8fd5FEPGKvnEb3c65iCcjIH0O+JW3LLkAj6ert/RAZ2q7EOyMbHE6W/Kr1Lx75HC+TXZrWOCf3y+K+yEYH4ydwTEb894IDNy050M35LG//h4ZZSQqxiovANGGREXQCKrhtLkwZO3L9A84Z1iYwUufN9Jb0LFg0AVoNzkSEHxNs2QF4rPA5XLIB5sqr7Z7qLexVWoy4spQpMNm1P8h0asPvRtodTEc8CY6icyXT+7u6btff0mMpZtKla3u/TbxvJaFD56VHWDO7Pv8zk6NkdraFMFdy4O19ENvHkCvqjx2t1uPpF0aNH5E5YKKBzdX4U3G1BsybwG3OqIqlJKkohPbS9d5fbnwQHDdISA/W/K7uXRFm0Upa4R0V39pcifapHYDhb9Vq1VVLMZqh5mehz7w2FwfreWsqpCn301RkOSdU7ZNPq0r5CsZ7RXZzrm7r/WHad8P/fStu4D7Rc4R4cOGq2MqLkxz6rGvjXohtjIwKifNf19N9R3Cbh9k1Jw7mtWZNNYUFmjfcFBpP5WCtziQl5FKS/2nlJNsQTgsnpoU10KThkDps4JSMd1l9KN05iIrGJHhtw2h4WJrfnZfipSlKSYmoYYX9qcBbgUyKUUbAzPrWjot5uKL4KRQnqahqUxPJAXs8NK6XyfP/J+lpWorERahdXDoir8F4sxTjRuzxiT8Rch1tMrPXVRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 02:04, Balbir Singh wrote:
> Add support for splitting device-private THP folios, enabling fallback
> to smaller page sizes when large page allocation or migration fails.
> 
> Key changes:
> - split_huge_pmd(): Handle device-private PMD entries during splitting
> - Preserve RMAP_EXCLUSIVE semantics for anonymous exclusive folios
> - Skip RMP_USE_SHARED_ZEROPAGE for device-private entries as they
>    don't support shared zero page semantics
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>   mm/huge_memory.c | 129 +++++++++++++++++++++++++++++++++--------------
>   1 file changed, 91 insertions(+), 38 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 337d8e3dd837..b720870c04b2 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2880,16 +2880,19 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   	struct page *page;
>   	pgtable_t pgtable;
>   	pmd_t old_pmd, _pmd;
> -	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
> -	bool anon_exclusive = false, dirty = false;
> +	bool young, write, soft_dirty, uffd_wp = false;
> +	bool anon_exclusive = false, dirty = false, present = false;
>   	unsigned long addr;
>   	pte_t *pte;
>   	int i;
> +	swp_entry_t swp_entry;
>   
>   	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
>   	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
>   	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
> -	VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd));
> +
> +	VM_WARN_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd) &&
> +			!is_pmd_device_private_entry(*pmd));
>   

Indentation. But I do wonder if we want a helper to do a more
efficient

is_pmd_migration_entry() || is_pmd_device_private_entry()

If only I could come up with a good name ... any ideas?

is_non_present_folio_entry()

maybe?

Well, there is device-exclusive .... but that would not be reachable on 
these paths yet, ever.


>   	count_vm_event(THP_SPLIT_PMD);
>   
> @@ -2937,18 +2940,43 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   		return __split_huge_zero_page_pmd(vma, haddr, pmd);
>   	}
>   
> -	pmd_migration = is_pmd_migration_entry(*pmd);
> -	if (unlikely(pmd_migration)) {
> -		swp_entry_t entry;
>   
> +	present = pmd_present(*pmd);
> +	if (unlikely(!present)) {

I hate this whole function. But maybe in this case it's better
to just have here

if (is_pmd_migration_entry(old_pmd)) {

} else if (is_pmd_device_private_entry(old_pmd)) {

There is not much shared code and the helps reduce the indentation level.

> +		swp_entry = pmd_to_swp_entry(*pmd);
>   		old_pmd = *pmd;
> -		entry = pmd_to_swp_entry(old_pmd);
> -		page = pfn_swap_entry_to_page(entry);
> -		write = is_writable_migration_entry(entry);
> -		if (PageAnon(page))
> -			anon_exclusive = is_readable_exclusive_migration_entry(entry);
> -		young = is_migration_entry_young(entry);
> -		dirty = is_migration_entry_dirty(entry);
> +
> +		folio = pfn_swap_entry_folio(swp_entry);
> +		VM_WARN_ON(!is_migration_entry(swp_entry) &&
> +				!is_device_private_entry(swp_entry));

Indentation.

> +		page = pfn_swap_entry_to_page(swp_entry);
> +
> +		if (is_pmd_migration_entry(old_pmd)) {
> +			write = is_writable_migration_entry(swp_entry);
> +			if (PageAnon(page))
> +				anon_exclusive =
> +					is_readable_exclusive_migration_entry(
> +								swp_entry);

Single line please, this is unreadable.

> +			young = is_migration_entry_young(swp_entry);
> +			dirty = is_migration_entry_dirty(swp_entry);
> +		} else if (is_pmd_device_private_entry(old_pmd)) {
> +			write = is_writable_device_private_entry(swp_entry);
> +			anon_exclusive = PageAnonExclusive(page);
> +			if (freeze && anon_exclusive &&
> +			    folio_try_share_anon_rmap_pmd(folio, page))
> +				freeze = false;
> +			if (!freeze) {
> +				rmap_t rmap_flags = RMAP_NONE;
> +
> +				folio_ref_add(folio, HPAGE_PMD_NR - 1);
> +				if (anon_exclusive)
> +					rmap_flags |= RMAP_EXCLUSIVE;
> +
> +				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
> +						 vma, haddr, rmap_flags);
> +			}
> +		}
> +
>   		soft_dirty = pmd_swp_soft_dirty(old_pmd);
>   		uffd_wp = pmd_swp_uffd_wp(old_pmd);
>   	} else {
> @@ -3034,30 +3062,49 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   	 * Note that NUMA hinting access restrictions are not transferred to
>   	 * avoid any possibility of altering permissions across VMAs.
>   	 */
> -	if (freeze || pmd_migration) {
> +	if (freeze || !present) {

Here too, I wonder if we should just handle device-private completely 
separately for now.

>   		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
>   			pte_t entry;
> -			swp_entry_t swp_entry;
> -
> -			if (write)
> -				swp_entry = make_writable_migration_entry(
> -							page_to_pfn(page + i));
> -			else if (anon_exclusive)
> -				swp_entry = make_readable_exclusive_migration_entry(
> -							page_to_pfn(page + i));
> -			else
> -				swp_entry = make_readable_migration_entry(
> -							page_to_pfn(page + i));
> -			if (young)
> -				swp_entry = make_migration_entry_young(swp_entry);
> -			if (dirty)
> -				swp_entry = make_migration_entry_dirty(swp_entry);
> -			entry = swp_entry_to_pte(swp_entry);
> -			if (soft_dirty)
> -				entry = pte_swp_mksoft_dirty(entry);
> -			if (uffd_wp)
> -				entry = pte_swp_mkuffd_wp(entry);
> -
> +			if (freeze || is_migration_entry(swp_entry)) {
> +				if (write)
> +					swp_entry = make_writable_migration_entry(
> +								page_to_pfn(page + i));
> +				else if (anon_exclusive)
> +					swp_entry = make_readable_exclusive_migration_entry(
> +								page_to_pfn(page + i));
> +				else
> +					swp_entry = make_readable_migration_entry(
> +								page_to_pfn(page + i));
> +				if (young)
> +					swp_entry = make_migration_entry_young(swp_entry);
> +				if (dirty)
> +					swp_entry = make_migration_entry_dirty(swp_entry);
> +				entry = swp_entry_to_pte(swp_entry);
> +				if (soft_dirty)
> +					entry = pte_swp_mksoft_dirty(entry);
> +				if (uffd_wp)
> +					entry = pte_swp_mkuffd_wp(entry);
> +			} else {
> +				/*
> +				 * anon_exclusive was already propagated to the relevant
> +				 * pages corresponding to the pte entries when freeze
> +				 * is false.
> +				 */
> +				if (write)
> +					swp_entry = make_writable_device_private_entry(
> +								page_to_pfn(page + i));
> +				else
> +					swp_entry = make_readable_device_private_entry(
> +								page_to_pfn(page + i));
> +				/*
> +				 * Young and dirty bits are not progated via swp_entry
> +				 */
> +				entry = swp_entry_to_pte(swp_entry);
> +				if (soft_dirty)
> +					entry = pte_swp_mksoft_dirty(entry);
> +				if (uffd_wp)
> +					entry = pte_swp_mkuffd_wp(entry);
> +			}
>   			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>   			set_pte_at(mm, addr, pte + i, entry);
>   		}
> @@ -3084,7 +3131,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   	}
>   	pte_unmap(pte);
>   
> -	if (!pmd_migration)
> +	if (!is_pmd_migration_entry(*pmd))
>   		folio_remove_rmap_pmd(folio, page, vma);
>   	if (freeze)
>   		put_page(page);
> @@ -3096,8 +3143,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>   			   pmd_t *pmd, bool freeze)
>   {
> +

Unrelated change.



-- 
Cheers

David / dhildenb


