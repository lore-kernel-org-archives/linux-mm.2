Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4298ACCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 06:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88BF98E0006; Tue, 21 Oct 2025 02:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83CA08E0002; Tue, 21 Oct 2025 02:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704748E0006; Tue, 21 Oct 2025 02:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4948E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:48:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 001B758AAF
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:48:35 +0000 (UTC)
X-FDA: 84021193032.28.2CBB0CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 13C7A180007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:48:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lc9pCGe4;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761029314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huVkyxFpCB69gJ+klCkiZ2S/86uNPLmp0mdGVNQt13Q=;
	b=8jKpr8W4fGXkHJ1bZpJTifr43qNRJS4UehUd4ygck5JRvkaSN8EqYOxhUz2N8chW66qZyQ
	qbcwBSBngE5Y4Je+28d6tiLlQa8IQIFe4E9MVi5zmy/7oSmoqKKdj0ZHlf/qUUUrIzurjC
	mBJ1/fhvhzQ27eUUen346wn0QJyWpTg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lc9pCGe4;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761029314; a=rsa-sha256;
	cv=none;
	b=1XImU/hwSSvebCusVkOzsKBk0UgJX68+sA79WFW1MDFpjjPwt2v3Sjwcf6CqTY43NC76lp
	MEYVG6unTq8U7Q3dXM1nC5gKk/spqHxk71v9c9BQ/UC9PPuz7moAzJpHLcHarCR3T2wPtw
	zVutoz6G9LRhfDOeOI/M71gdQAfckfY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AA4A6036E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B63C116C6
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761029312;
	bh=Yao5CLBIZBpqI8yZPYhEq0pLUsEI2cplrdc+D5Sg0x0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Lc9pCGe4de/NwZfnpRTSrjSrKhtCdrPT4YYHAJFqrg7l3b+HCjOL2xUTsC+YZni87
	 XlfP8OpuLa6fhm8tWD1oVyg2z+yr8Takyigtfu44Vo+xaCE1JuSCVugB1GfQMZ1r7R
	 o3Q36IPGOLcbhaubcq90aAIXwiyl0dgPctB8YjK0U5nDiB8Qh5Fc/o5yhI2T3BvI6j
	 rQmhMaMkaNCNncYuFTkINepfNHB+CLc4F9hT+nGESeNP1MqRqDRns7t5KpJFJ2N0G8
	 Gi148MiT4/+DSp2DP8twIsy1akWq/dVe+HNPzFB0F88M6XR9GOYXnuS3FX+JIrvwUD
	 eXapKOM/0+g5w==
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-78485c4146bso27859257b3.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 23:48:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXHb53gtGLkC8XuBdsjOtHlq1iH/47jbtJCaKu9R0+TRFxEzdy4DLr+JnifgIbRksawwKMi0FuYHg==@kvack.org
X-Gm-Message-State: AOJu0YzUbepUD7X43yT3UeDwKlfF45bVgj2vCBsPIPUBGKm6EcfJuVaY
	shzIUkjtdytkunmL2s57CsFimh2BeccAjTTnpYZPi9O9XNuubH5z0r4GzdNP+bYwSc85OY856qT
	inKde0VEiR1vtMuyKQPc85yxdZ6r0pJfRO70+xNPvDQ==
X-Google-Smtp-Source: AGHT+IEKwgU/k6+a6m9j5wLqPHqWi37Ymmn/fXH4mZwMQ6tpYpjsC1ZwqJENF/v+P8dGntZXlSsHbAcNq1qNWQU/s6E=
X-Received: by 2002:a53:edc2:0:b0:63c:f5a6:f2de with SMTP id
 956f58d0204a3-63e1626c69amr9740357d50.64.1761029312099; Mon, 20 Oct 2025
 23:48:32 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
 <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
 <CAMgjq7BD6SOgALj2jv2SVtNjWLJpT=1UhuaL=qxvDCMKUy68Hw@mail.gmail.com>
 <CACePvbVEGgtTqkMPqsf69C7qUD52yVcC56POed8Pdt674Pn68A@mail.gmail.com>
 <CACePvbWu0P+8Sv-sS7AnG+ESdnJdnFE_teC9NF9Rkn1HegQ9_Q@mail.gmail.com>
 <CAMgjq7BJcxGzrnr+EeO6_ZC7dAn0_WmWn8DX8gSPfyYiY4S3Ug@mail.gmail.com> <CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG593TFeOGV-oax++kWA@mail.gmail.com>
