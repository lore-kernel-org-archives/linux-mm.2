Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9946EE7491E
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 07:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADBE16B0088; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79936B0092; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A56A6B0095; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76E3A6B008A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:45:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 243F41388CE
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:45:44 +0000 (UTC)
X-FDA: 84253580208.24.50F1967
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id E5C2B180004
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:45:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766562342; a=rsa-sha256;
	cv=none;
	b=m+o+lNX4NWBZO+m8yVUemll2qYmMgV5uh7mxYx/1mE4gqwCiKkC+0sHDE68HtVxPWkkJQT
	ziz1qrN2/jwnM3vw9WHyiuk6PG9fo6nyhExP+bD6JSDLSmlF3luBleVpfr70tozMtcoV1K
	4c7Cx+vbsM9dO/tm+842teGXRo4o/rE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766562342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3s7tTltRuD6Lb+kcD1KFn2o0nBR6SPg+NVcc4fIvOu0=;
	b=Tmx+dFy0LE3fx/woe1R8fNAiA1JSZyLotgDUY4fiPNl8xup1EC/0fG7dCLiIJYPKW1HSuz
	wH0HmktPFsJkBvPVBq9Jfdd3i1Pk37lRVGAdd+47ZKQZ9+/lrM+VLLzvkl/rU8rut8HXcD
	V+3iiEELfWejAeVh8yRUbckha5N9vug=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dbkRr3lsyzYQtmq
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:44:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CD0D740571
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:45:34 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgA3l_cMmktp9pcvBQ--.63051S5;
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
Subject: [PATCH -next v2 3/7] mm/mglru: make calls to flush_reclaim_state() similar for MGLRU and non-MGLRU
Date: Wed, 24 Dec 2025 07:30:28 +0000
Message-Id: <20251224073032.161911-4-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251224073032.161911-1-chenridong@huaweicloud.com>
References: <20251224073032.161911-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3l_cMmktp9pcvBQ--.63051S5
X-Coremail-Antispam: 1UD129KBjvJXoW7WrW8ArWkWr43Wr15uw43trb_yoW8WFWrpF
	ZxGry5t3WrAr9IgwnIvF48W3s0vw4UKr13Jr4Y93W3Aa43Jry5CrZxCrW0yrW8GrykXrW3
	Gr129w1UZ3yUA3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
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
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2
	KfnxnUUI43ZEXa7sRiuWl3UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: E5C2B180004
X-Stat-Signature: 3eejda1qxb79ym9epxhynx8dmixt4we5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766562339-126801
X-HE-Meta: U2FsdGVkX19gWUyiR4IbReUjmtM8DgRgBCUZSQud92E7SPgFc27PCt3k6uMmBEKqX67P+rt+H2BLtwnZViG5pKQ7vvWbXXjHFbHrKFHPBgiNHVvtAULzK8Gw/yuTyP/jqoqMzTXVyY4ucwJNYYGfGG+txinE58cqg3KAzjZ+ybmQ8fvk54uho3hcWJLC4Q4ZJV92+YrDgHrsBJSbfc2zU1o+aKeEvkuda0WaMZfo5yM5Qj4F3pNalLhqyDyjEil702VZuXtwr/FGVNMM9+t8aRx9hFiM1eHxmhNeyeLFz/dUYZV/vNAdCeFb9D937Uv0xutZoq/x6fvU39TEFkrUd9dra3wL1FBN9Wht4zSKukK//NET+D2HEkLIsJJyALAtccZtOqB3WJe8hS4AsFQnBbf2Xk7kODZmgOuohRR/oF8N8gFf4onDyQ/xYsyzDdrS8zbhmdVeW8iNmXtx4K1A0HW8Sg8UF7b6d/otB2J4O0oIuzaSszFA8QbYqVg+oD1NhBtg2E849tKOTGXFuUH+Qf2znIVIwH02UEnwR3C+do5/dduv53AwEXrXSeeqIdWK5RqdDHuL4+FwUBUR6LiguNnaImz7TL9JMc7L59dmtz5v4hXHJZkAeR5StaldiWk7RoaFCA7got9SxVhUhyGd/4E95j3grS2vSDYvqEBMv6sJedcOefmvNcnDvXduYlnzBCcFjqwhAzH1UeJTWC9jZc8dE6c183zu5JrPWTf3eQL4vljHFX8b5wOtZu6ziSBtlZqB9FGxFNsuAP+hktEp7l+CPUNimsAFpaIPaAEhHvsQzgH3W1A0ck174k366BN20JwSl6mh/g1KTFtGzAj5kC9lyWFMDrD6zweBoyXFyCPlxL+iMUTdB4M2AtGRBFd47sGBjQHNF8JKeuIlGT1EI7k6/WUGIbaANJlJjRqXFqauvqfRb1TjRXX6o2MSin2R9GrzGx2sYeDrT03zEdd
 S97Sujxi
 C8BiZzXLlQmKqujNQNuDC9iSNtWm6z7YSwMLPxyLN91CSc+D+vx93kOPINlkfz4y/BP/O8/q+DhgIQfG6hwFzS9zlKWDETfjNlp4hAN1cXYOB7VMy5Zc+EnwjKnMxSzMWXZg4InpI3/j6SDo=
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
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8f4f9320e4c9..bbdcd4fcfd74 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5822,6 +5822,8 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 				   sc->nr_scanned - scanned,
 				   sc->nr_reclaimed - reclaimed);
 
+		flush_reclaim_state(sc);
+
 		/* If partial walks are allowed, bail once goal is reached */
 		if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
 			mem_cgroup_iter_break(target_memcg, memcg);
@@ -5854,8 +5856,6 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 
 	shrink_node_memcgs(pgdat, sc);
 
-	flush_reclaim_state(sc);
-
 	nr_node_reclaimed = sc->nr_reclaimed - nr_reclaimed;
 
 	/* Record the subtree's reclaim efficiency */
-- 
2.34.1


