Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37ACCC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E741E6B009E; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24F46B00A0; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D134C6B00A1; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA0C56B009E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 476B980605
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:52:07 +0000 (UTC)
X-FDA: 85190733894.20.B349321
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9732D4000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:52:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V3+r43w9;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hbhWqGHP3IwdcG31EliQltqMq/ikBw+QUFL967DHBK4=;
	b=FIwZf+MC9VxjEMjq1FYQFIoYbDrY/pJz7U0O/NCesMPBhy71yueRdW0vWV9Mdczb/ixJ1h
	uyEGRwI7AX1rfpJfvyd+R2qFCsC5jY0W3DvvcqiQPv68Rav5v3/RUopaWIb36t0XjrguYK
	W9CVmDoZEPRz3r5ai+tBsvet7QLq+GU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875525;
	b=533uasU70mjdBYHZAmVlJP0+qXLItiAzepNal1NmIMO/Ru0vHsVBphpFOTmW+9juQONKGW
	503AZ8a2EnGttFPXnawQDQqJHhMF9+DUcDLgq2uZuXjQZ5C9VgoxAyS3jCaMm4bgi+7Uzy
	mMiNwgXQMuvy9M0zey+WlRAOlUvr8HI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V3+r43w9;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDF6A43477;
	Tue,  8 Sep 2026 13:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25521F00ACA;
	Tue,  8 Sep 2026 13:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788875524;
	bh=hbhWqGHP3IwdcG31EliQltqMq/ikBw+QUFL967DHBK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V3+r43w92haZ4/6h+NEX+yvlEVncdTDrKytnbWI0M8fT87s/vDS11yKyUCSiOlDm0
	 iyO0FmIXd//l+XRftblxtTIl8OTR5E2rj9iuLrwXYP1KY4sPbbqNtGHxImzC8jp6jz
	 qVPtLROBDJZnukrHdgtAXZusmW7LJeRt/Ka9J4bQkPAfCLByACdIpBfT2sKnsK53Af
	 xKjO6a1A8b+xui07xjlORaH2lkzvAQ7JywBg7EJ16r//tDIg03FHGcJ6KPYJth0LuI
	 ZCwxELgh+DrFXUbnEdOcv5L0cAngD/p1QoCfSMQeO0v1f8P6SO+J1Jd6bTlqHk5lcf
	 NFya6CFQn33bw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Krishna Iyer <kiyer@crusoe.ai>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/3] mm/damon/paddr: support hugetlb folios in access monitoring
Date: Tue,  8 Sep 2026 06:51:55 -0700
Message-ID: <20260908135156.97481-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260908135156.97481-1-sj@kernel.org>
References: <20260908135156.97481-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9732D4000A
X-Stat-Signature: 4pa1tequ3cyuzgd8g8d97u4rr7o11bwk
X-Rspam-User: 
X-HE-Tag: 1788875525-773665
X-HE-Meta: U2FsdGVkX1+Wc1MQ4vlKirrpI9caWg/wlTj7RLvmYoQMGNT1vH2MEV9W/1YUaIanbcRE3UtlE8vOp6TNTN5akQrP8AVbo0U0vtpGPh84Q19MKWdbw04zoxhbLmJ8E2rfERxrvCLj00SEj9N60z/Ok/WMiR8cvfIKvZjH19g1QIn7V7s92vOUH0pVpwGql05pgxecdYnW9joC9XdPnjKKlM9fRzDgwsxxsc+L+t7vyb0hpoAdQijPeLD0Gvmns2XpsJz0wJK8Bmypt3l5jVEwJQk5SnA7AW9j5pN/okgBmVvCXqdIjcbDSAZnUEw99sAS7ANFaRvmcBfvfZJlihrb+vjlJiL6h+E2CbXC7WEEiVdv0H0T+VrCQ6hxMYM5Qlefx5eC8otabgddqEgL49JKmz84jcMWCIqomJbuFRbT6j/mhXTOrAKnD76OSJmWp6CcTmftYV8zV9TEQM6rTQVxLZ/Y/op24n9FLyrI9ySWb1s0DYM+T+Q2ZskjirSsQjff9K1sD8yUpVpE9CHlndeXNWDAhUrIDRTFwQJswJWuV0U9qrCQx+fk/QsPg+cHjD/DhT8JXGL/y291Ru1WTh3VFPCO9uGa3Kxa3w/S52TfITvql8hx04+1CxC0veWR7qVuAAcE0aea10hYwpuhi7O+TxzJSl+z6F+nXfoFCDZa8KHlRhPw06Ep+69P5vppTyPXI4tqRx58Vj+zFsbbQjB6xI0m3EmGHEYt3Wk3RujgkKUb6GPjAMWxQgs6JnqxRK1EOWoBbKF81UfUt79sZVDc6MEb6Z7tXaIgB3u3iYHfsl2TnBlY7BSncP/46xI2gaoNM5BV9eI5UGwhTiEBJku2ceKlhxLy+eDLUygd/zdDLIorclc/npbEfbx3DJjBndhX7g32u6XQadf6imPQhXx5fbpByCt/PUX43UX0zc+HpVJCFF2MWdBlXufetXDJ45i30nz4QD2kqV5o7jFpq07
 Tvx7cnRc
 8CaqhluoxuxqB8hQqyyOKFFAFvvDAs9EGEU/EPDI2xEL7kksCXIa6yhZAKYdyrjlvwEHhUdgyoyeo6Pnz62McizexqDVhb0IOGS62y+t2v1jgqxdY/zwP+JGN/tQ5rCz2Zij2/tDAgUIWnaQTmQFXYGYirySBTq50l0OGyuixS8uul5NHhiWewz4fVFtsguK8IIyqXTNBgC2mKjCy9lwT67qKFxYKSoB5gijT2LKM19M29lztB/pVgWt1qr676Btl2hHzGieL+Iw7XrrKlxn0QXjnZbpCGRNvxdM6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Krishna Iyer <kiyer@crusoe.ai>

