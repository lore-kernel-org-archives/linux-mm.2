Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE4DEC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6506B00A4; Tue, 29 Sep 2026 04:00:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE5A6B00A5; Tue, 29 Sep 2026 04:00:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D44F6B00A6; Tue, 29 Sep 2026 04:00:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 297406B00A4
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:00:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DF3612043E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:00:15 +0000 (UTC)
X-FDA: 85266051990.04.CE4A3E8
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	by imf09.hostedemail.com (Postfix) with ESMTP id 81651140005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:00:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=xRYOB77s;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf09.hostedemail.com: domain of leizongkun@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=leizongkun@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VfTwtgaqFhP0XgfTY57FMkq9TvriF8OOY+/foM+bTxk=;
	b=xniYvcWyyXWykkuVMUKiEGsjTE1w4XGD5KP8VKge1eUrqsYqxuT2bCSnCGolNlxGFGsIar
	/ZATLJD3jDcXrFKDW2gN9JVLbFBLr23pl8sl3y+jf/+QGqXtGoX3MAruZa4oJl1hWMWNqB
	Xj+U6L9Np8HAVKQs3CyW/m27rLSKV2U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=xRYOB77s;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf09.hostedemail.com: domain of leizongkun@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=leizongkun@qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668813;
	b=F2niPhh1Pj5dPqT+bMnjgS2rieBEsuSQij6ZH2wbgANqEUZc40n2oEhchIxvo8C9EyZRkg
	EAwsiJohx16X2fUOomJbIvYTzpHyR88O2WRMALLQpjF0tpAO46DL+B1LqyWVb5vCXlKgTw
	+mf/w5LIPt5+FJ52lUVPnodttTs64O8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790668809; bh=VfTwtgaqFhP0XgfTY57FMkq9TvriF8OOY+/foM+bTxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xRYOB77smmWG72k+2IDVRdKa86f3wKXidcgw2+7NSIUeOddImUMxESx30A/O0/EQs
	 qTcctC54eM4m1oUVZF6MobNlThO5hNeCHW73JYz9J0JqyZHSj9h2V5tZC6OlB8T1Do
	 zLwTHVypJopt/PzwYU4LWPw1AB43MEUM2eOW9llg=
