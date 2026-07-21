Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2091CC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 06:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031466B008A; Tue, 21 Jul 2026 02:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24E66B008C; Tue, 21 Jul 2026 02:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D5B6B0092; Tue, 21 Jul 2026 02:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF35C6B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:36:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 35B9FA0B9A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:36:36 +0000 (UTC)
X-FDA: 85011825192.08.0EB3CF8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1F113C0002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:36:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of yanlonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yanlonglong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784615794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=WbL7hLFpyYyWlQ69suI7CdPGRC2HvE0nOjInllVPceU=;
	b=rrPxw7v2rJF+9WxTYmg/OXsh61LksLbZtAbMXE3Ht/Bc6qkgYxBSBfoIQ9KejB+paOUWLR
	D3Mb+iVWL+AWMFZmq5wzDST80Dfj0rUPXUuQ473TFYA2rqauL36K9WeG8nuTN4nG+V21aa
	AKqrdtiekW6ptlBUJtBAvGVDuHUChKI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of yanlonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yanlonglong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784615794;
	b=KD272XdEa4efd+3GFvzzmhwPGsIQs9Zu74Euggh/V+88tdi0nSe32v302UDzJIe4TtR48h
	uL1mLKYDoDfbAvWC38vF1q0tATZQ31AM6EdGxZlCKQA6uPdUL2fj+jCEnu30f4xNa5dhKa
	eDkTiwebiyM5mdC82Lh+oe0qUmY2ERE=
X-UUID: 7ee9a92084ce11f1aa26b74ffac11d73-20260721
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:4c1196d5-20c3-4374-a698-42b25190473e,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:76d2d3ce1ca729c4a973014ee7f7f4d2,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7ee9a92084ce11f1aa26b74ffac11d73-20260721
X-User: yanlonglong@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yanlonglong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 101423065; Tue, 21 Jul 2026 14:36:25 +0800
From: longlong yan <yanlonglong@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	shuah@kernel.org,
	longlong yan <yanlonglong@kylinos.cn>
Subject: [PATCH] selftests/mm/pagemap_ioctl: Fix missing NULL checks after calloc()
Date: Tue, 21 Jul 2026 14:36:11 +0800
Message-ID: <20260721063611.342-1-yanlonglong@kylinos.cn>
X-Mailer: git-send-email 2.47.1.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F113C0002
X-Rspamd-Server: rspam01
X-Stat-Signature: hktnkt9zzwnz5dpnorc7toge6ye4md3a
X-HE-Tag: 1784615792-463034
X-HE-Meta: U2FsdGVkX1+/bZOjYNwPuO0jpJ1JN5wJ+Lk06Q+rZmIJxTSXhiSay2RoSAXqPy6eXaJshCrYZTmjykVEp7t+NdGk72R5cjCz6jY/R4qlQc8qChSTBmlkDzuS7rJW9Wfg/4z9l4Ex/u+/5sAU9M/+0t58U8eXRfqNnm/PE65GM5auPh/C4YRWCN7Nxa8eyHThJ2LBqcVH2FJNS557TWWV8+yjkPM7VfxBUTKL93YhKbdOxd4lz1Gwj4FJFQKOg3gWDh7VYctQx9JxmTU6/OpJVHMv1s7TPi7lbZxwyPWkIRnkwHJtZYTebEeodqPGITqRTYOIuGkQhDtbIMEimDiECEacMCIGzkZK+rnOP2s7FRrbmwLzbEv1Rfbxp4lSpPxD8fCQz4cT6XKjrRiMHl4LTJiTpxUEk9AKbtNeoQIjkrpCrG/Yz1jr+mOTKQjmxzWXxwpb5vNNSZ2vaLooBj6yy5VQ2gBh76Y7TBMsCy2g6YmimHCdNkyEikTm4JcCphWD4dXHIJMeQS+qx1jfnSeeU1frl+msg807zlEWQ0fcsttOdI4olI/zBm+SojiaiZizOlrmjpX3L8RIuo31Aoc/ID3cUxRQcijYmPG1PSEebCrMC0L2wbguZ9hwD1JqHaNvHHd5qyOBmOIP2C5Yl7XNe3fQ0OHMRD9faXR3i5NsHznCvb2oTL5Pa+JNOzv9n72BDxNp4Ed4M+yn6aipD1NvW6WOBXrLSfy5Eln4BZAe8ltmzmjqI9E0xhCPg5nvGjeaBVQ53uWOqxx5NAtAINTUMXUD6QjYUC1UkOHJ+jT5+MV/8yz4bHPnz3HzWyPGYqOwQHcBjq06IYmj99ypuKzYiIakUPik8T0P869kYTGUMwhKiIyzNSjQ8o8GvgbSK75XaDX5d0kR+KVDOTNjXNyDTYlilyBLdVm2cD2DNycaFD+I0Ucdm8EvAMVg0Uf7vP7W2vQforKToTjMcTdcBqd
 fxMblCdI
 5/7Sp6b44M9NU8Y7vMKe3C76+J2xL4cxUsQwzLf9bcGzkrz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pagemap_ioctl selftest allocates memory via calloc() in several
places but does not check the return values. If calloc() fails, the
subsequent code will dereference a NULL pointer and crash.

Additionally, in sanity_tests(), the calloc() failure check incorrectly
uses MAP_FAILED (the mmap() error constant) instead of NULL. Since
calloc() returns NULL on failure, the check never triggers and a
failed allocation goes undetected.

Add NULL checks after each calloc() call, and fix the wrong error
constant in sanity_tests(). Use ksft_exit_fail_msg() consistent with
the existing error handling pattern in the file.

Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index f9bcff8e78fa..f6629f44a13d 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -212,6 +212,8 @@ int userfaultfd_tests(void)
 
 	vec_size = mem_size/page_size;
 	vec = calloc(vec_size, sizeof(struct page_region));
+	if (!vec)
+		ksft_exit_fail_msg("error nomem\n");
 
 	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 				vec_size - 2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
@@ -699,6 +701,8 @@ int base_tests(char *prefix, char *mem, unsigned long long mem_size, int skip)
 	vec_size = mem_size/page_size;
 	vec = calloc(vec_size, sizeof(struct page_region));
 	vec2 = calloc(vec_size, sizeof(struct page_region));
+	if (!vec || !vec2)
+		ksft_exit_fail_msg("error nomem\n");
 
 	/* 1. all new pages must be not be written (dirty) */
 	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
@@ -1000,6 +1004,8 @@ int unmapped_region_tests(void)
 	int written, len = 0x00040000;
 	long vec_size = len / page_size;
 	struct page_region *vec = calloc(vec_size, sizeof(struct page_region));
+	if (!vec)
+		ksft_exit_fail_msg("error nomem\n");
 
 	/* 1. Get written pages */
 	written = pagemap_ioctl(start, len, vec, vec_size, 0, 0,
@@ -1116,7 +1122,7 @@ int sanity_tests(void)
 
 	vec = calloc(vec_size, sizeof(struct page_region));
 	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
-	if (mem == MAP_FAILED || vec == MAP_FAILED)
+	if (mem == MAP_FAILED || !vec)
 		ksft_exit_fail_msg("error nomem\n");
 
 	wp_init(mem, mem_size);
-- 
2.43.0


