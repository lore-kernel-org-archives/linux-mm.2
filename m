Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE25C4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 07:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0CB76B0088; Wed, 22 Jul 2026 03:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE34D6B008A; Wed, 22 Jul 2026 03:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BADE36B0092; Wed, 22 Jul 2026 03:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85EEE6B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:43:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0EA151403A3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:43:03 +0000 (UTC)
X-FDA: 85015621446.10.18262DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 56B8E40002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:43:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ebWyYhT/";
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784706181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8U9RMhwokOKMZq1o2LzyxZKmoBd6qWII0YPk4ynCuMU=;
	b=ATdUQEwlUKnQFjmP4MgFqxf+6/nPM2UnyTxt9e2X6nQ9Dlt3a7fgeThGnqpoNSJmpfiY7I
	ehtsdMHFdA1pfMFCHbEvJFKwiBaF8Oj7RFrSyocv457UCMdv8r7jD7b1rpYJqxnFd0hrl1
	4SsZbb7t3BtgQWUxpM2XvD3ABthE56g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784706181;
	b=Ro1RLX/x9PJ98/q1iShD8m+iYB39INKFKnyCy8qMnw1WBXFnQ0ED7R2SCkzKeaOEAnYFeP
	sQOdztTcDEzzA7mav67rkB0074tz2nWajLCFGyI7ZCiUcURVbVjqJ7N/O+hVmL0m9omU9Z
	H6w/ZWcMxGDgMNhiv3kURL/65EIvMpU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ebWyYhT/";
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1068843F1D;
	Wed, 22 Jul 2026 07:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA451F00A3A;
	Wed, 22 Jul 2026 07:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706179;
	bh=8U9RMhwokOKMZq1o2LzyxZKmoBd6qWII0YPk4ynCuMU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ebWyYhT/wa2nWhacIPmvVJQzvzTXDlVJ96VITfDN5Jjar/Caw0wg39bD1SP1dKETX
	 gGcHws7ZzFTjOFv+WW1+UFwXcy/bKZuB6kT8vrqVnB1/hYEvv+DhfxQgk/SP1G2wDH
	 wPuaQcAKsmxLYHm10IedGfP258I1sqRRe9Lj2ruUgnqQfxJzubsXEKIixVMVA6myJU
	 5+EJyrg4BqYBwBtkMyoW/nP05SP/0jNrbNhAcNyCBfScuAxAHdBq++BKNbolsm52J8
	 vmmE+RXFBXJ3DLnflfRNGs4en5imzeBWwGyJG+GSj+lizYX7FOQBI6pM/9dkHJ3S6v
	 ICu/hNLhR+81Q==
Message-ID: <29fb9c96-5685-4974-afe5-c76f48eeba45@kernel.org>
Date: Wed, 22 Jul 2026 16:42:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next v4 6/8] mm/slab: introduce struct
 kvfree_rcu_head for kvfree_rcu batching
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
 <20260720-kfree_rcu_nolock-v4-6-964e03c41a4e@kernel.org>
 <cd11b015-7c59-4ce4-8eb0-8040fbb2cdfc@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <cd11b015-7c59-4ce4-8eb0-8040fbb2cdfc@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------rHmQ19i50j0kL2o2vIw30Byv"
