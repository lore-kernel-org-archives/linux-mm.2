Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3565CF6C1B
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 09:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 167C26B0099; Wed,  7 Jan 2026 04:26:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127536B00A7; Wed,  7 Jan 2026 04:26:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05E146B00A8; Wed,  7 Jan 2026 04:26:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAF4D6B0099
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:26:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 943818A440
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:26:17 +0000 (UTC)
X-FDA: 84304636794.14.B79DD11
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8D8FD4000C
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:26:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=iXONkfoa;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767777975; a=rsa-sha256;
	cv=none;
	b=acHnc5K8LzMWyNUhkqXkFiq1NMasa/ORlolM8yCSnhaDfzj8N4noakJouhJMTaeCeqmO75
	Nmyv0peOvEU4ytaU39EKVXrr3MMCDd0xrKT10hiWO383BZFTSQWmIZ37mD1YYWSKprb9lH
	wQyF3EDfZMzSWpC3wGTlckggOBKqQXY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=iXONkfoa;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767777975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIAJBshX9UsaOLqWvmn0k/csmGtpC9VX/+1HAPPsDhA=;
	b=tocdx5XhfnXDLLrBVAbTZEWUU4CDmn8bf7lBOqdRMF66tXXb1FyqYitdcLRIXfOQR5yNJ4
	/vPANjEDTiwPa+oct/mwaxVaH4S6oiTwCFjLuTHIDWUd9FPMgbutZf+o3XtlGOEh8eJr5s
	4zvD2n7Xum06fFt0eUBeI7EONsXH/Vs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XIAJBshX9UsaOLqWvmn0k/csmGtpC9VX/+1HAPPsDhA=;
	b=iXONkfoa/uF/4R4ajhM6wWinUkwHTSF8eaRHL5IvK+DX7ajR7bW1NvMDZYFtqQzDVMMXIgh23
	FuahsRow8QmPRAKOUu4LD4ehjF/NvnutjV5r/ttdwh6jmT+9nVd3E4tbRHAPb4PMf8CS9ykdi+I
	DVJ11cTQDTy8p/tpD9j4ZDM=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dmMyd5zgRznTZn;
	Wed,  7 Jan 2026 17:23:05 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 21E9F40539;
	Wed,  7 Jan 2026 17:26:10 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 7 Jan 2026 17:26:09 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 7 Jan
 2026 17:26:08 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<linmiaohe@huawei.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH 3/3] selftests/mm: add memory failure dirty pagecache test
Date: Wed, 7 Jan 2026 17:37:10 +0800
Message-ID: <20260107093710.3928374-4-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260107093710.3928374-1-linmiaohe@huawei.com>
References: <20260107093710.3928374-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 8D8FD4000C
X-Rspamd-Server: rspam03
X-Stat-Signature: ufqkasak5wyxdoz46gsmwbtafs94npeg
X-Rspam-User: 
X-HE-Tag: 1767777974-922325
X-HE-Meta: U2FsdGVkX19eBD76SnoJ8hr7vyG9/dlTSkf97d1NPycLfppX1rvjGCNo5XEI6PQcMdyz6zTvH1Zbyui5C418KZ68h2MjfWym7Bx9mgEgJzmpbYsyLjRClwIXIexYHYX4KoskMGpSvuEAbyIyeV8GFMm5F5qhpYp/2zMfgsAkrR4m/wKGy2X4HZSKvEgMu7iqXQ07EBBMRQThivXp+tWMKuvMIRiA8tsgA1P3tmNWd8H8QlkL3m3TbAaXn87HZZQBYzJKToTyxWcWnRzzNHXxWuBc/OWPIc8X+cdtmbNk4hNdOUlar82GhVZ9NNlsizYTmIsdlXDAyJiqGOAcrWIeoTfb1rZC1m8JreRS4iYELCMiHELLC8HQkb636ipFUeL10NMWV6SFYed0TFPAdYYkyr0ShQ/vUltfewQ7cHG8nHHKP2jyh7Jt7aj35LO7RU94/aOosRrJHaD3dZjAWd3bbpOWOPSJLvm7yUarz60QRRzfaRStKiAQgVWxyP1G4rrZeTfZoDZE5xcgd5/QuY4dONU3VpJ8eBgSOrj2X15YSzjzL7zY6asAiYrANT+Z+no8uOyNpOHyOr8yJ93VCkj+SoRO1pJbXznuHskLDE/OvoU6Z5GcWWmylzI8dT4X8zFsIC4qK2ksWfmf+M9mgGQeAlLv43VsMKUMpiGt3R7DThzVTpxvEeXnHVKlmou+FObVGw6pzNVvurkGv3+VsytEGo4fE7mSP2d115kx7Ibljh/h6FiN+Ob8x5wEEFUrj8yEKwcBO2evc2YM2M4ClrTTRwcfnkmfpyo8aoJZ7ikeN/M2i9/NlAAv1Y6Bv5+j6wlOtvLx+0oQeJWe8oHJVwOUMUeYlL+Lim00mnnLDgqL40rnPh2ykswk+4QhJzt6Gvm+uWkIzAPliyHajs5T+KVx6cB6u4uHZ1dYgs9mfA2RwsVTsU2/OklOfO8BVQ6g4Y2Bzn+3MG4AqRegXlBqga7
 BeiCuZng
 e3cCfUhXP5CZhZHpGY3gzWtf+JURICzgL4fU9G7TetcPNZAcwF720JKy+sLc1Sb3dYhY1IzEIACKCbuUjJEnCWgG1tZqufO6G6m4U7zpgHz824Z6a0aWcruPKB4Mqjj5RteexxsYYz1/inlzVXGAyvsxL7v7XJrhzz6uiwgN+XL0xvpGun3erxDp+fU/StslQ05l8A5Z0LvXvJb6Sv4E9nsnk9wyRyrHdut2/ncRDW9Zg7q7Nug9zdOY6FEX0zZzeD6a5iZcY4BRdNwz8Mh4ZpWN0Ivs6VpclFPT84naGncLjeHdRgm7xqo1AEh4mzRGFKWTe5RtfYa58MRU2KWtMEHesAQ61C4W3OsFPBLC/FwSV1W0LH8arOBJRyLSR0QCuFdwAs90vMNYKByc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds a new testcase to validate memory failure handling for
