Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A83D8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A371C6B00B2; Fri, 10 Jul 2026 05:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0EEA6B00B3; Fri, 10 Jul 2026 05:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B6D6B00B4; Fri, 10 Jul 2026 05:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 713D06B00B2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:34:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0395A1203D0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:34:01 +0000 (UTC)
X-FDA: 84972355524.16.AFF92C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 312641C0008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:34:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YWXqt8ow;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OccYc8NxGsDMDGI6vq4nPL3MmgM3Zh80pxvV6GiHRMM=;
	b=rBTvbkRR+klwuHhJrJGkRrs5i/MQRghRcHm6RMJtjqDgg6kcbG5PNl6Jv0dq/NTz+sZBFL
	c7+moAyBWY8kXJLydeZUViPwQX7PJdupNqs5/asTLSpZUEAOTIzqt5tDAnNDjZ+Xs5z0cg
	51oxWJWIR50szDWyY2MJHS5EQtGvLTM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YWXqt8ow;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676040;
	b=7qgEA0YM1EusJ45WeL0i+TxxVRy4P4XqcehQeRHKivUR0WxcdkS1D5R8gk3EUQJEWf0ZCG
	GkqwDZRNDy7zzLHr4nUui0pYXedtljSj/ZHBkjH3EuteLI/yj2ebLJYGk1sThhom5xkMhP
	IL28neJ4YD1ELnm3QMqJ96Y2EDlQZHc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A05E43D67;
	Fri, 10 Jul 2026 09:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9BA1F000E9;
	Fri, 10 Jul 2026 09:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676039;
	bh=OccYc8NxGsDMDGI6vq4nPL3MmgM3Zh80pxvV6GiHRMM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YWXqt8owcIw+8pJKVus3nEG0j5OP6I4LZuipqZ5tyTNaHu7GGGexqzuAi/09T92V0
	 UyKd7EQGcpIyfjnGX9VIoZm3ebQnIXW2CP4LEUtwqn2e9VJnmPWJEyp6Ogr32KCkNA
	 FU8W3kqvYkUsL4Rb0+hVNSIIwuZKfTOQCv7KniXWIAN20vLo1XA4SNHvP3YlijZioa
	 ER6cxEvmpvaTkzw1YXL3FFHkqnXfrWlli8hRjqnMFVK8uZYleSX1Z5BiUIoNlULzrC
	 gWvFx8s9JqO+JfIeMd2GUAaZxxujitJm9ME1ECBOMTuPGIHgS2l2nx3hxO0/dFDaWd
	 niWX4D9UIPlag==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:21 +0200
Subject: [PATCH v3 20/24] binfmt_misc: split the field parsing out of
 create_entry()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-20-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=9225; i=brauner@kernel.org;
 h=from:subject:message-id; bh=25W/cgoz/HpXh1KEXu/W3hNEhoDDwyECTUQhuRK1V1w=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7Il/mDanxkT488yZ3O7vfEVXM5w6XCdj8NA31Dq6Y
 veXQxOudpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExk+xOG/z7c0ZpG/9bJCzS6
 C18VP6yRxJOw6UR0HEPdbeWLwjn8TowMSyULvnZWGs19HvQhvYlthfzXi68P/SrcwXp3Scij22t
 mMwAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 312641C0008
