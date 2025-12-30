Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 519DFEE57C2
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 22:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1C56B0088; Tue, 30 Dec 2025 17:30:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17F056B0089; Tue, 30 Dec 2025 17:30:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053B06B008A; Tue, 30 Dec 2025 17:30:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E85CD6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 17:30:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97C8513A0C8
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:30:43 +0000 (UTC)
X-FDA: 84277583166.20.04C834B
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id AC27B1C0010
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:30:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u53kzRxz;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767133842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bY17wBiFSkgBJbhAhSInhnW3orH6SWgJQD/F8ICSjk=;
	b=4341ZlzlsO/CLjdlSnfuJeGt6ZtIC4VFA+9GgG56IIniHIWhExS9E/crWYUdJdGoVusOE4
	Qczsj4tavr79vQ2YrWq48G56IxCVXVahIkU8uUbXs28xAHKw/p/F5DnNstEpi1SqdqZTDz
	wSFchFHQlQcy0/XOcNwFB2yVvp9u/AE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u53kzRxz;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767133842; a=rsa-sha256;
	cv=none;
	b=1h9w2jqIcUEqF0gZ0Nyp/qa3cOB2CSQ7Gbd1cWWt0aiy8g+Z00bj/5csGXOe/ok041ka7p
	WCueBCUAmqnJWHW7uDoLJlUEauwIqz+xkKL+JiABKqK16+kQUqm4Yhherw9t9oW8WtRD0B
	lGZMm0IVALl6eOce3kbpsRGc8OE+5o8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767133839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/bY17wBiFSkgBJbhAhSInhnW3orH6SWgJQD/F8ICSjk=;
	b=u53kzRxzwu9NoSTC0mFD9Ebdgrvut4P9MdbEPxunLt/VgniBsgOSvitVkV30Nro4rM6Ay9
	ZUII/cYP0v8FhpmdtJV2bgq3HI2snfKiWLv8NOawCUecdBNtebqOgmsogy1DFFkJHuU5GJ
	7KlVZgc7yYkou0Yjw4Vig4AakvYKQxo=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Chris Mason <clm@meta.com>
Cc: Matthew Wilcox <willy@infradead.org>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Zi Yan <ziy@nvidia.com>,  Qi Zheng
 <qi.zheng@linux.dev>,  hannes@cmpxchg.org,  hughd@google.com,
  mhocko@suse.com,  muchun.song@linux.dev,  david@kernel.org,
  lorenzo.stoakes@oracle.com,  harry.yoo@oracle.com,
  imran.f.khan@oracle.com,  kamalesh.babulal@oracle.com,
  axelrasmussen@google.com,  yuanchu@google.com,  weixugc@google.com,
  chenridong@huaweicloud.com,  mkoutny@suse.com,
  akpm@linux-foundation.org,  hamzamahfooz@linux.microsoft.com,
  apais@linux.microsoft.com,  lance.yang@linux.dev,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  cgroups@vger.kernel.org,  Qi Zheng
 <zhengqi.arch@bytedance.com>,  Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
In-Reply-To: <04505386-e4e9-4026-8d68-58e85f2879ed@meta.com> (Chris Mason's
	message of "Tue, 30 Dec 2025 16:10:58 -0500")
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
	<7ia4ldikrbsj.fsf@castle.c.googlers.com>
	<1fe35038-abe1-4103-b5de-81e2b422bd21@linux.dev>
	<87tsx861o5.fsf@linux.dev>
	<c3ee4091-b50c-449e-bc93-9b7893094082@linux.dev>
	<krpcb6uc5yu75eje7ypq46oamkobmd5maqfbn266vbroyltika@td6kecoz4lzu>
	<03C3C4D4-DC37-4A2F-AFFA-AACC32BAEBEF@nvidia.com>
	<slvvzxjhawqb5kkgfe2tll3owxjwtq2qkwd7m3lmpdslss73lo@hkewnkbik3qr>
	<59098b4f-c3bf-4b6c-80fb-604e6e1c755e@meta.com>
	<aVQ7RwxRaXC5kAG2@casper.infradead.org>
	<04505386-e4e9-4026-8d68-58e85f2879ed@meta.com>
