Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C23CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 10:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9013A8E0005; Thu, 25 Sep 2025 06:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1508E0001; Thu, 25 Sep 2025 06:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778F58E0005; Thu, 25 Sep 2025 06:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 626BC8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:12:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15FA716040A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:12:11 +0000 (UTC)
X-FDA: 83927357262.11.84C173F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id C10DE1C0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:12:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eLAADUfA;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758795128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lG8Q/FN8wXVOGFD2S5MD44NnHhqfaQZRP/OiKpWlrJQ=;
	b=2/Hlv6L7Oa6mPAHNpCGj1phsGSYGEDiuTHsrGjB3EDmPZCa9N1qT9ejyishZHk8BBGVpTc
	Lu8SG09ijQwfa4Id8c9qAlfHGDc8aKwi1Nf2nXTcXJPpp7n24QJnLT6i6QlUOO/kt50vq/
	Qa/5nAxbAiRzCQM1W7hzG6vLGG481sQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eLAADUfA;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758795128; a=rsa-sha256;
	cv=none;
	b=Zucxf+9NgvuYl+wSTIhb380CWqEHA+RUrOyx6c3pf4wdBVsauXb77uZmDSQf9TyJWcOHhQ
	7kxOO9e/X7Q+pUtkr3ZLs8SoE1kzp/psvkmSpPA9Lx3hIgof0wKGhfuBwYuBhmMyL73/7r
	B8RvWod6m0lEway2z1y9bwO8GS8ysRs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758795128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lG8Q/FN8wXVOGFD2S5MD44NnHhqfaQZRP/OiKpWlrJQ=;
	b=eLAADUfAJq5+ihHEkscDUD8DDVbL/mjjMjmYcS3Ti/6DJjIctbiMfPOp0vtd7kOZc3yEyM
	WzNEqAjroM/XbjcYCqKAubJej+0iVY7wnZ0KyRicD4NJKkiEtiJWJUeG7ww0Bb2wH62TwB
	0P0ECkQiGL9e9ipdXhNbDe83MvLcxzE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-TyRU8rOPNTmdOtnFG0MjcA-1; Thu, 25 Sep 2025 06:12:01 -0400
X-MC-Unique: TyRU8rOPNTmdOtnFG0MjcA-1
X-Mimecast-MFC-AGG-ID: TyRU8rOPNTmdOtnFG0MjcA_1758795120
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45e037fd142so5870275e9.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:12:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758795120; x=1759399920;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lG8Q/FN8wXVOGFD2S5MD44NnHhqfaQZRP/OiKpWlrJQ=;
        b=I/Z0kU7mZx7c/QGH4V1MOEWLszCwLCdq5iAWSlXsido+KHnXdXdy089dAfPEtoDdC1
         HsAWTlDIPH97bz93MHp2xaXP081k08IdfODp8mgtNwB8iXMKdjLQE+Ys7XpkkCUmD3u1
         9HO7EkfYkg4puj3UqJfig87T35Cm82/rMNXUcVbFqaBzAUcs9eV8W+OH9tl7Y6oq4xuB
         4Db83BHaTmOzpSfzza1AGzbNC84TGFLscegrww67vyR0qKKo7NnDJ1sj27rMUKBaJ6F/
         VZrDdnLh0szS7Ip7a5qWtFAkFiZOXV3zm2qGoqxWByIGETyOxXNSDwHOzFtAfQ4usbiQ
         jjzw==
X-Forwarded-Encrypted: i=1; AJvYcCXPx3/tp9J1iYEwLZ/jF0t6aJpV8EgJPukwooxyLuW0rlU/YKe6tv62rwEZrmyFwcajnMKnB8+qAQ==@kvack.org
X-Gm-Message-State: AOJu0YxpiplHkjY48PSOCoxLII0RfZHY4Lfgbu2ypqng1qSwDK0lJkZ4
	dkdJkpibDZM099ivglRLMKKOK7a0Xd3bcQs4ThJM2iZdadJN5Jw93JpFE8iU4RWnXb6kUX1ElY+
	yGGR5El0tA5NVd/lINPfCxw9qaLYCPJnYCNYNbR6ZXIv10CXl/nIw
