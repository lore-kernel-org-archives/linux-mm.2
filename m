Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 568D9C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4CF6B00C9; Mon, 20 Jul 2026 05:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B660B6B00CB; Mon, 20 Jul 2026 05:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54C66B00CC; Mon, 20 Jul 2026 05:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76B7F6B00C9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0B4B807DE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:20 +0000 (UTC)
X-FDA: 85008644280.02.A4A3316
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1CC7F120005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XrEyjAsV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540059;
	b=SbVFL0NVPbfY7HJgFSPd9IduYAzKQBq7B9LOSrXizwsQ53LmVcPhT/WOIwxVB26x/1N1AR
	DjRGox7bWjb43OmW7yaQV9D7wChKKFN7CKVatPt5uVR5UcbHiXXIiyZKHSl6DGsp/euITf
	vNryIBmB6DYQ72xTRT2T/1zdVxvLwFE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XrEyjAsV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Vi2Y6eFLaZZncWxhzA85l4SRnVsg67aEdWUPdvtHPg=;
	b=LQS8uFsjEbWxe1apyfjHhbyFnsip4FN6eRLMtLMyIvqSEA8RByO4L/mkkPXJ7GZ3Gjydzd
	tQRIZ/bTPczXR3xv0eB9kppM0ylhHIoyZsRzAdQ68b0vu5/SBTKfCBkpyNi0RiRYGvsWXn
	wtkk3WcTYNArcB6uys9LoNmWmMyioSA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7052541A2F;
	Mon, 20 Jul 2026 09:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964FD1F000E9;
	Mon, 20 Jul 2026 09:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540058;
	bh=2Vi2Y6eFLaZZncWxhzA85l4SRnVsg67aEdWUPdvtHPg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XrEyjAsVS7VocJDQ+FLPK0E0rZI39Dwdh6rT79D3/z1ln1ia/tdKr77fL4myrxBLK
	 QCQWUROnM69/sB3uDoCeGiQBeNiwcdluPoZxRIXSWGiR+0GOAZDFFmyUgf/FYyV3gf
	 HvD5TqOH1bEg3Qa8MwMJAKZhS/4iodK/atJcoHnSbIkA/FHqudeoJ3//DpMSC0XnHr
	 TBogyuFZsbFyB6yg211N9J1s6M1ZF30GQN69+dAoMEkSNKBkA5rRIMJaYX+0P0+fJY
	 Dol6pOpfcns7rO1KOv7uiHGBe5kUL/8ve9TMFRXRVSaFodFHkbn6V6QbsppKnvs5ZU
	 K6NXSdswly/Dg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:29 +0200
Subject: [PATCH 06/21] binfmt_misc: split out build_interp_argv()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-6-ddb76c9a508e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3720; i=brauner@kernel.org;
 h=from:subject:message-id; bh=S1I+8XOcJimoOZpkS+sQ4beHcupitoNVrqmvMwX3N3g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm7SDFilVPxMX2L7s6q2imjtE3NOdu7jMjk6dyIXq
 36+qqxVRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQaahn+uweJ89yx/B2WenzB
 +6tnN3+33VscXOLQM3npGlbhHO+pDQz/E7p5tp5b1nuP8fumJ4t9Sh9/1bkc6+mx/1vc0qXxK85
 nsAAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 1CC7F120005
