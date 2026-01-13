Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C36D2F339
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F326B0095; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE99B6B0096; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37BA6B0098; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 96BDE6B0092
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6752FB6AC1
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:34 +0000 (UTC)
X-FDA: 84327320028.26.A454E15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9CD72100009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYeyIAc0;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768318052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nnBRSlbJMGAL4L4PuDSqVevARFNVRN+2okxO+GB2hc4=;
	b=PWonHMwYjAnkVR43/tU2xa0PaF71foCXDoFpv8KFvOGM96IYbtYDrCaO6Q0PhWC1Bso5rP
	nb8MLOV+kbTuOVFrheKMWpSwM2FNooBwJW5plgSZFEFvYol4285clZh/13zTy19m/NryY5
	dSPfNV5EesJV4mljPFFj/SFDnaQFXLg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYeyIAc0;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768318052; a=rsa-sha256;
	cv=none;
	b=VWWPntHJdCGgAIDEqeP69lY61N0cPUKI5TVqOrT8YHI/nPdidWvGny9Ay6ZuHfNlK8R0zA
	EQHzHiotbfePQx1T0KOj2dv4h18rggfOgDl38NbCm03+7BEwxXln16dE67F8bF7WOODVne
	ySI29ue3LliNVotG5UAfThSLF/EzuGY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C515744400;
	Tue, 13 Jan 2026 15:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812C2C116C6;
	Tue, 13 Jan 2026 15:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318051;
	bh=F7+1XG5LjId9vgDKAd+pvaqjxO2poIILsvjkJM5g+64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYeyIAc0DPPpy3z1Rl+8ig1Nyu0ySouQKyf6phjuEuB3RGheVTYUKbsvTHuTPDbmz
	 8aXf2v1J9bYSbGQyX3xR/g3cZIr4+ecuI3pAVK9JB2E19hYEVwytMRHmT7jadC4lZh
	 le0SJ31b3yfaNdvUhND+LOseKXPoiSYG29BonPklsL78TldIy1YGleHzemv41TvCmq
	 I/7Z1bcyf+tggipDawjvytAsszupZBKu6jrTedzFAub5n97J8xrc1h8M6ZM5ex7GT5
	 jI0Y8b709XpJCHtIalPaY18mdwJV1D4wSjkN77ZSd7DXKwYePkiYAO14j9X2d0LiT4
	 BXWifBme6kvGg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/11] mm/damon/paddr: activate DAMOS_LRU_PRIO targets instead of marking accessed
