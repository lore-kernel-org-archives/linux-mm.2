Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B0ED46608
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7746C6B00B6; Thu, 15 Jan 2026 12:49:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747EE6B00B7; Thu, 15 Jan 2026 12:49:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637316B00B8; Thu, 15 Jan 2026 12:49:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53D046B00B6
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:49:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 202DE5890D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:51 +0000 (UTC)
X-FDA: 84334936182.18.B9CD855
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 42B6D20002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HXF5eSd1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499389; a=rsa-sha256;
	cv=none;
	b=KxQczSIPeOy907qkitbXK+ReTSB684e1TIak/2ZPRomHhEmDYmhiB8bVTN6ao2iIavUxQO
	M7UW6BqtHdAPT/aEOxbIWhxzECK9WHi01nwgl8/cQiUVyBlxXlhNPTkjBsVHo4AZaZs8iW
	wbAMrBMkyasvlQrHXxy2ZCWNrTqLbSw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HXF5eSd1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzKR2gyy2aIz+OBiQsjB1N9t5p79oZzAtsRciLpQc78=;
	b=z2EUdzehTBUswKRVHxElvALvu1YLwltkueocEOeSg6ka8F5ej1aD0UmllkNabi9G5MFKgR
	sXwEPMfU86W1zNmiYbGWPayHRE5DR4NMj4Dr9cI6ZHGhdDUCrTVp6jAr9KIwX0Z39mh5x2
	l3wi+/ddQLBC9CKkdY/ujXSRCmG2XXI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 687B844413;
	Thu, 15 Jan 2026 17:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2463C19425;
	Thu, 15 Jan 2026 17:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499388;
	bh=4X4oMdETf1MDXNVdTj8Mvnuo+gH/VRKi/jbZgD6BtXE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HXF5eSd16LXlk2pg+ykoxFtOltKLYcVhDbq4eu1qwmD9XuCNWEyYNq/SBbzMC2xZp
	 Us30TUq2Qf0LqFXcegPXmaUXk++IckN9SudLLGy1m2S/IWaC9Fe3O7QdJixMC/QzW2
	 HJf9rCe/ppr7ZNSUKpXLcTQLpiUAT0OY1jeKS3UdP9YlVuUmo+x7zxnsNV6KlYZ7IU
	 OaZtTAo6JUCABYVdaE5e1ipItaqt9i4ljmLQp4ZO65psdJ+V6VolZKMHaqtQRalSo4
	 sMz1xXvAVGjzhRpu823inA7f7eVi+tZrnpoSlK6flDgUJfBJnR2OMCIZpueoNVb0Or
	 MITNRwqqqmCUw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:47 -0500
Subject: [PATCH 16/29] ovl: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-16-8e80160e3c0c@kernel.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=920; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=4X4oMdETf1MDXNVdTj8Mvnuo+gH/VRKi/jbZgD6BtXE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShIaOS03XvPpRfdi/+BkUUJRyp+R3CppMLW3
 ZiynNioo6+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSAAKCRAADmhBGVaC
 FSKRD/9yG9hD8ojJ6IljtJlzqxX5Mrd2/ao56DDsFXOA9FWMnwCaPHEJAENPNEWtwbmo+vNTjlp
 lQudXpKYDOeNMFVDBXjh6s7BskipekJgzjceXBd/7Z6OS9tRE/xrCWPE15WxooWzDH+MPSod03a
 dXyjbFBx/fMXGVLhHNec09c5PmN/AeUd28FN9pbOkV9+YFIABVgdQ4JjsdPqcHRpqcAiW6j5R1x
 HgNZYRunFukBcUwYHbHQXKQXMa7FEMKpQjmiWSpu4vL15ExPUoGC/AV541L9S3ZmMEFY2SqHxsR
 Fd/cWtvMpc0G5qWAV7q1qmHzpe5466KioKlFxu3HYEz3QVwWi2q2URf34dPKhYlj/SMZ9oDE3H6
 5ijLnuOZj7i/WgY+01ZxkNw0O8sebKJEN3+oguERhCG1jmSPmhERSbTg59Jh1Rpt6wU/eJ8MRSP
 mp5A0ii8f1xcVwyBnfe0wxC7fwXmPZorUgXv0TuPX54mAhzf0J+50OTuensdWi4sVgUyQ4Rv26c
 fUkFlkdWL6b67iWWqJHGyiPP/+lmavFA665rkX/WhAw4ATTVYmqKAJ3kI/M+4G/svV+Cq5ZxfPJ
 4W9/XSnk5zbuOwc/0/q/U5L4RAyIQDrojuGi7pHqgMXVPyD6jrJYx5YsZIgEyYbJcrMh6+zUrz0
 s2rdJhIgISrWcqQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 42B6D20002
