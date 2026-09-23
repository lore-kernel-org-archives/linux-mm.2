Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 334C3C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 16:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BED76B0099; Wed, 23 Sep 2026 12:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E496B009D; Wed, 23 Sep 2026 12:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283EC6B009E; Wed, 23 Sep 2026 12:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDAC06B0099
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:00:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DED71C354C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:00:49 +0000 (UTC)
X-FDA: 85245490218.04.3C89E32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C751320017
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:00:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlegRbPy;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790179247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AHP9yMNw4O4Y55aivDsZcXi1ygfma9rl6UXHfkVvyUA=;
	b=7Vm0ie3v9AxA6VmbF7uncJfkUbHV5a9Zasxtk8Z2KLFjBijc6cyxjsXNdPl9mQU4GIyST3
	wS9frLh7asIOm6aUGTHsD2X3gMzpoAru7ypYxfDJ4mjhbVbrneZjLeugXkLtrsTWp4AIZT
	JBAUbrZv8IBTEzZNC3s9HaCat0PUvgw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790179247;
	b=hunxanTkzBMgjR8cpkIeMYoz5gqkv9p2di5QlkcT78tpvYyUBIcRDNtvWD3fJhwenxSBtJ
	aLcGnssL8gP7Wa+hL3mJ69/qk1hkuFc7zZ5FXy8AohhHM90ggNlKlduQS9Fjlgs5Y5XHgZ
	XNtKp2wdW/ZDXbmuvvttKJH7NGbhhnU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlegRbPy;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D84060142;
	Wed, 23 Sep 2026 16:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31DF1F0089C;
	Wed, 23 Sep 2026 16:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790179247;
	bh=AHP9yMNw4O4Y55aivDsZcXi1ygfma9rl6UXHfkVvyUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YlegRbPyfJSaVVQWD97w0tpENa8G1akqMLmPiaL64UEUdemubV5zjP+0EfGoV456w
	 Uifzj7cb+vqbQ9XV9k0NZuiHdjgq2bbtktteEEZCqU+RyfE8Vdzs14C6QjTn3dk6ex
	 QG9bT67uVMzA8K/x0tiPCTdfiCFFlBRhlNL9GZTklh54hroAlXxqi4bnRFWMbo4R6R
	 /EkSIQ99nHp7NsW3bNj1lcbStY08CYCKLK3E/QiLT/9dA1F/p/qi+HC4F9ZCa+i/hK
	 GMYVXvajUrnN01mEg2OK5Ej+gpXbBw0EoN3rLbOAA1buCrlaLRELjpJxcKrpZI/XcI
	 0K2+nD7J24Zuw==
Date: Wed, 23 Sep 2026 17:00:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, david@kernel.org, vbabka@kernel.org, jannh@google.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 03/10] mm/madvise: factor shared LRU folio handling
Message-ID: <arP2k_07Mxp6AYYU@gremlin>
References: <20260922235830.2350770-1-gourry@gourry.net>
 <20260922235830.2350770-4-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922235830.2350770-4-gourry@gourry.net>
