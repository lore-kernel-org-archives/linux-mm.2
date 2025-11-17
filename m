Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC9CCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 23:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6823A8E0006; Mon, 17 Nov 2025 18:35:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633C38E0002; Mon, 17 Nov 2025 18:35:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522DF8E0006; Mon, 17 Nov 2025 18:35:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7FF8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:35:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB5D487C35
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:35:51 +0000 (UTC)
X-FDA: 84121708902.27.54F2808
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id E1CDB1C0004
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:35:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DoA1VcSD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763422549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ml4qtR6LtIc8g38fWOiTqau4kPBUJcG62FwwCDib3q8=;
	b=Q+vFe25eR0GYVhkD0oICn0zhE+VWqbwhpyXVGUTraag6iwdsIB4xRWFwLdqlQwIzu0MqYM
	8Nxi4LNGdA4q5w07gxcqddtByRzZGYCUpbFgIiFJzISo2pbEf0PRj9JVgc5NaPLBTasnrM
	rv0/3uIGVl5ppEhoeW6RPbNar3CBzaE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763422549; a=rsa-sha256;
	cv=none;
	b=iyVaW6ZJccy0xrjiNFNDbcTxLbu7CGU8q3g9uYYk7mISy/0t87XiX+p9Y7QhEE4ELzjuwg
	OQqUT1kfOqdhUx30hcpac9TZoHrxHBPQtHNyoKoWYYvBYh6C1OpwFfyQ320+pX025rSFvl
	xNj/NK/jwYk/DqGfIVkMmzX19k+pykA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DoA1VcSD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ed67a143c5so121301cf.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763422549; x=1764027349; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ml4qtR6LtIc8g38fWOiTqau4kPBUJcG62FwwCDib3q8=;
        b=DoA1VcSDU6GkOIuQGUqm9u39vfBzk/p6luljchmVntExFtOixPSCOOqzGsxu70kkNe
         Kjm6c4+6/zFLwvFdJjmbaYtr3TkhG+o8Wd1XmZmwA3XRweuAewVUbo1nrQdf9/gk/Ibc
         iIuhUOG7aTTeUBc20C4IjpOGTsqEAfRAwk3fsiHxFd2cnw3nMXF5c0AhXwAIS5/JpjE0
         3p6kKBMZ2aFmjUIN9iEgF864mXFBpiiDg9wfVgzBfoFF6tIexCmJTAxkxehz02nKFbVP
         fn1UG6ggeS+RojuU6j/hFTLy8E9kUmScQC6Imcl7sL/8XSm2RMEaAwEb/u9/BzfYPW+S
         SWBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763422549; x=1764027349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ml4qtR6LtIc8g38fWOiTqau4kPBUJcG62FwwCDib3q8=;
        b=jhR/FGallBYHfDIMxWKBReQZ/3iuri5RqJFy2iOH+nmsI1fgrijhl2OLyutubsLCdZ
         u9H7RFbtGq6xVkQpa+onvhYxJGKUzLYmbIFcuqmK5xVkfTT4u9y3f6T2rOhlq8miB5Fu
         1/hof1E0y0OUsaItSsaXWSe8pSgQeLZOW+G1XHlivgTsAKucOiiZR/5OxggkHNXUqztP
         pjXhW28vo7jyuxwbGQ7jp4dSdLb++ImEjQUU/QF+o51sHncm8WfCW0GCUqWDBUyJ+W5D
         /ozSeaq9DvaOawAGh4mZxFimhOKQnWVtVKYRrt0utJ/fTlizyRMK6j0nCyoLZ1I+vTdy
         oaBA==
X-Forwarded-Encrypted: i=1; AJvYcCWYZjTDRtKPhVJ/KbsmqmulPdwM4jwN/mTJMNfBUIsypGMJ6SYOQhcKmOXWJTFmKLO3EOqkW6SQTw==@kvack.org
X-Gm-Message-State: AOJu0Yy1sEFkl3BJkxAyRIM/EvG0+bG9I74Ehg3LJtIO9LkFQuZL68a+
	sojgQUzxhjGYjtGQZk+O7XrfM8gtYky5h3tWVNW0GGZQenw6w32m0Mpttns2ysSfRIOmR30f9vZ
	fDw+c2Kaft1Kifuphk0cBp7qT36SKvv37yunoUCTH
