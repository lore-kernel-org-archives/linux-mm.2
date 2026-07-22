Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28292C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872336B00B1; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78BE16B00B5; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F126B00B1; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDE266B00B0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F49DA0B5F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:27 +0000 (UTC)
X-FDA: 85018036614.15.03A316B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 62015180008
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PnwuS69l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763685;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42YT1zY1UpBZWtGhMcHBs6GuuyU+4ivCknTzIu2894o=;
	b=K9mMSfe2SDnHKmWm7eiMY45wI9FYM1R4tPKmXiAsF9menfcMnPJKwgmWbro+CnOI5DE+fv
	2LDp6EIqF7iQu5qgrQDBcRYmZM1GgXH4GsU4CScZBxamw9T828L2dRxFq7F1Mt+MZv5lUR
	10uhJS+sZR3wsT37HwtpL7X/HAsbMt4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PnwuS69l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763685;
	b=go6JLih4SH+nRIsphdoy6Z+eks9XAaaKxMQbOSARdxqY3IbidoSCGpSk6rtXtdSoJVGBIm
	bRii+lfGlh1bQdg3v0ajVTz4tsRY1er2SZ67jNEA0+Nnhy0JSE8dithnzjeloreIQ+gO/6
	WoiDpD46Uujj50SUz6+2Gz5SCMOKnBY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B86C545153;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 999D1C2BCFC;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=Va4m5Sx9fYuEtvTR2h5n8C+dF3X7m38XYQ8knPwStVc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PnwuS69lJKLV13AjZe1OBVkwxTjEICmt5ZlCaILdYj3It+aN2xHPMMQh5kVcfczg4
	 J2+PgB0oP+qt+0wpTmFUkgpWuV0XqjbDSBwgmlhReo2ISu8QdmjIn0QIaG6hOmQxEk
	 cu26STNOlSqVkhPth4WSd0QZd5PJy9wFrRpHxvj37hOO8d+/rZQBFEsb8wKL7zFkVW
	 lEgMWXl0AXZe+Mbx8bRCIdvt/P0SDZIuzZTv23reBu+/0X+BjTiraviDgde3OPE2oj
	 igffL2TOrayeoB0WWk9NXi5LM85Ps4LYHfQwyQb2O652QpR1X+Pv10vKEtPDL6Stya
	 +dtfkJyTYwaiA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866BCC44532;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:20 -0700
