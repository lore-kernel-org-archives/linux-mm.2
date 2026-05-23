Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D40FCD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9762E6B0092; Sat, 23 May 2026 13:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9270D6B0095; Sat, 23 May 2026 13:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C6A6B0096; Sat, 23 May 2026 13:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 706D36B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:54:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 007EE140B73
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:54:42 +0000 (UTC)
X-FDA: 84799434846.10.3AF9D90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3DA84120009
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:54:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j3/zQq+P";
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GvzInyki8MnmX5WWa5of2Y0DpS84K4dK1p7AUcMNwXw=;
	b=u5frozw4YbHmVCejbmKE1zLE7L09RzVsKy2lC31LRtbRZs+eObvfc3qUFhxr0ym/POU2Gh
	sgtFh52lw6U/I19VnKjP/tZ2x5QGtUrBdtnmUWSaUo20ar+tZ836XsnvNQs/RrFglPYDJZ
	7W5rtPFM4/L7XRU42gDCQNApZDAq1II=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558881; a=rsa-sha256;
	cv=none;
	b=tTxF6by732VLAI1H/TJnoxMdX0IWOHxv3xXX2nYjSul8VWJ39lOXfJKCoVafTCOiCmQCtZ
	FuDYn/oVwJgghVcvCuIUuYqs3kTDWDPNvIdrng84qvqiN2ImTw62d6yZejUuFTgrflDoLv
	69026ggBLZwvEqRN9UivXOhJw0mtISk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j3/zQq+P";
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EE4A41B34;
	Sat, 23 May 2026 17:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF19F1F000E9;
	Sat, 23 May 2026 17:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558879;
	bh=GvzInyki8MnmX5WWa5of2Y0DpS84K4dK1p7AUcMNwXw=;
	h=From:Subject:Date:To:Cc;
	b=j3/zQq+PxlG0iZSuFKwgwWYoAsK0CHz5cRp6E32xLvTDfBsCGugqN+ZUucB2u3maM
	 N/47G+WnhhEqHtkDEU8M1wLF1+2yXGj4atHqd+Kz8vYI5MMcd1e2SjcjGgTs3C/PPr
	 LNEBfAG6q9WPM8n0ozT5EO+bUdc2Yuja3cB80mDrmrZVSPTkbZZ5Ihx9d90deaNR7S
	 mZ0UqQsRFOZ9T/rtGsYIPziVm9ozSwmVad9D3l0e8qctz4vx7CktQ0xz7qRHVIXmxD
	 XmQnFQch2girJp1oe+UvE8X7jDGD54eiVSox604H8ebdWW+Ut3Qct0j+NhUgEhKIIG
	 QxKtUrZZ+JFJA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 00/17] fs: replace __get_free_pages() call with kmalloc()
Date: Sat, 23 May 2026 20:54:12 +0300
Message-Id: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMTpEWoC/yWMQQ7CIBBFr9LM2omUAiZexbhgcLDjAg1TjUnTu
 xd0+X7e+ysoV2GF87BC5Y+oPEuD8TBAmmO5M8qtMVhjg/HWIjnMip59Opk8jSE4aO6rcpbv7+d
 y/bO+6cFp6XE3KCoj1VjS3CdyRymywLbt2e6JaoMAAAA=
