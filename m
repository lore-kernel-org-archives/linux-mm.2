Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA146C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5268E6B088B; Sun, 16 Aug 2026 18:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D77F6B088D; Sun, 16 Aug 2026 18:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6126B088E; Sun, 16 Aug 2026 18:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D55846B088B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 552E4A047D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:21 +0000 (UTC)
X-FDA: 85108620282.25.AEAC5E0
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3FFAD40004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="X SU+L66";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=kxeVJIdK;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEajPWpWYWlbGhN/CguiGDhcHomV0Q9qRnl8pYmoAV4=;
	b=3H+jFK4VlbuJHH8ng8Hc9uGS2iKLjHPMQq0CWY2EmPTrCxusdTnWmJ6S8RKK3LskYQQgwl
	s+mhI02fExTB4x35fl5nDgSYQEZw/GF58VeqDWocHVNi2OibCG5rCtNYFxuCxvi96z3CDS
	zMn7+aqXMKwtUjJlEcp53LfMmgvuLU4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920439;
	b=DIdDmBRytOnW1sh8zHiYPjVhMogLD/2HB6WOVYPmYxhzBv3nnrqarO9YvhKM4dW1cKKYd+
	0f2+rW714i+WBHbkxpeUQjrWm7QDj3KA4qIAHHXFkAmusCMuxvUMB2+mQnQEnyKQG0kzyA
	3p9TikODV3lcrJVXReDoqlrG35mp6VA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="X SU+L66";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=kxeVJIdK;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id CF79FEC0074;
	Sun, 16 Aug 2026 18:47:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920438; x=
	1787006838; bh=KEajPWpWYWlbGhN/CguiGDhcHomV0Q9qRnl8pYmoAV4=; b=X
	SU+L665jfN6LvWryDqfVXrFM4L1PfaTutPm03RYuGnvG75EY64RNFj1Pz5nhNwC4
	YTBBzyAsoWAIthD3pTsb4D9nmjk7yye/igrhfJvan1uYmZm8XwdhDvOo1yq2Pd60
	u7wCoPboz7qkRNAj4pL+GLvfE+vAIfTA/ifC7l1XwUu9zQh19JO6o3iKZoMmaKi4
	MCyMIZJf52wTHIppKYMSoRVcdj/k10ijuZM8qOMPy1W2C/IczwP6QIdHs72SZ3EW
	dC5df+q97j8Dw9GIc66+zBp8IG0JP6jMNmAvIw4x62omNKj7ruRjdTZ8hqhpHKCZ
	/0Aiggb6Hpjsp9UEVPrrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920438; x=1787006838; bh=K
	EajPWpWYWlbGhN/CguiGDhcHomV0Q9qRnl8pYmoAV4=; b=kxeVJIdKQXkPD+zDW
	Hc3s+nxBL2O5P58eG4AxfdxazNX8ZbzU6GfvLdsC03iDk8RwRp6FmwKjuJdl4Ir3
	LjFIr2oQMVPl70W9N8oa8Xd/xXGgg8TdxnSjFLogsAQkMTJizWETZI50jF778WAm
	lomOU1aG4X1eHhmalt4dNrCq37BGkFT/u0y2FCSel13vpMpMYlfkmXkKCZVYW/rH
	jqDGfOajCuvOrnuMctMNNPr0P+w+RSIU6kKPR9s0H3m+rsfUFGRR3BaWTJETYEaT
	zTklzGlhO1xW21ihy6WhUHYJhLW5UEi6s+oKo62m/ikw1wJh9Am3dzjdIMriUqZm
	qlQrQ==
X-ME-Sender: <xms:9j2CaiOlz-JHocymSVQ5PNhbBZv6zoY5Dvf-4xSwmKIqDx-61D0Dqg>
    <xme:9j2CamT3fYExutsg3a2Hg_FFEreck-ywQqcrwYsAKB5OUYzzZd3fzW80_yfscdY8I
    TjZ1DrLwUsKlL8GHBtwUrfkWlyNsjr30PcNIO07FObTRaZvktcomPk>
X-ME-Received: <xmr:9j2CalUl5HO9g1SvzNU-CWuzkGh3-8umkCF09xqrSGlaUSRJd0D0NN3lAAQ>
X-ME-Proxy-Cause: dmFkZTEWPmjqOfRj5F992yj4B4BZj1raD29b+9/uQ9rFyvaV+kr+0iJRDW/7N8sznN5hp3
    Jd0ytp1vu59bDzCFT/O8S/efKgYbCfD2rLp5ESvFXHBu+C+T7VPMHXocEWQmqRcTwN39e9
    beda2Ri+DmyXoylgECNlOmesAYSvAqjyQbPp39VciQhjDZLAdlalALq+T39tfvcBsAftOx
    0pZrMKicu8IddtrFqvBcFdG/5WkfJWvoJzqNqmEsI17lT+SJI8PEV94Md+CC1CjuERkMm2
    pW/0xtbQUhoKznxP8UdY68yvPC1FKG1sdD5CGoRhqiz0Y+ik+TmkR1x+Rv8Bp8o0DAMUtZ
    cE0l5giu9WU8FxtH87akRwOLggtEGz9Dv2wcd/9L9aAdAWMzcaZbfT1wtLjnSx1hT6I9zI
    1Y4LA1YLLh2q43e+CQmfwta5t0xx3lsVCiUD7cC2BwIeD1CTfTqiUkc0HojLf7rC4PM4N6
    yZ/NnNw9MvpbU4dorT50kf8UOvmLFYyeUvbl7TV6stAyqkFLLKJjVI/ym70PglOCy9e0jG
    Jzdl+FjX8OQv7exDKeImToZak6fo4n7jWXfEBYv5NrACReeimfTQRLFLcu5aRty+EeRXQj
    NuAcg5VNidCBlztgm/DhHQAIp0S7HZ535kLsEqSc/5F1AYHi++FW9jf1pWHQ
X-ME-Proxy: <xmx:9j2CavQll0-_ZX_fKK0ZMq5Ksz_CfoojQh3zrtbLU2SaJWjbwGNW_Q>
    <xmx:9j2CaguixUNXLvQOf8XT7ZeRWAyFMRQ9_vJf_KcUhzqvKaE7pVXu9Q>
    <xmx:9j2Cagb_4GZmmchEUm5rWId12Pkbx4iULHUwKlIHsueBuuCopH0-9g>
    <xmx:9j2Caj9OPJ01MltZ72bFxNDO_o-3tB_SJhFNoDbg35I1aR6UsyRIfQ>
    <xmx:9j2CakAxtCtSc3Z85ciBLeNlzZWd1z6abNqdvUcbYovCCxQBgSMTTL9H>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:17 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 32/57] mm/collapse: move the file collapse into collapse.c
Date: Sun, 16 Aug 2026 23:45:44 +0100
Message-ID: <20260816224609.308019-33-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1b9e5qwzepc3bam85d8cazkohqy7dj5t
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3FFAD40004
X-HE-Tag: 1786920439-962546
X-HE-Meta: U2FsdGVkX1+2Akiwbcp+XZN95atxq962XQk6Jcjj49YwhdCyJh9fd4KnpOTjyK6UKL+hDxYAGidbq2gUGcJgu6Oz57FddHuL6VU2J+9d8uj9wMEXZahAlVzbTs1fD2nA8MUrycOlx4OKo+kF0hBogkZhTmMn5Z/lUBzfZ/2GkSrZbYqPALZpNrs5pQuZBhNpg69QjYPzG60hM9c+WyTkvZsj4V6huNoK+DJ+/tsSbf6jSv6iJ5TTzRCpoEliXpTzLrfq8M4pieBHUC5MlfpoI9kOxfKSBNSCqHMoTkILji3WXEugVCn5zcJeNExWg8xzCq7yUlq9wFhWNlIaPFPUOzW7nCZgZab80vcaNPljqj7iDCTX9TJBJncqMbV1Co1bgF+4h9RSevr6O3gdhHlPZYw2wjCqCmnj+an89F0FGZFM69H0Nz9zstDiE0vcuBaTNCOgDV9ItweRLFfjNPbG4kMgNbDMnfXkOcjWhYFbh7RZ60LppcZl1OJyrYJs8Da2tijIzpeDNZhWteqbfPR68aLg2meByKbWqeGQ9iDzP8fHui6hou6A93nNl0+tR2uBaYTFSo2Ap3NgwmqX1WuixFt+SVjyhvT7M1LZJ+h/1bdrvOYKWafsKfpyzvNs5adNZwtTEPv7jMRi+oa1nUHU6a6pAMyA/FbGnp7UYWpCDCDhbdyOygwwIeuGz75iE8c5AYjDnT4tlvEPvrTWkPt4dYwMabCAsLMmfID7HJayLZ7wdcaU8P0YuV7dtoeCXnVth2B3xjCKDcQQsp4KJExKbZUzP93iUFRxOGCbHAvd14ZWT+TEGuidyNjp9zQ4GnlLSGcuWJgO2bVfku15oSE8hEchMjrz7AANRNwV+LU+DaH+2xSiISlqwtpxHH5/JQdg2FwNbrj0+5ptm5475c/lGtsmzBrlQS2q2CWJJwL7AueTUUpinXCXNmA9eTkYo5HVFluOPCS1gqeRTocd1/1
 mpYOnYBj
 X3AWunLBZ7rJ3H2qabeyLPpmKYxHRFIC8BoKWDDLAcVDSF1mEkzXMstzo0KCRxU9W0Apc5yz0WsvvSG8YjH+G6KyKgp94FKnib6Q/7iFlMrCIgRU6iF7avYHQ6eQrK3rri/IkegIC4nqQguFWATVfErLJm4niwfALbnQC2iwN1s5GXM+91uGG8ZSsaVT1Q5OkHhsBRWoQZ1g6BjFtqKEWTPsP1YoIxQT0NfzNYo/V47iJPhjyXXwMgSED91Yj4msYFY/Dd5RN96nu76kKKlmkpuL6KIRW/r5l8PBwbBqzcQ1h32LwlbfAy44e9tlm7x1kofjY4YwYER4u4+OdMf4yR/yR1KI0zrpCsq//+GLCMqfYvfHmAzqYFUGlrzNvTFAye3Z3d4TQzbPpDakEEMd1dzI6sYf2ccL5FT1RxcwFECkQIULhAqmVywBhGQkHxBnLrMF5YFVd532aBEf9z/TFglyF2FKDCR12wgn3eOlEjPlDJgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Collapse is split across two files with no boundary to speak of: the
