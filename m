Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A66C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42646B009A; Thu,  7 Aug 2025 14:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2026B009D; Thu,  7 Aug 2025 14:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0896B00D0; Thu,  7 Aug 2025 14:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC816B009A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:16:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66B67BD182
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:16:23 +0000 (UTC)
X-FDA: 83750766246.04.AF87E0D
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf01.hostedemail.com (Postfix) with ESMTP id C4B084001A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:16:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZzMn77k2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754590581; a=rsa-sha256;
	cv=none;
	b=cCmJfLov0FBcNhUYhZkwj1wBwAbiGBOTi3xtaK32qANQqH2OXgxvmyQ05YsYmdhoGNpNdc
	x20J/l7aMS4lzUXqVCXzOndFdESKD1WAvntoTGpG+7pu4O/ZQ+STd913I36baoXsrb2W77
	TxV8L9T0Qb6uJVJNdSxv10fnIwMpW2Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZzMn77k2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754590581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fuqRlDbTna01MqlNvWVW93g+JqstLemjZjkgu63QJ4g=;
	b=YgUTpP6JSAw/SbZyVakHUoay34ke5Vtd8+dj3kUCi5YrKHzGovCX9SL2C6xFmnjRA4k+R6
	IGbViRr4l2aenvH+kX8w0IDuacpjGnyoXD/0F+topDdEy5dbAbmCPDt+LvSdGziMah3CI2
	3LRVe6X8PXQ+rXKL0mKIRGPsNHCZIDo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 10C3CA566AC;
	Thu,  7 Aug 2025 18:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B93C4CEEB;
	Thu,  7 Aug 2025 18:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754590580;
	bh=JoQgC6zNM11H86q8TF9fAO+e/aCVUyMLSqBJpfu95H8=;
	h=From:To:Cc:Subject:Date:From;
	b=ZzMn77k2ksIyI9xlWR9kEvK2b2tFCP8Q8Qm6WSHyBjRVPBTvl6TWkvl/9usnCXYtc
	 acHPXKErc8Ka+AN+P1sk7Vd83JAGhfPeFjpJ1WyyNiWUpnry/meTX+u0T6RmaJEZqJ
	 uw50R2P3OZ8q3Zyk4gXi/P9wdVQXjoWk+dO5zgC5C3pgvJaeUrkCvrARoUUZcIBsZk
	 mdfgweslTJhSkU69YvSQ7BVMlg0zvTnI49RbDhl5IUMD0/A8jOlKz8IFRsYnyIzIYw
	 sys4H/Do/fhgbgQUrOotwoP3KgY0Gdrt0lwSMF9wFpunwCb10tHTav24TzhesUeROV
	 bM1bydVaxB/Gw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>
Subject: [PATCH] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Thu,  7 Aug 2025 11:16:16 -0700
Message-Id: <20250807181616.1895-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4B084001A
X-Stat-Signature: b9yxyck57u7h85c4eo7m7jr637qoy1db
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754590581-802042
X-HE-Meta: U2FsdGVkX1+NGBkssLfUlkONGMXOPjJ9ImDOt4EuXCJSH86iF+L1JVJeWbddocd0K1Dw6QSz7Fjn9uuNWViwwWdDtkrAfYm27GRXm4Df0t0Q3Slb49f8MD5htzUDSDgueIhuXZNQpRpMflBGQre6QzxcUsVxmd43YWmHu7hiN5yMKlhDqmLWh3KpopqP+knnd4xH4E44Qoe7Yiyo52nnb8fEk/Rm+q7vJhG+PI+BlQq+DmJyzdCeJisKm9QHqUZedfofrGYgUphwHc4keOv6OpU9s/1uHA0bXPdOKBXsWSfL24sIY8zk1drHjtbpElLOfZn2yRpROV+xJYTHmZvBZcpQiRzqF+G6QOuQ8W3W9/Yaa4dKHUGr2t0/yPxup+gNw6V1LZYw3WpxiOn/heeYYnX/VqT4G8aRiS7FoZKoUJPn+Jj8lzY5CJXpJBnAWfRXwoiVPqH+Tgu5WTlU4LO2emmUmHXteUPbzQfvGjU4vTKf3/tJ/pQG/jjxiQUQFOQFR0dJVTfBNkbbiR4O7V/in22K1i1O1NMP9rNkOtpaSf83WYOMBKgneK1dzeQQMGjOOfs1RHfUlr/0aqZ0BUn1jTuUzaxAFQHlAUfV1NznpFkk3Y3LexCT19pEEOCosm50rWvYaZ/GK3rqOPzBcCEl09YUNdPhJ/+HkE+0ssox5PvDqmfksPM3t/Te1YBUAaDMr817JKigKCgari6yqlrouC4p4GpkHjkHosjqXWdhlGvGcbG2ejHBfa2fkj0EpdAZ2setgAOz72BpGIRGlwCnN+eA1A26RTJx8SULYW52ftgtGfeHneHfFPTj3SN6UWk7YEzDWA0JUISb33I3h9/OCVg/NZip6AaHnmihiZ6LhHbE7Buj96QsZrI2ZGSWdY6zmBcIZyWGs3FbAXzlKqyW5z1O0XYusPjxOONYJniIhH70VnPkpDIUwBeQkqZAu7+0knwHJN6LzD9wreOIiL5
 vtLChguq
 FZL64IkHb+0wzJ9iB31OnaUwQHiFbULUmfU216WW3gISuLsPospoFNiA7e0w7bsz7y8XblS92xHZeV5IJxAVCloVRzYXuvhyWiEiEQuBDdQrZ3iRgsFBqkCW/ahXbq0hfiKoAYG+fZQZWvdl8I50D+WZtEXhVzX5ti0RktW1ON/a7ct7ncCSmV31Pneo0qboqwohbgl9V671XCgKF/+NCt/U+Jp7/mSXj37X/XMdN2whoGKw6gqE9kUzS35cw1irTB19ykpJa4SnCWBHuPOISsHdsCuVvvlPR/A70hsH1FUBIaAMUW1740EQ75uLCizqrl540
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When zswap writeback is enabled and it fails compressing a given page,
the page is swapped out to the backing swap device.  This behavior
breaks the zswap's writeback LRU order, and hence users can experience
unexpected latency spikes.  If the page is compressed without failure,
but results in a size of PAGE_SIZE, the LRU order is kept, but the
decompression overhead for loading the page back on the later access is
unnecessary.

