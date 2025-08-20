Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B648CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 20:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78596B00E4; Wed, 20 Aug 2025 16:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29926B00E5; Wed, 20 Aug 2025 16:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3FE96B00E6; Wed, 20 Aug 2025 16:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 93C6F6B00E4
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:21:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 955848152A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:21:47 +0000 (UTC)
X-FDA: 83798256654.14.063BB63
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id D430B40008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:21:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a+uJmoT9;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755721305; a=rsa-sha256;
	cv=none;
	b=W1HKZ1g8IUkNobirm0L2o3ml5wMJNPKDeyzWTjxQ/DhJ5JWHoSbnWOnEg/HFbXotqjwbRm
	WR5SjIZpQ1R/FLb3HdhBzXps/fJ/jS+jWrNPJYap4M5avmnxwQqu+F+QiPoB6CyKctF1n9
	clRMGSZgcSe3p4aRrufZ8FoqBVesLK8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a+uJmoT9;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755721305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZfVBeq8pl0QP8g5U6AiE3ib+c8wqo++gGMPp1Ed/A9A=;
	b=slyOjE7G8hVGuyeaZWSVpMSt5hI3kxHX5ZDQgSvqwKj1CiAbI8QnoZyuMSJ27fI2Z/oyGv
	lAWCmvagRa/7NU8ohdDG7tPw8bdy+xvxA3/nVWpGD8z2xHv+VyVNbPk2OmP1nreBKcy8L4
	j4WwG9uYaEpXlTHewaOUXTgGgQw4Wmc=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76e2e89e89fso433188b3a.1
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755721304; x=1756326104; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfVBeq8pl0QP8g5U6AiE3ib+c8wqo++gGMPp1Ed/A9A=;
        b=a+uJmoT9afNiJ08YY5tMxSkZcX6Zg13iO4SrM99MeavTr9Yf3aYvrCdTDzclFwmgtW
         1T73FVFr21Q6/eX163pzQWZspMX+aNrkw/pNvqLjHvRlAqZmCq9/rVajeL9o15P7MCKk
         81r64puymZ3Si19raXSuzBoYXfHIbHp/G4yLOQRcHb/B8gq9q0y9tMo0Vy8Vq/JllxT8
         VPvyaLP3ZuuMlO4X2cU8YzW3Z0WIMJ5FaAIPmrX2ot5qhJKaEiEfOiT2osE3nUW2lDAp
         dPOs1aP0mjkIvTc9dOCIW5P2GtGN++ItJVcZ4/KDBZReux4SH6wJSqV+LjcZp7SZlYFT
         zyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755721304; x=1756326104;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZfVBeq8pl0QP8g5U6AiE3ib+c8wqo++gGMPp1Ed/A9A=;
        b=pY+Ou3+F+PIM5EWePVOuH/iJ9SBXBq+0AbASqVWCRWvWZlJfXQEdfDMAbn4g6sWNxa
         GZgKTbgp8cYT9WOSI2J3vzlYCedHQWan9Wa58LuGc+dKLrgeHtfkQdn4h1qqkuP5QxDJ
         4IYuZwTIiTKkmWtRF2hgcnx4yMw63J8Z7UYe+gqtxI3HWgTuAHYvIyYpzaTylrZQzTTf
         A5u5WaO2psKSb/1xrzXOUB3XbN3JRTe0p1/qOgP9miM/WZUM7e2G3zX5lq21cLu+kjRM
         jmYSVdHObQ0T5iULJFLHdWIZUdWKkEtLQ6cL5BAKcrer87991BfIRprM/FaRZyy31APe
         DDIQ==
X-Gm-Message-State: AOJu0YyL51QkCRuch4UoKeWgNlnTMSHs7Lt7zraRJUr8MqbbHt0BpPAK
	iTIKbs+IiihzwG2MtQmSPIPRtqaFmzoBWiaXE5+q3NHbmnJ2YUJYWuHCwqSZgw==
X-Gm-Gg: ASbGncu1Ve2fdM1aThnDZunmvJ9ovqcQYVAuyY/E1QKS2YU8OVbsOJH0jLLM3cVo/jI
	P3j0rF5bEnl0Ulgz1RjNWZVEhIsX8Hfl1iLSryrUCQyQtKLg2/+Ga1JuuUbvwxba7N7nLge3klf
	57qqNAaiuMtmCY9pD6nHnc+6oMcQvrWosEkzDmBUOG2LvfeaYy7Fi4iZe3scQubGkqqJXjAVx8s
	DHB4apin/oAuVHztSGiT4mWnRtrX/yiNppbyiuJVaZakTPux7g9ZhB8q0ODuMqX49cs33CBMHsM
	6UPTUHn/5J9kiiBlbixG2GLb5IaZwZu8w0JBG7bujs+v3eeu7P/J84wfcYjTLYiuUIHrN9MFoaF
	so+9qyDhFKIpQl1phicT9+8OM74PKyKFV6rcYsJqyQh0t/FfkVIkA5cc1PteqDd9v
