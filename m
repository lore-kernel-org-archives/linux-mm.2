Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C4BECAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165968E0016; Tue, 23 Sep 2025 07:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116AC8E0001; Tue, 23 Sep 2025 07:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1738E0016; Tue, 23 Sep 2025 07:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D6EAB8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:03:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78E061A0476
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:03:27 +0000 (UTC)
X-FDA: 83920228854.13.A39116A
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf28.hostedemail.com (Postfix) with ESMTP id 91234C0011
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:03:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="g 2S6l6L";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Y/X2fY6S";
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jFlzJ6561wUPMtQD7f6sb4ugc+4wKUHkJSRo02E7hiw=;
	b=T7HSLOX/J8vNTn+wevATVFqOl165OhlF/j3kwA33Qd+DAzs2Cpu5rBxD7xkj2z0yfMp0Nh
	CMfd1hdeAIUfDov6EsTy19Es+yazi8M2U5ykzWYl+xEPS6S8hd5KfTvfevV47eaFo0ObdS
	hNRaqQ7ii7YVyVX14WMMHcwjM9cF1hE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="g 2S6l6L";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Y/X2fY6S";
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625405; a=rsa-sha256;
	cv=none;
	b=oOsT2RzSDaoICHV/1ykJ+tiMYn6JXYvVeO/ckl2i/dgE02tILCoEBknmPLxRB0WLXR/NL9
	LN8/eGpxub+dAede9abDl8mI05iixO6WkTJxgRY/2SSj5qo8t970cpMidKHVlguP3o2VMr
	2foDrv+oAG/ptVAvHZ0Z6kwedYDFKLo=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id EED3E1400062;
	Tue, 23 Sep 2025 07:03:24 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Tue, 23 Sep 2025 07:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758625404; x=
	1758711804; bh=jFlzJ6561wUPMtQD7f6sb4ugc+4wKUHkJSRo02E7hiw=; b=g
	2S6l6L3MiMKNrVVk78Zc42IA/qVS5hU2W8/SmfolFj6PmyajazMKSkaPdK2jcjyZ
	usnOBTZQbkHfJCtyI/PliNUHMJnR5hZg5trr2AWDnCqIglt1AR55qHhnFPWUvFbQ
	dSRQ55n08Chzf/Tq1y1PnH1f4dx+PK4KRYOk+C7Rd/491iIIt0JxlVSEJQKH1f1B
	KO6tKHNVXXOIOVB06LKo9hZ8UcWU7yQdSYjNkl0hqmOv3eypaRwkYBQLCPjbDmM9
	Y4vDPril2mcwcPg6iU8x7qFVwujTznEjp1C8tTlSVRltrxw4cAM7zkdsUp2g69su
	Bt64h3faz0B1DWzo9r2Rw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758625404; x=1758711804; bh=j
	FlzJ6561wUPMtQD7f6sb4ugc+4wKUHkJSRo02E7hiw=; b=Y/X2fY6SixOFXq11V
	ZjqoBW7hM6wonlm2NFcIwz8Xn8bf7NEmxX1w3YOt0Q2FcP4y57fFgc1Ngh5OjOYb
	f6YQaS41vTRwyDzwi4H5uOM4UWeLRhcRrTWq3kNOs4BA2yyO4fg1F+VsiCMuIP2v
	VooPr3YPERizes8Mh0aPKt231ZLTAz8LfyPTOrP+EyhHOEU5Go/7i/2drxRb+Myb
	2/W0i8uWuAhEUYAiqk1ZsomTEWeu/w8KPLMb+pilZgBkyFmHlncIXyVGeXEz1Phf
	lMNBcro7voHeT7Z0m0/GVh21R+GzzewTFl3S7GtcDyzWV6c1VPmMGW2fGnyb/pIX
	zgmvA==
X-ME-Sender: <xms:fH7SaKHIMfLrnPtKye16LSHklt2fYlVPZEg4NfLJfU9m5WeLYw7jDQ>
    <xme:fH7SaHTRI7WZY_32Ab4Im7Jrz9dLpcIUTbwmYMMXBqu9kJfp0I1s8sG1DKYNXGWTX
    dvH76o75kA-wIMvFadwL_Keba1bCQi5vQpOu7w769paoI6DApZGP40>
X-ME-Received: <xmr:fH7SaKQCQMCMX9gyOywilbbmpk8KyD7N-AsG9_WfC4bFNELd6TH_hbJkI7N8Dw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegveehtdfgvdfhudegffeuuddvgeevjefhveevgefhvdevieevteei
    vdehjefhjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilh
    hlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:fH7SaKdQdie_-tnQsz8s2hh7eaHLb6aAEstkUi7EAhDkYfHOsNWCOQ>
    <xmx:fH7SaOcTilKhPP7o8DyTOetli2aJzcjap9kkqN7k_d5BB6at3000Lw>
    <xmx:fH7SaA-fyHqMt_fYdit-FKs0aIwXUux6u82i-_Bu7ebeHW7iLAuAGw>
    <xmx:fH7SaONSxnRORZyPyqhtBcM1-JtuHeTSs2U3eL6WKL9NzzgbX2sLDg>
    <xmx:fH7SaMK19ysvTWymXHmPF4TZpQTs8SJiLjGJf0-CR8F8r2gUx2RzG10H>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:03:23 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 4/5] mm/filemap: Map entire large folio faultaround
