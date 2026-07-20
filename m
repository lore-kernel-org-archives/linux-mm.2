Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C06C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6036B00C3; Mon, 20 Jul 2026 05:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76D36B00C5; Mon, 20 Jul 2026 05:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D366B00C6; Mon, 20 Jul 2026 05:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90F196B00C3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B6131A07B7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:11 +0000 (UTC)
X-FDA: 85008643902.17.AAFEBE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5881C20003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oHVrmoyP;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFBaQnb/LBlrKb7K7tX5A2RAZo96JQCMyZ4CUU0AmMI=;
	b=Kkz29E+B83kTETa8Zuui8aOvQzvarWulUYDE+zQnOTLKJ09ffsRWmAHjuBflTHG9XIgQps
	WZ4Y9B2wvAX82Qc4A2smhTUziMES1Z9MM3pvqYFuBwdeko2pFKTiPOn0YZVup/LR2p+2Ul
	3nmQhFoHirETBJTQLND1ABeQ2ucMKz0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oHVrmoyP;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540049;
	b=RIN1ZVIoE8gg41gtvGKi9hFip8r4oJCn1B0wtuexMNqrh0ewuK+p6786eTQQyzIt+jNm2d
	xlAOV/a1uZCojnbNzbSqEsqJOkHEroPYCsNjnZdCnBjnw9/yQ/w0U98Wru5Yu/CVOpguiW
	X57rLxkxgIGEmEp75M0jgavf83fFN04=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E9CF8601D9;
	Mon, 20 Jul 2026 09:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BE61F00A3A;
	Mon, 20 Jul 2026 09:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540048;
	bh=lFBaQnb/LBlrKb7K7tX5A2RAZo96JQCMyZ4CUU0AmMI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oHVrmoyP44Wp4dlQhYjgpP+dQ6qRvB04VzA+3+aTIIxED/50lEuCDss0uCKmtjIev
	 Uocmj6D87RhEteKLWL2MXH8YJxgZ4fDVLgYpfq70LzZxve0+Utz/Cs3Q4onz3BGDL/
	 EfMdI3ixgKdT0hBY2Oc+zd2YqYbIv6WJPLQaPiRTSYYa3rd68yQrag6UDCNWKH8ZVz
	 mSDeDe6nlXzlFKTS7BgydAp1ExXnXBjzcXFLbPIvA0KGO2Q1Xm/50EHyYvBOvfumae
	 oZ5q6uwRI2o5NQ1IeYdx+R6/qGikBLwdRd2JueuihYGVRVnClVNQYqMWadZ2D1exTP
	 a1LO1jUYPYi1g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:26 +0200
Subject: [PATCH 03/21] binfmt_misc: table-drive the register string flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-3-ddb76c9a508e@kernel.org>
References: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
In-Reply-To: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=6012; i=brauner@kernel.org;
 h=from:subject:message-id; bh=r9+zVZZXPXLbK/80ip4dEc0nKwHr02jbr/6VIF1VMGI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm5K79I/GvdVXE1YVv9xKsPXLwxLZ4oqbz36exNnQ
 Myq/49vdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzky1pGhu4lN+LsxBPDD1vE
 zf12UGX5v6pz8/8/XnYq4vWCQ83C+hMZGY5y5l9OnbrLtDHP73j4qzObJ8QvOFW4rKnB9skLu6c
 KurwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5881C20003
X-Stat-Signature: jjxu33okp8gdrefttib5wrh3rxib99xh
X-HE-Tag: 1784540049-208056
X-HE-Meta: U2FsdGVkX18bmZa4IOpZRtcD+EeuvvwrG9ua3Fk2SFRSebra39UEMBhP1Gs9sbYjF6PRqFNZM3XmUbPpgMhg2Fzqa41tzh/9X00cy5mhdyhh7RmssVKiWt20V7qYnN4A9Nvo25th1ddegG/lUbD0tuQmHulLeMWs+YWJbMQ3uXoQlpvLPBjd8i1VOHUbl0xdHcT43uhkN/kfm8C99ZGAkPeZmxX0EoaN5DSXgpxSQh37TYRbmTt7uZC2rBTcrmJM0Jk5Tu4BZGK8rDxdgFg+6J5vLsfya2YXoN09uLe0MMnvxAhNGa9U5iTvahEeNox70+Y1oO+HSqwRtCyvRlxQurbAhnIs3PTmAz9bby1vF8v7WmlCdQzfkyucdE4+0eU4ghrCplm62ToRALxCM/migMQkVSJEeLkqt3hjEu5haca3C386S2nNhFHJ1Z8skY3kuSwHz/SQMUalT4/3mA1SqsoPeNBfFF+J0QLY5wzSG1kelJqTGjaAwjcWj6HQfrD7OPgGoL9kLk3dEyO/J4aMQ+zZBAaaaF7gRee2KvpnzUOA+6Or3jbvJwUIecnGV+IfwnDJa3OmUBM5FWy48Yqvz/rehX46Z4jppbnzfImpmQYqgDNGhDY+6QPkp17Y4tDyM93YB2pDiEQtBZUYpzJN3qxqvHxRmjHAYDuwF3qRXOp4GDL3MENNHK00GSUK1GQ9pxi969k6ds9Irh72o7HMZn4w1fXlQMz3xru4KyqFs+EKh4HKcWzKC8MIaQMKODMpNglDXR0pklPDtVmnm0xe8r0wIDIX9bfVdHjXZe12vTjk8+7ZxIv2ZY8Mn6Zey4SVrnUPiMc+UwXx1asb492GjpFUxaOdqUTaW+rJPuo+Q24pIWnMS1eRK6r0ft91poGgT9FdMaZBKG2F/ALKwPLGwqZrJVyxHqj32xE7eIO0d1MEhjxkA8yMDgKlIZPucbb8STynjikllN92bGIRD/G
 vOfPRHoy
 nqKRoWnvpr8ErLor4te1Y5LM2Ln3Q6S2LestoQzeuUifPqfqdLxf99UNLkZb8p3zVP1E2mubXi/F7QCYYlL2+GPRrom7hYSXC3cU7FWLOP7a+9tGgLYwqiHeeK4kbNKpnDfbWNVLJvsm4q9qUEgXq5/jbAdELJ/0pXVhnGdLaDcWNy2YGsUCmik1fzLzMmF7W3zKw2TsqgaGXRaCrbzAkCV5rwSw36JUSDOD2O/6qPD285XzBWHfh1sQq+THaJ/GjttDDqUUSAqDTfYwq478ikULpj8mAcoRrqIgV3MCa5HfC6rzI+SSaITHgtFQLD1bFFQmNbo5v6/pdgffEa6pGV1no1RYf0SyRsmbeeWFWqrduL12Zbi/uJjMgzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every flag character of the register string is spelled out three
times: in the parser, in the entry's /proc output and in the
delimiter blacklist that keeps a flag character from sending the flag
scan off the end of the buffer. The three lists have to agree, and
each new flag has to be added to all of them.

Describe a flag once - character, entry flag, implied flags and a
description for the registration debug output - and drive all three
from the table.

While at it, express the "a 'B' entry carries no flags" check as what
it is, an empty flags field, rather than as a fourth list of every
flag character. Equivalent: the check runs right after
check_special_flags(), which advances past exactly the flag
characters it consumed and sets exactly their flags.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 92 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 52 insertions(+), 40 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a3175521c8dd..521ddda929a4 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/array_size.h>
 #include <linux/binfmt_misc.h>
 #include <linux/binfmts.h>
 #include <linux/bitops.h>
@@ -51,6 +52,36 @@ enum binfmt_misc_entry_flags {
 	MISC_FMT_OPEN_FILE	= (1U << 28),
 };
 
+/**
+ * struct binfmt_misc_flag - a flag character of the register string
+ * @c: the character userspace writes and reads back
+ * @flag: the entry flag it sets
+ * @implies: entry flags it turns on in addition
+ * @desc: what it does, for the registration debug output
+ */
+struct binfmt_misc_flag {
+	char		c;
+	unsigned long	flag;
+	unsigned long	implies;
+	const char	*desc;
+};
+
+static const struct binfmt_misc_flag misc_flags[] = {
+	{ 'P', MISC_FMT_PRESERVE_ARGV0,	0,			"preserve argv0"		},
+	{ 'O', MISC_FMT_OPEN_BINARY,	0,			"open binary"			},
+	{ 'C', MISC_FMT_CREDENTIALS,	MISC_FMT_OPEN_BINARY,	"credentials from the binary"	},
+	{ 'F', MISC_FMT_OPEN_FILE,	0,			"open interpreter file now"	},
+};
+
+/* Look up a flag character, NULL if @c is not one. */
+static const struct binfmt_misc_flag *misc_flag_by_char(const char c)
+{
+	for (int i = 0; i < ARRAY_SIZE(misc_flags); i++)
+		if (misc_flags[i].c == c)
+			return &misc_flags[i];
+	return NULL;
+}
+
 struct binfmt_misc_entry {
 	struct hlist_node node;
 	unsigned long flags;		/* type, status, etc. */
@@ -423,30 +454,16 @@ static char *scanarg(char *s, char del)
 	return s;
 }
 
