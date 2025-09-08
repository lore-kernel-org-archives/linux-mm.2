Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27336CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8690E8E001B; Mon,  8 Sep 2025 10:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8407A8E0007; Mon,  8 Sep 2025 10:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756F98E001B; Mon,  8 Sep 2025 10:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 644888E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:50:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14D8AB69D2
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:50:16 +0000 (UTC)
X-FDA: 83866368432.05.5AF36E7
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 34631140012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:50:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NE6zv9Xr;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757343014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cBnBAzByhKHzc++vGzjU9VUoO8lmeANHV6T0Upv1VAY=;
	b=oG73e6rSU/vZlgsxEN11mn/vKS8ox+UV1aMpmQpcuFbB+hTrIz0idOixjPVvAsXnLRBnzQ
	trkMDxzF7fE8P2JbPQC4YLGOSE3+RVkEXXQos1ySIA1AXPbLL+BuyzbIcElIHPG5xihoAP
	pLX/WAF8d44dE9xDWoquJChdxZsk2Wo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NE6zv9Xr;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757343014; a=rsa-sha256;
	cv=none;
	b=11t5SFnFkaLg+Z2w7pv4xvCEbCRyAuZqJBUYW5osRCFEg8P2jpOlPK4gETO6GN82eTrD5H
	KWvD4gKaQuOqt9Erxes2iZY3Y+oepyad8GN+X0c6kQIP+t5Fmjd9ZrShdp/V+kj5zz7+6C
	tm6lzvrjW3BOycRTmbp9VEynhkjEv5A=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-621b8b0893bso4935462a12.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 07:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757343012; x=1757947812; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cBnBAzByhKHzc++vGzjU9VUoO8lmeANHV6T0Upv1VAY=;
        b=NE6zv9XrbMSFwara7O0RpqoZNmGtM2FPQCe1Tgi1R5djOGn0Jyj9VTp3u4r+23TsRo
         OCq8+W2bXKiZ+Zjs7G5F+mvllfkTNi/wVTo5AHgQ55lBAeKQs4wSk7706FyXqxzPG3k3
         z4BChU/tqL0Yu2FyQf0IC8WjWBZHt0PXZQF79LpHMq/PVt3vpLobeHs55q0stsZtLI9+
         4tWm6oBlKJ5RovlG4JhT6AzRK9AUB1DN0iqtG3NxodOcb4vWftBgWuQIMGFWgKNWuJ+t
         c47x/xIFZncbwxxQSoBkqWGYzx7V4yPzG6Yl51huZ6IN61nEQrRlSEelnRVJDGRgmW2i
         xZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757343012; x=1757947812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cBnBAzByhKHzc++vGzjU9VUoO8lmeANHV6T0Upv1VAY=;
        b=ZnbuaCtd1mHlaVrzwwK5bBuS7EO559zhKyk9jjdbysZnQmVCG6ueGH9W+qV7/MnuWu
         08vNHJNpaT+S1SJORPpiYHZO8dvcLMb0wT7bFj9M7xI6xLA8ESQtXPMZ2okYtHdFVo6s
         dXjVFG1Ykrz7A8c9vFWZ7hfr5gpvEUZji4lq0V/b8TwHqKV33xPj3XFImD5pOvsjn0ic
         TAW+tdM1rEvwreJszrqtneyyCQWzpaortO+tomuzWSrTwY9IKCEb950yzHBNxdGfvFr5
         kZpDLGO2K1vr0bIcL12xzU3y/Rl90UiNw+IhPaIBuqEdXYvXmu+po2Q60zazOEF8HAsx
         DTDQ==
X-Gm-Message-State: AOJu0Ywql1QQPTw6fCwn+vvjfVolsyOjWTxkO7/9BOE26Zw0xjh1tSMZ
	n6OGKzj5ZtaSEcWZS3kuJkuIwbpkv/clXenN8jvJxNx9JmxL8btpgQFKoDy0baV+hasqGvoOc0H
	nVFMk103IFFOQL0hOjr6nrtbB1oBDw7qaVGOiBvk=
