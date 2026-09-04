Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26799C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7EE96B009D; Fri,  4 Sep 2026 11:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F5E6B009E; Fri,  4 Sep 2026 11:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0EB6B009F; Fri,  4 Sep 2026 11:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 843906B009D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:10:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0503CC0117
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:43 +0000 (UTC)
X-FDA: 85176416808.19.2EE320E
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf11.hostedemail.com (Postfix) with ESMTP id 10C2040011
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="X waYnG5";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=DX+ujuqC;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csaSFAKtS72MfKNk/auWa3JqV7XZUOIFQz4rsLI1NhI=;
	b=EbNN49oJJ0ddENg84lsfdsfKiUjppm+Swet5zJvniIIPYl9aVFeFo6pBVL4Xh0bdgaOE7C
	EnJBUCviUjazHLmj/aMwQO7+FgcyAL9i3uimhil2yV5t+KdkEZiOQGNaJdX8MLcU4e8acz
	1pEQennBkaGZnFxUUTzL/2njWwjDLSk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788534642;
	b=18n3zJFAv18vnzmoCh2XUK1mDnNfQb9Z8Y01w6oT2fye5gtup7HqnHT48DAXeC+SUC6qQ1
	PEEQxhlPS5vSjGm53YuoTFMsHCU7Tj13shImph9nb13sO0/Y8ky6uAbF5GPegR3SKxL19b
	IFck8xEYZ00vHbE7h2aK5FvHgveOjn8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="X waYnG5";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=DX+ujuqC;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8DED61400106;
	Fri,  4 Sep 2026 11:10:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 04 Sep 2026 11:10:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788534641; x=
	1788621041; bh=csaSFAKtS72MfKNk/auWa3JqV7XZUOIFQz4rsLI1NhI=; b=X
	waYnG5j1sSW2fwEzdyndDYCRRtS4ErnAiqu+9/6bftCwiKT6VUiCZJ1AdCV6cZqv
	FpAdvxcgEnOXmuigqNFSCvGhGxnk/WJ71//t2I+jw2Lhm1v1zQ4PwefHaKZhpFEv
	5365GptykMY+ws5agze1/r5HJmw1RPftgMBbJ9GMI3NjjAMwP6eWjb+pmxmBn6OZ
	36BqbGhu/f9ifoK0sU33hHsGlm7Wu1UksKLt8r2dU6MH++9hin4zN33/zIt4i8T7
	NsNds6UrQF+LxguJcPRqdTzvAkHf5somE3LPmdV6XtqMzxuzxTgkBj44etoqjE/b
	ocYQFy0RPos87gZANUWuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788534641; x=1788621041; bh=c
	saSFAKtS72MfKNk/auWa3JqV7XZUOIFQz4rsLI1NhI=; b=DX+ujuqCNxKmXGTWG
	rrJ0ev8RZB/VwCcBAgnB2OSN1Yzjzjw9iUp3LJodqP5FJ+7fkh6eUGtyajP1x45N
	AxBEpGkwhHGRjREV99cTB3wFwcJesYGu/PtcX92vlNPK4EjweIjL94lULMS4v3FQ
	X8Shq0T2jhRnEVNwaDR+8Ri+wNkPhoUOuEnvdhDSNc6Ze0ioUA99is0TjyqknHgE
	KIvMor/UZdd5BZdQhVjyvAX5rxBl6VVz4F3W3qC2BKH1PvpbdvRNFsmtJPd6lrwd
	q7tkhc6FOTE+eNHv5cck+e6xMnNpnNXP0oGmngJmatSdSnZXhzYDO4pKfiAexanA
	msRWg==
X-ME-Sender: <xms:cd-aauSu_FVyReBtVERC8V_XlC6GKDcSMxwoo06h3TQfJuhDbMTQPQ>
    <xme:cd-aavsNLN1DtOpjRAohmNQ0wPpAweCEvJHkz72rSezX-rLlGrpxY4Io5W7o2aPUM
    YBFuIYCgD5jZ1C9E3vPLef0xcrC-QrDRKeyNoh4VVquZkAIgT_ZaA1->
