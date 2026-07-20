Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60E1DC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C6F6B009B; Mon, 20 Jul 2026 05:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE786B00DC; Mon, 20 Jul 2026 05:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78116B00DD; Mon, 20 Jul 2026 05:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2D6F6B00DC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F4D0140736
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:53 +0000 (UTC)
X-FDA: 85008645666.11.F4C2843
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 64CDF1C0010
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K3dcM21p;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540091;
	b=f7xxCqrjOeh1H9+u95XpK4NMS8RzZMSZpTKolMA9PBkvuCX/axKSOh6Dx7b6nFZBnJubR4
	fEfZHn3ScZGfo8dPbHNBXf+vDcI/EDU8VWITrhSBDVWJ6VpaeAkVnQ/KQLAMHV5d+ZI+gK
	Np0e/8HM7Oehr3VXSxa+8uItTvy0JQY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K3dcM21p;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTLWrh6caoD4CwLDzNTxAt3JlVH4gwwkfJU5sX9FL1U=;
	b=ewDikv/vdnW73g6F8dtjRXmMEKYnVe8bWJYmihCrABAwyNJmTbqltXP+crDqQtjlTe9+QQ
	IXmeInp0v/gHYWAx6bgPT0Vq6m6F0gYFW5jv6rUAQEik7JzFvR1ePTf09JMSf1wwlcFGmh
	9uxvkavULSb9KBjRVpsHje9+itKJ4lg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3D2043FE2;
	Mon, 20 Jul 2026 09:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8421F00A3D;
	Mon, 20 Jul 2026 09:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540090;
	bh=LTLWrh6caoD4CwLDzNTxAt3JlVH4gwwkfJU5sX9FL1U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K3dcM21p+m2SrtYLQIkzXAXOKFJR71qgjlFct9K1ryfM/c1CdWvAnAdravTwuTc/9
	 ZgarO3e4TXpe1IrGauTgUmgSNlELIYaQaHm7FOWcvNe9a2zswu9NKjfxAA01hPoWGN
	 yBnYMrZR2bZAxv9ahZs/5j5mDltPmdi69VyBFoLjcHGpAOtCKbhfrZXImlv7sisIwe
	 EtCyV8B2dw1NNYBpFSw48oxExk0rLHbT4fSaCaMM/lBteTUNUKsakEG0x2snlnqH8k
	 BYCJnGWYUPJEW0doVOVhP9eYMHMrpLjgLyYTgtt+WZtHnbrrk/rEKSRsQDK7I/lqUQ
	 qwne+RUKZdaQA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:39 +0200
Subject: [PATCH 16/21] exec: carry a PT_INTERP substitute in struct
 linux_binprm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-16-ddb76c9a508e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3383; i=brauner@kernel.org;
 h=from:subject:message-id; bh=x2DkL4sFAm5IyQlbm2cRRy4gizA87I+afph09+me8n0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm6yXpq/pXDH3p+bXp8Wyf8690tnmr3pyq8cp1Yfl
 s6dePS+Z0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE9h5l+KcTeOGKlszauJ8u
 p3XXvNSSWyGdWfj/f6NL34YNSe3sqhMZGeacqN/+MKWoZuX7lTcPR+541ZGrq3w34tsXkUJrrcb
 ou3wA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 64CDF1C0010
