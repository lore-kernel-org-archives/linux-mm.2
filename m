Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B80FCF6C1B
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 09:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8141D6B0092; Wed,  7 Jan 2026 04:26:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FFF96B00AA; Wed,  7 Jan 2026 04:26:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701EC6B00AB; Wed,  7 Jan 2026 04:26:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 622E66B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:26:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 139FE577C8
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:26:33 +0000 (UTC)
X-FDA: 84304637466.13.5554BA2
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5F4AF140004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:26:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=x6NoTkP2;
	dkim=pass header.d=huawei.com header.s=dkim header.b=x6NoTkP2;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767777991; a=rsa-sha256;
	cv=none;
	b=eaTidb9U7vXMaN3KjHJl3VlUo3Jrwj98USJZpTenJFIrM5P2/p7Du5UYHYYAQU6cUYTbFm
	YlIXRvuirwFxQmeqEmG8Q/prvon5DHd+dgszepqxftI22ipshfvfDbjJ5cd2YJfraUyfr3
	NHKRVTf+597imJ+d2kHQNdbBCIXyAh4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=x6NoTkP2;
	dkim=pass header.d=huawei.com header.s=dkim header.b=x6NoTkP2;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767777991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdA7XvgLoWm60aQUE7Q0jUzx2rLp0cqWsZwG36r5gHk=;
	b=fKhcXLRe+6MTzp7KZU8CH3nt95JxcApoS44wLFwe+fQIw9n0zvyXWf9yNk45V6uGwf8du2
	eLWNf0kwnT/vUKow+UALRhE8dbXogsmLo808uDZMFO00ELUDInhvEee0hdMSfbFb82J5+e
	sRhg0PKfA92m5s4080pG8b6qlCoXNGc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QdA7XvgLoWm60aQUE7Q0jUzx2rLp0cqWsZwG36r5gHk=;
	b=x6NoTkP2vUXNi06Ad8aDcxoarEMnBZrylRz/gspddPAupT76sZQgUF/vFJ0pJsDLOAM0gndVM
	N8hQV04E+dyt61aDKpFkJMngjfrIKjOgK0RNFBoq6vT6WSri87toUQu56cSj2BX3BxnoB81kMcq
	k5ogkGBxUdf2PTg1Y4+g0v0=
