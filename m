Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0BE1CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A576B00B4; Fri, 22 May 2026 12:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142CC6B00B5; Fri, 22 May 2026 12:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F346B00BB; Fri, 22 May 2026 12:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBCB26B00B4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:48:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A8AB1405E6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:48:40 +0000 (UTC)
X-FDA: 84795639600.05.AD72381
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 39B06C000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:48:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LTp8f4Da;
	spf=pass (imf28.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779468518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkkB0hffRR69qMLvhInPQn8c5SMOFLnLZE8s1HedbWk=;
	b=aOzRNMbuquy58nqsAxyp0R2+JyO2F4D0eQ9BqiHhSZl9gnophdgrkL9PmDpUq8SvtyFCIA
	S/etYIi7BDCTA6e2A2SQAL1R39chu1A0+ajIj0fo01aYFdMsmR/ghgzjBWLoX0Sn7E2vg3
	dF+CwxUigPJVFyXE+UQa7r/VEIDlF58=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LTp8f4Da;
	spf=pass (imf28.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779468518; a=rsa-sha256;
	cv=none;
	b=Rob1lJox/V0Z3VgqM6W9ekqQFmE+CTVsQggVaqQV4qGHDKEwaVlRulXATEUA0ElZ48KyJ4
	R14z7RHEaGTQCTMir3bTbOZgWQqNJALNnYp4xFGYGsrQXlrAwS2Qx/ACYvsKcbIxi73+D5
	EXhjOxJHak6CyQxsf+LVORX8d3T9j7I=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d7645adbdso5120443f8f.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 09:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468516; x=1780073316; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RkkB0hffRR69qMLvhInPQn8c5SMOFLnLZE8s1HedbWk=;
        b=LTp8f4DaGTmeoSLL5bc4Gc7UL7H7qBYbLLtmX82vneKIS+25/Pof7wX1aSuO7Eytwt
         OmG/7lxEvV7qaKLDtd36TXM5vPDWv4uVrrK471rnAUXOS0e32eGnQxueUHMFvKYQURel
         lBKzin4CpJXZ+/OV7Qx5tsQqxbpbgvnmQHXjirmzC/aOwnLhcRDtltdkq8i6zj1N6MrV
         LjU8thtvMxyrATl1KAAPY4+XHrET65Qy866ylluM99l4BeOIxjau3ghTYBKbavD62FUb
         6Va8DVDHnpGf609MF/cO/FVaegsAB5vt8t/NYWcGkMyci/nF/LnRzKizMaF5WLgk92Z1
         8MIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468516; x=1780073316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RkkB0hffRR69qMLvhInPQn8c5SMOFLnLZE8s1HedbWk=;
        b=aPXx6tSFblpdN6zY08am+Q7hhTQxgCZ/PQ3afy8bd1i21nJLZOBD6/Q0X4vyRQVpwF
         e9GAcw5sHH09BHqH4YvG6KHvTShrls+RxGjWxfbhNvSq3I1GS9p9z+HryuX2ks5SdIYu
         brerttRu+3CuWLPXjz4EUdGwiFYychdxjozYKz7M/3fxs4iEx38yhho2ranjS2waMVFf
         wi+3GmDJZEJWtgllrEdgxSpiQEpqxtlIayobgkkUuEC4OZgxN5TphB95BayvZqWZY9+z
         GNYmm7tgk+QfqT5As4I7eZMiaKiZELEPnLUNyxhRfZ7gQmguMl7fycDk9Sw2uxkTQPBA
         DTyw==
X-Forwarded-Encrypted: i=1; AFNElJ9N+BkwNgMiTiohFYwboiVupS4CkEblvhPsjERIxFmNGS9xHaPbKXQvxotNzIpHdRv2DLuPDgyGFA==@kvack.org
X-Gm-Message-State: AOJu0Yw3IY2kJWD7hhCZ+o+OuLCxytXxT84tvjAbEwK/vbNc8n12EFvd
	curiTRr28s3rG83ZP7b4jJB3ikICCH3yLRxTSfEhXwAXNzCtErJ6P5jUCt85hVETazU=
X-Gm-Gg: Acq92OEs6nUQ0l4KtnB1ycoibQ3snxxHcspbwiVhSmTLG8Mo+Jom99M7ZGF3O9cWgzY
	pdL18FsX+prwXDCGacBep8V2jt8Z8LoouB05g/qjPvfRtxR/bSWvtBr+32GmHG9xn3CaOmhe8Jk
	He0aexSbc/9rQm1XWDFZhTgYSi93Ii2W248cz7HJpaQIVhV8GxyeQjBMrCKzu3mCXWu41Xhi+Qt
	E574gTV2Z7vaTJ6TLqC4pd/ecu/omsGypANS4d2sBpbUXoyH30bNkkJsYEhsr+AlFxjekUR9N00
	nlFTFDzSe3YdZLxRWNqn+NR+TiW//Pe5RoNfbl1qM+/a/dbH16PA7vzPOVWwtqnBeerkOOJJKDS
	5ZEOdeWdtNjUVQO8ilasnv00Cq3WgunzWZwXmousSNo8wpUixJgFnFcSzosKaIN6aVE1JU8UWF3
	UT+nTG5cHn1dvrmau6f4J7FsqD2xvno0QfhCnLUGTJfOzZPB1z
X-Received: by 2002:a05:6000:4283:b0:45d:8c16:5566 with SMTP id ffacd0b85a97d-45eb38baadbmr7082103f8f.18.1779468516497;
        Fri, 22 May 2026 09:48:36 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d70d89sm5769908f8f.37.2026.05.22.09.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 09:48:35 -0700 (PDT)
Date: Fri, 22 May 2026 18:48:33 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Maarten Lankhorst <dev@lankhorst.se>, 
	Maxime Ripard <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>, 
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	kernel-dev@igalia.com
Subject: Re: [PATCH v3] cgroup/dmem: introduce a peak file
Message-ID: <ahCISfTlN10gD8e6@localhost.localdomain>
References: <20260514-dmem_peak-v3-1-b64ce5d3ac38@igalia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="27zcqpjzhteuelt3"
Content-Disposition: inline
In-Reply-To: <20260514-dmem_peak-v3-1-b64ce5d3ac38@igalia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 39B06C000A
X-Stat-Signature: 7h6ncot8x76hdnsird4migtc53unqmkf
X-HE-Tag: 1779468517-984995
X-HE-Meta: U2FsdGVkX19/LIMVkddoUVjEyevT6Of9cGMpJIt/TLCwly4iDdrjtzUtrK26anMrX/riXiV9Ym1cM1QN5jC4G3YS57rKbjVkpYnpr6kydM8fh0eRTIeGRT8tRKtDtzhSrF6VwRPQ/utqfrqkDUow88jAvGCuGwec6DrGoQ6fesGJbniTGlaMfv0dvI/Vb20iZt9ZvNyzkk3GI/wrzuqMVMJrTZSbx+CGL5KGVaZcLhTX6Cope9rONy0HjviFP0h5YjVYu4mX0rXlf+3XBhEcosRW79Nk5rpyr46PW+pfiWwBUxKM5iubL/7EOE/KDjio23lOW3ofqlWxGDZO2K60qzpDHi1uDoZYPvkKwRUv7mfDSKbMHNJx1FKrrbzpMaN89lRPWDu33bt2MmDhPgUHPBYTrYzKkQvDhkFuJt5T+NN2XpUJSUheC2T9qvmn0HJ+0/5E7Zg5+Oz5L5siTpAthDaPS6wQNpwipXXzLVBD23A5o1E0/XrsEJWJu3zlxuDHgILCBjifKBOZV6c6rRs9dHtRb2wx7KHsl/jwj3tfgegLRGYNLBiqeJf536wR2ZPcpFvA/RN2Eaiq1a1JqI6uV+Q9kOZJn7GNimWCkOUcvHWiuUzddY3SRKD2QG3QkAg0ScEoslrcG49DVNnBNefEsjK091lX/3K5lBRq0lTMSafNQi5ciaDdFjEm8TyK+z+3ACMiTfdl5Osdv2tLE2ntDlfWuI8rOy3t+IPYEJFWx+4Hvr9Pr+eiQ92fPga+j4I1XyAGVrkgkUJlrj8anF1Y7h1MUsvqh4pRwoMWuKKJM+j+and8PKOSFcA4VxJGw1Q4/7xCN4VrlXJC6kERewYTdMyB5aF9f3ihk6Iac8TBqdo3tpV3XTA/sI0BJkJgv+B8xFcTc3/fDb1pclD22MIo56JWfS1b9RTBsL2eBjEKMe3bEWdARZP4Hdbn+77QukqPlbODPlfKOyaMQWJAo/Y
 QRcwmJNq
 fSm+2FBUV0gKc7gCFG0pG2lQZstfdt1rfPwcWK39WcXUKZnQm/aauLJJZ75m7IT/IANbcYAbrnmShtOJogbVO6QCketaIqjqvU50+dFKklXX6pOnZolbJVFx/Y+SUvnLyvct/KbxAVFclo9eNJegPQjDmNJuaqSK3f1/m6Q7ZP77CAgPEakTkB5kHPCmdqOho3xE4JeLFiR6g1IVNB2N4hCNCvza0QeYC09Qb4Gvj0weJ5HVZwHpNmL/i/Jt7qZcFkAQsF/XuBsybH7rI5yYqAIIFVXdlqzS6ooZwdxw7qD+bTvabw7rEEtt76SLUd+OTQY9I9NkiKy4sZeJ9NbAQZDihtRdMDZ93u9pdWSG/9EJSgP61+0T97FZgCD8cqMnqT4pVZweTLQE0u7r5NEjELNGUQ3ZJUupHUOUKaZlj7qMaUXbEszahwamR/SE38VrARWOXIhZiSJ7hlgJSUMKh5unBiuuREpBLLvX8i/Y+FARrynQDCudha517Yi/GEbAaG8GNBkz4Zm+T7AEqlPPRUwATaKsjcQau0KcbTHlYVdxfRaSDo3+qmGsscbmmi6YT3QQn/PnUEwCtNfqvvxw7+9zXagD/7VyD27HA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--27zcqpjzhteuelt3
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3] cgroup/dmem: introduce a peak file
MIME-Version: 1.0

On Thu, May 14, 2026 at 02:36:08PM -0300, Thadeu Lima de Souza Cascardo <ca=
scardo@igalia.com> wrote:
> Just like we have memory.peak, introduce a dmem.peak, which uses the
> page_counter support for that.
>=20
> For now, make it read-only.
>=20
> This allows for memory usage monitoring without polling dmem.current when
> the information needed is the maximum device memory used. That can be used
> for capacity planning, such that dmem.max can be properly setup for a giv=
en
> workload. It can also be used for debugging to determine whether a given
> workload would have caused eviction or system memory use.
>=20
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> ---
> Changes in v3:
> - EDITME: describe what is new in this series revision.
> - EDITME: use bulletpoints and terse descriptions.
> - Link to v2: https://patch.msgid.link/20260513-dmem_peak-v2-1-dac06999db=
9e@igalia.com
>=20
> Changes in v2:
> - Make it read-only for now and adjust documentation accordingly.
> - Link to v1: https://patch.msgid.link/20260506-dmem_peak-v1-0-8d803eb344=
9c@igalia.com
> ---
>  Documentation/admin-guide/cgroup-v2.rst |  6 ++++++
>  kernel/cgroup/dmem.c                    | 15 +++++++++++++++
>  2 files changed, 21 insertions(+)
>=20
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admi=
n-guide/cgroup-v2.rst
> index 6efd0095ed99..d103623b2be4 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2808,6 +2808,12 @@ DMEM Interface Files
>  	The semantics are the same as for the memory cgroup controller, and are
>  	calculated in the same way.
> =20
> +  dmem.peak
> +	A read-only nested-keyed file that exists on non-root cgroups.

s/nested-keyed/flat-keyed/


With that

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--27zcqpjzhteuelt3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCahCI3RsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ah3WAEA8jNoGbM+jfh2AQM8AaCh
AP+xdJvR4lj+FHVIyhs6qukA/0scDz7iwckNV/NU40VipKTbHw6vIv1Uo6Y97PJu
d5kF
=dGdF
-----END PGP SIGNATURE-----

--27zcqpjzhteuelt3--

