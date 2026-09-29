Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EED7C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365CC6B00AA; Tue, 29 Sep 2026 04:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316786B00AB; Tue, 29 Sep 2026 04:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253C96B00AC; Tue, 29 Sep 2026 04:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07DF16B00AA
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:01:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 793614044C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:10 +0000 (UTC)
X-FDA: 85266054300.01.311B670
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id A6B79140003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=VsmfTlkn;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf09.hostedemail.com: domain of leizongkun@qq.com designates 43.163.128.52 as permitted sender) smtp.mailfrom=leizongkun@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ly3nDUIqD4kXn9hZ6TwQqfmz9JPC5wf0TiGErgoezks=;
	b=5IYisHzRIbY/BHqzCPT1ZpTHjdjDhAtpdQ9NpO7DJF3+58TTcY7UyoSwFaYD6T1x2wCGeM
	t/6JaojsVyK7HUDDURDx5+CAb/r8Iv83b9oA1nJ5qJRc1iJ4EEtHbgs8SVEaavovdumyZl
	VWiSy/+mWNM7LI3yU+/urUbaKNGTbew=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=VsmfTlkn;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf09.hostedemail.com: domain of leizongkun@qq.com designates 43.163.128.52 as permitted sender) smtp.mailfrom=leizongkun@qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668868;
	b=Je390wBoA4AnuXa3EYPyQizpnuAQxMPWfnjWgJpvrQn80m/VQdBP/SHJVvjxLfuDTmMTr1
	WKT+pqsDDXehw8AOTcKlN59Mw/vpQS/aRWYINvrJDAiMdTrD8Q4lhoOWUpzZ+Ox2pE7/P5
	YrWuc90Uv7slyUhS46Bg28a9KTt4c/s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790668864; bh=ly3nDUIqD4kXn9hZ6TwQqfmz9JPC5wf0TiGErgoezks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VsmfTlknoVF4JW3KRm9tNxIDMIdSiI745lihU2yWaHqbtxCgfFwgc9p42E5NtkxIV
	 Ny8At5HC5l5IXa48z6SCnAS9ByW+lcq/RPmREuRcpuvf4xqqCUEo7DFqAopR+fbCYr
	 7icEIXlYQuNUyPFy3zcJiJowazp9drSUz0RCpqc0=
