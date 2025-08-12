Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFF9CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37F0E8E0112; Tue, 12 Aug 2025 08:32:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FAD8E00E5; Tue, 12 Aug 2025 08:32:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246EE8E0112; Tue, 12 Aug 2025 08:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 11DDC8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:32:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88217140305
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:32:56 +0000 (UTC)
X-FDA: 83768044752.16.156AB25
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id B090B120010
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:32:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E/+qEWGs";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755001974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJbVEsQJVCjelejxZubJqTtynOwasKvIUa9eAU0KJJo=;
	b=NU1VYhQWk434pBNWocW4gXLu8vXWdi4pH6eTmLiGrjaX74JiPW7eJlMYWOmn015NnicQKh
	QRTw6tndTQf3x/fAj0LoqRwo7mnEgCdou7enDThHEp4qo2Yh3/4vIJ45wop6fpdV8qnzsE
	02L67YaZrovRzJO1G/3i1NtkN9pV9Sw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755001974; a=rsa-sha256;
	cv=none;
	b=zPt8Zun81o8Jvh3Nd1KDE99QacDpMVa4eVgivsPIuuGVNsn6mkkUUDvn0O/9F5WL4B00b4
	p/R6gd3xEan1UFNSeYsiOm831AHEblGRQ5z68uB8lUVomkWdTstcd9o3jvd+p8Jz941eQQ
	GLNIpyrSjzySdEOvD4nxeDzOWmH8kq8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E/+qEWGs";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-30b6c230808so1361350fac.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755001973; x=1755606773; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJbVEsQJVCjelejxZubJqTtynOwasKvIUa9eAU0KJJo=;
        b=E/+qEWGsyV1BPBWHDze+Cdi2DphPLz+8PjZHiVo37HkFSBqd9zoJWf5Wsq0PD2E+nD
         w8/SFAIrS2SYCvnTziVe85/nmTWpy3K3RPSC8qhyzymN1a0toiGl5IwEt5T6+g1cWb1Z
         zPpvbMlXNy6Km8VdPzzsS1hNXI35S9NPHSr8rJ1A2bec7vSplXuIg4Fvr6t5VM21oUle
         zn7q6zi57Xmgll4Pqy8JqPJSVSP5DJE4NPUajHeEOGhN1CR8sHdDQVYQQM3E7peSRqjE
         OIFD5kIjFdWESkFLHgTvi8nLSVtC9e3yO+P+6vWVML0jHbLM+0tEVhrIw2yETsKgHq43
         ULXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755001973; x=1755606773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YJbVEsQJVCjelejxZubJqTtynOwasKvIUa9eAU0KJJo=;
        b=MY3uu88/c6bfyWARwd2+X0yLIUtMjOvShQfYgBSLlPVIIREHII3cOP1ll1LFY5Y2+B
         Yin/UrObMUgao0TFsPI9JhZNc8f5xE1CEb9uBTLwWO+woxPUB8ftqMMgz9zTNBg74Yae
         Dtv/VoEIULSFEXnaqnJMBBv1QLdQ89OhfuZo+2pJ2hjmO7P7eZ8St9eYag5MRdfNpqiQ
         Heq+ZxY0Lvo0l6U3opVA782WmQCMVnFr4rzqfG0F0UdbTWuam32KArmbwwmE19iRY9F7
         gfJnVnPrMcUpWxUyMFJw4VNOa0ZW2pw1qWbB1GCCx6SJave87Ns+qS/CcP4fhSxRd7Ow
         3Atg==
X-Forwarded-Encrypted: i=1; AJvYcCVigskh9Pw5IVM+LeBBJpqMtk7E0pDUkMDyTQfvhdZpgUARtsK+aXHsGaK7eG3YXq1x4DwtJwNKWw==@kvack.org
X-Gm-Message-State: AOJu0YxuVlpzQMIleVxWCaNR5RWK89FHZmA37DUljIk9Jn9RmCrxejsn
	8OrGL6OGy5BeFYqt7TiAwbcnixCVblBcmTaoTJxjUiM3ywe5zhC65B4alLOftn1x5YOshvlyW+6
	LkHulpl0aAoigIIxcaNasJswpBk/9msQ=