Date: Tue, 13 Jan 2026 07:27:09 -0800
Message-ID: <20260113152717.70459-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113152717.70459-1-sj@kernel.org>
References: <20260113152717.70459-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4kqk3te64twh85o8s5xw6qarhaz1cpem
X-Rspamd-Queue-Id: 9CD72100009
X-Rspamd-Server: rspam04
X-HE-Tag: 1768318052-221352
X-HE-Meta: U2FsdGVkX1+SbjiWe3bc1uk/Uqj4C0E1ZTOanJnNkd3GJtHqqS12dVPejSavo+1C33nIRFm6mnCOTpxRHHjyIa3HMP60Ra/eIB5rWMQmUgUeuOwEhRq3rUSZLQ/b79kixW9jjVDi1Eov9wAwFyP1wszPnPOpbcR7o0PQHWkxkoqN57xRFLWv65zsqMVJLpYxBlBOJ+fhk4uhTQhA8G4hyZoPpq4h+ULTVIpPZICperL43+9L3ZDsrjx0W5uaz0XDcDtSF+n99kMT4SD0srgtJaEN+9fD8HcoUm3WSTm5Vo3+VoceMBxPTlTQNYOmckCkhg476DioP/h5I4qBdq4/vNRBBhvVPIJXzpIKQGerpdSVomFpqA0JiPPK06EZEajsdzySyz1uEFkhChA6LGoKkbrCM2WDyTQ4akgqU8ua2EJGtaJBHyuRCGsecmnne6A+FGBmfHc/8q9/9EPzGG7ef8VN74UUFUdWbiXweBILEzoQZXkEMu40JM6Q2luAYpec/1EUEf23IjxYcojbhuqi2X5cAcuQdG0C8VKJDP7QcXzF8aa7g23ZsrtqvpwbxDseTx4C/PoXgExPdG4J7KMTtunXCaQnnsF7layeu5SQLaeTQfTlT+YrsQF9Uu3Yfb11dlpL9iNADvZj8ri1UAL5x5RhrRmKUsK1Rkcqsb4GQyrPcUdz8liemELGFpSS4diUX40YZUc4yVecUY6I2WclB1HyA4zXRqQg6qeaNThUQhRqldMwM5aIpFz9GiVnz6qLt8m3xjDc/HxFy9912/4oU+qxSnV9dJWTiKDWNBgd3WPwsgoviKdBmu/atWAQcjDr7uWmRnOXPAXpXThTdFvGjrVpzERDBMGyxjkXg96PRxX5w7hV0r2PKomFNs/jZ9JqS78PlRK2jZ+RuKrDIz8aNpOQ1MMRdjHoqyDiW1bfJtnFsxYjGfsDV0jnRSlgKajJQy8GBSvbGJYKcV8VB7n
 Lh5CBeIB
 x+B2XEYvTul7Q5HVthq/ObDyUwYyfzCXd5uop5Oh8C7gzM7HLAy/oV611KJ6Fmb00dZEA+6qkEYmQwrapZcaG/MLlhuyftkFvANKfKk2lwvff9SSD4pxcAe8PCq6fTFz/i+W05MRpfUWMCsQOcxWIpYtRttDYfuTKAXQDor3Vox/AoqmFIH9Gl1BO8+5pI990sz2P8hyD0gx6egKk/6uWKzgOSWECk9V3K9F1Vw/oYmVI/7dCCwZ9aSylHdh+Sn9eZ1TqNvgfc52Jdj2fGVxGrUTU1/9RV40XciNq8IZWkl3zfVA9SYDQzbxdbJdZ04KyESPn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS_LRU_DEPRIOD directly deactivates the pages, while DAMOS_LRU_PRIO
calls folio_mark_accessed(), which does incremental activation.  The
incremental activation was assumed to be useful for making sure the
pages of the hot memory region are really hot.  After the introduction
of DAMOS_LRU_PRIO, the young page filter has added.  Users can use the
young page filter to make sure the page is eligible to be activated.
Meanwhile, the asymmetric behavior of DAMOS_LRU_[DE]PRIO can confuse
users.

Directly activate given pages for DAMOS_LRU_PRIO, to eliminate the
unnecessary incremental activation steps, and be symmetric with
DAMOS_LRU_DEPRIO for easier usages.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 7d887a3c0866..4c2c935d82d6 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -206,9 +206,9 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
-static inline unsigned long damon_pa_mark_accessed_or_deactivate(
+static inline unsigned long damon_pa_de_activate(
 		struct damon_region *r, unsigned long addr_unit,
-		struct damos *s, bool mark_accessed,
+		struct damos *s, bool activate,
 		unsigned long *sz_filter_passed)
 {
 	phys_addr_t addr, applied = 0;
@@ -227,8 +227,8 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
-		if (mark_accessed)
-			folio_mark_accessed(folio);
+		if (activate)
+			folio_activate(folio);
 		else
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
@@ -240,20 +240,18 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
-static unsigned long damon_pa_mark_accessed(struct damon_region *r,
+static unsigned long damon_pa_activate_pages(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, addr_unit, s, true,
-			sz_filter_passed);
+	return damon_pa_de_activate(r, addr_unit, s, true, sz_filter_passed);
 }
 
 static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, addr_unit, s, false,
-			sz_filter_passed);
+	return damon_pa_de_activate(r, addr_unit, s, false, sz_filter_passed);
 }
 
 static unsigned long damon_pa_migrate(struct damon_region *r,
@@ -327,7 +325,7 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_PAGEOUT:
 		return damon_pa_pageout(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_LRU_PRIO:
-		return damon_pa_mark_accessed(r, aunit, scheme,
+		return damon_pa_activate_pages(r, aunit, scheme,
 				sz_filter_passed);
 	case DAMOS_LRU_DEPRIO:
 		return damon_pa_deactivate_pages(r, aunit, scheme,
-- 
2.47.3

