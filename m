Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33055E7E0D5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0915F6B00A1; Mon,  9 Feb 2026 14:06:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3176B00A3; Mon,  9 Feb 2026 14:06:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE04C6B00A4; Mon,  9 Feb 2026 14:06:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C65CA6B00A1
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:06:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9932C1B2C09
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:06:22 +0000 (UTC)
X-FDA: 84425849004.14.B436988
Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id CCED28000F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:06:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UPszbiaT;
	spf=pass (imf02.hostedemail.com: domain of 3KzCKaQYKCAgi3ioqvowwotm.kwutqv25-uus3iks.wzo@flex--avagin.bounces.google.com designates 209.85.160.74 as permitted sender) smtp.mailfrom=3KzCKaQYKCAgi3ioqvowwotm.kwutqv25-uus3iks.wzo@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770663980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3gza5co478YYPeHfG5MnlQXarASyDN4UjfFwF45d5I=;
	b=oDtwxl7TuM3Fd3Pz0ghZYiisiLQBLNgBwoZkTowqb3a/fi8aJAJUB0srnxv8LEgNpg4+w3
	epLlJmRTu3WERMbHbpUxzRHLlnTyr6UABbEYiFpPeVcJQbjQdyohpahXBpuktY5Af9k9Dl
	wd4+NzXRIEdDSpdMyTrij/pRgw6ngsY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UPszbiaT;
	spf=pass (imf02.hostedemail.com: domain of 3KzCKaQYKCAgi3ioqvowwotm.kwutqv25-uus3iks.wzo@flex--avagin.bounces.google.com designates 209.85.160.74 as permitted sender) smtp.mailfrom=3KzCKaQYKCAgi3ioqvowwotm.kwutqv25-uus3iks.wzo@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770663980; a=rsa-sha256;
	cv=none;
	b=4hW/A6pHj28RHrCEhlpvGIyNXaQjImwZXGzt2onBSOlmdlqoOJRe+8QKlMGLsWusA2YZpX
	KSSIGlKe+oj1+xNVEAovH5GzUDVGv70ULS6O++pSg6/NYTdSVxpmuqwj1H/J8I9NU57i1T
	RqjdxJ1hOAe0vMJpKYdChjHOrUp/RzQ=
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-409698ea4dbso21075104fac.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 11:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770663980; x=1771268780; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3gza5co478YYPeHfG5MnlQXarASyDN4UjfFwF45d5I=;
        b=UPszbiaT9iv9EhzXAIw/WKO+GXFFsRp8dqmulL7fY7VGi3FA3VWTB489CpdIsOkL5P
         uuG4lnd0Drt3bXaXYdKmfV+C5MtXWvnNFqlj0ZWZWHU34BSq8GOyv42xydD+IGKdryNV
         +NocJgGP4dyHBYcYwvdvbR8sVxnNvNoivVb28Dj9GvdxFFHCboKyADuaiweH0I+nIIhn
         J9UT5kwtnqugjAOsOzAXGDwDX/Bi9F1OPAH55+/o/r0CWH//jOieCgoqG/CdL4yUeL0l
         d8Hws5lJKgkWgWDPkd88tgJ2901gDI5McJQxnDgS9YQJLF6zTyguUOunBHMtn6008+DW
         bi1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770663980; x=1771268780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3gza5co478YYPeHfG5MnlQXarASyDN4UjfFwF45d5I=;
        b=QLNRNXd7V9B1+tHPM2Wu/JlURn92QM1SW2gB+/H6y+C/bHOJ1MKkKi/xt5Z7CHQD2t
         0IjGuLKmWLx/TLugYaa4w2zKCUmYL0xCz02vs4/aOonai8u1wJwHy/WOQR2bmngR3mPV
         ze9Yonq7LYoO8lABAwEVrAV89yd4rNmJjDftreMDEsBeID7GlXBPGj/nqxgRi3hnpRhn
         KXKIgAcw3+z8dM844pAltmaithsfJlWHCZx7zDTQHaOL37Sjw6PA2tg1EvqbAYeuKUvP
         OqZKCl5hLWCs3AOs6AKGGANLO4fElicCxOC2+VS+Qw0SMUSKeiS8ndXHNGA8mlE1OdvV
         kRnw==
X-Forwarded-Encrypted: i=1; AJvYcCWxSGbli6DZaXD8A9gI3waQkDj5OcaDoF3ZGtJbNAqz+zTFptu97tL+PJamtZnmDT+HqjX2KevD7g==@kvack.org
X-Gm-Message-State: AOJu0YzSj22EZSQ2xyIXqmj965W59vG/qSq8f2viY75qKlrVW7/YJBV0
	2O46raPMN7e/UkxSNRVbLPmMHElNfsPsMFplyQeQuFXbE6nyIkJjGF3hO9zRALHy1L4vAz56u/J
	Tku//Yg==
