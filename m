Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E44606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fk/ZoTkP
Received: by kanga.kvack.org (Postfix)
	id 5EC646B05C8; Sat,  7 Nov 2026 17:34:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C3C6B05C9; Sat,  7 Nov 2026 17:34:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491C26B05CA; Sat,  7 Nov 2026 17:34:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1ECD66B05C8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:34:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8981D1A041A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:34:57 +0000 (UTC)
X-FDA: 85409779434.18.51897AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D38CB40005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:34:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fk/ZoTkP";
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794090895;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1SQ55M2ZKFspye6i6a+mymWWbMlbcuU/lYS14dDVkcA=;
	b=Nq6m5sOuYphylfjASEF1VwQL3933G1HCgyIWZ8nldxo7pf4xemQFXYnJZUAE17thi2/N3j
	grMtyWsT62QSe+HmbnPUK4dfh8Irl74w4+AuHGqjvpzdfKFphdcOYQQSv1j/2dMWEEVSLs
	MNL4rOQEjtxvV7k8zF9SGLxbetLpas8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fk/ZoTkP";
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794090895;
	b=fTNwAb6SZmYLW5/m1O1CVK8NxsKFEE8RioDJhR+YQLspyuaQLpXilR+aNNGKqGm8cwdCL0
	iQCGfdDEeKocRuhYv5xGH6z64fF1ybnoUYrPTuFpWGrtbZoz1A0oSAIFhwU3Kp4L7nvvSp
	gJ7GAGQ68mJMT8NJUdSG0z/CIWxIU4M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13E4E429F4;
	Sat,  7 Nov 2026 22:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B568C1F0089F;
	Sat,  7 Nov 2026 22:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794090895;
	bh=1SQ55M2ZKFspye6i6a+mymWWbMlbcuU/lYS14dDVkcA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fk/ZoTkPNPRS7R8Gb9VFJDMml0zqWgTOUtZeHJj/hjcPAN6iRlseZFNsqZY6BZFN9
	 MaHb+Vekxwlm9uAxQlUXey/O1ubJyDSj5OTjXFU5784ipL0lDKGGgYJYoufhsxEMzH
	 re/SpBoOLuz/3rAERj4VyWzVilq0ZQmFAJL5i44MEMzBxyzoPybxHXdJqp0AsWapnM
	 ivK5gCAh1Odmg6EOzjUhvYDntI2JLgVVafhJoDFYhVwyNqZDKD/mAo8f7QbFvHQ1SS
	 Km4nXht5EjK8kd1yHsKD2gKZlaSeuYHA4PxgzCxG6deTlPhHxjeBMUpR4mPVnh9S8r
	 VI++l7WN95BIQ==
Message-ID: <sashiko-outbox-203367@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6.6.y 3/3] mm/damon/core: remove unreachable damos
 charge_{target,addr}_from
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261107222202.331476-4-sj@kernel.org>
References: <20261107222202.331476-1-sj@kernel.org>
 <20261107222202.331476-4-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 22:34:54 +0000
