Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F508606A31B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 18:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=khWEO9rh
Received: by kanga.kvack.org (Postfix)
	id 584DD6B05B2; Sun, 25 Oct 2026 14:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536166B05B3; Sun, 25 Oct 2026 14:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C626B05B4; Sun, 25 Oct 2026 14:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE9D6B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 14:33:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70B74805E7
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:33:56 +0000 (UTC)
X-FDA: 85361997672.03.3E7E448
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE808C0006
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:33:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=khWEO9rh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792953234;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WcI/5fRObBib8Q1yiM2jO7f739qoW3E8+UEK6/36WCo=;
	b=5ZMoyJ6+kIhdbb85F7ojC7eaiLPOxEbhgqipfsXeGul97XvWy/DFnXYVovkHQIUSVL+LSx
	nxoN+Bo8i8X7xULltO0HI+W/f7wA/+jP//jTB/2oS23VGm5kUQ8/w+ZmZiheV4sRxSGV4m
	qpadWhlO1X1StVCiI3+uOhH8eYLxViM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=khWEO9rh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792953234;
	b=nIX9hYAMiMxpxREG/fyKZwEQNRCpzVmnHBi6kJ/N42/if/SwIYIOk/ygDnQgII7wfVe/DC
	ZOchMBJTWpVIZckAioMe8nomyh9aUFCvHM/djbWE+yUfTLkzgKoc9GCMflCoC/GU73tUmc
	xaqr8Q+00+SUZe4LevsmH1Br3Oi/RSo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5724B600CB;
	Sun, 25 Oct 2026 18:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D621F01829;
	Sun, 25 Oct 2026 18:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792953234;
	bh=WcI/5fRObBib8Q1yiM2jO7f739qoW3E8+UEK6/36WCo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=khWEO9rhc82rNn9rFz6KXsSsfeALw4SFXKpGEcQmezX4LjdJ2HgEvwxgFIPlXYbcD
	 sz8Wn0OdbrwA3hqkoFHiC4tudHp2f+yaObsFriS2uM4rIONZVk+3I/VKovg4hv5Uoh
	 Y2UJzDpcO7N2viPoqtLnVhfK/mhMIk1E3a98ENtx24EXnGB4Hxkfptqymi6Rf/jOps
	 XjzV8DdI7kkLJRstMEa/8omn0aMjVw+Q7R4qJ/9RCReNfPsKslSBrVsh00LfwO1Bvo
	 6uE53mgYTBEPYpDLmekiQz6ZvHUZKBi127nFeGuvnWDbyatVwxQPFZHxSIZjfRRvYe
	 gpkgsl5VCts+Q==
Message-ID: <sashiko-outbox-184343@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6.12.y] mm/damon/core: error
 damos_commit_quota_goal() for zero target_value
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261025182326.178326-1-sj@kernel.org>
References: <20261025182326.178326-1-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 18:33:53 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE808C0006
X-Stat-Signature: 5a9b6rqot64orhb6bsi9naat5ykhmims
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792953234-176341
X-HE-Meta: U2FsdGVkX18WSPBQFbamYgZ2GAe5iPs/CwoFVLeKcWJCsXOsNR2lWwjjQmYv3vqnjvUdwIC0CBGxWYi8zJLKUa6GZN+Vchiosl/RXVFKd2mJw8mIHewj5Fehbw69r7TsO9JuAOpZdgGxseu8DX19/v6U78ZeXc9IHN4ep9tOlJAq4QpoNeO2za/qrcWd2O0RdNNVgy3vwy2J2++YQPNBAc2P7qMu/Dq4S72Kx/T5VjWL+4KXsffBsKc5ynOs3uX4h7mUJNedNKR+/8VXDJuk2odT9QOrbyU1h02ZRmsGeL/7QJCJ+6GZICgDqFedE89fDjkhmZ9KMi6oWsNUu2Ht07v/WYz7MAQp20xTpW2H3K5Q085y9/DE2X07gBYOJ8GwLOIZGqSKHQqWaGz07RnEIK1NnCgPpLzC3et0pFM5KEvyJTqgswUYbiyWX5CHrelqbJAIXUUGofIz8NwppndAsEWitjcyxpCG6XARIoTRsIsK19harA64v+fOwO7HjfT+2ciIt0+mv9XtbovQ1FxaovpvHNp0RAWVGR3+RRs3d6EV/f2BeYsUicLfp3fl/Sk08PzfWb3f3s0X4O7LsQqjrx5hHcPWrX7RhJj1VHF49NToqGt7NsK+2ISzZxEnVWu5fz6h3Ay2hgcuxwm723YLT8jBPJ8Q77JvyNUGeRsnC8CXpNG6rULhlPVBMOA2OIfOi1n9SKB0woj3lLOo0vsCCjf5MKr///4VCrKfJ/fBE0EkKxIa8hLDK4SQM3XaXqZbCQePJNk0SdiYV5LN/l8ti5pkn0Q/JTaDvXPD2XIuxJY4teOjKyw8kyotEX10XhrUCHTCRYr456+vppPNlIulw3ilU+FyPjNftKjdcIXr7iiuxf7YFdzkv7MNCNfwG65lfHrZLwZMRwZ4H2mOUW16BNz/kC5c/Jt2XYTnLY70kR5eBL8wqMiVL8Ec1F1TK+y1Hqgk3cCOhFpmMn6DClA
 8LL6ltkg
 irFwnurOF8iXCsx+pjJdT2FbJzYkQeFpVrDjYguJHUPb3aqEG9CP3IZtFBQ+6spR0Ry/dLy6WIeyfj0NOOm7i05kUY6nhcHnuFnk0HmuTmiWoON6uYsWXbK5uy+NaZ/O7HxIzibuOmqOR741MIZin9J+s/v8p5z+YN/Wn820ORD1b8fSv5u7jLWBMkjmEqMmVI5aHDSAriKonVvjXVKAZaDng9VRxVSbki6QcCPy3XwRllNQXEC7aK84yIbLYsA/g96JtfsOyWTqOQl/TKfXUKBTEEaI1P/YDIPHe8tjHsbfyPnNVsJHV5S43rFrgwiK5TO6NATjG6WxStvtZgQEv9HMlJgLQNr6B1SYHX/txI327w4WPgDAbxyR5Bg8wnP0Ih6LT4Dj4QnfmKKB2CJvyG0Tk8pWZQMKM5hpPiZ8LrFNyH6UGlHkMPLy13DsaoR2ZeMieTcmUDVzSHaqYMApc91HfKiGEOz+btA/p4z0doDBuJX6qOpeCTsuLcu3AjoEV/UinPIetI/ZOXCpqHvGw+dM56WZbl3avzR2tguUoqIIvDQEAZ//SlDaCI/3AqKohw1AO2ll7KPYxT53ayafawuucoDwEe6Q0DihImB8R8cWoIiozPGUaD5WR70V8XwmpMhj9
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
- [Medium] mm/damon/sysfs: ctx memory leak in damon_sysfs_turn_damon_on()
- [Low] mm/damon/sysfs: unknown member targe_value in damon_sysfs_valid_sta=
rt_ctx()
--

