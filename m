Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F7F5CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66DCA6B0471; Mon,  1 Jun 2026 12:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645B36B0473; Mon,  1 Jun 2026 12:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582D76B0474; Mon,  1 Jun 2026 12:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4471A6B0471
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:44:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE1EBC2204
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:44:22 +0000 (UTC)
X-FDA: 84831916764.25.6213E2D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id E231E140019
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:44:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=c5fqtT1+;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780332261;
	b=Ll41bkJUbVAJI6BQtcEb2T8n7GqbYapkyAhmI2kc6KDvk5OwOhpUWVjOWoJYJfp/VvZtj2
	SpJbUemEEg3u7qSZB9aGOGXSlCybUVneO9Uu9v1l4lhUhTw6V2cecLZcOglwkbLtw4ZdMf
	kVWgytaud+NA2FzrAXFYt/qj1PLP1hw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=c5fqtT1+;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780332261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvGbKlPMaorfIqYSu0NPB9TBFD9dBTpPD8uoSrJ/uf8=;
	b=uIwMNbQKQe7Z/mE68FLuW2UYyE1EmmHfn6udJqfHGYTD+nCx236LBTsynicNUuaK7bSC0M
	Z/T6BRKTMxTjZCO3ocf0d9wEpEebWku5/n2iGQx2CeRsSHgfxHKeVIvWwhbpMW6m1Nj6uF
	0l+2vYfAgPAoBRM93LNtr3I6dI1tGNg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21D5B1BCA;
	Mon,  1 Jun 2026 09:44:15 -0700 (PDT)
Received: from [10.163.164.232] (unknown [10.163.164.232])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1342F3F632;
	Mon,  1 Jun 2026 09:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780332260; bh=FE7vc9MqdE4fmTSoMt5zTtbVqHqtOgtF0vKRn9+wXLc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c5fqtT1+8I8LBLc1bebUxeZUc8VM+5CZobMAANsXoY1Fnzsd568LQELV3S4BAnsaI
	 ZwDK1K1OHtmJPu74ydcV7hNbqZiiZIQsI6lOooKpFBOaBIOEeUdtmBdzFZRpgqzrXT
	 rtdXOKfQ3j16dGPpa6iE3oZMUeSn8HQXxdEl3EaQ=
Message-ID: <73762983-d48d-486f-ad5f-78015e6f95ee@arm.com>
Date: Mon, 1 Jun 2026 22:14:11 +0530
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
X-Rspamd-Queue-Id: E231E140019
X-Stat-Signature: izwutktkbansks3c6hbyibdywgjf4pff
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780332260-830070
X-HE-Meta: U2FsdGVkX1/VzmxXY7W9SCFonEJGUJ1VewxHNxayC2ZjcYqt9luZY61hLZRniXI3K90J1Zjg+uYJ9GTS7whTFyN/TNOftlSOOUX3bvSVNLEonW+W4nLGwMr45QQLhbAJsx0izPYj1yperYFalC+eHKXbf4eyAUeR9uvbFA1RH2ahBqfvzODBsEb4cTY5+aZSPIY5yxbVcDn3xmDrStmeW0bzb46cANzCRQzJb+CZiEecCLw42bW6zVoq9qMCfNBbwnIP4lSLzv2Tflup7SE/b34E44mJjBNeVCDXqw3KJDkjJaCWd5jDlYy/WG8xLK4wo+XnJzNcQ0OVK0tJVvVf0LbLr0B5DzRjnjmBr3Bv2yr09mIpnts73PLXJaZCB8CRRS0XbeDdxZYg+ftN5+VA0oHt4KCkyx2KXPz567mqSk3OqG9deWJFIOaZhsOyD6e/ICoUUecPEgfyOnqu/fGILlFT6XGWwb7sMCUHmQ+UbTypxugxVklkzfSrSoyyupXdjk6VYXgtGJ64+goRDPFziz1zTx7i5rPu6PycMwCW51I9eTfcYhkEByWn0oXveSrxIT/5hY3iM3dIURDK2cFyn8988g6t6w2lOzfj4jY5VfyrYQ2AK/5WIEUPMYlusP0X8mArB7uLRjd1SpFhNU8Kr7AvnQmtVpDDQ4h360IaDwq1rTiuLQ1HG/WhzU/Ksk2GBTUKQncQxHdXKLj7sWnKrk7bKZU5MKLTFwhr5p2w72cS6+3yJIuYXRXNjZaLHsY5xQwBarUg8DG94I70S4sLzi+H6caCy3hg5kEAfUspvuGW+xmcnpdD/XEoXLT8AIByFvAQMo4HP46esrCXvh+LeCiVssgr2ktKSlOgTBgb2AwIhBt6vseimsRNsph1xeEBY1I6jc2jgidcfJ3I8MP4tKtkWmlikWqBjd5cLilBHkR+GGv2j5fs6dro2jbeEojW6FC7ifIzn/5/S5hu37i
 0Z1mx2TZ
 SgwrC6JWtz0dPAgqkv+oOnIXi2mjv+zb2WH5vqmpttqrz7NM82eCnCt66sMoW7ltxJMkovLNx/DfhewqZQLAbRHI+JqPnMG0nYXEyEKr0c6BSIrtK/BjiZryJTVxE8FxU1R9SNP4wJ8CT6GDogzqNTd5og9owk/ADOpwB4obwWQ39tH9Liesj5VtlEuV6jv10ZSxKEZJ417G+0x26DlIWroxFwsKb9MfVMWJfwuQaSRH87S5KVfZPTbqz7kQO1Gq32aZQDaeMLQOmFhe3VHM7H/mgMW6nmbzWGlI+DdOPpHjCjA/gKls8Y8uNHyTJe3MEVRGeEB5P7YFRs9Il3xRXqqqzegECQLE57VDJ9LOAgmXmLD4=
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

Had a look again and can't find anything so:

Reviewed-by: Dev Jain <dev.jain@arm.com>


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


