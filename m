Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B65CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 12:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DFA86B00B9; Tue,  2 Jun 2026 08:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7706B00BC; Tue,  2 Jun 2026 08:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE576B00BD; Tue,  2 Jun 2026 08:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 504776B00B9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:59:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF6A69291C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:59:03 +0000 (UTC)
X-FDA: 84834977766.26.A2DBD78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 450A6C0003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:59:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WtcIVtCG;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780405142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILpK8yncsPXo3Zp3F8bj4Ycb8h8YzojmPtfizCHdEBo=;
	b=sMuCw5ebmlX9ksDcPpuCdHHSV5u5atLyoB+7jlY7VfmkN6thLzB08lYbz8WW+5UR/uFhJx
	B8IXURiNPpGJGXMEqSW4QfstMUkzcrH1K5CLntpP1MkKvy/OnPw8uPGK2ldz+qyN//Q1Jc
	oK/gL7Wl8wRwwL4yRWQj37I+SKb0FWM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WtcIVtCG;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780405142;
	b=TCjeYdwu6FRbUxAlV3jZPtAAb1fPVL16xmoeJ4q3K14qk7M0/ibY4iVL+TenUgY1Vsr7Mc
	V/pGHISiSmKpn4FJQtjHFrlcp43exo6qbzJmPxzNBRZ5rp19ef8OuBfbRmikGwuLyOOcQN
	cxxP7Ni9bHKUwV0+BsLWgjwBMyF/mws=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B862560154;
	Tue,  2 Jun 2026 12:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9FD1F00893;
	Tue,  2 Jun 2026 12:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780405141;
	bh=ILpK8yncsPXo3Zp3F8bj4Ycb8h8YzojmPtfizCHdEBo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WtcIVtCGHBl1NcntUgJvu6bB7mYQhrurEPWuJ5Nfm6UXAy76S61lSrtxXezQny3Ur
	 XV70aHvWJVEY/ZhAPrzqUJOj1yJ5UhLkBN3O0/umzhVZ+VR9w+IuEFIfv/1KqkTXkV
	 8LZ9AYzVP09P8JgODMXujSpDZ/8Pza6T3j1Vv3FyEXXAqxevWGsMrKl50yMHeTE1Mi
	 jZSK0tL6abMUAN5fBtHb90I/qyCKgcHXjjliVVY/IShDU4w8rnSmFgo/E0x4qLLjZP
	 sIqs9AZmmi0uBwwQqNDgLqP88XI+y+IJnK0HzpluS0JmWYq5PKCoiSCRbW/HlxIQ46
	 0/7aCI4q8omhw==
Message-ID: <a09bb52c-2e28-49f7-a32b-e2743abff756@kernel.org>
Date: Tue, 2 Jun 2026 14:58:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org> <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org> <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org> <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
 <bfaa33d4-d156-4b11-8735-57a5d1b65ece@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <bfaa33d4-d156-4b11-8735-57a5d1b65ece@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 450A6C0003
X-Stat-Signature: kt3814pb5dz1dfcf84a49fyh9my6u9a1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780405142-398207
X-HE-Meta: U2FsdGVkX1+n0eDKTeIc0PVtuSfGJwis7EOL1oNV4MZPWd5TVlMrsaDiLFGJYGOzwh9pnq1IAcmjI4E0r1i2Cl0VayBhZMMrBKqkrZkbP8jtQviXaSOnYr4ydx/ddF2pRnv86M/6SYWgekApC6xteWqL4dtmpDVCiPdqCFE/gu5i0kMMOvKWttMRTp80ZiEVqVPV3Ji4nW/RutgpWTdn8RifPo0CP5YHSrxRiRomIOebGtWFPx2gqTPguy0IkiyI6uuLlgShSbMtUwWy0RpERHN6d5DqT3TolsIHRB5O+tEAUyqRHQS9LhQ+9hOO+yiAJR3VINFyOd4H2LsBnDTBXaob8It9iccuN1buKc9t6U78uy4hfFVrjXucb08oQh9KJJXywiNJNpOCaUEzqpiV0rpybT7ZjkSB0uE5zrcRRTLd7lf4QzknTtEYXbktGz6GQh6EcGyYS2+5pSCKP6NbCAW6djTn8Aj4eP9JDK5ADQlFBeK0w1vBJjC3wNrTXc5wwMEfudGWycmmCi5dH0RstZSduB1z/dvxG/F8FxEJT9sxOeUVnyIN94rQGhHSdQa4lfxsud4c0/Jvby8FY+gfblQVCXnCGJGafgi7CIhf1HQTyPfnh1s0yt3oXrv6xxJOBsKCfo2X/stsLLk9uUp2QZebu18xUn7+8+WYoXxTUATH9Eom5eGkGsC6KmIKVstwE3sNLICcnAuecZg+C/4gH89lmNIDW/RmORQv76o+MN4zvU3L2C5FMe3meyzqojNHmdCbS+05ZKthw3sLfhIApYQV8o6MkrKJCUqWdO0HBWpjz44MBO/AcMNPNfBw1Fi1Uxuugwq/2Yo3YonnsbVR4HoGYggIzbjToXLDKaWmd7j7SjM/OIXuA9LcsZiZyEOeqCkemjmcoHKyxOM/tcEBwTatldVLoA9KO6U1Hu8MLZ6UEJcVfXluJNtx7VD1MEJRyRjIeZatPj1HfTqaJRs
 UQ4n+0NE
 vqthwjuiTyPGo5dpNNNk0li8YG6cAJ+4ZNpOQuo8s931KAKYeCE16O2jbu4WRNFTgtNshUX8dlkW4oxMjKyMTHoK/1KT5PRT51wpzl0AwegesU7AiT3o0+iYe759EjQec4IPopy369xTWueA2A7pDsjjClqd2KlLngEEFyvs8WJClQZv5g74yqTWVu+rjip3Dy4PVVi/+BrOh9V/QNbtzcVlzIYTQN6doutks/0S7Vph1FEloSkMg+VKH27KkSeVi0cWo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 14:47, Vlastimil Babka (SUSE) wrote:
> On 6/2/26 13:20, David Hildenbrand (Arm) wrote:
>> On 6/1/26 18:16, Lorenzo Stoakes wrote:
>>>
>>> Err what? The 'random' tree is the MAINTAINERS entry you are targeting, it's
>>> based on the mm-next stable branch and only diverges in the work that's been
>>> done specific to the subtree, what's crazy exactly?
>>
>> We'll still have plenty of patch sets that touch files cross trees.
>>
>> I don't see the problem of sending stuff against the integration tree from where
>> it can just be cleanly picked up by sub-maintainers (after all, that's where all
>> the subtrees were integrated against)? Or what exactly is the problem with that?
> 
> The problem is that the patches would not be applied on top of the
> integration tree, so it doesn't make sense to base them on it in the first
> place. Unless they target the next cycle, where the integration tree would
> first become part of rc1, which would be the new base for all the
> submaintainer trees.
Why does that matter?

For example, the slab-next tree gets merged into the mm-next tree. Submitter
will send against mm-next.

The slab maintainer will cherry-pick the patches on top of slab-next. From where
they end up in mm-next.

In the rare event of conflicts, the base-commit ID is there and known. If it's
too much of a mess, we could ask to resend against the slab-next tree.

Again, TIP allows that. For example, I never based any x86/mm patch on x86/mm
and ... was fine? :)

-- 
Cheers,

David

