Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F73D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 14:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A976B0425; Tue, 20 Jan 2026 09:35:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E256B0426; Tue, 20 Jan 2026 09:35:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A066B0427; Tue, 20 Jan 2026 09:35:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3F176B0425
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:35:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A33C598BF
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:35:42 +0000 (UTC)
X-FDA: 84352590924.01.7E1F2D0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2C09C180004
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:35:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fzTmFh6U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0uyNt8Te;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fzTmFh6U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0uyNt8Te;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768919740; a=rsa-sha256;
	cv=none;
	b=8oig8lRG1sa6dgto+1yRe1dYON8PtsxQZIpW8EqbK5wbHZMHGqaKVMOR57Giil+GoV6Nmu
	brcrycdniHHUBxI5AL7lGXWMxRmSAK134oaWQh6ep/z4QC5R4oEQI80kDEqXGQ6LziXFd9
	/QSbHdxTYkTIkD7tMBIEDHgE+NJzmS0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fzTmFh6U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0uyNt8Te;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fzTmFh6U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0uyNt8Te;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768919740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dr07aLXDVCjM7i/UybL6ay/mRo+PckVKNWM0IK2ZlRk=;
	b=OIKWecuIEOhCpEpZKGtKN6CjBgANgWlxfDI+9AQaXhi6h6MgSUkHzWMAp+hhRawrVb3rTg
	G/bPL9tAabooZSf/mIKCf/7ClCZ0Rv8I+i43LJwEoqlk5PECkcJJoLm9ys1t0kvk39+jzI
	/pW9pQOUKOFwN2e+YHqyo769AmOIGn4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6708A5BCCD;
	Tue, 20 Jan 2026 14:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768919738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dr07aLXDVCjM7i/UybL6ay/mRo+PckVKNWM0IK2ZlRk=;
	b=fzTmFh6UPmm1R2MPTU/2h5WoDP5GcRIbztOJ37Wf0G2Ho7SS5T6lRdqZkFyQmcxULesV4C
	dytHCyddQBpjDhgRwUhhD4N0WRbT2zJlEhSN5tgbUbt/wVfejG1RjB1bvc0duo7t/o8JBO
	pJwPb8f1ZVR9gajrVhGnvBk46JEwxlk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768919738;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dr07aLXDVCjM7i/UybL6ay/mRo+PckVKNWM0IK2ZlRk=;
	b=0uyNt8Tewmtk1dT9/EczhE/wUA5iTwOeidApiLlYykzMTfAVxyEXD2CR4kG8tH62pZ5353
	iL/Jig2ZSyQATfAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768919738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dr07aLXDVCjM7i/UybL6ay/mRo+PckVKNWM0IK2ZlRk=;
	b=fzTmFh6UPmm1R2MPTU/2h5WoDP5GcRIbztOJ37Wf0G2Ho7SS5T6lRdqZkFyQmcxULesV4C
	dytHCyddQBpjDhgRwUhhD4N0WRbT2zJlEhSN5tgbUbt/wVfejG1RjB1bvc0duo7t/o8JBO
	pJwPb8f1ZVR9gajrVhGnvBk46JEwxlk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768919738;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dr07aLXDVCjM7i/UybL6ay/mRo+PckVKNWM0IK2ZlRk=;
	b=0uyNt8Tewmtk1dT9/EczhE/wUA5iTwOeidApiLlYykzMTfAVxyEXD2CR4kG8tH62pZ5353
	iL/Jig2ZSyQATfAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BEEF13EA63;
	Tue, 20 Jan 2026 14:35:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 79qaLrmSb2mcZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 20 Jan 2026 14:35:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 68DD6A09DA; Tue, 20 Jan 2026 15:35:33 +0100 (CET)
Date: Tue, 20 Jan 2026 15:35:33 +0100
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Bernd Schubert <bernd@bsbernd.com>, Jan Kara <jack@suse.cz>, 
	Joanne Koong <joannelkoong@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Horst Birthelmer <hbirthelmer@ddn.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: __folio_end_writeback() lockdep issue
