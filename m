Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C3FC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FE06B00C7; Mon, 20 Jul 2026 05:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE756B00C9; Mon, 20 Jul 2026 05:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CDD96B00CA; Mon, 20 Jul 2026 05:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 551E86B00C7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1D381A07B7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:17 +0000 (UTC)
X-FDA: 85008644154.12.93447AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EB9B6100006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QA7RLa9Q;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GDtZ/H9PPREqEQroKi/tSbzImHJ30r90YyvmcEwAQo=;
	b=wfzVgNLw8H2R1EcnLqWYjXfXScXFj0mNV2/DMrSLvixSN/e+sUH+2XCJA85S5s5moLKGjL
	2jSegeZraQWxYtdofHJkmZsFnnwfXJfXalWiKcL/VJ0YosWTAjn6VzQ1SRXf9vsyNNaCvG
	CJ56sWgNRCZ/Qo7vY/zhzipbOz0Q3e4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QA7RLa9Q;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540056;
	b=Kpc10joieH2i6KYKUhvQg1w6CmF3UatprD6BCnvHVhfa3ioCyuh5YN2fGOXTbHNIbn5dho
	bORnvWQoKssbM/Kwlh5cBBkvKSUORdj4HHvc/ztlm43144B5eCTwdDYhsyEAsn50WoROTn
	+iK70s7SBL09CEiGzB6vmDU6ejbcDQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FA3041387;
	Mon, 20 Jul 2026 09:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EEB1F00A3A;
	Mon, 20 Jul 2026 09:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540055;
	bh=1GDtZ/H9PPREqEQroKi/tSbzImHJ30r90YyvmcEwAQo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QA7RLa9QP1SNmuoZc7iunsr2CmLaNtwj8OM+BAV/YHGw6uzfHI5uoU1JjHuEq5TBZ
	 iK1su5CVPaC2a/DtjPRMF4GGRA8uZ4lB4Ib1cRq1bL5OzWJKgwEYKlb/KdOPUsAgRr
	 72xlwvjhTyvTIp29vcN1KmhzA1Ay9a1/76GrPPl9m/mE9tJjKIi/8sphCnHx3X018E
	 jouqZqg+qTV/UIAVIxmls32K6Sw5Pk0WIv2llawmEpAlV1R42326b6+QOrjGv7fcYm
	 R3EqZdfplXTgN5Nf+qZCYeieJHdc2xYpygQcY2d+j5bShKkYGM4ZvEQR8qA1UfiRJH
	 f1+5Pv0aScTIg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:28 +0200
Subject: [PATCH 05/21] binfmt_misc: split out entry_open_interpreter()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-5-ddb76c9a508e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2360; i=brauner@kernel.org;
 h=from:subject:message-id; bh=rTLpfXr1BN78GmzRT93H9qEQR280+PMjndmHO+m2QyM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm7yVZj6SXb71wclfLy13s1ffzav2VM3zfPyxL36g
 UXPJMusO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaiNJmRYXp4jZHv7AvszMwL
 2o0r7thc+5N5QOmKVsxXrj33sjT3SDD8z0g75T+79Ekgx86ehZlvflcW5+qVME+2FmuKnWRc0P2
 NHwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB9B6100006