X-Gm-Gg: ASbGnctYssqZUkUXckgM54bwV0/0M8jgkZQzgemjM8aY+I+mruQVQsONQHkRkIyWqtm
	gKM6ykKxe/JNs0Z9OEWcifpvDY3g1wBr6ZbotE1R5e1Tdas5fc/2Hmx/I+GV3zt5h/IFOX7fSel
	QLtaRP9IXlYik66v81SM+BtBoB1yta5Ob+cehY40Si/xOgkBg4HrfComP0d7zdHOejQIIQVRVs7
	i1mnd5K87t4UGJUGHP+Mg==
X-Google-Smtp-Source: AGHT+IHoCdMs3Rgdl4qcYf60aLmzGiOInPelzWXR6QdgP/GxD8XjaDfo7Lkz/WbYhPUj3aY2YwNFvuHZxaURYh+Mn6o=
X-Received: by 2002:a05:6402:278d:b0:626:59d6:36a8 with SMTP id
 4fb4d7f45d1cf-62659d63bf1mr5325649a12.10.1757343012341; Mon, 08 Sep 2025
 07:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-11-ryncsn@gmail.com>
 <c2ff433c-35d4-45e4-bf06-e725726fa515@redhat.com> <CAMgjq7AsYz+pDTCU5PWoNPN1VJ5Vx8ZLQgF6MT26JUSXr=6__A@mail.gmail.com>
 <9b4808cd-3239-4bb2-8073-7eb1412c4529@redhat.com>
In-Reply-To: <9b4808cd-3239-4bb2-8073-7eb1412c4529@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 8 Sep 2025 22:49:35 +0800
X-Gm-Features: AS18NWDTJApVExUbWOm3Uk5o3faBrft3HdzEwpOWLJ_Dud28dx1pmYwAgnZ0qk4
Message-ID: <CAMgjq7B5tm=cCPM6DrrjWS1tkpHDwmQueMKEBKz=br7xAgOgjw@mail.gmail.com>
Subject: Re: [PATCH v2 10/15] mm, swap: wrap swap cache replacement with a helper
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 34631140012
X-Stat-Signature: eijahyjoadbrgjqorbgysw718t5gekax
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757343013-365033
X-HE-Meta: U2FsdGVkX18xdTTtSgHcnPFciGHhuHwX0RzJbFovmsKhApmmao5E/0zYMEo9lcmvsWr6rY+ocaWLCR9EkDkCWHDpic93RghV0L3C7ynCgcGZ7PL02oJ4p3vZ8ZvD4Nadj0JxGpdHbCwBYTI0Iyw1zK+3qasBaNkOEeD1XU6cn5fqT+4hHa0z3FeaKN1LRkt/8vfSnZb6L5VGhrR/vqFOqY0VfKAz4pQa/kuNyDiz2Y2OsWt+kNSR/i2vjhyZwus4p6W+tkyZebqxao0Z4cDT3uqoMAh189ajwF/5++89BWJkDPvrtE8OAZ2xJZHqrCIoZjeVFqbSuDI7oWLxncbB16IDCr28BSI1fpQJxJPMIBJ7VauDyzqCSwj5D+x76+k0aQI+qu0eksMsZfmKfoKe0TZLKgObZzQiDOB8AcMykDZ75Q/Klf8q8PJcr9Ihexx2TJxhfXwKjtZHGuxnSUU2jw56+Nt/jG/Z9a0XYbcHZy0MOiKg6wkwnlL9V2nd8Dwb3xlhA4KifjbU56S4/mGSeU5d4XRRiehWbuOK9vbrgfo4hmhqwesGiRIihbjkCjVmYihcfd0EH0sruG/njDf2QIQkcIJ7Ph+q0W2DUsKgONj733QSQopnZ3c+s+uSeipIUsheG32n5q5McWX2inaXyx2ygq9P7uOrjVODNJOX8S+cnMzcTlg36jGd0PW3b8OhZgBtCZD2MlxvSmQUChP6kSFRHnX6thCtI5k1v+L8kO6YNIB8fIvyOY9BM+oNjkWQ+D+17bjXDiuoQbCSsXPZNjoEytJOtXeraHSoyDG+2pGmUd9CRUt81IvPFjPqMxz7XxySwqmRChq70xTJ0FzmAoFSsN9Eoml9iPR3cp7o6ZLPuMFo+8ZMjdSxLLhB0h5RVJw1GZyXBabr59I/MTvvF+OY1Ed7xzibEP454HSxPE41GWupDIqfQ9D8AMKgH2Hbv89I5uWSDsMU2ncXH8/
 iJNbiGId
 Yfe7cfYg91JFETTmfbi+tatSTJMIQyAH6w9K0uQQeHI2Vqw4JcuBaZXrduC7E9gOptmQBY6Hb1SKMVkSMMpRkEJWw+8snR9Iv+7x2sx5HKvLv088AI3zzSsp0X8rdyKdkVuu8w/8FemgD0PZ7ZLjBYIpdBHtNI4Q68uQWiq1wyythfel+mySIVYeOOL9Gw69jakf2T2aKykjylhHzNlbH3kDh+jIJQGUJ9W9sFMUpUqkmbSIZENHPu51bQzyo1Yz3Q4MBc+M2Vb0YEUEGRo51bRBkmZltg+Mmsuj4y1r7jewd6PWOJs+WYJXz3hasqoFLmgXAUJ0fpzCB2n4rvlJ+ZGuByeVuO3mpHqib6wSj53fMnTabdUyCoG8aIUW0WADBQyqV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 10:39=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 08.09.25 16:20, Kairui Song wrote:
> > On Mon, Sep 8, 2025 at 8:35=E2=80=AFPM David Hildenbrand <david@redhat.=
com> wrote:
> >>
> >>
> >>>
> >>> +/**
> >>> + * __swap_cache_replace_folio - Replace a folio in the swap cache.
> >>> + * @mapping: Swap mapping address space.
> >>> + * @entry: The first swap entry that the new folio corresponds to.
> >>> + * @old: The old folio to be replaced.
> >>> + * @new: The new folio.
> >>> + *
> >>> + * Replace a existing folio in the swap cache with a new folio.
> >>> + *
> >>> + * Context: Caller must ensure both folios are locked, and lock the
> >>> + * swap address_space that holds the entries to be replaced.
> >>> + */
> >>> +void __swap_cache_replace_folio(struct address_space *mapping,
> >>> +                             swp_entry_t entry,
> >>> +                             struct folio *old, struct folio *new)
> >>
> >> Can't we just use "new->swap.val" directly and avoid passing in the
> >> entry, documenting that new->swap.val must be setup properly in advanc=
e?
> >
> > Thanks for the suggestion.
> >
> > I was thinking about the opposite. I think maybe it's better that the
> > caller never sets the new folio's entry value, so folio->swap is always
> > modified in mm/swap_state.c, and let __swap_cache_replace_folio set
> > new->swap, to make it easier to track the folio->swap
> > usage.
> >
> > This can be done easily for migration and shmem parts, the huge split
> > code will need a bit more cleanup.
>
> Right, but it's probably worth it.
>
> >
> > It's a trivial change I think. But letting __swap_cache_replace_folio
> > setup new's swap and flags may deduplicate some code. So I thought
> > maybe this can be better cleaned up later. So for now I just add a
> > debug check here that `entry =3D=3D new->swap`.
> >
> > And the debug check does imply that we can just drop the entry params
> > in this patch, there will be no feature change.
>
> Well, the current API as you introduce it here is confusing, as it's not
> clear who is supposed to initialize what.
>
> So better to it cleanly right from the start.
>
> >
> >> Similarly, can't we obtain "mapping" from new?
> >
> > This is doable. But this patch is only an intermediate patch, next
> > commit will let the pass in ci instead. Of course the `ci` can be
> > retrieved from `entry` directly too, but it's the caller's
> > responsibility to lock the `ci`, so passing in a locked ci explicitly
> > might be more intuitive? Also might save a tiny bit of CPU time from
> > recalculating and load the `ci`.
>
> Well, no other swap_cache_* functions consumes an address space, right?

Right. I can drop it in this patch.

>
> --
> Cheers
>
> David / dhildenb
>

