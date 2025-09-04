Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69B90CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54198E000A; Thu,  4 Sep 2025 02:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2BDF8E0002; Thu,  4 Sep 2025 02:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A1C8E000A; Thu,  4 Sep 2025 02:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0F98E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:50:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47CB31A09A1
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:50:44 +0000 (UTC)
X-FDA: 83850644808.29.2A16313
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 64BD9140004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:50:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RDSlozPx;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756968642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ufVzcq8zm3A0Ht5VXxE6QoMNGE1Z254EF2tmVFoc4DU=;
	b=ebshMISDpq0TorrH6SbNsttYpPLu7tFaD7MclWLpnq5q/wslb1Kz8WUftpsMUJ9obZZkqW
	xvGOVAeWnz+FDSMKCcJoXVHXVHhGxmBPb2XD6YgP8W2YOfUts8/ujS8iSfZKXbGtH3m5bf
	EMBoldVBAr7MMbP0qDf9SMtQnt5ta+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756968642; a=rsa-sha256;
	cv=none;
	b=RKGoInp0e5JbvoaALeJZtcWgIuBzv04wGSD87aMfMFdE+Te4hx++CFE9QO5nLGwZjOLFA/
	YKMr/T2/VeAvBFVbqPROVFqecacTuKI4sJeiW0yvcWdQuZMMIhivq2o+ZjL0UsDxDluxYW
	VEmQFiiz6AeYi9EpKoDQqDyhg7FwuN8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RDSlozPx;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C3C676026B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A23BC4CEF4
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756968641;
	bh=ufVzcq8zm3A0Ht5VXxE6QoMNGE1Z254EF2tmVFoc4DU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RDSlozPxIPfc6Ho7vhX6r4Ib3+NiyO2Yzq2jQDrGjDYJvBZX4N66OiK/Sr2F/x4uT
	 oL3x6YMKzhJEeD/4WXh/Q/D7+e/Cs3Te5Z8/t7I6n4kF34Y0A9AXiMXVKIOAmWl4ol
	 XLPZ32KZ6M+a1wao+aCl0TI2U07g89vH1mGt9KFtxl/OdFb43A2wkF47/FyucIRs5l
	 Zu1ppZRb6jea6V3QZClTnaN7df9nMrP5BXaRLjpA9heJV7wSFdmnZQhCq4gjEzvZLb
	 8FWhnQvllBt+bfqityfFO4s21+7a2s7R9nA9/KkUGGZ+RYJcUcmdsTj5TgFjfT6rxb
	 scAyFJNSg//KA==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d603a269cso7211227b3.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 23:50:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWF+6FodjvXjwYkndD88OeFAjZP2OgA2DuPg0K9K/2fi38S1NwbjDrr4e0KYKoxKup8RWGWJ5rFxQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9zh9z1hu6a4UwlGaYIZcyr+CdG3eAiWCBjZJq0SAWJW0tlwwf
	0lRw9NfpsG7pDiCQMdXs685NPkaSp3QmlAIyINTAfqSNtRfOjqPPlc/NNGeY05aoFFJQHWzFdyr
	xd7Jia+yHp63UuVT9Z4wA8Hhcq5+K5t96rfM7q7xSKg==
X-Google-Smtp-Source: AGHT+IFhEKVdKiOgUb1HTDtx+Ip1bxA8hKxDH7kCW9l/rVvtQc/1r/5b1lwTccJNO47HGH9k3FQotKLzDfWksD0QlG0=
X-Received: by 2002:a05:690c:ecc:b0:71e:76e8:2457 with SMTP id
 00721157ae682-72276387388mr222815057b3.22.1756968640654; Wed, 03 Sep 2025
 23:50:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-9-ryncsn@gmail.com>
 <CAGsJ_4xON7fYg1VvcjLOsgBb_Wp4ruC+vdA4Q496GH1jXunU1A@mail.gmail.com>
 <CACePvbUVK45uRPVoO3ubDfQHikebSHFNQOsMTMvJ91QQZH2HwQ@mail.gmail.com>
 <CAGsJ_4we4ZfNqJ+v7+=0hjNKLakJ-s8qtRsGo_kp0R_th7Xvkw@mail.gmail.com>
 <CACePvbXjbtowr5wSKR_F_2ou6nVhxK3-+HvSs+P71PYOo0h3UA@mail.gmail.com> <CAGsJ_4wK2vXzc0z7+JNwChhtk2gSPcrZ=vHJx=qfXcr+cZiTgw@mail.gmail.com>
