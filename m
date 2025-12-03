Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0221DD12691
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B086B0030; Wed,  3 Dec 2025 04:55:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBE56B0032; Wed,  3 Dec 2025 04:55:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DAB76B0088; Wed,  3 Dec 2025 04:55:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 086126B0030
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:55:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 585BE13301C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:55:09 +0000 (UTC)
X-FDA: 84177701538.20.90F2EB3
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id D38B74000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:55:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764755707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=j2ucVbBRXJ5rVxE1BXZ1DIsnMyjNWnWmSg/imk14x18=;
	b=1oTx73YGZWBZYYLY5yKTQAulchSGgiJIxgJ+KkEBhcDDB2gihWUXmkmNvRz8CNjNz04erO
	zGFwG50pmRo+2upwPY1X7I7Id/+id8PPXnQWJmLv0fC9p2OANWnfYwW2ytHQ8F/L6d2ZaU
	5FgXLSNR+OUp96VHgCOnp+06EX+huB0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764755707; a=rsa-sha256;
	cv=none;
	b=YNNg7tZYivLewks8R0dhjWTIANHomkaUG/2gB+srTeru/2aNV9MUj2MIMF31eCYplFjl0K
	/G5xfr6kpo7L3FwW5PNo0QiXjCIyrygLU95WITfPtUz6IQ6Xc7emQV/MgN4INXPR9kcGWi
	Rw1JI9u2SgJPqB+bz1sXWyhuaPWWRBY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dLtKX4l8DzYQv49
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 17:54:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D255A1A1943
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 17:54:59 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgC34Z7nCDBpCm_KAQ--.24312S2;
	Wed, 03 Dec 2025 17:54:59 +0800 (CST)
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
	jaewon31.kim@samsung.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huawei.com
Subject: [PATCH -next] mm: vmscan: correct nr_requested tracing in scan_folios
Date: Wed,  3 Dec 2025 09:40:02 +0000
Message-Id: <20251203094002.1745458-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC34Z7nCDBpCm_KAQ--.24312S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uF15WFyfZFWxXFy8uw4xtFb_yoW8Ww17pa
	yfur1xGFWfXr4aga4rZwn5Xa17tF42ya47GryYqr1xZ3s3Wa40k345Gr1UX3yxGr1kXryr
	XasrKFnag3yDtFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a
	6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
	xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
	xUOBMKDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: D38B74000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 56h879s9tnjeza3kg8f7pq69kaap4xmo
X-HE-Tag: 1764755704-22664
X-HE-Meta: U2FsdGVkX18SwSKiqEyhikTNMX+Xf72d+RjSWsXixE1SdoBHvbLf3fQ6n4BmlfliHiN2DWfJsDJ0jvJj1DSLDQQxTpQBYwM4EVjM3VyLkGy+svDp9Kz3nVFjbDG2fXqcIteBYAdxDAMs8rpvZ8xgPolSeiysvC1r+dkXwN55ke4v4f/1+EkPBzRjp30eaQRrxH8l3G4X8FMOKTo4SVoaZaR5YI+iG7gCBC+DgO5H7wYOedcVWPfJWODlJlB2ZXwLLHr29StrizYIcfd+DTKZC6tsfdvzGvR8uDDTouWzMuoX7Tp5UoOZtCvFBl5QthDBz6cHW9cQQc5ATSk3PSlOoFZG4K4lQtRo0YuHrb/pFHAS1CfJwQ9z3uZ9WdcPF6cHh2av3UNs9Ze3TUG1iuSP/2yHTTXLY7eIfewDj4tLVwbN/jU5xBBzyza5pOhms8ssjwYw7mp0ovvpzwh2vq13VpntSbUVtYJmkOJO7RifzYdqjM+wseZD0kiQBuIjFJ7Y8hxqhHjpl+dR3+G1fSxWmTzievun8o/EkE4NYyY/z3xX+TaA+a5t9qOvBmLfWT8/3N8sBNCEtrmPpgt6W4GWuCWdjRtSF/NsHyYSZZROAtyzgbEjk4e7zIYfVOmxcTrhop4YtZDnfCqQRfr8s7LJL1GTuTuBc7ZN1DBcgzhVTM+JL8m9alQaH+IOSRRprEqzbEosoDEuuK5WAoAPAZc/AaRHjcEOYH6gid7nvWUPzlwCl0MJcMM928XkO31plWmoBmGHqH+tsveFX9EyGjMglFleAM+jlOKyXzHV5aeHbtDmXjRSFO6fcU+RT7MgTNWRZO7OTIpHl4RkS1kARtD46LB3h4yXuomYh1eXSRIG3im24n7o9Jho/ThtOofEIfAgEeCmTwnZWbBJ88FMY6SlKR45f3gTXOpJe3cOIQTEe6AyLWxuWOywuVzvaxhr5Iw3k2tA3I5G6aNIyCOzc1B
 69IQ/zts
 wkyK+Q+bdwUfJ8aFAFnZS5jJTNeDRWEThU+FwRyIRLs3TMFwEdxrdwqxXz+Ljtg3rTK0GetnOncv2D2Z4xHN89lFhW4CHr/PcUNmAYMtr9LijIH75oeOEItzDassmVNQrJlWyUXvDzzmTkLY=
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
constant. To fix this, modify it to print nr_to_scan as isolate_lru_folios
does.

Fixes: 8c2214fc9a47 ("mm: multi-gen LRU: reuse some legacy trace events")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fddd168a9737..8cfafd50a7a8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4601,7 +4601,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	count_memcg_events(memcg, item, isolated);
 	count_memcg_events(memcg, PGREFILL, sorted);
 	__count_vm_events(PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
-- 
2.34.1


