Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9589A606A901
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZezyzzF7
Received: by kanga.kvack.org (Postfix)
	id A07826B05B4; Thu,  5 Nov 2026 06:52:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7866B05B6; Thu,  5 Nov 2026 06:52:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6F76B05B7; Thu,  5 Nov 2026 06:52:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5840D6B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:52:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE0B3A8583
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:52:12 +0000 (UTC)
X-FDA: 85400902104.17.4DF2900
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1D976140008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:52:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZezyzzF7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793879531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iw61JVpfIKVjEhkIHEUqUjEP2S+EN2i3Q4HRmPwDDaA=;
	b=nCpW1YrJtbolPsql5QL6h5rkTntzu+souBaGbJO2erBaQpLfk5q11hMazC/E2wa3/UshUi
	YGba08W7/lcKQlHlRXAn3gHCNed2Xi3QBrx06pJTon0iuMEU7sWjUaFs8KZLLEG1e/Abvm
	rdri4iOzPLak0mcLwMyY8SQfg5B0n6s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793879531;
	b=Ut5sTkKoFnumGrbNpeq6cqTVbWa+NpBZUYREw0l4wcWGJbNE9kmZvjvpP3ypRdud/giO3z
	iNpxEt27Xbb7IeBlQBtnqYG1JpXS490U2DTNkktTn8HTSecow5XCSEVww0gt0j7j7Z6P+m
	nse4fO/AqH/7hTZiOuhqGruqPeFsi4g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZezyzzF7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 486D041FF9;
	Thu,  5 Nov 2026 11:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4F71F000C1;
	Thu,  5 Nov 2026 11:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879530;
	bh=iw61JVpfIKVjEhkIHEUqUjEP2S+EN2i3Q4HRmPwDDaA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZezyzzF79xxs58ivikY6ldetzXBC/dypds00DxgP/L7ZF1hVsuYELq9LX0gF+4+vE
	 MT7+PFkpNgafCMv82vJCf/3SIAiQucZUl2DBLvuXIkc9REvx8a0+/n/ooS2bq9+BwM
	 3Jythe0bz8SKxemB0D4I8HnaLLlvOFWv2+6N9kD6vO0ppXP3gfxkFOuEpTXLhlSmTh
	 DuZ/B0lVDQ1DPw5eFroVAjdQvYknBxF26J6fnD++4sxGneiqekTUVl4elkX1UbHFdU
	 iaZ6urAVlo0fiYNNQjXWtufSkNWTYfA/6/p0Xms/MkikCP17CquHeQNujhnc1X9Drh
	 rX+GbVI1X26kQ==
