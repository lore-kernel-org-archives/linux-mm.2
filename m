Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4316CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1918F6B0005; Tue,  9 Jun 2026 07:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1697E6B0088; Tue,  9 Jun 2026 07:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FA46B008A; Tue,  9 Jun 2026 07:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECD8D6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:32:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B32C12055A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:32:05 +0000 (UTC)
X-FDA: 84860160210.02.24F12C7
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 82D97140007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:32:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O0H4PbbW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781004723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lvgq7POn/w9rz+We0BV58+fu0RFe+o4GELqPjOVmyBg=;
	b=iDQfOP8ua+drs10tnqPoUOP9I/hN9K6YNAMzJebOJBxwM/7mDQazbSyhLK/7HXeyhbxvAn
	Ze8hKGgM787UfG9at71uBAvrEoEEFYvC73BpEN4rJIVughlpSs6BO51fxAmmkvl2lpyeSI
	jEMKjH9tWNcsRE36z1970U+TXW9VC9o=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O0H4PbbW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781004723;
	b=6SP4mXqacxtPfht1CxsxC9/DP5vWumlOJ/A91QPUtuKbBiCle8lp+6cTQMoj4s6MPItgXG
	6+bfhY1kmQQNBwajyaq6LvH8Wr9HgtvNEYMUJAbPi0JbYzr9QUBvq4AzJZQFZuM4QrEoYC
	K9v1/zbaXV5jUww3/BqmFMJ7EvXPDa0=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-66039d3efcbso5513315d50.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 04:32:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781004722; cv=none;
        d=google.com; s=arc-20240605;
        b=PLcgYYgCgBFvNV4Xnkzp1vlHzcM4RxPzUy2Io4HsFSR5KqZhhyEw1QPehioWjwvYJ8
         UE5PCt+9jqhNZn5QOE2EpiuMilKvvQPD7eaeMtXjO52MBLOjCNDVQJGNX6KzZvhJdhwa
         RWsPEKf4g9KMacIABYsv9xCUV6EVOj2UMF6A+VgP79QRixb4O+Sm1l8RWZktcUAfabvS
         3SMUFRqVMznM647z+jN4FPKCCX4FNWNLT3lNv4iZwetLk7GD8243737qZl7MS4Zb5zcr
         Drz9CDXGwwsrGZeToKa0xn6mOO6OipZsZ42lLOM5troXjHIkX10RYAaVce0ANZYeeXUY
         XWQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lvgq7POn/w9rz+We0BV58+fu0RFe+o4GELqPjOVmyBg=;
        fh=fK5QSSjz4b9ero0YivNXwmv1cyv1aEs9zhxipD2H/hI=;
        b=idTomjQZeKi0qadXbo7xX1lZFvaXK3jAMAVIwvQih+lY1bcFOQXsHhsGcNZNAhdJj8
         31dJ7HMknbaiN7xeQspxrQOGP1h1QftUKcuZFOwRUUvuqyKbL4Nkg12Af2syRT32KR57
         msmshWLV2Rcm3dPC5jmNc6nIh2/mBZgZmq2Kb6p/aoZ93TH4fkDS/NtcJrSeD3af5zY2
         JUAwMQLqZETmVjy9xJ/5Bma3VrBvjGH5gsRMgx09q5VRySXgR2Jfj7dHPLqNnuBKvd5t
         +WF8MdHfANmvcj8eFjAxTrRDWtjW1yJnLKKyDul6OJawr1G+6Nnb0CefhklFZBuPkFP6
         U3CQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781004722; x=1781609522; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lvgq7POn/w9rz+We0BV58+fu0RFe+o4GELqPjOVmyBg=;
        b=O0H4PbbWMz1KjOPaZxFoddYTGRovozjrG8z2EUiITVp0qImbiZFbt6reO5jrdXzcIg
         uod23/+cMWwH6lSc8REXPpKQrNgKdrFfzbT8hWoFbO9+CP9iTe2Bxsd06avVh5iZpPi3
         kJIN51YYTNf+eFDM5nQt8VMx69DCxfGp5teWw7umYxvWVKRKjI1Fm3F5CLlel9VwmQs5
         G0zmRucn4EliJqjJbpzUxlHNgZn7teB8N2Eq8zsz2TNuOY2FS0iVqGlQJWz5t2bUye0d
         arR2NwUpEexh2L3K1QlwCDMA3ycX8ER82bLYDYadhmYIl2MUEXxEWb6ArigBeRslLBbS
         CZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781004722; x=1781609522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lvgq7POn/w9rz+We0BV58+fu0RFe+o4GELqPjOVmyBg=;
        b=TBzLFj9c+wyR5i4FCQ9LrwJHlrYw0eZeOUrYazklHEp+lSeDny5f6vYC+KDApabklj
         3Du26usgj33ilhMS4ynKLbau72JPLBhqDQnyKB/8CeBqwWS2v+gbtwrkzaFAmAFnvvzU
         9QLyoGm8F3fNJX4D0P9NttZyxbSyTEocUptFaroOY+TQazNCltMg0nyV8ZGu+RU43oje
         Dq4cEJzjlkzP+LJH7EgjUyUIIqvKqkyPiyFbpl76NMTiG0uxyUj1FRXQ661P1tUJy0cO
         ojM/87uksGlq6BgQ1hksO3ZWee9EU2nJUUY9hhO5yGZaCgdxf9evy1a0seDzhJew4fnl
         0nNg==
