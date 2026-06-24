Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14077CDB470
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 04:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3516B0088; Wed, 24 Jun 2026 00:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B944D6B008A; Wed, 24 Jun 2026 00:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83006B008C; Wed, 24 Jun 2026 00:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71F9D6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:30:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF778120213
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:30:09 +0000 (UTC)
X-FDA: 84913528938.18.623B73F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id F12AC18000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:30:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CVZbVwtt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782275408;
	b=wFvuKU7ALdi2wpotqm/mS0p2/PmRkI+eycucxvgSGYjrLC4Oq23Osmc0J2fc96be8KKRpW
	cl0XPfry7Dm8SNXzca9L3mQB8qWvc2nePSnCUkPFmAn48qEGDApLck4IdEe63FyBqWWcCs
	QzhG46YLoWtcix5jGYLTJ2cgN89hxwA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782275408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bx/kebHPPgs2d60g6aifmIll7j/E5MvaYrxUaKwgJoE=;
	b=XvWZZ3phHt4aV7xbqARjEHwrUIaEbn9Y+jFeA1+2SEkXKA4BERiMu9rE1y0Vdp+1gTmqhR
	saHHjl3qrfVEcFWoLBN0cNZ8i47HAhbU3VgWUbVKADuMdVQocsbEBh1aA9tXag7nktRE14
	BpjZVrUWRsXYhH2Sq/90hVP1u2cXKQg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CVZbVwtt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBC4642B99;
	Wed, 24 Jun 2026 04:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6E41F000E9;
	Wed, 24 Jun 2026 04:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782275406;
	bh=Bx/kebHPPgs2d60g6aifmIll7j/E5MvaYrxUaKwgJoE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CVZbVwttm33JAE2R5U+7rIIovPr+pcOzHmnUiYpLBy+hKo+eomEmEpVRViqMBUftD
	 DquBiOLUzumiPCVhuOEw/HomSr+u+fomZqF7Nii8DBIyXxSO1ivA2HmrO4QHSDKYtm
	 5fErW3qpg9A18UgVUnqQQbsOTSrX3+5OX26PG9Lm6GWmL1AVxrDmGz4lKYwU3O/1Bz
	 Byb0EebmigTmmE+M3bDrccOMB71XVXQ5cAazxOn91qxuvrVRQ4pRU2iiEHDSh22d0X
	 NX65MrUsL3EY8aphU06Qguv+oesGp5b1LVe0KCQdX7i1y9FKV0pw2cMoBipVAwQzpH
	 bHR+8sGjQLpoA==