In-Reply-To: <CAGsJ_4wK2vXzc0z7+JNwChhtk2gSPcrZ=vHJx=qfXcr+cZiTgw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 3 Sep 2025 23:50:29 -0700
X-Gmail-Original-Message-ID: <CACePvbWhxBVkZtTYumjiyufYzZHeYq0oVQBLoHBghYO1P_e1=Q@mail.gmail.com>
X-Gm-Features: Ac12FXyKJVNh2EtzlqV9oVTXA2V2P4p32K8I_rvJswW67hlQD6kUeMFJjVHTzGo
Message-ID: <CACePvbWhxBVkZtTYumjiyufYzZHeYq0oVQBLoHBghYO1P_e1=Q@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 64BD9140004
X-Stat-Signature: 8jeb6oofkbxrx7ipq7zbbyq48af8j9am
X-HE-Tag: 1756968642-726241
X-HE-Meta: U2FsdGVkX1+6IWIDGG6tQj0Sxv1ZhO/vhn5dSQb6CH8ddNbK8moT8UF+bgDRrsenyv6MLvg6Iq8adeUdeC1b8mQ+T9qBwVqKQRJCVX5cr5ssWmbLNkfVUHVTzH4tcsMauIU5l3pfnVhGficG7rcvs6bMm9j/XIk/gzqiuBuRdumE4J7q5UbaA2LvhUBkUj3u7VjeG9578B7Vypsvpa+s+KSnE4JZLKPt+FzgZ96S+NdllaWTekIpblMRDxnJWOKclfJ7Qbe0U1IJ3rwk4qSCZZC9l43vcf3isDJh+igMmNHtAGgpkhJ78EvYtF38CpOHeoGe56Q4jlrYgYve7/7LeTN7xAhC44ipjsB/pyPTkZxZDh/+ET0vt9HVNdZl4zlDY9x7SnaUcDRfRPQwR7MgobHB+Fpr89pQEbHoydmiJnsee0xlWJbFDE03fttk3b/t6q8f90QeGbWSpvur2KTVbcuHQqS+XSr1YmBEjD/vqroCArm7QBUGOP1i8bCNly4plvim3JbjEoHtbcIkM8Lmrkrs0rmO69UNyUcL7zE6zcXbAoQba2knwoHd6cILDZRYrizuKP8q2UbABHr5XhZ10OR1D5dA7KNyrq0GPv0AbV8tMEa/TspHqsn7Lj2RnruD9wy8v63yVqhXDYCVJh6OPGjh4RCsf0s4tlrTbnAlNWDm7eh6QqN3jfYEB+KZVPQGeap08eI1C+XruwHTXA+RV593MrGixyMm5xiw9ILX0uHqrctAoAhYEDJbWS9D4ZuXYo82Qu7QYUt9bqHuDrjp+M1RL1sWLVtoEDnyiv6ly4mIbKBM0G5W/DiHDLt7H1CMYNSCYQlYewfd32dAPEejZw6FRP5dXnuGdoDTcwUGEZVpOCJ9dzclmxFuzeXNcCJXYFbtB8Iwz5h+95TbBuO0wpNSmKcSyJBOwSIqDU84e4zYlb7aPBZNxSDH/2l30WbUzhlRsEcCXkYbJ2Lt2nP
 zn8lWduS
 C50eLo2opDIkRXexPRfbWMBB0qNVghbUgeoyh6BZn4BRWaYJUxgtumoLpCVfiYgVc4zBv2pkJOl0eLYUPVCObqQgK8tt1CMEBY5RyzVKnNz2LpKXB4QJmG3/FUsbAIDwVJb8uTOqPv3cIsokavFZseMkTTHkeNfzxMW5URxqjpYUljrLYWidxhwHlbi8jhYKvbcNgFzEg36M3UFThn7cAQ5LxndsyVGsIBor10d3G1eHwPxaIVmZtnuWq/YtHNwXFsxX2ihu1eJHFFUfyc0NGnd22pHfUztYy8vHlntGe3R5878MauI7An8KQ0W235Q7epkz3fYOjtcwbj1akz0N9DRrL+RDkKoHDJE7yD2pQz6V92x0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 1:52=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Wed, Sep 3, 2025 at 8:35=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote=
:
> >
> > On Tue, Sep 2, 2025 at 4:31=E2=80=AFPM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > On Wed, Sep 3, 2025 at 1:17=E2=80=AFAM Chris Li <chrisl@kernel.org> w=
rote:
> > > >
> > > > On Tue, Sep 2, 2025 at 4:15=E2=80=AFAM Barry Song <21cnbao@gmail.co=
m> wrote:
> > > > >
> > > > > On Sat, Aug 23, 2025 at 3:21=E2=80=AFAM Kairui Song <ryncsn@gmail=
.com> wrote:
> > > > > >
> > > > > > From: Kairui Song <kasong@tencent.com>
> > > > > >
> > > > > > Now swap table is cluster based, which means free clusters can =
free its
> > > > > > table since no one should modify it.
> > > > > >
> > > > > > There could be speculative readers, like swap cache look up, pr=
otect
> > > > > > them by making them RCU safe. All swap table should be filled w=
ith null
> > > > > > entries before free, so such readers will either see a NULL poi=
nter or
> > > > > > a null filled table being lazy freed.
> > > > > >
> > > > > > On allocation, allocate the table when a cluster is used by any=
 order.
