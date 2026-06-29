Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BBAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BFBF6B0088; Mon, 29 Jun 2026 04:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149866B008A; Mon, 29 Jun 2026 04:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0111E6B0092; Mon, 29 Jun 2026 04:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C56D66B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:19:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 527481C598A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:19:14 +0000 (UTC)
X-FDA: 84932250228.11.265A610
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8C97FA0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:19:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a0POJnWW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782721152;
	b=Wk0gAFB9GsD8HZwrYaTJrGmjn30Pa51RwzIEp+R9OGDgbA5xzGNtDWCAIv7+xYazVbm1mT
	IjVv+xyZCUGAaS78gJ8mmeokNhKv/xkwlRZEFEBEweUb43CobtVMgB5SQAjd7GAymGmAwY
	L3KB+wpJtXX3HIkfoXZhWpI3l6xRS58=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782721152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZGohl8o0Xi4Sw0uZbCmVZVFuovj8uht9Jky77XzxYU=;
	b=xbBAGI4ca01xpNe4xSO+DBdE+g2x7pnr7u0L31gGqDc3qV1SzhJB3kRLNbnYEvPk6M5QJR
	TmVgfY8r3elwl2GYM2nUQ2/czbDtLFuqoDNir0V7mNJwlpZNwlcGQoawB3NPWrONV4xYhh
	V0mMJcS8osuStXmM3KQI/8UKAyCo9ZA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a0POJnWW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B487A406FC;
	Mon, 29 Jun 2026 08:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3345A1F000E9;
	Mon, 29 Jun 2026 08:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782721151;
	bh=MZGohl8o0Xi4Sw0uZbCmVZVFuovj8uht9Jky77XzxYU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a0POJnWWk9ffjgZuRxp3Xl1Ko7Fd1mFeGrnnmbmrrMA3HWIC+dBIu/1pEDHFjovB1
	 gIrp7QtAeYN74W3QDb4cqypY1atSqrRrj4lAruTKrkF50SudutWlUbr0ckVRNNNHaU
	 rcKajXP8DvD4Zz4aDxRkBfmugpUGtkrNtcgHCEcIUtq4eSlyH3fHEYmyhTv0bcNcaR
	 OTr77NDEnDum2neyY387k7QBXDtQ3l02OdsTD4Qf4AvMXTkFuxv8eDU5wc5SgR2Ea3
	 HFaHZjr9rYx3l0y8tEwRXvFDfUWVcEgjcjMxyLlLeQGpU0PtblG7gAae/KbDugIZ84
	 ukSShW0IL4tHQ==
Message-ID: <1f4d68e5-7ea7-45f8-8286-fc276178c7ed@kernel.org>
Date: Mon, 29 Jun 2026 17:19:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 4/9] mm/slab: use call_rcu() in unknown
 context if irqs are enabled
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>,
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
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-4-70a54f3775bb@kernel.org>
 <ajvpq2Ay-nRH7s-X@pedro-suse>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <ajvpq2Ay-nRH7s-X@pedro-suse>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------GaUI6z90zVa0zdq40fRpqq00"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C97FA0005
X-Stat-Signature: qg8ak8jop9a5yzncozozf8grkbg6rkxw
X-HE-Tag: 1782721152-751954
X-HE-Meta: U2FsdGVkX1+wljcLDsu8C77o8qip0PbYyVB/vdHa2a4vthmmj7RkF3wbqBQ0FDLnwP9U6LakrxIJ5TR75VDR/6klPZJ8avvLEsf5BYVsEHCTjhOa/8RgKJ40XW+IKL2QzM3+hIkRT7TWf5EPAjjOOHS/0xyf2sZQU8ZGXKhsp0CHEM2zfHQGPJvMWjT7fXt5v1VL4DHwrKm5PSvpbol9+LRF5A0xIGhDxgd+tr/xOgp896t6P4YmYP1ne1BK6fsAcqj8C5x6UsSfcLQA8NkEPzUiZbUWz8lXUHkEygaRaLdRtGoPS1LI/EOWxyNNE5XrEL4QwLHvPOgMqlcWIu8QpWO+9BrIuT3Ny1qD8STGJhsdsRYfNtXdSKGyyiZj5/xbb0+vif1Iu6i1ycVQI2TlYzpvRuyGFVq4zb2ZhcJpmv1+AuDs1alMnKnqqzZd1Ran1yMLBnC5Ex48o1KgQ6GLbOxQBg4X0AVgygSFbRLCYYXn3j1+EI2efmQP6yg8SvOe64CCxtsVxSMh3tGeTZLwrSudHr1P7A7IsfsrRnlg5TAXvrlgUYU6ihuDTTZVOSndHJs2EDDIn7SjROjxFqJLWeOZlCnYXV+VNLp6XU11Oqal1TK92Hcxih6jSYZmxDMW5H2rJU/d2/tIy0vHmCNIsIWnhKtQjJRmrZbff+ses7McguJCdlE/z+7vfVewUVFkVe1h0mddbd+Hpju2qGRPj6D31POccB5f4qzwNk6Wxc4X6QkUbG9QoctJfSGJWD4e+xddQiJa1B5vVcPtF4sJhawyZkym38IxcBcnVbmz0Cv4fWf8Nyr2L0DNfmiWiSj+CTaC0y6+hrTnlMqsf0spBTn9ONi6zYrxQB4bzhEAd+aTa7pm/2K6WsoAFp7d7PKy1ihT/Ni5Rp/FtrC8I7Qjsex8G1Sz/PGr3sHPrU5HDXCe+TfvGo26xHz1yvBuRDezBWVozG8IWEld+UHFCkO
 WAef/0/T
 C+8gaREy/nsmvK0k7iVpX9Fj7ux86DiLnBJNPzjWpqR2wSNGPdxaADoHRAM3xsYuaUZGUzLp6cVndZZlWnSkp6RGA7BCV0K1QeMVk79J02loytxIdU230zwUvIdlJm7iaYSdvYOsdyK8DlusIoj3F2m7SRO5xIPAFjarrWudI/X43bjj7AHl18rtVx9Q45cVehJSPzbZtZpMwX9c/YYrpZbNEy2JcBjuYgBbdW5AXkHBKt4Yv8hnJDnje0p4Lh6gcN+X2o+Rx07EYdZmfwUscZ4yKABzAt+DQixAwDHZXURJ7iwU9ZGGneGXbnuW/W5j3XVJUd8jeRY1ecoVYJIoErXiN0im58pTgn5JXMdxHVglmy8inO3NGASPTl72G6V3qtx54SV3Sc3mphzTy+LPmIb9+nO8AcrQdHxXRwQ76GAMRl38Q97FB4GZGkicesh+oUu5JgZJ1N4SvqlLOIkOh3VUuumpQNpe2yALMn+FRt0F8WSvXEjheiIZlrZ5jOLaR0QHU8iB6wsDvDUs0h+VCIkFthpR1p1zdsqnp3jt57saWdKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------GaUI6z90zVa0zdq40fRpqq00
