Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E162C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6116A6B009B; Wed, 23 Sep 2026 11:45:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574E76B009D; Wed, 23 Sep 2026 11:45:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EDA36B009E; Wed, 23 Sep 2026 11:45:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 146A96B009B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:45:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F85214025A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:28 +0000 (UTC)
X-FDA: 85245451536.27.C5F6803
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DDD4240008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nLn0rCcZ;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evsrLpPx+3ZMMMhVn053YC5QDyQsoD3UAb1BpOZ7Ewc=;
	b=R0qlA3D4umsazerLfBExp4RQ1ht7owUq3jo8Hhk9peg1fUOcMoFqGDp1EDqraEQ57ZBWFw
	cFkqBPlXHLitERrPCNmUq5UDHdTTqwg7/dfkECO7OM/L3kOB/jPwqpa+WgHB7BPsHFmp77
	wr83pEZa+o0IfkOn37qrLp1/SZunKBk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nLn0rCcZ;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178327;
	b=AMsZmoh9eHSWt7QPjeZyA24ahRG77vVo9ukgvd34L9evjm3dlkBvWcXcgnjtf7WEYH705E
	PBOYRBt6a3f0AuPost4G9hBDt9mUZiPGa2W8PtBOwgpABTDynZtwGN2j70sw4FqTJV5Rq0
	VdkCuPiii1sn2Ojgzbm2cAsBUsXFTpc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36AA542AC4;
	Wed, 23 Sep 2026 15:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31911F00893;
	Wed, 23 Sep 2026 15:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178326;
	bh=evsrLpPx+3ZMMMhVn053YC5QDyQsoD3UAb1BpOZ7Ewc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nLn0rCcZWtnRie2FV59JJMs9XVRpY5HnaIUTOb2mC5GCLbmtByEVJcFPQzr9elvM8
	 lI7cb73x5uSEwwymSaBxb37s11aSIcS/PCCOvn2I2+2Xd6eg6sCZFkyEtnNe/98cXj
	 zQ0htgsmDH9XHPc5RciveYGunT4BNdtXR/2HpWezWP7msphtQVKp0TaBSkyhdE1aUk
	 UonsOUvqZbMcBP3hVMPvECP1mLe0JwOcrHdaHO6ViBL413m3fqCybyrW4hpDPIExOI
	 TgAV5XLcZ6auagicNjbX6D0fNm1/oMh0iWth++pLF4aIg1lQm5U5qRhnrpMTzWSOk5
	 Pr8hZo37zbYbA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 23 Sep 2026 17:45:08 +0200
