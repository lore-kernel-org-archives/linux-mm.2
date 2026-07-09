Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC5E9C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A565C6B00A5; Thu,  9 Jul 2026 11:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07136B00A7; Thu,  9 Jul 2026 11:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D4D6B00A9; Thu,  9 Jul 2026 11:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70E756B00A5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:01:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC6421C7F3D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:01:17 +0000 (UTC)
X-FDA: 84969551394.29.D01D1BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3CFFA40013
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:01:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mCclnew5;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783609276;
	b=KKfRsz/IcmplGJ/lcGhm57tZVuwumeSlbE1yXlRizZWqibClCXy/opmNOi57wiMmUHZH7U
	DFMFpyVdqeVJ+QLEiRFVdnTA2D6imVBQ8fvCIsuMDIc1rxz0dfktWmdwl0sQvzUx/ZFjiT
	+S8EPDq6ZutYlyk9lAaGSDJJdx7Nc58=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mCclnew5;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783609276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bs58MBJLx0dSPnNUhauIAU/NgeeIieNvdxeLqwZSYtM=;
	b=tT192oyc9uREExgz94hSUKkBF/x8Iw3g3b9e7kkDhjkColY7hq9b3N1ET0DIjoAbFYiqme
	skETfC76P3/VkpBF78+YSmE11Avq0z+QSr7wDtk0qKkAi5XpUKt4bK7FPsLXDP8fcGoCdj
	qfXJplR/v2BfO3Py8JyI2uEYXPIFZig=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2958940338;
	Thu,  9 Jul 2026 15:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440AF1F00A3A;
	Thu,  9 Jul 2026 15:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783609275;
	bh=bs58MBJLx0dSPnNUhauIAU/NgeeIieNvdxeLqwZSYtM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mCclnew5cVt0n37fGUUOr9gmU1Esl5X7tOEFvhzautMETbyXk8KpmxhNQm8vmKPZ5
	 6XiMWaT8Biz/cLcvM2s5XXBMQnwpqmRJghipz963jxTuyfGEcGt0wgnXt8rgVoh2+d
	 fHb+wlRnlRgtdgycUpXTEggEYCvDSu613ePaDgE6SYGnzUQ2QFcrWP1AmuLpWhwI6o
	 9bFlytaI212c9Wo30pIdQVtQDa/LNOgnc1B1DegVASnPEkUwHzsWmNP3QB5uYFzP3M
	 jsiCRfnMrK9HpwWrFvFjlxe2uKfdx5pKI6aJpXbkSDlKODymBAIVQSX75bx7V5lQkz
	 YTUeXC6mf9jkw==
Date: Thu, 9 Jul 2026 16:00:59 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Wandun <chenwandun1@gmail.com>
Cc: vbabka@kernel.org, david@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, Alexander.Krabler@kuka.com, hughd@google.com, fvdl@google.com, 
	bigeasy@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, akpm@linux-foundation.org, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, riel@surriel.com, liam@infradead.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	pfalcato@suse.de
Subject: Re: [PATCH v2 1/4] mm/migrate: do not migrate folios mapped into
 VM_LOCKED VMAs under compaction
Message-ID: <ak-2VAwNNuCD98Jv@lucifer>
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-2-chenwandun1@gmail.com>
 <akz7ythMxfIZeT0d@lucifer>
 <ak0EsCeucJarlI7G@lucifer>
 <f33a9dca-03d6-45f8-bd25-717b9033c75c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f33a9dca-03d6-45f8-bd25-717b9033c75c@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3CFFA40013
