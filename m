Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BBE3CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B3D8E0027; Tue, 30 Sep 2025 02:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6531D8E0002; Tue, 30 Sep 2025 02:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569078E0027; Tue, 30 Sep 2025 02:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 472608E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:00:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05B6EC05AF
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:00:12 +0000 (UTC)
X-FDA: 83944866264.01.555716B
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1A5FF40005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:00:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZE+HzlyG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759212010; a=rsa-sha256;
	cv=none;
	b=DvrP9fZMXvSpkXNPHxER641MFSRO3frG2m3C+ygwQzX0e/ts1wlwdJ0vIviomKQswsgT7h
	An5VZK/vhtH23LBG+UFv3MMTYPcRxhzGvDfn/z1OtKkD6eLKd3ZPuEs54FR9JxJuJ30fXr
	mM8lbVCpLPW36excKI5AFXaZ+RoY6yk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZE+HzlyG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759212010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9AJux588gWgrV0mh0Bl4XWK/14sRfUKl951c+dMtJo=;
	b=LKa2BOEZjilEyO04UY98l8U5JJ3GCr611Pvhmon/5ApW590hMGPnH2RC1Z79l8SmvWajG1
	R+PegAYivM48jiBpshMudnFSUGK1MSkO6CWR+iVXtsRD/LIwhXi21At064cApDxIButYtm
	hPqVVrMb8L4DUu9Hh4H2UXORUPT1PoA=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-269af38418aso70640805ad.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759212009; x=1759816809; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9AJux588gWgrV0mh0Bl4XWK/14sRfUKl951c+dMtJo=;
        b=ZE+HzlyGYmtTLn015GuaYDm/hAaMzwsXTqwFy86BtMaZrJLJ8ftzUHXpQZAR0K+r12
         o7oth6BbRY/b53EwnBR/lWSu5TIXy1Gjkzavuyy0BxojhcKDpTcAYInDnaR4L/56oNE6
         u7EBzTWgLCR8CMPrUdSVkGAA+u94N9s91fv0JdRu1F3mzPE8fk0khUYauZEz1+5fiU5z
         8cdcqx/puW0bnGyrv8hpt6VSOSXytQVgy3rBXeBWHI/BCfJSpLseNQ5sE65Y9OcjjhDe
         W1lBZE8ciAaW64nYB3319BMkuHaSbbBlZB3JFLo+a88hNTkB/S1OsrfBxAVbOzkJABaM
         dJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759212009; x=1759816809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q9AJux588gWgrV0mh0Bl4XWK/14sRfUKl951c+dMtJo=;
        b=I5Tm5y0UXJL39OSTp9m18xlm9SshsK2CMqEbH4d3mDcNW23R9L1TIz5/sbVcw2JBFO
         FSJFXFgXSus4hmyw24jIcpG44J3piJWm/GGn0u3sfR0es0+o5NTYLliSaVoUJ0mX2EVf
         CcFELOgRW+1tAx9b3gmmTf6L8jwESaz5kufbLewoUVFnvHdz1wvCQrSyphuQk2ZZW0oH
         NCXOaEzNfHuORrIG+F/E7CvHTzRNcR+Gakn5CrmajcniNv97so4811L9Y4GhOJ6RrjPR
         HbkMVvEVde7NeJfLbBMj1jTQ6+/lo2topdZPprXiUm03J2iNBODvOXPhj98SyqmQflKX
         3vqA==
X-Forwarded-Encrypted: i=1; AJvYcCXsMc0GD6vJISw9LaPiuyHISVsvZaBUdrzBM080oZGGHrBqK2SLY5GOHw9TNXMedOgFq8uDFsV6zQ==@kvack.org
X-Gm-Message-State: AOJu0Yz9r7bDP8p6/rdFsGE8g7uAVrgmkD6G8udP6Jgqhd4c/a7uPM0p
	tByK+LsQzxOL0RELkXxUkN4Naw766+d1BRpXNTHbaCdxaAcJb2JAd5j3
X-Gm-Gg: ASbGncuZMlpSj4VhqAZHgmYT7wP1EJe6NT0kyMpdvk/NLcX/xSJHQFQWHkjAm+wbPZN
	d2QtukZPV42kNev2GGncfxQkjLoLlE/XyjKpyM20nDrpzF9dbwoL0OjlpV7Eb7bZ4ifBN082YP7
	kcD5Gb8HDDTW6e7xrINAuvRWsplZS65pYgaQP5mCzvC2SIge1WRAJGuTAXoehk40ePu59C7WBV+
	8ALmUYin+lt0NUkTOe9n4LzEtdgsOCNTm8rM4PIChwJTW/nMchn2rnbBEq3RoRj8ol+MFtbCb5J
	4EkoCyt5WhkSYO2FtTgMakFH5OZ8wEc+BGGUc7LrvFJaoK3ezZG9JcpQISQgGJBrfg2kSEEcknw
	4EHsf/1Hi8rHWK2V1uX5PtCegKJHLSoRnMMgzGc6y63vaMkwhPkEj/73AhDm1y7Ubo2SI/gKsxU
	9UWSQN9O+ii1KP/ZpsArKIQlZJk+apWAb8P38q0A==
