Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D041EC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C286B0093; Mon, 28 Sep 2026 06:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023D56B0095; Mon, 28 Sep 2026 06:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E0E6B0096; Mon, 28 Sep 2026 06:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9227D6B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A922D120164
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:40 +0000 (UTC)
X-FDA: 85262741760.19.FF51965
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf26.hostedemail.com (Postfix) with ESMTP id B66F9140002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="e Ifj1EE";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=FX2uFex6;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790589998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFcgFP6X9Bowp3MiNUNc4KNfT83IPzT+sj2xQ4bfpio=;
	b=QBUIH3t+2fChRTd4XhqvCW1kXcvcKQyw/fGuuVbCv2g72A/epQ9lzpOQw+uAoJ3rZ4ChsY
	CrFZKHTyR2C9d7f6Izw35OomY8r3GaEHVi+JPbLoePDpcrQ7/PMae1Bz+eq3L8qmEMCWXd
	+ZMutBIJ1wXY+pHVRKTP6P9TcT0pQEA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790589998;
	b=TQgdI+71j7GPSJ9bZfwnwG2yUS7gcXjYmqvOwxOkBkmJ+vfan0XWkSM/plGXTdN9xQbxnk
	xiIcy4fIXDLvWrbzrrh1S/QZ+KTTw4YiMdrbt2LVlm/tNkGaEI8/DThcjfBqj2z6DFjG/t
	ZiUjItDz2KNSbAwqRfrxdVkcsM66KOQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="e Ifj1EE";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=FX2uFex6;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3A02214000D7;
	Mon, 28 Sep 2026 06:06:38 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 28 Sep 2026 06:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790589998; x=
	1790676398; bh=SFcgFP6X9Bowp3MiNUNc4KNfT83IPzT+sj2xQ4bfpio=; b=e
	Ifj1EE26xJ+1Xkyt3thiOcfnSrjZZK8f5/2hknmmweH+hV/fl42jMJT1G4i/NaQs
	RkqVhR+sGXfOlhoDX8/YJlXdXZlo0l43wk5YryBpPrL1cK04mfYTYuU1s+7tUXN8
	V8t4cXhwneajfU5ye1GfpPzH+ULh3XAwUS8rEG5mRpLxdTHjzZWkQR9Rv6PhYLAa
	0xv0GjxjyEhW9wgXxttMDECdJRILXSNONBP4Hzj5QKG70lqowpwio39wnR6m8I0a
	8UJlmezLWLVcLIi2ZvbAq1sAqEaK3F62L8/Occ/u8GEp/bSNu3xsckgy1BmlGlFN
	g/8kT4dsbYmkAlG0nLtuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790589998; x=1790676398; bh=S
	FcgFP6X9Bowp3MiNUNc4KNfT83IPzT+sj2xQ4bfpio=; b=FX2uFex6PcbUMdT7B
	NhnVgIlcbDDKupjahE3eghemK3uZGdSXP7OYbYvH7A/c4clpWD7dceNSebtpS5ht
	AMENMzAb/shItcBVe/ga4/GShu6ef4eguSb7RsVqmviiRFUBzw+4X5kVMNwXTSVc
	swAwRyURrmcrOIy4B1mRU/viYp9H7kUWFIil5xpjMLAJouT2fom6GNGcknCXejPw
	bgLiQO535uxFpMIDyt108m9B0xqKYG+g71G5xPhLK6fDWTXsjo6JpzrT/AO8JO1D
	wS7ZdywTmYP0kyT13/yuEwPBVbUfmYGkwrItJfzVZ1qtt1LZJpIU2HC09HjPDWQ7
	kR1QA==
X-ME-Sender: <xms:Ljy6au1GJl6Z2lHxkqu_0g5yWx4qNw_ng7Y3xmuDlPBfIKIJ8e9f8w>
    <xme:Ljy6atDfxatNvCPBTwWUEPMRBTWFjwA-nDyC0I1kH9TWtGuiDS6TgH4cxLztDMdqA
    V68bBA00-1mAYK3kjaNGbnf3dfsKmxDP1i9g9XfmT5pz26tiNe88Bs>