X-Stat-Signature: ykk97wrft1dentydzrhspu6h9xc6n8fm
X-HE-Tag: 1784540091-647891
X-HE-Meta: U2FsdGVkX18BDWYh7fduu2b9hg+bgo67X2dhpUpdJXgKcjBoPmNDDvIFXyCe75+ixlfs8lrX6tBfNr/nEnAHqAunEq50iUeL4RKkENv7pEcOe9voGNcDRxlHFPaQhxtgjgH6NdDudPfxhpsFEw3MZL0jmJKt8pcgFH0hKmo+yKiT3oCVvBXpwnGpRm84Q1HODAQdCWh3NBcyCKE/XPa2jwAbengVw0+n1n+0kTfqJTHDNUdOrnjqVS5Zi2RyVdgJfaUJr5c0eiaYVa0vmgKMzZ4FdpUa0Xkv3905F2n6xwQLgtTDh3Tg+JFomfxOReRU9DEojxshYrsPEGaTz3VRVjbtzAic/RoSIk1Dt2d8DF2D353eUgF+og+Lmh6IvgohsxB09hRsG50yDgteHdT64oqcvEdPCw6WU5T4VHD+aYTtVoAwTEp7VFPkW8XQMTykas2xATW1/Ziy51B4MyvFlF/2JsgHTiUqQJHMuQJNHfRez/0qPN6IQPRIHHMkT/47lsXyh9kCLSZqhuobup3DuKOe1Knl3EmVW+4BKq7bZ9SO9A66gEYpU4p283JyZ0eD9lO8mt+0wDkOIqX3MmpTzb88NDOW51VTDI2kUr/lUdwPFVykKCdeIHJx3eZrij3PlETzd7W496cX+Ruk7kmX4AUWad79IZhlvQS3abFJyPcmDSudLa1YvXgqLndAS8HfEvfhbo0mLALzZIu0yWSvqbNkCqiAIUZB6sBzPw64xQ2auZ6I1U5neWx5JulOH9c91Vdb9+K0bxyNGH1i06Tp7ruBfONRqv72Ikt/6iHpId/bPlIUwLswtjd+jOhAhcd4VNGIUkn19XkVGVY8AWyiLPuU4qTnfeACdedgBagso/vgnc3qGF9lUao/6qRywSubCDhQ6eh21LjLrnTpMxhx8tMUMhSJf/UwY2eq3m9mx8xZKc9jcJY98rQiPNLvx7DhzIzhkeKw0lNMhDi1wZ4
 lhjlQ3+J
 CITHznbeYgTqHt8Ju6DKGIHi21nf3ykNGn3x7v7OPvhWWKwXvbw1E2XnQftXPIFCJjr0c0EXAyZ57q0IoeyXZOzXex2lF5t5NWYHE/M5qpRIDKLfu/gr47YllDH+nFEOoPkvrLFFfGcQ/Tw79BDAjzglDF44a9WsVorE+b9GhYMHC5AwPFWASFt0OM09Y37+YGBfrXD2L8iMTjvzbr3P7sYE327VW30/2NehFRh0XDoris4My9sG2q2pqF0LjmCJ07pdIBm6twUZilLRIPtNH8+W1pmkCLzgWw+7recO/UZQ2UTG8XmMCUcpVZ08ewSCQWRQBuiz6L3dk1v8KiSSaEcFYJrqi82hq3vwiCCTn7LuKHA5iTO/J+Yd3k2OJ4A7/Cd4n6O1ZwmQpsYo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

binfmt_misc currently supports an execution model where the registered
interpreter becomes the executed program and the matched binary is
handed to it as payload. The upcoming binfmt_misc loader mode inverts
this. The matched binary remains the executed program and the registered
interpreter is substituted into the role the binary's PT_INTERP would
have played.

Add the channel for that hand-over. bprm->loader carries an
open_exec-style struct file reference from the binfmt_misc match to the
binary format that consumes it. Unlike bprm->interpreter it does not
request a restart of the format search. The stashing handler declines
the exec with -ENOEXEC and the search continues to the real format in
the same round.

Establish the complete lifecycle up front so a stashed loader can
neither leak nor be silently ignored.

- Chain restart: if another format wins the round by staging
  bprm->interpreter (binfmt_script) the stashed loader belonged to
  the file being replaced. Drop it at the top of the swap block in
  exec_binprm().

- Unclaimed or error: free_bprm() releases a still-stashed loader
  next to the other bprm file references.

- Silent non-substitution: a final format that reaches
  begin_new_exec() with a pending loader would run the binary while
  ignoring the override. Refuse with -ENOEXEC before the point of no
  return. Formats that do not know about the override (binfmt_flat,
  binfmt_elf_fdpic, out-of-tree) need no changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c               | 9 +++++++++
 include/linux/binfmts.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 45d416994682..797d9a0cf6c6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1123,6 +1123,10 @@ int begin_new_exec(struct linux_binprm * bprm)
 	struct task_struct *me = current;
 	int retval;
 
+	/* A pending PT_INTERP substitution this format cannot consume. */
+	if (bprm->loader)
+		return -ENOEXEC;
+
 	/* A declined execfd request has no executable for a later format. */
 	if (!bprm->executable) {
 		bprm->have_execfd = 0;
@@ -1435,6 +1439,8 @@ static void free_bprm(struct linux_binprm *bprm)
 	if (bprm->old_mm)
 		exec_mm_put_old(bprm->old_mm);
 	do_close_execat(bprm->file);
+	/* An unconsumed PT_INTERP substitute from a binfmt_misc loader entry. */
+	do_close_execat(bprm->loader);
 	if (bprm->executable) {
 		/* A transparent dispatch still holds the write denial. */
 		if (bprm->executable_denied)
@@ -1757,6 +1763,9 @@ static int exec_binprm(struct linux_binprm *bprm)
 		if (!bprm->interpreter)
 			break;
 
+		/* A stashed PT_INTERP substitute belonged to the replaced file. */
+		do_close_execat(no_free_ptr(bprm->loader));
+
 		exec = bprm->file;
 		bprm->file = bprm->interpreter;
 		bprm->interpreter = NULL;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index ba5037b69866..aa6dac777173 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -64,6 +64,7 @@ struct linux_binprm {
 		executable_denied:1;
 	struct file *executable; /* Executable to pass to the interpreter */
 	struct file *interpreter;
+	struct file *loader;
 	struct file *file;
 	struct cred *cred;	/* new credentials */
 	int unsafe;		/* how unsafe this exec is (mask of LSM_UNSAFE_*) */

-- 
2.53.0


