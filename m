Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EA76CA0FF0
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 02:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5203D6B002A; Fri, 29 Aug 2025 22:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0006B002D; Fri, 29 Aug 2025 22:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 397A46B002F; Fri, 29 Aug 2025 22:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2659B6B002A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:41:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B060385AD1
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:41:35 +0000 (UTC)
X-FDA: 83831872950.05.8016EB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A37E1180003
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:41:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lmj1+lj1;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756521693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hZNaP5JIdF8J3UuqbOdm2dFiWxzlS3/JNJCD54zftQ=;
	b=eJ2vfLVe7rz0gxgGEaD4BAPpj42ZjlhuUAMht2nTl/YFID6RwpigdM/YANCqVrqSAMNahT
	wUsw929Wre0Am6u/Yn4pWCrsJ1jDXbQlsDanD1sFJIfZXw312Hvc8kMgUS/mQpTD0BKkla
	UX16x/SZ8hWL4yhrsCoyZvuprjUXii0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lmj1+lj1;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756521693; a=rsa-sha256;
	cv=none;
	b=kc6B+2XXR+0284xh+eVQByacrt0glRub+AlipGYH24f6tyAc3E89ElTooTz0QaZuz32ZYO
	6cvBIZn6MOsEEKkQ409dy7rcGdtDlfGbTjkNoiC88ABfSoQjzUn3HGp9YSQfqHQDyHDtle
	MuWRrQOQSN4UniBsEhHYB/fuyECejFY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2DC44491C
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797C6C4CEFF
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756521692;
	bh=5G9qiu/3oCfZ8wkaAtF7wRf2rZ6I1+X24VOlhJZYYtQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Lmj1+lj1X0oKH8Bz7zcE+7CjtnLbobOZgOsOS0OZ11HW12V1HTsUZHm3kAnA9IUFh
	 HR0VApKVkD1yXmO03fFQ2ibG25ZU6TB9fgN3MLUlx9LhX7JON14IvSdascHebI+znw
	 kgovQrd+UZtN9YmyJ6AJZ1ebbvcOsKSC8YsUp1j2oQyDf4zXnERo4cblWLMkNM0BmV
	 wcBbL1QVwHVGB4GEbYAHWyjUGo9BbOIFs9ZgcRmenQS42eA80pymonFjjDWmrL0VhA
	 qdeawbBU9LLyelfVuk2Kf/BN4To2TGgCbsIyX3PV0/tC1Qj7VltSWbEJpzNW4iLDc4
	 nNJUMiZ5AigBw==
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e970f3c06b5so1618833276.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:41:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVRnyG+zoai3eniUtXbk9/k5LBqZ90YROYoIYgNeE76SmLd80fkXgnOaZnIwZICzqCNpGUxDoXtdA==@kvack.org
X-Gm-Message-State: AOJu0YzdHHegmaQy8nQgXN5wRhv6DkAgmAXwVj13OL11JveNPBClVly1
	U891Q6mDjcX2BIUfsn5ntKcTb420SQOUVJW/I9j6lcI/XJbM7w9ns43iJQ6ZMuV693CcWqCtfzo
	hn1clM62oif9z3wvbPQ0gQAvdhTX/yLrhNbhXbYYdGg==
X-Google-Smtp-Source: AGHT+IGQ/k6INOYWvFdwTiuHTFlhFF5y46EnkbBNJMpXn3ZucQkUXRKv0aX51LSFkQRpwfIt0tzcNZNittrjRchbbbM=
X-Received: by 2002:a05:690c:490b:b0:721:6adc:4364 with SMTP id
 00721157ae682-722764cb124mr8314527b3.33.1756521691714; Fri, 29 Aug 2025
 19:41:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-6-ryncsn@gmail.com>
 <0fc6e083-b7be-4144-a50c-d1a7a2e1c3a5@linux.alibaba.com> <CAMgjq7A7_ZbSWJQj8wjhPb6vt=iLhHc5r=cJdzMeNpog-PcstQ@mail.gmail.com>
In-Reply-To: <CAMgjq7A7_ZbSWJQj8wjhPb6vt=iLhHc5r=cJdzMeNpog-PcstQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 19:41:20 -0700
X-Gmail-Original-Message-ID: <CACePvbV=HkuP8w=LvifvAv1O8VD0V0XPOfckVtLiEfHS3NnhZA@mail.gmail.com>
X-Gm-Features: Ac12FXxQ_kp6T58GjnYmxVVATJWYvm8TfahAQG6V-Cc0HTgxhU7fBqlqLgbOncI
Message-ID: <CACePvbV=HkuP8w=LvifvAv1O8VD0V0XPOfckVtLiEfHS3NnhZA@mail.gmail.com>
Subject: Re: [PATCH 5/9] mm/shmem, swap: remove redundant error handling for
 replacing folio
