Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A95CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F4E900007; Tue, 12 Aug 2025 13:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35688E0168; Tue, 12 Aug 2025 13:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71DD900007; Tue, 12 Aug 2025 13:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C42EA8E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:00:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76A991D3CD3
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:00:52 +0000 (UTC)
X-FDA: 83768719944.07.DC5C4F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C0A79C0012
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:00:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dRC6Og15;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755018051; a=rsa-sha256;
	cv=none;
	b=KuqQfROGceIC2JhAm9b6sbSJyvJow6LsSMUHHJlmKDQaXG8y2ZB+oqOGVRQQnJT3JGPO1n
	rypWO0s+OPgP57lvwmtE+h4TopapduFA2fDg1pPiJnE6lQX+21INMh97WgJyEvl41kpF22
	+Ly4hiKiyPj0FkJ7TO7U28+9r9XQ4PE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dRC6Og15;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755018051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9th4jFMUv0elsK6qLNG9Z1L3NbxInYjeD5vDlcryDaU=;
	b=RBvAeO+Om8Q7kl8EAH8Fn0tvFP2uQqCUUZBSvlOMukhlvT5Ue1d5DjXf1eEF78Fo0WUMCO
	zOIINWpnqweAJ6ldAc/FK75Jedf9Lhmvkz2CBFY2pVqFqQQ3kf943PKGxZR59sl9abobbl
	Lap8d4OIf8qMOglF0N3M0QbWmxVyPu4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65E0844A48;
	Tue, 12 Aug 2025 17:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF7BC4CEF0;
	Tue, 12 Aug 2025 17:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755018049;
	bh=dCWS2gXVwz/JvpJ3uTvsq+5QknRMo+7y7mpGSKtV/Uk=;
	h=From:To:Cc:Subject:Date:From;
	b=dRC6Og15dp+Yif66krceFfRwsNS+6ngVlVK8LjCwFgQ1tdOWjsk5WNFU8vVSf6QyF
	 WnGNCEDjkkWc5xwW8ybD6MfNr8/lCNUya4mIBFNA+4lDLMNve5Hp7X/0Y9Rif+qYEu
	 9j3janwVtv7hG4jmMuIcuktGUIvmK/w4jeGv6Oy9Cu0Aa0odxgnH+P71XznEZ3fD1S
	 0Go0l2o7CJivzgq1Z1SF7O2Slatk7XYb7OP/81NpVT7AFG/oQn1Y80SgJawMN+e4UQ
	 +WF+mcSwon7vczDYPcKU770aPHc8AjDEVFovzofe6n8x1ZyuYV1CXb/CZZsghJjso5
	 aYrIN4HUzuibA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>
Subject: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Tue, 12 Aug 2025 10:00:46 -0700
Message-Id: <20250812170046.56468-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C0A79C0012
X-Stat-Signature: 9b4kkqg14g8g7by3wym5pdjkwjaoi8h3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1755018050-13831
X-HE-Meta: U2FsdGVkX19oJIzM/3gTxPpKCdvdVvJveHyi1YW3S096b/QnOCADQZ3tcdVSRDktBsS5Y71k9KoFoWt9XplJfZgdkpCHg4o1A0i3u590duDPo3fF6FwTUzQcxymm0AkhCy428Yd5e1QTG6ibfWSP98wGqJN72pTwmi6/s5+PC3dQEGXXTc68Li9nfUEtODIevkHO0PS9GE3bdBqFuGqJLb6Y7hPI2cDfJTiYm/kO6p/0cibp6Xd8tKK1ljLd6aeCSBsJuFjmeRc7b+VxAEPRf/KBYjJdYC1mPxHLnEbCqsZ1M+J2/MLnk8LaZyUTCmP67mNMEqu7UPkCyIceJXgv3rTH88YyL/lzZAj9FuzFildT5fnr5WeQFJxu3OV2JwXezQV9VTcb6bpYRUzyIwMgcdMFTFX9PMpbstctlHkQ7j4nNmNiw9U4M6xhF9Ke9de6L51aH1HgfxIWYnCgoGoGY8al1xFlAtTZVAW2Ed3oar5PLzJt/xtHwIBljhcsmiB/VYB9GUx1/BeGZshaK2K15jiCPxoeBtsULQdVC+QXBtZ0TrRpn8gIyyXZ7Xz4qQ0QeWZ16bfe8L5kekxmozFw4nA07EhjR7c/BbdrnAxksnA3peeJjtPKfXrdYMBE8cZeSnMjCKk7FxkekTPa/lS/h90rrcFSIeY+hkieRjlkAD9A3teUNWpHy45oz82jpjofYJwG5mAemMHEUjaljqEoCMo8egIU8KDu/DYpELBi7/q0FRasd7fmRZfrz6H8PJ+H7KXiOgN6iRouHa8Aha67ram9rAXnOfYoKvSe+Yy/Y607bUZNMFX4LI0phwPbGR155MyXr9sxObtwUFAxkMIQXjYXZ5+6pBJ4vFtA7bcJma79un6Nedf4EH87dO3HWZzVLGaP0aqmUSGLwzX0FFPcGKHGp7iIaqloag0wiKQYjyqePzpNDSnNouOyue/2LElJz+LUCdjR4RGwBezS5oJ
 K83dXO0f
 +n/h31uvRkOGkiQBWcMKQv7o0sbkTEayFHHteGfFNHfcKvBSk94LaYNrWCfgyHumvTCMo84Zl8r5/hZAN2dRWPsTFtdwIM4R1LPphi919azEHzaCfSzwDQkZrIntL5DK7KNSRAxkUOnRy0jXDKt2PFMvPZgLCXDkPqLZM26GA0Ucd8PD1c2hIvt0yHRTA3a+ix5fXRLjQIfQgw4gogPQJmGE3gsB7d9KB69G+4lUSaoXiGVsUiAebPLW0nV//3+LPnulivudV+Y1Db3Tx8wCeST3HnE2QPw29Oz5DzYXXpKR3t2ggcRoR55jJ8Ywf0WeSp3pLFgcis7JjF2c=
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
list in the case.

