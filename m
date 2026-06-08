Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D09CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 18:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 540406B0005; Mon,  8 Jun 2026 14:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1426B0088; Mon,  8 Jun 2026 14:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0036B008A; Mon,  8 Jun 2026 14:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2ADA86B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:39:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D62E1639C2
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:39:24 +0000 (UTC)
X-FDA: 84857608248.17.19CDA39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B84581C000D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:39:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GiAkAKnr;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780943962;
	b=Hpi/eTwkDbKClTGCt1OUCdFJUN2K2ubnqce/smZ7wYchXbN50a1IP5J5zLkmu5OetLNTtE
	qvkdRWN8u2gxP2xMSavNmCT20YLnAOnKPt4EL0LjdqNNCoHgfEvaqCCkLeR1W7smbellNC
	UbsO/UUlyjJ35QK4ENdD/zpo+CgALVU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GiAkAKnr;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780943962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=za27+SB5/YA+oiUdbr1wpc/S+PrTSfT8moovwJUuByI=;
	b=CyY5IhCWe4aTCXVm6IjLTzQPGcOp4m55iRNMgfRY1OfFQu/pobgQacG4FwFKr74P15sbbX
	FDI0SXhvJgyNZu5vqEs1bpMiKT0y0jzq9BXRNHqPJ/vIZh4JFIggft3cfV3Q9/3GuzJMsv
	ahsNGCI+HpHPaMdgkUD5fRF90GCSruc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7DBF40B98;
	Mon,  8 Jun 2026 18:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCF71F00893;
	Mon,  8 Jun 2026 18:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780943961;
	bh=za27+SB5/YA+oiUdbr1wpc/S+PrTSfT8moovwJUuByI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GiAkAKnrheBqOulNbxwXdro8nA3WYX05o33l+zwj3OIp853p3PPlXw+YI4dwVesw5
	 2Dq6WRE7wTNM63SDi5LUTUsJ2fOkR/R5h+gWmuVVuIMVsCM7BUh4HhvadgqOzkqu3P
	 7y1yRs7w6MEEmVJtH2Q6OZw7+QVPtItS6jDVTta96UNCwlXcu4cgBhqjBwNfY9n2qw
	 wn0DgA80OkoCeOAIgc5O+nZehTDD2ihmoNfZ8MHBOWZDwirz9YPgztRnNWu+x6Qu1Y
	 QSrFNMvKWeSrrvTGV0Qx95TVE5JRTVF/NFC4blTp7WX4ekX/eY132ZbuRzdao3rtCa
	 OAgtwYMhdoG4w==
Message-ID: <2475e4c4-9ba3-4091-9bfd-1c1c15163da7@kernel.org>
Date: Mon, 8 Jun 2026 20:39:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator for
 cache-friendly zeroing
To: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer> <64f2e580-aa82-4849-9236-b8ec4208ca24@kernel.org>
 <AEB19464-20A9-4C5B-97B8-681CCDD81031@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <AEB19464-20A9-4C5B-97B8-681CCDD81031@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B84581C000D
