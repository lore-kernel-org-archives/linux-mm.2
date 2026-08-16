Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35302C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B663C6B036D; Sun, 16 Aug 2026 18:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16FB6B036E; Sun, 16 Aug 2026 18:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04DA6B036F; Sun, 16 Aug 2026 18:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6941B6B036D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E56771605D8
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:27 +0000 (UTC)
X-FDA: 85108618014.24.F566D26
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1017DC0005
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="D 3Ni3tb";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=cEPsT0B+;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2u63L0ngEfZ0oZc5UJMeb03US//762Pv3O79FLFlVN8=;
	b=OBm3U43pZo8moJrkAMmG/olfVDH5B97NI9NX5WAMOwyu8f3VxWOQGLZYjfAXMLxALii65C
	K+BN3SJmmNg148z/FHIr00JCbH6qqO+tt8ckPzy7O0AuAbPXuAkXTs0PaiP+b2tF71clYV
	+gWxHE3cRm3SKr4h2auagNUyEbG0vs8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="D 3Ni3tb";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=cEPsT0B+;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920386;
	b=mvgeKIzoL++Rff+r/N+EnMSkiX3kbZmS6Z2h+NEOZzI6xlVqHkEg8HrFGg4E50rAr7KTva
	hs5PV1dmsZpRJwFIl9oF5CALPK8o2Ansuj/Th7rI4jbIllT2bmj5sPLUF2OQ+IsMpO5NSd
	Y7tzqyC403mKS8Qc++s7DtQnBoq/Vo8=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 91497EC0242;
	Sun, 16 Aug 2026 18:46:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Sun, 16 Aug 2026 18:46:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920385; x=
	1787006785; bh=2u63L0ngEfZ0oZc5UJMeb03US//762Pv3O79FLFlVN8=; b=D
	3Ni3tbJD9MHvRzagaj9i5rQ+7ZHnppGXYfpjw2FMYRVFugWxwF2lndP58rlS8Tkg
	i8BmzBwEv4BnalDdR6aqfy7bXtflnh8yvRW6wN64fynJJmH5QtlpBVF8DFmbl22n
	5CZwd5ICB9pds79B5RXAf1QCr2PVbAF+uGOSrl9bve/wnBQCWKIrnvm6ftSygTN6
	TsNRaGsZ/xSNFSz5/dOPQRxbxcy4WpAP1XQIvtFJ1sNjZHLg7B9Neyz7wCiH86zo
	/jIuqyMr58LpUUuk9WXLnERRSfgWF/F1bFjkKrJXQfIEOqD9e9UUvleg+5Rvrhl5
	3zmzJEeCGEJQhUrwPgT0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920385; x=1787006785; bh=2
	u63L0ngEfZ0oZc5UJMeb03US//762Pv3O79FLFlVN8=; b=cEPsT0B+Xjq4pdpqh
	LRcDAkqohAJ+F3LI8aRpaHyCnmDweNb34uftCX1p0uIJvCRUpmJD0rSOE/RJM2mK
	Phf5Fn/xR9li1nkJDl2nsiHD7b/Xl9WcW1ux9pX5OQ+IHheVJ/WaDVIO9fZ/Sj1o
	pA8bbp883MtVJa8WGyFN1dvm6H8gpFxNYkXNJPZetaNoQ89MHIyzd0uSKjxcDscw
	ACrlaQFWotIay+ZxEl0oGs6DvFLAJlgB0P9Fl0ce87hCDdPzriuoXGfigcurwBcR
	sFzkKM/KGO1leZpLI2e0DVTEnOAIDkEg7z7CtMt3Z8EZZYiufT7pEts8YZboMYUO
	Z5SdA==
X-ME-Sender: <xms:wT2CatT6VVOfaQyi-7v82S6qkb0kuqWgTpb33dJ3KmNPISXD19oAvA>
    <xme:wT2CasF52ZgOP7Wau6vkrK304WJrztDVQSE6ZmZljRZn1xF1_9wUY1GYe3TV1RCWm
    Vo8fAKwRpLaLL1ORL3KlRpEgqeZxLQuOXLacI4rIXxD3JJb1Pa_adQ>
