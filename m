Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D169CD37E4C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 15:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43D856B0005; Wed, 14 Jan 2026 10:26:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411A76B0088; Wed, 14 Jan 2026 10:26:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314876B0089; Wed, 14 Jan 2026 10:26:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4F86B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:26:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCD5B140548
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:26:24 +0000 (UTC)
X-FDA: 84330945888.30.8E0D2CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 49A0F10000C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:26:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UuxL49Up;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768404383; a=rsa-sha256;
	cv=none;
	b=mIXBAfFUjsZJkner4XW/GR2B2GKMK0ICh5Pi2dh+9tcP/KAWzarC0fGov5WvZh8USe7vqm
	PMBlTaukdU5kTkVZ4t0WjEImiLpeJg5SmT/kAu1QZf9X8Up/9fq/Ys4C1Fb7OyRfF36IhA
	MC+WXyZb1d3QrThM9v9tRTp+2G5e+rw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UuxL49Up;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768404383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvsikAIbl+cEhR2X3kc5+cU8s2nM+gaqydUds7eRyR4=;
	b=5PI/GOEq9OhitgtmOOcH1FjA3uUz6YCpc081ZxWvD9j5VufzvKGWL726hFQedDhtzmoX9/
	U4ZfnVvl87sXmZQnr2MMiXE6x0ZL4ZxnZ0WpLESKlWh0DibNM4k3x+g51GloRsA3kAGbvI
	vLjKA4ZOGXZZ2wE/j6k79iuDgQMhr8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DA7E6000A;
	Wed, 14 Jan 2026 15:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C84C4CEF7;
	Wed, 14 Jan 2026 15:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768404382;
	bh=TJ8HYpqwvKEu5WPBUCmrbZTfwhtmNo45dUDkhLnlTis=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UuxL49UpINmE3bPn9I7g1qy3O1U7lEuEQBs6NY4FtevlZRrg+jir4TUf2JL5Et6S/
	 Wo3Rq7erhsD0wDrAjS0fAwtu2sdM1Ly6eiM6YJ56Efjw7Aqq9ho5u2uVmIb6CLm0qm
	 DbkRjtkwVuzFS/3LLXXupO+XD87WN1YxMglF8PVz6z7zZF37PIEsEJLTAjeNY90c2+
	 Is57pvmqsqoUYUcAtHG3VWlWJm+iZsfwi7Dpki4E16iuG5isE531rPd5Kr9GSqblBC
	 cmcig5bet6G0LrdDdcPVQ26rluu7tPoRJcI1jAeMRFhOX4YrFqzlg3FxIBJw/nlkLZ
	 OyWqiHYjHhBJQ==
Date: Wed, 14 Jan 2026 16:26:03 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Amir Goldstein <amir73il@gmail.com>, Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
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
	Phillip Lougher <phillip@squashfs.org.uk>, Carlos Maiolino <cem@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
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
Message-ID: <20260114-blamabel-hanfernte-ea1345885b46@brauner>
References: <ec78bf021fa1f6243798945943541ba171e337e7.camel@kernel.org>
 <cb5d2da6-2090-4639-ad96-138342bba56d@oracle.com>
 <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
 <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
 <aWZcoyQLvbJKUxDU@infradead.org>
 <ce418800f06aa61a7f47f0d19394988f87a3da07.camel@kernel.org>
 <aWc3mwBNs8LNFN4W@infradead.org>
 <CAOQ4uxhMjitW_DC9WK9eku51gE1Ft+ENhD=qq3uehwrHO=RByA@mail.gmail.com>
 <aWeUv2UUJ_NdgozS@infradead.org>
 <c40862cd65a059ad45fa88f5473722ea5c5f70a5.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c40862cd65a059ad45fa88f5473722ea5c5f70a5.camel@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 49A0F10000C