X-Google-Smtp-Source: AGHT+IE7ppi3rTM6S8pDhkBCrus98JT267r9X2CkaixyAbQTz839FrOVIIRUDZc1sYahqTZpBZxHTw==
X-Received: by 2002:a05:6a00:a93:b0:76b:d8c8:2533 with SMTP id d2e1a72fcca58-76e8dd5fad9mr6590344b3a.24.1755721304107;
        Wed, 20 Aug 2025 13:21:44 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-76e7d0d0ef9sm6222261b3a.12.2025.08.20.13.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 13:21:43 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH] mm: tag kernel stack pages
Date: Wed, 20 Aug 2025 13:20:29 -0700
Message-ID: <20250820202029.1909925-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D430B40008
X-Stat-Signature: 18y97n4osogty5shnhuffbieh85gp3xc
X-Rspam-User: 
X-HE-Tag: 1755721305-222181
X-HE-Meta: U2FsdGVkX1/tpmzpN3rbHziy/BvcDdUa8iUSlsYVrfEu2uYzGNFTMkmCk7EpEo6FwPrpqMBDh0BGWGd0OR/QYcJBRkhMh+UJNbAbT2Hb4UmxdyuZnbPdztTkkK6YZsSlxzpAo1BR6Cut9QbN0ihi0yHYAJVZGAikjCm4iZbtdlos37OGg+hNJenPM0WJ5CAPk9UcIEb5OH0buXowf37RW7USzKW7I6wdTwlwIlO7HyKezdgoGH/MO6gGxU2sgjfHwnrulm9HJcfL9Vv4J+aVvzhjnhaDZpd+8rUh5IEk9yJ7v+RYBjEFuTqlDfczCJN3+Kgsi9o7duH7plnqY7nZsMxpq83bPUYO9azt957XOF4J3CpIRG/xrjpdicfD/eknUhdfxbRD6msHVhDsUNhItiC+tiPVlfi+ozg0DRwqJpT52Ky91p9IfveApsxzdyDWJjHEVZWJfKMWwu6WgaLRaSwIg6uDj07MnpaC6dgRDJqf1ieo6xV/4yfX0kmzATzvY0dZgASfbixe1izgnIm6HVA/BdSmJDEBHaAwuyBiazBETrbsuPEmWItSBTjrWyg+GZWEVYCJ7IerIyDTraJoX7s6Xwfm0XNWgQSegZ7JG1CEyeb7Rs6QI0xujJBB0k/1sM2dd3SoCKGhJ+E421wSZ1cZk/+eZaXuCIlEwVZpnUcIGny+ZbI4H2102dM66o0jE73+iF/4PZ/w4UwrWZj2BQnhf0iyNBnQrRPmzpjehgk/svX8/RAnmCQ7O8LINNaD0ZNho/H9avr3MNulBHKnGV404SD0gCxr+F1DnAxNTPAg4PM0Vtie7AQI7xm/5h9gsB/SvmKSvVbY05Wxmq4RGrT2JYWPQywyP2sq0DwKasty9u8nI+q2+YgZESB6/XztaRk0hCJB0k91UXKUocqNJ+3T2COOu+5o0CFUMVp0VtUQBUitF+31SE0brFW1bklRyylvzczupxM2Url9rMy
 sn6FPz5V
 Z+jDdzCMTyqC5G6X6JU2ML8yCzWMOF40BZOT3xTqJ7kDLSUC5vWaxbIdTBSPAdQd51iGc4zpBKscYJyUjw07O7RQR+JL9eardeQRe3y7EwFz8d6TDf730V1o83AzZyrCND0XuYFviAqubsejlrnaY+N45Hj4uLhVCdrpTZPx5gPtBSeksdZK1gDo3oOgO79Bc/RLt4EbDIwh8RM001s7LDHquhzq5zEhVdtwmGTBBXbI2Fkw1MwSkk+FNRsATjStRcEM38tqgt2byt9WQmBbz7soR0J6vLD3DYw6j0i7vcAl2zZb2HU4xO5YYagnDRWDf7qIYWEerrU9ayfUENNvCxxkxSYKgJze2OqMeLZAFpvb0hz1TESEPk4S8e3yA+DsY2CISjmNTxLXvUH0zllYCLz5Og6eW4u4EJorb8rcMLmuPQtMQp3MyWosuVG2YK9HrVRWJt0ubmoXtJC+w1EH9ZfQR/yEyRS1bVxYpsRWdjROBW7E/LVC/SnvgIcASEOvvNcj3dA9T2cRJLmI/6RTeixZSLgjrJqONaRjR+cykc8Rnyno=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, we have no way to distinguish a kernel stack page from an
