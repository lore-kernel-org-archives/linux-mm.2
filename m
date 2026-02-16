Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C7ECE7BDAC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 040376B0005; Mon, 16 Feb 2026 08:32:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2FFE6B0088; Mon, 16 Feb 2026 08:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11F16B0089; Mon, 16 Feb 2026 08:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB23D6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:32:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 664221A0DE3
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:21 +0000 (UTC)
X-FDA: 84450408882.05.6B9B0E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 774A8C0013
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnzGrS+E;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=j7Em2LDZ8N8JiQzHQJHo1lDgXGPhiorUn1dbvzzh0ic=;
	b=KPqcgEfuh98iWVQrgv1gIMQ04RrrMYDHozTyssAir//eMG78SHWzkbS+hTBgM1Ng4Z4g64
	hbKPpJADY9RkH2F6zqdnXitAzFCfba6ANid0WRP5orF+ZLLZECUgPEMgpr+Qm8PISZ55t5
	EqaEC42sFyPBF0U4MGpCEca6Z7INy7I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnzGrS+E;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248739; a=rsa-sha256;
	cv=none;
	b=EsdbVx7cygmxdHLFKFose7Etlyp6NcVMmVUNq4UsXEdotCVrkPWisSydHgMspR/4GmAXjb
	8MOS464Q+32NzY4IUpnQ22N6jqDU3nSx4Rzrl2RfOfih8s3QaFrIw/fKPUzQevOuWsTezQ
	z0/cjG5vm1XP6vEHOB0+gYoMKGWQ1j8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88FA14186E;
	Mon, 16 Feb 2026 13:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44616C116C6;
	Mon, 16 Feb 2026 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248738;
	bh=IBfriahGCrZbgG2xPZaipNIY6Lm5nqv5xPLiQPNO0VU=;
	h=From:Subject:Date:To:Cc:From;
	b=qnzGrS+EGxMXTIwtFfpkP2HXkzwc0TfKfB9GHqoclOOIDAme6AsyKLaqS9E7Jtqka
	 f6gnJXGflC/unzfnHNAHt2Vulcy4z61/ZFYwFdYdczlZvsSOBRrCEqVSmspPphRoy9
	 yF/sMzGeB6kWmJQXp7H8Vfa6w3Ei0rX3UQoNp5nEhXqWE8kqSsdG9CGlh/rf44hjpQ
	 qP8XHTBhvyl+B9EyyHTPIEJK1w1vFuPw2o+gJTKkgLGJxb2LXI925d1+SS5jjjloEx
	 h3NPtd108rWtrY+y0O1A62vdnRHBtjd1Uq8x+m72u2vhcRoOSyKbRyAclc0UGzxxQR
	 2G1SZh+oI4yYA==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 00/14] xattr: rework simple xattrs and support user.*
 xattrs on sockets
Date: Mon, 16 Feb 2026 14:31:56 +0100
Message-Id: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEwck2kC/x3MTQ6CMBBA4auYWVvTvyngVYyLdphKQwTTNkpCu
 LvV5bd4b4fCOXGB62mHzO9U0ro0qPMJaPLLg0Uam0FL7aRWSnzWPIvN15pFWWnmKqjHaEcT+t5
 20LpX5pi2//N2bw6+sAjZLzT9Tk9fKudLp8kMKLUdPSFrhco4CjF2g7GIUTp00gTp4Di+DYKIv
 aUAAAA=
X-Change-ID: 20260211-work-xattr-socket-c85f4d3b8847
To: linux-fsdevel@vger.kernel.org
Cc: Jeff Layton <jlayton@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
 linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, 
 netdev@vger.kernel.org, Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=4849; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IBfriahGCrZbgG2xPZaipNIY6Lm5nqv5xPLiQPNO0VU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlolVf2J3f36a8ze/m4FeS2S03091//pKONFFL3V/7
 o5raQlvO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTAC4SwcjQ9CDunvilFdtFXp3J
 3LXpydXa0ve8ct39mhkmOxclbDypyfDfS1fQoKkiscXO6LCGhUnA9Rs1i74dSH5eat2qI1/z/yk
 nAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 774A8C0013
X-Stat-Signature: qqt59kgcqmtfenca9a9uecuq4dn6wc8o
X-Rspam-User: 
X-HE-Tag: 1771248739-936381
X-HE-Meta: U2FsdGVkX19UjY14Jwe+WJz4ypu70+4BCP9P3Un2iD74MptUfIj4kra6CQcGY5Z+0L8zDtZ4JA/gINrEqkruqdipctmWJx2cmOIZM81BzE/y/Ni28sd8b2L9pqyYrYxDmWZLQ6O+HUfMpRvIXPjVaE/SrMw35kwEb8bvaV/MkoyIRTP8taiJ6tCN5FzsP+ptJSd4bwik65f61YLjybf/5QohZIDUhofT9emZnATDoIJczYTdyTj8WtHbj+ob5t8AllOxHgipZb6Je3x4K4Y6mYpxl97qlrTPGVGhQPnSsbUl8vGYj2X9RyfDyinFkXOOi5UvX8ezqdIZtvFrDIegFZLDc/LJWeqmY+iM7cFDELYPuVa+EktM6IlCHJBW6gPM4Pr7c7CyC959UBlKCu2z7JWFzp9RZDO2O4IQKPxSWW4zPz1DgrvHmxcC7sffKwO+rIgKS7yfjRwn/0uU4r6AVUc1PWfQQVdQs7XKFQmzW8BCi5eCwD42A9uhljGMqmL1XGmkTYPCRAgqn86Q+TNYLe3GWq2vze69eZQJ5kaZSmrAN5KXm5fy+lq9bm+Kf7KKrwvmbl+EJMOBd9dqBul7CL54rwFyCNUukTsqG3a4n/hd7ZcNHGumc5KSyAimmymUBuzRAhEG3qbLbBqsn8cQiqEcGQj9OiYfzxVMFSeYsQJVhzAtCAMyjHa1LRzR0F8vB3UByrT/QcYBvbM20d8XN+E67+zQ6+PhRs+07fwneLkgKTuY0XNjPUBC8YoG0KP3RxlnUnchOz3AZh5g1D4iVYai9VbJL3BScUD6vByy8BI1QN7J8eIGez9umwAzSgORFZW6SPv85L7gbGWWCJUACSuZXhZThCvpyf1bjvPM8Gath2claUlP7k2Ra503zEO4sNHOIalBAvzXjKMgjAT8bQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

