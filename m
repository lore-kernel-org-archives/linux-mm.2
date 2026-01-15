Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C724D46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58C66B0092; Thu, 15 Jan 2026 12:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16306B0093; Thu, 15 Jan 2026 12:48:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2596B0095; Thu, 15 Jan 2026 12:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7ED476B0092
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:48:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A163B9792
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:05 +0000 (UTC)
X-FDA: 84334931730.11.C3CD2FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6AC4FA0009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sv2wZs8W;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vvXSkSgvuvBAdCYEw/mOnChggvFl3hZbp3O+rIZGmKs=;
	b=xbNRQqfVystp678U5tgpEbsK3UDHKa8IZ52MuoZaLRySJwA9T3YfFaLNg9SxKOAiHygEUh
	A6hYQUZG7n1kUKcLe/9CQuKRwUEkkeNaY4/yIWMQVsLFAk5vt+2b5pe4xsmPrMxHzGjD8g
	XsMw9tyupUltWllGSd1k3c3B8RDohhc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499283; a=rsa-sha256;
	cv=none;
	b=MFg9AVpuiftEOLnw8SU2IVis57WYhHzMHpauzgPpyM47sd61MNZ4YVLrjdKB8seu+P0UN3
	0yfTbgM8hcQYgIVoRvRUUgsLzRsUiKQ3DK3/eUsSvXEOKJi6xRxovPUZ+66TjCwe1ETXDc
	1zvuzUrj92MQ68Rgw/ob1cusZCtiAu0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sv2wZs8W;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B75441B3A;
	Thu, 15 Jan 2026 17:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A44C16AAE;
	Thu, 15 Jan 2026 17:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499282;
	bh=Jgrg+43s0ldgv37NKbEktTlLcn8JlZ4Z62/aDsJl2fE=;
	h=From:Subject:Date:To:Cc:From;
	b=sv2wZs8WpKeI0wpddsdCzx5FPuJfiv0htyo+0abzJrCCFK9q4146ZE28BG441jorg
	 Qo1tIee7N/1MnShJaAey62z4lfLsmhIXMLkZMLSEMlmEhDwdr2qsSYaFrVZPxb77cF
	 i3aSCJl0gIo+M7JBkTxdAg7VvCpYnqzbG7R2Ohvdin1j12CbILNcI3w/DNWL7f9jbe
	 DBukUrRoDDoNluFnmhgrGDxPlIkvSUMcrjLUpjjJ1T7VqZOaz0YENa8tKyKu6CaX47
	 KOmCoEsEsYyGz5wli5gj5MnM7JWLaAPtkHWHG4sSZOBoGuAC5psY5ECRaP4FTl6A5n
	 5/8prxsy2NgBw==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 00/29] fs: require filesystems to explicitly opt-in to nfsd
 export support
Date: Thu, 15 Jan 2026 12:47:31 -0500
Message-Id: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqAIBBA0avErBMcyaKuEi0kx5qNhhMRiHdPW
 r7F/wWEMpPA0hXI9LBwig3Yd7CfLh6k2DeD0WbUiIOi90r5DqJiEK/QWLR6MjS7GVpzZQr8/r9
 1q/UDI1yMc18AAAA=
