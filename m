Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C442ECCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB1C8E0021; Tue, 11 Nov 2025 14:01:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26AF58E001B; Tue, 11 Nov 2025 14:01:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132CD8E0021; Tue, 11 Nov 2025 14:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F341A8E001B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:01:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B753E12C61F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:01:22 +0000 (UTC)
X-FDA: 84099244404.06.B5CDFBF
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 02172C0005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:01:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TLEC12Pg;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf10.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762887680; a=rsa-sha256;
	cv=none;
	b=1iomozkCW2IIzkigUc5/8vI8CmsL9ruhBfbkWMKodx5MW07iLTG5xs5r9IBWoqqkzTUs3e
	+ntih276gNjpDyZLGEvYh+9SR2MLVu1Qt4lvyDl5X4D1SapECBY+hm+i3TX7FH+JvzrifH
	CLqbrD/K3D1xx0drXorQgFBvVP+06Cg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TLEC12Pg;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf10.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762887680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Epb41NgFerG0tgs3sczL0A6VdBeDJhkEgRYHHk2JhIg=;
	b=LDXvazul2lr8S1f7vnA5BNokcwj9bjulqya4gOwK/DssHd+iZ0Ygy4GpyN1+jAyy5tVIqz
	IutDjkrF08dAgM3rHCTIR6bsRxwRhgR5ZGxzjQ67Yl+6xYj6d172QsSuAzHhFzvBN0xXlx
	mP5cmBQZ9IPinuV0mqkdeQMQ9q2Z0o0=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42b3b29153fso1632985f8f.3
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762887678; x=1763492478; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Epb41NgFerG0tgs3sczL0A6VdBeDJhkEgRYHHk2JhIg=;
        b=TLEC12PgZTX9c7NYfQ5vXlQ/7E6eDQZGb1gXB8mgqmIyba1Py0XfIBAKDwePPXSjC3
         lYdQESTqYTP+DulKsHxjxHzq6KGgcBsTCF6DqLJuqLjDVylml6FrjM5EzJbCcg6c8P5I
         nl8U66HLDIRYZJtIEG2z0UU5TJEiu3fssiE4BiicY0Y5uUn52FTLv9bkoIVwAjWzO4/a
         CejkiC8wd+F/h+MdmG3G8pQ5g4S6GUPWGAVLXy0Kk/d7g1cil9qbClo1f+2GtJ+gB2BQ
         5P7kjrVe4JcLvJwwUU9TM8Fa4ftbiOL4HrpcNKAFik6s5YQ3rkAR5LqdPCBY0Qpxpvg4
         0OGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762887678; x=1763492478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Epb41NgFerG0tgs3sczL0A6VdBeDJhkEgRYHHk2JhIg=;
        b=E1rNSGIV1+hcaF7/08XJAuA4PMk/XomZycvKjfW+h8pnB2k9HsvTcGb5aQMuBETWZK
         G/zKQLyUDG9uQjv7HdsBhkOSFSB85CMCsSEfNz34BHQMMsUerGfGVcVtwn9uo55lMNQd
         /IM7CYYIlFjkdQGASRSccuvUQTn51IRs5bzJmVkM6S9Ys6A2J9zaWAg4FviFjX/QJZzd
         f4xBYS2BUTBvv1UUmaxD+s4qC4Gmq24pinUeaBYSgz1W7vZVodT4L2UtvXa63BeuW9qD
         kYR0RMUUtpjyf44Bk/zedN2jcqcmNeeHyPwdx6i/1PG0DzGXOfIqscEy/wqxQxQTPS6C
         BSOA==
X-Forwarded-Encrypted: i=1; AJvYcCWstVHKWmE4hxbON+Pg6c1sSolomZ/Kabt8AHsBPyQqwgc7hINHttB7vC9XsuWLgiwSwkjhRqo5rw==@kvack.org
X-Gm-Message-State: AOJu0Yy8SZk8OveqHe5RvflGbwSwzT3Z63j5MZX5ukihmejZX2hL7/bB
	VUjvRaWZ6GgVIosnmmsp8KjOg0yg+KYgdz+ReJLQchM5C7ldbGre/A6g5eKUDALHLwg=
