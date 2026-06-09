Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B408CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 20:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5326B00EA; Tue,  9 Jun 2026 16:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AACA66B00EC; Tue,  9 Jun 2026 16:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B406B00EE; Tue,  9 Jun 2026 16:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86B6D6B00EA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:54:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22B071207D1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:54:27 +0000 (UTC)
X-FDA: 84861577374.10.219BA75
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id EC7A340009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:54:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jJaTEy3t;
	spf=pass (imf04.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781038465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqqw2hwIdYKgB5JLRszYpZYql7zN6WelT6xH9FGqWa0=;
	b=EYdRMBM9XgDEuLy2pkBx/YdOzRInkWT6/c9im5uLbd30guu6Ev+eKMxSGtfCqi2av1u0QZ
	xJFy1DCLwlrooGUgM6gvs6vsbY/70W35aJllWXfjm+M/qqBcaib8PS33r+P/+ypzwcsuUD
	9gx5xEnHmDMhG5GTpBVMJRD+rtvXcKQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781038465;
	b=K5f8n0TwqjtzpZwe77bKXGEptIHkpAwS7Xzb8aesIwZXep37w8oUs2C+nnBOQqGaZdiz01
	R6oISDrKgIskNIpNb53Qoqnz4iat9w17iIrCavdibZiQMJlo3ooW6UimQ41kciqG2aoDO0
	nscXOFXexPhH9aFK5BHggf79FgwsVMs=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jJaTEy3t;
	spf=pass (imf04.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2bf2d865383so4595ad.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 13:54:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781038464; cv=none;
        d=google.com; s=arc-20240605;
        b=IbZ6nlOViDXdfKOaSQTqDCH2c4Pz5szuDtRyBdWfOVrOwWZQ7rjDNOZz1FsSe2t+y9
         H6Xi2kLDCFn2f9AY3yJnu7WycTjcithg/aH7MmgIrMzSYjScPuhuYFUntz6SwFUfkSqR
         vXBs2o7fQbkqgYUamXYo1JuH9WR7HOq96Emd9SBhctytziGEw9nqtFf4p8c5Hu8lanct
         Oe+d0HdFIl/GG/53hITLqIgn2wdCndO3MZol7Q4ko0aGKkhxr/4cdYRruX0Gvbc6ZOiQ
         dBNPZ2/RtBct9peU9CNpVXVQ82f21DSdruYoPBczw6UgaWkLtSmia1JkkuFU8wQHCXbE
         3QbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tqqw2hwIdYKgB5JLRszYpZYql7zN6WelT6xH9FGqWa0=;
        fh=6uX1VeisVFF2dqt39xjGHfB6q7Yb+wq9Xn2srkhxoU4=;
        b=ZEpfq5G9dJB2Ja+PyVxlXGwa97y1a0VkRF0dKGVdjuY67L79QfFPjR5mDCUySCAWQp
         9jERAArK6xWd4c4nNV+OrqXL7bOaMRd3FrpRmu1AIbqSKdlpjXOcbHhZ3HMPDOM2htAH
         Qdea91PqSTkJx1mDxGWSStx5tlwpZGGGKsnvZiST/gvV/ulIb5lmPI73zPqFnq6CiQ74
         TPz4GK85tm5YVLzu07p6ufYBjO/Od4FYEnkwFPDkw0cXdrE/fUaExcRFTaV0fm12GInO
         SRWW2TrG0NTWWWy6aDphyuE8i7yQntjMXR+KvuBLGhuQ4eOrTOaEY8k/wwSKCizWu17n
         aACA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781038464; x=1781643264; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqqw2hwIdYKgB5JLRszYpZYql7zN6WelT6xH9FGqWa0=;
        b=jJaTEy3tXMzbo6K+EiQfad5NQsrmdBWCxVzN3PO78YCIjX8D0a8oO7avSIKXKETTAE
         xJKzhvY3zoRYz8DZ8DxhYaKfQbKCZWtjH/1T7s93RTwDSf4OhlgoFot9FOuorQL4JDSN
         ztEDf7rM79n4+6BD7Bad2+uuL9HU9rXr+X7IbiOE1YOl2LYBCwvJ1xKV/5GP5r2+8JPP
         8I3Er+l1Fhqh4aMNNvA5TALodkB6x2H66kuXXU0Ru2AV6dzf1zeYI/NNW3ijWEcP+6SR
         wbTcYu2efF9rYI/kSv9f+ki/wpUKP0VJTrrNNHsfVn5002fwKlGS1+kuwCTWFWY89Tsq
         iwKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781038464; x=1781643264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tqqw2hwIdYKgB5JLRszYpZYql7zN6WelT6xH9FGqWa0=;
        b=VjFs90FFoM911yABojRfpAw7fXC4o4GsRSHShFB9QU9KS/LkWuU4bdHNIw5leO89Ah
         5fnBoOHjNRJFYv+pOT4bzRzN+/xjWnHIKYKNzYvORMrb7LTjtZKjxLelSHcj0JogEfAa
         JZO7Alv56m2qc3xYaZODn6MK+5Out+C9ledGJ/GlgMxMTDXewIsyUSUgbWPVFN1BZAor
         RUJsIgCJsHqnz27tdXzK7x11gsji5npcTJZvYM2uEuufT4f2XJYyb94XYkrS2SFygv5L
         iT+ZmkLJyPkZlhUSf44rsrpvB+xiUIfc0DnxIbcpGTLHnmtt9Aumadsv6YhdZ4UP7dD6
         qU+A==
X-Forwarded-Encrypted: i=1; AFNElJ+Us+aHRHyNx3+Z8dbhZy1nWn4qtMJGCgQC5CYUmkfey7CiV72T6FNrK5WM2Vnupf5MRCSeoi+p5g==@kvack.org
X-Gm-Message-State: AOJu0Yxqm/y2PRzQXOE9OoTUxVpyY/b7vv2hQZZrAd4J14MmnJ2sKG6A
	8OUE0+I2W+eXpUWKAyr2Fqa6HHE+l+myxKUdn8Ceoq4Us2yA1iFCNdeGpnrbeXYS5CHjDo9vaiA
	5CyUbbxnmX5K/sNN9X/xt/mU/Oqlo2eiDMywlrNHI
X-Gm-Gg: Acq92OEbD0xZ5Meq3YEMmI4xDHEI8vpP58SpuMZuxHhCeIkPVZWNKu44icInXHRl768
	/WlNSADn513H/OLAUzVOsj+dsSiK+OW+6TzVI28xC3ltYFj1/o174pyM4KGzMUabyIWi3xyzPGt
	a4MdFU784/hanam4zUKq8WevKcq24jcZZo5hZEnrJz25TswGhHWXFCxjEm60ETSx0iaCSEuR07x
	asVPaNLiWiY+WHtmMX4LXZIZUIhwr6Xop+LNVyX4iJprYrGvgpTeX09FqPO9XwzV5WJfE+1zFbB
	/gwfP9m0mwCcW+XoeB9nChc4L0xTXTcX2lYoz62gw0MvgPY8
X-Received: by 2002:a17:902:cf0b:b0:2c1:68ba:aa7b with SMTP id
 d9443c01a7336-2c1ebfd6b21mr8209025ad.20.1781038463230; Tue, 09 Jun 2026
 13:54:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
 <2e55b3b1388a4f7a59f670a83f222ba6c836ac4e.1780701922.git.abhishekbapat@google.com>
 <49f725a7-577d-4036-bd5a-5a33fc9e17c3@linux.dev> <26193499-e9dd-45e7-afc2-365685d6a749@linux.dev>
In-Reply-To: <26193499-e9dd-45e7-afc2-365685d6a749@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Tue, 9 Jun 2026 13:54:12 -0700
X-Gm-Features: AVVi8CdOb3SxpKX0t1hUfhz3i-rs5b_W0BECNgZZ22bjrm9-dLjLeFjugSjrW90
Message-ID: <CAL41Mv7Pg4jMeFc=nnpBntv11y=J=N-pj-DGCrWLvQgyQwwcGQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] kselftest: alloc_tag: add kselftest for ioctl interface
To: Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC7A340009
X-Stat-Signature: 4j5rrz7wxggig1gskke58curfta8qgwd
X-HE-Tag: 1781038464-885916
X-HE-Meta: U2FsdGVkX1/KbELaXBqJEFFDK0VEyXmmqYsTUynv8VjV7LJoLPnmZ3NnTATP1pI0bPRhrHwTqfkKl2Dil/g4LIVj0UwiJj4qZ0bNSZ0+hZwQWZlbojcIJRRV95rJIix3cFz2X6WlcAIHdFeiZVgwS+0sCdnZ07zvNgRKN2JPbV3H12LtHncrOr3/Lh70wABXUchGuU7gn0vGUEDqxahS5Rnj1x8BMWn0LX/so5xCG0cA2o7bEMJInxaMhZYWy4EqfzLvY2W6O3789kDy7FHZB3pow1M4gvUoqm/SfXChuaAnZnXtajJOgghtSEg/nx5cs8Mm4q1ZxZqdwAVikV+kzQPrySjdoON4VrQcV5jVK2+3BgQZRBFnmzY2l81A5WZFHvlx6CgUZKuz5ZM0zrfoyzTF/O0gNQzO/R88l8TfylJpJeQo2MPz6PcnRLBVIRA9RdbjRDT/9f47c6BlVGnjn2zkEnPkW56phglCsEc1uNHBvygIjbvTtuYEUQeFCZwXt8sej5VLHtnFxwDxfW1uQVeo8EFkw0zp5O1ppLQ4tZZhXu33qXISCyNFLMZWpQErNQf5ge7k7eNsEeeqfl6tzS7t7NhVwshubI3YQDEJnfXIjmSQYiJkWORmVXO4DgTR9gRXW2qNCBjIqFr3cuQuiT5pUD8peNn+78s7sho5MtGRe4s5elRYiXSYLqEIDm1UQX6KzrBM0H79PaTqrgQhPf0x8LFxts+vHOnxrwOtXxjiSuGk6aZJERrgBUKpVutz1kebZzv7l2BHDqOaAhZ41VoGUTITwNYuPEN0VxN7Wca8SUa4z/MdEYNDsknA2DVnTCngyBuh1vOcacc+gi4oW/X60GgALquQt1cTcJ+F1ZotbqSykdwBktlgd/TC4TBmEba1n60xqOd4t/PyXLswRDxjXmrL9lbcdh4uzgMhgDUxAxYCRmNiD/dOwxYu1JzRtnYNmgQOHaFZeEf/Nbd
 Z1s2jqt8
 c0YspqrQ91gHBCeHD7zgcdy59tiduFmT136EGnMu2dW1tKR+flovuyc1XEqzOqeE+o0XovzKHJBP0qZXjNLK8N6RO8I+RArGGiwAJQ0D2BSof0pydn6GLhnGHj+oS7ee2Q4EqjzmJfkov1WSuJDfE6D5SHeA0GMdq4J0MHBk9G48BcPvTp5LvqVw8Ykf9DjUW5LDmjFTGA68csKtv4e+B9WptZusF+UPL8pi5XQM2wMd5NfvAhZcmnVWJ8T6zr+oR8OX21/eMhHfY9YZTOImcQfoMI8jqnWn70PVS3jiT6Qd+ASXHU8DvxDK6rjF1FAtr3rXizAb4PPoJM8qdnE8/EKtlOjBvKKdQT7DqqcOgfColPeAlcJY94Vl9bVa5Y2Z54ZTpbOibkOaipi7Im89PlLuCdBFCBr5sb37K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 11:27=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
>
> On 2026/6/9 14:09, Hao Ge wrote:
> > Hi Abhishek
> >
> >
> > On 2026/6/6 07:36, Abhishek Bapat wrote:
> >> Introduce a kselftest to verify the new IOCTL-based interface for
> >> /proc/allocinfo. The test covers:
> >>
> >> 1. Validation of the filename filter.
> >> 2. Validation of the function filter.
> >>
> >> The first test validates the functionality of the filename filter. Usi=
ng
> >> "mm/memory.c" as the candidate filename filter, it retrieves filtered
> >> entries from both procfs and ioctl and matches the first VEC_MAX_ENTRI=
ES
> >> entries.
> >>
> >> The second test validates the functionality of the function filter.
> >> It uses "dup_mm" as the candidate function as we do not expect this
> >> function name to change frequently and hence won't be needing to modif=
y
> >> this test often.
> >>
> >> Note that both the tests match line no, function name and file name
> >> fields. Bytes allocated and calls are not matched as those values may
> >> change in the time when the data is being read from procfs and ioctl a=
nd
> >> hence can lead to false negatives.
> >>
> >> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> >> ---
> >>   MAINTAINERS                                   |   1 +
> >>   tools/testing/selftests/alloc_tag/Makefile    |   9 +
> >>   .../alloc_tag/allocinfo_ioctl_test.c          | 313 ++++++++++++++++=
++
> >>   3 files changed, 323 insertions(+)
> >>   create mode 100644 tools/testing/selftests/alloc_tag/Makefile
> >>   create mode 100644
> >> tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 77f3fc487691..80560f5f1292 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -16713,6 +16713,7 @@ F:    include/linux/alloc_tag.h
> >>   F:    include/linux/pgalloc_tag.h
> >>   F:    include/uapi/linux/alloc_tag.h
> >>   F:    lib/alloc_tag.c
> >> +F:    tools/testing/selftests/alloc_tag/
> >>     MEMORY CONTROLLER DRIVERS
> >>   M:    Krzysztof Kozlowski <krzk@kernel.org>
> >> diff --git a/tools/testing/selftests/alloc_tag/Makefile
> >> b/tools/testing/selftests/alloc_tag/Makefile
> >> new file mode 100644
> >> index 000000000000..f2b8fc022c3b
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/alloc_tag/Makefile
> >> @@ -0,0 +1,9 @@
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +
> >> +TEST_GEN_PROGS :=3D allocinfo_ioctl_test
> >> +
> >> +CFLAGS +=3D -Wall
> >> +CFLAGS +=3D -I../../../../usr/include
> >> +
> >> +include ../lib.mk
> >> +
> >> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> >> b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> >> new file mode 100644
> >> index 000000000000..5c3c16e86c23
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> >> @@ -0,0 +1,313 @@
> >> +// SPDX-License-Identifier: GPL-2.0-only
> >> +
> >> +/* kselftest for allocinfo ioctl
> >> + * allocinfo ioctl retrives allocinfo data through ioctl
> >
> >
> > nit: s/retrives/retrieves/
> >
> >
> > I've applied the full patch series locally and ran the kselftest, all
> > 4 tests pass:
> >
> > [root@localhost alloc_tag]# ./allocinfo_ioctl_test
> > 1..4
> > ok 1 test_filename_filter
> > ok 2 test_function_filter
> > ok 3 test_size_filter
> > ok 4 test_lineno_filter
> > # Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0
> >
> > But there are no tests for ALLOCINFO_FILTER_MASK_MODNAME and
> >
> > ALLOCINFO_FILTER_MASK_INACCURATE.
>
>
> Sorry, please disregard my suggestion about adding tests for
>
> ALLOCINFO_FILTER_MASK_MODNAME and ALLOCINFO_FILTER_MASK_INACCURATE.
>
> ALLOCINFO_FILTER_MASK_MODNAME depends on kernel config and also requires
>
> the module to be loaded. ALLOCINFO_FILTER_MASK_INACCURATE entries may not
>
> be common, unless we can find a stable way to produce them.
>
>
Ack, those are non-trivial to repro and hence we left them out.
> >
> >
> > Thanks
> >
> > Best Regards
> >
> > Hao
> >
> >> + * Copyright (C) 2026 Google, Inc.
> >> + */
> >> +
> >> +#include <errno.h>
> >> +#include <fcntl.h>
> >> +#include <stdio.h>
> >> +#include <stdlib.h>
> >> +#include <string.h>
> >> +#include <stdbool.h>
> >> +#include <unistd.h>
> >> +#include <sys/ioctl.h>
> >> +#include <linux/types.h>
> >> +#include <linux/alloc_tag.h>
> >> +#include "../kselftest.h"
> >> +
> >> +#define MAX_LINE_LEN        512
> >> +#define ALLOCINFO_PROC        "/proc/allocinfo"
> >> +
> >> +enum ioctl_ret {
> >> +    IOCTL_SUCCESS =3D 0,
> >> +    IOCTL_FAILURE =3D 1,
> >> +    IOCTL_INVALID_DATA =3D 2,
> >> +};
> >> +
> >> +#define VEC_MAX_ENTRIES 32
> >> +
> >> +struct allocinfo_tag_data_vec {
> >> +    struct allocinfo_tag_data tag[VEC_MAX_ENTRIES];
> >> +    __u64 count;
> >> +};
> >> +
> >> +static inline int __allocinfo_get_content_id(int dev_fd, struct
> >> allocinfo_content_id *params)
> >> +{
> >> +    return ioctl(dev_fd, ALLOCINFO_IOC_CONTENT_ID, params);
> >> +}
> >> +
> >> +static inline int __allocinfo_get_at(int dev_fd, struct
> >> allocinfo_get_at *params)
> >> +{
> >> +    return ioctl(dev_fd, ALLOCINFO_IOC_GET_AT, params);
> >> +}
> >> +
> >> +static inline int __allocinfo_get_next(int dev_fd, struct
> >> allocinfo_tag_data *params)
> >> +{
> >> +    return ioctl(dev_fd, ALLOCINFO_IOC_GET_NEXT, params);
> >> +}
> >> +
> >> +static bool match_entry(const struct allocinfo_tag_data *procfs_entry=
,
> >> +            const struct allocinfo_tag_data *tag_data,
> >> +            bool match_bytes, bool match_calls, bool match_lineno,
> >> +            bool match_function, bool match_filename)
> >> +{
> >> +    if (match_bytes && tag_data->counter.bytes !=3D
> >> procfs_entry->counter.bytes) {
> >> +        ksft_print_msg("size retrieved through ioctl does not match
> >> procfs\n");
> >> +        return false;
> >> +    }
> >> +
> >> +    if (match_calls && tag_data->counter.calls !=3D
> >> procfs_entry->counter.calls) {
> >> +        ksft_print_msg("call count retrieved through ioctl does not
> >> match procfs\n");
> >> +        return false;
> >> +    }
> >> +
> >> +    if (match_lineno && tag_data->tag.lineno !=3D
> >> procfs_entry->tag.lineno) {
> >> +        ksft_print_msg("lineno retrieved through ioctl does not
> >> match procfs\n");
> >> +        return false;
> >> +    }
> >> +
> >> +    if (match_function &&
> >> +        strncmp(tag_data->tag.function, procfs_entry->tag.function,
> >> ALLOCINFO_STR_SIZE)) {
> >> +        ksft_print_msg("function retrieved through ioctl does not
> >> match procfs\n");
> >> +        return false;
> >> +    }
> >> +
> >> +    if (match_filename &&
> >> +        strncmp(tag_data->tag.filename, procfs_entry->tag.filename,
> >> ALLOCINFO_STR_SIZE)) {
> >> +        ksft_print_msg("filename retrieved through ioctl does not
> >> match procfs\n");
> >> +        return false;
> >> +    }
> >> +    return true;
> >> +}
> >> +
> >> +static bool match_entries(const struct allocinfo_tag_data_vec
> >> *procfs_entries,
> >> +              const struct allocinfo_tag_data_vec *tags,
> >> +              bool match_bytes, bool match_calls, bool match_lineno,
> >> +              bool match_function, bool match_filename)
> >> +{
> >> +    __u64 i;
> >> +
> >> +    if (procfs_entries->count !=3D tags->count) {
> >> +        ksft_print_msg("Entry count mismatch. ioctl entries: %llu,
> >> proc entries: %llu\n",
> >> +                   tags->count, procfs_entries->count);
> >> +        return false;
> >> +    }
> >> +    for (i =3D 0; i < procfs_entries->count; i++) {
> >> +        if (!match_entry(&procfs_entries->tag[i], &tags->tag[i],
> >> +                 match_bytes, match_calls, match_lineno,
> >> +                 match_function, match_filename)) {
> >> +            ksft_print_msg("%lluth entry does not match.\n", i);
> >> +            return false;
> >> +        }
> >> +    }
> >> +    return true;
> >> +}
> >> +
> >> +static int get_filtered_procfs_entries(struct allocinfo_tag_data_vec
> >> *procfs_entries,
> >> +                       const struct allocinfo_filter *filter, int fd)
> >> +{
> >> +    FILE *fp =3D fdopen(fd, "r");
> >> +    char line[MAX_LINE_LEN];
> >> +    int matches;
> >> +    struct allocinfo_tag_data procfs_entry;
> >> +
> >> +    if (!fp) {
> >> +        ksft_print_msg("Failed to open " ALLOCINFO_PROC " for
> >> reading\n");
> >> +        return 1;
> >> +    }
> >> +    memset(procfs_entries, 0, sizeof(*procfs_entries));
> >> +    while (fgets(line, sizeof(line), fp) && procfs_entries->count <
> >> VEC_MAX_ENTRIES) {
> >> +
> >> +        memset(&procfs_entry, 0, sizeof(procfs_entry));
> >> +        matches =3D sscanf(line, "%llu %llu %[^:]:%llu func:%s",
> >> +                 &procfs_entry.counter.bytes,
> >> +                 &procfs_entry.counter.calls,
> >> +                 procfs_entry.tag.filename,
> >> +                 &procfs_entry.tag.lineno,
> >> +                 procfs_entry.tag.function);
> >> +
> >> +        if (matches !=3D 5)
> >> +            continue;
> >> +
> >> +        if (filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) {
> >> +            if (strncmp(procfs_entry.tag.filename,
> >> +                    filter->fields.filename, ALLOCINFO_STR_SIZE))
> >> +                continue;
> >> +        }
> >> +        if (filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) {
> >> +            if (strncmp(procfs_entry.tag.function,
> >> +                    filter->fields.function, ALLOCINFO_STR_SIZE))
> >> +                continue;
> >> +        }
> >> +        if (filter->mask & ALLOCINFO_FILTER_MASK_LINENO) {
> >> +            if (procfs_entry.tag.lineno !=3D filter->fields.lineno)
> >> +                continue;
> >> +        }
> >> +        if (filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) {
> >> +            if (procfs_entry.counter.bytes < filter->min_size)
> >> +                continue;
> >> +        }
> >> +        if (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) {
> >> +            if (procfs_entry.counter.bytes > filter->max_size)
> >> +                continue;
> >> +        }
> >> +
> >> + memcpy(&procfs_entries->tag[procfs_entries->count++], &procfs_entry,
> >> +               sizeof(procfs_entry));
> >> +    }
> >> +    return 0;
> >> +}
> >> +
> >> +static enum ioctl_ret get_filtered_ioctl_entries(struct
> >> allocinfo_tag_data_vec *tags,
> >> +                         const struct allocinfo_filter *filter, int f=
d,
> >> +                         __u64 start_pos)
> >> +{
> >> +    struct allocinfo_content_id start_cont_id, end_cont_id;
> >> +    struct allocinfo_get_at get_at_params;
> >> +    const int max_retries =3D 10;
> >> +    int retry_count =3D 0;
> >> +    int status;
> >> +
> >> +    /*
> >> +     * __allocinfo_get_content_id may return different values if a
> >> kernel module was loaded
> >> +     * between the two calls. If that happens, the data gathered
> >> cannot be considered consistent
> >> +     * and hence needs to be fetched again to avoid flakiness.
> >> +     */
> >> +    do {
> >> +        if (__allocinfo_get_content_id(fd, &start_cont_id)) {
> >> +            ksft_print_msg("allocinfo_get_content_id failed\n");
> >> +            return IOCTL_FAILURE;
> >> +        }
> >> +
> >> +        memset(tags, 0, sizeof(*tags));
> >> +        memset(&get_at_params, 0, sizeof(get_at_params));
> >> +        memcpy(&get_at_params.filter, filter, sizeof(*filter));
> >> +        get_at_params.pos =3D start_pos;
> >> +        if (__allocinfo_get_at(fd, &get_at_params)) {
> >> +            ksft_print_msg("allocinfo_get_at failed\n");
> >> +            return IOCTL_FAILURE;
> >> +        }
> >> +        memcpy(&tags->tag[tags->count++], &get_at_params.data,
> >> sizeof(get_at_params.data));
> >> +
> >> +        while (tags->count < VEC_MAX_ENTRIES &&
> >> +               __allocinfo_get_next(fd, &tags->tag[tags->count]) =3D=
=3D 0)
> >> +            tags->count++;
> >> +
> >> +        if (__allocinfo_get_content_id(fd, &end_cont_id)) {
> >> +            ksft_print_msg("allocinfo_get_content_id failed\n");
> >> +            return IOCTL_FAILURE;
> >> +        }
> >> +
> >> +        if (start_cont_id.id =3D=3D end_cont_id.id) {
> >> +            status =3D IOCTL_SUCCESS;
> >> +        } else {
> >> +            ksft_print_msg("allocinfo_get_content_id mismatch,
> >> retrying...\n");
> >> +            status =3D IOCTL_INVALID_DATA;
> >> +        }
> >> +    } while (status =3D=3D IOCTL_INVALID_DATA && retry_count++ <
> >> max_retries);
> >> +
> >> +    return status;
> >> +}
> >> +
> >> +static int run_filter_test(const struct allocinfo_filter *filter)
> >> +{
> >> +    int fd;
> >> +    struct allocinfo_tag_data_vec *tags =3D malloc(sizeof(*tags));
> >> +    struct allocinfo_tag_data_vec *procfs_entries =3D
> >> malloc(sizeof(*procfs_entries));
> >> +    int ioctl_status;
> >> +    int ret =3D KSFT_PASS;
> >> +
> >> +    if (!tags || !procfs_entries) {
> >> +        ksft_print_msg("Memory allocation failed.\n");
> >> +        ret =3D KSFT_FAIL;
> >> +        goto freemem;
> >> +    }
> >> +
> >> +    fd =3D open(ALLOCINFO_PROC, O_RDONLY);
> >> +    if (fd < 0) {
> >> +        ksft_exit_skip("Failed to open " ALLOCINFO_PROC ": %s\n",
> >> strerror(errno));
> >> +        ret =3D KSFT_FAIL;
> >> +        goto freemem;
> >> +    }
> >> +
> >> +    if (get_filtered_procfs_entries(procfs_entries, filter, fd)) {
> >> +        ksft_print_msg("Error retrieving entries from "
> >> ALLOCINFO_PROC "\n");
> >> +        ret =3D KSFT_FAIL;
> >> +        goto exit;
> >> +    }
> >> +
> >> +    if (procfs_entries->count =3D=3D 0) {
> >> +        ksft_print_msg("No entries found in " ALLOCINFO_PROC ",
> >> skipping test\n");
> >> +        ret =3D KSFT_SKIP;
> >> +        goto exit;
> >> +    }
> >> +
> >> +    ioctl_status =3D get_filtered_ioctl_entries(tags, filter, fd, 0);
> >> +    if (ioctl_status =3D=3D IOCTL_INVALID_DATA) {
> >> +        ksft_print_msg("Trouble retrieving valid IOCTL entries,
> >> skipping.\n");
> >> +        ret =3D KSFT_SKIP;
> >> +        goto exit;
> >> +    }
> >> +    if (ioctl_status =3D=3D IOCTL_FAILURE) {
> >> +        ksft_print_msg("Error retrieving IOCTL entries.\n");
> >> +        ret =3D KSFT_FAIL;
> >> +        goto exit;
> >> +    }
> >> +
> >> +    if (!match_entries(procfs_entries, tags, false, false, true,
> >> true, true))
> >> +        ret =3D KSFT_FAIL;
> >> +
> >> +exit:
> >> +    close(fd);
> >> +freemem:
> >> +    free(tags);
> >> +    free(procfs_entries);
> >> +    return ret;
> >> +}
> >> +
> >> +static int test_filename_filter(void)
> >> +{
> >> +    struct allocinfo_filter filter;
> >> +    const char *target_filename =3D "mm/memory.c";
> >> +
> >> +    memset(&filter, 0, sizeof(filter));
> >> +    filter.mask |=3D ALLOCINFO_FILTER_MASK_FILENAME;
> >> +    strncpy(filter.fields.filename, target_filename,
> >> ALLOCINFO_STR_SIZE);
> >> +
> >> +    return run_filter_test(&filter);
> >> +}
> >> +
> >> +static int test_function_filter(void)
> >> +{
> >> +    struct allocinfo_filter filter;
> >> +    const char *target_function =3D "dup_mm";
> >> +
> >> +    memset(&filter, 0, sizeof(filter));
> >> +    filter.mask |=3D ALLOCINFO_FILTER_MASK_FUNCTION;
> >> +    strncpy(filter.fields.function, target_function,
> >> ALLOCINFO_STR_SIZE);
> >> +
> >> +    return run_filter_test(&filter);
> >> +}
> >> +
> >> +int main(int argc, char *argv[])
> >> +{
> >> +    int ret;
> >> +
> >> +    ksft_set_plan(2);
> >> +
> >> +    ret =3D test_filename_filter();
> >> +    if (ret =3D=3D KSFT_SKIP)
> >> +        ksft_test_result_skip("Skipping test_filename_filter\n");
> >> +    else
> >> +        ksft_test_result(ret =3D=3D KSFT_PASS, "test_filename_filter\=
n");
> >> +
> >> +    ret =3D test_function_filter();
> >> +    if (ret =3D=3D KSFT_SKIP)
> >> +        ksft_test_result_skip("Skipping test_function_filter\n");
> >> +    else
> >> +        ksft_test_result(ret =3D=3D KSFT_PASS, "test_function_filter\=
n");
> >> +
> >> +    ksft_finished();
> >> +}

