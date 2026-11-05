Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29BDA606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SyJ9C7b1
Received: by kanga.kvack.org (Postfix)
	id 2AEA06B05B7; Thu,  5 Nov 2026 03:44:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2600D6B05B8; Thu,  5 Nov 2026 03:44:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126BD6B05B9; Thu,  5 Nov 2026 03:44:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA9D76B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:44:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FA44C0985
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:16 +0000 (UTC)
X-FDA: 85400428512.06.002E0C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BC59016000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyJ9C7b1;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcwWyu992adRNRov8at/qT9yIPityd08l/5rPv4jP5c=;
	b=uq7hpvsN6JG7UJbqGpdd1ad5s3wFGCZmqf9kXwc0B3pXJfc4Y49iz3KY2nh+A8MIYcIH7o
	sRA/tOpV75aJ3FIeHZ7r2NgRxuR+yCSBaUIdqTCzVbMABMM/coYprKAxS6MefUU7sFO3zT
	PRl6CwtsKPGq6KIwzY+OhuHukiYlAnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868254;
	b=sZFV9nlb/kmanNE8cIRTRQWSUplbQ+nXZT5smyIA5e5wbJWrxIOHx5yn14G1yZ6CGjFmx4
	wlYfgh1jKzorxI8CsLUBk6/+XqEgCV7m8Mf4CG/CakflcA+5pNbQoe8UaJavQU6iGdpnpO
	r9X9seDGVWlBzzLX9ToDg9lARAaHwmA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyJ9C7b1;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BD68433D9;
	Thu,  5 Nov 2026 08:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8EB1F00919;
	Thu,  5 Nov 2026 08:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868254;
	bh=QcwWyu992adRNRov8at/qT9yIPityd08l/5rPv4jP5c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SyJ9C7b1l3U73nQZClRGK9zBmL1sF5CWoGhfFhSSl+lKyRetzKE1PW29I66jfia99
	 5d/dp7f/9g72dI5q3lOooXb+PUZTfDQEo25fPrQGjMYSJtHbE5zV0Uf6MkXb48MdLV
	 cCO6P23MJrokKAe98Dyy1CH1OZjL6Uiym3qojlUFBv4ZK9R989pQA8fMzo1JTWTeip
	 SG58nRI+GlbiEJuGe1ClxZGWmAEmI+i8baDgzX0qTt2CtRVvyPWNki5YBqPHxrfX/f
	 hY5fgBJd78NHNKdYEHf2Gv+kbAjNyrhlQe9Fuc3wRjT8IlvrA6PcKkkE6a4MOcLcoU
	 51IRH/1bskBxQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 05 Nov 2026 09:43:54 +0100
