Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C92C2606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=SIJR7PaZ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1r3Ro8cV;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1Z1BTZMu;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mGqoE1nd
Received: by kanga.kvack.org (Postfix)
	id C98256B05B3; Mon,  9 Nov 2026 07:18:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47BB6B05BA; Mon,  9 Nov 2026 07:18:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37516B05BB; Mon,  9 Nov 2026 07:18:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7036B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:18:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8EF61605CD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:18:25 +0000 (UTC)
X-FDA: 85415483370.25.17D639C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8B05B1C0009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:18:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SIJR7PaZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1r3Ro8cV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1Z1BTZMu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mGqoE1nd;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794226703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s8QpvVpNDVewFKc/qW8KTv/Yu1CsTkwsgK7/aqBn6Vw=;
	b=RSESOtGySBJ2Bd5Unu6HysKZI8mrQ4u/G/hUp//mfhHiJVpnIZ+tnt7zZ3M9P4+KdAQUqr
	12uU9zP+ajVqz9AXIMrjY6NGirw6BbTumOgGu6XTSa96KA4OXbNGbTWmS13tZaN4cA48U5
	xUc7R+uBLmxQu+l+sIoJYdZ5xYYu7uc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SIJR7PaZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1r3Ro8cV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1Z1BTZMu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mGqoE1nd;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794226703;
	b=2eGPqALfxuJgn28bvFwfZkkjaUrX041trLANXrY1BOf0IMRy7NM5tEcTPVexzfUOwSnWJK
	AVb5eRTBRuE85Jgo3Tbyz9z2kl0oZr2Am5C7HtFPSgKpGjv07BtL9bUzxMFo/TD3rkSCOn
	FGnDMnEB+Nh+yadcGECADd69+TU8pLk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D51A221E44;
	Mon,  9 Nov 2026 12:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794226702; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s8QpvVpNDVewFKc/qW8KTv/Yu1CsTkwsgK7/aqBn6Vw=;
	b=SIJR7PaZ4U+XpZq2vvPgIgqvTCDwGnKA36pP50wEu8wyjZtemA+nWy2k986BZsVss1ka5f
	nCz6mXG0qCurcmfC8GSfWtiGK9MebGccxUkz5rgFUdhqqBB2N+MQF85M2vVzToTJi66HPz
	6jMN/EfDP0NjUAsrkZ+3ELZYmmOLlWk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794226702;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s8QpvVpNDVewFKc/qW8KTv/Yu1CsTkwsgK7/aqBn6Vw=;
	b=1r3Ro8cVIcesg7nk8K7EtvH8t+DP10ADIvcSpKiavdtleRUwXS+mgEjIHrRwtOcdn3lb+6
	AvbBcZ5pc03M4fAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794226701; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s8QpvVpNDVewFKc/qW8KTv/Yu1CsTkwsgK7/aqBn6Vw=;
	b=1Z1BTZMugD6HYxTAQkRQzosn0DP13T0XGiqTTmppMxuG0rRpqQ100/xvQmywNaetv5m1TL
	iGgpm9FwtZ+sJNWE/uTcpiMQTcOuuzN4MaRw+R6zedmVynm7AziMGsrvXyexCQ/EbYxIt5
	+HmO6laH1qBjB2VQsLgJWJaVxFodxZc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794226701;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s8QpvVpNDVewFKc/qW8KTv/Yu1CsTkwsgK7/aqBn6Vw=;
	b=mGqoE1ndjGEs5d7VGq4ZZvTVuxkzAhovZ+okVogOHVFLw5R801DXUW3Owo37UZBqmUEsdi
	vNlRjVsW9IkBxBAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C74AA13302;
	Mon,  9 Nov 2026 12:18:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qQuAJQy68WpUXAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 09 Nov 2026 12:18:20 +0000
Date: Mon, 9 Nov 2026 12:18:19 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Kiryl Shutsemau <kirill@shutemov.name>, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memory: refuse to map page cache folios that are not
 uptodate