Received: from canpmsgout05.his.huawei.com (unknown [172.19.92.145])
	by szxga01-in.huawei.com (SkyGuard) with ESMTPS id 4dmN1N3GSJz1BGFF
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:25:28 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QdA7XvgLoWm60aQUE7Q0jUzx2rLp0cqWsZwG36r5gHk=;
	b=x6NoTkP2vUXNi06Ad8aDcxoarEMnBZrylRz/gspddPAupT76sZQgUF/vFJ0pJsDLOAM0gndVM
	N8hQV04E+dyt61aDKpFkJMngjfrIKjOgK0RNFBoq6vT6WSri87toUQu56cSj2BX3BxnoB81kMcq
	k5ogkGBxUdf2PTg1Y4+g0v0=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dmMyc6zkWz12LFj;
	Wed,  7 Jan 2026 17:23:04 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 463E240538;
	Wed,  7 Jan 2026 17:26:09 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
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
Subject: [PATCH 2/3] selftests/mm: add memory failure clean pagecache test
Date: Wed, 7 Jan 2026 17:37:09 +0800
Message-ID: <20260107093710.3928374-3-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260107093710.3928374-1-linmiaohe@huawei.com>
References: <20260107093710.3928374-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 5F4AF140004
X-Stat-Signature: m8ep4ewr94z1en838u85tc1maf6a6o97
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767777989-409630
X-HE-Meta: U2FsdGVkX1/JVY22ksKRFtjsSqVvdglA7DUKfNDL/CVo9BPBY+44qdw03lviTElLFG6hkCmcg2Z+cQQfJooeABFrzR2idUb61ry0yMkDpwfDYHRu9PDQOCN9AOQGQrZRBTcbylC1nVsmQUvR4e+cHjw5qL3qwR+e3RlZtwzp3BGs505PJpiQUPcOGs0/WlO+ATT7atAYJmLtK2YGxnhjz7T8pkuva2KZb8OXYL0McsFLQ+ZnTGWJuQdY7u9jafMMWIdJjRcT3MfymukZG/Dq/6+vf3CBpJC/Y8l5kj6dW89cLjBs4H327iAzNCP1cA14j9Ja5L4NU5lKXAWXoTkN0tyzwtKDGSsycopbm+oBelukw7HLLtlR5qQdVN78KrPED1UUSgByF3KNGFc3mByEJm3yOR7DBf3GnkNpTHLqfj8wr2VhjXZen0fJqTdyNf3ckI8QHio9yolDji8kM6BouQECh2G6nkx4WuqjvLtlCjnQms9wkQvmBdJjy1CfqCMFpnWMAYaVO/IX4lpNzMDc4dUjx+5DGWCG/ZunDeWqOYRc9+kCAY87Ryv54kS8aVg7ig/EsvURNGn+y/2/dA317HjoQuqRRx0v1RYrO7m1q9D0MI7T16uBX3c3pDy7XGwXmx0VvxpLNsXUisX3Qh8uoJJSqz2cL1E0QJinr3gg3dCG/lNhVOCvwiDcLE1uM4qaiZQdolWFbgyYEZk44UcJWIG7hupqg88z6l/QHInVdUB5HfL5FTY08S+N2VDSC0XbpALdBcbayLAl1m7mv7XZqBDMrbORHTuKbhuouki1d7fjiadSRTu9yZIJJ1Xuu4xH9SOJIKAFj6cj+cH8wxngRgBgc9xS3ODC/Z0jCnmyx1F2aGdCeoPKinQmS28MlZApMzLsIAtEqsW6z0yKDx0SSLcNCRi/6OadMKN1emRLtv1NXgfb8GHJLPYHkHnbmq/3kFCuZEVFgi5torD+xDB
 ilekmdxY
 OZY0cfBEmBUI7BJXzf6tLqfk1Gk341SofwaszdML+NR9KthWfML/qRbXN1i05FOCIIOKsrauxj4GQ8J4mka4tc18ZeYGaYWWOECOR1V/NEJ5DSBzbfxG5IA/7i2jfcf8zPtSBXLFhJwt7mGdwiGpTGfVwTWtsVeZk5oR7o7G7SBd69L2vTdACujjkEFbBVI9clnAmM1O9U+7zJcHX2wwv23KWe5kNrs5bmrqqZqWfz9cI1RezvjLBOoUGdD60eE99WwTdqxEmoXqRyw0w++KI+42n2vbDBCz+Xx5ZRnEdWss/kxIBoLCLQOiOBtzIdsPSvaKdVLvsNqOSusmacielCqGpe/9q2HouaLFH+R2/mz+BoeCzcRdGmJDxCdg3p8z96qyj0bOLsfoPHzESZUE7gtMzzcGTHg3HXIqyXGyCuknXEUolLYgrD5sEim3Q96zHciXDFE+nDYbESryGIO5VZVhYEzvabTmQaZtMIi1WYh4O/koKAVQSJ5hm/Ys20UgfGl7rutnye0AwUPj3grU5s/fEpW60dG21pyiYb4WMhg2yiAM=
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
 tools/testing/selftests/mm/memory-failure.c | 46 +++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 37806a58f4b4..41bc669cef60 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -10,6 +10,7 @@
 #include <sys/mman.h>
 #include <linux/mman.h>
 #include <linux/string.h>
+#include <unistd.h>
 #include <signal.h>
 #include <setjmp.h>
 #include <unistd.h>
@@ -24,7 +25,9 @@ enum inject_type {
 
 enum result_type {
 	MADV_HARD_ANON,
+	MADV_HARD_CLEAN_PAGECACHE,
 	MADV_SOFT_ANON,
+	MADV_SOFT_CLEAN_PAGECACHE,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -154,6 +157,8 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 
 	switch (type) {
 	case MADV_SOFT_ANON:
+	case MADV_HARD_CLEAN_PAGECACHE:
+	case MADV_SOFT_CLEAN_PAGECACHE:
 		/* It is not expected to receive a SIGBUS signal. */
 		ASSERT_EQ(setjmp, 0);
 
@@ -236,4 +241,45 @@ TEST_F(memory_failure, anon)
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 }
 
+TEST_F(memory_failure, clean_pagecache)
+{
+	const char *fname = "./clean-page-cache-test-file";
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = open(fname, O_RDWR | O_CREAT, 0664);
+	if (fd < 0)
+		SKIP(return, "failed to open test file.\n");
+	unlink(fname);
+	ftruncate(fd, self->page_size);
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


