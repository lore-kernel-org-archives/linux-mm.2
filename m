Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9111AC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 17:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D6D6B009E; Sun,  5 Jul 2026 13:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E0D6B00A0; Sun,  5 Jul 2026 13:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEE2C6B00A1; Sun,  5 Jul 2026 13:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB3D6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 13:58:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17E321C6E91
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 17:58:40 +0000 (UTC)
X-FDA: 84955483200.06.F616049
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0750C180004
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 17:58:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="u/xo8ae5";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783274318;
	b=kw4cBTd7CZzx2RQaqH0usAnfRo4UnZjNLTkshpG9Et6CqptMd51Ps13tO9w5aEue4zLJWG
	NxSEFDX0PP2DzQqV5P+iqBUufg1kOFxK4pJfEMZkOI0IASEQNhgoeGpijiLoIscqaoTLgG
	ja+UsD8Sta0b+mEsQI7HN1dmyfTZJdk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="u/xo8ae5";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783274318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqVYUigsG2CB8elLPNwQAP+IU3+6cK1g9IZqqW2a86k=;
	b=vU3S9fDCDeWpYZvpO3wJo9t9FPjRc3Q0FEeUtuWSxCWnBXQHhfftmOf8J+DWUp1tdGs30F
	54pwvtw4ktbAJqFUA7Q9O4KMfZsZe+VPu2UwQqdDPRpc70WUQFjKXAPfcLyt2wFoWGq1K7
	OTCUHx4ZpYW4Mb74enhWmI6nDJY0Niw=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493b8d92a4eso208865e9.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 10:58:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783274316; cv=none;
        d=google.com; s=arc-20260327;
        b=QQryfS3CoaqZ0z7G5rOjv+thhsdHk3wCxPPtRDmGktNs1zkEn0A0Lqobl1tvRfqFWM
         u5B81XSz5pTkNk1kgSs54zyKMCIst6sZDuIKg2q0boCYBxMraISxvl6dD7H8OTn45Gtd
         VzztJnAJ0VDXJYQFm2p2uAhFHVRZLaC9AKNPg1fnm/6CFH78kEqg4N3pD3sqM8QIe6Tv
         N6ReW2yEpwrY9GSpwBTcE6v21PWZPEAraEPVyhSliFut6Gv3QL7KkuB0mSH+a1XVQvAO
         CHhdzEmLch3Vq0Lu1T/Me9TjQBj9+cD3U0QNv2FYroRBzkSQaUQzlIOhCIyKpcGsh5tu
         X+Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HqVYUigsG2CB8elLPNwQAP+IU3+6cK1g9IZqqW2a86k=;
        fh=PgEejNb42k1o0uH6d2lId/XFdtpz5CqdyLTVkSWaNDk=;
        b=YukPNnN6JvRsrTg+PQdDHOPsfrMnLH0px9S/ZvPLmdAOiqxEIZ/Ar1AMdSbgGEjAQZ
         Sh1ejbejjcd2bnRYBoYS5/fGLXGDqDUKaSyb7GENAGZUppsoTG8O6ZmSgzmXZG8Bj2sj
         ooPfA+0jDVZ0/UuPBS7QPB3ogcNmrDX7ccwTvUmNl+/onni9Q2L5P7TTwUOaHujPdYUj
         VYHFVbj5rT8VqyHZLFExFecWDwuFieLJN3EqnpWRvzldQMESYQnRbSPXOnMZuBKKQaxW
         XXFrROaTR1cySIdFs61X68rtNdq/4HB4GPZQQytbch+zTpT7x3qjngocaty1t7oF73cM
         igJg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783274316; x=1783879116; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HqVYUigsG2CB8elLPNwQAP+IU3+6cK1g9IZqqW2a86k=;
        b=u/xo8ae5flciIS0QNQ48XaBnTC482Av4KahQSNcA5LzLKQSMDjXhvSdpHXSUY7lO+W
         RRp1OyaBjk1wvHLttvaly8i5DKH/3vueHBNd+/Omxr2a3NSXesxiDGcl/IQj9+zdm8DS
         Icg8w7wF+5XpfiHQFKhsPxP/4ywo6opixTJ5vF5KrU8wpNc2xEUxeCqvTbyk1jcRHxIS
         IK1f73U2r2ou0vt0BDpTwrD0Ld8XIL4br7+0wvHgrMTDRRCfGNfy1VlHQdHxD0TWpFJN
         2tj4DNzcPYdSusYak5imxg8X5b0AkZo95+YnL/n2zoex6v/gd/D5VEk0LJudrii7NEDu
         dJvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783274316; x=1783879116;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HqVYUigsG2CB8elLPNwQAP+IU3+6cK1g9IZqqW2a86k=;
        b=dnqc6+/4H/ZNozc7ixnHalIv7I/0bP3dWRhFgtW5+lFfGcQCb8D/aUocCyiU2AOhxN
         0AXHVkOa/cM2xD62/ActOTYU4XkHaK1834DrtTIoMB8ij4f3v7AhgfAaAgJ94Y1qZcgg
         l+kwP/asbMoZ6krDdbkCXKWVFZobIdX4VTXcDd1171c0/QGexRQ8HDl1tTbb7xL/t38D
         nYDnm3tjU1q8y5n//IeqDF7YbBsUZAsz3QX6MMKAiIjv9PoJyF1DMIWHIdRmfErOishx
         DMfYirGkZ0DcMlpheH3csb5288N0QL9Q/QUkVIFfpVXb++3WNGBA4G93XqEFCRpFTkNw
         3p/w==
