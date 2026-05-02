Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B0FCD3424
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 07:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC5D6B0005; Sat,  2 May 2026 03:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD8B6B008A; Sat,  2 May 2026 03:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C286B008C; Sat,  2 May 2026 03:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78EDB6B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 03:21:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D23C1C03E6
	for <linux-mm@kvack.org>; Sat,  2 May 2026 07:21:29 +0000 (UTC)
X-FDA: 84721634298.04.B3286CB
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id EBCAA40002
	for <linux-mm@kvack.org>; Sat,  2 May 2026 07:21:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mTq0Ji8r;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777706487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpCDGLyqdlQwW4lsWNusxnqIO2tGN0lN9JL64dsGkB0=;
	b=zdtxiOORqvzJMC5kl41sQW3B7CQE/uS07eXQkKnClNgad7XXbjIuwTgziYpS0ZQ6wDfqGF
	040+nkRt1opSepU6+gblWVf59a5rkhqz/1wJVILbFgWKNlqksnUCrsZHhfsi/fxVpsVnNb
	vzy81MaTHu5gIT82upAJnW+5qEsWsiw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mTq0Ji8r;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777706487; a=rsa-sha256;
	cv=pass;
	b=mUoUG02Dwgu2TBAq6mx/fvJFjRSXIEEuyN5d1w9C0+GDMX0aZ7zOq/YlEhWWO3WeUXMAtT
	gtmTj88+VBhktmHjDM3d6KENTitGIomgROMJpC9s5Nu/iVJq7zNSP+7VOYLm2+BJ9N6FKD
	2taauiLTs5bWwLQ5nBDduPM0MG8UEus=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488ad135063so20212405e9.0
        for <linux-mm@kvack.org>; Sat, 02 May 2026 00:21:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777706485; cv=none;
        d=google.com; s=arc-20240605;
        b=SeuIusJHA8Tc/1yTmW1WTLkTFXW66huBU4nyaxjWuLdmCc54eX/55p1Wfr09cs1Hh7
         vRIUva14CJP5QLfVPQBo4HCxmMqbIbxUC+3HsyatUmiCY10E3c8mV0GcZd0gRzPmSV3x
         HigCnXKVqFG9S6j5gTeCJjC3RZR+H9lvN1pY7BeI0iZgD2JvAm8dZa5FDD6X43CXobXx
         IQOyEBXcCA+C8F8wOEIb8cFvi0jEbqWtYswyG5Ti1kQUsodFMY9m+QW+IeZ516M3CAZS
         bok/BGuB11Hkuc3eOmRaiSerdZx5zBHipfnSMQCX31ilKLpnvRESreEX9YtGJ7odhMd7
         5Fwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZpCDGLyqdlQwW4lsWNusxnqIO2tGN0lN9JL64dsGkB0=;
        fh=Xu83I3HZDY1uydEDyHIVhPvdnu9fUEpbWbskOykMuZI=;
        b=dskVyKsvf+QFJ0gV7YC9/XDUSsY6PKaixMKl73NcCiI571x1kI5mK47QTkh2ePet0l
         HLUxqlffAAB012OQZlPsRC1JiaOOcawDjlOfL9MwaY/QNG008H2x6WrKMTUaNz1jkyau
         7ycJHfaXUzZYgdD52FRzosXhAP6H7eq0CNw0L3q50spqoVTvE0Dya9wGnXAT3ujl/eCn
         kzLHYpUVrAV7gFEo93Fo9C1xLIX1IAx6jBRfDx9dVwKK93o7j2IWaMfME4xeHTbxMlff
         vuTPYX6+AHhRBuNZpDVVclJx4EcVfd2Xe8f5Ecb9ndC+r1rJ4GuMGF6ro0qMzA1liKqR
         cDKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777706485; x=1778311285; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZpCDGLyqdlQwW4lsWNusxnqIO2tGN0lN9JL64dsGkB0=;
        b=mTq0Ji8rOdTLfXRksqong7+JHsx0710bg3inRyHufRvyT3M0/v07x37COX33xe0npj
         yfXvJVKyQ7C9hQj5+DSoDTx5VobxJFX7EQ1RJUKpHnVlxss1MAFMalCTautf7Erx5Sis
         91S1AAOEUwWi1dG+ahM67cw28w5swFxTBDjpyTPclfkYrqX4fqIeXuJv2j+8Ls9SPv+M
         5/gCouCXK++9kXbL+LfiuIfkguKFD1LslCsjBgy7IWXwIcUSD571ki8UfwTvA4JbjwT0
         DGJhy2ImBTjQMgklS8alO6TyOh4vUJ0T7g2qMJrg2qsKweHIilE3QtV+UjE9eU4070fq
         QdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777706485; x=1778311285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZpCDGLyqdlQwW4lsWNusxnqIO2tGN0lN9JL64dsGkB0=;
        b=B5URQ3crr1uE/jGiZUJgGvGYLdiNUblzRaqpvqWl0+65XL0R+R4NcPAepEN9qcKD5g
         jML7IGhTZPeLmYWL58S64NNwwv2MtbLut56lgRt+7YSapl5fjIMEKKNBjyJFW5AlXA6e
         hvIncKSXTb6PFJfQ4al8L+haQvV2YcFxWsVe0mNp4V6OcdQYzQJFPV/wIYsAqrP+qtf3
         2FOoJsWPKR53pgJC1vwqPhpLWFlCjlLzEV3C6bftHZL4wGIg4yoTHsCNcVTCdQz6dBH5
         vxkQwPz6b77RzlJgbmLIo5hujKq6aLFJ0VlfGBLuLOwHQDHmJobbSjUKbWMIrjWcKdnz
         Ac4w==
