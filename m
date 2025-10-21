Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8457CCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6B68E001F; Tue, 21 Oct 2025 05:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBEDE8E0002; Tue, 21 Oct 2025 05:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4FB8E001F; Tue, 21 Oct 2025 05:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB8B38E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:52:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43B9D11A050
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:52:46 +0000 (UTC)
X-FDA: 84021657132.20.373C993
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id DE9D51A000E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:52:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cXu1hD3D;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TqEsS6di;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BFA1XwD0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MQCft215;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761040364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBxxw3f33T7dC7DhUU8jalY0jdpMgHmW3egy3pJTZ98=;
	b=B0G8aep9vS/aFHZC7nr3xGlP3ni5xRGwZhP+lR7tE4bpjPFdHjvFgojarW7av5I+pjqpXk
	L2wConvn7G6mdbqdpncjYsNgIaohoFelhiac1oP4iAwR/wCGIMqY7aZJ+MYe5Yxj+CxZKB
	nEnLd6ILqZ54KJm3IhNvbzb/h+GrluY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761040364; a=rsa-sha256;
	cv=none;
	b=SNxaK5doNbEwfKiM/C9QmJ3BQzLvME14MG2bnADqv3cEdO6vjUAvADuSjHk+FoB63wEoJe
	VPfN1hq8OZrs4+MFy1BS7+h6mlLQYQKs+y/ol13cPLS78sWI88J7OJVYV22XX40catoj3N
	PPGGqw+OLlLSDvaQLwfwDBLcIeMQQbQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cXu1hD3D;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TqEsS6di;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BFA1XwD0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MQCft215;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 41E8F211B8;
	Tue, 21 Oct 2025 09:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761040358; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eBxxw3f33T7dC7DhUU8jalY0jdpMgHmW3egy3pJTZ98=;
	b=cXu1hD3DW0vdsQIk7D4cYPtyKnGahz5KGi60w+yB/LY4P0ia3EL66qhFFhiRJZL2x+JGnC
	UngbJYn453f1mnTcQKKXzt8ftBN0pT7u44fPCrMFgUR3Yj05EcMVC/vMkjn5xZ/dQeK7II
	PfJkMq/0CgC+tKKU3M5H51jyEi/c0KY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761040358;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eBxxw3f33T7dC7DhUU8jalY0jdpMgHmW3egy3pJTZ98=;
	b=TqEsS6di4eGrYAmKVfQuYzjumkDaLTkO+A+kM3CmtI5sOnbV5l1hy98LF5gyL07lQCNwdH
	J1VbsQEB+zOmlJBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761040354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eBxxw3f33T7dC7DhUU8jalY0jdpMgHmW3egy3pJTZ98=;
	b=BFA1XwD0xHliRiWl4hKau00bDyfwzx+YxqUtwmgY/BhiiWBtONYJ670efAr6JHLjz1BxwL
	ZhPfnsDlexWzl4VlvF5IMfJA5KXAqRpxLYyuUFEJG7Kw/P5CRlKVHrkotKmD+WVuZJtvOo
	TMVC3XrLldJy78nw3xAP3q9xdfljN1g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761040354;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eBxxw3f33T7dC7DhUU8jalY0jdpMgHmW3egy3pJTZ98=;
	b=MQCft215cafvoyPNBAfugkI0jAdDJwgsSBHr6oWtBRJixDx74iu2UNt46hr2Lx7nIT5W0D
	MILGO04GH2nD+QAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 349C8139B1;
	Tue, 21 Oct 2025 09:52:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6qDZDOJX92gVYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 21 Oct 2025 09:52:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D5389A0990; Tue, 21 Oct 2025 11:52:29 +0200 (CEST)
Date: Tue, 21 Oct 2025 11:52:29 +0200
From: Jan Kara <jack@suse.cz>
To: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Matthew Wilcox <willy@infradead.org>, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
	djwong@kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <ls6lz2ttduuwwtmmlzwfkybeuiqraymv7fon5crft6dv5gtst4@yh3noihpzvla>
References: <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
 <5bd1d360-bee0-4fa2-80c8-476519e98b00@redhat.com>
 <aPc7HVRJYXA1hT8h@infradead.org>
 <rlu3rbmpktq5f3vgex3zlfjhivyohkhr5whpdmv3lscsgcjs7r@4zqutcey7kib>
 <750cfcac-e048-4fee-bba9-6e84edb7bbe0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <750cfcac-e048-4fee-bba9-6e84edb7bbe0@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: DE9D51A000E
