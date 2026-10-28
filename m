Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76FE606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bAo252W2
Received: by kanga.kvack.org (Postfix)
	id C5D746B05B1; Wed, 28 Oct 2026 16:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0DD46B05B2; Wed, 28 Oct 2026 16:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6176B05B3; Wed, 28 Oct 2026 16:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 809FA6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:57:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C5AF1A02D4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:57:07 +0000 (UTC)
X-FDA: 85373244894.30.7B30028
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 04491180009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:57:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAo252W2;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793221025;
	b=RsK3SN7k6Gr7Lo+cN4hiPOedV291ANRuP6jMbXBHSKU1BUDlh7cDcYxjy6Iox6b3ND0gAq
	9Dy8BVcCXgY//dKDFykNg0exrLR+axnRKBq4TZTOtkjhufZhNwdXjJHqJULPSsz3GZuZuR
	gYBkQHyow1GPjL78piN277rbASXYimg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAo252W2;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793221025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1l/q9mD+UZ0LKwfpiCWXfsaYI4tdxarEWoloUn1RTbM=;
	b=wfOcRXJL0CFDz4LPVV6kbOjFlbsNJEQRFh00cRyigsbS3DteMbC/CymRabcwJtaXRJnUGz
	uEL2ypovsXdLzLVIfLBHOz5fFw9RMmTpRT35s2Ba+Wx3OObdBfLNLuwRbcOS5uO4yaifea
	AFOZCvsNc8/N+YCiWiS46mq0ZjK+0bs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CFFE440B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3121F031E9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793221024;
	bh=1l/q9mD+UZ0LKwfpiCWXfsaYI4tdxarEWoloUn1RTbM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bAo252W2QRAa0s7Lc6LTKanJY7VuCqKvL/jR9XT+digCiXnXgxe5eLnXt+/xNB/eX
	 gjy38nCEHhsg0t3L/oArc3iiBY78AdM5qcvIXWUK9XwJKMkOwy9AZ58OqTvMiblN1u
	 /YaXNQXWG6Ia2Xygw/XoeAGnHi/dzUyCye/CZ0KeMxeTNgLe6+CJ/lR/nqU9sic8nV
	 ljX5F6nDUyALjT/gHm5plnrchivHSxJUTzl6CWXCwzriV5JPqimffxqS+w8jxRi/N0
	 l9GsCUeVInL0lP72tfzIldZKaJEnBirPtG4i5mZo9i3jsfLlBv5xMRmto4dd7leZVz
	 ETwHT8m8sWE9g==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93f259cdc86so121218885a.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:57:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByiXULLZLZqYzfhdazwCYXrluRPjQtCgr0+VFovWSYe66B9724gHnBfnvqb92vb0YhKJgWCmfQZHQ==@kvack.org
X-Gm-Message-State: AFq9FYJxHXbow71TKWCRawf8mvHZldzXfk6vPVW0mf7Umakomf4CAFvn
	2J2ycmtNLYnr5G2MdgJwTP1tqvSSOftGCs1kuaCsLOMdZkNu8Xv9Gd8U4jsZ1dBWY/thWG4ZR+X
	UHfv/ygwbZqouslJnsK/otw2ZVNYDHIE=
X-Received: by 2002:a05:620a:2849:b0:93e:5821:2c5c with SMTP id
 af79cd13be357-94408cf1bf6mr528393385a.60.1793221023470; Wed, 28 Oct 2026
 13:57:03 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-3-tjmercier@google.com> <auHMXBwnwuRwHLmo@KASONG-MC4>