X-Stat-Signature: qsasqof1hu6rk5ikja7uo139sj19fgh5
X-HE-Tag: 1784540055-435252
X-HE-Meta: U2FsdGVkX1+KzJP75FlolGWTIBUo5YrzGOgVk3Uk3KXkS3Yhs+MCQ5ZbEobqy639sOT/yYHBo3AbfLTZhVYWQoEravJGdZ0brnzJe2oDPM1ujbOF0gdES005KHkYm0lSlhjJ/CRluzDag1rnrcI9DOWp25SHJQLe74fypQlQbWyDcxFQ8nDHp233y4XHoR1LrE1AcWYki92LGLUtjRl9dRMOQf4kgpQPoM+kBd77eIy7ZiPnnox9CVBElMmpcoS3W9Epm9UtMoDFnOY1iRwN3tNmtPRQlGe+oojYqLb84TpA4EJ9qciuCWgdWpjWOJEnmShexSXdeTL+uhMXbnaHWdBxM26GUr0TEcAbXhpJQ64Hw7CIBBF99cVupbXe0tsm5Fk9cUSlC8WzLhZjelidcknaECeHqFTWSPbAw9klXVIOmo4OpKRymZ5gL8eywv1ZOkJdGhGkyfS56jtqMc4sPlh2utt7LjXvJnOEuliFTdFGcqApi/+TYg874jv6kJCYQFJPFMwleezoZnf1cb8pQ5Fb0ZpL9uH03iUOxIOww4d/QXDimtPhX0jUSAWvqJ4ycwWq95rNYI3vCFDF1uKHDJ11ovlvLVyRZyLJCR9zyi0SWqDo5dDUXeyThgNnow9aVhA+G4piACvzi9SJdMEU9ZYMYpk1gESnNdOU+LLZ+gpk2UYv62Pow25NpFHG+b/VfmCi3zBXJV4s+Ki8aQb+ydiea0r+X46MgWUxUdHWaXCAfN7iwuKzkg736cA1b2aiQGp7kWqO3Ymz1gxeSJAFN8d7ckV2T29ft1iSHL0THyZ1RQaZuZ6p49WizWEZU7ge1jSF0v52cFpqryo8H8U+V8j2Cj9wbiIcxcIV3SAELQHRijXWaElZ4Nbie2lDuHpAU9faWpLbNc3+jpzQZK20Yo1ABzOk31rOei1tFwIDYy98PAKcdGizzQ6xWJVqqWW8VRvku63cQPc0jpqUGPr
 70D3gocb
 uVRJOTID9kZ9vKYr7XkC6tk5G8seTXfZgo+dL59SIpiZwuy5K4GCSOqq6loshnL+Hno6b13DW0jy9VoPlUAt4vu3VW/lZ8rktm+5V9pS4fQWMG0NNx4W1KB/kbCW5T5Y+CFnvQxP6viIe16mlaeRE24JN0FK8wCwB0oMjDt/cLMkGiv8Cu0r1yY5tdKCcz9/gYhbBV4W5mu3BaCltZWEfeLNT6kS/4JPq16A2D2IvG1jBiKEMWgakiOGwrBqRcGILFIhD7OBDponONoh4U87R4eFlB1C67A28T6OtvQeuA4bHaBhp0RjDVXNLVye6k3gtVQVdsr9Wy8lh279fyJUmTJm19OM4HUFsnpAOudgMC1X/RfLNR0ht/p/mkLGUD4cq7Blfo188BQ/CCMI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Opening the interpreter is a property of the matched entry: an 'F'
entry hands out a clone of the file it pre-opened at registration
time, any other entry opens the selected path. Give that its own
helper instead of an if/else in the middle of load_misc_binary(), and
let it fail early rather than carrying an ERR_PTR through the
successful branch.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 7a6bbeb8a58c..63c10066e3a6 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -352,6 +352,36 @@ static unsigned long entry_invocation_flags(const struct binfmt_misc_entry *e,
 	return flags;
 }
 
+/**
+ * entry_open_interpreter - open the entry's interpreter for execution
+ * @e: matched binary type handler
+ * @interpreter: the interpreter selected for this exec
+ *
+ * An 'F' entry hands out a clone of the file it pre-opened at registration,
+ * any other entry opens the selected path.
+ *
+ * Return: the opened interpreter on success, an ERR_PTR on failure
+ */
+static struct file *entry_open_interpreter(const struct binfmt_misc_entry *e,
+					   const char *interpreter)
+{
+	struct file *interp_file __free(fput) = NULL;
+	int retval;
+
+	if (!(e->flags & MISC_FMT_OPEN_FILE))
+		return open_exec(interpreter);
+
+	interp_file = file_clone_open(e->interp_file);
+	if (IS_ERR(interp_file))
+		return interp_file;
+
+	retval = exe_file_deny_write_access(interp_file);
+	if (retval)
+		return ERR_PTR(retval);
+
+	return no_free_ptr(interp_file);
+}
+
 /*
  * the loader itself
  */
@@ -426,19 +456,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
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


