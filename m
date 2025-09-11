Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB794CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 12:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43178E0007; Thu, 11 Sep 2025 08:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A148E0002; Thu, 11 Sep 2025 08:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09438E0007; Thu, 11 Sep 2025 08:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E34A8E0002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:42:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AB6FC0490
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:42:13 +0000 (UTC)
X-FDA: 83876932146.11.BB32596
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 039A0A0016
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:42:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ftlnpjv/";
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757594531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgjmqO8SZYiSSNbuqjw/+LEAvLvMVdQ4JyG2LZ/F9u4=;
	b=OlokcHvha/pkWI1eQpcum1ft/JiMi9ofO87jZPRRuloGDXNSXKTsW4A1EpyZPD5Ke9KBIK
	1ukyu/3bxVUwVtVBIzFabCZW6cEJPwssBY23gJbDScZ2q4+aOv7XNCAq5wwQ5kx7SdhdCS
	t4EUf44DIglQ9IHIv3WwokwRSKs6qYo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ftlnpjv/";
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757594531; a=rsa-sha256;
	cv=none;
	b=HFlfNGzX0ddNEca2+ETsKCmdGQXly1+3Qc021f6VZFYlDwGiXHyRm39mfFnrGAs9NHO4I6
	mp+EVsqU7dZ71knP79UK27srz1zP2ceCu/OxKB4NGXKqm/4WuQgfwaRbn9p72tyl2uLuWO
	xeWnG60R7HsEQ5/YBVH2Nc6R0Cg7VfQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757594530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QgjmqO8SZYiSSNbuqjw/+LEAvLvMVdQ4JyG2LZ/F9u4=;
	b=Ftlnpjv/K63ah5fsylBjzagIhduQUdpEUfcKFf3VDAy41lN+8LZHkalD7t9qNIZEK+QPtb
	Wwj0E9DSNXRgwP3kkWtQK8EisA1hdQq3EtSF04YQEKeraopQFaWBH31GJo+yFEo8Te6FJF
	+3ob5InvEcsx10pqQ9YHSIz/ucCw95U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-MEa3FS3BMgGF-iNz0yg6Cw-1; Thu, 11 Sep 2025 08:42:09 -0400
X-MC-Unique: MEa3FS3BMgGF-iNz0yg6Cw-1
X-Mimecast-MFC-AGG-ID: MEa3FS3BMgGF-iNz0yg6Cw_1757594528
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45de5fdda1aso3866615e9.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:42:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757594528; x=1758199328;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QgjmqO8SZYiSSNbuqjw/+LEAvLvMVdQ4JyG2LZ/F9u4=;
        b=reKpFAw15mjekRnOFDPgS7AYsNGtV5W4s4XP/1naHilx0aNsfISyAu3TrulsbKjQ+3
         jX4r6InzRr1XhqFt8ZYwR64cr1RTEWi08iNXacICfYmbkUdd7YTOB0N/1pwukPY7wO2B
         sDyZGDkR4M9/sZjyEw++q98lF4bnzNmES0GOgB7XEWa9JdoMla0fVa4WirBClibhFu1X
         00WGhTpEwIgoEHxwV2zTjg2NM8lF9PXv+z3nw5tZWwIEQN8ahNZ0WBpDaGFZvdWW3lgY
         YYfb/8pL3fQ74UArbVYqNliHJHMU+B0eLasY4e9NiEcEe1eEHVahFofUA53BgNdFA4dE
         spog==
X-Forwarded-Encrypted: i=1; AJvYcCVWo+w5TFz2vxfAcTIXohV4DKvjxLv7Pw3A35xqmZncQLaQiWmN62PsR0bKcvAUspY2goKvOcRL3g==@kvack.org
X-Gm-Message-State: AOJu0YxugSDEMb3wZmj5oJfTCjvXVfrvY9DmKd8NqVuNYsSyh89ZHz1W
	UgsQWLqvphzv84af7Bmln6oVTScPpcfFmtHXFjp25FWOn/zhId/XInJyYZQSJhHPCnYCyBrXMHj
	WsWjUzhn6ufKF7Do8Kf90UEnZ3lN72QbZm9byuHqsGu+yEQeVBnrN
X-Gm-Gg: ASbGncslH2i8IWgRXrq1baEEYdpUjEhnrdbGM+yDuKJj5P05G4cnlbOj6sLyeVsV5c2
	CcFdYzeWtqeBBJ/qb9XjeaDbavb7baQqv3D1iK01zw72LBJgY5X+K0uny7kY7o31cpNHAOET2ua
	lI44yJymXs8qlb66u0SUJZlr6y1v1fRvbabE/zASIfXKPdM5F5rIjJP1liImH69sEj8xEhUvgsa
	X1kyXC73QnZOQURVl/d8HBDyFeThVcRjIbtJyhUZ75jJrET5AExVHfh/6I8I93DA5j318NK39IC
	m+sl87NWpIXCKWzDxQpHv0lmY5UrHTt2KS3CFrIWKJ2uzFKtAcmns5FetnLuaoZA7T7L59qw4Pj
	cq8+fpygI+85v5OAojroGLwRQpvNHN8qozkRDSbmMfxdZpc9BYv9iMuBzwbuq4eSY/j0=