Content-Type: multipart/mixed; boundary="------------0gIw2wbsDQjCNZaQoAyGLTmg";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>,
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
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 rcu@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <1f4d68e5-7ea7-45f8-8286-fc276178c7ed@kernel.org>
Subject: Re: [PATCH for-next v3 4/9] mm/slab: use call_rcu() in unknown
 context if irqs are enabled
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-4-70a54f3775bb@kernel.org>
 <ajvpq2Ay-nRH7s-X@pedro-suse>
In-Reply-To: <ajvpq2Ay-nRH7s-X@pedro-suse>

--------------0gIw2wbsDQjCNZaQoAyGLTmg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/24/26 11:30 PM, Pedro Falcato wrote:
> On Mon, Jun 15, 2026 at 08:05:58PM +0900, Harry Yoo (Oracle) wrote:
>> call_rcu() disables IRQs with local_irq_save() to protect its per-cpu
>> data structures. Therefore, if IRQs are not disabled, they cannot be
>> corrupted by reentrance into call_rcu(). So fall back to the deferred
>> path only when !allow_spin && irqs_disabled().
>>
>> The RCU subsystem does not guarantee this contractually, and this
>> optimization relies on RCU's implementation details. Ideally, it shoul=
d
>> be removed once call_rcu_nolock() is supported by the RCU subsystem.
>>
>> Link: https://lore.kernel.org/linux-mm/CAADnVQKRVD5ZSnEKbZZU7w86gHbGHU=
ug2pvzpgZTngNS+fg4rw@mail.gmail.com
>> Suggested-by: Alexei Starovoitov <ast@kernel.org>
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>> ---
>>  mm/slub.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index b0d38d515386..6a3552b70683 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -6158,8 +6158,8 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, voi=
d *obj, bool allow_spin)
>>  	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
>>  		rcu_sheaf =3D NULL;
>>  	} else {
>> -		if (unlikely(!allow_spin)) {
>> -			/* call_rcu() cannot be called in an unknown context */
>> +		/* call_rcu() disables IRQs to protect percpu data structures */
>> +		if (unlikely(!allow_spin && irqs_disabled())) {
>=20
> Perhaps this could be more neatly exposed by RCU? something like
> maybe_in_call_rcu().

Make sense if we need to keep this optimization for a long time, but
hopefully RCU would support call_rcu_nolock() soon (apparently Paul has
a plan [1]), rather than introducing maybe_in_call_rcu() just to drop
it soon.

But I don't have a strong opinion on this and
I'd leave that to RCU folks.

> Also, it's a bit odd that you're introducing code and
> then subsequently patching over it with an improvement. Maybe this coul=
d be
> squashed into patch 3?

I was hoping having it as a separate patch to make it easier for RCU
folks to take a look and provide ack or nack :)

[1]
https://lore.kernel.org/linux-mm/03da8742-3790-4428-84b8-11911bf44c9e@pau=
lmck-laptop/

--=20
Cheers,
Harry / Hyeonggon

--------------0gIw2wbsDQjCNZaQoAyGLTmg--

--------------GaUI6z90zVa0zdq40fRpqq00
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCakIqdwAKCRCGXBN6rc5S
1hymAQDnrjBNhyfghMOQ1Y5XsS5xCPbM5nzOMMvxwieKQiGerQD/TIjtJEpF5Zy6
02PvBcB4Ksu+B1/s6N8O0omOEQOq6Q0=
=1j6o
-----END PGP SIGNATURE-----

--------------GaUI6z90zVa0zdq40fRpqq00--

