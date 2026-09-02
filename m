Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B696C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6886B0088; Wed,  2 Sep 2026 01:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1682E6B008A; Wed,  2 Sep 2026 01:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FE76B008C; Wed,  2 Sep 2026 01:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB9E86B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:17:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E03DA076B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:17:44 +0000 (UTC)
X-FDA: 85167664848.24.D3D7536
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id AC2EAC000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:17:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MUysMIxO;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788326262;
	b=mevkiihXAzpIh2HqaZWSBA7Kc5SMHklGH9ExgHflxjelxTuUyVgHxXyR3CUN4sA8ew7SJM
	asfm/4JaOoH2WgXCae/gFF6X0QKk/3ucqHdzr4CU43+ljrLrrEqMFFttZ+z5IrB9Wm4QMq
	SLPFRJxviLys8ESRg/y+u2i2bXZwlsc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MUysMIxO;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788326262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+TLw6zL3vSpm7FMUBCdrBPYkyQicKr+Z+UYAKZ2UXqY=;
	b=kPdpArESDY264dLBGTs8XqOO6Nosvu9iMsM5XzaVF6n98TITOthfrFDdOFKZbATs2FGhMa
	ksfqxp3Jfx+dyqUBhzxsP1VarWqzMygMPsAS8gEDJ3fFUzK74iOSEWN/WdtuPkJDcHQU4x
	auRqovdEXiOQ6sp1LIroWFnaApqJXbw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07F7042DA0;
	Wed,  2 Sep 2026 05:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E971F000E9;
	Wed,  2 Sep 2026 05:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788326260;
	bh=+TLw6zL3vSpm7FMUBCdrBPYkyQicKr+Z+UYAKZ2UXqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MUysMIxOFdJR6EZRow/6+Cl39Xl2LEN0yNLkWLnRXkEOOdLa2//96Sg6VXGgF1YPp
	 owk4idofXqDJZcwdAc0kqziDnsJUsS23WOX4iHSsVfiIALkxEUVMABYRhBgoFx9Tb6
	 vqmnONDU2FzllyP2lUrB0iONj8NUTqZgyevsfDjEopSEIp8ZpqbqaEY6L2fXEihRS2
	 BBd17IgyN3XVCpIdll4JgF+22S9ZHjwlEvXNjpB4NHy97HnSZDRr0fFhz1IvvGsr1i
	 TIiQzce8/+uWjGS8hmRez0SgyiJSBZyQTY5rZYQCnTDux8RzgL2fvwGKRIFzuLPTcK
	 eRwwQYrLHJ/PA==
