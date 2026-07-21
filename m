Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A2BC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473376B00B8; Tue, 21 Jul 2026 10:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449CA6B00BA; Tue, 21 Jul 2026 10:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387056B00BB; Tue, 21 Jul 2026 10:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0503F6B00B8
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:15:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E625120199
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:22 +0000 (UTC)
X-FDA: 85012981284.28.6712F0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B9513A000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDi+9dqu;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxB9rXhek0NkBHgvSB/buO2qLSUwhPGzB/G5yFfhHG0=;
	b=yQmbgMoeRhRBU3Tgn3XBAqIWPj1mkBa7ncPEjWHM38IV2PntShSis/4U8/9nCpiaKNbu3g
	Crslqp5DUDXdM8tr+718Q2obkjAj7pyGr5e7dvrSGf90oV9C22CRhG30hizbXlIrrKoRrB
	+eP71gIyMbuQrcAQVHUoxN/S/7q3ElU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDi+9dqu;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643320;
	b=bE+DoNm4FipKccYP3EI7vYHZQYSIyoPaTOJoBIuZvmhZqk3UShaf8oZ/oqBjEoDOntxM4j
	189rHIyccsYpWMO2YQ4myGnJ3ismKgqR9pAk7/pwFbggnvwmXoyJfBrs9CHyy4uzRbUJyy
	CZzFMViE9K2Iob3+hTuXfjmtT+KDmJM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55453600FC;
	Tue, 21 Jul 2026 14:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4711F00A3A;
	Tue, 21 Jul 2026 14:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643320;
	bh=JxB9rXhek0NkBHgvSB/buO2qLSUwhPGzB/G5yFfhHG0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TDi+9dqugaFjWW+9mGHTkPO3it+doi5MAoIF7jZY87v1HRyotf13AKPk2SfNgAx0B
	 WuwSF+B7fgaVxo9Y8ai1WVqh8LwNEJYimn9QX+cJfMdUT8QpsgHkzPoc7YtwtO2g+M
	 zMfdaO4l0QW96uu10/ZOTbQK+wn3R+QygQRoNVoy7XrRFD4O3bo/7GtjPFdh7nNy/n
	 P3JFfIAdtuFE0Ysw7gWeJ3F51trRAwiDzfKYnwD4C2kXpxx2+nJELZbgJgAw0DW8y6
	 HKAX0d50tYArLKq1zuMWnnicAeN+MKnmjyUPtA/Blhp24s9erB5Q+yMfhhTsROstnd
	 Oc7WpQACaCJeA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:59 +0200
Subject: [PATCH v2 17/21] binfmt_elf_fdpic: consume a stashed PT_INTERP
 substitute
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-17-e57866e4ae0f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2232; i=brauner@kernel.org;
 h=from:subject:message-id; bh=F6D0PvuTQvQf8mA65sb9YaWA3Wr+Jlju8fB0fC0h/A0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1x0Im77iRNvLuf17Nnf/P6aqf7zw51mBoIVnxFvmF
 37wD7kt1FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR6ukM/70FTgatPBgWtm56
 5zHb3hLDl02Sa22VGMNN3AqPKTgw+zAyNETszFnt+Or40zPhPnuq1Q447frG7+xb06nj/ifo66P
 nbAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B9513A000C
