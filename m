Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D77CA9EC5
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 21:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280856B0098; Sat, 10 Oct 2026 17:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231046B0099; Sat, 10 Oct 2026 17:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11FE56B009B; Sat, 10 Oct 2026 17:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E132F6B0098
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 17:10:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB270140658
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:32 +0000 (UTC)
X-FDA: 85307960304.27.82FB284
Received: from mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0F614C0003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KS7OyI/Q";
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.13 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791666631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AER+gKlpTPf1sBa3rZBThdr/9FCuaxPfCniPDf7hSsk=;
	b=wBBYqC77vDy+n7W+eRa3cjTD7z71r9z/MrpYbX+23o26QhGoSjQOtA6KvpjjwFuNfXtm/M
	vUxRj41AdTs0ykqTLOnFzs7PEcuIKAHTwulbbFnbmiZkxaWhpbaXTasuHwt9BM1yoKGY/O
	oAqjBZqCGRjscEw6EzI6XR5ec8nH7Co=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791666631;
	b=uTl96cSyxtQ84d8OyV+T4ZaJxXksf11c6WhOm02WtQsm6BrJq2UGe6Xby5ofASgaTPfZZv
	1WWrmlafnU3Qymw7kw6X4AW4IXKBmetYGFo4STwAGZM6H4GqNbrlFRXZbeNMABp2wro/Gn
	6UTIyWLVBfmeOY19DoG4gGzGpJt/lmA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KS7OyI/Q";
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.13 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=K4VhJxKnrOb5JULTRJwVmPmQZaODKrai9O1wrnPYCE0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791666629; v=1; x=1792271429;
 b=KS7OyI/QiwHPJLu/LUwVrDl6Ey7PH1uBA2Q9RXEHgh9MAmLjQItfSy+ETIMisXJIU72sdDty
 QRZODZzTkiSVb3qOsHbBsQYBu5lM3h1+oKQeGD0B4Uh8wQv0hRHaiQd/W3Cmnr8MuNgDYWWlBqJ
 qKpa3TnSeTZnbFIC13ivWuUM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dc4302c868f365d5;
	Sat, 10 Oct 2026 21:10:29 +0000
X-Mizu-Trace-ID: dc4302c868f365d5
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
Subject: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Date: Sat, 10 Oct 2026 14:09:56 -0700
Message-ID: <20261010210957.1350874-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261010210957.1350874-1-shakeel.butt@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0F614C0003
X-Stat-Signature: dm8n3g14bihqi799k7hoinc3w9qh4i4e
X-HE-Tag: 1791666630-724490
X-HE-Meta: U2FsdGVkX1/x6mN0lTgxghpNXAMFCB7rvwE+mLKQZjbaaZSc8EPANzx29vD+rHiL4tfcdfZThgBosGUoD5k4STQWcpP3tTD2D0Sy5Qy92GgakvJUyCC/x8HKhk+5PbBPu+EUP/rfRpn1Jl3kwvE4awsXfAutvFUq2cwb8omD80v3w7euDHiifZL6ve7VDKO605QCjamLYjbp1F5xT3F6INqKMHwFOiaOYN6MefrNiAWrrfLvJ7GqKVNdNN/2auJEY5wCIQaX5tIBdz7DgRoy6mJ1l3jxL02LA7P+x9rcdkueQyUu842Y8n9q8jXACC+3jyboBwDqw6iGE5qaEtGYZ+WHkbTTot31lgGMHhVUfBPDCJEWugxq+B3PbczGc6uMXDfseLL7+SO9atY7Ywwsos/2eUduj1jKl3DSRHWmQxD68vC1zyW3VgdT/x++67f/G+osY37TQWmGLGUfDR1tGAt+mkbGro36TzPlgsDKlh9daziXE8iNNFf17POn1nZwQ+PxWFot1/QN9Sx0eYutfOezadC5RSm83mHJZo1i9tmH6OdefOwuqQS12SrbZLLK9SW/VDoNVahMkqDlhg5Wids+xcYr6WXg6vJ6dwrEjFrOzegmgPo9ZB5pLyU03qHkPM5G73JOsdvMsuQsO0m5K69L+yAvySf6KhDZmMAH3Bkijbu2xC3GwTdJKHG16uibvocoptLRt5QPwgdSiydvCiVBVkut5ixDCQi6UPQ2jQ9wroiV5yr5Ki5dkx8DHUo+yv3zFGw3EFBYyDdBxDGbxkjn79bwTYvLWidFuXPUJefMDi+8LQ0SscO6+yTJOcz3U8z7Bn1VYLJclzJURtqg8TWmZsNwKYHv43uFI+CDcjdNJv7V0KzhjNfqDJ7r6z9/7FR38Ijy7jwThANuc0/tQxGx57CMGJx+vkrYL3HXkulLhWR2rzDC7p+SyQIYDDGysU0t1PQfCBEkUMwXZxp
 XhmfpJPU
 elgOG29qLAJYPCp0s+7ZrtusWiBbLISgWaDZlvt+VWZC4qolSdnDVXS7xxociDAS5HZEegFTVihnniJ9FWukNPTKHH5jXyXh9M1e1TX1z9cnz+arwPWr4dNldh3E0WiI68umDC/akkKNg0JU7l5mYieQ3rqC6m4ffLP5xGdq+b/ffjxaZcPVOt/pM2/3+t8/X/aS6IVTRaEyl92gD8EePlefEj4lL3Lv7CKNsqeXdC0ihVElhzuyrrjyPHvJnEFc2N/pE+PGKaFxBjRTnP113ovhbKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel threads and remote chargers use high_work when memory.high is
exceeded. Their allocations during reclaim can also charge memory,
for example when zswap stores a page.

Without a check, the high_work worker can queue itself from its own
reclaim. The pending bit is cleared before high_work runs, so each run
can queue another run.

Skip memory.high enforcement for charges from task context with
PF_MEMALLOC set when they would use high_work. This covers kernel
threads and remote charges. The memory is still charged. Interrupt
charges keep their current path.

In a VM with incompressible zswap data, the worker queued itself 163 times
without this check.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3456960cbe68..d1e022e6572f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2708,6 +2708,14 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
 		!current->mm || !mm_match_cgroup(current->mm, memcg);
 
+	/*
+	 * Reclaim can charge memory, for example when zswap stores a page.
+	 * Don't queue high_work from a reclaiming task, or the
+	 * high_work worker could keep queuing itself.
+	 */
+	if (in_task() && use_worker && (current->flags & PF_MEMALLOC))
+		return;
+
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
-- 
2.53.0-Meta