X-Change-ID: 20260522-b4-fs-5e5c70f31664
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DA84120009
X-Stat-Signature: xr9bhwhyinc3aehaqtksbx5fiuar1g1f
X-Rspamd-Server: rspam06
X-HE-Tag: 1779558881-603162
X-HE-Meta: U2FsdGVkX1+b8bNcr01RZiAMdaxNLdagjPobJs0kp4UZL2bkN9cagt9tRHnAuN1N6N05EuU0V+aI39LN2GFE55cHHmgEw8KpbeKwfS6+O/HCJ4D5mPpPRc8RSS9cpqdqugHqXMljyDe7kk6gxVdIuT7qvVCZF1FALfQgeIaxVbpblQcI1R27mIfzsZ9UkvTe0e+B08FVn9NdjJiAGrprhrysQZ50F7uLCnod1WUJZm37plokOsecy7rTCBRWXb80ftaSvRPiSmtuXfO9XDsksS0nUzgciMckJhRbEOa7v5Y6Gv94A4OZ8/cLdOJw/WYUUU8ZtZX/JZ+P0FHzWp4ITJjLX1o9y4jMRSSvet+LS8mJdNPq0fcRn5X3Y564Iq5hv06OzFimEpE4XF/GSujNsFH/Ddz5gnFc94SnUUHn3uiWkgGgrHMd7WmKpHdDyUh3f1CaqGYF0YBFIwIxiXXVaB650Dp7zaV1R0Bz/pCm8crhX3iCMVaUojtqLRBNWl+uvyAsw+2w946mH52zGm3JhWoBy0o5eGk+0S0uL0BVR8R2UBrjm4/uuRXFIHKgITQX5E8zaEC4zgzE9Lhmwnj3RgTbigceEuZtLMqzfrmDNo4EI9CU8QtMn9Pmrec/B/sxwjqvmkXn9NuqWhkUh0UlQliLQHxmiSBSk+YeQBa7VRQsgXUzilFcPbFt60pmUnOfFiHcoOqSksj1+jGWcDkx+hC2aF1D6Q+5VF8BufTgsUpQglKHSL+ys6l9SSvcfUtlqG9M/7Ws1OJ32MINCxZ0dcKqV0PY8uv+xn0guhvFXe1dkS5BxxieHNvRqA9sh51pUWvPxV3x1p2E1xQtJYOTsN3vCOoeBPwAZVfrSiFTeeILgLRrqLkJK+AMPKpPIUh7Zq17xd9l6aqj8ao2keeLxLa4cSoSzoZTpfUeWi8BdUgi9n2S8o158wN+Fjvvn8ruregoCknOG99KfNc33gb
 ip6egm1f
 oITteUGuSl5jIhinV9nmkJuv31nfnvJ5VyjpYKgphyDBTawJLnmq9lpjrl7Y/YpGq7SvlV9FgN5LpzvDp6BDcMBI4ngGla7RWNGallf5CsHiS4WB053iudTiuGs3CIq4kqXB7dnlL/nZry3VsuvVcTMiSCkKRPNvIReyG4MCj6SGpMQgUYsCM24HA1pI89dAtdB07vjex1xCXFvbDruRGjDJHkSo71erym+hO+qJiNzSu+bWTNbyofMFsfHXeQFOlWF0bri2LqNP121TxhK9SVUCPsm2zD3TNB9kLBA8GBZeB6h3y8YxjmQ3VoHy4ekDQ9ZHcG9rKCEb2Bw47/1IoYECf3wxAd5RjgfDWDgsuGw3KoVZqtsS2c4uoTL6cvtSRsb2A3e1j3peXscQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/fs

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
Mike Rapoport (Microsoft) (17):
      quota: allocate dquot_hash with kmalloc()
      proc: replace __get_free_page() with kmalloc()
      ocfs2/dlm: replace __get_free_page() with kmalloc()
      nilfs2: replace get_zeroed_page() with kzalloc()
      NFS: replace __get_free_page() with kmalloc() in nfs_show_devname()
      NFS: remove unused page and page2 in nfs4_replace_transport()
      NFSD: replace __get_free_page() with kmalloc() in nfsd_buffered_readdir()
      libfs: simple_transaction_get(): replace get_zeroed_page() with kzalloc()
      jfs: replace __get_free_page() with kmalloc()
      jbd2: replace __get_free_pages() with kmalloc()
      isofs: replace __get_free_page() with kmalloc()
      fuse: replace __get_free_page() with kmalloc()
      fs/select: replace __get_free_page() with kmalloc()
      fs/namespace: use __getname() to allocate mntpath buffer
      configfs: replace __get_free_pages() with kzalloc()
      binfmt_misc: replace __get_free_page() with kmalloc()
      bfs: replace get_zeroed_page() with kzalloc()

 fs/bfs/inode.c             |  4 ++--
 fs/binfmt_misc.c           |  4 ++--
 fs/configfs/file.c         |  7 +++----
 fs/fuse/ioctl.c            |  5 +++--
 fs/isofs/dir.c             |  5 +++--
 fs/jbd2/journal.c          |  7 ++-----
 fs/jfs/jfs_dtree.c         | 16 ++++++++--------
 fs/libfs.c                 |  6 +++---
 fs/namespace.c             |  4 ++--
 fs/nfs/nfs4namespace.c     | 15 +--------------
 fs/nfs/super.c             |  4 ++--
 fs/nfsd/vfs.c              |  4 ++--
 fs/nilfs2/ioctl.c          |  4 ++--
 fs/ocfs2/dlm/dlmdebug.c    | 24 +++++++++---------------
 fs/ocfs2/dlm/dlmdomain.c   |  8 +++++---
 fs/ocfs2/dlm/dlmmaster.c   |  5 ++---
 fs/ocfs2/dlm/dlmrecovery.c |  4 ++--
 fs/proc/base.c             | 16 ++++++++--------
 fs/quota/dquot.c           | 11 +++++------
 fs/select.c                |  4 ++--
 20 files changed, 68 insertions(+), 89 deletions(-)
---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260522-b4-fs-5e5c70f31664

Best regards,
--  
Sincerely yours,
Mike.


