Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D447ECD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 02:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4680A6B0088; Mon, 11 May 2026 22:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419266B008A; Mon, 11 May 2026 22:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32EC76B008C; Mon, 11 May 2026 22:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22EE76B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:20:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A511C160328
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:20:22 +0000 (UTC)
X-FDA: 84757163484.01.AF817B8
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4A090180004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:20:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="WUk/hWn5";
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778552421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3abEkWy1zSpEx/nYCxvV4AVhIZirosMNZhqnKUXsN/k=;
	b=LXUEw6Dv7W4tOETq+yms/0uRlHPf3TtYQGQSMtBMyplTy5Pb46HymY12lzGRGTxRjIhdD/
	vXK7GikXwBIbGbpy8p1eaxda6CNtWTD635KShVT8MrMHGQU9hthcMJeom6vINucYpI7NCF
	DwdNRpaM9BIITkel1yy0dpzvukJKCpc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778552421; a=rsa-sha256;
	cv=none;
	b=fSlu67mq5EAMCKZNGf2LZSkHBY5cMJ70v6nUEuPRblrd6CMAeL3sVvOR7hOttDnmyiaE6j
	ZHiqQj/xzRl1+DuebTS/xF7opalS9+x6HB6bgkYMwNz8VeAKrQECZG/dPBUUKtY4MGh/i+
	Fh84xm+eVfBOTdmtGgnDnO6n3+2nf9k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="WUk/hWn5";
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3653cb9c6f8so4121159a91.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 19:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778552419; x=1779157219; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3abEkWy1zSpEx/nYCxvV4AVhIZirosMNZhqnKUXsN/k=;
        b=WUk/hWn5vr2vUmBibWLujQ3Z4cGkos9WGmab85e6wDIwj+Tl7ubmgtadFESlpZ2bs1
         HJtooUTSL2sC3/d1K2CCgiOpOovZDE2KdRKDMFzGwQynwgHFwL9GXE29zgKtA19ItMQh
         LEq6kOrUcofnQWqT16setfVLbatR06+O9+7cdlK9xQFP209DjrRQqmQ4m7SHZObobT/P
         gHPghG5ButdWaqLRLcPKiaETgtXdBuNV9Q+jebaErL6n1BfcylFEnSSk/0vsjbNh9OnK
         SA+sy8VTg9mNSXJkoq3rf1VXQbhpcSWI6L+HmunTxBlr5aho3+04v4x0XHbHCPJQrvni
         /VzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778552419; x=1779157219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3abEkWy1zSpEx/nYCxvV4AVhIZirosMNZhqnKUXsN/k=;
        b=sq8TBpXquFbq1pPA2jz8IrQsBouiNvvtL6O0zIhM0zsrVrWFWzjbnaKVwgPdtuYksX
         GHEfzRiIuGnipsaZgjkL0OmsU3gnGS6EiKkGOocehBGDeIWDZ81CaoYZ5vJvOEEDiJAY
         fLuFSmio3OkMZySrKDElc5fZz1Pnn+rtyQvjYt9YjBQeHAuAmiY+xEaY4f6krCEQ38N2
         nX5Uiw3SaWx9B2W/S1gYtG0UxN0kVWY/GZPazQdZZHo0VZURhGSCVooLCWjf2uX/LQZV
         LQm8U/GA3lNHHMyQ7utkNSJQvM0NB5Tmlv+FOuDb4EWpqbqD7WtD2Y7/OQ7A4h1U9ENw
         ikSg==
X-Forwarded-Encrypted: i=1; AFNElJ9ZJoA+SC9iDZYfYE2CNuSvADYGTLIwe8fe3ZLnQdZO74Wu8pAmaRhgp/D7d/uvgn+KdbcOD76boA==@kvack.org
X-Gm-Message-State: AOJu0YwbQYmuVJvP3i3paUbu/bLRWa8NX3uXPTnUeUx8laUEOwIJ83Cc
	92j25pPAZlwstnrVJr/3BjzOxMhZbtynyi9NNBFTf3pg5swLTmaHkqVgNYuuXWes19I=