X-Forwarded-Encrypted: i=1; AHgh+RoVZmzFfXyQ30o4lGg00nIFbxIvDIC92uTX0WxJ6ss1V1kbI9sdtOreQRrAxHZO08arhiuhbT3IAw==@kvack.org
X-Gm-Message-State: AOJu0YwarCuFLhR3ph7ErnGAVhvjFYtPGpoSTUuMSiS9F787bTXbKOwb
	5Y5HeapjOZriSlrYQ8Pk8zBmbpS1qlLEUHFqbUI7DTm1jTpfI2uTRz71LEbTKgKjyL0BNhpAjcc
	B+lpYUYfkQASlgJHCy1uM0znKKtMo9qfQf5lff8ah
X-Gm-Gg: AfdE7cl+FE8rCTLlRg2vPp+M3U5leQ7oWtbkx7lRwkdhVgVy8yHlu4CMZeQKY4zaS+k
	sDxhQ3csXcEHULgaup1UOnvHPXbQxhYx9OrLm5M11SvPyOAig4Up/k4apODDjrXZph56EAD8nB3
	2gOYncxzFnOo2pt37S0JqN6R01ZB2TWcNzBTliPN4P0cx8q1BrMJjjEENdIHgxZ217r/DokiwwX
	R4IaJ8yyMUTMR7hiELjPtrIG565x1oGRr8yjb5GJqGjSXW4elCLSA5aZdYF94RMl1LRRcMML58O
	6IzQ2f9NuYVXvaJrMyuNmwO7yMcrjw==
X-Received: by 2002:a05:600c:6096:b0:493:b169:784d with SMTP id
 5b1f17b1804b1-493d1083f99mr2694615e9.8.1783274315895; Sun, 05 Jul 2026
 10:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com> <20260531055829.3636554-5-jiaqiyan@google.com>
 <d1333353-b615-2dc1-ecff-8093d237cba7@huawei.com>
