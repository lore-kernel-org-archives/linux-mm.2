Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0886072C58
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3018NSM
Received: by kanga.kvack.org (Postfix)
	id 52A846B0610; Mon,  2 Nov 2026 10:34:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA6C6B061D; Mon,  2 Nov 2026 10:34:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3596B0638; Mon,  2 Nov 2026 10:34:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17EA16B0610
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:34:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD487A4D19
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:34:20 +0000 (UTC)
X-FDA: 85390575480.26.F8DD579
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id F0A3C40003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:34:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3018NSM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qehvQbejNsYpKxVFyBI5cuXL4HJf/COjdUqE20q/KJk=;
	b=UHEh7PoJsbk2Lxtkdnq+T2+qzb39im9xRSgBgGkt5p2AMWt/w8011Ze3vf0B6n6v63LCUC
	1pBEmzstyfLWPRok864A3rftuSqXKT7sz05wwGjjw18CihHjmVwBQWO3sJXiddEqeHkqhY
	lJOHINcGnETxJuYLFXvuUzjc9LTdyWo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3018NSM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633658;
	b=ymKpVLBfg22akc3iwoKsGlAuxckKG7CjVFH/3+uz1Q02lCAr1SPlVpRI6+0SHGkg1qk7Py
	mSpaC0FGBihNVxxBzpKocbLoLUNX+EHRxgvm9MF0MJw4f/s7E8v8MyG82JyYMnTXdrDylr
	af8/3ZCY/EFuPZWfGWhyJwEGexr6gtI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85AB76060E;
	Mon,  2 Nov 2026 15:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145791F00A18;
	Mon,  2 Nov 2026 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633658;
	bh=qehvQbejNsYpKxVFyBI5cuXL4HJf/COjdUqE20q/KJk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I3018NSMJ3JeeEZNHYpZOzTSTVjGE8V8mC3rxWyFrnFm/O6e0BQPqvYOSnqdWvMzS
	 FhRSnHG1Pz7M0jO3MB5OdMthxumcYZHGwgiesNL3clkwgcHDbIz9ja6O+6lu5gGJLA
	 PzRRVogMLoBdbC/vCygybRlSjZMHZHAZaGNWRN3uCoSd+5c4+7VtRVNL7l73qL+q+I
	 R83v2alIXJL0sOz6U1nmnu9cdG/yNEzCQaZx+lsQYDDUzsXFMYUp8cWRAgyEt0tsOr
	 4L2nbLK8eTjSuQksbl4N5zsJeumCILIO4kqk140gii9/aZ6MFm+VMeLb271ZSnrk1N
	 d4I4WeWG/J0hg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:23 +0100
Subject: [PATCH RFC 09/11] SUNRPC: drop the ioctl of the procfs channel
 files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-net-v1-9-982104a4f592@kernel.org>
References: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
In-Reply-To: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1522; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Ud9Y4QQyL+X4JWta5uPxcGegk5a98S++PodDMQ4oF1M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7S/nf10r1xa3IYtmm0TBAouXddfcmhZUb+it52U
 20nX9pxoKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi4WcYGXpLayZN/hhya+/z
 ysCf6/y1yhbKurD+W7OU58ipKVLTDMUYGc6eCmt4GKApJHKg5Ubmioa6i3H1f+olLqZ4VW318Nh
 xigUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: F0A3C40003
