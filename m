Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520B0C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7515A6B0095; Mon, 28 Sep 2026 06:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB046B0096; Mon, 28 Sep 2026 06:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F09B6B0098; Mon, 28 Sep 2026 06:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34B916B0095
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A01E8120177
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:42 +0000 (UTC)
X-FDA: 85262741844.09.1AB7ADB
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf20.hostedemail.com (Postfix) with ESMTP id B17611C0005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="s qDofRg";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=p1dptg7i;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790590000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyGjn09ahn/3UY0Q2MnLrKdILuuBxo8mW/lM52WL7VU=;
	b=H1gU4fTon108REEe1JrQR8uumd4u98rXxNui4XZYEPWA0fDXCMfw8rLkCb9TugrmZixi/c
	JPQalmem2fE7aixEteZ1x9sJQKYx3++/xG40H2aUUdmdEo8ia2rjglNTIHN+TY8ch7SmSu
	TY4Fb413XAPn9Gczl3CyX+7zrh2+3MQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="s qDofRg";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=p1dptg7i;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790590000;
	b=GXhKbSK3uZ/gIWiH+iE8xMrLlQNDuZM2bs8Y96LY0zOf8PNA9zfD5O0m5PUKnLHw0ghZkv
	qhH1c6xChnVr7iTsvfI+rf5dvYOmanCr8fljlTAfVy0Wfqs5SbFmKSfqCjQUGajS/8lvoh
	9byQBL0wAU8xhQLTdvSCJlbn9c6F1Ec=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 4D001EC011B;
	Mon, 28 Sep 2026 06:06:40 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 06:06:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790590000; x=
	1790676400; bh=GyGjn09ahn/3UY0Q2MnLrKdILuuBxo8mW/lM52WL7VU=; b=s
	qDofRgTSM0136aLGq9986888/biMfGUpHizdEGKj/6mH0IwDGAHRsD+5CVTpJCmf
	HfF12k/IGw32YcNgbhcp6na/YAo5vdSpysPY71TjBzUIQfbXv71aVdzoDUfYKbTC
	qgzYNPsd0QvOZKcp7LK8PEmQ0rVNmJhMblnoDvbKoNdjQujEqt9tIc2wSAgHVM0c
	3MIOB1ccVgssGSX4/HVtYIDsOjDIExt244B20DhXk7TORNX3ATEpgPN/RVGUsc5z
	4yh8nfqNAuUCE4Upf+tVpzw5TyxYBTenmKcxGVxEh4OjoLX/GdLQOtV+Oj/gBZLp
	E8hNQuO4HqSNxzT0Rc1+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790590000; x=1790676400; bh=G
	yGjn09ahn/3UY0Q2MnLrKdILuuBxo8mW/lM52WL7VU=; b=p1dptg7iRsPbXgViv
	PnHoDNOrwm3AJKxF4n41ktbjYaIr0+Soe0VIgXtx/KjRE1Ff6M9L2BfkZAHoIfqX
	8eWBIUsYf6Mw8ti6niqcwGzLwO1gBJGgCl2Xs5+a8T2lJviykFcLQQ+2ayAOUqD8
	V2jFQB6BcgKC0CE3uFxlI880SkZj37SQ50h1xz0d2+utv0yFj08Y52kCxOLcYP1o
	COpsa8HrLsfy6+iEg/9YWmbiLyZrfb/x9uWZu1mdeDkLgMX4gLl4MS05Jw6m10nm
	lRf2EUZMrF6pw93w52Dzr6ahbuIc9ycIo6m9evu/KL53ill//pi9u0H3bLnK/J5v
	Hwu2A==
X-ME-Sender: <xms:MDy6aiVxuonofH4w7-1NtxPiHLVPgcy25aA2z_K4QMSK-gr7pzbRxw>
    <xme:MDy6aqgpatMWbM6NwaA7fXyclmZiGNByt-iElWlaOUeUVsBSftUznh1SeZjOafRDA
    3WEUCiT6XwFAIbFcplazzkNavFvv7-BTIicSijvtlZGSOoEIVd35Tpk>