commit 1635d9f393d64d22688141e9540fde6f98f5d6bb
Author: SJ Park <sj@kernel.org>

mm/damon/core: error damos_commit_quota_goal() for zero target_value

This patch rejects zero target_value in DAMOS quota goals during parameter
commit in damos_commit_quota_goal() and damos_commit_quota_goals() to avoid
division-by-zero errors. For this stable backport, it also adds a validation
helper before damon_start() in damon_sysfs_turn_damon_on().

Link: https://lore.kernel.org/20260903010722.94244-1-sj@kernel.org
Link: https://lore.kernel.org/20260903010722.94244-2-sj@kernel.org
Link: https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org [1]

> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 5aa23c6545cb8..7895b11555d06 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1497,6 +1497,20 @@ static struct damon_ctx *damon_sysfs_build_ctx(
>  	return ctx;
>  }
> =20
> +static bool damon_sysfs_valid_start_ctx(struct damon_ctx *ctx)
> +{
> +	struct damos *s;
> +	struct damos_quota_goal *g;
> +
> +	damon_for_each_scheme(s, ctx) {
> +		damos_for_each_quota_goal(g, &s->quota) {
> +			if (!g->targe_value)
> +				return false;
> +		}
> +	}
> +	return true;
> +}

[Severity: Low]
Will mm/damon/sysfs.c fail to build in damon_sysfs_valid_start_ctx() due to
referencing g->targe_value instead of g->target_value?

In include/linux/damon.h, struct damos_quota_goal defines this field as:

struct damos_quota_goal {
	enum damos_quota_goal_metric metric;
	unsigned long target_value;
	unsigned long current_value;

> +
>  static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
>  {
>  	struct damon_ctx *ctx;
> @@ -1517,6 +1531,8 @@ static int damon_sysfs_turn_damon_on(struct damon_s=
ysfs_kdamond *kdamond)
>  	ctx =3D damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
>  	if (IS_ERR(ctx))
>  		return PTR_ERR(ctx);
> +	if (!damon_sysfs_valid_start_ctx(ctx))
> +		return -EINVAL;

[Severity: Medium]
Does damon_sysfs_turn_damon_on() leak ctx and its associated allocations wh=
en
damon_sysfs_valid_start_ctx(ctx) returns false?

When userspace writes "on" to the kdamond state sysfs file with a scheme
quota goal whose target_value is zero, damon_sysfs_build_ctx() allocates ctx
along with its targets, regions, schemes, quota goals, filters, and any
target struct pid references. Returning -EINVAL directly here skips
damon_destroy_ctx(ctx) (and target pid cleanup via
damon_sysfs_destroy_targets(ctx)), whereas the damon_start() error path rig=
ht
below destroys ctx before returning:

	err =3D damon_start(&ctx, 1, false);
	if (err) {
		damon_destroy_ctx(ctx);
		return err;
	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025182326.1783=
26-1-sj@kernel.org?part=3D1

