Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C05CA1012
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 20:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA39B8E0008; Wed,  3 Sep 2025 16:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B688E0001; Wed,  3 Sep 2025 16:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8568E0008; Wed,  3 Sep 2025 16:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5AF8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:52:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 373401DEDDE
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:52:49 +0000 (UTC)
X-FDA: 83849138058.18.5F79291
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5AF08A0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:52:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lAS56mrS;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756932767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrGbbZHkPmOkrhxaF1dT80bUwOd57ENAbsAwajvsVvg=;
	b=o8O4D7dsWADM+2ujwo44hMP5qO930MJ4tSH5hrpI1UyVWj5WofkZWa3LM1z/FXVg/ykvl/
	Om+zqUR+TqhkcOpcSf8Uj25mqVdliA1T6c2vFwuFb14slvUgK3fhX0usDJb9aKqGWkjRVa
	FfE9qPyzj49horLgE6S7tcJAyEY3tNc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lAS56mrS;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756932767; a=rsa-sha256;
	cv=none;
	b=zSK3MlCLoPOIC7FAn1tAqabMzrLjQN6of8HzaknYOWtrvPcQ6d1EuW0d44iAQv9hsNqG1U
	vAtNE/GXDPt2DLgS1H0UslL1/KK3YlrnDPNTZg3jj3HrT3V6uArLXM+EIA25102fOpBozu
	HMukuITcYQt7+0M1D5fBoYWOrvhLY4I=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b307179ea4so3347971cf.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 13:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756932766; x=1757537566; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrGbbZHkPmOkrhxaF1dT80bUwOd57ENAbsAwajvsVvg=;
        b=lAS56mrSzC9lwOXI4A1WL7TDoM1AXSUBpDqMVetvLoS0j08AZnXry6+r9jsP1zvVZo
         TsG2tTQzrwbRewzxMOzBwHrsArZfAVYLo65Xkn/2y8CWKyd/6nH7S/6redTgQhI1zw/m
         /JFtJZt1iTbPrusf1K+nHZKgjjokQXjpfRnJlJgQJ0OGRz2VPNL7KD21j6JR31UD++RF
         Pv3P83LM/Ee4yCJYzpgLeaefcAtfus8ke5FLQnie/68n+VTHM+qrgJ7OiNQC38HPLfxl
         I0Yd4H25VukV6rcNj59QTEig8LKGNv9p3LPGB0PBIAVCn8KafrZYy30AAPgSWtUmyxyv
         bOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756932766; x=1757537566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lrGbbZHkPmOkrhxaF1dT80bUwOd57ENAbsAwajvsVvg=;
        b=c0+h7kbGujFpw/sfnLEVb0LHknsOdAuNT18Urh8eVxjRycV4JaADieKJnz2ySl5jkH
         gmKrBJ62r6LtoVJSk7iUVNKvccQRtKcfl9LreLGfgz2umCHLo5DgIapFVVZSM4w32rYs
         rxOJ1vV8kzH+LP0Rrz9JILYa5Go0ftSOLMe/CoqKwD/Yx6DY/7UNtvNzhnBmlyUKfOxX
         QAsHjZfkaVrI/V/wmEJRcARuuLItoLo+05/fm0icvpNm2DVxB2iCMGMoXJUwu4J9g9Up
         /DVO7W7aMA0fxnWxj1kuJOvR3EMx4HGjoRagXg/upOVvEokq7yJB6mRUauaZC9glFHqj
         g00Q==
X-Forwarded-Encrypted: i=1; AJvYcCVHT0/xxo5THpJqWPTI3yIyL902fOwGX7W0bsCzu8EYQsuUlolqFYbHtRkDp/Zcqv4ylgoq0O5DZw==@kvack.org
X-Gm-Message-State: AOJu0YxX5XzhxRdBodi8/sPagquKA8gTWOiTxGE27+yEUE7zOuAaDKSz
	dHnbAnerNVg5i/zfCV0E/tpk4St0fWOHDyFPReJeEMR81FeW7ObdZ7wE8FRGy/Lihf/fYPs8Gae
	DEj7WF4zzT72PLL2JisTKui/HynxwaY7XJxQf
