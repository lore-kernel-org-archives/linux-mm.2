Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A3D6CCD193
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 10:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE9A8E0168; Sun, 26 Oct 2025 06:03:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5EE58E0150; Sun, 26 Oct 2025 06:03:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C006F8E0168; Sun, 26 Oct 2025 06:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A63408E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 06:03:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 644A786F4C
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:03:33 +0000 (UTC)
X-FDA: 84039828306.19.077C97E
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id 80F63C0002
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:03:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=STkDSgHM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761473011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cWfcrGPw8X5skKV0gndo5LB8ERy80+4uQwaPXZmD778=;
	b=WrIAJFPmFlQ+noj8MGPw3C4Y7TiYS/jcaoGL9nRCpmujdf2Gas9HdhusxggcWdHq2MZmge
	iP4pe4cEE811ELxtTdN1vBNygd0G3PGFSxtj3jeQ7PPGR3Ccu/bEZRZlJIvU6FwSdnW1rF
	cpwd9unR0cSBJG2KMw0Sbg/OFDzvKRw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761473011; a=rsa-sha256;
	cv=none;
	b=gTz30sy35ohmyJoFmLTEdoD/updhyJ9U4NG5+NBw5RRwreefc79R5d/AsAUTHyaFXxYPmr
	/QFPzsWw5bV7jyUJN7i9D5CInh1nYQh07bvNqWq+ASCF6QA3L13Vh9YWbBFPaOeBr0T8RP
	ur68SviLRa+ACAtnndaLKJUEtsJYcMk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=STkDSgHM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-33bafd5d2adso3455685a91.3
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 03:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761473010; x=1762077810; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cWfcrGPw8X5skKV0gndo5LB8ERy80+4uQwaPXZmD778=;
        b=STkDSgHMlEq0Os0L2pziGWpWRIXYFcgwe3Ym8UN/686kIQUAhk6xmlMBmCi43Ewjxs
         XpfT5fd2l68s43qxzx6QvpREECD/Z117rc+VxFCpXhHBNRYfy1fBeooVbBnWMEhMaIqH
         5XSUu5qmAo48A3yvNTQQSffTTNxCM+jtrpcu7ubVg47K4PP3KOMWGkjRES3l7SGZOh0A
         oExMexDdezgwFA5dqPe8IUXNLcpZcgX2WiSzrPvGY8TxDwkFK3QAXfm1EW9d0gKGMNTA
         Gjb+8xGuhgbnCwmNjCe4v+lfiWoUp/QWxZi2f6U5MZxsiHhwlgMgR76vrKZvpMDQqhRT
         J0eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761473010; x=1762077810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cWfcrGPw8X5skKV0gndo5LB8ERy80+4uQwaPXZmD778=;
        b=WcNAOzyXFYWdpqpEoLDg2scWjxQHdwQVxT1u6JxvsLY+SCbf8oj1cxANVN4YkvWYRK
         wk5W0qNC3oH1EjUF9DdqQ7V91/GTYiur1zHXHAYMxeJDOeIv9Fl4iYTkl4ux0U7pqHML
         YAFlePPMhcyXbO60AT5XEBcnGz/kUtVqn3oYhRqYMPfGuzUShHRvw51Vz4/W11Ox0xqR
         nPPpx36XczfOe661GbR9dJwrsOZxL9OAiCijBnEDPXGAn2gXM47I60M7EzbkpkbMOtki
         A18hfiOBb6ivH9Uf7twXCHF+Fk8SOLxwE+65AU+HmqX4TrUahmaV/QRjCiWqxEMFGnQ9
         ehQA==
X-Forwarded-Encrypted: i=1; AJvYcCUUaU+5QPlqJejBUC0lGEXfIwpnZG3fitX2Cs3jFbJRTbNm/K4UUOjfSsaZt8uyKm0fGo7C5CkATA==@kvack.org
X-Gm-Message-State: AOJu0YwsBC99pCrY1JLGWOpIRu8GhOGe1iRRomJOEGAfNp17qwp94bep
	N4A7dsdqOZXWUcyS32E8f8qh3JDght8CTsOF3tcDRK0pNCgGCxUSzcOU
X-Gm-Gg: ASbGncu/nRvxjXZhGmxGJ2zMaeTf1a38wbbWemrqQcn0xF+uMauvLlMOXgFOEm+Ulkr
	DXLCbpW5LcfDZ2Qln8/t7ckMbIHWCSHpy8G1VdEQk8F1bQ540XkLS9T8b7FkHTpfR0O0kxRHFIE
	rO5x0DfZdfy22lZZD6/XhevfBpyBNBRQSjGPw6prUvtrTmKCJmFKw4Qr2rgheQKpJCZrS/SYLCO
	q04kVp8OMCxlByAoNwUZqYJ+rT2PqFtEMs6MirBAzflCNOPpg0TMOiRituYhfLDtQa5ob7ycZz5
	VcDve2pd/gdtUP8nDs+ZChMPL41xSIfX+B477WAbeFvLrZaqV09fns5j2Qy0uYs6rLqEe3Kt1iU
	QBRGxNKEG5f681Ly0FU1JkRaV9wdmCLpHMJCgTacsbbytoq68gwK+egT60BF4F6JYgknkpMvGt0
	GWTUKtsRdWkn3EeVtZnAbubS8qh/gJy5gF6C4=
