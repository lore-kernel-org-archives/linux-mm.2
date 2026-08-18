Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724F3C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 11:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391956B0276; Tue, 18 Aug 2026 07:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368E06B0546; Tue, 18 Aug 2026 07:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280116B07FC; Tue, 18 Aug 2026 07:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BAFC6B0276
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:04:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 989F3A38F5
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:04:10 +0000 (UTC)
X-FDA: 85114105860.13.0D160A6
Received: from mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id 07207140004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:04:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="V5L/hW8R";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787051047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/0s4yVGaQ2+n+sedVItDX72au6W2onzWr2cter1pAA=;
	b=IDHzleQsUJ1q3wGKvcZu3exK+oEOSlk+ioBpdc9FVXuFOmjPgiGBswHBz/c+J52dNTzafC
	Vd62Ohg9mfE3cnOEby7VVQ2FaB1vYzinflHhAR3cHTTkoseAuItnylTzPKGdXz3AX0PiBb
	DAUsqpPuLRu/bmjXFdFNZNc7zkJHCsw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="V5L/hW8R";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787051047;
	b=eWCoFmQFescjO0KDqz7tmRn1FIupfvDF1Y3DL6sG14YoUp4nOe4ikolnElhxidGOzJ8lqz
	xsOCHRsDbq6NqnwkljjHuOm0fzOJmxmID9IJjP7ZxDUFXzrgk/XCmm1jEDcYHh2yWczv43
	tapyuEnJgsH+f6kYLIXaCpiFhyall2c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MWi4mSbgDzBcEms9pNWhuTCHSm4bPkMWdlMUVkjUkxk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787051042; v=1; x=1787655842;
 b=V5L/hW8RUYoITH5qbQVyLVBtzMWyvQD2ab3lU7BY15C4bDbhPmVFW1x6Shxguyq09mcB51Fv
 I1Lfj8aQbN05sa1Hd82iXtkgXhwCBKQlB1mB3q7l41XNgG8t5R9VTb2YJNNhWcrBeckA894AjcK
 HbTZGrzZL602ARvbjgyQNxZI=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a02:168:f6cc:0:a69a:f3a4:8fdd:3332)
	by smtp.migadu.com with ESMTPS id 7a9325f046949f8f;
	Tue, 18 Aug 2026 11:04:02 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Aug 2026 13:03:57 +0200
Message-Id: <DKS0Q1CR4APM.3JMJWR7UGI30U@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy Lutomirski"
 <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Patrick Bellasi" <derkling@google.com>, "Reiji
 Watanabe" <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED
 allocations
From: "Brendan Jackman" <brendan.jackman@linux.dev>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
 <anJ45UK0MWvskzlK@google.com> <DKPL6YQLP6NT.1747A5QR1D8VH@linux.dev>
 <aoOsiMyfWbkCbV8F@google.com>
