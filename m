Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12279D46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 783606B00AF; Thu, 15 Jan 2026 12:49:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740766B00B1; Thu, 15 Jan 2026 12:49:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63D8C6B00B2; Thu, 15 Jan 2026 12:49:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8416B00AF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:49:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C2ECB9844
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:31 +0000 (UTC)
X-FDA: 84334935342.26.270068C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5C5D41A0011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WrC6gPMN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499369; a=rsa-sha256;
	cv=none;
	b=Hpk07B4rDVGVnN6b3UXDCE8KfJhwvo9ZfX5FXibvh8jhqtzOBl04MEvOanTYhonPJJISS2
	CwHdvhBByoHv8KdIfsjx4KK2QVJGUznM2sSPF+eHYsOJvnD/TwSSwuyGWy8PxWdYvgh4zP
	CQbotqr8KcbBm3k1tM7A49QGg9DJfBY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WrC6gPMN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AYWURcqMUxp9DlYRnvKSwe7IEW9L017mImGJDNWH7a4=;
	b=Hb+UIApphjZdJ1/63i1qPKiwXseA+Sdkh1JGiwRU71AfbZYG3JvnR/6/VreUwJ8afZKy8S
	ab3iUxDPa8Qef7MGNr/2t4kxaSeWRegNoTyrhojtKevqVjnPnGh94b2CX0HCRd2OGYN8KA
	5SP3G0G6k9IP4nJnOlOH5GYtPLuEYf0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B4680601AF;
	Thu, 15 Jan 2026 17:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C14C19425;
	Thu, 15 Jan 2026 17:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499368;
	bh=eujLaXiTUgNyjxHmQdWX3y0IvgSLWTxRgF6WqDofLiM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WrC6gPMNbrPphwr9B2OdMVMQWD3w6Mv/nOHw1pbDBE9bxWiXfLBlumR/OK5kPYvhN
	 apkCGc+VCRQbuTwUzoMWQokSRmciqLfDU1cKQaB0vDgFmguXC/lEKFQuA1jBtQO1aF
	 nY3Vqv/eIQMRVKyVDelnHsTtCA/b3gjlScr6ZDHjRk3uLay+tzhSV4lLC/9YEnS5PX
	 mOoXSwKkjcNHnMBAWgQ1xuVpR4uWZcftB/FcM9PxN63hPvsYuMkuUDkxoOxaS/5EE3
	 hJFC4jBF3M1DIGPw7w+cQqHCLPWAeseUgepLBm2x4n/2+78QiklR79Cs3+JFj4Ixb/
	 cC6zieYF97tJw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:44 -0500
Subject: [PATCH 13/29] affs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-13-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=733; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=eujLaXiTUgNyjxHmQdWX3y0IvgSLWTxRgF6WqDofLiM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShHf9xsknLmtYtQUrLBjji8uf4+uPYffbqfL
 wgOw9E+mmaJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRwAKCRAADmhBGVaC
 FXbXEAC0895+UA8PrkFaOQufVJ/wApB6ITexKHprwSNunNO41jBbrtLkZkJ2sv0koCiZt90R2ZK
 lDcmy1jDGxHDAoeS+2s/+Dj1hyXFroy/xyIvQgDKnouziNx5qID1fnGi5BUM0th5keSDytGUuc2
 t1IfxlsMKP9kq9+tOQHdzMwlju0cH3P5LVsal1qPuxp3wefns1spTXKz8PNsXlSQjqHkFE1i5mM
 rbyG6PTv08LCt/VcusU6PoZ3u1stNRIt6uKT0vzEnO50P+Yj0sHQxEnoX+Bod6emLLeH2eTMEHN
 wuEd/bsRVBogUBGLgr68r57KJxfT93SdeBFK+gHvb1jPbAAhh5cGNAJPqzpumHEbLkKMuLd/Ye0
 nIgKzkZs4U2z5jqviDwSJ6c4wEkvItIzYPZ3PwvGABupEupo5QluuZyftB0AZM0afQWDn08238O
 qbPIrfeH6fKrGYEVVXUuvVJyBDK4LdBJj9OV9OHOHpv8K2WsopPfKfiZgTXTBmXOnJ1302CZH2Y
 eX4T3kDcoEe46PYP5+BtNXT4lpKazM99sT7Qh7ingPdHcFB0kcUp2MYsavYRSaGoYKFQ3mjlIWT
 qXve3+HMCZ60tdt8a0IIZCFnqRO1vasQ9qrLpmhyye3NkmxHM05dXIQjSEO5amwJr/l7RLg/KZt
 t/2RgC4+1Mljlkg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 5C5D41A0011
