Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FEAAD31A15
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB756B008C; Wed, 14 Jan 2026 02:20:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45EA6B0092; Wed, 14 Jan 2026 02:20:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F286B0093; Wed, 14 Jan 2026 02:20:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91A1B6B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:20:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F8A0C1AC2
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:20:14 +0000 (UTC)
X-FDA: 84329720748.18.253ACEE
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4A110100004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:20:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/7FT5Lk";
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768375212; a=rsa-sha256;
	cv=none;
	b=ZIVXUHQIBouBCErt3lBSR2zOXhIsCpd642tG3F6OG25hW8NFBNKESW1cvSkYQ8nRuHsWag
	YEwniKSHysjQXXZWriiOxqF4qR4rgHnefFRcH8lpsJzDpMAcfb2NqFMQuqEqe43Jl0V7zw
	BNlBYseD+xqAI3qst2+bMbY2FO/ad3c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/7FT5Lk";
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768375212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZhuQ4Kj6PEI3Wh95q/aQ/X7uFCtTD8uLx3UOMlw/Og=;
	b=zF1NRYKolAHybGYB0rCZr0zmUZzOHtjMjk+kYEb8nc7yeUNShlEt/n6GdUDMNA1U4VACpI
	JAmw3S7sj+TjmZ1uJsnU4++ELqvj2iKzp5JM1uDDb1wwrWAX3vIWpA4YYCsXBluGcesa08
	BxQmOajvUjaWeEMP9EuklA5oVxhGrEk=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768375209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bZhuQ4Kj6PEI3Wh95q/aQ/X7uFCtTD8uLx3UOMlw/Og=;
	b=M/7FT5LkHJfTtlvj1MpmkPypLWsVSfMh7dQpCKJjFQQakzEied/8pKbIeQ/Bpy1ujuzlwv
	JCdzG8dWTDZ+rGCkA0WZDuhKEk5JxI2WzjjYtOJYW8ZqXXQzTDpqPu7pZ5IrygKsLN0ELm
	4vz+i99TpW10TuJoCzUWRN9bF8ROlt4=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v6 4/4] mm: thp: reparent the split queue during memcg
 offline
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <3d8dd14c-d3a7-4cae-99e3-10ebe4ad52aa@linux.dev>
Date: Wed, 14 Jan 2026 15:19:25 +0800
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Chris Mason <clm@meta.com>,
 hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 david@redhat.com,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com,
 npache@redhat.com,
 ryan.roberts@arm.com,
 dev.jain@arm.com,
 baohua@kernel.org,
 lance.yang@linux.dev,
 akpm@linux-foundation.org,
 richard.weiyang@gmail.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C5A78F53-47F6-4A98-AB66-0CBD3D8B10B4@linux.dev>
References: <8703f907c4d1f7e8a2ef2bfed3036a84fa53028b.1762762324.git.zhengqi.arch@bytedance.com>
 <20260113220046.2274684-1-clm@meta.com> <aWcrVRT_RjxdjoN7@hyeyoo>
 <3d8dd14c-d3a7-4cae-99e3-10ebe4ad52aa@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4A110100004
