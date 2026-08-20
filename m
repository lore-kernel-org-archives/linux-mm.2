Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A912C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 09:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DACD6B009B; Thu, 20 Aug 2026 05:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B706B009D; Thu, 20 Aug 2026 05:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1D26B009F; Thu, 20 Aug 2026 05:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7F56B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:27:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCA11A01DB
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:27:27 +0000 (UTC)
X-FDA: 85121119734.19.7EDE9EC
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id D78501C0007
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:27:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UsDwAcI2;
	spf=pass (imf20.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787218046;
	b=HlbQhm7Fkj71yeca4DVWRlynrdiSJkjONNH5S1SHhyXT68mRQhhGUyuY/Z+z0kawdyzqHu
	Ahh7JZn+Vai55qhrms9nyfGzKlNsFdH6x99exUu54wENM6SrH+5SYrnEtBOSiDSKxz8UEM
	8cfOChXpvqMC80vUiJcA4ceoj3b/jnA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UsDwAcI2;
	spf=pass (imf20.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787218046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMskdTdkeMRGiYIbEal35ckaJbDeYchkDIOfTGopKXE=;
	b=pc49zTwyJ0uCj15qN9uK0ggvzOv3dk8u6SPDLs00vzfnaefMccM4rb97qj0ZHxTniia/SU
	17xs4kMKR+nI+Z4nAw2ZKe/7Ho9pgMEgJj3P/8FK7Nw9MyyzceSOyZxfjF1A/uDwlNSUFs
	PiviewzJmEtzr0RiPnSrdF85EQZIRd0=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49558ce01afso15789465e9.1
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787218044; x=1787822844; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hMskdTdkeMRGiYIbEal35ckaJbDeYchkDIOfTGopKXE=;
        b=UsDwAcI2gHXlUZxndsrL8SWZpKhwgDHJTGa7QMaw/kQvcYOphAulT8jr/8AeRvQi7V
         jxSzR80kFE76FbQHuxQ94RGFt5B2TStuxzCjDGX/2MsICUeivQmwwubpCKvS1KhsfIw2
         zZ7cz2IBHPuc9zult8qB8OIGC4UFJQOjRLCxgaR2fYyQv+ysV6BDbZWIiIz7fy2UtdmB
         KoovwZpwSzkmiHZ2JL8MsYrxyeZflsIn/pbj7yT/ZgZVJA+LpTJ2ysY3W8S321QP9CB8
         zVjYWpJeug/ljsBj73r945WFxCAU2UDP9Ev6q417nYB37EcDvHEYxHYe7w6XGJcP0zuI
         1nwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787218044; x=1787822844;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hMskdTdkeMRGiYIbEal35ckaJbDeYchkDIOfTGopKXE=;
        b=rARM0MG/Q9aBnwEGuYOygYtViKdzvsfsiFSORO07hwVHfCIVWMeLMjU5gslPwKgIPZ
         L5NOAAv08EE3vy+gk4u21SYi5vixa/2sNW2KvJ7TrJh5RDaHIXTw95UOoo9fcLZNF2+3
         WlaSVMoUdsvAufsq7B5JY7IaDGCdPVc+ZywQB0ogAG9BTW6b06gvrP/mWfA9xhS4EZhv
         ilEY09Xcbc9T7A5+36LZLpjcUqpuo+PniCBSBMfnOvMuPnx8y0Qfk77ujojcYdJchS9k
         NQwYUM97hKPx2jBsPWVW6SH0FQvYgXzXAls579R8MZBmh7dq0oI+GHc0aNTms76xZ980
         4EDQ==
X-Forwarded-Encrypted: i=1; AHgh+RoAPwGPkga8+Bo9/nggOBkPzOc8MNmo5o7/cyWdg4223weeg8/SN1zk3BcmDyh8E88sXP/iVHN6Ww==@kvack.org
X-Gm-Message-State: AOJu0YzA1DQ59s+KXac4cKZW0otH//bPydMhJZsA+blu1evTy/S2RKId
	fVEE/6yOarghXY4EtCAmFmsXSFdxi/K7ZVMaYAqpmMEnLn3ITX3Q2TBSIhYpZawa/8A=
X-Gm-Gg: AR+sD10525fpcnBa3izPLBOmPPAxetvW06i+Twus9Vxdy2+niWhFbIbCzZIsT0XV+Je
	gPHP0rRPDFpy8POXyWzU2sBpcm3kes/b5iydThS0lc+CJT1QUeCs4mRZphZ6luNzrraxS1Alou4
	zDSr8akay3Mi7wxkVjz5H3VIoSnVGCm2BPMItLqHIxIMhrZA5YS/CJt+Rpf2vUC8FrkEjVx+LPq
	JmeTi7pLROv5iHImlFSivxvz5XlQK4L5DjXPMk2FDflu5cJ8mONno2Qcl7V8a8m7noAfdlaJV7G
	uPpLh5/QW3sNcGl5VuSBdDEWHG8mpHA5Z1Pj7ktQcamY7m5K17T2pVIyWFaJ3OwwcTQsZ7QfhM8
	se3JXTypppV8McPZ01Jd5nS5xiO5m+x4/4awNdwofjZZHoZKcetpTU9Rm4drr0OxQRBgrj4q05V
	pxH4A/z3W49IQjdw3Z+opaPJdnWgqwHt1ukxkJGQdRax3vjWz+701voElIeaWA9NI=
X-Received: by 2002:a05:600c:c167:b0:495:4d00:2fda with SMTP id 5b1f17b1804b1-499aa143546mr214370055e9.2.1787218044328;
        Thu, 20 Aug 2026 02:27:24 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499a9e805a4sm144983515e9.4.2026.08.20.02.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 02:27:23 -0700 (PDT)
Date: Thu, 20 Aug 2026 11:27:20 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg
 parameter
Message-ID: <aobIWjGwusjSzvBn@localhost.localdomain>
References: <20260820070944.31451-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5mgqyivtgswggrj3"
Content-Disposition: inline
In-Reply-To: <20260820070944.31451-1-hongfu.li@linux.dev>
X-Rspamd-Queue-Id: D78501C0007
X-Rspam-User: 
X-Stat-Signature: srjcbhoy7ecx19fpkxxyjkpuyn8n54dt
X-Rspamd-Server: rspam06
X-HE-Tag: 1787218045-639443
X-HE-Meta: U2FsdGVkX19O8Ga4KRR2ApAffixPCdKtKvWmQ3v2XFBgwVlbcxikxiq26SKj3cuwIkedLc11ks/sdHEBOyEHBOuGN8LhqEqc0y2/WMPFPbt1ucN2wHvr66bBjRbm0T/L0KTlKTvu+eM5KYnDOjarghqNNzdSecx7ZrCsG/kPkboqTZLS4ty7DAS0WIl7YMaK2AUYP+mie2OvdPld0v+HBM+61D6D9tUlIHRDGJtTZ/1nNt1r4LAapf4LAIsoTzupi1k6LLFzfDrUBcPjwz+rkcy8ObLd87Y137tsJj5oMX93IX49CcTbuyFRRZKafXfi8kvdn+BeqZj2o89ZUh7rp1Q2R3i/tHbXZPM5esP+NQJ6G1zQSfp0mdd7ILTNg641FItYBBqoJLVPvl+ZdNi0FUCd5/FyFAZcNYNnLdGXjAKbS/BKb63goPh6tLIH4v/DMpIalerSx1fK7ye0cLxM4424/AlJG29nUAkH1sUc7RHFSprsxgfOg1JVhaWqYKF8meaw2i4bR5QBJvngCCl99/3mFvzQvahNczR/xXdjem7qaF+7JgK7ULu0TDplwCXxw0XbZ1LjwYwiUZDvkGQGZ8aun90bGeDqzg7SBs2Yo/4f14DZ6K0swks0i52qq5T9BQSzmX/EFMZQHmT01/fsNVHEJp3ombq/zJCHueuQ1HUbq0b/P1WX/H1qxJfNy+5WQRfCDDovRvOIfy44IZCrO8iG98fgxCFBX4ZH6rxw80cMHFcn3pM9AXTRL81PaccF0zbCg837WBg+UZ7O6tI0TnikYKcbKquXQKTcVHW8FYG8ku5qK4Y51ac9rPHcOKyc0qMrlJlNiLmRoYRXUh2XdKsnmldt8ZFuQVDSFzKc6ncaj+OGaW2+lg2W4ckceCuXFwVuEXfC3DhSpGuffgQaWqJ7ZIwdi3tf2VMGkVtsCX/mDbr5zBcSLpy8L652tPULoo00GAZN3NgBNTA3rs3
 mpYZ1Up1
 w4RroYCn0zesNttxvOXGnt1IONMJHLwTyW/rbkT8QpO7LK3XHjCaQRcawYqnLdw6dGHnqgeKbAlNpd/Lp2623k86tZ5FtegchYYUY9Sekp2Uec/JtqKSlLt1PbeDCn65XyUakohXonZGd05IrVwGz35b/r5eEILfbe0HfOxfeCMADcUcebeup4zcdVs8f94lEfJgZWvlnGQRzI1cpbELKg4uiblRIBcR3VKoQs1N1QO79rTVZ1Ef80yLEJ6XwMPFSzHXyVRb6xCy7onyEG0MOH0poIt7vhEq83LGElvpan2qh2YvPPLU/GWF57v02iSOqVru57821WeNypVS6/V4OznpD1VJYO2yqbhZJkJv3o670G/fe9KoQwCauY+APAdHhbNoz9xSm+aTY5AQ3BolbCdJ0w8yBk79ijGLt8dXfTuYyUmDCAtqbpoHee4Pax7cDL05wLBCs4JZvx1yR42eceS927HT2hw3znPauJTz8e3tFrHJF7pkd/hu7a4Z0DS94xvN/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--5mgqyivtgswggrj3
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg
 parameter
MIME-Version: 1.0

On Thu, Aug 20, 2026 at 03:09:44PM +0800, Hongfu Li <hongfu.li@linux.dev> w=
rote:
> From: Hongfu Li <lihongfu@kylinos.cn>
>=20
> cg_run_in_subcgroups() discards its arg and always passes NULL to cg_run(=
),
> turning the (void *)100 from test_kmem_dead_cgroups() into NULL so no
> allocation occurs.
>=20
> This makes test_kmem_dead_cgroups() falsely pass without exercising the
> "dying cgroup with charged slab" scenario it intends to test.
>=20
> Pass the arg through to cg_run() to fix this.
>=20
> Fixes: 933dc80ec262 ("kselftests: cgroup: add kernel memory accounting te=
sts")
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  tools/testing/selftests/cgroup/test_kmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Good catch,

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--5mgqyivtgswggrj3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaobIcxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjWhwEAka0wkR1ajkCSVyjaiXDA
XIVViX0NbgRoaisxbd3m6XYA/0av7r0/ssp0z/21d6p1a6x5TWOMouSsQwmWbet+
y5YG
=RIxv
-----END PGP SIGNATURE-----

--5mgqyivtgswggrj3--

