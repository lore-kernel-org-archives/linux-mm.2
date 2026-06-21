Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31236CD4F26
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 02:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0146B0005; Sat, 20 Jun 2026 22:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197F96B008A; Sat, 20 Jun 2026 22:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AD296B008C; Sat, 20 Jun 2026 22:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE7FB6B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 22:41:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56122A02E3
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 02:41:51 +0000 (UTC)
X-FDA: 84902369622.20.5EEBFDF
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5CFE21C0003
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 02:41:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VZZsmG1H;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782009709;
	b=SQqI13awZJ2cH9dmR0xbBo2vmvKyIx28U/9WB2wYnWWgL8vJoEOWKIl6Alw7qjV+/EBA2i
	fn1Lsu+Wuejhp3e85NVWPFdt6Vh0/fhDn9Po1MYNy8HVnhOKFfTjp5FR437cu2mqsVAQRg
	+N3SlgnossyB6dnz7Nq6qYA+HqSWmHA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VZZsmG1H;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782009709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q4KIUId1f1sVncDnw+MzAlE/xDSKE+kT336E6fD6PfA=;
	b=Cj5kQlBrBBWCIe27laMyF+wxuFAEXGTUVAAHyqf8ogk2gE1FcGkkiwe/PRmSxtiJ/olsNs
	F6DoUi23b3+/CYlDoU7zEgMduypLnVCrMYYNJswpN926yIJSRGy2HGfjkje3/WNs5XePnO
	yre/Pmj/qDYghV+n/VoVSZ4RK6paHgE=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5177d1ff061so352381cf.1
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 19:41:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782009708; cv=none;
        d=google.com; s=arc-20260327;
        b=p1RNV60BzCbXnoTT++6KW44jk4xWTdNz8hbSpJVz9i60/zmXV5SwTUIDq2mQzVxPBp
         /QEnT3HoqLw6CJdpjJNxYRB5/Cq+Ao2vxU2EbELs+jfPS7RqaX8QbqYbJRm35k9xX/Wt
         fPQ9O1XV08Wps1oQbX+UVniX15HHCu9l4jKlhxe+TGqe9xVYrAJS8NZsyVeV4PcCgyNv
         R9UFbLNaaObHiktoAieSV6PPju7b5kmprtUoSzoUpdVjqJG3MKMmkCAmMUKMhj4WF1hi
         we+Dm6VPRmynTVIcPMZBo1Ngz3AxdzCX5Jed9/IkoepZkMtOsejmpUCRveF4fyAY0bSE
         NWxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q4KIUId1f1sVncDnw+MzAlE/xDSKE+kT336E6fD6PfA=;
        fh=f+TcHL+SJPKt30T0AzWMLPpeh6tkmaB7NJSGLcrol+E=;
        b=f+uBeJAuaD39i2Sg2Tuo8yWVk6HAILyt6aw4gUsXd41omHeC3SJeRwSp3cRfT99hLi
         BxNuOX+VDBo4FdRqTJd/zFXxBawDCDGnvuz0sr9LzIowAg77ynwF9e185N2YgAJFbDQc
         2Kb0xVR5Q+BH0F8OqqtOPOUNzDwE+pqGIE9z1x8vG61BmEJ5oxwsViRlQ1pysUv9D7BJ
         SN2Jh0Vtcgkvxt26gZ4E/Gi8JbXBGkiH985pDXIxzcIZ69j97FdCNjyJ78KgftkapzK7
         zwpR26UoArAA5eGA5zrmF9yJF/hPhaT4oPgLcMUE1VDYf0cBWEF0uSbZ4PJLyqmIIfZ2
         sIzQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782009708; x=1782614508; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q4KIUId1f1sVncDnw+MzAlE/xDSKE+kT336E6fD6PfA=;
        b=VZZsmG1HEynwrzXDoHVQgtDqhjMfen8o3elUEmiT168bD8HoAK5u6hrDXAHEo8bLWd
         qK3NsdZMpnGRd82TEfC8c67PmqMY5JT9QxuqSbVee73NSM5dEUerK8gFdbHD6ZOLVIpC
         bllZfTLHYRvbzdHDBd+BlLp4no6OyHaTHNjXkAC8ViTMZkdNzABzdULJBAi29NWicgQn
         NBl+j1oF5r8idWdCvKNmQTPVdBKcS6sMz5KoeorZjQtrui1HIllUxEpdfM4A4ofuWC4T
         4mBpz3rcfkPxh5xMW8r4r16Xz2FRSU5RGQFq0lcv3jRvNq29sMQHEV7uS5Vgw5GbR1yw
         ouoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782009708; x=1782614508;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q4KIUId1f1sVncDnw+MzAlE/xDSKE+kT336E6fD6PfA=;
        b=czTDHEwfWV7m7nS96kwhUTqaARIz+D7f3f1nOa5uLZkLU7OVPIX+Ew9wQOM+NFvFOE
         NFazN/AgwG4O7YG0g8dt0ROfPvts75ZN3WDCa9b4sxb9hhDvFIbbEYLLH8CvR0QrrS+c
         zms6tovtV8YwDoFcD4ewM9vgn7Ne9Zi8JZq1VqpWhO9khrd68H32L5xfeZQYodgvXz3q
         PDvIBkFpY+zfm2aJrWXl944aQrajLY+aG4tbhSgn5mJwRQoqrpSLhto6vmXtiyfQR0gF
         tc0X9IT1SrJ3j8Sv4FyiTPMRaWYngDj7KV49aaTvS/a5Ex4RIxeJgvuO/+aqtEKLflGh
         FrDg==
