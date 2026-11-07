Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55483606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 23:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M9AuTeG/
Received: by kanga.kvack.org (Postfix)
	id 581A36B05B5; Sat,  7 Nov 2026 18:02:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558786B05B6; Sat,  7 Nov 2026 18:02:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F766B05B7; Sat,  7 Nov 2026 18:02:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26E6F6B05B5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:02:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94A6F140410
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 23:02:36 +0000 (UTC)
X-FDA: 85409849112.19.6DEB4A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EE60718000A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 23:02:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M9AuTeG/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794092555;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODEFshzPsmt6jbffRU5HBwlLEZaxy7bDLgcL+MuZrvU=;
	b=QW4hR2DueT29l2mzV5xjq6D1+ixhMjfhInmM1P7GdKauTY09jSDHdC3v7sxg9QQOKnG4RH
	n9Zk1m/ImfpFk0zKgm4ZVGPAKE5wyV/x1YxFvEduh8TM7zbg+h42GjiVRtzDXRWp5UB210
	d5+zK7nQ02oGZQEAuLtDCXB1ieBsD8M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M9AuTeG/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794092555;
	b=K9DBmkkBwKFz6t1kmq4eETjKVePatHxRh2bFdR73laMMuKY7VMKU7PKNkEEPoH23KLChYu
	AwpwdQxhvG9lAmpQOCMxpcPdkindyGo+RkeOrVgTVwbqx3i4/dV+c47RiIZjiChyqpXy3c
	CZPAsYphmDMgeldVdM1mnajvR4HTXYQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30C8061213;
	Sat,  7 Nov 2026 23:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08041F008A6;
	Sat,  7 Nov 2026 23:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794092553;
	bh=ODEFshzPsmt6jbffRU5HBwlLEZaxy7bDLgcL+MuZrvU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M9AuTeG/5QA2dxBfiho8NEnGkYULK83353V4lE3dS8j8G+gYWcLz6c0n/vrXb72eh
	 M2Cy8LPWUQ/fF9QPxhKLYUixevq8FHamYQuguYjmytZ13Da+Q4bza5TpYWTAAoZijp
	 ejdlFEgq+vzVROJefnRaSFgCcJ7xGo00NxKtpUoNCXddvlrBLq3qfNnkyU2bBmapE9
	 ab0G57PUgjNsucNKQDpuEqa5+9s/LC5sIJI1Cj8WlUfwfdUYMWsT31M5zyvFTKP1pq
	 es3tlJ60t/bQvKdDAG9onqyp5GjEFgP1dneSUrw1Jo8PxonEC2c+ARaXC3e43aHMUV
	 GRLROXcaGVZQQ==
Message-ID: <sashiko-outbox-203374@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6.1.y 2/2] mm/damon/core: remove unreachable damos
 charge_{target,addr}_from
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261107224800.340250-3-sj@kernel.org>
References: <20261107224800.340250-1-sj@kernel.org>
 <20261107224800.340250-3-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 23:02:33 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE60718000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 7ncibur1pd5446n638tryamixt1xax96
