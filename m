Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96036CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3718E00E7; Tue, 26 Aug 2025 10:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B238E00E5; Tue, 26 Aug 2025 10:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90B48E00E7; Tue, 26 Aug 2025 10:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 900DF8E00E5
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:21:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F049DC015F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:21:22 +0000 (UTC)
X-FDA: 83819121204.16.6D0E9E7
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0DC2A0012
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:21:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EOkv4oi2;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756218081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I+VWRhdnTUjnI3XomDtbZckS18oyRmRBoSQJRcxV7jQ=;
	b=Bwy8sdZg71cip2BtbnYoyXLdMpPwCZ/BgzPLR+MqAE/J4a2Nhl66BKRBCETBq/mPLApJt8
	YoX0+ksYTOJM/Y2AiNgAv3NqD8FChcqsXDwJHDCuwsmG5+CtJhEiGiGdvoXDeTcUA9D4bk
	kLUoFaGuXnXMECgCChqW9OBJkhyGlkw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EOkv4oi2;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756218081; a=rsa-sha256;
	cv=none;
	b=ae5KRH+pCgBEPTabFOivaxYbWR3xr0Q/ccf2Juo6tRyep9NgEW9B4Yy0qmusGSg4AjYnHS
	R+ezLWs7jNrBlAQt4151GsxBT1hBDQITaAd9f8uEM0cjQfLGzVpUTeaKpfIX8HXdrC/evh
	hJUTe6My6v2rn99G9aZchHPD4aGAeYU=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3c84925055aso1991310f8f.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756218079; x=1756822879; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I+VWRhdnTUjnI3XomDtbZckS18oyRmRBoSQJRcxV7jQ=;
        b=EOkv4oi2v9PVY2/k55B1+NVXkiJc7TMqs0YmY1os82Na8O4LHEqQaz4joSKAxsOOnm
         CJuJHyWW3CV86KSD9u5Cqyc93NVTGRpgEILqco6tA7ZqJh9JRQABLO2gT1eT1AkoAw2l
         4qCv3tSF62pxJbPYiDLdy2KvS2YZkGBs7P8LeaOEe7x1BqLmrVoVVs0/9QqoJyfmKMKF
         TlDbPwKNCjeSqwK01kqzJJUN29PQJQPKmzpuZ+Bkn3zGylp/EqNM0x4TmZs37tYJizl+
         8s8l/JXC1Hr38q0Sxoe1TMkz3m7vgIrv+Cciuuj3GFpSWukjj35zsbQ4DJk3ipkCVSVv
         isAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756218079; x=1756822879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+VWRhdnTUjnI3XomDtbZckS18oyRmRBoSQJRcxV7jQ=;
        b=cjMCk7vl1PcPoiTrA65obEM6qICKbDEsbTgck35vhh04uCXagMI1+A/F+tCM0w45IC
         3uqTJZJTAGFH/iBtZxO4DYvW+UkdCxvFnBBwEJoif1psb5fo9DjJXOmzbuIXNsK3JMVz
         hogpkP/ThwiMT4uvgVh8zm1YMFmL0sA9ia1pIfZsMwBpOQcwQiSvWtkNdYGGuys9WDyu
         gxFVi7NQ2TV4SZGejCtLwik87vRP4Z122Wa5EDd2FyQ9AAhPr6j4YEtsAGufDixwzDRW
         3ZmMABBFjqz4ehyVl18CuWOo1H0AlGvBV6F/3VkLDr7XuidBC6sbsrmb8/L/OOfWzXTQ
         fzYg==
X-Forwarded-Encrypted: i=1; AJvYcCXBvJjzio3oZAFXC2neZyx+rODASTZ1cy1hr1Ppyt6PeAkGMo/N7L010M1if6COeY0jhF7+HFQiCA==@kvack.org
X-Gm-Message-State: AOJu0YwbXC69DHDD/4rop6ndgWstDf0JxEAO0R+zPv+9fZSmEaAdRGGv
	DHVkz+yDto88fRz3tVpkCPA+sv2zE+qJcZH9mnCBxKOSJMMoBFrY4KMQ5JdBgzQUFEA=
