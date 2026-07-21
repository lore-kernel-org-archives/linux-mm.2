Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 140E9C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9266B0099; Tue, 21 Jul 2026 10:14:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580876B009B; Tue, 21 Jul 2026 10:14:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496656B009D; Tue, 21 Jul 2026 10:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 146546B0099
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:14:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BB1A1A01A9
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:39 +0000 (UTC)
X-FDA: 85012979478.12.EC3D6A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B9E454000B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a218HhdR;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jh0kCK0JumH3aozuqcy0Oaz/v3fXNMaeUd/Qe0rfQyk=;
	b=N+rHvJbtZO8HSBrT2S5fUNyzuvjG8vB7yLxD0FgMVJkG/vw4sUnR075yL9UMJJNqhcbdO0
	fX8XODNaVXtfnbv0Oz6qQI5I3YU1g4XEBPSODAxjxGwgWx1di2XTfspbdHH+KWC8KGf4Fl
	YTW4WM2wEgwWZHbosBY3pJ1Pt7trwQg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643277;
	b=yvwro4OOA7O4D+xKxEzvSRRsAD0LcwNaO8XRLpm64q/cZxjdh9F/sAUOYLFRXTgDoHIR7g
	7uxgvU81XDRJlzMp1TKFZsC+f5vGeHTJao5hxu0/zN4L3EG4Kc0usznKLt1GlRKe2SSmvS
	XWpkqbziLNLhT2x15Wv+akBAHXCvmQA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a218HhdR;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 105EB4168A;
	Tue, 21 Jul 2026 14:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544651F000E9;
	Tue, 21 Jul 2026 14:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643276;
	bh=Jh0kCK0JumH3aozuqcy0Oaz/v3fXNMaeUd/Qe0rfQyk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a218HhdRCmuYafaPTfLmconv3uRTsvKgdeS9DkKis8JgpYQVAoEqiXLXsmXSz/Cp/
	 2i2wBeroEgVec8kk3ohpJ4sVMmfW4mb+wVgdY+iHevi3QbqPRq/ghjXwkllQvtmCQD
	 uM3v8ZR+XrKG5nfcQB6v0Bo1u5e8Ab9vfz1FsBYdkWSO1F5s98FnayxiLMAoYtk62c
	 L7xqD7eSCuQU/K4d7Li1v92ZWZh/29nI7Xv4nkLnhTQqcP1/7Uk4gVwHvzDkV2p7TY
	 Luq0b5GkzEb4TZlKORdUmTGeDikRN92i0e3pz+Soa2fzrsoYUNlnVVMTtqQBlDMjGa
	 cVEwD7y5IgG8A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:45 +0200
Subject: [PATCH v2 03/21] binfmt_misc: table-drive the register string
 flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-3-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=6070; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WfRCXhSBfi2LzkKaz/OKGy2fNvqcBkrDAyApc0zJ7VM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1+2P4XscHZNfsYiX505IkWjKprlzp69ofLXU74ui3
 NtrjSJeHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOxSmf4w9F9Kjpuw6Q2x+fb
 +NI7xcqzOEMb7s5I89k9VeeKsINkBcM/hbMdKTX/Sz7uaProOe/F/cWM+t4Ljv3tDP3yO5LFwD2
 TDQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: B9E454000B