X-Rspamd-Server: rspam06
X-Stat-Signature: mcueiqxqjgt6xfjwt6z81kqen3bxmqzq
X-Rspam-User: 
X-HE-Tag: 1768499369-810999
X-HE-Meta: U2FsdGVkX1+dxE6AIPf2ZISaf+/Rd0QI6lmKGGaZ+i9nAOpwiNs5EjUyUoO3aH82EAgPw6nx5z9y5U3Wz4C7Cck5yAlckUmKyVxGHFdNVMEkX0c/uMkZS/UtQdgd6BE4w+mdy6fVGbDd5ft8yNBeGtY/veFbfTn8vcinXsvYLoVxNAg8R7VjiVx3b3frAwYsVY4ou4EPu6r/8xcKFRaPOU15dfk2PP6B2Q0V1cm++tkWbvTPYDoAgsQNeD0MoacH/yImN2nFCCZQFFgFr5Of3OQUHqjVToK9fEkfNxgYtWj5TF72NwbvEBTxhu82s0hNSjcMlsIpdXwYPVjCOraSrmP/KfwqY7u14uvUDq+dmQKFsGOI+nhkf1k2f836HPSDHryjnBL6xNdQifwfgVBG8VXhVDKNc3Rv1GkoWH9EE+BnsTYWDkSedc8FN7+AQ6c9U67LtgyJd0WuexK9627weX4PwW8O/Xe/bNkbLtt7XEaYStAEyHRH6iIQbioKqRhqCvTjEyFW7QuuFpGxE/AtRda0Kny1tJANJXRT4wjizBepvPJpAtfEhtXZsFZ8peGZY7o9qbsm2LnHfpkKjEGXpw1GAOr2FGC9SIiwhdUmJj4nJsGHurhMgj7sZ7NRO0eaTlqtXV4jYfXpS1Tu914L99jyCwrSeEAEUWeD76PNOplei7E7cOwNzvm9v0z/N+ru8ioeQJ/U+Cr1NP0l7Nz1+pwfDaMJEM6jyjoj5qhC1RmqaR9g24UfmbsEs/V7OtG4FaOG2ysHUJXNy2yoIMyNZ8oEbqNchFgDJs9TjowcRK3HCFkJqiEpCaK9SyR5msLIOgvGshENGiGkZQBbkkxonyB+1fRmg/+hBEo0qVl2rIZr3L7Sl7DNxVZaFY0C56l/pAJHD8NDB/bP4rqTE98NshjAvTbPLzvu+yAlGDsvSMv58zpUwgi24dtq8yyyJzFG0gExP+CCo1Ral9RfaaP
 UelXlwem
 q6F72MGR3AJbm+fmKCpqufD4ndUnMw5VyA6OJ27utE5s2Aq6orFz8wMKale+gVS6LVBLBSQrsd5V0L6LqwzI1loZE5Lh558UF+Uq7xoYWcXwkaSojsP3Zi/PWjuODzkyAYpLdbqkJZdUCH6CNus72MyG1FnKn/MBDpQswF0LuPP7grmsC91Pe1LsoQlrmBMc27aEu7NZQbS4sMvCXUVgtjXC/+6AlxKQeKZx78um597iWAhJA/5FPQ5MTi55ro6MGCh8PLxaKh1JkYEndrIe4cBm82wf0X8PSBq0QLHdbbJWKjSVg4zuSrVjGxdlLX8rbgkGx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to affs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/affs/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index f883be50db122d3b09f0ae4d24618bd49b55186b..edea4d868b5131fa69912655879231912ceff168 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -569,6 +569,7 @@ const struct export_operations affs_export_ops = {
 	.fh_to_dentry = affs_fh_to_dentry,
 	.fh_to_parent = affs_fh_to_parent,
 	.get_parent = affs_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 const struct dentry_operations affs_dentry_operations = {

-- 
2.52.0


