Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A9BED5B857
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 16:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29D66B0006; Mon, 15 Dec 2025 11:28:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDAAE6B0007; Mon, 15 Dec 2025 11:28:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF09F6B0008; Mon, 15 Dec 2025 11:28:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE3E06B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:28:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 854C51A031D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:28:47 +0000 (UTC)
X-FDA: 84222239094.19.46B87B6
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id A12E5A0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:28:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PL1JWJNK;
	spf=pass (imf15.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765816125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWw+tWmkHo6tPMqmZEk9P+niRGJoCGV4ZzodtDdGtk0=;
	b=CcPGc4o19hZatODRkJwjcjQwfE49THxXGbIrTyGgc/uNtmA67/AAt4ReHKgED+0ZAbXdWM
	Em8MQXRPAFBGAooouGQCAOBWQ6WXGDCJbUich+N6OUqwsY/fBoR7jLAOznaQV92qaTXSNR
	tqZNfbp6S/PPo3arz6m9+iZYhnp2674=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PL1JWJNK;
	spf=pass (imf15.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765816125; a=rsa-sha256;
	cv=none;
	b=yiA2bLNtJuepdilTxSuqvo6yDppfeD6F6tHcmp+26Cf1pY72MTCrPGyzod6yzqOQHQiqI5
	ehGirQuLyGEtLMJz6sbK50ElutlSFj11dZs4M82vsRrHrI89fLxHFYBekB0CiwP9b6auNQ
	bt363+O2wQlq7yOLAmPNtaSLYW1QSpw=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42fb0fc5aa4so2581145f8f.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765816124; x=1766420924; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TWw+tWmkHo6tPMqmZEk9P+niRGJoCGV4ZzodtDdGtk0=;
        b=PL1JWJNKPm7R/Y2eiOD4LLJoJ5QzVEj5stoqMIR6Z3NBJUDLD/3841TaeJLvPjHzWw
         aNJqpGbtIU3HK0dvPcHSMTkNjMmcuhD3XAkmuUe2+x/Uc6ESpdJtRiry6SifWj5aZuf3
         zlwEeOIj3AkQ34X5yUVa16THF0Wd760oBjshrEY+2m6+Ao4KutxJgNWUfjDbCEBBFAgV
         XvuFegpUqZQ+j41jygatnQeJU6FdfY0jDx7bCqOboorWtwtQeb5GLmrfdiYpn4s0R1eR
         Xs3+fMDqLr2UcJAUF3Iri3zWWP27QlYIv0quXTb/sJ812uHGNSAxPi+dCh1XF7Zc/BI2
         gDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765816124; x=1766420924;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TWw+tWmkHo6tPMqmZEk9P+niRGJoCGV4ZzodtDdGtk0=;
        b=YWGPLqmBa5yfoNxdU4N5diTejnXsG98MbpcO41wzfxLBYsMI2O3CAlJrQzYTFOcbi1
         m+W0k2DfrYBcVbRRjvGK42wOpsBc5RAxttlB4HggUgywYv56MiGYNBvqQ1t6X/vq8KEN
         5FlYpNq82vT2RXppnWuCyGTxpaf6XKt5r7bAZbEzpZpB2kLt7Bkg6v/mxHZsVdaSdPgk
         sIgSgU0jPHn8AtWP1PwIzzB61zQf9XIH+PrBrsCpCln4deB2LO6QaUKIxT090KV5OV4W
         Ks7bG8VPrYU9Ft2ncXFyu/vqIAoZtxRb2/vspY9RHFRbTKpo+6YkaUbO0Q6BPT9l9GNT
         a8VQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIHjMFrFOwwCwyovJupEekWLvGMyueYvyXNIb9vvh0k/aswK8+bbIQ24/OWXAOSAZuL08yu48+NA==@kvack.org
X-Gm-Message-State: AOJu0Yy/WM7XxfN3Y7/HP0NQohf9wINIBteMnkEwtCG+NkVzi44WQP+x
	cSE7IVMbJt26Ub5imgD3xDhdYCBZUb8lwvWY+NPX7wJFUbXueWJqtuGNvlKgD+gKCao=
X-Gm-Gg: AY/fxX5d8TZ+NrlD2l9V5CR+pHYQzNY3Z+nZjDGgD0eBMZ4VGStX1qgeArDYHOuo7Jd
	E9L6h4hjukyZ0SkzkD4R1VcV8sdrn52oseu3J5B3fAcOiQiXQR19Z8syLh0+ovSknVMQUq6zFpL
	tLR5QGWTU2Jdx5K62+sYMsVvFiOBdYByqR1I8XpvOGDsKVxytgEUnmoyRakg6WYDhVjBaemTzjC
	6m/vhMDlAH8IAuq5V03B+6jD+WLPcw0l4TQ0uY3yRaIme9nXafzyQmpJ2c02rgppzgjW1ZFm9AT
	6EAzJjuVE8j2sytd7Fbv6QyOUCydbtDqEj1uNtpkmlkZpPQj8fo/CI5Kjsu8hTTBLUHQ6Ovn25v
	UpPS8IaTs36zFcnQQLZ6JOkSgqPkRj2Ew58ZUct4no0NMIm9Idq2dpneOsxbENF97fBloaH89h8
	q57u382Qfy4+aYYo9DUmp+VzlBF2OevJcOwzf2ymc0jA==
X-Google-Smtp-Source: AGHT+IEWUVPMrA6Fi5wvb0Db1pxM3XzOxI5IqMeRhxio+HMtumGqZc07ye0kb4axZ8m9cm5bX784HQ==
X-Received: by 2002:a05:6000:240a:b0:430:f494:6a9c with SMTP id ffacd0b85a97d-430f4946d3amr6708612f8f.17.1765816124058;
        Mon, 15 Dec 2025 08:28:44 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-430f42a3290sm14751671f8f.17.2025.12.15.08.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 08:28:43 -0800 (PST)
Date: Mon, 15 Dec 2025 17:28:42 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, david@kernel.org, 
	zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com
Subject: Re: [PATCH -next v3 1/2] memcg: move mem_cgroup_usage memcontrol-v1.c
Message-ID: <oshmc47mt6ivnxcozgztsltxa5enqztrsyrk4ph73yfbwigx77@k3t3vhni5gvq>
References: <20251211013019.2080004-1-chenridong@huaweicloud.com>
 <20251211013019.2080004-2-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zggmhi5oxztkuphy"
Content-Disposition: inline
In-Reply-To: <20251211013019.2080004-2-chenridong@huaweicloud.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: o4hz6sjmzzbsanmwa46r71aohuy3zx5f
X-Rspam-User: 
X-Rspamd-Queue-Id: A12E5A0007
X-HE-Tag: 1765816125-308569
X-HE-Meta: U2FsdGVkX19WN/nXZ2vKmYCs2qg8LG5uVwcrQhlHgTIc2a57NMtVg753Ulpv57DBB8vUUh74Dx2qp5t5wZVeWtN3uRsAhT2BQDvxYcl6AKMp4gOEGhpHDwgq+PT++tzRWUugtvFAQRKdKIdiwHQ0/nVniUaArjdR/ZSonEmJx1/Oe+YbU9ng86EKwZW+vyDVjnDct+jjKpSPXxFfLuVhHa64K3cKMDMoEOYiHfpcJT2f5VEeOQmFCw/+tWSUoLi4LoYEJ8C6uZ7KgoU15ZkaFoUYmTTXBgc4Thhjtbved69Agl/VTC8X9aOVFY4Pzyn5K53p0/DiWMPDOMGrW4chxLVGF8TGAvbUcoc12Eosjz4QCn60SAJO3LOGjSqI1jm5mNlZgNfiwdQ1Msn78InM6fWwklIXktMqIOWkbX4vP8qkkMdwn6Kx1RvyvVSdwWl6q+kZ5YsO+DDFpJDnLwNromHUFJDWJenu4r29in5UntRr20UXOlOK2wr4hIvcDJUzZZYu2P9C4vYkYDpaRt4n3ib31E309DKqxfD+Uhanyf0sWzUGOZseOovca3xwIB1FtcFU71Yv/toIT+mfrs92zyhMeOZQSpsvrZ05DfSiYHHSseAUpHNqc8rqugKgqGeqE3EPxM6VNjnrIETFj+pndTN6tjpGmIJ3adivgRLmI1pS4wLP7k0AlUxEdmJxmP+dsUjVA+UyTNXTPjyrVEXCqYIk+FODvLBj1Tm/kvpkCi0tv1Sy85BZZ53VopgMs5nCJFIzgay/C2emi7nLiM3/JgWpqAg6rP3Zc/AkvxIYsiGt6Zxl2FJ5YD5q2DyOwj8M+oa/6YlDP0gDyhnRQycOzFg/yN6iek2GsWxbej7mgvvumQNtSoSAeT+j8p0lT/HJiP9bfmW8lalOmkByU2oE0y7L5PALzLGOlUEZw0tpUNNjNijX7EEBQEl81H6HxvKrfQ65UiTBb+eptoz/8IH
 /1s9I7QM
 iIpe6u7s+trKOd+zHgkstuIbCnwZawsviY2ge4Mmo3N5Romc17EJdaD0xxB66x6Nkj9ZQ+WoZSFalhRhIVmu4AQ3Dxgq+zAUX8FqQwb1jcxSZAtQRpQhf8WqMRaH6UsSfn4zn1AberTR//nzG6CddS6M1vMIL7nUASJ4kJgDA4mYhOuz0LXMZAkBWq6NDSYGh+oqIYzOHFgm9jYtzBN8kTfehdaPS4YMq5wG7mjEDaZZT8+EB9rgBOUxMzgfnJzw/CMgXsa+lalq+I1E3f6TbqPzdNv51+Q6viTW/l519atBPSF3pHi0I1E9TrEyUiEezjYa7pEs62PHbRXxnzn/f2cwr78LwwQWE3HLdfRBZp3GTP6eQ5PQm6ZkLs2nPeFNqMceiYxd+RQRN+2TeIwRsYTzDAiLMIjgpFLxH2EPBXhbQMREGWlWIgsaNlJdxjdKRj1jf1cr8TCNaSMHbLwSrJOETVct7c5XN8ru62ZFC0tj9C/43FwZ6xbv0jpfPB1xXhy49C2tsa1nens6n8AfqDnq7y5ju/ygZ4l3Ev/cCG1H52eN2fW4bmRcgFQwwDk0squdak1h2CF0fGdDTErAeA+3nLaj9h0X5TBbP+5kfaGbg2GjxV8AIKa73P7YTlXW237ljqmU2CNtVwCA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--zggmhi5oxztkuphy
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH -next v3 1/2] memcg: move mem_cgroup_usage memcontrol-v1.c
MIME-Version: 1.0

On Thu, Dec 11, 2025 at 01:30:18AM +0000, Chen Ridong <chenridong@huaweiclo=
ud.com> wrote:
> From: Chen Ridong <chenridong@huawei.com>
>=20
> Currently, mem_cgroup_usage is only used for v1, just move it to
> memcontrol-v1.c
>=20
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol-v1.c | 22 ++++++++++++++++++++++
>  mm/memcontrol-v1.h |  2 --
>  mm/memcontrol.c    | 22 ----------------------
>  3 files changed, 22 insertions(+), 24 deletions(-)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--zggmhi5oxztkuphy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaUA3NxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AjUkQEA8FJ0+x7VlY8tI4SBieqx
WYg8Xzg+uuluC8BrRJr0YLoA/2y5h9r0vvPhhNNWV698p+QJS52s9tRUAMFU4Aiz
G+YO
=xXct
-----END PGP SIGNATURE-----

--zggmhi5oxztkuphy--

