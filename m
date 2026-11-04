Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5FAC606A85A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFD2PUd6
Received: by kanga.kvack.org (Postfix)
	id F30516B05CD; Wed,  4 Nov 2026 16:17:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE14F6B05CE; Wed,  4 Nov 2026 16:17:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7B76B05CF; Wed,  4 Nov 2026 16:17:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B440B6B05CD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:17:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E525160823
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:17:09 +0000 (UTC)
X-FDA: 85398696978.30.C08FC27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 79D3A2000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:17:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GFD2PUd6;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793827027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9Gv115N0bDoQvMBYyTS/wpgW4qJjq8VbxC+yRP4KyM=;
	b=7NriC6HRxaunbNhmnscsb+osgxyKgJZpdqpocolPUm2NHst1yIWtm4zNAKJST0DVCY7Q0c
	+EmrW0MW4R1xWZFXmF+f9GSmY/dLniIKnD7klT3tA4f62Qg2i0ndTBNeUEXKxs5yvUnS3v
	OIfCtpt4uxCsh0CocCs+gifgyQR9/cg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793827027;
	b=T9fjK+VAk1W6mW3fkOoosZjIsrMWLO3UP2pOQbBMDsnZXJbtVuTXiTenWxGUPT3Wbvqr5H
	zxAeTz3vDvxBePyMoPajZVEpqo5xJslvgw9eyPrBnku6RNQ0xbInlIONvx/cSGvSSFWwid
	4b8I/lHnMCUXvRVWGRZWVCEeLGjTjLU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GFD2PUd6;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1F03636FD;
	Wed,  4 Nov 2026 21:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9F81F000C1;
	Wed,  4 Nov 2026 21:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793827026;
	bh=h9Gv115N0bDoQvMBYyTS/wpgW4qJjq8VbxC+yRP4KyM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GFD2PUd6BTj5fmrmmSI+cZ4E9GEI3LlMEpflSkZvI2Iy/HKEsVlDagxEPEYiOX1eu
	 6ElyyncQ0rrwyIBIkPp/XWwhgdzsXBn+/b90KV+TEsMkmwI+miczIyx0CMAnIRszrV
	 705QVia+UUi4xkPdegCLDBIKBVSAkfwNHY73/TtBbhHvZQKJ0cvxQ1vTe8DfdvO/5V
	 CbsXTMlP+I9ChkLIInzYDZH6Vkf3DmHKKpxT8mJTXjBn6MGg5ViExoHIydhw/tlacZ
	 fpw3hq5lGgYMN1XG4QVJV5Y00ZJDWpXQXrOvu4alhhntZgUzcaCrgL3afy4QpZXkhi
	 VA8UKKlx7LIIg==
Message-ID: <963b9722-ca48-49f9-ac04-857d3d1526a2@kernel.org>
Date: Wed, 4 Nov 2026 22:17:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm, vmscan: make kswapd unreserve highatomic pageblocks
Content-Language: en-US
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, JP Kobryn
 <jp.kobryn@linux.dev>, Frank van der Linden <fvdl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261104-kswapd-highatomic-unreserve-v1-1-38be5106adf5@kernel.org>
 <auuPhqCcgZBt_lUR@quatroqueijos.cascardo.eti.br>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <auuPhqCcgZBt_lUR@quatroqueijos.cascardo.eti.br>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 13fcufm35hxtpd591da4nayy9fgacw9h