X-Gm-Gg: ASbGncvVioiCvUh9LYQ9IZz5NjQBDl9zQa858td6xFYwRFebwsq0dM9wDiafJPCa87G
	VGPF5r1odpAg4dhROalyQYo7MH7swkKx5DqS4tOASCvvdtnAxVy7xVrZO76R2UByNqQvvEAvHJc
	ubzbj453poXR2XGiyqvl6z16ACFqm9teeVVni6whFnDlTf8JJOkw4ERTmJ333AAc3aNcoNZc73H
	imkanuH9VPtNMD6QttXrmfDYZWHPYxOtK+oZr9eYj9YXnik1mAjlAwtpBk0biwZgTPAwPPyuNyk
	gwPnLmbtiFZNy84y+/y+iYYKd4/2IoyV7fPLv7W2azS8F6zUZs0D8qrcoLWCTpHOZGm1z19pdi4
	U/cIz6jgRccLHUEOxdvwRbl457i/RWtlAM3hetWL1LBIO3zhAu8Aq9ZzQ/8oFQYPbfdqH
X-Received: by 2002:a05:600c:1ca5:b0:46e:2637:d182 with SMTP id 5b1f17b1804b1-46e32a08feamr34778065e9.28.1758795119593;
        Thu, 25 Sep 2025 03:11:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlNMDizXc3Rq/dhiO8rd/15mVcqt0iIObArVPXmOTFpH25amynq0pBhSR/qoFGTRlMvFSsQw==
X-Received: by 2002:a05:600c:1ca5:b0:46e:2637:d182 with SMTP id 5b1f17b1804b1-46e32a08feamr34777545e9.28.1758795119112;
        Thu, 25 Sep 2025 03:11:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e33b9eabbsm29826805e9.3.2025.09.25.03.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 03:11:58 -0700 (PDT)