X-Forwarded-Encrypted: i=1; AFNElJ8+smgBI4heBZnYMNpB2x1wyew/VJmqPy8XTtO/w283bJGL0XxbcNj5Qzo++FdwA9CukkqK3jvhag==@kvack.org
X-Gm-Message-State: AOJu0YzererzxdS5PQe5ZrlAdxHkywPVib0IM9lsowxJJ3xbDYQpZUEc
	AYa8YOGIzYtcX+cTn2U0ILU/5m3P+ZODK/MgKzqP96Od8297bJzsc9QUi76e63bdcvfpU7JYowy
	/9J9Q3I2N8e5EamssN4x0dN0pts04bPk=
X-Gm-Gg: Acq92OG7C1iJvO8t9l4ghBCfsTeQqM5gGk7sBibCBClWhPg8KVengDLY8zPAfSU+q5g
	kJZuqLbG5Jr6VLt7KM2/Gl1bw5NL26/jUp2JWdwuvdxxHmS/b2oRVZGnWJrqKh67BbhsUWyD2l+
	IuqIWmp/glbnS0GUkab0tUqH7JUW/yYwbjtZEDsNkCP73vUQBsKZBhHg/5czPrOHqWRsRz+ah5l
	EFWbqgWVVCY6XEA0t6PY4jnioL1BT7uH6eT6XEZX7U6YUZ2VNQZFs9Qx/cZusMq+ZnLHUbAgcAV
	1RSiTz4Z1pr6YUP1T7g=
X-Received: by 2002:a05:690e:418f:b0:660:55e1:5bb0 with SMTP id
 956f58d0204a3-66106e7af94mr17575366d50.22.1781004722502; Tue, 09 Jun 2026
 04:32:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260605084242.1549811-1-haowenchao22@gmail.com>
 <20260605084242.1549811-5-haowenchao22@gmail.com> <CAKEwX=NiAwQdJFUErh41+wMvDDtFK2seTXx+bUu5SAAN46gCdw@mail.gmail.com>
