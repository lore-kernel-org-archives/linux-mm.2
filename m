Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A62EACA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 12:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE55F8E000B; Wed,  3 Sep 2025 08:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96258E0001; Wed,  3 Sep 2025 08:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84F18E000B; Wed,  3 Sep 2025 08:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C113B8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:35:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CA9411A6D8
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:35:38 +0000 (UTC)
X-FDA: 83847885156.12.7C4F71A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6753340010
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:35:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iNCshDMl;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756902936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLEC9Evf5FlWOMlAZljYLeumaRL0HGk6iNDsEWfj9Yk=;
	b=QJkFWN4vUDQLZ43wmoYKSv4kOz3bDGzI09E9MzgCa/aRi6W6B6dnhsqhBgswPHja1sk+hf
	cWgVhW+mR/Km5/KJLQrWCz6JL8iEfCjAmt7nAaEDkK4fL7bCOC1M8B1ALBBua0JDwFG8Zs
	lxEEcKgTAn/xrgluNT+Pm7VEUpQEt2c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iNCshDMl;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756902936; a=rsa-sha256;
	cv=none;
	b=d9y0nVy/ZBHxJhfTKIxbDOKxOKfsGMU/85hMAonnZWqLZPeoQ43oew3z6T+utKPCyIFRfi
	c1a6ZVMRU5YsxdkRCyEOrWaNwR7AHUQ4GC0vejaqXKWv1v/RrLwcBduylz0+LaMwsHmmvf
	iN16IOm2rXXcyfJDtSOi5tz2KUuG0DA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D5D9A41842
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AC9C4CEF7
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756902934;
	bh=DLEC9Evf5FlWOMlAZljYLeumaRL0HGk6iNDsEWfj9Yk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iNCshDMlH0PP+U9tYmnBYVOGgDIkcmqrwdh58SuD3jbDPCfT4moWf816Uj/eyH1S7
	 xr6Rsz3M4EqSRpcx0hvbNvyyWs5zwuoj/6hF5BVsUMOZf20AweHu2VMcIkWbDoEm6x
	 ylEuQbTRLsGKMC1RD+YXty13wYoqapj7BYfUc8Rf7KjNSN2Uu1AIJc2ww91TbO6kIC
	 eSHMsXBM//vvLNUR9i5Ca/bCJUbVtIFxo0QpsA86qs4I1iiybANMQtPVr33aeZzCgG
	 yTcC5kBMtuCaAl/492FDWR7eKBOjpJv2n4qd0EGNVANtGlWKdpGO2V5qyYACUqyXwk
	 /NzZXzwtJB3FA==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-71d603cebd9so68051977b3.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 05:35:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVlIaAoPR1CQVGpcOvlWyMwA2t9ry2dmJPTMBaPL1+i3DvlkxTOBnI7XZBnzaQldvV3PPBl9xHyQQ==@kvack.org
X-Gm-Message-State: AOJu0YxeaUhgw4RfoXG16579pu9tC0P4qRS1RQDBa/UII6tnIJzvWT8q
	1Cgzqpr3aRzNM4mVU2hbFMEts0wA3+W7SNNEuGC7KvZp5/mgv9Z02xhp0Az6qrkTGPAIa1q+JOG
	DaP7Rl+9jrtRg4c4oGKUQDV20SdWjD+tN0FBjAPjZmg==
X-Google-Smtp-Source: AGHT+IGmgXA5iAxR2DYRbTXvmclzzmqAtU6Yh8IWC7J9OjhAjhsYHmOxUIuiq8Gsl1Ovbv6IdvDksI2ck1w83DXMZ4A=
X-Received: by 2002:a05:690c:6903:b0:721:40df:7383 with SMTP id
 00721157ae682-7227655ae4fmr199308807b3.41.1756902933940; Wed, 03 Sep 2025
 05:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-9-ryncsn@gmail.com>
 <CAGsJ_4xON7fYg1VvcjLOsgBb_Wp4ruC+vdA4Q496GH1jXunU1A@mail.gmail.com>
 <CACePvbUVK45uRPVoO3ubDfQHikebSHFNQOsMTMvJ91QQZH2HwQ@mail.gmail.com> <CAGsJ_4we4ZfNqJ+v7+=0hjNKLakJ-s8qtRsGo_kp0R_th7Xvkw@mail.gmail.com>
