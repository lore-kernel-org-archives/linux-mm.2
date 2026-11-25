Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35847606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 02:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fT73FuJi
Received: by kanga.kvack.org (Postfix)
	id 49D3D6B08D1; Tue, 24 Nov 2026 21:23:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475ED6B08D3; Tue, 24 Nov 2026 21:23:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38AFE6B08D4; Tue, 24 Nov 2026 21:23:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1749B6B08D1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:23:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C4C141C4934
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:23:05 +0000 (UTC)
X-FDA: 85472043930.23.668767C
Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id 94DB040005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:23:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fT73FuJi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795573384;
	b=fUudjHnRLVuUqb1vsFuPjMcPKtYm+Mh5YgW6+GsNgtk/SKCExZHHkLRFw23XSQPeZH1OFp
	CMjDUmxOnaF7LdNKyUDXRnaX9gQtDUdNxUlN0PDAmV16tC22z1JykMlruhsdgpT/tbh658
	l8TPiFAnOWv6j4ssE3KQsN7uVcAbh4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795573384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=90g/AHhcoAXcPpVja+XtP1PT+bZ1pIcNF3fvL+LDX2Y=;
	b=4uOle26+ynxRl1xc7YKLFhdSqmHsDjERvm0rL/kjE/TE5sc1d7SQ1mhAR5lscQd9TQVZZA
	qpyn7pNgQ0LD2rPKocnTURRYdt+JwKPWxaV2X/0vJPPHaq+cQtdKGOUAGmoWPnoT2Cvnaw
	+0gdfDUUS56qwAiwzj23KI6cSWkoDj4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fT73FuJi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rNC5GBZWdM52z/SE5ZYTzHP/7b3f7ExkhRG/8ASKIis=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795573382; v=1; x=1796178182;
 b=fT73FuJitHNJRTiPCzAnIh8SPcz6/XInG5niiHBuHYE0elXZQ62OfkWJmlkd3JnAuWYUjP1h
 XNS5GnkI74m9E9WS2QkIvZBHSTbQu2l5Fsny9H3yC0Z28+cmmrqazXFfGfVAvU+w68MMOt2geTm
 sH1tqnN6pXfjA+XvpfBkr+pI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 97de5dc6311956eb;
	Wed, 25 Nov 2026 02:23:01 +0000
X-Mizu-Trace-ID: 97de5dc6311956eb
X-Migadu-Flow: FLOW_OUT
Date: Wed, 25 Nov 2026 10:22:57 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org, david@kernel.org, akpm@linux-foundation.org,
	kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, Baoquan He <hebaoquan@kylinos.cn>
Subject: Re: [PATCH v5 4/4] mm/mglru: count PUD subtrees skipped by the
 PUD-level filter
Message-ID: <awZGgSrYIuOFoLwZ@bogon>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
 <20261123085800.981256-5-baoquan.he@linux.dev>
 <sashiko-outbox-230767@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-230767@kernel.org>
