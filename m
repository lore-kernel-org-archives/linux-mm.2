Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB16CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 04:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F25C6B008A; Sat, 17 Oct 2026 00:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3EF6B008C; Sat, 17 Oct 2026 00:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592536B0092; Sat, 17 Oct 2026 00:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4A06B008A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:50:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D05DA781C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:50:46 +0000 (UTC)
X-FDA: 85330892892.03.F3C56B0
Received: from mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	by imf11.hostedemail.com (Postfix) with ESMTP id 48AF740002
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:50:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ivdsxJSQ;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.150 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792212644;
	b=1cdURSXY5VljqHrIExlsuxKxhL0vaauL8qjR5+MFkFi6nFfYPz7FpSPnP42Z6CQu77jrRh
	n+RsfPVua9BPkRcQXq2Zsq6UWItjUCU2IKNBnk2vfpAi5Z+ZJ/+dcceLFpusxIFLeydyO4
	tOJsgp8dwlgZ74pcWMgKhT8gsL1RKss=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ivdsxJSQ;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.150 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792212644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w12QpfnhKL3Xam3li02IGjWhFMu8ayu2lF0NUVNihLo=;
	b=sWnZHmpmFw5H2gUlLcj/uRygY7fHJII2xWhUp3BwFbVztlBqBm5EEgKXLOAY7ourQ3SmZo
	hFTiHUb1nGsSFZOi2yxScdE5So/2xq6M5JGwwKIcSQ1rNPizbpS8w5Qhontvbz84VGwkLF
	MMqkaTOGVzMysjZljMUTVfhXUtkdLLM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DariwmLPp7xJOYKPqVbT4bqPHAX4FpqWRkGiDxZp0g4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792212642; v=1; x=1792817442;
 b=ivdsxJSQPaqSUqZ9H/c87QzRiOuGMFexGZ0syHQ1YODe5yjB5P8tK030iiN/hfRnmxuRwOhs
 E2WBJxN0va5bNnFTrjFqeMo5rXMgLTAxKE1rk7YzASK2PAmqV59q79f64totFiskn25feZv0eyL
 UFmxpguJ3wtLlZCWE40VcLzQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 80e13a89da7f5256;
	Sat, 17 Oct 2026 04:50:42 +0000
X-Mizu-Trace-ID: 80e13a89da7f5256
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: pfalcato@suse.de,
	baolin.wang@linux.alibaba.com
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	jack@suse.cz,
	djwong@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
	ngocthang2710.1999@gmail.com,
	willy@infradead.org,
	rppt@kernel.org,
	ljs@kernel.org
