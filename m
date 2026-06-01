Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 343C3CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99ECB6B043D; Mon,  1 Jun 2026 11:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E8A6B043F; Mon,  1 Jun 2026 11:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B816B0440; Mon,  1 Jun 2026 11:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 768BD6B043D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:51:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3312FA06ED
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:51:04 +0000 (UTC)
X-FDA: 84831782448.22.DFAD2B5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id DC68320002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:51:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a6z0xSFC;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780329062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ffMgAw/0l81oYOcF6pMuZyRvtL6NSmTvL4iZ9xhEUA=;
	b=WWN2GVwRNTc7TqyDS3mVwQfuubJJX4Bppt2rGGxBQplYKSE/KKb5YXyhXy1dMqB/2tpr9V
	tuvUNEQ9EYPknfxm4mUqYvB6IO9Z8Lxwijawme+3FydTSOhv8kcqpTbFNZrVzhakkPlFba
	VYiBGRAEa+gYMtIfneeugMMPw3P96Is=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a6z0xSFC;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780329062;
	b=JRelQSgx03r5PVMKaQysjkxpnIP16eP6GBmMpXyX7NHK6cd/l2jFJ4fRudcKuqaj+3SfEq
	lfDOIWcS5bnSLh1ojFL7hrpr/w5Dd/JeDI4wRXouLkYXNtymUrZ89SWb0gFHV/aumN+eNV
	N92hjEmkIRnqSsIDZ/Q/1IFcko30ut4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A9C3B176B;
	Mon,  1 Jun 2026 08:50:55 -0700 (PDT)
Received: from [10.163.164.232] (unknown [10.163.164.232])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 58AB23F7D8;
	Mon,  1 Jun 2026 08:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780329060; bh=OlRcZLIeebzLMKiQRYyZEfaoPBr3MziUGMt5wekQ5Qo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a6z0xSFCG0cXx4w9riACRq6j/sbmuGQrkWAVPOhxI5ZmLMpVRZTmaMuarUCzsFEWH
	 h8CqPay08Dlwm1kf21m0CTVjbpOZXxtm4nv3ojl4YlrmToVFx2KmncgodCc3jOFZx2
	 iw3L9DyBU2D2DIs8DilPDkzABixIJ/6ZILmdIVqg=
