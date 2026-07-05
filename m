Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A90C44500
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 17:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA546B00A1; Sun,  5 Jul 2026 13:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463956B00A2; Sun,  5 Jul 2026 13:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32CC26B00A3; Sun,  5 Jul 2026 13:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E45A76B00A1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 13:58:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5562D1C0E4E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 17:58:54 +0000 (UTC)
X-FDA: 84955483788.12.BCE9AF3
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5D0AAC000A
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 17:58:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ou5Amfk8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783274332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qs25MIgpxqt8YOSdzxXD8r1mUPjmEWb4k7h5921s8Sk=;
	b=ZvYjvVcrID7yGbWsvK7VKNvTAb8z5R5WJvtjnEi7hAqIwnD3UuVy8D/aPPwulwkHfH6pU+
	2AP3aMsXb8xR16/yH1VYYCSSMKcx3NW6SjKoPopCQ3r2iHuaS5E12VO4ml/vHedD4eNjkD
	HcW+TZG68vfBhCw9Z+9aPpBEo8mCacY=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ou5Amfk8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783274332;
	b=ObjoFLPra36VhiXQ6JdNQonxeVMaSM1BXPb+o/NlHYWLdRnfzT1f5Mb9/ejbjGZQr3A0hb
	vHzJFN5CgxeoFPSLzgCfnSGbGw+PS/z4dh+bff5LTXxNRl/Ohhpr8/ToLUS9Pz42rMq4xl
	Om6qKLSYAIAhEX/5BJyYFD8o5RMP6Yg=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493c556ada3so140995e9.0
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 10:58:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783274331; cv=none;
        d=google.com; s=arc-20260327;
        b=ZGq8CxA3DjbVMwdDr6GF5jddZqiVVyIOuLvOVSGDGRvxVFbq0Vmi2PHpYP8GT4/+NG
         UJ6ujg/Y//HRdYBrUKf16N9L5QMCmOOiFjeTNkzzVJ1jbcJSHLRBNzohOzQL3DfWvMuf
         3KRMXwOvMMeIqMtuo1vUOPanvikZEKesTSR0X9BrSFaIuMmv89nZtz/5G6P1LHDZfbF6
         eF4NDNGBIl8J/FNbADmEcEJ+TXOWYhJzFOP2ZXZt5II5xCKvWh2/xmSUBrOHJD3dKUr7
         oJBmSH3rIjqg+ro6OxcmJz6yHb5QrnaQJvOFnyVHxH18uufObzmsfbFD/ZJBYlMWeIly
         MHlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qs25MIgpxqt8YOSdzxXD8r1mUPjmEWb4k7h5921s8Sk=;
        fh=2eNQik04EvrHRQKz+B3W9ZAaBjYS2gVW1vwy8n3lIUg=;
        b=gZVDqezF6Ktzvs8wB03eFOYRFsAMHyv04wTaIN5oLCRAZokXCm4AQu3q7HqGlkL2bB
         b2MB/UMTqm6AmJFDduOYx55N1koWM4jJm5bEbsGLGQdgpfHYdPdWyGcnDmQMehFwy0+a
         2q5H3JO0Jtxdq+0MwSy6kYRagdwun1yaRw4yWLRGn72rUbWgrp3rUNVdpQappJbzxHqE
         t/7Qh4/+03NXwllQ6MdZnbB6V0iKhC1Vswr8ugkXhPdkJg6d53chs/IgD0ObzPjk26sI
         rvbBbhOfANevqguEkAGt9BVT6LEFQqsRgDe63AFcqQAPCYFgwABigWOPDfKx4o2jQtbH
         2sew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783274331; x=1783879131; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Qs25MIgpxqt8YOSdzxXD8r1mUPjmEWb4k7h5921s8Sk=;
        b=ou5Amfk8A/7QS3eNlEaBe1EsUKAquIgQLaIOBJFT69Ee/3nCFTU0auBtXEPzKhes9J
         cMkRf38ZrPKwJBcrGh1Xn36U+DgqUDsu84AewIUt91TIQFipZTmUguUlLrz0Dq8pwF+U
         5Nd+TU+APQ27BsV6BXFYdcrz+NTFQQJ1kmD22s6uWb+LWW/Tv/rquUMg3lHGogIXaHe9
         zP2VD+Ng+szmq54WfdXlp7tkUbma73T2JWxu60JxBLWMgrQpDgchok5fireBno7FyybY
         qgdarN7qh7raRvjwlFSlYhyHOXblGTJleKd2UP9MgcxoZGoDth1wcLbCQyVn8n/bBv7Z
         Z1Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783274331; x=1783879131;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qs25MIgpxqt8YOSdzxXD8r1mUPjmEWb4k7h5921s8Sk=;
        b=sgXboneHEIae6lU+SkCZOGvvhoJa6h+my9MYbuOAAAHCrfHBqT/g8t0xDKC+cESyw+
         vsA4SM3G3bW98QjHjAkNB2B0xpkTTiYT8Ymf5YMqAoRE+evcdGfPz91m5hEdD4axTMXb
         v0zjZdPcXbhvu5FwcSNO+SZ+soxaW9oKbL0K6FoxPl2M6pGl5Gmb6YdSyGNUGWazOcsj
         +olHL2M/wVRuwzV9vlc2R1+KfVxb8muJbiT1ng5rMLtCYrR9kfuFZFMjlyc6stdIgRRX
         T1j1sZk6XfOk8Nz/ZxGkdizkJFiq1JB9F4UndDEJ4sgP80C8E4IcyZB1A9k2FutWvfOx
         akhg==
