Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D59C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 12:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826976B00A6; Wed,  1 Jul 2026 08:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7BC6B00A8; Wed,  1 Jul 2026 08:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A03E6B00A9; Wed,  1 Jul 2026 08:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F05C6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:48:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD53614014D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:48:27 +0000 (UTC)
X-FDA: 84940186254.05.1B8FB22
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id A571680003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:48:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FBzO9H7c;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=T0ytnlOz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FBzO9H7c;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=T0ytnlOz;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782910105;
	b=L0xGUljKZGK/jw0js96AGxqVVcuk9NOs0O3EwwT81WwKb8Jo6mcGXUhZ76wFw8jbWnrsX6
	QxCtlU5HCkQRN7DEcrq65yFuI0kqS6qK3fmFjwl7smgvteqR7VNXdughs2yZWlYV4qE8eZ
	l762YuxToMYkwmQXjPZ1oPr/qETOYV0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782910105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvYRWyc3z8t27v3w0F62f0dG6Aqi1GbB0bRsD3zgvpc=;
	b=gOrrKXVJ7+w35HBGoOaRXdF6JwmN9PteBWYxS4og/qv0uNPxm5Ro6e8Reg4zXnC6samyjM
	Vo2plu2Vf2EJI8U/E1WdAwiT24bOLVZxB/2G8cFeAYxghqfJv9EJlydbwxk7EeUsslBa9Y
	P6mWWAjxO8zR1Jos2lT+LKL4Ek4HUkY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FBzO9H7c;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=T0ytnlOz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FBzO9H7c;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=T0ytnlOz;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5029A759CB;
	Wed,  1 Jul 2026 12:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782910104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fvYRWyc3z8t27v3w0F62f0dG6Aqi1GbB0bRsD3zgvpc=;
	b=FBzO9H7c7Z/s2E2BIupzX3lBkpmiT/Qc5MtIPhWGV0CX0FcpAyD8tYathFJkp4Kw8ZwXQf
	oS3OyXEAxtydlKRWdNFAkERhiuCzcXsvpDx9JNnIYe8+hYg66ZpMAWij1ho+sce+S6oDQb
	11rcOjdrEh8uf9KstGO+o4x3aMbQYF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782910104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fvYRWyc3z8t27v3w0F62f0dG6Aqi1GbB0bRsD3zgvpc=;
	b=T0ytnlOzZ2O8awA/SAMxHkS+lt3EDFCOWRfjgiJJqBwYE+fMJ3jD5EMYu1+hI8gQ6veAJj
	Sjqk7rycwKyMmgDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782910104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fvYRWyc3z8t27v3w0F62f0dG6Aqi1GbB0bRsD3zgvpc=;
	b=FBzO9H7c7Z/s2E2BIupzX3lBkpmiT/Qc5MtIPhWGV0CX0FcpAyD8tYathFJkp4Kw8ZwXQf
	oS3OyXEAxtydlKRWdNFAkERhiuCzcXsvpDx9JNnIYe8+hYg66ZpMAWij1ho+sce+S6oDQb
	11rcOjdrEh8uf9KstGO+o4x3aMbQYF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782910104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fvYRWyc3z8t27v3w0F62f0dG6Aqi1GbB0bRsD3zgvpc=;
	b=T0ytnlOzZ2O8awA/SAMxHkS+lt3EDFCOWRfjgiJJqBwYE+fMJ3jD5EMYu1+hI8gQ6veAJj
	Sjqk7rycwKyMmgDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5EB55779AA;
	Wed,  1 Jul 2026 12:48:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ohXhE5cMRWqYXgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 01 Jul 2026 12:48:23 +0000
Date: Wed, 1 Jul 2026 13:48:21 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Gregg Leventhal <gleventhal@janestreet.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Eric Hagberg <ehagberg@janestreet.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Message-ID: <akUKty7jsWJrdyho@pedro-suse>
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
 <akQIIav_zaK6RmIC@pedro-suse.lan>
 <akQO8JtTxmp89GS8@pedro-suse.lan>
 <akQekZUyoKadiGCH@pedro-suse.lan>
 <akUADHLWEetveHLp@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akUADHLWEetveHLp@casper.infradead.org>
