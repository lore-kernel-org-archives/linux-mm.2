Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D8DBC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6476B00D1; Mon, 20 Jul 2026 05:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8E4C6B00D3; Mon, 20 Jul 2026 05:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3166B00D4; Mon, 20 Jul 2026 05:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DA8C6B00D1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE46B140631
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:33 +0000 (UTC)
X-FDA: 85008644826.30.EFF319D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 22282C0006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gAoQ+mZi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRfhe++Vmx0dQogFN2E57R6hUp7AJ1T9ucJh+D1qoow=;
	b=Gk8Reo81wG72kQru6eqkWHBVQbGGr3ry//Emr2F/WD+LSWj4Pvh1Ts2oK4aq+F1NWNcsZE
	r6xqhuLkLSG4YknD0y8U5gHP5lRHX0j7ZC1a0wZT1ILb4e+eDkqPCFGTWZs+CGOkUX3Y+E
	10ohSPanW5pekUxwfMdWOfpoxkdsq8k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gAoQ+mZi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540072;
	b=PICRsYRBvQ5j/9K+Y1ZPZ8B8BqyeiysW1E2pKUZOdpjz4k4e6lkto4l3wDG8Hfb3Q/9l8/
	o/AdhozHe1eRMF/DCP19RDEZK3h3os1qWRZgAOV2tXOUWVJYnfFt6pQvuHNCf/xZ7kNmqW
	4RLSxWnwSDkabScjPLv0e/+ZQ5X7lxE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B2207601D9;
	Mon, 20 Jul 2026 09:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A5C1F000E9;
	Mon, 20 Jul 2026 09:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540071;
	bh=kRfhe++Vmx0dQogFN2E57R6hUp7AJ1T9ucJh+D1qoow=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gAoQ+mZihBhDjed/ZolRTDTZ7l+tHhRSEbo6/jpN5/9N4cFA/lQWQxGkk9BxbUZEz
	 M/E1hkEkVDzIhYef3zRcztpdA/6qETeHVArlOGLigDMU43LBKsrCRumFBrNrc45iur
	 EoD3s/6/zgxFv1dxavE9y0vsQD88ERg6KY18Wc2XX6hCEBM7NPqxbi8uBvnVaIu7Vz
	 WGiaqhRgEg+zq+NVkxO2m6wdOhJM6T1d0YzyJLa0OpGPRCIXFVYUbUc0ZXZjJnnhWk
	 jvhdLWC5hm/t/42VyUQX0ow5m+Ci9bsAULaHkxs+ZLxUOb0YO8AfbhwrYnt5F1EIXB
	 kY7dfSKMR3y3A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:33 +0200
Subject: [PATCH 10/21] binfmt_misc: add transparent interpreter dispatch
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-10-ddb76c9a508e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4278; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qqOcTwx6DBtvc+iZC86zS1LbP+X1a8RKvg1vP8ft9uU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm4SCvb4yufUMF92yq/Vryr+OOsy3OI8Mk3t8U0n7
 rU+fExXO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZS7szI8NLknUv8X7kmzfw/
 MwqPdW3//vCqqHfkuqwjwtqHbOtlJzAyLGZV1X6TeTgrv+yI3P0XTBYVTc6FCyayqixc/UFd1iS
 OGQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 22282C0006
X-Stat-Signature: pggkspapiw78aomheirx83i1ntpnz5s1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784540071-69198
X-HE-Meta: U2FsdGVkX19n5jruXOwWzz/BTPWNCF+dCrXl+0V8uuE5e2A9jUCffttS6JLCcnR4HZQjDEI9V+QouUXIJqzdngZ9oVZ8TG689b2ywB2iJZOifDbFFsufhezxpMsmXWXG5SVscvniSxmMbwDbiUIr6nlCON5aX4RbT8tE9mhT5LtG/tNqRgzkPmYX3aEz8ZyZ1tswkN780mtK7x5txBvr2eT/BT+XWhQcwi37SNhs8ejOr2dG+9Fv+/0jScX75cPB997ZoeTt5vBWUbWe8zc2w7E7S7FAZXl7EvKHOD2OUY/tt6/RbwL8KKFxtngcpxNgEBu4XzGmXCQEf68jYOdHGVTKAsppGn/dqFaFT06am5kE+MEC6PxMUsTCutSC/tXAHYJcmfoMq2SLdHoG6Pp8W+WE+kH8BdovIkFW0zRqzUQn7GXjBlq34Z1e4XPH0zfTrfPOoCdAxBji1NwR8nnJOvQbku4PutC0lokq+rgqIq6L+7Kf/C+yUzxfn9eHoeX4iSS9FeJNkXcPnfR952vAA4Ts7+ZWWDW3wnqSMGkAGpIncqQqMpKMbf9iwMOsSN7y9SIiRyKHrAbwL5TJy3UOgMMFEtzcKpX7y97J1QwCCaMsz3nPgji5tGd2kwgb/4GNYkXEIbpRwWEbNxs6IQngQHj0RJ6FwamhOsVeW2dKYfGhNCewHyDNcvTUMrjt48RDVU1mJP5YMgN7KfmPIICe/iM99yFcRy3eG61bN6HfoqSmfs126ZPxuiJZGN2qJgzQ8iCSu5C1qcc33BL2BPYg2LMxxnSS2sy8AZ/PzwuPbHDf35dW9rpzaEWfn05/wNn+ZkeRYJAwFbfHhxNXcJYCOMihQ+UQMhQ7xDeyjb/T1CpOvnhFAqgJI+SqPFQOV3CaO34JLGMvqkN4iodVCG5A1Q7u/kI43S9wI3CSTaZ7DfgrAFI2OBkr/zyyWkvPED4NBK7+wTfldVFB8oaM5xS
 GlpKwTlX
 xEfNHZQLg2KRtVAvg3Y7oWJ0sN9IMouCvhtLoLLOrpSFnV1BAz/Q8/KoC7TOLaUrTtwRmuwVUXgX8xrmRJynpzxg+wKd/iZWRsRLpjohS/IZVFzsHmi6UaFIVvFF+y1eMasBtX7pqPJ4yzqNJxxOFHzKcYxSH8+N0bbu56ZUCL+NVVR6XcqSha0BRYEWGUUd/F6qgNCNgZy2T3S9OrWZdIKDlx7iAW6CDaHNn4OVwJIljoiJKt+miay2Hvm1x3T9Vd0b3PWoiczBTfoKxDj/QNR+H8PZUz6o76/S9IBR1VhbIdmE6bj1dXlWOn+tZmJ8SS8IizOZ6+Vq4vpln5D082yIluXTR32apeyEHXfMlLhIuH3yOF37BLrOV8/XfqogbJoVy2Hqed0LCYiblhdNeiJMOZEq0Up9ARwk6Flmx6uMSwV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A binfmt_misc interpreter is visible to the binary it runs. argv[0]