X-Forwarded-Encrypted: i=1; AHgh+RryjR8NRcz4INgEPb+mP32IN1Trh5RNRUCET9ceQzEfz/wjIbPdQKChhIjK9bV6ogWzUTgiqchT3Q==@kvack.org
X-Gm-Message-State: AOJu0YxxUpjbWXRaZIHSkAiGVhv5Gh6iuKKC1lLk4ABIY+ssme1Q8x2K
	1tcVvOJBS9QrK3oiIj4VG4GM+Md/zxGsJteeYgdgNpny9sylN6L22JF/GjYb2wHoRmFpEM5b4gm
	vb7dD9VaQfFyW1r4zz0B/oGYL2HOTl4zymSplPYEb
X-Gm-Gg: AfdE7cksmR/ucJVZLRWDWDoz2DcKaKjY7WT3JXXr75yXqt8sHB6hTDUrl6tL1+zYpjB
	uFM71x3Qv74I2RiMCtePwUQGcTNoPNgMRRXCsI+i4jB3uuvHkwaykbsfxwoo7wrnwUDZTA5DmYx
	KX+trB1+dATaLZvgI8Evc9MJTu6HixyMLHVup3aey5P14qWW0whCGXJFvK2WZIe544F2yIGsmK3
	2HVvLq4k/xkTfCxJWBaOfVrQgerfn6hzVTe1U78wDVfxkTJqnbUuEkklb8xOA5EN+vRhw5L8hSb
	8PY+QGh7WGy3fSI=
X-Received: by 2002:a05:600c:3404:b0:493:b47f:a24 with SMTP id
 5b1f17b1804b1-493d103a1bfmr1152085e9.6.1783274330646; Sun, 05 Jul 2026
 10:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com> <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com> <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
 <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com>
 <DJAY8RKHUO52.28U7OSO06U91J@nvidia.com> <db7d1c9d-3d73-4502-960c-9c2023b90471@kernel.org>
 <DJCAWX74LL8P.2AX46L7QCCWKV@nvidia.com> <CACw3F53jgq5JS+0qkC3Jmj-jkDRHm1H_Z=Xvv-jKoL5XHy11sg@mail.gmail.com>
 <c8ab2147-c6aa-480f-bfe2-55f095b55add@kernel.org> <DJFOHJCQM9YS.23PHVLJ0FKUMD@nvidia.com>
 <DJFOQQ7NYAO5.2REY6S2W78UBJ@nvidia.com>
In-Reply-To: <DJFOQQ7NYAO5.2REY6S2W78UBJ@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 5 Jul 2026 10:58:39 -0700
X-Gm-Features: AVVi8Ceds1x2sFzPXGLOg2h056BJAG-ZyI1MK9aysBYzdG5WTKhnOETH_jSLuRs
Message-ID: <CACw3F50Wxb8jL8nOJBruJCce-f35iow_5Q8jOE-gV+zmUhDocA@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: Zi Yan <ziy@nvidia.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, harry.yoo@oracle.com, 
	osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, ljs@kernel.org, 
	osalvador@kernel.org, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7t7k4km4bc3izzbmw9sp7fmfn6pah6rb
