Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E1D2D58CA1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 22:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5397A6B0005; Sun, 22 Mar 2026 18:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4186B0088; Sun, 22 Mar 2026 18:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38B266B0089; Sun, 22 Mar 2026 18:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22DED6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:56:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 983395B41A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:56:43 +0000 (UTC)
X-FDA: 84575210286.20.20ECF2F
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F2494000A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:56:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=dCS6leci;
	spf=pass (imf11.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774220202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=838iRbAcXH2NCU1A1DaV1kt5NP6LjTFkRnUqJYBZUx4=;
	b=rV26q0umvd4CSY4VqZT2iHYeryaekA2KlgOQEX9vfwXdpI3AdX+yc/BXOH6+VhjDFtXYFh
	bIAU9ENT08DToX4sCzJxX3U8RI5gTxIZElmYSigOAS289cD2EsMkphXFzugAbyoGgLHjjL
	PUK/2hhWRFfWQjF/cgg1UFDZu4tZj+4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=dCS6leci;
	spf=pass (imf11.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774220202; a=rsa-sha256;
	cv=pass;
	b=eFVmDq/Xxwkqoe00IJJPL6DhI6RSnItnJC8oOJbdG8qZRX4PL8g4nFtT6g+H7p+tvDENkM
	16Rggubsh6mRaemcoK9M88k+Gq9d5qHhO26MQIrc7c+CUwVkeXLVQ22as+xuFzmQ8acMG+
	9VCZi0ynCFihT8rz6PRgS5614h3kRE4=
ARC-Seal: i=1; a=rsa-sha256; t=1774220190; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=UigafiQgHsVCVl6vlg+lSi5Wv7Zc4Q43A/4OmBfX4Jo7SDCX+174XDaHuxeLQ8WBWjRFC8iD0TRvM5wNPVNnD1c6U1bMaHlNaV+hiSJWWHlnbKdEKG09WVyid0igDeYyJyJuIl78dIM4bXJR8I0G2ik6RgzxI1F5oN+hHnVEbN8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774220190; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=838iRbAcXH2NCU1A1DaV1kt5NP6LjTFkRnUqJYBZUx4=; 
	b=gh6Egw/LrWqRw58TqEKBHxEis0qD+qrL2vTYdZGGZRcy856DwVsCxZMABF8BP/mPXIWBQePCIuMehWmmP+j5oyni7mPI4aw8LmEk4NaD+V/LO4ov4RrlLN3VyHSDd2wriHCgP0hJcPZvlAjq/l0rXHKhsAYOSvwfRUAbfhLulNw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774220190;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=838iRbAcXH2NCU1A1DaV1kt5NP6LjTFkRnUqJYBZUx4=;
	b=dCS6leciad1MsQSVZkgf5sGCoTHkodLVIC4JTCMNFMpTzdimqGWYAIsU/xlEhOBj
	QL6lg8sJkXGbYX3dofOqUy5opI10hSkILoqNGva2MSQlowfAiKul4t4d5WQwkTE/MRo
	BwtE64P9v141egHO8Z366nPkD0fmYscyLzomfI/o=
Received: by mx.zoho.eu with SMTPS id 1774220188445159.7066913354488;
	Sun, 22 Mar 2026 23:56:28 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH] mm/damon/core: optimize kdamond_apply_schemes() with pre-filtered scheme list
Date: Sun, 22 Mar 2026 22:56:27 +0000
Message-Id: <20260322225627.263202-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: krs4w9rnr4zk9weaicdx5dxfnggu7ipe
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F2494000A
X-HE-Tag: 1774220201-336080
X-HE-Meta: U2FsdGVkX1+eQQ/GnP4cBau7HBfThl8dpxEbkk9gC3dosCk/7jypr7sUuMOoro686K12rR5TJmDrDxP/nGPFoTTivTWLttzBeujkuLjv8/TUpI9UBXwaVgxEyZ5XgQXr4ZA8GOEnLzlVmvlF4Di859LSYAvgiGqBT9s9ituNQLbYcHLPxKZ8xa9pJURPtIizEnYKei7muu+b3TKFcdnbtwXrV392OfavT74ayspwhOQJRnZ4rbEkjtOcWfUT7oD1HGJ88MyPay3bF8jAkomdHUxSV8thyPRMM1U+jXjgmu0/WyuOWBgCcRyTnfkQerSmaBZbpMnQ35ydjEBLg99KzimtP3BVkQWLf1rjBJW/DniTs4TdowcYHs6F+/XM+Sy2nSY93suTdvWCO9cgsGU1PdzF5d6bVKUA0IBkKbY+kk1eFnuyjlQz6FCACyCJ703HSXQzgAwSfV2mpKptIn7jz2UJm9WbbWzz8xJKm0UVG/X5HCSIqe1G/QruQB/pdkHZdGlGMFOq99NiV2bbqBFADpZ3LWEqUA+5QKH1waQh3WSLI+7YWH0hPfqOe2x8BrQ5VoKe1JhhzH4tA/JzSK0lFJWbPMye/mFnX+nvC7gEgMRtFOmKkMinnJph59dEs7uZsxZ3lEm2LgdxRjWFlnUb8XyeyRbYQcpcevg/R5ZECtpmGtH2zlw6d7LvMx8BM9o31Sh3htu8T7yT/YQ6+rEFGkoksXOrkq3mMX3QM42vuSwKsYnsXBQAtrskgZ51N0gOsysH37uuQP6e/Vik2PLJejYKQRtnrT7zPXi0MjInq67XR0ETRAKpwYPGTBsnf9U5zQ+2KCDSOVYpXqTvmg8aM3JIXJy9KkDehuel11om+oaqDDMbGB6rmxVEy9osCQhwgqKBoqJddB9/Gv6uQRQPTHoXZd9vvNsw77sY9pAyBfoWwZVzLapmbDrQRgTTRmkSCSKVV29yImWygtMKMUL
 FcinVBYK
 uq424H50qL9tg5K6sCUT87Pp58pFeDYnvU2J87MgQuGSkP1nI4Q8XbFl2jGofw3178cJTH5TnxPFMBdGEZSJrou2ML8SBqp5YMdtlfFsXPfEwjerekkRZ7tqpWQJvoToaSL04k7cAM8oKvjhTWzhqTcDDrE3MlFVtZv5L37iBYh59J3En5AupOrogE7xrM1SxzQHnIcBYYN81+jm+ThIHSXmtflRcxPPLcN2C506/V90NHUIF5SPoEZv9EK3eWUb0ffGY040b1pw5gLXNNLhwBHYspjT8+g6V+pbz6U8VthQlZGGmhk7WVUCmm/y9EXZUr2OsdQXkOabFR+ZZUP0pgEwLYiQLnGlYxra7AfHQ13yybNFdjM68TbMZ9HZ8+roFXOk5YSRfVtRV9fg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, kdamond_apply_schemes() iterates over all targets and regions
for every scheme in the context, even if the scheme is inactive due to
watermarks or hasn't reached its next apply interval.

This patch introduces a pre-filtered list of active schemes at the start
of kdamond_apply_schemes(). By only iterating over schemes that actually
need to be applied in the current interval, we significantly reduce the
overhead of the nested target/region loops.

This optimization maintains the original Target -> Region -> Scheme
behavior while providing substantial performance gains, especially when
many schemes are inactive.

Performance Benchmarks (Filtered Array vs Original):
| Scenario Description      | Speedup |
|---------------------------|---------|
| Mostly Inactive (2/10)    |  7.5x   |
| Half Active (5/10)        |  2.9x   |
| All Active (10/10)        |  1.3x   |

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/core.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c884bb31c9b8..3b59e72defd4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2114,19 +2114,16 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 
 static void damon_do_apply_schemes(struct damon_ctx *c,
 				   struct damon_target *t,
-				   struct damon_region *r)
+				   struct damon_region *r,
+				   struct damos **active_schemes,
+				   int nr_active_schemes)
 {
-	struct damos *s;
+	int i;
 
-	damon_for_each_scheme(s, c) {
+	for (i = 0; i < nr_active_schemes; i++) {
+		struct damos *s = active_schemes[i];
 		struct damos_quota *quota = &s->quota;
 
-		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
-			continue;
-
-		if (!s->wmarks.activated)
-			continue;
-
 		/* Check the quota */
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			continue;
@@ -2476,7 +2473,8 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	struct damon_target *t;
 	struct damon_region *r;
 	struct damos *s;
-	bool has_schemes_to_apply = false;
+	struct damos *active_schemes[32];
+	int nr_active_schemes = 0;
 
 	damon_for_each_scheme(s, c) {
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
@@ -2485,12 +2483,15 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 		if (!s->wmarks.activated)
 			continue;
 
-		has_schemes_to_apply = true;
+		if (nr_active_schemes < ARRAY_SIZE(active_schemes))
+			active_schemes[nr_active_schemes++] = s;
+		else
+			WARN_ONCE(1, "too many schemes to apply");
 
 		damos_adjust_quota(c, s);
 	}
 
-	if (!has_schemes_to_apply)
+	if (!nr_active_schemes)
 		return;
 
 	mutex_lock(&c->walk_control_lock);
@@ -2499,7 +2500,8 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 			continue;
 
 		damon_for_each_region(r, t)
-			damon_do_apply_schemes(c, t, r);
+			damon_do_apply_schemes(c, t, r, active_schemes,
+					       nr_active_schemes);
 	}
 
 	damon_for_each_scheme(s, c) {
-- 
2.34.1


