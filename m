Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6B0CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536C86B0098; Tue, 13 Oct 2026 08:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7106B0099; Tue, 13 Oct 2026 08:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3885C6B009B; Tue, 13 Oct 2026 08:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE52E6B0098
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:21:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D04A4C0B58
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:55 +0000 (UTC)
X-FDA: 85317514590.11.D327D33
Received: from mail-m16023653235.xmail.ntesmail.com (mail-m16023653235.xmail.ntesmail.com [160.236.53.235])
	by imf20.hostedemail.com (Postfix) with ESMTP id D6F1B1C0009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf20.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.53.235 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791894113;
	b=tWLRYtTxRgvx0QyHFH/94mxDoiDA5dzL/JEVRhPk+a4Y97NSkked3eG3O8WbAuRsxEc96t
	0pGqFmql5yqIwYOj9sPhQJkDZrv+5/2S77TrZ/sBbuHpYqudYdr1cAH67J1+Sog73BQVk5
	7xSGp1q9ubKRvCftv9Zpuj2uaay19h8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf20.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.53.235 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791894113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=11SLCA9FUlj2rVjvIROu27JkEGWlBPKoCfVrZ+rrJkk=;
	b=tS3dgNYmxfT2qY4E9mRwtkxyqIQE1Jvwo2DN4kg/81qFA/7o0CZW6A+m7JVkbkffkkcng3
	smjg05KSuwiFVWPQ2V072GIuiKzr4PnkN3TBFjIhQg5aUdozmetU/q1dodo1WKOfpJ+s+T
	+/+PRmpsrfP3YfogQqcNmZ9oa6A0T1o=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 200407eee;
	Tue, 13 Oct 2026 20:21:46 +0800 (GMT+08:00)
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
Subject: [PATCH v2 3/6] mm/page_owner: add open-coded page_owner iterator
Date: Tue, 13 Oct 2026 20:21:22 +0800
Message-Id: <20261013122125.843451-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261013122125.843451-1-zhen.ni@easystack.cn>
References: <20261013122125.843451-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1353630d00229kunm0bc94a6a5256
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSUtLVk1CT0ofH0xKTx1IGlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: ox5zfsi68x53boa7za61f1nr7e4iubcn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D6F1B1C0009
X-HE-Tag: 1791894111-565440
X-HE-Meta: U2FsdGVkX1/+UCm+FW38Jtrh4/U7IYirru4ywNZJr/7Eyi3ceI9jy5RYIajPGQJx++jILayVP3OSQyIF8Kkpmzad+rba43c/dcvgI1X/feWSr/uQphKolau8Kk30YagJLXzQwNCAqIR/eIX2kP6nINf7BkAHwG/txtwnJfIIFv9LD5A62y+7jfxznSn+N5WVbVr+u1i2yxYEcDKN8cKyPmbxQgClYGTFoRwbWTa5uDG5ztjOxQ2XCnc2CBb79gVuLpvHoHQsZIDp8hxEwBdNLRWIITSjbPtI6IncFPTWJJC+wHsDUQvZZ5+nX/jTWiArsG4iXLViqRPo9B1//zXIn3pnWgHTfdgFgpYKjxhGWLWKo3F7qC5CEAqM8uyu3BTpFO5NBc2+AvDDI6g1igI2wnXriSe1d5ftgJaCQiKLmnDRF7cexjl8LzVjSHBPBj7gf3iI/vyYmJiSYUFIdVxVRCal9iniOkkpPv3kqfwwqTKxXUI+tQiHlgwv19V5Ha0Zgo1cmJhA/DZxLiAjvMzXiYIB/t2gsY/IVIgtZbEQzEps2hBAJj8utCVdFc4cRSsIm3IJDKJ62dRWxB8pT1Vff47bAcx9TpVs4kuXm/Q7I6R3/230FthwxaasypJXh7xU9gCwLuJGupwpKhl+xkQls4FR8txIa/iVVYmhrtBtRRoNTnMbz9tSxOHYf13GLRfaF9rR0OQfQl9Z07pkHjdCkXpv538lFkr7oiDXUA7jO1dAXAtmIJPKMSfKkctzZ1vMWcVDd6of6xStvR8+Cyh1EmKxxp/z8Z4xahwzc2DWgPmlsBjVcNtrL2zB6UzCAaQrp2XyYFNYNbNU+XJ5N4FLvdtfYsSZ0GFk6MBjPFYkJDtUpw5+cexvMXoEjRyMze8Izlezp9bQgo0pFo3XjStk17yRLnGolaPzEU7QzD3uymc9X6m3M9v/JX8heYK4sYvWOlP4qNlodVmcGWd5a9H
 22GD4P7I
 WpLOSjgVY0QXs0s0Y8BpUNZAXsG7FKS7oLOPWr3GDReZ8G75LKo6lsOaBOdt3rceSdtjOPDv35/pBhJvYIe7vvs/8c7Voc4YYttTm6I6GpPDaFf1L+eBDZ+PJEFqKBiKwaC0Ye4WGksaZpd/dgv7dLtcgpfntkn+gHtY2g9+DUkcV6yc=
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
of the current page into a caller-provided buffer.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v2:
- bpf_page_owner_stack_snprint() now takes the scan cursor.
- Buffer args renamed to buf__uninit/buf__sz.

v1: https://lore.kernel.org/linux-mm/20261009112308.240769-4-zhen.ni@easystack.cn/
---
 kernel/bpf/helpers.c |  6 +++++
 mm/page_owner_iter.c | 53 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

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
index 938cb42ab7d7..ac7e69ba0cef 100644
--- a/mm/page_owner_iter.c
+++ b/mm/page_owner_iter.c
@@ -4,6 +4,7 @@
 #include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/seq_file.h>
+#include <linux/stackdepot.h>
 
 #include "page_owner.h"
 
@@ -122,3 +123,55 @@ int page_owner_iter_register(void)
 
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
+__bpf_kfunc int bpf_page_owner_stack_snprint(struct page_owner_scan *scan,
+					     char *buf__uninit, u32 buf__sz)
+{
+	return stack_depot_snprint(scan->po_snap.handle, buf__uninit, buf__sz,
+				   0);
+}
+
+__bpf_kfunc_end_defs();
-- 
2.20.1


