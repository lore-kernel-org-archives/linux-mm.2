Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 169BAC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D306E6B00ED; Mon, 17 Aug 2026 12:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0ED6B00F3; Mon, 17 Aug 2026 12:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7C26B00F4; Mon, 17 Aug 2026 12:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8109C6B00ED
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:22:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDDE6140847
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:22:58 +0000 (UTC)
X-FDA: 85111280436.10.043F709
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 95EFC18000F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:22:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M9lEqKNY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nc8Hgt6v;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1KN4OFxU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lvZ+d9ee;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786983776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hij7YwfoE5wWVmiYP4GWFvxTOzb2//kKqvv5I9rQBiA=;
	b=Flq0VQHaKvw9a2AWmQne+Mv9wnYOLdIrOA1WJuR119KYXSsIuRML6MfxLUIBTgD38tvct4
	dHnCJEIqhLKgLVJYGrBrvw3W8WTYkAvift29geTrBGLVrpMVswq+4aGnIU/i885PIuVRt/
	gSHkTrW61FoOvb/yjwnTCU+w1oNGxrQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M9lEqKNY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nc8Hgt6v;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1KN4OFxU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lvZ+d9ee;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786983776;
	b=BjlGovdE8l9EA6Zmr9Bdm8Pd/WR239ChElu9kCVvUd9bhOza9gaoRrQFHIr+MNd0obTxWD
	xto39TfRsZpwyzmuJDps9hzK3YZ56IXXp7RtGY1i8IQBzX96WKueVqnJxlbIDepF2lsbDf
	F6R+Z0VO68NJ6K0ZGdHgFIL0oogEwLQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ECFCD840A1;
	Mon, 17 Aug 2026 16:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786983771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hij7YwfoE5wWVmiYP4GWFvxTOzb2//kKqvv5I9rQBiA=;
	b=M9lEqKNYcNJeMlimzADwxfUN4Iuo8u1M5qZ1lTJs3quXNwBeUKx2NTgUTgS8gU//7f5KQe
	fOY9tOjPW0xPTdA9Ji7vIhNgInEWFVTziRjFAjTddLfdyVYXf0yOjFJbVILUYFR3SNGUAy
	ZUuOgKX9Zcec18Pbf66YNXV7DFrLQ/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786983771;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hij7YwfoE5wWVmiYP4GWFvxTOzb2//kKqvv5I9rQBiA=;
	b=nc8Hgt6vxy+kjbV35GgFuIzIg1ehEZBvexsuSDvHdnYPCBTMM0v4L26sjFuZ87li6F9oe4
	qG4/HxkDWdPF8+AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786983767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hij7YwfoE5wWVmiYP4GWFvxTOzb2//kKqvv5I9rQBiA=;
	b=1KN4OFxU2Rl6wuR6tZ+d5x7TcGnuYjUAcsDSxKkQypGZPQOKTPqnI4H07BGKHtuGkIIt+K
	pHsL+CnR1CkAv/nsRiRo1Mralp+pjKdAiwKuHU1WcgzP3MFeqTM4/s6OLqwQxS4hEONSLU
	iUa5063guwOJLY4U+nfpn0WgMc4qs8Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786983767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hij7YwfoE5wWVmiYP4GWFvxTOzb2//kKqvv5I9rQBiA=;
	b=lvZ+d9eehGsD2WHxLtIdIgKyKG8tyrLQzC17UozcWpwcq4D0KPVpVxo8FzdfzNZj9FSa3N
	1b6EKMjbip6JbPDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5D8E7955E;
	Mon, 17 Aug 2026 16:22:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rpcTOFY1g2rndAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 17 Aug 2026 16:22:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 90FACA13B5; Mon, 17 Aug 2026 18:22:46 +0200 (CEST)
Date: Mon, 17 Aug 2026 18:22:46 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Ayhan Aydin <nsd.project.dev@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Neural Storage Driver - learning page cache
 prefetcher
Message-ID: <ffcij36vnozf3rginqd2opd2dwqyki7xhtdo4veuty734hhgba@utjav2k263o6>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
 <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com>
 <anlByPDZmvEhWeXI@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anlByPDZmvEhWeXI@casper.infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 95EFC18000F
