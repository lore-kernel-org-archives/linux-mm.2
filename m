Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54622D43352
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 21:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE956B0006; Thu, 11 Dec 2025 16:11:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6DC46B0007; Thu, 11 Dec 2025 16:11:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAB0F6B0008; Thu, 11 Dec 2025 16:11:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9945B6B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 16:11:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26A32B837C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:11:49 +0000 (UTC)
X-FDA: 84208437138.02.499CD35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7AE7540004
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:11:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=A7npviBy;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765487507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LwvWXv7WmyrUZysIkOJ5BmjdT2f0eqd+48EtQKg/k0U=;
	b=SPdDNTtenC7Eo5cmT0cGBXxjlMuiVxbkhmkSSvLeqK/3Cmr64OX6O4djRpZLH2V2mJpXi8
	mVXxzwBU8qRUU67emgrSf41PHFfxCVLuh9g+Qj0rGrlNlzw7ynC8w0GEdeubcuo1WNzFbe
	cCJEdsWMsy7jS8KjayqXJlmqdRb19nI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=A7npviBy;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765487507; a=rsa-sha256;
	cv=none;
	b=TKpVLDCCKhi4M2CQTJQwnli1zN+GGh8vAKPZBw0L1N2fiTwFSRRpuTC4DkB+94W5Z3Xh6G
	VGPediU7h1DL8x2raF+uz0yyOGRTw0YHJitMNsnHuqR7rGkLKvFkddteXF3h5o6xWyJan8
	KFF3ULCaujbyytZQIxBGaaTayFFELBI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E02C42D67;
	Thu, 11 Dec 2025 21:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1076CC4CEF7;
	Thu, 11 Dec 2025 21:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765487506;
	bh=XfWChLIq0U5zTAEZDWkGgBN6OS3uU0puWnQSlLEXHEU=;
	h=Date:From:To:Cc:Subject:From;
	b=A7npviByx79r+2lwvsaoRYS71wzj04sSvrud/blEramhGNT1WNyNYqfiXjh3Vbae7
	 kwBLBrsz+1LqJMutFapSLzWLraGQSJjwTlUBrR0QNzLsXcB5upoX2RzBkjvEer/3WW
	 BsKcwyAfaNgZjlCLItXvzcoWzWnaEXUSeC5sMHN4=
Date: Thu, 11 Dec 2025 13:11:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional non-MM updates for 6.19-rc1
Message-Id: <20251211131145.512b1694cf5f46d959cfef76@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4kcjxfwoekx6swi5iyncxprokm4iwgfp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7AE7540004
X-HE-Tag: 1765487507-663136
X-HE-Meta: U2FsdGVkX19X3GN9ntLoBetGY3DMRGjf6Fkwu6kS4O4V0pvoJIs8F9GXnwbu4gfgXYC+ftcUzFhxtrXhzbTLmVO1Cpkx3mHRWzXWOekHLbjV1doU8hWzAu/H970NZ8wE9tvmckVjE1bA8AsOyqtSgq9yJw7D1qto1f3cxGfaVt97TdkXinYG449t+oveKtAHh7ZrAif0usYGR2m3ReBmoIbBdRB5o4NpWsR2+IXo1xYfKseQheLKfHQGxYhO8WIcKcxacCFWNovj/Fvaj+DzIrTMKdcMPG/sH3LjgJ7P4rahLn2GJA8PxuD0cWgaBV3gp9ISW0GJrHM/5smlpaagKYb4EZ+GaON+VyJyiuesS6GxIciZATv1bEQncy+CYsKnbzC2nIy59YfkddsoLbGFSe0fenbhk/43TF/JPc9dJ4V38UHAvA5sXpXK8bcJHHeVwOUIQpB7tVWStpZc1ATK0E7BpVywmGsMuJK3zOLuspoLjG9xv1xMV2oIEhjQlINDs1BucUUSoM5315jrVjNfa7A3ENw0sMLkpcK+435itMQHyeVNGTeEfTLPxdxenybKN2fGLPTHULMjqlQBukMkD5wct1oHnXXcHZE/sVUwiqFdgv0NPvFBxI04IgQXVJoPDoGfQWjZanVyTsAq3r4t42C2FZPAFzF3hmCm+EdxvKvPeIvza3Gz5pywAS6yefISEj+d7yiKWZ5Pf/FDqqYdd3PD6sJD2wXd2t1r6Jpc/rZ4euJ+LQPpY2DB4kAhgycqoFI9D4hRNQLUveyvGMaaHB/6i0KlH+b8+5rS2kIzNUFeqL2Hi9AHOS/XvoCHYVgpSmLa0jrKxHVG0rbEUUZOPMLFK2b23mpITS2M9Hd+EMtFvXkfHtCy7aV6SsOKVv8Lt3n8bVv3FuAlYuJro1+W5np49MISdUU4wTI+ELuzJ+TMLMSk8E8qw8JsUmYMJttTH9KLUxlselhXzLgLnK1
 vJywfcCD
 q5iqRplR2ZIForHyrSTnk1sj3hELHvFeDVsybIayOvTMCjTDBCQojaBcg+ItLi7y0SaNfeyaIuEHIyJ/BQJlzLz0ELkQRfYD6Q909U285Ggph8ECY8ddKwsn0RKECulHrqgo7YZe0N8JHE7ga+Eb+V9kKLNLktKpyqf8MRizUxsmvp04++916HkJqGlmq+1T3T4ZUJNGidh3QRhTgJqyNIi57PzFWurxhXAzcFU4lnVdHNPQ7i4PY2d0lgI8nHcVjRxcuH0tBTAkWN/zSyEQXNaB6NtdF0qbBMKeN5XLD0SJ02IU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this small batch of followup non-MM patches for the
