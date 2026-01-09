Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 245A3D232FF
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 09:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48FC76B0088; Fri,  9 Jan 2026 04:27:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446C66B0089; Fri,  9 Jan 2026 04:27:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31E6D6B008A; Fri,  9 Jan 2026 04:27:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2214A6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:27:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C142D13A799
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:27:04 +0000 (UTC)
X-FDA: 84311896368.15.5C00225
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 649EC180007
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:27:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KXI2iTWi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I+3h+YTM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=16e6Tram;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PGw8o01N;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767950822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ix79vpLIssdL500RHYujbFB++xsIiyUcELipWU4WwU=;
	b=2Wfqlkf2o0xs6r3ukmFmGh3Q9ct3cJP6aN9YRtPnm3JTQNrSoh1YGFYM7bAppTa0h6MICR
	x4XyfVs4M7QrX1HqWyMmtlySbMHg1nCSt85e2qKACT/Zhz9H5HYF1GlLztUGc7OyfFhKk7
	PPan2qV31/bS+8efEA1xRPIxA+z62Fk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KXI2iTWi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I+3h+YTM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=16e6Tram;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PGw8o01N;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767950822; a=rsa-sha256;
	cv=none;
	b=KV4Pa4/4DHC054zCxd5+4z/kmQs+rwagIkD3Yk5Nk4Lt+qtBo6HfafoefWXREu4Jxw8Hg5
	n0v6uphu++d47tDK4N4xQ8sCGUXsdlLY7p0lolvNW3nWu/X0rY7tJtDfxEXJ2DLM3kDZ60
	YE8kXGXOiL8IkfCGH1zq0llKzesB7Rw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 43CDB33820;
	Fri,  9 Jan 2026 09:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767950820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ix79vpLIssdL500RHYujbFB++xsIiyUcELipWU4WwU=;
	b=KXI2iTWiAJmOz21iis4yFqf5NnYhRDof3J19rqsZwYRuWlpBv5dcGDcz+rPkZ2NFQ7sBw3
	6F/yzH+m9ddnb9SROmmw6miQVWUavs2Eg8AGGPV1EpMQQU6h2S4XjYW76fJh6lzGTBRt02
	shHABFz4+AgJcXRKWJA4UpNzrHl4hCE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767950820;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ix79vpLIssdL500RHYujbFB++xsIiyUcELipWU4WwU=;
	b=I+3h+YTMi7XyTBxg0nKsfasYi3xNLsyRViTjEJI4hA7/0Kr4xASdVvjM5NCcFY8z/BXHig
	gtG0FCWUIYgZrHDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767950819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ix79vpLIssdL500RHYujbFB++xsIiyUcELipWU4WwU=;
	b=16e6TramPJH4Gs7875HDbzGuy8ICZI2BILnT1SGRvVAXeI5sQUjzAFlNaNR9kACorpHpXM
	nei3ptJVD2BUcQ5r+hV5aj5YMzGmHUhxPPheHPPJgtr2K4a0j9TnIfXo+9hSNy8lOl3XCf
	SJ1RxzU1924fXlBtLP3laUNrmhN+RXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767950819;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ix79vpLIssdL500RHYujbFB++xsIiyUcELipWU4WwU=;
	b=PGw8o01N9jcoRQmfnP+ZoeS9HgNB1q6FOHcZJKmgTM6SnO2dBelSCiHyvByrrSDNihQRUj
	Pa0cf4D023nkzOAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3206F3EA65;
	Fri,  9 Jan 2026 09:26:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TGXGC+PJYGkWAgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 09 Jan 2026 09:26:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D22A1A0A4F; Fri,  9 Jan 2026 10:26:58 +0100 (CET)
Date: Fri, 9 Jan 2026 10:26:58 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>, 
	Christoph Hellwig <hch@infradead.org>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
	Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, gfs2@lists.linux.dev, 
	linux-doc@vger.kernel.org, v9fs@lists.linux.dev, ceph-devel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
Message-ID: <qzdy4ipzuxl3exs26tr3kd5bloyp7lrr3fqircgcxltvoprd6k@shasgtm4zncv>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <m3mywef74xhcakianlrovrnaadnhzhfqjfusulkcnyioforfml@j2xnk7dzkmv4>
 <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
