Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4824BF532D0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 04:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10586B0089; Tue, 24 Mar 2026 00:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8056B008A; Tue, 24 Mar 2026 00:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24EB6B008C; Tue, 24 Mar 2026 00:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95B656B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:08:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 287851FC68
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:08:55 +0000 (UTC)
X-FDA: 84579625830.28.D5D4747
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9D56240009
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:08:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=swMnSffl;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=swMnSffl;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774325333; a=rsa-sha256;
	cv=none;
	b=LydPjjrfgTuTQymyPYS9BQ0l+l2o7t6sA48OJyxUW/Pw2HNzZJdohqHQKn28XMhbqjtyAh
	0YmB7qquOlB9+ma9ZzeREsaL/WwTod+bpw8S+Jo4uGiKwS8SrGNh3g5YYkVlfWIv/VWH5m
	akujzFK8DVQLfJjxOSMgf0/33uj2Go8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774325333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNpvENm/1/dCj8hYriY5M45LJZW9naKKsuVJO70iRJs=;
	b=qrQ3JpE8DvUCl3iNG1icxNO7r7ICXFLLJBveKspW+YdNybHpc0VQaJAzBN6thfVw7EoUcv
	f09K31Yw1wq3U3IMsY88HGRanwhA+bHaSplv7D0l4hTNQXZSFv5XohtGwqK79oxHP3KgnU
	onKEqvb8TRTD45XFtqqxX5KRX2jrH7Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E5C43600AC
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84331C19424;
	Tue, 24 Mar 2026 04:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774325332;
	bh=79XuQrnsihtiEE5YsTLFUzqNzacWkJMn2AsEJnnaw2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swMnSffllabeTV0erKbu1hhgJnFGHRfKchRAuKRvXLKdhmk8mN19fbj28cniILeVx
	 I+kmKmAb7NEeLYJRkW0LN6hjIhptKz73DbZHYj85ENNKxg6PfNkBOcaTek5oJVl0Mv
	 lBfxfOteItCXB+GA4rM8Iotpa9HeBk2sQeHeq3tikwL6qNEfAMrxbpYg7VIpckHsh7
	 qR3wGfE9+9DQYKltNXogOuD4Q2sj41K2WJFOjXrm1zV9dfmAa2Q9glq3qS8r11mPg+
	 uTlRoAMbVyqNcYSF/g9XDhXJtlFVoxYgdy2m/oaXya6bBFWPTgTnuJu+mU/bhmol1g
	 m3HIxBMR0djOg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5 07/10] selftests/damon/_damon_sysfs: support pause file staging
