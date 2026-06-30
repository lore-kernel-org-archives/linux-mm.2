Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ACB3C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 18:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148516B00A9; Tue, 30 Jun 2026 14:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8796B00AB; Tue, 30 Jun 2026 14:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A616B00AC; Tue, 30 Jun 2026 14:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C415B6B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:31:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 416A21205F8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:31:11 +0000 (UTC)
X-FDA: 84937421142.14.8BA53EF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1F5481C000E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:31:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=g3UoGDoz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ta6n1aUP;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=g3UoGDoz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ta6n1aUP;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782844269;
	b=HTowZyLqZ+CK7DudhKJZywWAkGy2c8+o1uZ4rDprl1XJdwwkanDdlSbvc8ghRoiPInEHwY
	xqsS86VH8E/VkTlICH9IMdItVaNYA8RQquG3+APnCHFHAmtLQhL8gbH1vjn5N5Mm+yPXpZ
	4eRJXT+ws/Hwd3NB7j7JQvnJIc/OYX4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782844269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mU8FzwXctUR/PxXeIEd6XhA5si5vC1kRVBGbfPOCGCo=;
	b=J9XhaKYTsBnvtbP1Vn5tjTonTqP0PcYe+S62NcTnBbb0kJeZuRRjLii5WM4QCAD199gtfK
	qLVsC6/qSQUKbpFBlCGl5ZZIvrcVJAlQe1kZgkxtGNZSYo/5U7flWyi+wbBrfmpDYY6c8b
	WlkgEIkc5XboXm/p36l4naAC3+6C7L4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=g3UoGDoz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ta6n1aUP;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=g3UoGDoz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ta6n1aUP;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 993C8736A6;
	Tue, 30 Jun 2026 18:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782844267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mU8FzwXctUR/PxXeIEd6XhA5si5vC1kRVBGbfPOCGCo=;
	b=g3UoGDozpKNrTrpCTewdzW6hDWOnKcvFzikZ5WTozmwcmfdels4BSJu0Jb/laTXa3hRlBN
	EacZPomiwlX52XRjWF+Bj5fVhsd0gwei0wcKiKTCECQSegvS0P4smGKAYXgC/DY843bL6o
	gNliXQ/M3kjDpqyfANik1Zi6CKBHDlQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782844267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mU8FzwXctUR/PxXeIEd6XhA5si5vC1kRVBGbfPOCGCo=;
	b=ta6n1aUPYiqSF+UBgmUWCEcge4k4qQdy+01PvEuiyB+oV3Ot/SKuMx3VuB0cMDbK4FZ7dL
	dDpUKLV2O07KWgAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782844267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mU8FzwXctUR/PxXeIEd6XhA5si5vC1kRVBGbfPOCGCo=;
	b=g3UoGDozpKNrTrpCTewdzW6hDWOnKcvFzikZ5WTozmwcmfdels4BSJu0Jb/laTXa3hRlBN
	EacZPomiwlX52XRjWF+Bj5fVhsd0gwei0wcKiKTCECQSegvS0P4smGKAYXgC/DY843bL6o
	gNliXQ/M3kjDpqyfANik1Zi6CKBHDlQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782844267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mU8FzwXctUR/PxXeIEd6XhA5si5vC1kRVBGbfPOCGCo=;
	b=ta6n1aUPYiqSF+UBgmUWCEcge4k4qQdy+01PvEuiyB+oV3Ot/SKuMx3VuB0cMDbK4FZ7dL
	dDpUKLV2O07KWgAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A0972779A8;
	Tue, 30 Jun 2026 18:31:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dnq8I2oLRGpTcAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 18:31:06 +0000
