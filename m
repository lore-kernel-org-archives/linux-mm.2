Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEAF3CD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81BC6B0095; Wed, 17 Jun 2026 08:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58C66B0096; Wed, 17 Jun 2026 08:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F766B0098; Wed, 17 Jun 2026 08:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2C586B0095
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:26:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34E30A039C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:26:15 +0000 (UTC)
X-FDA: 84889327110.09.38B75F5
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4377B2000A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:26:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=diFuttTi;
	spf=pass (imf03.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781699173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YBXCuE6tuFht3k3o9SLsq14tW7sWyyo0dU5FVc07Z8=;
	b=mDt8o7PH4aG0/Q/DB7FeGvVu5edSLPI7EJPK78Cb2qHOHHSS++xTJQioTYl2bxShxFAgNx
	W9Nx3aWz/gyjfjsPabXuwAINPoQePKyNHMsJ9rFhqDV9TvrayJNVj+v579pVrcPQ8FNYdx
	9jJLxwkSDHgDUDiucjwnx4w0T6DQLjg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=diFuttTi;
	spf=pass (imf03.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781699173;
	b=F39Y11qh5LRvOGbhu7B/TW2h6iV3XlvNlr6R8BfABlAYmHli4xoHu0x1KhOm2Bg7Fr5fL/
	qOTgQzDbVEOq56bjaGSFLS64SYfqU0Qbznrsyf7I7/KF2s6w7mgKOty57NwC0UE3xVMf8a
	0AUPTGKYHMecR00X5Rqi9fp6Vyv5t6g=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490c0c92cffso37968515e9.2
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781699172; x=1782303972; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3YBXCuE6tuFht3k3o9SLsq14tW7sWyyo0dU5FVc07Z8=;
        b=diFuttTi6JqzlHLFD+Ms7FlkPhdoscN+P1qAvBmIvC/eUpkphPga6G/b0UXIw0GI2y
         RI2jtFdO9exHVEmNZ2eJn5G5v6rIGWtoRog/zpGpYGG0xaQt+7ZpD4+ZuEcBMYkdc7FI
         gVWLv49TXbSS9A56GrSTb6BCJ+Kixc1mJica2nBuS/RxIqFiJiM5gTERb01TsQpSeqwu
         4+jzBaX/xfayh54ZHnvODxAE9C9Fxa7n6ZbKskwzDtgHJl9zVrKnVyxJoH80qz1fwTfE
         xOYWhZ/xKdnPUoRYMLJhRVpp4D3HebItjK0Smua0glAa9u6TfwjAAXfhbi3EblGEet7z
         wAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781699172; x=1782303972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3YBXCuE6tuFht3k3o9SLsq14tW7sWyyo0dU5FVc07Z8=;
        b=CvqLWYC1Arg6v8fereZwIMdVO5ASj0Vi8z7zXWnGymrCEv/Pu677q21fuczqIoP09h
         sBwpRvKb7rpquLU7mOFfENcPtMCxYhbS07hbx05rd2DZ/JEHUpTBk2oINyys6WWOpRMh
         UR3Rn4nZrUEJe2Q2DsO2g+1qOau8zbst8Tsel5Ck6qVTVKqJkszuH7jPqpms8VXFcdQR
         qCTgSt3gh500g2SrdFlxR8lkOqjpsjucBnqHIDk04UNz311c7YpXf5U7t+Ae6GQKZkZ8
         ISea3dAblj8k06xQRnTESWs8gtzXEVZU0fvkvZ8t1tkeFu3bJlp+XdPEmMYunzCHQJZJ
         LZWg==
X-Forwarded-Encrypted: i=1; AFNElJ8l9TIUz010obguht8pjspuIqG3XoY6LN2k4Ws5GZUVEPPkNAyF1QgE4ac7v1zdIre85mqLAX/m+w==@kvack.org
X-Gm-Message-State: AOJu0YzB79W1/3bDqJUQVN1YiUjI1h7yF0Ow/Nk7+4KvgMj6I3YDdC1v
	rdBSJjjYvKdoVPEm0bXJIP4aIZImMX6nf4EehzPTouSjujcH+1HMANxuX/7dviQiCss=
X-Gm-Gg: Acq92OENwEWczCJn3mDBEWOje8Yh+tLjoaGxBJN7rZpMZUanTtWZ19EpaiBAZqijeSn
	uVjqxr6ykWYR3MOx1Oj4tvNN6zXpsioakgrxplgz0ibIziDB9miw1D94xSLGTmPtm5bKWCFtPZE
	pqWZqj00s1c9itk/x7A6uIjw1XpbIAD/r+CkVCySSBlraN1R6N0/ou7IwF5bOFPho2eHwJgD2Yu
	EX9YwfbvCxANOS8JYy/5xx57RKws2aYPCGK25C2sUmqN9W4D1RyeI5sevRIOtFeQmSDoGYJ2n51
	rXjP6Md7Ze3bk+xPq45e+sUg+aamnKbPMFH7ZCCqXX1EOHNDQ7O56SyauXo/fmGa5tVfa9gP17b
	Cb8MlFGxgJLXQDoinbjfuSzWHqjD63nTqUfMMH2TvkL2ZOgBB/6J/dERUmXXZCHKtYq8KjjoyzN
	FcbtwsyNZegRjmRKeXBg==
X-Received: by 2002:a05:600c:8b43:b0:490:bbc4:76a6 with SMTP id 5b1f17b1804b1-4923341fdb8mr74870325e9.21.1781699171664;
        Wed, 17 Jun 2026 05:26:11 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa3abd0sm179575345e9.1.2026.06.17.05.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 05:26:11 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:26:09 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Li Wang <li.wang@linux.dev>
Cc: akpm@linux-foundation.org, tj@kernel.org, longman@redhat.com, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, shuah@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v7 8/8] selftests/cgroup: test_zswap: wait for
 asynchronous writeback
Message-ID: <ajKLmjRIjKTNKGTn@localhost.localdomain>
References: <20260424040059.12940-1-li.wang@linux.dev>
 <20260424040059.12940-9-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rhxkikwyiqml4ro5"
Content-Disposition: inline
In-Reply-To: <20260424040059.12940-9-li.wang@linux.dev>
X-Rspamd-Queue-Id: 4377B2000A
X-Stat-Signature: z5zzn3mq7to83k7hjut5hcasbg619ofp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781699173-545497
X-HE-Meta: U2FsdGVkX1/fUgh/smDhe5pc82fM5lFkfKgRuzvgyvydvwa2T4E9d+ahWiK71csuQMBMoPjy5MUODeWnp59b1qOu5XVm5G+XTwzbmFA23A4OPJt2P06bgenWihD9y9Lrk3PwugpO7UHETp0VFnEUGGxC7VHj+g+eI3J0GVgqsr3VA1cMDwIGnkLAfuv2gwV8P7Bcire3KFZUbECPAniwuFR95sqTzF6jH7Us582dQzj7PnLoA4dC4sx7nGW/waumgbFMrbygzW+1awsm3mIes0ds5QtRBtiLxAtCIO1/o8je3BJYQ8plPMXU2Raa6Qwf6bUk0D3cKpa59Tk9xNvFbKggoaJ7zJgIiou30mbT8a78lGow90hoBgJxfTWNHOshUL1K2DLHFVhYsC8oPirJ+d6wX5fPD1jyywKCqMLNu5lyOzeDIgXQbmhuBzhwBqokTrhsHvRbxo4hlb+BzY/cKC31H7vT6bETu6K0EtImW+vBbcuveFiSMEW5zpqcpoNA4LkgDFbjElD0cGvy2OGkFt2bqfFojKCiusunJtGGKt3FiKhWBaomc1vJ7atFGF8zfUyyhSWtUEntbjAORP87Q//nj+7G0dZ3p15C7NskUGa+X5jpdK6dj9VpHLMc9YHOqC9NDgBgrjjSdT9cs4nCWNYRv5xlS71tDGbX2S+FsRCnWdnPQ+qMhihpKnbfrYT8igRC9oadGgQOhlVs6wU6HXII9w67/f3F1bph+MhF3mjDTbBqJPu/Iye1UeXWbkq2BcB6uMA8O7PK1YmgRg8VKPmx7zhcsFEfFxpAtf8feUlmp8eHymlrTFzw05no2xGQYOL9dMm4gFGjz5fzvB5b02Bj6S5YrQErSspv/hYv2yscGVAbU9K/V2KbeEBzLFCLKT6GWPl7LvDFcyk5KMqDH7U4/bbs6KJKH9JHu/nUuyHKR0oGrVw9iquYGcTTzAeFtPyHdCYdT5RhFoZOA0K
 9zFepibe
 kv7hCBgNb6xzlPX/5GsAur5zhePkJTAFGE6VO7KAs3+ppVk8OWNIs4pp7QYE1g0kFNhhZpy3mnyt06hWW3Xrka4qZPrfK9Hw26lCrZfPliLKO6PMMIpEoMn+aMEkfXYS9pr6LJDT/Nr6Fy97QibH3JUAWQVCYZ3JkcpXekhpgtDu9MNCxy3q/EmnjbjFvuHo0drwTNk+Qji7AC3DcpHa2gmmTVvfC+lF6z4h/2xDRBESKXRd2EYto+//shlmMu0Kr8mrpbpFWaQJ3u1BvsN5C+TH7vkZ7gOgbfJ/iZMWs5ky27WyMT0tpC6kQoWmiK2pcbl48Bdmu/nnD6B6lalX2/ieH93MJpDj7d/wFEATEkCfCDLFFh9LMP9hmzq0bIaijaBtB91q/oIFHzCIHwCT4Y6PlJhN7UUHWzC6Zy5TGn/Th6wrSz1au+l5VsTowBKES5zex
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--rhxkikwyiqml4ro5
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 8/8] selftests/cgroup: test_zswap: wait for
 asynchronous writeback
