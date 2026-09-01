Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56560C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72C186B00E5; Tue,  1 Sep 2026 04:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DBE66B00E6; Tue,  1 Sep 2026 04:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2726B00E7; Tue,  1 Sep 2026 04:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9786B00E5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:57:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15B4B80373
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:57:10 +0000 (UTC)
X-FDA: 85164589020.12.2B0F41F
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id DF8A640005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:57:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VrcrAe6R;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788253028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xrf2I5rwuZTtUj0/BgFzlW7VpIjkJf+F8+X2M3EKpgI=;
	b=72svZkDjv07Kg5DqmhUwNiPzed/QCpyT3nr6QhyWwhSpAhRXfiagX6s3aW5xH8FauXb6nt
	CuuxRca/RPG4dDls7ii2r011LHnBLGVHX82uE61/aKw8ilVjnsaxBW95dybcQpajsqxZWG
	0wWrSwPYcvnp7HTUDJ1M7Y2IsxFFi+U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788253028;
	b=yqQ8doaeBngAg1I75dDp3Oejw2U5sQdQ7mdBjnFkJLbNVF2LD/0XKJ6WybtFxk0kh8E49q
	tCGywI3/bPJfRoJzCxCvxpiDAjhHJyaDz1A1s2ztZJeccWcU1y6QEbWw6ZmfhOrXUIpnBU
	HBWQttFcJNH71fRyfWs8nKJ0srxznzU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VrcrAe6R;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-499b2981a7bso51484305e9.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788253026; x=1788857826; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xrf2I5rwuZTtUj0/BgFzlW7VpIjkJf+F8+X2M3EKpgI=;
        b=VrcrAe6R97DW3ZxSvr2vWMjGL7fYk3Gz3WydgWowtMnytMdkLi7odgG08PdejvhMxG
         cSUch8E5Lzs57xKVgDqwkv3QpQWGm1eFsFZIfuWHefkQ3P3Zmm+gtvXTnz8J/JpTTpSb
         IZhyk+UrJuCDLyiPXlm+v1AC5+apzE7M9GG3Do1YA+XNunP0J8TqC6j0DnkWFOW/y8Xu
         f4swQ6mDsaetMt6KzkfUdWGIhCgpveABwq9etajfibqJ+zLNVKMuOH0t30c7Evil77V6
         otF53VrH59ZNQDC6FoJNECsTavJY+xnUxxTzixFNU8L+FoWpKbfHfhfgBCTGDr58borT
         aYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788253026; x=1788857826;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xrf2I5rwuZTtUj0/BgFzlW7VpIjkJf+F8+X2M3EKpgI=;
        b=J0k0e7TFenp5W0Njzu5QDGs4cTMMKPxLI7XT6t+7Olwc42sZmXKOYR4/V7Cbpnlmc0
         S8UsiTZyreFop1m7oQBVI0/qVqWQnnDnfgBLekjZMC0bUE+xUpS56qSE2nEdBIrfL05T
         6HLmeioPdn183yeMv+ajuzOZ79r+g6Lsje2Kh8BcbkQEiV93tG+LIRlO87IG4GgAqhSO
         nGFKvxaIkz09CPxAndZMh7Gh049y2EjMnw478HvpQrPKDYr3dV8XR6M7c3A3rrO6uwjZ
         VirUuxa5bL7PWfOp3O1kwcSixNrcX14lLZhDcd1+PnXw9Lr84ljhozPL8erMS6hFDRMT
         1V0g==
X-Forwarded-Encrypted: i=1; AHgh+RoxVzTF81NI9isoMlbETlcd+ZlKisfi98p7Kknwr7x8jApOkFavbVEzChQ2Ow8FYv7AbUzbz0d8Kw==@kvack.org
X-Gm-Message-State: AFuF++kgXlKP9znky94f4Z70GQGBVzYBuT5dadAMAfoIkMsO0/DjrEjC
	Dt6cKCFpgKW/jv97d5FdO30hw4EBoIRfJdRyyFk9pIC4T7x02g13uMLl2wuMflVwQnQ=
