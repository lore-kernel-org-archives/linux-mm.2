Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F2C1CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 21:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C9F6B0005; Thu, 11 Sep 2025 17:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6140D6B0006; Thu, 11 Sep 2025 17:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529C76B0007; Thu, 11 Sep 2025 17:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3CFC06B0005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:26:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B4B581A0544
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:26:21 +0000 (UTC)
X-FDA: 83878252962.26.B73708E
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id ADD1216000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:26:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Wxb//3CQ";
	spf=pass (imf08.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757625979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=muvx9qdyEE3ghxoAMYPt3hoTct41JTKDZsOlOaOPEAU=;
	b=B3lVqyw27QNWvyxY+uUamxoqLdaPN0IUWkacnS3UKqy3k8IETiqAob/DxrYcJlSL0jH7rV
	oJNmBO7Xr9gHpFpdAgOidznXPTODDN0ooV0TFP+mo1+Ue6W1nhf0F5SHGQ3ROTFF4YEyOp
	jePOM+TComPWEXCx86ACdbD6sVUAyOA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Wxb//3CQ";
	spf=pass (imf08.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757625979; a=rsa-sha256;
	cv=none;
	b=hTqfeglA8RuoHq0+wMb0QkL8/PHxRPoP3gsfyXU/cKi1ZfU6aynT6Q5Vdz+Jqkrd6bYUss
	FwYPB3XmTtZOKrGDqfvfVOv8/V3qphomF6hblzYy49U9qxyeUwfYYOFBkkjALMSDlvaf3/
	dIi9/aWDSOFGvt0134U79UyAlERZR0c=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45dd9d72f61so24095e9.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757625978; x=1758230778; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muvx9qdyEE3ghxoAMYPt3hoTct41JTKDZsOlOaOPEAU=;
        b=Wxb//3CQCUzp/HvZi5n7CMKviuzTBUYs/41hiED6J3hgOIBKUh4PljtHjrvH0SPVs7
         FmkXBG0GB+QsEmT/cfX+K4gEoJFH1di7tDMKMTAbuvHds411cGLMjIAi8ZHj0SxxjPpS
         A6V2TauBUJA7Qj/nGich312pR2IHTNrnIkxFuT2HlC+HK4PdH0NCsiXUacqzMvmtzoNy
         891GmN4pOqEjSfzglkBm+v69ziF1loiK7uHM3YccZwCrWHudRN30yz1X6YRchgdayp7O
         DwDXbXTeenKBxv3uHQ/Ykvl2xfqwP47nwTKNkl91hOflqptiHfet5sAq35gNIjWAqWCY
         ckTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757625978; x=1758230778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=muvx9qdyEE3ghxoAMYPt3hoTct41JTKDZsOlOaOPEAU=;
        b=mTqNnzt3dQUHq8zlr0XPRqy0//hYzfMT5qg6G6Z/bIF5ywxR+RTN0af/0X96yy86nH
         tPpU47Ld96joKV0+lstmrHcdrQByNq/fMK6gf00Z84fjV1f5DMsAOyhtAW2VK90otFu2
         gh/gnic/vjFnaqEndxtNETk+SMzotcYLpTFzQxO8BeE6owGTWskXC1TccSC+2ZA7eX62
         YdBQLhyXEiH2/jeoYnwbCpdklnPquUvy3pwzGwTq3JYJOvAlQt5wmcbZrcoYORGJauEf
         PSk2e1NbPibt/zlj9+rh+xl824g6JHXoN5KQY8Um8h/LRhxcyxp8I4Cre3uBgs6IO7fL
         WuSw==
X-Forwarded-Encrypted: i=1; AJvYcCVYUQVvysdotpP87+Z7UNzTT4EsHd+p7nE9sHAl+Wwa42F4xiYky1aG7b6U9AfTuA2pomUgQTTZng==@kvack.org
X-Gm-Message-State: AOJu0YzzJtBhryKdqV4kA4OzswZcYdBYu/bEQ6Vtv/k6wGb2OQtXCT6I
	jp6I0nEOmonzhk9mxaNPP+hzpfZ0NEghJBqVfmBA7Rm/c10g9mzubbGgPz7EwqICYZb4RONp4WK
	dIPsz1y07kFfOjmmzGeySVG6jhHj1Q4VpJbtqcR/F
X-Gm-Gg: ASbGnctqOBS1nL1EvpA4i6sINXlwjkH+MFh6kOwX0Zvi95cG/qBiR8O3BGaYLgogZXz
	kASGOEXDQhDkDAzU/fKvikUkn7OiC0TzYnH0MJwGTXuIQ0IOTPKQp2UWha9i75ddOcxCJWaWsfg
	E6YX2x+XYAYf96d5TA1mvvtM/70ROAx6BwF6ocgypbq4KTFxeriTPb4z3CQw1xTWVtanEsj5M2w
	7qyeet2xVrIRKg4yJuIRutpTtzFtLGg2KihbzHn8+/PoB0sqIzobg6nRg==
X-Google-Smtp-Source: AGHT+IGeI5npxi7Mgjv/AQZyj20ErEgsxJ1WUGm5ufWtxl66DRT2cimFQlPKpRNZt6Q0/CjVOtAFU08N/DTZ4T3ULi4=
X-Received: by 2002:a05:600c:4b94:b0:453:672b:5b64 with SMTP id
 5b1f17b1804b1-45df74aea3amr3235725e9.2.1757625977823; Thu, 11 Sep 2025
 14:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <aMGkAI3zKlVsO0S2@hpe.com> <CACw3F50yTvMphcp111Qzh3PKm+FYoXX9g_sLpV5TPuubqK2+Qw@mail.gmail.com>
 <aMG6SRckMsnQH7ov@hpe.com>
In-Reply-To: <aMG6SRckMsnQH7ov@hpe.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 11 Sep 2025 14:26:05 -0700
X-Gm-Features: AS18NWBC4uuIS2CzvlC033iuGSPukXC1VYLzEEUeHNx8bxP_6fELZH6vPU6FTTw
Message-ID: <CACw3F51TsnT+QK8eYKHRcy==_vLsa+N3Btz_kzpfH=6mkYbHxA@mail.gmail.com>
Subject: Re: [PATCH] mm/memory-failure: Disable soft offline for HugeTLB pages
 by default
To: Kyle Meyer <kyle.meyer@hpe.com>
Cc: akpm@linux-foundation.org, corbet@lwn.net, david@redhat.com, 
	linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com, 
	Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz, 
	jane.chu@oracle.com, joel.granados@kernel.org, laoar.shao@gmail.com, 
	lorenzo.stoakes@oracle.com, mclapinski@google.com, mhocko@suse.com, 
	nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com, 
	rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com, 
	surenb@google.com, vbabka@suse.cz, linux-acpi@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ADD1216000A
X-Stat-Signature: yajzdgetkhmg8jrt9hcyrgegxztimp4r
X-HE-Tag: 1757625979-523968
X-HE-Meta: U2FsdGVkX19JDfAFAS3Qf+eNfUPbULOSWa5tKnbsgtMVjIQM8AbRvlP0B+piz6JQgzODOuZAL/fb23vK9N0IXWjgb0g78cVrkaYaA1mSrAzGYmjVpZygLyJxMHbTZZTLr+uTcczb1x2dmYws3LhCJ6+VMswVJxGeoPZlup2UnFJG9IqslJUOl4wNIwZo5BUu99pWdtKOiVr/OfI/1bBuREWUGvfM5DU+9+L7gOYeXHy8qJJpQlwcGdhl/fO+4aEHiRR+D8e1Db98AO2V1gjrjKKLcev8vn4XmAihve3LnwkHsbmtcVeYrTLSlUyThhjqtWam8w/OzGwKMzaPUJ7x2xpX1jRzHTzLGRkA6edhKfiW5wR9fd+lrUHO92Vnlq6+XWMyzWim22JI7AWpzN6MqjsaA/k8NDUWca9ijl7BNFN3J0YTV03BYZuOVdXjjaiURawQ+Qm2Kl9L8Av3ZCFTv/tlV7oWjUynYks5Uf8pp2rck4iNLB49tX69LYIF6wBzU3/i93USxMNdsh84bAWoD27yqRGgndQ5CFJ/hCL0Z8rm8dybmmwQY/UDtPxvzGMZK+v3H1/TwbmS95HZEndc4XoJ2l4inGDfznGjkYow6a4B85/Bk4W5WeKQ8BqoU4IZO0XVy9W7KYNLDow81CUaA/fI4ACNKd7vW+AwEU3dkesbH04UMErTeDY6v7E/9gRlRRKiwUicKXC22CBdHhtBsidLzinQOQIldd/PLeSmfdQ9YtSf88G/sAF8EoFdV4GBAmAXQKiV/UqAhovyDyy8NUT99V2PbUZs31h9XNDtNCJ0n5KW3bO6Ogjs4UaIoeVba4rDX+LqULBAkpvn4cAZ4+4aSlKYP7t7ac1uXG41lfE5CefTk2RvLSp5D0e/25T1fYfRxKy7FINPU91IvtpPtInfLcZXX6TI2Yul+deHuW7vSsgQCXaTPVMxPi+cszMMbJ7tIXgUA9LbMzwukcU
 X4uTf6AS
 bjdFxsM3aixbrWHvfpiy0wngMcecfJ+t9gSuyGzwzmnjpxc0H5Sp8wsJcwjJLlOu2rjMHeXoFMOFsklKg99I6OYObCo2FjZfv2/Hzsfqg/sA4AeOy6/FbYiuXYYhxsbpwsH4SwymmZhiuMNPXPLAvkiotRp4F1AumrR2iAHajXh9KVcKvjsEAlDih78kgIOluZrwx/F78Vhmv3oWLT1wtjxLn4NSsLGcCMkTsFUJVbpBZvwuiKZCRBQUZSzTKKBW1LgPoB0QX8BczzU8/2NMhQONqIOSeiA9W3hUToG8/pcSDhDOWlxvrZvrCgP9MhUniZ4AqQis/K5U2P1YSmBpBHKrtK+2bpgHiWnhRZkKiLZ1BWzY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 10:50=E2=80=AFAM Kyle Meyer <kyle.meyer@hpe.com> wr=
ote:
>
> On Wed, Sep 10, 2025 at 09:44:24AM -0700, Jiaqi Yan wrote:
> > On Wed, Sep 10, 2025 at 9:16=E2=80=AFAM Kyle Meyer <kyle.meyer@hpe.com>=
 wrote:
> > >
> > > Soft offlining a HugeTLB page reduces the available HugeTLB page pool=
.
> > > Since HugeTLB pages are preallocated, reducing the available HugeTLB
> > > page pool can cause allocation failures.
> > >
> > > /proc/sys/vm/enable_soft_offline provides a sysctl interface to
> > > disable/enable soft offline:
> > >
> > > 0 - Soft offline is disabled.
> > > 1 - Soft offline is enabled.
> > >
> > > The current sysctl interface does not distinguish between HugeTLB pag=
es
> > > and other page types.
> > >
> > > Disable soft offline for HugeTLB pages by default (1) and extend the
> > > sysctl interface to preserve existing behavior (2):
> > >
> > > 0 - Soft offline is disabled.
> > > 1 - Soft offline is enabled (excluding HugeTLB pages).
> > > 2 - Soft offline is enabled (including HugeTLB pages).
> > >
> > > Update documentation for the sysctl interface, reference the sysctl
> > > interface in the sysfs ABI documentation, and update HugeTLB soft
> > > offline selftests.
> > >
> > > Reported-by: Shawn Fan <shawn.fan@intel.com>
> > > Suggested-by: Tony Luck <tony.luck@intel.com>
> > > Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> > > ---
> > >
> > > Tony's original patch disabled soft offline for HugeTLB pages when
> > > a correctable memory error reported via GHES (with "error threshold
> > > exceeded" set) happened to be on a HugeTLB page:
> > >
> > > https://lore.kernel.org/all/20250904155720.22149-1-tony.luck@intel.co=
m
> > >
> > > This patch disables soft offline for HugeTLB pages by default
> > > (not just from GHES).
> > >
> > > ---
> > >  .../ABI/testing/sysfs-memory-page-offline     |  6 ++++
> > >  Documentation/admin-guide/sysctl/vm.rst       | 18 ++++++++---
> > >  mm/memory-failure.c                           | 21 ++++++++++--
> > >  .../selftests/mm/hugetlb-soft-offline.c       | 32 +++++++++++++----=
--
> > >  4 files changed, 60 insertions(+), 17 deletions(-)
> > >
> > > diff --git a/Documentation/ABI/testing/sysfs-memory-page-offline b/Do=
cumentation/ABI/testing/sysfs-memory-page-offline
> > > index 00f4e35f916f..befb89ae39ec 100644
> > > --- a/Documentation/ABI/testing/sysfs-memory-page-offline
> > > +++ b/Documentation/ABI/testing/sysfs-memory-page-offline
> > > @@ -20,6 +20,12 @@ Description:
> > >                 number, or a error when the offlining failed.  Readin=
g
> > >                 the file is not allowed.
> > >
> > > +               Soft-offline can be disabled/enabled via sysctl:
> > > +               /proc/sys/vm/enable_soft_offline
> > > +
> > > +               For details, see:
> > > +               Documentation/admin-guide/sysctl/vm.rst
> > > +
> > >  What:          /sys/devices/system/memory/hard_offline_page
> > >  Date:          Sep 2009
> > >  KernelVersion: 2.6.33
> > > diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/=
admin-guide/sysctl/vm.rst
> > > index 4d71211fdad8..ae56372bd604 100644
> > > --- a/Documentation/admin-guide/sysctl/vm.rst
> > > +++ b/Documentation/admin-guide/sysctl/vm.rst
> > > @@ -309,19 +309,29 @@ physical memory) vs performance / capacity impl=
ications in transparent and
> > >  HugeTLB cases.
> > >
> > >  For all architectures, enable_soft_offline controls whether to soft =
offline
> > > -memory pages.  When set to 1, kernel attempts to soft offline the pa=
ges
> > > -whenever it thinks needed.  When set to 0, kernel returns EOPNOTSUPP=
 to
> > > -the request to soft offline the pages.  Its default value is 1.
> > > +memory pages:
> > > +
> > > +- 0: Soft offline is disabled.
> > > +- 1: Soft offline is enabled (excluding HugeTLB pages).
> > > +- 2: Soft offline is enabled (including HugeTLB pages).
> >
> > Would it be better to keep/inherit the previous documented behavior "1
> > - Soft offline is enabled (no matter what type of the page is)"? Thus
> > it will have no impact to users that are very nervous about corrected
> > memory errors and willing to lose hugetlb page. Something like:
> >
> >   enum soft_offline {
> >       SOFT_OFFLINE_DISABLED =3D 0,
> >       SOFT_OFFLINE_ENABLED,
> >       SOFT_OFFLINE_ENABLED_SKIP_HUGETLB,
> >       // SOFT_OFFLINE_ENABLED_SKIP_XXX...
> >   };
>
> I don't have a strong opinion on the default because there's a sysctl
> interface, but that seems reasonable. I'll wait for more feedback before
> putting together a v2.

Yeah, no strong opinion from me either, as long as
SOFT_OFFLINE_DISABLED is still 0 (used by our fleet).

In case you don't need to send out v2:

Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>

>
> > > +
> > > +The default is 1.
> > > +
> > > +If soft offline is disabled for the requested page type, EOPNOTSUPP =
is returned.
> > >
> > >  It is worth mentioning that after setting enable_soft_offline to 0, =
the
> > >  following requests to soft offline pages will not be performed:
> > >
> > > +- Request to soft offline from sysfs (soft_offline_page).
> > > +
> > >  - Request to soft offline pages from RAS Correctable Errors Collecto=
r.
> > >
> > > -- On ARM, the request to soft offline pages from GHES driver.
> > > +- On ARM and X86, the request to soft offline pages from GHES driver=
.
> > >
> > >  - On PARISC, the request to soft offline pages from Page Deallocatio=
n Table.
> > >
> > > +Note: Soft offlining a HugeTLB page reduces the HugeTLB page pool.
> > > +
> > >  extfrag_threshold
> > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > > index fc30ca4804bf..cb59a99b48c5 100644
> > > --- a/mm/memory-failure.c
> > > +++ b/mm/memory-failure.c
> > > @@ -64,11 +64,18 @@
> > >  #include "internal.h"
> > >  #include "ras/ras_event.h"
> > >
> > > +enum soft_offline {
> > > +       SOFT_OFFLINE_DISABLED =3D 0,
> > > +       SOFT_OFFLINE_ENABLED_SKIP_HUGETLB,
> > > +       SOFT_OFFLINE_ENABLED
> > > +};
> > > +
> > >  static int sysctl_memory_failure_early_kill __read_mostly;
> > >
> > >  static int sysctl_memory_failure_recovery __read_mostly =3D 1;
> > >
> > > -static int sysctl_enable_soft_offline __read_mostly =3D 1;
> > > +static int sysctl_enable_soft_offline __read_mostly =3D
> > > +       SOFT_OFFLINE_ENABLED_SKIP_HUGETLB;
> > >
> > >  atomic_long_t num_poisoned_pages __read_mostly =3D ATOMIC_LONG_INIT(=
0);
> > >
> > > @@ -150,7 +157,7 @@ static const struct ctl_table memory_failure_tabl=
e[] =3D {
> > >                 .mode           =3D 0644,
> > >                 .proc_handler   =3D proc_dointvec_minmax,
> > >                 .extra1         =3D SYSCTL_ZERO,
> > > -               .extra2         =3D SYSCTL_ONE,
> > > +               .extra2         =3D SYSCTL_TWO,
> > >         }
> > >  };
> > >
> > > @@ -2799,12 +2806,20 @@ int soft_offline_page(unsigned long pfn, int =
flags)
> > >                 return -EIO;
> > >         }
> > >
> > > -       if (!sysctl_enable_soft_offline) {
> > > +       if (sysctl_enable_soft_offline =3D=3D SOFT_OFFLINE_DISABLED) =
{
> > >                 pr_info_once("disabled by /proc/sys/vm/enable_soft_of=
fline\n");
> > >                 put_ref_page(pfn, flags);
> > >                 return -EOPNOTSUPP;
> > >         }
> > >
> > > +       if (sysctl_enable_soft_offline =3D=3D SOFT_OFFLINE_ENABLED_SK=
IP_HUGETLB) {
> > > +               if (folio_test_hugetlb(pfn_folio(pfn))) {
> > > +                       pr_info_once("disabled for HugeTLB pages by /=
proc/sys/vm/enable_soft_offline\n");
> > > +                       put_ref_page(pfn, flags);
> > > +                       return -EOPNOTSUPP;
> > > +               }
> > > +       }
> > > +
> > >         mutex_lock(&mf_mutex);
> > >
> > >         if (PageHWPoison(page)) {
> > > diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tool=
s/testing/selftests/mm/hugetlb-soft-offline.c
> > > index f086f0e04756..7e2873cd0a6d 100644
> > > --- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
> > > +++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> > > @@ -1,10 +1,15 @@
> > >  // SPDX-License-Identifier: GPL-2.0
> > >  /*
> > >   * Test soft offline behavior for HugeTLB pages:
> > > - * - if enable_soft_offline =3D 0, hugepages should stay intact and =
soft
> > > - *   offlining failed with EOPNOTSUPP.
> > > - * - if enable_soft_offline =3D 1, a hugepage should be dissolved an=
d
> > > - *   nr_hugepages/free_hugepages should be reduced by 1.
> > > + *
> > > + * - if enable_soft_offline =3D 0 (SOFT_OFFLINE_DISABLED), HugeTLB p=
ages
> > > + *   should stay intact and soft offlining failed with EOPNOTSUPP.
> > > + *
> > > + * - if enable_soft_offline =3D 1 (SOFT_OFFLINE_ENABLED_SKIP_HUGETLB=
), HugeTLB pages
> > > + *   should stay intact and soft offlining failed with EOPNOTSUPP.
> > > + *
> > > + * - if enable_soft_offline =3D 2 (SOFT_OFFLINE_ENABLED), a HugeTLB =
page should be
> > > + *   dissolved and nr_hugepages/free_hugepages should be reduced by =
1.
> > >   *
> > >   * Before running, make sure more than 2 hugepages of default_hugepa=
gesz
> > >   * are allocated. For example, if /proc/meminfo/Hugepagesize is 2048=
kB:
> > > @@ -32,6 +37,12 @@
> > >
> > >  #define EPREFIX " !!! "
> > >
> > > +enum soft_offline {
> > > +       SOFT_OFFLINE_DISABLED =3D 0,
> > > +       SOFT_OFFLINE_ENABLED_SKIP_HUGETLB,
> > > +       SOFT_OFFLINE_ENABLED
> > > +};
> > > +
> > >  static int do_soft_offline(int fd, size_t len, int expect_errno)
> > >  {
> > >         char *filemap =3D NULL;
> > > @@ -83,7 +94,7 @@ static int set_enable_soft_offline(int value)
> > >         char cmd[256] =3D {0};
> > >         FILE *cmdfile =3D NULL;
> > >
> > > -       if (value !=3D 0 && value !=3D 1)
> > > +       if (value < SOFT_OFFLINE_DISABLED || value > SOFT_OFFLINE_ENA=
BLED)
> > >                 return -EINVAL;
> > >
> > >         sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", va=
lue);
> > > @@ -155,7 +166,7 @@ static int create_hugetlbfs_file(struct statfs *f=
ile_stat)
> > >  static void test_soft_offline_common(int enable_soft_offline)
> > >  {
> > >         int fd;
> > > -       int expect_errno =3D enable_soft_offline ? 0 : EOPNOTSUPP;
> > > +       int expect_errno =3D (enable_soft_offline =3D=3D SOFT_OFFLINE=
_ENABLED) ? 0 : EOPNOTSUPP;
> > >         struct statfs file_stat;
> > >         unsigned long hugepagesize_kb =3D 0;
> > >         unsigned long nr_hugepages_before =3D 0;
> > > @@ -198,7 +209,7 @@ static void test_soft_offline_common(int enable_s=
oft_offline)
> > >         // No need for the hugetlbfs file from now on.
> > >         close(fd);
> > >
> > > -       if (enable_soft_offline) {
> > > +       if (enable_soft_offline =3D=3D SOFT_OFFLINE_ENABLED) {
> > >                 if (nr_hugepages_before !=3D nr_hugepages_after + 1) =
{
> > >                         ksft_test_result_fail("MADV_SOFT_OFFLINE shou=
ld reduced 1 hugepage\n");
> > >                         return;
> > > @@ -219,10 +230,11 @@ static void test_soft_offline_common(int enable=
_soft_offline)
> > >  int main(int argc, char **argv)
> > >  {
> > >         ksft_print_header();
> > > -       ksft_set_plan(2);
> > > +       ksft_set_plan(3);
> > >
> > > -       test_soft_offline_common(1);
> > > -       test_soft_offline_common(0);
> > > +       test_soft_offline_common(SOFT_OFFLINE_ENABLED);
> > > +       test_soft_offline_common(SOFT_OFFLINE_ENABLED_SKIP_HUGETLB);
> > > +       test_soft_offline_common(SOFT_OFFLINE_DISABLED);
> >
> > Thanks for updating the test code! Looks good to me.
> >
> > >
> > >         ksft_finished();
> > >  }
> > > --
> > > 2.51.0
> > >