To: Kairui Song <ryncsn@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A37E1180003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: j6xjtm4hx7z8ouc4qagyijs1goanptgm
X-HE-Tag: 1756521693-261987
X-HE-Meta: U2FsdGVkX18e1vlUINptFrfbQZqBpiRivcd056n9n2lN9Lr8i34jPx/eFqKKlZ+AB5H4lQt7fhGejFvJBdhgWHvz1RnlrpzEVdccZ5V0CK9paqAdiF9N3B0lLuNOwBq/8xgq5sfXpNeYoxws+fl3jV2J6hXaFlyrU2bfvapo+2tiNc13C1NXfsaTmY14oNuvE4xrNDalwFSSZ2qVg0BvnmmXluEexKxe1UMaSDuO6FwLmyrdQ3uzOBIQbmgo3BSKRmlAnpPtw2buvIpLU/iWoBb9fMM2VaZ2BgvCQlILs6jtgZb5eFQ+hw+KYmEWzkYqP6sdpclxK3SlbmjVrmWq5MLdLFTXSDN+EED8g4Mcr01fNRLtl8HQu1KsZjk70pzPuVouUj9utnTi6YKuCyvVvYq69Bdba0OiEHjjTGTqrYlBggYMR4yvWSURwnwNd0bbcCMS9HBo0Nh9jh8SaZ26ooEAiBKezP/z72ZrZH4fapLUuLYdYYydRwwqRi0AhHGIcWdRMlpm2ZX+yy9RrDmwBgak/33SDwQ+QaEVlHuEFoTveoPCSl81t5AWtLGSwmV3pzwmzAy6L/WDN7wcXd8Wa9lzasPA2JLtD8sxjn154JaMdeLcZjzP5fe+GNblui9S/9irlZx44azNG7i7OPEN1jzGYRL1n0JJWKd7pcu74iLz7oJy1qJ6g7QmZDcioQNroM6MP5veacQMqz/jdHSediAwQoi3rzU8WFiTX65y/2SnwPZVANKFDdBSb7Rz+wqQ9ViaDVOviwwORu61VWli4kGf+kY+v1f92e8gRTazDXCtMBpOVdEKS1I+A9EVrCZTZ/X2QaVHIheOYz5E6uE6IM3A+YeM1z7G8BQdTozFgsNZDtvOi2KTXreRSpBjtigbVCm0ne0xMRtJTfqWclE9/pXayQrOEkCIrBGVvbYeVY6/0vXnKQFimC9nW5bQRrOlosWGfYG1o1WNvTGFajF
 IObJBWL+
 Cc4XqTmemH6mBbovO101xM+07K7N1KrnN2wcGQWnSZhASlkABAsCace8oQWT87ts9RxEL1OqivpCNy8pxZLc8KNI4m+YSE/TBbKU/pzh62bXxRKQ+7FnZIPePJdOH541i92wcCh2NRxFhAWIpR9htZMhnOm2mn18E1KHVDFYbP4OkPhbTVaQD+7OiXM9HydOOQhLYnzBkbBBSv2NAPfeCzURV8nAMsAVdNgWzYi47uB03jp2XGbBD+qSHr01Aa82fNXbIdqtJ8JDsStdg4XCw8BZahNxdAlp22QAC6QXY1G2Mvv27VMa/5nkMrx+LbP9bYmuMnHACZYuEqNIwFdli2Lw91dMOSPrIIyMXrzFDFio+AZY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 2:46=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Mon, Aug 25, 2025 at 11:09=E2=80=AFAM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
> >
> >
> >
> > On 2025/8/23 03:20, Kairui Song wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Shmem may replace a folio in the swap cache if the cached one doesn't
> > > fit the swapin's GFP zone. When doing so, shmem has already double
> > > checked that the swap cache folio is locked, still has the swap cache
> > > flag set, and contains the wanted swap entry. So it is impossible to
> > > fail due to an Xarray mismatch. There is even a comment for that.
> > >
> > > Delete the defensive error handling path, and add a WARN_ON instead:
> > > if that happened, something has broken the basic principle of how the
> > > swap cache works, we should catch and fix that.
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >   mm/shmem.c | 28 +++-------------------------
> > >   1 file changed, 3 insertions(+), 25 deletions(-)
> > >
> > > diff --git a/mm/shmem.c b/mm/shmem.c
> > > index b4d39f2a1e0a..e03793cc5169 100644
> > > --- a/mm/shmem.c
> > > +++ b/mm/shmem.c
> > > @@ -2158,35 +2158,13 @@ static int shmem_replace_folio(struct folio *=
*foliop, gfp_t gfp,
> > >       /* Swap cache still stores N entries instead of a high-order en=
try */
> > >       xa_lock_irq(&swap_mapping->i_pages);
> > >       for (i =3D 0; i < nr_pages; i++) {
> > > -             void *item =3D xas_load(&xas);
> > > -
> > > -             if (item !=3D old) {
> > > -                     error =3D -ENOENT;
> > > -                     break;
> > > -             }
> > > -
> > > -             xas_store(&xas, new);
> > > +             WARN_ON_ONCE(xas_store(&xas, new));
> > >               xas_next(&xas);
> > >       }
> > > -     if (!error) {
> > > -             mem_cgroup_replace_folio(old, new);
> > > -             shmem_update_stats(new, nr_pages);
> > > -             shmem_update_stats(old, -nr_pages);
> > > -     }
> >
> > It looks like the shmem statistics update was mistakenly deleted?
>
> Ah, you are right, I'll need to add it back. I somehow misread this as
> the error handling path. Need to add it back just drop the !error
> check.

+1, I will wait for your next version then. Otherwise the patch looks
fine to me.

Chris

