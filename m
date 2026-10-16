Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED8DCCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 13:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245AD6B0098; Fri, 16 Oct 2026 09:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216326B0099; Fri, 16 Oct 2026 09:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12CE56B009B; Fri, 16 Oct 2026 09:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D29246B0098
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:18:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68CAA1C3B76
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:18:51 +0000 (UTC)
X-FDA: 85328544462.20.DA638DF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 50A431C0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:18:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UnmfVm1t;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ev1VyZ7c;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w5tKgH8+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4eNxa2jk;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792156729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvOXCsd43Usn/ts9ZeDzJEb232W8k5UHTWzvCgsNFXk=;
	b=rCAY5a3YEjwLgwiLCXYTemEmsZavzI/Kiq21cDB5Li/HJ2Pe0H4ZBt11AXg962OcJRbwjc
	ELKPy532CrKUB93TbEGLlbF3JKl9hakzIgv+LlYW7prJ+P4Wtye0KpMZ5Pt7j9BCATHLGF
	mdP2hX2QDbKRYnrug9d+5NI9Mybm1Kw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UnmfVm1t;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ev1VyZ7c;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w5tKgH8+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4eNxa2jk;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792156729;
	b=chKuBcNmNcdIFeOghM+zZyb2y/4FbDQEvqWGq2sPmrFxTlDecAaN8iVsZaIYVsJZ1SmbCV
	0WPCM2xdsm3rfiWOUmWfs4+n+n1zT3qHwNZNQyDSPh6NpZ8jTI0FiSZG3JpVhMN+uU+Inz
	ra34V7t2XfK5UiiHUIXki/7MDKLqEDI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 92BE921C64;
	Fri, 16 Oct 2026 13:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792156727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mvOXCsd43Usn/ts9ZeDzJEb232W8k5UHTWzvCgsNFXk=;
	b=UnmfVm1tqwplPFdONtyFvTQ1AS5VP5cTD3qAq7xlctd+CFRVtHCsgbhkCMx9uSzccqMWsN
	3q4cKvYz4btr6MgHhN7ES/xZ1Q7FEzw60UOuYHFuWX1O2iBY1g7ZVXTwc0kgnR2/sx3dBB
	XBctDAKpjnkQLXYobhahIMgRTICUFYg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792156727;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mvOXCsd43Usn/ts9ZeDzJEb232W8k5UHTWzvCgsNFXk=;
	b=ev1VyZ7cv3eveqXi+jJAUUTkN9NMMWx5zYAdiOWV4c6zddfHkO0DgBV9/Tt8SL/eGsPU6Q
	IE+x/Fg39ceYm+Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792156726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mvOXCsd43Usn/ts9ZeDzJEb232W8k5UHTWzvCgsNFXk=;
	b=w5tKgH8+hN6tM6f+SHj3du8Q1iln5C1HSTlEC76yTb/PPnf6Ntbd67FFRlPvNuzWQGJifd
	vvonu/hW2hUYbfTfWV819LHbEAsv9Bs9RXv3k1NNmpBCE8IbWqFvVXbQAl3czQrJdrGNd/
	N+H87JUNigQsOnP/0AhRsOa1tQxLYTc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792156726;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mvOXCsd43Usn/ts9ZeDzJEb232W8k5UHTWzvCgsNFXk=;
	b=4eNxa2jkwB9wPUj6ps1INqFC8cCFqBjjGltQCxyfJ6ZCOSlq2/OSdWhNviZc8iz/lFt9na
	RQ4TsTKuYa1RHNCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 189E11339F;
	Fri, 16 Oct 2026 13:18:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mn7RNTQk0mqLAQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 16 Oct 2026 13:18:45 +0000
Date: Fri, 16 Oct 2026 14:18:43 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	david@kernel.org, ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, 
	kas@kernel.org, jack@suse.cz, djwong@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, hch@lst.de, 
	syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com, ngocthang2710.1999@gmail.com, willy@infradead.org, 
	rppt@kernel.org, ljs@kernel.org
Subject: Re: [PATCH v3 1/1] khugepaged: fix readahead lock inversion in
 collapse_file()
