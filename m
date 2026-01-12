Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E01BEC9EC8B
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 13:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC016B0088; Mon, 12 Jan 2026 08:06:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9366B0089; Mon, 12 Jan 2026 08:06:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A3E6B008A; Mon, 12 Jan 2026 08:06:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 263936B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:06:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF8D21A8D0
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:06:31 +0000 (UTC)
X-FDA: 84323335782.22.E912545
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3A7FFC0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:06:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KfQxrRlk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8cpFpgzW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KfQxrRlk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8cpFpgzW;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768223189; a=rsa-sha256;
	cv=none;
	b=hgIecS2DkZ8i9yRkVc9CllCu9HrWejA3/Tso30bkMNw6DkgEmGBMX4xPwdxvglDIP+FNSf
	6+VqAGIfzvpHT8H4Z3IWglqBf5P2RXsXhqnT5Ysy8ZJ8/fPjZ5GKEWI9rhn/rZsz7xOlIz
	8FAbbq05REnAHXNQbyXDV6jSvmcuIaY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KfQxrRlk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8cpFpgzW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KfQxrRlk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8cpFpgzW;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768223189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1O4F1mH7HItPmOqJ627Rc9BGNGj+R0e31g81fuFMM/4=;
	b=5n/0G6pAOLFe4B7CoCLccNYkEfP2TU2o6QtTjSdFlqhiUZw7rWQVpcdDqwxCsR1y6Z6Rsv
	g3sMzZjhCG3ebtRqgz5MKVFhUBOVVl08Osu3i9hoPGb24f0gqtSPkuUTuBsu86RQlksR8V
	Ny5WQFytMgjsRDHn6aHA8SwfAyFUoeM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 508C9336AE;
	Mon, 12 Jan 2026 13:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768223187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1O4F1mH7HItPmOqJ627Rc9BGNGj+R0e31g81fuFMM/4=;
	b=KfQxrRlkpaswM4pAu/Suran5vSqEP8Uv5n6UKePya1mXrqas9x7B72WEvUP3HJZ/yaujBD
	K9UcW/PGJ9/0Mdes5qc/0L1K9zOeCHlgSkNvwR1iz6D9JlnKpPrG7I9/TknNtLSw95OmkF
	LqKq2s5iK3+mrXIt1a8U1D4Y94ftszI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768223187;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1O4F1mH7HItPmOqJ627Rc9BGNGj+R0e31g81fuFMM/4=;
	b=8cpFpgzWtTV1uULcC5qhLr5DmVAyZ3iI6B5li9TvXdprn/YaRxcZSDs6Ghltj8llgmSzKi
	9hIDam+YUNmoG+DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768223187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1O4F1mH7HItPmOqJ627Rc9BGNGj+R0e31g81fuFMM/4=;
	b=KfQxrRlkpaswM4pAu/Suran5vSqEP8Uv5n6UKePya1mXrqas9x7B72WEvUP3HJZ/yaujBD
	K9UcW/PGJ9/0Mdes5qc/0L1K9zOeCHlgSkNvwR1iz6D9JlnKpPrG7I9/TknNtLSw95OmkF
	LqKq2s5iK3+mrXIt1a8U1D4Y94ftszI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768223187;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1O4F1mH7HItPmOqJ627Rc9BGNGj+R0e31g81fuFMM/4=;
	b=8cpFpgzWtTV1uULcC5qhLr5DmVAyZ3iI6B5li9TvXdprn/YaRxcZSDs6Ghltj8llgmSzKi
	9hIDam+YUNmoG+DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 47FCD3EA63;
	Mon, 12 Jan 2026 13:06:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ncyLEdPxZGmoFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Jan 2026 13:06:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DF7DFA0A7E; Mon, 12 Jan 2026 14:06:26 +0100 (CET)
Date: Mon, 12 Jan 2026 14:06:26 +0100
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Bernd Schubert <bernd@bsbernd.com>, Jan Kara <jack@suse.cz>, 
	Joanne Koong <joannelkoong@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Horst Birthelmer <hbirthelmer@ddn.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: __folio_end_writeback() lockdep issue
Message-ID: <wu7mu22kgr7pmzrneq6rkivhwvpbximyrkouciktl7wf5w7wur@rsyqyczopba2>
References: <9b845a47-9aee-43dd-99bc-1a82bea00442@bsbernd.com>
 <b7b72183-f9e1-4e58-b40f-45a267cc6831@bsbernd.com>
 <aWJ-pHIY8Y8sjLeC@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWJ-pHIY8Y8sjLeC@casper.infradead.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3A7FFC0005
