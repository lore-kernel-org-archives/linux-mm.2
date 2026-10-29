Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E24606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmxfRq/W
Received: by kanga.kvack.org (Postfix)
	id 2960B6B05B2; Thu, 29 Oct 2026 16:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2466F6B05B4; Thu, 29 Oct 2026 16:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183BA6B05B5; Thu, 29 Oct 2026 16:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE2516B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:59:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 881ED4051C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:59:08 +0000 (UTC)
X-FDA: 85376878776.13.ACE34B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D51F58000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:59:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jmxfRq/W";
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793307546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wrz5dmAaDurZZfTeBzHlm9n0015a8frVXDMMr6vuISA=;
	b=BsuoG5FkwXyRAW2SZsXOLBRO//bjL+LSrO8R4fmN+tOTziZh9ox0Y4Tf85hgzdpFTxgjVX
	lAqbyf5Tqv937yCQozfmQE1i/r3qofF8Bib/2ZD3UZb17q8otRWwMB62sgV04Xx9ayn2RV
	PBW7BQUi7vYflG1+177jJOGXimorHXk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793307546;
	b=hXbPtndQWwjLBS9BcCbp1T/f2AwSs2oW5PfZMfeAJghnT1YZF8NfS6otcPQhlRxtCjYBFi
	AoiGGMAv5/XeeWn8UfRkb0Va1BD+/rmruakavntgAIkxAlBdyDeivA2QjPdMxRxTvcTj2W
	TAz3X6i0E/gqUPTxp5Gdo98rezJa6Cc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jmxfRq/W";
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1179641A69;
	Thu, 29 Oct 2026 20:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EE91F01816;
	Thu, 29 Oct 2026 20:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793307545;
	bh=Wrz5dmAaDurZZfTeBzHlm9n0015a8frVXDMMr6vuISA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmxfRq/Www1yiDpn1schwv1eOjCzvV1jdqrAyTBwFUbhooyCD9Hh09WufuAsXVa5w
	 2gyuAiZnG7ESQFGJzF11UBQMnd8J0p74JWspKeGENsEVpJEX5jetL3DCtMNwdYSVIc
	 5IdDa+uG2IooRd9FXP+RPZD/d6I9Yfz6raCyjitjjNhnl94fCA1TBdbgYhdHO6d1s4
	 GyoBJopzSOIUBXoWb60wacVfwCK1V633BD/zZYTQ+Vgz6gpufUsateRPDwcP0KqrSp
	 RCNNVjSLhTz+zXEcOdqLLB7KtEgqLNrUkvqpYwSRuMnL5ng0GDVbJWK0+tDXqkusrJ
	 Cm7nwAEAnTynQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: kernel-team@meta.com,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array after concurrent resizes
Date: Thu, 29 Oct 2026 20:59:01 +0000
Message-ID: <179330739525.606664.13318485044610934477.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261016132510.789715-1-nickolai@csail.mit.edu>
References: <20261016132510.789715-1-nickolai@csail.mit.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D51F58000A
X-Stat-Signature: 6adt4yaqixmpb69hj73cfinh1aahofyk
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793307546-281261
X-HE-Meta: U2FsdGVkX180tvuX0kslnkB2h609hk2WN7/FvvBf/ghejmRwL1R+j0wMyckFaIs06F5wQ9KyEu3cxhBi5SCxldWy8GQzOYm4LwC3vKswAPSWWt6UbsjIe+apVM6eIdNKzzk3aCotAXPs+ZqXwvtVm+NyfZOVCXEgdHTjAgn0Rg3icNCmveyB1F+E676PmOJ+AOHtoW1aB1QqOIVxyGS7IbQDfxGhwXikYpZztyUgyXoZcrbPxkl0EVRaBJHQv9jb45vGEDSCP+EJzu8vQUVPGH5KlyfJ8+5xb1kRpjGi1DcRXugzBQNbkdCYnbD8ofI7yrWMlRs8kI6iwf/qb1u8qJyLEetERvdw93TmTGWWE1Zh5gtyzcikQhZYvomUeogFACcoms/1U65Elk3dQ5Q3mLN9q1/uBDJxJ9UCBaXE5qmd5RoNlpl4nmDGMaFgTlraE7KCEqnCKsG8dP4DSQk8GSiGcOOzF8DQMwOZfKZbTXcnPQzjWzAjUhiU3rGd+6NrvsX7Aiq9aBP2r4XgixpO+BzbkB6pJUpKgzBU5ZKC+zZNoLR3MSeK932XyEas09ViJnWvaW500++/iV2HBL4NebMogzoqTiqCyx9HqNsqi4Fh62lyAmDhuNqS/mnvTKxkIxWrEOOEjkicaFehXwUGXUEH4o7y0g+kRoW6azNSw2CAwrsOF4JlBzNhhsXvBDuzu/0G6a8ZsIpDR9pe5B0RkScreUukDflnSZqbH/dEJuHdzY0lQVqnvhAhC4tqZmw2FdVrVEqeBEDwTuQvbRuUP+i1ZZqpQiJPZy5S/C3USWjNoEJjHkbLBSk32ck3ZES6dBYFJu9YBcfIJb3fuLp3EaU2h7ztdqnCtyohq8aDxQOmLAsX6E8qRWw9lHXU/XUMwaijZrT8D474NyOVX0FWR+F3BYhBzKENB+93YLk6Zb25U5zgfyBodNaU5CEVUoo8QbWxYn0wjVVmr4VoHdu
 ywjoFapx
 sWL8SmXWrsWdY8ZAEYzlmvRGfrdyuvLfzp6teqFzSgH1Y11mWngkndgiMTdUakzRnef5TAh3sSetvsZkPHoqpWhtQ6894ZzWklg/HiGfaOyCHcCRmGKyXX8hki5tBfrwQokhg3+qwDdgo918a4aY0/onZgv4zvrAbUcTyfQ9Z55tbacwjvkEgtEoBJbNAFOdze3QFQKDrl3c0HK33ASAaxt4Cfap81AO4jf7sqJbvlGTcbTLjWiNo46OpKp1Oqm/2V3qxkq66O+x7sRk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 16 Oct 2026 09:25:10 -0400, Nickolai Zeldovich wrote:
> mempool_resize() shrinks a pool by dropping pool->lock around every
> free_fn() call and, once the pool holds no more than new_min_nr
> elements, stores new_min_nr into pool->min_nr.  new_min_nr was only
> compared against pool->min_nr before the lock was first dropped, so that
> store assumes nothing changed meanwhile.  The kernel-doc allows
> mempool_alloc()/mempool_free() to run while a resize is in progress and
> the grow path also copes with concurrent resizes ("Raced, other resize
> will do our work"), but the shrink path does not: while its lock is
> dropped another resize may shrink the pool below new_min_nr and a third
> one may grow it again to a size between the two, replacing
> pool->elements with an array of exactly that size.  Storing the stale
> new_min_nr afterwards leaves pool->min_nr larger than the elements
> array.
> 
> [...]

Applied to mm/slab.git slab/for-next-fixes, thanks!

[1/1] mempool: fix min_nr exceeding the elements array after concurrent resizes
      commit: 8dde7b06d2d819422c736dad7efb9635b6673cc2

-- 
Cheers,
Harry / Hyeonggon