X-Google-Smtp-Source: AGHT+IFU+r5rd1i/zL0ytQ8WGidWA2lJlrB/4TzfYyuXqTn8bqTegd2HnrJMszIQIY77p0EH4LGqxw==
X-Received: by 2002:a17:90b:3ec1:b0:33b:a5d8:f198 with SMTP id 98e67ed59e1d1-33bcf90b791mr39786862a91.25.1761473010340;
        Sun, 26 Oct 2025 03:03:30 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1a84:d:452e:d344:ffb:662b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7d1fdesm4824966a91.5.2025.10.26.03.03.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Oct 2025 03:03:29 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	ziy@nvidia.com,
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
	rdunlap@infradead.org,
	clm@meta.com,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v12 mm-new 08/10] selftests/bpf: add a simple BPF based THP policy
Date: Sun, 26 Oct 2025 18:01:57 +0800
Message-Id: <20251026100159.6103-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251026100159.6103-1-laoar.shao@gmail.com>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: efptf6dw51jm5b7dcdrg4w1hey1znpzn
X-Rspam-User: 
X-Rspamd-Queue-Id: 80F63C0002
X-HE-Tag: 1761473011-975311
X-HE-Meta: U2FsdGVkX1+ae2L3OMbOjIBkFl+hltm3fnJnDarcNjNL7r2Pu9Wo11f6usuI6y8bvFHARCZS+I4j1zA5yHjEJTSpABYr1mi7Vyod/3jfan4FNWHTRVAQZCXNIVR4v9B3/3xFrsI99yMunAoNFpWiK/ToGZxVPO9KpfYY/WY/bFTpsMGS73ojBC/Dsr+jibHbdymkdIMPV1WUES3r8GNUqYS6juJXnHiWuwEGDRL+hM+7f4PymUFpRPl1c8uBxT00Wr8UDyWD8YnIXyQ6jImLXACAE4yaWgsetuv1Mfi1DWMN5U+rPmcsISTgW3v9wvCXYw/5tQvwsQn1YhOUXDAihu40l1wPlqnY4tjeVeX/9EEae9S9Vme3KcX3zoqSooRIWFONQui5anV+AWOlTW3RLVrR+M1B/umlcaTDpPMszX43IOeN9hZxE5w+PAjwdQUOurz/I3RLdSpzoXsSmHloH9kxU1qGzjQrq3xOovuW3iqCsMKls4rmao9pkMOcrz239wVP0N19nijyzVNlm1gV1ZdNWhQrDM49JobzU/jChIkfzg4nn2X3q14cbXnsZdSPsKJpdpbjXQj6kreyBqFcrmt9xw8gu8p0BaGCvzuk4uNCnARTgrQxk3+QW39KFRcfWXoM7eoBJv6F561xF9Hzv9z0CxbAvuUuT4r3D1ZiK2q6RnMYNWU7H6i0MZZzeNChkMcbqN5SVJYyy6yU01+8iSVQiKppb4Lqzs1aG6KsfiZFuZPJGkrNEAJq1le8BpNYIDTTrVASHcAFdGBRO5398+TKB1X0LcwZlDv+xUU2cAJjLyrcKTlQvAKhvK6pMeokkYvlEzpbc1W8G7uuuxszIOK1yPVOca8IWJ8J1+yh2iNQTOYYEU5erjoYTQBY71zfgskKohIoY4ZXMqF/jewFSNNZWBk9/W/kY+i/cjeVL6wqSMn8/RdasQQxRASOhjOHylyZQte9b3SV2+stLZZ
 fJSeWL2m
 x4MD17W4Y21fyj6pZrZuXNHA8CAyggn300RTP1tP41yOjxVTQhAc+4ykVp7sFXHwE0wSeQ3MV0hNWAa90eGGQolZOdjB/5qx/C5YjOsxTNunlNJq8nbU7ABLMXz9UmOreeo+T6r7mQpmUigPTXM+ZstIvvDlO3rYJElA7sKDLk742M2WymNQy61J8C79HIm4CpMtlICIzCMnMgQ5XZDJyakyT+z/zBEXfPHZizxcud7EQx/amfpyOywDatS79sYY/oy+kRBP1eZN6STARxmSnKASgtp8P5yhOJPRFVPaUfkWvkavVugU/jcdUDs5ZfnNX2TKhw7sidaIDH3G0whEZVVsxVytud0L0QZgsY7qA2o1Gmi6n6dQzMdCIOyr7y9LL7T3P9QjXP/y1yjW8ud4ZqLeOjQHpDVD+mSoczwALj42KsVYR++HrD/tKG49L+REhJXleFLHICSp8SKV4KJ6JBeosyESbyJSGlhc9oi0lmuyF97HwF3pOgXW1Mlz4clY/bK0uKBNQ08p3mmk=
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
index e8eeb7c89431..295cbda88580 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16524,6 +16524,8 @@ F:	mm/huge_memory.c
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