X-Gm-Gg: ASbGncvp1L1cQB771Y7KuBZWgm+tm6/dM24YbS6So6PzifHGMo7stsWVnttx2XEyW/o
	qqRc1KSX4oFfVICzWtLthghIuF9l90lEhClHe2fNQUbEPn5CE8cDBohowRFSVuWf14E2FTwYCYf
	CYxl6goKhkfmMbSEjjWju6YAlvn3zdqWauvO4jeu+WhT1ETYO0qUlbYPdBPTxcNh6WS2Q2xDKT8
	4pgNXub9F5Oa6BGkwRAcZKyijPyMjA36WaiaYMYlQGTH26QaD0K6Ub6YO8KtxA8eRFkgXVtRJQ3
	aY+9KXstuy1ocTf4gwak2rhmb//EzpnzzQEwB1mZCuoNyq7K9bYVG8b4dhLWWX/NJN8nNzw3jnc
	ATANY7SS+c/DFjUZynyl6rE25O9XHv+NKp12tWGSR0HIhgtinEH/cZA==
X-Google-Smtp-Source: AGHT+IF1onmcmCLINy+0Rdj3SUnLle5wvn3JPSHU/RzbuH+Mf9JjVWxvuwon82t0M3+JcME7Da8B9g==
X-Received: by 2002:a05:6000:24c9:b0:3b7:93d3:f478 with SMTP id ffacd0b85a97d-3c5dce01212mr13313281f8f.51.1756218079134;
        Tue, 26 Aug 2025 07:21:19 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32760f2686dsm377332a91.0.2025.08.26.07.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 07:21:18 -0700 (PDT)
Date: Tue, 26 Aug 2025 16:20:58 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Maarten Lankhorst <dev@lankhorst.se>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>, 
	'Thomas =?utf-8?Q?Hellstr=C3=B6m'?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Maxime Ripard <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"'Liam R . Howlett'" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Michal Hocko <mhocko@suse.com>, intel-xe@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC 0/3] cgroups: Add support for pinned device memory
