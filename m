Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E545FE521D
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85A46B0093; Fri, 24 Apr 2026 08:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D636B0095; Fri, 24 Apr 2026 08:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C740A6B0096; Fri, 24 Apr 2026 08:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3EA56B0093
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:24:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FA9D1C00FD
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:24:49 +0000 (UTC)
X-FDA: 84693368298.10.8695A96
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2FEC0C0008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:24:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YN3rWZLc;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf10.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777033487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJ09Jo0h/vP/hOFzbwH4NhaWc8BN8qSSaNGeuLFDRBg=;
	b=Y6d/u88Pc2YDqVLI6YnCP+FdlqK2e0CbTrOV/EcqD/LbDp7JpvaDE0+kZJVdWmxc1gVT1L
	Bn5AbRk4LNT1Mn9xWQLVqEKP9eV4EN+7icNYJORRshvfTd9e0+GZ5NpHMrHVX2WekYUa/S
	utGpMXB2Ef080nvL2a+mYdUpzPeYAAE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YN3rWZLc;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf10.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777033487; a=rsa-sha256;
	cv=none;
	b=y9EBWu8dQNQqF1J2mAc06NeNE5TJimG3tzzw9TWGpq+Vkm2AMlLDef0qw01uLVDO+Mqt3Q
	5e32CgET1FsTaMbAics/o18j+H5Yr1ssbMHfBB/CHCcxWZGiqelNAMChBThcq07pOzvuNE
	0cf5M7YIM3qjF2oZ9NUYXKhGDKaG3xs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=VJ09Jo0h/vP/hOFzbwH4NhaWc8BN8qSSaNGeuLFDRBg=; b=YN3rWZLc23qtp4id7Che7GivgN
	LF8Am2+CC2mxHoaRu6hOkF4Usj7eEN2lt36BXtrcuCZHr0CRb9M/FG1Ww3J3kohVSyInyp1hyL3l8
	jmn1ipXgtFzxQbSUpXrTbw/mbQ+J+IJEd4kqeE0PHYxGWcyJ+fP89PpGplBbNJHZOXBwEkJj3Fzpk
	i4TlXPfLlVClj7Wn0MhbDkO47SINKJMlIMr/IoiGn9+3pBC/cZIqOhfVroRDtO6al8t/eMyO4IdXQ
	Ii9j6FATtWNS92NqCAPLU5EhlNwANxF4onx6QHwt5toxqK3JS82KjsNx1Dhj1Edw7p3Xiy8qS2hGG
	BToyHnJw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGFaK-003AQL-1h;
	Fri, 24 Apr 2026 12:24:40 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 24 Apr 2026 05:24:02 -0700
Subject: [PATCH v5 4/4] selftests/mm: regression test for
 panic_on_unrecoverable_memory_failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260424-ecc_panic-v5-4-a35f4b50425c@debian.org>
References: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
In-Reply-To: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3929; i=leitao@debian.org;
 h=from:subject:message-id; bh=Ju4F+y15N/15YSKcoOoe8hecUCP4Fg5cxAM43INPgiw=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp62Duu02nZb1HcgkNBUxR/EIf1G8rz/XDjppUT
 a5iK2aM0haJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaetg7gAKCRA1o5Of/Hh3
 bWsDD/9hAKxJHJJVVYekL9J7smIGLipCaTr4t1HTbxP1YFDcRGht3rB9LvffgMAKZ62PgQoIP3k
 Wv5fIbdL4Wqec2gvXjLyr+VE5aQxBiIZSpqsTJx8iKAsQIBI4xpXpjy+T/j7Du+BP2EElYhXjKD
 +f9SEYoqgOYL8XCgucawSJQ2yzGSykz0pj4Cp2JqGqTTMVNSNn+P0bf6j0/fHRNdKclHBz6rL+f
 5tHOkvT9UyD5FQwvuxJ/lDyT5b0D3PYChXL5Och1JmS33EzDyKZtKclj4qtaEgaI2PlToBApaTW
 nHOlSx4tDt0Xyh55JRMqCAKvHLWUw52QeABwgugBgR/CM4vlbct8Ep71GfT9AGwjz/sR6yqEZRh
 w03TG61wtVlT6gNdaYhCeX4t7fu/EpivZfdO2/qaB5A3QPAPtijmolOVwjlZGVixcPDnQGppcog
 6uZyckkp4wLCspqDn8TfZ1gJp24FSSVZs4RKaFLUtuWzfNWKiN38ZwoZ+XU/96usP8yHOt7OuBB
 g66OGBDe5NJJUju6idlaxWnnowQ7TdpfNYWq8QpLQGEtDn2IU2DHrqD3L1Zb7VdCicDrnEnSqb+
 iiiuXHHejKuVCcRSHbwdxDE6P8smOYx45fIXYbcu+sfSSyscZ+RyQ7hTORpdAHkVC1vYSVwveVr
 giSdM36EMaw2/hg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2FEC0C0008
