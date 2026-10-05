Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E838ECA5FFC
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FE06B00A0; Mon,  5 Oct 2026 04:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692596B00A1; Mon,  5 Oct 2026 04:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55AFB6B00A2; Mon,  5 Oct 2026 04:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34E516B00A0
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:47:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24E67A015C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:47:16 +0000 (UTC)
X-FDA: 85287943272.14.848C922
Received: from mail-yx2-f1.google.com (mail-yx2-f1.google.com [74.125.224.129])
	by imf22.hostedemail.com (Postfix) with ESMTP id 49980C0009
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:47:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XY0Zn+yn;
	spf=pass (imf22.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.129 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791190034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lOJYATF5GzgxnR6rvCgXN1lfrW7Tn1J/cuI+kptyHw=;
	b=nYT+m5d/pgVoBDHFDPBrAvf4tDuauVtuAbFysZGbGPlS+7kjUbTvsOpyT3/v5FZ4q336ZE
	7SNKukUjn9f10OhXDKR+Sdz2WQCWM++X2cM8HON+J3zLEifvcrlY0mh5RFUALyQRHfpjN8
	OejQWgJSXvv8kQjM+lMOfcdZH7kI8ZM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791190034;
	b=WIP6t2WL1dFpw2hk7AJkMeuTXUlZqTgm6A43w7OBe2jMva4YuP3on9W4tdjaOSZXWoJaxV
	K3WRPZ7J/ixY1hzBcNrR92E1nM5NcbEyxc8h79p7ceUzbHk57xMoAdvNk4qourdH2K2Rtq
	MC3rMhQRJzr0GOEw+G+kuOTDuDDnAQs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XY0Zn+yn;
	spf=pass (imf22.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.129 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx2-f1.google.com with SMTP id 956f58d0204a3-66d27631526so449472d50.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 01:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791190033; x=1791794833; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3lOJYATF5GzgxnR6rvCgXN1lfrW7Tn1J/cuI+kptyHw=;
        b=XY0Zn+ynndvQ3FE4QNabiTDpxnQ1Sb3xmO2O8JZOEpyJ1h+FFygtaPBMOk4JeWzBp8
         x6Qb+cN+TdeA6VS2pMhorw6o/y/3e9zJhsA2y0jBxwPKRYjkbJEm33VDXcC8U6faz4s2
         jtOxtPSvT7/sm59WdhunBOHz2o26KLyYRfiGz8cXuLz40hgekWV6hKXrVYc0RZZPQNGi
         ZtpwqIIYFgt5gkGssjffPEe7UP0i/Mw3i+sC2+taFOoUNkObzsnb+kPUiAvDpkn/1HHU
         Bd9snDoTGDrcGfqSDGxaYByutNbLzFJDRYTLQkEGBUq1mf4gu7kNgqwtELUwUu0SrswY
         b0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791190033; x=1791794833;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3lOJYATF5GzgxnR6rvCgXN1lfrW7Tn1J/cuI+kptyHw=;
        b=ABleZ5LlZ35kDutXwKsgzJnkN1PA1bjqLPAmwO+oUZy9Dcy0jvM7xLVPwN/jDhvBvM
         FCDOQDBuD4nvjDb9coDCzmMINqu+7t/YwPgbPUfd9qm80yNDkFiWcxPDYoS2fgAfVtE3
         UnNlobHAY8rYgtp5D4yvlDosKG7xou/zn8MpJBlDq0GX9OgcHWmQP04tu21FuVZrnmoV
         0+hLhXADjXUzdqECMXYxXyUIeOoUsmu6aIbmwTUFfrYotau6NbCAPbmjTykGyxNy3FIu
         6ItHGwRLXzc/OX/b61padBT/6UFN2+IKOf0sIxvGnF0mdRAvtGIWixk5gcAOeLCc3rCV
         jCdg==
X-Forwarded-Encrypted: i=1; AKwUvBxc3kg+o3nEd9GUQBh1tN/Qyzma9knhTp1aZBBys/2UIQbtoGmwWhdlyy3eIyBqHmqti1NDjFvOHQ==@kvack.org
X-Gm-Message-State: AFq9FYKIKyYx+J/tPKFFMMY6ntBDo+LEZ23A3AhSsK02WWR5et3hcSWL
	ZtJKe+aQFeEngeTTUkvCvSaYXEIAuwtuxZ5H4vpfEkH6CdqOOrczJYY=
X-Gm-Gg: AYBFou06Bp70eKbx6Gh+4EooDwCg+JdjVEXcJYr4A4GkJn8MpgIlDKisDXoGYzev0Th
	DCv3c7gIDPvCUz57kS9tgzxKfMmUd2FIvBifWxOoPJ2KKeEW2z96LOy0h5RZ5hbrkPfnf879H8I
	Grs0zGqTmLqcK8i3i0ohxvK8Eg19TRFgrs9J46GDybdEr2BDJkpZb6acS+n5WS43Iu8E/+8u+NZ
	W8PC/A8Xn4jQuzbYRJXzOPyMLX6/tl1GQq6fHBmBvQeJAhYc/hc8p96f3RTtus6beY+W0vA2ToY
	RoT7WISaph24oHiQ7YE/IgpteIGVqN981V87VE0lu1LiAhPStI/9UpA5p1VGjGzSlha8kLIMtbU
	1XXLflN+cxwLCXTjUPXETNO9UwLB3EuYz1jI1K6ab8apF5zmtFwVdAMaqqPoorFnQZFIgndSFz7
	WHTA/GdpNW7kDJ7xMBiRIKhn4R2/oHlCuOpZZU8a2BNEWp8n+mcK/tSIOXAsM6yGNkB4E0Zbdph
	woeG12aFvItFgflukIjQ0zRz48qMDozBrcFK7/ZQt2eFnh2r3Akt28SaAOohkdb3+vp+5Qoorok
	Mqr6+EV88QPr7eqzaOnL5p+yD8hYXLG7tw==
X-Received: by 2002:a05:690e:12c2:b0:677:afe7:1f98 with SMTP id 956f58d0204a3-677bd3e2c84mr2661304d50.83.1791190033376;
        Mon, 05 Oct 2026 01:47:13 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:1149:2fcd:c86b:8747])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-677c1b9c895sm2346306d50.13.2026.10.05.01.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 01:47:12 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 05 Oct 2026 01:46:52 -0700
