Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F84C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7541A6B008C; Wed,  9 Sep 2026 08:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC936B0092; Wed,  9 Sep 2026 08:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4C06B0093; Wed,  9 Sep 2026 08:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 331606B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:23:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81DBC1C0918
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:23:02 +0000 (UTC)
X-FDA: 85194138204.17.B3611F6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 068C7A000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:22:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xMWzteXn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ZMbUSxJ/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zdHebBXT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YNAOxb7a;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788956580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=081DfqZYJ67fRJ5TkbDWVgSiZBa+jC0p668G6F1xrBQ=;
	b=3HrMREMxHpJHX0iwqNzCBtWBpAevduSWCiGDS7eO4pcsef6lcCdkWCNi70Wa39cDkJe98f
	pYmBPoqsE1TF5KW7hTOWU1Mc2iWOgl7YRa1rStajQjGsaY9QvqyCMMXJ3Jd3Gz+tRMyDO3
	S2R9Ly01FVaHuEMaHCYGsBwDkADocJQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788956580;
	b=f9KEEK7uetd4HG0EOtwRs+/Os4D4I9bVkjeLg4azGwZ/ECvBP/785DcxhivVT2AFMMaFVT
	A7+oDZngX3naxEcPlQK7IC4D984qIXPq1Y+TJdgc/AL3SfpMwNLEThFkhClUw0SgBsRHS9
	FAsp+B/6wKys/dTn96YIqRU+6xBZiJY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xMWzteXn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ZMbUSxJ/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zdHebBXT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YNAOxb7a;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F12FA1FB08;
	Wed,  9 Sep 2026 12:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788956574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=081DfqZYJ67fRJ5TkbDWVgSiZBa+jC0p668G6F1xrBQ=;
	b=xMWzteXnfOvr7W/s7ivuFQmm1nlxThsjWE0HAkNslw1uwfBaLlsryFeMB2s4CbjmZDvyaH
	Wm31pN6IPVn4hegx3fOi8jcTG/TmG1AM66E1zoK7U8uuPEA9g3mBS2byIK1N9dCwcO89Ry
	RHcXcT3kKrkvX5g8l6nRqb2i+YE5hZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788956574;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=081DfqZYJ67fRJ5TkbDWVgSiZBa+jC0p668G6F1xrBQ=;
	b=ZMbUSxJ/GVHkPN16J2Fs02WbLJnnhKmXXfDL8RE4Z1tE6k6D8ZT/xDlGUtx9Y46Xv9nChp
	AaD/CISA+VhJ91CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788956570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=081DfqZYJ67fRJ5TkbDWVgSiZBa+jC0p668G6F1xrBQ=;
	b=zdHebBXTZQjkq3KtkxN7ruIv0KBfyUtw9VqFEBn/pTJsh4tmTd6+B3lpoejpP9nCPYYiFW
	z9mDDum2fy6LC0jACYDUf9mtnJ45Ya+qi4/hp5zT8X3TkKmicu2Lc2rH5sACjhSmSYUX+L
	8fbuepQB/rJvg4bFoI5fXUq6g/RPi1I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788956570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=081DfqZYJ67fRJ5TkbDWVgSiZBa+jC0p668G6F1xrBQ=;
	b=YNAOxb7aa8SvbTfib3kKfv+UtI8CkNa9qTIJjYiWbTDqJBScyo1FrwAmegiA4nD7++exuL
	oK1huHaABmBohyBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C93D213185;
	Wed,  9 Sep 2026 12:22:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DrsZMZlPoWpWMgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 09 Sep 2026 12:22:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4C6C3A1341; Wed, 09 Sep 2026 14:22:45 +0200 (CEST)
Date: Wed, 9 Sep 2026 14:22:45 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hughd@google.com, 
	baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz, ziy@nvidia.com, 
	bfoster@redhat.com, joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com, 
	yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating straddling
 large folios
