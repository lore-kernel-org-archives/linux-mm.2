Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21BDED29C41
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:27:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27F736B0273; Mon, 19 Jan 2026 11:27:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C5E6B0274; Mon, 19 Jan 2026 11:27:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104726B0275; Mon, 19 Jan 2026 11:27:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB0AA6B0273
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:27:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5DDCC14018E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:27:23 +0000 (UTC)
X-FDA: 84349243566.15.1A402A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8DAE71C000A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:27:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f237MPyH;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lW38OPk4PkfErZi0faVwbOax0ytdfzP4ktwM5gCuCJs=;
	b=KPTxbMphnTzCoSaVbXysgx9lzOZtXctmajEYethj/VnIlNnUfwd/JGfBbkoepRaXD9sYLG
	4pjrWgxHPymPUR+DSxiJfjtfp0b822a4tlivQHx+AEoDK8tjO8myJKfXUm7cgD02c0EaHI
	bWXd7l6nkIuX5HBwbn6XrEAV7lIel9Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f237MPyH;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840041; a=rsa-sha256;
	cv=none;
	b=TbgNW3ctyeohGnEFv3GkSeuR/vNKkNl5Fm/jvNta9JGeiVbzto9NWfmKu5y8WTVx55ii4f
	GdFxlbK/qb5QLg/GSE4lpEr1jYBPxnGk0B5Qr5WDekgQZThsJ9WGgCINZEtqzGlk1Lwa2c
	mYUfYoHj7cKROMGGnR1ZATvafZ1GgBc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F17860135;
	Mon, 19 Jan 2026 16:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BF7C116C6;
	Mon, 19 Jan 2026 16:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840040;
	bh=yX5wj9VHSThOjafnyKvHMJdYbGSk/5OP4p9PS/zazFw=;
	h=From:Subject:Date:To:Cc:From;
	b=f237MPyHkZbdY+WPcsLBi0kuGtUgJbV4HoKceS3Jz1Lmrv4gP0tgEIWx9faQo//X+
	 +UUjREu/69qFBMgdHch+q9bk9Ep8RKPHs/QzSabx4v5reJiL9v0kEdJGMeWqOPK39A
	 0jSEKULtL05hYKWy8N1WS+HOt5YyvBcESAtJ0ZmYc6dhEbBinazAzj9QJSGklzZ9p9
	 LbTYD833qVCL0hCJmQS+SihR6ziWecIunpgB2VxOhgkmSC9roap7mrwb5zOJntllqQ
	 se8GRkweMjAwYRoYx2aL3RsVvvEMBUqvD1Pqmz58J3HWTOMdRGmvio/OwXlAFPl4n+
	 HkGliBF8cqqKg==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 00/31] fs: require filesystems to explicitly opt-in to
 nfsd export support
