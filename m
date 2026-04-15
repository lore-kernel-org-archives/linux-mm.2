Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 549AEF41987
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA55F6B0096; Wed, 15 Apr 2026 05:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C8D6B0098; Wed, 15 Apr 2026 05:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92A66B0099; Wed, 15 Apr 2026 05:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9462A6B0096
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:53:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01FB713A989
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:53:18 +0000 (UTC)
X-FDA: 84660327318.02.B70C035
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 192AF20003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:53:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FtCsIPAs;
	spf=pass (imf03.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776246797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jl2opwE1RDHcRGVmWLd07hWifPyRG0CM/7HsKxadKT4=;
	b=jfwLq522MSZoha8ukhf3H0ivDWX9t7jrT9zQODgOo3L/5vmxB3ZCSSvIjUc7ECoO4KhiBH
	jud60EWi0In9QSO7PliMcrRLVRNFF1s9p66Ld93+j+jyZOJIGStZvhIYAdjxYzAXAUduxu
	eHWBqzCT5AIRYLOgQflktpCmWIwR6Ps=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FtCsIPAs;
	spf=pass (imf03.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776246797; a=rsa-sha256;
	cv=none;
	b=l+653W+QXy9hKynBrc6WPi6TPgFALENv+LEU7hj3UY1nuAVe10sBeMWnDg2IgSO4hQGRqg
	93YcHNgfxb0r50s+sw6d/qGl/BuSbo//vt0faqAo36ZFfDHGIJNVgesEoGQheZoHxNGqgD
	czs6GrETQFzQ5rnSaH92mqO67VYJYtk=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488ab2db91aso101628885e9.3
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776246795; x=1776851595; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jl2opwE1RDHcRGVmWLd07hWifPyRG0CM/7HsKxadKT4=;
        b=FtCsIPAschXlhv3iH7JyHD4KCd66vGTQOxg6c2REEUc7IgqSEhsTwtTDBZweb54Xye
         iOYtFbiknPVVBehxClhiCF8a0PaGzi4y0CaF2h2oTAUxOpxgckX6qhNHvtqDiBs8Wmkv
         Ehb8Swo6WYBfeHkXp/jTiy5bpbO9AWgYX3iEyRDwkdxC+VHR1s3JlKko8YJuET75c8sf
         AnPIICSw4/VlT9hvusnbBIAWEuLPR9ML+zJ/3MyxOV0HG5FwXrZKFR0tIAG2HUedPylY
         nxWAi7GDhLm6qq7SnD+dA8kuqNSm1POX8T2zBoSOm43APPQp6AtzWApHm/wYx3IdPIXZ
         HGzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776246795; x=1776851595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jl2opwE1RDHcRGVmWLd07hWifPyRG0CM/7HsKxadKT4=;
        b=edx6z2B4Z6sHpWeTM6/JvgAzcQx/6qkjj6G85PuaCYT/ZJ70yJ0Qz/lM9DzD5hgMwc
         DQtKnpEVt6IZaJRpy8FegBP9vD1cebfU+euhEIudu3ZLYsuBjF2Am0w3i9iiVRogALVD
         7X4mMkjhrLrGvqZNUhV4xV8MyXVM02Br6FF6as0DDe7eWwrBsGYSE1516Bs0qSt0tPTu
         UsEd9SH2j0viHwWthm1QefxZlbzvSjMgyVLCfYaDneSD3vlec/PWP4TxAnmh3AkzouJD
         FYxGkz5OPXvTBGjGvlYAWBCU8qoeW09UYzGuAScHBLguc7fA5akT1f781WCVYcvXUQKF
         /bKQ==
X-Forwarded-Encrypted: i=1; AFNElJ/YqyCf5zQl5QvQ7imPAW84Xi+d0t3vLX076hdoG/N2j/+sc1LWYWsiFHFx4WMD77fCtEwlAraBug==@kvack.org
X-Gm-Message-State: AOJu0YzqX2+bvR0X+DODgxIi5bolmCX2FDtyNCVKlYD46uNlnFDIOj3g
	42ftNvfX0YSDzhmUomRkHbuDHO9JkRBEJhI9wWeZg0HE0s9DZhNaBbnta5vyMHMKo5c=
X-Gm-Gg: AeBDieuA3R4Mgk+bUTN39b+WTftcVR3kC97Qybb6+ACs7sklsZygnYkIPmE3pav1tJc
	eIjc6h/UV2bckSUVLK0Dygju2dB38gGC21+nGJ6l2e9AQmUPJvBAyGKKa6MLflzM0uDYlr/AiYd
	LhCUVR6Pc4rf8YI+meUsp+Mpt9L9ONTjydlKyBuA+O5ISd2cptVZm5Sx5czv28osKCW22+L4lBp
	ep30WNh0FeE2L294SSzSioposljhXRL9upy8oHGoaSpFuga4lFmKrmNumN26gFnscmqDwWXzxIR
	hBDgSKFS3tLNSrQqCweA0FNKbcq92UpmjLBFcqE+s26meNhS/xfoQ84J8PbKTQDJsXq2Id3FCx6
	b4OCwTqVtHe4HV2p5EtBo7vQXtWqJz32y+nh6NxK7pFckLoMFLZNK8Qln1Zpays1FzW2fN5MiD3
	Cml69KXaeBxCqHhc0iXPp8CL0qyBi8U4FqE5h5C0sB/qJD73qhyJtkXA==
X-Received: by 2002:a05:6000:2010:b0:437:711c:8754 with SMTP id ffacd0b85a97d-43d642978e4mr31875774f8f.7.1776246795396;
        Wed, 15 Apr 2026 02:53:15 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3d6409sm3838343f8f.23.2026.04.15.02.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 02:53:14 -0700 (PDT)
Date: Wed, 15 Apr 2026 11:53:13 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: ranxiaokai627@163.com
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org, shuah@kernel.org, 
	kuba@kernel.org, hughd@google.com, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH 1/2] kselftests: cgroup: update kmem test tolerance for
 multi-memcg stock
Message-ID: <vjhou23d62pvtdqsan2nrlldkwf27qchpfmzf4yoetqn2gdhbj@cfiuqzzotbxf>
References: <20260414110524.2414-1-ranxiaokai627@163.com>
 <20260414110524.2414-2-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k3iorpsupp5gfcn2"
Content-Disposition: inline
In-Reply-To: <20260414110524.2414-2-ranxiaokai627@163.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 192AF20003
X-Stat-Signature: intpwpz7psosfsbiu8o4pwgb5txwg776
X-Rspam-User: 
X-HE-Tag: 1776246796-460492
X-HE-Meta: U2FsdGVkX1+bwfZMgsByIx1ef12XyXq1K9zFnwkeBKo/rJzy1CehDSXmONu62kaVO33gi7q0E1XeMAdJcokq9rXtK6RwIkqEUSvb+F4Dfu7YaGl2/f3ligQgNkSobsohEEev520K/iVHOtwXPstCafuSLZaLJSKiwj7BRfyKgf/atUGPMFUnHrej/wd+3JHJDN4A/BGvwd+iRlZt8jYyjE0f5garTnjM+XUMrodqNYEOnaVoCO9g+5seb6k3R5jk14+mis+hln5brfSOd0wKAQtf9u4ojmnMmgNpYPATcrMiAD2ZvfZE988IkKy3n58o3uuA7EH1Yrj67Ai6tJpGSfiCA1eit9Hk5fPikvtOartYiirlJrHLqllojyNyg5jbLXeJdGaOUDPAdx9arQ4wtwQS5Gcgfuk2L3tShfWGzC6enqFBecaXhH40j+cKJ5zN/JAY+5V20MHfJyxJ6WdiRTGliD7pttHyIlRKGRzi7N2NSBhQa66kyFCHdBMC7q/X9Mb3WGnMuZudmoqlttjGk8SdobgzkhabXpfnMAa01Sl/AsRUPxgRF1CKza9O8Lj1SvWA0A2DLpOb2dYOQe7Wm6KkNqq6gxroCk4TKt43bRBFAvTlOtmRf79Vmai31py5ZKmTl44R+SRqbBgWeV96YhL11AFPx4pg4PpS+WZAGCPubaNlkDuB5a+d0f+V4RY8lH1TIET7ku1TyqhmcmseZF96/y0CjJlEkyOEOaku6qlyFGQHYaF3/hokAX9NBnWdNb29iAXR9xA48afKGrRwEevVI0xyKna8lVkFmZ4zlM/je/rdrplyXX6KWMKopU4FHscBOVDYDLfaMGc61fFXiV88kEcc2yqY8qqyE8kzsZKHB0fKxSFb1ea4oLq7s2dm1+bhD2j+pYt4cMQk3cFygd/Ncj4MIkVCduZ79LSfhZpEKyhrZLKA5LPCMTo+GO3se6oddL5Whd3T1FNh1eU
 tPaXbH7Z
 j5K0N7wk2btMijfXLLjPR1nDjD6emRHAdc9m6oEWew6NJ6ZZs8q9PAVFILQiqj4Fm5iNoXMpaClCEuGSyYiGNy3DTiAezlVqPKVHFUFK5pE6Z/fTa6OwCaNZQaYxVCWiUxDnnKbc61MkltTth84Q7n03FIpHmibEPoSSDB48hmNZJsvoMHsn9tYqcihM+Ek6VYHExEE89tsMOpDchkaIZbi5NfUdw7rStlMkt5kCOX8iMN1UdaYNbcM008vZI+R4+9Jo9HQGna7X9Vkr6uzI96+heJA1+EOORtvqN1TxqF5jzKFZTXlhmBI/lmRt9mymbFWCR89hjdd9Lc/VjXEWjkekb/0qNmkkzuuRyii0R8sjPKE1ziNDLemkN13u/lJ7sXHVYW3stZOg/sj7/Ra79b/FN1jNagxqpzqTrjyAy4pfQXPypnqFNdZkG0uvj6vYWab6iWOWRiApQD/jbdEg0VjUdExPq16LA+EUjjuiXTtQVCJxNaoNTL4QbMlPpvKL63NrQlQTNdWCFh5LLeli6WTzam0f/Nx7CsjMw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--k3iorpsupp5gfcn2
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/2] kselftests: cgroup: update kmem test tolerance for
 multi-memcg stock
