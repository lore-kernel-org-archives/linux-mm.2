Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1840CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F394A8E0013; Wed, 10 Sep 2025 12:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEA948E0002; Wed, 10 Sep 2025 12:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB18F8E0013; Wed, 10 Sep 2025 12:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C566A8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:44:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8AA4C5611B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:44:40 +0000 (UTC)
X-FDA: 83873914320.27.7044E39
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83934C0017
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:44:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PC+p4pKS;
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757522678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8djFOJ+gM1iYSlPzwE6pCiywCzk1B+3Ytmse7uaXQ0=;
	b=dYgXaueI5nM4fKfw+O78V5gk7ULMWDO1K9G9cMlQoQpBiEwVzx9QRbkKm3Js+m5bu+9tOa
	zmepTq5JtA5aenjwq5kMSQUmS3SwQa59OWWwQl7IF99YvO1xXKqxAHq28SP1A7BJknDdbn
	H0plfJz/A8XFCAxuBgpSta100PiJsHU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PC+p4pKS;
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757522678; a=rsa-sha256;
	cv=none;
	b=v3KbRldq2NCw6tS/QJkShZhEM2GaO8lW2ldTSAu9TFLxxnYbU+aUQaSAn+m6HjIfSeGxVY
	GAMj/USPB2lxhCGdUblzJrMVAY+X59tUww9hDd9b/FzLDxvvOyWty4BPqaNeVdTktctKYE
	nwJFvqbZT5PWKYv7xljuhFxp1ShcTMc=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45de54bfc36so1465e9.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757522677; x=1758127477; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8djFOJ+gM1iYSlPzwE6pCiywCzk1B+3Ytmse7uaXQ0=;
        b=PC+p4pKS43kr195soJBVjT+7BLi4/F6njakRp1BVxugMYrRg87gxZSJJTwS0DOd/LA
         LDTdU7AzTaBYjXUZROurMnbA5mJ+gWptA2H4lZdzXlKP4gmCow4ILYFt67w3yUw/F849
         HfKRAg1Nzwt7NmW49sLZ/EBqz1Wq5t2PqIwFfytmeH9Og/Nrrlmh4PhWOuoT9Vg221Lb
         RU0A9KVMG1a0+NLKxbQ2zUsCiVhaNAiDi+0tLBTfsfu50XfUHQvij37UvNjo+31JAlbf
         wY5nrUrX03drfQ1Pd0DHXdnd6HCYVqadFC68N4i1N+9xewwzSKUGK+YHoszsflVUxaYX
         ZP8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757522677; x=1758127477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N8djFOJ+gM1iYSlPzwE6pCiywCzk1B+3Ytmse7uaXQ0=;
        b=ggZM9lGimcvIUNWEM4kcCtMvXFOMsMMLi1dSIOiWzqL2mj2+ipltdcb+sQXLyP1oHq
         CRA67UllPNv9Ol3jtfMPDwuMHce7kpdPtzuopokWvIpXZSzMGkpvkD2L4nopn2UFuXVD
         4OtwWatJMZOP0nodSLAkZZmKhzKG1NtBjd+QPvDHBQ9BOORVBK6Cg9t086cI18TAmPYV
         tTQ1JbvYRLZOshaJNvvCAkj45mplbCegYb2ElA3uF2GKfUf82wN97GTuvghX9oI3+MUe
         JJFWDT0jUVFiQGngrQA4Fje6CU6D09Geyyu7cepeKDQQHxd6wi6+9SJVCMV02Gv4FmYd
         3YBA==
X-Forwarded-Encrypted: i=1; AJvYcCUPr3QM55AIDJaWQKDu5crq9bjGH0n2cSWCfvdzNxtouf/xxRv72gQcb+QVTI7IUD4/LusrArs/KQ==@kvack.org
X-Gm-Message-State: AOJu0YzWAvu79PXrJV+IpTph8bJLnoXK0FCRw3N/XW3j6BCr7e8H0dX0
	NBzXw0kc7irIugvMU/hc7UggaqoQjsrBMgS5BQIwQV56d3dTs+IDMCbyigvvf4VzouiVuq5pAbM
	ihL/tcgc++pYMiWCoIc9rNXkRp0JDtwwbK3FSGOhW
