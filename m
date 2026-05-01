Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391D3CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908C46B008A; Fri,  1 May 2026 15:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CE76B008C; Fri,  1 May 2026 15:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BDEF6B0092; Fri,  1 May 2026 15:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52E216B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:08:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0855B12022D
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:08:35 +0000 (UTC)
X-FDA: 84719787390.20.0172212
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 49518C0009
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:08:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vCFSKxRu;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777662513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7cfqrv1nnyfyEJ9gOjhJIUa0rBiId0AlmtPVRjc0aI=;
	b=a66HQQGX3iyHspLPoKkJAJFxaZIYe2D4J8MeNH4GsOEYBUDi1cUrECldopxbYQEhX+mwVV
	i7gpsN3mr00gHIPtoXrLFyfibg+O4YTzCmPdDq5JMDVNDrPYHxv60ZGoFil7nlcw9IxAmD
	/fplTIfuSUCLB42jrxyIZyCJ8BOAd8Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vCFSKxRu;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777662513; a=rsa-sha256;
	cv=none;
	b=zAop+vn2LYAQquiqtEEMDy0VccftrW7PKoodS/o+itA9AhiwSdlfQTzeX6MOf8mM02KTBT
	HmYWEgZW7XUMYwkmd37/SWi204pR8E+A4g527AMv86bTMWsadOKZlPWL0lQ3v+YzBAA+e6
	y4a6C/lcIbMipTnIAC4lFjNKVwXm28U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 863B060120;
	Fri,  1 May 2026 19:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE8FC2BCB4;
	Fri,  1 May 2026 19:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777662512;
	bh=I6gnZHqYOCIXMIR7WcCKDccSArsK7LaPaWd4F38Mg+c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vCFSKxRu9IyObNQP0Q4c0ohR/O89ev2Mh2lFh4nYXTb4gPMCQcuAv5+UGVP3Y65Rg
	 /6ev2/LxHXqfn6bUirlOeSO9/Xo/yLp3Z2UiHMJ5Ass9u11i6xUrvOJCdua2ir3Jt5
	 A3AV7cM8wmADSCLkz0kIabN8IZJuAxix3TOaYJhA7YE4KFVjgRF3CI7HPk5LlvTmDK
	 a8vnnEAHM0+4aMN/B5ZGSXSQlnnhnLgfj07OuddnglDg6uoj9GvXW0TH3Y5Exnngn3
	 LpChLJ4cyBtzbfSHRUBvRAvC2n8aiJk/yD9VS7c0/zAp0UMcYbZKtiwJWm5oGcrgpC
	 Fje7nj6LyeyIg==
Message-ID: <24ab5ddc-11a9-40ed-90b2-1a6c68010928@kernel.org>
Date: Fri, 1 May 2026 21:08:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
To: Andrew Morton <akpm@linux-foundation.org>,
 Sunny Patel <nueralspacetech@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Balbir Singh <balbirs@nvidia.com>
References: <20260501115122.23288-1-nueralspacetech@gmail.com>
 <20260501054416.af0ed62d635c3eb01d425e61@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260501054416.af0ed62d635c3eb01d425e61@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sbccmhnfj5zg8hmhir7pxjymfhdfng58
X-Rspamd-Queue-Id: 49518C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777662513-256295
X-HE-Meta: U2FsdGVkX1++8YDJCE1xIcdJjCMBx8s7j+6vlLKT9AVbu16twp3GoRwlkar96A2AUar9SF3Bt3zMR+yn8oiZibp7umQkQSCV+H54MqoTtcfLaIQyhVF9KvsO/Jpxb+/SeOa5fQorur/JN+k8+jgADdJzrbTd8bhPrbN8MCRC2P71UyBzFKxu7gdJvlBwTPITeBGsNM+yOK6wCVlxRRgIjD22P56BXwH8+Pu6xJjNw8Pfx7sgvqVrNn5QMAVDtlh0ZRn1qIWaK2aXXosw61kfQzHSQNoTz1loi0htDeyqe+vm+TISdjbWWIwpzeMb4GtVRlusZP+QyG/iBIBWr1/efU5Q6kx8Z6kp8++kSdrWI+YjxqUNzN/i+aHsfoFTb34SCbIQi9X1D5gPB9eYReVNaN2qusXgaAJAn/vNLGKKwSLdEGnLL9E2LXDclXLrAImWKRcIYzK+ky2U6vvrnxTOYRJMqB0MPAR2r038DpdKNHRcSoZtnYhKD3cYI1e5AS5+XPB4kvS6/e3TSVVAQsO9c7/R9RjV8tRJR3OOoo7m3mZC6K1mjVQ189lxDFDbQ4tUdbWBZynxUyeHDO2n3+m0o+hKZqQiSnygStn2+ppM1ErY+g2qFL1/Z7j/vGRl2SZ7JfTrdZ9Qj7Z+aTBGT8T2hDaCQj5giibltRRPkaMP7qik+NmQPq0jdjsxZl5pWw3KAK2ZQZC4hq8VWC6ZRLVFeVmowqLFJnfZMeM3W1UXF8pKRkiKmZRVHg+h98kwuCJxNs86BzUUW5ysUug6Q3Zr/iWwJFrmRdT0tZvVxPz005djriX9OFNQvnZ/USxVhVLt3Co6+Nvho7lqUEU0Ts6Z/Z/EMTSggcQaY/cHb1FA2gr2njuQUjFQizOvJWlHpNR5aoPvMjqVhpnC3WKYW5AKctzmQrBa6FyZwSZcAPjOAYcT9MvDqb9V+zVBHap1CX3+Ygcbb6nZLwHfyhNE6PB
 HdLNIKtP
 FB+H03UBLPZnBQ6bPAMhGj8mQz3CIZsqQY8PpOeJ1p+KUV98sidm5EBX6T5ertXq0fm44tz8ap58Plu87DONIsZAN9NR9prQrcWoIyAjDE6jqtF60Wl7cPh9Ftq9PeBQ2nyEs25Ed+Zk9EtB8MWqtS04aFf2uzKnR7VD/P7Ed/NBzrPHHNVPuesRZzdTXOsCa0mXxLsnWxehzchJZhS6GBdgxDP9/S3+bObV1XYZBtHXalkjccxtOabxWG1H65Kf3C1Lh66qpiqQfMrznOvU3lekQe/bEwv/LlfdVdAikBgzYlZE6EQbVg4Z6scJOD69KzPicCK15KlwOvobUssjBHCVA3FxCK489FWqVEZSwlDMpIxVS5USIftkIcHyZxCCXwIVgKjufVI6kA81iqIoCulI6hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 14:44, Andrew Morton wrote:
> On Fri,  1 May 2026 17:21:16 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:
> 
>> When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
>> to a PMD check failure, the pgtable allocated earlier via
>> pte_alloc_one() is never freed, causing a memory leak.
>>
>> Added free_abort label to release the pgtable in error path.
>>
>> ...
>>
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -840,7 +840,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>  	} else {
>>  		if (folio_is_zone_device(folio) &&
>>  		    !folio_is_device_coherent(folio)) {
>> -			goto abort;
>> +			goto free_abort;
>>  		}
>>  		entry = folio_mk_pmd(folio, vma->vm_page_prot);
>>  		if (vma->vm_flags & VM_WRITE)
>> @@ -893,6 +893,8 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>  
>>  unlock_abort:
>>  	spin_unlock(ptl);
>> +free_abort:
>> +	pte_free(vma->vm_mm, pgtable);
>>  abort:
>>  	for (i = 0; i < HPAGE_PMD_NR; i++)
>>  		src[i] &= ~MIGRATE_PFN_MIGRATE;
> 
> Yikes, we leak that page on several error paths.
> 
> Thanks, I'll retain David's ack from the v2 patch.

Yes. If we want to avoid more labels, we could do something like:

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index ab49d4dcdb60..babb56c4d47f 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -795,8 +795,8 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
        struct folio *folio = page_folio(page);
        int ret;
        vm_fault_t csa_ret;
-       spinlock_t *ptl;
-       pgtable_t pgtable;
+       spinlock_t *ptl = NULL;
+       pgtable_t pgtable = NULL;
        pmd_t entry;
        bool flush = false;
        unsigned long i;
@@ -818,14 +818,14 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
                count_vm_event(THP_FAULT_FALLBACK);
                count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
                ret = -ENOMEM;
-               goto abort;
+               goto error;
        }
 
        __folio_mark_uptodate(folio);
 
        pgtable = pte_alloc_one(vma->vm_mm);
        if (unlikely(!pgtable))
-               goto abort;
+               goto error;
 
        if (folio_is_device_private(folio)) {
                swp_entry_t swp_entry;
@@ -840,7 +840,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
        } else {
                if (folio_is_zone_device(folio) &&
                    !folio_is_device_coherent(folio)) {
-                       goto abort;
+                       goto error;
                }
                entry = folio_mk_pmd(folio, vma->vm_page_prot);
                if (vma->vm_flags & VM_WRITE)
@@ -850,21 +850,21 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
        ptl = pmd_lock(vma->vm_mm, pmdp);
        csa_ret = check_stable_address_space(vma->vm_mm);
        if (csa_ret)
-               goto unlock_abort;
+               goto error;
 
        /*
         * Check for userfaultfd but do not deliver the fault. Instead,
         * just back off.
         */
        if (userfaultfd_missing(vma))
-               goto unlock_abort;
+               goto error;
 
        if (!pmd_none(*pmdp)) {
                if (!is_huge_zero_pmd(*pmdp))
-                       goto unlock_abort;
+                       goto error;
                flush = true;
        } else if (!pmd_none(*pmdp))
-               goto unlock_abort;
+               goto error;
 
        add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
        folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
@@ -891,9 +891,11 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 
        return 0;
 
-unlock_abort:
-       spin_unlock(ptl);
-abort:
+error:
+       if (ptl)
+               spin_unlock(ptl);
+       if (pgtable)
+               pte_free(vma->vm_mm, pgtable);
        for (i = 0; i < HPAGE_PMD_NR; i++)
                src[i] &= ~MIGRATE_PFN_MIGRATE;
        return 0;


-- 
Cheers,

David