Subject: [RFC PATCH v4 8/9] mm/damon/core: cap the region merge threshold
 per target
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-8-b03452e137f3@gmail.com>
References: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
In-Reply-To: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, 
 Wei Xu <weixugc@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
 Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
 Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
 Kunwu Chan <kunwu.chan@linux.dev>, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 49980C0009
X-Stat-Signature: 1rjn6m8two3bybczr8nq1rpyz4rfabih
X-Rspam-User: 
X-HE-Tag: 1791190034-121848
X-HE-Meta: U2FsdGVkX1+pF76KUEdfsncnupz2mykU4ue6Hz/gvKBK9WrtEIW3N2I/S/WpT/huwJvG0D14cVQ6rkXHMc5u8FTvMeP5OBbETlb/zwpyOw2ncWybN6hbcJIJglAhXhqe9QkuXMp29Bhwhxcp4lfe/eTsiYL7N+MVyupxNtPBb4YEFTJmBCB0Pqf6fVTMSGkPrLU1xxUmAcKpOSQKIdHAb9Wy+yJ5UMh+cMhZ2uD8vcMElCCYZECPFrFbSPIo6Yc8m8dVfXhjnun/KiXVWBhF+UrIOa79CjgLHbk5t2lwRyJJpziTFInVSPU7wgkFqGMxMoT5cvh1ltSz5u9KvXA5Gi4G8uwMOfdr4qMrf66R2+586s5sGkG8OvTYWN8f7Pg9K/DQajfDHHPvqtaFDPw5XT+tWoffoJd6LmVV4vOCDYEGwlirviH1zGG03S9vfLg6QJoDDRWwbOJjI5lE4vWiFbwvl5jOrey+Z1drmFKRWBlg8Pd+0GeGsemOn3tJL1NWmTJOaI9InrI9GLq4PVDqnrD2GlXp0nD9+kMRiVu+gp13AzjzcKkWREhqJAbDpQAKTeOHPu/tmA8vcQubeILnEpyIppuwx8i/uvv+yw4FNzv464VHvWvhMIvjl+P3CWugEuH8esbQ2zL3f5TNf4wbZlXnIqsu+ITzsXgVzsOcZxkGLkZnBTYh1rrMBT06q45bkwOvvESSvCjyyuj6stB7BxY4WZFwE9LYtTwiEsvGYjOg836PgDErjMirDEjj1mjEZV4EDvDBlWYG6IJ80ZU2HaeAINQVQTdSywcEnJO27hIhm5l1VZQEqr6nTKSgb11HFjJGWrphL1jNRUlDKlQF3zT1veRvFxSb2L/I3+y8q7mD8RcSg3CFE5OU9LryJgDWbSaOEx/jbo4zmBJwYDZUl7ToLGxrxpI0D2ez4q6nr9o+xdWUDmm7nNow2p38RK6Va5UAL1ahs8Q2AT/WJC7
 echp0swO
 GGoBjzPETEcljZ0m+Q8inNc8vfPl4KKE8VEI+tukm/i6jc0ofW3ts+4Fh9zwZSxPDE6i/dtpSyY4q6bd5yJY8NM6lKScLvvIBKLVmqCu99XIu2N0oXZhbWdgl8eYEcnUrAs8RNzPnFnOYjmXilEJesKzOvCstD5YWQ51fk19UZcNPdwDDjVQkxzApbgXkmRSrQuqYIs0M6YsjK0vclUYdDRmZHp57uq+g0svTjYphUi0iG6jz502hIk48h9a23gytdn8zbGW4lSmnTjBKII53PIcqNYBGD0C9BIExcH4HMHmuubZFTfxYU+daHSBPD3L6F/Oi/WcRp6eOiiTbD/HLkkZWQJYYuuc4FQo5XW9AJbj/zLUEgjr6uExftsDoNhZ44Jnf9m+8TNhh9wTgEqOzrzwuvp8W4YNGyPCQIv4GkR9cKon8UWG/A6dEnei/9DN72Fe2g04IsZx1vpypNMX+9kmzIUbeFFwxLxzOVQ6DSPMGafdPwIGTg4KrZbZsaD85bDbW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_merge_regions() applies one context-wide threshold, the highest
