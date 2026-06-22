Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED65CDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8456B0096; Mon, 22 Jun 2026 04:33:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07FA66B0098; Mon, 22 Jun 2026 04:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9F36B0099; Mon, 22 Jun 2026 04:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B87456B0096
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:33:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 454EF4058F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:33:28 +0000 (UTC)
X-FDA: 84906884496.25.ADE74C6
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5B6EAC000A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:33:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FHQAc44n;
	spf=pass (imf10.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782117206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqsCQKkmRUVfBZPd9K730PqbM5N64wyAbDnC+li40Cw=;
	b=XXS1vIReiy8mG0JqLbXI87KWMwPId1d6b7i+6kY/wkrXFdESATmaWeNH24O9/VNdH6z1wT
	JSlv/fa0D4JkHYSUKBh4lljl/j5j6UcgjL/VRycMec7dLmTlCKbe6wI/1anzTmH9FwrHMP
	LGCz4V5Y67JHFvJOSHXUoBJ0YKfsXc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782117206;
	b=JqCj1sm6w2Qo/79+qy8yHoWTOefv//J8W9kzpXikcUMplTO3ihLea9tOwD0jE22XFuZ8lx
	oHehgWeARwjGBBghlWqhwOke9VKDcuC0LbM8HWzNjmtnRlU8th5CxycD7nYmLACpYIU9uo
	N+0Qu7SWJmqCLl6AklwtESYaSYdbJ1s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FHQAc44n;
	spf=pass (imf10.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782117204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KqsCQKkmRUVfBZPd9K730PqbM5N64wyAbDnC+li40Cw=;
	b=FHQAc44nNfvpZIk6Uesy9k4k9buuih+lxEV7l+zy54ZgveUwr+BgFoeslLQE75ak8UVx4M
	y7bVz8N0i/NrJh5F/0cTK/UcW17X8U94lzBuQX+qTpeGiy4CZJNXy5Eh7fIs3JrAJVIOfd
	lJhqrCFABYGLKPmVbs/XB8+wA4Q2SSA=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 22 Jun 2026 08:33:12 +0000
Message-Id: <DJFFTJZGYZ91.6Y7J8M13KU5@linux.dev>
Subject: Re: [PATCH] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Hao Ge" <hao.ge@linux.dev>, "Suren Baghdasaryan" <surenb@google.com>,
 "Brendan Jackman" <brendan.jackman@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Michal
 Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar Salvador"
 <osalvador@suse.de>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Alexei Starovoitov" <ast@kernel.org>,
 "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
 <2399b3ad-4eac-4a14-94c3-27e9f07972a1@kernel.org>
 <CAJuCfpG48TmvaiaRvnL-NXKU6nn55D3bks2DgzAc0URsZhAxqA@mail.gmail.com>
 <DJBHRVM65A11.1OL2M9MXN56H@linux.dev>
 <45fcc57a-ec8d-46d6-9c28-065d001c081f@linux.dev>
 <DJD0AGHTWYRN.1YWG5MDH87WVO@linux.dev>
 <CAJuCfpGtymV=Tmsvs8Z-oF6pi7mD54mRiZNZtpF3UpYwBL7Uig@mail.gmail.com>
 <267e070f-adc2-4f42-b528-746f852d9ef4@linux.dev>
In-Reply-To: <267e070f-adc2-4f42-b528-746f852d9ef4@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jxuqitbooi13ph4u16kuhoueink4j7wt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5B6EAC000A
X-HE-Tag: 1782117206-834244
X-HE-Meta: U2FsdGVkX184iqFXmeCnrG8vFl9tm/FX6fwj/DPZOESHqx7vKIBatErlIe0GJ/u9XnTi896ZtGkXBZcsTpGlSQC/qhBhxAluArD/kAkZBTileNNuFsVazYMaPEI+1udrxidI98103qYT/mhPCfQjMq/Unf51aG/NEsYrSOyTL7loEVDe4E81SllCS0FznpWbfE8pEPF0H11Gj+F5QNRJ0g8FpYgi98UG+LwZ7Ud/+kPfOSuU6KQUuQgXcGlMOCRmgjg0VkN0SFDrisWQPCB6xrL9Y8uOxSWW+T0K5hpEPxTHVDsu8DuENA9OORNoWz1Eo1S78N/0o9niYazxx5NoZiZrAd5cvSzUJLIMhxmxHpsox5x2/cFZ9BAZYrlSGO1XFrMX/Wpsftr9xFB1aN9Dx+MNMUc6Qc+L6AruNQAqtZNxEl7NitYGJ2m5PsQVFDFwrxMMv2QjFBxDpQD7bNo61QFlEOS5CUJUDLiwn5UfbBR1iRVIte6SdL43/XPDVBa5xzY38bVhemG44WTzfasuVkhAi+CjldxQpHwVGtKVU7XO67vE7r1zXO8obvG6Z/oz0w/HTcRysmfTBVnZuM7PzNj1GK+FrYS71PwJT/jeTL6IOnaYthNGOCWqvSjZ+2AKUQzKznh7jV+bCKXPLEgKy50VXCoJl60V7n5H9mKLWTYKBI3/Qi9CWH3bc1/2b2OLRqb+2OfRkUOJORlOUaqNDc1ZDxTg8bbgpqU/Y1VQC/PoQbprG+ds9kvlj6Ab1FHWtFtupE2gNhT6c3xbJsO5+OefjfvLqorPcdmau6B69bEa+0Nm9Tz9wUILbEbaDif65Aa9d618flVHrxYMieJ555k32/H5l1PREPNTyB7VdNeDhietKysdCekPNKwOgJUaLIp/jmg1o2nPiQkNIIazLRH5lOOKI99oGXWLrzueyiMaYeTOLy6YQ2aVGUuXpRL6FyFMLB5EOCmyRQmuh7b
 NZmb/0FN
 0HDIwyTIwm/cyXmGorW5kSn9HD1D9AEcZzsWTu5LRURZGDmBhxEC1p94lij/mibx+eqiXandnl/Mz/FqbGt2vnTuuKGKmvciB16I9duqxq1d4LV5pSbrEU5706WwqYP56iPOn2qDOy2jT2lTlJk1gHMbQNZLbBEtyNBAmwn2xTKXHOSoK7fkRGxLwh5LGUSOWIakO1Zs42EpXHoqCVf78sZ0vVNd1jn4GF8LXs4fiaB8uK09ok06BW4iRvgspAZbj0+pRRiw6Xt4tpJfzP7obJ7z0mLUIr/iTok7qz9FYT3MwRjnQ+r6lFQrx+lQ4IqwW0fHxp5tJvwwsLcS8K6opcDZod+9k0kTMSELcDBjiuJpTv99RrDs57jaAC8a40LZKaV0pFQ7uuuRE3KqukAa1bmwPLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 22, 2026 at 1:58 AM UTC, Hao Ge wrote:
>
> On 2026/6/20 02:08, Suren Baghdasaryan wrote:
>> On Fri, Jun 19, 2026 at 4:57=E2=80=AFAM Brendan Jackman
>> <brendan.jackman@linux.dev> wrote:
>>> On Thu Jun 18, 2026 at 2:22 AM UTC, Hao Ge wrote:
>>>> On 2026/6/18 01:14, Brendan Jackman wrote:
>>>>> On Wed Jun 17, 2026 at 4:49 PM UTC, Suren Baghdasaryan wrote:
>>>>>> On Wed, Jun 17, 2026 at 9:39=E2=80=AFAM Vlastimil Babka (SUSE)
>>>>>> <vbabka@kernel.org> wrote:
>>>>>>> +Cc Alexei
>>>>>>>
>>>>>>> On 6/17/26 17:29, Brendan Jackman wrote:
>>>>>>>> Currently the core allocator code is controlled by ALLOC_NOLOCK, b=
ut the
>>>>>>> It's not, it's ALLOC_TRYLOCK! Thanks for proving that we need to re=
name it
>>>>>>> to ALLOC_NOLOCK:
>>>>>>>
>>>>>>> https://lore.kernel.org/all/DJ9QPTO2WXNB.10E88ZHWRDHB0@gmail.com/
>>>>>>>
>>>>>>> So you just won the job to do the rename :) I think it should be do=
ne before
>>>>>>> this patch, so that the new usages and other _trylock names introdu=
ced here
>>>>>>> can be done as _nolock outright.
>>>>> Ack. I'll aim to send that tomorrow once Sashiko has caught up.
>>>>>
>>>>>>>> main entry point function is significantly different from the norm=
al
>>>>>>>> __alloc_frozen_pages_nolock(), this is tiring when reading the cod=
e.
>>>>>>>>
>>>>>>>> Plumb the ALLOC_NOLOCK control one layer up in the call stack: cre=
ate
>>>>>>>> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is=
 only
>>>>>>>> exposed to mm/) and then turn the nolock variant into a thin wrapp=
er
>>>>>>>> that just sets that flag (as well as handling NUMA_NO_NODE, simila=
r to
>>>>>>>> how some of the wrappers in gfp.h do).
>>>>>>>>
>>>>>>>> Rationale that this doesn't change anything:
>>>>>>>>
>>>>>>>> 1. Simple bits: A bunch of the nolock-specific handling is just mo=
ved to
>>>>>>>>      the new alloc_order_allowed(), alloc_trylock_allowed() and
>>>>>>>>      gfp_trylock.
>>>>>>>>
>>>>>>>> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>>>>>>>>      previously in the nolock variant:
>>>>>>>>
>>>>>>>>      a. Application of gfp_allowed_mask; this only affects early b=
oot, and
>>>>>>>>         only flags that affect the slowpath get changed here.
>>>>>>>>
>>>>>>>>      b. Application of current_gfp_context() - also only affects t=
he
>>>>>>>>         slowpath
>>>>>>>>
>>>>>>>> 3. The slowpath itself: this is now just explicitly skipped under
>>>>>>>>      !ALLOC_TRYLOCK.
>>>>>>> I'll have to ponder it more closely.
>>>>>>>
>>>>>>>> Ulterior motive: adding an alloc_flags arg to the allocator's
>>>>>>>> mm-internal entrypoint can later be used to do more allocation
>>>>>>>> customisation without needing to create new GFP flags.
>>>>>>> Ack.
>>>>>> I think this change might also help us in removing __GFP_NO_CODETAG
>>>>> Nice, this actually looks trivial? I can probably just tack it onto t=
he
>>>>> v2 for this patch/series.
>>>>>
>>>>>> introduced in [1] and being the only user of __GFP_NO_OBJ_EXT once
>>>>>> Vlastimil's patchset removing other __GFP_NO_OBJ_EXT users lands.
>>>>>> CC'ing Hao as he is brainstorming ways to remove __GFP_NO_CODETAG, a=
nd
>>>>>> this might be the answer.
>>>>
>>>> Hi Brendan, Suren,
>>>>
>>>> Thanks for CC'ing me, Suren. This is indeed a viable approach
>>>>
>>>> and I believe it brings us one step closer to removing
>>>>
>>>> __GFP_NO_CODETAG entirely.
>>>>
>>>>
>>>> Brendan, I'd actually put together a rough local implementation
>>>>
>>>> earlier with mostly the same core idea as yours, and this change
>>>>
>>>> would indeed be minimal based on your patch.
>>>>
>>>> Thanks a lot for being interested in tacking this into your v2 patch s=
eries.
>>> Oh, I just took a look and it's a bit more fiddly than I thought becaus=
e
>>> alloc_tag.c is actually in lib/ not mm/.
>
> Hi Suren and Bredan
>
>
>> One option is to move alloc_tag.c into mm/ (while keeping more generic
>> codetag.c in lib/). From a quick look, that seems doable and probably
>> the easiest approach.
>>
>>> How did you tackle that, can you share your implementation? It would be
>>> nice if we can avoid exposing alloc_flags in gfp.h.
>
> First, I introduced the ALLOC_NO_CODETAG flag as shown below:
>
> @@ -1478,6 +1480,7 @@ unsigned int reclaim_clean_pages_from_list(struct=
=20
> zone *zone,
>  =C2=A0#define ALLOC_HIGHATOMIC=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x200=
 /* Allows access to=20
> MIGRATE_HIGHATOMIC */
>  =C2=A0#define ALLOC_TRYLOCK=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0x400 /* Only use spin_trylock in=20
> allocation path */
>  =C2=A0#define ALLOC_KSWAPD=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0x800 /* allow waking of kswapd,=20
> __GFP_KSWAPD_RECLAIM set */
> +#define ALLOC_NO_CODETAG=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1000 /* s=
kip codetag tracking for this=20
> allocation */
>
>
> Then, mirroring __alloc_pages_noprof, we wrapped a helper function named=
=20
> alloc_pages_noprof_notag.
>
>
> @@ -5252,13 +5335,25 @@ struct page *__alloc_pages_noprof(gfp_t gfp,=20
> unsigned int order,
>  =C2=A0{
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page;
>
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page =3D __alloc_frozen_pages_nopro=
f(gfp, order, preferred_nid,=20
> nodemask);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page =3D __alloc_frozen_pages_nopro=
f(gfp, order, preferred_nid,=20
> nodemask, 0);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (page)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 set_page_refcounted(page);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return page;
>  =C2=A0}
>  =C2=A0EXPORT_SYMBOL(__alloc_pages_noprof);
>
> +struct page *alloc_pages_noprof_notag(gfp_t gfp, unsigned int order)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page =3D __alloc_frozen_pages_nopro=
f(gfp, order, numa_node_id(), NULL,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ALLOC_NO_CODETAG);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (page)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 set_page_refcounted(page);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return page;
> +}
> +EXPORT_SYMBOL_GPL(alloc_pages_noprof_notag);
>
>
> Lastly, we exported this function in gfp.h as shown below:
>
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 51ef13ed756e..ac6e837ac8c0 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -234,6 +234,9 @@ struct folio *__folio_alloc_noprof(gfp_t gfp,=20
> unsigned int order, int preferred_
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 nodemask_t *nodemask);
>  =C2=A0#define __folio_alloc(...) alloc_hooks(__folio_alloc_noprof(__VA_A=
RGS__))
>
> +struct page *alloc_pages_noprof_notag(gfp_t gfp, unsigned int order);
> +#define alloc_pages_notag(...)=20
> alloc_hooks(alloc_pages_noprof_notag(__VA_ARGS__))
>
>
> Hope this information helps you.

Cool, thanks! On Friday I also tried doing it by just moving the .c
file and that also seems to be pretty practical.=20

