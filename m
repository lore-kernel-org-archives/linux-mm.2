Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70479C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F146B00FB; Mon, 29 Jun 2026 14:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EFD06B00FC; Mon, 29 Jun 2026 14:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B85A6B00FD; Mon, 29 Jun 2026 14:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0021A6B00FB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:20:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C04E12022C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:20:15 +0000 (UTC)
X-FDA: 84933764790.22.0B1FA7A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 585C740009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:20:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VBx6Go9V;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=h4tlWpoq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U9PHprco;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Tb4wgHhX;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782757213;
	b=rVMO3vIa9Ed/lEshtOKp3dNW4XpEa88pHPReGlFzmDaP9QJO1Q2bpFwfDnnccKteYHaFNJ
	T2leNcwPIuvZbb93URkf7qw6hLdHzlr54wh+lKO4SFdsMhRbPHIKrU/61T6gUz+B3gxLNB
	Y6QgVSA6SfIE8hHj9HKbOxn0V4VnS5Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782757213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52IgFMOwkd7eriRsZwUPQpeZD1+MN1y/keLJNnBYVKw=;
	b=07aPtdzhv/yIIA0H3haa68EPpXs/Z3ViZfrhi84aZCBjEyg8YFCeW22FMKJI46s4vnStpV
	egmegRQU0cOOgQ7Tvzn8NBlpYgmTCeAI4MjcK3iEtO/b9Pf/dOPBtinNJQFUJLSHD3JzS4
	m/W67AjZokQU7X6PSMbxI6NghOmfZWA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VBx6Go9V;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=h4tlWpoq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U9PHprco;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Tb4wgHhX;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A759C758B1;
	Mon, 29 Jun 2026 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782757211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=52IgFMOwkd7eriRsZwUPQpeZD1+MN1y/keLJNnBYVKw=;
	b=VBx6Go9V4Z/2WdxoGsIajBgRyxGs51T2zdrn5kyeSY5D0lOoCvb4NQ/9p10HX0WDBcZUWA
	2U+RL9jpLs+WNgXV5v7nJneQeFFViOAB+4XLhlxflnOQwgv8Iv7QIUptrnabC/GHjkUXtu
	AchlE6MveWFQaV67x5iuJtqFrCZnSv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782757211;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=52IgFMOwkd7eriRsZwUPQpeZD1+MN1y/keLJNnBYVKw=;
	b=h4tlWpoqlaXYVfDSY/fzkzUFqLQ+rrMqs/isZ2iw4IMP7lEEVBV6kzORggOQwSRzXvvfvp
	6Gy3GKVLHMjLVkDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782757209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=52IgFMOwkd7eriRsZwUPQpeZD1+MN1y/keLJNnBYVKw=;
	b=U9PHprcoWiVDaHulvM/v56i2Hwpo+KEo4FNn1ptTMPBl5hGeeh3hUp5hUhsTcr3uE+EyPA
	q5moh5oZZFpigbqa8Vql5deANlGwuTrFlEukiGo5Mqawe18eVGo5Y9mAo1eOx1XakB4LUH
	n/okYa5mutt2kSH4pyJaDXMOAoZsquU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782757209;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=52IgFMOwkd7eriRsZwUPQpeZD1+MN1y/keLJNnBYVKw=;
	b=Tb4wgHhXz5ILT5wwi16vtUCYlEoySq02kFyYurCi8zZhDaVdIplCnIbFvdsDlvdRzB5TuA
	+q6vqj6Cse9mlODA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F0CF779A8;
	Mon, 29 Jun 2026 18:20:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q42DD1i3QmqFbQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 29 Jun 2026 18:20:08 +0000
Date: Mon, 29 Jun 2026 19:20:06 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Xuewen Wang <wangxuewen@kylinos.cn>, liam@infradead.org, 
	vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: annotate data-race in cpu_needs_drain()
