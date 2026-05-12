Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 864A7CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A606B008A; Tue, 12 May 2026 03:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3BC06B008C; Tue, 12 May 2026 03:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A0B6B0092; Tue, 12 May 2026 03:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD5BF6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:15:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67A388C9B7
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:15:22 +0000 (UTC)
X-FDA: 84757906884.29.AD91411
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf24.hostedemail.com (Postfix) with ESMTP id 60269180006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:15:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570120; a=rsa-sha256;
	cv=none;
	b=r/xsMC8djZL7uXMD7Hxef8lIywRjYQInGO9y+C8HG6HwmiwRiq+UnsF0v5JAvAyshcaUHF
	mgESm8CUoBQCHXJyfv7EO5TSWxCqaweZge4DNUAoohq1YukjDI8hpWjzHlLS5AkoTDfHnd
	puey4NhQc/VjBe3XKKzH3vaznDN0Pa4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=6Q7+J2j7UVCFrdF1FM5910G7lPwWZ7/tIsBfGI2nj94=;
	b=7bdLn8YpNlvg1GZfupLrIy+DYZz3hLKW23ibHiDak2D4Xv8/cauoecKnG6I4kCpjkJWWrm
	Ytf9Xxf4UPJUfWs94jyqHE9bnwrSuP8p2kCzCIVfid431iL7oyPDjCSx9WRDJpRSeiVm2V
	+s3z5vE0VhjQGLJ8HUhLBOry3CdzD64=
X-UUID: 4eef91f44dd211f1aa26b74ffac11d73-20260512
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:f9674a71-c2c8-4f0f-879b-b5182cad1869,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:f9674a71-c2c8-4f0f-879b-b5182cad1869,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:a4fa77afa57655aead32552bc0befba1,BulkI
	D:260512151511UXZ7AZTA,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4eef91f44dd211f1aa26b74ffac11d73-20260512
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 588572323; Tue, 12 May 2026 15:15:08 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	vishal.moola@gmail.com
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v2] selftests/cgroup: check malloc return value in alloc_anon functions
Date: Tue, 12 May 2026 15:14:24 +0800
Message-Id: <20260512071424.59449-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dm11u4nodfp4gpgphqh6c3r5grcaz9j5
X-Rspam-User: 
X-Rspamd-Queue-Id: 60269180006
X-Rspamd-Server: rspam07
X-HE-Tag: 1778570119-8259
X-HE-Meta: U2FsdGVkX1/JPOMkesAnSKUgrzpA7jyYyI+UWXcpJh8jNlEUz8E3j/gaMDSZQ7GgWw6NrWTov/9Ngl7UGXUA0uTOxYdkN/dQZUGNjd/ENmlWzO0b7j4ED9s6pr28NBOpSWXqf2RRcX0b8IXbNL/BDH9Ix6QTaIAHNzoxnKesh64yp3va4FF4ufSmt0KK7j/nmZ4FVMvqlpU5urB7vncTxwCIkb1MjmlFqiZIgqpH6Tjt8gV4DXqXaW9UcESDlNet5GbR1sTVCYVbPu/aVWewGKwAum22RjGMTpjNonttkIBpeU8YmrKIAuMt3+5X73zNfwHymn5Vf3J1f+XCdxPq4SGXJKtrWtKfZgV31RTpbBeV1ScHz/C+0iPESxajcrODfiivE7mKTa4XtfjPe4OOwF94G8XHJYzjE0Fz0Z1TXfQYcVm1WmBqPJPj2tqa/m3i3phHQP1cMifFyQvhYZoCsCrEaV221i7dDjLdagN/P0JbdCgktLc6ACJWGHJOcfGaoMbHKIVXlUQ+rsX1ZO6tFKXt1ni66CY4XJYyBKdtBypoKvy6Vpjr7lY2PtzI3xLnE+/E9cQrri3EmZw/dcZCEazbymrCXLDjlDSaJt+Bvl2ieDJSjG7aIPflt3OwK6WKG7uqOKFyKndBIacMCH2IyZNKfjnFPaxgJFx5QXokFe+zIVAq3kCwrjnR+1anmqUCUAAeMa2EElfKwT9Shmj9C1Ns+y0fHTAQQiJi3ysKm380iQfrLLyGODDAyoYaABWLIHYrFxnKbySEI616+COytuSnamHHz3akh9np29AjyPGCgckJwVv/e0HWEomt4BbZ07JkjO2zg/uLuf/4d8WsJqYdP32VU05QcvHh3BEw0SQdQRLt6lFrUwkski9KCAVF5v8X6FjrPHkF/LyAuDTJhNPaDEhrUnSVMJ1rgnDKhF3aKESyX/8wfPox46A6aF9dCqAaLb420habdUUKuhW
 BXZae/j8
 6OwjUY9GIlCEmFLbUGauJ/3vu6rT5IbgjywgNuBhrFtg58M+Qo6EcUEQOmHHST8/30f8y791I1H1ifFirh0miAoT6nK6yAlYPP6SfxNTj6C1+Krh3rLrsf+32RkiA2kFCVWAj400yvMsdTsY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_anon() function calls malloc() without checking for a NULL
