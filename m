Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCE68D2CE17
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 07:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19BC06B0007; Wed, 10 Dec 2025 02:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A0D6B0008; Wed, 10 Dec 2025 02:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011C36B000C; Wed, 10 Dec 2025 02:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0FB26B0008
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 02:26:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DF3E1A03CA
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 07:26:48 +0000 (UTC)
X-FDA: 84202729296.09.48DEBFD
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2DD3980007
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 07:26:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765351606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BOyAi8pAgfF9LoUJLm8S1NFc1ZVcYKUmpUwWkQUdh4Q=;
	b=H3CdQ7QK1lYSmP1lccZKzORwJk0KUVGH/Nyc90pyB8obNsDMIr1vgpdRco8mvEY/bKX7Uy
	igFYu6KTS8LzlknT2oPcTO159aDjH7cRo5OEx7ASZe/6HjJw+3FDTFbCK/QMmchisq4VIu
	POL5yyZNayAeNwcNeaEdqDSL3bP4rQc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765351606; a=rsa-sha256;
	cv=none;
	b=YsZwa7BEVjnvW/C9w+70nOLS4rw765FimFRmlBxeT/HPnLrpj4Ewm+TuOhzkHwldurfqT8
	ep/Lntp0tdIgBh1moOziFqKnbNBKCzzDnrNPtgeL4Gy1DyXdr4S1qwcyMwOdmI9EAaRYQf
	5oW1wJPh+m5Q0ajPIlUV+ciFFB7RFOk=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dR6hw6CSKzYQtql
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:26:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9A97B1A1B5A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:26:39 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgC33pujIDlpfef4BA--.9918S4;
	Wed, 10 Dec 2025 15:26:39 +0800 (CST)
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
Subject: [PATCH -next v2 2/2] memcg: remove mem_cgroup_size()
Date: Wed, 10 Dec 2025 07:11:42 +0000
Message-Id: <20251210071142.2043478-3-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251210071142.2043478-1-chenridong@huaweicloud.com>
References: <20251210071142.2043478-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC33pujIDlpfef4BA--.9918S4
X-Coremail-Antispam: 1UD129KBjvJXoWxur1kur4rXF4kAr47AFWkWFg_yoW5KF4kpF
	nFk3y3Jw45trW5Gr4aka4UZa4fAa18ta43Jry7Gw18Z3Zxtw1YqF9Fyw18XrWUCF93XF17
	Za909r48C3y2y3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRNiSHDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: cgzcoftujthfxefhjx1hwmj5n5yyxjag
X-Rspamd-Queue-Id: 2DD3980007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765351604-860531
X-HE-Meta: U2FsdGVkX1+x1ds7jVPk1nqV/4vVEZDBLO6mF0B0N6clg7LiEEzdx3g7/6P4GmX6NwGJeEkcnMnibgmsgP93BPpE7xqi1FJyS0K8KVk7CTijKmc96JwqNP6EE0nblbn9joNVBontLPr+/ZF2Kzj88PEBb3hfhYdX5e5Nr1O1uakKcTzfeWh6pYZ2B9zvstw+TlLRbfis4HjkRUVp0cSlaY5ot5sSuquC0w02kcpW2T3ShxJgqFciV3v7yLRo1nNXip/OE3wYxMVm6BRQR3fnaUhNSvKQsMcjmLNzaNjGuvnFktvXp8VTgfUFGwtgBQKfbuRZCozWOIkml9zevom3PltXf8y/jg1gCq/5yTKoVOQAF3wVxb5JgkogCvEd7zqT4GFgB9WpZnkgcdseEmZY5jcjtl9IgXpr1p4tn0bUTH9qwQuzZC6TpObdiw8ybrTYr93j7twgbLf/WgAU9ztmlXvKF5QGJUmkyS23IhW2RUPsV1MY5kequ8Cbv5o/OGiwSb0Ll/8qoGc7SUTz8opjwrawjcI1G4np7KthycCIAmId/2/55v+XtSuQCygnavFVbz8QOQ8u4yrbyBNXjFqybHM0oUMdZz//bEfbHuQJ6B6XE4RCaSaijAZw723SvvvHow8A+v2rkYKHvTuxImuFg+eD3jZEQfvhpXfJ4jnud/8dweEIITHycLODZRxDMVWnb9mPHjaKWTB/5Ker0pAURZO1Pb/1c+n9Tu6r97pYreeFSlHFWEfVxAa/CR8PFvRLJAaDzXnO0X1r9eECF4KdMNddKNDFN687RYpFIBaMkN9nUUuOcOh7opQ8Hawn1eQZA6+BNWhQk5hmRAkZ3fbRRcpZ2Q5+2LWRg9rQRNiM8Rw9hWM6Wmn7JJx04JloH9BD9Ln8kIMgne7rH6j6Zrpl/8zNxExEQku5LlKPk9jY4SPYAb1ZfPlhQy5pRa6KGHvl84SAoJFGf9c7xv4/2J0
 Brj2frna
 52/6D1oYj65h4Cyl6g/EgLIuFkO+Tbd4Yp19WRYTwQ/jwTAuaV4A6rY9pvAoMTMXfK8BZi7GqdgwH7c552PBYe4v/9onHzWuPocUr/V2TaNVCsYWD3N+wihUSGJ6YN4CHii6PqD49elJoN16knYanGGdYMeR4ZevmlgWg8vFNlEgWtHwrJ9WnlebbAw==
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
 mm/vmscan.c                | 8 +++++---
 3 files changed, 5 insertions(+), 15 deletions(-)

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
index 670fe9fae5ba..fe48d0376e7c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2451,6 +2451,7 @@ static inline void calculate_pressure_balance(struct scan_control *sc,
 static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
 		struct scan_control *sc, unsigned long scan)
 {
+#ifdef CONFIG_MEMCG
 	unsigned long min, low;
 
 	mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low);
@@ -2485,7 +2486,7 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
 		 * again by how much of the total memory used is under
 		 * hard protection.
 		 */
-		unsigned long cgroup_size = mem_cgroup_size(memcg);
+		unsigned long usage = page_counter_read(&memcg->memory);
 		unsigned long protection;
 
 		/* memory.low scaling, make sure we retry before OOM */
@@ -2497,9 +2498,9 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
 		}
 
 		/* Avoid TOCTOU with earlier protection check */
-		cgroup_size = max(cgroup_size, protection);
+		usage = max(usage, protection);
 
-		scan -= scan * protection / (cgroup_size + 1);
+		scan -= scan * protection / (usage + 1);
 
 		/*
 		 * Minimally target SWAP_CLUSTER_MAX pages to keep
@@ -2508,6 +2509,7 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
 		 */
 		scan = max(scan, SWAP_CLUSTER_MAX);
 	}
+#endif
 	return scan;
 }
 
-- 
2.34.1