X-Stat-Signature: z35jez4wpnpic1z3ng6abfecypmxx3k6
X-HE-Tag: 1777033486-536895
X-HE-Meta: U2FsdGVkX18x+sHDBrUCoNFJrhs7XJxl4gB++3A9ICgxiv4y05w0r4CSb9775ODobVIOEVeXw6aO326nH6JMNIxgq5ym/0GFlA+844VGV1lAejq19qOc5glU7CmpH/qnibeEY+i1rSPtGH+maxZmO7oEkMkkwDyiH9ghq/uSWW760EDXTDGg8OLjU06f8ZPe+G9l3rYpX7qpvwRRCHCvyUEljkGsV4oETNLV/L4h7eESDK9Q6KSc5vkHi8NOSTpmHlz5XHrkaxQBmUG0vQ/yuMH2tzQB0dxZWzP48TGzUFZNVpDdX8mlWdqt7LH0fiCT8onS/BT6GW2/cx76ljSrHG8j71Lc5Y8e6hLtMVtIRPy3akHyx1zyGZHTv4yHbtrt1U9i6nRSryzbfdpHtXdRc8GRemTStcHmm/ptbxM430uAZD9tZws88DPR0VZXKG4DSjC3HRXskD+bkkcRnZK9XG2xVrHY7SmtMP3DFbdcoAJOrT4aj6ajtbJ1Yu4m7ItSeffE91DHMpZ7LKw+lmD1ZCTeMaPKy1h/THZXClpjv6HmZBVF7e9XzwEPJPLArIVoFX/074cixv6oOQ0bnuK5HlGHJCZC9SnqJPqUK7DhShW4+1V7uH6+elRgUHIoa36zVWzxJanIxuWFb2Wo+DFua5QzOhKNjHi766wk7UcdFg9otR10mdFXC9+JSmL+bNpmmwsz+9Dlmfnx8/u/PX/RYPiiTpESbDkDU/bgKDUXqL5V082vmjBYpSSFin/19YhMh0Ip896GGrHq8KusorYc3yuvJ1HKGSrprEmFU5ZKMgSL76lGiDwUNAOU46Ka3UjzI5Xowb4rE6qftCuSjqMLh98RinauqdIlaLnDzxRi8mgBTZZ9Og0uCiN2qQEprCZ3tut4EdMkzDJZt5pwK+LPVMI/fAIWafxGCduFaVspYGsZVmvo/fF6Xm8jkBw0hqU5Ey4wHzCX89647BFDCQx
 xwg/x1UV
 in52PYnE1bqas/nSlQuypt8ImU6gffQKrB9Nzsee5xO7Bnuke7hH5TTO8mtaHDFzrtD2XkIXdZeUobRiWJP9yufgzqrJ5/9LdZbSWu6X+FUZqn52DjyFdKJK4ABvYfeM2CMri+wCnA2J4HckVt8FJR0EeCz+6mbtMFnTpL5ECxvQ4jGb8BmZtTJDUSbUjA5fUaqpA4KZontZ6BezNfLLtPnzpwhbQIg3wTJ4xq5REGvg2Ut5BrpuE28TkSWT32xg54K3C5dYBsGcJ1tw25ksVoPG5dDnQjTDsrComWcrT8phKAFbfetQHv8v7QEJguXhhtDWJLM4qmvRILsiA6iZu3xY8NWVqP/KkFjV9jNXwTJs6zwPG0pSSD3KXGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test that enables vm.panic_on_unrecoverable_memory_failure and