X-Stat-Signature: yw3wsg8iaecitm1rormu5opbw7gm19pr
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D38CB40005
X-HE-Tag: 1794090895-209771
X-HE-Meta: U2FsdGVkX18KRz1jnBKfj9ifChqFF6jQbY+TISy27lxAspHQH0vyxCq0JTb6298160kSlfLTGy+8IlfCqQMmRbvgYQb/UY3zdU1d6i/dUBJAC+bjaoKQOA/fsbKwPJlEAaTZwGntnJTMbDcOqaRPMQuQfVt981uHSG8XiebwadNAbZnAdQ9HnXVhBKr7x8ZDiKotfJ1V4GBgP8RVmVPdEmgepNaGLW2iW0A/sTORNIObPxqLpWGcrqm3ou+zIeAKeXktpdAHex8CzMFTCNPQ35JQ4DBfuNCQ6WgsjEb9WELRYvR0oR5kxEvyX++zy7Cnk5E+cCX1b3Pn9yQ0S1h43TpaSWIopMESRvPbFWYmPbCHuSpbNgaDiOrdPqCruWyyXA5aqMTq+xzf4+wUMFsweIOakDqygh025dxOH08CCgjD6a4CM5wbsTBJtCOAibnfR4vnhlO1OVfNXZbHLzNnKTkPCY/BEEwWIEyy78e+CJ0Y0d9IwYxDH6w5bkmlFLlg8GCVXc/rWVLJT22S0NjvdeoITuhlCDC1YSKjGPo7aI886n3fR3EMeH1nlM0MCGX9RHfhLDaSUhbDUmt07uuhgo4V3gN4mIhSgOuftDDQa6Z55boceD47w7BGjnytDfInmRG4X5hHuJxqAyUGq9z4bbhzF3eedwh1szlCcj5zgO5V5LzzGzZhqEPzqr2iCbX0zGsxNc25DkOJx5l6jDp1p4kM8ivNFMiYXlk8JOa9wmRXRM/02Zq6kqXLqsyD/6fZHqRQD8p63PWsbAUIjt6hJPL4LaDiSmbOvULObqS2LarxCM82FE+4IsCPTU6IR8m269Ka0t0MGF+7ADuIJyR/QoDqzUm2IbvXhcgvJ06lGTosKZ7WpCmIDCivMwy80yKedq/J10VAWEVK/cQCXpA76O+SVs0hDUPAXj7xCmslSOQZfplTps+hXTgj20awTWHcIyii/HHKugj86PTsMY7
 XuAApIek
 EnFeL0r1mQwoAebj0td8wv3ZORAbF6TxZLiNI+XHQIV22lYzcaOT7bWy2WVKfwSmJR7swqRJ+jCSKqNkNywJUC7VOQYIakLWmV1JTcHXWLRodC5NZBmj3Nuv7E62cdQgM93r5hNYDnV9Dl8+rin+JwheHvoPzHwocxElWC8+um8XDEaxZK030p7neIp90h6InnUOnL94DaGo9ous9Gt7vgb1cdmns8Ksf6L+K1axdKTi2QKeVyDy0X681OFg54cFROJeF+wHQ5C8/edA+jAvG2LzfGWppAsnLLKiSdhChkmiXSoYzvflY9jl5NXnBfbaKN+VVLiz58jSG0LfCGT10k0Kp9/vBaCPeMV5QHh3jo2CYHTOnp4KXIk8pr+X4QDntr79KixgEksq1eU2bFx98b9IbbfoCiMnC/MUaw/N2WBa4W1kXMG8Ef0k2Tc48LSIw+7kFvmGYJVm7WtKnLXaLKQkH8M9EeWEs6QgoZ8sXmMyz20If2xK9rihFP2uvcwQeH1ZgcWn99aD3+Gw6RVoDqPzWlPPkHyoiH4JzGjYp+9ovJaZWIBsA1G+eQFEyP23bn4gaIs/IuyQyztZmhRrQ6TlwftrGgOCyBbQYq1W05XD0ASj88raZ+WifGSLIH/9u3Qja
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
- [Medium] mm/damon/core: dangling pointer ABA match in
  damos_fix_stale_charge_pointers()
--

commit f7e621ee98abae5b2fb7828ae72ea3e96d1173fd
Author: SJ Park <sj@kernel.org>

mm/damon/core: remove unreachable damos charge_{target,addr}_from

This commit adds damos_fix_stale_charge_pointers() to damos_adjust_quota() =
to
reset quota->charge_target_from and quota->charge_addr_from when the target=
 is
no longer in the context or has no regions.

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 99e934a6d1ce9..61d45d40fc1d3 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1088,6 +1088,27 @@ static void damos_set_effective_quota(struct damos=
_quota *quota)
>  	quota->esz =3D esz;
>  }
> =20
> +
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

[Severity: Medium]
Can t =3D=3D quota->charge_target_from falsely match a newly allocated
damon_target if the old one was freed and its slab slot reused before
damos_adjust_quota() runs?

When an online commit removes a target in damon_sysfs_apply_inputs(),
damon_sysfs_set_targets() frees the damon_target via damon_destroy_target(),
leaving quota->charge_target_from dangling, while damon_set_attrs() advances
s->next_apply_sis past ctx->passed_sample_intervals so kdamond_apply_scheme=
s()
skips damos_adjust_quota() on that cycle.  If another target is added before
damos_adjust_quota() next runs, kmalloc() can allocate the new damon_target=
 at
the same address, causing damos_fix_stale_charge_pointers() to return early
and leave the stale charge_target_from and charge_addr_from values active in
damos_skip_charged_region().  Clearing charge_target_from and charge_addr_f=
rom
when the target is destroyed during commit would avoid keeping a dangling
pointer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107222202.3314=
76-1-sj@kernel.org?part=3D3

