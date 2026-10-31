Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67AEE606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MdG3vwND
Received: by kanga.kvack.org (Postfix)
	id 8C0A86B05B8; Sat, 31 Oct 2026 16:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871216B05BE; Sat, 31 Oct 2026 16:36:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787A86B05BF; Sat, 31 Oct 2026 16:36:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BBA16B05B8
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:36:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4D28A09FA
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:36:28 +0000 (UTC)
X-FDA: 85384079256.30.766589D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 54CEE20002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:36:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MdG3vwND;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793478987;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2ru2S13CIhq9NBkMO/MyjWR+bJSGBvY/6OTd8m0ekc=;
	b=X2/uLgNc1DYMkJr5ld2P4bvbf8Jf3ufiL3qqseK9MG0r58BlZJfoJ7a5wbBi6ZDPt3q6gy
	/j7UtrPgr+oeKPR2W1IsunUAZDrmUYY3EJ5tiDC1gTQEL+WZDCFZGCrR09xAxr0bWwbjoa
	H6/zn748BbUTyQ3DrbdYoH3bXlL2qDk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793478987;
	b=dKGEd5ahxu65N22oJ+g9FyaVIClYh3WVl0Y/1j/SB2Si4/zKe8oS1sjwk5hCFYf911HCo7
	4D5uWwclcdlCwh/WPAe2e8nHesXUf+8GgSKa4nLgmgwNMKi7RXnrH4621IHceWvndblLCZ
	aMsvmw1lInV/u29mACfhXeHE4FZ9maU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MdG3vwND;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCBA4600C8;
	Sat, 31 Oct 2026 20:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D641F000C1;
	Sat, 31 Oct 2026 20:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793478986;
	bh=Q2ru2S13CIhq9NBkMO/MyjWR+bJSGBvY/6OTd8m0ekc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MdG3vwNDiZqBbXbRaR7aLigmxsmYICLskNTiOc8ayqUhIVn2z+jB7T0SyI50RPytM
	 YkBd6Zeypm/gz3nEdxMbSgDrHJl0hEyaUp0SnEPtWvhSE6Vbeg2PCA1i5DyS08AkAd
	 gjnb5S+sWwmQNUwicq/YibUu8GCQHvGRtuP4oZShjR4mpj+Vx4PR4p/SLuN340qJUt
	 GYVGsiNB7pLYWUPqFdVNxh9DLsGM1y4wM43/a9S4qyL815Wgun7GQi1eHBk0GB8+gj
	 wR87c6vYk+BAgTrnMhqok9u+XPPRh9k0TtwtR1OoED5xOLbKyVdz9L0mC/nsrc1xGK
	 xuVedDGGGZLHw==
Message-ID: <sashiko-outbox-192118@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/6] mm/damon/core: handle invalid target in
 damos_fix_stale_charge_pointers()
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261031202614.96036-2-sj@kernel.org>
References: <20261031202614.96036-1-sj@kernel.org>
 <20261031202614.96036-2-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 20:36:25 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 54CEE20002
X-Stat-Signature: nqjdhfzsnae5nznwa7hmeis3ozghfega
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793478987-533089
X-HE-Meta: U2FsdGVkX1/lBmUxCrotGn1KnuilpQt1rkX7ziSYLha47/SPOFD77Q1VdZyTrCXWDuJbJ3X8shELcZ/Ri/INUEyeUb3eqXOlNeShQMB8/28zDXeap5ZGECg4T9JbBKj//vSpC1mdxWhWm4beLxvE2MLqF3XRlwM4ALHBi3N2mkKf1ADJ7Wbk7qShj2djbBq3nfc3+iDWWFEUiiGgkK+fCHq9ioOv1oTcOpm4ngMFyjlav1DEUYhsjyYone8iKI91f4HoTBdyBrBGd0GfvMKc92D0366yMLO5TB1JJKS3C2ADjl4RyeFsJQ7U2fN5y2PVbJ0td3wzFxLPlD/BUehsa0H2Yx+kGF8WDEOWjYDLrbCJizvrzPNX95NmRJNPINHG5iqgFrivUpDLCxdfKS+zppVJ2aNmPQJBN4DrjyFq0loEJbzW4q8BUbQmTTHQlCL2yHHAJxz4cRiZoQK0TrtUcxk+pizGDdWnDMSBLwdUu6vChR8tQ++HcnsOtUDSCEyvhQe2nwFSKnC9enGE+EnaGUCdmUR6NBgJ+ns3OlMAqguqLqnIJJsVOOOImREQWITHekFygABjsW7Qv0dbQnRkgjA9+yXJegAnVBr6Y1mSDIzgY+lBmRxp+gxyCXqUitI3nwvet8APYpOceHFOkE+MxQRJY4z8kqvZUySUlCqwIsuEh5Oyh/C4myzSAmzcOrCo0koDIhpv++yLWrfW+LZLILoamUMWF3BiVLhxsG/zcv0YgNibX16IBu1UYW0Ig2A9D3+Oa0Ot14in5idx+/2RqnWPABl50OlJ/U6+uEEnnaNGZmrE+eHSarcmBsxlBDgehdyKNMlEheCsLuI45enVEOyXk4pMy9qhyE0nEaddN4kKxUL4kbzREl5iylyj8uplkpY3VzHWqR7YKqMa2Q3en7sFDnkg7PCokXWlV5h5vryaCJG9BI7aBtin9Ne5PiyxVaKR0zbKt3uhUoBV7zq
 rngyAlDJ
 FVcSIJ1Qq7XoSDO0yh/StFms12TkEwKC3FQpa08accrffSRyVm0wF57pVah32EN6Y7vjfK1TuB+AGtoQrF0Z9GZjvzU2uAqqiRSft1jMSFyFrVsQ4OCp9Y2ljztRYvEdMbarII9gNYwQ4p9ESFTl9IfCRvy+UUOLsEOcl1SRKojU77h+ALMMpKCAOZTPu18fI8mknUywjMslgxwVmdZebyDxoDr6F1l4YXazEvrQdeBbwn0yQPDEtBDNio3UX0x8QLGCaXajuvDBC1mOc4+mU9txWvZHaPtlE8eOC29Eqe+tOg2Q1xXA49qhXlhRBPQzITmB4yU9kdSCyjWoZdPlITlY+pzyfCy8PkvyM6/3lW3MVtZtzsT2sYNDw+HtY9dpLl1xGdiRBMTisc0UDQLmEqB+K/MXJ1kF/AymsOmqbTGAbJX23C/Qfob8P0dNXObOpfmBoqQdUcn96DSCXGEQNHFEt+MH+f7pHu6j38cjf44UJJvkwMI7XHyjM8mlNh5as05tok66g+GPWi5y8gKTmyEjdLdsvRovghv1i9/LNYWlOFYGy2x3F6tQw7N77wzf8Mo5HaG5dNd4BaXnYEwjgtJWXENKFlQekKrEN1MJFANSyGCfruAxJ8cq0yXqELMAWwAPz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/damon/core: stale charge_target_from and skip regression on i=
