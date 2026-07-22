Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E015C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEDE66B00A3; Wed, 22 Jul 2026 09:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5C16B00A4; Wed, 22 Jul 2026 09:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDB316B00A5; Wed, 22 Jul 2026 09:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97E8B6B00A3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:07:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06D0B140188
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:07:03 +0000 (UTC)
X-FDA: 85016437926.21.9C4B0DE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 095511A000B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:07:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ki6qfqx2;
	spf=none (imf19.hostedemail.com: domain of BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784725621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6NGYVGoDNv5DzPxbrC6+XyBR93vPnYxvEZjsgBrOkY=;
	b=lc8gHQCRxoHi2ELWYnksS5Uy4z0TTVDL3suj5ZkHQYwLMNz9uQ2xcvGeAPUFByDb1NH+P0
	3DBbNuZWnBHhp3JVVubVvd5IGt3RtckID5kYdS8WJv4M73qbmsTraeaTDGuDjclwN7MuEg
	7s6BReBukN1RFi60u1Btdv7mF2y5Wzw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ki6qfqx2;
	spf=none (imf19.hostedemail.com: domain of BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784725621;
	b=I2DOy6ED/EaSzH6R/k05HiIOK3+UW4pJnPT9mtX0c35eXCySr3QFoBjcp59BAyHzciWBu/
	eRgc0IfRiF+1dENzRqA34LClC0mShsRfOo30/RbDddMzenaMMVFT0C+HOV8SiWuH8tAwfB
	S7bOq4zM3tkKlmQbfPaNFfd+fdDWzUM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=L6NGYVGoDNv5DzPxbrC6+XyBR93vPnYxvEZjsgBrOkY=; b=ki6qfqx2y3YAnvxI4tGgMsCmJS
	G8dchq2FCO2JFWduQDRgo4pWtuJZUVutGnIovf5Zz8yxevdkip+e+WmzpgHbImp/DeFziZry9Qh+C
	qmBY9XSp4yYnbDwFm33M9/fbhEXeTkb5+tozSpVYhQBZuOUNFg0IjyhXjxNGUc2fX6splp7yftdem
	U90xfk60qrLvKOoX9tSZ5e1uMp4vooSRL5FZNQKuzciPWT6Z0Js8Zql++kgpHV/nGEfmHuH70DUfS
	zWNZVf6rSXFiGPto2gDUM4I4CDJuENYBQuWA5YG/a25G6MqS+mci1e6atquQdGv+YYZHGE+BLZqRO
	/mfbD9ag==;
Received: from [2001:4bb8:2d6:3a78:eb21:714c:af4c:ee7d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmWew-0000000Bpss-42a5;
	Wed, 22 Jul 2026 13:06:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	ryncsn@gmail.com,
	trondmy@kernel.org,
	anna@kernel.org,
	sfrench@samba.org,
	linux-mm@kvack.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: [PATCH 3/3] mm/swap: move swap_ops into file systems for file system-based swap
Date: Wed, 22 Jul 2026 15:06:09 +0200
Message-ID: <20260722130615.3163560-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722130615.3163560-1-hch@lst.de>
References: <20260722130615.3163560-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 095511A000B
X-Rspam-User: 
X-Stat-Signature: i6tq1awri7n7asz3o3q4b1hj5cqrcom7
X-Rspamd-Server: rspam04
X-HE-Tag: 1784725620-577379
X-HE-Meta: U2FsdGVkX19KzwXyRhbp4FKQLL00V0goooOZrk5Vs4IDpjItMk+zvSJ2aWM5Lo/V7itqL0uI+XQuJDk4nn5vbEo7b0pd41PtR6B89lePP2NrsYmJEHhi0zKBWSxi4TyzFC0e/zg0a4LuRniqLdv/vduYoSkKolMVMhdzxgH8L/YbNj6ElTFUajUsfEmbFyG1rNAvqfCiGDpolGAMEi9B15uiRM9jms8ijahGMOjJ9Kj77sI4E2GvE5kVcdH/Czo/OoOm9PNkEHNok2BwvTIKiX2z4Hc/iK2KRnpPG6YWVRx0BFTgjjZVAd39cUU1u2IccHluw4Oiibo9doB+Ht7nSquF8TrDXenyUcpGCSaF9IRXy+I9RqD85xgjkZBDxhQpukKzDC8eStepDvNKaf8i9ZavCfrKa4VlLJTCP/RpbxjWyYvbXDh4uGR/VuyMyaDmv56KmQRWZB7MfvFpHjVnpxhoIs9JUOYBwUtUSqRLb/7rx2kLHgYHLilFdwE1dYH3sioH6MAyyPiwPB20Wee6w+LIS3l+NbMZLR3EUNxTtver4WedKKfOJ4dTBrXL0wYFOC4BVhrmmk/BOChQ1Qp0shfk2B0HYpTKRQSa5QUf6cKJOOiS8RNIQqlrUHay5agZgW2b8KWkrpFM1fb+F1zlsUPVEc7vwlxt+Zlhed+Ujr7vf7qswRe9vYuQKuO8zrK+Uu/Mc0dCcXxZwrCoPsbtewa1yXWRYE0sgOnOCoIQTdYxYcFkx/ivDtVUHpouvYFV/uajYDA6Br6zAKowCfWtx74XCafs1GSWXdOdSh5sgO8AA6SQJwB8w2IQfoWq+XzH2GDzyzy/RFhqPD37BN4qRdgkj/+80eCjd0T1jleadwOXYVqjnvhE1wEhcvgLbnTD2W6RVvjxbTrjEA/sXy6mr45D8/JYzSKGgXW/yaHO4Y7NI1tZRcLwILWf0oqniORjeXDdGaLakf3NzJ7+w17
 C6lrIaTx
 +zFIKlrXR7f23F31kU2/qRQ0OhAnbzTgwjN4PXnufmDCmCBCRfHqcdMzI+S20b7FFLYQjHrKpsWj/jo56TmrixKYqstOrNdVFpY+r7oIzWZLD4LeeGqfyNsc9pkHFhnJg3uOPSS+rsYNGejXibJ1K6YKo+FQs0L6r1ZY8r6dhv6XCw5y52xeIlcgZaDuj13bxNHudvK0o8wKHlTzxmd4MwTJK1DPIPHUitwC1CKYzrqSmIYKADmZrDLaijP5FoPPJlg9q36BMnO8EAkevadwKeTbD2LkO6AJBx15xXhbP93wbvR/RwTWN/OhX13+J7CEoKBtf6yEzCuuGmSy/n7LT1iQ4JSVM3WW6oCPdA5h+oCok7AqAyiGNtgneHk2AWYU9dS3E6qxzGrkpIpfdQoczGXPdqFRLZWcw0laH3IkhYGb5cJCloKSamdV67kN7SLajb0xinNOT0sW7VkuD9Gdx8lDfDtj/Tm5hrrQbgMV7k/ah4LqBER+vrnV27gmY4Zz3qMKgCnO9+Hlgfj2tFLNks6OhJbxyrJhv0gJMc26yXeuL7l5v3C7gm+6DgOK4uuQtUEiXr+0GBPAm1iLwQPcyhIBsn3+kD6BuTzX7IUW9k3IloFFUCOxVzj0mG8WZuL7gl0Q/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently swap to and from file systems goes through two indirect calls
between the swap ops and the swap_rw method.  Reduce this by directly
providing the swap_ops from the file system.

For this refactor swap_fs_submit into a swap_fs_prepare_rw helper that
initializes the iov_iter on the callers stack so that file systems can
call it directly, and use that to initialize file system specific ops
in NFS and the SMB client, which then get passed to swap_fs_activate.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/filesystems/locking.rst |  9 +---
 Documentation/filesystems/vfs.rst     |  8 +---
 fs/nfs/direct.c                       | 20 ---------
 fs/nfs/file.c                         | 42 ++++++++++++++++--
 fs/smb/client/file.c                  | 63 +++++++++++++++++----------
 include/linux/fs.h                    |  1 -
 include/linux/nfs_fs.h                |  1 -
 include/linux/swap.h                  |  6 ---
 include/linux/swap_ops.h              |  5 +++
 mm/page_io.c                          | 34 +++------------
 10 files changed, 93 insertions(+), 96 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 1a50d41a39a1..f58a8d7d5897 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -266,7 +266,6 @@ prototypes::
 	int (*error_remove_folio)(struct address_space *, struct folio *);
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
 	int (*swap_deactivate)(struct file *);
-	int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
 
 locking rules:
 	All except dirty_folio and free_folio may block
@@ -291,7 +290,6 @@ is_partially_uptodate:	yes
 error_remove_folio:	yes
 swap_activate:		no
 swap_deactivate:	no
-swap_rw:		yes, unlocks
 ======================	======================== =========	===============
 
 ->write_begin(), ->write_end() and ->read_folio() may be called from
@@ -355,15 +353,12 @@ should perform any validation and preparation necessary to ensure that
 writes can be performed with minimal memory allocation.  It should call
 add_swap_extent(), or the helper iomap_swapfile_activate(), and return
 the number of extents added.  If IO should be submitted through
-->swap_rw(), it should call swap_fs_activate, otherwise IO will be submitted
-directly to the block device ``sis->bdev``.
+the file system it should call swap_fs_activate, otherwise IO will be
+submitted directly to the block device ``sis->bdev``.
 
 ->swap_deactivate() will be called in the sys_swapoff()
 path after ->swap_activate() returned success.
 
-->swap_rw will be called for swap IO if swap_fs_activate was called by
-->swap_activate().
-
 file_lock_operations
 ====================
 
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index e7677423a20f..c437a342d4f3 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -776,7 +776,6 @@ cache in your filesystem.  The following members are defined:
 		int (*error_remove_folio)(struct mapping *mapping, struct folio *);
 		int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
 		int (*swap_deactivate)(struct file *);
-		int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
 	};
 
 ``read_folio``
@@ -977,16 +976,13 @@ cache in your filesystem.  The following members are defined:
 	can be performed with minimal memory allocation.  It should call
 	add_swap_extent(), or the helper iomap_swapfile_activate(), and
 	return the number of extents added.  If IO should be submitted
-	through ->swap_rw(), it should call swap_fs_activate, otherwise IO will
-	be submitted directly to the block device ``sis->bdev``.
+	through the file system it should call swap_fs_activate, otherwise IO
+	will be submitted directly to the block device ``sis->bdev``.
 
 ``swap_deactivate``
 	Called during swapoff on files where swap_activate was
 	successful.
 
-``swap_rw``
-	Called to read or write swap pages when swap_fs_activate was called.
-
 The File Object
 ===============
 
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index e626c72495e6..ccafdc1ce64d 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -145,26 +145,6 @@ static void nfs_direct_file_adjust_size_locked(struct inode *inode,
 	}
 }
 
-/**
- * nfs_swap_rw - NFS address space operation for swap I/O
- * @iocb: target I/O control block
- * @iter: I/O buffer
- *
- * Perform IO to the swap-file.  This is much like direct IO.
- */
-int nfs_swap_rw(struct kiocb *iocb, struct iov_iter *iter)
-{
-	ssize_t ret;
-
-	if (iov_iter_rw(iter) == READ)
-		ret = nfs_file_direct_read(iocb, iter, true);
-	else
-		ret = nfs_file_direct_write(iocb, iter, true);
-	if (ret < 0)
-		return ret;
-	return 0;
-}
-
 static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
 {
 	unsigned int i;
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 851d93a09988..e1bdd10b35f1 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -29,9 +29,8 @@
 #include <linux/pagemap.h>
 #include <linux/gfp.h>
 #include <linux/rmap.h>
-#include <linux/swap.h>
 #include <linux/compaction.h>
-
+#include <linux/swap_ops.h>
 #include <linux/uaccess.h>
 #include <linux/filelock.h>
 
@@ -575,6 +574,38 @@ static int nfs_launder_folio(struct folio *folio)
 	return ret;
 }
 
+#ifdef CONFIG_SWAP
+static void nfs_swap_submit_write(struct swap_io_ctx *ctx)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct iov_iter iter;
+	int ret;
+
+	swap_fs_prepare_rw(ctx, WRITE, &iter);
+	ret = nfs_file_direct_write(&sio->iocb, &iter, true);
+	if (ret != -EIOCBQUEUED)
+		sio->iocb.ki_complete(&sio->iocb, ret);
+}
+
+static void nfs_swap_submit_read(struct swap_io_ctx *ctx)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct iov_iter iter;
+	int ret;
+
+	swap_fs_prepare_rw(ctx, READ, &iter);
+	ret = nfs_file_direct_read(&sio->iocb, &iter, true);
+	if (ret != -EIOCBQUEUED)
+		sio->iocb.ki_complete(&sio->iocb, ret);
+}
+
+static const struct swap_ops nfs_swap_ops = {
+	.flags			= SWAP_OPS_F_REQUIRE_NOFS,
+	.submit_write		= nfs_swap_submit_write,
+	.submit_read		= nfs_swap_submit_read,
+	.can_merge		= swap_fs_can_merge,
+};
+
 static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 						sector_t *span)
 {
@@ -597,7 +628,7 @@ static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	ret = rpc_clnt_swap_activate(clnt);
 	if (ret)
 		return ret;
-	ret = swap_fs_activate(sis);
+	ret = swap_fs_activate(sis, &nfs_swap_ops);
 	if (ret < 0) {
 		rpc_clnt_swap_deactivate(clnt);
 		return ret;
@@ -620,6 +651,10 @@ static void nfs_swap_deactivate(struct file *file)
 	if (cl->rpc_ops->disable_swap)
 		cl->rpc_ops->disable_swap(file_inode(file));
 }
+#else
+#define nfs_swap_activate	NULL
+#define nfs_swap_deactivate	NULL
+#endif /* CONFIG_SWAP */
 
 const struct address_space_operations nfs_file_aops = {
 	.read_folio = nfs_read_folio,
@@ -636,7 +671,6 @@ const struct address_space_operations nfs_file_aops = {
 	.error_remove_folio = generic_error_remove_folio,
 	.swap_activate = nfs_swap_activate,
 	.swap_deactivate = nfs_swap_deactivate,
-	.swap_rw = nfs_swap_rw,
 };
 
 /*
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 081bb16abeb4..190e24199fa1 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -20,7 +20,7 @@
 #include <linux/delay.h>
 #include <linux/mount.h>
 #include <linux/slab.h>
-#include <linux/swap.h>
+#include <linux/swap_ops.h>
 #include <linux/mm.h>
 #include <asm/div64.h>
 #include "cifsfs.h"
@@ -3351,6 +3351,38 @@ void cifs_oplock_break(struct work_struct *work)
 	cifs_done_oplock_break(cinode);
 }
 
+#ifdef CONFIG_SWAP
+static void cifs_swap_submit_write(struct swap_io_ctx *ctx)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct iov_iter iter;
+	int ret;
+
+	swap_fs_prepare_rw(ctx, WRITE, &iter);
+	ret = netfs_unbuffered_write_iter_locked(&sio->iocb, &iter, NULL);
+	if (ret != -EIOCBQUEUED)
+		sio->iocb.ki_complete(&sio->iocb, ret);
+}
+
+static void cifs_swap_submit_read(struct swap_io_ctx *ctx)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct iov_iter iter;
+	int ret;
+
+	swap_fs_prepare_rw(ctx, READ, &iter);
+	ret = netfs_unbuffered_read_iter_locked(&sio->iocb, &iter);
+	if (ret != -EIOCBQUEUED)
+		sio->iocb.ki_complete(&sio->iocb, ret);
+}
+
+static const struct swap_ops cifs_swap_ops = {
+	.flags			= SWAP_OPS_F_REQUIRE_NOFS,
+	.submit_write		= cifs_swap_submit_write,
+	.submit_read		= cifs_swap_submit_read,
+	.can_merge		= swap_fs_can_merge,
+};
+
 static int cifs_swap_activate(struct swap_info_struct *sis,
 			      struct file *swap_file, sector_t *span)
 {
@@ -3361,7 +3393,7 @@ static int cifs_swap_activate(struct swap_info_struct *sis,
 
 	cifs_dbg(FYI, "swap activate\n");
 
-	if (!swap_file->f_mapping->a_ops->swap_rw)
+	if (swap_file->f_mapping->a_ops != &cifs_addr_ops)
 		/* Cannot support swap */
 		return -EINVAL;
 
@@ -3392,7 +3424,7 @@ static int cifs_swap_activate(struct swap_info_struct *sis,
 	 * but we could add call to grab a byte range lock to prevent others
 	 * from reading or writing the file
 	 */
-	return swap_fs_activate(sis);
+	return swap_fs_activate(sis, &cifs_swap_ops);
 }
 
 static void cifs_swap_deactivate(struct file *file)
@@ -3408,26 +3440,10 @@ static void cifs_swap_deactivate(struct file *file)
 
 	/* do we need to unpin (or unlock) the file */
 }
-
-/**
- * cifs_swap_rw - SMB3 address space operation for swap I/O
- * @iocb: target I/O control block
- * @iter: I/O buffer
- *
- * Perform IO to the swap-file.  This is much like direct IO.
- */
-static int cifs_swap_rw(struct kiocb *iocb, struct iov_iter *iter)
-{
-	ssize_t ret;
-
-	if (iov_iter_rw(iter) == READ)
-		ret = netfs_unbuffered_read_iter_locked(iocb, iter);
-	else
-		ret = netfs_unbuffered_write_iter_locked(iocb, iter, NULL);
-	if (ret < 0)
-		return ret;
-	return 0;
-}
+#else
+#define cifs_swap_activate	NULL
+#define cifs_swap_deactivate	NULL
+#endif /* CONFIG_SWAP */
 
 const struct address_space_operations cifs_addr_ops = {
 	.read_folio	= netfs_read_folio,
@@ -3444,7 +3460,6 @@ const struct address_space_operations cifs_addr_ops = {
 	 */
 	.swap_activate	= cifs_swap_activate,
 	.swap_deactivate = cifs_swap_deactivate,
-	.swap_rw = cifs_swap_rw,
 };
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 50ce731a2b78..87b5e9957c00 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -438,7 +438,6 @@ struct address_space_operations {
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *file,
 				sector_t *span);
 	void (*swap_deactivate)(struct file *file);
-	int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
 };
 
 extern const struct address_space_operations empty_aops;
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index ec17e602c979..764056498eba 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -548,7 +548,6 @@ static inline const struct cred *nfs_file_cred(struct file *file)
 /*
  * linux/fs/nfs/direct.c
  */
-int nfs_swap_rw(struct kiocb *iocb, struct iov_iter *iter);
 ssize_t nfs_file_direct_read(struct kiocb *iocb,
 			     struct iov_iter *iter, bool swap);
 ssize_t nfs_file_direct_write(struct kiocb *iocb,
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0544b2ec4c56..d8584f53a6e4 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -334,8 +334,6 @@ extern void __meminit kswapd_run(int nid);
 extern void __meminit kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
-
-int swap_fs_activate(struct swap_info_struct *sis);
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
 int generic_swapfile_activate(struct swap_info_struct *, struct file *,
@@ -461,10 +459,6 @@ static inline bool folio_free_swap(struct folio *folio)
 	return false;
 }
 
-static inline int swap_fs_activate(struct swap_info_struct *sis)
-{
-	return -EINVAL;
-}
 static inline int add_swap_extent(struct swap_info_struct *sis,
 				  unsigned long start_page,
 				  unsigned long nr_pages, sector_t start_block)
diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
index e92b4f532604..57ac6c703f68 100644
--- a/include/linux/swap_ops.h
+++ b/include/linux/swap_ops.h
@@ -36,4 +36,9 @@ struct swap_ops {
 	void (*submit_read)(struct swap_io_ctx *ctx);
 };
 
+void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter);
+bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
+		size_t prev_folio_size, int rw);
+int swap_fs_activate(struct swap_info_struct *sis, const struct swap_ops *ops);
+
 #endif /* _MM_SWAP_OPS_H */