X-Rspamd-Queue-Id: 79D3A2000F
X-Rspam-User: 
X-HE-Tag: 1793827027-364795
X-HE-Meta: U2FsdGVkX1+Z74McuUTkGqsaPd4hkAmbay5VscnXERvT4MvrOCImmaqjwHdUq7BNtEHfpd7YWuOvszS+CYaqkBHeUvgePk07/JcdxRd75gdkFWHSHnaFNgIZWGPQMiU8r4BnNzvXcorDcmFd5U3s0SEjyqcHBAQq6qTbl+UAMSrYhHNKBOEf9HjMjeYuSERPAHcE4qYkUFQqJ/qekASVeJhBTxRtzSYWUJFDRi/qGx0fHB8ek9tChTvhhCJHKJ2VQ41Q4T6MYtYUFVbiX2eu+D+3OvwH+l8bO8tXsRTDz2N+kV6C1nHGPcNhO/o6zPPDhM5Wp4+/YrvoBT9szJp8cmFqgL9ZDorP7ygAenRnzitBFog5QO79gWlwve37ue2Bii0z9R/I6BrutDF/JuKhPojepuVs5IMnfD9w5mVNhUg9LxW5U6IhUZlzJw+4PqECPzvlmUJfwtq1gLkhlggCdJuscW0OPcgD/uaqegE8sbX/EcpQCE57VsqPQ+zEXkU2vvoxjhTzP5dPTS9odmvINMJuq0Gf0T/CR7ZM3EPo6aYng3IkWoNWR8jh6wBuFk1ePVWh/iraCYL5I7v7vzf30J307+pvv8skE8pkb9hdHHBm2g7hL/wDHQez1Ppnag7yicD861brTpdtwAK5V7VwQYugVYRcpyo75AmLiWxXHB/6Hfasob8BX9ihStTvpi0TJMAYjvA7TjKSSX4WsVFEbrhnnQ7mKOTwMgjfvhfp2edeKqe0FYmrERWKe9xhtwBYY/k/PCqLo42uTeqTg62V+8RtFN2RXXTwpaM2bromB8oQf/Ll6NQXsmgucjSeVPhAL1WEV0KZ5abHg1iSgdw+W7K98ak/H/xuKxESq6zBC59lsYwRGofCqwTf+uS9Esd8p7/weBcghG6xMP5x1E8Bq7Yq4Cb7PvqPJ9DxySugY4ByCMsdSBNpHC6STYlnqcwFfYH6dCuN/mThwX5jS5O
 xcbLaKpw
 7jE+8xWHeW5FtGkcBd1QR2b8I8N3gmwyvab4HZ3A423GgM15E3HkNq6MNGmb1fxonBxbRURirzkWQe9VrEM10sA0Kq4ACZ4E0eM0VgZtpBAF7T0SBem945jdhCiX0HuRGvy5smh65U8Cscqsrzt9CfhAvCritsXtTJaM4x8X74FG0BC1YJClFLzB/KwXG/DbJWZvm38t0wskqRcN7CydfttBlnnoYHh7wTv6vn/8oB1dGL57/Cwkw5oQroiddwR3TUD2OArJJcr6k8gUKdgJc5lbYweV2H443joDE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 21:03, Thadeu Lima de Souza Cascardo wrote:
> On Wed, Nov 04, 2026 at 07:38:44PM +0100, Vlastimil Babka (SUSE) wrote:
>> A customer has reported excessive reclaim activity despite memory above
>> high watermarks. Analyzing support data (including sar log) revealed the
>> following scenario:
>> 
>> - the system has almost all memory reserved as 1G hugepages for kvm
>>   guests, and operates normally
>> - due to a spike of memory pressure from userspace, highatomic
>>   reservations occur (probably due to e.g. concurrent network receive
>>   activity)
> 
> I think you might mean 6a204d4b14c9 ("mm/page_alloc: only set
> ALLOC_HIGHATOMIC for __GPF_HIGH allocations") as one of the fixes you
> mention below.

Indeed.

> In that case, GFP_NOWAIT (which is typical for network activity, AFAIR)
> would be one candidate that would produce such reservations. But I agree
> that if any other real highatomic allocation burst would happen, it might
> produce such reservations.

Ack.

>> - on one of the 8 NUMA nodes, this creates a situation where free pages
>>   are above high watermark, but when __zone_watermark_unusable_free()
>>   considers highatomic pageblocks, the result appears to be below the
>>   low watermark
>> - pgdat_balanced() is false, kswapd hopelessly keeps trying to balance,
>>   spending cpu time and disrupting the system. It has nothing to reclaim
>>   because the node is filled with hugetlbfs hugepages.
>> - since the overal memory pressure is under control again and there are
>>   no allocations restricted to the affected node, they are satisfied
>>   from other nodes without going through direct reclaim
>> - since direct reclaim is the only code that calls
>>   unreserve_highatomic_pageblock(), this never happens and nothing fixes
>>   the situation
>> 
> 
> I am trying to understand what is going on here: so allocations on that
> node are only !__GFP_DIRECT_RECLAIM? That would explain the highatomic
> reservations in the presence of the bug just mentioned.

They are probably __GFP_DIRECT_RECLAIM, but if they only origin on a cpu
local to the affected node but can fallback to any other (which is the usual
case) and zone_reclaim_mode is disabled (by default it is), they will just
succeed on another node and not attempt the direct reclaim.

>> Note this was observed on a 6.4-based kernel and there have been recent
>> fixes upstream limiting the highatomic reservation side, but I don't
>> think they can prevent the same happening in mainline, only perhaps
>> lower the chances. Nothing seems to prevent the issue completely.
>> 
>> For example, while we limit the amount of highatomic pageblocks to 1% of
>> the zone, this calculation does not subtract the amount of hugepages or
>> otherwise permanent allocations, so the highatomic pageblocks can end up
>> taking much higher share of actually reclaimable memory.
>> 
>> The most targeted fix thus appears to be to allow kswapd perform the
>> highatomic pageblock unreserve to match direct reclaim. It's also
>> somewhat similar in principle to how kswapd reduces watermark boosting.
>> 
>> Hook this highatomic unreserve to the moment we are increasing kswapd
>> reclaim priority, as that is when kswapd is struggling to make progress
>> and it should roughly match the case of direct reclaim failure.
>> 
> 
> I tried considering a different approach, making the allocation do the
> unreserve in the absence of __GFP_DIRECT_RECLAIM, but I don't see why not
> let kswapd do it.
> 
> Regards.
> Cascardo.
> 
>> The only caveat is that direct reclaim knows which migratetype it wants
>> to allocate and thus changes the highatomic pageblock to. Kswapd doesn't
>> track that, so use MIGRATE_UNMOVABLE. Highatomic allocations usually are
>> not movable, and this will avoid creating nominally movable pageblocks
>> polluted with unmovable pages, so it should be the least problematic
>> default.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>> We interrupt the regular stream of AI fixes by something a bit
>> different. RFC to get agreement on the approach. Haven't tried
>> reproducing the issue in mainline, but it seems quite clear to me from
>> the data I've seen.
>> ---
>>  mm/page_alloc.c | 126 +++++++++++++++++++++++++++++---------------------------
>>  mm/page_alloc.h |   3 ++
>>  mm/vmscan.c     |  16 ++++++-
>>  3 files changed, 83 insertions(+), 62 deletions(-)
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index a8cac5e01066..785a13570788 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -3476,6 +3476,68 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
>>  	}
>>  }
>>  
>> +bool unreserve_highatomic_pageblock_zone(struct zone *zone, int migratetype,
>> +					 bool force)
>> +{
>> +	/*
>> +	 * Preserve at least one pageblock unless memory pressure
>> +	 * is really high.
>> +	 */
>> +	if (!force && zone->nr_reserved_highatomic <= pageblock_nr_pages)
>> +		return false;
>> +
>> +	guard(spinlock_irqsave)(&zone->lock);
>> +	for (int order = 0; order < NR_PAGE_ORDERS; order++) {
>> +		struct free_area *area = &(zone->free_area[order]);
>> +		unsigned long size;
>> +		struct page *page;
>> +		int ret;
>> +
>> +		page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
>> +		if (!page)
>> +			continue;
>> +
>> +		size = max(pageblock_nr_pages, 1UL << order);
>> +		/*
>> +		 * It should never happen but changes to locking could
>> +		 * inadvertently allow a per-cpu drain to add pages to
>> +		 * MIGRATE_HIGHATOMIC while unreserving so be safe and watch for
>> +		 * underflows.
>> +		 */
>> +		if (WARN_ON_ONCE(size > zone->nr_reserved_highatomic))
>> +			size = zone->nr_reserved_highatomic;
>> +		zone->nr_reserved_highatomic -= size;
>> +
>> +		/*
>> +		 * Convert to migratetype and avoid the normal pageblock
>> +		 * stealing heuristics. Minimally, the caller is doing the work
>> +		 * and needs the pages. More importantly, if the block was
>> +		 * always converted to MIGRATE_UNMOVABLE or another type then
>> +		 * the number of pageblocks that cannot be completely freed may
>> +		 * increase.
>> +		 */
>> +		if (order < pageblock_order)
>> +			ret = move_freepages_block(zone, page,
>> +					MIGRATE_HIGHATOMIC, migratetype);
>> +		else {
>> +			move_to_free_list(page, zone, order,
>> +					  MIGRATE_HIGHATOMIC,
>> +					  migratetype);
>> +			change_pageblock_range(page, order, migratetype);
>> +			ret = 1;
>> +		}
>> +		/*
>> +		 * Reserving the block(s) already succeeded,
>> +		 * so this should not fail on zone boundaries.
>> +		 */
>> +		WARN_ON_ONCE(ret == -1);
>> +		if (ret > 0)
>> +			return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>  /*
>>   * Used when an allocation is about to fail under memory pressure. This
>>   * potentially hurts the reliability of high-order allocations when under
>> @@ -3491,70 +3553,12 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
>>  	struct zonelist *zonelist = ac->zonelist;
>>  	struct zoneref *z;
>>  	struct zone *zone;
>> -	struct page *page;
>> -	int order;
>> -	int ret;
>>  
>>  	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->highest_zoneidx,
>>  								ac->nodemask) {
>> -		/*
>> -		 * Preserve at least one pageblock unless memory pressure
>> -		 * is really high.
>> -		 */
>> -		if (!force && zone->nr_reserved_highatomic <=
>> -					pageblock_nr_pages)
>> -			continue;
>> -
>> -		guard(spinlock_irqsave)(&zone->lock);
>> -		for (order = 0; order < NR_PAGE_ORDERS; order++) {
>> -			struct free_area *area = &(zone->free_area[order]);
>> -			unsigned long size;
>> -
>> -			page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
>> -			if (!page)
>> -				continue;
>> -
>> -			size = max(pageblock_nr_pages, 1UL << order);
>> -			/*
>> -			 * It should never happen but changes to
>> -			 * locking could inadvertently allow a per-cpu
>> -			 * drain to add pages to MIGRATE_HIGHATOMIC
>> -			 * while unreserving so be safe and watch for
>> -			 * underflows.
>> -			 */
>> -			if (WARN_ON_ONCE(size > zone->nr_reserved_highatomic))
>> -				size = zone->nr_reserved_highatomic;
>> -			zone->nr_reserved_highatomic -= size;
>> -
>> -			/*
>> -			 * Convert to ac->migratetype and avoid the normal
>> -			 * pageblock stealing heuristics. Minimally, the caller
>> -			 * is doing the work and needs the pages. More
>> -			 * importantly, if the block was always converted to
>> -			 * MIGRATE_UNMOVABLE or another type then the number
>> -			 * of pageblocks that cannot be completely freed
>> -			 * may increase.
>> -			 */
>> -			if (order < pageblock_order)
>> -				ret = move_freepages_block(zone, page,
>> -							   MIGRATE_HIGHATOMIC,
>> -							   ac->migratetype);
>> -			else {
>> -				move_to_free_list(page, zone, order,
>> -						  MIGRATE_HIGHATOMIC,
>> -						  ac->migratetype);
>> -				change_pageblock_range(page, order,
>> -						       ac->migratetype);
>> -				ret = 1;
>> -			}
>> -			/*
>> -			 * Reserving the block(s) already succeeded,
>> -			 * so this should not fail on zone boundaries.
>> -			 */
>> -			WARN_ON_ONCE(ret == -1);
>> -			if (ret > 0)
>> -				return ret;
>> -		}
>> +		if (unreserve_highatomic_pageblock_zone(zone,
>> +							ac->migratetype, force))
>> +			return true;
>>  	}
>>  
>>  	return false;
>> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
>> index e238ee91ed24..9fba6480b18d 100644
>> --- a/mm/page_alloc.h
>> +++ b/mm/page_alloc.h
>> @@ -282,6 +282,9 @@ static inline bool free_area_empty(struct free_area *area, int migratetype)
>>  	return list_empty(&area->free_list[migratetype]);
>>  }
>>  
>> +bool unreserve_highatomic_pageblock_zone(struct zone *zone, int migratetype,
>> +					 bool force);
>> +
>>  /* Convert GFP flags to their corresponding migrate type */
>>  #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
>>  #define GFP_MOVABLE_SHIFT 3
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 9959ca158ce8..91c622068d99 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -7460,8 +7460,22 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>>  		if (nr_boost_reclaim && !nr_reclaimed)
>>  			break;
>>  
>> -		if (raise_priority || !nr_reclaimed)
>> +		if (raise_priority || !nr_reclaimed) {
>> +			/*
>> +			 * Similarly to when direct reclaim is retrying, try to
>> +			 * unreserve highatomic pageblocks on the node. Convert
>> +			 * them to movable ones as kswapd doesn't have a target
>> +			 * migratetype, and passing unmovable should lead to
>> +			 * least permanent fragmentation.
>> +			 */
>> +			for (int i = 0; i <= highest_zoneidx; i++) {
>> +				struct zone *zone = pgdat->node_zones + i;
>> +
>> +				unreserve_highatomic_pageblock_zone(zone,
>> +						MIGRATE_UNMOVABLE, false);
>> +			}
>>  			sc.priority--;
>> +		}
>>  	} while (sc.priority >= 1);
>>  
>>  	/*
>> 
>> ---
>> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
>> change-id: 20261030-kswapd-highatomic-unreserve-7e6629ec65d0
>> 