In-Reply-To: <CAGsJ_4we4ZfNqJ+v7+=0hjNKLakJ-s8qtRsGo_kp0R_th7Xvkw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 3 Sep 2025 05:35:22 -0700
X-Gmail-Original-Message-ID: <CACePvbXjbtowr5wSKR_F_2ou6nVhxK3-+HvSs+P71PYOo0h3UA@mail.gmail.com>
X-Gm-Features: Ac12FXzB2G67O6c2neqhsxxf2zRfAm25LgGfCqfNTYe7Va-TDT5xLTpHlg6jKIU
Message-ID: <CACePvbXjbtowr5wSKR_F_2ou6nVhxK3-+HvSs+P71PYOo0h3UA@mail.gmail.com>
Subject: Re: [PATCH 8/9] mm, swap: implement dynamic allocation of swap table
To: Barry Song <21cnbao@gmail.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6753340010
X-Stat-Signature: 1qbupnot5475j9ytiou99qkgwrgo3com
X-Rspam-User: 
X-HE-Tag: 1756902936-683370
X-HE-Meta: U2FsdGVkX1/lRvmobpxFYEtEbn3smavlhf5a7DVKia/amEOpiHwp/TXH9ay5lIRK9njcetsNxqMxPZGk/RAhrdofCKstjxsemuq7TT7JDTb6a8oqhK1Z9P2FRSn+HmFjiVqSfpO/IRk1Kxap+g/gBhjr9BkigCPpBAkV61snkAa6Ue1Nqwm2iG/WpYMTSKRPnQ9vlqX2vLbQP2GR1XdcYDN1F8eN0GbQunJj/dY4BEKmY/YXE4XR0MKaHyaIrcrfjrpSj60EEsbgZ54nZ63klLk3Uc+DYoopFtObVvHQaajXcsM+VfcHOVrF4K3an0ofZJBNKITpQnU/J9zFYWIfGXN7KHwsQnjYVM5laBLG5hn7LDfiPMxL51lTY66EcwNW3I3xeD7c5x8PSfdtNLu2mHi8r7fFFp6xbjTqqGjjHIhf8i5SK27NyEWxLYhkqRCod0nijJDcW2+1XVamwth125l3wZiyyKzHlywfnXrRAsUX/eei2K6LnWHxGG5WUgfdpXSOvRfz7f/j85FWx0OZ3Ecsj7rnUVvNezy6Ultbzgd+NaBS505r4GwxZ5Ud2gtKTos2GJHik/eclox1+PSFi9V8a3YrpypAYRa+ylHrlMD6Qh5kIPDeQysc2/VYCvOPGEnKZB6yNV5OdcpxYgx0uaIS7gF69s4uANYtVGTvqB0g2N1c51JHtGRPvKNKUIcmECvPO4XzLj3KT4M3gBxYZj/XYHydZkPBg2bV/tWr5XKiBNClCgfPsf7cWbXXgC44IqF94yiRzns69hc51bkjemDue/Ia1wYuS3qCNcO9W6spH3Ch4Bao960J7ZkWtOWNCg76sMMyj2hp3k/GtCngXvsm+z2WQ+usSNU7iOadPX9UoO/unODyTKtcWdvGzySjBnFnsZAr/tDJhCZpQqMmDRVpqfYhZ4D3Qwyqr0aA9SBk7W74yqWszmXuqn6r/cBRs9JitTWs1n/ed6KwrPn
 t3oCBufr
 aRHjh66qFqR+1Y4OdqTStuCtc0N4YTPypo5VJaz4bxwUOAOet9Yhc89t8bR2/loPnqJ8ir8sno7MFz/368o3xdlcXJXMtXHgrHHEMma4UNV9RLnf5ET8CUUdg1nHzJOUJZJ7V5TIfrIy4ZvNREE9XfutNmLqz4tLbyb35XMkQmI2uAH5AZ7MPVmdpQFdpNElvP5jdjocMtZ3+E4Q6zlap1lNVbpw3tsuhUDV5NhgHVX2NvE7zf07ZZnZvc3nvXNWu01Wo2wl2V59Ev88IRj8mfwlJQME90/UkstzfOnTEN1s6K5k4kSFIqVkvf1HbQBOrUCMr6y4m4yWzGS3Y3HWWxuHikjAMYvNZECwpz5QtgSWFrDM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 4:31=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Wed, Sep 3, 2025 at 1:17=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