In-Reply-To: <auHMXBwnwuRwHLmo@KASONG-MC4>
From: Barry Song <baohua@kernel.org>
Date: Thu, 29 Oct 2026 04:56:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zuGRjH+=1JxH4BYEC-vJumKjkhXPse0jW_nKEzQXXVmg@mail.gmail.com>
X-Gm-Features: AclHuK_r9gV6TTj6VxggfDw1Rx1dq7FXiQbSIh4_WBWn2_zzCiGKkwAo5h87zro
Message-ID: <CAGsJ_4zuGRjH+=1JxH4BYEC-vJumKjkhXPse0jW_nKEzQXXVmg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old generation
To: Kairui Song <ryncsn@gmail.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sjkwh93yq1ffea7ounizk17st1zpzgeb
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 04491180009
X-Rspam-User: 
X-HE-Tag: 1793221024-481303
X-HE-Meta: U2FsdGVkX1/XlqHpZ2QIVc4Huy0OgA4sGbdiNOwIYFC9xByknETtr9MkAL4+xD4S7M6i70fVXTJdZw1+3NiUoDb+nR/K2C7ZD+Z2/qvJdCzuIabwLB7s2Mq96Xoqvhh+/Qsn5lKuRqiMJ2M0nbzK1HvEtq5zq3saLcezjr4S27U85CD0l3Bp3mN+wxeKZO98q9M6skxQop8K92jwRL9Ah7Qp3jBJd7ULJg4wkv4JnP657lHSn8o/JSazi4fVO+4twqto7KH9Q9Wk+Nd5nC1lOUPby8Mhw7jji3f0EQmTKFH9zlWFdWvFMixS8Q495OeUs1XzOsxAEm9aksIVJXGxOPTtog9uQBuUQo6Dp7PEyn3FaeW1UOiTIBeMk80JfRYHx6j+jwIMVlaxkuy9LUIJc+04/nGi6G3kUb4d5Hrc+SdUKcMdEFw7iXwM+PrNp0nMJhnjUO77JF/3k8xvhKLNUEtb/ScS3ZHYIPGD5+ZT7TTZvLvFJxNM45PKpo/fZGR8Jzi2GB5TuecFAHPAr5/U5KB2ulix78oyumQILsVykdZJBca/QJFsCXxaTA2phcOmiFhaRs6GvTqb7VTaC0Iivg0Hz+PNSZHhMv7jPIM3PTYDvgpjhKq9zw0HtK1g57EUO4310RhaHUXEO2799PGSHbtpRCEEWeOuLuV4e5VtBfp4WQhTn59v+8wQylYY6/28GPrIZz1K6xwMbBXw3hGt/IRei/kciv4JNNJYt3i0EijuctgjT8m93QOkJ82Sto/HEOkuZyR6y/kZ8TTnrUN1tC45JUIECS9y9YEqXHTiHJtqa6pFJ/29ITxMmgc/z81T1HAg3fmks66CvmmZmhKH/jEM94rzutOhWUpOYjkh9lBybZDF3iP70h9V1a8eNdazaDqj9Sp89hiQXvvjLpQ3gPgz6Nd9U1MzUS/SP+sKUw+7Xdtb+nPGZxqrCIjTCV06OtA5ITBan4s/iJdu1EP
 We2QkXGb
 BRcvG6MDkL8/T0eoxZ0XIJiGlb1jRCIgADGy3VbjGNRTI/vRbXBB0YP7LUfr7bDTWM4yWD1fbpFUb4Fn4gWMm4bDziJa8i/KM9pBH2UWvdXuZe+kTfqYS8XLAOGCXYlsELUqg2e4z8vR+oNjFh/7xdk2dRjQTH8eyoqBrMlZsYlUTax6jpiSa7PYr29g+wDHQL7rx7yYjOfaefzbx5xL1ksnLQEtIPOMmyRP0/DStz/42+W6tcZmHK4GLMWaKHNak1zp0PU56WAiWDL+ISJ63FmHwH2I1Ufilfg2JRe2ePqI2rDrg8nAewpUQ01nXOqLxFexDTXK+85GP4Zt79vBJRXwPlTyEmIDNRI4o+a48UAa/x8lGs+fuJNB8mUq+mwxd/nkk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 6:43=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Oct 27, 2026 at 06:06:06PM +0800, T.J. Mercier wrote:
> > lru_gen_offline_memcg() moves an offlining memcg to the head of the old
> > generation of the memcg LRU (MEMCG_LRU_OLD), so that global reclaim
> > visits it first and evicts the folios it left behind.
> >
> > Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> > dying memory cgroup for LRU folios"), those folios are reparented to th=
e
> > parent before lru_gen_offline_memcg() runs, and nothing can be added
> > back to the offlined memcg's lruvec afterwards. Putting an empty
> > offlined memcg at the head of the old generation no longer serves any
> > purpose and only delays reclaim from the memcgs that still have memory
> > due to additional shrink_many() iteration.
> >
> > Remove lru_gen_offline_memcg(), so that an offlined memcg is rotated
> > like any other memcg below the reclaimable size threshold until
> > lru_gen_release_memcg() takes it off the memcg LRU. MEMCG_LRU_OLD has n=
o
> > other user, so remove the op and update the memcg LRU comment as well.
> >
> > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> > ---
> >  Documentation/mm/multigen_lru.rst |  4 +---
> >  include/linux/mmzone.h            | 14 +++-----------
> >  mm/memcontrol.c                   |  1 -
> >  mm/vmscan.c                       | 20 +-------------------
> >  4 files changed, 5 insertions(+), 34 deletions(-)
> >
>
> ...
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 636152d8c94d..45a2c1021f4f 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4538,7 +4538,6 @@ bool lru_gen_look_around(struct page_vma_mapped_w=
alk *pvmw, unsigned int nr)
> >  enum {
> >       MEMCG_LRU_NOP,
> >       MEMCG_LRU_TAIL,
> > -     MEMCG_LRU_OLD,
> >       MEMCG_LRU_YOUNG,
> >  };
>
> I think there could be other usage of this LRU_OLD macro, but indeed
> offline is the only user currently, removing it is cleaner.

I'm imagining an Android use case where, after LMKD or similar
userspace killers implemented by various OEMs kill an application,
we may want to prioritize reclaiming its memory by making it more
likely to be scanned and reclaimed, while the killed application's
memcg still exists - not offlined.

Similarly, a foreground application might benefit from a lower
chance of being scanned and reclaimed. This suggests that Android
background-to-foreground transitions, or LMKD itself, could
potentially leverage the reordering of memcg LRUs.

But anyway, this is not a reason to keep
MEMCG_LRU_OLD for now.

>
> And everything looks good to me, thanks!
>
> Reviewed-by: Kairui Song <kasong@tencent.com>

+1

Reviewed-by: Barry Song <baohua@kernel.org>

