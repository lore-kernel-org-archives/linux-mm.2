Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEFB9CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28746B00D6; Tue, 16 Jun 2026 17:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1BF6B00DC; Tue, 16 Jun 2026 17:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D1E6B00DE; Tue, 16 Jun 2026 17:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55C3F6B00D6
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:11:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6A7A40261
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:11:58 +0000 (UTC)
X-FDA: 84887023116.04.6023387
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id BB4C3A0005
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:11:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JfYh+j2L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781644316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBBwjXqSRUTYQPXVAPGWlWCY+4f06L2zkzkryOWNY24=;
	b=PzfgLhreHuAMCDuZVodroZ3NUvjw8uR42DZKsSLfowwJ7KV1eKlDPYuJ9dDkTF+SPx1uzw
	vkhwXJw4irpWrABWr+4DiKcwM0Yc+GFBGf6shzh6qmw1e3nsdeD0olNXXRePH+NjPiFici
	wmAaRKzccWpUegCXeAxzEvdgzbFaXBo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JfYh+j2L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781644316;
	b=WGdgJ5IFm3mcVr0gMzGgS/GZSnIdp9lDQxrtaVMFacaDqiXs2c4yNkbXp2WlBrEmaNdmTc
	Q+EvYPUfOxNx2gK4J3IekDHtcQ52CGqS69IX4B9yYBESQw1EGCM+GHUMD1QzkQToQhHu+b
	/PHiAELgrdKorDFn9u3HSufMIMCSiA4=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2bf2d865383so6905ad.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:11:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781644315; cv=none;
        d=google.com; s=arc-20240605;
        b=YljP5MVbxb1EKq09gJ/iEUO1mr5riWtrYEtDIVE2lt36i2HG3j5s/Ll7M+7Bynu87j
         rPEJIucsbAhrxg6YiIsJg15z6svNhprSw6NDo9wRbfkEp8MzJZFRPUV4hw1vQSDnxT8o
         FxD1p1MZrYLkP3w87xm7Fq5ibTBm3CMWhNAMbz0hRVhByuljBuWRaWusP0hq67W39Jv5
         p5X5gAzO50kRGrkGznzUIQ79h1BRj40mc/WT3KqXr09hPs4C7DsLEwltnvInlLLYxnzw
         D7RsD0ESS+gUNEFGMdoE7qP0wk5BPg3d1En2Z1O0/0wbmIzO5jP3/6k2VZKw0eASpqoB
         yhbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FBBwjXqSRUTYQPXVAPGWlWCY+4f06L2zkzkryOWNY24=;
        fh=HR60ib6fk43zYuL/qLvk5VW2Q1Sr0N0JSh1i3Y5Qizc=;
        b=HKEXARtD4Qk6Ps3Yvhx6uvPL4cjl6DNgK7fGTWDRZVS3DtrxTMYcapmgN21qUOHXxC
         iTmjh3EbbtdqhUrZTMfBtw8fKekzXWR+gnbuZysiQZM01MO3TPYGYmwLgZIEi+JX2uER
         VQ8kf9vkg+4G7kZAkHsHXzZwJILBLsct36qxkxPziUS5pqzVa0ynaPlvgSYVIokS+xV+
         5f4K7sHl3DGKgCg0g8xMqXzS9JislZg5+3VeEV0KqoGO6pRM4/m+OXzyOifehruItPv8
         hxjIAjc8nhkB/yMuyMZF8SlEvFzvyWICoG1KAf69/DoyjaMJvOavbiI+XcXnhjiGxKJu
         op7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781644315; x=1782249115; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FBBwjXqSRUTYQPXVAPGWlWCY+4f06L2zkzkryOWNY24=;
        b=JfYh+j2LTSsy0w4hFD5zGrJCCA/T7vtyp5VmseXbnoAvMbSez2rlDwLrhBReWvhnk7
         u1tOLpf4KcuFZ7Ku3QhAPXryL1j3TVsPLnhErfD2fjiwWKdyCkz1vuyNtLxTWz34cCs2
         Osv8ESbdUHNtn1ph0Mls7TXgXHCj+93WSB+42hp/q9Baa7Rirdx7GKTk48a/VGWQQbzp
         4ZYES1TgffFlKcZUS9oRluLISu0KTjInAr9a5hBVXD3Hbe2eFZSjVsAh7O56n5ezNxC/
         oGkUsY7yKsy4SIRXf/T2PF0vaQWouLXHfbtJczh7cF9YkdnuJM9lHfUzg24EdhkYiyQf
         cAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781644315; x=1782249115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FBBwjXqSRUTYQPXVAPGWlWCY+4f06L2zkzkryOWNY24=;
        b=Pw1tKhTVkVKUEnl/rRU5PwZeLy4kKL+gJRuGRI+zeXAq5Pj+jipRuIGCUXSuU2zh2/
         +3toD/Jo3Sp6Qze2kfO6UH/VcaIhTURnHxqRyjkRHSn0Be4bX74He0vslcqi8mjpmc7L
         3EyaYQOp74zh7KIB2GIuF/ileTNruI8FjyaUEno0NNhKy/k1JGpAENRSenFzBT3uBPGJ
         wZiC/Iab+eZRH9t//qOumw7IY+Zppg2RGQkKi5CXmGjCMXS2ur3vqRqghxXefTuW1kHr
         ihJZHNK9HZgpUsBJm4wEzz7rnYDMtivnSxplYz8j7sLeA77bMINNlKlrfUcmWRnnAlPb
         SEKQ==
