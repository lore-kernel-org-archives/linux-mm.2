Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A80AD1F9D5
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 12:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6600A6B0029; Thu,  4 Dec 2025 07:39:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637F56B002A; Thu,  4 Dec 2025 07:39:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574DB6B002B; Thu,  4 Dec 2025 07:39:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49A266B0029
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 07:39:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EABDF514E9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:39:06 +0000 (UTC)
X-FDA: 84181743492.15.0B3F5EE
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id B070510000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:39:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764851945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=cYXaBkHSRB0Y15dHh7FJqREbOqHU7gKr9gjVBUDh/FE=;
	b=k2UdGYoWTeWrqGOyE140bfD4GMshSK8c5vq2iYeZq2QVoTFngbw8BdwiYpNhh5PRlaGSGa
	fVyqcZ69mtb5Evsv+I8j2r3bdGfenjLBK3XDQxq9Mzhuwf0tb/tu6Qt5dUphV/d0/qVgXF
	6KY40cuCXyW6+fwPuNI426Eggg3iXus=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764851945; a=rsa-sha256;
	cv=none;
	b=n5aCDFd2/lDvg9x9ArjWEoFq7McJAyIgEhI49z2ugaBEDFDHUo7BLCvsXv0WLeitp3ODjw
	UVu/IuuAYnZDhyfBFk/q20qX0hLH/VPACpLDG1zP5X4fp02WXWRxFXsp/aNSMSmtx0E8Y2
	gF9angZclUFrWhIVBXTYNbsNggpAIeU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dMYvH1vFyzKHMYT
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:38:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 2C77F1A154F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:38:54 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgCXdU_QgDFp_XtKAg--.33838S2;
	Thu, 04 Dec 2025 20:38:53 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	yuzhao@google.com,
	jaewon31.kim@samsung.com,
	ioworker0@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huawei.com
Subject: [PATCH -next v2] mm: vmscan: correct nr_requested tracing in scan_folios
Date: Thu,  4 Dec 2025 12:23:55 +0000
Message-Id: <20251204122355.1822919-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCXdU_QgDFp_XtKAg--.33838S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uF15WFyfZFWxXFy8uw4xtFb_yoW8Zw4Upa
	yfCw47GrWfXr4agayfZwn5XF43KFWIya47Jr1qgw129r9aga4xK345Gr1UXrWUGr1kXFyx
	ZasFgFnagayDtFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8
	ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU0bAw3UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B070510000A
X-Stat-Signature: 3hy97ok5o6sdefwm6bbunujxmiwaybxa
X-HE-Tag: 1764851940-158041
X-HE-Meta: U2FsdGVkX1/ZF/1UdK+L9snvw6wLkGxYRy47IyOjob/q3MJNR0QuP8WNH3mmtI866GbNdBSp2wDQMsHuGreI/N4ifXghwJy1iMehDGWd6hYTFGBmOkEn/cjjGnja4g/aP89CxIkqV82gLtnCToCBVvNh6LNl+yNNeFUBe2Ry1eUK8RHSAoSQtnjWU3IaHr9/6XfsaBolCblIhgJUdf9f5vbIY6P8MHqfsELINLj8NHVjHKfgFRlogyShnHjnhKVHvNX9tkHRJl8+/Di6G5gr5lFio/mU7th5mMg75DUAaWUbeb3FsQR2iia31vpzGNJqteN0OF2e2MdHDikTpp6W1k/xx5FRJb0s5N86iv1BllZXCd/BmBH2zUv5hVbu2NPRAQz9aoYeDWk78fuVMBnwRxrSzE8JuuKLgP81ECWXoTiaAXArnJkgImKvp7YHwL85a4EHirunFOEG16GIl4i7u+deK0Z6NhSxE2WGlIvZemT2X6XVJfXyo+doAOLBZCsrFcgdpF0swho/gVrui+pXmBgY/Mye3/Wd6Yu1Yc7yLAtIXYd21VJwaf0BL7//8SNfDIMq/XBa5gZBWNtqHOTywnyjlaF62EcAxjAHPgs2UQ5KCvSYaefQRTLGKLkZSEv9EPf3Lg6qZx7eJdBtGCkGssoyYUVkq//0N2jTuM29266jbU27p7tpNKZtXBduXtWa1f8gNOJKLJ5QNhj62lp511iGHBSpnHDWTfvUnGIgFolz+nXjy+gbBKG07mB5X8H1NVwJHJ/LHDmK5HNCwhOMMggxB8pPCdHZOvjLzwRhB+TJD/s3lPkk7KHprkfTlhEk1fSabD+ELu9yzoDuvEAFnr5AYbeT6UF5FSyv8lHUyWWWJQ7SYhWxbNLssxxEjp6bdlm4OX0mjU7qei4+O/2GxjR3/2PqA6UNNcEW2iyKb2wXttOyEzxHwasaVLV+ZUwNgT4fF1k54sfy2ZAdoLH
 vY3l+6qJ
 kjpu4S1VvfhXy6pID/7NhSYJy76xNZj65gk3GqM/ppnz9OYEx9fEDLj3g/2t2zMPF+3Gof5NAD9EqznfsMxVPIJeRWLDYjGCjjKVv6rsLBGhEH4+m8vM/15lMtwJlrnl2ImwNLP0pliiSvzI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

When enabling vmscan tracing, it is observed that nr_requested is always
4096, which is confusing.

        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
        mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...

This is because it prints MAX_LRU_BATCH, which is meaningless as it's a
constant. To fix this, modify it to print capped valued.

Fixes: 8c2214fc9a47 ("mm: multi-gen LRU: reuse some legacy trace events")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 584f41eb4c14..a0a74cac947b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4404,7 +4404,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
-	int remaining = min(nr_to_scan, MAX_LRU_BATCH);
+	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
+	int remaining = scan_batch;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
@@ -4464,7 +4465,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	count_memcg_events(memcg, item, isolated);
 	count_memcg_events(memcg, PGREFILL, sorted);
 	__count_vm_events(PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
-- 
2.34.1


