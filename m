Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749E5CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 08:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978F98E0026; Mon, 18 Aug 2025 04:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A2A8E001E; Mon, 18 Aug 2025 04:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F518E0026; Mon, 18 Aug 2025 04:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71BC68E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:58:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB8BF5B81A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:58:11 +0000 (UTC)
X-FDA: 83789276382.05.7DFD71C
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id A131D180003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:58:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755507490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=5fmc4UqLdT/9R4E8ZqQJSI8helzRM4G6X5+/ol5HTro=;
	b=uad7HNCK3nVvHVcexRxi4wzLFHHHUf58ePpN5YNmiOCpguNf/VTuuUcWJ1A3gMx4oJrMtE
	PTT4d7Wa7SIRR+FtDzP/MKSOLU2JvY5GgGJgSaBT245Tl6FUmHDYB8mO4x1ne9DvNuytbJ
	NayRUwvrgMrwgtdVjouwWj/4pvWI/+E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755507490; a=rsa-sha256;
	cv=none;
	b=Kg9Z7mUuLHJBYgEqjnJj4mIUSxr81/rO7QShr4YKVg6hQ5P9qOoGjO0FbYDeOLuZ/3avrT
	/LGTp1J/rsYYYMO5R7jecIUDZWVEg3yqAZ+dDQlXr6CJrI4N7LnqcSgDQsc2F4GawlT3V+
	AkrX995sIQZ4bYdBHAiKvDw1dgQjmoU=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c56662ft3zpbjR;
	Mon, 18 Aug 2025 16:57:02 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id A34CE1401E9;
	Mon, 18 Aug 2025 16:58:01 +0800 (CST)
Received: from huawei.com (10.67.174.33) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 18 Aug
 2025 16:58:01 +0800
From: Gu Bowen <gubowen5@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <linux-mm@kvack.org>, Waiman Long
	<llong@redhat.com>, Breno Leitao <leitao@debian.org>, John Ogness
	<john.ogness@linutronix.de>, Lu Jialin <lujialin4@huawei.com>, Gu Bowen
	<gubowen5@huawei.com>
Subject: [PATCH v4] mm: Fix possible deadlock in kmemleak
Date: Mon, 18 Aug 2025 17:09:44 +0800
Message-ID: <20250818090945.1003644-1-gubowen5@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.174.33]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemh100007.china.huawei.com (7.202.181.92)
X-Rspamd-Queue-Id: A131D180003
X-Rspam-User: 
X-Stat-Signature: zg58kp7hxw65bjsfu5ggza1ncmq3rr7w
X-Rspamd-Server: rspam09
X-HE-Tag: 1755507488-680377
X-HE-Meta: U2FsdGVkX1/t2hV5JwwTwzCgsRPX1JWWnisHwZcaT08PPgQ1620HQG1kbrff2FHIReFkWBhJqh2hWREbjCQGo378AgMUTzklopffHlLUatKSHKZd7++5X23hcfQnS1Bj4H0jRuZeoJubDjxWIiYrkOhjsm9oPxolsGfk7CJAupJhjeIaNr3CrTetP2Wu3Blhd+CjmoHtX2qK0KBsvxjeLdTFSpF0lC6Jf9NFX0XRQ1LbaSu+ccesXT6JrmQ8k7Zix6vts6a6kABLb1BXzWhHlfTitxlDzIfRGnr7HLM7m9qDxDNfK7YU4sn0udfAxaCbbLJiQt6Nf3x4kIU3mOd8qO+mii/68vixnm/1c0A9db8Z7qACYfEvtERUaC0pfl/cvSjRBSD59olqd9i9zOVMOzOd4OGAtEWuZELWMvDhb8EAtUZ6zZFvF5k0jtZGM4zW9CRbkufEXuYaKOucGIHTS0H4HrIztu/kIzMBK6LTdQa0XFYe4YrInZLM1C9pOQRQu5GKVcmIlNTFLShKIYL4h3T6n7ZW6MSXH9V96fGdiPXFqsFzk+LOvGuHBca17ml1bLnNavGXlmPmh0rg+M6tR/5R2VLFPco8lcgFKfiwoalSKIWpinlD3OZ3k51llDgsUw+epxnXzRZMnpTH68Pbx6E4vgdMfT2jLR9Ko8uHJO/f3Kq52ZmZgsoeodqEWcKlmSqlcvujMokk6LNeUNp6tIKic33ZdAlsxhL1jAo9itcat75nCUgQDSHRnHT1UnREZZJeSpQd7K0MKSo6EMTBa8Gh6qC02qjweOVq5nLsA3Sv0DcrZP+TyemBB5GsUAPRGTezUR9C4IMxXBPBzROcI1OyRuLkiHFP05LhRCecyq/zndU9DhxM6AjuWELQtEFowBU9uom/tNoyJnrqNu/BL8x7ShZ9qaO52K5nKz8utOi3XzlJ0WKjXqOuH3YA1XNDpMYV5gtzE/PMR7GTD5H
 SPS3JlNA
 p3O95sjP+hMA7CdnMMsLbrQyKwanLvqJDP3pSQmmVjQBn4hcDS6UnKvpJbMwCO8tlq6C/OUnyKokLQO17k0jAqkgNOjoJ3ScXhyCE4fdz9gUKeWKHkkdwnHbqXIqEnoVtt+cO5VHNgz2RzfrEgZ4T6AI82OkMLzxuKgfxRgarUHgJURFBdIrz9FUXLL/sqzhKPk7Ud4BBANKdJ4B6y803BmJWIQNvNY/khqp/huW7QxKePINejoH8rnz7KLarNurS9Cu4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Our syztester report the lockdep WARNING [1], which was identified in
