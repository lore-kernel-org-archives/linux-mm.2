Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B597EC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C7F6B00C5; Mon, 20 Jul 2026 05:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23CF86B00C7; Mon, 20 Jul 2026 05:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1539E6B00C8; Mon, 20 Jul 2026 05:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D91E76B00C5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FD431C007D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:14 +0000 (UTC)
X-FDA: 85008644028.13.4A46FCC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8A5204000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jO6EIZ93;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxF2LOj5owB7AseMZAs3mwjbsnW5b27Au/f5Wy11w54=;
	b=0dval3QB3A9OdMst5HdLlv2Ldtc74ubwhvcf1IiUfCOld2Iy4TuaKII/k6t622GSnTd9gq
	BX5TZzNhFy0tIOX0NLXcX9E6yy38iSwnPy8xKv6gyvWNamoAENNrvoPbU2YVt/k9qEndK5
	T8OwWIQ7IF7yAcmocB0zkGiLw4XtFrc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jO6EIZ93;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540052;
	b=E5Uf2/oAf5VW4/OGeBWYahgps2zuMSMLCcxX8c87MqjJ8TA1je5FKL3zA6QVbLxGdPmtMZ
	bqFU0895sI5xVVGz+36M8Ut/BmMalCWUJAzv8JZRCGLa+9vJ1Grw6dCS3c6Y2ZjH9CgvwI
	srD4xszyMyr3l1aOyn+5Vdt8W1cVmwA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD76043EA2;
	Mon, 20 Jul 2026 09:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F64B1F000E9;
	Mon, 20 Jul 2026 09:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540051;
	bh=IxF2LOj5owB7AseMZAs3mwjbsnW5b27Au/f5Wy11w54=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jO6EIZ93I+GRI4GA9wOElCT3QrhIn/Qwg5lzTP248wsyruzxdpTd+oP2WutLdxhkL
	 E/XLwAfBoUnqJ2KUahHWvDp6BLljJiDjRaS6++3b0neXMK77FILqYyrK1zuKHkTUgm
	 5cVaZvlhJkPFGI6YMvQaD7lWhDo1nOdSbTv0xnISfGPnDsKAZm7oR3Xdodaq14Tbhh
	 UW064Y5x7qDjQixSErNTZJGXZxK04deUnkz4wAegcobQU6ZW+8vBk6BqUmjaYtofTP
	 PkxRTqq5dc83UBDvVS76918QEyzxGrQJodhoAbxme9HZ2ZizIol/85+UC1lD+9JL/r
	 jtujj0bvz3oow==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:27 +0200
Subject: [PATCH 04/21] binfmt_misc: normalize the per-exec invocation flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-4-ddb76c9a508e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3765; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WY80KBFFTZ58IsmgG8CgWNhF100PcOIx0XJMaNp2qm0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm4qC2c8cZFt6Xvv9EU/Dk5bc8eNZVmhhNeM9HXPc
 i7WndE+0VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARA0lGhi+3n/VG1GucNWjn
 P3wlOOdmiOniP3mhmV+TOpPYAnb+nsnwP+tx6/rvPMlpJgUqy43f/575t2PmtdzVF+yc27oqLBg
 qWQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A5204000B
X-Stat-Signature: gp6iduwgdaz47neyfo9ozz9xckc9en9i
X-HE-Tag: 1784540052-290555
X-HE-Meta: U2FsdGVkX1+3xAfbTMYNTHR11tOYXmcvzZXZOQfOpU5MpJy5vhnP2f8WKQZln1hptZ5lFvrMY9PoFPbYu712JjOIRSaB32sMba4fYlh0cfrt+HJhrFacRbHYvqbVzQdvVSv2oplhhhSN5Bt6IgfXOzvzBf6DPXVPesXY3MjrZbpuO5/k9cF8M0/yAaPIsp5vEYGqZnAYGB3Yvpo1oC4eSCElWV/pfcF+athVeIaN66vu2Oa11fswxWsAZYoKW7K5v5w8LWZhCuiNoJKy+tipfGsEWSzRTa2qS5OHfKMLhskS2HxkDkKfsZTJqSj0egn3VEzaxaqPXMA8xwtA45dUv4ss9yUZDVgLNHDV1urQwKc2DegEF1+TLU1igUjHBzB415ytN+vcqo6TzzZHBzrn+3jN4ujKoQwMucDIqxVQPoQkW86Zk6MURFVsXyRDplLf0zo3dN0Tuj0yA4tbcVWKTHBuomuB79XGuUTZwUvlBsueif952wrPSTY5tfFc/XTAtWAzGtcEB9iCBXllnJjT5QHBWFFwjcvktUk9TsbacYhvhlYKS7tG+0OGId+uunwcZ7CZRRdEmU1M7zyVXX3+dFtAFMgclkmml90S6P3Q3uGfG6+EhAJw/RMzFUzmhEYuVRRXBhgTAUouyXUX1W9+i4vCFv+3q7UVbhIawzuq0BQatFohIW+F9ArxONxz4UglXoFx2D02Gik0GGFSIhnKviHxTGBehvzot70ktmBDMKjsYoJGV1CoWdaez83wcScurUfWojH25Sz8s31nTZIwe9c3D5CXJRrJyTvQ4V7RieJ7jNNL8LE6N1hCfs79Q0erW1JC1ll84gmgIclyV3bgfWZxeTQTDf55pXTW7TGflofmr2aCj0mFTKuyvjd5CZa1v1TKoX+pyrHt7nJz/sc87tgqjbP54ue4GDpizryymGha7am1wKcxXNc+ubfm7Qd1H78j1BNyQbmmD9tV+nk
 6wth4JqO
 WGrONAilBnqv1BPxnOuLZyVxe7jRGbLuvSp0EMckqU96d1PtY+illNQvwpzYOxsHnDqjN6F5FUFS1ZUdJ5o9xRc3j4eRM0xVVb4z982F00QWrzPrFlDhxprv2IZNU5c8a/QVvxlb8r5h5JgsRDpo0RJxBfeWAsjV8aWqKvnk+9M7MJSY95Se6hJSv79yaA0QqOrfJKfqI9RIa3pI9msY3cFTchtroIFU1DjNRKK7y6Dg9cH1ugMK2qyaATTyvYT+XkO6UpQqP/GBdhuxZH6c1Yn4HxWq3cIjZ8EcB07l97dxhSjhFm8/C3HSBt3wA6vUd1HLKY7QV2m2A7/nHAcyqrE89pxVPR/UOEiGsIVVJiZSCgNeE9Tv+q3S5wQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A static entry fixes its invocation flags at registration. A 'B' entry's
load program picks them per exec. Since load_misc_binary() branches on
which kind of entry matched and then applies the two flag sets side by
side every flag is handled twice and each new one has to be added to
both arms.

Translate the 'B' flags into the entry flags they mirror and let the
dispatch act on a single set of flags. The boolean the two arms
communicated 'P' can be removed.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 66 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 25 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 521ddda929a4..7a6bbeb8a58c 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -318,6 +318,40 @@ static const char *entry_select_interpreter(const struct binfmt_misc_entry *e,
 	return ERR_PTR(retval);
 }
 
+/**
+ * entry_invocation_flags - the invocation flags in effect for this exec
+ * @e: matched binary type handler
+ * @bprm: binary that is being executed
+ *
+ * A static entry fixes its flags at registration, a 'B' entry's load program
+ * picks them per exec with bpf_binprm_set_flags(). Translate the latter into
+ * the former, implications included, so the dispatch has one set to act on.
+ *
+ * Return: the invocation flags for this exec
+ */
+static unsigned long entry_invocation_flags(const struct binfmt_misc_entry *e,
+					    struct linux_binprm *bprm)
+{
+	unsigned long flags = 0;
+	u64 bpf_flags;
+
+	if (!test_bit(MISC_FMT_BPF_BIT, &e->flags))
+		return e->flags;
+
+	bpf_flags = bprm->bpf_flags;
+	/* Clear so they can't accumulate into a nested interpreter level. */
+	bprm->bpf_flags = 0;
+
+	if (bpf_flags & BPF_BINPRM_PRESERVE_ARGV0)
+		flags |= MISC_FMT_PRESERVE_ARGV0;
+	if (bpf_flags & BPF_BINPRM_EXECFD)
+		flags |= MISC_FMT_OPEN_BINARY;
+	if (bpf_flags & BPF_BINPRM_CREDENTIALS)
+		flags |= MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY;
+
+	return flags;
+}
+
 /*
  * the loader itself
  */
@@ -327,7 +361,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	const char *interpreter;
 	struct file *interp_file;
 	struct binfmt_misc *misc;
-	bool preserve_argv0;
+	unsigned long flags;
 	int retval;
 
 	misc = current_binfmt_misc();
@@ -346,32 +380,14 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (IS_ERR(interpreter))
 		return PTR_ERR(interpreter);
 
-	/*
-	 * The invocation flags are fixed at registration for a static handler
-	 * and chosen per exec by the load program, via bpf_binprm_set_flags(),
-	 * for a bpf one.
-	 */
-	if (test_bit(MISC_FMT_BPF_BIT, &fmt->flags)) {
-		u64 f = bprm->bpf_flags;
-
-		/* Clear so it can't accumulate into a nested interpreter level. */
-		bprm->bpf_flags = 0;
-
-		preserve_argv0 = f & BPF_BINPRM_PRESERVE_ARGV0;
-		if (f & BPF_BINPRM_CREDENTIALS)
-			bprm->execfd_creds = 1;
-		if (f & (BPF_BINPRM_CREDENTIALS | BPF_BINPRM_EXECFD))
-			bprm->have_execfd = 1;
-	} else {
-		preserve_argv0 = fmt->flags & MISC_FMT_PRESERVE_ARGV0;
-		if (fmt->flags & MISC_FMT_CREDENTIALS)
-			bprm->execfd_creds = 1;
-		if (fmt->flags & MISC_FMT_OPEN_BINARY)
-			bprm->have_execfd = 1;
-	}
+	flags = entry_invocation_flags(fmt, bprm);
+	if (flags & MISC_FMT_CREDENTIALS)
+		bprm->execfd_creds = 1;
+	if (flags & MISC_FMT_OPEN_BINARY)
+		bprm->have_execfd = 1;
 
 	/* The entry's own choice - not one accumulated from an earlier level. */
-	if (preserve_argv0) {
+	if (flags & MISC_FMT_PRESERVE_ARGV0) {
 		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
 	} else {
 		retval = remove_arg_zero(bprm);

-- 
2.53.0


