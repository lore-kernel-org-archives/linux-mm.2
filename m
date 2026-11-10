Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4C41606D4F2
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OT1LM/Xd
Received: by kanga.kvack.org (Postfix)
	id C16FD6B05B1; Tue, 10 Nov 2026 16:56:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8426B05B9; Tue, 10 Nov 2026 16:56:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1016B05BA; Tue, 10 Nov 2026 16:56:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3116B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:56:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3400C140128
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:56:54 +0000 (UTC)
X-FDA: 85420569948.08.7381A0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 98F2814000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:56:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OT1LM/Xd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794347812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZDErYEQzOGJUjtDBXVtItn62hZcw22wk/hmpMTwW8s=;
	b=au/pwwC3wkhzdsL6h+F1XAE0qdtHer1KYv7Jx/wrThdAuT7pw9Sf+sElGfq0CTkZS2GUPt
	cezv+a8QBTQu31xRUoluwT6NB+aZOVg4MR60+hnlJKiCeu9KBh1sga/zoXuDc/M6nhG1AY
	QMugCI+ZVmahrC3dK3uhpEJyfzGD7PY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OT1LM/Xd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794347812;
	b=L23efi8UYCkHE9hU3wMtrtHkLmuZWY9OEh+imCrJrZOq8+bqtpbAjZHmtGEuW7Z/CoTSlp
	nOvv+IDKfpXSrsJViKph8cGhDbSmCbWogCUxsXGlKV8YTkDxa/gMmZdGVh9qBC6lA5gyXr
	mRL4NWR5b/U196stO35TYI/aEJQUs1o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC23F637F5;
	Tue, 10 Nov 2026 21:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C96A1F008A2;
	Tue, 10 Nov 2026 21:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347810;
	bh=2ZDErYEQzOGJUjtDBXVtItn62hZcw22wk/hmpMTwW8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OT1LM/XddW8RQD5eAmU8fBGOFbAM8/CnJEQs3885Wa0JF4KqnzpeNdym5//nw/qmO
	 iSIXz2DK4b5upf83EDFMcSmu0R158tcCDKFJPJc+nb5CZdciue++Ti2l4+7JB3cJcZ
	 ofKUHpSYZzgbI/fZlqfADzqczaOi6d9z3Y/zO6lUhjFut4nTY/Mo51uO4It6fBxl4w
	 kteuhsecwTnXgVw0wlXvii87uhXMhUgsuU0E2MSi8RSzt1K2+xoj6E83ckzwcRg4rF
	 Ht/S7BOo0R3XlqC9Z0pGpdIAMmq9jRNZQqamTSsu2Lll7rHCO7Qg9kxjiih6PwTNRR
	 88zmVF8rr0Lbw==