upcoming -rc cycle,

No conflicts were seen in a test merge.

Thanks.


The following changes since commit aa514a297a0c175239f24a2e582ebd37f0727494:

  calibrate: update header inclusion (2025-11-27 14:24:45 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-12-11-11-47

for you to fetch changes up to 601cc399a01049efa76be8f496541315dc9cf914:

  mm: memfd_luo: add CONFIG_SHMEM dependency (2025-12-10 16:07:44 -0800)

----------------------------------------------------------------
There are no significant series in this small merge.  Please see the
individual changelogs for details.

----------------------------------------------------------------
Ahmet Eray Karadag (3):
      ocfs2: add ocfs2_emergency_state helper and apply to setattr
      ocfs2: convert remaining read-only checks to ocfs2_emergency_state
      ocfs2: invalidate inode if i_mode is zero after block read

Ally Heev (1):
      checkpatch: add uninitialized pointer with __free attribute check

Andy Shevchenko (1):
      args: fix documentation to reflect the correct numbers

Arnd Bergmann (2):
      mm: shmem: avoid build warning for CONFIG_SHMEM=n
      mm: memfd_luo: add CONFIG_SHMEM dependency

Dan Carpenter (1):
      liveupdate: luo_file: don't use invalid list iterator

Deepanshu Kartikey (1):
      ocfs2: validate inline xattr size and entry count in ocfs2_xattr_ibody_list

Dmitry Antipov (1):
      ocfs2: fix memory leak in ocfs2_merge_rec_left()

Edward Adam Davis (1):
      ocfs2: check tl_used after reading it from trancate log inode

Gustavo A. R. Silva (1):
      ocfs2: avoid -Wflex-array-member-not-at-end warning

Lalit Shankar Chowdhury (1):
      fs/fat: remove unnecessary wrapper fat_max_cache()

Pasha Tatashin (1):
      liveupdate: luo_core: fix redundant bound check in luo_ioctl()

Prithvi Tambewagh (1):
      ocfs2: fix kernel BUG in ocfs2_find_victim_chain

Thorsten Blum (1):
      ocfs2: replace deprecated strcpy with strscpy

 Documentation/dev-tools/checkpatch.rst | 23 ++++++++++++++++++++
 fs/fat/cache.c                         |  7 +------
 fs/ocfs2/alloc.c                       | 12 ++++++-----
 fs/ocfs2/buffer_head_io.c              |  2 +-
 fs/ocfs2/cluster/nodemanager.c         |  3 ++-
 fs/ocfs2/dir.c                         | 10 ++++-----
 fs/ocfs2/file.c                        | 14 +++++++++----
 fs/ocfs2/inode.c                       | 11 ++++++++--
 fs/ocfs2/move_extents.c                |  2 +-
 fs/ocfs2/namei.c                       |  3 ++-
 fs/ocfs2/ocfs2.h                       | 18 ++++++++++++++++
 fs/ocfs2/resize.c                      |  4 ++--
 fs/ocfs2/stackglue.c                   |  3 ++-
 fs/ocfs2/suballoc.c                    | 13 +++++++++++-
 fs/ocfs2/super.c                       |  2 +-
 fs/ocfs2/xattr.c                       | 38 ++++++++++++++++++++++++++++++----
 include/linux/args.h                   |  4 ++--
 kernel/liveupdate/Kconfig              |  1 +
 kernel/liveupdate/luo_core.c           |  4 +---
 kernel/liveupdate/luo_file.c           |  7 +++++--
 mm/shmem.c                             | 11 ++++++++--
 scripts/checkpatch.pl                  |  6 ++++++
 22 files changed, 154 insertions(+), 44 deletions(-)



