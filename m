Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E4BCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 08:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 196808E0017; Tue, 21 Oct 2025 04:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 147508E0002; Tue, 21 Oct 2025 04:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0356F8E0017; Tue, 21 Oct 2025 04:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DFE308E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 04:45:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72EC0140392
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:45:15 +0000 (UTC)
X-FDA: 84021486990.20.086DC31
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id A9DA440008
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:45:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VcNxK2Jh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761036313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEc/XUPAfFsPjKe3axuLcNBbK/tw4kRowPq6sCBVSU0=;
	b=X2/B+UgL3w/BwCz+Q7ckm75Dy6s888bQULJXAAKiyLGGM0u/DdvO3fHfG/b4W+D/3mauki
	jaJNQhZVobNEqeOFHVbyWnMQeuXHoC9v5KZwaMRD6A9IL3JJxQR+aQnW1mlek+dcpZxvBS
	R1103pSl3XLO1t8F3E1AAFUAjiZmlsY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761036313; a=rsa-sha256;
	cv=none;
	b=2HHDGlCHhpD1LdvAfbmEhG72hnSzCag7ufHagZ/L8H40Lu9Z+VnBRTMhdJq00RjeUW+B4w
	vbNXO85xsO7IDj/4704ZKVNwbkvESLNmJcpcvL+7UyZ1+6htn5UQGQGoisxbqZmucFYyMU
	jPMnOkeT2FnepL656NLPZmzE1Azcdfc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VcNxK2Jh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63bea08a326so7292910a12.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761036312; x=1761641112; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tEc/XUPAfFsPjKe3axuLcNBbK/tw4kRowPq6sCBVSU0=;
        b=VcNxK2JhBexuvveZgFSDyYOChGkuKyWmj8SNyur9dPgY9RtceJ80HqU4AoLDTfwKa7
         vCEqBRr29pZokkS2UDUVYX4U31lqDHJy99gpSWfRjN3ArmtQPHvRSP0A1BQASZZHpTKy
         JYFTzzIpfr7Mf7QMvvnRPwr5yKjdd/LE56a7qRCyY0gBl/uuAq5Y5g9mZENy7KBYO52h
         GXsBm+eTmdZ6U2CqSJzatqYyLiu014S/Z8oK5D4lHQmS8ZhqXbxtW/IqA3+YC8KTk1cH
         e8MMNOdPqQ5eWHDkfYMIQK6wTflK8SjcU+t0rMs1w8Lj+FLlRrF89rrmG+0HE6yFsMuV
         Ituw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036312; x=1761641112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tEc/XUPAfFsPjKe3axuLcNBbK/tw4kRowPq6sCBVSU0=;
        b=iCUmDgO7Fp9yJ3U/HoJHTchqEXovWZcTyouhKjDMBq2jaVWMLvaxOOGNljowwAsB2C
         QrzTB/R9vFs4mOpq/0nvLztjDbXdQ/gJxFz9JGdX21wLxtCgZehVsbzOG/3z6rIawZD/
         6UPjtIZapLeY7qQaNA/Ns+A+xlHffW/uASMaOIvMwBavB8psXRvCaHWzoffcggbIDfXz
         Ppb17iG12n5cBp6QCMOimrsjbmDRjvbM4SXH9EpVyuwH5CIWHvhM4Z6UGhtTjP2d8Ixk
         D8M+E6nolYCdpNS/mdasyWJpU9KiJEZ3q+nu/79DHxEfWcVEhLpZpKkFYJmYpXFobwWh
         umxA==
X-Forwarded-Encrypted: i=1; AJvYcCWDy2eVNrnZbK8zG09Va0xwattEVbMqrKOru//HK9QieHnPcftDSdjgVJyD3OwJYRHrfXZ3Sp9r1A==@kvack.org
X-Gm-Message-State: AOJu0YydKF86pW/34VTFAjtnDFxHLJ8OgdAQXN/tWdMBkYgP6Z8DJswX
	zRMVRnrgFZ4SlDo13KMgCi43MS90X6bRGflbKfwMFdG3ejKUDE6LJizg8s815/a2dmLeDn8QyCA
	6PLigufPha/bjbKp5qxAoQ8eDvxgtXL0=