Date: Tue, 30 Jun 2026 19:31:04 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Gregg Leventhal <gleventhal@janestreet.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Eric Hagberg <ehagberg@janestreet.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Message-ID: <akQIIav_zaK6RmIC@pedro-suse.lan>
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sgcbtvevrg4dwu7g"
Content-Disposition: inline
In-Reply-To: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F5481C000E
X-Stat-Signature: 9uact5id9xigs5dfhgnt7h1p867r3eit
X-HE-Tag: 1782844268-19121
X-HE-Meta: U2FsdGVkX1/XrGOzquS3YTnEkgY56jHOJz0mv9Q0sjXZInBsnzWGI2S/0Zb8HAGIcSJ/yHzdQlWeyu88DwjgxlczMChf3/mRGFJsMxvvHKUP4qRGqYGidt8zSx4lAwr3srwI9hUt9pFO3z261vP7vLBCMCSDe87cboNg99BHmwZcjgYUvHqd4765MYjwV4tWEu3G2voR/Kc0hwIrcMX8fNlHLr+p3+s5SgYmvkfNn6TthXxzEQyyA0msulHOhANy0xd9pqtEPI3cfO0rmUqcs/X6Neq/WQofrLwTKlw+ZLWawrMUlo29LkuPgxvDDhkbNr7XBVbX1xDmDTj7i4/4yzL7LtfXYELNf6ghs+cUSdrisCGw8C+pbKZfcl6HiWkzSfT5pXxjqZJLHkpYWEy8umq08FozUrLe2+ooRZtgc4pmXS1UCv3RP8HZ4bC7WmSsi6RCWZzNEDh5Y21SGSBF1xcr2frXmUJxXtOsvu/B17rc8tJfo+Ttk99R3bOfH6snWlw8IbqbdakLGjkpraF6g/teOYpNMG7CmwUmQy8h9bse8Qa2qcRA/QrUSqCqIazUmj7LAlfgpli+cWyAfKwj4BdoZJAFmtzi8TcQJdwBFoufWLDl9W8mX+NYCb3qBgXRVhOgG83de681q3sEDSFLqiRpxN5tGX635ak2oTuwC5Xv76btAEWxKlsKn2PMy7eQijIAqgQsSRC+lPot6wHejPF/MbMlCQasxpXeDKfS380VaqtsbNeqx/Y6IQLkmAUp8QWHNutUb3qXIRqaKPy97jBLCpNFbo8Lyz2NulRCHtWUT1t4C4BKcYUnJxXuSaGSs17iTkWtUr7KLlHp/sb2hETXC2kRsoNvdwc90jJ4DMAyjLt2IqA9F1DKbfeTnd/ifR+/w5rEGC3yOjCiAYcqBH6EXM3OWpozDTAU848KNWpbGb4F+E4u6ANnASyvnZ15sssldqhXgGTL6DMNc65
 CtP2V040
 gBWlDqHJFLF+Zl0ZLM27Tgo8J+zjJ1WP5AE5jxJvzJCZSNVakRXyKuDpVuajBXtd9YXOzKDWuLiot4jx4qBylhl7BsAG+XXhK0ROSHqCRC7Xd/pblrBc83UTW0ipQ2Vi94zUfgskmBtFNAKRUdusJ9R1ldM6Z1DJIH6LF0lHiK2h7ZoE7D6WlqUknNOql9nwVA8pkEz7tj/1tHoSX6Ctd/Sgq4PQATnsSp9A25d/mT1INRkc46HM4R0/evStY7h0P7TeFGENPpX0lMHHrUOMN37RvPHdVgNpTFP7nqVmtCEb7uajDFWlNdT3xuWuUU+yj2tTZ5fzHOhmMoiE56T+Hx9YJ4zTXvonYTTzXWsr8WIMLkDbURFhSzbkyZVvxcIs8e69M4fKjX1hDIE72GnfpbaFyl7SR0w8ki3H22mxNqF9jjq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--sgcbtvevrg4dwu7g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

+CC some relevant THP folks
Quick note, your email client's spacing seems to be all over the place, making
this extremely hard to read.