Received: from lzk-B860M-AORUS-PRO-WIFI7 ([2409:8a28:a83:5ba1:514f:5353:e14b:594e])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 4008050; Tue, 29 Sep 2026 16:01:00 +0800
X-QQ-mid: xmsmtpt1790668860ty55e9eiy
Message-ID: <tencent_6DE2E1B379FAD189CEFE60DBA83A4C1DF005@qq.com>
X-QQ-XMAILINFO: Nqv6BipjixTcZeYFyZves1ffgjsrPWdKwazucvA0eWb4ZVNnUHqqop4zQM+6k4
	 LLteYgw7z9J2uOtTLEJmoQjP2PL18GG+AbqHfFnxXl4i85TgNFDW31qkb7yoI3ztps/+Cfn5Dc/q
	 4uxewVTeEfX4QSAhSEx9tuBa9TT4WF+bAHlKlGOoDNxzUjq75jRAA3klYnXUa+LWzYRtAX0Cd3kn
	 M0/jj33lIDGKvSGQgn4Ab/QLkO8rcRuxvUzEkCl0S0UKb+Jn7bsvEAabNk6W/liwUwCYBLC4FyQC
	 +nR90nSDg3RMpL1zzgy/f/x9Ba+ee5WJ3h1UIGVJ0aKlDcw0seRkhdSMVJjd2FtKCUd+CFowQu9K
	 dQ24gtWV5ZB81VhS+frGNjLbbU9YuxDQHdxDJrrF8+65KmLNoLc2H5rCpvNyAldlvs1EUK8nDUkR
	 taJ3D4dYLxF/TGVPrr+SLXD3bM1pyUrkXiKwZ1hdbpAVhlUlL8a39Ddz7SZCutATSLZgYHrC6cNI
	 /i5mXOjenx8zwaP3g6eIlrGtgUrqiP+E73caWkFebYWTsCgYNt61b/Qa3YPsEqDgz4m1v3dp4l1l
	 5fKsD1PUM+xGoSuvyS0Kys54dSObSPo2bcOhM1l43hu7BHRiQDozipIEWDXQvRr3J7jMccftljWf
	 uuqkmnxZJ474KRYNUmPNAmExQvO4lDvatE6ySI0Nnux9RN6KPDUNID253TC7wwGqDVFblMWXdsuA
	 IhmmfKdgwoCjdDVV01d4nF63rc7mzljcRdb7GopOGEelGn1QUdfmccBmKA1+rnNpR/5rbBsWIhXs
	 JFUfLVhG2Bew0vpY5pZdUPybEHTxN0qAHQjyh8aHtMnVUfkpIlyCQ/UuNIwmi2P4k5I0TJMYCkNY
	 KETKpK+v6Rparr7WZmNDRVPwV3MGUbBW5iURyFBaDh2PZwtGxulXJs/kv4ycrOjiheau0BO8voAf
	 HclfTAOsmoaauMVw479d/16STszxFO9IYE6IWzCROTUMVa1y55XlwBBq78L/gbWWkmurVrus8u/v
	 jDyb7hVrjd5KxQL4Rrkz7As84+SP+M+TIEZlznqnc5p6MTnzhhqma7LNSRvHscC2TXhe/adCHIgK
	 tAcSePkZWskaSejlDNo8Zbt9QuECFY53OLOUo/enw4FniVWNvkA2bDMyy7lsRRJSg1Dxc8QmxLnU
	 ZpWczCei0ibF9U76iqEikyJLsQV1c735NcwAM=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Zongkun Lei <leizongkun@qq.com>
