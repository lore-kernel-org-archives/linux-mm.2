Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E36FBC3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1096B00A4; Wed, 14 Oct 2026 13:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8E86B00A5; Wed, 14 Oct 2026 13:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0803A6B00A6; Wed, 14 Oct 2026 13:12:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6E8E6B00A4
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:12:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F35714068A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:27 +0000 (UTC)
X-FDA: 85321875534.30.3E5D068
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5142F18000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UP0d10/7";
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghheLVaJ/gX6nEonLl9gHN6oOmaGkKtSAgsx7MmKQ3g=;
	b=HRyhXfcErnDNyMVbZDoKXohb0ADtwS9PvaTWVPHTAloYa6TAfBDF4nCxg2stk8Lg0pg9Hf
	BlUDhKaISlHv34TbTmwJpNQMWsPGLTUwx2SjGu+sT6YEh+SiAM6j88llooiaF3OBka+lHx
	+EWxCtyoUvEkhQioK0k/YrXjSiGWycI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997945;
	b=7eWnvGNhHx4pqEjz+y0K9ryUsi6QdMEPCYBkIajLGZByBHSNMgvvINzjOtRuoCsZxWJOu9
	LAUoKLqoC1WjquEJbRkuj40145+/QznzuaPgQ+htGj31Uty9R1yk/VA6Xb5db6nX1W4U69
	lgjMeSara9/XGKXPk6QXYRGC2UMzpMc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UP0d10/7";
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDACD60A66;
	Wed, 14 Oct 2026 17:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C421F000C5;
	Wed, 14 Oct 2026 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791997944;
	bh=ghheLVaJ/gX6nEonLl9gHN6oOmaGkKtSAgsx7MmKQ3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UP0d10/7ajJS7uDLbamTgU+u3mYlInh1ovqKT9AsZnSfLXL86NU5zXtC6bucBOFmj
	 x8bTEPjZigb7Uoyp4/1Ml8bqcnGi68WfEA1HxEyb75ziiRBiHqf74r4I9io0+/X50d
	 QfF6bYbrGTaLnJOMnpPFW1VsmoHrrMYUEpP62QNpwxvmayXJilUZpmUe+L0h17q09D
	 HdQK7UO28IWCXXIf3BIXMd7yADj3SHGRZWCkEm66K7uNS1WHL3huReMn2BD0gaGZQz
	 XaQABApnybxpv0NmBmOQW7KgonSK8wsYrvtrl1HB1eaq62iIlp5vHPovvSxXOv2Fv3
	 qgu31KRDDqP4g==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 78FF0198003A;
	Wed, 14 Oct 2026 13:12:20 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 14 Oct 2026 13:12:21 -0400
X-ME-Sender: <xms:87fPauR2qh6wpjajOfP3uTiSlFKQaI_kIB9c8qC86zn_MP-wVi696Q>
    <xme:87fPavs12tDoc9VHQmgaEfnczZhhShtwu10LezhoTWiYy_CTSEL84GFvy7WDlALks
    wbXt2OEccPiSi5RaxbL446D-wF-Mxecvs4moCw6-tnxUAdyIhMBSec>
X-ME-Received: <xmr:87fPah8arimKiYMTEZFX7DmcYeyhtT0rzL9vTbibn-JBrRhtI-5wOW3lPgU>
X-ME-Proxy-Cause: dmFkZTFwiWz5xia+xtfntThlm+O9tjGeMfOg5p/zL8VYVtsXULwc8jTBr08jVHcQEsbhxK
    TMndqLDMMqjXpLlrcd2DNZw/axYZ8/70s9fvQ++ndGURDbYnj9+jE2pWTYgDyBIy7T7c+g
    1FLBAJg8ViAMIIR0WeG0kvIsAspTPwKIIiDbhgldWlfNpOyYl1MvyWfNinOTpMZ090jALU
    i/RcA+fWUVj+1PXpLp5EB/t8KfPsMi6C8/Rktwnc+ddxJOjK8acgquDVoYbmvcpcPF5ZbL
    fP/sPU/D8T1xJDgjYxA59CqeA0LY0DgbH9ErVKg6G21806a9Ona+7e7I9CP057PccJyjlb
    RJunY59V05jTYe7Q7N4LTguEDLhUxjZiw+9otdXTimDDyUnj/gBdnPlQgwkrbck+IfIPYW
    82hBftchyULhlpGWaSd1L2FLS0pGRNApT7nCyS5XHIeZ0QXGmAH7sRzsYz2X38IrI1Tkml
    qSo6jIEdsQYRTZnc0y2csIkaVRTjJEo0YqabWJqMGbr3SvFF2BsTqncd7voLfHu9wXlF1X
    FIX2YhqHwn8wvI7aJ4OvzR5Avh4OYZgSiqs8jHyLD4H6twj8GOLejLN13KV054UXgAZ7bi
    Ujr5U7D9yHzErSrTQhcNGLi/7VORFxIACHkANoSzwQlIiuc3HePCeVucyR1A
X-ME-Proxy: <xmx:87fPagbS0kPhq1sI-wjJ-ZzQuUj3075uzsEJv5b-zKhPbj4Ln13JFA>
    <xmx:87fPalqDvCcoOr1PXadOHyHc3n-fVyoocUucQmsZq1nYAabWWW_qMw>
    <xmx:87fPagZlZwnvJQNRGa7T6bY23o-6I_hJqINTFzAHo4wFcosHgUR7PA>
    <xmx:87fPag6H8IX72uOiUxu_mv2fQ3_6nt3X_HEwp0Oh06CSg9H8TfI1Vg>
    <xmx:9LfPajSswidL2XP8AWvl-aPQRT4koNflxR3nWaIze57AAdtLVwtIwDoa>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 13:12:19 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v5 8/9] mm/collapse: call collapse_file() from collapse_single_pmd()