On Tue, Jun 30, 2026 at 01:01:53PM -0400, Gregg Leventhal wrote:
> Hello,
> 
> We (Gregg Leventhal <gleventhal@janestreet.com> and Eric Hagberg
> 
> <ehagberg@janestreet.com>) have a reproducible data-loss issue involving file
> 
> THPs and write-open, impacting filesystems that do not support
> writable large folios.
> 
> 
> Attached are:
> 
> 
>   - thp_write_open_cancel_dirty_repro.c
> 
>   - thp-open-writeback-before-purge.patch
> 
> 
> 
> Summary
> 
> =======
> 
> 
> On an affected 6.12 kernel with CONFIG_READ_ONLY_THP_FOR_FS=y, a file can
> 
> contain read-only file THPs installed by khugepaged / MADV_COLLAPSE. When that
> 
> same file is later opened for write, do_dentry_open() notices
> 
> filemap_nr_thps() and drops the page cache:
> 
> 
>         /*
> 
>          * XXX: Huge page cache doesn't support writing yet. Drop all page
> 
>          * cache for this file before processing writes.
> 
>          */
> 
>         if (f->f_mode & FMODE_WRITE) {
> 
>                 if (filemap_nr_thps(inode->i_mapping)) {
> 
>                         struct address_space *mapping = inode->i_mapping;
> 
> 
>                         filemap_invalidate_lock(inode->i_mapping);
> 
>                         unmap_mapping_range(mapping, 0, 0, 0);
> 
>                         truncate_inode_pages(mapping, 0);
> 
>                         filemap_invalidate_unlock(inode->i_mapping);
> 
>                 }
> 
>         }

Ugh, this is embarassing. So, good news: this code doesn't exist anymore
in mainline! Bad news: it exists on every other upstream-stable-maintained
release :|

FWIW I don't think your fix works, there's still a race there (what if
you write and wait, then someone dirties a folio, then you truncate the
pagecache? you lost data again.). I'm attaching a very quick WIP patch
that I wrote against 6.12 LTS (again, this does not exist in mainline).
I _think_ we want to go roughly in that direction, either here or in
collapse file paths. There are still problems which are invasive and
I haven't dealt with (GUP and other "temporary" folio releases being
the main one). Some of these problems may simply make it so opening
these files writable may fail (there is certainly, AFAIK, no way of
waiting for GUP and other temporary folio holders).

We would probably be served with a custom loop that forcibly yanks
only THPs out the pagecache, though. But that requires a bit more
code for a stable-only issue...

Anyway, the patch is obviously ungood and uncromulent and is only
here for a rough conversation starter. I don't think it works and
it will probably never work. mapping invalidation is simply too
best-effort for something that Just Needs(tm) to work.

-- 
Pedro

--sgcbtvevrg4dwu7g
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-foo.patch"

From 22c7255577e1efbca5186fa3a3afadf714743647 Mon Sep 17 00:00:00 2001
From: Pedro Falcato <pfalcato@suse.de>
Date: Tue, 30 Jun 2026 19:13:20 +0100
Subject: [PATCH] foo

Not-Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 fs/open.c               | 15 ++--------
 include/linux/pagemap.h |  1 +
 mm/fadvise.c            |  2 +-
 mm/internal.h           |  3 +-
 mm/truncate.c           | 63 +++++++++++++++++++++++++++++++++++++++--
 5 files changed, 68 insertions(+), 16 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index be7b55260a75..8feaf87c06b8 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -985,18 +985,9 @@ static int do_dentry_open(struct file *f,
 		 * cache will fail.
 		 */
 		if (filemap_nr_thps(inode->i_mapping)) {
-			struct address_space *mapping = inode->i_mapping;
-
-			filemap_invalidate_lock(inode->i_mapping);
-			/*
-			 * unmap_mapping_range just need to be called once
-			 * here, because the private pages is not need to be
-			 * unmapped mapping (e.g. data segment of dynamic
-			 * shared libraries here).
-			 */
-			unmap_mapping_range(mapping, 0, 0, 0);
-			truncate_inode_pages(mapping, 0);
-			filemap_invalidate_unlock(inode->i_mapping);
+			error = filemap_truncate_thps(inode);
+			if (error)
+				goto cleanup_all;
 		}
 	}
 
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 68a5f1ff3301..401b03970f68 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -67,6 +67,7 @@ static inline int filemap_write_and_wait(struct address_space *mapping)
 {
 	return filemap_write_and_wait_range(mapping, 0, LLONG_MAX);
 }
