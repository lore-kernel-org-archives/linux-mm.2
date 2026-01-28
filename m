Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC64BD3F091
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 16:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35B76B0005; Wed, 28 Jan 2026 11:38:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEC916B0089; Wed, 28 Jan 2026 11:38:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCE256B008A; Wed, 28 Jan 2026 11:38:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC4396B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:38:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 414EFC2693
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:38:49 +0000 (UTC)
X-FDA: 84381931578.19.5258E25
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 00FC9100003
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:38:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I/+JSsJN";
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769618327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvwUtKzwHdNf28qH621RfDijiiFJTykMerMvhScCt2E=;
	b=ElIoel67HYvIIGwgPuSxYBDUrXoDJ2kOGMDTjZfDwG0dU2Lj7djpDhTCp96x8XOE/kpIox
	a2zndPAiLHYxILmdiLcy0FlwMsxivbfa8YQjRq86WSOv6Eno9DYZR1l6wgQkvY4y1hNj7J
	9y1RP1Fn5EOUsHHLptsczGjvZaohGQ8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I/+JSsJN";
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769618327; a=rsa-sha256;
	cv=none;
	b=AxEKXZ6e+eTvreqOlkS0ucisqsiDZJzjJp7UyLHH+lrIF3mc4pplsG5cnkJSvykUz6vYWF
	N0uwmyFX9f/wJ6Ko0qcxWsbqXv9RoxP7r5O4BEIZ6FRS7PuFe5ajwEMdVLAp452QW6H8qv
	eexy9IFjcTKbz81uhuyVPuVvLreskkc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769618326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vvwUtKzwHdNf28qH621RfDijiiFJTykMerMvhScCt2E=;
	b=I/+JSsJNM0dR4fl/xJzZCdSQNUJHBN3Xm1Q/GWqzYJcsrz+2Ksej+e6US9ZhJ0bCQj7cP3
	3Cst5nUTwG6hB7vp9oWqrA9X4b++pugRpsnk/7XrE/q8wM2EncGauuvmiMQaAwNFRev8Ah
	GAQiXtT9ROnAQSH354qLKYjCN0mjT88=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-NfujA5KFMOeg2LUsRzlnuQ-1; Wed, 28 Jan 2026 11:38:45 -0500
X-MC-Unique: NfujA5KFMOeg2LUsRzlnuQ-1
X-Mimecast-MFC-AGG-ID: NfujA5KFMOeg2LUsRzlnuQ_1769618324
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-4088136faccso12058111fac.2
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:38:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769618324; x=1770223124;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vvwUtKzwHdNf28qH621RfDijiiFJTykMerMvhScCt2E=;
        b=aTfWDRK3STeY4VMHQr8ykdF+cb7IKZp0bHeu7RTDwyx4DxYJrwXMp2C2lH8e0JXgqR
         zMHh/AihztgMx5cdEAIDKXjj5KR4kF/N/wfzz3oUHI0q2MTz2kB25nz3UYE8VIq+LyaZ
         OfcL3FRRuPvWI8nYos0xk22yAxzh4DTYIZZ9KYKJPSLFpJgneUiBXAmzFqukU1NkQAI2
         VEqGQ0G442EcfzhGF/tDIw3wKGqFY2rlOVrdqvy2/5HVRkkJX7GxyiNKv+qLM09NCoZ8
         rD4GuX7UfYNKLszcdvG18Q2LVbb5NTKMnJGM4i3MJXqOxMMfHoZPDjWIndRqBdhQeATr
         MMLA==
X-Gm-Message-State: AOJu0Yy0ueKAoV2HfHv85Ttsq5A+s2W/WyuDylEtT1AxeWySaV0YsB+e
	jWZ9nPt+z7FqmiWfgkA6YZldfrkma09oPc8mSxW38B5CQvyPahonFaXAtWhKvBS7cGxSyfq3Vfh
	4LaJACd7n5af5fRrpy806yYubGttsaBe+fRtB0PDmQ1kOLkhWjRpDg3Ifq6xVfgr/tc3SL2v+N0
	2mhOvkSjPxX2fkp058wSfQ0zD2L0doSBfT1A==