X-Rspamd-Queue-Id: 94DB040005
X-Stat-Signature: dkhipg367ozaqrodfh3twa1bb7rcob4b
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795573383-454318
X-HE-Meta: U2FsdGVkX1+hyi6qtNZueVqARSxCHNk7PkwaHJA25HmZcp+4fFLTNJaYgMBMgCaAwNrGG3MVFulIx8bx38421V8KKARJY4y4mr5n0+mXawddv+Z2VXk7xZFyIXunjoyBmrC7qLTQnIh8jGwGNW2BhJsntRuWRSPTY4wPqtJQCGR+EEmlAQbgIPverMhtrzBO7ab6bFkDzcdTSm6tcxL95zL1bfNQF/DhdWDpwyC9SjgBKxJ+lRo7Wni4IESCn/UTfkoVT0jQEpWMcTPnn2wvy902zinPFpbr5oVUE5Ux7GLZS7G9/O9VIQ46gZQML4O/UoT19YT8eqYHptGWGRO7qBLmLDFG9PcPknM7U+EYSu8auDBC48vqpCFzwPQB+hH+T4GqaaEHHfKPNle8D06c7e4KNrpIMyOuWWTd6Fx9GLNFi4EnKmuOH28hI/S2ImhInjiWjNufECf9eR3wiD1BOMEkcRq9pf8xNOv3RDH/zxvmxZURJTwBSG6XaY62sI70e33TY/pZD4ykvmxJI9afrDRCIJgLxtLRxk3y9Fbf5xF25xvMESJ7LeG4WmxstioOFJ0E6g5LoxMW3KxKkz52G0z61pT0IoRTPqU5x7t9b+ZOgRXrPgOEhkhbmSdHcfoDrLkztJop2Y1GAF3xQ14ALq3adFlb8AMxXH6ESnnYkfaIyxHAhqsC0uTpOazEiPg/1NJT7OXawHChE69K/mHYh1bfj8v+NiBQVqHgvZFt4md8c9sReScUr3oWcClMbQrS1swURLyqfRT8dBka8h+ZeMsC8DMvZD0jJInVpNAcb4ucziR8V+a/XScGM6Xq9xFsiMi8w32h6M7eOuEFbP+Z2BOoFpoT6HWdWHix5Uq2ErU3rdQkpRlDczuyshyibdqZx+b3hSP3BC10EEluGPcqGnWAie8irnZkA4r21P7mdF+EEQQPgFJRM/7bcMGFNpGiW8RBYMulPGGwdN6X7JW
 VzBPos+A
 Iq9d3TOgI3WIpt0FWiCbNjWuVzjlPv1TtkMtOL0qfzYJd0cFRqxiolQX3rCB8sa72OycmgdYasT14i9FZBTa4AR7wAo8Ieoj1J11QUnbSU+u1buzmRZNRJulsJ3LvetqYJAgy7SQxSCY9XtkN2q8iVeiMdvRIAWqCYYqiYkI2CHavTaK6UJ/kO8TSUzu4yvMLddJE0tAya6yXmvLpSzv1wVUTQt/9fjJOgbuT0bYuyaDI6YvO1tkj8wb5ILX0yGPddswMqb7kpwo1yZaZrsX3x/l4Dz3wwcJmVS8TIkTemWFe/L6kCaDUoBetucpWD8c0yu7n6D3p1mM4czy+AmKjHn6ii4cJh7e3l/YWMJGiS4MaBb020yQ3g5vJM1J1oiUdmvAbaaVd9doyNgZ5eRLmu/AJ5dUHpXhgPW44NzYADztgfQVZzUCVsn3jzDKHW35oJMlnDPxRBYasZIbwBuSJ5QrqLlTMw8bCuqySopsIwZGM7jEDSQYzIf2uptlLd+3jVZ8HULwmnArXqfwMK9pzSGHkyyo4tXKjWyVilSyqTUdcJPI2pWqOy6qOKlvCcDFekDEFTg0tF57BhoIKBXpw3sQ5cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 at 08:59am, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/mglru: lost young return from walk_pmd_range_locked() in
>   walk_pmd_range()
> --
> 
> commit 3dc8080e8c434c4239bc40252f11504dbbdb29f3
> Author: Baoquan He <hebaoquan@kylinos.cn>
> 
> mm/mglru: count PUD subtrees skipped by the PUD-level filter
> 
> This commit adds MM_PUD_EMPTY_SKIPPED to count PUD subtrees skipped by the
> PUD-level Bloom filter and exposes it in debugfs and the
> mm_vmscan_lru_gen_walk tracepoint.
> 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 517f5fbecdbf7..56e18ffd3383e 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3836,8 +3836,10 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
> >  
> >  		/* Skip a subtree that had nothing young for this lruvec last gen */
> >  		if (!walk->force_scan &&
> > -		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key))
> > +		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key)) {
> > +			walk->mm_stats[MM_PUD_EMPTY_SKIPPED]++;
> >  			continue;
> > +		}
> >  
> >  		if (walk_pmd_range(pud + i, addr, next, args))
> >  			update_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1,
> 
> [Severity: Medium]
> Can walk_pmd_range() drop the true return value from a flushed THP batch
> and leave BLOOM_FILTER_PUD unset for a PUD containing young THP entries?
> 
> When walk_pmd_range() encounters a PMD-mapped THP, walk_pmd_range_locked()
> batches it into first/bitmap and initially returns false.  If a young
> non-leaf PMD appears more than MIN_LRU_BATCH entries past first, the second
> walk_pmd_range_locked() call flushes that queued batch and discards its
> return value:
> 
> mm/vmscan.c:walk_pmd_range() {
> 	...
> 		if (!walk->force_scan && should_clear_pmd_young() &&
> 		    !mm_has_notifiers(args->mm)) {
> 			if (!pmd_young(val))
> 				continue;
> 
> 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);

This has been reported at patch 3 sashiko report, a repeatedly reported
issue. Will fix in v6 soon. Thanks.

> 		}
> 	...
> }
> 
> Because that flush resets first to -1, the final walk_pmd_range_locked()
> call at the end of walk_pmd_range() returns false.  If no subsequent PMD in
> the PUD sets young, walk_pmd_range() returns false to walk_pud_range(),
> which skips update_bloom_filter() for BLOOM_FILTER_PUD and causes the next
> generation's walk to skip the PUD subtree and increment
> MM_PUD_EMPTY_SKIPPED even though it contained young THP entries.  OR-ing
> that return value into young avoids losing the result of the flushed batch.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261123085800.981256-1-baoquan.he@linux.dev?part=4