In-Reply-To: <CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG593TFeOGV-oax++kWA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 20 Oct 2025 23:48:20 -0700
X-Gmail-Original-Message-ID: <CACePvbWn1pAJg8xGfJFrWxpkJDakJA0GfgJc0W80EUYS6YhBAg@mail.gmail.com>
X-Gm-Features: AS18NWDK_5ydoR83ck7SoROtH9BUHSuIRVHk1u1H4KWAOIdgu6-tq2E-NYuReAE
Message-ID: <CACePvbWn1pAJg8xGfJFrWxpkJDakJA0GfgJc0W80EUYS6YhBAg@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm, swap: do not perform synchronous discard during allocation
To: Kairui Song <ryncsn@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 13C7A180007
X-Stat-Signature: bjfuxwwuykxfq7w15w11o59m1yafdzgq
X-Rspam-User: 
X-HE-Tag: 1761029313-608665
X-HE-Meta: U2FsdGVkX1/matQfuum8QotmgvRiNZKiuzQyWb0NFuDUYc76x86tn4GO5fzGF9cv0l4I2HsljiE3QwP3Apd3VD35iMJ+rfz1m+CUAc2Sw2W+9gu4jdpLK8skr1T/YXrJ8fMcDrINmWHRRPlHLdQi4EpJDH1/x444hwxsJ8144wTqJw9smqUldC8yB4JGDNfJ7/CxuvBytMWp6ngrSH66Mn552k3w3bd6ag5KOx8oQTjH8YzoZUxxJm+yXK1m/heXN2H/JT/1VOs193maEbXgrhgsdKqpQjVOhJ/UNlg/dIrpsrwamH5uAzQz9M/SJ7V7iAqAe6jn9hGGxys2CWvxAChmzTyP32GtWCsiONEpo+FX/K9hEvrvZVngIfFQpfcBa59GukFT1ynB74i+BQxIw7WalWLMFzzIyCe+FF1dyl+r3jycYR77/M/J+wLB6WOfTXWWNRk4kzcbHBsB3KC6952DIeDJEhQEH/N7C3IONZir/ZRu19dcbGP1mW0LsqZkFrFgI9BcngRR3ZGWffLUc8P/Mei+9ForD5FTZKSKKgkPxYkBp/YWPEkNBffqbo48AOtd7BPKcG6JCURFRofyTyv9Z4WsG/B9k3MnS7lNX60kMPLPIfXkNA7CIvmbOljxf0xUkf29rASL3525nrVLBmBzStLoQwYgw0QvfxqMuWI8DI5kihZiq4s67jMPgZ1Yx8FMUIMIGCJwo4PDFAhWVdtZUttUN5W1lOomesGeiMuLNdnNkgt73nyBjiy+Z6geFZN0NHjdzc3RNzark7oPRwR2DOLHUUE892bvUFiTAJPBpNqd49cWcWNdIC0Crd++3Mmej7YxkpH7HdCfEiLgnpC5tDDY0fZrTSV8uBD8ZRqQDWndsu357p6FDISHZSBEg2I9m6TwsJF2sI7kwGnAU7qkUVxfkw3/rvOB2nqkGpuAYI6kUJjAiLY2/WHhxeVf4875I9IXgkieoHNv6bt
 yK0mN/ba
 C0DlriOGZReOlgIFtR8G02z6Et17w1Sfxk0+rljMqnhjSbDV9L8u1ILI82MBoGPqNVTJ0yKwsZ2kLCeYrBDvzjRNYrv8M2iPF5kxK266BUU8qh4k50ov5xHTO1kjeIuWwB8VW4NOgtE7LRjOEfCXJrq0N062v0zpEp6dI71qIpecAfvjM+hpznGWSed52DBkA8R7DCyM9DhPrkKT81QVFGHZkRMY7S8Z5Mm5nHHKDGSftEPpjSapt1Fdv77tHx9zStCiSs8NhgKmEuH+9PYZf2onMatCNFKjUaY36KtFeaZXhMOlD4U7yIM+ZhrwqNo4TPSE4ZZT0MpkNbfQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 9:46=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Wed, Oct 15, 2025 at 2:24=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Wed, Oct 15, 2025 at 12:00=E2=80=AFPM Chris Li <chrisl@kernel.org> w=
rote:
> > >
> > > On Tue, Oct 14, 2025 at 2:27=E2=80=AFPM Chris Li <chrisl@kernel.org> =
wrote:
> > > >
> > > > On Sun, Oct 12, 2025 at 9:49=E2=80=AFAM Kairui Song <ryncsn@gmail.c=
om> wrote:
> > > > > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > > > > index cb2392ed8e0e..0d1924f6f495 100644
> > > > > > > --- a/mm/swapfile.c
> > > > > > > +++ b/mm/swapfile.c
> > > > > > > @@ -1101,13 +1101,6 @@ static unsigned long cluster_alloc_swa=
p_entry(struct swap_info_struct *si, int o
> > > > > > >                         goto done;
> > > > > > >         }
> > > > > > >
> > > > > > > -       /*
> > > > > > > -        * We don't have free cluster but have some clusters =
in discarding,
> > > > > > > -        * do discard now and reclaim them.
> > > > > > > -        */
> > > > > > > -       if ((si->flags & SWP_PAGE_DISCARD) && swap_do_schedul=
ed_discard(si))
> > > > > > > -               goto new_cluster;
> > > > > >
> > > > > > Assume you follow my suggestion.
> > > > > > Change this to some function to detect if there is a pending di=
scard
> > > > > > on this device. Return to the caller indicating that you need a
> > > > > > discard for this device that has a pending discard.
> > > > > > Add an output argument to indicate the discard device "discard"=
 if needed.
