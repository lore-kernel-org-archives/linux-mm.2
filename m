Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A216C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0029E6B008C; Mon, 13 Jul 2026 05:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE4F6B0095; Mon, 13 Jul 2026 05:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBECD6B0098; Mon, 13 Jul 2026 05:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADC5A6B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:38:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3600D12069C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:38:01 +0000 (UTC)
X-FDA: 84983251962.22.E857358
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 817FF180004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:37:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JIDk3tx6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783935479;
	b=gsZvOZ33N8iSmrVpCXsJIGudze9HrW2C9Sb0Uh8AF1PgBkr7pNtMV4DerwNQvfIuabaiBP
	lu8lxD8a942LwwhrwvvalnrbnoJ3MTbAmiV+krZK7PQxTc9aP6ELF1DwHnJQrHhIiH0XNM
	TKPEcY8+xMDxo9+TnTCYGeX2tWhPYaw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JIDk3tx6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783935479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rvVsmNUiaRCk48qdsU4ef5SiZPZfdpdcGy8a4cIbIvw=;
	b=5EZ5AH7ZQDELVGRdZFlrmnERuGXigYw4gMF1YgZrQDRAtH3ifsrp9xs0xY7ybeEEha2CRm
	crtDujggjwX87Qc/mn+fQxuaZbi5h3aClXnEOvZvYnGaf7kOqA2i97dberNf/hfevbSbjP
	dxdzyCZCDNY6QcJUA28zSocuz4c4Wkg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783935477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rvVsmNUiaRCk48qdsU4ef5SiZPZfdpdcGy8a4cIbIvw=;
	b=JIDk3tx6AB3lAyGSfAFF9Get8nRGjzzD8GOI/dTjvMuDc1MEDecxUAeE8KNeNO9wCUw3wq
	V/H3MTaTZxqBmhIhrSplO6cWnP+gdEV5EGQro5wriG9oC1W+cqGKExJDQ3v7fTfSDQdKcj
	MsJU4thh9KxUPUoR6VkiPCKeuvZGEhc=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void
Date: Mon, 13 Jul 2026 17:37:37 +0800
Message-ID: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 817FF180004
X-Rspam-User: 
X-Stat-Signature: j4jsokgtwq4ko66ssc75rd7abw85g4ry
X-Rspamd-Server: rspam03
X-HE-Tag: 1783935479-602181
X-HE-Meta: U2FsdGVkX1/UnNkHlVaL3jSsqOJec0wiFn2IxRQY2GNtFGgxAdgGqurd/8fYTgnyaX8ELza7pzIak/08kasXYtzb8vQ1bLUAOqpW7/phQIxgdqexHxeZS15wP/mdjE5fqkcBHgerNWsp+NUPbQLsaTU8XYoEnFlAK3azCMlFgnEfWTA6Lh7ey43crD/3YrcIqIPcAoEMHCqkfj1O0kURnbJEO2olcsbQjxetZfSKv0Kwnay2kKDI8jsMt/YH6ghMHyVhKNAk2/tpu57b5YurwO46xPcPIjemmjAaytv6PYc3drUf1CV4Xnb0eG5tVsTttKcjhBdY1SRULPdh/0B5gtrhIqV4Fx06aFPfWnYxnVVR+Yy0mMK6FupWaDWQp5bjQcZef6TZ5TgW1EZewGZFzuCtYT5DXDW0eeMIv7AcFhAhlq5l7hwP/G6gex7kWlsUO+sp9wDWOsEwo7njT8XAmyUjMqOSK3chwN6/BJ8zNn5APn2ODgTLP08uabC9j4GgDODm+w3jwn7b50/4VYn4TLrAL0SXdHBESp6OsIiowoGJ0I/Jj/ovSrlAIkpu4DuE8yycL/sqKJP0YN61C9ldAg3b680LSsz3eFO5fRRVJCwA1F1X4ZjqiwY3JwW+zyTFLNtm61+nV5KEKo0VY+ODrENWA4lnNrGokY7wTbYPssHexDqaes+RZDQtgtTuDrFw/XW1fRNFtQ/R2CywWL8iTOMC3QQ9fbcMukFLfko28GekV0FWRdSooDR59yIhKCjCbtIUZYh0CXWxhKWzk+lOKfFYH/meIXjeQ4rDCYsw1YSRHqsaobnj9cVZ7GJNFGUayVNJm1KFXEHyivVXKWZzhlaMqrWSPRCQKfD3H4+88DDK4Tr3f/Ytkv2CHaPCD6PUGzFJTOjctrQRbKJg1X9ZFhYAs8wSWBkERS+SInctsW5vAFyyPEFnpzvFEk/dxw2aHHVmAQ1I+E6NsvLmG1G
 lDQJnqBw
 Po5zlDNcXRi9GCyggggutOOGpuPi5tsnB2zZuVou0ysX/+R2omit0mre84X4nN8CkJxuKmCJBS1umVobron5xrxHmGpK4uNwzyoePI3zXKMds3ROkJmju/m4IQTyql3VuQZ6V+UPAYvM1RaKi2YW3d/rjOSglh8lWYA3PqpnW/B48sfD3k0HNw8t0JIohgpZtBq08mscW+TTk0Vbu0AN+naEJr0S6bXCtFtt/PnbYShpmt0/5pzahq1lcvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Commit 7d74b06f240f ("memcg: use for_each_mem_cgroup") replaced the
mem_cgroup_walk_tree() call in mem_cgroup_oom_notify() with
for_each_mem_cgroup_tree(), but left mem_cgroup_oom_notify_cb() with the
int return type required by the old callback interface.

The function now has a single direct caller and no failure path. Make it
return void.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol-v1.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index e8b6e1560278..73bea1b5c8dd 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -752,7 +752,7 @@ static int compare_thresholds(const void *a, const void *b)
 	return 0;
 }
 
-static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
+static void mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_eventfd_list *ev;
 
@@ -762,7 +762,6 @@ static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
 		eventfd_signal(ev->eventfd);
 
 	spin_unlock(&memcg_oom_lock);
-	return 0;
 }
 
 static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
-- 
2.43.0