Message-ID: <2fu7s7ewyeal353zaum3dzn3t5vcqu5hff7u4kcogcvl77ksur@omxo5kvwi4w3>
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ua1r34sanonf46q1doj5ij616uex19h9
X-Rspamd-Queue-Id: 068C7A000A
X-HE-Tag: 1788956579-707992
X-HE-Meta: U2FsdGVkX1+PJh4U5p4aV5K1IiWFOADAVUeDtY+bHEFW+tBL13rnB7oNl1KBwDAGjQbR4xDYXtUuDK8tnoBFX+BHGjZ5K53ok6usuBLd3kSITkqCj+5m9iGegxD9lpEg+WzKw5oF7+ty+2XPSn8e7KMf8pvY07c1aZSeVVNiz5rf0vHTzEZGGok7wfAHQkKGz2yLiob2EMZtaT8r5W+DigB+/WYZ0AUEMnX6+1bE0cIDlcZoBvz9QWPliBB/m/ejNHPsCRS0VuMUUJKuIf+ZEw1nOS368MoHzgoGpMj7n3voxAoaP0cTTrfLEfbMGpobjr6Zk8k/bqf1Ds52P+yGnJSeXq2xYVgk+cM+Ka40ytV0hgDFpMjmvi80NjNTwHMfVZr9mmfmVAANbyxHyfxnHD9MiWh9rH3rgCnaXglPUEsiqDcYDXYSeRhCfU/ejftrJVHDrTcr+6fJTla6xheGosXzZJFRrl5xLKjaVnNAAtn47WsI/nKYb49OrqgVExrH2xpl9Xlvt0vnpHnSliwqe3NuH4F9sgcvQ/dS4+V/iSp9rzcp5NTcSywq1IDBUUzA7z4/jo1iwmyqRkhu2kqhoUeD/y/nH1E94WEgVA+0lLjeQ1rhVh2zStkakwmF5cmMgO2qKzV7ZuasgnWyk5xcev9ac/FkPNU30DLPt3HAjnAHK30T31oZpL/kI8AfIOmmP5rT/78+0GIczslfExTU7BFUngrYo5Jd3ua9VSo4bHrx2+gCGeFxJhFQ2iDdB56zAQ+Wvq1BsryC11jyo4E5Yp88RKNpho4/fE0Dce67/8V80kQvoVS9QcWB8yEW3jjtJl2+AbWkmroLfM1b6XGCko0qBb4waf7qkU3OExhv0hmRVR3U6V2JpOl3+cGO6PRerOlmL2gnUrxq14222lokNuzJcSuoZK8lWzWB/AnpnMgNP0gKB6MaqfZWP5cHznCxp0B05LzQ9TAsLsxrX2h
 oe4M1jSZ
 A4XiWE1zr7cfcZajUrQlqV/sL2NHYB+AeBQljTts32GJ2FhSjLxZav7XnVRJ0x91IOLd0OUKpZmYgRNNA/ebNhw6siezLltIxqqTq9wcTjNhOY/IQ+MHESXW4lku1QSJsooZWWJd73puRn338OEkr3J3SkUMDCwojLVBba6KpwK5eE66rlvQJMzsrBsRzCp3GXr2eiuF9zKKKGakpe/b/5MCAUsJYy0QEvwnFPaODdubH2ClUcsMqPfV8dp0RGDoyRaTCSItalNJGCqccWyb68TzjjzDGy98lm83UQiz/H1mc/LORZxGo2GUSq4Jj/L3oC1OYghAUPgaQwUOsRFX8npcoj27BLBbi75EEHPG5soN58nPJE6pjRlYHdZ0NpB/UDw7yfviIUjXd8ygJ1dsxDBajsGuj/Qm5VSJFPqhjw6Ry9dqMYqX8SEFULg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 09-09-26 14:23:39, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
