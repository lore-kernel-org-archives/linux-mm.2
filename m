Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A601C606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 11:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5UCROmp
Received: by kanga.kvack.org (Postfix)
	id 21A606B00EF; Sun, 15 Nov 2026 06:47:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2866B05B0; Sun, 15 Nov 2026 06:47:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12FB86B05B1; Sun, 15 Nov 2026 06:47:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E794F6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:47:53 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72C78406AF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 11:47:53 +0000 (UTC)
X-FDA: 85437179226.02.39D10C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B331C160007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 11:47:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5UCROmp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794743271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUUoDFkPJkBg6tiiX+gwUNqdlWB0vRGU4J1TlhHh7ZE=;
	b=aJOKzd2rPyT5Xhlal2MHSWwrAu6AddyccdYIsEUAA1j4ax3NJnrSVkWH+OdvpxBvw+VlEw
	7taalqoXtPSVM5CjWiJe4IPB5IHFNVJnNoIxSBLn4eGvfVCOMtPPlYPfJMKYOcrtSNw1xE
	vlVSMIVCXzMwOgMgE8ZJdEacBlCY8b8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794743271;
	b=eu7ZuLsGd1wtgQnOzAEp2387kQy40PcXxc+uoyCTFKWA1RD2m4eiphGr3gUwaEqvuohaX3
	6UQiJwelTX79uwo73dVwHAJBEGetp1FnIceYwEV0aNbBlixpiD4kuocWqR4Zc+SGQJQ4+I
	ilAQZTbXvIW5Dxx/zcGf0gl5djHtd28=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5UCROmp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A73F44567B;
	Sun, 15 Nov 2026 11:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF671F000C4;
	Sun, 15 Nov 2026 11:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794743270;
	bh=dUUoDFkPJkBg6tiiX+gwUNqdlWB0vRGU4J1TlhHh7ZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O5UCROmpYOxPof//EVMXlzhE8CwpBAuLxySuhjVJTwgdWIcUjDEHfxQDjag+uTRua
	 Z+qDIjnj4mqHBNrUw8Ko1zjkZMcqAeFq8ldvZlzCVbByFB+ptCuml13g6R68XiAcOc
	 tTmUPUcRTu4mDvyiHtXFi/q4pZoMhhtkVDTdv1WqLRxEzoDBelkcsk5jYXJt2EAUob
	 xjg6qsjtw4gR2WGGuYhHVN3Y9VjEoACQTHM3FtneMm5yNVilA99bE1xWageT1rHDiS
	 UNAqlNNFNjgatsQNOofsxEUu3m18tcJw6JldfrHIojxyBAVmlXl979klg5KOmmNJfI
	 Ivyq26TJMKVYg==
Date: Sun, 15 Nov 2026 12:47:41 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chris Down <chris@chrisdown.name>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
	ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
Message-ID: <20261115-boxen-mundschutz-jacht-0ab871beca58@brauner>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
 <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
 <CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com>