In-Reply-To: <d1333353-b615-2dc1-ecff-8093d237cba7@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 5 Jul 2026 10:58:23 -0700
X-Gm-Features: AVVi8Cd9zRYHvPs4tUWZyZW9WTTQLQY0esjkwEXUfIe1gSfc0fP1Ur9HOLM9gk4
Message-ID: <CACw3F52nV8JnYG=7DKqECZjaHQwF=-P5o8mGfgJVDq-EbALweQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] selftests/mm: add hard memory failure anonymous 1G
 HugeTLB page test
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, ljs@kernel.org, 
	osalvador@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0750C180004
X-Rspam-User: 
X-Stat-Signature: 1fj8mnc5r7xwogxs3g9e1mtckz4t9ju1
X-Rspamd-Server: rspam03
X-HE-Tag: 1783274317-274607
X-HE-Meta: U2FsdGVkX1/WnEbxRuHsI0Xn9H0z9/dkuiH0yd6ArgK9N7sheWulL4T3C3qd1+Xi9kGjrk5SKVLt2w01Zs+LL7TWdWFhVY6bQgJ6L4+HBMjckgcsHEEwB6rjOyG6GioOSKPTEQF3oWsCE/4Xjil36Mm0wdcgYanAgWsGGivBn7hc/7jPl06F9hZcQhedU8512JBn4n2kWXCZgyt3NAzxS2CSWj/84c+enJY4nsBaMwA++aA4oPCuFR60ckXCdIlq18AA+kAWJVVAf1vSM8vyAWFtq1swZrs4smCh4gxZzkRPdFJ7b6HE6OlEcuK0H0bSnaaDmq6Bo5fXu2wDu1TFol1z2Ud466Ht5ieg+TUz1F4r4L3kJR8IDH6/2/O9vnjk80tEUzKnRXtgEk6dUyPrsU7RUEI2j6Oms7v+Q/E1aXBHIFv2Ec1/NkxXmxizFbhVtT56oT7LgRIKd6aEYPTpgAf30rkjaPo2174oR/6eSSzqWxfQUQyw/iqcfR2mtIZ0jeDBdB7ghBcUK20u0t1AtDteLKNcw964qKrYyn/TdpnvarNlH0zxbrGjc0bK8RqEpGsnWvg23lSR5AC600VKChElpPmxScdSd3Jk0jQ/203zBUZ0MrqN4jfEhEgWDmohiBVL5FFzZ80yiBdjYpPJzF4xEohVDtoY97qDQDqQlmAJLuFhyuZSvLaZdefBghz8sDjsKeF0JEuHjjTdu56nkzD72I/hmybzZ03qQdDLoQVPqTnaHkCs/2ityFTtjUpBF3owSzyJO34X0RskatSkOqPbJQdX7LvZcN3T8wHdUGTmEpweVkXu2MTkdRxaj+TaNh0gL5gYjKkoMIwhIAQG0gS8Og8gU8FS0BBiJRd7R6Poj2aoqPg45EzU6QmFoa2gim1Qd8omJ667GYde7svT49CdZyG9cfaesC6o635FZ6nTt9XmeR8NXV1Fn4J+Xg5CTocVbeiiRQwFIu+39fN
 fAQmGsXB
 VRwgCCCONT/kVXMsXd6JbRT9e+BjOXX12Vf9to7jcAGl/XP7lHf5WV0tWL9ta5XAisQJO65/QaBxV0PAIRIH4/G2ZyjcrEscBBDNHOAZKW+FA8Hxl1d/q1vw0/AYYqMTnfFEcOM1mC6QxziVXEBnaFZPJJD/vNOvPdfw6sXu3NWIewRbwD0vP6nTt5qjq78T4hMMuSQk9WyDiSr6fIo55j/IaL+7G4SZRbCi6qRXqFW407DDrchFNtakwVlTIJi9HS9yjLhaNDbWGZ8JCMNF0AFXksOdU3ZtoR5JIjIm9Dgmwld8l3AjwxHU3oLtY27CRZ/YdOM2/Vu2DkuTb6y+RczeS2DttE+2doYwOLWPbBfoYuac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 12:38=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.com> =
