Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC32C624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08506B00D2; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAAAF6B00E9; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FE56B00D9; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AC596B00D1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0666116030C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:58:20 +0000 (UTC)
X-FDA: 85164591960.20.1571093
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 15100C0009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kRCDP9kR;
	spf=pass (imf22.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788253098;
	b=YR66zkm+/vWdeCUOjHBKZckLk/5tsNhwh8hp1vQOVzQe1oFyO46qb99FF+7inzxyV0l7fO
	CjPiFCKTC8nvzGd6MjMPHoylfZESf4WnrzCy2lOE8Ubl8ao5CgtyexJqJ7O+bU1z7v8EyY
	/QOCxv+PtpCwTCZiKymndWurDr9F0G4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kRCDP9kR;
	spf=pass (imf22.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788253098;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=84huNxLkELVQlU/eNcQEwxG8ezQjUmmAP7CmYgdQbys=;
	b=nmZcxfaU2IMSoujviaLnhPHgNL7ReByDMAhqJy/pcZ5HpuUFg3LMqToI29b8ncCGEB/VMX
	POIZeiOfK/LnRESL8N4CLlw1bepe1+/V3CQQ2d3y706r+ZjvPZs5JkfP/u/Qp0JqTr8n34
	hoS2NxewH0JL7+Ubz4mVDcV5bZoZMsk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD4FB419CC;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6801C2BCF4;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788253096;
	bh=2rsNpbbKndbyocdYHBqGvoSTRhCZGAVV39aajeiQvbw=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=kRCDP9kRglnPQjyJSzcjD4Abzpt2HdWFARfsP7NYOJvQKKtr5fswRRJjnxHfiF6wy
	 gsPJRleHQdLRUIE7ZNGRH03IN/HReQQ5pG89j46UBJC260PPX5gIGZyEH2ylX0S06U
	 Y9//vQqqc+Cl5ROtPFzvW12eXNSJgqy/EHZXh2jEbEJ5uDZ72VZnZ25r7jyNOQqGNX
	 d4A/+MSH+2BuqjL09iBrFAZGDITjX5blBvXJnwCAMJCKlxGv9Qgpmon0tqZup1Usn/
	 EuKpyXd1KNiGvMLYUFviX+aJYITSMdDZ+4dnFHzFZsXjwutIv65hGTPepWREHP0xVH
	 TBYTpPCGqMUrw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33A5C61DD6;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Subject: [PATCH RFC v2 0/6] mm/memcg: move memcgid refcount to objcg to
 unpin dying memcgs
Date: Tue, 01 Sep 2026 16:57:59 +0800
Message-Id: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJeTlmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIzMDCyNz3aTMvPQ0oER6ab5ubmpucnpmim5Ranl+UbaupbFFqpFpanJiUqK
 REtCAgqLUtMwKsOHRSkFuzkqxtbUA5Vvo4HEAAAA=
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788253095; l=3096;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=2rsNpbbKndbyocdYHBqGvoSTRhCZGAVV39aajeiQvbw=;
 b=niyCOO6I31iqWLWbba9BN/RcyJmA4XUdfG73eXvhi2yvhf4G3il5zEqKw7xURsTT+nbknaOgH
 SEQtesn+OCHCSrV8AwoIdhtMQMgrZm5lhO4im7A0OvH0B6Hj8Ev/k12
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 15100C0009
X-Stat-Signature: rfdtkp4i3onckxarcp5xzfcuo158mpi3
X-Rspam-User: 
X-HE-Tag: 1788253097-706016
X-HE-Meta: U2FsdGVkX1/Nf6hqbNfitvCSY49Yzymq/UBwCvaavAKwLEUEdFCG4vo7IROk1RaLow3xh+VCU+d1pgRjVYzttk539KjY6vW6Upi1wUvwvqWzyDI/w49NlurWk8IpfGxnEW1DpnI4k+KyUTY2Q/0Hb7VMUEgDjNkVQWZYTCn6D6Zko/xDzYB57tVp7Aryz9nNwcm8OgGNV7T1+LUMnnyPWDEAYyP3yvb3tVPJGXrDhMZpc7F6MKDVrHwAnfPnBtEEJy7JyrH3PCbVvV+9wu78jpF9bFqfKWk2uTbOpsQ8KO1RwjTE9lcBhataCvrJS4PXKSj2sLrXIBAyvueatb1kCi1NmZzB8kpLqOC0M7K19K74PQWEDtI9DSKt7JMA77zLQ8v12c4ReHSAQJgsC5VrmuYA/m2zUqKRIsv+Foy9UUXu/76FtchAoPQBGV4qpsglhYaJtsUw9DIXDzBVhVJIXL/9cy6Xjr6QyrDuaCHPKxMlP8g2qnRyYt72vIAlrOn+R2qu3qOY8rYZ5yVrVQr/isRus3TiJesyfjzLg1XLMhqOuS3I00J1eJuUgKuSCjeTz4u6kYevozxd77EDpRNKp7oVnQJX0YdANkqeiV5SnaypgA3AURV34BkDhCWKiZDFZ3eQqdnCtTUGG/fyLFkDaetApTZf9RjoRvyiamrlwEqxBjgzJAy6WrDmVaCbQv4vApihauOgSx5Vi8etDwVfRJizsaCu9HaP7Gf/cpRnbKJ6DSiF596nfw3EbiekEZt6NNrk2BVPnydRT7fiv3FtsC0XHlVxyTwOfi/S5A+ekgGMWoWnxOAIpJ9iP1s25CzFe+W2Fd8+71xqZ52ARdRZOAG2vQXdmo1HvHeL5ra+xLcKoginDFh0rF8XPxXJTy2xttVAw6T7/QJrrQXP2QFByUFRaOjneOT8dggY2rlFR4k/tK3Sls5a27wLH9trHrH4OOzkGHYOJUn7yJwAqDS
 qy/gpjKl
 B9i75ne1tuIl1duVGLgSFfFoHI4gmV6+P/NSu+acL2KgDSwCsoMSplBhd2nwABIMwq9sLx6CixMGC+38r7DIy48Rm4J2gxquifIDbs3b3FROI9BAyJnbHtlohpl8npSoqzRTI7qOBWINPSqlZZv/wVEjCgKtP8xjiIkYtUGQ6cz+6fksACitGAfyT/hYwSJRDC5VFQEjFK5SQ+9injxjzbg5HwFlyUkK2P7Bki4u+er4IRNrekVYUQvxxKp6kr7Fr+sE9ueloZpjuz4AvaiI/qTaZh/qv1EPzsyr770p9Z9zh4zyOK74cU/zg5jxCkQTLCzMa+6eqNNIiFweRlwOQZbjj2tisbthqE9ucSGRWrxW5OCuFo9jJKDkc9dwUn1nMD9s7VsknFS11RamFoIfSw0jYF+EeB1lMzUfYbZCZtDU7GZddsRd7oLK5UuG8RdwI9ejh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Although the dying memcg problem caused by LRU pages is fixed, I can
still see the issue on some workloads that use shmem after those pages
are swapped out.  This series binds the memcgid refcount to objcgs so
dying memcgs can be freed normally in this case.

The memcg private ID identifies memcgs for objects that can outlive the
cgroup itself: swap entries and workingset shadows.  Today the ID's
refcount is embedded in the css, and every outstanding ID reference
(mostly swap entries) pins the css, keeping the entire memcg alive,
which brings a problem: A swapped-out page holds a memcgid reference
that pins the css, so the memcg cannot be freed until the page is
swapped back in and charged back to its online parent.

The work done by Muchun Song and Qi Zheng already charges folios to the
objcg, which is reparented to its parent when the memcg offlines.  This
series applies similar idea to the memcg private ID: the ID's refcount
moves from the css into the objcg, and the memcgid xarray holds a
reference to an objcg instead of pinning the css.  When the memcg
offlines, the objcg is reparented and any remaining memcgid references
resolve to the ancestor, so swapped-out pages no longer pin the dying
memcg and get the online parent naturally on swapin.

Patches 1-4 are self-contained preparatory cleanups:
  - add a helper to drop the online-state reference on offlining
  - take the memcgid reference only after swap charging succeeds
  - make mem_cgroup_private_id_put() take the ID instead of the memcg
  - return the memcg from mem_cgroup_private_id_put() for uncharging

Patch 5 actually moves the refcount to objcgs, and patch 6 makes the
remaining callers (list_lru, workingset) to filter out memcgs that have
already been reparented.

Changes in v2:
- Rework the logic to try to keep changes small.
- Change order of the commits to make it cleaner.
- Fix problems reported by sashiko.
- Reparent to mm-unstable.

RFC v1 contains some scripts and codes for reproducing the problem and
testing the fix:

https://lore.kernel.org/linux-mm/20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com/T/#m0e8ce07568e16239ba113c803f27caf308b299e7

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
Bingfang Guo (6):
      mm/memcg: add a helper to kill the memcgid on offlining
      mm/memcg: get memcgid reference only after swap charging success
      mm/memcg: pass the id itself instead of memcg for putting ID
      mm/memcg: return the memcg when putting memcgid
      mm/memcg: move memcg private ID refcount to objcg
      mm/memcg: filter out reparented memcgs got from memcgid

 include/linux/memcontrol.h |  15 +++---
 mm/list_lru.c              |   2 +-
 mm/memcontrol.c            | 117 +++++++++++++++++++++++++++++++++++----------
 mm/workingset.c            |   2 +-
 4 files changed, 100 insertions(+), 36 deletions(-)
---
base-commit: 88297631d4d42f6004cb39c0ba3da7d2d10a616f
change-id: 20260827-bingfangguo-memcgid-rework-938e25ecaba2

Best regards,
-- 
Bingfang Guo <bingfangguo@tencent.com>



