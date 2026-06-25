Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50328CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CE6B6B00F7; Thu, 25 Jun 2026 03:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5BA6B00F8; Thu, 25 Jun 2026 03:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3A76B00F9; Thu, 25 Jun 2026 03:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D81BA6B00F7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:48:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68FAE4059E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:48:00 +0000 (UTC)
X-FDA: 84917656320.16.950423C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CC920100003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:47:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M8wc07r5;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782373678;
	b=M1hXnwL55zuXNkiuIKa2DZwTFEKM5UFj3WmVAyHVJ0k0K7kc61coyHb1K7lMcFNDKGJ9AP
	u3sJtrnntejvvWmwpVhRaSUIZs0rqdvsvwbbWVwxtFCKg32Ln3bisWPBfLmIyZmPYH1u9K
	CeDQ5/YDz1Rr0M9FLn8fHVf6vubIoIY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782373678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6EWf8/p3GdUfDsB6KUh8cm6oeky3cDiDHBT1ngph3QY=;
	b=CFxolg27necYHRUZ3AzskAsu+5ZOSYdgTIS3UOAdncqf/J9OBI7mLnPJKpyh2iW8qGI+KO
	tkvhN2jUry5slHPgsfmZZzzL8mXjiEWp9tO06I/7GFaK46xFrJltfCIp4moRrV84r+jsam
	VTM1p5PNcb1lvM+HORjTHEW+RsJWA9g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M8wc07r5;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7B644059F;
	Thu, 25 Jun 2026 07:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629371F000E9;
	Thu, 25 Jun 2026 07:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782373677;
	bh=6EWf8/p3GdUfDsB6KUh8cm6oeky3cDiDHBT1ngph3QY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M8wc07r5i8ikZrrruBZSlFI6ZiEcpaVSmzn3OWpol0NLZBI1Z5CrNHFGkPnYt8ia6
	 0yRZLA+z+PrGz+DNu7N2dGurP12D8fqbDklIRoDMIN9MnxNb/xG0Qtr/CNTHLtfbMt
	 k6qHkzc0mpZJz/fqQZxhuM5Yq2+j6xIx+HPfSJ1s8cq3H52rj7KUVdAdBCM9jDkGjy
	 FrcHzCwya5a6S9SLixuV4k7yJP4ghsZbAlt1OGZaZJ6i1OmvfThZochaaQy9ttk8z8
	 MgX+UtezYFty2vTwI21NbzRz9Dz7CcjHmoAlN32+tOUYNGH+i+zPKnE5LqgpOT7dO1
	 Ndm0MibJax02g==
Date: Thu, 25 Jun 2026 08:47:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-mm@kvack.org, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, kernel-team@meta.com
Subject: Re: [PATCH v2 0/3] mm: __access_remote_vm with per-VMA lock
Message-ID: <ajzbm6SnoLODUdvF@lucifer>
References: <20260625015053.2445008-1-riel@surriel.com>
 <b0d9ce70-ebb7-4b79-9a35-257b69daff7a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0d9ce70-ebb7-4b79-9a35-257b69daff7a@kernel.org>