X-Gm-Gg: ASbGncuvVnZT9r0g7NAc3VQcSfj3I3TJLmVjtDLp0vfOLwCZQ2WV7aG72nL/zQgtrnt
	FtdFqspBpSSVD0fFT4QuC1LeZ1gVf6MatPjeFjx7lxcLWt/cGBcydPQ8jG3J/Br6FdtOwSxzO7p
	rJaP0O+kvexLaC+BFlsgeF2SJ+hXtAP1vrkzalAMWv3p1PQI39gGwdHibpeIbmZDzpUfkiFWKb5
	7tZCm7amTNulYTZbAR8/gsRfCqqy5Tgc91MDckRRM0oOo8ZqF9Bo4d97b2utFHXex96fMjorql1
	5rvEEGsrBJqScbiH1/4bLqzmnh9qpqEdU1DsGl3Ti/57RdzPaKTgGPxb0yty5yUXoVKn1vf74YH
	X+W2h/Y6y/U+oitMBxGS85xoExjay7243qKEecuXSCz9oHXdta+b9tscqeW4QebMhWNl6Lmgggd
	3vfWxMn286L/5SvAp64JO8mTVqUPQieAs=
X-Google-Smtp-Source: AGHT+IFjd4Z8ZyYwgjnX/oawjyx5P78Okty05jRhzRxhhnb1ZsNUnhRLUldhAazDANfsJjvK+WSEYw==
X-Received: by 2002:a05:6000:2c09:b0:42b:39ee:288e with SMTP id ffacd0b85a97d-42b4bb8b9d5mr281057f8f.13.1762887678240;
        Tue, 11 Nov 2025 11:01:18 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b2e052f32sm22848861f8f.17.2025.11.11.11.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 11:01:17 -0800 (PST)
Date: Tue, 11 Nov 2025 20:01:16 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Leon Huang Fu <leon.huangfu@shopee.com>
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, corbet@lwn.net, 
	hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org, kyle.meyer@hpe.com, 
	lance.yang@linux.dev, laoar.shao@gmail.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mclapinski@google.com, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, tj@kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
Message-ID: <5xyq3w4jlewi4gt326exj45piti46vrsqkxnh4jzxmsgl24rm6@ivoslsgvgkp3>
References: <ewcsz3553cd6ooslgzwbubnbaxwmpd23d2k7pw5s4ckfvbb7sp@dffffjvohz5b>
 <20251111061343.71045-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="csbfp2a7l72eto4t"