engine in collapse.c, the file and shmem half in khugepaged.c, helpers
reaching in both directions, and the function that chooses between them
sitting with the daemon.

Move the rest of the mechanism over -- the file collapse and its scan, the
PTE-mapped-THP recollapse and the table retraction it needs, and the
allocator they share -- and with them collapse_single_pmd(), which
dispatches on the VMA.

khugepaged.c keeps what is actually khugepaged: the tunables, the daemon
and its scan budget, the mm_slot bookkeeping, and the walk that decides
which ranges to offer.

Five helpers lose their last caller outside collapse.c and go static, as
do the engine's two entries now that the dispatcher reaches them from the
same file.  check_pmd_state() was already static inline, so its
declaration was only ever dead.  collapse_single_pmd() takes their place
in collapse.h, keeping the interface it has today: a VMA to dispatch on
and an out-param saying whether the lock survived.

Pure motion: every function arrives in collapse.c exactly as it left
khugepaged.c.  Beyond that the diff has only the four includes the moved
code needs, and the header declarations that changed hands.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c   | 1095 ++++++++++++++++++++++++++++++++++++++++++++++-
 mm/collapse.h   |   17 +-
 mm/khugepaged.c | 1075 ----------------------------------------------
 3 files changed, 1090 insertions(+), 1097 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index ae7c2777b279..21bfbc038044 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/backing-dev.h>
 #include <linux/bitops.h>
+#include <linux/dax.h>
 #include <linux/highmem.h>
 #include <linux/huge_mm.h>
 #include <linux/hugetlb.h>	/* x86 flush_tlb_range() uses hstate_vma() */
@@ -11,8 +13,10 @@
 #include <linux/mmu_notifier.h>
 #include <linux/pagemap.h>
 #include <linux/pgalloc.h>
+#include <linux/rcupdate_wait.h>
 #include <linux/rmap.h>
 #include <linux/sched.h>
+#include <linux/shmem_fs.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
@@ -136,7 +140,7 @@ static inline enum scan_result check_pmd_state(pmd_t *pmd)
 	return SCAN_SUCCEED;
 }
 
-enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
+static enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
 		unsigned long address, pmd_t **pmd)
 {
 	*pmd = mm_find_pmd(mm, address);
@@ -182,7 +186,7 @@ static unsigned int max_order_from_offset(unsigned int offset)
  *
  * Return: Maximum number of empty/shared zeropage PTEs for the collapse operation
  */
-unsigned int collapse_max_ptes_none(struct collapse_control *cc,
+static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
 	const unsigned int max_ptes_none = cc->policy.max_ptes_none;
@@ -239,7 +243,7 @@ static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
  * Return: Maximum number of non-present PTEs or the maximum allowed non-present
  * pagecache entries for the collapse operation.
  */
-unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
+static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 		unsigned int order)
 {
 	/*
@@ -251,7 +255,7 @@ unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 	return cc->policy.max_ptes_swap;
 }
 
-bool collapse_scan_abort(int nid, struct collapse_control *cc)
+static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
 
@@ -276,7 +280,7 @@ bool collapse_scan_abort(int nid, struct collapse_control *cc)
 }
 
 #ifdef CONFIG_NUMA
-int collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	int nid, target_node = 0, max_value = 0;
 
@@ -295,7 +299,7 @@ int collapse_find_target_node(struct collapse_control *cc)
 	return target_node;
 }
 #else
-int collapse_find_target_node(struct collapse_control *cc)
+static int collapse_find_target_node(struct collapse_control *cc)
 {
 	return 0;
 }
@@ -2110,7 +2114,7 @@ static void collapse_anon_scan_init(struct collapse_control *cc)
  * that acts on what it found hands the range to collapse_anon_pmd() afterwards,
  * without the lock.
  */
-enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
+static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end,
 					struct collapse_control *cc)
 {
@@ -2521,7 +2525,7 @@ static void collapse_add_candidate(struct collapse_control *cc,
  * largest order downwards.  Returns what the table yielded: a collapse, or
  * the reason it did not.
  */
-enum scan_result collapse_anon_pmd(struct mm_struct *mm, unsigned long start,
+static enum scan_result collapse_anon_pmd(struct mm_struct *mm, unsigned long start,
 				   unsigned long end,
 				   struct collapse_control *cc)
 {
@@ -2583,3 +2587,1078 @@ enum scan_result collapse_anon_pmd(struct mm_struct *mm, unsigned long start,
 		return cc->scan_refusal;
 	return cc->select_result;
 }
+
+static void count_collapse_event(unsigned int order, enum vm_event_item vm_event,
+		enum mthp_stat_item mthp_event)
+{
+	if (is_pmd_order(order))
+		count_vm_event(vm_event);
+	count_mthp_stat(order, mthp_event);
+}
+
+static void collapse_control_init_scan(struct collapse_control *cc)
+{
+	memset(cc->node_load, 0, sizeof(cc->node_load));
+	nodes_clear(cc->alloc_nmask);
+	bitmap_zero(cc->eligible_ptes, MAX_PTRS_PER_PTE);
+}
+
+static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
+		struct collapse_control *cc, unsigned int order)
+{
+	gfp_t gfp = cc->policy.gfp;
+	int node = collapse_find_target_node(cc);
+	struct folio *folio;
+
+	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
+	if (!folio) {
+		*foliop = NULL;
+		count_collapse_event(order, THP_COLLAPSE_ALLOC_FAILED,
+				     MTHP_STAT_COLLAPSE_ALLOC_FAILED);
+		return SCAN_ALLOC_HUGE_PAGE_FAIL;
+	}
+
+	count_collapse_event(order, THP_COLLAPSE_ALLOC, MTHP_STAT_COLLAPSE_ALLOC);
+
+	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
+		folio_put(folio);
+		*foliop = NULL;
+		return SCAN_CGROUP_CHARGE_FAIL;
+	}
+
+	if (is_pmd_order(order))
+		count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
+
+	*foliop = folio;
+	return SCAN_SUCCEED;
+}
+
+/* folio must be locked, and mmap_lock must be held */
+static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
+		pmd_t *pmdp, struct folio *folio, struct page *page)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct vm_fault vmf = {
+		.vma = vma,
+		.address = addr,
+		.flags = 0,
+	};
+	pgd_t *pgdp;
+	p4d_t *p4dp;
+	pud_t *pudp;
+
+	mmap_assert_locked(vma->vm_mm);
+
+	if (!pmdp) {
+		pgdp = pgd_offset(mm, addr);
+		p4dp = p4d_alloc(mm, pgdp, addr);
+		if (!p4dp)
+			return SCAN_FAIL;
+		pudp = pud_alloc(mm, p4dp, addr);
+		if (!pudp)
+			return SCAN_FAIL;
+		pmdp = pmd_alloc(mm, pudp, addr);
+		if (!pmdp)
+			return SCAN_FAIL;
+	}
+
+	vmf.pmd = pmdp;
+	if (do_set_pmd(&vmf, folio, page))
+		return SCAN_FAIL;
+
+	folio_get(folio);
+	return SCAN_SUCCEED;
+}
+
+static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+		bool install_pmd)
+{
+	enum scan_result result = SCAN_FAIL;
+	int nr_mapped_ptes = 0;
+	unsigned int nr_batch_ptes;
+	struct mmu_notifier_range range;
+	bool notified = false;
+	unsigned long haddr = addr & HPAGE_PMD_MASK;
+	unsigned long end = haddr + HPAGE_PMD_SIZE;
+	struct vm_area_struct *vma = vma_lookup(mm, haddr);
+	struct folio *folio;
+	pte_t *start_pte, *pte;
+	pmd_t *pmd, pgt_pmd;
+	spinlock_t *pml = NULL, *ptl;
+	int i;
+
+	mmap_assert_locked(mm);
+
+	/* First check VMA found, in case page tables are being torn down */
+	if (!vma || !vma->vm_file ||
+	    !range_in_vma(vma, haddr, haddr + HPAGE_PMD_SIZE))
+		return SCAN_VMA_CHECK;
+
+	/* Fast check before locking page if already PMD-mapped */
+	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
+	if (result == SCAN_PMD_MAPPED)
+		return result;
+
+	/*
+	 * If we are here, we've succeeded in replacing all the native pages
+	 * in the page cache with a single hugepage. If a mm were to fault-in
+	 * this memory (mapped by a suitably aligned VMA), we'd get the hugepage
+	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
+	 * analogously elide sysfs THP settings here and force collapse.
+	 */
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+		return SCAN_VMA_CHECK;
+
+	/*
+	 * Keep pmd pgtable while the uffd bit is in use; see comment in
+	 * retract_page_tables().
+	 */
+	if (userfaultfd_protected(vma))
+		return SCAN_PTE_UFFD;
+
+	folio = filemap_lock_folio(vma->vm_file->f_mapping,
+			       linear_page_index(vma, haddr));
+	if (IS_ERR(folio))
+		return SCAN_PAGE_NULL;
+
+	if (!is_pmd_order(folio_order(folio))) {
+		result = SCAN_PAGE_COMPOUND;
+		goto drop_folio;
+	}
+
+	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
+	switch (result) {
+	case SCAN_SUCCEED:
+		break;
+	case SCAN_NO_PTE_TABLE:
+		/*
+		 * All pte entries have been removed and pmd cleared.
+		 * Skip all the pte checks and just update the pmd mapping.
+		 */
+		goto maybe_install_pmd;
+	default:
+		goto drop_folio;
+	}
+
+	result = SCAN_FAIL;
+	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
+	if (!start_pte)		/* mmap_lock + page lock should prevent this */
+		goto drop_folio;
+
+	/* step 1: check all mapped PTEs are to the right huge page */
+	for (i = 0, addr = haddr, pte = start_pte;
+	     i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE, pte++) {
+		struct page *page;
+		pte_t ptent = ptep_get(pte);
+
+		/* empty pte, skip */
+		if (pte_none(ptent))
+			continue;
+
+		/* page swapped out, abort */
+		if (!pte_present(ptent)) {
+			result = SCAN_PTE_NON_PRESENT;
+			goto abort;
+		}
+
+		page = vm_normal_page(vma, addr, ptent);
+		if (WARN_ON_ONCE(page && is_zone_device_page(page)))
+			page = NULL;
+		/*
+		 * Note that uprobe, debugger, or MAP_PRIVATE may change the
+		 * page table, but the new page will not be a subpage of hpage.
+		 */
+		if (folio_page(folio, i) != page)
+			goto abort;
+	}
+
+	pte_unmap_unlock(start_pte, ptl);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
+				haddr, haddr + HPAGE_PMD_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
+	notified = true;
+
+	/*
+	 * pmd_lock covers a wider range than ptl, and (if split from mm's
+	 * page_table_lock) ptl nests inside pml. The less time we hold pml,
+	 * the better; but userfaultfd's mfill_atomic_pte() on a private VMA
+	 * inserts a valid as-if-COWed PTE without even looking up page cache.
+	 * So page lock of folio does not protect from it, so we must not drop
+	 * ptl before pgt_pmd is removed, so uffd private needs pml taken now.
+	 */
+	if (userfaultfd_armed(vma) && !(vma->vm_flags & VM_SHARED))
+		pml = pmd_lock(mm, pmd);
+
+	start_pte = pte_offset_map_rw_nolock(mm, pmd, haddr, &pgt_pmd, &ptl);
+	if (!start_pte)		/* mmap_lock + page lock should prevent this */
+		goto abort;
+	if (!pml)
+		spin_lock(ptl);
+	else if (ptl != pml)
+		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+
+	if (unlikely(!pmd_same(pgt_pmd, pmdp_get_lockless(pmd))))
+		goto abort;
+
+	/* step 2: clear page table and adjust rmap */
+	for (i = 0, addr = haddr, pte = start_pte; i < HPAGE_PMD_NR;
+	     i += nr_batch_ptes, addr += nr_batch_ptes * PAGE_SIZE,
+	     pte += nr_batch_ptes) {
+		unsigned int max_nr_batch_ptes = (end - addr) >> PAGE_SHIFT;
+		struct page *page;
+		pte_t ptent = ptep_get(pte);
+
+		nr_batch_ptes = 1;
+
+		if (pte_none(ptent))
+			continue;
+		/*
+		 * We dropped ptl after the first scan, to do the mmu_notifier:
+		 * page lock stops more PTEs of the folio being faulted in, but
+		 * does not stop write faults COWing anon copies from existing
+		 * PTEs; and does not stop those being swapped out or migrated.
+		 */
+		if (!pte_present(ptent)) {
+			result = SCAN_PTE_NON_PRESENT;
+			goto abort;
+		}
+		page = vm_normal_page(vma, addr, ptent);
+
+		if (folio_page(folio, i) != page)
+			goto abort;
+
+		nr_batch_ptes = folio_pte_batch(folio, pte, ptent, max_nr_batch_ptes);
+
+		/*
+		 * Must clear entry, or a racing truncate may re-remove it.
+		 * TLB flush can be left until pmdp_collapse_flush() does it.
+		 * PTE dirty? Shmem page is already dirty; file is read-only.
+		 */
+		clear_ptes(mm, addr, pte, nr_batch_ptes);
+		folio_remove_rmap_ptes(folio, page, nr_batch_ptes, vma);
+		nr_mapped_ptes += nr_batch_ptes;
+	}
+
+	if (!pml)
+		spin_unlock(ptl);
+
+	/* step 3: set proper refcount and mm_counters. */
+	if (nr_mapped_ptes) {
+		folio_ref_sub(folio, nr_mapped_ptes);
+		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
+	}
+
+	/* step 4: remove empty page table */
+	if (!pml) {
+		pml = pmd_lock(mm, pmd);
+		if (ptl != pml) {
+			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+			if (unlikely(!pmd_same(pgt_pmd, pmdp_get_lockless(pmd)))) {
+				flush_tlb_mm(mm);
+				goto unlock;
+			}
+		}
+	}
+	pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
+	pmdp_get_lockless_sync();
+	pte_unmap_unlock(start_pte, ptl);
+	if (ptl != pml)
+		spin_unlock(pml);
+
+	mmu_notifier_invalidate_range_end(&range);
+
+	mm_dec_nr_ptes(mm);
+	page_table_check_pte_clear_range(mm, haddr, pgt_pmd);
+	pte_free_defer(mm, pmd_pgtable(pgt_pmd));
+
+maybe_install_pmd:
+	/* step 5: install pmd entry */
+	result = install_pmd
+			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
+			: SCAN_SUCCEED;
+	goto drop_folio;
+abort:
+	if (nr_mapped_ptes) {
+		flush_tlb_mm(mm);
+		folio_ref_sub(folio, nr_mapped_ptes);
+		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
+	}
+unlock:
+	if (start_pte)
+		pte_unmap_unlock(start_pte, ptl);
+	if (pml && pml != ptl)
+		spin_unlock(pml);
+	if (notified)
+		mmu_notifier_invalidate_range_end(&range);
+drop_folio:
+	folio_unlock(folio);
+	folio_put(folio);
+	return result;
+}
+
+/**
+ * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
+ * address haddr.
+ *
+ * @mm: process address space where collapse happens
+ * @addr: THP collapse address
+ * @install_pmd: If a huge PMD should be installed
+ *
+ * This function checks whether all the PTEs in the PMD are pointing to the
+ * right THP. If so, retract the page table so the THP can refault in with
+ * as pmd-mapped. Possibly install a huge PMD mapping the THP.
+ */
+void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+		bool install_pmd)
+{
+	try_collapse_pte_mapped_thp(mm, addr, install_pmd);
+}
+
+/* Can we retract page tables for this file-backed VMA? */
+static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
+{
+	/*
+	 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
+	 * got written to. These VMAs are likely not worth removing
+	 * page tables from, as PMD-mapping is likely to be split later.
+	 */
+	if (READ_ONCE(vma->anon_vma))
+		return false;
+
+	/*
+	 * When a vma is registered with uffd-wp or RWP, we cannot recycle
+	 * the page table because there may be pte markers installed.
+	 * VM_UFFD_RWP ranges similarly rely on per-PTE uffd state
+	 * and cannot be recycled to a shared PMD. Other vmas can still
+	 * have the same file mapped hugely, but skip this one: it will
+	 * always be mapped in small page size for these registrations.
+	 */
+	if (userfaultfd_protected(vma))
+		return false;
+
+	/*
+	 * If the VMA contains guard regions then we can't collapse it.
+	 *
+	 * This is set atomically on guard marker installation under mmap/VMA
+	 * read lock, and here we may not hold any VMA or mmap lock at all.
+	 *
+	 * This is therefore serialised on the PTE page table lock, which is
+	 * obtained on guard region installation after the flag is set, so this
+	 * check being performed under this lock excludes races.
+	 */
+	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT))
+		return false;
+
+	return true;
+}
+
+static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
+{
+	struct vm_area_struct *vma;
+
+	i_mmap_lock_read(mapping);
+	mapping_rmap_tree_foreach(vma, mapping, pgoff, pgoff) {
+		struct mmu_notifier_range range;
+		struct mm_struct *mm;
+		unsigned long addr;
+		pmd_t *pmd, pgt_pmd;
+		spinlock_t *pml;
+		spinlock_t *ptl;
+		bool success = false;
+
+		addr = vma->vm_start +
+			((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
+		if (addr & ~HPAGE_PMD_MASK ||
+		    vma->vm_end < addr + HPAGE_PMD_SIZE)
+			continue;
+
+		mm = vma->vm_mm;
+		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
+			continue;
+
+		if (collapse_test_exit(mm))
+			continue;
+
+		if (!file_backed_vma_is_retractable(vma))
+			continue;
+
+		/* PTEs were notified when unmapped; but now for the PMD? */
+		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
+					addr, addr + HPAGE_PMD_SIZE);
+		mmu_notifier_invalidate_range_start(&range);
+
+		pml = pmd_lock(mm, pmd);
+		/*
+		 * The lock of new_folio is still held, we will be blocked in
+		 * the page fault path, which prevents the pte entries from
+		 * being set again. So even though the old empty PTE page may be
+		 * concurrently freed and a new PTE page is filled into the pmd
+		 * entry, it is still empty and can be removed.
+		 *
+		 * So here we only need to recheck if the state of pmd entry
+		 * still meets our requirements, rather than checking pmd_same()
+		 * like elsewhere.
+		 */
+		if (check_pmd_state(pmd) != SCAN_SUCCEED)
+			goto drop_pml;
+		ptl = pte_lockptr(mm, pmd);
+		if (ptl != pml)
+			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+
+		/*
+		 * Huge page lock is still held, so normally the page table must
+		 * remain empty; and we have already skipped anon_vma and
+		 * userfaultfd_wp() vmas.  But since the mmap_lock is not held,
+		 * it is still possible for a racing userfaultfd_ioctl() or
+		 * madvise() to have inserted ptes or markers.  Now that we hold
+		 * ptlock, repeating the retractable checks protects us from
+		 * races against the prior checks.
+		 */
+		if (likely(file_backed_vma_is_retractable(vma))) {
+			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
+			pmdp_get_lockless_sync();
+			success = true;
+		}
+
+		if (ptl != pml)
+			spin_unlock(ptl);
+drop_pml:
+		spin_unlock(pml);
+
+		mmu_notifier_invalidate_range_end(&range);
+
+		if (success) {
+			mm_dec_nr_ptes(mm);
+			page_table_check_pte_clear_range(mm, addr, pgt_pmd);
+			pte_free_defer(mm, pmd_pgtable(pgt_pmd));
+		}
+	}
+	i_mmap_unlock_read(mapping);
+}
+
+/**
+ * collapse_file - collapse filemap/tmpfs/shmem pages into huge one.
+ *
+ * @mm: process address space where collapse happens
+ * @addr: virtual collapse start address
+ * @file: file that collapse on
+ * @start: collapse start address
+ * @cc: collapse context and scratchpad
+ *
+ * Basic scheme is simple, details are more complex:
+ *  - allocate and lock a new huge page;
+ *  - scan page cache, locking old pages
+ *    + swap/gup in pages if necessary;
+ *  - copy data to new page
+ *  - handle shmem holes
+ *    + re-validate that holes weren't filled by someone else
+ *    + check for userfaultfd
+ *  - finalize updates to the page cache;
+ *  - if replacing succeeds:
+ *    + unlock huge page;
+ *    + free old pages;
+ *  - if replacing failed;
+ *    + unlock old pages
+ *    + unlock and free huge page;
+ */
+static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
+		struct file *file, pgoff_t start, struct collapse_control *cc)
+{
+	struct address_space *mapping = file->f_mapping;
+	struct page *dst;
+	struct folio *folio, *tmp, *new_folio;
+	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
+	LIST_HEAD(pagelist);
+	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
+	enum scan_result result = SCAN_SUCCEED;
+	int nr_none = 0;
+	bool is_shmem = shmem_file(file);
+
+	/*
+	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
+	 *
+	 * TODO: once shmem always calls mapping_set_large_folios() on its
+	 * mapping, the shmem check can be removed.
+	 */
+	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
+	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
+
+	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
+	if (result != SCAN_SUCCEED)
+		goto out;
+
+	mapping_set_update(&xas, mapping);
+
+	__folio_set_locked(new_folio);
+	if (is_shmem)
+		__folio_set_swapbacked(new_folio);
+	new_folio->index = start;
+	new_folio->mapping = mapping;
+
+	/*
+	 * Ensure we have slots for all the pages in the range.  This is
+	 * almost certainly a no-op because most of the pages must be present
+	 */
+	do {
+		xas_lock_irq(&xas);
+		xas_create_range(&xas);
+		if (!xas_error(&xas))
+			break;
+		xas_unlock_irq(&xas);
+		if (!xas_nomem(&xas, GFP_KERNEL)) {
+			result = SCAN_FAIL;
+			goto rollback;
+		}
+	} while (1);
+
+	for (index = start; index < end;) {
+		xas_set(&xas, index);
+		folio = xas_load(&xas);
+
+		VM_BUG_ON(index != xas.xa_index);
+		if (is_shmem) {
+			if (!folio) {
+				/*
+				 * Stop if extent has been truncated or
+				 * hole-punched, and is now completely
+				 * empty.
+				 */
+				if (index == start) {
+					if (!xas_next_entry(&xas, end - 1)) {
+						result = SCAN_TRUNCATED;
+						goto xa_locked;
+					}
+				}
+				nr_none++;
+				index++;
+				continue;
+			}
+
+			if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
+				xas_unlock_irq(&xas);
+				/* swap in or instantiate fallocated page */
+				if (shmem_get_folio(mapping->host, index, 0,
+						&folio, SGP_NOALLOC)) {
+					result = SCAN_FAIL;
+					goto xa_unlocked;
+				}
+				/* drain lru cache to help folio_isolate_lru() */
+				lru_add_drain();
+			} else if (folio_trylock(folio)) {
+				folio_get(folio);
+				xas_unlock_irq(&xas);
+			} else {
+				result = SCAN_PAGE_LOCK;
+				goto xa_locked;
+			}
+		} else {	/* !is_shmem */
+			if (!folio || xa_is_value(folio)) {
+				xas_unlock_irq(&xas);
+				page_cache_sync_readahead(mapping, &file->f_ra,
+							  file, index,
+							  end - index);
+				/* drain lru cache to help folio_isolate_lru() */
+				lru_add_drain();
+				folio = filemap_lock_folio(mapping, index);
+				if (IS_ERR(folio)) {
+					result = SCAN_FAIL;
+					goto xa_unlocked;
+				}
+			} else if (folio_test_dirty(folio)) {
+				/*
+				 * This page is dirty because it hasn't
+				 * been flushed since first write.
+				 *
+				 * Trigger async flush for read-only files and
+				 * hope the writeback is done when khugepaged
+				 * revisits this page. Writable files can have
+				 * their folios dirty at any time; blindly
+				 * flushing them would cause undesirable
+				 * system-wide writeback.
+				 *
+				 * This is a one-off situation. We are not
+				 * forcing writeback in loop.
+				 */
+				xas_unlock_irq(&xas);
+				if (!inode_is_open_for_write(mapping->host))
+					filemap_flush(mapping);
+				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+				goto xa_unlocked;
+			} else if (folio_test_writeback(folio)) {
+				xas_unlock_irq(&xas);
+				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+				goto xa_unlocked;
+			} else if (folio_trylock(folio)) {
+				folio_get(folio);
+				xas_unlock_irq(&xas);
+			} else {
+				result = SCAN_PAGE_LOCK;
+				goto xa_locked;
+			}
+		}
+
+		/*
+		 * The folio must be locked, so we can drop the i_pages lock
+		 * without racing with truncate.
+		 */
+		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+
+		/* make sure the folio is up to date */
+		if (unlikely(!folio_test_uptodate(folio))) {
+			result = SCAN_FAIL;
+			goto out_unlock;
+		}
+
+		/*
+		 * If file was truncated then extended, or hole-punched, before
+		 * we locked the first folio, then a THP might be there already.
+		 * This will be discovered on the first iteration.
+		 */
+		if (is_pmd_order(folio_order(folio))) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			goto out_unlock;
+		}
+
+		if (folio_mapping(folio) != mapping) {
+			result = SCAN_TRUNCATED;
+			goto out_unlock;
+		}
+
+		if (!is_shmem && (folio_test_dirty(folio) ||
+				  folio_test_writeback(folio))) {
+			/*
+			 * khugepaged only works on clean file-backed folios,
+			 * so this folio is dirty because it hasn't been flushed
+			 * since first write.
+			 */
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			goto out_unlock;
+		}
+
+		if (!folio_isolate_lru(folio)) {
+			result = SCAN_DEL_PAGE_LRU;
+			goto out_unlock;
+		}
+
+		if (!filemap_release_folio(folio, GFP_KERNEL)) {
+			result = SCAN_PAGE_HAS_PRIVATE;
+			folio_putback_lru(folio);
+			goto out_unlock;
+		}
+
+		if (folio_mapped(folio))
+			try_to_unmap(folio,
+					TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
+
+		xas_lock_irq(&xas);
+
+		VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);
+
+		/*
+		 * We control 2 + nr_pages references to the folio:
+		 *  - we hold a pin on it;
+		 *  - nr_pages reference from page cache;
+		 *  - one from lru_isolate_folio;
+		 * If those are the only references, then any new usage
+		 * of the folio will have to fetch it from the page
+		 * cache. That requires locking the folio to handle
+		 * truncate, so any new usage will be blocked until we
+		 * unlock folio after collapse/during rollback.
+		 */
+		if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
+			result = SCAN_PAGE_COUNT;
+			xas_unlock_irq(&xas);
+			folio_putback_lru(folio);
+			goto out_unlock;
+		}
+
+		/*
+		 * At this point, the folio is locked and unmapped. If the PTE
+		 * was dirty, try_to_unmap() has transferred the dirty bit to
+		 * the folio and we must not collapse it into a clean
+		 * file-backed folio.
+		 *
+		 * If the folio is clean here, no one can write it until we
+		 * drop the folio lock. A write through a stale TLB entry came
+		 * from a clean PTE and must fault because the PTE has been
+		 * cleared; the fault path has to take the folio lock before
+		 * installing a writable mapping. Buffered write paths also
+		 * have to take the folio lock before modifying file contents
+		 * without a mapping, typically via write_begin_get_folio().
+		 */
+		if (!is_shmem && folio_test_dirty(folio)) {
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			xas_unlock_irq(&xas);
+			folio_putback_lru(folio);
+			goto out_unlock;
+		}
+
+		/*
+		 * Accumulate the folios that are being collapsed.
+		 */
+		list_add_tail(&folio->lru, &pagelist);
+		index += folio_nr_pages(folio);
+		continue;
+out_unlock:
+		folio_unlock(folio);
+		folio_put(folio);
+		goto xa_unlocked;
+	}
+
+xa_locked:
+	xas_unlock_irq(&xas);
+xa_unlocked:
+
+	/*
+	 * If collapse is successful, flush must be done now before copying.
+	 * If collapse is unsuccessful, does flush actually need to be done?
+	 * Do it anyway, to clear the state.
+	 */
+	try_to_unmap_flush();
+
+	if (result == SCAN_SUCCEED && nr_none &&
+	    !shmem_charge(mapping->host, nr_none))
+		result = SCAN_FAIL;
+	if (result != SCAN_SUCCEED) {
+		nr_none = 0;
+		goto rollback;
+	}
+
+	/*
+	 * The old folios are locked, so they won't change anymore.
+	 */
+	index = start;
+	dst = folio_page(new_folio, 0);
+	list_for_each_entry(folio, &pagelist, lru) {
+		int i, nr_pages = folio_nr_pages(folio);
+
+		while (index < folio->index) {
+			clear_highpage(dst);
+			index++;
+			dst++;
+		}
+
+		for (i = 0; i < nr_pages; i++) {
+			if (copy_mc_highpage(dst, folio_page(folio, i)) > 0) {
+				result = SCAN_COPY_MC;
+				goto rollback;
+			}
+			index++;
+			dst++;
+		}
+	}
+	while (index < end) {
+		clear_highpage(dst);
+		index++;
+		dst++;
+	}
+
+	if (nr_none) {
+		struct vm_area_struct *vma;
+		int nr_none_check = 0;
+
+		i_mmap_lock_read(mapping);
+		xas_lock_irq(&xas);
+
+		xas_set(&xas, start);
+		for (index = start; index < end; index++) {
+			if (!xas_next(&xas)) {
+				xas_store(&xas, XA_RETRY_ENTRY);
+				if (xas_error(&xas)) {
+					result = SCAN_STORE_FAILED;
+					goto immap_locked;
+				}
+				nr_none_check++;
+			}
+		}
+
+		if (nr_none != nr_none_check) {
+			result = SCAN_PAGE_FILLED;
+			goto immap_locked;
+		}
+
+		/*
+		 * If userspace observed a missing page in a VMA with
+		 * a MODE_MISSING userfaultfd, then it might expect a
+		 * UFFD_EVENT_PAGEFAULT for that page. If so, we need to
+		 * roll back to avoid suppressing such an event. Since
+		 * wp/minor userfaultfds don't give userspace any
+		 * guarantees that the kernel doesn't fill a missing
+		 * page with a zero page, so they don't matter here.
+		 *
+		 * Any userfaultfds registered after this point will
+		 * not be able to observe any missing pages due to the
+		 * previously inserted retry entries.
+		 */
+		mapping_rmap_tree_foreach(vma, mapping, start, end) {
+			if (userfaultfd_missing(vma)) {
+				result = SCAN_EXCEED_NONE_PTE;
+				goto immap_locked;
+			}
+		}
+
+immap_locked:
+		i_mmap_unlock_read(mapping);
+		if (result != SCAN_SUCCEED) {
+			xas_set(&xas, start);
+			for (index = start; index < end; index++) {
+				if (xas_next(&xas) == XA_RETRY_ENTRY)
+					xas_store(&xas, NULL);
+			}
+
+			xas_unlock_irq(&xas);
+			goto rollback;
+		}
+	} else {
+		xas_lock_irq(&xas);
+	}
+
+	if (is_shmem) {
+		lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
+		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
+	} else {
+		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
+	}
+	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
+
+	/*
+	 * Mark new_folio as uptodate before inserting it into the
+	 * page cache so that it isn't mistaken for an fallocated but
+	 * unwritten page.
+	 */
+	folio_mark_uptodate(new_folio);
+	folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
+
+	if (is_shmem)
+		folio_mark_dirty(new_folio);
+	folio_add_lru(new_folio);
+
+	/* Join all the small entries into a single multi-index entry. */
+	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
+	xas_store(&xas, new_folio);
+	WARN_ON_ONCE(xas_error(&xas));
+	xas_unlock_irq(&xas);
+
+	/*
+	 * Remove pte page tables, so we can re-fault the page as huge.  A caller
+	 * that wants the PMD mapped now is told to go and do that.
+	 */
+	retract_page_tables(mapping, start);
+	if (cc->policy.install_pmd)
+		result = SCAN_PTE_MAPPED_HUGEPAGE;
+	folio_unlock(new_folio);
+
+	/*
+	 * The collapse has succeeded, so free the old folios.
+	 */
+	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
+		list_del(&folio->lru);
+		lruvec_stat_mod_folio(folio, NR_FILE_PAGES,
+				      -folio_nr_pages(folio));
+		if (is_shmem)
+			lruvec_stat_mod_folio(folio, NR_SHMEM,
+					      -folio_nr_pages(folio));
+		folio->mapping = NULL;
+		folio_clear_active(folio);
+		folio_clear_unevictable(folio);
+		folio_unlock(folio);
+		folio_put_refs(folio, 2 + folio_nr_pages(folio));
+	}
+
+	goto out;
+
+rollback:
+	/* Something went wrong: roll back page cache changes */
+	if (nr_none) {
+		xas_lock_irq(&xas);
+		mapping->nrpages -= nr_none;
+		xas_unlock_irq(&xas);
+		shmem_uncharge(mapping->host, nr_none);
+	}
+
+	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
+		list_del(&folio->lru);
+		folio_unlock(folio);
+		folio_putback_lru(folio);
+		folio_put(folio);
+	}
+
+	new_folio->mapping = NULL;
+
+	folio_unlock(new_folio);
+	folio_put(new_folio);
+out:
+	VM_BUG_ON(!list_empty(&pagelist));
+	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	return result;
+}
+
+static enum scan_result collapse_scan_file(struct mm_struct *mm,
+		unsigned long addr, struct file *file, pgoff_t start,
+		struct collapse_control *cc)
+{
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
+	struct folio *folio = NULL;
+	struct address_space *mapping = file->f_mapping;
+	XA_STATE(xas, &mapping->i_pages, start);
+	int present, swap;
+	int node = NUMA_NO_NODE;
+	enum scan_result result = SCAN_SUCCEED;
+
+	present = 0;
+	swap = 0;
+	collapse_control_init_scan(cc);
+	rcu_read_lock();
+	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
+		if (xas_retry(&xas, folio))
+			continue;
+
+		if (xa_is_value(folio)) {
+			swap += 1 << xas_get_order(&xas);
+			if (swap > max_ptes_swap) {
+				result = SCAN_EXCEED_SWAP_PTE;
+				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+				break;
+			}
+			continue;
+		}
+
+		if (!folio_try_get(folio)) {
+			xas_reset(&xas);
+			continue;
+		}
+
+		if (unlikely(folio != xas_reload(&xas))) {
+			folio_put(folio);
+			xas_reset(&xas);
+			continue;
+		}
+
+		if (is_pmd_order(folio_order(folio))) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			/*
+			 * PMD-sized THP implies that we can only try
+			 * retracting the PTE table.
+			 */
+			folio_put(folio);
+			break;
+		}
+
+		node = folio_nid(folio);
+		if (collapse_scan_abort(node, cc)) {
+			result = SCAN_SCAN_ABORT;
+			folio_put(folio);
+			break;
+		}
+		cc->node_load[node]++;
+
+		if (!folio_test_lru(folio)) {
+			result = SCAN_PAGE_LRU;
+			folio_put(folio);
+			break;
+		}
+
+		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
+			result = SCAN_PAGE_COUNT;
+			folio_put(folio);
+			break;
+		}
+
+		/*
+		 * We probably should check if the folio is referenced
+		 * here, but nobody would transfer pte_young() to
+		 * folio_test_referenced() for us.  And rmap walk here
+		 * is just too costly...
+		 */
+
+		present += folio_nr_pages(folio);
+		folio_put(folio);
+
+		if (need_resched()) {
+			xas_pause(&xas);
+			cond_resched_rcu();
+		}
+	}
+	rcu_read_unlock();
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
+		cc->progress++;
+	else
+		cc->progress += HPAGE_PMD_NR;
+
+	if (result == SCAN_SUCCEED) {
+		if (present < HPAGE_PMD_NR - max_ptes_none) {
+			result = SCAN_EXCEED_NONE_PTE;
+			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+		} else {
+			result = collapse_file(mm, addr, file, start, cc);
+		}
+	}
+
+	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
+	return result;
+}
+
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+enum scan_result collapse_single_pmd(unsigned long addr,
+		unsigned long end, struct vm_area_struct *vma,
+		bool *lock_dropped, struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	bool triggered_wb = false;
+	enum scan_result result;
+	struct file *file;
+	pgoff_t pgoff;
+
+	mmap_assert_locked(mm);
+
+	if (vma_is_anonymous(vma)) {
+		result = collapse_scan_anon_pmd(vma, addr, end, cc);
+		if (!cc->select_orders)
+			goto end;
+
+		/* collapse_anon_pmd() takes mmap_lock itself, where it needs it */
+		mmap_read_unlock(mm);
+		*lock_dropped = true;
+
+		result = collapse_anon_pmd(mm, addr, end, cc);
+		goto end;
+	}
+
+	file = get_file(vma->vm_file);
+	pgoff = linear_page_index(vma, addr);
+
+	mmap_read_unlock(mm);
+	*lock_dropped = true;
+retry:
+	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+
+	/* Dirty pages are worth a writeback and one more try, if asked for */
+	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
+		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+
+		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+		triggered_wb = true;
+		goto retry;
+	}
+	fput(file);
+
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
+		mmap_read_lock(mm);
+		if (collapse_test_exit_or_disable(mm))
+			result = SCAN_ANY_PROCESS;
+		else
+			result = try_collapse_pte_mapped_thp(mm, addr,
+							cc->policy.install_pmd);
+		if (result == SCAN_PMD_MAPPED)
+			result = SCAN_SUCCEED;
+		mmap_read_unlock(mm);
+	}
+end:
+	return result;
+}
diff --git a/mm/collapse.h b/mm/collapse.h
index 11f51c6ea444..dc60806fb81e 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -187,24 +187,13 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
-enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end,
-		struct collapse_control *cc);
-enum scan_result collapse_anon_pmd(struct mm_struct *mm, unsigned long start,
-		unsigned long end, struct collapse_control *cc);
 int collapse_control_init(struct collapse_control *cc);
 void collapse_control_release(struct collapse_control *cc);