X-Rspamd-Queue-Id: 649EC180007
X-Stat-Signature: 433te3sqcojq57rtp5xxp6fbrbboisfw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767950822-308403
X-HE-Meta: U2FsdGVkX1/NTNnSJAgFpQKzcZGKizKh0o0Mj8xEZ+RaZzn6z7en1aDAKtMW2P4xCGCLzKCIKqPvED0Jvb0VD2+3ERbVM1Hb1iawFId+8MZLM8gxAwSu7OoJcH1jd4ZvMes9E/fH9vaMYme+c8wFqQTEl2zgU12XMn0U2wn9QzDWSvjhs1bXuI6vogDqRzJqD/cQsZoPQCuFMzAFD+xOjXCoen43eTi9O7pEQysY8f242AXdOdIJENLFvjcuksPn4JP5o0g83uFFJjBWKjQfAyY5GlKOdY8ZMdHf1nZZ4LRQKj6tBYlgOSAnu3bR2pX2MKdEH1BIek+H5yu8zIvXUcR/Jvwoo3vJb4K9UYMKuuZSRn4L282UoIEm/ShBEIkhT7tcGsKGCGvmGstuAHUD+OYWbvtO4yoR+iyZxVUQBrCr4pBFMDaJY4zCQ7bGu31H8llE4BfEE2oJLN2PrpCxLrQa9dIr+fpdIukqTN9hHe4K7h9LTqck7/+kNOYiUNg06hH86jUHsARRNskPr3JvbuPlU6AhBUUr+5ohrvXnz61pfUQAxs27kMNl9VYNg0cQFhHCyNOHbvXFFBN/c7hqPVE5CS4+CRduhckZrRfmwz56UKcCiSIcYDMFstfsLAk0JwA/NRIPRCgUBaz0wkEZDz8uDrwlzGhNKbK1xvnLBG2F8UT6xXw4mJJeFG8d0vZDHKoUxC4I3jGGJowowmCnUQS/JeR76wxfXYRp6ThhFvGhMp41Dde5zh3dRNg/t5Qd1DhrgUp1ST8hxRGPYrWHMtI/DR2AHwbqrYhatJZjtcOJH03CGngFedYQbMfySq7EeRxbhFYVztLMCVyphtXVihVIxDGWHQRJsGSDQLaGv/OHjkgPCy3Wnma1XccY0GVIrFNUKd2KtTO13RLUlmpJuYa24XStCHdDH1k6DCvOTMOwFZJeZL9iEnoXelsS2Tc4A2POQrxKxD/12Mlxh4W
 4nAhVe+A
 Zu9lX3LW4b6ql1yl55c7TzhVhZnrNzqRgDnj3zESMyd+lcEt4kZifnZzp2SSzIv80/G/MSFEP8C7VNS36/saJlERW6x2QGHR68CUWVfYdJIr+/zxvXCPs42NloudCx2ncJf1WRe1sCPy5kJN5R7HaAODXob2JIHfNrOJZ/LGxT4b5N0HEviLzsUXs+VNRl3ZuyBGKi4IO7MSWybW1twnfQEaiJPhXi8CwHwQgmse260AZANDP2dXIJRw30z5X4Qtn2Ey0toXazXbnj4xxQiRl4GUaQ462OugwOcXr84RSw0fByPm3NtUK2e9g2Bz4+2YiHuM5hfSAls+vlDccAQG+WPjkZcNUDmtVmxDpvMODTgohXLAHewIK5RDadQdn3QGzNHIyg9F+Bk5i7c0AvSQ6VCtc2FJFvQn4kaBo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 08-01-26 13:56:57, Jeff Layton wrote:
> On Thu, 2026-01-08 at 18:40 +0100, Jan Kara wrote:
> > On Thu 08-01-26 12:12:55, Jeff Layton wrote:
> > > Yesterday, I sent patches to fix how directory delegation support is
> > > handled on filesystems where the should be disabled [1]. That set is
> > > appropriate for v6.19. For v7.0, I want to make lease support be more
> > > opt-in, rather than opt-out:
> > > 
> > > For historical reasons, when ->setlease() file_operation is set to NULL,
> > > the default is to use the kernel-internal lease implementation. This
> > > means that if you want to disable them, you need to explicitly set the
> > > ->setlease() file_operation to simple_nosetlease() or the equivalent.
> > > 
> > > This has caused a number of problems over the years as some filesystems
> > > have inadvertantly allowed leases to be acquired simply by having left
> > > it set to NULL. It would be better if filesystems had to opt-in to lease
> > > support, particularly with the advent of directory delegations.
> > > 
> > > This series has sets the ->setlease() operation in a pile of existing
> > > local filesystems to generic_setlease() and then changes
> > > kernel_setlease() to return -EINVAL when the setlease() operation is not
> > > set.
> > > 
> > > With this change, new filesystems will need to explicitly set the
> > > ->setlease() operations in order to provide lease and delegation
> > > support.
> > > 
> > > I mainly focused on filesystems that are NFS exportable, since NFS and
> > > SMB are the main users of file leases, and they tend to end up exporting
> > > the same filesystem types. Let me know if I've missed any.
> > 
> > So, what about kernfs and fuse? They seem to be exportable and don't have
> > .setlease set...
> > 
> 
> Yes, FUSE needs this too. I'll add a patch for that.
> 
> As far as kernfs goes: AIUI, that's basically what sysfs and resctrl
> are built on. Do we really expect people to set leases there?
> 
> I guess it's technically a regression since you could set them on those
> sorts of files earlier, but people don't usually export kernfs based
> filesystems via NFS or SMB, and that seems like something that could be
> used to make mischief.

I agree exporting kernfs based filesystem doesn't make a huge amount of
sense.

> AFAICT, kernfs_export_ops is mostly to support open_by_handle_at(). See
> commit aa8188253474 ("kernfs: add exportfs operations").
> 
> One idea: we could add a wrapper around generic_setlease() for
> filesystems like this that will do a WARN_ONCE() and then call
> generic_setlease(). That would keep leases working on them but we might
> get some reports that would tell us who's setting leases on these files
> and why.

Yeah, this makes sense at least for some transition period so that we
faster learn if our judgement about sane / insane lease use was wrong.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

