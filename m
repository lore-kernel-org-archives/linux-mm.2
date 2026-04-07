Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 496B2FEEF31
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29FE6B0089; Tue,  7 Apr 2026 08:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB266B0095; Tue,  7 Apr 2026 08:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA546B0099; Tue,  7 Apr 2026 08:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5536B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:48:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A4CCC2798
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:48:11 +0000 (UTC)
X-FDA: 84631737582.18.CE8D3EA
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5441020015
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:48:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=H7PIfKQP;
	spf=pass (imf13.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775566089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jsPjgRVFyADCET9OBAbphHMErVazIwO74nJ/z5grGXg=;
	b=0JbdpSYwUNkbLHWA4IXIS+VzKJalFmDeYJgbjXa7AByndOWWmL33uFFCOODxnfTVsdBN4q
	CunShYcZvP0C8+9yZpm5NAZrsPxQ15iq1GbaMxmzXs2KCatYMaOEibldjrQUAmsMYXqBnr
	MY6FZ7WMUKve7Y/jfPQvDCGrlH+rn1Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=H7PIfKQP;
	spf=pass (imf13.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775566089; a=rsa-sha256;
	cv=none;
	b=k1MHXrll4HJ3dTGYjFYd2FWq4lIQvgmXXhiCvMSJvipQF1Z2S0LuIbEx6jpylxdYOt9cb9
	/tVPpnb/otW6fuQjqKrGqv6mlF6yER67XGrL5zTzVQBw4MVb4kiod75Sw+SomcgPDCiVCG
	y5+QHUytexN2NGE+IM44lMKcjjrKyYU=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so34308395e9.2
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 05:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775566088; x=1776170888; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jsPjgRVFyADCET9OBAbphHMErVazIwO74nJ/z5grGXg=;
        b=H7PIfKQPRMlNgeCkubjYXeOpsymFirQg5l2tnaDapuxb1vk1XS4Spe6ohfLpbpBPkv
         gnp0q1O6xlc4d9eQg187qj6oXtjLkK8nMcxrBH9y9AdmaNDhWVtZ4+KL332FKk75SaFT
         gXilxp6/YCBmqhU3JTeIHnWmNo6Ba+dEO714otoF6wlt+ElKzo3V3zfrUCDgjevOlLiP
         xWZ1Bmb76wGFiNdKReXwREwtfWHTyDQErKkGHPeKUG7sGUn8zKxHfw54PJjgwtE47ty7
         845fUm2840hmyT4lottfgXRobxITkb7cwjnOUsQfMMI2vuW0KYBn6c3HLRx1YAe/o2di
         Ud3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775566088; x=1776170888;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jsPjgRVFyADCET9OBAbphHMErVazIwO74nJ/z5grGXg=;
        b=iIttjjw+yyVGXwHlGI8c/PfrWVMs7ParQ/1lwY0XMX99tkGJzG3DvOeLgJh8I8dKmi
         7PoFUcAsPqSEU/CZmoQGoLPl9lxF+hHKUXYeUK5m/pNsI/XzKKLCZyAczASWkJ+4nVGj
         4/mwShX8/G05YQ96K0q33Tj7Q+rU02nFVHF6GKLG6hCKKdUeNDv7ncgs+d47aOsV/taQ
         QRM9Bkhje1HT8Y9fBopPic4UzOGKruuYU656C/rzv5PZpLmBPz/fyZ+ZegGJ2yfUzFQo
         hFkWmYt4YJh57t95cT7YPkkXEP3Yf6XBROzvh8azuAeKWfp6GAYqexa8clp+ym5bGixf
         D55w==
X-Forwarded-Encrypted: i=1; AJvYcCXDCc+ppwdFlKGbgzp75O50rZXpAzV4EOLfgrFu4N7R4QbeqMwwGR+YtiDz0LlhmnHE6tA6nc9RRQ==@kvack.org
X-Gm-Message-State: AOJu0Yxh998dJfgfvuYyXCW+02WaOadvMMPQkcud2Dyd6b3wysngiKxr
	mqOend/7deL3Uj866lDb+FCpybg7+M1lyqYY9ch0Psp2QGVHnAUjG2yUwrTTQ6bx+7c=
X-Gm-Gg: AeBDietWdh+r2m39t0sah2HNVJRoC85EndWYOR44Jz7w+TvDoHgKoRWz+ZgQf8AVI/9
	GAOAzHrAqYCrye7s2j1qnEYZQXP6YNFcOeBjnDkOVDvXgSIXSapez3UHRGBe59XredOtliMcCkw
	48W9nPcd/GYuQDVVznkqtgvvpAFCiOBT98wO3h/m21ElcJl1+PKqzAt1+Q4t/3qpU5YyrRFbeyQ
	PLOdFLbY+urCZMpeijdMtL9eSe5a+rIi5TKEJ1WtdQCQvfWus5nY7RZm2Qr0P/hOs7+j0P/2tU/
	Dli7BXR2I9OptsRdl2QXeessEfa4E8LfePkv+5sWOxFtOh5+W4jJvTr5qebc7X2KEcMGc11GWWx
	j46beZ/3VcJXD/lGZQhO5bixraIrg/XlM/h00fwtggBa30tGlclodLNS5AkOqIgtQ/p7kb85X2p
	409lHqtF5nhXVboDsXRAMaB4yXWe6SKyjG3dNX3NMVqC8=
X-Received: by 2002:a05:600c:4593:b0:485:33ad:3c9f with SMTP id 5b1f17b1804b1-488997de1c6mr263906175e9.25.1775566087832;
        Tue, 07 Apr 2026 05:48:07 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4d58e5sm50268531f8f.23.2026.04.07.05.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 05:48:07 -0700 (PDT)
Date: Tue, 7 Apr 2026 14:48:05 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
	Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH RFC 2/2] cgroup/dmem: add a node to double charge in memcg
Message-ID: <auzxmkl5jxlvlxpryibtz7srdnssguiaylb3uisheclrqelcgh@owm2nve7axb5>
References: <20260403-cgroup-dmem-memcg-double-charge-v1-0-c371d155de2a@redhat.com>
 <20260403-cgroup-dmem-memcg-double-charge-v1-2-c371d155de2a@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3iqnq37lhwpyhhg3"
Content-Disposition: inline
In-Reply-To: <20260403-cgroup-dmem-memcg-double-charge-v1-2-c371d155de2a@redhat.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5441020015
X-Stat-Signature: zghws81n9z4igb3m43uzgj1zi7ra9awx
X-Rspam-User: 
X-HE-Tag: 1775566089-598873
X-HE-Meta: U2FsdGVkX1/jUYy8MjKbVV/o8w8FCa+zjWewQuxSZWxbScFvIlNaeVoNhzPGsFa4b1BbBRfo4aSGXduAJK5xp3qm8LaojHA5CWi13Gx/BH8237u/K5qWsyvhcMteHL9Za5+zeXSqcToroqGmXDqLtKyRitVEizdX0X+tuQA9haR6A/63chHAwDCEC2KyE2schnrrfas/+R+IHx/6jup//GafnGhzUd9l20WkJ0mwAk0Qct0hCxxpcZcsyChxW6dHF3lnktfw25m2Z3jLDuCDjzF/0Gq8t1x/svkFVKTxHFdizptmZmr1ZZOODJx1/nKPm+k440QNg11hQEnVlefEkcZLrxqyQsYtcCyB2xJYxLJUlHxM8G6jmn4hP8EvHeTqhQmpnrD4FFX1X2nPs8Togp5faIzVBVCASTQccVWuoxwCwljMp+ilcTtJtVGdjpXWnZMF8Bu3ngsvBU4syv8vTfXQzFDycyejIbBKPh02v3oDzDzFI5ui2NrUa/KstIdG23iI5bFiglgHGQjtx+5IX/eHFEux/30KqIuhp3wtPvmjJ7TOzJokgHKNZDY384tLnmriSNHiiSnRAO9NQEfkhrbIUrquz9hMhX2ItzDqxQT4U7simLH2llmm0usl7zY3TdBk4e1JmNxKUH2wYXZ3T4u7QSCNFdvmVaRrNydwoIvcPd086BDfENNsvjR5x239kEG5KZ2Z1BvO7tEaRWFzPKhFhHa0f9E1VAH/gdeeuXYrS0SzzB00NH5n2OVf6X61b8eJ5Y+aiZHiLG0BMk6zyOxviRjau1USSdm5ekrkN2x3tsixUfW5W7EMxpQlWyx5vPrCqU/OGJ9BElrIpAlb8rvzIkEbPEC42+FWVwKxnEiwtQoSWIe22YWd1HUEUQkk8InFJjvXpJj5fjwccF3HtDaydDXQpBVkWff5k/54leJEsbeCPaORA43iGgwNAj5Hm8cgXvn3aJMDR6Heuwp
 thlvoTAJ
 3+Br15pPkokx//OII7W2y3+jEpAuhkxUwrQiB8NrGluYwkZdlAVZhJQKxKLzY55sEilQcIbb8PM5KyEYW39xeAaU9O08pQ2HDiM7TcR9HPGMhWXQnNFbk8VLho+6bxKf2H1fMX4eeE2SsFCnjzZR+fbCT2wdXgi2vcjVAJQNjb8VrshNgkiqOtq+/GKc3KqODKnaGj98+iiV9iQp7fPh4if/NNQMG9W40IxidCHLxaOPWsOmXrKRW/F4L2pg5klL4xFEBH4dW1E/a87JCesAJbWZoP/kEIhFMaPL+eFQexghiKeebZGZ+mATYV8TlLO+oo/PGMKbiYeu2gvATRDpMOee4xI9d5rF5dFAgEYO1hrPDk6HGfoDdvfvcMIsfv5KCQA556ihCaaFYf0l6RD/O59RkK6X7PUosaltsTJ+yCa5yldA4aoVIVaTa8ZudjWhmpraOLt1Z64FPR39u5JeyOrPy8H/d3aQxRgmeMM75YIMI9stUzkHP9Q6LbuX6wCUWAXZWHMAAVDZ1KLklAUPRdBfofAW3GfnqB5jGJqHuNqAp0Twr+wxG7c/wjJpF1YE0IXG7gOKPPvDesfoIc2wfJbDrl3Q24NJIRwVE7e+3Ew69lds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--3iqnq37lhwpyhhg3
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH RFC 2/2] cgroup/dmem: add a node to double charge in memcg
MIME-Version: 1.0

