Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9D3FD45FE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09EBF6B0088; Wed, 25 Feb 2026 19:53:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0601B6B0089; Wed, 25 Feb 2026 19:53:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8FC6B008A; Wed, 25 Feb 2026 19:53:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF90F6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:53:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3A3513AA0F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:53:54 +0000 (UTC)
X-FDA: 84484785588.29.CC2A4F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id F1A194000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:53:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xqlkl38o;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772067233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MP3At+V5QSmekCI1bwLN/NiPOKrXJZ5DwcbD+tHfk5w=;
	b=aBcpFU839YSZNpwc5xrotbkyYSIlXALsQ8v7rl9ePpxHSIVQXzU7QVnfqDHhbGUw+xG4Vq
	7Hy9QYoL+qCdSLlGjLbgLJN9cvxMTJBgroZooTljSK1RJZWP7H8148JCOMe9SCykV/C+pI
	FotBL26cUzZ7RT8cnUxZq9r9x+qI1Fs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xqlkl38o;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772067233; a=rsa-sha256;
	cv=none;
	b=rHEdTCMy/uDrEjNhLK1slCAztPzF0aQ76pep5VhZYJgdAY0FginCkxKipYF8sjZjVO1EL5
	d6pMJrzzLgVuW6F8AvUQ910Lj7cxOdfb4v7MlkyYnTd+FYx+KDf9iyEWIxRTX9MkQ+vkKP
	RMWENP9CKWFhseAnW3yCUGJh/3R4IOk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EBA9243302;
	Thu, 26 Feb 2026 00:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64945C116D0;
	Thu, 26 Feb 2026 00:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772067231;
	bh=H+4ZFB56eGq4gNOwEmh7VtVx1y/BR3AOfSM4+GziBoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xqlkl38otYDSZdSJptQyN0H83BcVNsYv/0+EPC7EBKPWvPIMIWovn+bgfZftbUmjp
	 S2AWI/ciM1Ayfn+pk72wGKwm1WECAEsguLw3YxEpCFuspjPTgN6vqwXnvRsCezrKBf
	 TJHE7SWpexdjA6Ry8U6dWZe0ZTYEJTNCJm+1intc7XOyS5i3KP6MhlFwdFp7V3iazl
	 7chYT+RIJDWTG/aEvv44utQuEpCgBO+AXKPhvRtIUAhw5oUnmsZH2v2UPFFwqVJmMs
	 d/H/ccfoNMnBg+ZuoGLX3o5hpGQ1InrLkgGPKpt+2MHo9Cm6YJgt63sIBbbu3cJ1Vd
	 Br4VJZ9P2yTSw==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v3 1/4] mm/damon/sysfs: set goal_tuner after scheme creation
