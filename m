Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A75CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077C66B0005; Wed, 17 Jun 2026 08:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04EF96B0093; Wed, 17 Jun 2026 08:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80296B0095; Wed, 17 Jun 2026 08:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE7566B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:26:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BD4814040F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:26:07 +0000 (UTC)
X-FDA: 84889326774.02.26E3D01
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3B0CF20006
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:26:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XN9K6dnx;
	spf=pass (imf13.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781699165;
	b=3V+wOuovAcNIyEAL9ThpeQuSEXlHdEKWVx46HeRyzJ1Mf8hobcPRvX1OZShjxPtIy2Zfa2
	5Ut8EDGmlzv06jL2OuHTvNIlGuhSizow6P7aVVW+Bg1rdT44KYtKpuVBFvtYLUnVFU/T9s
	nLZnDkWK/AhhLU5cIQ3SJMm1JWqgbAQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XN9K6dnx;
	spf=pass (imf13.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781699165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPt25DcGCAYbTcLBdAYH1YOTb8QxGJA5VYhPTuLTerQ=;
	b=fnesDngbUY6kPm1SO5JRhAOZTlYCw1DRzistW2GYcICtL9zvLiDw/l/5zgRVYhChJpBXQK
	GAyW7Ri57vO0JUfQPB054uMxmr15cIEb0IN5Amv2v3QFvVlDNmygtDmWMetrdRkOwlfwTN
	papwh5BfR4J1+rJ6tSd6/zsegcfKuxA=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4631679f204so219087f8f.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781699164; x=1782303964; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UPt25DcGCAYbTcLBdAYH1YOTb8QxGJA5VYhPTuLTerQ=;
        b=XN9K6dnxH7qR7lfQ6y+lCM4WPezxWJaM6C21ya7utZo8lSllOtBI7/p6dPLp+FQ1vK
         pdbMMvs2roErjKCGob9W4W7H32PnUvgoPTQ2zlxRW+AM47L/z+RzhVhP6DzEBogfDBuZ
         ZTErF3l1rw3V/BggQO79kWKKbRm4/MK4cix22gfTINkAVNsnciTecOqWMRD0UVmnRhKg
         ASYV9b3XXad0fTYmxGWQ5ugO0Yc8pQFJOglPJ+fu6LN/goLeTKRFmH76V0Ocvcs6lI13
         8v0JLup715cuASYH2YovIo7G2ZEtU55qyO79ksKf1KBSjOIrz3V6AQr3Pnb2i914T0FC
         wl0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781699164; x=1782303964;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UPt25DcGCAYbTcLBdAYH1YOTb8QxGJA5VYhPTuLTerQ=;
        b=gTsVpcbDt7cnqh/uzCBgNjP25vL66oFqPDexiHXz3QuRb3L7d9LylAxoXPEHJhnH8f
         pO3t37uuWHyXjv5ZKvV7UXt+wtL9t+6b/Hu8XzdXrw49rREI9dqB0/tduAavgoJq4YA+
         GW0p0B6SPMMA26HwOD+xQMX/dHv/xMbn2hXzIOWPdAS2zKmrlAJm70SwPFOleYIcGGOU
         Lp3E6VJs767LvbaIAC7x23mSNlV1yydPR2o7uMpZGCZbYG4Ybf+IdAyd0avYVd27sB+c
         ELZbFI0c4cIcW7H3/WLzf8km39cJRX1/ENYNr80zkt+bioJx6uEJ+xq4wjKlMxZVXWae
         W4Vg==
X-Forwarded-Encrypted: i=1; AFNElJ+Ye0BoUPfmf1elwByAD1kouRMYLSf9WauhW/xL7P0gqV1kv4txXx8JoyekiAhikvcp49YK3+lyaQ==@kvack.org
X-Gm-Message-State: AOJu0YxLQ9C7+qai7jdqb5GhIFgtkHLnG5POIUj/JMl8vUbd46e5x88v
	FmoWw0qq3q8J8A6UP7rWgFH4R9CGDTlLKMI+FJ8IhvcCYQGCfopQNlYmxneN7Xausco=
X-Gm-Gg: AfdE7cnNAi1Oqj+h8iZNuMWyq3XU5tDyiwLgX/5JakqHqCIgABtVZvaxAeainzqmVGq
	8WSJpgy80l8CwcRGHIzB9cCpP0VUCaCm3YdWMVUYAexxieEIsZGi7gYLNVH0ppbpXaEEssgxFlW
	AgL8EoOZ8V+LxbXL9WbbmtrNQvBuNqlbq1eir3k5AiV2zk6rVMzpVG4TJIeah9RtzFhNJPbc2Fy
	McWENfQbiobHfk3Jwmk73VZQ3W/+S541dTUfnLkJTfjy4wb6lMOAPg/sFnEfHQPOfc+VktwJC/x
	nQMauwZgUIr/9yl6isMCU7nC3I7Y/RIy+H0kKGeazu1F06VForjQ0xZA3ka2IrTKto+HCzcl5rc
	nU7oMrtaZ8R85yjDEEcdRM7Zdsoxzaj/ej90taEOUquRE0IUIUEenIRbpmc0trBFxD/+iOaP8KG
	Z8B247JkNOw0Msg03VBN0JP6nsvkZA
X-Received: by 2002:a05:6000:603:b0:463:1d06:ab33 with SMTP id ffacd0b85a97d-4631d06ab96mr1913666f8f.27.1781699163597;
        Wed, 17 Jun 2026 05:26:03 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-462e7fc53fasm3497433f8f.33.2026.06.17.05.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 05:26:03 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:26:01 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Li Wang <li.wang@linux.dev>
Cc: akpm@linux-foundation.org, tj@kernel.org, longman@redhat.com, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, shuah@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v7 2/8] selftests/cgroup: avoid OOM in test_swapin_nozswap
Message-ID: <ajKRLmEoR3P2QTNW@localhost.localdomain>
References: <20260424040059.12940-1-li.wang@linux.dev>
 <20260424040059.12940-3-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n7t6jkbdigw2ibo4"
Content-Disposition: inline
In-Reply-To: <20260424040059.12940-3-li.wang@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B0CF20006
X-Rspam-User: 
X-Stat-Signature: k13iswaias583g81knykh8gzced9iu9g
X-HE-Tag: 1781699164-881508
X-HE-Meta: U2FsdGVkX19EdL1zrX6J5a6oANVMCAzl+THX+8bhrAF0IAHNYg8EHTx4KWEsb/AGn6DoJh7+WRZOr7JSW8ik2YDx2Tw2LhJbPxF2sG2Os1GqzeZY4SZXre2D1x5RA4pcgjWHL/r80tcU8udEVT3GIlk+o17ix+VjtVazbuCNkxrT4LWcnIfKVmuJ11LQF4PXEe/SQ8fSBiLhCJ7syvauZ6rygcKEgbuSjf6M+OInW0QgUKEsm/c0eI29KoBP+yhKFjYX094vsKAOxIKcTh0ZL2+aAa3OZCmW+SFoidkZx/oQ9KA3m1jbotq6zQo9kzDvPyN8Y3/PnviZqXu9QONQJQWGVbVLL7dFvUZcu31QLWU/Cl7TzxJwLZ9PMy43ya2ZVBROOTN+xVnc6Yo1Yo2GRSjNoCR70eN25kJfNMiegL0NRRD4Equ8hr84VB9ISyzjYdrMjsVIn5XBXNCyFvpergs7IK5AC04Csg7LVBJ8pHwgH4RHxSGrQS6186HkBNd+CeNnBC1P/WAiylPP04qDglMEnCx6L6WMJ15I2PA+I3YZx8dRbbXmES8sRflmxFtqoggtJF6PLg7Fa8fLk+tQxvMwxSoQh67FDZcphFXYDBeI+VckmBTUrE8JKvPpJxWDFJFDu/RGk71sQPfpyjvyJtp0zZPd5eDOSCjJ+6hn9VlelhAgLwn1zTxABVT+vJRy7E8o4t1Mby3FmIe7OrnW1B8iJl1AfdTQ1xMHJ+7LqDzIUjKQlH4BolO6qGiSp0lMFamKuxVpDc//WQY4FPWGteO8yPGy1HKkeaomnpqSw4ixi2L+cgQ2G6l8KDPQ/0pTHOJSa1+P3d+OtBcscpwwKG7dFVoQ3QF+2cMUwJtbwd8WqRcZqAk1kOj5NYSR3C5KL/IrJduumpUAZ6bZiixgnv8Bowy7i7Zm8EbvaZ5EEVrL6jZkzL59kcuCro2bchTs+516NdLVBmWS0atq24Q
 FFHk52nl
 O7sr+Fl1hAm5GVdlXC2bljoDsYP+Wepoc9yD2V/nXsceAHI1FxlZm7y9sUBaDCSYFcfnyftQQ3GqZwBp1ehsBbLd8zuB/pUpkxKAT/hyNrfk8U21RxAQsqNFx++xpfj7ZSFvWcXz+JVK2tcK/uihFcqPYeB+kqzgLmAb02XgvyKKTgBtJjnrSw+71u+h7WtVqYD49clPCPkxLsVG5RSNj1Kl3JRcYks/uVufWS0vGqQrUwPygoeqQmU79ZGZlvqd3ssB61PGhOa5gDkpSecfGgtEbfSXJFQEWNNfIuKcxZUXb0iRLGYqdbH7TiHSYnUUBW1k1wAfTdujjQxYEcHOckDgivsLHIGO0UB0wrq1xluRCU6icVw/ANQy2PIIeyKspQBa3Jl7NtvvlAJJh4/4sUjjYW6of7Clyzlev79vybzx3YElHUq9LS2YdTAw3ihLouGQL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--n7t6jkbdigw2ibo4
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 2/8] selftests/cgroup: avoid OOM in test_swapin_nozswap
MIME-Version: 1.0

On Fri, Apr 24, 2026 at 12:00:53PM +0800, Li Wang <li.wang@linux.dev> wrote:
> test_swapin_nozswap can hit OOM before reaching its assertions on some
> setups.

Is it because of differences in available IO or what does it depend on?

> The test currently sets memory.max=3D8M and then allocates/reads
> 32M with memory.zswap.max=3D0, which may over-constrain reclaim and kill
> the workload process.
>=20
> Replace hardcoded sizes with PAGE_SIZE-based values:
>   - control_allocation_size =3D PAGE_SIZE * 512
>   - memory.max =3D control_allocation_size * 3 / 4
>   - minimum expected swap =3D control_allocation_size / 4
>=20
> This keeps the test pressure model intact (allocate/read beyond memory.ma=
x to
> force swap-in/out) while making it more robust across different environme=
nts.

I see you used allocation value that is preserve absolute values from 64k s=
ystems
test is differnt on 4k ones. Any specific reason for that?


Thanks,
Michal

--n7t6jkbdigw2ibo4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCajKSVRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhqQQEAhKvnU2uXdtmJBVHmhU0h
vihGBStgNmEeFai/1TzvfbMA/jfIjPkmuNEjQrWZRoxCNCCn746++JvMF9TKwDBC
VKQL
=xbR8
-----END PGP SIGNATURE-----

--n7t6jkbdigw2ibo4--

