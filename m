Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47CD1D1D483
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A96976B00AB; Thu,  8 Jan 2026 12:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D2C6B00AD; Thu,  8 Jan 2026 12:15:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918726B00AE; Thu,  8 Jan 2026 12:15:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B93D6B00AB
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:15:16 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 564288AA62
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:16 +0000 (UTC)
X-FDA: 84309447432.29.BE0A9F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id AFBED1C0010
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QUf0x1S5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892514; a=rsa-sha256;
	cv=none;
	b=Wvlc0GEFXfbt3uFm92PlVpXBcT3W1sBaW28M5/lLsKzNTJziYGEOhZ2Je16CgO0TlESLbP
	UfeLmJlfnV5EuIKr3TIHGmP7MWNFThctj/ZiiyQJ49Ppsfgkweu/fAKBhj8kpQtxAZDZG2
	AUJuUhVQjskPM0Ov6vp6QI6auqOt/Kg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QUf0x1S5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikPkvxZEFqEFOk9dERq4FeObG5IFIQK9n7omq8yijjk=;
	b=USKrBY6NTkp/LHRIeB17En3N/NFZUs7EhCut1uESa4dVI6fAD14saDHO/ZLsIlgw0R5K+r
	CalLFx4QDwj8n1m+vtbhUEO8A27ngncvCzUE+rrS/pRkyvIyeQvQjq6l+zAJKEJtlDTESL
	fqjjJaB/kAzyYs2/6c7WZD0wbw9W8oo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 15BD860145;
	Thu,  8 Jan 2026 17:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686B9C16AAE;
	Thu,  8 Jan 2026 17:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892513;
	bh=LxI/ylJoAyN2L8j0GVIMwgPEgj096EiMNnZ2VE5RMBI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QUf0x1S5Bumga21rP/0u5v6W2RQ4BluTcyv+ihE6zxjqOH4cSdhGIv2a2hWmNwkEY
	 GP82TOP3utzcm7AFsouq9nW5sKotUofmqhH2HblXeYHjAkY53RIkASaReGdUxITEHR
	 CpbVb4v5pnNOvg0fePHXAZs9jF/BSPNoZCdA4BgkfotHBZhgCxh+Eqx7ucO5aAd99s
	 nC4VLK1Eokk+dFaCZRvPgX8Q/2tq7B4zKAB8fli4S/NyxIc0ZjCWnK2HbP00IJ5no3
	 +f+bc+sVTDmD/e9V2p0pp0WJUubi6eMBZruCs3UzQVL6YfG5bgieNR569AeoUsBbXV
	 zyAWDIpezVFJA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:07 -0500
Subject: [PATCH 12/24] jfs: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-12-ea4dec9b67fa@kernel.org>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
In-Reply-To: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
To: Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>, 
 Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
 Anders Larsen <al@alarsen.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, David Sterba <dsterba@suse.com>, 
 Chris Mason <clm@fb.com>, Gao Xiang <xiang@kernel.org>, 
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
 Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, 
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
 Dave Kleikamp <shaggy@kernel.org>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Phillip Lougher <phillip@squashfs.org.uk>, Carlos Maiolino <cem@kernel.org>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
 Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>, 
 Alexander Aring <alex.aring@gmail.com>, 
 Andreas Gruenbacher <agruenba@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>, 
 Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
 Bharath SM <bharathsm@microsoft.com>, Hans de Goede <hansg@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
 linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-mm@kvack.org, gfs2@lists.linux.dev, linux-doc@vger.kernel.org, 
 v9fs@lists.linux.dev, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1701; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=LxI/ylJoAyN2L8j0GVIMwgPEgj096EiMNnZ2VE5RMBI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W7d87lASYok48UUP86L0PxRicnWCxcwIa2g
 mrjhHHdS8eJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/luwAKCRAADmhBGVaC
 FRqVD/4mxKu66YoVwGnK/KbDPL6sP7u3c6Fqe/CzabSY/cYfYzAoIK0qove2EW8DsMJoXrFfCt3
 AmH3fJ2NzhyuumNIiCwfp/98d7mGtejKDtNXVvNybC6Jhq5FGUc9JGmOfhnBUuxvv8b35sFNHIq
 PcEMa7D8RqJH5xGJod2txTPQ4bl53O0YlGgolAHJ0gPLgzW2lsGIRrACSKbH1shyiIUw5MQSGbB
 +GUepZAWHQSzMuKtbeyL8am4GHJUfVIt6bdbVhAaNU6e2RqOk0PlRircBoM05Xwr9WHwl2Gu2ub
 4c1jexsIsI5V4AFxKZvMcP7/qBD32Ui9VZOzp7RZX8ts5DZkaKFkP9Hp2aTR6z0lenvWHeaWJJu
 jhsCqHB86EpC+byLIiybWPjlh1UFMOpYDEXuVEWiFeQf9xA/om1XNjgyXxKQNPJ9PtFsi+LL0mJ
 uxFuMtlhX78r62nBwdRMHsaTg92bFaT8MkoCRusNV76fOjKvtVtLxi7dOeAfyBIfC7jt4RhjsEj
 B7rWLAEte6L3EGQ3BCHr2d5EQ1zZNiDlgkhMw08fKmQAgqI1+rcy1K73Ng2NHs9sG7cOSzQg2vu
 BZmdy/67YXC2viG4pAV2raZi5ApCfRPQwFxyhoOw81iQyoQ384mrcmM0Bsl4zpgVZcBA5sw8kuD
 j1Atxo2tHiM6kQw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AFBED1C0010
