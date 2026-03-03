Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 600B7EC1438
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 12:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED6F6B00A5; Tue,  3 Mar 2026 07:41:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4276B00A9; Tue,  3 Mar 2026 07:41:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899196B00AB; Tue,  3 Mar 2026 07:41:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7704B6B00A5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:41:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C878C07D1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:41:05 +0000 (UTC)
X-FDA: 84504711690.23.FC16F8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5EFD040004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:41:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zvz0oQM9;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772541663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dz1UqQWo35jSY2bBvEnEEfh/E4dbpsr+vpKWUaY3iw=;
	b=U/4rgI52F5XCdcCOwzbPvkOSbP7OH7bpVEywq0bTdpG2gGJVpwOwEOdrHMuVvGz9QkQuwJ
	1dQhDaZ5DOM3wnqKNb+W2+xaEmnlDwel1DmW1m9GsbKHCEX3jsUxr2c5VQjzdh9Jpl9VfN
	Mk/ITpoy3SsIjdQQ2JSEel1cKyJ9RHE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zvz0oQM9;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772541663; a=rsa-sha256;
	cv=none;
	b=O9BrEitolbAv83shBfuml4YUJpcwcQncJplqGsqRWlMwemTJFmHNRQSzrvxqZFtZO1TTT0
	ugVsOpawbEqPd5HYNzZ4rt0bEgMOTy+SNZWLcjI08LL6jix0omCN+54w9tbwxmPxH+yu32
	diBknUh6oDmAy9ALZEyqneTUFDXJ2pc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A8376012B;
	Tue,  3 Mar 2026 12:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A327C116C6;
	Tue,  3 Mar 2026 12:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772541662;
	bh=VP3JX/y7oHBrbuT3Z5WJTKU4TP0CvwWXeHSRvhRDUa4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=Zvz0oQM923J04EpBWJnh25hhi1uji/p9u147a6lunY/FvMUKCcB35+UyrQ0TMgEa5
	 GdwqkMNsNHk7uOP5gamt+yaACOgsqZbyv8Q6aXl/q5ROkvBu87FNOVYXK8CpHIxmEm
	 DiteLwJWuRDYIJ3IgaK/HoVWBG06sjQe0n34B1+PNE6XDMKpiXq5/bkfI3YvyOLjL5
	 xu53HCqTB8sVkttFXX0uh9wl9fmZToNs05cXE4Ea9br9f+WmAEhi6+QXnESXgGFt0d
	 9iDNZgv2JJ+8YSmo8OGVtxnPp0u/cZ+lalNTtSSkojp+G+/VCnuhFBbEDHV/dEz9rq
	 DkEeRpA2ASGUQ==
Message-ID: <1df344e68aca20c24d447318ff93db3f359043ee.camel@kernel.org>
Subject: Re: [PATCH 00/14] xattr: rework simple xattrs and support user.*
 xattrs on sockets
From: Jeff Layton <jlayton@kernel.org>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Josef Bacik <josef@toxicpanda.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>,  Jan Kara <jack@suse.cz>,
 linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun
 Heo	 <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski	
 <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Date: Tue, 03 Mar 2026 07:40:58 -0500
In-Reply-To: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: tk513ntfcf54wtjau9rbkwf9bc5aq8uf
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EFD040004
X-HE-Tag: 1772541663-66377
X-HE-Meta: U2FsdGVkX1+ua2/XHzv+cMHLOzHpzhAyiIK9xHzZxCmn+v9I8by3OYemeFpKtHjTMrJqOunF9rg9LjjzYXWvwf2Q2FZ9yA7DsHLJ762avXBgfzD2rg6EjgP8htIlS3UTMEjJnoherATnKXKH4l2Yz2ZxFmJ11i1Jz1iZjSjrJNopxroBLEPnzGcwpwDMkdkwswMNSqum109wKU5hmCbwnMYVGq2OAXeEFoPaA8tdwNu2zNgLO9adRMawxxApemhdWO/Hb+8oBXoFQpzkO0IJemngs4ldtb7eb6oeVck5dTnjrnWITHOjulTqM1g/3EA9eH3QyaQJPzeOaJOrXrW21cmLkMPkp7R+KpxUkmoh/6ourtnB5yLG2B6ZMN2sq4GJjh9CmNArjxoXalcfC5UTRzxuVogH7XKdBlRPLLdxVOVcohmlhfC2UEOwmO8Ueg0KNt01o6OKNakCahpFlBL+oBHuKs5ieN45QXRKRVLDLZAkFu9NSxI7NOpgqLVEeQ8hk/en8tKeNgWcWxOxHMtYznTHoTYP/FDumSu9+Fq3sj3MXcUsbk7rZwRljCp4MW0MgLUfIee52r8ctrh6w5VRiTnAOC8oQYeDi8bDzselcLdO65zLu3Z730AkP4MpsA6kPzoPMTxjC7f/maIbALidq9dVM69jR1em1ZwzJQX1tjtZW0WyzW/tVPGDHdb4+1HosVpCeGYZwSEZbMWF+jcA+EuvBKDPNHYlWaO6LaU7rqT61GVFfsUwcN20H/uWgVlEYHRvkLhu8hb01GFR1mwmTmPu5ebr5E1d+aX5dZ30TgdQc04L3vmeP38xQlgEt4BSVGnVPTGl0Iq7dL8SwfQC3IhGVunWnE6W+iI0zs+62t1bSLVBZJFAQdprTIqJKzMx6tfgsHcw8C2h/yoLEFcXKjc7MEzBj712LBtUDmFlojjPlj7+s1tjtPK22g4Tij729x/LInrrnCRiSqmuVZ3
 ER02oEnk
 UG2f+I+3cPk8Wf2bPf4gRWECyyWSXc1YmcSjcsSRGYTglKjrf2/+/wsUJanmIT4DR3X+G86N3t+z0OytLk8Gfu2rSJJuo8s1AfO5Yu6l2r0ummAgneaBeKfHVIX7own9ONEaN5T0/BMPtvv80uP71/MkbTXry0jQDqI7R4sGS7WlDYFYfVd32rwXc+8hwKfa31tPf0yxI8qOQjXpYnpaBK9vpLR2CBkG8lQxJUgMp5szuf0p25Wy8b90HlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-02-16 at 14:31 +0100, Christian Brauner wrote:
> Hey,
>=20
> This reworks the simple_xattr infrastructure and adds support for
> user.* extended attributes on sockets.
>=20
> The simple_xattr subsystem currently uses an rbtree protected by a
> reader-writer spinlock. This series replaces the rbtree with an
> rhashtable giving O(1) average-case lookup with RCU-based lockless
> reads. This sped up concurrent access patterns on tmpfs quite a bit and
> it's an overall easy enough conversion to do and gets rid or rwlock_t.
>=20
> The conversion is done incrementally: a new rhashtable path is added
> alongside the existing rbtree, consumers are migrated one at a time
> (shmem, kernfs, pidfs), and then the rbtree code is removed. All three
> consumers switch from embedded structs to pointer-based lazy allocation
> so the rhashtable overhead is only paid for inodes that actually use
> xattrs.
>=20
> With this infrastructure in place the series adds support for user.*
> xattrs on sockets. Path-based AF_UNIX sockets inherit xattr support
> from the underlying filesystem (e.g. tmpfs) but sockets in sockfs -
> that is everything created via socket() including abstract namespace
> AF_UNIX sockets - had no xattr support at all.
>=20
> The xattr_permission() checks are reworked to allow user.* xattrs on
> S_IFSOCK inodes. Sockfs sockets get per-inode limits of 128 xattrs and
> 128KB total value size matching the limits already in use for kernfs.
>=20
> The practical motivation comes from several directions. systemd and
> GNOME are expanding their use of Varlink as an IPC mechanism. For D-Bus
> there are tools like dbus-monitor that can observe IPC traffic across
> the system but this only works because D-Bus has a central broker. For
> Varlink there is no broker and there is currently no way to identify
> which sockets speak Varlink. With user.* xattrs on sockets a service
> can label its socket with the IPC protocol it speaks (e.g.,
> user.varlink=3D1) and an eBPF program can then selectively capture
> traffic on those sockets. Enumerating bound sockets via netlink combined
> with these xattr labels gives a way to discover all Varlink IPC
> entrypoints for debugging and introspection.
>=20
> Similarly, systemd-journald wants to use xattrs on the /dev/log socket
> for protocol negotiation to indicate whether RFC 5424 structured syslog
> is supported or whether only the legacy RFC 3164 format should be used.
>=20
> In containers these labels are particularly useful as high-privilege or
> more complicated solutions for socket identification aren't available.
>=20
> The series comes with comprehensive selftests covering path-based
> AF_UNIX sockets, sockfs socket operations, per-inode limit enforcement,
> and xattr operations across multiple address families (AF_INET,
> AF_INET6, AF_NETLINK, AF_PACKET).
>=20
> Christian
>=20
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
> Christian Brauner (14):
>       xattr: add rcu_head and rhash_head to struct simple_xattr
>       xattr: add rhashtable-based simple_xattr infrastructure
>       shmem: adapt to rhashtable-based simple_xattrs with lazy allocation
>       kernfs: adapt to rhashtable-based simple_xattrs with lazy allocatio=
n
>       pidfs: adapt to rhashtable-based simple_xattrs
>       xattr: remove rbtree-based simple_xattr infrastructure
>       xattr: add xattr_permission_error()
>       xattr: switch xattr_permission() to switch statement
>       xattr: move user limits for xattrs to generic infra
>       xattr,net: support limited amount of extended attributes on sockfs =
sockets
>       xattr: support extended attributes on sockets
>       selftests/xattr: path-based AF_UNIX socket xattr tests
>       selftests/xattr: sockfs socket xattr tests
>       selftests/xattr: test xattrs on various socket families
>=20
>  fs/kernfs/dir.c                                    |  15 +-
>  fs/kernfs/inode.c                                  |  99 +----
>  fs/kernfs/kernfs-internal.h                        |   5 +-
>  fs/pidfs.c                                         |  65 +--
>  fs/xattr.c                                         | 423 +++++++++++++--=
----
>  include/linux/kernfs.h                             |   2 -
>  include/linux/shmem_fs.h                           |   2 +-
>  include/linux/xattr.h                              |  47 ++-
>  mm/shmem.c                                         |  46 +-
>  net/socket.c                                       | 119 ++++--
>  .../testing/selftests/filesystems/xattr/.gitignore |   3 +
>  tools/testing/selftests/filesystems/xattr/Makefile |   6 +
>  .../filesystems/xattr/xattr_socket_test.c          | 470 +++++++++++++++=
++++++
>  .../filesystems/xattr/xattr_socket_types_test.c    | 177 ++++++++
>  .../filesystems/xattr/xattr_sockfs_test.c          | 363 +++++++++++++++=
+
>  15 files changed, 1547 insertions(+), 295 deletions(-)
> ---
> base-commit: 72c395024dac5e215136cbff793455f065603b06
> change-id: 20260211-work-xattr-socket-c85f4d3b8847

Reviewed-by: Jeff Layton <jlayton@kernel.org>

