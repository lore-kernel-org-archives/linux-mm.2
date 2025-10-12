Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72585CCD184
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 16:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 628FD8E0005; Sun, 12 Oct 2025 12:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9B88E0002; Sun, 12 Oct 2025 12:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8008E0005; Sun, 12 Oct 2025 12:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 36DBA8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 12:49:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4108B61ED
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 16:49:40 +0000 (UTC)
X-FDA: 83990048520.09.BB928D8
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id EFC6B20009
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 16:49:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kmN38eWA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760287779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7XOt9pYTGZkZSu2ppNvovLspExBwSC4+Ysww8r0Eiy4=;
	b=tnBO/Gy00sBR3iXiRmUIg6fLH655NlSGuoCS4JMxZpmekYOLp70x8Qheoobeawax/fmYGe
	ANCEwQ9KaD3cvuFPmE+apH7Bfb0Pp2InRSm2fQyKKHQlbI1gfFgSnMsE38JK0ATk0dLARI
	kOfpsaJWtGZI6osV5oSjmSPcAcDiANw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kmN38eWA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760287779; a=rsa-sha256;
	cv=none;
	b=oE+g/tdAdt0bOmXCcbljQuHl/v7F1OGqy0d57P3bBEYKLTD81YEi+xZjlms1I3pBNoY1yr
	ilEUjmo8UoKYxFRgu4c3XcD9wvVOV+lJugwImQ6sd8rlg5DF/JmfTHdU5onOOd0XN5Q5y9
	RkVvuAy+voVlaR+hdQgTH7ZeFyf+FS0=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b3d196b7eeeso549767866b.0
        for <linux-mm@kvack.org>; Sun, 12 Oct 2025 09:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760287777; x=1760892577; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XOt9pYTGZkZSu2ppNvovLspExBwSC4+Ysww8r0Eiy4=;
        b=kmN38eWA13e2H9A3IjCXWGx+Qm9uyKC+x5MMJbzScGBoYyEfO0vL7ti4P4nLb8dsvl
         UpRIofX5kRGcXDigmjEFBB+46Vv6tkwtwrj8Eo6hZ4P8DjBKnT4W/I1x+WqGkPT18Uiv
         3PQkU8w9pjHfC3unsS5+IJMyqS4mzO4kJWr51/ifT84cZzBItBe/gUvaRhT5jW0igSBr
         n9fgj3kYa3xHcmvZA37Mk3xNd6cij72SsE69lM5kwEocZSmkhtkj2rX2vafcHeJf2Bm4
         f51qam+pNoyz6nggGycqtLG8FUX28z/qiQtEEiX07nkLILU4K7mrxhIbtrJCJ7k0/oO2
         dZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760287777; x=1760892577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7XOt9pYTGZkZSu2ppNvovLspExBwSC4+Ysww8r0Eiy4=;
        b=b9amXBFu4Fo7g0OvJXvFB+jFMCzwmHoU8fotGr214s03I7NQOZzRZGNeXgkRlbflkl
         b0V088NTgEJXyl7Zc6LEJWdfLDFzGs83dHWDLf6sLT4l0I0Wlc/IrsWxN7N+8yS6Sl7J
         6qxJvqaupZHIuUReZbBcUcvYeha+6l/ip2mM8az1zxobgfkfJQFCAxVLnebY5KnBi0HK
         N5e/WiH3330LNbsVugMMNkQ0w+d9ZO7E/At5gGN+Aqb/60i/IswK6r+mqmAjd0+aNN2l
         479UNPvpx1Ie63m1hwif258jZcBhyTPQmhqFfsjGpH1qutiADKvYsoICQHz8yzAisgiY
         peoQ==
X-Gm-Message-State: AOJu0YysFKunTMk8rC2bCnukO5Rq6y2erb8Ne2GREER7r1ghjlFYtuNJ
	AmXdzGeOi7byMFjlMzccwRhSsKpJBPW5YcfYuD/1VmQyKLp3x40vir8N4O/ErkVPLTNv8s2rJJJ
	WBpzxE7S5H5ShsIPuVEBlQHbWCjemFyU=
