Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A9ECA9EC7
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 05:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9288F6B008C; Sun, 11 Oct 2026 01:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9846B0092; Sun, 11 Oct 2026 01:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C84C6B0095; Sun, 11 Oct 2026 01:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E03F6B008C
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 01:00:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 929708062D
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 05:00:13 +0000 (UTC)
X-FDA: 85309143906.01.2F2D7A5
Received: from mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70280C000A
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 05:00:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eQ86C4gM;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.33 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791694811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWf5+kAlVZ3NlUWq6MfX5/TjTbRn6hDbTeK1rL7ppB4=;
	b=tbIzYoCUV8GHdAQR/Ha5wd15oCQJMHgdDCRQBDlesVaRAQ2AVNGi/nk4Wpfo3/8G8eoRZO
	jc1rgRE4oQ3U8u92unNCuUmk2+ly7cu/7JRyLVuYa8h3fOYKztYlW+wnte3Eyk1V9yCqwv
	fxu3VTUmqKlPpE/z8+t7XiX/n4zQZzM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791694811;
	b=ePrNXs6D2BKih4TaDLzOR6mrsIubiu9nWhvxLpGihk2oTzEpUzZsAIGVEB67dcISqrz7P9
	HYkae4GIM0MSR4qyt0/w7JLzZwzgEjPx5sPrXZOCTW4XCPbtgt4yJ+95AgVDk+jxJaUvmF
	RcZQkQXJGHRsDrx2k/8ZzsssbxhvEWo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eQ86C4gM;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.33 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1HuUJaxdjLUcaFiwr5i8Gt9zxnjbL+m1NmdgUhx7MSk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791694809; v=1; x=1792299609;
 b=eQ86C4gMs4ibqqMZu8e33y9Yqfuchn35YGYQgnZCI6j1mrgfYOUXLsJHHMNNVbh/P+CMWofR
 a60NDVka10ARwLg8rTQNIn1XrML+CPzJrd+4A+jlLO9BSbJDgdDgPeaIdgy67b2GpNiDLMTi+ck
 dVOb+q+2GDWinoCYOIj+JEsc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0d66700324061ff8;
	Sun, 11 Oct 2026 05:00:08 +0000
X-Mizu-Trace-ID: 0d66700324061ff8
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	yi1.lai@intel.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH] mm: shmem: assign a lock class to the unused huge shrinklist
Date: Sun, 11 Oct 2026 12:59:56 +0800
Message-ID: <20261011045956.30277-1-qi.zheng@linux.dev>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261010161622.3a460fdbcd6765adb5c1eb7f@linux-foundation.org>
References: <20261010161622.3a460fdbcd6765adb5c1eb7f@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 70280C000A
X-Rspam-User: 
X-Stat-Signature: skb8eqwdjfqaydq5dw4juwonrfwbnewg
X-HE-Tag: 1791694811-592109
X-HE-Meta: U2FsdGVkX1/hKr1boJYdP3RWUDiTTEcuA62kE9vE/5XFUL97GgVvYfNBXXhuaQveHbMTMMJ4Q5KgTDGBVvjwR22xFNioS/Khs/qPdwizetsimoq8YF52XfC6uiuXVbCt7R7Ow3qL9D8HEKoXjf0FXc3JitYnBfInaeUsRr8gQE0RWJyNC/LFulYKaD38ULUXqHamb4tvELK4t9UtCD6vByntlyW9gcv1qRFHvuR0f5yNSl0Eo7X8dw2fAxd+EW2RM6jTlNNygtABxgedFwqsjMxcMEhP0FiltTeSNJQfO5FANkBrAAxMQQcDAYFWfsS+DYKZInX9Ss0qn3lg4gS5QwDjVx7jv52tNRhe++x5oOuE4Jv7bM8N9iVFKEmR85eh2uEMg/OuknhLvy6ZeSB+ahlaGhvEtapWlybm365chvV/xRg7PmBQi5PCnlm37qku7rWn3tT+weqZM4a9Te2Zlyguz+MVsIQ6mJPVmyfBqR2ysNlcH7c+trXEDY8qtC2VkwdFPMAnBfEExyI+YU9ND8dGmF2T3ZINUgBDCa7Rhs4saePc/25a0q4AUSlD2Qkv+4SHaTvaSNBwQ7zoTTfmDxKlLJv4iyWxTgD5dapmw1YIvuHWkm3P/JtFhocAYbsm1kpz85B9Ny6L9XiO9ijsIvVefYkt6AYD/2IJC8gbEqvR4iaW7MV6oRVYw8DOxJ2txreg0y1aPnzDdgvwFascFv4U95YomK0QbgYkj/iQzNJjnRqZAm/XEhOWWfKu5lhuBKf4m4gvBzmUonNhayNYcBt3+c4ncPOX1L6a0oW03GiXDVW7p5vbYeQ7XCG50jbePzZ3lXuhE/K5q6xvL/2/B3ZFKaW7pQdBWWd1RqP4Dvq3I59pbFwlVg6usLyTYtD1/rwrVBttja2JFp2a6ouTGEmB12ctKb0FqsdLbqF1qJ5wN4AMcfZKerncNHMHPap/sxaYwEjA0XugPGgn+m2
 SBeezy3j
 2knyAh56dNj2mIRtCdqJuHY7ZBsoFaOzpJXTDAIOo2C+MF0ifCxE/cRLvYZWblSY5OxI9w1+rFE9stQN2g5Hhte77Q5uFbVYxITzQu4XoGIxYcQVP9kGH695cmdbQ7YwZ/h9qf0UlN6VYMmak0YkAkGmyIRq20KHCb+1tZ9cxI4hlr/nzWS8cK6hAUQNykpl1QFXdEv6BxGw3yYpMi1vTfzgA5jydQ1wd4spARsraCgofICOPcdmJ2tXwFAiVtt/933CWogKpWzJACh0Sfjm8EVhx7d+fPNyQ53A8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The unused huge shrinklist shares the default list_lru lock class with the
dentry LRU.  Although they use distinct lock instances, lockdep conflates
their dependencies and reports a circular locking dependency:

	WARNING: possible circular locking dependency detected

Give the unused huge shrinklist a dedicated lock class to fix this
false-positive lockdep warning.

Fixes: b9b1861d4f7a ("mm: shmem: make unused huge shrinker memcg aware")
Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202610091403.d1d8080b-lkp@intel.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/shmem.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5a9bcc7c66926..a6e3c9c7f72da 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5164,6 +5164,9 @@ static const struct dentry_operations shmem_ci_dentry_ops = {
 
 static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 {
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	static struct lock_class_key shmem_unused_huge_lock_key;
+#endif
 	struct shmem_options *ctx = fc->fs_private;
 	struct inode *inode;
 	struct shmem_sb_info *sbinfo;
@@ -5243,7 +5246,8 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto failed;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (list_lru_init_memcg(&sbinfo->shrinklist, sb->s_shrink))
+	if (list_lru_init_memcg_key(&sbinfo->shrinklist, sb->s_shrink,
+				    &shmem_unused_huge_lock_key))
 		goto failed;
 #endif
 
-- 
2.54.0


