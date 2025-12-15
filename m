Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07AEFD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 04:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15BE36B0006; Sun, 14 Dec 2025 23:12:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E296B0007; Sun, 14 Dec 2025 23:12:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EB96B0008; Sun, 14 Dec 2025 23:12:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFFA66B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 23:12:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 867905D5F8
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:12:08 +0000 (UTC)
X-FDA: 84220382736.13.980B125
Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com [209.85.219.65])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6B78B18000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:12:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cF7YyQ9a;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.65 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765771926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E7DQ2g2y7DFnp+FRCa/U8wGU2Z4RUvLIQJbTa2M375k=;
	b=FbzWs5J9Auy+VFWHQoOWxv3Q+xNV+ud/f6zjM93WLS5Vv7C/xxsF4HMJs9irvALPZRaq4n
	n0Kjpe6+PbDAm4kCjoDtu2oI3QkUoUYoxeCzIptj5/W8yPPRy9N9l7J0FLF2oAR7uI+nEd
	BS12C56Qw1z7QKRU5wyC8R3zj/03zZM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cF7YyQ9a;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.65 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765771926; a=rsa-sha256;
	cv=none;
	b=b4WK6ED0AL4UTtuntUkngGetSyvkWCqqoWXdKMJmeJBY+DFu6awZUiocxpNlm+VyaNXKuU
	OPweD/TQHrLcQIlzUK3DkmpyfUX1g/g6hutr4y8vYAWvwB2HweRH1o179nyFfogyfDfGWN
	sBbFrHEQnw00/6c84/DEm383YvGfxPE=
Received: by mail-qv1-f65.google.com with SMTP id 6a1803df08f44-88a347c424aso8080376d6.0
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 20:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765771925; x=1766376725; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E7DQ2g2y7DFnp+FRCa/U8wGU2Z4RUvLIQJbTa2M375k=;
        b=cF7YyQ9aY5HmYrjPTOnLnB8KRNbMirFC+yHuKNi9k45T/qSbxHTGtrcc7ijAwW1jYC
         +tmlyIW2bAOFrD2dPaheh9U8M8oF9tXQokU/IMvnnzvN3icf3KORENVeTYI6aOW6R/G6
         xLqTqHJxIzaDY7ezd2g2tgYz7GOGYAMh+i/HTQ/y02BDrgyIJu8ClbYyRAiTxIzBK5Hq
         PcfJkpFC/hxkXzhGrfh38rDAyq+BAnT5vwlWRDZXgZ+RxGNu5Ra3lcTYySXr2y8VvfRt
         OYg0NV9yUMEPvlmLpyfe5OhjmNBrSsZlnxC+VYTzF3loFkKHKwiwjNZETn+0YHqPOvvn
         ps9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765771925; x=1766376725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E7DQ2g2y7DFnp+FRCa/U8wGU2Z4RUvLIQJbTa2M375k=;
        b=XBFe7rfCw0MsDcHThiiy0nPSxqjtS69/UKjzH3YAKmRT3p3KiA4YfTkGq8sIdSEgV+
         dVxpkcXvQhj62qYbAGtzrv0PcfxlpKZjU298LO8Z9TP/tZcM7/AW2QYTS5neDwV69uJN
         4ocLqASNntRBY24VHKh+aFG9IA6cwplIq9d7/MUl1vAUK3FM19Nv2tD7AgzOh0mr1PHJ
         9MHySTfkkYMMzX97dGUowtYP3GUg6hrKRxho/HvfYgMXMekVmQrjo9yWfdw8JXxEIKf2
         1IkTwxNwy43R2ORgPLCuTaeG+eNYLoGZKcO9Lv6t4/2/lz4oz2Ov8JFMdO1UNuB3Klpn
         TAFw==
X-Forwarded-Encrypted: i=1; AJvYcCUwqxtpdItcPUBEhf33CSCETZRTAuxb3iq8qhNv/9sbkztS/a+omigdWshCIOrEyHOdDV+MqNcmSg==@kvack.org
X-Gm-Message-State: AOJu0YwxGmFpG+AKpDUrhcz1RL+l/Vpr5yCD+6InJ4f1tfGeN237Qao/
	O2bkYVb32+q6toEQu2Eq/rlhZBCFLo5kvwvy8gtixKZvXlY7C9Df7GsPYmnzD65edjc=