X-Gm-Gg: ASbGncuhc71fhWq0g/915sR9s/TGluPk/YRHmxLuRcHXBwRpD/OPsz5sxBieh4kzgpv
	/COnfEvwTOjkYkYKacIBsJTKVWMUvnbUR0PT/tLfHZDMUcN6q3syXtOf3X6nm/IqVTCohUrYhY+
	yv0ICj5yzhiXWZNLkK4hj2xh5qJ0AcB8dkJdL2iyyws/MaHKjsEW9TCp9zagSMXfYcTFGWlZJZd
	J4VFK4H46klnFxjLxyv8cBBvcvXx1obFelrexshcWCLon7nYQySrGj1OOfG
X-Google-Smtp-Source: AGHT+IGpNO2ZXaI/t+BJlY5E7XeayvBSN+u9HLM7rBt8OJlH05DE1Vd2yvSxHyFby5fD4qXdINnUHIZKxtpDi5wteKw=
X-Received: by 2002:a05:6402:2552:b0:63b:f59b:e607 with SMTP id
 4fb4d7f45d1cf-63c1f6364demr15217927a12.2.1761036311803; Tue, 21 Oct 2025
 01:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
 <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
 <CAMgjq7BD6SOgALj2jv2SVtNjWLJpT=1UhuaL=qxvDCMKUy68Hw@mail.gmail.com>
 <CACePvbVEGgtTqkMPqsf69C7qUD52yVcC56POed8Pdt674Pn68A@mail.gmail.com>
 <CACePvbWu0P+8Sv-sS7AnG+ESdnJdnFE_teC9NF9Rkn1HegQ9_Q@mail.gmail.com>
 <CAMgjq7BJcxGzrnr+EeO6_ZC7dAn0_WmWn8DX8gSPfyYiY4S3Ug@mail.gmail.com>
 <CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG593TFeOGV-oax++kWA@mail.gmail.com> <CACePvbWn1pAJg8xGfJFrWxpkJDakJA0GfgJc0W80EUYS6YhBAg@mail.gmail.com>
In-Reply-To: <CACePvbWn1pAJg8xGfJFrWxpkJDakJA0GfgJc0W80EUYS6YhBAg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 21 Oct 2025 16:44:35 +0800
X-Gm-Features: AS18NWDkIvCbn6oryOwYrnXEjtMybnk1XdF-2GkljB37F_uuXBAS4pUVPyIhdOE
Message-ID: <CAMgjq7DT13YwgFvGHPAn7ibb5E6XQDRf0P1XoFjz24ekF11C4g@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm, swap: do not perform synchronous discard during allocation
To: Chris Li <chrisl@kernel.org>
Cc: YoungJun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A9DA440008
X-Rspamd-Server: rspam02
X-Stat-Signature: tjpg7oue57tmix3yxuwy8r6mgjqbr4u4
X-HE-Tag: 1761036313-449139
X-HE-Meta: U2FsdGVkX183lope8yzccACbBiad0dMvB96qxOy1XpS9dsIcrVMnZ/gDYkAO+UFgeBCEqLb8RbIWKWdT1WPgp0xXaNi/pMVjiPRoff5vu879g7+Iq7F+jPxl+zF39K/yZktA7VEbLddTB+RG7OoE0yhsYEYX1g0PkIVnB5URo7bV9V2A+At7SCUvihG9h1j/EnWnvb1AxYkzSDwNPyLQkB5g3hNb1Z/dgVX0m+eJ5F8/QFzFgx7eSdshd1fCtyumF71MX/dfyH7dO4UzBaKWe6xsSsUJNStxoQIOubCDPBenHt3CSi538R3VkRDqe5zwOpi8+yUyQrVVhfNCaG0zHwnjYm0GHkxW6rrgmCNSeYfP15ushCIFnW5wsRhb1MjzDo4tRhaMGfvpg9C/UfCDjYUXu20NBLOEq32Y7dlRl34olOgjxwrZ++vuP9Fhv9/MBtKoE+WgKzms+KsVxpzw7uwqo+F+xMfgtftTk3P1PwZ5Mt4JXisJZHq0WlRfN7oN8MtKGBer1lttPOwEiRXfAHZElpHQnsJJJnwulDDcgTfwFF3bCpX6mfpnrdbGanp/swT/uLOoZ+ZW0lbaPW3J21dPa2hT0CczYGaSaPxp+17hKm7i9v/0FjoOM29+sr1tjWpkUGTALMNt7kFPBX5C3PCRrY3zvTI6syQ86J8DaSfD4YFelUqN2upqFCIyco1+0cCNkyl8Asr7GJQxgvI6Qmir4QmsiQbjtZOTvCx9LZuKZOIBoUSkprnPTldYwQ9kzLA1bTMukWcQ5eGW8RXIS33YniW22UXLikMw67grtfJhGFSTyrJUCC53bbtHQKyKPfET/U30mqKm1iZrrPxJekh5C1fucfHTzc6aDGmz8jCOD8omZv0Tz2fUqIEl9F5IHPVwoEnyRxN92LogQZnsOOf+mWGvaJiImDqNnDN8gmgirdbymJVIGJAnPWiqody/jy259zNxlOqrEXi+wzD
 ASH9z26I
 +LOXR1VPJF3BB1vQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 3:05=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Wed, Oct 15, 2025 at 9:46=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Wed, Oct 15, 2025 at 2:24=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > On Wed, Oct 15, 2025 at 12:00=E2=80=AFPM Chris Li <chrisl@kernel.org>=
 wrote:
> > > >
> > > > On Tue, Oct 14, 2025 at 2:27=E2=80=AFPM Chris Li <chrisl@kernel.org=
> wrote:
> > > > >
> > > > > On Sun, Oct 12, 2025 at 9:49=E2=80=AFAM Kairui Song <ryncsn@gmail=
.com> wrote:
> > > > > > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > > > > > index cb2392ed8e0e..0d1924f6f495 100644
> > > > > > > > --- a/mm/swapfile.c
> > > > > > > > +++ b/mm/swapfile.c
> > > > > > > > @@ -1101,13 +1101,6 @@ static unsigned long cluster_alloc_s=
wap_entry(struct swap_info_struct *si, int o
> > > > > > > >                         goto done;
> > > > > > > >         }
> > > > > > > >
> > > > > > > > -       /*
> > > > > > > > -        * We don't have free cluster but have some cluster=
s in discarding,
> > > > > > > > -        * do discard now and reclaim them.
> > > > > > > > -        */
> > > > > > > > -       if ((si->flags & SWP_PAGE_DISCARD) && swap_do_sched=
uled_discard(si))
> > > > > > > > -               goto new_cluster;
> > > > > > >
> > > > > > > Assume you follow my suggestion.
> > > > > > > Change this to some function to detect if there is a pending =
discard
> > > > > > > on this device. Return to the caller indicating that you need=
 a
> > > > > > > discard for this device that has a pending discard.
> > > > > > > Add an output argument to indicate the discard device "discar=
d" if needed.
> > > > > >
> > > > > > The problem I just realized is that, if we just bail out here, =
we are
> > > > > > forbidding order 0 to steal if there is any discarding cluster.=
 We
> > > > > > just return here to let the caller handle the discard outside
> > > > > > the lock.
> > > > >
> > > > > Oh, yes, there might be a bit of change in behavior. However I ca=
n't
> > > > > see it is such a bad thing if we wait for the pending discard to
> > > > > complete before stealing and fragmenting the existing folio list.=
 We
> > > > > will have less fragments compared to the original result. Again, =
my
> > > > > point is not that we always keep 100% the old behavior, then ther=
e is
> > > > > no room for improvement.
> > > > >
> > > > > My point is that, are we doing the best we can in that situation,
> > > > > regardless how unlikely it is.
> > > > >
> > > > > >
> > > > > > It may just discard the cluster just fine, then retry from free=
 clusters.
