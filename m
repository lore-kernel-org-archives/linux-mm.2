Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFCEFC5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 14:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A27C66B07D1; Sat, 15 Aug 2026 10:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF526B07D3; Sat, 15 Aug 2026 10:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93BFF6B07D4; Sat, 15 Aug 2026 10:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2386B07D1
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:44:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A279A80371
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:44:31 +0000 (UTC)
X-FDA: 85103774742.07.8E26FEE
Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9A36E40002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:44:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UFQWiPiY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.239 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786805069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FyocDWbiKEhWozB7O216bJDmqB/VWihVNpwHu3R+Vo=;
	b=JJ/0BmsAye7VfXjAiniW1/zQiZxfAfdZwP0IT/fNRnmGpKUHM8aC9zWcXKzihlqvcmm2UF
	MY6fhvFkHmfWetqgi3kwboijFrG57OrOWaBll3kLZ683hZnLH5Cukl5C5nAN4vzDJR7mbf
	79fBXJgVWxbp2FY3fkWzAZx+Zd36bf8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UFQWiPiY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.239 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786805069;
	b=itt4YEQ0cSlWXeGl9ay3X6GVd8rvYPpKHLFjq1hldmFoBo4wDHpSvKn+SVm0GtIFx0HUOq
	V8ZhJTsETlbL/KOL76DuTocK7wS/j0ncauluAk/wH3NnCLvtU/V1QJ2NZY+5hP2EPOGYY3
	PWAk/nQWcxAIA460R0x557SoJaW3rvY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ihwcnUGvpCpT1va2cNKOoueJ4crpL+N4d9Fdxf7d0bQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786805068; v=1; x=1787409868;
 b=UFQWiPiYnWXg9RLDyWIyRVKSpNYTEV+yAy8qHmeQci53th70XiSGBBi44or+5TsY9ixRSFAJ
 TJc91WE+mEbRtA5oWBtLbmlS2sRrxL+5/wBd/P1KVaIAVNosQIajD38dBs8JtoIIEQr0wE7mH10
 cjK/8Bvz1WSicLVyPg9VX2yo=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id 93f03fcd28b6c3a6;
	Sat, 15 Aug 2026 14:44:27 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 15 Aug 2026 15:44:26 +0100
Message-Id: <DKPLJ7RJ7PHX.Y3GTAR0JLYOC@linux.dev>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
 "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy Lutomirski"
 <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Yosry Ahmed" <yosry@kernel.org>, "Patrick Bellasi"
 <derkling@google.com>, "Reiji Watanabe" <reijiw@google.com>, "Sean
 Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 24/26] mm/page_alloc: always direct compact for
 unmapped allocs
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Borislav Petkov"
 <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-24-6f5729aa9832@google.com>
 <60bd3790-f350-44b4-8066-9e6a7285efff@kernel.org>