Date: Tue, 30 Dec 2025 22:30:25 +0000
Message-ID: <7ia41pkbob5q.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: hzwfzwwgmm35r68zmsrkopn6y47f6m1x
X-Rspam-User: 
X-Rspamd-Queue-Id: AC27B1C0010
X-HE-Tag: 1767133841-894933
X-HE-Meta: U2FsdGVkX18XZGtgF4OEZrzCfVjrvYw+lVzSC2MPRZS9RqNGNGXAVHuOVKEYlSs5rxjJQ1pE/60Pv/1UKtGDcQnpWPZCal1OQLMWYv8BCuMrw1PZ4b+V54rMYoCVrw6VeSTtdu3ctcynJdTsCyv4V7jt75lY6e+GDbAy74kG3ou4xJXkLQbjBPdKD9iClEJtOwIzc1Et3GhIvvO2iNkxbOMQuzhgt0zDzzzecnYrNcxhAyJAJS6ncJWVbe47oV8OG66ZIg9qtfIKwm5S67c3oxwzGSxtFeOS/WURuWQR8TxInipLkCeS1arw+iVZaGWlN41xY1cvyRX4c+WnKs/txWnD5bo2EWzOH/u8RuWL3AJS+QjICUCci5VlIGAyJTGRx7ZF6L3qiU3kMwVbCocxNCrpgjGsnKCxLR1g93O8HpjaNnMP1CUnqKi+Hi0xEDkQFgCkKQoXrZVJwfy6JsibRZzc2vW49yXpPfpYbdPo6f0mMK4dR8XumToUp//NFmiwm8Jkk6OxkBalwKCbPlR8N+dD+TlDwk2bHXsP2Ks9rkt1faFUZbsahsUaak6rHj96JXNWyaYzzh4WzxHEL0bqaoYb2ILBQW4dfJyDAW/Kj6ZZ4S1g2+Ika8Mfc+3Gmg1mQKJQOfI/AlKIBNu8kpdKek/wpBVuCfO5jkR7qWXXXYbUIIT22yqwseDL445SAGBj/Q51nnDaBhF7c7Yd1cNR8oJoBJ8UaYKJ+0iKlycYAw9d4DzChZtEYIR5Zy1lx/PjVleO/9Jpzz56GP6DtVJNnR85X0BeD3+om9DgpWpwM6sBKcKUNw1iKazvFxHaHf3ewlkVyNtJcqUAptBi5H2oELDj7L7drdqFHRwE9Hu4qS63EJoSRUlZCN0+2d8IA/Ibn2uoY98K6a3eT0rRUEwyAeay4Q+AUS0Sv8rI0xTfPrrotoLsbarVmvnxUBRm3US796Fie107sH/kY1qbkP3
 w5ImXV0e
 9FyjWzq38OMJFbMYSI8vjz0YpdL80CE8kPfaPeD4/OL1qLyoMzRV7g267dK3KAL1kBUTgy59eAA28DsYqagktTmrIZF0rVAAaEEpRWCOPhmFSNgsE7NG6i5Ml6ROfHceuypVU4AV2mJTkqotW0ygpoYaH3mc0xQ9UY2RJvPOYpCAtd6vnWbjrMNI38USAeaf+k4Kt1PQSwIa9AIMFhzeJStGyQejSdOttxvDNy3CDGtrOTiH25Gkhcet1rA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chris Mason <clm@meta.com> writes:

> On 12/30/25 3:51 PM, Matthew Wilcox wrote:
>> On Tue, Dec 30, 2025 at 02:18:51PM -0500, Chris Mason wrote:
>>>>>>> I just think you should do a preliminary review of the AI =E2=80=8B=
=E2=80=8Breview results
>>>>>>> instead of sending them out directly. Otherwise, if everyone does t=
his,
>>>>>>> the community will be full of bots.>>>>>> 2. Looking at the mm
> prompt: https://github.com/masoncl/review-prompts/blob/main/mm.md ,
> are you sure the patterns are all right?
>>>>> 	a. Page/Folio States, Large folios require per-page state tracking f=
or
>>>>> 		Reference counts. I thought we want to get rid of per page refcount.
>>>
>
> [ ... ]
>
>>> Early in prompt development I hand picked a few hundred patches from
>>> 6.16 fixing bugs, and I iterated on these adding subsystem knowledge to
>>> catch the known bugs.  That's where that rule came from, but as you say
>>> there's a risk this information gets old.  Do we want to get rid of per
>>> page refcounts or have we done it?  (more on that at the bottom of the
>>> email).
>>=20
>> There is no such thing as a per-page reference count.  Any attempt to
>> access the page reference count redirects to the folio refcount.  This
>> has been the case since 2016 (four years before folios existed).  See
>> commit ddc58f27f9ee.
>>=20
> Ok, I'm half out the door to vacation, but I'll fix up the mm.md to
> better reflect reality when I get back.
>
>> We do want to git rid of calls to get_page() and put_page() for a
>> variety of reasons that will be long and painful to write out.
>>=20
>>> As an example of how I'd fix the prompt if the per page state tracking
>>> were causing problems (and if we didn't want to just remove it), I asked
>>> claude to analyze how it is still used.  The output is below, I'd double
>>> check things as best I could, shorten into prompt form and send to the
>>> list for review.
>>>
>>> Per-Page Tracking in Large Folios - Analysis
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>
>>> Based on analysis of mm/*.c files and commit history, MM-004's claim is
>>> still partially true - large folios do need per-page tracking for some
>>> bits, though recent work has significantly reduced this.
>>>
>>>
>>> Bits That Still Require Per-Page Tracking
>>> ------------------------------------------
>>>
>>> 1. PG_hwpoison (include/linux/page-flags.h:118)
>>>
>>>    Defined as PAGEFLAG(HWPoison, hwpoison, PF_ANY), this flag is set on
>>>    individual pages within a large folio when hardware memory corruption
>>>    is detected.
>>>
>>>    The folio_test_has_hwpoisoned() flag on the second page indicates at
>>>    least one subpage is poisoned, but does not identify which one.
>>>
>>>    When splitting a large folio, page_range_has_hwpoisoned() in
>>>    mm/huge_memory.c:3467 iterates through pages checking PageHWPoison()
>>>    for each:
>>>
>>>        static bool page_range_has_hwpoisoned(struct page *page, long nr=
_pages)
>>>        {
>>>            for (; nr_pages; page++, nr_pages--)
>>>                if (PageHWPoison(page))
>>>                    return true;
>>>            return false;
>>>        }
>>>
>>>    Used in rmap code (mm/rmap.c:1990, 2070, 2473) to check individual
>>>    subpages when unmapping or migrating.
>>>
>>> 2. PG_anon_exclusive (include/linux/page-flags.h:146)
>>>
>>>    Per the comment at include/linux/page-flags.h:139-145:
>>>
>>>        "Depending on the way an anonymous folio can be mapped into a pa=
ge
>>>        table (e.g., single PMD/PUD/CONT of the head page vs. PTE-mapped
>>>        THP), PG_anon_exclusive may be set only for the head page or for
>>>        tail pages of an anonymous folio. For now, we only expect it to =
be
>>>        set on tail pages for PTE-mapped THP."
>>>
>>>    Used at mm/rmap.c:1408-1416: when RMAP_EXCLUSIVE flag is set for
>>>    PTE-level mappings, it iterates through each page:
>>>
>>>        for (i =3D 0; i < nr_pages; i++)
>>>            SetPageAnonExclusive(page + i);
>>>
>>>    HugeTLB stores this on head page only (see PageAnonExclusive() at
>>>    include/linux/page-flags.h:1153-1162), but PTE-mapped THP needs
>>>    per-page tracking.
>>>
>>>
>>> Recent Changes - Per-Page Mapcount Removed
>>> ------------------------------------------
>>>
>>> Commit 749492229e3bd ("mm: stop maintaining the per-page mapcount of
>>> large folios") by David Hildenbrand (March 2025) introduced
>>> CONFIG_NO_PAGE_MAPCOUNT which:
>>>
>>>   - Stops maintaining per-page mapcounts in tail pages of large folios
>>>   - Tail page mapcount is now always logically 0 (-1 value)
>>>   - Removed _nr_pages_mapped tracking
>>>
>>> This was a significant simplification, but it does not affect the
>>> per-page flag tracking described above.
>>>
>>>
>>> Flags Stored in Second Page Only (Not Per-Page)
>>> -----------------------------------------------
>>>
>>> These are stored in the first tail page (FOLIO_SECOND_PAGE) and apply to
>>> the entire folio, not individual pages:
>>>
>>>   - PG_has_hwpoisoned  - indicates some page in folio is poisoned
>>>   - PG_large_rmappable - folio is rmappable
>>>   - PG_partially_mapped - folio is partially mapped
>>>
>>> See PAGE_FLAGS_SECOND definition at include/linux/page-flags.h:1218-122=
0.
>>>
>>>
>>> Conclusion
>>> ----------
>>>
>>> While per-page mapcount has been eliminated, PG_hwpoison and
>>> PG_anon_exclusive (for PTE-mapped THP) still require per-page tracking
>>> in large folios. MM-004's claim remains valid for these specific bits.
>>>
>>> Key source files:
>>>   - include/linux/page-flags.h (flag definitions and accessors)
>>>   - mm/huge_memory.c (folio split handling)
>>>   - mm/rmap.c (reverse mapping with per-page exclusive tracking)
>>=20
>> This is pretty good and yet dangerously wrong in some missed nuances.
>> Which probably summarises the state of the art nicely ;-)
>>=20
>
> Yeah, that's generally how it goes.  It's a good starting point, but the
> details have to get verified.
>
>> To start with, all flags marked as PF_ANY are set on individual pages
>> rather than only the folio.  So that's currently:
>>=20
>> PAGEFLAG(Private, private, PF_ANY)
>> PAGEFLAG(HWPoison, hwpoison, PF_ANY)
>> PAGEFLAG(VmemmapSelfHosted, vmemmap_self_hosted, PF_ANY)
>> __SETPAGEFLAG(Head, head, PF_ANY)
>>         return test_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
>>=20
>> Now, PG_private is a flag we're trying to get rid of -- it should be
>> identical to (folio->private !=3D NULL), so I haven't made any effort
>> to convert that from being PF_ANY.  I'm not too unhappy that your chatbot
>> doesn't talk about PG_private, but a more full answer would include
>> mention of this.
>>=20
>> PG_hwpoison and PG_anon_exclusive will remain per-page state in a
>> memdesc world, and there's a plan to handle those, so there's no need to
>> eliminate them.
>>=20
>> PG_vmemmap_self_hosted is a very, very internal flag.  It's OK to not
>> know about it.
>>=20
>> PG_head has to remain per-page state for now for obvious reasons ;-)
>> In a memdesc word, there will be no way to ask if a page is the first
>> page of an allocation, so this flag will not be needed.
>>=20
>> I believe there are some subtleties around PG_hwpoison and hugetlb that
>> are not fully captured above, but I'm not convinced of my ability to
>> state definitely what they currently are, so I'll leve that for somebody
>> else to do.
>
> Thanks for taking the time to debug the output.  I think before trying
> to put this into the prompt, I'd step back and ask:
>
> - What bugs do we want AI to catch?  I can see knowing these large folio
> details really helping find bugs in the transition, or debug bug reports
> down the line, so it feels like an important detail to record.  It's
> definitely something AI won't know all by itself.
>
> - What details is AI getting wrong in current reviews?  We don't really
> have this answer yet, but if AI isn't getting it wrong, there's no
> reason to try and teach it more.

Also, we probably don't want to hard-code the current state of the art,
as ideally we should be able to review old patches as well (e.g. on top
of LTS or custom private trees). So in the perfect world we want to provide
some meta-ideas on how the LLM can decode the rules from the code itself.

