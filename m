Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF15EC01CC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E036B008C; Mon, 23 Mar 2026 07:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7946B0092; Mon, 23 Mar 2026 07:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA00D6B0093; Mon, 23 Mar 2026 07:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA9C86B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:31:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B732160B4A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:31:37 +0000 (UTC)
X-FDA: 84577112634.29.5B6B906
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9613120008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:31:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p9bPmzob;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774265495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhziJECue8XJWzdMSh2HEUgqs+nPNBM7Y26rRz7w8gE=;
	b=Zx7q7KIzOnzhtacqT5/WTDWn+wl32jlrr7siniPGDqp1CPSxCwyiO6J3Uu52TcyuMMPaBj
	qnMOK6oxuwKziSJg1ZQrRKp1GG6tjpi/1Fi2nkDK9Cnya95fjOnjNP1YcGp/SmICiipVJG
	cxc/ud1k7ju6RhopCOmguNzj41aexG0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p9bPmzob;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774265495; a=rsa-sha256;
	cv=none;
	b=St8hUKU7dAxwxFQPqSXw/xoo0/9JjL2K7+Ixcx4vhvjqjJ11QendCh6nrqjWAlPD2INE8c
	sNmAvhXrWW32BlTHotC4PJfB/Iv8XqIW8l7R1W7Q/pcLDzUc130dXxydypW4CyBYB+RIr6
	9p3Z7nbDAA3iJAUyHt/TInFSv9jBjNA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 911FA41B69;
	Mon, 23 Mar 2026 11:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F168C4CEF7;
	Mon, 23 Mar 2026 11:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774265494;
	bh=NcOYolYnjCWmwEsm8Cl8P/3RRbyXeO4093isKBT05ss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p9bPmzobLbl62wwLE74pDZaitcxloK4Nppy9v0gfN2XgGBZCPvppvBOdCqEdnwAzc
	 MWwqCSdS0zpVhguesU0V0Nbj8T6NrOhM7vFGkxokmnh5+0bIMFEcmIzbcDD0dQ4EyR
	 c1+iNmbcFlj06nDt36xh2O4t/1tHMfEP2sKgTtEi6BDVwgHx19f0vvGCHBEkZwR02z
	 OD/xoAJrSkaNesB+jgss8VbpaQd8usAnS8vsZ4QRWnKPKtP5/DWpucVCKG+jtzlsYq
	 HHNfrxPWwf0xznaoX/y8D5x8CbFyKz4QEcuU4p4mIKC9FRrmPytbT/fYWNelQYOnWe
	 aTXVocCqXWk0w==
Date: Mon, 23 Mar 2026 11:31:29 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-ID: <5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
References: <cover.1773924928.git.ljs@kernel.org>
 <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
 <87tsu9kgv3.fsf@linux.dev>
 <20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
 <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
X-Stat-Signature: 5pewdjcc7s858r4deb8g85g4uetxbdmy
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9613120008
X-HE-Tag: 1774265495-540312
X-HE-Meta: U2FsdGVkX19H1Xxr18gfumJBoL5XY2/SIzYots5YdTBsv2x9w9ptOkZrr7AzH3wTN1TltmW/SC5ka3ww947vDuu7V1IEM6RbSHUYS5+r8tmvDyKPw9g6NMGgRaUMGos4SKJ+dmRwgEOVBtfoMR40YGUX5zjbhK2I629dVnzhzvs/LPgMMgqlnkQ/2vvVGLrEA45p+Mn/DyAnAix8+jdx43PYeZcg9cSHSZ04mwbZU08p7PbfCk+wts4L8o+utfsMQyRmu7V9dK8EV9arYLk+IjmxXVmeTET9GVc+pDLgZV7qfnb/W2IaFivMEV965fDvcSV67SUUAF6z+lvqKTDRzs+fF0EbHZXM12V9+GkLCCYfKHJz299IE9TKJQjtGgXUM7kcLSYT/fiO4JVQo/n2kVNyItDu8fiDuulCrMAa/OyAxrZM1rUgfDhKN0wOgqL9slvg/kght10qieea3hx8N4cIGinHkXDvHen1unsv14AhGlc4GfqburoJ79Brt1etQgiurZ58oWIolFEb5vIH0jeEO04bn+GQ6DtlQ1EfqFTOmr8AJLclTlkTmm7o7ANHICYTqtMn8tkkADhbUPLzc4PaUcuzKaJYz3EckC1dwAQidXcXKpvROiplUYJBpYl/5xcUOU5kziJsPuulkiek6qlqinPtlz/y6Cr0SqASqbFAhXdE39WT1AC/tyBvUXw1jmS2N8OfVhz7fjHpTICynIM9QwUCWIsp3xXyD1qSzkMAVIyY1TcR8Wzq/MaB4HKXKHEWWKe/7wld0NB+0T6ExDlH3E4MubwOkFK4xOw2bYbEZChFFgktFpTKl/jhwuYCmyS1ZMXDFq7yhm94L3hC7cjJsXdwvmxCssnHnO2KuxIG7yb9JjtuYGKbXQnPSd9ohewrw5P9VSqMZKoIzQqaHFHDkuKZ7jNPkqdUJDi6+Qbs87XAm5UcS5xyf3VIjX23LnyYV6NXSfGtREV/xp7
 OVxe+bRR
 ubZ9GckUPyFmDlvxwN2c+p4pV3UUsp4GG2zXqs2R6R8OYk3gP70DfZfjJziczDRFU9ufkHqu0CVXqhLncusEurOm+U+aQpqA809A6hcfwmNNcD5jVxLnaJuhqDKT0Hjn+12DCBAGyngyUEH2bVqjv9idaH1pOTRKb4zVruvqSKikK6aUMphp/aH2qIZRYCfms0e+moEHFOLTMZZM6ScnKkZZiyzg19X4sFPeR5QXRaA1oc2rW75s27umZl+Cj7dymAQ2kGFK8RNhOZTPnLXeUDrYUUS8mQWRQ+kvbN5bbP8wIXhS/eAtzk0BjJW04UIZ1YY3n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 05:15:30PM -0700, Andrew Morton wrote:
> On Fri, 20 Mar 2026 20:33:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > A lot of patchsets are "failed to apply".  What is Sashiko trying to
> > apply MM patches to?  It would take some smarts to apply the v2
> > patchset when v1 is presently in mm.git?
>
> ?
>
> The way things are going at present, I'm just not going to apply a

50% noise vs. signal?... maybe wait until we're in the 9x'%s?

> series which Sashiko "failed to apply".  And that's cool, I'll just
> wait for a version which Sashiko was able to apply.  And then not
> apply unless all Sashiko questions are resolved or convincingly refuted.

Andrew, for crying out loud. Please don't do this.

2 of the 3 series I respan on Friday, working a 13 hour day to do so, don't
apply to Sashiko, but do apply to the mm tree.

I haven't the _faintest clue_ how we are supposed to factor a 3rd party
experimental website applying or not applying series into our work??

And 'not apply unless all Sashiko questions are resolved or convincingly
refuted.' is seriously concerning.

The workload is already insane, now you're expecting us to answer every bit
of nonsense Sashiko hallucinates or misunderstands also?

I say that with no disrespect to Roman or his efforts, but as discussed at
length, it is not ready for prime time yet.

It's clear that Sashiko is not correctly handling applies, and produces a
lot of noise. Predicating taking series on this is absurd.

Thanks, Lorenzo