X-Gm-Gg: AZuq6aKPKYeX+6Y5xl6fwdbPfBVllwyQo+rCAtWbWmCHoFG06N3niO1j5V/5gs4EEnQ
	8hpl63pIQzi0OkNUjGnV2OdfJ+B30FikN41YBqvqIh4V0C79Bb0LZ3I5S+r539g8lP6mRLB2hkw
	4eTOGuWfR0vdA9J3WCzkDhnxIIQBUasFeh7Qw26GMtp6/UV4DUPkvtQMcHAm9PvfJLfIKvqlF8u
	CyyLvIIjJ/rxNaVxqYBoiN06IdWno87axcNKXtBd+Rx0WY5gpK8pmDF/ag+WcUNA/+cP5mk9vHU
	R14CohdrBm1QBTPPKVeJcru/N0SX85Yq8n27YzjNDCAc+Bo/7hieyHEfeBGszH4E+FJ9r36njxz
	h07YqXCt3xBxH8HExGQ==
X-Received: by 2002:a05:6870:6f03:b0:3ec:3aa1:84d2 with SMTP id 586e51a60fabf-4093fc716demr3763774fac.11.1769618322661;
        Wed, 28 Jan 2026 08:38:42 -0800 (PST)
X-Received: by 2002:a05:6870:6f03:b0:3ec:3aa1:84d2 with SMTP id 586e51a60fabf-4093fc716demr3763682fac.11.1769618320931;
        Wed, 28 Jan 2026 08:38:40 -0800 (PST)
Received: from ?IPV6:2601:282:1c83:9aa0::56cf? ([2601:282:1c83:9aa0::56cf])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-409570f63b4sm2077985fac.3.2026.01.28.08.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 08:38:40 -0800 (PST)
Message-ID: <b824f131-3e51-422c-9e98-044b0a2928a6@redhat.com>
Date: Wed, 28 Jan 2026 09:38:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v14 03/16] introduce collapse_single_pmd to
 unify khugepaged and madvise_collapse
To: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 akpm@linux-foundation.org
Cc: david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com,
 usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, zokeefe@google.com, rientjes@google.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 David Hildenbrand <david@redhat.com>, shivankg@amd.com
References: <20260122192841.128719-1-npache@redhat.com>
 <20260122192841.128719-4-npache@redhat.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260122192841.128719-4-npache@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wi7UYLUxXctMjetfEMtXHxWgGrFtQmPHs1MredVK1i4_1769618324
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-ZM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: xaozdh9eg1m1sfpd565cysxguhjxwuu4
X-Rspam-User: 
X-Rspamd-Queue-Id: 00FC9100003
X-HE-Tag: 1769618326-286187
X-HE-Meta: U2FsdGVkX19nbelQBc2pqtxqkMaPkltUTgdZa+jTiZizQngSv0OBB/xb/4nM3f3l1PJvNF19fqbEXJ1UJEm8HsxO0w3BSvlfNEpUE2XhdxQuRCea48jadW6YprZFIoawxOXwkyzuXOllIm7Or/TIijkc3u6zVtUT9aTjrP6HDVIMWOWIIF+bsHo0mxsBPlTfw4r2PoIB8cg8rfVghSfnnB0PZREl1SMm+j3aHtlXtgF64UmaIPDXwvtqgl8cceIt4ELXcBETTKr+iY1EMNGTStIyDvEw6rF4C20f69RMIf4anJtPsEX6HSF8OWvWv9qN/SJ5KliRKNDwLEihyDdEkZjwN/KKOrSsmu3uaXllxW5s4AHed2nlrQWNftiIC6imOSb8hGjqKx4fhFvPxNliuEg+GrlMKBrNs4EtHc+1l2hx1tYmIM4HRwu0t9HvQk0EgA17kG/j8+Q7F4hZC6/bhxtbmJN1BsFoSupnZXpI09G2DlnfcpIJvTEmL/F796nz0bpiAm8ndb9nBVilCC6FFBrHslXaT7y848DoN6p8CJC9OyciC+5OpjwDVA948QBhYKEYc43QOFhEV6aFOr8Qteb5WYH6a5KWbueclLz5ZCfKZxfJavl4f+sFCUDQkCMCbJrcgUVt6jmC/FSRai8SD5j+UWvFClZWLw1zUVz64MIuwlhhDmTDofFzMAtOQNlZ05La/vTnDZz3pDKdrIiaqj/rDdIV6wHRMPNeV5p7w5Ok0BA5uxXfe5bgA93Rk1WYQkVyl9cxspXO+a/awTsSXEF8FFcB8XIOXsVT2cxfiakLVzJnAFyeDk3wYJmvwAXJnWAiGIqeCWL6v+5ByCeH2/leeLcNJPRjhSUQOqyani62J7hFZL1uc1PVb6OKx6kCZyHG3Is+YEr0/cVUuZoSEY65ys/9dKz48sxkPnnHkaiBiv2aNNk2IPa2z+J2HVZ54LuIC1p8AoOpMZPt1qE
 WmT6celo
 FhVAlWO0Q1bGvybKHNtKiyo+yPGTtJxMgiHEyRa7EzraJbnZvWQYj2zOIYcnrCcZIExGu1WFC6VSE6d4S8ebeR+VXckDbGto6ipGU3sA0y6eGFwne+o085WIJ5cE1kuHUAfgL3S+JETEV6IcmuAz27JY0F6AN7pZm/WnrpDS73wYVSZPeCCmi8pKOrZ0aYXT5KQLhPFEAQuN4I8/13eVmIYTmrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

