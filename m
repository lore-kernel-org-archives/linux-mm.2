Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A401CEFCD9C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70AB6B0093; Mon,  9 Mar 2026 07:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31CE6B0095; Mon,  9 Mar 2026 07:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50246B0096; Mon,  9 Mar 2026 07:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A15EC6B0093
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:55:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 645B81B6C8D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:04 +0000 (UTC)
X-FDA: 84526368528.25.A819EEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B23C94000B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j82uKpnm;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773057302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CqI3vHzakqI8orNexuCGvLApPCcAy8fd8/ne0QNbIHw=;
	b=4EhbNDZwjXUCTckD8864ticS/OWEJZ1wIE+LZw34w8IeicUE3zFMRzsAfjsXKPIaw2jPWn
	rPoSHJeuvdBClpWvOwCzWgdTYpbd34qXIl0GpM7ckI3kFSg6B4PuZF3n7uZ0LMFXgagWqH
	Kdx2ZI2kQFJVobT6Ixb89pC5xQEuBNg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j82uKpnm;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773057302; a=rsa-sha256;
	cv=none;
	b=lC6Oe0/BAGVqdMvc2IcibgDQchIAQTMT1Qo1ZNHF+tZ4DZLekmHDcrPiqGS6xeRSB3mszK
	ErwaKXPoBdaCqCt10SI8DebCVj6Tzs+TWGNZPxuVDJr8L2sottXXQTGE8+vlNAkQrvxMmq
	R83bsgAPM/hsgJwvKDc81yEWvRTOliM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D7DA543FC9;
	Mon,  9 Mar 2026 11:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E261CC2BC86;
	Mon,  9 Mar 2026 11:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773057301;
	bh=hQMT5ZnC+kM/6V8s8lr4xcjgalTDxyHP1vCCvJobalc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j82uKpnmoFrUvTTCkoOY17tPF5sZCZegqhK196oh4IOsYj3uxdMJQPO+xEB8+B3Jv
	 EUVZElGrUZiu/ZK/gUwawNjkf8ZO9XtmtVH2FxLFvzTDmoEAOknwNOUPN1rT1Z/Geh
	 kiIeGzV/ncOGHcFH2dHL22L53TeXvzNulh8dW1JBHbPAWb5C2WSU2SMiexIjc76usk
	 iNLRP6UHbVU7hXOaUT+d2nO6Utvc0hFkdGQs0N+6emPi85eiI1/BCZCRlcgTqBmM/W
	 Gdd2vlVAO+vxY+41HKbZSqnKWprM5Fw58Qt2XgG2P5j6lL+kV46PQFpGwUONvGVdx4
	 8b0CfuywmTEog==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/6] selftests/liveupdate: add test for operations on a preserved memfd
Date: Mon,  9 Mar 2026 11:54:38 +0000
Message-ID: <20260309115441.266805-6-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260309115441.266805-1-pratyush@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B23C94000B
X-Stat-Signature: gmz4nqj4t15wqj91zh5q4gmigr1h4jpj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773057302-871071
X-HE-Meta: U2FsdGVkX1+I8vecZAf4uhcjKzPn7XC0o612z9yUqIiUZ1XGTTBSrzRZdaXXL4v0y/R1inO1V2StyLXJmduizuYPqA809aCbd2Y54e+MUtvFBlql1VY6uU7VNIKDLOPuPKygCf6P6jR1Z3Fh3cK3KPyMZjAhOjiGjqLfUzop5FLmcAuh8BS3tSOveQt3oiWNV+TWOQauvWwbCgH7PAwkYO2ovrxdb0c7RqDdi2QXY3SKdsAeT3jCY8X6n+MkUINSXAbrrFwRd26OD7qCotm72G18vwETUZBdILCNOyHQ02R/QPv4hCbPM5MfaQ/FIP1AVUk8dDlsmfcdajy7FPfAkaxMrqi8EXTAKaEcCbtATB395d2qPRW0szAcNZYtRFihXwwDmUYvDSGv1vlqRWBIK1VpxIGqsBc3DoKFsblFpH4OQB96sdlMOA7id+zu+fbroYLfqZ7LxPeG6BKio7to24uL8MVnjZ16czbcUPFK33JfTUwzCRXbE5qlMQwMJfGWTuzxBos6P8YSZ79qhzRw9mPyjvQiTdv8zCAQBYnwBO7yaDDCnzHwQHmtZelrpZ86cJonlYCsz3NtQRzgbfatwyIsJ0wR7zsRJm3MEcLAGOg9AIlqR5s4nLZ7d94VGY0bA8jlnGr8/+hEQ2FNdr05+h196r6u6FvD5diWkOx87AzacPw7+NH7uM29IX3srhyfEbaBja748yuCy66g8R0KzjEFl9T9rfZOuvyIDppXrC4z2XqmxnTw/JEfEKEMQZNlt5jARfJx4jrX1zJRv0MvSh5oyzqKzy1hPM2P8zAxNl4ADOizGw1RKa4FinuRXzz+VN7HAwiIUBzOjIjUBTXiautjfICBTnS+zKnfxqNXMcykO61utUuR5MKEIYMlhsHL7hMzU4CHJTPxpuybU66lYgYzp5Gf58cA9yi8Npkmx1+eG9HgCmGKNwjls8PxA9U1Kt76CLJAe1y3Svxubn8
 Q9sYh5DX
 aFlUAd9xM6tetf7lT2+r2ngcXOQurmcMby30uMsOJ+NK1GK/jQgs7REUixWI7/AGAd3LW2F+BF8Rz/ShJ8L8pb2Fe6upyvyXLyeYs6Lm4hdHavAb9pYVHRMb23W8kAx+MVAI2IfFtcv8sEfI+0vdlN1ISELC9s15vOcgfOMwyHn4hfJHkhYm1lB6TI1K9n2rMWzhIwsOFYr5rQEI6JS8VSk/XEmcqoXbgZ9h3F7VLyP2xfMA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Once a memfd is preserved, certain operations are not allowed to
