Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F48C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3FC6B009D; Tue, 21 Jul 2026 10:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CBAF6B009E; Tue, 21 Jul 2026 10:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B99E6B009F; Tue, 21 Jul 2026 10:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32E6B6B009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:14:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 964171401A1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:45 +0000 (UTC)
X-FDA: 85012979730.21.E881601
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D8146140012
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSdt31W1;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643283;
	b=AjxP4oet33VY3mgtX5vF7p74tt9NcYFoyBDIr5v+qnDrXILfITvYRsq/Q7H50ePm/30no5
	OJ6EpU2Pif+PyEy1A3HCiuaK+LK5p4LIC0RZArxoLIrprIHLMEty0gq1RTiy8Eqjc6OC+O
	QR/TV3lqzRbzJzyy94tuXMFwWvHLnqM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSdt31W1;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=duxkptqHCs8NlPAFgm0agkM0Ne79nLrUlXWxBx15U2k=;
	b=HQFDgCG0ynGcNYyqXkPI+N42zg6KProUa5peOPXHrTh74h+LVkbYuPBMTeT5VMJFSyM5wY
	MYOWtXXNlmKeqfUZ8vm7O0wMp5aUDIZ8RcNey4ggPg8F98fhOqL2AuDWuBqD01xP4UgezW
	BRZjrL6Jio+PQuVrSKklRKPr6Y2K9C8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 74645600D8;
	Tue, 21 Jul 2026 14:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E54C1F00A3D;
	Tue, 21 Jul 2026 14:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643283;
	bh=duxkptqHCs8NlPAFgm0agkM0Ne79nLrUlXWxBx15U2k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gSdt31W17nVihKiXN+zywJvxfCcz1NRvt4sjbDXGtHJNnRe9N/yGaD5fC9MSwIJxi
	 Rv4cXnm3PK356bgiea74LNfkr8MdD+1H+gMQcRQb34aOe9hxZX12zyAHtyZdU08vlm
	 sNyWMrq6CYiBvjeAGCWKy3dKSX8w9wLtm3h1g+AqChnfic59F5T4vGufzbanrsNxiX
	 wiLlE9Ajes5sokGmAHW6/xxw3dt0Vbcs2s81EbgKdbmD1NST2/qwSp0LICiDB1piCt
	 gNLnoRQ+xkmUurpTwOZCKTRUb7P+nUH9qicxCGYPo8K+3NCDaEXWYaaKObtinsryiX
	 pw2gKxUWq8f0Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:47 +0200