X-Gm-Gg: ASbGncsvLVZWH1OIJfRtyw0PNy0HKOckaNV1JS12QWMij9nJTScQkO3sQknUSResHSg
	tnaVpkqTqdpD3UH/VKt89pdMflrTa1LzCwjYbe8zF8hGwbc4eBQ+gQ/iqK0s9MJQiKzJDql+7au
	jqSjRc59LTNZsMQG0mjiZiEEZQjH+9I4aeH/r7fGGNIZlVjuGf1VDR4CgkP7MZmn5oK20w1w1xJ
	tFfPBdo2Vaunhr3cw==
X-Google-Smtp-Source: AGHT+IEeKTRk/jxWcQ9dPhf7ezzD2Bpp4UPWhsV8IsVl0FOkyOHHFGsrc13kHi1JV4+qraqX+0jyUZiSZbSXNsYcJ90=
X-Received: by 2002:ac8:5a91:0:b0:4b4:ff15:2c22 with SMTP id
 d75a77b69052e-4b4ff152eddmr23444781cf.15.1756932766141; Wed, 03 Sep 2025
 13:52:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-9-ryncsn@gmail.com>
 <CAGsJ_4xON7fYg1VvcjLOsgBb_Wp4ruC+vdA4Q496GH1jXunU1A@mail.gmail.com>
 <CACePvbUVK45uRPVoO3ubDfQHikebSHFNQOsMTMvJ91QQZH2HwQ@mail.gmail.com>
 <CAGsJ_4we4ZfNqJ+v7+=0hjNKLakJ-s8qtRsGo_kp0R_th7Xvkw@mail.gmail.com> <CACePvbXjbtowr5wSKR_F_2ou6nVhxK3-+HvSs+P71PYOo0h3UA@mail.gmail.com>