Received: from lzk-B860M-AORUS-PRO-WIFI7 ([2409:8a28:a83:5ba1:514f:5353:e14b:594e])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 2B48A0; Tue, 29 Sep 2026 16:00:02 +0800
X-QQ-mid: xmsmtpt1790668802tp4qo867l
Message-ID: <tencent_A5FBB2ED9BEA2675E50B994FB6E928A71A07@qq.com>
X-QQ-XMAILINFO: NxF5De9alh3HaNk/wflERZXSEFLrnbTepwBGxqlvRXz7catyNQqvZDYgyjcaL/
	 k8oX6CZsjmQnOm135jSK+ZxufxqTq+yo94WdR7Okm74BUMeoxku8zJLiD8SCYD1XQSoYTkLMPjC4
	 XG6TWtCxhaNQ3Jeu4wJKrzqMNMsyFVqqkvsi9S/pSlxdhrG8FJTW+kGQK8tHDgGXT002AkuISOkn
	 knmzsdPSofPt6OYOg0ksIQJdIRrzNc779Hbn09NKxsNwM+bfKsyUlmEVQgMy1iHAAzkyRbnzxdzM
	 +H4a3FbNcZFmwNFhJqLP0I75jyAj5xQAk3e9rIcCLgL0uxjT7tznx41DuuxzyEzRiTcqkukCLLed
	 fvijSn78wILj9MfEpSVHfkSnZdroq0Hi9a1h+iWGQqeflEleov4W3Vsx36NUgvsparfjAB5hTFUr
	 NwM3t7BWS3jLIc5KL+nKpElB2nCs2u0WifMVYG+BbHPa8nSS8l/XiYzCTAS3qccY3Pdd2iPRPO7m
	 XtSsNOJyNUWfiGKSD0G7qz39b8HL6WxVCeZ9eFBBLth9kyQwZxtRs6IIHEoPdBgweYugb1HHWu/y
	 CWnNDxGUivCw/CQSpiZGErdZvuXSQEMS6C8eRYdlMgNYKFDK8vv+sXQGJovL1FmIWINJ6180Koi6
	 X1pV32aWF1/VxJ5pMlP7Tsm4RsJSKfLa+ipm69J+9XPTM8Kpx5pZuyk1LF8INkFo+chL+lEwt1GT
	 hDqLbccog8/6MGckETy/vbk7NQJl8KHVp50HDaI+IXeKOVOwYhKDzh+S7H6fTj90AkVpb4z02qKM
	 wAZIRfJ4Ch6nm2r7tK/vDeUeKZCPFtxm8ynv4/uECW2KVpqAENXVAPmkGGYQ0AllDUql2oIMf947
	 3h5XH51KCDK6iWbfC3VJYVBWGQvaFTfbelIDO7/DTqwroJZnAcOQ+Bxi+0uvnblf+nfuaqM+UwOD
	 N3aOmdDh2aOfui/Yoa4Pr0Z4HjoTTQHPNKLZBoVdxuqvDKtsefeBRpsmCKRTgBxm+jKYgrAjdneo
	 I7rHzM343Cvx4HM2yAqwZslIa5RfRp8nKFx5f1Tqg/RfvSINhOmQAEJv+wZq+pvgv7qjyWKa/Q75
	 hUNtmxe9oUam3vKHlnLG6EEWcXJhuWt7PO5+XWsiWWtIX8Yfp7gPpV+w+Y2egE0OjBfRCa
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Zongkun Lei <leizongkun@qq.com>
To: linux-mm@kvack.org
Cc: Zongkun Lei <leizongkun@qq.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/6] mm/hugetlb: swap out anonymous hugetlb folios via MADV_PAGEOUT
Date: Tue, 29 Sep 2026 15:59:48 +0800
X-OQ-MSGID: <3ef0663e9c15e9fefedac7367d6347768bf94d08.1790663399.git.leizongkun@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790663399.git.leizongkun@qq.com>
References: <cover.1790663399.git.leizongkun@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dn5bkqo5e3gqf35jfb4e6cy9grdxpbs5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 81651140005
X-HE-Tag: 1790668812-616747
X-HE-Meta: U2FsdGVkX18FWC5ppIGWtsWxzci8YgVe6VWlOOzot6IdIxjaxNIqB6bHy7hwe+aIg7ovDDgDaPlm8aod611l59q4yBF49sr63QqYfE9sZjE2Dgz/8Qr+BlPNxQtDorqjgUUSXJmtLDLa7OFS7VX2NTWfW4W6A5gnUEtSXDiT2rRkjdpdN2O4XlXh+2c6FIycsX6M+08d6DAAfMVyBLVewKAI/3IGXXfCh3z1wVfQLO/DmM1SlqjYVDcgUt6nxRIiH7Ou7m/1UkZ1z/RZtrQuXlVqpgMuzvlmJRPUN+K8twmmByLnqldgNJ0b71VdufSuthTfvdP8lSCY9ldDRjLAfb0PgP1mC7TewVIRVKZXdi1/Uqoy5vuyJU588pdPSRqUCvVsbeW59/zAR4QCDmkxRDiqy2wCC6kKsr+hyXzfK3qfpdcX3CN+er4pbivZMifMHr4VI+GNxF7YyKg+iCVTEtS+EecdbtWHhT+nEgsxzpjDN51ZxAkYQlWwtIlvJ2LhQZIZssuldr9NQZmYCE3CPZSehPIWWKBVZxAuibfSLJc9y0u5UxaGFAg1LeR5z6NekO5eO7rE0S5SP1/jtkP3WPIO/BhAvXGI4n8MYsg2sWKElg26lYpZxmY//7uw4OJ4/FiwcsoktsZLsyaoA1H75p72v52MJQuOX1PS9y6DQEGRPAB9mrJDu7Dt85Tq/rAajaL5RAMsMwocynMnYQZA+JDx7T5tgalk0wWH2Uz1/sS8RGxNhg94GCyopbov97HjYJpFay4e7ePwzj3OB/YYYiLf2DNCpd08Wr80EJtSLIacywRoCtSuMErgkNeL156dWwi66BbXlQ/3TXvVt4ZUTDnLSVL2HvEYne+RcR0R7TQ39S7zPc/cErzWHS4GJgtizzdtdxVsbh3D61KQOXMgj4ZzB8JXpPFMcRsju7ChGY8sphu2Whr+FQMOb70ctce18jLFZSqWjh1mtd2fWaP
 M2x40qia
 6xs2/9W/Cc0tGi1YuX11R87QeZatzL14V8pPUyVfuw8YyUBQpLpz/LZNPolQ+IqSMnyCLZm2Mi9AyFWC1G3F/mrlcVfyXRpYKgPyEdGje1jiBO0B9zUExwKPTOSVwjhOxNeC1fJR+lqTBYDv6kKokBbKagBVnYvYHVSasGzufNuPlaT5AVivDfffmIaR8FtIXY+PeOBCaGGgOdkObs4M/lQz4NMogh3JB2isOWJhmPVZ5HqkmZSz8CrwLNdebhZ+mDEqvSvmazyxM2zsqi1n/eviZsdmyAzGeOluy0m32YElJtcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the producer side of hugetlb swap: private anonymous hugetlb
folios (MAP_PRIVATE hugetlbfs/memfd mappings after COW) can now be
swapped out on explicit userspace request via madvise(2) MADV_PAGEOUT
/ process_madvise(2).  The kernel never swaps hugetlb pages on its
own: cold-page scoring and swap decisions belong to userspace.

