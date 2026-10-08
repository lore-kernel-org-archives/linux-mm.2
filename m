Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E51A8CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 08:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9076B0092; Thu,  8 Oct 2026 04:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3BCA6B0093; Thu,  8 Oct 2026 04:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903216B0095; Thu,  8 Oct 2026 04:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59C8C6B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 04:16:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8BF8A0506
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:16:54 +0000 (UTC)
X-FDA: 85298753148.20.2C2EEF7
Received: from mta1.migadu.com (out-101.mta1.migadu.com [95.215.58.101])
	by imf12.hostedemail.com (Postfix) with ESMTP id 967CD40006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:16:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BkJY+0QS;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.101 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791447413;
	b=vAsNAB4UZ6K+Fpye2S0dhSSQAzhamQbVgVBov/7WrClCIst6Z+et/x3Bx8/iHVI6+OlsKQ
	sZHEgL6hM5wd0NN2L0S6Ga4Zn8Df0NazCxJReb9DZ8d4765oSV+T7xXtll/lhzu33gPcbZ
	FLl97LZlvWXwcfHoBLztPvaZ72UkbEs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BkJY+0QS;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.101 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791447413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHAPwba2bGTS8af5kSWYut1fycRyI5aoznVbcbDNoEY=;
	b=wmezpQkuNtT9jWnnJwqyKIasUl+62Ea/Of9gVR3/AUdhSXmGn6jZrq8XurP4oqBd9EAkmq
	Mvp0DSyFB9LBAaIHJju/GH5Ewu3hYqZf2sxmUpDUtzgS0WenoiYJguvZvYYYb2Omc8pzQC
	oO/g+0N34WVvGaT48b2loFfSCi71i+s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MHAPwba2bGTS8af5kSWYut1fycRyI5aoznVbcbDNoEY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791447411; v=1; x=1792052211;
 b=BkJY+0QSb2PH8p++GP4mjbq/HTFXm3+f5i36xosvBRk3rKj/t6A+Zf9vTPO0ab3uN82FxXOs
 4FLjSIpaL/NTT7gDSHZCCHiXwebn3WT+VNicvpy/TSH/XW+Ggg3P7v01nSZjBj+rcvWnub7bOId
 bpVdqVmv+ZmiprT5PjTWaEaQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5d61374c685aff04;
	Thu, 08 Oct 2026 08:16:50 +0000
X-Mizu-Trace-ID: 5d61374c685aff04
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v3 6/6] mm/mm_init: add zone mismatch warning during page
 init
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <asdKHy_xHHa0wJ65@kernel.org>
Date: Thu, 8 Oct 2026 10:16:36 +0200
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
Message-Id: <3466BD00-1B0E-4F15-B104-88A22807ECD2@linux.dev>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
 <20260929053231.66085-7-songmuchun@bytedance.com>
 <ar5xbQsUpSQZg0wO@kernel.org>
 <78D5D6AA-BE36-432C-B0F7-453F93DF18C0@linux.dev>
 <ar9p39Y9SmlxvbA_@kernel.org>
 <85941AA4-7E50-4AAE-BC05-0F443B21BE8B@linux.dev>
 <ar_0GLYM6KsIH6tQ@kernel.org>
 <D91CEA1E-6B79-434D-AF49-16C62C0FD095@linux.dev>
 <asTS6OtxPMVshuIO@kernel.org>
 <CF8ED1DC-9745-42D3-92F0-424A02385EC1@linux.dev>
 <asdKHy_xHHa0wJ65@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 967CD40006