nvalid target
--

commit 3b1cac25b68197d5c2819d4a16dbde02446b2d07
Author: SJ Park <sj@kernel.org>

mm/damon/core: handle invalid target in damos_fix_stale_charge_pointers()

This commit moves the DAMOS quota charge pointer fixup for invalid targets
from kdamond_apply_schemes() into damos_fix_stale_charge_pointers().

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 73b571b429cb3..ce75db510a9d3 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3394,7 +3394,11 @@ static void damos_fix_stale_charge_pointers(struct=
 damon_ctx *c,
>  		return;
>  	damon_for_each_target(t, c) {
>  		if (t =3D=3D quota->charge_target_from) {
> -			if (damon_nr_regions(t) > 0)
> +			bool valid_target =3D true;
> +
> +			if (c->ops.target_valid && !c->ops.target_valid(t))
> +				valid_target =3D false;
> +			if (valid_target && damon_nr_regions(t) > 0)
>  				return;
>  			break;
>  		}
> @@ -3513,15 +3517,8 @@ static noinline_for_stack void kdamond_apply_schem=
es(struct damon_ctx *c)
>  	max_region_sz =3D damon_region_sz_limit(c);
>  	mutex_lock(&c->walk_control_lock);
>  	damon_for_each_target(t, c) {
> -		if (c->ops.target_valid && c->ops.target_valid(t) =3D=3D false) {
> -			damon_for_each_scheme(s, c) {
> -				if (s->quota.charge_target_from !=3D t)
> -					continue;
> -				s->quota.charge_target_from =3D NULL;
> -				s->quota.charge_addr_from =3D 0;
> -			}
> +		if (c->ops.target_valid && c->ops.target_valid(t) =3D=3D false)
>  			continue;
> -		}

[Severity: Medium]
Can moving the invalid-target reset from kdamond_apply_schemes() into
damos_fix_stale_charge_pointers() cause stale quota->charge_target_from
pointers and alter round-robin target skipping across multiple targets?

First, in kdamond_apply_schemes(), damos_adjust_quota() (which calls
damos_fix_stale_charge_pointers()) runs for all schemes before the
damon_for_each_target() application loop.  For virtual address space
monitoring, c->ops.target_valid(t) is damon_va_target_valid(), which
checks whether the target PID still has a live task_struct.

If the target referenced by s->quota.charge_target_from is valid when
damos_fix_stale_charge_pointers() checks it, but the process exits while
damos_adjust_quota() builds the score histogram or while
damos_apply_target() applies schemes to earlier targets, the target loop
in kdamond_apply_schemes() will see c->ops.target_valid(t) =3D=3D false and
skip t without clearing s->quota.charge_target_from.  For all remaining
targets after t in c->adaptive_targets, damon_do_apply_schemes() calls
damos_skip_charged_region():

mm/damon/core.c:damos_skip_charged_region() {
	if (quota->charge_target_from) {
		if (t !=3D quota->charge_target_from)
			return true;
...
}

which will skip every subsequent target for that apply interval.

Second, damos_adjust_quota() returns early before calling
damos_fix_stale_charge_pointers() whenever damos_quota_is_set(quota) is
false:

mm/damon/core.c:damos_adjust_quota() {
	if (!damos_quota_is_set(quota))
		return;
	...
	damos_fix_stale_charge_pointers(c, s);
}

whereas damon_do_apply_schemes() calls damos_skip_charged_region()
unconditionally.  If damos_quota_is_set(quota) becomes false while
quota->charge_target_from is still set to a target t (for example, when a
quota is disabled or its goal is removed via online commit in
damos_commit_quota(), which preserves quota->charge_target_from, and
quota->esz becomes 0), and t exits before kdamond_apply_schemes() reaches
t, neither damos_adjust_quota() nor kdamond_apply_schemes() will ever
clear quota->charge_target_from, causing damos_skip_charged_region() to
skip all other targets permanently.

Finally, when monitoring multiple targets [t0, t1, t2] where the previous
quota window stopped at charge_target_from =3D t1 and t1 has since exited,
kdamond_apply_schemes() previously skipped t0 via
damos_skip_charged_region(), cleared charge_target_from upon reaching t1,
and resumed applying the scheme at t2.  With charge_target_from cleared
upfront in damos_fix_stale_charge_pointers() before the target loop
starts, won't kdamond_apply_schemes() restart charging from t0 instead of
advancing to t2?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261031202614.9603=
6-1-sj@kernel.org?part=3D1

