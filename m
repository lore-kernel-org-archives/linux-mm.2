Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A15F9CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F29F90004C; Wed, 13 Aug 2025 04:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A293900044; Wed, 13 Aug 2025 04:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B88B90004C; Wed, 13 Aug 2025 04:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02CC4900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:41:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9A871A023D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:41:07 +0000 (UTC)
X-FDA: 83771089374.04.0531183
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf30.hostedemail.com (Postfix) with ESMTP id EE37580009
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:41:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=gubowen5@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755074466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=6ocy/RLBGZEzcx5S0CvmO23ykbLj2YT5mpiXPg9Bya0=;
	b=eBZiL1Xth/T3NC0W+ReNm0F/Y90+KE+Vj2UhgyQeBaTeCBFOJrKZXYMkP7lkiL+p5IcH0w
	WpjZ4aZ7k0BHx6AGCQm1CF8zb88VEu4B7E4yHCrFzPNjJryiyXa7GWeSCVUQbLfXSgly5J
	HMYuBbPNq2mJOBrY3glZQXn+lnH5ZmA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755074466; a=rsa-sha256;
	cv=none;
	b=2ACt/fRIcoZxVluojaxgwH/3pep85fr1bdOZ3DDpKLzM8Mxun+4raUbAqCRY4EZ4qOeuef
	BIdcqXiS+tBPRZhrTM71pd2zJQjebg4xfCifpb7GQpUtS/LFD2ED/r4xpUHWHWlrAKUakg
	SB+uiA8Z50k6JPCLsowSsberoYpLSYA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=gubowen5@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c21w00zyfz13N4r;
	Wed, 13 Aug 2025 16:37:36 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id 468B9180B51;
	Wed, 13 Aug 2025 16:41:00 +0800 (CST)
Received: from huawei.com (10.67.174.33) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 16:40:59 +0800
From: Gu Bowen <gubowen5@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <stable@vger.kernel.org>, <linux-mm@kvack.org>, Waiman Long
	<llong@redhat.com>, Breno Leitao <leitao@debian.org>, John Ogness
	<john.ogness@linutronix.de>, Lu Jialin <lujialin4@huawei.com>, Gu Bowen
	<gubowen5@huawei.com>
Subject: [PATCH v3] mm: Fix possible deadlock in console_trylock_spinning
Date: Wed, 13 Aug 2025 16:53:10 +0800
Message-ID: <20250813085310.2260586-1-gubowen5@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.174.33]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemh100007.china.huawei.com (7.202.181.92)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE37580009
X-Stat-Signature: qphro8f7gthab81jecrfxu5cqmtngdh5
X-HE-Tag: 1755074464-559092
X-HE-Meta: U2FsdGVkX18Su1lL/vDg/1NmvqACMdLMBS/eMdiEsDcKUNuroPPiEU5oTFWYsWa12d9hieA2t1PXE7TlmJ75GVb5u+jDbAIbj7NeTxyYxJuiDWQ+pvA0hqDQncDemWEKckLOHBpgKZ4OcvTpgBfdlqjhkZRolWCHpHhQqjR49mZSwIMe/VPfDYgv1UGBQKuVk1oRMsLCyAanPBqKIQJrr/syodkR5hVaLBH60ErQ7V1Xq3o/C1qCpIFeuNyRaTzBqShHkai1Ta8h2Q3Q6wjlkmPezuyNZ/EHG/yY1Kjxc513LS25vhGr31K+A7gk3jjeXliue6OxzT1A93RuYuYAZevafEYVpFlndP18xXZv8Pyj4Z39X374muWbLp9jgG+r1CD1Wl1dSLuQivQfzGbYTFhGVRYGsh/Ow1iZ+K9RKy7K22oq+s7hHBM6AgFfSFHPyKVEfJvKEHpWFEJDFgvZPQB8PhaHMdiY/sR7FhULv17QAO3zf/mmqT7BOmMYabwaY9J81G5vyUWxXregCxuns9bUUwkuRQvkrMwtvdhlI7mX0VEDPTeJ3b9B2QIVsG2ALQnCN1aaT/vZj9DyNjqB0m5IW7PpHnaTdEHfsg24IReBrMpLCBNdreQ9/01KWKp6niQGN7iLiE+vaJNlYBMfo+DzwuWHCp0ytpsEY9hSdZcDgBHvAxSTLH4MPi0KRHspqk/IGDZ23FUfF0R5fH3SzXdBzq5q+e+gdyqB0H+H7NM3RPG3/I+Izs+3GQcSQCNiB+TzzVZ0WFKbE+iRTF/I54MnY5rk5dYmSRvTWqVkg2uzVSuQPfLHyAEx+dnTv4w9SN+UTtcWe79/wofzTw495QFYz6nmzqoCYlYS9JV1XzhfWlEGCbcoKmb6tT6CAXsPH6gkDLzmSmJ9DbRSsSaOPBMeibGgKwuBCvD2Z2IVOKKBaeq8rgQcQiPGBMn453Z2cYf4ukfcOa3BjAPCkr2
 QdEEKK1f
 P1BQpmRFa0Zo9BhWGb6wbUfwfkZJlUJ+XQTI6dua8ffMRda9Eqq0IhBWjf/tjIoV3jt/k2uHazj+mGYx/wruF/8IO5kKJlRACXEs7siVbXOA7aCckrhsHzrK1e0ur0UnRCo1t9b2QAtDpb1Y3Lqs3RBs5eMGSSQgUo0/M93426AR/n/T6kro+GDvNomAzhyFWTkkAUO0VuWQM2QZl6dyLv+DW4CkeRnipxkeucO66HIvF2X/UywEdiOO2uHtb8XRRrrIJFB33lP/6Z2Rtkfa4HqcpAWbCXATNmP+wctTbQEKzcctXM1pMNyi//ZHL5GBDSc6zA8rnDOd1qhxcY7umnP8SkQ==
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

This patch also fixes other similar case that need to use the printk
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
 mm/kmemleak.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 4801751cb6b6..b9cb321c1cf3 100644
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
@@ -632,6 +638,11 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
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
@@ -639,6 +650,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 			 * be freed while the kmemleak_lock is held.
 			 */
 			dump_object_info(parent);
+			printk_deferred_exit();
 			kmem_cache_free(object_cache, object);
 			object = NULL;
 			goto out;
-- 
2.25.1