X-Stat-Signature: 1zzp6tfb6jp6imhz6ghh9gfkzmw9ezs4
X-Rspam-User: 
X-HE-Tag: 1768404383-832834
X-HE-Meta: U2FsdGVkX1/l8DqWAuSM1dAegZyJYBBA6JVoJnd9QDPQEvaUhazZuXGyKGyoiXfyUMesrm/QTp4s261a+H1JA3T+7YXfaba0SHj7mOW7LPy3+Bdt8VcrA6tYZCCsJT1AewE50/cg473gGYuANi5z1PQGnzI+ksQ6ckr5IQ8EbEHLlkKVYWJwmLg8qzBWMhFcgjaD2jxTUlb6GMi89fcHG/reBVUbDPbxL01TznsWWRwaBjLCkK75wKwwX0LyhEGT6vzUM4iByaAfMTsTJC1/OZeTbP6+XpDrZ7INR2nLCUVtOx0n4VymV6hISBi0PEolvtEYeWQdL5blTEEeJX8PqIdNUb3cfJOPRI7RSaH14bAtfRYD6uJ0wz2HWShuyGPCBqoBHZNu6gZUUkOoqz3jjOCm/oE7D8uieI2Nrd28yH4SyA+e4ktFZz/FfY2i9/J6e/jPQ/jo4hXtUncGlPnfgX7B/DxM82k99oLMbIOarCLVS7yDHgaYlJ4mrs42hFCj1EVVrxaERUqLhgs9ZTM2mb7dDeJUjFfFuZ0tpQD2FJS3JUUhP/qw2RgwOK342EN8O8D1Eur1cYDW00WgyTdkgygrOQwTz415jtx6CxsxoNsC4ntjoA8iFGJnYfDAkWivf3D+oM0x55P44fk35FYTzdZKj82AyJwcolkBeSWqcYReAsX4qT8SzCNPjMedTdpHQ6NHWV+/LDzQbSv4MpvGBE9oaK/nhxO4NVEtjejfiFHLLZwazwqpV2fJLNplXu61zJ93TVN4Z+tdjINzgRyYEvcNEHB+JjanSHVwQjdmUj340gdrB3USSUzyRpsGmA6CcynRXXIT06TR0a0O6NZOHyDOa4N23Cz0zlGhLNnuPqBX2uXp6TnCpoV1+MKQ2kRZOEWlmFnW255LEtUuj0SogAx9jiOHlyeTCL+OdZlGTzrH5ka4vFi3esd/4TQzl6ZLez26ywBXJQY62iA15Sr
 e0Fuu3l4
 0Z6NVNDX91LVyI7y4MiNQ8aKQ6qAjP/dnBzA6E0B95CQeJcUnT4hxjozC9RgVHA4zulP6BNAaWbCGmPxx0BjygD+1LhT65pUJfis7wmw5kfv4O+7qVKoREXqm1C+FKxUECJFZY/ZKvfPyJfDhN9iQJMBz+YaYOBJlMdqLjXYGI4aqo7WJrxnAMCIuUzeWxUcmWZahj2uRdwk5d2+Rk8twsAPRj9PKq9ALSdcn8remz4swcqksf5LCG2Gze3Gex4cbdHvNgBiva0OA1mrjw2W+cX9EBp1KOWTirW7LxEm7Q5TiHwX+CGphzFT16pSNf/Usg1vnHgIYxNw8OD39iAJUAQBRSUnf7/ki27IxjZlSGNL++OpNqMOX3KcvRzMsIazn4LSSbWBvlxLT06wI/byhLGxlpkf+/Yk/DcZP47TkI7iDbaGG9yT/GZRb3ptRryf3xkusnJWpH4Ekgns=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 08:41:16AM -0500, Jeff Layton wrote:
> On Wed, 2026-01-14 at 05:06 -0800, Christoph Hellwig wrote:
> > On Wed, Jan 14, 2026 at 10:34:04AM +0100, Amir Goldstein wrote:
> > > On Wed, Jan 14, 2026 at 7:28 AM Christoph Hellwig <hch@infradead.org> wrote:
> > > > 
> > > > On Tue, Jan 13, 2026 at 12:06:42PM -0500, Jeff Layton wrote:
> > > > > Fair point, but it's not that hard to conceive of a situation where
> > > > > someone inadvertantly exports cgroupfs or some similar filesystem:
> > > > 
> > > > Sure.  But how is this worse than accidentally exporting private data
> > > > or any other misconfiguration?
> > > > 
> > > 
> > > My POV is that it is less about security (as your question implies), and
> > > more about correctness.
> > 
> > I was just replying to Jeff.
> > 
> > > The special thing about NFS export, as opposed to, say, ksmbd, is
> > > open by file handle, IOW, the export_operations.
> > > 
> > > I perceive this as a very strange and undesired situation when NFS
> > > file handles do not behave as persistent file handles.
> > 
> > That is not just very strange, but actually broken (discounting the
> > obscure volatile file handles features not implemented in Linux NFS
> > and NFSD).  And the export ops always worked under the assumption
> > that these file handles are indeed persistent.  If they're not we
> > do have a problem.
> > 
> > > 
> > > cgroupfs, pidfs, nsfs, all gained open_by_handle_at() capability for
> > > a known reason, which was NOT NFS export.
> > > 
> > > If the author of open_by_handle_at() support (i.e. brauner) does not
> > > wish to imply that those fs should be exported to NFS, why object?
> > 
> > Because "want to export" is a stupid category.
> > 
> > OTOH "NFS exporting doesn't actually properly work because someone
> > overloaded export_ops with different semantics" is a valid category.
> > 
> 
> cgroupfs definitely doesn't behave as expected when exported via NFS.
> The files aren't readable, at least. I'd also be surprised if the
> filehandles were stable across a reboot, which is sort of necessary for

They aren't and it's not desirable.

