Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25AF9D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4406B00A7; Thu,  8 Jan 2026 12:15:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881A16B00A9; Thu,  8 Jan 2026 12:15:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701576B00AA; Thu,  8 Jan 2026 12:15:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5356B00A7
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:15:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0293457783
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:01 +0000 (UTC)
X-FDA: 84309446802.30.145D853
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 19E99140009
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Yc4/t5lo";
	spf=pass (imf23.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892499; a=rsa-sha256;
	cv=none;
	b=wuBJWI9WjHCqRG6p4TxwZURChAIQ/LrcfqQ2xbQG/xqCsYQ5ONzQBUmdm0BTextTojTjKk
	R9Uq7+53oMLAl1+74GC8U85gonk/Gb8dPHIvCsVTiyKRsH9N2NyO0xP/AfCkCQF7FlDSj9
	OMgAAGRo8KmXBH3NXo3HPQ7nBFFmX2s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Yc4/t5lo";
	spf=pass (imf23.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YtI+DzwDF0tnFdtfx//elv6GXPDJiavSmjVlMaJ3h4=;
	b=pv2lkCbowwWAIjID+WqJrQzQpNcyG1Uv18WE1WsQivPAoEOz+CKOD4hJlpn+UKd4Vfsjil
	kWmh8OuTJpfulkvs5vfZoWA213kn9L8E/WMgzxpEeK5THMzAhfVzQYl2W+rHi9y1io10Z3
	TkhLA7sBAK7KLGRCFD3XFK5dQgo7W/Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4335B44454;
	Thu,  8 Jan 2026 17:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B8EC116C6;
	Thu,  8 Jan 2026 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892498;
	bh=WgBctrBD8RLFVYdXDqzWSCdo8NzR8JtstjicYPh/U9Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Yc4/t5loZyezYaHDNXK9dd9JvafuBssh+sDSZ3exryKjh9p7XKLxOnlh0HZwejipA
	 tmTIA9/0xJ8xrgH6Y0t7D/mGDf0AqOx/WxR5blHGNJ28gGiZsD17coCliZNvV/vsQQ
	 6XXHPDcyYcOAYUAUaCsSzNRMecSySzNpEAlW8DnTJpjxE+2aVYhL1ZUMVLMRfcMxTd
	 xcBwALhaSlls70OLDrhfnMlALrjEGcjhs7rFzNgirkNOyZkEjSq0YeHhTjU+YgFGXK
	 0ZdpaO1Q0mxXKVnWoQw6OmB+h27qt7MwfOpTqYoFF0/0bFAfq9Vui9DQor/pHuo71X
	 3yAVhPaaUcVtQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:05 -0500
Subject: [PATCH 10/24] gfs2: add a setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-10-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=777; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=WgBctrBD8RLFVYdXDqzWSCdo8NzR8JtstjicYPh/U9Y=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W7rGRw7xJ9j9CSSmtKVJzAnrZ9HKw5x4g6Q
 fvlmyGGcu2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/luwAKCRAADmhBGVaC
 FehDD/9tUv+oBi/X1dqLnHkQjWAAqllp1O9XIJiC0Dmcj8NdKQjiIEJoahbDF1BoadzLSTlRIhG
 A4Ia4k0zHK75I3zk36XIzkn0YkeesqfVpCvK5vIKdcZPe4GPp3NEtPgWRDmyc9smykSu9lcxyGt
 o3l+UDqQoHxbqKwJZH9ShVgldb3vOGhWSCMI2sXQdc3CYDZ7ZxCc3YsKa5ZRB5LOjockkEKYWK8
 p6/cCQQ6VrgkzOzR6kcmCg4RDj2xDwpeWdoJT9ycfMG0UjbmiVkiDGAa4sRYDAVvfy03xNezHyU
 5fyokGDABc5UKt/0cGAZdgST7O+ieCGQbEmmqZpU1+cx+UOOG/2pDPs7oDoXS4jukcCWY/H5GGR
 FUVOQ4/6u1giyiF91KGM6VNNqNpV8VEcv8MEgDz/SAyMMSpT4EVfVtQ4CfbKhLzJPALVtAZeUBG
 iSE5FEWPy5iiIR+EC/zcPL87/uOHshC0KlklvrdJMW94IKhSSDNyw3dkrUU9qEuYOxDTa2qfxvG
 /Hejpi55FfCCR0Ha8ZwN9NZvBz7U51fU3QOgjIbntwAC6kia2Na5SdIB9voB+3l3b9eoMRxPGxT
 biskjjTc1jw8WRjwPA9wlhGjmNGP4Vl8Db8cK9ZzgRfrZxP+iZ8N+sFHZS0E5jwImgp2j1lEnZX
 PrqPNklrdm/ygrQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 19E99140009
X-Stat-Signature: dit59au9mu6bk3fwm9nngrs6dmznx7i5
X-Rspam-User: 
X-HE-Tag: 1767892498-822888
X-HE-Meta: U2FsdGVkX19NcJBIGRO8j3ceJt+Ma+jgPQkFB145veK94KXt/2MzmaOcnVWqDsYhXK5kuzLX3+XkZY1q9OpxxdPhk65lL3XkeCJ3bIWV+eDOFaMof+NshwB5r71NhOcifpbwohFfEbIqvca25N1tlQHpgn3sa443LuJ7XZURvg/dRXXm05JFy7EnpKzwViJMP/VEs+n+9OPKRy2ACWZyR8Y9BWZ9WR9+QzknaSyh/OOi7UwAeWKw3BDBdOvjIywD9tu4nCBvZPDoiIIy59ODxhQ1xsxaHZd4kFeXnnD/DjcrmKmeopmu9ywcXaA63AgF1qUDGRpwDZdu0zceKD575Z8lN4El6XQ4B4rx5UfeXglXXaCHrtYjWxO6onIlIqOmTVBvQ5a4Hi+Rfx5eJKnUZ23NE6s/+zhNt14guXeEEyLwhIEOvjln34ttaoJ5/vNOCh3vrDsX/zaBOwDT/kfOMzK3UUy+LxP98xoePFXRiVp+ON3UMyal8wxKiotUrVkZb4v3z5W63SqmmJu/aNcb+iFPO/BnLw7a1odiQzwzjmZxFlt4o+fZHC4g4jmSaMxnj3Q89D/orv2MKXSzaCLSYIK345aiCQciK+i9jt9Sh5viU+oHKBAgMaSP+5UXu0/Sgtfvq1kzrpJpm6VsJwrPYiM0+w9gQRInTasq++2S9ms+VeF6NX6WGDjvbpkmu5c2jmwFz3LjBLOo8e0f9KJ+StnTMqL9b+WNQrc3KIyqrxNiv/ZfbGau50sn7ciuqcVyMqfMYFbLrSJGrAje8QYLCCbttO3EMocZQi/v2bedt9Df57lO33GEal3xJIzb1bsymZ5VCXBo7rRQkjybqGuK6lukRcH+wQtzzt0eooRHMP8x6Bdr/jzh7N5PK+iAKwAH3vKIQ/L5286VZib4YCjodhRbDlvppqvFICMFPz0GDzdfkZbsSq0y67B4KamJGbMpR8AWBD0X0FLtGxEy7h4
 sQ0jnGvf
 RJwhJuwAYR+40SbQ3FnV83DQxQ3+vWzWLHyF+PjYXvzSP6H2pDFUVaN+47gsXuClnkoS0NCrLvgzB7X85k8OGO1bXPB9qTDUgId71CBde6QxirG+eRyiAoU1WkFRGQkCJJNvMPY2oCus6+dL8B64Gj/L7hG5Fx3GBKYOGkqEpk0cmvQVCGVobxL1I+ZcEMkE5xcQKk7tIvEOAnuKsSgLNdlXDFC9UYVgHNmfPbhzRPvXRvnATcPvMUa8JE6tv533GhCBQWl5mTUHPsCSULFPEskd3XHif7/odFvcJBT31PoedPGprt/s9de4Idw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gfs2_file_fops_nolock() already has this explicitly set, so it's only
necessary to set this in gfs2_dir_fops_nolock().  A future patch
will change the default behavior to reject lease attempts with -EINVAL
when there is no setlease file operation defined.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/gfs2/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 86376f0dbf3a553375b0064c9a1eff3bfa9651f5..6daa96d815e1e30f099938543a0ed19aa90c720c 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1639,5 +1639,6 @@ const struct file_operations gfs2_dir_fops_nolock = {
 	.release	= gfs2_release,
 	.fsync		= gfs2_fsync,
 	.llseek		= default_llseek,
+	.setlease	= generic_setlease,
 };
 

-- 
2.52.0


