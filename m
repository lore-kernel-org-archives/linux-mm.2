Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 657BBC4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 07:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02066B008C; Wed, 22 Jul 2026 03:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8C986B0092; Wed, 22 Jul 2026 03:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55F56B0093; Wed, 22 Jul 2026 03:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8678B6B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:40:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3E3E1203BC
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:40:09 +0000 (UTC)
X-FDA: 85015614138.12.94427E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 52854100003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:40:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wd3Jt86V;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784706008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOWpF0SWGu5KolaqJIGzoxc0o70j8bo0gsvJlnQPkgI=;
	b=bjGhE2Wtbe3V3X4ozbHG0E9Fl29PSx8v1xe4hVR0g2qV7L/aMXAJzWMUR36fTDI1YyFgwN
	byeKIMsXI7UtTuEkopDoKk6NQolUW0JPCUQAEp2bcgHUgkgmJsh9MEXH6XGfiJYSXF8Fu9
	dYPaRYtu+OHmxNaGEV8imgH7Ng28y30=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784706008;
	b=nLHaZ7KpBjJNA8ZtVy0RmSeaSayhemtV12poA/bBtEneowtfCl5LCMurfkiBKMRsNVPbdm
	3X16+0L8oBLM+f2hdVFxcGizTFjCZLjxFtC1qucPaCC1vCaZo5cT2uyLdhGJK/nvggL8xj
	S9Q9jS0R97WYETZsYVZAyd/tzVEkA/E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wd3Jt86V;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB38360A6B;
	Wed, 22 Jul 2026 07:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E341F00A3A;
	Wed, 22 Jul 2026 07:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706007;
	bh=EOWpF0SWGu5KolaqJIGzoxc0o70j8bo0gsvJlnQPkgI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Wd3Jt86Vu53iEttc61YcYnQiAaDSf7xapZZfaILjhiLL6m2B8pGv8pSJC2Uf5svkx
	 CLdz0CIPv6sjynwuf65K4CdVjvdaSzz2AgR6BflE1W4zU8NYmNJR99efOHc06MKsNR
	 F8MgQtsjqVxajUqNz5iilfuisAnH3fjz5j2Ou60sWxVE7Iyq/xgJREpm6Zn/djRrjB
	 r2rFXj+5zWPw59AnDsOknXqCO312vjHc+FkL+hTnPjMD4jzXyP0zH9J9bXL95n6g72
	 WwRj2+3JORAcdQFrN1VtGeKwvBQQnafW4qhinXdDpxURaz5ELpy0FbAk0lAUbpGhZ1
	 LJ+Yr/49wz6cA==
Message-ID: <8d971637-0ba7-41f1-a3c3-13e9e0bf7184@kernel.org>
Date: Wed, 22 Jul 2026 16:39:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next v4 2/8] mm/slab: handle the !allow_spin case
 in kfree_rcu_sheaf()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
 <20260720-kfree_rcu_nolock-v4-2-964e03c41a4e@kernel.org>
 <1d0d8021-62d2-4c42-a2a6-a7e8ce2f5d37@kernel.org>
 <0ce88f37-f231-4a00-b06b-95b0910c2db0@kernel.org>
 <c66cf308-943d-4fc3-ae84-e81bdbb384ec@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <c66cf308-943d-4fc3-ae84-e81bdbb384ec@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------zKUBDNrRhwRulzNhyQZFGYIc"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 52854100003
