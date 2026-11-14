Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79883606EDCE
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F26xTNVz
Received: by kanga.kvack.org (Postfix)
	id A52BA6B05F7; Sat, 14 Nov 2026 08:10:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29666B05F8; Sat, 14 Nov 2026 08:10:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93FE66B05F9; Sat, 14 Nov 2026 08:10:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75A326B05F7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:10:17 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 074131403CB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:10:17 +0000 (UTC)
X-FDA: 85433758074.30.9BD8775
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 35610A000B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:10:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F26xTNVz;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/mTAJVuuQhpAVAUlFXnSBfePIty5rSPTob9a1ZdEdY=;
	b=Gr7Z1/yHMxMgzJtL/+Y3gBcq8c3UN2gJuRdSqeS13nnGB8fpx3oh0pFvaXgfCCbKbQbDUC
	SX1LSUuelU2GNaS2EK//cO4ssbbupB4KKZm9RG7W5bDpvRtsUPxvs++gQbWRFrjCSne0Yy
	cP9ebE5g3qD/XHIZRfjeHIfduN5otwY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661815;
	b=F3g8CtPLTlgccD7dItpwL1VXY0F4Y2ycwkHMlhbL5DqkKoqkvBVJJkasaPdm2717p40ZZW
	d9I5pCNFPSQJ5lo5+AwJGaEiJOcdMjSvqjO6u+r+HiYMVAJ5gdCN24qN4gFzAe3GKYW8vY
	jm9+Ur55yxj9XFC1jPcxeVB2qMecbT8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F26xTNVz;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DBE5418C8;
	Sat, 14 Nov 2026 13:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE741F000C8;
	Sat, 14 Nov 2026 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661814;
	bh=h/mTAJVuuQhpAVAUlFXnSBfePIty5rSPTob9a1ZdEdY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=F26xTNVzW9tp8yy8ppp+Dv86UhrCHvWmEOdhHICMiXGEZk2O2+Kja+w/MuQlnOMu+
	 JzTI3R4yuU5GRr42/E3D7uDu4Cr/FBika6QDUGu74GJkDlBEAeX1YGEjS/Dlqk9bBI
	 Om+csVo3teTzJCkmRtuq/I0XgR/m20O/2c2RKOJeToz5F+wAMlJddfR2DNTckBrev0
	 DnzEWbcdtIz1gsrII6cFjNLa4arltfHbmaBXKJT4vFgnQ2RFGqTnnuIxfh6U+NKph/
	 bThJoXJ1oJU7xRahe5YNw1jmbpdofQyjA7ORrMjBcwkVSn1sj7SLDJhUkBv2Vrvutf
	 PFOJUgNRV91oA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:21 +0100