The pieces:

- hugetlb_reclaim_pages() and hugetlb_reclaim_folio_list(): a
  deliberate mirror of reclaim_pages()/shrink_folio_list(), not a
  reuse.  The folio source (hstate activelists vs LRUs), the free
  path (free_huge_folio() vs free_unref_page_list()), the putback and
  the swap-cache removal (swap cluster lock vs i_pages) all differ,
  and hugetlb carries no scan_control/memcg-stat/demotion/workingset
  state.  All reusable leaf operations (rmap walk, slot allocation,
  writeout, referenced/pin checks) are shared; only the control flow
  is mirrored, so a future unification can mechanically fold the two
  together.  The machinery lives in hugetlb.c because it is pool
  management: folios come from folio_isolate_hugetlb() and go back
  via free_huge_folio() or the per-hstate active list, all under
  hugetlb_lock -- the same family as demote_pool_huge_page() and
  set_max_huge_pages().

- try_to_unmap_swap_hugetlb_one(): an rmap walker callback mirroring
  ttu_anon_swapbacked_folio() that replaces the huge PTE with a swap
  entry covering the whole folio (single walk, swp_pte_prepare(),
  mm_prepare_for_swap_entries(), MM_SWAPENTS accounting), plus the
  exported wrapper try_to_unmap_swap_hugetlb(), following the
  try_to_unmap_poisoned_hugetlb_one() precedent.  Cost to generic
  rmap code: one added line in rmap.h, no changes to existing code.

- hugetlb_folio_swap_supported(): the size gate.  Upper bound: swap
  space is allocated in ranges of at most SWAPFILE_CLUSTER (PMD size)
  pages, so gigantic folios cannot be swapped.  Lower bound: while
  swap cached, the HPG_* per-folio flags live in the low bits of
  folio->swap.val and the entry is recovered by rounding it down to
  the folio size (see folio_swap_entry()), which requires
  nr_pages >= 2^__NR_HPAGEFLAGS.  Relaxing the lower bound flag by
  flag breaks down at bit 5 (raw_hwp_unreliable, set on the
  memory-failure kmalloc-failure fallback path, independently of the
  folio size): extremely unlikely, but the consequence would be a
  shifted swap offset, i.e. silent data corruption, and correctness
  cannot rest on probability.  A VM_WARN_ON_ONCE_FOLIO in the
  swap-cache add path backstops the gate.  The gate scopes a new
  feature rather than removing anything: upstream supports no hugetlb
  swap at any size today; smaller sizes are left for a dedicated
  entry store follow-up.

- madvise: MADV_PAGEOUT on a private hugetlb VMA isolates the present
  hugepages and hands them to hugetlb_reclaim_pages().  Shared
  mappings (supported later in this series), userfaultfd-registered
  or locked VMAs, and hstates failing the size gate are rejected with
  EINVAL.

This patch is the producer; the consumer (fault/swapoff swap-in)
landed in the previous patch.  The order matters and must not be
flipped: without the swap-in side, hugetlb_fault() returns success
without installing anything for non-present entries that are neither
migration nor hwpoison entries, so if page-out came first, touching a
swapped-out page would fault in an endless loop.

Signed-off-by: Zongkun Lei <leizongkun@qq.com>
---
 include/linux/hugetlb.h |  36 +++++
 include/linux/rmap.h    |   1 +
 mm/hugetlb.c            | 317 ++++++++++++++++++++++++++++++++++++++++
 mm/madvise.c            |  76 ++++++++++
 mm/rmap.c               | 147 +++++++++++++++++++
 mm/swap_state.c         |   8 +
 6 files changed, 585 insertions(+)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index b751cba214be..282185646fff 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -866,6 +866,30 @@ static inline struct hstate *folio_hstate(struct folio *folio)
 	return size_to_hstate(folio_size(folio));
 }
 
+/*
+ * Whether a hugetlb folio can be swapped out, i.e. enter the swap cache.
+ *
+ * Lower bound: while the folio is swap cached, the HPG_* per-folio flags
+ * are preserved in the low bits of folio->swap.val and the entry is
+ * recovered by rounding it down to the folio size (see folio_swap_entry()).
+ * That only works when the folio is large enough for all flag bits to fit
+ * below the swap offset.
+ *
+ * Upper bound: swap space is allocated in ranges of at most
+ * SWAPFILE_CLUSTER (PMD size) pages, so gigantic or larger folios cannot
+ * be swapped.
+ */
+static inline bool hugetlb_folio_swap_supported(const struct folio *folio)
+{
+	unsigned int order = folio_order(folio);
+
+	if (folio_nr_pages(folio) < (1UL << __NR_HPAGEFLAGS))
+		return false;
+	if (order_is_gigantic(order) || order > HPAGE_PMD_ORDER)
+		return false;
+	return true;
+}
+
 static inline unsigned hstate_index_to_shift(unsigned index)
 {
 	return hstates[index].order + PAGE_SHIFT;
@@ -1195,6 +1219,11 @@ static inline bool hstate_is_gigantic(struct hstate *h)
 	return false;
 }
 
