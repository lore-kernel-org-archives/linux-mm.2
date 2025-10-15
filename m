Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 599FACCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 16:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30668E0044; Wed, 15 Oct 2025 12:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E19E8E0005; Wed, 15 Oct 2025 12:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CFAF8E0044; Wed, 15 Oct 2025 12:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79A278E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:46:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 267FB118BD1
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:46:33 +0000 (UTC)
X-FDA: 84000927066.14.672ADCD
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 45E921C000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:46:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=io4cA57o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760546791; a=rsa-sha256;
	cv=none;
	b=23UWNbv0haTMC55qROG7SzlgtC28sNsT/jONpiwcrxTE674l7zqL+LreiU14ZsAzXzodKE
	ot+e+zWZmFPtV59LqmsttRKBm/HGG8Ju1QPa28qZnKgFWY3iz8PK4fQpKm9jKWTonX7YqA
	4S6FsvS4cHbEcW7VoNFtyHm+XWY+OrQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=io4cA57o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760546791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=je0F7nfACXJpbmYznXu1sTtkMbdp1GFHRjbs99COgfU=;
	b=XisB3ka6fngS/ShjffUrAzSj+CazlZ47jCJgv5850uRZDrHCMslc45hV3Y1Mcp/I0S7uaC
	V8Zg7vbLcI+zsDQ/k1M4P3CQTUW9cFpVBNFRtVZk/MX35C8eSiK23iA5eQ7HUy+he7nXKE
	c02E53UktG59mFH09qIKrNdTS4J9c64=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b48d8deafaeso1401830966b.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760546790; x=1761151590; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=je0F7nfACXJpbmYznXu1sTtkMbdp1GFHRjbs99COgfU=;
        b=io4cA57oOTqPCHT8QwCEUOjz5KNDgtTZEmM7s6K1ii+FdNHATvVhJzU6exBy0d90SH
         wTMSQgdvseFLI5OH0Uo2sjCTYkI2gHPTWhMEquiHGz1h5+IW78aQffgqeoGJdfazAVAE
         UfJY0Jcsd1EwFuNX9FeaOtoGiFnrgEBTis+4PlFq9lIWWZtHYAehPqh98E/VxRbLaWsf
         PtsuS4U0oK4V2fcwqPBDnNb0K2XPhezwzLc8tHMmtj62xunZ0kqpd+UROxlP6uj61NaT
         R63uf62Dr5k6dLK3kWBZLxPntDYRAVXwQQ+Ehu7WQagRwWYy1pmemj7TDnC53WrtQonP
         dxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760546790; x=1761151590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=je0F7nfACXJpbmYznXu1sTtkMbdp1GFHRjbs99COgfU=;
        b=cMf+ldC8eA3u8ViVYxVAM07Gnb1OoWLN9O8yl+GiQEzsdgDqUENUdo/P0JzrKRlyLm
         Ng34hYJ4WMG3xCW8vciMhxG/mWh2dqJpFTU025ohg+r9XahDa9U69OwcX5sihzdLM5qp
         8GoPa8S5AChDMlBxrQWSAhVMtll50r/Be/oF7psdEqZcoS+aIyi/48V6PRh5xFvrXAse
         rhV+6mBZdF5FXB3WNTq3q42s4lmabBn2JKpJ92q6zI9KY5MEJs/K9ykv6hWXSr1wC9fO
         5n8632ZuthL69qLeWLOSregEZzVQnWH6RFDyK5KiDPzr1E2XfFZ3sEj/9UyF4EUu6Hvm
         W9vw==
X-Gm-Message-State: AOJu0YzxX2OvAKoPnp7VQR6Om+Ivx7BWYZue4inNVqvfTu3TI/46ihEA
	h/m3K2U9lveo9kmp4nf5XSsqsqdfdnANWxSp69g8KzgGlDeOQXGxN/SyQrehXuOPDQ/nDNs/byx
	y+3tXLtpYTmLzX5xmFhG1qLykCXc6w8U=
X-Gm-Gg: ASbGncs4s8Y2n7SFu5kxD9yQI9OqpUykiSbqaqu7pmVwrfhVRULkHA9MtJBHaCqvx6I
	VcfYxzUEs9awB7hw7Fx6SZDXay8EzFLQHwPwT8Tmz6PhK6zONNxvAK49MA1qvORScXg7tDZwlG+
	NAuzJfsRecVlSZm3OuR4UyQcxXRxKO8PfvCpB7p6EKSeGk+up9Tiax7Ih1jI46Fudm/yROel2dv
	CZtEhr7qqsueCuH3i8kHPkHqA==