X-Stat-Signature: 1m3ma7jiqmayji8qdqbe3us9f5j81x5s
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783676040-754020
X-HE-Meta: U2FsdGVkX1/UI1FpDckcdH2rOus4kRsqLw66TU0tzhaT8r1gsfsDJFVc3LYM19EGf9NvM3gDQqjw+l15dS8lilXPFJA5KQzSfUiJ5AqywyRLnpp9XXfXoYrDQWemvICcS7vBJy4YsXi7loY0rYk0s0BuwbFlvYVJw5D9LQ7lcvQPP6KVNZkMveYupYiolPNuCmucPZittT/FmATJFc9MnGBHyf5UCzeLvlG7vcrf3Be8cqqfOWQdPO3C3bRD33lYEtQPCDYmavmyKaDow78QxWB+eBzgAOQtxmKLthf1gV3IoLIZDD0F3IujkKROPqZTmrn5cSwiJoi8+FxDIrnsxCoLwGk+GdfthWIQEFiwIvuEGdW5CTo4sqh0n5agAAw77BM2H2XQIFh4pewO80mWa94Z5Hd0eb9aH8Ra8sJW2ExAj7cM980Ev0EY9G4nOAOYwyvKH+ybfdhBbqkbwOTITwiBw2UO88sov6ajhv10hNlM02IzpMCPCPfovhD05TMntrw7bAzgJPfORMotZy8Ha0aEe9kYrLyxM30ps9fHzqM3q2jqcOTFyiMNaHX7NBFQZhBV9Tw1k58eL0Qejg+mw7o9toqCRlxifxpj7HsIXGzUC0adJBG5yklMcODO6gu03g7f9NMFQYQXS72U97wW7e7BY8t0wdP+A3YXOU7jnaCaKsa7TE+hORuO20vjuQKNWCj/IYZCDh/GdC90xeUIHcMV7Y7PIjF3W5uDqRggAzXjnYgRRcfVDolomBoGtNzBJfhTYiRvzB2Vj4zfSQZpdUBPm8oHauHaI48i7AMX3xUyVLYLjKHFRP8NPNxjE14aJ1zfzgWcbe1/DU990odT068lPeCPlRvj9EL1cTvcCEqJfRp0Wg+84uqzx6Prtkf1YstwVUDF8Dcmi82BuPtNbR649b3asedCNP5GWn+SMFbtR+V9862rsK/xiyZFgPEZ/fxZe/1C70xUxjAqeBG
 BjGxgCVP
 3Dy1fPvaP3HYPiZMJXANWlVKDYk6AcpQ/LLeWwdBzn9JPcfnMj3IIncJvFfCG64ODZXOSI3hspSfVgMGNsuUERbYTRmweTmeLlbSAb67veFfGGaZoS0Ue5aBD1xlUzK/PM6OAOOYZWddpZImVsZxRI6FogupUoOEaRoGlJgL4WjjTWuRot7vDn8vyzYdEa5NEwdv+N08qOaVDGcMZ21pA2C8oy/826L6ZXbPL4emsaOwn7Dcs3Z1b/949sFytV8ba0Fj3p7i0kfI0QK+abmoktOzQNODnTArHhdubHnczTxWSem9Fr3/UpJY5SeURf1AiEoo8ERpgJKSO3FQnvxpqkkcireXhKKwtuZgHDN99r5rjPITniLT3wD8P0oBx5sJw3mhbF+m920tHtV0Ht1tCPxrPsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

create_entry() is a two hundred line parser with the M and E field
handling inlined as the two arms of its largest branch. Move them
into parse_magic_fields() and parse_extension_fields() which return
the new parse position or NULL so create_entry() itself reads like
the register string grammar again.

The offset parsing loses a provably dead check on the way: after
*s = '\0' and p = s the subsequent if (*p++) always reads the just
written NUL byte and can never fail, it only obscured that the code
simply advances past the delimiter.

With the field parsing gone every remaining failure unwinds the same
way, so hand the entry to __free(kfree), return errors directly and
pass ownership out via no_free_ptr() on success instead of routing
every exit through goto tails.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 225 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 108 insertions(+), 117 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 4cfd3ce5e47e..a9e1e0bbcc60 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -340,6 +340,95 @@ static char *check_special_flags(char *p, struct binfmt_misc_entry *e)
 	}
 }
 
