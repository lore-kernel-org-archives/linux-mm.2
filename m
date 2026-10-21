Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2463E606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 12:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tm37ZDbD
Received: by kanga.kvack.org (Postfix)
	id 2640D6B020D; Wed, 21 Oct 2026 08:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C606B0213; Wed, 21 Oct 2026 08:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17AAD6B0246; Wed, 21 Oct 2026 08:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E510C6B020D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:31:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 87B991A0517
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:31:14 +0000 (UTC)
X-FDA: 85346568468.21.5D380F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B76D1180002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:31:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tm37ZDbD;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792585872;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AmPCPhtUpqgpJ2u0GqlRc5Zjdh5CqUyYd/DkwsAihog=;
	b=fZj7/rTmnidBqQVWOH8PBfPZztQOsTZLJs7B7KhBahFlSxPuHknNE0zRlCTJy8TOat9XlM
	gX0I3mFbxE9ojnt4lqqV2rPwc3vQo7U6MHdo3O6+2qqxfnnjlg4H6V8/CzCspV1YhjFGHF
	5sm+AfbSdhoMoGLFHeePhU1qM21Uo7c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792585872;
	b=MKyDdnCbdutB5/VL9PLFw7RP7hHK2in7EYPZvf5ZgsOYrrMWFcp2nzQHc7VjsVyhA4BaYB
	EfgRHvRRkY/yWn1bbCZzmhwe0s0PK8u43ioXg11dvp2yLHwQNavy//n5R0T36EqwpmcraU
	3F2mbKTytIQElkn9oK26Q7J4YEMG+dE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tm37ZDbD;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE38540DF9;
	Wed, 21 Oct 2026 12:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7941F000C4;
	Wed, 21 Oct 2026 12:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792585871;
	bh=AmPCPhtUpqgpJ2u0GqlRc5Zjdh5CqUyYd/DkwsAihog=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Tm37ZDbD8d+IlYJN7+SmnnEBBuKRImovwhksG3i2X9rJml2DeE/9liluxau7LBYLS
	 0G8477SqBcff7Zhjy+0LQkLSGIn/tL4anPTYOarP+1HBNiRjbl/ENTK+5mL/IpdN4r
	 jKUJ+QSv4sMnDImTgT/Ru9qtNTdGyGHW32++xRHozaaWAsZFi5fe2SSxEFXWAFKyFH
	 3D2SY1zXZt5BYjiTYwGHhjtpdEHOFhdZCROvL67oDHwuwJ1HPjpXc3d/5oG+VqTYSj
	 CTKoNN0n/YkesjjO7KFCAtX7m0ugYg6408/tz+H8yA7DzhkHs574Q0fUTuhejHYPYK
	 hVo0q1I22AguQ==
