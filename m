Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F03CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531F36B00ED; Fri, 26 Jun 2026 00:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508B96B00EE; Fri, 26 Jun 2026 00:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 420F06B00EF; Fri, 26 Jun 2026 00:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 153046B00ED
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:59:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 832094038B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:59:43 +0000 (UTC)
X-FDA: 84920861046.28.F693AE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BA72240004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:59:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DktboQ2x;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782449981;
	b=RNm1HbFmuKN3pPkiMEY8VeHiiRHdkYocs665lu0xJzD/Y8ZNbIo+08NG4+Aooqio+0fMix
	vmOFjlaoxpBtKFXXu/HPmaXnBlTTDqsnE1YRFExdrIygdB4/hh9IlXbz/EfHWykhjEzWfr
	41pd0QbqKww8n+jVV+R1gU8ngwYgiRE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782449981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQydTLN/cERJBZY6JZKP8VCAhgH15XKAESApLXzuoY8=;
	b=gEiOG9H3vJSYb2CVIFdwS6HxB5O036A6Hx7M6RqD1zbcyHJbRC5lz8jpIxJfIEyA4LTCYa
	P7QXJ42lg51S4Ob7y9nCbpdokCD4DHhG9xf3gTZymZpBwwrjwDis7SPBVt4MVcuOTSaEz5
	4oVGVW8zc+WPQqUF5+DXgEFNKy3R32Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DktboQ2x;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6FD44166E;
	Fri, 26 Jun 2026 04:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A631F000E9;
	Fri, 26 Jun 2026 04:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782449980;
	bh=vQydTLN/cERJBZY6JZKP8VCAhgH15XKAESApLXzuoY8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DktboQ2xA0hGMY8Fmh9f0+XpL6P9Zxer7PldlOtFQod5tZmJbgve1NMZVBn4e0J/E
	 5Owq1HCD0uYZi+FsD3U9FIR5IBme0Xi2HE+p/MmTzlpscizw/dBkyTFK9Iey+ldRq8
	 YIGP8uK03oodbO4g+D880HpITmhSovgGmTQ+UJMcm9zYtWUepbvU/ZHuiWokMSeuv1
	 yoqDBvjJs9NWUDeB2cmJn5l8tUiX4usoEJS9OXtrS54hCuAEOXFq80zUF/M/OZG6ci
	 Xh2uh9CanlkCg+LB3Qw8Znnq4tBpFRy1Dcx51+JsVeMoVS/AAZm2SSlWjPuSLfP+Ya
	 5aMCGjVmze7+g==
Message-ID: <afdaff7c-fe6b-40da-8f54-aeeab8fe8867@kernel.org>
Date: Fri, 26 Jun 2026 13:59:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Qi Zheng <qi.zheng@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260625151554.55105-1-qi.zheng@linux.dev>
 <aj12aVq3he6q7b2C@cmpxchg.org>
 <4c7b0c46-14f0-4a62-893e-e50714e09b74@linux.dev>
 <46ac28bf-5be1-4600-b522-0a1aa76c28e6@kernel.org>
 <08cf8972-6cfc-4452-9a3c-88e0368dbbf9@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <08cf8972-6cfc-4452-9a3c-88e0368dbbf9@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------5Zw0piV59P0tyDvSf9ksEESi"
