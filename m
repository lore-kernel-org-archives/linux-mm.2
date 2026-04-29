Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F4C2FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 08:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3BE6B0088; Wed, 29 Apr 2026 04:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854446B008A; Wed, 29 Apr 2026 04:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A286B008C; Wed, 29 Apr 2026 04:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 623006B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:42:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DF6FC1385
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:42:50 +0000 (UTC)
X-FDA: 84710952900.23.FF30BC3
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id ACF4B4000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:42:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RUMX91KS;
	spf=pass (imf12.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777452168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kHHye3OD5C3a9QpoeBC/kUEHYAfNMmW71MhL7O0n4Fw=;
	b=gqrXUnOPJYYoGWmR82hIikMJQ+Cy0ZcpilJ8tv0FYYQOiH+lXhIwm1/LiO/1Y3+WUKxlA/
	7PAIrS6msmeXveUiaZTX0LshsqxzG06G2DBkHGqjlSdry7fY6T2wCZC50YV+bTozzS2Xy8
	I5My2BWbu2npG/CccYx9C3a5l4UkjlI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RUMX91KS;
	spf=pass (imf12.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777452168; a=rsa-sha256;
	cv=none;
	b=4rhD3+NE8P6JMiZq9mQNXRIeCknh8uSa7naHvjYll4+B0MFCejZciCfzoq+3g0npDBPxT/
	cZvv5HKfD04CCmyep+7b5cBAjJXHdxofrRZGnCmb8ZQ+jl6pwOdn+E6HiG3PjtRgZ77CgU
	ec1/biuiW3tUEm/GZbFt++SidTjfCSI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777452165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kHHye3OD5C3a9QpoeBC/kUEHYAfNMmW71MhL7O0n4Fw=;
	b=RUMX91KSTk3uaUQrNPKok1v0sYN/1C6TvYdMHB3ULoMGrn2LCss8ED4STcddVBt1uEjWRl
	fs2O2EQA6gSn3ixhwkHo15lOeRnPKdpg7bgHck0DIIXdlp9WULZ5ELvkhMv/5Of1PWrNAI
	8A4hL++CkWq+hBqzpF7+a0s0VtLuw/c=
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm/memcontrol: hoist pstatc_pcpu assignment out of CPU loop
Date: Wed, 29 Apr 2026 16:42:16 +0800
Message-ID: <20260429084216.186238-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 99j1996b1uphujs5n1bmdp1jnsqhoz38
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ACF4B4000E
X-Rspam-User: 
X-HE-Tag: 1777452167-127948
X-HE-Meta: U2FsdGVkX18KNA4lXOco5Sqj/joJ9JXCkj88ZrYQo6Uqab3k2opHfbd3BHX9R3CTPblpxEzCEKWcz57UaG9LX/BHtDTIyYb2WR9Iq6oMzDkWBYUZpTZX+MKO4d2VqItCpCa0Fu5M3A2QtliVx2GhHzou3Dog3fZFx/jg0rGqCFe2WR8Mks/l6xZZe/2EE7ABW45u4tViAdEfvB80/NLbXT9gVIKs9wMZJMqCQy+Gc4Xc3R0ZR8crANPjjq5JPz6CUgoIgKbCQoBbU+c4wXBgnDYD7FHEpDBDNd8eHeSXqSDuZmp7RIBVPaje43pQrdPJB5xM2VgX4+pZ+CZ6ZQRsEyf852JXllDx95B81Y1KeQdlg/LILE8M85kBy0qtlVm88G4LSWS2p7Ms5B8jOo2uQLpq2U/tKRK2a4+kdZDAwUfnZ4+P02VQt9ykJ+hMS5u5xLEo3gNEsVzxYqHcx5vXHlDVDY11G6Wtl6rLC/Qu9u27LcdbQa2/M6xN3cxHlHdrDdS8Me8uR8v7/g8QczYG7PZngd5h2hoJuFmYYgBbmJENuYd2cbEO8DoXF5kgPhubHxqHDU+iM7qSPZQcXkF9Zy5t/OGY2qnRTS9ClW9MfJOCP/Nol6wvR1bUgj9HLyLUoHfGd83Or5bHzox/khVUlsTtRzjvvDEb3+H5CvlXrRxwLtgzuLb7e8yN9KT2N9Nt7G7NToEB8ya/jLKOAdOrtA2nNvqzNBchNL4xollJ7qNMd8K1zhNeNtTRpxJJGsB/9PX8Cmv09qF1J4e3epsqckWBatwXx2xkcm28IkN9BXs35x9mhXAHtcNuUbzLlcCNf8dBKf0gFQg5N4IAzVJB5WiZJRjfw5dQ1B4u8AsPzqNUV5cThp+aaMRZB6Nn909Ms1OvL9zTa3piNMvN93/7p1Hucuw3fbwo7r02cYiv3hL4P0DK0BE1gzLEgpaMVUl3nj+8Lg/DpZ5NwY3uLoB
 MgIe2D+1
 YUBhGM8Tn7MvI54bb1amURqtmNVFf9kQPZvHXRiXO74QW54XVyvy6g32gE9w27FOG8+unPu8cMDRv65aU0gs4zee8UBUqe8K/cBF+0+EPoBBqH7HxSxGmdn0HAZMdqYTkIVCADCuHImdwrIyxyDh+hbFHY0WCZcMmBMadkgA8Jkn/nZzqRoYBq5v0ALsOhQQsky7OjLKdhy5ns2blHGtvGdTWv7V0YTIh+7+I49aOjCHOwqBP8B9gB99pjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

In mem_cgroup_alloc(), the assignment of pstatc_pcpu is invariant
with respect to the for_each_possible_cpu() loop: both the 'parent'
pointer and 'parent->vmstats_percpu' remain constant throughout all
iterations.

The original code redundantly re-evaluated the 'if (parent)'
condition and reassigned pstatc_pcpu on every CPU iteration, then
repeated the same ternary check 'parent ? pstatc_pcpu : NULL' when
storing into statc->parent_pcpu.

Move the single conditional assignment of pstatc_pcpu to before the
loop, resolving both the loop-invariant placement issue and the
duplicated null check. On systems with a large number of possible
CPUs, this eliminates repeated branch evaluation with no functional
change.

No functional change intended.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f..4f4a60e57a08 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3993,11 +3993,10 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	if (!memcg1_alloc_events(memcg))
 		goto fail;
 
+	pstatc_pcpu = parent ? parent->vmstats_percpu : NULL;
 	for_each_possible_cpu(cpu) {
-		if (parent)
-			pstatc_pcpu = parent->vmstats_percpu;
 		statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
-		statc->parent_pcpu = parent ? pstatc_pcpu : NULL;
+		statc->parent_pcpu = pstatc_pcpu;
 		statc->vmstats = memcg->vmstats;
 	}
 
-- 
2.43.0