X-Google-Smtp-Source: AGHT+IG6mst+qVI0JUb5puzOWQMXSlytfQLY39/u3UCs+EtF1W8BL9hwi0uE2sSR4jvdT6ZVos7cZl+TB59DjLKsk2o=
X-Received: by 2002:a17:907:980f:b0:b42:9840:eac5 with SMTP id
 a640c23a62f3a-b50acb0e645mr3174683566b.61.1760546789493; Wed, 15 Oct 2025
 09:46:29 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
 <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
 <CAMgjq7BD6SOgALj2jv2SVtNjWLJpT=1UhuaL=qxvDCMKUy68Hw@mail.gmail.com>
 <CACePvbVEGgtTqkMPqsf69C7qUD52yVcC56POed8Pdt674Pn68A@mail.gmail.com>
 <CACePvbWu0P+8Sv-sS7AnG+ESdnJdnFE_teC9NF9Rkn1HegQ9_Q@mail.gmail.com> <CAMgjq7BJcxGzrnr+EeO6_ZC7dAn0_WmWn8DX8gSPfyYiY4S3Ug@mail.gmail.com>
In-Reply-To: <CAMgjq7BJcxGzrnr+EeO6_ZC7dAn0_WmWn8DX8gSPfyYiY4S3Ug@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 16 Oct 2025 00:45:52 +0800
X-Gm-Features: AS18NWBxPhombhPrk2cbIiwnOB7SZCpnaOyVcUMkzwhYwQ_vXmWp_OG4dB0nf-M
Message-ID: <CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG593TFeOGV-oax++kWA@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm, swap: do not perform synchronous discard during allocation
To: Chris Li <chrisl@kernel.org>, YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fitk31w1bdaudb956uhdjgp1t4rbw47h
X-Rspamd-Queue-Id: 45E921C000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760546791-894270
X-HE-Meta: U2FsdGVkX19CjpPvxU1fWhA2yhKNf1VIv9v0aWBsA1let4jJaczrz5UrHTqhRTmr0aKfpVdVjlR9aGba/pyk9tSjtUSibclDXL9xVoe+PXFtCVVY+EL33qUZVaw5Di6cuFg1iLp8dZU/MxZ5VPi7EJ56tEb8+7bLAc6VmmEXCUZfGadHKVq/soeK9Fnev1oQsWkbYEgzki4HPUdm9ocjBGDA0dHR9Oo5knvHiOHgX7vm1UIBhD1PCAOuSaRqkVGA47WItt3j2ymzy1mI9QCaH+Cq+tuF5OD3YEsOIEB/If0cnl2jw6bTJDpNV3G067uxNWr21wREqUPGVvtFGYCMqht5OXzI4gEW+u3fAiPYEaSnywiXlLVhMnf1kuKNAU5dqesh8UILgsFYgmlSFxB3gxOGXJ/i+vyfmQmKDBy7Cbhs7TOu3p1IPSYfc/FdUb7SZ/joF9X2zf97AJVUI1sMXOy373qvNC+vK4jb+r2UTjFSDBhwDh7g0B5sdjlHAZTItStjlZ3UhBXN0fnEgcoGR6uqB32hEY0ENW7fTy1vs/w3nYzVzsutfvjTAarjCFf65wIjKeYg71oXfgRQSO1I3n3qUzQyNHHfVZoDo7zlJgA6bqlLvy0l6OnK8M6YQ0FG76X6gbXCCSHzU3En5Dv/8VdSxwOmdLDIZN0idl+gaWGnNFpU3rm7VKqZ2e/8TwrmoCC97/0HC3iuG/RvttsANwaO0rtr0qRUNAk97oI1iWSHC+tbqgTmALr86q9pnHb2aLGnHA5YaCBblqnUxxJaGW6c04ogCJBL4Ls07/R4B6oGoKuIgZvPfvXl+yJmxlleUt2NJxg6sIeWTj2qMGjhUEOcYUsusyV2PGuH3vvh49cu1u2HBK+qRee/rPaYtdPqh9pSmu1/mgmaHhtxmXJBb657brssJoBAiHiCmNAHas2c6GMnVLwxT2hlcfSuw0p3y37c/i9TRoh4BFMLFXC
 CSkR4Xpl
 +brsVcPGZvToIocWvTFzLtSzvlM8JZPptiSCGjrDLf/yHyktD/kcNU9uIh6p19xbhUXAhIEDjoVoFGXasfMZ8fPIPY7qx5QwIKqPvqPeKXJ2dsai7gvom1SXQ7eMK/NAqZJsMYmUQIsVdBnMChrqjHXAr6kTw+HM45uHRCubbNlF4z5J4H+mdQXvTrwCkO/FklM12a72NAdvdj1YCv16jjBBkqpvmw6IPvHu4ufoMg4QemHjIhLH+jQiWLB+UL5IjpG8rWMTIS2nbx1Pu5aqqufrKd0f+8Jt556zOQUggE7VIajd6psFr+y3YQfUw9IxTeTJYTTIixMh8M/jVbAHjjuKGY+Y62j2X8z5x+xen5dUA3m7fuLbCs1ATpeOTtwkHJYS7dtNpMtJCIes9LgmgnVZIEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 2:24=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Wed, Oct 15, 2025 at 12:00=E2=80=AFPM Chris Li <chrisl@kernel.org> wro=
