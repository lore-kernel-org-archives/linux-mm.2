Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93073F9D0F1
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 21:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9FB6B0088; Tue, 14 Apr 2026 17:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6AE16B0089; Tue, 14 Apr 2026 17:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59836B0092; Tue, 14 Apr 2026 17:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9439E6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:05:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24311139CAA
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:05:39 +0000 (UTC)
X-FDA: 84658392798.24.57D2AEB
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2CD9CC0010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:05:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VBZ16NCm;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776200736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WFQt6WFmWVPfUNz0yp/lCGugbU7zTlDBXyrUbnhxBDw=;
	b=gsXtmX+nx3uHvtRVfHHrfQ1A0TguGrX8NKJ+Mnu4mIvDJdsqkXMWKCW3J/YFOXK7u3vqbh
	nrgJKWcXLgUhJZbmP1Uv9wfodzxybE5W4FhFSf1uT/pgiPp+pGiZncEjikaNXmvfqyzHvJ
	nZj/cL5TUByJrIhtsTYKoSbjlFHmaZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776200736; a=rsa-sha256;
	cv=none;
	b=Y77K9JjwDqYB++Qzn4DtR1roe8skIfyTRvawBzX2Pk21Kvspw+kij4o508Ma9tHY9CUwe/
	HFk+dITHFD8tZGJPMU0sGEx+p/9/Aacx/tzOZT7gxjsRcgP5WL8tzUt4iZTrM1HSfD86kr
	/rHHVJI9GiK71GLvXml58mwLbz9cBjE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VBZ16NCm;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48896199cbaso64293395e9.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776200734; x=1776805534; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WFQt6WFmWVPfUNz0yp/lCGugbU7zTlDBXyrUbnhxBDw=;
        b=VBZ16NCmxhIqw8HLFpZLLvA9Fgg9hWzFKNgsRZbmFdz98xxlPqshMmL8xLWa3R6lg6
         zhKTShDnjQ2Ms3u9YhuqzwKwo57wT2GhqUPSW+oO6cWduUJDZr65AVsZAxdy6j+gTToy
         JZ/9+ZytC7MIUEgGFmT0EEwskwPvbihN4En1QehEv/z5dWPCzUUR4W3UuW5dw0rwuzj0
         OIu/R7M0uthtzH6eOUGys0RwltxB/zLR+sxzdZxAIAG814XgPrlDobly8YgDQivBMeKe
         IfRqzlpRgIaZCnko6XZPqDhkqJdNtHKLTtP0D6VFi1Gpl41S/GiNqjO1wfYxkU0VC0D0
         EuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776200734; x=1776805534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WFQt6WFmWVPfUNz0yp/lCGugbU7zTlDBXyrUbnhxBDw=;
        b=oM+aD4B5kekctm/G145JGQwh1lW0kvDelXngYxxbw92LRDOkye1NNDfF/NTXdsj3qW
         V2kc2NHKbb6W7yoIOW7A6HxpIZszJ0Dk3bea3g1MmkVSvu+jpG7j93gD7med2BmyFd6Y
         IAnY6KLG1Dtn4iw5RSYyfpFPfHLpw4rCGQ2bWoKEYZVTXbO34bYe5oAM/lmQN9SvYhfy
         t8gaQdEFOgbA/1+lbTUP31eDKSPa3afX2l74oRZXviGSZODXwz2Ik2q3HN/MJZ+WG+ji
         8gYxikvkV+AYVCSPYeEumwdD0aJwC1l17ttZxPIKsp3TnozHb+/vVY34AldMn8tJQrvG
         NK+g==
X-Forwarded-Encrypted: i=1; AFNElJ/LQoYRpBe8X9JvJHGJ6pMsahWoz+S3xnsO7di2x7HAvGpTIBs07LK4WTcn1UwLCVqInBw5CrV5VQ==@kvack.org
X-Gm-Message-State: AOJu0Yys6tvsiPI+VM96NPTiaQ8MIbmPYH22kXz7ziomaDmbGSe+gDS+
	0iWwirj/tXfClmG7NRK3Ybr0tgEWEGIkW3KVxdtZ6/UnGU20ZU49+VDe