X-Gm-Gg: ASbGncsJb+vd56QcQW1mIn9Uyb6rjZ+INzYfN/thOemwVFbnfhh24gPfwvmkvVOq0Mk
	92IWW0litSYZ8G+AqUWLq4mqOSLWSawzo5EA+MQoF/DVePxEFdJs82XrEuYedlLgHuKuQBbjGqb
	DeoiwPzLszgFJZJrcAwPAoXY8xK5jhSAeb6GS7rVvL0abjbl1FWKlPQsGUHRpuSFq71qO8SpnBE
	ETcEfi5DTbcSdaZuBZDsUgAeaiXCyPp150IYWNP9dRhBcqvf06rcOcv9NicU0K4ptPgrA==
X-Google-Smtp-Source: AGHT+IF2mQrZXP4K/FSUz1cC3V3y0QVIUWYmp5rF0sW9e0pDB+OF2PUVbWnEbmek0L16W5AgME6YvHnS5CHacP+Rl2M=
X-Received: by 2002:ac8:7dcb:0:b0:4e4:f2b9:55aa with SMTP id
 d75a77b69052e-4ee326e21c9mr816581cf.17.1763422548638; Mon, 17 Nov 2025
 15:35:48 -0800 (PST)
MIME-Version: 1.0
References: <20250607220150.2980-1-21cnbao@gmail.com> <efeb3350-fbdf-408c-92ef-c6eada4a5755@huawei.com>
 <564941f2-b538-462a-ac55-f38d3e8a6f2e@lucifer.local> <c9925b2e-207b-447e-afce-07873406a853@huawei.com>
 <7998c1f1-fd53-45e9-b748-55043522f1c7@lucifer.local> <545c6e40-db22-4964-868a-74893d6ad03f@huawei.com>
In-Reply-To: <545c6e40-db22-4964-868a-74893d6ad03f@huawei.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 17 Nov 2025 15:35:37 -0800
X-Gm-Features: AWmQ_blSXXRZYgiR0iajqY-enzPGSnij5IPzocbApidHVhflQFkxID5iHq6O5rk
Message-ID: <CAJuCfpE=QvAZB9ETMLEi7=tt-+Z9cBA-PxD9YdgvFYC12kydrw@mail.gmail.com>
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song <21cnbao@gmail.com>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Barry Song <v-songbaohua@oppo.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Lokesh Gidra <lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 58jprzooeowchj57jhhszsi5qtt57omu
X-Rspam-User: 
X-Rspamd-Queue-Id: E1CDB1C0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1763422549-953220
X-HE-Meta: U2FsdGVkX1/G77MfMJm6Wv+ii9q07RLXI6UQSVELKVb7kirvgMJlLmNaQH2jKbui3QA+T1UwYEiY8egVHj0JjyKb+gdVO59CsORuGdsowmS7M/njULFMINKmtGi1Kq9CuVPkgfjgAC/XOqMDC70aPor3h3nL/U5x4HNzhf4NzuhGAFZnlMyZpUHvTYGlA0BoDGIg/6eug9ErKjapZXSh7dzA3OdvjThMiN/mpi36gGnwcaGftatf65KPrnIGEUX6H5YsM70z4fVUYo4Hw8tTtxSmpsMFl8HcX9hbvi9GL/W3Gu5McRgT4wkSXYkmVn1mkOXExAu8DV4W8nFFrqLdqH7qoh08yrspMQJm7mnUb4Ph9NkMV15Wlm6OF3rn93iQ88JfeZoNnb9GhoLIbjiRFjLZCdevYpUbdV8mRrIqwX5ticHGSl7HcbxA8Q9klJxrDIUBmzjkW7sfrxuR3zxpYT9iMtkzWpuGZBLSqG9qpUHk5qkX/yIgf3tkPJAsOayuFKIo0hEZeAHm4xG+WGu1wS92RBTUGVarP3fxC3ds1sthoQiXlJ3qTNrCpaYRV5SbLLy7kzbVSiWpXv+G+/biiZZEOgR/bVsclXKr4sl20bAnlGWDWhw7AHWoPnI7gYv/JmAn0ZUx+w1HDXSABU3+1t9OEdipLPNQ5PVe2yrTM2NVdgVWYyP6u/cZxNOxDhMTAjvAgq6z5Mk3wkIJ0d08l17HQBqPmzlkTK/RNTt9irWvBOV/tyN6fViBEdcOdtVHoZO6E9xXgEZcQ8sykITZBWrOoDcriZ4pzdLvIqkRgrCub/jAI0cJ5SgQ8Z567VITPRW+lOV2SPg+pKn0cU1DA6HevKKxex89AsDW42f/rRlhddy01RrJzjhqyJnTGahXIRIuw/XSMMtYLhB42xrIp7L7ql9khp5XbodcZ2oxW4Uos1XsHRlj3UxJ4L7dGH1M8/B6mj1PyvSmC2JJk5v
 +mqzfma6
 PN9Mko9qY4L7fKMy09BVmH+pH3svVVCJKnI1f/OW53PeOIdfCwvWtEt2OVNe9h5vbAv3Oq+qnz3WXEew7M7HfTaXUyGjYVD2MqYvW5e4CGLRRB7emoFs9q9kmcArqo6mFbuv3PX5Qq9sE+XMRGGWO/Wm7Tc3Z1LOXNuKkdnxr0XBD0m8QofrEAwgIsb7/qOF12oXgOkTcZ7z5e9tMwVapMVWhkvjAsX7bmagJdRTR4k/weNkMdKfIv/J4TQefTJnO+x3yDK12A86BT3sRaZEVeuHOlqx4ZSnIn3Ak/8wSbcii4Yf03nfqfWvxPzJc3Sw2T1dypNni+JSljg1yUbcBw8/iUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 5:04=E2=80=AFPM Kefeng Wang <wangkefeng.wang@huawei.=
