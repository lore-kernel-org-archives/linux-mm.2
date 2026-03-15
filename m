Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2376F30273
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 05:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3BF6B0122; Mon, 16 Mar 2026 01:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16D46B0125; Mon, 16 Mar 2026 01:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4B16B0126; Mon, 16 Mar 2026 01:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 965F46B0122
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 01:56:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40040140DE2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:56:52 +0000 (UTC)
X-FDA: 84550867464.13.116C238
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C0AE20002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:56:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CXDBG/Vp";
	spf=pass (imf03.hostedemail.com: domain of devnull+lenohou.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+lenohou.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773640610;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxer0NfzQZDdup4NesOsAaWG/3EWcxqGhLoPWPxbEhE=;
	b=REem3zndPsKx6snhkg1fx1EGhFwJKz0yA7L8CBz5//NMGERjN09CbiH2pLabMpomRowdl/
	KXwtWDrmt6Rbrz4nEIyE94pq+4pba/p3HxxL1ZhOmWGsxSpUymD/eiAmfXjZmpCRuLZj82
	2A3OAwxA7jryEeSQl8pjoBOcGJ/yHJg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CXDBG/Vp";
	spf=pass (imf03.hostedemail.com: domain of devnull+lenohou.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+lenohou.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773640610; a=rsa-sha256;
	cv=none;
	b=I/cHV1yCx4rAc4S6XCQR83MMrbEjLB917VzdTBTNBVcW+E1LBK5/A1ydjj8hTl5YvKy73J
	TkhGbqmBBCqt7yLzZ7wm1hTmZZS821x9pcL5dMgGcrG+KdiGW5+4MVMNGX/xApuvE0O9lc
	P4QIF1AkhP7H0yKgRxDXq1ogF0qcJ+s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B8A8600AC;
	Mon, 16 Mar 2026 05:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B215C2BC9E;
	Mon, 16 Mar 2026 05:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773640609;
	bh=TlMsf3YX4/n1Rdmd1W9Puqt05NoyrFspFfZYJm+GiSk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CXDBG/VpOQ7/5e6+al5KRqxqyApvmdbbjuLoQyBm6fCj/tKn3D40M4b+Z0bNe5Wl9
	 NTDknIAoZ/tp+BEv9deBUK5MsJGRj+g2eDLbT8mI/lgytWl4tGsXRyaHEZGaTKV3Nc
	 SCFpF08Gn1cMsE1dagNg6wPjC6Q1VgbiYq68mEFiGm+F9NLUHeWM638CvM01aMRcZO
	 3A8pp71xiupJRI7EtKMnpQ8iZnLHIdwKE5YSnCHeUL8ey/4S/a0egcU6Y1TBUyKUu/
	 xpfB9k6SlloQTLdD2k1dZrZzVGCAnCsnlgwTtrCQ5wcry/PNaeUN7sNMsZDuyqIZxN
	 2i3r5nP0OnaKA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26375D58B37;
	Mon, 16 Mar 2026 05:56:49 +0000 (UTC)
From: Leno Hou via B4 Relay <devnull+lenohou.gmail.com@kernel.org>
Date: Mon, 16 Mar 2026 02:18:28 +0800
Subject: [PATCH v3 1/2] mm/mglru: fix cgroup OOM during MGLRU state
 switching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260316-b4-switch-mglru-v2-v3-1-c846ce9a2321@gmail.com>
References: <20260316-b4-switch-mglru-v2-v3-0-c846ce9a2321@gmail.com>
In-Reply-To: <20260316-b4-switch-mglru-v2-v3-0-c846ce9a2321@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Jialing Wang <wjl.linux@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>, 
 Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Leno Hou <lenohou@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773598759; l=11348;
 i=lenohou@gmail.com; s=20260311; h=from:subject:message-id;
 bh=kyuspqsl57CQHhG9arU0ApaAlBWfHd4kjkO+N+OYlnQ=;
 b=lJZQoqkROXtQJhx/pEQq7aliD0NS8u0fPJ1wpQyQwBo9/YPQsBfBhdCAFEeVPzqdPIsBP/NDB
 5JrJ1B8hIlTAtZBmWasqTgSBzV0uMKjPPFp7/YxZuRrvgduiYgtTHf7
X-Developer-Key: i=lenohou@gmail.com; a=ed25519;
 pk=8AVHXYurzu1kOGjk9rwvxovwSCynBkv2QAcOvSIe1rw=
X-Endpoint-Received: by B4 Relay for lenohou@gmail.com/20260311 with
 auth_id=674
X-Original-From: Leno Hou <lenohou@gmail.com>
Reply-To: lenohou@gmail.com
X-Stat-Signature: minxp1jori4emtcsrcpg37bpjzryw5yu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C0AE20002
X-HE-Tag: 1773640610-805494
X-HE-Meta: U2FsdGVkX18Z75xHMKCGbdiS94RO3X5B6DmEIamfwyJNw7oyue8o8eM6A1NBEicDx27Uxc0KeSOnyzdnChARbz8A/4VGqShQZB2gNeNJxIys1RE4y3767HwyW4QysTTd8QlgngdSoA6SubULkCPdO98UeVpD0nI5yOLqMGAjtEAHPISm3rroA8Q5HWm7WT4dRZ457Y7pd8HIH1+gmUS/XAZbvbsh/r/2w6ujruL7qNh61vI6XIFqRyWQiaa2bTaDPgnZn96LKl0tgsns25qEwZHTddKFu1Ghyd70gBFANnsSZbkY2nHYuoocu0YFbweZtQ6h86iOOWWJJMozVIb9HQmrBsC5njkwvNywHNbWyBtVpUpgGAKXdWnko/5ITeeD84Txh7/DQFuUjCdq2CG8qaOYdc9RbmM5MULKE/QuKXn14Fb7k8I2CpdMkDSeYaF8BmA2oUtlDUgX4yHULwSk+kbII0Gf7lROWW1VbdtilrqPV4XPRbgx6t1fLXv+mKsPP/ChWjFveeD6SMXW8H93Gh13847IJcS285LQW+/UlBIVA1N7IdOdZZqWxIpjUiCTOhZweSqV8b8jq+zzCU/86R1jXk0HSW2mJ1x8BlAFVCG0+KtfP6P48U92xxAqXdsA4QSU8JHlfvzNJxo/0KBjfYE9SxHICKOapOAhukFu+zys87Jl14rXghzZVapmifOMtsa3zGbjqWDO/1mAuEcQxrXM7aZ7ANc77t+BvQTJabwPPF04neCGdAsaIbDbiJZpiQpBPX6A1fPR5bcFuscWn+E95Os+oqSHaLjADi8w/hVta0QwCjfZgP1eVOU5pglf3+LuyMPiGVSL2jKJt5Zzyf8+Esi4LDRfmfMZggRIAMGn8pxMbmyJwv+xFDoecF32jYC3yXIhMjL4wmUtePxACp3aovM8h5uiNIwXe6T4NkZFw4QShhaqdC8zBpJbktp66I9d9MT3upCd06hSQ3I
 21zKzJXy
 XplkNxmSEtWZQ2Qspd49LEB0ny5DP8Cr+g0AbMWllUA9JcQo3zy3vNTMFa9YwTHzd0lAj5o5eI0+zPwRUPhXGu7QjKLqhYtwhMNNnBRvlS8Vwj0tTOcUfhBVyuijI+7VTZnMrjTp9kSnzrzPE5W5/yPBgU2LHIIOEYhIaHuuggoz+ZwwMmptZaFiMXmjJYULxmMiSvY6eY3pMtsCZgwTA5rNBRnK6zFriuIjmeEPWM/exPeqTG3pntX6gjGYhTxYvFFNbABQsfHG3yftv6pTtwufXS8medKUmjv6C/KCe5h9+16+Svr/fRFeIf470QytH+tyV0QEkgodMq0XVwZiNQPmAsUnr0CH3Da3xkP4uKgII0nBgvUqdecxu7+jzBTx8MoUsmPCIbw13saUi714om5DK791pBBS6fJUb7MeHXyqiy/eJVjHGylfwL1hQgF0LG5mInb4Wjcigq8NG+ePMTjEDbaRz4nY9TJfZefwPN2uC1ZYQl12vAaR6qZCELYTKl0Tz7s9sObiMf7zLQef4O4clJayl5i21sYseA7QwkU9oeSUqby/e6vCeMDynlm7Tq22L36zWeA4pUpNUt/swk4AkH4o6mxVwvyfxYY1gUWapWqlAXMn9Q/p0ISRwpclJtdEt1Oyu1kmX9Ai2AtOy4unI/eE5fFVA1gpRudG2TMYSb4CqQrt4E7ZjWqST67Z8nNBRvNEVj6MAJWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leno Hou <lenohou@gmail.com>

When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
condition exists between the state switching and the memory reclaim path.
This can lead to unexpected cgroup OOM kills, even when plenty of
reclaimable memory is available.

Problem Description
==================

The issue arises from a "reclaim vacuum" during the transition.

1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled to
   false before the pages are drained from MGLRU lists back to traditional
   LRU lists.
2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as false
   and skip the MGLRU path.
3. However, these pages might not have reached the traditional LRU lists
   yet, or the changes are not yet visible to all CPUs due to a lack
   of synchronization.
4. get_scan_count() subsequently finds traditional LRU lists empty,
   concludes there is no reclaimable memory, and triggers an OOM kill.

A similar race can occur during enablement, where the reclaimer sees the
new state but the MGLRU lists haven't been populated via fill_evictable()
yet.

Solution
========

Introduce a 'draining' state (`lru_drain_core`) to bridge the transition.
When transitioning, the system enters this intermediate state where
the reclaimer is forced to attempt both MGLRU and traditional reclaim
paths sequentially. This ensures that folios remain visible to at least
one reclaim mechanism until the transition is fully materialized across
all CPUs.

Changes
=======

v3:
 - Rebase onto mm-new branch for queue testing
 - Don't look around while draining
 - Fix Barry Song's comment

v2:
- Repalce with a static branch `lru_drain_core` to track the transition
  state.
- Ensures all LRU helpers correctly identify page state by checking
  folio_lru_gen(folio) != -1 instead of relying solely on global flags.
- Maintain workingset refault context across MGLRU state transitions
- Fix build error when CONFIG_LRU_GEN is disabled.

v1:
- Use smp_store_release() and smp_load_acquire() to ensure the visibility
  of 'enabled' and 'draining' flags across CPUs.
- Modify shrink_lruvec() to allow a "joint reclaim" period. If an lruvec
  is in the 'draining' state, the reclaimer will attempt to scan MGLRU
  lists first, and then fall through to traditional LRU lists instead
  of returning early. This ensures that folios are visible to at least
  one reclaim path at any given time.

Race & Mitigation
================

A race window exists between checking the 'draining' state and performing
the actual list operations. For instance, a reclaimer might observe the
draining state as false just before it changes, leading to a suboptimal
reclaim path decision.

However, this impact is effectively mitigated by the kernel's reclaim
retry mechanism (e.g., in do_try_to_free_pages). If a reclaimer pass fails
to find eligible folios due to a state transition race, subsequent retries
in the loop will observe the updated state and correctly direct the scan
to the appropriate LRU lists. This ensures the transient inconsistency
does not escalate into a terminal OOM kill.

This effectively reduce the race window that previously triggered OOMs
under high memory pressure.

To: Andrew Morton <akpm@linux-foundation.org>
To: Axel Rasmussen <axelrasmussen@google.com>
To: Yuanchu Xie <yuanchu@google.com>
To: Wei Xu <weixugc@google.com>
To: Barry Song <21cnbao@gmail.com>
To: Jialing Wang <wjl.linux@gmail.com>
To: Yafang Shao <laoar.shao@gmail.com>
To: Yu Zhao <yuzhao@google.com>
To: Kairui Song <ryncsn@gmail.com>
To: Bingfang Guo <bfguo@icloud.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Leno Hou <lenohou@gmail.com>
---
 include/linux/mm_inline.h | 16 ++++++++++++++++
 mm/rmap.c                 |  2 +-
 mm/swap.c                 | 15 +++++++++------
 mm/vmscan.c               | 38 +++++++++++++++++++++++++++++---------
 4 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ad50688d89db..16ac700dac9c 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -102,6 +102,12 @@ static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
 
 #ifdef CONFIG_LRU_GEN
 
+static inline bool lru_gen_draining(void)
+{
+	DECLARE_STATIC_KEY_FALSE(lru_drain_core);
+
+	return static_branch_unlikely(&lru_drain_core);
+}
 #ifdef CONFIG_LRU_GEN_ENABLED
 static inline bool lru_gen_enabled(void)
 {
@@ -316,11 +322,21 @@ static inline bool lru_gen_enabled(void)
 	return false;
 }
 
+static inline bool lru_gen_draining(void)
+{
+	return false;
+}
+
 static inline bool lru_gen_in_fault(void)
 {
 	return false;
 }
 
+static inline int folio_lru_gen(const struct folio *folio)
+{
+	return -1;
+}
+
 static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
 {
 	return false;
diff --git a/mm/rmap.c b/mm/rmap.c
index 6398d7eef393..0b5f663f3062 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -966,7 +966,7 @@ static bool folio_referenced_one(struct folio *folio,
 			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
 		}
 
-		if (lru_gen_enabled() && pvmw.pte) {
+		if (lru_gen_enabled() && !lru_gen_draining() && pvmw.pte) {
 			if (lru_gen_look_around(&pvmw, nr))
 				referenced++;
 		} else if (pvmw.pte) {
diff --git a/mm/swap.c b/mm/swap.c
index 5cc44f0de987..ecb192c02d2e 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -462,7 +462,7 @@ void folio_mark_accessed(struct folio *folio)
 {
 	if (folio_test_dropbehind(folio))
 		return;
-	if (lru_gen_enabled()) {
+	if (folio_lru_gen(folio) != -1) {
 		lru_gen_inc_refs(folio);
 		return;
 	}
@@ -559,7 +559,7 @@ void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
  */
 static void lru_deactivate_file(struct lruvec *lruvec, struct folio *folio)
 {
-	bool active = folio_test_active(folio) || lru_gen_enabled();
+	bool active = folio_test_active(folio) || (folio_lru_gen(folio) != -1);
 	long nr_pages = folio_nr_pages(folio);
 
 	if (folio_test_unevictable(folio))
@@ -602,7 +602,9 @@ static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
 
-	if (folio_test_unevictable(folio) || !(folio_test_active(folio) || lru_gen_enabled()))
+	if (folio_test_unevictable(folio) ||
+		!(folio_test_active(folio) ||
+		(folio_lru_gen(folio) != -1)))
 		return;
 
 	lruvec_del_folio(lruvec, folio);
@@ -617,6 +619,7 @@ static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
 static void lru_lazyfree(struct lruvec *lruvec, struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
+	int gen = folio_lru_gen(folio);
 
 	if (!folio_test_anon(folio) || !folio_test_swapbacked(folio) ||
 	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
@@ -624,7 +627,7 @@ static void lru_lazyfree(struct lruvec *lruvec, struct folio *folio)
 
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
-	if (lru_gen_enabled())
+	if (gen != -1)
 		lru_gen_clear_refs(folio);
 	else
 		folio_clear_referenced(folio);
@@ -695,7 +698,7 @@ void deactivate_file_folio(struct folio *folio)
 	if (folio_test_unevictable(folio) || !folio_test_lru(folio))
 		return;
 
-	if (lru_gen_enabled() && lru_gen_clear_refs(folio))
+	if ((folio_lru_gen(folio) != -1) && lru_gen_clear_refs(folio))
 		return;
 
 	folio_batch_add_and_move(folio, lru_deactivate_file);
@@ -714,7 +717,7 @@ void folio_deactivate(struct folio *folio)
 	if (folio_test_unevictable(folio) || !folio_test_lru(folio))
 		return;
 
-	if (lru_gen_enabled() ? lru_gen_clear_refs(folio) : !folio_test_active(folio))
+	if ((folio_lru_gen(folio) != -1) ? lru_gen_clear_refs(folio) : !folio_test_active(folio))
 		return;
 
 	folio_batch_add_and_move(folio, lru_deactivate);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33287ba4a500..bcefd8db9c03 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -886,7 +886,7 @@ static enum folio_references folio_check_references(struct folio *folio,
 	if (referenced_ptes == -1)
 		return FOLIOREF_KEEP;
 
-	if (lru_gen_enabled()) {
+	if (lru_gen_enabled() && !lru_gen_draining()) {
 		if (!referenced_ptes)
 			return FOLIOREF_RECLAIM;
 
@@ -2286,7 +2286,7 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 	unsigned long file;
 	struct lruvec *target_lruvec;
 
-	if (lru_gen_enabled())
+	if (lru_gen_enabled() && !lru_gen_draining())
 		return;
 
 	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
@@ -2625,6 +2625,7 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
 
 #ifdef CONFIG_LRU_GEN
 
+DEFINE_STATIC_KEY_FALSE(lru_drain_core);
 #ifdef CONFIG_LRU_GEN_ENABLED
 DEFINE_STATIC_KEY_ARRAY_TRUE(lru_gen_caps, NR_LRU_GEN_CAPS);
 #define get_cap(cap)	static_branch_likely(&lru_gen_caps[cap])
@@ -5318,6 +5319,8 @@ static void lru_gen_change_state(bool enabled)
 	if (enabled == lru_gen_enabled())
 		goto unlock;
 
+	static_branch_enable_cpuslocked(&lru_drain_core);
+
 	if (enabled)
 		static_branch_enable_cpuslocked(&lru_gen_caps[LRU_GEN_CORE]);
 	else
@@ -5348,6 +5351,9 @@ static void lru_gen_change_state(bool enabled)
 
 		cond_resched();
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+
+	static_branch_disable_cpuslocked(&lru_drain_core);
+
 unlock:
 	mutex_unlock(&state_mutex);
 	put_online_mems();
@@ -5920,9 +5926,12 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	bool proportional_reclaim;
 	struct blk_plug plug;
 
-	if (lru_gen_enabled() && !root_reclaim(sc)) {
+	if ((lru_gen_enabled() || lru_gen_draining()) && !root_reclaim(sc)) {
 		lru_gen_shrink_lruvec(lruvec, sc);
-		return;
+
+		if (!lru_gen_draining())
+			return;
+
 	}
 
 	get_scan_count(lruvec, sc, nr);
@@ -6181,11 +6190,17 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	unsigned long nr_reclaimed, nr_scanned, nr_node_reclaimed;
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
+	s8 priority = sc->priority;
 
-	if (lru_gen_enabled() && root_reclaim(sc)) {
+	if ((lru_gen_enabled() || lru_gen_draining()) && root_reclaim(sc)) {
 		memset(&sc->nr, 0, sizeof(sc->nr));
 		lru_gen_shrink_node(pgdat, sc);
-		return;
+
+		if (!lru_gen_draining())
+			return;
+
+		sc->priority = priority;
+
 	}
 
 	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
@@ -6455,7 +6470,7 @@ static void snapshot_refaults(struct mem_cgroup *target_memcg, pg_data_t *pgdat)
 	struct lruvec *target_lruvec;
 	unsigned long refaults;
 
-	if (lru_gen_enabled())
+	if (lru_gen_enabled() && !lru_gen_draining())
 		return;
 
 	target_lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
@@ -6844,10 +6859,15 @@ static void kswapd_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
+	s8 priority = sc->priority;
 
-	if (lru_gen_enabled()) {
+	if (lru_gen_enabled() || lru_gen_draining()) {
 		lru_gen_age_node(pgdat, sc);
-		return;
+
+		if (!lru_gen_draining())
+			return;
+
+		sc->priority = priority;
 	}
 
 	lruvec = mem_cgroup_lruvec(NULL, pgdat);

-- 
2.52.0