merge score across all targets divided by 10, to every target.  When a
high-traffic target and a low-traffic target share a context, the
high-traffic target sets a threshold permissive enough to erase the
hot/cold boundary in the low-traffic one: a region with nr_accesses=1
next to one with nr_accesses=0 merges because 1 <= threshold, even though
that difference is the only signal the cold scheme has to admit it.

On the regular merge pass, cap the threshold for each target by a tenth of
that target's own maximum merge score.  The score is the one
damon_merge_regions_of() compares, so a probe-weighted context is capped
by its weighted hit sums.

The passes that follow the regular one exist only to bring the region
count under max_nr_regions by escalating the threshold.  They keep using
the escalated threshold uncapped, so that bound still holds.

In a probe-weighted context the merge score is a weighted hit sum, which
can exceed max_thres, the samples-per-aggregation ceiling the escalating
passes stop at, when the probe weights sum above 1.  Raise max_thres to
ten times the initial threshold there, so those passes still run.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e3c29d7cff23..7c0df07f0a90 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -4167,12 +4167,40 @@ static noinline_for_stack void kdamond_merge_regions(struct damon_ctx *c,
 	unsigned int nr_regions;
 	unsigned int max_thres;
 	bool count_age = true;
+	bool use_probe_hits = damon_has_probe_weights(c);
 
 	max_thres = damon_nr_samples_per_aggr(&c->attrs);
+	/* weighted scores can exceed max_thres; threshold is max score / 10 */
+	if (use_probe_hits)
+		max_thres = max(threshold * 10, max_thres);
 	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-			damon_merge_regions_of(t, threshold, sz_limit, c,
+			struct damon_region *r;
+			unsigned int t_max = 0, t_thres = threshold;
+
+			/*
+			 * On the regular pass, cap the threshold at a tenth of
+			 * this target's maximum merge score.  A high-traffic
+			 * target in the same context must not set a threshold
+			 * so permissive that a low-traffic target's hot/cold
+			 * boundary merges away before the cold scheme can act
+			 * on it.  The score is the one damon_merge_regions_of()
+			 * compares, so probe-weighted contexts are capped by
+			 * their weighted hit sums.
+			 *
+			 * The passes that follow exist only to bring the region
+			 * count under max_nr_regions, so they use the escalated
+			 * threshold as is.
+			 */
+			if (count_age) {
+				damon_for_each_region(r, t)
+					t_max = max(t_max,
+						damon_merge_score(r, false, c,
+							use_probe_hits));
+				t_thres = min(threshold, t_max / 10);
+			}
+			damon_merge_regions_of(t, t_thres, sz_limit, c,
 					count_age);
 			nr_regions += damon_nr_regions(t);
 		}

-- 
Git-157)