+static inline bool hugetlb_folio_swap_supported(const struct folio *folio)
+{
+	return false;
+}
+
 static inline unsigned int pages_per_huge_page(struct hstate *h)
 {
 	return 1;
@@ -1377,6 +1406,13 @@ hugetlb_walk(struct vm_area_struct *vma, unsigned long addr, unsigned long sz)
 	return huge_pte_offset(vma->vm_mm, addr, sz);
 }
 
+/*
+ * Self-contained reclaim of isolated hugetlb folios.  Hugetlb folios are not
+ * on the normal LRU, so they are swapped out here instead of through the
+ * generic reclaim_pages()/shrink_folio_list() path.
+ */
+unsigned long hugetlb_reclaim_pages(struct list_head *folio_list);
+
 int hugetlb_unuse_vma(struct vm_area_struct *vma, unsigned int type);
 
 #endif /* _LINUX_HUGETLB_H */
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 0b332770abee..cb45f6de9b79 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -966,6 +966,7 @@ struct rmap_walk_control {
 	bool (*invalid_vma)(struct vm_area_struct *vma, void *arg);
 };
 
+void try_to_unmap_swap_hugetlb(struct folio *folio);
 void rmap_walk(struct folio *folio, struct rmap_walk_control *rwc);
 void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc);
 struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fc2077a03744..c7af58399e5b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7550,6 +7550,323 @@ void fixup_hugetlb_reservations(struct vm_area_struct *vma)
 	if (is_vm_hugetlb_page(vma))
 		clear_vma_resv_huge_pages(vma);
 }