X-Rspam-User: 
X-Stat-Signature: wd7bp59ars3udfzutsrq4ubn88enay5u
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C751320017
X-HE-Tag: 1790179247-596060
X-HE-Meta: U2FsdGVkX190lumDlJWJyzH52wwOk5QqbOZfftjNGdURs129K54jxEihF1FjrlB921OgcW/76R8/rm5w6OEeRgo4bm5GPyMzHJ5FAZIvkl2OIKDE/ZDBtFbvxH1+b4x/munLmJGWEnArGw9noMZYMDojZunUPsl+I37cM9f4DIebIGcVBG1GLCJARgbTQ6HUZtaj2RMgaNk3YFLfEn1AEaGOkcIonvjlR2Mcci6IhvNB7zNZh/h2mCNll8G/Dovq5EQ++3NxBVyWIQ1MwhfUancQoCR84b2BsSr5l2DC05KPbe8oN0M1Y+FrWSaTTXOhcMbUNwgyEZBMCuKPzZTcsnsbA5P44qQsg3J5hBYzM5n7UizqUQa0l2/XIfd/2CihyEjZwxhanjnBwhxV0K8PaOfeOfx0rPeE+GosabYlQeRkNCA9+3y3xM9ladqrc8j+cPsgIY1gFmgqWUSjhK6OVzim7slqyKXo4cmsoN6gGqcT4G4BmwJnmUcMr/gZUBAXwVVTysuDdWF+vAvJi6M+u4zb2IWboW/E3CAqAbYPfu1WqcwAeIdFmltlnOfdrl6/YaIkEhpc9Bhox9SNJ0fyfnLual30Zxi3wNaJDmE4lo78josV+NBbpEYEQdENEsdjoNvVycsFfJkfsFG/xkDrnkbxWvrs7zgkguejLOZgrTFUuEJfVZKZSqaFUrozSnHeHUNN+kTe09MyFyK05zQx9cL7i1jU1YdcEtexRPO4NYnllt1eYBc5hzDpm4qB8eArh+nMbENVAdd+WV3h1ILUixilMCSY9MGj7o5PgpL34Dyds8ZLicMZ2CQZBgnNFHOmEx63Wr8tBW4JWGog/cNMWRrpPjUOMybhgddLE3XzV9R6xkCMSXP/JuqJRJ30qXJsN2SYl5N1jvhUZId6KZ5UbEGxN6DG5Ay59VAtmUc/i3vZ923NqXHXP9drSHQ7odyD62UsISEJgc2srAlGVZM
 ApgXMLQc
 C/NkN/UaOUUtBkfh3D5751dtuo9MNFkQ98C/Ksel+kWG0RODUyM82Q2h+kz1SX3LpYqSlxuAh9YhV/8zB2x4g0GTj0bi/yzH2E+/O+86/EKXBEOTn+pmjBNJka8P1yjvS1xhq9VDK02t9EQxC4ck5yzNemoEcxzhYEIhZhms9w0h9+qFnfPmQ/FdvInaF6Ss9kN+jG7F+mcgDev84Gf3JkJ4Lr9v7dEQYlfeTBd61QWSYDLSrBC6Yc1fL3x9YRFTwDQwxb1KfWz1sjcUZcLef+sR2BxTjb0ztMng+pKMu1qc2wzLrt1+/1DYYRB3XABI3sJzXXDH4r7S56SuErVUbHs+S0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 07:58:23PM -0400, Gregory Price wrote:
> The huge-PMD and PTE paths duplicate folio filtering, reference clearing,
> deactivation and pageout isolation. Keeping both copies synchronized
> obscures the page-table-specific control flow.
>
> Factor the common filtering and LRU operation into helpers. Keep the
> lock-before-reference sequence visible at each split site because an early
> reference can prevent split_folio() from succeeding.
>
> No functional change intended.
>
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