X-Forwarded-Encrypted: i=1; AFNElJ9cnD20asJq0Hxv1SsgyxXCfBlu6BnRam9LTJVHkaKK1nmefaC5vtiMylWnvwYWPGZgzc5axC8QSA==@kvack.org
X-Gm-Message-State: AOJu0Yyn5S/vgdnPhyZVp4V52zNxj7YizqmtAcYVm/CSdJIm5BXcuoq/
	w4E6pn1Zz/M4aRxwrgPruvEoe00cwNnHKq2usC1lt3RI5UF50654i/NbZskp4jbttcyDTL5/Og+
	SrpaGvJJf4e+lCOnDEsLJFebU/BUv4GYAezgnKq/bVrSZ8Vx0X2R/XessEM8=
X-Gm-Gg: AfdE7cmmyXHKXFlLrgwz7itsU5SF7uxBuAXNWTS32lNYGSlOV3ureNyk8PoCW1QrZL2
	2PH6WrGw0EUnVmq4X3NhURGgscl2p2Ojq4j9nVMAOrx+i4QRq2n0DoF1HBASbB85BsixmG6Ujot
	zrAgMh+fpaBYu5gikWUWArMsm0v31WdcbkJM1Dxpb+k64a7ZytYRJQUyRQ3NrjAmUjIjUuVgw5o
	oeR92SwcZnN6wRMqgKiZ1XyihDl8OjYUkT33+juyo4sILYYl68wWIotCPSmB8cciCimJSI=
X-Received: by 2002:a05:622a:4c1b:b0:516:4f62:85e6 with SMTP id
 d75a77b69052e-519e8d23ffcmr14386541cf.17.1782000628850; Sat, 20 Jun 2026
 17:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781803482.git.abhishekbapat@google.com> <1d729195a8d11fadb1a1fb78c64633d46843ffe3.1781803482.git.abhishekbapat@google.com>