return. If memory allocation fails, a NULL pointer dereference will
occur when accessing the buffer.

Add proper error handling to return -1 when malloc() fails in all
four alloc_anon variants:
- alloc_anon()
- alloc_anon_50M_check()
- alloc_anon_noexit()
- alloc_anon_50M_check_swap()

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
v2:
- Refactored repeated malloc() patterns in alloc_anon_* into a helper
  function.
---
 .../selftests/cgroup/test_memcontrol.c        | 53 ++++++++++---------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index b43da9bc20c4..21aedb35cc12 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -55,15 +55,31 @@ int alloc_pagecache(int fd, size_t size)
 	return -1;
 }
 
-int alloc_anon(const char *cgroup, void *arg)
+static char *alloc_and_populate_anon(size_t size)
 {
-	size_t size = (unsigned long)arg;
 	char *buf, *ptr;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return NULL;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
+	return buf;
+}
+
+int alloc_anon(const char *cgroup, void *arg)
+{
+	size_t size = (unsigned long)arg;
+	char *buf;
+
+	buf = alloc_and_populate_anon(size);
+	if (!buf)
+		return -1;
+
 	free(buf);
 	return 0;
 }
@@ -174,18 +190,13 @@ static int test_memcg_subtree_control(const char *root)
 static int alloc_anon_50M_check(const char *cgroup, void *arg)
 {
 	size_t size = MB(50);
-	char *buf, *ptr;
+	char *buf;
 	long anon, current;
 	int ret = -1;
 
-	buf = malloc(size);
-	if (buf == NULL) {
-		fprintf(stderr, "malloc() failed\n");
+	buf = alloc_and_populate_anon(size);
+	if (!buf)
 		return -1;
-	}
-
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
-		*ptr = 0;
 
 	current = cg_read_long(cgroup, "memory.current");
 	if (current < size)
@@ -406,16 +417,11 @@ static int alloc_anon_noexit(const char *cgroup, void *arg)
 {
 	int ppid = getppid();
 	size_t size = (unsigned long)arg;
-	char *buf, *ptr;
+	char *buf;
 
-	buf = malloc(size);
-	if (buf == NULL) {
-		fprintf(stderr, "malloc() failed\n");
+	buf = alloc_and_populate_anon(size);
+	if (!buf)
 		return -1;
-	}
-
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
-		*ptr = 0;
 
 	while (getppid() == ppid)
 		sleep(1);
@@ -990,18 +996,13 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 {
 	long mem_max = (long)arg;
 	size_t size = MB(50);
-	char *buf, *ptr;
+	char *buf;
 	long mem_current, swap_current;
 	int ret = -1;
 
-	buf = malloc(size);
-	if (buf == NULL) {
-		fprintf(stderr, "malloc() failed\n");
+	buf = alloc_and_populate_anon(size);
+	if (!buf)
 		return -1;
-	}
-
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
-		*ptr = 0;
 
 	mem_current = cg_read_long(cgroup, "memory.current");
 	if (!mem_current || !values_close(mem_current, mem_max, 3))
-- 
2.25.1