Date: Mon, 23 Mar 2026 21:08:41 -0700
Message-ID: <20260324040842.58055-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324012825.46899-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9D56240009
X-Stat-Signature: huk3eo8ebgw6eiow1obshiwjd6w3bwmp
X-Rspam-User: 
X-HE-Tag: 1774325333-714876
X-HE-Meta: U2FsdGVkX1+F1fD3sWlL+aOelvl6eNt9MVX38Ax2z7WodVty36we5YQeoXr1L4OsMgAYcZU5/9tBjV7ct++G7ptvrFpJb4Ebe+Tvtm7oykR58SnrzusiVYtjxrFBUdj1Hz54zwLbQGYBvC/1VlK2KrfhByGPavbYS6AmZSpZIS7UrP6Qe5M0EDBZfjwhFDBDJ5Tu0/bzOY9g6fd2o0qRkH0kWAr5708BDPU6L5IEQFKUjhgoyrBcNO/noe10IqDDgjQ01CkCHzTfZJ7vb6ouJM6uV+v1/akasLz7DeytYotrXTkcZ2xba2YfpoAgsJJzm+rq7L+tkVxD65yLCyuACzezOmi1tSE8jQ3wCC7AAaUw0RoHzzqgQzhq7OHKFw5Vlu+xTjczGtl5qG275Iu3Lq8GgjJCdrQgHA/L3BzbCBZXUZcBQinrJrWuieek88avaz/hRd1dzM3A13sW07rYnPanOGefu43+tg8zJdnxQnoEtGg1h9Gu++KTuxx5jyEEPuG/wzwgrykQkBDZDqVER8THB38i061fKcgGYhEDD4xdI7bLl2WMxo4iz1ZtLtC8QddPd6y4qUZUej8asHdn0DcVspMtslhtkTHrd0SPSUlI5QuIzujGshGncf6hqjfA3IiO7tTIWD4M/EYsRUtor2NJWSbkh9i+Z7H/MPnjD4rWC5aYB/UDGwgEf+ZH6M/fysUjuir4Nfm/h5YyDF2dSVDRPKb1Szy8nkIMTvY7dYH0zOveYuIwAMN/bURBSQmDeQ/Fe4uuPRBkQ1TlrkmsPG8lR4zM2lwjIci1YEddX8WxKgZGqoRfzArV9y1gFM/cRQvr//CZL3XYoUMQRaLkQ0WN/2gVRfxcnmcr6vz+Dcnl61XHkRae9tRfaH1UdPWRF5uhgUeH+ahpiCh8DwrKxFFwsnMQkREgHs/Iqr//O58Hyn7Eo4EDLNH/EkCeblkdWHso3Rscf9SF9Ql8Sua
 lD2TsfBy
 SQ1hORO2MS//eSJq6h1WL8oruUclrYYKK1pIwfHMYFamKwbAbgx/TUDlw5iFxKDcOGnLDuEgmZNjqhXL0kBfYNJglk5Pp+MSY66jum5T6g3KzczYI7MkgpfJg1cgd31QtS7w6zzMYO7efHqpwp0x2UHwBQiEdk74Gy52vsZqJB0rBEzle5GhMPG2SEFGLwe7efyRIU6ETA78wZrWL988gApSyjedWN0RMGD2t13ePbtTK9WWiqzlfhO+f3AEJc/CE/txA61/2QwCgDxC6W0zphsMjiwguETtWJEXgWlYyHfLXYmZPj7vDAeUCu18cFVZSQ2HBonbg2KqPsFqhaAZUwF//vpMsc356GEl/rZsQ0p3DQUwQZYnfq9Esr7DmIubSY2U7tDozh6vBVccslbMBFdbd1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 18:28:24 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260323231538.84452-8-sj@kernel.org
> # start of sashiko.dev inline review
> commit d9ca6c4a33fc4d613982730edda6f4b67ae30a67
> Author: SeongJae Park <sj@kernel.org>
> selftests/damon/_damon_sysfs: support pause file staging
> 
> This commit adds support for the newly added pause file to the DAMON
> test-purpose sysfs interface control Python module.
> 
> > diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
> > --- a/tools/testing/selftests/damon/_damon_sysfs.py
> > +++ b/tools/testing/selftests/damon/_damon_sysfs.py
> [ ... ]
> >  class DamonCtx:
> >      targets = None
> >      schemes = None
> >      kdamond = None
> > +    pause = None
> >      idx = None
> >  
> >      def __init__(self, ops='paddr', monitoring_attrs=DamonAttrs(), targets=[],
> > -            schemes=[]):
> > +            schemes=[], pause=False):
> 
> This isn't a bug introduced by this patch, but since the function signature
> is being modified here, is it a good time to address the mutable default
> arguments?
> 
> In Python, default arguments are evaluated exactly once at function
> definition time. This means any instances of DamonCtx created without
> explicitly providing targets, schemes, or monitoring_attrs will share
> the same list structures and DamonAttrs instance in memory.
> 
> For example, self.monitoring_attrs.context = self overwrites the context
> attribute of the shared DamonAttrs object for all default contexts.
> 
> Would it be better to change these defaults to None and instantiate them
> within the method body to avoid unexpected state sharing across instances?

I agree changing the defaults to None is a good idea.  But that would better to
be another patch, not this one.


Thanks,
SJ

[...]