+
+/*
+ * Reclaim a list of isolated hugetlb folios by swapping them out.
+ *
+ * This is a deliberate mirror of shrink_folio_list(), not a reuse:
+ * hugetlb folios live on hstate activelists instead of LRUs, are
+ * unmapped through hugetlb rmap walks (whole-folio swap entries), and
+ * go back to the hstate pool on free instead of the buddy allocator.
+ * None of those hooks exist in the generic reclaim path, and shrinking
+ * that path's folio-size assumptions to fit hugetlb would complicate
+ * both sides, so the hugetlb-specific steps are reimplemented here next
+ * to the machinery they depend on (demotion and pool management live in
+ * this file for the same reason).
+ * Caller: proactive reclaim via MADV_PAGEOUT.
+ */
+static unsigned int hugetlb_reclaim_folio_list(struct list_head *folio_list)
+{
+	LIST_HEAD(ret_folios);
+	struct swap_io_ctx ctx = {};
+	unsigned int nr_reclaimed = 0;
+	struct folio *folio;
+
+	while (!list_empty(folio_list)) {
+		struct address_space *mapping;
+		struct swap_cluster_info *ci;
+		long nr_pages;
+		int refcount;
+
+		cond_resched();
+
+		folio = lru_to_folio(folio_list);
+		list_del(&folio->lru);
+
+		if (!folio_trylock(folio))
+			goto keep;
+
+		VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
+
+		/*
+		 * Never hand a poisoned hugepage back to the pool.  hugetlb
+		 * folios are always large, so this is the large-folio arm of
+		 * shrink_folio_list()'s hwpoison check: keep it isolated and
+		 * intact rather than unmapping or freeing it.
+		 */
+		if (folio_test_hwpoison(folio) ||
+		    folio_test_has_hwpoisoned(folio))
+			goto keep_locked;
+
+		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
+
+		nr_pages = folio_nr_pages(folio);
+
+		/*
+		 * Only hugetlb folios whose size fits both the swap
+		 * allocator and the swap-entry/flag sharing scheme can be
+		 * swapped out; see hugetlb_folio_swap_supported().
+		 */
+		if (!hugetlb_folio_swap_supported(folio))
+			goto keep_locked;
+		if (unlikely(!folio_evictable(folio)))
+			goto activate_locked;
+
+		/*
+		 * Only anonymous folios (MAP_PRIVATE mappings after COW)
+		 * are swapped out so far; file-backed hugetlbfs folios
+		 * gain swap support later in this series.
+		 */
+		if (!folio_test_anon(folio))
+			goto keep_locked;
+
+		/*
+		 * If the folio's swap write is still in flight, the bio holds a
+		 * writeback reference that end_swap_bio_write() drops
+		 * asynchronously via folio_end_writeback() -> folio_put().
+		 * Freezing and freeing the folio here (below) would race with
+		 * that completion and hand the same hugepage back to the pool
+		 * twice.  Wait for writeback to finish, then retry the folio.
+		 * Mirrors the synchronous-reclaim case in shrink_folio_list().
+		 * The write is still sitting in the deferred batch: submit it
+		 * before waiting, otherwise the wait outlives the caller.
+		 */
+		if (folio_test_writeback(folio)) {
+			folio_unlock(folio);
+			swap_write_submit(&ctx);
+			folio_wait_writeback(folio);
+			list_add_tail(&folio->lru, folio_list);
+			continue;
+		}
+
+		/*
+		 * Anonymous folios enter the swap cache here, before the
+		 * unmap below installs swap PTEs that reference the slots.
+		 * Hugetlb folios are not swap backed by default.
+		 */
+		folio_set_swapbacked(folio);
+		if (!folio_test_swapcache(folio)) {
+			if (folio_alloc_swap(folio))
+				goto activate_locked;
+
+			folio_mark_dirty(folio);
+		}
+
+		/*
+		 * Unmap from every process, installing swap PTEs that
+		 * reference the slots allocated above.
+		 */
+		if (folio_mapped(folio)) {
+			try_to_unmap_swap_hugetlb(folio);
+			if (folio_mapped(folio))
+				goto activate_locked;
+		}
+
+		/*
+		 * The folio is unmapped now, so it cannot be newly pinned.
+		 * A still-pinned folio cannot be reclaimed: the pin holds
+		 * extra references that would fail the refcount freeze below,
+		 * and writing it out to swap while a device is still DMAing
+		 * into it would lose those in-flight updates.  Mirrors
+		 * shrink_folio_list().
+		 */
+		if (folio_maybe_dma_pinned(folio))
+			goto activate_locked;
+
+		mapping = folio_mapping(folio);
+		if (folio_test_dirty(folio)) {
+			int res;
+
+			try_to_unmap_flush_dirty();
+
+			/* Could not write back, folio still locked. */
+			if (!mapping)
+				goto keep_locked;
+
+			if (folio_clear_dirty_for_io(folio)) {
+				folio_set_reclaim(folio);
+				res = swap_writeout(&ctx, folio);
+				if (res < 0) {
+					folio_lock(folio);
+					if (folio_mapping(folio) == mapping)
+						mapping_set_error(mapping, res);
+					folio_unlock(folio);
+				}
+				if (res == AOP_WRITEPAGE_ACTIVATE) {
+					folio_clear_reclaim(folio);
+					goto activate_locked;
+				}
+
+				if (!folio_test_writeback(folio)) {
+					/* synchronous write, or freed/zeromapped without IO */
+					folio_clear_reclaim(folio);
+				}
+				node_stat_add_folio(folio, NR_VMSCAN_WRITE);
+
+				/* Handed to the disk, folio unlocked. */
+				if (folio_test_writeback(folio)) {
+					/*
+					 * Asynchronous write still in flight.
+					 * Userspace-driven reclaim must not
+					 * return with the memory unaccounted:
+					 * wait for the write to finish and
+					 * retry the folio in this same pass.
+					 */
+					/* Dispatch the deferred write before waiting on it. */
+					swap_write_submit(&ctx);
+					folio_wait_writeback(folio);
+					list_add_tail(&folio->lru, folio_list);
+					continue;
+				}
+				if (folio_test_dirty(folio))
+					goto keep;
+				/* Synchronous write (e.g. ramdisk): free below. */
+				if (!folio_trylock(folio))
+					goto keep;
+				if (folio_test_dirty(folio) ||
+				    folio_test_writeback(folio))
+					goto keep_locked;
+				mapping = folio_mapping(folio);
+			}
+			/* Nothing to write otherwise, folio still locked. */
+		}
+
+		/*
+		 * Only a folio that made it into the swap cache can be freed
+		 * here; anything else (a clean folio still owned by its
+		 * mapping) gets put back onto the list.
+		 */
+		if (!folio_test_swapcache(folio))
+			goto keep_locked;
+
+		if (!mapping)
+			goto keep_locked;
+
+		/*
+		 * Remove the folio from the swap cache so it can be freed,
+		 * mirroring __remove_mapping().  With the swap table based
+		 * swap cache the entries are no longer in mapping->i_pages;
+		 * they are protected by the swap cluster lock instead.  No
+		 * workingset shadow is kept for hugetlb folios.
+		 */
+		BUG_ON(!folio_test_locked(folio));
+		BUG_ON(mapping != folio_mapping(folio));
+
+		ci = swap_cluster_get_and_lock_irq(folio);
+
+		refcount = 1 + folio_nr_pages(folio);
+		if (!folio_ref_freeze(folio, refcount))
+			goto cannot_free;
+		/* note: atomic_cmpxchg in folio_ref_freeze provides the smp_rmb */
+		if (unlikely(folio_test_dirty(folio))) {
+			folio_ref_unfreeze(folio, refcount);
+			goto cannot_free;
+		}
+
+		__memcg1_swapout(folio, ci);
+		__swap_cache_del_folio(ci, folio, folio_swap_entry(folio), NULL);
+		swap_cluster_unlock_irq(ci);
+
+		folio_unlock(folio);
+		nr_reclaimed += nr_pages;
+		INIT_LIST_HEAD(&folio->lru);
+		free_huge_folio(folio);
+		continue;
+
+cannot_free:
+		swap_cluster_unlock_irq(ci);
+		goto keep_locked;
+
+activate_locked:
+		/*
+		 * Not swapped out: drop any swap slots we reserved.  Only
+		 * anonymous folios can hold reserved-but-unused slots here.
+		 */
+		if (folio_test_anon(folio) && folio_test_swapcache(folio) &&
+		    (folio_test_mlocked(folio) || mem_cgroup_swap_full(folio)))
+			folio_free_swap(folio);
+keep_locked:
+		folio_unlock(folio);
+keep:
+		list_add(&folio->lru, &ret_folios);
+	}
+
+	/* Flush the deferred TTU_BATCH_FLUSH TLB invalidations. */
+	try_to_unmap_flush();
+	swap_write_submit(&ctx);
+
+	list_splice(&ret_folios, folio_list);
+	return nr_reclaimed;
+}
+
+static void hugetlb_putback_after_reclaim(struct folio *folio)
+{
+	struct hstate *h;
+
+	if (WARN_ON_ONCE(!folio_test_hugetlb(folio))) {
+		folio_put(folio);
+		return;
+	}
+
+	h = folio_hstate(folio);
+
+	spin_lock_irq(&hugetlb_lock);
+	folio_set_hugetlb_migratable(folio);
+	list_move(&folio->lru, &h->hugepage_activelist);
+	spin_unlock_irq(&hugetlb_lock);
+
+	folio_put(folio);
+}
+
+/*
+ * Reclaim a list of isolated hugetlb folios.  Mirrors reclaim_pages(): folios
+ * are grouped per node and run through the trimmed swap-out path above.  Any
+ * that could not be freed (lock/unmap/writeback contention, pins) are put
+ * back onto the per-hstate active list.
+ */
+unsigned long hugetlb_reclaim_pages(struct list_head *folio_list)
+{
+	unsigned int nr_reclaimed = 0;
+	LIST_HEAD(node_folio_list);
+	unsigned int noreclaim_flag;
+	struct folio *folio;
+	int nid;
+
+	if (list_empty(folio_list))
+		return 0;
+
+	noreclaim_flag = memalloc_noreclaim_save();
+
+	nid = folio_nid(lru_to_folio(folio_list));
+	do {
+		folio = lru_to_folio(folio_list);
+
+		if (nid == folio_nid(folio)) {
+			folio_clear_active(folio);
+			list_move(&folio->lru, &node_folio_list);
+			continue;
+		}
+
+		nr_reclaimed += hugetlb_reclaim_folio_list(&node_folio_list);
+		while (!list_empty(&node_folio_list)) {
+			/* putback does list_move(); do not list_del() first. */
+			folio = lru_to_folio(&node_folio_list);
+			hugetlb_putback_after_reclaim(folio);
+		}
+		nid = folio_nid(lru_to_folio(folio_list));
+	} while (!list_empty(folio_list));
+
+	nr_reclaimed += hugetlb_reclaim_folio_list(&node_folio_list);
+	while (!list_empty(&node_folio_list)) {
+		/* putback does list_move(); do not list_del() first. */
+		folio = lru_to_folio(&node_folio_list);
+		hugetlb_putback_after_reclaim(folio);
+	}
+
+	memalloc_noreclaim_restore(noreclaim_flag);
+
+	return nr_reclaimed;
+}
 /*
  * Mirror of should_try_to_free_swap() in mm/memory.c for the hugetlb
  * swapin path; keep in sync.  The exclusive test differs: hugetlb
diff --git a/mm/madvise.c b/mm/madvise.c
index 73c2901b9adb..a46306cd1d49 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -635,11 +635,87 @@ static void madvise_pageout_page_range(struct mmu_gather *tlb,
 	tlb_end_vma(tlb, vma);
 }
 
+/*
+ * Page out private anonymous hugetlb folios in the range: isolate each
+ * present hugepage, hand the batch to hugetlb_reclaim_pages() and let it
+ * unmap, write out and free the folios synchronously.
+ */
+static long madvise_pageout_hugetlb(struct madvise_behavior *madv_behavior)
+{
+	struct vm_area_struct *vma = madv_behavior->vma;
+	struct mm_struct *mm = madv_behavior->mm;
+	struct hstate *h = hstate_vma(vma);
+	unsigned long size = huge_page_size(h);
+	unsigned long addr, end = madv_behavior->range.end;
+	LIST_HEAD(folio_list);
+
+	/* uffd interaction with swap entries is not audited yet. */
+	if (userfaultfd_armed(vma))
+		return -EINVAL;
+	if (vma->vm_flags & (VM_LOCKED | VM_PFNMAP))
+		return -EINVAL;
+	/*
+	 * Swap PTEs are only installed for anonymous folios (MAP_PRIVATE
+	 * after COW); shared hugetlbfs mappings gain swap-out support
+	 * later in this series.
+	 */
+	if (vma->vm_flags & VM_MAYSHARE)
+		return -EINVAL;
+	/* A huge page must fit in a single swap cluster to be swappable. */
+	if (hstate_is_gigantic(h) || huge_page_order(h) > HPAGE_PMD_ORDER)
+		return -EINVAL;
+
+	/*
+	 * The caller's range is only PAGE_SIZE aligned and the hugetlb
+	 * end adjustment in madvise_dontneed_free_valid_vma() does not
+	 * apply to MADV_PAGEOUT, so align the range to huge pages here.
+	 * The range is clamped to this VMA, whose bounds are huge page
+	 * aligned, so the rounding cannot spill into a neighbour VMA.
+	 */
+	addr = ALIGN_DOWN(madv_behavior->range.start, size);
+	end = ALIGN(end, size);
+
+	for (; addr < end; addr += size) {
+		spinlock_t *ptl;
+		struct folio *folio;
+		pte_t *ptep, pte;
+
+		ptep = huge_pte_offset(mm, addr, size);
+		if (!ptep)
+			continue;
+		ptl = huge_pte_lock(h, mm, ptep);
+		pte = huge_ptep_get(mm, addr, ptep);
+		if (!pte_present(pte)) {
+			/* Hole or already-swapped: nothing to do. */
+			spin_unlock(ptl);
+			continue;
+		}
+		folio = page_folio(pte_page(pte));
+		folio_get(folio);
+		spin_unlock(ptl);
+
+		/*
+		 * On success folio_isolate_hugetlb() takes an additional
+		 * reference that hugetlb_reclaim_pages() consumes; drop
+		 * only the pin we grabbed under the ptl.
+		 */
+		folio_isolate_hugetlb(folio, &folio_list);
+		folio_put(folio);
+		cond_resched();
+	}
+
+	hugetlb_reclaim_pages(&folio_list);
+	return 0;
+}
+
 static long madvise_pageout(struct madvise_behavior *madv_behavior)
 {
 	struct mmu_gather tlb;
 	struct vm_area_struct *vma = madv_behavior->vma;
 
+	if (is_vm_hugetlb_page(vma))
+		return madvise_pageout_hugetlb(madv_behavior);
+
 	if (!can_madv_lru_vma(vma))
 		return -EINVAL;
 
diff --git a/mm/rmap.c b/mm/rmap.c
index fed0362e0bd0..2ce54cb5ff20 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2193,6 +2193,132 @@ static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
 					 pteval);
 }
 
