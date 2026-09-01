Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06254C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120456B00DA; Tue,  1 Sep 2026 04:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD0A6B00E8; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5BA36B00EA; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C42E6B00E6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F7411C1E84
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:58:20 +0000 (UTC)
X-FDA: 85164591960.29.B89AC06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1D496140007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FKbRx7OB;
	spf=pass (imf23.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788253098;
	b=Ojm2MZqgeV/d0r0D5SdZbt25CfcKP/HIAgzuhD7J7/ncGIRiGTSOv6jQ5ygGX1uQz5UngT
	FWQJR8w7eONAhnao9Cb1ht9lbPAnkDXzkt+wOJJnd8SB95npHrRYgmfnifSfYzkjN0cyta
	URAM1ldHgpwgmuEBXvm3tu8Y7044/X4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788253098;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzFam+ZYlGaokSMN4UXblBa8dLDiVcmEpUdr0MeDDKo=;
	b=W21rhgBSscRATFPh03+twjhdK7YSzlzG00NEc/Oz6BJmBK5fPKCoXxRRty+uiH/Wi8yTTm
	4WcPCjf4CvlzS7eH9yVruy6jvsmsgvypAVM5ejcVspgjBmbFoipcsicSlp4NNnpAcSJF1F
	ESdP2eZreIPSVi2QQ4O0ugg2CeKLWew=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FKbRx7OB;
	spf=pass (imf23.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31ACE419E5;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D05FC32786;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788253097;
	bh=e48zmxDz9kiWmbI8h/PlXtcqt9ITTR5UArZLJzZ8S+M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FKbRx7OBlFSonSo5DUXAwFKpi3N6sW1nqpa6N/s7w1GujUVkcsgUjiW5bBrBolTld
	 I2zMqn9o3ILxUJ1dbl7HEPwQ+kg4GefQbdE8gu5NJ9Bid967ZyrWFsy85inIn1MAPz
	 dgYw/+CZ6NmBy3aec6QMVw3kZRyLgCPWl4msCWzeakivNWjgH1VSyYXRmXH7GJrOzL
	 6tL6B2fe5YOAZXDmU96Gc1WqpMppP7Bp0V6alvfdWh1JIFB5i11abW78xPGNAMpw4d
	 d9etcydeRFwgG/qiApsIZgQcFzLRq/yZ32o6LihXjaRpOP1DziB2Bbbv6fj0ARoX9M
	 MK0kJiaKighag==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D00C61DD6;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Tue, 01 Sep 2026 16:58:03 +0800
Subject: [PATCH RFC v2 4/6] mm/memcg: return the memcg when putting memcgid
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-bingfangguo-memcgid-rework-v2-4-8edd7f7a7251@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788253095; l=2395;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=A1qQqLP5yDMt8FsMtFOg0bivZFdxXUGUKPpa8uP9vSI=;
 b=SDxnNZGTvufnF2pzh/K+4XYnYFWQcDEg+BL0G/Mxc0c0jXuvvOso6qj3wfuU3pFeXELjN/juH
 /qvaZjgC7g3BEC0Brs8fdvQp+grYKljsPUo0sOADm4168oeOHGOopSQ
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1D496140007
X-Stat-Signature: rkjsc4kff69buf1iir1ppr197ttpkpnh
X-HE-Tag: 1788253097-887225
X-HE-Meta: U2FsdGVkX19dmIyJHELddEjGl2rfOx3hx75Sf+vUnOR0O+A/Z5JFXWjQAU8oxgZs6YM6dHmAIDpfQnZMGdN/PjdiGkyJ38F8I8atz79ujtKl+yU18vAqbY5EBH+rg4Z30zCoA50BolizE6f/WhWL3/oWC+fvKFwXIOykyOwJV/T4kGOXFaNhyXmm/WsZBVKosq5rlNNMIS0jjFOm1cKqiJiPJr0AHTgg6GDcIl7NE4K+MWGuvFDMyGa2U2ql+3356X5Ul4M6bsyoRfJ61s8D1vEP2Kqc3HYfTfqY1zz35d/SpIrLEUY3Ch7vEVEB95qUn4syDqMviY9n03v30iD50VnBtQqTdDVmK2awON0ZwczF9wXpIaksoewD7O3gdqFh4ugCaSx0LBJ+y8wwvwKv2ezJGu8YJqBdA6EaRPFgyAJRNLK0YgaAi9AhqlwgB7jq7+kXQ8a5JJlCBb0IOyQRUihCFfnpj05LBYMm7YNax70z0akQzsYK0LNw1yqkWMUcvIrp7JR5wrNlQ+emjjiawIlvfiFG4Cq/r4uKavgfY1q97nCAU4ow6wKaz07WN5MAE8o5y+2saop6FDQ/S1Vf3l1wemZExGupLOQ+ZOTkzU6SYT95yb/WijMYRgKGFToP8SPlEc5aHdoE58YeCX7K48I8VzMIJ5irkxddVpj4ufBU9L/SRly9CLZJpL5Oyk3mt1LhklshaS9lxHaD/Dw6lliRxqFtO+PxwJAODrTWmmRHUGsRIsx63iBYLulH57MfrD8lMRHUTGfZWwtUjZselh2elF4IY+dha65GMmI4jkdpIhDulO+XQrp3q2CNiA+2fOTU+g8ANv3rMlglWM+WHATzuOO9l92EzdBs1ZPiiqg0UWXPwNrHN7YXr6YZWKg5AmtFLvreVgBQbcGuYZ2ng5rgciz+0MrSIu23XxFEWcJ0ix8MiYzjpuygIOCen+LnVeg/Hm3Qqn2qE73lUI1
 Jx4jtwNi
 m2UCL8Cv0Fec+/xQAeyGen4oh7yKNJfN+sNyX8D/Gp8iW/0pRcTAt5sIO0tjl8RisduEUFJM6XylWsVXuCjgPkfqRkfL/SqnGAdjkN8tkRnCFcds9qpEeX+UyeGYiMRHZeNAMBXW21pLUZ8A0ocQkBLzcEdN+yD3uhq64G2EiaUjIUDvA44TLq/bVAbgLPYjt/xlWpWb79mjy/1E0jHrZoVjLdxxtSFtImGI+Ndt0hexVhlXxHUQEczBNyhciOOXp66Hosc1ghNZ26b8B2Ku53cUePuSqr86jLDBtNWNtiJtLj+TuNPF/8hF7Vy19piTvb1L3SNg7qW5EOQqVtMTA1RxSqDkxHALT8vJrj10Igv5sM1war2t14Hb4dCQ93fj0AyJoluyo10S+hbhtcL64z01jMaeAwVw02nIUjiEJTgSq5/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

__mem_cgroup_uncharge_swap() needs both the memcg and the id refcount
drop.  Right now it looks the memcg up by id, uncharges it, then looks
it up again inside mem_cgroup_private_id_put() to drop the reference.

Make mem_cgroup_private_id_put() resolve the id once, drop the
reference, and return the nearest online memcg with a reference held for
the caller.  __mem_cgroup_uncharge_swap() then uses that memcg directly
and drops the reference after uncharging, avoiding the second xarray
lookup.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 048c9bb0fad79..f0503a1e5492d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4048,14 +4048,28 @@ static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n
 	}
 }
 
-static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
+/**
+ * mem_cgroup_private_id_put - put memcgid and get the nearest online memcg
+ * @id: the memcg private id got from mem_cgroup_id_get_online
+ * @n: count of references to put
+ */
+static struct mem_cgroup *mem_cgroup_private_id_put(unsigned short id, unsigned int n)
 {
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_private_id(id);
+	if (!memcg)
+		goto out;
+
 	__mem_cgroup_private_id_put(memcg, n);
+
+	while (memcg_is_dying(memcg) || !mem_cgroup_tryget(memcg))
+		memcg = parent_mem_cgroup(memcg);
+
+out:
 	rcu_read_unlock();
+	return memcg;
 }
 
 static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
@@ -5816,7 +5830,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_private_id(id);
+	memcg = mem_cgroup_private_id_put(id, nr_pages);
 	if (memcg) {
 		if (!mem_cgroup_is_root(memcg)) {
 			if (do_memsw_account())
@@ -5825,10 +5839,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(id, nr_pages);
 	}
 	rcu_read_unlock();
 
+	mem_cgroup_put(memcg);
 }
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)

-- 
2.43.7



