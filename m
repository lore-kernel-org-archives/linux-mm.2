Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB541CA6018
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C206B0092; Fri,  9 Oct 2026 07:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11AF66B0093; Fri,  9 Oct 2026 07:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23FB6B0095; Fri,  9 Oct 2026 07:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C33B26B0093
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:23:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5384E160348
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:23:36 +0000 (UTC)
X-FDA: 85302852432.08.ED54D47
Received: from mail-m1602365228.xmail.ntesmail.com (mail-m1602365228.xmail.ntesmail.com [160.236.52.28])
	by imf04.hostedemail.com (Postfix) with ESMTP id 30B3640007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:23:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.28 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791545014;
	b=4bPWDpenrKHL1PMfp0z2q84g8xhyg/cfn7rTcp0QJoCZaa8aKEdAFyTC+OnbrArD9UagUQ
	R59g/v3GEj3a7+fVGr4MVmYEaaGibKI468u57hdyS8dUfejHTR4es2QHLiekAgGJzPAB7L
	d7E/b/r9TWsSmuC5la7Albdb2bEgXRE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.28 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791545014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FUL5e6XiDo/8g1xJlmWxbsgduTWJpPh850hBY8iI+Gg=;
	b=5W3vpGv7nU97eYlHnN5et+JRja6I0+u/hIgO1lzrPfGJPqQcNnNUh5VOMeOLg3SMPaQHJV
	uQK9Hbfw4h5WV+2u43qBJ6VotYjbMB0QHxSVneelv3FMub66rKZHKBNB6GaENVb/wfS3iA
	u3bMY1edHAlUdAEvVmfWvORw2TyLiVU=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1fe2901a1;
	Fri, 9 Oct 2026 19:23:28 +0800 (GMT+08:00)
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
Subject: [PATCH 3/6] mm/page_owner: add open-coded page_owner iterator
Date: Fri,  9 Oct 2026 19:23:05 +0800
Message-Id: <20261009112308.240769-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261009112308.240769-1-zhen.ni@easystack.cn>
References: <20261009112308.240769-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa12067610e0229kunmd33b3e054cb283
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSBhNVh4aSEtKHUIZTUtLHVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 30B3640007
X-Rspam-User: 
X-Stat-Signature: qag7kskbyan7npxxkaaf8jkuek79bsag
X-HE-Tag: 1791545012-481625
X-HE-Meta: U2FsdGVkX18ID3nomavYNCob0+diW6u4vYL0r1o9c0olSYfaiYNfHReeDsd9VVMz67bSNPVAGY6tF2tVWIiwGV5zltp1kni2EQJnt4DEiNtwGuoJ6z3eOiCI106fxvkA54Ke0bhyQwNfzYEeZDwGEWrRzF6HVBpwJaQwHG1mMBYRlIHm3Ln/z6EJyMNDix/mP8kzb7afMHe+GQhXmdiQD3y7ERndViApSaBFntUZVFFRxEsZKffxY0LctDL5x6xls+ASvOYAiEbrvxrELDEI6pjCV/D37O8szm/slkSVOD5V5y4Ir86hZwFtCL4XdYnTSZu6F3KxwbKwbNME1sJK+e7iO8wYedn7nSt2VBwdbTg76hkY5sWAm/Ddiu1hy7RP+kc2/Hh2bqQ3JeGS9PwXKgfm03Afk+cS4boMh+ZhgBF+EhALPUotMGX9e0U7Fxl97tf3O+9m0yoB3kvoFabrWcb5PSuqKIvbID5NYfblQ6aKZ3OsWYFbUTCH03QUhwOIMze0ZnISxNfb6G4RO0AeXCTJDtC7HEX6KVX3z/hIc2x2kqmLi4t7xogWx40puY0wBtyJPBj9Dz+sNFGOX3g9iGUCWDrjNZ8ddNZu0V/O/+mZpyMdLXr1z5J4ts5OI+NeiKG4EIjjgN66ItPeKZ2fmbX9LCtB8wqmvAyyajwdSMxr4C+40vJGwn7VzuByZGgArqd2lQNnevikOVrTQ9ieEZGu3po/N5q2qv2HnVdEUmTWCsP94/N6YcPQgsJasXtumN8vHQiO5hLAfGgUzN+An4Aa7tpHiv+MghkidWHVlz/IWsaLP+Ju97T3TQFnw/LiMrzwSvQJaa9UKnN7aLe75nk1Nzyd1pfpmOVREZe0xrKyvrHUy+MxPTFbTEPqBa+1EKIobb1H6/TBgqgahluEzIksdazjejdaFVNPuXXkAVs4Okv2RRJWmtCtETLuxqkxqpm03A3kd3r+x3kxS2F
 v5wTizC+
 dmUxGzhMgPStN9rjD61bMUH5c3AQSBwBiLoaimvzMsij4m2UnJveuXOW/Xdm35T7wRcqAN/98iCf9Da/0uQUH/leq8LfGkI+Xa2H3pyjiiYDUq4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an open-coded bpf_iter over the pages eligible for page_owner
