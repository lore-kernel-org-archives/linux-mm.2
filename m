Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AA610F9943
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD836B008C; Wed,  8 Apr 2026 10:55:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999E06B0092; Wed,  8 Apr 2026 10:55:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA936B0093; Wed,  8 Apr 2026 10:55:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7AAF26B008C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:55:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D991B6514
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:55:39 +0000 (UTC)
X-FDA: 84635687598.21.903D84F
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1C6F018000D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:55:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O+dXJxSc;
	spf=pass (imf24.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775660137;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTAJnt8Rzxnihpw2s0R85tzSbsKjYZRdJ/xdTQ6GUWU=;
	b=cVw91Q2eVQaIE0xxxd+fvV1iUqdY9GjbwFdqOBk931DeWL28ArcVUT7qj91JQNobazK2z8
	5vqG14Vz5VCuwUeupGoSUALjzAA5S+9m2RdZr8ywgQxudJAa8/vL5ajatgZ8/2xnV4+j0Y
	5k38JaQBt7hEAOhHGyjnN9v+RURAACA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775660137; a=rsa-sha256;
	cv=none;
	b=PeofnS9w37Zk9hCa5TmyzeOL3juZaMD9C2J5J9sC5oi9JjKd9G3e1Kkha5e1TacWPa9K0D
	lrusxvTWah8RotFNGouYLykOgBsRZE4Ff6eDOFGHYsBCuF4/zY/pXYGJVv3tpy1uOvJPy0
	/wvs/+LQtKsb8A6++zZX9kLOGzNyDwY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O+dXJxSc;
	spf=pass (imf24.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4887eca00c4so42988785e9.2
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 07:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775660136; x=1776264936; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lTAJnt8Rzxnihpw2s0R85tzSbsKjYZRdJ/xdTQ6GUWU=;
        b=O+dXJxScpdwVoRcFSID0/E3vQoUAw31ltHYt9DCCKGhs6XU6dLd+zH0OR2HK6CVnah
         KPhlUgc42E8SamJPH7RkrlPtEX00mS36EyT5dYn1i8JvB4Vojloj4ReMKzSD2XhEa5U0
         NLop6WDxMFc9PmZL5RmTLJUWkLVt3aD66SJpKx8/jUP4f1SGHhzoAFHPB03ru4KPWYgi
         qbUqLBPTeYfwtbV24jolP6zNKLCzmZP97GR0Cx+ETsLIYlbtPQdY22rJe4w/P2/sLeXi
         57IetrJEkOKD18AYVfVZYTRTQ/v5hI9Q3rC/eMoaBH7Z7SFLK9Me5Pn4rWF545TrT+b2
         Covg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775660136; x=1776264936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lTAJnt8Rzxnihpw2s0R85tzSbsKjYZRdJ/xdTQ6GUWU=;
        b=YNQ4kdtP7i6++sW3pS7tKzI4EG7n1T2Xy5cji0xZuAd6xgDDqFUUBPbISoPXWcWlHm
         zwVs95nlHp9ighPlIDRLGK+lKazFeF0NNNszj58KZamwVKYYbxdmNU4tublNXRLqacmM
         hAK9E+3qZuwI3v4Mm8vpddu6kcpaq3amLmGalZppIKo4tu1ki+pc1JxB58ZGkg2GpDuV
         uOQP3jgNRaZRniW2Sncx2dlo5M0DK4rTMfg53goBTe/CFoh5M90sOIOfEgE3vLTjYhbx
         jLLg3oJ2V1twUMwffUyGp3eg0gE9QQwBnqbkQqvKghuoHd99e8s1IDPjfcXMzBUQmtJc
         /h2A==
X-Forwarded-Encrypted: i=1; AJvYcCW0RayMx8B15vXto2joHseuZfkLPBAP0jf+EsZ2UpknoUMpe9653SG8TQBoFXgNt1GALq8WdPqu+Q==@kvack.org
X-Gm-Message-State: AOJu0YxWu3d9JOOySveaDVco9w6OjwwD8Ees06Jsr6bNgphVKWWTe7ag
	9UreIPr5amj3pQOFjNmg0DfJ3nhgZN+Niih1oN/0RuHYoo65SevkZWIy
X-Gm-Gg: AeBDiesnRuttG1pAnniDKxCtR2aIlgfsgooSNCeVblfj8akAeBXbMcBfD3JFPIywUeX
	K2bHmSrKwZq0PAZ8Vi38BZAFcx0/JcqTSARYnjaETQcU8fMW88o9tVFdhiir1RqV7BEDwLXiV1N
	NmYYnQtDIsDS3YwZcYHpWkUwcXMFFZYPhOOy+C1Ck2bUWRIKmU3qz12pCrC9pKYGy02EXk6Pf6m
	GbQR9TfaF0Y90Aa4M7xvoJiOdajQ6KgH/Hj9xTqZ5214uhXpvx1GCPddPsY7yi4cdpasaSWbGnL
	HcuXEd/B1FwCMiVClCe2Jc8CzCApeIC4w0UZHoV/6s45dV6zqxi7eZ8YZCU//kIoPafkiS+hTdZ
	iX95Zn/5VQxJ/tbWLPwDlVLa6/XpcZ+jqYrRv06A/LnMSr0E798wRYN4HrWVK66vJK2tP8LU7ke
	HdKhyh8s52OZID9hanrcdR/2zm
X-Received: by 2002:a05:600c:3b19:b0:486:fab9:a578 with SMTP id 5b1f17b1804b1-4889976af3bmr294382785e9.11.1775660135451;
        Wed, 08 Apr 2026 07:55:35 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b093:bb00::3006])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4f5294sm55762103f8f.35.2026.04.08.07.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 07:55:34 -0700 (PDT)