Message-ID: <avG5Wmrff1v-0p8G@pedro-suse.tail5790ac.ts.net>
References: <20261106144323.3634477-1-kirill@shutemov.name>
 <sashiko-outbox-202966@kernel.org>
 <8cd50b75-0845-4e82-a8ed-acfd3a261a3e@kernel.org>
 <avGvM5kpv_z2ezoz@thinkstation>
 <avGwAfK4I31KAPHl@pedro-suse.tail5790ac.ts.net>
 <avG1Rg8OyP74VIFV@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avG1Rg8OyP74VIFV@thinkstation>
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Spam-Level: 
X-Stat-Signature: szqftyt3ior5hqu8arzqnuhqcrg74h5b
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8B05B1C0009
X-HE-Tag: 1794226703-630399
X-HE-Meta: U2FsdGVkX1/u1PetDlxPe20sMtqBle8UHGCv1wWEvxgRlSDZ1M6Uwkd1rQp+Vm9Q/UQuO3WuSbPnQjVYoCBzuLHu3RcrLutH2Y+N/2DxXbYOI49EKJlSI+l4LlHc/SV9RKdMCDRCQhPcVQfVS08kBiHRJypbKFhADqVBXjMWE5Ysdl2wGP/V/5MijLIjkLo+VCAirlwc1YCTypvoagFaMzq/XFcovagp8uWk93NpjnWDtoRt/NDs+FHFD59wZLDjPoBSoII3N4Xxb4zoLN6e0lpOwalgZbNvwhFe3gbTvWX46FcfZpI1pToyzC3m3rK4Qzi4elpouAZk7ad3O8vIT8cO93HAUMbziHja6eCxavMyCVYlJ2ysG+VkS5iQJhE40PKjSq8jkw5FaSQJ169YZRglA/SGjlzgrls/ZlwBkhqsREJrDVQaNJfF4ZSrB+l8jPZZpLJ/XCvOXjpg/Zpu9InSNKK2jiz3S7l5XxyT/g5cSrulldE3dGArXZojVxq1LblB/X6XYAi+AYQTmoKKY1/F0irxJWO1sP63HdRI8M2yH1322uCc7Bbl0m5iCR7N3LM5IcyKdizjpQ3x4LFulWHwhRsXJckGrGatDrouIusA6MNDfavBByrtuCqk6W4/9A4xuVLFZTXNr9TUIlTVr02zSx/RAntS2T+LCRVRhFrdJVonMauZ+bxPqVEgMlcLg00HIERMVaIviYUhBcbrD9vhJzb8XyuO2At/DA3rqyi4kv5jZJoLzFIQXS+9sJRQdtRAPhuIksQxFvVxiWAigp3BVse/J88n7PZV8ARM/QoyNZQOGpWEmT4oJIQnDtW7S2C4Q/PuxR9G8b+CemOzbTHjUK0j6Yt1q0dV6YL05NfFO8KhfZAlhTGX15Gw4qcrf7dtPkrQePeAjnusbOgky3V3y64oUqNSa41F5z57nhHIa7ketkZaC3rGHRudAiW8Ji3TUtf5veUIwVR0XTu
 zpkEjr6l
 jwY1n/7uQ0zzCbXGuXLiSVKcAwbHAa17pqF5oqqaIriGLnbZp6cn7YNvvcy/jBl2lHtnO8PmJn3n4+BiP1vOph1za7M0HeKl6JdaRvwKP4NJquuC0KsmHbMyJxnrfMJOt8SQPnVLzSC/dQUc6RBkMMPYeDckQElnw5sDwdt0pQ/cfRNBvXjxrF7tXH7LS4ErGDXQKtisSDNKsGHOYmzbKHnXyWcDoUOsFh5Y5nObhlsa+GpexJ8jg8pYwKXpphX+MErPV8VAWH44KLYH4bmghXKiScRXRKtCslNDtYxxksqHJy11y4HQU66ku/wnc2A89b0c2BW/a3Zu+/0Vn3gZuWbjhy7cO9U0PfJiW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 11:58:18AM +0000, Kiryl Shutsemau wrote:
> On Mon, Nov 09, 2026 at 11:37:42AM +0000, Pedro Falcato wrote:
> > On Mon, Nov 09, 2026 at 11:32:44AM +0000, Kiryl Shutsemau wrote:
> > > On Sat, Nov 07, 2026 at 07:17:52PM +0100, David Hildenbrand (Arm) wrote:
> > > > > - [Medium] mm: missing folio_test_uptodate() recheck in
> > > > >   do_shared_fault() mkwrite path
> > > > 
> > > > Kiryl, can you look into that?
> > > 
> > > Yeah, that's legit. Will fix in v2.
> > 
> > Related: https://lore.kernel.org/linux-mm/as-fqjiGj5T5NLOe@casper.infradead.org/
> > 
> > At some point, if filesystems can randomly clear uptodate as a way to signal
> > writeback failure (even without the folio lock!!), these kinds of checks can
> > become a bit too error prone.
> > 
> > Perhaps we need to address this problem first?
> 
> The clearers Sashiko pointed at (ext4, ecryptfs, ntfs) hold the folio
> lock. Which one does it without?

You seem to be correct, from a quick look I can't find anyone doing this
without the folio lock. So it seems we're safe from that angle.

So the only thing we _cannot_ do is assert this on e.g an unmap (since we
stop holding the folio lock).

-- 
Pedro