In-Reply-To: <1d729195a8d11fadb1a1fb78c64633d46843ffe3.1781803482.git.abhishekbapat@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 20 Jun 2026 17:10:17 -0700
X-Gm-Features: AVVi8Ccp1JWWGh8vuK0OCMvf2qXL_iG1xVRWvCaRYZI7qVBXymsswxgx3mKN_Ao
Message-ID: <CAJuCfpHPBq7TiD1wfvMyVWbBOw9prEY7LvoLveeoYQOuEEJabg@mail.gmail.com>
Subject: Re: [PATCH v6 5/6] kselftest: alloc_tag: add kselftest for ioctl interface
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5CFE21C0003
X-Stat-Signature: yzsux1ozmgxmr1nz8wfs3p8nrkhhkkpq
X-Rspam-User: 
X-HE-Tag: 1782009709-987764
X-HE-Meta: U2FsdGVkX19NBhIPP/KhmhdgIOFTCBUACrToLDVYwHH99WkhGmFOM910JBuVPUIG56GK2XwZ1U5ohBRurVL9gqfy47IikzyMp513TtrTvqL04zJWGvPpso7+/iy75Pm+bWs7zV32ixVM1cX6mO/TAepETPw+XhJCwu+jNWiwVCmMJC8FFtFuhgXv/1O4TpZSmM4WbZVrD78zDMb+cMHZUoOAyCrunQexResoTIbz9qzOrQwAVlJwKV8jf5cFwY0bANbquvLBZqTnoKgvU4T1QPABtqASil0fnXfr+bxueeEOtco8SVV5Bv6txBcZtLvq3m2HF9jwJLx9QIfBkgcTxJ3cuyg4h2kT7Z+Ma4Qttr0Uib2XRlV3m2pj+FEZ/IGY+0hx4Urn4fZ3U4Nip0aYXtsrtmWob0p4EE7RHEuuI6vlllAm3FbHVuwxCuEPkm2NRCNWKpa7rx7+DIt+0EHo17gCj+J2NxFhiYe6VLQc6hpqzSfU8C2zydbGFYDJbxOKZeZF4lEi4u2FVDsTSDKKJ1IE8stBb0azZ3CaBIOAojTLKojPlgBGH6kS0ipfR2J9lOzp7938YX3onhhj7rf9PoG6BWGi1YUSpIWHbc01BTasY4XNXhKwUEyGkOJH9CPojCBFKeCSiogz4myHA+GcFnZRgmTgo75aP2cmS2dsjORQ4zm+uuq9/HM2lmyiVfr9x6f+Qs1gW5T3LeFd2SXM6L1gQjzFqJRKKsEXKqtCNn4LdZLcUZg4pEGueYQEOX91ONzoFiS9WCE4CbnQeocgbGKKwmp5HuRQdIkauDH/0PglUiBOlvY6or5E+Ukr8ubtk79pDjRBoyrRAWsZfjNfQ8/64MMm+ItNoC/qVGnMasZ4eCOoClu0R3nlk9CrdEarPHSQuKxhVGWArgoGNhjc2d5a6R7p9jzhNSjKyV/cU03paFaXjt4DWGZpyP8bMwZmjM4oQFXkKOMpfOJTVBI
 3G0MIoiP
 hNoYeMdUk4n97HSYp5Qg3iMa8mTpDKgMh2uavt1Yist/IPRCLD/2+cNPSity5P8mlSm7fXEEUOfbQQp+WRXphSfyC7Zv3g7GANRg+lKqx4cL9LYEUNJv9+OqlXpO6X0F71Mopo7DtW2w4ANTpe5AQvhv7HnZvjUHYkHIgDJWnWQBeAs9iAuqAqAcs81dHOC3DuySulT4dJ6HBpvrQBSE9/oR7azZwq+ssK7hkBNYXysbRjotHrU70jd7HyVYLBpAj0w9OassOYNV8BDzffeBcxVg3yjhExm33sVTlYF6laR7hypkVlyS8TemylzVrmetzZYtZUjzoBOYhML4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 10:36=E2=80=AFAM Abhishek Bapat
