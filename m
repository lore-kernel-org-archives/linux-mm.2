Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75159D59D79
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 17:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAEA76B0006; Fri, 12 Dec 2025 12:47:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5F266B0007; Fri, 12 Dec 2025 12:47:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94DBF6B0008; Fri, 12 Dec 2025 12:47:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 856E06B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 12:47:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A3D8140281
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 17:47:28 +0000 (UTC)
X-FDA: 84211550976.18.733303B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 79FC21C001D
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 17:47:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="sIfAb/p4";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i8FQAv0c;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="sIfAb/p4";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i8FQAv0c;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765561646; a=rsa-sha256;
	cv=none;
	b=wiXPRTkcr1KMYNXecW4Mmny/jsW3VUQ/s69bcxNFx1d5yjfzFnwJvhg+ZIvHe6uAZH3Pw0
	pAr4ZxmA4Wl9nYpn0mW6df5EXuqWv7m4WpybFcTUX3xzLdfuuEhM8x+bTYxe+AmzMQSfKy
	DeQdxD20Ll2Ah72qTZNzsQ+TUuD/hOI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="sIfAb/p4";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i8FQAv0c;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="sIfAb/p4";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i8FQAv0c;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765561646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xm0B47SXvFdhP/mdCU4utvaKDziZRXpRGWDc4KmO5tU=;
	b=tpOxtLLWpAxha3Cuq/bE/rC5FJ+8DJC+CVJYMARdswMefr5iyXurWIV7B7nkhLGAjJmQtZ
	1Trqv1oW7VGh5DxHqJhUo7hSyTC6e1+mZn+UUiQURGTGIZ6fKpBtHyozev7dVqm/5dDiXS
	gzVF+7M7TqqFJ4EHKn1hnowcV9/BBxU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8DF0E5BF66;
	Fri, 12 Dec 2025 17:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765561643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xm0B47SXvFdhP/mdCU4utvaKDziZRXpRGWDc4KmO5tU=;
	b=sIfAb/p4D3Wt0AuIHy9d4lz3SFq4gnO/6SFyhsTF2ygbY/Eu+3El5BBtY66KNg+Y6piL4z
	rYWZBY5/pUq8T7N0fOpeWLIqfvqt2e3OJGzzC6CfSUnFde4/QEwcX0lEFNNyJ3fCRbFooT
	oohQCd2J5rr/Xec8nt1eJiUa2yTIPdI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765561643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xm0B47SXvFdhP/mdCU4utvaKDziZRXpRGWDc4KmO5tU=;
	b=i8FQAv0cWuXxk7dKE48gBkpOaAEnQfaDu/OTo34L6MeHMsWMaWjB6Y0P0voWhogAWknYjd
	/OesIp650MuRd8DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765561643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xm0B47SXvFdhP/mdCU4utvaKDziZRXpRGWDc4KmO5tU=;
	b=sIfAb/p4D3Wt0AuIHy9d4lz3SFq4gnO/6SFyhsTF2ygbY/Eu+3El5BBtY66KNg+Y6piL4z
	rYWZBY5/pUq8T7N0fOpeWLIqfvqt2e3OJGzzC6CfSUnFde4/QEwcX0lEFNNyJ3fCRbFooT
	oohQCd2J5rr/Xec8nt1eJiUa2yTIPdI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765561643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xm0B47SXvFdhP/mdCU4utvaKDziZRXpRGWDc4KmO5tU=;
	b=i8FQAv0cWuXxk7dKE48gBkpOaAEnQfaDu/OTo34L6MeHMsWMaWjB6Y0P0voWhogAWknYjd
	/OesIp650MuRd8DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D2C53EA63;
	Fri, 12 Dec 2025 17:47:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NQ95HitVPGktegAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 12 Dec 2025 17:47:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1B158A08F3; Fri, 12 Dec 2025 18:47:23 +0100 (CET)
Date: Fri, 12 Dec 2025 18:47:23 +0100
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Deepakkumar Karn <dkarn@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Liam.Howlett@oracle.com, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pagemap: Add alert to mapping_set_release_always() for
 mapping with no release_folio
Message-ID: <7pottkepdngwjiz6mi6rby67a2xpm65ulx3oflzhrv275efq3y@e64lbkl767eb>
References: <20251210200104.262523-1-dkarn@redhat.com>
 <aTnn68vLGxFxO8kv@casper.infradead.org>
 <5edukhcwwr6foo67isfum3az6ds6tcmgrifgthwtivho6ffjmw@qrxmadbaib3l>
 <aTwIAwjeSrALbVww@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTwIAwjeSrALbVww@casper.infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 79FC21C001D
