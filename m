Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D7B5CA9EC5
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 21:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C4A6B0095; Sat, 10 Oct 2026 17:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F726B0098; Sat, 10 Oct 2026 17:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159206B0095; Sat, 10 Oct 2026 17:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E914F6B0095
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 17:10:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73DFC140658
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:29 +0000 (UTC)
X-FDA: 85307960178.09.A8E7BE1
Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	by imf08.hostedemail.com (Postfix) with ESMTP id 72945160005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bjXXxXEi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791666627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYFHYZ/HmsfSzg95gJwc62rtg0oIF4EFAWVPd3Taucc=;
	b=03RnbqdMUhzf6EP/k0qvaKhv+ZE6Z3iToCgi9sXfTWYqqPjObwkRKf8m9+Z0bgiYl0cTco
	4aBnLNutZymDyOMM3uMMdjywPssl4kwuPBbuYAsFSnYNbc6+V4CsoTw1GCqfxdA+saVFJI
	OtcPt53kHxtjP5PuP1/k0wkbrzoYOKQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bjXXxXEi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791666627;
	b=IPH/ZA0UzfyuaY+wiBx/zv+V10VZB12UUB+3Bs+55ht83kKazaMc46XsqGH0/Nrk+O4Bhg
	CJ6ZuS3l8cbBQZrm8tl4B2IF9CmEA2HMS4r4MMWGsCV/eDOVjoRAC1PXe2VKoYBJT1vTLP
	LPWtfy7onGqrLcU3xyhtf7BtMbJ9ShE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=I9Jbe/FzwhYUq3Ebi/TIDOHeruGUbjsfkx6G/pKSGvc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791666626; v=1; x=1792271426;
 b=bjXXxXEii3oBT+t4vR0lQwKLFoRgJlRWgclBZjpu+U5l+WWnv1jOJoxJ+N/YYY980xJI8Bw6
 6hZvnzrHnCnH5s4+SGVPGoONozOV4jrnwqRe42/RLtsZBz1Ch9RFSkJSblRw6aiBBx8uMUDuPT7
 XUV+JKQezHAgRZxF6pzaoLlo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 60868bde65bc6ff9;
	Sat, 10 Oct 2026 21:10:25 +0000
X-Mizu-Trace-ID: 60868bde65bc6ff9
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH for-7.5 3/5] memcg: use high_work for remote charges
Date: Sat, 10 Oct 2026 14:09:55 -0700
Message-ID: <20261010210957.1350874-4-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261010210957.1350874-1-shakeel.butt@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 72945160005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: enm8r953bny1b4wohokbak8iurnhnw3q
X-HE-Tag: 1791666627-145285
X-HE-Meta: U2FsdGVkX1+Z40VMbWF4Kkldag/S8tCuDvSx8b31ALSjK3Im5fh+LU0gTeoHjmHo9jWCi6O9kcCg9aTLVqRY/DpDjC5TKt3WY0hXt7i3bXKuCeHJiCnw8Z9f7O+fWcWOeytHb0X1rIOEHhuvtKoImEH8RfecgSPMDBx9tLEKFXavwTF2+/428HJMXQk0J5MoJpCH+V2XooXf1Je7h7dE+NesbU4fIOAw66h52ZD77iB0NRwco37xHxpixyqp4Qxrj8CpE3vEIEUQdigrYG3CW9B9Lmz8KnQ3yM+olhPCTvw51oaLGyi6IskO5ZLmqE/tnJh4KYn5hcWJhI0JrRF1gNpj3dkLKk8rtRjXeWx6fqfbPonzeDegqNcM2myH86QyMbfiHC+TWaDRh2J+OzfkY/RYHBGVTGDUxFHtxqWKwEg3MpwZ8pjQrRWv2E874xF1uUbWnUW6xO4JQlv9tT8A9ph61IqO0ihtfJwpAxOtisUFlWpMS7TWdIoBL/YRP6CwsR0XDJXN2QKgU9Blroz/eJcLPD3Je27oVTcrF2fKBV1TW8Xmg+sw3+faHEApo/zMH9Oko7cCB4iUamb/thz903o3yTKyzDMGPP/xv+W+TWVkeq7RgVEiWSHTFpl8Mu4jBFDntDdI3GnePS9+MRvk7qjMCnYm/g8BrVD2WPhezPf+zN3IjufIE4omZBsN3v+XSWIEyzzUA8VPA4rN51lDkMmBJkOKwLf20VLTr13SoWvSMfSCRWEJq+ZqxQul4cjcMkip+KiF6rF9qmjiPSFDiuvJE3VVTxGTjnJM90soHyefsVjLygMtUEaZ/lTvrmnlkokK6WfsAxlJFPrCvyo837Kf/hUUlLDeZswtQR50t11VEka7877pzxr1lP62jeaifkjIjlX/hu2cR7fxsahVLAtfNjfi7BFqYZCcpcHv/HUWdcLRavEXCSwLjMU2xq6rX8XsFWrgEp9cC9xjPJh
 /uUNiUIE
 Rzy8o7rHXe3CH3raAzeCNpGhq21S+TLTRMc78IwAKh8lRHQvLD7+iQs5p8i4NGiv8O+gqJWbJWE4DV4XK8eQO+45uKm7XyFAUDBUDzfCvYECz2ctVxTe5pkmCxzq9+QWjzRY7e4qDQiUQm3KnS4uXEAG7FLd/k+Age1kMFyFi3XTVu5WBHspFX+LsdPLZVTb4iJN08T86B/Pac9A1wG9vrGizbZ7StNuZNugUyPrfis2SHm6feY1BFbpanfZKWx07PAUPOvZig6RKJfAv/XCnYVoPzEiFxtHLfDKBkMZkzh/TDiI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some charges go to a cgroup outside the current mm's cgroup and its
ancestors. The high handler uses current->mm, so it cannot handle these
overages. Filesystem notifications and remote page faults can take
this path.

Use mm_match_cgroup() before checking the high limits. If it does not
match, use high_work instead of recording task overage or doing
synchronous reclaim and throttling. Charges to the same cgroup or an
ancestor keep their current handling. Tasks without an mm also use the
worker.

Like kernel threads, remote chargers skip memory.swap.high throttling
and its high-event reporting, and a fast allocator can outrun the worker.
The memory.max and memory.swap.max checks stay the same.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8116fce6ab96..3456960cbe68 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2705,7 +2705,8 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 			       gfp_t gfp_mask)
 {
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
-	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
+	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
+		!current->mm || !mm_match_cgroup(current->mm, memcg);
 
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
@@ -2728,6 +2729,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		 * Don't make an unrelated interrupted task handle this charge.
 		 * Kernel threads may be working for other tasks, so let a worker
 		 * reclaim instead.
+		 * Remote charges need reclaim from their charged hierarchy.
 		 */
 		if (use_worker) {
 			if (mem_high) {
@@ -2756,7 +2758,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
-	/* Interrupts and kernel threads stop here. */
+	/* Interrupts, kernel threads, and remote chargers stop here. */
 	if (use_worker)
 		return;
 
-- 
2.53.0-Meta


