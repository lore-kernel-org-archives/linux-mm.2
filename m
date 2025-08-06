Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3797C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 03:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679356B00AC; Tue,  5 Aug 2025 23:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650736B00AD; Tue,  5 Aug 2025 23:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5662C6B00AE; Tue,  5 Aug 2025 23:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 470226B00AC
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:03:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B380114EE0
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:03:25 +0000 (UTC)
X-FDA: 83744836770.29.31A2B30
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 932DBC000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:03:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M+k5efG/";
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754449403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9gZYHBoazKH3rjXuPK5OlYak4Pcs3GQzqOG3Z86lDc=;
	b=nGpTjtom36VqMsBbEKCNAXcUIGGV6oo8SqTUNLS5Nms5qSezLTjlIOb95Ka0pvQOoSaT8D
	5asvqP+sVGTKWoTIwGTUyBqfBV/IClyiROsUyH1lnQqmCz2iPJKhyeiT66QN/89RY006W9
	cS5RN9tCTjbrdG/lqiwEsVDpKO7rS0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754449403; a=rsa-sha256;
	cv=none;
	b=xEOHo5OKZ1DMBHht6s5feJgZ6nFXcdItRHorCj+MZAJ9huUKrYQKzQNNIbZ40lyrq+y5aY
	QHJ1+fsvx9AxV2DbEN4rlAcOHE/5mwgXnN5BZeKYnGkUC06udF/Uh0S92Ff4NjD4CoVYEW
	bhyjyuFtEqT3fxMpgroqY6RDAfLl/yg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M+k5efG/";
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3338252b2e6so1300311fa.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 20:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754449402; x=1755054202; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o9gZYHBoazKH3rjXuPK5OlYak4Pcs3GQzqOG3Z86lDc=;
        b=M+k5efG/gDLP2Lq1LnJObrBSZuncyhpB4PTvZx9Nm8MGlTdkxd++aXQ1NqRvmHK9qz
         COqn7ns708Fyh5EHbIuhonyWOdcymT6rUt6HwPdFgtyDv+oCMRlaP5fOMqDLvy6VYNuC
         WZkb1rLAasIyw13b2zXD2nuPsQhunZRrwFcF+3fGUsymtNdMo2YAkRYe+66cvm/Z5RC9
         pRo1cNz+qYggUpckfz9WvXqvT6d0aTrCrNIwCtzyieBeQRAHsJyzq/3zU1CmyGOjzX41
         QACGMpvR8Q7VABaqj/Ryag5WNXSpe4YqO0ro6T2Fy/M4CS+p8VP1momXDHCl1nLsVljn
         je+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754449402; x=1755054202;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o9gZYHBoazKH3rjXuPK5OlYak4Pcs3GQzqOG3Z86lDc=;
        b=jWgcNr1QdiO8+nRFpnIzBwZmmkWuxqP5rrP+xlU1E9fTSV0kQsadE9kHboZ54rRUF8
         XeVDu9fQxs3fiB/p0LNp4vZ2nwnbQUuMkLRN6wqmVO+3QhtfExIISG/bVQ4lNYbLeq1Y
         hNrrSWnxmbMgWlVB9wWhFD8JPaIgG6kDITTZ+7s187q17kyFeicXgmWkYAys0fZAf9G4
         jFw7jw4RAfcMG9gm8x/7t28eBPwyB3qqAA/RRSywAMqRhS3zmNSXEcd66IL2csqjfmsq
         vyzd4tP6MzfuDYIG1fKOWuLqMqkNRZfZEYhje/DGVYTNyLTIXIM5X0s7Q+vL4lTFGmEf
         tvxw==
X-Gm-Message-State: AOJu0YwfwYCS36LTx7W8ljIyhY8CkvPmfR2IWsMe9oE8xP4y0lb/JqEt
	1RpdoGl7kEBYLcXeXb7c1z82nqYJZ9VwOC/PIcZhq0dfaLhOcDIsXjUG+2QtJ5Hi2JQRWBIaYep
	I4YTPm3OEM8k9CGe396zD/Vz1R+Gz/hQ=
X-Gm-Gg: ASbGncvLRFVUb5MUhP7GLqdb+rroJLJlfZ/yr22RanINV0A6wXKzBTGAoXszImw2P1S
	w6iwyoebspBEiFqkFRG9uYlMy1RY2wklJHWcULjlGwy4f2UZ+j9I+iHesVAwc0PAbR4vH7dvsA3
	8oCvtB7qyiqi9p+z/ugFEtPyLI5obULJQpMSAWx8qE45jfcK1HHMxeTJjeOfAoPEBxT+/pYmyyH
	MNXcLU=
