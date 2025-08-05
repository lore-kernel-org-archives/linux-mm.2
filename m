Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097AEC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 02:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07D06B0088; Mon,  4 Aug 2025 22:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF986B008C; Mon,  4 Aug 2025 22:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91CE06B0093; Mon,  4 Aug 2025 22:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 822686B0088
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 22:00:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 042E0136B7D
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:00:20 +0000 (UTC)
X-FDA: 83741049042.26.9B1E36A
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id E6B3C1C000B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:00:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=E5BPJFQD;
	spf=pass (imf18.hostedemail.com: domain of sudarsanm@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=sudarsanm@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754359219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSG7opwXv5FWsH2EhXuTn8+OP17SmN7esmHU9ZRgkXc=;
	b=ajEZJWj4Cj1P1PX5fmfR+wzpIYPpWsNpDZHnFJt6aNvhZonGjNwNKPIfhZLJfdLZuEu5Mx
	D+0Quuwq9oAIhPqhvIwwlztkoIzOSvNV9FQnjLy8px9bRSOQvYm9oBZveMvLTAGUniDPWV
	Ps4ADKveavpGgM56dbI2Gnb5iEbzDa4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754359219; a=rsa-sha256;
	cv=none;
	b=ao2apEElsAVr6yo8iJ2eTGWNY2xZ3CCPu/71M+w9arLgAARRvCzWAIhd+2g+R1m/XF92wn
	4fYNbQ2eaF2EtXemsE6N1H/uzkzHUMEs8479qgnStl2e8X7VyBtuNFZwZqKy03TARim9Uz
	T7heObzU4rnhcS9ePkGitarU5f3bphk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=E5BPJFQD;
	spf=pass (imf18.hostedemail.com: domain of sudarsanm@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=sudarsanm@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-459ddb41539so6250895e9.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 19:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754359217; x=1754964017; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kSG7opwXv5FWsH2EhXuTn8+OP17SmN7esmHU9ZRgkXc=;
        b=E5BPJFQD85WrMjuDlGBfBQN5f8rA7oGKU9P7Y7yk3tIK8Oqf+T9lrv3aMEAJlrDiGm
         dXxyusX+G/p2j6+QsgA1jVlpXTQ4szslznpfYiD4/9akdpFHck1wkp3/PT1sSpFzZ3Or
         e9XxecrlvqvFZQDZ8O2g7Y814kUfTTrdbrVlp9r6tuFTEiIehX8CBNaDbEQVkCg95Nd6
         FPglPJ3SJFCkMwcdSr6ctFTIrMKlog47JjDVXhjxqCZ73h9gvdXK2R9btqDK5JOAwKZC
         xCWWc1pAIMjQYgImkHjU4SbZQecbgUWPraXJuqv0D6C3SYZXSXbfKqhRiCDHSM7w49cz
         59bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754359217; x=1754964017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kSG7opwXv5FWsH2EhXuTn8+OP17SmN7esmHU9ZRgkXc=;
        b=aVjl8CKip8jJUbT/bn+I96HkBvaGGW3y1T0gOtZoN76S1t7aOlKtrnnTcpdiXW8gls
         uge0uGh9lZ7+x2PP+gGP1amNNrIvpbNdar6aUFxsYU9XyDoBoyu2P18MqtiW8n4a7Gwa
         oeuicKF3hbWaMpIdHllypfuNtaZQBGo7gfc8t/UTWb32rvT12vtnBVd55oFLuiQrpfQi
         0ZMnpB3mZZI2Tv0FIjYQiayJUVV03gteZDWjsOLX86GD++XsRWspqGZsyRkCkITrOPHU
         Iup9CaKq44+rM/OmifTeOQm/ULcJRaVDUvuiepdgi+Z2KtI4ix7qrLz1xiax5hsLzVyN
         imNg==
X-Forwarded-Encrypted: i=1; AJvYcCV8+BsWqa5Z7kM+oaIrXuB9yThgAlnmIGLRBIb/UhXKTihlU3yO5awZ+Z/zrL0GLR/QRV8BB4n7Dw==@kvack.org
X-Gm-Message-State: AOJu0YxxsX0Obtr9g8xeV00Eb+FlIINfw96cB2zytas1DD/Y7mh4Xgbu
	tLDT9CVRNLWD3AUsUUDGbUDyoYbRbfRugGMR9r6is5TBhxHKIY398ER4zbJsYbw5BVqYtnb3ga0
	Q0EvCZJP5MI9Fkp5s/OFFhEUfqiNlIRndM43XZ45t
X-Gm-Gg: ASbGnctJx11EOxfPylxmPwI2Nlb1C7bnn8LwBU0AzCmvEPHetLp0bThKPtCmowj8lSk
	Y5i82fduSJmKExagwDe0OTfKZIteQHx2wSk9GzBYfjNrt9MRYciENy9+hyAfHM693krlagJSAtX
	Yuk738EKyIy+VbjMsS8cf6oJ3NzE5tFmBB9DTjVVG4vj2GO8RVWwxb7b84rljnO8jQQSC2EfwHJ
	kQU1bQo
X-Google-Smtp-Source: AGHT+IHU8mICIqYoxrBVexKLpAl1lfHIFd4RBPzxvH9x1QdKoshXo7HiGb8ekOlyGWshojjeuYWAqUhNU+zNS+nDRmI=
X-Received: by 2002:a05:600c:1548:b0:43e:bdf7:7975 with SMTP id
 5b1f17b1804b1-458b6b5ef11mr91572245e9.32.1754359217211; Mon, 04 Aug 2025
 19:00:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250801234559.1178521-1-sudarsanm@google.com> <8c609741-c2b8-426c-8f83-8a79022b67d7@redhat.com>
In-Reply-To: <8c609741-c2b8-426c-8f83-8a79022b67d7@redhat.com>
From: Sudarsan Mahendran <sudarsanm@google.com>
Date: Mon, 4 Aug 2025 18:59:40 -0700
X-Gm-Features: Ac12FXz0fbRx1mvWhuQG3tGn2Pn1eTjXZ_7L8a0gEEdaxYWLXKdLSI_NNmxxtvM
Message-ID: <CAA9mObDx=oDeRAGJSdY3crMAYY=qn0-v2ZH9vsxkv3NcgUCL-Q@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/mm: pass filename as input param to
 VM_PFNMAP tests
To: David Hildenbrand <david@redhat.com>
Cc: linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	trivial@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E6B3C1C000B
X-Stat-Signature: n6xytt39z3qh8p9p74n55c65k8cy37ef
X-Rspam-User: 
X-HE-Tag: 1754359218-73938
X-HE-Meta: U2FsdGVkX18b7CdaksY65uo+SjxRPxPIhqOmXZrbDMIKZUaeG5I/i8ogvKUeIdk17suSdjQubldmD8+LfVlrbf1yTlhP7+Nkt0nIOHmpgBJsebtybP2PzQUtHNl62c5acvIc2zemkBoJp2j6xO+TWhgdqEDavh1K13iK3XSy59Lre9pWKIOV9TIAMdmIEw72tFW3F0z1XtSyF1jNO16VHo2Qav2iJ2ow/UfenBatKDiVAetjvz3EqOvOZvtC69l69j0ozK2TxPi6/U+3alMHLKzFpetjiKq+7sMWncMavuDV7goLoiUF6Ot0EHoDycwigXg9XWpsRE3mcYoEydUMMBb7UrqKR66MwPb42IlgZMQVe6yFDVxmhejgrZzF4zNSBP4KD2ME3mHc/BnO8sojO2JHR4Hqin3mXbAfZTexuOLqdEA4iNsKxpBlVgVk4Tm7EhbhKcfi4GZKy3T6NIfony0ZK7LQvdmPQoV5U+mcLVm0RyVNW/h2wdXWf/C6BNpvWQXwmFKg0Hqx8pa/m+rsFOrH31fmJia8pSa+pZ9JvZf0O0AwtRpF692ybyoLjUb8Brpno31tjm9fJurYHv/LiJvwSuWi3jA0m/CIN1URTXQQ9gO2XEDBP9RrOBwdT24T8WFjKEavIjm3sSh06NQ3XWtu0bEh7EUKGWcesCJ+z3EQ1UX0gH3nyNgr7OFWnhys09vxxA+PUfcksucf+SBwlL3OmqrFBOLxfLt8lICjPUU3QM4mgK3Wxe6dleqLdAUB6ryzwVPdrx614Pun0/13TEZ6WdxnVKk89zFVM46JZfc1suIHRok8281vhDEVPOdi6J5FiS5lSyi+qiKo2sUATwjiBdpwuWaJIgCFVSKweh3VoAofteGOEurCbarYpkI0VsIryh0m3ooS6M69X9hmjnxWE1BJUYOhCJ+dVTGli7gGW8Rk0CQCzjUbwA08un/MjmzcpwCpQ5XLs6gUxu/
 Au0qGePP
 qxlxb3ZHTdboLlIP9W5oEuSquXJfNeP9vHhL+yXR4vBN+6L6AEyJbyoWjeM4yDcviLt+FA/Mx42y0cjpDBdIqNdNxDG3F4xD3tmRTlcGBi/fSGdyqOUZpdsGZ6HpQ8DtiLwERTmgURO0EYXwgLYC8UjelO3VwFhwSZUVDi1q2uLWtCOsyCsdBMAPKi4Nji7TjIpuEgMP2ZqTghRLTaWxS6iLpJ+ox0WRZl7Q2sY9Sm1t9mo7AntR8dgF41R6FFCQlQuYtl80ZZTpPkID9Vb+lSQghNnVQ5aaXkLaK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 1:25=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 02.08.25 01:45, Sudarsan Mahendran wrote:
> > Enable these tests to be run on other pfnmap'ed memory like
> > NVIDIA's EGM.
> >
> > Add '--' as a separator to pass in file path. This allows
> > passing of cmd line arguments to kselftest_harness.
> > Use '/dev/mem' as default filename.
> >
> > Existing test passes:
> >       pfnmap
> >       TAP version 13
> >       1..6
> >       # Starting 6 tests from 1 test cases.
> >       # PASSED: 6 / 6 tests passed.
> >       # Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0
> >
> > Pass params to kselftest_harness:
> >       pfnmap -r pfnmap:mremap_fixed
> >       TAP version 13
> >       1..1
> >       # Starting 1 tests from 1 test cases.
> >       #  RUN           pfnmap.mremap_fixed ...
> >       #            OK  pfnmap.mremap_fixed
> >       ok 1 pfnmap.mremap_fixed
> >       # PASSED: 1 / 1 tests passed.
> >       # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> >
> > Pass non-existent file name as input:
> >       pfnmap -- /dev/blah
> >       TAP version 13
> >       1..6
> >       # Starting 6 tests from 1 test cases.
> >       #  RUN           pfnmap.madvise_disallowed ...
> >       #      SKIP      Cannot open '/dev/blah'
> >
> > Pass non pfnmap'ed file as input:
> >       pfnmap -r pfnmap.madvise_disallowed -- randfile
> >       TAP version 13
> >       1..1
> >       # Starting 1 tests from 1 test cases.
> >       #  RUN           pfnmap.madvise_disallowed ...
> >       #      SKIP      Invalid file: 'randfile'. Not pfnmap'ed
> >
> > Signed-off-by: Sudarsan Mahendran <sudarsanm@google.com>
> > ---
> >
> > v1 -> v2:
> > * Add verify_pfnmap func to sanity check the input param
> > * mmap with zero offset if filename !=3D '/dev/mem'
> >
> > ---
> >   tools/testing/selftests/mm/pfnmap.c | 62 ++++++++++++++++++++++++----=
-
> >   1 file changed, 53 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selfte=
sts/mm/pfnmap.c
> > index 866ac023baf5..e078b961c333 100644
> > --- a/tools/testing/selftests/mm/pfnmap.c
> > +++ b/tools/testing/selftests/mm/pfnmap.c
> > @@ -1,6 +1,7 @@
> >   // SPDX-License-Identifier: GPL-2.0-only
> >   /*
> > - * Basic VM_PFNMAP tests relying on mmap() of '/dev/mem'
> > + * Basic VM_PFNMAP tests relying on mmap() of input file provided.
> > + * Use '/dev/mem' as default.
> >    *
> >    * Copyright 2025, Red Hat, Inc.
> >    *
> > @@ -25,6 +26,7 @@
> >   #include "vm_util.h"
> >
> >   static sigjmp_buf sigjmp_buf_env;
> > +static char *file =3D "/dev/mem";
> >
> >   static void signal_handler(int sig)
> >   {
> > @@ -98,6 +100,30 @@ static int find_ram_target(off_t *phys_addr,
> >       return -ENOENT;
> >   }
> >
> > +static int verify_pfnmap(void)
>
> You really want to pass in the address, and verify that that very
> mapping is a PFNMAP. (not something unrelated, like the vdso or
> something odd like that)
>
> We have a helper in vm_util.c that might be useful: __get_smap_entry()
>
> We also have a check_vmflag_io() in there. So likely you want to add a
> helper check_vmflag_pfnmap().
>
Done. Sent v3 patch for review.
>
> Nothing else jumped at me, except that phys_addr might be better called
> something like "offset" now.
>
> --
> Cheers,
>
> David / dhildenb
>

