Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A59C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 09:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0FDB6B00D6; Thu,  7 Aug 2025 05:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA066B00D7; Thu,  7 Aug 2025 05:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCFD26B00D8; Thu,  7 Aug 2025 05:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD2076B00D6
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:03:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D7071A0901
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:03:24 +0000 (UTC)
X-FDA: 83749372728.12.283E448
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf20.hostedemail.com (Postfix) with ESMTP id E810C1C0011
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:03:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754557402; a=rsa-sha256;
	cv=none;
	b=bkn/CLsQDlZRv1fdxoF2FdAOU7Fi2vfYqIZx7gjaWl9yxBE1g+HK8OFmb87nJVq9wC7jGt
	lWxqVV1tz0lXlVuezMaN1MBLbNu3Uh0Ktls0SXxqQedJm2FxvqHGtqBa7mdYIica5kgIaG
	UG1ynLj4f+MlpFN9wGQIHgfqRL0Un9Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754557402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=qP64ARyfmz6aT4JOMq3Ij3BTyOabvY+AaH2W3rAlpxk=;
	b=hAzWR3gbYKZ0b0jXvnza4r8cLDZexPoKczs41oQxVrGitjRODfgJjSD2A/TIwEq7N4TGvp
	d3AJvQMM9pNp8tzaqe0KcE8tmioZEhXB0Da3M0I6FOd/k0w7zKhco1OBs0/AkurR/Ck6Ul
	4l/xsXpgzatOUWQSB/bI5o3LctnonD0=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4byLhd0f2lz13MvG;
	Thu,  7 Aug 2025 17:00:01 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id 788CB180B60;
	Thu,  7 Aug 2025 17:03:17 +0800 (CST)
Received: from huawei.com (10.67.174.33) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 7 Aug
 2025 17:03:16 +0800
From: Gu Bowen <gubowen5@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <stable@vger.kernel.org>, <linux-mm@kvack.org>, Waiman Long
	<llong@redhat.com>, Breno Leitao <leitao@debian.org>, John Ogness
	<john.ogness@linutronix.de>, Lu Jialin <lujialin4@huawei.com>, Gu Bowen
	<gubowen5@huawei.com>
Subject: [PATCH v2] mm: Fix possible deadlock in console_trylock_spinning
Date: Thu, 7 Aug 2025 17:14:44 +0800
Message-ID: <20250807091444.1999938-1-gubowen5@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.174.33]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemh100007.china.huawei.com (7.202.181.92)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E810C1C0011
X-Stat-Signature: 9o5zgmujk7cpi7bidhii9to4ktsngxsh
X-HE-Tag: 1754557401-234176
X-HE-Meta: U2FsdGVkX18p6Gcn/hWsubXcYzWmQe39w4rH3ub6ISDlmZFg5N2yEvsGErMdE+Vv/ASEvEe+Upuuzfyfg+7b/Lxty2vPJaCTD0pz4b2KIlODxsHY+gY2bl6ofMsD+goobHEkhTJr38t5GseTWtDMC8+/IMNq+qcoEMK41NlhIRsPG2eAjOvRJHXf4D0nj5QpHx//6O1zq29r4h2x9pbQ+7PZOgab3w8VLA8VsfZ+1uhzNrgVmrpgYnLCOG3ZL3K5axyNE+RoFnrMtTQkvrOBWDJIPbmt569zVQhWaIZ9bwDWXsgu0WOIK5Zc7MRi+HyS7OSxWCQeOzj/ixgCkcJz+Jgxd7rXpk1fRtnVRR8l20u+D8n6SaeH7UjfvLHrLsuKbb8vAoY94cDeCtP4AqrkWnGWPEQdTvR3aiOFKjuYJWqZEEwG53iET4S5WgBY/enJiTtL+BJDA/SlmTF//H53D0N/8RsC5jsGkABlip6l1N0cuRNUivt3hZ20iXdekTFEkmwTcXhl8rrBVkf0OLxTf0BD2xxNlTceagRCrpHebV8KavIvl6fX9F7cskVEOGiS0v+EhkdPxlE87bBfGW1BSb4WSYzt4UGc9mNZu0/c/Rsn8d69QpLMgNnWc7qysYCTCzBc4bsWTanfFsEh3KPXnz2uDyXnH9wR1CuVxVtNLl6RsWxdVQzqKGPoucgapgtxb1xqN+Hglty5uO0Pyps/87ThVqfsYICDFxN+Q/E5ziN1SKzmcLNhr8VVqsR+RItRg4uREG6oOomN1ClZKyG5pSrCShsHZQGZZgaWMT/ua21LRYrpFqXlAO3QguxH0fvb9Mc1Qdh3j69Q3UfwVGuIDw57lkDFQm9cErmJ0wwVhtrNuhfQGp65sVxxIuVNPKwVnOG1ov5xpXptqeu5oJ3sTiRt+mafosNf3SKo2ueBpf5S2vS40R9cEogbaxCtH4o81scO0I5yya8pTRfqFDT
 F/afYNn4
 crkGwnF7LiOj9xl1SHGL+VFWm4PpBAug01P/i1UK/cQ+W5carZ9bsKyko21liXXSlooTIkoSBcE8mPv56mNTEQG8GITX+Hd/X7+9SlRTD5LcfS4T5fhByf9iTDiJTFDKu+h/d8hbwms6XpcSO7k0UsXa6I5iu8NqfD8llKkygIpf5w4Lk/iLod33VzIQHxfPQ3H3A4t9/igtuThkPlBqWMrlzGr9467Ly9PcO8SAqEkFjAf1eawx876ODYxxsSIOOIR9lHxnIcSfDuSzoiQb5EzY3htkcbIn6SUokvqv6nBe4zXG6RC1ZaQeb2scqBspfzgHRQ2NIfQlb/I7UqhW2r4hHCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Our syztester report the lockdep WARNING [1]. kmemleak_scan_thread()
