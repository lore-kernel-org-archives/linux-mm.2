Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EA78CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 12:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79ECD8E000D; Mon, 15 Sep 2025 08:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7766B8E0001; Mon, 15 Sep 2025 08:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C488E000D; Mon, 15 Sep 2025 08:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 58A228E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:01:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0074E1605FF
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:01:35 +0000 (UTC)
X-FDA: 83891344992.14.648BF04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E2ABE40007
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:01:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uhlh3UjA;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757937694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3HTfREYcxN2IYZTwE+tg7AjNlGXEdHvW951AsxH7Ds=;
	b=IGjXhYiTuxpw6hvCLeJKxJOMT6+Lx6ymQ4pHpLqO7F1VqWwIAIkyaIA6JPEsYnVSrMzPko
	BVh+ZwlxiVaRUzDS+ffqMDOZJidYaMxHAnGi/MjbYIZmdADLmDvKBC18HMhVrrwjMKjNA9
	yMz2/wI3WGpiziblyGhFh/dmTZvP67M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757937694; a=rsa-sha256;
	cv=none;
	b=Y+3QM/2bv1O2umeIK87EMjhwswu72A7tdHt7L95I5L/PPlBRr/yRdiHyIRbgyAfEVXHqiM
	B1L6w6utQYAQBXl6RsUBbk7WOeX1U+o88FwAXH8YoTbqEUbqh9hxBsyh8VT29jW4AXBmsW
	OlbFBFDZj9eTLlECffXegQHPIht25qg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uhlh3UjA;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18A68601F8;
	Mon, 15 Sep 2025 12:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF5EC4CEF7;
	Mon, 15 Sep 2025 12:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757937692;
	bh=OdpGHaR6mVxP5HKq5aAY+2+SKhkbZPP2b52C+M/aSWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uhlh3UjAhOfXkVXbGPLkiJ2IwDdJz6IbjDX6KkXNjuFGEsfdy/sJg70IdeFE9Q2GM
	 SGcU3KXvT6Qnske83HJXQMspd9vSfkgPkSE9lnATOu0hyxx/a5snwXytgMZZqK2qiU
	 XPxFeh2fVAOSe6DSVTCeezuiSAnEwGakC8RJl2Q83blDnt3CrW07BnelRszu/OPKaI
	 IcPL1K26ULRyqxXqH/mvim8LeE06ZKP8gJocdA/z9c8Z6+xHScyJomdacck+6maZlm
	 8lFQIhzn/O/DYbxu2eSiUXBVKu5Apkht/+WLP0qWu/OCEKXfrM5e3CdMMkoH2qNmPC
	 XCijZ744058pg==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1A835F40066;
	Mon, 15 Sep 2025 08:01:30 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Mon, 15 Sep 2025 08:01:30 -0400
X-ME-Sender: <xms:GQDIaKIRTXCcaxAUYKgCRxMNWcCye0dRCoakwCbSGQUurMQVVdE17A>
    <xme:GQDIaP_BVAD9Lp_0CNgDffomeY121c4OgJc1sHIPcU76TfkIe8Tjw1Trfb8LVMSNM
    p_kfphQPtQNlsMaV1c>
X-ME-Received: <xmr:GQDIaIizBz999vqBaFlrq3S6TjVE19T_VZfEuOaxoNufMXutpoxNxDCJDgI5TQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdefjeeigecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeelkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhorhgvnhiiohdrsh
    htohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepnhhprggthhgvsehrvggu
    hhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprh
    gtphhtthhopehlihhnuhigqdguohgtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhinhhugidqthhrrggtvgdqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghl
    rdhorhhgpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsg
    grohhlihhnrdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomh
X-ME-Proxy: <xmx:GQDIaPR-9ZZsb_FqFD8FxF4U_29VX41nyxPhlQ8UN_jnJgsRNSEGAA>
    <xmx:GQDIaLlG2Tvx9s8Rs0SzuH3AZ7b7LQWHQUu839I9L64iVETXp4w8PQ>
    <xmx:GQDIaJWNfKqdibNS9dwiMOpk8c7OP-x002n4Dqg2bfH34J8nsNqd7w>
    <xmx:GQDIaCzOrN2B2rfuCp6OP4xFWPwwWijDYhGbdgADfIR2bN8zdV9OOQ>
    <xmx:GgDIaCUwNebGqmUNTY1vfe4EQlThA94bk8k2ZooT7GpWo9L-_KCwBMMA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Sep 2025 08:01:28 -0400 (EDT)