X-Gm-Gg: Acq92OENw1t38QfKBn8JNkiU5lxp82FQh/Rl/OTnWEPvNpZDsFj02fKrbUcXA6wvtFE
	rq4cX0SqxFs6S/jcUfJStTjZlInxPxt6ZSoZOLYSwY4RdlGD05jZj9sSm/AJMiVPnFOF3Pvp2Tx
	rL5XGpRBuSY2ibc7g8MMvQa9UtgxOq8Rcx8C/T6Xp+AUfZk2s/kFFO1Df4wnSBQnjBdxGX53P+f
	vIL46caSn1TzbPc/vTwku/bzvKrCfmgSM0honJAGP8CmEV1oR+8aezKC8zeS2iOA4ekWkSbi6LN
	A2i/UeNW2/7MxE0v/M3azU45aI6zCAXQggaNfBxFPat2ts3tn6E/UxXyvD9MlehIZT568txfD2b
	Yf5pH3z1fwDmHvfYJvAnFrJzJ3yFd/kjqG4ljQkD7Q7N23IRW4nXiAcofi9Dt0SU1xMrua6hhwm
	cGLKaTfPjPEoH3F3tKaPJCLiiB3nCF0btX+dj2obAC9ms=
X-Received: by 2002:a17:90b:5787:b0:367:f9f1:af78 with SMTP id 98e67ed59e1d1-368b24ca34emr1232873a91.7.1778552418807;
        Mon, 11 May 2026 19:20:18 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d687bedesm11806019a91.16.2026.05.11.19.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 19:20:18 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	zihan zhou <15645113830zzh@gmail.com>,
	yaowenchao <yaowenchao@jd.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v2] mm/page_alloc: fix zone reserve update serialization