unidentified page. Being able to track this information can be
beneficial for optimizing kernel memory usage (i.e. analyzing
fragmentation, location etc.). Knowing a page is being used for a kernel
stack gives us more insight about pages that are certainly immovable and
important to kernel functionality.

Add a new pagetype, and tag pages alongside the kernel stack accounting.
Also, ensure the type is dumped to /proc/kpageflags and the page-types
tool can find it.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 fs/proc/page.c                         |  3 ++-
 include/linux/page-flags.h             |  5 +++++
 include/uapi/linux/kernel-page-flags.h |  1 +
 kernel/fork.c                          | 19 +++++++++++++++++--
 tools/mm/page-types.c                  |  1 +
 5 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 771e0b6bc630..46be207c5a02 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -201,7 +201,8 @@ u64 stable_page_flags(const struct page *page)
 
 	if (ps.flags & PAGE_SNAPSHOT_PG_BUDDY)
 		u |= 1 << KPF_BUDDY;
-
+	if (folio_test_stack(folio))
+		u |= 1 << KPF_KSTACK;
 	if (folio_test_offline(folio))
 		u |= 1 << KPF_OFFLINE;
 	if (folio_test_pgtable(folio))
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index d53a86e68c89..5ee6ffbdbf83 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -933,6 +933,7 @@ enum pagetype {
 	PGTY_zsmalloc		= 0xf6,
 	PGTY_unaccepted		= 0xf7,
 	PGTY_large_kmalloc	= 0xf8,
+	PGTY_kstack		= 0xf9,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -995,6 +996,10 @@ static __always_inline void __ClearPage##uname(struct page *page)	\
 	page->page_type = UINT_MAX;					\
 }
 
+/* PageStack() indicates that a page is used by kernel stacks.
+ */
+PAGE_TYPE_OPS(Stack, kstack, stack)
+
 /*
  * PageBuddy() indicates that the page is free and in the buddy system
  * (see mm/page_alloc.c).
diff --git a/include/uapi/linux/kernel-page-flags.h b/include/uapi/linux/kernel-page-flags.h
index ff8032227876..56175b497ace 100644
--- a/include/uapi/linux/kernel-page-flags.h
+++ b/include/uapi/linux/kernel-page-flags.h
@@ -36,5 +36,6 @@
 #define KPF_ZERO_PAGE		24
 #define KPF_IDLE		25
 #define KPF_PGTABLE		26
+#define KPF_KSTACK		27
 
 #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 5115be549234..c8a6e1495acf 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -440,15 +440,22 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
 		struct vm_struct *vm_area = task_stack_vm_area(tsk);
 		int i;
 
-		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
 			mod_lruvec_page_state(vm_area->pages[i], NR_KERNEL_STACK_KB,
 					      account * (PAGE_SIZE / 1024));
+			__SetPageStack(vm_area->pages[i]);
+		}
 	} else {
 		void *stack = task_stack_page(tsk);
+		struct page *page = virt_to_head_page(stack);
+		int i;
 
 		/* All stack pages are in the same node. */
 		mod_lruvec_kmem_state(stack, NR_KERNEL_STACK_KB,
 				      account * (THREAD_SIZE / 1024));
+
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++, page++)
+			__SetPageStack(page);
 	}
 }
 
@@ -461,8 +468,16 @@ void exit_task_stack_account(struct task_struct *tsk)
 		int i;
 
 		vm_area = task_stack_vm_area(tsk);
-		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
 			memcg_kmem_uncharge_page(vm_area->pages[i], 0);
+			__ClearPageStack(vm_area->pages[i]);
+		}
+	} else {
+		struct page *page = virt_to_head_page(task_stack_page(tsk));
+		int i;
+
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++, page++)
+			__ClearPageStack(page);
 	}
 }
 
diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index d7e5e8902af8..4031fdbad3e7 100644
--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -127,6 +127,7 @@ static const char * const page_flag_names[] = {
 	[KPF_PGTABLE]		= "g:pgtable",
 	[KPF_ZERO_PAGE]		= "z:zero_page",
 	[KPF_IDLE]              = "i:idle_page",
+	[KPF_KSTACK]		= "k:kernel_stack",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
-- 
2.50.1


