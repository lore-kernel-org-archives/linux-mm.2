Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09390CD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 08:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12336B0005; Mon, 15 Jun 2026 04:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC32A6B008A; Mon, 15 Jun 2026 04:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B3436B008C; Mon, 15 Jun 2026 04:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0926B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:45:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51B7416627F
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:45:34 +0000 (UTC)
X-FDA: 84881513388.11.FB4F9D5
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6A2CD1C000B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:45:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hkljb8J7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781513132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Jm4k2i1ci/THg4OcVgCv1Y10n2g7/5+J2F//tf0Ado=;
	b=RXQiSpvF/2DvD8QpqiA8A78O3n3Jj2kjpiJntsnNzttznfjisgYDMpFh3MHV55UHRxv4NP
	BhYASOoZosn0qrBL996JW82CUtcrkL9KaTkbplrWLKFfsV2jX9Qhe4T3B1iOoUwpS/UQas
	plQVqrLMZUE2t13a2tf2N/r5dLfKoro=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hkljb8J7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781513132;
	b=qhRC/Pf+9B4sPv3T0CwZW+hLg4rnnu8YxlLF+vGnwi7ci5bOnqql7tafI4bIIl9RcESUfU
	wNa30g019evBRWqbhVOlOMU7p1reTt/DEbTiilpxLv6fxWe9sM0P96hLsApenvHr8dVWrK
	60CR8wIIP0JX6DXxXjgv/YqpNskDjOw=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781513129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Jm4k2i1ci/THg4OcVgCv1Y10n2g7/5+J2F//tf0Ado=;
	b=Hkljb8J7pCiLEUhyQY16gBNRETl0vYvjfj/swktUmFSzMKg8I0fR4+bIC8enNuSbBnZfwh
	3R9UTd1e1xfylTPm/Fiy7Z8JsbGEdq6aGH5xaAPjMyB5kXAIDU8vK5fGefV27Fhm2M7tbv
	MX/zl2wkZoqzXvOYThktd19dkbVpSzo=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 14/19] mm/hugetlb: Free cross-zone bootmem gigantic
 pages after allocation
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ai56f5AxGJQ5SiGp@kernel.org>
Date: Mon, 15 Jun 2026 16:44:48 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <386B96EF-7EBB-44C0-8B83-D4BB8B60D649@linux.dev>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-15-songmuchun@bytedance.com>
 <178041489395.457517.12727427621570734471.b4-review@b4>
 <1ABCD934-CA2C-4541-9B76-32FAEFD398FF@linux.dev>
 <ai56f5AxGJQ5SiGp@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 61a18bj9ffdjr6au1rjuxpyus8fqs8c8
