Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F60D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71666B0005; Mon,  8 Dec 2025 20:41:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF74C6B000A; Mon,  8 Dec 2025 20:41:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98296B000E; Mon,  8 Dec 2025 20:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B39D96B000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:41:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DF6AC03C7
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:41:18 +0000 (UTC)
X-FDA: 84198229836.28.1EB424F
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id ED36418000D
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:41:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765244476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bvCVePLtgLDIY8bvxs+Sq3V+lxn+cPcPDagMi7uVI+o=;
	b=TGtKfozU6Kffxq0vX1bYB8jc0QYN2HDjjYplP1xEto2ZXte78NYSEcfqBna0VmNAKpjEPc
	ahmbUXbXwe2Np6uurL1V1lXngbiO08lK+mya+l4HjVDtNSsiN9yPITSSmi1LuBnr/HfDWC
	rCzdR8iWVgNHLEaIbau9bSJq59YitOg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765244476; a=rsa-sha256;
	cv=none;
	b=288p+VSmfSdS6Lcxg6Xbzia+o8B9cP37592lFHjqo7kghYIDtuO7nRustdnKZGemRZ8c9K
	z5qGVe2z8p+wQMGsdBrpbCvf8vVTOA53yixoq+Xa25vMz+z16GVdL1aFWdeBUcZTHSX+Rv
	CUdq5l4i2RVnjg+VSZX6HYaHlPaABHc=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dQM3x2mqtzKHMHr
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:40:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 325D61A06DC
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:41:11 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgBnRlAafjdpkF9fBA--.23909S6;
	Tue, 09 Dec 2025 09:41:10 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com,
	zhongjinji@honor.com
Subject: [PATCH -next 4/5] mm/mglru: combine shrink_many into shrink_node_memcgs
Date: Tue,  9 Dec 2025 01:25:56 +0000
Message-Id: <20251209012557.1949239-5-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251209012557.1949239-1-chenridong@huaweicloud.com>
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBnRlAafjdpkF9fBA--.23909S6
X-Coremail-Antispam: 1UD129KBjvJXoWxGF15Jw45Gr4rCF17Cr47CFg_yoWrXr4DpF
	ZxJ347AayrAF4Yga4fta97ua4fCw48GrW3Ary8J3WfAr1Sga45Ga47CryIyFW5Ca4kur17
	ZF90vw18Wa1jvFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRQJ5wUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: uecp4ywzxkw7s466w6cdfg4sg5pbntii
X-Rspamd-Queue-Id: ED36418000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765244474-204703
X-HE-Meta: U2FsdGVkX18tiynRDKyfZF8kR/02jj4VxD1JkNXgmHpw80pKGJxBXE9/+YOArtnNgkjFg/GGHciAfbxJ2cQehxJfxXK2gRkDmOePpf1yzakQ6+CATjOfpMkvwkKhjgV93PXZvTjC+Z+XrKbDzs2DgdcdoNaIfakx4B0gLkIDq+trwaMAb785x8vR0zTqPfQO0kAL57pZ1IsUmyQon6DoeYRHZQiycYi8Hp1H2a0h72HIa5mBi/3oqpE6l1YNOk0YQZTBr2/D+VIw7SAFMJ2NvoXyzO+3iN9FjN161c7znjhk9eGcxjE9xqWvyJsJ5Up6Umvn3xVmlZKJTG/AIYW0Oh7DPKkvWvguECooBewQV1Vta5qyRjVkc1h0rh9PmInAy1mnQCeuKlPRaarxJDI5+6AL4vGCoCE83UyCXR0qryxCpSeSVyclb5ZLwnVYx19FgwmZpEi/GSSGo77ZprNOrE/3PtFYk5hCPC1zOJU/0yoaYrztV5FbZh09lMNmD1pqFwFK+/yfBWDNdTYRHfvVF6FQNkGhW2aBdfok2nQke+FMwucZmqhB99OD2Ua/dfgnstoo9phO3lA8Mu74Vlh3hDYZukvFGNwrBuIoPV1BatYg+wtEYGwg3+pyFOx0RSaOLuFNJJcDPs8GzBptmN3M9ZRJv8i90h8FEhGeUjhhbB8ZEI+9uz1adwsybA1+zDFQH8v5hIJoi6yzSCkz4ZECRTEu/y2Ae9yJgKdjzHG1cabsCs3/ngdjMJtvLqXlq9457v7+JEsi7NhDso99Ds+fuAy6DFu/afFpvx9E4xKATfRQ5cy2onc84ZuRJ5z2xOiZwaXdso4r3o7qqfMTZmQSI5CttBfnYG/kXt5dDinolT8wUxw7JfW6O3ZU7jYYJTCtUZj4nc2PZ6GXrR3+WSTJs8sykF2Ki3yg9GRKt/L8ZWs0GzAh7dXZ/d8avxVnIulSxM9k6lvp9KO5diyARD/
 G7B1bMan
 HC8xNYtNh5JkDto9mC9dD+EDh4c5MgLu66XbYfj0FYVRVSdBD45R4FjcLnA98kPShswQyQ+NnATC7BKyP5S/oJZoXrXs14c/A/GsCIYK5uahVJp/XEUiyxQBAxRgs0WA7TPGoiSatxd2xIazOnCgoB4eqQDxstT1m+ICoiAgLftMWMWzG/WHTlOzG7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The previous patch extended shrink_one to support both lrugen and