X-Stat-Signature: 1x3afc858iyjtgmyfjuwpxn334gnuqoe
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 56B8E40002
X-HE-Tag: 1784706181-22164
X-HE-Meta: U2FsdGVkX19SXso4v+MgdaX0OkuQw4OZLuXmvDs7D8IEjXOZ/W6ECUnCzICvADJ+hIsHefqnkqAsBBri7LMGgpFozYmnVub/WGzjQ5OkMAH+lHslilkquH6L/WQN/kePWzlA3pSXsaETdA7QmWxMCJJ8uabEdfnNH+bj8tZktiXjG0i2HS44pogriUc2F6yefmFLzGYpqkGV2Q5ziLCxHTBj8trcl6Xl0Le92kh7nuFkpgGtboDqOXo8lm0NWTIN2g9C+rwhbnj6zB2/1zJy+19QD+kGA6aCe1rKZyAOKOLk/M6/PmHwKeD4MA9g/aeQADEvFNB5ufur8uxC6nrEVl4LX4Z1O1wxs31mwqEnPCUVkhIszCAxbOvSGJTB+njXhS+ZVZ5UPY/4oqOj/iYnA8dZmbIfo/d9q+YmYsn9UM7qZEwZ5NX6GvPmva/NB7zEqcyHci+dVp9sD8JFiRQUebGpXwUqwpVQ/h5oz3QkKf2oJvnA53rJDszZCo7f6EfUg4bR2TJAkQAUqJthNXZ+zl77abTIGLxtRmdtd1ot4R5COvafkqUXtG3/TFMD/ny2T8dMRVfx/B5J7zOxGnsnVNksa8xMpfZCHSyT7/jshYhdBnh9c+9VL8RO4TjuSYCfqodAT1yVyKtWSI3K4Hg037dl8I5EHvBSQOSVqvsSMkaRIkVKvR7I7RUcYBuZJbWTNTRAeFoXD5aZyWh+ufZzJrWvUq1B3q8tJ+m5ab3moxTwIyBNVVLBfvWuemB+8aRtAkd6plvpAC3BidkcsPSvkOx/bDGZfU/07LaIxucnW9dY2mGrHTEN9mxKJmcaApqzWPkZGUctE8XZCeagMLbTeJHprV1W0BzHLXyb5efTEqLeYwMVRsjfG2h2cO117jR5mQAHqm9rRDHQfwZ/zfbBBwl9uu2Mv2DaZWUBqml6yowklOkHZk3RRNsYcyfjXi+v50mZL8eTmz6R/3hxXgo
 SW6gBMTA
 LwctgH3bnUCeVE/jx1oZl9wRKCGil18aANwN8udMYRQGgj/RF3ymHJdbSQ8Cj6hU0OjmTNBi1lx1TQvrBd6woU/rokM4uxs0Qpr1h7bG3AbO9Nyz3nE24noauyofRptN3p5OJD1BOX96VZ94sjHAnhjViVapioDrf4XiACHRZ5vMOg/08OtG9305xBNNCKQz7N/++jPAcph2pE6yMIWUjZBzWkkRsTX2BrFt/ekvN9Bn4CtDx9bdK0Y+ZUpAI8ujv0ekuDJSNpaBecM0eEOo6meGCEFXswcRa3YLNc6DKBDgLk25cqqCJry4HY8F3LKstyBK7s0GKQuJ1iuK0ACNOTJMakqvqV+zcOtCU3vyzVCg5xINPKIqTWfZ3zkp3z0cHtCW/rFlDfP46XIwGGuSAYIOGaYo4G/fscwAdL73m0TwmIBfhDODMWMY0rmqv+dzrpzOLzRDtvE7ruhuiQbX+JHvSQE/eOnLZ0apheMD5RrnKoqYyQ7+2/GBuVgkuqul4uPAuOXEkGvOFoAj2GW6Yt+7qaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------rHmQ19i50j0kL2o2vIw30Byv
Content-Type: multipart/mixed; boundary="------------77Phiovz4D8FAfavJFkTxfks";
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
Message-ID: <29fb9c96-5685-4974-afe5-c76f48eeba45@kernel.org>
Subject: Re: [PATCH slab/for-next v4 6/8] mm/slab: introduce struct
 kvfree_rcu_head for kvfree_rcu batching
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
 <20260720-kfree_rcu_nolock-v4-6-964e03c41a4e@kernel.org>
 <cd11b015-7c59-4ce4-8eb0-8040fbb2cdfc@kernel.org>
In-Reply-To: <cd11b015-7c59-4ce4-8eb0-8040fbb2cdfc@kernel.org>

