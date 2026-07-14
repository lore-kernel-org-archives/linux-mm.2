Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AC10C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77C4A6B00A5; Tue, 14 Jul 2026 09:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC756B00AC; Tue, 14 Jul 2026 09:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532246B00AA; Tue, 14 Jul 2026 09:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9AE6B00A9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:52:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55C788035D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:44 +0000 (UTC)
X-FDA: 84987522648.20.17568A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BF9884000D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXSHgfay;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTFa+hpzXfcfyF1zP3rvNz2Fhu2Cffg36gE6sioOaYQ=;
	b=tkZWISyX7wnuP4eyfXfp2g1JWkO40fOUGbZulJ4DJSZNMI4iMo9HpdJSp8WNNoA58Kr5g8
	uVHrR8lnikbgVvy5TWvHHFAGlYGIqdnAYWpu80U0KsnEVYBl0iw+kzH5fvl/qDZn7n/PaH
	HninHbRlKYOftX2hOXEgeuzeNZMScDs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXSHgfay;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037162;
	b=mnGlRtMDl7m07kuhGk3gNzhEQGGf7mMJiTEWk67jsCpuPPKlmO5yW8mca5AmVzyyY20VlS
	Z4lipZZLwfQ/3hZsw4L0ny5kRYTmds2oTLuyfcFKmUYpLSyh2mq2lyT4YPaVhR+iCPifyf
	WfCnutvqx9s7weyH0PfJudBiJJd0dzY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A8D56136F;
	Tue, 14 Jul 2026 13:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B211F000E9;
	Tue, 14 Jul 2026 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784037162;
	bh=MTFa+hpzXfcfyF1zP3rvNz2Fhu2Cffg36gE6sioOaYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXSHgfayZDyKOjxmFxTfQTlWYACYLOF1UShP6zz/S0vV6siNuJJPHalozH+s0r8YB
	 gwGVBU9sm99r4zVvNBWuJM1x8YMeYOjk52ctqyyS/FKv4mZVpB9grooZW1flRLiEvy
	 mZ462KChCsmiktOfOujR+u2hYkPpRwQrtBUN6GnKJ7PnCC6pzIJdQ4ATSo/4G82BVL
	 dhQehNgCxHx7kY4C9tgNQ7ADb73tY2p9BPVlwJWlzJh0yUwccX4uaq4PkveFw5beMy
	 cR0YFSEFjgDehYed2pJ1V7dCiy3CLqHNr/aldqnn1cGafOo/FkG2vJWlG/P1US5xCR
	 bXuLRqUFzMaJw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/5] mm/damon/paddr: drop last same folio access check reuse optimization
Date: Tue, 14 Jul 2026 06:52:32 -0700
Message-ID: <20260714135236.92699-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714135236.92699-1-sj@kernel.org>
References: <20260714135236.92699-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BF9884000D
X-Stat-Signature: bj4e1gdci7748j695zedrzkeam9fbdxu
X-HE-Tag: 1784037162-194859
X-HE-Meta: U2FsdGVkX18G0XkUJj7Faj5osB8cMX7a7mZVcte2pcVA0zs4WAv+oK3/dZnYHRPIdTQaFGxSSDnD6LwHGsGj1w1e8RPSIgpVQNektP665JE+Ez6G6GkwpJI+mShrKyLm54vwOVCLBzEG/Y17cK7lxraaYp0OMBmcLBBaALZjVmMZLDJSFXyDblA1qK1kJZdJTBg4L/sEbuMiPyUaXD/fXbqss64AwDr6tJB58HOhQu9RI5zQxkzHoU/6P32TwO8MhaSoVQDe15GWqMVqbn5CXBePsFl9dI8cfv8G4Djj8LH46loO9HLjjbdp5K0aSKY1adJeSnfNDzPcMsELReUVQlYrC4+KTGHvOzsEvJdGVfbJ0qmYYjZYOz19uSRdb7ZA4gkEOXMLr6f5RZQfr/SNGaxeDZcK6YPQagxEUswFrkOG34cxXjXSy3M1sPvjpKTXose2/6B0qFUrkIXhk5P7AonuypwKZttfHiHrmmQxiuB1YB13Kplduxwewdw6PtxSiQAwOiKppiUysFU0TYpy16nNrennsCylMSdStCgL3QQt+BmJNeNrZzteelzjw6PHSlq7HX/MR/EpbiL5+M7qDp/VEvEa+13tNQ+FF8p/nlYuYkquCd7XRO4Ryv/RSY4B1VndYck56YSKs7+obrxWO0IWsCwKT89dmNSZib3xOTWbFiwKSzWJRovKL6Xy2MvFiV9Cq5lTzaWXruTLh73J89HTZs+KrEC0SbGkkbl8BnFDntijo4FP/rzzjV4u+9ioMeHbL7AqalWyryo7JTtarNGCCjn7KcBcT29o8cpAqHrb2jskzHKFlFHLqWE2XQfZ5qc27A1s7NY5MyzUobbWNAMJu20hpdDTy1kdyln3T5ZLj9PvV40kg7sYnmTHh2eAZ9otnfM8nVEa24wWyCpKjLSO3XRq1H40A9KKxL0NtY7ZLapJv1Q6ukCOxkO1tCthtHdwhXeB/QStXPwUE/E
 YMN9c89X
 sr4q5mUeWLsR8ruiBOvyqw3JHwi876IvqtGT1E1C1XwyWgi7CvvbXTDAH/U/4N4JnVYkzAOJ4dNlgi4AgHOdYz8wXh+afVt5YxIT3I8xQRP//z7f6Enl/foYGlfwinnE1w98bh0QuCBjuz6CCA7zCzfiFCFik33WxyXgAcodJipXoS60qTmmfLzb25EJJYo+sREgnu6ADhx6jJPSn6iyJt80vt/HVXSf08LtKyh+qVQbhKEY=
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