X-Stat-Signature: 6cn6ppfjhbr9zh43865nsfko7p7t7zok
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765561645-613056
X-HE-Meta: U2FsdGVkX1/AKKAGBw5KGw8+n6KlwDvyIHer1IZ31qtG5sxrzfOAtNZ7jvwTslNFEzp/JyGWqz3ceO7BNbKE62plWuH6oKFjm8TGWB98ehGv85vT4vGdvG6I43e5yv3zKJjMgdZnq432Oj3J8psBHZChxSEH+kpQeRWiS+MzMHtcFA0alrC2gUgSLV9qtSSxHI3BNdyyp/rA3TyJOJU5SKsUTGbtmgsa1We3WwweAR9nfKc5vCiNuyGKnTl3iDzixsSkTToZZeBLI1xUdmKffwetyYfzayGO8VM14HxSpZFiwTOGHAvHeUxXRgtsmsPDhJq1B8s/d6cq/NxtsYjDSLGW537kRx7HmFXgh8MwnGNDZ7JVGESgUbVgjr4QvvGKgn31GNWu+DD30EGTHua5tbuJQxcD/GnOfqDfqXrSg9ryvA02PKeAiNlcjIe3PxDCnbSPfbH1uq7vBhwqDbFNo3o42tnWXgWzRS7thi2LUyvBJdm6RS+ONszSGIQjLhhbrDs0Hd5QgxUoCIedEJI08zgE9hFXkLxKzzmhZYu75/hy1rmXwVd8NXfeC1fP6FeVajTqJnncEjBEYFAHLve+2g9L2g9BKHUdVGxKdE12SYP/d8OMHPBLj6tiryGYOs1PBFcfn3o4xFb5+c62P/CR61+Qqkxs943JyOj8m/tpoOSVYaLTVjKlGz5n41ocTN8//4XKoF5gOZ30xwjAO+WO1zL4P3J4lER+STlYri7QOdq0pUpo2KOxg7lOJIEtQbSXhuYMAX09P8iumHPgvvoMG843kuxq1XPO8rmfGRMdWDV1D3STP2t5mxYyaroXao08HWsRchfKGDs4A3Cah3m17AYtRi01vI1m2a1k5GqcgfaQWeJBs7nLGEdQmJ68o78U6QtJb1UD76t7lgWuTkUY5G1rob2dzqXWTBFVVnjIQzVQtBPI9GIjlOj/k46X/akyuLpC+RpQonESskPIfrD
 MHETEEme
 oguAdrRb52IE0F6zvh8xZ8BfNYZDQhHytvfBz69D26YojgchfzrMEkSj42tKJeRN3kux/wmtFapqMAuxNMIz3HXqH+IzJ8D0K5C3av4d+k3oBL2cMX0qBPl4xhOgKkcPD2a4GSrYIhacePVxskLjag/KjjqYfvS5kZOlXPpZ4O6NVPjiwvUWAlR8c0sa8Fl9jLlH2RQHYxOIvwEvCnZ7o8F1PrAk6HPWQ7mV3tD456KCOt8cXY1vLJ7xnvI218XqQ7sH+2Dm/gc7+uMqrVd7mH5HYaOQnYGOtPe+PNXZZos2nXghuvRqy7+FfLK+XFAFf9dywVWpHfK2WGCeHCUFhf3/8Zt6wYQRYN/QMlEHE1ZcFwq/kDxl6XVsJEA+yfkq1TpBnS32BWX++jcY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 12-12-25 12:18:11, Matthew Wilcox wrote:
> On Thu, Dec 11, 2025 at 10:23:13AM +0100, Jan Kara wrote:
> > On Wed 10-12-25 21:36:43, Matthew Wilcox wrote:
> > > On Thu, Dec 11, 2025 at 01:31:04AM +0530, Deepakkumar Karn wrote:
> > > >  static inline void mapping_set_release_always(struct address_space *mapping)
> > > >  {
> > > > +	/* Alert while setting the flag with no release_folio callback */
> > > 
> > > The comment is superfluous.
> > 
> > Agreed.
> > 
> > > > +	VM_WARN_ONCE(!mapping->a_ops->release_folio,
> > > > +		     "Setting AS_RELEASE_ALWAYS with no release_folio");
> > > 
> > > But you haven't said why we need to do this.  Surely the NULL pointer
> > > splat is enough to tell you that you did something stupid?
> > 
> > Well, but this will tell it much earlier and it will directly point to the
> > place were you've done the mistake (instead of having to figure out why
> > drop_buffers() is crashing on you). So I think this assert makes sense to
> > ease debugging and as kind of self-reminding documentation :).
> 
> Oh.  So the real problem here is this:
> 
>         if (mapping && mapping->a_ops->release_folio)
>                 return mapping->a_ops->release_folio(folio, gfp);
>         return try_to_free_buffers(folio);
> 
> We should have a block_release_folio(), change all the BH-based
> filesystems to add it to their aops, and then change
> filemap_release_folio() to do:
> 
> 	if (mapping)
> 		return mapping->a_ops->release_folio(folio, gfp);
> 	return true;

OK, yes, this would work for me and I agree it looks like a nice cleanup.

> (actually, can the !mapping case be hit?  surely this can't be called
> for folios which have already been truncated?)

You'd think ;). There's some usage of try_to_free_buffers() from the dark
ages predating git era in jbd2 (back then jbd) which is specifically run
when we are done with journalling buffers on a page that was truncated -
see fs/jbd2/commit.c:release_buffer_page(). Also there's an interesting
case in migrate_folio_unmap() which calls try_to_free_buffers() for a
truncated page. All the other users seem to have a valid mapping.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

