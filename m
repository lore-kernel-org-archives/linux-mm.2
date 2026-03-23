Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFC31F483EF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDFC26B0005; Mon, 23 Mar 2026 16:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90206B0088; Mon, 23 Mar 2026 16:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C580A6B008A; Mon, 23 Mar 2026 16:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B4BB46B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:05:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B2A1140D31
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:05:50 +0000 (UTC)
X-FDA: 84578408460.29.12D176D
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4BFCA40006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:05:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hdinH41R;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774296348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSm3pi/p5+viVRprqSKsRJS/Gwafhj+x/zgoAdc82J8=;
	b=JCrOJzTsA/HLoSOQO3CWPd7DGu4630/RsyMMCuvBBjyJ3LWw8XOPXU/oPsH4m6+jsmGL2n
	VzyYL0KEHNoWHb08E0EnrQ22FCGdiIuQq0WkbiKaWGscjrc+/2dgkI47y0wnKOErD3iCg1
	qeXENAyptHuVckAS7czpBkspUaCZMGg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774296348; a=rsa-sha256;
	cv=pass;
	b=a7yVqLt7RSQHeXUhjAVoCcOiXdpwi+R8/sv6hKOjHKB+XhqMYgNv6Xm4G5sYfboJcmlKsc
	DEcP/idboiPHDhvAujbuBcZ/8gqthnZFOfmdlJLM3ErnJYuaju3PlxmBas95EHyHA+jLiQ
	/AXtjhL9PcdBvBfn9pUZ17Tehf2EPjg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hdinH41R;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43b3d9d0695so4247323f8f.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:05:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774296347; cv=none;
        d=google.com; s=arc-20240605;
        b=EW8HSEy7WHyQadIckQTBHuvYGy5zLejYhoHJC581y67L6etmxARM6YE5Sy//J0+xTn
         85ZdiXRjF5FQXsTqCyUmLUewaq1F396KcnucIDRyfks9QlwAROhI35M8pV7h+C91ldC+
         0B1AcJSMtOo035g9bUnPd3I9DRk3gBefQ5gNMGG2ft5/ANS9QZRbHdZjD3mGSg2hthH8
         yV7IUXiuEjqIU2w1GkeGbLSgHiynswmXNxwGLWOYyks2u5QY8BswFq3bQ/+NOyoPmuV4
         F5Ljl9gJ3H+Xa+Zh+GKohtKO32/69C6DX9Bs1Pk1OJ+odWqOr7/OT7gXWUtGJjC3GpdR
         2pFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cSm3pi/p5+viVRprqSKsRJS/Gwafhj+x/zgoAdc82J8=;
        fh=+xCeJiH9RBhbVUGPwhkvJHFOgLmN8fPTWxp+wQdSkkA=;
        b=TeynjouABzIbb1AFK/9zgIJVhEl3/2/NPOl0JFVgZMU5av4XVN9H1gmsNrlvigM3dU
         mPSdHWbHzhgrQxP5n1MVKabJRFJBu9qwGfbYW7tR9EM9MHLmQqXIvKQchRBWOtAN2U08
         s6pOhq2MdZWrkuVHJZb+8cW4N1w/vuLzNiPLWgo6fa2LbnTXrRKxIRrc5RJ509G57JQp
         V8yJO9gLEYQnLrz3btxSyYj5tDbryGnGNaFRvrXrvAfD4C3hu5QrcGNPdDhVov+xjffq
         rq81bKkkkSUj4ZjPlVZUMFKe537T/KcGu7tvfrdIW91Q96FvMOB2rxO6hzwM5/LnAYEA
         MbDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774296347; x=1774901147; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cSm3pi/p5+viVRprqSKsRJS/Gwafhj+x/zgoAdc82J8=;
        b=hdinH41RdTGyK0Xyqfc21vM00tW6cOb+Ql8uLiM4KbC7jKIBYLELOi5tQCs245NFue
         Am9glPYY8WVQZYq4QYSgVATM8jNQ0KTTOxNj2EUGzAX1iRKrwhAbGXMixebBAUU2ukqa
         I32ShZ9zJh//Q1xtqazOK3qKosftPyGw/i0lo7ODlG3AtUYts7txE4D84MJ5IJqZD7pw
         skMi8ngTimwaMXa8tuk6Fxq83LOKqL46t6L1Bdv0S3RuscRzFdDevLIGwaS2vnf3Wz92
         ttKmevaPoIXtb96Cj/+Acq8lyd0Jk2prmA4yslQon1mVHASzaF+zRa+PuGalWIGiIiNY
         5ymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774296347; x=1774901147;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cSm3pi/p5+viVRprqSKsRJS/Gwafhj+x/zgoAdc82J8=;
        b=UAzG2pwbidewOLQt4uQ3yDCKeEuScPkZ/YseqQRK23Uzp4OpzL9L+ZsXcWxL5sarTa
         b89h7SpIhHXqHoHtPUA5xGaTSZFP8GwMF62vQdSSQ411/tfa3arsbrt5gFmaHT9+wc/D
         q8KuGUZGXVEvH0VPqEvR5sUDx0S6modSfU1ou2KTjboo5AwAaX+L5Vh6LEf1Q4Q86zI5
         BWkE65LqnQ0U+mQkpRDNAF8L56U2ieTWCWfK6eOIVeh+IUN2I/QtMrCSQpP1EGJ7S2ej
         pzSZDC9BIvOouewWnG4sTRKn2lj2LTlntUnf1GuPn/pytrNq/uGMpzbYaWvAXEXDJVGO
         KO2w==