Message-ID: <atIiR1NWNssDvgt6@pedro-suse.tail5790ac.ts.net>
References: <20261016065920.4153-1-lance.yang@linux.dev>
 <27e5aadc-2d68-428f-a958-308e4a75c058@linux.alibaba.com>
 <atICp2NL8j2z7UFM@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atICp2NL8j2z7UFM@pedro-suse.tail5790ac.ts.net>
X-Rspamd-Queue-Id: 50A431C0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: gz3fpnfyfstpnaukkr7h491erugjtwtd
X-HE-Tag: 1792156729-287263
X-HE-Meta: U2FsdGVkX18Swe0hjBV5SRSGzp6GODc5Y1UOBhhk6hlhF7mJqsGg/Lrv28ezRlJg+GfNQwdibe/dXAVOGZ067/LcHeL/RgzJinr9Bx4T9phtV4Q5dj0afFVA0Hv+PJh8jWgS8nURQtfNzjfd02n6K0sttgiYxh4vOIrR9WJrZX0DGgMNDgxuMPvIKVIqbV0FKK0e/xU0eZVWhnE9R/38WUCoM32ixmMzuZ0vWetqrBPHcALr/3+qPsyK1ymTiUjjjla3T0wTfhsQ9oc8izWvVbTqWZWlOlroEdfLpBG6i/HPkIKAyflffInKJilxOUKyXl1r7mByvXyANQUXJ+1WmaKjKnu9B098JEN8YPQ9IaQYTgHQ63/k+ExeoX7V7L5+kY2AhN2iwvWWfZgIRewwiyUi7Bp0TO++NSseDlBxMXthwMLGMuHPpiUnG/9hvyBZyiZt6bf6a+PWUcbHL0tj4/5NPTR23kJNCj9wgyTrtk+ENWLjwrrTnwS34swNApGV9epAWp+p1owsaAw/+FBNA67Y4Bw8D2diF7Zow/nPppxkrBLQzcDGRBisfu0qdsGXiVCFOMtuAi/cr3OqK7Ao0ncfPaGNBlUrlVS01HIW/YcHXSY8NMg71ecwMzNPCbUJvlD5GD2SFnpZ1WAzj2qQe9KUzeYCbAuQ4Qnf8Ramud6RuKyCIKHGSZ8Fc7TFJHlk0J0G97J9gGrnuK8Fs/Srt/T2gPoWzeYqV3511Sr/sX5liduJ9eIT+RyOoADsBE76RafIoEkKOy44ClCAtWPwo8AX/uygk9cDaKh/0I13u5qpwDWIanpdIYjvvHfXkFUdPypJqrgzPNBT/XxF3fAkMjjTKKz4TjBndDZiUT5OWv1AlMP0wkicVhc/FPamiM/Ku3BcxlMvBivpHSUjlDIRbee9Rbqzz5MYqmz3th6tHEuO5sAW1IMM8V/wa4fJP1vQKHMWlp1Borm/X2lKq7r
 apvm3IAi
 r6vYBZWVHMqaRM5x9cHUucH0A06YWo7LwnWNDGR3BtLYx/NOxXCQnPCKbBkz8h15a6Qm+0FzhkGtF4JM1F5Ab5mGwkosvm0dbQjSFRM6v0RS4Gcyg5eMMekix4os59L2fjIzPWnfe8FRxyaQqszFnbUhK+P3K1Qi47oHSqbpW5D5wZE69NORiXSbDGoZFMdqj6WmX1RjQnmPx5RN8v7gOJqkTQVV3H3jQ4OqMWtSwC+7RllE6eRPUfeDCX17ZTg7x1vHFW0MFNangclQYFdJSKNR0sa8UniV288PTH9YdqC+M+4rZwOPN3iZFUO6ZLJ26eXYtr+SmiFgmbsaK6RVUw+YEfugsOOx+iXCVL1mZDdn9kSwfTdlJhQTxEbdphinMd8BmzyxaVlN+xOXxujlxvbkE9qMyuV4LqucRPzyqZptx/fI7yZ4N0a14LpYdIU6Z81x6UBGw87wa8iGWya4N67WnsJ+TazFjV+/aNPM3On+OR+5U64+wFxE1kKfXfy94jLvT4Tpi1Vj1Ku0J8jC5M5IMr3ri/2k00f7YY+C4f3i4q/We0m8Z/I4VH//vQ0FU5aY/eFrg2hCZSShnXJtfjFaVsRFCAy7jaKj1B86UeRHsWBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 12:00:24PM +0100, Pedro Falcato wrote:
> On Fri, Oct 16, 2026 at 05:57:48PM +0800, Baolin Wang wrote:
> > 
> > 
> > On 10/16/26 2:59 PM, Lance Yang wrote:
> > > collapse_file() can end up calling page_cache_sync_readahead() with
> > > source folios from earlier in the range still locked. If truncate already
> > > holds mapping->invalidate_lock exclusively and is waiting for one of
> > > those folios, readahead blocks on the same invalidate_lock and neither
> > > side can make progress.
> > > 
> > > Do readahead in a separate pass before we start holding source folios
> > > locked for collapse. Keep page_cache_sync_readahead() and its existing
> > > policy, and drop each folio's lock and reference after checking that it
> > > is uptodate. If truncate or reclaim removes a folio between the two
> > > passes, roll back instead of doing readahead again with source folios
> > > locked.
> > > 
> > > Shmem handles swapin and fallocated folios through shmem_get_folio()
> > > without taking mapping->invalidate_lock, so it isn't affected by this
> > > lock inversion.
> > > 
> > > Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
> > > Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
> > > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > > ---
> > 
> > Thanks for the fix.
> > 
> > > Thanks to Nguyen Ngoc Thang for v2. David asked for volunteers, so I'm
> > > happy to take this over.
> > > 
> > > Some older stable trees lack the folio infrastructure used here, and the
> > > code will differ for each stable tree, so each backport will need quite a
> > > bit of rework and its own review. I'm not sure whether to Cc stable here.
> > > Once we agree on the fix, I'll send a separate backport for each maintained
> > > stable tree except 5.10, which isn't affected.
> > > 
> > > v2 -> v3:
> > >   - Replace the scan-wide invalidate_lock and page_cache_ra_unbounded() with
> > >     a preparation pass using page_cache_sync_readahead().
> > >   - Roll back on a new page cache miss during collapse.
> > >   - https://lore.kernel.org/all/20260913163644.122133-1-ngocthang2710.1999@gmail.com/
> > > 
> > >   mm/khugepaged.c | 42 +++++++++++++++++++++++++++++++-----------
> > >   1 file changed, 31 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index ef5cd6fda34f..b3f67617caf0 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -2262,6 +2262,34 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> > >   	new_folio->index = start;
> > >   	new_folio->mapping = mapping;
> > > +	if (!is_shmem) {
> > > +		/*
> > > +		 * Populate the range before accumulating locked source folios:
> > > +		 * readahead may block on invalidate_lock.
> > > +		 */
> > > +		for (index = start; index < end;) {
> > 
> > why drop xas_unlock_irq()?
> > 
> > > +			folio = filemap_lock_folio(mapping, index);
> > > +			if (IS_ERR(folio)) {
> > > +				page_cache_sync_readahead(mapping, &file->f_ra,
> > > +							  file, index, end - index);
> > > +				folio = filemap_lock_folio(mapping, index);
> > > +				if (IS_ERR(folio)) {
> > > +					result = SCAN_FAIL;
> > > +					goto rollback;
> > > +				}
> > > +			}
> > > +			if (!folio_test_uptodate(folio))
> > > +				result = SCAN_FAIL;
> > 
> > Do we need to check PG_uptodate after locking the folio? If we successfully
> > lock the folio, doesn't that mean the read I/O has completed? The following
> 
> Yes, you do; a read can "complete" without the IO having completed successfully,
> and in those cases PG_uptodate is not set, but the folio is unlocked.
> 
> Either way, why are we checking for uptodate here? We only care for starting readahead.
> Anyway, I would possibly recommend we do this as post-processing, not pre-processing.
> The current loop is a little overhead-happy.

To clarify: I would do this kind of RA as an error path if isolation failed.
Namely, at the end of rollback, after unlocking folios. It doesn't make sense
to me to do this kind of checking upfront. I don't think it's particularly
realistic that, starting RA upfront, you'd see uptodate completed folio reads
when doing the actual isolation.

-- 
Pedro

