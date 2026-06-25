Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C819ACDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98B306B008A; Thu, 25 Jun 2026 01:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9143D6B0092; Thu, 25 Jun 2026 01:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851C16B0093; Thu, 25 Jun 2026 01:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 551C76B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:40:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3FD91C4FF6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:40:39 +0000 (UTC)
X-FDA: 84917335398.22.57481EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3C4981C000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:40:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omGmfD9F;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782366038;
	b=bspmaYIKMuOaglq7lGqc4uY2a6cjN1ie6VcCQ3NNdXHhoMo+kDWh4yY57R1IorUTypdNcN
	7i/3ESxvrg6OzwVsyOI7OAGuCFSVlJcxYwa2I/mZKIQOLpC4gUBUZc01dpJ0AX1ml6OjYR
	JITYO4cbZtVrZYjc049UtavbpHlmFhM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782366038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1CYx3XQgylaUzO4k8wNoEpO9t2hZ1nDpctVE/l57eTI=;
	b=S/eUGZ93HsEb7EkvrGQU6Rm5JRzwOpKVx2poQa4STQtbGPlLShnFaG1d+XteHv4a1GNgVQ
	Hv48Sxd705zl5Bwu8KhV8X2TCW1IvFwNP41OnkPi9T4N+mutseee4qAfBcJ05ojtZt3tvu
	d0vK2JyFCbtah6RCBw97N0R0tgeuqbk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omGmfD9F;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96576600FC;
	Thu, 25 Jun 2026 05:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CA21F000E9;
	Thu, 25 Jun 2026 05:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782366037;
	bh=1CYx3XQgylaUzO4k8wNoEpO9t2hZ1nDpctVE/l57eTI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=omGmfD9FsHrFxIi+oV06COrE6S3wY1T01d/W8zp/TBk39MMccWf67jXEQdLtkvWX0
	 dRk2Sh1cNw+B7Nk8Sez3VNAvEBkc2xkDIjk5QD2JOoM4BS5ve4VyAEu7JSAko6PdR9
	 JMBJ72xNs7pUrAUVL8cnNsav5X4j/3712669Xc3n93JhfFxLDkNpkcASUfEF/MmBY3
	 KGEfDUK41cOCyNszS84CbCpH4dOwAh9jyEUVCEOfSKsy+icZYVuHp0yYEMaJonEWYr
	 exg/2JAoccuh+wtXORibtTbugnu6NnPL1KB/6q5VzyrTS4MUSsFT1C2seykSVXP/7i
	 eBLYlbNBVJ1Tg==
Message-ID: <e82b9b33-af72-4665-bc9b-c2e2cf55c338@kernel.org>
Date: Thu, 25 Jun 2026 14:40:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 7/9] mm/slab: introduce kfree_rcu_nolock()
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260624172234202jw3y4yP1YfgOYbPCQdVIw@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260624172234202jw3y4yP1YfgOYbPCQdVIw@zte.com.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Gtjp5Uv2d3HsvH5Wirwk76EU"
X-Rspam-User: 
X-Stat-Signature: 5hq4tk3kmxnmwo67ea83z9nhg4t3ra7y
X-Rspamd-Queue-Id: 3C4981C000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1782366038-95318
X-HE-Meta: U2FsdGVkX18/gVOqQfQJP9PFt1cl7ubTEfHRNpI0dopeORctuzfUCCdqtIZxoYkAMpeKyfOQqO9BNnXiwvhjpYOhHJ4p1cCzkMFP6aJCx3v/XQjaohv6Ixa1lYdLz60mYugURA48W9JJMYPRsmageOmOt7dG6kr25R082XzxBz5glFxCBrCjF0h0RKvYEG2QclNi6y5LQykWVmH7VPGYs7kYgrQ0KMHihP+vX9gl2eetT6/ufakc1LGyjk6aMH8rj+ss+yIk5PdSOQ2EWboxrBUaKd3OiaFCYfRw6BTNA/EZQf39GgYsidOmZHBCZGiL6sHmzxv8Jk1R1PLA3Y67fw0c1CI5hnKWJng2eQ6gIkJIOT/777a9aT+ZRr5Q0S4jC3qw/Akj3yQdb26SVIrxBplqCEzr5LPJSnoHw2epNSaZf2fjoeRYf7T6LbKUwMfATOyRdbbwE/k7pvGUPVilHsjyCyl70k8dZOvnYHcjZQPE29/5C3a6Hv6/QfOgVxV3tpSPqBlhfhioVdYhYViRqTiSW68BCTaDPHaZfprQkCAdnpKMNVM1/wLKkOXnqqUrb1+r/BPSQrYGaXBzo72QMw+qnjtIgbl31ocITZEUwFDeLVmpWnA8xT5LE4rAsrefIVZ0UtzeDz3TSsRAfQZ5LtH3NxzKpWyMDSkJdlzlL2BLrSzD5IiSUIkNJydG074Up0gc7rnFVrR4u2sreFSiPxL+5Ksg1PR/caLqxPcaTi2fs41GDwpAXr5E0lnGQv0CV3Al82tYt0dl3LNnYZ58AWeUfr0M6eS1jrRdEkQmyP//voDSZ0pmakOKgQ8xtS4lR11oWT3mIr17TZNZvQbZfpCgK3xW3b6yA2IBZ9cHe68EyRwNLKad6bqLY+Dq1zhw0J9BpyezTkIQJikCp+s0wGYbdMoev6SHqTgs4M3OImsd0fIklYpazU4KAkAPaE1tvd5bov3ozDh4PAF3o3V
 yq7a6MWt
 uJHNfrLYwXXVvWFmjoMGazXKEfFGLcW4qjE4R0PGBw5uQYq7Yh4PZY/7hE2LkOpCyYkHiIUS1N2b9FE7AAcUN9Bbd9YUnqhPWNPmL0rQLWW+Nj1IIiDG4QyYMmzdKRM8zR/E96nGeNxDObdi5QDUe5GgtIf60Px/LQb5DLy76FxuEAsdxV5t//bgepwoJd/h3FYB/UUq2F5YSo8TaoRPYyiog2EXP0G9eVOAE4sU2Gpq8eBRdn+ZPGwzpZuPCaLD4oeYEJG+gRtkwX9KXkmuWlk4iNAbTK0G8ULVPVot99EbKdKdUcGLuTw9tZNw/Fw6e4i9EXlaawtrAQEtVo2vu7WCBebTGw39HtmTI/PYM7qNfjqdpAP/Nti4oootem3iPaovW7dcrTL45x67buCTn5jz/KrzTq8jwrH6E0qH5hona1bfdiCxjIHwHzLeKjD3QDXNh66fkzslIi/msMvvCnUEuRl0Z6Q9rXfyhsaI9xPo4FSqrWtx8jwZHCVfhs09pEtPhccWA9O+dJqxhbk+f2g2gLX+at1pqIaZHwnQxaKOwncoCr+v2jrfpzWru4L3jKiY/1xFqwweavU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Gtjp5Uv2d3HsvH5Wirwk76EU