X-Gm-Gg: AeBDies9WxUYFyQ0XNNA0cZtm5E2HAbjBT2jy7M6+rVjBxIm4A1seiF8V3YpHXI9wmU
	kHam01AxwpiYAsqlAnIi7FIPdi2vns54kPwstYbC9wwBz86EMB4EHGkGnfPgRXSKGfMn+99sRRd
	42HHaXjecRrPw6koEes3kyuKVA5dO8FfIuGD8X5cLmw3jbf4BOl6+iooQHS7TtMx93Xi1rVo6Vo
	qRfkJVEUwNpZZRJGgUYiN9M+PryhMuNT996javC0vI7sU5ZLCo7utgfQWhmRIHrhQu8V4EXDwA3
	m8XuY/W9ZdWVMV0ZWOG9DVQ48zVeSBhB5MMdIW41B/+4siRSWC7BUfRDfcEvHlvpVTh6lrqrel2
	OeKlH8hrloggYPyjaf05gW/+woY8fow/ppXowTD1NdKvPy/BWY/Box+6k7c6r68Xr48WunKxLsz
	PAVe0Qc5v/rJrhK1Cw0GaVjYU7P2hLSUQIipfC4SXhSdFdDu38n6KEGVWpW8JKmH/T
X-Received: by 2002:a05:600d:d:b0:488:ba5f:984f with SMTP id 5b1f17b1804b1-488d67b8dadmr205583445e9.6.1776200734242;
        Tue, 14 Apr 2026 14:05:34 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ede15cfbsm83786205e9.1.2026.04.14.14.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 14:05:33 -0700 (PDT)
Date: Tue, 14 Apr 2026 22:05:32 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Arnd Bergmann <arnd@arndb.de>, Kairui Song
 <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Michal Hocko
 <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Koichiro Den
 <koichiro.den@canonical.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] mm/vmscan: avoid false-positive -Wuninitialized
 warning
