Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0048CCAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DFD38E0017; Tue, 23 Sep 2025 07:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E0B8E0001; Tue, 23 Sep 2025 07:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647B68E0017; Tue, 23 Sep 2025 07:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5948E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:03:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15C67160469
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:03:29 +0000 (UTC)
X-FDA: 83920228938.16.820B41C
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3F58D1C0009
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:03:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="H NjaJRt";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="AWz/3unk";
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBJQwyFG/mBuy6u3kCYzOX5EZriO4heRBy+k+i4RgPY=;
	b=qlP2GVCuo1JbL+qVy2aoboy4B3sZYpAKzV/SsIK31Ab2xI3GZkJPTLHRw1zhapIIMqCddn
	2UPrfIq+BVfXgeqowzz99bzfNMRlxTnSBsASfVSjRs+K+hDjFHnq4U0bD2yaFfdzZuEcma
	fK71pKDbwEe/Khy7ZUdx2H3mLSc06hw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625407; a=rsa-sha256;
	cv=none;
	b=kDzhwHtEyuN1ZXQLpcwoPJcFPAqJkXK3IZcPYVUUiOFlC/Ls0Gp8EtFKVrPb5Wli85If64
	ERW/F/S2nr962c1wK2qJKLQ/v9J3OBuxJ0o/EfIocG3cXjh5WKa70r9GAdPuGkl7tXIcRP
	XOi1/tNKQ22pJEMCIW99Q3nOk/Oo4LY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="H NjaJRt";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="AWz/3unk";
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id AD25FEC0040;
	Tue, 23 Sep 2025 07:03:26 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 23 Sep 2025 07:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758625406; x=
	1758711806; bh=gBJQwyFG/mBuy6u3kCYzOX5EZriO4heRBy+k+i4RgPY=; b=H
	NjaJRtpsVfOKdVDwAZnJREfeF5y0jmef00dfHEU6FnuZe78bUl9WNwf0tkI2FKgQ
	+MruUEBEyzY34kb50Ydfx1JcJ5RYn8ORHRCJ9+DgcUFB1Kbb070TrFo0bqgNvZFX
	hzt8q0ePr2H9tM8LhOZcSVZKKdDxWHj6GjPpXQMcmvljpdzWt5stgDB0z9WB1nqE
	3jAMak8hh8uNn36LJbKhWpl4Md9N8ldu0+6D0uSfCYWR5oHOj18hC120XehNWB6e
	cd0D44xEkHt5oAUyanDho/eDthOl/CAWOgFYGBacxHsVakfTOZ6+H+qSsAKJalEk
	UWfZQKTMpSLKb+KFMegIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758625406; x=1758711806; bh=g
	BJQwyFG/mBuy6u3kCYzOX5EZriO4heRBy+k+i4RgPY=; b=AWz/3unkIPlNecDqF
	gsNQmFd9BnXD+PgyKYnbcxwCMQsGZFp2dkrixlckj8stfErNX+hchm7Roydn5PGA
	gOUmYrtngnlasCs0ua9uisXOnkZC09TTscIx4B/pnU6q7uREzHCXQ8ZKyd0Shdks
	mpaZ/EKB1IxlH1fr/has42Mj4zB5H4/nCsPM2nrFF6eUuPj8rdqKDqSzXn0B4Yel
	fNCMSlg/XO+5qnZ0x19UuyJ3Kx4YBhRaZxmQ+4s4XwAR2zEn9s1oC8Sqds0O61k7
	yrF7g+KnIrG0ggu7yLm22yiSc+XWMsrTlDbuPuNhKlsNZaI+ANTKTEVd/mOa83fn
	BlYig==
X-ME-Sender: <xms:fn7SaHwasEwXoM51YrHZ0O3f1ukBfW7kZ1CnlBbPnbQiWy7oCeEl4g>
    <xme:fn7SaLNtWxovas7NVfQhLMN_Qtp0_dPIabtA_l_8PlgghAGYCrFwnHwvy18nlKybf
    5EjNbU9gWu_FEOZAftpiWOZCBwa3eCX3pQAXpiUFLe3KuqFxK8KGmk>
