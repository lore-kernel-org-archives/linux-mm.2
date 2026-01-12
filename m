Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C9EC9EC7E
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 12:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1076B0088; Mon, 12 Jan 2026 07:38:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634B66B0089; Mon, 12 Jan 2026 07:38:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540676B008A; Mon, 12 Jan 2026 07:38:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42F806B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:38:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8608B160BE8
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:38:34 +0000 (UTC)
X-FDA: 84323265348.28.F1BB98D
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6425F20005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:38:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FW2Ir78Y;
	spf=pass (imf13.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768221512; a=rsa-sha256;
	cv=none;
	b=0ggFjLmJiFU5KXR3wI0d7MmBH2gYnq9ZAUnt0Kdn1KQcnjBK28UCK92L6KzpGFrcPqD2hG
	ldjQ3bh0UtOO0NcfIbzjBO66Ai5kvxQx+qxT/ZVED6kVa/8ch7f/I77V5jaDkfeSZ95Z24
	XuBuA/ptnzkEhMMTMsyBf30W04JEgrg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FW2Ir78Y;
	spf=pass (imf13.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768221512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJPyM+iSl9+gUHGXGEFui1PKAGNb9Q5bbO0rp//iqF8=;
	b=dU9S4RVqmzg3djubIDuVZTr5fa0BW0b3u0CvpZL5gOGSTOeFA0rDkIYa7t9HTFu5BGBaOs
	l5sT5EKyYeevg6Ab9rfGfaPiagnXitEvocOZplobUd3Wr/7Z/sI0IHD1uLGSMjok4Rif2h
	VqRhOq4iIHS93AnHRPbnVHjIxiQPzWo=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477563e28a3so34706705e9.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768221511; x=1768826311; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MJPyM+iSl9+gUHGXGEFui1PKAGNb9Q5bbO0rp//iqF8=;
        b=FW2Ir78YLJAgHuXe75pDqnsUpyRnxGUGQRo0sSCWrswtnszX7yvTu5EEaIhUKBXmuD
         0IfJMmUC63WHLxbv4biL6eZKTAq/Rcg5yUlHaBsDJjqgsFKFIeo109NHlaDP93u/exBG
         esWapiDKO8Bt7lPPLz24b9N+mxLxi6U2MOkyd/SlZdbE0uga+Tkw1VJ6knn5SalciUWp
         RkpML+EMSccnZ5frvjYopG/dGibRdSV1Om2bSY2vzvJwKOJ+rJKLFJ7QX+kO9Hu3tEXc
         LK68m3+Uxi3Z8Jp2NkT3OxtalvI4QR85Sme50wxyuG9RhUebXWBfPXT1wu8yQsiAkIEp
         U32A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768221511; x=1768826311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJPyM+iSl9+gUHGXGEFui1PKAGNb9Q5bbO0rp//iqF8=;
        b=q+nab9Xcefx+bB8hWNsPdxB5CM33HxPA1WZvWVbdRUstTdniCTvyL7r0uLIT36GAjy
         aGw+/IqoiW4+QDBwOpPFcamG2/rUu9onieGJJR8k05C4Os9w8LbL34f8ypH841QwHhRl
         L7SC5OUg6xCPEYRMjN6Rezo1fYIDKI/kAHPti6rit5Pm5DUyRHjfklRaZ4E3/P9eJ7dU
         JRaiqGHho1BfR4W4jq03BDrLvSQIb6hmkJ1duNrff+TRJztvMiKLDXossJ6wwS9tlrWr
         /0LL4thFk6oFOdMRJiFmJFUVEOTS6GEgkrDQ7RS/5wDIu0v6uWQXNHqmwf+7DKDgXjok
         e7NQ==
X-Forwarded-Encrypted: i=1; AJvYcCXm6V7A7RshKlkZjhdVf64T/3e8Ri1eU/cA9DLpIGtsJPNaHrtcuckANJ4dVCEqCU95cuyl/96nig==@kvack.org
X-Gm-Message-State: AOJu0YxbOC1+oWG/s6Y3iarAvvaQ8N8QnkrPw9ZsxQAimvTPhFXETtCm
	6ksSdeSeQ+qbXl78TPdJpmFmxI6rON2k7RvuNGHPnmRbl+SkaEf13JoJvvsFjx2u9NY=
X-Gm-Gg: AY/fxX6uhhK1tU1xnSzuAWzowORVOPfgrnNUZ/pYbpX9jR0Zufb1HazbIeqTlbG5V4p
	6OyjNvVGr0rUAKCHU7O9Ea7NZnvJBEJSqY0BQzJavdaJMzW1uIvf58wMZ7XqDXTAa+82F7x2zem
	A3mhTp35B1v0yaIR2HpnDf1WvMPQUxkSnN6IQONOI5RTLDOIXhiUNSxUES2APx37ZxFyNBfLhPB
	W0Vp5dfIp7D4DEE8Ih8lXCDT9WEgStSVuF709Hdl2buenEqW4xyObjW46SoEvfc1MCEkj14kIlj
	yZqJqea2sSN2D9NMmJ2wXljiL6Ehh5qNgvbg5pzJQPqVeXnw/ntTplRNEhugID51U4KDN6JT9if
	O7iCmTWKII3UuBtYhqKfE2rmHiP3iCHGelyOzguHb/ywSBJ8y2L+OR2MquzmN43AgdSjChoMbA6
	oCIEv8uUnhfqQCpnpB6ulhKGOnzL3M5uY=
X-Google-Smtp-Source: AGHT+IEBX9O7r4RZ13L+NusGM/ZK0yEzZLDAA/V+uZ60+JG+kl3g0xr47hSKM+50E8bFxfdYpRdsWw==
X-Received: by 2002:a05:600c:681b:b0:477:a219:cdc3 with SMTP id 5b1f17b1804b1-47d8486d5e6mr184013565e9.12.1768221510694;
        Mon, 12 Jan 2026 04:38:30 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5df9afsm40784010f8f.24.2026.01.12.04.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 04:38:30 -0800 (PST)
Date: Mon, 12 Jan 2026 13:38:28 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Andrei Vagin <avagin@google.com>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Mark Brown <broonie@kernel.org>, Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH 1/3] binfmt_elf_fdpic: fix AUXV size calculation for
 ELF_HWCAP3 and ELF_HWCAP4
Message-ID: <zt6p77wtnc2rrw3hko3ppl2sruy64fhrz2mhgyahvpjuzitpga@tpjsfhxmwrep>
References: <20260108050748.520792-1-avagin@google.com>
 <20260108050748.520792-2-avagin@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="s2pgxkol6rb2nun4"
Content-Disposition: inline
In-Reply-To: <20260108050748.520792-2-avagin@google.com>
X-Stat-Signature: zhu7bf6qf4scb41o791g6m1op3h448i8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6425F20005
X-Rspam-User: 
X-HE-Tag: 1768221512-779044
X-HE-Meta: U2FsdGVkX1+srQLJb1/LfVwG1uaIznH3sAnH+pi+8dUMz2oWhZYF76/2ic+ZGaFulYVFtZ43cO7eoTUjiySgglPozCrn17HWOw6ar1ublS8mnrAcMFuSsK2H4c4mCfBgEbimxYMGxJRFVNRbMQP6cVRIqNVQP4H/SQ9bZR1Lwlt4zuFSyMl4nDN6y98TPThGLdeiacibIF43xmIeNlQ/8bX5q04E/Ou4zLZL2cfHGdkfL8IgqMHER5J9goZxFkAWWayqdvXuw3V4UpnRGHizfPudY6ZhdS9SO/lyVgD75VxT7cSBNdwFZ6/x5rPt84Qkc5C+wgJsPMweeeUyWN1GLB4CvGlT7Iqsx3fmRlE5qETHwrGnEvOT04cwjdmm/CnixPT8RSeXv5MqTUDvpLu8+MPpzeHEnB2s7SSnEVPiCTftqNKfk58m9h2N2YAOJIS2KUrEBITfDPX7uC9pax7mj5YinRMepmJ0edt8tg9GSGV+Ll8fm3/poOsKCex+XrEcp9gg0B7lGrm5el5QUNBDLn8yA8YU+lG5cR3m3zLeOPWOvvLlBgqFu7OiNixZiCJtzJuhwITp9kStPMKhS1CzrsRoKO7wAUAfKUUFZhRNzr8cKjQAC70czgX1I2XF5aPr5xQwPaFmYBaGACcomdGQNVMLfvHTZ6NFpbp3IPOrnN3cQpo7j63hdBLCnlhJnh6WlDIJhnRmlON+lCAiN7uz5jRpR4caBYKMI+ne78dgopbPFwyUQWf68mdssrZ10azYc1p/1gWaqra1yEiZOeYK/6QyD133d0yhtN2aXQCSR3FZAmKCGByw65pzROE4cls58GjiMuxLjsnEwqw5vOdxraxaz3R0MN/5imRmAkh8iJ0dfhBxvd+IM0rrQlb6LF+PQlTISD3tnyuJQODVS2iK8fzWJnfEUwUEpaIwG0hQBUMHiCHJBjluQ4fMvmP1MRvFYceJwnoncf51n62fAa6
 fRxY2nQw
 dfwZVASiwa2hn5f62qOMbPM8xOrHVh9Dnfm8NEy47ZZAq7jutjUN+vNUdJiOxTW+fMwDdymXj3fIUWxVCc4MqtolWDjDHYt/Spw5gGXm4CqYYJtz52n+vSDPsHLOuZN9lgpugoSD84lh5lhwVTS+4f/s0hhx83sO8VQSyc9ioCXgRwkTuBWyzjxCMMGZ0KD7KmVaZGj5KG/bJ6D6yITxfJ2wjfD+JFEPgNAnNzCptDmjA+J7hG7VdYbr9yJJT1dlDMLCviaMEOaimZZmvQpCfMyJRErJmpMg2+BydTMHNz/UrCWO4dHsf8u5cynjjj151qBu3dlsDBLch3+i/0jkjHXr46bLXVIfepSfnNDOIuB9E5NnYalUEvOLl1h3lG75KA9XjKy1E6lkunyELbzXToqfWlHH2OR8TjjbybOuAaDr+ArqnMH1YdqiyO96m8gxsuqiMvE+0+sgFXzQdu1+HFoJrLEnYf+xnweI1vUW0GtNEu2m7qdsFj99PzahiP1y+GUVlYPlubc3kEf5rxsTljSTlOfeGonPxjBbtuzRKabusl7kJRVtnaXfp+1MF9i7P572m3Rcyk0h0JdBogLUTh/dKjWZQLl5w8pFV+z8x6EppG6atA2Lv+d4ZWq0qmbHgpk1aAli339KiwxEmvyWBXVfaLw+flh9XopX5wtFfssnBOxi5gXckKogBvBew1mw3B5Sg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--s2pgxkol6rb2nun4
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/3] binfmt_elf_fdpic: fix AUXV size calculation for
 ELF_HWCAP3 and ELF_HWCAP4