Subject: [PATCH v3 05/10] mm, slab: rework KMALLOC_RECLAIM handling of
 SLUB_TINY
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-slub_tiny_rework-v3-5-0484ce59eabb@kernel.org>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
In-Reply-To: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Stat-Signature: 57bt78dozc88t6r5e6i3eegh1oyxz6kt
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BC59016000B
X-Rspam-User: 
X-HE-Tag: 1793868254-495834
X-HE-Meta: U2FsdGVkX19jWEK58KlXxOiydEkEX+zBOlQ5yWTZbyzsuVyRTMyKmOx71GmcJX7EXDtWj7I3t+SYu6cBWIsNvs2Dw7KuzHuwIiRrQvGSZBT3EZzbbfCg5G6mHTURbulvHfWR7fUPejWNgJT725y/86sZx3BX0UlhUFXt10l2DSrDkw67X5PRf7Xirt9GHe024BizYIbo8/EVawW324OF5Q/qso+/o+NJBZdwpM1wyhj2ObIT7Y2cNOViVs0WSx48o0D1LegL7FjWkyojMP9GzUsE6Trhci2FKW2af4jrnHMgZREpkpqNoS16YGVCf0didQ+Rzvy0FSpm3vP2rgnUa17IsfZWg7zZImLIr0e5ylQSlr5ASOrDJMoKMj2ARDFd2/qRM0CmAye7Q6lI1GlvRldmVx/FGE1Zm1oZxmW1zKKLmrZKbqm2p4DUFsxcj1Pw12ucyEf9QpHb+630T+XGTAlP78sQsgz+QcF1wOmHJ3KTtBzwcoY+9E9a8e+pfpuebAG89uOtOxlamp9nYu9vdR+4PBJ0s/MxUbmUExEX0FCqBqA4FKUQNcpWUfBvL2S/vy0G7KNZjTijKyqIzoxmfmzll8kxcyyMYI24xjOJyk9+8JWO4DvVykaatN77hL4DozJeWyuVBOCspB+718vYm4oesYxsXrecQuHjRfASAFucm00qkD+HGEe56jmHxRv5m97lsVolX9DnMb2fCQXSJWE1hlS/ouckdOvPuqhfcVYcqm58tcf27p7vNwHQQTbU0JbDZdHgrJVLlFpQB2A/M+31Ywn1V8rfQiu4UgRNFUStzBIw/EsQt/RJWOK2W0s9S+HvzqzB5Qhbxfsf9XvpoMXRoyYGLoei5pafncMlEXwJAuM2+n2r+nYPsqik/yoDTLmHIZpPwByzk+NxQMUYQIO+cLYjPJSKh+9qnc0eAD5HHrakExMhBieKcDit97JUUgbhw/IUkT4DGt9uAqS
 t2QZZ2IV
 oHgwIpn/4OHV85uLHDAoc95bM72FK+nF3azHUGtJ/sz6tGCDNAlD0ssFrX8ZvoxJL9I8EPo0NOSaGhkXGZopX++hihdpfcREwuV6kOyHSM3+Sk2PqTkmvyhAlcSu32bEIL+GoQPoAZ3xbwfdkTxkCEJzfYJX0CLnKOEQrRVJEdwMgI9WwG4DZqSId9ckIReqyv9aVXukow3WosAIUA+MvlrSWPBHxggGwVbxbemC5D603C4nNEh0MDcTrefiQtKBTCQZnDzgiB4YsgzCMVwvjrHLUEWpUf5I5b8MU0WxJAGMlYtFU0w7HlxcUIRyQeCnJfTSTfDdjZEZy2nW4KVOE8sc9Z/0jCMGEJfiAXybHhEYwXVcwO3Gp/eD5kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

One (relatively minor) aspect of CONFIG_SLUB_TINY is the assumption that
letting reclaimable and non-reclaimable caches merge will save more
memory, which is more important on small systems than the page allocator
level fragmentation (where distinguishing reclaimable slabs should
help).

For now that has been achieved by #ifdefs that result in making the
SLAB_RECLAIM_ACCOUNT no-op and aliasing KMALLOC_RECLAIM to
KMALLOC_NORMAL on the enum values level.

With the goal of converting CONFIG_SLUB_TINY to a boot-time decision,
rework this so that SLAB_RECLAIM_ACCOUNT and KMALLOC_RECLAIM are
distinctly defined always. Now, creation of kmalloc-rcl caches is
avoided by assigning a pointer to the normal kmalloc cache on the
kmalloc_caches array level.

To prepare disconnecting of this boot-time decision (and the evaluation
of the need for kmalloc_no_objext) from CONFIG_SLUB_TINY, introduce a
slub_tiny_enabled variable that's initialized to the CONFIG_SLUB_TINY
state.

