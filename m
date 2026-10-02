Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB4CCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119856B00B6; Fri,  2 Oct 2026 05:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA6B6B00B8; Fri,  2 Oct 2026 05:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3FB6B00B9; Fri,  2 Oct 2026 05:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C38CA6B00B6
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 574D4A75C9
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:04 +0000 (UTC)
X-FDA: 85277232768.03.83A9BD8
Received: from mta0.migadu.com (out-129.mta0.migadu.com [91.218.175.129])
	by imf23.hostedemail.com (Postfix) with ESMTP id 51335140008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nlTAQEKg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.129 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=roAk5SWvCfO6tRD7usWMkoWmhkjxdhsqx8L4kRhcClI=;
	b=n4Ks0RBiy2/TIk7sW5fCQbAnBLxvOGBXbf5/LsOIjzeWpl48m6ieOWaTWU+2EB0yE+ZErU
	0FqpBX0PIKOutVoFR6CCbFoVtcYQ2viKw8opFQckcPWSD6uHnuvia9Z+thwq303c/jo/37
	r2uJoE9zbPaNqztxSeMh2Ha8U4AeGRU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nlTAQEKg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.129 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935022;
	b=7YtpOmHWJT0P5bUfXRJy6zBEO74ZEgvy9x1Wdmde1MhcnTyc5a0LGDZScCug41lC5yn1YB
	kuQlvS7cbwtWbctRaFrrNn4/HzNbCJRpVVsgHQdt+kUhlHXngFeoIyIhc8GYTcWV21vlTh
	qUpLgv2cjIVS71A/a3prlvoTRczfuA8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=roAk5SWvCfO6tRD7usWMkoWmhkjxdhsqx8L4kRhcClI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935021; v=1; x=1791539821;
 b=nlTAQEKgfBTJ7beIvEZL1nlOX9yQBup7rkvDhDPQDEea763f1MOHHC2Yd87TRkN9nS7D09aY
 U6E7ts/3WBktQzF1GXnyYfUF+B+t/l6cN+GnL9NiG50MyBEScAtEwxt+SYUY2yToAtyxl0ItJj+
 blBTN1dUBGX7UdkAHu9KHf28=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 12c54f5d308feb20;
	Fri, 02 Oct 2026 09:57:00 +0000
X-Mizu-Trace-ID: 12c54f5d308feb20
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v3 6/6] mm/mm_init: add zone mismatch warning during page
 init
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ar9p39Y9SmlxvbA_@kernel.org>
Date: Fri, 2 Oct 2026 17:56:40 +0800
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
Message-Id: <85941AA4-7E50-4AAE-BC05-0F443B21BE8B@linux.dev>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
 <20260929053231.66085-7-songmuchun@bytedance.com>
 <ar5xbQsUpSQZg0wO@kernel.org>
 <78D5D6AA-BE36-432C-B0F7-453F93DF18C0@linux.dev>
 <ar9p39Y9SmlxvbA_@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Stat-Signature: p3j1wr1dr9y4nt6gxaeqto75775dj9ez
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51335140008
X-HE-Tag: 1790935022-4009
X-HE-Meta: U2FsdGVkX18HNIe2CIng+id0RA+K3T1iHwqwyEvUNwhYucTbZc9dw95tdkfw1rc2ulQTqV24RCSi9peTeVL6C/7Ic0xt47bRuPTNqFJOifcMl3FPaKiJLEtUy3twzXKTPiZroWSwBUzeXDoOEwDGcy+xo4uiFIkDiBmiBTv5VXxVXoAFHR0QR46W/2YgKojwyxf42w+j1Qi9QUJhlUfl7uCoI53zf1e9bEJF+kPdGvfkIm1+VmA30DxRpThEIvniPmeLjZ3XjSbhV4NDbA4rv8K+kXNxzlAh3uZG/8R6vxceMZhYK8syVqOY8cR3dbYMwWdgmapm5J4uSiljgwflDU2vz47wWa4WnfpCBdOdz62a1sYOENkWeCs+5GL5o9qNfZolkeQrAt6s9YsxsGHzP8xZ3eHif+Yi0p0SbBYYOOE5jR9Q0/zGcqoX4kSh82ZlBoEetauAxuez3oNOKgJdbw3Pgn7AFLyg2yD+hZ0DR1nHZOvwVcs72eZJGh7hXiq+MeQ6ZEJPYgbGCOkGWgHwDxEVk1AGhH1XWo5JOBDHSJIiANuB434+AFwBsfFMek+q0MOlDsjf3FTs4tzWqtgJZRGxEGt4G/sSlNRlJMR2XTWR+8UFG9sgE64rxh4B3a4JhBrimGilOR2diy/cIuLrIl1lt/e4VejOyxXypbe9xCCJBtHOeA64uAMzjkZEc6TUpp1/mc4QNuA4hdteopQyv2dUufankMXexvs9RqRF5avetK8SKH5zeZuQ9xOOd9Hbq9wpKl1ro+xdGmkwnRqXKBp/BcJ1KQlgr5AwQxUWwQGg4wNCro1zujzWk/BVEGwgUnsCY+7KJsaoPDGzIeqnwP45jWfGrt0xsdmztsYGhOJQbor7L9OQAeFP/uoiOwAFmxTPoQHntTQXlo27yvliv6Ae+FjCjICSJot408dChsr91hXgzCoFt+X+KvmQkNlx5blf/RU/M4tulT5KqGT
 G+tat2AO
 1/Py1J51p2Mny0Y6sjWGi8qWYwck5fve+7AOG/nZkrMLrWu6Mx2qCJdAtrRIiGUFailMsloyimzJuvroop2iDuy0WHxBV5wUFvaQgeChyIho3bBzD15Vn9AS5N9pYnUBwh7FUjhlMuJ7ImPy5m2bagl3J2PDhDeVuekBlJoMNUP5WgyBu7GPxve/b0/LaaisXl3oplRPAVTsBX/mmlT7q3Z5OeMTlvi1GC3vtbjkLfIcETFBp3Ax2mUI4/Lyv/VlwSp7Kd0Lk7YqTRdInbM3taHiN9+CmsUW3HOPXfVU92A1057pZEnNjZaEBFyy3hAN1CySXCQ2gSJoz4oFLsn/xCUcZ6gJUD/UX85WmbWkBlJO0TWJXOaSjzACYvSVuDNzkw+S1jpzD7RLWurJJztlaJ/fBagcPwfGX6rOk/atG2EAk0zPSPmKdTLBOlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 2, 2026, at 16:22, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Fri, Oct 02, 2026 at 09:48:42AM +0800, Muchun Song wrote:
>>=20
>>=20
>>> On Oct 1, 2026, at 22:42, Mike Rapoport <rppt@kernel.org> wrote:
>>>=20
>>> Hi Muchun,
>>=20
>> Hi,
>>=20
>>>=20
>>> On Tue, Sep 29, 2026 at 01:32:31PM +0800, Muchun Song wrote:
>>>> For vmemmap-optimized sections, tail struct pages may be backed by
>>>> shared vmemmap pages. Those shared pages must carry the same page =
zone
>>>> ID as the struct pages initialized for the section.
>>>>=20
>>>> Warn in __init_single_page() if the shared tail page has a =
different
>>>> page_zone_id(), which would indicate inconsistent initialization.
>>>>=20
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>>>> ---
>>>> v3:
>>>> - Collect Acked-by from Qi Zheng
>>>>=20
>>>> v2:
>>>> - New patch.
>>>> ---
>>>> mm/mm_init.c | 3 +++
>>>> 1 file changed, 3 insertions(+)
>>>>=20
>>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>>> index 1650d6bc1211..bd02e8d06965 100644
>>>> --- a/mm/mm_init.c
>>>> +++ b/mm/mm_init.c
>>>> @@ -609,6 +609,9 @@ void __meminit __init_single_page(struct page =
*page, unsigned long pfn,
>>>> if (!is_highmem_idx(zone))
>>>> set_page_address(page, __va(pfn << PAGE_SHIFT));
>>>> #endif
>>>> + =
VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pf=
n)) &&
>>>> + page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=3D
>>>> + page_zone_id(page));
>>>=20
>>> Hmm, page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES is initialized a =
tad later
>>> than page so it'll have stale data in the page->flags, won't it?
>>=20
>> Lance is right. The shared tail struct pages are already initialized =
by
>> vmemmap_shared_tail_page() during vmemmap population, so they're not =
stale.
>> The head 64 struct pages are initialized later =E2=80=94 right here, =
after vmemmap
>> population.
>=20
> Still it looks out of place here, can this check be done in =
sparse-vmemmap
> somehow?

The struct page entries of a vmemmap-optimizable compound page
are currently initialized in two stages. During vmemmap
population, the shared tail entries are initialized first. The
retained head area=E2=80=94normally 64=E2=80=94is initialized later =
through
__init_single_page().

This warning connects the two stages: while initializing the
retained entries in the second stage, it verifies that their zone
information is consistent with the shared entries initialized in
the first stage. Therefore, the same check cannot be performed
during vmemmap population.

I am planning to first unify the HugeTLB and Device DAX
compound-page initialization through a common helper [1]. Once that
work is complete, maybe it will be easy to move the initialization
of the retained head area into vmemmap population. With both the
retained and shared entries initialized in the same stage, there
will be no cross-stage inconsistency to check, and this warning
can be removed.

Would keeping the check here for now and removing it as part of
that follow-up sound reasonable to you?

[1] =
https://lore.kernel.org/20260513132044.41690-18-songmuchun@bytedance.com/

Thanks,
Muchun

>=20
>> Thanks,
>> Muchun
>>=20
>>>=20
>>>> }
>>>>=20
>>>> #ifdef CONFIG_NUMA
>>>> --=20
>>>> 2.54.0
>>>>=20
>>>=20
>>> --=20
>>> Sincerely yours,
>>> Mike.
>>=20
>>=20
>=20
> --=20
> Sincerely yours,
> Mike.