In-Reply-To: <CACePvbXjbtowr5wSKR_F_2ou6nVhxK3-+HvSs+P71PYOo0h3UA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 4 Sep 2025 04:52:35 +0800
X-Gm-Features: Ac12FXz0qfkg7F_ObHqoqis0mbjXyNQlDtGx4gRi-mD9FYViJi2Cg8w3R_9QaCs
Message-ID: <CAGsJ_4wK2vXzc0z7+JNwChhtk2gSPcrZ=vHJx=qfXcr+cZiTgw@mail.gmail.com>
Subject: Re: [PATCH 8/9] mm, swap: implement dynamic allocation of swap table
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5AF08A0002
X-Rspam-User: 
X-Stat-Signature: f4dm6dn6wc6gbspx14esub1nct8ipdn4
X-Rspamd-Server: rspam09
X-HE-Tag: 1756932767-917048
X-HE-Meta: U2FsdGVkX1+vB/pcUtV5PCIDYxQefXKwo6ueTr9+HxL+LwRe8eeBrHWDkyxeTBPjt5dKH/2OOvWoTAf3EMJXxD/wolkSlsJ+UooWktszRpnrHwyXtKvK6uQg5aHCQHThBzgzBuwfYSk/iP6hVvtHCcAK4kt7ine8moPuMXSscXnOPKNcTbyoj6iC6YsYW3spfAo4NFDVc+/ZDknbdMIoqsMrIaVCQt+dECIXBEJYh3rQVl+PGDC8EJkAPxke4BwRvTIXXSH/b5TiM+4sseHptpvvIO+8RMb7FHt87Wpx3ST11F0uGhmF/Ex//8RYAzE0vspPd4kdRIrBsHY7l2LGYMLTTIoUBJM4ozn2t44IdpmHWrFA5ERlUdjXdx8/+PTLZ7w54L0CF01VmLEGOvAbVFtTa5hMYEMNvOfCrxg3M81UG87hGowggxTDvbJAYUPtxSdddHFSgjF/cx4FsiKDC5GM+HdRXF+AEl63XIy0+yjakc88fA3H8+Xd5IJ15EDUNZi/0fIfA5gTpnwQd07kaXR/4Bu7OdlBqVMvr0Ip+LKOmYTdbrWivCXheb31lDds2nUnsTGFTrQ9YyNWR+/NDHJYkjBOMb7xqJrl1KWzpBZpA5PptFN7RjhezZGZ8InPskeiGo3pBtSJU2eVNqxNeP1fGjz4bnPZe6Co9aMAnMz4TMEuNGiSaJDPhfcoKwvRlmv+YE8u+7l1fTQEQeE1uigrgHxM3RgiPfppK9i8fTfdkZex1110swLZJkV4hXynE7WDquOtYRO5id6m+az8ShXBpXU2DEq9w0LLkzFqk4SWhViIASzORfhlEJ+oHXvaE9zWc3eErbZq9cSs0BDFfrPs+lxEZSXzsNseSruhg97azLaL3PuI19slNeGZS4K25zdIO5jLWfs73k3BwPr8uMOQGuG+drPwaGAzNystxVUfUOsAhSQf2XtQyi5Rous2VdnLlGnVHQN/zOeyTw3
 SLew6ggj
 +EoR86E7KuktleMkfBIVwSwKoiKF0N1pItYEzAjURvKLT5OND4IGsbHM1MfRtDWV8jWWa50xXo/DJ1mvG410VmsVM4ToqilEKxKYPJY8irrmejMU7IEQ10c0JNr1tsCu9xBm1x34oYLN/mxknfLx0d1gHeQGhf19rv+4fK7MhrPyg2Dqaqi1y4insYrqLqF1Fq7qSsyI3ub7es8606wXMeO/cam7vq/vsxra0ErJe1Tm8NvzeTv72OS6SUE9gpiDYZwTnmfGG0ay27PQ+GC9eJmsW1UBWksbrMBOfzAv21u4nSqbUYWkyKsWMldh4rqvt/ITbCYRARy7NsZIuLqGQ4sZG7ksd0J4ZEI/nZM25CJ9rR2X00/q9SHySGm2jIQEevU6W2an6RPMIJ92LervVJkQYQk6M968op5OAqEvwxQnhcuCtnZeWdmnQ/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 8:35=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Sep 2, 2025 at 4:31=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > On Wed, Sep 3, 2025 at 1:17=E2=80=AFAM Chris Li <chrisl@kernel.org> wro=
te:
> > >
> > > On Tue, Sep 2, 2025 at 4:15=E2=80=AFAM Barry Song <21cnbao@gmail.com>=
 wrote:
> > > >
> > > > On Sat, Aug 23, 2025 at 3:21=E2=80=AFAM Kairui Song <ryncsn@gmail.c=
om> wrote:
> > > > >
> > > > > From: Kairui Song <kasong@tencent.com>
> > > > >
> > > > > Now swap table is cluster based, which means free clusters can fr=
ee its
> > > > > table since no one should modify it.
> > > > >
> > > > > There could be speculative readers, like swap cache look up, prot=
ect
> > > > > them by making them RCU safe. All swap table should be filled wit=
h null
> > > > > entries before free, so such readers will either see a NULL point=
er or
> > > > > a null filled table being lazy freed.
> > > > >
> > > > > On allocation, allocate the table when a cluster is used by any o=
rder.
> > > > >
> > > >
> > > > Might be a silly question.
> > > >
> > > > Just curious=E2=80=94what happens if the allocation fails? Does the=
 swap-out
