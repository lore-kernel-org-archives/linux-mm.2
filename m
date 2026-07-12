Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D687C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 17:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FF76B0095; Sun, 12 Jul 2026 13:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3576A6B0096; Sun, 12 Jul 2026 13:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246606B0098; Sun, 12 Jul 2026 13:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F38D86B0095
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:03:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7336F1A09A4
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:03:43 +0000 (UTC)
X-FDA: 84980746326.20.F092942
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E5F7740008
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:03:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJ5SwUQU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783875821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTFa+hpzXfcfyF1zP3rvNz2Fhu2Cffg36gE6sioOaYQ=;
	b=NsNqPN/BryhuGxKGiyCu42B2CgU40Or5Ix8FbmOTOZUB0hFSuh2GyW22d814rlJdyyKsFA
	qfseQ1NsqzSMdL8dCZqXhKUbEDh6+tw/lgMmNq/l1w39R2S6z6fNJxH6MHP1Yr1ZOt5jpl
	QJfd7xiF6+pC3XDho8DF28JBDboSD4E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJ5SwUQU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783875821;
	b=v3f7N8S12Bzyi4QB1x4kdv2p3PySj4rgyG8r0rXEKBF78x2D9wi9+8Zpe97MLbpWpLBI1j
	MVPv4fJMCn+WCyCXSFDHUFbSHgwCfI+kuJhO5N+rB+WCPz2H+kleUVuY3WH/I0aisOfNiu
	jSoe8rxs9GYXav73+sqzOu3tPPpYUSk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7345F6136B;
	Sun, 12 Jul 2026 17:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCA91F000E9;
	Sun, 12 Jul 2026 17:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783875821;
	bh=MTFa+hpzXfcfyF1zP3rvNz2Fhu2Cffg36gE6sioOaYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJ5SwUQUrhliTXVTQ0gJzeD61a0JDOTHv2z0xzqoAS/iIA7hQdL75F85oFu1rSFjh
	 AYPVpug0uM99scxME/UG9d4esLNmi8/IoZ5S6F2kNJpXfQS7w5LXdpbTnyGIVnuJlM
	 +bRgjKl1KHMomWUhzJRwLtgez/wsaYpw2gppJS2HUB1M1jjEQ6jWDLA8/balgdk8A4
	 rEXdxh4mvVJRGXDjRKrBWnOVKAay8Qjez3OnN8Xjklw0Ytkj3wPkaR0452C7oymyj9
	 dBKoZ93RLxUnM7QwPhpx9jXI9Qg+fBEdHHQdAf9P7ve8UARAmyblwkp7IETnAt3h33
	 BAZoFhohdXLHw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 4/5] mm/damon/paddr: drop last same folio access check reuse optimization
