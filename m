Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E29CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597506B008C; Tue, 23 Jun 2026 02:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548BE6B0092; Tue, 23 Jun 2026 02:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4633C6B0093; Tue, 23 Jun 2026 02:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BEF66B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:17:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 644F81203C9
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:17:33 +0000 (UTC)
X-FDA: 84910170786.19.C0EA311
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B495E1C0006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:17:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HRuB9r/X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782195451;
	b=lYBL7WhknKhrpbnX6hhWE7fhGQNgum48egkJSBBfsPBrxF4x0LpUx6PQU5ZqpZCBQjwEaR
	lNUP5jNfCPKQq/T7yaF8WKotg7o6eM9KUNjQ1lkJ7lACmzG3kr+8ESSEQa86Z+1cFmYEKh
	a0cuvk3DVGho2P95exiGpxSsMHAKaiA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782195451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wURFcKatuG6Z9PR+jWQVTJNfeJ7Yg+VswIaJSJOM9QU=;
	b=ayxIGJyt7j7Vyqwev2WDzLkxNbhd3cmDSRWMALnE+ehUFxw4j2aXEhYdMgW+0sCOBGntLf
	aPCoHUsUBfcxwPkbkTWB7/+AijbIoijRlR8EJ453N3Gx4yQeGvXWukrzwZByl2Ys0oNjKv
	RJnLP+HKz9U1mhwkjPnq+N23MPVAApY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HRuB9r/X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31E0160209;
	Tue, 23 Jun 2026 06:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF481F000E9;
	Tue, 23 Jun 2026 06:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782195450;
	bh=wURFcKatuG6Z9PR+jWQVTJNfeJ7Yg+VswIaJSJOM9QU=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=HRuB9r/X5W4McSJjC38ySksYgMQnjNn0tmhZ9k01WwSqfu1rnnyyFx+/q5lhVnqXX
	 hJjTLEYVFjfj1JunJECgn1C+c/Pq4/lykMIUFKPRhrLBPW2YG3yvI/k16kSvheNJQo
	 9/idUGBSxH2rkcGJFKs4P+3FFcah/2qjFfRoEnD043nz5uZloeZSX68htRAsBVoWmu
	 x+kFibYc9sm3zhAqnO8jwX8IrCp6ttGi3qMxhYY6AOzgZ3QJi1cmuryNFincMbd3By
	 5XhRVKz1GUKh1JwbTa6Nqs5YXjOiHXWJMFQpaacJ0e9OmKZuK52Wjaf7drQ05xJ4dv
	 aWCUf6rA/TiUQ==
Message-ID: <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
Date: Tue, 23 Jun 2026 15:17:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Harry Yoo <harry@kernel.org>
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
Content-Language: en-US
In-Reply-To: <20260623024237.45990-1-qi.zheng@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------8YsZNEvf73Xski3Cmenrn9FR"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B495E1C0006
X-Stat-Signature: i7kzxctkac4kwfpjpe4equpry6dgf9te
X-HE-Tag: 1782195451-581498
X-HE-Meta: U2FsdGVkX1/94drSEa3wjiEMOGhrX7GSJzY6qrOOp8SpPbV8OLJWt3oNLSz1OGYUcP8YU+02HWnFEmcIvjU1Ztn18TpDmSDVPJ3rToPwdt/WLn1GYiC8lBKV/qP/jt2IlH7YQurNpIeDb1l7om9xYRjwDpMOM41ArzGs/3sq1tJQ209yEUJZ6do+l6EPA0J380jYL0lxdOmE3jECxWJ9PbNdkdDljKyU4UIU00ljGnwQWlyaPAETdCh5tFNVt4UCmeGgWs04qjTgfGKfyaNIfDt8oPGD86ewBLEzDyKIhLCJvRauUf68gJ/oT9XOQVdFtNonVGxgDztfL4MYNX2nNaCcCVALOLjEWlR/enEuDozssiy9fQ5QJYlx3ayJaRlVXaOABalBvxcaZ5sksV+neK42LhkE8DNjGTKXxGzoMyvRk10g2z3fQ93QrbTVH0lJT/EcpObPtfTXiVXnP8Kul1BuEoJuIKHNVlypGfqoCMHbta+FFftXPsGEb3C5GYG8+kn+gn3+ZE4OfC4pF6nbem/ow6sZXz31+4/z1CHIjUludvsHdrmsvs7NTmr6JsOByuJYFifvj71LG9UtX9r9Rj72/w3OSmOo4ptkVcoe0a9pbcApe31ou/77f68iTQgUbnVbSHV/x5D0FEsPH6e/KQ+GhLTcfsT522IEgAi6udk2XtFiX3V+EoLl9ydfcrYM2Q4B2wrg3+b6HT74vxbVlPhtPTkxRcPZHqD70nb0hu2j20Fed+BTzcNqZzgmz2ERtoW5o1qX/ZtuucvXk2sIdN6SfAdkWAjuhPfufhDXHXQzKG871gpotgqQ6OPnb++wd7AVsiXQxSSx4FD3s9Fcx+IS0ynURk/UG662pBpkHIqRxtWYhktbC5NwWnewqb3SmZZ6IoiRZt+MIv0GLWiS/J65HRrD/sh7YHIGNuMDz/xGvf9mW2fGyE7ofTvlZK+6JUo6opPmM7kd85IV3Yy
 on1VuYe4
 plQoBJCU5cdnWHdwgwrB2l2HISbivS0lmzxyWcP2jHXxezMdC7zzskXB3PyWPMdUHwplPMzelrN3TZzY2fu5IZiqPSyFxVRn2Ij6w0tF4F8sld/Qnr8qaX5RN5aKhHEtzSoFjQrqqRuYtS2UN9cDS4PzVmxsR80HYWprMaVgxoajfdzyY6Mlx0sRPBbG6lRBXyTMo0ucx9Kwx8lHJGRgD6wwikngfZ2gYtqhEbTXmI5Pp8iX4Q6S5BG3/2Sh+Cx4NWvI7N7jsGti78svfHy7+iK+WhUh/aJ7S/oyzq9/tDbjQOzN7C5M0cStJt6qIbKWlJIToCGjAq5ziXKtBkbJgg7Nailit+Of7pXQu6Y3f5EID/y9TLUwtS514xwVJE6r0Zeq8Yu+MghR2SMo4oZIRaliXnn3zP1UElwMUSbJx41DSo2jNzePSRHV7q22XRRe0Rm95eYWzaNNltGnb6wKNlMMG62A+rNB+O/+rCEC3+YBOZk7lSsPKKdrZqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------8YsZNEvf73Xski3Cmenrn9FR
