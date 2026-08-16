Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27DD8C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107AF6B0881; Sun, 16 Aug 2026 18:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0428D6B0883; Sun, 16 Aug 2026 18:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C926B0884; Sun, 16 Aug 2026 18:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC03B6B0881
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C9C5C011D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:12 +0000 (UTC)
X-FDA: 85108619904.11.5D655F0
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6CD7120002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="H W2cTKe";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=KiLMp3B4;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4QTeWOTpJRPuh3OfF+8CEm8xjikxAxj2x56bLCOOSc=;
	b=mz9TOG+nI5AjqluFzrzoVKFB4wV4FK9d5ZuwVlWFE8BBq3B01avpGqL1zwU56l+X7uMjlX
	+1cFic9BjQ+MiWvEXlLwrA5x0tcDkq8E6Plmd+JxYP/T3X3gdk+9vKcSzQH7n7yejnaWkY
	RaVaNxcRAvl0634alIhIy1MSvcoz3bE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="H W2cTKe";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=KiLMp3B4;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920430;
	b=O1yN9FlPKB7Bo7D3yc1JJUc9In9iv5lANhwGoZG0xVDJPWMciTttH/37f0b/h7hZzO0bV/
	iRIm8I/jElWEU9cEpCuny9JbTVjQt3KnYOD9wV9f57jrFSePe6sZGYZeaChFmNXsaxGDh6
	STsOjxIDqrHI7wShDXJ7IHGqPWGxSQ0=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id F3212EC0243;
	Sun, 16 Aug 2026 18:47:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920429; x=
	1787006829; bh=I4QTeWOTpJRPuh3OfF+8CEm8xjikxAxj2x56bLCOOSc=; b=H
	W2cTKeViOUFKg4ugUwcqSC2lzWJ2gzQ7Bl336yHE4NmnTD/qYiXZJsS56PyF3jb2
	vRin2AVLS4DXRf50KFmmsvo15XzGj6ZIFMCxW03WGSC/kro0ZFT6IFJAUlgtHdNy
	hM/fH6yJL6al46oPTa5NXWEtpQQTLqS3moEhY/crVlL3JyNJwfEHpbz1j3kZcrcx
	uc+i42paLfUjk4TVxpShCfb002SV7PIr7Vvvl/K8Df/Kx3R1Y8cK4Yr/qvdTv+UA
	VQt7mxI61MBPkXm1Y6/DEljs8O5n3aFOsNl2ZUr5vl8HIK07YW3x6Q/GFZBU2fur
	VXUI0Zr3/GosIsshFIHOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920429; x=1787006829; bh=I
	4QTeWOTpJRPuh3OfF+8CEm8xjikxAxj2x56bLCOOSc=; b=KiLMp3B4ag400yZym
	+u+s/kP8DjoiV1jGTUTQh2HrwXArbn4BZkhHRadCrK83d4yfJSLprdZxmKYcteHO
	2fer5H+sy+0buosPR8Jmq/oOFdb9PocomY1Io8K3Mo6iOEq6505wWMSEt/j0uJsS
	5hMv4hnkWSAXWQURzSUF6TqqU4MjMv2KmIg/QpYD/78uBX3THZSuZWfcbQGr70Ab
	EcPfrHqlhhLAdYfwzS3Apkpxct6mHHw7ChfflvQq1hghT4TjW3dKGq9D/dK1EvPJ
	zy8Uv+0mt+J8Ooliq/iNd8BAPNecVWh3XL3zw0M8TFt/CZWDZmMnVXBdtRwKT5CS
	lSIcg==
X-ME-Sender: <xms:7T2CaitN-YTQ2oxKfQAXKd9RWsPSMTeRjEMTkFIjyUirfvcgQ6viDg>
    <xme:7T2CahB17GMwG6FGD2lL-yU19_a5ttzJSzw9N_ET_U-HIz2EK6L3ye6HNIYyu4Rnb
    Wq4ggFRnLrlwTGPWQg9Gyf6cWkIZSKF0MRDiBrJLhaOF38XwO7sv9vu>
