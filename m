Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29F90D46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 946966B008C; Thu, 15 Jan 2026 12:50:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A976B00B8; Thu, 15 Jan 2026 12:50:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D3E6B00B9; Thu, 15 Jan 2026 12:50:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 73D596B008C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:50:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42039C1C5F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:04 +0000 (UTC)
X-FDA: 84334936728.13.744C9BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 79269140009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BgcU8VF4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499402; a=rsa-sha256;
	cv=none;
	b=3SqeYnZbg+7j+eGhHxxkC2Chs1pTiClmoa+1irjb0r6hDRgAZ2Vq8G8yyQuKHWccpJB0Zo
	t8UqHq1X/MAW6FKmpmzRjMBhQQbkuh6+IZw4yhT7UAS2rTOiJhkh/RoxiS+ykw+jDmX3th
	LPMjL5gswB4pr9Jc/LCfp0JX4BTlbwY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BgcU8VF4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=koSNGk/Vom2LZhpxaJrpB604XEMfBvGIQVT03DlSk+s=;
	b=8gC2pjRFLgGmqShjErTAx2da1WKgSvVYUmTwc22oTtN7wZOfYVLXgbzD8/bLZ6lM+GwQMq
	nWRvlYehYDU/ihH+F/N8VJ/5aPRolkFylTuv43VTaInKDvC6nKoOVv7Il7+AM0Yv3tUl7g
	HTvGmT7/eiWuGh7CeFqzlzi5py+R5Co=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C7029601B4;
	Thu, 15 Jan 2026 17:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D67C116D0;
	Thu, 15 Jan 2026 17:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499401;
	bh=uwDrVoHbpPoBcmo/v3dHeiBewkzxqNNqtxlZm2e4dt8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BgcU8VF4uU9VNdxjCqNfjET7gHGx/VAo0oeIqeLRdIsgPaTT6ct03dx2jrDd7o8BI
	 CCshVV1E208sOr9o2PH7/g+JfxDpXY9eZDUibvIq8pvFscodjQuSN8RWQxruSKXoI/
	 hgW78nAy8K5x9VS3/1/p3O1mrvpBnt2hfAlVpoyRe05AcB2r1c5qou3xP7ajy88NQs
	 ZIX0etbtDG0jg8MtYwH8eYXxe6RowC6CHSQkZ4tfMrgVWi0rtt4KD4G7v8NmX1SKpf
	 +ycIqXRbQcG6Cw7cOfPPhmE0wJkxag2JDFt9f2GH6540kL2VxJ2UyVpvitSiIDeIFm
	 tgS/jf+s8G1Vw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:49 -0500
Subject: [PATCH 18/29] ocfs2: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-18-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=686; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=uwDrVoHbpPoBcmo/v3dHeiBewkzxqNNqtxlZm2e4dt8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShITPD+RPkPMEpLXnnFoYUrWRBnV+i6/7ZXb
 2Cib6qgPF+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSAAKCRAADmhBGVaC
 Fc4lEACr6zvbp8mwIEyJqUBPypx0CbTv1b+btQfVmrA6CGpz6NlXnPBXu74SWbwJx78R9naDxSo
 4ujJV+JxC2vsZN3gMSbSryefeh8vZFixmZ9GKrLwy2JF+yR5MDnrhDIYFhoust1m/CpIYwTQLrN
 +OA58sbRtyhvTPNH4lrppknmtdvvnrgcMCc67prQQoAY7Kj3scJ/0f2hABl2MSEXjYjQGBAv58E
 h+6QcX9C2XIItQt7JJmt4EDshWg5v1sWm/f2qRitZE0LWnzNgY2OuGNuCDhWXzEDfCsTzUrlI4W
 mzdzEglnrL8uYAbYYwi0B7c/Lq/vHAOXHlJ16H0MzyYhPCFrt8PeDXExqTc5bRkzyIwecnQqV93
 ckgmq1M8drIiGpvkwBXihOVHAgYI/F9dJ22BRkXcTJKuCe1hEcqQiMrpjMU9l4o7EZv8tiR4Jmh
 aru/nnZVOrSyeFUiQLuQ+mpI1QKdrp5nuLV/2yhOXcHpv9wIYritLVYCn6uu+2yhjSywg34K9lK
 Y6+l5UAQpaFC8ea/mQaaeZYFDFhliHr8y3hTzrVvm0bl6YExJefRbNT3UPxPyRcGgQH+bVzthA7
 BLgRv7GlM/YDGxkyl7UNZlKjzauOn/nQxU6EqVlzLfm7Lt2s/99ujhx6ajeRupcwTat4e/vkE+b
 NnihSUwg08h5YFQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 79269140009
