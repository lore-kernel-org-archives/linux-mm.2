Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7973B606A32F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 08:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=avLsiJ0U
Received: by kanga.kvack.org (Postfix)
	id 6F34B6B05B0; Fri,  6 Nov 2026 03:38:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3DF6B05B1; Fri,  6 Nov 2026 03:38:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA7E6B05B2; Fri,  6 Nov 2026 03:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 372446B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:38:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2DFC140357
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:38:44 +0000 (UTC)
X-FDA: 85404043368.09.0F75C4A
Received: from mta1.migadu.com (out-140.mta1.migadu.com [95.215.58.140])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8925D100003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:38:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=avLsiJ0U;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793954323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7HL2QGS1OX92aMQqi1SQISrpLABTArOf/d1xsMjIfRU=;
	b=jguTP58AHfV47NEz7WhwwOru/skJo2df1c44du++jwcgoY0tha2qONtv3pDb8LWH0yMWWh
	TTmJjWPXN2+UJgt8YYpa/xiNguMLrhgjJU9D0bbHGPukmo0rswjixScGYp1g6ejCyt8/fN
	AZu+brSxZZ98XL7JkIRE75ANYepX0D0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793954323;
	b=gB+HgINsqHVGvOIS4CK1vPXz0UGKVqaj2WsFC+3xxFCbb9i7QA7wv4gz/GmEXhH7Y0wHbU
	5HvuAgMhrBjeHvxR467l4XTetdj7LVho/xzSyHH/Wp2UEKQAKyMumhFFhBhR6HnwSQaSKe
	COxQIwtSM0C1stJk93HR8YuEkPpNpbA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=avLsiJ0U;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OQv2V6wgOoL/c3SmQoZgSHZMEHskeM3NZ49yCaWoo0Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793954320; v=1; x=1794559120;
 b=avLsiJ0U8JkNoApkvbqr8ex0R1z0VcEIOEgvt78Xjk6zeNaX9AX6FOF114vxKtIRy6EwZDYp
 sljQMWyAxHutm56MKltEfZuB5ZwjqOlyDDSJj18Wfn107hqxWm2eiDlOZ9G4RwSE3+zzXoQti2c
 G4L/j7q1y6QOIZbU43ezAYDY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 36c4e4aa0a83de9a;
	Fri, 06 Nov 2026 08:38:40 +0000
X-Mizu-Trace-ID: 36c4e4aa0a83de9a
X-Migadu-Flow: FLOW_OUT
Message-ID: <8e5956d5-ae03-40c0-b5a0-bd550f4c14b3@linux.dev>
Date: Fri, 6 Nov 2026 16:38:35 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH v2] mm/mglru: fix a no-op lru_gen_clear_refs() call in
 lru_lazyfree()
