Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE99ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:05:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23E066B0096; Wed, 27 May 2026 08:05:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EEC36B0099; Wed, 27 May 2026 08:05:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B62D6B009D; Wed, 27 May 2026 08:05:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB9EC6B0096
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:05:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ABD7A1A0500
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:05:15 +0000 (UTC)
X-FDA: 84813069390.19.FE0B7AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DF3B2C0007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:05:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEBSWLta;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779883513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSe/p8m92m4kv6gkSLjHZwhNrgydZHmT4N7lsMHBvQU=;
	b=pZ3jFzIOxa9IhCCoLZd/5gffueF+xwg33oOQNYZs//1JuTSMJoJ7p+eybnHLRWHF9Ad7S3
	IFCfDaMlZDYVo2y8fg9rJJPJmWe9RD21Od8UgxGlGtpKVUbVXQzGuTQO8mGxH/H6J01rzv
	QyTX5a3HosZyUEYssmjjdofp1wmRvK8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEBSWLta;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779883513; a=rsa-sha256;
	cv=none;
	b=e3hg0eNApuCqhu2BI/I08+Ool0ALKcZqNmHD/4H97dZXzV8hxSMignIS/kRWyUQSh9GPhj
	awguWoICqi2eRpQULM38ir3hmEKAsn3iZmv8WekpGjNV7pxP9hhwXISYHFw8dkVKGFH3hB
	ujVlCCA6K+cJ+7lZWV/M1L+fM7bIA/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4685060132;
	Wed, 27 May 2026 12:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDD71F000E9;
	Wed, 27 May 2026 12:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779883513;
	bh=dSe/p8m92m4kv6gkSLjHZwhNrgydZHmT4N7lsMHBvQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEBSWLtaZIuoMiK58mLh0h3+0FMG9IjpSp3cijZXDpJUAI2yAuoxrOkYksYtwqUoV
	 ayrNBjVdYBsJ4uUBTaqARidUay+v6Iy/CXc5HwTbfTj+cZz3gpJNfCh6IVruk0zHYF
	 ZMntdi8fdcDrJhOFuIWjUHPPknUkGwpcLFAsmm4+YXJKKnMKVMpMTi2stdGvqVafTj
	 pgTEobe+ZtvrgggQFNadI7tE88JKdrrWmLHG+tdQ4E1+eKi6k1MUT6QXDFhBYz1O0h
	 fWBhWkWeVexTDXhD9chgA9VhUR8xEY5v3IqDHj0K+ZGhAakGALO0saJdKMeDQz9zTW
	 cTIuDPpg54pAA==
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Dave Kleikamp <shaggy@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Kees Cook <kees@kernel.org>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-nilfs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	linux-ext4@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/17] fs: replace __get_free_pages() call with kmalloc()
Date: Wed, 27 May 2026 14:05:00 +0200
Message-ID: <20260527-anachronismus-waagrecht-abgibt-77744a201ada@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=2952; i=brauner@kernel.org; h=from:subject:message-id; bh=7rQ2H903AAvQ6IZQAXl+cCdxot1XbPFMx/ZvOX+8vrc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSJ3X1n8TZN9+8lI6kCEx+Ra2rJdjqm/rwVB6c+tFmke vLSg57+jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkUzGL4H/Wc/8X5Rv71Hhe/ LJ41e+PUnsiQ20n3F3Eov1G/e8HpkTgjw6ra1Vf7Iu73sXftPit++IHYnemLJ5iqnCmtzdAtv8p owwQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: sdsiog3fmx5nssq73qqkdom436oey18k
X-Rspam-User: 
X-Rspamd-Queue-Id: DF3B2C0007
X-HE-Tag: 1779883513-429008
X-HE-Meta: U2FsdGVkX1/ycW+eTMrVDKA+lueGjt626O/DViY5TrKcIzL3OCxV1wn9KZuuecDw3Sm0jbDwF6ADB3DuBorQzm4nE/7jmpj8RVkGYjfom34b4MyeA/owZpbVg8n9WgF8ZTA+1pWkSiUeh1GNppQVswHTTFPdgueCVCepqt3bLBBGLJoHHH7/UfDJbZ4JRzNGaalzP4JInrcKjZPMaWAY219MadXBXCxXmg1TWzP3duyzyooQriz2CkPyA3yxw2gz6DNc9EpSMPwshaaHao3U743cRQFWWT8zJjjgRgqA6vNoygH0lTb6R1byc20EjQFu5u8CFrpnhmrDB5LL4+oaN0+46Ugv94MUo9oaxETzJvArbg1y9Crd/SDlZRr+3yBv3sEgO1PSANtLKZ5QNNSECFM1NsSlryUyvuMgNUXjbQD5GayENzD/AWXoZM0Z72I/hgPblZ9XZvRvMkxcefr3YXW8kPxeVFfhf0c7lLjRiIePaTuitV1OfAGWpxbDKRFIYBWeyk4nrSbm74jq9JjJIaMDP1fsX42x3PrE6HUVeHnQNmEtVO/1bGF51iRoAkK8s+KkhdJ6BjAnbnMjcH157aRPALsXEhe5oRB39U7jX2YYCp+GY476hwO4/8BwENvqFlZGDSgNwkh041Z9osCZobn/oLjQ87bSlZL7nUP9DfByi6tInDvUHCx4sIC+vgbNWYiBX4b82Ng4iW3WEDdwv8xbZdB4ffHUZqv1ViPAOuLRnw2cmbWzjUY7SRhdrhAT/xJdaWHz/uPVlGwHpA9Ib7zXXVzLDUK6HSzKIQcEHLMBeOhMEM1FhZi9YSivleDisphY9WUnETbilxVFQNlFeNC40yTivAcFOvq8Icf7TJe5c0bhP/4ZvplANI9lcVeukouoKwe576aa2P9rqCmRl2TAIaoEYU/dCdDISHOB8XcjkP12XQoHKne1q3xnKn/ggcwUQK4v6Y1KHeilrOm
 GkWSfRnv
 ARgujKr8zvTje+nFMVD2Ry6ItgK5PP/uqEZKJdNeRtGyJMD8QvuHYUT0EePdM2df8H1QyETv1Z+BmICLYrubRWxfKCN3y6k2zG1aT+DlQ17Qa6X3H8IqjqhYdOban1YkN42SZ81fj1D3gNbp2/0yLd3JDOs7BAETzObRgNBvxYKaEoQCk5gb9d+MRSbG4Y80bVs62GIuydEe8s5lLD/vJTPoK12gw/vh2A3a8lmHjiAubFrMXGLoa+IFSeC3og4L+tDblT3CroqKiOtuJb+tAAolPQmAQTqKf4i1ESVqM++KkdcxQPqV1MEwP9wshbygHnGwQtMu2dulHg9TVgUtMOYQ7oO5ALRobjSsHb2YUNT+9auypQkpaweDm65xLeuv+ZEyA5+7nInJBaEeMBpkF3bL8RH+kzVUZKKtfZNUM3T3CcuRgWNkPdjvyHwtgJ5tzzhHA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 May 2026 20:54:12 +0300, Mike Rapoport (Microsoft) wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> Also in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/fs
