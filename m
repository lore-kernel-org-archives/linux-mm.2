Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9806CC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7346B00BF; Mon, 20 Jul 2026 05:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E9D6B00C1; Mon, 20 Jul 2026 05:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794866B00C2; Mon, 20 Jul 2026 05:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4AC566B00BF
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD0F240762
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:04 +0000 (UTC)
X-FDA: 85008643608.19.49380BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id F2AB6C000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CXwp4/sg";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540043;
	b=cMIUZTgcILgRyJF81QvS9pTCPmyaFwn97eNnnuGmAr6R8KPTI23MV40nB1xr280yxEXco2
	e56/zMYpqOzRmqf9WYAArRUYiWrvyRS8jI5cNZqGLVPqkDQ8xz0PEEELrvhWwLjYaNY41U
	464ARAUhUGtXv3A9sSPFMUXKGWm6rmY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CXwp4/sg";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WU8HHfi0XRjF1MtN9eV9/bX8KhXCEqYvsKnAtQltP0=;
	b=veXK7tgjYOIcydnRwXlvTxz3rjBoo2Wx4hfqUh/6XW+jQnLYVCbao6XYQLEALmSmphvpZV
	RmILtXOgCA/GB3LJgLaPSf10/kMpKmFLZirISIOZGdfZyNLgAMdbD0mtnHU5sqF1oxpquk
	nLlfqMX6yX9Xro6Njg30Beom4wsPPvM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48B3041387;
	Mon, 20 Jul 2026 09:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065CB1F00A3A;
	Mon, 20 Jul 2026 09:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540042;
	bh=5WU8HHfi0XRjF1MtN9eV9/bX8KhXCEqYvsKnAtQltP0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CXwp4/sgl9RgFVehfnAi8KQkdRTrXCDJ6bzcipcJgybnMg5i6pa/kjodZV0GoDRhM
	 35yVkpXr2iBxRdMuxZBo1J69wbvBHVvHWShvf+wnq0GbjXb48+hYaMHtQZtMK1oYy3
	 4pAN93UKhWpbLunj65CwXuM545UgXzE6fQ1pGk8YmKEiivctVs4QEle7huVLxC7MlH
	 DDuttxZh55gT0AraSxsAqmhC8iZPvqIpUwWG7ubY+JKK9tTU38dAojHWu5WSHwNinD
	 GN2P0+Pk7Zg4oM/mDIWMO45nTD8OsNMZLnsLCBrntnPKNajTmUno8F29/YGmrKLEfM
	 ThmaLEUyAf8EQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:24 +0200
Subject: [PATCH 01/21] exec: do not act on a stale execfd request without
 an executable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-1-ddb76c9a508e@kernel.org>
References: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
In-Reply-To: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2160; i=brauner@kernel.org;
 h=from:subject:message-id; bh=CoHLaRoM2mplRsL5iN7kCgByR53yCKHvwoveSm2vgWs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm6c1/Cq9wWzWdFRUwNPL4+fz5cL3Cuzju644L+qL
 OzM5SsTO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbS+Izhv/fHhpSZpdIbTknN
 nbPHff27N0WMi1V/8HuXvF4hW/Cwz4bhF7NT1GvRIzZLzSsTleK3TRGdm5QRv/aLVdgB5ZakDlU
 NBgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2AB6C000D