Content-Type: multipart/mixed; boundary="------------ton6HL0VdAY6bEx1XiSPETpG";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
Message-ID: <e82b9b33-af72-4665-bc9b-c2e2cf55c338@kernel.org>
Subject: Re: [PATCH for-next v3 7/9] mm/slab: introduce kfree_rcu_nolock()
References: <20260624172234202jw3y4yP1YfgOYbPCQdVIw@zte.com.cn>
In-Reply-To: <20260624172234202jw3y4yP1YfgOYbPCQdVIw@zte.com.cn>

--------------ton6HL0VdAY6bEx1XiSPETpG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/24/26 6:22 PM, hu.shengming@zte.com.cn wrote:
> Harry wrote:
>> Currently, k[v]free_rcu() cannot be called in unknown context since
>> it could lead to a deadlock when called in the middle of k[v]free_rcu(=
).
>>
>> Make users' lives easier by introducing kfree_rcu_nolock() variant,
>> now that kfree_rcu_sheaf() is available on PREEMPT_RT and
>> __kfree_rcu_sheaf() handles unknown context.
>>
>> Unlike k[v]free_rcu(), kfree_rcu_nolock() does not fall back to
>> the kvfree_rcu batching when the sheaves path fails, and falls back to=

>> defer_kfree_rcu() instead. In most cases, the sheaves path is expected=

>> to succeed and it's unnecessary to add complexity to the existing
>> kvfree_rcu batching.
>>
>> Since defer_kfree_rcu() can be called on caches without sheaves, move
>> deferred_work_barrier() and rcu_barrier() outside the branch in
>> kvfree_rcu_barrier_on_cache().
>>
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>=20
> Hi Harry,
>=20
> Thanks for the series. These patches fill a clear functional gap in the=

> existing free APIs by adding an RCU-deferred free interface for context=
s
> where kfree_rcu() cannot safely be used.

Thanks for looking into this, Shengming.

>> ---
>>  include/linux/rcupdate.h | 12 ++++++++++++
>>  mm/slab.h                |  1 +
>>  mm/slab_common.c         | 22 ++++++++++++++++++++--
>>  mm/slub.c                | 23 ++++++++++++++++++++++-
>>  4 files changed, 55 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 807924a94fb0..5a39e6225160 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -1263,6 +1263,23 @@ EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
>>  EXPORT_TRACEPOINT_SYMBOL(kfree);
>>  EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
>> =20
>> +void kfree_call_rcu_nolock(struct rcu_head *head, void *ptr)
>> +{
>> +	struct slab *slab;
>> +	struct kmem_cache *s;
>> +
>> +	VM_WARN_ON_ONCE(is_vmalloc_addr(ptr) || !virt_to_slab(ptr));
>> +
>> +	slab =3D virt_to_slab(ptr);
>> +	s =3D slab->slab_cache;
>> +
>> +	if (__kfree_rcu_sheaf(s, ptr, /* allow_spin =3D */ false))
>> +		return;
>> +
>=20
> One consistency issue to address here: kfree_rcu_sheaf() only calls
> __kfree_rcu_sheaf() for objects belonging to the local NUMA node. This
> avoids filling a CPU's per-CPU sheaves with objects from remote slabs.
>=20
> kfree_call_rcu_nolock() currently skips that check and may therefore
> place remote-node objects into the local CPU's RCU sheaf.

That was intentional, but actually, this is a good point. Thanks.

> Could you add the same local-node check used by kfree_rcu_sheaf()
> before calling __kfree_rcu_sheaf(), and route remote-node objects
> directly to the defer_kfree_rcu() fallback path instead?

Falling back to defer_kfree_rcu() in v3 didn't make much sense
as the object is inserted to a global list which would cause more
troubles than NUMA miss.

But once we make the fallback path percpu, your suggestion would make
more sense.

--=20
Cheers,
Harry / Hyeonggon


--------------ton6HL0VdAY6bEx1XiSPETpG--

--------------Gtjp5Uv2d3HsvH5Wirwk76EU
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajy/TwAKCRCGXBN6rc5S
1reCAQDbId1rvGbMDk6S+2sXzRMP61XyXQQ9nNAf7KHYJwdk8wD+OSS2WZN+8LCA
npzV0tX4akpRMlyzoaZnWg0TSBQz3g0=
=bUWa
-----END PGP SIGNATURE-----

--------------Gtjp5Uv2d3HsvH5Wirwk76EU--

