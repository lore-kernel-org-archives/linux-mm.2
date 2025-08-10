Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366AEC87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 12:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1286B00AF; Sun, 10 Aug 2025 08:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8D26B00B0; Sun, 10 Aug 2025 08:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5E06B00B1; Sun, 10 Aug 2025 08:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADE476B00AF
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 08:58:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5ED00114DE4
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:58:57 +0000 (UTC)
X-FDA: 83760852714.20.360C76D
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7EC41100004
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:58:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OoM0Ytf+;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754830735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DuqcSADnXqnWDt2KXmVA1zBALEN31klBjKcBY7VnF4M=;
	b=Pi8aBFuuonk0f7RTJ5IwYHGhiwoLQuQPzen8Zf5HAq0Ym/D73xu5sdGSTS059ogE01mmH8
	AYJ9kmI3kyehScgFt3neTMulS1EK0qUjsPbbt0N2qAA10oWfAZE/nBkWurRK+xE1LX2hqp
	EaEdjY453Vd+Z8oRm6l/A15y8BkWubY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754830735; a=rsa-sha256;
	cv=none;
	b=TL3SWMd4NoCWliFeh0dYeAwo+mPNXOsxQZOIuvZVljhs8AsIRssaoQbaA83PJVCP6Hf7NO
	680pcGJka8J6QBT/PwA6rkohWOu4r2So81eVMYpaCFOPozp/JIytg9bMYrJxuoQ4AexOKL
	ydPQ8Ercsii2hnAMXTpTI1JcBp69g64=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OoM0Ytf+;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-30799a41109so1368423fac.2
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754830734; x=1755435534; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DuqcSADnXqnWDt2KXmVA1zBALEN31klBjKcBY7VnF4M=;
        b=OoM0Ytf+gjqpu1uY3KuNXJFX8h/6cCge2WAzbgh7xWrv/JEpJbk4ZjXt3IHoxx6SW4
         N5/IerBrXCMC/YaRcSyrrH0wBVNmWPsSz/U9girU0wS0F5y27bY7LMiac5Zhlrizdkw0
         FTVp4rZV+fDt5hnlceKH32gXfYCqK7l+OJ0VxQafkt2VQ/yg9fHnEOWCItgtHuKRBnI+
         1Q7hI6prf9EMQPzr1WPkyAX2uBAfNufVlnqt4OPfqcIderWL9w6DcgK+CE8JhSLT9reU
         Oam2a3jrEEt2jq+dYXzbVv5NVEjTm7vENRqyMN54i12derERaom4/iTYmM/3N5b4Mh6O
         FSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754830734; x=1755435534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DuqcSADnXqnWDt2KXmVA1zBALEN31klBjKcBY7VnF4M=;
        b=nu59bQwl74XHHYtzXFBTf6M8f7vZY9g/ohEg1ib64igh9G7B4wiQnCcA4vBuTR6zOD
         JUoFNHztsUDnyL1qkpbsiFmcCeQq1q4CIZQCH5RuDYyR6hhHNVc+TxHJgS4PfLyC6kqX
         sdzsImzX/etQ8VF8f3FENRXDMUs2+Q20pdgI8SIprxBKo5pB26MDMcnvI+URLiDwgr79
         irtS5y3CgXWAHreogVmtUNBpWAEuSec9HJM/5BvjVsCyfr6MBCLrvSpHjPgY2biR5Yi1
         xijrAT77CbO2tcWQ1guTOj0mCYF+kN33qn06QDV6frhKjK+3lIbG5Vi6oPWJR+6HnqjG
         +bCw==
X-Forwarded-Encrypted: i=1; AJvYcCWTrwq3dPgJ7yw5V79NBfh9bYEAScfTOpzCGQ8ZOmSHCm27mYhRuuPON4PVd9cg7HOZLwgMzoNg1w==@kvack.org
X-Gm-Message-State: AOJu0YzIo9EhFSCBj4N0PTmSd13Mz8mTIdur1psPDHY0QBgUsgg7rKtn
	aBQDgxNFipKQx5mZIkyiszJIOlQOvzEMl/jDuLxrUqy7gsQqticPn+vIK7m4n0IZncrMDsjB+hy
	SJ2H6Z33ObY6RFyWSRbNn/1Dbc1XosXU=
X-Gm-Gg: ASbGncvt9EhxlcSj5fNcsmoyNJgqPwAYewvKFrC1T/YifXadzrzx6dzz/7UAI5XBs78
	jGBIyZdQ3e02zz2bDdA684GvhbUPoCWms2e+81EOuolDqIEs2MKVIUHAY6TNpYoKukZmvIs55FN
	tIXF4G6DDsRrmQMO3syvS2dWPwvL26x+yDKzg4UPej3Oqg2olMizHyHRh3eSIjOqD7k6NrkN4oE
	Pvj