<abhishekbapat@google.com> wrote:
>
> Introduce a kselftest to verify the new IOCTL-based interface for
> /proc/allocinfo. The test covers:
>
> 1. Validation of the filename filter.
> 2. Validation of the function filter.
>
> The first test validates the functionality of the filename filter. Using
> "mm/memory.c" as the candidate filename filter, it retrieves filtered
> entries from both procfs and ioctl and matches the first VEC_MAX_ENTRIES
> entries.
>
> The second test validates the functionality of the function filter.
> It uses "dup_mm" as the candidate function as we do not expect this
> function name to change frequently and hence won't be needing to modify
> this test often.
>
> Note that both the tests match line no, function name and file name
> fields. Bytes allocated and calls are not matched as those values may
> change in the time when the data is being read from procfs and ioctl and
> hence can lead to false negatives.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>  MAINTAINERS                                   |   1 +
>  tools/testing/selftests/Makefile              |   1 +
>  tools/testing/selftests/alloc_tag/Makefile    |   9 +
>  .../alloc_tag/allocinfo_ioctl_test.c          | 335 ++++++++++++++++++
>  4 files changed, 346 insertions(+)
>  create mode 100644 tools/testing/selftests/alloc_tag/Makefile
>  create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_tes=
t.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 019cc4c285a3..6610dd42e484 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16715,6 +16715,7 @@ F:      include/linux/alloc_tag.h
>  F:     include/linux/pgalloc_tag.h
>  F:     include/uapi/linux/alloc_tag.h
>  F:     lib/alloc_tag.c
> +F:     tools/testing/selftests/alloc_tag/
>
>  MEMORY CONTROLLER DRIVERS
>  M:     Krzysztof Kozlowski <krzk@kernel.org>
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/M=
akefile
> index 6e59b8f63e41..276a78c64736 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  TARGETS +=3D acct
> +TARGETS +=3D alloc_tag
>  TARGETS +=3D alsa
>  TARGETS +=3D amd-pstate
>  TARGETS +=3D arm64
> diff --git a/tools/testing/selftests/alloc_tag/Makefile b/tools/testing/s=
elftests/alloc_tag/Makefile
> new file mode 100644
> index 000000000000..f2b8fc022c3b
> --- /dev/null
> +++ b/tools/testing/selftests/alloc_tag/Makefile
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +TEST_GEN_PROGS :=3D allocinfo_ioctl_test
> +
> +CFLAGS +=3D -Wall
> +CFLAGS +=3D -I../../../../usr/include

I recall Hao suggested replacing this path with $(KHDR_INCLUDES). Have
you tried that?

> +
> +include ../lib.mk
> +
> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/t=
ools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> new file mode 100644
> index 000000000000..1ae0291f2245
> --- /dev/null
> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> @@ -0,0 +1,335 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +/* kselftest for allocinfo ioctl
> + * allocinfo ioctl retrives allocinfo data through ioctl
> + * Copyright (C) 2026 Google, Inc.
> + */
> +
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <stdbool.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <linux/types.h>
> +#include <linux/alloc_tag.h>
> +#include "../kselftest.h"
> +
> +#define MAX_LINE_LEN           512
> +#define ALLOCINFO_PROC         "/proc/allocinfo"
> +
> +enum ioctl_ret {
> +       IOCTL_SUCCESS =3D 0,
> +       IOCTL_FAILURE =3D 1,
> +       IOCTL_INVALID_DATA =3D 2,
> +};
> +
> +#define VEC_MAX_ENTRIES 32
> +
> +struct allocinfo_tag_data_vec {
> +       struct allocinfo_tag_data tag[VEC_MAX_ENTRIES];
> +       __u64 count;
> +};
> +
> +static inline int __allocinfo_get_content_id(int dev_fd, struct allocinf=
o_content_id *params)
> +{
> +       return ioctl(dev_fd, ALLOCINFO_IOC_CONTENT_ID, params);
> +}
> +
> +static inline int __allocinfo_get_at(int dev_fd, struct allocinfo_get_at=
 *params)