X-Rspam-User: 
X-Stat-Signature: wggud8tpex5d966b5kzqi3iy16855mh1
X-Rspamd-Server: rspam03
X-HE-Tag: 1784540058-527155
X-HE-Meta: U2FsdGVkX19B+k87dZKmgP3H0Pk/o9+6IYo93zdHMigV2iGuVsu31SmJOtCvKar5hBwmc8sl0h1ub0L1u0FgdOTiVcm6gUm2ogsWdFqq8ICSIC/tRYbTDnIjvprQuCjeye196GcpdwOkpNBcTSTF4LQhleKKhXJ40kdO+RkeCmItvNGj65oquqle+WaVzJOFDlc4rg3i8ihQcksmz5aytyKD+oSEa9FfEj9TK9/HwJf4qDbE8CML+KLBSYg9KhRcFAakWGC1gPPK5Phdzvms/FbIiiwh/vK2ix1/rUNzxkEaXbjx6NX2rYYNRYVhABLdhQ32jTOe6HMBCB8O9p3jiBBk0GoeeEJsM+BWAk7ECq73bgimpIBDB03zHC7KF12u7L+R0ZKMuosLnKULj9IK3l3xa3YRUZWrNlSmq62Dmd7cjBqljZAMaM1o+2pebPjS/NHhCqXWzGxGcu1Uy1S5slEapiEl3nX4RfvpERhPn7PpWtjH+hjj58FfL/EQmAD7vEbM0VWRmolywQt4AZvExC+8CmBdoenHMiylGQOCQ+PJuS4/q5sDQEFXQQwAH2aXi8+JcQ+VED6TNKH6TfXXITljPmUf7XDf/Lp/LUMGvv8i1Rb2Da916BkK2XUgFPJIZeML6ClX9GPTG64dmFBmOq9ffrU3JBcC/WO2s2+kIhrnfr3jk+W/nBTxdoGdpxtFmu+ik7OQW73y2RqId2p3uNm3Istv89Xog4rP4sIgQIGegwB6Vxr13Sq91tk6ybWiK0C6qfyPyZ+AvDWVtVXB3eClDQfr2uXS48vroI/gnibYmvNQ1qcSNeF4T622jVt52kznSzX52tOaBLT2O2zVUOZwkCfjG4SgpqnnD3byg2kZaqEo4eh1sobmEUtX/9scGFJGyg/szjXx9fngdgsZaN9/EWE+cFcIwexqjS3Zl5pODPmbYH3qmDEvm1P6pvAoBrbVTZRrDUxOybND5qO
 y0nWS22I
 H+5wh4gSCTnM0/A/c38fOmnq7cuPHDj5yR0KrZu6VflvQCzqTODKGJllLQQ4ZE+E8V2/zGVa2NMekALOyyse4BbGp39RstesEMciAglxP+tYM4ApclVgF9B5QhK6Y4V0VtyTqGOEYQtofgY033ii77yDLsl5XvRbNTCp0SDH5E7XkNW522MmBuHo1+cClk91mOu80wGG9R2bcsbp4E2j9Slsn3SqOeMgFH6A7D/zdEf88S3RwV+xec/Ty+l2ZKPCdGeuq7NBGU1fhhVAWP4nBe/unMn9yj++MZB6g6We2oAFGj3amuadaKkM6Fk6h4aj1BNnLLvi/rFDSweulMOMujBi0SG4QSo6F/2KdDLxsHhf3UbY1HdOBTJ3T9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Building the interpreter's argument vector is the bulk of
load_misc_binary() and the one part of it that is specific to the
classic dispatch. Move it into its own helper so what remains reads as
what it is: pick a handler, pick an interpreter, build the invocation,
open it.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 84 ++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 30 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 63c10066e3a6..f0ccc5d000f6 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -382,40 +382,23 @@ static struct file *entry_open_interpreter(const struct binfmt_misc_entry *e,
 	return no_free_ptr(interp_file);
 }
 
-/*
- * the loader itself
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
  */
-static int load_misc_binary(struct linux_binprm *bprm)
+static int build_interp_argv(struct linux_binprm *bprm, const char *interpreter,
+			     unsigned long flags)
 {
-	struct binfmt_misc_entry *fmt __free(put_binfmt_handler) = NULL;
-	const char *interpreter;
-	struct file *interp_file;
-	struct binfmt_misc *misc;
-	unsigned long flags;
 	int retval;
 
-	misc = current_binfmt_misc();
-	if (!READ_ONCE(misc->enabled))
-		return -ENOEXEC;
-
-	fmt = get_binfmt_handler(misc, bprm);
-	if (!fmt)
-		return -ENOEXEC;
-
-	/* Need to be able to load the file after exec */
-	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
-		return -ENOENT;
-
-	interpreter = entry_select_interpreter(fmt, bprm);
-	if (IS_ERR(interpreter))
-		return PTR_ERR(interpreter);
-
-	flags = entry_invocation_flags(fmt, bprm);
-	if (flags & MISC_FMT_CREDENTIALS)
-		bprm->execfd_creds = 1;
-	if (flags & MISC_FMT_OPEN_BINARY)
-		bprm->have_execfd = 1;
-
 	/* The entry's own choice - not one accumulated from an earlier level. */
 	if (flags & MISC_FMT_PRESERVE_ARGV0) {
 		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
@@ -451,6 +434,47 @@ static int load_misc_binary(struct linux_binprm *bprm)
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
+	if (flags & MISC_FMT_CREDENTIALS)
+		bprm->execfd_creds = 1;
+	if (flags & MISC_FMT_OPEN_BINARY)
+		bprm->have_execfd = 1;
+
+	retval = build_interp_argv(bprm, interpreter, flags);
+	if (retval)
+		return retval;
+
 	/* Update interp in case binfmt_script needs it. */
 	retval = bprm_change_interp(interpreter, bprm);
 	if (retval < 0)

-- 
2.53.0