X-Google-Smtp-Source: AGHT+IGWxdU8yg429wV/BEb3fwg5pdBborKVwW4JfYTj0EisAf/O7g6UCqz7QBFgg2+6oztJ/ZtPGCd/hmS6rk//c8U=
X-Received: by 2002:a05:6870:d60a:b0:2d6:2a40:fbe7 with SMTP id
 586e51a60fabf-30c20ea1839mr6002024fac.6.1754830734392; Sun, 10 Aug 2025
 05:58:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250810124354.16456-1-ekffu200098@gmail.com>
In-Reply-To: <20250810124354.16456-1-ekffu200098@gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sun, 10 Aug 2025 21:58:43 +0900
X-Gm-Features: Ac12FXyAVojbHXaYNEc1bAVyQmTG6kEonLtZC-nGoddoNe4AthOe6g-HBOLDrJ0
Message-ID: <CABFDxMGHz_DJJncoE=ZUkBJwyph=_3WTfgd7H-0XyAdtuKtWJg@mail.gmail.com>
Subject: Re: [PATCH v3] selftests/damon: test no-op commit broke DAMON status
To: sj@kernel.org, honggyu.kim@sk.com
Cc: damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7EC41100004
X-Stat-Signature: d3soph3jtaozka8rmyqni58sxd6i8jyn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754830735-847484
X-HE-Meta: U2FsdGVkX18F7f79w+QYHGN+Oc+mU8JqaFfMUNHHVqpWu1CJoCU3a15xdtU8qrciBWFyy9A82yXYLwHumT+cDcLFjsPwyfhtaCmQ8hY5jUEHZGyl8otoh5tlCLc7CJ7BG5WhwDSpiM/tIrNNUw88TJ00cSwtDO+Nef0YLfRe4Bifo8njObKA6fr0HPx4cm9awimdcDWii1hVZlF2WDnmXmc11vVwcTSdjfKvRNHwMu59g/su1Ohpack6tV75L5MUxdv+PBHy2xXydJfzqbzsKKiD2VoeTcIFk9Rx0jY+UKpt4SyACbx2Op/3Y/pxp/60DVJn5oSJPbBUxiDymgSR8lmiCdfheQCl6L0RRPBl4E0oiVM+DMyeRHN1Qy6Il6tFsNWFpTVZhoPnbXyukdE2o3WzITbfDNhFur8VRHSNJdJkc5kSGPTkEDm1dvtVNK9sPRfhytqWmP4/9WI7aoaKFvVJ9etc7WPDigsdrZ9YgZI1LODOvpyHL2Tg6RXGaBrWvegTqbcX5Nhhek6Q480JDvLDwXPuqwMPCcMObqZ/KwdFrxCKDfSnQ5YnlUVJlEIsK3R0bJZrMFV2Ufbwx0lXZK7cidRpA8HdVyktmmShduzGuG7kG6gYvMrFtiOV73/Mn5hvfiDkykkWqQXK9Uvnqzmuo28UrOepTPlBCNeFfil3d27FhOsPfb540f8aRyFqFLysf7SaGKAqIuOuqfXrpLTKMV6pB2qiY9o5G5Mptgmid4m+Z7phyJiuL+PjCZTtNssn5jHSOEfIcaLOz88kk+mdoLEOL5wZfK1VDyO6TZFU2JNeBsCdu9p+t23/pLof5+D9vSaBAXK/lEFgDslU/Su1EFxkQdR40qGiyx6JgP1aeVE27kEHwX8Wnfa47sAYk9wRV/tbcmnKPx8d6waE33cuvSEjLJQxrYnp6o3GTupfzXyQZZB3hMo7cWlRTn5o1stkCldV1Iv/8LnEWXB
 1x6MAUGW
 JTcuZDWgIFcttC3UdxBfxANRDcVaz+WSviSjYDfYnJ+v+IsO6xOOdth6AQae7uGqdIOKdl0TX1he8VBModGB1dbeoHGcopDOM73Lx0euZWgr2Ah1aWI/dAtppu0ZqcOgd78zrWF58+eRZCLTjjNyRQis9te0U+wd5DOLr32FxX3mLZ4KMDgFUz68iY/att6iTkGWS+JXg2YiHtlGtmIsTNmW0mmlTgdxgx3sr+jcJhcQ3wlb26zz47OXQWgf8oDRzClaoNCQghN1w8FVYNPDfA5/Ui44p3IWr1QpPH5dyqODW6FKxNJpu4UM1NS+4qk8p2zBN7slPabRVrRxWlO7GsyS8RwdXGStxU2RgC7rWxF5b9+y+0XXfQ8Ix6/6FP0nL2yDDOeISSvrfgVi1K2vmBV5sFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 10, 2025 at 9:44=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail.c=
