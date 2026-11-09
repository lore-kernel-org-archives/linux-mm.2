Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3702C606D805
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rHEGSCfy
Received: by kanga.kvack.org (Postfix)
	id 5489C6B05B8; Mon,  9 Nov 2026 05:34:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520686B05B9; Mon,  9 Nov 2026 05:34:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E2D6B05BA; Mon,  9 Nov 2026 05:34:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1206B05B8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:34:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A840B405B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:34:54 +0000 (UTC)
X-FDA: 85415222508.17.794C5DA
Received: from mta1.migadu.com (out-64.mta1.migadu.com [95.215.58.64])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7AE42160005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:34:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rHEGSCfy;
	spf=pass (imf08.hostedemail.com: domain of qiliang.yuan@linux.dev designates 95.215.58.64 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794220492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7zFSuRHxbLKvLhaBXFfwZSQS8Ww63rMzgnhGg9p6Q8=;
	b=GYVE6SZzn05feAad5Q6S1FUo6W0l4DmPAvWmZlZF4QtH9ZqVa4D+H5/lFm5GZ2kvJdr4oO
	bTAa58Q4sE1yoDVt/Q/+JYjq6WpEj+xrOvq9MRjIKX0TizdM8HSyZMqXvlKx6NqB7Dbl8v
	I8iNEga9E46OAzHIjDlcsTCOi0Gdw60=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794220492;
	b=0sj5RKhAy/O3w03Elp7I/MiATVB09a1omziD15O90rIr/qPpRau10RSTvqIrRQLklbT7K8
	+ptl6FraorHAjH8wto+H8k2i3RC8SJ6Bs+jyrEaZbcMBi0qc49MI1tsRfolTbFyX31AHi9
	uEseHIrjsFukLsK5ao/IENhIvSgTnAg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rHEGSCfy;
	spf=pass (imf08.hostedemail.com: domain of qiliang.yuan@linux.dev designates 95.215.58.64 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZowXYPpehaGrr4w7J2ZcT85zAd1vaHLiUEOsJbbNAQU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794220490; v=1; x=1794825290;
 b=rHEGSCfywrL7dGE5Au+uLy5I7FAEkuO+lt7l/b6GHu7OIP0LAtf9nnaoxBMhQvoBQRQFiRW9
 8W5rr4/d+JxYqC3r3ZweVR9i4iGDH1L8dXAq3K+Wjuxp5EtPTHFlazYcMdsGnCbTYXbHTmnpxk/
 KMaAADfF5n+MNPMhRoTq4JGI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4a2580fc19b1d598;
	Mon, 09 Nov 2026 10:34:50 +0000
X-Mizu-Trace-ID: 4a2580fc19b1d598
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Mon, 09 Nov 2026 05:34:12 -0500
Subject: [PATCH v2 2/3] mm/filemap: read ahead downwards on descending
 VM_HUGEPAGE faults
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-bug-mm-mmap-readahead-descending-v2-2-abac52890a9c@linux.dev>
References: <20261109-bug-mm-mmap-readahead-descending-v2-0-abac52890a9c@linux.dev>
In-Reply-To: <20261109-bug-mm-mmap-readahead-descending-v2-0-abac52890a9c@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Vishal Moola <vishal.moola@gmail.com>, fujunjie <fujunjie1@qq.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>, stable@vger.kernel.org
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam06
X-Stat-Signature: qcgw16msj7z7na855xcw3swfxwakppmx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7AE42160005
X-Rspam-User: 
X-HE-Tag: 1794220492-315646
X-HE-Meta: U2FsdGVkX18Cl8ysdsr4U86BKFfI+EWaQ90UXoxpvxdLNsefTiaXydmA8P80Ym2CblZoMzRwKArI8mabZ8O3TvRbQYh3gjckPIkMxsINc3HNl+Dm5QErct4LSov90DFJTLKMfvAhS/6atLRlSypnWubZd7QME/FO+6hvFw6w/HpNlUCEwwAM5Ec4UZSuhTFIbz151RRgdXiTqkMN0qTX7yVrBg1dRB+DCAuZSe8ZuVS843iO1qkX2Zbpj/o75CKa9rtNskIPbmq8fGKpV9nLHVAKnkStj4qKHhbQu0zWVYTsn4dxC0bd5LDltt9Vb8Y2bAHur0JibMUe/ItVrJvrzlrcQMqFqLvsDpFdlIREDaYhRSfUmDxGN/yAg2EbnWMqM7QtsF5v0kZpY4wjuWC+rW21CJiCkskxZVEq7ngKo1OBejTy4kd7nzMENkdqAweuLHaZDkbAc6/UagBPhstvl8ewHzo5jlgUUN5X/VsVG/+0anf2c+scZgedPxDY2PlwwKkn6gZIPQ5Q/9BnnLk3IRdvwn8RhphnwFtkPclsTyA17wtf+ByjGMr1rFx1AOJyM04MoYbcA6lt12g38t7lQ2or3usi11eIDNEeMZhKTcqSuLtnyCWDSukvz4ZB3q3tksjpByj3PmK0I3/pouPDxXsYNrw6SFk7kHYKLTso94+wrZA66DOKoDJ2rm8q/FusEUqURDQnQKLXk2mJGvvwXKO/eN49wgmclaaAdthARa26nNcOTgFQJX0HApbHu8HyiGlYTRvb3Of6ZLoCXlSkGbqevy9+wr3bk20T5uSGDx3fM84jrLysE/D8L5HR5lV7amJCMsh0Xdaf622OLt98I1MURjCmV++pkVq7MIskAuOnTqqxkgqvWhu9vHhi/GGMQzXFHtpW3IQAKLqZE28oxDMBU6SfCEqNWdn12Ks1h2+4npdx3poYB/iKTSuYYwFw1BCbt0iqTNgEsTOlgT7
 q4XBYmXb
 SUJ/c+Ec/PFqzzOGX6iA4q3N48gd+YGJqjYDCb2PUCVoogCkKlAMllU6foJ2EcShm0R1wD1guSNghEngfqh1m7LkeDq0gzEV+PVvsdWaSzrPHUTwPk39brTNw0SONOhkyJDTV4CE3uBxLIq1N/RSDWH30gf3T7oeXTbOZ4xANPmMsc/vX7uTNILWQdJsAcwJCDwrcBko2KfFEPzqo6qF1ERxhwyJDsk0wjZ7T90cijKynpIoryyHeako+lVFqwQ4M7CMnKUMa2LhgIYK/98RQvzx89UIA984wdaa1+7NcaYg4Dpp5y5z4XFKJ5YDaFAjKAC/eLJxGLuMD76lh4BqASFiOIHK6AzLlq14TRZyx24NFvg5aISu/jqHizAK9cQ6pRX7H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a VM_HUGEPAGE file mapping, a synchronous fault reads the PMD-sized
folio that holds the faulting address and the one above it, and maps
the faulting folio with a PMD. do_sync_mmap_readahead() counts each such
fault in mmap_miss and stops reading ahead once it passes
MMAP_LOTSAMISS, while filemap_map_pages() lowers the count for faults
served from the page cache, but only when it maps them with PTEs.

A reader that moves towards lower offsets, such as memmove() copying
backwards out of a mapping, never finds its next folio cached: the
folio above is the one it just read. Every folio is a miss and none is a
hit, so after about a hundred folios mmap_miss passes the limit and
every page after that is read on its own. Since the PTEs mapped around
a fault no longer count as hits, nothing lowers the count for it.

When the folio above the faulting one is cached and the one below is
not, read the folio below instead, without a readahead mark, and count a
PMD mapping of the faulting address as a hit the way a PTE mapping is.
Such a reader then misses on every other folio and hits on the rest.
Reading one byte from each page of a 2 GiB file, last page first, in a
MADV_HUGEPAGE mapping with a cold page cache, read_ahead_kb 8192:

                   before       after
  time            42.83 s      0.57 s
  major faults     473189         514

Fixes: 0b9c0aeba938 ("mm/filemap: count only the faulting address as a mmap hit")
Cc: stable@vger.kernel.org # 7.2.x: needs the previous patch
Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 mm/filemap.c | 48 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c38f0e4cf6123..e445279cc561f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3336,6 +3336,27 @@ static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
 	return 1;
 }
 
+/*
+ * Whether a miss at @index, right below @nr cached pages and right above
+ * @nr uncached ones, comes from a stream that runs towards lower offsets.
+ */
+static bool filemap_descending(struct address_space *mapping, pgoff_t index,
+			       unsigned long nr)
+{
+	void *entry;
+
+	if (index < nr)
+		return false;
+	rcu_read_lock();
+	entry = xa_load(&mapping->i_pages, index + nr);
+	rcu_read_unlock();
+	if (!entry || xa_is_value(entry))
+		return false;
+	return !filemap_range_has_page(mapping,
+				       (loff_t)(index - nr) << PAGE_SHIFT,
+				       ((loff_t)index << PAGE_SHIFT) - 1);
+}
+
 /*
  * Synchronous readahead happens when we don't even find a page in the page
  * cache at all.  We don't want to perform IO under the mmap sem, so if we have
@@ -3409,13 +3430,20 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		ractl._index &= ~(folio_nr_pages - 1);
 		ra->size = folio_nr_pages;
+		ra->async_size = folio_nr_pages;
 		/*
 		 * Fetch two folios so we get the chance to actually
-		 * readahead, unless we've been told not to.
+		 * readahead, unless we've been told not to. A stream that
+		 * runs towards lower offsets gets the folio below.
 		 */
-		if (!(vm_flags & VM_RAND_READ))
+		if (!(vm_flags & VM_RAND_READ)) {
 			ra->size *= 2;
-		ra->async_size = folio_nr_pages;
+			if (filemap_descending(mapping, ractl._index,
+					       folio_nr_pages)) {
+				ractl._index -= folio_nr_pages;
+				ra->async_size = 0;
+			}
+		}
 		ra->order = thp_order;
 		page_cache_ra_order(&ractl, ra);
 		return fpin;
@@ -3981,10 +4009,16 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 	 * Make an exception for shmem/tmpfs that for long time
 	 * intentionally mapped with PMDs across i_size.
 	 */
-	if ((file_end >= folio_next_index(folio) || shmem_mapping(mapping)) &&
-	    filemap_map_pmd(vmf, folio, start_pgoff)) {
-		ret = VM_FAULT_NOPAGE;
-		goto out;
+	if (file_end >= folio_next_index(folio) || shmem_mapping(mapping)) {
+		/* Check before filemap_map_pmd(), which may drop the last ref */
+		bool hit = filemap_mmap_hit(vmf, folio);
+
+		if (filemap_map_pmd(vmf, folio, start_pgoff)) {
+			if (hit)
+				filemap_count_mmap_hit(file);
+			ret = VM_FAULT_NOPAGE;
+			goto out;
+		}
 	}
 
 	addr = vma->vm_start +

-- 
2.43.0


