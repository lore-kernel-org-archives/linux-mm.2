Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B06BCCD184
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 02:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43348E0007; Sun, 12 Oct 2025 22:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B358E0002; Sun, 12 Oct 2025 22:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930DF8E0007; Sun, 12 Oct 2025 22:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 843188E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:58:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2882985624
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:58:36 +0000 (UTC)
X-FDA: 83991583032.07.A408C3E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id B881B4000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:58:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pgQEnUky;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf07.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760324314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lj0S3vmb6d6s8d0aaOlI5MPqL6b+xgrnGX6hOqz1wwY=;
	b=XeV59GQrNIKAIvSe2H8CpXqe1STUJjk+kx2TQqvd/CIN1mzRM+y2CaVizdIqiTL5Rt/a8A
	hIWvl4RBx1h9YsbxjoH4My6e65ooz5YlI4Xuqs75bNZ/1NuUFLusQSf0cILUtAHz6XBKBu
	tV1cBKtf/NBrvVEP01nA8a7i53mFSAY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pgQEnUky;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf07.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760324314; a=rsa-sha256;
	cv=none;
	b=Mp0I1hQBSHIbssWYO52cu7tFDWH2DSK+Jk1z9jU2ZlCb2REGMGWfZqXvaYBccH8afLmFkk
	2ZJgLa9Db9ZG+S1JdgG8TqjrKc5KbuDnFBj8ME0OD2nSiYOYaFwkNNT+WDvHIRmr43C4Qm
	ViFf6JPMQWBzI+n7KjOxMbmhMyRLgo0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Lj0S3vmb6d6s8d0aaOlI5MPqL6b+xgrnGX6hOqz1wwY=; b=pgQEnUky4Ql91uLX3wxEvBkqfg
	Y5kAKuNYys7DA+Bdzoel/fuaJiYGe+yhJC40tdLtCmysJJmXsjU7NWrXctWPSuOKQd2KVl8e2cKNf
	vfKkVLHEa4wyUGUZ3BwaGLIy79HIiReJSvlaIdamBqQYFc/m+FOjw4daFqRcvHHYFc/nIXvJrCsJZ
	R5ftvFBbGFHhDVk6Z+T7I0h/7k4zlDlbVmAwuMtgIiixL8gp97UMYAnraPIxl5BBu85JDsneKe5qz
	xqCiWkuFZudZ97TBpTgw80q4gaZ425/EZZPUU92LFfnQu6Y0AeErFsIsOrun2fhPEWl9YnV6Y1Uu2
	A17JVs6w==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88lZ-0000000C86m-3JLa;
	Mon, 13 Oct 2025 02:58:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/10] 9p: don't opencode filemap_fdatawrite_range in v9fs_mmap_vm_close