This reworks the simple_xattr infrastructure and adds support for
user.* extended attributes on sockets.

The simple_xattr subsystem currently uses an rbtree protected by a
reader-writer spinlock. This series replaces the rbtree with an
rhashtable giving O(1) average-case lookup with RCU-based lockless
reads. This sped up concurrent access patterns on tmpfs quite a bit and
it's an overall easy enough conversion to do and gets rid or rwlock_t.

The conversion is done incrementally: a new rhashtable path is added
alongside the existing rbtree, consumers are migrated one at a time
(shmem, kernfs, pidfs), and then the rbtree code is removed. All three
consumers switch from embedded structs to pointer-based lazy allocation
so the rhashtable overhead is only paid for inodes that actually use
xattrs.

With this infrastructure in place the series adds support for user.*
xattrs on sockets. Path-based AF_UNIX sockets inherit xattr support
from the underlying filesystem (e.g. tmpfs) but sockets in sockfs -
that is everything created via socket() including abstract namespace
AF_UNIX sockets - had no xattr support at all.

The xattr_permission() checks are reworked to allow user.* xattrs on
S_IFSOCK inodes. Sockfs sockets get per-inode limits of 128 xattrs and
128KB total value size matching the limits already in use for kernfs.

The practical motivation comes from several directions. systemd and
GNOME are expanding their use of Varlink as an IPC mechanism. For D-Bus
there are tools like dbus-monitor that can observe IPC traffic across
the system but this only works because D-Bus has a central broker. For
Varlink there is no broker and there is currently no way to identify
which sockets speak Varlink. With user.* xattrs on sockets a service
can label its socket with the IPC protocol it speaks (e.g.,
user.varlink=1) and an eBPF program can then selectively capture
traffic on those sockets. Enumerating bound sockets via netlink combined
with these xattr labels gives a way to discover all Varlink IPC
entrypoints for debugging and introspection.

Similarly, systemd-journald wants to use xattrs on the /dev/log socket
for protocol negotiation to indicate whether RFC 5424 structured syslog
is supported or whether only the legacy RFC 3164 format should be used.

In containers these labels are particularly useful as high-privilege or
more complicated solutions for socket identification aren't available.

The series comes with comprehensive selftests covering path-based
AF_UNIX sockets, sockfs socket operations, per-inode limit enforcement,
and xattr operations across multiple address families (AF_INET,
AF_INET6, AF_NETLINK, AF_PACKET).

Christian

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
Christian Brauner (14):
      xattr: add rcu_head and rhash_head to struct simple_xattr
      xattr: add rhashtable-based simple_xattr infrastructure
      shmem: adapt to rhashtable-based simple_xattrs with lazy allocation
      kernfs: adapt to rhashtable-based simple_xattrs with lazy allocation
      pidfs: adapt to rhashtable-based simple_xattrs
      xattr: remove rbtree-based simple_xattr infrastructure
      xattr: add xattr_permission_error()
      xattr: switch xattr_permission() to switch statement
      xattr: move user limits for xattrs to generic infra
      xattr,net: support limited amount of extended attributes on sockfs sockets
      xattr: support extended attributes on sockets
      selftests/xattr: path-based AF_UNIX socket xattr tests
      selftests/xattr: sockfs socket xattr tests
      selftests/xattr: test xattrs on various socket families

 fs/kernfs/dir.c                                    |  15 +-
 fs/kernfs/inode.c                                  |  99 +----
 fs/kernfs/kernfs-internal.h                        |   5 +-
 fs/pidfs.c                                         |  65 +--
 fs/xattr.c                                         | 423 +++++++++++++------
 include/linux/kernfs.h                             |   2 -
 include/linux/shmem_fs.h                           |   2 +-
 include/linux/xattr.h                              |  47 ++-
 mm/shmem.c                                         |  46 +-
 net/socket.c                                       | 119 ++++--
 .../testing/selftests/filesystems/xattr/.gitignore |   3 +
 tools/testing/selftests/filesystems/xattr/Makefile |   6 +
 .../filesystems/xattr/xattr_socket_test.c          | 470 +++++++++++++++++++++
 .../filesystems/xattr/xattr_socket_types_test.c    | 177 ++++++++
 .../filesystems/xattr/xattr_sockfs_test.c          | 363 ++++++++++++++++
 15 files changed, 1547 insertions(+), 295 deletions(-)
---
base-commit: 72c395024dac5e215136cbff793455f065603b06
change-id: 20260211-work-xattr-socket-c85f4d3b8847


