Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E0ED26D9B
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 09:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421BD6B0088; Mon, 12 Jan 2026 04:56:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB966B0089; Mon, 12 Jan 2026 04:56:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3E06B008A; Mon, 12 Jan 2026 04:56:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5186B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:56:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0548C1FE5
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:56:42 +0000 (UTC)
X-FDA: 84322857444.06.E734EB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0F380C0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:56:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gEU9mwaI;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768211801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQ0wZqwdWPtiS8p4pbW8LzccPPAucI4yXbRXcC3iXZI=;
	b=No1qOEjHRfriJTn+eiNvhzmMu5uM9wFYAIHTzetN57gl2SACqUEnqBy7QwcLq/lDQXfeK9
	IJgMuXbqCvkCeC3zBEWcINgcteWEv5I7GQivI6YGPWieuVOUHuFOUJcG1F8NoGkUYsTuKH
	+430wveuwTLxfCqAqXX7N5wISApllgA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gEU9mwaI;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768211801; a=rsa-sha256;
	cv=none;
	b=DODzHpKtBFEnT8tTFAgIDxD0uTTig1ZzrtdvcVvvDvtiQA96uZ/zOfQiuACNucBoQpC5RX
	j0FBHm9aPEpWLQgms5mI/GvH/jpV6iDR28E5JT4JYFzmqINqS+eA5Q/TgriB93os0yUxlS
	gTs0bXuw9j49VOEwMiB2kADbPBBQWAI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D58160179;
	Mon, 12 Jan 2026 09:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E7DC116D0;
	Mon, 12 Jan 2026 09:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768211800;
	bh=7FithyIBKaoedpqmHqroS7296muzq9qFftbtMNAIURw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEU9mwaIMduY/7UbDRfY3dCfNhfrteaHYYuLXyRnnRx/QJgC20lljrEWUMS7U6O0R
	 FC4KxbfeMIzSr1rRikavC/N+gC8ZfUxStYxTRJJhtfOpS2cGLgj7zxDin23MW6Wb7P
	 1GOMC1no3G/npgBBoc6dk10UcMEW7fSBM4p03vkd1kqbUw8Lw6VvU4ZPPkKi6WPwPs
	 cFsx7BjBlanMei3Mx7O56x77krT1lDMI8Q5IBx6rppzFEkL7VX/wsOGT2lTjE9XE60
	 DtV+U34LS4bSOB3RmY3uhoDoP3WLijr7CMYxfWHp68KquGlaW4jVxNHX1fQyEK5DDo
	 mEN7+/Mr4XdZg==
From: Christian Brauner <brauner@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Christoph Hellwig <hch@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Anders Larsen <al@alarsen.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <clm@fb.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Jan Kara <jack@suse.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Carlos Maiolino <cem@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Hans de Goede <hansg@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org,
	jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org,
	ntfs3@lists.linux.dev,
	ocfs2-devel@lists.linux.dev,
	devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	gfs2@lists.linux.dev,
	linux-doc@vger.kernel.org,
	v9fs@lists.linux.dev,
	ceph-devel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to lease support