MIME-Version: 1.0

On Thu, Jan 08, 2026 at 05:07:46AM +0000, Andrei Vagin <avagin@google.com> =
wrote:
> Commit 4e6e8c2b757f ("binfmt_elf: Wire up AT_HWCAP3 at AT_HWCAP4") added
> support for AT_HWCAP3 and AT_HWCAP4, but it missed updating the AUX
> vector size calculation in create_elf_fdpic_tables() and
> AT_VECTOR_SIZE_BASE in include/linux/auxvec.h.
>=20
> Similar to the fix for ELF_HWCAP2 in commit c6a09e342f8e
> ("binfmt_elf_fdpic: fix AUXV size calculation when ELF_HWCAP2 is defined"=
),
> this omission leads to a mismatch between the reserved space and the
> actual number of AUX entries, eventually triggering a kernel BUG_ON(csp !=
=3D sp).
>=20
> Fix this by incrementing nitems when ELF_HWCAP3 or ELF_HWCAP4 are defined
> and updating AT_VECTOR_SIZE_BASE.
>=20
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Fixes: 4e6e8c2b757f ("binfmt_elf: Wire up AT_HWCAP3 at AT_HWCAP4")
> Signed-off-by: Andrei Vagin <avagin@google.com>
> ---
>  fs/binfmt_elf_fdpic.c  | 6 ++++++
>  include/linux/auxvec.h | 2 +-
>  2 files changed, 7 insertions(+), 1 deletion(-)

Good catch.
Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--s2pgxkol6rb2nun4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaWTrPhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AgZTQD/fZEPNQXq4wayVRf5UJeP
yCKrUVfm0ZVJbogI5yyUiKsBAPYaPoop6oDIbDmy08Fmb8Y8MICFtI5C8agrNBfO
CYYM
=f8Iv
-----END PGP SIGNATURE-----

--s2pgxkol6rb2nun4--