X-Received: from oalg15.prod.google.com ([2002:a05:6870:85cf:b0:404:59ca:ea1c])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6870:b414:b0:3d1:a15c:f06a
 with SMTP id 586e51a60fabf-40bf30182b4mr364249fac.0.1770663979793; Mon, 09
 Feb 2026 11:06:19 -0800 (PST)
Date: Mon,  9 Feb 2026 19:06:05 +0000
In-Reply-To: <20260209190605.1564597-1-avagin@google.com>
Mime-Version: 1.0
References: <20260209190605.1564597-1-avagin@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260209190605.1564597-5-avagin@google.com>
Subject: [PATCH 4/4] selftests/exec: add test for HWCAP inheritance
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Andrei Vagin <avagin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: csfwot1sz959d854j7jinbjcebq7o76n
X-Rspamd-Queue-Id: CCED28000F
X-Rspam-User: 
X-HE-Tag: 1770663980-999115
X-HE-Meta: U2FsdGVkX1+86re1kA0jpPx3NtGxREp2G9knYTU4sEP81jMOUyHdtFnyEce5idlfWrz6nrKxxozqOSUUL+veusEWlRuQCdLKY0WjCfdMsV7YauInIw0qBgyYQeQ15wlbLLapPyHt3EaoeN8tyhcuIiU2xdfFFIhyC92LqKSKQENkRSlr1gw0//zrkOZign9gQ34Kt2FCEh1vNDvoVoUsWLET7imoBWOGkYvaWSYwSo5vUZskVEfPjHVInoOr5OerMDyPK47/eWk3J0fRB21N64pMcWzzbKMMKPiC6q4QjJfgkh1d+7TkWhS7ECilp1fJG1oXkKHQPNNYc+sWiDq5C7/eo8aCm4ZCL9Thmrdi4NjxE7C+k2HgTXQazL/w6i48m0KElax6yyf5QODRnaPOfK7kfl/u7SjsPca2jz/PdEmkjHZw/0NtNfxTXG/m0puvC6utrp3c7stkERkOO4MXBK6Ddr+7NU//OeNocpLaHtyPUXxgAT+znJkZ4wBSsQD4mIvLa1diElh4hgzOXVu2iy0j5Ti0soUbA2NnuCbChF5zr27l4+2orjIrLbOyrGEzbZ7nt46A8Z5Ztnh4MovEUOyEGxvV6iuubUZTr1My5Y6Hm4EGBxQlyCA+mpG+2caMbqI9iq8qmU2kQUSsJ3TH92or3pqzp2d4wtnP1LS/DHpcv1pyLR/Xdacl3WTri/rKbBy0XbiJeMLxNu3PQX9GHiOGa70C8Cus2QCMT7mMYb+G8FbDJnjsxRUpQGBk+tpQ/tYUoCc/zYiZqVtkj5BNC0y42IFHs+4BwyJrYILPhBfGOWWpOLGzc3wGJertmMcv5AeZFDv3XyHB8h2E+SyvUX/Lez0rh1TnM/FiEfZMq9qhc7ATK6eJuc6bgU8w8+s+bB83E8HstFo5Lznf8mcYf7TD+kS9lO37c2Yptnnm39FpsV7vjCrkk/ZdjdpqrT7I8A+mb8TC4iXQuZZ2Npf
 +h6/UJaZ
 Tp+DYzHcpWFfHQfdg5MqS7FsQYwXlWmzBoDdfx2rT/bQI4NoS7gPBA5dpaz1OlNSnkDRHfMt7roWj5zMKQKK6SXrayiQfbhuQpPPh2tk6C9VrX7FZD+14oL9NClcjv5HFEmqaHigcX+w9l4XrHPwB0SQU04pWU7Klqri/oghwNCkoB3l76SgWiPALcOkT2ZlWUW9RCjih9NwuRW/GhxrgV599fH6o06lCbGorUa07rgfc6XybEu8Fqd6ouCHG++12x56KnkhOLZoBdyzEJcxgxTgiZAfFylWuMN2pBPZTHrVjQLViy9kRUGU8OiHr5qcwfxz7lDgNn1RT7vmtikmW5P5lq3rwD302fIC3UTAOyltQ8araSOg6ajdVutGy2FyNxVhdyrurpHPJcwpRY3JeJH2PqXxLm5+K+VaqIEuwxeo4qCc7GI9B8NdpRmgg6KseKv9xs5fKX7MfnWrYewFGaveBiaV9X29Px/NmcWK2dTuOPdok57rYURI5O7wETCf9XfXPTsRny9XTx3iIXh4SmO9/yaovZHJtn8cvu4zVdUSA7+RHeRgfJzHNHAqF1jDW4nMknReFwrXJO22wWEkVFBjXV2h3qRmB0sNBIO88D9mxNW79Rt7yHX7HAnMlUME9ecar
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that HWCAPs are correctly inherited/preserved across execve() when
modified via prctl(PR_SET_MM_AUXV).

The test performs the following steps:
* reads the current AUXV using prctl(PR_GET_AUXV);
* finds an HWCAP entry and toggles its most significant bit;
* replaces the AUXV of the current process with the modified one using
  prctl(PR_SET_MM, PR_SET_MM_AUXV);
