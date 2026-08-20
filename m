Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39022C5DF89
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB336B00A6; Thu, 20 Aug 2026 15:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D976B00A7; Thu, 20 Aug 2026 15:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74BB26B00A9; Thu, 20 Aug 2026 15:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47C316B00A6
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:34:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B3A414021D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:34:09 +0000 (UTC)
X-FDA: 85122648618.25.2E8C492
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 267CB20003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:34:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=c0JOFDjn;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787254448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1vvnVo1qN72SUUfR1JNLXgFtnDutTVMaAZGTKbqCPk=;
	b=pjjunrhPxrnpzmtdxgQD4wJe6QgZHmNDK2ADq3waZKSNHj1beEf3J5henTBV+zYnIuQL1T
	GyNam0dQ6OFPFe8YHv9viAGVsNoHOk4x2Fs2lyeG38W8crhtp3NYqTflJ+se0gHGoWuBjN
	sxKrPkQlRdhAkEzO9oYjcUjOklM29VY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787254448;
	b=QUD9o1q4SxHLc6ZBTxQvsOuW7Uj45MSPKHNQyXI/9zFnbFDSclSTFKweWVDTXen4PRR6p0
	BBwRwYge+qwhWCKf2izHbMLJsAGunUxtuVPROIxwI4ql3InxoHSIVLo7P6Mq+hLyb7S8gF
	m/ObEDsFj3my/38q5IM4XqWzt8Vn6Dc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=c0JOFDjn;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=z1vvnVo1qN72SUUfR1JNLXgFtnDutTVMaAZGTKbqCPk=; b=c0JOFDjnq5+Q3iuUmyoZ/KXCC/
	0dp/pEOPqaxq681nb8dhxypup5ezuM0vnxiMcxGmY4OFP8fWY2yyJqvx/rp6xuk/AuRT/Dd4OBIk3
	zkrbV7TkD+j2Xvx3d83NE75fnefLTo7KvhhXTeQlUkJEH8KmpIYcLno3JO+/Q2Ro7UBR32K3AERO5
	Qvh+FkwGEeSdmlfQNEaTFPyvJ/wEPf/HNfbB6hhFzfsMeJeBLbWpNy1JAdWNoBCg1lFhf7LbgzJLx
	28ROfB3JkhRlbVxV9M6QbPOQ8WpJ7e8t4Eifi2SNjELqznhL011t2n9mAPNtbb7teYNStDhOvLKV2
	DqD0iRVw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wx8WH-0000000GALl-1nPQ;
	Thu, 20 Aug 2026 19:33:45 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	devel@lists.orangefs.org,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 7/7] Remove folio_launder()
Date: Thu, 20 Aug 2026 20:33:40 +0100
Message-ID: <20260820193343.3852967-8-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260820193343.3852967-1-willy@infradead.org>
References: <20260820193343.3852967-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wre8648q8w9pofd5msw9bgwcr6c596kd
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 267CB20003
X-HE-Tag: 1787254448-506480
X-HE-Meta: U2FsdGVkX1+U8LOLecHL24WUcUZVYd+ev5jp+bIl+q8VAhOzdXyUh7+XeyKBDh9lKNXi23izzeZq5N3ukv1EmlKJkXVKlcvZOXEQaU3AHb+mJk7yTdtnu87BV8kvfXD/dcg9HspwjYu14ry6gWvgkM9YOguzHJkPUJnbsm8kB3ssjqb6IJNQ31MwXfn/dWxdpauLxIW2EuQR4vRuMFomd0iJEazUgnezPruoIiBfxtRLO5gIjqBs0ooy9xzu4WHD/j3Uh7SN3qk6ggta6GDtmZ9bLyvxPV16XKbbCAffyOniY9NR1/4HuXs4xrzmH9zZKiaYBxYLpsTsiNELEIHtp+e6LdLGQr+WSurGCDXa6Ei7oslKqL6oV5Yuqj7vasAuV4er2Ou8lwEnhQoeF+kGT+onu0eaphiCMIMq3Kn/KAtlcsRDkqfx7EFLFmppTPVJyLKYYf5xWSKaIWjg9SC3RYZhp0B1zS3oIzQsxS/1g02FFnkfoNl8tfrl9B//YfPO+ayn7uJKZfV7YEPj+9qAwmFi+oR04H4F64qvK4kCYcsILAfqpB9Cb61sXgPBwdQnM1IeL2VeNRcA31/yl06SCaNwb0kSkoMVP0a/uPw+EJq47h1FOaKAdyAMn5n4XXT2wbAGHvG5hhFwiAgxPvkL9gBZ7PnNE6O391HmK9Rd6Q8PGai/Vrz/WH+jOsltaESK6ziNubRZQS7riOugiJz4d/co79bCOi88I+vlU5jnaLWRVna6v1A8F5m42OtuxTsFQVeW/TQwV5NccFHTKn9Md/Fca91LKvIqAdfu7ANNPUGM/psXa8vqLyoEwSqCBX+JkmS8sV3UUkhyGH3dIObaIbAz/VPkJGzy0M1M1yVcHrdNxnazSxvKIi+mr855/Dc6Jopcn5cd1RslWr+ab4zNhBa6Djl1C+7JkOgXhi6JaMAQjqnDwpLqORH59Am/8z/tHJYYJrS9u8qJCPpPvJ5
 A4Vb0iDy
 PDnJg8vKHjs2SJ4hLrb4jKLR70PaOV3S5zlewadyl0th5qeGV/IZTMZGFxnTDXOtcunU0N+IFFw35lV8ajGL+LmZ95SzIIGlJmzvItvt8QJ9OkMVeQk2BQR1p3HYO/z9dSoo8Dyd1ouIVgBUH+e5HugwMfXyVKr5TpAT+IVHx3/1676gCBFVwWJ/aqnVuGk313NtBa9WdgpuM7ffFhpo8hvhC655We0w0DhSai64RVSgZB/8+G1c0OEwqsj7hRsmSLSyPF/3eKrFFh4z1oRHy+1NvTFYPRjlXATBj9Px+LjouB8IYSKBovF9cTtRsLh05RNL/DOZoDzUWZ8aiKvke5/PVc9mjymLLWpEhN2cIzbFz+rXqbiRbiHieNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we do direct I/O, we need to evict any page cache that overlaps
