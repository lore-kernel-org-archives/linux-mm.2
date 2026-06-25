Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80761CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 04:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F896B008A; Thu, 25 Jun 2026 00:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457D06B0092; Thu, 25 Jun 2026 00:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E016B0093; Thu, 25 Jun 2026 00:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02A796B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:16:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 666711A054F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:16:30 +0000 (UTC)
X-FDA: 84917123340.05.35DF772
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B5B4440007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:16:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FpHe8Xbp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782360988;
	b=TJ8XLcXxJeFenArwzvfAs7LlSEf/q1irNRFd9FHugpcYkOfUxS5O9dqLtzUegX0IOCWmhf
	+2CJ5t5ghojH/OG03BbFXh3WANxsqvhKXtm99VWquFzf1Kd9crsVtdmCmXoklozg+0ZPO+
	MV1yOGKtD9PEgn/CLrIP19pMxYqGtWs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782360988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AiN5oVYDkvToeVAoDXhpX8L4SOwM6hG76+pNbHn5Akw=;
	b=MpwJZBm9qysC3woz00zdjec9zwLd88fIbcqbczmLA3cX74RVVjyA0lTH3t0QxYkEuWKeSU
	z1hxYgawV9U7ssTqcllcI76DhmSglVyoAozO4lSSvyRSQSbBSDoVb3NwGg0WpxCjYIo6+f
	+8qtraKbsh6B2kWRpUIS5pt+waqcHyE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FpHe8Xbp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B7A260018;
	Thu, 25 Jun 2026 04:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D112E1F000E9;
	Thu, 25 Jun 2026 04:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782360988;
	bh=AiN5oVYDkvToeVAoDXhpX8L4SOwM6hG76+pNbHn5Akw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FpHe8Xbp6Y5I74KzZO+2qeKc73fP1HBUFJJa0yWbRlq5rqQ5FaHySku1wSFlFUASU
	 7Uzhxaxbpiq6I8j1tzpjuZS+vvK2FX2V8VuzCwPdrpabgSo4g8EljSeL3WpVNdwH5i
	 FZDO+1ZhgCkbKTEomAjhYsb47sa/vleBuXCsoIWmp1KeiX5UQQCw6JB/WG1TpoW3t7
	 HHWs4rPIjqIidmejtqa9TH++f0BZz9AuatlL+x+j7QgqLXXurb1tIpAmdAGBsylh/i
	 fYuLgaYUodk/EpOfStrc43GPtbfXPXlCxr+66oGupfIN8kT6nnlH0EO0AkeXrB1Wmt
	 khUS/Ec1AtOPg==
Message-ID: <b5c85cea-5daa-4690-ac41-a6f5aebd1555@kernel.org>
Date: Thu, 25 Jun 2026 13:16:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260623024237.45990-1-qi.zheng@linux.dev>
 <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
 <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev>
 <8a76aefd-629c-41f3-b365-aefd4cc1411e@kernel.org>
 <7946da94-dc1d-4cf2-986e-466c378665b6@linux.dev>
 <dfe5d773-2992-448b-a6cb-ef633714a08f@kernel.org>
 <1d638906-6d64-4e57-a181-4b77683652b5@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <1d638906-6d64-4e57-a181-4b77683652b5@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------LxQQ5OPbtD0ywAOp0mjeioxs"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B5B4440007
