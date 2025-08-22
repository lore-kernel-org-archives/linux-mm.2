Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D60CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8698E0002; Fri, 22 Aug 2025 15:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90258E0001; Fri, 22 Aug 2025 15:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCCD08E0002; Fri, 22 Aug 2025 15:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B8A648E0001
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:08:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6509AC0319
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:08:23 +0000 (UTC)
X-FDA: 83805329286.03.32ED580
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id CC43C40008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:08:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UzVGswKW;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755889701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=U6lwBV3yKqft213MEAtOAvp/xzvEyIjshWQCuGSX2vI=;
	b=vriyvJhsWra+UgnPb+dMPpquZpzFM0opG/RgUgPfeCD0POin18DYQarZ0EtKYfJ2CuMdFI
	HTVYQubL6cIJlRrD72Hrzu+VNkWnjgK3saRTxWEEjVzRrk37F9uccrG0JpkjapII4Zgn4/
	0RVwSZZOMCI164GuhrOfpGSxzzUmgVc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UzVGswKW;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755889701; a=rsa-sha256;
	cv=none;
	b=gGRXgutQvM+ZS4iA4twFl7CdB6NiDntNFihGAVgEppybH6ZsboMsPo0kNqdOTNY38V/Gh7
	Ftz0mk5t/xaPWPv7sqzUxiSYc8nm3P16WE3lBkzNc4LLyWuLPQZJzpIzvIaDDWPRdqUlSc
	O+Z+NoIfZLQCf89j8EgKUTLBy9P1pPI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E26C1601E7;
	Fri, 22 Aug 2025 19:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651E8C4CEED;
	Fri, 22 Aug 2025 19:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755889700;
	bh=2tGcS2IEAoH/Pq57hMCe7/BIUfhX1/hcBcom+GnUW40=;
	h=From:To:Cc:Subject:Date:From;
	b=UzVGswKW4ePnVmoW+se/wiehGew8PrTCgYx/j1YCVvKliZ+ZoTSiWRNXWgAz74QmZ
	 bJ1jx0k0/7y/J4BCOYYfyfKJRC5B+eSbmMKbd/KpZbluUsI6eV5kdzgeDreoRKS/jy
	 EuVJP8nHhes/iLBVz227eZZ/Yvp/WTOEOWAmke3VOUxzMzHXZf054Hhr7BEvqHfAn2
	 CBoFAEycS0a5WgyDWxSivyPC2OxOXx2fbkIMgrRFTRScA12TcVNiEAutg+4dmJx3u/
	 Tn80tPKe6P1P+gSugpjEnLFjJDgGwpogJoR1xPi9pM5z4OCej8fngdQRRLYCxxo7Jn
	 XiZxJl/qGK2iA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v5] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Fri, 22 Aug 2025 12:08:17 -0700