> >
> > On Tue, Sep 2, 2025 at 4:15=E2=80=AFAM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > On Sat, Aug 23, 2025 at 3:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com=
> wrote:
> > > >
> > > > From: Kairui Song <kasong@tencent.com>
> > > >
> > > > Now swap table is cluster based, which means free clusters can free=
 its
> > > > table since no one should modify it.
> > > >
> > > > There could be speculative readers, like swap cache look up, protec=
t
> > > > them by making them RCU safe. All swap table should be filled with =
null
> > > > entries before free, so such readers will either see a NULL pointer=
 or
> > > > a null filled table being lazy freed.
> > > >
> > > > On allocation, allocate the table when a cluster is used by any ord=
er.
> > > >
> > >
> > > Might be a silly question.
> > >
> > > Just curious=E2=80=94what happens if the allocation fails? Does the s=
wap-out
> > > operation also fail? We sometimes encounter strange issues when memor=
y is
> > > very limited, especially if the reclamation path itself needs to allo=
cate
> > > memory.
> > >
> > > Assume a case where we want to swap out a folio using clusterN. We th=
en
> > > attempt to swap out the following folios with the same clusterN. But =
if
> > > the allocation of the swap_table keeps failing, what will happen?
> >
> > I think this is the same behavior as the XArray allocation node with no=
 memory.
> > The swap allocator will fail to isolate this cluster, it gets a NULL
> > ci pointer as return value. The swap allocator will try other cluster
> > lists, e.g. non_full, fragment etc.
>
> What I=E2=80=99m actually concerned about is that we keep iterating on th=
is
> cluster. If we try others, that sounds good.

No, the isolation of the current cluster will remove the cluster from
the head and eventually put it back to the tail of the appropriate
list. It will not keep iterating the same cluster. Otherwise trying to
allocate a high order swap entry will also deadlooping on the first
cluster if it fails to allocate swap entries.

>
> > If all of them fail, the folio_alloc_swap() will return -ENOMEM. Which
> > will propagate back to the try to swap out, then the shrink folio
> > list. It will put this page back to the LRU.
> >
> > The shrink folio list either free enough memory (happy path) or not
> > able to free enough memory and it will cause an OOM kill.
> >
> > I believe previously XArray will also return -ENOMEM at insert a
> > pointer and not be able to allocate a node to hold that ponter. It has
> > the same error poperation path. We did not change that.
>
> Yes, I agree there was an -ENOMEM, but the difference is that we
> are allocating much larger now :-)

Even that is not 100% true. The XArray uses kmem_cache. Most of the
time it is allocated from the kmem_cache cached page without hitting
the system page allocation. When kmem_cache runs out of the current
cached page, it will allocate from the system via page allocation, at
least page size.

So from the page allocator point of view, the swap table allocation is
not bigger either.

> One option is to organize every 4 or 8 swap slots into a group for
> allocating or freeing the swap table. This way, we avoid the worst
> case where a single unfreed slot consumes a whole swap table, and
> the allocation size also becomes smaller. However, it=E2=80=99s unclear
> whether the memory savings justify the added complexity and effort.

Keep in mind that XArray also has this fragmentation issue as well.
When a 64 pointer node is free, it will return to the kmem_cache as
free area of the cache page. Only when every object in that page is
free, that page can return to the page allocator. The difference is
that the unused area seating at the swap table can be used
immediately. The unused XArray node will sit in the kmem_cache and
need extra kmem_cache_alloc to get the node to be used in the XArray.
There is also a subtle difference that all xarray share the same
kmem_cache pool for all xarray users. There is no dedicated kmem_cache
pool for swap. The swap node might mix with other xarray nodes, making
it even harder to release the underlying page. The swap table uses the
page directly and it does not have this issue. If you have a swing of
batch jobs causing a lot of swap, when the job is done, those swap
entries will be free and the swap table can return those pages back.
But xarray might not be able to release as many pages because of the
mix usage of the xarray. It depends on what other xarray node was
allocated during the swap usage.

I guess that is too much detail.

>
> Anyway, I=E2=80=99m glad to see the current swap_table moving towards mer=
ge
> and look forward to running it on various devices. This should help
> us see if it causes any real issues.

Agree.

Chris