diff --git a/mm/page_io.c b/mm/page_io.c
index e741e67d6592..88962571cb93 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -650,11 +650,9 @@ const struct swap_ops swap_bdev_ops = {
 	.can_merge		= swap_bdev_can_merge,
 };
 
-static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
+void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 {
 	struct swap_iocb *sio = ctx->sio;
-	struct iov_iter iter;
-	int ret;
 
 	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
 	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
@@ -663,40 +661,22 @@ static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
 	else
 		sio->iocb.ki_complete = swap_fs_read_complete;
 
-	iov_iter_bvec(&iter, rw == WRITE ? ITER_SOURCE : ITER_DEST,
+	iov_iter_bvec(iter, rw == WRITE ? ITER_SOURCE : ITER_DEST,
 			sio->bvecs, sio->nr_bvecs, sio->len);
-	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &iter);
-	if (ret != -EIOCBQUEUED)
-		sio->iocb.ki_complete(&sio->iocb, ret);
 }
+EXPORT_SYMBOL_GPL(swap_fs_prepare_rw);
 
-static void swap_fs_submit_write(struct swap_io_ctx *ctx)
-{
-	swap_fs_submit(ctx, WRITE);
-}
-
-static void swap_fs_submit_read(struct swap_io_ctx *ctx)
-{
-	swap_fs_submit(ctx, READ);
-}
-
-static bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
+bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
 		size_t prev_folio_size, int rw)
 {
 	return swap_dev_pos(folio->swap) ==
 		swap_dev_pos(prev_folio->swap) + prev_folio_size;
 }
+EXPORT_SYMBOL_GPL(swap_fs_can_merge);
 
-static const struct swap_ops swap_fs_ops = {
-	.flags			= SWAP_OPS_F_REQUIRE_NOFS,
-	.submit_write		= swap_fs_submit_write,
-	.submit_read		= swap_fs_submit_read,
-	.can_merge		= swap_fs_can_merge,
-};
-
-int swap_fs_activate(struct swap_info_struct *sis)
+int swap_fs_activate(struct swap_info_struct *sis, const struct swap_ops *ops)
 {
-	sis->ops = &swap_fs_ops;
+	sis->ops = ops;
 	return add_swap_extent(sis, 0, sis->max, 0);
 }
 EXPORT_SYMBOL_GPL(swap_fs_activate);
-- 
2.53.0


