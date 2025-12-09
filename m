Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 107A4D1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 13:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B608A6B0008; Tue,  9 Dec 2025 08:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0A26B000D; Tue,  9 Dec 2025 08:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9880B6B000A; Tue,  9 Dec 2025 08:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0EF6B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 08:18:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4815C0426
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 13:17:59 +0000 (UTC)
X-FDA: 84199985478.21.337176B
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 341D640005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 13:17:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765286278; a=rsa-sha256;
	cv=none;
	b=4iPrRjtoVDDSPh1cJA7Sgw9+wQ+BZ6XeS70h2TfQISy3ZkGz+MujPmzhDACprsQHHm6rYJ
	CQG8/6BO82MxqWnr3mDUTTHZLfsVxeRmFD4m7OzT3KCkDxMMT6pTnQUCFPfCI45Fy8TOoV
	7orE7tvzznSwyhyqe1lVs6lx2e+MqTs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765286278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8mhkgd/OdvX3ZOKrzTUXDY1kf5QHXNcxhFs4svF01sw=;
	b=w+V7gYOkgAdZNbYvGFYs24G2akXDnRR+h0jRkdfgRKeimIgGCYmsavXXIUE0VwycsODQos
	QOBJKrUSLCrX/OBhRxjbcc3AytuqwjbQJQZg8t0VJhg4qA10DxajKECRZYJGwWvlG5Yxc6
	iRd1IORt1LHktmnKWQp9SORCQ0sWPDI=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dQfWj5J7fzKHMKd
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 21:16:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 4989E1A06DD
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 21:17:48 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP1 (Coremail) with SMTP id cCh0CgAnYn5wIThpE+mPBA--.4181S4;
	Tue, 09 Dec 2025 21:17:48 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com
Subject: [PATCH -next 2/2] memcg: remove mem_cgroup_size()
Date: Tue,  9 Dec 2025 13:02:51 +0000
Message-Id: <20251209130251.1988615-3-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251209130251.1988615-1-chenridong@huaweicloud.com>
References: <20251209130251.1988615-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAnYn5wIThpE+mPBA--.4181S4
X-Coremail-Antispam: 1UD129KBjvJXoWxur1kur4rXF4kAr47AFWkWFg_yoW5CryUpF
	nFk343Jw4YyrW5Gr4aka4UZa4fZa18ta43Gry7Gw18ZwnIqwn0qF9Fkw18ZFWUCF93XF17
	Za90yr48C3y2k3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQl14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AK
	xVW8ZVWrXwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I
	0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAI
	cVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0x
	vE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv
	6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7sRipB-tUUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 341D640005
