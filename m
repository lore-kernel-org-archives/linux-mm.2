Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C99FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF376B008A; Mon,  4 May 2026 04:01:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB62C6B008C; Mon,  4 May 2026 04:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3B66B0095; Mon,  4 May 2026 04:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF6A16B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:01:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E0BFA02E5
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:01:15 +0000 (UTC)
X-FDA: 84728992110.17.7BAAED5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id BDF3A8000F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:01:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gxLS0mqE;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777881673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6391mxTUr1WVmO0k6M3035hZd2l92eA5g1GJUgBhGI=;
	b=27IFvXkLwX2VM5JotTQE/x0VLwPoGV4LZumdeb1uEXYOjnBVFFPHCeegOFr1Hf8t6ug+C/
	xyawo4Haef7ZE2LjFd+YhWHMZWS7sC0CtCPxfeJj6UGVlXF9ekwKbeD+IEtFoUWnylvn0P
	oo4WKxW1M+ODPtMgkOiJqq8PftCldHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777881673; a=rsa-sha256;
	cv=none;
	b=x/RySUigXl9Ci8ZvP5dJKIb5xnqmEVUQJhagP5i360InnQq/0ZKT4bVo85Bu5FUe7iL5Vb
	Y4NBSznd5RT6jVwFROHUaZsZ1SBLBXmMJkR+E6lG5U9fAKLCO5nf3nUmMmQvD+/8ywcp8t
	zxnYpvaE9mrGbz+8NGaDqu7Drvh1G1Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gxLS0mqE;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5BAF43CCF;
	Mon,  4 May 2026 08:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB3DC2BCB8;
	Mon,  4 May 2026 08:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777881672;
	bh=g8WxYRXB8kS63CKZCS/93KxG1y3PKdaKScohACydG4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gxLS0mqExC/0/8egOY8GbrLhQQQjEBQbz2/suB5bEmem1CHvN/rwnUB3ZTFV5Gc8c
	 xn/okk/WKMfZIdutsPfTVk+0t0sBZ5g1P/WZchX7f/oFLswVrirI/71LSmbMw+PO5O
	 a+Bkp/7S94mzRg1hWiR9DIiYJtLZQT9NXCxYWDhvMRwdq7a/TcgpIWKsIg1ygWwIcF
	 PHGqYdJRskyH1m/5c7EHVuVMK9AszRfhAjG+n6ONgcDyvl0ct6k1TsAIr3hxEXc+nz
	 NhGBWZy/i7mLG51GLWF21FqUe+ki4zRszzyqxb5fsBVYRQp/ClkYbhU9/dQuL5zoeE
	 Xbd+KmaNFfmXg==
Date: Mon, 4 May 2026 09:01:07 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Ryan Roberts <ryan.roberts@arm.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>, 
	Barry Song <baohua@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
 [RESEND]
Message-ID: <afhFEQfC-nISu-rj@lucifer>
References: <aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local>
 <afWcMyc5M4vViLJd@lucifer>
 <8c729d621f281dd0b1a891f4aaccb0ba4956b219.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c729d621f281dd0b1a891f4aaccb0ba4956b219.camel@surriel.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BDF3A8000F
X-Stat-Signature: 8uiszg3bs1xsgxanjjcx3upiby3rc4ju
X-Rspam-User: 
X-HE-Tag: 1777881673-166811
X-HE-Meta: U2FsdGVkX1+S2GcW+09sTRILMGbkbTGQO7rQ9BnYh2kXo2qR5g1zHapf5FGsPXP0nTWMF/rFvtDsPV496r4Bkl/Xp5GT9FSzm/ynXOtkPkbAKOE0EFRPX3TmDrPW8DZzp5C8UiSglNZBN9HQn7h5OsPHSYbkHq28ipjeJkO+HqmlH8iEpEVnh5Rii6HLk6vmRnAj+D8l1gEkyGcHtNMQt7xba/ljijA9+XU1CVz4CYEmtQ11lYTmgDdxCJ5I73n6KAdIeD1gIbXF9fPJYvkHcpI0fY7xPX8cfB9ao4Gh0OQUd74Oi/XGRAMv5kj+wMcAlMp/Ej3DgcRRR/KQja9XiMk7GVvWvF+3E4MgNPSHFiexcTj1It2/DGU/JT7pocsXMIMOOJbUI9yMBuR8OeopZrDwsGDpjeyZpDwdjkoUf6sTtvQKRW53IWnVNP/xMQFdcDPktDYCIMK4MCgUbfzZ+qdNX6byVRCxIPXd3MLFh+SoaHF/qAUqC9BgtbaJAeAKeqsbtncSCCD4flT2l8KuRYN1IscL0DUCBBOvoDis7URHeMGW6c1xKeJmaIi7p1N7ybDAHPepTsKRMJTfj4k89U1go8N8kgGl1kuM66rOf3I4RkQSZO1EXqFh+1qi+sbwoudVdvji7E+m+zu+XRwqmEOZ0MYyWkNgi8HHSf1MuAFBMdcW+9/WQr149fh+k4X/AUK4fIhxY54OzncwMZ/uign73vXpUynBnb9UJYIAAYplta5ddRi52n2mSFXZAHuEVJn2BmFj464jlEk/ovhCPvEYqV1Ivb8uw+lDmFUtL6pDwhsdEz5yHxXjGwLJdavYS5Me69IXdQ01BX6bOWkfpkOCwjoaIkWqM8ZbiDyfaGkhBqgYDXm73tBPJIkuT7rtwpxFtmeQLUR9sxF7/oM7LaWZsGANbAb6eGmTwwzBz/y7fClVhM95gEYT0QrhHLxbTmoeHlOZ61BAVfu2wSq
 xHXHoM+q
 gNY7qZmIleUpGWRPircBuntw8kacHoDtlCGpEiiJNFqwYUA+NFXC8/GxMwN1tBRf043WJ8WCTBy1jP/dL8jKVmzobjkwXdASsS3vTEXENV5mUE2AbB8i1tQnA5d0HbrjqqCpyw3PaTJLX+6mkA3eV7hdDZveJWdAN63+dBg4qpHUtmdvAZNqrQ2xmNMH3a1GLv4NSeAX67eEXpNk1YmeKMer+yrDSTVSYn0M/0GsqlE8VFr0tYF6UbtLJ/kxitavgS5pA5DdDQNsKNWivPuorS02onBqxSbzJJcqpAXcKofta5jA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 03, 2026 at 02:26:36PM -0400, Rik van Riel wrote:
> On Sat, 2026-05-02 at 07:53 +0100, Lorenzo Stoakes wrote:
> > As is time-honoured LSF tradition, I am sharing code for my proposal.
> >
> > I worked a very long day yesterday and got the _very_ rough PoC code
> > into
> > some kind of vaguely shareable state.
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/ljs/linux.git/log/?h=project/cow-context
> >
> > CAVEATS:
> >
> > * The code is not great, it's 'experimental, wave your arms, hope for
> > the
> >   best' stuff used for experimentation.
>
> First, some refcounting that confuses me.
>
> The changelog, and the code in dup_cow_context
> shows that only the parent's cow context gets
> an increased refcount.
>
> However, the code in __put_cow_context seems
> to unconditionally decrement refcounts all up
> the hierarchy, instead of bailing out once it
> encounters a parent that still has a non-zero
> refcount.
>
> How is that supposed to work?

Ah no it does bail out :)

This code is very much PoC so not perhaps ideally clear :)

So __put_cow_context() calls delete_child_from_parent():

void __put_cow_context(struct cow_context *context)
{
	...
	for (curr = context; curr; curr = parent) {
		...
		parent = delete_child_from_parent(curr);
		...
	}
}

static struct cow_context *delete_child_from_parent(struct cow_context *context)
{
	...
	struct cow_context *parent = context->parent;

	if (!parent)
		return NULL;
	...

	if (!refcount_dec_and_test(&parent->refcnt))
		return NULL;

And only if the refcount drops to 0 do we propagate (because the parent
being dropped drops a ref from its parent).

	return parent;
}


>
> Now, having the remaps array cloned at fork
> time does make the refcounting on that side
> a lot simpler. I like that.

Thanks :)

>
> However, it does raise another question.
>
> Say we have process A, with child process B.
>
> Process A has memory mapped at address X.
>
> Process B munmaps memory at address X, and
> then maps new memory at address X.
>
> If I haven't missed something important, the
> remap table does not need to get used, because
> the offset and the virtual address match.
>
> How does the COW walk handle that situation?

So in the example given the folio would become AnonExclusive (or rather
!folio_maybe_mapped_shared(folio)) so would only walk process A.

If you unmapped in the parent, the folio would become AnonExclusive and
then get moved to processs B's mm's cow context.

So it'd work perfectly fine and be efficient in that case.

But in an example where say process C also forks so the folio remains
shared, we would end up doing a useless walk into process B, then find
either that there isn't a folio there or that the folio was unrelated.

In my slides (I will put them somewhere after LSF) I argue that these kinds
of situations are likely to be the minority, because most memory is
AnonExclusive and that which isn't largely remains untouched (i.e. all the
walks would be valid).

There are cases also where anon_vma can do useless walks (anon_vma is at
the mapping granularity, whereas a folio might or might not still be mapped
at lower levels, assuming not moved by folio_move_anon_rmap()).


>
> Overall, I like that you are trying to tackle
> the problems associated with anon_vma, but
> have to wonder if this implementation will
> be able to avoid some of the complexity
> inherent in the problem space.

Thanks :) And yeah I think unavoidably there were be difficult corner
cases. I also don't suggest that this approach is necessarily going to be
the one that ultimately works, there's a HUGE TODO left on stabilisataion
(esp. in the migration case), and I plan to do a lot of testing around
latency and edge cases to really exercise it.

However, no matter the outcome, this should give us insights into the anon
rmap (and the testing work will provide a good testbed too) - so either
way, I am determined to improve the anon rmap even if I need to look to
another approach.

>
> --
> All Rights Reversed.

Cheers, Lorenzo

