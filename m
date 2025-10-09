Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 687E4CCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 15:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1908E0030; Thu,  9 Oct 2025 11:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81DD8E0008; Thu,  9 Oct 2025 11:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9496E8E0030; Thu,  9 Oct 2025 11:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 814418E0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:33:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CAA713BF9E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:33:11 +0000 (UTC)
X-FDA: 83978969382.02.ECE300D
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 453F7160018
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:33:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Obi4mDvx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760023989; a=rsa-sha256;
	cv=none;
	b=Fqz88blSiuFhn9p5PsJrwdG7V1d9aCG0hwTBAOJ+frOiR4Qg7W9qdpKZqGab/bkZ0a/2Z0
	zyITyihMuf+2lOUmBQ4yZkmQBckd22vkLzyd2D6Ww+CFSpWy0JguvSpWummYhvUSq64lco
	IpN8GtysuXcTwBSLw0GGI12mCXA9av8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Obi4mDvx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760023989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+tq4vS4s3Lq+JCSufOXbf2L061em+hD5hZGExKt/ss=;
	b=n61PUnwzOH/9oRZd4CDHOkIwIR2fVbnnZkJsvhZoM+3GUMCVl6g/t8ZWHCiR0KY/p5NWQX
	+q8KIRTR62sd4LKS7SfY0Mr0BI61yCEAPFEDgANY2bmtuh6STLtxfMNnkyVOzn2ze+5c7d
	3ZbLST5j2HxpYmpIm4LqUEX0UAGXP2I=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-62ecd3c21d3so1794829a12.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 08:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760023988; x=1760628788; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N+tq4vS4s3Lq+JCSufOXbf2L061em+hD5hZGExKt/ss=;
        b=Obi4mDvxM7LBjh/+tWzxni0JbqG6fOglRUCbNsa+WzKJQevQMvklw675u4MQZAj39F
         gQV6n9F/r9D8HGgk830GUOt7FL988gm97E+bPDq3y8+C1HYXvuuPMXpO0ENLnsOHwLde
         plelFtQi0tkb3SMjHhTjeB3vxWc8X3WZDio+dU383GmQpSQ5phSmUb4CtZezsKLSbn/s
         hhdmFvN2/7OnhyYcf9DmkddkwsqjDEzv/7ld1YzxMhqqSB7hkAs6cQtOa739Iva+yE8L
         N9QcTjymiOnSf8fPzEe3zOwlZbn7r4XN6kKsMW1pOUFHHCvQTQV1KXycjxO1KK+ugRwx
         fu6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760023988; x=1760628788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N+tq4vS4s3Lq+JCSufOXbf2L061em+hD5hZGExKt/ss=;
        b=FJB+50EUfON2EZPM6phzs1dAqFJt+VIF7Suqxga8DetyFCeBklIysLMJzgS3/Xu/KB
         fsqm/3PS6sDn639iYBDrBwbxJ+qvg7hRB3/d4yJDA4ALWOuBTpjbOzARX8s46bYDKOnD
         uEaUw3ndLNdB9Lupltansa2NJ1Zm8+zwe1PwyncbpCoCnNNZSLOjNH6wIYGmRUQIbP3X
         zMuT1biOYh6wLFV1wP7Sgf9cZI8u9IWIS4oc+uItfejkFSS1K9CziBsSnkPq+VBuEn4l
         lJ1sX393mKGL/BfNzobc6DfrNP/32aHt5DYCc8fsk/B+rd/nIzOr4+1SWEY12TtOdegu
         OcXg==
X-Gm-Message-State: AOJu0YxahQQ8LuMclxZtyylUBKGnPDuS7vYetUQuJzODojtrYyS4IIaf
	8s+YAlglZuwPGV7N/uFgzrxiYWezFcZgaggaHlhAx6mQ0tyYPeb1HxRu5oM4BfwoLEqkVg2rRme
	gA5up8LmrZJPvrlL/CQvWXrtlU5NQim0=
X-Gm-Gg: ASbGncsuvR7bubWzIDuX5Hrrrv/l56afyjpcFlg+QhjMl2xKuBCQ9PHw2r6yMGsqY0I
	Sk05KYDWIfF+mjSa1rye127tUvRuMHncRTyDfp1YGkGogCYthklpUAG3xkMoeEdJnf2VR4FwcGn
	WnAcvKFw/7VP4WnEUVifeYBPESlUddMbb8OXWcdekzrPEKu7D83de5bcIWQyDbuoQEfVO4Igi0/
	mAbc4PQLHKRkW5PRL0kgyHCCzFIBxe6B3+N7Jjzbw==