X-Stat-Signature: rbgp3mrzqeoarsxf9di4nob6diubjeaz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784643277-791789
X-HE-Meta: U2FsdGVkX18gRcZ7tRviA+j6NO8j025HT1U2t5I5c0YMlaPnLFFC9EBETbIAElKnDDlLe8UF/XDM/QxOIkUUPwsKhWKucwlrkE+rnzG4BB23A7LWbKj8I4dNXiIj76PmT92mo9nlb6Xunjwra20r3QN0tt8HLAn+DUL7trzwH9ik1ABM2mPtvTEYtmByAA9NxBaXCA8sa3Rca2y32OvNexxz7fSOnMScXEj1W8wJlXIEOJncPjxfDfnWT/zS6bN4SAdg5yGDnybUqXG4UV4HB+19bE1CFul4/TsQA4GgrmVqyJWolh07tM/84nSzRTgHdpCKZLsxYsDSiHVz3Z5mpOD+bzEP0Z/UE4P7m4kcJBcW/0upJq1iuB4rckN8Rus53p1gv6asbZ9ONcZZ3C0HCmCgQk10yDzqjh01KWDMznOfSIRRXU9/w6GPkXZARdeYlPbl81W8sMxwhWlOgkGZzdpmCP7Y3gJS2whl7gyAv5A8fsMkYjV/mCq880iMuDlTw8ZuOeJRhwqm/5P8k+94dOO+fnjE22eq0SuUy04RGUyMHMbDvCUxdamAHgnfkA4xowYSRzqKyvfTDqE/G8RQ+SHmOhmaQJNBX5aTgA+YvNLQi4CxJ+96Mo6I3mqrxUEqxghFhMecDJ34YrxWuH+eVjzyNQRSI00cZgHnUgj5/sVqYA16Sw6FJ/Ud/E1x7RlUEfuh93xjq8h8JKS8ZSZaAXQeiGVktO6BTi6EEHhJW9hSEjoDoBsYSlfQs8RfKEGb57R6nU2qAhCI2p/oKqUm9xnKLGhR5GBagEHw+QV2XggHQN1/h+oIK6j+yUcFpVWl27BsxOwNiLkrvtpLlghoNGe01DjZa4qdBLtJGv1jpxjmFFl+CYuv4iFE3AnbBFs/MZS+jF9SqGadhsTBfGu/WQYTHN0HRCWMGk3ttNsSRFhjj9fu0w27yqPGfJYU+3oWWP4cxD1vwF+qQIXgTD7
 BfD1zrN/
 VfkF0M8FF94WdDMw7iMNpVxc6sR+sdC2fKwOxUY6j056ircGJQ7QO83Y2H2oYsZEXphE3a31tw0UI4mPTrcFJgDHo7mFWUNbGY2iz6zXz+iDOoBCguaeQ/ela18V4Z36FwONl9ebQWovgZd5U1fJlgK9C3Kx2a3YUdkH0x6RlAw+/9QXw4SsPdB83MW4A3SVmLlBddXsYqcDpl/7WvdbDoYwCDco8eeEhFD5X7kEBD+qKhWO551XKHCOBOV6VypMGnZ0wNhbRAg9NoVhX9DAIlbdFaPb6l1Rvs6tBTFz0S/uVpV1FbvmHwlQvysx7C0LLrcFNTAJCvVU9X06dw3x4WihAVeTd1AmlawKO2cF75s7E7cj0qwATzMw7MA==
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
index bfe30fe532ba..c0a3b42a38f7 100644
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
@@ -424,30 +455,16 @@ static char *scanarg(char *s, char del)
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
 
@@ -570,7 +587,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 					      size_t count)
 {
 	struct binfmt_misc_entry *e __free(kfree) = NULL;
-	char *buf, *p;
+	char *buf, *p, *flags;
 	char del;
 
 	pr_debug("register: received %zu bytes\n", count);
@@ -595,7 +612,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	pr_debug("register: delim: %#x {%c}\n", del, del);
 
 	/* A flag-char delimiter runs the flag scan off the buffer. */
-	if (del == 'P' || del == 'O' || del == 'C' || del == 'F')
+	if (misc_flag_by_char(del))
 		return ERR_PTR(-EINVAL);
 
 	/* Pad the buffer with the delim to simplify parsing below. */
@@ -666,21 +683,21 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
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
 
 	/* Non-F opens the interp at exec against the caller's cwd; require absolute. */
@@ -749,14 +766,9 @@ static int bm_entry_show(struct seq_file *m, void *unused)
 
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