X-Rspamd-Queue-Id: 6A2CD1C000B
X-HE-Tag: 1781513132-132010
X-HE-Meta: U2FsdGVkX19+6bRZRASO6cdz/5osYw4FSCuwO7PLoXeT4iXJRGDX6SLWJmqw1+QrqyHJTDaJNDN5tZBLCF7/jXzcWFiVxMwoxhetc0TcVRfG7VRCa45RT2NByCfcHu8tFF5MLHE315MYqrde+X6MqzH7ae7k+ztNS5z9A5M/LNH6Nlv6V5fGYVE0pb8ON852KcShdrv7nfwjCttBQzyFWTlb/HQMm+jAPLcMpugF4+SGjcLQj6gvXhj9MRj58YVaVpvONSkCQL2BYrxcQ9K9SKiXw7aQzJvdgiPommsNYui/p0VnpiBfAOXKLm1bz1GAYIEtB5SNaZ7iDp8sb8cqukSVAHnhTNjYEf6WOkyPoSR6S8dvmq8GjhwQB4DXL+Ouj90HQ864HouOEmk3ASh6hbdePE0OX72Gfr/RILfGUkZTCdIM7+u2Ng+PWPl7XA3QD7P/hgFq6OnaZYa0aPAWDJhKw4RAfgdiybRxKl7yV1yDi5H9+483u3laducmlKhfws1BinhpmxkTHGchH1ane8flzrVzCANdwgDZeAbXx6AASe31ENP9/QyKJzUDhDz1Lo+BFxQ6pq5TrGEthy0STUD2J2DJ1fgGfVTDrPuilD3y9vcWs9AAo1ASZL0TeYehYsS1wcDGfIk3ZdT6lZMfQyWQytvTYaI6Q5/hH9hzpXg/wm/K6q+sbEb9nXI0NwAJ/Sw8NRixO7CKPTIwuY/Xkmc8IEa455aYyjPAQp0B97+WuA5Z+LbB6WsAy2GwLuVIfTJeSF4nKCQ9UDWuWfgWh0KhINjMBjWm2GWKdaIN+wrDX4/DtDJIBeH+JwaMQlbWDkfJ/doeAIe6kCf5aUI0yboJ/0vKcu/k3E5w8v2KddIUEG734q8BSFCg6HADSlFlIWbeHmU9QgIhs4IDrfANyZuzP//zew38wJ6qeEgBvZiLe047g/u9CtTn5NFyUdaVaZaPyp9sV7GxFbGD4f8
 1qrVZ3vH
 vA5o/Z3nrG4d/b9jKl07KP/uxMVnc52FRXwRSRFlMbTzmyreYykPuoidiKcNGdYzvDbxRhDbNV9FyU2Ge+CFojBs1c2qLB6vQeAmseCUVUm08KTLjFTwMbZLHA9rq7Ti9wUV1AT91/Yi/FdsT4HvO6J+iKELzoiUAG7qCWey2eIbr/dxKK+d0wc+O8UMUN7zQpuoTNWO3mW9AoVVgyupEbaKm1uUXtBeqSjJKwT4A883NA8Imw34NRHKIJTcKJIjHnLbydtwXiTCewLRRzP7jvPp6QbDQHIYebaZIy8bHWnYQT9w68J8skFBoe804lHTfp85Xzlam8zIukZWSG2jJfoalWexOxOMUReGM1bnZ1B13JRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 14, 2026, at 17:55, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Wed, Jun 03, 2026 at 10:53:04AM +0800, Muchun Song wrote:
>>> On Tue, 02 Jun 2026 18:10:34 +0800, Muchun Song =
<songmuchun@bytedance.com> wrote:
>>>>=20
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index 5e557c05d80a..218fb1ca45f4 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -3073,22 +3076,38 @@ static bool __init =
alloc_bootmem_huge_page(struct hstate *h, int nid)
>>>> [ ... skip 26 lines ... ]
>>>> + * pages belonging to the requested node.
>>>> + */
>>>> + if (WARN_ON_ONCE(nid_request !=3D NUMA_NO_NODE && nid !=3D =
nid_request))
>>>> + list_add(&m->list, &huge_boot_pages[nid_request]);
>>>> + else
>>>> + list_add(&m->list, &huge_boot_pages[nid]);
>>>=20
>>> Can we just memblock_free() the page that intersects zones here?
>>=20
>> I had previously considered doing this, but then I realized that if =
we free the
>> allocated cross-zone memory here, memblock is very likely to select =
the exact
>> same block for the next allocation. This means we'd just end up with =
this
>> cross-zone memory again, degrading allocation efficiency. Unless =
there is a way
>> to mark the block so memblock avoids reallocating it, I ultimately =
chose to
>> defer the release to prevent this issue from happening.
>=20
> You are right, there's no simple way to avoid memblock using the same
> range.
>=20
> The comment at hugetlb_hstate_alloc_pages() hints that we might want =
to
> split allocation of gigantic pages to be more explicit as a followup
> rework and then freeing of cross-zone pages would be cleaner as well.

Make sense. A followup rework is better.

Thanks.

>=20
>> Thanks.
>=20
> --=20
> Sincerely yours,
> Mike.