X-Gm-Gg: ASbGncvgUnLzG2MEjELRUVf5e1kd8xBPyu4ancUunumy51MeKS38wq/VV92+1iyqvey
	Z+p+vkRY0jQI+ENHdzd0CtDx7butHUmJ7Ye/DbtYP4sRq38TjBmhK3ViFi3nGHEp6HqqfS8EwAY
	cxK5+P7hNmWL/qED76zxhxdq1aOyJY/6+hCmWoXwXzSWTmuv+2qEorIvSVbk+IZNoES/TDzGgS2
	Vf/+M8BvTftfZzvCrJt4ucWQCbF3fri0H8u4Ko+K62yXVM=
X-Google-Smtp-Source: AGHT+IFTBvuUZZbE9a7cb6P3kpA3ULFLR99Myk3ietqEoRXe6pHxUxt7cTci1SYV2hJKjY+FPJBIPxKpPjiWn+9LOME=
X-Received: by 2002:a17:907:3daa:b0:b45:60ad:daf9 with SMTP id
 a640c23a62f3a-b50a9a6cb4fmr2086829166b.3.1760287776995; Sun, 12 Oct 2025
 09:49:36 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com> <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
In-Reply-To: <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 13 Oct 2025 00:49:00 +0800
X-Gm-Features: AS18NWCVRaNfz5cs2rL1M42T2Yq0PAar6obsHH9qXEUUMhQYTgqXJVDIsOQCkgM
Message-ID: <CAMgjq7BD6SOgALj2jv2SVtNjWLJpT=1UhuaL=qxvDCMKUy68Hw@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: EFC6B20009
X-Rspamd-Server: rspam03
X-Stat-Signature: q191u61thikz7tzemdbea7qgothfoxyz
X-HE-Tag: 1760287778-470601
X-HE-Meta: U2FsdGVkX182Sepz+U5LBXpOTQhVhs1ENkj7yyz8VcE8UyX2E/uxyIjuqKT/+8ydkW4WQcI1Xuy3G0SK/7k/y7HskPyxF6jJ8HFbZubZHJLEGsdZ1TcaKrU3Sv9RXcYtNh/8bq9N7xiNVAFHvsvXL6pdEy6X56jUOEm9z3IK9Pwq9ofxRtleS7lGDc0URrVUeg/GiLElIzuxookCmVCcBXMBfIPK6YBTY/SsVgHqfpfeyStuXNmpM/7EdcVwkBDl1LzH7jrME2VtfbcNy952KPrFJo47k1MILPO9xw++5iecK9BGuz0acVyiqPigTYP/rka+LSaOkgo0M25STNF6VNzG8W1kkCOxgcH0v+6+55VY6sJoVB2grFPmz3ykziU2WuOc/oY+hfzMTpg1M3z5Yh8uTdlpDCP7PicZypbYZDoG6S2LCuQ/1Ck17hIySNpGCa1x3GdFVQgdSc+akzKpvcGXAVa6Pw1+SD7poYuFTmZph4i8sWcKeNhGwhTe/E35IeTHX0u45TNLSJdvgOpaMJtkOdUpoTm30oQCXofyt/BExonDILNpJGNxZyepjZQj7O+l4sQorUA7UZ4b9O8aXgfCxCgFG5SpK/edqqThATlOQl5l8YanHB5N+v9wfReGvCTAQ4vWFJM5SHi9F/SI8Ec1osmkuEUYD1Cac/k+M4s3MSEtn2YpxLxfh7b5SR7LLt01ZwDDc1ZuwoCG0Swx8tplC8S2cpOajo8hp8iQ/YughKR23YgfAEj+JAFd2bsV2aGIdNOzUzpQ0njUmKHyVaCwEe9EJn7aowDat5SS6SM9XEvxzE7oMHdlkZkt0R2X01OFWoHLki+aZtPTHiXWRK0JNT2xnmmBY8w53QKDttJsecbVyTAYzUCULrlIa3cmku8hhcQ1nxmpWWhzPxbr9PIDZLyZF3eLF4uIVouf1f8Cy7ffa+iqje4Emg6bZW3dJzMAFlTW/x2Al6v+gbv
 0RbeFxmz
 qx3m+FP+W8yTWLxc=
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
>
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
> Add an output argument to indicate the discard device "discard" if needed=
.