X-Stat-Signature: bjbe99ud6nrq6nbgp1a5cj7typxdz1z3
X-Rspam-User: 
X-HE-Tag: 1786983776-893195
X-HE-Meta: U2FsdGVkX19dWqaMdOGgAG8vumy6cafYf1fPxA87dZFHrM4I8sghrXltLPDMJeqjzJ4iuw0rfAoBLTjrz8mimhFa2r9p2deYgFxTi5nOhQvSrZayonz7DifE42+gWjBqEpry0pErTs+hwkAB9kiQm2A0sV4riWiQ5HP6+/bfVpCBfrXZuC7nRJA0Wafx4HbDBpKWeV5QNmtf4ZPsinjRni5B06XVuj92GSLQxx7w049jvDiLVsG26flFV0As4uzviN39Z1oDkcJ8QZR+PAYPiXJwSKj0aphWRDf0GxfTNwWsA084YGcUkPMEaaDXxl4BeV+x2rTtlL8q07F0Ue8P35QZm3l9lcEYd+Z9pI1eFn5+NSwyV64oDUpFNjglbt07zysu49n34YXJdK2tvYomHQ/JbjjZOfk7GziHey6Ml/q1KRoF0u50PtZ47kQ0rbT7X+wJDff4AKwUX8vlaK+B4rTjnDArNELRo/esvdhFkN54y6KbSyFaYfnYpgaCooCq0Db3jdEt/QBUE8WVEPFgqjXm99D8GxmsJ3gxiBk8b+ioFzEHKc5up4TzwM6Nxue7OtTtcVDnQJaknVrhX4TY94h8qgPQh/K62j5atfDvf2Xt0ZD0MBhtgLSoG5puWpJs8Y+Tw1M9B5BEpYth/fyuUi2id49j3/vGXAmPnE+/BSGMXEIbw2IOMC4yRe8qbb5E9KtgU8QCewKR4+4idpcgNlZZdQgXgyZtnydkIYmbYyKkbyWC8pyofffzvt1ARCI7USqUhMcYydoVFMPk4nP8LMwAX8BXLssQjyvwsNn9jUbJDtE+VhvUhP4IuCb8k5pDJ2StstFRmdzevRkaESR1cXRKxDNVF/+X0ukhd1E/tcpYn11YKLG1iN4wNgcgK2XixSdcVTn0/3sU6oaeqU8UCyfWg4dLxc+SqjnmO9n/LdOl587dHUWwejFz8UrS/m45eaA0OPE95YS7jX1A3G5
 W17gDqih
 2NLLz9JoZzO9M7+7Vh2s0aEfQtfdTrTI++yJnE7sGSJVjTPjPaorIpIfvcgFPFqCorOIA2yEM5d3G/95lx7gV12A21PrxpGoQ3uU9UkKaZaPKuywubRMUIdIBOTZJdXjLdJi4CuF9GOabWYQgtIkkub6rAZOAb1EKdxuShg7QOksrfv6w0z7fa+KGhZRs23yNeg3PTGIDt8SGxZz9s3uErahq7uAqWnx6y8DeiZK87RxOgdmadPTpGgd+ok6EWrVkQGduHbEhYhWFqy/K7e7qtGLKYD2ZxLnC5CBP7hCGkqrnbBj13mLi1axWe5cFVDbnecQ+/bZ4DIi2i4f+RwjDb5pvRrtYcLkfrgnq4BOlZoIShSiiQ25R3f4mc//Vb6akN6RupeZmQJ2ruJMCCvxN7uaaHqEeQHeDit+R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 10-08-26 04:13:12, Matthew Wilcox wrote:
> On Sat, Aug 08, 2026 at 05:10:42PM -0400, Ayhan Aydin wrote:
> > For reference, the series adds an optional observation hook
> > (CONFIG_NSD, default off, see PATCH 1/3) that does not bypass
> > the existing ra_state / file_ra_struct machinery. All actual
> > page insertion is still delegated to page_cache_sync_readahead().
> > Benchmarks (interleaved ON/OFF methodology, i.e. same-machine A/B
> > with repeated runs, SQLite full-table scans and buffered
> > sequential I/O) showed an 18-19% wall-time reduction and
> > +22.6% throughput improvement respectively.

I can see how SQLite table scans could be improved but I'm really surprised
by the 64k sequential buffered read. That's basically what the current
readahead logic is built for. So how is the sync readahead you trigger
better than what generic async readahead does?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