Message-ID: <7fe72c55-fbf9-472e-8d10-5b6396994435@redhat.com>
Date: Thu, 25 Sep 2025 12:11:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v6 07/15] mm/memory/fault: add THP fault handling for zone
 device private pages
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Alistair Popple <apopple@nvidia.com>
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Oscar Salvador <osalvador@suse.de>,
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
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-8-balbirs@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250916122128.2098535-8-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5hIk93jDEh219x-Tq3HW9wQwBJpf-Y5NsZLgXhN-Wms_1758795120
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C10DE1C0006
X-Stat-Signature: 1aje59yb7ho74dq1jichei59a4eqmnz4
X-HE-Tag: 1758795128-594705
X-HE-Meta: U2FsdGVkX19sVX9Guuv5RN0dI0v4ZvyiBBVk2d6Hib+/lg4e82uXhHyh3JZovZLtmjc5/C6hcxNsr62ko8Y9oX3fyk9/mcJFJmcba+R1mUFtqlcWtyAmZ6UcAA8Xdncj7ZW/XwLl+Xyt7MqCfAwciTOoTNNzlPewiSa4aK89WkB3Ly4GGS3xymcLoTwucZmKFLDWFAiPlYd79hbtxSd4a1y2qQCPj/4hEcqBP/g5Iq+WHfiCoqHPhSlrWfk6AYhr6P99FaWym+FFHE0MYOw9xjGfsy7hVjyjDmxp9ppHMl0A1LzHsTpWRxtldEKr2glK+JnJF8b9d4lMkNLMhVlELSYqhhaaFz4DvvmPcnNjEh4diqXR0v/+Lsp8rRLQIUYgC2GLK4BxikrVgSEUR7ie5nTNrQla2sgwZZXIyaC5YMCRByDyLLnRn1TioPuxnoKDvCKyQYksIHRl7/HuIXf+rSbgBS4N1EYfHObjxHKPRrjjimekiG9uaElAKEahxmFVD71H+AciwYsE+SxPzX6SK55otvpaKQYrEh8mC2/lamdb5TPrcfnBYRrniZxWMwJrK1KtX6yq6AGwMCbi0taCRmiasdCZ5TgvfzHW9qv4cxbgl4N/8bIL6D1kwMydUieWu8eoA3oGcEvvrr/lcuTmDiP68aFVo6/6u+GnwnhqTuXEgsl3hll28QFSlpfjfDvgU5ONZ7d+fgufXFYBVgPw2zm8p2DjfhwVcAKQqntu6cUeDMO9v77Pr0NPXuwdiBHr/ylFJHrK4G5zWwRsX8jdQ1y1j33C70vclZ6kA1E1AdgoGbcE5eCylAb+UhLm1icxgslschnrxYOKpxbCvf4bquNre+LpWLQ+rAuGBXQtAeMlVMYVc8sP8Ea1yoZeIrOF2mmbBJEp5CAuqOyEXrDw3WdduZMojIMA0qx1QzzM/QhghVNEso4KnwSLsYnjcPh1XR0IEhjDhywRLiKne8b
 yQk4Wdyq
 HT31QiPSeMML0GCBtsjwbFcBtNonyCCgjjxqDpFf8wiM7KoYA4JHJuJZKS5xhNAMQeI6YrD2fX0hm4JnpdvJbaxbp6JrdBb+K+ZSlP2hbrkYefOzDDVllVgWgOQfWR/InWou6d5RVSWZcsxwtGzenITsiUISscKZW5fgfIBN/4PHMjFmf58GC9L0YWYPsbnobjGJGPC7bECTkhvkt6XRma9WILTMghXQdIZs421I2Kc+AyNgHAGZqVDJcjv1sKgtK69VxsdOo92TexAZtd3iNMxYXJVjtidfpVg2kC66zeAeAhI/OZrhr5i++FBpJQgq8MoYIMHhjbsvGnrQgeo/AOm9oruVzDWDbQ/r3ScdqsFtKyCo5b9likr0xmm8GrC4eHsChnDa2pKuQ5t1AUo1ybANAVYVIDcwe596UonC2ajaiY6i9nn54Ra/1uKOmCzgM7ptXAVDIm0FI4Q7nTgHOrDudFvxGKDzYH2j2OtGtFfJd5cE4tJePXmhnHvxJNyFeVJjM6yRmA4Q0z9Z95zPL26jxfLvuKnUZiQ9rWIO9WaI3GOJ1XAWUt+O1VcxNGO7JSlaltQ3lq1At0f0Dj7ChuZNhwU9w43kd4C9j0r03EghC4wDBvQDtylGRFFHES2VwKWfJkRIyrHMR6HEYFvuBVrlIM5Bv7QTAbjRkjReq7tf8KZlzaFuvj+9yFFqYjvuDc/3GZLqRPlSHNuhXR01eYTz5Hqn8lHPaB7qo9MyN3hkSoiU95oJpL6SZK1wPhifz8aTvCGnYp7giSLh2OgOrMj5Uo81U2Gr8v7UX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.09.25 14:21, Balbir Singh wrote:
> Implement CPU fault handling for zone device THP entries through
> do_huge_pmd_device_private(), enabling transparent migration of
> device-private large pages back to system memory on CPU access.
> 
> When the CPU accesses a zone device THP entry, the fault handler calls the
> device driver's migrate_to_ram() callback to migrate the entire large page
> back to system memory.
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
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
> ---
>   include/linux/huge_mm.h |  7 +++++++
>   mm/huge_memory.c        | 36 ++++++++++++++++++++++++++++++++++++
>   mm/memory.c             |  5 +++--
>   3 files changed, 46 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index f327d62fc985..2d669be7f1c8 100644
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
> @@ -671,6 +673,11 @@ static inline vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
>   	return 0;
>   }
>   
> +static inline vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
> +{
> +	return 0;
> +}
> +
>   static inline bool is_huge_zero_folio(const struct folio *folio)
>   {
>   	return false;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 5291ee155a02..90a1939455dd 100644
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

We should be operating on a folio here. folio_trylock() + folio_get() + 
folio_unlock() + folio_put().

> +		get_page(page);
> +		spin_unlock(ptl);
> +		ret = page_pgmap(page)->ops->migrate_to_ram(vmf);

BTW, I was wondering whether it is really the right design to pass the 
vmf here. Likely the const vma+addr+folio could be sufficient. I did not 
look into all callbaks, though.

-- 
Cheers

David / dhildenb