Subject: [PATCH v4 12/16] WIP: tools: testing: Add unit tests for HugeTLB
 subpool functions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-12-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=14658;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=mkZsBkGR1i2iMA6usas88vw7grWu7JqdfT5S4nhfgh0=;
 b=ktCZhZBR1fq1rX8XzhqdfUzrgnujNlZmpVtJioipANfWI+nvudolTpM42bFhOmozkCbgwr4SA
 q5+14r4sr5lBkqUY9t/n+Wemw/6PlDBMIAL97tN3cJN7zFLgjjZWrqG
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 62015180008
X-Rspam-User: 
X-Stat-Signature: b15myskj66ntneuuu7ohbq4ap4jpr9iq
X-HE-Tag: 1784763685-105962
X-HE-Meta: U2FsdGVkX1/57OSKzLNLPVcCldjx2HryrJmRzHQdWXTKgT6ckrbgW51Ab9Gdj/2xyt1qc9V9NkSna08wDDcCz6Vaaga6hBnCEpllKYE+rfScc9JdUTj8eIiA+ElczqztuHOouvEJSJ/0aO1mjAhqQIxZnlNzBpSk/Bj1Nb33oZ6GXZgkGjdxYPfkBjOhE1lpOQ1kRf19hu4alreFcxkjx4F+BiP6cS45OFKC/gq7rNSb2cUqdU37eAtlvOy2ov43xXd3lN7yqxjYFEDRLKhN+OuP4uKTURWobpU+yn43r4fuiGy88c7cIqdD8ruv7noaUrmsVfNFevuLC5AOTmxQFtt4n+potUx1n9h0hdMcCzM3KfL7ueiZFNeVPNS8NXoQvTHlcXizj5nLcoixL5kx1f2vLw+xgykxg/aUscXGPoOpGmcbE02+HOpH7IamndTbDOucLjXLVQd/LewImj4QxfFJ39vkeNA670PvNLp06KmRLxiMJFQI6LpUGN10Ge0g0Tm2+j+uiictm06MPmqr2QJia7PDpkdybvhfhwtq80ZFiGpReG9fLmd02O6iHE06Q6j3vAsZwLLI/eBhQ7sAXw1hRIpzoFsFUc/oQBr+K8u4yM58vnYEiHNwQdVLG5lEEyJPPeIfraIXwqRX7AyCmVMY5gSWZFZUVJWfj5OasGGR+5CyyGFC03q5W4g6SHYMJbDh/dwTXLaSTkoE3oYPhH9SA8sCseF3W0uhfN4rofvemjEDMyo2x4JUugMkg7YHQ/20sf1EPyjgVnsxyiW4gDU4FqMO0IVu2W8/jP6vvq8aHvEgHSAlO/u6diAkdoBX0OSREjL3FtwwYQB+WDn1Maam/XZrHuVm8QIV++5gD2YWDsxtNw6/BntfRF3vxIAITKCzigOvpUW0shGCzoUyaTALx8PMXyeWRWDa+9zQJLSdY6sgtlJRMNwHboLTWrD7GRAZQh0ab0+u+3CRzwA
 nxE6AqGM
 tODJJyIuvBGEzEziR3PFDp0nVWjgxKvN57i55uMwmQ29pxF3x5garb/LXeZDo+4jN4LSC1P0Lww7OWJJPXBjoORWBus1mLXG6e4I1OVLW3jl+Uw/hcGRQLXRViEsdcVbucR8C4G2OLK9F0OoHlQ8lakvWg+lW4glFKH4oSF3RP3H1hH8WCEWO+ZqJjneefKT6pM+ye3hEIF5wI1mbQJhHlX4MoerB9rS7equecIbhuTnnfAJaVBjBy7/Ie0IKdzdVuct5SfHdYAIdGK/nypCbea9nEiuCi4xG0YxJBPCpM+z62M+wY4fXDk4ScC70dkw4ZEpAbC11Tajv9xTPa6hEBDQhwZPmlKSP994MDly0YWZ7z8y3HlCZtx+EINuWWaJsWbnBnhp7yWQodm7gDZuv+ysxUAcguCdVsQ3+qPOaObBXzTkc2BjAhwURLj42qgJG1O/g8NkVvcRHpXqs2TEnCvQxw0E8WqeGOPIWYIz6sJ4HGIYu/JqnbQrg+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Introduce unit tests for HugeTLB subpool functions to exercise subpool
functions. Set testing up so that tests can be run directly from userspace.

Reuses the private kernel struct hugepage_subpool struct layout natively by
embedding the implementation directly, avoiding structural definition drift
between implementation and testing.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/hugetlb_subpool/.gitignore     |   1 +
 tools/testing/hugetlb_subpool/Makefile       |  18 ++
 tools/testing/hugetlb_subpool/test_subpool.c | 400 +++++++++++++++++++++++++++
 3 files changed, 419 insertions(+)

