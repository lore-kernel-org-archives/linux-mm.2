Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D5DEE83EE5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 07:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F39D6B008A; Wed,  4 Feb 2026 02:23:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874336B008C; Wed,  4 Feb 2026 02:23:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796426B0092; Wed,  4 Feb 2026 02:23:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64B7E6B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:23:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E22416071B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:23:14 +0000 (UTC)
X-FDA: 84405933108.09.9E3DF0C
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf11.hostedemail.com (Postfix) with ESMTP id B4E9F40006
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:23:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bS+LYkvr;
	spf=pass (imf11.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770189792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s09W6T/GPRyuerNlrv5Ie2L5UW/FX11530s9MFvNE9k=;
	b=qNbV/TBNDw33W0VHRzLXlRwug72wz4BgTLlsLe0q45s3rrb6+vS2lp7epxOuEQZfKnccQm
	OIlyYZm4idpQy3WJWONZ/yD93pJV+iluqBnhCBG/np8y2R4frtZZcY7l4oJEdsYLddrabz
	yVrb5yz/KJk5ggCZtsRHIUxpvlufasw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bS+LYkvr;
	spf=pass (imf11.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770189792; a=rsa-sha256;
	cv=none;
	b=4Ho5ifRXer3877yq9FBQ09jBghuwRwHZJvyg0AGwbNvYkNgcy4CcxgDxMf7JQe33E4gH7Y
	Q4bwKvQrF7zFa7Kq16AVUg9OBY3KWfgSkTkMTqJO5cjrHIotoV5hAIVjaCS0mYISjLH9MX
	scyKm207YY1veY26B6fcZFbnVaKPVXU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=s09W6T/GPRyuerNlrv5Ie2L5UW/FX11530s9MFvNE9k=;
	b=bS+LYkvrjYAQ2n6R77Wd+cwuAY5NfZdg8JR8ntIaEENdBt5a0JxU6C3WY7K1+EGFL1PPNJiLX
	BeRkw2I6/1xUhoPQgI7WW1fgkOjxxugRuwvPawScgtx8VKSYBH/l5vASkO9L2fNvY5N1SOCO/8u
	Zxb4rj4UuHY35Ne3yoF3Ggw=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4f5Wsz5XfBzmVCj;
	Wed,  4 Feb 2026 15:18:31 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id BDE2E402AB;
	Wed,  4 Feb 2026 15:23:06 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Feb 2026 15:23:06 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 4 Feb
 2026 15:23:05 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<broonie@kernel.org>, <linmiaohe@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH v3 3/3] selftests/mm: add memory failure dirty pagecache test
Date: Wed, 4 Feb 2026 15:33:31 +0800
Message-ID: <20260204073331.899406-4-linmiaohe@huawei.com>
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
X-Stat-Signature: 1k7q5pxrkx97fcp9hmoakdh5saruxb7n
X-Rspam-User: 
X-Rspamd-Queue-Id: B4E9F40006
X-HE-Tag: 1770189791-481883
X-HE-Meta: U2FsdGVkX1/uQWZP7Xp9p/y/jyZksIhJR+UL4iomo/oB7L8r1k35l8G3e7bIUvnRi5HmszAHrZjUBzlatjmJIY/0bw9KfPwE0aryzWCoMbjf/+rzKpwtZHgy3Zsmlp56wXkBw6SQSJVDlGWeEX2ObmbM9QgayJSpRdnf0dgnR1NHU16icl6emaPzavZvKK2a0EI0c3fHkZFdgcJXXXhiS+zgnklai1+w5PDwA+bXDbIkyRNzG/MHLQ4Ol6xtbiY7mPHc/j4qlvC4w7+JflhFTfb8B4oNrNtjcuDEkmp5VILj3gOpOh+zI7KI4pWT0xWMCvsIPs0BtafySyhKDhKSDKVUeXqv5XtJmV12PR9TEHldnBxxjKZKS45z1icn4Yecl7k7C42xjxGF4BwpuoLQfccfy2GiVz0TFW79rAksBrpkmkF1AhfROK4zcV9SyhZstzScNSBU2ifGzsSJaxVriowWJubr+IIwnOtqR2wTmSmiTbNlJLVBu6/F5a82F0T23lE7LCACrQbvjgFLeH2IuXXOFWAiE4y/bPMKRtn+sLCvrHosetLKlRVbeTXPZgTg8d9T92J/Y4phD8/+wY3lPonqdLVni0YDb9lcVZFGCKZGWWB74j5zrMpS3OjxcrxY783WJEzr+yDnioFqSbdbrH7JAcGmHkF4mLN+j6X50lk/f6XGd+nOnVBwG7TqLFYkHRSBkTFBAx355q3igFcj7+z0P6ttrFcRGKm2lTuXeHkjaks+EpTL5bWme184jPelvdIx+i2IMrL+FhdEesvUDXIrU9gDpZVeGwPoa6tg2jOayHKfQsEOBlbDnSGqj/7jABpt4lTKCbJRMZpcUXxyNjbUgPuXb8ocGVuHEPZSlzLCkVSc3rIqHhqrkFCndR1nluv1O2axQlf8zR8Ts3SPvvAISoDOCQhhP0FEn7UUCA6NqiFS3DM4uO/Lpn0w27hnY9n2tn0JN7NgSwy4UYE
 6dFHHzf0
 YQrLSAmcKDDkxjnVuLizVROups3tLmt5BlorKTD8ZjlxpIjT/J8k4Hvvxwf4KWXj1QyA5+1E385W+H1m4VwAaz0REEx5si47KmyKrf/MnuaHXjCAGz+hvl5I3gzkpKNlZWHHUuKpJL/ieOw6/CTwHgDrRIGRY4/bL/QntE0n2rjMSp1Cak3zUF0Wy0hJjMwDxswus8ZEmn3qSQY+XlafL6FoYV2OAzJZOGTPuhcPBQyQCosvYB3EvgI7UvVIRp5+eOZn7YyYfQwo5m+zBTdq6bOTkJkmsHufE/UYqK/RD0S53ouILUHYiOmMBYTblst2t5Dlmgn2D79WCI0cLqA32Q9HXmQvfYHgH9Ud32x4fNMlgpIU=
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
 tools/testing/selftests/mm/memory-failure.c | 62 +++++++++++++++++++--
 1 file changed, 58 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 3aa624db9577..3d9e0b9ffb41 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -29,8 +29,10 @@ enum inject_type {
 enum result_type {
 	MADV_HARD_ANON,
 	MADV_HARD_CLEAN_PAGECACHE,
+	MADV_HARD_DIRTY_PAGECACHE,
 	MADV_SOFT_ANON,
 	MADV_SOFT_CLEAN_PAGECACHE,
+	MADV_SOFT_DIRTY_PAGECACHE,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -162,6 +164,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 	case MADV_SOFT_ANON:
 	case MADV_HARD_CLEAN_PAGECACHE:
 	case MADV_SOFT_CLEAN_PAGECACHE:
+	case MADV_SOFT_DIRTY_PAGECACHE:
 		/* It is not expected to receive a SIGBUS signal. */
 		ASSERT_EQ(setjmp, 0);
 
@@ -172,6 +175,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
 		break;
 	case MADV_HARD_ANON:
+	case MADV_HARD_DIRTY_PAGECACHE:
 		/* The SIGBUS signal should have been received. */
 		ASSERT_EQ(setjmp, 1);
 
@@ -244,6 +248,18 @@ TEST_F(memory_failure, anon)
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
 /* Borrowed from mm/gup_longterm.c. */
 static int get_fs_type(int fd)
 {
@@ -259,17 +275,14 @@ static int get_fs_type(int fd)
 
 TEST_F(memory_failure, clean_pagecache)
 {
-	const char *fname = "./clean-page-cache-test-file";
 	int fd;
 	char *addr;
 	int ret;
 	int fs_type;
 
-	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	fd = prepare_file("./clean-page-cache-test-file", self->page_size);
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
-	unlink(fname);
-	ftruncate(fd, self->page_size);
 	fs_type = get_fs_type(fd);
 	if (!fs_type || fs_type == TMPFS_MAGIC)
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
@@ -302,4 +315,45 @@ TEST_F(memory_failure, clean_pagecache)
 	ASSERT_EQ(close(fd), 0);
 }
 
+TEST_F(memory_failure, dirty_pagecache)
+{
+	int fd;
+	char *addr;
+	int ret;
+	int fs_type;
+
+	fd = prepare_file("./dirty-page-cache-test-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test file.\n");
+	fs_type = get_fs_type(fd);
+	if (!fs_type || fs_type == TMPFS_MAGIC)
+		SKIP(return, "unsupported filesystem :%x\n", fs_type);
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


