Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B10C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 06:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81F06B0092; Sat, 19 Sep 2026 02:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33DE6B0095; Sat, 19 Sep 2026 02:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24D06B0098; Sat, 19 Sep 2026 02:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B257A6B0092
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 02:55:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD93CA01CF
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:55:48 +0000 (UTC)
X-FDA: 85229601576.19.1E17102
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D1A6714000C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:55:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+AEKnKS;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789800947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBPJxnWCG6gJlIc6Oea03Hf0PVIwKD0gi2pxmpWV7wg=;
	b=hSBg082WX7kXjNIKdY5FJwuUVZDk41kVyjesMfyBoHd8R+YzSKhw09Up96pAJc2YZu9TG/
	pwFPudXMFQZ0jT61JcOR6K95RY5wJk5g/cGJs165GNLdh62LEPbKFQPLz7IK84LxVh0Rfo
	OogFCGS0ESld3fhkQSt0qugm1d/Jewo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789800947;
	b=N4Lg8kSakEYfQW2goE5bQLfiTnQBwoVp67g5mPPeZy97YzaBEs/pmrPVz23wk97D6KtsHu
	caOToPVNtPEuwDq1NXh6w8locINViFehVvJnqZF4G4pIImUNCo3RlWRsBcBukRs8nvPS9c
	2/7MdJnBKR9jBOBcdnVnCveTlciC1tw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+AEKnKS;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD2CA44501
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3E21F0089F
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789800945;
	bh=lBPJxnWCG6gJlIc6Oea03Hf0PVIwKD0gi2pxmpWV7wg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=J+AEKnKSs40RtUxFHrdfcp3zT5jxcthRo7FB00CisvBl7fEzlqFqKpcNy2v/Vy4yG
	 durzYf7lnVwsUJPJmtbX7pD1dwuBem1vFNh8WNoUsw55tcJoME5g+xWrSORan6WcJo
	 TBlIFozGzJoXeSW+JLipA+IA8JFaGt+hgLoN5WZ0n93RxrIm/Bive5HJ6dLRFkITwb
	 OVdjmBvSX0xHpCLQOtK17yCz8VHSJtsZf6HdhSTi+H+8eCY5JgzX5IHiF2Jtbh9Ozo
	 yIcYjDdND+wyMApxwUgCN/PkTKvgMG2qFqmLqmSa9SXFeNORbPO4lpTPiE6UNGDC5o
	 Iq3628FTA4ItA==
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66f7f72a284so1339748d50.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:55:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwXN2NZ2G/tW5hCOLoRLq25NJNWPxcNQS1pT9EizakTN/dg+vCwa709jIko4N4Lhmly42k7hgreIg==@kvack.org
X-Gm-Message-State: AFuF++l01L5scP2Ox22O9wMt+0NKDCZ7luBkYrgQCJe3t4yVoPIU/yfL
	5DE9TSWKyWrIKtnmT11Vb0egiootgZbG3u2W673yBEcxOoRX6VJH5fRubiFYIcEFTloGsOsFPrN
	dapujcQhd2eyOZGjL36YVWaeivFeMoH3kGUFNzZ4j1g==
X-Received: by 2002:a05:690e:e82:b0:66c:c644:3938 with SMTP id
 956f58d0204a3-6717fc73116mr1567140d50.7.1789800945084; Fri, 18 Sep 2026
 23:55:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev> <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
In-Reply-To: <aqjpYHbZ14A8xRtK@fedora>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 19 Sep 2026 01:55:33 -0500
X-Gmail-Original-Message-ID: <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
X-Gm-Features: AcwNN1Vd2tjplOjh6PB67R-OyLCbkYjVi_cZf-a78V7vf9J1xJzsesI2sggm-dI
Message-ID: <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Baoquan He <baoquan.he@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1A6714000C
X-Stat-Signature: p4njcqkbd5awb9f3r4zn857onwg9whch
X-Rspam-User: 
X-HE-Tag: 1789800946-947520
X-HE-Meta: U2FsdGVkX1+5d4NujWQ3cUVyjp00t0H27LG30UtHBrP8BkZUmE/QT8JPBAIMCM81vPL1q9GwzoSSY8Gsi4MtBjIpgYtJ7OhfTKWgRUNrgcxD+qzE8yHxFP0AvZggOZ6Fkz8WuHQ8HwKBIfGaoqP4fOfQdZmuMnkmhEoIkIODwZudujEgY+KWNnBKiotOF7UKKp8se3/HNP8uGqJsWHc4VH/9o5nRN9Ci+kp0Dv1uLBi37X70039BAhujWodU84qI/mYzAa1tQie87fo5zMh+F8JT0VBXdDG1fCKgoybajmuJ0tEdR2sqdB/R9YcTHoOQmxIFSgfA2Tq78ynpC8A5zLRskZBSpC06K5y+3btAHQTojRxBIj14RZNgUMCTxGSFxiwdEIS/UeIDBolmXj35f4fMk1kADGfvdKrBTIQWo87+66tdatuSoehSbshMILHDHky7JH/ubHYyTOqIRtVoJC6wEbrjKmgjynp4ujK7ZwOKxWHHTKHR0JQTjtSxy9Uz6ClA8bCrUuEQh0JKdANLET4lUCuuHmfa2d2wEZrD3KXAx6dJkqHmqaPM7Uej5miutZvu2LeuE/TSW0yx1aE1H+Y/rXXZHFWS/5HN/PWw3I5mKJCeXYZ3m2DSS1jkCfUP7J1aYV4bDOKBtD90mjbdtunt22S6Y1a6J0RJaJF3cuJiiHUzERQ+aCOlKdNI9B6kqfChJxjLoG+Y1VqnvoZUUTj85LmR6COKDZZdhMCBJHxuxRME8trpa5EgWL3ciKs0iG9MW8KtB9eOXGdvD0V0CzzAYGgrSdqqxkyy9lQkEBx0U2xUheLfZpT96aKoxqkePg1W7QSiroNbSzFc7VCkoqWB1I1oeDAszSeWctbBVBwP0acLLyTkXtCMlV8WCB94W1egsUo49jFi9Gizm7Fm8gf27enWNDFKPplCrVGYk3EZ6ji+KRSMXkGXsPpv7s0dlFXthKGc1yuboIzkgAD
 vM4+6I0Y
 DBJ79+dnbyLnxGj0CdJZcn7IgpsISThPYfrrOQVuVDI6kDDuQzHcSdsdrr5H9KvLraJ92B52Jwv10hy9dpYmphxjuM7Zg+Yo0QkFLIsMGr/yVO8CKrwng2ekaPeD3k0JMMZXUCYx/npuM72XjwzfURSJWEnviH6kfoNCUZWBfY0w+uPV1vhJaReYLQmtZfEpq/m3ZswK9G4OTJDk+zjroGhEuuSTYmvHWJgyiyvPLGvA7T1LgkZLmYRsE5WgJbVzijknLzOhcB0Wpc2T4jEe/KQkwElZMxXds7cYGjGvDoRWYm0e/FDzbTIc99KEbuBFsS+eq2Cp4iRosEB6ytxz/RLoVUWqigiYhVXRRoTgyOKi9Xj66VEzdi3kcliLgA0UbmD693LSjWQxT2evCECnWmGXbsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 1:45=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 09/15/26 at 01:48pm, Baoquan He wrote:
> > On 09/11/26 at 09:45am, Shakeel Butt wrote:
> > > On Fri, Sep 11, 2026 at 09:06:29PM +0800, Baoquan He wrote:
> > > > On 09/10/26 at 09:39am, Shakeel Butt wrote:
> > > > > On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > > > > > Hi Nhat,
> > > > > >
> > > > > > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > > > > > .....snip...
> > > > >
> > > > > [...]
> > > > >
> > > > > > With VM_SPARSE, xswap's cluster access is exactly the plain-arr=
ay line the
> > > > > > rest of swap already uses:
> > > > > >
> > > > > >     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> > > > > >
> > > > > > no branch, no RCU discipline, no tear-down state machine, and n=
o NULL
> > > > > > return. So VM_SPARSE doesn't add complexity to close a gap; it =
lets the
> > > > > > cluster layer stay as simple as it already is, which is precise=
ly the
> > > > > > part later work (writeback, rmap lookup, memcg charging, THP) h=
as to sit
> > > > > > on.
> > > > > >
> > > > > > I'm not going to claim xswap wins on throughput. I measured it:
> > > > > > on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap a=
re all
> > > > > > within ~2-3% of each other, effectively identical.
> > > > >
> > > > > So the claim is VM_SPARSE is simpler than xarray based approach. =
I feel like
> > > > > we are discussing implementation details before deciding the desi=
gn and
> > > > > architecture. So, instead of VM_SPARSE vs xarray, let's discuss a=
nd decide the
> > > > > need for dynamic growth. Why we want dynamic growth upfront or ca=
n it be added
> > > > > later? Once we decide that then it will be very easy to pick an i=
mplementation
> > > > > that would take us there.
> > > >
> > > > Hi Shakeel,
> > > >
> > > > Thank you for joining the discussion and for taking the time to com=
ment.
> > >
> > > Hi Baoquan,
> > >
> > > I am mainly trying to facilitate the discussion but your use of LLM i=
s causing
> > > more confusion. LLM use is fine but please at least re-read before se=
nding that
> > > the sentences flow and makes sense.
> >
> > Sorry, my bad. I used LLM to find Nhat's words. But I did check it by
> > myself. I wrote most of them by myself. While at it ath the moment, my
> > logic could be unclear.
> >
> > As said, how swap_cluster_info[] is built is the foundation. Whatever
> > you do, you have to make swap_cluster_info[] ready, then you can do
> > writeback, rmap lookup, thp support, etc, on top of it.
> > swap_cluster_info[] is the basement, then you continue building 2nd
> > floor, 3rd floor, till a high building is done with things added. Nobod=
y
> > wants to claim he just need the high building, while no basement.
> >
> > Now, the foundation has been built with the lazy vmalloc, it can grow o=
n
> > demand. It keeps swap_cluster_info accessing as swap_cluster_info[],
> > a basic array semantics. And since we our target is to support a very
> > large swap device with an extendable logical space, grow on demand and
> > shrink becomes important. Now it is there.
>
> By the way, with my understanding, only grow is enough for xswap. You
> can reserve a huge space for it, while in fact you could only really use
> it within a small space. Then it's fine, grow the swap_cluster_info[] to

Yes. We should use incremental baby steps to make the merge easier to
digest. I think grow only is fine.

> the place it ever used, and it mostly will be used again. E.g on a small
> system with 10G RAM, we set si->max as 2x10=3D20G. In fact it could only
> reach 2G swap space. That's fine. 2G is the place we need, keep it. The
> left 18G is untouched and surely no swap_cluster_info[] built for it.

Agree.

> Anyway, Nhat strongly suggested shrink is necessary. I am wondering if
> there's really use case.

We can always add follow up patches if shrink proves useful; I really doubt=
 it.
We don't have to address all issues in one series. I actually advise
against lump too many patches into one series.

Chris

