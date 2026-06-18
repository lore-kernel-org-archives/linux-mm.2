Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACF22CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 20:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F17D6B0088; Thu, 18 Jun 2026 16:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2FE6B008A; Thu, 18 Jun 2026 16:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093E26B008C; Thu, 18 Jun 2026 16:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC6946B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:37:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D3601A027D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:37:13 +0000 (UTC)
X-FDA: 84894193146.13.EC0491E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 800E640002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:37:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=og3XibOh;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781815031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Fyhh0EcfIxaITnGEMNITSDgPpfMWLLfxw9z5p5FfBM=;
	b=4k0GINPoF7D0JsuIAGoyclxa8Wvekrt98OoYGeWUUl3sFvR4eXU9bMSannOIAI92aHsdte
	/ObbKNp+iUlB4xV/dscy2ND8o6fMp2rsZJOJIczA73WfA6zlxOY++4D5pGoddX3gUG0XJF
	nQktaCa/B/isr7wWsCpKIXq7W16eTzI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781815031;
	b=saqotg2P9Ptmf1+45A1ksZBBjBJtmWBauSnDZb81GchinCoPMQMeyQdnGR0RuBtIM+DWLX
	ZOPd0p4pu12tJJ0biOG9iIW2aaz+bLiqHnhrXJIOl8/hFpc3mg/MEn1NQ61TjRNcWLNTLe
	04EsCzHgb/GJCWO+wZ9+9B4p8qH6tnc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=og3XibOh;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06006601E1;
	Thu, 18 Jun 2026 20:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58F01F000E9;
	Thu, 18 Jun 2026 20:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781815030;
	bh=/Fyhh0EcfIxaITnGEMNITSDgPpfMWLLfxw9z5p5FfBM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=og3XibOhjGYcrL1JAf12+8mf9Rv+iTimdln6jc89RWSNrdCVV72OMII4XV05YWHzG
	 bIcmFw1s8ZoOsbFQMuf+4WgRTGapZV/M7zEA9t/4ASX6BSi5H5N5P+O0jAdBgsq8qL
	 TwNnmAy+EwRuCFiMvAiKNTOBT7a3mAEgOOhVambKejEhbg2JHwE7jw+1DdOnSy8GlL
	 VjGRzQCCOS04DTg21alhdpDBPYml2nWmB/jq91KwfkqZRIPglQFPPDDxD5ka8zX1pp
	 Hfg7Uyzi7Rga8oCDIgmtWpuz/hey99Mn0A3LkRrcDq8pmvw7BktVUfZKCe6O+mOmeK
	 C6YEXqWE9ZosA==
Message-ID: <603e002e-77f4-492e-9ad4-75572e18fc0b@kernel.org>
Date: Thu, 18 Jun 2026 22:37:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: __access_remote_vm with per-VMA lock
To: Suren Baghdasaryan <surenb@google.com>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-mm@kvack.org, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
References: <20260616190300.1509639-1-riel@surriel.com>
 <CAJuCfpEKgiQDGXgCKrqnn7Wk5YrT8nr4-H88PVeEruSKjtY_CQ@mail.gmail.com>
 <dd66797a-6fc5-4c31-ac43-d767560f3029@kernel.org>
 <CAJuCfpEqz9t-x8abYD6idtHmi9t8p4YfDmnbkJ-ix4i=RMS4wg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpEqz9t-x8abYD6idtHmi9t8p4YfDmnbkJ-ix4i=RMS4wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 800E640002