X-ME-Received: <xmr:7T2CapMaJ6U3ivIVd-QKdUewcUkIE1yzqg9h3tAxDKd9V2VTtuLnGKnTs28>
X-ME-Proxy-Cause: dmFkZTGlsoL4dlGZVhjNGnyng7DWLkzd23+vL0S14uJaq1tszuZ6c/qXpcKjIN3SVavrqW
    anksLy7isjEKJzVCE9/It/QcezLPAumFeVWWYf/196d5DKxXijJBwwHlwdbhLN8+Q20ZSw
    VAcGFAGUZDfCfgJltT5NnBIG4Gh7JxdfG7re68r55pgQSoCRLBnoP1i35vKgO+O/kd9+lz
    qLG43ny3AnvUx0aE1SnxP3FJCiuv2lDE4FRTwfST8/uDABclrMy6sZKUEjfd1WPzb5NlOP
    S5qghqIOcnVKJHuC+GM/K5ckB8SXpR6Ag+KqE5QSQT/v+DpSzaOOJbUo2XdsQxu9tqIPVC
    wtH8RrR+VRBK4rHQP5fUOUd9SDmtkxSJIuqK6X0YhrZ10zdW4WgrIMWQcAlMOIw07y45IF
    iUQPQjmY18mZD+KeADQUCZgbhRiYVOnmw5psrOcS2zb3A7Ve3TEpym00DdUWWBFRygip4Q
    Fn+i65Iy6aPDTmuKBbeNhatneA0MOXpV6XTo/iFtVU6PszWR/4qIwju3GvgPVWhmGwEaF8
    lOhqjwLWDDCkWCXUSIksZsiHNeLhW050yblRbXZhW9L1t9tojDhndbGZqh5BRIbDI62sIJ
    2pCa7pAkdvTJlFFSD2rj0hqoXUfSk4uHGCJ+7xklr79KCQBj6ko9GT3+9ngA
X-ME-Proxy: <xmx:7T2Car6ja2x14aOjb-XHTccESUVK3zzz3OlefJJuHHfOiTZuhw3NSA>
    <xmx:7T2Caj2KGqYDygko7lCUqLIWmvZFcFnvEYQvh3pneyQVUUnSeWx73A>
    <xmx:7T2Caqr-g0RdIP-pIfCMvJa223e-pezovUUZT4A6ObM08ANLGZ3Pzg>
    <xmx:7T2Caq_OsZBJl_h9di85Sw4Xk_ocFgBnlDH_aOV2I-81IjMHPW3n_g>
    <xmx:7T2Cai4cfrWa81ngUM3QzKGR4bHDyQQNX_qU-fp-iToXl_FYtO_EX8CG>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:09 -0400 (EDT)
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
Subject: [RFC PATCH 27/57] mm/collapse: scan the windows a VMA can hold
Date: Sun, 16 Aug 2026 23:45:39 +0100
Message-ID: <20260816224609.308019-28-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6CD7120002
X-Stat-Signature: x6id9r8br6cxo55jptqxifu839qfo93d
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786920430-741291
X-HE-Meta: U2FsdGVkX19qfEQoYOnkFjir3rJ8Sl9Cqw8sTtzqM07wsukfZnSqObjDZmetgiK/2Ti6m489/wNvnNEUMWqbEPg/sNYI6+JoGhvSyLJqKy0IqssQVHNTRha8lhwNO9iqEdbHNsRhpCWqRS3eyzZPYN2Y12jpqKekXkHDjmA/nYlxu7eyj6j3ssOWWcTrHKYUjNsRvTzWgxwYOzz7wGrd3NC7S0jrMQUlJcq3no3Y7EW8mKeT1hxtq9IMx0EdmjKupFshFQfoPq1PzrKyoaNPDGH+BVvuAt7MDQz/hYOa54GLlo5b6DdvmNyyumRMxverbKVUj5gPx7a/740qc19/8YF2DFR3dS6bHWZuQyXyxP6E442tzrUQXfKouS44UDA4S1RZ1RUvDOqfMbelpejatBmvf1AI3u6j0jfGXfPCggBoKmc1zfSyz2aAD1gqEXwozNNbQTuvsXQLInD3sDCWXlO0F6CAx60KpDXmqdnwbHzolxSuujkDM/zTfjaETy7cyCGf3HGXe3a+bEjGZVcLa+3s+8nxDKCd8QA5DIusV4yOlk6qLCMctSovqGd5nugI2MS/kLFbkX0ArnYvxGfnLTYAlWJztIOQ64UOSUfvPIu693LEWWFyqnYM4BDZKP7QndMHVJzgugMlybUL5MPd6IzHxxFnHkeOr2eTKcG0qBJNdnigrUzCBEKFSI874jWbA9lC7tvNroSZxuAxX9WECJVKKrQu/htGNSl/h6rGyY7VJ7Rm1YB9OuoqiC/KxNhxWKYK8SOzYDEmrbzAep/PrNe9SHRsIGSXehQtsdwtO/pcl0o9nBlY3hMKzeixQJj8+FV5T4iqyu1CXX/aAuQ8Ct3bqh5istq7rD+C+H1xLXM+9CM1yy+FmtxKFj0b93CvB9eUcanDMQlbI5WIwggiLAqVnPNZmJYxYb7+SmkzbSy6mnkKhEL2aYAkl4vdweI9jdh4eh1uHtdrFqBqvUe
 QjMINpMX
 Rd0+W/JKtwyzE8nwaYDJabDmF/1OaaYxoSv+SbYc9TlQGWGr1Ml6r/x6OX9d2GJ4OkDHfoSY3GQB+E6j4P03azzgOQbtwErKndzCnreuNCNKIJg+B+PCpRmMP6mt3ek14rBiRvw/8buuUJoc0ajYMP09JBUWdIkcKefI9EknZGtPZKua0mru4xiVITN8lmm5Hl/KGEuIeLCVr2QmwGcXlF3BCaODIWC3iEnq8rISO1vIBXChKiAeeHsOodtabKzqqeHh47FxtUrGLWw0pfrt46OlLfbvL/xNLcsEiWBosMX9f1uNw7tsHJjTJ9gfkukTVIj8YOHyrHsEXYbZLlVQM8b71369SmIrO+xseepRoAcAAtuEGHsTrxpUPPcEYECLYqC25VmZXanr/Dl62oQO1H0x6fkAKlRJiipOD6fnYm4O2gr/2G8B2wKEnkX5JeA1eEDO44qvvWXK4E5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

