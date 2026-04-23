Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95B70FDEE4A
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9805E6B009D; Thu, 23 Apr 2026 16:35:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9589F6B009E; Thu, 23 Apr 2026 16:35:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AB316B009F; Thu, 23 Apr 2026 16:35:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 648F26B009D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:35:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 93AE71A03C7
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:35:06 +0000 (UTC)
X-FDA: 84690975012.15.D5093B9
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8AE2B140002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:35:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j20Lmmdd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776976504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxH+yk1exTjyfi+5qxKujuSUOSqkgCGj2Y+qVsczotM=;
	b=NMzeaPLRW4OLe16ElmfOarKKkYwNZhvHijmbfFV7+tFRImgtEa5OSJEL2NxORIPw6cRpB0
	9nmvWwugSANGrR5WrfiCMu7In1esGAvb+ywRPD6XASJHwnLOBNAdD6iXJ/lHdk3m1GBS+c
	R2zQcFmQASgsftah5I43cK6MKjllKgI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j20Lmmdd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776976504; a=rsa-sha256;
	cv=none;
	b=2d68p4fUr2avt5EfDAOPFajomYEQrX0wro7r27vW3bZ7tJ5ct+DMyIlyaI9sjh0jsV//8e
	RY7+BA9isPvOH/l+q5oa+9N/CcbvP1fprE3CEP3ngL0MRi0ZwZ/zGnVDEPolVHLErD0WsA
	+h/FektVb++k/JYJrIfiBiMjQ2liIwg=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7d1872504cbso6022108a34.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776976503; x=1777581303; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IxH+yk1exTjyfi+5qxKujuSUOSqkgCGj2Y+qVsczotM=;
        b=j20Lmmdd7aw/wSPvbUFWyeHquyB9taw3YOj5psAA8NvMEv/cS4fAmrF/FvhpAA+wks
         jcBrf5tdZ/GzXkjBAzKD7+1f7bvpRHAIygmXYbowfASf+RzjPaDQZjunvDI47u1Hc4mm
         8c1r12u02HDXMd6EGnZQqZYfJoGijluwN3V8U4xUVFi0Eah4scJ3uzEG9iwkPXtv1fnS
         8qzNHh3tj1ddySubJn4D5/xm5VmyD91yUYn1Jdj7ESaotpDuqcUP731k9idjFJj1OJXs
         i2olm1usoV8zNFc6xdkrCpnMDie8RgJ2EDy/KUVwGcgid58H0mPdLN5qxKORvMvO/WFC
         Mx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776976503; x=1777581303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IxH+yk1exTjyfi+5qxKujuSUOSqkgCGj2Y+qVsczotM=;
        b=Kc1idiqlmMn4mkVEm56hx2MrP6j2K41VsqxfMz/NTQyCxMl8JqP/vwS8Z0nTchuCh+
         +eeIKgFo7kMVbfLx2pTDqSG4G4G1D0GxPWrLmY/fLOW0kYnkhZjasRcZtDSNSEKGamXa
         ruQL65swLhgBTWwZ5X+D9s5Sn2qzWalVXnJExQJW4waF6zqEgz+3J+OR2csxBjAbcIXg
         crVVPyvFRh8nThFv92GcjGkkVwUy8uRu9QeleO7FeFzq8baRjLef8y1dhKZW0ethESH+
         c5ma+pJ20c3l8WJ02V/BfKg2DlCjo2+b2pnfhsfMnsGkbylAYIHVr/IKXaSUagKCkx7p
         Wiqw==
X-Gm-Message-State: AOJu0Yww3e5aThmeNB6lMucGcNxdmiWh5Qk4m8U8v22Hfa3m2jYokk9r
	lx4/w7+gm5qhd5won+h//e+7OyZHucdnBhEUp49n2+9bMeBIJGmFeyox5ixecw==
X-Gm-Gg: AeBDies5zR77ayVormP+TQMr/bRaWv/sdbDt9ZATAeyVBFcMG/aQP68PVlnqncKf1GN
	mxNismn8uVSKiYwpE/iZJ7zoQViELrQeXU3Snk992iyID5Ieinsw7ENrvcNRVDFB/HzyuR6+0vy
	9vkWPLNgaf3pXnL/Dmh2eFjdDIfAn/D2GhMeqR2olrGgLuQ0/w9Hk1G4i38r1Io28vnlDHDEyJv
	/lT76RnAot7Vel25/NiMUDmDTj49/cDWABlv16BJZDKiR2t2mBU+fqPaeFITGszwYCUG0KNsCa4
	fdCZlq3UFU/MgfGylWigJCWrXN6ER4Kg5IasEF6kj7dsOpeUfV/NMgld+LLEbQ/GNA3CQrXambP
	qSsYjUeAd8uCa4NWoR/7okYbgnAR3V2i154TkVnEvc7d7PWkxNd+ljtffkjhsxZ/SjCm/pBwX15
	//WOZdA1ozKJC71YQCbk+ygIYJAPGtrfkB