+enum scan_result collapse_single_pmd(unsigned long addr, unsigned long end,
+		struct vm_area_struct *vma, bool *lock_dropped,
+		struct collapse_control *cc);
 
 unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags);
-enum scan_result check_pmd_state(pmd_t *pmd);
-enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
-		unsigned long address, pmd_t **pmd);
-int collapse_find_target_node(struct collapse_control *cc);
-bool collapse_scan_abort(int nid, struct collapse_control *cc);
-unsigned int collapse_max_ptes_none(struct collapse_control *cc,
-		struct vm_area_struct *vma, unsigned int order);
-unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
-		unsigned int order);
 
 #endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 907ed1131460..b7fc93e11d6b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -543,51 +543,6 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 	return SCAN_SUCCEED;
 }
 
-static void count_collapse_event(unsigned int order, enum vm_event_item vm_event,
-		enum mthp_stat_item mthp_event)
-{
-	if (is_pmd_order(order))
-		count_vm_event(vm_event);
-	count_mthp_stat(order, mthp_event);
-}
-
-static void collapse_control_init_scan(struct collapse_control *cc)
-{
-	memset(cc->node_load, 0, sizeof(cc->node_load));
-	nodes_clear(cc->alloc_nmask);
-	bitmap_zero(cc->eligible_ptes, MAX_PTRS_PER_PTE);
-}
-
-static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
-		struct collapse_control *cc, unsigned int order)
-{
-	gfp_t gfp = cc->policy.gfp;
-	int node = collapse_find_target_node(cc);
-	struct folio *folio;
-
-	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
-	if (!folio) {
-		*foliop = NULL;
-		count_collapse_event(order, THP_COLLAPSE_ALLOC_FAILED,
-				     MTHP_STAT_COLLAPSE_ALLOC_FAILED);
-		return SCAN_ALLOC_HUGE_PAGE_FAIL;
-	}
-
-	count_collapse_event(order, THP_COLLAPSE_ALLOC, MTHP_STAT_COLLAPSE_ALLOC);
-
-	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
-		folio_put(folio);
-		*foliop = NULL;
-		return SCAN_CGROUP_CHARGE_FAIL;
-	}
-
-	if (is_pmd_order(order))
-		count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
-
-	*foliop = folio;
-	return SCAN_SUCCEED;
-}
-
 static void collect_mm_slot(struct mm_slot *slot)
 {
 	struct mm_struct *mm = slot->mm;
@@ -610,1036 +565,6 @@ static void collect_mm_slot(struct mm_slot *slot)
 	}
 }
 
