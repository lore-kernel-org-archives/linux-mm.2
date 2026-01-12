Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F423CF45B0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71C56B0088; Mon, 12 Jan 2026 12:20:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11A46B0089; Mon, 12 Jan 2026 12:20:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44E56B008C; Mon, 12 Jan 2026 12:20:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B57CC6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:20:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81AD1140767
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:20:40 +0000 (UTC)
X-FDA: 84323976240.25.5764838
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 02255140012
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:20:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Wtin3mX0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tMZ0cW9H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Wtin3mX0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tMZ0cW9H;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768238438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1PoHnkFvFVa85D90IbSeAH892zq7+97wrja4nCJtn2k=;
	b=zrQTUrGfcof6EG7uHNtNbqzS/Qvij3XX/l21qKSUznVFUe9Jhwidsb2x3xuTQsmqxtiu72
	R31KO3bo+j5iRJ7LhCRyHe1b8NjTvlhAzx/cjD1lFdtyhe3JrQ8UoSrkp1cZgdYfFQ60dd
	R7WmOTJx1gzFGMKQ3HbJbRFztgRXcJQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Wtin3mX0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tMZ0cW9H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Wtin3mX0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tMZ0cW9H;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768238438; a=rsa-sha256;
	cv=none;
	b=pbfp0A3BvJRQt1Dod4IdTeOfPuUzarmpXr6s5OFnZ69sM6Y/u8XAVusLgeWuYo/RV2w1Sb
	QjmGGpdpW/jYQgJt+4s62TZXGoz0UQzW7fr5Os+OQwz5WPqlkNxKckdCxmkTK/pV0m9qPa
	15vGpiQq5k4F2LfeXmQB8rl2tv02Rzk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4044D3368F;
	Mon, 12 Jan 2026 17:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768238436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1PoHnkFvFVa85D90IbSeAH892zq7+97wrja4nCJtn2k=;
	b=Wtin3mX0Ev7yYdelfKhLUxmjbtFSl4hsIDm6uQ4DYV50Q+w55Em/pEngJOOOW8VKj0kxox
	tQzY0RYwWga+TJ4cn/TGBNGosX9Hhw1cRHrK4mRrTg//BNGD7H96ngce+vljJUCg2oqu6D
	sXAt5D814qFW8Kc+f/4rZCI6E4E4PBQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768238436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1PoHnkFvFVa85D90IbSeAH892zq7+97wrja4nCJtn2k=;
	b=tMZ0cW9HguNUeOf9mQzFGesnecprQvYJ3p20DA2XZO039FzTR18IwSNT4oiw+Tea9P28jY
	UWMDmJuNHhSlzEBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768238436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1PoHnkFvFVa85D90IbSeAH892zq7+97wrja4nCJtn2k=;
	b=Wtin3mX0Ev7yYdelfKhLUxmjbtFSl4hsIDm6uQ4DYV50Q+w55Em/pEngJOOOW8VKj0kxox
	tQzY0RYwWga+TJ4cn/TGBNGosX9Hhw1cRHrK4mRrTg//BNGD7H96ngce+vljJUCg2oqu6D
	sXAt5D814qFW8Kc+f/4rZCI6E4E4PBQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768238436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1PoHnkFvFVa85D90IbSeAH892zq7+97wrja4nCJtn2k=;
	b=tMZ0cW9HguNUeOf9mQzFGesnecprQvYJ3p20DA2XZO039FzTR18IwSNT4oiw+Tea9P28jY
	UWMDmJuNHhSlzEBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 302053EA63;
	Mon, 12 Jan 2026 17:20:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AGW4C2QtZWkwEQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Jan 2026 17:20:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D774AA09FC; Mon, 12 Jan 2026 18:20:35 +0100 (CET)
