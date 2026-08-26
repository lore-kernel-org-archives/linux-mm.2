Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D95C6C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 15:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0726B008C; Wed, 26 Aug 2026 11:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C556B0092; Wed, 26 Aug 2026 11:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623496B0095; Wed, 26 Aug 2026 11:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 383FF6B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:56:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B255C1A0188
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:56:07 +0000 (UTC)
X-FDA: 85143871974.03.59B43CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E360F1A000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:56:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NpNbeG7Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787759766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AJOXS7+FmhIjs+QHaVJiOWkg62Yl8bLA9jCz7ES/Zg=;
	b=IIJOKE3sgkgw4Z8z5Ch+uO2JzfrIPBbLRLRY8iTBI6JuPj9/eubhYORNgdDZ9MrW8ORiDW
	zTjskx2oXtM+6RVKSXJFIZL/ac9I4TkPg5NBkXa79wsy1JWUs6ATmJBdrtcP0DFpieLbP0
	8CX7u9zq/Ivu1BJC3AMOWGaoKQcV4bg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787759766;
	b=e8lB/K+NIxwbw0iBBKd346igmDt12E09vEGIljPGwbVJi3dlD7DjNkNvgZaF4ttK56Go/d
	Rckrt/CYJvZXeGXlXS1TO33zky3s321GakdjkJM1nPXxZcy8FHway9SeSDfpgACoW6eKQQ
	37If0GSEeWEgXAWgfrHkk3d6BIIQ6u0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NpNbeG7Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD41C43CD0;
	Wed, 26 Aug 2026 15:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620831F000E9;
	Wed, 26 Aug 2026 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787759764;
	bh=7AJOXS7+FmhIjs+QHaVJiOWkg62Yl8bLA9jCz7ES/Zg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NpNbeG7QIzDMh6RL6aLU7mL5L8eblE+RXsu59K3or1cIT0ZfKd6YOIDldAxxy6PsE
	 EKZ0/lzI5WH+IZz6S0byhCGimtJ3IlkiBMDu5AMkI9YcIhc4AIK/OYehGL2njx790N
	 FOk1APnd++One2KJ3LZs1dJGUDj1U7eF/a0MeAz/hHa0uqe3oGVF367wiTZpDwupia
	 479kDzuC33TyZz+o9T+67z/py39Ob7GIS7CaTVuWlGk8SO/Ixn8WObgJ6MCU7m0JXY
	 0L5Rbs52IrXmUWlxZSX0rhNoDsqpg2eGreTy7U9pOfS2ddDFHkZD4YC1sQ0s+3hdmP
	 XRPJqbdPBUD/w==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 26 Aug 2026 17:55:47 +0200
Subject: [PATCH 2/3] selftests/exec: test delimiter restrictions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-work-binfmt_misc-delim-v1-2-43618adf8599@kernel.org>
References: <20260826-work-binfmt_misc-delim-v1-0-43618adf8599@kernel.org>
In-Reply-To: <20260826-work-binfmt_misc-delim-v1-0-43618adf8599@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4526; i=brauner@kernel.org;
 h=from:subject:message-id; bh=653qz3nDY95B3k6oyXltdsVnQQkTWcEE8ubSGxx0fbo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT183RnqfOu+t3y0NQ09cTdpOdv9ixyur1gv9XrmKMHt
 775dbrtT0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEousY/ju+ZDrk1WCvmp42
 6xXbpikMBZ9yPEI+PnQ9t2KRxaZYx8eMDBvqXbqXrGSVy55oudc2vvvm4xtJl5peJ638f+Hr/wu
 PJBkB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E360F1A000A