> > > > > > Then everything is fine, that's the easy part.
> > > > >
> > > > > Ack.
> > > > >
> > > > > > But it might also fail, and interestingly, in the failure case =
we need
> > > > >
> > > > > Can you spell out the failure case you have in mind? Do you mean =
the
> > > > > discard did happen but another thread stole "the recently discard=
ed
> > > > > then became free cluster"?
> > > > >
> > > > > Anyway, in such a case, the swap allocator should continue and fi=
nd
> > > > > out we don't have things to discard now, it will continue to the
> > > > > "steal from other order > 0 list".
> > > > >
> > > > > > to try again as well. It might fail with a race with another di=
scard,
> > > > > > in that case order 0 steal is still feasible. Or it fail with
> > > > > > get_swap_device_info (we have to release the device to return h=
ere),
> > > > > > in that case we should go back to the plist and try other devic=
es.
> > > > >
> > > > > When stealing from the other order >0 list failed, we should try
> > > > > another device in the plist.
> > > > >
> > > > > >
> > > > > > This is doable but seems kind of fragile, we'll have something =
like
> > > > > > this in the folio_alloc_swap function:
> > > > > >
> > > > > > local_lock(&percpu_swap_cluster.lock);
> > > > > > if (!swap_alloc_fast(&entry, order))
> > > > > >     swap_alloc_slow(&entry, order, &discard_si);
> > > > > > local_unlock(&percpu_swap_cluster.lock);
> > > > > >
> > > > > > +if (discard_si) {
> > > > >
> > > > > I feel the discard logic should be inside the swap_alloc_slow().
> > > > > There is a  plist_for_each_entry_safe(), inside that loop to do t=
he
> > > > > discard and retry().
> > > > > If I previously suggested it change in here, sorry I have changed=
 my
> > > > > mind after reasoning the code a bit more.
> > > >
> > > > Actually now I have given it a bit more thought, one thing I realiz=
ed
> > > > is that you might need to hold the percpu_swap_cluster lock all the
> > > > time during allocation. That might force you to do the release lock
> > > > and discard in the current position.
> > > >
> > > > If that is the case, then just making the small change in your patc=
h
> > > > to allow hold waiting to discard before trying the fragmentation li=
st
> > > > might be good enough.
> > > >
> > > > Chris
> > > >
> > >
> > > Thanks, I was composing a reply on this and just saw your new comment=
.
> > > I agree with this.
> >
> > Hmm, it turns out modifying V1 to handle non-order 0 allocation
> > failure also has some minor issues. Every mTHP SWAP allocation failure
> > will have a slight higher overhead due to the discard check. V1 is
> > fine since it only checks discard for order 0, and order 0 alloc
> > failure is uncommon and usually means OOM already.
> >
> > I'm not saying V1 is the final solution, but I think maybe we can just
> > keep V1 as it is? That's easier for a stable backport too, and this is
>
> I am fine with that, assuming you need to adjust the presentation to
> push V1 as hotfix. I can ack your newer  patch to adjust the
> presentation.

Thanks, I'll update it then.

> > doing far better than what it was like. The sync discard was added in
> > 2013 and the later added percpu cluster at the same year never treated
> > it carefully. And the discard during allocation after recent swap
> > allocator rework has been kind of broken for a while.
> >
> > To optimize it further in a clean way, we have to reverse the
> > allocator's handling order of the plist and fast / slow path. Current
> > order is local_lock -> fast -> slow (plist).
>
> I like that. I think that is the eventual way to go. I want to see how
> it integrates with the swap.tiers patches. If you let me pick, I would
> go straight with this one for 6.19.
>
> >
> > We can walk the plist first, then do the fast / slow path: plist (or
> > maybe something faster than plist but handles the priority) ->
> > local_lock -> fast -> slow (bonus: this is more friendly to RT kernels
> > too I think). That way we don't need to rewalk the plist after
> > releasing the local_lock and save a lot of trouble. I remember I
> > discussed with Youngjun on this sometime ago in the mail list, I know
> > things have changed a lot but some ideas seems are still similar. I
> > think his series is moving the percpu cluster into each device (si),
> > we can also move the local_lock there, which is just what I'm talking
> > about here.
>
> Ack. We will need to see both patches to figure out how to integrate
> them together. Right now we have two moving parts. More to the point
> that we get the eventual patch sooner.

BTW I found there are some minor cleanups needed, mostly trivial, I'll
include them in the next update I think.

