Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A9FC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1327E6B0088; Mon, 20 Jul 2026 10:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E31F6B008A; Mon, 20 Jul 2026 10:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F396B008C; Mon, 20 Jul 2026 10:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7F086B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:29:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59C0B140176
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:15 +0000 (UTC)
X-FDA: 85009387470.07.D0E477C
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3BEC9120002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rVIwa0RG;
	spf=pass (imf29.hostedemail.com: domain of lixiasong1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=lixiasong1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557753;
	b=oUpLo+2fMCtNv6itjiEd+g8O7KTOLxum9NeRKEFy8lN1b00gEvoCn+tKpF0ye7w2kcSUIb
	P9zf1n+qO3+/YUyc6TBPBuf5yHMxjKj2/tQObVpFZtpolYBr9gym4Q9cL1ZFXkP1p7pEWi
	xa38lUqIuMZqK8DHIJ3ShIwfXJfLmu4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rVIwa0RG;
	spf=pass (imf29.hostedemail.com: domain of lixiasong1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=lixiasong1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DrkyWGZJvKpz1Y9hUbiad/mxBLk74eyl6ggh9U6vGD8=;
	b=Wii1bpK6Su3qn5Df9iPI4DJIdBXMGBmtdGxwSIXQJgdCcq7zf6ptEcQ0nj/oE7Trj87W8G
	Iek2RUh4aJQtGT+GkQkNBb6XKW8vfimRqt0AWFumOaQnqGTLTYuWmSQHm/sp8AFrdYkazs
	+nEVJoEUO1Q5Mg3z4QbHafMjL2ejuAM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DrkyWGZJvKpz1Y9hUbiad/mxBLk74eyl6ggh9U6vGD8=;
	b=rVIwa0RGo6cGzljxEKCvwxkHBm71KKmMyXECRod6E4mkEaj3QR8pW0nFK8EH6Pm7G4fUoAyVg
	Dd/qnBYUUkaSjqLHpooIKMJ3mx7f82I/ja1CSLn7amNOg6zRfnnU5dGhHjOC7anImB+SzrMTGxJ
	kHg/lO9AiNRt68+IHVfaWfQ=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4h3jML4r74z1T4GB;
	Mon, 20 Jul 2026 22:19:42 +0800 (CST)
Received: from kwepemj500018.china.huawei.com (unknown [7.202.194.48])
	by mail.maildlp.com (Postfix) with ESMTPS id AD4DC40579;
	Mon, 20 Jul 2026 22:29:00 +0800 (CST)
Received: from huawei.com (10.50.85.128) by kwepemj500018.china.huawei.com
 (7.202.194.48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 20 Jul
 2026 22:28:59 +0800
From: Li Xiasong <lixiasong1@huawei.com>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>
CC: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <yuehaibing@huawei.com>,
	<zhangchangzhong@huawei.com>, <weiyongjun1@huawei.com>
Subject: [PATCH] mm/slub: fix missing debugfs entries for caches created before sysfs init
Date: Mon, 20 Jul 2026 22:51:24 +0800
Message-ID: <20260720145124.3684976-1-lixiasong1@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.128]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj500018.china.huawei.com (7.202.194.48)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3BEC9120002
X-Stat-Signature: 79h96cf6t5cwiitzcef5gpc3pxd4gpe6
X-Rspam-User: 
X-HE-Tag: 1784557752-562744
X-HE-Meta: U2FsdGVkX18dKzhmHPPMbly7vtltepd70y4fe69sVmzADjudaBoePc120zCoHL4eA3ZOqol2/3Kov+ni+kJaYjHtPg4whLzu8IIfOdItl2eP6wZ2dYdMO3L8Gye1lkBm8B9sUQD7R2M9Ud9+tnUnOnbR2nk9UaqLrpLZtbvE3EWAW30PGA61wXmqq5nfLxBWI/9ljNPbQDPlpGgJ05DxvuX9MwlKpMDA/qXnEHAdIgLMRepCc5ecxea1C4ZLlykWnbm8LRkzcuMhKddOJC5pFd50JD6OCqSTn4y6SxHRyRgG68+Q+lJn6rYX/UyKSghR46T5PxfsUOShVEXPOxdCJHlk0aPtG8pT/kJ1vhIQXvCrDF7AOjYnaYFby4UuWfXRpb7Iis1I2WAE+YoShlzxT4MSXiq9mMa0L+rVZ38tlSlKMBAXchzwkZtHfMTEYMMjCHXePRiFMd/rFH7pKUxg+XiSCsViCFpJlctM6Whhpid/VCxEbmZls097Eurl4GnENoQ+5QB6r0N2FUhqL45FrYu/V5LMZivMHh6uKJb9eHdst3C9FaJi/v3l1rwGOmpS6PzjuBriuks9lZylTgw0zH2FnPTidISx5aOnQYRHJkV1OUnZLS5Gkvgw9nLX5TLHcKiAUCHuIOA9m1GSsflN5K0bQtOygZcfkb/YMoLhLIBl/5XPgsZDnsb+wMXkctOsfp3ksuVgHiy2ZkwM51wBXiFre80xwT2FqkZirZJA0NyMzaEbRJuThDK2q2j5rBID+pJuFc33ZZp3RAtr1zxmc3taI0FdHjArXQZdl9OMyyJUhH7ERHrQqRdqnFU2bI1Tvq8RrIuHX8Yt5+NwYyr1+dC7+TSZPFFSJKQtGdXHN1ar7lCY1LTkkpI4gbpZ+Ij30EPT+jKZyPAkLtg8O5+zLrXprOZ+VmIWOMkMBk3Uq45/HqJBsbuXI3lYq9DF8jzJqpWQ8mq8OOkgi/840fT
 5Hbf8naG
 a1io2KOr9FRM9KrTlCUK08RSYFrnt6d4r9BiyPmWYoEZwwKivMzA8U/tT/XwS1hf8r52vp4GRNhI9zzhNpE554JRNZ3bWYyMS2CrASnRyEFzbhRzV7zke5xORdQPDpgZ9XPcQiTmadPQ1p+vE0SIshpcqml1JfZj9ug6/62Hajyq55f5T1YwtB5S2WpkaQt9MMFgTBnVrcGrAQAQQaspAdNQqSoC0LSYAmbUJq2HuLsnlLLi1a7iG8czpMki2xpr09LdFjZ3pXXJN6MigMYnw8LlKJBGFjvCTwOpA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

slab_debugfs_init() creates the slab debugfs root at device
initcall time, while slab_sysfs_init() moves slab_state to FULL
at late initcall time. SLAB_STORE_USER caches created in this
window currently miss their debugfs entries because
do_kmem_cache_create() skips debugfs_slab_add() when slab_state
<= UP. This was observed with MPTCP's request_sock_subflow_v6
cache, whose slab debugfs directory was missing.

The affected initcall window is:

  slab_debugfs_init()
    slab_debugfs_root = debugfs_create_dir(...)

  kmem_cache_create(..., SLAB_STORE_USER, ...)
    do_kmem_cache_create()
      if (slab_state <= UP)
        return without debugfs entries

  slab_sysfs_init()
    slab_state = FULL

Run slab_debugfs_init() after slab_sysfs_init() and protect its scan of
slab_caches with slab_mutex.

Fixes: 1a5ad30b89b4 ("mm: slub: make slab_sysfs_init() a late_initcall")
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
---
 mm/slub.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9ec774dc7009..d35e40c7a7ba 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9992,16 +9992,23 @@ static int __init slab_debugfs_init(void)
 {
 	struct kmem_cache *s;
 
+	mutex_lock(&slab_mutex);
+
 	slab_debugfs_root = debugfs_create_dir("slab", NULL);
 
 	list_for_each_entry(s, &slab_caches, list)
 		if (s->flags & SLAB_STORE_USER)
 			debugfs_slab_add(s);
 
+	mutex_unlock(&slab_mutex);
 	return 0;
 
 }
-__initcall(slab_debugfs_init);
+/*
+ * This must be after slab_sysfs_init(), otherwise caches created between
+ * the debugfs scan and slab_state reaching FULL miss their debugfs entries.
+ */
+late_initcall(slab_debugfs_init);
 #endif
 /*
  * The /proc/slabinfo ABI
-- 
2.34.1