X-Rspam-User: 
X-Stat-Signature: e5781dthpidzinjkyyn96o4uhrtm1wi8
X-Rspamd-Queue-Id: BA72240004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782449981-813502
X-HE-Meta: U2FsdGVkX1/shTitSw5/NX/ft/8yocHs2cANxZnD6hGKJPlEf+ig5pElkxKF6+90pOP9PAiih8H22krTBICHg96Ocs4pmSegZAzc+N7DJk0vRCxsEH8O958LjHBAb3e1dYKWxn8F/2dRuNFzQ5BQSuG4c2UHddY745rGN02HnBweKt1LNu3n8bT739wUIM5OWvKTP8qGPvpzqI5SLmVsvoXt6bQzRo/1DCRYbGpArv7tG34sMBINXtuyybDOhCH50cxOfLL44xdLwXQIL7aoC94PRUKc1hVb4M79fhhERVZnkliY1t5R8TRMrXtru/QfRrsY5G/eS76y3mqP2OCdt9wDToS593OD7RwO4m1mPAY5PUUqCTPav8rbNguv0tDfzLst6PM1fF1cZasaeRVV3EI1U1rsssSKh9PR3W4bLcZTw0YaaXfgs45LajtIABxciUb/eJA5yxwb0Xtjrj7ZZj58h+xExp++03l/mwRI4dALmImWlPBwlEsqgmwrevPvy5fctU05Xpa2bbm+yJtnK4gcmomScOWPzr1o2bASB8UIHKe8DPTxF3CytpInoRRVf1SdDykiOX22rwC6jeeEefv9jV2rW4IK4IWAZwGfAUNr8tiM/yzUfY49ZeQDCV0UNgE6pl82FhRB1NC7p/pq8M/Fjs7xE1jsbujlPMoFcltxLDesIpsBmv7G9rEy+7zQ9besmCGiLIhOTTl4iy6KsIjO18qQEzFzC3vd0ARA0Q9WiHisWd3ok7q71l0SlhKEuDrfAWXRus7/NC8sA5EAbLEuaEvSc+D7is5Lq8eht4Nr/K9F9RnrgjXJPFofdBUcL2KrkcLSzMA9c3OjQ5cd3UpUAVi+ng+5WuPpDOg6pzY7uhV5h19EVWVKs85a3KGRBNZMPBnT9kxqyzqWT92ecYQLnO4s7PG8b+Qs5r7reTMmoaDuVxbLRcsaVLYfxoetor9GOQQprzdW6Lb8lGz
 xZlg0V/9
 PzZ7tPDl40vdIfrVz9ohhmLCx7iON7FY/6BCjPUBpdfs3deQCH/OWjz0SFGXsZE/fmnZMWL96MdfwiqKhGu3liarr66mtvPT95ypjSVVvBgUKcmHVNYIyuszZfeqmP6FXrzXdHJtPgRY5AIlUUX3hvTT7Wxw90U8jibP7baOOSc4Tzwt9o/OmCNrgsCTEwdfD9RVp4+tJVHnAUxs664CWnWCBxJ/zaYS0oAbuUoyvDYOpVPstwM610AQF13o/rn3vOB2xHprWxOw+q46hKAcFWBokMi62jQt+XspBsZX66w6UHSUT27gYTgogZuscs7Vg4QYhuKliBKcrr0BpA5DVPUos9kUA9ErFMb+4RfhYsxu0TuwglfBNwFErUL8+sVuf1u3PVzFtm8jQPYZV1c5bdn17lZK0AehVtSoKIxPuqTU5NASTLDsRCFm403kXQWh+jrTiyrmXY8lyB/4isrlVJGTlwnhgpEzsuQQi3z8BFslkoeEsCbZ289k3qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------5Zw0piV59P0tyDvSf9ksEESi
Content-Type: multipart/mixed; boundary="------------ZRX0Bm9osqEOHrx8TlGs75oJ";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Message-ID: <afdaff7c-fe6b-40da-8f54-aeeab8fe8867@kernel.org>
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
References: <20260625151554.55105-1-qi.zheng@linux.dev>
 <aj12aVq3he6q7b2C@cmpxchg.org>
 <4c7b0c46-14f0-4a62-893e-e50714e09b74@linux.dev>
 <46ac28bf-5be1-4600-b522-0a1aa76c28e6@kernel.org>
 <08cf8972-6cfc-4452-9a3c-88e0368dbbf9@linux.dev>
In-Reply-To: <08cf8972-6cfc-4452-9a3c-88e0368dbbf9@linux.dev>

--------------ZRX0Bm9osqEOHrx8TlGs75oJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/26/26 1:48 PM, Qi Zheng wrote:
>=20
>=20
> On 6/26/26 12:43 PM, Harry Yoo wrote:
>>
>>
>> On 6/26/26 11:27 AM, Qi Zheng wrote:
>>> Hi Johannes,
>>>
>>> On 6/26/26 2:41 AM, Johannes Weiner wrote:
>>>> On Thu, Jun 25, 2026 at 11:15:54PM +0800, Qi Zheng wrote:
>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>
>>>>> The mglru page table walker batches per-generation size deltas in
>>>>> walk->nr_pages while walking page tables without holding the lruvec=

>>>>> lock.
>>>>> The reset_batch_size() later folds those deltas into walk->lruvec
>>>>> under
>>>>> the lruvec lock.
>>>>>
>>>>> The page table walker can run concurrently with the memcg reparenti=
ng
>>>>> path
>>>>> as follows:
>>>>>
>>>>> CPU0                           CPU1
>>>>> =3D=3D=3D=3D                           =3D=3D=3D=3D
>>>>>
>>>>> walk_mm
>>>>> --> walk_page_range
>>>>>       --> update_batch_size
>>>>>           --> walk->nr_pages +=3D delta
>>>>>
>>>>>                                 mem_cgroup_css_offline
>>>>>                                 --> memcg_reparent_objcgs
>>>>>                                     --> lock lruvec
>>>>>                                         lru_gen_reparent_memcg
>>>>>                                         --> reparent child folios t=
o
>>>>> parent
>>>>>                                         unlock lruvec
>>>>>
>>>>>       lock lruvec
>>>>>       reset_batch_size
>>>>>       --> child lrugen->nr_pages +=3D delta
>>>>>
>>>>> This will trigger the following warning in lru_gen_exit_memcg():
>>>>>
>>>>>      VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>>>>>                     sizeof(lruvec->lrugen.nr_pages)));
>>>>>
>>>>> And the user-visible impact of underestimated nr_pages in MGLRU was=