Message-ID: <cd8b6bb1-5c42-47e4-8773-2c301a029372@arm.com>
Date: Mon, 1 Jun 2026 21:20:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260601083044.57132-1-ljs@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260601083044.57132-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DC68320002
X-Stat-Signature: ukq4qe3883n4oo8158tmdu6gptbc4dr6
X-Rspam-User: 
X-HE-Tag: 1780329061-760482
X-HE-Meta: U2FsdGVkX1+GdcKc/vgQ3ULayBdE23CZ6B5kNddgEg1mHWtGZKaajpae26eYrRgSWIMTjWHrCw/Y6MXdXKnnHksdQtOGTrgFxH0tT41tzgOm0vexBGsg1uQahlgJkKqgGQ+W9Bx9gbrieNPY3CU1j/Y2ktzLDVisuAOD6BCGuLqlAT2S+tNqVKanTLFzI2chCSF4WUi897E0gT3ebHdHKzqJJzU8FpOvmegyiAf6F+MGY/8kkJvzT8mBADdNMFafR/qORRxshg066B1wSedvJBrsmKVPs3k9ib7iGvQyHd2kbI7pBPcQaghsHQAuFTAABigAORN6cQwtoZO+PJNyYewvTiAYcRpfhx1VmgZIvQTbtfOOYyi2iXBIh8o/RYF5DP+Af/g5IvNz+RWOOZjTRqKN0k2oovMoaZP/diNLWUC6XBe1v8d7gr8e+UfLTSb/k90CR6VeLaW4/ZrSPPa/R+CwMtcQO7LLaO1aiFImAQ6+OhE46EZosrr4gx+mUpGgBrEMOQdbQhCIbI+IzJuvNU8Is3xkMAHDpifu3Et6qtBS7OyCvJNJ1DaDZheswZsbkaMQDp/K9rliFZSNgs5o8fNEHkoak2hM1ph3nLiuf/HXbgwjeU10Ihy9WhW2BYaHM/ZZG8SAwiYMFMc0RLQ4FP4blqv4ZooIsCU0y5+ybWVaIMN57Uc48fjtv++1L2BjVW4Unu5XDt6EbDAGjK0O6u74QjbHLBGDhv8fXaRduvrXE+5Xm2yW+zb3mILrEv8mHyO6yCAkxQi8bZq350M1W7pryG92sVIWOwPB+32UIPXiywywxWHKJ107cdPG7ckx+imR1S1voiBD0yr32vFzPrOmxnXc+z6EyKDBG02euAIquGQ6XajsWeGt69Xzl9zVGHcN8sdDFLXGHd4jICvOTH0fxYq+8iYm6J6lRQ/l6h/pkyrDPqu6EWoutoOyURutW/d1df2NY7pnDg8nhNT
 L7QcGaKi
 V98CtW4ADOWqqFR+4+a2OYHgH9wi9REriB59u4Gcq/IM0rc504ogtiNbYvjzISvgxH6OuL+SYNaFmll/Wwr0314YmicvVV5WbP6jEobu0ZOPLQ3UI/s883enFqtE76/Er8nrIkjhzbfXn1T/I4AUvU5u8J2c7haMOAUEnuFKGy3MXQVVQ7p86sJZkr9eVL+G2K8WPqlh0YrUy00V0sQEbDJVryPw1UTbrW/4o0VGz0ayVLk7WjuGUN4UgoWEBRp3sdB+14hUuWOskxGCyHYcqv3RFz7re6JewBnGd/CMn9ERjzOpys/2cW8nrSoLK8PszNzElbuSYdJKEmLRvw3DYG4Vr/dNBy4K4gV1YkoxxT3TC+/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/06/26 2:00 pm, Lorenzo Stoakes wrote:
> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") updated set_pmd_migration_entry() to use
> pmdp_huge_get_and_clear() in the softleaf case, but made no further
> adjustments to the function itself.
> 
> Therefore this function continues to incorrectly use pmd_write(),
> pmd_soft_dirty() and pmd_uffd_wp() to determine whether the installed
> migration entry should be marked writable, softdirty or uffd-wp
> respectively.
> 
> Whilst all are incorrect, the most problematic of these is pmd_write(), as
> this can lead to corrupted rmap state.
> 
> On x86-64 _PAGE_SWP_SOFT_DIRTY is aliased to _PAGE_RW. So calling
> pmd_write() on a softleaf will return the softdirty state encoded in the
> entry, assuming CONFIG_MEM_SOFT_DIRTY was enabled.
> 
> This was observed when running the hmm.hmm_device_private.anon_write_child
> selftest:
> 
> 1. The test faults in a range then migrates it such that a device-private
>    THP range is established.
> 
> 2. The parent then migrates it to a device-private writable PMD entry whose
>    folio is entirely AnonExclusive with entire_mapcount=1, softdirty set
>    (accidentally correct write state).
> 
> 3. The parent forks and the PMD entries are set to device-private read only
>    entries, entire_mapcount=2, softdirty still set.
> 
> 4. [BUG] The child writes to the range then migrates to RAM - intending to
>    install non-writable migration entries - but replacing parent and child
>    PMD mappings with WRITABLE entries due to misinterpreting the softdirty
>    bit.
> 
> 5. In remove_migration_pmd(), if !softleaf_is_migration_read(entry) we
>    set the RMAP_EXCLUSIVE flag when calling folio_add_anon_rmap_pmd() for
>    both parent and child, which are therefore AnonExclusive.
> 
> 6. [SPLAT] Child sets migrated folio entire_mapcount=1, parent sets
>    entire_mapcount=2 and we end up with an AnonExclusive folio with
>    entire_mapcount=2! Assert fires in __folio_add_anon_rmap():
> 
> 		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
> 				 folio_entire_mapcount(folio) > 1 &&
> 				 PageAnonExclusive(cur_page), folio)
> 
> This patch fixes the issue by correctly referencing the softleaf entry
> fields for writable, softdirty and uffd-wp in set_pmd_migration_entry().
> 
> It also only updates A/D flags if the entry is present as these are
> otherwise not meaningful for a softleaf entry.
> 
> This patch also flips the if (!present) { ... } else { ... } logic in
> set_pmd_migration_entry() so it is easier to understand, and adds some
> comments to make things clearer.
> 
> I was able to bisect this to commit 775465fd26a3 ("lib/test_hmm: add zone
> device private THP test infrastructure") which first exposes this bug as it
> was the commit that permitted test_hmm to generate the test.
> 
> However commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") is the commit that actually enabled this
> behaviour.
> 
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

Sashiko continues to find existing problems :) What do you think:

https://sashiko.dev/#/patchset/20260601083044.57132-1-ljs%40kernel.org

>  mm/huge_memory.c | 45 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 33 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bf9b480bb3b0..79463c709c98 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4982,7 +4982,7 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>  	struct vm_area_struct *vma = pvmw->vma;
>  	struct mm_struct *mm = vma->vm_mm;
>  	unsigned long address = pvmw->address;
> -	bool anon_exclusive;
> +	bool anon_exclusive, present, writable, softdirty, uffd_wp;
>  	pmd_t pmdval;
>  	swp_entry_t entry;
>  	pmd_t pmdswp;
> @@ -4990,12 +4990,26 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>  	if (!(pvmw->pmd && !pvmw->pte))
>  		return 0;
> 
> -	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
> -	if (unlikely(!pmd_present(*pvmw->pmd)))
> -		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
> -	else
> +	present = pmd_present(*pvmw->pmd);
> +	if (likely(present)) {
> +		flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
> +
>  		pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
> 
> +		writable = pmd_write(pmdval);
> +		softdirty = pmd_soft_dirty(pmdval);
> +		uffd_wp = pmd_uffd_wp(pmdval);
> +	} else {
> +		softleaf_t old_entry;
> +
> +		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
> +		old_entry = softleaf_from_pmd(pmdval);
> +
> +		writable = softleaf_is_device_private_write(old_entry);
> +		softdirty = pmd_swp_soft_dirty(pmdval);
> +		uffd_wp = pmd_swp_uffd_wp(pmdval);
> +	}
> +
>  	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
>  	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
>  	if (anon_exclusive && folio_try_share_anon_rmap_pmd(folio, page)) {
> @@ -5003,24 +5017,31 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>  		return -EBUSY;
>  	}
> 
> -	if (pmd_dirty(pmdval))
> -		folio_mark_dirty(folio);
> -	if (pmd_write(pmdval))
> +	/* Determine type of migration entry. */
> +	if (writable)
>  		entry = make_writable_migration_entry(page_to_pfn(page));
>  	else if (anon_exclusive)
>  		entry = make_readable_exclusive_migration_entry(page_to_pfn(page));
>  	else
>  		entry = make_readable_migration_entry(page_to_pfn(page));
> -	if (pmd_young(pmdval))
> +
> +	/* Set A/D bits as necessary. */
> +	if (present && pmd_young(pmdval))
>  		entry = make_migration_entry_young(entry);
> -	if (pmd_dirty(pmdval))
> +	if (present && pmd_dirty(pmdval)) {
> +		folio_mark_dirty(folio);
>  		entry = make_migration_entry_dirty(entry);
> +	}
> +
> +	/* Set PMD. */
>  	pmdswp = swp_entry_to_pmd(entry);
> -	if (pmd_soft_dirty(pmdval))
> +	if (softdirty)
>  		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
> -	if (pmd_uffd_wp(pmdval))
> +	if (uffd_wp)
>  		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
>  	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
> +
> +	/* Migration entry installed: cleanup rmap, folio. */
>  	folio_remove_rmap_pmd(folio, page, vma);
>  	folio_put(folio);
>  	trace_set_migration_pmd(address, pmd_val(pmdswp));
> --
> 2.54.0


