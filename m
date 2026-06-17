Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389DDCD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7EF6B008C; Wed, 17 Jun 2026 08:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BEEF6B0092; Wed, 17 Jun 2026 08:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6DF6B0093; Wed, 17 Jun 2026 08:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E98126B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:25:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 57DCD8D926
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:25:42 +0000 (UTC)
X-FDA: 84889325724.15.0142FAE
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5BB5F40011
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:25:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VcikxgQx;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781699140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GtI51H7Zd74M1RsBhYXt9g8xAv+Fn70VlHsGIGT064=;
	b=wfOtDT4qPhP27BFpdxx21OkY+5CfYnnXEPeDXEz7S9FgH5wVewYQLvFG2anbQBF2l+Y4pQ
	B/zCti8VRoL9fSG0pbBozyD9qT7yEhPS2PptwtectBqk7lp440gka1ECpJ6uzJoj0S1PxO
	JKGdS52l5vNZhELY7l8tewTiAXvJhAM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VcikxgQx;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781699140;
	b=nyduc61kQDOssmc2YnReMSDkaXd1L2j/M05kqGk7uvUDZ7op8UrJ/FOOXi1Qyc5JKWlt7h
	6B9ImnxIelgLc/669khaPG9kUyPsCBHmtW3R0+IAjjRe3eLDwPeFRrynpVMHX0b+IYpr8P
	Pd8+osuBFWtXUx4/tA/cQsUT2aw79vY=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4626fdc829aso625530f8f.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781699139; x=1782303939; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0GtI51H7Zd74M1RsBhYXt9g8xAv+Fn70VlHsGIGT064=;
        b=VcikxgQxedovZh40lRnxx1j9LybMB+ZULnQ2LZBTlL1srqqxE7mHIb8lHNCfGI8f99
         ox/R2O5gTl7ZSb3ter9he7zvllc1csblw73Fb3D0swmrk1Zn3utiEu6sbYaYF268SQgY
         G9BFwPZx4n+rSOATBfXlLOF/xtG46brMpZQ7AiCE6goJci8igSyYlbQBghcKk24I6nRq
         ING78bVH6u6PURsBIE7ZcRXo6KoZYeQEVd4aczywmCQjKLuIzT2ffTjRpN1gi+ToYoT7
         Z/kXXS3UNMVabY6P1zjrfQr/qwUXoMLZQbguFH/tRNnKMzFb9PTEW+rVmcw671ke9WQH
         Wf4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781699139; x=1782303939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0GtI51H7Zd74M1RsBhYXt9g8xAv+Fn70VlHsGIGT064=;
        b=Wa+AEmw0dZflUjy+9DOsxiQXomOdSvXepPSCKl5VCcDJlIioIvcPKGeXp2QQ14ZFAv
         8eZqVFGDG15HRS7l8HuPTMIEo33O8zIfNhRzYvPDWh+buhdVxVLmmN5fijVxxzf4yM3p
         IQzIM3xxROFJaMHD9pFb256SXjyDRV/ZFU88xMyUxv0ZhUyO8g9g88E2TIaylbShQ75/
         uF63khxfEnD1zVnaxQS8AD+BQrpQqb7bZJ7dnsed53tbNHfFujoR6BSiY4fE6jW8BR4O
         Woa0O+DlNOQJ+/xGlaPmvSrVJuTsWURiZSPy1YjDDukS470j39xDvlUwDKVKWx6d7cjZ
         3EqQ==
X-Forwarded-Encrypted: i=1; AFNElJ+cI3ts8MXsuuqrpQlaV9dSW4tzlTkX+HmDO/FN/w6jthcY4KLKsFeP4m1mGeMfSpCUbCqf4hG5Tg==@kvack.org
X-Gm-Message-State: AOJu0Yw77Kye0ZjjVK4NVW4yjbLOGn92cHr/poviZnXa48LZ0QKcZRBn
	KKa3gO5RdJ58QpvevuA7qy9tzAOBcjD6AAd3iLejJW/K4mVjcajC5CiLSDOVb0YMAc0=
X-Gm-Gg: AfdE7cmfQEBYCJdqz61/ozPCW++Zj42fNeSebSMEXBjRO0Xuz1Fw2OQAzP+vKGF9Bvg
	BEGmTxE8oVArgpk9K1LwsyH0VL2akky2ZCmeMDJ/20K1W683mBMpKvoDWrosDlZFze7Quy38ziu
	SAQHN9BQxC+3qwTRKso0IeEWxhO50ew3KO4E1yZowXn2t2dhsPoLRZvzsAFi7cfK1nqoMMr2Ty9
	farud8K/f78m00r8YYx2kAyScQUkKSb90X+fpFJRdIz+ezFf0dmf19am/HxUb43cLGRlTxoAFSa
	oPz7zisqfBQgKOiO20EMKKXJ1E8PxH2q5p8vGzBnErfvTzkraPYL7/awVYqHkcHuVuNBok1cMj1
	2rXtToUu6qdDtQObzpXO8HTxMLNE4qEkb8Uii5AMx5d9x09ny+/wmsuxh4zzycBEpIYAq9zb9jx
	1L1ueFktj25tQObAlokw==
X-Received: by 2002:a5d:588d:0:b0:43f:dbbf:6d93 with SMTP id ffacd0b85a97d-462410d3c5bmr5999253f8f.27.1781699138624;
        Wed, 17 Jun 2026 05:25:38 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f726sm51008107f8f.15.2026.06.17.05.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 05:25:38 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:25:36 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Li Wang <li.wang@linux.dev>
