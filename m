Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A156160A3808
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506C36B06C4; Wed, 21 Oct 2026 07:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483096B06C7; Wed, 21 Oct 2026 07:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286766B06C5; Wed, 21 Oct 2026 07:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9F676B06C4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:25:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9639E1C3C1B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:25:00 +0000 (UTC)
X-FDA: 85346401560.21.CA6028B
Received: from mail-m607.netease.com (mail-m607.netease.com [210.79.60.7])
	by imf11.hostedemail.com (Postfix) with ESMTP id 24B7140008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:24:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.7 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792581898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EPDlZMTSTVQ5eCE68sbvYSTGTpxshvufAloZkiCKtC0=;
	b=bUU1RkN0uKXb/DN2ANYXoEGlT64SxAyyl5NPlt+BwphBvYVcLbv/la0uvMdQVO5/RnX16M
	f4YRApQEk2oYZlqUsuQP4Ekv8uD5TpQkhgT5p8ceAf3HAC/HEuQRKzjvpQKgLOOFkCMUI4
	jVd50fyzh4rY9OH+gKXIkDjB3RM0Dno=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.7 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792581898;
	b=FdXuAm4qbhTQGXknI19FGfEHQNdHrQkGrSc0s+12QqSTgRJJs51GK1bQHRKyWd6dvbTHPm
	jpPXtR8dGWzePZDSPdCBEvtkTfWoULBhqdWnhr2fG+eEodh3G5wOysjgdUBsO4Yqp9OZun
	5oNqVP1uPuJfEgn4/GV8H2vPFGTqgU4=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 204f151ab;
	Wed, 21 Oct 2026 19:24:53 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	shuah@kernel.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v3 4/7] mm/page_owner: add open-coded page_owner iterator
Date: Wed, 21 Oct 2026 19:24:34 +0800
Message-Id: <20261021112437.1799213-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261021112437.1799213-1-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa15e34fe6f0229kunme08c1fd526ace2
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSkNMVk9KT0JPSk5NGB5CT1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 24B7140008
X-Stat-Signature: mwgou7byrjuuwnfsj8ihq7u1ipimnfop
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792581897-809461
X-HE-Meta: U2FsdGVkX18jt11zdEwVyPd01uabyhwpeDIYKAP7gs5naoxbXX96SzxUbZZOGKMMz6aOAjY1T7jabkd5y+EiexCnOxW9qzZXY6GRjo/JhhMBR6CmMYCl9mryr8aMZOlrzkpAwzmZvK+ewI2yYXjg7O/Qy1CZTHQS5DGYfghSoWyzihv5NLRcmD+E5A4zeo4uIH6fjBhCOL5MHqdkDbj/99enah/JEnFBNxAAc+t5ObmqtgwOi6+lJeBShy3oOAQtkMjRrCA65fnG+z1Ciqd0hqfcFVUu3965KxaeZBexwIU+0uO+PyJCAkpHc304iG9Y/2MW6UqbGnRYzBrcqvhHAMSBLVSeIO+/nsTtE0u0HiDXpZfG1pThzWJRQC73E2SugAF0GV/4oXbpT4aafv8+zcQVkj/JlJgvXU6lu7DMT3Z5NxYqgCCUVl3LwhWu+ZKCB1bxWfjtX9BHFU+jPmgRx7r80zw8Bzq5PgVcYIw/ZTvP3BODg9j/zMiJPCZ5z+3TA0hVGYzqH9CrBWhzpji/ZEPTgKxdK5RQ2gV+UxHa+n93PuXI9Zja0g+TEwsryiZClSsDNfjxO3L8yl3oyhW+xVKhekjm4V/oBprJYfswNG2lznefrIYoWf0xwnLFD8omXVmskEItmn0XuUeaZB0TWDC1Gfwh+99K9PI+zIf2OmGXVBPSiXeCLHVnWY0KJRiWbVpocbjV7SfNU7j23YLSSK/lpQAlF6yO54dXqy/PvsGXfYJa5inLiih+WZb5GwfAfSe2RJofJgDkzgFaUjUq4EFoJ5sBYAgcZIIMVOZd2ZPml6RuctsfjAbqGWoThE/5QWDsSUxphgvJ/sfGkp3BwpUup79uBCiSs/2Nmc0MI1GUsUqPceyKSUgbwWEDxPED7fuZSfBMwYIiYxV9PGE2KTVaksW5Q0TBW2XWP1esBTGnAUYgryAiKUFgst1QwGDhSMQxZgbTmjjWbJp3ryQ
 mfXtl4uz
 ik3l7wutXodhpuUyi5AHZVx3bAdK08atcvNZVMjYkPoDq0rayj02z1E6lH0rfzc8pMk2AmPviWrMQNRhUruHO8f0d+/Um26hgJQuc5r+Cqq2vnind9rXvhLaXN4+sH/S1VVPDmaoiKrs9upnesXbseFMBhr/agNg3DNyVqfXvp2f97XXjW9QkfS/q9+0uIqOl8eiLrmzNeryNy3E3PLyawRpNL0+TJfMc4STjmFTFYSBaqjPPQbYrXkxhlU4nCzHO8owxisBQS53H4x90xTnSOy/tWSq5Kbq4O4v0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add an open-coded bpf_iter over the pages eligible for page_owner
output, reusing page_owner_next_eligible().

A sleepable BPF program drives it with
bpf_iter_page_owner_new()/next()/destroy(); each next() returns the
page_owner_scan. po_snap is copied inside the page_ext RCU window, so
the program needs no RCU section when it reads it.