X-Forwarded-Encrypted: i=1; AFNElJ99MXcGGp81OVWNZByoy/3KhdH4yqdNH8u70vRzyehro6EzqQhWwTn0xWpNeD+AXWtUr9pCehYVJA==@kvack.org
X-Gm-Message-State: AOJu0YyEw+h9y7kSvj8z3iA+YI+O9tqxF86U9JM4LE4zwNFDj1thRbkx
	X1uq1IbGlH+fca82ZG/5Ir8OdTLk1BPEP4ZvoAyzGuZMLarjOsaaRnfi7Cue3BiwEE/L3011H8B
	OgqsHgrtx/GMfsDoAQDEFcjTz1dkOtQ9vIGZPo4RlpOj+RE+XfDlAAPN2
X-Gm-Gg: AfdE7cnpoS7QfVNSkU53SAzXKQtBErCCkTXzAgSeydYRrZJQhOzfK1oIbNvzXX8su9J
	/dmT6TK6hpIGkIF1p6hkGwQc12UKmdBTBADEcxYmln6FeRK3mn2D39plwZbAqYV5cBqjfLESHqm
	U3EJmx2P9SR5Y3aCXwDlfD00aT0cNBzLc5NJ+nhU3KlDB3apNoUG11hJIupiqKkLUJefMtO7/tO
	RktkAV+rJ84mb4CY4HIVOgLfonFnxBETUsssIrCQj4/OtJVtpRYobpooxApQ8Obg1QcOOqHVJ5M
	DRxm1mAxs8Frp6ld5KXAGv2+vpIDL7NAWWWSBA==
X-Received: by 2002:a17:902:c412:b0:2bd:63cb:c5be with SMTP id
 d9443c01a7336-2c69c16752dmr2696475ad.5.1781628990995; Tue, 16 Jun 2026
 09:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com>
 <4d9c8dc420e2019e1fce62ecf31ec40933fce3a8.1781564384.git.abhishekbapat@google.com>
 <f5afcb7a-5b38-4c98-ac3e-529631bda4cb@linux.dev>
