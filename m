Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA974CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5525E8E0024; Tue,  9 Sep 2025 10:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502128E0003; Tue,  9 Sep 2025 10:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1278E0024; Tue,  9 Sep 2025 10:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C24E8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:48:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC1361DED7B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:47:59 +0000 (UTC)
X-FDA: 83869991478.20.9430605
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id A787F40013
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:47:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NsAdqhMJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FkTT70q4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NsAdqhMJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FkTT70q4;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMjuisp9t8XFgyyrcRhHqDOoH4i/8GEPNGid6fl7m38=;
	b=R8v/jKYP1kAGK7e4XISwLttyWj3ElzODFwLaBIWbwIA1ZaEvQPexnHBoD2iCx2UkFiPrIE
	3VJvhnnLDppagNYUKa7iAwPgGCcSVlHaGIx7Fuu2M0LlYa4IqlZ3oNkaQVQ16fiC+W6O0l
	dNXbA/YzdeRbyosMEh78JGnewmutjYc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NsAdqhMJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FkTT70q4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NsAdqhMJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FkTT70q4;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429278; a=rsa-sha256;
	cv=none;
	b=Vu5ER+H+RwYBWKnXVLc+6ViJIUoGtDNPYSVazYxMXXoWSLXhx0aquWuJAnA/2iBWVUblYO
	dqP4S0AjJLMGYP7xIfprr/RF6fpLUu9gZU7n0CBRTyNYaFk43BafSYINIFqJYCurc8MN2F
	JUe7fFMAUORGsmBhbsjIANIT6ozyDEo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2548A1FF95;
	Tue,  9 Sep 2025 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757429276; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yMjuisp9t8XFgyyrcRhHqDOoH4i/8GEPNGid6fl7m38=;
	b=NsAdqhMJgY6c2vxy3ehQ+20TZisYYRx4aqpgzKppHNExNtYyEsj2w9qeo6xOx7HJKMNhz2
	Tzr7yGacyhHjttRdjHruJeqs2sx0JkBDCvUGEEYvSorDYpDpVFskhAG6CBWIj0sPu7DN6y
	WxJzY17FYkLGZqXJICJl7fpk41yUTQ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757429276;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yMjuisp9t8XFgyyrcRhHqDOoH4i/8GEPNGid6fl7m38=;
	b=FkTT70q4tlbkJb2uMcd9/3OtBm7qIelJM3FeQG9er9j1YzCRHJOX/Y3bYmgY/+hcLN6+yd
	X/8eCTRADvL/SRBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757429276; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yMjuisp9t8XFgyyrcRhHqDOoH4i/8GEPNGid6fl7m38=;
	b=NsAdqhMJgY6c2vxy3ehQ+20TZisYYRx4aqpgzKppHNExNtYyEsj2w9qeo6xOx7HJKMNhz2
	Tzr7yGacyhHjttRdjHruJeqs2sx0JkBDCvUGEEYvSorDYpDpVFskhAG6CBWIj0sPu7DN6y
	WxJzY17FYkLGZqXJICJl7fpk41yUTQ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757429276;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yMjuisp9t8XFgyyrcRhHqDOoH4i/8GEPNGid6fl7m38=;
	b=FkTT70q4tlbkJb2uMcd9/3OtBm7qIelJM3FeQG9er9j1YzCRHJOX/Y3bYmgY/+hcLN6+yd
	X/8eCTRADvL/SRBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1AFA71388C;
	Tue,  9 Sep 2025 14:47:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eDyFBhw+wGjdeAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Sep 2025 14:47:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D6303A0A2D; Tue,  9 Sep 2025 16:47:55 +0200 (CEST)
Date: Tue, 9 Sep 2025 16:47:55 +0200
From: Jan Kara <jack@suse.cz>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] readahead: Add trace points
Message-ID: <2qebht2w4jvxm23kcdzyp645mdxf4xbivrant5inao5742en74@lrepdbs24jow>
References: <20250908145533.31528-2-jack@suse.cz>
 <iruyokxvyziqzq3qrcorpx6mq2pshs6beyvgsokqlcz7loane2@y4bdrxzzitwa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <iruyokxvyziqzq3qrcorpx6mq2pshs6beyvgsokqlcz7loane2@y4bdrxzzitwa>