X-Google-Smtp-Source: AGHT+IFxOy+OVpj7YYQUa1xeFuFT66rHzPXVfIt7SgvZyLCGZHlY21OivixoSzSZemCeMeGafMhUvg==
X-Received: by 2002:a17:902:fc8d:b0:25c:2ed4:fd7f with SMTP id d9443c01a7336-27ed4a6e9e4mr225370925ad.42.1759212008758;
        Mon, 29 Sep 2025 23:00:08 -0700 (PDT)
Received: from localhost.localdomain ([61.171.228.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm148834065ad.9.2025.09.29.22.59.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 23:00:08 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
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
Subject: [PATCH v9 mm-new 08/11] selftests/bpf: add a simple BPF based THP policy
Date: Tue, 30 Sep 2025 13:58:23 +0800
Message-Id: <20250930055826.9810-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250930055826.9810-1-laoar.shao@gmail.com>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1A5FF40005
X-Stat-Signature: gdhzecom766s6xunaif77i76cgzsqm7b
X-Rspam-User: 
X-HE-Tag: 1759212009-614963
X-HE-Meta: U2FsdGVkX1/tfJWc2p5d+lvA28fr4hho1sJ+LhzGBjucmH1tiE5MZ7tDQRAb0/MFQPFESpeHDig49tif00hDIMdZJ9pFyUg9Hq61agkQB8On8HRkfzSqJYGlf2+yEH0uz5UfU05/6e+rtxdycDNvGq10xp2DJD6n6S/GAew/kKenAdNWtd+pk2rqVTTm+POZsvAoDeRm0zReVujM+EG07c06XOUblpVZ8EB+IMXXTMN0+fT2oZDeFz7FFoaAh0mVdubZv5xtqLLnTCh8PgL73GYX3/iUOxPVJtjXnwa/4eXaVLD0Izx+y8D7kN6+PFYcj7gYaUPz8z1anu5yDc2L0EEcho/nS6TBNC3AAIgu0qdYMRLHCovEGme5lhorLZ3tiCjdPd6awQtpBOq0H0QQ7nzNVO5c9ADSmtJoqBa7fg79DVsUcZ3+PoHHBMmyEMgPNXQmIrZKv+4900pJ4Y0wyLYsO1CBaV3hJEn7vVgRCUTcglb4jdTzDmpRe6pVj8lZXU5icMhT0Q74xk/YDAzvoEPy/m/VZGe6IELeiUU0ERFOhlvgPzK/Gu4yomnPQax2EKhQjTZCGPx44E2+lEh1+2q2BEjBXODN2+C5jv/MgOMwrJ3qhpck5D4frlTJ9e1halLmJorGlu/SO+SrdDw9JbsY/GOwweSJSQpj2jQltdV/PFmdWv1tjRRKzfam+gzlQ5xLa26q6j1ja9VCngPZS5+ovU7VShY9LBT0EpImMiBKzPA4UCUSOiAMmDafv6DZK9nKQPt/jz0P0jEF4DuAM4r7OqkRro+1mhSLfxx0AmN6ugMR48atnovq5XeVRlzBXeXiEsE8dLQ+/SeuVN+GnXALoGfcMcMi1B2W45Q09A4VMEQ+ySv29jGiT1jkOpExPbnYMJ6BMtTBopiIJ3+r0ljC3Ec9/f1zwlI+GjIwmCQ2k7uYICW1jhKpIEl02Ylx0Cdi4OtDAcO6koSZpDi
 qSfNaUzF
 rjy4Q10gtYENpgqSx0slT9Ho0dHY0DGtRwibIOCDfdj0am68b9+ofG/qk+ym+JaijmKO2tbH+ZlGYpl8e9cfxRlc2rAAHWi3fiC6mznexB8W8StouOmI2DBmraEbeqYvmOHo6KjM1mqK/Ct8pMZtQQTpsCRaaVOZocZXhaASXE66LztfV/yhq62MFFVJDFogv8v47eNK7ibCau2nR3JVnJ5HmN6trulwtfPXCKlRkJZ3SfttiifB9J4Jxp3sGvuvmq4eRgeEmoQplNP/xktSn0WlQVthZ8VusS7UjV+yptdILr5PBl8JK7XUhifXiTTWu8mAsaJ5pB5KMqLjKsutKS/NJZ9mZcL7UA1fcMZhdr4dGdAtNhUe92VC/FnqaP72yMIX6U1ikHxfrL1wXn3/ybjtDHQ2FFmOsc/DoIHDCTy9AF9iUH6bY8lD0SC343ahWwtHGra9tL2+ZM/9UswLkQ3xoFfRXFqkcO9VHB/tyhiyJ8PjgT+FAEp97e6GmJSiKixj/8JbB2aBrXhY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test case implements a basic THP policy that sets THPeligible to 1 for
a specific task and to 0 for all others. I selected THPeligible for
verification because its straightforward nature makes it ideal for
validating the BPF THP policy functionality.

Below configs must be enabled for this test:

  CONFIG_BPF_THP=y
  CONFIG_MEMCG=y
  CONFIG_TRANSPARENT_HUGEPAGE=y

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 MAINTAINERS                                   |   2 +
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 257 ++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     |  41 +++
 4 files changed, 303 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7be34b2a64fd..c1219bcd27c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16260,6 +16260,8 @@ F:	mm/huge_memory.c
 F:	mm/huge_memory_bpf.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
+F:	tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+F:	tools/testing/selftests/bpf/progs/test_thp_adjust*
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 8916ab814a3e..13711f773091 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -9,6 +9,7 @@ CONFIG_BPF_LIRC_MODE2=y
 CONFIG_BPF_LSM=y
 CONFIG_BPF_STREAM_PARSER=y
 CONFIG_BPF_SYSCALL=y
+CONFIG_BPF_THP=y
 # CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
 CONFIG_CGROUP_BPF=y
 CONFIG_CRYPTO_HMAC=y
@@ -51,6 +52,7 @@ CONFIG_IPV6_TUNNEL=y
 CONFIG_KEYS=y
 CONFIG_LIRC=y
 CONFIG_LWTUNNEL=y
+CONFIG_MEMCG=y
 CONFIG_MODULE_SIG=y
 CONFIG_MODULE_SRCVERSION_ALL=y
 CONFIG_MODULE_UNLOAD=y
@@ -114,6 +116,7 @@ CONFIG_SECURITY=y
 CONFIG_SECURITYFS=y
 CONFIG_SYN_COOKIES=y
 CONFIG_TEST_BPF=m
+CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_UDMABUF=y
 CONFIG_USERFAULTFD=y
 CONFIG_VSOCKETS=y
diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
new file mode 100644
index 000000000000..0a5a43416f2f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -0,0 +1,257 @@
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
+	pid_t pid;
+	char *ptr;
+
+	ops_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_OK_PTR(ops_link, "attach struct_ops"))
+		return;
+
+	pid = getpid();
+	ptr = thp_alloc();
+	if (!ASSERT_OK_PTR(ptr, "THP alloc"))
+		goto detach;
+
+	skel->bss->pid_eligible = pid;
+	elighble = get_thp_eligible(pid, (unsigned long)ptr);
+	ASSERT_EQ(elighble, 1, "THPeligible");
+
+	skel->bss->pid_eligible = 0;
+	skel->bss->pid_not_eligible = pid;
+	elighble = get_thp_eligible(pid, (unsigned long)ptr);
+	ASSERT_EQ(elighble, 0, "THP not eligible");
+
+	skel->bss->pid_eligible = 0;
+	skel->bss->pid_not_eligible = 0;
+	elighble = get_thp_eligible(pid, (unsigned long)ptr);
+	ASSERT_EQ(elighble, 0, "THP not eligible");
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
index 000000000000..74ad70c837ba
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+int pid_not_eligible, pid_eligible;
+int pmd_order;
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(thp_eligible, struct vm_area_struct *vma, enum tva_type type,
+	     unsigned long orders)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int suggested_order = 0;
+	struct task_struct *p;
+
+	if (type != TVA_SMAPS)
+		return 0;
+
+	if (!mm)
+		return 0;
+
+	/* This BPF hook is already under RCU */
+	p = mm->owner;
+	if (!p || (p->pid != pid_eligible && p->pid != pid_not_eligible))
+		return 0;
+
+	if (p->pid == pid_eligible)
+		suggested_order = pmd_order;
+	else
+		suggested_order = 30;	/* invalid order */
+	return suggested_order;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp_eligible_ops = {
+	.thp_get_order = (void *)thp_eligible,
+};
-- 
2.47.3