Subject: [PATCH RFC v2 40/42] erofs: refuse files on pseudo filesystems as
 backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-40-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1554; i=brauner@kernel.org;
 h=from:subject:message-id; bh=G7tJlJJnInVCqA4f4ewlrJ9rtBBg8ilw8miRJBX+0NY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iJnCssvWLi9e2DJl4eu06dM0Y00/Tfzzb4uTU86rv
 ycsT/wK6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIUiOGn4wKuxctKVhzQK7P
 /16SfMFr0yMs67VSHrYaCJW87fifu46RYVHfjQK/wyu61EpT3J9naxxhfFH1vl3hrcymU+syTAp
 WMgMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: d8if83ojys9ocoqd1bznu4x1dq3a7gtf
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 35610A000B
X-Rspam-User: 
X-HE-Tag: 1794661815-368252
X-HE-Meta: U2FsdGVkX1/d83qElf7j9tF1DgpmLowU5NWMnIyEHVa3Ahnq4iLMk+BScWF/RAjRawBE6GN3/pZO0H9QYbiFCk2t4hEO2/D1aWIKz/GXxIK3zCG2CqJvwldzHGxjt7Zb5uqk/ixE32kvCAJ28EMgS/DRqG12VKxGgL8GxG1aDRk2mlzrL1d32a+yVT2XhgNUM6hNACiKtuiHHD3yQAjQcCr1HGAUXgJsDDu2ItNFVyGG4u5Wf85WtP0/17Elxreh3qnOPjfGpusBYf5LUP5CVlaL3lft69Fx0tmekDVpVzXHjH20m+qwK/e2urHH8ZQlgRfnDEgb5y7PJnPXXzQAMwSOE4Uc3nIj4vu5G+4121nl0Qd9x+yPXL/0/7rF9xlIdEtyebDmDFGfSIE/vl5Z3sSNJcIAoRLMaBXm7PsMr/tVEnkCvNUGJaoKfdXNnhvxVzN7+fM++y3KCBVmZw5nvnW1x6SYZqyT2DvRNs/vS7FyGsaSlfYC+V8ey+zq+tMjymewGCnlrUEhVW6Fg6O6ESUvsnRoHiqftpdtfMjNdINTUegboyEHgAThS45QA3YCFRFnEAIitSbUTeYDQK3pED62weNhLjjvlh+Tj7kgliO0/+4ob1iuOJNhPEZoaizGWP6waCqrWR25QkizPMXofLuPZ8klSelqZnCB+lrXAu0m+/+KbC0iQWjqEkAbCdfBM4wcDNzXMl081nabxXX4D8XqvLhy2RDgGF/V4qd+hO+6iNAa/7qqN4H/3H3XglE8kMf8afKHAwWNKzDCycAOWk4PTtxpRlb7pMvz+TVWpPxOGMCZ/sSdSa+xerA8G9D2AM/nCTEIf12W9IMTHBfYoUat3VLd+kvxJBLVmB5H32zw14vRelrgcdS3b0/a9mv4Xi7ZE7uHhDlhKfxoD5PYnTc+fqZGgl3E4YkF3FMvavFkYiEvjGTle5oavySrNZTNyNzn9JT7fycv6K95ZOe
 E6vO6+we
 n2n+OmKol4X7BUf48Kq6PKQ4TLl9KimbaadgtUBzEjUOgc80SHPrlf228S/sIHccuox69tGYq5LhvxbZ1nL1QW6eanLwlN3kQHyA7YpILeDa5wSSQgHTnRz6SnatXKHaVdx1F54pkqJB3cHcMLbTHe0YGGtoDEhQjFvOyoWMtCDTAESx3wY3+eF2iPlNmAfAH1W9ATtM31XnOPWTOIVhuo3grWxBSACqJdGvBvQQkYM5193OGJ/MELBLkSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

File-backed mounts take any regular file as the image and the same goes
for the extra devices of such a mount. erofs reads them with the
credentials of the mounter so this doesn't hand out anything the mounter
couldn't read anyway. But files on pseudo filesystems aren't images.
Refuse them just like loop does.

file_check_backing() also checks that the file is open for reading. So
a source file descriptor that erofs can't read from fails the mount
right away instead of on the first read.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/erofs/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ce05557bd9983..517a289b9395c 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -158,7 +158,7 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 		if (!erofs_is_fileio_mode(sbi)) {
 			dif->dax_dev = fs_dax_get_by_bdev(file_bdev(file),
 					&dif->dax_part_off, NULL, NULL);
-		} else if (!S_ISREG(file_inode(file)->i_mode)) {
+		} else if (file_check_backing(file, FMODE_READ, 0)) {
 			fput(file);
 			return -EINVAL;
 		}
@@ -835,6 +835,9 @@ static int erofs_file_get_tree(struct fs_context *fc)
 {
 	struct erofs_sb_info *sbi = fc->s_fs_info;
 
+	if (file_check_backing(sbi->dif0.file, FMODE_READ, 0))
+		return invalfc(fc, "source can't be used as a backing file");
+
 	if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
 		return get_tree_nodev(fc, erofs_fc_fill_super);
 

-- 
2.53.0


