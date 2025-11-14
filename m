Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C2C1CE8D68
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68BC18E0049; Fri, 14 Nov 2025 12:56:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C598E000A; Fri, 14 Nov 2025 12:56:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52C388E0049; Fri, 14 Nov 2025 12:56:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC4E8E000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:56:31 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA9A21A0475
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:56:30 +0000 (UTC)
X-FDA: 84109967340.10.9C238B8
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id CCECBA0003
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:56:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VvOWRnoK;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf25.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763142989; a=rsa-sha256;
	cv=none;
	b=qfmCXiAhBt+BeKw5SM9Fi0smXYABHIhANtKvWxGJHvnw7GGD3s+k3yBBaXNXjxKbcswVqJ
	iGA+CapFDdngj7OJIFLArsJh9FqbNNEVbrH0MgnqqA5OauGXodp2Jsiogunf4vyReh3Zmi
	C0qXN++udtUaydmkmui3rRRPwINRMiA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VvOWRnoK;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf25.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763142989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zWQAU6Ma3m+wki4R+pps61nPK17IsTuakpJuoqTYH0=;
	b=780WndgCXcUJG+hcrvHBlwaDcmcWLntLFw5t6SiKi+fZ9P0xbm5tqycCvku5heZyhMkTQU
	QRfg7m0Ju/EhlYnUxLVEP99xFubRgONhQVu3vmxI67OkDdJA0fAoRhDht/4j/hm6ZuwRq5
	kC1sye/m/KLnkGKtEUAmiW2x1C9JEhc=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4775ae77516so25194495e9.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763142987; x=1763747787; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/zWQAU6Ma3m+wki4R+pps61nPK17IsTuakpJuoqTYH0=;
        b=VvOWRnoKCkyoAhvSiHf7pI3tF+g7lpfY8Lh6PQJ+eIx+wuSNb1ofaFl4FM+jgvfv/0
         n8XI8gXf3vgHNpZ+ryhAe2Z9fZYfF2x1ZsTfZE+m3HHqtciBlMEDJRPOVsv1mCs3DoKG
         zZEDBcNgF50g03doHv6/6Rvi7NCDbEvKFUu0reLA3xJcFK9sFHpnFFqy1n/vts5J4hjk
         IklnDBmbgj6fFIRBlf56/l4qWhHhjRvoUUSiDVpB8p78kTlIA6cLD5LtB0nNB7+7zjpO
         X4eQmVSs9rTeQG5WUtkklZQTdwwAG4Ks9LIRXB9LAc2lYscaE8V3d2laRN/Kb15XYtO1
         92nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763142987; x=1763747787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/zWQAU6Ma3m+wki4R+pps61nPK17IsTuakpJuoqTYH0=;
        b=Yw+UcGTYbdDsql7PlW3Rc3LqGztqng+bc+fz96vqxDqn1/TqzhzjSSf4Nm3DlKWNGk
         9EZMfXNYhMojNNasajyGbYzL3n+mt4Z6TLAJ5WVjrm3vQvII6J+3LKlfiN/sEcPTHZ24
         G53OMHCVMnwb9laYRMA/Mx7miNf3kwRdZdT5TBuBtJaQq73TvBf2JiCR60904I3NMMvS
         +jffN8uxW+Yhhm9MmwmNy9N2V+aIK5zmgX2Y7EYvmKGuz1vY+0eYX5cA+H+W6ER/KMsf
         qd5IBZCWZU3m67CM1PRSi6kSvxZalNN+9gHHbFHbMzf8QwWmVAR/6VLvvXEw9/KKQc5f
         t46A==
X-Forwarded-Encrypted: i=1; AJvYcCV4qa7n4tWRjwVWI5E47yCayl5yWgQOYMUShksKzmKpQGo0sGRvVSTOOVIjNZhioMjsfCovuzxtqA==@kvack.org
X-Gm-Message-State: AOJu0Yxbq11jlZEvosoeR9xj5TWJwjvNWg5m881dRR1qD9+zjbIFFT65
	YZYVcaUEb+dQDu5OC18s5ZEKvjJVQOJtxCIlzVbNE6pFJgTlK0ygIboNOY+9rAizORA=
X-Gm-Gg: ASbGncvpVzbwnrOHf1/sLMR6tUCT7gMBy/xYhDVPPQhcEwc+XhAdBc0LJPal8O3Fwaj
	UsmmX5xL1pEC5fsV7tG5dOe0fLa40N0H2GRgXCDaQGT5cDh2alcRvvPt6Z+1UsJ+8SyLVKarfgP
	GmPTXW/CURphxfGE1INPH/RiAuOmse2EYnU6kkBUMqBOtZ7t4qftosLLiOxcE7EMmwMqUQLRGGy
	1qEAx1t4VngcDLenb+aGfkeeaj6u0M8JTYQrY7Z/GGjPavsUc9ySrPHZWY+uzmUohpa6dpwmKQX
	F4AQBnp9O/qNSCpjU0jAxZHDCdPxLsm2SyCGtjpO0d4jmMCj2Ia+sqlFFDgXM10l+I6Y/qD+PNk
	bEFbcgLw/aCodK6FU/JGRHzLFZs7MuGwcv7TNjUxnRmzX3SrTf98vLIp3PLzp5VL+60R7kfhsVO
	PyIrZofKibekIyjEG1TgIpWGdJdyAgXWo=