invokes scan_block() which may invoke a nomal printk() to print warning
message. This can cause a deadlock in the scenario reported below:

       CPU0                    CPU1
       ----                    ----
  lock(kmemleak_lock);
                               lock(&port->lock);
                               lock(kmemleak_lock);
  lock(console_owner);

To solve this problem, switch to printk_safe mode before printing warning
message, this will redirect all printk()-s to a special per-CPU buffer,
which will be flushed later from a safe context (irq work), and this
deadlock problem can be avoided. The proper API to use should be
printk_deferred_enter()/printk_deferred_exit() if we want to deferred the
printing [2].

This patch also fix some similar cases that need to use the printk
deferring [3].

[1]
https://lore.kernel.org/all/20250730094914.566582-1-gubowen5@huawei.com/
[2]
https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/
[3]
https://lore.kernel.org/all/aJCir5Wh362XzLSx@arm.com/
====================

Cc: stable@vger.kernel.org # 5.10
Signed-off-by: Gu Bowen <gubowen5@huawei.com>
---
 mm/kmemleak.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 4801751cb6b6..381145dde54f 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -390,9 +390,15 @@ static struct kmemleak_object *lookup_object(unsigned long ptr, int alias)
 		else if (object->pointer == ptr || alias)
 			return object;
 		else {
+			/*
+			 * Printk deferring due to the kmemleak_lock held.
+			 * This is done to avoid deadlock.
+			 */
+			printk_deferred_enter();
 			kmemleak_warn("Found object by alias at 0x%08lx\n",
 				      ptr);
 			dump_object_info(object);
+			printk_deferred_exit();
 			break;
 		}
 	}
@@ -433,8 +439,15 @@ static struct kmemleak_object *mem_pool_alloc(gfp_t gfp)
 		list_del(&object->object_list);
 	else if (mem_pool_free_count)
 		object = &mem_pool[--mem_pool_free_count];
-	else
+	else {
+		/*
+		 * Printk deferring due to the kmemleak_lock held.
+		 * This is done to avoid deadlock.
+		 */
+		printk_deferred_enter();
 		pr_warn_once("Memory pool empty, consider increasing CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE\n");
+		printk_deferred_exit();
+	}
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
 
 	return object;
@@ -632,6 +645,11 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 		else if (parent->pointer + parent->size <= ptr)
 			link = &parent->rb_node.rb_right;
 		else {
+			/*
+			 * Printk deferring due to the kmemleak_lock held.
+			 * This is done to avoid deadlock.
+			 */
+			printk_deferred_enter();
 			kmemleak_stop("Cannot insert 0x%lx into the object search tree (overlaps existing)\n",
 				      ptr);
 			/*
@@ -639,6 +657,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 			 * be freed while the kmemleak_lock is held.
 			 */
 			dump_object_info(parent);
+			printk_deferred_exit();
 			kmem_cache_free(object_cache, object);
 			object = NULL;
 			goto out;
-- 
2.25.1


