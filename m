Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9435CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 12:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490508E0006; Fri, 19 Sep 2025 08:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A918E0001; Fri, 19 Sep 2025 08:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4AF8E0006; Fri, 19 Sep 2025 08:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0CC08E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:40:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B625BBAA1D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:51 +0000 (UTC)
X-FDA: 83905959102.05.B03FAB8
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf08.hostedemail.com (Postfix) with ESMTP id C9197160004
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="N SYViHE";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kDbBi8RO;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758285649; a=rsa-sha256;
	cv=none;
	b=lwjzUofdG5sOfqBT+VFI76p1Ag7cHuzEcQgouR+RUSQZvLZILHLHmif9PNsTeN9QdJwRd8
	O30+X5ee/SF+w/xBqC+XP/+EDxEiHM3fmlg8KB85Owpa5BlDDjQGpz0jKaICG1hC5/zyAe
	EnlnUxXGVYMgCt9MoJaLpwy+3TT7Eog=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="N SYViHE";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kDbBi8RO;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758285649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbXQCXRSraPiiKdXSvs7n/9rDBYdGNJLDwAjIbxUIRs=;
	b=pE6mVD0pOh+k2FJdtvptefArlad6lnJhMUR8qShL/9wZhrYujgJz655SKTCK/X3kDHQ4k/
	ntRv3rOyTcm2sjXzOT43gOZUkRxRk6K2pgie32IEIdEbBdUz92jk/Q6ZyHT6iuD0V4rOKa
	0jvkuD2uoPJcU8aOgHDdR5/O23hoSro=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1FC241400185;
	Fri, 19 Sep 2025 08:40:49 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 19 Sep 2025 08:40:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758285649; x=
	1758372049; bh=zbXQCXRSraPiiKdXSvs7n/9rDBYdGNJLDwAjIbxUIRs=; b=N
	SYViHEWild38F6WS9INcKPuheF7zhmeVta5B2MH+Fd+EwozMYQm6PWZHXG35G1+m
	+S52ybxYtD45Hnu1i+BTPyUnqas5Tvf7M8JEkvVL1Ff3SUz2qn/Bahb0dqCpZbE1
	sYKDzJlJ2zUUfQCeTpTVOJaY+irQeFVMpbqyVwEfH/MB4BBvzNH+UKmgjIIPDPSH
	6lbtRdOJi7B5Q/O44aamoO+/3A4lS4FqtnXMvaR+6lxDdSRC3dKkPtvFlw/7BRYX
	fSskhHDFupDuGZ+0kkKb+wUnhdonyzT6ktH+dT4juPa17rPxn2z697+ihAg0Y+Bb
	ZY0e39ykKlHoGZD3n20DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758285649; x=1758372049; bh=z
	bXQCXRSraPiiKdXSvs7n/9rDBYdGNJLDwAjIbxUIRs=; b=kDbBi8ROkAz0sn539
	NhdcLTG+VbQ9pN9Z9Bgf6YgHXcLN8AqtezTZDXrz3R3e94vrfzmJmJm24utk/EDI
	q51KGt659t2FKcxTy3TVoO8od7xmBQH8IQqiUcdDkbKG8JwYjKClS8ycT7KSxdnu
	zMLmhcx7nh5BmlXMOl+yrlDzQOTSRwF7B3UynnkjsaNaDgEjemoyV/+RnpuEq1/z
	P/KErjnLjw1vRNWofg77Afc9LD233PoaUogKpHWLEu+XCxfYN590e7aJyPbOVRfR
	bT03TDgVRy02KICnyaFMsyZZrSVw0c5iS57ULiQUBhyucEAoJhR/T26aPoy12f+9
	VzsvA==
X-ME-Sender: <xms:UE_NaOIynym39jH7ipn8OgrnkfAMPu0hrcl38pK-fLeMRQQ1X3r6ag>
    <xme:UE_NaHpSuWdNwdYEvmuGjQY6_hMNEmYVqJbQ83ShFQOdCdLvJlPX8asL74lLCUond
    x7q7YBuGlaeXVodXo0>
