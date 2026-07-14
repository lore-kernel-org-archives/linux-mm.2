Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA7F6C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4826B00E1; Tue, 14 Jul 2026 15:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77CE16B00E4; Tue, 14 Jul 2026 15:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E106B00E2; Tue, 14 Jul 2026 15:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 284796B00DE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:58:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2CBE1A04EF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:43 +0000 (UTC)
X-FDA: 84988444926.09.F85E02D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id E7DE720003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ldTGOKqe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrII2yqfAxov3h2f3TrylfxbsK446SzmBTiehyPo/x4=;
	b=Nt/Ex7hjGWj7UgOfzrTNYlCD7h2qf81uVLyAq3QQYKDfVjyHdTAITyUnJw93B47P3ZYrkc
	36ILqjh7AfZnDXzHZ14qHD0IzOSdyzHenoiE0fXRjBLpl3pdpU9Mrb7G0lMT8f6YhOEvS6
	MXGM1YD7Y7SdYd9bjiQjm5B8AU1t87U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ldTGOKqe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059121;
	b=M8vg97UDjsZ4Ll+PCBgOq1CRGA6WgO02hrQd6sNshPPWS+yWrNcMPjOSGILyjm6Alp4xOl
	MXVqbL8LjKHX2PuwRVRl3PXnh4mJFeTqVnzLeEfuDnV3DhYthPXD5wNN4VFtDum+dwn/LJ
	acejMYJ3i8C4LmB7S2HP8ssFF2oW2Ck=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FCD3601ED;
	Tue, 14 Jul 2026 19:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E921F00A3D;
	Tue, 14 Jul 2026 19:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784059121;
	bh=xrII2yqfAxov3h2f3TrylfxbsK446SzmBTiehyPo/x4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ldTGOKqetGQvzmmKjn7+qOMI2CQ/9ByRH8kK+yHEF8b7tZEOaf7hwWm5/cbxL8Bv7
	 6a7FI642cNuuaarcDRP4nmalI6SpMnBtvbhmnLptlHoJpAfuQhLn+hOGyWfUfv4yjB
	 XDC5UVQaUsQaQMb9hovZnW8xfpwI8kvRYq+/9HLr1XbJVwKE2grcdKh3COPX39A5Xa
	 8Vv2nojgffagoy08HGuJaxGSokDZCIyWffGaAnXYjbiSasjQOttzZWQng0qtsyTYZz
	 0cAHrNHxp7TF71JJPQp5qGoWXyJ8aJoG5F2kilK02nZC+JiEKM9Dtx76xGRoeDOTD1
	 HvwfKREQdcwCw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 14 Jul 2026 21:58:11 +0200
Subject: [PATCH v2 6/9] binfmt_misc: let bpf handlers pass an argument to
 the interpreter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-work-bpf-binfmt_misc-v2-6-57b7529c002c@kernel.org>
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
In-Reply-To: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, bpf@vger.kernel.org, jannh@google.com, 
 mail@johnericson.me, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4198; i=brauner@kernel.org;
 h=from:subject:message-id; bh=d4Ff11U2JQdbUrC3jXwwqEI22gBF0oG5S4PDLPyJubc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSFTbm8NDhILvuQVPpNFlE35xeTw8IzTljX+s1o6Qm78
 ekxM9vmjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkc6Wb4X9vyzaNRKLUs7LdB
 hEfiiRPN0Yf9wn/u+HGUR5jF42unCMM/+wVCEm/mlN55NCvj9/3zkQt0+F0eC2/4vjNl46SeK5F
 uXAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E7DE720003
X-Stat-Signature: zmixu55zni3fh6dipwewwdykyi9yekn9
X-HE-Tag: 1784059121-762780
X-HE-Meta: U2FsdGVkX18LFNWT0dJtLp8Jf4sD01iZ4X7AgxxrtjnCw7rf4oR6ZDJphiukhA2Cq1f8938WSsVG2qpHqTSQB4eLp1qzQxKpH1TwOtmIUHm3rHm2HUkaDXl9pToRC7nDYAGwtll15f++jCd52kRa2pDnxIJ/panK3pUKLZgSmpmoOkFXB6eWmPbwWOnbWWpSAtyzFCuaU6KbuYB1Diy+f/pma312bC3BJhfoxDlO5Kkv4pMu+vRbz+CY0uSMcCadEkeutbqf+2Bj5He/XybENIphb73+ch/X6zLQHFD0alE5BSq3vAv3c7hqcq5hc1cKA/ktnKzIjIB00UsBk7YkhKG0Jt3SwTbzymypSJOVQy5sDRKNluo0mpFkTVIrQeiUKpn8m/Mq18xTtMnDzrxNaDrwUlOaG7PkC25VpiMmPKz77MGUbysQqkUaSFVn/l9/H1g+WK9kXzoss+K3T2cBoH1CVPqWVf/suRMwyHiFQ/hHzJJeHfxWs39USwpKnTCGXhSRJhLt981y5Zvyf15uSN8U2oaTMUy8/YjlCO3e8iqtnulDX0N9EHKS4UnATeuGWTdiLsDbLqE/E1eDoEAV1sk+Cm85ZMOpcn+24z5dKMfguoM3u1Zt6WgHu1VapUlWoenqbAI1NgDAOUWtlaur+k44X0LPeCo0tcGxPgGKF2mX8bR+STCeJBeQzatV5TCqLYhElQCv627+OQvc8S8OP/z7MbA2gQDLT9wD7inEss4ndbrnAyAWDvu7UsCh//IOfV5O8iDjAfHE1ePybiJwjZ+JbUH8aDPx3fdE0qRviLeZxq/NkrWSngatGkgbcDae4AEm3oh7w0LAGXVIqlQi8McD4cXQdKvQzvyrOH775LZWRLvB7qY33Wo2pjMcnLEi3lIVm88ne3iJ7o1tpUaUYyETpncfl6EQio9R7PK9vrZvq+ZSZ8ZrtToe3xp1oC1FErN0BrDax1Gs/HXVqO0
 +f2Mx2Hl
 TJZCe2e8JEJ9Qo3vBKOofw4A9AdzYrP1wN4+Jxa+FlbI/hpujSeBtDIFHxg8Td/ZUZaQypw/LO2BJWGqKm0opDdP+4dU5TyBA2VBRN1O/6YkAz1YinTgGdOzAm4n+fUtHdAMPpWQUJLTeClFixxvmJ/M0q3RDG7LEuqCfwGi4OJwZZkQNTGDNY+VRfSsWRUmPzkEDoej3ti68MV9kbCiocEjqCJpE/xK3hQ2gObDe6EIjA3sEgWlbD5Vts9iQbp2SWKAxWwuAgp242yJZ7nk59vYeyvZnYSdu3XJiR17iQuKajV9KgwjOOWW1rJ4Y4PIkinfEOvi2v5FeeLitD0hCQgoW+8o3+L91biWGpI3Qe4BftrLgIpKG07mHLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A bpf binfmt_misc handler selects an interpreter but, unlike binfmt_script,
