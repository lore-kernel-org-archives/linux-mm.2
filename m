Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460D260A260F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mwgDVwYb
Received: by kanga.kvack.org (Postfix)
	id 894736B05B5; Tue, 10 Nov 2026 00:33:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C916B05B6; Tue, 10 Nov 2026 00:33:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7837A6B05B7; Tue, 10 Nov 2026 00:33:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1956B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:33:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2AD114087C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:33:39 +0000 (UTC)
X-FDA: 85418092158.10.A631BAB
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf26.hostedemail.com (Postfix) with ESMTP id DA766140003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:33:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mwgDVwYb;
	spf=pass (imf26.hostedemail.com: domain of 3sKzyaggKCDMYXPfXnPcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jiaqiyan.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3sKzyaggKCDMYXPfXnPcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794288818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BG6uusGfW4BQS4a7rj+WuxZomPKpk5tcwlM4xud+CGw=;
	b=L7h3A9oIUFm8E5mkNoecE1gBn/1vJqtlHhyCCvZFYzhpg8t2naqaSRfUXVBmPwqsfo1sbm
	4m+uRiEY6x44ii+S1z8uXRilZd6CLy/VIwTyl7cU+y3gc1OmoBwX2gnIvznLab5v5ynoZm
	tHaAkU3WKxTmKPCjqcYJQ+TkjZskXU0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794288818;
	b=pNpuhpqlzDaNEpCYXOZ/gOmW5Nl7cL4zDwWWE95iUbCW+eYEGR8De+8C3NhSBFgryB2/mv
	Iq+uBbtbR1SYuoMEs+D3/sCmlh7rF22yFFml7PEazdH6x4254ENpYBANVqf1Y5kVksMlV6
	JOjUwuBY692XD3nAq5heBK7U1sLueOk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mwgDVwYb;
	spf=pass (imf26.hostedemail.com: domain of 3sKzyaggKCDMYXPfXnPcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jiaqiyan.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3sKzyaggKCDMYXPfXnPcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ed00709df0so16425755ad.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794288817; x=1794893617; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BG6uusGfW4BQS4a7rj+WuxZomPKpk5tcwlM4xud+CGw=;
        b=mwgDVwYbvWRmO8oA7SbYEIFmlJZQFsKXrst1sqoVyvKb5YBwoD/ceGqzKzyrKNmtOu
         1t1mA25kS+eMxBwZS4+vH3kHmhKJTkolcwQbN2BNjj4gtzVroAwUajeOye3u8DLQNPIj
         gfsG6/ROe1Or2YxEeT7S+igd5drEFZ+0sNiP9jomZIFEJafoNpNFrtnqcdkGk4rXY67z
         bTRe5Cr0F8T6X3fhUkdxsiiiDUspJj0ruwOn6b/Ed/+8ePs64rFXfgfukZCTmftZL9JM
         fWiGrYvbvPVHk16QQcacJl0XkibT/ctCaia+QO2sfOztInmxw8vhfCvOhcHWdn2IQHoi
         lD0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794288817; x=1794893617;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BG6uusGfW4BQS4a7rj+WuxZomPKpk5tcwlM4xud+CGw=;
        b=LcdEVQEOUVot9aQFHEMSnzHujWA/SemE6nGz2pJegBvn3hlKMD33aBzRrDqXoOVVHi
         datDlqwIlMl/I+rQfChYJPwfJaxq4pdzW0xzVyixOysDHKFeCxSdoQ84pOSp1nn8Re4y
         M9Ta0X8v9RUiNclESulpNDu4t1mKsW8otZKNmevEC17tEzwRQk87SK52Gj79/aXRJIt+
         Ja/1ul+jSwPHoTH/v0fQUBs5GwzqPEVOSz5ZU7dzyqxbGoVhn6uZlHJ3/NUtcE8oPmcU
         hcDYpi9D4OHH/EE7DJQgwAwZGDokwrGIkCxUXhojfAey2ld0ECM7++myJ+nHauIL3ij+
         7ygg==
X-Forwarded-Encrypted: i=1; AL+hErEW8nANUUfk+JVdFmX+ZGNWrs8Or/Q2uZCVnu9AR7KNoqrkzoemLoNM3Jxn7IqrWKCRvA04kmAcBg==@kvack.org
X-Gm-Message-State: APuU4Z/jOapg0z+JIodi6p/mWVbTMR+Qt3qeOBE0iJ2sf+1zZpZsPYf6
	kB58RfDy5DhLUlM6Q3eylFcYk1dxfk3EVFU1eXpOklo5I3LSBLkXuPuReIxxlMkY1dSk17Hhfyg
	OHbXmOXCbHY98gw==
X-Received: from plbio14.prod.google.com ([2002:a17:903:12ce:b0:2e5:ffbf:77d8])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2ac6:b0:2ed:e93:71af with SMTP id d9443c01a7336-2edb924365fmr15045795ad.41.1794288816426;
 Mon, 09 Nov 2026 21:33:36 -0800 (PST)
Date: Tue, 10 Nov 2026 05:33:30 +0000
In-Reply-To: <20261110053331.2708996-1-jiaqiyan@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110053331.2708996-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110053331.2708996-3-jiaqiyan@google.com>
Subject: [PATCH v7 2/3] mm/page_alloc: only free healthy pages in high-order folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, vbabka@kernel.org
Cc: osalvador@kernel.org, ljs@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, osalvador@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: 8kkmjgqnnqxbryd4546xzirs4bmwepk3
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DA766140003
X-Rspam-User: 
X-HE-Tag: 1794288817-436965
X-HE-Meta: U2FsdGVkX18UatiZ9yFRXz7GJTt1TpOQhjIwOc7wyWPF+NV6eAKz4roEmk0OCw+vb5HO2Jtbtq7Jb9t4+uw/Y+lSNOEGrosHjMyInrIZGJpAsVoh/41qPcwpOaRznZoIlVYeEdhYCou6KH0QhdDIzAdowoLr08rhac+W9ORz696jXntjCDy+CHRh0YjJZMq42SChgiuVBshMXJChl95EndBdZldEe3w79ppYkMsj3tnaqTlE5fWjkhXnAlJjC26zCii3wzsa2RprbIpHX4Raofy5akLgZeTo7JX9gWzBSAm/iYFD4LjiEfkSRYj2nrLaszpBHkjQ11qtpmnPcgqEDzh7Ct+KtRnslurrn+zpjdfDX8DMKuPTWb+NXGBy1mueSC19qgvMuXntv++3MhuvgMb2GLZPibcLV1/MSVAxIDf2JQXH2pLf3fU5S5spNBpNvw+6dOJEpJqZhKhfIA9ety2OdGO8iNoyt3n+T6rOz/h88eAGnn9ImwouzdxMVEKCgNDcje1ljhjoOqyHIYhP1MgtL6jFXIEJtA0FM0Guakp/H1upCY3eudOt67gEVfuAk++vuNQNMKle3I10wmqM7QACA5CwG5vKSvCT6pxjzPDpW4aBunIBAwF+qD+GtylFp0wtdiVL68dzknJLgoOMm5fAGEx5cdE7H5NuMTZFM0A/+NoUzwvWN62Ke18YeTZoMhfo//+/lZNJilWcYD1p8RQOpxvYErLkkMGKastHwxpg346yLe4CYZ5WJi5um63OLB4RR2UXyTgw0fbLVsPhRDghLRM0rsWsFqSbH8r4rZXRduAYEU99hBMLa1lBhK0GZ1cgqiYS5WQbUkVJZ7vvtU5dPQTVkuYaaIrdldUDlFRG3cmmw99/2bVH0trnu7uJ9OQfflQdjXy2O1IoBAl6eTWATNnLQsEjfsyMXVdtuN4PpxMkpmEHS3AmSSL9/lpoRnNSHuG1mfW9/EOCejL
 JkgKpNFv
 BBFK68FrVmakqxuzFXmdCqZ2DiJw+Y9v9UFGgvtogP6StQtirI8XAk7LvRXC3kMi0C6sXsayTcLOSdVq0ibC/GGisvgU5kfki0WmzsJf2bZds40BimdgOvuPQYREJo2baahpufmHEmnQkZTpAkU69dHrFGsbHmsElIClAc5RWxVvCeNeO0FpNT2tlBlUiC+z31KR4Vp6S6XiCsXHT6rvmOLx+XhF9C9hLs4qMdRbjR1J8rNDsDWPEBk79Pxe5qei46OiHH+MtgjR8XSZ4PZyOalIcJ+InPBgtEzxUakoZ7JrT+TZqWqsNMvgjSdHs4Lqaqzs1aaDK+GPe7RiYQLFoElmLx77+O3eTLcmoXB3Evvs93cU4Tw01GYI3JpZxJFceE7pLeE076BSWwske00EQls2tKW9pM13AQxSP8UPmEvSQNxoAujOKwWtV1muduiAl0r/lr2QIys9M5226nIQk5diGi4WjTe/M/k9GgRk+8sL4kLRoqpCEh0W0A15chSr54NUxkM+acxHKEG4G0OQcUdTVK2I9mrqHDTBOXckd5WFHRZQUa9Ka2TlIsPLzC2+4KE7r7a0m1L9EXjdUOtLDf4REuWfRndBvVxx3/pZualxJSUEnX18I+tvR1BLJ1hA1beG8zy5sJuqi4Tbxy+SGUY56PhLMUT4H9vPqVTYdUxSOeZrVdn1QxKCuZ4VRTs7w0Ia/zKLf/vbQv92xm+GvoKTlasi5fm52iQLHzzjS2wDVIGvLcDKcnOyGXpGgvvn9SzX8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
becomes non-HugeTLB, and it is released to buddy allocator as a
high-order folio, e.g. a folio that contains 262144 pages if the
folio was a 1G HugeTLB hugepage.

This is problematic if the HugeTLB hugepage contained HWPoison
subpages. In that case, since buddy allocator does not check
HWPoison for non-zero-order folio, the raw HWPoison page can be
given out with its buddy page and be re-used by either kernel or
userspace.

Memory failure recovery (MFR) in kernel does attempt to take raw
HWPoison page off buddy allocator after
dissolve_free_hugetlb_folio(). However, there is always a time
window between dissolve_free_hugetlb_folio() frees a HWPoison
high-order folio to buddy allocator and MFR takes HWPoison raw page
off buddy allocator. Worse, a free HWPoison HugeTLB folio can also
be dissolved outside of MFR, e.g. when shrinking the HugeTLB pool,
and then nobody takes its HWPoison pages off buddy allocator.

Another similar situation is when a transparent huge page (THP)
runs into memory failure but splitting failed. Such THP will
eventually be released to buddy allocator when owning userspace
processes are gone, but with certain subpages having HWPoison.

One obvious way to avoid these problems is to always check
PageHWPoison() when allocating pages, which check_new_pages() only
does if page sanity checks are enabled. However, it is against the
past efforts to reduce sanity check overhead [1,2,3].

Instead, keep HWPoison pages out of buddy allocator when freeing a
high-order folio. __free_pages_prepare() already walks through all
tail pages of a high-order folio to check and clear their flags, so
counting PageHWPoison() pages in that loop is cheap, as pointed out
by David Hildenbrand [4]. Unlike PG_has_hwpoisoned, which is only
maintained for THP, this catches HWPoison pages in any high-order
folio, including dissolved HugeTLB folios.

If any HWPoison page is found, then after all checks and
preparations in __free_pages_prepare() succeed, take a shortcut to
the newly introduced free_has_hwpoisoned(), which only frees the
healthy pages and excludes the HWPoison ones. __free_pages_prepare()
then returns false so that its callers don't free the folio again.

free_has_hwpoisoned() iterates through the pages of the folio to
identify contiguous ranges of healthy pages. It uses
free_prepared_contig_range() to decompose each healthy range into
the largest possible chunks of different orders, which are then
freed via __free_frozen_pages(). Knowing the number of HWPoison
pages from __free_pages_prepare(), it stops scanning once all of
them are found, and frees the remaining pages without scanning them.

Sanitizing pages at free time (e.g. page poisoning and init_on_free)
may write to page contents, which must be avoided for HWPoison
pages. So factor it out of __free_pages_prepare() into
free_pages_sanitize(), and skip it for a folio that has HWPoison
pages. Instead, free_has_hwpoisoned() passes the new FPI_SANITIZE
flag to free_prepared_contig_range(), which then sanitizes each
healthy chunk right before freeing it.

Each excluded HWPoison page is treated like a page that
memory_failure() takes off buddy allocator: it is marked
PageHWPoisonTakenOff and holds a refcount of 1. Its alloc tag
reference is also cleared, as is done for an order-0 HWPoison page
in __free_pages_prepare(). This allows unpoison_memory() to put it
back to buddy allocator via put_page_back_buddy() instead of leaking
it.

As a result, memory_failure() no longer needs to take HWPoison pages
off buddy allocator after dissolving a HugeTLB folio. For a free
HugeTLB folio, or an anonymous one that becomes free after being
unmapped, try_memory_failure_hugetlb() and me_huge_page() call
__page_handle_poison(), which disables pcplists, dissolves the folio
and then calls take_page_off_buddy(). Since the raw HWPoison page
never reaches buddy allocator now, take_page_off_buddy() would fail,
and memory_failure() would report MF_FAILED.

So add __hugepage_handle_poison() for these two callers. It dissolves
the folio and then checks whether the raw HWPoison page has been
isolated, i.e. is HWPoisonTakenOff. It doesn't test any HugeTLB
flags, because the folio may have already been freed, e.g. by
folio_put() in me_huge_page() if it was a surplus folio, or by a
concurrent dissolve. If the folio's raw_hwp_list is unreliable,
__update_and_free_hugetlb_folio() leaks the folio and the raw
HWPoison page is not isolated, so memory_failure() still reports
MF_FAILED. As free_has_hwpoisoned() already holds a refcount on
each isolated page, the callers no longer page_ref_inc() it. Soft
offline keeps using __page_handle_poison(), because it marks a page
HWPoison only after taking it off buddy allocator.

free_has_hwpoisoned() has linear time complexity wrt the number of
pages in the folio; the worst case is when the last page of the
folio is HWPoison. While the power-of-two decomposition keeps the
number of calls to buddy allocator small, the linear scan of pages
to identify PageHWPoison() defines the overall time complexity. For
a 1G hugepage having 8 HWPoison pages and if the last page is HWPoison,
free_has_hwpoisoned() takes in worst case 15x the time free_one_page()
takes for a healthy 1G hugepage, measured on a system having 56 Intel
Skylake physical cores. The cost is nontrivial but far from triggering
soft lockup, and fair for handling exceptional hardware memory errors.

This commit message text was reworded with an AI assistant, then
reviewed and edited by me. The code changes are my own, but they
are reviewed by the AI assistant.

[1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
[2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
[4] https://lore.kernel.org/linux-mm/8e48c288-2183-4d58-b69d-5f78344b5da5@kernel.org

Assisted-by: Antigravity:claude-opus-5-5
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/internal.h       |   3 +
 mm/memory-failure.c |  52 +++++++++-----
 mm/page_alloc.c     | 170 +++++++++++++++++++++++++++++++++++++-------
 3 files changed, 183 insertions(+), 42 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 9b8864a8540a..3ccbf7e4439a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1195,6 +1195,9 @@ static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, b
 {
 	return -EBUSY;
 }
+
+static inline void SetPageHWPoisonTakenOff(struct page *page)
+{
+}
 #endif
 
 extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b215312f261b..b456e0996ecd 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -214,7 +214,40 @@ static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
 
 static DEFINE_MUTEX(pfn_space_lock);
 
+static inline bool PageHWPoisonTakenOff(struct page *page)
+{
+	return PageHWPoison(page) && page_private(page) == MAGIC_HWPOISON;
+}
+
+/*
+ * Only for a HugeTLB page being handled by memory_failure().
+ * Unlike soft_offline_page(), no HWPoison subpage makes it into
+ * buddy allocator when the folio is freed, so take_page_off_buddy()
+ * is unnecessary.
+ *
+ * Return values:
+ *   1:   the folio is dissolved and the page is isolated with
+ *        HWPoisonTakenOff and refcount=1. Caller must not take
+ *        another refcount.
+ *   0:   the folio is dissolved but the page is not isolated,
+ *        e.g. the folio's raw_hwp_list is unreliable.
+ *   < 0: failed to dissolve folio.
+ */
+static int __hugepage_handle_poison(struct page *page)
+{
+	/*
+	 * N.B.: we can race with concurrent dissolve when called
+	 * from me_huge_page(), the folio may already be freed by
+	 * folio_put() (surplus folio) or dissolved concurrently.
+	 * So checking any HPG flags is not safe.
+	 */
+	int ret = dissolve_free_hugetlb_folio(page_folio(page));
+
+	return ret ? ret : PageHWPoisonTakenOff(page);
+}
+
 /*
+ * Only for a free or HugeTLB page being handled by soft_offline_page().
  * Return values:
  *   1:   the page is dissolved (if needed) and taken off from buddy,
  *   0:   the page is dissolved (if needed) and not taken off from buddy,
@@ -1204,12 +1237,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		 * subpages.
 		 */
 		folio_put(folio);
-		if (__page_handle_poison(p) > 0) {
-			page_ref_inc(p);
-			res = MF_RECOVERED;
-		} else {
-			res = MF_FAILED;
-		}
+		res = __hugepage_handle_poison(p) > 0 ? MF_RECOVERED : MF_FAILED;
 	}
 
 	if (has_extra_refcount(ps, p, extra_pins))
@@ -1352,11 +1380,6 @@ static int page_action(struct page_state *ps, struct page *p,
 	return action_result(pfn, ps->type, result);
 }
 
-static inline bool PageHWPoisonTakenOff(struct page *page)
-{
-	return PageHWPoison(page) && page_private(page) == MAGIC_HWPOISON;
-}
-
 void SetPageHWPoisonTakenOff(struct page *page)
 {
 	set_page_private(page, MAGIC_HWPOISON);
@@ -2150,12 +2173,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 	 */
 	if (res == MF_HUGETLB_FREED) {
 		folio_unlock(folio);
-		if (__page_handle_poison(p) > 0) {
-			page_ref_inc(p);
-			res = MF_RECOVERED;
-		} else {
-			res = MF_FAILED;
-		}
+		res = __hugepage_handle_poison(p) > 0 ? MF_RECOVERED : MF_FAILED;
 		return action_result(pfn, MF_MSG_FREE_HUGE, res);
 	}
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 93dc29480ba1..49f00559b890 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -96,6 +96,13 @@ typedef int __bitwise fpi_t;
 /* free_pages_prepare() has already been called for page(s) being freed. */
 #define FPI_PREPARED		((__force fpi_t)BIT(3))
 
+/*
+ * Page(s) needs to go through free_pages_sanitize(), for example, because
+ * free_pages_prepare() cannot sanitize a high-order page block due to
+ * hardware error in some page(s).
+ */
+#define FPI_SANITIZE		((__force fpi_t)BIT(4))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
@@ -213,6 +220,9 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 unsigned int pageblock_order __read_mostly;
 #endif
 
+static void free_has_hwpoisoned(struct page *page, unsigned int order,
+				unsigned int num_hwpoisoned,
+				fpi_t fpi_flags);
 static void reserve_highatomic_pageblock(struct page *page, int order,
 					 struct zone *zone);
 
@@ -1312,14 +1322,65 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
+/*
+ * Sanitize, which requires writing, a block of pages at the last moment of
+ * preparing to free them, i.e. __free_pages_prepare().
+ */
+static void free_pages_sanitize(struct page *page, unsigned int order)
+{
+	bool init = want_init_on_free();
+	/*
+	 * __kasan_unpoison_pages() sets kasan tag on every tail page, so
+	 * it is fine to use should_skip_kasan_poison() when pages here
+	 * were a set of tail pages from a compound folio.
+	 */
+	bool skip_kasan_poison = should_skip_kasan_poison(page);
+
+	kernel_poison_pages(page, 1 << order);
+
+	/*
+	 * As memory initialization might be integrated into KASAN,
+	 * KASAN poisoning and memory initialization code must be
+	 * kept together to avoid discrepancies in behavior.
+	 *
+	 * With hardware tag-based KASAN, memory tags must be set before the
+	 * page becomes unavailable via debug_pagealloc or arch_free_page.
+	 */
+	if (!skip_kasan_poison) {
+		kasan_poison_pages(page, order, init);
+
+		/* Memory is already initialized if KASAN did it internally. */
+		if (kasan_has_integrated_init())
+			init = false;
+	}
+	if (init)
+		clear_highpages_kasan_tagged(page, 1 << order);
+
+	/*
+	 * arch_free_page() can make the page's contents inaccessible.  s390
+	 * does this.  So nothing which can access the page's contents should
+	 * happen after this.
+	 */
+	arch_free_page(page, order);
+
+	debug_pagealloc_unmap_pages(page, 1 << order);
+}
+
+/*
+ * Returns
+ * - true: checks and preparations all good, caller can proceed freeing.
+ * - false: do not proceed freeing for one of the following reasons:
+ *   1. Some check failed so it is not safe to proceed freeing.
+ *   2. A compound page has some HWPoison pages. The healthy pages
+ *      are already safely freed, and the HWPoison ones isolated.
+ */
 static __always_inline bool __free_pages_prepare(struct page *page,
 		unsigned int order, fpi_t fpi_flags)
 {
 	int bad = 0;
-	bool skip_kasan_poison = should_skip_kasan_poison(page);
-	bool init = want_init_on_free();
 	bool compound = PageCompound(page);
 	struct folio *folio = page_folio(page);
+	unsigned int num_hwpoisoned = 0;
 
 	if (fpi_flags & FPI_PREPARED)
 		return true;
@@ -1376,6 +1437,7 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 			folio->_nr_pages = 0;
 #endif
 		}
+		num_hwpoisoned += PageHWPoison(page);
 		for (i = 1; i < (1 << order); i++) {
 			struct page *tail_page = page + i;
 
@@ -1394,6 +1456,7 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 				}
 			}
 			tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			num_hwpoisoned += PageHWPoison(tail_page);
 		}
 	}
 	if (folio_test_anon(folio)) {
@@ -1425,34 +1488,20 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 					   PAGE_SIZE << order);
 	}
 
