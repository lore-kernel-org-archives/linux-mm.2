Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 762CEE6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 07:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D718F6B0088; Mon, 22 Dec 2025 02:58:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F3D6B0089; Mon, 22 Dec 2025 02:58:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4BC26B008A; Mon, 22 Dec 2025 02:58:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B50456B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:58:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B511BAAB6
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:58:41 +0000 (UTC)
X-FDA: 84246355242.19.9551D43
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5BEB040005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:58:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KGqu3qj9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766390319; a=rsa-sha256;
	cv=none;
	b=nwup62eqlf8fweUfc7C34YuoVcAO4bUu5rWgGT7R+udouTe2P4DZBzOsjRpHhPUBEoY4AP
	XDWQUFOabnDLKVyvTsCbGCKFo5v+1ByEhtWqXJAOUVhftoID8tg6HtotvAOTn4lH0vHeDK
	aMX30/A4XOBzEKEfBQN6QLJP87K0JDA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KGqu3qj9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766390319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylWioNhICSSpBRob2bsrVLxiTy6B4jhPYZz39fA3Tlk=;
	b=xg7rgYh2SAJmw9Ch4LDM3YHwHSsVwZsjQ+3vnIyOJS8X7FLrO3uHaJ8+koj3W/66dJqyTU
	jtnMmPnvi2jU3e2pq6PWjKqt/HmhemMtSlfyCTbPp/c4RuI9JObC4DMlO+tPjyEYfljwfd
	vbq68c9GPGjGrnlIO7YsE/m/rJJ7rnM=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766390312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ylWioNhICSSpBRob2bsrVLxiTy6B4jhPYZz39fA3Tlk=;
	b=KGqu3qj9PBEfdH6tBRkNtw3gXVqHf7LSyqjNSB4UEMGOaSTbM1wDeVDQPhYXpVQoRk+gwR
	wlqqV5X58Pb1aLFtRuuRDMYWOnxFJUBSDkjpMsO+aDD1+rS/26u4eFXxDucRG85Dd2khdm
	UBMS0VKISsnp5U1RUJXf39HkzQCS+QE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCHv2 06/14] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251218150949.721480-7-kas@kernel.org>
Date: Mon, 22 Dec 2025 15:57:40 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <34BED0AB-22AF-4107-84FB-543D11BCA136@linux.dev>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-7-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5BEB040005
X-Rspamd-Server: rspam03
X-Stat-Signature: 4q4if7t9esyasx3ha4jas8kqwepyesha
X-Rspam-User: 
X-HE-Tag: 1766390319-637942
X-HE-Meta: U2FsdGVkX18vifjqcJLZ4UAaWLS0KZAGAwR2v0cilbEjlfjZtH5WibMu905PbUTb3GClYxElYmia0BcCZ2zfA9RyI+gLeOKWiwh+tyT2bf3WR707VxUReZOpaiwMHBHKdVn7bNqbzs3YPaEA73vpjR1Fsv4o/N8mjVntlNnWeqgnxM1x02F+Z+RajqOn1pFixMGli6ATnzC0ap0u+hlcO1M05J82AJBkUlqNzV2sjw6NYQMwrPLiirqKPR6VyzmWuuhZh2eLazXKD7r3ugkC/BpUjCSjqK97fxrM7bQl25wiVgOnu6xEcvjrZG1rpQ/anTTQ5r3QsSq5KkZovAPJyaTIas7wfV8B3PVhteDELEUHIydRym/xbOmM0SZz2yS0j4bfrRysyDfyPPqm9TNqqbF7Nnd88ZQQFQvSqGMy6/Vb7vtgEWVJU/xyhM1zPpv+2a/wAEbNuC5+OOZ/l5reD+3SHQo5EYV3RIY4DrRtRkEFlUqqn0DUogku1tRJUFD1VeaJAQhc5lJSwiJTZPd0RWGn8u3Z6y7M8oxgzQBpFhNh1eLC8WYb0L5mz+z5+Nt9S1IuNF6LMiVX1uHd0kOVs8dfI0Z/kmkPDtfyfjBbWSLaELD1Hwn959f7o6TyrrajiLbvG08r9a8t3v59dqSbGHodHDmUhWYURcJHb0XCw0h/cICXh0DoRrbmyTUbIDDkyRv0ONbQzs07PSCnijlsZi43RBJR3XZSQgnKHLAtVwNdGH3asdC6gcFMfbGwjNTPd51GWz6FUbR4J9MBxvLS7Ly7p65YP1bqA+Ra96TpLgm0j8iW43irrgit5ai4JulEwC9OQgZnqK7C108YkponT/1CzDd7/NQf481XTwPXCI0nW9NEQA97hf/CrE4aKiVM3xCa2AZv5ZT/J7KRrkOD0QZ9tadtGcHe+SsDM1MW8fDu+E7CX7jwgkt22Laf7zqRCpsVhHFFPW19tCl6cNr
 ErsRunLD
 69KC+eFrUx/z/aO2Da56Du0JcHWLZtYF3tJdPpIgIRyS9Hk/WibpadvP6svp+V6EIiIdG3FRPo8xVVS+TEG5pOP9UTHyEg1QdiE9QxMqp04V7393sdVXJTTmr8i71Bf5hM3fOo/Tpds3IP2zh2Iz4YsHWmy7Rnqk4d3keZFPvVnYxBAlUAggBWtf1RuXrNWKgsa1BQwIdArCsW3LviZ6Rnh57OlRhrZ16EPmG+s7NHK8Sy+qLaAgoGa1R0DaASXeME4rxcuUjNpO7hdy9Zjc0VV2Zo42rDWZEnYsqi/zBJ3A9M5/0JgQPh5iVhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 18, 2025, at 23:09, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> For tail pages, the kernel uses the 'compound_info' field to get to =
the
> head page. The bit 0 of the field indicates whether the page is a
> tail page, and if set, the remaining bits represent a pointer to the
> head page.
>=20
> For cases when size of struct page is power-of-2, change the encoding =
of
> compound_info to store a mask that can be applied to the virtual =
address
> of the tail page in order to access the head page. It is possible
> because struct page of the head page is naturally aligned with regards
> to order of the page.
>=20
> The significant impact of this modification is that all tail pages of
> the same order will now have identical 'compound_info', regardless of
> the compound page they are associated with. This paves the way for
> eliminating fake heads.
>=20
> The HugeTLB Vmemmap Optimization (HVO) creates fake heads and it is =
only
> applied when the sizeof(struct page) is power-of-2. Having identical
> tail pages allows the same page to be mapped into the vmemmap of all
> pages, maintaining memory savings without fake heads.
>=20
> If sizeof(struct page) is not power-of-2, there is no functional
> changes.
>=20

Forgot to mention, I believe I stated in the previous version that this
mechanism only applies when CONFIG_SPARSEMEM_VMEMMAP is configured.
Therefore, you need to wrap the entire mechanism within =
CONFIG_SPARSEMEM_VMEMMAP.
For other configurations, it's difficult to guarantee alignment to a =
very
large size (for example, in the case of CONFIG_SPARSEMEM && =
!CONFIG_SPARSEMEM_VMEMMAP,
vmemmap allocation uses kvmalloc, which only guarantees PAGE_SIZE =
alignment
for the returned address).