Message-ID: <b45f79bc-5a3a-430d-8a64-5a1ac6097d25@kernel.org>
Date: Thu, 5 Nov 2026 12:52:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm, vmscan: make kswapd unreserve highatomic pageblocks
Content-Language: en-US
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, JP Kobryn
 <jp.kobryn@linux.dev>, Frank van der Linden <fvdl@google.com>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261104-kswapd-highatomic-unreserve-v1-1-38be5106adf5@kernel.org>
 <75540cfc-0577-4d91-9369-d1c4fe9c3096@gmail.com>
 <76431b4e-27b4-4922-bc59-bf97516b40fc@kernel.org>
 <e5865932-ccd9-4f7b-bb64-e05a6f7a60ce@gmail.com>
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
In-Reply-To: <e5865932-ccd9-4f7b-bb64-e05a6f7a60ce@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8zuzmxeywb7nxmom53as8h36j65uj976
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1D976140008
X-HE-Tag: 1793879530-510817
X-HE-Meta: U2FsdGVkX19sEHC8EKd8FQwbaZi1UP3MQNIYeOX3wwwTRR8LOIZWj02E1C53g99lUr2XdpceW8vmaAXD11nu1Vz0y0owPTSTOyKx4yhzdPRBf1lrTdibpDpPt+oaTXQfSMsC1EZsMUVuql3XBe7wTsTyFuvzR60B4spUeLLSBt0tn6yyb7Cxys8PC6DEd0/3wG5LpL+Vk5Aomeq7j6x0EPiXP4+0WjOvMVhPAglOW1uvgag6N7rJ1ieEkMDjPsCukQwHxw8EkJ1sZt8nPaTTyOAw4QBypCvNbhYyRUG9ryVD484ZliGccPiP2I6KdV6JtbCcFaKPaiu1ezk2lC0GK0IK7YCF/Z/rJGmR4pwsrMI1uS38s4AwNq5L52yJ6T/78QXAGCIIu+pmi0ezpRcnu0nYEafALPsDWlzUoqNV/VEkHusSmX5yO4WnzaJW1P35XtCq50yIbK/XbZXS4ft0xoU9rn3Bt7FIrG58OB4s9olO4jjkNqHps/AC7YVD/V9omsYqTQY2pv+IRKHRMW9prlBiYVC9taiCOg5ITa8euYSfaZR1Crb+UVorMKMqxloCViioPSrrN8XLodxbIJw+zCMbqBxEIALLxtNT++V7K4sBzZMe0EIy1g968O8PO+BaicnDhCK9jcd+hE6iNEfKkjpJhHhnhISq0ogJ6EjHmO0PifIP4vGTpsAYj0mI4YXy4X8NYyMr6568Ary6LebxbxElp7C3sYX68aL1LJ+9eFAv6XEn8FzocfRdg0fIS6zvdmanNR+k4B59I7b7F5Uj65H717M67uaT0zIVkeexNEca+ug9US3KeBxE+cNnuPn/m0JXGZNFuqbM/ltap0VZplxTXpS1If+s2ISOnoBT05PW0GXSkPuSXFupqsW1h/jwXyFAG7+j2Z2wAxTu5nwaJmxtuWaaQsKwTpldUPxBUDIr5B4dD8awsbL6rGO9PusGspTDqmp51vZL/g5vWQ6
 q3Q+v0cO
 91k5fZVXrrJAXPg+nLjsqPeoXw5mLPHxj+7XDTa8G8bwUCyiuKWcJ8FLzWMRAz9/fDu88LTsecPAJ8haiDKaMGzhle7D9MovBzo/oAP8q/1ujTP/9UMpTH812NNdDxGiYU61gh32ScGczmDWQBaMGFZ3X9l4LvlgoGeeOKNK/EjArlVUHetlKhEqv0Zz+YJLwL6cKGG0+wHLjwCrSoomcDbznVuJIdmHLTuq5B25OGrXCdNplk9HDDE4hgsoHKZtV6zpq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 12:43, Jose A. Perez de Azpillaga wrote:
> On 11/5/26 9:02 AM, Vlastimil Babka (SUSE) wrote:
>> On 11/4/26 22:56, Jose A. Perez de Azpillaga wrote:
>>> On 11/4/26 7:38 PM, Vlastimil Babka (SUSE) wrote:
>>>> Hook this highatomic unreserve to the moment we are increasing kswapd
>>>> reclaim priority, as that is when kswapd is struggling to make progress
>>>> and it should roughly match the case of direct reclaim failure.
>>>>
>>>
>>> isn't raise_priority true after almost every pass at DEF_PRIORITY, stuck
>>> or not?
>> 
>> Can you elaborate why? At least at first glance, kswapd_shrink_node() should
>> return true if it scans the requested amount of pages. So I would assume
>> that although balance_pgdat() will do multiple iterations to reach high
>> watermarks (because every round of kswapd_shrink_node() will limit itself to
>> SWAP_CLUSTER_MAX per zone for sc->nr_to_reclaim) this should not be raising
>> priority if the rounds are successful?
>> 
> 
> 
> it's max(high_wmark_pages(zone), SWAP_CLUSTER_MAX) per zone, so the sum
> of the high watermarks. by default that's at least managed/500, while

Ah thanks, as usual I got the min/max logic wrong, hehe.

> DEF_PRIORITY scans lru >> 12, so it can't return true above priority 8
> even when every round is successful. and sc.priority-- runs before
> pgdat_balanced() is rechecked, so a wakeup that balances the node in one
> pass still unreserves a pageblock per zone.

Yeah in that case it would probably be safer to perform the unreserve only
after reaching the highest (lowest numerically) priority and still failing?
I think it should still be enough to recover from the pathological scenario,
which should be rare (but not impossible) in the first place.

