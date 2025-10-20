Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C94CCD184
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 03:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9501F8E000C; Sun, 19 Oct 2025 23:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900A38E0002; Sun, 19 Oct 2025 23:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1E38E000C; Sun, 19 Oct 2025 23:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65B508E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 23:17:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFACCC06D3
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:17:39 +0000 (UTC)
X-FDA: 84017032638.23.089978E
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1FE6740003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:17:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cSAQ6E8n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760930258; a=rsa-sha256;
	cv=none;
	b=l3n4SeyIidIfknQ+WJYtIrUfwOlHA3UQVNFspsLOQMwrmzEDC2YJ6Cgr4OKKX/Me8Qnbzy
	fpwQBnERx2ATPWiZ+ccEqNT67Zuz/dAd7Kxd/7nl8dz8pbtpaBKK4IrO6Ek60knq3OuBz6
	213+Y5aDaFL+kWrJ62RgixIpCoNl/Yg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cSAQ6E8n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760930258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODPaRNudblRqFy9JUc368eS/DdFyEosuZnJ/nJRki7o=;
	b=uvruWs75Dp9+keupBL9976vh8qX+b04gqnbVTTdQUKXb8Omv+5rWkKS0sDGAzgLA6H8Qva
	0Rem0cDkgt9ZKTdn98LcfJrWUaLKt3NqWRmXtynAC2r4ee5TwB9d25leUCNVt2xso1Ot50
	jG/yJPZ4ISZ0ZzsZfortcHlcJ7ZcJZM=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-290dc630a07so17496165ad.1
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760930257; x=1761535057; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODPaRNudblRqFy9JUc368eS/DdFyEosuZnJ/nJRki7o=;
        b=cSAQ6E8n0jb0Q6b4z2RfF6gPr77hGQZomKg6ahcYZbc1syYnxSg8+urxI/BptW+NZH
         L1B/q/7/Xv67krP4YtFCb+Q6aXBeYDiEPCXsdcV5Vp1WeLaFRUvf4jJ/GhjssArOPuI1
         MIAbKHtn9a1GE0qbaZDxYglkD8iydK8KssejeSWotNlp7CbE22kPWaIn8AyC3H+wFMCU
         bqmLI2JTMtZ/YCtNPMBqhY/woXJXJ+ls3yeUljVHqAWCsXRE33QLz6xMxSjtQ705x1Ij
         ElBSNzCXAG2cjl5/fp4kxjPN2nlYeNRKRRtquPTJT3SPyReFDvcTZy45G8IVQFm6VmNz
         eJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760930257; x=1761535057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ODPaRNudblRqFy9JUc368eS/DdFyEosuZnJ/nJRki7o=;
        b=ajUFSunWtyL4qoZTRROzhTHcO+sWmw+RaHoy7qfW/mP1lsaBIs+H3nEVXkF7Q9gl1x
         SmTPNb8RoBJ3w7yqNS3TT7j5/ZeRfbF2wB9pDTWrlt7rNWA31O+hEu7FBr6AGtycebL2
         RVBEdHybVRJCnNmj12uYfqjBBeNKjtMvBnxidTwz0rKi/02m86LaC3le2yyNCmrkk2h/
         latvohF3cuwvdbF9nJIzBGOPZoexQujDk6N4ijIXzPMblN4axJ2NbKRUd1Ac0w0zsoi/
         mwmrJC42aMfiOMDuwqytpVms3LrrKUxB9rOD7RoqUPKeBzXCwYYl4ReEBDkPxiLFSHeh
         8CaA==
X-Forwarded-Encrypted: i=1; AJvYcCUHG56ctqVZgIgSz5JP/dsNY5PZI6aC9NECC4Zj2t8j74PEKGzl+DyNdo1hGACJ1JOQcci7ZDOaGg==@kvack.org
X-Gm-Message-State: AOJu0YwD8OO+Dm/XvEXkNtylWuSYfK5P2BcYJSasfO4rtveVKCJqTOOR
	E2ixgMAMwUP6uZTlOlu66XXvNYuWQ7fFL+/0o4PqZc9W22VgbfAFfs8/
X-Gm-Gg: ASbGncst9vouvNkd7Tr5dFaFBc0kjfSJrZm8HCdG+mYCzN2wT15YHSsLRxOcnVhc5HN
	ra7vqydM97LfLRnYb9HPPIG0lO5/L+hgPTXvJC+WBVAM7hFApT//wvWPBEnGLa8HqYVQmCF5ypw
	NWe3CJ2fqVOL0VUthZvUXhHvhtg2tbVYsU0HgtQUHBvs6DGFWpACe2fJbzEPh24LojYRwQDRmbg
	ZEIS4n4hFrSoa0TR1/2nFYEEStj2eDMqGYgq2uzxKygGTH+B7jaAfb32tZyCzEl5CtQ4i7bK0Gf
	pGagh2+l4ODuksrdXz54xN4NjvwZ95RNRfClrC/CUwARaAESA/OnqeF4+KbmeMEOaCpp2SvS6pe
	LZ0UxKPAol6R5YqHZIw42C/Hf2g/qmzy3dlLTsKFx7uaUFwYF4hyOhnPH8Uf1OHk6jVoUNSQ+CK
	p6SqiRPte/CwMPmYqUDsOa4Q7hQetkw90vzkJgjuJlEy995g==