+/* Parse the 'offset', 'magic' and 'mask' fields of an 'M' entry. */
+static char *parse_magic_fields(struct binfmt_misc_entry *e, char *p, char del)
+{
+	char *s;
+
+	/* Parse the 'offset' field. */
+	s = strchr(p, del);
+	if (!s)
+		return NULL;
+	*s = '\0';
+	if (p != s) {
+		if (kstrtoint(p, 10, &e->offset) || e->offset < 0)
+			return NULL;
+	}
+	p = s + 1;
+	pr_debug("register: offset: %#x\n", e->offset);
+
+	/* Parse the 'magic' field. */
+	e->magic = p;
+	p = scanarg(p, del);
+	if (!p || !e->magic[0])
+		return NULL;
+	print_hex_dump_debug(
+		KBUILD_MODNAME ": register: magic[raw]: ",
+		DUMP_PREFIX_NONE, 16, 1, e->magic, p - e->magic, true);
+
+	/* Parse the 'mask' field. */
+	e->mask = p;
+	p = scanarg(p, del);
+	if (!p)
+		return NULL;
+	if (!e->mask[0]) {
+		e->mask = NULL;
+		pr_debug("register:  mask[raw]: none\n");
+	} else {
+		print_hex_dump_debug(
+			KBUILD_MODNAME ": register:  mask[raw]: ",
+			DUMP_PREFIX_NONE, 16, 1, e->mask, p - e->mask, true);
+	}
+
+	/*
+	 * Decode the magic & mask fields. Note: while we might have accepted
+	 * embedded NUL bytes from above, the unescape helpers will stop at
+	 * the first one they encounter.
+	 */
+	e->size = string_unescape_inplace(e->magic, UNESCAPE_HEX);
+	if (e->mask && string_unescape_inplace(e->mask, UNESCAPE_HEX) != e->size)
+		return NULL;
+	if (e->size > BINPRM_BUF_SIZE || BINPRM_BUF_SIZE - e->size < e->offset)
+		return NULL;
+	pr_debug("register: magic/mask length: %i\n", e->size);
+	print_hex_dump_debug(
+		KBUILD_MODNAME ": register: magic[decoded]: ",
+		DUMP_PREFIX_NONE, 16, 1, e->magic, e->size, true);
+	if (e->mask)
+		print_hex_dump_debug(
+			KBUILD_MODNAME ": register:  mask[decoded]: ",
+			DUMP_PREFIX_NONE, 16, 1, e->mask, e->size, true);
+	return p;
+}
+
+/* Parse the 'magic' field of an 'E' entry: the filename extension. */
+static char *parse_extension_fields(struct binfmt_misc_entry *e, char *p,
+				    char del)
+{
+	/* Skip the 'offset' field. */
+	p = strchr(p, del);
+	if (!p)
+		return NULL;
+	*p++ = '\0';
+
+	/* Parse the 'magic' field. */
+	e->magic = p;
+	p = strchr(p, del);
+	if (!p)
+		return NULL;
+	*p++ = '\0';
+	if (!e->magic[0] || strchr(e->magic, '/'))
+		return NULL;
+	pr_debug("register: extension: {%s}\n", e->magic);
+
+	/* Skip the 'mask' field. */
+	p = strchr(p, del);
+	if (!p)
+		return NULL;
+	*p++ = '\0';
+	return p;
+}
+
 /*
  * This registers a new binary format, it recognises the syntax
  * ':name:type:offset:magic:mask:interpreter:flags'
@@ -348,29 +437,26 @@ static char *check_special_flags(char *p, struct binfmt_misc_entry *e)
 static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 					      size_t count)
 {
-	struct binfmt_misc_entry *e;
+	struct binfmt_misc_entry *e __free(kfree) = NULL;
 	char *buf, *p;
 	char del;
-	int err;
 
 	pr_debug("register: received %zu bytes\n", count);
 
 	/* some sanity checks */
-	err = -EINVAL;
 	if ((count < 11) || (count > MAX_REGISTER_LENGTH))
-		goto out;
+		return ERR_PTR(-EINVAL);
 
-	err = -ENOMEM;
 	e = kmalloc(struct_size(e, buf, count + MISC_DELIM_PAD),
 		    GFP_KERNEL_ACCOUNT);
 	if (!e)
-		goto out;
+		return ERR_PTR(-ENOMEM);
 
 	p = buf = e->buf;
 
 	memset(e, 0, sizeof(*e));
 	if (copy_from_user(buf, buffer, count))
-		goto efault;
+		return ERR_PTR(-EFAULT);
 
 	del = *p++;	/* delimeter */
 
@@ -378,7 +464,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 
 	/* A flag-char delimiter runs the flag scan off the buffer. */
 	if (del == 'P' || del == 'O' || del == 'C' || del == 'F')
-		goto einval;
+		return ERR_PTR(-EINVAL);
 
 	/* Pad the buffer with the delim to simplify parsing below. */
 	memset(buf + count, del, MISC_DELIM_PAD);
@@ -387,13 +473,13 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	e->name = p;
 	p = strchr(p, del);
 	if (!p)
-		goto einval;
+		return ERR_PTR(-EINVAL);
 	*p++ = '\0';
 	if (!e->name[0] ||
 	    !strcmp(e->name, ".") ||
 	    !strcmp(e->name, "..") ||
 	    strchr(e->name, '/'))
-		goto einval;
+		return ERR_PTR(-EINVAL);
 
 	pr_debug("register: name: {%s}\n", e->name);
 
@@ -408,111 +494,26 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 		e->flags = BIT(MISC_FMT_ENABLED_BIT) | BIT(MISC_FMT_MAGIC_BIT);
 		break;
 	default:
-		goto einval;
+		return ERR_PTR(-EINVAL);
 	}
 	if (*p++ != del)