X-Rspam-User: 
X-Stat-Signature: fpm69g9x9j4o1ttbt78rhgj6usqxmd63
X-HE-Tag: 1782360988-758187
X-HE-Meta: U2FsdGVkX1/9LAEKPg7Sg/zJhDzOgnVtU5a66uLkBHRinrauWbGkuKFyq69D9UHZVkZGLv5psNINXdIXkrkePDjhREXhsHowlO9Am4sDLNCNVdEuTLdzxxdA5KZtocIxS9aCcRxyf6yYz45Vw8pNVDu8QvEpncrFrvJDHNVM2HrGoijlTb/NKayWyiRa9ksuQ8ISV2DFJAxsDPUqjIU4t4x3sMOecB6Egv3fMnOIQVxQcES0ZPv9W0WDTdIFqmVq9VexjBczhK5ELozq9dPQkl3SkLWdj5y8Txg5WzvxALWs+1lqFdAU/ObT07drU7EuFX4WWIASir6KTJ5ALfqDUFN9c90HBSrZwWLEpatO1Rxy0bEcMVlgQHMcSkKIjuc4oG0KptdHftRvPtmaSDT3xZLufcrNDdRgUZSSaHM999wqUPEDUBbmPg8MLzGPQKjXRnupgGKaPos7q63QTauk3VZHPjxZ5dTXlcnZ1xVQ3vO6KqjULrYdFaHwUzqWpC/bg1I/n047tC2o4Y2eFy6T0muE4wVGHvy0GAoI8em/VmBmHHJ1i9qWM9QF9M4w7PNz8SaI4HXo4LKE6uMtJE7hN/uX8uNzVgq29E4xE4/bMNHC2CoUumdDWyP3ygv9WLIp+TT59qUBr+ZFaRkY8yurW5B/DhDUWCy1AEb2xiVtoae/7TSHYW6b4wATkhWN/pAmriLtFcT8x2PI65hH/SRW4dBm+tuUFXlSt3kLaBdW9n97lRo3XFZD+HwL1KHU2xAGBk97RX5gJYqJdKSN29TeHOGEKlHT3340qB9tRS7rzAM2w/4EHOJIDPxd/vanpIPJ12vjG9CE/3LgILMboKe+/FuvcNSHXUIdkWD7A8gV3+iCtWK18YW5YjXbgG55UCVdYjBvQi3uLBaFd/6Il3SUzfbaNtqyZvoxpVz3Luw07l14nzgyE25PRZTTMEssklEd7eI4nElSY2T7BvhGP8Y
 JBW7y4cH
 iRzItQYalFP3Vvm0P//fFDFGZQcv3oOKPM8lhTv1YB/7G7Qml/AECterT/uCT2V4zpshSnwHcd3W1bymMSGt0vbfkuWbejY7ofR0fFPEJmCxNHXrrYh5YRa6sx1DRAnT4P6KQeYGZMBaZu8GJHzN1V10pjUta3HnKPxYKsVxy9/+FsQB0vNsQswXbRiqFXkPTYwpdBYYfunlR7J4fOGum+PhGMfSK+LTT3Ap+uAu9wI9NPh9gV1tj2A0eoKy/o/+06cup/gahvn44I8KtA83ThzncDpsfOrWJWkvCxyoAulgUuza9NRFRbjHJdlQG2Gq71vXE4boHSgSP+/nfs8I8tDUyVvBRfN3rSzY1NgZggRSNpyoRRr6GfKpMNn0A/rlK5MFkCC2T82l+tT1VCqPsqaa4CR5KnWY0iqAvOaY5UUsgeKdTUn051sFgHYakGL2mAgJfM/K+k4DpaxF/m4TKIl3ilOf9bugJx2J+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------LxQQ5OPbtD0ywAOp0mjeioxs
Content-Type: multipart/mixed; boundary="------------06RF0h870Fk6SH6J3RTvV02N";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Message-ID: <b5c85cea-5daa-4690-ac41-a6f5aebd1555@kernel.org>
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
References: <20260623024237.45990-1-qi.zheng@linux.dev>
 <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
 <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev>
 <8a76aefd-629c-41f3-b365-aefd4cc1411e@kernel.org>
 <7946da94-dc1d-4cf2-986e-466c378665b6@linux.dev>
 <dfe5d773-2992-448b-a6cb-ef633714a08f@kernel.org>
 <1d638906-6d64-4e57-a181-4b77683652b5@linux.dev>
