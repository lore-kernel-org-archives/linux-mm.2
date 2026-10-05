Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F5CACA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD90D6B0088; Mon,  5 Oct 2026 04:18:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A236B008C; Mon,  5 Oct 2026 04:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78EC6B0092; Mon,  5 Oct 2026 04:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AD116B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:18:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1562E160181
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:18:02 +0000 (UTC)
X-FDA: 85287869604.16.AE808F3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A25A40008
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:17:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=j5knjFn1;
	spf=none (imf17.hostedemail.com: domain of BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791188280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuhGNh33RwpQYIAorkA2VvhjQZ6YMZLfJjskTBdQXyI=;
	b=hFZxpwibzs0uKB8ypVkkWC3tdeTQtmA30AnIbeEJcfwPo42jZQCzWxKOZ43ZzUweKEQol1
	rfrTACrK8sXYyQu5buIMwlJtOwy/f/vRe1r910bU4qb6IodqkGfa3wccCVZnP4/Cm2TdIY
	P9A0wzaQnRuVjZAihxwk6n2wrBd8PD0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791188280;
	b=OuqqKAY9an29lDgnTT+BDroZNjLV2MHZ0cMi4W2Cj8E22AH78Da36x86V0hCEeq5GeICam
	q9NmEBDM6Jjt/4s7oDi+hpYPzO0KECBsg74BQBVSnGXx6WIic5kLGEO+f74mvatbnQpF9m
	bgi61ZEBmV/ZkacY9zDHKNkX/SFovZU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=j5knjFn1;
	spf=none (imf17.hostedemail.com: domain of BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NuhGNh33RwpQYIAorkA2VvhjQZ6YMZLfJjskTBdQXyI=; b=j5knjFn1RaLQq9uuPmpU4+3fzU
	K1B4O6C+MlIn7MMaiUKEHpbjcCadAxow2q1BWjDX4yRIxpUtlNqI4G42kp5za1wmy/2Z11iuuSOqN
	aei2LDuZfL79O0HopoD6b0SjVBZSPRC6dZ79kH0ElBm+AoarvbwqDOXdhO8NYCxPJMWFeNlFVnP6v
	wdbSgiKumwwN7yyMAaoiaxUeC6XVVjIHwrhI2xPcq5+1HIpf/E9VbgqVEh7jj0UW7ds8+1i+8HLmm
	4xrg9h1+cLyqg4U9KKtPrkoYy+m4Yy64bzlA2vCYXstj9i1XD7/EWjPuczj8IWheuHY8PkmmLSXh+
	ZNGTf74A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDdtM-0000000Fra1-30eo;
	Mon, 05 Oct 2026 08:17:48 +0000
Date: Mon, 5 Oct 2026 01:17:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Andi Shyti <andi.shyti@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2] drm/i915: look up shmem folios by index for writeback
Message-ID: <asNdLJdbpkUVsQzU@infradead.org>
References: <20261004094827.174193-1-matthias.goergens@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004094827.174193-1-matthias.goergens@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2A25A40008
X-Stat-Signature: dqaas5p3ou3e51nuwdti1nfo1b7d3f14
X-Rspam-User: 
X-HE-Tag: 1791188279-268658
X-HE-Meta: U2FsdGVkX19FNu11yAmQtiSq6RcEZmtXtB6ECSjd46PoiEPj4FHoZZiH94L2IWReVg3N6vbuKsuyYvViC3vukKa9MR0L+ear/NSJ5Yx3Nv3Zp4iYgZocCqm8gj0mypzirZ8y9JNPSOTpaZHv3rFMbbOjAv+A4pptz8HsB2A6f2rlGGYR3blBYLh4x11y0uOHU4j4dIT1DtYDGebvDeYXWKVKXCHKaq7uTd7lasrAKmSgfL1yREHclV5jS10cJkhDGqN5QwnqE/hW0PEUKZAjIt6wRUZjdxSn5WqtH1g5DL6K10ap3AQDSl235dFG9cQbi1B7NqkkPc117zj1tdzAM6ayGlkLSwdO2oclJ/9KapHvHO4glyT1fZWZRVF3QyKtHDar8tvPy0XudczNPrKwbRmqADl5ulUHnGo/KzZjf2krgq7E6B8oswyb4cdu7yX5yTQL3DdfTGK4rQFLOmoAbn2UlxQBN77wfIAxRa6SeslvR9uChPFd71BkOOIZ7Qfcwh7n/V1oWa74wHzN4QDGH5eonmf3IQfZnqFvu+T+CmkOo6oh7N5/MqHPB3uKLDAyQLs37MUEIMn6xsSeU/hmDSmTPDpM/c/SvRpOUq+9Sz6fFO4ukBFjQoO1AiPOtgCNs2w2SPL5rTNnf+1UbHHmo1jNmyZ9z/kQEYWa3OkTJSfDHX0+y+JrcQrN/7Q8hhHL7bakzB2BbVpJ6UM20m8gHRDFE2PGsKKOpK+BE0pTgDRFMlRQ+eG7nzl5iPQV2GTKBDTQfD5WnvpsyQAS9HkjzLRtinZwotaexFD+uI7qgJQjDPMmBu+4SRzjlWF63uC/DTq3z1NZL1M85S9+d3IcpqLMtaG8OJoQnhtlVSq4eVb3Zmo9oSgPzwnpIOZ2y45MsxetbZ19qHnGyl7TDmIT4Lk8XZ8QZXJ/AU0OifZ4FxBTiPxQApl0UL/DnjLvZFg9wskbrJOzwdnpfim3IWU
 b0XE+W5O
 mbKKDgjjkyDr8W7kMllECok460dHgdkjUQzw7LAKfnKAAymvLBXv18Eb0ygJuL5DFFc0C1+TdYasX0uWC711wNSo4Hqqx88wKd66hZzdAl69hxql2CWHzadwlOVT76zN4wnglUu04OtTQMg5C2bX+qqEeqXYZJcFeOvT8mtJ/+sIQILI8Ed3YYBpI/jUvkfDaP7YFKzpaXrjR3k2U08qV0RJi9+mmw59pbAbyer0tNtrBI2KjrSSSx4O+2u+ikOWADiECA/uokkoZnXfSgTPmy0Kd5HBXTc3WQLfOXQHLKCPj+BgTsmM2/Q7SDCNZjGSOhR0b0nJn4AAepQU+kSvlfi7gvNIme80M1TXhmvCwrJh0BpAkbLNuPOmQPsMcxkJgRNdI8+4iCX4e6r2kqaKg3yx/f0I4Yb4mggskWEyOTzyVEdVtirwFXwOyQM7zmMS8JBR5+Q9DOLqZ/kTO8+Y47dyDdLOQNxC57Oko71IGKw3uW1oEau387YejgpkVAJYedk3/IQqkOE3cKqizGc7q44MVv4Y+1YreLQ7ls9CqGnpBqFdBd9sNiPIVOUtmB3+hmKZl+IK5RW/pOe/HdIx9uyPJ8oHtbIrSAUwmKcvBMXyZAXFxvePb7/7cVEZ8XrgOK5jKIolaMmh2UacyAv36BpKWr/scXVW6jEZ0xldIHtMj0vsQ9UhQZtNGKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As mentioned multiple times before, none of this code belongs into a
driver or anywhere outside of mm.  This has come up basically everytime
this got touched, and Matthew Brost said he was going to look into it.

This patch that adds even more mm magic in the driver really is a no-go
(as is ignoring the shmem and mm maintainers and lists).

Also if this was broken for a year and a half without anyone noticing,
I really wonder what the impact really is, but it really does not
sound like we should optimize for sketchy backports over the proper
fix.

On Sun, Oct 04, 2026 at 05:48:27PM +0800, Matthias Goergens wrote:
> Since commit 776a853a43c9 ("i915: Use writeback_iter()"),
> __shmem_writeback() starts writeback on no folios at all.  In
> WB_SYNC_NONE mode writeback_iter() only returns folios tagged
> PAGECACHE_TAG_DIRTY, and shmem never sets that tag: it dirties folios
> with noop_dirty_folio(), because shmem relies on LRU-based swap writeout
> rather than on the dirty tag (see the comment in __folio_mark_dirty() in
> mm/page-writeback.c).  The loop before that commit looked pages up by
> index and tested the page dirty flag, so it did write.
> 
> This affects the shrinker's I915_SHRINK_WRITEBACK pass and the i915 TTM
> backend, which both call __shmem_writeback().  The pages stay dirty and
> on the LRU, so reclaim still swaps them out later; what is lost is the
> early writeback.
> 
> Go back to looking up the folios of the object by index, in batches
> with filemap_get_folios(), and reschedule between batches, as
> writeback_iter() does.  Mapped folios are still skipped.  Unlike the old
> loop, do not wait for a folio lock, since this also runs from the OOM
> notifier; a locked folio is left to reclaim.  shmem_write_folio()
> returns with the folio unlocked except for AOP_WRITEPAGE_ACTIVATE, so
> unlock it only in that case.  It may also split a large folio and leave
> the rest of it dirty, so look the rest up again.
> 
> I came across this while measuring an earlier patch of mine to this
> loop, which changed nothing because the loop never visits a folio.
> This patch was measured without Intel hardware, with a test-only mock
> selftest in a QEMU guest with swap.  Dirty, unpinned objects of 1 to
> 256 MiB, with and without THP, went through i915_gem_shrink() with
> I915_SHRINK_WRITEBACK.  Before this patch, no page was written in any
> case; with it, every page that was not mmapped was, also when swap-out
> split the large folios.  The contents read back intact after swap-in,
> and the mock selftests give the same results as before.  This has not
> been tested on hardware.
> 
> Fixes: 776a853a43c9 ("i915: Use writeback_iter()")
> Cc: stable@vger.kernel.org # v6.16+
> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
> ---
> v1: https://lore.kernel.org/all/20261002073107.2209644-1-matthias.goergens@gmail.com/
> 
> Changes in v2:
> - Look the folios up in batches with filemap_get_folios() and call
>   cond_resched() between batches, instead of one __filemap_get_folio()
>   call per index with no rescheduling, which Sashiko pointed out:
>   https://lore.kernel.org/all/20261002091439.59C611F00899@smtp.kernel.org/
>   Measured with the same test-only harness in the same guest, v1 against
>   v2: on a fully populated 1 GiB object, the longest time the walk ran
>   without reaching cond_resched() went from about 85 ms to under 0.1 ms;
>   on a 3 GiB object (786432 pages) with 1% of its pages present and the
>   rest holes or swapped out, one call made 255 filemap_get_folios()
>   calls instead of 786432 __filemap_get_folio() calls.  A run of swap
>   entries is still stepped over inside a single filemap_get_folios()
>   call: about 2 ms for a fully swapped-out 3 GiB object.  I did not split
>   the range further, since every page of the object was in memory until
>   just before this runs, so holes and swap entries are the exception.
> - A batch is looked up ahead of the writes, so if writing splits a
>   large folio, look the rest of it up again (v1 got this by reading the
>   folio size after the write).
> 
> This replaces my two earlier patches to this loop, which can be dropped:
> the loop they change never visits a folio.
> 
> https://lore.kernel.org/all/20260915062924.2410550-1-matthias.goergens@gmail.com/
> https://lore.kernel.org/all/20260914105606.3997649-1-matthias.goergens@gmail.com/
> 
> In 6.18.y and 7.2.y, the maintained stable trees that have
> 776a853a43c9, the call is shmem_writeout(folio, NULL, NULL) instead of
> shmem_write_folio(folio), with the same return convention.
> 
> In review of 776a853a43c9, Christoph asked for this loop to move behind
> a shmem API instead of living in drivers, and Matthew agreed:
> 
> https://lore.kernel.org/all/Z--XtaM7Z3zbjzAu@infradead.org/
> https://lore.kernel.org/all/Z-_hQwNeiOnNYJVp@casper.infradead.org/
> 
> I kept this fix inside i915 so that it is one patch for stable.
> 
> The test harness is not part of the patch; I can post it if that helps.
> Testing on Intel hardware under memory pressure would be very welcome.
> 
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 70 ++++++++++++++++++-----
>  1 file changed, 57 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> index ef9440166295..d2077b823b1b 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -304,28 +304,72 @@ shmem_truncate(struct drm_i915_gem_object *obj)
>  	return 0;
>  }
>  
> +/* Start writing a locked folio to swap.  It is unlocked on return. */
> +static void shmem_writeback_folio(struct folio *folio)
> +{
> +	int ret;
> +
> +	folio_set_reclaim(folio);
> +	ret = shmem_write_folio(folio);
> +	if (!folio_test_writeback(folio))
> +		folio_clear_reclaim(folio);
> +
> +	/* shmem_write_folio() unlocks the folio unless it returns this. */
> +	if (ret == AOP_WRITEPAGE_ACTIVATE)
> +		folio_unlock(folio);
> +}
> +
>  void __shmem_writeback(size_t size, struct address_space *mapping)
>  {
> -	struct writeback_control wbc = {
> -		.sync_mode = WB_SYNC_NONE,
> -		.nr_to_write = SWAP_CLUSTER_MAX,
> -		.range_start = 0,
> -		.range_end = LLONG_MAX,
> -	};
> -	struct folio *folio = NULL;
> -	int error = 0;
> +	pgoff_t last = (size >> PAGE_SHIFT) - 1;	/* last page, inclusive */
> +	struct folio_batch fbatch;
> +	pgoff_t index = 0;
> +	unsigned int i;
>  
>  	/*
> +	 * shmem marks folios dirty with noop_dirty_folio(), which does not
> +	 * set PAGECACHE_TAG_DIRTY, so writeback_iter() would find none of
> +	 * them.  Look up the folios of the object in batches and write out
> +	 * the dirty ones.
> +	 *
>  	 * Leave mmapings intact (GTT will have been revoked on unbinding,
>  	 * leaving only CPU mmapings around) and add those folios to the LRU
>  	 * instead of invoking writeback so they are aged and paged out
>  	 * as normal.
>  	 */
> -	while ((folio = writeback_iter(mapping, &wbc, folio, &error))) {
> -		if (folio_mapped(folio))
> -			folio_redirty_for_writepage(&wbc, folio);
> -		else
> -			error = shmem_write_folio(folio);
> +	folio_batch_init(&fbatch);
> +	while (filemap_get_folios(mapping, &index, last, &fbatch)) {
> +		for (i = 0; i < folio_batch_count(&fbatch); i++) {
> +			struct folio *folio = fbatch.folios[i];
> +			long nr_pages = folio_nr_pages(folio);
> +
> +			/*
> +			 * Leave locked folios to reclaim: this runs from the
> +			 * shrinker and the OOM notifier, so do not wait for a
> +			 * lock.
> +			 */
> +			if (!folio_trylock(folio))
> +				continue;
> +
> +			if (folio->mapping != mapping || folio_mapped(folio) ||
> +			    !folio_clear_dirty_for_io(folio)) {
> +				folio_unlock(folio);
> +				continue;
> +			}
> +
> +			shmem_writeback_folio(folio);
> +
> +			/*
> +			 * Writing may have split the folio and left the rest
> +			 * of it dirty; look the rest up again.
> +			 */
> +			if (folio_nr_pages(folio) != nr_pages) {
> +				index = folio_next_index(folio);
> +				break;
> +			}
> +		}
> +		folio_batch_release(&fbatch);
> +		cond_resched();
>  	}
>  }
>  
> 
> base-commit: ce1e0223d8ad4211275c82a17ed6d43ab81e13d9
> -- 
> 2.56.0
> 
---end quoted text---

