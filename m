Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF1FCCA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 04:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233648E0003; Mon,  8 Sep 2025 00:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20ADA8E0001; Mon,  8 Sep 2025 00:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121228E0003; Mon,  8 Sep 2025 00:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE64F8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:14:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91A051DEE7A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:14:12 +0000 (UTC)
X-FDA: 83864765544.12.2B8E86E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7104040009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:14:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NtjX64P9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757304850; a=rsa-sha256;
	cv=none;
	b=LB0o1IysAUMMN0YDhllVQO1XAEgm4sxQm5LtdwOS9NzFXSVZ5rw38HE6vvH2q2UIuYj9Pj
	vZUI+6LaXgug0yDbWksDqooCGubM2tMElOE2QavKmV8DK7Zo4fGK70sE0C3HO2iak96iop
	+DxLipgS+Sm3DLvCjIkQZ834dKYCGes=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NtjX64P9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757304850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJsCe6eTTTGDK/V3oOGv4fFA8SBbBbHuaXgk/m4NaJ0=;
	b=x24BU4wmN399oTjEcwhMho+2ZZ4TGyZn3R1gp3AGILjylkGstWedIFm8K7za7niTP+ucLi
	Dw6jNtoYWHdMYrdnOXnUPNCCKhLcp8NYNs+JTX+NkY4YxJuJciK7Zf5Tn847rP+Shm+gjr
	scD+7beDxW9YqxSfmC7puZePXa2kBXM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757304849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xJsCe6eTTTGDK/V3oOGv4fFA8SBbBbHuaXgk/m4NaJ0=;
	b=NtjX64P9GhojYmSTLhlImsEdmiHDzKZMFKPhVhzQVyfnHzIfN7BB6HNduRnUM7oQKGUo6c
	j/hSChb0CFtXiQ1i2QRbUOliJxiq9RVQA72VHYkBqkxGKP83pfz1bc303IgOqVVO9ljle9
	CWdw9PVu+qFkrkexxGKL1NGTMxzgzgw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-Dc2CxtFaMam_omtt4azRMA-1; Mon, 08 Sep 2025 00:14:08 -0400
X-MC-Unique: Dc2CxtFaMam_omtt4azRMA-1
X-Mimecast-MFC-AGG-ID: Dc2CxtFaMam_omtt4azRMA_1757304847
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45de14da365so10468995e9.3
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 21:14:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757304846; x=1757909646;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xJsCe6eTTTGDK/V3oOGv4fFA8SBbBbHuaXgk/m4NaJ0=;
        b=Aqt/NzZikzEnC/lCUw04QHx/pj2NDEzbPa6u3xOERMQnTj8BiEhit04Zc0497VQXO7
         JreA4jn+SLlkrmUII06ecNTNJQNxC52s2/8+ZJK+awXQ+3RfRHQnt6FwSeaoEm1Tgxxk
         P1p3uVOnRdoXw441ZMac4eNXDeotY3NdmSWShf1FvYcH/JWXtS57ry3ckAE1qJkvJJh8
         w0UCXXnNmpNcCoLKCkKMQewbglRnqD0Kl5EObVraY2CCpeRzQPxxMvkp1iJXtMGpmBLw
         9eXzJ4Gb1nxvCFb+2woGfMi0Gqdd+nCP6ekwidODC3L0KmtPsCOJ5fRVOMFfqZZQPeYE
         XQTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMKUQQCjfOCVHB6rdhrpoAHeafQMRrn0eS+j7tovEY9ybKT7t7glNYBN2Fmwf6Nme8PKiVRyX2LQ==@kvack.org
X-Gm-Message-State: AOJu0YxfHjU67DgVTmBT5KG9kk8rCFILhbA39Jz6KWK5lKbm3MIGvLhX
	fKTFNlgWuuHULd1bUnQ3rEVCFb5Gqtv8gXsIeR4NIj9bxGJHpl0yFEsXtjPG24qxAWjJF8s/wVN
	11MXMmnTumnWPJkVdipLT9ctDxoqWdZAo2yLFTV//bMKHYSpr7JA23W2VWd4hXA==