> 
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
> 
> For example, a 4-page order-2 folio punched from offset 0 to the middle
> of the last page:
> 
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()      # same_folio == true
>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>       folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>       2nd split of folio2 fails / cannot lock
>       return true                       # BUG: caller keeps default end
>     end = 3
>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
> 
> This became reachable after commit 7460b470a131 ("mm/truncate: use
> folio_split() in truncate operation") replaced the atomic split_folio()
> with folio_split(), whose non-uniform split can partially split a folio
> and leave the end edge merged.
> 
> It has gone unnoticed because a dirty large folio normally carries the
> filesystem's private data, for example buffer_head, so
> filemap_release_folio() -> iomap_release_folio() returns false on a
> dirty folio and folio_split() aborts with -EBUSY before any split,
> leaving the straddler safely unsplit. The bug is only reachable on paths
> that produce dirty large folios without filesystem private data, and it
> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
> attached.
> 
> In addition, even when both splits succeed, data can still be lost when
> the mapping's minimum folio order (min_order) is non-zero. folio_split()
> stops at min_order instead of order 0, so the sub-folio containing a
> split point stays aligned to 1 << min_order rather than to a page. The
> original success path left start at the page-aligned head of the range
> and set end to the exact page index of the end edge, neither of which is
> a folio boundary in general. Either one could land inside the large
> folio at its edge, and the truncate loop would drop that straddling
> folio together with its valid out-of-range tail.
> 
> For example, a 64K (order-4) folio with min_order = 2 punched from
> offset 0 to 36K:
> 
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()        # same_folio == true
>       1st split at p0 -> [p0-p3, p4-p7, p8-p15]  # non-uniform, min_order
>       folio2 = p8-p15 # straddles: p8 in range, p9-p15 tail valid
>       2nd split of folio2 -> [p8-p11, p12-p15]   # success
>       end = p9                           # BUG: p9 inside [p8-p11]
>     loop truncates ... p8-p11           # p9-p11's valid tail is lost
> 
> Rework the contract so the caller is told the page range to discard:
> 
>   - Return true only when a split occurred, false otherwise. This
>     clarifies the existing confusing return value semantics.
> 
>   - Add pgoff_t *pstart and *pend out-parameters that receive the page
>     range fully covered by [lstart, lend] after any split (or none),
>     i.e. the pages wholly within the range and safe to discard. They are
>     aligned up (pstart) and down (pend) to the mapping's minimum folio
>     order so they always fall on a folio boundary.
> 
>   - Rename the byte-range parameters start/end to lstart/lend to avoid
>     clashing with the new outputs and to separate byte offsets from
>     folio indices.
> 
> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
> &pstart for the folio at the start edge and &pend for the folio at the
> end edge, so the truncate loop drops exactly the fully covered pages and
> never touches a straddling folio that still holds valid out-of-range
> data.
> 
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Thanks! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v1->v2:
>  - Export pstart as a new parameter so that the generic and shmem
>    truncate paths don't need to recompute the start value from the
>    return value. (Brian)
>  - When min_order is nonzero, align [pstart, pend] to the inner
>    boundaries of the folio to ensure they do not point into the middle
>    of a large folio, which could otherwise cause valid data within the
>    folio to be incorrectly cleared. (Joanne)
> 
> v1: https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@huaweicloud.com/
> 
>  mm/internal.h |  4 +--
>  mm/shmem.c    | 13 +++-----
>  mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
>  3 files changed, 67 insertions(+), 38 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 68db5abd0a4c..6e6ad3187378 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -627,8 +627,8 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
>  unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
>  		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
>  int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
> -		loff_t end);
> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
> +		loff_t lend, pgoff_t *pstart, pgoff_t *pend);
>  long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
>  unsigned long mapping_try_invalidate(struct address_space *mapping,
>  		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 89a1495e55f7..4efbbbba5da5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1175,11 +1175,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  	if (folio) {
>  		same_folio = lend < folio_next_pos(folio);
>  		folio_mark_dirty(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
> -			start = folio_next_index(folio);
> -			if (same_folio)
> -				end = folio->index;
> -		}
> +		truncate_inode_partial_folio(folio, lstart, lend, &start,
> +					     same_folio ? &end : NULL);
>  		folio_unlock(folio);
>  		folio_put(folio);
>  		folio = NULL;
> @@ -1189,8 +1186,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  		folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
>  	if (folio) {
>  		folio_mark_dirty(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend))
> -			end = folio->index;
> +		truncate_inode_partial_folio(folio, lstart, lend, NULL, &end);
>  		folio_unlock(folio);
>  		folio_put(folio);
>  	}
> @@ -1258,7 +1254,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  
>  				if (!folio_test_large(folio)) {
>  					truncate_inode_folio(mapping, folio);
> -				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
> +				} else if (truncate_inode_partial_folio(folio,
> +							lstart, lend, NULL, NULL)) {
>  					/*
>  					 * If we split a page, reset the loop so
>  					 * that we pick up the new sub pages.
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..d88a1b159084 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -206,35 +206,41 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
>  /*
>   * Handle partial folios.  The folio may be entirely within the
>   * range if a split has raced with us.  If not, we zero the part of the
> - * folio that's within the [start, end] range, and then split the folio if
> + * folio that's within the [lstart, lend] range, and then split the folio if
>   * it's large.  split_page_range() will discard pages which now lie beyond
>   * i_size, and we rely on the caller to discard pages which lie within a
>   * newly created hole.
>   *
> - * Returns false if splitting failed so the caller can avoid
> - * discarding the entire folio which is stubbornly unsplit.
> + * When @pstart and/or @pend are non-NULL they receive the indexes of the
> + * page range fully covered by [lstart, lend] after any split (or none),
> + * i.e. the range of pages that are wholly within [lstart, lend] and so safe
> + * to discard.
> + *
> + * Return %true if the folio was split, %false otherwise.
>   */
> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
> +				  loff_t lend, pgoff_t *pstart, pgoff_t *pend)
>  {
>  	loff_t pos = folio_pos(folio);
>  	size_t size = folio_size(folio);
>  	unsigned int offset, length;
>  	struct page *split_at, *split_at2;
> +	unsigned long min_nrbytes;
>  	unsigned int min_order;
>  
> -	if (pos < start)
> -		offset = start - pos;
> +	if (pos < lstart)
> +		offset = lstart - pos;
>  	else
>  		offset = 0;
> -	if (pos + size <= (u64)end)
> +	if (pos + size <= (u64)lend)
>  		length = size - offset;
>  	else
> -		length = end + 1 - pos - offset;
> +		length = lend + 1 - pos - offset;
>  
>  	folio_wait_writeback(folio);
>  	if (length == size) {
>  		truncate_inode_folio(folio->mapping, folio);
> -		return true;
> +		goto no_split;
>  	}
>  
>  	/*
> @@ -248,9 +254,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  	if (folio_needs_release(folio))
>  		folio_invalidate(folio, offset, length);
>  	if (!folio_test_large(folio))
> -		return true;
> +		goto no_split;
>  
>  	min_order = mapping_min_folio_order(folio->mapping);
> +	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
>  	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
>  	if (!folio_split_or_unmap(folio, split_at, min_order)) {
>  		/*
> @@ -259,38 +266,67 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		 * for shmem truncate
>  		 */
>  		struct folio *folio2;
> +		bool tail_isolated = true;
> +
> +		if (pend)
> +			*pend = round_down(pos + offset + length,
> +					   min_nrbytes) >> PAGE_SHIFT;
>  
>  		if (offset + length == size)
> -			goto no_split;
> -
> +			goto split;
> +retry:
>  		split_at2 = folio_page(folio,
>  				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>  		folio2 = page_folio(split_at2);
>  
>  		if (!folio_try_get(folio2))
> -			goto no_split;
> +			goto split;
>  
>  		if (!folio_test_large(folio2))
>  			goto out;
>  
> -		if (!folio_trylock(folio2))
> +		if (!folio_trylock(folio2)) {
> +			tail_isolated = false;
>  			goto out;
> +		}
> +
> +		/*
> +		 * split_at2 may no longer belong to folio2 due to concurrent
> +		 * split. Retry to find the correct folio in case it's still
> +		 * large.
> +		 */
> +		if (page_folio(split_at2) != folio2) {
> +			folio_unlock(folio2);
> +			folio_put(folio2);
> +			goto retry;
> +		}
>  
>  		/* make sure folio2 is large and does not change its mapping */
>  		if (folio_test_large(folio2) &&
> -		    folio2->mapping == folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> +		    folio2->mapping == folio->mapping &&
> +		    folio_split_or_unmap(folio2, split_at2, min_order))
> +			tail_isolated = false;
>  
>  		folio_unlock(folio2);
>  out:
> +		if (!tail_isolated && pend)
> +			*pend = folio2->index;
>  		folio_put(folio2);
> -no_split:
> +split:
> +		if (pstart)
> +			*pstart = round_up(pos + offset,
> +					   min_nrbytes) >> PAGE_SHIFT;
>  		return true;
>  	}
> -	if (folio_test_dirty(folio))
> -		return false;
> -	truncate_inode_folio(folio->mapping, folio);
> -	return true;
> +	if (!folio_test_dirty(folio))
> +		truncate_inode_folio(folio->mapping, folio);
> +no_split:
> +	if (pstart)
> +		*pstart = offset ? folio_next_index(folio) : folio->index;
> +	if (pend)
> +		*pend = (pos + size > (u64)lend) ? folio->index :
> +						   folio_next_index(folio);
> +	return false;
>  }
>  
>  /*
> @@ -413,11 +449,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
>  	if (!IS_ERR(folio)) {
>  		same_folio = lend < folio_next_pos(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
> -			start = folio_next_index(folio);
> -			if (same_folio)
> -				end = folio->index;
> -		}
> +		truncate_inode_partial_folio(folio, lstart, lend, &start,
> +					     same_folio ? &end : NULL);
>  		folio_unlock(folio);
>  		folio_put(folio);
>  		folio = NULL;
> @@ -427,8 +460,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
>  						FGP_LOCK, 0);
>  		if (!IS_ERR(folio)) {
> -			if (!truncate_inode_partial_folio(folio, lstart, lend))
> -				end = folio->index;
> +			truncate_inode_partial_folio(folio, lstart, lend, NULL, &end);
>  			folio_unlock(folio);
>  			folio_put(folio);
>  		}
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