Also add bpf_page_owner_stack_snprint(), which renders the stack trace
of the current page into a caller-provided buffer.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v3:
- Gate the kfuncs with KF_PERFMON.
- Check the page_owner_inited static key in the iterator.
- Without scan->page, start at min_low_pfn - 1 and let next() pre-increment.
- bpf_page_owner_stack_snprint() rejects a NULL or zero-size buffer.

Changes in v2:
- bpf_page_owner_stack_snprint() now takes the scan cursor.
- Buffer args renamed to buf__uninit/buf__sz.

v2: https://lore.kernel.org/linux-mm/20261013122125.843451-4-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20261009112308.240769-4-zhen.ni@easystack.cn/
---
 kernel/bpf/helpers.c |  9 +++++++
 mm/page_owner.h      |  3 +++
 mm/page_owner_iter.c | 64 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 712dca5a2c5b..0ba836f77957 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -4946,6 +4946,15 @@ BTF_ID_FLAGS(func, bpf_iter_dmabuf_new, KF_ITER_NEW | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_iter_dmabuf_next, KF_ITER_NEXT | KF_RET_NULL | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_iter_dmabuf_destroy, KF_ITER_DESTROY | KF_SLEEPABLE)
 #endif
+#ifdef CONFIG_PAGE_OWNER
+BTF_ID_FLAGS(func, bpf_iter_page_owner_new,
+	     KF_ITER_NEW | KF_SLEEPABLE | KF_PERFMON)
+BTF_ID_FLAGS(func, bpf_iter_page_owner_next,
+	     KF_ITER_NEXT | KF_RET_NULL | KF_SLEEPABLE | KF_PERFMON)
+BTF_ID_FLAGS(func, bpf_iter_page_owner_destroy,
+	     KF_ITER_DESTROY | KF_SLEEPABLE | KF_PERFMON)
+BTF_ID_FLAGS(func, bpf_page_owner_stack_snprint, KF_SLEEPABLE | KF_PERFMON)
+#endif
 BTF_ID_FLAGS(func, __bpf_trap)
 BTF_ID_FLAGS(func, bpf_strcmp, KF_PERFMON);
 BTF_ID_FLAGS(func, bpf_strcasecmp, KF_PERFMON);
diff --git a/mm/page_owner.h b/mm/page_owner.h
index 0aa7695bec82..4ab513f17fc9 100644
--- a/mm/page_owner.h
+++ b/mm/page_owner.h
@@ -6,6 +6,7 @@
 #ifndef __MM_PAGE_OWNER_H
 #define __MM_PAGE_OWNER_H
 
+#include <linux/jump_label.h>
 #include <linux/page_ext.h>
 #include <linux/sched.h>
 #include <linux/stackdepot.h>
@@ -13,6 +14,8 @@
 /*
  * mm/page_owner.c
  */
+DECLARE_STATIC_KEY_FALSE(page_owner_inited);
+
 struct page_owner {
 	unsigned short order;
 	short last_migrate_reason;
diff --git a/mm/page_owner_iter.c b/mm/page_owner_iter.c
index 529b2c4a589a..4b9741a2de53 100644
--- a/mm/page_owner_iter.c
+++ b/mm/page_owner_iter.c
@@ -4,6 +4,7 @@
 #include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/seq_file.h>
+#include <linux/stackdepot.h>
 
 #include "page_owner.h"
 
@@ -116,3 +117,66 @@ int page_owner_iter_register(void)
 
 	return bpf_iter_reg_target(&page_owner_iter_reg_info);
 }
+
+/* opaque to BPF programs */
+struct bpf_iter_page_owner {
+	__u64 __opaque[16];
+} __attribute__((aligned(8)));
+
+struct bpf_iter_page_owner_kern {
+	struct page_owner_scan scan;
+} __attribute__((aligned(8)));
+
+__bpf_kfunc_start_defs();
+
+__bpf_kfunc int bpf_iter_page_owner_new(struct bpf_iter_page_owner *it)
+{
+	struct bpf_iter_page_owner_kern *kit = (void *)it;
+
+	BUILD_BUG_ON(sizeof(*kit) > sizeof(*it));
+	BUILD_BUG_ON(__alignof__(*kit) != __alignof__(*it));
+
+	kit->scan.pfn = min_low_pfn - 1;
+	return 0;
+}
+
+__bpf_kfunc struct page_owner_scan *
+bpf_iter_page_owner_next(struct bpf_iter_page_owner *it)
+{
+	struct bpf_iter_page_owner_kern *kit = (void *)it;
+
+	if (!static_branch_unlikely(&page_owner_inited))
+		return NULL;
+
+	cond_resched();
+
+	kit->scan.pfn++;
+	if (!page_owner_next_eligible(&kit->scan))
+		return NULL;
+
+	return &kit->scan;
+}
+
+__bpf_kfunc void bpf_iter_page_owner_destroy(struct bpf_iter_page_owner *it)
+{
+}
+
+__bpf_kfunc int bpf_page_owner_stack_snprint(struct page_owner_scan *scan,
+					     char *buf__uninit, u32 buf__sz)
+{
+	int len = 0;
+
+	if (!buf__uninit || !buf__sz)
+		return 0;
+
+	if (static_branch_unlikely(&page_owner_inited))
+		len = stack_depot_snprint(scan->po_snap.handle, buf__uninit,
+					  buf__sz, 0);
+
+	if (!len)
+		buf__uninit[0] = '\0';
+
+	return len;
+}
+
+__bpf_kfunc_end_defs();
-- 
2.20.1