Date: Mon, 15 Sep 2025 13:01:26 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 	Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, 	corbet@lwn.net,
 rostedt@goodmis.org, mhiramat@kernel.org,
 	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, 	willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, 	usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 aarcange@redhat.com, 	raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, 	tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, 	cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 	hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, 	hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, 	rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <ioo6sjwlznvfmv7kupubkqk6qc6lec7kczius7g27o4kpp3z5p@druouu5ziylf>
References: <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <155c821d-402c-4627-a723-6f8c88a2f65c@lucifer.local>
 <ae9d88e2-bab9-49fc-a459-d7b9a8fe9351@redhat.com>
 <ff4b6935-fd13-478e-9187-219fb612aac3@lucifer.local>
 <e450009a-56c9-4820-bd0c-da1d782d3962@redhat.com>
 <2757fb07-78bf-4a39-8c60-8ca8be200994@lucifer.local>
 <a48c8d89-da30-4a7d-96f6-e5e17757b818@redhat.com>
 <e0580a44-2afc-4f3e-8d3e-d4fe9b2eeb21@lucifer.local>
 <6ec80746-2945-485f-930e-8cc34446f9e3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ec80746-2945-485f-930e-8cc34446f9e3@redhat.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E2ABE40007
X-Stat-Signature: bzog8tqc8s9p6ngd5sq1b4a6pys5g3qc
X-Rspam-User: 
X-HE-Tag: 1757937693-957853
X-HE-Meta: U2FsdGVkX1/t+8ZMneM7LSJjsrAPE0ttrUPpkR0ByLuW0Zk7VWnd1w0L5RCQrd8ymsfnR+iZBbGzVYCT5gxR6ux77VJDmo1qFcWI92MC4zF7YS10Ocuj88KsD2jgfpM4xyYHrFTeE9tk1m3Zo1dpOIzhL5q9SpiFoYpQTQwfUkwuh+uJyZImu2ApREQBFx6+qxQSYeGUarfUDXKJMIq4+eCRWeciaNpUZ0uUmN5b8Vo7x6yFX+p9ZPesrhJy+2JyQWvN/A05tVDDLtBcrAAocZJvdN2K9uvhb6JuwXu38MQja6TjD0J2t7gMMBfThgCLKO0ojO6vHSMhkA4PEJR+uocMsb2QAjfTzalxvwz+4SeMOuQOtbzwlGh66iFA3B53NJdt8r8ZV38LZykr9NHreZZLNvMJCe0E84Ypt3lLNwOJ58WTXUFo610Omo4gxrH0bwz/DAGoOJFgjOOLPUlkn6Rmyuy9o9puwalz7ev5hFxlEXCDDVyt4u1ej6NZOtijcEp0/Q9mdlB7Cn3upM4kDs7eWePhkUYcgNpq55JRaOHzZqv1+2aHaEzz+d7u5nuB33XS54ZNB3JyTMhm01Dn4TvhpmFaCjlaQ76C/7HLVCErS1MTA0HGSOM2qZuog2BzaDOqepM8whBBVwSKKYUd1nUiLVI2k8Zkt2KQPssvpDMUOWncO+uwU9b+9e4KRS3xyxe/Mj6IzT0nocG5YbwMqai/XFpYUR5KiA+5bBnPbqX+0ipYCI+W2b/FvcTqFPmUCpqy1+JB2qsrSW2YqtYuIYJd9m2nZOFWCxDS8nO3Sd0qdFYvRozfRZLo9odGbVzhxayowVu3E5CtTB+tky2hTRAY+ZyymZ+fNBEJoQqtN7HM6QpiLf6PZe6frEjLY+uQcwHJeZuqlgUnFe/EJ4whwYzzGg4wKg3swm0m1zMpXI9u79B+/UNv2tk3SbZ68bKrBOaDP4qlFUBV52XrWmH
 3c51dK2I
 CmbsWSahiL1gQp/ilELMUlgAV0m99OXIdoGvbkpQwWMHv7DhfxXG0wuf1tV6dsUp8eYuwqNUtBZStAYxUQ6UKxPXRflLhto4SI9R+WNaoFSjJScMnFg3THqkGXO9z3dOcmbbpsYdffhycY4iSILAe8ex+tfNFvWfXCPcPmkXwmwnedtqw6IoT9kSNaBHkFuQL8krEwIGdh3UHkhj+5Xx5quqMbFW3udl85GXYAQJ/k5B1cwMMaf2O1zsyPSKa4mgoK1q2rllunMVHkPG+K/TL0UIZTmXD1PjEvWlv9VG+dqDdh/N+wMuoiLyAEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 01:45:39PM +0200, David Hildenbrand wrote:
> On 15.09.25 13:35, Lorenzo Stoakes wrote:
> > On Mon, Sep 15, 2025 at 01:29:22PM +0200, David Hildenbrand wrote:
> > > On 15.09.25 13:23, Lorenzo Stoakes wrote:
> > > > On Mon, Sep 15, 2025 at 01:14:32PM +0200, David Hildenbrand wrote:
> > > > > On 15.09.25 13:02, Lorenzo Stoakes wrote:
> > > > > > On Mon, Sep 15, 2025 at 12:52:03PM +0200, David Hildenbrand wrote:
> > > > > > > On 15.09.25 12:43, Lorenzo Stoakes wrote:
> > > > > > > > On Mon, Sep 15, 2025 at 12:22:07PM +0200, David Hildenbrand wrote:
> > > > > > > > > 
> > > > > > > > > 0 -> ~100% used (~0% none)
> > > > > > > > > 1 -> ~50% used (~50% none)
> > > > > > > > > 2 -> ~25% used (~75% none)
> > > > > > > > > 3 -> ~12.5% used (~87.5% none)
> > > > > > > > > 4 -> ~11.25% used (~88,75% none)
> > > > > > > > > ...
> > > > > > > > > 10 -> ~0% used (~100% none)
> > > > > > > > 
> > > > > > > > Oh and shouldn't this be inverted?
> > > > > > > > 
> > > > > > > > 0 eagerness = we eat up all none PTE entries? Isn't that pretty eager? :P
> > > > > > > > 10 eagerness = we aren't eager to eat up none PTE entries at all?
> > > > > > > > 
> > > > > > > > Or am I being dumb here?
> > > > > > > 
> > > > > > > Good question.
> > > > > > > 
> > > > > > > For swappiness it's: 0 -> no swap (conservative)
> > > > > > > 
> > > > > > > So intuitively I assumed: 0 -> no pte_none (conservative)
> > > > > > > 
> > > > > > > You're the native speaker, so you tell me :)
> > > > > > 
> > > > > > To me this is about 'eagerness to consume empty PTE entries' so 10 is more
> > > > > > eager, 0 is not eager at all, i.e. inversion of what you suggest :)
> > > > > 
> > > > > Just so we are on the same page: it is about "eagerness to collapse", right?
> > > > > 
> > > > > Wouldn't a 0 mean "I am not eager, I will not waste any memory, I am very
> > > > > careful and bail out on any pte_none" vs. 10 meaning "I am very eager, I
> > > > > will collapse no matter what I find in the page table, waste as much memory
> > > > > as I want"?
> > > > 
> > > > Yeah, this is my understanding of your scale, or is my understanding also
> > > > inverted? :)
> > > > 
> > > > Right now it's:
> > > > 
> > > > eagerness max_ptes_none
> > > > 
> > > > 0 -> 511
> > > > ...
> > > > 10 -> 0
> > > > 
> > > > Right?
> > > 
> > > Just so we are on the same page, this is what I had:
> > > 
> > > 0 -> ~100% used (~0% none)
> > > 
> > > So "0" -> 0 pte_none or 512 used.
> > > 
> > > (note the used vs. none)
> > 
> > OK right so we're talking about the same thing, I guess?
> > 
> > I was confused partly becuase of the scale, becuase weren't people setting
> > this parameter to low values in practice?
> > 
> > And now we make it so we have equivalent of:
> > 
> > 0 -> 0
> > 1 -> 256
> > 2 -> 384
> 
> Ah, there is the problem, that's not what I had in mind.
> 
> 0 -> ~100% used (~0% none)
> ...
> 8 -> ~87,5% used (~12.5% none)
> 9 -> ~75% used (~25% none)
> 9 -> ~50% used (~50% none)
> 10 -> ~0% used (~100% none)
> 
> Hopefully I didn't mess it up again.

I think this kind of table is fine for initial implementation of the
knob, but we don't want to document it to userspace like this.
I think we want to be strategically ambiguous on what the knob does
exactly, so kernel could evolve the meaning of the knob over time.

We don't want to repeat the problem we have with max_ptes_none which too
prescriptive and got additional meaning with introduction of shrinker.

As kernel evolves, we want ability to adjust the meaning and keep the
knob useful.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

