Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E82EC531F6
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 00:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955B46B0005; Thu, 19 Feb 2026 19:44:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D156B0089; Thu, 19 Feb 2026 19:44:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859C56B008A; Thu, 19 Feb 2026 19:44:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 757036B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:44:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FA271B602D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:44:58 +0000 (UTC)
X-FDA: 84462990276.04.C301995
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9496D1C0012
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:44:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iNgrOn2F;
	spf=pass (imf18.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771548296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ec57cqNejTPjMjje6tikIvXcTnr2nUu1M8l7acAwyc8=;
	b=2hyvUNvLlreTIdz0parmpeeG/n1BQMc9x42vhAYi9cDC4gIwyQvL9XekjnhvSl2a3HcJSy
	AaWaTwuUjR5g6/hGNx0lZ3fyOvZLTBjLurOlMAruLUKVDYjL6Ho/JhkgKw2EARfHXNHTSY
	btneosmSgLT8BQ4VnZzLRqr+VQ1UbcY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iNgrOn2F;
	spf=pass (imf18.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771548296; a=rsa-sha256;
	cv=none;
	b=YFJSVS6nSz49ptxY/830eewCHecBKwnsgMhiXY+15rLPuKs9eiWMkKW8wmRtjnfr3psXXn
	eh36KprNIDsbjuLPMPd3ND0zixXFnbtcD5H5ZBhMU0bcN1Pb0Z0skQ+MSsegDE57Lhpt1E
	nmx+z6QLD1Cq/wdyoc4jjarTjOYyjts=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E1E3960054;
	Fri, 20 Feb 2026 00:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847DCC4CEF7;
	Fri, 20 Feb 2026 00:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771548295;
	bh=kagJ+UlIdLhqkqspgrp0oS3pZa0ipNhQ034OQlfEeFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iNgrOn2FjR7+xFM/Tus8NkYomQ/mZXHDMoEg2Ks1LLulQRPBoVawVhUJLwQjt36Po
	 YyrJsb863cKScPUVC9qF3gpeYWh+eTIs0jNcVwrl0A/zcWKRrKQXwS0vbmbTLjdqW1
	 wlZAw/+Sj7fVU+aC73t335JuSCkVltl/wUxzo4oq2oiig4DsYbQ7IhD8tncmYsH+XS
	 OqklRFg5TRKLiMOK3S1IyBB7AMBMDhc7kgSiKRBGFKZMbZxhdmaY/tNAmw1uB0Vu8f
	 AQqsqtBQ+VS8i6HkYSrzjPX0RKcxkA9Nt/eFkvZZKrtV6PfcuJayphZ7c2SVGLXTRn
	 RMUZQXkbI5mHA==
Date: Thu, 19 Feb 2026 16:44:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH 00/14] xattr: rework simple xattrs and support user.*
 xattrs on sockets
Message-ID: <20260220004454.GR6467@frogsfrogsfrogs>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 9496D1C0012
X-Stat-Signature: d7xnwp9wrgg13o1bn9as7dq5g6aathtm
X-HE-Tag: 1771548296-631047
X-HE-Meta: U2FsdGVkX19UnkqNLtEhWNGs039yVKrNIlO9EhOuDnD3X96AKbYcBynk8nD65nj6bOKFgsQwskzEFMrrnMVh7PqNHgLsGJJr6kh0XONS6URIJZ/50lVkArA+/pFAeOfIHlGafJZgDgxak0vwOTKtkmnT/BO9v51w/rPqBgJHBMaTG4aQO7pRCOQcgxTIx18h6/RQsrwjY+cyX38DuBF8NXIWjFCu2sOlalySC7G05t70SP0fP5rGCnkDaMEwBNbhyGqsUGivKSoaYNl0wMwBlaLncg+NZAwCDBo+Ch/QsHI7mBpe8U3NcLsZuvpiFC0woDIXqhzHu49/k3Vpiu+4UiI/pFRYrfTpauQdwgeyD8SD20FMwNbN25Gp768OZlv4IE7/LIiBGy02Ws3BBovxIqdJsN6cVqhc3LLRRIMZ/fHnrs9jWJY7uj/ebs/c3+N9N0xDk7qXEs4kWtrmJpai6m/87PBpAuBvBn4GsEVJNuRuk/9ANRwd89ndLLQTZ8lPQHrjSfue5kZnTbvQAxioYtPNqVH3XhMeiLYhNlouhRvuqzEcFVdFstHPpjHzpOAtcPYIXzEufWeziPUsFsNptJGurblyDCx3BCjX7EdNKV6fnS/zIkruuyvpCdEqnooSnn2/oRMZHbr3ipWg9qiDrN/YT4KKEbhKibDrwhZic8mVybAGpKNBIiTho7Dv+okimstpjd0WUHRzsG7NIgBKKhj6Zk20huCimssgRiMg/ZJLlX2isQdG3i+SvS04Nva/I6fObBYPV6vgeUnOCI16WePtN90kZ0I2rLBkFnOCXqpPLmuYSHVuBuKw/InoZZ1gzKzfa65wfaEjtyQu2PMuKrhrfqoK2IENOKsp/m3xlxJyJaQ3btbCP/LCqFMmMhWZjgulasaQU4Ze7KxXTw8ZwaFEOHOwCSz1169cFTeMCWY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 02:31:56PM +0100, Christian Brauner wrote:
> Hey,
> 
> This reworks the simple_xattr infrastructure and adds support for
> user.* extended attributes on sockets.
> 
> The simple_xattr subsystem currently uses an rbtree protected by a
> reader-writer spinlock. This series replaces the rbtree with an
> rhashtable giving O(1) average-case lookup with RCU-based lockless
> reads. This sped up concurrent access patterns on tmpfs quite a bit and
> it's an overall easy enough conversion to do and gets rid or rwlock_t.
> 
> The conversion is done incrementally: a new rhashtable path is added
> alongside the existing rbtree, consumers are migrated one at a time
> (shmem, kernfs, pidfs), and then the rbtree code is removed. All three
> consumers switch from embedded structs to pointer-based lazy allocation
> so the rhashtable overhead is only paid for inodes that actually use
> xattrs.

Patches 1-6 look ok to me, at least in the sense that nothing stood out
to me as obviously wrong, so
Acked-by: "Darrick J. Wong" <djwong@kernel.org>

> With this infrastructure in place the series adds support for user.*
> xattrs on sockets. Path-based AF_UNIX sockets inherit xattr support
> from the underlying filesystem (e.g. tmpfs) but sockets in sockfs -
> that is everything created via socket() including abstract namespace
> AF_UNIX sockets - had no xattr support at all.
> 
> The xattr_permission() checks are reworked to allow user.* xattrs on
> S_IFSOCK inodes. Sockfs sockets get per-inode limits of 128 xattrs and
> 128KB total value size matching the limits already in use for kernfs.
> 
> The practical motivation comes from several directions. systemd and
> GNOME are expanding their use of Varlink as an IPC mechanism. For D-Bus
> there are tools like dbus-monitor that can observe IPC traffic across
> the system but this only works because D-Bus has a central broker. For
> Varlink there is no broker and there is currently no way to identify

Hum.  I suppose there's never going to be a central varlink broker, is
there?  That doesn't sound great for discoverability, unless the plan is
to try to concentrate them in (say) /run/varlink?  But even then, could
you have N services that share the same otherwise private tmpfs in order
to talk to each other via a varlink socket?  I suppose in that case, the
N services probably don't care/want others to discover their socket.

> which sockets speak Varlink. With user.* xattrs on sockets a service
> can label its socket with the IPC protocol it speaks (e.g.,
> user.varlink=1) and an eBPF program can then selectively capture

Who gets to set xattrs?  Can a malicious varlink socket user who has
connect() abilities also delete user.varlink to mess with everyone who
comes afterwards?

--D

> traffic on those sockets. Enumerating bound sockets via netlink combined
> with these xattr labels gives a way to discover all Varlink IPC
> entrypoints for debugging and introspection.
> 
> Similarly, systemd-journald wants to use xattrs on the /dev/log socket
> for protocol negotiation to indicate whether RFC 5424 structured syslog
> is supported or whether only the legacy RFC 3164 format should be used.
> 
> In containers these labels are particularly useful as high-privilege or
> more complicated solutions for socket identification aren't available.
> 
> The series comes with comprehensive selftests covering path-based
> AF_UNIX sockets, sockfs socket operations, per-inode limit enforcement,
> and xattr operations across multiple address families (AF_INET,
> AF_INET6, AF_NETLINK, AF_PACKET).
> 
> Christian
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
> Christian Brauner (14):
>       xattr: add rcu_head and rhash_head to struct simple_xattr
>       xattr: add rhashtable-based simple_xattr infrastructure
>       shmem: adapt to rhashtable-based simple_xattrs with lazy allocation
>       kernfs: adapt to rhashtable-based simple_xattrs with lazy allocation
>       pidfs: adapt to rhashtable-based simple_xattrs
>       xattr: remove rbtree-based simple_xattr infrastructure
>       xattr: add xattr_permission_error()
>       xattr: switch xattr_permission() to switch statement
>       xattr: move user limits for xattrs to generic infra
>       xattr,net: support limited amount of extended attributes on sockfs sockets
>       xattr: support extended attributes on sockets
>       selftests/xattr: path-based AF_UNIX socket xattr tests
>       selftests/xattr: sockfs socket xattr tests
>       selftests/xattr: test xattrs on various socket families
> 
>  fs/kernfs/dir.c                                    |  15 +-
>  fs/kernfs/inode.c                                  |  99 +----
>  fs/kernfs/kernfs-internal.h                        |   5 +-
>  fs/pidfs.c                                         |  65 +--
>  fs/xattr.c                                         | 423 +++++++++++++------
>  include/linux/kernfs.h                             |   2 -
>  include/linux/shmem_fs.h                           |   2 +-
>  include/linux/xattr.h                              |  47 ++-
>  mm/shmem.c                                         |  46 +-
>  net/socket.c                                       | 119 ++++--
>  .../testing/selftests/filesystems/xattr/.gitignore |   3 +
>  tools/testing/selftests/filesystems/xattr/Makefile |   6 +
>  .../filesystems/xattr/xattr_socket_test.c          | 470 +++++++++++++++++++++
>  .../filesystems/xattr/xattr_socket_types_test.c    | 177 ++++++++
>  .../filesystems/xattr/xattr_sockfs_test.c          | 363 ++++++++++++++++
>  15 files changed, 1547 insertions(+), 295 deletions(-)
> ---
> base-commit: 72c395024dac5e215136cbff793455f065603b06
> change-id: 20260211-work-xattr-socket-c85f4d3b8847
> 
> 