wrote:
>
> On 2026/5/31 13:58, Jiaqi Yan wrote:
> > Add a new testcase to validate memory failure recovery for HWPoison
> > anonymous 1G HugeTLB page, including proper SIGBUS delivery,
> > releasing a 1G HugeTLB page containing one HWPoison page to buddy
> > allocator, and isolation of the raw HWPoison page.
> >
> > Although can be added in future, this patch does not support testing
> > the MADV_SOFT variant.
> >
>
> Thanks for your patch. Some comments below.
>
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  tools/testing/selftests/mm/memory-failure.c | 73 +++++++++++++++++++--
> >  1 file changed, 68 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testin=
g/selftests/mm/memory-failure.c
> > index 032ed952057c..ea43b2877c81 100644
> > --- a/tools/testing/selftests/mm/memory-failure.c
> > +++ b/tools/testing/selftests/mm/memory-failure.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/magic.h>
> >  #include <errno.h>
> >
> > +#include "hugepage_settings.h"
> >  #include "vm_util.h"
> >
> >  enum inject_type {
> > @@ -27,6 +28,7 @@ enum inject_type {
> >
> >  enum result_type {
> >       MADV_HARD_ANON,
> > +     MADV_HARD_ANON_HUGETLB,
> >       MADV_HARD_CLEAN_PAGECACHE,
> >       MADV_HARD_DIRTY_PAGECACHE,
> >       MADV_SOFT_ANON,
> > @@ -47,6 +49,8 @@ FIXTURE(memory_failure)
> >       int pagemap_fd;
> >       int kpageflags_fd;
> >       bool triggered;
> > +     /* Number of initial HugeTLB pages with default page size. */
> > +     unsigned long nr_hugetlb_pages;
> >  };
> >
> >  FIXTURE_VARIANT(memory_failure)
> > @@ -157,11 +161,11 @@ static void check(struct __test_metadata *_metada=
ta, FIXTURE_DATA(memory_failure
> >                 void *vaddr, enum result_type type, int setjmp)
> >  {
> >       unsigned long size;
> > +     unsigned long nr_hugetlb_pages;
> >       uint64_t pfn_flags;
> >
> >       switch (type) {
> >       case MADV_SOFT_ANON:
> > -     case MADV_HARD_CLEAN_PAGECACHE:
> >       case MADV_SOFT_CLEAN_PAGECACHE:
> >       case MADV_SOFT_DIRTY_PAGECACHE:
> >               /* It is not expected to receive a SIGBUS signal. */
> > @@ -174,6 +178,7 @@ static void check(struct __test_metadata *_metadata=
, FIXTURE_DATA(memory_failure
> >               ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self-=
>pfn);
> >               break;
> >       case MADV_HARD_ANON:
> > +     case MADV_HARD_ANON_HUGETLB:
> >       case MADV_HARD_DIRTY_PAGECACHE:
> >               /* The SIGBUS signal should have been received. */
> >               ASSERT_EQ(setjmp, 1);
> > @@ -183,17 +188,36 @@ static void check(struct __test_metadata *_metada=
ta, FIXTURE_DATA(memory_failure
> >               ASSERT_EQ(siginfo.si_code, BUS_MCEERR_AR);
> >               ASSERT_EQ(1UL << siginfo.si_addr_lsb, self->page_size);
> >               ASSERT_EQ(siginfo.si_addr, vaddr);
> > -
> > -             /* XXX Check backing pte is hwpoison entry when supported=
. */
> > -             ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
>
> Can we write this as something like:
>
>                 if (type !=3D MADV_HARD_ANON_HUGETLB)
>                         /*
>                          * XXX Check backing pte is hwpoison entry when s=
upported.
>                          * Check backing pte is hwpoison entry when suppo=
rted.
>                          * Although try_to_unmap_one() also installs hwpo=
ison entry
>                          * for HugeTLB, pagemap_hugetlb_range() doesn't p=
arse
>                          * swap entries at all.
>                          */
>                         ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, =
vaddr));
>
> So we don't need to modify the if condition when more base page size test=
s are added?

Of source, should be fixed in v6.

>
> >               break;
> >       default:
> >               SKIP(return, "unexpected inject type %d.\n", type);
> >       }
> >
> > +     if (type =3D=3D MADV_HARD_ANON || type =3D=3D MADV_HARD_DIRTY_PAG=
ECACHE) {
> > +             /*
> > +              * Check backing pte is hwpoison entry when supported.
> > +              * Although try_to_unmap_one() also installs hwpoison ent=
ry
> > +              * for HugeTLB, pagemap_hugetlb_range() doesn't parse
> > +              * swap entries at all.
> > +              */
> > +             ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
> > +     }
> > +
> >       /* Check if the value of HardwareCorrupted has increased. */
> >       ASSERT_EQ(get_hardware_corrupted_size(&size), 0);
> > -     ASSERT_EQ(size, self->corrupted_size + self->page_size / 1024);
> > +
> > +     if (type =3D=3D MADV_HARD_ANON_HUGETLB) {
> > +             /*
> > +              * Only one page is hardware corrupted; the rest should a=
ll be
> > +              * released to buddy allocator.
> > +              */
> > +             ASSERT_EQ(size, self->corrupted_size + getpagesize() / 10=
24);
> > +             /* HugeTLB should have lost the HWPoison HugeTLB page. */
> > +             nr_hugetlb_pages =3D hugetlb_nr_default_pages();
> > +             ASSERT_EQ(nr_hugetlb_pages + 1, self->nr_hugetlb_pages);
> > +     } else {
> > +             ASSERT_EQ(size, self->corrupted_size + self->page_size / =
1024);
> > +     }
> >
> >       /* Check if HWPoison flag is set. */
> >       ASSERT_EQ(pageflags_get(self->pfn, self->kpageflags_fd, &pfn_flag=
s), 0);
> > @@ -247,6 +271,45 @@ TEST_F(memory_failure, anon)
> >       ASSERT_EQ(munmap(addr, self->page_size), 0);
> >  }
> >
> > +TEST_F(memory_failure, anon_hugetlb)
> > +{
> > +     char *addr;
> > +     int ret;
> > +     const unsigned long nr_alloc_hugetlb_pages =3D 4;
> > +     unsigned long alloc_size;
> > +
> > +     if (variant->type =3D=3D MADV_SOFT)
> > +             SKIP(return, "Soft offline test is not implemented");
> > +
> > +     /* HugeTLB settings will be automatically restored when test exit=
s. */
> > +     hugetlb_setup_default(nr_alloc_hugetlb_pages);
> > +
> > +     alloc_size =3D default_huge_page_size() * nr_alloc_hugetlb_pages;
> > +     self->page_size =3D default_huge_page_size();
> > +     self->nr_hugetlb_pages =3D hugetlb_nr_default_pages();
> > +
> > +     addr =3D mmap(0, alloc_size, PROT_READ | PROT_WRITE,
> > +                 MAP_ANONYMOUS | MAP_PRIVATE | MAP_HUGETLB, -1, 0);
> > +     if (addr =3D=3D MAP_FAILED)
> > +             SKIP(return, "mmap failed, not enough memory or 1G hugetl=
b not supported.\n");
>
> This test is no longer 1G specific, so "1G" should be removed too?

Thanks for the good catch, fixed in v6.

>
> > +     memset(addr, 0xce, alloc_size);
>
> For 1G hugetlb, alloc_size will be 4G. Would memset() here take a long ti=
me to finish its work?
> Same issue in check_memory(). Should we try to enhance this or it is just=
 acceptable?

I didn't really notice any long wait time when testing with 4GB here,
and I think it should be acceptable for a non-performance test.

>
> Thanks.
> .

