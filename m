Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70E26C531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 11:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4246B009F; Thu, 23 Jul 2026 07:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5743A6B00A1; Thu, 23 Jul 2026 07:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2BF6B00A2; Thu, 23 Jul 2026 07:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2299F6B009F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:33:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7A381C09A3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:33:46 +0000 (UTC)
X-FDA: 85019831652.29.6E529C3
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf30.hostedemail.com (Postfix) with ESMTP id D9DD28000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:33:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RcC4lbyw;
	spf=pass (imf30.hostedemail.com: domain of lixiasong1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=lixiasong1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784806425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GxVNFt8xQTYyKNyZXDf27eETT5f/KM+VvCGWAK3V/z8=;
	b=8R/Bd+lN4c71lHWED8Y1VDCczjkR1S+PuQzKCiEJoA65lfKbDu9tSYUvnkstgQlqQRmAdH
	bIGHYhjfOAfEu92r4+CyGRbK6Sg7v3DBvpn2vofUl7pyuME/e6cKYWBfqhl0eoXcCbdbuW
	lXm9JBYLHfPT1fndYUliu88UyrgCCYw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RcC4lbyw;
	spf=pass (imf30.hostedemail.com: domain of lixiasong1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=lixiasong1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784806425;
	b=n8zL/1nvLGOj66YNu6/oQmuWOcTEfngkMIovqGyJGxlUR5RXcvhZD/Wp2O9RtfwUfJKgMB
	y2o20c+iDUTmQrMsQcwTuiMXhDTwZ8/DdgWRAmZFWeoW1DUUjpytAt7XuAgxGstwKwvF7I
	CSJBAjrGDC05FkWOBjoW/dDRtUGCzjU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GxVNFt8xQTYyKNyZXDf27eETT5f/KM+VvCGWAK3V/z8=;
	b=RcC4lbywS4NyQB8ogFvDv3vWqNzsM05EjyaK9pIIK11HfiA3i/BbV6Ul/8d4m8g2e71eXSoFq
	+AYUlYCq3WtuIWn/OpH6GHJdRZyWfuRLL/K4lCmUXrUAxZ/bfT/NRDkKxrl2JFA1RhwsX5uv1ig
	2iEQqzz8YnL2S1s1GtZVN/E=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4h5TKS2PCwzLlTV;
	Thu, 23 Jul 2026 19:24:12 +0800 (CST)
Received: from kwepemj500018.china.huawei.com (unknown [7.202.194.48])
	by mail.maildlp.com (Postfix) with ESMTPS id A1FC740586;
	Thu, 23 Jul 2026 19:33:35 +0800 (CST)
Received: from huawei.com (10.50.85.128) by kwepemj500018.china.huawei.com
 (7.202.194.48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 23 Jul
 2026 19:33:35 +0800
From: Li Xiasong <lixiasong1@huawei.com>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>
CC: <stable@vger.kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter
	<cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>, <zhangchangzhong@huawei.com>,
	<weiyongjun1@huawei.com>
Subject: [PATCH v2] mm/slub: fix missing debugfs entries for caches created before sysfs init
Date: Thu, 23 Jul 2026 19:55:32 +0800
Message-ID: <20260723115532.761920-1-lixiasong1@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.128]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj500018.china.huawei.com (7.202.194.48)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D9DD28000C
X-Stat-Signature: 5ff95qw5nwj6zjmxi3qhdsywak68acj7
X-HE-Tag: 1784806421-920552
X-HE-Meta: U2FsdGVkX19erHTxMwW0++QH4gSg7JFUrBZTuogeXKuwT+exPSX0C7wG+KRjb5tU61Tk+kexaOoq/KoZW5OsXnhKvYI/Lv8tm+9wZ0xR0XPrTk0Hh2Z2fCnkd4g7rpl3JIiweIHscA9cVi+f+kU2Kc2NrgPH2EjHlQZF9JIHb7eQNn2NH1NfJ0XGbKaE+nIUl7NTfGe74meul5mJteGhT7K3q/ieQMmUY02SOBji5MSQLreTLIxs9XEixAHiy92SdILTepf8klqCXNDRsPFgVIiS5OPqlbJAakz5MnCFVqp7CC0KZYQ6TXdiaOlquze8nhGoiwlEgJctxiCcuxJ5obYKdl0vQV5/fx7Xm3PQeEmO6lcMj+TMrqJCnvpa6T4B8E1BzGSwiAdMyFxNC+c+B9m3UuU6wT7x/+EvmR8gVd3hojMf3/2QxKD9Vv/xn5oMTRa8Sd3bMqYu3yk4KwGF/bt87+7FFkcOdcTBFltDidkxTT9zE+lo/2AgM0+GG0X+NMVbmKSeX6/SjJUED0YNSFhUE/yDaRXqD9EAKsINyg1VVQYcfGwKd0E9UNV3bXUvpilTiU3yeKlhzhrMCIcFScvavVCQN7MtOTc2UDnloy2aYDkAnehghHKZDEbgAOHyloY8arGvtRn0anXzG5woy7cMqpkTz9Ae97siUMQ+H3+fTlg/jymrF4iZSnN7THTDvBHZENRG+gbwBfOPY0QBn65PAXLzx7N3bBoT9tM9Hii6upYjjj1SkK2uTuvr5Knb9stqWoYfjg6EOo5vo1n+a3D5WQU1t14gEzq6KDvij/lHes8COmAnFTcBzna2o04jCXxWuYe320d2l6IZ0VuAn+7ccy5ziTuTyzzjx7HwSWZhG9VMUVG8ynsN+uIhUYdCURXLEbmcm7gpBHVuIkuX8q7ProaHoswZHObbbsl1i2eleLR35mkqEEgrp1so+8ja7T7o4kLNfpN5J6DrlSG
 FoP3N1dk
 me4f8zxFy9tkOo7nbeA6yiAH5Ano/XQkPPXlofHYDPJluIzLTlxSJ7q2Hza1/oBC2doNLn3zjJ0av+cBXrhA4OyBUP9wjucdUnMfP1/OLncgIEglWkyzHljzB3FZZWlTkFPTUNZzuze5S+GRvJbMx3pcoFEDKts7jLNOb2m7aQ7BlS00oeDbghmec47wbmYUa1tEb/zkfFoc2SiYrkpfoFBeYmHpjKEilRsZJJJKLcHjFFG7PB9dthXawLtBrE5VKcMgOnA1YV4nSpDzODaMbQVfyIZkBZKky4qHs/5xQdjuIjKSMh0Rbuw+2KEWfNl8g1GP+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

slab_debugfs_init() creates the slab debugfs root at device initcall
time, while slab_sysfs_init() moves slab_state to FULL at late initcall
time. SLAB_STORE_USER caches created in this window miss their debugfs
entries because do_kmem_cache_create() skips debugfs_slab_add() when
slab_state <= UP.

The affected window is:

  slab_debugfs_init()
    slab_debugfs_root = debugfs_create_dir(...)
    list_for_each_entry(s, &slab_caches, list)
      debugfs_slab_add(s)

  kmem_cache_create(..., SLAB_STORE_USER, ...)
    do_kmem_cache_create()
      if (slab_state <= UP)
        return without debugfs entries

  slab_sysfs_init()
    slab_state = FULL

Initialize the debugfs root and add debugfs entries while
slab_sysfs_init() holds slab_mutex and walks slab_caches. This gives the
sysfs and debugfs initialization an explicit order and prevents caches
from being created between the debugfs scan and slab_state reaching
FULL.

Since the debugfs root is now initialized later, a cache may be released
before the root exists. Guard debugfs_slab_release() in that case to
avoid looking up the cache name in the debugfs root directory.

Fixes: 1a5ad30b89b4 ("mm: slub: make slab_sysfs_init() a late_initcall")
Cc: stable@vger.kernel.org
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
---

Changes in v2:
- Move debugfs root and cache entry initialization into
  slab_sysfs_init() so both use the same mutex-protected cache walk.
- Guard debugfs_slab_release() against an uninitialized debugfs root.
- Update the commit message accordingly.

v1: https://lore.kernel.org/linux-mm/20260720145124.3684976-1-lixiasong1@huawei.com/

---
 mm/slub.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9ec774dc7009..70e9aeda6a8f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -339,8 +339,10 @@ static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_SLUB_DEBUG)
 static void debugfs_slab_add(struct kmem_cache *);
+static void __init slab_debugfs_root_init(void);
 #else
 static inline void debugfs_slab_add(struct kmem_cache *s) { }
+static inline void slab_debugfs_root_init(void) { }
 #endif
 
 enum add_mode {
@@ -9771,11 +9773,16 @@ static int __init slab_sysfs_init(void)
 
 	slab_state = FULL;
 
+	slab_debugfs_root_init();
+
 	list_for_each_entry(s, &slab_caches, list) {
 		err = sysfs_slab_add(s);
 		if (err)
 			pr_err("SLUB: Unable to add boot slab %s to sysfs\n",
 			       s->name);
+
+		if (s->flags & SLAB_STORE_USER)
+			debugfs_slab_add(s);
 	}
 
 	while (alias_list) {
@@ -9985,23 +9992,16 @@ static void debugfs_slab_add(struct kmem_cache *s)
 
 void debugfs_slab_release(struct kmem_cache *s)
 {
+	if (unlikely(!slab_debugfs_root))
+		return;
+
 	debugfs_lookup_and_remove(s->name, slab_debugfs_root);
 }
 
-static int __init slab_debugfs_init(void)
+static void __init slab_debugfs_root_init(void)
 {
-	struct kmem_cache *s;
-
 	slab_debugfs_root = debugfs_create_dir("slab", NULL);
-
-	list_for_each_entry(s, &slab_caches, list)
-		if (s->flags & SLAB_STORE_USER)
-			debugfs_slab_add(s);
-
-	return 0;
-
 }
-__initcall(slab_debugfs_init);
 #endif
 /*
  * The /proc/slabinfo ABI
-- 
2.34.1