> > > > operation also fail? We sometimes encounter strange issues when mem=
ory is
> > > > very limited, especially if the reclamation path itself needs to al=
locate
> > > > memory.
> > > >
> > > > Assume a case where we want to swap out a folio using clusterN. We =
then
> > > > attempt to swap out the following folios with the same clusterN. Bu=
t if
> > > > the allocation of the swap_table keeps failing, what will happen?
> > >
> > > I think this is the same behavior as the XArray allocation node with =
no memory.
> > > The swap allocator will fail to isolate this cluster, it gets a NULL
> > > ci pointer as return value. The swap allocator will try other cluster
> > > lists, e.g. non_full, fragment etc.
> >
> > What I=E2=80=99m actually concerned about is that we keep iterating on =
this
> > cluster. If we try others, that sounds good.
>
> No, the isolation of the current cluster will remove the cluster from
> the head and eventually put it back to the tail of the appropriate
> list. It will not keep iterating the same cluster. Otherwise trying to
> allocate a high order swap entry will also deadlooping on the first
> cluster if it fails to allocate swap entries.
>
> >
> > > If all of them fail, the folio_alloc_swap() will return -ENOMEM. Whic=
h
> > > will propagate back to the try to swap out, then the shrink folio
> > > list. It will put this page back to the LRU.
> > >
> > > The shrink folio list either free enough memory (happy path) or not
> > > able to free enough memory and it will cause an OOM kill.
> > >
> > > I believe previously XArray will also return -ENOMEM at insert a
> > > pointer and not be able to allocate a node to hold that ponter. It ha=
s
> > > the same error poperation path. We did not change that.
> >
> > Yes, I agree there was an -ENOMEM, but the difference is that we
> > are allocating much larger now :-)
>
> Even that is not 100% true. The XArray uses kmem_cache. Most of the
> time it is allocated from the kmem_cache cached page without hitting
> the system page allocation. When kmem_cache runs out of the current
> cached page, it will allocate from the system via page allocation, at
> least page size.
>

Exactly=E2=80=94that=E2=80=99s what I mean. When we hit the cache, allocati=
on is far more
predictable than when it comes from the buddy allocator.

> So from the page allocator point of view, the swap table allocation is
> not bigger either.

I think the fundamental difference lies in how much pressure we place
on the buddy allocator.

>
> > One option is to organize every 4 or 8 swap slots into a group for
> > allocating or freeing the swap table. This way, we avoid the worst
> > case where a single unfreed slot consumes a whole swap table, and
> > the allocation size also becomes smaller. However, it=E2=80=99s unclear
> > whether the memory savings justify the added complexity and effort.
>
> Keep in mind that XArray also has this fragmentation issue as well.
> When a 64 pointer node is free, it will return to the kmem_cache as
> free area of the cache page. Only when every object in that page is
> free, that page can return to the page allocator. The difference is
> that the unused area seating at the swap table can be used
> immediately. The unused XArray node will sit in the kmem_cache and
> need extra kmem_cache_alloc to get the node to be used in the XArray.
> There is also a subtle difference that all xarray share the same
> kmem_cache pool for all xarray users. There is no dedicated kmem_cache
> pool for swap. The swap node might mix with other xarray nodes, making
> it even harder to release the underlying page. The swap table uses the
> page directly and it does not have this issue. If you have a swing of
> batch jobs causing a lot of swap, when the job is done, those swap
> entries will be free and the swap table can return those pages back.
> But xarray might not be able to release as many pages because of the
> mix usage of the xarray. It depends on what other xarray node was
> allocated during the swap usage.

Yes. If we organize the swap_table in group sizes of 16, 32, 64, 128, and s=
o
on, we might gain the same benefit: those small objects become immediately
available to other allocations=E2=80=94no matter if they are visible to the=
 buddy
allocator.

Anyway, I don=E2=80=99t have data to show whether the added complexity is w=
orth
trying. I=E2=80=99m just glad the current approach is hoped to land and run=
 on
real phones.

>
> I guess that is too much detail.
>
> >
> > Anyway, I=E2=80=99m glad to see the current swap_table moving towards m=
erge
> > and look forward to running it on various devices. This should help
> > us see if it causes any real issues.
>

Thanks
Barry