-/* folio must be locked, and mmap_lock must be held */
-static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
-		pmd_t *pmdp, struct folio *folio, struct page *page)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	struct vm_fault vmf = {
-		.vma = vma,
-		.address = addr,
-		.flags = 0,
-	};
-	pgd_t *pgdp;
-	p4d_t *p4dp;
-	pud_t *pudp;
-
-	mmap_assert_locked(vma->vm_mm);
-
-	if (!pmdp) {
-		pgdp = pgd_offset(mm, addr);
-		p4dp = p4d_alloc(mm, pgdp, addr);
-		if (!p4dp)
-			return SCAN_FAIL;
-		pudp = pud_alloc(mm, p4dp, addr);
-		if (!pudp)
-			return SCAN_FAIL;
-		pmdp = pmd_alloc(mm, pudp, addr);
-		if (!pmdp)
-			return SCAN_FAIL;
-	}
-
-	vmf.pmd = pmdp;
-	if (do_set_pmd(&vmf, folio, page))
-		return SCAN_FAIL;
-
-	folio_get(folio);
-	return SCAN_SUCCEED;
-}
-
-static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-		bool install_pmd)
-{
-	enum scan_result result = SCAN_FAIL;
-	int nr_mapped_ptes = 0;
-	unsigned int nr_batch_ptes;
-	struct mmu_notifier_range range;
-	bool notified = false;
-	unsigned long haddr = addr & HPAGE_PMD_MASK;
-	unsigned long end = haddr + HPAGE_PMD_SIZE;
-	struct vm_area_struct *vma = vma_lookup(mm, haddr);
-	struct folio *folio;
-	pte_t *start_pte, *pte;
-	pmd_t *pmd, pgt_pmd;
-	spinlock_t *pml = NULL, *ptl;
-	int i;
-
-	mmap_assert_locked(mm);
-
-	/* First check VMA found, in case page tables are being torn down */
-	if (!vma || !vma->vm_file ||
-	    !range_in_vma(vma, haddr, haddr + HPAGE_PMD_SIZE))
-		return SCAN_VMA_CHECK;
-
-	/* Fast check before locking page if already PMD-mapped */
-	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
-	if (result == SCAN_PMD_MAPPED)
-		return result;
-
-	/*
-	 * If we are here, we've succeeded in replacing all the native pages
-	 * in the page cache with a single hugepage. If a mm were to fault-in
-	 * this memory (mapped by a suitably aligned VMA), we'd get the hugepage
-	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
-	 * analogously elide sysfs THP settings here and force collapse.
-	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
-		return SCAN_VMA_CHECK;
-
-	/*
-	 * Keep pmd pgtable while the uffd bit is in use; see comment in
-	 * retract_page_tables().
-	 */
-	if (userfaultfd_protected(vma))
-		return SCAN_PTE_UFFD;
-
-	folio = filemap_lock_folio(vma->vm_file->f_mapping,
-			       linear_page_index(vma, haddr));
-	if (IS_ERR(folio))
-		return SCAN_PAGE_NULL;
-
-	if (!is_pmd_order(folio_order(folio))) {
-		result = SCAN_PAGE_COMPOUND;
-		goto drop_folio;
-	}
-
-	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
-	switch (result) {
-	case SCAN_SUCCEED:
-		break;
-	case SCAN_NO_PTE_TABLE:
-		/*
-		 * All pte entries have been removed and pmd cleared.
-		 * Skip all the pte checks and just update the pmd mapping.
-		 */
-		goto maybe_install_pmd;
-	default:
-		goto drop_folio;
-	}
-
-	result = SCAN_FAIL;
-	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
-	if (!start_pte)		/* mmap_lock + page lock should prevent this */
-		goto drop_folio;
-
-	/* step 1: check all mapped PTEs are to the right huge page */
-	for (i = 0, addr = haddr, pte = start_pte;
-	     i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE, pte++) {
-		struct page *page;
-		pte_t ptent = ptep_get(pte);
-
-		/* empty pte, skip */
-		if (pte_none(ptent))
-			continue;
-
-		/* page swapped out, abort */
-		if (!pte_present(ptent)) {
-			result = SCAN_PTE_NON_PRESENT;
-			goto abort;
-		}
-
-		page = vm_normal_page(vma, addr, ptent);
-		if (WARN_ON_ONCE(page && is_zone_device_page(page)))
-			page = NULL;
-		/*
-		 * Note that uprobe, debugger, or MAP_PRIVATE may change the
-		 * page table, but the new page will not be a subpage of hpage.
-		 */
-		if (folio_page(folio, i) != page)
-			goto abort;
-	}
-
-	pte_unmap_unlock(start_pte, ptl);
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
-				haddr, haddr + HPAGE_PMD_SIZE);
-	mmu_notifier_invalidate_range_start(&range);
-	notified = true;
-
-	/*
-	 * pmd_lock covers a wider range than ptl, and (if split from mm's
-	 * page_table_lock) ptl nests inside pml. The less time we hold pml,
-	 * the better; but userfaultfd's mfill_atomic_pte() on a private VMA
-	 * inserts a valid as-if-COWed PTE without even looking up page cache.
-	 * So page lock of folio does not protect from it, so we must not drop
-	 * ptl before pgt_pmd is removed, so uffd private needs pml taken now.
-	 */
-	if (userfaultfd_armed(vma) && !(vma->vm_flags & VM_SHARED))
-		pml = pmd_lock(mm, pmd);
-
-	start_pte = pte_offset_map_rw_nolock(mm, pmd, haddr, &pgt_pmd, &ptl);
-	if (!start_pte)		/* mmap_lock + page lock should prevent this */
-		goto abort;
-	if (!pml)
-		spin_lock(ptl);
-	else if (ptl != pml)
-		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
-
-	if (unlikely(!pmd_same(pgt_pmd, pmdp_get_lockless(pmd))))
-		goto abort;
-
-	/* step 2: clear page table and adjust rmap */
-	for (i = 0, addr = haddr, pte = start_pte; i < HPAGE_PMD_NR;
-	     i += nr_batch_ptes, addr += nr_batch_ptes * PAGE_SIZE,
-	     pte += nr_batch_ptes) {
-		unsigned int max_nr_batch_ptes = (end - addr) >> PAGE_SHIFT;
-		struct page *page;
-		pte_t ptent = ptep_get(pte);
-
-		nr_batch_ptes = 1;
-
-		if (pte_none(ptent))
-			continue;
-		/*
-		 * We dropped ptl after the first scan, to do the mmu_notifier:
-		 * page lock stops more PTEs of the folio being faulted in, but
-		 * does not stop write faults COWing anon copies from existing
-		 * PTEs; and does not stop those being swapped out or migrated.
-		 */
-		if (!pte_present(ptent)) {
-			result = SCAN_PTE_NON_PRESENT;
-			goto abort;
-		}
-		page = vm_normal_page(vma, addr, ptent);
-
-		if (folio_page(folio, i) != page)
-			goto abort;
-
-		nr_batch_ptes = folio_pte_batch(folio, pte, ptent, max_nr_batch_ptes);
-
-		/*
-		 * Must clear entry, or a racing truncate may re-remove it.
-		 * TLB flush can be left until pmdp_collapse_flush() does it.
-		 * PTE dirty? Shmem page is already dirty; file is read-only.
-		 */
-		clear_ptes(mm, addr, pte, nr_batch_ptes);
-		folio_remove_rmap_ptes(folio, page, nr_batch_ptes, vma);
-		nr_mapped_ptes += nr_batch_ptes;
-	}
-
-	if (!pml)
-		spin_unlock(ptl);
-
-	/* step 3: set proper refcount and mm_counters. */
-	if (nr_mapped_ptes) {
-		folio_ref_sub(folio, nr_mapped_ptes);
-		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
-	}
-
-	/* step 4: remove empty page table */
-	if (!pml) {
-		pml = pmd_lock(mm, pmd);
-		if (ptl != pml) {
-			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
-			if (unlikely(!pmd_same(pgt_pmd, pmdp_get_lockless(pmd)))) {
-				flush_tlb_mm(mm);
-				goto unlock;
-			}
-		}
-	}
-	pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
-	pmdp_get_lockless_sync();
-	pte_unmap_unlock(start_pte, ptl);
-	if (ptl != pml)
-		spin_unlock(pml);
-
-	mmu_notifier_invalidate_range_end(&range);
-
-	mm_dec_nr_ptes(mm);
-	page_table_check_pte_clear_range(mm, haddr, pgt_pmd);
-	pte_free_defer(mm, pmd_pgtable(pgt_pmd));
-
-maybe_install_pmd:
-	/* step 5: install pmd entry */
-	result = install_pmd
-			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
-			: SCAN_SUCCEED;
-	goto drop_folio;
-abort:
-	if (nr_mapped_ptes) {
-		flush_tlb_mm(mm);
-		folio_ref_sub(folio, nr_mapped_ptes);
-		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
-	}
-unlock:
-	if (start_pte)
-		pte_unmap_unlock(start_pte, ptl);
-	if (pml && pml != ptl)
-		spin_unlock(pml);
-	if (notified)
-		mmu_notifier_invalidate_range_end(&range);
-drop_folio:
-	folio_unlock(folio);
-	folio_put(folio);
-	return result;
-}
-
-/**
- * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
- * address haddr.
- *
- * @mm: process address space where collapse happens
- * @addr: THP collapse address
- * @install_pmd: If a huge PMD should be installed
- *
- * This function checks whether all the PTEs in the PMD are pointing to the
- * right THP. If so, retract the page table so the THP can refault in with
- * as pmd-mapped. Possibly install a huge PMD mapping the THP.
- */
-void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
-		bool install_pmd)
-{
-	try_collapse_pte_mapped_thp(mm, addr, install_pmd);
-}
-
-/* Can we retract page tables for this file-backed VMA? */
-static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
-{
-	/*
-	 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
-	 * got written to. These VMAs are likely not worth removing
-	 * page tables from, as PMD-mapping is likely to be split later.
-	 */
-	if (READ_ONCE(vma->anon_vma))
-		return false;
-
-	/*
-	 * When a vma is registered with uffd-wp or RWP, we cannot recycle
-	 * the page table because there may be pte markers installed.
-	 * VM_UFFD_RWP ranges similarly rely on per-PTE uffd state
-	 * and cannot be recycled to a shared PMD. Other vmas can still
-	 * have the same file mapped hugely, but skip this one: it will
-	 * always be mapped in small page size for these registrations.
-	 */
-	if (userfaultfd_protected(vma))
-		return false;
-
-	/*
-	 * If the VMA contains guard regions then we can't collapse it.
-	 *
-	 * This is set atomically on guard marker installation under mmap/VMA
-	 * read lock, and here we may not hold any VMA or mmap lock at all.
-	 *
-	 * This is therefore serialised on the PTE page table lock, which is
-	 * obtained on guard region installation after the flag is set, so this
-	 * check being performed under this lock excludes races.
-	 */
-	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT))
-		return false;
-
-	return true;
-}
-
-static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
-{
-	struct vm_area_struct *vma;
-
-	i_mmap_lock_read(mapping);
-	mapping_rmap_tree_foreach(vma, mapping, pgoff, pgoff) {
-		struct mmu_notifier_range range;
-		struct mm_struct *mm;
-		unsigned long addr;
-		pmd_t *pmd, pgt_pmd;
-		spinlock_t *pml;
-		spinlock_t *ptl;
-		bool success = false;
-
-		addr = vma->vm_start +
-			((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
-		if (addr & ~HPAGE_PMD_MASK ||
-		    vma->vm_end < addr + HPAGE_PMD_SIZE)
-			continue;
-
-		mm = vma->vm_mm;
-		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
-			continue;
-
-		if (collapse_test_exit(mm))
-			continue;
-
-		if (!file_backed_vma_is_retractable(vma))
-			continue;
-
-		/* PTEs were notified when unmapped; but now for the PMD? */
-		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
-					addr, addr + HPAGE_PMD_SIZE);
-		mmu_notifier_invalidate_range_start(&range);
-
-		pml = pmd_lock(mm, pmd);
-		/*
-		 * The lock of new_folio is still held, we will be blocked in
-		 * the page fault path, which prevents the pte entries from
-		 * being set again. So even though the old empty PTE page may be
-		 * concurrently freed and a new PTE page is filled into the pmd
-		 * entry, it is still empty and can be removed.
-		 *
-		 * So here we only need to recheck if the state of pmd entry
-		 * still meets our requirements, rather than checking pmd_same()
-		 * like elsewhere.
-		 */
-		if (check_pmd_state(pmd) != SCAN_SUCCEED)
-			goto drop_pml;
-		ptl = pte_lockptr(mm, pmd);
-		if (ptl != pml)
-			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
-
-		/*
-		 * Huge page lock is still held, so normally the page table must
-		 * remain empty; and we have already skipped anon_vma and
-		 * userfaultfd_wp() vmas.  But since the mmap_lock is not held,
-		 * it is still possible for a racing userfaultfd_ioctl() or
-		 * madvise() to have inserted ptes or markers.  Now that we hold
-		 * ptlock, repeating the retractable checks protects us from
-		 * races against the prior checks.
-		 */
-		if (likely(file_backed_vma_is_retractable(vma))) {
-			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
-			pmdp_get_lockless_sync();
-			success = true;
-		}
-
-		if (ptl != pml)
-			spin_unlock(ptl);
-drop_pml:
-		spin_unlock(pml);
-
-		mmu_notifier_invalidate_range_end(&range);
-
-		if (success) {
-			mm_dec_nr_ptes(mm);
-			page_table_check_pte_clear_range(mm, addr, pgt_pmd);
-			pte_free_defer(mm, pmd_pgtable(pgt_pmd));
-		}
-	}
-	i_mmap_unlock_read(mapping);
-}
-
-/**
- * collapse_file - collapse filemap/tmpfs/shmem pages into huge one.
- *
- * @mm: process address space where collapse happens
- * @addr: virtual collapse start address
- * @file: file that collapse on
- * @start: collapse start address
- * @cc: collapse context and scratchpad
- *
- * Basic scheme is simple, details are more complex:
- *  - allocate and lock a new huge page;
- *  - scan page cache, locking old pages
- *    + swap/gup in pages if necessary;
- *  - copy data to new page
- *  - handle shmem holes
- *    + re-validate that holes weren't filled by someone else
- *    + check for userfaultfd
- *  - finalize updates to the page cache;
- *  - if replacing succeeds:
- *    + unlock huge page;
- *    + free old pages;
- *  - if replacing failed;
- *    + unlock old pages
- *    + unlock and free huge page;
- */
-static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
-		struct file *file, pgoff_t start, struct collapse_control *cc)
-{
-	struct address_space *mapping = file->f_mapping;
-	struct page *dst;
-	struct folio *folio, *tmp, *new_folio;
-	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
-	LIST_HEAD(pagelist);
-	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
-	enum scan_result result = SCAN_SUCCEED;
-	int nr_none = 0;
-	bool is_shmem = shmem_file(file);
-
-	/*
-	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
-	 *
-	 * TODO: once shmem always calls mapping_set_large_folios() on its
-	 * mapping, the shmem check can be removed.
-	 */
-	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
-	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
-
-	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
-	if (result != SCAN_SUCCEED)
-		goto out;
-
-	mapping_set_update(&xas, mapping);
-
-	__folio_set_locked(new_folio);
-	if (is_shmem)
-		__folio_set_swapbacked(new_folio);
-	new_folio->index = start;
-	new_folio->mapping = mapping;
-
-	/*
-	 * Ensure we have slots for all the pages in the range.  This is
-	 * almost certainly a no-op because most of the pages must be present
-	 */
-	do {
-		xas_lock_irq(&xas);
-		xas_create_range(&xas);
-		if (!xas_error(&xas))
-			break;
-		xas_unlock_irq(&xas);
-		if (!xas_nomem(&xas, GFP_KERNEL)) {
-			result = SCAN_FAIL;
-			goto rollback;
-		}
-	} while (1);
-
-	for (index = start; index < end;) {
-		xas_set(&xas, index);
-		folio = xas_load(&xas);
-
-		VM_BUG_ON(index != xas.xa_index);
-		if (is_shmem) {
-			if (!folio) {
-				/*
-				 * Stop if extent has been truncated or
-				 * hole-punched, and is now completely
-				 * empty.
-				 */
-				if (index == start) {
-					if (!xas_next_entry(&xas, end - 1)) {
-						result = SCAN_TRUNCATED;
-						goto xa_locked;
-					}
-				}
-				nr_none++;
-				index++;
-				continue;
-			}
-
-			if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
-				xas_unlock_irq(&xas);
-				/* swap in or instantiate fallocated page */
-				if (shmem_get_folio(mapping->host, index, 0,
-						&folio, SGP_NOALLOC)) {
-					result = SCAN_FAIL;
-					goto xa_unlocked;
-				}
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
-			} else if (folio_trylock(folio)) {
-				folio_get(folio);
-				xas_unlock_irq(&xas);
-			} else {
-				result = SCAN_PAGE_LOCK;
-				goto xa_locked;
-			}
-		} else {	/* !is_shmem */
-			if (!folio || xa_is_value(folio)) {
-				xas_unlock_irq(&xas);
-				page_cache_sync_readahead(mapping, &file->f_ra,
-							  file, index,
-							  end - index);
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
-				folio = filemap_lock_folio(mapping, index);
-				if (IS_ERR(folio)) {
-					result = SCAN_FAIL;
-					goto xa_unlocked;
-				}
-			} else if (folio_test_dirty(folio)) {
-				/*
-				 * This page is dirty because it hasn't
-				 * been flushed since first write.
-				 *
-				 * Trigger async flush for read-only files and
-				 * hope the writeback is done when khugepaged
-				 * revisits this page. Writable files can have
-				 * their folios dirty at any time; blindly
-				 * flushing them would cause undesirable
-				 * system-wide writeback.
-				 *
-				 * This is a one-off situation. We are not
-				 * forcing writeback in loop.
-				 */
-				xas_unlock_irq(&xas);
-				if (!inode_is_open_for_write(mapping->host))
-					filemap_flush(mapping);
-				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-				goto xa_unlocked;
-			} else if (folio_test_writeback(folio)) {
-				xas_unlock_irq(&xas);
-				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-				goto xa_unlocked;
-			} else if (folio_trylock(folio)) {
-				folio_get(folio);
-				xas_unlock_irq(&xas);
-			} else {
-				result = SCAN_PAGE_LOCK;
-				goto xa_locked;
-			}
-		}
-
-		/*
-		 * The folio must be locked, so we can drop the i_pages lock
-		 * without racing with truncate.
-		 */
-		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-
-		/* make sure the folio is up to date */
-		if (unlikely(!folio_test_uptodate(folio))) {
-			result = SCAN_FAIL;
-			goto out_unlock;
-		}
-
-		/*
-		 * If file was truncated then extended, or hole-punched, before
-		 * we locked the first folio, then a THP might be there already.
-		 * This will be discovered on the first iteration.
-		 */
-		if (is_pmd_order(folio_order(folio))) {
-			result = SCAN_PTE_MAPPED_HUGEPAGE;
-			goto out_unlock;
-		}
-
-		if (folio_mapping(folio) != mapping) {
-			result = SCAN_TRUNCATED;
-			goto out_unlock;
-		}
-
-		if (!is_shmem && (folio_test_dirty(folio) ||
-				  folio_test_writeback(folio))) {
-			/*
-			 * khugepaged only works on clean file-backed folios,
-			 * so this folio is dirty because it hasn't been flushed
-			 * since first write.
-			 */
-			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-			goto out_unlock;
-		}
-
-		if (!folio_isolate_lru(folio)) {
-			result = SCAN_DEL_PAGE_LRU;
-			goto out_unlock;
-		}
-
-		if (!filemap_release_folio(folio, GFP_KERNEL)) {
-			result = SCAN_PAGE_HAS_PRIVATE;
-			folio_putback_lru(folio);
-			goto out_unlock;
-		}
-
-		if (folio_mapped(folio))
-			try_to_unmap(folio,
-					TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
-
-		xas_lock_irq(&xas);
-
-		VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);
-
-		/*
-		 * We control 2 + nr_pages references to the folio:
-		 *  - we hold a pin on it;
-		 *  - nr_pages reference from page cache;
-		 *  - one from lru_isolate_folio;
-		 * If those are the only references, then any new usage
-		 * of the folio will have to fetch it from the page
-		 * cache. That requires locking the folio to handle
-		 * truncate, so any new usage will be blocked until we
-		 * unlock folio after collapse/during rollback.
-		 */
-		if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
-			result = SCAN_PAGE_COUNT;
-			xas_unlock_irq(&xas);
-			folio_putback_lru(folio);
-			goto out_unlock;
-		}
-
-		/*
-		 * At this point, the folio is locked and unmapped. If the PTE
-		 * was dirty, try_to_unmap() has transferred the dirty bit to
-		 * the folio and we must not collapse it into a clean
-		 * file-backed folio.
-		 *
-		 * If the folio is clean here, no one can write it until we
-		 * drop the folio lock. A write through a stale TLB entry came
-		 * from a clean PTE and must fault because the PTE has been
-		 * cleared; the fault path has to take the folio lock before
-		 * installing a writable mapping. Buffered write paths also
-		 * have to take the folio lock before modifying file contents
-		 * without a mapping, typically via write_begin_get_folio().
-		 */
-		if (!is_shmem && folio_test_dirty(folio)) {
-			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-			xas_unlock_irq(&xas);
-			folio_putback_lru(folio);
-			goto out_unlock;
-		}
-
-		/*
-		 * Accumulate the folios that are being collapsed.
-		 */
-		list_add_tail(&folio->lru, &pagelist);
-		index += folio_nr_pages(folio);
-		continue;
-out_unlock:
-		folio_unlock(folio);
-		folio_put(folio);
-		goto xa_unlocked;
-	}
-
-xa_locked:
-	xas_unlock_irq(&xas);
-xa_unlocked:
-
-	/*
-	 * If collapse is successful, flush must be done now before copying.
-	 * If collapse is unsuccessful, does flush actually need to be done?
-	 * Do it anyway, to clear the state.
-	 */
-	try_to_unmap_flush();
-
-	if (result == SCAN_SUCCEED && nr_none &&
-	    !shmem_charge(mapping->host, nr_none))
-		result = SCAN_FAIL;
-	if (result != SCAN_SUCCEED) {
-		nr_none = 0;
-		goto rollback;
-	}
-
-	/*
-	 * The old folios are locked, so they won't change anymore.
-	 */
-	index = start;
-	dst = folio_page(new_folio, 0);
-	list_for_each_entry(folio, &pagelist, lru) {
-		int i, nr_pages = folio_nr_pages(folio);
-
-		while (index < folio->index) {
-			clear_highpage(dst);
-			index++;
-			dst++;
-		}
-
-		for (i = 0; i < nr_pages; i++) {
-			if (copy_mc_highpage(dst, folio_page(folio, i)) > 0) {
-				result = SCAN_COPY_MC;
-				goto rollback;
-			}
-			index++;
-			dst++;
-		}
-	}
-	while (index < end) {
-		clear_highpage(dst);
-		index++;
-		dst++;
-	}
-
-	if (nr_none) {
-		struct vm_area_struct *vma;
-		int nr_none_check = 0;
-
-		i_mmap_lock_read(mapping);
-		xas_lock_irq(&xas);
-
-		xas_set(&xas, start);
-		for (index = start; index < end; index++) {
-			if (!xas_next(&xas)) {
-				xas_store(&xas, XA_RETRY_ENTRY);
-				if (xas_error(&xas)) {
-					result = SCAN_STORE_FAILED;
-					goto immap_locked;
-				}
-				nr_none_check++;
-			}
-		}
-
-		if (nr_none != nr_none_check) {
-			result = SCAN_PAGE_FILLED;
-			goto immap_locked;
-		}
-
-		/*
-		 * If userspace observed a missing page in a VMA with
-		 * a MODE_MISSING userfaultfd, then it might expect a
-		 * UFFD_EVENT_PAGEFAULT for that page. If so, we need to
-		 * roll back to avoid suppressing such an event. Since
-		 * wp/minor userfaultfds don't give userspace any
-		 * guarantees that the kernel doesn't fill a missing
-		 * page with a zero page, so they don't matter here.
-		 *
-		 * Any userfaultfds registered after this point will
-		 * not be able to observe any missing pages due to the
-		 * previously inserted retry entries.
-		 */
-		mapping_rmap_tree_foreach(vma, mapping, start, end) {
-			if (userfaultfd_missing(vma)) {
-				result = SCAN_EXCEED_NONE_PTE;
-				goto immap_locked;
-			}
-		}
-
-immap_locked:
-		i_mmap_unlock_read(mapping);
-		if (result != SCAN_SUCCEED) {
-			xas_set(&xas, start);
-			for (index = start; index < end; index++) {
-				if (xas_next(&xas) == XA_RETRY_ENTRY)
-					xas_store(&xas, NULL);
-			}
-
-			xas_unlock_irq(&xas);
-			goto rollback;
-		}
-	} else {
-		xas_lock_irq(&xas);
-	}
-
-	if (is_shmem) {
-		lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
-		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
-	} else {
-		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
-	}
-	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
-
-	/*
-	 * Mark new_folio as uptodate before inserting it into the
-	 * page cache so that it isn't mistaken for an fallocated but
-	 * unwritten page.
-	 */
-	folio_mark_uptodate(new_folio);
-	folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
-
-	if (is_shmem)
-		folio_mark_dirty(new_folio);
-	folio_add_lru(new_folio);
-
-	/* Join all the small entries into a single multi-index entry. */
-	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
-	xas_store(&xas, new_folio);
-	WARN_ON_ONCE(xas_error(&xas));
-	xas_unlock_irq(&xas);
-
-	/*
-	 * Remove pte page tables, so we can re-fault the page as huge.  A caller
-	 * that wants the PMD mapped now is told to go and do that.
-	 */
-	retract_page_tables(mapping, start);
-	if (cc->policy.install_pmd)
-		result = SCAN_PTE_MAPPED_HUGEPAGE;
-	folio_unlock(new_folio);
-
-	/*
-	 * The collapse has succeeded, so free the old folios.
-	 */
-	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
-		list_del(&folio->lru);
-		lruvec_stat_mod_folio(folio, NR_FILE_PAGES,
-				      -folio_nr_pages(folio));
-		if (is_shmem)
-			lruvec_stat_mod_folio(folio, NR_SHMEM,
-					      -folio_nr_pages(folio));
-		folio->mapping = NULL;
-		folio_clear_active(folio);
-		folio_clear_unevictable(folio);
-		folio_unlock(folio);
-		folio_put_refs(folio, 2 + folio_nr_pages(folio));
-	}
-
-	goto out;
-
-rollback:
-	/* Something went wrong: roll back page cache changes */
-	if (nr_none) {
-		xas_lock_irq(&xas);
-		mapping->nrpages -= nr_none;
-		xas_unlock_irq(&xas);
-		shmem_uncharge(mapping->host, nr_none);
-	}
-
-	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
-		list_del(&folio->lru);
-		folio_unlock(folio);
-		folio_putback_lru(folio);
-		folio_put(folio);
-	}
-
-	new_folio->mapping = NULL;
-
-	folio_unlock(new_folio);
-	folio_put(new_folio);
-out:
-	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
-	return result;
-}
-
-static enum scan_result collapse_scan_file(struct mm_struct *mm,
-		unsigned long addr, struct file *file, pgoff_t start,
-		struct collapse_control *cc)
-{
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
-	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
-	struct folio *folio = NULL;
-	struct address_space *mapping = file->f_mapping;
-	XA_STATE(xas, &mapping->i_pages, start);
-	int present, swap;
-	int node = NUMA_NO_NODE;
-	enum scan_result result = SCAN_SUCCEED;
-
-	present = 0;
-	swap = 0;
-	collapse_control_init_scan(cc);
-	rcu_read_lock();
-	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
-		if (xas_retry(&xas, folio))
-			continue;
-
-		if (xa_is_value(folio)) {
-			swap += 1 << xas_get_order(&xas);
-			if (swap > max_ptes_swap) {
-				result = SCAN_EXCEED_SWAP_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
-				break;
-			}
-			continue;
-		}
-
-		if (!folio_try_get(folio)) {
-			xas_reset(&xas);
-			continue;
-		}
-
-		if (unlikely(folio != xas_reload(&xas))) {
-			folio_put(folio);
-			xas_reset(&xas);
-			continue;
-		}
-
-		if (is_pmd_order(folio_order(folio))) {
-			result = SCAN_PTE_MAPPED_HUGEPAGE;
-			/*
-			 * PMD-sized THP implies that we can only try
-			 * retracting the PTE table.
-			 */
-			folio_put(folio);
-			break;
-		}
-
-		node = folio_nid(folio);
-		if (collapse_scan_abort(node, cc)) {
-			result = SCAN_SCAN_ABORT;
-			folio_put(folio);
-			break;
-		}
-		cc->node_load[node]++;
-
-		if (!folio_test_lru(folio)) {
-			result = SCAN_PAGE_LRU;
-			folio_put(folio);
-			break;
-		}
-
-		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
-			result = SCAN_PAGE_COUNT;
-			folio_put(folio);
-			break;
-		}
-
-		/*
-		 * We probably should check if the folio is referenced
-		 * here, but nobody would transfer pte_young() to
-		 * folio_test_referenced() for us.  And rmap walk here
-		 * is just too costly...
-		 */
-
-		present += folio_nr_pages(folio);
-		folio_put(folio);
-
-		if (need_resched()) {
-			xas_pause(&xas);
-			cond_resched_rcu();
-		}
-	}
-	rcu_read_unlock();
-	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
-		cc->progress++;
-	else
-		cc->progress += HPAGE_PMD_NR;
-
-	if (result == SCAN_SUCCEED) {
-		if (present < HPAGE_PMD_NR - max_ptes_none) {
-			result = SCAN_EXCEED_NONE_PTE;
-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-		} else {
-			result = collapse_file(mm, addr, file, start, cc);
-		}
-	}
-
-	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
-	return result;
-}
-
-/*
- * Try to collapse a single PMD starting at a PMD aligned addr, and return
- * the results.
- */
-static enum scan_result collapse_single_pmd(unsigned long addr,
-		unsigned long end, struct vm_area_struct *vma,
-		bool *lock_dropped, struct collapse_control *cc)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	bool triggered_wb = false;
-	enum scan_result result;
-	struct file *file;
-	pgoff_t pgoff;
-
-	mmap_assert_locked(mm);
-
-	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_anon_pmd(vma, addr, end, cc);
-		if (!cc->select_orders)
-			goto end;
-
-		/* collapse_anon_pmd() takes mmap_lock itself, where it needs it */
-		mmap_read_unlock(mm);
-		*lock_dropped = true;
-
-		result = collapse_anon_pmd(mm, addr, end, cc);
-		goto end;
-	}
-
-	file = get_file(vma->vm_file);
-	pgoff = linear_page_index(vma, addr);
-
-	mmap_read_unlock(mm);
-	*lock_dropped = true;
-retry:
-	result = collapse_scan_file(mm, addr, file, pgoff, cc);
-
-	/* Dirty pages are worth a writeback and one more try, if asked for */
-	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
-	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
-		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
-		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
-
-		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
-		triggered_wb = true;
-		goto retry;
-	}
-	fput(file);
-
-	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
-		mmap_read_lock(mm);
-		if (collapse_test_exit_or_disable(mm))
-			result = SCAN_ANY_PROCESS;
-		else
-			result = try_collapse_pte_mapped_thp(mm, addr,
-							cc->policy.install_pmd);
-		if (result == SCAN_PMD_MAPPED)
-			result = SCAN_SUCCEED;
-		mmap_read_unlock(mm);
-	}
-end:
-	return result;
-}
-
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
-- 
2.54.0


