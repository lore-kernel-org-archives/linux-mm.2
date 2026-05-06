Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DCF0CD3440
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF026B0088; Wed,  6 May 2026 11:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6FC16B008C; Wed,  6 May 2026 11:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85546B0092; Wed,  6 May 2026 11:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB04A6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:09:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47515401F7
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:09:31 +0000 (UTC)
X-FDA: 84737328942.22.060DDB7
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id 467524000C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:09:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Twc+0qCy;
	spf=pass (imf11.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778080169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtBGz2x9WQ+HNP+qaMuedUIcyx8fnxzRJan7d8nhIVw=;
	b=jQqmo9GKKNOBYNwL4zVbiSFC0V/1+/VorlwWzo06y7ixqBODHb6oGijH/b5PP0w61K/cRG
	RxgMs158gJWbiq+6UC1FHs1hjygsFd3NbuKcCQpCOiHysf7rv4mxpEb+8320zkG2NOJLoc
	syE1BATRtCQwQDsH8akjqVwy2n753zo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Twc+0qCy;
	spf=pass (imf11.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778080169; a=rsa-sha256;
	cv=none;
	b=f6RXaF75jw2fgMTQdlgjyqqaFFHBC2fgjb/4jvhrZw7SoGMbjxC9NmPSOlrDXSYKthNE4Y
	TWBQ6IIbXmSYvhcwhfW+cc1+8xmNXAOJ0mDhDNL929q/Nxi9ktk5fRiWUPMTySuknQppT+
	YsN9ke52XdtMadBYbXzp6eQLIfBxJMI=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488e1a8ac40so64618965e9.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 08:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778080167; x=1778684967; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PtBGz2x9WQ+HNP+qaMuedUIcyx8fnxzRJan7d8nhIVw=;
        b=Twc+0qCyKTcEuJ99DaajfVEFQf8Z1xVPlYN5bhGJAUZSJT18KLMKba9JB7S9aN62Gz
         0SmjGAMiJ63IquugOh6LCd/RVaNcgEubBXBse0Rca2s4ybzihcgyO3VsUoL7/xtoaEpH
         MW9XGd9Iwlu6Ft4OcZrzjIkw2YAe6Is2uWiM+oDZGCGhe0COo87FyOgpHhA50P8DAdZZ
         9BBy6E3sNfFUxunkSC87q3nIwJq3IlQY2kFNPrrV3CqOkXcuMjJ/4DBk/Y45/geL/ME+
         kar39gHI5ncUP8BVe4KW/T/VSETwLgSYe1kNgjROYiyFgY6ZpcVAX4RSZ0NoGasyQuZs
         21Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778080167; x=1778684967;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PtBGz2x9WQ+HNP+qaMuedUIcyx8fnxzRJan7d8nhIVw=;
        b=OGva0xuBcYFDkmoUuPwlpAW437Cej5wtbCAcA6HjQmaKKbPIcVSVOf5jowLv1xrwg5
         vX2kPfy2qJqXBzE2TpeBMnioMDHBlXegN+k1DqGBNXPYIVk+tSxbfLXhdPmLWY4y0gId
         B5H+FznfSluK757BUjzOv/TiL7jsM9/pjt5FsaNT5luNEb0tUbqdCM194M5Pq0F05+uU
         00PYgPdrUF6CXf0B/XTSAfqjRNPOmQgSiWDv3AbbNNipcwgZXZRpy+TbRhRIAVYys5R5
         zzTlUoIyBDmdEFkY/otuTqo9Q8e3dCZRVUq3SlfmC88rwH2vyZNcWmuycbUfgTB5+RfU
         4TfQ==
X-Forwarded-Encrypted: i=1; AFNElJ+d82Md6q5UBsjeQ5Ymj4/AAT5BKvW1kjGl5nXqD+JKelcq0miu6FPRvfIknm4NhL1OIn7lBY1f0A==@kvack.org
X-Gm-Message-State: AOJu0Yy8ri9Je4EIxeIgK/gQe1s/u7Fi7ozX4LOnDna1ofPryEILdoQx
	WbDngDbJE+6rWOLPmceF99IE4fBSBmVzYZUaPjX0HYjlidA2cycm32DsnaXscbb+Fso=
X-Gm-Gg: AeBDieuiZV8r20NpeGsXaEmZM66BH1V2+xXKnMJP9gn7A+vtylEGj9UFl95U7pH7Crh
	Wf+zIkdgKKBokCw5Pyd96wh20ys26HPGGe1VVvUnOrEitK/jPjCDz9U8/v+7aVuDzb2uSNsDNrn
	gjEujLpJveOTowQNcK/xw3+Z2UzmI7LnSpyg5ermSuHbBoth/SUm94M33EIVhp7yn606HohAlU8
	P/fyyfIpTqOc0B6xdkX0ULzoKeF+hLEusYPG9WEaK9MVAvQStrOwz59tbJGkmiVuWloyL0mDrWS
	ua+virmbOhovm8XurUTQq1tEnZ4a62apISbjtjAOkV6l5Tm7+SWO05PoutPDnzb+pGP+PnVAcAd
	0tIyZuYrXujpasMPdMzGB8Gro2k98WytOf/rRHcevqynS+8olY5xlr56rPp/rOiQBLdO+8CeuTW
	N7aWw7+Bbi1qPpmlCi9puAKrPI95HOFWS32m+xd9sVyyeOCKE9lCICL/KGlkI=
X-Received: by 2002:a05:600c:8906:b0:488:ffad:6728 with SMTP id 5b1f17b1804b1-48e51f46d7bmr49899505e9.19.1778080167469;
        Wed, 06 May 2026 08:09:27 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e5312df8dsm18475835e9.18.2026.05.06.08.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 08:09:27 -0700 (PDT)
Date: Wed, 6 May 2026 17:09:24 +0200
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
Subject: Re: [PATCH 0/2] cgroup/dmem: introduce a peak file
Message-ID: <aftQijvIHNZo_UyS@localhost.localdomain>
References: <20260506-dmem_peak-v1-0-8d803eb3449c@igalia.com>
 <aftB-cc5EhDXxCGA@localhost.localdomain>
 <aftNsqrv2sGPOPHX@quatroqueijos.cascardo.eti.br>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pjfnm2wcpgmp3gca"
Content-Disposition: inline
In-Reply-To: <aftNsqrv2sGPOPHX@quatroqueijos.cascardo.eti.br>
X-Stat-Signature: 7i8c5tkyb95mfq35a7x8j3ic3x1s93rq
X-Rspamd-Queue-Id: 467524000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778080169-495206
X-HE-Meta: U2FsdGVkX19sZAxwjRF4VKcdkjQCYFIal9jR7ZYmwd0s0jedkyh3Gru7AfcPEz5Ihkr4M5rABqOh8zHUS3/U1QL+TyBO/cJRE6lYsNPz+DNKeOpszq/x9RBkNrI5g/d6xeEt95+CGxi8VXeB54ZkWrDVUv0509evktt30Sk/VJo+FulTr8t7pfdcOs0Jjmo4UJ7bR7Lhh2Rz+vkXO4/8lopph1kEq7239WAykqtLj83Ul3xXBSFIpJZiNxDk4edVl53m2eYwm771BxYsx4Ubyo7PW69rob9PKSwxL22xkCWMA2ZvGvaTvleDR22e/4vWgnRfMESl2Uz/yyAC0hAND0REKGRZGxC/eNz2ardNaOeE1xj4MqShk6XBMQpzrmEHRZNjPEXesPj0XzLOHDC/zjwTNX9KNLkMc0EUn02RW4nC7ZkUcqRvxsAzgioqQvUIoDFl7Ic3ZggKPrMk/lb5s1iQkTtj7a1sRacU78/nGlRJb1Fp7Ox8L9gbLI367zK9XWuvkWnqEfhJ646E84Y6GUkdR2hM5uarq9l7W3W+6ZpWTvE8KNfUNNg4Ad3ZbFEVLMn9FTvJSutq+dR72yCanpf8bt90xYbKCX74e+ZrZ4nlw85c7z5g1Kst8TFlOFSfcVQHLtY5w7dnpuUlTrjb9Gx4yjpFvKf0CTuE42Czr5cVfsP2NnQCsuBNFm6VMfatxsAVN+t7g8jIF04DPgRMSbKgnyhxZ1EelPz8xbqhf30wVdRXRvmbbDobGK4dAcCk7Sx7Y/a/6cXVUD1hxOIXG6iczZUtqmUWeP8fYVvMoWNWSswsyYTlFOZ23P2Fl/20RObBz0Qbsy8GZdbWcclvUJCSTo6TDJUfEkkcBoVT2W/Dp2WyhFFz934gchDEWcpgHg+UXozu+6UciSIkJ8iXey8x53sUGb6+/ij8FEEJVYTPow71QfeuXykIDbv4UfKNQHLWVaj02uQVxVASF1P
 3gC/r7o3
 VugEVwJkPlgyWX2u9kF2s/SSh80obXtPUyEhyUDg252trhkNxAGuBLclD7ZcjgE3aSHkW8TqCBTCc7zvPeVMyZx1LODUh9N7aKCUSH+mz2yTlQzKQIFO1U4D/qxey+NnMq+WBtYlwv0Y/1Xx41QGpGMFR0ugMMk5pwKIbSkiwqDtO8Gdc5HMjl2Y2ezytv9OR5PB/CAirYbg1Wk4xuaG3M2wHj9Z+AwzFly/Xa4ZLoy1kcPdapRaIUgaqmIpe2CF2K4oAj+91Df8U9DLlPPOBqhvMoSJ8G6gn9E9Ib4m3MfkIWUQwPnVw5fGp5WDYQxeYcVCsEydOD1X8Uo3EJB58NzeDysuG3KEQpGa0ooBDntPBfHPF6v8Pw1Nsocydc0R46kTH4xjbA1315SvIyTaVSNNwQ5f49/0wGaJitRhK8xOILyAYRafdtD36h01mdR2IHM4N8zMbUPjMkwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--pjfnm2wcpgmp3gca
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 0/2] cgroup/dmem: introduce a peak file
MIME-Version: 1.0

On Wed, May 06, 2026 at 11:18:26AM -0300, Thadeu Lima de Souza Cascardo <ca=
scardo@igalia.com> wrote:
> I used void *, at first, but as the only current use is for the pool and =
as
> mixing different uses may lead to misuse, I thought it would be safer to
> use the type directly. This has been pointed out before for other members
> of cgroup_file_ctx. See [1].

That mail reacts to union overlaps and pointer vs embedded struct
allocations. Correct me if I missed your part.

I agree that having properly typed pointer is safer.
cgroup_file_ctx sub-structs are for generic cgroup files. But here
somehow a specific controller needs propagated to the generic member.

What about storing also the `list_head *watchers` inside `struct
cgroup_of_peak` and each subsys would manage it as needed?
(ofp->watchers =3D=3D NULL could also substitute ofp->value =3D=3D
OFP_PEAK_UNSET)


> I started with a non-resettable peak file, but as memory.peak can be rese=
t,
> I added that feature too.=20

At the same time pids.peak has survived without reset option till today.

> If we want to merge a non-resettable support ealier and need to take
> longer to discuss how to work on the resettable support given the
> above, I can resubmit. But I guess we can see if we can reach an
> agreement sonner rather than later.

What kind of users do you envision (i.e. would they need resets at all)?
Anyway, the behavior should be explained in cgroup-v2.rst since that's
where they'll look for it.

HTH,
Michal

--pjfnm2wcpgmp3gca
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaftZoBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Agf3gEAnS3SQwtU72d+vybPMvLs
abYBuiDKjsiW+4zy1RFNTAwA/36oWRqQ1pjGEuPTFgTxHnl4+5Ls3E65Byjp41wO
W6cN
=obKI
-----END PGP SIGNATURE-----

--pjfnm2wcpgmp3gca--