Date: Wed, 25 Feb 2026 16:53:48 -0800
Message-ID: <20260226005350.7612-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y15MQecahb-FfeQEJK2uwFdC7VxUH7GHCfSvy3uQ_jNC_A@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ogq6c14a9d7waik8ic7gusgwh1yfk4pd
X-Rspam-User: 
X-Rspamd-Queue-Id: F1A194000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1772067232-946844
X-HE-Meta: U2FsdGVkX1/2l59ylE8NTDW598Xn4uvJIIu0yj11PUAeHaGHxezTz8uHpIS36ylEaFlr4LnvW0hzJusFAXZSR0WdkmEy/uiooJzStFC51FT3hrRYLKqBnWRaiyFFs6Cm2KODG6PKSIUmBr2ohJ90jwa2rLeG8PzptZeDDs2neZv9XAcSYYQHIARr/NI9IEXFR1HcoNyqOgWWUTV9OKBhK3DL124D+MinrAg8km2uAD47D4WyA/3YmD/fv3rnwvE0SYYUTzZyPwZUJkrn5GOZW+pThNym/uM0G2OGdfCtgm+8YJ7kgpCTbvsMnMYJZrhz1QLyD8Nsf/tcVvfnII6U3F6JoROF72baj6yhgPLoRsI10en9/flhEP5yAaOcJp4oc6yFbkhtnIh9+R2vN3/LI0f6qHM0p0XRAZRZfgUiLNLy4SeKtj7oSktpxeISLLqutUgrEcO1XAGP87LT/SzEZK6aSnZGdx5aPZ236NbjmG54lc22zU+OntDHZkG4cKcWkCNc6739t3r9SsJ2mvWQRtccoGjCBVO6U1YVx+P8EciCY+hxKhax28LERCuulSXoqol9Nmff8QqcSAswH2WndJRog/rUjLvnbVlINFfn530tC5U3cfl7Aoa6NNYlEz5hFP4OV5P5LYzI7n4Lkvu6yMM2bD74eX7BQ4MP5NtYS0wXH1bJswAt+84ox9RpgZA3TPteXLLLrQ7+vsTjzbBEZt+muK142U4+vVRaYPtjI0eAAFoZnlTVQhr5V9saum8wYorFg+ewJbaBNgDkgibx7irBomc+DYe/T38mQjvplJTIk5ls5JdpsBsM9yPW8dW3n7niMgn7T59CgyfKEpMXVjng8eJiN8BTivsbaTkFHUHFzItzN1Og2C2ui60h7YTarUpW5NCb4KBS4SOHTcJbzhYbSFzedjL66WCyevEfmiQPAppkCXclLFQtgyICID3nqsmVoSP4/IIxO92e60p
 vbM/n6Gd
 O0iBc59fTD7Ld+WDkIyIb0api2Spx6rusmj1rEf2vRfJ1l97CCQQwnfj0v2yGTuJA794Gn3atazBHRWkP+wc5bdNSjCpt6MzUFhsPKwSnuQSF+SZnVH3qnyvOaI5TtQcbkbFGnEvPkJa40LIV4OG9jIYtP3aniTcJTYaKKxAzEGqAUwVXKmJrhvSp2H9on6TQiOUHEv7MyMPQxlbPmZtOulb7AeWSpdq3xbMVO84T1uWjE/LFOI9Prf8KxyHQ9QYXGyMAkxu7yMHjq8C05lVt4NNki6qOxISHBkBJ+RYFeduQA+dKWRKXE+61q7JxMxx3c4X3aoOcXPRis4oZgGK9MMUTo/G8SjGMTbSMbHHRN2WuAgfsoOD1CZyojBMDzjtalvRMU5uGfrVGLAYqE4n+CtdjP83Vb8SmQ0R3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 10:23:09 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Mon, Feb 23, 2026 at 5:40 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Mon, 23 Feb 2026 12:32:29 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> > > damon_new_scheme() always sets quota.goal_tuner to CONSIST (the default)
> > > regardless of what was passed in the quota struct. This caused the sysfs
> > > goal_tuner setting to be ignored.
> > >
> > > The comment in damon_new_scheme() says "quota.goals and .goal_tuner
> > > should be separately set by caller", but the sysfs code wasn't doing
> > > this. Add explicit assignment of goal_tuner after damon_new_scheme()
> > > returns to properly apply the user's setting.
> > >
> > > Without this fix, setting goal_tuner to "temporal" via sysfs has no
> > > effect - the scheme always uses the CONSIST (feed loop) tuner, causing
> > > overshoot when the goal is reached instead of immediate stop.
> >
> > Thank you for catching this, Ravi!  So, this is a fix for the RFC patch series
> > [1] that not yet merged, right?  I think this fix is better to be carried with
> > the series, and squashed into the broken commit to not introduce unnecessary
> > regression.
> >
> > So, if you don't mind, I will squash this into the sysfs-schemes part change on
> > my tree, with your Co-developed-by: tag.
> 
> Yes. Please go ahead and squash it into your series.
> 
> >
> > [1] https://lore.kernel.org/20260212062314.69961-1-sj@kernel.org
> > [2] https://lore.kernel.org/20260212062314.69961-4-sj@kernel.org
> >
> > >
> > > Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> >
> > Reviewed-by: SeongJae Park <sj@kernel.org>
> >
> > > ---
> > >  mm/damon/sysfs-schemes.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> > > index bbea908074bb..fe2e3b2db9e1 100644
> > > --- a/mm/damon/sysfs-schemes.c
> > > +++ b/mm/damon/sysfs-schemes.c
> > > @@ -2809,6 +2809,9 @@ static struct damos *damon_sysfs_mk_scheme(
> > >       if (!scheme)
> > >               return NULL;
> > >
> > > +     /* Set goal_tuner after damon_new_scheme() as it defaults to CONSIST */
> > > +     scheme->quota.goal_tuner = sysfs_quotas->goal_tuner;
> > > +
> > >       err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
> > >       if (err) {
> > >               damon_destroy_scheme(scheme);
> >
> > To follow the order on the comment ("quota.goals and .goal_tuner should be
> > separately set by caller"), I'd prefer setting the goal_tuner after
> > damos_sysfs_add_quota_Score() call here, if you don't mind.  Let me know if you
> > prefer keeping the current order.  If not, I will just make the change when I
> > apply this to damon/next.
> >
> 
> Agreed. Please make that change when you apply it.

Thank you, I will do!


Thanks,
SJ

[...]