X-ME-Received: <xmr:wT2Cau40tnCFhUsoT4EW18icUYMer9gWKfk7YsFA09QwqcHPeqYXMH7UNy8>
X-ME-Proxy-Cause: dmFkZTFX8QZ1Abcp//ElmtP0wYUsUMnb+KjPA544aOlJXhXcQAudkXa81C9Rj4L11ediC/
    SYpDnD1LvcyFEAv2YFQNL3ReIx6t28G7cFOXvsWQqNdQRv24cIelnnbcWrHqur16sY2q+b
    PHK84xbhjrx0R6ZFbdj3lDcQr+wbYteZ9PHsSvZgjQoovnxRkTlpJXxI+K+aK0DY9MqaWr
    nM0jSjvJAOtmNeFdTIuI9VxKMOFqeJI9DUUNBafqnTlsaU2K5w1xy/oDJpRmozGKRfcEpJ
    T4FDpTcqBKNo58tTW6I4nVl91YkYNyFfziYdH6IV5aj62MGBqsSUtSYZnaDODTOndFzTOe
    O2T+e6i2Gb6iXpx6u856YCM0Twl2zjRv6jsf0mu3PZPrhPjoJp43+TcgdmbLSiZaIa3ttT
    Xtv3uffV61LDU9Bxx8ngiLZEpCG/jF7lw3dGmsuX6sYHJKahwa5GXZ9nam8ziMSeI1kra1
    48PX9SyKC5GvF0rAs+rjraJErRymPbrT3FHL6+nlhWTPQ1cNs+YTdOTsO+Dl3vMKOgjwoZ
    DqQuTq/btPOXP6J7W2Wo+83UdwvraRj7Hw3QYH/7wgDoOk1mjJLYwF0YAfuJAnZePL/9ld
    8D3vhPzRY4A8pdb3x4tFK7UN0/lbov4pDTOoRfRpRgcix+lPNecjcwqamMUA
X-ME-Proxy: <xmx:wT2CahlAF74-b50w1H4nUKOFfjdXf9JX7zz9m6hvZZ8-f8a58wODfA>
    <xmx:wT2CaswB6pcgyFhBUizUKRKVz7yW8Q3nkZDyP8Ps4_XPvbXZZ_eDAw>
    <xmx:wT2CajMqUYwQ0Y3Xe18XWCz38p9mRLctkWt7bQnPttHlCEIdH3Qn-w>
    <xmx:wT2CamgeRSgLN_UOqFqPwK4aKJ9ENYFCGv-buMiBGf_UEjdRbPoj2g>
    <xmx:wT2Car3TcRplushI8ivcH2lATUhKbDMvc90CJFl4CdcfbtDHTYOD4WC9>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:24 -0400 (EDT)
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
Subject: [RFC PATCH 04/57] mm/collapse: rename mthp_present_ptes to eligible_ptes
Date: Sun, 16 Aug 2026 23:45:16 +0100
Message-ID: <20260816224609.308019-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: r3y71xuc7bys8u1rkbrze6rsnd3kyfem
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1017DC0005
X-HE-Tag: 1786920385-135817
X-HE-Meta: U2FsdGVkX18dREi0J4aUwELeXgen4BMhOFONAMVYUVUpN26eOw8ZtPPCx7LbhgwE8NVtcsWO0yTixznH8AU5HYpSO+KmUJr3LMCJ6w0dlhrSM6SMc8t9F07cQZfhJJB3qidoQrjqwGgCtEpErRt83FM9amimbUDsXM+OQz/o4a7S6q+12XGmKgwlLrQayHTZK5EtamxOa9PjOJ9nDfynblr7urqSNLDhK0VL/ECtPE0ozNR3zVno1zHkCxwkq8gZNXbUMoGj+N+qacfTdLnplrWauxfuoIhCkxD+5kwiv0Ttk+D1HctKQ24toOlD7e/W1Qrh/dxNRuqcu7Qsi/sEfrNhtIwJUBv6CHDfi47r1ltBa3edMo8SK/vfknoet52rZrMkd4iiClcnlq9Sa9lRlq0Ahhrv/R/f9n+X8H6bfHIYUrkXXMCgNuNQAygYCP9jmAK0CmPcQJZgwKvBLEASpfU1GUhmT3pw0vbJT0u5D5aqJ0OqruyaqYm3+PArCGE/by1Xx1wErwd1nV7ax56+4IHeYBs7SH2+s89dsfSBRwTzRbgiBN6e3/GXjtEJhBIxBgqh4HkkywHddkEdRuwMKjAuyiFecLO+NhvCvhlOm9iZY5H/sGWjhSRpmjjchlQeaU1xbnD2cbXcyP/P3I6jCkvZXq34WvFk8hz7XfOZI7Pfda4pQX3WRt3gyIOPBA+DJdPl99NT2o4rVA6WiVtIz6tuUZvuce+LsTH3NIbE9zAUIENplxZD7AhA/8mjTY6/OgKxLXnHeYm4eeSS0gYNORGsypH9DTOwzFoPsU9h3pZdIt3T8a9/4ObFAyGtPnwcxnsGU1praHTzLozlTbk5uW0osaCWmgVYcUTpJMRxZ8HcATayIEAydFQmfHBIT4lujNSsgNSvaKadK540mN6lqkQ/8S2dvvvCqThUSHmm98DJ+58Hj6JxTWItUOSSPe5qPNr1YOOi+rnYKs9uwtt
 0kGuGzk5
 2uxE/EGdiiwEI7IpaMPH6L9Gh1JQLZOMgaA0w54SLSDvoblGznRQz6qTyujfSyvPPKc7MdILjBHsCN07D0m6eVeRqQrmuyQZS7LEhessW81KIpsC+1xvw+7S3MEScOSKLMeNDcS/cBjSN3Tm1EPGTDXakpcPc+SVA4kzvHnFnmDF209qvh91PhTlXGs4T9cpXyTPPvjfWDxM9Qq4A61u1ntRAUZTuSs1Dy/3Ubrv7e3uFUx87BKU+SIA+9A5T0rwj+xGK8rZIqIdREKrjjgsXVWtNgMRDuJeu9znL4zLWzlCGDJ+DTiRExCcNs6EOwzRvoKLB+TtXyA5V5OumaYn5EA6+CJe2a9rNxYir2EfCQC5NQifHhC4JRtLMyLxsGqRIViQX/7nrJmbsGFvbP+mCZF0XdecRhNUjHCYx7+4+KXjJLBuTGQRLEOZFH8B8OMY0TriXQSj/tnmRF618nnjATLmlteIDDtaO0Y92oVvyBo/ZWn9ffMwdlImoDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Neither half of the name holds.  A bit is set only after the PTE has