X-Gm-Gg: ASbGncvPaWbRwzGFNY3zka60zYfglABZQ5ZUDgisMfshTxI45Y0ZpCGM5uAZarfaQpI
	t5008tSMoInJLlT858l+cU/M9CEluoBHetUjyyRTkWAGFOjkJIBA/boamvKFjjEq7lloWHGlt9F
	Vyq/anW7TPDQhOs0R59nfJLlcu4PkLC2A7H+LQunzjuccpIjqty2jVAkThWrZl/8YPkhz4wxujJ
	sytnCZlenr/DyeUPYFh9G9upw/cf8c+FV66JqbzaBjlqw0EZBHAZJ/Ck8rg02qYSx27OcOlMAeB
	F/NMvrbZqz2xUpyhB0zUTYDGO2oZSCGdI2zILwkBG3wI6I3tTPD+l+t4VyJ420HWoQ==
X-Received: by 2002:a05:600c:458d:b0:45d:d50d:c0db with SMTP id 5b1f17b1804b1-45dddea5102mr52603675e9.15.1757304845803;
        Sun, 07 Sep 2025 21:14:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFutUyjnY3i7VNpdhUwrQ7pqW1CmodIEYjJPgtpuIcj6TCRCx7EUrnPJPxT8ek+IEd6gcbzjw==
X-Received: by 2002:a05:600c:458d:b0:45d:d50d:c0db with SMTP id 5b1f17b1804b1-45dddea5102mr52603475e9.15.1757304845375;
        Sun, 07 Sep 2025 21:14:05 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd4affb6bsm142588705e9.1.2025.09.07.21.14.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Sep 2025 21:14:04 -0700 (PDT)
Message-ID: <e6b795de-f522-4952-9ec3-00a2359c43a9@redhat.com>
Date: Mon, 8 Sep 2025 07:14:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 05/15] mm/migrate_device: handle partially mapped folios
 during collection
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
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
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-6-balbirs@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20250908000448.180088-6-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: inQy86A1VJj5pF0dd0C8uZtjwC1eiW2fQEVxvjpCnfU_1757304847
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7104040009
X-Stat-Signature: w8qufubm1kgtau3g7fdim55jwj9pfaz1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757304850-978382
X-HE-Meta: U2FsdGVkX1/uvJLv2n6TDWJjUK0li+HMJV3tqm0Ph9gsYo0Lf7MarPMSmBAj5wefom+b5nVDV9DGhu4cep9Zl/xbiF4Ydk/xRwUVDdC3CsnCxOSPnIRtLWoWJa8URXc0/sip4Soih1yf08ZI9BgaExhpBSUEaTHlBFyW/cXEDM8p+ypclj8/ruxDK4Fa1LfUyZOFQNXc/Ul0yMTF7Bs6l+O8kSt043PoV/h8e2Yzw5d83Ur0tr/C6S4hvrkf75VXd0uxcAXge8OEzyOC4JgsU2dGFJjL70oWikIJc0csQai9VjmANOOetQJZDzD9yHNDOTkl3e69N4+/x/PXyTk0ZxiINYV9dIPeyjqetP5XsXt+lO4kDap6ZNeOc6ZkOho/7XCd3AZQXzG68Mx5o+N1jIoT29x4WPWrvEJHypO+BPC1FeNQjEsSYS7pa5UEEhs2PCEKgshgU+v+NjJVyrEFdeGHsJAqLsVbgkzZv43lpq7CmLQa+gDjsnglAcofry014dDpFQBhLtecqPDnJVf08JTfVRopspBSjHgsp3+Ax24YKHPPvRjktsSvbsupibv10j3HBK5c1CXJMEOEFGQh1+s82uNGJBZuZN+k+e30/QKDh2l59blOI2tSAAtgQqzxnbzWjxbC7oiu+BQA0/faU5tCb9OGoFe5pWtJ5jUhyl8yDIiLfkf+qRx59L8coK6zfHmsqbOOwf9qCyMb+d30t9Mr1fEwbLG+08JcumVy6h8Ce07jZH+X/MjzXqdMXNQJYtuWu+x6Gsw7ZNba1r8R6RfWM0n1SBhpJGuWfI58peoF0af6hN1Q/pzocEQZhlJxTipZIkWc+b3V6u325/mbtAaHVmEgHuwQw/Y3rHTMGwQOjx8ICo0RqsQkAAiOXNMuVl6K5MY/WkVnul6HBTja3DOhIxI4H2JAbH3OGVV1LxE4huwIBEuQks304OXDjjDAsNFvaS+t+FR/N7ouoWl
 eUVV8cUv
 bOgxHqdpZTIOT7Ea/cbpLmxqkquhESk2Y2Q3P18BwKiXi3hv4yfgaFQ6/9W19au6MLMAH4RFDY9ZWI67OLcGsD954kpSYWTrwQ4mVrW0b8vHKAQeEtHMujxZt1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 9/8/25 03:04, Balbir Singh wrote:

