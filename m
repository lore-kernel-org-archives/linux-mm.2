Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E6F606A324
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XPb67244
Received: by kanga.kvack.org (Postfix)
	id 50F326B05B3; Mon, 26 Oct 2026 16:54:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499396B05B5; Mon, 26 Oct 2026 16:54:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AF516B05B6; Mon, 26 Oct 2026 16:54:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07AB46B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:54:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FAD21208ED
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:54:12 +0000 (UTC)
X-FDA: 85365979944.16.09FD29E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3B61EC000D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:54:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XPb67244;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793048050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bMnT/4trapZ7pJUm3w1Qwlc7Feo2DJc90apJ/xjlYRs=;
	b=rn0ZsMg6N3ACZDC1+rICeAtLvnwPh0aCptHPWvkSRIBfAvLosT3opx/VwOaJk/C1/1euhj
	NwqKmKAff0Xc40GBix2vkawbvbfBiKBZm7YH0GQPEG37jWge9qJS8I/LjUJpsUYycDzvYT
	bnM0qV4CghL3q7GGrsPqEBOYn7ocS5I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XPb67244;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793048050;
	b=FzD0NThJGgW1hSls3h8Ka0It+PixQ73fNvGLMgjE45omFWbytswnkFRE4lBeeGHkqL42xP
	P2IhdinoekeWTd73HH/k61vG7ESABLP36JNLpaePAbGXlF+bF3vqlMhnMGUzA0lyTz7aVU
	Q1syIVqBQliZwIhgSKc7tPY4HMy3OQU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 049E643B3A;
	Mon, 26 Oct 2026 20:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBC61F01829;
	Mon, 26 Oct 2026 20:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793048048;
	bh=bMnT/4trapZ7pJUm3w1Qwlc7Feo2DJc90apJ/xjlYRs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XPb67244qTZDbAZwCKsjKX7Wa43nK9Yl31/j58LBJZCBq1c61pQCUJCUnj1+RkLuz
	 KCa2wz280Wxv+llBXjpmtki+bWqrp/LxirJXr6cmYGNJd6ECSUNMCKwwXY1RpuYs9e
	 bJB6A7vT9iez9Cqx1124jczOaQac9gqrMtwb427/MIYaC/ZlFXk2q0YY8uNf30KfCt
	 xBByToK7cwWUPVtzPT9WdpVyt7QbNMzKxO1hRf5OfwcIMhNdK5/K2WV6tsNSIXACy5
	 gIyIsh0BR6sAbzh8f9RhgdPZnzQCk94hUiYki3hqJaUb/9YJppO1B7XXqVRCmKIyGS
	 wM29CWwVkcFcQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 26 Oct 2026 21:53:30 +0100
Subject: [PATCH 2/2] selftests/exec: check that user namespaces keep the
 exec securebits
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261026-work-securebits-userns-v1-2-b35473fa1a34@kernel.org>
References: <20261026-work-securebits-userns-v1-0-b35473fa1a34@kernel.org>
In-Reply-To: <20261026-work-securebits-userns-v1-0-b35473fa1a34@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: =?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
 Serge Hallyn <serge@hallyn.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Jann Horn <jannh@google.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3798; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nECyytmiEdouw3xcpnbysOjPPBsO49O6sByTJMX2B9o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTd3/si/8v/bbE/rqxrm8J9h9dyM4d8+sG9j31/as0M2
 zupTibuXkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEXoQzMtxSY3BOvzR9j14m
 p4rLmem74+TF0950hax6ue3H1Fe6yh0M/0tr7FNP1J3WFqhbPEE9k3PhIZetqod+77taYufnprD
 xMzcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 3B61EC000D
