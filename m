Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14EF3D3E783
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 01:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151D76B0007; Wed, 10 Dec 2025 20:45:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB026B0008; Wed, 10 Dec 2025 20:45:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47D46B000D; Wed, 10 Dec 2025 20:45:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BDC8E6B0008
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:45:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63170C0767
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:45:24 +0000 (UTC)
X-FDA: 84205497768.15.F652EA8
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id ADEE11C000F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:45:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765417522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bATo4aD8BcreVRTbB56k5oeNz2mItAaS0yYrXnIXCLk=;
	b=cmi1Gs6IiCyHH7DKz52FaliaeyrjA2709A2LY3wMvpHT8DKAig2AL4DN7DRxWYzP5Uvzs7
	d2LBqmv4LJRT9yFI2fpkkJanBvA5roJhXC83PUHxUo5jao+TLFOTot/vmu2vs8qyPsIAiu
	4FHEyUPwPLg4sOcaFc+uf1I2sl23E5o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765417522; a=rsa-sha256;
	cv=none;
	b=wrSqHncfyP7fxJLlVdPsaZbX5CeDrXrcqk2Ozdu2M2JQMTJWscmagG/GwCFm0+DBKmwJo5
	mzvEy2gAr8l7+U0ENh2fHdjnAtxJp/xTOXlAswSL0Gd7h8OisMaPgoR7zwSAKLAQt9gN3D
	dpDkN29PkMMqA9QTdeH7+MkL7UB0LgI=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dRb3g3XdczKHMMD
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:44:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 5BC1A1A08FF
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:45:16 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgB3VlAgIjpp39lLBQ--.49534S3;
	Thu, 11 Dec 2025 09:45:16 +0800 (CST)
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
Subject: [PATCH -next v3 1/2] memcg: move mem_cgroup_usage memcontrol-v1.c
Date: Thu, 11 Dec 2025 01:30:18 +0000
Message-Id: <20251211013019.2080004-2-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211013019.2080004-1-chenridong@huaweicloud.com>
References: <20251211013019.2080004-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgB3VlAgIjpp39lLBQ--.49534S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF1fZF1fWr43XF4DAry8uFg_yoW5WF45pF
	s3C3ZxZa1rJrW5Wr4akFyDur93Za1xXay5t3s7tryfZwnxtwn0g342y3yrAFW5CF97Xrnr
	Xws0yw1xGr4Ykw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0pR75rsUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: 74wngea56ubqmi5es9pykqotmuxxwxf3
X-Rspamd-Queue-Id: ADEE11C000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765417520-228259
X-HE-Meta: U2FsdGVkX1/fPpZqBMzx9rBMNQKFbiuiqjq05rMuCxGNPiNxneMyP4FotaZQOgL6L33MbOZhQROA9Hs4K7IDLyixR8a/EUHDnrkg6Sm6Fn4vOL7Q9iI4ujqNVIsyzh3JV/HtOwl5lZtXdRVxylt76MbGnT8TlgdVXOHB1hkjiqcUgePa5Xkg46ffnrj3OvDb7a4myUHB/fZwMt0drmR1E+X7giBsN9Ni9JDdhELLrt8pc0oaBw119iQlODLTefBHfBhfZGzzR0frR7TOsn3j3p9uSDIu1ppDmXVHLsp55ouKqc2cDPVFOAR8pf+HIfnuGylKGdNg+Z9M/0+WWogRw7rvbsxZIg29D/9bOEi72QU6VoT7K7RhvRH7y1P+tmw7MCuOokSt2KPr0g6DqBwu/OrJGDyLJ/a9OmHh5u/3ckp2CoLHlupug6xiWK06/EwX7FxCJDF6buzrkqSoroPgAiIaRKuNofLFT8VF0SW3/IC4PBCgqgn5+sB/jTg/0KCjdDygbXhUrKlAbqzKb4I4Djcd9DZvz1SlYI6dr4ledaNMbtd6aP/g8LnjA2yoKwCed1FSqnnO6kD8YP8hF8Onqvupn2/ocltK1Pl15yxrIjd10iCtK4+xqoj6WB8neHpZbHMQwgBGcntCmuZuh7M5Ub1YNOsogIrbeddmJL0JQXnk8tRgpZNwU8IrhnefLPk/2F0I4skhYk1JD7e3P6iDckQ1hCq1rPC8kLAFzl0wpl3e1elDRD7qtlLvgPL5iK51Ky5Tp/UJvaXclAucz34OuZ3KtCnT995Y3XN4+O8QhmTXsjKEzRRomBGLZYaT0ywnQZ0+0INvVRxnlEPWdUyurx65zZJs4rPrGKiNQTn1kK3WCcI4AiYUKga9P3lo5MAAiNPhSgy0WfA+8nQZdhZ6ADy7CRsCvA5wXGBG4Vl9TSB+HDM0xDZ4FXpcUMsGsMqsXweThbX1D4MnR246rqS
 6tTLjEOK
 rVupEo/Gf5g+nVC0CJLb0tT7yju2JB95pyV/R0FHGos0s7AAvyCeCdw1J0kcoieEpdffiesUxzfmNwpT2VKV9OdWshytBBdJIILvGihObsUghE6Cg3VtYO+es0UydU/QDtzW8EfGQGNXBMeDNtMNC+/tjJ79ch2WrIOeAA/gSb9HjUpnx596sYfCMdO3ZtrglrPKDupbjeom/9wiyYLfqa45fQyzyknInSOPT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

Currently, mem_cgroup_usage is only used for v1, just move it to
memcontrol-v1.c

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol-v1.c | 22 ++++++++++++++++++++++
 mm/memcontrol-v1.h |  2 --
 mm/memcontrol.c    | 22 ----------------------
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff742..0b50cb122ff3 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -427,6 +427,28 @@ static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
 }
 #endif
 
+static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
+{
+	unsigned long val;
+
+	if (mem_cgroup_is_root(memcg)) {
+		/*
+		 * Approximate root's usage from global state. This isn't
+		 * perfect, but the root usage was always an approximation.
+		 */
+		val = global_node_page_state(NR_FILE_PAGES) +
+			global_node_page_state(NR_ANON_MAPPED);
+		if (swap)
+			val += total_swap_pages - get_nr_swap_pages();
+	} else {
+		if (!swap)
+			val = page_counter_read(&memcg->memory);
+		else
+			val = page_counter_read(&memcg->memsw);
+	}
+	return val;
+}
+
 static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 {
 	struct mem_cgroup_threshold_ary *t;
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 6358464bb416..e92b21af92b1 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -22,8 +22,6 @@
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
-
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2e49f4ec9e0..dbe7d8f93072 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3272,28 +3272,6 @@ void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
 	css_get_many(&__folio_memcg(folio)->css, new_refs);
 }
 
-unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
-{
-	unsigned long val;
-
-	if (mem_cgroup_is_root(memcg)) {
-		/*
-		 * Approximate root's usage from global state. This isn't
-		 * perfect, but the root usage was always an approximation.
-		 */
-		val = global_node_page_state(NR_FILE_PAGES) +
-			global_node_page_state(NR_ANON_MAPPED);
-		if (swap)
-			val += total_swap_pages - get_nr_swap_pages();
-	} else {
-		if (!swap)
-			val = page_counter_read(&memcg->memory);
-		else
-			val = page_counter_read(&memcg->memsw);
-	}
-	return val;
-}
-
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg;
-- 
2.34.1