> Extend migrate_vma_collect_pmd() to handle partially mapped large
> folios that require splitting before migration can proceed.
>
> During PTE walk in the collection phase, if a large folio is only
> partially mapped in the migration range, it must be split to ensure
> the folio is correctly migrated.
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
>  mm/migrate_device.c | 94 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 94 insertions(+)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index abd9f6850db6..f45ef182287d 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -54,6 +54,53 @@ static int migrate_vma_collect_hole(unsigned long start,
>  	return 0;
>  }
>  
> +/**
> + * migrate_vma_split_folio() - Helper function to split a THP folio
> + * @folio: the folio to split
> + * @fault_page: struct page associated with the fault if any
> + *
> + * Returns 0 on success
> + */
> +static int migrate_vma_split_folio(struct folio *folio,
> +				   struct page *fault_page)
> +{
> +	int ret;
> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +	struct folio *new_fault_folio = NULL;
> +
> +	if (folio != fault_folio) {
> +		folio_get(folio);
> +		folio_lock(folio);
> +	}
> +
> +	ret = split_folio(folio);
> +	if (ret) {
> +		if (folio != fault_folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		return ret;
> +	}
> +
> +	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +
> +	/*
> +	 * Ensure the lock is held on the correct
> +	 * folio after the split
> +	 */
> +	if (!new_fault_folio) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	} else if (folio != new_fault_folio) {
> +		folio_get(new_fault_folio);
> +		folio_lock(new_fault_folio);
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return 0;
> +}
> +
>  static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  				   unsigned long start,
>  				   unsigned long end,
> @@ -136,6 +183,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			 * page table entry. Other special swap entries are not
>  			 * migratable, and we ignore regular swapped page.
>  			 */
> +			struct folio *folio;
> +
>  			entry = pte_to_swp_entry(pte);
>  			if (!is_device_private_entry(entry))
>  				goto next;
> @@ -147,6 +196,29 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			    pgmap->owner != migrate->pgmap_owner)
>  				goto next;
>  
> +			folio = page_folio(page);
> +			if (folio_test_large(folio)) {
> +				int ret;
> +
> +				/*
> +				 * The reason for finding pmd present with a
> +				 * large folio for the pte is partial unmaps.
> +				 * Split the folio now for the migration to be
> +				 * handled correctly
> +				 */
> +				pte_unmap_unlock(ptep, ptl);
> +				ret = migrate_vma_split_folio(folio,
> +							  migrate->fault_page);
> +
> +				if (ret) {
> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> +					goto next;
> +				}
> +
> +				addr = start;
> +				goto again;
> +			}
> +
>  			mpfn = migrate_pfn(page_to_pfn(page)) |
>  					MIGRATE_PFN_MIGRATE;
>  			if (is_writable_device_private_entry(entry))
> @@ -171,6 +243,28 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  					pgmap->owner != migrate->pgmap_owner)
>  					goto next;
>  			}
> +			folio = page_folio(page);
> +			if (folio_test_large(folio)) {
> +				int ret;
> +
> +				/*
> +				 * The reason for finding pmd present with a
> +				 * large folio for the pte is partial unmaps.
> +				 * Split the folio now for the migration to be
> +				 * handled correctly
> +				 */

This comment is still not changed, there are other reasons for pte mapped large pages. 
Also now all the mTHPs are splitted, which is change of behavior (currently ignored)
for order < PMD_ORDER.

> +				pte_unmap_unlock(ptep, ptl);
> +				ret = migrate_vma_split_folio(folio,
> +							  migrate->fault_page);
> +
> +				if (ret) {
> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> +					goto next;
> +				}
> +
> +				addr = start;
> +				goto again;
> +			}
>  			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
>  			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
>  		}

--Mika


