Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 109A0E83EE4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 07:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00CB66B0093; Wed,  4 Feb 2026 02:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4DA6B0089; Wed,  4 Feb 2026 02:23:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD75D6B0092; Wed,  4 Feb 2026 02:23:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C99566B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:23:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 617D91B243F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:23:12 +0000 (UTC)
X-FDA: 84405933024.26.595ECD7
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf18.hostedemail.com (Postfix) with ESMTP id 89E371C0003
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:23:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OV9KX8k3;
	spf=pass (imf18.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770189790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WZHqA9lPqKkrjMNeQLv05dYJq5dmAwXW8jYtq6upg0=;
	b=zvicZ9sbERI2NY4wQ3tGGMirwXhC8G7HispIaTjBMgeCq06Ljn2t1soxhxWh5PsMFbGiA5
	S9tFXVmpjBdQhQLFeQLH/vU/Q9AapcR26VrWn8weUpvAxHOiihK6LcHQHy4eGmERdpHi9x
	AeOmOAysSli1KKflG1UeSHu8ScgO9+g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OV9KX8k3;
	spf=pass (imf18.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770189790; a=rsa-sha256;
	cv=none;
	b=x+Jc8x4p4G8mLYQnBiW5d4W1oz7tdUli164S7mSU3J03cCIcVgz7xzMlbXRYp9WpBX3xHa
	R/tfejgIhdDrGiMZaIjfENgQuMv0f5V5fpDC1fXTk97Yo7ymcqG2h4X3HC+7hSS8mdYoVH
	e0fgumYrvlDS13EV1UVM6Gbjq90aeZw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6WZHqA9lPqKkrjMNeQLv05dYJq5dmAwXW8jYtq6upg0=;
	b=OV9KX8k3v9BN3RXwOqFiih7lcukz69wbyhF0+qUr7bwJNmRpnFjYtGQYwW7KYgiddrBvJd7vX
	XzXwR5w/Kst55MneSHY6j4PgEOqQaYYlYe6N6b9FmdhXgcl5NSSHIc3JJSyR8Y9CY3+dVSjwEWi
	qLGeXOws9M5fQ3o6KgYvvX8=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f5Wtr0K5TznTWL;
	Wed,  4 Feb 2026 15:19:16 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E89014056C;
	Wed,  4 Feb 2026 15:23:05 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Feb 2026 15:23:05 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 4 Feb
 2026 15:23:04 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<broonie@kernel.org>, <linmiaohe@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH v3 2/3] selftests/mm: add memory failure clean pagecache test
Date: Wed, 4 Feb 2026 15:33:30 +0800
Message-ID: <20260204073331.899406-3-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260204073331.899406-1-linmiaohe@huawei.com>
References: <20260204073331.899406-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam11
X-Stat-Signature: cb7dafxs9qa7b8an1p3irnmj3swgx6gj
X-Rspam-User: 
X-Rspamd-Queue-Id: 89E371C0003
X-HE-Tag: 1770189789-255006
X-HE-Meta: U2FsdGVkX19y4VfqEGRIckBW4hAD4RQcUZXPipJD/ukd5mVF3EAzegw034WrvahEML6TmPV34FDFHhu4gmIlagGzbC6Try8SSgTLajQvossSKAF3/CQCRAEn2dNJb61y9vPU2ZHhuUA2m2oG2LbpTcflSGHQXQaXHys1HESmVFYGoC+oxFEn7gUTABahBnRmtw6FKmphu1B7TSo28h++wbA+NU6wT+ysKgyYMIQwDLTh7eEzFuF8NKDSuz4OXSHjttMPs0BcALo835pCx2kQ+nsU9bfOCRvfoaDhGWNjKluPKhHkcJjD7hz9ALeZc47g+Me7mu7IgCterX93r8iXHaFM1gy7DM2REsAxc1rPXl7u9MAd64xnc2LooRFzfzFCPw+0thnc0CGkUN3qIlKn052SDPXq4Djy0YiQITuvyjaww2qy9sSZ+uPjvLhvPiRr+RovvWA09gUqsAf8/NPyHt78TYkw7cRN/ZQ4bybBkMt00iwJyGIVx9bZ6R4PiHqrm54vgbrGeF61uOJ2O8YVW0NaRyKG6lMRoraqSfVwJaSQU2VC9hplYPYe0gaHdUDct9eFPYl2aspMOgz2f3lesQJRseirL1Uqc/8dFF9fHIOLX7X3FzyovFEMS6zxs4OZHWoAQ3+3w/TsdCV6CrOETBj4saD1qMo8adE3WrNAx+H2Z14gporWXyqfmBPln/JL7lpO4jisMcw8YIGO1Td16y73vvx6vCwqR+/ldQokdIvPWoXFgsKihrA24kzIurFEDqIrGGDXEouvJBYJiJkTgY84G0Bk59DO32Ya3mbxU89eUAYTRdLTXkU5SZb6G17QFHAmdcg99U8ZfnwU0zZcYw/qC5AgyJGTvrX9QbVcDIb7+947BFCpqmj7HmIUmfX7b70gwGYCjdEjqzvho2MuOTNWz00epF/hKvkjEILeqN5vzK6mMKh4thapIp5lpASIrRg6pYBEefpIM04Gxhr
 3F4Zq7Qk
 7TdEsI763QsWgkWHOnDsp1tQQytethMgjYBkhgdBGzG0a11ZGNDnKXZTK/mSDOGjx59KyVYOf2TgnfwTWfBHX5XVaiaU7Kv/7bBUjD7OI5nN1VsAzzXSjQ7dVbF4EhaeB7fvq0VHofkkImyeM8RP/rnjDvBwF0e7O0zvJhYCLZB/pq7KQVohlGW9Q0CHZY7zYPbHB+2o6PQNkmY7GzNZsu6tQ24+aiqZIyJO0NYLyw3c0IcFGClh++IheaFg3p1ybnoTuLhkj1tCuh9LeV8hrr07IXKrFQjqQpPFuujgO5Th0ZPRdKgrCmMel6nsrVCCN5qYUySUXxL71WFlgUoB859UdXeD2Wb38JbijckZzJXfxPzzM+48XpgSWmEM+lFXhc64my54kI48NjUw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds a new testcase to validate memory failure handling for
clean pagecache. This test performs similar operations as anonymous
pages except allocating memory using mmap() with a file fd.

This test helps ensure that memory failure handling for clean pagecache
works correctly, including unchanged page content, page isolation, and
recovery paths.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 tools/testing/selftests/mm/memory-failure.c | 66 +++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 37806a58f4b4..3aa624db9577 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -10,10 +10,14 @@
 #include <sys/mman.h>
 #include <linux/mman.h>
 #include <linux/string.h>
+#include <unistd.h>
 #include <signal.h>
 #include <setjmp.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <sys/vfs.h>
+#include <linux/magic.h>
+#include <errno.h>
 
 #include "vm_util.h"
 
@@ -24,7 +28,9 @@ enum inject_type {
 
 enum result_type {
 	MADV_HARD_ANON,
+	MADV_HARD_CLEAN_PAGECACHE,
 	MADV_SOFT_ANON,
+	MADV_SOFT_CLEAN_PAGECACHE,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -154,6 +160,8 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 
 	switch (type) {
 	case MADV_SOFT_ANON:
+	case MADV_HARD_CLEAN_PAGECACHE:
+	case MADV_SOFT_CLEAN_PAGECACHE:
 		/* It is not expected to receive a SIGBUS signal. */
 		ASSERT_EQ(setjmp, 0);
 
@@ -236,4 +244,62 @@ TEST_F(memory_failure, anon)
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 }
 
+/* Borrowed from mm/gup_longterm.c. */
+static int get_fs_type(int fd)
+{
+	struct statfs fs;
+	int ret;
+
+	do {
+		ret = fstatfs(fd, &fs);
+	} while (ret && errno == EINTR);
+
+	return ret ? 0 : (int)fs.f_type;
+}
+
+TEST_F(memory_failure, clean_pagecache)
+{
+	const char *fname = "./clean-page-cache-test-file";
+	int fd;
+	char *addr;
+	int ret;
+	int fs_type;
+
+	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	if (fd < 0)
+		SKIP(return, "failed to open test file.\n");
+	unlink(fname);
+	ftruncate(fd, self->page_size);
+	fs_type = get_fs_type(fd);
+	if (!fs_type || fs_type == TMPFS_MAGIC)
+		SKIP(return, "unsupported filesystem :%x\n", fs_type);
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory.\n");
+	memset(addr, 0xce, self->page_size);
+	fsync(fd);
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
+		check(_metadata, self, addr, MADV_HARD_CLEAN_PAGECACHE, ret);
+	else
+		check(_metadata, self, addr, MADV_SOFT_CLEAN_PAGECACHE, ret);
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