Message-Id: <20250822190817.49287-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CC43C40008
X-Rspam-User: 
X-Stat-Signature: uepscp7qtiaxeii18jdoshsip5s8ngmg
X-Rspamd-Server: rspam09
X-HE-Tag: 1755889701-462938
X-HE-Meta: U2FsdGVkX1/x+ix6m3g1nLeVd3q6JqjkUrHRR5TVQwCGB6qpZbZLilGGbpi3nkuqVyBcHNT/bBM6AOIxt0IS2XAhfO0+IWLDUCEEIecKsfgFf3TZXWqFamylu9oNXzeWyiOrVPxSmRH5vmMblJq05BEctlettjpeY7eeeka0amsADAmMV/eGA/J75zc+femnLL9zQc58GWNSob/QwKggmL0KeRSuBQnFCzyDFyju4VZKU1InK7D3347DX/wdsthnTs4mRUrYfRHF7UExkzRmjcKTFSfU2VI8VwDnXN6dYXH1afKRVELZHf1Lo7+FNBPfGqxDKZpLbzH49pZjC3agNdzG0GJW/HnaRJVUeP+/iwcFN6pR3P9pF4DPctgXlBne9DO9JzEkos6t+BwE10JdZva1E7Nr/SVLTNLBbzUo5Ed/4L/C/EPCkAV0PkrcCLQ3KsfghRrCaQlPnUK3xXqWA9QEzNDvURM5NThUjigPaSx/BeLSgx9R1f2npjHYf5HXgn3JkRTeOCci6FmSVjEErOP1dnCHrLauP/57C816QQ+JQyEwvsWy4wMOr3U2MQDpRCLmukMq+Cln/Gm400C8hBpIHQAEWuwCDgkKbo/yioPK5q485mXYYFbC+Vh3qaFYJ2HR7koM0uMzMvMmeHpK8Qua+jQPIyU6wvuydMeQOnKr5ZSYTjY5AS8w3mPIufDtBAO5DhqsKHOFWP/77BqzKCt3iO82LkhyAg0+1cied+rJ95uaONnHrq58hKVzsjDEnpYzDBQbDCkFN9ehjJTJ1taWfIR5HO3GupgleN4p6J8EbUeJ/4gkcn5VI1oBwm2rqP5gPVRdKqlNTWUYzztZNDVHWGOaD1z0x1/za95a7lGH0HT5xewpM/kmYqknHlZlSbUGdXFjHoTxO8ziyFM5fGWAL1Z50Uy9uHKj4z5U3ueVEsMwG3WtNGPtiCjeeL7ZZFcvTTImN1ys4muh29B
 jCRxtnqR
 rIxfWAHBJSXX4I8VJ+kaMwcL1cB26XkdqlSXH7+VzhKfzijMb8bk4aFWS3pzsffJfK/Zw2jqVilfkB/8TlCHEIt2zcuqItz7EebXDC2aTyRO18ppDZvo3Dt4Lit6fyi+WsLPnqrDipszW8XYfWYbmzRTlG3j32ml+N3r0DJEETdaOUj9U1r8mCFox92rJqRvPEToco00t64aGESVClNJ7ISd49EwxmhM6LxCkPSN3VgeLoUJP4wPSCkNrl59OWH3rENanB1n53MHWQx+hRQlM7EHzN113+8i6Euysv59s69a+lAUwsHF0T/oEw17KGLfZ9F7qnxaDxrTTse6Es+egmYCzSVcq8VIDSo5SRF+dMzA0N04tvNO7snWX2b685mwy3K0navOSQtz8VeSBDQF5T8kPHh95gLMaMG8PuH6pTEEriHNew4Z44/YS614kDq7gg3JSDfp6wWg3jpoWaQsSM+thJ1JwwafHn8NrFqeDc8rLlYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When zswap writeback is enabled and it fails compressing a given page, the
page is swapped out to the backing swap device.  This behavior breaks the
zswap's writeback LRU order, and hence users can experience unexpected
latency spikes.  If the page is compressed without failure, but results in
a size of PAGE_SIZE, the LRU order is kept, but the decompression overhead
for loading the page back on the later access is unnecessary.

Keep the LRU order and optimize unnecessary decompression overheads in
those cases, by storing the original content as-is in zpool.  The length
field of zswap_entry will be set appropriately, as PAGE_SIZE.  Hence
whether it is saved as-is or not (whether decompression is unnecessary) is
identified by 'zswap_entry->length == PAGE_SIZE'.

Because the uncompressed data is saved in zpool, same to the compressed
ones, this introduces no change in terms of memory management including
movability and migratability of involved pages.

This change is also not increasing per zswap entry metadata overhead.  But
as the number of incompressible pages increases, total zswap metadata
overhead is proportionally increased.  The overhead should not be
problematic in usual cases, since the zswap metadata for single zswap
entry is much smaller than PAGE_SIZE, and in common zswap use cases there
should be a sufficient amount of compressible pages.  Also it can be
mitigated by the zswap writeback.

When the writeback is disabled, the additional overhead could be
problematic.  For the case, keep the current behavior that just returns
the failure and let swap_writeout() put the page back to the active LRU
list in the case.

Knowing how many incompressible pages are stored at the given moment
will be useful for future investigations.  Add a new debugfs file called
stored_incompressible_pages for the purpose.

Tests
-----

I tested this patch using a simple self-written microbenchmark that is
available at GitHub[1].  You can reproduce the test I did by executing
run_tests.sh of the repo on your system.  Note that the repo's
documentation is not good as of this writing, so you may need to read and
use the code.

The basic test scenario is simple.  Run a test program making artificial
accesses to memory having artificial content under memory.high-set memory
limit and measure how many accesses were made in a given time.

The test program repeatedly and randomly access three anonymous memory
regions.  The regions are all 500 MiB size, and be accessed in the same
probability.  Two of those are filled up with a simple content that can
easily be compressed, while the remaining one is filled up with a content
that s read from /dev/urandom, which is easy to fail at compressing to a
size smaller than PAGE_SIZE.  The program runs for two minutes and prints
out the number of accesses made every five seconds.

The test script runs the program under below four configurations.

- 0: memory.high is set to 2 GiB, zswap is disabled.
- 1-1: memory.high is set to 1350 MiB, zswap is disabled.
- 1-2: On 1-1, zswap is enabled without this patch.
- 1-3: On 1-2, this patch is applied.

For all zswap enabled cases, zswap shrinker is enabled.

