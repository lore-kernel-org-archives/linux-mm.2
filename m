Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45FA9C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DC986B008A; Fri, 28 Aug 2026 14:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63EA76B00A9; Fri, 28 Aug 2026 14:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E306B00AA; Fri, 28 Aug 2026 14:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 311206B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:37:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5AFDC04E5
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:52 +0000 (UTC)
X-FDA: 85151537184.22.498B616
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id D56D0C000F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aU5TzBfX;
	spf=pass (imf22.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942270;
	b=QMs0P7SiPd8Wf1BYdb72zlsVa0uYQgoV48tI+LUODH1PEmdDpCPhRqDR6SmlyxNdmPho4P
	WacQERKeGxCFqzXqIL9h9tRneyWEDQAYYVe0c8OcK3/LACFIOhgN2mfE1/F55unXbJEpi8
	6GKW3ZEcRra6NKtq+V8B3tUVY674olU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zk9fbsTtY0uQCDGritDt2l0ASVNz5DfiHm7Yt38aS10=;
	b=zgt8Sq9stjZypdGgFJq/quqb4TdzbK+uZtI/cfdvkySwzKBQSjNwZcIPgw6dvfJUh/WBnc
	Gj9aEzd+BLD98qbxMpE+NFuumfeggSrHoz2E+hHIT9KpONyUw6N1OU5Ac8YUFtAjcsNy9p
	xeF/dIEBLwZhXJGG0cRc0xj2xaA5p+I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aU5TzBfX;
	spf=pass (imf22.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-85590c5aeabso1168188b3a.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787942270; x=1788547070; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zk9fbsTtY0uQCDGritDt2l0ASVNz5DfiHm7Yt38aS10=;
        b=aU5TzBfXSYjN6jtqCQImHOD24m9lVMvn0WmnAygykwqCZdOukWfaRhECQXjNo2ZAxW
         aj7noF0JOJjK8gZQ+u1YQpu6bbbz95/fDL3bq00heN+GBJOwljDpbWDrXSW4lShiHkRa
         mu0JyxD0mafidHxHLNPD4hqxMbt9zGawwnb0delnx0S43IbXVo3llhYoKjpYWvtUvsVT
         PRnAVBBq8EqcNLbVoSWVU6Jwo3KqsSm1NUo2SSOPPAN2wyG5RIXgCCuM+p7LLQWWsZkN
         4RK8yFuMzZ7PiDUNU8HFZ7N29YAeJxyPkCfbZT2HCFnuD1xSSM71wLZ1jfBZO+mbEEA4
         iSZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787942270; x=1788547070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zk9fbsTtY0uQCDGritDt2l0ASVNz5DfiHm7Yt38aS10=;
        b=nZwH1ZAZbVohs1WVL4NHGKA8el881Qk2If+v4R2sFMhYvI0cnlgUP8pdFR57r9pWAb
         ourdgBBIEYUmBgqLC6B+DQvOruRpnYepUraXuw0eD+AaLm+QqwWsuK20B5cnYnNGcDnk
         Gqqma+k9VrRmEjOMf+JGiF1NBPxGKOipmyxBXGFlOSfBf5MzhWhleN4CDRojAydxgSVQ
         PhC3QcP1GglnZBqTX7bCSnc5kTWFWB76Z9laFGC3mkzxQ3wK23jXnUfOCb10++xQ2ihd
         Vez41tlp/3A4oT0xpwJ4QmDWSn1pDlQElVEJM8ryK8mIyL/+7Jwmb3eQLiCneIb6PqD0
         Laag==
X-Forwarded-Encrypted: i=1; AHgh+Rpscz+PUg3xSHpVpYmDmTzGKc5M//MeAhuFYltrE1/pXjTYaYdigj5/t3VkN2SlDrm3zCBkzcmoTg==@kvack.org
X-Gm-Message-State: AFuF++lKLJXK3TCPLycVSKo8AflVUrIgc97n9odgubP2RfWXjot+K/YC
	iBnA9/FKSG9ePMMC4XwcY0O8tiAgSexmbJy8LPWTR6DuVjIe+NHyGos9IXcXZ2ax
X-Gm-Gg: AR+sD10wniB5TLjgtvwvfMM+ZG+NHdjjQNkV22ryTb34UnsZ1v6mOrS6+vQesjamfyL
	0D5Oqz31JT+vGKssyqW9NNIT6hvWNtgwJQjUzaaQyriw8ihhuEGMcxNVmxMl1fhi1XGFrfnb4RS
	j9fTft57YJ+3JCAzrF2GaQHsjhJtpyPTw95VhyjpOZtUxKIoRrzDkDU5unzlAgFcQdD5pL8Upd9
	KLYJ9suwtI2gk/S0hE9sgCg3XETE1s1iEhTcGtCNjogzO0VHWFjCZnxbWRj003UtQu++0gYJiA3
	1fKzDz9EjXiiyKI4VMoy3HgbYYavHePRz6qtLEdQh04x3uKfRqj9Uk3faOOcmLARgVgZ0doKbOj
	o1KxTH9Goksgq4gs1mrZ7WZ9l8xVQK5A/YM+oVY+X/YRFueAePvW+yhK5bxMPi1t9t2diGcIh+j
	apDi4Ww8vXUSYYeW9jlD4S1fxPbjBzX8N5VesvHusdWSqEhsrXEg2/wfczW36xaogBooKYbjPvJ
	4o3OiWruSXWK7bqbQ==
X-Received: by 2002:a05:6a00:3cd6:b0:857:7317:cff2 with SMTP id d2e1a72fcca58-8577317d17cmr2655096b3a.19.1787942269557;
        Fri, 28 Aug 2026 11:37:49 -0700 (PDT)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a2ea6fa3sm844230b3a.37.2026.08.28.11.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 11:37:49 -0700 (PDT)
From: Yin Tirui <yintirui@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	linux-kernel@vger.kernel.org,
	Yin Tirui <yintirui@gmail.com>
Subject: [PATCH RFC 6/9] mm/huge_memory: add and use split_huge_pmd_anon_rmap()
Date: Sat, 29 Aug 2026 02:33:16 +0800
Message-Id: <1022e5cfad8bb7e32946da7e881534730757bbbd.1787941780.git.yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1787941780.git.yintirui@gmail.com>
References: <cover.1787941780.git.yintirui@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D56D0C000F
X-Stat-Signature: n33d4g3ec63ujk5n7zpmtpy65nhewiwe
X-HE-Tag: 1787942270-48511
X-HE-Meta: U2FsdGVkX1/YL3WtEkiitW7qR6J01vKP1kWg3c4Ne2FhiCSPLpdDwTo1yTBAhV7+GT4WiIAP3k4po4AVsq7kYzmreAmaUSVNSdaQG0dcoKfjrcxitJeDlkSV4gSBvYxn25qW7pFtLLmBe2Z7evKdcam2Z6LDmRGMOMBMU3nrNq0qBdmFbEXNvpPP9bmuF1E4X2a/votfiaiv8YWTADnE0Cxul5wT76dDpPr6xUBaSMYSoWhA3wz+T65QgLP/e4Tdj/PPSEo3FSPyAHccSkCEVdmkcMoH48WAFqAm42jpS0cxdI49lRjWoHT/DU+IQ5PzjNVG21leHzn3TRYDntL4g6S7t1s/nQqnyCPccfCoPeLD5o2Id9oPcoUIdgvrt95KB5KyTmQZnJk8phuSWc/Tu0b+46Pas3RMN5d5nse/1TcZudo2ujN3sBd4O8nWnGevpsi7UHqu2Y84rluOvamGbmHIb0H3cb2R4JDEZmWc3x9ojS7oSfq0EbkjG9Gxwp8YeNI/4rpF+CcwIvzc1okyhxoCwpuDcgxhqqaJI+5lTKdUtj1mhSqQb1hob5H35qUDI2PF/N2g8bl6zy/a33QBwXzf9dSxPb3Kk4uNCPyuxspBzx1+SnnU7HgNd8+SMAFyPWSaoYIpSfc58OE5YpIkykBGOZhYYw/gZolPONtAtwKZemLPRFsn61dEGkkGVONJCdhM8kdSwtgtNU6EwTl4BxqW26G0NOwWKEFxqvgBBI5Ifvz7l6S658h7H6HuwH2Igx3QUUnoWrsfeT7abFJPDo8sbL86AsH1k34FJXFmiPUKT73uhOX407/+01c2ooMDJRhXrvJ8gxRQAkR2sM80TSnq9OoalZ+qAtKU33oOFPdR7biieaeVEeDhVeRBe5UyhawfNoYx17lHJPaaBkl96XtC1loj1M+NQfdeeFxhES/HhjBk2zmeduC/shaccCsx+vLFfN4xcrc9eX7yz44
 d9WTrufU
 MredsSGmICbli1WteOGOxc61M0oYMGwL/F2Mp0DDvskXluamsFglCrsLgUyZMNIix+Yikxc2OXi1IH2Lxf/kbyjCKR/A7Z9m9MFChWil0r21Hih95H3XlPj9/sZvKBBbsZUHnlSMUmDGC+VQBcdAfXexgRd1Ka4VvQAynNAjxdjxiVNU3F1ZCgqlZzvs3IUaIOerBjaIDFOEeAcl5hKLmpIw8jodf5Y3UDc2HJL4h4x38Ox/+lrEgu9TdDgxZaijwSERYiqjoJyEdvkCf0d55K0QfXhB2Mk2NU8jp2KDvDlsP/KVklwViKZ0yhP5zjvWf91M+3+Yrfm8ycwNMQ119SHznOO6Ya3x/qlqkC3OHCHAiDk45aT22HE/Yn8kvDLIXUJaIge4kGyXsSw/blP9IWZVMK2DJ+nsWRvNRz0pbQCseMvqVHvr5j34MUiHpnvNRK43cGQ9rO9xnFpM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The anon-exclusive handling and the PTE-level rmap conversion are written
twice, once for present entries and once for device private ones. Factor
them into one helper.

It returns whether the mapping may still be frozen instead of writing the
caller's freeze back.

No functional change intended.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 90 +++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 43 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1cd8878edc1d..e0083a9e89b8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3194,6 +3194,43 @@ static void unmap_huge_pmd_entry(struct vm_area_struct *vma,
 		folio_put(folio);
 }
 
+/*
+ * Convert the folio's PMD-level anonymous rmap into PTE-level ones.
+ *
+ * Without "freeze", we'll simply split the PMD, propagating the
+ * PageAnonExclusive() flag for each PTE by setting it for
+ * each subpage -- no need to (temporarily) clear.
+ *
+ * With "freeze" we want to replace mapped pages by
+ * migration entries right away. This is only possible if we
+ * managed to clear PageAnonExclusive() -- see
+ * set_pmd_migration_entry().
+ *
+ * In case we cannot clear PageAnonExclusive(), split the PMD
+ * only and let try_to_migrate_one() fail later.
+ *
+ * See folio_try_share_anon_rmap_pmd(): invalidate PMD first.
+ *
+ * Returns: whether the mapping may still be frozen.
+ */
+static bool split_huge_pmd_anon_rmap(struct folio *folio, struct page *page,
+		struct vm_area_struct *vma, unsigned long haddr, bool freeze,
+		bool anon_exclusive)
+{
+	rmap_t rmap_flags = RMAP_NONE;
+
+	if (freeze &&
+	    (!anon_exclusive || !folio_try_share_anon_rmap_pmd(folio, page)))
+		return true;
+
+	folio_ref_add(folio, HPAGE_PMD_NR - 1);
+	if (anon_exclusive)
+		rmap_flags |= RMAP_EXCLUSIVE;
+	folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR, vma, haddr,
+				 rmap_flags);
+	return false;
+}
+
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
@@ -3275,23 +3312,12 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		anon_exclusive = PageAnonExclusive(page);
 
 		/*
-		 * Device private THP should be treated the same as regular
-		 * folios w.r.t anon exclusive handling. See the comments for
-		 * folio handling and anon_exclusive below.
+		 * Device private folios are treated the same as regular folios
+		 * w.r.t. anon exclusive handling, see
+		 * split_huge_pmd_anon_rmap().
 		 */
-		if (freeze && anon_exclusive &&
-		    folio_try_share_anon_rmap_pmd(folio, page))
-			freeze = false;
-		if (!freeze) {
-			rmap_t rmap_flags = RMAP_NONE;
-
-			folio_ref_add(folio, HPAGE_PMD_NR - 1);
-			if (anon_exclusive)
-				rmap_flags |= RMAP_EXCLUSIVE;
-
-			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
-						 vma, haddr, rmap_flags);
-		}
+		freeze = split_huge_pmd_anon_rmap(folio, page, vma, haddr,
+						  freeze, anon_exclusive);
 	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