X-Rspam-User: 
X-Stat-Signature: 3qr4hbuydtwsejut85toyhigbsm17ju4
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793048050-86168
X-HE-Meta: U2FsdGVkX1/JIgoOEys6qM6O4m141PiuAhhDSxiD32MINHNO2GIqpMzPlODxxvwE/7xoiUllrkPGksvsf//QAq7lps0HfFwCdFl6z1HS98OT8LW7PzsOeoIapxNG499dje18RW5BtZ5kNyZMVYMIIpw86jQFi7QKekwzcY/7WzX7b0QCzPdTsRovv6vsQTsM/oDh5S3gEGXMye/rpROE5862xBMDuWdoi3BP6lBl9iY7ZbbHKC5jCgj0IZMWhycfLC+yfY1XBl+49EEmDwmOcTh/yNWA4kB97i7Z5MjwtugjaG+fUIHjQ9MJJqmEbJTdjCwAO8hfdpVmdgjIkmvoVZEgO3i4E/2U1G1cb91pMJQEof+HJPPmVFVJuNunGtlUI8Jsrd9g7ZdmJ9oAU5jYk46YwKtOkI5Pkh5TqdZwITdDzv7tvZ5x+9ZU4F4f2tChzPBADr/v3OTKcdvaZbzoilVoj8C1e+J+h0ovgtoQSJyZ6Nz8Uw/HDjatGh7tmZIzm/hneE++Ebnoqk/C1Qhtiv8HQ0eDfqezn+Je9sSpXTPYSFdAf8miuUjOpOTs2+S+dgVDhb+gdbWWOXCqo9Pl5v+3T8tq81CLSDZeosUKFqt34A8jPXhHswAWpPSNMZHxQP1yEs4zhjE4pcD1nqUUDQk+PiHe+AHwLWTY+YniT3lyle8Lv+oWYalSmivHNGlZGKuyXsDoOWF5JhsLl8r+POAh2yD5446Tm+mk+ddmOUC49JRkaaBiLEXNVKBHpYhvgEfElLyqnRniiDX9dGhB4k8girAndh2wWoFVEDeZ3061MhkMG+MCT+4WL8PETRXPGS6rvEz+1T5eGMhibhpBus1WB7S5JF45f3XWbCam8V5tIYD7nfhcS1vlu5GHSQHrTiEM8qMgcdhdOS+h0aICYpKy47LT8csyuy9+6gtFxriBaVIZijq3O99apbXDpzF4RkkszSoQtVaACQOfgP/
 x/vfseV6
 CxAfXRBeSkwyxiUNuGZ/u99jLE15KJT7PAOrR2iGbfHwB4Lg5AROh6gz7JoCIlpiLlxpl6gfkzySMSx3Q/EUpkGVugVh10mgtTbTtcKxn/igHoAaTWVQZgEDtK2FK/rhYIlGXCPhQXt9wGJMulLF5Ur2vx2WaHQucwmIsi70TePn1JPVYBt/dSgkK9oiqXSgRgTEmNIdruUqsG9rPo8a/9pIH3zcTsOa0fba3PUPfVgw5FEhrUqaXZfH4FKsPjSI2M2ajUzIJt7cdq8AJ7HUJN+q1F4mHAxp9QHTDCapLdGAvshwqp7pmXnbtO2DHlmGqezSoZMtD6ZjBIEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Check that the exec securebits survive creating a user namespace with
unshare(CLONE_NEWUSER) and joining one with setns():

- both bits with their locks, which can't be changed in there
- both bits without their locks, which can still be cleared in there
- only the locks, which keep the bits from being set in there

The other securebits are reset as before.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/exec/check-exec.c | 83 +++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/tools/testing/selftests/exec/check-exec.c b/tools/testing/selftests/exec/check-exec.c
index f2397e75aa7c..5753c657808e 100644
--- a/tools/testing/selftests/exec/check-exec.c
+++ b/tools/testing/selftests/exec/check-exec.c
@@ -10,11 +10,13 @@
  * Author: Mickaël Salaün <mic@digikod.net>
  */
 
