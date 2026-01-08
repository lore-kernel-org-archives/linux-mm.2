Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44C6BD1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5B676B0098; Thu,  8 Jan 2026 12:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4AF66B009B; Thu,  8 Jan 2026 12:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3276B0099; Thu,  8 Jan 2026 12:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E9ED6B0096
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:14:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B1D08AAD1
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:23 +0000 (UTC)
X-FDA: 84309445206.14.C4DF303
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4025220006
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZSaPnWwg;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxDU6h8fD93a8T/FHybHd8/P8j79IMMptX36dqNJSKE=;
	b=RPiKNMDiCTudfm265rX8wX7q4PoyfSLYTlPDZukUQWkMy9FJJCpVrOC0zAhlQt3TE+ViFy
	vO1o08doMHE9DSX/tqn3mWMFHsgxq57aIDuLxnebIsQmJhEy3nUzAByQJgWJHb+hGscI3v
	UvopSh7jcxBLJ4u1A4wWyDAUa/4iXRU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZSaPnWwg;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892461; a=rsa-sha256;
	cv=none;
	b=CZn2qAdHN79rilX4p1Yz9aCEjXYtIMa0/c4gk2yPZJo3jML4mi51WJZ4jGjt4uXrnUfdQP
	dBatDjTjsCN7kCvDebJINaz2z4RHYEXqFyjNyRWJbfWDlv+m8QdT9vIP7SDJPhAvtjCZjI
	nYiiPeU9hWC+4W48U8gEDsDQ/upbC6Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5959942D65;
	Thu,  8 Jan 2026 17:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C1FC116C6;
	Thu,  8 Jan 2026 17:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892460;
	bh=oF6oBWJVqDuAAjKOQDrehLsz3iDowLXPik5JXzWYc9k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZSaPnWwgsRoKS590NDK2nAb5RgiDV815lEy8151AZJxlLARMNFc8t5dQmMkUz0JST
	 rhKyFwUz1dAGUm2NJr8lAPlp3DwDOHv/02nIAnvGd2M3IupL9oZhj0Grg9oVi4lN4w
	 g7D3z2STHURmDZ7NplBhcLcj2za4gZrXAivQc4lPJdJghdWPCkspzxfRd6035DGdLn
	 2CdUmU6nzbxgjhHov4TVJabLWt5UsKGi/wQpmKn+Y5aGNWkmIaPLTlfGqI9EjM04b5
	 SrCcVTmQGHH/I/azeRLaSBDgCI3GPNs34GWUzC/P/4BqmjEidn0sUaA6O/AFyqFh6q
	 wdrZtmGzHbQUw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:00 -0500
Subject: [PATCH 05/24] ext2: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-5-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1749; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=oF6oBWJVqDuAAjKOQDrehLsz3iDowLXPik5JXzWYc9k=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W51+myyOp3T7N9nKeOj1w9UGryiKEWXK2c4
 uBs1ppIWy6JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/luQAKCRAADmhBGVaC
 FRkZD/9X9AfDEXdOTU0p1NyunRENOiWMn7NFym0pJGC1a/vMqoagJhOg8DJ6MWl0AR4frQh9bjS
 RRdYTAntz/vRZdUXQNmip65bTzlDHP+7il44wPVMcjDwHIsz/pUXTZ8ZNiOAV1M30DKxFJ9CT3u
 PdA9yreUBmEt/UK4x4lDQYF2NTE/9bbfJyB+jEe6nZoAWmq9g5u2qXSDCWUAoaJMshmpGRsAT9b
 iFxzTB72klqyvrmWMKxhZBRZ7rOm2zCChTQJjZ3/SIQPBG5ZVNNy45nlpsM5xHtfjk1j1n0c1rR
 nrs6DQmLE9iFxTz7Ls8SOyBXRP58fsWMaOjwWX3QAQjt9zdsJY/xkWuEg4E9VMD874HkO7HNI/G
 JO0oJrQplsRc/CdexbsnS88REfIKqU+aHZrP7FcdSMkiJkUllzUIg6KsHM1NeBhRaOKJu8BOVJl
 vP9oTLwaLmDSKUTSEmJuGeYeZGycAu7M3/Gjg5DMImjB8r7YXFJ+i6AwSZhrbin+pvpRRt5YdNG
 tS85T0sG8bfmsbqZA+Ehp5mxN15t+NE0o8yVF91nO8z++bAqPBiK11NiIq/J9xBYUp3zqQchc3c
 JtymSVf1sO2KPVdy+/ujVxsyUinNYAssa0lgopwLrTE1n2rzFWAEuElJ4wunlge9cvt2wpYCZNv
 NTn8dDHxmIim2RQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 14snjnrepo9dkuhisybhid51karah74y
