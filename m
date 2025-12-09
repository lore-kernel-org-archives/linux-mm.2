Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D7FBD3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A506B000A; Mon,  8 Dec 2025 20:41:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656376B0012; Mon,  8 Dec 2025 20:41:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284C76B000A; Mon,  8 Dec 2025 20:41:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB32E6B000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:41:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7887F8981E
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:41:18 +0000 (UTC)
X-FDA: 84198229836.14.DE4C8F4
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id DF6E81C0015
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:41:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765244476; a=rsa-sha256;
	cv=none;
	b=LvlaW7BLAdsfe8eiSGmuBpxQXVJdhEzAUPOquEKSz6aK9jq5mG6FnYBMyzgVsZCQ39WRL4
	k25XNdCm1YSHvbzLjIrvI68ymGSlR0u6KTOfRTb7Lg1pw8Cm731zxWm07vj4EKynTW9DXI
	duLcSXy915EXdilQ5ZwRcaIaMYTHKmk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765244476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=11At4c9MvfjG1OeHfj3uDrmiEynCLHwSNgVvyp6J9EU=;
	b=wE3eT0yLV3wORQxPr30rBGvJPBGO4VJ7TJDFwoCVJu7K00YJN0uUSAuByWkN48F3LHhgV0
	i2CGufBp5kXbH4QPnIMawvk/I4eAetg3UDxKa6/Ksv7pOC416yRQxBqBpaITxAdOB8UOFS
	A3VqZey+L3L8Y/72SxSWGHEVGo9ee/I=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dQM3x3TWnzKHMHr
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:40:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 4E9231A06D7
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:41:11 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgBnRlAafjdpkF9fBA--.23909S7;
	Tue, 09 Dec 2025 09:41:11 +0800 (CST)
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
Subject: [PATCH -next 5/5] mm/mglru: factor lrugen state out of shrink_lruvec
Date: Tue,  9 Dec 2025 01:25:57 +0000
Message-Id: <20251209012557.1949239-6-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251209012557.1949239-1-chenridong@huaweicloud.com>
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBnRlAafjdpkF9fBA--.23909S7
X-Coremail-Antispam: 1UD129KBjvJXoW7tw1UurW8Aw1rCFy5XFWUurg_yoW8try5pa
	9xG3yUZa4FyFn0qr9xJF4DWa45ur4UtrWxJr9rWw18CF4Sqa4rK347Cr4Uury5Z3ykZr13
	Xry5Gr17Ww1jvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRQJ5wUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: DF6E81C0015
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: y9ru956qfdwnzgouud8xpymryhiehuu3
X-HE-Tag: 1765244475-709057
X-HE-Meta: U2FsdGVkX1/S418I2+c7nvaGsY5L+VSq1zhWlvr5flD9HVIsWkX1KCUPypKtMuuqMOlDG/9yXH5PQebuzZK6+lyofXHvWByq4bm13vmJ2zTgnbToPnx1jS2rAQyrj+A1Shi7Qoox3JirMSyM4EAF5ZC87ywXaIEFKedBtD+V9GV67nLtFxpvtA+dJgKMTqGClyKFPy3X8B5Pmt0N5EeIq3ginJlLQhtJDIYa5qmdwVMhDJHweXtCxJF0nSb6LZJ4Az6erfQDH6XaIKOn+BBDv3OfM714VgLvp6xTq1m73Yf4YNs4vuEj2RsIfqMdhM1vOnyaHYkbKxX1Bi9jvlhjTgn+3NtZyemOR36oNdEYO2F0ecf9oVZDD3FKlIKbJZu/7GxnGkzjvSPS1cjb6zLrEnD0PT9NYUOtVtOmYvvigidx0I7uTIFNzM8XXAT32CfXYeL+dPRpATAAtPmZMBdRKKxsphPbGbV5ASy0libayWzx7+dbea3zzNJTyAzT6YaBqJW/xrK7MNgene4LmXq2E46zOxZ7ENn3BB+c21qJLXNKNyMlIjSXZF4pfq8OmaIYw49DdLPutM0549Jcd8gABFIbphNxo2aFIrYbg27SyU9hA5ytwFFO1pm6UMiOGmmAKbz5KIuQnM2LDiGpHkJdUSj9YtAtflcs8/lq9gthDVVy1GoVCZ7ANS3eo58u3qARIDZxvXYMnENSY7E/mnG9T92Z7NPa/gtLqsjnnHWOmIa1Valiv0Wpz/Gf6XnvWegHk/EAOhBY3W2ng7sy0iWsrobS0xF6+MFr8TpnSsX//d0KdC4/ETSBl6VWGiMlni838D++G5odtBdRzTdLD0D3PusnjCr8ETjYks508SvG/USwftT23znim+uS9tXBHf+5jLQHkPRwHLwRh4bJ+EVnyfL8SZbx4NkkdLjHBb0mUKLo5QwO9lgtJl/FmCdZ8JBOJgetoeCw2IqOY6xKPHa
 yTmeTd45
 X2vMvIuX4phWw/hh31Mgcd0wj64hRvJFjrUat+RUsdredcr1dePuxiaI84HWbvqIJ9VYDxxFAGPwLEQSu1a2Iap3VsDVdUGxD7CftMmNS8E0h+xtQblpwIXW+mwmJwA5yVTfaqGutkOFjvU4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

A previous patch updated shrink_node_memcgs to handle lrugen root reclaim
and extended shrink_one to support both lrugen and non-lrugen. However,
in shrink_one, lrugen non-root reclaim still invokes shrink_lruvec, which
should only be used for non-lrugen reclaim.

To clarify the semantics, this patch moves the lrugen-specific logic out of
shrink_lruvec, leaving shrink_lruvec exclusively for non-lrugen reclaim.

Now for lrugen, shrink_one invokes lru_gen_shrink_lruvec, which calls
try_to_shrink_lruvec directly, without extra handling for root reclaim, as
that processing is already done in lru_gen_shrink_node. Non-root reclaim
behavior remains unchanged.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index dbf2cfbe3243..c5f517ec52a7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4762,7 +4762,12 @@ static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc
 {
 	struct blk_plug plug;
 
-	VM_WARN_ON_ONCE(root_reclaim(sc));
+	/* Root reclaim has finished other extra work outside, just shrink. */
+	if (root_reclaim(sc)) {
+		try_to_shrink_lruvec(lruvec, sc);
+		return;
+	}
+
 	VM_WARN_ON_ONCE(!sc->may_writepage || !sc->may_unmap);
 
 	lru_add_drain();
@@ -5524,11 +5529,6 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	bool proportional_reclaim;
 	struct blk_plug plug;
 
-	if (lru_gen_enabled() && !root_reclaim(sc)) {
-		lru_gen_shrink_lruvec(lruvec, sc);
-		return;
-	}
-
 	get_scan_count(lruvec, sc, nr);
 
 	/* Record the original scan target for proportional adjustments later */
@@ -5708,8 +5708,8 @@ static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
-	if (lru_gen_enabled() && root_reclaim(sc))
-		try_to_shrink_lruvec(lruvec, sc);
+	if (lru_gen_enabled())
+		lru_gen_shrink_lruvec(lruvec, sc);
 	else
 		shrink_lruvec(lruvec, sc);
 
-- 
2.34.1