> > > > > >
> > > > >
> > > > > Might be a silly question.
> > > > >
> > > > > Just curious=E2=80=94what happens if the allocation fails? Does t=
he swap-out
> > > > > operation also fail? We sometimes encounter strange issues when m=
emory is
> > > > > very limited, especially if the reclamation path itself needs to =
allocate
> > > > > memory.
> > > > >
> > > > > Assume a case where we want to swap out a folio using clusterN. W=
e then
> > > > > attempt to swap out the following folios with the same clusterN. =
But if
> > > > > the allocation of the swap_table keeps failing, what will happen?
> > > >
> > > > I think this is the same behavior as the XArray allocation node wit=
h no memory.
> > > > The swap allocator will fail to isolate this cluster, it gets a NUL=
L
> > > > ci pointer as return value. The swap allocator will try other clust=
er
> > > > lists, e.g. non_full, fragment etc.
> > >
> > > What I=E2=80=99m actually concerned about is that we keep iterating o=
n this
> > > cluster. If we try others, that sounds good.
> >
> > No, the isolation of the current cluster will remove the cluster from
> > the head and eventually put it back to the tail of the appropriate
> > list. It will not keep iterating the same cluster. Otherwise trying to
> > allocate a high order swap entry will also deadlooping on the first
> > cluster if it fails to allocate swap entries.
> >
> > >
> > > > If all of them fail, the folio_alloc_swap() will return -ENOMEM. Wh=
ich
> > > > will propagate back to the try to swap out, then the shrink folio
> > > > list. It will put this page back to the LRU.
> > > >
> > > > The shrink folio list either free enough memory (happy path) or not
> > > > able to free enough memory and it will cause an OOM kill.
> > > >
> > > > I believe previously XArray will also return -ENOMEM at insert a
> > > > pointer and not be able to allocate a node to hold that ponter. It =
has
> > > > the same error poperation path. We did not change that.
> > >
> > > Yes, I agree there was an -ENOMEM, but the difference is that we
> > > are allocating much larger now :-)
> >
> > Even that is not 100% true. The XArray uses kmem_cache. Most of the
> > time it is allocated from the kmem_cache cached page without hitting
> > the system page allocation. When kmem_cache runs out of the current
> > cached page, it will allocate from the system via page allocation, at
> > least page size.
> >
>
> Exactly=E2=80=94that=E2=80=99s what I mean. When we hit the cache, alloca=
tion is far more
> predictable than when it comes from the buddy allocator.

That statement is true if the number of allocations is the same.
However, because the xarray node size is 64, xarray needs to be
allocated a lot more often than swap tables which is page size.

From the page allocator point of view, these two should be similar.
Basically every 512 swap entry allocates one page from the page
allocator.

> > So from the page allocator point of view, the swap table allocation is
> > not bigger either.
>
> I think the fundamental difference lies in how much pressure we place
> on the buddy allocator.

Should be about the same. About every 512 swap entry allocates a page.
That does not consider xarray has an internal node as well. Can you
help me understand why you think xarray has less allocation pressure?

> > > One option is to organize every 4 or 8 swap slots into a group for
> > > allocating or freeing the swap table. This way, we avoid the worst
> > > case where a single unfreed slot consumes a whole swap table, and
> > > the allocation size also becomes smaller. However, it=E2=80=99s uncle=
ar
> > > whether the memory savings justify the added complexity and effort.
> >
> > Keep in mind that XArray also has this fragmentation issue as well.
> > When a 64 pointer node is free, it will return to the kmem_cache as
> > free area of the cache page. Only when every object in that page is
> > free, that page can return to the page allocator. The difference is
> > that the unused area seating at the swap table can be used
> > immediately. The unused XArray node will sit in the kmem_cache and
> > need extra kmem_cache_alloc to get the node to be used in the XArray.
> > There is also a subtle difference that all xarray share the same
> > kmem_cache pool for all xarray users. There is no dedicated kmem_cache
> > pool for swap. The swap node might mix with other xarray nodes, making
> > it even harder to release the underlying page. The swap table uses the
> > page directly and it does not have this issue. If you have a swing of
> > batch jobs causing a lot of swap, when the job is done, those swap
> > entries will be free and the swap table can return those pages back.
> > But xarray might not be able to release as many pages because of the
> > mix usage of the xarray. It depends on what other xarray node was
> > allocated during the swap usage.
>
> Yes. If we organize the swap_table in group sizes of 16, 32, 64, 128, and=
 so
> on, we might gain the same benefit: those small objects become immediatel=
y
> available to other allocations=E2=80=94no matter if they are visible to t=
he buddy
> allocator.

The swap table is page sized. One cluster still has 512 entries, If
you make the swap_table smaller, then you need to have more of
swap_table for one cluster. The swap table for one cluster needs to
add up to 512 entries anyway. Smaller size swap table does not make
sense to me.

Chris