X-Stat-Signature: 6cczttoa9adrgkrcs86z7wzqikoa73c6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781815031-139584
X-HE-Meta: U2FsdGVkX1/YvOC0uBqhMUAUvIDthCwCiXVPUwyiRbEhEnmP4NON5w3yQqw22jXPZok/J65XsWVth+3zYb2lym3vGQ4GdOJDnq+j029sn04lGNATSaZkusj8oOeOWhsksYihLy705ctISrUoHHpJiiXmrpkSUqaxGONIpAvgF7cHSS8oDr/Q4yFMZQAdtqbBtigDW941Mn62YsuqdxOUFsvoxXKJj2MTvZC3yD6N0VtNpC8dGayWcbyu4iZMa4f/8tKsiaGcnzSJeP5rxdxrDHhR/EU6C+2fTqc9zCt+y979737sAkcax3MFgMuK5HtRg58yea8vJHvbEMkg+mdJwNnDu7Sb0Td0xGy1KTqRFwC048e1sLnzWcb3M/fxBTK5RfBOsBgX8kIJobyL8QC1Z/ouEgcy2i0FJ3MkRT2505v0an7xfulQoG+fADucFPVKknGi/hP7qeu4K1MO5Dn4Z+A2zBWSpHmuVI7PxyZXryoiwhmQQCG9X4u6mkvRnh4TRfbAI5fIrRfPnPooKGVdWTagZa/Pj1RV4bZTvVvBvPh9Qyjrr1ABsPjOu5Al0wfCnrM1BXsfYeEupGKCy/jxBYpsCtOagvXDb5veAvXPHoYMap7gQFaCvwb0Dk4px4q++h3zErkXgUzu9RvztQe636hfSi1N/BeAzxv9VUnU15U13mM2PUdmINOcbj82SxylutdFGVspW37sodgOdQnzqqKgg0nVBNEyjNwoGKINZVuMV4FbiEcIJO8RQDLqMi/EmNXoQwSKJ2DGEKV2pgkMACqHnIqvagSWKmdMIQ1p1tp6P+PQ0OFR2YbiAdHUDJw4tCN2RYs4r9U1nPxKH6e869QJP8lt8iMteW35hsXRQxtYc58brqsmBaK9FOay85XoHGv3iIO9u/+zhfaKZcnHud9dY57NW6ZL33FWLVl0DIjRiT0Iz9OQQIQiZnDa7bVoxDiJXR5SmMvNA7cMlje
 XxTl7OMt
 Q8vyiH2sxjbHbD0DxK6G6Icno+iVRD2Q0pWmTMZF1+ch6rlG8Wwlwe78zO5frGdbdDm52W48kw1Kna2/K5prH9i8bKU5Gh1ct9UhnOIkVA4Ms63PNqyOa5c3drUCpW76bWY+AzUXWGc9bqj6JWlMUGVoeSdBHV+SZp9Zmchjrmz+jNaydDSiGDrZzrqpBdOESn9kZO57bM5PiN30TCDs7X1YhO9EbGUFZXWNrhgQe31LMTCiRGK7bAShS7Z2B630nLFqoTGtloocdM0UU7624sK/YtP/JUBrDn75XIUDN2UKTXlMDFvbTtWIoi7KqAxTeUfShzv/ryM09WFprLSr9zQ+bc731Wfpn6WLo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 15:33, Suren Baghdasaryan wrote:
> On Wed, Jun 17, 2026 at 2:42 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 6/17/26 03:10, Suren Baghdasaryan wrote:
>>>
>>> Thanks for the patchset Rik!
>>> Previously when I looked into using per-VMA locks in
>>> access_remote_vm(), the biggest hurdle was get_user_pages_remote(),
>>> which required mmap_lock. Your implementation avoids altogether and
>>> keeps the code much simpler than what I expected.
>>
>> But, wouldn't we, in general, also want to teach GUP to just work with per-VMA
>> locks?
> 
> Matthew suggested using gup_fast in access_remote_vm before, and I
> looked into that. The biggest issue there is that gup_fast assumes it
> always operates on current->mm, not on the remote one. Reworking that
> is quite an undertaking.

Right, that's more tricky, IIRC the CPU from a remote MM might not get an IPI
sent to sync. (but my memory is fuzzy on that)

> Teaching GUP in general to work with per-VMA locks I think would also
> be much harder than what this patchset does and would require a GUP
> expert (which I am unfortunately not).

Well, "harder" is not really an excuse ;)

Where a folio_walk really shines at is that you can just walk a PMD entry and
process it all at once, instead of returning 512. Where it doesn't shine is that
you have to walk the complete page table again for each individual PTE.

... which is also what we do right now through get_user_page_vma_remote(), which
is rather suboptimal.

Ideally, you'd obtain multiple page ranges (with upper limit on the ranges) in
one shot, whereby each page range belongs to the same compound page, and there
is exactly one page/folio ref on a range. [we discussed that in other context
recently]

Then, you can just let GUP do the GUP work, without re-implementing it for some
special cases elsewhere. And others can benefit from the work.


So I'd really like us to find out what it would take to teach ordinary GUP (or
better, some new GUP interface) to run under the VMA lock. We can start with the
existing interface to GUP a single page to KIS.

Maybe having a new GUP interface that consumes a VMA instead of an MM could be
the first start to enable per-VMA locks?

All GUP does is walk page tables and call fault handlers. userfaultfd is nasty,
but existing page faults must also deal with that having to fallback to the MM
lock, so it sounds like a solvable problem with some churn?

-- 
Cheers,

David