--------------77Phiovz4D8FAfavJFkTxfks
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/21/26 8:06 PM, Vlastimil Babka (SUSE) wrote:
> On 7/20/26 14:44, Harry Yoo (Oracle) wrote:
>> rcu_head is overkill for kvfree_rcu() because the callback
>> function is always either kfree(), vfree(), or free_large_kmalloc(),
>> and thus there is no need for a function pointer.
>>
>> kvfree_rcu batching reuses the field to store the start address
>> of an object, however, this is not strictly needed because we can
>> calculate the start address in the slowpath. For the purpose of
>> kvfree_rcu batching, it is sufficient to implement a linked list using=

>> a single pointer.
>>
>> Introduce a new struct called kvfree_rcu_head (the name was suggested
>> by Vlastimil Babka), which is similar to rcu_head but is only a single=

>> pointer to build a linked list, without a function pointer, when
>> CONFIG_KVFREE_RCU_BATCHED=3Dy.
>>
>> When kvfree_rcu is not batched, kvfree_rcu_head is the same size
>> as rcu_head. Note that shrinking struct kvfree_rcu_head on
>> CONFIG_KVFREE_RCU_BATCHED=3Dn kernels would inevitably require additio=
nal
>> complexity and also some sort of batching (which defeats the purpose o=
f
>> the config option) because it cannot fall back to call_rcu().
>>
>> For now there are no user-visible changes to the API. k[v]free_rcu()
>> simply casts rcu_head to kvfree_rcu_head. While this does not affect
>> the API, it allows kfree_rcu_nolock() to reuse kvfree_rcu batching
>> as a fallback when trylock or sheaf allocation fails.
>>
>> Stop storing the object pointer in rcu_head.func and instead calculate=

>> the object's start address in kvfree_rcu_list(). Factor out the existi=
ng
>> logic to calculate the start address from kvfree_rcu_cb() to
>> kvmalloc_obj_start_addr().
>>
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>=20
> Nice.
>=20
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> Nit:
>=20
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -351,6 +351,33 @@ static inline int objs_per_slab(const struct kmem=
_cache *cache,
>>  	return slab->objects;
>>  }
>> =20
>> +/* kvfree_rcu_head offset can be only less than page size */
>> +static inline void *kvmalloc_obj_start_addr(void *head)
>> +{
>> +	void *obj =3D head;
>> +
>> +	if (unlikely(is_vmalloc_addr(obj))) {
>> +		obj =3D (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
>> +	} else {
>> +		struct page *page =3D virt_to_page(obj);
>> +		struct slab *slab =3D page_slab(page);
>=20
> Can use virt_to_slab().

Ah, right. We don't call free_large_kmalloc() here.

>> +
>> +		if (!slab) {
>> +			obj =3D (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
>> +		} else if (is_kfence_address(obj)) {
>> +			obj =3D kfence_object_start(obj);
>> +		} else {
>> +			struct kmem_cache *s =3D slab->slab_cache;
>> +			unsigned int idx =3D __obj_to_index(s, slab_address(slab), obj);
>> +
>> +			obj =3D slab_address(slab) + s->size * idx;
>> +			obj =3D fixup_red_left(s, obj);
>> +		}
>> +	}
>> +
>> +	return obj;
>> +}
>> +
>>  /*
>>   * State of the slab allocator.
>>   *

--=20
Cheers,
Harry / Hyeonggon


--------------77Phiovz4D8FAfavJFkTxfks--

--------------rHmQ19i50j0kL2o2vIw30Byv
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCamB0dwAKCRCGXBN6rc5S
1obAAQCqHfelJX+qi5duTvHrT8jGkOgRfpF+LiWvdac7y5+2pAEAryoulTJ2FIDf
tKqBX1pWil296y3KUUzK/9SUjWszIAk=
=N3ce
-----END PGP SIGNATURE-----

--------------rHmQ19i50j0kL2o2vIw30Byv--