stable kernel version 5.10. However, this deadlock path no longer exists
due to the refactoring of console_lock in v6.2-rc1 [2]. Coincidentally,
there are two types of deadlocks that we have found here. One is the ABBA
deadlock, as mentioned above [1], and the other is the AA deadlock was
reported by Breno [3]. The latter's deadlock issue persists.

To solve this problem, switch to printk_safe mode before printing warning
message, this will redirect all printk()-s to a special per-CPU buffer,
which will be flushed later from a safe context (irq work), and this
deadlock problem can be avoided. The proper API to use should be
printk_deferred_enter()/printk_deferred_exit() [4].

[1]
https://lore.kernel.org/all/20250730094914.566582-1-gubowen5@huawei.com/
[2]
https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/
[3]
https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t
[4]
https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/
====================

Signed-off-by: Gu Bowen <gubowen5@huawei.com>
---
 mm/kmemleak.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 84265983f239..26113b89d09b 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -437,9 +437,15 @@ static struct kmemleak_object *__lookup_object(unsigned long ptr, int alias,
 		else if (untagged_objp == untagged_ptr || alias)
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
@@ -736,6 +742,11 @@ static int __link_object(struct kmemleak_object *object, unsigned long ptr,
 		else if (untagged_objp + parent->size <= untagged_ptr)
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
@@ -743,6 +754,7 @@ static int __link_object(struct kmemleak_object *object, unsigned long ptr,
 			 * be freed while the kmemleak_lock is held.
 			 */
 			dump_object_info(parent);
+			printk_deferred_exit();
 			return -EEXIST;
 		}
 	}
@@ -858,8 +870,14 @@ static void delete_object_part(unsigned long ptr, size_t size,
 	object = __find_and_remove_object(ptr, 1, objflags);
 	if (!object) {
 #ifdef DEBUG
+		/*
+		 * Printk deferring due to the kmemleak_lock held.
+		 * This is done to avoid deadlock.
+		 */
+		printk_deferred_enter();
 		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
 			      ptr, size);
+		printk_deferred_exit();
 #endif
 		goto unlock;
 	}
-- 
2.43.0