X-Stat-Signature: 6x13puce88o7p8iumu8smu9fn5cfrk3y
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A571680003
X-HE-Tag: 1782910105-260571
X-HE-Meta: U2FsdGVkX1/QwWkuPReEJTOhoPpIP9MI7QXCkNIBhjHBiuSobIrcEvde7BS/Vuz55weDMddSaaFLTLFmoEJ73TXOPQtJiCtaZkDytD7d8ZAQPdb/h45CTEwAzf6GGg89TeQ1JdX9yKjn/A28jaf7U6B2Tu2mIdJ2HtG1qhyYOxa+1+5g37EwrFC/CDVWtLoFI7wYIOzVLeaPT2PCmi5wPVSaDZ6+SjksyLJbmp6mCuKZGOcfwEDTzdnTok+gSl5GnhddsJqnipPPUU0TNh8AcCtO9dP/c6o2TP1ia8NiFHEMKXL7grI8x07B/dsWWAALCmrsrPrSX+2FrbEQZF6CHGtlyW7zgYE3sjxLQC6KEVZfOXkuFoWjXLiFY2La8grdAwYO4YkXk2OsuFA/yrhj82Tit4RDFDEBsYD8N0mUm1fJPQKhZaUDfepS5NHwkBwMoyCO+bi+prc0cYGvArQOryP+o+K3sWWAtH5xejCegMul1pPjfrrymmh1tmQqYvkxF/qvI5pqYk3XxAksXUpxRo6lC4GASLy2oMRRuSDfYmVhJqGsAEJJQWThJgitGBreKclSG7edzOg7yhlCHqpJqGFoFnUXsPvDo8b+C79Cf3fqBOz39XWaAwVfKwC514kC33xFu1rgwBUsZQRCQFtUmolMGh1UaQSEYP0BoZ00tb0dQaixUPYKDqXkDxTZWAq7naKgZIuYz6lB9K04VL/ILYetkR2B7srFqB6MDG0R5WiwD9LX8XaIBC64WhPzB8/2LvAMNPjr9UIk7OwOpIfUqBp3UJZIDj8M8rKG4RhYVhYdOAcMns0eM21iyycXoY5pp/RxVwfQbAiRe7/l3k9EM/oU528DlF/L0DEx1VmIIS+iQSKrBG0MubpUvc4Fb9EpqUmUMhmCdbM8pW4m1wr5W3dQBKi2vdo6Xd9HsE1yew4+tN1UnADtmv+r29DBD/DHgEFixVCZppK7VOjHNqK
 kpM/BRJ2
 +u6jR3EUag6Spjfz/oTGG1V53xC9E2TwUCostLodVOs1YBp8jx1XJ7CccsY90Bp+IF48y6AhIYsByaK9spT5XPsPruuu0W8MXDr7agfIX3uAR0zybe9/sC5PmGtYfAWC0y8PaeGcsRanIjUbkiBICjay8XG6h0csWqNZDmWl+1HEE2WTlRC4y7qo3sKITdxR17DJWX+oK6pDNq3PQGBFRRhg+/yqhiaiJKf3AaenzmNUaDX0wgReoh4FZfHSQqsXBcjW/pcdZpZlt29cviBcAZPXxxOeU1ULTOtk8AEdUsWlpChF7BcCC+0C4JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 12:54:52PM +0100, Matthew Wilcox wrote:
> On Tue, Jun 30, 2026 at 08:55:12PM +0100, Pedro Falcato wrote:
> > @@ -2043,6 +2044,17 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	 */
> >  	try_to_unmap_flush();
> >  
> > +	/*
> > +	 * If collapse looks to be successful, flush any dirty pages
> > +	 * out the page cache. With the nr_thps incremented, there won't be
> > +	 * any new writers (nor new dirties).
> > +	 */
> > +	if (result == SCAN_SUCCEED && !is_shmem) {
> > +		err = filemap_write_and_wait(mapping);
> > +		if (err)
> > +			result = SCAN_WRITEBACK_FAIL;
> > +	}
> 
> Oh, the other thing is that this should be conditioned on
> !mapping_large_folio_support().

Thinking more about this, I don't think it works. On the file open side, we
always truncate the full page cache, even if large folios are supported (due
to possibly max folio < PMD_ORDER). So if we skip write-and-wait on such cases,
it will be possible to fully reproduce this issue.

-- 
Pedro

