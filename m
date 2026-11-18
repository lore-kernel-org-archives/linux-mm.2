Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6E1606A334
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EtbFjblN
Received: by kanga.kvack.org (Postfix)
	id 2A4DC6B05C1; Wed, 18 Nov 2026 16:03:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27BA66B05C2; Wed, 18 Nov 2026 16:03:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1916E6B05C3; Wed, 18 Nov 2026 16:03:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B339A6B05C2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:03:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB6E51605D6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:56 +0000 (UTC)
X-FDA: 85449466872.20.C19C6B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id ACDFB40005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EtbFjblN;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795035834;
	b=SL7W9kJcKuzQBhO+uPFGku3Pb/kimstYctwEtgPdONk2ikw10SnNKO8QACXMVs5nOge/A2
	SnaCiwJhBNv8umvjBVGbC2Y33Rl0eljMlc9lp5K+jgNqRcoledy1noGmhOC1oo7sbvak7Q
	tH6Lu0icEvHODIN1owglhtNVn8y1S9g=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EtbFjblN;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795035834;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYyINE7jQPx2L1Va5b9g3LdqA+A1T8KDOMXxQcugP40=;
	b=i6suhYIw74AYvADRjHoOtYNjFGFRlmV4bRrRpzk1lQ4ZZLsxsbstJF7bov2QE8+URGNIOM
	XKXGwzm6WKTM741uW5GLu+E7pkNmIYGjOaL9h+aF3pEWWUJDJ8MEcYqvFDTKyapg0hfk7Z
	vNf+KoUjn8xh8Q8rEPnkwROcU6Bu0oI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 744BE47598;
	Wed, 18 Nov 2026 21:03:54 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035834;
	b=kll0KWkyO2PheqQQOHxGrKR3EJkEwmCMd3Bc9/1PhpdsI3j3b+n5g2Wk7pjuLeR5wMky
	 IGE8qDumObL6mwdksDjQQoYaC9rZiYmIKPmxT5Xam1xixpOWr6bC0MUBRzbmTREfAmr3Z
	 pWUszva/4nlZDPdMfVeC9L7lCExd0oAyWQ4wpcnFfMyYOWVRs8L+tcN1YqkqE1PlDNAUd
	 A6etILZUF6bnO3IVF1Ytj3lMZi/WwTwET1sBmod8nqH6BtFc7lRDu7jyVYTbhjkWnfpOM
	 5QIPs74ibemT7fH2x8Exopn0PC70Wa5/r9R/PHoJ9dRebgz934SKkA/AzvBahdk6xmg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035834;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=KYyINE7jQPx2L1Va5b9g3LdqA+A1T8KDOMXxQcugP40=;
	b=uLkGPtZkGvOLBHeyhaPzdvHUzvjRWzySMokjUnK7atmrjPJtiqzfUvtTz8ew919O30Zd
	 L6+eUb/1jjusAQa50A5QpB8pD7Q+6pn4jRxXhDs6c/27mpqCwFLyWaAeKWIuLuR0K2FAf
	 NbbONfLaRWG0KbN37H+bf614b7mqkHNLzWm+hVqGaQP5lR1O7MIYP9pp/TwaMqQDtokzR
	 twF1T4QQdq3dSD+zurGESf+ZLrjV+PbkOvkHc6wJD9I7XTWxi+iXZWaR+CmrgQozl71Re
	 URj25tCK2HEv3zY/5DoNst10z0nFN2ZyEeaN1RDU19e911poSBWZTEGYxV/p6Gw7DVA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DCA831F01576;
	Wed, 18 Nov 2026 21:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035834;
	bh=KYyINE7jQPx2L1Va5b9g3LdqA+A1T8KDOMXxQcugP40=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=EtbFjblN9nh5D4fls+VqfJTr0ROzGqSgQ/csxbhyAEuejXIST61I/ijBffbEKNvV0
	 xKIMI/BRLExDws13JnyxSr35g90oBzfO8fOmqOQW1rxHmAkVJiwjcjfvvU/AoI9YbM
	 WziZ8MkNhJCO60Va3htwrpMJ8ObYHt9Z6Dc4O+n0SgubwCdwvCi/xKY1jwY1qPL3+S
	 ehPfZR4Z/yyWXlIyboi1qdEdHUS64cZaUrokmPKICh7VrZ351Crd5WvW0+LzvwzAzt
	 Em4QyfduKrQq3MWCEkwAqpCfyOSQubE/fbICSIQypL5f4VsDcJdVxs3JNZQ6PgIt29
	 EM/sfXH+g3w/w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1FC7D4AFAC;
	Wed, 18 Nov 2026 21:03:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:42 +0800
