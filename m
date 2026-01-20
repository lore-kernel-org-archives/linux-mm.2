Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A5ED2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5060D6B040A; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B36B6B040F; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396006B0410; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 273D76B040A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C62061605A0
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:57 +0000 (UTC)
X-FDA: 84352495794.07.BB34B0F
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id C324A1A0008
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768917476; a=rsa-sha256;
	cv=none;
	b=KZcxXZNtzF+qg0kg3XFTy7sqiTaMFuTVOchPNyFRHwHkCkypcXgNiycoQ9rwcrP3p/ZGsH
	ty4cS3dsWroV5N9+R7aKdrMB+MDb/C/wt0Vz2uqJeZxE+WOerz1/0tXjmgKuUZMtywTK3r
	FBvIm4JBT1ABPxN/h1eTzaSKog5gWm0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768917476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M9YNIU94UQP7SwONiUdJauc6JsgBQzgjKKAQquECyik=;
	b=xyEH3IkL4aJsv5i+L9sXtvT8wBnu4MWIn0avVZUZLnQoj9jKBJJWVheDdXUi8isC0emH5D
	WTD9Lqr9Ipc/a/x4Jo1x5ivvxRtDGcaahrNxcTmvVXrpVLuzwdobcm/iURh18Ax/+4HzpR
	MQfkAXk1DRxUBSX+6Dove5noj60urFg=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dwTR70GgpzYQvHH
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:57:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E4D8F40570
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:57:46 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgCnCPnQiW9pwhTxEQ--.10691S4;
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
Subject: [RFC PATCH -next 2/7] mm/mglru: make calls to flush_reclaim_state() similar for MGLRU and non-MGLRU
Date: Tue, 20 Jan 2026 13:42:51 +0000
Message-Id: <20260120134256.2271710-3-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260120134256.2271710-1-chenridong@huaweicloud.com>
References: <20260120134256.2271710-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCPnQiW9pwhTxEQ--.10691S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WrW8ArWkWr43Wr15uw43trb_yoW8WFWUpF
	ZxGry8ta1rArnIgwnIvF48W3s0vw4UKry5Jrs093WfAasxJr1YkrZxCrW0krWrWryvqrW3
	Wr12gw1UZ3yUA3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
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
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRRCJPDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: unhx5dxtzb787fu39dujka41uqoj7ayu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C324A1A0008
X-Rspam-User: 
X-HE-Tag: 1768917471-519254
X-HE-Meta: U2FsdGVkX1/sIIaijSJJ+GpSaDLQ6uhW56i7VaA5aXNvNPSWGA+zOaJ+9pfmxojDSp0+lWY1b4C2gDG8ml+1xn3p2ALP8gWP2gAK6eWSiNEkVIaKeaSeHnQV8Bi3qBKEQ1cq32S40tc/6eRkUZM+i8lJa4egC5r0VIGBOJ2ncZ3xuILjN+Mf/i0FDC5V/bBwM/zhEr+wI0kJ/DZoj+7UcMtSRRDTo0Q7/3GPywllVv41IpHoR1CcG2DJQ0w9TjuaZpzV7CETcp+Qetm9+ll06w6ieMz069Zs4tUp3vAhKIguxpH7QvwFZh/d+8h6xvYUkanPaumcMibT1O/tkTPOzmfistYqLrN8q6op8Q+h8nDlsO+RySDb2tw9ErmTtAdA087Id2ap8VIR6kP4xP0WDQ7iU0tzroPBSye1cgChKd4rHIew2fA4Wi6lNnmNUxWYoiGYGMSMauolUAc61g8zQYs40mtlKa+bTUpAWnp2uK5rQ8bdPjJGe54uX8LqJIUuMX5Xaxiiu7iOxI99QtigU2uxaUAA45e/kxHK1gcCjPbzNlgUHb+Iu5IfCkW7oMY6sxZQsI1GYVdGv7XSdJsM8MSYQJDLm6eXoI/TXE0pzcXbGdGcADMkTog2GCBRG2y4Kq25Qt9fwCltnOOSi/rHNTP5n3W3ia1kPeDncy0VQqe2Ih7mSenjNDyQimqO9htJKQi9GKv2VF0Xjmv7R6b9VZVmeXVQmCIS5fCxBFDmoWe9qBiwYHIbvdVNuAUl5c9M4YbeTNs+ukVLdCDfnzeZhz25GMITaPU3lcjyMNgATI1LXqM/YUyZ25QCG8JIqADhG0fIkKtiF92+Rf6odMCq/DdnL1KET1wosOPrltatJcwEkbJWjUhcK+iJZsFzCWIwH6kgVnIBkQiE/U3yzaoRsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

Currently, flush_reclaim_state is placed differently between
shrink_node_memcgs and shrink_many. shrink_many (only used for gen-LRU)
calls it after each lruvec is shrunk, while shrink_node_memcgs calls it
only after all lruvecs have been shrunk.

This patch moves flush_reclaim_state into shrink_node_memcgs and calls it
after each lruvec. This unifies the behavior and is reasonable because:

1. flush_reclaim_state adds current->reclaim_state->reclaimed to
   sc->nr_reclaimed.
2. For non-MGLRU root reclaim, this can help stop the iteration earlier
   when nr_to_reclaim is reached.
3. For non-root reclaim, the effect is negligible since flush_reclaim_state
   does nothing in that case.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3759cd52c336..5a156ff48520 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6182,6 +6182,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 					   sc->nr_scanned - scanned,
 					   sc->nr_reclaimed - reclaimed);
 
+			flush_reclaim_state(sc);
 			/* If partial walks are allowed, bail once goal is reached */
 			if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
 				mem_cgroup_iter_break(target_memcg, memcg);
@@ -6218,8 +6219,6 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 
 	shrink_node_memcgs(pgdat, sc);
 
-	flush_reclaim_state(sc);
-
 	nr_node_reclaimed = sc->nr_reclaimed - nr_reclaimed;
 
 	/* Record the subtree's reclaim efficiency */
-- 
2.34.1