+/*
+ * Swap-out counterpart of try_to_unmap_one() for hugetlb folios.  For an
+ * anonymous folio, the single huge PTE mapping @folio in @vma is replaced
+ * with a swap entry covering the whole folio; for a file-backed folio the
+ * PTE is simply cleared, the swap anchor lives in the hugetlbfs page
+ * cache instead (shmem-style).  Called from the hugetlb reclaim path
+ * (hugetlb_reclaim_pages()) with the folio lock held; an anonymous folio
+ * is swapbacked with its swap slots allocated.
+ *
+ * Keep in sync with ttu_anon_swapbacked_folio().
+ */
+static bool try_to_unmap_swap_hugetlb_one(struct folio *folio,
+					  struct vm_area_struct *vma,
+					  unsigned long address, void *arg)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct hstate *h = hstate_vma(vma);
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
+	const enum ttu_flags flags = (enum ttu_flags)(long)arg;
+	const unsigned long hsz = huge_page_size(h);
+	struct mmu_notifier_range range;
+	bool anon_exclusive;
+	pte_t pteval;
+
+	range.end = vma_address_end(&pvmw);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
+				address, range.end);
+	mmu_notifier_invalidate_range_start(&range);
+
+	/* There is only a single mapping in a VMA. */
+	if (!page_vma_mapped_walk(&pvmw))
+		goto range_end;
+
+	if ((vma->vm_flags & VM_LOCKED) && !(flags & TTU_IGNORE_MLOCK))
+		goto walk_abort;
+
+	VM_BUG_ON_FOLIO(!pvmw.pte, folio);
+
+	if (!folio_test_anon(folio)) {
+		/*
+		 * File-backed hugetlb folios swap out shmem-style: the PTE
+		 * is simply cleared and the swap anchor lives in the
+		 * hugetlbfs page cache, so a later fault re-enters through
+		 * hugetlb_no_page().  No swap PTE is installed and nothing
+		 * is charged to MM_SWAPENTS.  Shared mappings may share
+		 * PMDs, so flush the notifier-adjusted range.
+		 */
+		flush_cache_range(vma, range.start, range.end);
+		pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
+		if (huge_pte_dirty(pteval))
+			folio_mark_dirty(folio);
+		update_hiwater_rss(mm);
+		hugetlb_count_sub(folio_nr_pages(folio), mm);
+		hugetlb_remove_rmap(folio);
+		folio_put_refs(folio, 1);
+		goto walk_done;
+	}
+
+	/* Private anonymous mapping: no PMD sharing possible. */
+	flush_cache_range(vma, address, address + hsz);
+
+	/* Nuke the page table entry, TLB flush included. */
+	pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
+
+	if (huge_pte_dirty(pteval))
+		folio_mark_dirty(folio);
+
+	update_hiwater_rss(mm);
+
+	if (WARN_ON_ONCE(folio_test_swapbacked(folio) !=
+			 folio_test_swapcache(folio)))
+		goto restore;
+
+	anon_exclusive = PageAnonExclusive(&folio->page);
+	/* A writable mapping of an anon folio must be exclusive. */
+	VM_BUG_ON_PAGE(pte_write(pteval) && !anon_exclusive, &folio->page);
+
+	/*
+	 * The new swap allocator keeps the swap entries of a swap cache
+	 * folio pinned at count == 0; folio_dup_swap() bumps the whole
+	 * folio's entries to the initial count == 1 before the swap PTE
+	 * installed below starts referencing them.
+	 */
+	if (folio_dup_swap(folio, NULL) < 0)
+		goto restore;
+	if (arch_unmap_one(mm, vma, address, pteval) < 0)
+		goto restore_put_swap;
+
+	/*
+	 * See folio_try_share_anon_rmap(): the PTE has already been
+	 * cleared above.  hugetlb_try_share_anon_rmap() clears
+	 * PageAnonExclusive (exclusivity moves into the swap PTE built
+	 * below) and fails if the folio is GUP-pinned -- in which case
+	 * it must not be swapped out, so restore the PTE and abort.
+	 */
+	if (anon_exclusive && hugetlb_try_share_anon_rmap(folio))
+		goto restore_put_swap;
+
+	mm_prepare_for_swap_entries(mm);
+
+	set_huge_pte_at(mm, address, pvmw.pte,
+			swp_pte_prepare(folio_swap_entry(folio), pteval,
+					anon_exclusive), hsz);
+	add_mm_counter(mm, MM_SWAPENTS, pages_per_huge_page(h));
+	hugetlb_count_sub(folio_nr_pages(folio), mm);
+
+	hugetlb_remove_rmap(folio);
+	folio_put_refs(folio, 1);
+	goto walk_done;
+
+restore_put_swap:
+	folio_put_swap(folio, NULL);
+restore:
+	set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
+walk_abort:
+	page_vma_mapped_walk_done(&pvmw);
+	mmu_notifier_invalidate_range_end(&range);
+	return false;
+
+walk_done:
+	page_vma_mapped_walk_done(&pvmw);
+range_end:
+	mmu_notifier_invalidate_range_end(&range);
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2779,6 +2905,27 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	return ret;
 }
 