passed every check the scan makes: uffd, lazyfree, anonymity and sharing
among them.  Presence is the first of those criteria, not the whole of
it.

mthp_collapse() then reads the bitmap starting at the PMD order, so the
bitmap is not specific to mTHP either.

Name the bitmap for what a set bit means: the scan accepted that PTE as
a collapse source.

No functional change.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   |  4 ++--
 mm/khugepaged.c | 13 ++++++-------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index 26dbac7beddd..9c82e71533df 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -53,8 +53,8 @@ struct collapse_control {
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
 
-	/* Each bit represents a single occupied (!none/zero) page. */
-	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
+	/* Each bit marks a PTE the scan accepted as a collapse source */
+	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
 };
 
 #endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 804b1d35f52a..a12aafae8d9c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -576,7 +576,7 @@ static void collapse_control_init_scan(struct collapse_control *cc)
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
-	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
+	bitmap_zero(cc->eligible_ptes, MAX_PTRS_PER_PTE);
 }
 
 static void release_pte_folio(struct folio *folio)
@@ -1437,8 +1437,8 @@ static unsigned int max_order_from_offset(unsigned int offset)
  * mthp_collapse() consumes the bitmap that is generated during
  * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
  *
- * Each bit in cc->mthp_present_ptes represents a single occupied (!none/zero)
- * page. We start at the PMD order and check if it is eligible for collapse;
+ * Each bit in cc->eligible_ptes marks a PTE the scan accepted as a collapse
+ * source. We start at the PMD order and check if it is eligible for collapse;
  * if not, we check the left and right halves of the PTE page table we are
  * examining at a lower order.
  *
@@ -1469,12 +1469,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 			goto next_order;
 
 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
-		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
+		nr_occupied_ptes = bitmap_weight_from(cc->eligible_ptes, offset,
 						      offset + nr_ptes);
 
 		/*
 		 * Swap PTEs accepted during the scan are counted in @unmapped,
-		 * not in the present-PTE bitmap. Account them for the PMD-order
+		 * not in the eligible bitmap. Account them for the PMD-order
 		 * candidate.
 		 */
 		if (is_pmd_order(order))
@@ -1682,8 +1682,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			}
 		}
 
-		/* Set bit for occupied pages */
-		__set_bit(i, cc->mthp_present_ptes);
+		__set_bit(i, cc->eligible_ptes);
 		/*
 		 * Record which node the original page is from and save this
 		 * information to cc->node_load[].
-- 
2.54.0