X-Rspam-User: 
X-Stat-Signature: d7gmqh4yrgzr6we8wzyyr1f9i54tow7b
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793633658-149848
X-HE-Meta: U2FsdGVkX197LvJ49DBZTUuTvDAfiXaCGKQy8p3hIFcWQRdZHAO75SwG73XzdRcG1B4md7fnkpVvSqnJpD0NU/EqKQE+FIKyGGC8bjusfd+4JMDBKKHmOb8thNmfCkEhk59kvGuNX+UzUBHKqrWg36KIzyleH41G/CmXPqWq/xCs7BHOh8jfxyosa2LrAF+w++z0YP4V4n/NOKON3uiUqsQ4NUlOcuzKVQ1qup/CdUJPHhbAxujN0LJsMD1ARg6wMyRx85aGY2IGWJcct5gpRnPC+m3BWvdLxgrNBI3o2cHsCp/XfBDUotvue07YTdZLA4vgS1hrRKYtHwZvjd6EeL4NuHkVjwEHmlTHaSpo4w21+kTOWfPsnw/2jsRjh4pKL6EE6RUTBGi6SVcIPU755Kl9n2B67EeR5p9+W9TeFQP4iM/j5Z2Y2PhBAOO7Mlu6z+7nxDXsFJZnhcO18TTl5Zp1Phi5lr4kLnltXdi1kWDDE3kUy2FYTMmkRHrgvSXh51C2uFXMbEHrp9IbeqS/pPF5TrV46FHvdzNJBZBEVXQhxumRB5Nb+bzV5inzVscfiIGPuj18Lnl9guKNsYrqQS/fmIlkF0h2bDZcY6YmOiLEn1soJqkjd1d4xZ9BkPHGNORTpxERpcQLbNNwa1n5HMAnkmauZQ6far1HCRoqw/bBCXWFG9MeqcQefiu/x/uJc2IYmGeKs0mILC2Bq1glNp592egxv/xW3pZsP4bYXK55yyQPKGaJanlUQDc3Rpytet3W9g+QSOCuSr4d+6iilbKVfnhKRAKLktiVKtPsHRSd1F8JMORhLREIQuO+5WamnKV7ZMFuwN4vVWx5dCoMv9ep26D/KpEwW1DSKAVI5SlrxOXXSunVQT6XMx9ZImIhIKbdzZy9EohuC0QjQeHk/uq/1K0L6w+EHoATdDNMKxTOzh7icYJ1wRk0qLh8lLYlfE1hVaeeMJ9y0IjSPan
 UuL7Lxa2
 MaKDbZ9fkosWUbBU7Pe7XSJAuVEc57q/twqrx2iAUkg8SofjhxqtXauwHHhUOe2nGs4mRLt0sNPfBxAXq3Wt1gqz4EtCVwFmsmSsbOLMRAa4Ao7zMSoRo5+V9+uoDt9rp72cvpsA4nFMqrKjubEAzVzGp12gjcL5/qTNrvTUiGe1/MoWyk3m1pCbqrfrlqe0Ut+e9Cm7Xwm/APbHjnqXFnFI/eRkdaHG28HNuXQPVYZHCMd7lfRq3FPD6ikvXLUUi5lW+5h1iWHelP1gt52pJCQvXC2FBLY0MhISo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_vfs_ioctl() answers FIONREAD for regular files with i_size - f_pos
before it gets to the file's ->unlocked_ioctl(). The channel files are
regular files, so cache_ioctl_procfs() has never seen FIONREAD and only
ever failed other commands with -EINVAL. Drop it. Other commands fail
with -ENOTTY now.

The rpc_pipefs channel files are regular files as well.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/sunrpc/cache.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 81a3f0068f36..d242b6f33cbc 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1596,15 +1596,6 @@ static __poll_t cache_poll_procfs(struct file *filp, poll_table *wait)
 	return cache_poll(filp, wait, cd);
 }
 
-static long cache_ioctl_procfs(struct file *filp,
-			       unsigned int cmd, unsigned long arg)
-{
-	struct inode *inode = file_inode(filp);
-	struct cache_detail *cd = pde_data(inode);
-
-	return cache_ioctl(inode, filp, cmd, arg, cd);
-}
-
 static int cache_open_procfs(struct inode *inode, struct file *filp)
 {
 	struct cache_detail *cd = pde_data(inode);
@@ -1624,7 +1615,6 @@ static const struct proc_ops cache_channel_proc_ops = {
 	.proc_write_buf	= cache_write_procfs,
 	.proc_write_size = CACHE_DOWNCALL_MAX,
 	.proc_poll	= cache_poll_procfs,
-	.proc_ioctl	= cache_ioctl_procfs, /* for FIONREAD */
 	.proc_open	= cache_open_procfs,
 	.proc_release	= cache_release_procfs,
 };

-- 
2.53.0


