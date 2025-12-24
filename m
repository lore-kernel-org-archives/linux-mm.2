Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71557E7491E
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 07:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55B26B008C; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5846B0098; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42456B008A; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77F846B0092
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B81AC164C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:45:44 +0000 (UTC)
X-FDA: 84253580208.28.1FC89FA
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id BAC48180006
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:45:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766562342; a=rsa-sha256;
	cv=none;
	b=LnwzYWfEU+qMfrTB4ZiALJv/wBRUPTIXXxel78S4B+aJBtECOlMqv4Tvt+OKF/tX9g0W3O
	9h/OOs1UHNUlaaiEWkHzKF6q67hA7XdV/p6NAGNdaubON1bDPDIwIK1kgyJFJEwlvSLXxy
	HOQsWmWfqLIENwN4rJl8O9tM2STbRiY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766562342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+cSO6WhghuXQuK4Gfuh8X08r83AiP2FIpLGLUgt/ztM=;
	b=4Wt8BZc86IwyhhZxZl1b6khOm+0QxZYKE2ZlnjCoyA5tiPcNv1sUwAgl/FEoGqDQaBTM04
	KbSmLh/spRkxaTDUf+tk7NKW5Fq9WME6PwBJ2XKbJs3QuL84xGQhvLyBcdhwuOvAb+Vo4S
	qHYhw57IZjwjkSy6XTH+XmHsPdFR1+c=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dbkRr4ggLzYQtp4
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:44:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id ED0F340575
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:45:34 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgA3l_cMmktp9pcvBQ--.63051S6;
	Wed, 24 Dec 2025 15:45:34 +0800 (CST)
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
	zhengqi.arch@bytedance.com,
	mkoutny@suse.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com
Subject: [PATCH -next v2 4/7] mm/mglru: rename should_abort_scan to lru_gen_should_abort_scan
Date: Wed, 24 Dec 2025 07:30:29 +0000
Message-Id: <20251224073032.161911-5-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251224073032.161911-1-chenridong@huaweicloud.com>
References: <20251224073032.161911-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3l_cMmktp9pcvBQ--.63051S6
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar15GF17WF48Ww4Utr1fJFb_yoW8CrWDpa
	yDW3y7Aa4rJFW5Ka95XF4kCayakFWxtFyjyFWxJ34xCrZagFyFga1UCry0vryY934kur1x
	XFWaqF1UGa1jvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BAC48180006
X-Stat-Signature: qkkd9kh6pcjj6nnarrt5z89qhpzyjf4s
X-Rspam-User: 
X-HE-Tag: 1766562339-298237
X-HE-Meta: U2FsdGVkX1+19MoWRSUlou32QWL36FO7oJleZ4zZAMdCLhrxmm4t4AYNqORqEmtYKnahVOX8baNnKE/ffxbqjBmzU02cliInGopE5C6/im/FMtfJFeXDaXFZEdH0WLwtdCj4SJLBwlNMOov0MNMHAKcqeS6cCa3La9Sq8e+/MKcNHEoKpLqrLijHMNDVK6QMFKXlPqOGdBOUbJVXrvJO4J+y0yJX2UQSknNJjGk2YYAsPw0z1demb3H0X5HX60kHkj+bsNqi6Qjure8dBWRmq65Nb5GaXJgpDU20d+Qbf8OATH6ikmsBUVohzGxktdOGfl34rv+q3iJWybQoJREBRCHTHwm199cZ6IwNZMb+6iWGGfc2WoMIvB8kL7N5OkycPAwML6td+GdM8DcY9Q8/aroTkbQa+mraBuEvwQ09C88/O6WDNHEr81i11ts+RKBW33kwSXF/9GC6VXdvZ1z5SczqAGCdCJ0jAbNiTbhEZ6LN+YKtOjtTpMyh0dA8xM+XtZpYpeSx1mY2OLGVpv8jhElHMtgQE+V3cpP5djwpJJu0jnv3VpmbLcfv9wuiyCi8KXawaJqNhuTjpghl7bGPIRtqevHv0275aC2uEPnCX4TCSnBE0ir0KW9oxdaSBTDoKGUiGS6WAwrufFXBw9yOwW5DWec7d8KxO2xoHE8C4GfKHAMRek7/DEcUqg/SEvKm3Wc+uuLkaD5pjbyNKtRBrmkwVElogXHfBYVzzBRMU8TnltupAuMO839Td0jrUH3E+GORMQ8gXEQIYQSeYWyvry/J38ZivLKUZ8o77+q4PjA8F/jerSEb2R+Nle7gBwgqYN1ckA4XmWc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The function should_abort_scan will be called in shrink_node_memcgs
to integrate shrink_many and shrink_node_memcgs. Renaming it to
lru_gen_should_abort_scan clarifies that it is specific to the
generational LRU implementation.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bbdcd4fcfd74..e55c7835cab5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4690,7 +4690,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
 	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
 }
 
-static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
+static bool lru_gen_should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 {
 	int i;
 	enum zone_watermarks mark;
@@ -4742,7 +4742,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (scanned >= nr_to_scan)
 			break;
 
-		if (should_abort_scan(lruvec, sc))
+		if (lru_gen_should_abort_scan(lruvec, sc))
 			break;
 
 		cond_resched();
@@ -4809,7 +4809,7 @@ static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 
 		shrink_one(lruvec, sc);
 
-		if (should_abort_scan(lruvec, sc)) {
+		if (lru_gen_should_abort_scan(lruvec, sc)) {
 			mem_cgroup_iter_break(target_memcg, memcg);
 			break;
 		}
@@ -5561,6 +5561,10 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 	BUILD_BUG();
 }
 
+static bool lru_gen_should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
+{
+	return false;
+}
 #endif /* CONFIG_LRU_GEN */
 
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
-- 
2.34.1


