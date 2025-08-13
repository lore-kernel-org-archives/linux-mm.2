Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5232CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 17:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6199E9000B7; Wed, 13 Aug 2025 13:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA9F900088; Wed, 13 Aug 2025 13:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5076F9000B7; Wed, 13 Aug 2025 13:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF30900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:15:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4EAC82DAF
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:15:26 +0000 (UTC)
X-FDA: 83772385452.26.1F56FB4
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf17.hostedemail.com (Postfix) with ESMTP id 103B640016
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:15:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LVRSsYTR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755105325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlG6b4DaWtB+emMTg3JlINnppkMDuCAqpnoFKG6Fl9Q=;
	b=1RQiGf6enQ1D/svyI3PG6owq25uEuKkppHaqVslegfJR8JoPMiJhuNssNAl73h5LroMxia
	I0HN3GDd+Q4spHgxdy3lCBUWSWamHkwXQu8j9nK0WFb67SDse1VFc0drQhtWdTejef54Yw
	s9yKuQp+iO9wBLwr59LMtx1L/jTjuNg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LVRSsYTR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755105325; a=rsa-sha256;
	cv=none;
	b=WTVqQ+8uTF+X/7WJKA3DcKkY435K7CpazquedROAIGsHxUbzTAAPHxO2FkCdLqN4ZWYCWg
	DYeZZcfUy8Vo7rL7tMYyLCfJjtWOowMG572D1uIIVQgF6j4cxrSVnXuQH0ypSQvzwsq/UZ
	RMLFF+Fi49OOj1BcgpGvMYBfpBjnOWo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 058345C6DD9;
	Wed, 13 Aug 2025 17:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6A1C4CEEB;
	Wed, 13 Aug 2025 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755105323;
	bh=haP9OHMAMhQFyfWQmk2C/oxDgQ10LKbcB3P5wQvSL/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVRSsYTRdX2VYRvvtiefw8TtFiUqluqdhX4D1x/IfKGW18QxA/MT80uUtDrTDXmwP
	 odgWGA6ydkOLcK+k0wYoy+CoxXhcimEBLnEWT4YvZ+Y4yuQWxrvlouRwaPQ6dV/d/3
	 GKpz0muIKNZ6L9RPpM8Z+YcTxHFxwvvrip5WYSOuSRzhxtkkbG4MQDRxu0Re4SXOMZ
	 Hp+favwPOR1ejoNm2xv8VxlHDB85zP3sVmpcJsm+rIlVaWQHSu6Vsf7N3qlooxmHxr
	 cXzBiJOjQes8yXqgPYkiWM+eM4Qg8r4VK12OEW5MFK1Osmpc3MOOvQASCGtRzIDqcg
	 8GnusH16avy/g==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 16/16] mm/damon/core: handle quota->esz overflow issues
Date: Wed, 13 Aug 2025 10:15:21 -0700
Message-Id: <20250813171521.6482-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-17-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 103B640016
X-Stat-Signature: mjty8ynz4x6aumujzm3apx333a4kkiqr
X-Rspam-User: 
X-HE-Tag: 1755105324-782732
X-HE-Meta: U2FsdGVkX1/YoTuGfRjStTKVh1WOvBpNCerxk2tG/Im6/keYBndmp/vzQa+R5uSP4sIHiBvyvliekAZY4VJkXBDAIWprSvE6cfhWdBczjvUBTnnHG7o/VIQ62X/cxO3eR08cbHlyUjbLl5jZChmLd66J18n/VI+jD/C9U7+P43R+aHDzw8Z7/RbBPWIxRHmMDWtt3czj0NizOH1grll/suCbf5eGq2jJCTM/WweU6RflYt+ZPvBhEZkBZU1hdQ/FOtL/7d7LhTyNKlu5OYWviJtD59drGPXQOgSk6Q7qIt26MQqSosDizQw5WY5XfuM5g169kSOR43VVeZh0onTjLzw/sJSHzzbf4X+SoEpq+PBQx3Eif5NMOwyPRTGnHRBaCB1kZoASMRPvZ5nW3ikQU8ndX55NdHMeNzjui1So3R8qMAtabGOSQ5o+xV+RqKdz+keCFR8y5GI57wZWRNxLkLwdD/nv6q2U/vNEuvQHh/Js0NwrFgSBMLLVdSXPzWWiFG5AVIfudN0M92KSVbkObFv30vBJCGlmS1LCymdSjmvGd1fQsqnrfa518Te7HVj4alXcHt/4liXNHPcNcrLoZ2uUEC0WPMadXBsGbMRwVelVXOQrobuSLVe1B53soL7Nl3uNHGrdjxjktiDfcgfZ7ZJgm+v0dHqFweSee476oLhojFP4prIJV66INW2M9GRLOFJBuH60UhRt+KlrM/6+DzQ5zFJMWuA6Ip4wlnvUHUaSMj7BRMQml5nur2WDdAR6mQ+FmLJ7L715PUsjRmUuZ76X/q1hfefGUWDdAqvNKgDb5eejHpolrbe8fZcXUPxJUtZDb0SKPEA9Zm7RmpKI5iZJqzp8aGOsZfXJgUZYFPZTpC3t7X1pLAUpyB40H4NRTRPxeA4HUgqrmcQiTCpLXRLeEbnrvGsSyralJX9rtaG4RcuJEfJI7fhaOlItGB7hW5sdCTPlFFObWF0U9+U
 tSxiLJTs
 NYBC5ZvoSyV48qaYTj2Ttm+zNpnse/QZRnqsWXikLYyL8wAyKUxm4olfDQWrQWWRrYg0bR96VKiPGV1pVBSXNpIWJHlwxVOWMkSM6RFCOVvur2MQXAjxF8tlzuJQcBcd6rP10Bb0KvwIp/qgtk+idD2FzPOQeBRM3xKyLua/LspdryrOTGlokPfFpkSelW42Mg9W4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 13:07:06 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> In the original quota enforcement implementation, the traffic
> calculation multiplied A by 1000000 due to time unit conversion,
> making it highly prone to overflow on 32-bit systems:
> 
> damos_set_effective_quota
>   if (quota->total_charged_ns)
>     throughput = quota->total_charged_sz * 1000000 /
> 		quota->total_charged_ns;
> 
> Requiring total_charged_sz to be less than 4GB/1000000 is unreasonable.
> Additionally, when overflow occurs and causes quota->esz to become
> extremely small, the subsequent damos_apply_scheme logic permanently
> sets sz to 0, while quota stop updating, ultimately leading to complete
> functional failure:
> 
> damos_apply_scheme
>   if (quota->esz && quota->charged_sz + sz > quota->esz)
>     sz = ALIGN_DOWN(quota->esz - quota->charged_sz, DAMON_MIN_REGION);
> 
> Total charged stats use the unsigned long long data type to reduce
> overflow risk, with data reset capability after overflow occurs.

Thank you for finding this issue!  I don't want to change the data type if
possible, though.  Could replacing the easily-overflowing throughput
calculation with mult_frac() fix the issue?


Thanks,
SJ

[...]