X-Rspamd-Server: rspam06
X-Stat-Signature: ow8igm7df9fnfh4jm4i9bbst3s71hfh3
X-Rspam-User: 
X-HE-Tag: 1768499402-973565
X-HE-Meta: U2FsdGVkX19/JDBoGlRXwsbCeivcpkYkOBbwQJoiyz1FnT8hELsh/y4buOc1QxgoI79HDWhouH6lTtAZwaG/GKlQThHPfVm1no+Cxxr1nZAFvN4E5aSmuc2zUAEfO5vEG3ThzdYRQRi8Drp7eLu0S0w86yRqgwFDV4drtISwVgspIyRtCml7fTJyKRgSerNqMH8YuI1kc/XBjl7CfgXTHxzacFAn8pp/v6N/mUF0tsBmA467mY08grSmV+AZc5rVYGBNvMebuA1Kfg2BxIMQoTdq2iwyZNUYQjpVQ0vIQ9ETeuFcjq6ftumrtRtibZ7/WXNJinEJxy0+qi+0uWnq6eXoDBKxCXljqpFRTux7UDSjJE3NZou5AT5Bzk4YN99jH6cQKXl69VUw4xyU+xNKjvdxhv/TU0NKbva+A11Ck6c8cnhp6ldx5ewFSqPYuSKsOxm0Ny2ZrCVchYMqXxOUqYxUo1ITIcjjizphGyfziJSOtaIJPCDcGgXXmm1gErS5TREwhFb48T+lYUGNWU5LDim9jED9Ati3MwWRVN91MqUR6ft2COMhy63qhdGXl8k2IaV6zwbQnKyRaSYB15mBHdLEvg97SxL12iLXuJnL51fmHyKKDUqKScOObah/Iw1nko9NGXKJY223eYKya6feWwIfRCV7+VO7c8/4sDYDX6owYVN2fMp674OLyWJ3g2QxaO5qeSzlVKuBhf4G3aLSnBpv+26cdvBhDWSG/tSH+z59zqZIWHuB3PBUnAbJnLq9VLwffCHfeseJT6p64uzPJpdsqCWB5NepakqacrLdfSBMJGVvV/urAnTkHLdRY5N8fDTCxo1gcizdN3zR9/WormUqtJBEmptFWSJoxXOUtGMLLZsNhoHHIoryfu+PPsCU8mJvJrtP1P8OzdMYq3WfVXjptcU2ARlHkUfclp52pbz6L3jPZq41PVhmFFHBttfRtsJUXwu2UFvqpxSwgLd
 PHRW0Ul0
 S7AEmQPDWZvsaZpSCgNlJAVfd+V7GI22GO1/Dmn3Ecn3wf5qlB5U9z/e0O5Jinlrw6Fgxyi6teFD/6hvxZVnm+i+X8CSJt79PtOItorhar5toenwl10fQeJFi7sghQFzQhyW76gaKIDci9pYd1u+T47CbPmGA3krCs5A/yzmyAsZ5HDRnNSiniHD9dej/5aTnLWhn0Y85N7HlLZeQgv/Vm+NiKqnfqdjMWhEA88c0iXwY40qxTkE9TSmDUCrSCfX4hVEyM8+fBazJN313ph9usBrHpHDw/mFf92Y+2LvCUkhweMXu757bszIICxUP98FsOiPWVHRtV+3O75Pb7N8ANTElbMVBxCIhCNKntmHflvoJZp8CUmTeCNUV6v0sRd0tkPteDy5WBotHn78=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to ocfs2 export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ocfs2/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index b95724b767e150e991ae4b8ea5d0505c1ae95984..77d82ff994c86037c14fbf7a1d9706f1dd2b87ac 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -280,4 +280,5 @@ const struct export_operations ocfs2_export_ops = {
 	.fh_to_dentry	= ocfs2_fh_to_dentry,
 	.fh_to_parent	= ocfs2_fh_to_parent,
 	.get_parent	= ocfs2_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