>>>>> premature OOMs because MGLRU does not try to reclaim memory when
>>>>> nr_pages
>>>>> reaches zero, but there are still more pages.
>>>>>
>>>>> To fix it, make reset_batch_size() check CSS_DYING under RCU before=

>>>>> flushing the pending batch. A non-dying memcg keeps the original
>>>>> lruvec
>>>>> stable against RCU-delayed offlining; a dying memcg redirects the
>>>>> deltas
>>>>> to the first non-dying ancestor.
>>>>>
>>>>> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
>>>>> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-
>>>>> efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
>>>>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU
>>>>> folios")
>>>>> Cc: <stable@vger.kernel.org>
>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>> ---
>>>>> Changes in v3:
>>>>>    - re-implement lock_batch_lruvec() by checking CSS_DYING under t=
he
>>>>> RCU lock
>>>>>      (suggested by Harry)
>>>>>    - update the commit message (suggested by Harry)
>>>>>    - temporarily drop the previous Reviewed-by tags
>>>>>      (since the sync method has changed)
>>>>>    - rebase onto the next-20260624
>>>>>
>>>>> Changes in v2:
>>>>>    - update the commit message (pointed by Barry)
>>>>>    - collect Reviewed-by
>>>>>
>>>>>    mm/vmscan.c | 45 ++++++++++++++++++++++++++++++++++++++-------
>>>>>    1 file changed, 38 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>> index 35c3bb15ae96..1ec8c23c72b9 100644
>>>>> --- a/mm/vmscan.c
>>>>> +++ b/mm/vmscan.c
>>>>> @@ -3262,10 +3262,44 @@ static void update_batch_size(struct
>>>>> lru_gen_mm_walk *walk, struct folio *folio,
>>>>>        walk->nr_pages[new_gen][type][zone] +=3D delta;
>>>>>    }
>>>>>    +#ifdef CONFIG_MEMCG
>>>>> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>>>>> +{
>>>>> +    struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>>>>> +    struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>>>>> +
>>>>> +    rcu_read_lock();
>>>>
>>>> Where is this unlocked?
>>>
>>> The lruvec_unlock_irq() in reset_batch_size() will handle the unlocki=
ng.
>>>
>>>>
>>>>> +    /*
>>>>> +     * The memcg can be NULL when the memory controller is disable=
d.
>>>>> +     * Otherwise, the caller keeps the memcg owning @lruvec alive.=

>>>>> +     */
>>>>> +    if (!memcg || !css_is_dying(&memcg->css))
>>>>> +        goto lock;
>>>>> +
>>>>> +    do {
>>>>> +        memcg =3D parent_mem_cgroup(memcg);
>>>>> +    } while (memcg && css_is_dying(&memcg->css));
>>>>> +    lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>>>>
>>>>      while (unlikely(memcg && css_is_dying(&memcg->css))) {
>>>>          memcg =3D parent_mem_cgroup(memcg);
>>>>          lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>>>
>>> There is no need to acquire the lruvec before finding the first
>>> non-dying memcg.
>>
>> struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>> struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>>
>> rcu_read_lock()
>>
>> while (unlikely(memcg_is_dying(memcg)))
>>          memcg =3D parent_mem_cgroup(memcg);
>>
>> lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>=20
> If the first memcg is already non-dying, there's no need to re-acquire
> the lruvec. ;)

Oh, right :)

Hmm but I still think Johannes' suggestion makes the code cleaner.
Observing a dying cgroup should be rare anyway, it's worth focusing
more on readability?

--=20
Cheers,
Harry / Hyeonggon

--------------ZRX0Bm9osqEOHrx8TlGs75oJ--

--------------5Zw0piV59P0tyDvSf9ksEESi
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaj4HLgAKCRCGXBN6rc5S
1gGwAQDgsTIu64tG5UvWCyfrIv1RVZyVbf0RbKQAyfsnxC9KtwD/T20rBlrqpe+s
utP9zOBgC9FpdJDhK3gMwCVJCJvHsgc=
=ossq
-----END PGP SIGNATURE-----

--------------5Zw0piV59P0tyDvSf9ksEESi--