X-Gm-Gg: AR+sD12i/wSupKFBfFe23festnmmXsnnl+/QiuconCxZ6XSKNP6FBK36VmGwp/D/BtB
	uhfoOr0oZTHL042651bGIHZV7zjZYFnnlEG4XH0whvz8sK2Nd0ZvWMWDa2I9/7W/l9zgjEaexCN
	olX3ZY+MbR+gD/W4fIVnTa3p5aE1s8Kaym24sHJJA0TgW8fE1XxHpiNYGd6NkwG2IPvuB6KZnr2
	5/pv4yd9j5ImHkHJO+81IJcypgqNqqxtwku6g7RkSVovKgZcoVlFvbYmeh82ZufQ3O2M4AMB0vS
	xZXO7rouAnwJsyJ8jCWxC5WfAxSVY2zEHHyV6zQ4x7uLSlF6PvpsAgMd9eDEi9z/S9wWVXToPI5
	B2GOmgmGZVlWrMqQmUwMorOlYp5KLFIClZ8Ff+hzZ7Hd+nxejc8MKoTKrGd4kF1V30aNEHLStP5
	Pc41Fln+JQR1Q4jeBtz0JzDDFAXQt8fZOk1Lg1r5ayJXFVHNNWxha2KIVxKYgus5k=
X-Received: by 2002:a05:600c:64c6:b0:495:52a5:8829 with SMTP id 5b1f17b1804b1-49cdc558470mr121172455e9.11.1788253026345;
        Tue, 01 Sep 2026 01:57:06 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48442c4259esm3313283f8f.7.2026.09.01.01.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 01:57:05 -0700 (PDT)
Date: Tue, 1 Sep 2026 10:57:03 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
Message-ID: <apaO1OHVQWJCuJDE@localhost.localdomain>
References: <20260901052250.154532-1-wfelipe@google.com>
 <20260901052250.154532-3-wfelipe@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nuwu7tagmytj5izv"
Content-Disposition: inline
In-Reply-To: <20260901052250.154532-3-wfelipe@google.com>
X-Stat-Signature: kcpbnh1b45e54xztfmiw3xfyg99ihadt
X-Rspamd-Queue-Id: DF8A640005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788253027-33416
X-HE-Meta: U2FsdGVkX18fkIMECEPKntwaJkZFf4e2Gi9AyK+WkdF4T1d8zhu8ooFN2YFiu6+kJ4kPUAcaQ1WAl+QFQkyle5feTCmhOUQ58KrBody9XZMT85NpDbQoKizEEQY3L9wCbN50XG9L+uxFuuWq1+q9VEfrN2OSYzjvpm0wuyhWQRPEDC8dxn8wC3qC2jV7RBm6vo4J/tF9kl8hTgTSoR0JDCOvZxZahO7sQvBKwvdDzrZLQa5dV2nRP/h8/n8PQ5iAjKRHNEQW2aRttpG1D7770z26RHO3cy3LqY18YVSXjpg0vk4+worBZN3cfSyvYeumYJSblleXKy9hWcyzFfbU+vtzR9bdlQ+vmWcWWaKIJN6AZOpGr3ME1h5LAl/iPBVZ0RdXfMv6M3Wujh2d97/p7IoTzUdJH/KABeEftJZEXbzTXf6f+w72bBwSLpNCs/w+FYv0mtCqL+YDmAs5xNiUH2An/wQ/xHwlt125ZdpF5Wg6HK0sp4QcfDxzefqW3KTjAlTCXnI+HjHzyruDxP+jSAzovEb0LatSPw251QI8VbkjGrTNMSjPYfMxPqG39UwmD5nrjVOkDXtdUbcZjeh+VlrEAVYukYH38jEYZ2dj2TFaxmyFxgkEuJkU3k2imfsKzsRFbA679BAUw/p54y11Dm7lEhiciqmx1u3/BXdnpMtKZbESYu24DvP8T0fFWHMdinZc/PfW0bXRVFBzaLUO53EE9Y0clI0gu/XUN/Ou/Jtdr4yGLUJHbqzYX5EyYKIie0GU9/HXGIebEJMIScXci3VF+EBjJoKkukoXloR1Z08yYXTzU8wiE8A6AO8lTNJPz1F6OX+EaAd7cGgRHiVtqZSB743zDYmM76DHbnBYGMqzRN1Vc5fseNt11zAcUWogwXztyi+yGqHdqWt5akBfP34Du/k6wCUc9U82afkFAH9sZlqt9IF8Y+O/4p96wvtZtvVyKYQcrKgcqD2IYbn
 S5kmK6EW
 N3djkmFwlvH0UdaUa+CqBau8ebzTYs/3PpN/PTTEVsyPkWoQITPsyZY8XazNNpKtWIPNa12fRolgDFY0iZwbatKYiakBIJQv1KoTd6ZOmPymT8mArU2qYU4AmFO3KVH0yUH+ZV2+QQ7QoVY2equOaRm5slYMtpVWVQsZjEyeOGygQW/pTj/D60qedCGSsoKUCE9M7wG6R/zSVRrQA8pGPJlriKxT5zDuSCNrTXk6/Xtv156dr2s7VxKBceNkTS1ETYf5drvsb1E122lH2g5ZFFzTnAzzSC8MjcUnJXMwSzEy5o83v+m3Grd0nn78+u4QkyE0YZ557rS6TgiQfhJb2zRN/r4Z7v20NJSvkTHTaAijzD3I+Q090DCcQUz3qnYKtJWG2WauO0gBbW6WA0d5PDUH1ovvfxKXvppDwp2TcXt+ERASDkKvSNQWDd0oHvePDD3Jv1WGQ7qNXN6+Za+n9aAh4YZswechaSw9nZiJ0BPysxt5QW+2psTo2IGrXdRrn33gMqKuYJrpA7EMDQgXjsbDD/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--nuwu7tagmytj5izv
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v5 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
MIME-Version: 1.0

