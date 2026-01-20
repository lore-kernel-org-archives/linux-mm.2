Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B46FD2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 12:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A68B6B03DB; Tue, 20 Jan 2026 07:22:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F374A6B03D9; Tue, 20 Jan 2026 07:22:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69E66B03DA; Tue, 20 Jan 2026 07:22:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE3816B03D7
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:22:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CDAF1AF32D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:22:00 +0000 (UTC)
X-FDA: 84352254000.01.C039BCA
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf05.hostedemail.com (Postfix) with ESMTP id E0CF410000C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:21:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZkOIGNta;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768911718; a=rsa-sha256;
	cv=none;
	b=59RbXUXcdCoHXzeuhKRAW5WosvIcI5nZzP1vrsszTYVlpb7fhjfKVo3J8MQn414otoPgrA
	0k/sDwizgkgKWhIdCHCHq8NEEAOigJrDhln0pNwaj8r7Q2ii907jV9tjpQGZZmgLVBCJXN
	oZXlpiFhhPehlwbOCeKjAHKsgSTj/yY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZkOIGNta;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768911718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XN5AlAlhJg9JIFTM4XSCb0KoyacQhShFHnroCAR8iys=;
	b=IrsB78NlhOirTH8WGaboyswvHz18HEVFoN5cjAQI9g/gqtLGyagiMbKeG3Hw4ylhkgT8kY
	drNwnZ6pNswpbmqcpJeGbAfAc/eG3Iv40tKU8EZQGEk4dPahaFgiZLnKiacfcidsv4gXoH
	DZlQpyrfSLQebI2L2ZIrqWND/N5Hj1E=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XN5AlAlhJg9JIFTM4XSCb0KoyacQhShFHnroCAR8iys=;
	b=ZkOIGNtaBI3w1qyeubmh483u17JXwZ1FjOPx6UdjLrjnXD4lyZxmMvTYJWdhdqKw7y6zfy0Ee
	raRNtnX7p1Dptc9oZduEyC0Be0Q443XWmk2DFH/RFqI+1IVD/8QtREQUFEPiOEJYm8nyVxs/Im2
	KEAUEE/iWoxvj2mC/9dW4QY=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dwRF13J6Tz1prL6;
	Tue, 20 Jan 2026 20:18:29 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id AAD1120104;
	Tue, 20 Jan 2026 20:21:54 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Jan 2026 20:21:54 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 20 Jan
 2026 20:21:53 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<linmiaohe@huawei.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v2 3/3] selftests/mm: add memory failure dirty pagecache test
Date: Tue, 20 Jan 2026 20:32:39 +0800
Message-ID: <20260120123239.909882-4-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260120123239.909882-1-linmiaohe@huawei.com>
References: <20260120123239.909882-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E0CF410000C
X-Stat-Signature: dybbn7sfdyz8jn64h8ibk8hd1pao95mm
X-Rspam-User: 
X-HE-Tag: 1768911717-225170
X-HE-Meta: U2FsdGVkX1/z/Lx7F90pm51KiVjV5/6G0LpCfzkds9YALlm0TyVpaL0KCNR6BNPh3KO9wE6nfJkybJWQLOS62DroRp2nkKvvN6gSAJwN3t+YmnyJ5eP3fwcQwlrdFaZAhQemz5EaFmMfRvtkeiZz7ZxoD87XpUl+6aQ1/eRmD/G7+R0CS8m/bj6C7NiXprBNPpY4bTqA3xfaa902wCnSfOUgY2V8Lqn1sB+rHMMYDoNIEZpA9E8174F7JMHtt/OHfF+QEcmGcE9kmOjKsQsv3LFb3jg7C06XrTZbtTuSLAOLKGw8PA6KhvHXMyaU/NhjSV1zP/yUKKnxN/2BWrBvx4XYb3TNCcUScmLGJXGSHd2ffl8tjmhFETiap4aG1xFwGiDhcpbCGfxaZ3WR/x+gj4kWHSJQX6J74IGM8BNnGUVQF9mpJpsARU0wQYWN+8jRavmB10p1uS9eakpzrHWckHYsnbSfqribfFNzIOzdAd0Iz9cl42/RD4Rip/LTz6WVT+RKMg2BJtr88iqGMgutkXPxrmrphIG1FC4ZBV9E+X2GGgZl7fZCvR+R8LOecgzu5ncgBd0IhqVdyd1vz8L1k9r85DXAKg5HuBBBYixIZi1TpykikaEr4HP9R5imePp0lF7DIbJpaEQ3KYCXS8X1BrrCQmSoRHw8cNaU3f+axDK95UscNlHlkxRHL2oywH/bckx+y+9bllfwz2nBHWI3ZfhN3IBO4iZ2s5t89/ywOWxrtk2GhXveopNeds70PKy5jJBWlP0CkFNG123ryCH/4bP3F/fMpnlANfFwQ/tg182yLOv7lnms2AhuchsLOp0pmlD4PSuxbX3FjiYum9L2netqxdxm8sN1OUxqDyjBBpdxKz+Fuhgn4XvseDTkzKMtnJyKB8TCjdjJVEgG1Wpt9voy0vD5FheK1jffMuq/V4Y2xVvFLlbCXppNwvg4hIHq8qPN5lYvG1O+xFQMbzY
 KXLSHUkq
 2etNZ/e20I0/CJ3P5f7bUFwme5r/p/v6fs29yHg5ZxxSVutqMlHXU3YSYXI7kyBXogUrzLeyFtTdrUQEKAOtconBjhI6x+uq3g2EkAPOR1tNeOHPp3vU4z4X+LR9XInjeLfA6XlqJvarpD4Ei8XL9UPuAlilt4k2U7/LCjmCgdCfaNWpuJC9EjK3yntnwpJyWiWmVonIBm8ORCMLjnbTdYxFTDn7H8b8iIqmJ2L7PEhhzA8uDqAqNW32KSzcOiRS5eRIZzBkbHaGE1ENu0YKjKsCbhr2MP46C3WqifKBUsSgEEF/i2si6aCFDo0B9420L+vdG8fcp+9cjNIDOq+8NY0nX81fit81E2muuat4fJ1MdqNI=
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
index 128c2ee6d332..a74a057599b4 100644
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
 static __fsword_t get_fs_type(int fd)
 {
@@ -259,17 +275,14 @@ static __fsword_t get_fs_type(int fd)
 
 TEST_F(memory_failure, clean_pagecache)
 {
-	const char *fname = "./clean-page-cache-test-file";
 	int fd;
 	char *addr;
 	int ret;
 	__fsword_t fs_type;
 
-	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	fd = prepare_file("./clean-page-cache-test-file", self->page_size);
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
-	unlink(fname);
-	ftruncate(fd, self->page_size);
 	fs_type = get_fs_type(fd);
 	if (!fs_type || fs_type == TMPFS_MAGIC)
 		SKIP(return, "unsupported filesystem :%lx\n", fs_type);
@@ -302,4 +315,45 @@ TEST_F(memory_failure, clean_pagecache)
 	ASSERT_EQ(close(fd), 0);
 }
 
+TEST_F(memory_failure, dirty_pagecache)
+{
+	int fd;
+	char *addr;
+	int ret;
+	__fsword_t fs_type;
+
+	fd = prepare_file("./dirty-page-cache-test-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test file.\n");
+	fs_type = get_fs_type(fd);
+	if (!fs_type || fs_type == TMPFS_MAGIC)
+		SKIP(return, "unsupported filesystem :%lx\n", fs_type);
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