X-ME-Received: <xmr:MDy6ashIYj_n_Z1qKOQxzc8IdIX31Z7hBvVOCMu6ati-PPRaZ2f9gIuEKJs>
X-ME-Proxy-Cause: dmFkZTGMD42hMgRoykqOjUnjhQtIwxUkbQ7HJUm3r0v8qg4G+w5HsQqCTFJeONZOOlAoTZ
    3cCyUPpxIiSbyZ2Tu7YPa3AAj7sCTCV2iMmUuGeQ9O2nYvFx4pqQgu47FPrepCLtn5mR8Y
    TFpZu0gc0RK5+soBqa17Izn0t8458G4TUOMorf2iUNwoNcvIBqn6qB4EfUoYIj6v0KZGYR
    +H9V2caIQyvUMHhBp6HpDE9LGyk5fDiJXvaKgdPDp7u8Zi3Y25cXOb1RGde0EKV1CRBWLp
    8vgyxTPXFx2P0qBK8gg3C7juaiX7+nTPBAuBcmJzHDM+E8HDEZrS5vhGsuUSQCum3RfeZP
    1qgFo921exWSghsHzwiPbF5RsN0fhr95Ft8wi3INqf6veKgs3fYfRT4uVAaks8R00u9cI5
    v3qQ3zWj7GEl+LHXWkm0DsgxlairW9DrZigbyx6D/NkNWYBfFl7UxnT4fwigK2ZSKPHpNT
    4Lb+z1RzNZKqxDeAUMoyS5hRnxBzESu9z+BQVSDA2Nt80jWkr8MQsZ+FftDaUv6prf3Jzt
    xC2sTgzu8rmv4n8nMx1jMmzfWpOfjRY8bvSLPnY6ZtzT5M7iFfdYrv1VbDEq94AVV1fHqc
    neBxVK1krPXYyOngIh1ZGUv9l+8xqxqNVPH7XyjHYrwX5RG9MgTygfeDmomg
X-ME-Proxy: <xmx:MDy6avuFQvVsKph4AuPwkfEk8gUukiYMqpMzXh4lFlLUXiHyq5uXMw>
    <xmx:MDy6aqtA1msAlq9qLxlhDzZo-bnSgDi8gH3yMnCGQrrE820JUMMsKg>
    <xmx:MDy6aoPGH-1DeZWXg36tRZor0CkaPuwTvHeK14Dd5lrE_1EGuwMkFA>
    <xmx:MDy6akdXRGjN-CdPFKR1LqenSZIbyt2A0SD6iiAC_hN2daL7fzHI2g>
    <xmx:MDy6ag39jEAvNy91fDPFYbJJ0VG_k7N7cNf65muTtsnTUVBDhpxpECwL>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:39 -0400 (EDT)
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
Subject: [PATCH v4 03/13] mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
Date: Mon, 28 Sep 2026 11:06:17 +0100
Message-ID: <20260928100630.21870-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B17611C0005
X-Stat-Signature: 7z9y4sdsh8egbemb4boydrj5mu5dn4hp
X-Rspam-User: 
X-HE-Tag: 1790590000-170335
X-HE-Meta: U2FsdGVkX19CDXwXeL0wkfTojagQN4Wwsx7atourr5JerUcOmR2iFb8Wt+zTmN/WrXp3zzbfLVnOb1DAbqbZpPgnEXSDqZRbqWnmWvtkJ/gEEzTf9TDhU652gPiqhXl750AOfGDb06/inZ15a4jKNM1b8UBmYVHKlaO04gK99UrpzxbUhh5WNTn/dNhTrREhuaivwrNcH6a/0Y1UP7YcGh+I+MNci1MsQsQslJmLdmSTZifYexdbuFZKO6W+v+TO+KzEl8iw1Vt04gi9z31RrV6bekZL0ORpC3htKNjTjwvhuN0J4bE4gLFzKG8d34wIaxJxzplxWOEeg0XATZuL4Q6PuH1mAUpOE4/v3ztFrl1blunYMYDkakhJW+h9OrPpW7Jjo8YKlzzqZtVvreHdUqxoy1pl1Xh+s+Uocch+zD4td/PTMQNnrmdv6sAvvrmJRZEM+M5sorFGLVMcDGudS2BvkyNSD80ZOSNGYfJJn+Hb/QmmZOtnfvEHJafiGvMYf6JFmZoUCEjDKK95xTeWZpdRZ965SQ/3PwhlL5ny1X/FazLI2n1WaD5fB2oHB5dek15dXqP8pYdRGNw/KyCA/URZjgp3mDn0PCgy1cZSP1KFQKxo89zAslRWmZHXH8oKcaH9CxXL7Z7WwJMcQielspC1L4X2yFUtOMZ2wjGK2Gfx+3sIT/ZYArAklyP7xahGaVjmTHb9M6VnCw2ecH4wsgfAmIDo0ap+ivT6qvrng68s5ZWwzt1qIUxunpD8I1Qn9snbViQZlGSc7ye7pwtghDqsWY9n3/2XORSLGaG0uXQ1WY/788c+gFJQ/N4UGcUXCtq7PvJtY3NCl/jbvnhhA0YXWKMnb7a5xuCnrogwEudQUUo+QR+BdPWSvUDcJvBOd4VVTRciBeVvI7t6KsDBxpLO1ETAleq79kw8Mjj1QHiLowuwpHOBPIpjBolm9zdNYF7pkUunjedLxKgdMh0
 O7c8D4j6
 YicyUngm4NyAF68bQdLmDVQsd77U5WqB/ouHSrx8nrhgWu1GbJ0Ng1quQu54/alpjUwvp6FL5z+2GN8IWIHANBPAx267Qy/nkgymkzAXKWODiLC6iARAa5KLVOcyKjkmnW8rJt0i50Mk6pRfTWUQnS2AnqdxiYgXj/bR7WvaosywNBuOxsesVpd63qxtNrTQIm1w5p5wxjrfIWHOVam8OuNH5Pa0tE+Xt2JIVOuGO0ToZEr06UfUTscMBoX0I+UyV7QrFeRLv3wLVtk8OmKtKK58BkcznI8NKOipcf81jyfHlld+fDOs5OZBbgWl8MQV1KI4l1y5avnidwKuoPaxV8NoCN1dRevQvOVONElH8E/GKWOvcfK9zITcHs1+ZFEbdzciB5Kt6QxyZr0kMjbc+0r8V5Sgy1PhPDyflM/DoPg91ZGHJxuPdE14PR1dcvRBOxuKGcg/mU9dQkLuIWUJ9Fvx5VGDN3VQmF3vUh2g+lzxgMp2u6MtQtK/ymXNZrNFdJqBHJbvepIjYkKbQUIkBwiTsY7nbWMO78MEB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The name says less than the bit means.  A set bit means not only that the
