Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7936FCCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 08:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6268E0014; Mon,  6 Oct 2025 04:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D9E8E0002; Mon,  6 Oct 2025 04:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66CCB8E0014; Mon,  6 Oct 2025 04:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5254B8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 04:20:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D83D3C04D4
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:20:08 +0000 (UTC)
X-FDA: 83966991696.23.E9462B5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7E89C2000B
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:20:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J3WgEZ5B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bkrIDvaA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J3WgEZ5B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bkrIDvaA;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759738806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91nFhmvjOlSuh257mCaBP5+wVYdOBnUlRIsTLkrttYM=;
	b=NZQ5FlCYbx24dU2kdBgLbMjLLby1WAuoSm/ljX9LmpPotxOcdU5C+PAFjGFQDWt9/g6Oi6
	cKaW6ZG4Xp+Z2c7oe72N4QkraMys4pTgZWEnRFPEHKyXcZvHrSJ9J0s42Z4nZ8ANhJQg2x
	07m+1m3LQr0oHlbbyXOIC1H+6Adzh5Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J3WgEZ5B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bkrIDvaA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J3WgEZ5B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bkrIDvaA;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759738806; a=rsa-sha256;
	cv=none;
	b=ZqO9Qu4b/mDK1g1MyUhXE1Y8xjpvoKmtWeNAyZnORKcyx0OiLm/z68aUDo1WY+1A6ciGjQ
	zTxHMk4R/nH5Jw7e5FIRor5xVGjkCcD+H9eyftO4/5OjMc++QvgolnzXg5+Gf2nDyntEn+
	25ZWgvEBAquAkKIu4R/3GIE1QZ2bM5Q=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0D488336CB;
	Mon,  6 Oct 2025 08:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759738804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=91nFhmvjOlSuh257mCaBP5+wVYdOBnUlRIsTLkrttYM=;
	b=J3WgEZ5B78Wf6D0vRriyJcTdMF8A0lAUcn8+Hi2fa3ZRBE7CjyYzBCU8VnvRUEOvmp1vh0
	qWHeJEE1GFluDXwDXw7nMKT7KFNeFtBZ03CIaFldpoHV3ZUrES1smQ4h0R6nLryerc+TUi
	t/kg041ZOiPFtcel7x6LXRd0Fia7eAg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759738804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=91nFhmvjOlSuh257mCaBP5+wVYdOBnUlRIsTLkrttYM=;
	b=bkrIDvaAwa0PudhD/XVNV/19jACImrGiwZpucwSEt9t5i/Ic4SlNL2h6s9sdQLEuYlTEs6
	NhxgM1u1FksI6hDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759738804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=91nFhmvjOlSuh257mCaBP5+wVYdOBnUlRIsTLkrttYM=;
	b=J3WgEZ5B78Wf6D0vRriyJcTdMF8A0lAUcn8+Hi2fa3ZRBE7CjyYzBCU8VnvRUEOvmp1vh0
	qWHeJEE1GFluDXwDXw7nMKT7KFNeFtBZ03CIaFldpoHV3ZUrES1smQ4h0R6nLryerc+TUi
	t/kg041ZOiPFtcel7x6LXRd0Fia7eAg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759738804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=91nFhmvjOlSuh257mCaBP5+wVYdOBnUlRIsTLkrttYM=;
	b=bkrIDvaAwa0PudhD/XVNV/19jACImrGiwZpucwSEt9t5i/Ic4SlNL2h6s9sdQLEuYlTEs6
	NhxgM1u1FksI6hDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 026E913995;
	Mon,  6 Oct 2025 08:20:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PIuWALR742jUKQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 06 Oct 2025 08:20:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 94A39A0A48; Mon,  6 Oct 2025 10:20:03 +0200 (CEST)
Date: Mon, 6 Oct 2025 10:20:03 +0200
From: Jan Kara <jack@suse.cz>
To: Dev Jain <dev.jain@arm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: readahead: make thp readahead conditional to
 mmap_miss logic