om> wrote:
>
> Add test to verify that DAMON status is not changed after a no-op
> commit.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---

I just forgot to add change logs.

Changes from v1 [1]:
1. Fix code and commit message style.
2. Merge patch set into one patch.
3. Add fixes and cc section for backporting.

Changes from v2 [2]:
1. Separate the patch into two parts(code modifications and tests) And
this is part of test
2. Improve warning message on dump failure.

[1] https://lore.kernel.org/damon/20250808195518.563053-1-ekffu200098@gmail=
.com/
[2] https://lore.kernel.org/damon/20250809130756.637304-1-ekffu200098@gmail=
.com/

>  tools/testing/selftests/damon/Makefile        |  1 +
>  .../damon/sysfs_no_op_commit_break.py         | 72 +++++++++++++++++++
>  2 files changed, 73 insertions(+)
>  create mode 100755 tools/testing/selftests/damon/sysfs_no_op_commit_brea=
k.py
>
> diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selft=
ests/damon/Makefile
> index 5b230deb19e8..44a4a819df55 100644
> --- a/tools/testing/selftests/damon/Makefile
> +++ b/tools/testing/selftests/damon/Makefile
> @@ -17,6 +17,7 @@ TEST_PROGS +=3D reclaim.sh lru_sort.sh
>  TEST_PROGS +=3D sysfs_update_removed_scheme_dir.sh
>  TEST_PROGS +=3D sysfs_update_schemes_tried_regions_hang.py
>  TEST_PROGS +=3D sysfs_memcg_path_leak.sh
> +TEST_PROGS +=3D sysfs_no_op_commit_break.py
>
>  EXTRA_CLEAN =3D __pycache__
>
> diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py b/=
tools/testing/selftests/damon/sysfs_no_op_commit_break.py
> new file mode 100755
> index 000000000000..f557587ebc81
> --- /dev/null
> +++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
> @@ -0,0 +1,72 @@
> +#!/usr/bin/env python3
> +# SPDX-License-Identifier: GPL-2.0
> +
> +import json
> +import os
> +import subprocess
> +import sys
> +
> +import _damon_sysfs
> +
> +def dump_damon_status_dict(pid):
> +    try:
> +        subprocess.check_output(['which', 'drgn'], stderr=3Dsubprocess.D=
EVNULL)
> +    except:
> +        return None, 'drgn not found'
> +    file_dir =3D os.path.dirname(os.path.abspath(__file__))
> +    dump_script =3D os.path.join(file_dir, 'drgn_dump_damon_status.py')
> +    rc =3D subprocess.call(['drgn', dump_script, pid, 'damon_dump_output=
'],
> +        stderr=3Dsubprocess.DEVNULL)
> +
> +    if rc !=3D 0:
> +        return None, f'drgn fail: return code({rc})'
> +    try:
> +        with open('damon_dump_output', 'r') as f:
> +            return json.load(f), None
> +    except Exception as e:
> +        return None, 'json.load fail (%s)' % e
> +
> +def main():
> +    kdamonds =3D _damon_sysfs.Kdamonds(
> +        [_damon_sysfs.Kdamond(
> +            contexts=3D[_damon_sysfs.DamonCtx(
> +                schemes=3D[_damon_sysfs.Damos(
> +                    ops_filters=3D[
> +                        _damon_sysfs.DamosFilter(
> +                            type_=3D'anon',
> +                            matching=3DTrue,
> +                            allow=3DTrue,
> +                        )
> +                    ]
> +                )],
> +            )])]
> +    )
> +
> +    err =3D kdamonds.start()
> +    if err is not None:
> +        print('kdamond start failed: %s' % err)
> +        exit(1)
> +
> +    before_commit_status, err =3D \
> +        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> +    if err is not None:
> +        print('before-commit status dump failed: %s' % err)
> +        exit(1)
> +
> +    kdamonds.kdamonds[0].commit()
> +
> +    after_commit_status, err =3D \
> +        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> +    if err is not None:
> +        print('after-commit status dump failed: %s' % err)
> +        exit(1)
> +
> +    if before_commit_status !=3D after_commit_status:
> +        print(f'before: {json.dump(before_commit_status, indent=3D2)}')
> +        print(f'after: {json.dump(after_commit_status, indent=3D2)}')
> +        exit(1)
> +
> +    kdamonds.stop()
> +
> +if __name__ =3D=3D '__main__':
> +    main()
> --
> 2.43.0
>