X-Stat-Signature: xxhjsfuen6ud6rhz889azum584198shn
X-HE-Tag: 1783609276-627837
X-HE-Meta: U2FsdGVkX1/Svc3/jHT84WT6A7fiQDZP41R633L9Bpkqa7/DR16e+uhDh8yTMIk+l3yZXc6ym0DMWnuHBwE+Vx/G60zufNgpxilkd+VCwN21IEmTINciRd/WrTp/A7Vzz2a+QjMX21BVA1iLDMLyk7ku/IY9vvoNZfkxidq2aZp8QLV37nUunCTo1e2PK/SvjeI7ncqkahzdJghNAiBnnTbkphABvW9tmS2vRavV7GIIUnKra0SwEDPDDVmw5N1AaO4hPcK7Fx/L/t/UVCuOgoL+sxiEVXvO0D7MbdlAybkMAVujSm7NBIMDEtB2sJLxReoaTxzqFSgUzlL5ApUmxlPNmOexYbEZBpxWZEldRIQ8BDsH+oosPdTU/XFFbEar7dGD0aRXc50xLTwn1bSBM7T9K5dUd0qKKLuyeEwlG7z+d7/2kqrvweJrxDkVDEGMqtpEPBrS6CEmiso53u2P054H3Afdm84jcZ9fkETJcmFweI5jnplYrvnad8UuLlxIxnliYHrEWIJduuny9bDfk1xNklrorqJ+O9H2It+/CjRlkxEKTsfn4w9ciFn06DeZ5masCexbRctaEnXkcAyEWuxc1LEZdklJDHA0pBx1rKg3X6u4Rw6n5ZH4XTarH7BUcPUnXlsuiPYWSCUV3sxu31JmSt68EMG/HsTdHCqQJOBWEyoJZ34d+eM7lP9lGJThk5/8wCRdvgyCw7Cxz2c0ypv2R8fKjp+GajYq6uOh8n1I/tnvZme1P2weVh/P6OPaiOFNnw8mpdbUwN6Rw0Z5dSfm5402lEQgCbBHKj5nPRPH+AJqLIrdZHPk9jIIfOH/ptqlDQeeZW2A2alDW1AzXICqYH5Can2GwyX1kTs5iosj4mmdL4sDEc+2hLn2hV6WqR6KGNi/AOvoVeyvwMe2cjUwhOMmm5m95xZtyWo9+3t1Xdp4KfOF2xgB5M24XdqImDxDLManWWu+AnP//QG
 SMXsh8PB
 C4xh1qzfCBITHzCO7klzuwEUz2sp69KvqP1hxiAzLY6szFW8ASpy4blwkh/mo27X0qjxZLDbzd6zdCtDWBIj+fFuY9my3p8dpPzIYi+L92BLL991xocKiZ5SXEK2IGH4IEbOL84Y6r6BS/+u1XQzo1sjjIsuFrhYM6bhHtlOmboK/3bhL1T3z/QAJNNj1DXQiNgtMiQW8fc3uBHNu4eQE1A7sIVqNM8WbAGeLFARxQbvL9qOzxBE4FqEFMUAF6z1KYisAxDgu6gPY0HTN1uJ40i+iivhFqTGN85WwqW0/EPvSqcnXdnNh+V0RO3w+j2Sxbpfzrsj40q2b/AOYPowvw3NHT5VcZsLWBMmdp/AyUXrY5oi9ceQA28WvFQXk2BS3g9kd9+xbHoQiC7fIDf6ufbXgSdqT7qnjEzEav+oEaHEYofY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 04:25:27PM +0800, Wandun wrote:
>
>
> On 7/7/26 21:55, Lorenzo Stoakes wrote:
> > On Tue, Jul 07, 2026 at 02:44:50PM +0100, Lorenzo Stoakes wrote:
> >> See above about deduplicating.
> >>
> >>> +			ttu |= TTU_RESPECT_MLOCK;
> >>
> >> Hmm. I don't love 'respect mlock'. I guess we only know about the reason
> >> being compaction here.
> >>
> >> But I'm confused anyway. We have the folio, why aren't we just checking for
> >> PG_mlocked() here instead of getting the rmap to see if it's mapped
> >> anywhere with VMA_LOCKED_BIT?
> >
> > Also, since compaction_allow_unevictable() is a function that is accessible
> > elsewhere, you could literally just have a TTU_MIGRATION here instead and have
> > the rmap logic call compaction_allow_unevictable() instead rather than this.
> Do you mean:
> 1. change TTU_RESPECT_MLOCK to TTU_MIGRATION, that'is OK.
> 2. move call compaction_allow_unevictable() to try_to_migrate_one? but as you suggested
>    migrate_mlock_allowed function, it already called compaction_allow_unevictable()
>    in order to determine whether TTU_MIGRATION needs to be added. Did I misunderstand
>    something somewhere?

The next paragraph addresses this.

>
> >
> > And then you could adapt the function I suggested before not to take a reason
> > parameter but rather a 'is_migration' one instead possibly and then pass (ttu &
> > TTU_MIGRATION) in.


> >
> > BUT. I still question whether this is at all needed since you have the folio you
> > can check for PG_mlocked...
>
> I described a race scenario at this link:
> https://lore.kernel.org/lkml/c372e68f-2bfc-45b6-a431-01bf55717247@gmail.com/

OK thanks. You really have to spell this out in the code in a comment, this is
really non-obvious.

I will try to look at your reply in due course (am between jobs atm).

>
>
> >
> > Cheers, Lorenzo
>

Thanks, Lorenzo