X-Stat-Signature: yh56dchepuwb4e5hfe4eaqab5ijwmcdn
X-Rspam-User: 
X-HE-Tag: 1768375212-291244
X-HE-Meta: U2FsdGVkX1/Nh14LymqJiXDm2ay4asMI3CIkC1mHBlsrW1r1bvhCEGPMj/o9gK9ZRykHWxJ4gcbwVYbEtJflZfw87cZhy9tzcREpog8Om5OwCsstXHgEzDJwN3TSLRV4mS4qoj28TjAlEQhhsx2dLPhcHfgIkUPQW9NoP/MYg/1hEQW/aDAMVxZvGudxiLZulAbAm+5bF3Pq27qUkabypSA3QTe2a3gr35+KzP9ALlAP4buOBIhpTivrny5VlCpSczoMr6+mixguin3hR/g1lKNvi2J50C8LzNZvkkL2pM+KAMzcpJBeT9isFqTXkfMligeoivF/EmgznjtDRmYJ0G5B1uQxHyFLGDCDiNxsD0HKPgSKmq6J7rDGJNpuvJkcQXC+2jH5rSxSCoBf4HHsxJ/8nI0ItxyLt447wPLO1kOSLT1kTHBAFZGWpgvy2vAVF0fCff7HX/S99QrpzydN/ZLGO4W1RBNRoq7c70XJ2Z2KaKXV2pjHXN+4v020GbKTB9fHQFtrWUaoHQKCtiO+6ZcFlJ1HtkCNpyUPlG77sIqxGEPwB/ZUxjoQFN29tSvUgo6WC4DtglIcoY9DFYWJ1uyX2Ig/SXnOgk0m5cp+8/tfDhhvLQhIOw9n80whgrRTXZplz9pZeymuMxVslEn6krtNnx4n7g5vtTkhKbGEAvqJUOjzZCs9lhDV7em/bsmdHmsakCKEfhrnzFhQy6T7+ogmujjy1KNvDm+ru8FZwhpbMPxdMAtL8T1C5xiZ17D3XZV5pg5r3Ivc3jbAuh+oxzbUjRQANUaTtKlXMjmUGGWftgZdx40umW/+6YeUW0ArqMGVJU9mPYyh8TOldCuvt2jUdA6tu+WwnsliWExy9wpgjI5/xpfaB6Fn1Dm/t3I9JNBmEAYmt+AuWBMl8DeSDV0RtU8sv7VvpOLKsFn99uppGNuSFdKu3ZgVfYP5o3U3Pymzo/3RY3ykCoXanRc
 10/iEs4A
 W+UyaCB8luyEFykwuLUZ4DtbF2+RPQ6fOlaCXuy8CybqHRqtJkU12/BNk2wt6Z6PAiuFoc+W0tN+N1TrC93WFmy/Y/qn9M4/YaZmLsAQwqnibw5TlPTszFURsrGPwSw+JwI81EqL3Gksz6XI/rbVYErL1MfIbeJCstpywjGjP96+ZJ5i+umvqA6LiCFoCxSrYkAUXbMs46yMphyUxNpPuQOOVqESrCmP0cuaO90DldFtxYgp9OmN2X6eenvGY/JUDaR3AKmDkPa418x0bThUQdta4ypXnpg8kcjbhiGjDTYJQprF++5lWSWZsiuAy+5X/jGY0zOYW9x11nLACDeFP5C8k0SqXpPC1W0bj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 14, 2026, at 14:25, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
