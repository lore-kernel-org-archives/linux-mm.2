Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA47CC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 05:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298C36B008C; Sun, 30 Aug 2026 01:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249266B0092; Sun, 30 Aug 2026 01:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074076B0095; Sun, 30 Aug 2026 01:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0A526B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:14:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B9F740271
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:14:14 +0000 (UTC)
X-FDA: 85156769628.11.E060F0F
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9808F80003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:14:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=fW8TA8MQ;
	spf=pass (imf02.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.215.177 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788066852;
	b=KviTV93rTvLwQEqTR+hvocuIzzC+06eA9nPNFxOQiH7xM7mT429X81j6MssafMdrHRqhS3
	jGAiEEjTvhM8ADVwuJ2lcT3h7sFgu8zCac+YBWZp2TEDVJRoJKNn34QP1jw+MR9g4A/tz7
	ipxhNMeFogr9jsRHhTpOCUOJI+cM0l8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788066852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Qq90Jf7KadtS5HpHzOCYry3UrGmes12BSmNzbFVazM=;
	b=5FNaTX/BIpwrhwt6CtOT4mvp++dL6/xd19P+N0uSbqH1Kv1ifqWIxFpSZgmag3ZQRVP/Lk
	7jUgNDxlBuYjowyHV4el9QlYCROiOe7YXWFyY9koxO1MlunXugddXFjiR5qzf7LYrmIGRy
	BwVXBvx9SoURZpaSQtC4Ou9rw93xeQM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=fW8TA8MQ;
	spf=pass (imf02.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.215.177 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc1bcdb3c4cso1686978a12.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 22:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1788066851; x=1788671651; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Qq90Jf7KadtS5HpHzOCYry3UrGmes12BSmNzbFVazM=;
        b=fW8TA8MQsiKTEkCG73OCjc5vUN6EA/tVyoTJU9xsOmNACiSGqRGuGJBJVrtH+r0jco
         cKts+LoZrs8YBDCTXj3PKQwHxPXhosLy50r3P1lyCwcRsp5HV2Il8HSPpsZvLpPnFBzE
         7aTWqcupwE7VSlwNPSvnxigOG6x7COvYnNnP31Rl2hHvtZRBSmg0zpmjyie0ZFp6hNUe
         4YtqxIS7JMO0l40Kc+hgkkgTYON3qqUty16MZFJ/gg0iJPU/bfJCVngpvwloG8VXRsmZ
         T4/uYfQfvoO9BJr5Zbii1zKDlSkXy6RRcpzsWq8QFK07HkXZpsNouom9uJ2e+h+mDkuY
         sNFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788066851; x=1788671651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Qq90Jf7KadtS5HpHzOCYry3UrGmes12BSmNzbFVazM=;
        b=dpTDi95NRYBUOEgKzVZWb8ZHD3cdi6qKMqgRZcoD68HnlPr9myu0vTxp4qxJVAy+qS
         w7UOUloMkbLgTy9b8LYSjX+yiDhprZKQp1NhKberdvMR8b3k992PtiGmFgd92nqSBgVh
         MC8X6ZSORgBNoOrAn9NW41P4Xbx1WWjs2i/Tq7VqQdiQ+t0E0qFFe4K7gs4sDH0K5BHr
         AKNVDQkpzevDKFLMmCAYMfbLNtHRECRvs7vjahVABsgTPcN8kShl8HhRhvpGnITsdsEe
         uhZbUs0ZlkByQe4LVKCq1j/hVWl6VX6OJjgPuGlWI5ffM4chqZPh57TaA2JhGf9og14P
         6/nQ==
X-Forwarded-Encrypted: i=1; AHgh+RrucnaBbts7xSlTBMId2JpapgaIB3lDrlihfBUtOEqW37w9h0fQw9qCKR0AFl0R5Fdy4utZpFHktA==@kvack.org
X-Gm-Message-State: AFuF++ltsMJP35cdAqPicnzNgS7ltPdB9VJ8rAdQjN97UcvqMWJidF8z
	wK2ZkWyQ1kn/D5a4CawiFzmnFlo4uKRf8l8ZEOOvs9xwhlhj7J7OrBxVN2N4biMoxpQ=
X-Gm-Gg: AR+sD12gDNR7zvqjJSzvM9SoLO/4LVdBfle708TJGZZINBID57w9IWY+QHGCivHhFb1
	RtecIX/pY/5Tk/+tnBysb591xQnUEdkY8SsWavHf9Ff8UhUlqlUUQR3sPoKMdAYMf/yDL67EydC
	K0HryPHTPpQF5yURSLuIFiVXD8yWmTGLAqACOlVOMuYoW+uWzpfrqc5TmFkO9LLt+I6c9498c9h
	yEfi9uD32e7JDNVxmUNwXSIPhpX2f1+StwnL8akTBiyhjLTwsu9gMFih9W+wCOMQYCINlZ5SSBg
	T7tuNEItZmwnytzxtQkYaJzIoRG4Uo6ZRT2Sbizl+cn+aW0Ho7Jdes7gqNdqVh0dqzl/38eplBk
	GSeP7NvXT2oN3sJCw5MYGZ42Xu3KcCb1CyUJ+hJ244fs4QdAso3dWcqzfFRJQj4xE6hq3SmfhoG
	naPEAAraQ4JGDsSzNEq9UAUvxalCmr5Dis4klfgP/Jhil3Wv8pYWfAKn6NAJ5T5InD/nP6p6snL
	iRi1GiB1gB+nY2wQvPwtRa4iVaveJh5BhHP
X-Received: by 2002:a05:6a21:998a:b0:3c4:2b8b:e88f with SMTP id adf61e73a8af0-3d26646a960mr24213242637.5.1788066851383;
        Sat, 29 Aug 2026 22:14:11 -0700 (PDT)
Received: from MBP-Krishna-Iyer.civet-hops.ts.net ([2601:645:c68a:b830:d101:1d:112c:715e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286fa37fa5sm22595810eec.29.2026.08.29.22.14.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 22:14:11 -0700 (PDT)
From: Krishna Iyer <kiyer@crusoe.ai>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Krishna Iyer <kiyer@crusoe.ai>
Subject: [PATCH 2/6] mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap walkers
Date: Sat, 29 Aug 2026 22:14:03 -0700
Message-ID: <20260830051407.50008-3-kiyer@crusoe.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830051407.50008-1-kiyer@crusoe.ai>
References: <20260830051407.50008-1-kiyer@crusoe.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9808F80003
X-Stat-Signature: 8ipyjbdryr5ozr3akihd593xzfwdmhpj
X-HE-Tag: 1788066852-402286
X-HE-Meta: U2FsdGVkX18wnusD8iluzW1mUG5GYk4BL568UD4nvgGJ2NNpTcaLg6PWMddpkF4JlcssUDGLN33uP7uxHN9i6UGSi5ssOb4U91jCbKaL6fJv6l/kaoi51S3o9vr/9DiNbVB2jqxUenOsJoZSvVRiwdAZqWE7NVX/f3XWaXPaUHvX7oPnNXJHV2RaRdjf91ui4n0wl1HZWJbbD6owK+TfjFi1nDyuIHszX43VQtt4VRD8B3gsQLzhqEgid1XznxU5YgSG0Zd79TmWEyTPXcVvoRwBlUf1IAgR6wtUs/0M4UqgGqJYJ7GmaNlDaPdb7Rknn6+2G4skuaeg79gF9lXQqnDl7vaxpK5Y9uj+ZRR6hMsuQJnuBjSvIFEADOohzRf8B5cIVOTXtvf6mascjX/B6U699alELj/rqWsOvQ+Fis0U+h8/g4hgThSsLU17zGtV2Amm4t/2nLVCrFb+0MpnLh03mxSiIN0upaUZqZy3k1wAYpOOYpGsrqnYeijPV8uKUrO42SYoRczgyx574+/bmPLdy0WT4vlucyj/PH52avb416HIMAVDRaqrq+X4ypfUuBBTtYifQZT+Fo/AsONYlSOjuwULnzs9crGkJ/ezeJkmyCt/JoDKLyjHEVEIJGVuxYKYb/c68okyEg4rGqFWcE4IrylgSo+C1+/hGaFohjHwR2PTIlb3LaJSGu91dR6TLYbvV3G0D1s4lpxxVUNuEmYIoUD+6u01knfBzedkYR58mnXI5gKVwOA2+AETPhzIFQjsEMkV6ouUeQxOuhPwmZTby/k5qcAJGRVFAPrytjTptgMXBdq/pcdMQTzkWcXMDr3VbpyXqmkIMkmQaJ1xnJnklDGlvyfpyxNnLzDdBDw1YTwueSmYm/mBVY8EI4wehjMrNYSEOsF61x87pRhDyDtL1WZeNaxz1kexNSgRuWvcibfiUikAtT75M16lNsTQPdNRY/NkbQjGDLlHnAQ
 P86Ae4bI
 ztuLPxbfe2Km51MnBbpxuO8F8g2p6WlZNSkXugpRI5AjsxIs0Pu8cohknfv083w78UAYWhi2vVODYd7bvERyG94u6vtXI4SqJ0xPxGfTplBuelLzGHAHZSwGAyvbPid1AG6ljwoMOe/9Igj7JtAKlmsJZc0eltjn0zomcA1AujH6DR9xQqkGI6TP47dKmm6V5E+W7d8fNfzYoSj509yj+kzGZ1VVAzGhUUJReXdxP47PYSlg+35iSLRuNYn3F9egAWu3Dzte6zDdeT0W3ohkNnwCpQj54XM3Z8deXTBGTSWNx9AwK4n6k0Lh2gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_folio_mkold_one() and damon_folio_young_one() assume the folios
they walk are mapped by normal PTEs or THP PMDs.  When the folio is a
hugetlb folio, page_vma_mapped_walk() returns the huge PTE in pvmw.pte
with its page table lock held, but the walkers treat it as a normal
PTE: they read and age it with PAGE_SIZE-granularity helpers, which is
wrong for huge PTEs (up to PUD level), and notify secondary MMUs for
only PAGE_SIZE of the mapping.

Add hugetlb branches to both walkers.  The mkold walker reuses
damon_hugetlb_mkold(), which the virtual address space operations set
has been using for hugetlb aging: it clears the young bit of the huge
PTE via set_huge_pte_at() and calls mmu_notifier_clear_young() spanning
the whole huge page size.  The young walker gets an equivalent new
helper, damon_hugetlb_young(), which reads the huge PTE with
huge_ptep_get() and consults the page idle flag and
mmu_notifier_test_young() like the existing PTE branch.

Locking mirrors what page_vma_mapped_walk() provides: the huge PTE's
page table lock is held inside the walk, and for shared hugetlb
mappings (the only ones subject to huge PMD sharing), rmap_walk_file()
already holds i_mmap_rwsem, satisfying hugetlb_walk()'s locking
requirements.

This is currently dead code: both rmap walkers are only reachable
through damon_get_folio(), which rejects hugetlb folios since they are
not on the LRU lists.  A following commit will let the physical address
space monitoring primitives opt in to hugetlb folios.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
---
 mm/damon/ops-common.c | 63 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 11 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index f5fe92b825bb..62004206ca31 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -193,10 +193,20 @@ static bool damon_folio_mkold_one(struct folio *folio,
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
-		if (pvmw.pte)
-			damon_ptep_mkold(pvmw.pte, vma, addr);
-		else
+		if (pvmw.pte) {
+			/*
+			 * For hugetlb folios, page_vma_mapped_walk() sets
+			 * pvmw.pte to the huge PTE with its page table lock
+			 * held.
+			 */
+			if (folio_test_hugetlb(folio))
+				damon_hugetlb_mkold(pvmw.pte, vma->vm_mm, vma,
+						addr);
+			else
+				damon_ptep_mkold(pvmw.pte, vma, addr);
+		} else {
 			damon_pmdp_mkold(pvmw.pmd, vma, addr);
+		}
 	}
 	return true;
 }
@@ -221,6 +231,24 @@ void damon_folio_mkold(struct folio *folio)
 
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static bool damon_hugetlb_young(pte_t *pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio *folio)
+{
+	pte_t entry = huge_ptep_get(vma->vm_mm, addr, pte);
+
+	return (pte_present(entry) && pte_young(entry)) ||
+		!folio_test_idle(folio) ||
+		mmu_notifier_test_young(vma->vm_mm, addr);
+}
+#else
+static bool damon_hugetlb_young(pte_t *pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio *folio)
+{
+	return false;
+}
+#endif	/* CONFIG_HUGETLB_PAGE */
+
 static bool damon_folio_young_one(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, void *arg)
 {
@@ -232,16 +260,29 @@ static bool damon_folio_young_one(struct folio *folio,
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
 		if (pvmw.pte) {
-			pte = ptep_get(pvmw.pte);
-
 			/*
-			 * PFN swap PTEs, such as device-exclusive ones, that
-			 * actually map pages are "old" from a CPU perspective.
-			 * The MMU notifier takes care of any device aspects.
+			 * For hugetlb folios, page_vma_mapped_walk() sets
+			 * pvmw.pte to the huge PTE with its page table lock
+			 * held.
 			 */
-			*accessed = (pte_present(pte) && pte_young(pte)) ||
-				!folio_test_idle(folio) ||
-				mmu_notifier_test_young(vma->vm_mm, addr);
+			if (folio_test_hugetlb(folio)) {
+				*accessed = damon_hugetlb_young(pvmw.pte, vma,
+						addr, folio);
+			} else {
+				pte = ptep_get(pvmw.pte);
+
+				/*
+				 * PFN swap PTEs, such as device-exclusive
+				 * ones, that actually map pages are "old"
+				 * from a CPU perspective. The MMU notifier
+				 * takes care of any device aspects.
+				 */
+				*accessed = (pte_present(pte) &&
+						pte_young(pte)) ||
+					!folio_test_idle(folio) ||
+					mmu_notifier_test_young(vma->vm_mm,
+							addr);
+			}
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			pmd_t pmd = pmdp_get(pvmw.pmd);
-- 
2.54.0