X-Forwarded-Encrypted: i=1; AJvYcCVoPUp2QqqctYZJH3NusY2c2jGgHhIA/QbML92en4u5eu3Dixm0JGy+wItVtRn2pfec46Bmrw6MYw==@kvack.org
X-Gm-Message-State: AOJu0YxU3I2W8vDmIXuVViEeq/h0wtgk6LGeV4LrJk+CZbiuZYiRsc9g
	N9X6/CSnEbPx29bM/68M1Bf46pu8v6cUJKK0QCmUnWe+Nek7eRffkTlDbo7Qk+qZbwseMs4Eyk/
	lkJBFKUoT/3hNa+6psL1sb9qvVP/HszY=
X-Gm-Gg: ATEYQzxgJjug+4Bp4Z4D8TL1G0cNYIIjemWaAbU/bHq3ISR3aN9xvNxXaRMwAbk1T9v
	g7bn9KBsib4xXxjdu/gRz2puheYbHZCC0964T6ReaG+7YufldIKEhM6cIBB9ZsEH4q6AY1i7RiB
	N7Iy1dw5a/GAweRLSNHLzUEI2OIPl8CBSyZVrv7s/l/RfWyV2uCVIzBq7/OiknfvAzu+sa5jqFh
	f4bY7UKecoEB/c8wy1+PlP14fFL1IqL+3Cs6Y1O0/ZsyK/n53UJPVlWg/K81fOA2+JMN8Zc+jm0
	hrLpin4KX07GP3OWHqiBbkgD4q/NkL4Z+pWneV3w87lN5EnU1lngs7o=
X-Received: by 2002:a05:6000:290a:b0:439:bee4:8a93 with SMTP id
 ffacd0b85a97d-43b80543fbfmr1328875f8f.12.1774296346222; Mon, 23 Mar 2026
 13:05:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <CAMgjq7AiUr_Ntj51qoqvV+=XbEATjr7S4MH+rgD32T5pHfF7mg@mail.gmail.com>
 <CAKEwX=PBjMVfMvKkNfqbgiw7o10NFyZBSB62ODzsqogv-WDYKQ@mail.gmail.com> <CAMgjq7AzySv801qDxfc8mEkEsFDv4P=_qw0rNOTe0n+qy7Fz6A@mail.gmail.com>