+#define _GNU_SOURCE
 #include <asm-generic/unistd.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <linux/prctl.h>
 #include <linux/securebits.h>
+#include <sched.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/capability.h>
@@ -24,6 +26,7 @@
 #include <sys/stat.h>
 #include <sys/syscall.h>
 #include <sys/sysmacros.h>
+#include <sys/wait.h>
 #include <unistd.h>
 
 /* Defines AT_EXECVE_CHECK without type conflicts. */
@@ -460,4 +463,84 @@ TEST_F(secbits, restrict_locked_unset)
 	CHILD(EXPECT_EQ(EPERM, test_secbits_set(0)));
 }
 
+static const unsigned int exec_bits = SECBIT_EXEC_RESTRICT_FILE |
+				       SECBIT_EXEC_DENY_INTERACTIVE;
+static const unsigned int exec_locks = SECBIT_EXEC_RESTRICT_FILE_LOCKED |
+					SECBIT_EXEC_DENY_INTERACTIVE_LOCKED;
+
+/*
+ * Checks that the exec securebits in @exec survive creating and joining a user
+ * namespace, and that in there they can be changed exactly when they are not
+ * locked.
+ */
+static void test_userns(struct __test_metadata *const _metadata,
+			const unsigned int exec)
+{
+	const int error = (exec & exec_locks) ? EPERM : 0;
+	int ready[2], done[2], userns_fd, status;
+	char path[64], c = 0;
+	pid_t pid;
+
+	/* A user namespace owned by us to join later. */
+	ASSERT_EQ(0, pipe(ready));
+	ASSERT_EQ(0, pipe(done));
+	pid = fork();
+	ASSERT_LE(0, pid);
+	if (pid == 0) {
+		close(ready[0]);
+		close(done[1]);
+		if (unshare(CLONE_NEWUSER))
+			_exit(1);
+		if (write(ready[1], &c, 1) != 1)
+			_exit(1);
+		if (read(done[0], &c, 1) < 0)
+			_exit(1);
+		_exit(0);
+	}
+	close(ready[1]);
+	close(done[0]);
+	if (read(ready[0], &c, 1) != 1) {
+		waitpid(pid, &status, 0);
+		SKIP(return, "Cannot create a user namespace");
+	}
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/user", pid);
+	userns_fd = open(path, O_RDONLY | O_CLOEXEC);
+	ASSERT_LE(0, userns_fd);
+
+	EXPECT_EQ(0, test_secbits_set(prctl(PR_GET_SECUREBITS) | exec));
+
+	/* Creating a user namespace keeps them... */
+	CHILD(EXPECT_EQ(0, unshare(CLONE_NEWUSER));
+	      EXPECT_EQ(exec, prctl(PR_GET_SECUREBITS));
+	      EXPECT_EQ(error, test_secbits_set(exec ^ exec_bits));
+	      EXPECT_EQ(error, test_secbits_set(0)));
+
+	/* ...and so does joining one. */
+	CHILD(EXPECT_EQ(0, setns(userns_fd, CLONE_NEWUSER));
+	      EXPECT_EQ(exec, prctl(PR_GET_SECUREBITS));
+	      EXPECT_EQ(error, test_secbits_set(exec ^ exec_bits));
+	      EXPECT_EQ(error, test_secbits_set(0)));
+
+	close(userns_fd);
+	close(done[1]);
+	EXPECT_EQ(pid, waitpid(pid, &status, 0));
+	close(ready[0]);
+}
+
+TEST_F(secbits, userns_locked)
+{
+	test_userns(_metadata, exec_bits | exec_locks);
+}
+
+TEST_F(secbits, userns_unlocked)
+{
+	test_userns(_metadata, exec_bits);
+}
+
+TEST_F(secbits, userns_lock_only)
+{
+	test_userns(_metadata, exec_locks);
+}
+
 TEST_HARNESS_MAIN

-- 
2.53.0


