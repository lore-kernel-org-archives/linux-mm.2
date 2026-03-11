Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B45F1FD063E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 07:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5DB06B0089; Wed, 11 Mar 2026 03:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F066B008A; Wed, 11 Mar 2026 03:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17406B008C; Wed, 11 Mar 2026 03:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 800FE6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:31:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33EC41C91F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:31:53 +0000 (UTC)
X-FDA: 84532962906.13.AEB112C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2493D140010
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:31:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CFVjoH0k;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773214311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cWiFyBcdQIPprieqKABTKimIyvkofRGeeAguDoRoOlk=;
	b=7JSVfWncnslUktpWsDxpaJW0XBHDcYyaHWiDbtAgI5oMQTveBWPlQ+NY50ur0so2fVUw+t
	wrF6YJwjzhkiLZYn1LaFrqe0jePoV0Ak7cIitiuZheNK2rvZV0kGAz6meGubTmSc1qtD6y
	smfbruosTdiW3Z9pg5gEaLdM/MpRck8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773214311; a=rsa-sha256;
	cv=none;
	b=5wGRcxyfGvb66oQ4wk7Y48XfWzYKlLysNPZtT0UuvRQK2Z0PD18MA9oOqvDhDmr+ipET7B
	O/Rzw3zvhRHllKU1xbSDdQ7lVi2Y5xJMfJT6xdFRz0KcbsybwNDwIPR7bcoUf/KoDJfJIP
	9a62Od8TMkGbCJE5XF3NCY7s7sYZ7fI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CFVjoH0k;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6EC544486
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD19FC2BC9E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773214309;
	bh=3V4xHLccw4r7xXUFmzGLCC246uQfgynbB+kat8hm+Bw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CFVjoH0kIm7TgHiBi2WgNXveLq1CZfPSaXIF9qI7Xt7Hr6Hop9QSbbDrR0PlwhNT/
	 7VZu9JHaOecyn6gXGe68L1rsGqG2+i9oomt8UqOCu+FC5sJoyV13ycuupFl/Jk3O4K
	 uwewpZod5ZRoVz9uBprcK85QHt10kgJKi9HfTsN5iaM74LYGPvEZ+mK706UVbIy03t
	 oAQ1Uhshk9Ntt05Rc3vBAz22v4RaUXCnqR3S55SDfYMY0SpR3Tz3eecbo/9UETbkxC
	 KEHoioDqc7O4MJF5UVSu6nIOYj84w3uP8SsM+E/z6ZfaXurVbazpx8q/z2/JbYSq9V
	 wnQ/QY/oaKxcA==
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-64c9c8f8783so759574d50.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:31:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXHmRZYNkFyOmeBIqQmOkZ7HsYygjXJLUv0fcFt4g8EBOxT5ttl/b33dtRUPQmppO1v4Nur/7P9Yw==@kvack.org
X-Gm-Message-State: AOJu0YwOHMDzZMCS+V7+f/jWXszrsHyPXz8ZiZlnURhs1dXR26fbXqmB
	4HT5SMTfOFZVOk1svtYh6jHfvdtoJ+vpTltxgc55e2ll/BiQ9LNgbbbyoGwFu9pqzxuPC7qdCKW
	OfPiaJFGBc9nJC0YM7QblNX61KRY1AKAHS0hWWdpv0Q==
X-Received: by 2002:a05:690e:1347:b0:64c:9bf0:3055 with SMTP id
 956f58d0204a3-64d656602afmr1277629d50.6.1773214308943; Wed, 11 Mar 2026
 00:31:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260306024608.1720991-1-youngjun.park@lge.com>
 <CACePvbXVvPp_a89UFztZo5nGawpFea9t=NRisf468VcxHgkX7A@mail.gmail.com>
 <aaqKJQeO8wLQL7Zn@yjaykim-PowerEdge-T330> <CACePvbVp=9PM=LUdL=aq8G2Svy+v04pBnf3ygRY+xW3WEHNm9A@mail.gmail.com>
 <aa551UFgiq+gUl/T@yjaykim-PowerEdge-T330>