X-ME-Received: <xmr:UE_NaMWSH6G6mWwDcyHYJZI17YaQ79DFb6ZRU-aPVhhtSFEvDZht6xlZSBI08w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegledvfecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:UE_NaK0uqiiVdtiGAGQ0IVnUYxR-YLHrzt-EWVsWnlN3pM1riBHZdA>
    <xmx:UU_NaF3pCeFGH43GhX_HKjpLGkGnOmRuA9_YLLIoEEubMdi_qOdPSw>
    <xmx:UU_NaBkKPcsu-XEdPZ-27U9G1b_shcsWLWfEoCQmHOinO1lSSYEVRA>
    <xmx:UU_NaONZNr-E-fIDhOA1sTQIzxJiyLC0IF9bWBsTMhbcY0b9ayuU9w>
    <xmx:UU_NaB-en_t2e6nqwVGnn6SZ1vYVZXSK0aBtHqateyX9wMWvwQbFF3L9>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Sep 2025 08:40:48 -0400 (EDT)
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
Subject: [PATCHv2 3/5] mm/rmap: mlock large folios in try_to_unmap_one()
Date: Fri, 19 Sep 2025 13:40:34 +0100
Message-ID: <20250919124036.455709-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919124036.455709-1-kirill@shutemov.name>
References: <20250919124036.455709-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C9197160004
X-Stat-Signature: m3c3oiy9x5fxh7fbkwqsw1dhficoj8e6
X-Rspam-User: 
X-HE-Tag: 1758285649-247021
X-HE-Meta: U2FsdGVkX18+Z531vwhFMiiKGbihKh5NtVUmi4MYYbvP3IsUF0uJaVsS7fdT//GOvIvV/GHdc44Xa0yDOo0twarsI+3AEFBUwlsziSOVOPvxNm4BIX8Dus9+wrbuZFxKRmA8ZS8MXyVqWSEGjVrvR3FuAzUe+Ka0JydM3Y2tCNp/cm1xzziB/PCY7gonxWZH4WUc+w+BPxQIobyraBV/trFldm59Azr9clhDp+t8LlKL0X3DVCG04G2K6HnGy2jqKC1B2Az3FlqXtiK35mzZb2qvbrscr2a8Te87bvNJXNAy0IhxAW5iwN+OdG5Gnjw7h6In1jsHijdpCYgl6nm5YDxggjlzmwVvS4TCdBh/dDqAmMMznG4hTy1uSYSnI5Ki73h+w3W5UKoCTMg8mCtHKWMmZDMAYXoJEm/QfJ0UPhrlLz6XxjYAsFGUSvrmDG2Ecx1N/u528KY6ExVntlUTIqSNsM+bGJGizyJl85QhnBaLjUBHVpLpoUdEB2KtEhHNGXYEZPINiWfFe6VUk6djZz74dIgGzhts5R9uSjHgkmimNpJ1QzonWdsjlL9gub1gop9KbRCi8JjE4ER/0WrN8qmqphSiAP9eAXFwCc5k/883TamEfwxCu95cRifJDFxvd1mxzxGa1gIZXJ9aGewhnfTUM8P3I3znjVC+/aD3TvrvaTtkH3tKnfSUyDBaFuuA3gFwdRk9M5Ulh5N6QGULj1hfLCEwL8NveTNxOXh53qkWGgK/ohkjkiXpfpcyfXNrxGNdQ+wd6xOmrTyF8tig5lMqgsAZX78ItU4d1OhQ38+1AJJadlIWuj6pMOit4ymWgBv/5T2iZPy+BSpwBhoYWbKo3IfjkTFSQCW6zPfp/7iW+2MS+yv0vdrmloCiBaFG/hHZOolvrTGOLNfXKXuBVlhcENgrsIUpwToHlDLyi2FdSP6SsMJStUdscKiytQ9hlFpMy7bxJkAuf4bZraM
 BafJVZvL
 jqwVK0SXqYuC2/81kGG0Zt5LpAoyHkHTobYx3v/1nDY8CrhsUJrKYTTWp+tCByx9345r5nR1khSAboRddYtbzNW/fmz3fciDe4CIs1jLG5UKX2iEvHEIv6MKeVcTSeZN2cc0w00K1rhGRbbiDdH2XyA8gYCkLTIuJK6bGJh13TIESt5GVNQWFhcvQ78bTLvvTz3USNIF/9muFT2M+lmontb/b+RMlUJlpe0UCUTM26avijuZLK5tGLn6TR75TT3YwM8AOzB6N9TH5duqVTly8z5yXZpiUQ3TTWWyBcNil/w+D3H7Tgk7cI/GqjgMuKJC3m3EXe1b/7n4SWFjE8xy4WWX9lRZIykYU8yDgCLXRHoSM1MkpkbK6/nRIuYF4EmLfL3sZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Currently, try_to_unmap_once() only tries to mlock small folios.

Use logic similar to folio_referenced_one() to mlock large folios:
only do this for fully mapped folios and under page table lock that
protects all page table entries.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/rmap.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 3d0235f332de..482e6504fa88 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1870,6 +1870,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	unsigned long nr_pages = 1, end_addr;
 	unsigned long pfn;
 	unsigned long hsz = 0;
+	int ptes = 0;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -1910,10 +1911,26 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
 		    (vma->vm_flags & VM_LOCKED)) {
+			ptes++;
+			ret = false;
+
+			/* Only mlock fully mapped pages */
+			if (pvmw.pte && ptes != pvmw.nr_pages)
+				continue;
+
+			/*
+			 * All PTEs must be protected by page table lock in
+			 * order to mlock the page.
+			 *
+			 * If page table boundary has been cross, current ptl
+			 * only protect part of ptes.
+			 */
+			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+				goto walk_done;
+
 			/* Restore the mlock which got missed */
-			if (!folio_test_large(folio))
-				mlock_vma_folio(folio, vma);
-			goto walk_abort;
+			mlock_vma_folio(folio, vma);
+			goto walk_done;
 		}
 
 		if (!pvmw.pte) {
-- 
2.50.1


