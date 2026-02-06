Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24FF6E8B364
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 03:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B82D6B0096; Thu,  5 Feb 2026 22:06:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54FA96B0098; Thu,  5 Feb 2026 22:06:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8986B0099; Thu,  5 Feb 2026 22:06:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7556B0096
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:06:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF7CD1B2C12
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:06:36 +0000 (UTC)
X-FDA: 84412543992.12.7195AFF
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf28.hostedemail.com (Postfix) with ESMTP id 40401C0002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:06:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bS+LYkvr;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770347194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s09W6T/GPRyuerNlrv5Ie2L5UW/FX11530s9MFvNE9k=;
	b=2fFXoZ21CRv5CIoNyJ0OwqCyQuPYblxiRU4nefDru4tD2nSlUUHBKNuNooICah1h7DwDGh
	el5Bw/CxzYtWe3uHSWhd3GD80G1AEpHPzKD2/AJkO+MQV0LzBHrk2FdhKCVLpLbDT8b/o+
	jXxX5LAhMgVdDf+jjMutKbGrlELUoXc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bS+LYkvr;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770347194; a=rsa-sha256;
	cv=none;
	b=f4ktuxBrPV0iE5AiAoVqyJSoUQ0o3MsatjIrb8NdZgOchhDiZ+TaA50+FQYaYssvUOPJ34
	6ankM/NT0DcCyNgk65W5719SnDPEm8Mh8NPgZsZSmiVFHuFJR5TV6y9CGtIBRuBWkgOpxc
	d3Bj2gAVNMhQZWAMI1ZXmWyXYx43rvo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=s09W6T/GPRyuerNlrv5Ie2L5UW/FX11530s9MFvNE9k=;
	b=bS+LYkvrjYAQ2n6R77Wd+cwuAY5NfZdg8JR8ntIaEENdBt5a0JxU6C3WY7K1+EGFL1PPNJiLX
	BeRkw2I6/1xUhoPQgI7WW1fgkOjxxugRuwvPawScgtx8VKSYBH/l5vASkO9L2fNvY5N1SOCO/8u
	Zxb4rj4UuHY35Ne3yoF3Ggw=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4f6f585B66z1T4Fj;
	Fri,  6 Feb 2026 11:02:04 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 9074C20168;
	Fri,  6 Feb 2026 11:06:29 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 6 Feb 2026 11:06:29 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Feb
 2026 11:06:28 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<broonie@kernel.org>, <linmiaohe@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH v4 3/3] selftests/mm: add memory failure dirty pagecache test
Date: Fri, 6 Feb 2026 11:16:39 +0800
Message-ID: <20260206031639.2707102-4-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260206031639.2707102-1-linmiaohe@huawei.com>
References: <20260206031639.2707102-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40401C0002
X-Stat-Signature: fk89peqp1huprnzqc9ecg8hko9yroyif
X-Rspam-User: 
X-HE-Tag: 1770347193-421147
X-HE-Meta: U2FsdGVkX18346h+K9Ogh3kb6deA2XldMHmdS/XpZp7n00ybbr0KPq6c+Tr47qKrppYjfVLdw+mbPcuwwrSFjzxBn5gygk9JqvMXlo6dNvLAbRXHZ5Gzvt7Q7X42fQKrtz+XlOQStUEe94fjtNTXdBzu27vzTdvXUFPPyS0LYNt0hoVGDV10ecAygdy9M0jEXdwvV+NZChdNdSZmO7+B7g1qx2czQLDFUomkaDQ9LaJhSTfn3lPVUXsNOjviSAXcjz7joI4MSjHepoWISvZmNot10yuvIgjI1LDox5AW12zpwPvARdPrd+ip2ydBQiLokF4DxycNKhIH+XFzBU58st8zfEmWr3biV9CtyJ53oI3emnOBhuwtc+ElfczLDF82utjR+T5mJYgq912Xll1fBh6yrRs+uLsZ+EnzFrezxdZde/q1nCrFbWKjrvkCohF2z0GOv2qd3fSLup+UeotSw7lc1TYCIiw2ivtlWlWK00Q9MA6xRGO6i5Ts7J/gl05K/d7mYw2jbdVeMOcJcWogdqDgBR27i8ul+NY8Iw0fnf0pEzK8TqtWOTtz4cUZvvopRUed9fuXG66ug6vuGkiVMv768QgjAiQLpWr1qupiJLai+41hNuWi8G7JIzFs+br29ZMJ6MfcS2l3CnYgFEoMtWk/M/t1C6/fU2Yh6Ht1V6S6BInUzYYM37f3H2V9y7YcwBW1dxS0c/4TOhKLIgelPCUaYycXwXnzxwbdUXNamwA/A1i4DrDhutFH/OM7gDbS/nQt0twGtlQj9Eod5CQE8PEzmtKjDoSwoMrnXp0XZRqsTRiFXi24rckKCMiJzxmhFuQ4/xUc8pq+GLe8Jr4ErVVypwGGsT9CjD+5OHGl5TkL94s5e237eIknM5n4xFgAAmd4jPE0yAbsVIOSIGit3AIHNmy+LJVbRTDvZF0akpTZmI+XS74BVStsjsCaBBlt4ib8lNAbIAaTE7EglFd
 rFhfqQ1P
 mxXuAKKnuhqAq6fGNxGzzLZuy6SG5PBhqw1gt6KoVp/OqRmW40MnPjyZ4RS4Twk48FVH2ywmm/DZ8/96R3hdqtcWtSUu//p2yNGwh5Hz1qyCSnX2JdIbdc2Hs7xcvaNtWbCYNoSOXz7y+e5adu6Do58Br1OjhJFfvfP475s3s2ZR9x/qtV37DgoGOgV3lpmA/2kjiEc2sXel5k11T41wChWw88/kGQRMb7+I6LQAp5M7iOsRuHeqq/1/ogRr1IObxyk3e5qGhl44p2bNva6Sb5nozmc3+yOeai0VHaDsZ5CgOJE14NVL6Hdp+T2UW1Tfz9eVIrLqyByUq1Ng46MkxithCuwXIKIs79q8c/ccdP5PnjAqJusnS6stzQq7xW3qDzyMoqwOt+c2d4lO5hl/2/Jx7HrhhH8tmU6Y3HK5qpijZCW+7g5rYf4C4YEg+MfKgOGslsmV4cvckUQEnwZx1grscG4JC6WHa5avm
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


