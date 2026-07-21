Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E134C44533
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251946B009F; Tue, 21 Jul 2026 09:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202396B00A0; Tue, 21 Jul 2026 09:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0CE6B00A1; Tue, 21 Jul 2026 09:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C750F6B009F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:56:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C35EA0180
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:56:16 +0000 (UTC)
X-FDA: 85012933152.01.1D3149E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id E162B1A0009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:56:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=auv+cOF9;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784642174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9fw6tX10NOGyHA6auYIwnDyOcSkQ3ibq0lAwrBaFXhs=;
	b=4W0pbsFG1MVjYx6zMOjLYXBQ9EFjoq3CAc7InTT5gjCHsbYpy5h0ITffiAizBf/D9DzcNX
	PBP5qLN52+n0KK/nzxm8wAm0iMkIW21IeL9sZDivhqMRtPdvjdqKeVNaToS7KkzWHJlVA1
	hun6+6KdH26A7GFe05KoJimJlEDDBqY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784642174;
	b=O9Qd40+sn+oGBQ6mhi6MdAFcGPvd4nmNr0j08o4lBGoggcL62FaHKscoA+yD6OLl/5LqCm
	h1Hlc3nlwKs2LWguJ4Out120U9LW/RrvsvC+yYJvQym9D/LvmPK7KvpsHHPiYIOnWSOKqz
	rEzP5zR1jcgxxMaMb9Vl7jRvD58EOlw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=auv+cOF9;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784642173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9fw6tX10NOGyHA6auYIwnDyOcSkQ3ibq0lAwrBaFXhs=;
	b=auv+cOF95a8jdbGGN1VrjO7rd9sqP3SZ8Ncho5jhTGPIKgJBwWQaZ2vc1De+MAh6sClakO
	SD/33Vlm7P4tqzmT7qWWx3Y3K6TB44kJd9GmJcXnv3daS1KSMS7Se65w/YjA/ZLmBXQYb0
	YzRsUMnzu0wj6DVyBhTs2aeQBnhHMGk=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-mNonmBm8MAui9tL4qgA_eA-1; Tue, 21 Jul 2026 09:56:11 -0400
X-MC-Unique: mNonmBm8MAui9tL4qgA_eA-1
X-Mimecast-MFC-AGG-ID: mNonmBm8MAui9tL4qgA_eA_1784642170
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5aec6240ddbso4953562e87.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:56:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784642170; x=1785246970;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9fw6tX10NOGyHA6auYIwnDyOcSkQ3ibq0lAwrBaFXhs=;
        b=aBGOaL/VnKok1wmZMYg9G+TuYuva9OxFtTE8GzrJNGItAhda/hdKRFX18yoGXbWWCG
         t/KZIMZGSNhwlni1cfGzlddVYo1mFnojvYxBQMfJEoVKpYGCXSf4tkdWG+rlXH2WIEo7
         /CUnHtYAuSa44dsUg/SyiEs+f8L6q8J5RHH+QSzq/T6WzhCcjQSCbyso7Nr6BVIGJ0jt
         UnNnFHtEabmEv+M6nU2/x1cyLDNMR12OhMdWfSBW2pZ88Ro2m8LKciwVMarm4WV6dtFN
         5JKUBVsIhalh/ELGSCPnWuE1go844pZpfiMfPrvjZLYIReoFxMbfnPf/iAyDQeuxGMw1
         vF6g==
X-Forwarded-Encrypted: i=1; AHgh+RptAPQyJE3jVbahEDF42hMgUsrQ/SJVreG9WaanghJ572+5KrEfv3FuUwV6rdTtC4xJ5Z2yko2O2w==@kvack.org
X-Gm-Message-State: AOJu0YzdxdFwpcU2+oGH/aakPN6FfWvt91nSESTZtDEx+q5PvL34Sjgi
	MY4wJUwoKxPrSVZU8rlDGjMI7rqLdepEy2k5yllQsuYFn1iEGZPoPlE9/m29OZkbtLTjpli2v18
	LfUYwMcDJfA/qcenVIQ0kNnASybHs/6u9E5KbRQ0PUvJzYu2ztkrPJmRdWJWAMhLJDjVyAMN1d0
	1KGgZq/7cT0YOBBQRXRnwX/Vic6Ss=