In-Reply-To: <CAMgjq7AzySv801qDxfc8mEkEsFDv4P=_qw0rNOTe0n+qy7Fz6A@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 23 Mar 2026 16:05:34 -0400
X-Gm-Features: AQROBzAzMaxnOtFYtdtVGHbHrUkaMTL891lXMF0vK2wektlQwRdZr3vTHyQqlKE
Message-ID: <CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4BFCA40006
X-Stat-Signature: 1dswcmgxoi9hmfxfu1qa1aexiygiiuzk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774296348-838352
X-HE-Meta: U2FsdGVkX18EurvTifHhoQv5okgWDVrvypUTqEExtLJPU5U0zjUaHiIkzHu7i27TN2txvTwA91UpSG0C2RKkbj3hZHBXP9qo3vy4pRc0hp1F8itTy8PkZos5nJ6fxd9Ukj8e0edkgB7ZBCUrDo/msVaYhjsuZpXnCTF0x/gdwQs4x00jGeIEZf14QbtEEA2BFCeH885CKoZeQgLQi96GA9adNRuwXPXu3etciTwHqcQL75zlYuUoKd9npIp5XVZnv7jicpUD9Gtpw2JoWSIkJThnACFsttm4RW+GXASuS6XUzPw6h1v9ZiGbYSOaEzk1qVIXUnz7t6ZJFzTc+9KYy75dv4AwqqRjZXX0ehnCcA+EUlCj4pcdnDpE+GfClwgNaZPhDuv6NFIOp2HkqoKDZY3ok1Iizsx8F+6V3pqiA7Gh1tfgS6Mkbsp2BTLYnMqujBN+IoqhcUxllWEKFEJajp5FZHLQ3zfF/6j4juSWvCqZsI7Ny+5zmoEvufESkjsyTvKvSfpLk9Y9sbaB8I70ntCCooihwLuLpNPajB8oEn4VPXzPBPrx8Fa/36lmDGwamfyYyUztxXg2BMEJb8KlDG+EJvPRUINP2MnaQ7fjEMvih0s3sIEENKSL5Bo/56CUW2ZK724JR9rREUWnMUz3ctwThHNRxZtTJ6ElUWIjCa2/6XugjdeFetDxnt4syrnJ+hnd/JjeiCRUbS94812MQzh4DJPEnY1WqjSOCw8HQ3Xi8ViteS1RKQGUUxKOjGh64EmfeuFo5TQ+ZT/c8q95BGdFXqN/Isgc0c+OSK7CFUzfsKCd7Tj5+IXxsW+l2D3Jrwtg4sAj6T/yTgVk0E5NkHPDV2lv58I5YEqJz/nZoGQSVdIw5PsNpq7TosTBL0FwWqJIqs99/EG4G4bAB2oK+f/AglY17WWlhcJFltXD2xdjb+/1K9/dqdBXvfibF0ytvAY/9R3AB+d2NEqXneW
 9wkWEUn4
 Ih0Fmfc3XXvube2suwihXkhDfqub3PPoXN/dbuNyiCtEi8j9pefqVoNLWY1WOinzDN+YbVZE5wLknnpsr3zKUwKhEA4sDiGbjBKNjEXIHK6Pj323XwFil75+mBk1q/CWA1IkoCRmNmnRVaPAkf7j7t3jr27B5jjuxwjxs+qYf/PdI+ASBVqr75BWTnIULLcJneRAOCkgv5VLS7B7r3utdfyLV95cWF9gowEmCiTNvT9PhsXwvpXdu3WBJUor+EM34fPgQmIj3SEkt/wGSBEWXhsqvclB3I99esRjOa7YmO1KdnSbUO9KuIoEFzVB/12gEf35Wy/y05yV3/depaD3oXvsUD+gVFo06Mxgu+LIckfm/PW0rj48aY7cDThCyTIJgOw7SRv1m1Sz7EeASKt+lUsX5FRXMUdpXDB3PYZuNBlEP69gffxDDm1+8fp8tHjQKsEpgE2rtQMNrlXU++NIg5QqifdKstHMEDfQ8ZrdUNIGz2jf6D4B8kXqwWWkkU8x17JSGryWXdS6XO8HSUJd5OeHpKwtueY0JwJm0EnTjHKm4Oyyk7t27PHDQ2b+o8o5Hfk1NOipMaeMnwy6SZNPdOMIJp/z/I0/7LNfGf/6mDNYqNU+yg1Fg29iaTEBaYGB/PA3znrnIFkye+RNVVFqRwoTrC7Nxv+Oy2iEQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 12:41=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Mon, Mar 23, 2026 at 11:33=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> >
