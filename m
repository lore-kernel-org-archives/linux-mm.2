Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ECE8606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 07:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=v+SIytma
Received: by kanga.kvack.org (Postfix)
	id 610146B0928; Wed, 25 Nov 2026 02:58:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A016B0929; Wed, 25 Nov 2026 02:58:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 488F46B092A; Wed, 25 Nov 2026 02:58:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18A7B6B0928
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:58:30 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0E48160D63
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:58:28 +0000 (UTC)
X-FDA: 85472889096.01.F04824C
Received: from mta1.migadu.com (out-44.mta1.migadu.com [95.215.58.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8D35840004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:58:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v+SIytma;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.44 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795593507;
	b=ZcTAeq5BNPoStS2+wMkoW9tV2TR50QJItch6qQcGhpsSaP3tE10mtKBxbd6UYXY6Wnwsjo
	1QMsDT4+p1dkQkvFb/Ml2Xo97dnxv1mOTrzfdQZRXQsq/D3iIPIwZt2JbjM3aVFdlUejPe
	A9P0owlvGu7Lo6GfK4lF0QqxCNDXeZI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795593507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERfJb3qF0+sgEEuK6tJL1bCyE1JjReykvfA28PGir+g=;
	b=Fb4KA4OXEzuqxNWo37FIgl9212c4xC9MfJp29D/E9I0z4CkBkQPppo3KntxycG95IS9pp8
	o1xFIXc59DzFOgWG5ChWxdW1l8/OtuNuuA2KGgS01VJmxWEnTDjYYzdZEYnzAzuvsU/L04
	bM+0m9N6jumAYjpU2qr5q1yvJ4ZGqQU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v+SIytma;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.44 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JJb4V3QmzElV+J3+lTvVhXCbEVNDcL1viNTlfeP0Wlc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795593498; v=1; x=1796198298;
 b=v+SIytma8dOQHqmZB62ikezj2CXVTIhPAIXBPy77bQ2S6LMV1nCrDFsbY6MWaY+8UYEIeCPK
 BsZg37nSHICyHPmU9JS8RSfP+1PNzNtuD40bmveUrCYfrUArq2UO5YGgjNpqnWN1iXR9biOqA0M
 gKEeOmbrQA/+xTA/2oNcP0BM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d6c3d85e79e38a6d;
	Wed, 25 Nov 2026 07:58:18 +0000
X-Mizu-Trace-ID: d6c3d85e79e38a6d
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 25 Nov 2026 07:58:18 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <8f0abedb57eb51b09fbfca232fcc0f6eb0dedd03@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 0/2] mm: memcg: fix memory.high allocator throttling
To: "zhangjiao2" <zhangjiao2@cmss.chinamobile.com>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>,
 cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Hui Zhu" <zhuhui@kylinos.cn>, "Song Hu"
 <husong@kylinos.cn>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Chris
 Down" <chris@chrisdown.name>
In-Reply-To: <6e73ae4b-5400-4f6d-bf5b-2892827ea144@linux.dev>
References: <cover.1794902513.git.zhuhui@kylinos.cn>
 <avzSkT9-jsCrMoeX@chrisdown.name>
 <6e73ae4b-5400-4f6d-bf5b-2892827ea144@linux.dev>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D35840004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: q793bdq6jzbhh61fgxs9btsmff6f9i4e
X-HE-Tag: 1795593504-47105
X-HE-Meta: U2FsdGVkX1/A68iP4qlL83ugo9iOttD4vDkFgajvROQoUeQad9yBpYjT7FNqUGpOnnZnK06ESdgE6vtre2tSJvUDdeuronNxKR+3CAliUuQewhwChjhSmCVXTu7zxDDldVghUgAvIICOTiyxTSFoRj1J2QsP3N6lz+pX7CBpfqZ8W/0nQpjB4BKxTUEJBixFS5tz+auiY2AmsZCr8f8HhwLb+hh4va+jeT/CwYJvuVR02yS1XlcfHs9UrFZqQ/grIjDOnkRJ7F7QXbigKw5EjN65zzJDGsrvNSKdUcujmmq7MjgTaKtJuN/FIKQhd7k8sfMIQHzWrIYfEAd37GtMrkzKHc7qJ+RZ0sNe4N8UhDcBkza95vqr/7C8Tii0EFLNBsAJPq217ikPOlRSwYsawJEraEY1CLmXhsIdcpZWdUjCyOpXxC5ao1aIdeYTrP6J34OoAX+B4oOTys7cOztikUNo0VTLsta9OgTx4v1Av6DzgjFF1TjYfn48VzF8Gys10sRsQkOk5CQToBMhIh7/BonLhH2Z1VAv2pIMchmG05PBEzXfj/UwPiVhMea2U3XKhF4sPmd4NDh9DchOocHPcspnOPaEU+s8vEXurK4dsm9X5JiR6coewXOj2bplgP9On4uM7bTloOrIWNO8pdTlOka0MXAsxXndRi4wsvkOtHD6UIaOFjAhYQ+1q93SVL/E/cTqt9p5ebfFCssnKsUDZ1dFlz6u050a/bUoEUJmNQ4gFCTqA+0ET9Q+hWSkHduHUS0ZoUjKx1sdtGw0ZiXl98VrebK+fsSuiwvHK0W8pwDRWkee/p3t6I4alzy60HI/EDia9oXksMKTFNP2kum0PSEUagXnTG4gyngpYcKIlQTTP1jea6A87hhjTID/o1hvrw+3tbkyUo29ClAJO/MR6akqF8rDOORkLpiYR+3opvOegO65ebg2tzl+00b+RryHvv3cOopRhLOs4x+CXLk
 D4ErXnkV
 kRDCrC23Wem47Ho8cQul8XCktZEScJFl/DLY/ejYmBr0+Cuy9Fz4BMQwot2yZEEzXiT4FEO7LX/smPQ9ljNHnhHX+QPe6/0YjOEv8J/QPy4obm6Bpz3qc2qlhM11cekEBYACjNO02+uLW56jExTriX+1PhGzqaU/univyD2NFOEMH/yN+5DIGXY1LpOfTjzgwSl1nfNtfRByOMEvzRLouDDMwrN1iG7srT23uRBuu8D+r+nMFlk/L3kZLx9gSuAhnuhooeYdj1UHXCXcKH95yoGJjyeC7BteGON0sGBjreISL13lpQCEVPM61UXTxSYv8fp5jjZc4jQl65+zpelTYdhgP/XDrGS+D78y1ncVNEfuOd65GkfDPJEXbUSZAZkp0ssGm6FNZCKwyyYG5+OhGEZ0KuJJyas0HYwPycj7kageJpZV5Ers7GQNGQXEST2sl80tKSRZfV7POoRHh/JgNU2gYvm/sy1SvoD4bJNH+prJIg3WxlKlfYcPlENmGl6WdZADV3JFjRmm+fnxkYKPRedV6/OFNSA9AbN+f4RPdVegF8sA1qnxAppNgy98j8e6MGfxkwZuihorWL8QLX5gCPCHL+sJyXMy8ekud13p3aHnwy2hYkyXVi/UAZR6Zc3z7SPJvoNRiMWmnLLFEik668PJawnAUpnkknkzu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Hui Zhu" <hui.zhu@linux.dev mailto:hui.zhu@linux.dev?to=3D%22Hui%20Zhu%2=
2%20%3Chui.zhu%40linux.dev%3E >:


>=20
>=202026/11/18 06:17, Chris Down:
>=20
>=20>=20
>=20> Hi Hui,
> >=20
>=20>  Thanks for fixing these, I've verified that these fix the issues
> >  reported.
> >=20
>=20>  That said, Zhang Jiao sent a fix for the same two problems a few w=
eeks
> >  ago, and Johannes thought the overage cap there was a bit of a magic
> >  value, which we have plenty of in mm already, and I agree we shouldn=
't
> >  add more [1].
> >=20
>=20>  Could you please coordinate so we don't have two patchsets doing t=
he
> >  same thing?
> >=20
>=20>  Chris
> >=20
>=20>  [1] https://lore.kernel.org/all/auNrakxaET8qkuAn@cmpxchg.org/
> >=20
>=20Hi Chris, Joshua, Zhang Jiao,
>=20
>=20Chris: thanks for the pointer, and apologies for the duplicate. I mis=
sed
> Zhang Jiao's patch [1], and Song Hu's earlier report of the overflow, w=
hich
> already proposed check_mul_overflow() [2]. I've added Zhang Jiao to the
> thread so we can settle the coordination here rather than off-list.
>=20
>=20You and Johannes are right about the cap. I've dropped
> MEMCG_MAX_DELAY_OVERAGE and reworked 2/2 into the shape Johannes sugges=
ted,
> with calculate_high_delay() and the caller's penalty_jiffies both in u6=
4 so
> the value is narrowed only after the caller's clamp. That also removes =
the
> in-function min() from 1/2, which was undoing ff144e69f733 ("mm/memcg: =
move
> penalty delay clamping out of calculate_high_delay()"). The series shri=
nks
> from 19 insertions to 9.
>=20
>=20Joshua: the Fixes tag is the right one, though I can see why the diff
> suggested otherwise. The division comes from 0e4b01df8659; my patch onl=
y
> touched that line to add the clamp. The bug is the reordering in
> e26733e0d0ec, which replaced
>=20
>=20 =C2=A0 =C2=A0 penalty_jiffies =3D ((u64)overage * overage * HZ)
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 >> (MEMCG_DELAY_PRECISION_SHIFT + MEMCG_DE=
LAY_SCALING_SHIFT);
>=20
>=20with
>=20
>=20 =C2=A0 =C2=A0 penalty_jiffies =3D max_overage * max_overage * HZ;
>  =C2=A0 =C2=A0 penalty_jiffies >>=3D MEMCG_DELAY_PRECISION_SHIFT;
>  =C2=A0 =C2=A0 penalty_jiffies >>=3D MEMCG_DELAY_SCALING_SHIFT;
>=20
>=20Before that, the shift ran on the u64 temporary and the narrowing int=
o
> unsigned long happened afterwards. After it, the value is narrowed
> first, so shifting it right by 34 always yields zero. The division play=
s
> no part, and in v2 the diff no longer goes near it. Your other point is
> settled by the same rework: with the clamp gone, the comment goes too.
>=20
>=20How I'd like to proceed:
>=20
>=20 =C2=A0- Zhang Jiao: would it be OK if I send the combined series? Th=
e overflow
>  =C2=A0 =C2=A0fix stays under your name and keeps your changelog, in th=
e shape
>  =C2=A0 =C2=A0Johannes suggested, and I'd carry the 32-bit truncation a=
longside it in
>  =C2=A0 =C2=A0the same series. If you would rather send it yourself, or=
 split it
>  =C2=A0 =C2=A0differently, say so and I'll follow.
>=20
>=20 =C2=A0- Song Hu and I have been in touch off-list, and they are work=
ing in this
>  =C2=A0 =C2=A0area as well, so the patches under my name will carry the=
m as
>  =C2=A0 =C2=A0Co-developed-by.
>=20
>=20 =C2=A0- v2 will include what was missing before: a Fixes tag for eac=
h of the two
>  =C2=A0 =C2=A0regressions (e26733e0d0ec, v5.6, for the 32-bit truncatio=
n;
>  =C2=A0 =C2=A00e4b01df8659, v5.4, for the overflow), Cc: stable, a chan=
gelog that says
>  =C2=A0 =C2=A0plainly that throttling was completely inert on 32-bit, a=
nd the wrap
>  =C2=A0 =C2=A0threshold corrected to about 130x at HZ=3D1000 -- the 409=
6x figure misses
>  =C2=A0 =C2=A0the HZ factor.
>=20
>=20Two separate patches rather than one, because they are different
> regressions with different lifetimes, which matters for the stable
> backports.
>=20
>=20One number that may be worth putting in the changelog: the smallest
> exact-zero case is memory.high at one page with usage at 2049 pages, wh=
ere
> max_overage is exactly 2^31 and the product wraps to zero.
>=20
>=20Thanks,
> Hui
>=20
>=20[1] https://lore.kernel.org/all/20261029073857.974-1-zhangjiao2@cmss.=
chinamobile.com/
> [2] https://lore.kernel.org/all/20260818012115.65838-1-husong@kylinos.c=
n/
>

Hi Zhang Jiao,

Gentle ping: OK if I send the combined series with the overflow fix under
your name? If you're busy, I can carry it forward and credit you.

Thanks,
Hui