X-Google-Smtp-Source: AGHT+IEi9Cw1yLSBYhDfGj8ifvZFfup2ldm7Hs9ePdk1zXy82LC6OWq/dk5WMP5T2rN7DVpi7cZ7ZY8bVanuzuqVW4c=
X-Received: by 2002:a05:651c:31c2:b0:332:4558:b30b with SMTP id
 38308e7fff4ca-333812b070amr2956421fa.18.1754449401342; Tue, 05 Aug 2025
 20:03:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250804172439.2331-1-ryncsn@gmail.com> <20250804172439.2331-2-ryncsn@gmail.com>
 <CAF8kJuPY20cybaFqBXk34sEgZ8ydNOk7AoOtmNGLtdO3huzE-Q@mail.gmail.com>
In-Reply-To: <CAF8kJuPY20cybaFqBXk34sEgZ8ydNOk7AoOtmNGLtdO3huzE-Q@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 6 Aug 2025 11:02:43 +0800
X-Gm-Features: Ac12FXw-4ibyz3mto4mqVWye7WxZvW2ejJd4ZWbmNS5Fo5San-d3zHvFn9O3qQM
Message-ID: <CAMgjq7Bu3PmDzrEptRUifzZqkQX1cZQ-2DQjjmvQiknJvtGGPQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm, swap: don't scan every fragment cluster
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 932DBC000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 4wmhuowkboqpano55zbsnqxpimsfbhhc
X-HE-Tag: 1754449403-275608
X-HE-Meta: U2FsdGVkX192Ssn0ob/asPcozjf6nggBwep9jt3vYYQSpqLPxAHq8J0FqI/++14A7Ii2W5h3teoYThETUudoe1XjuAtvbTxTbTWZrAspZPTyLtE4K3paO1cR3/0uXfk263ALN/hmbeXi+QrGo7EuVASoPkX/Ljn1aWWvSFYFJVBMHo2Cwa4Ws09NSxvsaD6E+qEz24Rdo0lYofTdlpz3LLVpTz2AZ2ZWttBUzRLBhSVQdkZX9vNKI13gLD6eTyCs+Ukj+GyGROq/jJEmGbXrcCSoyXtZKyN6E/6Tj1qFUkUlXiBDng1LrJYmTG+YzRYtIob/MG27hoqmgq6RMhDrbg4ypf5+Yw9HC8U6bZoPL+Hm9qW/wzPAcJ2aW76BzeBZ0zROROoJnbODAH8iYE6YAO+uuT0+OBa/m8voFxPd0EboPNXqKlpGMvOsM/XpZDkx9oy2IKPMwhONxrdN1E9GL860Z4AT3XdgpgdAKSZgqJQOR777YRx2sl32GZSTH1Fq0gpQO3xfEFI9PZ7nzZyEKa+XgVMB6T/vrYUatTO/s3ldgyPe6NSNuunMZNPDTWW3jsJkybYRV87ZLFIvBr9ELwvrk+1gDYGO3D9ZgenQbjTqY9kpLcSO+/NEFoyi0nOEzFywDJjF5hlgsn7s/kosd13fqjUJ8zYwOoWDjEVOV8P+XpSexPFHInM9PKl6do7mD8O4htTOGyinRxTdowjogUKcUjbPC5mBH8tF1w1Z3CeuobCTJlfYB80ygqZVbx89LZhlMFPjYNwHwjaBAKZPnY17Wuy2XZ5C+298gLS2hnBVDFDtTFNdPX6xi7Dp2VJU3hjDRr+7uWfkPJRuJnWqA4Nb9Q+q2+4Whc+i4qDRA8XZOUf4vs/fRtqer+SzTl7+H9Ztu/80Vd+tyPxXENcG3wx3HxGLERzHktCR0Yo4xPtpLvgASe5F2aorRcWH2a1nbEzBTKxl+FYeLK0vZQP
 p4bIDXLb
 JdKciAYb/du++AflvuZnGYMIypIVJktPxKyes9zwPHAWAaUTd2UHOHyQgsE5BOsyJYfELPHkk+AAVoUgCdbz2rwQAFYYQAhtyjqsIHgQjK/fkKfEBrVSxLZG7r070G0R4n8d9nNyJFWJaHsLvYSeQ+XyeDB2I/CsiDYVhxA7YyyVC2/6QPBd9JFznDlJX3/24zrm566CxeWZ3fJBNGka/QPsA6FLEBcSh8gZUGKMqtTRkq41JyEUfjDdBzTRCMO8ddRXv0grkA5yzAgTH9Qgu2xBqrlMfWBi+ju2lh/k4aFqkDQImHd5LMbRqdvWx5A6pp6WpyDSowLgRODhb+UEGScy9noJUe+TPSL7b9SfNLqNjo1BeF0fQnW07p8wB6TTaNoZ5+aG9SZxSV9jPUK8fjotfMUBlWSEqI4VYL71oECD2q+M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chris Li <chrisl@kernel.org> =E4=BA=8E 2025=E5=B9=B48=E6=9C=886=E6=97=A5=E5=
