Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D0CCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09A1A6B00A8; Mon, 11 May 2026 12:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B106B00AC; Mon, 11 May 2026 12:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3226B00AD; Mon, 11 May 2026 12:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D959B6B00A8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:26:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B5CD1201AA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:26:14 +0000 (UTC)
X-FDA: 84755666268.30.D117A26
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 30490140006
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:26:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cG1enXI1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7HBCzjFk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cG1enXI1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7HBCzjFk;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4cEJJojjKJfVGKGY9ofdQshTBxx0aX2LtNULn18dP8=;
	b=mZCH0oCM+cYVMrKodtMZQ+OPxTJH4hvPc3U8Z0TKT8Bd20fnDfeROdwa+rB/0s8BTHxyI9
	Iqu19FlMS71k+IJr/1wgxALM2sQQX9NL5jbwjhGuZV0rRCWLcDIDKFNSV/Zt78+7jdV8al
	H9Hz604Cki9kumzYuFPCjs6o8JuNN3E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516772; a=rsa-sha256;
	cv=none;
	b=ialbV/KQLpkZWbZX9a6l1wrdQTT6eA8Kgfq2CdZLFDK5trzMIJGfIUzwkAqD3FIlnk52ch
	danFJihimsLPHNtR6Y/iqra1EUrdU3puzfFZnj/UmlbRnLCQRPCZdsvCsIyJXHJoAIxGOH
	5aw1GstNayJOcBe0RjCLjlq1n7KMWr0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cG1enXI1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7HBCzjFk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cG1enXI1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7HBCzjFk;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7E9076BA83;
	Mon, 11 May 2026 16:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778516770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U4cEJJojjKJfVGKGY9ofdQshTBxx0aX2LtNULn18dP8=;
	b=cG1enXI1P9zXeCfgkXjUx4u5hpncq+Y613nKTv0IRnAtEHFZ/V8xcL9EtVAabjgj6Zo19A
	wq1KmMskBV+N/uT//dOkrglyJEqpyBFFRlilBlZDnvTgd5iixrO63Ao4kF0eGAe4IwtOIP
	FvTXO4dRn58RgMAIZLAt9ACD6FCC25I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778516770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U4cEJJojjKJfVGKGY9ofdQshTBxx0aX2LtNULn18dP8=;
	b=7HBCzjFk19z3ATbwxp7QTHebnhnWYz+EGezfmSNN/SgEnC85vJjO7Tbe3sgA3El+odKGA6
	R4zShiR/kMf+b+Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778516770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U4cEJJojjKJfVGKGY9ofdQshTBxx0aX2LtNULn18dP8=;
	b=cG1enXI1P9zXeCfgkXjUx4u5hpncq+Y613nKTv0IRnAtEHFZ/V8xcL9EtVAabjgj6Zo19A
	wq1KmMskBV+N/uT//dOkrglyJEqpyBFFRlilBlZDnvTgd5iixrO63Ao4kF0eGAe4IwtOIP
	FvTXO4dRn58RgMAIZLAt9ACD6FCC25I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778516770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U4cEJJojjKJfVGKGY9ofdQshTBxx0aX2LtNULn18dP8=;
	b=7HBCzjFk19z3ATbwxp7QTHebnhnWYz+EGezfmSNN/SgEnC85vJjO7Tbe3sgA3El+odKGA6
	R4zShiR/kMf+b+Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 350FC593A3;
	Mon, 11 May 2026 16:26:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id u/XsDCIDAmrxWgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 16:26:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3739CA079E; Mon, 11 May 2026 18:26:04 +0200 (CEST)
Date: Mon, 11 May 2026 18:26:04 +0200
From: Jan Kara <jack@suse.cz>
To: Vishal Moola <vishal.moola@gmail.com>
Cc: Tal Zussman <tz2294@columbia.edu>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: fix page_cache_prev_miss() when no hole is
 found
Message-ID: <s6hnqm4bbi5j2ergudihydboj3uw7gsu7te4dfmjgv2qeosfbd@yvhp5oy3r3b6>
References: <20260510-prev_miss_fix-v1-1-755bb123145a@columbia.edu>
 <agHPIcZHHyzBjcGN@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agHPIcZHHyzBjcGN@fedora>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 30490140006
