Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F75CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DD656B008C; Mon, 12 Oct 2026 11:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58EE16B0092; Mon, 12 Oct 2026 11:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4196B0095; Mon, 12 Oct 2026 11:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3B66B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:13:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 917E1A90C4
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:13:37 +0000 (UTC)
X-FDA: 85314318474.13.ADBDE65
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 875EE180005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:13:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Yo8yX14K;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf06.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791818015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0r5ZIRxJicrpwO18Ig2AHoe77ANyyN2+mXpKTZzO6Rs=;
	b=3agYfoKwNnd2lTW/nW6/zLAsxPjBide/ZPG8hs9ayVSDn4vbW74MyZ9BLNkd2bCG+iEgOC
	K/mx3LfXeQOxe0+y14ZbxoDtno8QGNxvjKYbn4bOAbHWUZ+6caUJYGCliNzlXVCR6ttL9E
	5Qoje32NwbvFuxSvmlhrz/8gGk36DwQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Yo8yX14K;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf06.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791818015;
	b=qgZTAhI5xkro1VOdPkom9D2rkqalmMpPi8kYgHUMYHmtW+NgnEwkGub291huTZgpfAHKMc
	3L64O7SvIJ4PgfXFNEJShUhK+m2pnOln2DLPkjQg7pdLKRmMgo4qBhCuMGRMYMLBE1iXGx
	7aUfmmYihMRxuOMtVpRjgOWuihRJIIo=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49ff680331aso15936425e9.3
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791818014; x=1792422814; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0r5ZIRxJicrpwO18Ig2AHoe77ANyyN2+mXpKTZzO6Rs=;
        b=Yo8yX14KJwXNo3Af+tHh/EGRO/TjQeRiT+hqvvxBp8Uh9oEx2k4vlVi8FHnBLKygfN
         9Jil9JlyDFSaauHIoHMxaD/LHJal7lZNl5VFAbk/rLRZ1KRBcjcpaUlW2teObOkvXBta
         BtN+k5sqVRQhvl5L5P2gPmY5okjR4kw8bNs5EwiKVXbZ7X54Y+KCxA8CKesKjTF1Tbmf
         U3LZLK9zsgwvrUYjseioU7YKHJPS/jRjuW+LQyoCsgg3Ti43rvC7jEW4RjMmgwDsnp24
         g2OCwGfEXWlk0OglSU9SIGIGPRq3rePMf4aIwaUYO9+oTO8j+6kSudOCTE33e7RVnGRM
         hXqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791818014; x=1792422814;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0r5ZIRxJicrpwO18Ig2AHoe77ANyyN2+mXpKTZzO6Rs=;
        b=aQmD+Uu+mKK7Yi1APjQGYi89ekEZ6DsZC0GZWB2MgqgmMybOIj+uFC+z4s/JtTwrpk
         RrK6gYHX0cCiXSYw7+IS2ottrhIx1I/tvD0NGQl6OS2atzEomizx+lVG948hJCiwAzq5
         ihVtQtQ9YuRlidC23O2bF+8Lr1YRLo+xY6JxsszhxDyYKAQb06V6rmjz0+qX8wkg5OMY
         98mhW488oiUsSDJQzL3XYT3N4ScoZCqMGpY4v97zmvWwz+vGrWtCyIlqvV1QAYoB+IkU
         DMqu0jLql5oBYvc5OmcSY2Yj6A7Cna9s6AUauiKWok2g3yJa2Y3m2INGujElOrBHKD/S
         xNCw==
X-Forwarded-Encrypted: i=1; AKwUvBz8OPRbLtLWjFJH+wkqvKRkDrg4iTj8Qk3qsv6l5fpK7c7BS47KLt4iFndChyFFQHhfVPw8gmamIw==@kvack.org
X-Gm-Message-State: AFq9FYLH+GvZ8c2x26UXsh3ojTraFzHz/dyfgPr8hR30JCMw5eah0FoY
	i7eQBSnlkMX+BfKywag6+bepCld/gtlNhcx8VhJIoJYpbGu6yDGb9ck+9ISZiDCyfFBev8QF+cK
	PUfy+ZZo=