Date: Mon, 12 Jan 2026 10:56:12 +0100
Message-ID: <20260112-wolldecke-fernhalten-1ed186b0d6d4@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=3741; i=brauner@kernel.org; h=from:subject:message-id; bh=7FithyIBKaoedpqmHqroS7296muzq9qFftbtMNAIURw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSmHHURP88sMJN9ukDhRhXbqQequdlWvjZyfBfLe1DV5 5jhhU9qHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABcxZfifcM15deTeLVM3FDGZ slyxOp2V1fLaePb0rF9Nh78+em/0gOF/0ZzNd4vlgpU/arScCRCctkFYad0Mv4pHyyuf8rps+VT FBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9dexeydft7mk6ydutzyne48gdpm7wm88
X-Rspamd-Queue-Id: 0F380C0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768211800-487263
X-HE-Meta: U2FsdGVkX18xiZiNM09PUCpWvtri+vZ7nIUxq4eii4WPBRyG2jaRrcjjKItQK81y9CcsartMeOgXV0MV8d+YLyc3gN+lxXJLzoOTtsgPvuCERMdGkmVn9LVeZnP+M+kO0rTBiSwrBAo3uMSPqc7SRfvmSAZs9FAEASXzkS2ugvuEnkAMPq1CoNnZ4yDrNRC6Yx4EGqzkm7bhkYpNYa0XlIMwm06nhVjBRcyiaJDwk7tzUl5xTViq7Ioo1ZtZGouyIGntrmJDU/zjXgjWZXRYAhSbnhN7PVhggZrFwQTNt4BYGCU6Cgi6aCVx0YIZzfR8cq2SdhuhDMFjd4uaSklx3gFMQ9aAaT6CUO8x6uIPOEfKrByfxXGS8wXmd89WQcc5k96G0i6Ey+WNsG2cTG4MW+F6RQllr7hCu47VVomBUVi6DlPY/clNkXzXnKQz2EDiNA0LRzVriIjoDloc2hOJeMDP2TXBSXAANiwC9GQbzQc6WygsrbhM+M4A1N8cQxSumLk2xuMy2XJssITooxFyBS0woVtTLHzqjUhvha5gXCYr1yvmAxODbVlgD7irJ1CxaEwVs2td7TvSEkFPkdG/+MPmUmkHwnQflwloWZPM3RirCKdxHpbHWe3EQ34IRD2dUlHL/MSFE1GJZgjxxIoFfTCQHn4T81HkbsT8tPhatxfRgeiiFFLHnYNBmy8kcsbLFqNGnr5Ww9Tcd4+SnLkGkwFASnM3/llikhw7ovtipgiN3QSA+d7TjV/AJAecw51aBXCaSY/nYlpbGOP8qj1w1n4lDC7lxEra9QQg19GiLoTakC426Ve8PLanYeHq44Fn1a6BUsd8rzIBRCzSYwj2UbW/VfYlb50lLGecPSnb+6NfshZFwCj1Lhi6yPzSoHy8POZA+gbCWR6AXP1lvmASUxTRf+h8R5lnzaZwZJKVqh5/1oYKiDohUhNLT0nwXRzdsuVmBc2fN+/8zP3KxbB
 UjiSbSkG
 AG5VqQClGnjs2ZLORftU8Qb5sOJ57MlwwH34eutdWA6y4Iq1mr5yUdiUFRkj3fXB0y44/CfwzPfHoj40QFVAPAyp9nP0oY+yr8rgRkuRJjvQipP/fUw/DAwRiJLo7kkLrTDKg0zX9PhT1UnYpUC0ACjFdw9nPvSPNMzptoGsZ4V6c2XcEkIlXuRh02Ss21siL2y9TZQF1LNIv+/HsBiLrLW1b2uGxtNyaCCBe+pZUU/w77aM0Yzz+Ml2K12Sg8PzOjNNoMZbGmJ73UHAyuyaMLtVwI146zYzmRiUNUE8Ciry+J1uqo0hp6226cY5LqV6W+abw1LsWyOCX7+ialr7JNXjUXPd9iP29mlfHYiUVNtJ46dM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 08 Jan 2026 12:12:55 -0500, Jeff Layton wrote:
> Yesterday, I sent patches to fix how directory delegation support is
> handled on filesystems where the should be disabled [1]. That set is
> appropriate for v6.19. For v7.0, I want to make lease support be more
> opt-in, rather than opt-out:
> 
> For historical reasons, when ->setlease() file_operation is set to NULL,
> the default is to use the kernel-internal lease implementation. This
> means that if you want to disable them, you need to explicitly set the
> ->setlease() file_operation to simple_nosetlease() or the equivalent.
> 
> [...]

Applied to the vfs-7.0.leases branch of the vfs/vfs.git tree.
Patches in the vfs-7.0.leases branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.0.leases

[01/24] fs: add setlease to generic_ro_fops and read-only filesystem directory operations
        https://git.kernel.org/vfs/vfs/c/ca4388bf1d9e
[02/24] affs: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/663cdef61a27
[03/24] btrfs: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/f9688474e413
[04/24] erofs: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/f8902d3df893
[05/24] ext2: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/ccdc2e0569f5
[06/24] ext4: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/20747a2a29c6
[07/24] exfat: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/b8ca02667552
[08/24] f2fs: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/9e2ac6ddb397
[09/24] fat: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/a9acc8422ffb
[10/24] gfs2: add a setlease file operation
        https://git.kernel.org/vfs/vfs/c/3b514c333390
[11/24] jffs2: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/c275e6e7c085
[12/24] jfs: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/7dd596bb35e5
[13/24] nilfs2: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/f46bb13dc5d9
[14/24] ntfs3: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/6aaa1d6337b5
[15/24] ocfs2: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/f15d3150279d
[16/24] orangefs: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/136b43aa4b16
[17/24] overlayfs: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/94a3f60af5dc
[18/24] squashfs: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/dfd8676efe43
[19/24] tmpfs: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/f5a3446be277
[20/24] udf: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/dbe8d57d1483
[21/24] ufs: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/545b4144d804
[22/24] xfs: add setlease file operation
        https://git.kernel.org/vfs/vfs/c/6163b5da2f5e
[23/24] filelock: default to returning -EINVAL when ->setlease operation is NULL
        https://git.kernel.org/vfs/vfs/c/2b10994be716
[24/24] fs: remove simple_nosetlease()
        https://git.kernel.org/vfs/vfs/c/51e49111c00b