could you please apply the following fixup to avoid potentially using a stale
VMA in the new writeback-retry logic for madvise collapse.

Thank you!
-- Nico

----8<----
commit a9ac3b1bfa926dd707ac3a785583f8d7a0579578
Author: Nico Pache <npache@redhat.com>
Date:   Fri Jan 23 16:32:42 2026 -0700

    madvise writeback retry logic fix

    Signed-off-by: Nico Pache <npache@redhat.com>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 59e5a5588d85..2b054f7d9753 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2418,6 +2418,14 @@ static enum scan_result collapse_single_pmd(unsigned long
addr,
 	mmap_read_unlock(mm);
 	*mmap_locked = false;
 	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+
+	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	    mapping_can_writeback(file->f_mapping)) {
+		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+
+		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+	}
 	fput(file);

 	if (result != SCAN_PTE_MAPPED_HUGEPAGE)
@@ -2840,19 +2848,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned
long start,
 			*lock_dropped = true;

 		if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
-			struct file *file = get_file(vma->vm_file);
-			pgoff_t pgoff = linear_page_index(vma, addr);
-
-			if (mapping_can_writeback(file->f_mapping)) {
-				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
-				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
-
-				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
-				triggered_wb = true;
-				fput(file);
-				goto retry;
-			}
-			fput(file);
+			triggered_wb = true;
+			goto retry;
 		}

 		switch (result) {
--
2.52.0

On 1/22/26 12:28 PM, Nico Pache wrote:
> The khugepaged daemon and madvise_collapse have two different
> implementations that do almost the same thing.
> 
> Create collapse_single_pmd to increase code reuse and create an entry
> point to these two users.
> 
> Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> collapse_single_pmd function. This introduces a minor behavioral change
> that is most likely an undiscovered bug. The current implementation of
> khugepaged tests collapse_test_exit_or_disable before calling
> collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
> case. By unifying these two callers madvise_collapse now also performs
> this check. We also modify the return value to be SCAN_ANY_PROCESS which
> properly indicates that this process is no longer valid to operate on.
> 
> We also guard the khugepaged_pages_collapsed variable to ensure its only
> incremented for khugepaged.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 106 +++++++++++++++++++++++++++---------------------
>  1 file changed, 60 insertions(+), 46 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fefcbdca4510..59e5a5588d85 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2394,6 +2394,54 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long a
>  	return result;
>  }
>  
> +/*
> + * Try to collapse a single PMD starting at a PMD aligned addr, and return
> + * the results.
> + */
> +static enum scan_result collapse_single_pmd(unsigned long addr,
> +		struct vm_area_struct *vma, bool *mmap_locked,
> +		struct collapse_control *cc)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	enum scan_result result;
> +	struct file *file;
> +	pgoff_t pgoff;
> +
> +	if (vma_is_anonymous(vma)) {
> +		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
> +		goto end;
> +	}
> +
> +	file = get_file(vma->vm_file);
> +	pgoff = linear_page_index(vma, addr);
> +
> +	mmap_read_unlock(mm);
> +	*mmap_locked = false;
> +	result = collapse_scan_file(mm, addr, file, pgoff, cc);
> +	fput(file);
> +
> +	if (result != SCAN_PTE_MAPPED_HUGEPAGE)
> +		goto end;
> +
> +	mmap_read_lock(mm);
> +	*mmap_locked = true;
> +	if (collapse_test_exit_or_disable(mm)) {
> +		mmap_read_unlock(mm);
> +		*mmap_locked = false;
> +		return SCAN_ANY_PROCESS;
> +	}
> +	result = try_collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
> +	if (result == SCAN_PMD_MAPPED)
> +		result = SCAN_SUCCEED;
> +	mmap_read_unlock(mm);
> +	*mmap_locked = false;
> +
> +end:
> +	if (cc->is_khugepaged && result == SCAN_SUCCEED)
> +		++khugepaged_pages_collapsed;
> +	return result;
> +}
> +
>  static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *result,
>  					    struct collapse_control *cc)
>  	__releases(&khugepaged_mm_lock)
> @@ -2466,34 +2514,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
>  			VM_BUG_ON(khugepaged_scan.address < hstart ||
>  				  khugepaged_scan.address + HPAGE_PMD_SIZE >
>  				  hend);
> -			if (!vma_is_anonymous(vma)) {
> -				struct file *file = get_file(vma->vm_file);
> -				pgoff_t pgoff = linear_page_index(vma,
> -						khugepaged_scan.address);
> -
> -				mmap_read_unlock(mm);
> -				mmap_locked = false;
> -				*result = collapse_scan_file(mm,
> -					khugepaged_scan.address, file, pgoff, cc);
> -				fput(file);
> -				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
> -					mmap_read_lock(mm);
> -					if (collapse_test_exit_or_disable(mm))
> -						goto breakouterloop;
> -					*result = try_collapse_pte_mapped_thp(mm,
> -						khugepaged_scan.address, false);
> -					if (*result == SCAN_PMD_MAPPED)
> -						*result = SCAN_SUCCEED;
> -					mmap_read_unlock(mm);
> -				}
> -			} else {
> -				*result = collapse_scan_pmd(mm, vma,
> -					khugepaged_scan.address, &mmap_locked, cc);
> -			}
> -
> -			if (*result == SCAN_SUCCEED)
> -				++khugepaged_pages_collapsed;
>  
> +			*result = collapse_single_pmd(khugepaged_scan.address,
> +						      vma, &mmap_locked, cc);
>  			/* move to next address */
>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
>  			progress += HPAGE_PMD_NR;
> @@ -2799,6 +2822,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			cond_resched();
>  			mmap_read_lock(mm);
>  			mmap_locked = true;
> +			*lock_dropped = true;
>  			result = hugepage_vma_revalidate(mm, addr, false, &vma,
>  							 cc);
>  			if (result  != SCAN_SUCCEED) {
> @@ -2809,17 +2833,17 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>  		}
>  		mmap_assert_locked(mm);
> -		if (!vma_is_anonymous(vma)) {
> -			struct file *file = get_file(vma->vm_file);
> -			pgoff_t pgoff = linear_page_index(vma, addr);
>  
> -			mmap_read_unlock(mm);
> -			mmap_locked = false;
> +		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
> +
> +		if (!mmap_locked)
>  			*lock_dropped = true;
> -			result = collapse_scan_file(mm, addr, file, pgoff, cc);
>  
> -			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
> -			    mapping_can_writeback(file->f_mapping)) {
> +		if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
> +			struct file *file = get_file(vma->vm_file);
> +			pgoff_t pgoff = linear_page_index(vma, addr);
> +
> +			if (mapping_can_writeback(file->f_mapping)) {
>  				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>  				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>  
> @@ -2829,26 +2853,16 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  				goto retry;
>  			}
>  			fput(file);
> -		} else {
> -			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
>  		}
> -		if (!mmap_locked)
> -			*lock_dropped = true;
>  
> -handle_result:
>  		switch (result) {
>  		case SCAN_SUCCEED:
>  		case SCAN_PMD_MAPPED:
>  			++thps;
>  			break;
> -		case SCAN_PTE_MAPPED_HUGEPAGE:
> -			BUG_ON(mmap_locked);
> -			mmap_read_lock(mm);
> -			result = try_collapse_pte_mapped_thp(mm, addr, true);
> -			mmap_read_unlock(mm);
> -			goto handle_result;
>  		/* Whitelisted set of results where continuing OK */
>  		case SCAN_NO_PTE_TABLE:
> +		case SCAN_PTE_MAPPED_HUGEPAGE:
>  		case SCAN_PTE_NON_PRESENT:
>  		case SCAN_PTE_UFFD_WP:
>  		case SCAN_LACK_REFERENCED_PAGE:


