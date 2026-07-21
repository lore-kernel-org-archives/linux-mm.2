Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C529C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99EE36B009B; Tue, 21 Jul 2026 10:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951886B009D; Tue, 21 Jul 2026 10:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3E76B009E; Tue, 21 Jul 2026 10:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF0B6B009B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:14:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8C241601A4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:42 +0000 (UTC)
X-FDA: 85012979604.13.966EA59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E489EA0015
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ONsSPN4c;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyGEpYbcwGv7piRskie7GEiXfFGsg+Xr0oBrZjeYwV8=;
	b=LvnAfsHWHzXIfsi/4h0+XnJmyMuQVdOxrrVd2Y/R2Lhla2DrkkaJh33vo7d/7xVQWKTFip
	mjaMyekeJz9uxfD//Ntm5vJ5QUFD2HRNfpuY+9mE0n/i/lL0k2Zsxlj2Vu0lx5PqLLbDqp
	WNHaP4jLQ/eor6iJrtIKdnizrErM1Q8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ONsSPN4c;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643281;
	b=YmAkxMvJaRhJ3fEzAEOjJw/BOpNQPtSBGnMLQeiWyJDkX5llgR+qrlHgsm4bPo2cakmG4p
	VNlqNMXb7Drq5SU78Cq/+4Ke/TVZ0rbPGHzQZ6p/o6JNqoRNfFb1vFJSDVbwONrseM0O8W
	TjScL9+3zuanKFHN9hkXMZHDVa7zUfQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3899D400A9;
	Tue, 21 Jul 2026 14:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E2E1F00A3A;
	Tue, 21 Jul 2026 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643280;
	bh=fyGEpYbcwGv7piRskie7GEiXfFGsg+Xr0oBrZjeYwV8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ONsSPN4cVun5DrXfOww/uNOoV/vVFsfQmMlEIbMbUTvdBuXX/yaORqZquI1GgvXAX
	 DTnJZ7+R2M56xXMkMgqpqK9xY6ywV2JlcfVIqe11nXNuG31WBWg0zQUN1qaL3TvN+p
	 dnPr5YCsB5OujvP0Ie4+oMqq/uKGRzax5sXVtSAQpaZgeewOztOKIUSuTrqYSza1kC
	 ViLjVQCra09ZvWVfXL30UW9v4pxNUkCZ7QHuijjMjrV/fST1IUn/SB9BEhcURO5z8F
	 W7UN//+6rOr9Z+Y5G32MrRlyaaWhnNS1za+Wp4P9TNN8cb3IU5LzY79x+fB9hgA+Cb
	 DSqJRtCluJyVQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:46 +0200
Subject: [PATCH v2 04/21] binfmt_misc: normalize the per-exec invocation
 flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-4-e57866e4ae0f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3918; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QIDHtR3KSxAJAQLN+OvdeHpWTXL5ZRWoOyF3KfYp6pI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1+23SrF7Y3ddXMkgp+jtotNP3Ze/6Yu4HTF375yTa
 3bM44417ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIfQnDP01mI/4jt+KWSh7t
 mLH5xMU1mqd286xbpOOpcfr/wmP/Vpow/I+YuOeHp/ghvmO/RK+k7nTiOnN/3tTJ2x00uhX4mVf
 NWcgEAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E489EA0015
X-Stat-Signature: zyn7cyufc11mfbnt8nrrz3kc85qky8sp
X-HE-Tag: 1784643280-726755
X-HE-Meta: U2FsdGVkX19aEzcJqTT01HlltcJ2LciZ70LTj+YFqO/Dy89U3dLbl6/W6LjE/FR6ISUr2OXfu7VEl9tdDuVX9lYWgeKvsOTpOUS2XUOB7JM+hlSOikr/zIia8ptTUQWs3NdZjjqnGXKUATUOwlShN+c1k2zweHWUhbsYiP+YmtrSuH7LESDUUJK0S5J46eP3qzY/PCtgbYZ4JjYFIrV3JadJnlhbYdCSiYiV0EBtH6c0pQZ9mSKwWVdN8FBfTDvG1lNfxxw0jSWyCbxtf2MMCi/3r1Vh0p0TFSmZrNlsTgEVnH8ClUEKZ0cDePn1jnLe2tTzpa2CeKElO7q7ruGz730t7cRoHz9mccMy6mG2/WptxHiswZVrckR+/L1/otdX9Ckjrg2g2IkA4vHNoWmfhbQ60EbaYiqSaNLd8bd/SokA2d3FuynaiRp7AtDPpO0H0hayh8eBAALik43QUco1U7ujFt7MQDEEvHu5HzdsMu911OTdtXtrZziWR6dPci/ckxiv+qjYDGDzC5UjB9To+pi/wRvOfVm+2ZKuqo9z9+pr5aUgsaK9j0ZCGKYf6QJTuU1tQHf/Vhbs8OC5sprkztkw9njXgJ0HpM4A0e17BTiy/aZJASg30odPLBb2nWJgDeJDi2VoJDgyqR1IARlu1l44IW9+r1pLEGQFwDwCpliNuhHtfx4OyXB9vASdqeqwtlKJxKNJCmL0yFBiJzXPInyX39RqFdUsawYUsqXvQ+NHehfPlf03nfTQfKuWE95CAlvzd9Fn9Z15avWL1jUhCGS/0pgpb349Mj4f0w7gBN8Th19qtz70mJ3s+PmeMO8ai6bJFs3Y5NS9jchPWxPSskdPpnpV07ad0UBSS2sMD/Df0H9XgEb6km/p2c4aWrL2hnJ9qpoVOg+xL4DeUjv7nTWSZdCx0vWw4eBR8/8TfoOKo6EwLZbreTWFQY5kJE8va2sK8KmydNdbEkQ6rZR
 Md5lPbKM
 m8PTauj6vwVNBfqeLIAkAZ2yuHeB98TKJFgTRyDZg8MUp5h2yW4GW0yGzXO1zbpvkJypOwzWI/awl4NS+/GYjkoazcUisVkEkjhmZTJ5QQNbF5XDpfDYASWww/k1lsq2Va/TQI+vAix4zAGZdsSnVjsaeAgRMPgDWuNCd8hTCI9tlq45wTKfU31SkeKXf/6BKIJU5Ch34GmvSZLUQJE69YaUGNwnXIbE7Azwlh0iBazu7ruMLc87KtJRXuInAAk3E0iQx/iMNA4v6j5U6QWHu3768vrayQITJZlpzqKXU1HGlcbLKUaeXOKjUEIQaIaL3j/U9+ZgraK5JrlWiM7wZsEQncEJlrrNlorXILm87BM5bapUQ2wo/K6cRSw==
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
 fs/binfmt_misc.c | 62 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 23 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index c0a3b42a38f7..dc2ee012da10 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -319,6 +319,40 @@ static const char *entry_select_interpreter(const struct binfmt_misc_entry *e,
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
@@ -328,7 +362,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	const char *interpreter;
 	struct file *interp_file;
 	struct binfmt_misc *misc;
-	bool preserve_argv0, want_execfd, want_creds;
+	unsigned long flags;
 	int retval;
 
 	misc = current_binfmt_misc();
@@ -347,28 +381,10 @@ static int load_misc_binary(struct linux_binprm *bprm)
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
-		want_creds = f & BPF_BINPRM_CREDENTIALS;
-		want_execfd = f & (BPF_BINPRM_CREDENTIALS | BPF_BINPRM_EXECFD);
-	} else {
-		preserve_argv0 = fmt->flags & MISC_FMT_PRESERVE_ARGV0;
-		want_creds = fmt->flags & MISC_FMT_CREDENTIALS;
-		want_execfd = fmt->flags & MISC_FMT_OPEN_BINARY;
-	}
+	flags = entry_invocation_flags(fmt, bprm);
 
 	/* The entry's own choice - not one accumulated from an earlier level. */
-	if (preserve_argv0) {
+	if (flags & MISC_FMT_PRESERVE_ARGV0) {
 		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
 	} else {
 		retval = remove_arg_zero(bprm);
@@ -424,9 +440,9 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		return PTR_ERR(interp_file);
 
 	bprm->interpreter = interp_file;
-	if (want_execfd)
+	if (flags & MISC_FMT_OPEN_BINARY)
 		bprm->have_execfd = 1;
-	if (want_creds)
+	if (flags & MISC_FMT_CREDENTIALS)
 		bprm->execfd_creds = 1;
 	return 0;
 }

-- 
2.53.0