In-Reply-To: <1d638906-6d64-4e57-a181-4b77683652b5@linux.dev>

--------------06RF0h870Fk6SH6J3RTvV02N
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/24/26 4:11 PM, Qi Zheng wrote:
> Hi Harry,
>=20
> On 6/24/26 12:29 PM, Harry Yoo wrote:
>> On 6/23/26 6:14 PM, Qi Zheng wrote:
>>> Hi Harry,
>>>
>>> On 6/23/26 4:18 PM, Harry Yoo wrote:
>>>> On 6/23/26 4:16 PM, Qi Zheng wrote:
>>>>> Hi Harry,
>>>>
>>>> Hi Qi!
>>>>
>>>>> On 6/23/26 2:17 PM, Harry Yoo wrote:
>>>>>> On 6/23/26 11:42 AM, Qi Zheng wrote:
>>>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>>
>>>>>>> The mglru page table walker batches per-generation size deltas in=

>>>>>>> walk->nr_pages while walking page tables without holding the lruv=
ec
>>>>>>> lock.
>>>>>>> The reset_batch_size() later folds those deltas into walk->lruvec=

>>>>>>> under
>>>>>>> the lruvec lock.
>>>>>>
>>>>>> Ouch.
>>>>>>
>>>>>> IIRC the user-visible impact of underestimated nr_pages in MGLRU
>>>>>> was premature OOMs because MGLRU does not try to reclaim memory wh=
en
>>>>>> nr_pages reaches zero, but there are still more pages.
>>>>>>
>>>>>> Perhaps worth mentioning in the changelog?
>>>>>
>>>>> Maybe this should be placed before "To fix it...".
>>>>
>>>> Thanks!
>>>>
>>>>>>> The page table walker can run concurrently with the memcg
>>>>>>> reparenting
>>>>>>> path
>>>>>>> as follows:
>>>>>>>
>>>>>>> CPU0                           CPU1
>>>>>>> =3D=3D=3D=3D                           =3D=3D=3D=3D
>>>>>>>
>>>>>>> walk_mm
>>>>>>> --> walk_page_range
>>>>>>>        --> update_batch_size
>>>>>>>            --> walk->nr_pages +=3D delta
>>>>>>>
>>>>>>>                                  mem_cgroup_css_offline
>>>>>>>                                  --> memcg_reparent_objcgs
>>>>>>>                                      --> lock lruvec
>>>>>>>                                          lru_gen_reparent_memcg
>>>>>>>                                          --> reparent child
>>>>>>> folios to
>>>>>>> parent
>>>>>>>                                          unlock lruvec
>>>>>>>
>>>>>>>        lock lruvec
>>>>>>>        reset_batch_size
>>>>>>>        --> child lrugen->nr_pages +=3D delta
>>>>>>
>>>>>> The problem here is that, while grabbing a reference to memcg
>>>>>> (via mem_cgroup_iter(), for example) makes sure that the memcg is =
not
>>>>>> freed, it does not prevent offlining happening, and
>>>>>> reset_batch_size()
>>>>>> doesn't check whether the lruvec has been reparented, or the lruve=
c
>>>>>> is going to be reparented.
>>>>>>
>>>>>>> This will trigger the following warning in lru_gen_exit_memcg():
>>>>>>>
>>>>>>>       VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>>>>>>>                      sizeof(lruvec->lrugen.nr_pages)));
>>>>>>>
>>>>>>> To fix it, add lrugen->reparented to remember the new owner of a
>>>>>>> reparented lruvec, and make reset_batch_size() charge pending
>>>>>>> deltas to
>>>>>>> that owner.
>>>>>>
>>>>>> Could you please explain why it is unavoidable to introduce the ne=
w
>>>>>> field and why checking whether the cgroup is dying (and charging
>>>>>> deltas
>>>>>> to non-dying parent) doesn't work?
>>>>>
>>>>> Peiyang tried doing this [1], but it doesn't work because
>>>>> ss->css_offline() is called before clearing the CSS_ONLINE flag.
>>>>
>>>> Right.
>>>>
>>>>> I also considered using mem_cgroup_tryget_online(), but that only
>>>>> prevent
>>>>> the memcg from being freed. It's doesn't prevent the offlining.
>>>>
>>>> Right.
>>>>
>>>> I think checking CSS_DYING under RCU and grabbing the lruvec
>>>> of the first non-dying memcg should work (this pattern is already
>>>> used where we use RCU to guarantee memcgs are not freed).
>>>>
>>>> If we do not observe CSS_DYING flag, it is safe to charge deltas
>>>> to the lruvec because RCU guarantees that reparenting cannot happen
>>>> under us.
>>>>
>>>> If we do observe CSS_DYING, we can walk up the hierarchy and charge
>>>> deltas to the first non-dying memcg.
>>>
>>> Checking CSS_DYING looks feasible, but the rcu lock alone cannot prev=
ent
>>> reparenting. We should recheck CSS_DYING after acquiring the lruvec
>>> lock, otherwise we might run into the following race:
>>
>> Haha, actually, I was thinking of checking CSS_DYING under both RCU an=
d
>> lruvec lock. (because that's the pattern)
>>
>>>    CPU0 reset_batch_size              CPU1 memcg teardown
>>>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D   =
           =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>
>>>    read !CSS_DYING
>>>
>>>                                       set CSS_DYING
>>
>> Oh, I thought the entire critical section is covered by RCU.
>> (I see lock_batch_lruvec() you suggested below doesn't do that)
>>
>> Isn't RCU enough to prevent reparenting because RCU guarantees that
>> all readers who read !CSS_DYING complete before reparenting?
>=20
> Oh, I think you are right.
>=20
> I forgot that offlining is executed in the rcu work context.

It's confusing :)

> Let's walk through this again:
>=20
> cgroup_destroy_locked
> --> kill_css_sync
>     --> css->flags |=3D CSS_DYING;                    1)
>     kill_css_finish
>     --> css_killed_ref_fn
>         --> css_killed_work_fn  <-- RCU work !!     2)
>             --> offline_css
>                 --> reparent memcg
>=20
> So while holding the rcu lock, if CSS_DYING is not observed,
> css_killed_work_fn() will not be called until rcu_read_unlock().