Keep the LRU order and optimize unnecessary decompression overheads in
those cases, by storing the original content as-is in zpool.  The length
field of zswap_entry will be set appropriately, as PAGE_SIZE,  Hence
whether it is saved as-is or not (whether decompression is unnecessary)
is identified by 'zswap_entry->length == PAGE_SIZE'.

Because the uncompressed data is saved in zpool, same to the compressed
ones, this introduces no change in terms of memory management including
movability and migratability of involved pages.

This change is also not increasing per zswap entry metadata overhead.
But as the number of incompressible pages increases, total zswap
metadata overhead is proportionally increased.  The overhead should not
be problematic in usual cases, since the zswap metadata for single zswap
entry is much smaller than PAGE_SIZE, and in common zswap use cases
there should be a sufficient amount of compressible pages.  Also it can
be mitigated by the zswap writeback.

When the writeback is disabled, the additional overhead could be
problematic.  For the case, keep the current behavior that just returns
the failure and let swap_writeout() put the page back to the active LRU
list in the case.  It is known to be suboptimal when the incompressible
pages are cold, since the incompressible pages will continuously be
tried to be zswapped out, and burn CPU cycles for compression attempts
that will anyway fails.  One imaginable solution for the problem is
reusing the swapped-out page and its struct page to store in the zswap
pool.  But that's out of the scope of this patch.

Tests
-----

I tested this patch using a simple self-written microbenchmark that is
available at GitHub[1].  You can reproduce the test I did by executing
run_tests.sh of the repo on your system.  Note that the repo's
documentation is not good as of this writing, so you may need to read
and use the code.

The basic test scenario is simple.  Run a test program making artificial
accesses to memory having artificial content under memory.high-set
memory limit and measure how many accesses were made in given time.

The test program repeatedly and randomly access three anonymous memory
regions.  The regions are all 500 MiB size, and accessed in the same
probability.  Two of those are filled up with a simple content that can
easily be compressed, while the remaining one is filled up with a
content that read from /dev/urandom, which is easy to fail at
compressing to <PAGE_SIZE size.  The program runs for two minutes and
prints out the number of accesses made every five seconds.

The test script runs the program under below seven configurations.

- 0: memory.high is set to 2 GiB, zswap is disabled.
- 1-1: memory.high is set to 1350 MiB, zswap is disabled.
- 1-2: On 1-1, zswap is enabled without this patch.
- 1-3: On 1-2, this patch is applied.

For all zswap enabled case, zswap shrinker is enabled.

Configuration '0' is for showing the original memory performance.
Configurations 1-1, 1-2 and 1-3 are for showing the performance of swap,
zswap, and this patch under a level of memory pressure (~10% of working
set).

Because the per-5 seconds performance is not very reliable, I measured
the average of that for the last one minute period of the test program
run.  I also measured a few vmstat counters including zswpin, zswpout,
zswpwb, pswpin and pswpout during the test runs.

