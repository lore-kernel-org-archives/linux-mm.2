Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C8BD107639C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 18:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1B26B0005; Wed,  1 Apr 2026 14:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652A26B0088; Wed,  1 Apr 2026 14:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5414D6B0089; Wed,  1 Apr 2026 14:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3ECC06B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:41:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA6F8139305
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:41:55 +0000 (UTC)
X-FDA: 84610856190.30.26302AA
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id C0C3410000C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:41:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GHxbN5Cv;
	spf=pass (imf14.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775068914; a=rsa-sha256;
	cv=none;
	b=ods8vtMlWw1fbbmqYROw4J8QoZmuBg6NinBsc1Hpjvk/V8f/K+NaZO68MbSEuRdYO56Mr1
	7XeQtHWTwNu/zmhwD7UtsGwsBa03fljTDIk1lTkpUQKktjQoEwtdH+jqOf8woJgS9oMCu+
	OvXva3u33sfAfwkmEVPYt9MXP9eTJZ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775068914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=diWyiF5CM6MLfjiGHibL/eUp1W0TNuRh03hTNEA1N0U=;
	b=l1CeRdz1XF6lG0M5dBgnVfnsBS0e6PpUpvx6XhqghisXV/N1TdUrTVWmQX8hiH/RW/UX4w
	xCl1UvtuzHKP++UuVVgv752lNcq6WI1XxpAea5C5J26OtuksDCZWlcAojCpyQx+LNpt3D2
	gVovZuXGgMrZGMdd9wkL9NnKlvxtNQM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GHxbN5Cv;
	spf=pass (imf14.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48557c8ad47so347805e9.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 11:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775068912; x=1775673712; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=diWyiF5CM6MLfjiGHibL/eUp1W0TNuRh03hTNEA1N0U=;
        b=GHxbN5CvGD8Tjgnii07kxKCQeOVydjPMLtdtofOTnCEsKZY87WyRe1RC75DWOICpW3
         8MOGD5hsn+hQLGso0Ryhi/vULCjHVnZfap7Bbr/UZ+XwHMBhKhC3/NOd6xIwDG2hbgvh
         64u+yHmzpiSeDklgwWMIqpgiV63nMyR5y+khkcVwZmB42k3eiHYjVRRdeP4Q96EnOtHM
         pzRXI1WgRFamQstNOYPOS238sQQUW8/9sveWmxMXqY9IV9KyllUbZN5rp7kX2tes1nKf
         zuoKXRdKOCD69ZtEyN8yq5UR65ijCXC5X4ZdiDfZEY9TYg3Giqql+4GDKxIkwFJNHh9M
         //0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775068912; x=1775673712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=diWyiF5CM6MLfjiGHibL/eUp1W0TNuRh03hTNEA1N0U=;
        b=PTwBkmKgZnESvzhwu0df2vQnjgsqb1wy2R7qUGa27Yg+SEXqKSrNUS1dT/XT0Amn8l
         ZSHbzfFl7PTwfKfTfIx50zc8kMqeiZGKYXOg/XZvlHFyCf/uxzlHfUHMATgCu2ttlKNH
         DbDtS44xuG+a5UR06VlaC1s7mHI3TixWiix1mv7sZcgVwWIY0+D1LrLGB7H2QQVtiElG
         Y3vd5EZp28Jjg0KVOg3sXwNYMFxNrYdWyM40WS+LHnGEkKKSTON540CIct1rN3lUMbNb
         xM6kIZC1PHS0A0WIWRaqU8lo2gD6d6o4SYQU17gF1ERgMqHtlEGK3YWOODGqgIAMF8aW
         X4+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVrNc5yNBrGAHSccwwRk+KSGujfTpx3G00RHMTUzJ03ErV7GNR3V1fjF82IICldRWxz3cKck6GQ2g==@kvack.org
X-Gm-Message-State: AOJu0YyRJ67K0+I5cMSw+JGkd4kvMoMFb/r5vMAWdvVSDztFRsvXF4ag
	IeL9d4PiFAMeY7tmhZbw7hMdQnCgoUTHsn2iriiTdoZPF8psw1J+JVtQ6g1yh5ElC8E=
X-Gm-Gg: ATEYQzxMlb2TYyz12F1UwXR5ED2k9EwavJSUKuGgbySIqvH3r0qyZABJdlSnu7hjoPC
	0CI5ldymoX1+7AJfBiZCnM6HiBQQPNhqMHC1h8aOK/6TrGdGhC8otoejmI5mSTZJW8a9g0HFg03
	0kHuI8/e1MtFOhIYn3PLWZTzSCHXEju7N8TPNyiEIEUiPIH55DWe58hJ8U1k5eUChnu9IvKbtjz
	TOAixd8gakBijHdrnEl2q6B/TPd6bOJNt414IHa/cWlS48UIXqre26nzsjaBO8VgSI7slxoXUoq
	KcISHEqQQoXPWbaM+yEP5uw0i2baPLX9HMdRAnsmVWHCtKTi/wSwMwB2dRgK7m1l8Es2+qBOrfh
	0FAicQmJ0SffdIg/48Vqr/sNTyJvnrUepuOZzPLrZ1Cn3rFont44plJuAvYJdPCdmovxUMKJmcN
	Azz91yHxHVnrweICT3/oQ58+frb3cBB9bjJYfMqN0my/Q=
X-Received: by 2002:a05:600c:1798:b0:488:8bdd:cfde with SMTP id 5b1f17b1804b1-4888bddd1bemr1447595e9.7.1775068911853;
        Wed, 01 Apr 2026 11:41:51 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887c9250afsm49170605e9.36.2026.04.01.11.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 11:41:51 -0700 (PDT)
Date: Wed, 1 Apr 2026 20:41:49 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>, Sebastian Chlad <sebastianchlad@gmail.com>, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>, Li Wang <liwang@redhat.com>
Subject: Re: [PATCH v2 1/7] memcg: Scale up vmstats flush threshold with
 int_sqrt(nr_cpus+2)
Message-ID: <n6mhkjsxsami3qmczkdh57eep4lmcgbtyl7ox3ajzveke44yf6@m4bjevvsr47k>
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-2-longman@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="isa3i4d4tepb4cvo"
Content-Disposition: inline
In-Reply-To: <20260320204241.1613861-2-longman@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0C3410000C
X-Stat-Signature: 3pkn1ziywyru5mytcg7ezi9k7wtnb6io
X-HE-Tag: 1775068913-713897
X-HE-Meta: U2FsdGVkX1/HLo8p3b8VGyxwiIv+TX+C/BmX6SP+i4h55f7msL/8gXWd/fezV/owZGhoSZK339WD8QLh9/02HUpCO7MXrsREdzZmBayfp+IHm7vC7CCcatm9AhtYoWxUSMMAFjLpBJVFe9EqVPJb6kWJm62IXsXpZO2h0edeGxQ5xV/TTi3QTY+z37ylOdzMVIN6NSexHtzCZ5Ou49JUFTwDqLgcVjQY0Z2xOYR4xNb5KOP4oVYyqgnEoNY+GK+f26dMiJ2dOF0wYTJb36uqqFRGuQ2QgAX5GwlwuQlAia3jgp6ZMRmRbC2I/IxT5ytDNSCd7xc+IHBe6x6ntKj/8W1Y5BPtjxSNYoARYWbpWkDN/UvI03Fsbf8+xkE5XE9AXFKbxfrb0SB+DO7YcyQg25RP3DGLK5r/RBlpQkLKhTu+3ue9vSm5HmwueYnOW36CY2chjmqp0fpSHFTYal/h39cQjmvyttTyom5wUH69JcXuURrZvW+oTIaWVNY3BJLhkNJZB9qugkzba55fZENb0FyLmNCk+h3mae+gLxrJpGE7UQWrG1bN9WcUjflOai+6q853V+rkIgvbELEiwhLAf3VCdSqCwD8TG0FJGU7Ggn9tC0V2wuE9KE5mh2ntq4d2Hhg9AdLq2+EoM3QFEZRtql57/hl224jS5Zk9I5PByGt/aEdI0dyC/iMuoGhvldAzdEkmD66SGpuDFP/+rqo0ddQfNiNDb1RcwrMmE39HQwtQU9hA879xJGDD4NPvUUuS0qTHc2z6Z5NCXZIskOpo1uD7ExwcNQkFPvJErDpsb9H3iAcerOJSKY2MDVrHIO8RLgrwY8360GhGv8XtN+FRiCsdNhXOIPANcW0c+YVLPdsc3RxaaqMYgwJo+YqkKomeyWtFaz7EPLFrneJVrHJHFxX/g3X8TbWhOxcXrBULZNZae2jegPXozV3kShf3qhGkUZFKlmNSGZ90mp4nAXJ
 id0ZjEmD
 Pf4mFviN+vyfwdWYnQlwYO8g6v0r3g5mC25vVqDHF1UFGgHz5MMssTJuA8alNSaXGFN69sP0onOiE9cogSdFn0nRic1k33cTFJDvLL4ys981v/MgXJDA83IcFie+0JrxdJak/kpbCZ9CEqNzAlLbzKHtnMST467b2150Vwfe0kURqo6IfevhbgKWmdbD7Za5sNmZNmthTGiL190/hqDA8UfS4l9EdUsDcmvIC4t3CtkL5bKE3kmJcdDSXOjgimc6ejdXr6iXcB5mQPZIFatRjJ7pzCjTRbW8TzZy8jOp/277/Ut+2Xz18UeTgDepr4+FpC7ZNJkN9jXOVO71jWvRgmIq/kDgW1F0L0V88GTJ725bB/XYWEWYi9BhhKoS550kow2zHY2a+nL99qXpQ5TXen4mAmp5t6fU0wymyGuvLdDXLySzkHyYQRjVB+RGlzqOGQsQfYQu/LQIBIFW0ZZZIAk75bumLHBfnoHRNZZIs85MzgTpq4/AulCgNtjDGxtw015EbI/d/lYoPlni59sHIz2RDnV3b/H4YArvnqPdRZloxcPDwdp9z1Y/acROs2HH4MygavuD0HwxCi8u/KlkZ4Ou7Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--isa3i4d4tepb4cvo
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 1/7] memcg: Scale up vmstats flush threshold with
 int_sqrt(nr_cpus+2)
MIME-Version: 1.0

Hello Waiman and Li.

On Fri, Mar 20, 2026 at 04:42:35PM -0400, Waiman Long <longman@redhat.com> =
wrote:
> The vmstats flush threshold currently increases linearly with the
> number of online CPUs. As the number of CPUs increases over time, it
> will become increasingly difficult to meet the threshold and update the
> vmstats data in a timely manner. These days, systems with hundreds of
> CPUs or even thousands of them are becoming more common.
>=20
> For example, the test_memcg_sock test of test_memcontrol always fails
> when running on an arm64 system with 128 CPUs. It is because the
> threshold is now 64*128 =3D 8192. With 4k page size, it needs changes in
> 32 MB of memory. It will be even worse with larger page size like 64k.
>=20
> To make the output of memory.stat more correct, it is better to scale
> up the threshold slower than linearly with the number of CPUs. The
> int_sqrt() function is a good compromise as suggested by Li Wang [1].
> An extra 2 is added to make sure that we will double the threshold for
> a 2-core system. The increase will be slower after that.

The explanation seems [1] to just pick a function because log seemed too
slow.

(We should add a BPF hook to calculate the threshold. Haha, Date:)

The threshold has twofold role: to bound error and to preserve some
performance thanks to laziness and these two go against each other when
determining the threshold. The reasoning for linear scaling is that
_each_ CPU contributes some updates so that preserves the laziness.
Whereas error capping would hint to no dependency on nr_cpus.

My idea is that a job associated to a selected memcg doesn't necessarily
run on _all_ CPUs of (such big) machines but effectively cause updates
on J CPUs. (Either they're artificially constrained or they simply are
not-so-parallel jobs.)=20
Hence the threshold should be based on that J and not actual nr_cpus.

Now the question is what is expected (CPU) size of a job and for that
I'd would consider a distribution like:
- 1 job of size nr_cpus, // you'd overcommit your machine with bigger job
- 2 jobs of size nr_cpus/2,
- 3 jobs of size nr_cpus/3,
- ...
- nr_cpus jobs of size 1. // you'd underutilize the machine with fewer

Note this is quite na=EFve and arbitrary deliberation of mine but it
results in something like Pareto distribution which is IMO quite
reasonable. With (only) that assumption, I can estimate the average size
of jobs like
	nr_cpus / (log(nr_cpus) + 1)
(it's natural logarithm from harmonic series and +1 is from that
approximation too, it comes handy also on UP)

	log(x) =3D ilog2(x) * log(2)/log(e) ~ ilog2(x) * 0.69
	log(x) ~ 45426 * ilog2(x) / 65536

or=20
	65536*nr_cpus / (45426 * ilog2(nr_cpus) + 65536)


with kernel functions:
	var1 =3D 65536*nr_cpus / (45426 * ilog2(nr_cpus) + 65536)
	var2 =3D DIV_ROUND_UP(65536*nr_cpus, 45426 * ilog2(nr_cpus) + 65536)
	var3 =3D roundup_pow_of_two(var2)

I hope I don't need to present any more numbers at this moment because
the parameter derivation is backed by solid theory ;-) [*]


