Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A53C3F31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13AE6B008C; Thu,  9 Apr 2026 11:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4626B0092; Thu,  9 Apr 2026 11:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DA866B0093; Thu,  9 Apr 2026 11:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91D186B008C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:10:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EB22160809
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:10:24 +0000 (UTC)
X-FDA: 84639353568.02.65D2A21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7B9BA18001B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:10:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ga94zfGZ;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775747422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qXVKUAxy+elrynhs6cxblO1GtPFfAVzCsABhyo+9Lk=;
	b=wodyVX/xap6RUpwbCtU/QebUGLhLQs+M5B7DnIiejxnxvO4PIvI9+oy+BPZ3LyusjAQqzG
	46aAZNp/Rw5AehaS523r3Wf+jHCmc0DNzta2YEPJQ95aGvncICLVM4Y5GjJQa2XhTnTkJO
	lbRUeuXg8BZd3UDMUzUqNrLyFBOI/wA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ga94zfGZ;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775747422; a=rsa-sha256;
	cv=none;
	b=OyUpd8mmpbOxkYq7VNL6R5QZ1S83L6rkRRyYWvbIbkxutlrBj/zlXPX1TvIHivZrcr0yrD
	wfyxXrcmNL1NFoUosGFK/X55M3eVGFAU1gi2Xmj0zzax3KCbSSWIOs/E67+odZzbAePi3G
	sPLFO/sIrD7BFUVQ67rFeTAUGMWsP5E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 826264171E;
	Thu,  9 Apr 2026 15:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EA1C4CEF7;
	Thu,  9 Apr 2026 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775747421;
	bh=mpzbJeW9K8HU2WsSd97Hb9A6JcAPIDKyhFRx2DEEoe4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ga94zfGZlyiDjKYAxafyOeqcBSHFLvp+MC1zJIsqZ2CZzDB8V7fQt6soXlFoDHt1C
	 oeNp3mU784AFH2Km/tgGqAOxH6kJDsJAepj1RcOngWBlKmhnzuxFmgVy8CwZfscRZ+
	 4uvoPbCeNcEcbm+UWrrNBjf7l3xnPwHTLM3Y8sg+JxTDfjp3oHHSgAQXSb6aBC/upw
	 3lXDP4VqBY9Lwp4UtlNFCZ3RKlavzj7FLyRrdGwXHcOGcz6FUtL6jwWBbSleyXUXb7
	 SLDxnFJjO9RuWg6f453kioizTxG7lexyNfTUXidefPlibk80ZhHmiew0XSDj4ZbukB
	 wXG2eyKMjE9+A==
Date: Thu, 9 Apr 2026 18:10:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/sparse: remove sparse_buffer
Message-ID: <adfBVc8ohLrtIe3j@kernel.org>
References: <20260407083951.2823915-1-songmuchun@bytedance.com>
 <b22f0af1-848d-45da-99b2-0c28b740e979@kernel.org>
 <70EF8E41-31A2-4B43-BABE-7218FD5F7271@linux.dev>
 <dcc3b56f-5d4c-4bb0-bfd8-49747df30f47@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcc3b56f-5d4c-4bb0-bfd8-49747df30f47@kernel.org>
X-Rspamd-Queue-Id: 7B9BA18001B
X-Stat-Signature: ymdfd5nsx698sdqrs3qpte813uqhrcdx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775747422-374558
X-HE-Meta: U2FsdGVkX19K4nC/Wp3fjb/G2qPsv807OxFzrgM8zPIKykLHbS84he0mA1xD25m3zJ0UesEUnYw/Sf0ReZxIXhsDbpYkAbeswBELIuUt9dAxauWB9/mP4Zs5FpkijP9pvGXo4p33naBwaeKdIw6KNxuKv7/5DMxf8/sSHBdgE/oDvINNj0iZV7F2VcjBX3TuJAUkaBgoR7rguzTB2wcajjmKE+1xR8PmBeA27/SQfcv5kPm/QHXYxXH3T9gTtOWJIIXO/qaoR0fDElUl2QADGJISyVSLZColZGpSM4ilNM2zqvr42kIs8EB9P7mkECpemr4LUpnGI81sbfJ4n7XHe//5Rg9dCN6cKM5wUPDFabaEGIFHn0Eax3wn9yS4mWEHFO4FUAOVi3kxrllAMoxpeBxTqmPFDmI7YubXUb0A+I1/FlWeaM4BuyljbKpadfWUJmsG8MTthaKgZALiRwR5JfKTfg2sj/MGHwO6P1m3rLeFAF2tFmpCyEAad7cwUbjLB+sQVHrOHpluYEmvOG9UbgnbIZOe6TBiPon75OyHb9qEK4N37JKVQg9IjGpA4eBv6Cwj5wtDo/nu/pCcn3xrAcfIoEQazavOfFBAdGOuTx1wS3vJbiohA0lM9KBpwoOZkxId94TE2IA+vDTn8lKBxIi+E3yuLvC5mwQlecFtgvCEZvLhhbDhT0P2LmoLaON8rYnsbrm+L09225JHoN5tPeSTU20j38E5/BF8xEKl5bC3ctRWXhbeJ4IascCSDE50Qed9QWTOGkRqDzX718YBa417RyQ9zQQrV5yHCc2IGxXtSnfPODjCJyK52vtUvGo6JJxfJ3U7/XUKRZUVBeYqakjMBfahL1f1woo53qPJBxqj1dvP5m5MbYSDGgX83urv8e88QNkl5UNp4knL4otgp1S+/qARxcwHmZI160Ybj7qu8J11AJ7BfUbShV/sySh5gQe6QJGBAx1xpweheI2
 t2vWgXBN
 ThDTnMPA3d7BbcVVAHAjDRuE2VEeuUD7LXAkiYQhgdd3ltjUKKCifmyRyB4R9rCDir4NTW5fERta2QwpbZDUcxTA40oB/xUuABysurjtoJmgD/S0LmtF7bnSMkke/+Cj4yBNjObocjXziGr6w1Snv6lyUZOj1XAoW/pzGPUkCSxLPuKIMBlhjPW4UGEi2q5uAXIQmVEeHGF/oeDm8uZtjxZcewYFoMAt67534So3KCx42AgDIUNBbGk2P9ReXQHSlK4nJ3kKxPvkmlKD6D+URba+/ThS81VegaLCbm/ZKYiE7LB51byfAQLX5fzb0VuUn0w3xwJZ17E2ol5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Apr 09, 2026 at 02:29:38PM +0200, David Hildenbrand (Arm) wrote:
> On 4/9/26 13:40, Muchun Song wrote:
> > 
> > 
> >> On Apr 8, 2026, at 21:40, David Hildenbrand (Arm) <david@kernel.org> wrote:
> >>
> >> On 4/7/26 10:39, Muchun Song wrote:
> >>> The sparse_buffer was originally introduced in commit 9bdac9142407
> >>> ("sparsemem: Put mem map for one node together.") to allocate a
> >>> contiguous block of memory for all memmaps of a NUMA node.
> >>>
> >>> However, the original commit message did not clearly state the actual
> >>> benefits or the necessity of keeping all memmap areas strictly
> >>> contiguous for a given node.
> >>
> >> We don't want the memmap to be scattered around, given that it is one of
> >> the biggest allocations during boot.
> >>
> >> It's related to not turning too many memory blocks/sections
> >> un-offlinable I think.
> >>
> >> I always imagined that memblock would still keep these allocations close
> >> to each other. Can you verify if that is indeed true?
> > 
> > You raised a very interesting point about whether memblock keeps
> > these allocations close to each other. I've done a thorough test
> > on a 16GB VM by printing the actual physical allocations.

memblock always allocates in order, so if there are no other memblock
allocations between the calls to memmap_alloc(), all these allocations will
be together and they all will be coalesced to a single region in
memblock.reserved.

> > I enabled the existing debug logs in arch/x86/mm/init_64.c to
> > trace the vmemmap_set_pmd allocations. Here is what really happens:
> > 
> > When using vmemmap_alloc_block without sparse_buffer, the
> > memblock allocator allocates 2MB chunks. Because memblock
> > allocates top-down by default, the physical allocations look
> > like this:
> > 
> > [ffe6475cc0000000-ffe6475cc01fffff] PMD -> [ff3cb082bfc00000-ff3cb082bfdfffff] on node 0
> > [ffe6475cc0200000-ffe6475cc03fffff] PMD -> [ff3cb082bfa00000-ff3cb082bfbfffff] on node 0
> > [ffe6475cc0400000-ffe6475cc05fffff] PMD -> [ff3cb082bf800000-ff3cb082bf9fffff] on node 0

...

> > Notice that the physical chunks are strictly adjacent to each
> > other, but in descending order!
> > 
> > So, they are NOT "scattered around" the whole node randomly.
> > Instead, they are packed densely back-to-back in a single
> > contiguous physical range (just mapped top-down in 2MB pieces).
> > 
> > Because they are packed tightly together within the same
> > contiguous physical memory range, they will at most consume or
> > pollute the exact same number of memory blocks as a single
> > contiguous allocation (like sparse_buffer did). Therefore, this
> > will NOT turn additional memory blocks/sections into an
> > "un-offlinable" state.
> > 
> > It seems we can safely remove the sparse buffer preallocation
> > mechanism, don't you think?
> 
> Yes, what I suspected. Is there a performance implication when doing
> many individual memmap_alloc(), for example, on a larger system with
> many sections?

memmap_alloc() will be slower than sparse_buffer_alloc(), allocating from
memblock is more involved that sparse_buffer_alloc(), but without
measurements it's hard to tell how much it'll affect overall sparse_init().
  
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