X-Gm-Gg: ASbGncuaFbWW64hgLLplrXWG65gbtQ8ZpP6+Jq1xipsEtOwRQL/+/c4KqdWimfItAT9
	myuby7YyTpZD02znvuOabzUQjqxUIvFDZT86LNkCjBUiLxzxtoQoCdVTuKRD2aeK3qK4s4zMwcy
	EGp9Eu5cKeUTeYMiT+unPnhNBuw8YctClqmH8tCGcSEgn5UE+rl0KaswiO4RZTWLZFA1anaMT5h
	yoBeQhuF47E5vkHuBZ0/CTHKcvuxzL6KnOUtayYM9Ca
X-Google-Smtp-Source: AGHT+IHCdi9zmwz6KoicCAR0Jv0+Vt/UGzR3h0GAFmH0mG+ENE/AB5F6T/JRMRgwDoGFU9ca4fFaXajfQ9zfPfYcnhA=
X-Received: by 2002:a05:600c:4ba8:b0:45b:74f7:9d30 with SMTP id
 5b1f17b1804b1-45df81fc22amr1324515e9.1.1757522676452; Wed, 10 Sep 2025
 09:44:36 -0700 (PDT)
MIME-Version: 1.0
References: <aMGkAI3zKlVsO0S2@hpe.com>
In-Reply-To: <aMGkAI3zKlVsO0S2@hpe.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 10 Sep 2025 09:44:24 -0700
X-Gm-Features: AS18NWDIq2crh-gg2BM8GO2RnYKbsPnCvYRMI6YaiHazGhs_SQQK_MbAUFz62O0
Message-ID: <CACw3F50yTvMphcp111Qzh3PKm+FYoXX9g_sLpV5TPuubqK2+Qw@mail.gmail.com>
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
X-Stat-Signature: ehu4i76hxb4iui6jpik6wqiu3sij185f
X-Rspam-User: 
X-Rspamd-Queue-Id: 83934C0017
X-Rspamd-Server: rspam04
X-HE-Tag: 1757522678-670059
X-HE-Meta: U2FsdGVkX1/vaZfTyFZN1oJhizfHFLMGkVDDSr1VWuzCUoo9s+8XfRqs15CgN/tAbBCTKOLmWh3N0wl2zH4YBJtmcpKvsEW2LkEGLKH+JMcJ9/HFkJqkr5rP9Vc/szq0lk8AP7oRLEoHZlsvrBK1suzjRsGUq4GR79xlwshbY6rjw09/lwSO9lILbPHXrjV7INBr21eMvltyA+fDdH0uq3KLcN92UFS+dzpLSN5lPCP/2Jm8uDcsNwWdz0Vu69S4Ok+MZdi3a4mNIIRIGKyuuoTet6AxnG282rihrWQgdrSWLeCY8FJE3GnPdWJ5xoFr9ZT7XDaB2A6k+fecsPE+9SSWMvSnk2CdG/fX3xfEmaohERQ1VOH1MkBubMgcbQOvlpd1TAiT3HPRADG16/FQuMM29dZkJlqGZNbO+8QDZjXp1maBRFQKWCYaxEWFUpfKr7lqXLrhKNQ+6cr2HoMyspXjPnx5Gpk6Bsy6EhCdnKgftigD5n7w3cx8r21Zl1toHidOO+9ypLq1LkY6+QnCOwXki1oFNwCialg1XsoktkNUiPa3u+t2liAC8QoTtE1xZE7NhUhbkx6qlWH2yAp1cd/rxbc4kU2DrZJuFLswqf3GKfcLhXZ6xjIEryqOdtrdmt25OsU6t1q2wJM7251hsC30Cb1SnlLDSpu16PFX3VmjExXkss8f2IVlpMd/IaKCy7FFPGiFg/kPyrgbvCsmNTJKBdPspPahyhyUCUJvrWMiwzZY15lSIjvrMfnQ3WuNMmam6YPexot95rbolFQgmD8sqNJcK8R27pp5gn9WSA6bPnND987K61nbEdLO5rV9WrQn5hV43UlkGCmWqIejcLtLyo7cxrZBzQ1x2FCpayAONI5GG/ra7zLR1U/rJDDttkPezl/BEJtiHN6t9jEgih0fTXtGvLSDMYn2H6ZJqGlnEgfwD5gyjDXHOjhEdLLPdObXWeC6od2MyCxCEsq
 P9sFkywZ
 toN5s/rXENB46RI0xoqBU+orVvRvEehzcM3Zl9fivVag3lgklvGrhfSe+Cu2HLh1QPJ32H3XOX7jckKHOsqaRkqCcT8wLVyERnSr3bx4nA3IRng2eix9Q8IDZfRVdJz4dlHGCNnyMRKpDBg9Kv0xJ53pGGe+IXkhZN3U1g7tDAXA/cGcnfTbzUo04kstha1++yAczxS7AVSKmQrIR2BXxGOEm0g8K1OJMn47Q8B4wLbv15Qf2HgmmnsUUF2+hhKr8Mo/EtvA3EvBN1OErGSfhJddX8C1z+lZTCeUm0hh9auVJ1rbcQZcb1CQtjH1jyXRjPPICtafHCZ1UjXOYZRjqurErZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 9:16=E2=80=AFAM Kyle Meyer <kyle.meyer@hpe.com> wro=