> With the int_sqrt() scale, we can use the possibly larger
> num_possible_cpus() instead of num_online_cpus() which may change at
> run time.

Hm, the inverted log turns this into dilemma whether to support hotplug
or keep performance at threshold comparisons. But it wouldn't be first
place where static initialization with possible count is used.


> Although there is supposed to be a periodic and asynchronous flush of
> vmstats every 2 seconds, the actual time lag between succesive runs
> can actually vary quite a bit. In fact, I have seen time lags of up
> to 10s of seconds in some cases. So we couldn't too rely on the hope
> that there will be an asynchronous vmstats flush every 2 seconds. This
> may be something we need to look into.

Yes, this sounds like a separate issue. I wouldn't mention it in this
commit unless you mean it's particularly related to the large nr_cpus.

> @@ -5191,6 +5191,14 @@ int __init mem_cgroup_init(void)
> =20
>  	memcg_pn_cachep =3D KMEM_CACHE(mem_cgroup_per_node,
>  				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
> +	/*
> +	 * Scale up vmstats flush threshold with int_sqrt(nr_cpus+2). The extra
> +	 * 2 constant is to make sure that the threshold is double for a 2-core
> +	 * system. After that, it will increase by MEMCG_CHARGE_BATCH when the
> +	 * number of the CPUs reaches the next (2^n - 2) value.

when you switched to sqrt, the comment should read n^2

> +	 */
> +	vmstats_flush_threshold =3D MEMCG_CHARGE_BATCH *
> +				  (int_sqrt(num_possible_cpus() + 2));
> =20
>  	return 0;
>  }
> --=20
> 2.53.0

(I will look at the rest of the series later. It looks interesting.)

[*]
nr_cpus	var1	var2	var3
1       1       1       1
2       1       2       2
4       1       2       2
8       2       3       4
16      4       5       8
32      7       8       8
64      12      13      16
128     21      22      32
256     39      40      64
512     70      71      128
1024    129     130     256

--isa3i4d4tepb4cvo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCac1m6BsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhqDgD/ZH5FdNATX0Dm9ldZMHyS
oV/8qO6gLgjmu8goJGbY7NgA/Av2MbsmiWijOj+3I3XEmPfOtsPxWjctyieoz9ut
LtMB
=Nhw7
-----END PGP SIGNATURE-----

--isa3i4d4tepb4cvo--

