Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 808F6C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68FF06B00B1; Tue, 15 Sep 2026 07:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640796B00B2; Tue, 15 Sep 2026 07:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5334B6B00B3; Tue, 15 Sep 2026 07:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 285006B00B1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:33:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 963F51203CF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:56 +0000 (UTC)
X-FDA: 85215787272.16.43F0D85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E0FDB120004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlpWXuFj;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472034;
	b=C/BOvSLtmbDEnq4bhDXkVAdZdrNNGagUBPDxM9/WWT/d7dxExvGzPJOLxnlQKcDyK2NaEi
	/FVJ2VWhU0kdHPhWHopbnL3ORNGiNvxrsbrJrqYRQFneGS4dXDr2QwVJ0ic2TL1KngIJsg
	nfdGeVX/c6mytvW/DcUP45KnTQU1SsU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlpWXuFj;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbTaUTx0F+8Yd8wvmtUsGd49oHWKxWwv7CwFTyLjhec=;
	b=5nRwGZkDEJty7W3TBSlKpValG1feJ6mhda6PVB1+Dv/QWrKkEjgJ4kzO2jSNWdVFZmQodA
	tXfLaLF9owQOpQEMhXSXJjXWkzkMVzGYrGhP7otAiTOBny4IEuFkbQzA92xoIW4RdjH663
	rMBQiWmQAxJwht3LgK7Z2MxFwRCLNUY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 579D2600D1;
	Tue, 15 Sep 2026 11:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01081F000FF;
	Tue, 15 Sep 2026 11:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472034;
	bh=mbTaUTx0F+8Yd8wvmtUsGd49oHWKxWwv7CwFTyLjhec=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KlpWXuFj0+jdehVdQRW9dTm9BsasJoCQHq4y714jucc2LKezn+Raj3o0ioX232wqM
	 jhHvMuhWUpiDNoQEY8ZOItiHHjXIh3EJ4lYCmA5rI9RGISwFKPW38moaoO3+dsZ0aK
	 HShijMbdV4vAKfbEdZN7JwWHJCH9KbWrPxcDpTVAS0WUv3FhYQrUmcvC9ARRSnSa7u
	 Ca768uVHlWEAIo6sTG8e8Q1xpvU8CLuiq6NSrBvgzzER0wYqMt62L865asuebsmyIW
	 I7PEM9/+fxn9Mvp/KBLnfVW338UGGCg59dyrovq5duqMA/k5+J43h20hfjg0v7DEBj
	 Nim9gww77JPsw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:06 +0200
Subject: [PATCH RFC POC 20/50] file: warn when the descriptor table is
 unshared with slots
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-20-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1273; i=brauner@kernel.org;
 h=from:subject:message-id; bh=G9FG2jHFipdUrRTGsnorEbb5m5RZUr4ZNfIJ8EYrZNY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Klt0PSve+Zwt2WPgtbjy2r2c+q+Ga6c6JRtXJz8V
 7d7s9uBjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkk9TEybK8Ujbgr9+l9SPar
 Xzk+r7k8K/PX8z83lr3l0RmsOXPvPIb/xe7Pwk1X1l5rbbs/0/NrxfS1XTYnq53m69hY7lW8vLu
 CBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E0FDB120004
X-Rspam-User: 
X-Stat-Signature: ha9rnni1snbxbk48h7bob8qas3esj33r
X-HE-Tag: 1789472034-849218
X-HE-Meta: U2FsdGVkX18x0uK8wgAaZcN5MIHkkhV4VPP+JSEm6hoH1hu1zHdkNjPBN4Tjv5M031zhMgW5drYtZqm1QeHayDfF+JJBQeitjuTgF7QD0IG3hoNn2VPlyuqpsquKfCrnMCjlZ/LZeV+WEygPlZKatpuXB6Ghg9wSOJTBmCTGWlE1GrNjHtUycBdR2M3q7hpQBeZsj8OJs4SbPxtqJ/du2Cnq5GYzRAl6nrS3eszCEVDhvdOM+qi+r3UN+PMlRg50z788QzQG68kyHzwL5aEr2FJITFB5XTJDJPEqzwP/3DCgY1UEpTadVtbFWPIJAFmInihK2FQDz7/PKGjj4TUkllA9cXHzedDbGf7NNK2jOdjk1lKHDPROgyzzvUqFurPXTDTILM67y6S6uxKhWBQc769q4F0bhnZr9X7dzRUj0MWGJOn2p85sS5kRpgn4nfWgk5e5Sy2Zy6aF4ntrHHzou6a4aNRAE7AouZ/fI4zvLSIr/Z6Zxdnt0BQN7cEtRMWWInD33zFWMVVIz8rsp2ZUxJEOsIQvy6S3q2ulPc8EI8JwpLwNK2cLH3+ITtax3/IoC7gv7qGVyzB9vsKSF5v67Fn0BMjdaTRbTeQon3gOZh1iqffsOYP4tUjd1MkckqaKDI9Rd09T3jbb/wuatcbfwCSrfgUSVjrp13ieajMTjFeC0FHC1a/kI0jJyqMGovaIHB4dSeJ7u1q8FOpTMm0ujRC7Fu/gfHgvdPil2WLSbrKpDs3G/iozc0N4qNFkUKlq317HIDpKnKn8YEsLubOSJo7orN3CqMZTBZFYJ/pCQiMkGLmnXdtzndbgvj0foErKefvG4Uoj5yrKnm/supo8BDhFpr8TOV0GhSdXWug23BtmwqH6rJvc0ngpC2SskDK7/VqUIRhXiesyZiUQ+24vbVNLwXLkSvPSYFkORlin5NY/qZUm5kvwgYVWM+CQ9ONo/afxau6mCywlqfMBEjF
 plIYBJ3h
 oNuhjThqAzSz/JM4RoQZ57mKCtKnLjljvGDd5M2XfFRGobWTltVauaqB1nvVT0acnzdNwUeh5nFZtDLEOSW0aYjhzTkM5tiyzCyhagmi4Wj7/L1V4LMVn+QwhM3c5K4dtq1AnFsOYvNxnoNECkqRY8ezvwqevZyyBz1yC+lwg+Te9LpUfxsLe2mUoAiEVYLJ5GoVKGF6aloYGeoWEtAQ+xN4xLv3SlXyXLcp4snH0oBmQW7o1+5DEx2uZxsMC23Z9otuE0lm3eJO9srg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the fdtable is unshared or the task exits we can't install
reservations. The reserved fd isn't reserved anymore. execve() would
leak the reservation into the child.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c     | 3 +++
 kernel/fork.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 745f6eb5279e..1aa0f7b99fc3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1159,6 +1159,9 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 */
 	io_uring_task_cancel();
 
+	/* A prepared descriptor would be installed into the new program. */
+	VFS_WARN_ON_ONCE(me->fd_slots.nr);
+
 	/* Ensure the files table is not shared. */
 	retval = unshare_files();
 	if (retval)
diff --git a/kernel/fork.c b/kernel/fork.c
index 59c5cfa3e482..bd0e1e85abb0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3217,6 +3217,8 @@ static int unshare_fd(unsigned long unshare_flags, struct files_struct **new_fdp
 
 	if ((unshare_flags & CLONE_FILES) &&
 	    (fd && atomic_read(&fd->count) > 1)) {
+		/* Prepared descriptors live in the table we are about to leave. */
+		VFS_WARN_ON_ONCE(current->fd_slots.nr);
 		fd = dup_fd(fd, NULL);
 		if (IS_ERR(fd))
 			return PTR_ERR(fd);

-- 
2.53.0


