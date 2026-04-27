Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3657FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83296B008A; Mon, 27 Apr 2026 12:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A816B0088; Mon, 27 Apr 2026 12:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA2A6B0092; Mon, 27 Apr 2026 12:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B779F6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:58:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CEB412017D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:58:01 +0000 (UTC)
X-FDA: 84704943162.03.C02A8E6
Received: from out203-205-221-190.mail.qq.com (out203-205-221-190.mail.qq.com [203.205.221.190])
	by imf18.hostedemail.com (Postfix) with ESMTP id B33201C0016
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:57:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=gQXLJUyI;
	spf=pass (imf18.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.190 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777309079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1JvSeF30219RBk+xbUaNaVTMY2zuIFNzkHsiaJcAUI=;
	b=IhG9Rryb+mc8wpHi83lhSybrlx3elXjhWEoMKT6aUeNBrrUIyw7FhxK8WNs5+xI/K29ksY
	u3/ZeA8MHm4+FlcLe3NI9DUL4oAxIWC8j7HL2g+Q5AJ+IuGBmGx3i59yB0E/AGHi/CjSWR
	MZF8LdljfiRMEtS3WVa+x94PLNl+tBI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=gQXLJUyI;
	spf=pass (imf18.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.190 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777309079; a=rsa-sha256;
	cv=none;
	b=G5im6WOxJ4byqP+jyly0g3b44Oem5cPCy3pwrDDpEf8jbcYuLvw7o1SOEFQrRoGdOEE+Vy
	sr7Xob9YQb62MjONBCmR528IG8C1W1dfm0NsuFaQzR2gzdQthrz+ihateascC60z6xRPKN
	RTlTmel47fJo2CbdWO6TtZ1eC/bvLm4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777309075; bh=+1JvSeF30219RBk+xbUaNaVTMY2zuIFNzkHsiaJcAUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQXLJUyIm5qOEHJ/B58iHD/yFGhxGdYsH8j5nwwvG22zXoUskg33/4HdRs/kdT3S+
	 tZDOyPmdu9ssgKwABbdZChmShvXduyyU26LrQfOJ8MsHIS1a1ZBnHFCxer/s1hmAWA
	 he/8fyZzErehb86ZA3hajls0D1m2ny5GEnJaQ2QQ=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id E73AA4C8; Tue, 28 Apr 2026 00:57:51 +0800
X-QQ-mid: xmsmtpt1777309073to1iceus8
Message-ID: <tencent_949F3B157FE71D3C7247AE6FAE2C5AB82809@qq.com>
X-QQ-XMAILINFO: OIJV+wUmQOUALqh99JbrUzyKqrytGQhvISUP2SJ+lBCQnAMZx+Ah4KMdLXmAp/
	 CYkVWiEAjpgSPZ+AP27Kda4iF/pd6tMH3yioFtTwwaGx3s1yYPOAmfQDkoclFRWL82QDH7sek5OI
	 RlUXYkrXU+EPk2Fn3F2Ad6RFJnrQNPq+WlBoy9DQKpgeQ7JtiKwZxQ3S77zt3qpTuVixEnOL5Ss7
	 SwUgxaq0GaTG2wD5NbrsvNvRGjtDV7cfPTkUqtaGgXkTFLqJkaxcVa5CZYc7noQex/SCI8k6EmIq
	 VFU8sixXlICQAubYrkZq7IiI4lHlK9SQMeA2C4c8RrC1etJHaN9GuL4ts9qWqGznnZ7ThzpURkOm
	 3LKl9USwzVyTZSoaGUCWYP+8TzxK6CSUd3xjQKwoGC7S34wm6MHrDI2dO4yr2YHpJ7s6XeeCNR69
	 xFytxtEqB68URvc3RQjw0pF6YNQC7CxoHtdTdq3ACcmAi2xH83AIgVaJd3GqEjtF+hy9rCgVp0OV
	 aBj8onayxhOxufZ/dSuJ/nnhJAYPG6NMOcfUE1dTM6vRvUSrZNQU5z+DP78mjnYT53mKwy6/tKJS
	 ySrMq64g8xcak3JQwQoQtZU9doXWMhw/cMshFi/UmfelF6oPrPoLR1tBpt4D3Bds7vwWTQdnj7xm
	 A/NQyDr3qDBrJ7HJfM5OYF/zy0wnd9tyT3mZNiOkpVgxl2Ino+ufpN11fC3/QCYYZOGqTqrYGRJH
	 AMQRXSt+Tvx9TWP/Fmdb8K5qCXX/AqfYRSXCUy+lfPoEYBpPgQGRZdh4mUVFqezHj+v3oCa5v4x+
	 fypNi9y6QZtU9rRy7UnQTZ1la8CGg7orPL1FkH9XlX7pzITwt1SNmwPxhAne9/+f4VMJBTdR2s0N
	 kF8QYNU1L7PhX7SknKwCvS3gqNq3lhKIKdY1/V6C71z7IAXFKXfmwc9bm65vZaCH9pVuoSGQyrYa
	 b0hfD7ZTkK/l8owIE9LwT5MQbKjeK9d15bRKMujp2hsJ+cp6Dt08Pl80LGixqbSPTf5vcw1AhWV6
	 VGqAOkqNpitWBMzveS
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: fujunjie <fujunjie1@qq.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Haoran Zhu <zhr1502@sjtu.edu.cn>
Subject: [PATCH v2 1/2] mm/filemap: count only the faulting address as a mmap hit
Date: Mon, 27 Apr 2026 16:57:50 +0000
X-OQ-MSGID: <20260427165751.746502-2-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260427165751.746502-1-fujunjie1@qq.com>
References: <20260427165751.746502-1-fujunjie1@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B33201C0016
X-Rspam-User: 
X-Stat-Signature: d987gaic8c3yzyaj5od8rok1xwgw11gd
X-HE-Tag: 1777309078-810039
X-HE-Meta: U2FsdGVkX1/d0focLvRFEJUhTI923Pz//W0R8nTHYoCyqFPhGShq8LJT62wlOa2z6i41gByj1NFcuulf3/vu2N0t3ao636e6NNu+2tJFn2wWrZmtuAZbAYawwfMF1EYG2aG4GzRmV4mgRknqy0dI/adJweVjjZ8hXl0ULYQtooVYiPw/NTrEcAYr5ev3rlSdA+lJLvM472KF9RI/YMuI95SzioMqhp1AdQZccZ5k7EHKHKiclEfQvyGj9Oig0jhk+18iYb+P3aOMJnBc1/rk5sKdJqgYv5RoBCWZpW5hk1R7ytBaHSImSaNLBmSd3zWgYMPOYqQZL93k82/T1qY2y1ZcVeZ2GSNfbPdkFIu2YSlh0vE+LTOBZ0lXCIqFvkrVhkttSGywjLtQbH9lMDz1/mz37AwQ5wUHVqzmzFF4M/XC/Jvk3KSV9mjjkgzWlQhv91Lur79nLtpClat4HTIA9bY7x0z3ewbUk175LYqPSAAvQWEW5ED+hiSqY6ZV/jpb4icY7U/w61Jb1X53fueai12YAoGaDedka4IHcjDT6tkNM+iTqlz+fqtQQmn6LHn6ma/JRv1cqMiqGj2bkuoizp9kuMjjaW2HQXWnLj5jBHLitNfd7zYhTm4CimPd2sfoZgoD+/3D4SW1mB8yLFXR8vuzOlw1ahpol1iUmHbKNWlDPh9wLkOMlikTFkt0n8V5g7eQ5/z6w/xfgacrfPokXtOE0z/2ZFX5ZnRI9Eo2Sk2J2abUXm01ZNiNEqdPecYh2JfP7PqviCBEwOya9QhR0vF4t6LsHgDGgqg1ix6UGVSVEgmH1gnIiOgG/h9K/S7Xy8stnaBE1alhJMM2da2XJga09VFy/C/HFRnM5yAeqDu1+eTpcLEDv/IeRiT/E/nw/+EoJBrPPetpCN67ctOtuS15+vQJAsSCSPZqmy87n7PEdtA8BDUSLIklgn0V5uPgYGj+W+cFu2L8bcUmptS
 b/aq/z7Q
 +C0RSl+t8tOQGn14ghiBzz8pDdWIuSg86f1FtAFkpSvdtnfkJlW/6hKzkntEYtpsInpnztA9vgyBbQxS95RbWI5yJpo6RTs37t5gkbzEDdcGBZk9Bph+Y5Aw4t0OHD/jcdxNoRAiHuGR1x/CJTLFdQT+m7zurjRTOnH5LatN3SORFt2nyx+OyCr/eGwwCLjt90ry1UrsN8hWuoMMGyE7vLmdjZNXdKwEQMque3NfLw/EmBmXs9WVari2ECX2LEoZTbKHl+bRytXQvqmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

filemap_map_pages() reduces file->f_ra.mmap_miss when fault-around maps
folios that are already present in the page cache.  That hit accounting
is too generous because fault-around can install PTEs around the
faulting address even though the fault only proves that the faulting
address was accessed.

Move the mmap_miss update back into filemap_map_pages(), drop the
mmap_miss argument from the helper functions, and decrement mmap_miss
only when the helper return value shows that the faulting address was
mapped.  Keep the existing workingset-folio behavior unchanged.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/filemap.c | 55 +++++++++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c1..41ffe9036c96e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3747,8 +3747,7 @@ static struct folio *next_uptodate_folio(struct xa_state *xas,
 static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 			struct folio *folio, unsigned long start,
 			unsigned long addr, unsigned int nr_pages,
-			unsigned long *rss, unsigned short *mmap_miss,
-			pgoff_t file_end)
+			unsigned long *rss, pgoff_t file_end)
 {
 	struct address_space *mapping = folio->mapping;
 	unsigned int ref_from_caller = 1;
@@ -3780,16 +3779,6 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 		if (PageHWPoison(page + count))
 			goto skip;
 
-		/*
-		 * If there are too many folios that are recently evicted
-		 * in a file, they will probably continue to be evicted.
-		 * In such situation, read-ahead is only a waste of IO.
-		 * Don't decrease mmap_miss in this scenario to make sure
-		 * we can stop read-ahead.
-		 */
-		if (!folio_test_workingset(folio))
-			(*mmap_miss)++;
-
 		/*
 		 * NOTE: If there're PTE markers, we'll leave them to be
 		 * handled in the specific fault path, and it'll prohibit the
@@ -3836,7 +3825,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 
 static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 		struct folio *folio, unsigned long addr,
-		unsigned long *rss, unsigned short *mmap_miss)
+		unsigned long *rss)
 {
 	vm_fault_t ret = 0;
 	struct page *page = &folio->page;
@@ -3844,10 +3833,6 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 	if (PageHWPoison(page))
 		goto out;
 
-	/* See comment of filemap_map_folio_range() */
-	if (!folio_test_workingset(folio))
-		(*mmap_miss)++;
-
 	/*
 	 * NOTE: If there're PTE markers, we'll leave them to be
 	 * handled in the specific fault path, and it'll prohibit
@@ -3882,7 +3867,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 	vm_fault_t ret = 0;
 	unsigned long rss = 0;
 	unsigned int nr_pages = 0, folio_type;
-	unsigned short mmap_miss = 0, mmap_miss_saved;
 
 	/*
 	 * Recalculate end_pgoff based on file_end before calling
@@ -3921,6 +3905,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 	folio_type = mm_counter_file(folio);
 	do {
 		unsigned long end;
+		vm_fault_t map_ret;
 
 		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
 		vmf->pte += xas.xa_index - last_pgoff;
@@ -3928,13 +3913,27 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		end = folio_next_index(folio) - 1;
 		nr_pages = min(end, end_pgoff) - xas.xa_index + 1;
 
-		if (!folio_test_large(folio))
-			ret |= filemap_map_order0_folio(vmf,
-					folio, addr, &rss, &mmap_miss);
-		else
-			ret |= filemap_map_folio_range(vmf, folio,
-					xas.xa_index - folio->index, addr,
-					nr_pages, &rss, &mmap_miss, file_end);
+		if (!folio_test_large(folio)) {
+			map_ret = filemap_map_order0_folio(vmf, folio, addr,
+							   &rss);
+		} else {
+			unsigned long start = xas.xa_index - folio->index;
+
+			map_ret = filemap_map_folio_range(vmf, folio, start,
+							  addr, nr_pages, &rss,
+							  file_end);
+		}
+		ret |= map_ret;
+
+		if ((map_ret & VM_FAULT_NOPAGE) &&
+		    !folio_test_workingset(folio)) {
+			unsigned short mmap_miss;
+
+			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
+			if (mmap_miss)
+				WRITE_ONCE(file->f_ra.mmap_miss,
+					   mmap_miss - 1);
+		}
 
 		folio_unlock(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
@@ -3944,12 +3943,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 out:
 	rcu_read_unlock();
 
-	mmap_miss_saved = READ_ONCE(file->f_ra.mmap_miss);
-	if (mmap_miss >= mmap_miss_saved)
-		WRITE_ONCE(file->f_ra.mmap_miss, 0);
-	else
-		WRITE_ONCE(file->f_ra.mmap_miss, mmap_miss_saved - mmap_miss);
-
 	return ret;
 }
 EXPORT_SYMBOL(filemap_map_pages);
-- 
2.34.1