X-Google-Smtp-Source: AGHT+IGOBjp3trHQon1RiKTkHvnyhNWFPxll3OTbBEoNjqhhZpOKT8ELp9LCl0TFv0EiwWwI1kAdeg==
X-Received: by 2002:a17:902:db09:b0:290:a3ba:1a8a with SMTP id d9443c01a7336-290ccac6d3cmr145711245ad.53.1760930256915;
        Sun, 19 Oct 2025 20:17:36 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1da1:a41d:3815:5989:6e28:9b6d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471fddfesm66373435ad.88.2025.10.19.20.17.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 20:17:36 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	david@redhat.com,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v11 mm-new 08/10] selftests/bpf: add a simple BPF based THP policy
Date: Mon, 20 Oct 2025 11:16:53 +0800
Message-Id: <20251020031655.1093-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251020031655.1093-1-laoar.shao@gmail.com>
References: <20251020031655.1093-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kfz5hrbib8k1etf4ok6pm1s5wm3u4oey
X-Rspamd-Queue-Id: 1FE6740003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760930257-296680
X-HE-Meta: U2FsdGVkX1+qUsbVl23U0pQ3JmlVtHZ8yAM5FeExeeDewGUTrhjtsqdGrWH94yDT980ajBvjlGzudkKdP8cm6mIRt/5sSO+r0Wh+Le29A4gcSBHbptHXMJKlZM0HW+VMkAm2+TIgMS4VABLvrVWzP8LMBkM2eRK9gWak+getK7EOspZdIE9qx97WfV9aGHBJtoHZss8gzP2bK+ZBHPT0DyDdaIEKq5J89ycshPCaBEIXDltrwkk9kIMaNf7R0G2dATAhBs+Jl+gcbchl69o+FfQwiAhFafXpuBhaMoEW1ooYNeooS3YCLux82RJnqEBXgSV5gog212/fDHewY8qtI3ZoWNpeUIzbG/QCcsE5iK/mfnB4XEa21XbS6z14Wgj6mHJA9XIuUflx/oyHIkUhpKcTo8N0Z/vkY8fe2heODI3BkFnCsHHXxJm07QpQc1ExoQjqhr+1pF4tVhf1SpkTOT0IXEqbnXdKCkTMo6ij91f0OB8fSpnkcqjhbAwp7Xxq9hR691BERlmzh647oUwAd2n8WikiYz/Ak81/NEvWiKudvhMfBsTm8RNrgngkLXnH9vUD1FZpwTljkYXf7CQMarRQhjTdtqrM9YgaQ2ePOIF+1pqEiHwxK3oNSz0IwAut/A4tlhsq4h581ZN39gjMQSmO146of0c1avYRDEowcNlR5nqNuEZ3/du6Ih8FHaJfpu8st3oFAHIPYhyOmur9SXHdNpZ1t/b4+yxXWzeauV41eKUpvE3wH7qwxa9XpQ5PZvOM5kkqzkd9ofbUUVNQcfQhFNQzzvwNV5HUqWrKf2tFRsvhx1NXLNfLyEq1b4qv917/5DKbmMtV92g2o9xClB+Nmu45ELrFOl1QtLAO0VRM2jT8El1N9h8mLodJ8LC9CBLsvTp1YHxSP+J6DjBKH5LOABp0AFCtOHcpWGozeyRrUQfkX5ZZ8jMfenRrmL7H4O+FkJN/xNGM0SYyGGO
 E9KKBiwc
 Gsi5iw2nRDiI0saxmJrbwttWFgOMb6zUzdJJNeBqpY980rEE02WKmDK2M0wwphafEGRice0ZhbSEHFU91GTqZuxmzTACS0BcubFny7XDYcMbHXY3e+0fvzGsAm7gZfkMAtY5ZZAsT+5yEo3AgVuKwvXCTfaPmch1E3eJdyLqwX/ItJQbC3GIHItZV2rRsEdEQx5iSscfD0Z8b/+vFhDmyUd74mXj3BhIH6s0Woq+n8k6j46uZo3OSQo+MQ+dtoooEX+vmf2oDC5iNXd1cTepdlLacvyZTEV3uxY0OhMXiK5L4emPArflbG7uQCbQqJXsRAokBg4ZqAWv3HSAVh3Kt5MJfIQPtgzdIwnuM4o0L4Sgq57MObnoPQqYmmUPhGxmOs/v4fnvDlEhWJXtRg0e8/SKvEjdHhlcDOBafS+Mq9LugrIE6MXwJcvFbq/229qsyzTgxBt9B4B60HWT5UgCfh8DxgSRKG3YrQynHLELgTgVYn3GT45JUbWhHkBUO4Agd/9vqwnxbcJ1VJr0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test case implements a basic THP policy that sets THPeligible to 0 for
