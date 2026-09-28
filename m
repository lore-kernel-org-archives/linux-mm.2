Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0B0AC9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2326B009F; Mon, 28 Sep 2026 06:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099456B00A0; Mon, 28 Sep 2026 06:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA856B00A1; Mon, 28 Sep 2026 06:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B11A26B009F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29CC31A016A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:52 +0000 (UTC)
X-FDA: 85262742264.07.41C8184
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4F73F12000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="R YciL++";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=l6Fc4pwt;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790590010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PaQT7qTaOGvZkOpnI76MyqzTTpuh1i8/HxIO+fGPfo=;
	b=ILSPI2SAk2tszFymLCiwqiEuiDHxcVeMuHystoU0d2Yowo1OkwpnGdlVx4zk5vHYC0Guxy
	kJyK4TevLHur3yR620RaKDRtCA9n2eK01345edIxiVnd41LmUbsoGRniusR2mwrhfrLi2t
	LHBDJCJtJQ0zRluPcXe6UNdQ6wKP2u4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790590010;
	b=j3KJiCHjuKOT5fP/L59GoYmNpRP1u+Ogg6Li3wzJbQahOVdQULHsA5RbwKLJd6OYsj9wHn
	t7EorFqVNMp/LhET6FrTPApOn25gC8allnEmI4Gc59cN9p/MzOqI7kaGUN43zEsSOK3Ygg
	1NOg+viXO8l8RzJ1ZOh9+pPZxsHLzaQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="R YciL++";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=l6Fc4pwt;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D86FE14000D0;
	Mon, 28 Sep 2026 06:06:49 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 28 Sep 2026 06:06:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790590009; x=
	1790676409; bh=9PaQT7qTaOGvZkOpnI76MyqzTTpuh1i8/HxIO+fGPfo=; b=R
	YciL++XDUqVTAZ6TOwsr0KY0vEjR+UJnXzHC440gpqvPIKFM+sGID5F+otTHRnp8
	RmGOGuopKgcQYRjQkvR+04uF4CZb1wSJKUzBrYQa0g8O18oD5KRSaOAsl6xBQJwY
	RdPcMUSjYHY3PnoELOaasZPPA02ZdU0icBtIQKkILW3sfbxL8FRF2w9evWfI3iIW
	h0zQ/tP78ZfNQ6w9Lz3xfvrUEA7T9UnlHQTDIoalO4r5D+9DFABMzV8x5QqAIenN
	N2Y3XiGb7KgnqgpikxGfVA9JpKcZf5KtBq6nxdhNS/YuMJe8pCXSnBCEMoCOVoN4
	6NwnKf627FJ2QXs+bjP0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790590009; x=1790676409; bh=9
	PaQT7qTaOGvZkOpnI76MyqzTTpuh1i8/HxIO+fGPfo=; b=l6Fc4pwtHrHskpz1p
	DnZWg7cfnp4M+giIrESKSyU2WL2X91laMk1wu8yxfEKikFr5Drw2BNWP/qTEhETJ
	q9DIMicNDiJ4ip6+sjddQVXYyi/0xoVzPvB5cZJf19f0/TjRulpEtzq9J1deNQ/h
	pGP8fjtWYAr6tOLc6okYnTVpImdSVeW6JqoJigq+f/am2ZSkgZjdmRijQEL9Dc/3
	5ZBIko0ZT8sp3JWnx7PNWCOvq2bcpC8Bs8/AY9vw9dpWVXhO4O+Ih12ozXcL51Uf
	qMDonOh/qEWg7Iuw3akCOdj0BVAuo/rrL34QpP5M+hE25RlIkPRdW0SOdzMm7dBz
	qvUNQ==
X-ME-Sender: <xms:OTy6agn3Z8arhOlEmBe-X0m8YtV30oXSneneCvFfHE4l61re4XFqoQ>
    <xme:OTy6arwDx7VkxMvuZfmB-paHVdgYdJ34lwQY8zcJFxqg5J_l_spmmj9ZNoYkEFiFa
    4wAlEYiFH3C_BPB3dx-ypmv67lOBJlqRxkrhXMEOPVGpjGtn8o3J_g>
X-ME-Received: <xmr:OTy6akwbSW8LEq2KS23az2j9PSwBRPci-W-g7WmOAafrDRtdgu9VmQkuMwU>
X-ME-Proxy-Cause: dmFkZTG4PJbO3UAUv73kvgZEv1qLl5z3Oxsi3Ojn/Cc1gjyQPAY4pttCRQI27MH3dZhDE1
    QOPy+mv452PPCSDsPFoXsadZBBemUC7OEPjfBcMnl1HRY+YTKUqrnPjkqBcWGUry80H8PC
    /K6WQA/dTtmOEop/aiwEwk7y/N5mXgzmzQwcpgiHqOtfdhP6k3WxKdxsMyJsyB6Hvye7b7
    y8KqhRd53u+yghVVISP0UmiTClCERv2XAI4oMribMzYWNytre02a5omAhHuTKchvkb64ds
    QZyxNlGi6Daf2p9KIHOOPKsvpCSjo6Or9ZEQkSNGQE8W6NOQ2qvEeUYlVLLdnIfc4Nbbrx
    qa6eMGDCQsoULDqrTHT7PP8YjZPMt+Vo3DQ32XOFXFb0YpZfPoyitxknwsVy16MO/DCA3b
    Y72oaSlYevlgIO/FPuvj57Nr6uoYW4OANasY6P/iwD/NGMPe6ehDKNZbX8JR7xb1o0kaPb
    iuvql9OLGqTdQpWAch37J1iXE/NceJgb0h4NnEKVpDTSF8feeoGsWB6RzvjAvJiASkJiBh
    MuQ1R0F9hUnpFeXybgT3YKePLrIwo4THgsIyT8bwgvOtT7afk3HgN/9bkx27cWsQWqIo04
    dbqazUl/0S1K/A2F/AxcEcdVuE96oFfzxj50xcTUYY1ufni03uNZ/85SS0hQ
