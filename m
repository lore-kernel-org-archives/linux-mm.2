Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E6E9C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD9F56B00AB; Thu,  9 Jul 2026 18:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A7B6B00AD; Thu,  9 Jul 2026 18:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79A16B00AE; Thu,  9 Jul 2026 18:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC9BD6B00AB
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EA9E1692AF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:56 +0000 (UTC)
X-FDA: 84970684512.09.F3C7572
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B29AE1C0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X6WpDXKz;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qths/4bju2BHU08NXVAtb1Z/aOxqWP0RmZrhLbQMcik=;
	b=AxELWvKkva8WJ0DwaBTOTlVgMd6vcYvv93hSapxMRuoBqRQY7LW716S/ZwrnyV7qpz7NgN
	RnpzpAqkW3mdR7C30BwbT7ouainm5r9H8yyjid9j5xxnVjXQfu2uCKFdFAVZqfOmk1kdLc
	vnUlKJ6+l3HARgQW6ASEQAhPJ+GW4Cg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X6WpDXKz;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636254;
	b=PyJElOpQZC312oahO5cPLcBL3Vr5QPyWvSqloLhMlQv8qWf1E/N/yA8JV2WStCQ92ERc81
	F2UfoRNerMOEEVjb3bFiOjLCyac1xlczpyvjMn8Zigsz3l7YUWDSFrWMtnVlRVbfpyxuZf
	YCthuA/G2Wks3F0I0PwKzWTOuaXdhsU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1419140187;
	Thu,  9 Jul 2026 22:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1D11F000E9;
	Thu,  9 Jul 2026 22:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636254;
	bh=qths/4bju2BHU08NXVAtb1Z/aOxqWP0RmZrhLbQMcik=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=X6WpDXKzAWietm9E1WCbXsCdlovVqXUoCgirZx6vUP7uxrBbs/EyKbhaV6dvul0wB
	 c8pZtowH9PBEQ7H3bCUgnEwQblgVjKCLOgB6S7jM0j9etWyxrVhI+exGFysTj5dRdA
	 WIL9KO08yn0YGVpqg6Zgfgq9lRzSG0Q9PZNywCZ4wu0+oOXP3+yD5DXtkTsS9CvbQL
	 plH6o6RBzbfGsZvMEUmO5HZURlUfBVzROGUUbmaK5RVv8HTV66M5PK7u0/5HNAXfFf
	 w0CZQ54Nz8oc1FW0rMHo4drTLV//f7NVJrYnsJNUeeKuTu0wB84SEr5uU/u2CQvZOc
	 nEx3dxFNJo2pA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:14 +0200
Subject: [PATCH v2 19/23] binfmt_misc: split the field parsing out of
 create_entry()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-19-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=8841; i=brauner@kernel.org;
 h=from:subject:message-id; bh=4MrCQxnDVAcU3XelW0WHC7l+OAq00Zcdr1tP5j2kYCw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHxrW7rm23UzXvddRy6uEea78kLDuXJeCfe0RLFTE
 z3DHkU5dpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkeiXD/6odnzYyr9BteyNq
 9VTomiXzWw/9OUs8uGe/Se84czbzqCLD/xyxU60braY3ztG2mJp2qpXX1lDii01MR2uKoG1y8V9
 7FgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: rqdhftcinwb1o8p8pyjngyeo1maf9cgk
X-Rspamd-Queue-Id: B29AE1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783636254-608826
X-HE-Meta: U2FsdGVkX19S+/Oj0J1pK0Usnznvx11K5Ir/3+bP0aXVk76POm6kx3E8vDYJOQ1PzP1brcODwhkJ2DLSddE9+qgb7laiCWDskYnO7/so98IShXyckbO61gHRtx6tVXYpuPpppNW4SbukXr2FNk7VxaS/EzrAGvE5e6zfaVfGhU7zL/U4lXQiJShq8oE1z6al65fzGfxOo1qDvTmdOICqZns4hiUtWTGCWldktd5ssswZWey1hSlJtDFcWip2ZOLBGbbIMFDMJiEJ93jJyNbfbuKhssYo9fC4mGV149TiIXdtlEp7Tnw40Wni8hMRYTm82sgapOLq7nk+QKXkkrQVpdBAcg4R7/CE2fxpNO+G69KUSqXyLNfBP1U5Ffruwvl/gSUbNcdiwymj/9SWApTHUJw6QQ6RXgWERvdAcuMjLimP4WXzorPeH+053rJR0eMPrsOU4QiKVy2BYm4L1TYgOAN7Ef4tdWlLIe5yBfyvH79YrCoFtgG6uM4f3EgebjuFLqz/R6cQ7EKw1u9TDbrqVvvQ1LmiNXaIW7Oqhk6ZcBXLrY0tO4fOihKyvz1BMjP6jZOKbDtfE7K/eizl11Jb8mWuzJARHbuKEwa2AHhcSJ0CnyJe7UDCDVKaOAsZkKW3QdlacNyAY3f2D8JXcLFJf9vt13Ub8WmIRtFq84ii0ocHPY3lbIk3DR1XKoggXlbydFNzvhmJi/1IL8+d1hijB98XwmD5T50vI5u1ITvYqflNP2jH7n/MAtFpCk8QTN+Nd2lWywdq7RCgzPOjZWZIFp+5d4rAOGBRJh1D+V73ch75O56XuMlglfRvZnCHBGU4LlDWmI0pfkfdZi9ZPjggkIkqpFZTGiT72sc2tgIkzLm1Flhacql8CKAMM28/3ee6vfLjxe09dJMeMDcfAlzEoAPlXQPxRMVH1sL7vL4wHP30/Aj78LdkUFZNvNTYJhkHhsgspKkTCdNbA+zVNK1
 a3kEloxW
 sr4RabSWjEpDOiZ34LxuOqfI1kST+1xX7yKaAntUFvPtQelQgyoP0ur0D1aWsJn7w6lcR3vkqit4G/mXln25Vo3p98SSypG/PjHiS+xpe0/+BJhek5FaQlSJzEOHJ5po0LCVDHpdfHolVP3VWy20PvnVDWyjgkaLEf/XtBZ5wC+q9kqURehVKOuivZdV+fpTapEjKoV47mES16ZFeMmXWtBJjRozHj+sxqCsG5X5Lx59KHOVUrgKGZ9+Kz0dWLnPqfV7W/u+TYXpNTVFnHJaB++ROFOBlM6bglkHJCfkCZv8nIVt3GGQ3c/4Qo1lULV8CvGKPXkzgXigJ/vuB1WcRpPGL8s3CVRS9On8H+gEiSfKGmKixTiaS3ifur4jGSxcD+UqU20glwdXQXHhjtIDKLJtsIg==
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
 fs/binfmt_misc.c | 223 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 107 insertions(+), 116 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index c7435d103629..c2d947f934ab 100644
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
 
@@ -383,13 +469,13 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
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
 
@@ -404,111 +490,26 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
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
@@ -516,19 +517,9 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
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


