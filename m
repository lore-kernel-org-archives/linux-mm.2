Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779C2CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 14:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC3F90017A; Thu, 14 Aug 2025 10:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7CE2900172; Thu, 14 Aug 2025 10:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D930190017A; Thu, 14 Aug 2025 10:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C795C900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:03:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F0CA1604AA
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:03:56 +0000 (UTC)
X-FDA: 83775531672.07.0CC508C
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 730491A0004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:03:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MNIANTw4;
	spf=pass (imf19.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755180234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lC65XYVp3GguS5ZtQw5kqmm56yzuVcq1hmEZc/3UkP8=;
	b=NNm0Wk8IMKyyGaHUb/lr0MvnH21xwuZ+BxmFWYeFNa6DaIK7bDRB/3T+sMln/dGmiD75Zm
	wuru1ZRitJiJotcve3IGimofDTOWpybBZFRjcUF2BG4J1o5BN0zAZP3WyEZNoENUVXcnj3
	g0SWVu4As0aY9mgVj4Ljd9RvGskQsps=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MNIANTw4;
	spf=pass (imf19.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755180234; a=rsa-sha256;
	cv=none;
	b=4DYZyKpV4tGFlWMkl1aLa+CnBMb2geAqwxuputOWFt+i2evoTOUwmgAlDWSGdaJ/bXan4g
	HbASz+Trf4gFqsVQs/h5lVBA+h0tEbW4esgfFpII/SRRT1GScAH/BgPzT/+efi4aJ1oDBG
	Dz5EKrMIXZHlMtXtdN9A+UTrGLFWoOQ=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b9edfba75bso446826f8f.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755180233; x=1755785033; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lC65XYVp3GguS5ZtQw5kqmm56yzuVcq1hmEZc/3UkP8=;
        b=MNIANTw4JPObAx07xjxoxujryigVFrc4be6Aq3xasPlcCao5Ia7jHgsYKN/DhzxtOD
         chJAQub9wKdK6xRZPrZdfl633FcXlIdeeT48yjArpkwgkcHT0XcSp00wDvFQnPOQgXcT
         5dfzpUlxNdugk8r0XBtG6gNVJUOnaTdRIArF0cqeqOpCpxo3BjPrPWfeudzymfg45fV1
         PKe5Hj5WOfSG1YzQ94LHb+A1KSM3Pu4qRW3U46dZZPW+Rkzji3hoAaWzX55yEtLQirmj
         a0VBPsU1EiKXWrzFdFT52xefWS1E4qrOb/5GUliGxkrPWiemBZPrlEWET5X82RD4n0/T
         kurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755180233; x=1755785033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lC65XYVp3GguS5ZtQw5kqmm56yzuVcq1hmEZc/3UkP8=;
        b=ExHRGY9ReDcJvIn9LEwH5Qj2h5NQQNYBWMHDAGimX/9Dt42VP8g4dyjQOoXtyRoC8z
         /so9xTph5jFn1XXNQxMqwhDOUwmrKI+Dz7Lq3dZyQhTmFQBUs/EOgFet2nigjdZrfRDS
         HF4dc4H3Md2WPPzZ58D2IeNMh+d2bug3sk94WkvKkhREPJ8zrLwjKv1lUU6G76t86ZqH
         1r/HwSyIv7Dh2nVuC8Xk0XZnd4kv9s8qhiYC6yIbT+wvwo5N22FvUJpHOmOPy93H8jyZ
         qC2lD6bvAQ/QjyMwRMI+jQTCW3OLCjB2LM8dWJEzItJ+U2RHQ19MF7hc637QMKpRWiy9
         CJYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMUncgqb+rxxpB8SRYqnOcYAa+f8wUxapEn/ILKpZV6HoQrLoipCHjC8PIy6p6lfLow5CGZlfGww==@kvack.org
X-Gm-Message-State: AOJu0YzIENX4+krJRYzgHwxlJrAk7xJf0YbUvpLH7Va835i7vvwox4n4
	LzO2Unkk67EiZqG/fG6Z/+1FtAiKCBBcijAGKqu7DwrloKn4Oxs05u/IvBoY92csPbg=
X-Gm-Gg: ASbGnculHZDt9jny1eYCZIaB7BwC3nue3ox4z4e3E/veLeEunmFSn/kUKwMBre+2bPy
	z26FDM85Nbl777C8KdEWQKKk1HChHHYoemRJcTQH/V38aWOfFla6KWyMUoxcLFHaljkr/lTRX0o
	D+jrt1E2CHh7cVmlzSozaf80EMLojQSql9MnWRewr9gBtA1sBjhyEK4wBEjRcFLD+aEg0AjcNKM
	Qbw56AzACZLO3M5LGInWSC6ehzvHD7JiP1B1tjWAhLbahcsalluuHJWnqIICX/9BEh5QAGjJT4f
	DDe/Kha3ntwpUzcMBGslqAD9kyTRu5jOgfgN8CKW0Sclxrc8IF829ABoHhZuHX1ISVOvXdpgEEN
	flqxZRjCKu+aCViUVIzyuhFRI7KRkJ3uThdN3iK/lJA==
X-Google-Smtp-Source: AGHT+IFepIfEgCQYh8ddmvzxRHyhlH/Icj4lFNZlo25smTmLumPxpWK7npvv59MNJPG2u//aqGvssA==
X-Received: by 2002:a05:6000:3108:b0:3b9:16e5:bd36 with SMTP id ffacd0b85a97d-3ba50cc8b0bmr2180594f8f.15.1755180232712;
        Thu, 14 Aug 2025 07:03:52 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422bac12d4sm29684671a12.32.2025.08.14.07.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 07:03:51 -0700 (PDT)
Date: Thu, 14 Aug 2025 16:03:36 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, gunho.lee@lge.com, iamjoonsoo.kim@lge.com, taejoon.song@lge.com
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <uyxkdmnmvjipxuf7gagu2okw7afvzlclomfmc6wb6tygc3mhv6@736m7xs6gn5q>
References: <20250716202006.3640584-1-youngjun.park@lge.com>
 <20250716202006.3640584-2-youngjun.park@lge.com>
 <jrkh2jy2pkoxgsxgsstpmijyhbzzyige6ubltvmvwl6fwkp3s7@kzc24pj2tcko>
 <aH+apAbBCmkMGPlO@yjaykim-PowerEdge-T330>
 <aH/baxIgrBI3Z1Hl@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6rfjwiky6sklgybr"
Content-Disposition: inline
In-Reply-To: <aH/baxIgrBI3Z1Hl@yjaykim-PowerEdge-T330>
X-Rspamd-Queue-Id: 730491A0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jpgki3wgpxg53m57cbpot3yry5bwzfa9
X-HE-Tag: 1755180234-820263
X-HE-Meta: U2FsdGVkX1+7pvxBkL9T1DzAF5jXmNbXLl/6W5AZ5TxGjdCFm2oIgjE3gTkP5UmnlGanEpks4T4PZcymejfX1s9cRIosJt2u9/oxG8lhIVeUMM+Ekx5fEKJG/9pTls7TtWD9kq4EWl+i+HczuXgI7q6EzRBZyNKiXGQpc4Eg+uDF6dz3ZQLKcj1L5xTdr/Vmu9cOqWirPWCsY4PjYEriJ8ncNdnlBBeRuRxWW2lLGPvaHPQkS44Bd4ClOZx3dBOBO8Hu9O31UmZ3sNpwO+svno41xy/AI/CooPTbgKT21hwE9e/ueqcAsp9ouo1RUlq+BYG/0oua4G+zu1mu0fge40mw1L5WMe59XN91t29GZstK5hCTbOPMMsskeftyXcPp5KolgWL4W8QRYhc5wmVQsmDZ5I7gpgTYb/92LJM3Qs6KV+T5pBR13f7cXPeyZjSQF8qT7tg57PiopfYp5Iobo03TWRguROzsTqkyiK5u6KQIR6hwgI3dxekz5HDq0iajGuDXLfpb0RspvVFsSDr6iVC6Vq4WGj0us1T+8NHh2S22dVL8EwSNfhj17+ky2eGYnKjyf6e2wRuXvQViCV7JEs6qbOv37tT16BkSuiPl4gMPOWkTETB8erc2VVe/c1dtaFqozf+U2x+oP/8sLfDrce98+yTD046D+vlDrML+XJCLMun+K9CEZNn+JtVHLivABc7sdSzqymDDFAlJr91JLj8cFnIw4dGsAiVEEItzcevtHd7OjFDh7JH+IRbU4LExu+Daoc2IfF30PxesJk8e2cTt8IqbgTfsl88IWnM6Mjes0P+fe4wVlDliUUNop81WY9enAWYPpauAbJO0YiZniANW3I67aFQ7CeV4KbC1T6ffMR7Eyp698XDbvCfVHuOnPqqJe1WJEqJWC2NKWCp0JjA3OL+Dp68oU4fqYBp9e9FmkZhhZcnJRbKfAswvUccJJtyFRV98rNzZOap/oMH
 jyxEqXpu
 4uiI1eQEJRheuYBedjI95U83aJPJIB9ACL/MigDsaNqWdDASkeMgqOgoh/pbJtoA8gFUlBg506fjeAu8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--6rfjwiky6sklgybr
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
MIME-Version: 1.0

On Wed, Jul 23, 2025 at 03:41:47AM +0900, YoungJun Park <youngjun.park@lge.=
com> wrote:
> This leaves us with a few design options:
>=20
> 1. Treat negative values as valid priorities. Once any device is
>    assigned via `memory.swap.priority`, the NUMA autobind logic is
>    entirely disabled.
>    - Pros: Simplifies implementation; avoids exposing NUMA autobind via
>      cgroup interface.
>    - Cons: Overrides autobind for all devices even if only one is set.
>=20
> 2. Continue to treat negative values as NUMA autobind weights, without
>    implicit shifting. If a user assigns `-3`, it is stored and used
>    exactly as `-3`, and does not affect other devices.
>    - Pros: Simple and intuitive; matches current implementation
>      semantics.
>    - Cons: Autobind semantics still need to be reasoned about when
>      using the interface.
>=20
> 3. Disallow setting negative values via `memory.swap.priority`.
>    Existing NUMA autobind config is preserved, but no new autobind
>    configuration is possible from cgroup interface.
>    - Pros: Keeps cgroup interface simple; no autobind manipulation.
>    - Cons: Autobind infra remains partially active, increasing code
>      complexity.
>=20
> 4. Keep the current design: allow setting negative values to express
>    NUMA autobind weights explicitly. Devices without overridden values
>    continue to follow NUMA-based dynamic selection.
>    - Pros: Preserves current flexibility; gives users control per device.
>    - Cons: Slightly more complex semantics; NUMA autobind remains a
>      visible part of the interface.
>=20
> After thinking through these tradeoffs, I'm inclined to think that
> preserving the NUMA autobind option might be the better path forward.
> What are your thoughts on this?
>=20
> Thank you again for your helpful feedback.

Let me share my mental model in order to help forming the design.

I find these per-cgroup swap priorities similar to cpuset -- instead of
having a configured cpumask (bitmask) for each cgroup, you have
weight-mask for individual swap devices (or distribution over the
devices, I hope it's not too big deviation from priority ranking).
Then you have the hierarchy, so you need a method how to combine
child+parent masks (or global/root) to obtain effective weight-mask (and
effective ranking) for each cgroup.

Furthermore, there's the NUMA autobinding which adds another weight-mask
to the game but this time it's not configured but it depends on "who is
asking". (Tasks running on node N would have autobind shifted towards
devices associated to node N. Is that how autobinding works?)

=46rom the hierarchy point of view, you have to compound weight-masks in
top-down preference (so that higher cgroups can override lower) and
autobind weight-mask that is only conceivable at the very bottom
(not a cgroup but depending on the task's NUMA placement).

There I see conflict between the ends a tad. I think the attempted
reconciliation was to allow emptiness of a single slot in the
weight-mask but it may not be practical for the compounding (that's why
you came up with the four variants). So another option would be to allow
whole weight-mask being empty (or uniform) so that it'd be identity in
the compounding operation.
The conflict exists also in the current non-percg priorities -- there
are the global priorities and autobind priorities. IIUC, the global
level either defines a weight (user prio) or it is empty (defer to NUMA
autobinding).

[I leveled rankings and weight-masks of devices but I left a loophole of
how the empty slots in the latter would be converted to (and from)
rankings. This e-mail is already too long.]


An very different alternative that comes to my mind together with
autobinding and leveraging that to your use case:
- define virtual NUMA nodes [1],
- associate separate swap devices to those nodes,
- utilize task (or actual (mem)cpuset) affinity to those virtual NUMA
  nodes based on each process's swap requirements,
- NUMA autobinding would then yield the device constraints you sought.


HTH,
Michal


[1] Not sure how close this is to the linked series [2] which is AFAIU
    a different kind of virtualization that isn't supposed to be exposed
    to userspace(?).
[2] https://lore.kernel.org/linux-mm/20250429233848.3093350-1-nphamcs@gmail=
=2Ecom/


--6rfjwiky6sklgybr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaJ3stQAKCRB+PQLnlNv4
CFBgAP0YLsIMSEwHcqH0D9nz6CywkXUaQ5+rGzpsZ9ThrHtU1wEApCgAfBGTFDNp
6bjzuw0DnamTil8xVsgM0FRkjUunhg0=
=bJ1Z
-----END PGP SIGNATURE-----

--6rfjwiky6sklgybr--