X-Forwarded-Encrypted: i=1; AFNElJ8GcxbDB/VzR1tlL+wxuGwK6AnPenG9BIrKU7IjWKQCXZyKfMUmQ+iwRB9d6Ke69klgIBNIYcu3rw==@kvack.org
X-Gm-Message-State: AOJu0Yx52d6WbrnH5gf6fAQiki7bOLxgH1JzNFRLejH8QD8ewtfhuCmI
	YVPMKfNT9h8Imk8B3PF6UQXWMpFasX+2Yo4DR9lqrhPe2FHFy1cM3csQKbhGuWgy5BcyK/tDEbV
	BIqJHu3Wz1xLEGYcl/L3p9k76kROORLE=
X-Gm-Gg: AeBDievjy+ECLL2yDvC2xWs3NCbbCBEfb/hvCwpqclym2ZFiSfVz5Ixvu+XgAyyAN22
	uj1jzihFgkwuKYEnPHTV2HOKaXb5j/Tc1PWl7OFTdg56CAkbPkVPcPV6Iab90AsZPam55jJjnge
	38oQSwYvZkeTSUxNl/rGPhHex54/AHNGE3MPE4p2KsqMaLVNqrnOmLClPR5qVgG2WflYW9/vJDp
	0W93No2Vfig33ABZczHOCzq7hzCGleV19nx7QJY6eP5gZX2hR0gOE8mR3Vrxr3xSTssgEoNHDA2
	rgXHgvorRxIy1Fjkp6fPlQIx54s8UKJXUZ3mDVQXDf+p46TGWzmWmyEyDvNBwYgPoQ==
X-Received: by 2002:a05:600c:4f47:b0:488:b8bc:6a32 with SMTP id
 5b1f17b1804b1-48a988be27dmr31882145e9.23.1777706485082; Sat, 02 May 2026
 00:21:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
 <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com> <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com>
