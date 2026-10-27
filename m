Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B15606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jJW0SXJL
Received: by kanga.kvack.org (Postfix)
	id 220C86B0720; Tue, 27 Oct 2026 16:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8266B0722; Tue, 27 Oct 2026 16:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10EB86B073E; Tue, 27 Oct 2026 16:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D84AB6B0720
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:16:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 671D2120B26
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:16:32 +0000 (UTC)
X-FDA: 85369513824.12.C6B5FF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 73F4C180004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:16:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJW0SXJL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793132190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yv3WgMVRZis5mvccj4o/E0izobfrAv/a1j0nsDI8MA0=;
	b=xXBzsnKfRjQETImz5qG6X3fFC65FN0jdjcBJvD8AKyx12v6i32tYd8enc3p6cdY7BFNzg9
	xQsyIFONdU21N353EPFWLUT8ichb1w6oAw52rrEYY+TpnFBtRT8rQAfZZeHx84f70iUlmr
	id8pj+57CwXbLYLPcPVsRa/EqPKDswk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJW0SXJL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793132190;
	b=WoaSDmBj+tbDnwcThdF1QxCDz7QpwB4DVSvnW2vsBis12GIoo6Z6Sczbcw0YrGTfalmnwD
	+yYqQN+v6/3I9Q8ihJQlBpN/7FMG4VOG67LJjTtqJB8nrGT/wsTEtFR48kTj1uF9Q4Wga9
	nOnhRt3Be88BKpkMGEMFEJTLFXmWl9Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9645C41E91;
	Tue, 27 Oct 2026 20:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA341F01828;
	Tue, 27 Oct 2026 20:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793132189;
	bh=yv3WgMVRZis5mvccj4o/E0izobfrAv/a1j0nsDI8MA0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jJW0SXJLeraETSisKmLGPZ7i/niPRtOH+C6mSo0yvHCASRUUPPEIxjgRf6Amq8fm+
	 guD8eMawZUcIYN4L8ottvokjcLzQtRxTIc6G/IaYcQ28Enew/DR0Bnl3BsYV/QQE2J
	 0hdFqwJZNLy8RKx4IJqyGPpAU9wV/3120sksETknuNAP8zPqt4N860F/uqakh7J7BY
	 rZ3SThlETe8nJioehN7u2DR+e6u0H+HcigoSFiL10pPiH6mkacMEP5q/dTdZzfuopT
	 MmIzUUMf8ZnIOiPnpYj5WEcYVoDTKryLy7LcYVnKciV6QElSnOEpZ5Ft6bRTWLHX4N
	 dKR41ADQjP4Gw==
Message-ID: <9da1d287-c101-4af0-8371-888e78b3defe@kernel.org>
Date: Tue, 27 Oct 2026 21:16:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
To: Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>
References: <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
 <auCZFckDfBMrlfxV@thinkstation>
 <070DDE5C-2183-4A8B-AC2D-891CAE15E581@linux.dev>
 <d7a634b6-8668-4753-8bfc-e9334dde705e@kernel.org>
 <4A32F5E6-977D-4720-8723-B19AFBC08FCF@linux.dev>
 <auDkbDlgSZxqlk2G@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auDkbDlgSZxqlk2G@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 73F4C180004
X-Stat-Signature: ygo8uh3c5ngost1sfr7aydt8gr4udia3
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793132190-568686
X-HE-Meta: U2FsdGVkX1/YFscvJ9Nn/U2+wxMwMX46nz0rPJiVXksDCsBQdRhE7VnI7Pzt0Gvl2KcuBs4JL9iXHG2Eatc0rKXhVyT2K+CU4R05pAUSYPdyIzoUMTPnpHOZC4RHAS5izTRPzep+6eh/13SuKBpPuDfZHmomQt6x0LnhZY5KszdyVoCMhjpKCumK4wdz+0e7LLcYUzKxWK1d4Lfwt0vbHLHtAqPUvpOu7smyYrYsgke1EV9pvrzcP2toBCZqt4FXoQk6qrDmP4dVqo1gLfGztqiaPgalYjLWpLbBjNgZeWG07RSKHlJnPl+qOT1IhRtGiy4o1oMG5WNwzvVnSSvoYsshGR0zjHo7YP6mK/Eso/Zy0Oohdg8I2ksYWVx3EIxQumNv7TXrfl2CGCFF0JhidFIWRCRzW5vcctxwJYlyZBrqiNsEkpjR5A5ic0UdNAwkzUULW3QOc35Kfg4wQV+0c9nNyd+ZS/6Gw4slit/M7QGtJtPR2GUnFvN8HXaHXvskadVqJG2KaTqF7fIDygltLA607UpIrvWMiGS2uHVCJebV/PaT5INyPsKEUCqv8xuz+z1mtUJRpRl+aA1mRZd1V+r8TesxySFFkdh9OENGCs3PNlQmpSLPScy2hRV56vRuGQx6VAbTRpDDWfzuwS7mKTqnT99jJF1CfL9gBHdeDApTsuSVEWLjJA6wH6oVExWWw3NNkZxcXiEwIIi+2CbS2Z4kfg7SZsgVrwE0omdSpdGACjn77TQ6639L8uTW8GB8bnjqtzyxg62OxXMJjejCwHQaa9BCGCFZQtXQhg7LpbCOudqVqTEpWls2fSU0ITOux+SL4fkLIYgx2Tq5eHCkNCttWg0z9cz4ilRK9ltVQG9h9lT8yfFEQcBuWeINR7MD/Vh6Wi54s42KSLazZJHTmSLmMTJhT+AP5frl9IjohrUQX7SqmVSfb3DPtIlf8dHrVrbdgvq0QdJpRkybY4T
 3pfr7CjY
 C3v3HqVce88Qs0uMfJ8iidxWEIyxuSwEXO/9LCh/nLkPN6O0RL1YoDx6/jj9qQgPQcdJf0c7mlaLdXcYqio2jQRVqATPv5aQ+d8jnU6Joqg1D48EAxohchW7wNyN9meb2xAWBX3/QFWQfRU2h8wXAFzu11hMhBdA1YFvSqhBLU+fVBjXa6wxdqH5a/T8w9utiI4utz43o9krTNlPYN5yKuzTXyzPNLiUjXKGsbbRR1y3vOoKX+BJ2zjG9lzI7XO9bxWQB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 18:51, Kiryl Shutsemau wrote:
> On Tue, Oct 27, 2026 at 10:03:54PM +0800, Muchun Song wrote:
>> Therefore, I am kind of leaning towards removing the RO protection
>> and restoring RW permissions to solve the race.
> 
> Okay, what about this:

I'd be fine with that. Best to send it out officially such that we get more
feedback from other folks.


-- 
Cheers,

David

