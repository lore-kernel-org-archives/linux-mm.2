Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF37FF886F
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 03:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 877BF6B0092; Tue, 28 Apr 2026 23:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84F916B0093; Tue, 28 Apr 2026 23:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C8E6B0095; Tue, 28 Apr 2026 23:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AEA96B0092
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:02:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 23BD61A0665
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:02:14 +0000 (UTC)
X-FDA: 84710094588.26.D1D062E
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf20.hostedemail.com (Postfix) with ESMTP id B0F781C0019
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:02:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oxo6NdW6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777431732; a=rsa-sha256;
	cv=none;
	b=UZUBrXhPmfY+Azs34Y5MRG/gMz+mFbUNi2EWROrrZEuwYSvmlHcjtV3Vyv/urjCPvHlNVv
	hugASp1eym+kuzNxAXEMP4u3/iyuVJNIXmrfVkT6vRfqnujfWa+XSrrGsuPbbyQCnsVwi5
	wlsAzcP6EahDEoshmqkFRNfj7XiivsM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oxo6NdW6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777431732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/FM019OPNeOk2Zn+soqE+l3vbEFGXrxJeVq00i8YqA=;
	b=jWvqgPDdV64hty33+XGTYt3oBjpq/DHinYlcUruEwDarWN7c2Otg9DXIp7CyCCb0lBaHFT
	NUWonijvImxT0uBpiQ9a1xezLuvklKC1jBd2Vx6IBMWwlfC0WUtcx27TmxzxMVvLUbUnEv
	ei/zcywEZu5Dv36F4e5S78mU9gvA1x4=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777431728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x/FM019OPNeOk2Zn+soqE+l3vbEFGXrxJeVq00i8YqA=;
	b=oxo6NdW6M0lAsIZYY3RtZBdCAMu7S1zP9snq5kAiD/XXeKgJgZbX42oUZ/GflFxLq+JPl9
	ohJpjC/s/5lrT4PIUDrOXPb9G6oUSvl07gCyZ1ZCGW9ECdgICTJavHZ2JTifPXQBjZLCxd
	T90uCaJ8pdwRLu71pci2T9gcYmPFyms=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 14/49] mm/cma: validate hugetlb CMA range by zone at
 reserve time
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <afBiBUq98Msv7ZFc@kernel.org>
Date: Wed, 29 Apr 2026 11:01:06 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <25FDC3CD-2202-4099-8E42-877A68D3E546@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-15-songmuchun@bytedance.com>
 <afBiBUq98Msv7ZFc@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6kgykmz8unt6fsytjoyh4dwssjepyo4t
X-Rspam-User: 
X-Rspamd-Queue-Id: B0F781C0019
X-Rspamd-Server: rspam07
X-HE-Tag: 1777431730-932456
X-HE-Meta: U2FsdGVkX1/iPwHNH3TG2KPTQRnvlvtDVBZfDgIZgbPFSw5nwDZ9UCsTnogWpZnE0opSx/SPTBcqJQqDSmaS7xxUH0WaAzwr1ery8w1B0m00LFd+iHlm45ljIcloJEMWq9co9XIjFsKtMeDMRxqeqeaRZDbX3Q8bwbV2DTTOZWLK789gLeqmzONI1bsxQNH95YgrxaVrjsSjmOwxT0lYBtFb1EqPQz4c0uCJNLaY/MPZAvQMLIZUpsi8mZKt//M0HQfhjzAJipWUVXTZa3U6Xkli0zFLtbuDNzppsr9v6g0sKpmICCmBzomUQQN1NG9Y4Eo7J8QpiOZK87snBJSa8jZGhHtbUCoAPBnjvi6W5CPLJJFlvnJEKjSt77nEpaZfJaa36E4zEVyra4XK6fJ5A6R0/skBgbmVgLjV7e9LTzZuKrDW4AYdp+49OeGPa9KIdXq5moBhHk8NBcybgIhKDyNRdVqu0oaXPD80RYskO+a7sod49yoILRDN9c3n4VlafbPHxjHrlZZx5RqHk62Nd3N0spTqQXDOlO/kpixosgWtDQ01adMIceZqSoLLOSnLl6K2bYZIK+P6BfQ2HAC7yaAXr9C3mrWKp0S31PFhuUrWHlv0TXyK49QbyzIjpf5a1cDLNQMOtqSK3KncgEbT4cBWzh3xe4/tjPqgLrhGpuw7eRSIHpMdp/SY/iEn7ibzZ3/pg/tiz8AP4uJfZq8jqVGZZV2YAEYQrl7c0SMjpnZ+Kd4hTgnwvDMvDMQnQWQvpT4LHx9+X1YDI09bRcqbf+EwXo8Va2s+45yUfNQ/wg8fN36AurizPTft1LQruiUkPIgymOlG9jpZZqE7ua74KsCDT8hK4g9+tWZRl6eRxIiG1dK4t2RR6TyYLbFU0Ms9GiIT8yW8b5IZXRLPDVwfDyLaw/lIXP48bL1ZAMypY9509nAxzeipCeXUjwm8526EWZ2P23XW7abzQ5Scc04
 ALh8eACH
 twp2Ja1QlxX+LemNDNBWpC/0fO7SfLYZjewKUBBzgHpiTZ7Ca+waLQmmsVuctmdiR0+z4scqVZYcFOWNj5UMMjeSxUGs9X4j2o8a0GoGEQAw3VT9dIzlZBw2hucxHWNdFQo7RUBUSyZ6omC3qq8SHHsG8EWcLcYDLxSFqPUsam2ksT/71Rxi1eu3fsZWtfhRpq+g3c/JxAyroURtTqNKWOrI7m2E0iXzDDI/0DYf3+Q3HJZXs0emkVznx4VRUfG/g8pp7bUCzue4lhRfmM0iK0B93OVKEBrKveAYh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 15:30, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Sun, Apr 05, 2026 at 08:52:05PM +0800, Muchun Song wrote:
>> During hugetlb_cma_reserve() we already have access to zone =
information, so we
>> can validate that the reserved CMA range does not span multiple =
zones.
>>=20
>> Doing this check up front allows future hugetlb allocations from CMA =
to assume
>> zone-valid CMA areas, avoiding additional validity checks and =
potential
>> fallback/rollback paths, greatly simplifying the code.
>>=20
>> The pfn_valid() check is removed from cma_validate_zones() because =
mem_section is
>> not initialized at that stage and it can trigger false warnings; keep =
the
>> sanity check in cma_activate_area() instead. This is preparatory work =
for the
>> follow-up simplification.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> mm/cma.c         | 3 ++-
>> mm/hugetlb_cma.c | 3 ++-
>> 2 files changed, 4 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/mm/cma.c b/mm/cma.c
>> index 15cc0ae76c8e..dd046a23f467 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -125,7 +125,6 @@ bool cma_validate_zones(struct cma *cma)
>>  * to be in the same zone. Simplify by forcing the entire
>>  * CMA resv range to be in the same zone.
>>  */
>> - WARN_ON_ONCE(!pfn_valid(base_pfn));
>> if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count)) {
>> set_bit(CMA_ZONES_INVALID, &cma->flags);
>> return false;
>> @@ -164,6 +163,8 @@ static void __init cma_activate_area(struct cma =
*cma)
>> bitmap_set(cmr->bitmap, 0, bitmap_count);
>> }
>>=20
>> + 	WARN_ON_ONCE(!pfn_valid(cmr->base_pfn));
>> +
>> 	for (pfn =3D early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
>>      		pfn +=3D pageblock_nr_pages)
>> 	init_cma_reserved_pageblock(pfn_to_page(pfn));
>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>> index f83ae4998990..b068e9bf6537 100644
>> --- a/mm/hugetlb_cma.c
>> +++ b/mm/hugetlb_cma.c
>> @@ -233,9 +233,10 @@ void __init hugetlb_cma_reserve(void)
>> res =3D cma_declare_contiguous_multi(size, PAGE_SIZE << order,
>> HUGETLB_PAGE_ORDER, name,
>> &hugetlb_cma[nid], nid);
>> - 	if (res) {
>> + 	if (res || !cma_validate_zones(hugetlb_cma[nid])) {
>> 		pr_warn("hugetlb_cma: reservation failed: err %d, node =
%d",
>> 			res, nid);
>=20
> The warning here should be updated as well. Other than that

Make sense.

>=20
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks.

>=20
>> + 		hugetlb_cma[nid] =3D NULL;
>> 		continue;
>> 	}
>>=20
>> --=20
>> 2.20.1
>>=20
>=20
> --=20
> Sincerely yours,
> Mike.