X-Stat-Signature: 5nyey35qmr83w84d7y9owom7d4ha44rn
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B331C160007
X-HE-Tag: 1794743271-419514
X-HE-Meta: U2FsdGVkX19eQtlWYxvKE6HaPbbrhqubfr/bwdrL9OO1l3TTnZvhRQMMazmjRF9G4GmOOHoDEXr7vWtJea1L0feix/tFEUcOqOvjSc7SSChupqBcpjR0U/xmqqByWBXX1yvk1j+KrmuKmtSfJ4qbmC37aHcgmiOq5JoPtxs+J4Qq284R4tAPxYzxI7qxIeXknx4yq6OAnqZ02hhdpWE7s21iVvvLg45+cyIuM9aRuphLvWD08oXbG9XSwEFN1ch1pP9AfZpoeIbrTj2gI1z2RAsIrn+of6K2fcrLkCn17IzWiOo1eV06NF4nadLW0nw5YHl3CiTVf12ZX0QxbM7OKxQVGRlqZ6hFjxL5xhT/XR+4PhUIsbfTyTEVvord+UgbDkPtgy1MP3x00XP+HeGoGtNq97UK7P4fhQwsxAQjj98r/yka87emok5aWuC3iYbbo4s7BOD1JWBA+by7AdOebeoxT2syUk/I6R7nM/+GZYvIyNO/SC+NPUGAtTUEvTcBcn/cZm61gJbrMTlPGRQKG6vLTzbBKUfRhiyKmJjK3lSQkMfZmIqZ4L9apP9DqpqR0Us3dHt7I7YUfF/I3PliZ2UhWZTzFEoznbZrQRkS291Tjc4u0cl40FSWer+k1GeIiRLhQgsiOe4NEfYENRHD+MNEP7sXfjE3vBscLBqIHbm4OT9hrfuQH4nwSfhubZwhE6pgIbahxS0AcQFIuc45y2L94WA9gOPTSHayivob1AZAI7arAGyS1hSQLnA2zq8neq4gZZFuivxq0E7j3UKMIdfzXQnTx5Rwnh9sDWCTyRSOmN93urAfmkcT7fpM2GT39vHgQek6D3UIbxA+XMzT/kDuyXXzBBbYaBeymKc9McvhkFOJea3uM2qJe0HKnXqunI5ucdTvHE8KQELM3snkuWji9MoJtQQWzAo43/abAvMKek65m5QBQaErlqBJtl2wpDDVP5YmU7b9Xt8+n64
 c38k/NXc
 4ucqrsr/cOvQa5ehZCIaNlKaWpV8NPNJ/8HdgGYdL8v5BgQrCDw/I/ybjxHIoETHe9K6TrW1CWToMtDlsD3OnfLkhUvJWf4UdaF3odntEn65JFXh/JMQPaBjNgSgZw+B8pOwnMkL7g9TgFTGcfXmQ3vVQQ9QorJmSRt7eyViRqPeiz5X/lDaG9g0KU7Se3h6LnPbdobbDvumMdVwxC0b0IxgRwZOKMBFtVRZZlsrlDajW2Id85nm5hnKTPt1/sVkQdfG9G2woVbEb7g/UKTmvQlPOgdeWMW6JQZERJU0L4wKBLbHbpFOvSJi8ZyUI4f19UTq95upavX3CDPrX7PkrkZc4C/Qp13k4x47GvbTiEbI8t+zb3hcDUPN4CQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 12:19:57AM +0100, Amir Goldstein wrote:
> On Sat, Nov 14, 2026 at 9:06 PM Chris Down <chris@chrisdown.name> wrote:
> >
> > Hi Christian,
> >
> > Christian Brauner writes:
> > >+      /* Look through stacking filesystems at the inode with the data. */
> > >+      if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEUDO)
> > >+              return -EINVAL;
> >
> > This looks good in general, but what the bots said about O_PATH files
> > here is real. With FMODE_PATH this is reached for a file that was never
> > opened, so on overlayfs nothing has been through ovl_open() to look up
> > the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
> > itself, and when that fails it hits the WARN(1) at its end and returns
> > the overlayfs dentry, so the check passes as well.
> >
> > Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
> > it's easy to trigger with that. From a quick test with a metacopy file
> > whose redirect into a data-only layer points at nothing, registering an
> > O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives
> >
> >      ovl_d_real(/f, 0): real dentry not found
> >      WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
> >      [...]
> >       file_check_backing+0x308/0x5e0
> >       fuse_backing_new+0x219/0x4a0
> >       fuse_backing_open+0xe8/0x390
> >       fuse_dev_ioctl+0x53a/0x7d0
> >
> > and the ioctl still succeeds. A normal open of that file fails with
> > ENOENT, so nothing could have used it as a backing file anyway, but with
> > panic_on_warn this is now a panic.
> >
> > Maybe ovl_d_real() should just stop warning when the lookup fails, now
> > that it has a caller that isn't trace_uprobe?
> 
> Yeh I guess that this needs to be a Fixes for lazy data lookup.

I have a fix for that.

> The correct fix would be to teach all the callers to deal with an error.

I've also implemented that. It wasn't that hard and it's also a bug. Not
a bad one but still.

> > The check would still pass
> > for an O_PATH file whose lowerdata couldn't be looked up at that point,
> > though.
> 
> One observation relevant to this patch set is that a datadir layer has no
> business being a pseudo fs and that can and should be blocked explicitly
> at overlayfs mount time.

I agree.

> The other observation is that fuse_passthrough_open() should probably
> check the backing_file that was opened for io in addition to checking
> in fuse_backing_open(), which could have different FMODE and specifically
> could be FMODE_PATH.

Sounds good.