X-Stat-Signature: fjpi6gz33xfuauwnfhisayrco5ufwd8d
X-Rspam-User: 
X-HE-Tag: 1787759765-394424
X-HE-Meta: U2FsdGVkX18MPfMkYpSuE3jIhG91pXiBoXNOQtEeKO13c4m3UI4xB7BgNCDDT7Tyhdft0c0tJI7Mc/YSlLb4OXgP5ISWf0h8bw8DXgFEKpK30+1bk9GsLIO/mYkFvfK/cFyVoTo0s4g3wU3qBRyRilWtf6OQINzftqsWRhSQ4RbdHRjZgTYa19B1CSR4g4IAVATV4+6mc/RaxBM+gSkjThAwZTsU4Xc1zkqX5EbhIQnCCuDvt7jHuTvmgIk1mXxehexuacgYM95hEz++wLHLavr1FeTEBLdX1FNCtEv6J/ZEwWwK8Q0Bskt49FDI9hjhHp0BZxpI5f1lAbVEZhT5nd+H0FE9DEyolHHgq35mQnAi8Z2g8FBt4ILp46ShtgO5Kuzzk6gkOfKo4/z+mNLyOcu3J+f5aJkNSOJ6Gi71i7uvR+59Zn64ZqXAXJzs+FebL4X3KvmNbwnVRo8DoxjtSY1dCAFSHq5Hn2JWxocRKtO4fLY3gz5+5T0kBeEogjCP8iknrWqE9KCfopIVsFVAa1CrpBXov7aGw1y64XuEWHSFmKYos2V3ONA8F9FsW1+h+903Qz3kLB5f6qCiM1Z7Nw12n2onG0ec2TnYNuyoKv0zknJ6DUxDyKyQueFtIXKR339jbUwjqmSMUw5qcVEWs6pkgu+Z4ah/BPVmr5GTNbfYU9i8hKLMOvdB7lH7Pbch2JmlfN1y1RetQIyDSluWO0l/m/4xz2ymJjsqFs3qoyFMAPwB7fQsitldn6QszNh7MRaJDw+cevZQvdm4DJOQRnDznZXekWDBPl16p5ex5u1tKh5FiRquH9+0VxmHM+XNnmV9pXrbw2aGK0MfWcMvJk7uSKYXAciOCzsiqUS9ebwk4hCWo3O/BKyscydroHWqgeTjBzXMUZ96QrN7OmqEKcYPlf42tR5aTsBc5LOxpNZ8I5pzH8DJdTxjbSrRqAIR29RJfllKIP+B6QjTaII
 0ftWZnfa
 Xxo8XCbfkK5j80C06l8KzofKy3YndHUQ+2BHtIkCw3KRtI7Cm8ZWUDeYVark+/uuLtzOmW118RPkVCffh1syGXVWhzyM0D/OTlcFeSm0zXZ/SErDeq3USfrbkXvo/VMoi96BnBDmvVM7o7rhJ74SIKGMbaY/lI0L/rlnI7ODjyo/P+yeZF9OVY2Fdp8UfrIV3NxRBtzqZ08MT9oJCNis5xQ5HXhy0zrB3kSV4MfOSe+mxuR5cJkQ629023vV9DkfUYDw1DUZlMxiHx3UrOZlSzahUZzAq2C6usxxb0XzcLtye4LVgLf+GSvHi+Emrq0M6Cgi4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test that the new delimiter restrictions work.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/exec/Makefile            |   4 +
 tools/testing/selftests/exec/binfmt_misc_delim.c | 127 +++++++++++++++++++++++
 2 files changed, 131 insertions(+)

diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index b640af8f02b5..2220ed345e92 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -45,6 +45,10 @@ TEST_GEN_FILES += binfmt_transparent_interp
 TEST_GEN_PROGS += binfmt_misc_loader
 TEST_GEN_FILES += binfmt_loader_payload binfmt_loader_payload_static
 
+# Only ASCII punctuation delimits the fields of a register string, so a new
+# flag character cannot change which strings register. No bpf toolchain.
+TEST_GEN_PROGS += binfmt_misc_delim
+
 # binfmt_misc bpf-backed ('B') handler test: a libbpf harness plus its
 # struct_ops objects and the test interpreter/app it routes between. Only
 # built when clang, bpftool, the vmlinux BTF and libbpf are all present