Content-Type: multipart/mixed; boundary="------------ER20SFcEhPfRwGGdTjKgmtqc";
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
Message-ID: <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
References: <20260623024237.45990-1-qi.zheng@linux.dev>
In-Reply-To: <20260623024237.45990-1-qi.zheng@linux.dev>

--------------ER20SFcEhPfRwGGdTjKgmtqc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/23/26 11:42 AM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>=20
> The mglru page table walker batches per-generation size deltas in
> walk->nr_pages while walking page tables without holding the lruvec loc=
k.
> The reset_batch_size() later folds those deltas into walk->lruvec under=

> the lruvec lock.

Ouch.

IIRC the user-visible impact of underestimated nr_pages in MGLRU
was premature OOMs because MGLRU does not try to reclaim memory when
nr_pages reaches zero, but there are still more pages.

Perhaps worth mentioning in the changelog?

> The page table walker can run concurrently with the memcg reparenting p=
ath
> as follows:
>=20
> CPU0                           CPU1
> =3D=3D=3D=3D                           =3D=3D=3D=3D
>=20
> walk_mm
> --> walk_page_range
>     --> update_batch_size
>         --> walk->nr_pages +=3D delta
>=20
>                               mem_cgroup_css_offline
>                               --> memcg_reparent_objcgs
>                                   --> lock lruvec
>                                       lru_gen_reparent_memcg
>                                       --> reparent child folios to pare=
nt
>                                       unlock lruvec
>=20
>     lock lruvec
>     reset_batch_size
>     --> child lrugen->nr_pages +=3D delta

The problem here is that, while grabbing a reference to memcg
(via mem_cgroup_iter(), for example) makes sure that the memcg is not
freed, it does not prevent offlining happening, and reset_batch_size()
doesn't check whether the lruvec has been reparented, or the lruvec
is going to be reparented.

> This will trigger the following warning in lru_gen_exit_memcg():
>=20
> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> 				   sizeof(lruvec->lrugen.nr_pages)));
>=20
> To fix it, add lrugen->reparented to remember the new owner of a
> reparented lruvec, and make reset_batch_size() charge pending deltas to=

> that owner.

Could you please explain why it is unavoidable to introduce the new
field and why checking whether the cgroup is dying (and charging deltas
to non-dying parent) doesn't work?

> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a=
-a53a-1e28cc894f0b@smail.nju.edu.cn
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios"=
)
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---

--=20
Cheers,
Harry / Hyeonggon

--------------ER20SFcEhPfRwGGdTjKgmtqc--

--------------8YsZNEvf73Xski3Cmenrn9FR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHQEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajok9gAKCRCGXBN6rc5S
1kURAQCrKB/rsq4mdWtdZZm4JU1WVSaM4LcbuV2X4quEVTJE4gD3XKbfFR+HrWSj
FKsjLyGg+8QuabxOWILmVsvWQ1DIDQ==
=j7cm
-----END PGP SIGNATURE-----

--------------8YsZNEvf73Xski3Cmenrn9FR--

