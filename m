Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08FD606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oj2NzPoW
Received: by kanga.kvack.org (Postfix)
	id 02EC26B0944; Thu, 22 Oct 2026 10:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21C26B0946; Thu, 22 Oct 2026 10:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E388F6B0947; Thu, 22 Oct 2026 10:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C32806B0944
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:00:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16CCC16012F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:00:51 +0000 (UTC)
X-FDA: 85350423102.05.58DED01
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id B7D76100018
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:00:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oj2NzPoW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792677648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYxKdG3hGFUHAS2wMT8TWf0HywRpu62ZcKtPYmwcpl4=;
	b=qlHIPJedLnjbnleGHGfBmAxoZvFKEolNAs8+S/1HG/hNwthyNzsv3j3zzxrz1mC69pjItJ
	hclXtrj3r1gY7Z52tuyCUd7on+oDftETJMHiZOCrQV3699iRGqXg3CjlwmCB8iRwd2U4tT
	SkJ9fPdM9D+JDtPIXe3Lprw9XD7snho=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oj2NzPoW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792677648;
	b=0qDx11vspyj+wZTguy5+x42BtXQs8VQW6H2SC4D7lckIBHZSzoZGYYm6ZgoiwVgsXg+imz
	r0teHCWlLXNfuvYqKiJi5eUUSG9ausKjScVceLmDuwEnX7ioflXytjSP254I8xAR1pDjFL
	8aL7OZlFsrao1pwc0QtuHoX3xGhsKs8=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-35829219da8so1068708eec.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792677648; x=1793282448; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RYxKdG3hGFUHAS2wMT8TWf0HywRpu62ZcKtPYmwcpl4=;
        b=oj2NzPoW4SOChda5MmLPChIqdeE1jFyxvSY/Eijhwv5p7x9fgKic+Om6Ovz+yJajun
         qgWfNKamtQX4BFVdBzghdj8u4g9gcX80HuxJxq0YEi2lS81fmz8/Lb98QRTUj7kT+VCn
         jzZKn/4gKPUDEjAYYp2VWVhwigUxXmJdvPyFOcyPhg7bXTowFyZMDOZaVZN471Z8N3NM
         Cj++i6eOO6lHX4aHfpgPqQHCnNHRYYRYXUC8fIlGoLh5iybNvwXAfPL9pSfFvjevdAzR
         4ZNVfsLzSojoHQT7+Gg3GIT0C5LxsOxMrV3ywpC7NOUytklfnboGHbc4bhLMZZdIkCA9
         fQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792677648; x=1793282448;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RYxKdG3hGFUHAS2wMT8TWf0HywRpu62ZcKtPYmwcpl4=;
        b=zXRWkoCWlSjQTrNqZDH/1xNVCbL5TKd7bGf1HPMYi8oKjIUgJdGRyA4vE71xpI0bak
         SifMYE2dn6ccAJL+nWJMAVFEcx3wN1vBxkZq65+KDTuoFFTu5ei6XHrWojB270xFfrON
         mMuNYYlhOq5feFWuNIM3ln1WY0fYQNczbIyCue11MLv/9xJWa4Te8UNidtV3C6Iv4MuJ
         SSNUSpAposRqoI3Vq51ZrkfBUBmD7SSG72St6US/F783sk/Qe9eYbgeSu+Gx7uLk2I9e
         KrijnKQU6U65IjxSlgk3AbS7iF7UCIIzng8OSER+cJyNCvaBIUvPwND0/AP9iskX4WYG
         xsxQ==
X-Forwarded-Encrypted: i=1; AKwUvBy4Fhhs25K6YiXTAdk9S5d2qMMIEP5wzQ2jToPu8B6BiXED4oN9Y7gADubGgnwoxa+rZjVQGx7WVQ==@kvack.org
X-Gm-Message-State: AFq9FYINSXYEv9+KvrU7YOXBZNSy8lKJSet0mWsU8imLziy2swxu1ljY
	2JXlip8pH+cJMmyES3rQlrIwlwRHaAinJzD46jvvVdp3cOL4XsN6Scui