From: Alban Crequy <alban.crequy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Alban Crequy <alban.crequy@gmail.com>,
	Alban Crequy <albancrequy@microsoft.com>,
	Peter Xu <peterx@redhat.com>,
	Willy Tarreau <w@1wt.eu>,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org
Subject: [PATCH v2 2/2] selftests/mm: add tests for process_vm_readv flags
Date: Wed,  8 Apr 2026 16:54:36 +0200
Message-ID: <20260408145436.843538-3-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260408145436.843538-1-alban.crequy@gmail.com>
References: <20260408145436.843538-1-alban.crequy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1C6F018000D
X-Stat-Signature: uu6y1sr5rsf7rpf85k498hr1b9gwrxui
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775660136-964408
X-HE-Meta: U2FsdGVkX19feI8YoNsQbtHwHc5Fwgtiml82XSzGXrLxqKGh4J5DVJUEAZzeR+eemywKP9HdccxjR4RTlTShxOf1m9RTi5y9wxsQJRlo7loVGf8IP6QIg4pmORQlbdExkHD3P0q3q6QcC3tyEwHxc01BXpKxYe/UbRNHMaNu8W3c+djZ8UH4w1lEzxTByWu8iW5Iy136nQGiya+gGVAbhTEaZ7nZSPaFFxUgWjvBWGTvoDPxcbMj1iVz5ZYoyyIJa8XDrApMeMFcZyBfSnGGNrActJ+JGp3HfViytxVOgNSwj3nC5tzdivYeFc6vGJICpbmbvv3sk2l0074TZ+Wa2apakP7aHeyBK0+wqhAUJ1tnYAnfjJyNd3CbhKn10O3tTtIr7Gp+jO/zFvVSq20Tr5Fw3DR3IxnQZg4CSN7y9TT0JBn4P7ATV7vfMNtO4f5cYn+vGbswvlSp8TtOeXXXMdD6gYZjYIjSi2IN+BdqiovDU0CWGXjr3a25ISDKDii38xhZKPBgImNW+rsLbaqQOn0S5C7PO33kXR1HYbMudhbzkAhgWW1jz/yIpnF8oxlyGqj62xvQEoHI3JUQHeQy8vtAxNEjS0kWSleCHAVLfvB4GFD9M90z47rtFZqJlXhDNstOvUQ5/u3cQ6IIua8hk4KdPQdslbfdrDXoAO2ongM7z0g9X4FjZ6wT9XO4yTwgwhW2/668vRq76i8QPKYPg+7pOU5ji3z1sBBt0OOG6eKA54/QyOqsG5T/eGAAV/rRWUP+QqcN+IsENARXZXV1l6Qiyu1yfW9efwNsfJzkFe+SRv0UrnVb41O6x4oEabjVPLH8n2n3BXSawiIBb7ybAUZvHxVcV8KPd9tip4BzuS1whk4Y2DiclKqgWijpkUQTIoAu7AYNKIhAqOJXi1W80wslI9o+88w5iMUMZqqdBtNb7KUlhfsmXY4ISzeff9/m+EMTPqGX50/GkX99ELw
 U/muQV7u
 SBJh9vtm3az3KKCX6yIfsapOJKXdwZmRDLYurbiM9cZO4PTGw20svL01bpomL5D+68xgwh7Qx6YlHB+3DOGIvSA/J2INO9BAfWEM/2EHAwIdrGOKFEncYiblpZ2c7IMp3YQb65yWXZ1KCfrZyNL6oJGR8KNTOz6fedJvzouixRjrBPeQT9DYJ0xkJqUE8cETTDpo30f/Ikqih1+IXk9XVcdn9Qw5p7NZIQPKH1h06lbLNT+yC9dYe0T71Ws/xMVcDuHpoAFLmsLcWlxdiQCsCCH3o5yYSXYoLcc54LNqPWATS/eH6jBREULuzBk2BfM5AQkF6dOepVMbmVSC6z33cFIle40bZpq+JX+TKMBFxWR/z0JWdR+zXWBcuUu8wShnX+lIlEo4oenNbxLadk+LS3SJCDGohakKKGfIU6gunwmOASG+hljEaalvIIkyrKVxXGXA9i33fJdAFP7GKzx7LLIDbWAuA9fgPS7Yb+Igl8pxNfdo/T2lAH/5udTEYu8pGYtFjjJSu4Z3EQ9v/fAM9sbVxw8VmcJTfT7ww43/j1Tq30iPSXl2J91ZL4MtZBYiTe1rd2DaHYqBXihxsd3DOjzReAIpMnM4DE+BIvO1LEh/1a+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alban Crequy <albancrequy@microsoft.com>

