Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA4B8C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 17:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872BD6B0088; Sun, 30 Aug 2026 13:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823026B008A; Sun, 30 Aug 2026 13:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739A16B008C; Sun, 30 Aug 2026 13:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5275A6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 13:12:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6AB080318
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 17:12:10 +0000 (UTC)
X-FDA: 85158578820.29.0F339DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 38D83A0004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 17:12:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h21hGi/e";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788109929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXEYMGhp/cWNLlxplD0mdNJ/+9TNUXWP+5DukL3pdsE=;
	b=vhgcuEeDl6/1zVktnRHmvu/KGJdhaqA4lUXQ18nQoA5MqvTSMkl1Ga+CSgj+ZRCEWSlGu2
	Dvy6+YgcKLcY4SAmWSZ7ZompLAt3zwUFbqFbackwBYYNAK8wZk57hJLw8/JtPGR5XNOXf5
	6HtZYv/NRXRClqlZypW5sIG2EdstR9U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788109929;
	b=a9hr2KfT6Sx9HIeUsRHt4lafuFq9Gmyfy3wEtDomgt82WxYWvEm94dajHE6ywUmoylMvPf
	jqbHRUd3DwZ9ONsnU9pXtlz/3jvloQbKJTbOIZLIWjRsY+218YkL+8adrJFHP6qX75XSH0
	YooqCWCXDaIxLYQiJWX9u6iuz1Dyhus=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h21hGi/e";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C251600E2;
	Sun, 30 Aug 2026 17:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B231F000E9;
	Sun, 30 Aug 2026 17:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788109928;
	bh=cXEYMGhp/cWNLlxplD0mdNJ/+9TNUXWP+5DukL3pdsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h21hGi/eWGaMYfJasN6PgeKqwpL3ESnYWocFYrdo92xTbITJm46je2MsZm+3heunE
	 U3Gxrbilx4nHmGaePxOLgazMc83tpYTNOswgcfMNScDJnAiwBhVG0ccoj7pjRYorUJ
	 CN4nzpcziXPxt1cFrbe+sd1t5pdALdopH0f0I26IQTNIHvwQ40OJMShqa/6RGPjBnz
	 paxdsBlwzsCCsmJmgpVyrXK45UfWv2HoI3TDh1AFIQk//BsuW6GXHYwCI3hgViazl8
	 nS50tSy4LvZrr2jFLd7EFM8/Ez2rCpkdjfx/Ji4B3Wkk0XAYzeOaCGLLlKswxK0oAC
	 gr2exMCEeKM9Q==
From: SJ Park <sj@kernel.org>
To: Krishna Iyer <kiyer@crusoe.ai>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm/damon/paddr: support hugetlb folios in access monitoring
Date: Sun, 30 Aug 2026 10:12:00 -0700
Message-ID: <20260830171200.103425-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830051407.50008-4-kiyer@crusoe.ai>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 38D83A0004
X-Stat-Signature: wma7rzbq8bdiwrbce7jni4tone3ptf7k
X-HE-Tag: 1788109929-731740
X-HE-Meta: U2FsdGVkX1/9M9U9PkJlWDO0cJDyvHVzRt1IJQSPaFRV4n5DPhG6kxOYN9inJJ1gtk7MRNSIC3i4IpwNCuvAVuqTIvpJ7tqsyIHvAZ7Zhr+KYnITRjqzlywhjjaw5vZD+TNa2POJ48CU6Xe58y0BLUbeTpwqQMB+ZjferrZVZIKOmH8YcxaIHOLcqGddoqLkGVyQVMwFhENg07Sjn564ErZG1jbytpmWHlX4zcEyTHdTL3L6ketSacNiISSjhZoruJ0PkRiISOZjv79uyogGGQ8QvLc9lukA8+8I/aid++lTi41DjZI31N6SYygaeBHwaNx0r2b16jkJE+RPZQ5mtxljuX3P7EDOGx82Om2O6KYeEaM6W+rod8wfiv2VgaCbs4cJ3kAck2S3hixRkVaCTjMhfW2kV4L4WgDbB55P64gk7Vs1LyWjBVy1ngEfmn/diHKcl8OlGA8P2b8vXAF9/FpzzVT2ocUoei92GhlJ/Ze6OUIVAFio7aDZYvY9MLEHtqr7fFemN1on3X3OXlsDTFnd1qZwhdYeotDse9o9y5SKhJtVO8UhTBfZB2L6Zp/pRutHz0stU3AQqRDiomi5Aj6vwIoAHODECguwypkLPQf2+YfQaW6TovC3nFRvJFXqLZEBCpnR/OAjBMxu3QbNLFSr2BpgKk4usQFWfa8tE1imwjhL6+ebrc6+NcZeaT6veiFVE4kC6fJgaN2fS/1P1KcuLVyCWpdd8pUJEh6WTt55diBd3nZW+/YxqZFLsFhRL2BsYuxP4jD6J7uLjvwayFMw/0hZmZGOG5w8W6NAiHaYU4uBkAEAvMGugJiQ53i3qCvbjtPc0OwUV9HBLhqwrA1eUIBZALc8G6uHNsNURriLb5S2UBH02Nm1gFnSIWtSIRTOaCBZy9VKAYdusftXO+tIoWGl2wKbHtGLJ5Tl6GSQG/ZzFlRVfHa7UdPtdkDlh15MRCeVle/6aNkvX6a
 nD9el+Rc
 tuUUjS9O1l5s/MZaT9V077NlcWHs3fO2Bz14WmDFj5G9AW/NW7ADCEcHOUQS66O1b+ZNf8EZtC2x20n7s1pnY5GCs7QQM98ThSSqW+cxtleJnkvzVYDQTe1NSQ2aUYTXm2/1rk8ICfBPvRcd08Uog6AVe+cwNc40mda1Wae5by4omue2oWjPTVWSF73dkItId9RSQY9ODIkn6nZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Aug 2026 22:14:04 -0700 Krishna Iyer <kiyer@crusoe.ai> wrote:

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
> modules like DAMON_STAT observe only the host-side remainder (kernel,
> page cache, daemons)

