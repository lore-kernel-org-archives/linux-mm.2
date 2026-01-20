Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81867D2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42AB76B040D; Tue, 20 Jan 2026 08:57:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9C56B0417; Tue, 20 Jan 2026 08:57:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4BF6B040E; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 32D2A6B040E
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDF368BFB2
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:57 +0000 (UTC)
X-FDA: 84352495794.26.F3D63FB
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 71065A0003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768917476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P4LBzUqUsTiZbRe/x20yajMjz1EO1EwZ74HsKs3uBXo=;
	b=XnoR+lj6lUqXaMfnG29FgyPTf1/ecaCpnT7AZQwfj4314nOZ/9ScZSr9mG6kY8y3zWX9NS
	gWuwAVyqyTndE6cD8U6D5PRSSOvjtdC/w5cts89HLWjLVZbIppLOLsq/Dy4y+yx84Gz5Sw
	5W/dfQjeupQJSMMuHjiLlochrlz6ixw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768917476; a=rsa-sha256;
	cv=none;
	b=00xvXEZ4KOeQ4a5BSDlX6LN/HPzmV7It/pr0CAmyEdbXzSmyzymHo9iJP7IUsucU5FKeGZ
	IW4/ZvdRcplS9dto8FG4tvYkTsuUJS6t0IQv1yHPhQadyfuxWTLfrPRFle8G4FZ76oGBkH
	u5NqXr4LkJXj/IHgoqRZHOkmvQaSnBU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dwTQP4yZJzKHMkg
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:56:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0E91740570
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:57:47 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgCnCPnQiW9pwhTxEQ--.10691S5;
	Tue, 20 Jan 2026 21:57:46 +0800 (CST)
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
	skhan@linuxfoundation.org,
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
	ryncsn@gmail.com
Subject: [RFC PATCH -next 3/7] mm/mglru: rename should_abort_scan to lru_gen_should_abort_scan
Date: Tue, 20 Jan 2026 13:42:52 +0000
Message-Id: <20260120134256.2271710-4-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260120134256.2271710-1-chenridong@huaweicloud.com>
References: <20260120134256.2271710-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCPnQiW9pwhTxEQ--.10691S5
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar15GF17WF48AFy7urW7urg_yoW8Aw1DpF
	WDW3y7Aa4rJF45Ka9YqF4kCa43CrWxtFyDtrWxJ34xCrsagFy8WayUCryIvry5u34kuF1x
	XFWaqF1UGa1jqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2
	KfnxnUUI43ZEXa7VUUbAw7UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 71065A0003
X-Rspam-User: 
X-Stat-Signature: 8yxhsicawi1s8qed8rgn7tomx1ya65ps
X-HE-Tag: 1768917471-611027
X-HE-Meta: U2FsdGVkX1+0QWAB5EMsvRTer8yXyOGU4JTeDGfskK2DhcBGlOaPClkFJNC1lZVJv5JsCnyZn8wEd/xK6TbFr8N/qqXVMQryYAYGZd7FtAmtxKaD97e5u10Q49LXmEmaOKwvSQvM/ydnK7fb9tmFCoXExMQdyOdW4AzSS4i7G/DGo2tNqt4XVMHBXYHizjlINxoZtgbmdzB+dCHHCrT/+rZ2/NHNThxGXZw+Sji1aT3GBktvigG8KJ6jgTWo79uteg3qyyyarmmhnVz98uP1sVYsy5+bUP+Nv++hoD7SpJimxLW3I0VZ6l+4vPky4n0qcoOsQvSQMNv8lOvzwND1IQQgZfMmFzUSi4S+j8O9yEWTbh6Jww2HjwrqaTvyX33+lvJ8rZp+Xwemvcmh9QCe4CrWyvmtNwGzKmYPH5PJkyqm7rFfk7eUbtxv5UJUt2f21QaDjBqCiB8SYOieZORsXjyGNnDbmP3qJd8jxgdLDHCcnrTkdWkWSXX99txpiQdafLbVH3Wc57Jzm2pZBy39cS+KkcnVr1KT4gfEE0iLk+Rw5W03aWWtx+urdXOz8k95V1eyOD5FiBr/BvN4S+8cvjEMYjr+4kOG7TVjC9AanZxB92KDGrnUoRooWNG4CyNs+26adNmCmzMxncPc+q8jzAOAPnWj90XD3QL6LSPuNS09f7r3Kj6cgs2ho3vsqT3CmmkNFD/se1YMgYL5OLlzj4Ma7cHXubWAFjqs+BEz7QiX9sNyoCiouDnsicEV/3uOavJrQVUrNBGXY3RII9RSH5rwusONjs3ivHexFISxfY2o2U5YtIDnh3Kf6QHM0wQL7xYFV1dxISQCm8TIHDkclFJZjYlFA0jpMIgaWlYRux/WrokERVXw9Vu98Lejs4jJxlAVyup8raBjyW8oayaIRR0+HHH+0/I1BYS6Ua2Yf0v/n5/K4nHKcT7FMQ6VpL/swb48YZfE7oeg5yW+490
 l3La9k9D
 +gNLUDCLAgeVApORywHxYATjvgUlevKgpLHaynxeqW+ZSYWSqBkNZ93o3ll+b/2Q6Sv9/mW1gbg9yKCK0E4WbC+6sPjyYLIxgDDIp
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
index 5a156ff48520..ab7a74de80da 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4855,7 +4855,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
 	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
 }
 
-static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
+static bool lru_gen_should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 {
 	int i;
 	enum zone_watermarks mark;
@@ -4907,7 +4907,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (scanned >= nr_to_scan)
 			break;
 
-		if (should_abort_scan(lruvec, sc))
+		if (lru_gen_should_abort_scan(lruvec, sc))
 			break;
 
 		cond_resched();
@@ -5011,7 +5011,7 @@ static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 
 		rcu_read_lock();
 
-		if (should_abort_scan(lruvec, sc))
+		if (lru_gen_should_abort_scan(lruvec, sc))
 			break;
 	}
 
@@ -5788,6 +5788,10 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
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