X-Gm-Gg: AYBFou0ofs5sexbUsUmjDO+7ILI3kITma66/mxqeC62oc3Q0tziwuYKCyfN2B4VUGGK
	ZbsaR+/7UgJtFSJIesZXTRzSHDedVmi7XNC4dAJsDKNm6TKL0tkwp3Un0T8w0Mv84usv9aC3pIB
	TAJ+CxwdeyS8IuZTZZKl4ulCMWxL1WZrAaG60UUY8PKGnOHoMSgBBZ0zG4aAXJOZywGGt/PT1Il
	1txeAYDv0azS++TLwTPEy3/7TyO2kWm19SgLekiZL1R/ydUlWUPVZhBqeOBSjoANOhZr/9Yv656
	k7E7Ud3a1IfJoLxvvbfZzMiMfLmO8YDZJY/UZFmi0mHnM1sgHU/Iq08IRv9dIpTC4wB/azPNbFh
	Ip0Q6MFrJOhCoW3V7snwnLn9d6eeksHP2pW2xh95W8RTd2hKspaUBn3lg9/kQ3JD3hgnZbGDNQ4
	mhoFpri5J2/iaap+gDa8xnRP2+RozWVfSzyF9B5fQatQwCQJSx6pK6PWzGosyrYAQc5+qsmj0dS
	Qrn1Ub+e3tboDrVSQR8++D1kzhj89/GaQn5BE/OZYawGSQnrbt9TZBVaLwPSY/ieCppJVS6
X-Received: by 2002:a05:7300:c392:b0:35c:49b9:3166 with SMTP id 5a478bee46e88-368aead362fmr3201965eec.6.1792677647279;
        Thu, 22 Oct 2026 07:00:47 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3673e15353csm29420342eec.2.2026.10.22.07.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:00:46 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 22 Oct 2026 22:00:36 +0800
Subject: [PATCH 1/2] mm/filemap: read ahead downwards on descending
 VM_HUGEPAGE faults
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261022-bug-mm-mmap-readahead-descending-v1-1-6d08b34862f2@gmail.com>
References: <20261022-bug-mm-mmap-readahead-descending-v1-0-6d08b34862f2@gmail.com>
In-Reply-To: <20261022-bug-mm-mmap-readahead-descending-v1-0-6d08b34862f2@gmail.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Vishal Moola <vishal.moola@gmail.com>, fujunjie <fujunjie1@qq.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>, stable@vger.kernel.org
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: B7D76100018
X-Stat-Signature: unz8fk9xs1p98rmg5dhai14y1tc778j6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792677648-203874
X-HE-Meta: U2FsdGVkX1/U89+ECQW7+IjgOLixnWTTAjf7xu6GcV52JHbhmFNycsyQA5uo66XdaBxiQlq5k5M24uum+i06TcNxPijg5AoJ+DGwuIA/IAS9qg/9DsH0wI1P3ntDcKhcb17/z6/AFYRr9/5K9PCggOGQzpmXD6TYnmynIMlsGJ8j/NwBGa/Yp4474Hz44l8jUOGHLyi7JnXXPlFX9Y9tyaY20UqRmKH0CBWrdjF1E6VmIGAGUgqfDyk5u9f0UwKzgDzTvIclXxRuk2W/poxo93rdolnQlgxwdx0qNlCHQH9M6y33aqKBuAD5jF5/TdQjdcY8cQWLM2JcGkjgxF+YQ+UAm2buAxXh3/wCAxH45XyHIlcGYTLyyF+HdZZLfgZjxnbQsTzxR3hAkpPUPJh9yHRyBfqgLnO6YYc4FseYCQR2oQ1NYbv8pyPZ/QgaG4QZrLmHZ3woVTwm5RucsBBd/UwWAd1BOOWtVX5JnvP5Y3WaLXEgVaUJrU1PNfAyZ7rKfHIoPnOG7ZgilAIWtpre4frPKYckkqkil8ZBphXfMjCNS6OCncUJuDGjBDJWTJ9PMIhoKlD3oQ2YYy4IvEzv0hOjTmLvT2c+R51w0NEE3W+9t9UQEXszxgAIAhdUjWp9vTSYod1Zj5UOLkijunXH3MfpcM72UXxleAywdStU1WEL9KsPl/KMX7FRUd+kthGcvoaSF/G++aFE9MRzRAblw167+bQnmIv4vWk51dYYOJFvFSnaLzTGAzBFZ3NdLZHWSkHm+mjCgLzBwUzg4e/GkQR59kKGUC4wU0ykfbA0bTnWg9MVQbg2vIJkB0z7mOkpSlQSMIwP5KbaF/oTku9kAeM7vO55YuIgjnAOxziA1WvdVVQkaw1HNjbseId0rp4NiX3pwnNoM7GS1HaGFzs06Zp8yIrzoOdmcb6hpgvyYoMOCyyZcIT9qucr2PXaR/swx2HVNMlT0Q0gL3vF628
 VT79tTQN
 4QFqZffy1F+McyvDAyo1C/u5QBi89/4n1S20oatrbNErtdoA2NdOfZUSv3ukFXU6YeyUYvxYqDyuSHGH319d2Ah2QgJguEC3ep46XUzXuldOhxkfd1hVyRmnUS8NFtDKIu4xYWAdWcqrKd3n0Oaf1JxhbY4cTl1bnafcFnOe9AXaQUF/P0YiBAeUOkwsHDvJYCPxbPJys9Xgx2eeFKbRsmeYSzHGc2/0Y1/BZ/iHggLQWjNOdqSFr0+yFG+pYT9CXM3DhTr5bKqAVvJ6xPzqMTaZbfwt6eWPrg8akuzdU0s6vc78/tDE7/R+WRwmcZfWW3HcMFaIjV/tu7o2k6W0oRTtNWSRSUc1NcvH0xT5qAcmjlO2JZIE0MjRcRY3STcIp7PM/wa4WgeGWGIezu2O2BbZDv7sw8avO19vjCIhxcZ0AEImK/mA4HDox0CPUW7nUDeG5BKTiHMTRt4H0n/nOR4hC+LB+nTBBzzQZ1fgY5/FoX0SjY+1Rdo03bOUHfq6XapeSgzOpZZRAqUkuvpnLfl2U8G+bMgAn1bK6ewSL1RSg4aw9hUXXFsW86gO5CbykDtpy
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

