Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13984E9A04A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0BF6B0005; Thu, 19 Feb 2026 10:00:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2783D6B0089; Thu, 19 Feb 2026 10:00:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B516B008A; Thu, 19 Feb 2026 10:00:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 072766B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:00:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E68413B496
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:00:45 +0000 (UTC)
X-FDA: 84461518050.10.47C15E8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 139B340019
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:00:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771513243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bf9shwcxi6+RNcuKlehYMYK1/zJWznKBE3VcW418bik=;
	b=TdY0gQDk4eyI8+iWLnumh46LjUEQGXNcu9G9Utt5wSh8RZAxXIhTF8sDaDDqmPSNkuEYvB
	y2Daq4/v6o2vtB2HtCt8z7EFp5H3mRIfgikk3XcQGKvYXzIJywjvuZURXsiEz1mQuCJUN3
	1cUCCgDK8jBmGYYkf4kwWCa4j79LOHw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771513243; a=rsa-sha256;
	cv=none;
	b=xycYo2kEsujAekkaX5KTmJ+OzkoTh9aitJT5N2AfpbR8FcfKq/Cb9MyxY7WyUDkT6Qwun7
	a4jmcAVQlOr6ERVUqE1K8l6x6yKzqp8qaOgLnslsTo7+5bmxJkKWxrr6ccj352puXEiQ9d
	gJe8JV034+S6WafMQsdZlNvzoR99NFo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9393B5BCFF;
	Thu, 19 Feb 2026 15:00:41 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C18F53EA66;
	Thu, 19 Feb 2026 15:00:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PSkBLJgll2lqFgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 19 Feb 2026 15:00:40 +0000
Date: Thu, 19 Feb 2026 15:00:39 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, 
	surenb@google.com, jhladky@redhat.com, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, willy@infradead.org, vbabka@suse.cz, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions
 since PTE batching (cac1db8c3aad)
Message-ID: <rtaao2lmzbmyugjeqdwhnacztjfgijjcax6itgst557qhqsnkr@iibocfiibsfh>
References: <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
 <nfrvygkft42c35ymgupwggrc2hrbatxaa6cn3hjxffrvhaprqg@wjg4ye4uv5go>
 <8315cbde-389c-40c5-ac72-92074625489a@arm.com>
 <5dso4ctke4baz7hky62zyfdzyg27tcikdbg5ecnrqmnluvmxzo@sciiqgatpqqv>
 <eaa6be47-f1fc-4b88-b267-5aa38e3ba2a9@arm.com>
 <340be2bc-cf9b-4e22-b557-dfde6efa9de8@kernel.org>
 <cdrrvtzy76f7wplcrls3pbfe37kzrvzsrlaed7glg2cq6j3yob@wjbjklvovpl2>
 <624496ee-4709-497f-9ac1-c63bcf4724d6@kernel.org>
 <r2b2cjuqicmrw3zdwruacpelulhjhfdawrtbgzph5vsf6h5omj@dhrga7p62hju>
 <9209d642-a495-4c13-9ec3-10ced1d2a04c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9209d642-a495-4c13-9ec3-10ced1d2a04c@kernel.org>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Stat-Signature: 37jb5sta8zekk9wzenrjbojfiey4d4q7
