Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E6B9D3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 18:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94826B0006; Mon,  8 Dec 2025 13:35:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E366B0007; Mon,  8 Dec 2025 13:35:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0CCD6B0008; Mon,  8 Dec 2025 13:35:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB9466B0006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 13:35:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C0EB1401A7
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:35:36 +0000 (UTC)
X-FDA: 84197157072.06.B963F99
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id F2C068000F
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:35:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZXFKiJUl;
	spf=pass (imf30.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765218934; a=rsa-sha256;
	cv=none;
	b=hmA7nqpVK7gmAI+eoaIIa5YSzET4BEM/tCl4yya5nc2LOk/h/wMmc7ALw23PQcUnpcLJCU
	8gFaPx9koB4h2TIJm2SU9O86vU3nqhWHFzYic2AzMyLfVEZfccLrDJr6JVTwYAF/AAGJHx
	kkAyZ3PsDbPYmmOZiRMqOYtxNsW83xo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZXFKiJUl;
	spf=pass (imf30.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765218934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wY2G3umTjO8QaTDkLQv7bCwYeE+8B+SB7EhcsgEzCs=;
	b=OM6fIDT9HJhSt3bY1eCAJtPYi61WQcPgd4Mb8NcYC254RnYY0efTyowOAPf1DDk9Hy/r62
	ZOtSRofDjlL3sOlrTwhzh7PHQlMsKvkBbadaNi3/73Th5hll7JKaNOND8QhU3Jfgz8fD7n
	MkJxRX6lI2bFSDQhRIN6K5jInFR+8Jk=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42e2ce8681eso3300017f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 10:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765218932; x=1765823732; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2wY2G3umTjO8QaTDkLQv7bCwYeE+8B+SB7EhcsgEzCs=;
        b=ZXFKiJUlCrqXqA8e2T1cWMRVDGfjjGrAzasbJa2w+iSUE9mXEiAsbt3X4XUJaRpdBU
         XtnOJTBBSYuFDbrolLTX/bGbUFya+BME7fmct2rN/tjUg/fIQpyQ0UaPieSvRJL9goGh
         kJ+YG75WiDv9UrlT7RlaNGQk/PZ8qp3k13/pdjIVF9MOJQcyi2IfXHh3KcSwwP9wasBT
         ecFvzF2qY2o+qmM2Q0JXJhxSmO6ZUA7J10+7LzHlaL3RLmUTDmvBRXbQd58sHXpJkbxp
         SW4RYXQjjgtX8SzTFdz599VIek1sQTON51utp+zOWD/lvDSYFKqqJY21fu22SuOfwQ92
         YfcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765218932; x=1765823732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2wY2G3umTjO8QaTDkLQv7bCwYeE+8B+SB7EhcsgEzCs=;
        b=dgpqOd41PNmyphgH1ssyk3FP3cLZtQqHZBf5TGD6PQW0FdCz9SkcDMkvra/Pke5Um8
         ycjrz9BF+U8TawmmFn2tWniGZRBEZxJN3Ufoxop/x8dLmIg9pdAYM30/te2GTIFcpkKt
         1RkcIjQp2xqIU1ulXYvLnK+T6hraSTDFJib6pbXV1pbNwswurYVDh5HEToZLMd4VLhTZ
         f9Ge5S2Rc8mPkEPAQ35mTEXuOCh1n1M3hFAupMppmgwjp8JRfBqN9WrHpTVBy9rvPWgW
         SVeOFrhPtTpwOn0+z5QJmsoyrVIMfB8UNKhADWEsMjiqErOVVUhnSgu9roZmbW8QbVOp
         QaCw==
X-Forwarded-Encrypted: i=1; AJvYcCV7X2AXjHTs5hTNbpBHHv7mvGAGNfimHbi9dnxt26pslfu1c7qlaDVLOnoP++6e/XFxpSwX1A3AnQ==@kvack.org
X-Gm-Message-State: AOJu0YwRfXwSTnK/HdzACPPEGFJIWduMb2Ov+/fUSDgsrln1DckqnztT
	I9QZNcpLCZAYrPI0LQOBKC0xgMa2wuRJBxD0ylrpNmcP1jwdEImYq4p47gCLzo+V84o=
X-Gm-Gg: ASbGnctQa4cPbJM3Iix0evvNUQvKf1Wf6rbn3D+bMKfbtLJQQqQmhuQt6X0dqNri9Oq
	01cj8LxQ1L+JOZjG3eQDjjPOvPi8f2F1t48EmnMWB7wv/I7rVenKOrWgu25EtktDcQfokvWf/fw
	0dAXbNa0QgHC/MKi1RNbFLlW2Dobr8d1huIdAdLQlk0ldUsCeUQN6sB5nHZ52edKf3zUv4Y2voQ
	KqHNupARmS63VMZeGOTKMujw7ibnI1C2BFF0MhQIxOad4fkkTx4+V1u5xjNlq1Oi7D1lwDEdKtJ
	b4VRiePN25eTdphlO8I1lbdRh1xvfD6MuNFcZdUPhm+STTAmLfcrO+3fqttFkgbivuEj3QBZ6Ro
	sDTzPtvaJxlZV4TVs2Tkzs3yqeuH0FSPwA/DXLv6Rp/UpL39KeZBM23+MAJMYHgRxcqWzkXKBNU
	O/iXrswGt6oBoi9CMHdlwQLZGVHpPT0dI=
X-Google-Smtp-Source: AGHT+IFG0X0Q1R93N8u/vWpDPDL2ng5Ky3tWYqQdQgUzDrHgsA9PHt4E0RmT1shTlNsMnNxjNNJR/A==
X-Received: by 2002:a05:6000:4028:b0:427:454:43b4 with SMTP id ffacd0b85a97d-42f89f56dcdmr8989533f8f.48.1765218932357;
        Mon, 08 Dec 2025 10:35:32 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7ca4f219sm25439566f8f.0.2025.12.08.10.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 10:35:31 -0800 (PST)
Date: Mon, 8 Dec 2025 19:35:30 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Paul E . McKenney" <paulmck@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] cgroup: rstat: force flush on css exit
Message-ID: <hjxarrg2jy6cyy5hptjjbkop76jmb6mjdcazlcyqe6nnaoo3l7@7amn6gdssmeg>
References: <20251204210600.2899011-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gmi5fsjbdr4tg4xt"
Content-Disposition: inline
In-Reply-To: <20251204210600.2899011-1-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: F2C068000F
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: acbketkt1yaneaa359sdeouuxeyt3b9g
X-HE-Tag: 1765218933-137613
X-HE-Meta: U2FsdGVkX19oFOvBkcCw9AAi8vdr5U/EXbSjKC1uDi3r3hVk6LuUa2uZwJWlt3X8/nHI3evIjUjJmlvB9NADKchdZvoRs3LdB06W47NS3qYUMCHGPxLl2V4mapztoqWAEE8zSrdWdPgsQ5ro0MoOvOTw/pqyVVsbylARhEUrAkyZ4zHblMDNUrgc2OyFzJUH4p8mnB5r/9132BebmGtEfuAwE/4dxMzfE0Gfptst1jCfKV0BJbfzN1cJrAhtLhZdvLzF1/skBK3doXPHp50PHk3kLCrYs6sqRiYBRC//LTcgM9yt6j6BZ30VCdQJ18+lVZYtpQe915C2cJjKBjLXsH4CmdAzLoaal4sef/bh9B7dv3vVREJOrCll8j/EWsmr2dqVm6uLRQ5wgSSheczr0hsGrongwdncmvQsFh/7+Gnz3GoPzr0fN4rT5eJ2gp5jyHzfgGtChwt/Pe2gBwu0ENyjO5Yc//sRhzhg0/GUJnRlTk22AGrSydxIdaH7WSqtXNVqccyAcEOewIJTuJqCW3a0oX4u4ec9qTM7aliEMaWa3D7wo1V27VAYi9052Z5ebn9PxHL8xCNs6p+tBafiGrCz+uxdyZoJ7b+TJj9/HhOgo6D/sF2sX/MWbQnQk4xzaMQIjK3nN22vLyJtBHIL2TTCNJHI/9Z+mgpv39/bzMGN/k2HlPcUKEbQWR+2QFJGaNfCQ/j48yUgKounxDaEzljTNPcc5zUE8Zwlra+o4pfLohdYeIfgyMd+0Q881GZVBnQiNi3ifJCGD7/hEO6q4BoZL8DnntwPKHu8VM5ZE9//BAxCYYSGE0DONU3mzMZWaPhEhOSnNWdEaICis0RGk4H/Rwgb8F1p02kG17FfNxXoQJ4/I6Rt/RLUIwxSYbIOmlopjVXJlT9Rs9Woh2ic+xaA/EweHwhls0hLfQuiw12IF99pxSvtNbtGZxVZWlnKZKYVKWmIssC6CyN814l
 kFkwLclk
 V7ygL2bVmpj+UWmiHF2Fwt4r2Iabr9YiMY9z+qFCsq/U7ULMPBDl0maozdWr85/FSgLXlWGRnyYW3hTra+FjzwDYTpx5IkoZFCCPab8fH78uncdgV4ducFSNwV+VOsmivasHmlkTCKlOdYGEPN1ciUZu+GXk6G6LroEO2GsiMXWD5SYYVKwxtmjkprsiwxKixLZITvVThgEDemSFl7uXXk0Z4G6UzMqZ25C1NiYsUv7f2mZzhb3pYvPYsRn4AUY1c/mkmsEXvCtgOpEoYamSAClqulNWUVbyLu76ct62o9jN3Y68ggwUgtmvcA4XejrM9ZeBqj6qBqaN9/Hy7xccxi8OevcV4sBAa/YU/GboUkZQMIXo4CnCg2usx65jMpzy80q7gq853GL1lmfnr9OA2cyN7aeBDv8wEbcwmORh+SNuuTfdomK0A8GBEog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--gmi5fsjbdr4tg4xt
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] cgroup: rstat: force flush on css exit
MIME-Version: 1.0

Hi Shakeel.

On Thu, Dec 04, 2025 at 01:06:00PM -0800, Shakeel Butt <shakeel.butt@linux.=
dev> wrote:
> Cuurently the rstat update side is lockless and transfers the css of
> cgroup whose stats has been updated through lockless list (llist). There
> is an expected race where rstat updater skips adding css to the llist
> because it was already in the list but the flusher might not see those
> updates done by the skipped updater.

Notice that there's css_rstat_flush() in
css_free_rwork_fn()/css_rstat_exit().

> Usually the subsequent updater will take care of such situation but what
> if the skipped updater was the last updater before the cgroup is removed
> by the user. In that case stat updates by the skipped updater will be
> lost. To avoid that let's always flush the stats of the offlined cgroup.

Are you sure here that this is the different cause of the loss than the
other with unlocked cmpxchg you posted later?

> @@ -283,6 +283,16 @@ static struct cgroup_subsys_state *css_rstat_updated=
_list(
> =20
>  	css_process_update_tree(root->ss, cpu);
> =20
> +	/*
> +	 * We allow race between rstat updater and flusher which can cause a
> +	 * scenario where the updater skips adding the css to the list but the
> +	 * flusher might not see updater's updates. Usually the subsequent
> +	 * updater would take care of that but what if that was the last updater
> +	 * on that CPU before getting removed. Handle that scenario here.
> +	 */
> +	if (!css_is_online(root))
> +		__css_process_update_tree(root, cpu);
> +

I'm thinking about this approach:

@@ -482,6 +484,15 @@ void css_rstat_exit(struct cgroup_subsys_state *css)
        if (!css->rstat_cpu)
                return;

+       /*
+        * We allow race between rstat updater and flusher which can cause a
+        * scenario where the updater skips adding the css to the list but =
the
+        * flusher might not see updater's updates. Usually the subsequent
+        * updater would take care of that but what if that was the last up=
dater
+        * on that CPU before getting removed. Handle that scenario here.
+        */
+       for_each_possible_cpu(cpu)
+               css_rstat_updated(css, cpu);
        css_rstat_flush(css);

        /* sanity check */

because that moves the special treating from relatively commonn
css_rstat_updated_list() to only cgroup_exit().

(I didn't check this wouldn't break anything.)

Thanks,
Michal

--gmi5fsjbdr4tg4xt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaTcabxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AjUwgD/UQNbUH0dTJn/Ak6ywJAj
LkSAHi07EwnjGVgZNMs62TUA/RMxBqM3KNIPKEcYvfDpyhH6tzQJOOgGI29G1Ncx
RiUE
=BgfL
-----END PGP SIGNATURE-----

--gmi5fsjbdr4tg4xt--

