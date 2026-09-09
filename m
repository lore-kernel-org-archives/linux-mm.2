Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC192C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD27D6B008A; Wed,  9 Sep 2026 08:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83576B008C; Wed,  9 Sep 2026 08:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B722A6B0092; Wed,  9 Sep 2026 08:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0F36B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:36:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 944F8A01EB
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:36:23 +0000 (UTC)
X-FDA: 85194171846.17.0EF0544
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf01.hostedemail.com (Postfix) with ESMTP id 645364000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:36:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FeCJS5Hx;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FeCJS5Hx;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788957381;
	b=LD8aPMZBiMMxgXQ+J+B804z3NDusAcPTU82XC8V+0FIyCblh5AFEu4SjXcQH79m7LMB6kz
	PPOwh7mosg11367nsd2HGzCQZuuFwSPIh5Fgrlt74Eoa6tLugxYDBp9qESXVyFsujGIg5S
	AKDp5AR642xg25VDSqgXJdc9gSisaFY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788957381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=m9Hb4vfngA9EQWN3H9npql3AFIz3Fr2ZElykfb77wSQ=;
	b=mW+5e+x2G6g6CRaL9dXEoB8IOafZ1YserUfskHOrJXFzmyWOOQjs9MOqAQxjjOkr86yrTz
	T+1E9e8sK6CAnFwKrduLoecmZRstdQgQppcjUKzr8XYVJcpQaLgtiDWNICcWNx3EFh/sMW
	7SmYkELWOQkFwG798RRF2OYwYkeiB/o=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=m9Hb4vfngA9EQWN3H9npql3AFIz3Fr2ZElykfb77wSQ=;
	b=FeCJS5HxJdhI2N8puR38OXCUpj+o+fHAr4Vbs93htfVq0hxYDS1M/6WGhLTxMwL1a4yaV94eY
	8KuBoVlX+q9laLA9vWFXz6G/xzp2dkOwTdgfyZFW153WSeSFw/OznZlt5UYgl2qsgjYZtT4dviR
	TqG07Lgl2BEem61RX4B/oLc=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hg0PS1l2Qzcb3G;
	Wed,  9 Sep 2026 20:25:00 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 070BD40538;
	Wed,  9 Sep 2026 20:35:59 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 9 Sep
 2026 20:35:58 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>, Chengming
 Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Kairui
 Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed
	<yosryahmed@google.com>
