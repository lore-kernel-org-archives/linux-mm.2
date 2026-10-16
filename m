Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E76CACCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 11:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85786B008C; Fri, 16 Oct 2026 07:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38076B0092; Fri, 16 Oct 2026 07:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE086B0095; Fri, 16 Oct 2026 07:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 911EF6B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:00:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E1B012038E
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:00:28 +0000 (UTC)
X-FDA: 85328195736.15.B7EF6AC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id EF66080010
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:00:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HlfgIFpV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pCUbozxk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HlfgIFpV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pCUbozxk;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792148426;
	b=vTSSaa5bkVoVTAE4bJl3W5/mf+5Gl0S4FcQnZX1XWbYBdR+OBZkQ2ElOij3EAjsW7Z7C3J
	r72slbqLu1BOLARDLBRhoN9B4Z/yF9jaKbBy4wPzyapPNCCjzsifqLe7OH37owv1Vw+0+/
	fB97GjYO1URvDnwGh1KZUp5hpOOGA48=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HlfgIFpV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pCUbozxk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HlfgIFpV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pCUbozxk;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792148426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6PCfMbuGmCfwpBRIO+Gy0QoX6CF8bLNNX4OEjsspNk=;
	b=S0RuGm88jmfef1U6eu2//tOd0Y+op1D1noXwnU+DO1dsDLjbTcD7NODqwviORjq1go/qQg
	rXFcTokcU9JBmmehlwkzrdTR3ONaeS7gtQdjFthYqs6Au93+8Rh7XHgdYA6PMLSM4m8y7h
	wv7bYAu5AtnZDPPvxgJL85fbeQm4Aew=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 83B371F6E6;
	Fri, 16 Oct 2026 11:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792148424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U6PCfMbuGmCfwpBRIO+Gy0QoX6CF8bLNNX4OEjsspNk=;
	b=HlfgIFpVZerIa3PRw5aH9wctXjLl+pHxZ1YxDQZgHTRdh1tT5StwwFycExRTzAx09uLRIi
	r+mxgt1rAEhpZEeODve3P5tZ0WdwgTveeunGKQtptuMWQtYToMbgO5kYpbgYP3yYKJyYkE
	fw8r3wk3AI7jDA9IVPxXimKhYFZUXdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792148424;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U6PCfMbuGmCfwpBRIO+Gy0QoX6CF8bLNNX4OEjsspNk=;
	b=pCUbozxkHy0zzFI/y9WTaw0Xlkr1l0Ch1x2JhC7D6AKJ+R0TqivttfhO7x4yrK4AZM/32N
	9o91Q9ovvbBTWBDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792148424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U6PCfMbuGmCfwpBRIO+Gy0QoX6CF8bLNNX4OEjsspNk=;
	b=HlfgIFpVZerIa3PRw5aH9wctXjLl+pHxZ1YxDQZgHTRdh1tT5StwwFycExRTzAx09uLRIi
	r+mxgt1rAEhpZEeODve3P5tZ0WdwgTveeunGKQtptuMWQtYToMbgO5kYpbgYP3yYKJyYkE
	fw8r3wk3AI7jDA9IVPxXimKhYFZUXdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792148424;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U6PCfMbuGmCfwpBRIO+Gy0QoX6CF8bLNNX4OEjsspNk=;
	b=pCUbozxkHy0zzFI/y9WTaw0Xlkr1l0Ch1x2JhC7D6AKJ+R0TqivttfhO7x4yrK4AZM/32N
	9o91Q9ovvbBTWBDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 048A81339F;
	Fri, 16 Oct 2026 11:00:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S0+JMMYD0mrLcwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 16 Oct 2026 11:00:22 +0000
Date: Fri, 16 Oct 2026 12:00:21 +0100
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
Message-ID: <atICp2NL8j2z7UFM@pedro-suse.tail5790ac.ts.net>
References: <20261016065920.4153-1-lance.yang@linux.dev>
 <27e5aadc-2d68-428f-a958-308e4a75c058@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27e5aadc-2d68-428f-a958-308e4a75c058@linux.alibaba.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF66080010
