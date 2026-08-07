Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EECF3C5AC9F
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA4336B0093; Fri,  7 Aug 2026 05:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81256B0095; Fri,  7 Aug 2026 05:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BC06B0098; Fri,  7 Aug 2026 05:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7FDFE6B0093
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:35:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D220DC0342
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:35:40 +0000 (UTC)
X-FDA: 85073966040.05.EF69D28
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1376640008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:35:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ry6KOkwv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786095339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoZJUvqOnB9ofJGbnDsG82ZWVAW/7cBOGmRgNjA3QOQ=;
	b=DbvRkSDEl3ZGStJQu2SF72fuU18Ch4uF/mlwb/cH+zz6xx/WtuxNLgSYHQcaO92/+IiP9g
	W7iG5ChObCOcg5mWyW1ZhNKU84xoIyVB33FDFDZGj8kg6rzM9zqDu1S9lS1XCA+/yhc0w9
	3q8w+WYOMfh7O5wuRgOAzQZfO6r0KTI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ry6KOkwv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786095339;
	b=LXT92Pfw56f0v7u3meS0zKNxXDES5d80KWU4GdwuPOf/YLZn6S5Upf0XuBxsys7bOxDXcL
	Djrjm7bCw/245yorg9fB7o4ZrZlVFoWHoIBW4lL/TOKALRffGKrTbTk/oscKnuh7xpuBkn
	3IVw7PUtet1k08hwSwWChTTszwVW+l8=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2caf228a910so26263055ad.2
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 02:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786095338; x=1786700138; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BoZJUvqOnB9ofJGbnDsG82ZWVAW/7cBOGmRgNjA3QOQ=;
        b=ry6KOkwv764qtdXaRZhwe15FWWcY71RXKfGyoId0PhdFOTk6Kdqeay0EmNVlYXiMOx
         3rqTmDYm4VDSIaI+8QOPziPcNtmK154qNlf6Z1Pj69ifqkRX78YbQf7SVKpjz5+EOf/a
         arI6pV8cA6WsEUSfO4F9pn7S8B5d3sKesNB3qIri00PbXHHvWfJ6iPIWdfmgvqPZgEBU
         +sVk0dkdIbZBYNc+gxS1lGBIgWl1w61pI0m4VdvgLMuqcQDFi7x8lSA1tfGCsAj8Gx5R
         V1HtAYHN7zZTu8zn8Xp52lWKJOJLDJuyaPKHTm3IhdWqpJg7U9Ro7PoPSBX4nXo/QpFZ
         ztpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786095338; x=1786700138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BoZJUvqOnB9ofJGbnDsG82ZWVAW/7cBOGmRgNjA3QOQ=;
        b=ZDHpuGqD4fPMGB/JAonrmd0P6z13PSZn4JCKyi2lMibRHQNVAuzCD54M7Pv70/E0C/
         Nkhaw68ZTT/p3HOzTu5F5u2kszFcXOwFwAfxpRkyMavT6e/qsv60VgTWHGrarN03EssI
         oMJkOVsUWjz7pxz/lrR+ZDb/hSWDmEJ8lvVt0cKqCVqJOmWuQYGvySoONW+/TPBbXwjC
         la7L+rxiSf0Er65zzOiJgC3Ea8La70W97FIY8Fpfww6ZF7/h1yiCHMGbSpwDxtA4aQhr
         NX2OWqKu3PUTfhTKrsPhX1uwkKWnycJIcnHH5WQXTI0C4HS8a2zYx3lQDoSexLAMfg29
         JZhQ==
X-Forwarded-Encrypted: i=1; AHgh+RriIR3IvCNO79eCC9ZalSA0IztHo++7DiQ80BVsdrlobZaVmm4uOaksMvzi8nTdXjdaWH9BKSCJwQ==@kvack.org
X-Gm-Message-State: AOJu0YwEfWo92fxbergWdkb0wJriRAka5BitM7kQGxTC5QjXQ7fayEn0
	uD4Lf523u0e5gNWuzAzf6Lle5tB7RMqKiliB89617FcxdgT2WutjCClr