X-Stat-Signature: c96i4m5xuf3j3w55pnrrqdoph1gu7i8t
X-Rspam-User: 
X-HE-Tag: 1765286274-343873
X-HE-Meta: U2FsdGVkX1/6WRWep+ymMn2AAMGIGiXZ9sArA+pcy31b8Y1jraYyLyjr8SHt6/nQlh4GdMjHQalaXiJc1bfVHCFSvVjfVeYbOFcQ/4qhf3FemJWy/LQVEzPDf07baquyC7TtkaJyhFTjG3tST0RYSILiYYpf9AjVoJWOAK7Ss8ZOuy5seWl3fdF1d1MHboWITQiGF6DDuRHF++xiigXelMmYxXMM2h7kc92GSeVqzW4jNcOXv5ydLlTBtBAdqCv2/cnRq50OnT9Uxw8FKvkU+AEZF+Lng2loHKZZF4W4qBcWOXUMLHx24PgDbEd3iHSsMMmlqcbtD+4UnPCEcAs2YnLLJYx99rEa3mT93B5ME6OnV/h5AYbaHkZj335GISv7hsavc7BPm1zyCGdPZk2thrUfOUVY9kWKEz3EjrNBeGVdiqJKgFDscQf0ywiBQNa3FsvanJHVkMCCk2GiHiTZcAV5tyuyqNJVXOd9mTxcEFO56XeUboAu7m+Y5MCxHU/NvGUiBgeSJuZmImc+IHvjpXrSNIi4vmLb6vD3HT1oudefeehvn6o+68WlIJeMxYotsv70KckT9bKNxQorV0B9V6E3kL0cLMINLafYg+HF6qIEEHXxFaj8V5hV7OlGNnavLysYuJsM3hiDh06Ud5C+qwTEFuaHJYAaxjMyaLx4pNEHoC6L28oyhXXmcY7lFi/nLb+jXBREC+zbGq0/EzVoSIy++goqIPHdeTw6wCRk/0//N622LVNyFdw6V5lIlqNacKeRI5faNxc4wy4c+mtgT6MLzQGGUbyjxrOWVSKJ5zIgqyhAB26kN43Bg97ub40y5uR4KCAujgYiBektfbckQs54MBaw5l61TdqDWIKzI3EJ9dYKXuqnoR/pEiCxxsUM3nwXY7V2PQ0qH4MXU7P9fCWMq5mdG+z0VkQbSp5A+ehyTHmcTZgLz+434zGjhpG21cYuIPkFPRdy0iXCHXJ
 PAf0YaDf
 Tk+oovW5w4o8KfFSOxBy4UYO3UKbVo4tfQuKlfYqc5++UkKkCQafNNojon60UAVdsTm2s0f/Dq9lSuOZyS/vNsGIU2eEsTSAqVff0k/+xqM1AxVgx4sGyVa/pjEcJd8FRJSY54gTkk57tV4RrnUGBaSJnrwVxnBUtb8LvLnKZQZLucHd+VJeAjeqn9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The mem_cgroup_size helper is used only in apply_proportional_protection
to read the current memory usage. Its semantics are unclear and
inconsistent with other sites, which directly call page_counter_read for
the same purpose.

Remove this helper and replace its usage with page_counter_read for
clarity. Additionally, rename the local variable 'cgroup_size' to 'usage'
to better reflect its meaning.

This change is safe because page_counter_read() is only called when memcg
is enabled in the apply_proportional_protection.

No functional changes intended.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 include/linux/memcontrol.h | 7 -------
 mm/memcontrol.c            | 5 -----
 mm/vmscan.c                | 6 +++---
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6a48398a1f4e..bedeb606c691 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -919,8 +919,6 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
 
-unsigned long mem_cgroup_size(struct mem_cgroup *memcg);
-
 void mem_cgroup_print_oom_context(struct mem_cgroup *memcg,
 				struct task_struct *p);
 
@@ -1328,11 +1326,6 @@ static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 	return 0;
 }
 
-static inline unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
-{
-	return 0;
-}
-
 static inline void
 mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *p)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dbe7d8f93072..659ce171b1b3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1621,11 +1621,6 @@ unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 	return max;
 }
 
-unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
-{
-	return page_counter_read(&memcg->memory);
-}
-
 void __memcg_memory_event(struct mem_cgroup *memcg,
 			  enum memcg_memory_event event, bool allow_spinning)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..35175f7b7f6e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2485,7 +2485,7 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
 		 * again by how much of the total memory used is under
 		 * hard protection.
 		 */
-		unsigned long cgroup_size = mem_cgroup_size(memcg);
+		unsigned long usage = page_counter_read(&memcg->memory);
 		unsigned long protection;
 
 		/* memory.low scaling, make sure we retry before OOM */
@@ -2497,9 +2497,9 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
 		}
 
 		/* Avoid TOCTOU with earlier protection check */
-		cgroup_size = max(cgroup_size, protection);
+		usage = max(usage, protection);
 
-		scan -= scan * protection / (cgroup_size + 1);
+		scan -= scan * protection / (usage + 1);
 
 		/*
 		 * Minimally target SWAP_CLUSTER_MAX pages to keep
-- 
2.34.1