X-Gm-Gg: AYBFou1NyeGATO573OzPid0exzpC7AgeapEUJf1Gxnu4g16f7hOVFEIEggnqLJcE3Su
	VhlLasc7CxMJmG8pHFpnCLEBXgKqZrcEmRDEuYfDbKuoGtWeKKntam/axSOG7wB2iTbRgkQ6+8n
	G/cTiaNoBfx5Dv3Pf+BFZDN0TAmhVodzTyYt1stzk6aXjsWslTg1ZhH8S3il7GQWGEU3cQ0jGqo
	HPeAErcmzE5LnSrk8tze9RTXaAyG4zKIW9dFfEUVe+YavcBzstrpMzLLip0ncafvn2uwqnaOGnF
	hStugOps/OKFMJZo8phZ4hpBp6pMRD9BNjISBCZ+YL9lInJQcSVIsg8CW2Vcz9HWb1+qhQLg0Jg
	EamugCUMTKcZgqAawV4XoP+ZeIZ9lnfJ0yKgWynsMyYF7r0IrhptGJV89bRh3xZ3U9WIx/Se1xv
	xN9mvedWClNdxIfED7UA0JSWdfGh2X8ou3Oa16wvp17sKufjuN1VyGw6qotxPYpfSqe2iPVJ2nY
	g==
X-Received: by 2002:a05:600c:3d96:b0:4a1:746e:5898 with SMTP id 5b1f17b1804b1-4a18e4835e7mr165297275e9.13.1791818013897;
        Mon, 12 Oct 2026 08:13:33 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a19f318c31sm78961655e9.3.2026.10.12.08.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 08:13:31 -0700 (PDT)
Date: Mon, 12 Oct 2026 17:13:29 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Sebastian Chlad <sebastianchlad@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shuah Khan <shuah@kernel.org>, Sebastian Chlad <sebastian.chlad@suse.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] selftests: cgroup: Report failed checks in
 test_memcontrol
Message-ID: <20261012-blend-diner-c6361d00b9f1@there>
References: <20260926055152.1684-1-sebastian.chlad@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="u5gbdmp2bzg3luyu"
Content-Disposition: inline
In-Reply-To: <20260926055152.1684-1-sebastian.chlad@suse.com>
X-Stat-Signature: t1p11dg711gefqzt4ugtk9sps9wb3pzz
X-Rspam-User: 
X-Rspamd-Queue-Id: 875EE180005
X-Rspamd-Server: rspam08
X-HE-Tag: 1791818015-893152
X-HE-Meta: U2FsdGVkX19pwQhUlq8hI3AkY1rVx+grycI9tiyWXqGNLFb6kRwjMDTPScSvnjnvf5KS3LzIsUvERaERHIXSb2xyOAJVNgDQAb+mQVEm91NNWhIWkJuYtlzQkRzjTOeMOhHszig+H/dBhlsIiUT+E9V7sJKwylk9KLUETAJVEwGH8F4Fo3PhVyDVut+HdPriFPCFjYLLPfeYbAf3mHUYPvnuKUEi9Mz/Zbjv/3f0mmafhG2Jqkp8UulWfHbGp1Vfv2BK0hAxwcbf2ZsAsueMrMT/zWRybw4N2KaO8n6R/F6x9C4ppqQQvXAzFG4D+zdySpliSOR7A2DShd8RDFGSvRt5w4E7IUjkcLpO1u7mDjeIr+C3A1ZdMemw77X7h+rfQVHoqS1cIpYOCuEO2LKV7kJ/KXqgOjhcxejvoFbg9UiheQnlvPAlEbyGqCoAtgIqowP4GbkTi1lVbOkwk40yvRIgkucJuzz7wjC7l5ssn3Xqr6R+xzweZNddj494Quk23pSVSLtt0xWc9X2iTdNRD3r6PL9UQfUxUQiuOuHHmHkXj11reoKYFpb8Pi+BpWtDP0Uma/JIQsB5M1JFQsSEgifeNY+4K5Mu0eeET1Jsz9/uPkqZW+W4+FtWGiyhG8tAceA83d64rzZ0eSWFEIvcHVPKUlTFOQS0ZkD4ZCXKlclXx0+Td5/vb/Ml33R5K3eOWKXzBGlxQnAb/IiwFuWCa6crJEkCal1knOTwnOnGEG3X0ZusIkv+F3cw5xlzPDAvUgdDklPgpyASjIHE+D/fK1zDSUJK+d5ezVRy6+NO5k+yAJ0nBl1Z6e+MGiL+DjFBgJQWz1UXE3MCgEYmlpgB60VEN9F21n1uUY3SFLEDQMpz03FM6mf461SwBR5Ojsh5BkfaImnWHhNHr+HsZpL8+DHe6IZ9rdV5J+/9VAQZSivjnKsXW3bTIYdnzLdrp3T3JmT9NicJvCI2H+IfE0p
 1cqIvHWb
 Kr4fF8TB67MwTgPlgQROOsm76K8ohdJIo5+2/gbnKwSAmi+upGDHxLwSPP1Cqy65e5gZmE1XIuyx91G7gRH+dqtKgJbGhw9t0R+/Y+Oe4OPWRDXTZJpsfRFO1sVIAGYhLJDN5dTNuftj+CWBiIspqLjtySC13KHoz1rVKzb1UbyWKT7dMO3wZnY9UzE1GAf8p0oFpHjZBok8rFhuRNVKMw5RERghZuM+ITUaYej1SXRQKMT3D20AAV5NWT2D79ZVlrok6F/mTCYsBzUIZF96gtO1KjYDMd2yB06047qpLOYh6p+9TEfqY7Seyks4SraBprr5CYprVhSf8SWR5Rynxd6AaNxd7RmT1GYi6RvSaRQ9qvB/h/GAt0veaUzakohnmtux8HOjeRhTE8iRG/Tx8KK2P1FnC9kH9dW0QWcp4lo+jA+nqtmIHXn/vZo4dD49lnz0J7TvTqUFSP2MSzVKqC1lZx7rDw6TZ/4URHt+YJwZ9F+0ruaHuNmnzebXdCzuY+1y0XsoJq3yqbhEOxXAkhSjqyp8HQCDLdTWxGh86iQXK79lvAJsioWRo5Ovapr4BSCizveQxvp0N4Oi4v5c7mruYQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--u5gbdmp2bzg3luyu
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 0/2] selftests: cgroup: Report failed checks in
 test_memcontrol