succeed since they might make the state of the memfd inconsistent with
the serialized state. Among these operations are truncating or growing
the memfd. Writes and reads to already existing memfd should succeed.

Add a test that makes sure a preserved memfd does not allow growing or
shrinking, but does allow reads and writes to existing memory to go
thorough.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 .../testing/selftests/liveupdate/luo_memfd.c  | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
index 56106cd09978..75f88101e7b5 100644
--- a/tools/testing/selftests/liveupdate/luo_memfd.c
+++ b/tools/testing/selftests/liveupdate/luo_memfd.c
@@ -39,6 +39,10 @@
 #define ZERO_SESSION_NAME "zero_session"
 #define ZERO_MEMFD_TOKEN 1
 
+#define PRESERVED_SESSION_NAME "preserved_session"
+#define PRESERVED_MEMFD_TOKEN 1
+#define PRESERVED_BUFFER_SIZE SZ_1M
+
 #define LIVEUPDATE_DEV "/dev/liveupdate"
 static int luo_fd = -1, stage;
 
@@ -136,6 +140,59 @@ TEST(zero_memfd)
 	}
 }
 
+/*
+ * Test that preserved memfd can't grow or shrink, but reads and writes still
+ * work.
+ */
+TEST(preserved_ops)
+{
+	char write_buffer[128] = {'A'};
+	int fd, session;
+	char *buffer;
+	struct liveupdate_session_preserve_fd preserve_arg = { .size = sizeof(preserve_arg) };
+
+	if (stage != 1)
+		SKIP(return, "test only expected to run on stage 1");
+
+	buffer = malloc(PRESERVED_BUFFER_SIZE);
+	ASSERT_NE(buffer, NULL);
+
+	session = luo_create_session(luo_fd, PRESERVED_SESSION_NAME);
+	ASSERT_GE(session, 0);
+
+	fd = create_random_memfd("preserved_memfd", buffer, PRESERVED_BUFFER_SIZE);
+	ASSERT_GE(fd, 0);
+
+	preserve_arg.fd = fd;
+	preserve_arg.token = PRESERVED_MEMFD_TOKEN;
+	ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_PRESERVE_FD, &preserve_arg), 0);
+
+	/*
+	 * Write to the preserved memfd (within existing size). This should
+	 * work.
+	 */
+	ASSERT_GE(lseek(fd, 0, SEEK_SET), 0);
+	/* Write buffer is smaller than total file size. */
+	ASSERT_EQ(write_size(fd, write_buffer, sizeof(write_buffer)), 0);
+	ASSERT_EQ(verify_fd_content(fd, write_buffer, sizeof(write_buffer)), 0);
+
+	/* Try to grow the file using write(). */
+
+	/* First, seek to one byte behind initial size. */
+	ASSERT_GE(lseek(fd, PRESERVED_BUFFER_SIZE - 1, SEEK_SET), 0);
+
+	/*
+	 * Then, write some data that should increase the file size. This should
+	 * fail.
+	 */
+	ASSERT_LT(write_size(fd, write_buffer, sizeof(write_buffer)), 0);
+	ASSERT_EQ(lseek(fd, 0, SEEK_END), PRESERVED_BUFFER_SIZE);
+
+	/* Try to shrink the file using truncate. This should also fail. */
+	ASSERT_LT(ftruncate(fd, PRESERVED_BUFFER_SIZE / 2), 0);
+	ASSERT_EQ(lseek(fd, 0, SEEK_END), PRESERVED_BUFFER_SIZE);
+}
+
 int main(int argc, char *argv[])
 {
 	int session, expected_stage = 0;
-- 
2.53.0.473.g4a7958ca14-goog