In-Reply-To: <f5afcb7a-5b38-4c98-ac3e-529631bda4cb@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Tue, 16 Jun 2026 09:56:18 -0700
X-Gm-Features: AVVi8CeuQwdwFenEreIZ_n6dANPmV86qly9NGCdeEqnOpkdWlWk_T04j-QDnrT8
Message-ID: <CAL41Mv7s9iA6a3YKV40E-9vk9WZfCjMEgBbLq_FVOjRS-PdVvA@mail.gmail.com>
Subject: Re: [PATCH v5 5/6] kselftest: alloc_tag: add kselftest for ioctl interface
To: Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB4C3A0005
X-Stat-Signature: 5ifiamsmb9grwbe6iuz98ztde3srmxdm
X-Rspam-User: 
X-HE-Tag: 1781644316-966910
X-HE-Meta: U2FsdGVkX194KZ8UYaPLZVz4hsVwmGikWl6nVacbzXqAr2gKYLYQEOvfV5zlyDt0guQUjDDrWj06ZEhuP1Vpphi/2cWX8R9jAA/enAaKEZ7rFWkKwjL2q7+wkF/YohrtZ4lQH6YblPxfI6zyPxGvJFakIcPxqn2fIyEq05PddpUvk+4tkIvyWuwQ7H2TrxILJSePAWCDFKICpsED3qJ7kpkhMPJwmnNSHc3617ZTpDTnvSgcyAnjLS48/aR321MVIOo2/0TIt9tCP95Add+bGwnjR90zbjT8HbVgBp62Yd6Pq2Ttl0G7RswKOq2waBLqulvTuBngi4uANSt+OlZpIitOFWffZmzpyhYP07WzFL5qaS3yP5Ky7T4mc6GEhlDKz6V2hQLYgdeScU+IHq8LEnHDO7fn7YgKrxTBI4MHoGRsaWyE4qV59AaEsIZQpEqotkcdGG92iBeYuyv2kLTuoZs3HA95aHcKSzV+YIZ2zdzE9/wqqbTvZKXbt4NhcaX0Zub73Ezrm/d6h+il2pcI8StOCjPJ6pBzCVZ4rQgk1qWUJPw6O7cDwaqc2ccrw134k20qVdVoTnAy6mUc7aaZmhR7LISmyg8T36RO/57AYTYVrQkWneR6j9c5zeae3zMvS5U+/o0xui0cYLfEnrVi31IdDAuuw0wBBuHrsxe1sPPazMd/YQQuATki6217pVZmX5fYRCJu6rUcG70DD8qJKb2XGySW7G47eezvPEg3sWRuXUyitEMdJhoF7716pKbzJsU15Lqbf70fDXAhHMn17gMzH02kYS/EGMAPinTie61Aqv5YZ7Z8QhjpCvwORCG6uTQu125Ss5F0kesjOQUS9roov2qSVDlmWFSgZ0q+IFw1kYAYWPNYf8n/m7uG3a/NhIQootLfCmgyMl2jQKziZIxDFFqrvKXx3Juw66tRI3mUPIkymGxqh7nqSdjmKkeNHXNRNbtnkVnMeg/vJpT
 8xxIsZeD
 ep5B/pF+U4jspSHGSokPxhyz7bv4Aak2ixp9tgGj18rN/BNtVLC/NiIYCwaLwl8Ca0avFyt8EzUfiBT2X3LMiiuCQRlDwU2M5drynW0bJYb//3rArj9L5udifuSpWV7ReFzU2rC8JDHBbqb10CpxC7Jv4M8LDKK4C21CjDgu/Hp5cb4eAslAx+MBHVgOt7rsdwINdx0nATGG1qDPt9ZvPLh0HaLJa+Kzd2PPHm6jnrmDjxeEyok52khOtsd0A5janGDIp727mRRJ/rWcEUyezGeqYIlgOtl5Oa70lXFXJc2eG9vhG92I2yN7T+KksV5NvzGuTPByGNLjBlLGEmp8R8MQcbHPHJmTkQivwyQn63ciqjheq3iTNGFF1dQysmS81SJylQZi718+D0qAMU/kVfdRT5G1vTfa+gyE5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 11:01=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