X-Rspam-User: 
X-Stat-Signature: wkzntpsrzk7e8u8dqt17mhhu8osknhtr
X-HE-Tag: 1780943962-406510
X-HE-Meta: U2FsdGVkX1+A+zaqLEX6qsU2a6peCqOdcHv/LJ/C0Z+Gu2biR4na/HiRHWGXfykfNl7CIR0wvVesH/khUnkRCUhbtp1HCu6QsjVlIouqaereS7X10BrGNgMRaw6JzJ7mA8JFzc3iQp8HmRdC1xTkGYp3Jj1ubN5NL+vDS7Dn2aP8fu+Frxhz+sOq5Pe7wJoxoA2Z4RkzeWlnQF6HS+oibmWLulGAUxR+MTKjlHk561s6vuJ2Ne9F7EYUU3CLUY0KduQ2N8dYb/f14Y+bvF+r94vapinM9KGvIXl2xCeXRpFV98kUiv3z/u9CjK4mFTD4tI13Sqv2Ne+iYQLMoG39B75spv5rMtigOJ8CMOBABLnuJdZxhy+E8Rza2ekh1SNJhC0c9ECx2qwXf+ScMjtWA4ENLFkYzd0zLyow4oPrFhy05W1+k0zA+elssgX8nb4j/XJXmyvcYdFvnNoL/KBPA2iL+lpivZOFh/h1OQkpH0dNG+EiAYbRxDoNSweg5TQjv2mWrCxTQPvvskIR52aHLLUKm8qUsWvIqYzx80SNZcT1u5xKlAuPSMX64spZw9j9UdpjWv1EcZ550qyCCGKsqI+XSrBBaummgs21EQeq0m1F9qTdx4S9m2z2iaGL7b0xZwmB9NbpgBB+zIQGFY4ov1w27g2FTlVnNA914QpwZk0iv9TmifvMrap6fYJ9uqXcqAVZvj7JSJJArJhojVtl0ANLC/W6SMs34AUEeT5Wx56T/d2TTkh/luUobLCaWxb0OyGY/DAPao0hdBK+39DAZeG11tRKJSlPFQ1MLWCsOljj/M+ZiZXFspDX9vCw38zbp8YmI4f4cWV1MixtsnUMyymXJFZddndjObdoMPCJOk3JWlKrNzYqyJGjHaJUumVosAAaHACDo1MOpub8igYPiRAIz+X8os19o2vMFrbk+E4U0SFst7FQGe2AH4ScLvRPWidtK09wllh27oKDdBV
 7Rur8tiu
 WRbPiGJlNLPOYl/pSiVYHDOZLTvcGeIu8AuBS3jVqGasM/EhS2WXYqdQlefH3sTNf3drXWce7Rmw0gWRHkHR8XYWvveNDVSATGI98oGR/5ZUxeYFZ7AauUZieUBebMfk7ynQbDrGx4GGEpnDwXtCW79R79obn7AwhdqFFV/A18lI6rHV6SQlbpiTpzw4MJa6wmlnDAhmrGUqAc6FGVs6ZKt+boOAC94lIc1T1CWHHcL9+lVX2q2U7saSSIuOAW0VFWz/SAz+76T+UUhZWLQSwEfbLudpaK0LpbFpzqSOOwcyt2Xu83snBlwOn1tYDufZ0I9AiwGjG1RqJpRqivH+VEcn4ilOIZbIz3dhqHyDZu5otxLtgZQpkL/JPA09UJgyp9VxU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 17:27, Zi Yan wrote:
> On 8 Jun 2026, at 7:08, David Hildenbrand (Arm) wrote:
> 
>> On 6/8/26 12:23, Lorenzo Stoakes wrote:
>>> I noticed this patch, again, sneaks in some additional code changes that
>>> are not mentioned in the commit message and seem irrelevant to the patch.
>>>
>>> Not sure if the AI is doing this, but please don't do that.
>>>
>>>
>>> This feels like very weak justification for code that massively changes mm
>>> code and makes it all much worse.
>>>
>>>
>>> Is this the only relevant code path? You're changing a TON of code here
>>> that will have multiple different code paths?
>>>
>>>
>>> Ugh god, so now we're passing a user address through allocation paths that
>>> might not even be aware of this or be allocating memory at a point when the
>>> mapping is known?
>>
>> The original ideas was to do this only with internal interfaces. I think I
>> raised before to leave hugetlb alone for now.
>>
>> Fundamentally, user_alloc_needs_zeroing() is something we should get rid of, to
>> just be able use __GFP_ZERO and do zeroing at exactly one place.
> 
> Just a reminder that user_alloc_needs_zeroing() not only checks init_on_alloc,
> but also some arc clearing page requirements. To do zeroing in one place,
> clear_page() used in post_alloc_hook() will need to learn how to handle
> arch-specific zeroing from clear_user_page()/clear_user_highpage().

Right.

> 
>>
>>
>> The question is how to pass that information (user_addr) through internal APIs.
> 
> Or should we defer zeroing after a page is returned from allocator? So that
> user_addr does not need to be passed through irrelevant allocation APIs.
> Something like:
> 
> alloc_page_wrapper(gfp, order, user_addr)
> {
> 	page = alloc_pages();
> 	if (gfp & __GFP_ZERO)
> 		clear_page(page);
> }
> 

Not really sure what's best here. I think we'd want to limit the lifting to some
internal API, so it cannot easily be messed up by random kernel code calling
into the wrong API and not getting pages cleared.

-- 
Cheers,

David