From: SJ Park <sj@kernel.org>
To: Krishna Iyer <kiyer@crusoe.ai>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/damon/paddr: support hugetlb folios in access monitoring
Date: Tue,  1 Sep 2026 22:17:32 -0700
Message-ID: <20260902051732.90094-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902025700.17975-4-kiyer@crusoe.ai>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m18ehtbwt48sfj3xm5xy8dyw4fnnh68f
X-Rspamd-Queue-Id: AC2EAC000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1788326262-834102
X-HE-Meta: U2FsdGVkX196SpLu0HKf+0zs6LsAy/ERvhPWEqNvu1b8hJbkJz8zlxWrsdmnozO6oMUtC4kMabqqBHP7cUuvZdvODnUQwAyqfUKQu7yNT0CvviXKSJV/SKqyDCSDjua8Qwt+kTai/wS543LA4LwYiixGDBIsbHGLdm03JBPOhqghw2YT49vhXey0S5QfeQt3xEloJQhdEph0FfOP+ATDUmSO+XFe6LWEAqbl1WWXIibJhqqa2KKYiKYX2gW/WuOO8q98YA5UEkQNhyit3bVAI+VEz3uKzqlldHl6dKtPY+qyB9iA1gf5T5HeekB/+MHHzgs40rpCe8fy3OzOlZx+QKd1uFTgjuigUMt6hZxR2QPalQLaHAIsh14hWtWIuPQB98RqycgeigI2Q8F2qvwlHXljiG9zmgWf3iDF8ercHuSiozlEcAR9eWjV43QPRjsMB4VcPUgiPXk86P+BYeqNZ5qv/sv9+MkpwUUeiYlI7/NQiutaIQYaAzphl1M54jgRKZmr7nKN3WEV2Nzx4FT36aS8weBdwx+j4Pemg4+roVhsFNhRusC6YuThJEAwuzgNPD4rZX9yAOK6jc+3V+jHXuj37INKL6LMwhQBp1n+cfZXe5S22t9b9+cOPwnTclcHlOI75I20wq9z+uUiOwy+QIe36LvcJcHLJRa8xY1OeKct+qdBAdW1PA6FBzbY3bjYzWnoWv5O7sWMnlAfhROXglYiNsMoylDOGUEOHcGb67XF+VoMqQtMJkk/ZQo7QWsR8EjLaMkfZhSv719eK6fLprYTxIDGc8EWvqa+yisBPNlFwdNZ9sZLZyVWsqt1YIhXwxtkh3o3VTRCHwIazgReb1zVwJbrC3yzs4hWe2Q+z96Y94BcqOUGfF6qmg+4LCdERFUJYZ49HkFJOuojHsBbWd93IPYnM99VBCqNK0zkX8NYZp+eU2RqtecXwxkfcQJrpfhfWfEhavjpuozjbT0
 QHsvzOtI
 9v5jbTuh5Bon1iEOu2qF0SOM7TgNxWqTu4kaZwQ+CpNcCfXqH5s2/ukLCOnITQe1ele5Ekrpbs5Bbmpc23ga8jyJGcRPAergrKl7zsvrSFUguKC++ErWiMsoZlV8cK7KqJuXwqYpxD8SFwlsd0bwcEkQ5yygzkE/JW7A0R+Kg/+hNNOmNdQy8a6Vocz+rDmdUC3dUN7zRh/4MMbseHPD+x08HzhEkNbt2RDAkX1ZDzaxTcgs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 19:57:00 -0700 Krishna Iyer <kiyer@crusoe.ai> wrote:

> DAMON's physical address space monitoring is blind to hugetlb-backed
> memory.  Every access check starts at damon_get_folio(), which rejects
> folios that are not on the LRU lists.  Hugetlb folios are managed
> outside of the LRU by design, so every sampling attempt on
> hugetlb-backed memory silently fails and the pages are reported as
> never accessed.
> 
> This is a significant blind spot on virtualization hosts.  Cloud
> hypervisor hosts commonly back guest memory with 1 GiB hugetlbfs pages,
> covering the vast majority of the machine's memory.  On such hosts,
> modules like DAMON_STAT observe only the host-side remainder (page
> cache, daemons) and report all guest working sets as permanently
> idle, defeating the purpose of host-level access monitoring.  In
> testing on a 1 TiB host, an hour of 4-thread random access over 842 GiB
> inside a guest was statistically indistinguishable from an idle host,
> while a 40x smaller host-side workload produced a quantitatively
> correct response.
> 
> Add damon_get_monitor_folio(), which additionally accepts hugetlb
> folios, and use it in the two paddr access monitoring primitives,
> damon_pa_mkold() and damon_pa_young().  With the previous commit
> teaching the folio-granular rmap walkers to age huge PTEs and to call
> the mmu notifiers spanning the whole huge page, this makes guest
> accesses visible through secondary MMU (e.g. KVM/EPT) young bits.
> 
> Free hugetlb pool folios have a zero refcount, so folio_try_get()
> naturally keeps rejecting them.
> 
> The DAMOS action appliers (damon_pa_pageout(),
> damon_pa_mark_accessed_or_deactivate(), damon_pa_migrate(),
> damon_pa_stat()) keep using damon_get_folio(): reclaim, LRU
> manipulation and migration cannot act on hugetlb folios, so their
> behavior is unchanged.
> 
> Note that the access check granularity for hugetlb-backed memory is the
> huge page size: one touched byte reports the whole (up to 1 GiB) page
> as accessed.  Also, DAMON now consumes secondary MMU young bits that
> KVM's own aging uses; at DAMON's sampling rate (one page per region per
> sampling interval) the interference is negligible.
> 
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>

