Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC8DFC9EC4
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 00:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B586B0005; Fri,  6 Mar 2026 19:21:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8976B0089; Fri,  6 Mar 2026 19:21:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5196B008A; Fri,  6 Mar 2026 19:21:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CA466B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 19:21:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28E7F160718
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 00:21:18 +0000 (UTC)
X-FDA: 84517362636.20.16C54B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 76C90A0007
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 00:21:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmwAfEbn;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772842876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEzbkLJU6DsdZAFaCsYbpkL4MxE55Eu/ctnKgkyKJWo=;
	b=U+FX6c1tOfigy/umoPxQm4blVQxyAhS6FCIvkqlg6lG32oS4zPz1Oc113wfpdYVC7Q0gHD
	+Jt4jX9iFwy4uc8ozy+RVmwg8hSqUNLF/zNl9qerV4MA54Eae9faFZrYhCT1sIPhNRQ86T
	SdrqSK6eiYXJIkoGxtAk4N2qJeVVgHE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772842876; a=rsa-sha256;
	cv=none;
	b=6Ihvze0n4xOdxAqiKY3QzCpa8j/7Y/cbrfD8gbNBl0ijZip3JArzoUZdzwUJ58ffbEkY0o
	Iik3MM0ACkBbqvMjy1lNVCJGA45sP0tYOHjjSSCugB266susk8yoG/embPAWYqnzDQPn6Q
	m2A5xUPLkXa0y0NfRcBWwrKWBiwlWTQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmwAfEbn;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52CEB40AC5;
	Sat,  7 Mar 2026 00:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9CDC4CEF7;
	Sat,  7 Mar 2026 00:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772842875;
	bh=uqHdwNgwIWQfBSHknp0uLe4ul6M3Tot+WSbz66G0te4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmwAfEbnQ1wSHbjNfaEJ42F5hwBgvwXS9sSph+A3kiUEaK/gwfCSZPcoDL5GCMrBi
	 g9yT+7VCQHdc8qDDa3N9PxpUUdxOJXLgg+rRf1boS4RH5hWsgTP07I0EFhm2h5ql0w
	 ghYrCGf5xMPPQe118CxJrclLXDvTq3hMfGreNsFJf95ekOjLYtaTlsbp5FwD5KhIJm
	 +rx7ZJRmCSrcdr1NrdNVLk8d8Yt70bW+onIGK0U1U6tNcrdzLc2KaUMKI42bDbNIom
	 dGDPDpmup4NuO3YcDgpyXzBIcVanBUng7QTL0GU7SS14S9E+DvbihG7eqg7MroKz+x
	 RfQdsChtexJ7A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 01/10] mm/damon/core: introduce damos_quota_goal_tuner
Date: Fri,  6 Mar 2026 16:20:46 -0800
Message-ID: <20260307002046.98992-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 76C90A0007
X-Stat-Signature: mn8rft4ub7zjkzy4ifybz7j33cyazweh
X-HE-Tag: 1772842876-432085
X-HE-Meta: U2FsdGVkX1/UaWUZsGoU0qBZAdUavx1oSDi1f+JwTmue23nTSlIYxNUuhJnMJ9iWDwjTQUoDJuQ/GV68o9FBGCQRbUb2x4B1KessaDNvV5/auxkt/nVHlpdNroWyMN7oIafzYDcFnV3Om29v5kXf9wO8HLnyFuVjZGykJmmGa+iNdmY8iXKpRmBWZEfGSkARR2//r0GDWAourU9drPD4L4u3eNN8WUKjqgDcMW7JOOZjO8Cif0C8HqPQ4qPgN14axisQOxA4S1x8tz7lwUCoYbMgXl16QjL5yRefR4ihdvHn6PdQt6N64ubt8uHuLfxjdBJq3Yu9bMIWcYxMjkMFLNYp03rRjkT14NsTrju/onJ+BzZTH1vDgm5ZD/gWT08dmzZfqmVZq60R3wBXqOWRB9gHuqo0pPU2obqtriVXcEUNpUMEe3hApawFl9J+li9yDynKq2EPDTykuNfPBmDYD3UTAf5PqCu4bl3fVLgaooL+NJAwNsMjnLnfCXdlkHQQrG0fK4n+MNlY5CNhBFabbS9ZAneZ7Nwuhe2hQ+0xNWao6hdsbNAXa5RO44eAUGut5hRg2cE4vEdjYuuY7t9Lu731fdY3b8JessvTbbLnwJQX9ZbFuRUjoxL6jxtaF1vqwq4yL9lu/ahp1d3msDJDCCVDaf0eq6P7hbdOzTN4hN2n+nuLyMgCAVSK432iEQmUeOK3hK+GxES5JCRHDJDdoO+mfeLub4Nb1A9xfq2/p5Qjttrh4q6qNwb3Shy50XE+sNvAhDxtvFBKT5m+z3eHlpHaZSmpzEjQSWLh6fvdSTcuWl8J58eIjXdSW99JeD4FOhJuckd2lxBaAFJXWoCGIfcm6PHwkSiLkZABJDno5qEMyW9SSguB08FSZEtrLEEusiCL9DnTz4/ysMwlwcRelBka+JmvhniadTC3Zpt2nhjhvTQ/nF7BM1b+Zd5c48oAi2CPpgQe9UiMqzp4k5p
 ghJ0cxxd
 rJSRzwLMo4jp7xU03gcsYveO7bmI7eN2c565ijWdzS9bEgO3iBfgDDOyvO0UbOHAxShwANj+QfN8UR34c3CsTph8FODZCLqM/pL0Z2XZu0ybOvc2etN5aSWuLg7VLKPT+brniEkChoHKCcHwYJc+XoXKIC96PjdaTcma/Jn3iNAxea6Uoi5JYYCo854HjDzmI2w0UYa88NXlet1CCctmNr45eP8hN/vdCm4ydOh5UEnR41n2SCJnKqZOicD73iInzV94Uk2mYDMnh5wugbrLiMV3hl/XxshSLQ5sH/4vcuVtucMVSYZbgDqiT2O4uAFECpzh270TerfaY2SHHljxaYK3bsuyFN0oq8AeKL1/KTF2ZNr4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  3 Mar 2026 20:41:10 -0800 SeongJae Park <sj@kernel.org> wrote:

> Currently DAMOS quota goal feature utilizes a single feedback loop based
> algorithm for automatic tuning of the effective quota.  It is useful in
> dynamic environments that operate systems with only kernels in the long
> term.  But, no one fits all.  It is not very easy to control in
> environments having more controlled characteristics and user-space
> control towers.  We actually got multiple reports [1,2] of use cases
> that the algorithm is not optimal.
> 
> Introduce a new field of 'struct damos_quotas', namely 'goal_tuner'.  It
> specifies what tuning algorithm the given scheme should use, and allows
> DAMON API callers to set it as they want.  Nonetheless, this commit
> introduces no new tuning algorithm but only the interface.  This commit
> hence makes no behavioral change.  A new algorithm will be added by the
> following commit.
> 
> [1] https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com
> [2] https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
[...]
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index e8c44541754f7..c5503fdb10bb7 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -432,6 +432,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
>  	scheme->quota = *(damos_quota_init(quota));
>  	/* quota.goals should be separately set by caller */
>  	INIT_LIST_HEAD(&scheme->quota.goals);
> +	scheme->quota.goal_tuner = quota->goal_tuner;

Because scheme->quota is overwrote with *quota above, the above goal_tuner set
is unnecessary.  I'll drop this in the next spin.


Thanks,
SJ

[...]