+/* Parse the 'flags' field, stopping at the first character that is not one. */
 static char *check_special_flags(char *p, struct binfmt_misc_entry *e)
 {
 	for (;; p++) {
-		switch (*p) {
-		case 'P':
-			pr_debug("register: flag: P (preserve argv0)\n");
-			e->flags |= MISC_FMT_PRESERVE_ARGV0;
-			break;
-		case 'O':
-			pr_debug("register: flag: O (open binary)\n");
-			e->flags |= MISC_FMT_OPEN_BINARY;
-			break;
-		case 'C':
-			pr_debug("register: flag: C (preserve creds)\n");
-			/* C implies O */
-			e->flags |= MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY;
-			break;
-		case 'F':
-			pr_debug("register: flag: F: open interpreter file now\n");
-			e->flags |= MISC_FMT_OPEN_FILE;
-			break;
-		default:
+		const struct binfmt_misc_flag *f = misc_flag_by_char(*p);
+
+		if (!f)
 			return p;
-		}
+		pr_debug("register: flag: %c (%s)\n", f->c, f->desc);
+		e->flags |= f->flag | f->implies;
 	}
 }
 
@@ -569,7 +586,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 					      size_t count)
 {
 	struct binfmt_misc_entry *e __free(kfree) = NULL;
-	char *buf, *p;
+	char *buf, *p, *flags;
 	char del;
 
 	pr_debug("register: received %zu bytes\n", count);
@@ -594,7 +611,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	pr_debug("register: delim: %#x {%c}\n", del, del);
 
 	/* A flag-char delimiter runs the flag scan off the buffer. */
-	if (del == 'P' || del == 'O' || del == 'C' || del == 'F')
+	if (misc_flag_by_char(del))
 		return ERR_PTR(-EINVAL);
 
 	/* Pad the buffer with the delim to simplify parsing below. */
@@ -665,21 +682,21 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	}
 
 	/* Parse the 'flags' field. */
+	flags = p;
 	p = check_special_flags(p, e);
-	if (*p == '\n')
-		p++;
-	if (p != buf + count)
-		return ERR_PTR(-EINVAL);
 
 	/*
 	 * A bpf handler decides the invocation flags per exec with
-	 * bpf_binprm_set_flags() rather than fixing them at registration, so a
-	 * 'B' entry carries no flags: 'P', 'C' and 'O' become per-exec choices
-	 * and 'F' (pre-open a fixed interpreter) is meaningless for it.
+	 * bpf_binprm_set_flags() rather than fixing them at registration, and
+	 * 'F' (pre-open a fixed interpreter) is meaningless for it, so a 'B'
+	 * entry's flags field has to be empty.
 	 */
-	if (test_bit(MISC_FMT_BPF_BIT, &e->flags) &&
-	    (e->flags & (MISC_FMT_PRESERVE_ARGV0 | MISC_FMT_OPEN_BINARY |
-			 MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_FILE)))
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags) && p != flags)
+		return ERR_PTR(-EINVAL);
+
+	if (*p == '\n')
+		p++;
+	if (p != buf + count)
 		return ERR_PTR(-EINVAL);
 
 	return no_free_ptr(e);
@@ -742,14 +759,9 @@ static int bm_entry_show(struct seq_file *m, void *unused)
 
 	/* print the special flags */
 	seq_puts(m, "flags: ");
-	if (e->flags & MISC_FMT_PRESERVE_ARGV0)
-		seq_putc(m, 'P');
-	if (e->flags & MISC_FMT_OPEN_BINARY)
-		seq_putc(m, 'O');
-	if (e->flags & MISC_FMT_CREDENTIALS)
-		seq_putc(m, 'C');
-	if (e->flags & MISC_FMT_OPEN_FILE)
-		seq_putc(m, 'F');
+	for (int i = 0; i < ARRAY_SIZE(misc_flags); i++)
+		if (e->flags & misc_flags[i].flag)
+			seq_putc(m, misc_flags[i].c);
 	seq_putc(m, '\n');
 
 	if (test_bit(MISC_FMT_BPF_BIT, &e->flags)) {

-- 
2.53.0