injects MADV_HWPOISON on a userspace anonymous page. The page must
still be recovered via SIGBUS — it must not trigger a kernel panic.

This is the regression test for the panic_on_unrecoverable_mf()
recheck: a buddy page being concurrently allocated to userspace can
briefly land on the MF_MSG_KERNEL_HIGH_ORDER branch (refcount 0, not in
buddy), and without the recheck the kernel would panic on what is
actually a recoverable userspace page.

Run in a forked child so the SIGBUS path is fully exercised; if the
kernel ever regresses and panics, the host VM dies and the harness
reports the binary as never returning, which is itself a clear
failure signal.

Skips when the sysctl is not present (feature not built in) or when
the test cannot write to it (insufficient privilege). Saves and
restores the original sysctl value.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 tools/testing/selftests/mm/memory-failure.c | 84 +++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 032ed952057c6..9cb8d694aee94 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -17,9 +17,13 @@
 #include <sys/vfs.h>
 #include <linux/magic.h>
 #include <errno.h>
+#include <sys/wait.h>
+#include <stdlib.h>
 
 #include "vm_util.h"
 
+#define PANIC_SYSCTL "/proc/sys/vm/panic_on_unrecoverable_memory_failure"
+
 enum inject_type {
 	MADV_HARD,
 	MADV_SOFT,
@@ -355,4 +359,84 @@ TEST_F(memory_failure, dirty_pagecache)
 	ASSERT_EQ(close(fd), 0);
 }
 
+static int read_sysctl_int(const char *path, int *out)
+{
+	char buf[16];
+	int fd, n;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	n = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (n <= 0)
+		return -1;
+	buf[n] = '\0';
+	*out = atoi(buf);
+	return 0;
+}
+
+static int write_sysctl_int(const char *path, int val)
+{
+	char buf[16];
+	int fd, len, ret = 0;
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -1;
+	len = snprintf(buf, sizeof(buf), "%d\n", val);
+	if (write(fd, buf, len) != len)
+		ret = -1;
+	close(fd);
+	return ret;
+}
+
+/*
+ * Regression test for vm.panic_on_unrecoverable_memory_failure.
+ *
+ * With the sysctl on, hwpoison injection on a userspace anonymous page
+ * must still be recovered via SIGBUS — it must not trigger a kernel
+ * panic. This guards the panic_on_unrecoverable_mf() recheck that rules
+ * out concurrent buddy allocations being misclassified as unrecoverable
+ * kernel pages (MF_MSG_KERNEL_HIGH_ORDER).
+ *
+ * If the kernel regresses and panics, the host VM dies and the test
+ * harness will report the binary as never having returned — which is
+ * itself a clear failure signal.
+ */
+TEST(panic_on_unrecoverable_user_page)
+{
+	unsigned long page_size;
+	int saved, status;
+	void *addr;
+	pid_t pid;
+
+	if (read_sysctl_int(PANIC_SYSCTL, &saved))
+		SKIP(return, "%s not available\n", PANIC_SYSCTL);
+	if (write_sysctl_int(PANIC_SYSCTL, 1))
+		SKIP(return, "cannot enable %s (need root?)\n", PANIC_SYSCTL);
+
+	page_size = sysconf(_SC_PAGESIZE);
+
+	pid = fork();
+	ASSERT_NE(pid, -1);
+	if (pid == 0) {
+		addr = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+		if (addr == MAP_FAILED)
+			_exit(1);
+		*(volatile char *)addr = 1;
+		if (madvise(addr, page_size, MADV_HWPOISON))
+			_exit(2);
+		FORCE_READ(*(volatile char *)addr);
+		_exit(0); /* unreachable: SIGBUS expected */
+	}
+
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	write_sysctl_int(PANIC_SYSCTL, saved);
+
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_EQ(WTERMSIG(status), SIGBUS);
+}
+
 TEST_HARNESS_MAIN

-- 
2.52.0