becomes the interpreter path and the binary's path is appended as an
argument and /proc/pid/cmdline shows both. For wine or qemu-user that is
the point. For a per-binary loader the interpreter is an implementation
detail of running the binary that has no business in the argument
vector. And a binary handed to execveat() as an O_CLOEXEC fd without a
usable path cannot be run through binfmt_misc at all. The interpreter
would have no path to open the binary by.

Add the dispatch machinery for a transparent mode. The binary is handed
to the interpreter through AT_EXECFD. The argument vector and
bprm->interp are left exactly as the caller set them. argv[0] and
/proc/pid/cmdline look like a direct execution of the binary.

The interpreter loads the binary from AT_EXECFD for this. A relocatable
loader can and glibc's ld.so is gaining AT_EXECFD support [1]. A staged
interpreter argument is dropped so no argv slot is built for it to land
in.

The transparent branch raises BINPRM_FLAGS_TRANSPARENT_INTERP. A
dispatch through it labels mm->exe_file with the binary and raises
AT_FLAGS_TRANSPARENT_INTERP next to AT_EXECFD. The aux vector bit is the
loader's hint to retarget saved_auxv and the statistics markers to the
binary, which is only correct while the exe link names the binary too.

The inaccessible-path bail moves after handler selection and into the
path-building branch. A transparent interpreter takes the binary from
AT_EXECFD instead of a path, so the restriction does not apply to it
and the O_CLOEXEC execveat() case above can work. Nothing can take the
transparent branch yet.

Link: https://inbox.sourceware.org/libc-alpha/20260717-work-glibc-binfmt_misc-v3-0-45129bfb13fe@kernel.org [1]
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index f0ccc5d000f6..239cca389e0e 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -50,6 +50,7 @@ enum binfmt_misc_entry_flags {
 	MISC_FMT_OPEN_BINARY	= (1U << 30),
 	MISC_FMT_CREDENTIALS	= (1U << 29),
 	MISC_FMT_OPEN_FILE	= (1U << 28),
+	MISC_FMT_TRANSPARENT	= (1U << 27),
 };
 
 /**
@@ -399,6 +400,10 @@ static int build_interp_argv(struct linux_binprm *bprm, const char *interpreter,
 {
 	int retval;
 
+	/* The interpreter has to be able to load the binary by path. */
+	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
+		return -ENOENT;
+
 	/* The entry's own choice - not one accumulated from an earlier level. */
 	if (flags & MISC_FMT_PRESERVE_ARGV0) {
 		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
@@ -457,10 +462,6 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (!fmt)
 		return -ENOEXEC;
 
-	/* Need to be able to load the file after exec */
-	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
-		return -ENOENT;
-
 	interpreter = entry_select_interpreter(fmt, bprm);
 	if (IS_ERR(interpreter))
 		return PTR_ERR(interpreter);
@@ -471,11 +472,17 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (flags & MISC_FMT_OPEN_BINARY)
 		bprm->have_execfd = 1;
 
-	retval = build_interp_argv(bprm, interpreter, flags);
-	if (retval)
-		return retval;
+	if (flags & MISC_FMT_TRANSPARENT) {
+		/* No argv is built for a staged argument to land in. */
+		kfree(bprm->bpf_interp_arg);
+		bprm->bpf_interp_arg = NULL;
+	} else {
+		retval = build_interp_argv(bprm, interpreter, flags);
+		if (retval)
+			return retval;
+	}
 
-	/* Update interp in case binfmt_script needs it. */
+	/* Update interp for the next round; kernel-internal, not user-visible. */
 	retval = bprm_change_interp(interpreter, bprm);
 	if (retval < 0)
 		return retval;
@@ -484,6 +491,10 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (IS_ERR(interp_file))
 		return PTR_ERR(interp_file);
 
+	/* Raise only past the last failure, or an -ENOEXEC decline leaks it. */
+	if (flags & MISC_FMT_TRANSPARENT)
+		bprm->interp_flags |= BINPRM_FLAGS_TRANSPARENT_INTERP;
+
 	bprm->interpreter = interp_file;
 	return 0;
 }

-- 
2.53.0