diff --git a/tools/testing/selftests/exec/binfmt_misc_delim.c b/tools/testing/selftests/exec/binfmt_misc_delim.c
new file mode 100644
index 000000000000..ffc17cb78545
--- /dev/null
+++ b/tools/testing/selftests/exec/binfmt_misc_delim.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test which characters may delimit the fields of a register string.
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "binfmt_misc_common.h"
+#include "kselftest_harness.h"
+
+#define ENTRY	"bmdelim"
+/* Shares no character with the sets below, or a refusal proves nothing. */
+#define MAGIC	"bmmagic"
+#define INTERP	"/bin/true"
+
+/*
+ * ASCII punctuation without '\' and '/'. The backslash is refused because
+ * it would cut a magic that uses \x to escape short. '/' is accepted
+ * but cannot delimit a rule that names an absolute interpreter.
+ */
+#define PUNCTUATION	"!\"#$%&'()*+,-.:;<=>?@[]^_`{|}~"
+
+/* 'M', 'E' and 'B' name types, 'P' through 'D' are the flags. */
+#define LETTERS		"MEBPOCFTLDqz"
+#define DIGITS		"0157"
+#define WHITESPACE	" \t\n"
+#define CONTROL		"\001\033\177"
+#define NON_ASCII	"\200\244\377"
+
+/* ':bmdelim:E::bmmagic::/bin/true:' with @del in place of every ':'. */
+static int register_with(char del)
+{
+	char rule[128];
+
+	snprintf(rule, sizeof(rule), "%c%s%cE%c%c%s%c%c%s%c", del, ENTRY, del,
+		 del, del, MAGIC, del, del, INTERP, del);
+	return write_reg(rule);
+}
+
+/* No character of @set may delimit a register string. */
+static void expect_refused(struct __test_metadata *_metadata, const char *set)
+{
+	const char *d;
+
+	for (d = set; *d; d++) {
+		int rc = register_with(*d);
+
+		EXPECT_EQ(rc, -1)
+			TH_LOG("%#x delimited a register string",
+			       (unsigned char)*d);
+		if (rc == 0) {
+			unregister(ENTRY);
+			continue;
+		}
+		EXPECT_EQ(errno, EINVAL);
+	}
+}
+
+FIXTURE(delim) {
+};
+
+FIXTURE_SETUP(delim)
+{
+	if (getuid() != 0)
+		SKIP(return, "test must be run as root");
+	if (!binfmt_misc_available())
+		SKIP(return, "no binfmt_misc");
+
+	/* A kernel without the allow-list takes any character but a flag. */
+	if (register_with('q') == 0) {
+		unregister(ENTRY);
+		SKIP(return, "kernel without the delimiter allow-list");
+	}
+}
+
+FIXTURE_TEARDOWN(delim)
+{
+	unregister(ENTRY);
+}
+
+/* Punctuation delimits, which is all anything deployed ever uses. */
+TEST_F(delim, punctuation_accepted)
+{
+	const char *d;
+
+	for (d = PUNCTUATION; *d; d++) {
+		EXPECT_EQ(register_with(*d), 0)
+			TH_LOG("'%c' refused with errno %d", *d, errno);
+		unregister(ENTRY);
+	}
+}
+
+/* Letters name the types and the flags, so none of them can delimit. */
+TEST_F(delim, letters_refused)
+{
+	expect_refused(_metadata, LETTERS);
+}
+
+/* The offset field is written in digits. */
+TEST_F(delim, digits_refused)
+{
+	expect_refused(_metadata, DIGITS);
+}
+
+TEST_F(delim, whitespace_refused)
+{
+	expect_refused(_metadata, WHITESPACE);
+}
+
+TEST_F(delim, control_refused)
+{
+	expect_refused(_metadata, CONTROL);
+}
+
+TEST_F(delim, non_ascii_refused)
+{
+	expect_refused(_metadata, NON_ASCII);
+}
+
+/* The escape character would cut every magic that uses one short. */
+TEST_F(delim, backslash_refused)
+{
+	expect_refused(_metadata, "\\");
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


