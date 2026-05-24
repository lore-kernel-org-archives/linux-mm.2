Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4610CCD5BB8
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 02:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122916B0092; Sat, 23 May 2026 22:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3776B0095; Sat, 23 May 2026 22:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04266B0096; Sat, 23 May 2026 22:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC6DF6B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 22:53:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EB811A0C38
	for <linux-mm@kvack.org>; Sun, 24 May 2026 02:53:42 +0000 (UTC)
X-FDA: 84800793084.02.D51372C
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 61767100008
	for <linux-mm@kvack.org>; Sun, 24 May 2026 02:53:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jkoU16Zp;
	spf=pass (imf05.hostedemail.com: domain of jillravaliya@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jillravaliya@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779591220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJU1WI0ApMjCZhKMFKsjNhiewF3RRbggYCCtCbOQ6Cs=;
	b=6ZOgLCydIIonTmm4ro3M+OklsJqYLLyqDSj1JYh/11DxwN+H4fbQV4Ly/deYOF+bTLL6Yu
	yYBYFYgIJgYvIccgz8bHeleByxo554+JYNLRVcaWEXmWcT8T8KZQKfSsCjcNq/bw94bFJV
	NH/b486mxYT4saNAmos0OMAPh3WEQMI=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jkoU16Zp;
	spf=pass (imf05.hostedemail.com: domain of jillravaliya@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jillravaliya@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779591220; a=rsa-sha256;
	cv=pass;
	b=bJaD7LTqojSCebAjohBK2OPBeLxo7VOUTM9kRHzakX/YYEZAH5DA/53fLBMMldUN+JMjeR
	swxal8SOgR21bUz3MEb9byFMsdaFjav+j//rHecyoyfl00fhraGpdWGsJ79USFIF6yz5s7
	7uVnwXt9SMRchsAHRn4vfXlnhxgSTMk=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bcd3c190f71so1396270766b.0
        for <linux-mm@kvack.org>; Sat, 23 May 2026 19:53:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779591219; cv=none;
        d=google.com; s=arc-20240605;
        b=MywnPYJvSzP3bUF4aQsvknZE1iK59tVXL3aJlGhePQ4l38N0YBWdcJADipddQEWpqv
         //IsKhql/u1j+CO2dGh/6UmTjTc3nbrOTj0SoCYOvwXSurkoq+ypW6xA32hI49aF9aaT
         V7Kb9Vx6gTIqZOuF6fmOYacfAvjC6D59CytWujWy7MLFUg862V/7Lwlj/m+B9cLv2alm
         uUdtWORgranOOSx/o0kKZz9Y1LjBXkMJ4AJMfi9LIMWWXaS8PIIB2Nlz8aFH6I6x9wSf
         VJtNk6GZf+XiQ1eTcuOqDY3QzkkFEWwrgrbzRi6qqTWPIG/bHenecJCxRsZZTHkhNEcl
         HKCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tJU1WI0ApMjCZhKMFKsjNhiewF3RRbggYCCtCbOQ6Cs=;
        fh=W6wR73G6trBmVE7FlV7kCHoQThROt57RSqajUq+nsIw=;
        b=FYqehO0w9GFI8jYbfPDXehSwwl4BKnQBFmqWA+0m+K5PgkUs7NroeIf0EiBdP+cjXV
         AkxV8I3L1lToHXYaW934RUaAAF7hioocD7ub7oGBj++EzsbaxI7nL8DUtAJZq/NCStWi
         VSqFztLKP3ks0Tbe2dB6t0iG1LKA3s2BNyHpIKLF+BNqf/PHaqjzF5JpkQmajauqBLXv
         sFPKaM8DvA5QVHcVsU1l7NACG/1hIh7BcnfpHb/Wlc+1evEDoErZbV3DYk8zAD/t7tvE
         FI/vGDWlQbyMIGVPWuesGgAGzIb6hPn/gZEmA0Txte7jjeXeLT1JIpjKqQBKkVfDZkT2
         nm7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779591219; x=1780196019; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJU1WI0ApMjCZhKMFKsjNhiewF3RRbggYCCtCbOQ6Cs=;
        b=jkoU16ZpolW+sGgshSFHMcCydO4Cg7m/RDLWnsXNmMOINd8g7XrihcefFi7ftJ0NQ5
         a7YvtcoZ5vqshQzblKZg7rfzHbZ5JJDcezgOvgnvB8JvWhBv2LExlZz7rdt5/jOAdrJb
         QnTJ02/P11WngCHm1qYOCh/2wh8Tr0eJv0/C2wbNAfOuB+20nGBg3viSS+BpBSh6Olee
         9IkAHdOzl12qp33/U6Rm18nrJPgXLPoStHg73SYDPMLdqGqmMyDUD4//lmwYuh3wQMMu
         YhDkQu0u8sSS/sesWXbrNLAakKH1rkb5kW90e62kn6lOtOKNnHqrAk7xXBrVz28emXBn
         zdSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779591219; x=1780196019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tJU1WI0ApMjCZhKMFKsjNhiewF3RRbggYCCtCbOQ6Cs=;
        b=bADLR3WU6Hl/fim9K+IpV/C+rHz8Xn3md7B4X6O0AyzrPm1wRiTAU+aABDQZPUDKcc
         LEQXJ0/AHlimp6doFijjzq2ked6AJtUXZXwgshNiGIRPbLCIqnwecxIXHoB7r0u3fmu1
         PMQETgnQqVE3cQoGHR2MlxV/2gpGwhehVjBhA1UF/DJQLXCB9n37E2zGeg8G6HxsaTF6
         T+HthRaMVVSZXIt9gCn/AuDByqID0GZlJnu9ZrsSElqo2OpjhCMtfvVHg0+gIvWH/zTY
         22KY9K9CEpD3rTpxX9bjsRR9pE29+MiIQ1bXHY4Tspl3Lj/0fKcQwnh2aMIKcplAHEjR
         cGpA==
X-Forwarded-Encrypted: i=1; AFNElJ+2Y1FUpfoeRF1EtpMI0Sb7DBU11+6fZeMljPMJAJTQ5crcGCWG47t4mkKZeH8cW+WYS/3dfK1AwA==@kvack.org
X-Gm-Message-State: AOJu0Yz3xH3nSqXu8GMAYdEvNIquGPAj3euuf80LH6TXTep9w69Wea+g
	l39+NBetjsS4gyefCiwWLm/0BxxNLOWZZOrS96vjCkcQe4UiEbpPpnG8+oemcgfEaSNg41SiqNN
	8AmQl6DFiJp1ETSsGv/MXHTBdkpXVotM=
X-Gm-Gg: Acq92OEugIPsmtaUVMw+ZTZ8r84lTfkMr8GJV0Vg0nBrpn9K+W6Yb8x6C+nNKe3wDhQ
	dRoX4+NZXYWg6hUl31xoifwfQQ9lqNA3vG8dDFLdrBjxv2v0ZphqZprdmBy5ZmCdnjOOKi4jHWN
	4En9ytDeEYZXx6TWl9LJIx1+66WtQM7F9uyeHppC2PeVdLEi8fRF8mKsdVosP9OWG4JDrsoT41y
	732oTep/Ogyn5UrDwDSqaYmp46U8NJm5XcillPZAwefbo317l5aDc//KWVTggSD72p2K7HEdfsj
	fhNp5CIHYx97a0/lZqfWBfYrTtzyvFaWsUxxzhB/8g==
X-Received: by 2002:a17:907:a647:b0:bd5:d06:52a0 with SMTP id
 a640c23a62f3a-bdd278c9516mr572664966b.43.1779591218444; Sat, 23 May 2026
 19:53:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260507114854.41117-1-jillravaliya@gmail.com>
 <20260507114854.41117-2-jillravaliya@gmail.com> <ahHT1wDkF4Dg3R7P@milan>
In-Reply-To: <ahHT1wDkF4Dg3R7P@milan>
From: Jill Ravaliya <jillravaliya@gmail.com>
Date: Sun, 24 May 2026 08:23:25 +0530
X-Gm-Features: AVHnY4J2vOMyTJGk9pgeo_CLP3RoQSuMYoR7zig_3PmuI0UTRZ8ZhnmNcnHiBag
Message-ID: <CAHr0Pbtc2qMSk6_h5fXEViTPTd=D217ZW8E9BsbF1n-=-3aqHQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] selftests/mm: add test for vrealloc() shrink page freeing
To: Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m1fgn4r9m43znxaiqa5fio1rswb8nd1u
X-Rspamd-Queue-Id: 61767100008
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779591220-334247
X-HE-Meta: U2FsdGVkX1+siMG4lMdaB9hqVgUVnMGXAQUH7kZtdMk3nF5OVCXImqUMWLiWRAYYN9XNBvc/lLG4F4g2VxfASFJysvJN04EU6+MSfemQvHuGQ8aZtnfP1kIRRqFIG36hSjrCbDBntzxvicgmVvfdon+4LtzOEgdXm1SLUrIrx3keUhbyvApfkUYfDiAdc8u9mkIeIgdhIxWeVSKFH9JApz7P2yHQJOLLgztifuBVniBRkuX8jjVH+I5cL8Q6UCQXNPKvb+fPaG4ufmbfgOMl014YflDt1jNNTUkA/jEback5y1ECMzMW8SK1dunQ3Q2ApSHIQMmWq30FY0zOCkro45AkazyCAVNAwzcTmET1T7M6hlxvG8ezXSMLcDft23f0h/C3WxZXgXhwLnKMu/7j4Xy++JNCGfcR4hq+D8nlEhYFkWfJ3mb3fdd36naFDg3Yy6Hg+s+7d0u1D4MtLnKBIKyuv0S2yelHLKCpEf6YVg/FVrmV4cA7FbvwFeWlEEo1gEE1MwDt+lg8B+0VPrO77FR+mkvBcTA5OwzhXvMArmyd+pP7mCk+toLdlRVTvIM8jLJR7gzM/VZm6GPBfQywnpbMBE6Yr6v/VexbMaBVCxrjkN8iCiTWWEtXpzlg1ScrTI5bhVp+vrYfJvQc4F2OeLsQrd7SDDerOLrUGboX6593wTwqNP+lQuDPWTClCMhNSPGQ6bM7lt3Pl0IjrXJEZfIjooOlOgPJcZh7Qnn50pB60qQmfNtb9ycKyICPaBXwtPbgjF2irgNmYLZqiot3wRNRxp1+3BH8irGlYaM/LJhasgm0GQO47Hp/Y9VitnC0UdR55GRFADzdRAB58MaNT/8Q8dgfirUkR29OHtJC1M99aNWytO+bENBvRaClS1X/zgSUM26D7YLA9GKKrPk7oHA12+W1k5Y84nSx2R78vzoJpTDSO1ezxwPHjRjElZLuPhSJXta45N2py3+cH5K
 XV4ecnX/
 zpcpf4NWjMW0Bs/G0IpPtDc+8hQE3lWxcWUGRCmIINjB9nRUgtPvFQ7iO7nSCtotapsPxjEOpGPEWeEK1z/GMHqB3rWkxs/jrBizlKcGsITf31OHouh5wxZCbsrwuMAmM1D7l/F/5GtrnDHyGI6HcRXW2bVOxqlkcO5ZAkjJ13CN/aQCZ/rVhsAmY3EBo+6OF58nIlll1RsoKswAlszMVrfcj2FjV9bnIVGtAQbYBUhRQaa8eUqNeoB/zm37W4UnbKtS//XAtygQpIf21Dr6G5uicXARoHDDmJSvtkcx6NifFpuWY8T+xfM8nABa76dexUsKIGiiyKHHUve9S6FX9X2fdpJgNaziAG5Wckz39aZdjw3tm3sxqZbcrkdMHMIdgjR3fM/dDetiKa7RoD4Wl8bQ+UO/eKacyHoyWt3iffNS8FdIgDJeJVXmmkYATnhgi4Cf5TZrswuEMNjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Uladzislau,

Thanks for pointing that out. I'll check test_vmalloc.c right away.

Jill

On Sat, May 23, 2026 at 9:50=E2=80=AFPM Uladzislau Rezki <urezki@gmail.com>=
 wrote:
>
> On Thu, May 07, 2026 at 05:18:54PM +0530, Jill Ravaliya wrote:
> > Add a selftest that verifies vrealloc() frees physical pages
> > when shrinking an allocation.
> >
> > The test loads a kernel module that:
> > 1. Allocates 10MB with vmalloc()
> > 2. Touches all pages to force physical allocation
> > 3. Shrinks to 2MB with vrealloc()
> > 4. Verifies free page count increased after shrink
> >
> > Without the fix, the test fails because no pages are freed.
> > With the fix applied, the test passes confirming ~2048 pages
> > are returned to the system after shrinking from 10MB to 2MB.
> >
> > Tested on kernel 7.0.0 in QEMU.
> >
> > Signed-off-by: Jill Ravaliya <jillravaliya@gmail.com>
> > ---
> >  tools/testing/selftests/mm/Makefile           |  5 ++
> >  .../selftests/mm/vrealloc_shrink_test.c       | 65 +++++++++++++++++++
> >  2 files changed, 70 insertions(+)
> >  create mode 100644 tools/testing/selftests/mm/vrealloc_shrink_test.c
> >
> > diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selfte=
sts/mm/Makefile
> > index cd24596cd..4eab7c76c 100644
> > --- a/tools/testing/selftests/mm/Makefile
> > +++ b/tools/testing/selftests/mm/Makefile
> > @@ -104,6 +104,7 @@ TEST_GEN_FILES +=3D hugetlb_dio
> >  TEST_GEN_FILES +=3D droppable
> >  TEST_GEN_FILES +=3D guard-regions
> >  TEST_GEN_FILES +=3D merge
> > +TEST_GEN_FILES +=3D vrealloc_shrink_test
> >  TEST_GEN_FILES +=3D rmap
> >  TEST_GEN_FILES +=3D folio_split_race_test
> >
> > @@ -282,3 +283,7 @@ warn_missing_page_frag:
> >       echo "Warning: $(PAGE_FRAG_WARNING). page_frag test will be skipp=
ed." ; \
> >       echo
> >  endif
> > +
> > +# vrealloc shrink test module
> > +vrealloc_shrink_mod.ko: vrealloc_shrink_mod.c
> > +     $(MAKE) -C $(KDIR) M=3D$(PWD) modules
> > diff --git a/tools/testing/selftests/mm/vrealloc_shrink_test.c b/tools/=
testing/selftests/mm/vrealloc_shrink_test.c
> > new file mode 100644
> > index 000000000..cf4263074
> > --- /dev/null
> > +++ b/tools/testing/selftests/mm/vrealloc_shrink_test.c
> > @@ -0,0 +1,65 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Test that vrealloc() frees physical pages when shrinking.
> > + *
> > + * vrealloc() shrink path previously zeroed unused memory and updated
> > + * vm->requested_size, but never freed the physical pages backing the
> > + * unused portion of the allocation. This test verifies the fix by
> > + * loading a kernel module that directly measures nr_pages before and
> > + * after vrealloc() shrink.
> > + *
> > + * Copyright (C) 2026 Jill Ravaliya
> > + */
> > +
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <unistd.h>
> > +#include <fcntl.h>
> > +#include "../kselftest.h"
> > +
> > +#define MODULE_NAME "vrealloc_shrink_mod"
> > +#define DMESG_PASS  "vrealloc_shrink: PASS"
> > +#define DMESG_FAIL  "vrealloc_shrink: FAIL"
> > +
> > +static int run_cmd(const char *cmd)
> > +{
> > +     return system(cmd);
> > +}
> > +
> > +static int check_dmesg_for(const char *pattern)
> > +{
> > +     char cmd[256];
> > +     snprintf(cmd, sizeof(cmd),
> > +              "dmesg | grep -q '%s'", pattern);
> > +     return system(cmd) =3D=3D 0;
> > +}
> > +
> > +int main(void)
> > +{
> > +     ksft_print_header();
> > +     ksft_set_plan(1);
> > +
> > +     /* Insert the test module */
> > +     if (run_cmd("insmod " MODULE_NAME ".ko") !=3D 0) {
> > +             ksft_test_result_skip(
> > +                     "could not load %s.ko - is it built?\n",
> > +                     MODULE_NAME);
> > +             ksft_finished();
> > +     }
> > +
> > +     /* Check dmesg for pass/fail */
> > +     if (check_dmesg_for(DMESG_PASS)) {
> > +             ksft_test_result_pass(
> > +                     "vrealloc shrink frees physical pages\n");
> > +     } else if (check_dmesg_for(DMESG_FAIL)) {
> > +             ksft_test_result_fail(
> > +                     "vrealloc shrink did NOT free physical pages\n");
> > +     } else {
> > +             ksft_test_result_fail(
> > +                     "could not find test result in dmesg\n");
> > +     }
> > +
> > +     run_cmd("rmmod " MODULE_NAME);
> > +     ksft_finished();
> > +}
> > --
> > 2.43.0
> >
> We have a test case that covers vrealloc() functionality. See test_vmallo=
c.c
> file.
>
> --
> Uladzislau Rezki