X-Stat-Signature: ue37yc5jj6kdgba87urojkn6xwnxhbe5
X-HE-Tag: 1784643320-187679
X-HE-Meta: U2FsdGVkX18xmYiN7Puk3JFLm7v+ZI42lugsCiEag+fo/D5I61iiMoPVJAxZ3g+UynaAZ190GgPNYWjtIpYhPcmZHRTLAQPGSBN569UyujlbS0lDcmFiOHuGRJb63aMzD1/wfxzprSC7oBmtQPk1o9+v1bFoV/HwBPx1/oIG/gphh7sU6lKnGHSp4imlKdEymtIlPunZ4sHgtnsHnckHhXNlCNM+wE3O+WtYugoO1+zF9yu/1XrvbB1oDwj849MCYmYCqEJNrxovLImJGkIxcqrpsoYLNH4k7aLwrC5HqDQhxNYoEoFvb/Zx9DTSrh0Kt2wrlIZHleGPAEzjAdxy532AQ0ctuEb/wB5ZZ7Jg+5PK6FDwcudQIOTIRsT/gN0S0flsrPJOzhJzgb+++VxfI6CyagowNnHtW49W+QfsMU3F0EH/qydM8Z2haUbaeV5hQGfsrOJKgdzzAQGg+nYgYQHxiukMx1Jglx6YxDQK2sOKcMXbZ1ppmt3yjYj8hvgixZ62aDVbdJHgrN9Pgf7X9bq2AYwODh6lxpn3tNYkoOKaOrR9Z05u9IeUFbHbaj6dqOMQ4g21rHIgHMLuh6kISTjWGS8LqSGvr+v9rDHIJ6an8r7YPAJvfjjtwA47B+rPV5Gmmz694mKqqHFb5i11j17dmVK/vXJ7pgWBMlWr7o7spErhNS0Rla+kEwsozfgENgbzvxGjZlNou0heSyCPu8XE9TtvYfjLpi4n46niZvdWb7zSfOW3I+k3FB/LXWODtuqdCOoNrq/6YBVtZgSMPj2ZFFiQvMzdPnFRMgmFbRaw58RzNt1ZwZ/Q0QXa4u8KSFpBKc0iRPvTxOcGF77fdkSwzyJm4O/pmkOZGHVDR8NitQvyYNVtdueBeP3ciqVOMUUBNmoOhChtg2dkuHjmS3SdCxcom+0TQfhh2js5Hk3gon4TrvGi9seVCd0kuLUfLOBp3en7IUkQCLtl7JV
 KxcgzHn7
 YgiPV8sSu5WABDvaro08PNlG+0ndv6YQKkTEjM2WyIBq+WkzCBtYbBor2Anux5UieMX7oC9OWrwpTygokZjkV9Icvsgl2/+0m4siTz46D+LUV0NXjYfvx78lmKpdVwG6aLqpzUhNabeaFlVLs6kFzRhyNHuFCG19PRGMsuNXXssmUXtSmyS7gST/8HID85V6/ZP/mY1EbYFm/DSxo0tUV68WCN1bh3mE3qAc9HKV7tOXUFXB4T0JkIQko7lsRFc8foVghNqWiqEGPgJx7WzrQN3jx236GGsokrisIhZBDkpM2d3uVTcwYRUxWokRSs7xMZkNOLzC2fj7ry31pLFvrf7EhFzaBUVYsIN9H+edfXhsg+xPT8gz0SsIIlSrixXwjTxL4e2RucBiaBPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do what binfmt_elf does. When a binfmt_misc loader entry stashed
bprm->loader use it in place of the path named in PT_INTERP, and drop the
override when the binary names no interpreter at all.

Without this 'L' is unusable on nommu, where fdpic is the only ELF
loader. On ARM with an MMU both loaders are registered but split the ELF
space between them along elf_check_fdpic(), so an fdpic binary is never
picked up by binfmt_elf either.

Declining is what fdpic did so far, but it declined late. The pending
override was only caught in begin_new_exec(), by which point the segment
scan had opened the interpreter the binary itself names and overwritten
bprm->buf with its header, leaving the next format in the round to
inspect a buffer that no longer describes the file it is offered. The
scan consumes the override now, so of the in-tree formats only
binfmt_flat still relies on the refusal, and it reads bprm->buf without
writing it.

Transparent dispatch needs nothing on top of the AT_FLAGS translation
both loaders already share. The binary travels in AT_EXECFD, which
create_elf_fdpic_tables() emits, and the exe and comm labelling is done
in exec.c for every format.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_elf_fdpic.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 0a3cdf280307..068c46875c74 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -263,7 +263,8 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 			kdebug("Using ELF interpreter %s", interpreter_name);
 
 			/* replace the program with the interpreter */
-			interpreter = open_exec(interpreter_name);
+			interpreter = bprm_open_interpreter(bprm,
+							    interpreter_name);
 			retval = PTR_ERR(interpreter);
 			if (IS_ERR(interpreter)) {
 				interpreter = NULL;
@@ -299,6 +300,9 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 
 	}
 
+	/* No PT_INTERP to substitute for: the override does not apply. */
+	bprm_drop_loader(bprm);
+
 	if (is_constdisp(&exec_params.hdr))
 		exec_params.flags |= ELF_FDPIC_FLAG_CONSTDISP;
 

-- 
2.53.0