X-Gm-Gg: ASbGncuRySAD0WGkiJPkNThRnrZHMbKkKYHrwPXwf/W/PHOya8mED+KFsK4TYL2F4xV
	7Av0aYxAjLK2kq957TlulgOEL49jgiyLggCHymYDxs0r6mgcaJSVCGcS/xvr6x0RvvvhyU904fF
	qFLGsPiD82obY0r7chQmsc+W8RlaDS8u985WnY2sRO+RSM5viDRMPMODTw5CHnXwchM+3AwW/7R
	uvA
X-Google-Smtp-Source: AGHT+IFLY+ky7e3BroIIydWjoY0aabZimRGPv+KZv2ff2sfoqaC+0xQ4C7oeRILPEIRw/Fmk+/4AWjzm7pUMRn5Tgvs=
X-Received: by 2002:a05:6870:169b:b0:30b:9750:3085 with SMTP id
 586e51a60fabf-30c94ed0290mr2350864fac.10.1755001973402; Tue, 12 Aug 2025
 05:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-alex-fixes_manual-v1-1-c4e99b1f80e4@rivosinc.com>
In-Reply-To: <20250812-alex-fixes_manual-v1-1-c4e99b1f80e4@rivosinc.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 12 Aug 2025 21:32:41 +0900
X-Gm-Features: Ac12FXzk5--95ren1VR6OqqAUzs5yqbnOkCJYlLg7DPyV4KuIMBIBIZHxZk8QM4
Message-ID: <CABFDxMGPS6LE=A25VjXEpfKuzVfgxfgu=_uhkWXc3D+xuq-B6w@mail.gmail.com>
Subject: Re: [PATCH] selftests/damon: fix damon selftests by installing _common.sh
To: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: SeongJae Park <sj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Enze Li <lienze@kylinos.cn>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qsztaanr983bss17ted7bem61sa9yibx
X-Rspamd-Queue-Id: B090B120010
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1755001974-865238
X-HE-Meta: U2FsdGVkX1+sxRV5D13P+xP+yLRGpyKiu6H8JSmqDnTzVoNS9hvh0z9ud38lI0ux/NGCeyHPd0DcEG0RWUbNVaX92KfaV666IVZ1qH4MEvHmt0wW4zx1TcSwrixso288onYnlPsZvebajBMVVPN83AUa49JDksnytjW+RrnZNhKERjrewND3puJYqxzOYaqIMSojxsi/NUQGakAGfhtETivC4o6MqJqtaI3ycykr/QWy/8Ns2qnBXeJ7kE7jRGsUup+cKsMm0MyxuDaitYiYUJHK103rGK6YXC/REDeBv5W1IlHqEXkakWtv7n5OX0rh+CXL6W1gzU0vF0hn9G6Q3oTVz0kMoHsbNzmMP04cMTHSxsDZ/wloofZe9lcNGw3JWNZKe0ipqpZLPhmbiL73tcKJHTap3Rb6KZ8ryPtEQVtNgPojQXSv7k1/qo2sYc1cRLyfjV6SQH8cdpv49wQ7jph+sXmJ9mKiMkjVpp6iPBzERasRUJDRc+SuaPTeAci1+xEGIc344G5Bo+HdR0WLm5QSi/Mh29gN5HTm1Z0omgrvcmBJr6eiURiv5fIeDTOy+KYhTmsrrfqFEFJGQtLL5M24Fx7gmqED8pigps0XAp5+EcgF+5OB3bRBRDXSk7ahoSyMbdqI/ETOnUXC8YwUnNG5Ut1+kOT+eL0f7crZhHkfmNyOMEVj4BSi+WV5dfxIXzK3MDj0CZ2j5/yKtYH3FWOZZB48LTOsn/ckrNqhUEx13bH7FTivCgYVdq8lswLZuv0JS0nGFgzNxk0Ey8ZeEMl04VpbfHElTB5SfcBFBHt+6xBrSFLGn91hVlHCAQgw/q9Zh/Ct4BReBRucusqyGQf3bbm/Tq+VgT1cuSek6Phbcxn57sHKfRza8HFMWKCKkLCW892cQOnvt/fTlH2hp/ONWypSqzbp78Gikcw0ZvcgjYHeMXq5HJMGWMdAVrvzlv5Nu0PjPKoBLWb7oRY
 zuoy3Jd6
 98oJFFOKpgDS0a2qTAyCPX66Gi+6gw8Tq9mAvUqNWAr0ayBVUs9Qr/V3kWrYIgvsPxuo1q7Vx1KPW9NmcUAjIMJ5NtuAPudOwWDBwuZhw0szegcElF4wLqBmKOObVrc3wpH0wn8nvD1xS7OwtXuL3ixtItpJ8UOXn33ON37Zb8LiFwY3K/BwZPcqcSTmY+zL2dFV5CFQKPe2Aa2rLayizDVuEKCzypECk60vASyrUpNkltaUGP3FomowwIIpBtPUqFQvMn6ms3+2+lixDUHZxdopSovCldbGmRRorwLX8wQTpDuz2VDoKdSH4xaR5ZFVEAYZigHf3fhMeHcLC8rPGyZZ/A2DzkOhMU6TEOjeGGg3GpUOVtqNYGXeZi4qZPIJkAVGTEiqQRSwcUKfNuPb4KxSm/ieNXd1kHobR0ebWOFPf5RdAnRcv8l4GI8bwlTna/lXZsCzKTyEybK55QR8TrlBJvvoizTMbPJgmM8D1evzbGoKTWcyA2jYrSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Alexandre