>=20
>=20
> On 1/14/26 1:36 PM, Harry Yoo wrote:
>> On Tue, Jan 13, 2026 at 02:00:43PM -0800, Chris Mason wrote:
>>> On Mon, 10 Nov 2025 16:17:58 +0800 Qi Zheng <qi.zheng@linux.dev> =
wrote:
>>>=20
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>=20
>>>> Similar to list_lru, the split queue is relatively independent and =
does
>>>> not need to be reparented along with objcg and LRU folios (holding
>>>> objcg lock and lru lock). So let's apply the similar mechanism as =
list_lru
>>>> to reparent the split queue separately when memcg is offine.
>>>>=20
>>>=20
>>> Hi everyone,
>>>=20
>>> I'm running all of the MM commits since v6.18 through the AI patch =
review
>>> tools, and this one was flagged.  I'm much less confident in this =
report,
>>> AI tends to get these races wrong:
>>>=20
>>> [AI review output]
>>>=20
>>>> diff --git a/include/linux/memcontrol.h =
b/include/linux/memcontrol.h
>>>> index b0c6a4635c67b..cc6db20d7dca0 100644
>>>> --- a/include/linux/memcontrol.h
>>>> +++ b/include/linux/memcontrol.h
>>>> @@ -1775,6 +1775,12 @@ static inline void count_objcg_events(struct =
obj_cgroup *objcg,
>>>>  bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
>>>>=20
>>>>  void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
>>>> +
>>>> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
>>>> +{
>>>> + return memcg ? css_is_dying(&memcg->css) : false;
>>>> +}
>>>=20
>>> [ ... ]
>>>=20
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 13684e5376e82..d17d3810a882c 100644
>>>=20
>>> [ ... ]
>>>=20
>>>> @@ -1129,8 +1140,14 @@ split_queue_lock_irqsave(int nid, struct =
mem_cgroup *memcg, unsigned long *flags
>>>>  {
>>>>   struct deferred_split *queue;
>>>>=20
>>>> +retry:
>>>>   queue =3D memcg_split_queue(nid, memcg);
>>>>   spin_lock_irqsave(&queue->split_queue_lock, *flags);
>>>> + if (unlikely(memcg_is_dying(memcg))) {
>>>> + spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
>>>> + memcg =3D parent_mem_cgroup(memcg);
>>>> + goto retry;
>>>> + }
>>>>=20
>>>>   return queue;
>>>>  }
>>>=20
>>> There appears to be a race window that can cause split_queue_len =
counter
>>> mismatch. Between the time CSS_DYING is set (in kill_css()) and when
>>> reparent_deferred_split_queue() actually runs (asynchronously in
>>> css_offline), folios can be unqueued via =
__folio_unqueue_deferred_split().
>>>=20
>>> In this scenario:
>>>   __folio_unqueue_deferred_split()
>>>     -> folio_split_queue_lock_irqsave()
>>>        -> split_queue_lock_irqsave() sees memcg_is_dying() =3D=3D =
true
>>>        -> returns parent's queue (locked)
>>>     -> ds_queue->split_queue_len-- decrements parent's counter
>>>     -> list_del_init() removes folio from child's list
>>>=20
>>> The folio is correctly removed from the child's list (list_del_init =
is
>>> self-referential), but the wrong queue's counter is decremented.
>> Good point. Sounds pretty possible to me?
>> I don't think there's anything that prevents it from unqueued
>> before it's reparented.
>>> If the parent queue was empty (split_queue_len =3D=3D 0), this would =
cause an
>>> unsigned long underflow to ULONG_MAX.
>> Although the accounting mismatch will only persist until
>> reparent_deferred_split_queue() reparents the deferred split queue.
>=20
> This period is very short, and the only thing affected should be
> deferred_split_count(), but it does not cause a system error.
>=20
> So I think maybe we can leave it unrepaired.

I didn=E2=80=99t look closely at the specific issue, but based on Qi=E2=80=
=99s point,
we can actually take a cue from list_lru_count_one and provide a similar
workaround to keep deferred_split_count from returning an enormous
value=E2=80=94see commit 41d17431df4aa.

>=20
>> Ideally this should be fixed by checking if the folio has been
>> reparented after acquiring the split queue lock, but since we don't =
reparent
>> LRU pages yet ... do we need a band-aid before then?
>> Do we want to have is_dying property in the split queue as it was in =
v2? [1]
>> [1] =
https://lore.kernel.org/linux-mm/55370bda7b2df617033ac12116c1712144bb7591.=
1758618527.git.zhengqi.arch@bytedance.com
>>> Could this be addressed by checking that the folio is actually in =
the
>>> queue being unlocked, perhaps by verifying the list head matches =
before
>>> decrementing split_queue_len?
>>> [ ... ]
>>>=20
>>>> @@ -3920,6 +3920,7 @@ static void mem_cgroup_css_offline(struct =
cgroup_subsys_state *css)
>>>>   zswap_memcg_offline_cleanup(memcg);
>>>>=20
>>>>   memcg_offline_kmem(memcg);
>>>> + reparent_deferred_split_queue(memcg);
>>>=20
>>> The race window exists because CSS_DYING is set in kill_css() before
>>> css_offline() callbacks run asynchronously. The comment in =
split_queue_lock
>>> mentions that THPs will be "hidden from the shrinker side" during =
this
>>> period, but does not address the counter accounting issue when =
folios
>>> are unqueued.
>=20


