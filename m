Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D529B108B8EE
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250F26B0005; Fri, 20 Mar 2026 07:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB2F6B0088; Fri, 20 Mar 2026 07:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B7A6B0089; Fri, 20 Mar 2026 07:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E581A6B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:00:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A2831B6BB2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:00:02 +0000 (UTC)
X-FDA: 84566146644.11.7FC77D3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 13DA3180008
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:59:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=d7Qrpcxr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hI6hkbaW;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=d7Qrpcxr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hI6hkbaW;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774004400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DaDVasuYUvXpMMcTsAUgA6Ek0nz8rzypmB3rWztAYds=;
	b=CGy6LkEg535aJ+lm1sG7b0JxQdPjRa3dx1b2+Qg42qSY/qZnMVH8MdbOghFHLTNQj0BRiF
	vT44tWI6lDWu8cFoiIgKpmxIWLy9IF9FiPkebEy2rAxvW7lRPibO0afqousQiSYnM9lm2p
	Opi7JorbExI1ePjgsbv3Ko6kzgFYdNU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=d7Qrpcxr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hI6hkbaW;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=d7Qrpcxr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hI6hkbaW;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774004400; a=rsa-sha256;
	cv=none;
	b=Lkd87MzpgwAgHuTw3URmrBB/vFBS4MkgZt4KZTJtD5xSu00s8CQ9gAypN+PirvYUvYu1f0
	xfBqCTjzUR85Hw6srER0U2Qhqytx2jAUJg5wZmdqvXuj5BDqRUVEGkKZl6NQqPWx8xQ64J
	LKN+rb/aX9gZJTchJHp532ehjxk5h4M=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 51AF45BCF1;
	Fri, 20 Mar 2026 10:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774004398; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DaDVasuYUvXpMMcTsAUgA6Ek0nz8rzypmB3rWztAYds=;
	b=d7QrpcxrjSC3b31gNyXyPn5e3bgOqn+GsuyNdl0cWeYnku2UcxFE8lOWrwZW6NR4xiEiHS
	Y2x8igwmgzkWdRHhXN+9A7ht51R1WNqhJRQgSy9m8HygaKckYJyl4O8B3+pt8ibWyYN1WK
	ON5NwC6+g8oz3rF1EFZ5+DClmvB5bQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774004398;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DaDVasuYUvXpMMcTsAUgA6Ek0nz8rzypmB3rWztAYds=;
	b=hI6hkbaWErEX4na1gf1WCeCd78P06uAwdw6hERW72UE/THyeCtBYwPpBO7qbn4ETRnKPsA
	XxpH07HD5x+PhlDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774004398; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DaDVasuYUvXpMMcTsAUgA6Ek0nz8rzypmB3rWztAYds=;
	b=d7QrpcxrjSC3b31gNyXyPn5e3bgOqn+GsuyNdl0cWeYnku2UcxFE8lOWrwZW6NR4xiEiHS
	Y2x8igwmgzkWdRHhXN+9A7ht51R1WNqhJRQgSy9m8HygaKckYJyl4O8B3+pt8ibWyYN1WK
	ON5NwC6+g8oz3rF1EFZ5+DClmvB5bQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774004398;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DaDVasuYUvXpMMcTsAUgA6Ek0nz8rzypmB3rWztAYds=;
	b=hI6hkbaWErEX4na1gf1WCeCd78P06uAwdw6hERW72UE/THyeCtBYwPpBO7qbn4ETRnKPsA
	XxpH07HD5x+PhlDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79F454274F;
	Fri, 20 Mar 2026 10:59:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AKZoGq0ovWlpXwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 20 Mar 2026 10:59:57 +0000
Date: Fri, 20 Mar 2026 10:59:55 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>, 
	Luke Yang <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/mprotect: un-inline folio_pte_batch_flags()
Message-ID: <tv6pcikk456ynfx7lz3lrql3yafg4njuy3bzi4v6yi5hpe27gi@hakvdy2jmewu>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-4-pfalcato@suse.de>
 <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
 <69382383-5f08-408f-8c13-d674e82c4dfd@kernel.org>
 <fcc2665f-014b-490f-8451-ca907730e60c@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcc2665f-014b-490f-8451-ca907730e60c@lucifer.local>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 13DA3180008