X-Stat-Signature: egitynbxnfmy4qyzkytpowm57i85zgpx
X-Rspam-User: 
X-HE-Tag: 1768223188-761876
X-HE-Meta: U2FsdGVkX199RlKRYhFCNuKrPQx6BCmHoU4aQVzrBzGZOcEJMdlEELJDDtKTVmief4C6WlY410a3LhXk/WmB4pqm33SASZ6UkcQZdE8SvOVCWFTp/3LGlRukDa59/TjpZW2U+QIb1/b9Oot0Y67UJqQbFZVMEJUPJ880KIDbSPdirTkuCc+IVx7sdJXw7NxXM6Axci5WWlB+BBdU5LZ+LCFhLQ0RJx3GE3wXviSla117QJi4xzHkDIX1lQ5/UqoI+xVCZWayJlKlt2vKVP2fdXXzLg78LjlyZxzfeuLHNl8t32nlwfB+RLwyIn0cceNGSflWTFo8vU/rWNUp4fLSpIeImslMPX25xu/8BrzeASQzqFiEj0WTZblUjCYSGWkTtzysZLqXToGSO/65PYR7FvpNCUa+PFH+YoprzmgHr8whIGYyTZE9DA+7TfifS7FfRnwCwWgL9RlQnrpY3oYwpAAhQvDC10O3JW3GwC0dlPpBw9xUeyP4tX3rEEG1ZBSjSdmP+pDOje1E2m7fhHOUAOwt82k8z4gTlsZn39xfRqFLJ6dZEmJjSnAZI+KstaF372WoIR7hfT4ku2PDrB74AEvGaO3rZU2Gn9itcAv+jNbuM5QCXBxT4S1gm2UonbomaRjZm0h9cJAEHs6cRxme6apHHb71VOSwFRKQpnCFFf1eyUd7njYykDemSpM0dU3Q/QlP+SJnuPELEIIA+6SYzpIVSN8GyQg80aXpoXe3x7BR7gyDZ8i0oo3xug4ZCdO6hgHvpY55yyuhPo9d5ussexoWWOxMvik81DvnAo5tX6HNBtileYPr38C4uWj2REN//7ymKz+m8mVEg/0t5bPfoB5dnwl7qtBRVygo7ud/NOO2zy+cHBo2XVga1T6IYpGd1D8W+FLs4wdglPIm+0FzYO/pvxWVdJGGxhzAHmZUTfGGQghqwV7szCVT3pBn+wV+qW3ayDpcFr+nXQmrskk
 /pA5eSvj
 7ktpqNmUZyKzA65WGQXnxDGcPVvJ4Sj5rIkGQxZEWHFXfqIMrLAl9Y4m3BuCq2ygkKzinuesI9ADx929j2/cAtln9puXEgEADcm1DX21WNBOmUvka3XuJjOW5yfqKgMhMCJytmvkItESHV2yT/HtkpqUc9XoNfK1DhhYC8zjqeRRQXUvNNvlF/vA4Da1rzOAr3hLpm8tIok5UvRkUjWiijmXce5U//d52GbkNadqpT2boRWvrmHthWXf75HFDnxrua4PWgEhC4FGosdV4IKkA4Z0FXdlgPnE6OO6xukEAQkfFnpVG96T96uG+K9ltrOnI6Mj4CfUduF16Z1gME+8x9mFMfQnIh9HGmo0nPQGaYDtUlKtAPgmz2nrfeHccFn0iSp8y0KzsdUsa47rC+dD2+vz7/LDfRhqFj3rD5H59SLH8Y3s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 10-01-26 16:30:28, Matthew Wilcox wrote:
> On Sat, Jan 10, 2026 at 04:31:28PM +0100, Bernd Schubert wrote:
> > [  872.499480]  Possible interrupt unsafe locking scenario:
> > [  872.499480] 
> > [  872.500326]        CPU0                    CPU1
> > [  872.500906]        ----                    ----
> > [  872.501464]   lock(&p->sequence);
> > [  872.501923]                                local_irq_disable();
> > [  872.502615]                                lock(&xa->xa_lock#4);
> > [  872.503327]                                lock(&p->sequence);
> > [  872.504116]   <Interrupt>
> > [  872.504513]     lock(&xa->xa_lock#4);
> > 
> > 
> > Which is introduced by commit 2841808f35ee for all file systems. 
> > The should be rather generic - I shouldn't be the only one seeing
> > it?
> 
> Oh wow, 2841808f35ee has a very confusing commit message.  It implies
> that _no_ filesystem uses BDI_CAP_WRITEBACK_ACCT, but what it really
> means is that no filesystem now _clears_ BDI_CAP_WRITEBACK_ACCT, so
> all filesystems do use this code path and therefore the flag can be
> removed.  And that matches the code change.
> 
> So you should be able to reproduce this problem with commit 494d2f508883
> as well?
> 
> That tells me that this is something fuse-specific.  Other filesystems
> aren't seeing this.  Wonder why ...
> 
> __wb_writeout_add() or its predecessor __wb_writeout_inc() have been in
> that spot since 2015 or earlier.  
> 
> The sequence lock itself is taken inside fprop_new_period() called from
> writeout_period() which has been there since 2012, so that's not it.
> 
> Looking at fprop_new_period() is more interesting.  Commit a91befde3503
> removed an earlier call to local_irq_save().  It was then replaced with
> preempt_disable() in 9458e0a78c45 but maybe removing it was just
> erroneous?
> 
> Anyway, that was 2022, so it doesn't answer "why is this only showing up
> now and only for fuse?"  But maybe replacing the preempt-disable with
> irq-disable in fprop_new_period() is the right solution, regardless.

So I don't have a great explanation why it is showing up only now and only
for FUSE. It seems the fprop code is unsafe wrt interrupts because
fprop_new_period() grabs

        write_seqcount_begin(&p->sequence);

and if IO completion interrupt on this CPU comes while p->sequence is odd,
the call to

	read_seqcount_begin(&p->sequence);

in __folio_end_writeback() -> __wb_writeout_add() -> wb_domain_writeout_add()
-> __fprop_add_percpu_max() -> fprop_fraction_percpu() will loop
indefinitely. *However* this isn't in fact possible because
fprop_new_period() is only called from a timer code and thus in softirq
context and thus IO completion softirq cannot really preempt it.

But for the same reason I don't think what lockdep complains about is
really possible because xa_lock gets only used from IO completion softirq as
well. Or can we really acquire it from some hard irq context? Based on
lockdep report at least lockdep things IO completion runs in hardirq
context but then I don't see why we're not seeing complaints like this all
the time and even deadlocks I've described above. I guess I'll have to do
some experimentation to refresh how these things behave these days...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