MIME-Version: 1.0


On Fri, Apr 24, 2026 at 12:00:59PM +0800, Li Wang <li.wang@linux.dev> wrote:
> @@ -345,7 +366,10 @@ static int test_zswap_writeback_one(const char *cgro=
up, bool wb)
>  		return -1;
> =20
>  	/* Verify that zswap writeback occurred only if writeback was enabled */
> -	zswpwb_after =3D get_cg_wb_count(cgroup);
> +	if (wb)
> +		zswpwb_after =3D wait_for_writeback(cgroup, 5000);

We should have something like
	cg_read_key_long_poll(cgroup,
	                      "memory.stat",
			      "zswpwb",
			      0,
			      500,
	                      DEFAULT_WAIT_INTERVAL_US);
for this.

Although this also needs further change like (and respective adjustment):

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testi=
ng/selftests/cgroup/lib/cgroup_util.c
index a7b3380d88d77..c0511853db9c6 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -188,8 +188,8 @@ long cg_read_key_long(const char *cgroup, const char *c=
ontrol, const char *key)
 }

 long cg_read_key_long_poll(const char *cgroup, const char *control,
-                          const char *key, long expected, int retries,
-                          useconds_t wait_interval_us)
+                          const char *key, enum exp_op expected_op, long e=
xpected,
+                          int retries, useconds_t wait_interval_us)
 {
        long val =3D -1;
        int i;
@@ -199,7 +199,9 @@ long cg_read_key_long_poll(const char *cgroup, const ch=
ar *control,
                if (val < 0)
                        return val;

-               if (val =3D=3D expected)
+               if (expected_op =3D=3D EXP_EQUAL && val =3D=3D expected)
+                       break;
+               if (expected_op =3D=3D EXP_GT && val > expected)
                        break;

                usleep(wait_interval_us);
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/too=
ls/testing/selftests/cgroup/lib/include/cgroup_util.h
index 567b1082974c5..3e9bfb66cf5a9 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -19,6 +19,11 @@

 #define DEFAULT_WAIT_INTERVAL_US (100 * 1000) /* 100 ms */

+enum exp_op {
+       EXP_EQUAL,
+       EXP_GT,
+};
+
 /*
  * Checks if two given values differ by less than err% of their sum.
  */
@@ -69,8 +74,8 @@ extern long cg_read_long(const char *cgroup, const char *=
control);
 extern long cg_read_long_fd(int fd);
 long cg_read_key_long(const char *cgroup, const char *control, const char =
*key);
 long cg_read_key_long_poll(const char *cgroup, const char *control,
-                          const char *key, long expected, int retries,
-                          useconds_t wait_interval_us);
+                          const char *key, enum exp_op expected_op, long e=
xpected,
+                          int retries, useconds_t wait_interval_us);
 extern long cg_read_lc(const char *cgroup, const char *control);
 extern int cg_write(const char *cgroup, const char *control, char *buf);
 extern int cg_open(const char *cgroup, const char *control, int flags);

--rhxkikwyiqml4ro5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCajKSXRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ahk/gEA8MFcY73q1d/mRp6IVc/w
CQOVsXy+oQ7vXkS8eyOailYBAKUGPqDDIcVYrCtsuMyhJ+LOoh7WKCiXRcrKQPNr
iBMI
=ROyv
-----END PGP SIGNATURE-----

--rhxkikwyiqml4ro5--