Subject: [PATCH v2 05/21] binfmt_misc: split out entry_open_interpreter()
 and build_interp_argv()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-5-e57866e4ae0f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5121; i=brauner@kernel.org;
 h=from:subject:message-id; bh=k/hMy0kVcRHGLKQwOzJAwZZ8svOPTcyroGFEZc0+CGM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1+1nCTN6+O/osnQz4flezpEGHOwi/iliIjy/pFtfG
 xw68HBxRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwES8XzL8M1y2mVlcJIYpUKhA
 4CvTE/2bGVu3PZn/8uHuzllsl1U/MTD8M5/ZInTAd59dmcSnf7X3P3x3PWHh+UFv4bKve49GW1s
 0cwMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 7ntyzzygtgu5xch5gfebzf8895cyjqnt
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D8146140012
X-Rspam-User: 
X-HE-Tag: 1784643283-670999
X-HE-Meta: U2FsdGVkX19gO+a/EmUrqwq5Lo82Mqrr42JzAdl3U3L8fKBKJQ9Q6mGi6ebHIziiol8C3PrtzgFz8EIUSvL5QmkC9czTE9Hmw2FW4WWeldxYYWMCVPjUGZHt65ipRLUSV4v5f4EiHT0xZKfnSwXqRAw0R2Un8+yweRzMfWHRPh6LQPJr6lNxPzAvGX+8dr9CZxQ3DunrQfCsKN61ucvcPkhhoJq/fFoe6aoNsXj7dCX8oAWMkibpb7I+skcno0AxUOcPuxAtK2+Oymj8LmlLHAepdMsXCBvOvTtGa+CPZyqPX3tvNbFnaHHlJ0xMlh6a8JAMQpIgB0A1AejmEJp/TJHn0dYblH+uLJWyJYhESJpxz3zdLUqlLO4u8FlbNEB6fP1VEc4hZx5PerIVlVQZcjvV/MZmQ9xLqtfz6AX7G/vtKqxzI+HumzoLIskwH8u4Ri9eJXfmINW9xrf0flgTj5QpjoNjtD0brltLnBlmeaoGZq97kWXt8FaWqknete9fLF8lGRS06Qy4GjC6O3ZpiNArBqLjykU4XDjCX0/NOjJ3950pjQZj2eyO6LExVNNPsz/kyHuuW+tZ4TjqIIOOi1PAEQAO6AJ797a41TdpE5pBhL89/X25RbMW/x8Updb7MQJDp93K5IWMbfjxpWlIx9oIXPdgLd6EdZVTU8lPJkgSySzmrcU2nY660L1UObFVW5eMhTZKBb5RZZy15zPVrS7bdxCohmEfOmJR/kXc/x58hN1j1ePwfKIMPvd/FQd85g8itkkOogdFfkAQ72E85n7G7LELkrXyKaQQOT0vFAtzqjXJJgJ4QZrDq9IZ1zOo5CVU7lRkwVADqD8x8AIkgSay1l6Z9gyDKYzCXohf/NBWjE4V36j1fvL5ZYGzJiihO2uNmNrnMpxYP2/3mtapNqLQX7RCBjCBbTxamLyShULZVZgLujZ++EDAkQJbfjIhxjXkxN/Kmn6xaA4cl8i
 VQGY7vDU
 MWXnn5GPeEOXj+ZEdLRK3lAh7fR6pAXpfDVcF8vb9AYakJNse/6fcRncka2FJfdqAR84K1UCSsO2jCWAd8UfJzrZ4e19R5GX7e08khnrEqtdM5twpuvQ6OCrVV9H24p9hHZo65BSrV3/g9B5JjXygaHGYzFMK1iQAHsA6/KjCmNbvcRSI4E0iR5Fwk0wrMVADMFBTjUXt4tLM5Iqh2VufnEjuz3rC9Rbw+I9D/Zlqq3UZPA+B9dW0oK+1xK4HYWw54uLCTxMOSpts7+9/+KNa7jBILhfDQRGXYyMNjEuVmbTjmrx3ZvMNjBzUaUhP8uN2OyUA69z/HfxxBxbS+jSm1y1d9LHjqZFhW3zfysasl3EK2D4yhB1xAriCI+Wwj5JFTRP6gM2AWkfc1d8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Opening the interpreter is a property of the matched entry: an 'F' entry
hands out a clone of the file it pre-opened at registration time, any
other entry opens the selected path. Give that its own helper instead of
an if/else in the middle of load_misc_binary(), and let it fail early
rather than carrying an ERR_PTR through the successful branch.

Building the interpreter's argument vector is the bulk of what remains
and the one part of load_misc_binary() that is specific to the classic
dispatch. Move it into its own helper too, so the dispatch reads as what
it is: pick a handler, pick an interpreter, build the invocation, open
it.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 110 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 76 insertions(+), 34 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index dc2ee012da10..304109a5091f 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -353,35 +353,52 @@ static unsigned long entry_invocation_flags(const struct binfmt_misc_entry *e,
 	return flags;
 }
 
-/*
- * the loader itself
+/**
+ * entry_open_interpreter - open the entry's interpreter for execution
+ * @e: matched binary type handler
+ * @interpreter: the interpreter selected for this exec
+ *
+ * An 'F' entry hands out a clone of the file it pre-opened at registration,
+ * any other entry opens the selected path.
+ *
+ * Return: the opened interpreter on success, an ERR_PTR on failure
  */
-static int load_misc_binary(struct linux_binprm *bprm)
+static struct file *entry_open_interpreter(const struct binfmt_misc_entry *e,
+					   const char *interpreter)
 {
-	struct binfmt_misc_entry *fmt __free(put_binfmt_handler) = NULL;
-	const char *interpreter;
-	struct file *interp_file;
-	struct binfmt_misc *misc;
-	unsigned long flags;
+	struct file *interp_file __free(fput) = NULL;
 	int retval;
 
-	misc = current_binfmt_misc();
-	if (!READ_ONCE(misc->enabled))
-		return -ENOEXEC;
+	if (!(e->flags & MISC_FMT_OPEN_FILE))
+		return open_exec(interpreter);
 
-	fmt = get_binfmt_handler(misc, bprm);
-	if (!fmt)
-		return -ENOEXEC;
+	interp_file = file_clone_open(e->interp_file);
+	if (IS_ERR(interp_file))
+		return interp_file;
 
-	/* Need to be able to load the file after exec */
-	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
-		return -ENOENT;
+	retval = exe_file_deny_write_access(interp_file);
+	if (retval)
+		return ERR_PTR(retval);
 
-	interpreter = entry_select_interpreter(fmt, bprm);
-	if (IS_ERR(interpreter))
-		return PTR_ERR(interpreter);
+	return no_free_ptr(interp_file);
+}
 
-	flags = entry_invocation_flags(fmt, bprm);
+/**
+ * build_interp_argv - splice the interpreter invocation into the argv
+ * @bprm: binary that is being executed
+ * @interpreter: the interpreter selected for this exec
+ * @flags: invocation flags in effect for this exec
+ *
+ * The interpreter becomes argv[0] and the binary its last argument, with an
+ * optional staged argument in between. The caller's argv[0] is dropped
+ * unless 'P' keeps it.
+ *
+ * Return: 0 on success, a negative error code on failure
+ */
+static int build_interp_argv(struct linux_binprm *bprm, const char *interpreter,
+			     unsigned long flags)
+{
+	int retval;
 
 	/* The entry's own choice - not one accumulated from an earlier level. */
 	if (flags & MISC_FMT_PRESERVE_ARGV0) {
@@ -418,24 +435,49 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		return retval;
 	bprm->argc++;
 
+	return 0;
+}
+
+/*
+ * the loader itself
+ */
+static int load_misc_binary(struct linux_binprm *bprm)
+{
+	struct binfmt_misc_entry *fmt __free(put_binfmt_handler) = NULL;
+	const char *interpreter;
+	struct file *interp_file;
+	struct binfmt_misc *misc;
+	unsigned long flags;
+	int retval;
+
+	misc = current_binfmt_misc();
+	if (!READ_ONCE(misc->enabled))
+		return -ENOEXEC;
+
+	fmt = get_binfmt_handler(misc, bprm);
+	if (!fmt)
+		return -ENOEXEC;
+
+	/* Need to be able to load the file after exec */
+	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
+		return -ENOENT;
+
+	interpreter = entry_select_interpreter(fmt, bprm);
+	if (IS_ERR(interpreter))
+		return PTR_ERR(interpreter);
+
+	flags = entry_invocation_flags(fmt, bprm);
+
+	retval = build_interp_argv(bprm, interpreter, flags);
+	if (retval)
+		return retval;
+
 	/* Update interp in case binfmt_script needs it. */
 	retval = bprm_change_interp(interpreter, bprm);
 	if (retval < 0)
 		return retval;
 
-	if (fmt->flags & MISC_FMT_OPEN_FILE) {
-		interp_file = file_clone_open(fmt->interp_file);
-		if (!IS_ERR(interp_file)) {
-			int err = exe_file_deny_write_access(interp_file);
-
-			if (err) {
-				fput(interp_file);
-				interp_file = ERR_PTR(err);
-			}
-		}
-	} else {
-		interp_file = open_exec(interpreter);
-	}
+	interp_file = entry_open_interpreter(fmt, interpreter);
 	if (IS_ERR(interp_file))
 		return PTR_ERR(interp_file);
 

-- 
2.53.0


