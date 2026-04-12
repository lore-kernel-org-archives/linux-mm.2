Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B86B3E937EA
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 15:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068916B0089; Sun, 12 Apr 2026 11:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019D36B008A; Sun, 12 Apr 2026 11:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E727A6B0092; Sun, 12 Apr 2026 11:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D3CD76B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 11:36:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8356A8C8AA
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:36:50 +0000 (UTC)
X-FDA: 84650306580.08.044BC86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B4D1140002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:36:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgLepv1m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776008208; a=rsa-sha256;
	cv=none;
	b=0q99Uvz5pBN8PMC1ZTYCxe4lHiBl+uEc5XYXerGYsQ3FbGtr2ZWil/TvgwpqPTX8WjLUy4
	OzOqdoCQSeZOtWKsgxrdkpRFE7F24uUbfpIE5BkpQpoR2H7lkBV0rsWtNbFR6jrIwbc1N4
	gZn4HkjzFK1jTxIDqpBRbo6ib9dKLGc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgLepv1m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776008208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unSq7PbNOTlhklQT1jPRYJ4nhdVlF8kzA752Yfm8H9Q=;
	b=WIp5wmrjeZiV+JOGePUMorncdOVhXsvmvahi5Zsk0n3IPz/PBtCUp8JUkA70e9PcmN+oWE
	EpqlqF9uR7qgFBtV1gJ6xaVdy4m0Hri1hjM6ksyxBn1SJR592+06CJztaON2vfQHCzSGHC
	kbP4dCPr1DwMT5PjKzEbUESMbWOnwVs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 753B6444A6;
	Sun, 12 Apr 2026 15:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED54C19424;
	Sun, 12 Apr 2026 15:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776008207;
	bh=JqsLH+Zb+NtHMqOAf4UeimGqJTVIjcjxFFcutVJhpAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TgLepv1mSZVG7YhtjLNhGH/h79jbc/xCvLnMYmzhDtREE/996RhdUkGfFe5CEGSdH
	 iB+b22DN70NUh16Y1iQM2pyCHmo4y8yGb7F7ht3gJyArGmAQgoW5yewdxG0TI6ncn7
	 MzFEc6njTNvDsB8OAThrIgN8KQId9pBalE7Ylcfi4/ueb74fSH2ZSrjlyKilK9+p14
	 6F4dcWdOR7Iy7pht5nZKMoePy2rE0dN9kEaL2b3k/nZtXp8z9T2PcIjR8YGjwdsWvo
	 FWpsglhxfJqfSjUq+cvPaAg33DYqPGNTb5C9ruPg4v4H7ll33zArYdCUv6Zb1nrJ1B
	 MNw6uc/Y+YU4A==
Date: Sun, 12 Apr 2026 18:36:40 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: David Carlier <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] mm/userfaultfd: detect VMA type change after copy
 retry in mfill_copy_folio_retry()
Message-ID: <adu8CNz2USFyL2nN@kernel.org>
References: <20260409120653.290386-1-devnexen@gmail.com>
 <20260410114809.3592720-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410114809.3592720-1-usama.arif@linux.dev>
