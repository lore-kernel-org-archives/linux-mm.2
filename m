Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39BC3CAC583
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9577A8E0016; Wed, 10 Sep 2025 08:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F1F8E000B; Wed, 10 Sep 2025 08:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 870FB8E0016; Wed, 10 Sep 2025 08:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 769EE8E000B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFB308705C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:01:38 +0000 (UTC)
X-FDA: 83873201076.21.932BA52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BCB2520013
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:01:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rsmyMrH6;
	spf=pass (imf03.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757505697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFcWM1G06/h31MkBDlmPaUf8cMuKOuxdNuw7ZObi1F8=;
	b=ngv3HHqFoOP/sk7t0Xjkd2eTVm9zHIpiN8kLoepjC4J8RIolCO3pc76PXRtUwdofOkAvvH
	gNEGyoc7JWx+IxW4gDzSIpFmHyOxXdmeQT0TGz8MNQWKPP5qwtYMZ0Y4+x1jRtRZ/uo4ca
	qDhh6Od/ugrnEMM+WCuL6m+bklFjBe8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757505697; a=rsa-sha256;
	cv=none;
	b=HYpYPv1RAiX4/oF77htp4U3GZwCY3/wJA97Awk8BHQu0XA7F8T6dx/D968On7CJTC5CKKa
	MgbTRwc6M4HZf/Q0PmcYdJi3JBZvBIIJIqy62S8IyRvFo7mhItueHaRDercTuMq3hNSPp6
	Cc1k18MQjStEiivdJBghuROC6VUu3Oo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rsmyMrH6;
	spf=pass (imf03.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C82340165
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C765C4CEFB
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757505695;
	bh=q7q78drzXiKAUcp4TX10uJS3Ui+QbaBZIzkWxDYUaSI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rsmyMrH6HMsR3JewGm2maVZVPb7UrKYMVyPburjtPwPWnt13R6T8Xv4mLQnCqX6EY
	 ZF33DNJAc49I8teHKRg80FMJjjUvMLY9A8P2d5MDdtkndS2nsactb7L3gttV/GVYZs
	 6XO/D+Iz4AU+BzLId0+bzNeprX44AIt41/HkJIjcRgtqor9XnzmD7yAluJEiesbwTr
	 Uk3YwdMIHdeH3CFNXOhn+F61i0Y2M/7DKuO92q9YJSuhmNKv0lRi6cFH7LpflueyqP
	 4JxHE79gP7D4wPdqKw93z0MFex5ZAXcPwpAaXOlAHLz5aSLqXq6O52HFQExGzXRW14
	 niO8ITnUp6ZCA==
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-746da717f35so2863219a34.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:01:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWXEHpZR2gCobcgkG0Wn2TBwMdetrBN60Zi25hfHba3MiVmpGSwX+B/R5X7oj3ECYWgy+Ao5Rvlrg==@kvack.org
X-Gm-Message-State: AOJu0YxLYARN0GPMv57Jp/fD8oYAQABYDyhz7AMmh4zW+rFuaPE/EAiX
	clQNNnoNuEo1OwOxufdHX5YwC1JhON23YG4IeNfEyEu8scTIU542o1g3Oa7KOUgLL1Cey5rVvFz
	ybPOg9a6W8S0rCSMzj1oihRV44ibxaiw=
X-Google-Smtp-Source: AGHT+IFrO/ARxn2+pn+H/jgdGSskG+5HqHzwzQA7Fcamf///NbmjsRp1nadipREjIcejf7Yv7LCCEAJMMm+0x5m/zs4=
X-Received: by 2002:a05:6830:370a:b0:73e:7f48:e6bc with SMTP id
 46e09a7af769-74c6f023596mr7471623a34.2.1757505694328; Wed, 10 Sep 2025
 05:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250904155720.22149-1-tony.luck@intel.com> <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
 <aLsHh70jI6BGHjaN@agluck-desk3> <bwu744g3qzbzylxvfgt7v4tnf2k2eosqbkg7alm6u5roa7j3bn@gmut2l5227kw>
 <aLspJ5Tpqp4qRDk2@agluck-desk3> <cf05bc8e-fc79-49e4-a90a-47e661b4ae69@oracle.com>
 <CACw3F538k+dshTs1_rxbpYoRdFyX3tLYzfaWj-_d7Lq5Dd2Jsg@mail.gmail.com>
 <aL8rIgSImDh7Nj7E@hpe.com> <aL82BsIJht3HIIS3@agluck-desk3>
In-Reply-To: <aL82BsIJht3HIIS3@agluck-desk3>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 10 Sep 2025 14:01:23 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0hihNmnnB2x9q2JobGQJirmj0Q5oHFmKfOsqesjGvD4-A@mail.gmail.com>
X-Gm-Features: Ac12FXzERbz1mwe0hhW3ABLRaK1GOuCwiKZgFxzAjarjVxa6UFAJjjTQrUg5u8o
Message-ID: <CAJZ5v0hihNmnnB2x9q2JobGQJirmj0Q5oHFmKfOsqesjGvD4-A@mail.gmail.com>
Subject: Re: PATCH v3 ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Kyle Meyer <kyle.meyer@hpe.com>, Jiaqi Yan <jiaqiyan@google.com>, jane.chu@oracle.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, surenb@google.com, 
	"Anderson, Russ" <russ.anderson@hpe.com>, rppt@kernel.org, osalvador@suse.de, 
	nao.horiguchi@gmail.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, 
	linmiaohe@huawei.com, david@redhat.com, bp@alien8.de, 
	akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz, 
	linux-acpi@vger.kernel.org, Shawn Fan <shawn.fan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BCB2520013
X-Stat-Signature: 3ic7kkoar6ffn3f4hsod8udxoswingwr
X-Rspam-User: 
X-HE-Tag: 1757505696-17995
X-HE-Meta: U2FsdGVkX1854iB7t5m5jLSnL0oLK9hNJUSOtoZGUtnqFQG8IOm2r1+CgCxSF4V34dJWbSKxdko3ry4Zf5ZkBVKyBnCgyqMhwxiagPwVVyxQ4WqRmepMcyxGUZpdY79lSQPPhSi5pHCgwwysHiR1srW9/PbE+gQlBSyfUYZka7sx07rn0Ji43SQWZCJSzc4yjdrQ2o1bkt+Vo0H9QDeR4OAGdn1kABS1q5hzNKsNOQxCeXHpSyf5aGcN/8awlYV102jvVRYfDdI4tnbSIbuHNHLupBEv5+xL/n4fs2pmATwxYsNIuiT/52FudbxLoq0zFQPOjuYJzcOkHdpmZOCGLfV2Uuotd3i8BhbuHUI6IMKm9wmLL2Z1EXSS9PS2m4iHbJQ2eYbYAZRKTw4FKJACUb6yi3n1B7LjGr+BtOyZG6efqo/wEk8sev9vry/0Gq+5uC7ZisLLd7Xi73KjzHb1+ToKC+VkSRFpo31x2ejoq8DDQQ+hg9jCRKm/UjVrIZ1Twuh9HgNqcflzPAuhRvplIsIQDOa5cLbJRL6yod3tZV1OhhdJBJ2XLbEyd+Y4diu3fznZLtb09LeeDHQu3HM/kCglgY9E/cHXJzgotsmC8yBK6A4QWgbKkbamcULirtWfGrjQvL5MOmkjGZix0pxouZW24YoBsDDNK1++9DNb9QkbCrP/uxhYOOqmrKAN2AtO0a+nfSqbQ/GQpfEV+V7BDmgTUu4HeQkXjAyuubgBDwlk6QVuqYlw3nckac6j6MZ4DJn/4gx2lM/6yc3Ri73q7yAA0T974IdPBGeXXhGYUWtTd8b5ZM53l4cik7wc4HwzMCc3qVok67l3m6AawzJu4Bpw9XVc4i7Nw8M85ioX5brHPlSdYuVBP0YBvLUFyRgwJjY5pmnaFdHG7wUAUjpLsV6LxtLbSobPJN0hZPcZfjJ+h/HH3RBM01HWuh9bQZT0+1XzTg5ALUNzE/yis5e
 wNY6Yg4Z
 9QfrpEenGTCQrZ+xjDxCIS4ejClgL6lNVVHS1cbtVupXeBCIqG0TFHQJAPFwaWk5KLDOgajbAOibfyqNx99Y6EmbFDxS1trANiMw/EZGRk++JOC5IlYy3gminldX0dwybCZngrReOQ2ykDeOCcQJ4Dt9OYVmXjv+ZvjzFFWVhGS+0//X+iN3g868Uz7kk8Za7Qyy+qvnzzog26GqkI43CosrQxma2QzNKmJTwYeIc1GdbD7yXfT8bv/2YR1vJj+1kk0x43W05x4Wu/B8uqT/qdWnMMffTym1mk1GI3M/hINvUBzm8eHzeRPNCcRUmuezaBbZG2E8tbDUvX1/bPbEU69qTbM9HVGC+HkEPPTuI6crKq7z7HZ6OOdEcWBWuF83uL4Ae
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tony,

On Mon, Sep 8, 2025 at 10:01=E2=80=AFPM Luck, Tony <tony.luck@intel.com> wr=
ote:
>
> On Mon, Sep 08, 2025 at 02:14:42PM -0500, Kyle Meyer wrote:
> > Optionally, a 3rd setting could be added to /proc/sys/vm/enable_soft_of=
fline:
> >
> > 0: Soft offline is disabled.
> > 1: Soft offline is enabled for normal pages (skip hugepages).
> > 2: Soft offline is enabled for normal pages and hugepages.
>
> Seems like a solid plan.
>
> Needs an update to Documentation/admin-guide/sysctl/vm.rst
> to match the new functionality and describe the reason that
> users might want to avoid taking huge pages offline.
>
> Also this line in existing text:
>
> - On ARM, the request to soft offline pages from GHES driver.
>
> should read:
>
> - On ARM and X86, the request to soft offline pages from GHES driver.
>
> >
> > Maybe something like...
> >
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index fc30ca4804bf..efa535d405a8 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -64,11 +64,17 @@
> >  #include "internal.h"
> >  #include "ras/ras_event.h"
> >
> > +enum soft_offline {
> > +     SOFT_OFFLINE_DISABLED =3D 0,
> > +     SOFT_OFFLINE_ENABLED_SKIP_HUGEPAGES,
> > +     SOFT_OFFLINE_ENABLED
> > +};
> > +
> >  static int sysctl_memory_failure_early_kill __read_mostly;
> >
> >  static int sysctl_memory_failure_recovery __read_mostly =3D 1;
> > -static int sysctl_enable_soft_offline __read_mostly =3D 1;
> > +static int sysctl_enable_soft_offline __read_mostly =3D SOFT_OFFLINE_S=
KIP_HUGEPAGES;
>
> This is changing the default behavior (which allowed offline
> of huge pages). I'm in favor of the change. But you should call it
> out explicitly in the commit message when you write up a patch.
>
> >
> >  atomic_long_t num_poisoned_pages __read_mostly =3D ATOMIC_LONG_INIT(0)=
;
> >
> > @@ -150,7 +156,7 @@ static const struct ctl_table memory_failure_table[=
] =3D {
> >               .mode           =3D 0644,
> >               .proc_handler   =3D proc_dointvec_minmax,
> >               .extra1         =3D SYSCTL_ZERO,
> > -             .extra2         =3D SYSCTL_ONE,
> > +             .extra2         =3D SYSCTL_TWO,
> >       }
> >  };
> >
> > @@ -2799,12 +2805,20 @@ int soft_offline_page(unsigned long pfn, int fl=
ags)
> >               return -EIO;
> >       }
> >
> > -     if (!sysctl_enable_soft_offline) {
> > -             pr_info_once("disabled by /proc/sys/vm/enable_soft_offlin=
e\n");
> > +     if (sysctl_enable_soft_offline =3D=3D SOFT_OFFLINE_DISABLED) {
> > +             pr_info("disabled by /proc/sys/vm/enable_soft_offline\n")=
;
> >               put_ref_page(pfn, flags);
> >               return -EOPNOTSUPP;
> >       }
> >
> > +     if (sysctl_enable_soft_offline =3D=3D SOFT_OFFLINE_ENABLED_SKIP_H=
UGEPAGES) {
> > +             if (folio_test_hugetlb(pfn_folio(pfn))) {
> > +                     pr_info("disabled by /proc/sys/vm/enable_soft_off=
line\n");
> > +                     put_ref_page(pfn, flags);
> > +                     return -EOPNOTSUPP;
> > +             }
> > +     }
> > +
> >       mutex_lock(&mf_mutex);
> >
> >       if (PageHWPoison(page)) {
> >
> > > > I don't know, the patch itself is fine, it's the issue that it has
> > > > exposed that is more concerning.

Is the $subject patch still relevant?

I gather from the conversation following it that it isn't.