Date: Mon, 19 Jan 2026 11:26:17 -0500
Message-Id: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13MQQqDMBCF4avIrJsykzZWXfUexYXEUUNLIhMJF
 vHuTYVuuvwfvG+DyOI4QlNsIJxcdMHn0KcC7NT5kZXrc4NGXSLRVfE6B1mGqPwQe0XakMGb5rq
 rIX9m4cGth/doc08uLkHeB5/ou/4k8yclUqgqrpBK5ItFe3+yeH6dg4zQ7vv+ATyiSsWrAAAA
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
 Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
 linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
 devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, 
 ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
 gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net, 
 linux-doc@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
 Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, 
 Dave Kleikamp <dave.kleikamp@oracle.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5453; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=yX5wj9VHSThOjafnyKvHMJdYbGSk/5OP4p9PS/zazFw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltSzbGzajTJvmhlV7jB47UePrPRdt3Wu5GHL
 L1B0sA8PKeJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bUgAKCRAADmhBGVaC
 FXY4D/42rFsMWqLxlGJh5AWMBxSb1l17atmfl6mxPzMfAPokDVOiTK0fNOZalTR4OcT31QZxTed
 nkOmw7Qd+RTSm3dThDf1+et1RhMguer4Bj1ll4VmaZ/poVmu4fIUqbDcyU54UE4F3/M+fsmJXJF
 3s1+tqIyC+7WzF6/x/HWQY9RkQLGkUqkteSCoXdzEDc+WnhRgXntOXZFP/HpDfxG/pkaHnd+RBz
 4lFdhCAZ/xSuv67OWqva7ifRVDMiF1E1jM7uLNP2SeE/hd0wYNuORHvkzf0PBL9T0k2Xtf89p3W
 re4QkZpVZiycpFTZTWt04k1pqWuWK0n8tjfz/V3hdvnGOrpI230p/dDpXhnTN9sdFWylM4U9ya4
 qshCtu+DBJBGHEinp1+ZpE1k5xl1aig3/uN9f7VhUaZWww3qx9qr4g5LvGXfxxoxzZ9wBjiF9KO
 N6VxYj2loIjuU0+56wmYIb9mvXWeQ3O5IJtU9xTAV91iUxWYiRU9dcBVDvwk0wF6sm/fKmizn3g
 YPMFjbuTpkp5VsApqvODwDyEo97gF8luB/qvkGPpxV0AKc1MyfjvFpPOyECG1xpqAW1/f4Iph0F
 ju2zuNnVWaPFBf5KCowY4rq8s1kCTJxt/dnIpOlxVJ6FNlp9OpxryB048OYYuKuRfAwjC8gjHz+
 qu3QGNImWfKzpxQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 8DAE71C000A
X-Stat-Signature: t3ybw4ufykfs83qhhwk56s6dtxpcrrjg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768840041-483931
X-HE-Meta: U2FsdGVkX18alEzo9wqTAV0sd5H4beHcN5sCNPBUHaVO/wfid8dQbdIZZ3BJKf0OxpEC1k2C5OFOAramV+HF8TTsK0nnJj23Gnx+znZruwY1/lNxSjU6fo7sLcJygXN1HczTKYW5D7GYgd/pitDpEpIqDCTAhVXpsEofb3UpGIY8sAHxlbV3hRN+WRTwVk48ROVaIUT91SZ7ESIucGrhv8XgOZFKnmEHS2lnWaFuRKyx2Dnk23jfEjY1PNkgJ+/xYc1u8qexmy7vRzx4+sCSXurHvXXb0qW5WI7Qw7WhvwVX1lss0gBT8bkT2SKhU2X5uFEsQErL1e1nvyAi4OX5Hc+8jIW8a9R/Po8YTrGOZTOUeYV7peU1k5w+2KkFCFkxXlt/pVZ1HLsoFlyglVrWwLVx/D1r18wg07h/BXnftAQ45ak7um0TJK2vSoZaOsUupOA/ot9j4aHoM/3RGPdDGugsmlVOIvuFOLF2kldKO7lDCCxeRcX6LeKmv3+WjfqCnmfMNZNxpAycWjRT2R+QTya4dHvrWbKlqciQLCpaiN5DTH8aSYKDDP0uSLEpsqlDcHvCz/7AM/BU7IqGeLiOw+od5Sld37g8t97quN2qXIKpGvVmuTKt+dcsogaphWBzohit1c0TQ2yVtHLK6RqesNmLhdBPKwfz8nTHi3qkHKsXEBg2mhNNPJlqpW0DyYQjflMKUbaG+RYTN76syzAJu1kDe81its1VadpvAOwchz4aQ3OrxmPc64vFvfgct1G2n38MFxFqCiGZFB27CDDjcAUr+4pyYDP8Wpfoe642qmPzP8ExeduxoKngcD3IZympqj9FI3xaPYEXdcDGvCJhGmfA8wFH4L+bUT+PlJO+Oa7xQlODZ0UCeAZFz9aadZvlrfke0XRrRTAEI1UoEBnlrhgS7KSAwebP8tsI2UJLRBMDLUN+f0cI6UOhhoAyPXfmzA6XxOf4ukLU/hcut7f
 yieE8eqT
 oE1SCvCPtqWzgJo8N8jT2GMOuOlFDXEyezmaZtgYvU+Lndpe00ar+M501sar3JldmJvWCK0j76MaubDIZxeaWhE8je4eKfSO9mZT4ecruw0Hpn2RfOH7sb8XPH1owO2zhXEXnEtqTA4YGNnP5gzYFF+wGdGbAGzVg27JapUSqqR+okj4FDr/GF90sOgOif/22MtGjpMGvapVg+HIEvnrt54o42Y4fn0qB3cvFiGZX22ENty+2nNE54K60mfGr1dqOB0R87/re4d72txcbuxrIm/NxKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset adds a flag that indicates whether the filesystem supports
