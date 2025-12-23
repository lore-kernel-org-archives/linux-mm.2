Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D52DE6B272
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 11:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8976B0005; Tue, 23 Dec 2025 06:27:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7436B0089; Tue, 23 Dec 2025 06:27:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787956B008A; Tue, 23 Dec 2025 06:27:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 679266B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:27:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 08E5212C40
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:27:05 +0000 (UTC)
X-FDA: 84250509210.20.1A6AE74
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2611120005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:27:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ruu6uNy7;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766489223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHAire6Xrax1yj32Yc8zIc5EhAa4dkXuU/POIrRR/HY=;
	b=IVETnP4Ae1kqobsM80znuqa7GcqlKsKBDXchFE03WjPuWD09mWKV6PckqOudhjHrjgAjwZ
	QlfY40F5j5y9j5Ekf6AumFq4FDRGJ8oWJ3O+yaQCQk/XDCE8jFZrFOdRy2D//D8GEQMsoY
	Ord9twFEKhIT47I8yNjBJuf+k1oSzns=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ruu6uNy7;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766489223; a=rsa-sha256;
	cv=none;
	b=mdjoqz67nIyadiPUIiPFe+gptFu/xk3pbDD9Y3f5cVj/PIMFQXwiD5KsFvv8tGyv971TiL
	j2os7kSkp/Z/qIOJyUgZVIVEEKAoTs7TK48cE/JenAfPBdNBD+y85CEiK1WbNW/v/l07pt
	lUoAa9QZobyymuj7Qi7c2RDHqZRswA0=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766489220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JHAire6Xrax1yj32Yc8zIc5EhAa4dkXuU/POIrRR/HY=;
	b=ruu6uNy7NeHLswweIWluoeREM4QDf0rh3qZ+Urjcc0ceeBOlZFf7/WqDxNPMEBqhhyk1jM
	hTgK+0ZeTXoL4L26dmCdBhLDWJbrV0IFDeIGdHGOzWv4Bgqq5nn1oEZi6d6ZPJv9nf44s0
	j1+2u8uIbHVu1avHUbvFAL+MCK2+sKs=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <4f82b8ef-77de-422b-a9a5-691c4eca24a3@kernel.org>
Date: Tue, 23 Dec 2025 19:26:07 +0800
Cc: Matthew Wilcox <willy@infradead.org>,
 Kiryl Shutsemau <kas@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AE2B4254-3EF7-4974-858E-BDC51E02C9C5@linux.dev>
References: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
 <CDAEC896-E3EB-4EAB-9F0F-70BC448B3B9A@linux.dev>
 <4f82b8ef-77de-422b-a9a5-691c4eca24a3@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2611120005
X-Stat-Signature: o9b994fucth4tyfb1f8p5s9cwp3yth15
X-HE-Tag: 1766489222-494166
X-HE-Meta: U2FsdGVkX1/K7O8CkWLZH9TzeHEw4WjjMuoc78bR2ATzjZSQ3snuTWvmo99gC77S6yoc/xH4i2fMOKzbtVH2UbPLL4IBzLQlQ/cBY1h+y+C6WFVkFD2xt0Rz+obVY2SUw9FyO94M7hu4PA+3/mfcorQAOM7olBpy/kTEAuveYbFdc9OPvXafVza0A7Y/nkE/za8uMKZFBXw9EAVDrW9ljJtKYzliyZyj0RPDc1fb4Y59lrosVoiI9NpCd70tIkeQNnGEpYisdAf0gwmNagCnsaMle7ox78g5qJQv9yMr8nIuYs/t33fmZEzs1KPSbcr5ePR8LOkrCKAw3MuhNu0SoCt/2PLV2bIcNlrO12LCyiinyt994f4b1V0Y/Zj4BCQL54NzRIvB/TT1/Mmzj1nxEYFPVHapr9nk+KB5a2RqmnkGMSFY5+ZDxIbIk5pGIr6+9NLT4fbKy2Yc78Vf23IgtsDrmz1FyBn97kPp5kDaJvn/9AhnhAxQFLmRi8jCFZL7krXbKmE4Q9YnzelijdzIV6bEDJZbMj/ACdvsk/hgsU6zGNakgj5wC5L8msmX+VIhK1xu4nKJ76skrPEKEBwiTjNNrlwwt0ivFm4J2m3eQwLPSclypY2Gx0rfBWZND34XN18VawsZAU6vWBpBZc8TK6yRfGBPXIK5T+Oiikj8WYu7WkdGlfLIVYa99TVu+rtV6wBM0M3M07mgDxj2Kl2wBQ0GdA9lelj/SQpsv00cnN0+H530Qez9hTVJh4zp/jY0ZRXPqbmaDr1JXX+oPR2JPke2DgnrIzHdTYSTrSmPuE0WGzBV1CnzHL3GeX1oONc+61qYoFGHDSo0wPtOIv85dxgoDGi3lwiciETyWN9nK6hjXYV0rNvpTY8TVmNNr6b2c2uhDpg8dPbr9re/CiXYTyqKEb972j6gj2zSvwhNyJ+nYyb7BWu6bPETCUMy4g6zZzzsS9HL/OjYRirwAje
 KKqL7CX8
 epuTTpGfGDmcxvQjniMXgrfgzBsd1I56kG1fb9/2oQQsl6CZor5O225wdyh/InmbogSat5VJj220v9AySKZ7qEh2ec1tJTnwawt0C/PMSzsKX5IlQRHvIFMlS84Tgs2eekqyP1lj0+cZfbWuIYEzJlE4RapXwuRxIj3F90ChMD7NGedqyrii0aqIapUih8A3MnNHH+x5nE7RZJzzceIxY/u65Ugbd7p9rWOFYp0JbDDoQbwheYqlOF9PUdmFDIEqkZ928aAKJsi6rGajtks2Gg/JK60Ut5l8r7u42sLmY21u21yg1HSYFtnJsDNrzGOVPRST0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 23, 2025, at 17:38, David Hildenbrand (Red Hat) =