Subject: [PATCH RFC 3/8] mm, slab: rework KMALLOC_RECLAIM handling of
 SLUB_TINY
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-slub_tiny_rework-v1-3-a0e66d536eb5@kernel.org>
References: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
In-Reply-To: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DDD4240008
X-Stat-Signature: q4of9wsq36kc1fy5h5hrhw5qeitdnfir
X-Rspam-User: 
X-HE-Tag: 1790178326-392911
X-HE-Meta: U2FsdGVkX18Amhl+Jadnrwh4XiS7/VtD7Y3yIdKI11MZsJ/fbgV1ARy0FPQ54OLbwjy/Cv/IyfZwBhcVOgL6Ak4XQ62L/10yUXj9mebmb3oNNbsWaDRsbl0YqaOUo5I8oIi6lleZQM5XKAg3Y5MaWLfZqi6GrP9QKw2XWQ9w1+W5R0srkQ3vaQRNu4l1zxCLLsSzgcAEIBL/26VwfRPh4cY3nJEkKgWrLfugBNN9bP/SS7WVJImDqfPT1UUAf0AeNS9HNGY1WELiEvquBhFT28bclLtm7KAuNjKGXngGMb3+84cW1SHnSp0/irUsPjc9CKlBtywFKRnFt91G42F+c/Foi+yLnTpDJvxtZjcuOJheBSq03B71f15psyTiZORlXOrHRJrcLKLONmUX7tYCyTYu6L28klqjEsq4j0pL/hdAtg5Rnn1OyxhxwDBkfO64oQcXN+zoUreKNxZi13bf3uu9CorIt32iB78c9Da5bB7jcRV4lhBZuoyCFTnoRyLYxE1BJtV/aAxZ/DIIEbAkhz6zspKxT05VYjEwPcEmmEsNfTKS6yn+ewUrvp7qygglDv1tJGKzGpyuVvBczDJDbJ068dK9SqKwmi/eo4Dbm5jxLs3GuIv1SMbZ4I5SYoTdKsFc0T5O4yhbMbBaskxAsu3W1UzTiRKwymjwX7g7A8iQUFKCoPZqKUzaUcdXg8yi18xKF9xswP55EZRNqmyx/ZdN19J3yILV+mTtYzmhmHS5AhZPaFjYW9jMZacaAbLTlBV8Y5SpzMq6HWsDDnADTneEpT9e726WsEXM89M5FY4CP+2k9a0dZqWy2vwvKbkqxwpPUGTP+KXN1047gbF9kJujeDFizPcB/uzNBFFjWSyuI5rWXWhz3TAh+WMI3We+WmRkpGd5PDZqy95B9j8Q1ZnBbMmMA8JKghOf5+MQTvKZufVZsqXN+vKkKfpkz20Dq5d1SMKckePuUiodGFQ
 uZTK3pI8
 or9L45nImI7RCN068WbZtTkXL93F1Pm/bPu+TF36Kc5ToMmegheSBgWlhFIpgJNInOXNt3Cpg8e8vkUrInJ2ph01hkk6Agp+OsjZWe5cW0IGkasjI0XCgNplXCkJIpdu8yfUPgH7/wx76suIhHV85t6Xr47t30DT0P2UfIqM6DB50yFfvTmnjutBL8JMofQSdIQhgWXMtUYOxdEnOrDtTjMThQM5hg9NWEfBBUTcV/3Q4/33pOppQY9fi1AibOSX46vkcsrc2g8anj1Z/wfJLbzxeewpg7qw9lXVA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

There is one minor functional change for CONFIG_SLUB_TINY: with
SLAB_RECLAIM_ACCOUNT not being 0 anymore, caches with and without the
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
index 77fcbf99b7b4..00d49ac0d93f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -410,6 +410,8 @@ extern const struct kmalloc_info_struct {
 	unsigned int size;
 } kmalloc_info[];
 
+extern bool slab_tiny_enabled;
+
 /* Kmalloc array related functions */
 void setup_kmalloc_cache_index_table(void);
 void create_kmalloc_caches(void);
@@ -590,8 +592,7 @@ static inline bool need_kmalloc_no_objext(void)
 	if (!mem_alloc_profiling_permanently_disabled())
 		return true;
 
-	if (!mem_cgroup_kmem_disabled() &&
-			(KMALLOC_NORMAL == KMALLOC_RECLAIM))
+	if (!mem_cgroup_kmem_disabled() && slab_tiny_enabled)
 		return true;
 
 	return false;
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 28bf035a58f3..38de7d50bfa7 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -826,11 +826,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 #define KMALLOC_CGROUP_NAME(sz)
 #endif
 
-#ifndef CONFIG_SLUB_TINY
 #define KMALLOC_RCL_NAME(sz)	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #sz,
-#else
-#define KMALLOC_RCL_NAME(sz)
-#endif
 
 #ifdef CONFIG_KMALLOC_PARTITION_CACHES
 #define __KMALLOC_PARTITION_CONCAT(a, b) a ## b
@@ -967,7 +963,11 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
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
@@ -1000,7 +1000,7 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 	 * KMALLOC_NO_OBJ_EXT cache.
 	 */
 	if (!mem_cgroup_kmem_disabled()) {
-		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
+		if (type == KMALLOC_NORMAL && !slab_tiny_enabled)
 			flags |= SLAB_NO_MERGE;
 		else if (!(flags & SLAB_NO_OBJ_EXT))
 			flags |= SLAB_MAY_ACCOUNT;
diff --git a/mm/slub.c b/mm/slub.c
index bc593f0078c0..2a7b3b3b91b5 100644
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
2.55.0