X-ME-Received: <xmr:Ljy6atDH9mBKOl035VkHBkOlEbuVu1R-oBgFnW_mLN4h8zr1XiSU65oSFZY>
X-ME-Proxy-Cause: dmFkZTF8+FzWl2kPFFw+2+MUnNndpG3Es29zlM3W8MqBD0QW9993JqL27RjsdWHL5iQTuv
    8LHkef+10EFcRNyu6aMfBJblGtUMhigK1wvWUg5pa/T2F4HZOycwBRl+2S+z7tqw2cJfHU
    gdsF/P6BOMqpKS9LZRm0d8oBtyKEEqCXwj8zji6pXjSixGW9yMDmevXCSXRhMug+RBOuj6
    H/TPGEbj0UBxBpkklI8Q2dk1KPN1FfxQ05T6kAzB+fcPQyWzSSafNh6004OlOqdREfhbRG
    BHI+j7BDMASDclZuapGmxVrXolh8JlQnm8Hn+THchpsYHB/1yAmWKg/yew9Ltzw86nEqq8
    bKqUp8rATYVqUxwOYXBNR4CEdpEbrfQOYE8EwOaHhGp7YREpWnoaBA8ADGJ8u+aBo4/oJb
    pYWh3128Y249eByWZEu53WcW7ixM7wfQMglI6GR2s+KUExcTGzBiWTpGcG2lFDLMZ8Xsju
    o0f4vqrm8zA3Bm8+rrSDrR/E+EpCeRM4NfSakgxM/M8CRmvWOaEJ/DhAEY9QBGzaumAqoN
    OD3MK9D94t5dhMQHDo0E6DTgWmoMcY3wvM10Zd1NOhX3xhLSKX9SXzSUIpn1itlA4R7zFx
    xUQrEloP/qeTmILi4+b1YjK8Ula9PEPVy7nz8iI3JEdja6yyJWU5ySKa502g