There is one minor functional change for CONFIG_SLUB_TINY=y. Since
SLAB_RECLAIM_ACCOUNT is not 0 anymore, caches that differ only in that
flag will stop being mergeable. If that turns out to have a noticeable
impact on memory footprint, we can adjust the merging decisions to
ignore SLAB_RECLAIM_ACCOUNT when slub_tiny_enabled is true.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/slab.h | 10 ----------
 mm/slab.h            |  5 +++--
 mm/slab_common.c     | 12 ++++++------
 mm/slub.c            |  2 ++
 4 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index ed949e8522be..930dd64b9ad6 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -55,9 +55,7 @@ enum _slab_flag_bits {
 #ifdef CONFIG_KFENCE
 	_SLAB_SKIP_KFENCE,
 #endif
-#ifndef CONFIG_SLUB_TINY
 	_SLAB_RECLAIM_ACCOUNT,
-#endif
 	_SLAB_OBJECT_POISON,
 	_SLAB_CMPXCHG_DOUBLE,
 #ifdef CONFIG_SLAB_OBJ_EXT
@@ -241,11 +239,7 @@ enum _slab_flag_bits {
  * pages are allocated with __GFP_RECLAIMABLE, which affects grouping pages by
  * mobility, and are accounted in SReclaimable counter in /proc/meminfo
  */
-#ifndef CONFIG_SLUB_TINY
 #define SLAB_RECLAIM_ACCOUNT	__SLAB_FLAG_BIT(_SLAB_RECLAIM_ACCOUNT)
-#else
-#define SLAB_RECLAIM_ACCOUNT	__SLAB_FLAG_UNUSED
-#endif
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 
 /* Slab caches without obj_exts array */
@@ -724,11 +718,7 @@ enum kmalloc_cache_type {
 #endif
 	KMALLOC_PARTITION_START = KMALLOC_NORMAL,
 	KMALLOC_PARTITION_END = KMALLOC_PARTITION_START + KMALLOC_PARTITION_CACHES_NR,
-#ifdef CONFIG_SLUB_TINY
-	KMALLOC_RECLAIM = KMALLOC_NORMAL,
-#else
 	KMALLOC_RECLAIM,
-#endif
 #ifdef CONFIG_ZONE_DMA
 	KMALLOC_DMA,
 #endif
diff --git a/mm/slab.h b/mm/slab.h
index 79774e2be3bb..835d977634ec 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -396,6 +396,8 @@ extern const struct kmalloc_info_struct {
 	unsigned int size;
 } kmalloc_info[];
 
+extern bool slab_tiny_enabled;
+
 /* Kmalloc array related functions */
 void setup_kmalloc_cache_index_table(void);
 void create_kmalloc_caches(void);
@@ -576,8 +578,7 @@ static inline bool need_kmalloc_no_objext(void)
 	if (!mem_alloc_profiling_permanently_disabled())
 		return true;
 
-	if (!mem_cgroup_kmem_disabled() &&
-			(KMALLOC_NORMAL == KMALLOC_RECLAIM))
+	if (!mem_cgroup_kmem_disabled() && slab_tiny_enabled)
 		return true;
 
 	return false;
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 6036ce1ac333..b7a4e32c7a11 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -836,11 +836,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 #define KMALLOC_CGROUP_NAME(sz)
 #endif
 
-#ifndef CONFIG_SLUB_TINY
 #define KMALLOC_RCL_NAME(sz)	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #sz,
-#else
-#define KMALLOC_RCL_NAME(sz)
-#endif
 
 #ifdef CONFIG_KMALLOC_PARTITION_CACHES
 #define __KMALLOC_PARTITION_CONCAT(a, b) a ## b
@@ -977,7 +973,11 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 	unsigned int aligned_size = kmalloc_info[idx].size;
 	int aligned_idx = idx;
 
-	if ((KMALLOC_RECLAIM != KMALLOC_NORMAL) && (type == KMALLOC_RECLAIM)) {
+	if (type == KMALLOC_RECLAIM) {
+		if (slab_tiny_enabled) {
+			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
+			return;
+		}
 		flags |= SLAB_RECLAIM_ACCOUNT;
 	} else if (IS_ENABLED(CONFIG_MEMCG) && (type == KMALLOC_CGROUP)) {
 		if (mem_cgroup_kmem_disabled()) {
@@ -1010,7 +1010,7 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 	 * KMALLOC_NO_OBJ_EXT cache.
 	 */
 	if (!mem_cgroup_kmem_disabled()) {
-		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
+		if (type == KMALLOC_NORMAL && !slab_tiny_enabled)
 			flags |= SLAB_NO_MERGE;
 		else if (!(flags & SLAB_NO_OBJ_EXT))
 			flags |= SLAB_MAY_ACCOUNT;
diff --git a/mm/slub.c b/mm/slub.c
index 51daf361c601..a3ee1bdf0eb3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -219,6 +219,8 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			slab_obj_ext_has_codetag_key);
 #endif
 
+bool slab_tiny_enabled __read_mostly = IS_ENABLED(CONFIG_SLUB_TINY);
+
 /* Structure holding extra parameters for slab allocations */
 struct slab_alloc_context {
 	unsigned long caller_addr;

-- 
2.56.0


