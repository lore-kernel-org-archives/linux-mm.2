Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C787E74ADE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 07:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2136B0005; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7357A6B0088; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609406B008A; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD656B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 00FE1133F4
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:45:43 +0000 (UTC)
X-FDA: 84253580208.02.006B9CB
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6214F1C0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:45:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766562342; a=rsa-sha256;
	cv=none;
	b=8dPrhqVvbEPrCL5uFPRKn3M1JQeCTZFBYeMZfwSiLnIxhT7R6LAsYDwfASTB48pMW3Tvq1
	Il479PCunp8w/p5jfB6pbbFIX0gpSd41yf7iY4p5bSR0EwGq0W6y5x7jZi15JUBiygcTU6
	ZW+okPxYvbR3Y/C1kjdhmqiJQ+F92A8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766562342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6cUfqmEFnrq0YItbXJ14PLNpD5SI37XY0kYlZr87vX0=;
	b=u5MkdYx3gAYSSH9DYh8x7vGiewnNdtsuL6xeqq/7e3Mu8mQ34mmxU7efbNakCqlnAKaZ4+
	7Gw+hWzLG9PRYQXrY0WgcZSgBCHck8ld2DikhVHVNV8t3raCOHiJMPHi1nG+YkZgfeQJMg
	ZUdTy3o6jMaQKCwDzOqpUN5nE1cCsBg=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dbkSC5y5jzKHMNw
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:45:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 56BAC4058A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:45:35 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgA3l_cMmktp9pcvBQ--.63051S9;
	Wed, 24 Dec 2025 15:45:35 +0800 (CST)
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
Subject: [PATCH -next v2 7/7] mm/mglru: remove memcg disable handling from lru_gen_shrink_node
Date: Wed, 24 Dec 2025 07:30:32 +0000
Message-Id: <20251224073032.161911-8-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251224073032.161911-1-chenridong@huaweicloud.com>
References: <20251224073032.161911-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3l_cMmktp9pcvBQ--.63051S9
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar4ruFW5Zr4UXr45JFW5KFg_yoW8Ww1rpF
	ZxG3y2y3yrJ3Z0g3WSvFsrua43C3yxKr18JrWUJw1fCr1SqFyrKFyUCry8Wry5ArykZr13
	Zr9Ivw1UW3y0qF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Queue-Id: 6214F1C0005
X-Stat-Signature: u1jthhp5iydd8g4tgtd3qpneuotdju4g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766562339-875903
X-HE-Meta: U2FsdGVkX1/LOHVrl9gYbxDWnTH04UMY+DmsWrpdAsugS66NqeHasbN53zfERssf5qhz32kgDFIK7jdSFngimOgvNurkZyUS4xAu5bcWTZrs4qLO12ltP7V6/zM2uXb/y0zoMOQQpSdBt0glSSMtQmg49lsJf7wg6gYsvzcA3Gxjhhsfr/wbLrpmDxsFCfNdsNe4ol+8Hg/pVQLvI5Ti/XZt2pZ+m1rHAvo+nVeqOoZL77qeVkxLv+iatZIklgwAobWpEhtEh4mGnOLFnZDZA7nHUySZyAVL21F/Fyf6Y1RHRM6bNVkrwd3u6xd7uhIq2Mqac2dvS87vfkf7aXGf1bdkBSlRuD9gXehMfMVwHqLw4Av970AwU0aG10PMEsZgXMiJpY2k4kFUeTXaYLQRIfc0VHciZOFVHbiqCoSPaoV1jfsHTORXpCCkaQLofIQd2jcpYNKQdaye7QH+p7wsa89dPVkNS2gXSr8d7+5CGqcpwZEtsmBYNemiNsj4pBvM0YvDqK2GmhgXhGqhm3J7pwLh/coqR2HyvhS89hVTuDoGJqzmAQiwCToRCjlS+rcd2XLWZk6GUTAdjagCkqd9YNEc3qDB4DA38H+GeUyv+WRBscLE2iv8O2RVQZ3gHAVVAazG7xrFRMJls9g5JlXHxdtIpmrBMSl51UkZwZgl1yLlHd2k/gq8VIJnHDFG/2MPHuEWO7pDsv7+9eWj/3HM7ICfTAgp9eaOzdaP/kblbIa/3q5RniOHztAsAOfaLLBMcakctja0jAu4iCd8hwpWjvJVQvfJOIqfahzy37Sb5F63rGJgLlI2A8n2dPkYLejynyUksKKQJ+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

Since shrink_node_memcgs already handles the memcg disabled case,
this special-case logic in lru_gen_shrink_node is unnecessary.
Remove it.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1d13ce7338b4..5ea98bb94156 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4759,24 +4759,6 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	return nr_to_scan < 0;
 }
 
-static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
-{
-	unsigned long scanned = sc->nr_scanned;
-	unsigned long reclaimed = sc->nr_reclaimed;
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
-
-	try_to_shrink_lruvec(lruvec, sc);
-
-	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
-
-	if (!sc->proactive)
-		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
-			   sc->nr_reclaimed - reclaimed);
-
-	flush_reclaim_state(sc);
-}
-
 static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct blk_plug plug;
@@ -4832,10 +4814,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 	if (current_is_kswapd())
 		sc->nr_reclaimed = 0;
 
-	if (mem_cgroup_disabled())
-		shrink_one(&pgdat->__lruvec, sc);
-	else
-		shrink_node_memcgs(pgdat, sc);
+	shrink_node_memcgs(pgdat, sc);
 
 	if (current_is_kswapd())
 		sc->nr_reclaimed += reclaimed;
-- 
2.34.1