When the folio above the faulting one is cached, read the folio below
instead, without a readahead mark, and count a PMD mapping of the
faulting address as a hit the way a PTE mapping is. Such a reader then
misses on every other folio and hits on the rest.

Reading one byte from each page of a 2 GiB file, last page first, in a
MADV_HUGEPAGE mapping with a cold page cache, read_ahead_kb 8192:

                   before       after
  time            36.76 s      0.41 s
  major faults     473191         516

Fixes: 0b9c0aeba938 ("mm/filemap: count only the faulting address as a mmap hit")
Cc: stable@vger.kernel.org
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 mm/filemap.c | 101 ++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 72 insertions(+), 29 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f550..8a7d1238ae75d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3319,6 +3319,23 @@ static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
 	return 1;
 }
 
+/*
+ * Whether a miss at @index, right below @nr cached pages, comes from a
+ * stream that runs towards lower offsets.
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
+	return entry && !xa_is_value(entry);
+}
+
 /*
  * Synchronous readahead happens when we don't even find a page in the page
  * cache at all.  We don't want to perform IO under the mmap sem, so if we have
@@ -3392,13 +3409,20 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
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
@@ -3896,6 +3920,39 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 	return ret;
 }
 
+/*
+ * Whether mapping @folio at the faulting address counts as an mmap hit,
+ * which lowers mmap_miss in do_sync_mmap_readahead().
+ */
+static bool filemap_mmap_hit(struct vm_fault *vmf, struct folio *folio)
+{
+	/* Skip the retry of a fault, which maps the folio its miss read */
+	if (vmf->flags & FAULT_FLAG_TRIED)
+		return false;
+	/*
+	 * If there are too many folios that are recently evicted in a file,
+	 * they will probably continue to be evicted. In such situation,
+	 * read-ahead is only a waste of IO. Don't decrease mmap_miss in this
+	 * scenario to make sure we can stop read-ahead.
+	 */
+	if (folio_test_workingset(folio))
+		return false;
+	/*
+	 * VM_SEQ_READ and VM_EXEC mappings skip the mmap_miss increment in
+	 * do_sync_mmap_readahead(), so skip the decrement as well to keep
+	 * the counter symmetric.
+	 */
+	return !(vmf->vma->vm_flags & (VM_SEQ_READ | VM_EXEC));
+}
+
+static void filemap_count_mmap_hit(struct file *file)
+{
+	unsigned short mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
+
+	if (mmap_miss)
+		WRITE_ONCE(file->f_ra.mmap_miss, mmap_miss - 1);
+}
+
 vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 			     pgoff_t start_pgoff, pgoff_t end_pgoff)
 {
@@ -3930,10 +3987,16 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
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
@@ -3968,28 +4031,8 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		}
 		ret |= map_ret;
 
-		/*
-		 * If there are too many folios that are recently evicted
-		 * in a file, they will probably continue to be evicted.
-		 * In such situation, read-ahead is only a waste of IO.
-		 * Don't decrease mmap_miss in this scenario to make sure
-		 * we can stop read-ahead.
-		 *
-		 * VM_SEQ_READ and VM_EXEC mappings skip the mmap_miss
-		 * increment in do_sync_mmap_readahead(), so skip the
-		 * decrement here as well to keep the counter symmetric.
-		 */
-		if ((map_ret & VM_FAULT_NOPAGE) &&
-		    !(vmf->flags & FAULT_FLAG_TRIED) &&
-		    !folio_test_workingset(folio) &&
-		    !(vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
-			unsigned short mmap_miss;
-
-			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
-			if (mmap_miss)
-				WRITE_ONCE(file->f_ra.mmap_miss,
-					   mmap_miss - 1);
-		}
+		if ((map_ret & VM_FAULT_NOPAGE) && filemap_mmap_hit(vmf, folio))
+			filemap_count_mmap_hit(file);
 
 		folio_unlock(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);

-- 
2.43.0