X-Rspamd-Server: rspam02
X-Stat-Signature: awuqbc89rgo3bp3rp7kpk7eikoqseyps
X-HE-Tag: 1761040363-891332
X-HE-Meta: U2FsdGVkX18+/pK2iOSO7wT3zzVZQ+c5m5ojKg86KN7WDWa22C2prxKWJoDKO4R0ltTTz6buQUmvOU1Z2uMT4EqwggzCsGPAo0oUqobhtAKYowKJDLWmYj+HpNQVRPQKEGzYv7SfqooixVHmRw8qDg7d3fYL19QtjUJBN8OLxbd8NiwYLmHGYpnaJ4PPsWydLvXqV5dTpbxHPQ9KsnSBDQs5fIXGlCkjKbZTt3kJebtR5SElQDr5/WE90MQYbsFuWrisa+W8FuA/VewN/4MFLMGUFSswjWhzy51Yg3WC39hd6Sg1dcqv7j9pJ1F3AJNuxR21xvd83BWNmr9qQI4eJsqK6+mYcfD4p+xE3FxWJLWiAH4ECEeZu2AS6z8jLXTK/ZCVY+y4SjWvRA8yEdRTP3noRbw1Nk3+PUvsVyfYUhJnYEyHxA6Kp/V2QS+GPcjQ5jyniHzcosDJsf3mJRO+7756fVB8eXXMR+vsrR3gsLhru/ixWXRouS7tBbFPkOXzxPw7dJtAgA5UoW5+WMChQ2mspCJB95upCa1onnDOLA6gfskghdVaHwSHS8x4dn+K7jp0da29ODt8H2/sMG73K3JjOhXfPgTgeYP15cG5d6FmTlxsNrQgouGo0pjRsk/Njggo7Itsf4E3W8GHxtQbiKDaC3Bw/1jW7m+uUwtyL5QDrFjR1v4Vcdjl9OeLe5TV8WdQiDk3XR2naHDFpMguh6Uym07x50ccyyCdAImc4IMIysVFdRA6SZ5rh5bzlIJC1P61NniRQQTabgylb6l9a1nU8EFDNnWSTgeqPAe846Re/eLTEcIslLjrCeGbVo7X1Jeyra0oif7uxD8pXKcZ/BCOIw/jwwJIVHGjCahyU2zMybx6lOcxFNckTPhl3HdGBqFjvglY/U5GggC6EDDPAUGZF7hB5SQ4HcstxrYNe9RjqmMJH34dl+xGh2n9Yd/9HpgypqnZpxZniXoKmOX
 GsytmvcF
 qxn5T7WQl3sZvFJxyST0qs/0haK9n3weGXtl72dMUQmXDCr4EYNvM2145S25CIQGaDJjSIonXH8LO2vDBrmy60V/gPArHMM/cKbQAt12ll/rctAGmcbeRywNBrtUCP8pkKo4Z+T4BkG9cVmGm9I7vN7rT6OMMqd7TMPIgj4dudM4kNzBOTzgCsRxDug/0lusJzzcDuKMDCNx760WIVUCy6iREFZBhG8kYEXVtY8Y6uK5Yr5n5gAefRHhLEI00pxROg6hhRhoJtGCjcg0SVMYKJtEcJ2xKyw4RUXyfEoo8A+ETrRE+POgNjPJWPs4Itj8Y+h+i0Jeu5n6iqTy1qAhenogmJsoSUB3QFCD0qGx+l3/wkb+ZTTlUyuyuhsLd042UVfWlo90ywz5vDC8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 21-10-25 11:37:57, David Hildenbrand wrote:
> On 21.10.25 11:22, Jan Kara wrote:
> > On Tue 21-10-25 00:49:49, Christoph Hellwig wrote:
> > > On Mon, Oct 20, 2025 at 09:00:50PM +0200, David Hildenbrand wrote:
> > > > Just FYI, because it might be interesting in this context.
> > > > 
> > > > For anonymous memory we have this working by only writing the folio out if
> > > > it is completely unmapped and there are no unexpected folio references/pins
> > > > (see pageout()), and only allowing to write to such a folio ("reuse") if
> > > > SWP_STABLE_WRITES is not set (see do_swap_page()).
> > > > 
> > > > So once we start writeback the folio has no writable page table mappings
> > > > (unmapped) and no GUP pins. Consequently, when trying to write to it we can
> > > > just fallback to creating a page copy without causing trouble with GUP pins.
> > > 
> > > Yeah.  But anonymous is the easy case, the pain is direct I/O to file
> > > mappings.  Mapping the right answer is to just fail pinning them and fall
> > > back to (dontcache) buffered I/O.
> > 
> > I agree file mappings are more painful but we can also have interesting
> > cases with anon pages:
> > 
> > P - anon page
> > 
> > Thread 1				Thread 2
> > setup DIO read to P			setup DIO write from P
> 
> Ah, I was talking about the interaction between GUP and having
> BLK_FEAT_STABLE_WRITES set on the swap backend.
> 
> I guess what you mean here is: GUP from/to anon pages to/from a device that
> has BLK_FEAT_STABLE_WRITES?

Correct.

> So while we are writing to the device using the anon page as a source, the
> anon page will get modified.
> 
> I did not expect that to trigger checksum failures, but I can see the
> problem now.

Sadly it can because the checksum computation may end up using different
data than the DMA will send to the device a bit later. After all this is
why BLK_FEAT_STABLE_WRITES was invented...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