=91=A8=E4=B8=89 07:30=E5=86=99=E9=81=93=EF=BC=9A
>
> Looks good to me with minor nit picks on commit messages and comments.
>
> Let me know if you will refresh a version or not.

I'll send a V2 to improve the series. I think no code change is
needed, the change log can be improved.

> Nit: I suggest the patch title use positive terms, something along the li=
nes:
> "Only scan one cluster in fragment list"
> "Don't scan" seems to describe what the patch does not do rather than
> what the patch does.

Good idea.

>
> On Mon, Aug 4, 2025 at 10:24=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Fragment clusters were mostly failing high order allocation already.
> > The reason we scan it now is that a swap slot may get freed without
> > releasing the swap cache, so a swap map entry will end up in HAS_CACHE
> > only status, and the cluster won't be moved back to non-full or free
> > cluster list.
> >
> > Usually this only happens for !SWP_SYNCHRONOUS_IO devices when the swap
>
> Nit: Please clarify what "this" here means. I assume scanning fragment li=
sts.
> From the context it can almost mean "map entry will end up in HAS_CACHE".

Yes.

>
>
> > device usage is low (!vm_swap_full()) since swap will try to lazy free
> > the swap cache.
> >
> > It's unlikely to cause any real issue. Fragmentation is only an issue
> > when the device is getting full, and by  that time, swap will already
> > be releasing the swap cache aggressively. And swap cache reclaim happen=
s
> > when the allocator scans a cluster too. Scanning one fragment cluster
> > should be good enough to reclaim these pinned slots.
> >
> > And besides, only high order allocation requires iterating over a
> > cluster list, order 0 allocation will succeed on the first attempt.
> > And high order allocation failure isn't a serious problem.
> >
> > So the iteration of fragment clusters is trivial, but it will slow down
> > mTHP allocation by a lot when the fragment cluster list is long.
> > So it's better to drop this fragment cluster iteration design. Only
> > scanning one fragment cluster is good enough in case any cluster is
> > stuck in the fragment list; this ensures order 0 allocation never
> > falls, and large allocations still have an acceptable success rate.
> >
> > Test on a 48c96t system, build linux kernel using 10G ZRAM, make -j48,
> > defconfig with 768M cgroup memory limit, on top of tmpfs, 4K folio
> > only:
> >
> > Before: sys time: 4407.28s
> > After:  sys time: 4425.22s
> >
> > Change to make -j96, 2G memory limit, 64kB mTHP enabled, and 10G ZRAM:
> >
> > Before: sys time: 10230.22s  64kB/swpout: 1793044  64kB/swpout_fallback=
: 17653
> > After:  sys time: 5527.90s   64kB/swpout: 1789358  64kB/swpout_fallback=
: 17813
> >
> > Change to 8G ZRAM:
> >
> > Before: sys time: 21929.17s  64kB/swpout: 1634681  64kB/swpout_fallback=
: 173056
> > After:  sys time: 6121.01s   64kB/swpout: 1638155  64kB/swpout_fallback=
: 189562
> >
> > Change to use 10G brd device with SWP_SYNCHRONOUS_IO flag removed:
> >
> > Before: sys time: 7368.41s  64kB/swpout:1787599  swpout_fallback: 0
> > After:  sys time: 7338.27s  64kB/swpout:1783106  swpout_fallback: 0
> >
> > Change to use 8G brd device with SWP_SYNCHRONOUS_IO flag removed:
> >
> > Before: sys time: 28139.60s 64kB/swpout:1645421  swpout_fallback: 14840=
8
> > After:  sys time: 8941.90s  64kB/swpout:1592973  swpout_fallback: 26501=
0
> >
> > The performance is a lot better and large order allocation failure rate
> > is only very slightly higher or unchanged.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/swap.h |  1 -
> >  mm/swapfile.c        | 30 ++++++++----------------------
> >  2 files changed, 8 insertions(+), 23 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 2fe6ed2cc3fd..a060d102e0d1 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -310,7 +310,6 @@ struct swap_info_struct {
> >                                         /* list of cluster that contain=
s at least one free slot */
> >         struct list_head frag_clusters[SWAP_NR_ORDERS];
> >                                         /* list of cluster that are fra=
gmented or contented */
> > -       atomic_long_t frag_cluster_nr[SWAP_NR_ORDERS];
>
> Nit: please have some comment in the commit log that why remove the
> frag_cluster_nr counter.
> I feel this change can be split out from the main change of this
> patch. The main performance improvement is from only scanning one
> fragment cluster rather than the full list right? Delete the counter
> helps, but in a much smaller number.

RIght, I can split this into two patches, removing the counter has
basically no measurable performance effect, it's just no longer used
after this change.

>
> Chris
>