> +{
> +       return ioctl(dev_fd, ALLOCINFO_IOC_GET_AT, params);
> +}
> +
> +static inline int __allocinfo_get_next(int dev_fd, struct allocinfo_tag_=
data *params)
> +{
> +       return ioctl(dev_fd, ALLOCINFO_IOC_GET_NEXT, params);
> +}
> +
> +static bool match_entry(const struct allocinfo_tag_data *procfs_entry,
> +                       const struct allocinfo_tag_data *tag_data,
> +                       bool match_bytes, bool match_calls, bool match_li=
neno,
> +                       bool match_function, bool match_filename)
> +{
> +       if (match_bytes && tag_data->counter.bytes !=3D procfs_entry->cou=
nter.bytes) {
> +               ksft_print_msg("size retrieved through ioctl does not mat=
ch procfs\n");
> +               return false;
> +       }
> +
> +       if (match_calls && tag_data->counter.calls !=3D procfs_entry->cou=
nter.calls) {
> +               ksft_print_msg("call count retrieved through ioctl does n=
ot match procfs\n");
> +               return false;
> +       }
> +
> +       if (match_lineno && tag_data->tag.lineno !=3D procfs_entry->tag.l=
ineno) {
> +               ksft_print_msg("lineno retrieved through ioctl does not m=
atch procfs\n");
> +               return false;
> +       }
> +
> +       if (match_function &&
> +           strncmp(tag_data->tag.function, procfs_entry->tag.function, A=
LLOCINFO_STR_SIZE)) {
> +               ksft_print_msg("function retrieved through ioctl does not=
 match procfs\n");
> +               return false;
> +       }
> +
> +       if (match_filename &&
> +           strncmp(tag_data->tag.filename, procfs_entry->tag.filename, A=
LLOCINFO_STR_SIZE)) {
> +               ksft_print_msg("filename retrieved through ioctl does not=
 match procfs\n");
> +               return false;
> +       }
> +       return true;
> +}
> +
> +static bool match_entries(const struct allocinfo_tag_data_vec *procfs_en=
tries,
> +                         const struct allocinfo_tag_data_vec *tags,
> +                         bool match_bytes, bool match_calls, bool match_=
lineno,
> +                         bool match_function, bool match_filename)
> +{
> +       __u64 i;
> +
> +       if (procfs_entries->count !=3D tags->count) {
> +               ksft_print_msg("Entry count mismatch. ioctl entries: %llu=
, proc entries: %llu\n",
> +                              tags->count, procfs_entries->count);
> +               return false;
> +       }
> +       for (i =3D 0; i < procfs_entries->count; i++) {
> +               if (!match_entry(&procfs_entries->tag[i], &tags->tag[i],
> +                                match_bytes, match_calls, match_lineno,
> +                                match_function, match_filename)) {
> +                       ksft_print_msg("%lluth entry does not match.\n", =
i);
> +                       return false;
> +               }
> +       }
> +       return true;
> +}
> +
> +static const char *allocinfo_str(const char *str)
> +{
> +       size_t len =3D strlen(str);
> +
> +       if (len >=3D ALLOCINFO_STR_SIZE)
> +               str +=3D (len - ALLOCINFO_STR_SIZE) + 1;
> +       return str;
> +}
> +
> +static void allocinfo_copy_str(char *dest, const char *src)
> +{
> +       strncpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE - 1);
> +       dest[ALLOCINFO_STR_SIZE - 1] =3D '\0';
> +}
> +
> +static int get_filtered_procfs_entries(struct allocinfo_tag_data_vec *pr=
ocfs_entries,
> +                                      const struct allocinfo_filter *fil=
ter)
> +{
> +       FILE *fp =3D fopen(ALLOCINFO_PROC, "r");
> +       char line[MAX_LINE_LEN];
> +       int matches;
> +       struct allocinfo_tag_data procfs_entry;
> +
> +       if (!fp) {
> +               ksft_print_msg("Failed to open " ALLOCINFO_PROC " for rea=
ding\n");
> +               return 1;
> +       }
> +       memset(procfs_entries, 0, sizeof(*procfs_entries));
> +       while (fgets(line, sizeof(line), fp) && procfs_entries->count < V=
EC_MAX_ENTRIES) {
> +               char filename[MAX_LINE_LEN];
> +               char function[MAX_LINE_LEN];
> +
> +               memset(&procfs_entry, 0, sizeof(procfs_entry));
> +               matches =3D sscanf(line, "%llu %llu %[^:]:%llu func:%s",
> +                                &procfs_entry.counter.bytes,
> +                                &procfs_entry.counter.calls,
> +                                filename,
> +                                &procfs_entry.tag.lineno,
> +                                function);
> +
> +               if (matches !=3D 5)
> +                       continue;
> +
> +               allocinfo_copy_str(procfs_entry.tag.filename, filename);
> +               allocinfo_copy_str(procfs_entry.tag.function, function);
> +
> +               if (filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) {
> +                       if (strncmp(procfs_entry.tag.filename,
> +                                   filter->fields.filename, ALLOCINFO_ST=
R_SIZE))
> +                               continue;
> +               }
> +               if (filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) {
> +                       if (strncmp(procfs_entry.tag.function,
> +                                   filter->fields.function, ALLOCINFO_ST=
R_SIZE))
> +                               continue;
> +               }
> +               if (filter->mask & ALLOCINFO_FILTER_MASK_LINENO) {
> +                       if (procfs_entry.tag.lineno !=3D filter->fields.l=
ineno)
> +                               continue;
> +               }
> +               if (filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) {
> +                       if (procfs_entry.counter.bytes < filter->min_size=
)
> +                               continue;
> +               }
> +               if (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) {
> +                       if (procfs_entry.counter.bytes > filter->max_size=
)
> +                               continue;
> +               }
> +
> +               memcpy(&procfs_entries->tag[procfs_entries->count++], &pr=
ocfs_entry,
> +                      sizeof(procfs_entry));
> +       }
> +       fclose(fp);
> +       return 0;
> +}
> +
> +static enum ioctl_ret get_filtered_ioctl_entries(struct allocinfo_tag_da=
ta_vec *tags,
> +                                                const struct allocinfo_f=
ilter *filter,
> +                                                __u64 start_pos)
> +{
> +       int fd =3D open(ALLOCINFO_PROC, O_RDONLY);
> +
> +       if (fd < 0) {
> +               ksft_print_msg("Failed to open " ALLOCINFO_PROC " for IOC=
TL\n");
> +               return IOCTL_FAILURE;
> +       }
> +
> +       struct allocinfo_content_id start_cont_id, end_cont_id;
> +       struct allocinfo_get_at get_at_params;
> +       const int max_retries =3D 10;
> +       int retry_count =3D 0;
> +       int status;
> +
> +       /*
> +        * __allocinfo_get_content_id may return different values if a ke=
rnel module was loaded
> +        * between the two calls. If that happens, the data gathered cann=
ot be considered consistent
> +        * and hence needs to be fetched again to avoid flakiness.
> +        */
> +       do {
> +               if (__allocinfo_get_content_id(fd, &start_cont_id)) {
> +                       ksft_print_msg("allocinfo_get_content_id failed\n=
");
> +                       status =3D IOCTL_FAILURE;
> +                       goto exit;

nit: I would prefer a "break" instead of these "goto exit" statements
for exiting this loop. Makes the code flow more readable IMHO.

> +               }
> +
> +               memset(tags, 0, sizeof(*tags));
> +               memset(&get_at_params, 0, sizeof(get_at_params));
> +               memcpy(&get_at_params.filter, filter, sizeof(*filter));
> +               get_at_params.pos =3D start_pos;
> +               if (__allocinfo_get_at(fd, &get_at_params)) {
> +                       ksft_print_msg("allocinfo_get_at failed\n");
> +                       status =3D IOCTL_FAILURE;
> +                       goto exit;
> +               }
> +               memcpy(&tags->tag[tags->count++], &get_at_params.data, si=
zeof(get_at_params.data));
> +
> +               while (tags->count < VEC_MAX_ENTRIES &&
> +                      __allocinfo_get_next(fd, &tags->tag[tags->count]) =
=3D=3D 0)
> +                       tags->count++;
> +
> +               if (__allocinfo_get_content_id(fd, &end_cont_id)) {
> +                       ksft_print_msg("allocinfo_get_content_id failed\n=
");
> +                       status =3D IOCTL_FAILURE;
> +                       goto exit;
> +               }
> +
> +               if (start_cont_id.id =3D=3D end_cont_id.id) {
> +                       status =3D IOCTL_SUCCESS;
> +               } else {
> +                       ksft_print_msg("allocinfo_get_content_id mismatch=
, retrying...\n");
> +                       status =3D IOCTL_INVALID_DATA;
> +               }
> +       } while (status =3D=3D IOCTL_INVALID_DATA && retry_count++ < max_=
retries);
> +
> +exit:
> +       close(fd);
> +       return status;
> +}
> +
> +static int run_filter_test(const struct allocinfo_filter *filter)
> +{
> +       struct allocinfo_tag_data_vec *tags =3D malloc(sizeof(*tags));
> +       struct allocinfo_tag_data_vec *procfs_entries =3D malloc(sizeof(*=
procfs_entries));
> +       int ioctl_status;
> +       int ret =3D KSFT_PASS;
> +
> +       if (!tags || !procfs_entries) {
> +               ksft_print_msg("Memory allocation failed.\n");
> +               ret =3D KSFT_FAIL;
> +               goto exit;
> +       }
> +
> +       if (get_filtered_procfs_entries(procfs_entries, filter)) {
> +               ksft_print_msg("Error retrieving entries from " ALLOCINFO=
_PROC "\n");
> +               ret =3D KSFT_SKIP;
> +               goto exit;
> +       }
> +
> +       if (procfs_entries->count =3D=3D 0) {
> +               ksft_print_msg("No entries found in " ALLOCINFO_PROC ", s=
kipping test\n");
> +               ret =3D KSFT_SKIP;
> +               goto exit;
> +       }
> +
> +       ioctl_status =3D get_filtered_ioctl_entries(tags, filter, 0);
> +       if (ioctl_status =3D=3D IOCTL_INVALID_DATA) {
> +               ksft_print_msg("Trouble retrieving valid IOCTL entries, s=
kipping.\n");
> +               ret =3D KSFT_SKIP;
> +               goto exit;
> +       }
> +       if (ioctl_status =3D=3D IOCTL_FAILURE) {
> +               ksft_print_msg("Error retrieving IOCTL entries.\n");
> +               ret =3D KSFT_FAIL;
> +               goto exit;
> +       }
> +
> +       if (!match_entries(procfs_entries, tags, false, false, true, true=
, true))
> +               ret =3D KSFT_FAIL;
> +
> +exit:
> +       free(tags);
> +       free(procfs_entries);
> +       return ret;
> +}
> +
> +static int test_filename_filter(void)
> +{
> +       struct allocinfo_filter filter;
> +       const char *target_filename =3D "mm/memory.c";
> +
> +       memset(&filter, 0, sizeof(filter));
> +       filter.mask |=3D ALLOCINFO_FILTER_MASK_FILENAME;
> +       strncpy(filter.fields.filename, target_filename, ALLOCINFO_STR_SI=
ZE);
> +
> +       return run_filter_test(&filter);
> +}
> +
> +static int test_function_filter(void)
> +{
> +       struct allocinfo_filter filter;
> +       const char *target_function =3D "dup_mm";
> +
> +       memset(&filter, 0, sizeof(filter));
> +       filter.mask |=3D ALLOCINFO_FILTER_MASK_FUNCTION;
> +       strncpy(filter.fields.function, target_function, ALLOCINFO_STR_SI=
ZE);
> +
> +       return run_filter_test(&filter);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       int ret;
> +
> +       ksft_set_plan(2);
> +
> +       ret =3D test_filename_filter();
> +       if (ret =3D=3D KSFT_SKIP)
> +               ksft_test_result_skip("Skipping test_filename_filter\n");
> +       else
> +               ksft_test_result(ret =3D=3D KSFT_PASS, "test_filename_fil=
ter\n");
> +
> +       ret =3D test_function_filter();
> +       if (ret =3D=3D KSFT_SKIP)
> +               ksft_test_result_skip("Skipping test_function_filter\n");
> +       else
> +               ksft_test_result(ret =3D=3D KSFT_PASS, "test_function_fil=
ter\n");
> +
> +       ksft_finished();
> +}
> --
> 2.55.0.rc0.786.g65d90a0328-goog
>

