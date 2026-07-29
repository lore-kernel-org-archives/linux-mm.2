Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 731F2C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3106B00DB; Wed, 29 Jul 2026 10:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3A56B00F8; Wed, 29 Jul 2026 10:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9A96B00FA; Wed, 29 Jul 2026 10:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 387D06B00DB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:42:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8011E40661
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:57:18 +0000 (UTC)
X-FDA: 85041361356.09.3C59F93
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf03.hostedemail.com (Postfix) with ESMTP id E6DFE20006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:57:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=I2AU6TlI;
	spf=pass (imf03.hostedemail.com: domain of lixiasong1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=lixiasong1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785319036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Wjfz7u8Jjtoo9lneWaMiq4ptplMXYpCDbTPTzsZbqGY=;
	b=ihUw/1EwD5QROKSYumnuQgwMgN/tTOIWu6bV8PnDus8T9A0ytvmsjGtRw6j6USK6lBPyyU
	uLiW2/0FZOjntZ5YosTznn0bY7f3GBK2G2sdtvt/kQ1ctACoU/+YslgVL8x9xGOUdo6Vdx
	emJXNVok8uiNFOmr5e5bbu9Ip+9jojg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785319036;
	b=nfRQq6hKH5ndusQ6j5h8h7ddkSIaZ+lU49bC1+qj6jZf+UCbKp3Y/COooZUYYT9jDAYXi3
	vzlqfzoO91Qg+uDkRHE5NNFaW4vobT6gsAy2ZBDRj6YXvkyZD+B97c8ZX7m7sATGQ2vIdv
	5ha+Kaq3MMBQmnnvG/qvQjZJs6pxhuc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=I2AU6TlI;
	spf=pass (imf03.hostedemail.com: domain of lixiasong1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=lixiasong1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Wjfz7u8Jjtoo9lneWaMiq4ptplMXYpCDbTPTzsZbqGY=;
	b=I2AU6TlIkp48Hpytaiu6thA046L8hywVvahEPl/bM0sDfoILItxbSuGKeSeM0qIGiC/pW47+1
	TKrcq9mIeaK3z7P9Zy3A+1dNeqPmE0fgpilAue+avNo7wsJ2LihZfDP9/u9aIIIDK5E+4KQ2+dk
	x9C75brrzOEPm8EmCRvP1ko=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h96vJ40q0zKm6V;
	Wed, 29 Jul 2026 17:47:40 +0800 (CST)
Received: from kwepemj500018.china.huawei.com (unknown [7.202.194.48])
	by mail.maildlp.com (Postfix) with ESMTPS id 15A794057A;
	Wed, 29 Jul 2026 17:57:10 +0800 (CST)
Received: from huawei.com (10.50.85.128) by kwepemj500018.china.huawei.com
 (7.202.194.48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 29 Jul
 2026 17:57:09 +0800
From: Li Xiasong <lixiasong1@huawei.com>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>
CC: <stable@vger.kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter
	<cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>, <zhangchangzhong@huawei.com>,
	<weiyongjun1@huawei.com>
Subject: [PATCH v3] mm/slub: fix missing debugfs entries for caches created before sysfs init
Date: Wed, 29 Jul 2026 18:18:49 +0800
Message-ID: <20260729101849.3734287-1-lixiasong1@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.128]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemj500018.china.huawei.com (7.202.194.48)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E6DFE20006
X-Stat-Signature: 71ncjqsfunxuyzf6j4c4nfnyuz9pdm4h
X-Rspam-User: 
X-HE-Tag: 1785319034-419990
X-HE-Meta: U2FsdGVkX1/p4DphISqWlY8iTXkW74rBvOvFp254fzMpwWoJdYA5GXWwobu94bCYTCaKk1MCALWyD7kv9Jm/5Fub3PPZ6BAfSd5YJoV+cOx85hBrXTOsA4Hq2w/rPcImOc1H6pwME57ySDkh8A0gwA9ZaD7IWxQ2JlS0RviPZsIiedtbebGv/FaPoXSB0kD8Lv18eAVYfmnhcjS07FPZKtpOLfKIcS37LQwZGVzGcQ9kByl++KVmINejJ3IoU/1gpjA5w69FmrAe9qFhU0LweJkjI+jzVyRJFLSY6ju5pBvSbMUq5MnbcREinFtAH/DLMhacrwCfnzb0Itgu1uWBehyHra2nrF1m+B/c0rP2zJV02XmqtkX/cXjDOQt9lWHGFiFyeZ5OmYhdO7t28y3H/AUPGQkmEYIFm+JGtY8PUViaS1wSyHqt8CxJmcnyGm7flTw6yRfWU/j9SpRnPFL5lSnolQfvvliurTir1lFXv5uiSc3Qr/zJxn1Lbi3g70Q5wlUFwVhJ+PZBRmBcf2ZGxIw4uRgxwqeGtkV9kiFt/u/mbMY7Ni0jhEbYyjt20j50gWv8EilBlWdVwDF4u4zdnZX5Uvvu2pemhuxHEjZxA5ZhfSMbTmH7DWex2ceC8cBGtdNz/f4E+eLQiHJ71PRkPeZnC4emrFms82NPVqirNkK/RtkJdPAVcH+zHYC18aiauJYXfHcLQ9xVU4tmqXDlsYQJ5c9NJyqbtMf1o5tySrUir8gp4MfPw3q9ijsVzjDJFsQ2O53MxZWkCYkPNVzTA55cwKu0z6u/IFNLS6W2qe0XvhcmZ7g2Vmnpv7Ats5Nv+k+1DsXFPYrY1m0WTMWx4eSaYr7bx7POTJ0GOJGrnyG5vsL/RlhrCOGwWClKPg7IdLa45FXwoQQKaeuxYZ0hhzzzn5+Y9mJOx3paDwwJlS1O2wg/HBgKmbIG6A5RBPZPkK6hlmZIE1PeqPR2vdV
 ZlgjNZCI
 nmNGscRGPblA6234mgIUQ5gqIKp1Qqrs4I9q4qeQRtF373Wn8AzGjeW28oLODMYZkNAKl84iPagIbkE6LkKGR/nG+3gfMALMpwQ0Dv1ViA8/tUa5i2i0emGPp9R2rbzkmD40p7fqkeWFfoGsk8fPN+lw+/ZiATN0MytHLweoPyAsCqlHmTWLAQ931pyOQOWu26qG57q/u5qM78pUpFownek2Gb0xPYS95IIC/C95/OyzvhzVJo2hM7Sv6Kj0wtyYtcuGOxcH2urmk7Ahc/OXk2Aoyahg5uEmB+J7+MnLzKcT6DHnCpXREry4/GajIEdhTeJMv
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
slab_state <= UP. This was observed with MPTCP's request_sock_subflow_v6
cache, whose slab debugfs directory was missing.

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

Initialize the debugfs root and add debugfs entries while holding
slab_mutex, walking slab_caches exactly once and handling both sysfs
and debugfs entries in the same pass. This gives the sysfs and debugfs
initialization an explicit order and prevents caches from being
created between the debugfs scan and slab_state reaching FULL.

Gate the new slab_late_init() on either sysfs or debugfs being enabled,
with the slab_kset creation and alias_list processing factored into
helpers that have empty no-sysfs variants, as suggested by Vlastimil
Babka. On slab_kset_init() failure, slab_state stays below FULL so
kmem_cache_create() keeps taking the early-boot path, matching prior
behavior.

Guard debugfs_slab_release() against an uninitialized debugfs root,
since the root is now created later and a cache may be released before
it exists.

Fixes: 1a5ad30b89b4 ("mm: slub: make slab_sysfs_init() a late_initcall")
Cc: stable@vger.kernel.org
Suggested-by: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
---

Changes in v3:
- Introduce a generic slab_late_init() that runs when either sysfs or
  SLUB debugfs support is enabled.
- Factor slab_kset initialization and saved alias processing into
  sysfs-specific helpers with empty no-sysfs variants.

Changes in v2:
- Move debugfs root and cache entry initialization into
  slab_sysfs_init() so both use the same mutex-protected cache walk.
- Guard debugfs_slab_release() against an uninitialized debugfs root.
- Update the commit message accordingly.

v2: https://lore.kernel.org/linux-mm/20260723115532.761920-1-lixiasong1@huawei.com/
v1: https://lore.kernel.org/linux-mm/20260720145124.3684976-1-lixiasong1@huawei.com/

---
 mm/slub.c | 76 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 28 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0337e60db5ac..4ef84de4f3d7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -333,14 +333,20 @@ enum track_item { TRACK_ALLOC, TRACK_FREE };
 
 #ifdef SLAB_SUPPORTS_SYSFS
 static int sysfs_slab_add(struct kmem_cache *);
+static int __init slab_kset_init(void);
+static void __init slab_sysfs_process_aliases(void);
 #else
 static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
+static inline int slab_kset_init(void) { return 0; }
+static inline void slab_sysfs_process_aliases(void) { }
 #endif
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_SLUB_DEBUG)
 static void debugfs_slab_add(struct kmem_cache *);
+static void __init slab_debugfs_root_init(void);
 #else
 static inline void debugfs_slab_add(struct kmem_cache *s) { }
+static inline void slab_debugfs_root_init(void) { }
 #endif
 
 enum add_mode {
@@ -9734,28 +9740,20 @@ int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 	return 0;
 }
 
-static int __init slab_sysfs_init(void)
+static int __init slab_kset_init(void)
 {
-	struct kmem_cache *s;
-	int err;
-
-	mutex_lock(&slab_mutex);
-
 	slab_kset = kset_create_and_add("slab", NULL, kernel_kobj);
 	if (!slab_kset) {
-		mutex_unlock(&slab_mutex);
 		pr_err("Cannot register slab subsystem.\n");
 		return -ENOMEM;
 	}
 
-	slab_state = FULL;
+	return 0;
+}
 
-	list_for_each_entry(s, &slab_caches, list) {
-		err = sysfs_slab_add(s);
-		if (err)
-			pr_err("SLUB: Unable to add boot slab %s to sysfs\n",
-			       s->name);
-	}
+static void __init slab_sysfs_process_aliases(void)
+{
+	int err;
 
 	while (alias_list) {
 		struct saved_alias *al = alias_list;
@@ -9767,12 +9765,41 @@ static int __init slab_sysfs_init(void)
 			       al->name);
 		kfree(al);
 	}
+}
+#endif /* SLAB_SUPPORTS_SYSFS */
+
+#if defined(SLAB_SUPPORTS_SYSFS) || \
+	(defined(CONFIG_SLUB_DEBUG) && defined(CONFIG_DEBUG_FS))
+static int __init slab_late_init(void)
+{
+	struct kmem_cache *s;
+	int err;
 
+	mutex_lock(&slab_mutex);
+
+	err = slab_kset_init();
+	if (err)
+		goto out;
+
+	slab_debugfs_root_init();
+	slab_state = FULL;
+
+	list_for_each_entry(s, &slab_caches, list) {
+		if (sysfs_slab_add(s))
+			pr_err("SLUB: Unable to add boot slab %s to sysfs\n",
+			       s->name);
+
+		if (s->flags & SLAB_STORE_USER)
+			debugfs_slab_add(s);
+	}
+
+	slab_sysfs_process_aliases();
+out:
 	mutex_unlock(&slab_mutex);
-	return 0;
+	return err;
 }
-late_initcall(slab_sysfs_init);
-#endif /* SLAB_SUPPORTS_SYSFS */
+late_initcall(slab_late_init);
+#endif
 
 #if defined(CONFIG_SLUB_DEBUG) && defined(CONFIG_DEBUG_FS)
 static int slab_debugfs_show(struct seq_file *seq, void *v)
@@ -9964,23 +9991,16 @@ static void debugfs_slab_add(struct kmem_cache *s)
 
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