Date: Mon, 12 Jan 2026 18:20:35 +0100
From: Jan Kara <jack@suse.cz>
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Joanne Koong <joannelkoong@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Horst Birthelmer <hbirthelmer@ddn.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: __folio_end_writeback() lockdep issue
Message-ID: <yovlpjhao5gymqcdmg25w5tqxq4gduq3ccbrnsx4nssp4v2xs5@bflx5zxxb5l3>
References: <9b845a47-9aee-43dd-99bc-1a82bea00442@bsbernd.com>
 <b7b72183-f9e1-4e58-b40f-45a267cc6831@bsbernd.com>
 <aWJ-pHIY8Y8sjLeC@casper.infradead.org>
 <wu7mu22kgr7pmzrneq6rkivhwvpbximyrkouciktl7wf5w7wur@rsyqyczopba2>
 <fc67afac-2345-43bf-a67e-c36f2d9f04c3@bsbernd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc67afac-2345-43bf-a67e-c36f2d9f04c3@bsbernd.com>
X-Rspamd-Queue-Id: 02255140012
X-Stat-Signature: oxzstebjheo8jouc1kg5wddn41fubu5x
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768238437-378724
X-HE-Meta: U2FsdGVkX1/4J6O8rmfWPCfFx939XdbP1wqCw2ik9LZkBNp9Y8ZlGIQ3A2rZjEB9hVbvqwGuVM0R3XpJSJlLWKqZ4nBoy1CtaNERBm60gEyrajwnvqDnoFwl7haDlygmIUesRgw+6rjA7ECWkYIQMCvY5STdV4FcLlY4RtzVZv3zAU8Rkbxxn0z93Tyi7cRxNsGiIRz0SZhNqa57D43sS1yE3C4iUIw37r8Zu4/NdHWa+7tqF+xLbLre9YCd2D1mluq2LMLmW5CpRr37RIcD6d7NzavrcMdPeWLnrMQ48u9bWOLT7MM8lXEIc32FDVdBValgzebyj8kBwzRlRY6dq8MNCvvgTNeQaZ1YGXri2xXm9wQUpa4Z7T/YDkLdpiPHAclLauNd0SOA2TyM/wTGueb6YkPpkOmofz6MBdqxfjTvXi2iRGjIDla2HIiEGi1m69hVcAjOvWU8y08ksmQOavH7sn9DdxIBbTIlR7phpgoFBqO4ncevUjwUjLe+ck0dM8iDsuT04JrK6/NjbawvTR+rIKEpbxXO1VlWDMgRoL49rQy5lkQBFI5GV2vdmRM2nkNxQ7Irudmi7tpwc8wiP9qARYsqujHX+2jB6q4/V54qB+UE3N+wrohdxN5qvMSmEj93fpcw9j/tjeQopYuVrzvyYF8Typr2y0Mmuzugvk9b/m+M2KcGXLdYW9BVgWZg4JCyVNBlZH4m71pH3MdS44wSLl7zVCiicpYgsxDNeM9keCBAkMpBbZbdnjAecqQVEKQcmc5oGnoqtNsHlqP8HqzJl71fyGODZRmLUllH7dH9OguDTLkwmvy/h/vQG+srCR+W4QuvYJJ+DX9gYLkm1NH8G6ejzXwDvlnMyXhKplcqEkVJgOBWjknqvUhYgZv7nMw458F2YhoksEZRqI/RE4RyTTsg5g2ytk5N5MHdbgcg74pKCcUAGafBilc6NIYpfn3wAj7dDmBW9zwEs9+
 wyfH3JNL
 CMW/G/0V8q3A7x43oh+RhvW+3HEhvfD64e/bag1pA2yduGzkfvbrsxWbTLuzxic09RdZ/XreEV8iD7Foo7F5sDV3sEwE00LHTd2XXcpsIDuubfkHtqwMULXZKvfCEFUh35m7xfGNDQxetN3d1sAC0SKieTUOM1pVfl3w3W6krDdxEUGzGJWCSqzhIQMpwsJKDhkWxFKIuYCxQSxoMU8qdDuaYC+M1XAK70mtaLs3IUNPoSKMBztdGb1+V8JXF4T0iZwAdy6Gi0U876yHPFcX6Dpz5bbcRsF5QYY4P2PgfHDoIguKaD5T+KVESKKLFu4K/toqAUNptgGsAqTlZOeUpzUiGQ29h/EMdumLoaNMueZXI9T1GTXRoELLt5r0MugN4AuuFwJKPPgJ4PgbwyTMd5SAxv4I5782lkc5hSyHdsfuELx8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 12-01-26 14:13:26, Bernd Schubert wrote:
> 
> 
> On 1/12/26 14:06, Jan Kara wrote:
> > On Sat 10-01-26 16:30:28, Matthew Wilcox wrote:
> >> On Sat, Jan 10, 2026 at 04:31:28PM +0100, Bernd Schubert wrote:
> >>> [  872.499480]  Possible interrupt unsafe locking scenario:
> >>> [  872.499480] 
> >>> [  872.500326]        CPU0                    CPU1
> >>> [  872.500906]        ----                    ----
> >>> [  872.501464]   lock(&p->sequence);
> >>> [  872.501923]                                local_irq_disable();
> >>> [  872.502615]                                lock(&xa->xa_lock#4);
> >>> [  872.503327]                                lock(&p->sequence);
> >>> [  872.504116]   <Interrupt>
> >>> [  872.504513]     lock(&xa->xa_lock#4);
> >>>
> >>>
> >>> Which is introduced by commit 2841808f35ee for all file systems. 
> >>> The should be rather generic - I shouldn't be the only one seeing
> >>> it?
> >>
> >> Oh wow, 2841808f35ee has a very confusing commit message.  It implies
> >> that _no_ filesystem uses BDI_CAP_WRITEBACK_ACCT, but what it really
> >> means is that no filesystem now _clears_ BDI_CAP_WRITEBACK_ACCT, so
> >> all filesystems do use this code path and therefore the flag can be
> >> removed.  And that matches the code change.
> >>
> >> So you should be able to reproduce this problem with commit 494d2f508883
> >> as well?
> >>
> >> That tells me that this is something fuse-specific.  Other filesystems
> >> aren't seeing this.  Wonder why ...
> >>
> >> __wb_writeout_add() or its predecessor __wb_writeout_inc() have been in
> >> that spot since 2015 or earlier.  
> >>
> >> The sequence lock itself is taken inside fprop_new_period() called from
> >> writeout_period() which has been there since 2012, so that's not it.
> >>
> >> Looking at fprop_new_period() is more interesting.  Commit a91befde3503
> >> removed an earlier call to local_irq_save().  It was then replaced with
> >> preempt_disable() in 9458e0a78c45 but maybe removing it was just
> >> erroneous?
> >>
> >> Anyway, that was 2022, so it doesn't answer "why is this only showing up
> >> now and only for fuse?"  But maybe replacing the preempt-disable with
> >> irq-disable in fprop_new_period() is the right solution, regardless.
> > 
> > So I don't have a great explanation why it is showing up only now and only
> > for FUSE. It seems the fprop code is unsafe wrt interrupts because
> > fprop_new_period() grabs
> > 
> >         write_seqcount_begin(&p->sequence);
> > 
> > and if IO completion interrupt on this CPU comes while p->sequence is odd,
> > the call to
> > 
> > 	read_seqcount_begin(&p->sequence);
> > 
> > in __folio_end_writeback() -> __wb_writeout_add() -> wb_domain_writeout_add()
> > -> __fprop_add_percpu_max() -> fprop_fraction_percpu() will loop
> > indefinitely. *However* this isn't in fact possible because
> > fprop_new_period() is only called from a timer code and thus in softirq
> > context and thus IO completion softirq cannot really preempt it.
> > 
> > But for the same reason I don't think what lockdep complains about is
> > really possible because xa_lock gets only used from IO completion softirq as
> > well. Or can we really acquire it from some hard irq context? Based on
> > lockdep report at least lockdep things IO completion runs in hardirq
> > context but then I don't see why we're not seeing complaints like this all
> > the time and even deadlocks I've described above. I guess I'll have to do
> > some experimentation to refresh how these things behave these days...
> 
> Is there anything that speaks about the patch I had posted?
> __wb_writeout_add() doesn't need the xa lock?

That's a bit hairy question :) because currently xa lock is what makes sure
the wb we've got from the inode is still valid. Now that you've forced me
to think about it: If we move __wb_writeout_add() from under xa lock, inode
could be switched to different wb after we release xa lock and before we
call __wb_writeout_add(). I don't think there is anything that would
protect the wb from being freed in that case before __wb_writeout_add() and
thus we could create UAF issue if I'm not mistaken.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