> > On Mon, Mar 23, 2026 at 6:09=E2=80=AFAM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > On Sat, Mar 21, 2026 at 3:29=E2=80=AFAM Nhat Pham <nphamcs@gmail.com>=
 wrote:
> > > > This patch series is based on 6.19. There are a couple more
> > > > swap-related changes in mainline that I would need to coordinate
> > > > with, but I still want to send this out as an update for the
> > > > regressions reported by Kairui Song in [15]. It's probably easier
> > > > to just build this thing rather than dig through that series of
> > > > emails to get the fix patch :)
> > > >
> > > > Changelog:
> > > > * v4 -> v5:
> > > >     * Fix a deadlock in memcg1_swapout (reported by syzbot [16]).
> > > >     * Replace VM_WARN_ON(!spin_is_locked()) with lockdep_assert_hel=
d(),
> > > >       and use guard(rcu) in vswap_cpu_dead
> > > >       (reported by Peter Zijlstra [17]).
> > > > * v3 -> v4:
> > > >     * Fix poor swap free batching behavior to alleviate a regressio=
n
> > > >       (reported by Kairui Song).
> > >
> >
> > Hi Kairui! Thanks a lot for the testing big boss :) I will focus on
> > the regression in this patch series - we can talk more about
> > directions in another thread :)
>
> Hi Nhat,
>
> > Interesting. Normally "lots of zero-filled page" is a very beneficial
> > case for vswap. You don't need a swapfile, or any zram/zswap metadata
> > overhead - it's a native swap backend. If production workload has this
> > many zero-filled pages, I think the numbers of vswap would be much
> > less alarming - perhaps even matching memory overhead because you
> > don't need to maintain a zram entry metadata (it's at least 2 words
> > per zram entry right?), while there's no reverse map overhead induced
> > (so it's 24 bytes on both side), and no need to do zram-side locking
> > :)
> >
> > So I was surprised to see that it's not working out very well here. I
> > checked the implementation of memhog - let me know if this is wrong
> > place to look:
> >
> > https://man7.org/linux/man-pages/man8/memhog.8.html
> > https://github.com/numactl/numactl/blob/master/memhog.c#L52
> >
> > I think this is what happened here: memhog was populating the memory
> > 0xff, which triggers the full overhead of a swapfile-backed swap entry
> > because even though it's "same-filled" it's not zero-filled! I was
> > following Usama's observation - "less than 1% of the same-filled pages
> > were non-zero" - and so I only handled the zero-filled case here:
> >
> > https://lore.kernel.org/all/20240530102126.357438-1-usamaarif642@gmail.=
com/
> >
> > This sounds a bit artificial IMHO - as Usama pointed out above, I
> > think most samefilled pages are zero pages, in real production
> > workloads. However, if you think there are real use cases with a lot
>
> I vaguely remember some workloads like Java or some JS engine
> initialize their heap with fixed value, same fill might not be that
> common but not a rare thing, it strongly depends on the workload.

To a non-zero value? ISTR it was initialized to zero, but if I was
wrong then yeah it should just be a small simple patch.