To: Barry Song <baohua@kernel.org>, Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <20261026084035.535989-1-hui.zhu@linux.dev>
 <CAMgjq7AJSU9jUBTHGcm05mtGBH4EMQ_ua9YNwuLOGVzhkdLKkA@mail.gmail.com>
 <CAGsJ_4zPZg6pCuhDtTpSkueS2EDSfWeYa23h7kC9hEU0iGB-+w@mail.gmail.com>
 <CAMgjq7DvmrwTu0vz7oHx7y7w1B9uA0AbS3YJ5CcrDVg9VwKqpw@mail.gmail.com>
 <CAMgjq7A6jJQ_Ncp0BCqjQJ8pJXrjr1PoOu0rdj0NJOivKp6e+A@mail.gmail.com>
 <CAGsJ_4zO5S5XFc6dd70wKEs_mzqu_QW2bGOPyhKo4w2cjZrWUQ@mail.gmail.com>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <CAGsJ_4zO5S5XFc6dd70wKEs_mzqu_QW2bGOPyhKo4w2cjZrWUQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: b8q3hyanqdp7twscy7w8amdqewuqh1dn
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8925D100003
X-Rspam-User: 
X-HE-Tag: 1793954322-933870
X-HE-Meta: U2FsdGVkX1/DzNTUDJ6k69WCS/G+06wgnNFIdqXeeZXypIi4NjNXPDyDQfwltIJK7MFNleeb89OzW5HcW4+r2qf4jMpg+CpbS08sWJ2fMUXSjsVBBQPehKUbx2OCFFa+9zaVTkkbXAojpkIugWkPL2rIs3rjzCdN5N9wYGgYJBXBR72MUVWp3Y9bZV0zzCnEhYz22xVcl6ya3jyqMNhQoQA+BKd3croAD767WZGvdwo3T52woGV+CNP0G0kr8vWPJOGCMsI4Jcl7ymW6VQKhUfR8Kx+Bzw9ptfokq4G/SBCfigCos5v8LZuM2BYUom21+86KJQ8ZEzfXmWsLhr9I0KdZA3RO0ot2hUwuD+9szcGyb8W8HOboKWJ0P89NgnhiK0vmEEeVACvyVSbOSXKbxeon5l6zcZODE9DjW4iXw+nQYHQSqh9I8ll9pElAkZhEivoIjYgwdVVFREi6OAku/xKqDXxzZQqA/0++QhJ9wFkHltIvEFaF5hbwQ4GYSCijTt5czrLy02lRdemUnq2W1vQu3yG2kokc+MEs/DOqtl1qcG6QX5GOrhFlgPHeaXyoOr49qYRkEyG7kZeYlhNXnnbd6BtmMkJnv03UDgsnTNtUsOq54xEEjSlAF7z7MpCrL2guUcW4oQllw1+j6EBTRcvvs6Rgd2lo3lR7i8huEiQ/GWkHxIL+7LpATTPC3DcZvv21tZCzv19SCvve0aVYK563+9CrvFZ8dLkrRPQ1noY0cJFwN17e3EtIRfccHi4d2XaqTnRHQCYTDNQe5zS2O50GSopNEoEsCoCItxNjKqmw885Gp/qy5mJJSHxfQPmRVlveaLqjGfFZp2gKecwbrGh286rA3XF4YuOQ+jWMiNCNNbgbwlD/MCBinjHNaxQadbz2KY/7nGUKSuxdvNe6nlSKg1S/4QDGD7HpJf0sDjXWxVeW3TSXxhi/OfJEGT6PZwrhhkGah/dP0sr8jNh
 QScBCkm6
 qc70qzPuUkMEPuykV8zaBbnFf6eOnzUc2TccwzoxWLmjIjlayg2XEQuRJnd00DazyIWxYjA2y1S7+Dv24H7zjG82wRGLOJdf2U1fZzJGWNoGO4urwQbhc8ydn4YvF8qPTcH4bxK0iMn15QhRVjQclZsjyp+M/M4s7PAZakX7aj+mdU5jUwLYM5aFXY32q+m5a+zb1EL5MpxRLZ068ljHlPyFmwFW7Pw3r2xtHQVFcd027pJphSqRkasodBAHTndQw+s5+9zkl28PstDwU1OZfApmAPTx33MuPoyBj+qpsC269tycgYcjEMbJA7W/GyCk4ScgYrvDBRuY95CKdFr3t8fvZ5gUsNX3tcCPY77UC7l0I80vKmQt0A6FKiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


