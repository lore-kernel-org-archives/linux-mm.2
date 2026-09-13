Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A40C4C88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 16:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4627D6B0088; Sun, 13 Sep 2026 12:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413626B008C; Sun, 13 Sep 2026 12:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3030F6B0092; Sun, 13 Sep 2026 12:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC8ED6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 12:13:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45CA1A0840
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:13:05 +0000 (UTC)
X-FDA: 85209233130.05.106E75D
Received: from mta0.migadu.com (out-207.mta0.migadu.com [91.218.175.207])
	by imf24.hostedemail.com (Postfix) with ESMTP id C99AC180009
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:13:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HhB7gsTD;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.207 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789315983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNWGWCyfOe6Qt2zf2+kBDQKoLm23g9MPjehgcRUD7EY=;
	b=wWDgemXjdhORYdBcctJj/6Id8O3jwAmAqwjLHtZNTRRCiXKOXkNd8MDcO7D7VhOU00ktOY
	G+vo64cbe/vHyGDhFHBf6jObLii2eS/h/uA1U3nixJ8mfN/9Z3oV56g22kWn0qxZzPpnCm
	rfWiGv2fpuwr2tKG3ay/7yrifMiw9Kc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789315983;
	b=ZfjdnbIc8n7tIdW2tuz4C7On/dZsG9S0ii3tczNC5JbR8PDTwDzLSaSB19YHZciSFmBFov
	RE0h0wWVeQxIGnAvDZ4nmP9lGPI04k947lWNIDxpRK4Jb2MumzXgKp1SaLj63GP3VSteeE
	sWzbGPYe3Q5T7ntlrPm+TnopXQF6nFA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HhB7gsTD;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.207 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bYW+WBfUVJNpYRJUhNYP1JLnrq8AC9Bl88josSCvXZ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789315981; v=1; x=1789920781;
 b=HhB7gsTDUtQ9yxiqsmebYlV22PLtT3q1omZZ0IgdSHvvQnhxCWi+Em9i8QyMH1Ac4MdmwsVh
 J1mwdiZbtmvo4phdUf6zOPQMj7YOcg8VLZAfMaIaIYzWDi7kUrii3JhYRTHrgnn6xEfrlr0idFB
 MFKDLGyaq1KFlVgVaQbKlTlQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d6824c7a9c4362fc;
	Sun, 13 Sep 2026 16:12:50 +0000
X-Mizu-Trace-ID: d6824c7a9c4362fc
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ngocthang2710.1999@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] khugepaged: hold invalidate_lock across collapse_file() readahead
Date: Mon, 14 Sep 2026 00:12:45 +0800
Message-Id: <20260913161245.11120-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260913101142.28802-1-ngocthang2710.1999@gmail.com>
References: <20260913101142.28802-1-ngocthang2710.1999@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C99AC180009
X-Stat-Signature: ysm5r56n1nhjp9o14dnhr5zif6mzg8pj
X-Rspam-User: 
X-HE-Tag: 1789315982-490026
X-HE-Meta: U2FsdGVkX1/9AzfWPHh7Q4TvOxFeuZWZxwxOzsEw96X0oMoYTi0bpYxKNyfV6tB57EFe7nboxRa0+RJhr6C3JKnlKkNT9a5aNHbnps9p7w3fRmMtPti3VJF1uimvrC7BeChOGCrTieBnROvSqUQqYygVVuM6OH5xNmIWK1ZKImR2h7j6sY3/Ap2iL4lIIo4c+mbiCp/5Zog0feIIv9PY5vn0S9fG3QJ7HyU41MvugS8oLGSHyiJ7nxSJ0tBs+GUAfCU5UNssF+/d53oaTKjGEa/7Tr/BbZz+wBEILEZf2p0m8QsbKclO9HcM53jDCn3bjJ9R4yZRLxc4gtDIr6nlwVYH3llv0SYHiHe92p4R2TAUK2iWZVDPk8AjVTdAtrWl1H8OJhr55VfU8CDb9mpQCJbE7kIFFUnWL3tPRHwiOan71blIGc5injObJJfYrCKU6CeGqGsOMrgNhO73Sf5wFYBT6OVBDlAFd6FjdGZK+YDWv3EkgA/gfAqiUNrbl1Vcik3xXYJTvXEfPRegjMe/VgK3WJxO9ymrDLgDMUfMkJSExjFWxPLlzqXNDPj5nxneswPZlQQoW7DjtmqmzzlToTZlJoJIK++RND5vcx/eHt9rg7Bf5bjxshC3ZTH7nQt0wuu0ks3TayaZ1aMkJi+AKPReySyfrWXMZwPugWtb6JkGzuN0fl4w9EZY/OZ1hJV7w0wyRBqQI78wpH9Gt8qRLuztZYlGf6GiCXluntFqKmZ1d0YQph6KoXg9gOIYV9OEwzlxSFnOf78rBcjfQu7H79K6nH1XUDWxd6EgIHUsw5KcEE+G/ZHw8fLZ9Ft9Qm/PbmZleVf11qACWJ7FqCnJ+4Ydiz1Rkd4GbKHbHyU7qu2jMJYtW99QY+IN+l2HnfcEZKtppXVEguar3aYaZRyIf7gHp8f9XVZnkxeHhHhs2lnyyS7zy20A47WgKT9oIwhOG8vvLNMZBsz3E2xBjXN
 xCqv9Ozw
 f/8me3cvqUNkHj+CcDnSSr3fZWQ0diV+675kLiaj04u4hduQF8pxzqnOCTc3Io5YveGvqyJvo68su4o5tdVoahuUKinFQw9ddLYEMozIQclHDRgprhJAwC5aROuXHt7NHmsKzKShdiJsAxCyX6A9PXZmTNZCd0Fz7omVgtasnhyZ/Rk4sCS4hoUZowttQ6XNPcLQxHbQDn9MaXeHjGpHaG1eYa0r0pARlRjIvgiG0INIspp9m/B7FhmqCvMVxerev3Ms4JxktalwZ+Hkm8CAUUtSI3ECjUzNhxEFfA5LC7IpEUq/W/tmwva8YO6NWrgDpGlzR4QYsbMkifyn3M3AnJ/Df4N97lurNmBovT8I2LSwECOsKu8Sjm0Nb06+kPKKQmIZ8X3dSmzdyqUykJ52huGQ4bZjZ2ByDVjvlQ/O3aQ8XtcKIAlyyhrsQHS7NfuYkg8DIjJ2vYenzT/erK5ZN+KgQeXn0n+OLgxir7M6z5y8OQ/mzaqtcyqzdE98ZKw4G6qVwRa0eNidU1886lsRDcd1tYTcH6IvF9FUr99/J0YCRqI3t934JvRbcuA72EmJMrl4p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nguyen,

