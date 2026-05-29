Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA13ACD6E52
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9793B6B0099; Fri, 29 May 2026 10:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FEA6B009B; Fri, 29 May 2026 10:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 817A06B009E; Fri, 29 May 2026 10:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68F406B0099
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:56:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DDFE160C7B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:17 +0000 (UTC)
X-FDA: 84820757994.15.0EEDC5B
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2E77620013
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IQlbYRrU;
	spf=pass (imf13.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066575; a=rsa-sha256;
	cv=none;
	b=nJsjDs/zRedkBcht28G5rVlBwW+iIC7XqJnJrKJjZFpPJ78ZYDnPBZDfeA4QiVPUk5FR9u
	3Wvs+/1T2frNkUj+Ezo8pu0jNwUOWoKc9zuIsL4WaajrjYzc6O0aWf4wNA4KVOCvh8PSwv
	3rcT1MSoMMcHWyqThHlUvWdM9vEmhS4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IQlbYRrU;
	spf=pass (imf13.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sxBURKEIs5vdCG6YL1mHOm0YuBgobmnmOVB3aNVSj0=;
	b=3Kqr7FkObAzGGv/J0r5Rbd/4df23pXC3tuAjojUDK4vZWqxD4yFBzDDFx5fIyqA+3gQU8E
	E0CK7F5/IitiK2q/MpYM1+r2/mnRstJlUl8QmixBqVv+OllWgvwBOkOA9MxzVa15e21qD3
	Bv/W/OAqMxByOQx5GeUndYbSBg5HZaI=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4906869f0cbso64066135e9.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 07:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780066574; x=1780671374; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4sxBURKEIs5vdCG6YL1mHOm0YuBgobmnmOVB3aNVSj0=;
        b=IQlbYRrUXiE4fY9cfLDeKQsfuO1qhsknzUijcJwf2J8t3TJPBM6TbTVg5DvrhYMyBz
         45DFuVw9BFxNe5EAFmafAjLDovkRisGoUpPTZIO0Lmw2fSIWwQ62U6mVpDYOs8EOjuWl
         QXt3VlTfOW6FveyX2qltbhGYMUfCCRw5VLR6ns/M7W50cYJxkA4U38pHqBWkUJW9dYtK
         aMdRDYqgZjEWN/ajsIY0/9UMFT79yVKkX8ffVXDBNnsOtvQiXZj+Kzf5VUkhZ8uQ8zal
         xdKjNKYxPUy81HMG4rucww3mfdpj396nJ3rupFI2kqu0EGewIsGeJfkbcteKhINNbTJX
         IZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066574; x=1780671374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4sxBURKEIs5vdCG6YL1mHOm0YuBgobmnmOVB3aNVSj0=;
        b=IcAcSYzoa18MHg9T/RHz6+BVkvNSJPLdxkCOgy4P+JgT589PKcmFi7946coNBe7ZNX
         OpqYIf2zEAw1KGVlxM08HAZ6DxBKT3T81uWdpClggd6Sjghn3XmnnjcwFVNj9MsJs1N7
         wPao0QWBcOPlfVU9ZcqOB/ErW4YITJjz3PzL2iisxwTDrAtpZYNOiE9jFifR4e4l8vF2
         /1r0J05HOThpmTCPsav8gxPzoX0Eb/dC681uc2iXiJnM9RTVKLIB2uVRB9E8lOS5ULec
         sqC1OXnwFVUWtLznfV9NmDG0JgWF0VUDPWKzvKbthaLlkcLzImrCOs+7sdLw6HtHqH4f
         sY6w==
X-Forwarded-Encrypted: i=1; AFNElJ8JOHdugctYlHLy063UfvtU0WIdjTodoZQr+vKM9JXuYmVNlPShr8X6pYFju/A97xVdTu4/C2reFg==@kvack.org
X-Gm-Message-State: AOJu0YyhKXgQr+Dg3SpKTGNGB2+bEBZhwpn7FipfTjhoFIGPSIxjWNs1
	PI7gUguYaCXbMFXvHefrNZ/4bmhrWAtxpLPrOhSa9mAWu2ZV4JkAAwtEvYlViRU6TDM=
X-Gm-Gg: Acq92OFE36Fr5ffm7sxboOOXk3c3mIS7BKGrtzDk+1vFhg3Qoidy8eb9GYh51I9cFxK
	uDBarY7M3NsEtns13+JrwdTLvkqjwzRzZ7t3wyhJnpLZxpfHwt73ocETNCo+979tjKOAZEwOQeh
	4VfKEMhAd+uwfdJnEv7bAfNCduPJSplhoVV5BnnAT1fmh8SjtGv9sx64v1pMMEVUCQynedyjgbj
	BxZQMhYGv/GymX+N0CTgQVC+HOv0ndfybDn2GYZ/nh3R0I2XT3Q+Zio49Y6q14LM6y8UD3oUZpB
	vzrDi+DrkuXAwHUzUfbnNrRplLOxV5mfV8SL2YNEUTrUABS/9wVkDt6luRhyIgIfnv783VKdqpI
	X3iCeEAy5tEyHbU+hYAYCLFvCT8nEnNPCG+DXIQeaRl5hufkNaPbVWnXCoCmY4rEmRODurj6WiY
	AqdFycVeyME8KHapbOyukGMBbIRGPlVFRSbZ6KivC9LAiVRjecuru7524o5SM=
X-Received: by 2002:a05:600c:4e55:b0:48a:9428:5522 with SMTP id 5b1f17b1804b1-4909c0a7eeemr64821725e9.16.1780066573715;
        Fri, 29 May 2026 07:56:13 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909dff2a80sm51054325e9.3.2026.05.29.07.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 07:56:13 -0700 (PDT)
Date: Fri, 29 May 2026 16:56:11 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
	Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/memcontrol: add dmem charge/uncharge functions
Message-ID: <ahmoDiQ8Q11xUgtV@localhost.localdomain>
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
 <20260519-cgroup-dmem-memcg-double-charge-v2-1-db4d1407062b@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rwilhpywdsxyo6sd"
Content-Disposition: inline
In-Reply-To: <20260519-cgroup-dmem-memcg-double-charge-v2-1-db4d1407062b@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E77620013
X-Stat-Signature: m8pbz91h86p67zse11gmmesnst5s8grw
X-HE-Tag: 1780066574-707364
X-HE-Meta: U2FsdGVkX1+zsMCW1wr2zdr5qp9s4J7nWPMhuBF6mHryXCisHf/QI3wtIaLKSe47zgQi36vEruFV1pqGxA08NF0C2kbItwsLoqr43r3ZgI/EKnWf66scxwBdJ7uZHrr5WJ0J/NKurUEAAjeWsVMGq6Nq153YU8SUaK4bBPqKcBJZKVsy1dRhkvioLtJTySpRhnbJpsurW6OOBP4+BZFtlvCvvm2aiRjBojAMUQRaGJcpoUi5RDx+hg1mbWoF9/JOBnzcsISseGg+uveMABHdJw79ZKfJkqDI07RGiCMqAzoRhVe2IUnSyhOyQIZbMGdH3cMladha7GjHiBrUnmZA5cv/KteXVgpz4/TS02egMcz80kL8nEyHt40ZUBfmB4wU/+32TAaUovK/TNs8HCwQHcTtbizypSBcyhdZap1E7rzd2e/pgJ/PTh9VT+3gBEgYil0NWQot5Q3rrW+qVo+coSiWWUfPHkilLru2ELH8uNW6TRp2Sf4bdxA+sqX+wpmWaB3/ipnGcy1py/yK4ItCb/3h2Zua7g4aooBAphLzK/vyTjtQtC9ABQK0+WlZWqgMTezaKv5O1yqvODyyt82GfkXb7wvb0Tm1S22H9pMQ+OqP1z3zkCnRGGS1grz7q+tq+NflBJg8V3yg2deuXBHVwZU6110yExwuiJSZda+Idg5kn+TznlzcxE+HUGN1LZA2c95kTM2W53czYzZmJDZCXsWtpeV9hnu+29i04TouEjJvCtJWXXDdqsPFdZB4nzV199y9Dkw1U+NmrQZpxGAK6+n8lcFtCFl1UTXCorr1nnz/UxH7sDL+/4ov7igirK1Jj6SVhyzlsRQSbdiEur75gIvA9csnhfHZLzEuUcz1JGc/LaGQ9LW40a3s3aXEsL1Cy9UCoJH8mwGfx3wJj3Uy0TL/Wgc2vxV3299U0suDKgzBOSMmMxUQVaRGZZWHuNFLzvcOAxO1M7pwVF9JzZn
 XN3+4gAG
 xpyD1NEXUflknf8uAPb/R7oXjeUhFsaVz8/ky2Qz2PfidXQ/oqG5zAhg8t0LpYPPdA9MNQYKT5L4X468rQhnTKGobYGdIWFxjRy4+HUvnoZQTa7DpSyZVqJLcWLqlpJUV+mVQUWQyupMwA5xX0UCiYj0PnEzvCq4qRI0AJ70XdDODNNIA6oLnW03csc9YEcqkQ6p2NwrhIYJhhU5XYOVc0zhS3hMNP1XQCRC3ISrY9BVqOWjBHyhTMLPA3cB8LuA6zFWfb6nrrK23vZHGAtb898tbFpFNy5JpRjvDrbIM0kgC1p7R+yHylksxIv9Hr9t869CcTxhvvtxOs69RrVoK/AUB6sl4q9Fp7kHotF8cdLrq9qz6uIEilpigbQPBG2yRMmcGT3AvMyCy43QTLw81qfXgDKwMTOhV+vgXABYEWze+qbM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--rwilhpywdsxyo6sd
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH v2 1/2] mm/memcontrol: add dmem charge/uncharge functions
MIME-Version: 1.0

On Tue, May 19, 2026 at 11:59:01AM -0400, Eric Chanudet <echanude@redhat.com> wrote:
> +/**
> + * mem_cgroup_dmem_uncharge - uncharge memcg from a dmem pool allocation
> + * @cgrp: cgroup of the dmem pool
> + * @nr_pages: number of pages to uncharge
> + */
> +void mem_cgroup_dmem_uncharge(struct cgroup *cgrp, unsigned int nr_pages)
> +{
> +	struct cgroup_subsys_state *mem_css;
> +	struct mem_cgroup *memcg;
> +
> +	/* CGROUP_DMEM and MEMCG guarantees this cannot be NULL. */
> +	mem_css = cgroup_get_e_css(cgrp, &memory_cgrp_subsys);
> +
> +	memcg = mem_cgroup_from_css(mem_css);
> +	if (!memcg || mem_cgroup_is_root(memcg)) {
> +		css_put(mem_css);
> +		return;
> +	}
> +
> +	mod_memcg_state(memcg, MEMCG_DMEM, -nr_pages);
> +	refill_stock(memcg, nr_pages);

This doesn't look right.
Here should be memcg_uncharge().

Regards,
Michal

--rwilhpywdsxyo6sd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCahmpBxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjhCQEAr+BVWEm8zFPKmbprS/Y0
DGDmEkJvmxq53yv7/M98beIA/RFe/RMHQUNUp4via8ejOQCz9uiKLY1q3PFlk5c+
ByIA
=eOXW
-----END PGP SIGNATURE-----

--rwilhpywdsxyo6sd--