Message-ID: <4sn6k56c7g3jwvzze4imc4pilmomekvcelo7zo2awjqxsifaqe@djs5p2l55q64>
References: <9b845a47-9aee-43dd-99bc-1a82bea00442@bsbernd.com>
 <b7b72183-f9e1-4e58-b40f-45a267cc6831@bsbernd.com>
 <aWJ-pHIY8Y8sjLeC@casper.infradead.org>
 <wu7mu22kgr7pmzrneq6rkivhwvpbximyrkouciktl7wf5w7wur@rsyqyczopba2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wu7mu22kgr7pmzrneq6rkivhwvpbximyrkouciktl7wf5w7wur@rsyqyczopba2>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2C09C180004
X-Stat-Signature: byspdt3pss67kf8tyjze15n4stjrt5c8
X-Rspam-User: 
X-HE-Tag: 1768919739-904075
X-HE-Meta: U2FsdGVkX1/S2+ae1zzXn9+Dn650pqhshwO4Lp9eb6oOInVwZ6VPZoSCFscBRLUFs0lSTzq2WOrm6lj5YJ/fYjl/KCls+xIvtqJcjle5H9fTeT3EFajeQgDoJM6a5GF1bJYmUatIjdY+/IhnLcE34LW9gFKxN7T8lJEI1nl3ZCIlxpZ4n2KBXcKMGTaSccaQJ+d8yJl4b3R9AOje1qXfk8a9MtOrENibZd/9puYHMwKEn9ZBncYySQP0dbx6/K0bMRC1U9b6f30pG/axMtuZjrhwmHWlL1ycQRn13Jm6bha6RsbRFLCFV9BiqWRV6Yxf5BZmtGUwZEN9FEh9a1kFNF1DBwA3WUyQrAdXuzZ92na9RH/l27W2Rq2sFyaMuCo1+SkILtlPJoe11KN7ETuW+o71r2e+D3FPH8FgPJkN7iRmbssGzD8b/kT5ViFaMJu6fV71/0whdjDutc2RHG67p5PCpfyjKAA1AgL5/3BzK4zm7ABGGbDEz1ZIHwtql2jpkbUb7byAeWBNrNrRKFFYNoN2mWGTNkO7XbTC/Au9nDsM7JdU57rM+iKaQ9dBuL0/AWE0xJnD8p7al99yimgnc4aAMEwNGh7fWBDZsSW5z0wJG//7p9pRSJo25OLA90AP7FyWnAYesIykc9HEKTMcYTPkCqZJa9tVJ89aCIjsKOF4tgKQiVZMvaAKqlNzXnFcGwlI2+QwbRsp7aXk7+tsY7djnC31cvTEKkiKlUAn+F189539Sg3biScdPRXIUGHHFqiIi0hxm2FjBXg6a38CiD3OQIQIWKkL9Vavxr6W0omU1hUBu83lhfzb8VWUZdopR8iJ6wwpzPO8B4S0+fhDAmXBD4Rs+B7mPrULQy8Y7Jq/wLdRGlKgfy4NwwsaAKuETKqTeKIgiunLEsXnXBY7q2ONje0diYD/FqfF4Q024oiP8b2a98yFGCjaF2NOakWXi8fvhZL3Cq8KrkDqXPF
 zRznAfv3
 S34vd/d/tfXjj/eMPZ1rC+FPr/kTn93xRTEvGlqiyosRdUz+GuEBCFaJyjolNPYV637saaI+lAADLfG/HhjxTftbKhY1OFyrV4O/0bTV98VYIuM2vqlgBnceLPjNR2hC1+foG1gddrcZLPwiydvQeY53yHWgO3MbGeNh54FSGBGEmsXTKRnXkiDy5ZrTrS2AU7KAPYhtVASUOSvzAhCdRD8slB1GO/R1hTeZ4ou1R+ALWc7v0Fueb0/nBso2cYoSVHNgwvjOaEfXc1/gUhXyVMf1PMV962CECxERQCpaVlN4rJmvaG+sEAkzcACwkxySRA6cUXJeDxy7Jc7o93DCA0GuBjv2Rmh1vYe2nSv0bGArrQTkWsWOiVHErLoGD78R/YCMk0TzdsYGR/Tq237cmxebjr6aP1o4CCVfw+T/zu2H1ymA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 12-01-26 14:06:26, Jan Kara wrote:
> On Sat 10-01-26 16:30:28, Matthew Wilcox wrote:
> > On Sat, Jan 10, 2026 at 04:31:28PM +0100, Bernd Schubert wrote:
> > > [  872.499480]  Possible interrupt unsafe locking scenario:
> > > [  872.499480] 
> > > [  872.500326]        CPU0                    CPU1
> > > [  872.500906]        ----                    ----
> > > [  872.501464]   lock(&p->sequence);
> > > [  872.501923]                                local_irq_disable();
> > > [  872.502615]                                lock(&xa->xa_lock#4);
> > > [  872.503327]                                lock(&p->sequence);
> > > [  872.504116]   <Interrupt>
> > > [  872.504513]     lock(&xa->xa_lock#4);
> > > 
> > > 
> > > Which is introduced by commit 2841808f35ee for all file systems. 
> > > The should be rather generic - I shouldn't be the only one seeing
> > > it?
> > 
> > Oh wow, 2841808f35ee has a very confusing commit message.  It implies
> > that _no_ filesystem uses BDI_CAP_WRITEBACK_ACCT, but what it really
> > means is that no filesystem now _clears_ BDI_CAP_WRITEBACK_ACCT, so
> > all filesystems do use this code path and therefore the flag can be
> > removed.  And that matches the code change.
> > 
> > So you should be able to reproduce this problem with commit 494d2f508883
> > as well?
> > 
> > That tells me that this is something fuse-specific.  Other filesystems
> > aren't seeing this.  Wonder why ...
> > 
> > __wb_writeout_add() or its predecessor __wb_writeout_inc() have been in
> > that spot since 2015 or earlier.  
> > 
> > The sequence lock itself is taken inside fprop_new_period() called from
> > writeout_period() which has been there since 2012, so that's not it.
> > 
> > Looking at fprop_new_period() is more interesting.  Commit a91befde3503
> > removed an earlier call to local_irq_save().  It was then replaced with
> > preempt_disable() in 9458e0a78c45 but maybe removing it was just
> > erroneous?
> > 
> > Anyway, that was 2022, so it doesn't answer "why is this only showing up
> > now and only for fuse?"  But maybe replacing the preempt-disable with
> > irq-disable in fprop_new_period() is the right solution, regardless.
> 
> So I don't have a great explanation why it is showing up only now and only
> for FUSE. It seems the fprop code is unsafe wrt interrupts because
> fprop_new_period() grabs
> 
>         write_seqcount_begin(&p->sequence);
> 
> and if IO completion interrupt on this CPU comes while p->sequence is odd,
> the call to
> 
> 	read_seqcount_begin(&p->sequence);
> 
> in __folio_end_writeback() -> __wb_writeout_add() -> wb_domain_writeout_add()
> -> __fprop_add_percpu_max() -> fprop_fraction_percpu() will loop
> indefinitely. *However* this isn't in fact possible because
> fprop_new_period() is only called from a timer code and thus in softirq
> context and thus IO completion softirq cannot really preempt it.
> 
> But for the same reason I don't think what lockdep complains about is
> really possible because xa_lock gets only used from IO completion softirq as
> well. Or can we really acquire it from some hard irq context? Based on
> lockdep report at least lockdep things IO completion runs in hardirq
> context but then I don't see why we're not seeing complaints like this all
> the time and even deadlocks I've described above. I guess I'll have to do
> some experimentation to refresh how these things behave these days...

So I've got to experiment with this some more. It appears that my
recollection of block layer IO completion code is about decade old and
these days bio completion routines (and thus __folio_end_writeback()) are
getting called in hardirq context in most cases (verified this with ftrace).
Hence the flexible proportions code is indeed prone to deadlocks with
hardirqs. I'm just wondering why aren't we seeing much more lockdep reports
about this and possibly also real deadlocks... Anyway, I'll send a patch to
make fprop_new_period() irq safe.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