X-Rspamd-Server: rspam06
X-Stat-Signature: mg7ne4rainf1abtaysn1rhr4b6jbsay9
X-Rspam-User: 
X-HE-Tag: 1768499389-8615
X-HE-Meta: U2FsdGVkX18yNvw3NUjSVOM08NqvvIB140ypbZJNN0/m+5gg4JqbT8bIZH/y/hMSriNz7L3qJwkln8HCkNlwzdz/M9Y3EKrNF4J7nTWXyaRUMHgHfmjk1LEvkV/H2EQO3JJPUrdpG8UXxw6nlej7Kwxqbj76g8BLd5i0ehwSIr7UgHixCChQI2C7/H1CZHatG9QFg9tBcNpJAJsIMqlGT9BA/N50tcGXrqjG5YYGuGI1fmkwnu66ElgepHKDVbcBXwXv0hXuDEbQdGUCMYWCe9qaIPPc0lDp8jSJwYGlsez1cnQeNxZI1Lqf3FmKjybqXWO3WV9c8XtuOi60PVpp5XCi0QBmfYHv+w7QRG/tmGed5VeGtrd4UJ4xGPjqm5ph44oh5/RoU16227n/KgH85iZc6rR10zmPu0A5bWth7O//VulbrU/CTXIAA33eo66NaVadQTs7glJR+sHXJsOHvu+i0A8EbU7bGb2i5GWRUB3I6iPzvW222d6zKn2HiI74aEfT6Nc3ab0RJUzETVP45UF8jfvV15fG/BP1Je/gP5e37fhoRpocYDYkBOdzp+QOadRbM9Yev0E9Pui732vS/NwqtyZda/CQGRin5Zj18EYkoriK94a2AfCjBT9Ms9QRPqLlSZmk4wi4Kj0SPfeTlctYNgeapCcT5Rb0PaonJrfjVgedce9RVYR5D8xZW68t7owk4N5thcJ/UKbeGajSaiPGFrtBtcSbwcqutTuGOXcOzxxY5NT/YBeH9Lj1y05wu6VWy2aKHmwG/t8/TPKkNbbD6zznYGxS6jvE+Rla1JwXdjARhDSyj6Hg3FON/VeJZ4F0Ww8x59CDHbanNBaRURlYrBhRn9vCkf0sK0DeJ5s34MLPZpak1mLwuB2OZ3KQX8AqiD3DQDLwaAOJQ64nwdVq0U0QSojSIc+tGedXVN8gxRBatDC8nUL5xoGOFi9NIIaLVYEaTcYWMOJSqQH
 fPVem5tV
 WrhufuuK2DE4Dks5o9iuk3SE1JfD8PZ4nM+uBLnPVHt6UJVjFTTPD51C3W+gkdpraK4xnTNt5fLzCR1etByZFH8MYqM9WupKe9g9SwLRa4Djx2FABsoJs+7sV/MTmM8rBLj7KG1/+qUf7R/mtK3SWWM0bQZEqvnhPghuU+6kLvfmPl08qBAtRG6tMvDS2eynIgeSErogm/zk3vSHJGy1O36Wj+CLxuj8/TUagX6EXEfqPpW9/T7w77kOEoahTCq6GS5AeYTYPG/hVj8sxwj7/jl5qehPH93C1P2IdbRV4DCfphy3gXjfa3lBGqs4FUGjJhyWrgXQLktioEMI86r68spFqP12zQuEGrJsmvO6kFAfVcCs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to overlayfs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/overlayfs/export.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 83f80fdb156749e65a4ea0ab708cbff338dacdad..17c92a228120e1803135cc2b4fe4180f5e343f88 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -865,9 +865,11 @@ const struct export_operations ovl_export_operations = {
 	.fh_to_parent	= ovl_fh_to_parent,
 	.get_name	= ovl_get_name,
 	.get_parent	= ovl_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 /* encode_fh() encodes non-decodable file handles with nfs_export=off */
 const struct export_operations ovl_export_fid_operations = {
 	.encode_fh	= ovl_encode_fh,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