X-Google-Smtp-Source: AGHT+IGZB3OdGaKCHbOLV1DjRJE8Flzw9YSn53yJb0TkxYagYC0ihlYs/QmM4gJfLp9P7lvCgppolc6V05mnvXvmf2I=
X-Received: by 2002:a17:906:f586:b0:b3d:530:9f07 with SMTP id
 a640c23a62f3a-b50aa792c58mr944665466b.11.1760023987419; Thu, 09 Oct 2025
 08:33:07 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com> <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
In-Reply-To: <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 9 Oct 2025 23:32:31 +0800
X-Gm-Features: AS18NWCz5oAVWaFi3azMcyhuHXSD7tuBuaq6EfLkmRkR7yYb5BRE-j4_8-wITIk
Message-ID: <CAMgjq7BE_TsmykMQvLMAEheCwgepQMb-X__TG-H7+CUVP3ttYg@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm, swap: do not perform synchronous discard during allocation
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: q1d1utm3puboaocxkasukqrb5kpfr7wm
X-Rspamd-Queue-Id: 453F7160018
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760023989-301316
X-HE-Meta: U2FsdGVkX19bkmRCA9A7wzo6uInSUePYiaNoRc4ysCnBr21PQ3673dSZlf0ApdUaM4SZOUGWKMWd1572s1JLwa/jvcIN4iBGSWf13CeX45NS87Lx31NgsoCKe/ZEZtubVToh4vHx3DitZUw4RWiEYlScxfIL+J5jPjP0MT15y2U4mPpV/5obkwg3ZnfXou4rPYCV7L8tzD0lbS8ql4vAq7lWGoYJJMZtw5T4fqWxShG0eWtCEzl3CY+Qhtg7ynrdrxJl7PcboFIhyGQ9woYI3JE6S6s9bd7r4w6CJQuRaw57xj0cv3iLqMwMHyEDu/a5GmI5Q1pZDl9Pt/rmKdsn+xfWNOZmb2tvbLUHR5DCABzI7dtIJAssx++pl8ty+CAWExw18B73DJFsEqYS9sxItggFeABXxHPaIo9d2hFlatSXwv151pBEvxfmRB90ck60i7F4PJHBpGdjRAJenRl1ej7M9MaynbT4po/qT/xH64olDwRw4MDgHEn8MQz2VbnLkkQH6PzMP1qx5esrqYuwfNe8sHXyutZh4+ZVHS0zKK+iq8tKkeNvjnhZ+M768s9ogPXNwmTN6C228KKCGGRONb55Vaf69vkI5BY3ZxrpyW2gaoJPJDQlpEMWEMxLyHdUFWM5kTNEwgDY4V9hdZWe0dYNSLMDBrUOtaALxRWYIR+KGw7kZES2EZiT7dSgCv46lwEHbZVANGaHSZeFymXe/sML9yOo0nzcglkFgQ3oqjSHPItP9/z0vg0HkykATFnK2D3OIe2HzXESJrqzONkQFT0C/eDkZZ4LiJV6rP+DI8mzV3ID9GBCusOZPB8uR9cgsTnCsoBCQrgS+bPcnWRrDHqgX878iVTjWuB+oNRZz7tvqfmmZtXgkslYoR0hwQTjADZZam0XmdzbB8U82u8N0ITIJWLL2eRZBnRxbnVlWYYe8Xpfi4BLaw2bkbXgDZwgxeKiSWMqzCOMrgNDPiV
 bXJYihc7
 n6m2mY2v8+SnpqXe//JWRf6q43RHoH7ISXJVrdExRne85gaHmI7YKefWH1JBiN7p9E2ErV20yGNVYtgQ9RRf6ew8GF1cB1K0VO/oATRjDWneHVpaN6PI1Prdv25f34HGg4jrwrMyzxPPJDpigenHAzYbMP18PmY5hz7dpEESp0YjOc+aIxakYnfxeFbP3KzsvD6JIu7WOTshwIaw5Den70PzB+plPG6mKu0E1Hcn3f0Y8Vcg1CH1Hmj5aPNFTLnNkWuXlISmcZ/InVY/52XSK6Mgb4p40UxXceDK0cK3JQ9/GrJ3puH+TDXRMA2w9ZsQW2Qcq9fofSj+lti8v+pjwgs81miQx1sYLgAF/J4oqnGZnBFz7sSYGR+pReb4iL1YcP8SWehm/KJW4aNjd2+319tPJlaCOoVqul/+03E1Ya7rukyk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 5:10=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Kairui,