Hi.

On Fri, Apr 03, 2026 at 10:08:36AM -0400, Eric Chanudet <echanude@redhat.co=
m> wrote:
> Introduce /cgroupfs/<>/dmem.memcg to make allocations in a dmem
> controlled region also be charged in memcg.
>=20
> This is disabled by default and requires the administrator to configure
> it through the cgroupfs before the first charge occurs.

This somehow dropped the reason from [1] that this should be per-cgroup
controllable. Is that still valid? (Otherwise, I'd ask why not make this
a simple boot cmdline parameter like cgroup.memory=3Dnokmem.)



> @@ -624,6 +656,13 @@ void dmem_cgroup_uncharge(struct dmem_cgroup_pool_st=
ate *pool, u64 size)
>  		return;
> =20
>  	page_counter_uncharge(&pool->cnt, size);
> +
> +	struct mem_cgroup *memcg =3D mem_cgroup_from_cgroup(pool->cs->css.cgrou=
p);

This is not necessarily same memcg as when the dmem was charged via
current (imagine dmem controller to depth N, but memcg only to N-1;
charge, then memcg is enabled up to N so this would attempt uncharge
=66rom new memcg at level N, possibly going negative).

There is a question whether dmem should enforce same-depth hierarchies
with `dmem_cgrp_subsys.depends_on =3D 1 << memory_cgrp_id` (see
io_cgrp_subsys for comparison).

And eventually, if per-cgroup attribute is desired, it would make
greater sense to me if that attribute was on the parent level, so that
siblings competing among each other are always of the same composition
(i.e. all w/out dmem or all including dmem). This likely results in this
extra-charging attribute to be properly hierarchical.

HTH,
Michal

[1] https://lore.kernel.org/all/a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.co=
m/

--3iqnq37lhwpyhhg3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCadT9ARsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhOewD9F+F9qnpuYx39EPNVVkg/
SKfJIBup3dSTrvEji8kA2RQA/RMerQbaK2QZn1VEv4D6kzXZgky62HGmS4B6FfWf
8XoH
=uSlM
-----END PGP SIGNATURE-----

--3iqnq37lhwpyhhg3--