Message-ID: <sashiko-outbox-180254@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: zswap: set zswap_ever_enabled when enabling zswap
 at runtime
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wenwu Hou" <hwenwur@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com
Cc: chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org
In-Reply-To: <20261020122942.3477541-1-hwenwur@gmail.com>
References: <20261020122942.3477541-1-hwenwur@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 12:31:10 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B76D1180002
X-Stat-Signature: g7kwjxk5474bxayu9h1kefmgbww91naw
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792585872-579549
X-HE-Meta: U2FsdGVkX1+Cw4LkkwCFtBAJ/He7b2D8t+4LFVVYnbxl4/eiB3dk5m35va4F8RGMK8tUro7H515V/gfzvDAetW3wJGY+fyhU8HuyIpA3jsJiUeTkf+vpXkB2eXuEnDNQuvhQIRtlxkAyVEfABXfvJclDkmRpkZhjYiM5tb3lujImQe3EX8nAg0HN4CNiHTSA0V7islF4XvJu9v5Qohpwq738PdYBQyJpdDhaQDitlHQm8S4KTxi7XuHl5bU4r7bF9BVQnMdRjWU8t9RyB30F+YcRTDayOCNLWPeuVAHfwryLJp5mH8RiY1Q10CSY9u+7thKCzHkGYIW7/LOJMwcpw8OTGs6VZMKFTILrCcPcsToe16jq9iEGtiO1Z0wzOKAkzJFExV21wHSxEX+LgkvCsOv0/sYk8SWqpGCg0tKn/+JmBb8uKNXDTpydeQyFQchAKBr5obXQWr2QPSc/2JhflGLM/HZUbgVXhzbDaMkAUftfP1YXP2V6ibPOfdNpNS0K1nvTBeX2OuKc+2qOKa426HgfuAgOnClYs0FoxU56ChJ5HxD04+OU9kw50HC8H6rFEX/N4Qu79ZD34FacsXRP9EJ69rD/Yl88yX+NL2/tsRd7Iz4bxaXr/gx5v3gDENFwCR8SZZUmioj2yFxXmtVITAiJ9soYcWDPq+Y0eVg90p7Vvq6Vtkg/8sgiDLncGtFaixwW2cjaAt3osB3vUnngzPaZMKKio+lHWS57/w+2l/T883QG82o0VBOyoWblcXbfdZwdIq/XFqsfOzivkI/4kNDLcFob6ILjPLWnlEiGaQTgQNpasU6kcLMCJYB0YU60hzLwcGLdKlTUTtkiFbpk0dWeKz3SAgY9HtJ4FklMnNjC6olLbSLdeq3KkUuSRx17nlblz3GoUpe1d4FLQFNaPp18AxAIZHae/azQ9acCF2AOkFTddKmQOmASIAXdov2lgi4+vJGoZyvmCQPR5yc
 cF4r3Rl9
 x/Lh2uCjwumOEAcA6avX/CMTr4yH2TNRouA/bOHFa9ctndwpiy8OmE+q4IHL6cUc3KbRQYQMe++Vv4rp2/ej0qJ2W7tEa6eKUG+inqHWnkBlqT06kQAY06twGXtuVG6pwtIMFI9RcrkX3Lkp5aiNXYYKnKSqcy2OCu/P6jRsxkA9WN9AbYmQdX7A8s+Ei+13N7fjjXltPMdHxHGYGw1MY1TgIncy79Bzvyo1VUIa6Eaa2lU/LVI/4UVNjIaENXwYyKDGklzOom1rOgrZBfbECGWpLfZVvfsdrzCPWQS87RXyvthRII0cgnjKD22ydztOFYzfNRaDuWDfJWu2QL+OhpHlE7cX531e4QCbX6+PVImXEwNbkLZwpJF6UDCzlckEvs5hcuTWmaD4aJihl0FW/aOQUXdaVjYUk8DrGSq1+xmjSOUGCjEBYEhEh80q1tJ5v4VDD6HJ++Brn4w6Tesh/O6JS1G/DeZFrH3+9skFmWE7dH93Z0ky59cvBR8ePCLKRq5JuJrCd5YimbMM60sPrB+WQeFw1B9kIdodxUkm54WWUJ2QyxW9owGSa3w/lYUUQYiJ8md7AlcR19AdWVHWF+UEEIopSfYm/T2eXBqumcKOSyHr+DhXm7HD7qLL+pbaptk+Y2IjbjdJuhdfepfBKCip4TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: zswap: redundant zswap_ever_enabled enablement in zswap_enab=
led_param_set()
--

commit 4d07b90085374936c4c6222ca58eb86f3db68b14
Author: Wenwu Hou <hwenwur@gmail.com>

mm: zswap: set zswap_ever_enabled when enabling zswap at runtime

This commit enables the zswap_ever_enabled static branch in
zswap_enabled_param_set() when zswap is enabled at runtime after the
initial pool was created via the compressor parameter.

