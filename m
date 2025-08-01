Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DD7C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 19:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83A996B007B; Fri,  1 Aug 2025 15:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB986B0089; Fri,  1 Aug 2025 15:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700E86B008A; Fri,  1 Aug 2025 15:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 604296B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:58:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7438B8270
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:58:02 +0000 (UTC)
X-FDA: 83729249604.24.B7824C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 49D75180005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:58:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bLjlUGbR;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754078281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzPgwqY3y6pBcHoAtzAgp1evz/IsYZ5M7IMBVPgZNcQ=;
	b=XePgPVtvGfPmQtXEnk0TjUgt1mm5RrH6vJ+uH8AXL/6jifuZSsZS7Xaizid9A8/Il5T1pp
	ZQguAsMzxcZKzpOs1Z9CSIaNepPMUGH/mmD0Uvf4LxS0WzgHktxWLRXkd3SKhRcleX61Co
	WAQ/UENLbdUGj5bWsQf9i7OUYyX37I4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754078281; a=rsa-sha256;
	cv=none;
	b=pMRgig+dfUPLIyGN/+NhVs8Ps+mGf5jhhZfZE4+EoygROOTJefKVujTGg4LS/yx6TFa2rt
	t8nBMdUmwDlKpYt9Kh+y+JF1CsJR6MYhX9OkdYZ2xXAaFxHdltDaAMnKT8BJu+feqodmQC
	8DpSmF3q0YqEEX9/M8gylT3pfLZ4o58=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bLjlUGbR;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 787FD61130;
	Fri,  1 Aug 2025 19:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6336C4CEF4;
	Fri,  1 Aug 2025 19:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754078280;
	bh=tUEYr3HZyXjC24pkcxwmm2u2X5diq/zyBh0xRAimDJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLjlUGbRDq+Ne0c/edVOLhD+pSlZxu5jCJKXP+FmnAkAmUzVkgi5bXyB/SsKO7S5x
	 qz8uwOQsPEOAmhzXVKRIYT6SncnqduoPkjJC9N+SihafN7HOYyhGsCSIBp76xgPVUA
	 8j0D88z9/2BDT8xU6TIbtTQpiVCiI2X/A7MXz62fJoZOA07nM3wMrPlqct+DLT4xBc
	 XIynfZFssWNeZtVOUKMyLbMn+NnjQnXn5eYqQ/YLNAFJNIxUYqcT1Bhv88n7XcfeAh
	 PurPB4AEgxBf/XB1dm76xfVH9iatPCxXp3gO8nHnfrOkuVQtoaMtzuEjj6D7fvUCE3
	 HoikNGPOxnNcA==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Takero Funaki <flintglass@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/zswap: store compression failed page as-is
Date: Fri,  1 Aug 2025 12:57:57 -0700
Message-Id: <20250801195757.1384-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731172009.108025-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49D75180005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: dq3wy4xj6pp7agi8gwn4axgs8f8pwj5h
X-HE-Tag: 1754078281-78401
X-HE-Meta: U2FsdGVkX1/XCenZ9lzyIOigdtQCRrIo9l2BhV7REvgy1JMnDcO5xPBn00omdHu09wyYU9QM4IJoCbSVIrX8bcB8mN/QSjEomuXIc2a361krNazNMvjBkAUHrCKxcOFWsOMKpQ15yqnnBcIlRyUiFtI8SOfOT10wgJAgDUINh5MwCqTEna8XcxVZsBNIk9+rfuN1EGCulvoRILj1226hw2FtU67XWhhzRf9/KNnoI9VQg2v7G7VvRPBmNDG+RN2t0LGq7KvVaVBdzZLBsodqvDaCZiUJJFiJ79s3uKNIk1x/37HuE9NM+N8q05dRXpskjQrc2kX8W/lO+EA6C8d19Y+hoN3HxqFmnbLFVGzvITwn2Su/Z1dttewevTmucDtlX0NHbLRa8lABZpi75VnNAiAojDzoAFshYTkXy2lhO3Nhx1ELrS/pr2ReSozXzg26twp/zJxzFmoaCk0AZr0WylJXvf5qlZ7xKTpmH2UeloVOeEAt3vs4w9LZz+HbzS9qvzGl6n0zRB5JL0Y1KEHE8ADq1WJU18A3lRqcw91TjwdBy9aZOlrWoBdtGeRNPTHtBskGE7zqvCO4ljOh2rr+5Vy1l80zebcIhH1QIeV/LamvUe8LE2aZikP9oXuLfNp09/TkU2jGFQKVlJYrvu0Bz9hA9EaFfH1tT8UWdhXAMFj94HtoRXLG8iqsrwquUm5IiqzpIZWGZh9j31WD09OgbQRVIVYwOAmc6Z8ZyDkpDDQZVXfWUVWNlgRM50SGINjBNbCr02vcxhk2oJ+BwtyWsdI4RQi2SpaSqAKgvCMN9bMjoMyNReTINBub4nQxU/FX0B9LJhT26bdwTVL2eytXklYiC87XAK0dbUhTxCJU0N+7enm4tKRrDe8K9FNghR3RGlDYi0g16reEf0yLhlpHpjmNcQa4Rh++YLfqNw7CIOAqDfxtZOhBLy0ind2a3d3JQ2RpwwTF1jbzTmxknNq
 r6/YwGJX
 TRJfGJ0apjgtErpdN3aPiLP2IlxVc+iWcVgIYVgH3Jvt6bY1tRb5ulltNIFSoHCYOA3ItPOk7m0ThdsLoPX3u4/vNv1UtCpHWCCP7g+uh2bVXoqsyGmi2ndBMpkOZIfBZVeDL04PTLfpsq6bDy6khC1Z0lycSecoD7dVWyifNzMA2kJDO8ZMj480Ii5QAtCrtYmbvoB2Wxg+Tcf4IUuPE4txRZbuKIV9DLOJMw+kMw1xNy+Gw2235b+u7hM9kk4CR58cIg4gFSruxs6YEapc2bf37u06VaSv2lAaqP7KEML1Kbaf5+DXsaZAd3ZHrHT8jbJKfNm5AnnRi8uA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 31 Jul 2025 10:20:05 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Wed, 30 Jul 2025 16:40:59 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> Hi SJ, thank you for your patch! This is a really cool idea : -)