>
> On 2026/6/16 07:04, Abhishek Bapat wrote:
> > Introduce a kselftest to verify the new IOCTL-based interface for
> > /proc/allocinfo. The test covers:
> >
> > 1. Validation of the filename filter.
> > 2. Validation of the function filter.
> >
> > The first test validates the functionality of the filename filter. Usin=
g
> > "mm/memory.c" as the candidate filename filter, it retrieves filtered
> > entries from both procfs and ioctl and matches the first VEC_MAX_ENTRIE=
S
> > entries.
> >
> > The second test validates the functionality of the function filter.
> > It uses "dup_mm" as the candidate function as we do not expect this
> > function name to change frequently and hence won't be needing to modify
> > this test often.
> >
> > Note that both the tests match line no, function name and file name
> > fields. Bytes allocated and calls are not matched as those values may
> > change in the time when the data is being read from procfs and ioctl an=
d
> > hence can lead to false negatives.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> >   MAINTAINERS                                   |   1 +
> >   tools/testing/selftests/alloc_tag/Makefile    |   9 +
> >   .../alloc_tag/allocinfo_ioctl_test.c          | 331 +++++++++++++++++=
+
> >   3 files changed, 341 insertions(+)
> >   create mode 100644 tools/testing/selftests/alloc_tag/Makefile
> >   create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_=
test.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 019cc4c285a3..6610dd42e484 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16715,6 +16715,7 @@ F:    include/linux/alloc_tag.h
> >   F:  include/linux/pgalloc_tag.h
> >   F:  include/uapi/linux/alloc_tag.h
> >   F:  lib/alloc_tag.c
> > +F:   tools/testing/selftests/alloc_tag/
> >
> >   MEMORY CONTROLLER DRIVERS
> >   M:  Krzysztof Kozlowski <krzk@kernel.org>
> > diff --git a/tools/testing/selftests/alloc_tag/Makefile b/tools/testing=
/selftests/alloc_tag/Makefile
> > new file mode 100644
> > index 000000000000..f2b8fc022c3b
> > --- /dev/null
> > +++ b/tools/testing/selftests/alloc_tag/Makefile
> > @@ -0,0 +1,9 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +TEST_GEN_PROGS :=3D allocinfo_ioctl_test
> > +
> > +CFLAGS +=3D -Wall
> > +CFLAGS +=3D -I../../../../usr/include
>
>
> I think we should replace -I../../../../usr/include with $(KHDR_INCLUDES)=
.
>
>
> > +
> > +include ../lib.mk
> > +
>
>
> We would also introduce an extra field in the parent directory,
>
> allowing our alloc_tag target to be built when running make
>
> within /home/linux/tools/testing/selftests.
>
> like this:
>
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -1,5 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
>   TARGETS +=3D acct
> +TARGETS +=3D alloc_tag
>   TARGETS +=3D alsa
>   TARGETS +=3D amd-pstate
>   TARGETS +=3D arm64
>
> Below is the relevant build log:
>
> [root@localhost selftests]# make -j8
>    CC       acct_syscall
>    CC       allocinfo_ioctl_test
>
> Below is the log from running make clean:
>
> [root@localhost selftests]# make clean
> rm -f -r /home/linux/tools/testing/selftests/acct/acct_syscall
> rm -f -r /home/linux/tools/testing/selftests/alloc_tag/allocinfo_ioctl_te=
st
>
>
> (Sorry about this inconvenience. I had limited experience with the
> kselftest framework,
>
> so I reached out to my teammates to sort out the relevant build logic.
>
> It's my fault for not catching this issue in prior reviews
>
> and forcing you to send a revised patch.)
>
>
Before writing this patch, I had discussed this with Suren and he was
of the opinion that this should be done later in a separate patch. So
I'll let Suren answer this further.

> > diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b=
/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > new file mode 100644
> > index 000000000000..62d5a488a04d
> > --- /dev/null
> > +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > @@ -0,0 +1,331 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +/* kselftest for allocinfo ioctl
> > + * allocinfo ioctl retrives allocinfo data through ioctl
> > + * Copyright (C) 2026 Google, Inc.
> > + */
> > +
> > +#include <errno.h>
>
>
> errno.h is unused and may be dropped.
>
>
> > +#include <fcntl.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <stdbool.h>
> > +#include <unistd.h>
> > +#include <sys/ioctl.h>
> > +#include <linux/types.h>
> > +#include <linux/alloc_tag.h>
> > +#include "../kselftest.h"
> > +
> > +#define MAX_LINE_LEN         512
> > +#define ALLOCINFO_PROC               "/proc/allocinfo"
> > +
> > +enum ioctl_ret {
> > +     IOCTL_SUCCESS =3D 0,
> > +     IOCTL_FAILURE =3D 1,
> > +     IOCTL_INVALID_DATA =3D 2,
> > +};
> > +
> > +#define VEC_MAX_ENTRIES 32
> > +
> > +struct allocinfo_tag_data_vec {
> > +     struct allocinfo_tag_data tag[VEC_MAX_ENTRIES];
> > +     __u64 count;
> > +};
> > +
> > +static inline int __allocinfo_get_content_id(int dev_fd, struct alloci=
nfo_content_id *params)
> > +{
> > +     return ioctl(dev_fd, ALLOCINFO_IOC_CONTENT_ID, params);
> > +}
> > +
> > +static inline int __allocinfo_get_at(int dev_fd, struct allocinfo_get_=
at *params)
> > +{
> > +     return ioctl(dev_fd, ALLOCINFO_IOC_GET_AT, params);
> > +}
> > +
> > +static inline int __allocinfo_get_next(int dev_fd, struct allocinfo_ta=
g_data *params)
> > +{
> > +     return ioctl(dev_fd, ALLOCINFO_IOC_GET_NEXT, params);
> > +}
> > +
> > +static bool match_entry(const struct allocinfo_tag_data *procfs_entry,
> > +                     const struct allocinfo_tag_data *tag_data,
> > +                     bool match_bytes, bool match_calls, bool match_li=
neno,
> > +                     bool match_function, bool match_filename)
> > +{
> > +     if (match_bytes && tag_data->counter.bytes !=3D procfs_entry->cou=
nter.bytes) {
> > +             ksft_print_msg("size retrieved through ioctl does not mat=
ch procfs\n");
> > +             return false;
> > +     }
> > +
> > +     if (match_calls && tag_data->counter.calls !=3D procfs_entry->cou=
nter.calls) {
> > +             ksft_print_msg("call count retrieved through ioctl does n=
ot match procfs\n");
> > +             return false;
> > +     }
> > +
> > +     if (match_lineno && tag_data->tag.lineno !=3D procfs_entry->tag.l=
ineno) {
> > +             ksft_print_msg("lineno retrieved through ioctl does not m=
atch procfs\n");
> > +             return false;
> > +     }
> > +
> > +     if (match_function &&
> > +         strncmp(tag_data->tag.function, procfs_entry->tag.function, A=
LLOCINFO_STR_SIZE)) {
> > +             ksft_print_msg("function retrieved through ioctl does not=
 match procfs\n");
> > +             return false;
> > +     }
> > +
> > +     if (match_filename &&
> > +         strncmp(tag_data->tag.filename, procfs_entry->tag.filename, A=
LLOCINFO_STR_SIZE)) {
> > +             ksft_print_msg("filename retrieved through ioctl does not=
 match procfs\n");
> > +             return false;
> > +     }
> > +     return true;
> > +}
> > +
> > +static bool match_entries(const struct allocinfo_tag_data_vec *procfs_=
entries,
> > +                       const struct allocinfo_tag_data_vec *tags,
> > +                       bool match_bytes, bool match_calls, bool match_=
lineno,
> > +                       bool match_function, bool match_filename)
> > +{
> > +     __u64 i;
> > +
> > +     if (procfs_entries->count !=3D tags->count) {
> > +             ksft_print_msg("Entry count mismatch. ioctl entries: %llu=
, proc entries: %llu\n",
> > +                            tags->count, procfs_entries->count);
> > +             return false;
> > +     }
> > +     for (i =3D 0; i < procfs_entries->count; i++) {
> > +             if (!match_entry(&procfs_entries->tag[i], &tags->tag[i],
> > +                              match_bytes, match_calls, match_lineno,
> > +                              match_function, match_filename)) {
> > +                     ksft_print_msg("%lluth entry does not match.\n", =
i);
> > +                     return false;
> > +             }
> > +     }
> > +     return true;
> > +}
> > +
> > +static const char *allocinfo_str(const char *str)
> > +{
> > +     size_t len =3D strlen(str);
> > +
> > +     if (len >=3D ALLOCINFO_STR_SIZE)
> > +             str +=3D (len - ALLOCINFO_STR_SIZE) + 1;
> > +     return str;
> > +}
> > +
> > +static void allocinfo_copy_str(char *dest, const char *src)
> > +{
> > +     strncpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE - 1);
> > +     dest[ALLOCINFO_STR_SIZE - 1] =3D '\0';
> > +}
> > +
> > +static int get_filtered_procfs_entries(struct allocinfo_tag_data_vec *=
procfs_entries,
> > +                                    const struct allocinfo_filter *fil=
ter)
> > +{
> > +     FILE *fp =3D fopen(ALLOCINFO_PROC, "r");
> > +     char line[MAX_LINE_LEN];
> > +     int matches;
> > +     struct allocinfo_tag_data procfs_entry;
> > +
> > +     if (!fp) {
> > +             ksft_print_msg("Failed to open " ALLOCINFO_PROC " for rea=
ding\n");
> > +             return 1;
> > +     }
> > +     memset(procfs_entries, 0, sizeof(*procfs_entries));
> > +     while (fgets(line, sizeof(line), fp) && procfs_entries->count < V=
EC_MAX_ENTRIES) {
> > +             char filename[MAX_LINE_LEN];
> > +             char function[MAX_LINE_LEN];
> > +
> > +             memset(&procfs_entry, 0, sizeof(procfs_entry));
> > +             matches =3D sscanf(line, "%llu %llu %[^:]:%llu func:%s",
> > +                              &procfs_entry.counter.bytes,
> > +                              &procfs_entry.counter.calls,
> > +                              filename,
> > +                              &procfs_entry.tag.lineno,
> > +                              function);
> > +
> > +             if (matches !=3D 5)
> > +                     continue;
> > +
> > +             allocinfo_copy_str(procfs_entry.tag.filename, filename);
> > +             allocinfo_copy_str(procfs_entry.tag.function, function);
> > +
> > +             if (filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) {
> > +                     if (strncmp(procfs_entry.tag.filename,
> > +                                 filter->fields.filename, ALLOCINFO_ST=
R_SIZE))
> > +                             continue;
> > +             }
> > +             if (filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) {
> > +                     if (strncmp(procfs_entry.tag.function,
> > +                                 filter->fields.function, ALLOCINFO_ST=
R_SIZE))
> > +                             continue;
> > +             }
> > +             if (filter->mask & ALLOCINFO_FILTER_MASK_LINENO) {
> > +                     if (procfs_entry.tag.lineno !=3D filter->fields.l=
ineno)
> > +                             continue;
> > +             }
> > +             if (filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) {
> > +                     if (procfs_entry.counter.bytes < filter->min_size=
)
> > +                             continue;
> > +             }
> > +             if (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) {
> > +                     if (procfs_entry.counter.bytes > filter->max_size=
)
> > +                             continue;
> > +             }
> > +
> > +             memcpy(&procfs_entries->tag[procfs_entries->count++], &pr=
ocfs_entry,
> > +                    sizeof(procfs_entry));
> > +     }
> > +     fclose(fp);
> > +     return 0;
> > +}
> > +
> > +static enum ioctl_ret get_filtered_ioctl_entries(struct allocinfo_tag_=
data_vec *tags,
> > +                                              const struct allocinfo_f=
ilter *filter,
> > +                                              __u64 start_pos)
> > +{
> > +     int fd =3D open(ALLOCINFO_PROC, O_RDONLY);
> > +
> > +     if (fd < 0) {
> > +             ksft_print_msg("Failed to open " ALLOCINFO_PROC " for IOC=
TL\n");
> > +             return IOCTL_FAILURE;
> > +     }
> > +     struct allocinfo_content_id start_cont_id, end_cont_id;
> > +     struct allocinfo_get_at get_at_params;
> > +     const int max_retries =3D 10;
> > +     int retry_count =3D 0;
> > +     int status;
> > +
> > +     /*
> > +      * __allocinfo_get_content_id may return different values if a ke=
rnel module was loaded
> > +      * between the two calls. If that happens, the data gathered cann=
ot be considered consistent
> > +      * and hence needs to be fetched again to avoid flakiness.
> > +      */
> > +     do {
> > +             if (__allocinfo_get_content_id(fd, &start_cont_id)) {
> > +                     ksft_print_msg("allocinfo_get_content_id failed\n=
");
> > +                     return IOCTL_FAILURE;
>
> Sashiko pointed out the fd leak in get_filtered_ioctl_entries().
>
> Since we already need to update the patch to fix the missing
>
> TARGETS entry in the top-level Makefile, we might as well fix
>
> this at the same time.
>
>
> Thanks
>
> Best Regards
>
> Hao
>

Ahh I missed this code path interestingly. Ack, I'll remove these
return statements here.

> > +             }
> > +
> > +             memset(tags, 0, sizeof(*tags));
> > +             memset(&get_at_params, 0, sizeof(get_at_params));
> > +             memcpy(&get_at_params.filter, filter, sizeof(*filter));
> > +             get_at_params.pos =3D start_pos;
> > +             if (__allocinfo_get_at(fd, &get_at_params)) {
> > +                     ksft_print_msg("allocinfo_get_at failed\n");
> > +                     return IOCTL_FAILURE;
> > +             }
> > +             memcpy(&tags->tag[tags->count++], &get_at_params.data, si=
zeof(get_at_params.data));
> > +
> > +             while (tags->count < VEC_MAX_ENTRIES &&
> > +                    __allocinfo_get_next(fd, &tags->tag[tags->count]) =
=3D=3D 0)
> > +                     tags->count++;
> > +
> > +             if (__allocinfo_get_content_id(fd, &end_cont_id)) {
> > +                     ksft_print_msg("allocinfo_get_content_id failed\n=
");
> > +                     return IOCTL_FAILURE;
> > +             }
> > +
> > +             if (start_cont_id.id =3D=3D end_cont_id.id) {
> > +                     status =3D IOCTL_SUCCESS;
> > +             } else {
> > +                     ksft_print_msg("allocinfo_get_content_id mismatch=
, retrying...\n");
> > +                     status =3D IOCTL_INVALID_DATA;
> > +             }
> > +     } while (status =3D=3D IOCTL_INVALID_DATA && retry_count++ < max_=
retries);
> > +
> > +     close(fd);
> > +     return status;
> > +}
> > +
> > +static int run_filter_test(const struct allocinfo_filter *filter)
> > +{
> > +     struct allocinfo_tag_data_vec *tags =3D malloc(sizeof(*tags));
> > +     struct allocinfo_tag_data_vec *procfs_entries =3D malloc(sizeof(*=
procfs_entries));
> > +     int ioctl_status;
> > +     int ret =3D KSFT_PASS;
> > +
> > +     if (!tags || !procfs_entries) {
> > +             ksft_print_msg("Memory allocation failed.\n");
> > +             ret =3D KSFT_FAIL;
> > +             goto exit;
> > +     }
> > +
> > +     if (get_filtered_procfs_entries(procfs_entries, filter)) {
> > +             ksft_print_msg("Error retrieving entries from " ALLOCINFO=
_PROC "\n");
> > +             ret =3D KSFT_SKIP;
> > +             goto exit;
> > +     }
> > +
> > +     if (procfs_entries->count =3D=3D 0) {
> > +             ksft_print_msg("No entries found in " ALLOCINFO_PROC ", s=
kipping test\n");
> > +             ret =3D KSFT_SKIP;
> > +             goto exit;
> > +     }
> > +
> > +     ioctl_status =3D get_filtered_ioctl_entries(tags, filter, 0);
> > +     if (ioctl_status =3D=3D IOCTL_INVALID_DATA) {
> > +             ksft_print_msg("Trouble retrieving valid IOCTL entries, s=
kipping.\n");
> > +             ret =3D KSFT_SKIP;
> > +             goto exit;
> > +     }
> > +     if (ioctl_status =3D=3D IOCTL_FAILURE) {
> > +             ksft_print_msg("Error retrieving IOCTL entries.\n");
> > +             ret =3D KSFT_FAIL;
> > +             goto exit;
> > +     }
> > +
> > +     if (!match_entries(procfs_entries, tags, false, false, true, true=
, true))
> > +             ret =3D KSFT_FAIL;
> > +
> > +exit:
> > +     free(tags);
> > +     free(procfs_entries);
> > +     return ret;
> > +}
> > +
> > +static int test_filename_filter(void)
> > +{
> > +     struct allocinfo_filter filter;
> > +     const char *target_filename =3D "mm/memory.c";
> > +
> > +     memset(&filter, 0, sizeof(filter));
> > +     filter.mask |=3D ALLOCINFO_FILTER_MASK_FILENAME;
> > +     strncpy(filter.fields.filename, target_filename, ALLOCINFO_STR_SI=
ZE);
> > +
> > +     return run_filter_test(&filter);
> > +}
> > +
> > +static int test_function_filter(void)
> > +{
> > +     struct allocinfo_filter filter;
> > +     const char *target_function =3D "dup_mm";
> > +
> > +     memset(&filter, 0, sizeof(filter));
> > +     filter.mask |=3D ALLOCINFO_FILTER_MASK_FUNCTION;
> > +     strncpy(filter.fields.function, target_function, ALLOCINFO_STR_SI=
ZE);
> > +
> > +     return run_filter_test(&filter);
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +     int ret;
> > +
> > +     ksft_set_plan(2);
> > +
> > +     ret =3D test_filename_filter();
> > +     if (ret =3D=3D KSFT_SKIP)
> > +             ksft_test_result_skip("Skipping test_filename_filter\n");
> > +     else
> > +             ksft_test_result(ret =3D=3D KSFT_PASS, "test_filename_fil=
ter\n");
> > +
> > +     ret =3D test_function_filter();
> > +     if (ret =3D=3D KSFT_SKIP)
> > +             ksft_test_result_skip("Skipping test_function_filter\n");
> > +     else
> > +             ksft_test_result(ret =3D=3D KSFT_PASS, "test_function_fil=
ter\n");
> > +
> > +     ksft_finished();
> > +}