te:
>
> Soft offlining a HugeTLB page reduces the available HugeTLB page pool.
> Since HugeTLB pages are preallocated, reducing the available HugeTLB
> page pool can cause allocation failures.
>
> /proc/sys/vm/enable_soft_offline provides a sysctl interface to
> disable/enable soft offline:
>
> 0 - Soft offline is disabled.
> 1 - Soft offline is enabled.
>
> The current sysctl interface does not distinguish between HugeTLB pages
> and other page types.
>
> Disable soft offline for HugeTLB pages by default (1) and extend the
> sysctl interface to preserve existing behavior (2):
>
> 0 - Soft offline is disabled.
> 1 - Soft offline is enabled (excluding HugeTLB pages).
> 2 - Soft offline is enabled (including HugeTLB pages).
>
> Update documentation for the sysctl interface, reference the sysctl
> interface in the sysfs ABI documentation, and update HugeTLB soft
> offline selftests.
>
> Reported-by: Shawn Fan <shawn.fan@intel.com>
> Suggested-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> ---
>
> Tony's original patch disabled soft offline for HugeTLB pages when
> a correctable memory error reported via GHES (with "error threshold
> exceeded" set) happened to be on a HugeTLB page:
>
> https://lore.kernel.org/all/20250904155720.22149-1-tony.luck@intel.com
>
> This patch disables soft offline for HugeTLB pages by default
> (not just from GHES).
>
> ---
>  .../ABI/testing/sysfs-memory-page-offline     |  6 ++++
>  Documentation/admin-guide/sysctl/vm.rst       | 18 ++++++++---
>  mm/memory-failure.c                           | 21 ++++++++++--
>  .../selftests/mm/hugetlb-soft-offline.c       | 32 +++++++++++++------
>  4 files changed, 60 insertions(+), 17 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-memory-page-offline b/Docume=
ntation/ABI/testing/sysfs-memory-page-offline
> index 00f4e35f916f..befb89ae39ec 100644
> --- a/Documentation/ABI/testing/sysfs-memory-page-offline
> +++ b/Documentation/ABI/testing/sysfs-memory-page-offline
> @@ -20,6 +20,12 @@ Description:
>                 number, or a error when the offlining failed.  Reading
>                 the file is not allowed.
>
> +               Soft-offline can be disabled/enabled via sysctl:
> +               /proc/sys/vm/enable_soft_offline
> +
> +               For details, see:
> +               Documentation/admin-guide/sysctl/vm.rst
> +
>  What:          /sys/devices/system/memory/hard_offline_page
>  Date:          Sep 2009
>  KernelVersion: 2.6.33
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admi=
n-guide/sysctl/vm.rst
> index 4d71211fdad8..ae56372bd604 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -309,19 +309,29 @@ physical memory) vs performance / capacity implicat=
ions in transparent and
>  HugeTLB cases.
>
>  For all architectures, enable_soft_offline controls whether to soft offl=
ine
> -memory pages.  When set to 1, kernel attempts to soft offline the pages
> -whenever it thinks needed.  When set to 0, kernel returns EOPNOTSUPP to
> -the request to soft offline the pages.  Its default value is 1.
> +memory pages:
> +
> +- 0: Soft offline is disabled.
> +- 1: Soft offline is enabled (excluding HugeTLB pages).
> +- 2: Soft offline is enabled (including HugeTLB pages).