Date: Tue, 23 Sep 2025 12:03:09 +0100
Message-ID: <20250923110310.689126-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250923110310.689126-1-kirill@shutemov.name>
References: <20250923110310.689126-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 91234C0011
X-Stat-Signature: fgb6n666n9gmzwrngk9k5wjmf7dsjxas
X-HE-Tag: 1758625405-469455
X-HE-Meta: U2FsdGVkX1+o5BrH32nWtBIGy/CP0uTuxq5toU1DPH4rOdE9fBE0Ixpi/2XXnRJ6nUZrmgvGhpNhGUQxZrKRPHOlOywaiQYlHnYUlO6lYEjjzU5RB6KuBiCUabLksLPxjBNaV+/itvPKuEoVxyiw5G+ZNfDugOyPM7+86R0tsZsu/QR/ZfhMipBcmSM2Y2ewcMHnIZBexyyW26lKkmNzWTlDY9eGsKZQX4g8WPFUhzBjfmykgNOxiJNeBR4kaJty984cvVSxvTYUZrou6AYeSTJM0UH9+hiSZteelNaPjU/Pj2zuCrMAddw/RkHqcNu2lvKxY/MLnRmijGit72gImSSvhFUm/D0UplZbJlqc4wnBoGyHz/Jo8PY08iiH1VPMWHLRLNiCOfKgFJpMlzPMuMu6J1x76S6elAxDAeW1hCZgtDqRF2kOeRiysB4TDfo3+9+il74kdM0wcX8TwrozZqviLTD2sjEziTqQUpDC98CSSvsPqGNOPctwbniqlewgpMkMSt40rAewnU8eqIM5H/Q9lw9gJelF1atgmnlLuVRINXV1eQhPrzhvVvs+9eJc/yaTSCo4pxCUWK1hvFxnPX21GAjdhoziIdXCGGrTLHgPGxdQVp43Pal4r5vgCWr7irKPDtSRXuLUSCFX2UTIgnisZVDItoxqlRU7Zkq1t7Ix4STx6ykPI5J4YyzRvkFr/7+DkRE/PeT7PsPIPji5MIdqJNpx54W1nC0WUHEdXFHywXo8XRxtZelisy94FXHz1vD0qCWeBO/w8THK4wvDmmkzqULRqQOO3AWYo072hSPxBvqaDg8BrNp+BNdDX9Wwr2BLUklg81a7jnUBkhIY78rH8KKS7VZTT9dGG7j+LkvmyxqdNMjIEKAhG6n/MCNqiMx+ZjbENJ5xrGIcTgav0ubK2I5fWL61QW+64DQsjfkk8bpaV6nBPz3PNTyvfrUU6bewWuA3SDFbwTt13+0
 GOVeykjI
 7r9191hEiAPlwOACX+0jM6zAeCyO3n2chs1NBJzou9wKzEWLcltRQy88K5+w0A1UTbLjA45jWwXs9415dlNAcvJQPv6W2klmjsJzqNK9SqOKXr0SnV96Ll6iwT3QEPg5TUp8EUnoGWx3XHHSccqqc+X9nn9dPxE9tjub1TqMw3Bwkl1xDe9u20tDzdjma8hPuipYLbowkyIVagWcNnCAuZyQ3tU0YmocGVTR82MmdGLr/IrAb6fj8WPqZ10aQ0d4nVgNoK9/pgS1pbGUwA/sPMSWDqibUbrtDJQG/oDnVa2E4edTvkmUAVq3PTIR6qwXz+dhYh7X/Pm0jJiL250ajgkMHvf6HD4RpWXspIKAnB9VbTOpcuP3jk6gaG61suJmxSQoMoTwd6H1eA4c+41T/g9klWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Currently, kernel only maps part of large folio that fits into
start_pgoff/end_pgoff range.

Map entire folio where possible. It will match finish_fault() behaviour
that user hits on cold page cache.

Mapping large folios at once will allow the rmap code to mlock it on
add, as it will recognize that it is fully mapped and mlocking is safe.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/filemap.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..26cae577ba23 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3643,6 +3643,21 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 	struct page *page = folio_page(folio, start);
 	unsigned int count = 0;
 	pte_t *old_ptep = vmf->pte;
+	unsigned long addr0;
+
+	/*
+	 * Map the large folio fully where possible.
+	 *
+	 * The folio must not cross VMA or page table boundary.
+	 */
+	addr0 = addr - start * PAGE_SIZE;
+	if (folio_within_vma(folio, vmf->vma) &&
+	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK)) {
+		vmf->pte -= start;
+		page -= start;
+		addr = addr0;
+		nr_pages = folio_nr_pages(folio);
+	}
 
 	do {
 		if (PageHWPoison(page + count))
-- 
2.50.1