Knowing how many compression failures happened will be useful for future
investigations.  investigations.  Add a new debugfs file, compress_fail,
for the purpose.

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

For all zswap enabled cases, zswap shrinker is enabled.

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

Historically, writeback disabling was introduced partially as a way to
solve the LRU order issue.  Yosry pointed out[4] this is still
suboptimal when the incompressible pages are cold, since the
incompressible pages will continuously be tried to be zswapped out, and
burn CPU cycles for compression attempts that will anyway fail.  One
imaginable solution for the problem is reusing the swapped-out page and
its struct page to store in the zswap pool.  But that's out of the scope
of this patch.

[1] https://github.com/sjp38/eval_zswap/blob/master/run.sh
[2] https://lore.kernel.org/20231017003519.1426574-3-nphamcs@gmail.com
[3] https://lore.kernel.org/20240706022523.1104080-6-flintglass@gmail.com
[4] https://lore.kernel.org/CAJD7tkZXS-UJVAFfvxJ0nNgTzWBiqepPYA4hEozi01_qktkitg@mail.gmail.com

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Takero Funaki <flintglass@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
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

 mm/zswap.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 3c0fd8a13718..0fb940d03268 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -60,6 +60,8 @@ static u64 zswap_written_back_pages;
 static u64 zswap_reject_reclaim_fail;
 /* Store failed due to compression algorithm failure */
 static u64 zswap_reject_compress_fail;
+/* Compression into a size of <PAGE_SIZE failed */
+static u64 zswap_compress_fail;
 /* Compressed page was too big for the allocator to (optimally) store */
 static u64 zswap_reject_compress_poor;
 /* Load or writeback failed due to decompression failure */
@@ -976,8 +978,26 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
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
+		zswap_compress_fail++;
+		if (mem_cgroup_zswap_writeback_enabled(
+					folio_memcg(page_folio(page)))) {
+			comp_ret = 0;
+			dlen = PAGE_SIZE;
+			dst = kmap_local_page(page);
+		} else {
+			comp_ret = comp_ret ? comp_ret : -EINVAL;
+			goto unlock;
+		}
+	}
 
 	zpool = pool->zpool;
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
@@ -990,6 +1010,8 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	entry->length = dlen;
 
 unlock:
+	if (dst != acomp_ctx->buffer)
+		kunmap_local(dst);
 	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
 		zswap_reject_compress_poor++;
 	else if (comp_ret)
@@ -1012,6 +1034,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
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
@@ -1809,6 +1839,8 @@ static int zswap_debugfs_init(void)
 			   zswap_debugfs_root, &zswap_reject_kmemcache_fail);
 	debugfs_create_u64("reject_compress_fail", 0444,
 			   zswap_debugfs_root, &zswap_reject_compress_fail);
+	debugfs_create_u64("compress_fail", 0444,
+			   zswap_debugfs_root, &zswap_compress_fail);
 	debugfs_create_u64("reject_compress_poor", 0444,
 			   zswap_debugfs_root, &zswap_reject_compress_poor);
 	debugfs_create_u64("decompress_fail", 0444,

base-commit: 44fa6646d975349f6499d1aeb0ed826680d0bb5c
-- 
2.39.5

