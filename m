Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E71BDFD45FE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572116B0088; Wed, 25 Feb 2026 19:54:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D746B0089; Wed, 25 Feb 2026 19:54:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473356B008A; Wed, 25 Feb 2026 19:54:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35DDD6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:54:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 045701602CF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:54:39 +0000 (UTC)
X-FDA: 84484787520.17.9C45BBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6782C1C0008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:54:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GreAoEyx;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772067278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCGgfLyIzohTL0EhS4g472GMW4/UMF10Ji0K3AJdvNQ=;
	b=LLspSzBxjWS6MHMJJqKHk5UBgvqgddD7gwVrOCA3FoV1ecIssfLhVwEx7YrGOCfpdavfPh
	juAolVhGDlsE5VjyZhecujKfipx0KRoR81q8wzzjYTNUYlA0K1OJvYdpqrxiynurLN+mtg
	4e8sdsEjOBdONM0cST//2b6b3wrAEe0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GreAoEyx;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772067278; a=rsa-sha256;
	cv=none;
	b=aCAhJ3XL1qhN36TkaTg1SnxYgSFj18G689lvKFCnX1Lr3j9dyStadLSYcglmpFV1htcXmA
	F+WJUSwxqDfUBvII6gKqoqaoZnxNMVgMXTEQt0ge8T6+UPlW14ky7fVek/xjTT/BqHm0TJ
	KyyvI6KCD0CGYaZz2J3ooKm6qfJyrGY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CDA9D600AD;
	Thu, 26 Feb 2026 00:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5F5C116D0;
	Thu, 26 Feb 2026 00:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772067277;
	bh=N92T+3E8LhZQO5VlmuG98fMnfwS5aJm8dE5mN5TOOPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GreAoEyxNF1eCY+CIwrbtaTJSy8AV5QsujAvVhjp7m7ngK8yWSr9tyhAOIP7jbLqg
	 FHKjWE3mTCyROdAbSdDehqcSGc7iDgX0sE0iAWIDHeNWn0EM3tEac8t1nQxuwpbwUH
	 SNy8bLmX5q5ZnTKUDMBIckIMitO7xkRNF6GM4z9Ze66Wa/Wc87gnkaG0EYHC0kQ69P
	 5ar1/ljiF1kT6uhBEQ3e8yJXk+REgpcy2VP1wue02mKeKsqmXmeV07HAHNea5xlADN
	 7JS6b05uPvt1YReO3pRWF7S7gWeGu111D4xLAT/V2O5K0UeJ3uzPJJbH7u9SxwZZ7l
	 sYweuYj21WS1g==
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
Subject: Re: [RFC PATCH v3 2/4] mm/damon: fix esz=0 quota bypass allowing unlimited migration
Date: Wed, 25 Feb 2026 16:54:34 -0800
Message-ID: <20260226005435.7720-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y15BbvgKttRRxrNrr38y3Pt4A+MP8tfQZZ7LVyoUS+_0fQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6782C1C0008
X-Stat-Signature: c5isk8zjo7oafe7aej6jb1cd3su9ggnw
X-HE-Tag: 1772067278-828780
X-HE-Meta: U2FsdGVkX1/js6xrWd9GPnXo4uIJ9momh+k7masP830Ssy/9+iJlwp/aeWtbcUJgOqkxbg9o9HXPLDrP4COUVV08Vv5RiMhH89xLlZEzAmMXOQuHBrlmTn5ee9fuPkKxtjd2nAcrA/9lN+x9tAlsOKa676Vh9LxP+pF/mKyZfEu02pAvKz9lY/YxfP6bSk5VbCaY7hS1oZJXHJpBVin2CRuEyVXuUkG0O5r0xYQ0du7MSoOA5q+YC9RXoZsxKMd7ICw1aTIYmistjqTUBJomNzEwP9F+JW0urcaHbJ6SwaYAsvUi8M8s7DyN1+oztpmxhE0xY38LdXssO9Y0mYbSmr9Y64seBaxcUbthldkQowJRSbPmK55ibFBauHCjPa8YdBn6gyMuv8ttLjnOX8mErosJHRUx3C+rhyhwTUHwViOntVzjg2xiiaqLnp+7wGQ0aaLUBanz7APdZs/6vKF9SLd+DxD4/RK1aQ2eKsMZy8s3R1u29TUr8fo9clH2Rj2JEZotX9S/q6SYcImZezuyB+ueAPBMAG96/p1EIrTPKpOGBT1nbHJaxQ7PafCj+dEZySNyTH62RTN+BSDWIeN1eNbaIKwBaO9KSRS5B6H/3jmKQ+LRqfK2WH7ahZz2xGos73o4R98gH4P2i2Ows7Ad7S57uS9cxtKPnfMp/xdWHAINqyUUARORbKPzo5ZcgvCdlnqDnm0sCwjTx63ogu9N1jsOQ/N592WvQNuNoBqfSkd5cE9BonZ5VjEvRAxZsJweBOz2WpwxHhe5sIcexIhaOwTCpED0DoH7dE3cUSpTQu9pcQ/cYjjqIjpKUsiAZC9hZ7q/g6YedZFU2AdXBJWQgDtZD2nKaO/twqrLcu4ABFt+6xFiOH1aCBfqmcgmtF20mG9wuJyH79BO2CsMunZqfQXoKJoKzUXktcnxpvOe6xe46gRfgH0m0bCUvW39GQIJvdHvJiU23cRiftzqh2o
 mmF9a53r
 fxFp7+74j+fVZ60sw0OCPt8Co1n+D/kLr//XXLfQ4laljE+91m4T91Ezd3YhUCJ48hr5TriY5A+7OOwg2A8KSxBiQfXdZGtB44W4GCmt/ZRy1IDFz76ZSFdvSDBpyFlA4BCX0hu5LwI+wkLimrGp/Xw3TBlmhOT9jnhpTD5SyouXfhaLIhUYT/HD/CQ+OLBszOAUBMfOG48BDWx6fVOvwcAf7BUzHOgy78xs1YZSYNef2YC9aDfcz4MILqinJkhnmDdNaQTskTmQ2B03/EwCHfIFfoChUHP9DYENq6G7kRrdwF8SwMdOT+WI76xVA0+dj3IgHyHPlYJF9gY/SjhCH9BtrG78Bn+op0jLqZ8Eru915ne0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 10:28:30 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Mon, Feb 23, 2026 at 5:54 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Mon, 23 Feb 2026 12:32:30 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> > > When the TEMPORAL goal tuner sets esz_bp=0 to signal that a goal has