-	kernel_poison_pages(page, 1 << order);
-
 	/*
-	 * As memory initialization might be integrated into KASAN,
-	 * KASAN poisoning and memory initialization code must be
-	 * kept together to avoid discrepancies in behavior.
+	 * After breaking down compound page and dealing with page metadata
+	 * (e.g. page owner and page alloc tags), take a shortcut if this
+	 * was a compound page containing certain HWPoison subpages.
 	 *
-	 * With hardware tag-based KASAN, memory tags must be set before the
-	 * page becomes unavailable via debug_pagealloc or arch_free_page.
+	 * Pass FPI_SANITIZE to only free_pages_sanitize() healthy pages.
 	 */
-	if (!skip_kasan_poison) {
-		kasan_poison_pages(page, order, init);
-
-		/* Memory is already initialized if KASAN did it internally. */
-		if (kasan_has_integrated_init())
-			init = false;
+	if (unlikely(num_hwpoisoned)) {
+		free_has_hwpoisoned(page, order, num_hwpoisoned,
+				    fpi_flags | FPI_SANITIZE);
+		return false;
 	}
-	if (init)
-		clear_highpages_kasan_tagged(page, 1 << order);
-
-	/*
-	 * arch_free_page() can make the page's contents inaccessible.  s390
-	 * does this.  So nothing which can access the page's contents should
-	 * happen after this.
-	 */
-	arch_free_page(page, order);
 
-	debug_pagealloc_unmap_pages(page, 1 << order);
+	free_pages_sanitize(page, order);
 
 	return true;
 }
