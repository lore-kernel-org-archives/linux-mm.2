Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FEA9606A337
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FeIe9h+H;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=m0TxgWP2;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FeIe9h+H;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=m0TxgWP2
Received: by kanga.kvack.org (Postfix)
	id 6A71B6B05B3; Mon,  9 Nov 2026 06:37:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657A96B05B4; Mon,  9 Nov 2026 06:37:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547596B05B5; Mon,  9 Nov 2026 06:37:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32E166B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:37:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A541480668
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:37:48 +0000 (UTC)
X-FDA: 85415381016.04.FA649C5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 99D12140005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:37:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FeIe9h+H;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m0TxgWP2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FeIe9h+H;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m0TxgWP2;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794224266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRL63m1JCnXY61879gYZTrgoNvP3XpaHMthdQScuJXY=;
	b=kEXWK8bWCo7HIBS1+GHvPQj29xfBOSYG/oxyY/05fEoXFZil6x4API5WzXfUVPG3F6Dqqx
	a0cqWxMravDSAgxkRxYkiBDG4rHGBis1gtRHGYwpdFznyMrLXsOZw19yNgjEdIUqEn9yUg
	GP9xF+aL5+rmbAUW5NuNpNi1Trf5SS8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FeIe9h+H;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m0TxgWP2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FeIe9h+H;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m0TxgWP2;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794224266;
	b=BXYZ2N+r+D0HTX+jmNcUFZ59mJTV95O2usA4SFuQ7GGnDMeuxcthLw6Xr1JRYGo0uN/X5n
	4gGPG4YpQPj3h0v8kga3VVYm28RhekNiiLwO3YIzuQoUoXyLbEilVU/WfysDenl6pemltF
	wB5qBE7QFKRnk5vMT8g9yTHYD0O3Omk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5B85A1F7C5;
	Mon,  9 Nov 2026 11:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794224265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PRL63m1JCnXY61879gYZTrgoNvP3XpaHMthdQScuJXY=;
	b=FeIe9h+H4Mgvz6tLkAtMXzI1sMYIPmP6JUreacUuRnBpzFkDnOX631ABslZg30icD2j1il
	boy4Mbccw6ILsTHxJUReYiI8x/BneR8TeRudCExAg+rYEWcex8Am3aRqEuZeJsHrfeiYy8
	ioF9174EIRADEt2vqstb+JHAZJnT454=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794224265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PRL63m1JCnXY61879gYZTrgoNvP3XpaHMthdQScuJXY=;
	b=m0TxgWP2LPgSk+eKMmhcMgZKCwwWBKwJYMdNx3edpmcV87UdCz6tGuFE630Ly3U+wWp40e
	3ji39LRSq6LjBUAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794224265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PRL63m1JCnXY61879gYZTrgoNvP3XpaHMthdQScuJXY=;
	b=FeIe9h+H4Mgvz6tLkAtMXzI1sMYIPmP6JUreacUuRnBpzFkDnOX631ABslZg30icD2j1il
	boy4Mbccw6ILsTHxJUReYiI8x/BneR8TeRudCExAg+rYEWcex8Am3aRqEuZeJsHrfeiYy8
	ioF9174EIRADEt2vqstb+JHAZJnT454=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794224265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PRL63m1JCnXY61879gYZTrgoNvP3XpaHMthdQScuJXY=;
	b=m0TxgWP2LPgSk+eKMmhcMgZKCwwWBKwJYMdNx3edpmcV87UdCz6tGuFE630Ly3U+wWp40e
	3ji39LRSq6LjBUAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D0DB13302;
	Mon,  9 Nov 2026 11:37:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +9fIB4iw8WokMgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 09 Nov 2026 11:37:44 +0000
Date: Mon, 9 Nov 2026 11:37:42 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	sashiko-reviews@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memory: refuse to map page cache folios that are not
 uptodate
Message-ID: <avGwAfK4I31KAPHl@pedro-suse.tail5790ac.ts.net>
References: <20261106144323.3634477-1-kirill@shutemov.name>
 <sashiko-outbox-202966@kernel.org>
 <8cd50b75-0845-4e82-a8ed-acfd3a261a3e@kernel.org>
 <avGvM5kpv_z2ezoz@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avGvM5kpv_z2ezoz@thinkstation>