Message-ID: <dfe5d773-2992-448b-a6cb-ef633714a08f@kernel.org>
Date: Wed, 24 Jun 2026 13:29:57 +0900
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
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <7946da94-dc1d-4cf2-986e-466c378665b6@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------uturwecWcQieFOXdAi39JCaI"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F12AC18000B
X-Rspam-User: 
X-Stat-Signature: j16egp5zffogqrrjcmzzez7ireimc49p
X-HE-Tag: 1782275407-760970
X-HE-Meta: U2FsdGVkX1/8yTvSvidK6d/84IzEJxDL3yHJzF5Nxyly3uwBnuHEf4kvbq502IeQQZK1eV5kNpouSJW3XUkHwIGISTD8cFu64VD50buCZKZAOpRNk/bE9+0844RISqGab0SL01WJ/5pK5JIK/6U7mOJns44+ilMXoCQ8lsUmEHk9e9FqhzvdzOTfS47zBiFILCfgfm6ubrqC5CYEc0ptUrX8wD7XX422AOZTjZpYUmASGHOFNnFmjzec/eFSBuGI7ZUQtKUAFK65JlsMZbbhLzG0mDplI4c/QQl/5Xj/jV26pm7rV3+Kw85i/GFu7PDVyjfvtt80SxpmfXo7ccVQT6fjRaMHUvPmRDvx/zf9DubbtJObmmwGOCdiCYxr6fi1zTLF90/0NuQx1g+Q0ZQGfXsmpr0ZTv18Csd9YyDNc2j7HhrKHw5IOTyUssCS4mXx7b23fWXSVRmE8VZAJ5fzRErZUSRiBV+KfBe4WdaZ1/BClJjGwnepLOL3oV7hCDn2alzorW4pdr844DVJXKQYmXa485wuMDMaOq8BT5URBIj74CvDQFsPTH2aAVb4/TBd6/gGsVJBpFepu0FwCZlobk5Eh5pJNyxRNkZcWyMbD2FN+mY2DKzrj9QwwFv3Sdoog/uE8iOrliY41A+FvXj+B6Rqjek8hjEinsFUCmOrp3xCssYPdF3F0LW5llb2f3vAFFlFRu2QW+IR99A5WvKTiJ10Fh2LDmxNGlX7Cars0vvNeFTJZCD9v9bNtS5QWIPnax5QkTULg5dEBA0grgMtd3REufGO3lelBd4XY+xm0Rg6gWUy1YterKjcAv2k4TcsokaLE3YWfNGsggUqnzFZtcWEyIN629rdsnT3VUBI4inntayhb+FkVZXOGxsphuh12fxVoho48E0Z24k0b3nDwbbHcPHT9xpjuLc9n7ZTqohSIgCJUJasiXhGEMRaa5eokaDx5sJ/49ETJHjIkLK
 qxdp3pZe
 DWiQJlpb/+Cbe/U/L7Q4MOdY/GC27OAuQpYb0CGZsLKtb1n0D/KEwsK0cg+E7czmxJFFnlbZ1KOnEVL0pdjTk8qReVzpIH3NndXYtTs248enjDUnG7weaav5PxjTsv/rHPt2/fIvM/DuGnSEpST8LayzTmAarr6vkvEGuFUaSQJANBxjUo01CRgkLZBoQREoDOmuDMOnh96qGS6Y7+6NlLesG1puWcYiRPJXul6cDSYhE8mWBc56tSSdOBXvQ9ZJm1atDqTV5QRNYv3f3FUGirEEVWu9oBHVO4FeZ8w4I8Uqaf1NlDd0mi1PgKZxgIhF1CbiQlTENNc1F+nHv03gqO2OYajA2YErG3zDpQQDcn27HPhwmYVTC+2tj0gY6qt47lwrGitZR6o4AfPIkJzI8UwDMexqAO4h69yzlrIJ29g5fQjbQs2pDZjkMHWK7pw4BMTnH4nmvXFvqtI8ctEXfcWuRDd7Eijx7Gv/C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------uturwecWcQieFOXdAi39JCaI
Content-Type: multipart/mixed; boundary="------------6zyhzDgflNVOdEnJMoPRLwzN";
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
Message-ID: <dfe5d773-2992-448b-a6cb-ef633714a08f@kernel.org>
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
References: <20260623024237.45990-1-qi.zheng@linux.dev>
 <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
 <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev>
 <8a76aefd-629c-41f3-b365-aefd4cc1411e@kernel.org>
 <7946da94-dc1d-4cf2-986e-466c378665b6@linux.dev>
In-Reply-To: <7946da94-dc1d-4cf2-986e-466c378665b6@linux.dev>

--------------6zyhzDgflNVOdEnJMoPRLwzN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/23/26 6:14 PM, Qi Zheng wrote:
> Hi Harry,
>=20
> On 6/23/26 4:18 PM, Harry Yoo wrote:
>> On 6/23/26 4:16 PM, Qi Zheng wrote:
>>> Hi Harry,
>>
>> Hi Qi!
>>
>>> On 6/23/26 2:17 PM, Harry Yoo wrote:
>>>> On 6/23/26 11:42 AM, Qi Zheng wrote:
>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>
>>>>> The mglru page table walker batches per-generation size deltas in
>>>>> walk->nr_pages while walking page tables without holding the lruvec=

>>>>> lock.
>>>>> The reset_batch_size() later folds those deltas into walk->lruvec
>>>>> under
>>>>> the lruvec lock.
>>>>
>>>> Ouch.
>>>>
>>>> IIRC the user-visible impact of underestimated nr_pages in MGLRU
>>>> was premature OOMs because MGLRU does not try to reclaim memory when=

