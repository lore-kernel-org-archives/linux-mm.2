Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E383B10F3DEC
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05E146B008C; Sat, 28 Mar 2026 13:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00EFD6B0095; Sat, 28 Mar 2026 13:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8E316B0096; Sat, 28 Mar 2026 13:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4C676B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:00:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DCD3C0517
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:00:13 +0000 (UTC)
X-FDA: 84596084706.09.4B4E6BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8844E180012
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:00:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TDd9S5Ou;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774717211; a=rsa-sha256;
	cv=none;
	b=Z0eRmBJB9MBfEf253/Ui4gGwEL346Y3Fm4LufE9VCBUwxQLrzJXNfvM77ks6WgGoVvOW/g
	Sj3A/iYdhe/4WPP5laR+CwQp9YNAAYnVJaCzGzS+zAksK9yDLWqvMLUyqMkoQUa/eXA9GN
	k4dd/icA3q2pfwidzqKLDUfjKSkWskU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TDd9S5Ou;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774717211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggExB6DCHAsatHd2NbALIkykloNK7wxjHImoKs/R5uw=;
	b=c3SQwbNymLo+Vq4gZ1F/Uzrw4y74Nr2Rdyrk/KEs9AUyhx3dnhrewSXaC4Gt/jzuiDuUDm
	h5uFCRd+y0nAkKvQHO6hsdasyKA0i7ooe5XjWSzzez0aZh+VnMzk17k8G/l7mrXc3j/Ujb
	jFbK9gCrcK3FAt/IcDr9/6Sd6APIOd8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 844CC4031E;
	Sat, 28 Mar 2026 17:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489B6C4CEF7;
	Sat, 28 Mar 2026 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774717210;
	bh=s68sSmfGQcwxwE2rGybfBstgYbqH0EAa4djt29SiEG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDd9S5OuJ+XrVdbfEldX/D5gVlsDPXciDaB1qqqwyNrhejtaEG/W63bYL7YREGfc6
	 x9EdpA1Z5El9Ry9v58C9/tUiM2LYjGAHcHCGzf11Z7CPel/bNsFSZV/GtftxE6gJ0p
	 dtanvwnVTu82ChFGI0CpFcq+LOdntane5xR+FPSXAMTOJgu5ZVtOtpT5ZNqHo0nrHK
	 wV999tiuK0kEtoJFAxoByRTmVCWi2Gae/fjqQw3BYDTx5XeDsW/F+jgLSU0tWxRfb1
	 lcwufXWgJ7wvW18xAlOVsh9S70s5JMDIHehLEZAMNW2iYljQEXNh3dRq76MhcZw5x5
	 bV1ywA0yA8yfw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 5 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH] mm/damon/core: use time_in_range() for damos quota window start
