Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45F6FCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5C628E0015; Mon, 15 Sep 2025 12:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33DC8E000B; Mon, 15 Sep 2025 12:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970F88E0015; Mon, 15 Sep 2025 12:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8628B8E000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:36:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30F5959A14
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:36:36 +0000 (UTC)
X-FDA: 83892037992.06.EE4B723
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8322740011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:36:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iBuxdlii;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757954194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVfY8snGhae1gNVF6XV+gVpmXREYRrkvAAv7AFGFTJ0=;
	b=nkvfedm5EVMWdeEz14gEjFhLQHZ/AyiPVaZU/0py9suFfTmya14chAGjZH9ByJf//xlAqY
	z5cTDWMOgArYxfOWk469WqJZZtJs33JqPFWBC7XfMP9S6ffpNQYaNvXaNFdl/R37pCKc7n
	takCjOo865pKgcBvBUh1OIJR1OtFp5w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iBuxdlii;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757954194; a=rsa-sha256;
	cv=none;
	b=am2d5+C7WfXiSj+KqXeKzEvEjmJ40pXcU+Gp1764K9ZQUfNxgXNQrALX2HVwE6kYP8HVHa
	TW7S7n91hdgm0A//1uzjIfcPhW8vR6fkxB+iMhXBdJfKm64C/bEPmg/TG1Dg8m8XEGBr/1
	E4vkNJpWtI4/XwtXF3CfA9nZry3Qy38=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1148043797;
	Mon, 15 Sep 2025 16:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC6DC4CEF1;
	Mon, 15 Sep 2025 16:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757954192;
	bh=sFKlwRvnlnlP6/mO1ynOhYF6GOBs7Psz7KEyq9qFIiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iBuxdliijQWhpI3RVo+U8XJ/DnLZLfEukHRGl5721bxVKLIRHJVBjVfEKt6DfjfDS
	 whr5dFX9GZ6VWpSc7K8qe7RgRSh8AXt/Q9HJ1GOX6YTcO1FC3RNKjKiHZwf8/HVKE2
	 3IS/132qNOkP3R4c+xN7DObUcd757ZWC0tV0bAEPWBtvibWJzv3Vo7rHUchhvjxPpE
	 yR0ebyLV07fhRUVR22SpSRPYQCADdXGxUyGjlbPrZ8H5U/+j5jG67Q+Q6uG22akisP
	 uiJSaBX5O+jYoSOPl+t1jkI+dfk5sXJv05nhJq47C05CIAauKvtVfNqS9SVy8s1ptQ
	 m7BXo/kR5iHyw==
Date: Mon, 15 Sep 2025 19:36:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <me@yadavpratyush.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kho: add support for preserving vmalloc
 allocations
Message-ID: <aMhAiR6qnXMA-c8r@kernel.org>
References: <20250908103528.2179934-1-rppt@kernel.org>
 <20250908103528.2179934-2-rppt@kernel.org>
 <mafs0ldmon784.fsf@kernel.org>
 <mafs0ldmnlmq0.fsf@yadavpratyush.com>
 <aMgey9qEC_XUejXm@kernel.org>
 <20250915144335.GL1024672@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915144335.GL1024672@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8322740011
X-Stat-Signature: odzj6c4nxou8oikkosost81aajzea563
X-HE-Tag: 1757954194-584254
X-HE-Meta: U2FsdGVkX1/tapLvCqz7lbNRBUyr3n4+Xds4ezt/MEfqFXs0cUtxjNoJw/+rOvZIqUIVUcuoGJd6W0ZZZPer28ie249jpZOkdeFHZrc2cugt55Zq/Zt/qnVILxse/u65yKcwkYIHOjeCj/6rngesmFkupZsKxxYOVkC2n4W0APaurFoLiWLR1Hh4a22m4TgjWoa9/3oRadUVNFHvvYvey44U0bFuB/TcFCyHJZ2cNB7Uny27NwGdd72L2MW8400mSpf88rwDf+es0Wxl85S7rTp5UBS7801GFBqygqc600lrGkTTpOZ1mRGITPeO+R7WJ7SPMsG8zTT931Dn6bxawnSJtd/U03GbA/6N41Nvloqs4/3MoqkupEBE5vxDe7wMzpt+2+f4mrgzkhTB6ysy2SNuoEnhmL7Ti9rERZZVXThh9sH38sF9L0ovSxoRqv8/8HTGNKrxtj1gsKcXLT7HtSsDbqj4lxRPdCoeoJiCmLok4b3OudljjqMFU3+HQX4WuhOoK0irN04MrCjt33ZgRJMe5a+mpLNWSqg+aDXydyG/OqWk0IDt7rG04H356MqFLQDiBiUJpb8JGNBZzohGdWoZlnzQZYC3GDxzZA2Gp9c9F8J3xI0Va3LBHtYErP3vs279JdiLeMdlvq9fKd7zDm7ET5fFCacXn6lBCAgzZo2G8IbEI2UYVYFrq06DeNMga5ZmmEX6p+N6W/7KhP6qQLPiD2LgSqmd4eH8YRkunInbX8yRQyDBO6hiy00JcsG8oLttLCngfWydbnmwwBkuE037M7dAYQphcSq/8vcmVJjlHhlXoTg9JjSWaSyjsnM3ifjRwEcjdwe95mgZNUKK/fsrwyavi2fqvss+qOvsnRdl6Uyve816FuDoVRDDR1jojVwbfBVZbGWNH9whG+4+31IC3ybkmjF+UIrWSrVZJnrXVTyxaOv3sfCWeev97JWmL0jCfvnUKER/hse5/Fs
 Whc4CFol
 dDvGJX3H9ONCnf4DTKF2rhO+JkL5nW09HNrXGWU5sihJ4Om45mHrvLtX2eogogc+IlTyYRDs5NNJpkZeWJaygN+upESRxkOWOJDo8dr83uiojzA/SNIyM90UOWkSoSwPshIWLm5h56X0Ubyhx2J2uArIG4pAwwopNcC4h0r8K3T6WP5dCodSUiN6qipjo8/a63yTkO1fSI0tFQxPy6t5mKgPf607bboKlH41tnFdT5kwVekZEW+C+2J7mnUOJ4WtEtIWj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 11:43:35AM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 15, 2025 at 05:12:27PM +0300, Mike Rapoport wrote:
> > > I don't suppose I'd insist on it, but something to consider since you
> > > are likely going to do another revision anyway.
> > 
> > I think vmalloc is as basic as folio.
> 
> vmalloc() ultimately calls vm_area_alloc_pages() -> alloc_pages_bulk_node_noprof()
> 
> KHO should have functions that clearly pair with the low level
> allocators struct page related allocators, alloc_pages(order),
> folio_alloc(), etc etc
> 
> ie if you call this allocator X then you call this kho preserve, this
> kho restore, and this free function Y.
> 
> Under the covers it all uses the generic folio based code we already
> have, but we should have appropriate wrappers around that code that
> make clear these patterns.

Right, but that does not mean that vmalloc preserve/restore should use the
public KHO APIs and avoid using internal methods.
 
> Jason

-- 
Sincerely yours,
Mike.