dirty pagecache. This performs similar operations as clean pagecaches
except fsync() is not used to keep pages dirty.

This test helps ensure that memory failure handling for dirty pagecache
works correctly, including proper SIGBUS delivery, page isolation, and
recovery paths.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 tools/testing/selftests/mm/memory-failure.c | 58 +++++++++++++++++++--
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 41bc669cef60..275ab1c6de0c 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -26,8 +26,10 @@ enum inject_type {
 enum result_type {
 	MADV_HARD_ANON,
 	MADV_HARD_CLEAN_PAGECACHE,
+	MADV_HARD_DIRTY_PAGECACHE,
 	MADV_SOFT_ANON,
 	MADV_SOFT_CLEAN_PAGECACHE,
+	MADV_SOFT_DIRTY_PAGECACHE,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -159,6 +161,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 	case MADV_SOFT_ANON:
 	case MADV_HARD_CLEAN_PAGECACHE:
 	case MADV_SOFT_CLEAN_PAGECACHE:
+	case MADV_SOFT_DIRTY_PAGECACHE:
 		/* It is not expected to receive a SIGBUS signal. */
 		ASSERT_EQ(setjmp, 0);
 
@@ -169,6 +172,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
 		break;
 	case MADV_HARD_ANON:
+	case MADV_HARD_DIRTY_PAGECACHE:
 		/* The SIGBUS signal should have been received. */
 		ASSERT_EQ(setjmp, 1);
 
@@ -241,18 +245,27 @@ TEST_F(memory_failure, anon)
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 }
 
+static int prepare_file(const char *fname, unsigned long size)
+{
+	int fd;
+
+	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	if (fd >= 0) {
+		unlink(fname);
+		ftruncate(fd, size);
+	}
+	return fd;
+}
+
 TEST_F(memory_failure, clean_pagecache)
 {
-	const char *fname = "./clean-page-cache-test-file";
 	int fd;
 	char *addr;
 	int ret;
 
-	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	fd = prepare_file("./clean-page-cache-test-file", self->page_size);
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
-	unlink(fname);
-	ftruncate(fd, self->page_size);
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
@@ -282,4 +295,41 @@ TEST_F(memory_failure, clean_pagecache)
 	ASSERT_EQ(close(fd), 0);
 }
 
+TEST_F(memory_failure, dirty_pagecache)
+{
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = prepare_file("./dirty-page-cache-test-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test file.\n");
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+	memset(addr, 0xce, self->page_size);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (!self->triggered) {
+		self->triggered = true;
+		ASSERT_EQ(variant->inject(self, addr), 0);
+		FORCE_READ(*addr);
+	}
+
+	if (variant->type == MADV_HARD)
+		check(_metadata, self, addr, MADV_HARD_DIRTY_PAGECACHE, ret);
+	else
+		check(_metadata, self, addr, MADV_SOFT_DIRTY_PAGECACHE, ret);
+
+	cleanup(_metadata, self, addr);
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
+	ASSERT_EQ(close(fd), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.33.0