Add selftests for the PROCESS_VM_PIDFD and PROCESS_VM_NOWAIT flags
introduced in process_vm_readv/writev.

Tests cover:
- basic read with no flags
- invalid flags (EINVAL)
- invalid address (EFAULT)
- flag validation precedence over address validation
- PROCESS_VM_PIDFD: read via pidfd
- PROCESS_VM_NOWAIT: read from resident memory
- PROCESS_VM_PIDFD | PROCESS_VM_NOWAIT combined
- userfaultfd blocking read (no flags)
- PROCESS_VM_NOWAIT with userfaultfd (non-blocking, returns EFAULT)

Signed-off-by: Alban Crequy <albancrequy@microsoft.com>
---
New in v2.

 tools/testing/selftests/mm/Makefile           |   1 +
 tools/testing/selftests/mm/process_vm_readv.c | 368 ++++++++++++++++++
 2 files changed, 369 insertions(+)
 create mode 100644 tools/testing/selftests/mm/process_vm_readv.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 7a5de4e9bf52..056d9d961f6b 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_FILES += droppable
 TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
+TEST_GEN_FILES += process_vm_readv
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/process_vm_readv.c b/tools/testing/selftests/mm/process_vm_readv.c
new file mode 100644
index 000000000000..cc25471410b5
--- /dev/null
+++ b/tools/testing/selftests/mm/process_vm_readv.c
@@ -0,0 +1,368 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <poll.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <sys/uio.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <linux/userfaultfd.h>
+
+#include "kselftest_harness.h"
+
+#ifndef PROCESS_VM_PIDFD
+#define PROCESS_VM_PIDFD	(1UL << 0)
+#endif
+
+#ifndef PROCESS_VM_NOWAIT
+#define PROCESS_VM_NOWAIT	(1UL << 1)
+#endif
+
+#ifndef __NR_pidfd_open
+#define __NR_pidfd_open 434
+#endif
+
+static int sys_pidfd_open(pid_t pid, unsigned int flags)
+{
+	return syscall(__NR_pidfd_open, pid, flags);
+}
+
+static const uint8_t test_data[] = { 0x01, 0x02, 0x03, 0x04,
+				     0x05, 0x06, 0x07, 0x08 };
+#define POISON_BYTE 0xCC
+
+/*
+ * Test: basic process_vm_readv with no flags
+ */
+TEST(read_basic)
+{
+	uint8_t buf[sizeof(test_data)];
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = {
+		.iov_base = (void *)test_data,
+		.iov_len = sizeof(test_data)
+	};
+	ssize_t n;
+
+	memset(buf, POISON_BYTE, sizeof(buf));
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1, 0);
+	ASSERT_EQ(sizeof(test_data), n);
+	ASSERT_EQ(0, memcmp(buf, test_data, sizeof(test_data)));
+}
+
+/*
+ * Test: invalid flags should return EINVAL
+ */
+TEST(read_invalid_flags)
+{
+	uint8_t buf[8] = { 0 };
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = {
+		.iov_base = (void *)test_data,
+		.iov_len = sizeof(test_data)
+	};
+	ssize_t n;
+
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1, 255);
+	ASSERT_EQ(-1, n);
+	ASSERT_EQ(EINVAL, errno);
+}
+
+/*
+ * Test: invalid address should return EFAULT
+ */
+TEST(read_invalid_address)
+{
+	uint8_t buf[8] = { 0 };
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = { .iov_base = NULL, .iov_len = 8 };
+	ssize_t n;
+
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1, 0);
+	ASSERT_EQ(-1, n);
+	ASSERT_EQ(EFAULT, errno);
+}
+
+/*
+ * Test: invalid address with invalid flags should return EINVAL
+ * (flag check happens before address validation)
+ */
+TEST(read_invalid_address_invalid_flags)
+{
+	uint8_t buf[8] = { 0 };
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = { .iov_base = NULL, .iov_len = 8 };
+	ssize_t n;
+
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1, 255);
+	ASSERT_EQ(-1, n);
+	ASSERT_EQ(EINVAL, errno);
+}
+
+/*
+ * Test: invalid address with all valid flags should return EFAULT
+ * (flags are valid so we get past the flag check to the address check)
+ */
+TEST(read_invalid_address_all_valid_flags)
+{
+	int pidfd;
+	struct iovec local_iov = { .iov_base = NULL, .iov_len = 8 };
+	struct iovec remote_iov = { .iov_base = NULL, .iov_len = 8 };
+	ssize_t n;
+
+	pidfd = sys_pidfd_open(getpid(), 0);
+	ASSERT_GE(pidfd, 0);
+
+	n = process_vm_readv(pidfd, &local_iov, 1, &remote_iov, 1,
+			     PROCESS_VM_PIDFD | PROCESS_VM_NOWAIT);
+	ASSERT_EQ(-1, n);
+	ASSERT_EQ(EFAULT, errno);
+
+	close(pidfd);
+}
+
+/*
+ * Test: read with PIDFD flag
+ */
+TEST(read_pidfd)
+{
+	uint8_t buf[sizeof(test_data)];
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = {
+		.iov_base = (void *)test_data,
+		.iov_len = sizeof(test_data)
+	};
+	ssize_t n;
+	int pidfd;
+
+	memset(buf, POISON_BYTE, sizeof(buf));
+	pidfd = sys_pidfd_open(getpid(), 0);
+	ASSERT_GE(pidfd, 0);
+
+	n = process_vm_readv(pidfd, &local_iov, 1, &remote_iov, 1,
+			     PROCESS_VM_PIDFD);
+	ASSERT_EQ(sizeof(test_data), n);
+	ASSERT_EQ(0, memcmp(buf, test_data, sizeof(test_data)));
+
+	close(pidfd);
+}
+
+/*
+ * Test: read with NOWAIT from resident memory (should succeed)
+ */
+TEST(read_nowait_resident)
+{
+	uint8_t buf[sizeof(test_data)];
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = {
+		.iov_base = (void *)test_data,
+		.iov_len = sizeof(test_data)
+	};
+	ssize_t n;
+
+	memset(buf, POISON_BYTE, sizeof(buf));
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1,
+			     PROCESS_VM_NOWAIT);
+	ASSERT_EQ(sizeof(test_data), n);
+	ASSERT_EQ(0, memcmp(buf, test_data, sizeof(test_data)));
+}
+
+/*
+ * Test: read with PIDFD + NOWAIT from resident memory
+ */
+TEST(read_pidfd_nowait_resident)
+{
+	uint8_t buf[sizeof(test_data)];
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov = {
+		.iov_base = (void *)test_data,
+		.iov_len = sizeof(test_data)
+	};
+	ssize_t n;
+	int pidfd;
+
+	memset(buf, POISON_BYTE, sizeof(buf));
+	pidfd = sys_pidfd_open(getpid(), 0);
+	ASSERT_GE(pidfd, 0);
+
+	n = process_vm_readv(pidfd, &local_iov, 1, &remote_iov, 1,
+			     PROCESS_VM_PIDFD | PROCESS_VM_NOWAIT);
+	ASSERT_EQ(sizeof(test_data), n);
+	ASSERT_EQ(0, memcmp(buf, test_data, sizeof(test_data)));
+
+	close(pidfd);
+}
+
+/*
+ * Userfaultfd helpers for NOWAIT tests
+ */
+static int setup_userfaultfd(void)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	int uffd;
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (uffd < 0)
+		return -1;
+
+	if (ioctl(uffd, UFFDIO_API, &api)) {
+		close(uffd);
+		return -1;
+	}
+
+	return uffd;
+}
+
+static void *register_uffd_region(int uffd, size_t size)
+{
+	struct uffdio_register reg;
+	void *mem;
+
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		return NULL;
+
+	reg.range.start = (unsigned long)mem;
+	reg.range.len = size;
+	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
+	if (ioctl(uffd, UFFDIO_REGISTER, &reg)) {
+		munmap(mem, size);
+		return NULL;
+	}
+
+	return mem;
+}
+
+struct uffd_handler_args {
+	int uffd;
+	const void *content;
+	size_t content_len;
+};
+
+static void *uffd_handler_thread(void *arg)
+{
+	struct uffd_handler_args *ha = arg;
+	struct uffd_msg msg;
+	struct uffdio_copy copy;
+	struct pollfd pfd = {
+		.fd = ha->uffd,
+		.events = POLLIN
+	};
+	void *page;
+	long page_size = sysconf(_SC_PAGESIZE);
+	int ret;
+
+	page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (page == MAP_FAILED)
+		return (void *)(long)-ENOMEM;
+
+	memcpy(page, ha->content, ha->content_len);
+
+	ret = poll(&pfd, 1, 5000);
+	if (ret <= 0)
+		goto out;
+
+	if (read(ha->uffd, &msg, sizeof(msg)) != sizeof(msg))
+		goto out;
+
+	if (msg.event != UFFD_EVENT_PAGEFAULT)
+		goto out;
+
+	copy.dst = msg.arg.pagefault.address & ~(page_size - 1);
+	copy.src = (unsigned long)page;
+	copy.len = page_size;
+	copy.mode = 0;
+	ioctl(ha->uffd, UFFDIO_COPY, &copy);
+
+out:
+	munmap(page, page_size);
+	return NULL;
+}
+
+/*
+ * Test: read from userfaultfd-registered memory (no flags, should block
+ * until page fault is resolved by handler thread)
+ */
+TEST(read_userfaultfd_blocking)
+{
+	int uffd;
+	void *mem;
+	long page_size = sysconf(_SC_PAGESIZE);
+	uint8_t buf[sizeof(test_data)];
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov;
+	struct uffd_handler_args ha;
+	pthread_t handler;
+	ssize_t n;
+
+	memset(buf, POISON_BYTE, sizeof(buf));
+
+	uffd = setup_userfaultfd();
+	ASSERT_GE(uffd, 0);
+
+	mem = register_uffd_region(uffd, page_size);
+	ASSERT_NE(NULL, mem);
+
+	ha.uffd = uffd;
+	ha.content = test_data;
+	ha.content_len = sizeof(test_data);
+	ASSERT_EQ(0, pthread_create(&handler, NULL, uffd_handler_thread, &ha));
+
+	remote_iov.iov_base = mem;
+	remote_iov.iov_len = sizeof(test_data);
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1, 0);
+	ASSERT_EQ(sizeof(test_data), n);
+	ASSERT_EQ(0, memcmp(buf, test_data, sizeof(test_data)));
+
+	pthread_join(handler, NULL);
+	munmap(mem, page_size);
+	close(uffd);
+}
+
+/*
+ * Test: read with NOWAIT from userfaultfd-registered memory that has
+ * not been faulted in yet. Should return EFAULT (not block).
+ */
+TEST(read_nowait_userfaultfd)
+{
+	int uffd;
+	void *mem;
+	long page_size = sysconf(_SC_PAGESIZE);
+	uint8_t buf[sizeof(test_data)] = { 0 };
+	struct iovec local_iov = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct iovec remote_iov;
+	ssize_t n;
+
+	uffd = setup_userfaultfd();
+	ASSERT_GE(uffd, 0);
+
+	mem = register_uffd_region(uffd, page_size);
+	ASSERT_NE(NULL, mem);
+
+	/* Ensure the page is not present */
+	madvise(mem, page_size, MADV_DONTNEED);
+
+	remote_iov.iov_base = mem;
+	remote_iov.iov_len = sizeof(test_data);
+	n = process_vm_readv(getpid(), &local_iov, 1, &remote_iov, 1,
+			     PROCESS_VM_NOWAIT);
+	ASSERT_EQ(-1, n);
+	ASSERT_EQ(EFAULT, errno);
+
+	munmap(mem, page_size);
+	close(uffd);
+}
+
+TEST_HARNESS_MAIN
-- 
2.45.0