X-Stat-Signature: a8c5qbhs4o4p4gcane1auttt476rf9mt
X-Rspam-User: 
X-HE-Tag: 1784706008-846037
X-HE-Meta: U2FsdGVkX18VROKos+gR2Jf7wJk3gbeJkz+tztz8GtTBxqXabJxUenNf3E/FRSGaF2i9wJq7qwmX12mm+BcN8h17jQOa6eMP+jgCxT5pS5yB1ySD/wAtZyNLn2lQib6CSFConIl45KD365Qf8GLL76GGkEJjaDj1dKSvWP82QBXGYl+M6kF7QSQ5/zBva0/27P9KHG136IhWvhZSOKYsz+1Fq5rugs4qB/WvZhX4y7xQwTDk2QbSCVAdavfpQU2bcjvI8c8deqNTWeT1cT9fSrNC/XCEA/j4cNU33gfCLjamd9pCmH8y2mfaFrUacb5mLPSQk26Db+qw9fAxPunZf02ip2qPmZRN1iBUoxIpGzCpjZRtQghPlooGe2M9dVo0FE4dpgaKC3S9CgXaaaLr815vC5TIEDs//L4xvf25CIdCeGd6jqvtLfXlBwIDTgUCLDbDDUG8syBklfFp2pjVtFzRkYEaMCrF9eTpiyAye0RTBDTJj16hmIS4fkoiCLcm7luaYLgrfMLEigRkhzX5rTnen634ODA9MSmPmfGuuCFP05bB+SLS1W8THgCbzN7kwAMeFXcXKVbgw1avaQqOxMu/q1O5lAu1W3diS3j/jKbhgS3sSAs2QKN8PGi84B03UxFrygoS1t5z7L5ywBkVuICDCh4tjXse1ZijJRSt9fSqkOSVoNdRPY8b6OFLdlnrQopFD5rJnOnMw0+vBnYU0o/UfXr7Vo6vTr9FTmLlk1JBFIOUlT5vQReo+iZbUdJDdE97sUwuvYgkQSKUgPpWFJXVC8aa0kYnxlAeIsJRkbsRTD6Vjy5V0G8ak4Xlxkrfw+2Zv14h6TI13qBUKXk9uhXeJViR5xeCixlhvGxkUqdeLz+7RT267jHs/+MqcX60WJkJibqVsqBNZEjE1MMS61xe1m3kn4PKYCjDp5CYw5HHQqJ5888Xf4RRoSp6Xo8BhVEbXp3tkqAS0O4DDBq
 8lkUuYMd
 aWGwlIIZePOIr1mBtoKmNkTXUQVoeWKtFcxcls5ZEBdaJuac4haoFljKpNgAKU3aMID3XcSpRJVWdr6mBRL3yhDR1rSjUsas6RpECdee7L3/d8b87ab8sGaaQDUOUg7RKQGSVLEwbvqyuHLsYaZWYqSpYUVawHDT8SIBxGrCKzTreVBTfKnpXsFPAXVFv+foRJ1/2QvjUrrzR9+h32zWAwP1sy1el/yWSVuZ8R2Cm/xIalbxnAYKXOMQ5/Xhz6lRhDTyz3K0MGdLv0zuimwFPl9+ohzaVx5V9YgViGPNbPxXVet+BclFSHvHbIEErxi44V9L1hkakH3/raBQgjz4ClPqmSsTHVt7WLPlfwGLeMUppT5CdLW6rhntz4rDZtYR08miaV+4NG1SGlQTf0xm4zM52EZL8S73D1GeFPKr9TdaLRXo2aJoNdqExlr2aorV3fPAwceEXGwGUdCnXA3/WmL9AdOh7T9tD2JhvlsmAfVxbvp+BPsTlDvXyIVz0AYfpiP5XxlF9QDKYURC51IKD9yd8admwVe+aCj36QhCVMpp6MAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------zKUBDNrRhwRulzNhyQZFGYIc
Content-Type: multipart/mixed; boundary="------------d5K15x0Qu9OuIwg0efEzg03i";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <8d971637-0ba7-41f1-a3c3-13e9e0bf7184@kernel.org>
Subject: Re: [PATCH slab/for-next v4 2/8] mm/slab: handle the !allow_spin case
 in kfree_rcu_sheaf()
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
 <20260720-kfree_rcu_nolock-v4-2-964e03c41a4e@kernel.org>
 <1d0d8021-62d2-4c42-a2a6-a7e8ce2f5d37@kernel.org>
 <0ce88f37-f231-4a00-b06b-95b0910c2db0@kernel.org>
 <c66cf308-943d-4fc3-ae84-e81bdbb384ec@kernel.org>
In-Reply-To: <c66cf308-943d-4fc3-ae84-e81bdbb384ec@kernel.org>

