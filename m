Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 781B7606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KdXtynUd
Received: by kanga.kvack.org (Postfix)
	id 18E2A6B05B1; Sun,  8 Nov 2026 15:03:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F096B05B2; Sun,  8 Nov 2026 15:03:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09DF86B05B3; Sun,  8 Nov 2026 15:03:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4C8C6B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:03:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5260B1C1F32
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:03:31 +0000 (UTC)
X-FDA: 85413026622.18.0988323
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 983A2180006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:03:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KdXtynUd;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794168209;
	b=JeUEKt3QEFZ8SDQsSjf2UxNQLi/VUS5muI0m3i1FDrs0aSKllZHNtVqRxXkWPRKFfHyq/n
	GaBGdoTzovOAbM5YFmMjc0XL+phCW1GCFmCVD1qnL1JcDaydH++WIGeECKmO7KmjqL1yT/
	3qXhal9ot3ZgyndGwCsfCngMnMWm238=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KdXtynUd;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794168209;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZ6gdZXmi+wGnZ9NA1jOeRLxjxmr/2rmV5TZgPwzxj4=;
	b=DQtE7uCRtQfCNKPHA3Wm6kFrmsRcdjmrdsRbaL+a3Ow7Oy0CxCdRz/wdoBox7mDDkrnBS0
	Uf86UaF8nc1Ank0YQrL98ZVa+zU+kL5lSjGwvhx3pSfXhSIAyihpd2eJd1AkZYPV2I+bKn
	Q87axGagcJrsBbLGMS+g1MW31Fm7eSk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6C6D40A05;
	Sun,  8 Nov 2026 20:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EB41F0089F;
	Sun,  8 Nov 2026 20:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794168208;
	bh=DZ6gdZXmi+wGnZ9NA1jOeRLxjxmr/2rmV5TZgPwzxj4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KdXtynUdUUSz2QX4FLHkq1IJ5Bbm5ohUKS//EZI/ce81aoJ2geW29TVr8cD0feOmb
	 k8opN37d91LRaoS8Ypam63Xq4B/p33j9SeXA2RnBbFD39DL8bSKrtE3ow/vHk34A/l
	 P2wFdHAab1hueE0bEhNjSKKyP5jGjFVBezFWQuh4mE0oMIDDkwzvhBYIlBsXjS8Sso
	 HSt/zfQWYu7rXT6w8dq8NzZz9KXSAf8OIzXCKil4kRtVScCrEIi9pb+IzMP6nsIp6U
	 v+2Q5B3smCJtYLoCOMrzyg+QBgeaUCiiiy9mf4LCxCL1jhF7D8LPE8Lmrc1z9Ph3XJ
	 eqB6VeUiWlLIg==
Message-ID: <sashiko-outbox-204001@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.12.y 3/5] mm/damon/core: handle uninitialized
 damos_quota_goal->last_psi_total
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Brendan Higgins" <brendan.higgins@linux.dev>, "David
 Gow" <davidgow@davidgow.net>, "Quanmin Yan" <yanquanmin1@huawei.com>, damon@lists.linux.dev, linux-mm@kvack.org, "Lian
 Wang" <lianux.mm@gmail.com>, "Kunwu Chan" <kunwu.chan@gmail.com>
In-Reply-To: <20261108195145.115792-4-sj@kernel.org>
References: <20261108195145.115792-1-sj@kernel.org>
 <20261108195145.115792-4-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 20:03:27 +0000