Right.

> So lock_batch_lruvec() can be implemented like this:
>=20
> #ifdef CONFIG_MEMCG
> static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
> {
>     struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>     struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>=20
>     rcu_read_lock();
>=20
>     /*
>      * The memcg can be NULL when the memory controller is disabled.
>      * Otherwise, the caller keeps the memcg owning @lruvec alive.
>      */
>     if (!memcg || !css_is_dying(&memcg->css))
>         goto lock;
>=20
>     do {
>         memcg =3D parent_mem_cgroup(memcg);
>     } while (memcg && css_is_dying(&memcg->css));
>     lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>=20
> lock:
>     spin_lock_irq(&lruvec->lru_lock);
>=20
>     return lruvec;
> }
> #else
> static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
> {
>     lruvec_lock_irq(lruvec);
>=20
>     return lruvec;
> }
> #endif
>=20
> Does this make sense?

Yes, looks good to me!

--=20
Cheers,
Harry / Hyeonggon

--------------06RF0h870Fk6SH6J3RTvV02N--

--------------LxQQ5OPbtD0ywAOp0mjeioxs
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajyrkwAKCRCGXBN6rc5S
1oqlAQDfPXFk35QdbxUI3Bm7GIChdTiZa17jWOW965OuLuKNPgEAiwRuBaHrZiUM
mfCqJuZfGYrjhjtTFkDDPZtk9GBpGwg=
=qcnt
-----END PGP SIGNATURE-----

--------------LxQQ5OPbtD0ywAOp0mjeioxs--

