Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55EB5CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA0F6B009B; Fri, 22 May 2026 10:17:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AB006B009D; Fri, 22 May 2026 10:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0C66B00A3; Fri, 22 May 2026 10:17:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1AD6B009B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:17:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DF571C1C2D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:17:25 +0000 (UTC)
X-FDA: 84795258450.07.8327050
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2CDF140009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:17:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="bwH/SAzO";
	spf=pass (imf12.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779459443; a=rsa-sha256;
	cv=none;
	b=dOvHTztKBYez9Mi6rCnXy8FYcQZLbzuhHcQ/0e4AmpazXKk8K4nrwLusTVpQ+prc6B6snO
	wz2L6JrSjVwxEKq3YbGoHUa3RHXqJ/oX6R6lJ9M9C2z1SM0JHpeh1Ltm3s/2tD8a7H9paw
	J8cGmIDPixKWufrIU+GJvbTu9HyTm9s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="bwH/SAzO";
	spf=pass (imf12.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779459443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3AZPvBEFe3lqUHmEjYuLSqF1EqkmBHaAzjNMZgdm2Q=;
	b=L9z5pTjqbqXeYb6Eqt3eGr/8/01fyr9a4Dole9JymYUDaz7wGx1hVwTSKN7A/ARvRHHQSk
	OJm3q6htDTXE7UaXmIAlaIDRtTSl47zcOT+RdAaLHinBPjJiUYZc+a4ynlx1T2TAZpABqG
	BYGjjfgpC/3H5JpPTwkvRFbWrC2RJag=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-444826c16ffso6576584f8f.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 07:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779459441; x=1780064241; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q3AZPvBEFe3lqUHmEjYuLSqF1EqkmBHaAzjNMZgdm2Q=;
        b=bwH/SAzOZZzpfL4Kx51xmqqXQLDuVp7t2VwFNiV7vaoojXhomCGbLgUB3+cjZGWvIu
         3amlnv5g75GtBYK4dJWfC1ZBUFEH9keVuFJHiMtVyclDoi0r1Q0vw1y/J5uTiWFHqOMQ
         sEgfIgo3HT/K0erk+Zkgrc27l0mTlj/2MhPttJnvmdDhIp8USqH4s68mkfezGUzmuu3w
         FSFjcgTeEOuWZnr7bVvHs8Nu7MvZKv5YDIe7Yd9xxOVc73XwzJSwGNR8AWBr0dBIEuK1
         gWdfqtnOTL9GMFRDnDdZF6J54q+ZavPtof5Kl/PDBBqBRAcfJts6fmxvuBC01AEKmZww
         DPKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779459441; x=1780064241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q3AZPvBEFe3lqUHmEjYuLSqF1EqkmBHaAzjNMZgdm2Q=;
        b=j2/xxI9eEFDQSAfpf+TBus2XAmdAHTIhHKJMKxsMutUE4NGOmWe1MnVVTfTrgEWH5Z
         kPfzltfNNBGv7urRyYKrBVYCfHSkUkbpCGnU5EANe6VUASIWKa58t4lLcv316SiRjnXo
         owwOa0Ifv6aDVyPMx4q5VMwa+v4bAn/VV+X3123tknjfjj+quzmS6t9y3pLWZS2ab4Jf
         y+HVYGIWlAYQmQR4aNrcGrwALizozwdaHwrXcy69b4IgMLvnR5EI8RR3VlDencMP1XLn
         jMXbh+Q2duDs5q5FJcIouYLHwWwpKGop8jkVb41VuPIhtcsc5b+BS4b6OoGNnRiVYEcV
         uqgw==
X-Forwarded-Encrypted: i=1; AFNElJ9PacMwd2Y3m4PhyxZwWjuAkQto+kipjTvfBOyXnuzL7cPNlou3tRHLNqwn4EF48u86ZJi5RZeRbw==@kvack.org
X-Gm-Message-State: AOJu0Yzy9i1H6WXlbShLwwJhFRBoK7eylGEf/aZzY82RXu5IltBJ4jaC
	VPuR1VN/kFaPI9VY0nTyNTYLb3KhlY4Ywe/nthHTGFPRJg8JftPzVh96baoYJ+DnKBM=
X-Gm-Gg: Acq92OHLAWUTkYyyhP/rmfjDS4k2PFY2ysGW8DQXhDbKx1N3tIRw38hIdQNJMGibOmu
	/O1LBd9hQKsGfryoiWB+n3KParHIXZlI8PQzfESVnF2Ss007od34Mta+xRPyQmtESO4RM6MM98K
	j6Pbmom1/iooPiHJpgUbZ3ELThIqmpNTbad6vcRW24et2goEUeUWsO0XIAY15uX7rr3sscjB/It
	s+PgLex/rRE1iCvhOmxYHY4u4PvvNuFdWMxemfp5kd6XCA11eshy05oh8PLoCRBMw7JIz104LeH
	vLOaegXhJZNHSiYOJGNCYQUvYFaGlADisMPO69F/TmRoccxs4VAtl1aq7RexLzxCAfds4Whw6X/
	EoGN3HumcmGuHb45CwDWlI8N0i8bL/HHSRWcPYeqbMEYWLghcb9p9uk9fIxNz5LWfwH4qkCq3Fg
	IsJQUwk4NXL775hkTfpC/uDlOgDzTGbK60W85kF9bFjPzs3ZBv
X-Received: by 2002:a05:6000:1446:b0:43c:f1a5:56f6 with SMTP id ffacd0b85a97d-45eb38df638mr6017569f8f.43.1779459441546;
        Fri, 22 May 2026 07:17:21 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9f598sm4662287f8f.6.2026.05.22.07.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 07:17:20 -0700 (PDT)
Date: Fri, 22 May 2026 16:17:19 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: enable memory controller in hugetlb
 memcg test
Message-ID: <ahBlG9kRRFD8xSVc@localhost.localdomain>
References: <20260520093130.490020-1-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4ioeyy53bhh73ifv"
Content-Disposition: inline
In-Reply-To: <20260520093130.490020-1-zhangguopeng@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CDF140009
X-Rspamd-Server: rspam03
X-Stat-Signature: ak44h5wh4hr6fxffnfm1xr38jjygkfh8
X-HE-Tag: 1779459442-556619
X-HE-Meta: U2FsdGVkX18hPNppcTxa/B4pEFdVWSrM9iAusru2VEplsag0piC1ehWM4zb8gdkKTKP6yWEnCtArFsNUFO05w2QnU9bCfY9rvBPM/+RYBoya5tJko9MmqZtuT/ESPvWC8589niIIR9KTLZX9xLAEQAhy9PoWXfpVEl2K3qK3i2LirnBIdRJwRcBx3Y4MRnaUgq5N4Wwx4BOwCOiPrSXSK/WhRqaib3bCABeZTTQ48Ixs3h9oqGhH8UQ5C2RiQ4qu45XJ6Lz9BTsbIiSBAhpL12ZN4MMjZx2yEHXvq8Mdr6y5wpWjUG1JeRg/1cNN6x7rd3wRvlD9H0SJuGUNUaGbWaZJI0q8cS55IgeGoWK+6NuU9+QHq1gHoltN46d3N+iudjukbY0rAm6NG6CL2E/AWCi5gOypTk1COKyBoe4oqT+ueOqKGEv+upCS6F5x+MNwG6GtWqLVJOF5vplACAFgtCiKvb8adquVLELDFgcw1fYosQW2u+Pu93JnP3GSE5gwuRHsVzilSxK5j0qjuU0t8AGZ3vjbZ7Ji069OhjQJ5EguVmauRFAhtZzGCwHU5BTx+jIPiS0o9P9WTA4h8bJPJ4BrM0OUR27jRsGgTSN7nMM+B1nvHTWv5IQQdHaB1Cxrc56DepXRNzsrxakDFTuzqS94KRB7tJtNG1w9Oii1GLDNeFjIX7xEwJKexGcnXeb0PLATGQvivndne4uGwe9LJLHs/oRz6TmOJTVBLh3bCvFh8UumxzuErMhXZOyK/xTTR5IRZzhg74lGXojwYG6lkTRVTHzcFmp7kvHkSJTtMqQK43BCjMZ0nXHSU3PGe1Hac8f9vLJ9SLvfzY2SkQM54XecfHOtaEu5BqM3s9kizfS7XpJIxG/mWIpKLj9z2RNR3FA1KXULQU50qyqcs6iBacwUFt3/ZK5Z+D9wZEEH7Qzc3L5YJm+bqhyxk4+3ri0rltfnsaaysIuTA3KEAD/
 vvqMvjoH
 JBWjY41jAIbcIzeigyv1Af+3yEr3BPs+dUCPIZGReYTsz5CE9KplJ46H4oqaqWx5Kz303AOyHR1KbqQeEBZzvGECmq8ZsPVqLwzv9oemx8FZcfA6nQz9KMfe4rU1nkiQQuYB0wtr1V9RnPrsAx91GUZz5/Y1PFjqkRzJ9jrBUnnAHmoudr3hVZOQ4CjXi+TkAlKTcHsxG7APm4kRBGZ2MBXhnZJ/b2uAklMqI8cDQYmA5oJrDokB0sJMAEw9uBXoM/iuT/xKGRIvcGsyQKYhZNs1AhrSzoOHLwQYk/k5s+U5o4aPKJSzAq6JJ/1tu3z0ekPc5J7o7mt5vJn8Md1EXs7VIUUwR4rqvzURl+n8q+aeHQUb1IBaH7laD47DE//M5XBEiAHRFATtA9EqEJF7NAbebbmNPHfjT5Nh/QbJhYjJlEIMQPYdgvvCAaXvt54D5wGrMHhsnRiKVxRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--4ioeyy53bhh73ifv
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] selftests/cgroup: enable memory controller in hugetlb
 memcg test
MIME-Version: 1.0

On Wed, May 20, 2026 at 05:31:30PM +0800, Guopeng Zhang <zhangguopeng@kylin=
os.cn> wrote:
> test_hugetlb_memcg creates a child cgroup and then writes memory.max and
> memory.swap.max. When the test is run standalone, the memory controller
> may not be enabled in the test root cgroup's subtree_control.
>=20
> In that case, the child cgroup is created without the memory control
> files, and the test fails during setup before reaching the hugetlb memcg
> accounting checks.
>=20
> Skip the test when the memory controller is unavailable. Otherwise, enable
> it in subtree_control before creating the test cgroup.

Makes sense.

> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
> Tested with a cgroup namespace where memory is available in
> cgroup.controllers but not enabled in cgroup.subtree_control:
>=20
>   before: test_hugetlb_memcg failed with "fail to set cgroup memory limit"
>   after:  test_hugetlb_memcg passed and cgroup.subtree_control contained =
memory
>=20
>  tools/testing/selftests/cgroup/test_hugetlb_memcg.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--4ioeyy53bhh73ifv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCahBlahsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Aj5lgD+KS03JEmXK2JC8snPY5sv
PAmo66NuwBsqgnP9kOfQ8ZcA/2IFpR2fC0yXtbS+OysEn2k3bmEuzcNLcjI0lbRg
ndEG
=yptN
-----END PGP SIGNATURE-----

--4ioeyy53bhh73ifv--