Message-ID: <20260414220532.3c89dfa3@pumpkin>
In-Reply-To: <20260414065206.3236176-1-arnd@kernel.org>
References: <20260414065206.3236176-1-arnd@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: bgqnrxh4jxxp4awkmt54dajiyd36ktey
X-Rspamd-Queue-Id: 2CD9CC0010
X-Rspam-User: 
X-HE-Tag: 1776200735-259871
X-HE-Meta: U2FsdGVkX1+Egbfo5UUOWZK/o1d5VIgfcziQEligcfTML6WTl1PULHS6gOTq6iTXaFt4almBasNVLl7B9h+2s6/z4YrQ4QO8bUuMIwEUo1bD0pMFLvg1uTZfEz7FC8nDjjlqsycTKO9dZpZjZtq0OrnC8bBNx3w+9I16vMJs71EaeY4sd94stL/NJ2nzMzaeJnDwynVB9e1Rba11Vpk0BE/QT9fDlF8Hup34ajdddNwllH2CIdCEN/nVDYVJgopOTX7BnRT8VYKgFbgIW/2ZbdPr7JIGHTD45L+qjOsPrQyAbvYy2mMaICh06MaD0qpfatySwZAkW2UmTwp+dAcd+TgILuzajtcFXcIp0Ot8PdEIArzwQTm8vbtv/VPoq0VV415hOcuzxwES/09JRrw1ds9cqtyeEdwr78YQOlkg+z4C/pl5cqUJDb/U4yqoVbYLMWhMIxBnGAlAkZuXkgIZM57FuJLJNi5rGMsNyVaYQpsWZuZj+v24tWfWhLXxSS3OirXOhXKqXnn7p/a54jk4LBg2BO5InDB7qPYL2mwKLPlJPujtH+5DTkt+fRfZ1BWp99uwRG+YuyktVhJIlF1lhY0SPmRYTe+0NBAxgoVQ9qVr7+Izr96bAnDGoGUbViclkpQXk9sqlLoiBVQnzgAzI6IHPjei7XyhJpZ+In1QSkbdZ/G46Ae9uHsXW7kLphaocHP8LKRiVtoAvS5orJr4u+V0qEs68AFTdaEWHNATWksNkqNc+91ZckjBsZoVxi2fIwvli81RJXsEGgR1Jlhw54sh9/EQjM4ZTKMHLhlF2D1VbNm0zKQ2wCjurYTBMAx0GEDxOScsBkJTMPZKQbYNTbFDXNnlZFUWdKljSjtjXu97i2lJQ1MmtKhK5vMwvyZKybp967f7iJpooVyOsc5ePKmYQNWToGQsvT2lvm+o6jC421eNjqPtMmfsHjWzEnxAQYOd6jmK61wr6d/NMvD
 gXHQfXI5
 6c2lRuxjtHCxKYUeEQFCAAhYPwj4i0qLCYITkzgHF1LGXLTIgIz1LFUdPJQZIjvDOC5680gTndFSg8dlQdQhasCP0QWsRFjjGygvKH6baIIoJGVkkNJA7zopy3gi27ixXqmdG5mYfRdJPrit1o4wdPXoS2mzYE0g1WrkbRUvPg9FuI3kuWRMGziOhyiREuaOY9LEDLgJLuU7AGy4FFpxqUlqetRPNIxnSQbzbb0ch+rtR1572AHQnBjn0QCBPeeDokKvrn93EZ1CrnRIkJ/enqUM4TuzV2briGaJIHS1MhP3zkjr/XW4Dk617Mjw2YkfZtHLAE4Y7w6tJXZnRVaiWYtdIujVE7pFbl0JyqCaSR7M/jE9mQHTwW9ehW1G5JC++ZjtE9TU2zUJnTeU2qKn7SwS9DFV5JJ3j7ZYJKFm8LAehbEyorlXG+DyzvoqoffGbITPSNI7p8iZRzJUc+PdxG91jrmu8IzCuqqMZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Apr 2026 08:51:58 +0200
Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> When the -fsanitize=bounds sanitizer is enabled, gcc-16 sometimes runs
> into a corner case in the read_ctrl_pos() pos function, where it sees
> possible undefined behavior from the 'tier' index overflowing, presumably
> in the case that this was called with a negative tier:
> 
> In function 'get_tier_idx',
>     inlined from 'isolate_folios' at mm/vmscan.c:4671:14:
> mm/vmscan.c: In function 'isolate_folios':
> mm/vmscan.c:4645:29: error: 'pv.refaulted' is used uninitialized [-Werror=uninitialized]
> 
> Part of the problem seems to be that read_ctrl_pos() has unusual calling
> conventions since commit 37a260870f2c ("mm/mglru: rework type selection")
> where passing MAX_NR_TIERS makes it accumulate all tiers but passing a
> smaller positive number makes it read a single tier instead.

We've had issues with that code before, might have been related to the min().
Unless that function is inlined (and the compiler generates a sane loop)
the generated code will be completely horrid.

If this code is executed in any kind of 'hot path' it should really be
done differently.
It isn't as though there are many callers; and one want to process
all the tiers - but not in the same way.

The code isn't even that readable.

	David

> 
> Shut up the warning by adding a fake initialization to the two instances
> of this variable that can run into that corner case.
> 
> Link: https://lore.kernel.org/all/CAJHvVcjtFW86o5FoQC8MMEXCHAC0FviggaQsd5EmiCHP+1fBpg@mail.gmail.com/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: replace the earlier more invasive cleanup with a trivial
>     workaround
> ---
>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d3312c51f3f2..f829435d2807 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4760,7 +4760,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  static int get_tier_idx(struct lruvec *lruvec, int type)
>  {
>  	int tier;
> -	struct ctrl_pos sp, pv;
> +	struct ctrl_pos sp, pv = {};
>  
>  	/*
>  	 * To leave a margin for fluctuations, use a larger gain factor (2:3).
> @@ -4779,7 +4779,7 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
>  
>  static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>  {
> -	struct ctrl_pos sp, pv;
> +	struct ctrl_pos sp, pv = {};
>  
>  	if (swappiness <= MIN_SWAPPINESS + 1)
>  		return LRU_GEN_FILE;