Date: Tue, 10 Nov 2026 22:56:45 +0100
From: Christian Brauner <brauner@kernel.org>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, Karl Mehltretter <kmehltretter@gmail.com>, dsterba@suse.cz, 
	tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 06/34] nilfs2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261110-deformation-knabe-geltung-3bb7600eaead@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-6-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191225@kernel.org>
 <CAKFNMombDWkJ=m+CjMy7qnd_yy-vZ9c-EE7R95HKKkcy-M0+SQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKFNMombDWkJ=m+CjMy7qnd_yy-vZ9c-EE7R95HKKkcy-M0+SQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 98F2814000C
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: mkmgadrnc8jnx9rxz4xuw1tmt3j4scr8
X-HE-Tag: 1794347812-588670
X-HE-Meta: U2FsdGVkX18c8+RChHKxT70g5GC89c4yAg1i+U3ZQ7CXtLI2w0tFmMMsiG8TgoH/8y0CnZcUZETKtmXYmT8KsyzSDneMm14ERAvgB2zkewTWjdltvjg4I53thCB0IDGyQmYTiZdQh0wc/3L7TrNPlOWkd9ccz8UnGDUAtOuaasaVwKfWU7wZYJvLPEXmox2hCruvktiHSBnFXKCogvwrBVJNdta7fKLPWP9HHbgQrl6vkCtuHTr/Hfs/7vYRTIN8GegN+SRe7D/tD0MA+/KojaUVkhLsVJggJa1vV91ScVNkRECcyAq+aBmLn993XN79ECYw/e7nY/EgI7HqZPVgp5CBbZ+WzpYOGIJcuxgctHJYWdFuQ8+e0QmXlOxLnKqO/lZF84QBTVA9PSaecObA3EJfisxVeiaOEJjp4mons8wpstQMnfKNqFRvOomf/ToEWpbjhgFYyZzZTc/tRvI3BQWQU+9o5OkfR0Ja42wQK9xD0YLZTszT6gm5NmpYMd97i46aXQlaWPkCTI2NLx5PrR0F1fCAfdSXVrlvV8C3aDI/RtC96znl2NQabK2lEYgkcsol3HjoU2nL6q/Bzl8n4NskWP8y7Dhi5JdBWRr+9Dlk+IrQP8qK+LhG9T/CSm9neXBX6lPdvWNKBSOL3Jk1TT5kqjj8RtJSCWLp4SWio9xyqdlyhjH1LgMX0x5pkljGk7rccVYQ+Ivd6J1ptHuRRf/PkrXZJ2/MhfoqNvUk++VhgRgmmQYdgXdJMJbmITEWzwh29wE6qJOIo0YiDdongyPVtry14hHa8LzA8CIy9f+93sd1aX18tjFaboOyLNUC/OYiaknsxcgNO3dlm09jcJKc9zjF4ycRXO53W9ZoF2HxJpozfrUR8OFfuHrFtZCCHIJxJmSguQOlluPqo5ZlatBEJLuwzDE/sNy/NySFpsYU61R6Of5h5fT3RwpV8DTu9p5bjo2ZyKfaU20ze3S
 d6IpI4K3
 dpbQgQR+x+yOrp35uaLS2d9rvlmO+zUX+Lo3ec7EiqAp8Ki1l5e8aXW0IxjxoXV92N/AN6+eZ0xVCRH8G/xely835du5fdcOG+t1G8yG9dQ8zV3cfbPD4dbK0OIoPZPpN2Hu3F64BCC3aPvj7Z6aDP1DS3VagQ3hrhoYWmRHuO4+KHDR8uBV29C+aDIPuGUd2OEO4VsOTLk1Bt+A8LyfauxRo62xWwjQK/q3LH3pmjzWgUgYcpyA/8x8+OYReYb1UC/zSisKQZwOrjnfga77BiZLcLhMikNzTSUFmhpvQKKB5IvLgLPgaywE0MdxyQ/10n8VpfLaBO2ft0GLWGNjWDT6JzXAttLZOmNMH/BX8X3uyPjvzpsqQMb4VaVWxGhkL+gpOazDFCvlfwtYBzZWnCUmGdC32kM8sye+AAz36GVKMU7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 02:32:10AM +0900, Ryusuke Konishi wrote:
> Sashiko's point here has a valid aspect.
>
> This inconsistency can be resolved by inserting the following handling
> logic if sb_emergency_ro(s) is true:
>
>        } else if (!ctx->cno) {
>                 if (nilfs_tree_is_busy(s->s_root)) {
>                         if (sb_emergency_ro(s)) {
>                                 if (!(fc->sb_flags & SB_RDONLY)) {
>                                         err = -EROFS;
>                                         goto failed_super;
>                                 } else {
>                                         s->s_flags |= SB_RDONLY;
>                                 }

Meh, I'd not set SB_RDONLY there. Because it changes the read-only state
outside of reconfigure_super() which is precisely what this series gets
rid of.

The superblock can be frozen at that point, e.g., when the error hit
while it was frozen, and then thaw_super() leaves s_writers locked again:

  mount /dev/sda /mnt
  fsfreeze -f /mnt
  <error>                       -> sb_set_emergency_ro()
  mount -o ro /dev/sda /mnt2    -> SB_RDONLY on the frozen superblock
  fsfreeze -u /mnt              -> s_writers stay locked

It also turns the superblock read-only underneath the existing
read-write mount without sb_prepare_remount_readonly().

The busy-tree branch does what get_tree_bdev() does for every other
block device filesystem. A second read-only mount fails with EBUSY and a
second read-write mount gets the superblock and every write fails with
EROFS. That's what ext4 does since commit d3476f3dad4a ("ext4: don't set
SB_RDONLY after filesystem errors").

If we want the second read-only mount to work I think we should do it
for get_tree_bdev() and nilfs2 alike and treat the emergency state as
read-only in the comparison without touching s_flags:

	if ((bool)(fc->sb_flags & SB_RDONLY) !=
	    (sb_rdonly(s) || sb_emergency_ro(s))) {

But I'd do that on top.