Configuration '0' is for showing the original memory performance.
Configurations 1-1, 1-2 and 1-3 are for showing the performance of swap,
zswap, and this patch under a level of memory pressure (~10% of working
set).  Configurations 0 and 1-1 are not the main focus of this patch, but
I'm adding those since their results transparently show how far this
microbenchmark test is from the real world.

Because the per-5 seconds performance is not very reliable, I measured the
average of that for the last one minute period of the test program run.  I
also measured a few vmstat counters including zswpin, zswpout, zswpwb,
pswpin and pswpout during the test runs.

The measurement results are as below.  To save space, I show performance
numbers that are normalized to that of the configuration '0' (no memory
pressure).  The averaged accesses per 5 seconds of configuration '0' was
36493417.75.

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
value.  For example, configuration '0' performance was showing 5.8% stdev.
Configurations 1-1 and 1-3 were having about 6.5% and 6.1% stdev.  Also
the results were highly variable between multiple runs.  So this result is
not very stable but just showing ball park figures.  Please keep this in
your mind when reading these results.

Under about 10% of working set memory pressure, the performance was
dropped to about 0.57% of no-pressure one, when the normal swap is used
(1-1).  Note that ~10% working set pressure is already extreme, at least
on this test setup.  No one would desire system setups that can degrade
performance to 0.57% of the best case.

By turning zswap on (1-2), the performance was improved about 4x,
resulting in about 2.35% of no-pressure one.  Because of the
incompressible pages in the third memory region, a significant amount of
(non-zswap) swap I/O operations were made, though.

By applying this patch (1-3), about 56% performance improvement was made,
resulting in about 3.67% of no-pressure one.  Reduced pswpin of 1-3
compared to 1-2 let us see where this improvement came from.

Tests without Zswap Shrinker
----------------------------

Zswap shrinker is not enabled by default, so I ran the above test after
disabling zswap shrinker.  The results are as below.

    config            0       1-1     1-2      1-3
    perf_normalized   1.0000  0.0056  0.0185   0.0260
    perf_stdev_ratio  0.0467  0.0348  0.1832   0.3387
    zswpin            0       0       2506765  6049078
    zswpout           0       0       2534357  6115426
    zswpwb            0       0       0        0
    pswpin            0       463694  472978   0
    pswpout           0       686227  612149   0

The overall normalized performance of the different configs are very
similar to those of zswap shrinker enabled case.  By adding the memory
pressure, the performance was dropped to 0.56% of the original one.  By
enabling zswap without zswap shrinker, the performance was increased to
1.85% of the original one.  By applying this patch on it, the performance
was further increased to 2.6% of the original one.

Even though zswap shrinker is disabled, 1-2 shows high numbers of pswpin
and pswpout because the incompressible pages are directly swapped out.  In
the case of 1-3, it shows zero pswpin and pswpout since it saves
incompressible pages in the memory, and shows higher performance.

Note that the performance of 1-2 and 1-3 varies pretty much.  Standard
deviation of the performance for 1-2 was about 18.32% of the performance,
while that for 1-3 was about 33.87%.  Because zswap shrinker is disabled
and the memory pressure is induced by memory.high, the workload got
penalty_jiffies sleeps, and this resulted in the unstabilized performance.

Related Works
-------------

This is not an entirely new attempt.  Nhat Pham and Takero Funaki tried
very similar approaches in October 2023[2] and April 2024[3],
respectively.  The two approaches didn't get merged mainly due to the
metadata overhead concern.  I described why I think that shouldn't be a
problem for this change, which is automatically disabled when writeback is
disabled, at the beginning of this changelog.

This patch is not particularly different from those, and actually built
upon those.  I wrote this from scratch again, though.  Hence adding
Suggested-by tags for them.  Actually Nhat first suggested this to me
offlist.

Historically, writeback disabling was introduced partially as a way to
solve the LRU order issue.  Yosry pointed out[4] this is still suboptimal
when the incompressible pages are cold, since the incompressible pages
will continuously be tried to be zswapped out, and burn CPU cycles for
compression attempts that will anyway fail.  One imaginable solution for
the problem is reusing the swapped-out page and its struct page to store
in the zswap pool.  But that's out of the scope of this patch.