X-Change-ID: 20260114-exportfs-nfsd-12515072e9a9
To: Christian Brauner <brauner@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Tom Talpey <tom@talpey.com>, Amir Goldstein <amir73il@gmail.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, 
 Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
 Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Dave Kleikamp <shaggy@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
 Andreas Gruenbacher <agruenba@redhat.com>, 
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
 ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
 linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
 linux-f2fs-devel@lists.sourceforge.net, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4009; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Jgrg+43s0ldgv37NKbEktTlLcn8JlZ4Z62/aDsJl2fE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaSg9V9dGf/ZUraP4b1Pq5RtyBLPKPHN6qkaxn
 8S9nULay2GJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoPQAKCRAADmhBGVaC
 FU2HEACr1dom+IcUewiIOnk7xEbGWbqcKSzh/u8bfD7LubFnaY7GNt5n6p3PgjmIFAgE/Lfk2v+
 Do5G648LuI9AgNBffpq3Rou0EGw9+wxjXyRaSItdEWDshxbLnMS5D2dtmXeB4x2mF6Xo8wPho9c
 ncOUEwjZL61T/UOLGxpSOojluUsBXenixeUCTgPYWeDSKZSd1PrbfIIvNT3wwmmIpQAv0lasork
 Zl4qe+BiG1G0IPtketcJGFYIgXNp76Hnll+P8/EqVrDG+4nPn8MGAy3xqMQyq4+dCzENDy0DmS3
 AJMlGepQMU/y0tAmS4R1R2P27jpCMwpBj8HhdNo0JThYFgmCYeGwPxsTOTNG8XmrWn4zye1BAl9
 Oz/kXfQnSFwMzweZ9J7fT16IxYVpb12aXvYdwcnZ+IE/Suh66Nx8n52d4tuSwNkKYQf6d05G1bU
 I+lA7kAnXjIh/p4o4pNnALEld2Rn49OAx/yxtN5VOYrjpBIK6yRyYTXjz0PnCRFsn3V65+xhhPM
 CJTSVK9ZzU4nspmDSK5hdCvs1pnGqYR9dLF7QV60eUBpiDYnfsiOG+KZmrsLuWOd2/7/8V8giqf
 SBbuLOXJmeBQ1IbyaaZbzwsaK+7PAPY92+HTJ8jsZ6+vQhAXLJ40Y1ug6UAG1bGirhSbW+Ru3JH
 SgoO6jBDoISNHpA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6AC4FA0009
X-Rspam-User: 
X-Stat-Signature: 3ou8wwfj9dw4t86f6gtxzgnyhiijgnqr
X-HE-Tag: 1768499283-270226
X-HE-Meta: U2FsdGVkX1/CnZgkgvcckA0Puj6svGrM/dFkZfhIKtwHPwFVxUigI93j7Fn19Bf5TXg/OoFTWmbmFnYZhxgMbA75UuomC/zBf+I6m2uuLd/RZr82xgfCnKDJZHUEAcdSFHHvNONIK9vezQYd+GZV4r+tvMr8vBbDfk+IT//93KBOtf6yv7bpL8DsYGS/VWd+g3Sq+bGj68cIwjxc3mMUlhJ7ZuOHW7KNLkbuuNqBRWfduLfYwVg4NuTqq+pahdRnWq2vxGjRsVwz1p7a0pE9VSlC2rTa76Xrdru8VRhUlHKB+/AZNG2ZeuXzk+98aMC3Dh4y0wi8N+V4rj3ffxtP0DPkmkHFUHDCI47KHBOE6at1BZ5tv3xCjt4LQfuaogXca45hn6HOwmtzDJVpvLSWbevntMJZE4Pb+nfvbWwOsXFrxcxUNJiOJ2cFz8mZnpsTyXGFfitfckOAUr6K9hQkjMj9wQoeT9XDSgKws8u5OAH0JMSPVVoxuoaNgeYSGlSfLRIi5H/0WEAStzOwK4QtyDK5GbQBgf8P79v/HONdRdxB2jEt2oGvTZoBNcZI163vV5+JquAHNjfEX+pirB7pqtM7Y+0GegJKbvgjWou+4YCkxMklnk8txWgXYINbJVhANwrcn7bARs9O1EUbd9h7JlVobmk5K6pxIitfAAdinEZt8JY3FQpAxWj4zmxmAsQoFS2udHLSjunK0QNCRsUJMQvaRF69/OasjWy5UfzVEGTNrjuak47uTNEbrh5t2daCCpG5DIypyMbmvxPV1dVDjVuaXueaSp6nQCvm0jZx99jjR2Ko4wN0w18gCu6O6CKCbdQpqhjI4e+a3upxQk7ry/8MNQ7ZhL+E/CY7KOr0Za4T0IH27VsZCTKzpTDTeaGN5WkXeiM0kfAy4uWZ2hI8iT0mCTYtBEAH0o6vy5GnrBSzKevMZdnC2dGtQPQVjs5W/xKwXW5dvadec1Ci+X3
 8JSwYetn
 8Ps0QDq0xdu+yf+sRqV4hRiiREBfZyGNFnajpGl/I6kD9FC19LgEbQ0DOCUNOpqpHtQPyB8POyZouN/QSVsFn8m+6KDvkpXVou9K80Okag2YFScZO+5sDS4P4HlB7i484cz+dnNExbKhSUhJnGjcsNG+1+Se33S2/ZFPrGApOBGU6EJI3cL7QDfNcq9pKLfqSw0ada9WcenK0RishYR6JrqTFoCm8HRt9eZS1YpfmG2UAm0ALD9kUns9+q03+Qrl6QAo2DpNLOJL+GUv2ilbR6p4ZxQ8+V9DEuBJM02dOIVNcvpraKw35q3YgNnfbjyilr3kycEyazdLYY9b6cKqd99u3fRzqlN2es6rO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In recent years, a number of filesystems that can't present stable