To: linux-mm@kvack.org
Cc: Zongkun Lei <leizongkun@qq.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/6] mm/memory-failure: handle swapcached hugetlb folios
Date: Tue, 29 Sep 2026 16:00:57 +0800
X-OQ-MSGID: <11b04f7647e730e74d7eda8d29acc6d5fb762e57.1790663399.git.leizongkun@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790663399.git.leizongkun@qq.com>
References: <cover.1790663399.git.leizongkun@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 84bpd9ngdauk8fjr8k4nomincuuc81aw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A6B79140003
X-HE-Tag: 1790668867-167778
X-HE-Meta: U2FsdGVkX19fAXG/L1gSG+CKNnEE7A1LRSZwiSzaqQoDk5hlMasjHriboEyV9LwwCz0TMunp8N/SbCFo+y7ftId1VQUcOXT5327Z1bTKtx/WRCt/oIZPfDSWEtAxcvkhpOZOMzGYoqHRVTJN3dTNwZM6RAUJqjTaf6bCT9WvJLOV/N/9a/2mgxs7UWouylXYI0DFTimpqt2Jg6gN9lbsKrlQqgw0DclON/0C/BGhq+l1OaHxmYtuqWM+n6LwHhMJDe8fKhYsIQZ0rADnPZ8hOLp+kGVLLzkToL17/AZ6/fCXXX377Kqvi2zR88kzwaPAhM/Iq+U7xUCRzRIAkelU7NrY+HT2QLew6Tj6ISB3npvM4vr+7MyjhyEB8v/IzIYBtQaJPC//KjryC0kKeJ8FmeYh2yDq4uuO5Y7VcFhELxhmPuEqLBxFycb1ZSsoW5EW5n04Kg5Hu0xTT6NMHkb2MkIntHWZyOa/yGaInS3hzLmXyaLQ3ux+XfC7/TrjHJIFX+UOiEOjS+Wcsj2UO12dZqzW+nZPLWitS+x2w53mt8t6KyTsJEEMuVa6eZiWeqJ9CMhoCWJp7RvC7JeNmSAucryeNiGeJyAaQsJV1gyhNy2iU1DYTK7pvNItM2veh4etyC6d+PXuAeuW+47naFpQ5zLCsj6HBMy5XWkqL3OmRxOHzCibuKUxv85bHqKWhRuhsW7behQt5PqlMXWnkTxsanaGfkG50NE0f8sxJqoYjIAHIhC8NcPJYSAW+l81LFZOdgZg/RA0/SLohK8s6m1Wl1Xqi/sdKTb3EoAC35kdxUzz5vEub+67TDywLhvRwrnibNI/NL5z0VqBcmukha6jrYoYL2R/w09LfwCwHVi7RF/bJ5+X89pDEZhn81xcNnxVhLVY5KausmotG2YuTVjs2AfSn0noXH+/eZQFQ4F3WWPC6EugeaciBhxs4sucnkP/Se0Ec4FLcKLp3baoRyq
 r9SsvCCA
 f6R7R90TWvntFJ4gp8ncZPp3W//wIWEg5VqAtRxa8ZlN30OuQj/FR4ovHP/HnPf7gsFv8wkKVi+9bSdDrFD5NSRUblfpIK5CUV/DIqTZeR3/yT8JXnbGPOhDXY4EQDuFbbQ8/jFS+JDWGva3NCSwZV/xE95jzTmfl/AEPemo6jAoZIJ2xP10hU2F6Ku2DAlCRtEMSX5hmg5I1j3OaT76Kk1MkVuCSA1Zc95J8KwqebqMP8lFzMdaiPAb0Kso2nb2cTcYpe46HIldp2rXUE3Hs+Kb7Gao+eUIDW7wpQKXgSik8NJ5Q2OXwxVrC8xvwM5btSguVRVgGvgqqOx0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Anonymous hugetlb folios can now sit in the swap cache (swap-out
writeback window, cached copy after swap-in), a state memory failure
never had to handle before.  Two gaps:

1. try_to_unmap() routes every hugetlb folio to
   try_to_unmap_poisoned_hugetlb_one(), which requires TTU_HWPOISON.
   But unmap_poisoned_folio() clears TTU_HWPOISON for a dirty
   swapcache folio -- its mappings must be replaced with swap entries,
   exactly like for a 4K swapcache folio, so the swap accounting stays
   intact and the fault path gets to kill the owner.  Routing such a
   folio to the poisoned handler fires its VM_WARN_ON_ONCE and would
   install hwpoison entries on top of live swap state.  Route hugetlb
   folios by flag instead: TTU_HWPOISON set -> the poisoned handler;
   cleared -> try_to_unmap_swap_hugetlb_one().

2. me_huge_page() has no swapcache case: a clean poisoned hugetlb
   folio in the swap cache falls into the truncate path, which evicts
   it (the swap address space has no error_remove_folio).  The folio
   is never returned to the hstate pool (a silent 2M pool leak) and
   the poison marker is lost, so a later fault would swap possibly
   corrupt data back in.  Mirror me_swapcache_dirty(): keep the
   poisoned folio in the swap cache and return MF_DELAYED, so the
   swap-in path sees folio_test_hwpoison() and kills the accessor.

Signed-off-by: Zongkun Lei <leizongkun@qq.com>
---
 mm/memory-failure.c | 19 +++++++++++++++++++
 mm/rmap.c           | 32 ++++++++++++++++++++++++++------
 2 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba..0c31c8ab5542 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1151,6 +1151,25 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	struct address_space *mapping;
 	bool extra_pins = false;
 