MIME-Version: 1.0

Hello Xiaokai.

On Tue, Apr 14, 2026 at 11:05:23AM +0000, ranxiaokai627@163.com wrote:
> Fixes: f735eebe55f8 ("memcg: multi-memcg percpu charge cache")

An interesting catch.

> -#define MAX_VMSTAT_ERROR (4096 * 64 * get_nprocs())
> +#define NR_MEMCG_STOCK 7
> +#define MAX_VMSTAT_ERROR (4096 * 64 * NR_MEMCG_STOCK * get_nprocs())

When you touch this, I think this could be factored into it too:

+#define MAX_VMSTAT_ERROR (sysconf(_SC_PAGESIZE) * 64 * NR_MEMCG_STOCK * ge=
t_nprocs())

And given how much the selftest depends in this implementation
detail(?), I see that there are other selftests that include directly
=66rom the tree, I'd suggest also
#include "../../../../include/linux/memcontrol.h"

and use the constant from there (i.e. move NR_MEMCG_STOCK to there too).

That should make the selftest more flexible, resilient to future changes
and it'd document ramification of these constants too.

Thanks,
Michal

--k3iorpsupp5gfcn2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCad9f8hsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ah09wEA3WEcFRBjif8H4jLqnOLn
ZwnKif6bna2CGogxl/N556kBAND7SAIiWdZTXcOAME4PmEgfWjWiWRDi1KSjBeeX
qmQK
=LmmD
-----END PGP SIGNATURE-----

--k3iorpsupp5gfcn2--