Message-ID: <mxhut4yy3xqqv2gchlakiqu4bhjzbmu4bwl7xtdrwqqygcgwxk@cggnjvpola7g>
References: <20250930054815.132075-1-roman.gushchin@linux.dev>
 <766f5a8a-851f-4178-8931-5355472d5558@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <766f5a8a-851f-4178-8931-5355472d5558@arm.com>
X-Rspamd-Queue-Id: 7E89C2000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 1qint5jbz7bzkutk6mu48xw7dj7byw9t
X-HE-Tag: 1759738806-583246
X-HE-Meta: U2FsdGVkX19NT5MdNtNnr7SOG7QFxiBQMWmJ8f4KkrXkzyF7RHC0SQQKtVu/X+Y3itxQW2Zvv4lRz9GLlBiWNGsb35m8RPmrBof4tTw9OT/rspXl8SrCmxBZj4+DxixaisZ7MPodZ+PUcIAGLRVAyfrC22gFgBOzJomvorcyWw7Dwgfb+7piybwyhvKUIrwQL75rfH6YXdHLhKBxuP9VcYue1IOrFzRCEIPDZznH3WXgQhIGnvcVQrZyL/jaJIk5f1q1Hf1hfJ8n5EpNOtw1d8aOoqKUyTOH1B45XEXCIxYio9OhtHiw8EuPKA56K7weLBsHDsK/jINgr84BpoZv5z5hAJ+VSI/0PmRLSzxKQryffxaqqo7CP6PwqVTKUh+sLKP813b2t8XHKYcwlwmTqVG5WRMuPUBQNMSfR+nC+BLGsa3vhBfi8RLYr5BENo5OwE6BBvKIQbJLCsoYEib/2/5ZpBx/yuXEPasePXtZbIdFSRbDgjaZIQ1bCXvS8YEH0qWHIlaUYNnRcptw4eU+7A9xuZp4zGMQQpd+ADSjaCWs+pGc84AANJ69u2kpp2LVEnXbY3nEIZ/IsQKYi/eCWM6r62Ey8V4HkbC45D+DH5ZlLjMc6A24daZuYilyAybO/l10NKAGTiRDEaJRoQj9tS1pcfWOk3Vvj127XmKQN3MP8e8eZyh8GUENvHkM0VnIwJf3JJPQxsKoWA23wlkqY4N2ePnnSmwOvyiXaJnRiIEe9PJ6bkPsy4ATjBySnSf5MdPlk+cbdA+RA82pLWuYvetbJL53cvSShApmKZfLM1VIvfJD0cCitSZ2RpwO3RvCtsAejKnmrGxkcEcNoS1Prq8WoCwyRl0gCVNTKgDmSchRgboDniHJJVaKwmctQG7cAZDsTX961Jgs8J7m136uiyKjACvDr+exV9zpzWIVwl2wof47UIPjdveL6qzXkYYZqhKJuBXB8Tq2zwGAzoi
 G5i7lR6Q
 7SBfqzMqozxc9xRC27tqFwgt38+UWKKg2h2rNh3ld7bTXqOkuO7DdoylblygD8KytaLzUd26GJNIOPNr+G/x8WmM9z/89ebCeA4RI2Cso3Ki3x6xBmAYfLr0LVb/n6VP452IIn/eYQv1KY21pqROtcmE6DeFu0UAUrTaRlzKHD9yvwWT51EdiXf1nliUUwR+du06FTXS9l8x6N089vaFQHQwCJH9QAvgADu285/vwHnbqyHlcF1wW7l5p5UYIF0H2zE4jGEbSJAIuO+MZceAm7BCr8LVs8ETpZAcMNTTFKmY/18CxhvxkkILXUz8k1X7dr5xmOvdSUqxntFC2mqP9Bg6wdCVyB8EC8vaSG/j9TDY2xTZv4ILWqmJv8bkbxAEWsnkuowm6poOkZ83drsiNXUhgGm7VzH3A3/l+oKlxJ8oZI153lcIrD8t/gNzegJZz/Jo4p7OBqWgWGMAdwJTLDnPRFnaDywWIxiy6Ir1BHFs45k0YV+oFxVxC2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 04-10-25 18:38:25, Dev Jain wrote:
> 
> On 30/09/25 11:18 am, Roman Gushchin wrote:
> > Commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
> > introduced a special handling for VM_HUGEPAGE mappings: even if the
> > readahead is disabled, 1 or 2 HPAGE_PMD_ORDER pages are
> > allocated.
> > 
> > This change causes a significant regression for containers with a
> > tight memory.max limit, if VM_HUGEPAGE is widely used. Prior to this
> > commit, mmap_miss logic would eventually lead to the readahead
> > disablement, effectively reducing the memory pressure in the
> > cgroup. With this change the kernel is trying to allocate 1-2 huge
> > pages for each fault, no matter if these pages are used or not
> > before being evicted, increasing the memory pressure multi-fold.
> > 
> > To fix the regression, let's make the new VM_HUGEPAGE conditional
> > to the mmap_miss check, but keep independent from the ra->ra_pages.
> > This way the main intention of commit 4687fdbb805a ("mm/filemap:
> > Support VM_HUGEPAGE for file mappings") stays intact, but the
> > regression is resolved.
> > 
> > The logic behind this changes is simple: even if a user explicitly
> > requests using huge pages to back the file mapping (using VM_HUGEPAGE
> > flag), under a very strong memory pressure it's better to fall back
> > to ordinary pages.
> > 
> > Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> > Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: linux-mm@kvack.org
> > ---
> >   mm/filemap.c | 40 +++++++++++++++++++++-------------------
> >   1 file changed, 21 insertions(+), 19 deletions(-)
> > 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index a52dd38d2b4a..b67d7981fafb 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -3235,34 +3235,20 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
> >   	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
> >   	struct file *fpin = NULL;
> >   	vm_flags_t vm_flags = vmf->vma->vm_flags;
> > +	bool force_thp_readahead = false;
> >   	unsigned short mmap_miss;
> > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >   	/* Use the readahead code, even if readahead is disabled */
> > -	if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
> > -		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
> > -		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
> > -		ra->size = HPAGE_PMD_NR;
> > -		/*
> > -		 * Fetch two PMD folios, so we get the chance to actually
> > -		 * readahead, unless we've been told not to.
> > -		 */
> > -		if (!(vm_flags & VM_RAND_READ))
> > -			ra->size *= 2;
> > -		ra->async_size = HPAGE_PMD_NR;
> > -		ra->order = HPAGE_PMD_ORDER;
> > -		page_cache_ra_order(&ractl, ra);
> > -		return fpin;
> > -	}
> > -#endif
> > -
> > +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> > +	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
> > +		force_thp_readahead = true;
> >   	/*
> >   	 * If we don't want any read-ahead, don't bother. VM_EXEC case below is
> >   	 * already intended for random access.
> >   	 */
> >   	if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
> >   		return fpin;
> > -	if (!ra->ra_pages)
> > +	if (!ra->ra_pages && !force_thp_readahead)
> >   		return fpin;
> >   	if (vm_flags & VM_SEQ_READ) {
> > @@ -3283,6 +3269,22 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
> >   	if (mmap_miss > MMAP_LOTSAMISS)
> >   		return fpin;
> 
> You have moved the PMD-THP logic below the VM_SEQ_READ check, is that intentional?
> So VMAs on which sequential read is expected will now use the common readahead algorithm,
> instead of always benefitting from reduced TLB pressure through PMD mapping, if my understanding
> is correct?

Hum, that's a good point. We should preserve the logic for VM_SEQ_READ
vmas. I've missed this during my review. Thanks for catching this.

								Honza

> 
> > +	if (force_thp_readahead) {
> > +		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
> > +		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
> > +		ra->size = HPAGE_PMD_NR;
> > +		/*
> > +		 * Fetch two PMD folios, so we get the chance to actually
> > +		 * readahead, unless we've been told not to.
> > +		 */
> > +		if (!(vm_flags & VM_RAND_READ))
> > +			ra->size *= 2;
> > +		ra->async_size = HPAGE_PMD_NR;
> > +		ra->order = HPAGE_PMD_ORDER;
> > +		page_cache_ra_order(&ractl, ra);
> > +		return fpin;
> > +	}
> > +
> >   	if (vm_flags & VM_EXEC) {
> >   		/*
> >   		 * Allow arch to request a preferred minimum folio order for
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