load_misc_binary() builds the argument vector as just [interpreter, binary,
...] with no slot for an argument to the interpreter. A handler that wants
to reproduce a #! line therefore cannot express its single optional
argument, e.g. a handler that resolves $ORIGIN in a script's #! path loses
the argument that followed the interpreter.

Have load_misc_binary() consume the argument staged through the
bpf_binprm_set_interp_arg() kfunc and insert it between the interpreter and
the binary - the same position and single-argument semantics binfmt_script
gives the argument of a #! line. The argument is cleared once spliced into
the argument vector, and a load program that fails after staging one has it
dropped on the way out: whether the exec fails or -ENOEXEC hands the binary
back to the remaining formats, a stale argument cannot leak into a nested
interpreter's argv. This also lets static-style handlers pass a fixed
interpreter argument, which plain binfmt_misc has never been able to
express.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst |  6 ++++++
 fs/binfmt_misc.c                          | 30 ++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 45541604d528..6128057160e3 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -129,6 +129,12 @@ entries; ``-ENOEXEC`` lets the remaining binary formats have a go. The
 interpreter is opened with the credentials of the task doing the exec,
 exactly as a statically registered interpreter would be.
 
+The ``load`` program can also pass a single argument to the interpreter with
+the ``bpf_binprm_set_interp_arg()`` kfunc. It is inserted between the
+interpreter and the binary, exactly like the optional argument of a ``#!``
+interpreter line, e.g. for a handler that resolves ``$ORIGIN`` in a script's
+``#!`` path and needs to preserve the argument that followed it.
+
 Handlers are looked up in the user namespace the struct_ops map was
 registered in, falling back to ancestor namespaces, mirroring how
 binfmt_misc instances themselves are looked up. The entry keeps the handler
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a8f641c4ec2b..3fbc51197c76 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -268,14 +268,22 @@ static const char *entry_select_interpreter(const struct binfmt_misc_entry *e,
 		/* Keep a program-supplied error within errno range. */
 		if (retval > 0 || retval < -MAX_ERRNO)
 			retval = -ENOEXEC;
-		return ERR_PTR(retval);
+		goto drop_staged;
 	}
 
 	/* Selecting an interpreter is part of the contract. */
-	if (!bprm->bpf_interp)
-		return ERR_PTR(-ENOEXEC);
+	if (!bprm->bpf_interp) {
+		retval = -ENOEXEC;
+		goto drop_staged;
+	}
 
 	return bprm->bpf_interp;
+
+drop_staged:
+	/* A failing load leaves nothing behind for later entries. */
+	kfree(bprm->bpf_interp_arg);
+	bprm->bpf_interp_arg = NULL;
+	return ERR_PTR(retval);
 }
 
 /*
@@ -316,12 +324,26 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (fmt->flags & MISC_FMT_OPEN_BINARY)
 		bprm->have_execfd = 1;
 
-	/* make argv[1] be the path to the binary */
+	/* make the binary the last argument to the interpreter */
 	retval = copy_string_kernel(bprm->interp, bprm);
 	if (retval < 0)
 		return retval;
 	bprm->argc++;
 
+	/*
+	 * A single optional argument to the interpreter, inserted between it
+	 * and the binary just like the argument of a #! interpreter line.
+	 */
+	if (bprm->bpf_interp_arg) {
+		retval = copy_string_kernel(bprm->bpf_interp_arg, bprm);
+		if (retval < 0)
+			return retval;
+		bprm->argc++;
+		/* Consumed - don't let it leak into a nested interpreter's argv. */
+		kfree(bprm->bpf_interp_arg);
+		bprm->bpf_interp_arg = NULL;
+	}
+
 	/* add the interp as argv[0] */
 	retval = copy_string_kernel(interpreter, bprm);
 	if (retval < 0)

-- 
2.53.0