On Tue, Sep 01, 2026 at 05:22:28AM +0000, Wilson Felipe Pereira <wfelipe@go=
ogle.com> wrote:
> In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
> checked against stored_pages * page_size / 4 to verify that the pages
> pushed to zswap belong to the test memory cgroup.
>=20
> Due to slight stat update timing differences, delta can evaluate to a sma=
ll
> negative number (e.g. -5MB out of 1GB). Because delta is declared as a
> signed int and stored_pages is an unsigned size_t, C's usual arithmetic
> conversions implicitly promote a negative delta to a large unsigned 64-bit
> integer, causing `delta < stored_pages * page_size / 4` to falsely evalua=
te
> to 0 and fail the test.
>=20
> Fix this by declaring zswapped and delta as signed long long and comparing
> against a signed threshold, ensuring negative deltas correctly evaluate
> to true.
>=20
> Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem byp=
ass test")
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> Acked-by: Michal Koutn=FD <mkoutny@suse.com>

(The long long helper is a non-trivial change, so the ack should be
stripped on this version (unless you can convince me ;-).)

I'm afraid this bitness propagated too broadly.

The long vs long long difference is only relevant on 32b, right?
And the bit-width issue only appears because of the product, not the
values read from memory.stat [1].

I'd consider three ways forward:
a) Consolidate the helpers into one cg_read_key_s64() (same explicit size
   regardless of arch),
b) keep single arch-dependent helper and tackle product(s) only,
c) do not bother with 32b in these selftests (I have a hunch that
   they're not so relevant on such archs).

WDYT?

Michal


[1] At least the values derived from available memory, memory events
    could grow indefinitely. It's true that kernel uses explicit u64 for
    all of the entries.

--nuwu7tagmytj5izv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCapaTXBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ag6rAD9F+z0oXfuQAC+NJQ52/69
Wy9h9jBokjfFxG+tYku4HusA/A3LjZsf4+90ciLSyVy6BFPvXQx3uN958bN5VesH
mjUK
=8Zx/
-----END PGP SIGNATURE-----

--nuwu7tagmytj5izv--

