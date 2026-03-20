Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB83E1099B4D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4C86B012F; Fri, 20 Mar 2026 18:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17D0F6B0131; Fri, 20 Mar 2026 18:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F5D6B0132; Fri, 20 Mar 2026 18:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E77466B012F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B45398B6CA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:36 +0000 (UTC)
X-FDA: 84567912072.29.C48120B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2F28B4000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oc7nm0wv;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Ad0Ft19XJuChiOcYXF1+sGPODWhdDAyGJfKCFGfkGY=;
	b=5wkv4dbbkNFEdjgD83NTUWC17Otp8c89mRG1rsOugtHDOQ+hOLmt1yea8g1tY7yAhl4S3S
	7EXewWbT5LDR/X0sLEVDtdlvp9EBH5EXMNe7rPdLFzSTEpmthdJlUD2mSF6CFgjeQaPPCs
	uKrIXoFPgzWbTQR41LYcy0ibRTUoEKU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046435; a=rsa-sha256;
	cv=none;
	b=xGhT9rqcVi6Ixv2PvS7V7WUbBh+bbp9TYVfpsDetJTsZE0irMz8rsQMAs7JJGk9Ij6uoch
	AGTKj/hLsD/kpDcEGX6dQX+382MlVBMwCikav8CVo7I0gVSpMCF7l+M8fpRZpZnpXJyJ+a
	U3THtywq2tyW9Sbqr2NdYHfVrQlzBf0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oc7nm0wv;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BBC0D6185E;
	Fri, 20 Mar 2026 22:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D30C2BCB0;
	Fri, 20 Mar 2026 22:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046434;
	bh=zfhQBezGG5IcURkg0NJT+vOaS0gfqxyLqpHHVrI7cmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oc7nm0wvIPI8zRhE2sWNIsoZqJNkcj0rKW7f0P6BhLrYg79O6iX1NqkqqQ80fWOR1
	 /8lL3U0nYtBz34iD8QnhN/OAO9e3BhyKs/Tr+e4lZC2PPMPfdc1irVXs0TrXzvdrLL
	 GULWFOngwHrBiDXdseBMhd9km9NNqODvNvAPRUS667fmC5Z/ZQzeO+wNaVlOCHXIt5
	 pWhoTCZSaXBw8Qo2kr5dSs59RKsbk9m0efXCfRx5rgsTQGkqEayyuTYSQSjLqw56b+
	 eHlg1g5RfTijTn5ubMEusLGvXB8kf3KoxQPbuktXUTyTEnRV487+vCsOxH0mhJsV3K
	 VEOZGrCj6xEOg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v4 10/21] fs: afs: restore mmap_prepare implementation
Date: Fri, 20 Mar 2026 22:39:36 +0000
Message-ID: <ad9a94350a9c7d2bdab79fc397ef0f64d3412d71.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bkegosrsutnud8gn6io5z7shat44hjs6
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F28B4000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1774046435-919498
X-HE-Meta: U2FsdGVkX19SLQ2A8oshjiygmAMffkcd6rZs8hPYeKMAlYYEW6ojY8Ks+VbN6fvOSUDm4zKZiM0HQznJmt/CeMrpqm/zFuBNWf5IfdO3pDcNSM5Acv5EPVeB71wXSc0ytDtFrtB4a8TxZLsPmFQmAAAEFOxIH9x0j0fQusTsWXM7DoxdKLnVasIhcbpZgsMHzqZLtHe7XPgYpmBUyS+WniNhn+/7c4HC5KZFY81/NbPxRNKMbdHehFmvAkRUnfZokVjK7plUgyJCj08dn9QAXfXaY3KZCrydhT4OMp30pqnBt9PoDmFdaBVlx5lVYl1gwb8CDcHcb8BbOPR2Diti34yV1HsqsTeqh6eh4xxT7Hbd0MjLhbHaLXcov79ub91INCW/V4uTkyXNzqUX3+vvK5IYNanXO0AP4D868YhT+srZt6wHEy+KPsRVwaZWQ1vdKhJtYc6WUp/FBpA0d1unRRe6spWoopxBzlS/wITXsbnE4pxXALWRkqDR9M8aVyeZ/4lcScox53z09CRy5YlL+QQjb95lgMtjL3KTetL5VCEmHx7Llqzz26ftEWn7dx4cYpf5X5kNmYiI5tD+REBWAOQNB0ckZqvLPc0UkRxiJUDTJPznmObc0Kbv9q5SOEc0GOvNQS13V+qt0N7CaFbNkbR1AfQKpOPvPyPZiYop+5N46cX2YQqPov9ROnHoPwIodUH3YudgFNiRf5X8fhhmqaufz8Gtc2YDenHKtyDoEvWuppDhzdp3QY9rI+BspNZ7hbeibrxeyXFgsslnlY+g9NMZnWhGmGyv5YRJ6Z0XCqEnFZuyH3JwBLBHoV3KSyZhwM3XNcVyix3RTtKqi1KIgvMGRz5N1GW42aWh4OktEEHToEY7zYA3NhqZUs1vqkybMs+ymxsWaH7jnr9rt78DCnPlwBT73M3xnI6WkkOe2EAz3nfF5iRaIi8ANa89GdxBAuRiL0uo8ppw8og3Z5M
 Ce6fCiK+
 DX8pNsXorB0wwIx4PwlmQOElaNhvpdQjlgzEJ6b3fQmbk+0W2eYky0lFPuzoiWSVBDxzDS3rN3t8dY4ADv/dhTq5BI4ZJVoY3je53J22I3tV9ia7baPNXAJM82n81GSlVctnEdSK3JkrDQ+r0W3sR833tBFqYiMyiLqgA4rd+PWSb1/pkclA+YeCY1+6a5AIrI1W+Cj6BygIW5awikYthwiP6p2Nvsn7ScDHzrLg1EBBh2DQRQi3N7GoPO7IskDWKS4uBG7TjnePVGmb8GzjrAKKJlyUXpmYKQ8pZ3VNzsmHJ3vUbcFsbBF91CyPqjyfpU7RsZS149ENs/ClWT2CXmumglwXuNyJdP0+Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