the range in the file.  First we write back any dirty folios in the
range, then we lock each folio and remove it from the CPU page tables.
This leaves a wide window for userspace to re-dirty the folio by storing
to a shared writable mmap.

Many filesystems respond to this situation by failing the call to
release_folio(), but some try to writeback the dirty folio again, formerly
in their release_folio() method and now in their launder_folio() method.

Remove this inconsistency between filesystems by checking
whether the folio is dirty in the VFS and failing the call to
folio_unmap_invalidate().  Since we hold the folio locked and unmapped
at this time, there is no way to dirty the folio after this point.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 Documentation/filesystems/locking.rst |  8 --------
 Documentation/filesystems/vfs.rst     |  6 ------
 include/linux/fs.h                    |  1 -
 mm/truncate.c                         | 15 ++-------------
 4 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 08d01bc62c31..fd11f5c5d91e 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -261,7 +261,6 @@ prototypes::
 	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);
 	int (*migrate_folio)(struct address_space *, struct folio *dst,
 			struct folio *src, enum migrate_mode);
-	int (*launder_folio)(struct folio *);
 	bool (*is_partially_uptodate)(struct folio *, size_t from, size_t count);
 	int (*error_remove_folio)(struct address_space *, struct folio *);
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
@@ -286,7 +285,6 @@ release_folio:		yes
 free_folio:		yes
 direct_IO:
 migrate_folio:		yes (both)
-launder_folio:		yes
 is_partially_uptodate:	yes
 error_remove_folio:	yes
 swap_activate:		no
@@ -344,12 +342,6 @@ try_to_free_buffers().
 ->free_folio() is called when the kernel has dropped the folio
 from the page cache.
 
-->launder_folio() may be called prior to releasing a folio if
-it is still found to be dirty. It returns zero if the folio was successfully
-cleaned, or an error value if not. Note that in order to prevent the folio
-getting mapped back in and redirtied, it needs to be kept locked
-across the entire operation.
-
 ->swap_activate() will be called to prepare the given file for swap.  It
 should perform any validation and preparation necessary to ensure that
 writes can be performed with minimal memory allocation.  It should call
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 7c753148af88..bff64713bd09 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -768,7 +768,6 @@ cache in your filesystem.  The following members are defined:
 		ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
 		int (*migrate_folio)(struct mapping *, struct folio *dst,
 				struct folio *src, enum migrate_mode);
-		int (*launder_folio) (struct folio *);
 
 		bool (*is_partially_uptodate) (struct folio *, size_t from,
 					       size_t count);
@@ -942,11 +941,6 @@ cache in your filesystem.  The following members are defined:
 	folio to this function.  migrate_folio should transfer any private
 	data across and update any references that it has to the folio.
 
-``launder_folio``
-	Called before freeing a folio - it writes back the dirty folio.
-	To prevent redirtying the folio, it is kept locked during the
-	whole operation.
-
 ``is_partially_uptodate``
 	Called by the VM when reading a file through the pagecache when
 	the underlying blocksize is smaller than the size of the folio.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 50ce731a2b78..e0f4f518fe24 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -428,7 +428,6 @@ struct address_space_operations {
 	 */
 	int (*migrate_folio)(struct address_space *, struct folio *dst,
 			struct folio *src, enum migrate_mode);
-	int (*launder_folio)(struct folio *);
 	bool (*is_partially_uptodate) (struct folio *, size_t from,
 			size_t count);
 	void (*is_dirty_writeback) (struct folio *, bool *dirty, bool *wb);
diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..7f7d65fa926a 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -603,15 +603,6 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
 }
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
-static int folio_launder(struct address_space *mapping, struct folio *folio)
-{
-	if (!folio_test_dirty(folio))
-		return 0;
-	if (folio->mapping != mapping || mapping->a_ops->launder_folio == NULL)
-		return 0;
-	return mapping->a_ops->launder_folio(folio);
-}
-
 /*
  * This is like mapping_evict_folio(), except it ignores the folio's
  * refcount.  We do this because invalidate_inode_pages2() needs stronger
@@ -623,7 +614,6 @@ int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 			   gfp_t gfp)
 {
 	void (*free_folio)(struct folio *);
-	int ret;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
@@ -631,9 +621,8 @@ int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 		unmap_mapping_folio(folio);
 	BUG_ON(folio_mapped(folio));
 
-	ret = folio_launder(mapping, folio);
-	if (ret)
-		return ret;
+	if (folio_test_dirty(folio))
+		return -EBUSY;
 	if (folio->mapping != mapping)
 		return -EBUSY;
 	if (!filemap_release_folio(folio, gfp))
-- 
2.47.3