+int filemap_truncate_thps(struct inode *inode);
 
 /**
  * filemap_set_wb_err - set a writeback error on an address_space
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 588fe76c5a14..c44a7a11eee2 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -156,7 +156,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 			lru_add_drain();
 
 			mapping_try_invalidate(mapping, start_index, end_index,
-					&nr_failed);
+					&nr_failed, NULL);
 
 			/*
 			 * The failures may be due to the folio being
diff --git a/mm/internal.h b/mm/internal.h
index 3bfc1dc2d7ea..83e3bbbe18a6 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -407,7 +407,8 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
 long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
 unsigned long mapping_try_invalidate(struct address_space *mapping,
-		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
+		pgoff_t start, pgoff_t end, unsigned long *nr_failed,
+		pgoff_t *first_fail);
 
 /**
  * folio_evictable - Test whether a folio is evictable.
diff --git a/mm/truncate.c b/mm/truncate.c
index fb5c20b57bd4..3efcadd2be4f 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -490,12 +490,14 @@ EXPORT_SYMBOL(truncate_inode_pages_final);
  * @start: the offset 'from' which to invalidate
  * @end: the offset 'to' which to invalidate (inclusive)
  * @nr_failed: How many folio invalidations failed
+ * @first_fail: What was the first offset to fail invalidation?
  *
  * This function is similar to invalidate_mapping_pages(), except that it
  * returns the number of folios which could not be evicted in @nr_failed.
  */
 unsigned long mapping_try_invalidate(struct address_space *mapping,
-		pgoff_t start, pgoff_t end, unsigned long *nr_failed)
+		pgoff_t start, pgoff_t end, unsigned long *nr_failed,
+		pgoff_t *first_fail)
 {
 	pgoff_t indices[PAGEVEC_SIZE];
 	struct folio_batch fbatch;
@@ -504,6 +506,7 @@ unsigned long mapping_try_invalidate(struct address_space *mapping,
 	unsigned long count = 0;
 	int i;
 	bool xa_has_values = false;
+	bool has_failed = false;
 
 	folio_batch_init(&fbatch);
 	while (find_lock_entries(mapping, &index, end, &fbatch, indices)) {
@@ -529,6 +532,9 @@ unsigned long mapping_try_invalidate(struct address_space *mapping,
 				/* Likely in the lru cache of a remote CPU */
 				if (nr_failed)
 					(*nr_failed)++;
+				if (!has_failed && first_fail)
+					*first_fail = folio_pgoff(folio);
+				has_failed = true;
 			}
 			count += ret;
 		}
@@ -560,7 +566,7 @@ unsigned long mapping_try_invalidate(struct address_space *mapping,
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t end)
 {
-	return mapping_try_invalidate(mapping, start, end, NULL);
+	return mapping_try_invalidate(mapping, start, end, NULL, NULL);
 }
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
@@ -864,3 +870,56 @@ void truncate_pagecache_range(struct inode *inode, loff_t lstart, loff_t lend)
 	truncate_inode_pages_range(mapping, lstart, lend);
 }
 EXPORT_SYMBOL(truncate_pagecache_range);
+
+int filemap_truncate_thps(struct inode *inode)
+{
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t start_index = 0, first_fail;
+	unsigned long nr_failed = 0;
+	int err;
+
+	while (filemap_nr_thps(mapping)) {
+		nr_failed = 0;
+		first_fail = 0;
+		filemap_invalidate_lock(mapping);
+		/*
+		 * unmap_mapping_range just need to be called once
+		 * here, because the private pages is not need to be
+		 * unmapped mapping (e.g. data segment of dynamic
+		 * shared libraries here).
+		 */
+		unmap_mapping_range(mapping, 0, 0, 0);
+		lru_add_drain();
+		mapping_try_invalidate(mapping, start_index, LLONG_MAX,
+				       &nr_failed, &first_fail);
+		filemap_invalidate_unlock(mapping);
+		if (!nr_failed)
+			break;
+		/*
+		 * The failures may be due to the folio being
+		 * in the LRU cache of a remote CPU. Drain all
+		 * caches, do writeback and try again.
+		 */
+		lru_add_drain_all();
+		/*
+		 * We now know that up to first_fail, there are no THPs. Start
+		 * from there to ensure forward progress.
+		 */
+		start_index = first_fail;
+
+		/*
+		 * Attempt to writeback. If it fails, it's ok to fail the open. There's not
+		 * much we can do in that case.
+		 */
+		err = filemap_write_and_wait_range(mapping, start_index, LLONG_MAX);
+		if (err)
+			return err;
+	}
+
+	/*
+	 * It should not be possible to hit this case after the above loop
+	 * completes.
+	 */
+	WARN_ON_ONCE(filemap_nr_thps(mapping));
+	return 0;
+}
-- 
2.55.0


--sgcbtvevrg4dwu7g--