.mmap_prepare()") updated AFS to use the mmap_prepare callback in favour
of the deprecated mmap callback.

However, it did not account for the fact that mmap_prepare is called
pre-merge, and may then be merged, nor that mmap_prepare can fail to map
due to an out of memory error.

This change was therefore since reverted.

Both of those are cases in which we should not be incrementing a reference
count.

With the newly added vm_ops->mapped callback available, we can simply
defer this operation to that callback which is only invoked once the
mapping is successfully in place (but not yet visible to userspace as the
mmap and VMA write locks are held).

This allows us to once again reimplement the .mmap_prepare implementation
for this file system.

Therefore add afs_mapped() to implement this callback for AFS, and remove
the code doing so in afs_mmap_prepare().

Also update afs_vm_open(), afs_vm_close() and afs_vm_map_pages() to be
consistent in how the vnode is accessed.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 fs/afs/file.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 74d04af51ff4..85696ac984cc 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -19,7 +19,7 @@
 #include <trace/events/netfs.h>
 #include "internal.h"

-static int afs_file_mmap(struct file *file, struct vm_area_struct *vma);
+static int afs_file_mmap_prepare(struct vm_area_desc *desc);

 static ssize_t afs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter);
 static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
@@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
 static void afs_vm_open(struct vm_area_struct *area);
 static void afs_vm_close(struct vm_area_struct *area);
 static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff);
+static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+		      const struct file *file, void **vm_private_data);

 const struct file_operations afs_file_operations = {
 	.open		= afs_open,
@@ -35,7 +37,7 @@ const struct file_operations afs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= afs_file_read_iter,
 	.write_iter	= netfs_file_write_iter,
-	.mmap		= afs_file_mmap,
+	.mmap_prepare	= afs_file_mmap_prepare,
 	.splice_read	= afs_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fsync		= afs_fsync,
@@ -61,6 +63,7 @@ const struct address_space_operations afs_file_aops = {
 };

 static const struct vm_operations_struct afs_vm_ops = {
+	.mapped		= afs_mapped,
 	.open		= afs_vm_open,
 	.close		= afs_vm_close,
 	.fault		= filemap_fault,
@@ -492,34 +495,47 @@ static void afs_drop_open_mmap(struct afs_vnode *vnode)
 /*
  * Handle setting up a memory mapping on an AFS file.
  */
-static int afs_file_mmap(struct file *file, struct vm_area_struct *vma)
+static int afs_file_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
 	int ret;

-	afs_add_open_mmap(vnode);
+	ret = generic_file_mmap_prepare(desc);
+	if (ret)
+		return ret;

-	ret = generic_file_mmap(file, vma);
-	if (ret == 0)
-		vma->vm_ops = &afs_vm_ops;
-	else
-		afs_drop_open_mmap(vnode);
+	desc->vm_ops = &afs_vm_ops;
 	return ret;
 }

+static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+		      const struct file *file, void **vm_private_data)
+{
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+
+	afs_add_open_mmap(vnode);
+	return 0;
+}
+
 static void afs_vm_open(struct vm_area_struct *vma)
 {
-	afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
+	struct file *file = vma->vm_file;
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+
+	afs_add_open_mmap(vnode);
 }

 static void afs_vm_close(struct vm_area_struct *vma)
 {
-	afs_drop_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
+	struct file *file = vma->vm_file;
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+
+	afs_drop_open_mmap(vnode);
 }

 static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff)
 {
-	struct afs_vnode *vnode = AFS_FS_I(file_inode(vmf->vma->vm_file));
+	struct file *file = vmf->vma->vm_file;
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));

 	if (afs_check_validity(vnode))
 		return filemap_map_pages(vmf, start_pgoff, end_pgoff);
--
2.53.0