X-ME-Proxy: <xmx:Ljy6amPM_bYsm2VpJ1A0_48NL4z4JCPlAjmi_eRu_BwLlQ-oZ3Hsxg>
    <xmx:Ljy6avOqtEE1yD5HJL-5lVLGMyUld6xHBSwUMxX6lkISEOAU05kTUg>
    <xmx:Ljy6aiu3rzojY025sMXoD_4etdmDenqo2ieu7uxyiYakcV7kxnTasg>
    <xmx:Ljy6as--pEvoAR2DLTr_nT7XSOixEVkCD36XZw2bHUNgiqFWmmPEyA>
    <xmx:Ljy6apUlb3mAj2z7R-mfPQ8gExVBjSL7PwOTQ844Hl97oL6_jhcg83Dm>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:37 -0400 (EDT)
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
Subject: [PATCH v4 02/13] mm/khugepaged: count collapses where khugepaged makes them
Date: Mon, 28 Sep 2026 11:06:16 +0100
Message-ID: <20260928100630.21870-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xcz765agqzbh31tfkqhjsqymqacwgykr
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B66F9140002
X-HE-Tag: 1790589998-285897
X-HE-Meta: U2FsdGVkX1/kA1kyPHeCmqU48YM0iY5DVmNTrWGb+GWyKG1Ha8l3CVW9PF7c6Meu8yySh1g3DgGnwWOwZc3mEW1DEw0BZ6LDFoFb2PIZBdwF57g6ZjWrGR/JsuRB6mt1x9lQGFnA1Qubnx1QfgTSyv3w0acQ63/1HV3HggGylociHP1LcuMgvR47p93HzkitLASbPYNHFXEgpbcf64TMDZOCaZ6Hn+XfOhK+XS8/3/GtMkDntfoTDUBEqf2MSMG1V6UNsJ2+/6H8VjwS3Xd01LLQZIcq0hltR3Q2RLQhytYHd5cEhbh4qgr5M6nBCZzGESxaL/27LS6B4ChvIGjWOkN2st9mffJ5TNpcesvssE7GDzgWk7HEdg1itCmlx110bRvbtsaUOSdkTXC+T/UGsl+bpCxEo2AYXlQlQuQgWgxMWy/ckVV31nQyDDZ/ngyukSUD8JGuKhwIyEPFYJqNlOkrsLi0Fy6ST80GwkXuEL5KkYgmvdatCQueVT83iCZ3Xk197/o/P+5cUKy4GphzobpXVGI1OWk7L3VTUK6BPNRjtXsgwvsErTbYmL88bleX1549MKO3lZAolr1ZN2u8qCC119FC1QAqkcz4q5P81BRLVAORFPOEVkQwFoSatgbXQGhITXhYjGht3/va+h+ZYxgs+56mvxx4TZ72OeUd8zBgsw/OuxBINIjrGyad5NuM4/r9HE/B9G7LrBLivlIo4GDqEpfwHKDgH5HUagcWrabd1oDFjfb40LBAiYXJXBjMd7L1arZKRMyG9v6CeKlKKeqvggQa+N6IcZc8H7iAk5FmrYOHEYPO/Lfv/NKpt0xlQz+Khn8COkP38en9nio/c94C6yx8ltPEgxb3x0oFDfgCOTmPwIXFZuTt8PVEoCEB9DBpDqTUshyLJCWlroS2g510HuD/prGCxJEaDO8Ajw2Qez+JzOwRbWF9KGqC6+XikInOSbmdY9Mzy0KLtJg
 5D6SMlyq
 SXZkdRK7mcXRDw52G3rgNMfK37xrcZus27i71AxnXta5jeTSEx5BZ8RQhd3UtHKP1Y3O9gDMzWwFdRK6+wqbx7gcRZiJgGrJ42MPOrD/cMV7YXe+qKMlT5FAdL4RIknXowqwYEGRKj7ZjkooM93kKesTX20WLN3zKQmkEastWNquyw7hz/dr5u94itdEhMlSevpXesWgK/wxD71Li5vFm2oEUZC4QFn0pSlC1IoSxkfOfhBxuD+5pKTvRlrVZKfTA9OdbZmH/6GY4mmNL4fk6EpjRDbaIVSYkxlVisvX9Ry3Tbx2H+ljvWSF1U05vGAoI00gLHjSd8hl2F9xmReww1RJi4f1VH60oSpm7j/Sivo7JWrZk3v1wpsqdKfRWsmEqMteM7UbUGS6plaIO6R20GiHPNYkZraqBdtm61AsqJDT9dQhN6aOmnYddUH0YtIkkgxTf7T0jmy2h8C7kbQp1bx2QGBjTw2XRCZ9VCLu4WEDX8hSvRKDf1ohIVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
tests cc->is_khugepaged to know whether it should: the counter belongs to
the daemon, and MADV_COLLAPSE must not touch it.

The daemon sees every result of every collapse it asks for, so it can keep
its own counter without the shared path testing who called.

Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 75c876acf527..4979a93e3648 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2815,10 +2815,8 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 
 	mmap_assert_locked(mm);
 
-	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
-		goto end;
-	}
+	if (vma_is_anonymous(vma))
+		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
 
 	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
@@ -2854,9 +2852,6 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
 	}
-end:
-	if (cc->is_khugepaged && result == SCAN_SUCCEED)
-		++khugepaged_pages_collapsed;
 	return result;
 }
 
@@ -2933,6 +2928,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 			*result = collapse_single_pmd(khugepaged_scan.address,
 						      vma, &lock_dropped, cc);
+			if (*result == SCAN_SUCCEED)
+				khugepaged_pages_collapsed++;
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			if (lock_dropped)
-- 
2.54.0