Assuming you agree to below suggestion,

Reviewed-by: SJ Park <sj@kernel.org>

> ---
>  mm/damon/ops-common.c | 31 +++++++++++++++++++++++++++----
>  mm/damon/ops-common.h |  1 +
>  mm/damon/paddr.c      |  4 ++--
>  3 files changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 373b25db5950..80207b56c6fd 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -15,14 +15,20 @@
>  #include "../internal.h"
>  #include "ops-common.h"
>  
> +static bool damon_folio_acceptable(struct folio *folio, bool monitor)
> +{
> +	return folio_test_lru(folio) ||
> +		(monitor && folio_test_hugetlb(folio));
> +}
> +
>  /*
> - * Get an online page for a pfn if it's in the LRU list.  Otherwise, returns
> - * NULL.
> + * Get an online page for a pfn if it's in the LRU list, or a hugetlb folio if
> + * @monitor is set.  Otherwise, returns NULL.
>   *
>   * The body of this function is stolen from the 'page_idle_get_folio()'.  We
>   * steal rather than reuse it because the code is quite simple.
>   */
> -struct folio *damon_get_folio(unsigned long pfn)
> +static struct folio *__damon_get_folio(unsigned long pfn, bool monitor)
>  {
>  	struct page *page = pfn_to_online_page(pfn);
>  	struct folio *folio;
> @@ -33,13 +39,30 @@ struct folio *damon_get_folio(unsigned long pfn)
>  	folio = page_folio(page);
>  	if (!folio_try_get(folio))
>  		return NULL;
> -	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
> +	if (unlikely(page_folio(page) != folio) ||
> +			!damon_folio_acceptable(folio, monitor)) {
>  		folio_put(folio);
>  		folio = NULL;
>  	}
>  	return folio;
>  }
>  
> +struct folio *damon_get_folio(unsigned long pfn)
> +{
> +	return __damon_get_folio(pfn, false);
> +}
> +
> +/*
> + * Same to damon_get_folio(), but also accepts hugetlb folios, which are
> + * managed outside of the LRU lists.  Aimed to be used by access monitoring
> + * primitives.  DAMOS actions that assume LRU-managed folios should keep using
> + * damon_get_folio().
> + */
> +struct folio *damon_get_monitor_folio(unsigned long pfn)
> +{
> +	return __damon_get_folio(pfn, true);
> +}

The comment looks bit verbose and feel more like commit message to me.  I'd
suggest to drop the comment for now.  Because it is a very trivial change, I
will do so when I pick this into my tree, and later repost with the change for
mm.git merge.  Please let me know if it doesn't work for you.

> +
>  void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr)
>  {
>  	pte_t pteval = ptep_get(pte);
> diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
> index f7811c9c7a02..172f0f17c4a8 100644
> --- a/mm/damon/ops-common.h
> +++ b/mm/damon/ops-common.h
> @@ -6,6 +6,7 @@
>  #include <linux/damon.h>
>  
>  struct folio *damon_get_folio(unsigned long pfn);
> +struct folio *damon_get_monitor_folio(unsigned long pfn);
>  
>  void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr);
>  void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr);
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 5c6c3a597fd0..ed7b7f31291a 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -37,7 +37,7 @@ static unsigned long damon_pa_core_addr(
>  
>  static void damon_pa_mkold(phys_addr_t paddr)
>  {
> -	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
> +	struct folio *folio = damon_get_monitor_folio(PHYS_PFN(paddr));
>  
>  	if (!folio)
>  		return;
> @@ -67,7 +67,7 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
>  
>  static bool damon_pa_young(phys_addr_t paddr)
>  {
> -	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
> +	struct folio *folio = damon_get_monitor_folio(PHYS_PFN(paddr));
>  	bool accessed;
>  
>  	if (!folio)
> -- 
> 2.54.0


Thanks,
SJ