[1] https://github.com/sjp38/eval_zswap/blob/master/run.sh
[2] https://lore.kernel.org/20231017003519.1426574-3-nphamcs@gmail.com
[3] https://lore.kernel.org/20240706022523.1104080-6-flintglass@gmail.com
[4] https://lore.kernel.org/CAJD7tkZXS-UJVAFfvxJ0nNgTzWBiqepPYA4hEozi01_qktkitg@mail.gmail.com

Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Takero Funaki <flintglass@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
Changes from v4
(https://lore.kernel.org/20250819193404.46680-1-sj@kernel.org)
- Mark stored_incompressible_pages as static.
- Restore reject_compress_poor code path.
- Remove crypto_compress_fail debugfs file.

Changes from v3
(https://lore.kernel.org/20250815213020.89327-1-sj@kernel.org)
(discussions for changes from v3 were made on v2 thread)
- Drop the cumulated compression failure counter (compress_fail).
- Add a cumulated crypto-failure only counter (crypto_compress_fail).
- Add a not cumulated stored incompressible pages counter
  (stored_incompressible_pages).
- Cleanup compression failure handling code for readability.

Changes from v2
(https://lore.kernel.org/20250812170046.56468-1-sj@kernel.org)
- No code change bug changelog updates
  - Add zswap shrinker disabled case test results.
  - Fix a typo on changelog.
  - Add a clarification of intention of 0 and 1-1 test configs.

Changes from v1
(https://lore.kernel.org/20250807181616.1895-1-sj@kernel.org)
- Optimize out memcpy() per incompressible page saving, using
  k[un]map_local().
- Add a debugfs file for counting compression failures.
- Use a clear form of a ternary operation.
- Add the history of writeback disabling with a link.
- Wordsmith comments.

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

 mm/zswap.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 678caa981fc3..f865a930dc88 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -42,8 +42,10 @@
 /*********************************
 * statistics
 **********************************/
-/* The number of compressed pages currently stored in zswap */
+/* The number of pages currently stored in zswap */
 atomic_long_t zswap_stored_pages = ATOMIC_LONG_INIT(0);
+/* The number of incompressible pages currently stored in zswap */
+static atomic_long_t zswap_stored_incompressible_pages = ATOMIC_LONG_INIT(0);
 
 /*
  * The statistics below are not protected from concurrent access for
@@ -811,6 +813,8 @@ static void zswap_entry_free(struct zswap_entry *entry)
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
 		obj_cgroup_put(entry->objcg);
 	}
+	if (entry->length == PAGE_SIZE)
+		atomic_long_dec(&zswap_stored_incompressible_pages);
 	zswap_entry_cache_free(entry);
 	atomic_long_dec(&zswap_stored_pages);
 }
@@ -971,8 +975,26 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
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
+	if (comp_ret || !dlen)
+		dlen = PAGE_SIZE;
+	if (dlen >= PAGE_SIZE) {
+		if (!mem_cgroup_zswap_writeback_enabled(
+					folio_memcg(page_folio(page)))) {
+			comp_ret = comp_ret ? comp_ret : -EINVAL;
+			goto unlock;
+		}
+		comp_ret = 0;
+		dlen = PAGE_SIZE;
+		dst = kmap_local_page(page);
+	}
 
 	zpool = pool->zpool;
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
@@ -985,6 +1007,8 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	entry->length = dlen;
 
 unlock:
+	if (dst != acomp_ctx->buffer)
+		kunmap_local(dst);
 	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
 		zswap_reject_compress_poor++;
 	else if (comp_ret)
@@ -1007,6 +1031,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
 	obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffer);
 
+	/* zswap entries of length PAGE_SIZE are not compressed. */
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
@@ -1519,6 +1551,8 @@ static bool zswap_store_page(struct page *page,
 		obj_cgroup_charge_zswap(objcg, entry->length);
 	}
 	atomic_long_inc(&zswap_stored_pages);
+	if (entry->length == PAGE_SIZE)
+		atomic_long_inc(&zswap_stored_incompressible_pages);
 
 	/*
 	 * We finish initializing the entry while it's already in xarray.
@@ -1787,6 +1821,14 @@ static int debugfs_get_stored_pages(void *data, u64 *val)
 }
 DEFINE_DEBUGFS_ATTRIBUTE(stored_pages_fops, debugfs_get_stored_pages, NULL, "%llu\n");
 
+static int debugfs_get_stored_incompressible_pages(void *data, u64 *val)
+{
+	*val = atomic_long_read(&zswap_stored_incompressible_pages);
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(stored_incompressible_pages_fops,
+		debugfs_get_stored_incompressible_pages, NULL, "%llu\n");
+
 static int zswap_debugfs_init(void)
 {
 	if (!debugfs_initialized())
@@ -1814,6 +1856,9 @@ static int zswap_debugfs_init(void)
 			    zswap_debugfs_root, NULL, &total_size_fops);
 	debugfs_create_file("stored_pages", 0444,
 			    zswap_debugfs_root, NULL, &stored_pages_fops);
+	debugfs_create_file("stored_incompressible_pages", 0444,
+			    zswap_debugfs_root, NULL,
+			    &stored_incompressible_pages_fops);
 
 	return 0;
 }

base-commit: 5c2375777435b4378bf05f57ffae72d8a3be011f
-- 
2.39.5