In-Reply-To: <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 2 May 2026 08:21:11 +0100
X-Gm-Features: AVHnY4JJPCx4iVzK4vXW7jpHkva-oYoA8F0sH-mKu9sI_gFhCrlz3UorVnkOfjY
Message-ID: <CAKEwX=PrfrNys4ao7-d11J7r4pv5VmE8gTU_7iUHaHAKNaFuBQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EBCAA40002
X-Stat-Signature: bkze6uj5d7mmngtsyipzkcm68zd7ngxz
X-HE-Tag: 1777706486-927721
X-HE-Meta: U2FsdGVkX19nSsSNCENawesXVWSD1feebLR7tUOY1mGUH1/F6Vf+uPJn5nFmqwbQye/kN6mNFcRc5vmy1tnnFrLwg/xTXQQBfFl43hGb+Muc2mQSekfbDUVvjBdUcXxDNBQ3NL2rW/ZrP13QYH+MQ1BBo5Bs+PQOVegVqxJWfZJua+jwq5hW4K93J5Rh/SYGmr2915FRM/LMoISMZDGBqFj1MdL1BTAYs//OZnNcWhTzmm1dne6uAjd+Qt7B8DH9hzj0AS2Tb2Dqd7L846Q1mG3BNT1UFwUlaz/uHR6kjR/4BVqdz6hJx47kICu9RmTBMa+PxmtyRsxToazumOiq11IpdymiSS06oZe/bHIDi+VcrZWRoBbM3EBEiWjIKwR9dceBtomGpqAZUWL8xALUqg0rJ7JMvJe+dsil6i3G6fkYOrqn2dSLAZCZFbmIklz47+3/9frE8VPfACU288fq6tnAmpLxBpKeD6Mg5x8KpcdOMi3BuiCGOu99cgjgBFhrVgsG1HspIw+dTuzA0bqFqJtBYepsKKWqOTEXM51OzeV2uXATenqzFN0TQTyyFo3KKdU+2TnvE5oYDCvNfs60V8CJoyV9SCbC8gP/sfkTRxyUxph5zpNxBrP7iLhxZG2Fz9N011vW0Kj+XDH3t/ux8ygpIu8hpghTvuGvkLN5CtzJ3JhUuvigjPGPOfD03AAClCTKdxhmzfW8w0XAaN+s2JbmHhQvRxCXXuSrVmv7SQ2koBdaGkQXUZSfdGljb4JA/rxBB/WWNnHmiXwvZdYxwCb+1VMvn1ROrrSS9wNcwvmbA3pxR+exMzpKE7U3Qq/mhr1axWsh3sGGt7Kk1uzZ9fkNoAVStBBuhEIoFeD2gVBopjB8XtARQF0vSmLFw6VLihRy0imh4Eyzk7AVW60WaJFdJ7hKD1af8GaWF+N5ov53wS1G6TrxINNMixpWG41vpydbTH/PhcRRdE/gvf7
 bJveYGWL
 NEdAkuh1mvQdToywVatpmLZ2UFq01ScqSKlqY4SFWevAfH60ESXkUvSfowMdt9L03dirxI3kBReXG9YvaR7QHBn5zjlAgrTv6dwgPxSAZK9eXzqCUovSQrFPGdWNrGzJtfKxyyxPqGib9xt3u/hTkFKs2wq1DOVG9nvM9AOgFN8OmpgEYeqEQ35uoeK9vkPynnsZSVZYpeedmbOiZ/d82FpaJJvnB+//nPNR/mBhKIjR70KQve0f26VuNnpkG5IJas23NpG6tbkTbfF2BYPirmh78Rg2UBsZrCbcC5/AwdWf4yXxBJ8XBwdvxwmaZYowFvNebLP6x7reJ4CBwdyXgDS6rz2Wdzg6bzIEyi8CApyuQDJzEcgAEzJb1RsbLjtJxRnrmPTFveBgzQwOsIcnlO8VogsSlW8DfsvKYfdQ82bXtVAeHG8PmxUA7qMqelBmX7oYTQ94wS5AIatwqBdwyY/w8xHPCCl+PYjxerztpY5QuWfTnvgdG26Vmqhp7o0/KUaWbt3wVrL5brNWYI1Lb8EWVGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 2:51=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> On Tue, Apr 28, 2026 at 2:17=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Sat, Apr 25, 2026 at 9:13=E2=80=AFPM Wenchao Hao <haowenchao22@gmail=
.com> wrote:
> > >
> > > On Tue, Apr 21, 2026 at 8:16=E2=80=AFPM Wenchao Hao <haowenchao22@gma=
il.com> wrote:
> > > >
> > > > Swap freeing can be expensive when unmapping a VMA containing
> > > > many swap entries. This has been reported to significantly
> > > > delay memory reclamation during Android's low-memory killing,
> > > > especially when multiple processes are terminated to free
> > > > memory, with slot_free() accounting for more than 80% of
> > > > the total cost of freeing swap entries.
> > > >
> > > > Two earlier attempts by Lei and Zhiguo added a new thread in the mm=
 core
> > > > to asynchronously collect and free swap entries [1][2], but the
> > > > design itself is fairly complex.
> > > >
> > > Hi Nhat, Kairui, Barry, Xueyuan,
> > >
> > > Thanks for the review. I agree with the direction and have some ideas=
 for