<david@kernel.org> wrote:
>=20
> On 12/22/25 15:55, Muchun Song wrote:
>>> On Dec 22, 2025, at 22:18, David Hildenbrand (Red Hat) =
<david@kernel.org> wrote:
>>>=20
>>> =EF=BB=BFOn 12/22/25 15:02, Kiryl Shutsemau wrote:
>>>>> On Mon, Dec 22, 2025 at 04:34:40PM +0800, Muchun Song wrote:
>>>>>=20
>>>>>=20
>>>>> On 2025/12/18 23:09, Kiryl Shutsemau wrote:
>>>>>> The upcoming changes in compound_head() require memmap to be =
naturally
>>>>>> aligned to the maximum folio size.
>>>>>>=20
>>>>>> Add a warning if it is not.
>>>>>>=20
>>>>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, =
so the
>>>>>> kernel is still likely to be functional if this strict check =
fails.
>>>>>=20
>>>>> Different architectures default to 2 MB alignment (mainly to
>>>>> enable huge mappings), which only accommodates folios up to
>>>>> 128 MB. Yet 1 GB huge pages are still fairly common, so
>>>>> validating 16 GB (MAX_FOLIO_SIZE) alignment seems likely to
>>>>> miss the most frequent case.
>>>> I don't follow. 16 GB check is more strict that anything smaller.
>>>> How can it miss the most frequent case?
>>>>> I=E2=80=99m concerned that this might plant a hidden time bomb: it
>>>>> could detonate at any moment in later code, silently triggering
>>>>> memory corruption or similar failures. Therefore, I don=E2=80=99t
>>>>> think a WARNING is a good choice.
>>>> We can upgrade it BUG_ON(), but I want to understand your logic =
here
>>>> first.
>>>=20
>>> Definitely no BUG_ON(). I would assume this is something we would =
find early during testing, so even a VM_WARN_ON_ONCE() should be good =
enough?
>>>=20
>>> This smells like a possible problem, though, as soon as some =
architecture wants to increase the folio size. What would be the =
expected step to ensure the alignment is done properly?
>>>=20
>>> But OTOH, as I raised Willy's work will make all of that here =
obsolete either way, so maybe not worth worrying about that case too =
much,
>> Hi David,
>=20
> Hi! :)
>=20
>> I hope you're doing well. I must admit I have limited knowledge of =
Willy's work, and I was wondering if you might be kind enough to share =
any publicly available links where I could learn more about the future =
direction of this project. I would be truly grateful for your guidance.
>> Thank you very much in advance.
>=20
> There is some information to be had at [1], but more at [2]. Take a =
look at [2] in "After those projects are complete - Then we can shrink =
struct page to 32 bytes:"
>=20
> In essence, all pages (belonging to a memdesc) will have a "memdesc" =
pointer (that replaces the compound_head pointer).
>=20
> "Then we make page->compound_head point to the dynamically allocated =
memdesc rather than the first page. Then we can transition to the above =
layout. "
>=20
> The "memdesc" could be a pointer to a "struct folio" that is allocated =
from the slab.
>=20
> So in the new memdesc world, all pages part of a folio will point at =
the allocated "struct folio", not the head page where "struct folio" =
currently overlays "struct page".
>=20
> That would mean that the proposal in this patch set will have to be =
reverted again.
>=20
>=20
> At LPC, Willy said that he wants to have something out there in the =
first half of 2026.
>=20
> [1] https://kernelnewbies.org/MatthewWilcox/Memdescs
> [2] https://kernelnewbies.org/MatthewWilcox/Memdescs/Path

Many thanks for taking the time to explain everything in detail and for =
providing
such valuable information. I plan to invest additional time to fully =
understand
the details you=E2=80=99ve shared.

Muchun,
Thanks.

>=20
> --=20
> Cheers
>=20
> David



