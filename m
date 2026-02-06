Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3264ECD9BE
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 03:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F0C6B0093; Thu,  5 Feb 2026 22:06:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E88B6B0096; Thu,  5 Feb 2026 22:06:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5346B0098; Thu,  5 Feb 2026 22:06:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ECA9C6B0093
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:06:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 711495A951
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:06:34 +0000 (UTC)
X-FDA: 84412543908.10.9CFF27C
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf04.hostedemail.com (Postfix) with ESMTP id E7E2340008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:06:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dNWd3bco;
	spf=pass (imf04.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770347192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ug7z8CLLEDzHiWAEhPgov/+aEPCr00FtYh62Hmq/jp0=;
	b=LMmZo3So6SuEFAYwbp9QV/xu25RlSxVrynI/nlvtBrL8f2rJIpoju2tliVyeAU1EniGpQG
	XJZq61s9m3mT6T2cwJeVfLcHvqMzjHHB6T2eh7VVBCOKmqVcsekgmc6j1z+Yg3teDWWKQf
	SqzgfN+sS6Ua0Ny47ZBA7mpK21hRq9Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dNWd3bco;
	spf=pass (imf04.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770347192; a=rsa-sha256;
	cv=none;
	b=mVJME1Pub8cyNdQxBsfYZ4hZegMYUd3CQznZdO9EEg/8MrycXjTFZce9E7AozGKlUoTFIC
	gWw4syRQk+NtpP3LGdCcyd2Vy9RnJteygth8l5F8+LVAhQCxs4VM4gKAk1zTBYUdSiklzh
	IpfxIj0ELjbwwTf/gkX4MV27IHosByE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ug7z8CLLEDzHiWAEhPgov/+aEPCr00FtYh62Hmq/jp0=;
	b=dNWd3bcoY4ssyLLLCxM9wWF8VBLSOuMVx87c+i0YxTnhwMOQN6rexGePZArJeog8m56jvEV7m
	oiChmeFOPbKBCob7G4Y+etLECc0NLpQwkswquRAmxLvofLN6Ab69eJknMyqBbkYJJe1B3cIeXLC
	Nn+wNV2ny08POm5TlJYvYYQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4f6f5L42D9zpSvh;
	Fri,  6 Feb 2026 11:02:14 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 530C14056A;
	Fri,  6 Feb 2026 11:06:28 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 6 Feb 2026 11:06:28 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Feb
 2026 11:06:27 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<broonie@kernel.org>, <linmiaohe@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH v4 2/3] selftests/mm: add memory failure clean pagecache test
Date: Fri, 6 Feb 2026 11:16:38 +0800
Message-ID: <20260206031639.2707102-3-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260206031639.2707102-1-linmiaohe@huawei.com>
References: <20260206031639.2707102-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Queue-Id: E7E2340008
X-Rspamd-Server: rspam07
X-Stat-Signature: xmzgy5aeougyy6wqnyjw1a6bcp8oecna
X-HE-Tag: 1770347191-997048
X-HE-Meta: U2FsdGVkX1/1mabLSJkwhCiuCSbElPcpm5D/V/AmSOQqOnq9YExmeT3BArHsATa6XchZPLojCe+/TzLczhF1vgoUDMMh23yjVOEzwCrvjSjyGLL6tHiaEY29QNtUveyiyzEAdwUOHZcXgFAsO1EYwsPEqWQg8mZ1BgdbebpkahsLLMofD2bPCMdHW6sF/RqjyVyEQDVuP3PQ7rDc18eHmIaXd6idLWdqBeX9V3v0CDMUmuHytdcNcG3hSei8stHau+o2lDV/McneQ9NEy758C8lxhDRECXBxyUBELQWSEdDz/EtATvuX4fFQjckI9vv8apQSr9FVEiLocu0TkmtLXxqHpxapS31tSG9D25Q0VSRz4mhNeZVg4Y+Bvqf9Tm+oagbYRsK28b3kpwgpx77h8UN0h0kP82AwqED6yOBfWGRUkiU9HU1cEBJrJp+yzv2kM4uURI5nvEuCYpteb5mHXJEidmiEyfPH4IgY2ZRv26vEE+Avny2fDV7QxC6u55hpHcrjvnKpEscn0VlQztlvBQT/JgGfA6gwStDdTJZGugbFQaDOIYVNbAn0ecYVuP6GW6nb2FqDL8ryYAL/qa6nELbPVN/EdDjB5t1ZlU03n3T6660IbsPwd/L/ZMRh472KXx0D1XKqIvBJv8t4DI14zTL+ghX2+q69NurMZ83hJplpLAccqQ0trr5u5kxe32GUvuCyY5iO4nh/u5Kge9SgKcvMX1aGMOHxerV0Avt/ZX1WNSkO6PxF4Rju3rYvC7KT9aLCL/9dt/NGoTUHyWdlLrzqa9zfXxbP3L0l9qcp2COeOSBj37kEZiLpMvFqsaBqDTH5FF+dyJKi3Oc4V84E7dFeJDHeHVSLUov/9zbV1sUpuMKteUBFZ/uA1w72zM0r6aYtdFXJ3oA6W3XWRWIfJOurDSVnVgsBH+0SN0iGUdYb6pvA/xVb0koxEzsWkNmSqep9HCLjvXbcJ2UeXoB
 dCpIEpV6
 HfgaDxwy5iGwDCqptSC7TUTaulx8z2UVUeDrq0xcxS8Bw9xr4Ix1xzYP76kZ8dNHlVBeIkqIs0c09M1tx2H8Hx7NFr4oniQZz3foPnDAoEwZTZBmLFpZyMgbg/wM24wwXQa7YoUKqZZM+wqQR8M2b5PjNjbqjFK17qTbMsneuuAzuzfgH25RnmzNjslpNTMGuu1luJjceBJyJ8il87FVgeYAInXCuHc1LEYzRfMd6uIRcqXZbpVclC8QnjjfWWaGzwQhi3dyOkrpJ1SAeo6TUDzDNRg3Qo4/6Zk4Sjve26xvwGTAb829lgE6JJnxKBOe3JdOqA1odVwKkTAcPwWJgz2rfL02Wx49E2I8HhSLFalLNnDky1JpbLeyDu3AtRH5mFsn1DAJY760z2ZZDtFuwIDCTGQ==
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

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601221142.mDWA1ucw-lkp@intel.com/
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