>     mm: zswap: set zswap_ever_enabled when enabling zswap at runtime
>    =20
>     zswap can end up enabled without zswap_ever_enabled being set, which
>     leads to data corruption. With CONFIG_ZSWAP_DEFAULT_ON=3Dn:
>    =20
>     1. zswap_setup() fails to create the initial pool. Setup still counts
>        as successful, but zswap_has_pool stays false.
>     2. The user writes a compressor name to
>        /sys/module/zswap/parameters/compressor.
>        zswap_compressor_param_set() creates a pool and sets
>        zswap_has_pool =3D true, but never enables the zswap_ever_enabled
>        static key.
>     3. The user runs "echo Y > /sys/module/zswap/parameters/enabled".
>     4. zswap_store() now stores pages in zswap, and swap_writeout() skips
>        writing them to the swap device.
>     5. On swap-in, zswap_load() first checks zswap_never_enabled(). It
>        returns true, so zswap_load() reports that the page is not in zswa=
p.
>        The page is then read from the swap device, which holds stale data.
>    =20
>     Fix this by enabling zswap_ever_enabled in zswap_enabled_param_set()
>     before zswap_enabled becomes true.
>    =20
>     Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
>     Cc: stable@vger.kernel.org
>     Signed-off-by: Wenwu Hou <hwenwur@gmail.com>
>=20
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 572075bb1c1c1..bd97652b682de 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -661,12 +661,29 @@ static int zswap_enabled_param_set(const char *val,
>  		if (zswap_setup())
>  			break;
>  		fallthrough;
> -	case ZSWAP_INIT_SUCCEED:
> -		if (!zswap_has_pool)
> +	case ZSWAP_INIT_SUCCEED: {
> +		bool enable;
> +
> +		if (!zswap_has_pool) {
>  			pr_err("can't enable, no pool configured\n");
> -		else
> -			ret =3D param_set_bool(val, kp);
> +			break;
> +		}
> +
> +		/*
> +		 * The initial pool may have been created later by the
> +		 * compressor param rather than by zswap_setup(), in which
> +		 * case zswap_ever_enabled is still off. Flip it before
> +		 * zswap_enabled becomes visible to zswap_store(), otherwise
> +		 * zswap_load() would skip stored entries and read stale data
> +		 * from the backing swap device. param_set_bool() treats a
> +		 * NULL value as true.
> +		 */
> +		if (!val || (!kstrtobool(val, &enable) && enable))
> +			static_branch_enable(&zswap_ever_enabled);

[Severity: Medium]
Can zswap_ever_enabled actually still be off when reaching this check in
zswap_enabled_param_set()?

Commit 91b4edb993e1 ("mm/zswap: enable zswap_ever_enabled in
zswap_pool_create()") already moved static_branch_enable(&zswap_ever_enable=
d)
into zswap_pool_create():

mm/zswap.c:zswap_pool_create() {
	...
	zswap_pool_debug("created", pool);

	static_branch_enable(&zswap_ever_enabled);

	return pool;
	...
}

When a user writes to /sys/module/zswap/parameters/compressor,
zswap_compressor_param_set() creates the pool via zswap_pool_create() before
setting zswap_has_pool =3D true:

mm/zswap.c:zswap_compressor_param_set() {
	...
	pool =3D zswap_pool_find_get(s);
	if (!pool) {
		pool =3D zswap_pool_create(s);
	}
	...
	if (!ret) {
		put_pool =3D rcu_access_pointer(zswap_current_pool);
		rcu_assign_pointer(zswap_current_pool, pool);
		zswap_has_pool =3D true;
	}
	...
}

Since zswap_has_pool is only set to true after zswap_pool_create() succeeds
(either in zswap_setup()->__zswap_pool_create_fallback()->zswap_pool_create=
()
or in zswap_compressor_param_set()->zswap_pool_create()), and
zswap_enabled_param_set() checks !zswap_has_pool and breaks out above, isn't
zswap_ever_enabled guaranteed to already be enabled here?

> +
> +		ret =3D param_set_bool(val, kp);
>  		break;
> +	}
>  	case ZSWAP_INIT_FAILED:
>  		pr_err("can't enable, initialization failed\n");
>  	}

([ =E2=99=A6=E2=99=A6 ])

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261020122942.3477=
541-1-hwenwur@gmail.com?part=3D1