X-Rspam-User: 
X-Stat-Signature: qjytfzueutu41ajws9hdyebm71btmiwf
X-HE-Tag: 1792148425-803030
X-HE-Meta: U2FsdGVkX1/2fji1F/9Lkvsc6B8dToHOwW+ie+OacQRlm9uHUmyjzpZq/wvUoOINEiX093XoOXMVHizNJhxXPRYwczRUzuVJuP5ysi06KP+KCEyU20ydhAmxPwkJv1CtpIAwr8M56azcjQYeUr8hscvRn8ENfU373xrR1wgCgYT48lHz2Xj/fISt8sOkOYzHVtTYNxo0TuW0zABJCQgj0qAwEf26ZkRh/KkJMCMJZSyk7d3eDaIDezizth4gn2sTJJBkHyGmJoJi4DnEpgInv9iOL5yJC8x2Hu7FtwDK8ag7o2V52EC4geDzQrRgeiS+MPI9V7vNkJ4vgh6hUbNJShskECDT6LiH/IKVABk3j7Vk+IBAWxYA9pSwuZBljH8fkOiZ2Lc28cI8cPWtlsrLykO1ly9h0AgoBTJMpdXjxXUqGEXQAEoM9zMiEb9NsGEhfOBL4HwGdMzP4pn9bWN8RZ+93HNdxvpFg07X9Wle2B1TeRtjb90j+V+81oZHC1dFL5LCxDJ0opfT5OlwsUWSb/IbADNweDeuiWYTxhlQvZoqEOBGzqrkFZUbGTNzKoAPdtlN/QUydcJ298XNPkw3e3mtTa1sHTskBIopK3TJjWxxkNttUf6uQumFmyYphJvuNdrgsOaXs8u86hAltwdYD/U0yFn/0wpodDk2zBurgMDpGP509EgF10wJDjswdDLNlMepk4JAitkSSXz57s95k1O7fbgtQ5ErQJ+B6a9oT0830fAf/fqt/9aFpQvHcc1W10LHrO48/OgjbN7CH6Tmqy+hiILHy/8Xbczc+QQuNsWt3lQM2GoYvobYiKOWwUpsqmsUcAdjkpj9EO2TPgnTfaEJxASZT/bTOWKjjHd4+RBVlNsMq3fj5tT+WrxMtZx+7WlknMSU6zFgK7W7j5foWTBwVhx2hslMS8K5QUYsabMEGPT0D54F42lL7ml3ST/R2CZXxiZbybDOiyMjRMv
 Z5M9FUSQ
 lfQTz/vdQMFqN8s8znjkJAb/kptplt9z+cLtNRdwu2wyj49Ykvih8+oGp0vPZUWoLx4DoL2I7Z5ruhixIfQ4ISFSNhhyVpXt5zMLK1+JHlSNOjs5Liop/zL6NpQA9ivDCiaP9tGJ1RDQXWmsvtpBKW6o8EuZvYpuMCQrpsLwgw+ZP4tTP7ugfp4AlTuWKEITEM522qNMB/jsMOlW4Rorxv9IonBJB2O4UanngkgoLKpgyJUG++dhBxhUOI4zvPfA9acuH5PacacrCmmJmS50g5CA+eeaLEln27xONwvBurhfY1l7s1E6aalNC6BjtfnTrXv8cEWgWOCgtLmF2xF/d+TaSTETn+42X7ii3PyPOKCwBWanokrdyTecDjiU+HhQmxF97iWfV4A8hfyW9TbKSgA5xyj7dx8f3jij/eyB7w2AScKfteUyazoOMl97Et6zbizoGncNZYfB0cSwbP0oa33lgbcBgNt7wdli+Ff3ODXtD1GJ8aM6ceKofgDevstOxuxwScg2igWy+8J9MAmlEIUJk2LAjeZTQks+COHN2etGY8z5hHTuJT8FFYrCdV+8ek6CqX5w65OhwHI2H9GL54FYdPeQPx2xZEc3bG+Ryq6bKGmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 05:57:48PM +0800, Baolin Wang wrote:
> 
> 
> On 10/16/26 2:59 PM, Lance Yang wrote:
> > collapse_file() can end up calling page_cache_sync_readahead() with
> > source folios from earlier in the range still locked. If truncate already
> > holds mapping->invalidate_lock exclusively and is waiting for one of
> > those folios, readahead blocks on the same invalidate_lock and neither
> > side can make progress.
> > 
> > Do readahead in a separate pass before we start holding source folios
> > locked for collapse. Keep page_cache_sync_readahead() and its existing
> > policy, and drop each folio's lock and reference after checking that it
> > is uptodate. If truncate or reclaim removes a folio between the two
> > passes, roll back instead of doing readahead again with source folios
> > locked.
> > 
> > Shmem handles swapin and fallocated folios through shmem_get_folio()
> > without taking mapping->invalidate_lock, so it isn't affected by this
> > lock inversion.
> > 
> > Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
> > Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > ---
> 
> Thanks for the fix.
> 
> > Thanks to Nguyen Ngoc Thang for v2. David asked for volunteers, so I'm
> > happy to take this over.
> > 
> > Some older stable trees lack the folio infrastructure used here, and the
> > code will differ for each stable tree, so each backport will need quite a
> > bit of rework and its own review. I'm not sure whether to Cc stable here.
> > Once we agree on the fix, I'll send a separate backport for each maintained
> > stable tree except 5.10, which isn't affected.
> > 
> > v2 -> v3:
> >   - Replace the scan-wide invalidate_lock and page_cache_ra_unbounded() with
> >     a preparation pass using page_cache_sync_readahead().
> >   - Roll back on a new page cache miss during collapse.
> >   - https://lore.kernel.org/all/20260913163644.122133-1-ngocthang2710.1999@gmail.com/
> > 
> >   mm/khugepaged.c | 42 +++++++++++++++++++++++++++++++-----------
> >   1 file changed, 31 insertions(+), 11 deletions(-)
> > 
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index ef5cd6fda34f..b3f67617caf0 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2262,6 +2262,34 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >   	new_folio->index = start;
> >   	new_folio->mapping = mapping;
> > +	if (!is_shmem) {
> > +		/*
> > +		 * Populate the range before accumulating locked source folios:
> > +		 * readahead may block on invalidate_lock.
> > +		 */
> > +		for (index = start; index < end;) {
> 
> why drop xas_unlock_irq()?
> 
> > +			folio = filemap_lock_folio(mapping, index);
> > +			if (IS_ERR(folio)) {
> > +				page_cache_sync_readahead(mapping, &file->f_ra,
> > +							  file, index, end - index);
> > +				folio = filemap_lock_folio(mapping, index);
> > +				if (IS_ERR(folio)) {
> > +					result = SCAN_FAIL;
> > +					goto rollback;
> > +				}
> > +			}
> > +			if (!folio_test_uptodate(folio))
> > +				result = SCAN_FAIL;
> 
> Do we need to check PG_uptodate after locking the folio? If we successfully
> lock the folio, doesn't that mean the read I/O has completed? The following

Yes, you do; a read can "complete" without the IO having completed successfully,
and in those cases PG_uptodate is not set, but the folio is unlocked.

Either way, why are we checking for uptodate here? We only care for starting readahead.
Anyway, I would possibly recommend we do this as post-processing, not pre-processing.
The current loop is a little overhead-happy.

-- 
Pedro