Date: Mon, 13 Oct 2025 11:57:57 +0900
Message-ID: <20251013025808.4111128-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013025808.4111128-1-hch@lst.de>
References: <20251013025808.4111128-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: B881B4000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 8uymuhz73fs5jbc1wc851snhgukdksob
X-HE-Tag: 1760324314-785449
X-HE-Meta: U2FsdGVkX1/XMNpXxgdG4EqrQrvNv8LzVt8x+6igzS8CZaiC41JFF33t0sWqcjoBjFEP2LS8KZ+3gQDxHZ7HyyQojAe4flUWCmFu5HIBKgW4KVuoX98sVwzCIevHlq9ryn/1eEKxcgTkIAUH8bxNWw7xCGQXEFV0XbMWFHbaeNwHHHWuAE/bfw3rJwJExPWT5oDyKE87K4YCzeWBFRfJ9kFZ2cJEk9PLpps+x4OxCr0bBTz4UF1PPf1Eo8VFfuH8vY9Uk6y/MGAXlOHY7s3ploHZ2M65lq8hZvHyOHckJvctJx/0t+Z/b68kZpru9zgR0GzjdJE6kYSAaU3FTmxVHTvptNXWzR0zJTqcVQQWj/FZQXE+TUBdIIC+/ywAOgIWD4l85unqpe0DyoKbOlJoFAVfj+r6JGA6PhbTJ/dSg4/afIij+zzK2FQ/yaw9Nmc2iCoDrBzwDWmDZZfmaUKGIYJdnm5UmCDN98yMX2jFVeJmCYhTVEMwasYe3YpHbXTmZhlvu9T+c+Z7UffFXZIbAmiIlqD/0pGFGsU6i5FIGFsmMY787t59s8mpuep87wuCDhmgovWQgO05FZ79p6gUXQomI+PvUXXrcNMvQtdrY4YUY4+OoTHWqqXGcULCuv0oG28AgmDvk9t1FGV8uoNVDJvrcmhDmeb6YM1fRIMlKMr3+JYNHbcdaYrvqcU/kMIZcxw2YmRQuFnhHrVulj+lynjVV/FPKEgsXCmlhVD32kViyAfERyXrrSWmZdD9H+lOF4DzL/tuTfYmktDPyJ+MXlQOHatuKVPUg7nXhEgNGB9zv5bjbG5da3g+Lb57LbnJJLhyD8xFAifMPC/Vv2hsA13zsvGZMWU1YDcXzcr1M7t+yKng87n3MZI/5XkR1VcYcKm5S4M4qEnB9/cbknyD0JPtKN4Wq85jpdER7C+uI9nF8iCCYLwYn6RU254yEF3gCb8D7e0+kKQ5REWsvOy
 FNZcDoiP
 qXq1XaLbP5uOvbYG86T0wI+F8d6ex24dOIII1hh3vXKFVgfC/NDRlBpKvDiB84iGBqPtPKeAeQg33LXB8KFoIfoUqiD48vX1f8926RjUOvN3xHHsBZlBgVftfj94HRM9lR+N2g7qVDnsX47TlB3Ns2cdtcE8DWZfFQhXk7peafmJfW6XshOb8a0hCrNyorA18bSsT4rKe6yETzoIgsYgZEOJWlkv0b24IcMMb/UwrlUU5H1kn4PTuBmzIqTRjvYTJaFEUQeCSQV3pj6WK6w4N+K1T6lG39EccECtySHwHJkDMgjjZwiGYA727mdY066DDkWZwoC6/pvAM72Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use filemap_fdatawrite_range instead of opencoding the logic using
filemap_fdatawrite_wbc.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/9p/vfs_file.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index eb0b083da269..612a230bc012 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -483,24 +483,15 @@ v9fs_vm_page_mkwrite(struct vm_fault *vmf)
 
 static void v9fs_mmap_vm_close(struct vm_area_struct *vma)
 {
-	struct inode *inode;
-
-	struct writeback_control wbc = {
-		.nr_to_write = LONG_MAX,
-		.sync_mode = WB_SYNC_ALL,
-		.range_start = (loff_t)vma->vm_pgoff * PAGE_SIZE,
-		 /* absolute end, byte at end included */
-		.range_end = (loff_t)vma->vm_pgoff * PAGE_SIZE +
-			(vma->vm_end - vma->vm_start - 1),
-	};
-
 	if (!(vma->vm_flags & VM_SHARED))
 		return;
 
 	p9_debug(P9_DEBUG_VFS, "9p VMA close, %p, flushing", vma);
 
-	inode = file_inode(vma->vm_file);
-	filemap_fdatawrite_wbc(inode->i_mapping, &wbc);
+	filemap_fdatawrite_range(file_inode(vma->vm_file)->i_mapping,
+			(loff_t)vma->vm_pgoff * PAGE_SIZE,
+			(loff_t)vma->vm_pgoff * PAGE_SIZE +
+				(vma->vm_end - vma->vm_start - 1));
 }
 
 static const struct vm_operations_struct v9fs_mmap_file_vm_ops = {
-- 
2.47.3