Cc: akpm@linux-foundation.org, tj@kernel.org, longman@redhat.com, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, shuah@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v7 1/8] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
Message-ID: <ajJu85Kq26jWeiCy@localhost.localdomain>
References: <20260424040059.12940-1-li.wang@linux.dev>
 <20260424040059.12940-2-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xz3b5522yngbc7la"
Content-Disposition: inline
In-Reply-To: <20260424040059.12940-2-li.wang@linux.dev>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: aynnenhe4ybpgsidiqq77qg1pczbzq88
X-Rspamd-Queue-Id: 5BB5F40011
X-HE-Tag: 1781699140-631942
X-HE-Meta: U2FsdGVkX193Zug6nMh/x8sNe0rN0VEMyLm98Xq7oEjVMnhDSMbk5pie275rvWO1hIziL8zS76LgjnwnqhIQwbZMxoN9cQZHdnyd9+iTBb6NF2XL3/wjCGXd9TEwCF9FEsKCE4ajP7+s1EEb4Zq15a8JyQgDQz2IYx+Y/bv3ICK3X8poDXv1EHvomZaesgQV1RnUmHvzGzqPf1m0JD0Tb5ozHrOtXdz0RzKGTX5L/Sapu4jJjVaNAcSt7lo5QjCuqLjZwTg9JEWL1pGLJ6c1RvoSLfbdx+Sp+k0YS/WMGnMeRJg7YyNhuKGwDgVTLMnHpAE4DjeOf4Z83Woj9rCUaAIN2AgMX0cI3Irp2r0mDBem7BcFt3sP1VOtfaR3NWje8PRq2Cg2TTd/GWncwaPE5+xLEKp3AHQoKtwOQxNLsRLITvC3sF9OHO9koiJTIT0QaIuKe0vTXF9qrvdEfHeL727Si1J0k895BiPh6nPe7PilCdt7BP3OOTrmA7N+aiJ/6tE7JmX1DJhUNYfpMiHQHzMDVykS4zKRKyHrpapVx8D3JJiQUKcDdmFy4lqjoDzsj14B8rQqvcWFvOgvX/74F/K85s6ueEwNX8U9KxDkw1RvUS14VcY2hGI8lkNStZvB2Cnem5dpLrb0XV7w5U5QhiUWMKBQNvKKp35AkluIxiOX+OjZXfcTm9vZdccfe3aeTHdN9Aa49eTdY0cx3pMuWZki3AkntCbp9H3VKb3+leQwVijNMwSMXd9FgWbnYkkIozWpWu2nFEQ4bY6RSR6WCXZQLab4YA1mXm+MLHRKnkROpw5tNDUiVpXXi3QXQOW7R73BV3e4KobrJt9Nqmxf2Szgzb3PiquX1GqytrPJqPNcLGfv/3VQPSfbqht2DK1DuViRZyfhJgm6PgZ5X65s/cBMJNJmZir1kG13j9454qeYnEr8gJ2Gbc0gCWMmYb/D89VqtorYSwQip9blhi0
 ake2j4RJ
 elSFMlL3AbaO16SQc+nCqr08WFI76lGtwS2NcVCkYV1+EWZ0TlQn3r+qCq4Q1PjhGFvMO1eTrq0Cu2Xcam+qWRCpK5WIsdvVE8lNEO/Z7vpxaWwoRN8wKvC58vBtRP0MHFkLqJVQ6yBpHAeTkz+/spTJ3FP6EtLyzmyfkaLUD/0+BEh395ymmPn70nQVtwGQCjJa6GlJw+SPKDy7C7H9GVc57O+g0xIEzNeJRhjaD6Tx/GSSGZnNasOv63cfUvfKa9MzOO7+uhiLHxFOT5iHLBNm5SAVSGgfSw55ungJSM6dGgQF5ogZcyWakHLfVJw8Gh5s5lFEM/ZblxrYzRR7Xmumas6WSzVNubP2T45EeSgSM+ZWhhw55YGlFPEDS9rU5gqmPmbQU1OGw7QJs74idkfU/5GFXrgy2d9TP60wLS3yxI5KjiNwO9SoHzttYPXKFtlQSipQC8jGVBq0vDXImBvth2PH7TKDf25qgPQrYXyukFIUWrYSZkvlVfCoDn7Zf7ENi6dSz1dMLKkJ94Sm5E4UZNW+I7TGlyp83SMRn8JhfCT1kZh0rf9rtZx73eCFRdleiNDMTJhGyb0KYvseWJhFMxJIPGeDvFmv68lVJh9t08YjmoWOaqBI+sA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xz3b5522yngbc7la
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 1/8] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
MIME-Version: 1.0

On Fri, Apr 24, 2026 at 12:00:52PM +0800, Li Wang <li.wang@linux.dev> wrote:
> test_zswap currently only checks whether zswap is present by testing
> /sys/module/zswap. This misses the runtime global state exposed in
> /sys/module/zswap/parameters/enabled.
>=20
> When zswap is built/loaded but globally disabled, the zswap cgroup
> selftests run in an invalid environment and may fail spuriously.
>=20
> Check the runtime enabled state before running the tests:
>   - skip if zswap is not configured,
>   - fail if the enabled knob cannot be read,
>   - skip if zswap is globally disabled.
>=20
> Also print a hint in the skip message on how to enable zswap.
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
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--xz3b5522yngbc7la
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCajKSOxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ag2DAEA2nNoiQ15OgJR5VxoVnSf
lqGp2dpx3cwAQ5ux10qjH68A/1bVmadDbo1mKFNPpy/OmWnyJnAthaTKN3GT+oTM
BcoO
=cwDP
-----END PGP SIGNATURE-----

--xz3b5522yngbc7la--