X-Google-Smtp-Source: AGHT+IGvkm59trgyj5Gf5HwmmxSfxtaMfLKDTGvS69c4IEPfzONsRFIZ9Nawmf9x3L5Mg+WhWkKDyg==
X-Received: by 2002:a05:600c:4f51:b0:46e:37fe:f0e6 with SMTP id 5b1f17b1804b1-4778fea749fmr45845015e9.30.1763142987125;
        Fri, 14 Nov 2025 09:56:27 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f206e2sm11201352f8f.41.2025.11.14.09.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 09:56:26 -0800 (PST)
Date: Fri, 14 Nov 2025 18:56:24 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, david@redhat.com, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v1 25/26] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
Message-ID: <v22vajeyu2cj43euhuomfng27o5c6pvxcohijqmoefovbo6hx3@5yursykhzmxk>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <44fd54721dfa74941e65a82e03c23d9c0bff9feb.1761658311.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vp7kuhwwo5mfi7fv"
Content-Disposition: inline
In-Reply-To: <44fd54721dfa74941e65a82e03c23d9c0bff9feb.1761658311.git.zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CCECBA0003
X-Stat-Signature: oo8hcznhpdigyy7wwcessi558oy9uffk
X-HE-Tag: 1763142988-606603
X-HE-Meta: U2FsdGVkX1/dL7npfY2kAZDEh6D2wBsqsNQrILgdDdSFH9+kkaH20xPtB1ca29Pz2m09WUkm5rogR7SK5ALXHq9aiC/PvuCxtRI9pgezkFLCvgENneJu03vEqsha58m8q4MvKwKpfWcI+X8tkbHlCLmfRNOy9xJZqNFNGwdf2Py7W6cX3CN0Qrg9/0gG/bv07E3YxTFwB+OladAj1qUO9ERLLyyXXd+vIdkLJF531o3kmhH0zoGN6PwdgYRiUawKSnr4E+D6tTDMiDQkqMiuFTktz3/bn2EetORJopungIavKDm0IGqGODOcx7VauvjDxxdI+Wfx5KioxqaOenaBtFBuZ00VbmpxsvfuLSKGDp9zPHg6ZquIGIuwSAyBtvw9yTqvLOjFIBrn4NahBD4gbjYDyC35XenM4dw+tbsBMMaYJ/3sBuy0e3YpKMXiazTJJBKRLxebueR/euHOtonFNB92FwAuEwg3eIKTZzZSGJiTMUZ0/yhXfUy9jX9oW/PTXv6CVxYE1yQkp96iaW/s78n42Z09ArCE2tUsI0zGb5iDay5ZbCqOJXih8qw2e18CyWRxy02v5MD7O+RbfKaKjYzKOr25sPGdiaR3V+E2P7qnvzJlFaMbzpjADBL/GF94GCDFouAp6f+0wd8sPSEJtptnotbwisj0+I2WP+xzHGoA2TsgfrLAMlYlgDMVQ6N4MLc54lpl2pcV/4t9XcJ9LhXJD8lGHEZAp3D0fJkoTM0RAzISp1ThBZzxAA8WarbIP/PXuhzUJItNfT7cVDZzwULZMMVpfY1eckRfM/YemwjB4DQczhoJEEzXbSnxBLBtQKxFYvsabuUQpKqkXMTxEEaIcdEA+YGOk82MwjecHWaTh2QeOqU5p8KbpIT7G9tD3vJf9RJu0VWIzauMcvpsLHmcUXmPF4898Yy4F/qnkHUjIkvXRWsf7fPS59qtcxzqmjA5bAzWtVXakTRQn1q
 ku9JgIGZ
 afyoVSBSwSh3pxoixmRnNQ5Khq5aS4eEKjkJQxPy7CJZ+YaUpEj6cXSuznmbSYsCnN5c8XhNrBlGuiCs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--vp7kuhwwo5mfi7fv
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v1 25/26] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
MIME-Version: 1.0

On Tue, Oct 28, 2025 at 09:58:38PM +0800, Qi Zheng <qi.zheng@linux.dev> wro=
te:
> From: Muchun Song <songmuchun@bytedance.com>
>=20
> Pagecache pages are charged at allocation time and hold a reference
> to the original memory cgroup until reclaimed. Depending on memory
> pressure, page sharing patterns between different cgroups and cgroup
> creation/destruction rates, many dying memory cgroups can be pinned
> by pagecache pages, reducing page reclaim efficiency and wasting
> memory. Converting LRU folios and most other raw memory cgroup pins
> to the object cgroup direction can fix this long-living problem.
>=20
> Finally, folio->memcg_data of LRU folios and kmem folios will always
> point to an object cgroup pointer. The folio->memcg_data of slab
> folios will point to an vector of object cgroups.
>=20
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/memcontrol.h |  77 +++++----------
>  mm/memcontrol-v1.c         |  15 +--
>  mm/memcontrol.c            | 189 +++++++++++++++++++++++--------------
>  3 files changed, 150 insertions(+), 131 deletions(-)

(I know it's not only this patch but all the preceding ones, still)
thanks!

Michal

--vp7kuhwwo5mfi7fv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaRdtRRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AiOvgEA8/WdRJNOUmjpb/24RVIl
GID3YBbL9hqwcUzr7MBnIckBALfq9W2BMaoRuT47OYa+jpLmvbum3XNZT6HvES04
UQIL
=fGfQ
-----END PGP SIGNATURE-----

--vp7kuhwwo5mfi7fv--

