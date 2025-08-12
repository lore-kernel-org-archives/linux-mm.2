Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE805C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DEBD8E012F; Tue, 12 Aug 2025 09:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F098E00E5; Tue, 12 Aug 2025 09:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E1E8E012F; Tue, 12 Aug 2025 09:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E00B8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:27:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 11C5D14033B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:14 +0000 (UTC)
X-FDA: 83768181588.18.CF1CF69
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 39ABF1A0006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gAVzL9vQ;
	spf=pass (imf19.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RREPB+k7a/mceQdaxCB2njGP8WW7v6Nzrb7ci/2EA8A=;
	b=CEpTm3QWK+jGfyhHSkNybqgMANgOg+YlaSH/+AfQBREkh+6GWVbo1hVMuoJTYMQjEwgOCt
	1ByRZGeCOpCd2zrf9Z97Pgx27/W3qYD5CWPurFN1qrUOJ7Ze/Ps9eeYWDn4ZoH8qZ6A0MQ
	RRB1tF/gfnwBjW7QUGa3HDz9rVFDFxQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005232; a=rsa-sha256;
	cv=none;
	b=eozVjCY/sg5wxTAxpjl07uYnpaoYiHWBz9ffbI30rQfXVF4h8Jk/f02Sy0dzfONPW4bHcm
	t/tA+HmM3wIzDHz64le3jpdNFYxMLIjMyIM7lvGgHOtHHFJ6lMrqwtzfTGV1J00AYgxljK
	+AxX0rtlAQz6ie1+pRl4/Pea7fJHshU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gAVzL9vQ;
	spf=pass (imf19.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-30bc0cfd8e7so3264807fac.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 06:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755005231; x=1755610031; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RREPB+k7a/mceQdaxCB2njGP8WW7v6Nzrb7ci/2EA8A=;
        b=gAVzL9vQ3ulzLaPGQLE1mrhqpcepQdr8OJ7ufcG/XBgxGuiRX7E0DB5C7oVADsOMLL
         RRWJPCCBjn5+j8wk2ltXd+VtvbFWOeqo9LVcezDv2+lP9NNdMTfEWQRtpeQMTmIylv0J
         BmkhXx0sEmgoioCkZoIVoRlJbZvzB9q41EmOFGiEKU14VLIMCtxHRLcnpmblXqsIhzPx
         XCKM7Z9ZH6a8M7XakfQVPfS7wz3tRO7/dksuim8lmAKdVmJovE9eAVG9yYRZw4ovdEyY
         NFtmqJgzzQA6gr/7/403lZeiuDERVFnbeLfRIcLQ8+xOo5stS0y6cj0RmaMlck+Pj+RW
         sXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755005231; x=1755610031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RREPB+k7a/mceQdaxCB2njGP8WW7v6Nzrb7ci/2EA8A=;
        b=olVf/QV6W87b24Lu+N1Ba2ngGq6l98YP8q7iYZW50rye+jSmx0xH/G32/W/fUQ8CgW
         9o51ftWgPMN3g9k3aeuChdc+CwSPZHY7WGDNENZJcgeqUNC8CpUoN6+F6TRtUR9UO0Ez
         ufan/05awhzxFPwXGg46C4XVjczHoSbGxILEHAPamUhdt8oWXn2MUG0ByHEn+PHJvA3j
         nR6yWVylNY8pYvdTSD12siCKwIMW+vrgZFVB8eDyKSGiy6LozhHeTjihLiRaShGFIuvC
         +/PbQEIz60rfPG9hNOv91N1z+Uq6G/UL6HIeIYWQTSO78plTH5Qxv/G4LscvJWfn0z2z
         ek9w==
X-Forwarded-Encrypted: i=1; AJvYcCUeN1IKYKGBxE5E0gUwSMZN/StT4AOCw9rv1H3QVJ6TmV2gYkzrQLm3pdeL970c7m1lUuncfjC9nQ==@kvack.org
X-Gm-Message-State: AOJu0YxRV2HOmO8ZZPx8MI8x8Z4PX8ZstFFWiL1K9fo2d3D0yH10NvA8
	y4VBmsbHZb8FkVHmrmQq1WyDtXDcXv1FykT5ZWpRmUL8HHQV7oUp391rzBeEci4IdfUg4FNL4av
	BMhY62lsk4uK7yRf9dDlLnYnbm8tnk6A=
X-Gm-Gg: ASbGncu59wcTxJDG8i6KMeEFTMYfILKZgiQakCmrZqpJ0wp/s8QcA9PSbHoP3FToZgU
	rLIJSAkUjxKtz5PVezMPXSXaaj2jxZXbry4eItlo0mL9Pf1FHpyLetHOm/oEshiBGNoJHxAvRKp
	qy6ycVFtRIOeIPvbA87/zBKu+qoWMVOzZsayhWFxteVDfFXoQwpMiwflrfjzu4qE719L/AFD1Xq
	KSf
X-Google-Smtp-Source: AGHT+IGpbMz1DdsWZ1z4GCKL7utzJO8TIQxtkA8SafJyjmZ6lfFuwcFQBFZL2gHHQv89lc/KdDVrhAdvffGsU9WPpY8=
X-Received: by 2002:a05:6871:6718:b0:2e9:925b:206f with SMTP id
 586e51a60fabf-30c94f3cf74mr1607259fac.17.1755005231005; Tue, 12 Aug 2025
 06:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-alex-fixes_manual-v1-1-c4e99b1f80e4@rivosinc.com> <CABFDxMGPS6LE=A25VjXEpfKuzVfgxfgu=_uhkWXc3D+xuq-B6w@mail.gmail.com>
In-Reply-To: <CABFDxMGPS6LE=A25VjXEpfKuzVfgxfgu=_uhkWXc3D+xuq-B6w@mail.gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 12 Aug 2025 22:27:00 +0900
X-Gm-Features: Ac12FXxoAocnTTpz6traLMo0gPyYiDuR8cKin4JSoMSWQ6SUh-o9iDKVTOiC780
Message-ID: <CABFDxMEQYx7fdx4T7meUb01FoqJaHcW_2RoYnBwJ8GzmJTexzQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/damon: fix damon selftests by installing _common.sh
To: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: SeongJae Park <sj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Enze Li <lienze@kylinos.cn>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 39ABF1A0006
X-Stat-Signature: ii7o8gu45pghuiq4e8jqjgczm3wuu49c
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1755005232-65792
X-HE-Meta: U2FsdGVkX19ppR8tMYsBNx/qW+UBXRCu+CVet1jlQfuiQlI2vXaHM8xp4yiFuNI+jta4hsMygk7UkLLe1U+DTxmAhWpAondHp4pd1sZjlXs4/iZLjQt6KJQEuVbHIseBGcxj7y4sFCtFaO1WnubWvTBv+g0ScNHkKVyYzFBe/G4wqHf1pclJGBQ0BJUaygAwQO7ORLccyfHDIkKBifNmOu8dy4OBL6CeVCFgFNChYF5yc0oq48LsZMwpfU0/4Xcn+gAEe3a6RaI8/fOMMl5Bi4Y3eSq2/Y0qJRK7Yx65p3Rn3fx8RZs2q29rcjRCNVhX6dGpOeT+OSDy71qBt9eOidiN+Kf7iynvBb6EGHpGobsWgSvlcq0yojylxggWNuskXfw4CzshNSGz4yssAozTkES8vDxF17PEADbo+hM8WsHZs0hdSwKivpy7pn28XACfLMJLVeEiUReK/n94/R9gjcwGXqlE1zACW9ESPX3uRb0Rea403Okg0xe9m54WraXpnER1m30/puaSynXB40uq0VMwgdBwrWBddHNQshyHShMDD7E1xjReF40AE/DrOxAlX6mn6gwMyy/Z81ibuGzap+8wlRh08GPH6MRZRXKQ7QWAIawJ4PS0FIqNtH25tLnJk9jqWNP0yZgJfXmndhnIwMSsajuxtvv/s5tIkqvys7vTCKcLQzBXyWEm1SkX1nB6lP5GONIjVYwHyWjwXpnLt3rRhD7iAZngz99MlnWAcB9zMMgRT0cvoG+jkPq5rw7bxoYn5fW7ldZMD6FZXVZ2kXlFiX8822w3740wcmDh6iqAm69DlJAND5Uw6MGz/OTsixqWrzOmwByIaOz1r5LIGq4LW7P4qtXnmHpDTqdJ4bOHddZd0aYh0ENi22F0dYy8vPGxrwiz6pbNL0Pi5s+0+e5Twt5XM0dToc5sa2lwP1EyJAGi/3TxmvCyNZe0ZD8DV3J2nUOo2rgq7DSk0AE
 A1bwlX5n
 jHnjSSmVKmsJQ1+etgzRnwFxWFcTiC655BwG+W2Y5TuQHPmNE4g9liTcvMLK2otLly9xagI2d7E2Qv8uIn3d9JpgAzTpwMaqnsSLr7idIt+t56rqrXhN/thTs6k3PFTBxxuyGiWlrK8zHlUyCEaF+DR0hGsRgV3VHGzkBeO6VNu/gG68YG/XbudzhANZdZtafW7x2S3i2i8G9btm2Q8TTcExGIxUH4ngxkzD0HLlUUklvzrb74RdDmsA8jhMnJgPM8U4aSE0LZBq4S1gVdH1UCpiJntbe3JzW5kEeDiPZLL8tvMSNpguw0y3DTW2ADeiaCPBSJwJ1iKq7AabLnE0aTZmoRREW0AP/Cmm9ljdcJptW+sAicnKIfscKaAWncI909pbU+EJ6Hko4NhTnAcSr96T85LbRtY+ZjDBjFy4sGJ6MGPdSpxTPjOFbX7gk/CN6a1g4vrgS8518D+qF4+L0Wg/ZCrpLaJ9u621+p1zA0bS28nM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Alexandre

On Tue, Aug 12, 2025 at 9:32=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail.c=
om> wrote:
>
> Hello, Alexandre
>
> On Tue, Aug 12, 2025 at 5:13=E2=80=AFPM Alexandre Ghiti <alexghiti@rivosi=
nc.com> wrote:
> >
> > _common.sh was recently introduced but is not installed and then
> > triggers an error when trying to run the damon selftests:
> >
> > selftests: damon: sysfs.sh
> > ./sysfs.sh: line 4: _common.sh: No such file or directory
> >
> > Install this file to avoid this error.
>
> I tried to reproduce those error with my vm environment but I failed;
> with my workaround test method, it doesn't exist.
> If you're okay, could you please tell me line by line how you execute
> tests in what environment?
> I'm also struggling with the test environment, as well.

I succeeded to reproduce and also check that this patch removes those error=
s.

> > Fixes: 511914506d19 ("selftests/damon: introduce _common.sh to host sha=
red function")
> > Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> > ---

Tested-by: Sang-Heon Jeon <ekffu200098@gmail.com>

> >  tools/testing/selftests/damon/Makefile | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/sel=
ftests/damon/Makefile
> > index 5b230deb19e8ee6cee56eb8f18c35e12f331e8b7..ddc69e8bde2905ff1c461a0=
8f2ad008e6b28ac87 100644
> > --- a/tools/testing/selftests/damon/Makefile
> > +++ b/tools/testing/selftests/damon/Makefile
> > @@ -4,6 +4,7 @@
> >  TEST_GEN_FILES +=3D access_memory access_memory_even
> >
> >  TEST_FILES =3D _damon_sysfs.py
> > +TEST_FILES +=3D _common.sh
> >
> >  # functionality tests
> >  TEST_PROGS +=3D sysfs.sh
> >
> > ---
> > base-commit: 2754d549af31f8f029f02d02cd8e574676229b3d
>
> Does this commit exist in `mm-new` or `damon-next`?  I failed to setup
> the same base-commit environment.

However, I'm still not sure that this patch is in the correct
baseline. maybe it will not cause any problems with the merge
though... but I'm not sure. So I didn't add a reviewed-by tag.

> > change-id: 20250812-alex-fixes_manual-aed3ef75dd83
> >
> > Best regards,
> > --
> > Alexandre Ghiti <alexghiti@rivosinc.com>
> >
> >
>
> Thank you for great work!
>
> Best Regards.
> Sang-Heon Jeon

Best Regards.
Sang-Heon Jeon