Date: Wed, 14 Oct 2026 18:11:41 +0100
Message-ID: <20261014171145.3292736-9-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014171145.3292736-1-kas@kernel.org>
References: <20261014171145.3292736-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5142F18000A
X-Rspam-User: 
X-Stat-Signature: uc94x5m4dj5nt5qcr74kgzo5ux4fmfd1
X-HE-Tag: 1791997945-637949
X-HE-Meta: U2FsdGVkX1+sx7ODOud88uiuzIS/K85U0kTLMz1zrZcIsSCzIkFnmib1vmucVTJQy5e90CTdFPXXORLmQb8cPX1cDFacCEgKtIEAIZgytH5lby3DQT6LgEJPFpQnXPXG5QyAF6UmYtvr4frMuOaBCALJ6uC+Vdnh+YZqhUDNaXxfyinDxaEfJ2VtoXG5rHJWAcr8yoHLkFW665tigy7sNmEQsTJWq7EK0mjk035HbFsigY/0z5H/NDkeJd7rNwYH+l0e6pTzOzdD9MN6FoSBNO08W4ltNeN8UMD1cEN3MIH7o4z403Gl7RsjENGUZcgxF9oJwZQK69itzdLG08EpqYWLGdhNQldMS+NhaXc9uRSOwIRMpWzraQX6BHp/SoylPQn5Bf4mZdfwjq3PFyaLeBrU1wT5ByYyyWyRov2uwr4Em4KvHuuai7cVgqR4UiWRBSiI+zPD46nYH+NZOK7IZC5suHy6WQMhB6UTdkt2T1SOtvpjK6UpV/wzNOJXu+ULGzpf0iZAU01lE/AzHwWhSZ/xUgjrFUYZxPT1hzsp3Ukhje223Vp6QvT0VJERUs5tHE38ErLZlE19IwF2/uq9RRERI65pjy3tR273WdfCOHeUjdXjg5u4yI0WkB9peSfLz5I/xgtvlti/T8ngxJgE2lCJZZp0WOZcra1B8cVxGnpN3BDUFlj8Cp9YRs7RZig4xznrIrhGOLGlY2ux2Zpo0eqV1MC4At6ii6DKHGKpM9oaDAdjxZ+FLib4eSbVhM32XEW6KkkGip9EjL5/9ECALtRD4ry/JtEyZZQHIFE/17qBV9QoLS186JhzcfwMGqNgpLGu0+joO8klHiC98eXUqG1bOCXfuCE35GaiPofaFvnKeFS0Gskmf8LO1g5ld6Eus8E5LekptO31bns0Dy/Hsxr7JiBWdj8+onV+UtYn1XOSNsPOJXb5huIMvfMsIm8rMvusdV/znYDdc6DmO5x
 8M8wLsGo
 naX17wM/dqYp1nLvNsBCGyOML7B+iDDP4api6fB4SsZPcHFeNiVKG2kaNrI7rakK13Y04t2p/14CCedhCn4ZV14+dXeYN/of6dHv2Rzm6+3jwnRgvnm43G07Mo6PNn+xG9Fe74VSYkbWocbnQYRAUmf6gQGFqTGN4i50pzYybBw3+CV4Vel4ANQvA+BxOcymXMjnYjmoyTKxUZ3h+oOvxf0jLwFpRonIQLBlbvkE33QE9xEuN5td+3VgY+ugObPKa6nk9QGcJWVpJH/byRMBLNgem7Qt415bvjSYfDBPJxJ8ET5zqyoz3XdUdF4db70i8s1xY2g2fJD2GBQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_scan_file() reads the page cache to decide whether a table is
worth collapsing and, when it is, calls collapse_file() itself.  The
caller cannot get between the decision and the collapse.

Move the collapse_file() call up into collapse_single_pmd(), so the scan
stops at the decision.

Two things change with it.  The writeback retry re-runs collapse_file()
alone instead of rescanning first; collapse_file() repeats the scan's
checks under the page cache lock anyway.  And mm_khugepaged_scan_file
fires before the collapse, so for an accepted table its status reads
SCAN_SUCCEED; what the collapse made of the table is for
mm_khugepaged_collapse_file to report.

Preparation for splitting a collapse into a scan under mmap_lock and a
run without it.  The file scan has to stop where the anonymous one will.

Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 60ec7e80d554..89a4c3f5a91c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2737,13 +2737,9 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	else
 		cc->progress += HPAGE_PMD_NR;
 
-	if (result == SCAN_SUCCEED) {
-		if (present < HPAGE_PMD_NR - max_ptes_none) {
-			result = SCAN_EXCEED_NONE_PTE;
-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-		} else {
-			result = collapse_file(mm, addr, file, start, cc);
-		}
+	if (result == SCAN_SUCCEED && present < HPAGE_PMD_NR - max_ptes_none) {
+		result = SCAN_EXCEED_NONE_PTE;
+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 	}
 
 	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
@@ -2774,8 +2770,16 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 
 	mmap_read_unlock(mm);
 	*lock_dropped = true;
-retry:
+
+	/*
+	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
+	 * the PMD folio, and only the PTE table is left to retract.
+	 */
 	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+	if (result != SCAN_SUCCEED)
+		goto put;
+retry:
+	result = collapse_file(mm, addr, file, pgoff, cc);
 
 	/* Dirty pages are worth a writeback and one more try, if asked for */
 	if (cc->policy.file_writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
@@ -2787,6 +2791,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 		triggered_wb = true;
 		goto retry;
 	}
+put:
 	fput(file);
 
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
-- 
2.54.0


