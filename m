Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9D660A3803
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 20:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=sDuz0/k8;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Ckv9HDGF;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=heYlqDV6;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TUJeWbF6
Received: by kanga.kvack.org (Postfix)
	id 88B836B06C8; Thu, 19 Nov 2026 15:11:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862EA6B06E8; Thu, 19 Nov 2026 15:11:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7522B6B06E9; Thu, 19 Nov 2026 15:11:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4324B6B06C8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:11:25 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76010C01CD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:11:24 +0000 (UTC)
X-FDA: 85452963288.06.D63541E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0F0B010000D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:11:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="sDuz0/k8";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ckv9HDGF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=heYlqDV6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TUJeWbF6;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795119082;
	b=2PVqgXm5Yz+u7ojiSqhBX692pktpR5ZAabWjEtLBtVQ4DT+bWIEFGQWTSQ2rFor/TLzzGC
	32xF7IxlQIPRxuJb6kapdbKLQfB1yM90tQMvklABVVN9+LMEP2E8iVfngxkkQ8RY/6zF+T
	Q/GxXMMq+Ctb0Z+oO81hGrCL4NUxsQE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="sDuz0/k8";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ckv9HDGF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=heYlqDV6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TUJeWbF6;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795119082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4P5Cb+/gfgFBvqXWLKpYKOVGpUcYfuN40MLcJ/ms72w=;
	b=fSBzIKdnVNI0qUQXkD/QMCZfYXIWL9a9t/52++0AwFCJJo1p6zRcOMxCXmcFNYpknIja8U
	nMoPse7qh2L5ESc3MYmKh4iqenUZzHKkVxCwTOli2/DvEqX2TXZogtU4ZbNUHg6r139bfT
	hGIMr3OzJDg1+U7zSNAPUtPWWVeQo2I=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DC3401FCEB;
	Thu, 19 Nov 2026 20:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795119081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4P5Cb+/gfgFBvqXWLKpYKOVGpUcYfuN40MLcJ/ms72w=;
	b=sDuz0/k8dN04iladdCn1gPyygaKd0MO/dxStH2IZjsRRA/w5CATIAYcySkadXUYjOwviFc
	3mzhJ+eboRgKsfOV+T2wIdUAyyAxjY0+rroxNyciIdn1GqgB4MEPCaiNwDYd54NGzF/mi/
	reG0ytBYtl/iWXFp6zbR2aKSwZx2QxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795119081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4P5Cb+/gfgFBvqXWLKpYKOVGpUcYfuN40MLcJ/ms72w=;
	b=Ckv9HDGF4PAjrItC/XomsJDUu5vT0fLYjHvKcgIG4FffcfRNPkM2697Qc1w+/4uKtApvxx
	6QttGd9wgRq6geBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795119080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4P5Cb+/gfgFBvqXWLKpYKOVGpUcYfuN40MLcJ/ms72w=;
	b=heYlqDV66zR3q53/DcGEzUxq5XDHxwEP5Ctk9fMS48ak8rgF38T8TQwbAs20stNJf1wvqa
	iwPxYnQLqtFeV+PxepBWtsU1mNmLy9l6FhB/53at8XXCOavDNJid1RYQt4EJq4FpvVowUP
	Hba7vzM5zACDa155GUl79PArhsGC+8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795119080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4P5Cb+/gfgFBvqXWLKpYKOVGpUcYfuN40MLcJ/ms72w=;
	b=TUJeWbF6iWKkwT3EER10NoYiXdDCviji5x375945ma7CsJdZww9XPuSzdiCGiroyr96b87
	lEDDs8k9n4kb5vAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CFA1B134F6;
	Thu, 19 Nov 2026 20:11:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OqV1JuRX/2pPYQAAD6G6ig:T2
	(envelope-from <pfalcato@suse.de>); Thu, 19 Nov 2026 20:11:18 +0000