X-Rspamd-Queue-Id: 4025220006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767892461-157003
X-HE-Meta: U2FsdGVkX19YLdvwaYAvMC86KpxcTfX2zTjGPDsuSJZKgHljco8T3iCfYgPclXTopD65HXrrUjuai3jOdnEbvf1osO/GXNQLEb+V5VSgfEwdQmdIpZ4mIVkBw57yj+fApkyUwvpqiiB4jONEsUxZaaEA6b7nI0XP2HMhCzUTA2TTNRjkBtQYaxncetM5nMmHDs5KaR2BvM1zLUnxYNhx0InIy+h0oiXse2H0EO3Wa8bG5s0obvUgQTlipRAYOVGs6ySJsaGKrL78w9X18n+3bqb++nHXDXytIkOCVUufpjBarHo63fuCI3bGZGxvT0R95aqKIG5jQscrRsd8J+mMYTtufZHGdderfrzDV10zumAyd335xt2/uwiuD3rtEhDaHXB8SpdlrSloBvzArcrpdMnqvQaxvut047J3HbKyPLzc/4349OZgFK9YaNQKjD2MUouQdrh9Yy7JQBV2ZKEsTXwO53zk+vFRpJSr04/PjaLBERfqbx1zEQj7qfv95u/bAgsarTSIs8mHtIY9eaGLMf2rFKruFlxltA/rWZ/+0zdriiW+4T8/cy1DT5KvHrFz6lCRHTKx9gV/mneVrwIf8BWKpGicqe7u5zUKyNGaUiiPecaJwKzg/wPhlknwiVPb9s8YmEc6uKMsOQQdN/NaoeA383a5Y2mNOCIYUflHRfAeAOAR+tnDYQ31ABN9SkdZZ4Nk7mrwFlvfIlpKVU8ZM9oedXU1RADALEpaxy020NRWH2fyZetV900e/8LaQHwKQcwfc5g3SuJmkh/BiRyy403suGqKUeQmAx4KEUbv5ThJlKGjLuj9w+WL5W7am2j21baOvb5Sdo6sfdpE3gt51p57wIarZD8+NOOYbHd+QgvRunLp++UXrfZVubzbke94KvWd0iTdv7lGG+PLjVLHznQs9CycfipizSGETit9eo28VU6yoU8/jUUCmhO4SbrfU7dnWnkzDEvluO9hf13
 V5diHfD1
 fQ0f4ikC2Il4yo68rZhlpQYkWhB2i+pEhVVoHs0ulRxDWKzDAQvl/4ltQnqvmyb0e1gg+8xMFg7iI05tiV1Su+5GxwXSPrUF0wpResE8L8ZpXyEATChbWKZ2U8WcpXWUYNQOW0luEMfSpqDaXu1AIQjhMDx4Uc/tJg+AVFvHsTTYW7pFBqsnTaXzix8d21jPn72wUQGe50b5L2qKbUSBLw7CuuyHOC42IXmX65AM6eIu4mDxYkhzf3tketKcLODUbiDgcrOf0uX8lJnNL+HrCZ8qP7Q1FiCj6JsIUGHLMiCiiBa1mSNnzizilO2rBxoG1CSEqKPbknGSXcGnh17MfrxYi3cO54qSipkCh0DJG8KwAdyIBjtsCIE3ZSCU5h81ylnDy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation to ext2_file_operations and
ext2_dir_operations, pointing to generic_setlease.  A future patch will
change the default behavior to reject lease attempts with -EINVAL when
there is no setlease file operation defined. Add generic_setlease to
retain the ability to set leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ext2/dir.c  | 2 ++
 fs/ext2/file.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index b07b3b369710c4848d6091742cdd0b5c42d4674d..395fc36c089b7bb6360a8326727bd5606c7e2476 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -24,6 +24,7 @@
 
 #include "ext2.h"
 #include <linux/buffer_head.h>
+#include <linux/filelock.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/iversion.h>
@@ -734,4 +735,5 @@ const struct file_operations ext2_dir_operations = {
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
 	.fsync		= ext2_fsync,
+	.setlease	= generic_setlease,
 };
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 76bddce462fced77b24d64416cb9fdb172d8270b..ebe356a38b185e0d8662f704ad20e42fe618284e 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -22,6 +22,7 @@
 #include <linux/time.h>
 #include <linux/pagemap.h>
 #include <linux/dax.h>
+#include <linux/filelock.h>
 #include <linux/quotaops.h>
 #include <linux/iomap.h>
 #include <linux/uio.h>
@@ -325,6 +326,7 @@ const struct file_operations ext2_file_operations = {
 	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
+	.setlease	= generic_setlease,
 };
 
 const struct inode_operations ext2_file_inode_operations = {

-- 
2.52.0