X-Stat-Signature: wdi6rq9y98zgmnwsajxqtpa7ur98fju3
X-Rspam-User: 
X-HE-Tag: 1778516771-476590
X-HE-Meta: U2FsdGVkX19QrZg/sABkP/FDAVER4PMrkOckRCt/oCHQbr5qjX9zLi0c0jYpHXlO54P/K9kE3NwUUUUCpN7NUU1Q+WL/VpbLeceihPupR+Oz8yrvggNFnly2Fau7QqukqcXp5VGnhtYzksDghquQyNFm/5h4sYCl8Q3M13ayY+pVe6/UIq/s9bVxcsyoRgbS/zEpQ5QvhYEuXiu3NUtRBC91b5X5NOG61oj9e5XJqjEZWRWCd8N/JGu18aRVzxM7YShDBCT8RhtB1OxFp+MlAjDV/lBT0Xmzlu0waVMq0TtCityNM2q4hgvBd2TE4gjgtNIovMW5BKEB5IgI7/8bb38B5JjOqiA/oVK72n2u7ZWzYQPyWwoXIA0Z7EGWmI92pw54TBViHhTQHUlFZ7c+iit6uI9wk5mozPA83E5UwozlhLXtAlJN8duJ13QdzatS3T8QKz3VpHPkUXjeAkVwzD59Z05mnODCwiufnSEJ/g1c/VZwRc3KT8NEAm7xZ29t+p8HPDaaiPSI4pJlaL7ijQWSzWasAK4VEDaVCA0+afuHX17UdyQaEYPLB6CjrLbXxiYge1HneyPF4a7jbwP9ErmY+zgQMGDgd4F8ERR5Ly6Bz7SLADJie5pV/X2MYzW/vZ5DiwOBzsS+JdUJhBPWvEJHZ6/cpPjYxDlTgszOgdtlWqwlmHZOC5ndguEKyhMfikDX01nyWfXdaqtRz/+aZ6FRz8UagNfEUhw9xSPkZjgQoVc4Jy3Kyze3ujU16z9s5TWjd6T1SuPCrX9kkIW2qC4Yx0xgQYHhPS1BmbPXgW1vZShqsiLjZ3Wxf++Z4Cf+UG+6pzTYMY1wOmMfFonpu5rxixSzq6EjhBvuGau1+S4uoSKJ5NrNGWE6aUIjSAz6K26ewCuyF41gMO1GUEfX+oB7hPfpulNzuyh/W7zSY6oWj+SwnsOyXSfsxapm/Ij0RZudRIUiWqrw2/0dHRK
 0WofNEZN
 R1LD6sd/Xbj9Zgs2K4LtE2ffIEPI2+YAtqXD9fZ+COfuiBb1lbedyti95ORoMr7K3UX237YONq1msBv9hOzgZg541VtQ0Mk8ZF1Rl3DlDXChM5RHurdAoEeOY7aZIiCApyupHCMQ2ViFThYDJdPIpKyKlP6vTXtBWJN78L2uy1NO3dlT5I/SGD6FhB9Fj+UDqv6CtbWxG9RtfursUF98GqQ/Rxr8/Q4VJDb6Vgt9eWG5qcQ/SuOg3G+J21bnyySqXGAEh8Slbw0Zdqrp0cvsQbxUkD/PHlaNoTmT0ItLNqhO7VAgkoM4dsog4JWs0QNbe1gNeYPPDnyoX/wekNVXPpxerRjsInKPYp7A2wyfb4/v1wnWaq5KS+XpF13MNvPj9he7T0qHVhOdjz1uBax0hZsHfk5ufS34aJ4E6cR9DkXHHW498Q5DQkF7AbnwpIUXK+/1VYcyuRX+PLzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 13:44:17, Vishal Moola wrote:
> On Sun, May 10, 2026 at 05:54:17PM -0400, Tal Zussman wrote:
> > page_cache_prev_miss() is documented to return a value outside the
> > searched range when no gap is found. However, the no-gap-found path
> > returns xas.xa_index, which after a successful loop is the first index
> > in the range. As such, that index is misreported as a gap.
> > 
> > The sole caller, page_cache_sync_ra(), uses the return value to estimate
> > the cached run preceding a sequential read. In some cases, the buggy
> > return value can undercount the contiguous range by one, shrinking the
> > readahead window or pushing borderline requests into the
> > small-random-read branch.
> > 
> > Mirror the fix in commit bbcaee20e03e ("readahead: fix return value of
> > page_cache_next_miss() when no hole is found"): preserve max_scan in a
> > separate variable across the loop and return `index - max_scan` from the
> > no-gap-found path.
> 
> IMO, this way of fixing it hurts the readability. I'd prefer something
> similar to the fix in the original commit. Or...
> 
> > -	while (max_scan--) {
> > +	while (nr--) {
> >  		void *entry = xas_prev(&xas);
> >  		if (!entry || xa_is_value(entry))
> > -			break;
> > +			return xas.xa_index;
> >  		if (xas.xa_index == ULONG_MAX)
> > -			break;
> > +			return ULONG_MAX;
> >  	}
> 
> If I understand this correctly, couldn't we just do something like:
> if (!max_scan)
> 	return xas.xa_index - 1;

I think the easiest to understand would be to do the above two explicit
returns instead of 'break' and change below to:

	/* Return start of the range - 1 when no hole is found */
	return xas.xa_index - 1;

> > -	return xas.xa_index;
> > +	return index - max_scan;
> >  }

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