X-ME-Received: <xmr:cd-aah8SlxC0IuLw_E5Dv6SImVfsRQtrrRK5AoQfDdlMnlz3_LsFiv2lXWs>
X-ME-Proxy-Cause: dmFkZTFdOocfRN4jOpcQf0AqfSai/YCGo+xlO94MLvzn7lqitof50EENUNEgJzLPt2H+RQ
    DWgrwJL5dg2BaLkWQfjz0w8mX09EzID7A24sM1R0CcrzJ0aCsxP+pgO1accdG5RnvXKoNP
    Qi2+ranCgsFBQlrx3RUM64Xgm9l9zr2TPWbzFNtan3mUwkVlJ/gBEGXolzLuuMZ3CJ6e8L
    gmzum6oDDF3av5ecJE/wINba64+XlYa/U9oL8c0Dkr16eu3wp8w8wOsHTRTsCgO4oV0meO
    0fb7rtZliPO8XPlA3k/rGcTv+01JWMnSe6fG3OACTE4UctUjoP9cM2YnBbUckeF0hhckLt
    MMHeYhNDUPl4H+anSl0bx4O31nPweggRutuPuOSD3x0SBk0h7PGsgbLKNhVs6w0dYfOFiK
    uYRiJbsY1zG3wyIMbFQDDpgC56vqbkfDVNXSp3AcIV3y1+SR/EVO5E6n2mSmw5kgS1Faln
    KMe0a7IYL3FakTwavg3ixHmnnqMW/ll9wuw4GLGJgwQiA3X9obmCgwVf36wlnRxDap0Eki
    tDwPFPWlgUMJdvEnd+0mPBdshgAAjvK8sQxd7Y9dei+aygeLU8zgYgO4eYrnVK3AQ+JjML
    OjzR8R+srhjyw4VZMOJryhJc0YwyTEIK8RraXetOdXVeQhlZwH0f/tNpkNow
X-ME-Proxy: <xmx:cd-aagZq1IPMtXg0W2mk07KCR3zFtIaVJh4epJW78UATn2MzeapKcw>
    <xmx:cd-aalo7-vb1_gFqoZUKENxQ_v0ExsXdNpX2rTtZ87XoqN3FMfNIxg>
    <xmx:cd-aaga9_lmsJFU-iHImfckSAvrd03PjXsLKWURmzVRAOrUaw6bDYw>
    <xmx:cd-aag7_cO94Bxy2X7d59MVFZOZ2Ua_RFky1WoUN0V3N9L08VBL7Sg>
    <xmx:cd-aakXM3ypMzNY7-Kd_TLFjhIXlTod_DvpT1af_9k2AWH9cqsqfPeqy>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Sep 2026 11:10:40 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 06/12] mm/collapse: drop the collapse_possible() wrapper
