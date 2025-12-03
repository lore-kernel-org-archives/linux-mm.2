Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337B4D15DB6
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 23:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90BDD6B002A; Wed,  3 Dec 2025 18:25:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3876B002B; Wed,  3 Dec 2025 18:25:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8716B002C; Wed,  3 Dec 2025 18:25:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF2E6B002A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:25:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16D5F1606F3
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:25:30 +0000 (UTC)
X-FDA: 84179743620.13.2E2EA47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8A9A5A0003
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:25:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pQzPjEFP;
	spf=pass (imf25.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764804328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z498MzxAZteo/xwTRoG99m7sj4E0YFpbb9L3gGPbL58=;
	b=2BvmyRh4k6s88QsiZhYkKkV0UkQ72EAFkZFxZUQhHlKrahXN+ebG0jwyXbdIrLRT5rPsXQ
	lYW3zDA8YgHjFXM8H77wxgjoUfsC+Xn5VzGqO/agJfOOyHkh/JLls763t5owx/jJ9Z2mZ3
	UrzJfce2NNaPUb1Um3Y+omRcn58gKgs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764804328; a=rsa-sha256;
	cv=none;
	b=fDg379n+FqG3kWyRTDNe1yrjhDiDx4YKanFWMC4BufGUZQhx+iZG+Vf9m5scJEkKDO00SD
	VbjIkORMSvKmGnzm2fss3B2P45joB6Aam+CiJqyCN6xjXPkvh2HYrGPC9hze/89EvxhmTy
	PrGi+mr2eax8ZMm5rISoJdJcjZCBpwE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pQzPjEFP;
	spf=pass (imf25.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9A7A60176;
	Wed,  3 Dec 2025 23:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430AEC19424;
	Wed,  3 Dec 2025 23:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764804327;
	bh=sAJej4HZTiYDfV7VEYcwaKg9Xwk914WW6wlk1yPGQEk=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=pQzPjEFPD8N74U1fP1gOFDJDMKcIZviYG5+wt0HlBqPGc0RIFUQQW6xd4cnrlyWMq
	 P+Mddndf3V5rcRbC1NkvnFKPsD5HVrspRuDuRkMuJ9YYxbmFpBdRpD5cOfet1H0e+F
	 vD4Ikj+8E/yma5BlgCY/ipAKL46xBGTnuFDdnTI0H1jem5Y1DOlRFu4MWybtgZbb8G
	 +mxx1ZViFrEiDfRwRcCTUIjWRvSOEfqBF9wlB+fLW9LQyTJBphmKyGONFOc72r6nQq
	 kaOwqWlPK8LxWDOTkff6xuvGUAO0mEnPQAibAZRi8BipuaVQ5TAHTH1A9qX7jqJVJ9
	 424U5byWd05LQ==
Date: Wed, 3 Dec 2025 23:25:25 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 3/3 v2] mm/readahead: try to allocate high order pages
 for FADVISE_FAV_WILLNEED
Message-ID: <aTDG5RVirKFisCGT@google.com>
References: <20251202013212.964298-1-jaegeuk@kernel.org>
 <20251202013212.964298-4-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202013212.964298-4-jaegeuk@kernel.org>
X-Rspamd-Queue-Id: 8A9A5A0003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 7i71orzee3g31zbhptyb1gjxw54kustx
X-HE-Tag: 1764804328-907552
X-HE-Meta: U2FsdGVkX19qT6QLf+7rrR3FRUrw9aTMLX23BFJQpMu5jp/fIbPSGMpFLzP6HJBjHNWPTO+VBEVJV43sUhCImLbBOTWbgSzzldvpWhZ1LLuQH5998lbn1wFmwnZ+bzJCKKs9RNARG3HF24mXVWvnaTsehrZEFU3Kl42RU2hUcxP0oNcseKth+03jqoe29E6O7SStIqVyMNwfYzbXJ9ZEu2A1z8DlqEN2Z/pn5dGud3cEaYkUm/SqqAH/TwOZGv9ILf8Ga/MvveJpgyHjwVF54HjNYWj5gIyrnGn8Ifuexa5nNWEIIF+NvEBR3QLaFKpHNvMXHPqusMlbvC0s72e3XVc5Mh9e73LwhdNEEAp1ZcWPStDo+n3IqoG4R0/NrW+9LNosWSIArz0fHrAVaFOCJF8hZUn/bLpWyPl2rC3RMgA8EBdVYOQ91R8MHfyC6zXopwsyPUJuwD4mkJU/S6R2rGcD+g8nREWRSB6dcGD/DDDLy65jVbV0DqcxLLO240eR55prOq8Vzi+8Arij2qSYP5c85/uMZiKEpcItdFqPkY8/ooCeKRmI+hSNxmVx12IHAG6wI31UzKZTnnF3af42n7TVHWdS8fqzkyTckMokBlcctfo9BVyB9UI/BTYvYS9y1EA6nJHyx7nnnAk1AXNsz+LTceNebyERCQFxxKbqkWh5tO8ZA9bN5FsZsYvmH7r2Y63M4BK7lrhOvUA88WeKmAwWgADNq/9Dcs3GvMPe3cR23wnTdoA9YJ3mcN0B7YoNSz+xWsfVW4S5U+VsUcry2yxlj1Aaq2q9DXd6Xq9qTdDp6Y/Rw7c2SD+JeiB7pPn3ph24SUurXrTbaKPUuegixY1NSgpCX4VLQjoY+49nfjowz7HqLZrfRSvu5qflWxL62Q/qMVD4cUX6yg5uCXJY2fcfwiarVMgOUj3LHlcl+gE5YNdzwupl3WO/zw28YYW1Dd1FiSfhQeLWphnnYnA
 q/7rr7cZ
 Q0uPqK11CyE4R7WRDf5wHuXUbTUOgJZD8rG6DBONvzaQLvBUeYY1mMCXq/Pcuif8uGgqLOkQRBQNH89wE0JPFQgCbSoQQzytV1ay1jSWQjWGGcCfaH8jec/mfhaUYwaeg2w5uC/YJ8J3g6Gj4NElg9RDd6778vgaBwu0gPdjHMTjtaTcakV5DeoxJaNmjoDIs99OCwl6guEnNOGpGEdA45IawnZ+3cuiSgXU9ozylIvHDQJz2lToKnlIQi8pauX5Mya2NGEU8zvVejYx8r2pXbUcjUkPmDxxygjBSV4MiAdoxVBPc1qmclZdANGeCryQn9BXz0hZ/Op02dGG1TkiU7d9kr8xU4iYKp6W0JEVboVLET0MdD6LhATNnpCeHdv54haDZiCX+Oth7EY3NPeSHtkMvvoW33tp0C+4JVlQNmzk03pjAbHExSTRUmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch assigns the max folio order for readahead. After applying this patch,
it starts with high-order page allocation successfully as shown in the below
traces.

Before:
 f2fs_fadvise: dev = (252,16), ino = 14, i_size = 4294967296 offset:0, len:536870912, advise:3
 page_cache_sync_ra: dev=252:16 ino=e index=0 req_count=2048 order=0 size=0 async_size=0 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=0 order=0 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=2048 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=2048 nr_to_read=2048 lookahead_size=0
 page_cache_sync_ra: dev=252:16 ino=e index=4096 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=4096 nr_to_read=2048 lookahead_size=0
 page_cache_sync_ra: dev=252:16 ino=e index=6144 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=6144 nr_to_read=2048 lookahead_size=0
...
 page_cache_sync_ra: dev=252:16 ino=e index=129024 req_count=2048 order=0 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_unbounded: dev=252:16 ino=e index=129024 nr_to_read=2048 lookahead_size=0

After:
 f2fs_fadvise: dev = (252,16), ino = 14, i_size = 4294967296 offset:0, len:536870912, advise:3
 page_cache_sync_ra: dev=252:16 ino=e index=0 req_count=2048 order=0 size=0 async_size=0 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=0 order=2 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=2048 req_count=2048 order=2 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=2048 order=4 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=4096 req_count=2048 order=4 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=4096 order=6 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=6144 req_count=2048 order=6 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=6144 order=8 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=8192 req_count=2048 order=8 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=8192 order=10 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=10240 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=10240 order=11 size=2048 async_size=1024 ra_pages=2048
...
 page_cache_ra_order: dev=252:16 ino=e index=126976 order=11 size=2048 async_size=1024 ra_pages=2048
 page_cache_sync_ra: dev=252:16 ino=e index=129024 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=129024 order=11 size=2048 async_size=1024 ra_pages=2048
 page_cache_async_ra: dev=252:16 ino=e index=1024 req_count=2048 order=9 size=2048 async_size=1024 ra_pages=2048 mmap_miss=0 prev_pos=-1

For comparion, this is the trace of madvise(MADV_POPULATE_READ) which bumps up the order by 2.
 page_cache_ra_order: dev=252:16 ino=e index=0 order=0 size=2048 async_size=512 ra_pages=2048
 f2fs_filemap_fault: dev = (252,16), ino = 14, index = 0, flags: WRITE|KILLABLE|USER|REMOTE|0x8082000, ret: MAJOR|RETRY
 page_cache_async_ra: dev=252:16 ino=e index=1536 req_count=2048 order=0 size=2048 async_size=512 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=2048 order=2 size=2048 async_size=2048 ra_pages=2048
 f2fs_filemap_fault: dev = (252,16), ino = 14, index = 1536, flags: WRITE|KILLABLE|USER|REMOTE|0x8082000, ret: RETRY
 page_cache_async_ra: dev=252:16 ino=e index=2048 req_count=2048 order=2 size=2048 async_size=2048 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=4096 order=4 size=2048 async_size=2048 ra_pages=2048
 f2fs_filemap_fault: dev = (252,16), ino = 14, index = 2048, flags: WRITE|KILLABLE|USER|REMOTE|0x8082000, ret: RETRY
 page_cache_async_ra: dev=252:16 ino=e index=4096 req_count=2048 order=4 size=2048 async_size=2048 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=6144 order=6 size=2048 async_size=2048 ra_pages=2048
 f2fs_filemap_fault: dev = (252,16), ino = 14, index = 4096, flags: WRITE|KILLABLE|USER|REMOTE|0x8082000, ret: RETRY
 page_cache_async_ra: dev=252:16 ino=e index=6144 req_count=2048 order=6 size=2048 async_size=2048 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=8192 order=8 size=2048 async_size=2048 ra_pages=2048
 f2fs_filemap_fault: dev = (252,16), ino = 14, index = 6144, flags: WRITE|KILLABLE|USER|REMOTE|0x8082000, ret: RETRY
 page_cache_async_ra: dev=252:16 ino=e index=8192 req_count=2048 order=8 size=2048 async_size=2048 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=10240 order=10 size=2048 async_size=2048 ra_pages=2048
 f2fs_filemap_fault: dev = (252,16), ino = 14, index = 8192, flags: WRITE|KILLABLE|USER|REMOTE|0x8082000, ret: RETRY
 page_cache_async_ra: dev=252:16 ino=e index=10240 req_count=2048 order=9 size=2048 async_size=2048 ra_pages=2048 mmap_miss=0 prev_pos=-1
...
 f2fs_filemap_fault: dev = (252,16), ino = 14, index = 518144, flags: WRITE|KILLABLE|USER|REMOTE|0x8082000, ret: RETRY
 page_cache_async_ra: dev=252:16 ino=e index=520192 req_count=2048 order=9 size=2048 async_size=2048 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=522240 order=11 size=2048 async_size=2048 ra_pages=2048
 f2fs_filemap_fault: dev = (252,16), ino = 14, index = 520192, flags: WRITE|KILLABLE|USER|REMOTE|0x8082000, ret: RETRY
 page_cache_async_ra: dev=252:16 ino=e index=522240 req_count=2048 order=9 size=2048 async_size=2048 ra_pages=2048 mmap_miss=0 prev_pos=-1
 page_cache_ra_order: dev=252:16 ino=e index=524288 order=11 size=2048 async_size=2048 ra_pages=2048
 f2fs_filemap_fault: dev = (252,16), ino = 14, index = 522240, flags: WRITE|KILLABLE|USER|REMOTE|0x8082000, ret: RETRY

Cc: linux-mm@kvack.org
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---

 Change log from v1:
  - take the same madvise() behavior which bumps up ra->order by 2.

 mm/readahead.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 54c78f8276fe..61a469117209 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -593,7 +593,8 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 	 * trivial case: (index - prev_index) == 1
 	 * unaligned reads: (index - prev_index) == 0
 	 */
-	if (!index || req_count > max_pages || index - prev_index <= 1UL) {
+	if (!index || req_count > max_pages || index - prev_index <= 1UL ||
+	    mapping_large_folio_support(ractl->mapping)) {
 		ra->start = index;
 		ra->size = get_init_ra_size(req_count, max_pages);
 		ra->async_size = ra->size > req_count ? ra->size - req_count :
@@ -627,7 +628,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 	ra->size = min(contig_count + req_count, max_pages);
 	ra->async_size = 1;
 readit:
-	ra->order = 0;
+	ra->order += 2;
 	ractl->_index = ra->start;
 	page_cache_ra_order(ractl, ra);
 }
-- 
2.52.0.223.gf5cc29aaa4-goog