X-Gm-Gg: AR+sD11Folko0NUROxbX9gH6rdm3Xe2ZdF4CLQHU5V/kslohPtNDMa49bQzFgjt8/PZ
	OWUfm9npNmrukQBL9HQSqTIH151BgubTwwiz+hnlY6tN1MoyBg9W5SVJgojhMMWtrZz31dsPN2i
	TnBu41bwlTEujjjVBwCmPE5zGwIPaYUjRVvzHim2ITSuUCzqf8jz1+3ZjPdMftzHgr0L+I2/NcU
	n3/E6pMNhiuuq8raG9xsQWe3olUXhEd3qUdTFH1ml4W/0M5K/9aZf2erPs1j8Pi40eHlzewxtlO
	6s6nLDE9PJ9sMIm979JPLC///KbmOZs7UY/93pbXSZHuuMx+vzbbW9DFbCJgi4rrwb8OWSThg1w
	8TM0UhP4IbXUx1iShNP9jXksSu2l72HICxN4k7hiJyBXI85RYmOG4BroyB0I/LXWlprd+S9ovK7
	FoRaHVvkLLHHNf1zSUKFraDAuxPfCsQ9kl1l7dv/m/4O4OuspHZQDYOAmRx3MKiYfc
X-Received: by 2002:a17:90a:da83:b0:38d:e0c4:c955 with SMTP id 98e67ed59e1d1-3903c5d84b2mr21355052a91.15.1786095337751;
        Fri, 07 Aug 2026 02:35:37 -0700 (PDT)
Received: from celestia ([2402:1980:935:f4a7:6f5c:e816:9aba:2090])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm1604269a91.2.2026.08.07.02.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 02:35:37 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH 1/2] mm/damon: fix nr_snapshots counting using tried_applied flag
Date: Fri,  7 Aug 2026 17:35:25 +0800
Message-ID: <20260807093526.183009-2-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807093526.183009-1-aethernet65535@gmail.com>
References: <20260807093526.183009-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 8ecgwbdpzactqzi1t8h6w9fqfgyrqj3b
X-Rspamd-Queue-Id: 1376640008
X-HE-Tag: 1786095338-776975
X-HE-Meta: U2FsdGVkX1+6D1HIBWQ5VJ1qocLLO7xcZpOIGnmPmf2IeFsBYsyDbhBI+GFxAJZyBO0xbOvC0/VMSs/qXWWZqcrCIuQpGhe+slUSgQnPCOtgYoCyszPncLfYTuoBpru5zEMZPF0Zcpgu1rVgxpChu8P7tWsVDTWedfxRPgaKnzTTBgOw6Di7MunVUULn7b0rX3K7l4ClJm88meTPFvCT1PjeclHTi+m+VGa+GgGp+s6whYvCEciJ1EhDatjJCjKd5fxPJawRvGs+RnPJL+Ne0UvmmKS7J+UC0w7clTHk/Jv12BnTCMW287FQkcWcaXXmJwX5fM9wylpDFpUcD0kxJ+U4xHJW17B5DySEk4bg3f1xgXYF/7iV58y/rkaA8DaRIBoC0eLK2WO2O8jQyR63UZreF8sth0jqeAPFUTQpNeAoABeClvMcoB1xqXWgohNTjmhgzwNYUaXqnk+Rs1VxrFSYJ42A9Djs9lMd6hYzuX1TZryFf4oY4igde85SwOIhOeCgfpW7goaA1LClIhW1o0MJQxQAR/xhmnqHqG4ux3oUVPsM95gdT7v0XDRraj7if6BovgC6XoniuxWwF0bRpSjuGQmt57BJhVb+tmofujBT3jpVoYelVsz0dAhhGGIZXao27Nv20Obdw6FjK0wO8ep+gPYjoq21traHM5gAH9gTP/EBFHTVodOMW/Va2k4MwJKCSHq662nKKDme0tsGTWbuAIxRW7ySsiMuD3deJKO3vk0YYHMyHHKsE/PxrG25+VCmR1xdTMF8JTQZxjrAvhkVUqerzE4l5uhkiIFVC6ALP6GlV2ko2DZM1nFF6MU/ajOnbS0/MnRS/0CQ7N9DmL3z9r/MT/HK64I/g3bIbQXI4rumlum47PjGhU7mkJAqBZ+xZbVOHOWU/9tyADJmTzXoat/ZLXHkWZnCm3NZ8jVMEsBBPco65SzP1HPAUIm0O4s9O0iWPY45kX4W7jD
 jODAnpvu
 7GUDQmPRfW5l+iMyCNS5aWY1Lq2LWqcyjFRXZK9Up0Y6ZaNxA9VbqvV303spjXGnRUOdunIB/qQK20lbSN9YEZTyKLVdjVSGhEHsXFMp/275u+HBMZb0UxJHaNhlgE7rF2gfDZjtB4JuPkb8eh05CoTR0ZpXh6nEgzldkZS4spoCNPNhezonTRSMzYjKTKVXM2STV95ow99l9nzdjD7i0aBj6MDn4iEcHXU9xD5xoICk9xO/3vkgWihTY20h+gmHK8mPDSHpt6VaAL4xuVM14YKrUuGo3k2qLen3cfkVUPXHuD6yzdFWIxcM9m3MuTNyTrLi6lLAIKl+MsoMW8c/3enyLsDXnn15T1LsM8iVOEASj1+Gn/rZYFW6khJpS7BSQOlplk3Y05MvJSx+baPoB4a8XmNRRyLiMusr9fE/K6kULd7prXEzYdLINbpnqWY1+hlSEoeSFVnoUScbcZydT2N/VLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, nr_snapshots is only incremented when damon_is_last_region()