X-Stat-Signature: fxsjwwtnhjghiqf6yyraygkuhx8kwq5o
X-HE-Tag: 1784540042-771567
X-HE-Meta: U2FsdGVkX19DdSGSQeF+js2zSbajwfvuRFhUcAtlBJ+T1s5DDKBwaCxcZLZFgTxBnuARb7yIKhVmIF5V+SvU3AUstTe6/yf/e38c1BjJBfZnabR1dfwE8d0GN4wyOB/khlMhVTsX0SANFBigdqoz0NyW8MK7txnrIADvCYjeqnGaWkfh6m4Te6G3TDWO454q7U0U13HZ8ySibFo4AQ3eSVhbObjcFsY4Eo7C+g97Lqqupwarvz2fFeaxsUYZdQEY5XmYzUpxGCfOjUppS4tbJwHYsS2xcrwN8EW6MS2RFyLhXxyBUb2Kf58AOD7jYENQHaAa0BfRtOanHuwcm0C9gS/bazSUPVWNJtmLVTqEFhKuqwRbtGQkX0jtB9ogFrnhxT70amElIK1fmIuUkxoqKcdjuGqR/47V2NYeWr6xThj4J6wLRsWHyu4wlp2i8LLc10PwvvwE/Qz4yc5pWqpFraBTsctGS+CpuyFI7TNp/TwiHEIq7tghvKA2DlSD5tVoxpY/pkdD4pj0y+YvIJdtEc8Kn/4KO5v0BV22gGLfzlDbgnQc7EaQ5Ue7kINabqUMICsBZD6SmpQIIaDUVEtg46aBde6D8rgQg9VzA5DyikxgC/IrXdPKpKYudkhVNsDy6kANCvickd5s/4Ucn7KBe7JFuIngebT2tpgsBw2ZUu5iOKlosA7ycSHa0vSOIVwnkGG8M17nm/KmtAU9Cw239XK7WXIrwjD/HH1kPBq977nbs5Y6izgNiZZTT3hDnnGNZnVKraF+HlQqi68DImXY1qmOLuV3RQj9caKu7aKLpnb1wnddyQVhii2nGPQk9/yAQAUquoneAJgLVLpSppD6aTByQ7JbriO7V0ySjxk2n1ND1FZiRnNO2yryXzhdybEiDD9WVfh8HQHfNwJqGlsQUuQ8x63R3iV8F+Ppb39Dhu9uSJdC6nDeUZ8a/11xC84rsX90u0TRoIK5OBs6+QP
 v4/vLdea
 h8vUf7oVfYxqSPs2mVAeaEELmrwiqCOl6WTeXHgSfb7+xviRibyNv77UKzpmUzXhRO/gfa6gSQL7pGxPHItwVo28hIiumNMh96pgfxzaYi0syp/lfYmgU0jmorZ88Hl5yAIoU6awJ6ioLhOpbVnEFQ/m5coe58lwOrU4uvgMt9wrnbGGKtRlQhZFnj9cq5WuC/I/id6Dh3R1VbBl99YoFK1eJQbylbt+3DGl1b0C8/PW4haW0w3griln6UaZGp52cKy7DJTJp24xgqwwI+BabZ+IRvPFqPzm6xg25dIlbg19bn/irueWmJrahmjS8BrKj60C3pGmTz60RLTe8m0HOuM1TVJUKhun0k9GF+65bVIMSm3R39iYSXpktAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

binfmt_misc sets bprm->have_execfd (and, for a 'C' entry, execfd_creds)
before it opens the interpreter. When that open fails the entry returns
-ENOEXEC, but the two flags stay set on the bprm. As binfmt_misc is
inserted at the head of the format list, the search then continues to a
later format which never staged an interpreter, so bprm->executable is
NULL while the flags falsely claim an execfd is present.

begin_new_exec() then dereferences the missing executable:

  - bprm_creds_from_file() computes credentials from
    execfd_creds ? bprm->executable : bprm->file and faults on the NULL;
  - would_dump(bprm, bprm->executable) faults the same way; and
  - create_elf_tables() would emit AT_EXECFD from the zero-initialised
    bprm->execfd, handing the program descriptor 0.

An unprivileged user can reach this. Mount binfmt_misc in a user
namespace, register an 'O' or 'C' entry whose interpreter lives on a
FUSE mount, have the FUSE server fail the open with -ENOEXEC (which
fuse_dev_do_write() relays verbatim), and execute a native ELF file
matching the entry. The result is a NULL pointer dereference in
begin_new_exec().

have_execfd and execfd_creds only mean anything alongside the
bprm->executable they describe. Clear them when no executable was
staged, before the first dereference, so the exec proceeds as the plain
execution of the binary it has become.

Fixes: bc2bf338d54b ("exec: Remove recursion from search_binary_handler")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index c698aabe9abd..2f50aa039827 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1112,6 +1112,12 @@ int begin_new_exec(struct linux_binprm * bprm)
 	struct task_struct *me = current;
 	int retval;
 
+	/* A declined execfd request has no executable for a later format. */
+	if (!bprm->executable) {
+		bprm->have_execfd = 0;
+		bprm->execfd_creds = 0;
+	}
+
 	/* Once we are committed compute the creds */
 	retval = bprm_creds_from_file(bprm);
 	if (retval)

-- 
2.53.0


