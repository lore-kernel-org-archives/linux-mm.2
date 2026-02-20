Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C13C5516E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C18716B0088; Fri, 20 Feb 2026 04:24:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6476B0089; Fri, 20 Feb 2026 04:24:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD29A6B008A; Fri, 20 Feb 2026 04:24:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 968D06B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:24:04 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E65E1CF80
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:24:04 +0000 (UTC)
X-FDA: 84464298408.16.6F570F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id AFB3540006
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:24:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DGsyHYNw;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771579442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8qz6eDwBfFY8OxWFV7xEliVTEBlok02Qx3Lkd3Xirs=;
	b=4BXio/KvPOEOnWkhpTXbbf+MPKycYNGF38F3uEzr4FNbwTT066tzMVu/CJL6xPn47lGc7f
	roE9376whxxCj+WXM6K02ON1RhVLb4/R5KpIeWFj4fGMHPULH0MbOqEj8z+0XchoQF8NOr
	YReNs8m15PknBc2C/lUUMrUiLtDrRdw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DGsyHYNw;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771579442; a=rsa-sha256;
	cv=none;
	b=tnEkPejtJlhJMqn14ShNAfQAMAX83LJQQTolPhq7risT64tH3SW/M+f4XcvReN3FInpCrO
	AIbfqdBceDXzvTKlZgTaIRkyrbxPyOrqBTGyMEbHc5v+ZAY8MZuYK5XpGLj3+lASQr/Pxh
	wlbUgrBeyBTkC0rGsuc6D0d1OegArZc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1B8F60054;
	Fri, 20 Feb 2026 09:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36455C116D0;
	Fri, 20 Feb 2026 09:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771579441;
	bh=BHeY4ghWVmkcUwWQPrBz4LViBaL4pfipwy5Laz/tMBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DGsyHYNwmjHmKHTErCPbUzOMIEz5RBJFUZpcWdCAs6gEX2tsoSRcV+DxpXq9pSvIe
	 IaAhs24gC5QLcp1MlbR8zn/MPKnmTXLczuNHvw/xffmNP6X8gxX1O6E+HFhepV5Rhk
	 ffkPWVkWO6LZGLN2YNRtN9Udq6wNq1EWBRV5f+/bFvAdVxI3Z1l1Kf90DRBrm4xYKM
	 EUKmDg461M3xhij+RtvGXi2vpAt6u1Ga0MNNroyUBjVmD4a44KyKfh4tZXjLE0jvg8
	 rn6Iyiri9TfkiQQwTvLx2fo2l1QKUsJ3abNn36Q071N4YAsPRXVLd6TZmrcYnygnS/
	 32NxPOoV5Ybsw==
Date: Fri, 20 Feb 2026 10:23:55 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 00/14] xattr: rework simple xattrs and support user.*
 xattrs on sockets
Message-ID: <20260220-biobauer-beilhieb-2e792f9453cf@brauner>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260220004454.GR6467@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260220004454.GR6467@frogsfrogsfrogs>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AFB3540006
X-Stat-Signature: bi6xkhw63pzht7o1q8wt9toh37pbrbsh
X-HE-Tag: 1771579442-637281
X-HE-Meta: U2FsdGVkX19dNg7d6HZavu5x8PjPh0gW1zD2RsPwUenhRTyn2zYJay4kuyKqHcdbjVcCT3HxIoTLWEiR/6NbvC7fHq/suMkyPu0tjMztuqcQCPwQCppO4iztJVUmji51Mo53q3HmYq/aSLf98raJdJDFZ64yqc/6Xgh1ix6RSFvtSOupDvRzXyd6CVyKbybmvTeGwSKA56F4Soiq+HatetG7r6Z6Shi4OygU2vO+dvhLYQyujnl4fhvxDMn6twclSp7CIfTBcrXn9DBMugowFqCoBrU4fdMY25iE9qEWXFZqSxOqW8Vj0DWHMaXJb+6JIShEFM8S9NfIzIwQZL5d7fvgtNX1eYAg+xzyT50lVeed95J9QEEvhZ6nYkKM7QhJHIvSdgZCVpL9cWE/PIPU9LFgVMZkUGL1K+GLH3e0zBT1xCZheXvDdPkbGFxK9kcEPJm9tm3YNWAdKOX3d6ha2r0ov8LA3l8nwktyV5ftEfvC1JxPMBsit4UlTa8T0QW+FJ46BMdFNWp3qXijx1KbPpqDsMXXgNj7Z4E0pS59VX8B2YuuYqZIvOfCKXEeKv2CuKCemBIuakCSYM9+y6jlQLwm6UIZP7w/mN7NAK3Ut06t9TpHsrZh1fpzlW6KRd6Cx/7pYYQkQVaKtsUVw6BfzsSKB73LxZuYHdiLOIztrvod55WpIJD6hX+B+pxXnGFYuw6KNd9hXnDxwZBW1LSujBtNJGCvKzahRsmQMN4UA2sfVL0dftENgMpsrsy4wdGsVC6sGlH2MoJn8x6f0+nGfxSeQXpk7L3a/Nh4jThFDMeDuvV8SuuVz4UpX4YeMGXKzDYA8yJl3A79L56R6fJGxpc0fpjAd3CNs8heL0X6OhXBYvzHaRHOFlnIKE/etZav3isegTFTYJVa+rj2xyls9xGt6Cn1aXorFqG0Blrg5eoyI+Lzard2ZOHirtAJa5Pg1E9tPY/9PtViV/i5xQs
 AlKSTXB4
 LJ83bciyjkfxn1uU2OR7dSMEDfJotkdJX35iTPZBhRh0FbfsHrU1VfzaG3No4PnOwfxHuTyaos9mwd1mMvKeO4fCnCR+buTtp81GZI4mlXx0AUIXXO9DeOHpHAjqm+yZU6YEeLD1/UUGnBPm6pZr68aB6UJ2gpVfT4TiJGIo/Sy6vYqDj5p3bUTqXkCXZzKy86UdpQoucoMzstOOiihMEPoz+Mre2JpY1fCWkKsVpMTMl9ykqVGnGtjjcXMVbBhqdlGdZT8tWbL9CbgeTrpHbjhW0cZSE3TE5ToyVp3XLo+in9PsiDsIjGPCLw1nmZw895GhbG1PG7N7qreamy5ByS0tBL80928aTrMiSUC65gQwHlZrm5QMIPxt3JA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 04:44:54PM -0800, Darrick J. Wong wrote:
> On Mon, Feb 16, 2026 at 02:31:56PM +0100, Christian Brauner wrote:
> > Hey,
> > 
> > This reworks the simple_xattr infrastructure and adds support for
> > user.* extended attributes on sockets.
> > 
> > The simple_xattr subsystem currently uses an rbtree protected by a
> > reader-writer spinlock. This series replaces the rbtree with an
> > rhashtable giving O(1) average-case lookup with RCU-based lockless
> > reads. This sped up concurrent access patterns on tmpfs quite a bit and
> > it's an overall easy enough conversion to do and gets rid or rwlock_t.
> > 
> > The conversion is done incrementally: a new rhashtable path is added
> > alongside the existing rbtree, consumers are migrated one at a time
> > (shmem, kernfs, pidfs), and then the rbtree code is removed. All three
> > consumers switch from embedded structs to pointer-based lazy allocation
> > so the rhashtable overhead is only paid for inodes that actually use
> > xattrs.
> 
> Patches 1-6 look ok to me, at least in the sense that nothing stood out
> to me as obviously wrong, so
> Acked-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> > With this infrastructure in place the series adds support for user.*
> > xattrs on sockets. Path-based AF_UNIX sockets inherit xattr support
> > from the underlying filesystem (e.g. tmpfs) but sockets in sockfs -
> > that is everything created via socket() including abstract namespace
> > AF_UNIX sockets - had no xattr support at all.
> > 
> > The xattr_permission() checks are reworked to allow user.* xattrs on
> > S_IFSOCK inodes. Sockfs sockets get per-inode limits of 128 xattrs and
> > 128KB total value size matching the limits already in use for kernfs.
> > 
> > The practical motivation comes from several directions. systemd and
> > GNOME are expanding their use of Varlink as an IPC mechanism. For D-Bus
> > there are tools like dbus-monitor that can observe IPC traffic across
> > the system but this only works because D-Bus has a central broker. For
> > Varlink there is no broker and there is currently no way to identify
> 
> Hum.  I suppose there's never going to be a central varlink broker, is
> there?  That doesn't sound great for discoverability, unless the plan is

Varlink was explicitly designed to avoid having to have a broker.
Practically it would have been one option to have a a central registry
maintained as a bpf socket map. My naive take had always been something
like: systemd can have a global socket map. sockets are picked up
whenver the appropriate xattr is set and deleted from the map once the
socket goes away (or the xattr is unset). Right now this is something
that would require capabilities. Once signed bpf is more common it is
easy to load that on per-container basis. But...

> to try to concentrate them in (say) /run/varlink?  But even then, could

... the future is already here :)

  https://github.com/systemd/systemd/pull/40590

All public varlink services that are supposed to be announced are now
symlinked into:

  /run/varlink/registry

There are of-course non-public interfaces such as the interface
between PID 1 and oomd. Such interfaces are not exposed.

It's also possible to have per user registries at e.g.:

  /run/user/1000/varlink/registry/

Such varlink services can now also be listed via:

  valinkctl list-services

This then ties very neatly into the varlink bridge we're currently
building:

  https://github.com/mvo5/varlink-http-bridge

It takes a directory with varlink sockets (or symlinks to varlink
sockets) like /run/varlink/registry as the argument and will serve
whatever it finds in there. Sockets can be added or removed dynamically
in the dir as needed:

  curl -s http://localhost:8080/sockets | jq
  {
    "sockets": [
      "io.systemd.Login",
      "io.systemd.Hostname",
      "io.systemd.sysext",
      "io.systemd.BootControl",
      "io.systemd.Import",
      "io.systemd.Repart",
      "io.systemd.MuteConsole",
      "io.systemd.FactoryReset",
      "io.systemd.Credentials",
      "io.systemd.AskPassword",
      "io.systemd.Manager",
      "io.systemd.ManagedOOM"
    ]
  }

The xattrs allow to have a completely global view of such services and
the per-user sessions all have their own sub-view.

> you have N services that share the same otherwise private tmpfs in order
> to talk to each other via a varlink socket?  I suppose in that case, the

Yeah sure that's one way.

> N services probably don't care/want others to discover their socket.
> 
> > which sockets speak Varlink. With user.* xattrs on sockets a service
> > can label its socket with the IPC protocol it speaks (e.g.,
> > user.varlink=1) and an eBPF program can then selectively capture
> 
> Who gets to set xattrs?  Can a malicious varlink socket user who has
> connect() abilities also delete user.varlink to mess with everyone who
> comes afterwards?

The main focus is AF_UNIX sockets of course so a varlink service does:

  fd = socket(AF_UNIX)
  umask(0117);
  bind(fd, "/run/foobar");
  umask(original_umask);
  chown("/run/foobar", -1, MYACCESSGID);
  setxattr("/run/foobar", "user.varlink", "1");

For non-path based sockets the inodes for client and server are
inherently distinct so they cannot interfer with each other. But even
then a chmod() + chown(-1, MYACCESSGID) on the sockfs socket fd will
protect this.

Thanks for the review. Please keep going. :)