> > > been achieved, the quota check was not actually stopping migration.
> > >
> > > The condition:
> > >     if (quota->esz && quota->charged_sz >= quota->esz)
> > >
> > > When esz=0, this evaluates to (false && ...) = false, so the continue
> > > is never executed and migration proceeds without limit.
> >
> > Nice finding, thank you for sharing this!
> 
> Thanks!
> 
> >
> > >
> > > Change the logic to:
> > >     if (!quota->esz || quota->charged_sz >= quota->esz)
> > >
> > > Now when esz=0, (!0 = true) causes the continue to execute, properly
> > > stopping migration when the goal is achieved.
> >
> > But this code is written in the way because the current code assumes zero 'esz'
> > means it is not being used and therefore be ignored.  This change should be ok
> > for your use case, but could introduce an unexpected behavioral change for
> > other users.
> >
> > One easy workaround would be setting esz_bp with a value smaller than 40960000
> > instead of 0.  That is, esz_bp is the bytes in bp, so setting it smaller than
> > 40960000 will result in making it effectively zero, e.g., like below.
> >
> > '''
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2623,7 +2623,7 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
> >         unsigned long score = damos_quota_score(quota);
> >
> >         if (score >= 10000)
> > -               quota->esz_bp = 0;
> > +               quota->esz_bp = 10000;
> >         else if (quota->sz)
> >                 quota->esz_bp = quota->sz * 10000;
> >         else
> > '''
> >
> > But maybe there is a better way to cleanly fix this.  Let me take a time to
> > think more...
> >
> 
> I understand. Please take your time. I'm happy to test whatever approach
> you come up with.

Thank you for being flexible, I will do!


Thanks,
SJ

[...]