a specific task. I selected THPeligible for verification because its
straightforward nature makes it ideal for validating the BPF THP policy
functionality.

Below configs must be enabled for this test:

  CONFIG_BPF_MM=y
  CONFIG_BPF_THP=y
  CONFIG_TRANSPARENT_HUGEPAGE=y

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 MAINTAINERS                                   |   2 +
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 245 ++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     |  24 ++
 4 files changed, 274 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 50faf3860a13..7febdd8b17b3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16523,6 +16523,8 @@ F:	mm/huge_memory.c
 F:	mm/huge_memory_bpf.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
+F:	tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+F:	tools/testing/selftests/bpf/progs/test_thp_adjust*
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 70b28c1e653e..8e57c449173b 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -7,8 +7,10 @@ CONFIG_BPF_JIT=y
 CONFIG_BPF_KPROBE_OVERRIDE=y
 CONFIG_BPF_LIRC_MODE2=y
 CONFIG_BPF_LSM=y
+CONFIG_BPF_MM=y
 CONFIG_BPF_STREAM_PARSER=y
 CONFIG_BPF_SYSCALL=y
+CONFIG_BPF_THP=y
 # CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
 CONFIG_CGROUP_BPF=y
 CONFIG_CRYPTO_HMAC=y
@@ -115,6 +117,7 @@ CONFIG_SECURITY=y
 CONFIG_SECURITYFS=y
 CONFIG_SYN_COOKIES=y
 CONFIG_TEST_BPF=m
+CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_UDMABUF=y
 CONFIG_USERFAULTFD=y
 CONFIG_VSOCKETS=y
diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
new file mode 100644
index 000000000000..2b23e2d08092
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -0,0 +1,245 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <sys/mman.h>
+#include <test_progs.h>
+#include "test_thp_adjust.skel.h"
+
+#define LEN (16 * 1024 * 1024) /* 16MB */
+#define THP_ENABLED_FILE "/sys/kernel/mm/transparent_hugepage/enabled"
+#define PMD_SIZE_FILE "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
+
+static struct test_thp_adjust *skel;
+static char old_mode[32];
+static long pagesize;
+
+static int thp_mode_save(void)
+{
+	const char *start, *end;
+	char buf[128];
+	int fd, err;
+	size_t len;
+
+	fd = open(THP_ENABLED_FILE, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	err = read(fd, buf, sizeof(buf) - 1);
+	if (err == -1)
+		goto close;
+
+	start = strchr(buf, '[');
+	end = start ? strchr(start, ']') : NULL;
+	if (!start || !end || end <= start) {
+		err = -1;
+		goto close;
+	}
+
+	len = end - start - 1;
+	if (len >= sizeof(old_mode))
+		len = sizeof(old_mode) - 1;
+	strncpy(old_mode, start + 1, len);
+	old_mode[len] = '\0';
+
+close:
+	close(fd);
+	return err;
+}
+
+static int thp_mode_set(const char *desired_mode)
+{
+	int fd, err;
+
+	fd = open(THP_ENABLED_FILE, O_RDWR);
+	if (fd == -1)
+		return -1;
+
+	err = write(fd, desired_mode, strlen(desired_mode));
+	close(fd);
+	return err;
+}
+
+static int thp_mode_reset(void)
+{
+	int fd, err;
+
+	fd = open(THP_ENABLED_FILE, O_WRONLY);
+	if (fd == -1)
+		return -1;
+
+	err = write(fd, old_mode, strlen(old_mode));
+	close(fd);
+	return err;
+}
+
+static char *thp_alloc(void)
+{
+	char *addr;
+	int err, i;
+
+	addr = mmap(NULL, LEN, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (addr == MAP_FAILED)
+		return NULL;
+
+	err = madvise(addr, LEN, MADV_HUGEPAGE);
+	if (err == -1)
+		goto unmap;
+
+	/* Accessing a single byte within a page is sufficient to trigger a page fault. */
+	for (i = 0; i < LEN; i += pagesize)
+		addr[i] = 1;
+	return addr;
+
+unmap:
+	munmap(addr, LEN);
+	return NULL;
+}
+
+static void thp_free(char *ptr)
+{
+	munmap(ptr, LEN);
+}
+
+static int get_pmd_order(void)
+{
+	ssize_t bytes_read, size;
+	int fd, order, ret = -1;
+	char buf[64], *endptr;
+
+	fd = open(PMD_SIZE_FILE, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	bytes_read = read(fd, buf, sizeof(buf) - 1);
+	if (bytes_read <= 0)
+		goto close_fd;
+
+	/* Remove potential newline character */
+	if (buf[bytes_read - 1] == '\n')
+		buf[bytes_read - 1] = '\0';
+
+	size = strtoul(buf, &endptr, 10);
+	if (endptr == buf || *endptr != '\0')
+		goto close_fd;
+	if (size % pagesize != 0)
+		goto close_fd;
+	ret = size / pagesize;
+	if ((ret & (ret - 1)) == 0) {
+		order = 0;
+		while (ret > 1) {
+			ret >>= 1;
+			order++;
+		}
+		ret = order;
+	}
+
+close_fd:
+	close(fd);
+	return ret;
+}
+
+static int get_thp_eligible(pid_t pid, unsigned long addr)
+{
+	int this_vma = 0, eligible = -1;
+	unsigned long start, end;
+	char smaps_path[64];
+	FILE *smaps_file;
+	char line[4096];
+
+	snprintf(smaps_path, sizeof(smaps_path), "/proc/%d/smaps", pid);
+	smaps_file = fopen(smaps_path, "r");
+	if (!smaps_file)
+		return -1;
+
+	while (fgets(line, sizeof(line), smaps_file)) {
+		if (sscanf(line, "%lx-%lx", &start, &end) == 2) {
+			/* addr is monotonic */
+			if (addr < start)
+				break;
+			this_vma = (addr >= start && addr < end) ? 1 : 0;
+			continue;
+		}
+
+		if (!this_vma)
+			continue;
+
+		if (strstr(line, "THPeligible:")) {
+			sscanf(line, "THPeligible: %d", &eligible);
+			break;
+		}
+	}
+
+	fclose(smaps_file);
+	return eligible;
+}
+
+static void subtest_thp_eligible(void)
+{
+	struct bpf_link *ops_link;
+	int elighble;
+	char *ptr;
+
+	ops_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_OK_PTR(ops_link, "attach struct_ops"))
+		return;
+
+	ptr = thp_alloc();
+	if (!ASSERT_OK_PTR(ptr, "THP alloc"))
+		goto detach;
+
+	elighble = get_thp_eligible(getpid(), (unsigned long)ptr);
+	ASSERT_EQ(elighble, 0, "THPeligible");
+
+	thp_free(ptr);
+detach:
+	bpf_link__destroy(ops_link);
+}
+
+static int thp_adjust_setup(void)
+{
+	int err = -1, pmd_order;
+
+	pagesize = sysconf(_SC_PAGESIZE);
+	pmd_order = get_pmd_order();
+	if (!ASSERT_NEQ(pmd_order, -1, "get_pmd_order"))
+		return -1;
+
+	if (!ASSERT_NEQ(thp_mode_save(), -1, "THP mode save"))
+		return -1;
+	if (!ASSERT_GE(thp_mode_set("madvise"), 0, "THP mode set"))
+		return -1;
+
+	skel = test_thp_adjust__open();
+	if (!ASSERT_OK_PTR(skel, "open"))
+		goto thp_reset;
+
+	skel->bss->pmd_order = pmd_order;
+	skel->struct_ops.thp_eligible_ops->pid = getpid();
+
+	err = test_thp_adjust__load(skel);
+	if (!ASSERT_OK(err, "load"))
+		goto destroy;
+	return 0;
+
+destroy:
+	test_thp_adjust__destroy(skel);
+thp_reset:
+	ASSERT_GE(thp_mode_reset(), 0, "THP mode reset");
+	return err;
+}
+
+static void thp_adjust_destroy(void)
+{
+	test_thp_adjust__destroy(skel);
+	ASSERT_GE(thp_mode_reset(), 0, "THP mode reset");
+}
+
+void test_thp_adjust(void)
+{
+	if (thp_adjust_setup() == -1)
+		return;
+
+	if (test__start_subtest("thp_eligible"))
+		subtest_thp_eligible();
+
+	thp_adjust_destroy();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust.c b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
new file mode 100644
index 000000000000..b180a7f9b923
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+int pmd_order;
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(thp_not_eligible, struct vm_area_struct *vma, enum tva_type type,
+	     unsigned long orders)
+{
+	/* THPeligible in /proc/pid/smaps is 0 */
+	if (type == TVA_SMAPS)
+		return 0;
+	return pmd_order;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp_eligible_ops = {
+	.thp_get_order = (void *)thp_not_eligible,
+};
-- 
2.47.3