On Tue, Aug 12, 2025 at 5:13=E2=80=AFPM Alexandre Ghiti <alexghiti@rivosinc=
.com> wrote:
>
> _common.sh was recently introduced but is not installed and then
> triggers an error when trying to run the damon selftests:
>
> selftests: damon: sysfs.sh
> ./sysfs.sh: line 4: _common.sh: No such file or directory
>
> Install this file to avoid this error.

I tried to reproduce those error with my vm environment but I failed;
with my workaround test method, it doesn't exist.
If you're okay, could you please tell me line by line how you execute
tests in what environment?
I'm also struggling with the test environment, as well.

> Fixes: 511914506d19 ("selftests/damon: introduce _common.sh to host share=
d function")
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
>  tools/testing/selftests/damon/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selft=
ests/damon/Makefile
> index 5b230deb19e8ee6cee56eb8f18c35e12f331e8b7..ddc69e8bde2905ff1c461a08f=
2ad008e6b28ac87 100644
> --- a/tools/testing/selftests/damon/Makefile
> +++ b/tools/testing/selftests/damon/Makefile
> @@ -4,6 +4,7 @@
>  TEST_GEN_FILES +=3D access_memory access_memory_even
>
>  TEST_FILES =3D _damon_sysfs.py
> +TEST_FILES +=3D _common.sh
>
>  # functionality tests
>  TEST_PROGS +=3D sysfs.sh
>
> ---
> base-commit: 2754d549af31f8f029f02d02cd8e574676229b3d

Does this commit exist in `mm-new` or `damon-next`?  I failed to setup
the same base-commit environment.

> change-id: 20250812-alex-fixes_manual-aed3ef75dd83
>
> Best regards,
> --
> Alexandre Ghiti <alexghiti@rivosinc.com>
>
>

Thank you for great work!

Best Regards.
Sang-Heon Jeon