>
> > of non-zero samefilled pages, please let me know I can fix this real
> > quick. We can support this in vswap with zero extra metadata overhead
> > - change the VSWAP_ZERO swap entry type to VSWAP_SAME_FILLED, then use
> > the backend field to store that value. I can send you a patch if
> > you're interested.
>
> Actually I don't think that's the main problem. For example, I just
> wrote a few lines C bench program to zerofill ~50G of memory
> and swapout sequentially:
>
> Before:
> Swapout: 4415467us
> Swapin: 49573297us
>
> After:
> Swapout: 4955874us
> Swapin: 56223658us
>
> And vmstat:
> cat /proc/vmstat | grep zero
> thp_zero_page_alloc 0
> thp_zero_page_alloc_failed 0
> swpin_zero 12239329
> swpout_zero 21516634
>
> There are all zero filled pages, but still slower. And what's more, a
> more critical issue, I just found the cgroup and global swap usage
> accounting are both somehow broken for zero page swap,
> maybe because you skipped some allocation? Users can
> no longer see how many pages are swapped out. I don't think you can
> break that, that's one major reason why we use a zero entry instead of
> mapping to a zero readonly page. If that is acceptable, we can have
> a very nice optimization right away with current swap.

No, that was intentional :) I probably should have documented this
better - but we're only charging towards swap usage (cgroup and system
wide) on memory. There was a whole patch that did that in the series
:)

I can add new counters to differentiate these cases, but it makes no
sense to me to charge towards swap usage for non-swapfile backend
(namely, zswap and zero swap pages). You are not actually occupying
the limited swapfile slots, but instead occupy a dynamic, vast virtual
swap space only (and memory in the case of zswap - this is actually an
argument against zram which does not do any cgroup accounting, but
that's another story for another day). I don't see a point in swap
charging here. It's the whole point of decoupling the backends - these
are not the same resource domains.

And if you follow Usama's work above, we actually were trying to
figure out a way to map it to a zero readonly page. That was Usama's
v2 of the patch series IIRC - but there was a bug. I think it was a
potential race between the reclaimer's rmap walk to unmap the page
from PTEs pointing to the page, and concurrent modifiers to the page?
We couldn't fix the race in a way that does not induce more overhead
than it's worth. But had that work we would also not do any swap
charging :)

BTW, if you can figure that part out, please let us know. We actually
quite like that idea - we just never managed to make it work (and we
have a bunch more urgent tasks).

>
> That's still just an example. bypassing the accounting and still
> slower is not a good sign. We should focus on the generic
> performance and design.

I will dig into the remaining regression :) Thanks for the report.

>
> Yet this is just another new found issue, there are many other parts
> like the folio swap allocation may still occur even if a lower device
> can no longer accept more whole folios, which I'm currently
> unsure how it will affect swap.



>
> > 1. Regarding pmem backend - I'm not sure if I can get my hands on one
> > of these, but if you think SSD has the same characteristics maybe I
> > can give that a try? The problem with SSD is for some reason variance
> > tends to be pretty high, between iterations yes, but especially across
> > reboots. Or maybe zram?
>
> Yeah, ZRAM has a very similar number for some cases, but storage is
> getting faster and faster and swap occurs through high speed networks
> too. We definitely shouldn't ignore that.

I can also simulate it using tmpfs as a swap backend (although it
might not work for certain benchmarks, like your usemem benchmark in
which we allocate more memory than the host physical memory).

>
> > 2. What about the other numbers below? Are they also on pmem? FTR I
> > was running most of my benchmarks on zswap, except for one kernel
> > build benchmark on SSD.
> >
> > 3. Any other backends and setup you're interested in?
> >
> > BTW, sounds like you have a great benchmark suite - is it open source
> > somewhere? If not, can you share it with us :) Vswap aside, I think
> > this would be a good suite to run all swap related changes for every
> > swap contributor.
>
> I can try to post that somewhere, really nothing fancy just some
> wrapper to make use of systemd for reboot and auto test. But all test
> steps I mentioned before are already posted and publically available.

Okay, thanks, Kairui!