X-Received: by 2002:a9d:6044:0:b0:7dc:807:d1f3 with SMTP id 46e09a7af769-7dc9550d8e2mr10674183a34.7.1776976503071;
        Thu, 23 Apr 2026 13:35:03 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dcc892c515sm10877354a34.21.2026.04.23.13.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 13:35:02 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 9/9 v2] mm/memcontrol: Make memory.max tier-aware
Date: Thu, 23 Apr 2026 13:34:43 -0700
Message-ID: <20260423203445.2914963-10-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8AE2B140002
X-Stat-Signature: xkefg4hfftwfseqj36c3qscdzzhzu89y
X-Rspam-User: 
X-HE-Tag: 1776976504-831661
X-HE-Meta: U2FsdGVkX1+ro8c6hEDFNjmi1FKrw6Yu0cpuex9bX33cFUhPZMmKETPFqcnd7Qa4wvSn89Rm9ihgR8q+Tkdf8hZY/qpVimTvKhZKlcdChTN2j/N9WLY/fOiieHnf79MFldHBHj+ZIGOjFLjsYMtSQdIOs5w+xVgwObmfToD6hSj1J2ezqN4FSCj0iLWTyeYn/SzER4C/uLrESys5mGfU+Zypj0sqeJFex3KSgPK0cFrX9WPlD8EdmLEXVr6c8nY73ynsJ639sLsyomELqm7fyu5p54hT7soeWFAfFGAn8L/sS0qlV9iIwNlg8EzkugVfsN26ku4jUNnNvBnKJisVioBDjk3Op29Ihtw3Bp/kIHrdJlTmzOeLGcMB6TZW6E0y96CSCUirLac3B7uZOexc58tXrX6GFmZaFSTLUbSSp6qfGWpVefWXmPVW8jI7jSf66aMO0GjTrZaHi1/+euOaX2I0wFHbyRbOZxmXAUoqKHUA2pY5vYWm1Jp/A47WtFW0t3x/acUduVS5mwOS2ret/OhkD9h5aD1C86IdwNw4eJVP9UuDxhWpdLCwiZUctaGWjxIBonECtInWylO/fSJS6H2xVQRBOuv99CDTurlsjd4flyxYrAmuA1phBbv9ufH1SZTDdvWLwYeIbLd7EWN33T2avVk/No345D2e8+KANB9j3oG4nW05TFms3TJFanMCXo9d7m08vGHBKxVVqxA+7O1qMdu09bGI4/5LbfDZIJTSuJalNVonSQJ8kD1khYOBgaB2agV14qCdLYOuW739/8DjltASFcaz/4SrrYnXPXBjEIkBfJRqAw24ERmtMwCYpCwBvK44+0nAbZo1czFFZEEWPm9GeihMtZUV9uBXaYGXBQMcgGKHMId1B6D+lynRI98wrCyT+momeXZPij4qKNfpFwGv6IeyPvVd7qEsuHKVSNnypYh4CCZqm7DzO5G5YKMlh+W9a00BzYNIs/a
 w9ZvNZJs
 01K5Zwv/cJ25QHmzROhgcWbpX2kjuViZrOYfiUd0jdNNhIwoX+YswwZ5V+ydRpwpU6w5VCAfZ+m50i1U94pMiyL3s6s0ZD/LWmiNrxMRTjJ/sP3z9vYtUGTlhCloFHKlF1qJnZUR8rVQ5nzoBrd5cKUVZwL/d4DjfT4mA7oFAf44FctXe3cQdOM+LuIBZQGJebghNhrl/qPZRMc/AG536J8Cb4USAdtAa67XwKQhLDryGjdcA7e1F0jp3vrOXMV9iUa1cfDGNshIeZ0q+uhWVGa9b9dTlcZexIg9XGv8FJ4znLmYcOYjVGnj8A/rhc10EdsAAGtzh8RqUj6cPeUP1CNk6cCqQd8hU09OsFDLzw6hh6nqi624plZH8Elx/EPopYJHVuVmOqD7FOYDXxlcfrvw4m1EaFZI73N1dK5Frwof7hcKW+kwhfjQRH1N9S/mMWh0zI2mY/TzHZCg94zHtrMUQhTua2z2jsP6tShjwYFTaCM7KWpL1ydDgoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On machines serving multiple workloads whose memory is isolated via the