Content-Disposition: inline
In-Reply-To: <20251111061343.71045-1-leon.huangfu@shopee.com>
X-Rspamd-Queue-Id: 02172C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: 1hawbj9ygmmsjjd4qz75xo8sy31rip6z
X-Rspam-User: 
X-HE-Tag: 1762887679-437894
X-HE-Meta: U2FsdGVkX1+NtOMY4cUDVkU4bgIXPgIgy+ZAMeM0EhMb/4rDBqQVuQKDkgmT5i3CMiZJ/np5Q5kElDDBkgNmhtz/VG4wgUKp9mj02yA/iI1Sa6EuhvWS03mXRpceWsXZef8iUin/rIiaW11hC2Zsb5qNAeU38P7OVfSUjj3Jv/U3aMBoO8p4tF+7gDBpYg2HvLtJQbetJxwiBRGe0W3XpgsWHS7rWtr19VnJ3xq9Lzm6Zk0951PgWaG77KhW0vrcxKsY4OhCtxBqjiwN+mwgaqKSh9tRcgF3at3xQnNcojs91ceyFukZ5g9gxeyiEFbtTx8E0rPKdxC7vgtZKD6EzyhzIDLrpPnXEXRMJ/AgZmsh3qTPMdfMoo31wWFVWlKtmKfqkN1X3HJv6IHYdzRvtaETApAYBd0Ys0W+zBYG5DYrVMU3xzL+hMVMziKwCL6hpl6U9l1cFj7UhAGdWhvMDXAUWw9RuiISErNP1c23obuXhr+LFWlHqAFekijd6oeqgt4rPwrziFNH85PjArR+ExV/uFwhQOlw2JY7s9w0h8NWycKDz6ebLFHX5vqOoUonNphaNhY+tZ/an5Yy5UH4BIX+9oPtcQhc3CeIqhSjE9PCDSz3sVhjv4ekIL4h20ACoDSjdPqV0x4+ptphgBM5FLk63ht3/mAteMu0XNMglqrHNlasrAk9pKCYek1y/icQb6pLly6fq2ycsm52V3aobceFlnu0+inL/J48yEmNmaOKFzkwYVoMmSjC2FxGrnLFp0rstoKPIQTUKfyz6qUCP/vvLoSLesOOAmFi5YUy6A+MOmQZLDB2onVumQJo1iitJ32iiSbBahPECjt/FR53hbn27TdYKxWYu7bUl+HQN3CWRXHKQhUtGUIUT1n2ciacWKtj+8o4WqXDcJs486BjN+rB9Rs2iFYAhKJzzX85zOs0+hCzThu5/hdhC5SxUylTcTwMElMbnZvsDrX4oDY
 f9Od0LA0
 dp+4Fm6tAlsfFphh138Ml9dhUNQ9TvIEXpqeDZ73LufHJD03vGi6W0Q3cBWO2O349Ip15rI2uRQU63ixjIjyMuZC0cl/fZFaCTZm71tphF7dwCicEOflit6EgvKEGkHwdUXi1r5ACxc+h1WeNcw2qt9bHPQxy5W6S+PxOJk7ysp3fBZCgp+54uSwgSry2N2iveHW7mRcW4nBnKlswTc5OawgfMgAFPyiAllPABQXZHsyupZvKb40rRncIUTeMEBxjm9fadwx6TFNDyx7zraN1Sgyl1jIIkPbRB46stteD3mj95IBoTtYksOFLvAtiHv5RDURkexgNYmM88B73ExYXzDmx6U6Vk/KA8opcbg9/KL78YPRy82rXm3aKeXOn1kvrGODjWJU5takxM0LELOopZBVrzjgDtv5DOMHqJ0ZMPCcazuBJssGr4buCLmc1M2Ei3YHVSK5IY26M0DA9Nglj4T1cVHaI4b6R9ldyVbLHxi8CQP6BJWH8mSIHGYgDhQCwH43s5z3AiNYxm6TtEJ3KKh7GNG5zpFi/38WbGCIfIHOuREMQaBcxPnTEvA5fr1fMPbkyVVoHE5MhRucraYivxMTRoJYbtzW7PGY/CK3ft38V2JU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--csbfp2a7l72eto4t
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
MIME-Version: 1.0

On Tue, Nov 11, 2025 at 02:13:42PM +0800, Leon Huang Fu <leon.huangfu@shope=
e.com> wrote:
> Fewer CPUs?

Your surprise makes me realize I confused this with something else [1]
where harnessing the job to a subset of CPUs (e.g. with cpuset) would
reduce the accumulated error. But memory.stat's threshold is static (and
stricter affinity would actually render the threshold relatively worse).

> We are going to run kernels on 224/256 cores machines, and the flush thre=
shold
> is 16384 on a 256-core machine. That means we will have stale statistics =
often,
> and we will need a way to improve the stats accuracy.

(The theory behind the threshold is that you'd also need to amortize
proportionally more updates.)

> The bpf code and the error message are attached at last section.

(Thanks, wondering about it...)

>=20
> >
> > All in all, I'd like to have more backing data on insufficiency of (all
> > the) rstat optimizations before opening explicit flushes like this
> > (especially when it's meant to be exposed by BPF already).
> >
>=20
> It's proving non-trivial to capture a persuasive delta. The global worker
> already flushes rstat every two seconds (2UL*HZ), so the window where
> userspace can observe stale numbers is short.

This is the important bit -- even though you can see it only rarely do
you refer to the LTPs failures or do you have some consumer of the stats
that fails terribly with the imprecise numbers?

Thanks,
Michal

[1] Per-cpu stocks that affect memory.current.


--csbfp2a7l72eto4t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaROH+RsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AiN9QEA6sXoc/oeJj+mDnKkROmk
nkeyTszvrZYKIEtJBQFSBuYBAJ76dUKkXJVOhrMBSE2sGSx9Ye0xq8mM3w8ZTrQk
jKIN
=qop6
-----END PGP SIGNATURE-----

--csbfp2a7l72eto4t--

