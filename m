Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2549ACA5FE2
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 05:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A4A6B0093; Mon,  5 Oct 2026 01:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E1906B0095; Mon,  5 Oct 2026 01:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E0B6B0096; Mon,  5 Oct 2026 01:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE7826B0093
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 01:28:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 75BC21A013B
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:28:35 +0000 (UTC)
X-FDA: 85287442590.06.8BC1249
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A94FFC0002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:28:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J0AUaOTS;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791178113;
	b=6s9XEN+P5e4Z4vi/EpjqkwC5vcnKDQoCnH9hPjVY2xTmhAzQgJrHMWJA109mLgJIEalPu0
	Qf4tCVLnWEA7l9AqESlIzkmEJ7spEiyTYk/8RgXcD5i0KIwKaGdBXnYfZNXza/srj1RlQW
	XT3yyK+D4Shsvkj9EbJUTaphHKZBdRc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J0AUaOTS;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791178113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/AbI6aiQv0q0ubJ9FMKBNe/Rn1IMhw37If5/SzZ9nl0=;
	b=NqnrD3QiaEs4VkIU8sUi/iAMa4hJCc/pty3zhbrDs94IDnWzDh0Cx+XkCCAf6EtL18DJRr
	OysK2rVl8Kla+FVCZ6Otdu3eoPBh3hvUheCI5cQFj8JbRNghZAXOs457REEcxtymcETIZa
	KWw7aEzdvG3hKxf7/ZWEIRMg8rIwQVo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15B9E60A64;
	Mon,  5 Oct 2026 05:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BC21F000FF;
	Mon,  5 Oct 2026 05:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791178112;
	bh=/AbI6aiQv0q0ubJ9FMKBNe/Rn1IMhw37If5/SzZ9nl0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=J0AUaOTSJyOUBdnKaYJ27RfHiTmlcQWaqN4uLvpUd73xVbR108/OBQlFMU7hRoYRB
	 GDCSom7+8HiWw58v7h4+9ejEvMC7onVbGWgmfYnv0nkhrQbP6w0E3bV049hQJweae5
	 nayRApGuB1es+0tW69f1/VjhWXm4tuCNJVx9v+cg=
Date: Sun, 4 Oct 2026 22:28:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ayush Ranjan <ayushr@modal.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
Message-Id: <20261004222831.bdd648a2b406f02747dd9e40@linux-foundation.org>
In-Reply-To: <20261003033107.1488699-1-ayushr@modal.com>
References: <20260924061708.1645968-1-ayushr@modal.com>
	<arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
	<20260925053027.1998394-1-ayushr@modal.com>
	<20260925065013.3682431-1-ayushr@modal.com>
	<20261003033107.1488699-1-ayushr@modal.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 78tjueqxo7kcymien9a1gndixqk6ho9a
X-Rspam-User: 
X-Rspamd-Queue-Id: A94FFC0002
X-HE-Tag: 1791178113-934987
X-HE-Meta: U2FsdGVkX19f28ib4+xWbi6773777+6xj0LkGzdQjtBt/zt/9FspSzV0b1OFIFcsIiG4KgK8DdM3Q5hJ0BWz+sk09TDXt5pNURYeNg3POcvYF2nV4m1vwh43ZzbU4tQKwHozD8knplL+T1ZOtwwWqFG5aa9aH6BNLNy6HZ24GOApVxw5ytEn3b/rkWWUWbb5uxUE9e6+dIAm23Usz/vHXG+BWvmR/EZffqZE8amyBv6aifjT3EbzgtrM8Mnuk6vbbRQMkh/MHheKEBUQm/C1PG4ZsQNTNPgxYNMpwwuhd2N3W+ApUws+7TnX0OJsj3Uq40N9BZHCKhE0++eb4RJI3SVRgDHob6otIOrsrAmA8qcjGjNl0D6vZawgG0/RhQVSSac10XXrEyPzzC++O6cYn+U7U8+rMYiE630LC0hbrXBF0tTFbS4av3rCbzDTZpm4kGrWoF3vJjxWk3WPiMd3YZXjLwPms4+hH5smK9RFglJLDVq7YtnTIYEdE2ndjTKIzJz1dEU0p7rgFP2Ic+0XV3Wqj78PLsWqpWZ0h4WuYHb8vzaJ0mS08SHP3GTOClSjWwbd8g5U4GjltTnykAZUzvPzAtC1N+tsHhgj0n57GneN+YjyMkvDxjCSM75Ko4XDKyPdrCpfergBy3TCxD6ADe2mrFW37Tz0S8VtAwJU9KFaLboJhzZt9LFt2vL0HZ9v85BHyySraTz8gBO/C0HVeVMN6TiWI4aGq2a2hlRq45iLUUmJ0SsqurtlCvPsTij9LnmOfpeKfJyo76CezESEMQL7HjNgPEZfV8++be8TL+wOEKopH1wLgE4gM5LRG6qwEa+9MNG0HnwwPL/Jxlw+Z5HYA4fWEMj7QCtsGO8fbeWINvBbqw3I7XhF1EDoEGCWjbqjyMskEQI6diSH8vm1TiMoBPrrhLN2hl6TKJpsDCLll6DXcPXxMsUIdstQcnJyCWUhBXK4RkZdaAGKtpR
 KL7BmCjo
 aKRAhOH5O6vcgR+1YdhAPxrXbkrLd1+SoLaxT43AE4pLUQfQ66AQonOYZni/YD9d8MbZhq4cGXGbnTB+zpN8EmDDXiaKqvAvdb7VPWQdOB5CxJFNGIE0LkLqR+eHcwT++XvxIoqGrQjssjDfcboOQ3kMYOl5Giccy3jo7V1rzMIo3/7YQQoyTT6VWuBsBO4CyCk1taBmjmfec3ErlJWO4+O9mqfiCfwl+X0Yz+1hRmwdnePZ4hNdjNcmwmcfAFMyjJjO24CURPPTpZJP9OJUP9N5+XbSZWjrKM8QWudrX9M7Z7LvR2nMZnbP4Dwjq2r6Ou4BdCXKIZdgRxXZ427Q1BycybGQWc5hFroBxiaPiWqHyCwMw7fhooPvCU25PqBkDvMP87SCyEnkNFSU6El0IZmsEJhZIQEbwnPfJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  3 Oct 2026 03:31:03 +0000 Ayush Ranjan <ayushr@modal.com> wrote:

> Hi all,
> 
> Gentle ping on this. The reproducer in my previous mail [1] triggers
> "Bad page cache ... still mapped when deleted" on 6.18.46 within a
> couple of minutes on a 128-CPU bare-metal box, with no fork() and no
> gVisor involved.
> 
> We continue to hit this in production at low frequency, so I am happy
> to test patches or collect more data if that would help.
> 

fwiw I made gpt and gemini argue about this for a while and ended up
with the below.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: shmem: serialize fault-around against hole punching
Date: Sun Oct 4 09:05:31 PM PDT 2026

shmem uses filemap_map_pages() for fault-around.  Unlike shmem_fault(),
filemap_map_pages() does not participate in shmem's fallocate exclusion
protocol.

During a partial hole punch of a large shmem folio, the folio can be split
and the resulting smaller folios can remain temporarily visible in the page
cache while shmem_undo_range() restarts its walk.  Fault-around can then map
one of those folios again before the hole-punch path removes it.

shmem_undo_range() may subsequently delete that folio from the page cache
despite the new userspace mapping.  This can trigger "still mapped when
deleted" warnings and leave stale mappings or inconsistent RSS/page-table
accounting behind.

The race dates back to d7c1755179b8 ("mm: implement ->map_pages for
shmem/tmpfs"), which enabled generic fault-around for shmem without making
it participate in shmem's hole-punch exclusion protocol.

Serialize shmem fault-around against the hole-punch unmap/truncate sequence
with mapping->invalidate_lock.  The hole-punch side holds the lock
exclusively while unmapping and removing pages.

do_fault_around() invokes ->map_pages() under rcu_read_lock(), so the
fault-around side cannot block on invalidate_lock.  Use the shared trylock
instead.  If the trylock fails, skip fault-around and let the normal shmem
fault path handle the fault.  Otherwise hold the shared lock while
filemap_map_pages() installs mappings.

This preserves fault-around in the uncontended case while ensuring that
pages in a punched range cannot be remapped between unmap_mapping_range()
and shmem_truncate_range().

Fixes: d7c1755179b8 ("mm: implement ->map_pages for shmem/tmpfs")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~a
+++ a/mm/shmem.c
@@ -2938,6 +2938,27 @@ static vm_fault_t shmem_fault(struct vm_
 	return ret;
 }
 
+/*
+ * A hole punch can temporarily leave split folios visible in the page cache
+ * after it has unmapped the range.  Do not let fault-around map them again
+ * before shmem_truncate_range() removes them.  ->map_pages() runs under
+ * rcu_read_lock(), so this exclusion must be non-blocking.
+ */
+static vm_fault_t shmem_map_pages(struct vm_fault *vmf,
+				  pgoff_t start_pgoff, pgoff_t end_pgoff)
+{
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	vm_fault_t ret;
+
+	if (!filemap_invalidate_trylock_shared(mapping))
+		return 0;
+
+	ret = filemap_map_pages(vmf, start_pgoff, end_pgoff);
+	filemap_invalidate_unlock_shared(mapping);
+
+	return ret;
+}
+
 unsigned long shmem_get_unmapped_area(struct file *file,
 				      unsigned long uaddr, unsigned long len,
 				      unsigned long pgoff, unsigned long flags)
@@ -3865,10 +3886,12 @@ static long shmem_fallocate(struct file
 		WRITE_ONCE(inode->i_private, &shmem_falloc);
 		spin_unlock(&inode->i_lock);
 
+		filemap_invalidate_lock(mapping);
 		if ((u64)unmap_end > (u64)unmap_start)
 			unmap_mapping_range(mapping, unmap_start,
 					    1 + unmap_end - unmap_start, 0);
 		shmem_truncate_range(inode, offset, offset + len - 1);
+		filemap_invalidate_unlock(mapping);
 		/* No need to unmap again: hole-punching leaves COWed pages */
 
 		spin_lock(&inode->i_lock);
@@ -5467,7 +5490,7 @@ static const struct super_operations shm
 
 static const struct vm_operations_struct shmem_vm_ops = {
 	.fault		= shmem_fault,
-	.map_pages	= filemap_map_pages,
+	.map_pages	= shmem_map_pages,
 #ifdef CONFIG_NUMA
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
@@ -5479,7 +5502,7 @@ static const struct vm_operations_struct
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
 	.fault		= shmem_fault,
-	.map_pages	= filemap_map_pages,
+	.map_pages	= shmem_map_pages,
 #ifdef CONFIG_NUMA
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
_