X-Gm-Gg: AR+sD13U0v3cChqAL2mYnI2NmapLngglN+tTvgtbCMBAUMW99n44dnPWnBU4E8fWis1
	qVhcICXLe7vQtp2fQ0NDBsgc7eJkFvRPRDwNlP2eMhPUiDrvgbUYkLHfyadpcc2sO/Higcn5Ap1
	fr1Tpe8+8opiOMJn/vPpepQiaQYxE8tz7qYlYDTCk9KMqV/D6EJZTBUg==
X-Received: by 2002:a2e:a803:0:b0:399:813f:ba8 with SMTP id 38308e7fff4ca-39eb28d2e4emr40566621fa.23.1784642169672;
        Tue, 21 Jul 2026 06:56:09 -0700 (PDT)
X-Received: by 2002:a2e:a803:0:b0:399:813f:ba8 with SMTP id
 38308e7fff4ca-39eb28d2e4emr40566401fa.23.1784642169261; Tue, 21 Jul 2026
 06:56:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260717064502.1980173-1-npache@redhat.com> <20260717182947.534af296aaa1831d13f8ae6d@linux-foundation.org>
In-Reply-To: <20260717182947.534af296aaa1831d13f8ae6d@linux-foundation.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 21 Jul 2026 07:57:32 -0600
X-Gm-Features: AUfX_mwwiPmvqqUaVHsEmV_LKORSYZ1xa64gG9rW73SaBNGLYov7qz_m_ESycN8
Message-ID: <CAA1CXcCrA9nrraxVNTdo19TRONvqM-fndSbDaCib4tZCmQC9tw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mm: fix PMD level mTHP accounting bugs
To: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, David Hildenbrand <david@kernel.org>, Alistair Popple <apopple@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>
Cc: Barry Song <baohua@kernel.org>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org, 
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VkswyLkg5KC6TqSRLpVsp44I2NvqJ0DDZtwLD8pq2W4_1784642170
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cr1xm8je96hcdej8ue7wsmwpc14i5xb5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E162B1A0009
X-HE-Tag: 1784642173-117920
X-HE-Meta: U2FsdGVkX1+AgBo629hcSN6eK+ix58P+vbdCc0oRzUesA666xACd0amRlTV2KKuT45GhNsuTFfHmqmLJKQobfEsrFjbXRS0VMrBpSF/20OzcqISZgBDKn5owVagd7ItD33MvR8o7BEnIMwjhuYV/ivPSsKIfNb3nnmrpUaBYZ+ewMlB6gCYuaVN2rwUxzB3qrS01PWQcY4GIPvz36yExGO9Cxt8tiJ1eFV5YpzpSIsgWAsSTZaoeh5LUyG61gcur9kZGecA64V5qW/tukypHrAH4dcN4cRrUwdYq4GErQjXab29z3ZP9hANmveQPGRse/TXn9EkzDNmkpceXquSCvfvA8iyZzQwQ+B/lPgTWTs1WBNP4P7gixD7FF25Hgq3oJqZs+QVNGykOtbF1nw1zOudjyV2Kevg6OX+em4dRi8pgB2yOUoajAroBmUN20JCcarT6bHAfUTy9FjF6xOEtRZtDq00lQFkTaJ52AzB0TD7t6Qm1PLFHXteC+IE4Bypjtf13UwTkOxGdRlcNmWgwTirOoqePhpvsIH5tQjd05fGj5n93B0ZIZlJQo5LZEhDtJ6jIdPHSETe6YRI5Ag46vNSVpoxV6Im6YgDQTGCk4S4QzKmpSUa52mVkzS55TchxvRgrTe8Z4YzTj4AZUd2D24VBkhrgXwYZWuofSHWZuhe9Z+Jrf5Gk46YOfogI1qNkMxKVFvIqRW4S9vTN/etsvOeceEOlht4/2XzmthPXAyPNQZxvHhRs9TpgD6fzDkOxbjMaQ5yeYPLpgYe2mqsfmB6GDzcYQIYL4VwkUwr5Q72U+AuT3SpdL2+szSThVrAmt+hHzcXLGiKITV1CFSxd22Y9X6FKR1euSbOb/Uk8l7l7UPP8xLJ3YTx9stCBgmKhQ36FCP1fQshmQ5brsPLpOgfAqy8nNlc6/G+uJ5tC5/0EucsY2x/b3l5SpJDBdDYp3pBtaXrTZLkiFT3kIqX
 ypzwaMZh
 cgdkm9kxfyzr7Lf8Kq0/T1tcZYqwKeBDRaRTDHLOllzb/uGCTMLN2haBcbMdqp0D7ThfC/Wboxzdbfc9czZV8xlPbpugo8pHl1jnesGiQ//EXIDSJT4s7VZ4KeSbK90o/RtRkxjOfIIRX1G77D1IDmbx3wdmflYS+M7LxLC9NttTWz14i8esLVclBUhNG7GFHn+OEIOX45ttQMcIYKJiWSuFZXhma3xeTvi7YScbuiCUVBf5NuxNWcu+F4ePAxaIpT8wqINdqo9KpSIfWc4qJBj7R430SxiXapGR0Vmp1VGqqbVT2enI5Msawy0YNn36raJc0hKAy5zhLD9jZ+JPdkZJqgdVBgmABleJu+FT0lA0Rf4txq0z+jOZ4fNMnHflPRnsH9VD65fou2dXDMxJ7LY381sitT4xpdd07N537TYZdEPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 7:29=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 17 Jul 2026 00:44:58 -0600 Nico Pache <npache@redhat.com> wrote:
>
> > While running selftests I noticed the PMD level per-mTHP stats (nr_anon=
)
> > remained elevated after each run. After further investigation I noticed
> > this accounting error occurs for both the migration.private_anon_htlb_t=
est
> > and the HMM tests.
> >
> > In the HMM case this is due to folio_add_new_anon_rmap() incrementing t=
he
> > mTHP stats, but never containing a corresponding decrement in
> > free_zone_device_folio(). We solve this by making sure to decrement the
> > counter when freeing device memory.
> >
> > In the migration case, we are incrementing this counter without first
> > checking whether this folio is a hugetlb folio, which relies on a separ=
ate
> > accounting system. We solve this by adding the proper hugetlb check bef=
ore
> > incrementing this counter.
> >
> > With these changes in place, the two tests no longer cause elevated PMD
> > level accounting issues.
>
> Thanks, I've updated mm.git's mm-hotfixes-unstable branch to this
> version.

Thanks!

>
> Sashiko is worried about the existing code ("list corruption or a
> use-after-free panic"):
>         https://sashiko.dev/#/patchset/20260717064502.1980173-1-npache@re=
dhat.com

https://sashiko.dev/#/patchset/20260717064502.1980173-1-npache@redhat.com

I dug into this, although I'm not very familiar with device memory.

It seems we have two options:

a) free_zone_device_folio() unqueue =E2=80=94 unqueue zone device folios at
free time, preventing the corruptions/use-after-free.

b) deferred_split_folio() zone-device guard =E2=80=94 block at queue time;
covers all callers; stopping the shrinker from ever touching/splitting
a live device folio; makes (a) redundant for this bug, but it could
still be kept as defense.

I added a few people who may be able to help.

Thanks,
-- Nico





>
> >
> > V2 Changes:
> >  - add RB from Zi
> >  - Drop unnecessary check in __folio_migrate_folio(). HugeTLB has its o=
wn
> >    migration system in hugetlbfs_migrate_folio().
>
> Here's how v2 altered mm.git:
>
>  mm/migrate.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> --- a/mm/migrate.c~b
> +++ a/mm/migrate.c
> @@ -624,8 +624,7 @@ static int __folio_migrate_mapping(struc
>          */
>         newfolio->index =3D folio->index;
>         newfolio->mapping =3D folio->mapping;
> -       if (folio_test_anon(folio) && folio_test_large(folio) &&
> -           !folio_test_hugetlb(folio))
> +       if (folio_test_anon(folio) && folio_test_large(folio))
>                 mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
>         folio_ref_add(newfolio, nr); /* add cache reference */
>         if (folio_test_swapbacked(folio))
> _
>