X-Stat-Signature: yc5y5eebsn89ybhfxezbqbo9j578nxbo
X-Rspam-User: 
X-HE-Tag: 1774004399-861454
X-HE-Meta: U2FsdGVkX1+W5TMMqdSJpDTn7B52bZdZ7jWjQAr9aHFkFkun2V5GD8dWh83TR4VPDX6hoPIMUQN4zjBPSsdlfIgtp0hdzi94weO2CeHrGFy45RHbaAknzOfcxSUOkEblNLJNmpMu2Tc8Gy1vpxiGwSoCdDpJHa19fUs67Ycii1bNKWt8H6wt86C/rtMhs2vmLEff+S6ISiqEFFh60aDzWFnYzXxk9P/xAiSLjh2Ad/9GgO5xE8rL/PZheZiRjQe+jrFhrOm5Fw/f1prCgwmU1Y6gp8XjpSwKNl2wBcy1PnPb2ONf4PiQ//cs/A1QzAniKNaJobfqYVt7ffudY2Itp6zHXu5JPtA0GOHDJ/I47rXTZ9I861PFPnhdYZfA+UfUGwSfbmaFhpa5wEuxlkNEjZFkk7IU/pJZAFTUdi4llvsre3HLEA4ggmGL0lt9fptMSqxECNp19XWrtZ6Xrdplwn/gE9szn5hb9fvB6ukvM6N9x+1U8SpBi74uL7WRfSDcYaY0iBRtZEfoHwMK1z1NEcFpOQxso/xhqI3C9CapMAWU/G/4GtwjfjkQbOMpslUERJasA0Z0+bKniYFQBxeBScDVZ3uXRChYCmZgK0eD5YuZ6pGXomY+etsW7Rsjzv8kaAXula42lSTrMfodAPVafnY5tOP+HubmvSRWPe/UuM3EEk3qtd8x8SILDNhK/lRPS6x8XGWdraaDJs0iBm+rAOGZsbUXQu2ZOZAzsxRvJRALGMHOMcyRztfSaAi0rbQlwAN2+xe+zimyHJpTIf9B29QH9qWYAp+RplTPe88XV8+vX/loA7x+6cG8gvKdshxoewO5UUIAMsXIomxb7Esmq1OxF/D4Att8h3y5ofbsZmoaMgguIkEkCN/qxqTNzGnktFowUbF9TaweKxalVBCfxquyeUX0qLOmmAGRHIXV+LGwarTkosVfvRwomA/++iB5XDgdjB3KIaPaK+QFp3L
 abjCnqv9
 pyuNoVImtYHlmaWcv7u9xpvnYNRRtFg3+eGAgHvgklF2yeOt0tZoa9ObANiSwKygC1wsxASv/pnKxL31gTTOaVwTFePG7S3LDUQm/rlECs951DJvDADHQG9AQ7SsHHLQLcaA8JiL5M1NvsK2Z9fjFuC9lB7o7vS/M/zzqx1q/3u/d2YzfaAGBMLOta7g3dZO7kF4KDBFJO7EWP9VzwwsjYW1hIBXgt3DzsvRk0CoBiP2WnmsFCcDaMFzySz3U84GXKTZ4ywRJZ0OEyLLI+XQi3kkhNTcZVZQ3SrDWlNq3sJQpk8d4OVugMOjpODMow2BxQMatmqkdw2bh+Vs914f43VQ47Ri//mgBI/jw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 10:36:59AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 10:41:54PM +0100, David Hildenbrand (Arm) wrote:
> >
> > >
> > > This is all seems VERY delicate, and subject to somebody else coming along and
> > > breaking it/causing some of these noinline/__always_inline invocations to make
> > > things far worse.
> > >
> > > I also reserve the right to seriously rework this pile of crap software.
> > >
> > > I'd rather we try to find less fragile ways to optimise!
> > >
> > > Maybe there's some steps that are bigger wins than others?
> >
> > What we can do is, collect similar folio_pte_batch_*() variants and
> > centralize them in mm/utils.c.
> 
> I'm not sure that addresses any of the comments above?
> 
> Putting logic specific to components of mm away from where those components
> are and into mm/util.c seems like a complete regression in terms of
> fragility and code separation.
> 
> And for what reason would you want to do that? To force a noinline of an
> inline and people 'just have to know' that's why you randomly separated the
> two?
> 
> Doesn't sound appealing overall.
> 
> I'd rather we find a way to implement the batching such that it doesn't
> exhibit bad inlining decisions in the first place.

Yes, you make a good point. At the end of the day (taking change_protection()
as the example at hand here), after these changes:
change_protection()
 loop over p4ds
   loop over puds
     loop over pmds
       loop over ptes
         nr_ptes = loop over ptes and find out how many we have
         if (making write) {
           loop over nr_ptes
              loop over ptes and find out how many are anonexclusive or not, in a row
              loop over ptes and set them
         } else {
	      loop over ptes and set them
         }

which the compiler FWIW tries to inline it all into one function, but then
does a poor job at figuring things out. And the CPU gets confused too. It
was frankly shocking how much performance I could squeeze out of a

if (nr_ptes == 1) {
	/* don't bother with the loops and the funny logic */
}

I would not be surprised if the other syscalls have similar problems.

> 
> I mean mprotect_folio_batch() having !folio, !folio_test_large() checks
> only there is already silly, we should have a _general_ function that does
> optimisations like that.
> 
> Isn't the issue rather than folio_pte_batch_flags() shouldn't be an inline
> function in internal.h but rather a function in mm/util.c?
> 
> >
> > For
> >
> > 	nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte,
> > 					   max_nr_ptes, /* flags = */ 0)
> >
> > We might just be able to use folio_pte_batch()?
> 
> Yup.
> 
> >
> > For the other variant (soft-dirt+write) we'd have to create a helper like
> >
> > 	folio_pte_batch_sd_w() [better name suggestion welcome]
> >
> > That will reduce the code footprint overall I guess.
> 
> I mean yeah that's a terrible name so obviously it'd have to be something
> better.
> 
> But again, this seems pretty stupid, now we're writing a bunch of duplicate
> per-case code to force noinline because we made the central function inline
> no?

Yeah.

> 
> That's also super fragile, because an engineer might later decide that
> pattern is horrible and fix it, and we regress this.
> 
> But I mean overall, is the perf here really all that important? Are people
> really that dependent on mprotect() et al. performing brilliantly fast?

Obviously no one truly depends on mprotect, but I believe in fast primitives :)

> Couldn't we do this with any mm interface and end up making efforts that
> degrade code quality, increase fragility for dubious benefit?

Yes, which is why I don't want to degrade code quality :) It would be ideal to
find something that works both ways. Per my description of the existing code
above, you can tell that it's neither fast, nor beautiful :p

-- 
Pedro