> > > an alternative approach.
> > >
> > > My approach: first eliminate pool->lock from zs_free() itself, then d=
efer
> > > free to per-cpu buffers with a lockless handoff, and finally reduce
> > > class->lock overhead during drain by exploiting natural class localit=
y.
> > > Achieving both per-cpu and per-class is difficult, so the class->lock
> > > optimization is a compromise =E2=80=94 but one that works well in pra=
ctice.
> > >
> > > 1. Encode class_idx in obj to eliminate pool->lock
> > >
> > > OBJ_INDEX_BITS is over-provisioned on 64-bit. For example on arm64
> > > (chain_size=3D8): OBJ_INDEX_BITS=3D24 but only 10 bits are actually n=
eeded
> > > for obj_idx, leaving 14 spare bits.
> > > We can split OBJ_INDEX into class_idx + obj_idx:
> > >
> > >     obj: [PFN | class_idx (OBJ_CLASS_BITS) | obj_idx (OBJ_IDX_BITS)]
> > >
> > > OBJ_CLASS_BITS is computed dynamically as `ilog2(ZS_SIZE_CLASSES - 1)=
 + 1`
> > > (8 bits for 4K pages, 9 for 64K).
> > > Since class_idx is invariant across migration (only PFN changes), zs_=
free()
> > > can extract class_idx locklessly, then acquire class->lock and re-rea=
d obj for a
> > > stable PFN. No pool->lock needed.
> >
> > How much of the benefit do we get with just these locking improvements
> > without having to defer any of the freeing work?
> >
>
> Hi Yosry,
>
> Thanks for the review. Great question =E2=80=94 we tested exactly this.
>
> With only the class_idx-in-obj encoding (eliminating pool->lock from
> zs_free, no deferred freeing), we measured on two platforms.
>
> Test: each process independently mmap 256MB, write data, madvise
> MADV_PAGEOUT to swap out via zram (lzo-rle), then concurrent munmap.
>
> Raspberry Pi 4B (4-core ARM64 Cortex-A72):
>
>   mode        Base       ClassIdx-only   Speedup
>   single      59.0ms     56.0ms          1.05x
>   multi 2p    94.6ms     66.7ms          1.42x
>   multi 4p    202.9ms    110.6ms         1.83x
>
> x86 physical machine (4-core Intel i7-12700, 2 rounds averaged):
>
>   mode        Base       ClassIdx-only   Speedup
>   single      11.7ms     9.8ms           1.19x
>   multi 2p    24.1ms     17.2ms          1.40x
>   multi 4p    63.0ms     45.3ms          1.39x

Oh man, you are eliminating pool lock here right? This would help my
other patch series a lot too :)

https://lore.kernel.org/all/CAKEwX=3DM5YpR0cQrryX_y4pm_BuxyUWZ_8MbhWodwbf1F=
e=3Dgzew@mail.gmail.com/
https://lore.kernel.org/all/CAKEwX=3DPkFiP+u+ThrzjTKBi+usQf2uuhTZcfB2BNNA8R=
boOFDQ@mail.gmail.com/

Well, the deferred freeing would completely move that contention out
of the way lol. But this would benefit all users, regardless of
whether we're deferring the free step or not (for instance, this will
reduce contention between page fault and compaction, IIUC?) I feel
like you'll get some good numbers testing in a system with compaction
and THP enabled, with lots of swap activities. Which is... a lot of
server setup :)

If the deferred freeing is too controversial, this smells like
something that should be upstreamed independently.

>
> Single-process shows modest improvement. With multiple processes,
> each read_lock/read_unlock atomically modifies the shared rwlock
> reader count, and the cost of these atomic operations increases
> with more CPUs accessing the same cacheline concurrently.
> Eliminating pool->lock removes this overhead entirely.
>
> This only works on 64-bit systems where OBJ_INDEX_BITS has enough
> spare bits to fit class_idx. 32-bit systems don't have the room.
> I'm still working on the compile-time gating to properly enable
> this based on architecture and page size configuration.

/*
* The pool->lock protects the race with zpage's migration
* so it's safe to get the page from handle.
*/
read_lock(&pool->lock);
obj =3D handle_to_obj(handle);
obj_to_zpdesc(obj, &f_zpdesc);
zspage =3D get_zspage(f_zpdesc);
class =3D zspage_class(pool, zspage);
spin_lock(&class->lock);
read_unlock(&pool->lock);

It's basically just this blob right?

>
> > As others have pointed out, I don't want to just defer expensive work
> > without understanding why it's expensive and running into limitations
> > about why it cannot be improved without deferring.
>
> For the deferred freeing part: the class_idx-in-obj optimization
> addresses the multi-process scenario where concurrent atomic
> operations on pool->lock become expensive, but does not help
> single-process munmap. Deferred freeing moves the entire zs_free
> cost (including class->lock and zspage freeing) off the munmap
> hot path, which benefits even single-process workloads. The two
> optimizations are complementary.

+1 :)