com> wrote:
>
>
>
> On 2025/11/4 23:21, Lorenzo Stoakes wrote:
> > On Tue, Nov 04, 2025 at 08:09:58PM +0800, Kefeng Wang wrote:
> >>
> >>
> >> On 2025/11/4 17:01, Lorenzo Stoakes wrote:
> >>> On Tue, Nov 04, 2025 at 04:34:35PM +0800, Kefeng Wang wrote:
> >>>>> +static enum madvise_lock_mode get_lock_mode(struct madvise_behavio=
r *madv_behavior)
> >>>>>     {
> >>>>> + int behavior =3D madv_behavior->behavior;
> >>>>> +
> >>>>>           if (is_memory_failure(behavior))
> >>>>> -         return 0;
> >>>>> +         return MADVISE_NO_LOCK;
> >>>>> - if (madvise_need_mmap_write(behavior)) {
> >>>>> + switch (behavior) {
> >>>>> + case MADV_REMOVE:
> >>>>> + case MADV_WILLNEED:
> >>>>> + case MADV_COLD:
> >>>>> + case MADV_PAGEOUT:
> >>>>> + case MADV_FREE:
> >>>>> + case MADV_POPULATE_READ:
> >>>>> + case MADV_POPULATE_WRITE:
> >>>>> + case MADV_COLLAPSE:
> >>>>> + case MADV_GUARD_INSTALL:
> >>>>> + case MADV_GUARD_REMOVE:
> >>>>> +         return MADVISE_MMAP_READ_LOCK;
> >>>>> + case MADV_DONTNEED:
> >>>>> + case MADV_DONTNEED_LOCKED:
> >>>>> +         return MADVISE_VMA_READ_LOCK;
> >>>>
> >>>> I have a question, we will try per-vma lock for dontneed,
> >>>> but there is a mmap_assert_locked() during madvise_dontneed_free(),
> >>>
> >>> Hmm, this is only in the THP PUD huge case, and MADV_FREE is only val=
id for
> >>> anonymous memory, and I think only DAX can have some weird THP PUD ca=
se.
> >>>
> >>> So I don't think we can hit this.
> >>
> >> Yes, we don't support pud THP for anonymous pages.
> >
> > Right, so we can't hit this.
> >
> >>
> >>>
> >>> In any event, I think this mmap_assert_locked() is mistaken, as we sh=
ould
> >>> only need a VMA lock here.
> >>>
> >>> So we could replace with a:
> >>>
> >>>     if (!rwsem_is_locked(&tlb->mm->mmap_lock))
> >>>             vma_assert_locked(vma);
> >>>
> >>> ?
> >>>
> >>
> >> The pmd dax/anon split don't have assert, for PUD dax, we maybe remove=
 this
> >> assert?
> >
> > Well, we probably do want to assert that we hold a lock.
>
> OK, let's convert to vma_assert_locked.
> >
> >>
> >>
> >>
> >>
> >>>>
> >>>> madvise_dontneed_free
> >>>>     madvise_dontneed_single_vma
> >>>>       zap_page_range_single_batched
> >>>>         unmap_single_vma
> >>>>            unmap_page_range
> >>>>              zap_pud_range
> >>>>                mmap_assert_locked
> >>>>
> >>>> We could fix it by passing the lock_mode into zap_detial and then ch=
eck
> >>>> the right lock here, but I'm not sure whether it is safe to zap page
> >>>> only with vma lock?
> >>>
> >>> It's fine to zap with the VMA lock. You need only hold the VMA stable=
 which
> >>> a VMA lock achieves.
> >>>
> >>> See https://docs.kernel.org/mm/process_addrs.html
> >>
> >> Thanks, I will learn it.
> >
> > Hopefully useful, I made it to remind myself of these things as they're=
 very
> > fiddly + otherwise I find myself constantly forgetting these details :)
>
> That should be definitely useful :)
>
> >
> >>
> >>>
> >>>>
> >>>> And another about 4f8ba33bbdfc =EF=BC=88"mm: madvise: use per_vma lo=
ck
> >>>> for MADV_FREE"=EF=BC=89, it called walk_page_range_vma() in
> >>>> madvise_free_single_vma(),  but from link[1] and 5631da56c9a8
> >>>> ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock"), it said=
s
> >>>>
> >>>>     "Note that similar approach would not work for /proc/pid/smaps
> >>>>     reading as it also walks the page table and that's not RCU-safe"
> >>>>
> >>>> We could use walk_page_range_vma() instead of walk_page_range() in
> >>>> smap_gather_stats(), and same question, why 4f8ba33bbdfc(for MADV_FR=
EEE)
> >>>> is safe but not for show_numa_map()/show_smap()?
> >>>
> >>> We only use walk_page_range() there in case 4 listed in show_smaps_ro=
llup()
> >>> where the mmap lock is dropped on contention.
> >>
> >> Sorry, I mean the walk_page_range() in smap_gather_stats() called by
> >> show_smap()  from /proc/pid/smaps, not the walk_page_range() in
> >> show_smaps_rollup() from /proc/pid/smaps_rollup.
> >
> > show_smaps()
> > -> smap_gather_stats(..., start =3D 0)
> > -> walk_page_vma()
> >
> > Because:
> >
> >       if (!start)
> >               walk_page_vma(vma, ops, mss);
> >
> > The only case where start is non-zero is show_smaps_rollup() case 4. So=
 we are
> > already using walk_page_vma() here right?
> >
> > I may be missing something here :)
>
> You are right, I don't check start value :(
>
> >
> >>
> >>
> >>>
> >>>>
> >>>> Thanks.
> >>>>
> >>>> [1] https://lkml.kernel.org/r/20250719182854.3166724-1-surenb@google=
.com
> >>>
> >>> AFAICT That's referring to a previous approach that tried to walk
> >>> /proc/$pid/swaps under RCU _alone_ without VMA locks. This is not saf=
e as
> >>> page tables can be yanked from under you not under RCU.
> >>
> >> But for now it tries per-vma lock or fallback to mmap lock, not lockle=
ss, so
> >> do you mean we could try per-vma lock for /proc/pid/numa_maps or
> >> /proc/pid/smaps ?
> >
> > Probably we could, but I'm not sure if it'd be really worth it, since t=
raversing
> > page tables is a very heavy operation and so optimising it against cont=
ention
> > like this seems probably not all that worth it?
> >
> > Suren maybe could comment on this.
>
> They only operate a single vma(walk_page_vma), I think it is always
> better if we could only hold the vma lock, but wait for Suren comment on =
it.

Sorry for the delay. I had a huge email backlog and just got to this one.
Lorenzo is correct, the comment was warning agains accessing page
tables under RCU only. If you look up VMA under RCU and then lock it,
then you should be safe.

>