Subject: [PATCH v5 10/17] mm/mglru, smaps: convert to LRU refs based
 operations for MGLRU
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261119-mglru-fg-v5-10-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=3775;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=VfESysdUSKNXugn/NNka7t20akprAGwUFTR67FoqbQg=;
 b=H/mlewAs5YjJbFgVwQ+pifGag4czhOpjZorx0B42RAmT7qz/Hj/bOIhUZb9NbEASZ65gD+Ksk
 v1bQBrilAKvAWuGJBDPUYmCJ52LsSbiUmfk07pf4LJFpIAUy3Pk/ugH
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ACDFB40005
X-Stat-Signature: qtdywfwbnezfx7ijhk1sai8acqu6rsxz
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795035834-990020
X-HE-Meta: U2FsdGVkX19pLIbgfYt/s7z8tSm9xMAoM6CDWVabobsW2nUU5roANxNvUWl0k/v0b9YPeQI2KAMXYdJtG1XglIZ0alGoJV1qTEwsiH00xk3yYux3BTE3QudWXIZ08plDHieJLPWLEgwSZBIx2og2CwkewH0Boe1XBVpAq6jof/cOUOXmL+9Rl6j4fcuMfMjGcWrGTyymz3zB5nGTawm7/hJ0E9w3XYRg9RXNyELjC3kAMGUc6J74Dz+oqkhg5HpjBBEn/TWPCAGJz9tulsHbJUFjTl7GDWalzZFPCYATk/gdXO4jWshiotSmCREOgmIqVxp3oBO94rZ56Kyp4S7j/X1VdN4gCxUQG92Pr/IMMri9ROPPGxrm3eOXKTwYd17up9KvhqY399Y1KQ0VDc5MIsOIZopcPHhrF5504MMyXl8E5r1HhagxuQiub+LIoGf5XENZUix7rkb94jqJE+7ELgflfdB0LmRLJsmoJyBLYKSGobCDW/9adpNwZwikG+spcUZfRvkAOMHKFq1alt3StMXAl3HsUjKpw+OeyN1UZZ57Mcml3gmTEJjfBaAVFGRiq1eozF/7CtE+2ZI51xkQWYzdG40IcLnJNO7g7+9WY8jUzESUDK524BXieCAmxoJ42pPsVrY/Js8LiH5ijnPHgGmOtoc5YfHUAxDNt44cUjoQryZbgj8IhNi1HIR+IaCKfIjtWOSYTq6Nstlk7cLYwT1Kc3vbfxsiUpbMRFM73cXO5bewvx3VjDjHyPPS8vboyRZIqJJR3UZEpi4BdPHlBr4GLuI9vJRsdx6NmQRVGYesFvem+1DwJ9rWaTyrRi6a0mM/Q5n2u9YsOTxeF1GdArd9WuCdUaYButycxpzTKZU63oS6NoGtPEz5r2OtgIu4Q9MVIh1K0vU/d2aV/MZiPOLSxUFjexOI5kn0TFDYhT9bjVRhDwXSq5O4Msy77XusurqyOI8Cga9dJew4wp4
 ExIsNjie
 saGd03zKDmX63wKLLub2jwt61BOLNcK1nZyRbcdrLxFDVWQSaO8xN8CR5jcTGAvYJkImRxuq82+1s5rk0DB8IZKb1tTwMKoEq2xfaD6vjmjxfcArbm9c0NTFwLLELj6jcaUyWADI/9S66OrVkBleZ+YhVP+RZQQoZloZoQsnYYc0hMSyJY9QbTK4thdQwqcgUusB8hub1WsCgq1kSFyOJdAVnW12I3yL3bfsHI6dc1uXqGYo5mLwsbVJvD1dYRFQblugZbePMtbfAoX+qiqrJcY6iJ2lL5jNKY9iz3RWH2P4nFywLziNNdUViEqHxi7i/P8DYJ3xaaVY5NRfyp8ROYEBL9LXyB3rA7Rl7k9cOYQhZFMTmVO3LQCD5EZuIil4U8VdHONM0W3B2kWNYK03O1Lc5tYB5HYc42thmnNbKsRKdVpKy1L3mnnV1pDGNyB+dhm3lEvfdOXqhtCXkMe+hV1VwODJSrdQkvm2I3CeXlnf3/O5NMoQ1tMZ8ux397v9/r2CR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

PG_referenced is only the lowest bit of the folio LRU refs count
(LRU_REFS_FLAGS) now, and MGLRU never kept it stable: promotion used to
clear it, and now it toggles as the count grows. But with the LRU
referenced count as a stable API now, we can use two helpers to provide
in-kernel users a stable and sane reading of the referenced status of
an LRU managed folio.

Add folio_check_lru_refs() and folio_clear_lru_refs(), which use the refs
count when MGLRU is enabled and PG_referenced otherwise, and switch the
smaps paths over to them. The lru_gen_enabled() test stays inside the
helpers, so its static key is not splattered over the few call sites.

Convert smaps as the first user of them. MGLRU now reports every folio
with a nonzero count, so the reading no longer flickers and clearing no
longer results in an ambiguous status.

The classical LRU case is unchanged.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/proc/task_mmu.c        |  6 +++---
 include/linux/mm_inline.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 22361607020d..f76a37d052b1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -889,7 +889,7 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || folio_test_young(folio) || folio_test_referenced(folio))
+	if (young || folio_test_young(folio) || folio_check_lru_refs(folio))
 		mss->referenced += size;
 
 	/*
@@ -1686,7 +1686,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		folio_clear_lru_refs(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1715,7 +1715,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		folio_clear_lru_refs(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 3323a3c7336b..14aab2b1ed08 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -508,6 +508,37 @@ static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
+/**
+ * folio_check_lru_refs - Test if an LRU managed folio has been referenced.
+ * @folio: The folio to test.
+ *
+ * Returns true if the MGLRU refs count is nonzero, or PG_referenced is set,
+ * which is also correct for the non-MGLRU case. Kept as a separate helper,
+ * to avoid splattering the lru_gen_enabled() static key.
+ */
+static inline bool folio_check_lru_refs(const struct folio *folio)
+{
+	if (lru_gen_enabled())
+		return folio_lru_refs(folio) > 0;
+	return folio_test_referenced(folio);
+}
+
+/**
+ * folio_clear_lru_refs - Clear the referenced state of an LRU managed folio.
+ * @folio: The folio to clear.
+ *
+ * Reset the MGLRU refs count to zero, or clear PG_referenced, leaving
+ * PG_workingset alone for the non-MGLRU case. Kept as a separate helper
+ * just like folio_check_lru_refs().
+ */
+static inline void folio_clear_lru_refs(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, 0);
+	else
+		folio_clear_referenced(folio);
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {

-- 
2.56.1



