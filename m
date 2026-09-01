Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4281C624C6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0EB6B00D1; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A956B00D2; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CAF26B00E8; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 764EA6B00CE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08147140303
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:58:20 +0000 (UTC)
X-FDA: 85164591960.21.192FC08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 070FE1C0005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VaoAPBX4;
	spf=pass (imf20.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788253098;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OmN/OXZcg6whF+Qt1p5yK+Cmw6blyHVzSOLjIblB5Yg=;
	b=2/uKpKYOyEKz7aObVGFIUJbXa+TzPlLujsxdOp2EGMtgjtV5h02sHRVRIHMSEhpMTCP6KQ
	qOSSScbBjfmFnmf4WyL/R1j6EWfDhQBkJyiAlWU8y5WIIM9GnyHD+WnvvUwdMbrCE/vKM9
	mDqPnI2Nb0SyCByydi4Mqf+ovb6U+vw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788253098;
	b=6PLNdQSWFK3QmHi+35xO5pAsbS5QRaHHpT+fjOxs0UF/AuZ0zH3XEZtmzhJ+ccBVzUJuK/
	Go41O/lo/LUcCeTioA0SDEeQj3POjFvahrjxBtR1MB3A0XDImYbk+On63Ru+iVj5WzwHBb
	JFMocTPnzMswfHUPLZOe8/lFVDFvQEI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VaoAPBX4;
	spf=pass (imf20.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F2BA419E2;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0639C2BD04;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788253097;
	bh=At7AKn+WQ2iI4/tDQ568q/Nwj4sMXoMHy77RVQT6EGs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VaoAPBX4yW0gZ33XcEMkQYlvgaVKptCDrdCsxygWTNMey8yQJR/OINpETZMfmTKDc
	 BupBWrw2vyyjRGbB+lcm8KJquzTfoNlJ0SC0NvGztizsje6gMZre79gqcgWwwxwD28
	 W5DcUhM4ovHzlk0GVwZGtVydMn/ZmkuBzfmVe8wtjtLkIa45LJ5VK2CLYDD6DU4SAN
	 WtYnGkaw/fxZ2vfpH4o59ZWWoJkNRMVanrRUIsqcNcOaItWfYQXzzxZIdKugEdaR8X
	 XVpq+qOgU5FD5b1TAAsvmZD/wdvzLlPAM9dfXRtUyRyr0lhFJNR3EXD4yWvXBwH14s
	 Fh7ElzAzOXRVg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE4BC624D1;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Tue, 01 Sep 2026 16:58:02 +0800
Subject: [PATCH RFC v2 3/6] mm/memcg: pass the id itself instead of memcg
 for putting ID
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-bingfangguo-memcgid-rework-v2-3-8edd7f7a7251@tencent.com>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788253095; l=2276;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=Hme7alp92v7qswodLGOz+AEsobF9FQa4tLBqDCAkCtM=;
 b=c8nFHb4AUhwzs6oAknyCqJ0Pm1qLXpvYuxZxHbNmRGZsdbLVMb09sl90FHGF647pHZfMqOyHs
 cmyhPaHJmgHACPLgmtpGf/+GzZKmjR+RGTDIcB4wtk93DT2tIPbQDeH
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 070FE1C0005
X-Stat-Signature: ad5a8cbmc31s4i7ueuqcjiksj9csh3z1
X-HE-Tag: 1788253097-554391
X-HE-Meta: U2FsdGVkX1/kmjH5zguTmCPHIk7O68WZhJh2RRfnQEKtMZmJIrhimSgFd2ejNwoKl5RnherkSmyFaCv/HmPxP5yNjwseivApDZtpzi0afG5Fpxm61GNBlCrrCqReB6NMEdE856brZmCdsZDh25kc9y9XSvhUBLnxkjrsnliOQwQojRQMFaCD/9jBvw4KT/ERatoMj28V6vpndVWP76WfB58dpYOIfZ7SonOduykGi2Nr7EdTdVgZa0IjH7JWjpUYzHsls0XZeIB5B8lKSYQpo4dSVjFgRTk4E4yoO/NaiOAe5lMHeVvkBarFpMVZNO5o1R/2uGTLunIWSKgGQD1nl3o+cKEG+SnlcLnjhPl4VCMxjH+dv6GXbdOeIFjjWpR6qCKU9A0bzPxWhspDAkXKN63TNFZ3dt+YKxJ4NFWHGYMz/54H8OtK24Bo+YBDD0JwVtDr2QPMlGfVH8xisLfAIDkGESudmf27QftAw90Qi+JKnecE8ywvVaA3FvlYD/U1zFCVfy5sR1+hc+odwtUq0NK1dyK7wTgB0+jWFjoOlpGMWD9H6BjCVL+PVQR+D/FW+nl3CU/9HFBNmBgit1h1VoJMTaHBXh3De7jLu7FxZmvEirNS864FrUdS2AT8D2kuNirZf4p6bENcRvy5wo8JBLL3a7gEAg6tz0DqI6D6m0qI/9rhG3uhuN6Dc+XPXUoT0OwnlhvkHneerZJ3+pqnp/+geeY6wPxxbuDd03v5czzsZAYRwdECaQQDXBHL8+ck5ZBbVSAWr/YBP8yWDBLncXZp9TSFFLFxY8fDTM3DQgUzQo+Doh5zz8a7cws4UwnnEkD+9+JLiGpPiD5aJ7Agbp7Kj0rF0PYb0bZzJOHrMVgtffIcTpAMqxsmpDV3GgoL0ED/9vV0EQQml4WZPvMnu8yXzM7PRo+w3xm38t8/gzeuABf0p/plk01lHX1+mohbDxHrYc+tgG6vbij2yvG
 d/B7n+iq
 l28pesfHkZrjxSN5+SVn89O0ZZcJj6zWeW3Hl5b5VqL7ZnUNP+Toth0gCexvxOhR9nZDgHwz0N9kBLiebIbWyVNQZCuhwnY+blVS8DfxZs1xZL74UVWQFgD4y45Lme2YFRQvTgN5+sclnY/S6Mb/qPOU7I2YnHwp4RRJAGiMWYEdlJDc1TyTjMDldpCzCaLo98korcDx0yvcIy8RmWm/OhPEfc2aoL8fpbLmCLziQouNQKIiXTCHPyq3GhZUcris8YtvHRGWdl0KFyGU7y5A+0DSQ6PIkKE8iJmDR6D4Bw+Y+Rae08Mtzcughts68QW+E54aFTmgAFtF3IZaU5SEuMO/ZOj5U2FKcUQ+0hlmlkwJkEfHbrkp4yfFADXUFTL9ycba775MoBe5WB4cBMt24ZxEhvdfHS4n08OAs0l06bxc/sfs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

Swap uncharge knows the memcg only by its private id, and the id can
outlive the memcg it used to belong to after we rebind memcgid to
objcgs.  Make mem_cgroup_private_id_put() take the id and resolve the
memcg containing the refcount internally, and keep the underlying
__mem_cgroup_private_id_put() for the offline path that still holds a
memcg pointer.

In the uncharge path, the memcg pointer will have to be read from the
xarray twice, but we'll fix that later by returning the memcg from the
put path, so the uncharge path can obtain a reference in the same step.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ecb4fb07d7735..048c9bb0fad79 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4038,7 +4038,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 	}
 }
 
-static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
+static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (refcount_sub_and_test(n, &memcg->id.ref)) {
 		mem_cgroup_private_id_remove(memcg);
@@ -4048,9 +4048,19 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
 	}
 }
 
+static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(id);
+	__mem_cgroup_private_id_put(memcg, n);
+	rcu_read_unlock();
+}
+
 static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
 {
-	mem_cgroup_private_id_put(memcg, 1);
+	__mem_cgroup_private_id_put(memcg, 1);
 }
 
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
@@ -5815,9 +5825,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+		mem_cgroup_private_id_put(id, nr_pages);
 	}
 	rcu_read_unlock();
+
 }
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)

-- 
2.43.7



