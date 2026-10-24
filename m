Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13A6606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZC0mt9T7
Received: by kanga.kvack.org (Postfix)
	id B83206B05B3; Sat, 24 Oct 2026 15:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34B16B05B4; Sat, 24 Oct 2026 15:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CA06B05B5; Sat, 24 Oct 2026 15:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4956B05B3
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:07:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0ADAF1A0436
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:46 +0000 (UTC)
X-FDA: 85358454132.26.127EB03
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7B0F940002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZC0mt9T7;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792868864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZjaY6QuOHRtN96A5SO2kORXdqjBzKooIBWrk23AQ4w=;
	b=HmcqZz/Kb9BBYa/vWZlCKn6BXCIcaWvaL/rfY3BR9+HoOvl8UX21HUCUSo7KkIeI+5aPef
	sCMCVN2lMVN4qmgdRIBt6oozDYN5CoM9eZ4dkZUNtWBFtsHJXqUt1wa7SIWXwhiQCnhukQ
	rgr0X28tu0sk4N3rRBcY9DrsQiusqfQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZC0mt9T7;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792868864;
	b=ypnxU/U8aOs/J9EvGtlX0Ahgg5MeUWxBI44AGVO5zi3RA2e2WyuvaOVMRSuoPTTpXEXyog
	yHZDFO1dhbj+sCAX2huEjKDyWfG9I3BGT67Gohoz1CMc1bUxbGMJ8rh6nk3iAo5vig6Tt1
	A/HS+ZzoZJcRjcmkIJKQiWe3x2BNhNM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 117496020A;
	Sat, 24 Oct 2026 19:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ABC1F031E3;
	Sat, 24 Oct 2026 19:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792868863;
	bh=MZjaY6QuOHRtN96A5SO2kORXdqjBzKooIBWrk23AQ4w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZC0mt9T7mmveHc8v5XsDnpeWpmf9YjMXcXaad3CWhh3noCVU2hsUN+gDJ1aYjOs/o
	 ALjjJReZdiCIuNlgHhOScoX81pOFnErNOIWClCpAXaLMPk8vxbf/0Z+a+ugZbrKyfE
	 0akn6be13wFtI2PXX8zpgEg1I55iVW91qRsz/90Psc89N3/47h1wLjKCY4IzNB+P1u
	 cNP7QkDrNEfGNOLwc+GjzjY5CUsks+9Xu1LtnkqF5HN6CPfW8QVMBzYfcG7ZJum2w/
	 PDJhBzoZC/wO/c4+QHMFV1pg3gf2PIzfh91jMRHteyHGXh61rxi3aR+IKOFwAFlETu
	 GFqGbDRnvmyPA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Sat, 24 Oct 2026 21:07:25 +0200
Subject: [PATCH RFC v2 3/8] mm, slab: rework KMALLOC_RECLAIM handling of
 SLUB_TINY
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261024-slub_tiny_rework-v2-3-bf1419ab5ffd@kernel.org>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
In-Reply-To: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7B0F940002
X-Stat-Signature: ccfu3zexoedhhnxjwz5t4m5app53fa6r
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792868864-426328
X-HE-Meta: U2FsdGVkX1/rvsf67G+cGeOg9USjrMaCNppvjLhr2jpf51tXQFTUxUNzCuhzHjSfNA9LVQa4l+3TNnk74CR3kv+SmikbT9FLgj+/4f+TA7jnd9QTziFjemIlw9HYzTvJOVX6bAFaWvXiUuCyK09TE1N75Ui0ulNVSAcFWiWbKAEXa5KE2N5rtVVfLF1C857I+WzAl6s933Lu1NqdD1JbcAPEXrnOU/6iGaCIjVV03xumfm+g4yEhFxnFBeJvJMoEIH7cxVXdYr1VlhbcJW5/dVmtPWDX51YSat0dFur2JLanksXnV57B24KGfaNaU2LfV7In/tHf1BLkQea8qRA1/T3Hfh1ixxbXsJZAFOnVUdz9bGHGHl0L0FyjX9V1T2f195TUAW1Lxkj4ybrsTaGyI+FSlcbRhuEcuSEhyVO5oFTDc2+pRiMCBrkfKqzSw1pxPIBe1ZkiN7rsp23YAEK8tOL8CxsiPwD8VulM9gxKRY4oUu8xO8D+1roYs7AiECXRpviTncw8C7W34IwyAzHQ/73cgK8Sm7gCTezdjbRWnzChs590SO+CwHDzxHJHQop5nQ+Qi2FSjhNkL7VU5jn6aI4VCVHl6F6AADeNpl27t2aVhwCivi7wFNrUpjiKjvjtGgunp1PXfN82fX3E8MbyF+jEr/zHE+i/2pWC+mMnEw7aTU5LcwfTEr0D6bCzLJlicw4jhtSrt0HfEFvCd2+ou/p6mpL/hiLOjBebK+4tWA2WxoEUHxHXStaY9Ih9ZOKOqIjtpgckuEPZUnp8IZ4536iCetYMHjzEIKU7fIP+9/ADig49WOH/UXT02WZxSawFUn3UeXwWNSDP/vXEulJFwVCjt86moXlgI9YtImot5rcw5qq/j73isbtQNT/hZpObPbRoi+E89gk1K/Ilie385q6lo/88+HHWL8tBqXsZf3WWK+dyT20kwTL2d2fgM9CwoFlGMNgaHS5AHGEBYsc
 EAWkJZGI
 wRzn7zDSZ35LCKp9l10q/U9tnOnuGasv53i1sa8BH+4Qx71SZ65qTZUWE5LZ+q6SrJ57yIm3Uzy1fHoeGLhuftQWz0VpsFyfplo+c2V46HECTzN5fwjpiZ3qxd+NVB4HvzfQEDNORLpjTXG6tSDG0HtMudDU+jN3fL2czTMgaH5Y0nAdRm9POuGpjRaMefyOkJhuCh9NFsAojO4DpU1LlCNTHKAk/LGpOjKh+ZJLWB0wF60SYiRsi7LUrnAwFXQCj4/ZodbqQYgisyLbYvVsxNs6eWJlNHt8J3ITi
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
index 02dfe4351e8b..33e76a0c3084 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -835,11 +835,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 #define KMALLOC_CGROUP_NAME(sz)
 #endif
 
-#ifndef CONFIG_SLUB_TINY
 #define KMALLOC_RCL_NAME(sz)	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #sz,
-#else
-#define KMALLOC_RCL_NAME(sz)
-#endif
 
 #ifdef CONFIG_KMALLOC_PARTITION_CACHES
 #define __KMALLOC_PARTITION_CONCAT(a, b) a ## b
@@ -976,7 +972,11 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
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
@@ -1009,7 +1009,7 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
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