returns true. This is semantically incorrect because nr_snapshots should
count the number of DAMON snapshots (aggregation intervals) where the
scheme was tried to be applied, as documented in design.rst.

The "tried to be applied" means the scheme passed all guard checks
including access pattern, quotas, watermarks, and max_nr_snapshots
filters. The old damon_is_last_region() check does not accurately
reflect this semantic.

To fix this, add a tried_applied flag to 'struct damos' that is set
whenever a scheme passes all guard checks and is considered for
application in damon_do_apply_schemes(). Then, increment nr_snapshots
based on this flag in kdamond_apply_schemes() after the walk completes.
This ensures nr_snapshots accurately reflects the number of snapshots
where the scheme was actually tried.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 12 ++++--------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0c8b7ddef9ab..01e899a2150c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -573,6 +573,8 @@ struct damos {
 	unsigned long next_apply_sis;
 	/* informs if ongoing DAMOS walk for this scheme is finished */
 	bool walk_completed;
+	/* informs if damos is tried applied in this phase */
+	bool tried_applied;
 	/*
 	 * If the current region in the filtering stage is allowed by core
 	 * layer-handled filters.  If true, operations layer allows it, too.
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a1656..7230483e771f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -398,12 +398,6 @@ static void damon_destroy_region(struct damon_region *r,
 	damon_free_region(r);
 }
 
-static bool damon_is_last_region(struct damon_region *r,
-		struct damon_target *t)
-{
-	return list_is_last(&r->list, &t->regions_list);
-}
-
 /**
  * damon_probe_hits_wsum() - Returns probe hits weighted sum of a region.
  * @r:		region to get the weighted sum of.
@@ -2668,8 +2662,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (damos_valid_target(c, r, s))
 			damos_apply_scheme(c, t, r, s);
 
-		if (damon_is_last_region(r, t))
-			s->stat.nr_snapshots++;
+		s->tried_applied = true;
 	}
 }
 
@@ -3249,6 +3242,9 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	damon_for_each_scheme(s, c) {
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
+		if (s->tried_applied)
+			s->stat.nr_snapshots++;
+		s->tried_applied = false;
 		damos_walk_complete(c, s);
 		damos_set_next_apply_sis(s, c);
 		s->last_applied = NULL;
-- 
2.55.0