In-Reply-To: <60bd3790-f350-44b4-8066-9e6a7285efff@kernel.org>
X-Rspamd-Queue-Id: 9A36E40002
X-Stat-Signature: mcen41jcm5uj94okha9nrbtg9fycqz1p
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786805069-952426
X-HE-Meta: U2FsdGVkX1+9ofIl52SL86F52GBn1vx6jElC6C+fNhw/+mdDQG+E2nxds1Tov3L6wNeHtBQbYU80fu8qSsUK1vlScybd+t5pz3KWKFFvnSuOWy17+8imKTf9Yem+6AOSlytCqXaAlv4mSwPaOBmmUlEKAaNwgmaroxKTruBs/cKLya5CdSyGWUCTpWLFUSRjKdmLt5HP2gbGEA+5ejFj/s4K3fWOd8lKDO16fobtC6dMxD8JsflI+OublIKxvCjBZ2xm2jpcQnzu1bXbnepvg9NSqH0fzGKh+YousvqOsYdX+5VAtvShf/syMhjjcunhpIeG1LUUwq3wnkj8+4oXGe3hc8P0X6jxiYRuFLaOqW/fNZmmK6c2BUDRH9OuP6uJtegXWeZAuUtJIzAIKRpnXHMnAxQkN2IjWhaLeTDkwtarH0H6UjpNs5jCGVRxUtB5QF3vnRDMh722/Oi1IJi+1MsLUj/jNr9usYlhxJuEMtKSbWBeaHlMedUZqNr5ZCJWh4SCUtArnaLiw0TuZzxj355eE0cJz4gmnYe1MkvbhTL6G9yiUErx/YQPwYwrL2sYv8KSVB14WrB/TzS6PZQsUgbfHzuW1QyisOENX/MoWHoZyTgui8U4n6LSLpXq4lLp2IQqZzOG9tYUwbzwy/U/SoqaBbL4ELnkfWqfCS1hWOPEjAVjfHt+HbIUCuXHsKi9ks3JSOvUZ6LnDLgc/PPPf3YBdwAa19CSMAUIO19x+YhodELfTS9/VOfBiN8Ic+bcJ5/OJ1qkEhXNDx+ylJbKc9c4GugWW0rwwQanwVnIY1pCwBjSvQ+1dnj+XK7RXCc5xkPdJ7l222wdUDXk3na5XGISO6+MDzYkjXBG9EgtHpbvXREVPxpdarKSsnUR51RdbzdVyu3+TI8MkI3uSr81Xc3DzrUX7IswvUcw/ATq4ylgp/g64OcvbOYZh3Su3r9Hv1FxfwAsxrrMGKiftxr
 Exu/6NmS
 +G51dYIib3uS0MZusIru2S15xR7Y4cTv1IhWsbNLRh36dRduPJqDuuOInbFvDoH4Tu0HcyKc0PP54q1CA8gIG6v7QsxENH8W2NypaGjBc9ixrEV8NU90p2K7hWQlSyGBkmoNoZ5ILg4NhpNTlX6i/qg23GXloI9GipeutI+6MgqOIQFuXVlrmL2muC1XqElsZb4eGnsO0o8ODiywLnFVYDOP2JtXhxc+bafLeG9RJU0FIf2tJIYUppNwrooTeaFQVKlwr7SWOGzL/RcIh/ZXF3Hx1igzBci07Ocjxfez7dXYFbN2PP94xTENugwGlbkTVY1DccLrfpbc+cXdkM5PPMZpuXWrEjqCEePf6ey1Bj/F+i/f3aUwQ5QNq6TBu5FTx+/cs3djOH+ZFBY8BdbhfO6WPEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 3, 2026 at 10:44 AM BST, Vlastimil Babka (SUSE) wrote:
> On 7/27/26 00:22, Brendan Jackman wrote:
>> This is the minimal solution for ensuring that compaction can service
>> unmapped allocations. Without this, it's possible for compaction to just
>> check watermarks and see plenty of free pages, without being aware of
>> the direct map state, and thereby cause an ALLOC_UNMAPPED allocation to
>> fail unnecessarily.
>>=20
>> Instead, with this change, promote compact_order to pageblock order for
>> unmapped allocations, much like defrag_mode. Then, check specifically in
>> compaction for the presence of wholly mapped blocks that can be unmapped
>> once direct compact is complete.
>>=20
>> This all takes advantage of a major simplification: since unmapped
>> blocks are currently always unmovable, this can be asymmetric. There is
>> never a need to promote a !ALLOC_UNMAPPED allocation to compacting at
>> pageblock_order, because compaction would be trying to generate a
>> currently-unmapped block to map; that will always fail because it would
>> require migrating unmapped pages, which is not supported at the moment.
>>=20
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> Nit:
>
>> ---
>>  mm/compaction.c | 22 ++++++++++++++++++----
>>  mm/page_alloc.c |  9 +++++++++
>>  2 files changed, 27 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index ed12d2fc6fad3..fe1aaf293bbce 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -2531,12 +2531,25 @@ bool compaction_zonelist_suitable(struct alloc_c=
ontext *ac, int order,
>>  static enum compact_result
>>  compaction_suit_allocation_order(struct zone *zone, unsigned int order,
>>  				 int highest_zoneidx, unsigned int alloc_flags,
>> -				 bool async, bool kcompactd)
>> +				 bool unmapped, bool async, bool kcompactd)
>
> Instead of the new bool parameter, can we check alloc_flags for ALLOC_UNM=
APPED?

Lol, yes. I guess I didn't notice alloc_flags was already there :D

