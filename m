Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D5C0D2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 12:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7B86B03DA; Tue, 20 Jan 2026 07:22:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695226B03DC; Tue, 20 Jan 2026 07:22:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2316B03DD; Tue, 20 Jan 2026 07:22:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47E0E6B03DA
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:22:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EBB095880A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:22:07 +0000 (UTC)
X-FDA: 84352254294.30.9A2484A
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5BFCC1A0008
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:22:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OVZf+HWc;
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768911726; a=rsa-sha256;
	cv=none;
	b=Wf2eRGh5MKyqlMK3UOE6chC6OLpv8R4sr1Pye4bEycXyxuDYi80zR4JF5o3xYbkuS3mR7G
	t/02QwjvAT7VIPnxJDY8Kbu9OPsqtEsw9KuPY9YDTehHBVaAEkwUmb/U4609o2XXXT92ZC
	siNwL+5hEYvcaTC+0uDCOoUzZ/UJLL4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OVZf+HWc;
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768911726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mBOOYNYXFCfWOks6zujGii6P/ItlkH49gnpYx5qmEj0=;
	b=OnLzfNKiNHwiTpUdKp9GmXN8r/o8l1YJESEjl2ma0vfwJ4k7rM6OWIqFrW2GC27fCHMExz
	nbvILtLApTnJ4/+tk0O1kRvvgP21Ds6tWMi5nO3+blFq4OspFUVXRxKof7PvmjgkJgdsX6
	EWFajhsSGBq4Bmw0C2+Rb+1F6F+XlSk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mBOOYNYXFCfWOks6zujGii6P/ItlkH49gnpYx5qmEj0=;
	b=OVZf+HWcipbo88/UUufeT682Qw0LixFHuMyoJr9kztQYteb8FkKxYdPp5HxzztODMqzCYNxrN
	L6KB571pl+MMLOB0P5AhlRUAnbaEOAEGWgUXlo1IGqHbAkJxaJK+fgHqiqrNUaS1bJyv4NMtnPs
	GIt6D5covbai3OCo0PXzuBA=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dwRF46Yjzz1K96j;
	Tue, 20 Jan 2026 20:18:32 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2660540568;
	Tue, 20 Jan 2026 20:21:54 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Jan 2026 20:21:53 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 20 Jan
 2026 20:21:52 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<linmiaohe@huawei.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v2 2/3] selftests/mm: add memory failure clean pagecache test
Date: Tue, 20 Jan 2026 20:32:38 +0800
Message-ID: <20260120123239.909882-3-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260120123239.909882-1-linmiaohe@huawei.com>
References: <20260120123239.909882-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: c46wqnmn75fdwaq9jjg4cypezbp5siku
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5BFCC1A0008
X-Rspam-User: 
X-HE-Tag: 1768911724-995841
X-HE-Meta: U2FsdGVkX1/Jx2IqYDT2v531vjaKBdV/U4fJ9/gZYJ4aJLvnzuk/Djw5S+6f/HAEXLokzBRJ3yYDUUMM47/dt2i213NC3I/8mrSTU9khciFNEyHQpIDorFat7jiuRmX5LOeKeoD4vfD5cFJ+mL4o5Gr/bgaQGYUmEYT/6IT1WwQm7G0ySlsIHPD5VhWolz9dO46iP5lSRKRRayUx4OMImNpyWPIbM8+Uuw0u5Ym+vJEDKPpa/42+LkT7Eq6BqsNvUOEFiBDJ7lhBp5sGQc+9w4UwNCZZQ/lEIP2jmP9+XU7jThyJgl7oQT8jyw3rmcuDbgDt/7Lqtr5GRFeXrNDvh24jJG6N0mB7kGX/jg9FfDVvRegFZVmzy7oZUAnLK62b1hYAKs7rjg8SImO+EteRqvzgPbEMCCGgr1pdjIlSyMpYbg6Le56+C8zLiCfUUkOsPEQFu0lTrCkANmf+CdJEHKHY9sS7Av2Di3XApiEaUyxLOtGWxGnuA8y3FI3HVFU/FnyfANoXku03NJF/sHAS5JjLv2lqutj2KtTSrDpbT8Mz1i35bHlcEIDd51eb/PmbwGDzpB9s4L3BANOURDGJi4TPu7ULRe86/weSZyFa2Qicp30mX1a35MjCYJY+2NCpzG5JtoB4+Vbd/PFS+5AKcsOa7EwX/LyAGQs+eskuxEXNxzEq+T1y6fXgdBvXnJME5EIMcMI2yMrW8iSkhjRuLvNht7bhEorZoUS1ULyh0prrGGaqEqh/hRYT2ObZKNVcK2+OXx8oyuO//25YMtcLpBrSDCwa/KcS2NOlBCuJZ2KBM7Nv5TcyFSGTgB+6gethc8dtTnyCUtQ9I3tEZz+HwYOZLf8SYrz9U2oiRUX4oALLgwpPUZSJiUdILbsQ8xpuTD8U38EBHzJfgcyxTuK4EM/wUQdq0HsSnaAlfrlI5EXmqFsKtX2SN92EUjGc7dGxSCAK2Y9Mnokb+7o4HXo
 hnIvO+9T
 aoPR1YFF4ezfXeW43p1Ss1HPxVhxoF1b1mxywO1908edlqYsyRsDnsdJpsJw5csEf94WqVpuiP5eD+glgYtMefb2OlA5CjDE9MCeVCAbmYerH3dvP2vki2lbjaIJuqoSwwnrqp02bEKBp1UM5qQhjgPcydUFUtk57waGGXUGsF5VxHKzC3wgjqKRhcKpMk5nMvuwsOSD8tWQzQO0aYKhQJzUrcbtLDZfNqfOQcPDO/7CH0B/QmTcvZFycEZogN6JjVIkIn8xtQ5yNTp9DTaNTcRNdzeR3/e2eWEgex4CmAXR2D8yvOfT5edJBumdlKlTj3EkKW81sjQAPvXCDUyq+Fil8G5gVnPJOXzJxfImbIAw2cqIfZnNhs71ufNdimnqsb0BZogzpbtvoNP8=
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
index 37806a58f4b4..128c2ee6d332 100644
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
+static __fsword_t get_fs_type(int fd)
+{
+	struct statfs fs;
+	int ret;
+
+	do {
+		ret = fstatfs(fd, &fs);
+	} while (ret && errno == EINTR);
+
+	return ret ? 0 : fs.f_type;
+}
+
+TEST_F(memory_failure, clean_pagecache)
+{
+	const char *fname = "./clean-page-cache-test-file";
+	int fd;
+	char *addr;
+	int ret;
+	__fsword_t fs_type;
+
+	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	if (fd < 0)
+		SKIP(return, "failed to open test file.\n");
+	unlink(fname);
+	ftruncate(fd, self->page_size);
+	fs_type = get_fs_type(fd);
+	if (!fs_type || fs_type == TMPFS_MAGIC)
+		SKIP(return, "unsupported filesystem :%lx\n", fs_type);
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