X-Rspamd-Queue-Id: B4D1140002
X-Stat-Signature: rc34uxb9tw69pi4o6yp9by8chhnb87zu
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776008208-959409
X-HE-Meta: U2FsdGVkX18rpdhh7ACdVL4tkG1M+EoMkYonxiZJ8j5mvCF4nBvI9S+PQ+Jh/KPOSfW6f6VfItT60WBVbcfjBocH19Op56ty1hVl4JoMeqKS8WdQ+tpQreRen5fwvjEfT9gfnF/s1b1OrZsGKJr818FoxmOMsyn2AFSuY9CF//hdOeKUHgj/kdHbQXFGIqv7HxOKKNOGgPaxGt58jpRjTUXvvXkjJWBhxJdTSsg5Z5rYwMQMSDG58bDfuNsatHSVrN2Bv6CXGXZxzJ1qy9OtvmYhLAqLzqjdYQBmaYj/hF+GTFDFPe107Ao8GIsPxzBeFi+8dY2xPO4YQUqGvW3OIHJ04hCg3ZvbdXTp1FBHnfTdkvYfxdmrJKqeRF8VtY0QrTdfj3NWcD9Qec0pGv6Ry7wHjeESBoI8PJgs5b+P+jBj0rNi+3798Qa0cUFTX53vUfPoOhHEg0MU0XsgIb60hvzb7Ym7zCy1WyYkMSr8b/gNXc4rb6yRx2s2+5gUhXwKmPcusZCNu8TzIx8OJduDMyKaw4Lem8eX0iAv/kQaHiVGEqYWXjI8iv4M/8ju4F6vyNejEGcKczJZe+mQ3l3NmN2Siu+5Wy7A0mv/epSEy14I3bg5dzvwF4/r4P0z6nEX5nHAHJ794XHFIJf3sXOSTFez9tfAVUsBoDI01G/E0mTkXHJTdrbVLaMw8fjFJTeszEXE1cUVGd1I8mNEJAx4KGqApoiTECk93pkJ5QePPthyX+uK5WcP+4qbDdmqWQ9i3UjidhTskG00bVk9frFQDf8bFPUtHSMWXJBdkKi2dKEmYPqS6M+zjEj5aLPUG0Z2aM/EAtOs0j5mlXRHwRTasbZ4VWbBVPNdKfnJW6eAGXUpz1pHg5hD2GCItQHchol/IhWhXA2aQkP5un4j2ZOiCr0/i7pGhPJg9PZubfqtZPwo7kAm2GUtKjHIVjh06lzoCpEvvdYtN/N8qHLplOa
 2AfQBJZM
 EktmewwUfJaYc+R7K8dD5dQJrQ89QnA0Ya7/02HC/sZsW78G7IgkwhsihL4UYF0X41qZMInfSFiN+MWuAZd4Ugp9UiSoiXvSAjN3/hSugpBw6cT74cs1jYEKUEDmohWG2eEsNaasBCAtnpMgnKGwxsix0P8lkE3oL7qm/yZTKVbynq02HcUs63pMIX+oLSFECWpOct21dp8wqJCtotWFFAJiU1a7TjXuKckpaUPsfewAQ4SVqkewMXLm9TRuwyI4CCIl+nVSG8IhJrysyXxUh9ZEjzQPdC0xkj/U1LanCOigjEo2YYdBpj4NKw2VVXjSFNxHFu5tWhjuBq4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

On Fri, Apr 10, 2026 at 04:48:08AM -0700, Usama Arif wrote:
> On Thu,  9 Apr 2026 13:06:53 +0100 David Carlier <devnexen@gmail.com> wrote:
> 
> > mfill_copy_folio_retry() drops mmap_lock for the copy_from_user() call.
> > During this window, the VMA can be replaced with a different type (e.g.
> > hugetlb), making the caller's ops pointer stale. Subsequent use of the
> > stale ops can lead to incorrect folio handling or a kernel crash.
> > 
> > Pass the caller's ops into mfill_copy_folio_retry() and compare against
> > the current vma_uffd_ops() after re-acquiring the lock. Return -EAGAIN
> > if they differ so the operation can be retried.
> > 
> > Fixes: 59da5c32ffa3 ("userfaultfd: mfill_atomic(): remove retry logic")
> > Signed-off-by: David Carlier <devnexen@gmail.com>
> > ---
> >  mm/userfaultfd.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 481ec7eb4442..214923a411c1 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -443,7 +443,9 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
> >  	return ret;
> >  }
> >  
> > -static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
> > +static int mfill_copy_folio_retry(struct mfill_state *state,
> > +				  const struct vm_uffd_ops *ops,
> > +				  struct folio *folio)
> >  {
> >  	unsigned long src_addr = state->src_addr;
> >  	void *kaddr;
> > @@ -465,6 +467,14 @@ static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio
> >  	if (err)
> >  		return err;
> >  
> > +	/*
> > +	 * The VMA type may have changed while the lock was dropped
> > +	 * (e.g. replaced with a hugetlb mapping), making the caller's
> > +	 * ops pointer stale.
> > +	 */
> > +	if (vma_uffd_ops(state->vma) != ops)
> > +		return -EAGAIN;
> > +
> 
> hmm I am not sure if this is correct for shmem MAP_PRIVATE.
> 
> mfill_atomic_pte_copy() overrides ops to &anon_uffd_ops for MAP_PRIVATE
> mappings:
> 
>     if (!(state->vma->vm_flags & VM_SHARED))
>         ops = &anon_uffd_ops;
> 
> This overridden ops pointer propagates through __mfill_atomic_pte() into
> mfill_copy_folio_retry().  But the new check here calls vma_uffd_ops()
> which returns the original file-backed ops (e.g. &shmem_uffd_ops).
> For shmem MAP_PRIVATE VMAs, the comparison always fails even when
> the VMA type has not changed.

Good catch.

@Andrew, can you please drop the patch for now? 
 
> Maybe save the original (non-overridden) ops before the MAP_PRIVATE override
> and compare against that?

-- 
Sincerely yours,
Mike.

