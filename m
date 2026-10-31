Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B3C606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FcN7mrT0
Received: by kanga.kvack.org (Postfix)
	id CB83B6B00EF; Sat, 31 Oct 2026 16:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68486B05B1; Sat, 31 Oct 2026 16:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7DB66B05B2; Sat, 31 Oct 2026 16:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8178B6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:56:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6A161A023F
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:56:17 +0000 (UTC)
X-FDA: 85384129194.07.6AF582E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22CEA100008
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:56:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FcN7mrT0;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793480176;
	b=moZqG6TZjK+E/8vradbNlJvczRbzqnKWnovR4weRL9LMaH67jSWWO8NjqOBgNJe5jLGlaJ
	Q8kRnuk3p4xNLlWBuulfyadUGXERb8e5l8dRkV1fOymY30y47q3RjksIpwGFfPIIY/kJmb
	i68bmA9uDjopO1vT3d0PJXCGc8mZrmY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FcN7mrT0;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793480176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjK3yGbh9I562aCl8x1LgXKj2z60QV4RAB6gwWU7JvI=;
	b=poBDYjiLjiswyFAVwt+jyCJZDPREs5gVINpx1SIaeWcPCLE434e2wjUBRUq24Kl3f6Z2FD
	fhcoje4GORYfrntw3R2u61NgcUhY4xY/wfHOdp+XW9MyndcKkF93NQ0hrAF6I7RS56B6NW
	kB5KgfFDYHU7PVt/DThasvf4XBnvYU4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5252E409AF;
	Sat, 31 Oct 2026 20:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E0F1F000C1;
	Sat, 31 Oct 2026 20:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793480175;
	bh=bjK3yGbh9I562aCl8x1LgXKj2z60QV4RAB6gwWU7JvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcN7mrT0Fk92Pf9d8ua1XgnJRDHDr2AYDAk6Q6oX1zirqp1LEZMolcKZ8/DkUMCVJ
	 b+37cUAkM7wRvYaVTmpoQ5finMV84Zak/q5m2IEMRymE8oLT2IP7baliOf28DEVP8A
	 J6FEoieIsELr9eEE9pwj9pnAL3S/AZrBKPSlhKgmZFqN4EcneNyX1hl/o11QsL9FoR
	 YA6WE3viXtwLJirmi07y4Opwjfr6M6L8VhOoSzjdeKWTWwLFMqBZjPELma/2fbqGFW
	 GNzAgo8gPGrcZHyjL4G+jqNWLyhQCXb0y82Gr5APhntirYbkgPz5fy8S2t678zObBF
	 5B7XSBLqbjdBQ==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/6] mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action
Date: Sat, 31 Oct 2026 13:56:06 -0700
Message-ID: <20261031205608.97086-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-192119@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 22CEA100008
X-Stat-Signature: peybyb75q3y4whx9mj11nwrdm4j6y3b7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793480176-393280
X-HE-Meta: U2FsdGVkX1/n2Ppfh8ZSpqrO1DdLBKraDNhre/kn3hMPPUX5N3vrpvhE75t4aiLU7qv3XqGBSmb1d1eaAow9QBtd4/+QziBL0vZxlMgfuSx+Yh+VcsRAswm66wMb/i/FMAiMlWQ90KNjwCdNY8H6EvoQEvHLySNtEv9CLz7m0W1RIVt7kG/tnkuJfk3eUILd0CTS/ruSRlfRWvSCChcQSwqh+pRg1h2+BPt31LX/+C3pwy7F+voHMDl0R8mLT6Bsbcc8nojHjNCqkMj17Xs6ukE0qzz4RkyxpBpxi5xhvCMjyeyI657pjPlo1HC1rjpedVKTurUAqjd6nb8EUfV1Ldlyhj49UjbmMhDjAHu+meJNxNKCkp3WTX4k62znK3YNaLLtNhANSIr6Ey4wPT01tn4BHk2tyBiYi05HIcoZllEgLtI8eMw66f3SR18gyUdsDD6+j+SSMLFWwzAkWrGsLLZYNc3h05ontj0qJMUALro7qu4A18IaDwO4qhBrvpA0583Krkofey853EjUz8b8KANv3QwkfSP+S7PjSZDfIjQMxkm6+ERw+LWTD27Zzo9rhJW5rPG1CcRPXwVjOh6hYymtm10Ong6RJZxsBwIOGQzZKnzTGRYkiluTCYETmeqtGum7jGTX9tAoyvcFEp1GZIDOSW3RI0t3aubXB8BSTrIz2SxUWYEmIKOyWOb4yc1vO5Z1KonYlPvGhr2T+B0EGdU/X55/QmlkRGpWzzhRF3zQpVv7olKb4+r+A0Z6cdqRsodmoHEPhnFuvcffk9zRrM/Ve8fPzu8kXIiPHYtlPWP8glDN2MLIXDXRd9G6KAbI131hALVzQywtp9fCFLafzVX9jkFokB5XdnGs3gyzJ13a07nyITVMWGCJeXokd3aGk9J5IVcawqMEqR8FeL5j9V5uFzobFJHzWdVKBnsyZUUCoZ59L7SvEzRpPLZwGsiVYkK3U7FEp1Hd9jI6A7A
 pq0FRzlE
 Bo/f+y7qqOJodT6brOClPWy0fineEU4Y/zRH/Um2TrLvAfyDRKyLoMPz2G50w3FsuPMMmq8KYexOVmskKeuu+upFzFSOg+/zlgusl+mmtEDI6ccq4nq/pMgI5uHINd1gDnrj1U6EJrDRYULiPLYzzNbpNUAL+XPebgf1U6U6b+kaIdRDePdFsNZOFuTXPHgqWMeNH+stJB5K072UxKfuY47b2uIyzihwHitibldwjl7HuTEXAyso3YnE92Sispblt8yfAJ9isqhsAqsz4RACFNy2WFRg9xkfZe89lMMq/J23TULm965XnJsdFEk0UKjttAvP1ifBQQkfQY2TAe9LHTETuSjcnLkYe37xb6Kr62+KaP8xyL3hqHNTpwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 31 Oct 2026 20:36:41 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] mm/damon/vaddr: uninitialized priv.sz_filter_passed in damos_va_migrate()