Message-ID: <akK2lkm1k6IF49ut@pedro-suse.lan>
References: <20260626053700.2036899-1-wangxuewen@kylinos.cn>
 <04ea3e05-5b83-4c2d-8759-67c544a7b484@kernel.org>
 <akJHit8BV-hWRXYk@lucifer>
 <20260629093402.a4d14d4f95ccde7d4c804115@linux-foundation.org>
 <akKgikoi2dFKqmaG@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akKgikoi2dFKqmaG@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 585C740009
X-Stat-Signature: c1umoo91ie9qy46cwrp5w1oxc1bt3ku3
X-HE-Tag: 1782757213-876927
X-HE-Meta: U2FsdGVkX1+yrpGwfFSJDkJVJ7xFBCLRSjI2pc5di9UOfR0krEJUuJrKc4kvQMaqGrZ+jHwaBNuNqMRpPY0YDkPKwp3glzepl/Jh5tlGMeURegv8IEwXt4IwrB/VR736JiW6oMmPfL91hCengFXTDDtGTuIVLESnPrN+VDoRzP1vmyFgjyb8iuTpZIReNbHdi0je7VM7yQrqR7MtqqomJ2HFsdv6xN2nThpCskN9Kc34LTfUCRMOgmPLwHFxs5kOr1Nc/72AsB50EHWNWsjT+daxIyEvtEgnsDJ6D4nOAiOEBbLCebmqwdJIbcYwLUcokOUfPnPKSg3X+GBk+ys7T23CXxxs3ev8Ve2HYqvIbdpYpfg8/pZLXHBktn5gBNKPPcGZlO1l+8QhP/GNE0yFQ0M9qVH/p3lYzMnJ3Ez/F5uiJtlMmaeh3DomJeOWsFBEMelMLzP8mm1eJA7u2gDdQXIqw6bI5XRx8CdanwgTV1T2uHhO3eOJPlZS3cws8I/lI33nTPb9dRgKnyiedULUXc14qZ2rWMuxLFeiFxmPr3WsUNDE3Hac880E6jqehedCK3nke5g+MVX2RKTrBKZtL5gc0DVzSsPXHmno0rVXDur3Ft9VLVATwkz/vCQbcRg6xjfGIiqF52U8lFK0A29fx2ufiMV63beHsPdIws5z4+sQ5VmPCq1kVAynzyXv5LWRAi01w+6xZfHA8UsSNNsC3V0xqhaK5DNW75ed6P+ajLpvCJLUc3kTbBXIcr84xrbhkbez3MCG7eJcoLh3cqR3L8Kku6X3MGsT7J50VvqAClsKj+7iuvwTQvc9/4SpMOYeD8XeK7SGpIjE3t9MLKw+mOOcw9ij5DcDbWAwW0rBOvekVae2ZwcG7SkDWzRhbGVUUOqYn3tvtLHkRNYQEP6/bNoWeQwGYyzyifIrLkZ27M7KwJOxVhoO/JqVKUzt1XqSVxsXiBiiy8hHcDncHpM
 7AOdZqRU
 u0VCLSyqZdO0gnUjv1e3U22K0BdlqvDRQTsSNXH3PEr2xP4DxsjnwgpO5MC+lqzBTDkWdykG0Ya1bgTMMe4JFI9uTBEhtjA0cTFBUrYULoxeu1fb/y3OG1aldL/3DfRi2/f2/CzxPGmOZE3zCTuTdaJQ+XLIql6rMvnqK1FbTRzETbu6gTSQoqT1/wqPTITQPJtXjubg0Xljp1Tm0Zvggy5SZJXmACtVvXMxhbZAVg+krjYeewUgTVxTdLYlvE3SlhzgUisEZ8RoWhQj0LZqgpeOMnw+A4xGdvaExyrCJfvpAXKs3rNnRHe5xIZ6Jj1e/aycvJJf9eHkVUDiggBAYArrTEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 05:45:22PM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 29, 2026 at 09:34:02AM -0700, Andrew Morton wrote:
> > On Mon, 29 Jun 2026 11:23:26 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > > > >  		folio_batch_count(&fbatches->lru_lazyfree) ||
> > > > >  		folio_batch_count(&fbatches->lru_activate) ||
> > > > > -		need_mlock_drain(cpu) ||
> > > > > +		need_mlock_drain(cpu)) ||
> > > >
> > > > The indentation is a bit suboptimal now.
> > > >
> > > > Would read nicer as
> > > >
> > > > diff --git a/mm/swap.c b/mm/swap.c
> > > > index 588f50d8f1a8c..5958e6fdd3593 100644
> > > > --- a/mm/swap.c
> > > > +++ b/mm/swap.c
> > > > @@ -828,13 +828,13 @@ static bool cpu_needs_drain(unsigned int cpu)
> > > >         struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
> > > >
> > > >         /* Check these in order of likelihood that they're not zero */
> > > > -       return folio_batch_count(&fbatches->lru_add) ||
> > > > -               folio_batch_count(&fbatches->lru_move_tail) ||
> > > > -               folio_batch_count(&fbatches->lru_deactivate_file) ||
> > > > -               folio_batch_count(&fbatches->lru_deactivate) ||
> > > > -               folio_batch_count(&fbatches->lru_lazyfree) ||
> > > > -               folio_batch_count(&fbatches->lru_activate) ||
> > > > -               need_mlock_drain(cpu) ||
> > > > +       return data_race(folio_batch_count(&fbatches->lru_add) ||
> > > > +                        folio_batch_count(&fbatches->lru_move_tail) ||
> > > > +                        folio_batch_count(&fbatches->lru_deactivate_file) ||
> > > > +                        folio_batch_count(&fbatches->lru_deactivate) ||
> > > > +                        folio_batch_count(&fbatches->lru_lazyfree) ||
> > > > +                        folio_batch_count(&fbatches->lru_activate) ||
> > > > +                        need_mlock_drain(cpu)) ||
> > > >                 has_bh_in_lru(cpu, NULL);
> > >
> > > Yeah that works for me.
> > >
> > > Andrew - maybe easier if you fix that up? :)
> > >
> >
> > Sure.
> >
> > --- a/mm/swap.c~mm-annotate-data-race-in-cpu_needs_drain-fix
> > +++ a/mm/swap.c
> > @@ -832,12 +832,12 @@ static bool cpu_needs_drain(unsigned int
> >
> >  	/* Check these in order of likelihood that they're not zero */
> >  	return data_race(folio_batch_count(&fbatches->lru_add) ||
> > -		folio_batch_count(&fbatches->lru_move_tail) ||
> > -		folio_batch_count(&fbatches->lru_deactivate_file) ||
> > -		folio_batch_count(&fbatches->lru_deactivate) ||
> > -		folio_batch_count(&fbatches->lru_lazyfree) ||
> > -		folio_batch_count(&fbatches->lru_activate) ||
> > -		need_mlock_drain(cpu)) ||
> > +			 folio_batch_count(&fbatches->lru_move_tail) ||
> > +			 folio_batch_count(&fbatches->lru_deactivate_file) ||
> > +			 folio_batch_count(&fbatches->lru_deactivate) ||
> > +			 folio_batch_count(&fbatches->lru_lazyfree) ||
> > +			 folio_batch_count(&fbatches->lru_activate) ||
> > +			 need_mlock_drain(cpu)) ||
> >  		has_bh_in_lru(cpu, NULL);
> >  }
> >
> >
> > The removal of data_race() in need_mlock_drain() is a little worrisome
> > - perhaps any future callers would have needed it?
> >
> > need_mlock_drain() has only a single caller.  How about I remove it and
> > open-code it within cpu_needs_drain()?
> 
> That references a static per-CPU variable (mlock_fbatch) in mlock.c's
> compilation unit so I think it has to stay as it us unfortunately.
> 
> And it's better I think to only use the data_race() here where we definitely
> know we need it (and as the only instance of that).

I agree. FWIW something that would perhaps be nice to pull off would be:
lockdep_assert_held_or_data_race(), or something with a less excrutiating
name. Which could assert "either we hold a lock, or the caller is aware
that this can race". Which sounds nice. In that case, we could simply
slap that on need_mlock_drain() as requiring the mlock_fbatch's local lock,
or data_race().

It night be too special purpose though.

-- 
Pedro

