Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F523C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE426B0096; Fri, 10 Jul 2026 09:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431EF6B0098; Fri, 10 Jul 2026 09:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31DDD6B0099; Fri, 10 Jul 2026 09:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0E96B0098
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F60F1C3B55
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
X-FDA: 84972993168.26.1BA977A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 046528000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b/F5bCb7";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWM9ulbAfG9bosKr1Xo0BbZMoQtsvPUcnEqaGbAY52s=;
	b=vStQmmAxqZ9ptSUY/rOjWLGOtQtCNnPgX3vsy/awjJD9GcR1QiGxevSc7RUFlwuATlk/2Y
	FwzqpDTsJ47v8+vm3t8KE9Uu+vBlGnkq7YrMULuwXffEzF8HpZXsWzoukIxWm8zEWNxBKc
	x9jyCjEezmxzWd59YyLiOyytoWmeFac=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b/F5bCb7";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691223;
	b=N+Sn8/oS9qwIp2c24jnuZ/KxSTkUhRs7Jga5SS2/btnu1MoWlFbV1J/0auQrmK/LgNkyUw
	XyFFzIUz/gWYmINEl84ZoVtOP9gogHlsZHZZLCqoTFWWgAUqgvUs7flNhvgSVJZdtfiaw7
	Euw4uVBKjmjHIUUtwAAn0ibFC4DLmas=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1BE46136C;
	Fri, 10 Jul 2026 13:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348DC1F00ACA;
	Fri, 10 Jul 2026 13:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691222;
	bh=HWM9ulbAfG9bosKr1Xo0BbZMoQtsvPUcnEqaGbAY52s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/F5bCb7VYRuB7bxQDZbwQQlxBXciGRSeXazTLmsH/ZOAOJOsHvu6/QW7zMBqocSp
	 rt3TBZNIT8kUV5m3+I1BTPJ3zlm4ERceNclzDkvP9BlKOSR8+WvMeGPBzjJ8/nwfk8
	 SsUFWwsk58wAdCp2g/m4zVoKc5h3QJMnCJrChahtxKh2Keu6mYFoUv7ylZKdnjhVPo
	 Uq1KBQh9LQh8TbC8GVUu7r2uNrvHJqL+Qp64vHGOTzybgLaMQdw28acReru+cNfvek
	 pphtVbLdXvHSUiOSkt4Q2QZksFayQxu39j2Yb3DnUONzlcoQHIqYrpwUr1IhGOLmcU
	 6dbh6sukxcINA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/19] mm/damon/paddr: respect return_max_wsum
Date: Fri, 10 Jul 2026 06:46:35 -0700
Message-ID: <20260710134651.18084-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 046528000D
X-Stat-Signature: hs6m94omu1tt84qxqoxet583iscbp8yz
X-HE-Tag: 1783691222-464269
X-HE-Meta: U2FsdGVkX1+FfoiIrJB4r8bfa+tHT1EHaUF7enVtAymHJcXTez6/Aph4pBQNNqYlup5Z5DdAJqdD3DCpwcsq1CathezhjXY6dR9qGj6PU0FogWr69cEMaUFSue515c+ezXwDrS13UVVIyM2t4Y1EA7ZwF0eHdRAA7j5BECJHu4bU8AUKyfJJBRHdA1zUnU4f+gA4JGQoDZZA/QJp9jEPl5WnUm7oljrQV2zZeYc9GL+2TnFkqCKsFFvlDvYT+f8tpkYfl7SlFTNWdQFOuU98ziX6xarehfXbGBB/8rrcxuAjLCAF04o+uBWzXsBH8JEPAjKhupP4ki31bYzz8Lqq9fB3aXWbT5uDmJZvz9ploDH8n5/xaj2j+LImwi+RT/GpragudrTDJydo4iHp7eRh+yrJZHAT668cOVXDHVaJlgemQIocjntSud6/tOnEiThaiYbnHa5/pTplqLy3arfEM0RF7lYy6cpcYW480g73icFp/xU9rTE5QrRRdTPTtWz0aPdV5Bm3tVqMRWkjknEbst26PGQILQ/39fQuybHF3ObeYPld0+zwoovd2SuGaEZjeTdL6PJ8KijMerpAz3Q2Qmj3/dSLWgQepQKWwoY3N1ToEgKFLHZTdslCrpsEXeuAyh7Wl5ZExP4r/wkOKjKWd2tXnPN3Gxw7YL2KBz5jvs31yqFO6Pt0ZBBiNIfyLJpptPtlz7q7ktirUawoT3vnqte6zQhyrj8lsqbuB3/Y1cWigU8SliA6ziU1bG4JuUvUI2GFfaSG+aLj7f5joXLhX2kRgIOl/gWEyP0eJKxwwpW7U2F6N6/g+SdKmLMmy96eCHTe1BaAdYHONL6DRh8xFup2fE9H80fWt13C96KOCyve9eIVlUzAcmYlWpVxiSFnIPz9UtbujReWpIoo6E3eNGJBLFkBX6SenxXQzyNg0ug0hLZfhiSnsTSc+nKfrUCYn+ls//p9U7nA5VdjUB9
 aniYMyf3
 ik4httJPRrc680nZEGvEy/HZ1nfIoKVI0rbUL+rMs6tbzMbdlYgxlMYqqhCbm1nWWI98jyAKFz8ZSZy5sWynDuOUR19lMMbUA8RD3RNjeLc7MoH3wfX8RPtkAxWC9dJtAFsGxUt/891bZdsVySA+jNhfP1cT2B9KdwK3zmt2NL57Sx6h5GZw4TFPwjww/gKEisAvK3KpFWNsz9KLZKOS/LuYo+kR49y7GwxFUPSThJTGTTGJ6V/JtREoGp0+Ucif3gXdrmJP6ZXdb66VTeLb1Ba4eq4mnA2Na3+sgBJPqX6kcXTmgeHvIVb6QFgMon7EMdJoXXXZ85N+man3yOCbH3RRVAo8NvEYfxwcw0i6Old9Hapw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_probes() ops implementation in DAMON_PADDR is ignoring
return_max_wsum.  Respect it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 3eba3564a31fc..b85f88a7a38f4 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -172,6 +172,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 	struct damon_target *t;
 	struct damon_region *r;
 	struct damon_probe *p;
+	unsigned int max_wsum = 0;
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
@@ -182,7 +183,6 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 			if (set_samples)
 				r->sampling_addr = damon_rand(ctx, r->ar.start,
 						r->ar.end);
-
 			pa = damon_pa_phys_addr(r->sampling_addr,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
@@ -193,9 +193,12 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 			}
 			if (folio)
 				folio_put(folio);
+			if (return_max_wsum)
+				max_wsum = max(damon_probe_hits_wsum(r, false,
+							ctx), max_wsum);
 		}
 	}
-	return 0;
+	return max_wsum;
 }
 
 /*
-- 
2.47.3

