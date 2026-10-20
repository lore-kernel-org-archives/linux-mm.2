Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D592D60A261C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 14:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I2geFVwp
Received: by kanga.kvack.org (Postfix)
	id D6BA06B04D9; Tue, 20 Oct 2026 10:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D436B04DA; Tue, 20 Oct 2026 10:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32666B04DB; Tue, 20 Oct 2026 10:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9086B04D9
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:00:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B89A14014F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:00:49 +0000 (UTC)
X-FDA: 85343165418.26.1EE0FC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4BE24180016
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:00:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I2geFVwp;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792504847;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSlLg91psftAobeV8gdQkEiFF6hG5zNghfZl0ld8xE4=;
	b=XQ31ADtK6x5NHhezJ3VtTYMfARyms+wT7QV/TQu/1l0MJQoR0LJJM2PtgS/DC9zzwpu6XJ
	bo5b4nvz2bFugCdmfuNFbTyhT3m8RN8/dNJg2M1coguqQid/SnkfjoP3DXBC6tzEmP4xiT
	hzB1aPGXcgQ35SEDetRI1KyHPo3CahE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792504847;
	b=Ux5IjVCE8xWc7tQo6U5tz+riZA1KnvYLlM3Ww/XJsenOD3vxXph9CXiilZWm3t/OG519aK
	EHdNfULpncPk/BNXqLGHrBrW0cZFGDpJQyR0oKOoB3NLLu5UIUWCARueo8rtiz/lmvyKuk
	rmy9yETRn3PNm5cAudLeibzS1TeNIyM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I2geFVwp;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD8DC60DEC;
	Tue, 20 Oct 2026 14:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD991F000CA;
	Tue, 20 Oct 2026 14:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792504846;
	bh=BSlLg91psftAobeV8gdQkEiFF6hG5zNghfZl0ld8xE4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=I2geFVwpdSRal6bhErvcT89tNx5RPlTBPnxPEWTRgZ1PCP6+4uvuCtwpstdekNojV
	 Uz60j6IcEaWMy5hor8cADcWBlmm2HevTpR/F/CP7EdPh75z6P08NVOJXt39AI0yGdi
	 OOwWB9+n1GmRItRBa0g34ad9/F77U4B1knotKvN8atrOpU+yXC+L8mRI4VJE401sMm
	 km8oS2uDT2kaatV1fMmhgkYphsvkfViyySdMg1bYmPu86j4kWtoMc3h4JjTuAF/47q
	 rqeEXkLLEwgubHrTX2XaGNxhwE1KWbkwYQeojkSy4M72Rzb9PUE7iuPEUmtM5LQQcO
	 7RnURKDYcyqhw==
Message-ID: <sashiko-outbox-179075@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] mm/damon/reclaim: allow disabling watermarks to
 force reclaim of cold pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>, sj@kernel.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261020133233.3920818-1-ruanjinjie@huawei.com>
References: <20261020133233.3920818-1-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 14:00:45 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4BE24180016
X-Stat-Signature: r8ck5ps9ufenrfoa5e4c954amtd7c7c7
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792504847-895046
X-HE-Meta: U2FsdGVkX18C68fQQ3O288Zx4gLIJZFvQSH6t/t3Cv8nU6/NpzxmCtoJEPJeSOdjyf5Cp+GKJ8nS0sjwK5VPbt3+biUvoTpBWsAd+nGmkkdIJMtqigGxEB4HHUChkOf6RKdEqQGnw2oEu2HRcPC+REGHPww+7YRNKko7bAVRVv8/itt+a+YvjnXkZaaMAymTEqhwSpBi+0q8Z32jyd6+WrFykBVS/ptuyM++vNpsm7KysrWD/8iTTSf1dlKQMvtmL+VbPmN0LstNwaoyA4nX4T3frO4Rdde+zg8tRZSmS92mMNX3D+d2Rp6qCZsZmt2HDNIIYqsuRwBysO8CFn0FOijhFMFIeMnpJZvwUeC1lkkyWa6JrR4jCWNPqq5GsTjl58csTButhv0IUdnmSBhXVa0d8Bpst0phXpH/oP1RDjKuidyzDutFfYtn2CL9Z4NyDWMipzaKwk7TS7mT/S+IKWgoGG3hvPgUtlH2z6YSchQW+8bwSePaZlwfRht7ZBB228dkqfhv3oSwSGhGgHabbxfj0PyOZzBhlkcrRn07K33FyjNea0ydm+f/sdUPMCWHl3ffLLr2yabRFfGDJimDfN9tOxMxQxz+Fx4FkxgzOE6fJo0hBeP0GqnAwMvSkbhcFVE6KVN0xmtEKtnxK73TYxalExDplulklQv6VjL80RtLuvYYClU/wP6ytOnfdDEN4fHLj5aPilkt4MX8hnws3708RT5lEGJtDCEVqMvWahCwwrj01BfJmsTS4ksiPMYl9e21eUUzxBrq2xBf2rGABlkrcqpnxAXcDSRDmRdbtfmD3Xw/lGyUJmIWofKlLq80rV26oL7cTBcZpb111Hg1oZ72uTj5IomUIOcWqBY/WHkqOnDwpvqvhLs7ZOYzN3l6BGmjMRkJR+pNg9uZZhHYX5tQo11NNRgM7nsguRcfX4SplSbKjkOLQKLsFjPsKKhPIRvSRmc+XT4CvxyVEUN
 mgiyL1+4
 X6AY+MpdZ+ufzG0oWHbalYdmSHLHsfjSAws9vb4LJvpmIXnFleSKPCIHs09ICuOWA23ScLFTjuDt5UiyHc7zt0czzrOBhEX2D+PWzzbp+LDrzLkNBdaT4XgbMYaKX5Fcbw8zWwsdRYnPNtOKnjoFUpWLRni/LjR+DYzVooHYPu2BmamKGfqHHqmJEjJ1Midw/SQFwMcvmL6IcdbHky1Y3fRPsF8SBC5zMPaJPVG8/OlXuCitDv5dkuym5IVIYqM8qm3o2BNdd5XET0hhRbIMjEjJ+kroim2Z2Fk2UJnS+QDRlZCxpDZ2j4tBIlL8Bsxcic/Zdaq3N9n8gDjChyL2b8atkd5wQ6OD9HEduh+ujQKacQs0iKLR6BqCxUH5p6sT82PEk4Scop8Q1d2M2yS8v+LNCAFVu0RwVXmzNCqS+CGLa1LpF9Qap/e143EN/701kKXXSHCRoC3yRtTpqcxkeBbDDpRw1ymfBo8bbwMxScnEkpqbwZzq36ujTUVdg7a8i+4H2KF5vXh37k1dlkbWZ73UwoW3leI2vG2vZl2GGoVX6OFKQbcDLdGx3rcA8pp9I7mMAfAA65L46P5zr5tTVBB2edA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] mm/damon/reclaim: missing kernel-parameters.txt entry for ignore_wm=