X-Gm-Gg: AY/fxX7X3hrDvUpbpOkDypqbEBOXZuW8q5idIV8xCg3ncVx5l2meQPqvdkpiW1Yz1zF
	BuLhGbX0ZV6xjwQ8p/okNbKakO+45vUx3tQkxi9iy5Vht9bSjYL2HHy9zJ3SdDi9ygDIigEWop2
	Lo+qnwYhOFmwJBDyQ/2SvfIElGd4ZUvroyieJ89fRdjQTJpzhli6OjbndBbdA+qBGau3c+RvHDE
	71JMLKhV8ozMCdL5T7/6RKqqxA/YJB31y33Cri4cBfyTvfCwi/8BQTOFlz/pnAJ5V8m9KPoTOYM
	jnEEgqh/eUHfc6hxu3UkYRzii+iy5IK04VYHGcxAT+KnSgYivlYFLlmQ2evUrzSeqiOfXFXjJ3D
	/3tET4orciz9bjGRIcHyO3ESisjCL0iVNQl+c9tEeDIHgkYkJett2xExqjpgAfM+AVR4YPYE6sG
	EhHORfwEb2LA==
X-Google-Smtp-Source: AGHT+IHAmblDsUWWc7Lw8wQra+wzGGGtOdNSDrHzkr0iTOYEzvxfomHclZngzZVyVY6PMcP6p7yzfQ==
X-Received: by 2002:ad4:5761:0:b0:721:a9d7:297a with SMTP id 6a1803df08f44-8887dfe0aafmr179128436d6.7.1765771925333;
        Sun, 14 Dec 2025 20:12:05 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-889a860c642sm42392606d6.55.2025.12.14.20.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 20:12:04 -0800 (PST)
Date: Sun, 14 Dec 2025 23:12:00 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, david@kernel.org, mhocko@kernel.org,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com, yuzhao@google.com, heftig@archlinux.org,
	oleksandr@natalenko.name, bgeffon@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+90fcab4d88cffed6d0d8@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: vmscan: always allow writeback during memcg reclaim
