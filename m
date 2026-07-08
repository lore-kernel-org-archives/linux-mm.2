Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D29C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 19:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF52D6B0088; Wed,  8 Jul 2026 15:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACBC36B008A; Wed,  8 Jul 2026 15:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1836B008C; Wed,  8 Jul 2026 15:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 728D86B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:01:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCD5F1C2820
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:00:59 +0000 (UTC)
X-FDA: 84966526638.14.C51DB39
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id B8B561A000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:00:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VM5E2TLy;
	spf=pass (imf19.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783537257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3eMYQ2fgWM9eul1MhvdVNq2qZnIJPst3WSiSXllEgI=;
	b=KeQ+cNdP7S/+KYDLq9KzSMO0rf1Xp94x8IuTJQ6fsFY3ndJaHJIsriM1mdK/5hxYaJ52Cp
	qyUWh6S2g6pQyK50NMrCeuWHfL6khS02ZYeS91QLwugP3hLhIWLwqGsv+dhsGOGszTWvX6
	jRYa51Bvo6sqtqvRnqay7aNRG5DrLmw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783537257;
	b=kD/x9wOQwtwHs6EtRRg+n1IhsNeCmZ8lQ4S5IA3CeZX3vx0gFVIN8tKb7Qm5di044rxVof
	hyBYyZBup7fIM9m6XZkvCo4O5n3gw2Vty/4Qjy5QmvXLtcb1sBUM9WGwnqPwtfgf+DBBH5
	HAzJgGgK/jba+aweC3WkCaH+Zz++lkc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VM5E2TLy;
	spf=pass (imf19.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493bfe9f886so5619115e9.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 12:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783537256; x=1784142056; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k3eMYQ2fgWM9eul1MhvdVNq2qZnIJPst3WSiSXllEgI=;
        b=VM5E2TLyZEr5tAjn8gpEBUHUkpQwkCAekJtl0T2n/76AG2A22dJ3CfJeku4sFpGyR8
         Ua/bg2frlXQg9mLNLRwTKL+l23vyf6ADi+m72NqfkoQxNOCXgBoYofgpBBG5B9vOJYjn
         ODRhpllodj9L6jDoAIIgnXbVGBV18l93xCTTMI1F6/IUfTPvWW2GfRufn2QHcF11mSwk
         iBArvv6iX5IRx8PXjz7rWlZ+3HiUxLRZ0ij5DOJENeQZUbPPVSa2yBVXSwtLni59474y
         ogGCgAZ5wae4E7ogool7d0auToEHegCv/ARoDr/CT52VMef0T/+Hh1AI1LgvZtaoZGva
         Evvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783537256; x=1784142056;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k3eMYQ2fgWM9eul1MhvdVNq2qZnIJPst3WSiSXllEgI=;
        b=tTNze9CKilqCQA2S17f+RnR/8IB6kEM4Emf0ohjuHB0H5210CQYHh8vZ+sHvor+i2B
         NoF3OyLnpafPwYAmmEJ3ZSXhQrsOTrueZ0BD19rRhobp1RWlbIMgtGVTz03hficaoa5r
         6EqcCdXYA6WHw31X4nMu/cuOnOV7GuWsWa65Fh9zNqn1bLbSXGvtmsd46Yb1DsN3UExf
         k5It6LoL2HxH9IeC66AWYGq2G83iQLNHMuTHOrhx/cdimCs/QOQffTUyZW6pKSXFJ6IJ
         fXr5zTsDPrbrmrXj3ACoXE14A5xH2wJmbOPPiBXEFJhhUafCl1xQMoWPsWscY6xqykjL
         zFlg==
X-Forwarded-Encrypted: i=1; AHgh+Rqo3EmYx6DhAuKDB85A+FBvQlOTU20d07RYK0otxbmlnIerIuYM+Eox9c/OKeI5ZGWJlyAE/fYOww==@kvack.org
X-Gm-Message-State: AOJu0Yzz4gvUqNdhreEx+4pbzGJ8PbwLscpVuk0DJPLkrV3+RmofcH/y
	RWNwMdtSUFHU5rss59zPbW1Ik++wFbs5arEoVmZM0Lhw/YJGyt1sEK1vyWeOmFnGmkU=
X-Gm-Gg: AfdE7cmMgUxwzIytej+2p7NHPaJCCfu+98ZXR+483WszIUTnL0XRV2oqX3MRtaj3PkF
	8YaQCNAjXxWLYfoyp+NLUNS0tF9+r+m8w72h9kATqrFXegqKFjjs+FqJi/yi1Ha4vU4YZdVcoF4
	tfo9n3cWQl4hv0P5aQLTvBjAYftCVLXrQZjeUwzX3QKLQomZDMTDnbHCLY0jGZPMegg9NkGpys1
	tT9YVUFyJBZ2uUBWj7o76mhPaUPevupys9tBYWOcL72SG4cVfnfODO/SvEWF24NIwnanDdKMyGx
	RYbV7o+tnbDDdXXZRIXeC1ivalwTKh2RAXZZ50gxnw2JJLdfe5R0ebTpIWpEVEks43aDGIF3kHp
	Qb6paLEWyx2XyDZWaQvdcpXBYa/jY/80txTOPFMyFQFIdtcRzjS9P8Qd2YERY0aajNeeqxI5JHF
	65h/7U9ROCM1fofRBIeszpCHvIF8U2p9pfookunQ==
X-Received: by 2002:a05:600c:6091:b0:493:c83b:50d7 with SMTP id 5b1f17b1804b1-493e6831575mr37343485e9.6.1783537256247;
        Wed, 08 Jul 2026 12:00:56 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039af67sm51255578f8f.17.2026.07.08.12.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 12:00:55 -0700 (PDT)
Date: Wed, 8 Jul 2026 21:00:54 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Zenghui Yu <zenghui.yu@linux.dev>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, chengming.zhou@linux.dev, tj@kernel.org, 
	Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
Message-ID: <ak6c2TaOlcGxZ2Ih@localhost.localdomain>
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
 <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
 <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
 <CAKEwX=M7axSs2FJDq0KF3GBDpd6G0J=gP_2boUJraNf8M2n3Bw@mail.gmail.com>
 <CAO9r8zM8qk9g6+B6GiCV3oytjViMTEhbr0KjrccU+bF4+PMfTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="65f7eg5vudklrash"
Content-Disposition: inline
In-Reply-To: <CAO9r8zM8qk9g6+B6GiCV3oytjViMTEhbr0KjrccU+bF4+PMfTA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B8B561A000A
X-Stat-Signature: agqfipsusn885ujeq3h3fu6xong5sk83
X-HE-Tag: 1783537257-564573
X-HE-Meta: U2FsdGVkX18naSxRSbYnaH06wJnDW6jNgbfxTvBrrHlhA6AXpDd5s36ci3uWLm+SWTzHr8VaF1ODg77dVThKCuRdUPUk7QoL2rsBwOcrJID00icu0q7jy3nelcxmWpORoLJXiuMPwimsm/iwBOuCBolCguMFSU8ofuuTYxw86Rr8T9xTofT90EPxQMK+vXqsslKAY2YgD0C1ruhwWLS+YXk4yvBFMHLHUIz1TkDY/NSLqxZBx8jUP9QFmdf8+aqto89Jf66Op8RS6nG9bJmMWf79OsLsrU2vKVzWp9bqFyDwBUSN+wC1IkJj+SdEWbgYwAcHZj3uoNSe1vQ5SPdsnL5pXg4KlEfHpP+LiHVgfXEQXw/FNidMep9PxQ06Zx8LSnfqu1PnLa6vJmlqaKifawU9GjRJmK1JqqhhZZoPnjEsIn29sYGqhloZ+hdeWxm+zMS85eDIw0bZMFdUyd8CNujCz2GSDfKrUZdt+9l/5pqpQjObrtVyQ++TZttZxBXa5/qWXpVqnEX0rmYuaJf5vW5QS7gm5dTryMPUQjl8PjGG6nNqunloEP/iQo2I56s21D4pujcQh+r7l91ooN67R3gvZE5/q61xB4UmA04yV0Bzp/iHq7j71vtLE06vIS52f8CMdMkHilgqUpPDw/4mnUTMY8KH6BK8/GaRgoy53N+8Lf4uyL5AaVLRVPsIJ19J94S9+UFgqNArqhhL2xyyH+0/bfURIvUc2HsGvzWjabD5NnJvdaMQUIdAu4PLBje0SjaDeRt5RkMuVixsDypgPd3CKcsy+CQQw+QLOux6HERanLiQFCBvbXnOgarw0Wm465MBuEOGiZ0YIJS5lz9BrfMk8LWQjQmfD3NNO8GuZ0NETAp0/SSqn5QIdGoruO7FjKvenbi2M4UNmm3CHsYEVCQuA550AlKIltILM6wUY+FBC3yebQ+QJZAIoWNP2UmbPXMEPgJWdfujbUSnIbc
 vKWDd6Kc
 AqvkKp+nS8FYIDL4ltjMOTFtMfjl12EE6ikof3Sb1+KAZKCVDo90r/IyoZesMD/rUtE7cztRetg3PTgXgGLkP/XHtYc/34idPzcXCLk8fNfAX3FD/1fzZGBINFlubCazOGOlxYvWb9PmQph7gWvjcL8iZ7addZBlphOKyvIitus5hCZpWn8QUW3pXbOE6B0IeTgg1gZFdrgqEOE0ApCIOg9RqJHSyhm9tSG78IJJpEbjUiE3X6O4CuOAYV99iZlm7TeAfSvILZTaWXwIxx1OOStJAEnKYSRVfJDF3R1ZVh50yE7JfNGeGlrB5iXpqwxYUscASVrRTLHapGQ+MIRs57I+r7Xqc5jgOaIKTiJFOl/C0dra4T1H9QoK3ck6Uak98QXFmDV9YXAgy+FBP72gTe6WaF3VdQhqZF1ed3xsTdqn7r2Z4nY31U42dqqNvTtwsZNxHYNfWlFzNSOQ0o0tkJHGaOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--65f7eg5vudklrash
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
MIME-Version: 1.0

On Tue, Jul 07, 2026 at 02:49:56PM -0700, Yosry Ahmed <yosry@kernel.org> wr=
ote:
> I would honestly rather use more memory. I think there might be cases
> where the flusher is delayed. The flush being slightly delayed is not
> technically a bug that we want to see a failure for, but if a large
> stats change is not visible that's a user-noticeable behavior that we
> want a failure for.
>=20
> WDYT?

There's already the (recent) page size-based scaling, so the idea with
nr_cpus scaling could make the selftest useful on wider range of setups
(even page size can be considered as a slight implementation detail
leak, thus the justification of nr_cpus dependency).

Also, I still think that internally the threshold should be changed to
the "harmonic" formula [1] but the selftest can go with the linear
dependency for more pronounced effects.

Thanks,
Michal

[1] https://lore.kernel.org/lkml/n6mhkjsxsami3qmczkdh57eep4lmcgbtyl7ox3ajzv=
eke44yf6@m4bjevvsr47k/

--65f7eg5vudklrash
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCak6eYRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjWUgD+NXLAQPqFouL0lAEWSdLH
Q1TGxjtThGe45suKK7NoiLIBAM7klcnhnOTcn3O4JeLz/eHwfK1JWXaF9nVzAX65
8KEK
=2aDV
-----END PGP SIGNATURE-----

--65f7eg5vudklrash--