memory cgroup controller, it is currently impossible to enforce a fair
distribution of toptier memory among the workloads, as the limits only
enforce total memory footprint, but not where that memory resides.

This makes ensuring consistent baseline performance difficult, as each
workload's performance is heavily impacted by workload-external factors
such as which other workloads are co-located in the same host, and the
order in which the workloads are started.

Extend the existing memory.max protection to be tier-aware.

Depending on the combination of limit breaches, selectively reclaim on
toptier nodes: when memory.max is breached, perform reclaim on all
nodes.  When memory.max is safe but toptier.max is breached, perform
targeted reclaim on toptier nodes only.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 56 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e5f39830d250d..d8d67ada993ff 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1518,6 +1518,15 @@ static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
 	if (count < limit)
 		margin = limit - count;
 
+	if (mem_cgroup_tiered_limits()) {
+		count = page_counter_read(&memcg->toptier);
+		limit = READ_ONCE(memcg->toptier.max);
+		if (count < limit)
+			margin = min(margin, limit - count);
+		else
+			margin = 0;
+	}
+
 	if (do_memsw_account()) {
 		count = page_counter_read(&memcg->memsw);
 		limit = READ_ONCE(memcg->memsw.max);
@@ -2424,11 +2433,12 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
-	bool toptier_charged;
+	nodemask_t toptier_nodes;
+	nodemask_t *reclaim_nodes;
 
 retry:
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	toptier_charged = false;
+	reclaim_nodes = NULL;
 
 	if (do_memsw_account() &&
 	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter)) {
@@ -2438,13 +2448,20 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	}
 
 	if (toptier &&
-	    page_counter_try_charge(&memcg->toptier, nr_pages, &counter))
-		toptier_charged = true;
+	    !page_counter_try_charge(&memcg->toptier, nr_pages, &counter)) {
+		get_toptier_nodemask(&toptier_nodes);
+		reclaim_nodes = &toptier_nodes;
+		mem_over_limit = mem_cgroup_from_counter(counter, toptier);
+
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, nr_pages);
+		goto reclaim;
+	}
 
 	if (page_counter_try_charge(&memcg->memory, nr_pages, &counter))
 		goto done_restock;
 
-	if (toptier_charged)
+	if (toptier)
 		page_counter_uncharge(&memcg->toptier, nr_pages);
 	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
@@ -2473,7 +2490,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
 						    gfp_mask, reclaim_options,
-						    NULL, NULL);
+						    NULL, reclaim_nodes);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -4683,7 +4700,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	unsigned int nr_reclaims = MAX_RECLAIM_RETRIES;
 	bool drained = false;
-	unsigned long max;
+	unsigned long max, toptier_max = PAGE_COUNTER_MAX;
+	nodemask_t toptier_nodes;
 	int err;
 
 	buf = strstrip(buf);
@@ -4692,16 +4710,30 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		return err;
 
 	xchg(&memcg->memory.max, max);
-	if (mem_cgroup_tiered_limits())
-		xchg(&memcg->toptier.max, page_counter_max_or_scale(max));
+	if (mem_cgroup_tiered_limits()) {
+		toptier_max = page_counter_max_or_scale(max);
+		xchg(&memcg->toptier.max, toptier_max);
+		get_toptier_nodemask(&toptier_nodes);
+	}
 
 	if (of->file->f_flags & O_NONBLOCK)
 		goto out;
 
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
+		unsigned long nr_toptier = page_counter_read(&memcg->toptier);
+		unsigned long to_reclaim = 0;
+		nodemask_t *reclaim_nodes = NULL;
+
+		if (nr_pages > max) {
+			to_reclaim = nr_pages - max;
+		} else if (mem_cgroup_tiered_limits() &&
+				nr_toptier > toptier_max) {
+			to_reclaim = nr_toptier - toptier_max;
+			reclaim_nodes = &toptier_nodes;
+		}
 
-		if (nr_pages <= max)
+		if (!to_reclaim)
 			break;
 
 		if (signal_pending(current))
@@ -4714,9 +4746,9 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		}
 
 		if (nr_reclaims) {
-			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
+			if (!try_to_free_mem_cgroup_pages(memcg, to_reclaim,
 					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
-					NULL, NULL))
+					NULL, reclaim_nodes))
 				nr_reclaims--;
 			continue;
 		}
-- 
2.52.0