X-HE-Tag: 1794092554-174182
X-HE-Meta: U2FsdGVkX180+HcNx0KOWKGUSMqUqB41GfkYY54A/wmmJ/vFpNVbpw5zpNLKNoWnIcYluat8WaRbDbfEMyQQhGdNE/jd+OfkoeDdp05FudEW/PPRHOttYJ5AhyX37RwrWdwd4o0ZAmEIdMZo9Z/FAbAlb9mEYEYucg04aIjkWELoBJB2AhCNvvuxqkhRUfOWmzl3z2mu8ngEs9AWTjv1FODKoP3j+3864mD/qzO0gwyvfGo3/964HxzRYegCFCD76JsvHSRnFiAA5HPDR67/d4PuvBwble4QlbxaBRdJpmgWf+oWr85dVt4m5C1FmIZP02SynaP/gjfxonurxax7OzeuOUk00p/TN6gny0ezbMItpgV9Zb2DePOZjA3m+6noVmqhUA7rOq4CsZPgvD7I2fMHI7VxahQhzRBSCwMVSoOftEcscZS29XndEdeMIWCJDfwas6Zb04uk3Ao7o+q9FP27jpU9h61wTKPq4A9Ki8m+rlcpQWUJqG1bjsbnY4y7tsGeu0xHygv8jYk7B9TksIJ20fMrT7MTCAC26WkXCtx74SWebq+KYzLr702AhM+srOeEO+VT3UEtXletE1x6j3NNgL6j1h5fgFOmJJb9gCSyJrMx07bpI5A15/kqqWk76DpDAeDvWtI3eNfL/kRFOnBEi36o42z9OoQVc5O2UIF6wYrTK/f5tioZ19KPXCE4FgfTC3fpKA5izrkLlHyduRQ9Q6fTl4gfSK+2A835tArJg+6D8bpFNnmDmYLIx+gXoVQ05TFMGv2JJjo12gh+U4qEe+BA6U3L01Ip/W8fVS3L71KBs9TqnXcS00IbGHrCwR3i+JmSMkqcfZ5P/UIA8iSqTSb6nJQ2eDC86mvjttFT6IdTzuqjQ+TkWDo3sZYcV/KQeokczPsk0TsNjLRbUx8+uvEo53xxsCtZO6o5mcTbsX1tJ0IZa5rXyUwIOaCLrua5UoYhfmVdmAlp1uQ
 GU9dSafP
 WOIGGwZmnChwCUrNS7o5YoClqLk0p1u8eoU0D+eBIAjTC0kFhJoSY77fE4sVbV0RAIL//B456cJLWBZdp4rLYaDxKIQ4hRtKclzNeM9IajQjCeZp/804JNn7GiNwIHAnl+OuT3Nnvd33Nl09tEzpuJGdwJrZHJWwQA9419i+nmP7yj5ficyjMBQDZSA4kaBMUm2gvVy7Fjr55N2WKPtLRQeBDC5lvy+/8tMV0A8DkLuTM17mx0vtGRL6dbe4JU21u/HDJuWe5c00yL+JsZea+JKQrGgh6ipkf3fzfDJAi0ArGM/+n9b8sNvVinguV6FvW2dpH9kGDkcbjFKAOxVAMnrZMuDVOi+aNPZ2YcFX2Ypiy9FUr+ddrGd0lrhiqYlqXttmrlKNXt96Zvroj9o+rLq9BuN/3KEYw6yM3fkmBaZC7ZBvOCJ5XtqGUmTRWZqJpdx1sgPmVWQgtepF2ZCZ7K0XqT71ssg6/oVA5WL/zvRWUCDCIf7u3stxn1CAALUJU9o1YidX5uexaFt+JRLyS0ZE+JzwMV5Z3z9/T72vUHf8mWEMS8BUoX7kj5B2lcocyVgxPGKRv0p5Az5TfD4WYzpe6jE4qGK/sO+0uRcu/5tRPNsl4zDRJOULqBjSeGtfzVBoU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/damon/core: stale charge_target_from ABA reuse when scheme
  is inactive
--

commit 853b3e89da132f2ce03750bcf6dfc1f62a70d261
Author: SJ Park <sj@kernel.org>

mm/damon/core: remove unreachable damos charge_{target,addr}_from

This commit adds damos_fix_stale_charge_pointers() to clear
quota->charge_target_from and quota->charge_addr_from when the referenced
target has been removed or no longer has any regions.

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 9206737d05ae7..01f93146b92fe 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -860,6 +860,26 @@ static void damos_set_effective_quota(struct damos_q=
uota *quota)
>  	quota->esz =3D esz;
>  }
> =20
> +static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
> +		struct damos *s)
> +{
> +	struct damos_quota *quota;
> +	struct damon_target *t;
> +
> +	quota =3D &s->quota;
> +	if (!quota->charge_target_from)
> +		return;
> +	damon_for_each_target(t, c) {
> +		if (t =3D=3D quota->charge_target_from) {
> +			if (damon_nr_regions(t) > 0)
> +				return;
> +			break;
> +		}
> +	}
> +	quota->charge_target_from =3D NULL;
> +	quota->charge_addr_from =3D 0;
> +}
> +
>  static void kdamond_apply_schemes(struct damon_ctx *c)
>  {
>  	struct damon_target *t;
> @@ -890,6 +910,8 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
>  			damos_set_effective_quota(quota);
>  		}
> =20
> +		damos_fix_stale_charge_pointers(c, s);
> +
>  		if (!c->ops.get_scheme_score)
>  			continue;
> =20

[Severity: Medium]
Can quota->charge_target_from match a newly allocated target due to slab
address reuse if the old target was freed while the scheme was inactive?

kdamond_apply_schemes() skips inactive schemes at the !s->wmarks.activated
check before reaching damos_fix_stale_charge_pointers(), and
damon_sysfs_set_targets() frees removed targets via damon_destroy_target()
without clearing charge_target_from.  If an online commit removes the
target stored in charge_target_from while the scheme is deactivated by
watermarks and a later commit allocates a new target at the same address,
damos_fix_stale_charge_pointers() will see t =3D=3D quota->charge_target_fr=
om
with regions present and leave the stale charge_target_from and
charge_addr_from in place.  When the scheme reactivates,
damon_do_apply_schemes() will skip targets before the new target and
regions up to the old charge_addr_from.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107224800.3402=
50-1-sj@kernel.org?part=3D2