--------------d5K15x0Qu9OuIwg0efEzg03i
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/22/26 4:37 PM, Vlastimil Babka (SUSE) wrote:
> On 7/22/26 09:28, Harry Yoo wrote:
>>> Nits below:
>>>
>>>> ---
>>>>  mm/slab.h        | 18 +++++++++++++++++-
>>>>  mm/slab_common.c |  2 +-
>>>>  mm/slub.c        | 36 ++++++++++++++++++++++++++++--------
>>>>  3 files changed, 46 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/mm/slab.h b/mm/slab.h
>>>> index 281a65233795..85ef2ebc9812 100644
>>>> --- a/mm/slab.h
>>>> +++ b/mm/slab.h
>>>> @@ -429,7 +445,7 @@ static inline bool is_kmalloc_normal(struct kmem=
_cache *s)
>>>>  	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCO=
UNT));
>>>>  }
>>>> =20
>>>> -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
>>>> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned in=
t free_flags);
>>>>  void flush_all_rcu_sheaves(void);
>>>>  void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
>>>> =20
>>>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>>>> index b6426d7ceec9..e07b4e6d6679 100644
>>>> --- a/mm/slab_common.c
>>>> +++ b/mm/slab_common.c
>>>> @@ -1605,7 +1605,7 @@ static bool kfree_rcu_sheaf(void *obj)
>>>> =20
>>>>  	s =3D slab->slab_cache;
>>>>  	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) =3D=3D numa_=
mem_id()))
>>>> -		return __kfree_rcu_sheaf(s, obj);
>>>> +		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
>>>> =20
>>>>  	return false;
>>>>  }
>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>> index e32a68677537..0c350274fbff 100644
>>>> --- a/mm/slub.c
>>>> +++ b/mm/slub.c
>>>> @@ -2814,10 +2814,14 @@ static inline struct slab_sheaf *alloc_empty=
_sheaf(struct kmem_cache *s,
>>>> =20
>>>>  	gfp &=3D ~OBJCGS_CLEAR_MASK;
>>>> =20
>>>> +	if (alloc_flags & SLAB_ALLOC_NOLOCK)
>>>> +		gfp &=3D ~__GFP_RECLAIM;
>>>
>>> So in general we expect gfp and alloc flags to be compatible and warn=
 if
>>> they are not. This now performs an auto-adjustment, which makes it un=
usual.
>>
>> That's fair.
>>
>>> But AFAICS only one caller relies on it - __kfree_rcu_sheaf(). So may=
be we
>>> could just do it there?
>>
>> Will do. I don't have strong preference on this.
>=20
> Thanks!
>=20
>>>>  	return __alloc_empty_sheaf(s, gfp, alloc_flags, s->sheaf_capacity)=
;
>>>>  }
>>>> =20
>>>> -static void free_empty_sheaf(struct kmem_cache *s, struct slab_shea=
f *sheaf)
>>>> +static void __free_empty_sheaf(struct kmem_cache *s, struct slab_sh=
eaf *sheaf,
>>>> +			       bool allow_spin)
>>>
>>> Why not free_flags instead of allow_spin? Since you already introduce=
d them.
>>
>> Indeed I tried that but gave up on doing that as part of series
>> after realizing free_empty_sheaf() alone has 12 callers :)
>=20
> Yeah but I meant __free_empty_sheaf() only. It's fine to leave the wrap=
per
> without the new parameter for the most common case, like you did.

Ah, I see!
Right, that's reasonable and will do.

>> But I think it's worth teaching those functions (including
>> free_empty_sheaf()) to handle SLAB_ALLOC_* and SLAB_FREE_* flags
>> rather than propagating allow_spin.
>=20
> It doesn't have to be now :)

Yeah :)

Thanks!

--=20
Cheers,
Harry / Hyeonggon

--------------d5K15x0Qu9OuIwg0efEzg03i--

--------------zKUBDNrRhwRulzNhyQZFGYIc
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCamBzygAKCRCGXBN6rc5S
1mj6AQCEDuXSXD84vwoWMnvh3SAH6pQ7Ngs8xt8xR+bK8mwudgEAue6ODAgbBFy7
JAlMoRPioGz3QAzAlg9IcFHlo0egHwM=
=MCiF
-----END PGP SIGNATURE-----

--------------zKUBDNrRhwRulzNhyQZFGYIc--