stable filehandles (i.e. that they don't change over the life of the
file). It then makes any filesystem that doesn't set that flag
ineligible for nfsd export.

The main only place I found where this was an issue today is cgroupfs,
which sane people don't export anyway. So, I don't see this as
addressing a major problem that we have today. Rather, this patchset
ensures that new filesystems that are added in the future make export
eligibility via nfsd a deliberate step, rather than something they've
inadvertently enabled just by adding filehandle support.

After some lively bikeshedding on v1, I think the consensus is to stick
with EXPORT_OP_STABLE_HANDLES as the flag name. Amir is correct that
checking this in check_export() is the better place to do this, since
the filehandle can't be decoded without resolving the export first.

There are a few other fixes and cleanups, and some doc updates too.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Changes in v2:
- don't set flag in ovl_export_fid_operations or fuse_export_fid_operations
- check for flag in check_export() instead of __fh_verify()
- document missing flags in exporting.rst
- convert dprintk() messages in check_export() to static tracepoints
- Link to v1: https://lore.kernel.org/r/20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org

---
Jeff Layton (31):
      Documentation: document EXPORT_OP_NOLOCKS
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
      nfsd: convert dprintks in check_export() to tracepoints

 Documentation/filesystems/nfs/exporting.rst | 13 ++++++++
 fs/affs/namei.c                             |  1 +
 fs/befs/linuxvfs.c                          |  1 +
 fs/btrfs/export.c                           |  1 +
 fs/ceph/export.c                            |  1 +
 fs/efs/super.c                              |  1 +
 fs/erofs/super.c                            |  1 +
 fs/ext2/super.c                             |  1 +
 fs/ext4/super.c                             |  1 +
 fs/f2fs/super.c                             |  1 +
 fs/fat/nfs.c                                |  2 ++
 fs/fuse/inode.c                             |  1 +
 fs/gfs2/export.c                            |  1 +
 fs/isofs/export.c                           |  1 +
 fs/jffs2/super.c                            |  1 +
 fs/jfs/super.c                              |  1 +
 fs/nfs/export.c                             |  3 +-
 fs/nfsd/export.c                            | 24 ++++++++-----
 fs/nfsd/trace.h                             | 52 +++++++++++++++++++++++++++++
 fs/nilfs2/namei.c                           |  1 +
 fs/ntfs3/super.c                            |  1 +
 fs/ocfs2/export.c                           |  1 +
 fs/orangefs/super.c                         |  1 +
 fs/overlayfs/export.c                       |  1 +
 fs/smb/client/export.c                      |  1 +
 fs/squashfs/export.c                        |  3 +-
 fs/udf/namei.c                              |  1 +
 fs/ufs/super.c                              |  1 +
 fs/xfs/xfs_export.c                         |  1 +
 include/linux/exportfs.h                    | 16 +++++----
 mm/shmem.c                                  |  1 +
 31 files changed, 120 insertions(+), 17 deletions(-)
---
base-commit: c537e12daeecaecdcd322c56a5f70659d2de7bde
change-id: 20260114-exportfs-nfsd-12515072e9a9

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>