Date: Sun, 12 Jul 2026 10:03:26 -0700
Message-ID: <20260712170328.91144-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260712170328.91144-1-sj@kernel.org>
References: <20260712170328.91144-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E5F7740008
X-Stat-Signature: pjjuqd567axyxkidbgsktsf7ko1tjqi3
X-Rspam-User: 
X-HE-Tag: 1783875821-844776
X-HE-Meta: U2FsdGVkX19i5FN99g5UDxCAWYV7Ax2B4Er5THj5JHBm2Auaf5OeCRQbH2TAXtl0L4oohSP2pcIMoB9EqbX4oJtTpbK06B6fSEmnGl57+gus/cU2g5XvRP3MJn0wtMTsRE75B++GrGM3EGPXY4YOEbek0d+qjtCbfdrviEmli92xUNKaT9htwqgNpyUOaj6qV7tMnCQwGbCtq+tLkYVFOBMcBYTyI4jW1PySsQWTRw8amzyC/7ESRWYVFB8XpnJETuiFNc3dKyg4/QpU3Cs0oGoxoyDXDpTFbARhiw06sZMhLF1U4W7lfgwxAIey50fXPZb00IZEirQQ6Xa1y7N/DiyA2ahna1l4QZcORKVLqjhWQ65BDXHMdldYPj9PtGMJTChZWZ04wOWENZ3KdF3cwaJOfyRx64PVWi079O+5P9SzI5Tj1ZFhEgLzWbDPBOtCykZ4OzFodWkV7gAncoBklvCmv1VqFG73/x5Vj0JBXcFqs4K7V19OwkiyanzRf6sMVm6RzUfkU8TenaHzKF+O6kYcDkuOmZ0GrfOi6LJtknM5hNN5txTTWSD+zY4WRassRLO3mnPVW2R1D7GPEx22nbP2wy1VYEbtwLt5QGdqEQ+n5aQ2lhiF4NO4p6JaqT/eU8jk1Z+0HFtWjV6OTlYtyUJVFml9KzvZsMe4W0gDVX80fdRNL3uLVhx/W3vmjlWMIq+PXgvCdM6pS9L71yLyceWj2ADPgm5QR7bfH2uUPf16iitavX1JF6Zi/zo6gGbS0HQsctEYhzMH116/Wka9VK/Mcd5Ywm2mWcFHwtTZaZe3oFdCZAOyyerP3HNOLZvE41NzbpRv4XkQpmyrV8kQbUiY3H7BelAGDkhtzXJHelmMjezm6gVOxZ2QANv9pjgAhRXo/gNUxpIdpbU2rmhd68FtJcfm0UG3N4/pP2D/+r7CGHnBaDUCq5WcV5jgrWgtGLA6jAw+Obw/e4GFoS0
 sxBPoGcd
 T+x+rNESiDfOUPHhUcYnx6qOCdAVH4NZHrEYW2Jn9H3dKX2RO1IZMA38gtxpSYodgvT9GiiaESh1chmA56GSCYFIN/asdfZZ/jD9hSrfS5cff2K4aBDtZQTRAJokT0f5VgQwRlPG8jjJhFDM5Dcmxg7dhR+xWJMhqPPexegmYZvwdxLjnSziEivEUy3h6NYpHLe9tKe4EaCh734/UbJwfod6VWi65DKcjhGbIcAO+okZ8pW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It can race when multiple kdamonds are being used.  The problem from the
race is doubtful, but the gain from the optimization is also doubtful.
Simply drop the optimization in favor of code simplicity.

The user impact is doubtfully trivial.  After all, this kind of
interference can happen only by intentional user setup.  Even if it
happens, it will be rare, and the consequence is degradation of the
best-effort monitoring results.  No critical consequences like kernel
panic or memory corruption happen.

The race was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org

Fixes: a28397beb55b ("mm/damon: implement primitives for physical address space monitoring")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b85f88a7a38f4..e4f98d67461f5 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -65,7 +65,7 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 	}
 }
 
-static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
+static bool damon_pa_young(phys_addr_t paddr)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	bool accessed;
@@ -74,7 +74,6 @@ static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
 		return false;
 
 	accessed = damon_folio_young(folio);
-	*folio_sz = folio_size(folio);
 	folio_put(folio);
 	return accessed;
 }
@@ -82,23 +81,12 @@ static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
 static void __damon_pa_check_access(struct damon_region *r,
 		unsigned long addr_unit)
 {
-	static phys_addr_t last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
+	bool accessed;
 	phys_addr_t sampling_addr = damon_pa_phys_addr(
 			r->sampling_addr, addr_unit);
 
-	/* If the region is in the last checked page, reuse the result */
-	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(sampling_addr, last_folio_sz)) {
-		damon_update_region_access_rate(r, last_accessed);
-		return;
-	}
-
-	last_accessed = damon_pa_young(sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed);
-
-	last_addr = sampling_addr;
+	accessed = damon_pa_young(sampling_addr);
+	damon_update_region_access_rate(r, accessed);
 }
 
 static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
-- 
2.47.3