X-Stat-Signature: toisc4e8ny37jy3wq3s4rqhotodu3ux1
X-Rspamd-Queue-Id: 983A2180006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794168209-466614
X-HE-Meta: U2FsdGVkX1+CIqEg36Utm7Z7qWcujFSHuFBxuGRhzRSNij/spDMZktw/BEk2LpiWFjL/xxmk1SM0Huj6Rgh8yLMHEUvxS5ngstbkULHws2OPio03yESK93H5SS2Fs1nX5rkpl3dQTLA27fatt7ZdIrb8//Il67pm0K13NYrgtC9EB/qDQHJ6qbw/22ScWKToNwrxF7IU60ttNpQ2ncEpul5lTmMcSMX8GjbzHu3GfiraRzqEqgln3sa+/lAsxikzh8WQ4lHi+VGBCTq9YxQhTDydtuoJIo90ScoIWH1ByZ8VcsBbqQf5G6HieXJozKrodOzm+CE7tLnWHkCduOY6rKBVIQr0L+okXXqvG0JllWBhfNB0FAVYHrKYMt7PPdWvHEDA6mLpLkNVwzbVlclpDN2wV56Z31rcny3I2YDkHbm185ELUuE/HNEqN7TlI1WLGRjaIimyzjngeHyZMiDqL8/R43FPKZzY0j94FAz2ILSbb4j+Uv+S13Tbq7YHch1xdF8K7Yf+Wpdmuxlz8HhsHn+RC3Fce1t8RBaVqn5dFLLzmh2S5U7vDVIshyOMVFkEm84c0KOiqiS6GG/1kphJBrWO2eyR+bz6RFQzDS3hdyHPXt3f9z5f+Y4FbjEA6A2RPA4UegX0pLAOVvZJ0B+/a7HaZ/7QQVZbeMyQHIk33vfodkj8DPaSiDj/9z5XKgt4Mm4tEXIYNdGGQRLQWZ+WhA3jruD25zHL3RFfJ/hzd7mUZdL5LVq0FD1tgV2qLQzE34JZILCzqPkwkxGa1GfE8GftpxsYaa9J6MHyszpjGV3oxRdyNiyhCX15VV1hcJMDMwTMPxSwxyfoty7t+Je71roP1Zh0ZUAGkufZQz6+p6F7uzJCmeH1NO0JjAaElXuHUvVc0Q8jRHP0F16acc1HcSDM5lZvEYuI5JEzKGuq8+W9owyl83a0VDCJClamiLZRhl9S7MQGFDaIRWl1ZCj
 KYf9VrX0
 0Q0JTPTcQEtrPe6izigB9+sVFBeOflg/fABLpzdeJjmF1WRd39OxJsLPLVP88UhEeBlJsPm11KvnJgFBIYWEyMraVNa6FF36U0chZOhgy2FCvMdw8Bbaxe75cMoMqZVHjSIDb5DnCdiygKUpPfl1tHRhZKnvLLvOCqlhRD/YHrSQeKh3ZrnT1x8Oozv2tYchYrgUxo8IB4kyqFlusis/ucQq6eU+uDf/n8D4S9sf0TH2ko7ouyBr+m5GN1DWHsm0Pp1G2O4mC+J74ZDa9j7QWK1Lzfk/LnD7cd9TZDK7Ug7vGCKKB2zjvpZXXToB6C84TTfB8SUKmPEkatZxyk+4qf62sjtCbMCL9Z9xZVbc1g9X7Tsqxpdlam5sRf+c+2KrDbQrHO49RJB8bEBDew8b5PrrGB+NYanEqiiGQtVTwXfpzLfJZBUEJsqh/h22BEZSlFBdtoWLOoURRCRwMVhky9I1/ZGRjUG93DdgcQKGvFCmzOOBa5LISz+elJFusCNjuUveGW8CmdTbKGlqPHEsJLxXbxVhjLX9sEf1d99OZJqcvFTVy8zzEaZ5GID0aDo4ndiJnCTrdGXm/Jl1Y66b/5DO3B/t7IjfAL/K365GMerhewWF0ZgZbo5xN9/0yYq1OJLoE+qyU2FW6hITz3s1I3AwXVEFkdnNZx985FCbnNsdrBiYYhHrnSUcX6R+h92eCN6X9gvpdyRgUszc=
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
- [Medium] mm/damon: integer overflow in damos_quota_score() on first
  PSI round
--

commit 6456f90a0b14251a6d548d6849beb9dd850f55e6
Author: SJ Park <sj@kernel.org>

mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total

This commit initializes damos_quota_goal->last_psi_total to U64_MAX upon
creation and commit, and sets goal->current_value to goal->target_value on
the first PSI tuning round so the effective quota remains unchanged until
a baseline PSI reading is recorded.

Link: https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org
Link: https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org [1]

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 6ef77741b783b..52f01a6508b66 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -1608,7 +1611,12 @@ static void damos_set_quota_goal_current_value(str=
uct damos_quota_goal *goal)
>  		break;
>  	case DAMOS_QUOTA_SOME_MEM_PSI_US:
>  		now_psi_total =3D damos_get_some_mem_psi_total();
> -		goal->current_value =3D now_psi_total - goal->last_psi_total;
> +		/* uninitialized last_psi_total; make no effect this round */
> +		if (goal->last_psi_total =3D=3D U64_MAX)
> +			goal->current_value =3D goal->target_value;
> +		else
> +			goal->current_value =3D now_psi_total -
> +				goal->last_psi_total;
>  		goal->last_psi_total =3D now_psi_total;
>  		break;
>  	default:

[Severity: Medium]
Can setting goal->current_value to goal->target_value overflow in
damos_quota_score() when goal->target_value exceeds ULONG_MAX / 10000?

Unlike mainline where damos_quota_score() uses mult_frac(), this tree
computes the score with unsigned long multiplication:

mm/damon/core.c:damos_quota_score() {
	damos_for_each_quota_goal(goal, quota) {
		damos_set_quota_goal_current_value(goal);
		highest_score =3D max(highest_score,
				goal->current_value * 10000 /
				goal->target_value);
	}
}

When goal->target_value > ULONG_MAX / 10000 (for example, above 429,496 us
on 32-bit architectures), goal->current_value * 10000 wraps around and
produces a score below 10000, causing damon_feed_loop_next_input() to
increase the effective quota on the first round instead of keeping it
unchanged.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108195145.1157=
92-1-sj@kernel.org?part=3D3