Subject: [PATCH] mm: zswap: avoid unnecessary xarray lookup in zswap_store() 
Date: Wed, 9 Sep 2026 20:35:47 +0800
Message-ID: <20260909123548.296955-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspam-User: 
X-Rspamd-Queue-Id: 645364000B
X-Stat-Signature: pxejqp7os81hcfpehbq711piateyw13h
X-Rspamd-Server: rspam01
X-HE-Tag: 1788957380-32451
X-HE-Meta: U2FsdGVkX19Tkw5dyFJNdpL4IJHM0GCDXIDcHIwD1DFqE6e5VVnAW7W0jzLBmCqYkEpj9S8ZvsWNCOXI47RZ1WRZubELwCf8/ZeyAyQmYl8WjM45M0K6r5/9oSYRHOcf+kzNb87ic0FiGO7uf93JPf7EgKD9xQ5DVV8nRMHdRi2L+tvGcNMaQkFInGtmXGIR4mx0WNoSfJ8x1Da1dslGbytF4pZwR/xpW8EXU2VXqdnFtWRjr6wYZ7VC9+HzrJlTSJlxtZzLqU4zdYPVgi1XIfAAjVii2fFsCTiuCIVRtzGeKNmo0spvrH6da2uFvsFniw7xdD/dCG2aVjk0txOZMEhW3AeHJ3YaS11ht8FxYsTsVV4q4AghcZXkdduHROU3BHmAfR1n1Q+aliyGqM3yJXYvB3cbdPwi8Ii1ATDDid2QnnbgkBxXhNEbq6YHcFuYXSJTmPi63dhchvqPs9AZhSA9MoTT9ZnWrrBO8SCRlxVQRPHRPvxKvcIBTatV2J5wTaVQvIjxEPDh8cAPSgkdLLO2GgwyUb9/bmouwBJ9axCur+aW4rcweE/f0XGwJ+wBWVo1gDujDyVi1a8OcMjpYbXnJAkSpn2u7db6JnNM8h5fKaRKzk587RjxjlA6hcG/X63pjHHL2E293ZIFcEHN9/ZkcJcwPO+B+ya97JrBA06gkAUAUwT4QRgdrtomITN+yVoO3Jkshj5o+Ae3ofucTaMIgTOlydepdN4SbIJ+kBzxn5d14lMaQ6knWGKT2JOHabcW/iiKG6lakb3lLPB59ziX8Qly0jH/spsl/q0HaSWmEgchT83DlajtbGjsypIYH9PR1TudiQlsjjPaCWWvdfiorgqhMT7DUc8hZ/TZWgLluS8wrgklMRJ+qNommgOKVgmDjvnk+wSITT4uSPJ7CAQWOqnbrZvLyuG1Zv2FNSqf6tR7LpeYCwb/Medjqgk+NCAGQEzDKzw8ZJafFb+
 KasbFVyx
 PMmsfWy1sKuGMnizgvTrmaQvZpyhjZkV4r1+Ume7UmEEVmf/PMKzBQZ+wQ2hgCIbutJ7VV7WpvdauP1HDBT4n+w6zTRqtr433uo6det276B5EkCgwKuAr0HGs7dYhDtj1vYJwsJlLc64z11tIAO43HdTx+JYgu1jYaTPrdhmBsqkksusZttdQuUpvQnqBmJ+A+FXhTk19jbmBiu49F5p+giMky6rM4VCZnycBk6QuLy2F1/Az1fAVfRi9CFk9hpcHXbAq3tINrKnswt9PPbhikMB31K4Bikqg8B38RMHTAGZwe7JvJot3vGL9wXJndRValZKj5+CuysrWWW9afDL4FTW76G4W/YpSUNkgDsjKhKMU0n/vx/umZtR7b/MnOXlaDWsgxq9SlAVgZ4KeS38saLn/LNF3nXSS+mCFphevRyOYD8zAHQIDSuor8hmf7tlnSwQRTjfosRbOV2cFkvh8rOaa5tufqos/gSGK82xeWYRjRG2rIlb/jsxcGUs/9sjV/XQHRf6HoI6xc/7uZIitAiIfm7KzBhVh86i0Dm9AMoHk4wUxpN6fmHjEqMp7hW5J5kna
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_store() falls through to check_old and walks the swap xarray
even when zswap is disabled. Add a zswap_never_enabled() early return
matching zswap_load(), and reuse zswap_invalidate() whose xa_empty()
check skips empty per-area trees to avoid unnecessary xarry lockup.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/zswap.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0d8bd72193..fc6c5e0db5e4 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1488,6 +1488,9 @@ bool zswap_store(struct folio *folio)
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
 
+	if (zswap_never_enabled())
+		return false;
+
 	if (!zswap_enabled)
 		goto check_old;
 
@@ -1545,15 +1548,10 @@ bool zswap_store(struct folio *folio)
 	if (!ret) {
 		unsigned type = swp_type(swp);
 		pgoff_t offset = swp_offset(swp);
-		struct zswap_entry *entry;
-		struct xarray *tree;
-
-		for (index = 0; index < nr_pages; ++index) {
-			tree = swap_zswap_tree(swp_entry(type, offset + index));
-			entry = xa_erase(tree, offset + index);
-			if (entry)
-				zswap_entry_free(entry);
-		}
+
+		for (index = 0; index < nr_pages; ++index)
+			zswap_invalidate(swp_entry(type, offset + index));
+
 	}
 
 	return ret;
-- 
2.55.0