arks
- [Low] mm/damon/reclaim: inaccurate ignore_wmarks parameter apply document=
ation
--

commit 8e407c81e469d1e743666b3331a460c372ffea07
Author: Jinjie Ruan <ruanjinjie@huawei.com>

mm/damon/reclaim: allow disabling watermarks to force reclaim of cold pages

This commit adds the ignore_wmarks module parameter to DAMON_RECLAIM so
that the scheme can use DAMOS_WMARK_NONE and reclaim cold pages even when
free memory is plentiful.

> diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentati=
on/admin-guide/mm/damon/reclaim.rst
> index ec7e3e32b4ac6..ef57f60a91059 100644
> --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> @@ -159,6 +159,23 @@ this auto-tuning feature.
> =20
>  Disabled by default.
> =20
> +ignore_wmarks
> +-------------
> +
> +Ignore the watermarks-based scheme activation condition.
> +
> +If set to ``Y``, DAMON_RECLAIM runs its scheme regardless of the system's
> +free memory rate, so the reclaim is bounded only by ``min_age`` and the
> +quota.  This is useful when cold pages should be reclaimed even while the
> +system still has free memory, e.g. to squeeze the cold anonymous pages o=
f a
> +just-parked virtual machine out immediately.
> +
> +By default, ``N``, so the scheme is activated based on the system's free
> +memory rate, as described for the watermarks below.
> +
> +Changes take effect when the scheme is rebuilt, i.e. on the next ``enabl=
ed``
> +``0 -> 1`` transition, like the other DAMON_RECLAIM parameters.

[Severity: Low]
Is this description of when changes take effect accurate?

In mm/damon/reclaim.c, ignore_wmarks is applied in
damon_reclaim_apply_parameters() and committed via damon_commit_ctx().
Because damon_reclaim_commit_inputs_store() invokes
damon_reclaim_commit_inputs_fn() -> damon_reclaim_apply_parameters():

    static int damon_reclaim_commit_inputs_fn(void *arg)
    {
        return damon_reclaim_apply_parameters();
    }

writing Y to commit_inputs also applies ignore_wmarks changes online while
DAMON_RECLAIM is already running, without requiring an enabled 0 -> 1
transition.

Could the documentation note that changes can also be applied online via
commit_inputs?

>  wmarks_interval
>  ---------------
> =20
> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 014b0779ea6dd..effd963f3c783 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
> @@ -112,6 +112,23 @@ static struct damos_watermarks damon_reclaim_wmarks =
=3D {
>  };
>  DEFINE_DAMON_MODULES_WMARKS_PARAMS(damon_reclaim_wmarks);
> =20
> +/*
> + * Ignore the watermarks-based scheme activation condition.
> + *
> + * With the default ``N``, DAMON_RECLAIM runs its scheme only while the
> + * system's free memory rate is inside [wmarks_low, wmarks_mid].
> + * Reclaiming cold pages itself raises the free rate, so the scheme
> + * deactivates as soon as memory looks plentiful again.  For a VMM parki=
ng
> + * an idle sandbox, cold anonymous pages should be reclaimed immediately
> + * even while the host still has plenty of free memory; setting this ``Y=
``
> + * makes the scheme ignore the watermarks, so the reclaim is bounded only
> + * by min_age and the quota.
> + */
> +static bool ignore_wmarks __read_mostly;
> +module_param(ignore_wmarks, bool, 0600);
> +MODULE_PARM_DESC(ignore_wmarks,
> +	"Ignore watermarks: reclaim cold pages even while free memory is plenti=
ful (default: false)");

[Severity: Low]
Since mm/damon/reclaim.c defines MODULE_PARAM_PREFIX as "damon_reclaim.",
registering ignore_wmarks via module_param() exposes
damon_reclaim.ignore_wmarks as a kernel command-line parameter at boot.

Should this patch also document damon_reclaim.ignore_wmarks in
Documentation/admin-guide/kernel-parameters.txt?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261020133233.3920=
818-1-ruanjinjie@huawei.com?part=3D1