X-Rspamd-Queue-Id: 5D0AAC000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783274332-512004
X-HE-Meta: U2FsdGVkX19lSeEi0xKOlnYCYWlIgEA+QzdLOEMG0mlfPQaRulodyDG1ZXrqQhSJ0+mcVGCz46MwZrRs9CWqHigke5bmk2b0+ntbzm1GVzic6tUrtUDGAfMUoRpTahivR4FkEsPozUy5IjVVTQ/9NkpyGW5+sFVuSP9fvow3KAU1o5ngVmsa+Dl5Q5Hy7RrILR3p2VqzT5Kalj+3l5YHqJmzMtLJmNIu4p0fN37sYeJsL8osO1yjcF5RWG/fP298wzNk9CkL5dJNhBqbLH1pSj9q8t5lbMsKvGLxA0l8c+epO2Dj4m/Jcdy20tfkr98G/CMVvqI6lu6kO45uq8CvLV4F6QENhxwwOBwyXy49dfLXxCtvpJ3+FqpmOTqWJcPM/5u/QnevEBoyQv7Xux/TEbP89wdFnBvDXZNk8xlfAS6XkhNeitIBmR2tH8VPuLZbSjv7SOgElvMD+hkKJhq/N1pjCk0RN5LPJabPSrEGm374bfgb5jGf8QLqhMMSvRGU+lVVGYmY1Q2WQ8zMJQWjHbTjwxaE5NcAuGNuI4vNlW2I6VVAXuJrdPrnnIYlFroVSjvZtTyPibHRiQZgaGHORc6CjYPfdRLHveVcFsKv0rNOZgHAO0fhuuEENapL/lbnHDhAi5KHvqrobZGfW9e6nbxM/elEeqVtkCqt0NhgD8f8IieN35c5VvwQE12jPy9texVPhnmwHlemJ4pCtzHvFM4TdLLddslJaGZYsLQT+DmiRCM1PJsDJGYV80FbPnbUwWFKNtDqSf/CCnM6qdOoKg+6KVSYSD8/Iw41kR97yV/c9yOrGmeVp7h+ugOIFqjOmfrDilpuW/zITBeNc/lqEF8gsV9gWk3A2ZJU/OAX7dqVXfM/J1A7c5TlkfdxC2IrqemSF+e7ClJ5jASJpy3yosKqe9+d/C3Qolv20eEBRCJhcl3lkzkIZnBXo5PEpgKtmzemfggt62sploQQ5+U
 bAc0uczy
 tOd1u2T86TvQEJMs5QK4uvKBg9jtCu5Ny/U+maOrHkCdHOjZR2meZ0dPXybb3AG/89zIB6JxLVEX0fI4G5eCPCIZcp9pAQY9l63fWLkg0CHMcb2p8TR8h0u2HSV1rNsfmYclamBQtjMPxiNMFKFHiMKgneUSkznoH+pDZLfAXevYkDdzU6LeOLmx1IjT+0XTB7OUiuctAe0+5EreUw/oCBsyChLf7nMc2sWh88+QI4dsTU7vJhVrJMrPQWdxy7fJfqIBBoHctP9fnXXCb8n/UHGVdN2INp0932PX8Zbly3sXJTgslUA+0OE9Q07hRjK1s/zayGd0AFzPwG3zmPYddrFYA/jzD4bWLv3/LazkUYyRQ96UFOD0RC1FIZBF3AS3f1xtUnd56HrUi2SnH9X2HbKKe7T8zUeutbglY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 8:32=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Mon Jun 22, 2026 at 11:20 AM EDT, Zi Yan wrote:
> > On Mon Jun 22, 2026 at 4:35 AM EDT, Vlastimil Babka (SUSE) wrote:
> >> On 6/22/26 03:13, Jiaqi Yan wrote:
> >>> On Thu, Jun 18, 2026 at 9:04=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote=
:
> >>>> >> when copy fails with EHWPOISON), the next list_add() is going to =
cause
> >>>> >
> >>>> > I think we should fix compaction_free() (as a separate patch prece=
ding this
> >>>> > one) to not proceed if prepare returns false. It could in theory a=
lready
> >>>> > happen before this patch due to a random memory corruption of stru=
ct page
> >>>> > causing some of the existing checks to fail.
> >>>>
> >>>> Something like below should do the job, plus
> >>>> Fixes: 733aea0b3a7bb ("mm/compaction: add support for >0 order folio=
 memory compaction.")
> >>>>
> >>>> diff --git a/mm/compaction.c b/mm/compaction.c
> >>>> index b776f35ad0200..b2104cbe63477 100644
> >>>> --- a/mm/compaction.c
> >>>> +++ b/mm/compaction.c
> >>>> @@ -1876,10 +1876,12 @@ static void compaction_free(struct folio *ds=
t, unsigned long data)
> >>>>         struct page *page =3D &dst->page;
> >>>>
> >>>>         if (folio_put_testzero(dst)) {
> >>>> -               free_pages_prepare(page, order);
> >>>> +               if (!free_pages_prepare(page, order))
> >>>
> >>> ... for other cases that free_pages_prepare() fails, this is
> >>> absolutely necessary for correctness. Do you mind sending it out for
> >>> formal review (I will be happy to help review).
> >>
> >> I think it would be faster if you just added it to your series with a
> >> Suggested-by: or something? Unless Zi objects. The change is straightf=
orward.
> >
> > Let me send it as a hotfix separately, since Andrew prefers to have a
> > standalone hotfix to avoid splitting a series.
> >
> >>
> >> I'd perhaps do just a
> >>
> >> if (folio_put_testzero(dst) && free_pages_prepare(page, order))
> >>
> >> to avoid the goto?
> >
> > Will do.
> >>
> >>>> +                       goto skip;
> >>>>                 list_add(&dst->lru, &cc->freepages[order]);
> >>>>                 cc->nr_freepages +=3D 1 << order;
> >>>>         }
> >>>> +skip:
> >>>>         cc->nr_migratepages +=3D 1 << order;
> >>>>         /*
> >>>>          * someone else has referenced the page, we cannot take it b=
ack to our
> >>
> >> Maybe in the comment here add also the possibility that _prepare faile=
d().
> >
> > Sure.
>
> Done.
>
> Link: https://lore.kernel.org/linux-mm/20260622-handle_free_pages_prepare=
_in_compaction_free-v1-1-fcf3b14abcf7@nvidia.com/

Thank you, Zi!

>
>
>
> --
> Best Regards,
> Yan, Zi
>