non-lrugen reclaim. Now shrink_many and shrink_node_memcgs are almost
identical, except that shrink_many also calls should_abort_scan for lrugen
root reclaim.

This patch adds the should_abort_scan check to shrink_node_memcgs (which is
only meaningful for gen-LRU root reclaim). After this change,
shrink_node_memcgs can be used directly instead of shrink_many, allowing
shrink_many to be safely removed.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 67 ++++++++++++-----------------------------------------
 1 file changed, 15 insertions(+), 52 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 795f5ebd9341..dbf2cfbe3243 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4758,57 +4758,6 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	return nr_to_scan < 0;
 }
 
-static void shrink_one(struct lruvec *lruvec, struct scan_control *sc);
-
-static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
-{
-	struct mem_cgroup *target = sc->target_mem_cgroup;
-	struct mem_cgroup_reclaim_cookie reclaim = {
-		.pgdat = pgdat,
-	};
-	struct mem_cgroup_reclaim_cookie *cookie = &reclaim;
-	struct mem_cgroup *memcg;
-
-	if (current_is_kswapd() || sc->memcg_full_walk)
-		cookie = NULL;
-
-	memcg = mem_cgroup_iter(target, NULL, cookie);
-	while (memcg) {
-		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-
-		cond_resched();
-
-		mem_cgroup_calculate_protection(target, memcg);
-
-		if (mem_cgroup_below_min(target, memcg))
-			goto next;
-
-		if (mem_cgroup_below_low(target, memcg)) {
-			if (!sc->memcg_low_reclaim) {
-				sc->memcg_low_skipped = 1;
-				goto next;
-			}
-			memcg_memory_event(memcg, MEMCG_LOW);
-		}
-
-		shrink_one(lruvec, sc);
-
-		if (should_abort_scan(lruvec, sc)) {
-			if (cookie)
-				mem_cgroup_iter_break(target, memcg);
-			break;
-		}
-
-next:
-		if (cookie && sc->nr_reclaimed >= sc->nr_to_reclaim) {
-			mem_cgroup_iter_break(target, memcg);
-			break;
-		}
-
-		memcg = mem_cgroup_iter(target, memcg, cookie);
-	}
-}
-
 static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct blk_plug plug;
@@ -4829,6 +4778,9 @@ static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc
 	blk_finish_plug(&plug);
 }
 
+static void shrink_one(struct lruvec *lruvec, struct scan_control *sc);
+static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc);
+
 static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *sc)
 {
 	struct blk_plug plug;
@@ -4858,7 +4810,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 	if (mem_cgroup_disabled())
 		shrink_one(&pgdat->__lruvec, sc);
 	else
-		shrink_many(pgdat, sc);
+		shrink_node_memcgs(pgdat, sc);
 
 	if (current_is_kswapd())
 		sc->nr_reclaimed += reclaimed;
@@ -5554,6 +5506,11 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 	BUILD_BUG();
 }
 
+static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
+{
+	return false;
+}
+
 #endif /* CONFIG_LRU_GEN */
 
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
@@ -5822,6 +5779,12 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 
 		shrink_one(lruvec, sc);
 
+		if (should_abort_scan(lruvec, sc)) {
+			if (partial)
+				mem_cgroup_iter_break(target_memcg, memcg);
+			break;
+		}
+
 		/* If partial walks are allowed, bail once goal is reached */
 		if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
 			mem_cgroup_iter_break(target_memcg, memcg);
-- 
2.34.1