X-Spam-Score: -13.30
X-Spam-Level: 
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 99D12140005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: p1x4g14aygyk9b1xcic8msmcoapimc5t
X-HE-Tag: 1794224266-59390
X-HE-Meta: U2FsdGVkX19kRYRrbghVFrq8RbM9oLxi9XkjKf4bKuqhi1N1hroILkOSEc9BlIap9mXun7h1gAN1+VKfSC/OB6FG3gYAAOfav5S0ACjkMXt2ave7yEyLH3kbiGcFTMT11ILB2mKWfywJEKc8lGfCETzwXL/fqDKnMC0kmeKF9Hmw4lML2yCCBUCiFiSWX3MnrjwByG4+AP4g/k5JQdJx2kEJ/0DgC1dWZ2uNp72MoyxlRMMYscwfXenSmhXEk8hGJVBJMqErczbgee55VGfOoKGGK6aDRD43m2TyzHc+w8khJrMVrAbApVwGbWKdzkuyNvsPSMZxVR+JcDHHl76fiMJbEfzCSl2UiV1EKzlygLmJp+rCDppf+mEZcFIHXlt09QtmC0zhrCJALdzONvHFM0HakYZojpXsKcJPpWM9RjYdnl+TnK0HTAC5LO0vWasy7yBSkeSussO/+mHd9inV3wQYm2VhzWUmOjbdOxYv9eeiqPjuNrh6o976B11cHBKkB0FWS+TEOC+OL2vx42gcxbRkirwNaDZoZQp+OvFwwaLkrBB40aBgZk0A0xsJIqHjiO7qXbeq4JLKL3uQlRucF6l0uZyY6TV7YGn5mEfWSqZOT5Anxr5ej2rjjct1LCGXasiVdO9vlA48/tf075yQTyyiAIA6KCWHs1BbxchS+gTlJ1zXxzxCeudWx5yALOPgQheVvIBuCExNEwiEgoyHPNScNgkjCzP/yPoX7DrIBxiEeM4tmXuKV6pJSpOGC+4ueqeVjLTUtNCgH65uJOG26tP1WKHggn4DVsiGs7Bqay4bnLvlU6cYy3aP78eXWuk2O9+XiSxdruU33jNySTqOJ03dF/fvgKtAk/Mr0Pj/DnexI8E/CjiVFAfBa5R9KnLzQtLIm5aeQPof3dPUwL0DYU99W2ViA3c6Bhy8zCRsEJZHX0IMxyka+/eBIo8iae4wQnDE8PlQ2I0bkdvAS2T
 Kut3dv7L
 zsAC+Qgu9EMpyBvNUZThXNrNsyLD+dbIH5sjBQ7+6B31v6kGhC1Auji9OvUvRSGJYE9XLv31vnmOL5ckAE/mRaZ5xzX+TZ7gV/lCo35jAK+u2y5oRGj0f9p2Q+Wkny5NqyWl73XsBwfns5ECYg2J8mdSTFCaEZ8AkAHtMNYsNmHNQ/CiEPuGdSCKeCndvziGDGPaP49yZcMJdO28GjkIbBG17S80jSGbQBYJgaiRCIExeHpFw/jURgkXbx3jK/gWhn0KN9JDtdwG3RDKEhQIZ4d9Z4j7zqzp8Cx0fnFzpWGvnckc4aOWT4KYvwhRSMlCKea8SIkvtHGhflqeUlYQ5jkTLobpvM172v4Ra
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 11:32:44AM +0000, Kiryl Shutsemau wrote:
> On Sat, Nov 07, 2026 at 07:17:52PM +0100, David Hildenbrand (Arm) wrote:
> > > - [Medium] mm: missing folio_test_uptodate() recheck in
> > >   do_shared_fault() mkwrite path
> > 
> > Kiryl, can you look into that?
> 
> Yeah, that's legit. Will fix in v2.

Related: https://lore.kernel.org/linux-mm/as-fqjiGj5T5NLOe@casper.infradead.org/

At some point, if filesystems can randomly clear uptodate as a way to signal
writeback failure (even without the folio lock!!), these kinds of checks can
become a bit too error prone.

Perhaps we need to address this problem first?

-- 
Pedro