Would it be better to keep/inherit the previous documented behavior "1
- Soft offline is enabled (no matter what type of the page is)"? Thus
it will have no impact to users that are very nervous about corrected
memory errors and willing to lose hugetlb page. Something like:

  enum soft_offline {
      SOFT_OFFLINE_DISABLED =3D 0,
      SOFT_OFFLINE_ENABLED,
      SOFT_OFFLINE_ENABLED_SKIP_HUGETLB,
      // SOFT_OFFLINE_ENABLED_SKIP_XXX...
  };

> +
> +The default is 1.
> +
> +If soft offline is disabled for the requested page type, EOPNOTSUPP is r=
eturned.
>
>  It is worth mentioning that after setting enable_soft_offline to 0, the
>  following requests to soft offline pages will not be performed:
>
> +- Request to soft offline from sysfs (soft_offline_page).
> +
>  - Request to soft offline pages from RAS Correctable Errors Collector.
>
> -- On ARM, the request to soft offline pages from GHES driver.
> +- On ARM and X86, the request to soft offline pages from GHES driver.
>
>  - On PARISC, the request to soft offline pages from Page Deallocation Ta=
ble.
>
> +Note: Soft offlining a HugeTLB page reduces the HugeTLB page pool.
> +
>  extfrag_threshold
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fc30ca4804bf..cb59a99b48c5 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -64,11 +64,18 @@
>  #include "internal.h"
>  #include "ras/ras_event.h"
>
> +enum soft_offline {
> +       SOFT_OFFLINE_DISABLED =3D 0,
> +       SOFT_OFFLINE_ENABLED_SKIP_HUGETLB,
> +       SOFT_OFFLINE_ENABLED
> +};
> +
>  static int sysctl_memory_failure_early_kill __read_mostly;
>
>  static int sysctl_memory_failure_recovery __read_mostly =3D 1;
>
> -static int sysctl_enable_soft_offline __read_mostly =3D 1;
> +static int sysctl_enable_soft_offline __read_mostly =3D
> +       SOFT_OFFLINE_ENABLED_SKIP_HUGETLB;
>
>  atomic_long_t num_poisoned_pages __read_mostly =3D ATOMIC_LONG_INIT(0);
>
> @@ -150,7 +157,7 @@ static const struct ctl_table memory_failure_table[] =
=3D {
>                 .mode           =3D 0644,
>                 .proc_handler   =3D proc_dointvec_minmax,
>                 .extra1         =3D SYSCTL_ZERO,
> -               .extra2         =3D SYSCTL_ONE,
> +               .extra2         =3D SYSCTL_TWO,
>         }
>  };
>
> @@ -2799,12 +2806,20 @@ int soft_offline_page(unsigned long pfn, int flag=
s)
>                 return -EIO;
>         }
>
> -       if (!sysctl_enable_soft_offline) {
> +       if (sysctl_enable_soft_offline =3D=3D SOFT_OFFLINE_DISABLED) {
>                 pr_info_once("disabled by /proc/sys/vm/enable_soft_offlin=
e\n");
>                 put_ref_page(pfn, flags);
>                 return -EOPNOTSUPP;
>         }
>
> +       if (sysctl_enable_soft_offline =3D=3D SOFT_OFFLINE_ENABLED_SKIP_H=
UGETLB) {
> +               if (folio_test_hugetlb(pfn_folio(pfn))) {
> +                       pr_info_once("disabled for HugeTLB pages by /proc=
/sys/vm/enable_soft_offline\n");
> +                       put_ref_page(pfn, flags);
> +                       return -EOPNOTSUPP;
> +               }
> +       }
> +
>         mutex_lock(&mf_mutex);
>
>         if (PageHWPoison(page)) {
> diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/te=
sting/selftests/mm/hugetlb-soft-offline.c
> index f086f0e04756..7e2873cd0a6d 100644
> --- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
> +++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> @@ -1,10 +1,15 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
>   * Test soft offline behavior for HugeTLB pages:
> - * - if enable_soft_offline =3D 0, hugepages should stay intact and soft
> - *   offlining failed with EOPNOTSUPP.
> - * - if enable_soft_offline =3D 1, a hugepage should be dissolved and
> - *   nr_hugepages/free_hugepages should be reduced by 1.
> + *
> + * - if enable_soft_offline =3D 0 (SOFT_OFFLINE_DISABLED), HugeTLB pages
> + *   should stay intact and soft offlining failed with EOPNOTSUPP.
> + *
> + * - if enable_soft_offline =3D 1 (SOFT_OFFLINE_ENABLED_SKIP_HUGETLB), H=
ugeTLB pages
> + *   should stay intact and soft offlining failed with EOPNOTSUPP.
> + *
> + * - if enable_soft_offline =3D 2 (SOFT_OFFLINE_ENABLED), a HugeTLB page=
 should be
> + *   dissolved and nr_hugepages/free_hugepages should be reduced by 1.
>   *
>   * Before running, make sure more than 2 hugepages of default_hugepagesz
>   * are allocated. For example, if /proc/meminfo/Hugepagesize is 2048kB:
> @@ -32,6 +37,12 @@
>
>  #define EPREFIX " !!! "
>
> +enum soft_offline {
> +       SOFT_OFFLINE_DISABLED =3D 0,
> +       SOFT_OFFLINE_ENABLED_SKIP_HUGETLB,
> +       SOFT_OFFLINE_ENABLED
> +};
> +
>  static int do_soft_offline(int fd, size_t len, int expect_errno)
>  {
>         char *filemap =3D NULL;
> @@ -83,7 +94,7 @@ static int set_enable_soft_offline(int value)
>         char cmd[256] =3D {0};
>         FILE *cmdfile =3D NULL;
>
> -       if (value !=3D 0 && value !=3D 1)
> +       if (value < SOFT_OFFLINE_DISABLED || value > SOFT_OFFLINE_ENABLED=
)
>                 return -EINVAL;
>
>         sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value)=
;
> @@ -155,7 +166,7 @@ static int create_hugetlbfs_file(struct statfs *file_=
stat)
>  static void test_soft_offline_common(int enable_soft_offline)
>  {
>         int fd;
> -       int expect_errno =3D enable_soft_offline ? 0 : EOPNOTSUPP;
> +       int expect_errno =3D (enable_soft_offline =3D=3D SOFT_OFFLINE_ENA=
BLED) ? 0 : EOPNOTSUPP;
>         struct statfs file_stat;
>         unsigned long hugepagesize_kb =3D 0;
>         unsigned long nr_hugepages_before =3D 0;
> @@ -198,7 +209,7 @@ static void test_soft_offline_common(int enable_soft_=
offline)
>         // No need for the hugetlbfs file from now on.
>         close(fd);
>
> -       if (enable_soft_offline) {
> +       if (enable_soft_offline =3D=3D SOFT_OFFLINE_ENABLED) {
>                 if (nr_hugepages_before !=3D nr_hugepages_after + 1) {
>                         ksft_test_result_fail("MADV_SOFT_OFFLINE should r=
educed 1 hugepage\n");
>                         return;
> @@ -219,10 +230,11 @@ static void test_soft_offline_common(int enable_sof=
t_offline)
>  int main(int argc, char **argv)
>  {
>         ksft_print_header();
> -       ksft_set_plan(2);
> +       ksft_set_plan(3);
>
> -       test_soft_offline_common(1);
> -       test_soft_offline_common(0);
> +       test_soft_offline_common(SOFT_OFFLINE_ENABLED);
> +       test_soft_offline_common(SOFT_OFFLINE_ENABLED_SKIP_HUGETLB);
> +       test_soft_offline_common(SOFT_OFFLINE_DISABLED);

Thanks for updating the test code! Looks good to me.

>
>         ksft_finished();
>  }
> --
> 2.51.0
>