The measurement results are as below.  To save space, I show performance
numbers that are normalized to that of the configuration '0' (no memory
pressure), only.  The averaged accesses per 5 seconds of configuration
'0' was 36493417.75.

    config            0       1-1     1-2      1-3
    perf_normalized   1.0000  0.0057  0.0235   0.0367
    perf_stdev_ratio  0.0582  0.0652  0.0167   0.0346
    zswpin            0       0       3548424  1999335
    zswpout           0       0       3588817  2361689
    zswpwb            0       0       10214    340270
    pswpin            0       485806  772038   340967
    pswpout           0       649543  144773   340270

'perf_normalized' is the performance metric, normalized to that of
configuration '0' (no pressure).  'perf_stdev_ratio' is the standard
deviation of the averaged data points, as a ratio to the averaged metric
value.  For example, configuration '0' performance was showing 5.8%
stdev.  Configurations 1-1 and 1-3 were having about 6.5% and 6.1%
stdev.  Also the results were highly variable between multiple runs.  So
this result is not very stable but just showing ball park figures.
Please keep this in your mind when reading these results.

Under about 10% of working set memory pressure, the performance was
dropped to about 0.57% of no-pressure one, when the normal swap is used
(1-1).  Note that ~10% working set pressure is already extreme, at least
on this test setup.  No one would desire system setups that can degrade
performance to 0.57% of the best case.

By turning zswap on (1-2), the performance was improved about 4x,
resulting in about 2.35% of no-pressure one.  Because of the
incompressible pages in the third memory region, a significant amount of
(non-zswap) swap I/O operations were made, though.

By applying this patch (1-3), about 56% performance improvement was
made, resulting in about 3.67% of no-pressure one.  Reduced pswpin of
1-3 compared to 1-2 let us see where this improvement came from.

Related Works
-------------

This is not an entirely new attempt.  Nhat Pham and Takero Funaki tried
very similar approaches in October 2023[2] and April 2024[3],
respectively.  The two approaches didn't get merged mainly due to the
metadata overhead concern.  I described why I think that shouldn't be a
problem for this change, which is automatically disabled when writeback
is disabled, at the beginning of this changelog.

This patch is not particularly different from those, and actually built
upon those.  I wrote this from scratch again, though.  Hence adding
Suggested-by tags for them.  Actually Nhat first suggested this to me
offlist.

[1] https://github.com/sjp38/eval_zswap/blob/master/run.sh
[2] https://lore.kernel.org/20231017003519.1426574-3-nphamcs@gmail.com
[3] https://lore.kernel.org/20240706022523.1104080-6-flintglass@gmail.com

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Takero Funaki <flintglass@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC v2
(https://lore.kernel.org/20250805002954.1496-1-sj@kernel.org)
- Fix race conditions at decompressed pages identification.
- Remove the parameter and make saving as-is the default behavior.
- Open-code main changes.
- Clarify there is no memory management changes on the cover letter.
- Remove 20% pressure case from test results, since it is arguably too
  extreme and only adds confusion.
- Drop RFC tag.

Changes from RFC v1
(https://lore.kernel.org/20250730234059.4603-1-sj@kernel.org)
- Consider PAGE_SIZE compression successes as failures.
- Use zpool for storing incompressible pages.
- Test with zswap shrinker enabled.
- Wordsmith changelog and comments.
- Add documentation of save_incompressible_pages parameter.

 mm/zswap.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 3c0fd8a13718..2db2da130ec4 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -976,8 +976,25 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 */
 	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
 	dlen = acomp_ctx->req->dlen;
-	if (comp_ret)
-		goto unlock;
+
+	/*
+	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
+	 * save the content as is without a compression, to keep the LRU order
+	 * of writebacks.  If writeback is disabled, reject the page since it
+	 * only adds metadata overhead.  swap_writeout() will put the page back
+	 * to the active LRU list in the case.
+	 */
+	if (comp_ret || dlen >= PAGE_SIZE) {
+		if (mem_cgroup_zswap_writeback_enabled(
+					folio_memcg(page_folio(page)))) {
+			comp_ret = 0;
+			dlen = PAGE_SIZE;
+			memcpy_from_page(dst, page, 0, dlen);
+		} else {
+			comp_ret = comp_ret ? : -EINVAL;
+			goto unlock;
+		}
+	}
 
 	zpool = pool->zpool;
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
@@ -1012,6 +1029,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
 	obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffer);
 
+	/* zswap entries of PAGE_SIZE are not compressed. */
+	if (entry->length == PAGE_SIZE) {
+		memcpy_to_folio(folio, 0, obj, entry->length);
+		zpool_obj_read_end(zpool, entry->handle, obj);
+		acomp_ctx_put_unlock(acomp_ctx);
+		return true;
+	}
+
 	/*
 	 * zpool_obj_read_begin() might return a kmap address of highmem when
 	 * acomp_ctx->buffer is not used.  However, sg_init_one() does not

base-commit: 2ec534125ae474292175ae198483c545eac2161d
-- 
2.39.5