+	/*
+	 * A hugetlb folio reaches the swap cache only via hugetlb
+	 * swap-out.  Keep a poisoned one there so that the swap-in
+	 * fault path intercepts folio_test_hwpoison() and kills the
+	 * accessor.  The truncate path below would evict a clean one
+	 * (the swap address space has no error_remove_folio), losing
+	 * both the folio (it is never returned to the hstate pool) and
+	 * the poison marker, so a later fault would silently swap
+	 * possibly-corrupt data back in.  Mirror me_swapcache_dirty().
+	 */
+	if (folio_test_swapcache(folio)) {
+		folio_clear_dirty(folio);
+		folio_unlock(folio);
+		/* The swap cache pin is intentionally retained. */
+		if (has_extra_refcount(ps, p, true))
+			return MF_FAILED;
+		return MF_DELAYED;
+	}
+
 	mapping = folio_mapping(folio);
 	if (mapping) {
 		res = truncate_error_folio(folio, page_to_pfn(p), mapping);
diff --git a/mm/rmap.c b/mm/rmap.c
index 2ce54cb5ff20..a88c911e8463 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1991,8 +1991,9 @@ static bool try_to_unmap_poisoned_hugetlb_one(struct folio *folio,
 	pte_t pteval;
 
 	/*
-	 * The try_to_unmap() is only passed a hugetlb folio in the case
-	 * where the hugetlb folio is poisoned.
+	 * try_to_unmap() routes a hugetlb folio here only for memory
+	 * failure with TTU_HWPOISON set; a poisoned folio kept in the
+	 * swap cache is routed to try_to_unmap_swap_hugetlb_one() instead.
 	 */
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hwpoison(folio), folio);
 	VM_WARN_ON_ONCE(!(flags & TTU_HWPOISON));
@@ -2199,8 +2200,10 @@ static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
  * with a swap entry covering the whole folio; for a file-backed folio the
  * PTE is simply cleared, the swap anchor lives in the hugetlbfs page
  * cache instead (shmem-style).  Called from the hugetlb reclaim path
- * (hugetlb_reclaim_pages()) with the folio lock held; an anonymous folio
- * is swapbacked with its swap slots allocated.
+ * (hugetlb_reclaim_pages()) and, via try_to_unmap(), from memory failure
+ * for a poisoned folio that is kept in the swap cache (see
+ * unmap_poisoned_folio()); the folio lock is held in all cases, and an
+ * anonymous folio is swapbacked with its swap slots allocated.
  *
  * Keep in sync with ttu_anon_swapbacked_folio().
  */
@@ -2567,13 +2570,30 @@ static int folio_not_mapped(struct folio *folio)
 void try_to_unmap(struct folio *folio, enum ttu_flags flags)
 {
 	struct rmap_walk_control rwc = {
-		.rmap_one = folio_test_hugetlb(folio) ?
-				try_to_unmap_poisoned_hugetlb_one : try_to_unmap_one,
+		.rmap_one = try_to_unmap_one,
 		.arg = (void *)flags,
 		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
 
+	/*
+	 * try_to_unmap() is passed a hugetlb folio only by memory failure.
+	 * With TTU_HWPOISON the mappings are replaced with hwpoison
+	 * entries.  Without it the folio is a poisoned folio that is kept
+	 * in the swap cache (unmap_poisoned_folio() cleared TTU_HWPOISON),
+	 * so the mappings are replaced with swap entries, exactly like for
+	 * a 4K swapcache folio: the swap accounting stays intact and the
+	 * fault path gets to kill the owner.
+	 */
+	if (folio_test_hugetlb(folio)) {
+		if (flags & TTU_HWPOISON)
+			rwc.rmap_one = try_to_unmap_poisoned_hugetlb_one;
+		else if (WARN_ON_ONCE(!folio_test_swapcache(folio)))
+			return;
+		else
+			rwc.rmap_one = try_to_unmap_swap_hugetlb_one;
+	}
+
 	if (flags & TTU_RMAP_LOCKED)
 		rmap_walk_locked(folio, &rwc);
 	else
-- 
2.53.0