PTE is present, but also that it passed the other checks: uffd,
lazyfree, anonymity, sharing.  The PTE can be considered a collapse
source.

mthp_collapse() then reads the bitmap starting at the PMD order, so the
bitmap is not specific to mTHP either.

Name it for what a set bit means, and update the comments that named it.

No functional change.

Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4979a93e3648..081f705cfca2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -115,8 +115,8 @@ struct collapse_control {
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
 
-	/* Each bit represents a single occupied (!none/zero) page. */
-	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
+	/* Each bit marks a PTE the scan accepted as a collapse source */
+	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
 };
 
 /**
@@ -627,7 +627,7 @@ static void collapse_control_init_scan(struct collapse_control *cc)
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
-	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
+	bitmap_zero(cc->eligible_ptes, MAX_PTRS_PER_PTE);
 }
 
 static void release_pte_folio(struct folio *folio)
@@ -1482,15 +1482,15 @@ static unsigned int max_order_from_offset(unsigned int offset)
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
- * For each of these, we determine how many PTE entries are occupied in the
- * range of PTE entries we propose to collapse, then we compare this to a
- * threshold number of PTE entries which would need to be occupied for a
- * collapse to be permitted at that order (accounting for max_ptes_none).
+ * For each of these, we count the eligible PTEs in the range we propose to
+ * collapse, then we compare this to the number of eligible PTEs the range
+ * would need for a collapse to be permitted at that order (accounting for
+ * max_ptes_none).
  *
  * If a collapse is permitted, we attempt to collapse the PTE range into a
  * mTHP.
@@ -1499,7 +1499,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 		unsigned long address, int referenced, int unmapped,
 		struct collapse_control *cc, unsigned long enabled_orders)
 {
-	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
+	unsigned int nr_eligible_ptes, nr_ptes, max_ptes_none;
 	enum scan_result last_result = SCAN_FAIL;
 	int collapsed = 0;
 	bool alloc_failed = false;
@@ -1514,18 +1514,18 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 			goto next_order;
 
 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
-		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
+		nr_eligible_ptes = bitmap_weight_from(cc->eligible_ptes, offset,
 						      offset + nr_ptes);
 
 		/*
 		 * Swap PTEs accepted during the scan are counted in @unmapped,
-		 * not in the present-PTE bitmap. Account them for the PMD-order
+		 * not in cc->eligible_ptes. Account them for the PMD-order
 		 * candidate.
 		 */
 		if (is_pmd_order(order))
-			nr_occupied_ptes += unmapped;
+			nr_eligible_ptes += unmapped;
 
-		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
+		if (nr_eligible_ptes >= nr_ptes - max_ptes_none) {
 			enum scan_result ret;
 
 			collapse_address = address + offset * PAGE_SIZE;
@@ -1731,8 +1731,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			}
 		}
 
-		/* Set bit for occupied pages */
-		__set_bit(i, cc->mthp_present_ptes);
+		/* The scan accepted this PTE as a collapse source */
+		__set_bit(i, cc->eligible_ptes);
 		/*
 		 * Record which node the original page is from and save this
 		 * information to cc->node_load[].
-- 
2.54.0