> 
> 
> [...]

Applied to the vfs-7.2.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.misc

[01/17] quota: allocate dquot_hash with kmalloc()
        https://git.kernel.org/vfs/vfs/c/c94d1fa0af45
[02/17] proc: replace __get_free_page() with kmalloc()
        https://git.kernel.org/vfs/vfs/c/3c849e5fe1db
[03/17] ocfs2/dlm: replace __get_free_page() with kmalloc()
        https://git.kernel.org/vfs/vfs/c/40b7e5db6a25
[04/17] nilfs2: replace get_zeroed_page() with kzalloc()
        https://git.kernel.org/vfs/vfs/c/2abe95d9f56d
[05/17] NFS: replace __get_free_page() with kmalloc() in nfs_show_devname()
        https://git.kernel.org/vfs/vfs/c/75805c8f6d43
[06/17] NFS: remove unused page and page2 in nfs4_replace_transport()
        https://git.kernel.org/vfs/vfs/c/0d77bacd0eab
[07/17] NFSD: replace __get_free_page() with kmalloc() in nfsd_buffered_readdir()
        https://git.kernel.org/vfs/vfs/c/64f162f93a81
[08/17] libfs: simple_transaction_get(): replace get_zeroed_page() with kzalloc()
        https://git.kernel.org/vfs/vfs/c/5a3763a94e95
[09/17] jfs: replace __get_free_page() with kmalloc()
        https://git.kernel.org/vfs/vfs/c/d50250728dc1
[10/17] jbd2: replace __get_free_pages() with kmalloc()
        https://git.kernel.org/vfs/vfs/c/75c9377833a1
[11/17] isofs: replace __get_free_page() with kmalloc()
        https://git.kernel.org/vfs/vfs/c/95f2509040ac
[12/17] fuse: replace __get_free_page() with kmalloc()
        https://git.kernel.org/vfs/vfs/c/c78262429022
[13/17] fs/select: replace __get_free_page() with kmalloc()
        https://git.kernel.org/vfs/vfs/c/ac6aa4672cef
[14/17] fs/namespace: use __getname() to allocate mntpath buffer
        https://git.kernel.org/vfs/vfs/c/bd822134dcaf
[15/17] configfs: replace __get_free_pages() with kzalloc()
        https://git.kernel.org/vfs/vfs/c/32466534cba7
[16/17] binfmt_misc: replace __get_free_page() with kmalloc()
        https://git.kernel.org/vfs/vfs/c/df5f3ac3e999
[17/17] bfs: replace get_zeroed_page() with kzalloc()
        https://git.kernel.org/vfs/vfs/c/0a994e1ab090