X-Stat-Signature: hecxfcfirjz68qddzkk1ttef7ifxak9r
X-Rspam-User: 
X-Rspamd-Queue-Id: CC920100003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782373678-507969
X-HE-Meta: U2FsdGVkX1853SZBGCgTpfjt5ibykzBJ3elQtHxgEWB/i0SPS9O1tpzY0VJ81HJVExvI7DSzHZ4LsBkQlhlYrrA9gUQwqsKFdr20gXjEy6WcHgAPQzfBoM2uWveVLqr20cD2Ux6fUlW8tsXk0N4+3k4yqyqwBB2arWp+SwI7aNU86dhLyNxMfHIWTWbd9t3Teqt89EaAxO7f1nMHbPTALaHScbwD3DVkUve03zkbUJPT/jTl8UJ8ngwrhRfS00UTHQNnagg4cgvTUt9Xer5PMTZKKm8SD3+2d0fm7zCwv8d31JMS2OaX+fVLeZ6xcZxz+aPh8yv3aKpelx3j0rD08kgBigHjl3et1q4OFqNb/GSZerHdJc/7t7zUjPkAAO7bWQ0XdbkkNJ338K0ZUdMxzDNf2XCcktvzLwCTgos2uF5XoBoyo/pgBvb4tyqg5I9ziblwQu67qtmwgs+vUWr6y5FsowQBxAXqX5rizq6Ja0Qkk5uN9NtkiO9J8dalDm3aNB/wKpCek/ayYzl6uAQCSLjwruh52Q1YLTahDXdYyEwoe4Ne3ka2A7nrLLxWGzH/KpwVpayM4BDFeGxjrDe2z2c9cS/JEzzvdD5FYzllKS3Bj1XNBd7YCz4MlvYXmMgKXz5e258oD+9zl4NhX2yEMYR//uSdPWms09jC8Em4nmwe7qFIS9QT3CaqRjVbLMkfhpYKD+7qwSlB+qoS8I4SdsRLL54gYfH+d6NKyLt32Z3sGo1T2ozmelPmyXJSlqhO3my1sJsvyERwCgJTILMe1XhGAITO5sLuNeK6AmoUPm8dHfLjqq+EKGQRtObR/Mwl8wvs2bXpn0omcLwx0+jQuq5CwAzpYSaQl1rL/VfY5xwfg7UPz6EEZAYbIfcHdvM3RuCMgcltQIfBnD1NZAG3MqTKn2p75g2oJtA+IccyR1dpU31C+beo1EuN3nKCY8XgEJ+GaHleUty898759NN
 9tzH8zjN
 EWjZ/ZRBGXwRtWy+5tqdgRG3Ot+y69jxEDIfublKZrerwICODKr0hLyCRd7Sszp9H8TKI7IQoHqfPWUO8lDUeGWaVq003l0RFc06+sWtSSgnn3bLywuxhG9Kkl+DA0tMMWOf6JldaiwDeCRRX1BVjl66KGDcU/Vh7d6ePBeNsoV5TROmOP4AY1tnqulv3TVDvmbP7/FzPyXPlZxy2lDN7Gz70vG4VSy1MWU9kUslbHtK2wB6CidmoYq9mQVeUna+xkPyL9xYyA6MuRkCXqGk1FnUxQ0t8mkcsxlUwKUmX5Z94NKk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Note that it's the merge window, really ideally you should be saving sending
non-RFC series until after the merge window closes, none of these series will be
taken yet and you'll have to resend anyway)

On Thu, Jun 25, 2026 at 08:32:43AM +0200, David Hildenbrand (Arm) wrote:
> On 6/25/26 03:50, Rik van Riel wrote:
> > Sometimes processes can get stuck with the mmap_lock held for
> > a long time. This slows down, and can even prevent system monitoring
> > tools from assessing and logging the situation, because they themselves
> > end up getting stuck on the mmap_lock.
> >
> > However, with the introduction of per-VMA locks, we can improve the
> > reliability of system monitoring, and generally speed up __access_remote_vm
> > under mmap_loc contention, by adding a fast path that does not require
> > the process-wide mmap_lock.
> >
> > This fast path is only compiled in and used when it is safe to do so,
> > meaning a kernel with per-VMA locks, RCU pgae table freeing, the VMA
> > is not hugetlbfs, iomap, pfnmap, etc...
> >
> > v2:
> >  - simplify the code, which should be ok because these copies are < PAGE_SIZE
> >  - clean up the code
> >  - fix locking wrt tlb_remove_table_sync_one()
> >  - hopefully address all the other comments

This is really not sufficient :) you should break out the changes you
make and who suggested them.

If people give their time to review, you should take the time to make it clear
you've dealt with it.

>
> You mean, ignoring my comments about not reiplementing GUP entirely?
>
> NAK

Yeah agreed.

As replied elsewhere, I don't think we need to do that anyway?

But you _really_ need to respond to review inline so we can have those
discussions and ensure that you're moving forward in the correct way.

Just quietly resending with a catch-all comment as per above puts all the load
on us to go and check that you've done what we've asked.

On my side, my review time is very limited now, so triage dictates general
dismissals when the series looks wrong, engaging in discussion will help us all
move forward efficiently.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

