Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 654F61091911
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 19:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6221C6B057F; Thu, 19 Mar 2026 15:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3026B0580; Thu, 19 Mar 2026 15:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8996B0581; Thu, 19 Mar 2026 15:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FC486B057F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:24:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B9E7E8C25B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:24:23 +0000 (UTC)
X-FDA: 84563788806.02.4E2BBCB
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9810E100007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:24:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=WQ8VgxRz;
	spf=pass (imf14.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773948262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33NI7AQ68Fv4tWuv6cyisEGZPSwIxMJf5Ty5eJ3x0kE=;
	b=XZGjguWu+CtBiT0awTx//1yGnrMNOWVcGlc8ovwxcd9Ru9e+GZbBDr7HKInKwsYjpdZl8o
	lSt5P+X9hRVsF4aYrsI72L+UCjHAB0yoSQl9C2GwOtrqQzjrHeV3alkQ0hJYToso1csirW
	FIp73RdCemGW1IvHdaYtUtupLngFgcc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=WQ8VgxRz;
	spf=pass (imf14.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773948262; a=rsa-sha256;
	cv=pass;
	b=Ei6DM6tOccdpp9PZ0vfQQj9tiy7lX4B1N79zH7GGckumgKYeIYwUodGqmoA4uI0kQPp8a2
	qb2UYa7BFb8HIpj8rBqrB7pFa5vuQY3qSqUjyGSGYGT9o9b1yvEFyyahY68/fqLXMjyO7d
	3Lope+5jHD37Lj5O3v0lpkSxZN2vi5Y=
ARC-Seal: i=1; a=rsa-sha256; t=1773948244; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=LpXiz/tFnOLoP8QiZ2R/nq7fmTNiYGJi3qCyBCowWWMRmxUZgWjcQO51sbT/oGuA3NGf8chr2rakzPqj5GCwls3kz+XCQXeivvcSrpFr3DfmI0iL6snvGj/dqQxg8oCoYgFxmrSMpfMSOHZCzfkTOGDovynoG5LBI2STDsUz4t4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773948244; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=33NI7AQ68Fv4tWuv6cyisEGZPSwIxMJf5Ty5eJ3x0kE=; 
	b=HoX+lQPa1jdM8dBhh8GbSWhyhQnEEdImTRp/4W750SKHUw6jp9sjn9dctNn3I5VNEVysCQm0BWPTWubc+jLCi2C0FNdj8LO/ABrG2ZDVgGosHpfRz2p5F7ME3rg+Gu4RqFDYW5RbMsfH1RWFDgwOqkShmh0vUy1y3ryTM+aL4GM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773948244;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=33NI7AQ68Fv4tWuv6cyisEGZPSwIxMJf5Ty5eJ3x0kE=;
	b=WQ8VgxRzBRI4BfsQJNu0TZgSuX9R+xHb2ps7HuR8ltKXrTV8EE3e6Fc4dpXm/6hC
	KyYGK2GzBf2akrXPyKH09Cd59VoVcT+gSzkFekUJE3rw4dzz0TvBlQWaNP/DfFfcmBz
	tczEcRrWsTjy6l55y/JmxpsPSuEdtpMYBM8HIE5A=
Received: by mx.zoho.eu with SMTPS id 1773948242358679.734141052429;
	Thu, 19 Mar 2026 20:24:02 +0100 (CET)
Date: Thu, 19 Mar 2026 19:24:02 +0000
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org, akpm@linux-foundation.org
CC: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_0/4=5D_mm/damon/sysfs=3A_fix_res?=
 =?US-ASCII?Q?ource_leak_and_NULL_pointer_dereferences?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260319155742.186627-1-objecting@objecting.org>
References: <20260319155742.186627-1-objecting@objecting.org>
Message-ID: <73D7C494-E746-499F-9EF5-A6C7F3963302@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 9810E100007
X-Rspamd-Server: rspam07
X-Stat-Signature: zezxmzy3p5owusm1xys1m8i7ybiqfmku
X-Rspam-User: 
X-HE-Tag: 1773948261-710581
X-HE-Meta: U2FsdGVkX199slvzPU9QYSM5wl4tTMlYEaB4Kev9IN2AnqM7mkHikC1vBseNRDdXqlYYx/Burmz/Z47fB8Ux1bfM0217a1Kjw5r9U76m62qOT9DXKhERkPKZbOG/+7tJonqBwoh7MfJ9te8zu1jV/iO18McmN5BHvNvEG3YkGywkaMVNyWbY2GzlE7TLQnIzvu+T7YT6GLvzjgh2AYHorNro4ytVoU/dzlmu5VX7uXR5gohioWqEJ0/H8VnOVOzvZZ9I7/ST+R9TPI9aj2MsRP4Vch3MMf3mMOMr79r4IIN1nXdWJrDPTfkjE+/ckNWAE3oKt2RvE4FnOYqNifiwdN2PFVG98wS57hkIQh4JlWMyfYt+2nOwfoyMzj0iuZMNvUb1Nyc5g+SvmOIf7Cmzk5LwhwLIAuK30Qvb4iPxHbwBa0kFALlizrd+UU1UyUmjSdOX/Vxz+qG7bMpR/ej3OqHaxDhqRXcH4jKPiMOClCQT2C0Npeblk10tbUt3fnyWAL1hF9YbecdKVZUtt5p2m5Gk1I3jALBnPpmwnn8I8d7t6/9/tQSknm9MYAOqbC2rjgQhh0S7neEggXInKFR8vvu9Vq/Fipb9gBHekgsqMRtJnXOaOkKJ1CJJ3yj3mzoiKp5IE5y38RsvVBBKq/u0xXRh21kCMOdD0ehZ1XhmBegLArUURckLZjhEH1WoNS05A7ZCx7g1Btam8ohPc25NJpxHIB0mb+ey/r7mqvrnJuo/FB8hnDdrcQCwfdqPERuUAG84g7vorHhHmzjMLGcRa2em/Vb9QsZAiOzJPzOyOlrh2RgJQmvEAsIF1JThejdsVLxpreQhutuuQzo8LnitiQaEhXr5czrZNNJvckJ/jJN40SHWi5ovTVcRWSjY9iVKA3PS8c0e9cN9U8uJlMiusX6IjQySABQhW5HfI2WQ0N7B7aIyVz6GTgtm1xfbhKsy/qmPqgFiqkmuYzL62QU
 VbGQr3nJ
 74HqeCJ/3XVpR+yOns+O4fzrmJsODo1R3R0LKxXL8ks7GINAG85JzJp7/7CXld5SfqKPp9919np+4YfDakGTocp9aS4c7Tv1DQ0QiPVNlMwY1sKhjiqOfl2Z/GGKpFF8fyetZnzzerzRDL5dXjS71EhHBLVtr9ErEjx8A71qmyvptwl/g1Dgf+cMYks35pxFXWUzM8hZh437DSz2o0ug78OoIYCeMV3LtkeMYD7xuc1SS1t7j/xx0WD2kzDMtO8m9AFtMS2Y1pEL1eTtRF88xx3zPuwzuADGla8mkwLOpgfFtbz9owTOpcwaDI5IbTwiXxPjQWjayGnKOl52UE+ox3dX8IZBcAa/KKL1mDeFRSr3L+mIw24/X0et0GpOHpRdh3XxKP2u9CReu9i9pPMQvPiRbNQ5Uvi8R+3WtnRLQ4R8D/i4VT3D0ggCYh+mkvO5QZs7T0FnYrD6Ne5zDDktbUzR9PGk94nV/Zf2i2Z4/3Qm+FITUKAzO4UmNITzpL+Ottizly//kjo8eR8MSY/h8Ej1LqksYSOhp87RMZ+vVeb12g3S1bTssrPpawh1M9QBb0DIVzphO1eO45+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19 March 2026 15:57:38 GMT, Josh Law <objecting@objecting=2Eorg> wrote:
>This series fixes a memory leak and three NULL pointer dereferences in
>the DAMON sysfs interface, all in mm/damon/sysfs=2Ec=2E
>
>Patch 1 fixes a damon_ctx leak in damon_sysfs_commit_input() when
>damon_sysfs_new_test_ctx() fails after param_ctx was already built=2E
>
>Patches 2-4 fix missing contexts->nr checks before dereferencing
>contexts_arr[0]=2E A user can trigger these by setting nr_contexts to 0
>via sysfs and then issuing commands that assume a context exists:
>
>  - Patch 2: CLEAR_SCHEMES_TRIED_REGIONS handler in damon_sysfs_handle_cm=
d()
>  - Patch 3: damon_sysfs_update_schemes_tried_regions(), reached via
>    UPDATE_SCHEMES_TRIED_BYTES and UPDATE_SCHEMES_TRIED_REGIONS
>  - Patch 4: damon_sysfs_repeat_call_fn(), reachable when nr_contexts is
>    set to 0 while DAMON is running
>
>Josh Law (4):
>  mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx()
>    failure
>  mm/damon/sysfs: check contexts->nr before clear_schemes_tried_regions
>  mm/damon/sysfs: check contexts->nr in update_schemes_tried_regions
>  mm/damon/sysfs: check contexts->nr in repeat_call_fn
>
> mm/damon/sysfs=2Ec | 11 ++++++++++-
> 1 file changed, 10 insertions(+), 1 deletion(-)
>


[0] <https://sashiko=2Edev/#/patchset/20260319155742=2E186627-1-objecting%=
40objecting=2Eorg>



I don't think this is right=2E Probably best you don't listen to that=2E=
=2E

V/R


Josh Law