In-Reply-To: <aa551UFgiq+gUl/T@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 11 Mar 2026 00:31:37 -0700
X-Gmail-Original-Message-ID: <CACePvbW_t+dqFVZfde6aXxbREaX4iiSxd4knFGKQyDkbxprH6A@mail.gmail.com>
X-Gm-Features: AaiRm52Adgj8vkv6Psup88AW1ywMhrtnpWIBzQ3U1LbmgXHrKe1Ii1Zg4gMoYBU
Message-ID: <CACePvbW_t+dqFVZfde6aXxbREaX4iiSxd4knFGKQyDkbxprH6A@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm/swap, PM: hibernate: hold swap device reference
 across swap operation
To: YoungJun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, kasong@tencent.com, 
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev, 
	linux-pm@vger.kernel.org, linux-mm@kvack.org, hyungjun.cho@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2493D140010
X-Stat-Signature: nboh9js19k4eaam9ok6uoc91h7a1auhn
X-Rspam-User: 
X-HE-Tag: 1773214310-210992
X-HE-Meta: U2FsdGVkX182q4voS81zpbNjLWvlbgJX5L/ZhULG3cnogpM/U0wzoYU3DeRvJjVseGUAyR85mN6ClukWHCtTq8LvP9hn9pTv6lbPLaxgYu7OnxxHzVx+VbOILJExNVGXgPUIT0UQA8XnispnwuHtHHkz65Qaa1oX0UvHSA5vsLoC7OdcJ6tcvD/yDiwK/kQBjPC56YnbCYs4HtgFSwiazNkpufyLKqljXAyriwmvsDkgDisDypCgNkGRYjtE1TJsOVz1V22t4G8jGA0IIy4n9vkbCqfgHgmE1G9qZeL+YGviiVa/Q9+R1EwLO6RudNSwwhwL7WWiHkBDgLBRHURArFOR7dOAi7H/qI+oYwNTEeBnwQEnkqKlfua5LKcY7cIXYGjC6E8D7jLGpu5rA2tTkjg9S21De3UDILavU/E31YlvR0j3xzPDkbNrq4rHkyOXXV6vKAOuUGLnmyMU7/tggZWWclLTg5dkgBRnP86aa1bIpkeGWLdBa0QCn7rd1E9j72mI9Yvh15N6zhHnjjZVt5rmirAhP0/ftI5rqWeYTmgmFnw6u1tRTDyXIk8U8Ei3uB44z5tcea7EG/6c2NBMvINNlV0827cQFUSqTXqfk6xDfoOt2hL94MwKZXbw4lOLVKKmeDS76AVEzAEmrsIwNcWCjrCw2ap02S9bZvTRno+TvwxzzlrPpDZrcwbbc2KawiGCRiv3Hj8Qw7yTHOTogyuN0jPHZCithcU2VWnqSh2B4isqY7GGVKKv019Yw+7AdRkLs7PlJy3jASY/tWwPKfgJTjCN82lzhxxXzsSqmD2gdUBvU+zuN26SlzSvPLt0hejwqDGZ4n6xIvxXgm6+J2048XuE7CcCRB0kekJ8pDKXUQsbUozuuTx1quqW7E7242T47O5UZ7Y4Is61d8hnLRT/+YlK4Kq/aFzPSUMfXKCUv9bAGIeaMktZtfm4i3+KXOdhydR3wpTBHQxCVnt
 r0eofwtp
 oQkryd5JxUVT7NGiheTA6xbKkBuJ3KGIGsitj19iE3Wx9GpafXczy4hsMUjSJlwyTg7t3FaUvmvw3Bg2BIrsWlgSq6z19BCASHPSGAjmhUGp72Xll6zv+Uq2F2shSm2Qk3G4JcSPKxUe+KCXZlqkxONGa2XnGLhIv3ZlzOTf+Py9o3zyR5zFALrUcYht53DgOZvMirMrIPS5J7n3A2nE4dvkGdqTSm6t0K4iPrOgX6K1i3M/CClz4YilDvaxUXTvKQrX9bdGQ4sdNRPhQYzwouYshoT9AN/XHiQ+4aQHsfNp78AWzpkz3tG3mLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 9, 2026 at 12:42=E2=80=AFAM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Sun, Mar 08, 2026 at 11:43:20PM -0700, Chris Li wrote:
>
> > Agree. That place needs fixing. We will make two patches.
> >
> > Patch 1. Fix the swap off  racing between lookup and first allocation
> > on suspend.
> > swap_type_of() is very tricky for the device swap because of the
> > conditional lookup of the si->start_block matching the offset or not.
> > That make this patch very complex.
> >
> > One idea to brainstorm:
> >
> > So we can get the reference count on during snapshot_open(), after
> > checking "root_swap" still points to valid swsusp_resume_device.
> > Then we release the reference count on "root_swap" during snapshot_rele=
ase().
> >
> > That might side step the complexity of  swap_type_of() doing the
> > si->start_block checking.
> >
> > It should fix the bug you described here more simply.
>
> While that approach would be great as a minimal fix, I think we still
> cannot avoid the following situation.
>
> Until the first swap offset is allocated, we cannot guarantee that swapof=
f
> won't happen. To be safe, I think it is difficult to prevent swapoff
> without holding the swap_lock.

Grab the swap device reference at the beginning of `snapshot_open`,
before any swap_offset allocation, until `snapshot_close`. That should
prevent the swapoff? The swapoff must wait until the reference is
dropped at snapshot_close().
I assume the swap entry allocation happens between snapshot_open() and
snapshot_close().

> So, to stick to the minimal fix principle and only address the currently
> possible bug in uswsusp, we could consider:
>
> 1) Creating a separate function to grab the reference for uswsusp, and
>    put it in snapshot_close().
Ack.

> 2) Adding a parameter to swap_type_of() to decide whether to acquire the
>    reference or not, and put it in swsusp_close()

In my mind, shouldn't the first point 1) be enough? Not sure 2) is needed.

Chris




>
> On all strategies, we do not grab the
> reference when taking an in-kernel snapshot, and do not add alloc/free
> get/put.
>
> > > My proposal is to grab the reference at the lookup point to close thi=
s
> > > initial race.
> >
> > That is my suggested patch 1.
> >
> > > If we do that, I believe we can remove the per-slot
> > > get/put calls entirely, as the initial reference is sufficient to kee=
p the
> >
> > I suggest that as the patch 2. It is an optimization to eliminate the
> > get/put pairs. It is optional. without it is fine in terms of
> > correctness. Might not worth the trouble for patch 2.
>
> Yes, I agree. I will split the patch into two as you suggested and think
> about it further.
>
> > > device alive until the operation completes.
> > >
> > > Regarding the reference release strategy in this patch:
> > >
> > > 1. uswsusp: The reference is released when the snapshot device file
> > >    is closed(snapshot_release) and error paths.
> > > 2. not uswsusp`: I only added reference release in the error paths.
> >
> > That part makes this patch complex and harder to review. Need to
> > carefully check whether we take the reference count or not.
> >
> > >
> > > About 2.. I conclude that on a successful resume, the system state re=
verts to
>
> > > the snapshot point, making an explicit release unnecessary. However,
> > > I am not 100% certain if this holds true for the swap reference
> > > context.
> >
> > That is the part I try to avoid: the very fragmented error condition
> > for reference counting.
> > Hopefully, with patch 1 idea we don't need that complexity.
>
> I agree with you.
> But, I believe it can be a safe modification that can be sufficiently
> verified through review.
>
> I would love to hear the thoughts of the hibernation maintainers and othe=
r
> reviewers on this. Although there are some complex parts, I think this
> modification has clear benefits.
>
> Thanks
>
> Best regards,
> Youngjun Park
>