Message-ID: <qd3ioegpvmrrrwdy2qntxznyrnwq3bhe74lmuxio7sy4sjggtt@tm6nqds3pyvj>
References: <20250819114932.597600-5-dev@lankhorst.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n4nu53c6pb6rlauk"
Content-Disposition: inline
In-Reply-To: <20250819114932.597600-5-dev@lankhorst.se>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0DC2A0012
X-Stat-Signature: 49mskyo4hczbsbe1u8ffqhwo9nem8yoj
X-Rspam-User: 
X-HE-Tag: 1756218080-82929
X-HE-Meta: U2FsdGVkX1+QLd0l+iYD2Lm0lEOFEIdeLLkcwvBZWPNzihiSDIkaqF8zSe475JovzaZHAs9Q8EgP97qM/MLmZqMYgnr3KLPYD41k3zcI2jGIsi50ACiUDIuN+wgiVr9jkSH5JoDE13R1w1XPYoB7ljgUoUWxwbeLDEkwE6ZEacau4Irfz69cnPzGTJvQLPnJALdbU008nGqGbz1VpoRNuNWvw8PmoYI2bW5k+uirpRRmuqlrFm87SRbzN1ScFqUzW5TojHYBqOjOjejcFoq+0tjNOaRj9eFgdEKFCJXRizQrUmghchiN71bR8mSyWsg46cTsMnJZDqXs8fRWqnlsOWEX/SBfyc6zCt9IWZSWq2ccLxGObl6nrIs2hpvqdMHmk6oRIe1wpVe0WRElVXWzWLl+RAls0Tt9HSR/YEDucBrzqXTgmiEofziCulZbz9u0WfRHNX4WOH/RWG3n2bpjckCmTSu+dwtzW7RaM2s8fJs3cRHNjfI345h9tKuSxjzIhaRw+/ePG4BZ8qCjJPW1VdyDP0Wg8AGGEl2PwBlEHZx76+wNC+gfbepQ7f/dsnptJ4IOmJ2YTZBTvZ+TnMe7mjb1+sYxz7q/rLdBnWHk5Ls8YQOZvbH+GNKrxfoo3X3mYtn4d0AN8JKrWUYrqvNu+5uSHlEfMghuKKQ/A7LbqreTF1jTr8hVHADma6L2SL6K34IeRBFWyPfcpq2me014leBJ6lKR2WGmf7mwR8svHZfg6wFBSebIedqW3aGdPTjYRZO/pPrkhkxLIeTZgGCFvn9En2ojH5VG08CBbLCCZXCn5VB+WJJ5WWjHt32sIhup9YAGtB3dWtrSwqIYOSXVvRGWWD0rayHy5pNoqWHrEJmw0JLs+ONABZeUgQCxUjP0/AAl2/qThzuQlu3/6XhPfSh9ZUaxInkBDQ8OLI/4XyNK5sUe+fT7CzHQbH/4IlZSr0RWKjzotkaVT/Gfi2z
 StM06Zin
 4Ja3/7y1FJulYA88Za+4tc4qUu9fLobDl4GGHszQy4RByUZfQkIxyPBbj34JJnXibYM4aa0j/DIUAVGFxyMFU/rdqVrs6Zh1AK1LvayI3eLF0TkCxQF9GG1+OecMuQb0eAXxXLqIxatRFw4ZIzprD02ZcLZmYceex+tdPzQ0yX+7zjk5PLq/fvSWTPpUiv16s6sn+oKeBqWjCwzEFlnWEfvIusvvjaDmueTINIOwOvAlPguohfU2TOPIaQCrS4QsucwXCzbQSpIctfXvY4WJCm8oEusi/xlrDWeyhqNJeoXdJJ391iLrCgg6jvpCyW22fVLMT2svK/5WQlTEmPQN01NtgtuShUJqayEQnkKr8IPSlgV1mxNZXmpUyRc88rD1vU60WU45XIEWWFDowOXW0TSYxiFKIfUsCcJeOoJmi+rQlYi+2zl/6wY6xbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--n4nu53c6pb6rlauk
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC 0/3] cgroups: Add support for pinned device memory
MIME-Version: 1.0

Hello Maarten.

On Tue, Aug 19, 2025 at 01:49:33PM +0200, Maarten Lankhorst <dev@lankhorst.=
se> wrote:
> Implementation details:
>=20
> For each cgroup up until the root cgroup, the 'min' limit is checked
> against currently effectively pinned value. If the value will go above
> 'min', the pinning attempt is rejected.

How is pinning different from setting a 'min' limit (from a user
perspective)?

>=20
> Pinned memory is handled slightly different and affects calculating
> effective min/low values. Pinned memory is subtracted from both,
> and needs to be added afterwards when calculating.
>=20
> This is because increasing the amount of pinned memory, the amount of
> free min/low memory decreases for all cgroups that are part of the
> hierarchy.

What is supposed to happen with pinned memory after cgroup removal?
I find the page_counter changes little bit complex without understanding
of the difference between min and pinned. Should this be conceptually
similar to memory.stat:unevictable? Or rather mlock(2)? So far neither
of those needed interaction with min/low values (in memcg).

Thanks,
Michal

--n4nu53c6pb6rlauk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaK3CyBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AgF3wD/T7sV0i+cdg06NdkqMGry
p4ywSWT/m1ixLxww8iCRQjcBAIu13/A09vj6nD3AYjTurMoAlJUuSFWDZE0IA9G4
7jEP
=0oC5
-----END PGP SIGNATURE-----

--n4nu53c6pb6rlauk--