From: Pedro Falcato <pfalcato@suse.de>
Date: Thu, 19 Nov 2026 20:10:44 +0000
Subject: [PATCH RFC 1/5] mm/khugepaged: fix filemap_release_folio()
 interaction with GUP dirty
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-gup-dirty-what-v1-1-236d69f25c24@suse.de>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
In-Reply-To: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
To: David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Lorenzo Stoakes <ljs@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Spam-Score: -17.30
X-Spam-Level: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0F0B010000D
X-Stat-Signature: fykkjtxpkw4ufkr8yp7kro8peh4hgezo
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795119081-267795
X-HE-Meta: U2FsdGVkX1/rkdUGZwGeAZU2V4A0HIqqQFJGZpaGmB+OwwansabXoLu2HlORAky8Jz7HaHvOs86AN7KhLiCVI6lyAFND42OL+0UO37msMhoDEQ25CKepzZfF9kZkvQvEUvs+VbNwsF+X83KnL99YcYXJMcLikQr/aUoxcIE5FB1bEhosxOYZkiIwhdgYE+7GquvJdAvE1zWg5DRuvbgpX1ny6rdJTwDdRhYOIzPPldNyaxMzs+JxVS07ZV3KBxJA+qpO7JkrxFZtKOgchvjJ2MA0VRcoXofn53yvw1nU9gRxTIE2CiazJY/thH71eCE+fFkH++t5rESduLmsgtAKWnsjqbMKe+Hh8rHkblVeU/WKZLbi9W4cewC2fBzgHYte7KElcQzNTo7TA7kvLFaWIyfvVMuiEfzIRffnKI23oP/34VyBDzC63KUrRtlSw4KXsnUrzHK2AV4kaWtNL8R8/b977eYy+ESRwv2cfPyk6HrSKhkPVoai5TOIOnd4G5L3NKsrVzLnm6Lcu63sXDI/IyPBGT3SMyNlhtk1YaAizdtEYq+BeE0IoekP1xLEKLSrsKRvleQGvLjQan2j0HOYCqsaXwS0GSfd2DibL5iXPQgcpUigBwvSgkXiWz/NmIDiAb2drs9Fkpetla8ipOU0VEOaN7llbwN3y0+kAPo38keiBzjwGFM2JL0Mg9lo+LrsQSW/BA/MR1ZJD6wli23HZlPEogokZrg59rm+05xNL6e1laAs9xxwOs6i6vdWm3TFaVsGR6KEID5eezgeHicP8ukNBmG1MFZm8riZW7MGrJ2mXUCGztcUTzVaSziFh67S1dQnHfJhgCGnMC4Jtok5r/8aBkQAecsWooD8TPbcWk3PylbEUxAQfXet5r268cKEfOLJhhY9JW9oBEAhyKzOp40oHtEj/v+RK228cxOsT22Fmfq996KQbTfVJWAwafezR/ea6CSNGZ3B9CQpaNE
 KD7inr6t
 QB+sAyPOz4V76uqKIWB/k7BtqZPANJv7pplIzj8EAbz51AVOzWXnlOs1MR4AkVBAenhKMOHscN7+jeHeGY67kO12gPxJtz2M0q6iE4Ci+LPWZIBk64PH3WF3ixe2ZX3VX/vCLLjYGqnoM4jgEnzjtuhVfsi+hNHSUYcD7YDL1fqO7TOKvsu87WezWrXfvu0v5a8/XXOkEmwDiCHaMrH61bIgwR0NQKKvigN+hZW+wk7OXbuxBhl9gLTJNi/KJeB2au8gLjFR3qhJSt4hn4Rkh1dw4FtiRwSg8ii83LaepeeUDEv6mDTH3DE4Bx0UyzKsnhMw+SFQxjComGE9PA+jFAj2uZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Whether a folio can be "released" (drop attached buffer_heads, iomap
state, etc) is a complicated matter.

Namely, the act of calling pin_user_pages()/get_user_pages(FOLL_WRITE)
and later calling folio_mark_dirty() on these same folios relies on
on these structures to have been set up by ->page_mkwrite() or
->write_begin() elsewhere. ->dirty_folio() implementations usually
cannot set these up themselves, as ->dirty_folio() is not allowed to
block.

    [get_user_pages(), etc]
       ->page_mkwrite() called here, or before
         ->private correctly populated with whatever the filesystem
           expects.
         folio is marked as dirty, initially.
   *write finishes*
   folio_lock();
   folio_mark_dirty();
     ->dirty_folio()
          dirty_folio expects ->private to be populated by
          ->page_mkwrite(), ->write_begin().
   folio_unlock();

So, what happens if filemap_release_folio() is randomly called on
folios?

              T0                             |       T1
    [get_user_pages(), etc]
       ->page_mkwrite() called here
	 ->private is ok
         folio is marked as dirty, initially.
   *write finishes*
					      |   *some op*
					      | filemap_release_folio()
   folio_lock();
   folio_mark_dirty();
     ->dirty_folio()
          dirty_folio expects ->private
   folio_unlock();