Subject: Re: [PATCH v3 1/1] khugepaged: fix readahead lock inversion in collapse_file()
Date: Sat, 17 Oct 2026 12:50:30 +0800
Message-ID: <20261017045030.80989-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <atIiR1NWNssDvgt6@pedro-suse.tail5790ac.ts.net>
References: <atIiR1NWNssDvgt6@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 48AF740002
X-Stat-Signature: npsmjyu49yzmzhmb6ratzf6hxi1gmn6f
X-HE-Tag: 1792212644-275645
X-HE-Meta: U2FsdGVkX1/RXUA00zifv67hO9S5GTyuuFUDbNz+MSWTSwHrS8HeqPKpuJi0p+al/VikZ2+vSyqf39Ygopac0akY2kJXCQu4CFvT7mrA+ynPl7kDa3/Jz1lYKGR/5BuJb/uP1W7sQam9HbGZ7C7WAsqw18Ejz1vKGSRbTvG01ZQur+1YQoCnd17oMrg8/iFIRCl3IfCY85BaqF6GSuiRDRTOTlFHXxGjK4khZV0z0ytmzRu/VzEBdJ6lcYYcwLvzgkbfkfGigjHpS77+FOX0glbxb69H5me6I5z5/d/vMP4Vb8G3BO4JAgnHWyo35lsydTWPHNgUbmIh3BAzzDGiXYxb+89dBzRfH90x1tsrvm4KE/fzggzva9egAXtm3KqMGklmQbwzlJpGn4awSBICNQQ121dWFmnpoeovVz2kW6lExYnjSedHJg8yluv9/jz8z0s2rEY9PMl/4jzbdW1vs2+dwBA4Cac5Q1kibM0TzmVrGqy2XG4KC+d9o6hj4tKsQWyLaCz5asqXVpvi0PNVtaf4qWTyvHn03dNx6eF+4t1hFJa+pBKCZQJXdyBU23wexX134bRRTJSpduWbzBXPX9PlKBuCZg9D8TbIrw5KtC5sJtKygA2EH8OvMXqgckVLUqsI7ZfrslMU7ogOlHb82Ack8VgwLaRt7rac0MKq4LBggMWS5Fc/VSyur4mAprpNzq7rtfFxIZwpKt5k2qqGQCWKki62mmNY0RaCd5Lb1jPyVJEk71lM8T1bSF9lLcITC8d5W8KheGC/oKqjW//vf8Xmp6YeG6s+hWO7ScCmKQyWWjtFFNqDxbXs+XDHbMQ0aoBBm4ripXxuEQUlz6lsHaM4nKNkPpmazyTrzZ7Q6ziG4TgcU4IcKBcebw26AFl5sUPkHj4uv64otBpFzFz4/kP+815AlNDVW2IDA4HIc6mpYh3Js+8uYIFm6Qhi7mMAjNFFrtqbkNiqKZzYwRv
 W5SuLcru
 G2D6c9MUBclt0vNwrG93mOCi7fMuoO7BcV+wnSP+LHHxJW3i6xK+e/4UbzrXEusxuvSeUn9ZbwxcTX8DyRiRey931/UJ3oRLYDBhLYKRHKApZdz9mdT4PHfJWtNSUuSl6FDKP6/LO9V4PHARsOzRNEG0N20lwpFllOwZOTiRGQFviq/hj+AX/ymRZYpOp3yoZiACE+mIO1oHP/l6l+s/TbNdNfzq9MKz3z5h0vy+l4w4ZIp5BzNmYumNR0mi9T4uauNMkraFGc+p9vpNLDWP1qAOMXNcwdRPRoBO78bgitBOGGleQX88WfY8J8x7RznlHyaksZsrwtuHmzDneopoxO69J+mSMi5ONv9pR2x1LLWyuN6MLweJATWkrDnMeSup08CWnYJazBDGyiIghMTdAD/pSR9RGFeQ3aIVrBrJb9wd6hAmtxs0Ocns6iiCgYoMzv3x2gDLpSKTxT7nh++d6olaWQNWdCiE2iDGaIPUWFCFBUprqFwtQs7pFs6y94F+3HhEZ6koe3gIVe1xHx/qVa6Rzq8gWyGFIEqjX7toa2GjfAy+2rzqu6I4nzgQqalB8B0LLeoOqflRLDkU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Oct 16, 2026 at 02:18:43PM +0100, Pedro Falcato wrote:
>On Fri, Oct 16, 2026 at 12:00:24PM +0100, Pedro Falcato wrote:
>> On Fri, Oct 16, 2026 at 05:57:48PM +0800, Baolin Wang wrote:
>> > 
>> > 
>> > On 10/16/26 2:59 PM, Lance Yang wrote:
>> > > collapse_file() can end up calling page_cache_sync_readahead() with
>> > > source folios from earlier in the range still locked. If truncate already
>> > > holds mapping->invalidate_lock exclusively and is waiting for one of
>> > > those folios, readahead blocks on the same invalidate_lock and neither
>> > > side can make progress.
>> > > 
>> > > Do readahead in a separate pass before we start holding source folios
>> > > locked for collapse. Keep page_cache_sync_readahead() and its existing
>> > > policy, and drop each folio's lock and reference after checking that it
>> > > is uptodate. If truncate or reclaim removes a folio between the two
>> > > passes, roll back instead of doing readahead again with source folios
>> > > locked.
>> > > 
>> > > Shmem handles swapin and fallocated folios through shmem_get_folio()
>> > > without taking mapping->invalidate_lock, so it isn't affected by this
>> > > lock inversion.
>> > > 
>> > > Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
>> > > Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
>> > > Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
>> > > Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> > > ---
>> > 
>> > Thanks for the fix.
>> > 
>> > > Thanks to Nguyen Ngoc Thang for v2. David asked for volunteers, so I'm
>> > > happy to take this over.
>> > > 
>> > > Some older stable trees lack the folio infrastructure used here, and the
>> > > code will differ for each stable tree, so each backport will need quite a
>> > > bit of rework and its own review. I'm not sure whether to Cc stable here.
>> > > Once we agree on the fix, I'll send a separate backport for each maintained
>> > > stable tree except 5.10, which isn't affected.
>> > > 
>> > > v2 -> v3:
>> > >   - Replace the scan-wide invalidate_lock and page_cache_ra_unbounded() with
>> > >     a preparation pass using page_cache_sync_readahead().
>> > >   - Roll back on a new page cache miss during collapse.
>> > >   - https://lore.kernel.org/all/20260913163644.122133-1-ngocthang2710.1999@gmail.com/
>> > > 
>> > >   mm/khugepaged.c | 42 +++++++++++++++++++++++++++++++-----------
>> > >   1 file changed, 31 insertions(+), 11 deletions(-)
>> > > 
>> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > > index ef5cd6fda34f..b3f67617caf0 100644
>> > > --- a/mm/khugepaged.c
>> > > +++ b/mm/khugepaged.c
>> > > @@ -2262,6 +2262,34 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>> > >   	new_folio->index = start;
>> > >   	new_folio->mapping = mapping;
>> > > +	if (!is_shmem) {
>> > > +		/*
>> > > +		 * Populate the range before accumulating locked source folios:
>> > > +		 * readahead may block on invalidate_lock.
>> > > +		 */
>> > > +		for (index = start; index < end;) {
>> > 
>> > why drop xas_unlock_irq()?
>> > 
>> > > +			folio = filemap_lock_folio(mapping, index);
>> > > +			if (IS_ERR(folio)) {
>> > > +				page_cache_sync_readahead(mapping, &file->f_ra,
>> > > +							  file, index, end - index);
>> > > +				folio = filemap_lock_folio(mapping, index);
>> > > +				if (IS_ERR(folio)) {
>> > > +					result = SCAN_FAIL;
>> > > +					goto rollback;
>> > > +				}
>> > > +			}
>> > > +			if (!folio_test_uptodate(folio))
>> > > +				result = SCAN_FAIL;
>> > 
>> > Do we need to check PG_uptodate after locking the folio? If we successfully
>> > lock the folio, doesn't that mean the read I/O has completed? The following
>> 
>> Yes, you do; a read can "complete" without the IO having completed successfully,
>> and in those cases PG_uptodate is not set, but the folio is unlocked.
>> 
>> Either way, why are we checking for uptodate here? We only care for starting readahead.
>> Anyway, I would possibly recommend we do this as post-processing, not pre-processing.
>> The current loop is a little overhead-happy.
>
>To clarify: I would do this kind of RA as an error path if isolation failed.
>Namely, at the end of rollback, after unlocking folios. It doesn't make sense
>to me to do this kind of checking upfront. I don't think it's particularly
>realistic that, starting RA upfront, you'd see uptodate completed folio reads
>when doing the actual isolation.

Good call! I should have thought of that :P We can do this on demand after
rollback rather than walk the range every time :)

I played around with it a bit, something like:

---8<---
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 85ea095906fb..ce5d89ff47b3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2290,6 +2290,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	enum scan_result result = SCAN_SUCCEED;
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
+	bool do_readahead = false;
+	bool readahead_done = false;

 	/*
 	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
@@ -2307,6 +2309,10 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,

 	mapping_set_update(&xas, mapping);

+retry:
+	result = SCAN_SUCCEED;
+	do_readahead = false;
+	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
 	__folio_set_locked(new_folio);
 	if (is_shmem)
 		__folio_set_swapbacked(new_folio);
@@ -2371,17 +2377,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			}
 		} else {	/* !is_shmem */
 			if (!folio || xa_is_value(folio)) {
-				xas_unlock_irq(&xas);
-				page_cache_sync_readahead(mapping, &file->f_ra,
-							  file, index,
-							  end - index);
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
-				folio = filemap_lock_folio(mapping, index);
-				if (IS_ERR(folio)) {
-					result = SCAN_FAIL;
-					goto xa_unlocked;
-				}
+				do_readahead = !readahead_done;
+				result = SCAN_FAIL;
+				goto xa_locked;
 			} else if (folio_test_dirty(folio)) {
 				/*
 				 * This page is dirty because it hasn't
@@ -2704,6 +2702,30 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	new_folio->mapping = NULL;

 	folio_unlock(new_folio);
+
+	/* Readahead may take invalidate_lock; source folios are unlocked. */
+	if (do_readahead) {
+		for (index = start; index < end;) {
+			folio = filemap_lock_folio(mapping, index);
+			if (IS_ERR(folio)) {
+				page_cache_sync_readahead(mapping, &file->f_ra,
+							  file, index, end - index);
+				folio = filemap_lock_folio(mapping, index);
+				if (IS_ERR(folio)) {
+					result = SCAN_FAIL;
+					goto out_put;
+				}
+			}
+			index = folio_next_index(folio);
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		/* Drain the local LRU batch before retrying isolation. */
+		lru_add_drain();
+		readahead_done = true;
+		goto retry;
+	}
+out_put:
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
--

Cheers, Lance