@@ -7059,7 +7108,14 @@ static void free_prepared_contig_range(struct page *page,
 		/*
 		 * Free the chunk as a single block. Our caller has already
 		 * called free_pages_prepare() for each order-0 page.
+		 *
+		 * If the original compound page has HWPoison page,
+		 * free_pages_prepare() has to skip sanitize at that time,
+		 * but now it is good time to do that.
 		 */
+		if (fpi_flags & FPI_SANITIZE)
+			free_pages_sanitize(page, order);
+
 		__free_frozen_pages(page, order, fpi_flags | FPI_PREPARED);
 
 		pfn += 1UL << order;
@@ -7141,6 +7197,69 @@ void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
 	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ false);
 }
 
+/*
+ * Given some contiguous pages that have num_hwpoisoned HWPoison page(s),
+ * free only the healthy ones.
+ *
+ * Used at the end of __free_pages_prepare(). Even if having HWPoison pages,
+ * breaking down compound page and clearing metadata (e.g. page owner, alloc
+ * tag) can be done together during __free_pages_prepare(), which simplifies
+ * the splitting here: unlike __split_unmapped_folio(), there is no need to
+ * turn split pages into a compound page or to carry metadata.
+ *
+ * It scans every raw page of the compound page and causes nontrivial overhead.
+ * So only use this when the compound page contains HWPoison page(s).
+ *
+ * This implementation needs rework in memdesc world.
+ */
+static void free_has_hwpoisoned(struct page *page, unsigned int order,
+				unsigned int num_hwpoisoned,
+				fpi_t fpi_flags)
+{
+	unsigned long curr = page_to_pfn(page);
+	unsigned long end_pfn = curr + (1UL << order);
+	unsigned long next;
+	struct page *hwpoisoned;
+
+	while (curr < end_pfn) {
+		if (!num_hwpoisoned) {
+			/* No more HWPoison page in [curr, end_pfn) */
+			free_prepared_contig_range(pfn_to_page(curr),
+						   end_pfn - curr, fpi_flags);
+			break;
+		}
+
+		next = curr;
+		while (next < end_pfn && !PageHWPoison(pfn_to_page(next)))
+			++next;
+
+		if (next != end_pfn) {
+			hwpoisoned = pfn_to_page(next);
+			/*
+			 * Avoid accounting error when the page is freed
+			 * by unpoison_memory().
+			 */
+			clear_page_tag_ref(hwpoisoned);
+			/*
+			 * unpoison_memory() will put_page_back_buddy()
+			 * for HWPoisonTakenOff pages. Increment refcount
+			 * to avoid VM_BUG() from put_page_testzero().
+			 */
+			page_ref_inc(hwpoisoned);
+			SetPageHWPoisonTakenOff(hwpoisoned);
+			--num_hwpoisoned;
+		}
+
+		free_prepared_contig_range(pfn_to_page(curr), next - curr,
+					   fpi_flags);
+
+		if (next == end_pfn)
+			break;
+
+		curr = next + 1;
+	}
+}
+
 #ifdef CONFIG_CONTIG_ALLOC
 /* Usage: See admin-guide/dynamic-debug-howto.rst */
 static void alloc_contig_dump_pages(struct list_head *page_list)
@@ -7891,6 +8010,7 @@ bool put_page_back_buddy(struct page *page)
 		int migratetype = get_pfnblock_migratetype(page, pfn);
 
 		ClearPageHWPoisonTakenOff(page);
+		free_pages_sanitize(page, 0);
 		__free_one_page(page, pfn, zone, 0, migratetype, FPI_NONE);
 		if (TestClearPageHWPoison(page))
 			return true;
-- 
2.56.0.506.g506a7eabc5-goog


