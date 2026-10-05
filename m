Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC3FCA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 16:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426866B0092; Mon,  5 Oct 2026 12:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7306B0093; Mon,  5 Oct 2026 12:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ECC56B0095; Mon,  5 Oct 2026 12:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03D956B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:28:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0225B802FC
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 16:28:11 +0000 (UTC)
X-FDA: 85289104824.08.F15CD9B
Received: from mta0.migadu.com (out-66.mta0.migadu.com [91.218.175.66])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6BA508000E
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 16:28:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kl5Mb8yq;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.66 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791217688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+Tmnole7q0+tJ56UU4LkJKNC6EUiAUTbjpFGb9K7q4=;
	b=l0qSGX3C28zZQcu16rASN2Ku7aVWLFHtGM8NlrP+wNoPYQENkJwErxUCuNGeukFWz8GjHg
	rbbFG78c5xyHGeLYiB2Ed/wFMdqY9K4JkaS4o/Y0lJo9ZnnFJ7jImCAK7x2PXZ2kj9R2Rj
	QxO0riAnUpnuJY8qEPyAzqjD+tEa7L8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kl5Mb8yq;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.66 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791217688;
	b=caQ2C2jRsLwOWjvvisHWpu3RM6cz4aPbvvgorI9um8jvm1n1qbK6PsGW/ZeM9kD3whU4Q6
	BicHjPUI0vmIPpkqXosjNE9ruz2FxmxSUsrn/yhQGkIiwmKgaX1I/izMBlazzyiuGLaR3q
	h0EMr1/H7Ovldkapkjadb+IxBclCqYk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9+Tmnole7q0+tJ56UU4LkJKNC6EUiAUTbjpFGb9K7q4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791217685; v=1; x=1791822485;
 b=kl5Mb8yqAuBa1ysN4KRQ/JRXmdxeVWgpzqucHYaDFiWSuE1w7xoNqVIahcjpYYtcpmdvXvuQ
 z35vK9O03ciH2ppTch+uh8c6aUlBdcdWtI4eKsFBFDBA+lwCvzrfVvnJLg7jd5IIVVxrDw0T4hs
 FHVSGsQ3NMaX0drJVlCzGlfQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fa22e0d45fa7ff67;
	Mon, 05 Oct 2026 16:28:04 +0000
X-Mizu-Trace-ID: fa22e0d45fa7ff67
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v3 6/6] mm/mm_init: add zone mismatch warning during page
 init
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ar_0GLYM6KsIH6tQ@kernel.org>
Date: Mon, 5 Oct 2026 18:27:52 +0200
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D91CEA1E-6B79-434D-AF49-16C62C0FD095@linux.dev>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
 <20260929053231.66085-7-songmuchun@bytedance.com>
 <ar5xbQsUpSQZg0wO@kernel.org>
 <78D5D6AA-BE36-432C-B0F7-453F93DF18C0@linux.dev>
 <ar9p39Y9SmlxvbA_@kernel.org>
 <85941AA4-7E50-4AAE-BC05-0F443B21BE8B@linux.dev>
 <ar_0GLYM6KsIH6tQ@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6BA508000E
X-Rspam-User: 
X-Stat-Signature: 1g4z9mi6tqmsie6zjsa4tir75xmtrk5s
X-HE-Tag: 1791217688-588232
X-HE-Meta: U2FsdGVkX1+0cXv2XpvN1ifSjPFOhoo0pv+HZoh63k37sJWwZsnhtGnaqCMZIR7HWgthQEaq217OFq10DDah4q7LfzD+sEROCgasQU0phdZRcktIz84ikHmGkN3l1liJJZaodXulYAVdlabydF+dn/IkLOiUKiRQkPzAqxT15DJbL+KeHJwgeCHwrEuF/v47qIPtLted8AXZ8OHcscOLMiGAtJpL52ed+uf23xAgePNq4PBY1j8IcmSwhq1DsX7ZASRqM1sGgsjgsisI0fKMM+Xfnf/6CrlQ68wTdPP28/1p5ws+7qFNt0782m6WZw1xeR7o5BRpItfWFbuXxUZ7J8rKNLlS4u8jR7hp5VwuFXxhdPnmD6wcz9JYXs0e+RCSaWQP7yvXgL9K0lGthQFhIYgAFDjVl4aJIubVMcKx9GJN9uDSrMKuYVwCSC3BmeFW6l8/DD1CQgzHam9Vbgt/JAgO0vpoaTZCujgp1YZg7P1qPrbTRZhrwh2iEZaOmt3Zw573DtNudSP2nVUhQ5y0x1azrMIuqxvYplYRAHFP7gzYYCUUAd86CmsgVFWiUoYZIp/TNCwaNuHQQUVKRKwC3MqbalbrQXLijmsPCj4jUYf83i5jFqPhawxJrdnsNUMbjA5TXpDI3ZEXO6IgmfGCl+lrcUHAEJm5xPEi9O3ADdVLdy0oAJbKYXmEWFTWWquyLljRznJBZ7fIYoH12769HUHYHk2/bbYSzaNwGAPw8yuP+cv8eZrvLkWxmx8fZJqfd5fMwhXFMwoBDrSRjBt+nevYbje+iqYewWEuFtjCyn5dEHWOzL+p8Xyp/y80BH6qSuYTF6kdGwhC3MveZMt27rcUZis3UV1qb/XPACGnSm5kWXmYwGm8Qb+X61Vws+uCijx/TcrsefRekywk5iudDV2GiUCRnG3mmMO4yNO+yPxhnel+YLaUVj8ga9GUyfkcFuiZHQK3jHfUaidXscB
 g6FJobTa
 WmD1PBrBhtkuu1+W0RJVArTkfkAWAR+3tOIEGx6lPz1Bi2owc3VVqydOUNdRwjEj35SDVMuKMFyg103ET/S/OfnlP/rZ282FDI3SJr1aKdkfOS44lS7znxA5dEmW1Z20dQd0fA31AkiK3zH0bxz5ttZ+n2p3JDccLvUB1rEIJResGLO0fkZ/G3bHmyJuhQqgSxA6EptEw9eBI7+HseESMZzcaGq4Zjbmaz8oWprUQtDSHNrIkbuL3/AtK0himrOn3RSSMZXaOGG1VFWu0hWan2RJTh/xCRQF2uQEhScLpnHJbUGI0HwJu1oLNZfGU1xoqCOFpAItvcJTyvp/vsKFvfTbXhsFJZfHmCGTgq6IqVJcha3Y4RNz6z02jCCmJy33oGq7GNDhvwZcGad8dQQXXJkBQKkIuEIALZ2HKAldiamFL9XlphxqYmdhp9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 2, 2026, at 20:12, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Fri, Oct 02, 2026 at 05:56:40PM +0800, Muchun Song wrote:
>>> On Oct 2, 2026, at 16:22, Mike Rapoport <rppt@kernel.org> wrote:
>>=20
>>>>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>>>>> index 1650d6bc1211..bd02e8d06965 100644
>>>>>> --- a/mm/mm_init.c
>>>>>> +++ b/mm/mm_init.c
>>>>>> @@ -609,6 +609,9 @@ void __meminit __init_single_page(struct page =
*page, unsigned long pfn,
>>>>>> if (!is_highmem_idx(zone))
>>>>>> set_page_address(page, __va(pfn << PAGE_SHIFT));
>>>>>> #endif
>>>>>> + =
VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pf=
n)) &&
>>>>>> + page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=3D
>>>>>> + page_zone_id(page));
>>>>>=20
>>>>> Hmm, page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES is initialized a =
tad later
>>>>> than page so it'll have stale data in the page->flags, won't it?
>>>>=20
>>>> Lance is right. The shared tail struct pages are already =
initialized by
>>>> vmemmap_shared_tail_page() during vmemmap population, so they're =
not stale.
>>>> The head 64 struct pages are initialized later =E2=80=94 right =
here, after vmemmap
>>>> population.
>>>=20
>>> Still it looks out of place here, can this check be done in =
sparse-vmemmap
>>> somehow?
>>=20
>> The struct page entries of a vmemmap-optimizable compound page
>> are currently initialized in two stages. During vmemmap
>> population, the shared tail entries are initialized first. The
>> retained head area=E2=80=94normally 64=E2=80=94is initialized later =
through
>> __init_single_page().
>>=20
>> This warning connects the two stages: while initializing the
>> retained entries in the second stage, it verifies that their zone
>> information is consistent with the shared entries initialized in
>> the first stage. Therefore, the same check cannot be performed
>> during vmemmap population.
>>=20
>> I am planning to first unify the HugeTLB and Device DAX
>> compound-page initialization through a common helper [1]. Once that
>> work is complete, maybe it will be easy to move the initialization
>> of the retained head area into vmemmap population. With both the
>> retained and shared entries initialized in the same stage, there
>> will be no cross-stage inconsistency to check, and this warning
>> can be removed.
>>=20
>> Would keeping the check here for now and removing it as part of
>> that follow-up sound reasonable to you?
>=20
> While it feels really out of place in __init_single_page(), but having =
it
> memmap_init_range() close to the if that skips shared tail pages makes
> sense.
>=20
> What do you say?

Sorry for the late reply because of traveling to LPC.

Putting the check in memmap_init_range() would validate the
invariant for the shared-tail range skipped there. It would
not, however, cover all vmemmap-optimized initialization
paths: optimized Device DAX bypasses memmap_init_range()
when there is no altmap, and deferred boot-time HugeTLB
initialization may also initialize retained entries
elsewhere.

If the intention is to validate only the skip in
memmap_init_range(), moving it there makes sense. If we want
the warning to cover both HugeTLB and Device DAX generally,
it still needs to remain in __init_single_page() or be
called from the individual initialization paths.

Thanks,
Muchun

>=20
>> [1] =
https://lore.kernel.org/20260513132044.41690-18-songmuchun@bytedance.com/
>>=20
>> Thanks,
>> Muchun
>=20
> --=20
> Sincerely yours,
> Mike.