filehandles have grown struct export_operations. They've mostly done
this for local use-cases (enabling open_by_handle_at() and the like).
Unfortunately, having export_operations is generally sufficient to make
a filesystem be considered exportable via nfsd, but that requires that
the server present stable filehandles.

This patchset declares a new EXPORT_OP_STABLE_HANDLES flag, adds it to
all of the filesystems that have stable filehandles, and then adds a
check in nfsd to ensure that that flag is set for any filesystem to
which it has been presented a handle. When a filesystem doesn't have
this flag, it will treat the filehandle as stale.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Jeff Layton (29):
      exportfs: add new EXPORT_OP_STABLE_HANDLES flag
      tmpfs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      ext4: add EXPORT_OP_STABLE_HANDLES flag to export operations
      ext2: add EXPORT_OP_STABLE_HANDLES flag to export operations
      erofs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      efs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      xfs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      ceph: add EXPORT_OP_STABLE_HANDLES flag to export operations
      btrfs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      befs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      ufs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      udf: add EXPORT_OP_STABLE_HANDLES flag to export operations
      affs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      squashfs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      smb/client: add EXPORT_OP_STABLE_HANDLES flag to export operations
      ovl: add EXPORT_OP_STABLE_HANDLES flag to export operations
      orangefs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      ocfs2: add EXPORT_OP_STABLE_HANDLES flag to export operations
      ntfs3: add EXPORT_OP_STABLE_HANDLES flag to export operations
      nilfs2: add EXPORT_OP_STABLE_HANDLES flag to export operations
      nfs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      jfs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      jffs2: add EXPORT_OP_STABLE_HANDLES flag to export operations
      isofs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      gfs2: add EXPORT_OP_STABLE_HANDLES flag to export operations
      fuse: add EXPORT_OP_STABLE_HANDLES flag to export operations
      fat: add EXPORT_OP_STABLE_HANDLES flag to export operations
      f2fs: add EXPORT_OP_STABLE_HANDLES flag to export operations
      nfsd: only allow filesystems that set EXPORT_OP_STABLE_HANDLES

 fs/affs/namei.c          |  1 +
 fs/befs/linuxvfs.c       |  1 +
 fs/btrfs/export.c        |  1 +
 fs/ceph/export.c         |  1 +
 fs/efs/super.c           |  1 +
 fs/erofs/super.c         |  1 +
 fs/ext2/super.c          |  1 +
 fs/ext4/super.c          |  1 +
 fs/f2fs/super.c          |  1 +
 fs/fat/nfs.c             |  2 ++
 fs/fuse/inode.c          |  2 ++
 fs/gfs2/export.c         |  1 +
 fs/isofs/export.c        |  1 +
 fs/jffs2/super.c         |  1 +
 fs/jfs/super.c           |  1 +
 fs/nfs/export.c          |  3 ++-
 fs/nfsd/nfsfh.c          |  4 ++++
 fs/nilfs2/namei.c        |  1 +
 fs/ntfs3/super.c         |  1 +
 fs/ocfs2/export.c        |  1 +
 fs/orangefs/super.c      |  1 +
 fs/overlayfs/export.c    |  2 ++
 fs/smb/client/export.c   |  1 +
 fs/squashfs/export.c     |  3 ++-
 fs/udf/namei.c           |  1 +
 fs/ufs/super.c           |  1 +
 fs/xfs/xfs_export.c      |  1 +
 include/linux/exportfs.h | 16 +++++++++-------
 mm/shmem.c               |  1 +
 29 files changed, 45 insertions(+), 9 deletions(-)
---
base-commit: c537e12daeecaecdcd322c56a5f70659d2de7bde
change-id: 20260114-exportfs-nfsd-12515072e9a9

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>