X-Stat-Signature: ef5isk6gctfomkc1u15nbus5w8dkbnxu
X-Rspam-User: 
X-HE-Tag: 1767892514-562502
X-HE-Meta: U2FsdGVkX19pgRy5OiZQ41nsBE7dnYACYsfC6glikdH0i8iSfNb5R1fP7dbhA+pRpTvL/yGQCezLGNje0UA2HD9+4zeT3yNPAkLHcnxfU8cDuMoaVFRjLuG8Hz7CAd/MVZ5/7h0REwqXEbLKatB448xjGPLuq58jy8dCJMBb0m8GrMiGcKeez8JddeYDhSo3H8gnid5flqwJtht3TsnPAMvzkYDeVwkfLlEah+NMeGDRheE9HUuz1cx0IzxZY1+R5ebhKLbfiQjpfig/Pk/DQjYtV2Icr5nEntYZSBBlPHzIZVlcpPeIsPWKtR2/WGb/bzG6KwoASBauJOYW3qtUEzB/+1vM2sJ4SlQC0vYIj7c1QIV6ax6Fd7V5ydE0JmQgTd9nohV7zoOjIn4jw2LBs+1gpQtb2D0Cl7uHwKvz2DP6DLNpbR/PdFXqPMPDCTp59QrPkUW54gC8dviS3HDdIGd97fTE93tqA/6Y1MDwUfY2DbOKIaZBBTfYkNZjJFza48IPUE1GIOcMTTFHb7jvlrSj+vr+ddk+EVuqqZCetjJ6VNV7VX9t+ibxzXivBnGBNEgP1OLs9hDH3DDHcLVZjBFOX4uib/wcnhAU/KzSd7/oXN6ze6Ca1sWGi30KxY/90rls0DQxJzVjCJB2qyFcekGS2wmfHYla9+5BHhVXTidi1iBU+7QmUnaKsEc23ixzRmhR9OvimYM5eTmCMx6xtfUAfx4NwMjle0R4qF5wyHhfnvlluaEhjcEtIrckDktTIQFG8OFM93hLUfkw79HyXdfX2Zyz8/qy0IAqnb/1GyUR0yMXN98cW1bT76ST8KhxxEhS7D6IsqeqnbR8HEpjpV129RRKwsaNdjgbIDkakomE2pcFK3oxYO1L38bcdM8woeYb42eG9KQb0xQo5bjkkHPWvs3Ga18MOxdWCSbS3I7kKRzNpL4aM9SK5ARROfYqqCmOUXS4nd8Vl+cY7ta
 NrvnqYnc
 uSIGb6TriIJZdx0qwAFilh9/bKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation to jfs_file_operations and
jfs_dir_operations, pointing to generic_setlease.  A future patch will
change the default behavior to reject lease attempts with -EINVAL when
there is no setlease file operation defined. Add generic_setlease to
retain the ability to set leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jfs/file.c  | 2 ++
 fs/jfs/namei.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 87ad042221e78959200cce12a59a3ffd6d06c0d7..246568cb9a6ec144831eb3592712cce323d8cf1d 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -6,6 +6,7 @@
 
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/filelock.h>
 #include <linux/posix_acl.h>
 #include <linux/quotaops.h>
 #include "jfs_incore.h"
@@ -153,4 +154,5 @@ const struct file_operations jfs_file_operations = {
 	.release	= jfs_release,
 	.unlocked_ioctl = jfs_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.setlease	= generic_setlease,
 };
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 65a218eba8faf9508f5727515b812f6de2661618..f7e2ae7a4c37ed87675f0ccb3276b37e6ce08cb4 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/filelock.h>
 #include <linux/namei.h>
 #include <linux/ctype.h>
 #include <linux/quotaops.h>
@@ -1545,6 +1546,7 @@ const struct file_operations jfs_dir_operations = {
 	.unlocked_ioctl = jfs_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.llseek		= generic_file_llseek,
+	.setlease	= generic_setlease,
 };
 
 static int jfs_ci_hash(const struct dentry *dir, struct qstr *this)

-- 
2.52.0