> 
> > When zswap writeback is enabled and it fails compressing a given page,
> > zswap lets the page be swapped out to the backing swap device.  This
> > behavior breaks the zswap's writeback LRU order, and hence users can
> > experience unexpected latency spikes.
> > 
> > Keep the LRU order by storing the original content in zswap as-is.  The
> > original content is saved in a dynamically allocated page size buffer,
> > and the pointer to the buffer is kept in zswap_entry, on the space for
> > zswap_entry->pool.  Whether the space is used for the original content
> > or zpool is identified by 'zswap_entry->length == PAGE_SIZE'.
> > 
> > This avoids increasing per zswap entry metadata overhead.  But as the
> > number of incompressible pages increases, zswap metadata overhead is
> > proportionally increased.  The overhead should not be problematic in
> > usual cases, since the zswap metadata for single zswap entry is much
> > smaller than PAGE_SIZE, and in common zswap use cases there should be
> > sufficient amount of compressible pages.  Also it can be mitigated by
> > the zswap writeback.
> 
> I think one other benefit that is worth mentioning here is that by moving
> the incompressible pages to the zswap LRU, we prevent wasting CPU cycles
> on pages that have not changed since their last compression attempt.

Thank you for adding this.  But, isn't this only for writeback-disabled case?

If writeback is enabled and an incompressible page is tried to be zswapped-out,
a compression of it is tried and failed, and the page is swapped out to disk.
The compression will be tried again later only if it is accessed, swapped in,
and then again tried to be zswapped-out.

After this patch, a compression is tried and failed, the page is kept in
memory, linked on zswap's LRU list.  And the compression will be tried again
later, if it is accessed, zswapped in, and then again tried to be zswapped-out.

So in terms of number of compression attempts, this patch is not making a
direct difference, to my understanding.  The correct LRU order _might_ make
some indirect help in some complicated scenarios, though, but I wouldn't dare
to claim that.

Am I missing something?

> 
> This concern is a real concern that we have seen manifest as wasted cycles
> in zswap wasted on trying to compress the same pages over and over again,
> and failing each time. This is also made worse by the fact that wasted CPU
> cycles are bad, but even worse when we are reclaiming and must free up memory!
> 
> > When the memory pressure comes from memcg's memory.high and zswap
> > writeback is set to be triggered for that, however, the penalty_jiffies
> > sleep could degrade the performance.  Add a parameter, namely
> > 'save_incompressible_pages', to turn the feature on/off as users want.
> > It is turned off by default.
> > 
> > When the writeback is just disabled, the additional overhead could be
> > problematic.  For the case, keep the behavior that just returns the
> > failure and let swap_writeout() puts the page back to the active LRU
> > list in the case.  It is known to be suboptimal when the incompressible
> > pages are cold, since the incompressible pages will continuously be
> > tried to be zswapped out, and burn CPU cycles for compression attempts
> > that will anyway fails.  But that's out of the scope of this patch.
> 
> Indeed, and your patch fixes this problem, at least for the writeback
> enabled case!

Again, I don't think this patch is really fixing it unless I'm missing
something.