X-ME-Received: <xmr:fn7SaHcjYnvwJEXtb1uuGrlo2neJ1njXEbkt_vBq5tIIGOguXN-gqCXz28c_ew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegveehtdfgvdfhudegffeuuddvgeevjefhveevgefhvdevieevteei
    vdehjefhjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilh
    hlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:fn7SaH7c_7p_csMIeM9cnpiD6GpokB9xj1XZG9CSdzBQM-aRrhrNFw>
    <xmx:fn7SaHLI8RNNBEClF2-GcL88x86ItcfpAg0biZU2wxfNo15B7XDqqQ>
    <xmx:fn7SaD5gSfoIsXsAk1D22_vGgHcTybTdzU9vfMS1a0_poan3CM35Cw>
    <xmx:fn7SaObNfEVxrcxUDNs88YxZYUnTy_S7p4aBjs15w8MCL8TMbgew1A>
    <xmx:fn7SaK15_f3E18R0L66AyktqPKQzL6Y7u30szSUltkfRrVB9QLwcvu5Y>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:03:26 -0400 (EDT)
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
Subject: [PATCHv3 5/5] mm/rmap: Improve mlock tracking for large folios
Date: Tue, 23 Sep 2025 12:03:10 +0100
Message-ID: <20250923110310.689126-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250923110310.689126-1-kirill@shutemov.name>
References: <20250923110310.689126-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3F58D1C0009
X-Stat-Signature: fmyhpdyg7n9d7ppncnjb83ojjd4xjb5f
X-Rspam-User: 
X-HE-Tag: 1758625407-266515
X-HE-Meta: U2FsdGVkX18ekp6KfZE72Kfu+205ADdj657UeuH40JXMLssrwvi8iYVXHXDNG2y2x2Ou5j94e0Pg12L86z2yiUfVeHGMDa7lWE8m11V+k31BoM3hD8tdYHxDVtluKxzeFkZZsso343ev9P+bCV4J7HlgNhZyss6OSxo5dNeILh1S7ZehE9jMBK+2eGIRJ3Jofhro1QzYpUkDblWdto7k3PIXL4xSN5TS8WnJcmsXyvYqSuZGNhqXkQSQTXf66C4cOp++O2XNsJNzet0B9xFiTwm4IFG9g5Wcr67Y70fTuMIo6XB3GF1he7xPmHdt/8CVal9XaL7l3ctRMLAcLBR2xp8d4kU5MGZRrbEZRXOdIj8X5gAy4mcl5flPBu8MnZM757Xlsy3ZRaMWSxyZMuzWZoTYPwpVqv6JxK2/gkYvrO1b90K8RCJ4+KLssjUJIGmrOVZb5J0qsP+3bW5y6Rob0qEbm8nr7YyGf+/tv6UKG7nXxF0g4mz81V/H2KXuyo4URfXw8nnYZ7gAPXtgMq+yumkoCgQLdu4CIQ+3Df4Jb38V39JtYQRwSahfrzak+BkRk4SRKgqcEIQLjpFbdjsIYYMYZCk9mjToPMt+enasVZt+WS70o1XpEV2lUZQP2LCu2xZxs4OaN0ZTeyDDfntTE1t5OodJcNp3lE0d5h5CQAJ5p+L1dx3JDSaE9pAX/mqQ22Ypy81fl3pJnyWY/kFTu5r/e8VZoHmpQUspTDKFN2FjpO0aarDsSUPCPuqiQE+K5PowFu75mQVOXGssEJJWdX1vyQm8txLROBE6PE45PFqsxAWRWlujmp17emzLqXv2OJ4qhramJvBPVadjkh3890vqCmKlAuJPufZFXZDHpgIEc0gMAqMyolzZxbcUhEsu2/k29RB2039YcA28Sc7TKfaJA7aOVBK20YY2QemSQheV3nHbuKu62c1TtpmgMDiL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The kernel currently does not mlock large folios when adding them to
rmap, stating that it is difficult to confirm that the folio is fully
mapped and safe to mlock it.

This leads to a significant undercount of Mlocked in /proc/meminfo,
causing problems in production where the stat was used to estimate
system utilization and determine if load shedding is required.

However, nowadays the caller passes a number of pages of the folio that
are getting mapped, making it easy to check if the entire folio is
mapped to the VMA.

mlock the folio on rmap if it is fully mapped to the VMA.

Mlocked in /proc/meminfo can still undercount, but the value is closer
the truth and is useful for userspace.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/rmap.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index a55c3bf41287..d5b40800198c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1462,12 +1462,12 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 	}
 
 	/*
-	 * For large folio, only mlock it if it's fully mapped to VMA. It's
-	 * not easy to check whether the large folio is fully mapped to VMA
-	 * here. Only mlock normal 4K folio and leave page reclaim to handle
-	 * large folio.
+	 * Only mlock it if the folio is fully mapped to the VMA.
+	 *
+	 * Partially mapped folios can be split on reclaim and part outside
+	 * of mlocked VMA can be evicted or freed.
 	 */
-	if (!folio_test_large(folio))
+	if (folio_nr_pages(folio) == nr_pages)
 		mlock_vma_folio(folio, vma);
 }
 
@@ -1603,8 +1603,13 @@ static __always_inline void __folio_add_file_rmap(struct folio *folio,
 	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
 	__folio_mod_stat(folio, nr, nr_pmdmapped);
 
-	/* See comments in folio_add_anon_rmap_*() */
-	if (!folio_test_large(folio))
+	/*
+	 * Only mlock it if the folio is fully mapped to the VMA.
+	 *
+	 * Partially mapped folios can be split on reclaim and part outside
+	 * of mlocked VMA can be evicted or freed.
+	 */
+	if (folio_nr_pages(folio) == nr_pages)
 		mlock_vma_folio(folio, vma);
 }
 
-- 
2.50.1