> > > > >
> > > > > The problem I just realized is that, if we just bail out here, we=
 are
> > > > > forbidding order 0 to steal if there is any discarding cluster. W=
e
> > > > > just return here to let the caller handle the discard outside
> > > > > the lock.
> > > >
> > > > Oh, yes, there might be a bit of change in behavior. However I can'=
t
> > > > see it is such a bad thing if we wait for the pending discard to
> > > > complete before stealing and fragmenting the existing folio list. W=
e
> > > > will have less fragments compared to the original result. Again, my
> > > > point is not that we always keep 100% the old behavior, then there =
is
> > > > no room for improvement.
> > > >
> > > > My point is that, are we doing the best we can in that situation,
> > > > regardless how unlikely it is.
> > > >
> > > > >
> > > > > It may just discard the cluster just fine, then retry from free c=
lusters.
> > > > > Then everything is fine, that's the easy part.
> > > >
> > > > Ack.
> > > >
> > > > > But it might also fail, and interestingly, in the failure case we=
 need
> > > >
> > > > Can you spell out the failure case you have in mind? Do you mean th=
e
> > > > discard did happen but another thread stole "the recently discarded
> > > > then became free cluster"?
> > > >
> > > > Anyway, in such a case, the swap allocator should continue and find
> > > > out we don't have things to discard now, it will continue to the
> > > > "steal from other order > 0 list".
> > > >
> > > > > to try again as well. It might fail with a race with another disc=
ard,
> > > > > in that case order 0 steal is still feasible. Or it fail with
> > > > > get_swap_device_info (we have to release the device to return her=
e),
> > > > > in that case we should go back to the plist and try other devices=
.
> > > >
> > > > When stealing from the other order >0 list failed, we should try
> > > > another device in the plist.
> > > >
> > > > >
> > > > > This is doable but seems kind of fragile, we'll have something li=
ke
> > > > > this in the folio_alloc_swap function:
> > > > >
> > > > > local_lock(&percpu_swap_cluster.lock);
> > > > > if (!swap_alloc_fast(&entry, order))
> > > > >     swap_alloc_slow(&entry, order, &discard_si);
> > > > > local_unlock(&percpu_swap_cluster.lock);
> > > > >
> > > > > +if (discard_si) {
> > > >
> > > > I feel the discard logic should be inside the swap_alloc_slow().
> > > > There is a  plist_for_each_entry_safe(), inside that loop to do the
> > > > discard and retry().
> > > > If I previously suggested it change in here, sorry I have changed m=
y
> > > > mind after reasoning the code a bit more.
> > >
> > > Actually now I have given it a bit more thought, one thing I realized
> > > is that you might need to hold the percpu_swap_cluster lock all the
> > > time during allocation. That might force you to do the release lock
> > > and discard in the current position.
> > >
> > > If that is the case, then just making the small change in your patch
> > > to allow hold waiting to discard before trying the fragmentation list
> > > might be good enough.
> > >
> > > Chris
> > >
> >
> > Thanks, I was composing a reply on this and just saw your new comment.
> > I agree with this.
>
> Hmm, it turns out modifying V1 to handle non-order 0 allocation
> failure also has some minor issues. Every mTHP SWAP allocation failure
> will have a slight higher overhead due to the discard check. V1 is
> fine since it only checks discard for order 0, and order 0 alloc
> failure is uncommon and usually means OOM already.
>
> I'm not saying V1 is the final solution, but I think maybe we can just
> keep V1 as it is? That's easier for a stable backport too, and this is

I am fine with that, assuming you need to adjust the presentation to
push V1 as hotfix. I can ack your newer  patch to adjust the
presentation.

> doing far better than what it was like. The sync discard was added in
> 2013 and the later added percpu cluster at the same year never treated
> it carefully. And the discard during allocation after recent swap
> allocator rework has been kind of broken for a while.
>
> To optimize it further in a clean way, we have to reverse the
> allocator's handling order of the plist and fast / slow path. Current
> order is local_lock -> fast -> slow (plist).

I like that. I think that is the eventual way to go. I want to see how
it integrates with the swap.tiers patches. If you let me pick, I would
go straight with this one for 6.19.

>
> We can walk the plist first, then do the fast / slow path: plist (or
> maybe something faster than plist but handles the priority) ->
> local_lock -> fast -> slow (bonus: this is more friendly to RT kernels
> too I think). That way we don't need to rewalk the plist after
> releasing the local_lock and save a lot of trouble. I remember I
> discussed with Youngjun on this sometime ago in the mail list, I know
> things have changed a lot but some ideas seems are still similar. I
> think his series is moving the percpu cluster into each device (si),
> we can also move the local_lock there, which is just what I'm talking
> about here.

Ack. We will need to see both patches to figure out how to integrate
them together. Right now we have two moving parts. More to the point
that we get the eventual patch sooner.

Chris