In-Reply-To: <aoOsiMyfWbkCbV8F@google.com>
X-Stat-Signature: wq87bu5abhcnj7wdhpjcbwkodmcmobnk
X-Rspamd-Queue-Id: 07207140004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787051046-37370
X-HE-Meta: U2FsdGVkX1/gM9dlEiXk/56ybsK5UxHUEcpEgDTjZs1vgSQIM/iajgnpLUGEgGmG2qkBe8n3fUtZYsm+yyV5gXLyuU/+Nj1UMPPC6Decp13bE1uC/sbZ0D6Qcav7P+ie6KNHIVHa2KfguhiA23Kyx6tbYb/Pg0c3E/yQO3YSNO7brUB9hJs6VVFHVW9j7WXKN1Hnyy1DF6Y+xFfutShqfc72Mv7xRc6mayK2GjYRo71k+LPFtUP09q1wNMcuawXK87kuJgCx9mbj1mgwflHliqDMKRHzO8XT2WJDg4S5fGWp+KDkmHUXiVOfLSgBzKtjfvdDL229cklgjitoRgXUxBdSy8eXk3Tgr57dXA7wFg5HlsrhK8zqm/6lB969l+ikbfchKvo1LEoW4bxvLD/2OoWqNJPLi5WRpXukXXtP+GZIjIETLkL0j88PyTapRTKcfhR+BswqcvN87IL8HHmnu0tPN1lu5tX9Ritz/dx8lDw3NR9Io2KZTRq/JHnklhMAxgoZl+W+74V4/T998+lk6yGLRLKA/Bg8bzGjvc4c9AzgT2SkOMdPwtY1MqrH6UrEIECP42BEFnhvauLWJYYO0SH9eYxuzEzXQnm7MAKvEIDLNMsW/62Au9V4quy6e9YSQfKX9hH3HfbHLR3PPx92MKdbIFR2vrNuuYfriT7BGeh7+1DigxLbKLM7oniW4UdPTl84KwW9EPDihGzA6EcK5/2N2Sn4y7zPf5FVTVRD0zvYXdIo5jH/vThrQMTzkONoNZnmRRCe+bLI4rLz073fNfcgu+CVsCpGAUj6MHJ6VSwgKuWuTMrHTA4a1MgJGB0XGDSq0jwjbzMZaV6kgA6IwKdPoG6JSc/nZWzE6XthpjIUdLUCrEU3bP0rDMANao+9CQzCMcoohvdIfTS2mDftCKj8eyZwjxIyUqy6eGxXNEHHN7V8pmWKUXS2KqGL7HhbwyRR9jCjkBlYJnmUfsW
 0veeo/3x
 NCVnpDbgF7GiIjmgmCOC0KnZxG7oOc6+PzgeQbK7wD8rVq/36kb8jFnlkGQ2QBtOBPCng6o9ba/clGqrxoak54FTquYHAk0S5MKkMUqtsZNRyXM/7vbVDLPw3/SKaJH4dhWYVINizq+tYHI6aaji03rF9GcSeZZkdlVcy3EU7ieLr8mxdboOxVMnJEzEY5MxF+yjl9n2++N1uCjTI7bmMseLvHfRGc9lRGB9tRA00H1omC2qO/Czz9kKvZzsAjIoIPw+XCAJF33e9oqK7bD6zEqfoblwPV+/FHXEGdT8wNechBOMMWWPMUSQrMTpccy8TCybqukpcmXNtgztaHYnozhXa0aFin8ixOIlWaZQXnijW/DKZR7IjNqLzFqB4PedVAYf6OvCfYekmaLRrV2nN5hcSng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 18, 2026 at 2:55 AM CEST, Yosry Ahmed wrote:
...
>> [0]: https://lore.kernel.org/all/20260805-shivank-gmem-migrate-v3-9-00d8=
bdec4e1d@amd.com/
>>=20
>> > I wonder if we still need a fallback case where a pageblock contains a
>> > mix of mapped and unmapped pages. We need to carefully handle such
>> > pageblocks:
>> > - For unmapped allocations, we need to unmap the relevant PTEs and
>> >   potentially do a TLB shootdown (if they were previously mapped). May=
be
>> >   we should always flush the TLB for simplicity for now.
>> > - For mapped allocations, we need to map the relevant PTEs. No TLB
>> >   shootdown should be needed.
>> >
>> > Assuming unmapped allocations are always zeroed by the users on alloc
>> > and free, we don't need to worry about zeroing pages either way.
>> >
>> > We may want to track the number of unmapped pages in such page blocks =
to
>> > now when it's fully mapped or fully unmapped and change its type, but
>> > maybe this can be a followup if needed.
>>=20
>> ... However, yes this might be unavoidable despite what I said above.
>> This was also DavidH's feeling when I chatted to him a few months back.
>> The hard parts of it are a) the tracking as you hinted at and b) in the
>> general case that means allocating pagetables.=20
>
> I am considering a simple-ish scheme to avoid per-page tracking and
> potential TLB shootdowns in the freeing path (which prompted async
> freeing internally).
>
> What if we just always map pages in such tainted/mixed pageblocks when
> they are freed? If they are already mapped, nothing to do. If unmapped,
> we map them and zero them. No TLB shootdown required.
>
> We also shouldn't ever need to allocate. If the pages were previously
> unmapped, we should have already allocated any necessary page tables.
> Right?

Why would we already have allocated them?  In case it wasn't clear, I'm
talking about breaking down huge mappings here.

> Zeroing on free may still be bad, but not prohibitive, and hopefully
> this is only a fallback. We'll need to figure out where this fallback
> fits (e.g. before or after reclaim/compaction).

Yeah zeroing seems tolerable.

>> So yeah I think it's probably doable but I _really_ want to avoid doing
>> it in this series if we possibly can.
>
> Yeah I am trying to figure out whether the issue is theoretical enough
> that we can do it in a follow up.

I think it's definitely theoretical enough if secretmem is the only
user. I hope given that guest_memfd usage is gated by a userspace opt-in
that it's also automatically OK for that too...