> - [Medium] mm/damon/vaddr: double-counted sz_filter_passed in damos_va_migrate_pmd_entry()
> --
> 
> commit 872d2945863aba3a6ac672128498f5d65dbc8d40
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action
> 
> This commit adds sz_filter_passed accounting to the DAMON virtual address
> space implementation of the migrate_hot and migrate_cold DAMOS actions by
> accumulating folio sizes in damos_va_migrate_pmd_entry().
> 
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index c271b6d63c027..112095c2d53fd 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> > @@ -776,6 +776,7 @@ static bool damos_va_filter_out(struct damos *scheme, struct folio *folio,
> >  struct damos_va_migrate_private {
> >  	struct list_head *migration_lists;
> >  	struct damos *scheme;
> > +	unsigned long *sz_filter_passed;
> >  };
> >  
> >  /*
> > @@ -840,6 +841,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
> >  	struct damos_va_migrate_private *priv = walk->private;
> >  	struct list_head *migration_lists = priv->migration_lists;
> >  	struct damos *s = priv->scheme;
> > +	unsigned long *sz_filter_passed = priv->sz_filter_passed;
> 
> [Severity: Critical]
> Is priv.sz_filter_passed ever initialized before the page walk runs?
> 
> In damos_va_migrate(), struct damos_va_migrate_private priv is declared on
> the stack without an initializer, and only priv.scheme and
> priv.migration_lists are set before calling damon_va_walk_page_range():
> 
> mm/damon/vaddr.c:damos_va_migrate() {
> 	...
> 	struct damos_va_migrate_private priv;
> 	...
> 	priv.scheme = s;
> 	priv.migration_lists = kmalloc_objs(*priv.migration_lists, nr_dests);
> 	if (!priv.migration_lists)
> 		return 0;
> 
> 	for (int i = 0; i < nr_dests; i++)
> 		INIT_LIST_HEAD(&priv.migration_lists[i]);
> 
> 
> 	mm = damon_get_mm(target);
> 	if (!mm)
> 		goto free_lists;
> 
> 	damon_va_walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
> 	...
> }
> 
> When damon_va_apply_scheme() invokes damos_va_migrate() for DAMOS_MIGRATE_HOT
> or DAMOS_MIGRATE_COLD and damos_va_migrate_pmd_entry() encounters a present
> folio that passes damos_va_filter_out(), won't *sz_filter_passed +=
> folio_size(folio) dereference an uninitialized stack pointer?

Nice finding.  I will set the field in damos_va_migrate(), to sz_filter_passed
parameter it received.

> 
> >  	struct damos_migrate_dests *dests = &s->migrate_dests;
> >  	struct folio *folio;
> >  	spinlock_t *ptl;
> > @@ -858,6 +860,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
> >  			goto huge_out;
> >  		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
> >  			goto huge_out;
> > +		*sz_filter_passed += folio_size(folio);
> >  		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
> >  				migration_lists);
> >  huge_out:
> > @@ -885,6 +888,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
> >  		nr = folio_nr_pages(folio) - page_idx;
> >  		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
> >  			continue;
> > +		*sz_filter_passed += folio_size(folio);
> 
> [Severity: Medium]
> Can *sz_filter_passed double-count a large folio that spans across multiple
> adjacent damon_region ranges?
> 
> In damos_va_stat_pmd_entry(), the walk checks damos_va_invalid_folio(folio, s)
> and records s->last_applied = folio so that a PMD-mapped THP or PTE-mapped
> large folio overlapping more than one damon_region is only counted once per
> scheme application pass:
> 
> mm/damon/vaddr.c:damos_va_stat_pmd_entry() {
> 		...
> 		if (damos_va_invalid_folio(folio, s))
> 			goto huge_unlock;
> 
> 		if (!damos_va_filter_out(s, folio, vma, addr, NULL, pmd))
> 			*sz_filter_passed += folio_size(folio);
> 		s->last_applied = folio;
> 		...
> }
> 
> In damos_va_migrate_pmd_entry(), s->last_applied is neither checked nor
> updated on either the THP path or the PTE loop path. If a large folio spans
> multiple regions and is not migrated during the first region's walk (for
> example, because folio_nid(folio) already matches the target node in
> damos_va_migrate_dests_add(), or because isolation or migration fails),
> walking the next overlapping damon_region will encounter the same folio and
> add the full folio_size(folio) to *sz_filter_passed again.
> 
> Should damos_va_migrate_pmd_entry() also check damos_va_invalid_folio(folio,
> s) and update s->last_applied = folio?

Good finding.  But this is a pre-existing issue.  I think it is better to be
fixed first, before this patch, though.  I will add the fix to this series, or
post it as a separate one before this series is merged.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261031202614.96036-1-sj@kernel.org?part=3
> 


Thanks,
SJ

