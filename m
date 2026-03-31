Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93BEC10F92EB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 18:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6B16B0092; Tue, 31 Mar 2026 14:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57946B0095; Tue, 31 Mar 2026 14:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D226B0096; Tue, 31 Mar 2026 14:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94CB36B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:47:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52EB78B50C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:47:40 +0000 (UTC)
X-FDA: 84607241880.07.55904B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B38D1C0004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:47:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hCuxgfhk;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774982858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5fx/dab+pVL7aD9tN8uemN9eSReBjb0qsUrSrv1ddg=;
	b=RbMivsqbNa9W4Gcdsj10M5OMhlMUfCILS/OnEySiSjtAMxMPqLRnH8UKEPchS4lbCZhqMi
	fNmGcQefiUOsCg+D0PwTg8U66B8c/33R952lMcB2BGXaR4+LXDPCBLYSVlAlIfqajWz+oy
	TtpxZUI73AcP/sBpYha6l+mN2omrJt8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774982858; a=rsa-sha256;
	cv=none;
	b=hvBfAeOKJk87LdS3smQQOCxJBlQY5+urxICTE+KUQH2dvw5Q9UUDNFED+NermY+1NzZ6gk
	avRLUsuQptJjSOBocWAjejcD/SfthcFfU2kxWa1XnQf+nBoFjkYv8IujBRc8cgFodTUdhw
	ARJE7576/PUdlcwWLn4e9G38w/+sH78=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hCuxgfhk;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7302A42DC1;
	Tue, 31 Mar 2026 18:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0779CC19423;
	Tue, 31 Mar 2026 18:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774982857;
	bh=CUmvYJ+q9fr0CWu9PeM2hiD4yICAuMHbTJnAtOumyIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hCuxgfhkhW2T2Q50p+f5sEFLu1o0vSZtLrAfwaZoDPLQotj+9CrNSTDt99ktgypf0
	 MqMjS1oLLVheBrOv/aoB/sQc9tYjtIjC/ON9njXZ8nlquEQUpcy2R2Dzu3FqVm9JRJ
	 737vuu2fWRDxzXosqSJOW5RbqspgpR3kk6iFFWJbqzbyiGMOEl6NrLLshNFasROsd4
	 IM20vPN1u5cNPCMCE1aKuMkErL4MqR9RU85mu2IOedMimZ6HxcwaaMDeifSkR2Ht24
	 990T0kFs1K2Gzus8kty9SgWt4RW2zATT8xfXIbGYhsrGnfOjyG2IoPG52Z5DLh85h0
	 r0nRshjuR/m8w==
Date: Tue, 31 Mar 2026 19:47:30 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, willy@infradead.org, 
	david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, 
	rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, 
	maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v6 2/6] mm: use vma_start_write_killable() in mm syscalls
Message-ID: <cf6975a6-336a-401b-b122-b9597b5710b7@lucifer.local>
References: <20260327205457.604224-1-surenb@google.com>
 <20260327205457.604224-3-surenb@google.com>
 <5d90d998-9b8d-435c-b684-260600311797@lucifer.local>
 <CAJuCfpE5w8r_6Ss=5ZPrEb1RQOTG6HyY8Pivac=iiyqFRZvD4g@mail.gmail.com>
 <20260331112921.854d4f6cc793dba0972ee9f1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331112921.854d4f6cc793dba0972ee9f1@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: yz8z1xay1k7jzp1acyk4bi3d4hczedd3
X-Rspamd-Queue-Id: 8B38D1C0004
X-Rspam-User: 
X-HE-Tag: 1774982858-698742
X-HE-Meta: U2FsdGVkX19a96kiAZ0dQAnOH7A/0NTwuPRs07jc7ffj6YdxdUFSVV9e/k/UzUCHGL3wFpXrDPEOJLIhFn4fcVutqOQRLYUCtvQ5AhMf9ddaXkB4iDw+FqixDX6WBixJeER6abpbU/+c2JVQlUS9TPYKojY9QTyE10MSyrYE1CQoV94v7g/6szyqkfSTWxEVxQRPpNiyALaaCFaWsWFg5snW93lXRVaPd66qdw0Z09DkNPhuYHdOTEM38QwjwyVsvaxBODu30Ar12IqIwVQrwv+lS3aKsCvAut+W/m6wbiY/0d2gN+vubazpqU9Bp3pBVRp6wH0V3LAOpJoqDDOq/eTcnxGA6ghMapQpRb5or9b482d4SdWMoQWeM7VyTGa0P7FxDMNSmrQ70DTwuJFoNNXnlvVH3FbOu9uQrUyAJPOcyiFuCe9ru1uCPt41viybGTX4gAuS9YmPp9ZabdrvA85Wn+EDJBuCxjD0L40G/c8FXD9so1ZJ07IKcqrGQAIkD7vLGfT9szT1IrWTfRhYeYkOb/FykzkJ2Cyt1ACkvajZrmjCykHv6jwCkXTlwuqAh+aIN6oe3N1DTUk884ry1aP+ZRZCo9+7mWZRVgGTHkkHh0Ix1dubRXnS7K6Np7wTQIFzkNoCOK/pekWEUBN6g5DgMxS3YtzHct4+yq3kZ01bZRCGWYtxGGVyUWbREte39jc4oloKAePLa2XGFYq5s2T3g2Etct78ivuCzVs0Yj07e5opcMU1lOIaPLNYqWF/V2MP8w9M/jfjlqG2vdtqhzZ2AL1q5LGwhPbYWwM1ZQwaSnhmvLUPlDpzSyJB9YM4RHI3mbmdwPiwu7Pe2rSG0fQFu8Jr9EVpAoQwWyfFT+7Iphav+GvKiS+oY0aW+LCzIY7aw28C3QPdVcAksXiITVFsVEAB62FkgEOyVYv4lvXrUQCB1NgxL1/06bYUQ6VtL3saVv5L73uJ9r14F3W
 3hUThFqS
 XT8Iwe3Vy9P9FHBMD9XoTVIg24mkJejU1utn+CDP73z46/5v/Vpf50u26tu/NeNa9g1RlQIjCvYZR97T97ccNo2EqUAriOd0UxOHIBzzYuOZSPgTX7/kDJk2+dPpEJl4yQkK8ErXHibA7unhtT5QV8KqXLUHD+6aa1v/jk6O0AmWmhHzxF55Q5htpf9S99hD/4zAzjqrZoccbWqwYwniWKRG8XhAZ+CAEVh78bLup3ngyI7ZVXrMEDtTbwik70kGyAxMS1o+qTpmesXe0fVr6IfNoaKqNZZ0+PPC+CmB+EQbzTskCAyTi/Nz7nJF/MaNsNHSzpMPM/wpqwpC7o+Q7htocX6DvKuEsaMOZiHIZefxzLiwPI2hIrKISp2oq8nZ7bJ2y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 11:29:21AM -0700, Andrew Morton wrote:
> On Tue, 31 Mar 2026 08:01:11 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
>
> > > Instead? That is, assuming we really need to care about this at all.
> > >
> > > But I think I don't like this change at all?
> >
> > Yeah, this was the part I wasn't sure if it's worth adding. With your
> > vote confirming my scepticism I'll go ahead and remove the parts I
> > added to avoid extra vma_start_write_killable() call (3 instances in
> > all) and will post v7.
>
> Thanks.  I'll remove v6 from mm.git and shall await Lorenzo's advice on
> v7.
>

Ack, if we just drop the problematic bits we might still be fine for 7.1 :)

Cheers, Lorenzo