X-ME-Proxy: <xmx:OTy6ai_AXEVEX89-Wb5c7mKl6O9XePKlPt318d9dGmOqyZoLMZVB2w>
    <xmx:OTy6as_AO9fjvECMEpTC89rWZP9QWhGyWttEYwgLBA0iflWVbJ8GZg>
    <xmx:OTy6atetpzHkrNokP67v4Ga7PSUehbq1iYwAknbAQa3GdBjJtp-5oA>
    <xmx:OTy6agtOZ8m44HA2sOkitjXhM_m7a8Xufdxnali6TSfX8tXXtGTTPA>
    <xmx:OTy6alE09_rVSYimzoxAuap9i79t6vH2pHV58BeQTFNIkL4nHhP64ZBG>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:49 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
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
Subject: [PATCH v4 08/13] mm/collapse: call collapse_file() from collapse_single_pmd()
Date: Mon, 28 Sep 2026 11:06:22 +0100
Message-ID: <20260928100630.21870-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4F73F12000D
X-Stat-Signature: t6ipne1sm68sse3w1siukj7w1753aq6o
X-HE-Tag: 1790590010-71067
X-HE-Meta: U2FsdGVkX1+BZL1ByvQpWe3S7eYBefkF2XVoYfDkbsgYu3CNVp3ZWoXBLlSrPn3qW3LiRv/Yr/2Ss2JRTrYUdqR0dB6UZ1eZqETJmHZvM2XRZXfxtFJD4G3f1h9jG7eVi8ALTRW/yLXJVtvW3GNAQx61ACom+UjFnz8DzaNJl7ulq1o4kq+6jQ/Bb1VfqphX+f6i6E2ExTkL0HV2ki2HiaWmr+vHsDSDsvpmezOJenJ+ZxO4HZGFwHYUZ3zxbn6rRCGAtWNuNHWX+OVFp51jCmxKwm3WojZ1MEUJ1d2rPFRt2jpV4Ws4SEX0/Vby1fa6yejKOKXO6EgQM52WqcwsdNWlgyPR1W3U/d8oL/Dd7WRNo/s74i2puPbqCpzBMVvJRFqPurov6JfSq1Yc0jcAPQUdOHVHuY2ADNo/0cSt+JTOCD8ln0q0yw2JWnFmjo87ca00eXKHBnzIrgls/dFo4TAAtdchymRQ1vvayokXVoV8R5tK+kiO6BkWk2SNaNE7eThZVwMWoXYBC6gKa/ptJ75GP0VDI2g7Gqsg8XDOw91ye82zCN4AY4VqE6u05H91NbWXPFxEBzorrq/xd1FZhGKscyZmTnwewFVXPO/4Q8Qc8lQVkvbl9mPU8zlvVaEl4Nxy0dYNuPaDuLvdTps2Lod2z+MHQI1/XifyuSfaR2H0X0m1qWq265NxtAx4wvD1eGLYkj0peHvAxFAHwtlO2u7nPwXqyJfdjgK/w42lj+IlKbIxLITyy0+Wb/NPqGXD34QVAlQVedqudeE9/E22YXE40E3i885kR6w7R/WJVixkXXEDvsxCkeujnDrfPExMEn/WmXq9DTuq+j/kZVnXpIU26RE1CUndI/DKd2cKhuYfRxWTFIGqmaEUwCJbNZE7Zz6kVMsq68PsAkIbf6/yYVanYo8cRjL2e6NMgLu5vmkxcNYiXtJlKQbjLAgDa8K9Bwg5Oo50gbZCZAhgVw9
 /WLxGSQ9
 cJqKAU83sxyXuJkyEyrh45NtgmofqyPm/jAwBe2L5mg30AWip+4JsX+NCSU6Vc+unXFV29PP3t/nB5+5jQ70rtmzFfHeDkqNtIA6ijUbe/np1c/gB6i7HeOD0xXNteoXQa1a8ukYw5we61mnbs48+oNzKKoU359dvTTvU5bDO2M35GeP85yQGW3OY60kRlfzXjAcgwYlavE81Gp6vVXQLybzQJT955mZzIPNqIO1Ore9/Nz7lTNPk/Ajedw3yMj5SU4tNyBNflZQBGZeNcYnlUnQXE3i/Oh3POvkc7h4SYnPgkXtR2rjrtltjafMq7uN1bjwthZVJr7DLMtHWFV2FPa0lvbDHGQLQLqS/Ow5IYCTcSTL/sk2JwT9Sta1ZsSq5Fv8qRYVibiIHYcsDlG2vk/3sNXQlLt7Jma9eaFjKE74d8Djs7esB3/z7jbXUG1fUREnJWA+KC1yshBRqTjWsYKes2v2+e3OdIw2rqrsVlVOjpNPtO4o7nItLZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

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