+/*
+ * Try to remove all mappings of a hugetlb folio as part of swapping the
+ * folio out.  Mappings of an anonymous folio are replaced with swap
+ * entries; mappings of a file-backed folio are just cleared (the swap
+ * anchor lives in the hugetlbfs page cache).  The caller must hold the
+ * folio lock; for an anonymous folio it must also have made the folio
+ * swapbacked with its swap slots allocated.  Like try_to_unmap(), it is
+ * the caller's responsibility to check folio_mapped() to see whether the
+ * unmap succeeded.
+ */
+void try_to_unmap_swap_hugetlb(struct folio *folio)
+{
+	struct rmap_walk_control rwc = {
+		.rmap_one = try_to_unmap_swap_hugetlb_one,
+		.done = folio_not_mapped,
+		.anon_lock = folio_lock_anon_vma_read,
+	};
+
+	rmap_walk(folio, &rwc);
+}
+
 /**
  * try_to_migrate - try to replace all page table mappings with swap entries
  * @folio: the folio to replace page table entries for
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 43212df961bb..78e1e9b7821a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -21,6 +21,7 @@
 #include <linux/migrate.h>
 #include <linux/vmalloc.h>
 #include <linux/huge_mm.h>
+#include <linux/hugetlb.h>
 #include <linux/shmem_fs.h>
 #include <linux/sysctl.h>
 #include <linux/swap_ops.h>
@@ -217,6 +218,13 @@ static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
+	/*
+	 * Hugetlb folios too small for all per-folio flag bits to fit below
+	 * the swap offset must never reach the swap cache; they are kept
+	 * out by the hugetlb reclaim path (see folio_swap_entry()).
+	 */
+	VM_WARN_ON_ONCE_FOLIO(folio_test_hugetlb(folio) &&
+			      !hugetlb_folio_swap_supported(folio), folio);
 
 	ci_end = ci_off + nr_pages;
 	do {
-- 
2.53.0