* executes itself to verify that the new program sees the modified HWCAP
  value.

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 tools/testing/selftests/exec/.gitignore      |   1 +
 tools/testing/selftests/exec/Makefile        |   1 +
 tools/testing/selftests/exec/hwcap_inherit.c | 105 +++++++++++++++++++
 3 files changed, 107 insertions(+)
 create mode 100644 tools/testing/selftests/exec/hwcap_inherit.c

diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index 7f3d1ae762ec..2ff245fd0ba6 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -19,3 +19,4 @@ null-argv
 xxxxxxxx*
 pipe
 S_I*.test
+hwcap_inherit
\ No newline at end of file
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 45a3cfc435cf..e73005965e05 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -20,6 +20,7 @@ TEST_FILES := Makefile
 TEST_GEN_PROGS += recursion-depth
 TEST_GEN_PROGS += null-argv
 TEST_GEN_PROGS += check-exec
+TEST_GEN_PROGS += hwcap_inherit
 
 EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*	\
 	       $(OUTPUT)/S_I*.test
diff --git a/tools/testing/selftests/exec/hwcap_inherit.c b/tools/testing/selftests/exec/hwcap_inherit.c
new file mode 100644
index 000000000000..1b43b2dbb1d0
--- /dev/null
+++ b/tools/testing/selftests/exec/hwcap_inherit.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <sys/auxv.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+#include <linux/prctl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <elf.h>
+#include <linux/auxvec.h>
+
+#include "../kselftest.h"
+
+static int find_msb(unsigned long v)
+{
+	return sizeof(v)*8 - __builtin_clzl(v) - 1;
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long auxv[1024], hwcap, new_hwcap, hwcap_idx;
+	int size, hwcap_type = 0, hwcap_feature, count, status;
+	char hwcap_str[32], hwcap_type_str[32];
+	pid_t pid;
+
+	if (argc > 1 && strcmp(argv[1], "verify") == 0) {
+		unsigned long type = strtoul(argv[2], NULL, 16);
+		unsigned long expected = strtoul(argv[3], NULL, 16);
+		unsigned long hwcap = getauxval(type);
+
+		if (hwcap != expected) {
+			ksft_print_msg("HWCAP mismatch: type %lx, expected %lx, got %lx\n",
+					type, expected, hwcap);
+			return 1;
+		}
+		ksft_print_msg("HWCAP matched: %lx\n", hwcap);
+		return 0;
+	}
+
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	size = prctl(PR_GET_AUXV, auxv, sizeof(auxv), 0, 0);
+	if (size == -1)
+		ksft_exit_fail_perror("prctl(PR_GET_AUXV)");
+
+	count = size / sizeof(unsigned long);
+
+	/* Find the "latest" feature and try to mask it out. */
+	for (int i = 0; i < count - 1; i += 2) {
+		hwcap = auxv[i + 1];
+		if (hwcap == 0)
+			continue;
+		switch (auxv[i]) {
+		case AT_HWCAP4:
+		case AT_HWCAP3:
+		case AT_HWCAP2:
+		case AT_HWCAP:
+			hwcap_type = auxv[i];
+			hwcap_feature = find_msb(hwcap);
+			hwcap_idx = i + 1;
+			break;
+		default:
+			continue;
+		}
+	}
+	if (hwcap_type == 0)
+		ksft_exit_skip("No features found, skipping test\n");
+	hwcap = auxv[hwcap_idx];
+	new_hwcap = hwcap ^ (1UL << hwcap_feature);
+	auxv[hwcap_idx] = new_hwcap;
+
+	if (prctl(PR_SET_MM, PR_SET_MM_AUXV, auxv, size, 0) < 0) {
+		if (errno == EPERM)
+			ksft_exit_skip("prctl(PR_SET_MM_AUXV) requires CAP_SYS_RESOURCE\n");
+		ksft_exit_fail_perror("prctl(PR_SET_MM_AUXV)");
+	}
+
+	pid = fork();
+	if (pid < 0)
+		ksft_exit_fail_perror("fork");
+	if (pid == 0) {
+		char *new_argv[] = { argv[0], "verify", hwcap_type_str, hwcap_str, NULL };
+
+		snprintf(hwcap_str, sizeof(hwcap_str), "%lx", new_hwcap);
+		snprintf(hwcap_type_str, sizeof(hwcap_type_str), "%x", hwcap_type);
+
+		execv(argv[0], new_argv);
+		perror("execv");
+		exit(1);
+	}
+
+	if (waitpid(pid, &status, 0) == -1)
+		ksft_exit_fail_perror("waitpid");
+	if (status != 0)
+		ksft_exit_fail_msg("HWCAP inheritance failed (status %d)\n", status);
+
+	ksft_test_result_pass("HWCAP inheritance succeeded\n");
+	ksft_exit_pass();
+	return 0;
+}
-- 
2.53.0.239.g8d8fc8a987-goog


