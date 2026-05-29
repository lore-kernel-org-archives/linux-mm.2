Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 926BBCD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:52:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1CBC6B0095; Fri, 29 May 2026 10:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF3846B0096; Fri, 29 May 2026 10:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09986B009E; Fri, 29 May 2026 10:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B357A6B0095
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:52:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F71C1C021C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:52:23 +0000 (UTC)
X-FDA: 84820748166.15.45D49AF
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 67CAC10000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:52:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KYWDpHBz;
	spf=pass (imf05.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066341; a=rsa-sha256;
	cv=none;
	b=MeUsISnw/24YWAnNkmNmNnKJyeq17z9JEybUsYLQArQs0uO9k5/vwI985VtKJTIhJ1tKc6
	EJgh69d0FCe0iUpbQTKQHhKAtHcbB9zzBttatvRQC5GaPGmKDVWow/tWHogEZ/uInQ5PJL
	gynPxghOH1bEVThKUgbytHalOB0C5Z0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KYWDpHBz;
	spf=pass (imf05.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmSOuhBgxBhu7Is1B1Rw2/yoQpGrUuGnNNhQRjRyvrQ=;
	b=Wb8yzcoeFCXwUgHqIk9KQBdz6iAivK27veQe7p54waCdsVACRHarcghrfFYgAj06rOGFN5
	O3b3rgpjHb1W5hJUmeSUAMaaJKnhHj6oHgevqmjUtXXigID5JmnIcSrTr+cQzQzJd+642U
	2hWKrIof8ToWu7/RVuVcYmpx/0kE12Q=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4904c1ce4c1so82648415e9.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 07:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780066340; x=1780671140; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pmSOuhBgxBhu7Is1B1Rw2/yoQpGrUuGnNNhQRjRyvrQ=;
        b=KYWDpHBzztHDz0pD4GuSMfb0f3HP/C8ZbNjMgDYZ+4iHMDVSqh+chWEGJ8p0rq6H6/
         T0c0ECwvYRFv2gJ4mtda/JaQjGe39jH2zd/HVRRNhWy7fgihJlcI232A4Cn/4JrZDgL3
         R9mFMmV3a4oSrxFxc0+NjQoFQDc/D6XcbNhPLULkWYAZf319GhoSex2oEF+sy4djPrFq
         OLi5qdGqE9D64CpqarGxRBKuZg+DOCdLI+ntSFE6DlRQ/l+rLyCK/d6ClQw6mWQworHB
         i64ilmPIxGVKEZeGlLztmU9upaN3E8wl0ZS2aFtLifs5xak2Jp/pjiNqp8FkEG/j8iP5
         9eQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066340; x=1780671140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pmSOuhBgxBhu7Is1B1Rw2/yoQpGrUuGnNNhQRjRyvrQ=;
        b=SMDjuPLCnhQcu61Yi51DJMDPyfhOmsfecHPuOPpAQvhYd6JAOly1r80+B7MxMLAYK+
         LWhVvpO74iZzIzIhuXRReRuT353cqzxDz1tVUDU5tvuet7XsnGZjhksmmbVWFwjHeIsV
         SHI+yqcMJFhbwuGFh4UQ3ElOw3Ob7c2KY1hn/1PZSBKMX7OLlwZ/hK0ozqOzzDMXcJgv
         OspOHqc3KMm5jGgkd3IwDLxKgs+F/U1jvEewcMEEvrU6Yh1Fch7uJmTqeNMjumDczkUv
         rL2dPxZVir0Ka0CpnwJegvb+bFGD6sETskfmgHpWuKDinenz5GayMLkJqiwhVIU0wsyK
         Ig2g==
X-Forwarded-Encrypted: i=1; AFNElJ8paoWDw3w3PzkgAODgzl/OIHKauI0fZEAEw2/9og3Ne61Hjl3qRPlrhlatF72+SJlBy6dVuVkARw==@kvack.org
X-Gm-Message-State: AOJu0YwzcWro1NiJcYrE47C+KU0/LRwexa+5OwdBt4JoMBB6jCGEs31h
	7c8rarggr60SARGxQM7/TlH3rujb8bP+5ydVd8w4XswIrKIGPTJyniY7iQsD7+Uyi+8=
X-Gm-Gg: Acq92OFdhrjCEhwQcVAKH3EYh528a6H7zHORmyt8MpencdOLPSIvbGBuvj/o8qaTBRC
	uclResq9wgn2G+74CjfaTFTrC5sln/vxk5HGuQIAD4KiZXOZqA2IzIYxJxXvbYXwKtMNcTYzCd+
	C3x9pDjtI5qwy+fle3gMrJ1Q511r4oP79+xpd6M7kHFqqo1opgmJLsZwKCj6M3KFaobmERgpf6s
	3L8ejizA0s/O+R8jKusEynxRLKXqX2gdqcex+gVung2XWh2u64HT4Y7VMQpHJ15QJ0q3CPJTW7P
	JegMYuUg8A3LLFC0MZ5USkqy4YQ/WCPhVUyoUeMoVa+x8Q5evFiO1a1UEABQDsT6KyyAc+QlRPv
	6oRKfrelCUKeEGWzEc7jHL2GaGKAImGEeU/jS3uwdodbMvm2QyXS2SiupqhFQGFxeOCWAmjLsco
	Qhx/VlcXOQ3h0ovDxD5Q6O9LGVwSgy/6YyHnP52rFGdJ7ZuAy6rt7AVoqaxbNbF+cTpoVRXw==
X-Received: by 2002:a05:600c:1453:b0:490:9536:c513 with SMTP id 5b1f17b1804b1-4909c0b0012mr41744015e9.19.1780066339778;
        Fri, 29 May 2026 07:52:19 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d696f25sm62858365e9.5.2026.05.29.07.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 07:52:19 -0700 (PDT)
Date: Fri, 29 May 2026 16:52:17 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Maarten Lankhorst <dev@lankhorst.se>, 
	Maxime Ripard <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
	Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/memcontrol: add dmem charge/uncharge functions
Message-ID: <ahmceQfFPpXa_6Qe@localhost.localdomain>
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
 <20260519-cgroup-dmem-memcg-double-charge-v2-1-db4d1407062b@redhat.com>
 <ahB7pCu_G4vuswc0@linux.dev>
 <ahWfypvuTVsB-pHQ@x1nano>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rw7fy7kfpwloyodg"
Content-Disposition: inline
In-Reply-To: <ahWfypvuTVsB-pHQ@x1nano>
X-Rspam-User: 
X-Rspamd-Queue-Id: 67CAC10000A
X-Rspamd-Server: rspam03
X-Stat-Signature: w1dozet4fxdtkfzrumdpw3g8wk3etjaa
X-HE-Tag: 1780066341-849460
X-HE-Meta: U2FsdGVkX19Bjrhvn08bPqevsUAB265em3KAoydGrDlz8OqmouUfYSYfXmrvAgPfKsB4TP7Gv7gN+WRjqspnb9Wxpn6Wcj9PTN9hL7JNqLYiggfpmZW5664mxcVz/yLK+PpxTHLYbfwRwKWmAMl5AAALbv3c9MII8jjPhVMfV0h6ZgADr9zc5fVow17YHOjuhENRTxFqAfV2kmWKkkYkX/BhP8KPNx8ar1Ntm+I+qYcJFnu+WZHJeMo2VtJ0IW9hwnIuVbmBrS9GyLgUDlbjvBs2HRL8xxOTRRGxvG08Ub4D5E7Morf9UPoincZqQkxOboZhEbqFD/os833DYtCTdVxOlY/teOwRHIM6G9utrpd8h69C2NMWCj//Ju6DpKqYhCRGw2f1u/SLCc2RPllzAVgMgJ1Z0cqtkUDwtg1quzjXHMbH1zdDEU8nNgaCpv/VDAf7itvDpEYnKkvZhUPuEDnA8AkRQTW23GtS202MxKbKiN5+L99OHhNgQU189BbhmL2XtZinjTG9EzonhGb0cE+HmPA+vlHxCX+7ANnQc2zr9pttGpKUdLwbHu3iAvXeUwXP9Ftvc7zy1LUOM0ZND0q4HZALSmaBNikttKRF01FY2Q09neSCE9ZK4WsfNF3z2kxUwT5ogTY4J36QqSx8F6WiYfkseV0B5EHix+OuAL3d6M0sIMWiPEx3uonDMwoti4hcQYprbtxRSuAzUHhMd00yzKJ3R6PnEaDHzIn8hfxiDlVA+uB6PijzSCGnMtGc0CAjSQ/CnH9HhiuFNg3k3TqGkhjaGMwjLi9P2TH7ZImoDi77wUUiZ1ieg9SD/VH72PRx/vx6dVSLoopgydDr1D3lWWAj1/nNmQoHweuJ3zBqvQjkXnpELoIFkeBRABBzm0f2UTYQTg5E1qK1S0Zn56R83zw3txiRV4dUpGgVvhJ+ube86NqTeYLi2XoKSnG6oWCqQZvYf9V0y+LLzyI
 ElmGAJaP
 tPnFZcUDJeGuBUtyuwIEt58ldmHCCswZckO4AATL6cGb5DPg0ZDNhATmvig51s89Vt3q/DLNyiPN5Ac1+Yymj5LGzgLBvKLlyXVu7a1/SrxoHssFnEuyjBgaRFGyoO800H0+Ln7z/OIC4qf5TDj2C0cvKURGWHZXwUwKmqOXxolnuT+8OgcIjbzxN4Tbgv5ZYUEOHWBgMOVNrjlhhKhwqb2kbmoOK5havayBMieAW1Wogy3Qb22ZtgMAgkLxHxjrz/gkpJVlb988vfjWq0mYRwTNhp1GjlXbBDeREB9yMzjmpE3kkTZCoGVShG/FXo4+jW9cAzxx6zjW9wpq0RVYkT2WRGZTM16jK2m6ErHklxwd7EeMFYMwLDHcu0+XYeINmVs2BqLf+oH3Y9EjklBXYsJnnvULfxsEziHF9aFmd6udXytw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--rw7fy7kfpwloyodg
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 1/2] mm/memcontrol: add dmem charge/uncharge functions
MIME-Version: 1.0

On Wed, May 27, 2026 at 03:10:47PM -0400, Eric Chanudet <echanude@redhat.co=
m> wrote:
> but that made me realize there is a catch with
> this patch set, with something like:
> A: +memory{max:32M}/+dmem
> A/B: +memory{max:16M}
>=20
> It gets the CSS from the dmem's cgroup with
>   cgroup_get_e_css(cgrp, &memory_cgrp_subsys);
>   mem_cgroup_from_css(mem_css);
>=20
> Which would resolve to A's memcg and not enforce the memory.max limit
> set in B when dmem.memcg is set for that region.

One perspective is that this is in accordance with dmem's limit granularity.
If the user wanted to distinguish dmem charges below A, they need to
enable the controller there too. IOW, the depends_on in one direction is
correct. dmem is primary when it comes to those charges and memcg
secondary.

Another possibility would be to always use the highest precision
available (wrt where current resides) and then the API should refer to
struct cgroup from task_dfl_cgroup(current) (and make this only
available on v2), or to struct css_set and extract respective subsys
csses in the double charging function.

In either case, it's worth mentioning the behavior in the dmem docs.

HTH,
Michal

--rw7fy7kfpwloyodg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCahmoHRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ahb7AD/ReCU/1qelso4Se3AlOZq
R+fmGmGVDlgPYs7gBkJUqqEBALvZg8zd4ig7QW/B4SdBdSv8RGm7SPB7R9vTNMP8
dKYO
=3pZx
-----END PGP SIGNATURE-----

--rw7fy7kfpwloyodg--