@@ -3315,6 +3341,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 * complete for this pmd), then we flush the SMP TLB and finally
 		 * we write the non-huge version of the pmd entry with
 		 * pmd_populate.
+		 *
+		 * This must also happen before PageAnonExclusive() is read
+		 * below, see folio_try_share_anon_rmap_pmd().
 		 */
 		old_pmd = pmdp_invalidate(vma, haddr, pmd);
 		page = pmd_page(old_pmd);
@@ -3329,34 +3358,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 		VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
 
-		/*
-		 * Without "freeze", we'll simply split the PMD, propagating the
-		 * PageAnonExclusive() flag for each PTE by setting it for
-		 * each subpage -- no need to (temporarily) clear.
-		 *
-		 * With "freeze" we want to replace mapped pages by
-		 * migration entries right away. This is only possible if we
-		 * managed to clear PageAnonExclusive() -- see
-		 * set_pmd_migration_entry().
-		 *
-		 * In case we cannot clear PageAnonExclusive(), split the PMD
-		 * only and let try_to_migrate_one() fail later.
-		 *
-		 * See folio_try_share_anon_rmap_pmd(): invalidate PMD first.
-		 */
 		anon_exclusive = PageAnonExclusive(page);
-		if (freeze && anon_exclusive &&
-		    folio_try_share_anon_rmap_pmd(folio, page))
-			freeze = false;
-		if (!freeze) {
-			rmap_t rmap_flags = RMAP_NONE;
-
-			folio_ref_add(folio, HPAGE_PMD_NR - 1);
-			if (anon_exclusive)
-				rmap_flags |= RMAP_EXCLUSIVE;
-			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
-						 vma, haddr, rmap_flags);
-		}
+		freeze = split_huge_pmd_anon_rmap(folio, page, vma, haddr,
+						  freeze, anon_exclusive);
 	}
 
 	/*
-- 
2.34.1