In-Reply-To: <CAKEwX=NiAwQdJFUErh41+wMvDDtFK2seTXx+bUu5SAAN46gCdw@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Tue, 9 Jun 2026 19:31:51 +0800
X-Gm-Features: AVVi8CdevcvVQh3G1a_NKnL8jd303J5fW2Ltwqa0_h3zqZaeA7z3m3PrdUE0JFQ
Message-ID: <CAOptpSOBd95naM2HzSAOd-sJX=YWyaM7hphY_pnsCHg6vfLYtA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] mm/zsmalloc: document free_zspage helper variants
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Barry Song <baohua@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 95f6nw74tdqx5iywhgwj1wacxmxc9s4s
X-Rspamd-Queue-Id: 82D97140007
X-HE-Tag: 1781004723-266235
X-HE-Meta: U2FsdGVkX18dATjytGJFr8Rv/mEJkIp09rYAdh7X0QKGGj8Tvt3HqnTujsF4EPjPODVcqINdQl50zaJtzc4hKWJUkmdo7/vhjmkChj23PyvZyCvP53u4MYETDYoI+2kOQ19qHGFPvQ+XlaXuVjOajmV1ic7RfB/Oa1mwBOyWSHSFEQf7/SVy2FF5Mhs3mmGIkuY1v21sR5yYufztj+fpeWYqmTtGIp96NBqhUUDow+bAi8N4BeHjPfWXfWJ7M2rxVLAvxXDfDKekTP14SGwGWkqtZng8/nMJh+sjdlkBmZxHT1NxoUYRQg7+wUhEAHFlFx+MECJ6d4PiJo4wv0pWoTQkJW47PHDGUryFxDf/gZMujQBLNBmdo6lFlUzxZYfSfcBB7FThVkggh9roFpMONH5W36C2rTEGM0Nr+Xx2QRKSGUrSmrtB+NX9ZVa1ScLFZtDmCohc85VUDf4DwpxC9Z1E8pHKAHfd5Iu2XlZiaoRkThSCxhaVpzaUsoTrNn+z8dTqiCnOBp0QflG+Qj04IQuclXZW2ZyNQajFZOzqag8ChxKv/dI2WHOc2pIOdiyq7UzJJ7V00BOOD4onUCWJiugkrtc4RGRW1QFSuOEOSQf8xHiSxoT9lh8OVmfeIOyk6v/uVsxC3HrXKeO0qJlXoKL7hwiZOh+25eCwInsNF1RB4Yi2d+VA52DxZJGz72WykQqPsdE/MnfXSYAyk0H/M2BUJ4nu2W27ZhboD0eaRLSmnLpzw4Y5ZnWXBPZx69o1/GEwMxFr9nTN1hIch9g0BTBaT5BU2zYkzgva72L8I1Xoz3I9VDWMkjEET5+riHPSFeUhRlWCZQaEc+zP78+aS7L1qIzBvtrD5mpLt5opTshwtgMRIwuQ+4dLkwUI6Mau/mqaItRcpfzhVFFmnMWKiJw7my20NsxfgeNQyfQeMNNLY7fK0cNB2JciRTvvWMKffoO5KAsZM87etKnXyVc
 0errk50I
 plFSPCDAxV5tUfdvNNq13q3XhoKtplq8yFym0ntFKDPJJPnhKqcynBVd8lqNRRyTW2RTevKdYC1emVG+YXb8qzfOozzPZrDFJdaRWgGU8IfjRV27Qbbb1xaXp/S5x6FHnHq+sXCGrkjFMwuUdljyFEfkAM4T0y7uUR8VKJhy8DfSnaILRj9F13bDxuGg9wHGHdSLIxXiYw+MIjypuUARaWEY5BFyamlC5oRhxbX2u+AhJ2tz71/rjwUpnOFiCIOeOCyf2Ic243Y88F8N0fP7hIGmNtDdIFcKHBfxBy+oOG1/9OM72OxeMOwxIubxGzU1m0nyaDaScauspWIn2tR0YPY+RFHZ6cpucUPx6v2jSFuwYVgUpIsmZnulvmW1jWUlRL2Nhhxao/rPktlvm4GR35gG5z+j1C1gDB5pszbxSm3nBnew3WON5S822WG1q577g3SLM+jNLugsNcCy4CsMk5Qnz0SftV7gKVHmjJLrrIfE1A9VAF78qBB2/KlatAhAt5WJYk1SvLHV2YDSq/pixLcUbvNS8o+Nv4p2ulKNDFxH6mswMiU1vINFchdzm3igIVSzK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 6, 2026 at 12:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Fri, Jun 5, 2026 at 1:43=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.co=
m> wrote:
> >
> > From: Wenchao Hao <haowenchao@xiaomi.com>
> >
> > After splitting __free_zspage() into a lockless core and a wrapper that
> > does the class-stat bookkeeping, three similarly-named helpers coexist:
> > free_zspage / __free_zspage / __free_zspage_lockless.
> >
> > Add a comment block above them describing what each does and where it
> > is used, so the names are not easy to confuse.
> >
> > No functional change.
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
>
> I think it LGTM, but I'll let the zsmalloc maintainers have their say :)
>
> Feel free to add:
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
>
>
>
> > ---
> >  mm/zsmalloc.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index 2ecdf79cea03..9f588b63ec0d 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -856,6 +856,21 @@ static int trylock_zspage(struct zspage *zspage)
> >         return 0;
> >  }
> >
> > +/*
> > + * Three free helpers, kept apart here:
> > + *
> > + * __free_zspage_lockless(): bare core; walks zpdescs and returns page=
s
> > + *   to the buddy allocator.  Caller owns all zpdesc locks and has
> > + *   removed the zspage from its class list.  Used by zs_free() outsid=
e
> > + *   class->lock so the buddy-side work does not stall the class.
> > + *
> > + * __free_zspage(): __free_zspage_lockless() + per-class accounting,
> > + *   under class->lock.  Used by async_free_zspage().
>
> nit: maybe a short note on when async_free_zspage is needed?
>
> (IIUC, only when trylock_zspage() fails in zs_free(), correct?)
>

Thanks Nhat.  Yes, that's exactly it.  In v4 the comment now reads:

  __free_zspage(): __free_zspage_lockless() + per-class accounting,
    under class->lock.  Used by async_free_zspage(), the worker for
    zspages whose trylock_zspage() failed.

Your Reviewed-by is picked up.  Note that 1/4 and 2/4 have non-trivial
rework in v4 in response to the sashiko AI review, so I dropped your
R-b on those two patches -- a re-review would be appreciated.

Wenchao

