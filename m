Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F35B3CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497C86B0096; Mon, 12 Oct 2026 23:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D536B0098; Mon, 12 Oct 2026 23:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF1E6B0099; Mon, 12 Oct 2026 23:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 050AF6B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:12:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83C7FA0B70
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:12:37 +0000 (UTC)
X-FDA: 85316130354.19.872DBD6
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0B953140003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:12:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dhfOGM8e;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791861155;
	b=H7U6V+kHNxMXfP2tLYHBNMT1gZecibDmA6+EjtASsw7rw3IZRFIF0O9goBJSTXHGZdkci4
	sh0xdbLuOtTrWbYucAXvyqYeLGDi56QRkcOK8BbYtBvUUagLlR8ZswVoiD5Cwf8brm6zRi
	6DWadzmvIxNoDJxOvnuO4xi3Sb7/Y7M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dhfOGM8e;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791861155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpf5QsizXx9EkATcGnWqX+gyIM8QWqLtiyYMZfErVsY=;
	b=763iurjeDL+gCVhC3kNKia0LjXumxGEXbQrM3vQxC9uHP97k1XmgIPSeqJZDQ7T3SctqVZ
	eo04ZBln/lIqEszIsA0sPzmHsR8yt7SbEwIIusKJ/vVBlikRYhrmcgot6jjRDcDJNkmWkm
	YK8Llu6cQAEAPGLxqRptkyxLTU0RnYM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791861152; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=zpf5QsizXx9EkATcGnWqX+gyIM8QWqLtiyYMZfErVsY=;
	b=dhfOGM8eH5Bsylg+/TqBAxQ+pYGLqrMeAqhpH4TOJHc+/mcvGfqP/vLWUkFi8XNIf2T1al2KPA6QeU9N10K6eGRZw0S5odjJoEwblqNN/933+vcc69m9NF87wiceFTZPT9Fk4hSAohisuHd7BqD/0w64nKMmPETGM6XERj8uh/8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XCkEjeP_1791861150;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XCkEjeP_1791861150 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 11:12:31 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	xlpang@linux.alibaba.com,
	ryncsn@gmail.com,
	gourry@gourry.net,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v4 5/5] mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
Date: Tue, 13 Oct 2026 11:12:21 +0800
Message-ID: <20261013031221.1997194-6-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
References: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gnqa5y3ifqzc9a85pw1uho1tk1azmqh1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0B953140003
X-HE-Tag: 1791861154-967263
X-HE-Meta: U2FsdGVkX1/+zoZeKhpUzmJWU3hLgEV3nz84czWhMeORA+UFGigGtaL6Kn6bOVGzh4vj6rB5EgbC6u1Ty42FxoDaU9ECfXKq3Rl5PDP38IyWIjWMWaJJgtCCaDfUcyfvWm31K/ZaYbv+ugkZgqDpG/StCuJxCgmsBFhqcxNmOW8g9ealcDH+x0MEIjDpzmMxObzVyViV6hSSibfdCns3MVX0tBdC20dmwwUQsz0TJocSQVSrriH75hAk3XjRB7ciT5fif1xEQr/tK56cis6yFwO7qqgxkM4/W9x8zIL9fGW5SjiBD4OdtrVn688JDbnLC8oLQURJr8u5/YID5+LGVjq8gWqMbfgrRnDK94WVEIp5Ih8twdNevtMhpSuiCoEqNjMSjhCM97jdyFey7Tj/vZqCvqZYfuqxSv8qxq0gP9zuBdpGQeD5ZnFTFdliyNArhTRgAaWxb5lMxqK2goy3ai5EUDRBd6NzuVWEjmg8Ds27ZM/gyZEXPgDv2jetTdhAe9tqs2wd1lqvFHxZSzrUrwrUm92ZA3vmwUvrkK0L1k7T0y3j1CKlaljaJvR4+nHMLAyzK+cViwqtnlbzRgSVHkSweBAMktDicWO2PiCnZGgxwYow3lW7FtdRbQqKOlo7TgC76TmpCnuAJx6haEUHqFF/STwwDIolNKAwINSXyen8dIemPYT6p4j8XdL5/mNMC0im9hNnwI0l2mWOIQfJ0CRCtWTUTEI9Mn/sos27Kvnau20hfOdYAKhw4iDn1IiiGqt+gKcKim2s2tPnvv/lBe+82GRZj8QE2WI29tNv126T4TaoJX2Z5x+C7vRdAQv0VHTbVcTxEdlWcaATG0Gc+psCHL9nEnzLyYkGiwDTC6Je6dz4TzIK2tzfV77JymZyM1wiOcq7fSI8ro1Bofc2lDSj/jdx1QxDO09rQ6W+jxHFKQE0E/uS4TNG9GY2tVAqVhHijKEwYd4y/BUw9ht
 qirn88m6
 PMmXVJBfb63jqdUDdZ76cTdNQKEG+SAIRgfID7gvgEHuQmaVW56LEETaT7GLuHKcfauOK4g0CeZgCWXgYK5W0ic3jFgvZR1yo5JiwAinY+wtrG15z5sHnzMU/NMjZoiPD1G3Wfr+kWgUUTJnq7eMWiUud5fdxUnnk+obU8cut0eE53U+Vt6qa6BfYKJHEY5iz6KYAVnNz1maE+lqujj66itlj3jU2MDGJx6q8/VcU6J/FyCWD7eQcVuvwtGv6qoZ6APnkss+S+UoOtIJdiTNinE4d5WmATlZL1bxBjEv0RakLoD9WAs3egjigwFvKY7SylW9kFEn/3nDNdEYyEn2/AJu6Qm4CQFF8dpQk59CW1QBCscwWbhnnZym1C3i+OwOEAmMQ9K4b6KNgfZnP7JfTOo459w2j3gAgVqjR1C9HBwuLXnLLgDV99ONRXpcQRHsuetQgR8Hr/WecT4A81J6nYR/2/X/3ufapKWmOZBsNLUMg7AJg6h+9gGRlLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With kmem accounting disabled (cgroup.memory=nokmem), memcg reclaim
never invokes the zswap shrinker: a cgroup under memory pressure does
not write back its own zswapped pages to make room; they are only
written back by global reclaim or once the global pool limit kicks in.

The zswap shrinker is registered memcg-aware but without
SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
before commit 03375203e1da ("mm: do not allocate shrinker info with
cgroup.memory=nokmem") it was skipped by the !memcg_kmem_online()
check in shrink_slab_memcg(); since that commit it is demoted to
non-memcg-aware at registration.  But the zswap shrinker is not a slab
shrinker: it tracks zswap entries and resolves the owning memcg from
the folio's objcg, independent of kmem accounting.

This was noticed by Michal during review of the patch "mm/list_lru:
don't copy stale shrinker id from non-memcg-aware shrinkers".

Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
under memcg reclaim with nokmem.

Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 572075bb1c1c..382ed1fb2847 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1348,8 +1348,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
 {
 	struct shrinker *shrinker;
 
-	shrinker =
-		shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE, "mm-zswap");
+	shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE |
+				  SHRINKER_NONSLAB, "mm-zswap");
 	if (!shrinker)
 		return NULL;
 
-- 
2.43.7


