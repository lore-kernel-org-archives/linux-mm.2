Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49811CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335B86B0088; Wed, 17 Jun 2026 08:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30CDB6B008C; Wed, 17 Jun 2026 08:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4FC6B0092; Wed, 17 Jun 2026 08:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2AF46B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:25:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 519B04044B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:25:21 +0000 (UTC)
X-FDA: 84889324842.29.6392847
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 40B741C000D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:25:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YWvHmfAs;
	spf=pass (imf21.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781699119;
	b=1D1O8lEdQRYAs0d2Xjxa+zuISVBjQxC4XTGUSwYIgAh56+CDOccjDnJeC/YGt9iF4Vft2j
	5g0U8SM93bAudIssZFvoahL1bZ24NEFrIyVPX3j05jOTGtGFsWYJfA7onjpuLE5jdf891K
	XLZVxisQ6Zjg+srBNNlllmFHVVN5uNU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YWvHmfAs;
	spf=pass (imf21.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781699119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yJxZq3tkF0bDvOTRpsnisysrPdGXlXB3E4O1ntJTHg=;
	b=JETBdzi95mClQlZAWVVeQbeJe/wDzMiIY/gNPQNJjxjaiqa4dPjCuv3tfejh3qFJ/STCJo
	w8v2+5e3xHh/1gW8lXImVNnBsIFT5JRC7jUlKqE9sAZF3B26eMvmEnKYr5D6Vsr2d9kDL9
	6raZRAOOmetl8QL9JLjrqtUD1ogkgFQ=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490b64c8311so55586645e9.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781699118; x=1782303918; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1yJxZq3tkF0bDvOTRpsnisysrPdGXlXB3E4O1ntJTHg=;
        b=YWvHmfAsGmJt5OgEoFJ0Em0A4ot2ojaJWN3qfeeJoUu+xDj5wgfTM1xBotF3wHEbVG
         kzVabzpf7b3nTxFThL8nh+wHD9XRedrcW7nNxKA4Xq9dKqszdBj90ExImMX+LJ/yurQc
         1DRU7RPaN+4W3RGEM8hHW4F+Xwgi7E9fVxtFkKcO7G3YtKPGAVc2Gv+7ZQckne6/5vEF
         FJ0WnwZJXhkn4HWJIh1uY0v0HJvOBZpxb5VvRhG0UlcE+orpHryeo7VwlzC/s4WqSjYM
         bYot88OsLAHvWHR5X0bWPeJOKrAdruK8WNqiKq6aflrBxP4TOLLYZjT63jLcrUGmHBUk
         EpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781699118; x=1782303918;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1yJxZq3tkF0bDvOTRpsnisysrPdGXlXB3E4O1ntJTHg=;
        b=BlbeNqTMzB6HoWuBB6/MEd39l+d/z2AJ3Pp5tG98VtS4/m0AFt7/MKhzAQnHn4cmxZ
         VnNT48mW4rMuBonqNNj3RMqfLHZk0NJ1trZz3Ava2aKeBJ1T1OcAw13jKMkxvb2S+nFF
         jFOyos8eWPgcLKj4rDsbE/2+Y4psU3DrCJEHQ5Y7IyJ0xK5ea1TuKWTnESlUr4uWdkZH
         5mJCLhqaOyn40p3mgdbzwDO6LTl54h3ZEIkKM4lNYozGXfHTgMc8XxW5l/dlj3N9TEKH
         iIaCWVi9iUVkak7WrTYhZNIT90ERUgFgr/gHAVuOi1A1BaPmk82BX/VddFVgnJGwKkBr
         H2ag==
X-Forwarded-Encrypted: i=1; AFNElJ87AZk+OmqI/HBEUsCt4wJW7GuxmQa90ZZe3KKTnEIQPQAho0/nZPNUA21xxE9XSCkrJRKSa+Qgkw==@kvack.org
X-Gm-Message-State: AOJu0YwnGqSuKg+Vvy38W5QfehURj4tnFFYYYScefGn9H5GhbYUDsrmW
	00glko9J9uDof2m4AOxPtGuAtT0/kaP7mNW3GdaKXP47vI0shVTzk907/9/IGJrH444=
X-Gm-Gg: Acq92OHWyetjQxpr+ZVGzuLq4SlGNs01RbY+TpXjW+kKhGRwjWUdSzNBO7zGpvUyJlQ
	bkWDM8bWf/W3przEfTQFnBtWz9TVTF085i9/sXMK7Yklcw726nbUgCTkAc4vMyjlE6l735o6esc
	0KKbfEcgu48ymq3DV30kKnCVb/eqRIsyJts1WHPBaRm5N/1+c92dBdSfVxzRDLSOvKwMhe3SKfz
	/AiqoLeyLStcKwWbJjLRN6WEOb7MyzXH3Q0qe02mQfkYq5p7HOjabhfsEC7CBtkaA/pi78BuPps
	oHJttUQfPSpEVeac9pO8AfB4uVbHFKU/y8cnu2XXpo0aU7RkFM2SSnPTgLCrMXUgvpjcmIasBw+
	wOOrq9l04SnETvWa0rPy+7tU8YZjGU5AN/817gab2NdPfQq7JX2g2Ml/uu8AccGZyKMZtIHz6AH
	k86RznFn4AxLZHnsG+Eg==
X-Received: by 2002:a05:600c:c0d2:10b0:490:e5c1:b8c6 with SMTP id 5b1f17b1804b1-492333a16c3mr51513355e9.8.1781699117684;
        Wed, 17 Jun 2026 05:25:17 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a9a399sm140088385e9.14.2026.06.17.05.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 05:25:16 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:25:14 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Li Wang <li.wang@linux.dev>
Cc: akpm@linux-foundation.org, tj@kernel.org, longman@redhat.com, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, shuah@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v7 3/8] selftests/cgroup: use runtime page size for
 zswpin check
Message-ID: <ajJwNecLWRvX_7Tw@localhost.localdomain>
References: <20260424040059.12940-1-li.wang@linux.dev>
 <20260424040059.12940-4-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fw3psxfcciuimhrk"
Content-Disposition: inline
In-Reply-To: <20260424040059.12940-4-li.wang@linux.dev>
X-Rspamd-Queue-Id: 40B741C000D
X-Stat-Signature: r4s4pqhch8sfp8hf5f4m4d8ssymkfae8
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781699118-240021
X-HE-Meta: U2FsdGVkX1+WMzLY10b4UbZDDLSbYLZ/FdyVVBho3b3z++F+SmRKB3lr16f6/oN9SPqzVnbG+bN0Gbn+3Em00q5q05MeuM0UStJzQ2+0OKuvan1Rrpwd8QuY0Ia3dFApsynGcPNzPLDg1qbfgn5FsgQRT/YsBhQpnglOE67Foqz15y0gtaU17gz5zLI4J8/04irXfV0AESrPqN1yqGIJsBuqAbtGzEwV+aSu7g60YYnoQG6JE5trH6ORWo0PAJyVgP/d2KTjONCsuJst3jX+G+TgG9gPq8IUjNtuuoEqlOSgI7l5jcji/gKbFXND6YKJMXVdhy76U2tVofkxlAma20gnPmJBXl3eM4kBobgcinYWCq1xyR1VDszKU8AI+W9P6Zd73UvdjYO/+VCcGG/2UWdinOTp5IhUDr1Zxsnrh45maQrd33H32ZLby0gOHup1eqGBZgok4r/f3YClf8X8iHbau5havxs6vf3ML9Y/FTb/TxP1HpJTftqI106rNs0jPztHazSqWE5pbTEt0WdiDOviTDjDHY4Ffi8tUzAtCLMuKaRcLh9vY3lLCKmut+WYtFboZHSOxU+MSrra8JgWzgkHQ3syPD4swCmcLgf6Aaf4T7x48dlCwjYppQHP00tlP3WPQwsq1PUFNMr7oTvDuZCc95mLBXbejvwopyxuyTrg/3H7M6N9XgxTyTdylCbrK8yX44qVEziUDgcEcvmVvE1d6SUUdnSDbnZDdDbWzyzmyKXmAsBCe03+WIVl0/sZ9Dc5Mq3aRZeTxMet6J0SocZIarDtDBnPCSZ3BCVyZ/YW4Macmdwmq8kgjs8mf9yyZWc0T+fnZcR5bgqiE/Ttl6X9+5lrJIP3zqQlH186yrR7U9kW4tdSSFhDx6eCFV1dGG5p2/vzHE6F2LMHU3xi9osekLSd1KOugFUJQXySrCHiQRic3vIIp0bsPGiraEtNAIm7GP6D6g/cknvuVXm
 EmuQ/bRk
 sDi4bukP+8y0jYgJaK8qhnIJpIuiRd+4n5yX55BAZsyp08AyfuJagzksFKlkjRZWv91JRlB8/o6pYnecMjT7f9WULsMvIIoCaG7C5O4erjt1Czsl2VZ2wsk7m34efRd4SX1fBWzFxitA9aBexkLhhkjWjQhwixoKioAjefyRxfWtz3697Njz7VudBol0RUflYuPyzc+o8I/JZapVDg94tsOKPrSgOBl9FljyJhCKPnYEsffH6ysSNfIUTgu4QEOCCRmT8XX4d4ZyJK0qLig+GI7KQl6NEDH895LXGJh9VKG93SDajnrJONHZsT4cEWk4WSwVXquuHbAclC0pitKZHRkUe+l/hsxi+UQwslRzZIjFmelGpvFbBrfugzG0KPBEC+FajQwT8KJqi6TOhgxlsC+U2VduJRQzTJ3qnLdfaD7kKOHPUExLmKC0nfHbj6G6tQvRIBLaJL80i9Q6wHUCYJrVQeUD3DSo0olSeEmREit9yLL2rtGD8iHXi/M0X1pRXQyF6mWCUPZz7k+pbWggENnGad5bYj6W6ygIEhIsC5sUTNbnJDpS9Lk0zSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--fw3psxfcciuimhrk
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 3/8] selftests/cgroup: use runtime page size for
 zswpin check
MIME-Version: 1.0

On Fri, Apr 24, 2026 at 12:00:54PM +0800, Li Wang <li.wang@linux.dev> wrote:
> test_zswapin compares memory.stat:zswpin (counted in pages) against a
> byte threshold converted with PAGE_SIZE. In cgroup selftests, PAGE_SIZE
> is hardcoded to 4096, which makes the conversion wrong on systems with
> non-4K base pages (e.g. 64K).
>=20
> As a result, the test requires too many pages to pass and fails
> spuriously even when zswap is working.
>=20
> Use sysconf(_SC_PAGESIZE) for the zswpin threshold conversion so the
> check matches the actual system page size.
>=20
> Signed-off-by: Li Wang <li.wang@linux.dev>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutn=FD <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Yosry Ahmed <yosry@kernel.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
>
Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--fw3psxfcciuimhrk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCajKSJBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AifigEAsoKP16b+0Ymtb3KGVhyI
va7ay0/8bjusHJQkcZqNicIA/1Wml5S9Nn0nE+3XPCz+4d6nCaUqIpGdRKFGT56w
XSAD
=y8NZ
-----END PGP SIGNATURE-----

--fw3psxfcciuimhrk--