Good catch, thanks!

On Sun, Sep 13, 2026 at 05:11:42PM +0700, Nguyen Ngoc Thang wrote:
>collapse_file() calls page_cache_sync_readahead() to fault in missing
>pages before collapsing them into a THP. That helper takes
>mapping->invalidate_lock itself for the duration of the call, then
>drops it -- but truncate (e.g. ext4_setattr() -> truncate_pagecache())
>takes invalidate_lock and then waits on each page's folio lock while
>holding it. If collapse_file() has already locked one of those folios
>by the time truncate reaches it, and then tries to acquire
>invalidate_lock again (e.g. on the next iteration, or via a nested
>readahead call), the two paths can deadlock/hang on each other's lock:
>truncate blocked on the folio lock collapse holds, and collapse
>blocked waiting for invalidate_lock that truncate holds.

That can happen on the first readahead call.

>
>Reproducing this over ~150,000 collapse iterations with truncate
>racing concurrently reliably hits hung_task: blocked tasks within
>about 20 seconds on an unpatched kernel.
>
>Fix it by taking invalidate_lock_shared once for the whole scan, before
>locking any folio, and using page_cache_ra_unbounded() directly in the
>readahead call site instead of page_cache_sync_readahead(), since the
>latter would try to retake the lock we already hold.
>page_cache_ra_unbounded() does not clamp to EOF like the helper it
>replaces, so clamp the requested range explicitly.
>
>Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
>Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5

Ouch, we should add a Fixes tag and Cc stable:

Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
Cc: stable@vger.kernel.org

730633f0b7f9 added invalidate_lock acquisition to readahead but missed
collapse_file(), which already called it with page locks held. The
subsequent filesystem conversions made the deadlock possible by taking
invalidate_lock before locking pages :( right?

>Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
>---
> mm/khugepaged.c | 25 ++++++++++++++++++++++---
> 1 file changed, 22 insertions(+), 3 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 11ff98d55c76..690ccbcdf593 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -2267,6 +2267,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
> 	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
> 
>+	/*
>+	 * Take invalidate_lock before any folio lock: the readahead below
>+	 * needs it, and truncate holds it while waiting on folio locks.
>+	 */
>+	if (!is_shmem)
>+		filemap_invalidate_lock_shared(mapping);

Could we take the lock after alloc_charge_folio() succeeds, before
locking any folio? That would keep allocation and charging outside the
critical section. And if allocation fails, we should skip the unlock :)

Cheers, Lance

>+
> 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
> 	if (result != SCAN_SUCCEED)
> 		goto out;
>@@ -2337,10 +2344,20 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 			}
> 		} else {	/* !is_shmem */
> 			if (!folio || xa_is_value(folio)) {
>+				DEFINE_READAHEAD(ractl, file, &file->f_ra,
>+						  mapping, index);
>+				pgoff_t eof = DIV_ROUND_UP(i_size_read(mapping->host),
>+							    PAGE_SIZE);
>+
> 				xas_unlock_irq(&xas);
>-				page_cache_sync_readahead(mapping, &file->f_ra,
>-							  file, index,
>-							  end - index);
>+				/*
>+				 * invalidate_lock held above; don't retake it.
>+				 * page_cache_ra_unbounded(), unlike the readahead
>+				 * helper this replaces, does not clamp to EOF.
>+				 */
>+				if (index < eof)
>+					page_cache_ra_unbounded(&ractl,
>+						min(end, eof) - index, 0);
> 				/* drain lru cache to help folio_isolate_lru() */
> 				lru_add_drain();
> 				folio = filemap_lock_folio(mapping, index);
>@@ -2672,6 +2689,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 	folio_unlock(new_folio);
> 	folio_put(new_folio);
> out:
>+	if (!is_shmem)
>+		filemap_invalidate_unlock_shared(mapping);
> 	VM_BUG_ON(!list_empty(&pagelist));
> 	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
> 	return result;
>-- 
>2.43.0
>
>