Date: Fri,  4 Sep 2026 16:10:20 +0100
Message-ID: <e6780351a3a29fc1a9efb7d2fb2ef6d1466a50dd.1788533997.git.kas@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788533997.git.kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10C2040011
X-Stat-Signature: 576t7izfoooxdk898uytqt4jj68ggmc5
X-HE-Tag: 1788534641-764824
X-HE-Meta: U2FsdGVkX18ajd5wQc4GnZeKYjF9C/ljRhdnXIUv2Gj9t7i7itU1pf+iJbnvt6VXzFwr3a5+XYa7MRJz88Ma6eoLUO9QR//VfPWcBp4aVRvNxcDTeF9h4JBL++g6A77IOMsAwauz5noh1MAV3HF7KLMEpa0H4jkk8bqDz+fjH9shMHl6wU9BGC08GKCt/YfWc2gey9izQiDcvp/3YnAl4gwmpcxfbcFc784QCOuRTKSngRg/gHjT/0kMLFHfXpxKVh7Rp3Y6Ntm9ZAdSeSueHojPqzYUDE8L1d0QJLR53xFzhLIgp9yVPh5BG1HlRXwY1Syu2EtR6SD48mDrruWi4Of/fJvGBOEAvTNtMsUBAu6m2ZCbofAeCas/gP0Uyji037ts0ExdxtXEivR7GiaBICAf5MNL4Zhy28Jlken15mLJHNBS5X/RmCne1PyTcZF1H2X68h0nqqtznS0MYX9y0tCvUBSgaLx3tRhkZqekhiQxxQ8bgHYznk9sg5G+Fpo8bpUVpmez2fPNHBB3BcrPh32wNUIXMIAl9/gGTwvf1B7YgeN35LGZ2ysPP3ppdlmQCn2RdNZPVVFO76jDMB946gz3iuqMVttCsCpgK8OsIE54G1yELzMe9etNCGFG+HSl+Yb4HDQ5ZUNuSmua2vQvjGOfr/i7wLDpgS1gd0SpNuzqkveGG3IsbAwFzBJUojxP+vVasoT6DhY6fkBTeD2LM0jR3aN0bkU1OYCTJqJiMWvUO8J58+UaUC0lxjWFCSkeIUIOYFyBx+nQlHHG2t7OOUMTi8SDWxNlmFaXF2M+STYpD6Dy4qXVTAn5TWDC/8S+Y86ErRc6wwW04TmyTgTF7xsxDWGAXMTAh1mnwSONXupcaOEG//zcwbh1bI1hkxQ8JkEu6q/bHWVIYMnYH2NP4oMzViZU7G/OQnx4CC4AQ3WEB2dEMCAfvKWTcwgutPCvBX83R8/dpd62CGL0RKc
 VvrrFgJ/
 ye7N6uWg40vQcyM6db28w5B2ax6V/0wz6g2LO2mdv4PdxP4O+KAgUcZdED30VWQCY42Zo8NH4jcUsV+LlzdHsDXNBvSWUHyJa4YOsBd3/IaojRL3X5cxJepY3y+BFSnEtGtxDp54Dn6x8VFD7NNZ/NRH5dq9YOD7CMF6qvZ05p0WouHsC7D77G/U/GiuIGaztEVqemWgXFNfMfGnWsmcem3ozEdCRLVVDbR/lvzzqM3S58XX4ge8LlCn2wPKx1IcD5oXpgCpzCIUjQYCpw2PYz0bFNCJAP42buMvVKkZ1uzRswEY4gyHc6wskzC/MA6JMBoTWiTZwNsm4g4y43il11rjvl6uFUHcn2+m0trJO0ssI00hWrJIQxU7z6jBnt7ST3ifjbloOtcJXVuKNhGLkQGV6IdfmDmwdkz622bB8fXSczr7mEYNYncYcaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_possible() only forwards to collapse_possible_orders() and turns
its mask into a bool.  Its three callers can test the mask themselves.

No functional change.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b2ebacfcc0be..22272cfe97e6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -512,17 +512,11 @@ static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
-static bool collapse_possible(struct vm_area_struct *vma,
-		vm_flags_t vm_flags, enum tva_type tva_flags)
-{
-	return collapse_possible_orders(vma, vm_flags, tva_flags);
-}
-
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
-	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled()
-	    && collapse_possible(vma, vm_flags, TVA_KHUGEPAGED))
+	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled() &&
+	    collapse_possible_orders(vma, vm_flags, TVA_KHUGEPAGED))
 		__khugepaged_enter(vma->vm_mm);
 }
 
@@ -2864,7 +2858,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+		if (!collapse_possible_orders(vma, vma->vm_flags,
+					      TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -3177,7 +3172,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
+	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	hstart = ALIGN(start, HPAGE_PMD_SIZE);
-- 
2.54.0