DAMON's physical address space monitoring is blind to hugetlb-backed
memory.  Every access check starts at damon_get_folio(), which rejects
folios that are not on the LRU lists.  Hugetlb folios are managed
outside of the LRU by design, so every sampling attempt on
hugetlb-backed memory silently fails and the pages are reported as
never accessed.

This is a significant blind spot on virtualization hosts.  Cloud
hypervisor hosts commonly back guest memory with 1 GiB hugetlbfs pages,
covering the vast majority of the machine's memory.  On such hosts,
modules like DAMON_STAT observe only the host-side remainder (page
cache, daemons) and report all guest working sets as permanently
idle, defeating the purpose of host-level access monitoring.  In
testing on a 1 TiB host, an hour of 4-thread random access over 842 GiB
inside a guest was statistically indistinguishable from an idle host,
while a 40x smaller host-side workload produced a quantitatively
correct response.

Add damon_get_monitor_folio(), which additionally accepts hugetlb
folios, and use it in the two paddr access monitoring primitives,
damon_pa_mkold() and damon_pa_young().  With the previous commit
teaching the folio-granular rmap walkers to age huge PTEs and to call
the mmu notifiers spanning the whole huge page, this makes guest
accesses visible through secondary MMU (e.g. KVM/EPT) young bits.

Free hugetlb pool folios have a zero refcount, so folio_try_get()
naturally keeps rejecting them.

The DAMOS action appliers (damon_pa_pageout(),
damon_pa_mark_accessed_or_deactivate(), damon_pa_migrate(),
damon_pa_stat()) keep using damon_get_folio(): reclaim, LRU
manipulation and migration cannot act on hugetlb folios, so their
behavior is unchanged.

Note that the access check granularity for hugetlb-backed memory is the
huge page size: one touched byte reports the whole (up to 1 GiB) page
as accessed.  Also, DAMON now consumes secondary MMU young bits that
KVM's own aging uses; at DAMON's sampling rate (one page per region per
sampling interval) the interference is negligible.

Link: https://lore.kernel.org/20260902025700.17975-4-kiyer@crusoe.ai
Cc: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 25 +++++++++++++++++++++----
 mm/damon/ops-common.h |  1 +
 mm/damon/paddr.c      |  4 ++--
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 349e1604cc1b1..acf8f216c51cc 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -15,14 +15,20 @@
 #include "../internal.h"
 #include "ops-common.h"
 
+static bool damon_folio_acceptable(struct folio *folio, bool monitor)
+{
+	return folio_test_lru(folio) ||
+		(monitor && folio_test_hugetlb(folio));
+}
+
 /*
- * Get an online page for a pfn if it's in the LRU list.  Otherwise, returns
- * NULL.
+ * Get an online page for a pfn if it's in the LRU list, or a hugetlb folio if
+ * @monitor is set.  Otherwise, returns NULL.
  *
  * The body of this function is stolen from the 'page_idle_get_folio()'.  We
  * steal rather than reuse it because the code is quite simple.
  */
-struct folio *damon_get_folio(unsigned long pfn)
+static struct folio *__damon_get_folio(unsigned long pfn, bool monitor)
 {
 	struct page *page = pfn_to_online_page(pfn);
 	struct folio *folio;
@@ -33,13 +39,24 @@ struct folio *damon_get_folio(unsigned long pfn)
 	folio = page_folio(page);
 	if (!folio_try_get(folio))
 		return NULL;
-	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
+	if (unlikely(page_folio(page) != folio) ||
+			!damon_folio_acceptable(folio, monitor)) {
 		folio_put(folio);
 		folio = NULL;
 	}
 	return folio;
 }
 
+struct folio *damon_get_folio(unsigned long pfn)
+{
+	return __damon_get_folio(pfn, false);
+}
+
+struct folio *damon_get_monitor_folio(unsigned long pfn)
+{
+	return __damon_get_folio(pfn, true);
+}
+
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr)
 {
 	pte_t pteval = ptep_get(pte);
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index f7811c9c7a024..172f0f17c4a84 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -6,6 +6,7 @@
 #include <linux/damon.h>
 
 struct folio *damon_get_folio(unsigned long pfn);
+struct folio *damon_get_monitor_folio(unsigned long pfn);
 
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr);
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index c1e7d7a4f40df..d2173a448d0b0 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -37,7 +37,7 @@ static unsigned long damon_pa_core_addr(
 
 static void damon_pa_mkold(phys_addr_t paddr)
 {
-	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
+	struct folio *folio = damon_get_monitor_folio(PHYS_PFN(paddr));
 
 	if (!folio)
 		return;
@@ -67,7 +67,7 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 
 static bool damon_pa_young(phys_addr_t paddr)
 {
-	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
+	struct folio *folio = damon_get_monitor_folio(PHYS_PFN(paddr));
 	bool accessed;
 
 	if (!folio)
-- 
2.47.3

