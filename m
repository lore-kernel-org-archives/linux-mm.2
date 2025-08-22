Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60C17CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 07:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3426B0027; Fri, 22 Aug 2025 03:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53EEE6B0028; Fri, 22 Aug 2025 03:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D6F6B0029; Fri, 22 Aug 2025 03:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1476B0027
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 03:23:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F3A11DD786
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:23:58 +0000 (UTC)
X-FDA: 83803554156.25.A79BCC0
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf03.hostedemail.com (Postfix) with ESMTP id 158A22000C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:23:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755847436; a=rsa-sha256;
	cv=none;
	b=3SInvN/U5uEZ0/6dzqPnre4AlPPhsRNDMsiXlh19BU5MWkJM7cKtM4KSAGw2GKQ4f0sOkg
	ri1QX34+08IYW3FfFZonHF+pzeQBwGXP8EZMfK7qx1YJvARR+bL9w+nlSRAVxtzzxfRse5
	aUejvhqFhAJOge0JwfKeUm8AQ2CLW4Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755847436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=a/NNzoi5Ne0fMAS/06BXSVF/gh8aGsljrg/ePT3NtW4=;
	b=oJrEJmYayRC49nT/iwkQCRNtVlhq7ATj86Y/EWdR6rmv0xzA/xuU5jt76256Xw/flI6vty
	h1FJ5MIQ8RA/TUkpBt0Fkffv/gbgCKLmR4r6fuPafNi3yhD1pnfm2jrrcfP3LCrBNGoDph
	vSYwq8WBM8untEnahHueT2a0U73mRM0=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c7Wrf0dhYz14MYw;
	Fri, 22 Aug 2025 15:23:46 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id AD39214027A;
	Fri, 22 Aug 2025 15:23:50 +0800 (CST)
Received: from huawei.com (10.67.174.33) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 22 Aug
 2025 15:23:50 +0800
From: Gu Bowen <gubowen5@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Waiman Long <llong@redhat.com>
CC: <stable@vger.kernel.org>, <linux-mm@kvack.org>, Breno Leitao
	<leitao@debian.org>, John Ogness <john.ogness@linutronix.de>, Lu Jialin
	<lujialin4@huawei.com>, Gu Bowen <gubowen5@huawei.com>
Subject: [PATCH v5] mm: Fix possible deadlock in kmemleak
Date: Fri, 22 Aug 2025 15:35:41 +0800
Message-ID: <20250822073541.1886469-1-gubowen5@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.174.33]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemh100007.china.huawei.com (7.202.181.92)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 158A22000C
X-Stat-Signature: d1wzxinppun9yih7p1annkh4stbajce1
X-Rspam-User: 
X-HE-Tag: 1755847434-894778
X-HE-Meta: U2FsdGVkX1/hM5w+MUI9OgurnxdXola5Fihwswmf0V8nV5P4EJeHxxZcyT2cD1E7aAJATzimqfI+avgeqyHXDyLWQ13oEdN2GkGTDTcKkeIWhN9QhkLMWHtBnmEmHdg0kCncJNY9QXjaV7WLT12QO2EZ+6H9BH8FTkvGke+Ziz0OlJxK/NI/uW5JHanFb3+mnttyRmlmr6kzBx5Ii95UD8MteCvQ4kqvKM/fe2REEYiRPVYRS3gqBZbZo3Pvqns9EsjuTOotN+xRclbytUKbPEsMopFvbiyKqAs7AlpRP7vPmSENucodWU7IAczh9Wn8fWftLOBnqtUIJB9b+FndFOrKfHNUYLyJJDG84vzAa2a1cagWw2SwsuMdxfvwdFORZhWTm2jQj89D8C27Mmp74IgNsDB0JSnf60CS4mmDw1PQIgRuSusgAWOOF2SEZ5vycVx5a326TYrAncJx15dk6kgESNhhBRSOdlzpbe9jRIPeNBP4GTj9z/5fD0BhJTxU9o/3UM5r1eVb5Sckd8w8yc5XrVj7ljBy4zh6rHgQmkB7/hWEUDrXhD5g6gSiKh5/RrGXKdUHoCgVCoVsO47m8N3MSDpOw0MxIX65xdV711/im/ASV9N3VRcSPf6cnceytvcGQfz+A9xuIF5CsA0CUlQ6Q4QUK033wV1QVTNcRkvo4dJmqd4/FF7rm2epPT50dk9TWn9KZubz3cE/JzM7SUd3OO7uE+gXL81YwoUxgv2bsmURtVyzH2kfhr+ifXPoTlFfVUJrhOxZwRihk4a+hZfB88keLYmNKZMHHgzD4I5Egw3AtJg7A2xNBBye60f+FM6yPWUVGZp5/kIVcllKMjifUpuve9u7tgAOBadg6hEhLq+oARISEgTf0ekpJxgccCDqHev96bmn66OCFEw/BGWmBC4Kkc5JBRlR685lZPmhWa4niO39UoMwkuaAw0AfsO5PCAEenJup7ddcPcM
 ABEOCJfR
 bFivBS9Oaj1tTZH/wJ1MA9UzFLRLsJeqtQHEmbaaawFdAoGNNGjSeXWTbZcRkMOsvmaWfFMmhXaEpoo/BopxDBj5pxvMpUTG49TwiABMXC8+t8jDEacrplbku1IGLHT2pKXI6QlkoebuIGGiGPGb2NGua2kLo69RSUp0yQDIspoo/b5Lcigq1t16A6/L07+RE5DGQLMl4Bf4GrRcA0i4DGSe/eoOK089O0LRVHLfhECqFKVQV9HVAmwh+0iBpTbH26YS/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are some AA deadlock issues in kmemleak, similar to the situation
reported by Breno [1]. The deadlock path is as follows:

mem_pool_alloc()
  -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
      -> pr_warn()
          -> netconsole subsystem
	     -> netpoll
	         -> __alloc_skb
		   -> __create_object
		     -> raw_spin_lock_irqsave(&kmemleak_lock, flags);

To solve this problem, switch to printk_safe mode before printing warning
message, this will redirect all printk()-s to a special per-CPU buffer,
which will be flushed later from a safe context (irq work), and this
deadlock problem can be avoided. The proper API to use should be
printk_deferred_enter()/printk_deferred_exit() [2]. Another way is to
place the warn print after kmemleak is released.

[1]
https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t
[2]
https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/
====================

Signed-off-by: Gu Bowen <gubowen5@huawei.com>
---
 mm/kmemleak.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 84265983f239..1ac56ceb29b6 100644
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
@@ -856,13 +868,8 @@ static void delete_object_part(unsigned long ptr, size_t size,
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
 	object = __find_and_remove_object(ptr, 1, objflags);
-	if (!object) {
-#ifdef DEBUG
-		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
-			      ptr, size);
-#endif
+	if (!object)
 		goto unlock;
-	}
 
 	/*
 	 * Create one or two objects that may result from the memory block
@@ -882,8 +889,14 @@ static void delete_object_part(unsigned long ptr, size_t size,
 
 unlock:
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
-	if (object)
+	if (object) {
 		__delete_object(object);
+	} else {
+#ifdef DEBUG
+		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
+			      ptr, size);
+#endif
+	}
 
 out:
 	if (object_l)
-- 
2.43.0