LGTM and AFAICT all the code is the same as before just less horrifying so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/madvise.c | 90 +++++++++++++++++++++++++---------------------------
>  1 file changed, 43 insertions(+), 47 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 83d54ab385da8..c345fef23f15d 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -361,6 +361,39 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
>  				     FPB_MERGE_YOUNG_DIRTY);
>  }
>
> +static inline void
> +madvise_lru_folio(struct folio *folio, bool pageout,
> +		struct list_head *folio_list)
> +{
> +	/*
> +	 * Clear references before deactivating or reclaiming the folio. This can
> +	 * make idle-page tracking miss recent accesses.
> +	 */
> +	folio_clear_referenced(folio);
> +	folio_test_clear_young(folio);
> +	if (folio_test_active(folio))
> +		folio_set_workingset(folio);
> +
> +	if (!pageout) {
> +		folio_deactivate(folio);
> +		return;
> +	}
> +
> +	if (!folio_isolate_lru(folio))
> +		return;
> +	if (folio_test_unevictable(folio))
> +		folio_putback_lru(folio);
> +	else
> +		list_add(&folio->lru, folio_list);
> +}
> +
> +static bool madvise_lru_folio_is_filtered(struct folio *folio,
> +		bool pageout_anon_only)
> +{
> +	return folio_maybe_mapped_shared(folio) ||
> +	       (pageout_anon_only && !folio_test_anon(folio));
> +}
> +
>  static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
>  		unsigned long end, struct mm_walk *walk)
>  {
> @@ -373,15 +406,14 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
>  	spinlock_t *ptl;
>  	struct folio *folio = NULL;
>  	LIST_HEAD(folio_list);
> -	bool pageout_anon_only_filter;
>  	unsigned int batch_count = 0;
> +	bool pageout_anon_only;
>  	int nr;
>
>  	if (fatal_signal_pending(current))
>  		return -EINTR;
> -
> -	pageout_anon_only_filter = pageout && !vma_is_anonymous(vma) &&
> -					!can_do_file_pageout(vma);
> +	pageout_anon_only = pageout && !vma_is_anonymous(vma) &&
> +				       !can_do_file_pageout(vma);
>
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  	if (pmd_trans_huge(*pmd)) {
> @@ -407,11 +439,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
>  		if (folio_is_zone_device(folio))
>  			goto huge_unlock;
>
> -		/* Do not interfere with other mappings of this folio */
> -		if (folio_maybe_mapped_shared(folio))
> -			goto huge_unlock;
> -
> -		if (pageout_anon_only_filter && !folio_test_anon(folio))
> +		if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
>  			goto huge_unlock;
>
>  		if (next - addr != HPAGE_PMD_SIZE) {
> @@ -437,19 +465,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
>  			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
>  		}
>
> -		folio_clear_referenced(folio);
> -		folio_test_clear_young(folio);
> -		if (folio_test_active(folio))
> -			folio_set_workingset(folio);
> -		if (pageout) {
> -			if (folio_isolate_lru(folio)) {
> -				if (folio_test_unevictable(folio))
> -					folio_putback_lru(folio);
> -				else
> -					list_add(&folio->lru, &folio_list);
> -			}
> -		} else
> -			folio_deactivate(folio);
> +		madvise_lru_folio(folio, pageout, &folio_list);
>  huge_unlock:
>  		spin_unlock(ptl);
>  		if (pageout)
> @@ -502,9 +518,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
>  			if (nr < folio_nr_pages(folio)) {
>  				int err;
>
> -				if (folio_maybe_mapped_shared(folio))
> -					continue;
> -				if (pageout_anon_only_filter && !folio_test_anon(folio))
> +				if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
>  					continue;
>  				if (!folio_trylock(folio))
>  					continue;
> @@ -537,7 +551,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
>  		    folio_mapcount(folio) != folio_nr_pages(folio))
>  			continue;
>
> -		if (pageout_anon_only_filter && !folio_test_anon(folio))
> +		if (pageout_anon_only && !folio_test_anon(folio))
>  			continue;
>
>  		if (!pageout && pte_young(ptent)) {
> @@ -546,25 +560,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
>  			tlb_remove_tlb_entries(tlb, pte, nr, addr);
>  		}
>
> -		/*
> -		 * We are deactivating a folio for accelerating reclaiming.
> -		 * VM couldn't reclaim the folio unless we clear PG_young.
> -		 * As a side effect, it makes confuse idle-page tracking
> -		 * because they will miss recent referenced history.
> -		 */
> -		folio_clear_referenced(folio);
> -		folio_test_clear_young(folio);
> -		if (folio_test_active(folio))
> -			folio_set_workingset(folio);
> -		if (pageout) {
> -			if (folio_isolate_lru(folio)) {
> -				if (folio_test_unevictable(folio))
> -					folio_putback_lru(folio);
> -				else
> -					list_add(&folio->lru, &folio_list);
> -			}
> -		} else
> -			folio_deactivate(folio);
> +		madvise_lru_folio(folio, pageout, &folio_list);
>  	}
>
>  out:
> @@ -651,8 +647,8 @@ static long madvise_pageout(struct madvise_behavior *madv_behavior)
>  	 * owner nor write capable of the file. We allow private file mappings
>  	 * further to pageout dirty anon pages.
>  	 */
> -	if (!vma_is_anonymous(vma) && (!can_do_file_pageout(vma) &&
> -				(vma->vm_flags & VM_MAYSHARE)))
> +	if (!vma_is_anonymous(vma) && !can_do_file_pageout(vma) &&
> +	    (vma->vm_flags & VM_MAYSHARE))
>  		return 0;
>
>  	lru_add_drain();
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