X-Stat-Signature: z6pz63ig6sp5bw159ir71cejirpojiap
X-HE-Tag: 1791447412-882828
X-HE-Meta: U2FsdGVkX18ihoVIRUtp2isEHpfDnGhfDQq/37F75oEfHcPetvPtZ3ls5+ZT9Yztp2gAn9Zk7bqCY21ZOHbyRy92Rpq4BNGUuPavNL0dOVoSTrxkkjVb17lAxnpsZGB9UHqFIXYJhRF9yvfpLRBD3ooK1sxigCxtQzhujkopYyG2IPfbpbzCpbevcyN6ykyj6+uR2hDWAJUqTOa6Sq8PoBBx0DM0zpVWbPJNRH7r+7VnN7OfIMfWNT3gQWtPY4Pz/qw2IT0Z16O5mvDP/mX1P6vwaZocq/D1T8KgS9ITrCMyuVCuEhjk952VIPv4sAGSo1XdPCrOg8yfwpwNaI/DlnR6DmKW4oDYnStxwE0WuvTz/YcZjg8BIpNB+I0RVw+hsGy1BiI1KQCzW1Ok5sE4/cvGdyFtm0cT2iYdIv5jGGLhN+YHsbKZXaauMbdTO5/sAf1/H1rCbP34Ta04/pzMB2hfgbKJEj4qD5++AUts69IEoFfcAAzZ+RFESAptsB5kyIAti3Z+bX9u7LH/T5SIS4/infFzvc2VXZe+TnZ41I3lrMHewmzqhGc0ThbNPPUz2L/24nTqcaNxfNLhu18R6fzZDCYYrGCwxygz9iO3zY9UDk05FgrgMR4HIwjWcweOVaZ5Pu5NFcWoqi8Mjpu3ny/F56j3JN9BHoVO/3UfczE+U6MoQKH1ISyGUdnv9fFUA1Wem/kFxMnETXBTlqGiRXsQrXyGJAVcBXZf/QO4wCDfyCon1Q4bTdnkl6Jf5u7V1BK4M5ezvdZovFxDweFN4VF7JM6xP1k1aOqmvb8FMEeBnULG1FkAU6YKYCIM9nGnskg/lphbddRkd6baJSWYyZ3H1cyn+/ISvci9IWeZ+GfUSwR5hNXCcXPYSEbOt0YaQgAmzJcxI1BRA9WzgzRzL3Hj14dvHF0BNW8nx4xQV/DCbS33+h2zm4Wp3XRTLsLp6w350oVaofMnoj7Y+ah
 XRcXecI9
 Iq6jbVQPJvmgo73QRWzQiorrDfF5FeLZ4czxf0aNVJkpNhYikh9xIzIZzkqWLnHCZUZwTRGbALtIZ4OcpwMBU987Qu7QHZJqwfLe85SOqlpl2b+4BY/kbiE5wCa1odGQAfCcififfWXEHEVWUbrQjDjN0n4G5MTV7Brwgb4xeHQnltHWK07crn6Z/Qfu7ZaB1mSMNea7aG/7BcLBnvHNEHRfC52jjLOIZ+WfRlxu1sRwnWTMNO0Q+TR7TBOHQGtvEZReZr3AeJAL4C9MMluNtjsq1L9yb57pOGXcPishOOF/1OMvuqmNC5bv8hWZWRg5awBH7BbMAEtbmgkpuSggSuKyzhvnHtxkqKaSi5C+oef9fdY0Uqj9BYoeiv5WmoCWxQhushE70OrGXsP8barp/joBpzZBHk9WQwWKj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 8, 2026, at 09:45, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Tue, Oct 06, 2026 at 03:32:43PM +0200, Muchun Song wrote:
>>> On Oct 6, 2026, at 12:52, Mike Rapoport <rppt@kernel.org> wrote:
>>>=20
>>> On Mon, Oct 05, 2026 at 06:27:52PM +0200, Muchun Song wrote:
>>>>> On Oct 2, 2026, at 20:12, Mike Rapoport <rppt@kernel.org> wrote:
>>>>>=20
>>>>> On Fri, Oct 02, 2026 at 05:56:40PM +0800, Muchun Song wrote:
>>>>>>> On Oct 2, 2026, at 16:22, Mike Rapoport <rppt@kernel.org> wrote:
>>>>>>=20
>>>>>>>>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>>>>>>>>> index 1650d6bc1211..bd02e8d06965 100644
>>>>>>>>>> --- a/mm/mm_init.c
>>>>>>>>>> +++ b/mm/mm_init.c
>>>>>>>>>> @@ -609,6 +609,9 @@ void __meminit __init_single_page(struct =
page *page, unsigned long pfn,
>>>>>>>>>> if (!is_highmem_idx(zone))
>>>>>>>>>> set_page_address(page, __va(pfn << PAGE_SHIFT));
>>>>>>>>>> #endif
>>>>>>>>>> + =
VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pf=
n)) &&
>>>>>>>>>> + page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) =
!=3D
>>>>>>>>>> + page_zone_id(page));
>>>>>>>>>=20
>>>>>>>>> Hmm, page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES is =
initialized a tad later
>>>>>>>>> than page so it'll have stale data in the page->flags, won't =
it?
>>>>>>>>=20
>>>>>>>> Lance is right. The shared tail struct pages are already =
initialized by
>>>>>>>> vmemmap_shared_tail_page() during vmemmap population, so =
they're not stale.
>>>>>>>> The head 64 struct pages are initialized later =E2=80=94 right =
here, after vmemmap
>>>>>>>> population.
>>>>>>>=20
>>>>>>> Still it looks out of place here, can this check be done in =
sparse-vmemmap
>>>>>>> somehow?
>>>>>>=20
>>>>>> The struct page entries of a vmemmap-optimizable compound page
>>>>>> are currently initialized in two stages. During vmemmap
>>>>>> population, the shared tail entries are initialized first. The
>>>>>> retained head area=E2=80=94normally 64=E2=80=94is initialized =
later through
>>>>>> __init_single_page().
>>>>>>=20
>>>>>> This warning connects the two stages: while initializing the
>>>>>> retained entries in the second stage, it verifies that their zone
>>>>>> information is consistent with the shared entries initialized in
>>>>>> the first stage. Therefore, the same check cannot be performed
>>>>>> during vmemmap population.
>>>>>>=20
>>>>>> I am planning to first unify the HugeTLB and Device DAX
>>>>>> compound-page initialization through a common helper [1]. Once =
that
>>>>>> work is complete, maybe it will be easy to move the =
initialization
>>>>>> of the retained head area into vmemmap population. With both the
>>>>>> retained and shared entries initialized in the same stage, there
>>>>>> will be no cross-stage inconsistency to check, and this warning
>>>>>> can be removed.
>>>>>>=20
>>>>>> Would keeping the check here for now and removing it as part of
>>>>>> that follow-up sound reasonable to you?
>>>>>=20
>>>>> While it feels really out of place in __init_single_page(), but =
having it
>>>>> memmap_init_range() close to the if that skips shared tail pages =
makes
>>>>> sense.
>>>>>=20
>>>>> What do you say?
>>>>=20
>>>> Sorry for the late reply because of traveling to LPC.
>>>>=20
>>>> Putting the check in memmap_init_range() would validate the
>>>> invariant for the shared-tail range skipped there. It would
>>>> not, however, cover all vmemmap-optimized initialization
>>>> paths: optimized Device DAX bypasses memmap_init_range()
>>>> when there is no altmap, and deferred boot-time HugeTLB
>>>> initialization may also initialize retained entries
>>>> elsewhere.
>>>>=20
>>>> If the intention is to validate only the skip in
>>>> memmap_init_range(), moving it there makes sense. If we want
>>>> the warning to cover both HugeTLB and Device DAX generally,
>>>> it still needs to remain in __init_single_page() or be
>>>> called from the individual initialization paths.
>>>=20
>>> Yeah, putting this into all the callers sucks too :(
>>>=20
>>> With all the callers,__init_single_page() is the right place for =
this
>>> check, but I think we can add a static inline in sparse.h, like e.g.
>>>=20
>>> vmemmap_optimization_verify_zone(page, pfn)
>>>=20
>>> to make it a bit nicer.
>>=20
>> Yeah, factoring this into a helper makes sense.
>>=20
>> Since it currently has only one caller, how about keeping it as a =
local
>> static inline in mm_init.c instead of putting it in sparse.h?
>=20
> Presuming we don't expect new callers any time soon let's put it just =
above
> __init_single_page().

Make sense.

Thanks,
Muchun

>=20
> --=20
> Sincerely yours,
> Mike.