khugepaged covers each VMA in whole PTE tables, from its first PMD-aligned
address to its last.  A VMA smaller than a table is never scanned at all,
and in a larger one everything outside its PMD-aligned span is skipped.

That was the right shape when a collapse was always a PMD.  It keeps mTHP
collapse away from every range that is not PMD-shaped, which is most of
what an mTHP is for.

The gap is widest where a PMD is largest.  On arm64 with 64K base pages a
PMD is 512M, so the old walk reached only VMAs big enough and aligned well
enough to hold one.  A 2M mTHP -- order 5 there -- was unreachable in
anything smaller, however many such windows the VMA had room for.

Root the coverage at windows of the largest order the VMA allows, and hand
the range on one table at a time, clamped to the VMA.  The engine already
accepts a partial table; this is the first caller that gives it one.

The cursor is no longer PMD-aligned, so the assert that said it was goes.
The bound beside it goes too: the range is clamped to the VMA where it is
computed, leaving nothing for it to catch.

For a VMA whose largest allowed order is the PMD order -- every file VMA,
and any anonymous VMA with only PMD-order THP enabled -- the walk is
exactly what it was.  Where smaller orders are enabled, khugepaged now
reaches VMAs a table would not fit in, and the edges of VMAs it used to
leave out.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d1e031ed3e6f..895183d92fb8 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2838,44 +2838,56 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
 	for_each_vma(vmi, vma) {
-		unsigned long hstart, hend;
+		unsigned long hstart, hend, window;
+		unsigned long orders;
 
 		cond_resched();
 		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+		orders = collapse_possible_orders(vma, vma->vm_flags,
+						  TVA_KHUGEPAGED);
+		if (!orders) {
 			cc->progress++;
 			continue;
 		}
-		hstart = ALIGN(vma->vm_start, HPAGE_PMD_SIZE);
-		hend = ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE);
+
+		/*
+		 * Coverage is rooted at windows of the largest order the VMA
+		 * allows: below the PMD order that reaches VMAs a whole table
+		 * would not fit in, and parts of a VMA that a whole table would
+		 * leave out.
+		 */
+		window = PAGE_SIZE << __fls(orders);
+		hstart = ALIGN(vma->vm_start, window);
+		hend = ALIGN_DOWN(vma->vm_end, window);
 		if (khugepaged_scan.address > hend) {
 			cc->progress++;
 			continue;
 		}
 		if (khugepaged_scan.address < hstart)
 			khugepaged_scan.address = hstart;
-		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
 
 		while (khugepaged_scan.address < hend) {
+			unsigned long pmd_addr, range_end;
 			bool lock_dropped = false;
 
+			/* One table's worth at most, and never past the VMA */
+			pmd_addr = khugepaged_scan.address & HPAGE_PMD_MASK;
+			range_end = min(hend, pmd_addr + HPAGE_PMD_SIZE);
+
 			cond_resched();
 			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
-			VM_WARN_ON_ONCE(khugepaged_scan.address < hstart ||
-				  khugepaged_scan.address + HPAGE_PMD_SIZE >
-				  hend);
+			VM_WARN_ON_ONCE(khugepaged_scan.address < hstart);
 
 			*result = collapse_single_pmd(khugepaged_scan.address,
-						      khugepaged_scan.address +
-						      HPAGE_PMD_SIZE,
-						      vma, &lock_dropped, cc);
+						      range_end, vma,
+						      &lock_dropped, cc);
 			/* move to next address */
-			khugepaged_scan.address += HPAGE_PMD_SIZE;
+			khugepaged_scan.address = range_end;
 			if (lock_dropped)
 				/*
 				 * We released mmap_lock so break loop.  Note
-- 
2.54.0