In, e.g. ext4's case, this results in a WARN_ON(!folio_buffers(folio))
and very likely data loss, as block_dirty_folio() will not find any
buffers.

Thus, introduce a new helper to help figure out if
filemap_release_folio() can be called. filemap_may_release_folio()
mainly takes into account the refcount to help figure out if it's safe
to release. The NFS ->private refcount funkyness will be handled in a
separate patch.

As a part of this change, move try_to_unmap() back to before calling
filemap_may_release_folio(). This is required for mappings which don't
require write notification, and as such the dirty=1 -> folio dirty=1
transition is actually meaningful.

Reported-by: David Hildenbrand <david@kernel.org>
Cc: stable@vger.kernel.org
Fixes: d824ec2a1546 ("mm: do not reclaim private data from pinned page")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/internal.h   | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/khugepaged.c | 19 +++++++++++++------
 2 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 85cf7becf858..4c22d27ace96 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -718,6 +718,54 @@ static inline bool folio_needs_release(struct folio *folio)
 		(mapping && mapping_release_always(mapping));
 }
 
+static inline bool filemap_may_release_folio(struct folio *folio, int extra_refs)
+{
+	/*
+	 * Whether we may "release a folio" (drop attached buffers,
+	 * etc) is a bit more complex than what you could be hoping for.
+	 * There are two types of dirtying users in the kernel:
+	 * 1) ones which take the regular page fault/write(2) paths.
+	 * These regular paths (which fall into ->page_mkwrite or ->write_begin)
+	 * take enough care to e.g establish buffers and attach them to the folio.
+	 *
+	 * 2) ones that don't necessarily do that.
+	 * Essentially, the act of writing to a pinned/GUP'd page relies on the
+	 * above (for GUP-like operations, ->page_mkwrite). However, the folio
+	 * does not stay locked all the time. It is released somewhere in between
+	 * get_user_pages() and whatever it is you're doing with the page (e.g IO
+	 * submission). These users rely on the following logic:
+	 *
+	 *    [get_user_pages(), etc]
+	 *       ->page_mkwrite() called here, or before
+	 *         ->private correctly populated with whatever the filesystem
+	 *           expects.
+	 *         folio is marked as dirty, initially.
+	 *   *write finishes*
+	 *   folio_lock();
+	 *   folio_mark_dirty();
+	 *     ->dirty_folio()
+	 *          dirty_folio expects ->private to be populated by
+	 *          ->page_mkwrite(), ->write_begin().
+	 *   folio_unlock();
+	 *
+	 * Thus, it's not possible to call filemap_release_folio() if _anyone_
+	 * has a reference we don't expect, that can plausibly dirty the folio.
+	 * Additionally, we can't have mappings for these. These checks are
+	 * racy, but the folio lock guarantees that whomever is e.g starting IO
+	 * on these pages will inevitably wait for us to finish.
+	 */
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+	if (!folio_needs_release(folio))
+		return true;
+
+	/* There's no way to know whether these are write-mapped, so give up. */
+	if (folio_mapped(folio))
+		return false;
+	if (folio_ref_count(folio) != extra_refs + folio_expected_ref_count(folio))
+		return false;
+	return true;
+}
+
 extern unsigned long highest_memmap_pfn;
 
 /*
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 964f78c3856b..1f1b93371a7e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2396,6 +2396,15 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
+		if (!folio_isolate_lru(folio)) {
+			result = SCAN_DEL_PAGE_LRU;
+			goto out_unlock;
+		}
+
+		if (folio_mapped(folio))
+			try_to_unmap(folio,
+					TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
+
 		if (!is_shmem && (folio_test_dirty(folio) ||
 				  folio_test_writeback(folio))) {
 			/*
@@ -2404,11 +2413,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			 * since first write.
 			 */
 			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			folio_putback_lru(folio);
 			goto out_unlock;
 		}
 
-		if (!folio_isolate_lru(folio)) {
-			result = SCAN_DEL_PAGE_LRU;
+		if (!filemap_may_release_folio(folio, 2)) {
+			result = SCAN_PAGE_COUNT;
+			folio_putback_lru(folio);
 			goto out_unlock;
 		}
 
@@ -2418,10 +2429,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
-		if (folio_mapped(folio))
-			try_to_unmap(folio,
-					TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
-
 		xas_lock_irq(&xas);
 
 		VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);

-- 
2.56.1