2026/11/6 05:13, Barry Song:
> On Sat, Oct 31, 2026 at 3:27 PM Kairui Song <ryncsn@gmail.com> wrote:
> [...]
>>>>>>   mm/folio.c | 6 ++----
>>>>>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/folio.c b/mm/folio.c
>>>>>> index 35e242b48870..ea3adb6a89d7 100644
>>>>>> --- a/mm/folio.c
>>>>>> +++ b/mm/folio.c
>>>>>> @@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *lruvec, struct folio *folio)
>>>>>>              folio_test_swapcache(folio) || folio_test_unevictable(folio))
>>>>>>                  return;
>>>>>>
>>>>>> +       lru_gen_clear_refs(folio);
>>>>>>          lruvec_del_folio(lruvec, folio);
>>>>>>          folio_clear_active(folio);
>>>>>> -       if (lru_gen_enabled())
>>>>>> -               lru_gen_clear_refs(folio);
>>>>>> -       else
>>>>>> -               folio_clear_referenced(folio);
>>>>>> +       folio_clear_referenced(folio);
>>>>> Why can't we just call folio_set_lru_refs(.., 0), and should we clear
>>>>> PG_workingset? Keeping it helps PSI on refualt / redirty tracking (not
>>>>> sure if meaningful but CLRU does this), clearing it makes eviction
>>>>> better, but the eviction issue is MGLRU-only, CLRU keeps it.
>>>> I recall that in v1 [1], Hui mentioned:
>>>>
>>>> "Use folio_clear_referenced() rather than
>>>> folio_set_lru_refs(), which is not defined without
>>>> CONFIG_LRU_GEN."
>>>>
>>> Or prehaps we can have a folio_clear_lru_refs() do in a unified way
>>> for For both CLRU / MGLRU? (Just like folio_migrate_lru_refs).
>> And it will be better if we can keep this operation off-list just like
>> right now :), some later works could benefit from it.
> lru_gen_clear_refs() is currently multifunctional. It clears
> refs/workingset, but also returns true to skip
> folio_batch_add_and_move() in both deactivate_file_folio()
> and folio_deactivate().
>
> This actually looks a bit weird. However, following the current
> logic, I've drafted a version that we can use as a starting point
> for discussion:
>
> diff --git a/mm/folio.c b/mm/folio.c
> index dc2c796a4ea7..bc17cd3b6b6c 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -444,12 +444,12 @@ static bool lru_gen_clear_refs(struct folio *folio)
>          int type = folio_is_file_lru(folio);
>          unsigned long seq;
>
> -       if (gen < 0)
> -               return true;
> -
>          folio_set_lru_refs(folio, 0);
>          folio_clear_workingset(folio);
>
> +       if (gen < 0)
> +               return true;
> +
>          rcu_read_lock();
>          seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
>          rcu_read_unlock();
> @@ -465,6 +465,8 @@ static void lru_gen_inc_refs(struct folio *folio)
>
>   static bool lru_gen_clear_refs(struct folio *folio)
>   {
> +       folio_clear_referenced(folio);
> +       folio_clear_workingset(folio);
>          return false;
>   }
>
> The another option is:
>
> diff --git a/mm/folio.c b/mm/folio.c
> index dc2c796a4ea7..8d1fd788188c 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -438,6 +438,12 @@ static void lru_gen_inc_refs(struct folio *folio)
>          } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>   }
>
> +static inline void __lru_gen_clear_refs(struct folio *folio)
> +{
> +       folio_set_lru_refs(folio, 0);
> +       folio_clear_workingset(folio);
> +}
> +
>   static bool lru_gen_clear_refs(struct folio *folio)
>   {
>          int gen = folio_lru_gen(folio);
> @@ -447,8 +453,7 @@ static bool lru_gen_clear_refs(struct folio *folio)
>          if (gen < 0)
>                  return true;
>
> -       folio_set_lru_refs(folio, 0);
> -       folio_clear_workingset(folio);
> +       __lru_gen_clear_refs(folio);
>
>          rcu_read_lock();
>          seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
> @@ -463,9 +468,10 @@ static void lru_gen_inc_refs(struct folio *folio)
>   {
>   }
>
> -static bool lru_gen_clear_refs(struct folio *folio)
> +static inline void __lru_gen_clear_refs(struct folio *folio)
>   {
> -       return false;
> +       folio_clear_referenced(folio);
> +       folio_clear_workingset(folio);
>   }
>
>   #endif /* CONFIG_LRU_GEN */
> @@ -659,10 +665,7 @@ static void lru_lazyfree(struct lruvec *lruvec,
> struct folio *folio)
>
>          lruvec_del_folio(lruvec, folio);
>          folio_clear_active(folio);
> -       if (lru_gen_enabled())
> -               lru_gen_clear_refs(folio);
> -       else
> -               folio_clear_referenced(folio);
> +       __lru_gen_clear_refs(folio);
>          /*
>           * Lazyfree folios are clean anonymous folios.  They have
>           * the swapbacked flag cleared, to distinguish them from normal


Hi Barry, Kairui,

>
> I would personally prefer the latter. What do you think, Hui and Kairui?

I prefer option B too: it keeps the flag clearing independent of the
list state and leaves the two deactivate callers untouched.

But I'd suggest splitting this in two:

1. Take v2 as the fix now. If that is acceptable, I will respin it
    with Cc: stable added.

2. Follow up with option B as a pure cleanup, no Fixes tag. The
    lazyfree site then becomes the off-list __lru_gen_clear_refs()
    call that Kairui wants for later work.

The reason is backporting. Every stable from 6.14 (cc8ec7be78ff) to
7.3 carries the regression, but B is written against
folio_set_lru_refs(), which only landed in this merge window
(64169ceea5b1e). None of the affected trees has that helper, so
backporting B would drag the refs-flags rework along with it. v2
applies to all of them with only the mm/swap.c -> mm/folio.c rename
to adjust.

B also starts clearing PG_workingset on the classic LRU. I agree
with Kairui that this is the right semantics for MADV_FREE, but it
is a change beyond this regression and deserves its own patch - it
fits naturally in the MGLRU-FG flag cleanup, as does the sort_folio()
lazyfree check.

Best,
Hui


> Best,
> Barry