MIME-Version: 1.0

Hi Sebastian.

On Sat, Sep 26, 2026 at 07:51:46AM +0200, Sebastian Chlad <sebastianchlad@g=
mail.com> wrote:
> test_memcontrol fails intermittently, but most of its checks fail
> silently, so a "not ok" line gives no indication of how far off the
> measured value was. This series makes those failures print the observed
> and expected values. It does not change any threshold or pass/fail
> behaviour.
>=20
> Patch 1 converts the terminal tolerance checks to values_close_report(),
> as was done for test_cpu in commit 4cdde87d723a ("selftests: cgroup: Use
> values_close_report in test_cpu"). values_close() is kept where it is a
> loop or retry condition, where a mismatch is expected.
>=20
> Patch 2 reports the "memory.current < 50M" check in
> alloc_pagecache_50M_check(). Because test_memcg_high() calls the same
> helper expecting it to fail, it gets a quiet variant. An alternative
> would be to pass the flag through the currently unused void *arg of
> the cg_run() callback; I am happy to switch to that if preferred.
>=20
> With patch 1 applied, we observe at times failures like these:
>=20
>   not ok 3 test_memcg_min
>   [FAIL] actual=3D18722816 expected=3D30408704 | diff=3D11685888 | limit=
=3D7369725 | tolerance=3D15% | actual_error=3D23.78%
>=20
>   not ok 4 test_memcg_low
>   [FAIL] actual=3D20852736 expected=3D30408704 | diff=3D9555968 | limit=
=3D7689210 | tolerance=3D15% | actual_error=3D18.64%
>=20
>   not ok 4 test_memcg_low
>   [FAIL] actual=3D14364672 expected=3D22020096 | diff=3D7655424 | limit=
=3D7276940 | tolerance=3D20% | actual_error=3D21.04%
>=20
> These are the child memory.current checks in test_memcg_protection()
> (expected ~29M and ~21M). Their tolerances were already raised in commit
> d2def68ae06a ("selftests: memcg: increase error tolerance of child
> memory.current check in test_memcg_protection()"), and the values above
> still fall outside them. In the first case the child is about 38% below
> the expected 29M. This series only makes such failures visible; whether
> the expectations or the tolerances should change is left for a separate
> discussion.
>=20
> Changes in v2:
> - Patch 1: pass the measured value first in the alloc_anon_50M_check()
>   values_close_report() call, so that a failure prints actual and
>   expected the right way round (reported by Sashiko AI review).
>=20
> v1: https://lore.kernel.org/all/20260926034923.31718-1-sebastian.chlad@su=
se.com/
>=20
> Sebastian Chlad (2):
>   selftests: cgroup: Use values_close_report in test_memcontrol
>   selftests: cgroup: Report memory.current shortfall in
>     alloc_pagecache_50M_check
>=20
>  .../selftests/cgroup/test_memcontrol.c        | 50 +++++++++++++------
>  1 file changed, 36 insertions(+), 14 deletions(-)

AFAIU, the test is catching two types of errors:
a) running under global pressure (preparations already fail),
b) mismatches in expected values of protection tests (after
   preparation).

I like the reporting of the latter -- with (only) that all consequent
silent failures would imply^H strongly hint the error of type a), no?
:-)

Thanks,
Michal

--u5gbdmp2bzg3luyu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCasz5FRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhGygEA+E0rmCsu6Ho27N1p5NB3
Lk11r2ujJozxMdTi3dbS1r0BAK1DXnSYhASHxLY7xCWsydP9u68Z2lTjRkyysntj
W8gI
=dP/j
-----END PGP SIGNATURE-----

--u5gbdmp2bzg3luyu--