-		goto einval;
-
-	if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
-		/* Handle the 'M' (magic) format. */
-		char *s;
-
-		/* Parse the 'offset' field. */
-		s = strchr(p, del);
-		if (!s)
-			goto einval;
-		*s = '\0';
-		if (p != s) {
-			int r = kstrtoint(p, 10, &e->offset);
-			if (r != 0 || e->offset < 0)
-				goto einval;
-		}
-		p = s;
-		if (*p++)
-			goto einval;
-		pr_debug("register: offset: %#x\n", e->offset);
-
-		/* Parse the 'magic' field. */
-		e->magic = p;
-		p = scanarg(p, del);
-		if (!p)
-			goto einval;
-		if (!e->magic[0])
-			goto einval;
-		print_hex_dump_debug(
-			KBUILD_MODNAME ": register: magic[raw]: ",
-			DUMP_PREFIX_NONE, 16, 1, e->magic, p - e->magic, true);
-
-		/* Parse the 'mask' field. */
-		e->mask = p;
-		p = scanarg(p, del);
-		if (!p)
-			goto einval;
-		if (!e->mask[0]) {
-			e->mask = NULL;
-			pr_debug("register:  mask[raw]: none\n");
-		} else {
-			print_hex_dump_debug(
-				KBUILD_MODNAME ": register:  mask[raw]: ",
-				DUMP_PREFIX_NONE, 16, 1, e->mask, p - e->mask,
-				true);
-		}
+		return ERR_PTR(-EINVAL);
 
-		/*
-		 * Decode the magic & mask fields.
-		 * Note: while we might have accepted embedded NUL bytes from
-		 * above, the unescape helpers here will stop at the first one
-		 * it encounters.
-		 */
-		e->size = string_unescape_inplace(e->magic, UNESCAPE_HEX);
-		if (e->mask &&
-		    string_unescape_inplace(e->mask, UNESCAPE_HEX) != e->size)
-			goto einval;
-		if (e->size > BINPRM_BUF_SIZE ||
-		    BINPRM_BUF_SIZE - e->size < e->offset)
-			goto einval;
-		pr_debug("register: magic/mask length: %i\n", e->size);
-		print_hex_dump_debug(
-			KBUILD_MODNAME ": register: magic[decoded]: ",
-			DUMP_PREFIX_NONE, 16, 1, e->magic, e->size, true);
-		if (e->mask)
-			print_hex_dump_debug(
-				KBUILD_MODNAME ": register:  mask[decoded]: ",
-				DUMP_PREFIX_NONE, 16, 1, e->mask, e->size, true);
-	} else {
-		/* Handle the 'E' (extension) format. */
-
-		/* Skip the 'offset' field. */
-		p = strchr(p, del);
-		if (!p)
-			goto einval;
-		*p++ = '\0';
-
-		/* Parse the 'magic' field. */
-		e->magic = p;
-		p = strchr(p, del);
-		if (!p)
-			goto einval;
-		*p++ = '\0';
-		if (!e->magic[0] || strchr(e->magic, '/'))
-			goto einval;
-		pr_debug("register: extension: {%s}\n", e->magic);
-
-		/* Skip the 'mask' field. */
-		p = strchr(p, del);
-		if (!p)
-			goto einval;
-		*p++ = '\0';
-	}
+	if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags))
+		p = parse_magic_fields(e, p, del);
+	else
+		p = parse_extension_fields(e, p, del);
+	if (!p)
+		return ERR_PTR(-EINVAL);
 
 	/* Parse the 'interpreter' field. */
 	e->interpreter = p;
 	p = strchr(p, del);
 	if (!p)
-		goto einval;
+		return ERR_PTR(-EINVAL);
 	*p++ = '\0';
 	if (!e->interpreter[0])
-		goto einval;
+		return ERR_PTR(-EINVAL);
 	pr_debug("register: interpreter: {%s}\n", e->interpreter);
 
 	/* Parse the 'flags' field. */
@@ -520,19 +521,9 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	if (*p == '\n')
 		p++;
 	if (p != buf + count)
-		goto einval;
-
-	return e;
-
-out:
-	return ERR_PTR(err);
+		return ERR_PTR(-EINVAL);
 
-efault:
-	kfree(e);
-	return ERR_PTR(-EFAULT);
-einval:
-	kfree(e);
-	return ERR_PTR(-EINVAL);
+	return no_free_ptr(e);
 }
 
 /* Commands accepted by the /status and /<entry> files. */

-- 
2.53.0