>>>> nr_pages reaches zero, but there are still more pages.
>>>>
>>>> Perhaps worth mentioning in the changelog?
>>>
>>> Maybe this should be placed before "To fix it...".
>>
>> Thanks!
>>
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
>>>>
>>>> The problem here is that, while grabbing a reference to memcg
>>>> (via mem_cgroup_iter(), for example) makes sure that the memcg is no=
t
>>>> freed, it does not prevent offlining happening, and reset_batch_size=
()
>>>> doesn't check whether the lruvec has been reparented, or the lruvec
>>>> is going to be reparented.
>>>>
>>>>> This will trigger the following warning in lru_gen_exit_memcg():
>>>>>
>>>>>      VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>>>>>                     sizeof(lruvec->lrugen.nr_pages)));
>>>>>
>>>>> To fix it, add lrugen->reparented to remember the new owner of a
>>>>> reparented lruvec, and make reset_batch_size() charge pending
>>>>> deltas to
>>>>> that owner.
>>>>
>>>> Could you please explain why it is unavoidable to introduce the new
>>>> field and why checking whether the cgroup is dying (and charging del=
tas
>>>> to non-dying parent) doesn't work?
>>>
>>> Peiyang tried doing this [1], but it doesn't work because
>>> ss->css_offline() is called before clearing the CSS_ONLINE flag.
>>
>> Right.
>>
>>> I also considered using mem_cgroup_tryget_online(), but that only
>>> prevent
>>> the memcg from being freed. It's doesn't prevent the offlining.
>>
>> Right.
>>
>> I think checking CSS_DYING under RCU and grabbing the lruvec
>> of the first non-dying memcg should work (this pattern is already
>> used where we use RCU to guarantee memcgs are not freed).
>>
>> If we do not observe CSS_DYING flag, it is safe to charge deltas
>> to the lruvec because RCU guarantees that reparenting cannot happen
>> under us.
>>
>> If we do observe CSS_DYING, we can walk up the hierarchy and charge
>> deltas to the first non-dying memcg.
>=20
> Checking CSS_DYING looks feasible, but the rcu lock alone cannot preven=
t
> reparenting. We should recheck CSS_DYING after acquiring the lruvec
> lock, otherwise we might run into the following race:

Haha, actually, I was thinking of checking CSS_DYING under both RCU and
lruvec lock. (because that's the pattern)

>   CPU0 reset_batch_size              CPU1 memcg teardown
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D      =
        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>   read !CSS_DYING
>=20
>                                      set CSS_DYING

Oh, I thought the entire critical section is covered by RCU.
(I see lock_batch_lruvec() you suggested below doesn't do that)

Isn't RCU enough to prevent reparenting because RCU guarantees that
all readers who read !CSS_DYING complete before reparenting?

Now I'm confused. Is it strictly required to check CSS_DYING under
lruvec lock? CSS_DYING is updated outside the lruvec lock anyway?

>                                      memcg_reparent_objcgs()
>                                      lock child lruvec
>                                      move child to parent
>                                      zero child nr_pages
>                                      unlock child lruvec
>=20
>   lock child lruvec
>   charge stale delta to child
>=20
> So it seems lock_batch_lruvec() should be implemented like this:
>=20
> static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
> {
>     struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>=20
>     rcu_read_lock();
> retry:
>     while (memcg && css_is_dying(&memcg->css))
>         memcg =3D parent_mem_cgroup(memcg);

Isn't this loop unnecessary as spin_lock_irq() -> check CSS_DYING ->
goto retry does the same thing? (of course, we need to fetch the parent
memcg before retry then...)

>     lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>     spin_lock_irq(&lruvec->lru_lock);
>     if (memcg && unlikely(css_is_dying(&memcg->css))) {
>         spin_unlock_irq(&lruvec->lru_lock);
>         goto retry;
>     }
>=20
>     rcu_read_unlock();
>=20
>     return lruvec;
> }

Thanks!

--=20
Cheers,
Harry / Hyeonggon

--------------6zyhzDgflNVOdEnJMoPRLwzN--

--------------uturwecWcQieFOXdAi39JCaI
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajtdRQAKCRCGXBN6rc5S
1mQJAQCZYifwIBTlnCeUcd03aopvWuwmzmAOsss6kYgehOkUVwD/ZlbG/Gvdr702
Qh5RSIeU+ZTGtg5iX6Bl3y1ErVbhfwQ=
=8thM
-----END PGP SIGNATURE-----

--------------uturwecWcQieFOXdAi39JCaI--