X-Stat-Signature: 1o5zxozudekqnd8aoi4ncdb7z1ki11w9
X-Rspam-User: 
X-Rspamd-Queue-Id: A787F40013
X-Rspamd-Server: rspam04
X-HE-Tag: 1757429277-752944
X-HE-Meta: U2FsdGVkX1+RhYhG7XhpFk+PzlU5GfIO1lQpQYUwi+BrhmB+SlXLIomsIX6py0dWM33NIYSAY8HlBjO9crBv+Q7pACev5QjvacDwh8+ccZBRznQdsNDPrj1vG22tf633/Mo4QQYT3dUn677lMQ+LdfrV7YNfo2vXOezbvoIM8E1A6b0Kl9Iw94LuXOJ8SvONYaa6vgLlORjahQe348E6CBdX8zzjnAMsf3SU5L717jiEV5SBatoLfYlp8DKyd+bdYJbOlEN0qA2d1La5mjEJhUrH9Mg8aTDFVsA64h4uBLfEEiT+IrcaY80n8RkICJA1C/0LKRYx5KLZydhFSZ69W6Krkt7Z7ze0NLO8LglwHgLttUOzHZnRpJNu4bFFLGWFEddZoA//xSqdWSUuGHJL54+DsRHY5Ko/bcNl4brlZquRcgqdFdXLcw7557tBa88kLLCK21eJia7nXiz0xW0j7NkitQyxKlDWuENv4zt9HHTzn0Kygu2BMJ5qU+zylpMbnHPhneopWM+SxyC9oIOrVjn3r2uOX8Giz/YY1c0SgItcMR1Z8IKCZrjn4APNR5YzFIyJo8JzrEw8/JkAwnPx5UMRoST01yeM+xCFh4E0IT5uuDliyP0uHzdOk8yJ6cZyXAKZ34vdDPneIaEmKHgp4uHo2XyxNFtF0AHgDMzteFrjFIlNV4ppD6+iVLAWKCSFFgh2/2KX3zl0/24Kv0ei+1EUTnUdQ9GOQpo6cc2XPXzK6RY27DNzi0m+sJh0asHDi+ngcnOdhlrcT4ZTGcu/9RFCs+bP4NS0mnzNTte0CjmfMnP6VlONas94cBvctxedXVERiquiVnmlhMpCyjclXXwbRiDtm33MhYvQI1vcNI0pp5MUVOupBnsy/Lm2RqzqTZ7FhsTlfwEANbkAV7GCHDbY69HpXienQ8m72NU0ume/jRXY7YMJuaCLBtAMwRxk3gX+icEE/A9tbefCdX6
 F+hVgxLS
 RCBjLovFh4vITNQH/yHpm3gg38ndGoXEqQs/n6uFSuqLOoibavnN5gLK+ZZHil4CDT0jCotWP4Y+f/uD+awnHOdBnTJirRuwFDrcBlT2+Mfu8nEMh99e3MzBGutPhzyJTyaEy/dEK5o6uQ/Lg1w2kRa9Twrv+sUdBaE4E5vvKRrBqr2I1FkFQJ625fdQOK6QEJ98bKt1j6R81tFK5/3kOqdk8CKbIn4ZowwG8jxWYXavfR7/bg0ddzx3h27mocqjniBgVonij1W+KutKD7TD96Vnl+ra3PHcYuJViyTp9O2sd53deuObSQe3sG7cBHr9GnYvICqWX3vZVoZmcME/Ps403qA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 09-09-25 14:41:33, Pankaj Raghav (Samsung) wrote:
> On Mon, Sep 08, 2025 at 04:55:34PM +0200, Jan Kara wrote:
> >  
> >  /*
> > @@ -314,6 +317,7 @@ static void do_page_cache_ra(struct readahead_control *ractl,
> >  	loff_t isize = i_size_read(inode);
> >  	pgoff_t end_index;	/* The last page we want to read */
> >  
> > +	trace_do_page_cache_ra(inode, index, nr_to_read, lookahead_size);
> 
> Any reason why put a probe here instead of page_cache_ra_unbounded as
> that is where the actual readahead happens?

Hum, no. Originally I had it in force_page_cache_ra() but then I've decided
do_page_cache_ra() is better because it captures also other places issuing
non-standard readahead. But you're right that placing the tracepoint in
page_cache_ra_unbounded() will achieve that as well and will be a more
standard place. I'll respin the patch. Thanks for suggestion.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