Message-ID: <20251215041200.GB905277@cmpxchg.org>
References: <20251213083639.364539-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251213083639.364539-1-kartikey406@gmail.com>
X-Stat-Signature: dcs8u5mwhiqb5dknfmds4me7fdxkmsp5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6B78B18000A
X-HE-Tag: 1765771926-260684
X-HE-Meta: U2FsdGVkX19E/Bxx5l1RbiwfDXMDYMfG5dFEaY3eqwSGiyrsTKkcm7vP403ZOHLpiYOjGMUF1xR7yIMvNFknxIan2SSZbmQcnwVWxgsuLSsbBg5fQd0JXW59fSVM4WNc1Kdh0FloeMd5GMPwSUGH2Zsjh6h7fvlu7rUlu0DkrKbFwoUWGNf7HJKrM8Ie5NPJA4ZqvrynTAx/SuHUZ8NO7UB739JFNDaNWOJBPuZVuRvytpl1rtopxDXOGgMn1oPH7ZDy/eUEPwO5jWeIcp9dhT/iPcSM3Escv7oiHxor2C4tjxPuKI5l+bZXlPQcsAgxBdVcEDw3nNZ0xSpRFv44oQ2ZJ88M8lFAKGY9mxxOEEfVZksTFUX0bU8vgZhAek6bjeYPIkY4B0Kl88Qb/VUYKqcvjI7PFavp8VqrAqyWk6Zn2bXXTLw8XfBUk6VsGVGmU8xm0P+gEnB5qs6MmayH0DZMp2yb4XegRW/BThV1hyaBmETqitd6Ve7/zKxprJv+wfan8ntPGUbFBow53NJbGNC4DcRq0gGBLWkNM3p9FCi0rcgfxPBOLKNqTkZSWmFoTn4KnJX8UJvThrgGV5aDt8fgZJh8yRGws5WxHEzjP8Z0ZLjabcS0yJCjHc6iI22nqDFuQ/LH+y3erCt8MO+sb2B1Kvf3tl+yQOuJUSaWsbNhNtBE+QI6m+QxhHNQ6Rg0LJthPvrL3ELYNbFH5X6ShF94j/t2Qsf1mk/HKnEx49jKEW6RGR1bhzyaCbvI0qdwvI3gTbuqjPDBC6aw/kbASjzdHADdwHQvES8lXdPPM6ruzcO8nU4IDJEPDovtYX+VaruFS24gufskZ/tfZhLxZwHB2+hQkBXf4cpKrv7ROK7+X9oCEahvHF6Bu08RmX1+Vkm/gen3zsL2zKo23fwJHe4aDSD36/aa6IWQ4ZGZh3p1eNiI9Obb04V6QSC6EVztGE/MkPXdkQscZahR5Pe
 PPl6wFg8
 qqSD9vf+CJDajbFk3GtcaEvKwKOmQ32Wj6hMncOy66cDbKyfgcmPmee6uY5DSs5I5Y8hDEImx3vmkh35IFDC+fNiKc2BUmJh7jomWNXP1XO3ImWcSIgpN//bn5ocTuia+nIrAo9n7Xf5VSvvrTKzkfsHma2ePhR6mL8UimgJGHxSARYDioEQo8oNlUVw1dXTCqsB9TYbaH50VhSf77KbskeO7IbmYTVB8DPP49wc2XAKlRL4trqs6UjomfafNCEcgoIjTTA4JRyMqZXoRABaDE1NCEYV56Sm1mVEUV674SbBfgIMT5PigQ5QULighjSYrbYSrLk8oQLvMqA1PIfwWQkvXQ7xgh1ERDBqEIjA/LtECla7EpBlTdV2dJu3/IABsnU1X/2qqPioYu7pMWV4dyBScM/dLJwfINjKjXq16kj+fmxlDeHx4yHzj/ggJqoxP/KhSxo3LU89MhTUJjPKQ6Lm8/w1WgLOzgjKK3IQ/U7Afz9nWMYl7UuyDHgttWKTiG7wD+6XBvO0OqlgQg4/c6sbwrSd+lIC6PWaFjFu1BwFAz1Ag8PJKF1eZPBhs0U1uRqucGKf8hUn4q59ME3gZTrdBFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 13, 2025 at 02:06:39PM +0530, Deepanshu Kartikey wrote:
> When laptop_mode is enabled, may_writepage is set to 0 in
> try_to_free_mem_cgroup_pages(). This triggers a warning in MGLRU's
> lru_gen_shrink_lruvec():
> 
>     VM_WARN_ON_ONCE(!sc->may_writepage || !sc->may_unmap);
> 
> The warning occurs because MGLRU expects full reclaim capabilities to
> function correctly. The call path is:
> 
>     mem_cgroup_resize_max()
>       try_to_free_mem_cgroup_pages()
>         do_try_to_free_pages()
>           shrink_node()
>             shrink_lruvec()
>               lru_gen_shrink_lruvec()  <-- WARNING
> 
> Unlike kswapd or direct reclaim where laptop_mode's disk-saving behavior
> is a reasonable optimization, memcg limit enforcement is a hard
> requirement - memory MUST be freed when a cgroup exceeds its limit.

That reasoning doesn't make sense to me. Reclaim is always in response
to an allocation need. The laptop_mode idea applies to cgroup reclaim
as much as any other reclaim.

Now obviously all of this is pretty dated. Reclaim doesn't do
filesystem writes anymore, and I'm not sure there are a whole lot of
laptops with rotational drives left, either. Also I doubt anybody is
still using zone_reclaim_mode (which is where the may_unmap is from).

But let's not introduce more inconsistencies, please. The only thing
weird here is the MGLRU warning. What is it trying to assert? Clearly
whatever assumption was made here has never been true.

And what is the zone_reclaim_mode (may_unmap) assert doing in the
cgroup limit reclaim path?

It seems to me both the warning in cgroup reclaim, and the goto done
in root reclaim, are kind of unnecessary and gratuitously breaking
both laptop_mode and zone_reclaim_mode - obsolete as they may be. But
why even add this code?

Can somebody with MGLRU context please take a look whether we can
remove these?

> Set may_writepage unconditionally to 1 for memcg reclaim to ensure
> MGLRU works correctly and memory limits are properly enforced.
> 
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")

That seems unrelated?