te:
> >
> > On Tue, Oct 14, 2025 at 2:27=E2=80=AFPM Chris Li <chrisl@kernel.org> wr=
ote:
> > >
> > > On Sun, Oct 12, 2025 at 9:49=E2=80=AFAM Kairui Song <ryncsn@gmail.com=
> wrote:
> > > > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > > > index cb2392ed8e0e..0d1924f6f495 100644
> > > > > > --- a/mm/swapfile.c
> > > > > > +++ b/mm/swapfile.c
> > > > > > @@ -1101,13 +1101,6 @@ static unsigned long cluster_alloc_swap_=
entry(struct swap_info_struct *si, int o
> > > > > >                         goto done;
> > > > > >         }
> > > > > >
> > > > > > -       /*
> > > > > > -        * We don't have free cluster but have some clusters in=
 discarding,
> > > > > > -        * do discard now and reclaim them.
> > > > > > -        */
> > > > > > -       if ((si->flags & SWP_PAGE_DISCARD) && swap_do_scheduled=
_discard(si))
> > > > > > -               goto new_cluster;
> > > > >
> > > > > Assume you follow my suggestion.
> > > > > Change this to some function to detect if there is a pending disc=
ard
> > > > > on this device. Return to the caller indicating that you need a
> > > > > discard for this device that has a pending discard.
> > > > > Add an output argument to indicate the discard device "discard" i=
f needed.
> > > >
> > > > The problem I just realized is that, if we just bail out here, we a=
re
> > > > forbidding order 0 to steal if there is any discarding cluster. We
> > > > just return here to let the caller handle the discard outside
> > > > the lock.
> > >
> > > Oh, yes, there might be a bit of change in behavior. However I can't
> > > see it is such a bad thing if we wait for the pending discard to
> > > complete before stealing and fragmenting the existing folio list. We
> > > will have less fragments compared to the original result. Again, my
> > > point is not that we always keep 100% the old behavior, then there is
> > > no room for improvement.
> > >
> > > My point is that, are we doing the best we can in that situation,
> > > regardless how unlikely it is.
> > >
> > > >
> > > > It may just discard the cluster just fine, then retry from free clu=
sters.
> > > > Then everything is fine, that's the easy part.
> > >
> > > Ack.
> > >
> > > > But it might also fail, and interestingly, in the failure case we n=
eed
> > >
> > > Can you spell out the failure case you have in mind? Do you mean the
> > > discard did happen but another thread stole "the recently discarded
> > > then became free cluster"?
> > >
> > > Anyway, in such a case, the swap allocator should continue and find
> > > out we don't have things to discard now, it will continue to the
> > > "steal from other order > 0 list".
> > >
> > > > to try again as well. It might fail with a race with another discar=
d,
> > > > in that case order 0 steal is still feasible. Or it fail with
> > > > get_swap_device_info (we have to release the device to return here)=
,
> > > > in that case we should go back to the plist and try other devices.
> > >
> > > When stealing from the other order >0 list failed, we should try
> > > another device in the plist.
> > >
> > > >
> > > > This is doable but seems kind of fragile, we'll have something like
> > > > this in the folio_alloc_swap function:
> > > >
> > > > local_lock(&percpu_swap_cluster.lock);
> > > > if (!swap_alloc_fast(&entry, order))
> > > >     swap_alloc_slow(&entry, order, &discard_si);
> > > > local_unlock(&percpu_swap_cluster.lock);
> > > >
> > > > +if (discard_si) {
> > >
> > > I feel the discard logic should be inside the swap_alloc_slow().
> > > There is a  plist_for_each_entry_safe(), inside that loop to do the
> > > discard and retry().
> > > If I previously suggested it change in here, sorry I have changed my
> > > mind after reasoning the code a bit more.
> >
> > Actually now I have given it a bit more thought, one thing I realized
> > is that you might need to hold the percpu_swap_cluster lock all the
> > time during allocation. That might force you to do the release lock
> > and discard in the current position.
> >
> > If that is the case, then just making the small change in your patch
> > to allow hold waiting to discard before trying the fragmentation list
> > might be good enough.
> >
> > Chris
> >
>
> Thanks, I was composing a reply on this and just saw your new comment.
> I agree with this.

Hmm, it turns out modifying V1 to handle non-order 0 allocation
failure also has some minor issues. Every mTHP SWAP allocation failure
will have a slight higher overhead due to the discard check. V1 is
fine since it only checks discard for order 0, and order 0 alloc
failure is uncommon and usually means OOM already.

I'm not saying V1 is the final solution, but I think maybe we can just
keep V1 as it is? That's easier for a stable backport too, and this is
doing far better than what it was like. The sync discard was added in
2013 and the later added percpu cluster at the same year never treated
it carefully. And the discard during allocation after recent swap
allocator rework has been kind of broken for a while.

To optimize it further in a clean way, we have to reverse the
allocator's handling order of the plist and fast / slow path. Current
order is local_lock -> fast -> slow (plist).

We can walk the plist first, then do the fast / slow path: plist (or
maybe something faster than plist but handles the priority) ->
local_lock -> fast -> slow (bonus: this is more friendly to RT kernels
too I think). That way we don't need to rewalk the plist after
releasing the local_lock and save a lot of trouble. I remember I
discussed with Youngjun on this sometime ago in the mail list, I know
things have changed a lot but some ideas seems are still similar. I
think his series is moving the percpu cluster into each device (si),
we can also move the local_lock there, which is just what I'm talking
about here.