X-Received: by 2002:a05:600c:5247:b0:45d:cf5f:cff8 with SMTP id 5b1f17b1804b1-45de2028e47mr171825385e9.11.1757594527646;
        Thu, 11 Sep 2025 05:42:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFO3UgHu/gwI/hsgKG8HwCLbnyXISyfhUyVybHY35t3VDw/LBeDedVd1v1Q4+SvaiJ5o8WPjg==
X-Received: by 2002:a05:600c:5247:b0:45d:cf5f:cff8 with SMTP id 5b1f17b1804b1-45de2028e47mr171824945e9.11.1757594527093;
        Thu, 11 Sep 2025 05:42:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e01575fadsm25690325e9.6.2025.09.11.05.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 05:42:06 -0700 (PDT)
Message-ID: <d4ae7f61-f2f9-45dc-91db-4de7f3127744@redhat.com>
Date: Thu, 11 Sep 2025 14:42:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 07/15] mm/memory/fault: add THP fault handling for zone
 device private pages
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
 <20250908000448.180088-8-balbirs@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908000448.180088-8-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: r1fsklx_5CYNQEPFpcBS40RPVDDjNJcU_B9ETWszzAQ_1757594528
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 039A0A0016
X-Rspamd-Server: rspam05
X-Stat-Signature: tm4wxyuips18hboake9edwfq3ispf1sn
X-Rspam-User: 
X-HE-Tag: 1757594530-213744
X-HE-Meta: U2FsdGVkX1919fNoHFWeCzqaP5lNYsEWpoGL8HzSgEMPGUZBkkeksJGtL73nTGcdzM4YL6F1gzxLs1dFFdYRO3xjf7aVaAjjO/Bf8mftq71R6jxNynRQKrx6kfSA38trP40mclk4lQXs+frJrlaYtlzW0cX+51BdBtLDZeei81QtwtShIRnuqjwvJJXTgPkk5cQk5ssgNqmlJt7+NhuJQE6XLo0qnFijzGzX5gWl96uGrPA6oBFfFweY9d2A5hqyZwNp25+pfvetZ618/QdeVHBL2SsqGsZlF5UMDcu1V+FtDcZ2nDLpzEZSGqMpqg43hQ3nihcxBhvZXgW4AdaoSqunD+kZBQ2ZfHE+f4ZrjN4DI3yfZOA92O8UFVguOzzNVKsBkvAeivypuj0a/xR0WEnyxpQnedV4HCqhybd5CeLE5/Yvh6qP/SS+eKxb8y0axnw8nTsYcIWGH+CzGHP5wsB6pNowx6oE76q+MiaH0ZGmIBO6bRJkfv9RvXnWmm/fm4gEEQoB3v+KHjez7serH4ZDG1TF7mUgCHe/g9uiu4hggz5VuFiyxyxmZzDAPvztzyUOPHqIJ23A8CxorN707NXHoWq4tH0AieEFmLUfUFPg3r5uhsREuJg/D8Oxw+5Dkd+frVbi5AhHF2v0bonzRtgr0/XM8FvAAxIuQzx/jnyujOmgl3QhqFvUMeAyxOU8B1i6yLFo3cQsgRBpbJ1WoRs4j0Pf5Z1tM6qIKvV/5n/GbIW4qrOiUGZkW3U5luH11HRLycobMR+hB7AUxoAliJSWv6pB0+1uVnk8m+FLvypvmOBGrw2PJzTVGPb7voxZFSIbnBqY3lza07YhNyUIZ1O6PwNgqVDLyU/SW4fU78qeDLgi+/PV+ksD3f0CRBvDvvbhY6ZVB67zBXXKla1lUQtShXpVaRY+8+6Ipp0WxErxDYl9EmbJb8YUPg/zblL2Fp99Y/pQPx59Pm0GvsC
 kpY7dgCV
 cXWyNFKQIURawv+SEYr0GKFYw+IUsWRe7n5nQ5B825N9OQD2cdjLWadnEaV0FV6P+k1lWf+GmlGePBTtQqpYsHL+mqkpTzlP3z2lbpIC7DHZ4+wizjrQM4mMlfDMR4DfrS7ldoxUgm9nlWpcWNh+jMJ2hjRxN3qEhlSbvySRyQ2J+OlT/cx3RTmRJFh29T9bMFuJFscuyVf04Dts/7MTBBYhmBnWAYdM0H5wlagTQuU6Qm94OkjbdQhukbeTxgaOBAit/Jvc+OHiKHFCpU5x+XyyEp7Kyvh7uuFb94rfbY8J3DRpk92H2XU5cEyYk2KDOMcbwUNFeZ/G0SKJ3D+5qPGdrXGyHjKzMuGYoVegz8Lf0icol9tuGGSvH+zs6l3IuUOovKlYRVBw34xcGhxvecErR6pesL8USQoXFeLWQrA/iHCk4Xr/OanXRfc/BwNl97+tnGj6gOmyWKiexn2485dncmFbP7CjAz8qPAc4CWnYOa/M8fIpUd3GMW2+JSiUoKgkqWhwDd6CPIkjV1JlSAgAkimR+++g8w/O37xprzfiii8KVfQjYnWZEwiAwRzxKPqCl7s2RhJDhvHL7LSluY5xSSvrgnU2pqU7R/+cSN05nzq6/dvNpx3MhaKJ6Eq0loIz5MYyyqkaP6ZqpWuvIx+/i5tNOW8woZtCBoh6ZPAKW2+u2lgmTVxXY4RDiTt17Z9ncJaKlBzLwjBNUydD4SrBTWas579UTaSMhWf+4JkFwF/iIAGmiQundWyurDeh5gzBTVafMdsgv4VPCW0xEtpDQnYS2PWe5FmeuPuVIqZWMKWQsDPzVtuOLy0MarcZq4dmJulezADOGeoBFM3K7GD03Wb1it6tjQW1RvyLf8sJmxymWsix/gV65QEeLydGA7QVqwpWuD42Oc1I184viAa+r/7Mf2HaXyTQr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 02:04, Balbir Singh wrote:
> Implement CPU fault handling for zone device THP entries through
> do_huge_pmd_device_private(), enabling transparent migration of
> device-private large pages back to system memory on CPU access.
> 
> When the CPU accesses a zone device THP entry, the fault handler
> calls the device driver's migrate_to_ram() callback to migrate
> the entire large page back to system memory.
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
>   include/linux/huge_mm.h |  7 +++++++
>   mm/huge_memory.c        | 36 ++++++++++++++++++++++++++++++++++++
>   mm/memory.c             |  6 ++++--
>   3 files changed, 47 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 23f124493c47..2c6a0c3c862c 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -496,6 +496,8 @@ static inline bool folio_test_pmd_mappable(struct folio *folio)
>   
>   vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
>   
> +vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
> +
>   extern struct folio *huge_zero_folio;
>   extern unsigned long huge_zero_pfn;
>   
> @@ -675,6 +677,11 @@ static inline vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
>   	return 0;
>   }
>   
> +static inline vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
> +{

Is this a VM_WARN_ON_ONCE() or similar? (Maybe BUILD_BUG is possible?)

> +	return 0;
> +}
> +
>   static inline bool is_huge_zero_folio(const struct folio *folio)
>   {
>   	return false;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b720870c04b2..d634b2157a56 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1287,6 +1287,42 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>   
>   }
>   
> +vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	vm_fault_t ret = 0;
> +	spinlock_t *ptl;
> +	swp_entry_t swp_entry;
> +	struct page *page;
> +
> +	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
> +		vma_end_read(vma);
> +		return VM_FAULT_RETRY;
> +	}
> +
> +	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
> +	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd))) {
> +		spin_unlock(ptl);
> +		return 0;
> +	}
> +
> +	swp_entry = pmd_to_swp_entry(vmf->orig_pmd);
> +	page = pfn_swap_entry_to_page(swp_entry);
> +	vmf->page = page;
> +	vmf->pte = NULL;
> +	if (trylock_page(vmf->page)) {
> +		get_page(page);
> +		spin_unlock(ptl);
> +		ret = page_pgmap(page)->ops->migrate_to_ram(vmf);
> +		unlock_page(vmf->page);
> +		put_page(page);
> +	} else {
> +		spin_unlock(ptl);
> +	}
> +
> +	return ret;
> +}
> +
>   /*
>    * always: directly stall for all thp allocations
>    * defer: wake kswapd and fail if not immediately available
> diff --git a/mm/memory.c b/mm/memory.c
> index d9de6c056179..860665f4b692 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6298,8 +6298,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>   		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
>   
>   		if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
> -			VM_BUG_ON(thp_migration_supported() &&
> -					  !is_pmd_migration_entry(vmf.orig_pmd));
> +			if (is_device_private_entry(
> +					pmd_to_swp_entry(vmf.orig_pmd)))

Single line please.

But didn't we have a pmd helper for that?

> +				return do_huge_pmd_device_private(&vmf);
> +
>   			if (is_pmd_migration_entry(vmf.orig_pmd))
>   				pmd_migration_entry_wait(mm, vmf.pmd);
>   			return 0;


-- 
Cheers

David / dhildenb