> 
> [...snip...]
> 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  mm/zswap.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 65 insertions(+), 8 deletions(-)
> > 
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 7e02c760955f..e021865696c6 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -45,6 +45,9 @@
> >  /* The number of compressed pages currently stored in zswap */
> >  atomic_long_t zswap_stored_pages = ATOMIC_LONG_INIT(0);
> >  
> > +/* The number of uncompressed pages currently stored in zswap */
> > +atomic_long_t zswap_stored_uncompressed_pages = ATOMIC_LONG_INIT(0);
> > +
> >  /*
> >   * The statistics below are not protected from concurrent access for
> >   * performance reasons so they may not be a 100% accurate.  However,
> > @@ -129,6 +132,11 @@ static bool zswap_shrinker_enabled = IS_ENABLED(
> >  		CONFIG_ZSWAP_SHRINKER_DEFAULT_ON);
> >  module_param_named(shrinker_enabled, zswap_shrinker_enabled, bool, 0644);
> >  
> > +/* Store incompressible pages as is */
> > +static bool zswap_save_incompressible_pages;
> > +module_param_named(save_incompressible_pages, zswap_save_incompressible_pages,
> > +		bool, 0644);
> > +
> >  bool zswap_is_enabled(void)
> >  {
> >  	return zswap_enabled;
> > @@ -190,7 +198,8 @@ static struct shrinker *zswap_shrinker;
> >   *              writeback logic. The entry is only reclaimed by the writeback
> >   *              logic if referenced is unset. See comments in the shrinker
> >   *              section for context.
> > - * pool - the zswap_pool the entry's data is in
> > + * orig_data - uncompressed original data of the page, if length is PAGE_SIZE
> > + * pool - the zswap_pool the entry's data is in, if length is not PAGE_SIZE
> >   * handle - zpool allocation handle that stores the compressed page data
> >   * objcg - the obj_cgroup that the compressed memory is charged to
> >   * lru - handle to the pool's lru used to evict pages.
> > @@ -199,7 +208,10 @@ struct zswap_entry {
> >  	swp_entry_t swpentry;
> >  	unsigned int length;
> >  	bool referenced;
> > -	struct zswap_pool *pool;
> > +	union {
> > +		void *orig_data;
> > +		struct zswap_pool *pool;
> > +	};
> >  	unsigned long handle;
> >  	struct obj_cgroup *objcg;
> >  	struct list_head lru;
> > @@ -500,7 +512,7 @@ unsigned long zswap_total_pages(void)
> >  		total += zpool_get_total_pages(pool->zpool);
> >  	rcu_read_unlock();
> >  
> > -	return total;
> > +	return total + atomic_long_read(&zswap_stored_uncompressed_pages);
> >  }
> >  
> >  static bool zswap_check_limits(void)
> > @@ -805,8 +817,13 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
> >  static void zswap_entry_free(struct zswap_entry *entry)
> >  {
> >  	zswap_lru_del(&zswap_list_lru, entry);
> > -	zpool_free(entry->pool->zpool, entry->handle);
> > -	zswap_pool_put(entry->pool);
> > +	if (entry->length == PAGE_SIZE) {
> > +		kfree(entry->orig_data);
> > +		atomic_long_dec(&zswap_stored_uncompressed_pages);
> > +	} else {
> > +		zpool_free(entry->pool->zpool, entry->handle);
> > +		zswap_pool_put(entry->pool);
> > +	}
> >  	if (entry->objcg) {
> >  		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
> >  		obj_cgroup_put(entry->objcg);
> > @@ -937,6 +954,36 @@ static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
> >  	mutex_unlock(&acomp_ctx->mutex);
> >  }
> >  
> > +/*
> > + * If the compression is failed, try saving the content as is without
> > + * compression, to keep the LRU order.  This can increase memory overhead from
> > + * metadata, but in common zswap use cases where there are sufficient amount of
> > + * compressible pages, the overhead should be not ciritical, and can be
> 
> 					      NIT: s/ciritical/critical/?

Thank you for finding this!

> 
> > + * mitigated by the writeback.  Also, the decompression overhead is optimized.
> > + *
> > + * When the writeback is disabled, however, the additional overhead could be
> > + * problematic.  For the case, just return the failure.  swap_writeout() will
> 
> 					           NIT: s/  / /?

I was intentionally adding two spaces between paragraphs.  I find a few other
comments on zswap.c file are also using the convention...?

> 
> [...snip...]
> 
> And I think Nhat and Johannes have covered the other concerns.
> 
> Thanks again SJ for working on this, I hope you have a great day!

Thank you, I appreciate your review!  Also, happy Friday!


Thanks,
SJ

[...]