Date: Tue, 12 May 2026 10:19:44 +0800
Message-ID: <20260512021944.3445546-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A090180004
X-Rspam-User: 
X-Stat-Signature: 86tspgg848pzozjd17s558818cxhhibb
X-HE-Tag: 1778552420-37325
X-HE-Meta: U2FsdGVkX19yD5NnkSZoOjgA40ZH4NH6hgXSBjKG6US7QntmW+NlnCa569yVWIfH39Ay+V4AKT7pIS7ZqWclqLsGFbNWOa0LZ6unBlrbwpN5pbTn68HvVWI7ahNXtVXv5Qw3tIVybOgWaAXFW2Nmi1lFG2ZQxGyTCXaFdU92e6rrBfgjNSoFdX2JS2CNMTo80J+CLgonsRGaO1xJbA1diy1E1Gt1NqxdHGgIiRhcGPm08sCfH9OUkhARkXPmKnyFGN42FduoDcgWsq/+7Q6o7sIgafT7TWs5pc30odB1isMk9j3xML+erYSN03TwXdreYu1r82zecYRo2YhHeY2YWMoR1182KJro+sysOMIpQ42Op5kA2IEmMRAc137QSgy7BFYRmG1ZEXmvzSigNrgCVJzkogyVJIk7NxCNv0Cp9wFgYnkEZNBYifg0kIg9P8UbJbSfxbvy0zxragFo5G4ahLxxHh84limKqfojvWj9w1t6sEP3HHwPLoSZoq7WVcsHx1LqTrT4/uidLqE+nmWV8jKa7Oqvw9UOw+VvTDlla+7spG2B9m335Uj+lfKw/KJaF1TvuiqmV6TCfut9t1tq6dE4TWEW46akOHvaU5lxlfjPMUeCSsp276SnURluG0Z9yS2ETswFxMOaM+gfOl2g4YVU4/ZzXw/JJtzhGYZXrairpetenAZL9x0ZrQcpsEKEXZbkKlUFEX2TUwho6aSR1Da0klL7jHlG7VW4mahS/lP/O0CTHp+dAKu8sGwPBEuSun0+ROrh8/lf9nrdLI/qHAgUN1/a6m71f1Znv8an5HPcmO7ch5krgsGgxa0REsvJHMxOjW659OUheNUbGc6kykcoUMwvo4q7OkbLSQOJ7vdRVFe7ARYxvhcKdPHIUFS9Ksq3J7RKoqpT5/T4QqQeQAlFBwGmvA6gpGOKMpbiEiDZVZOznDcHTr72nZW+3yxrpwJP2LpB1Z7uj87RKDF
 cdyjnN8A
 mulzc+ZUl+O0TMQOhDGJfTsV3sJTlUQe8ur7wdkkKHQpCbUwKmLIf5syNNYEdC4JL0T3krY2bWYl2X8/+JnHx0rNs4RhWocioZuQKyubAeei48HO+zKsvaNEHlnSTtCBgIIvYk0S6NsmftKqz9xpq6FJXEDtNNNw3NfkHpA+KzoYRtrSGjsRDXQPYknhvw/NpGt9Skr2pgqODoSDKN4Lsv78LmqNqJbR9M2d5v4MAIJ2Ls6R3llL7NL6j/yGpiBxcSkhRRFT1OT10iOQxwQ8NA/u+f5W8xdLTz1LiFv1l53FfmkioRIbcmCqEw+jXWh6ZsH9k2+CQww9W3FQ79vb89IM6xZYcAudqZHufug/pnCO/VBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9726891fe753 ("mm/page_alloc: recalculate zone reserve pages
when managed pages change") moved setup_per_zone_lowmem_reserve() into
adjust_managed_page_count(), so zone reserve recalculation can now be
triggered from paths that run concurrently on different CPUs.

setup_per_zone_lowmem_reserve() updates zone->lowmem_reserve[],
pgdat->totalreserve_pages and the global totalreserve_pages as one
logical operation, but adjust_managed_page_count() does not serialize
those updates. Concurrent callers can therefore interleave the reserve
recalculation and leave the reserve accounting temporarily inconsistent.

This race was identified by code inspection rather than by a reported
runtime failure. However, these reserve counters are used by the page
allocator and reclaim paths to make allocation and watermark decisions,
so it is preferable to avoid publishing inconsistent values.

Serialize adjust_managed_page_count() to make each reserve recalculation
observe and publish a consistent state.

Fixes: 9726891fe753 ("mm/page_alloc: recalculate zone reserve pages when managed pages change")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v1->v2:
- expand the changelog to explain why the theoretical race matters
---
 mm/page_alloc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3a56825a7fc5..0989067da588 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6384,6 +6384,8 @@ static void calculate_totalreserve_pages(void)
 	trace_mm_calculate_totalreserve_pages(totalreserve_pages);
 }
 
+static DEFINE_SPINLOCK(zone_reserve_lock);
+
 /*
  * setup_per_zone_lowmem_reserve - called whenever
  *	sysctl_lowmem_reserve_ratio changes.  Ensures that each zone
@@ -6394,6 +6396,8 @@ static void setup_per_zone_lowmem_reserve(void)
 {
 	struct pglist_data *pgdat;
 	enum zone_type i, j;
+
+	guard(spinlock_irqsave)(&zone_reserve_lock);
 	/*
 	 * For a given zone node_zones[i], lowmem_reserve[j] (j > i)
 	 * represents how many pages in zone i must effectively be kept
@@ -6509,11 +6513,9 @@ static void __setup_per_zone_wmarks(void)
 void setup_per_zone_wmarks(void)
 {
 	struct zone *zone;
-	static DEFINE_SPINLOCK(lock);
 
-	spin_lock(&lock);
-	__setup_per_zone_wmarks();
-	spin_unlock(&lock);
+	scoped_guard(spinlock_irqsave, &zone_reserve_lock)
+		__setup_per_zone_wmarks();
 
 	/*
 	 * The watermark size have changed so update the pcpu batch

base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
-- 
2.54.0