X-Rspamd-Queue-Id: 139B340019
X-Rspam-User: 
X-HE-Tag: 1771513242-340621
X-HE-Meta: U2FsdGVkX1+XwVmjfFI/Du1cMnQzLh6LHrlYxkrw/C43i4vr2h0YxiFZ4/L+kdVjLjRWWQxzKcujcGwltb+T0xujaLH6y+ILVOXC2r+FFgEMDhdRfbSD9iYAR6t23VFMgZpaRkARYJWWSHZDXrwcCmftnSO8+C01AziZQbsqpA1AXP46Pee71K6lQIVWu2XLAUWKdSbv9uG/PQj6lfSJPxI90iUYlj1lhwbUR/eBMtarEs9BEd9UYi7PtQXR16V6LTpdMmzu3lcQImaYs3vk0etAk7MX/Wrh/I45Cfor2GFRFK5mwIUIdMqoDkPhQhg2ksVTWa0KNf/alhW9oequeUGX8xJKbI6+ylZG/X7A+5yXGJpbmaSHUFN2L90zGgIX05z/B/Ybtg0PnG/B9Mc1BOrorhEBg4kQ5gTFoOftrOLjnEuyVPJPGY+fV76Nh8jI5Ni4HNcGuDJfKCbd6px5p46tCfBFFaiq15/qhxhDX8KZh7JMPtEC9acCN7viFF70CSK/lWRLG9oeNyz91sZrO2E/ic+eP0KYbVnb02YlcAxZnGW2xSY0QBPulFRpN8hOmQD2NPPuAogFID9k3mpxu8d5hG8uHGITHu6/j7HLQytR0X3H8NX9fInVRKSH0tROw+HPx7rYwGtWpfgbGtXyob9sk5SZIhwr8Cy9TGEy707W13fi2SasW3xU9LIpwifnebUUm8W9VryUqzFQ2KKvdGEXTO2jaLYpqxS8pBCD4GtMYR7dAhBjkA6pI39BOQvqF1afUxOfF7tvfPDucnIQ5MID7GThSbUtCBD4KK3nuq5BwBV8mECQfS94dmy+lVdR2+w/jpm+TMiwrkYi1bjUPJoLEeHEBliwlNTT6mHfhdi/3riO17Jq4EoiKdurDCClSJDmqt+r6wsRXCKmu6Hu8Mq20BmFbdTClAYB33s+tG3ww8TKxJowBPke/M0qcZ5TO5hd1XY/ckEZEt1dzIj
 ObC9aqX2
 IlMLBN+w9NdfMpnr0ccHuqh+AzPA9UJnR0UIW+Ujab3ZP7VLvVWtKkIsCmRnFsOV4JTB+O4q8DX3MO+kqE7Jws+iTYWQ2e+YvnjMjoiIs5JTJFYU9DrCbjFeIiTJ86kAncTssmNZbI5M1NUUKQkNw0MaCzx4KkAXsKR8foJP0pJ4afco=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 02:02:42PM +0100, David Hildenbrand (Arm) wrote:
> On 2/19/26 13:15, Pedro Falcato wrote:
> > On Wed, Feb 18, 2026 at 01:24:28PM +0100, David Hildenbrand (Arm) wrote:
> > > On 2/18/26 12:58, Pedro Falcato wrote:
> > > > 
> > > > I don't understand what you're looking for. an mprotect-based workload? those
> > > > obviously don't really exist, apart from something like a JIT engine cranking
> > > > out a lot of mprotect() calls in an aggressive fashion. Or perhaps some of that
> > > > usage of mprotect that our DB friends like to use sometimes (discussed in
> > > > $OTHER_CONTEXTS), though those are generally hugepages.
> > > > 
> > > 
> > > Anything besides a homemade micro-benchmark that highlights why we should
> > > care about this exact fast and repeated sequence of events.
> > > 
> > > I'm surprise that such a "large regression" does not show up in any other
> > > non-home-made benchmark that people/bots are running. That's really what I
> > > am questioning.
> > 
> > I don't know, perhaps there isn't a will-it-scale test for this. That's
> > alright. Even the standard will-it-scale and stress-ng tests people use
> > to detect regressions usually have glaring problems and are insanely
> > microbenchey.
> 
> My theory is that most heavy (high frequency where it would really hit performance)
> mprotect users (like JITs) perform mprotect on very small ranges (e.g., single page),
> where all the other overhead (syscall, TLB flush) dominates.
> 
> That's why I was wondering which use cases that behave similar to the reproducer exist.
> 
> > 
> > > 
> > > Having that said, I'm all for optimizing it if there is a real problem
> > > there.
> > > 
> > > > I don't see how this can justify large performance regressions in a system
> > > > call, for something every-architecture-not-named-arm64 does not have.
> > > Take a look at the reported performance improvements on AMD with large
> > > folios.
> > 
> > Sure, but pte-mapped 2M folios is almost a worst-case (why not a PMD at that
> > point...)
> 
> Well, 1M and all the way down will similarly benefit. 2M is just always the extreme case.
> 
> > 
> > > 
> > > The issue really is that small folios don't perform well, on any
> > > architecture. But to detect large vs. small folios we need the ... folio.
> > > 
> > > So once we optimize for small folios (== don't try to detect large folios)
> > > we'll degrade large folios.
> > 
> > I suspect it's not that huge of a deal. Worst case you can always provide a
> > software PTE_CONT bit that would e.g be set when mapping a large folio. Or
> > perhaps "if this pte has a PFN, and the next pte has PFN + 1, then we're
> > probably in a large folio, thus do the proper batching stuff". I think that
> > could satisfy everyone. There are heuristics we can use, and perhaps
> > pte_batch_hint() does not need to be that simple and useless in the !arm64
> > case then. I'll try to look into a cromulent solution for everyone.
> 
> Software bits are generally -ENOSPC, but maybe we are lucky on some architectures.
> 
> We'd run into similar issues like aarch64 when shattering contiguity etc, so
> there is quite some complexity too it that might not be worth it.
> 
> > 
> > (shower thought: do we always get wins when batching large folios, or do these
> > need to be of a significant order to get wins?)
> 
> For mprotect(), I don't know. For fork() and unmap() batching there was always a
> win even with order-2 folios. (never measured order-1, because they don't apply to
> anonymous memory)
> 
> I assume for mprotect() it depends whether we really needed the folio before, or
> whether it's just not required like for mremap().
> 
> > 
> > But personally I would err on the side of small folios, like we did for mremap()
> > a few months back.
> 
> The following (completely untested) might make most people happy by looking up
> the folio only if (a) required or (b) if the architecture indicates that there is a large folio.
> 
> I assume for some large folio use cases it might perform worse than before. But for
> the write-upgrade case with large anon folios the performance improvement should remain.
> 
> Not sure if some regression would remain for which we'd have to special-case the implementation
> to take a separate path for nr_ptes == 1.
> 
> Maybe you had something similar already:
> 
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index c0571445bef7..0b3856ad728e 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -211,6 +211,25 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
>         commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
>  }
> +static bool mprotect_wants_folio_for_pte(unsigned long cp_flags, pte_t *ptep,
> +               pte_t pte, unsigned long max_nr_ptes)
> +{
> +       /* NUMA hinting needs decide whether working on the folio is ok. */
> +       if (cp_flags & MM_CP_PROT_NUMA)
> +               return true;
> +
> +       /* We want the folio for possible write-upgrade. */
> +       if (!pte_write(pte) && (cp_flags & MM_CP_TRY_CHANGE_WRITABLE))
> +               return true;
> +
> +       /* There is nothing to batch. */
> +       if (max_nr_ptes == 1)
> +               return false;
> +
> +       /* For guaranteed large folios it's usually a win. */
> +       return pte_batch_hint(ptep, pte) > 1;
> +}
> +
>  static long change_pte_range(struct mmu_gather *tlb,
>                 struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
>                 unsigned long end, pgprot_t newprot, unsigned long cp_flags)
> @@ -241,16 +260,18 @@ static long change_pte_range(struct mmu_gather *tlb,
>                         const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | FPB_RESPECT_WRITE;
>                         int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
>                         struct folio *folio = NULL;
> -                       struct page *page;
> +                       struct page *page = NULL;
>                         pte_t ptent;
>                         /* Already in the desired state. */
>                         if (prot_numa && pte_protnone(oldpte))
>                                 continue;
> -                       page = vm_normal_page(vma, addr, oldpte);
> -                       if (page)
> -                               folio = page_folio(page);
> +                       if (mprotect_wants_folio_for_pte(cp_flags, pte, oldpte, max_nr_ptes)) {
> +                               page = vm_normal_page(vma, addr, oldpte);
> +                               if (page)
> +                                       folio = page_folio(page);
> +                       }
>                         /*
>                          * Avoid trapping faults against the zero or KSM
> 

Yes, this is a better version than what I had, I'll take this hunk if you don't mind :)
Note that it still doesn't handle large folios on !contpte architectures, which
is partly the issue. I suspect some sort of PTE lookahead might work well in
practice, aside from the issues where e.g two order-0 folios that are
contiguous in memory are separately mapped.

Though perhaps inlining vm_normal_folio() might also be interesting and side-step
most of the issue. I'll play around with that.

-- 
Pedro