The problem I just realized is that, if we just bail out here, we are
forbidding order 0 to steal if there is any discarding cluster. We
just return here to let the caller handle the discard outside
the lock.

It may just discard the cluster just fine, then retry from free clusters.
Then everything is fine, that's the easy part.

But it might also fail, and interestingly, in the failure case we need
to try again as well. It might fail with a race with another discard,
in that case order 0 steal is still feasible. Or it fail with
get_swap_device_info (we have to release the device to return here),
in that case we should go back to the plist and try other devices.

This is doable but seems kind of fragile, we'll have something like
this in the folio_alloc_swap function:

local_lock(&percpu_swap_cluster.lock);
if (!swap_alloc_fast(&entry, order))
    swap_alloc_slow(&entry, order, &discard_si);
local_unlock(&percpu_swap_cluster.lock);

+if (discard_si) {
+    if (get_swap_device_info(discard_si)) {
+        swap_do_scheduled_discard(discard_si);
+        put_swap_device(discard_si);
+        /*
+         * Ignoring the return value, since we need to try
+         * again even if the discard failed. If failed due to
+         * race with another discard, we should still try
+         * order 0 steal.
+         */
+    } else {
+        discard_si =3D NULL;
+        /*
+         * If raced with swapoff, we should try again too but
+         * not using the discard device anymore.
+         */
+    }
+    goto again;
+}

And the `again` retry we'll have to always start from free_clusters again,
unless we have another parameter just to indicate that we want to skip
everything and jump to stealing, or pass and reuse the discard_si
pointer as return argument to cluster_alloc_swap_entry as well,
as the indicator to jump to stealing directly.

It looks kind of strange. So far swap_do_scheduled_discard can only
fail due to a race with another successful discard, so retrying is
safe and won't run into an endless loop. But it seems easy to break,
e.g. if we may handle bio alloc failure of discard request in the
future. And trying again if get_swap_device_info failed makes no sense
if there is only one device, but has to be done here to cover
multi-device usage, or we have to add more special checks.

swap_alloc_slow will be a bit longer too if we want to prevent
touching plist again:
+/*
+ * Resuming after trying to discard cluster on a swap device,
+ * try the discarded device first.
+ */
+si =3D *discard_si;
+if (unlikely(si)) {
+    *discard_si =3D NULL;
+    if (get_swap_device_info(si)) {
+        offset =3D cluster_alloc_swap_entry(si, order, SWAP_HAS_CACHE,
&need_discard);
+        put_swap_device(si);
+        if (offset) {
+            *entry =3D swp_entry(si->type, offset);
+            return true;
+        }
+        if (need_discard) {
+            *discard_si =3D si;
+            return false;
+        }
+    }
+}

The logic of the workflow jumping between several functions might also
be kind of hard to follow. Some cleanup can be done later though.

Considering the discard issue is really rare, I'm not sure if this is
the right way to go? How do you think?

BTW: The logic of V1 can be optimized a little bit to let discards also
happen with order > 0 cases too. That seems closer to what the current
upstream kernel was doing except: Allocator prefers to try another
device instead of waiting for discard, which seems OK?
And order 0 steal can happen without waiting for discard.
Fragmentation under extreme pressure might not be that
serious an issue if we are having really slow SSDs, and
might even be no longer an issue if we have a generic
solution for frags?

