Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A11CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 13:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0755A6B008C; Tue,  6 Oct 2026 09:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025006B0092; Tue,  6 Oct 2026 09:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56266B0093; Tue,  6 Oct 2026 09:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C01956B008C
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:32:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D000401E3
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 13:32:59 +0000 (UTC)
X-FDA: 85292292078.05.94048A9
Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	by imf17.hostedemail.com (Postfix) with ESMTP id F051040014
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 13:32:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jekc39bp;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791293577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smNz1eVU0GPZ0bGB5TxQ5+zWKlDqUlqFk7rJBl1+TLI=;
	b=WI5cFw11ntMb+UxCCPfTV8HIGDO1LwEduwmUP1AjqhmrFj7ECOZzux2/PTXwzzlVELUBKQ
	//px4KHy9QCI4QLDtYLlDI/FUO28o0CcgUB9anbWH5//B1RxaVDJ31aUwMTTUHuyi2FuLB
	8HyAxOKnRMX/vO5H8Hhsq3cO3iEtkKk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791293577;
	b=iAXKStpAerGOcV1/ZkL4vd0E/n3kkzU1rPXMbazIBUAYvKDt8sMfK3N6KWwYnLG/vyv4JT
	TrQmF+JcUZT0VlGtNdOYlJUtog7RS1CLiM8LBPQZsoHUzQJrKG/FOpXt6W2cipbz6hmEHQ
	Z9DaORFMYzZgY/7p4OTkOgDAQuPSuZg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jekc39bp;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=smNz1eVU0GPZ0bGB5TxQ5+zWKlDqUlqFk7rJBl1+TLI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791293575; v=1; x=1791898375;
 b=Jekc39bpI+ioS9+/6w+urByOeYORvH5fCIWg9NHDTuHFtSIJ4zHHA8DJ8fSensly7uHX/HR/
 107fIDjvmzrDpMlAjWnOOfZClu0j0s7hC1Mj6DPm/mAmZBfuONGQURZ+fMeBqUKxRJL59z83wPU
 Jq8nzS/PSiEN8JYwtO+Vjud0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 72132319fdfc02e7;
	Tue, 06 Oct 2026 13:32:55 +0000
X-Mizu-Trace-ID: 72132319fdfc02e7
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v3 6/6] mm/mm_init: add zone mismatch warning during page
 init
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <asTS6OtxPMVshuIO@kernel.org>
Date: Tue, 6 Oct 2026 15:32:43 +0200
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
Message-Id: <CF8ED1DC-9745-42D3-92F0-424A02385EC1@linux.dev>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
 <20260929053231.66085-7-songmuchun@bytedance.com>
 <ar5xbQsUpSQZg0wO@kernel.org>
 <78D5D6AA-BE36-432C-B0F7-453F93DF18C0@linux.dev>
 <ar9p39Y9SmlxvbA_@kernel.org>
 <85941AA4-7E50-4AAE-BC05-0F443B21BE8B@linux.dev>
 <ar_0GLYM6KsIH6tQ@kernel.org>
 <D91CEA1E-6B79-434D-AF49-16C62C0FD095@linux.dev>
 <asTS6OtxPMVshuIO@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F051040014
X-Stat-Signature: 3ypurr9jm1h8rhcutneowr4hnfjzfhfi
X-HE-Tag: 1791293576-58640
X-HE-Meta: U2FsdGVkX18Fu1QaaY3YoIvpD7L4X55AX1vDHCpAGB4Q2u8AyaT/4uZTFoZK3NldLf2qRyER9ARdzIzsTE6QGWSd9HFw3Wm8pqbizb7IKQL0lfPpI1kxKbqDzOy6RyxrmEBem4zz63qrANn1tV296RF+IJvM+q0un6I4IzDCAj+pYrIK27sSoWSSDs3S/rQ0kvgXAGNIdD1ljMZ1LObHwk0FsLoy5yaKB9aAGVfHsOgOEbLeblyucRks90GyIQN1kKz2H+Zdqu6/499MqDO+4IpjMF3jZ3CcjBiRReVbgwN2Pac/qRcGlFvdQcbUxgsbWWKdlGVAFkY540reH/F57eWwxa72TcVznv3G2sx+DA/HOfBAPw0ObdOdotZKXqIvUDfJf9pu51bcxd4XdED9qgiGWozJJHPwjBCMqqYkXxJwQbEYxJZaR943MDPMopt6dSbT0jLaEWpF9sPaL/kpC6YG7E21FXUxN2WoHP0WEBWwP0rgHvhDV6KRMzayKCD9Aozq8nUla06w3VHZtAecuTopqDDYrucntlof9/iBT84FMFeG8/rIGWklXQS6crGqx8WwOGK4xbHFntBSATRAGFhtsRVwpIq0aQbZqWvY/So8AY3KLge+C1n1KZZ7a66YmZBP3tCD9qbuV0PIicxXKVXhZiz5gLzZGKIymWOEpN2ChfpzJk7bwE0IiXMxi+92/ygcYfX3lwuYYy9AZ3K8QGYTVyqmWEInslf7eL+KxzKBgu1XHcVR16FyulhJIF1t+jcx+AuJxgW1At8X8KDmo5hmNlzBHWmv4W2xXpERqmhCkjcuNajItcOJJ0DOEsG2/0VGqM9EadM0EYN1L7cc6NJc2hkVNsNScSbGLZTwVf7KWm+7VF83lq71agGrNDWsqaxbrjOMqYB4eQWI+ZXbaVeuhb/N7XJ+81k/5QCPIedEpSrzdJxh0aW+f/g/3z0GnCWy09LgiP7E9dWn1rN
 xQgmReZC
 ORJkMe24HQUYJW0wbfuR2CLh4JbSFYP83nyOOXCJDLTf4+xPVJ07Gmqz+DZfYNIfoEYXEYQdPw+wEUZBH2RN1+IT5x8N7U49cVDOczrT/Wqq32brydPvxlYj5AcjnLcbELJlYONPsXDv+0IbVJ/KHSkDgsu3JvqlBZOd/6Ufc9tSjUw2cb4GXSMl6GbIvn8rAjJ4eL9O6eLwg01r7Z0eVpB807xi1DzGMbEcj4KUVfkSF6KTZooCzKRfVl3wsqqYg2S0nQa7ZUUEFQavla7hE2gkh0iEEYUjcyhPpK0APeIwJrHwRqwklDV2moC9r7AMFWQCZZPBrG7ij/7lA3JJYs5czPryG//uque42WqcKcTXeeOJvIY0Q0PG3O/dvpbgi6nA9+D/ndVASsSoYEROYB8W66qh2KztpKgEIs7xFoJmFfAfw3OSL5QqPtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 6, 2026, at 12:52, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Mon, Oct 05, 2026 at 06:27:52PM +0200, Muchun Song wrote:
>>> On Oct 2, 2026, at 20:12, Mike Rapoport <rppt@kernel.org> wrote:
>>>=20
>>> On Fri, Oct 02, 2026 at 05:56:40PM +0800, Muchun Song wrote:
>>>>> On Oct 2, 2026, at 16:22, Mike Rapoport <rppt@kernel.org> wrote:
>>>>=20
>>>>>>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>>>>>>> index 1650d6bc1211..bd02e8d06965 100644
>>>>>>>> --- a/mm/mm_init.c
>>>>>>>> +++ b/mm/mm_init.c
>>>>>>>> @@ -609,6 +609,9 @@ void __meminit __init_single_page(struct =
page *page, unsigned long pfn,
>>>>>>>> if (!is_highmem_idx(zone))
>>>>>>>> set_page_address(page, __va(pfn << PAGE_SHIFT));
>>>>>>>> #endif
>>>>>>>> + =
VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pf=
n)) &&
>>>>>>>> + page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=3D
>>>>>>>> + page_zone_id(page));
>>>>>>>=20
>>>>>>> Hmm, page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES is initialized =
a tad later
>>>>>>> than page so it'll have stale data in the page->flags, won't it?
>>>>>>=20
>>>>>> Lance is right. The shared tail struct pages are already =
initialized by
>>>>>> vmemmap_shared_tail_page() during vmemmap population, so they're =
not stale.
>>>>>> The head 64 struct pages are initialized later =E2=80=94 right =
here, after vmemmap
>>>>>> population.
>>>>>=20
>>>>> Still it looks out of place here, can this check be done in =
sparse-vmemmap
>>>>> somehow?
>>>>=20
>>>> The struct page entries of a vmemmap-optimizable compound page
>>>> are currently initialized in two stages. During vmemmap
>>>> population, the shared tail entries are initialized first. The
>>>> retained head area=E2=80=94normally 64=E2=80=94is initialized later =
through
>>>> __init_single_page().
>>>>=20
>>>> This warning connects the two stages: while initializing the
>>>> retained entries in the second stage, it verifies that their zone
>>>> information is consistent with the shared entries initialized in
>>>> the first stage. Therefore, the same check cannot be performed
>>>> during vmemmap population.
>>>>=20
>>>> I am planning to first unify the HugeTLB and Device DAX
>>>> compound-page initialization through a common helper [1]. Once that
>>>> work is complete, maybe it will be easy to move the initialization
>>>> of the retained head area into vmemmap population. With both the
>>>> retained and shared entries initialized in the same stage, there
>>>> will be no cross-stage inconsistency to check, and this warning
>>>> can be removed.
>>>>=20
>>>> Would keeping the check here for now and removing it as part of
>>>> that follow-up sound reasonable to you?
>>>=20
>>> While it feels really out of place in __init_single_page(), but =
having it
>>> memmap_init_range() close to the if that skips shared tail pages =
makes
>>> sense.
>>>=20
>>> What do you say?
>>=20
>> Sorry for the late reply because of traveling to LPC.
>>=20
>> Putting the check in memmap_init_range() would validate the
>> invariant for the shared-tail range skipped there. It would
>> not, however, cover all vmemmap-optimized initialization
>> paths: optimized Device DAX bypasses memmap_init_range()
>> when there is no altmap, and deferred boot-time HugeTLB
>> initialization may also initialize retained entries
>> elsewhere.
>>=20
>> If the intention is to validate only the skip in
>> memmap_init_range(), moving it there makes sense. If we want
>> the warning to cover both HugeTLB and Device DAX generally,
>> it still needs to remain in __init_single_page() or be
>> called from the individual initialization paths.
>=20
> Yeah, putting this into all the callers sucks too :(
>=20
> With all the callers,__init_single_page() is the right place for this
> check, but I think we can add a static inline in sparse.h, like e.g.
>=20
> vmemmap_optimization_verify_zone(page, pfn)
>=20
> to make it a bit nicer.

Yeah, factoring this into a helper makes sense.

Since it currently has only one caller, how about keeping it as a local
static inline in mm_init.c instead of putting it in sparse.h?

Thanks,
Muchun

>=20
>> Thanks,
>> Muchun
>>=20
>>>=20
>>>> [1] =
https://lore.kernel.org/20260513132044.41690-18-songmuchun@bytedance.com/
>>>>=20
>>>> Thanks,
>>>> Muchun
>>>=20
>>> --=20
>>> Sincerely yours,
>>> Mike.
>>=20
>=20
> --=20
> Sincerely yours,
> Mike.