diff --git a/tools/testing/hugetlb_subpool/.gitignore b/tools/testing/hugetlb_subpool/.gitignore
new file mode 100644
index 0000000000000..7348c2c72f1e1
--- /dev/null
+++ b/tools/testing/hugetlb_subpool/.gitignore
@@ -0,0 +1 @@
+test_subpool
diff --git a/tools/testing/hugetlb_subpool/Makefile b/tools/testing/hugetlb_subpool/Makefile
new file mode 100644
index 0000000000000..1bdb7e2635614
--- /dev/null
+++ b/tools/testing/hugetlb_subpool/Makefile
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: GPL-2.0
+.PHONY: all clean test
+
+CC = gcc
+CFLAGS = -Wall -O2 -I../shared -I. -I../../include -I../../arch/x86/include -pthread
+KERNEL_SUBPOOL_H = ../../../mm/hugetlb_subpool.h
+KERNEL_SUBPOOL_C = ../../../mm/hugetlb_subpool.c
+
+all: test
+
+test_subpool: test_subpool.c $(KERNEL_SUBPOOL_C) $(KERNEL_SUBPOOL_H)
+	$(CC) $(CFLAGS) test_subpool.c -o test_subpool
+
+test: test_subpool
+	./test_subpool
+
+clean:
+	rm -f test_subpool
diff --git a/tools/testing/hugetlb_subpool/test_subpool.c b/tools/testing/hugetlb_subpool/test_subpool.c
new file mode 100644
index 0000000000000..78900274cc264
--- /dev/null
+++ b/tools/testing/hugetlb_subpool/test_subpool.c
@@ -0,0 +1,400 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <assert.h>
+#include <stdlib.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/bug.h>
+
+/* Mocked Userspace implementation for Kernel Subpool allocation dependencies */
+struct hstate {
+	int dummy;
+};
+
+#undef kzalloc_obj
+#undef kzalloc_objs
+#define kzalloc_obj(P, ...) malloc(sizeof(P))
+#define kzalloc_objs(P, COUNT, ...) malloc(sizeof(P) * (COUNT))
+
+#define kfree free
+#define kmalloc malloc
+
+#define huge_page_shift(h) (21 + (0 * ((unsigned long)(h) & 0)))
+#define huge_page_size(h) (1UL << huge_page_shift(h))
+
+static bool hugetlb_acct_memory_called;
+static struct hstate *hugetlb_acct_memory_h;
+static long hugetlb_acct_memory_delta;
+
+static int hugetlb_acct_memory(struct hstate *h, long delta)
+{
+	hugetlb_acct_memory_called = true;
+	hugetlb_acct_memory_h = h;
+	hugetlb_acct_memory_delta = delta;
+	return 0;
+}
+
+static void reset_hugetlb_acct_memory_mock(void)
+{
+	hugetlb_acct_memory_called = false;
+	hugetlb_acct_memory_h = NULL;
+	hugetlb_acct_memory_delta = 0;
+}
+
+static void assert_hugetlb_acct_memory_called(struct hstate *h, long delta)
+{
+	assert(hugetlb_acct_memory_called);
+	assert(hugetlb_acct_memory_h == h);
+	assert(hugetlb_acct_memory_delta == delta);
+
+	reset_hugetlb_acct_memory_mock();
+}
+
+static void assert_hugetlb_acct_memory_not_called(void)
+{
+	assert(!hugetlb_acct_memory_called);
+}
+
+#include "../../../mm/hugetlb_subpool.h"
+#include "../../../mm/hugetlb_subpool.c"
+
+static void test_subpool_new_put_no_min_limit(void)
+{
+	struct hstate h;
+	struct hugepage_subpool *spool;
+
+	spool = hugepage_new_subpool(&h, 10, -1);
+	assert(spool != NULL);
+	assert(spool->max_hpages == 10);
+	assert(spool->min_hpages == -1);
+	assert(spool->rsv_hpages == -1);
+	assert(spool->count == 1);
+	assert_hugetlb_acct_memory_not_called();
+
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_not_called();
+}
+
+static void test_subpool_new_put_with_min_limit(void)
+{
+	struct hstate h;
+	struct hugepage_subpool *spool;
+
+	spool = hugepage_new_subpool(&h, 20, 5);
+	assert(spool != NULL);
+	assert(spool->max_hpages == 20);
+	assert(spool->min_hpages == 5);
+	assert(spool->rsv_hpages == 5);
+	assert(spool->count == 1);
+	assert_hugetlb_acct_memory_called(&h, 5);
+
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_called(&h, -5);
+}
+
+static void test_subpool_get_pages_below_min(void)
+{
+	struct hstate h;
+	struct hugepage_subpool *spool;
+	long ret;
+
+	/* Let's initialize: min_hpages = 10, used_hpages = 9, rsv_hpages = 1 */
+	spool = hugepage_new_subpool(&h, -1, 10);
+	assert_hugetlb_acct_memory_called(&h, 10);
+
+	ret = hugepage_subpool_get_pages(spool, 9);
+	assert(ret == 0);
+	assert(spool->used_hpages == 9);
+	assert(spool->rsv_hpages == 1);
+
+	/* Invoke Get (Consumes the remaining 1 subpool reserve!) */
+	ret = hugepage_subpool_get_pages(spool, 1);
+	assert(ret == 0); /* Covered by subpool reserve! */
+	assert(spool->used_hpages == 10);
+	assert(spool->rsv_hpages == 0);
+
+	/* Invoke Put (Replenishes the subpool reserve!) */
+	ret = hugepage_subpool_put_pages(spool, 1);
+	assert(ret == 0); /* Kept by subpool reserve! */
+	assert(spool->used_hpages == 9);
+	assert(spool->rsv_hpages == 1);
+
+	/* Cleanup: Return used_hpages to 0 so the subpool frees symmetrically! */
+	hugepage_subpool_put_pages(spool, 9);
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_called(&h, -10);
+}
+
+static void test_subpool_get_pages_crossing_min(void)
+{
+	struct hstate h;
+	struct hugepage_subpool *spool;
+	long ret;
+
+	/* Let's initialize: min_hpages = 10, used_hpages = 10, rsv_hpages = 0 */
+	spool = hugepage_new_subpool(&h, -1, 10);
+	assert_hugetlb_acct_memory_called(&h, 10);
+
+	hugepage_subpool_get_pages(spool, 10);
+	assert(spool->used_hpages == 10);
+	assert(spool->rsv_hpages == 0);
+
+	/* Invoke Get (Triggers a request for a Global Buddy/Surplus page!) */
+	ret = hugepage_subpool_get_pages(spool, 1);
+	assert(ret == 1); /* Requires global page! */
+	assert(spool->used_hpages == 11);
+	assert(spool->rsv_hpages == 0);
+
+	/* Invoke Put (Above minimum, so it releases the page to the Global Pool!) */
+	ret = hugepage_subpool_put_pages(spool, 1);
+	assert(ret == 1); /* Dropped to global pool! */
+	assert(spool->used_hpages == 10);
+	assert(spool->rsv_hpages == 0);
+
+	/* Cleanup */
+	hugepage_subpool_put_pages(spool, 10);
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_called(&h, -10);
+}
+
+static void test_subpool_get_pages_crossing_min_multi(void)
+{
+	struct hstate h;
+	struct hugepage_subpool *spool;
+	long ret;
+
+	/* Scenario 1: Crossing entirely into surplus territory by a delta > 1 */
+	/* Let's initialize: min_hpages = 10, used_hpages = 8, rsv_hpages = 2 */
+	spool = hugepage_new_subpool(&h, -1, 10);
+	assert_hugetlb_acct_memory_called(&h, 10);
+
+	ret = hugepage_subpool_get_pages(spool, 8);
+	assert(ret == 0);
+	assert(spool->used_hpages == 8);
+	assert(spool->rsv_hpages == 2);
+
+	/* Invoke Get with delta = 5 (Crosses min limit of 10 up to 13) */
+	ret = hugepage_subpool_get_pages(spool, 5);
+	assert(ret == 3); /* (8 + 5) - 10 = 3 global pages required! */
+	assert(spool->used_hpages == 13);
+	assert(spool->rsv_hpages == 0);
+
+	/* Invoke Put with delta = 5 (Drops from 13 down to 8) */
+	ret = hugepage_subpool_put_pages(spool, 5);
+	assert(ret == 3); /* 3 surplus pages released to the global pool! */
+	assert(spool->used_hpages == 8);
+	assert(spool->rsv_hpages == 2); /* 2 subpool reserves perfectly restored! */
+
+	/* Scenario 2: Landing exactly on the min_hpages boundary with delta > 1 */
+	ret = hugepage_subpool_get_pages(spool, 2);
+	assert(ret == 0); /* Perfectly covered by remaining 2 subpool reserves! */
+	assert(spool->used_hpages == 10);
+	assert(spool->rsv_hpages == 0);
+
+	ret = hugepage_subpool_put_pages(spool, 2);
+	assert(ret == 0); /* Swallowed perfectly to replenish the 2 subpool reserves! */
+	assert(spool->used_hpages == 8);
+	assert(spool->rsv_hpages == 2);
+
+	/* Cleanup */
+	hugepage_subpool_put_pages(spool, 8);
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_called(&h, -10);
+}
+
+static void test_subpool_get_pages_max_limit(void)
+{
+	struct hstate h;
+	struct hugepage_subpool *spool;
+	long ret;
+
+	spool = hugepage_new_subpool(&h, 5, -1);
+	assert_hugetlb_acct_memory_not_called();
+
+	ret = hugepage_subpool_get_pages(spool, 5);
+	assert(ret == 5);
+	assert(spool->used_hpages == 5);
+	assert(spool->rsv_hpages == -1);
+
+	/* Invoke Get (Should trigger -ENOMEM due to max cap limit exceeded!) */
+	ret = hugepage_subpool_get_pages(spool, 1);
+	assert(ret == -ENOMEM);
+	assert(spool->used_hpages == 5); /* Unchanged */
+
+	/* Cleanup */
+	hugepage_subpool_put_pages(spool, 5);
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_not_called();
+}
+
+static void test_subpool_get_pages_no_limits(void)
+{
+	struct hstate h;
+	struct hugepage_subpool *spool;
+	long ret;
+
+	spool = hugepage_new_subpool(&h, -1, -1);
+	assert_hugetlb_acct_memory_not_called();
+
+	hugepage_subpool_get_pages(spool, 5);
+	assert(spool->used_hpages == 5);
+
+	/* Invoke Get (Surplus Global Territory) */
+	ret = hugepage_subpool_get_pages(spool, 2);
+	assert(ret == 2);
+	assert(spool->used_hpages == 7);
+
+	/* Invoke Put */
+	ret = hugepage_subpool_put_pages(spool, 2);
+	assert(ret == 2);
+	assert(spool->used_hpages == 5);
+
+	/* Cleanup */
+	hugepage_subpool_put_pages(spool, 5);
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_not_called();
+}
+
+static void test_subpool_free_hpages(void)
+{
+	struct hstate h;
+	struct hugepage_subpool *spool;
+
+	/* Test that free_hpages with NO min_size works perfectly */
+	spool = hugepage_new_subpool(&h, 15, -1);
+	hugepage_subpool_get_pages(spool, 3);
+	assert(hugepage_subpool_free_hpages(spool) == 12);
+	hugepage_subpool_put_pages(spool, 3);
+	hugepage_put_subpool(spool);
+
+	/* Test that free_hpages with a min_size configured is COMPLETELY UNAFFECTED by it */
+	spool = hugepage_new_subpool(&h, 15, 5);
+	assert_hugetlb_acct_memory_called(&h, 5);
+	hugepage_subpool_get_pages(spool, 3);
+	assert(hugepage_subpool_free_hpages(spool) == 12); /* Should still be 15 - 3 = 12! */
+	hugepage_subpool_put_pages(spool, 3);
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_called(&h, -5);
+
+	spool = hugepage_new_subpool(&h, -1, -1);
+	hugepage_subpool_get_pages(spool, 3);
+	assert(hugepage_subpool_free_hpages(spool) == -1);
+	hugepage_subpool_put_pages(spool, 3);
+	hugepage_put_subpool(spool);
+
+	/* Test that free_hpages with a min_size configured and NO max size returns -1 */
+	spool = hugepage_new_subpool(&h, -1, 5);
+	assert_hugetlb_acct_memory_called(&h, 5);
+	hugepage_subpool_get_pages(spool, 3);
+	assert(hugepage_subpool_free_hpages(spool) == -1);
+	hugepage_subpool_put_pages(spool, 3);
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_called(&h, -5);
+
+	spool = hugepage_new_subpool(&h, 3, -1);
+	hugepage_subpool_get_pages(spool, 3);
+	assert(hugepage_subpool_free_hpages(spool) == 0);
+	hugepage_subpool_put_pages(spool, 3);
+	hugepage_put_subpool(spool);
+}
+
+static void test_subpool_max_hpages(void)
+{
+	struct hstate h;
+	struct hugepage_subpool *spool;
+
+	spool = hugepage_new_subpool(&h, 123, -1);
+	assert(hugepage_subpool_max_hpages(spool) == 123);
+	hugepage_put_subpool(spool);
+
+	/* Test that max_hpages with a min_size configured is COMPLETELY UNAFFECTED by it */
+	spool = hugepage_new_subpool(&h, 123, 5);
+	assert_hugetlb_acct_memory_called(&h, 5);
+	assert(hugepage_subpool_max_hpages(spool) == 123);
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_called(&h, -5);
+
+	spool = hugepage_new_subpool(&h, -1, -1);
+	assert(hugepage_subpool_max_hpages(spool) == -1);
+	hugepage_put_subpool(spool);
+
+	spool = hugepage_new_subpool(&h, -1, 5);
+	assert_hugetlb_acct_memory_called(&h, 5);
+	assert(hugepage_subpool_max_hpages(spool) == -1);
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_called(&h, -5);
+
+	spool = hugepage_new_subpool(&h, 0, -1);
+	assert(hugepage_subpool_max_hpages(spool) == 0);
+	hugepage_put_subpool(spool);
+}
+
+static void test_subpool_max_size(void)
+{
+	struct hstate h;
+	struct hugepage_subpool *spool;
+
+	spool = hugepage_new_subpool(&h, 10, -1);
+	assert(hugepage_subpool_max_size(spool) == (10ULL << 21));
+	hugepage_put_subpool(spool);
+
+	/* Test that max_size with a min_size configured is COMPLETELY UNAFFECTED by it */
+	spool = hugepage_new_subpool(&h, 10, 5);
+	assert_hugetlb_acct_memory_called(&h, 5);
+	assert(hugepage_subpool_max_size(spool) == (10ULL << 21));
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_called(&h, -5);
+
+	spool = hugepage_new_subpool(&h, -1, -1);
+	assert(hugepage_subpool_max_size(spool) == -1ULL);
+	hugepage_put_subpool(spool);
+
+	spool = hugepage_new_subpool(&h, 0, -1);
+	assert(hugepage_subpool_max_size(spool) == 0ULL);
+	hugepage_put_subpool(spool);
+}
+
+static void test_subpool_min_size(void)
+{
+	struct hstate h;
+	struct hugepage_subpool *spool;
+
+	spool = hugepage_new_subpool(&h, -1, 5);
+	assert_hugetlb_acct_memory_called(&h, 5);
+	assert(hugepage_subpool_min_size(spool) == (5ULL << 21));
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_called(&h, -5);
+
+	/* Test that min_size with a max_size configured is COMPLETELY UNAFFECTED by it */
+	spool = hugepage_new_subpool(&h, 20, 5);
+	assert_hugetlb_acct_memory_called(&h, 5);
+	assert(hugepage_subpool_min_size(spool) == (5ULL << 21));
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_called(&h, -5);
+
+	spool = hugepage_new_subpool(&h, -1, -1);
+	assert(hugepage_subpool_min_size(spool) == -1ULL);
+	hugepage_put_subpool(spool);
+
+	spool = hugepage_new_subpool(&h, -1, 0);
+	assert_hugetlb_acct_memory_called(&h, 0);
+	assert(hugepage_subpool_min_size(spool) == 0ULL);
+	hugepage_put_subpool(spool);
+	assert_hugetlb_acct_memory_called(&h, 0);
+}
+
+int main(void)
+{
+	test_subpool_new_put_no_min_limit();
+	test_subpool_new_put_with_min_limit();
+	test_subpool_get_pages_below_min();
+	test_subpool_get_pages_crossing_min();
+	test_subpool_get_pages_crossing_min_multi();
+	test_subpool_get_pages_max_limit();
+	test_subpool_get_pages_no_limits();
+	test_subpool_free_hpages();
+	test_subpool_max_hpages();
+	test_subpool_max_size();
+	test_subpool_min_size();
+
+	return 0;
+}

-- 
2.55.0.229.g6434b31f56-goog



