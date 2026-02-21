Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DB41C5DF68
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 00:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313846B0005; Fri, 20 Feb 2026 19:15:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1056B0089; Fri, 20 Feb 2026 19:15:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EA176B008A; Fri, 20 Feb 2026 19:15:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09FC96B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:15:02 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 552CEC1AA7
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 00:15:01 +0000 (UTC)
X-FDA: 84466543602.26.E419E12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 885E1C0004
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 00:14:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gm1Xi3dv;
	spf=pass (imf10.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771632899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIod2dutXppcRfuwBGpuqoExvgdWy1vEIHbOW6ewO1w=;
	b=Oj0IU9fte4Gz/nyct42GhRmyQnLpbtynFM52Zx639j/uQfsD5hWvWEXGWJHwUim49Ia0DH
	RMTZ0JwHWAKLuS7rfZEtil/Boima5mbmLrDxBw8QXu5ob0zZUlNQ9eQNNqY74DVYMUYRQn
	egttWlD5JOVe9s8pBbBx0MY8l5xhzlM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gm1Xi3dv;
	spf=pass (imf10.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771632899; a=rsa-sha256;
	cv=none;
	b=ASkhEV+jD4sgEBhT+oJJKhmM9Uja/NRkxFsgQdJ+RwSqVlmSP2638veLmc3hkBq5jGUL+S
	VImNeU6ynOLBVaT6NdXdvOyU1cHKgHBoDSqMl9adnLyuOn2M8JqM9z1R2IGl/c9gMVUeZJ
	qz4Nne18/EKTey+9ddrxG6KKg686KoM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 432DC434AF;
	Sat, 21 Feb 2026 00:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBCAC116C6;
	Sat, 21 Feb 2026 00:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771632898;
	bh=cPOXXeoMDDb6cE4js7btDJ4jN4yUD0fdZu49+gMi3ig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gm1Xi3dvnq5YtpVfl8JZPdsvzTXmuk1XT3ncjNDt44oMBe4yZg+FDZPRwBfmp9Sjv
	 cv1Yr+UqCemI4ia6PBzyOHRi0++Z1Kq4oDpMuPS9YQH1gis6iaSJw6gIAP68HStvoe
	 OcBAsgmA7nb3AqMD+2rFEUT9VjI6rE0WRr3GtrGut91Amhcr5WcVXwwxr2FstBRtGI
	 dNOQ2tvoS9DHSk6RZJwsPyqSQpYK4hfzDHUBqIG1AfSb4eizZbIca91x7CH1UWFdFG
	 0P2o+/8TnoL7W6ofnLu1E6SawJYbif5Jo5k0/Jn0ZHY2k5k3FZwbWx+0MQsuTu4Y/q
	 7OGxSkv+jbZyA==
Date: Fri, 20 Feb 2026 16:14:57 -0800
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
Message-ID: <20260221001457.GC11076@frogsfrogsfrogs>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260220004454.GR6467@frogsfrogsfrogs>
 <20260220-biobauer-beilhieb-2e792f9453cf@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220-biobauer-beilhieb-2e792f9453cf@brauner>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 885E1C0004
X-Stat-Signature: 5n1sa8kjf586zdjmxhtm13jy7tuw33bo
X-Rspam-User: 
X-HE-Tag: 1771632899-171765
X-HE-Meta: U2FsdGVkX18Fws+okWLFLAro0CsFnUoqE4T/j0qsE3UQSBwwAMrsk6g19DH6kNqkpakMGNfR6qOWxILc8eK2YZJs7hh5ZAv7Vd056qphCFByZytwWZ3YfbanY8nlO9Cf2BDb3TkxgWYYhLqqRcMQOmzW3gXcneJe7L5m9AXLOlqR639hIbsrwM3NlG4MTJQ9TCPqy9v81bwyBcyvEcMDxPDfdl7qet1H58zgy2wKYtEmDRHi3h+6BkegaDil7OodOxyaEgVaFmvzkA8r5u2uHwGd6mvK3CyBUBHxveuHgWk8EsOxxFaTsss1JTAMNthHZQq9NMu50tueQtXGyFgqDSxlSJGbUFmqJPuTC4Oa/elZ8KcN7+0OsjhovESETAomQPcffiK4TMYFaGEX6lyKFS7/kSd22pftBGMYD4gXxzuJAleWCRK+LxGHGAkAtkiyYrs+txEQujwcb9200dy2/YVWmxscNGolXr3WqK9Oi4d9sy80JXLMWHlgZ0FpzLXMPmgKT4K1bmnJDFkHjmBkgu4wxao6tgOEwEBwZpU+zVHVfgQdvoHbGAYg/4TO3WLELERNPWJhQyTp0/2basIgRW/PWTwy224gNBT9IOobVJNOG3A1quZKLYx4baUrn4Ut1+PppDCHMBCQwBJmvMHXsE/oVNiuyVD4UnZx54+5RFV+9SKrS19bqIhEkjuT+/XXAd9uT31/ZnQIFl+WxIRpRuh7xo6DrMgc0sLPBTxjG353vSB7moKQZYAtF6RAMyuFZeARWIQGfF2bv5Be/V3/fdhMofIi/wysbkKgVl6K7RbL+7OuyTkM+2tHgz2mB7/n7tA8zLpKlVx0cEIinoyhkNbNy3aRpbVsZOWL0FJJsh4ThzQaoXS8C/fgjBzBhK5oFN6FMmJ7S8J8JOQf8aYjtuCJppaiZJDEDavjERZAxEZez7GuLBRsUi589u7Zk1hmNwRJyxvSKITuOf6dJMp
 w1DGVnL4
 WOXLr+r6sGLDw2m43OmD/ZJ9nfsWKkQvVtYpFWAoUXORAn0bszyKY9tJb21A0mpNxFWX56GIhNcr+gRVSuJv+QGy2wqWwxZZ5Ww27awu+uHw7ikt/q0bGJSlHzljUTvY62oF0zK9DPgAPNjmEyMiBrl7kRfMFcwq43IwTW/jUV7VUjWnllFNioGRMGq3UeNTgYbQl/CeQLmJ4y1AANQTaWHIsxzXoc39wqP5D0da5e5U6H1O7C+hZAbeW9aLrISHFY8FK/62LLcJ7j0msJUP5+yXpgDmo1u1UeAvX9h3iovRa5DjJFTXV4MPVrmSmonJXENQTMYVLQev8HBk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 10:23:55AM +0100, Christian Brauner wrote:
> On Thu, Feb 19, 2026 at 04:44:54PM -0800, Darrick J. Wong wrote:
> > On Mon, Feb 16, 2026 at 02:31:56PM +0100, Christian Brauner wrote:
> > > Hey,
> > > 
> > > This reworks the simple_xattr infrastructure and adds support for
> > > user.* extended attributes on sockets.
> > > 
> > > The simple_xattr subsystem currently uses an rbtree protected by a
> > > reader-writer spinlock. This series replaces the rbtree with an
> > > rhashtable giving O(1) average-case lookup with RCU-based lockless
> > > reads. This sped up concurrent access patterns on tmpfs quite a bit and
> > > it's an overall easy enough conversion to do and gets rid or rwlock_t.
> > > 
> > > The conversion is done incrementally: a new rhashtable path is added
> > > alongside the existing rbtree, consumers are migrated one at a time
> > > (shmem, kernfs, pidfs), and then the rbtree code is removed. All three
> > > consumers switch from embedded structs to pointer-based lazy allocation
> > > so the rhashtable overhead is only paid for inodes that actually use
> > > xattrs.
> > 
> > Patches 1-6 look ok to me, at least in the sense that nothing stood out
> > to me as obviously wrong, so
> > Acked-by: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > > With this infrastructure in place the series adds support for user.*
> > > xattrs on sockets. Path-based AF_UNIX sockets inherit xattr support
> > > from the underlying filesystem (e.g. tmpfs) but sockets in sockfs -
> > > that is everything created via socket() including abstract namespace
> > > AF_UNIX sockets - had no xattr support at all.
> > > 
> > > The xattr_permission() checks are reworked to allow user.* xattrs on
> > > S_IFSOCK inodes. Sockfs sockets get per-inode limits of 128 xattrs and
> > > 128KB total value size matching the limits already in use for kernfs.
> > > 
> > > The practical motivation comes from several directions. systemd and
> > > GNOME are expanding their use of Varlink as an IPC mechanism. For D-Bus
> > > there are tools like dbus-monitor that can observe IPC traffic across
> > > the system but this only works because D-Bus has a central broker. For
> > > Varlink there is no broker and there is currently no way to identify
> > 
> > Hum.  I suppose there's never going to be a central varlink broker, is
> > there?  That doesn't sound great for discoverability, unless the plan is
> 
> Varlink was explicitly designed to avoid having to have a broker.
> Practically it would have been one option to have a a central registry
> maintained as a bpf socket map. My naive take had always been something
> like: systemd can have a global socket map. sockets are picked up
> whenver the appropriate xattr is set and deleted from the map once the
> socket goes away (or the xattr is unset). Right now this is something
> that would require capabilities. Once signed bpf is more common it is
> easy to load that on per-container basis. But...
> 
> > to try to concentrate them in (say) /run/varlink?  But even then, could
> 
> ... the future is already here :)
> 
>   https://github.com/systemd/systemd/pull/40590
> 
> All public varlink services that are supposed to be announced are now
> symlinked into:
> 
>   /run/varlink/registry
> 
> There are of-course non-public interfaces such as the interface
> between PID 1 and oomd. Such interfaces are not exposed.
> 
> It's also possible to have per user registries at e.g.:
> 
>   /run/user/1000/varlink/registry/
> 
> Such varlink services can now also be listed via:
> 
>   valinkctl list-services
> 
> This then ties very neatly into the varlink bridge we're currently
> building:
> 
>   https://github.com/mvo5/varlink-http-bridge
> 
> It takes a directory with varlink sockets (or symlinks to varlink
> sockets) like /run/varlink/registry as the argument and will serve
> whatever it finds in there. Sockets can be added or removed dynamically
> in the dir as needed:
> 
>   curl -s http://localhost:8080/sockets | jq
>   {
>     "sockets": [
>       "io.systemd.Login",
>       "io.systemd.Hostname",
>       "io.systemd.sysext",
>       "io.systemd.BootControl",
>       "io.systemd.Import",
>       "io.systemd.Repart",
>       "io.systemd.MuteConsole",
>       "io.systemd.FactoryReset",
>       "io.systemd.Credentials",
>       "io.systemd.AskPassword",
>       "io.systemd.Manager",
>       "io.systemd.ManagedOOM"
>     ]
>   }
> 
> The xattrs allow to have a completely global view of such services and
> the per-user sessions all have their own sub-view.
> 
> > you have N services that share the same otherwise private tmpfs in order
> > to talk to each other via a varlink socket?  I suppose in that case, the
> 
> Yeah sure that's one way.
> 
> > N services probably don't care/want others to discover their socket.
> > 
> > > which sockets speak Varlink. With user.* xattrs on sockets a service
> > > can label its socket with the IPC protocol it speaks (e.g.,
> > > user.varlink=1) and an eBPF program can then selectively capture
> > 
> > Who gets to set xattrs?  Can a malicious varlink socket user who has
> > connect() abilities also delete user.varlink to mess with everyone who
> > comes afterwards?
> 
> The main focus is AF_UNIX sockets of course so a varlink service does:
> 
>   fd = socket(AF_UNIX)
>   umask(0117);
>   bind(fd, "/run/foobar");
>   umask(original_umask);
>   chown("/run/foobar", -1, MYACCESSGID);
>   setxattr("/run/foobar", "user.varlink", "1");
> 
> For non-path based sockets the inodes for client and server are
> inherently distinct so they cannot interfer with each other. But even
> then a chmod() + chown(-1, MYACCESSGID) on the sockfs socket fd will
> protect this.
> 
> Thanks for the review. Please keep going. :)

The rest look fine too, modulo my comments about the fixed limits.

Acked-by: "Darrick J. Wong" <djwong@kernel.org>

--D