Date: Sat, 28 Mar 2026 10:00:08 -0700
Message-ID: <20260328170008.48144-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328163930.47096-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8844E180012
X-Stat-Signature: tt4rhxhmagqnn7gj34krgp9hho59sfha
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774717211-78408
X-HE-Meta: U2FsdGVkX19vHSvqbePOl0k1zFaVfX5rxJ6j3gN3UaAOEIpyrwJuJXM/9eJqFri/svibM9Iqq3PBaJl/KKG8FWNKSeHQhArv1bxZObcG6mfLWXImQwRe/h16JHrA4gn5jWhFUMldihpwrzCGZIVL1A+JQatIkCTNnq5+EZqSDi6WXzZTy9Lvi+w8HSlH6w0y+p1qIeSG+OUg50WIOE2vAuIuf9R2UmAqXEI1iQdBvedGIsrfvcUQd5PsHkr/VS4+T7gaqWuU1aaGqfw2JP8aMcCsqnacVIUh0kcD4Tr/bgbGJs0Zvy4ssR1ovoKmWoIMpB/EDU9eH8RBB/6YbQu0IiyCiOnaBpa+67wJ/HldAvslA7LDuCclOqe5PaV8ZrLpbxPiwbPh7vAYIFmsbKIhZIHhTeATNEo0ujParVACGa6AGgpapferZWMfY7n9I3H9Y1f4nalnGWqEBswGBXr0q3ElXyfxRXEglw0wHXZ5Dm8C68xI3FNoVxeac7N4zGHhsXUW8T1+f2TEEd3zDvmWM/+rIIg9m9CivFYzlDbxazU1+uu6Kojqp1rNfYdOWDHOoTb0jNPmvCNSYcXvOPc3WyZmfTGsYe5r+9QLY35yid6Z/UAK+WMIZUJckh5lMCULqSCDvpkcMkcw+75QkhFfEmUZikXUYmXK1iG7q0lp3zqrzO7QzZ/jxJw3j2+QRqXqzGoeZmVjE1cTtJC9umL0SyoATcAeq4Wa+uaKG2dsjHjmFUFUn4U3FJ58rOlCjLCAu9s6A7eQKImrv6WGHT2IkZTGChSqVZ0uwtR4+xppD8pNRY045MJk4j75UlFsIMeTf94DwWjzs923jqojaLO3DAUn4dPHHF4Y7wezPpxqplpKcLzJSjltW17ygaJG5PIXv2EBAUuzLd284AmA0klAJBmSq59kwWXlvZPSXnBC0Jz8z1HJXGH4LGuViTY/GM2pI/i7Oau3Ns0wfzi/xkX
 q6ODtGnP
 x3uaroH1HrimKOpdomCgMQ9WwM8duccLXjzDcUzwM0onIh5amnT7DgCawohd6qszat6TH8qw2aKDJOQlk25tCU8AVtsfAY3xjBI99S3B1ZIB20loO5ndZNY41ZbYPBgH+evLSrgNxVdpu7rngPvllCYv4z5LmLoldjoapMjTZtkCXpTe9FZIX7PzF84cswIaQ0IFeqOlO6Jbze7danMoI49UYllwnFHl/j/3oDKX6WWw7352+lQixbXLfp2FOyyPo6dz+3/UaBHnUDjLOvxJZ/cGceqpw9d1Ev05msMyZqksSA7FVYFamWA8ZUX+ruNo4gvplgH0X0tuJcgDu5+GbA5YW9qaI3DU9gC7C9dOapuumS/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260328163930.47096-1-sj@kernel.org
# start of sashiko.dev inline review
commit 2ee07f5a4fcf25b39aeac61c6b88fe3fdfd0c9b6
Author: SeongJae Park <sj@kernel.org>

mm/damon/core: use time_in_range() for damos quota window start

This commit attempts to fix a stall in DAMOS quota charge windows when
a scheme is deactivated for more than LONG_MAX jiffies. It replaces
time_after_eq() with !time_in_range() to properly handle the extended
time wrap-around.

Link: https://lore.kernel.org/20260324040722.57944-1-sj@kernel.org

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index db6c67e52d2b..8e47183473d3 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2452,7 +2452,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
>  	}
>  
>  	/* New charge window starts */
> -	if (time_after_eq(jiffies, quota->charged_from +
> +	if (!time_in_range(jiffies, quota->charged_from, quota->charged_from +
>  				msecs_to_jiffies(quota->reset_interval))) {

Does this introduce an off-by-one regression that extends every quota charge
window by 1 jiffy?

time_in_range(a, b, c) evaluates the inclusive interval [b, c], which means
it returns true when jiffies exactly equals the end of the interval. The
original code used time_after_eq(), which correctly triggered the new
charge window exactly on that jiffy.

By replacing it with !time_in_range(), the reset evaluates to false on that
exact jiffy and is delayed until the next jiffy. For small reset_interval
configurations or low CONFIG_HZ values, this 1-jiffy delay might alter the
effective quota replenishment rate.

Would using !time_in_range_open() preserve the exact original timing
semantics while still fixing the wrap-around stall issue?

>  		if (damos_quota_is_set(quota) &&
>  				quota->charged_sz >= quota->esz)


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260328163930.47096-1-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260328163930.47096-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

