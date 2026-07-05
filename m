Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32BF8C44500
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 15:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A190E6B00A1; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9DE6B00A2; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 907FA6B00A4; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 685396B00A1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEB761A0149
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:07 +0000 (UTC)
X-FDA: 84955174374.13.CF54E12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3800514000C
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fUGyteFh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783266966;
	b=F31ttX7DAVqMeJtShkh+hZ6JD8pwr3Bw76QzKnHwiF4erEocIuiSybftrAZTy6m1DU6ltJ
	svpujhsf5ahOBLao5B9w+3Q8MGfD3wjSBWSN87OKgKpRHQrucNTaYH32JvAYMQYfofZHAo
	f7H0tD1kSVnbc6YN/j7u0Wj+2S6ctek=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fUGyteFh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783266966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3unaNvAR5NVnY1x+9C1/8TjIcTr9Grgg5m5/eq+8dU=;
	b=6bWZFRPmSiLiCHWissIHSsjyI9VrZzZ6xi9okjEwpNAnTk1h4enhh9gVBNJ171wAtG/m8k
	F193B84Nw/Z07HxFIxJBqWRLjy3DMm5zld7fyyMoiz9ZPcfz1L6RHeI6q7O2rhicZpk3la
	Y3mZNdV/IbZpMlSkQsYD36Ge1SVFMP0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C228B6138B;
	Sun,  5 Jul 2026 15:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524A71F00A3E;
	Sun,  5 Jul 2026 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783266965;
	bh=Y3unaNvAR5NVnY1x+9C1/8TjIcTr9Grgg5m5/eq+8dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUGyteFh2fFAb5tcklBMBqW+sSALFuDj6SxZKu2jo3cvRKZf1pA5jHZw7RgpvGkrW
	 tI1ON6VMz5kJWdqJHhHACJfn2OwPEFT8kqisFBumpz4lVDYdeVi8wltxf9oplhbDbg
	 MVvsjYC8nqFvxCskefyzEV6gmdhcQCxt/VNBaADB+lzzG2ivwiQ1qtXtz4LIWb36uP
	 h65fQI7WkRROkPAfueCYWjtvCDo3br7IEzLSD+BDbqSpbSowY3KyvP+9fGqvuOIEzI
	 AnhobfgLS7MUYP8irYX9H5Wig6FpZt+0fb7gOAGmyDE1MMMY0QMURgfBRktF5KXHpz
	 vWrClZtl+H+zw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/8] mm/damon/core: do parameter testing commit on damon_start()
Date: Sun,  5 Jul 2026 08:55:53 -0700
Message-ID: <20260705155600.96555-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705155600.96555-1-sj@kernel.org>
References: <20260705155600.96555-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3800514000C
X-Rspam-User: 
X-Stat-Signature: bbwrdnebtyjad5w9p9s5833iw6k7tk6s
X-Rspamd-Server: rspam03
X-HE-Tag: 1783266966-527181
X-HE-Meta: U2FsdGVkX18+k9Xv71UoZ1YOShWaKzo54q30UXBHVq99UWYbtrk7+XTEJu+sRJH0TVGB8BR7N70uUrWa9B89hsr+oYfxUj0gWodXu2tDD+jEwS0kztxnnPdPCItQPv6GzYdxgG/gsb995Dt1a8MR45TPAe8AiFThxGo1tiP0pt3vrMTBFs0BzBSi1FLnKjVTAg8GNMqyppZl805q9p8KqpeaJL+va5uG6QN7PSV19BSOx/0pic5XmrgvOHLTVgc++dgNPlmNFBO9ruzI0x99yJyJBGSoR3VRJwyFq6Go+vEUp6V9RmPjmYM3OL47lMowN1vAKiMylZTqfWSw6g6cKfY443GwSMB2OX+ZeV4aFJ0ZhSdbymUDamRpJvHuQZs5q4FjAH/S/bmLYVVstltWdO+4O5mAAzqZO3ZF8MkTqETWmdfmNZCun8S46nyJpncNzHG4LVv2aqpW28+wcF1iNQ282ne5pewgyPQpR/O7BuXKp5oQe9yxJj/H+lVKPed3mD8yTZGO2L5dH0Z3peT64nyJjchjNZ+gxa4fNTKbbX+f/7kAKRVWf57B1iRMFbd+r6lpnMF5gI2PwIe8g5Md0UecGehJnu8Bcg4aw/SEabslUIG/EEZbXHDW9J9Senm7/n4mvFqVsD788T7fOiAqMZhlLOih+C7LLaQGTHpJVkOC71+eQt8SVIVuihO7xpp7BPA3c/5VdQGEbnUUacw9YLuWneXpoZTIZuIRSeUh3CO46Wo3/bhcG2erng6KioZZ1ecMZpJ8bSzg/ea6eBg0Cunyu0tVvKuf7zlGpVepl000bEE0AauKMY363e8VYX3KW9dyUcAft24XV7psj0Gxj7HSn1DOAkKx1/4d48ygitrsIdg3NV/kwzN23WokKF0bFPEwIZraQDwPkcjgvDkgaZ1X/0SCVKca8o1fBMylT0zLfq5N0My5TA+r7cCV6amSx8B/zLRSp1zLCQo8qJa
 khnEvS+P
 SvSUXbg46U6xbf0Z0A3dn1WjYC1v6DHJGHU45NRcKCQldjzTMlO4vrPNBERkHYsO+HIQcDsdM4reYyvpHg9Dn8Psb9jYlz6vaIYroWFLvVTVoQcl1p0B+ml5yDv657BDcSfsC6hp+z2LmVPPcZ2prJQLHWGX0pjSpurnuuKhTwbY4GRwNyn289Ix9M9G8iLPL8OWWAnA5o8XGsrdMzHKP6sD8vtDhpcaIzAK9ET92Wy4K4hOgpJN4pK2TVIw/86uJxJ9cJMdzVw7M8oIUXGwiTNoQbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_start() and damon_commit_ctx() are two main DAMON core API
functions for setting whole DAMON parameters.  While damon_commit_ctx()
does holistic parameters testing, damon_start() just believes the caller
validated the whole thing.  Embed the holistic parameter check that is
already in damon_commit_ctx() into damon_start().  After this change,
the callers can safely call damon_start() without validating the
parameters.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 018dd5ff80324..ca301abcb9ec5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1865,6 +1865,8 @@ static int __damon_start(struct damon_ctx *ctx)
 	return err;
 }
 
+static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src);
+
 /**
  * damon_start() - Starts the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to start monitoring
@@ -1886,8 +1888,16 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 	int err = 0;
 
 	for (i = 0; i < nr_ctxs; i++) {
-		if (!is_power_of_2(ctxs[i]->min_region_sz))
-			return -EINVAL;
+		struct damon_ctx *test_ctx;
+
+		test_ctx = damon_new_ctx();
+		if (!test_ctx)
+			return -ENOMEM;
+
+		err = __damon_commit_ctx(test_ctx, ctxs[i]);
+		damon_destroy_ctx(test_ctx);
+		if (err)
+			return err;
 	}
 
 	mutex_lock(&damon_lock);
-- 
2.47.3