>
> First of all, your title is a bit misleading:
> "do not perform synchronous discard during allocation"
>
> You still do the synchronous discard, just limited to order 0 failing.
>
> Also your commit did not describe the behavior change of this patch.
> The behavior change is that, it now prefers to allocate from the
> fragment list before waiting for the discard. Which I feel is not
> justified.
>
> After reading your patch, I feel that you still do the synchronous
> discard, just now you do it with less lock held.
> I suggest you just fix the lock held issue without changing the
> discard ordering behavior.
>
> On Mon, Oct 6, 2025 at 1:03=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Since commit 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation
> > fast path"), swap allocation is protected by a local lock, which means
> > we can't do any sleeping calls during allocation.
> >
> > However, the discard routine is not taken well care of. When the swap
> > allocator failed to find any usable cluster, it would look at the
> > pending discard cluster and try to issue some blocking discards. It may
> > not necessarily sleep, but the cond_resched at the bio layer indicates
> > this is wrong when combined with a local lock. And the bio GFP flag use=
d
> > for discard bio is also wrong (not atomic).
>
> If lock is the issue, let's fix the lock issue.
>
> > It's arguable whether this synchronous discard is helpful at all. In
> > most cases, the async discard is good enough. And the swap allocator is
> > doing very differently at organizing the clusters since the recent
> > change, so it is very rare to see discard clusters piling up.
>
> Very rare does not mean this never happens. If you have a cluster on
> the discarding queue, I think it is better to wait for the discard to
> complete before using the fragmented list, to reduce the
> fragmentation. So it seems the real issue is holding a lock while
> doing the block discard?
>
> > So far, no issues have been observed or reported with typical SSD setup=
s
> > under months of high pressure. This issue was found during my code
> > review. But by hacking the kernel a bit: adding a mdelay(100) in the
> > async discard path, this issue will be observable with WARNING triggere=
d
> > by the wrong GFP and cond_resched in the bio layer.
>
> I think that makes an assumption on how slow the SSD discard is. Some
> SSD can be really slow. We want our kernel to work for those slow
> discard SSD cases as well.
>
> > So let's fix this issue in a safe way: remove the synchronous discard i=
n
> > the swap allocation path. And when order 0 is failing with all cluster
> > list drained on all swap devices, try to do a discard following the swa=
p
>
> I don't feel that changing the discard behavior is justified here, the
> real fix is discarding with less lock held. Am I missing something?
> If I understand correctly, we should be able to keep the current
> discard ordering behavior, discard before the fragment list. But with
> less lock held as your current patch does.
>
> I suggest the allocation here detects there is a discard pending and
> running out of free blocks. Return there and indicate the need to
> discard. The caller performs the discard without holding the lock,
> similar to what you do with the order =3D=3D 0 case.

Thanks for the suggestion. Right, that sounds even better. My initial
though was that maybe we can just remove this discard completely since
it rarely helps, and if the SSD is really that slow, OOM under heavy
pressure might even be an acceptable behaviour. But to make it safer,
I made it do discard only when order 0 is failing so the code is
simpler.

Let me sent a V2 to handle the discard carefully to reduce potential impact=
.

> > device priority list. If any discards released some cluster, try the
> > allocation again. This way, we can still avoid OOM due to swap failure
> > if the hardware is very slow and memory pressure is extremely high.
> >
> > Cc: <stable@vger.kernel.org>
> > Fixes: 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation fast =
path")
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/swapfile.c | 40 +++++++++++++++++++++++++++++++++-------
> >  1 file changed, 33 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index cb2392ed8e0e..0d1924f6f495 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1101,13 +1101,6 @@ static unsigned long cluster_alloc_swap_entry(st=
ruct swap_info_struct *si, int o
> >                         goto done;
> >         }
> >
> > -       /*
> > -        * We don't have free cluster but have some clusters in discard=
ing,
> > -        * do discard now and reclaim them.
> > -        */
> > -       if ((si->flags & SWP_PAGE_DISCARD) && swap_do_scheduled_discard=
(si))
> > -               goto new_cluster;
>
> Assume you follow my suggestion.
> Change this to some function to detect if there is a pending discard
> on this device. Return to the caller indicating that you need a
> discard for this device that has a pending discard.

Checking `!list_empty(si->discard_clusters)` should be good enough.