DAMON can monitor accessses on page cache and user-space daemon memory.  But it
cannot monitor normal kernel memory, which is not LRU-managed.  Let's drop
'kernel' from the example.

> and report all guest working sets as permanently
> idle, defeating the purpose of host-level access monitoring.  In
> testing on a 1 TiB host, an hour of 4-thread random access over 842 GiB
> inside a guest was statistically indistinguishable from an idle host,
> while a 40x smaller host-side workload produced a quantitatively
> correct response.
> 
> Add damon_get_folio_incl_hugetlb(), which additionally accepts hugetlb
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

Thank you for keeping the DAMOS-side behavior unchanged.

However, incl_hugetlb() sounds too specific to me.  It will keep working for
monitoring purpose folios.  What about something more geeneric, say,
damon_get_monitor_folio()?

> 
> Note that the access check granularity for hugetlb-backed memory is the
> huge page size: one touched byte reports the whole (up to 1 GiB) page
> as accessed.  Also, DAMON now consumes secondary MMU young bits that
> KVM's own aging uses; at DAMON's sampling rate (one page per region per
> sampling interval) the interference is negligible.
> 
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
> ---
>  mm/damon/ops-common.c | 31 +++++++++++++++++++++++++++----
>  mm/damon/ops-common.h |  1 +
>  mm/damon/paddr.c      |  4 ++--
>  3 files changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 62004206ca31..ece101d34684 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -15,14 +15,20 @@
>  #include "../internal.h"
>  #include "ops-common.h"
>  
> +static bool damon_folio_observable(struct folio *folio, bool incl_hugetlb)
> +{
> +	return folio_test_lru(folio) ||
> +		(incl_hugetlb && folio_test_hugetlb(folio));
> +}

This is for not only monitoring but also for DAMOS.  What about changing the
name to be more generic, say, damon_folio_acceptable()?

And 'incl_hugetlb' could be more specific to the usage purpose.  E.g.,
'monitor'?

> +
>  /*
> - * Get an online page for a pfn if it's in the LRU list.  Otherwise, returns
> - * NULL.
> + * Get an online page for a pfn if it's in the LRU list, or a hugetlb folio if
> + * @incl_hugetlb is set.  Otherwise, returns NULL.
>   *
>   * The body of this function is stolen from the 'page_idle_get_folio()'.  We
>   * steal rather than reuse it because the code is quite simple.
>   */
> -struct folio *damon_get_folio(unsigned long pfn)
> +static struct folio *__damon_get_folio(unsigned long pfn, bool incl_hugetlb)

As I also mentioned above, I feel like incl_hugetlb is too case specific.
Could we rename it to somewhat like 'monitor' or 'damos'?

>  {
>  	struct page *page = pfn_to_online_page(pfn);
>  	struct folio *folio;
> @@ -33,13 +39,30 @@ struct folio *damon_get_folio(unsigned long pfn)
>  	folio = page_folio(page);
>  	if (!folio_try_get(folio))
>  		return NULL;
> -	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
> +	if (unlikely(page_folio(page) != folio) ||
> +			!damon_folio_observable(folio, incl_hugetlb)) {
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
> +struct folio *damon_get_folio_incl_hugetlb(unsigned long pfn)
> +{
> +	return __damon_get_folio(pfn, true);
> +}

As commented above, 'incl_hugetlb()' feels too case specific to me.  What about
damon_get_monitor_folio()?

> +
>  void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr)
>  {
>  	pte_t pteval = ptep_get(pte);
> diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
> index f7811c9c7a02..68d7de49c87a 100644
> --- a/mm/damon/ops-common.h
> +++ b/mm/damon/ops-common.h
> @@ -6,6 +6,7 @@
>  #include <linux/damon.h>
>  
>  struct folio *damon_get_folio(unsigned long pfn);
> +struct folio *damon_get_folio_incl_hugetlb(unsigned long pfn);
>  
>  void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr);
>  void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr);
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 5c6c3a597fd0..09d418b2874b 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -37,7 +37,7 @@ static unsigned long damon_pa_core_addr(
>  
>  static void damon_pa_mkold(phys_addr_t paddr)
>  {
> -	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
> +	struct folio *folio = damon_get_folio_incl_hugetlb(PHYS_PFN(paddr));
>  
>  	if (!folio)
>  		return;
> @@ -67,7 +67,7 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
>  
>  static bool damon_pa_young(phys_addr_t paddr)
>  {
> -	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
> +	struct folio *folio = damon_get_folio_incl_hugetlb(PHYS_PFN(paddr));
>  	bool accessed;
>  
>  	if (!folio)
> -- 
> 2.54.0

Other parts look good to me.


Thanks,
SJ

