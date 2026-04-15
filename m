Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6508F4199C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 12:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C53D6B0005; Wed, 15 Apr 2026 08:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076136B0088; Wed, 15 Apr 2026 08:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD976B0089; Wed, 15 Apr 2026 08:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD4F46B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:22:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C0FFC1BD7
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:22:39 +0000 (UTC)
X-FDA: 84660703638.02.815BA25
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf11.hostedemail.com (Postfix) with ESMTP id D5B934000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:22:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UeFP1PtS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776255757; a=rsa-sha256;
	cv=none;
	b=GjIXZspTZy6Ken4TFPlgQHMHD8f0ROloSVFBdN/VgQNEp+Pt3k4kYs9MwpuriiXpTFmnHW
	8ZHP3M/zL3tN8uCriXyQaE/7CTEdJyKBBaBy5LYWHat03XYWRGaJuqkLXxPU0dnh9bRh2k
	eprjgQkzxf01KN3K/uQd6B4r3OFxa80=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UeFP1PtS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776255757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCECXRZt1tRWhYO2f/EdS9u/dfLhHAlOtvQp6eMeCao=;
	b=XKb+FDJko6Yfql2rmOrmuvMia7s9IK2clt3/IID1fY7MO8TFX0+oFzLn7uTfmA6JIjhsJU
	D2sE2upFvrs1m9QrlAwT4pIyYwfAcImRibD55H0l1cXvr0jAfFYO4egkRffJ8atWt+PNv3
	qhUKXkCjGMySpgnM3Vj/XSskbbs/t8w=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776255753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VCECXRZt1tRWhYO2f/EdS9u/dfLhHAlOtvQp6eMeCao=;
	b=UeFP1PtSF6ipgLoxcNRkvHhJojxdRSDvpJboXiwDHiGFdWOJcrdUum8kCjr47GDwUTIjEL
	Oxib5nsSYCh6uASGbSDMCnR39l8VbiQwCV0shP4KLbjXNuik3D4XhtjFzThJ2YelY8PtYM
	Fxxwt17HNWkYfy7qwRomETUmFDVYQds=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 4/6] mm/sparse-vmemmap: Pass @pgmap argument to arch
 vmemmap_populate()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <9ceede7b-45d3-4d15-b8ce-f0b04bbb18dd@oracle.com>
Date: Wed, 15 Apr 2026 20:21:45 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 harry.yoo@oracle.com,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FE14CDAA-32AC-48C3-AB9E-31F6B47843AB@linux.dev>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
 <20260415111412.1003526-5-songmuchun@bytedance.com>
 <9ceede7b-45d3-4d15-b8ce-f0b04bbb18dd@oracle.com>
To: Joao Martins <joao.m.martins@oracle.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D5B934000B
X-Stat-Signature: iq9eujfroou79zg9oarb1hh9qkp6b4r7
X-Rspam-User: 
X-HE-Tag: 1776255755-906380
X-HE-Meta: U2FsdGVkX1+qEg97Vt8fHo+7JwHMyQR95+M5vxHkXVIVm/EVGo171BBiOpYf1mZboBJXzCpyyqyuMHLRQquWUZoW4LRLnmdiX6A4oy6XQXod2EhQeXxPzQOHH/r9Htm71cPnuoYYIlwCNDw/Z7eWxX7d3YZSZQfaIMB7Po+cbJVOnSGcbYsH3MxTUWKtDJ67trvZqeCh6qVp6dXv7JOXgxfVu25vQxhDt1feWpMZE1hMqvEPzm1vZqDO0YUiWThO0mpLjCVm0w1m49xTj2tnBPyEp5sGrqO9ZSrPPLe0NgzeuWiDPcygkoimezdJ9T3oKo6Z7/pVSl7NuKSIRxyztz1Dp9JsVk9MERJQjed9WjdEEBxT0T7SGTpn8LYQcb8yohNqaExsg4BbEBzUATQOI+q+k1Z4F70hKHU7VyOmTIX5wDxFn2gy18+u4u/0FEoZ5fwTQj9dxX3XslLTjFAbdgv8l0LhzvhteSCEiX0syVBovuKgyK2Lu+G7lGDHQPjL0xvvTj9eNHJrTAQc/XcnLeAGaGDJye/P1SwfuywxmZsBkHWDAigtczg89pNIm4Yzcf+fp7Cz31DugbgJHxTCOGhWBc1ghtNbOGThSjoBwtUgjrVX+gZTW6d5oxbli4u9IGI1vT0GYof0XG0zzWrmObb/j5P3M+zgWz0cLbLHcKC2Kj7i7xTkIehOY5kOYfwcxJvOg7jqLL1li8RhyP5mPiE+euI+2H0w70RT8NhAUWDTGjk5EfVEcarmtAbwCc5BIK7We3hA58o2k5q1NxAu45IImCraUmGKBay35K94T9MCbeoAT81hUaZ5wYDXn0jq6DZHroi3tuZ9XB0yXv06iMAkllMujWNdON1Cu461utGr6E7cCuwLrGr93DnkzTlUV4aF3U1gCC54j3X3k/2TXEpj9xwEv5bCSD0yshbqUjZukAkpTOPtjuycwU7KwcXJ3FwIZCWpQBq8XVkKGtG
 0HXWi+XJ
 Nn99SeG1K2RjwvHglEefIggeeVgkKVn5TV3iuLQsfMHrifll6ISqyAFxzQokMzPpLjLMnGZUadP9YOdeGlPXG65mc/mncpkpOXE1RCKdobnJft7PTu5ZOaaLWyZCZQhvKm8oiiyh5mxgbUEQAmVxhSVvN+7bnRTRZ6nRXiYYrdWBkPsDlik0sIYx3HC01Bqu0GXJk6yBDi4GFCNLVNTtmoXsvVW8SC+GAPGpZgyfsaRxJYJrZHCQ7Do6KSIxJCC1LlBahylPZAFBFbv5DllXq7xs3JlP7B6wyzoxIuJLQy2D8ahvkuQP5TB7qCQzwBTn/HwDv5bj0sFCPc1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 15, 2026, at 20:13, Joao Martins <joao.m.martins@oracle.com> =
wrote:
>=20
> On 15/04/2026 12:14, Muchun Song wrote:
>> Add the struct dev_pagemap pointer as a parameter to the architecture
>> specific vmemmap_populate(), vmemmap_populate_hugepages() and
>> vmemmap_populate_basepages() functions.
>>=20
>> Currently, the vmemmap optimization for DAX is handled mostly in an
>> architecture-agnostic way via vmemmap_populate_compound_pages().
>> However, this approach skips crucial architecture-specific =
initialization
>> steps. For example, the x86 path must call sync_global_pgds() after
>> populating the vmemmap, which is currently being bypassed.
>>=20
>=20
> Harry's series fixed in a different way (for x86):
>=20
> =
https://lore.kernel.org/linux-mm/20250818020206.4517-1-harry.yoo@oracle.co=
m/#t

Thanks for your information. It indeed fixes the page table sync issue.

I'll drop this one int the next version.

Thanks,
Muhcun=