output, reusing page_owner_next_eligible().

A sleepable BPF program drives it with
bpf_iter_page_owner_new()/next()/destroy(); each next() returns the
page_owner_scan. po_snap is copied inside the page_ext RCU window, so
the program needs no RCU section when it reads it.

Also add bpf_page_owner_stack_snprint(), which renders the stack trace
for a stack_depot handle into a caller-provided buffer.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 kernel/bpf/helpers.c |  6 +++++
 mm/page_owner_iter.c | 52 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 712dca5a2c5b..23a2d2d71f4d 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -4946,6 +4946,12 @@ BTF_ID_FLAGS(func, bpf_iter_dmabuf_new, KF_ITER_NEW | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_iter_dmabuf_next, KF_ITER_NEXT | KF_RET_NULL | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_iter_dmabuf_destroy, KF_ITER_DESTROY | KF_SLEEPABLE)
 #endif
+#ifdef CONFIG_PAGE_OWNER
+BTF_ID_FLAGS(func, bpf_iter_page_owner_new, KF_ITER_NEW | KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_iter_page_owner_next, KF_ITER_NEXT | KF_RET_NULL | KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_iter_page_owner_destroy, KF_ITER_DESTROY | KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_page_owner_stack_snprint, KF_SLEEPABLE)
+#endif
 BTF_ID_FLAGS(func, __bpf_trap)
 BTF_ID_FLAGS(func, bpf_strcmp, KF_PERFMON);
 BTF_ID_FLAGS(func, bpf_strcasecmp, KF_PERFMON);
diff --git a/mm/page_owner_iter.c b/mm/page_owner_iter.c
index 33dc9dcd59de..80693d417407 100644
--- a/mm/page_owner_iter.c
+++ b/mm/page_owner_iter.c
@@ -4,6 +4,7 @@
 #include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/seq_file.h>
+#include <linux/stackdepot.h>
 
 #include "page_owner.h"
 
@@ -114,3 +115,54 @@ int page_owner_iter_register(void)
 
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
+	kit->scan.pfn = min_low_pfn;
+	kit->scan.page = NULL;
+	return 0;
+}
+
+__bpf_kfunc struct page_owner_scan *
+bpf_iter_page_owner_next(struct bpf_iter_page_owner *it)
+{
+	struct bpf_iter_page_owner_kern *kit = (void *)it;
+
+	cond_resched();
+
+	if (kit->scan.page)
+		kit->scan.pfn++;
+
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
+__bpf_kfunc int bpf_page_owner_stack_snprint(depot_stack_handle_t handle,
+					     char *buf, u32 buf_size)
+{
+	return stack_depot_snprint(handle, buf, buf_size, 0);
+}
+
+__bpf_kfunc_end_defs();
-- 
2.20.1


