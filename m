Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDBACC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 20:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80D626B0088; Thu, 23 Jul 2026 16:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796E66B008C; Thu, 23 Jul 2026 16:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63AA96B0099; Thu, 23 Jul 2026 16:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33C9B6B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:34:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C260B1C005A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:34:55 +0000 (UTC)
X-FDA: 85021195350.16.C32F1F5
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id D6C1220006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:34:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="p/1QeKad";
	spf=pass (imf13.hostedemail.com: domain of fmayle@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=fmayle@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784838893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEd5Z19QO9gSWI1pJHRYKW58SP1uRktgGVYqFC8ZvOg=;
	b=tLUfIdTCCWXmmbZAVjOnVHc39grfQrVs5OgDQDW58Rq1jkmI9J1ZPt2kb5dam46R+1M6PA
	O12EtvRLqc9S04SYh/2S1FwuUdxS/FDagf5oJkhSYbPz9mPjNItAhWE+tvizphQzQiFdWS
	qH5oLLq6Cr6cpdhlsl1OhaQTDnCKExU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784838893;
	b=FWVjt63qexSJw435IgZDvJEQJ4ycDhe5gjCAOBQIFcP7ikeG8WumwlyEF5rfBxrgBN6nsk
	u77b1Y5Xn5FRBv03JkKn8lkCkigIWhglhljQ5M6Vy3yg8yQyMfTDSz2F9TPpbhKs+JEUf7
	pZVEWNjfx0lVqZgh3noftRGj82vfRgE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="p/1QeKad";
	spf=pass (imf13.hostedemail.com: domain of fmayle@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=fmayle@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so615e87.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:34:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784838892; cv=none;
        d=google.com; s=arc-20260327;
        b=TyQZVISx4FumOIsO2kFxcYIgWoCjirI1I/8oLB/smAvDBavtksvYe/MaWpSYZ4RpUD
         wC2OjMUvUsz+MN+C3vMLYBXAmpPMNSEozQAD32sBY9dtd8g27z6gdlblXdkT2G+gcH3M
         m09Y9urDnrrhIA69nrMNibAvSv/sElL/QAjN4+wPSobzBCfPJ3GUKx6wW41UnuzTlxRW
         N11f0/4w7a1WHZnbD22+Kb5xkB0PYN8YEZdFQYN5kZHAIYmnIzV3yXzUY3h//arNKuDT
         0T6GTUk8DVGxwuyxY7g8WZ/JRmQnzvmitWv2bC5F4jgR8Dgg0WhQHgov80FTI0wx/TPG
         KOQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kEd5Z19QO9gSWI1pJHRYKW58SP1uRktgGVYqFC8ZvOg=;
        fh=tiyGoALUUM1XrW5yM00nq7IxsbIYazEzWYpstsC/qro=;
        b=bxNdNIreDtRphuNoGzRUdg1LM2TeW3Yjn4HRXti2QFC6gBxr9UG2CXJgoMQHJ+k5eW
         t7weHZLleHLDN3pi7mlObSrftT7W2sENOP9BwHFu1YLRe3rKotpN9K65h+AyXNRd2dAB
         hH1hIbt49WEuheSnsST06nC+EAV5A3Cxcks9MTp17SFqfI06EFqVHyF1QlNoiKmarKGY
         bZdS/WZ20z/zXExG2MERTzF0MMnItW+sAoPZPmXTy/uPV+6QTMZSlRygFZOGg9XSgF7k
         33csCnaYL6gI9ycQ60Ty84TcX4zhtqQGNgVMaq4vsBM86QI4snSrHcGdj5UqjuFTVDtu
         abbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784838892; x=1785443692; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kEd5Z19QO9gSWI1pJHRYKW58SP1uRktgGVYqFC8ZvOg=;
        b=p/1QeKad8/B45IUShWh6lfYtjzqhqnPDVntwfgztaxOD8b0Yo875yUx/ysZ73uoMwh
         iRPVCovEnBlUnB0u+qBVFoN0xZusoZgsBg9+i/iXOecqu9GltIu3RazFc3okYq2KsMf9
         uSa2cbi/QfspawyLIp7KVSRO+Vto4UogHZOVrNCg79R5sK37SPXmBaEwrM2CUbDFC6+D
         CNYYnnZeDWgMXY5VukRHbJise6lqZbZkoMh7MyssFps05FrL5bpXtEDnfs7Ih56cPFq4
         bByY5ceeAEG7YeIdz/eU8XRVW9t8lAxifkXxrLjwENJ7dgv2wPTmYaZS5s0/1RefVS30
         xQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784838892; x=1785443692;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kEd5Z19QO9gSWI1pJHRYKW58SP1uRktgGVYqFC8ZvOg=;
        b=Rz3liJb/EbFPutO+fg8VxQIxtEqFjPnCrB/MHST8H8MSQytr5JUZzLFKOP7zfuYi+i
         rQ+JvT6beErN/YUi45ye2z9Bcw/Z1DfNrKE5sWnUUYUcgQBvGW0NnbpcG/v2fnIqNVgA
         Wp6PmstYRKFOiPB7JeBFwVwmWqD6vhVOuvE5wU4uIPx029/OJNEorg1o831Ns8XL7if6
         Czz2Q7VbZ9zRWR3qwf6HMCiLQjyWtlt4Gq4/aEVl8u4AezZVYbNQ0HbyHtNNHDjuHukg
         hcGdFJeFgOhlVElCG9PLTXJ4QV3GXh4Y+T1nRC51SpeJ1CGJdk9FmThrTcZzCtoSlyjS
         mgZg==
X-Forwarded-Encrypted: i=1; AHgh+RqQGaNC59qbPcBAs9fa/AFJattLzJ1IS9eZDZfwNMPku+FBAGUGoM4+Jo1Or5BnmeNDqjnMefVqRg==@kvack.org
X-Gm-Message-State: AOJu0Yx8H3vxHrNjsl3QrBTQ8UKNEyjn2A+sj8iI6va97UBBYKGBDZJp
	jD0zFhVkHEfmAzk5hrOcTMmutMRAdyHKL2LeNqvBEqD1QQGsYM8Y8BxduHD7AgVrRo9/sgGUFAQ
	R2uHevxonlXkFyy7noYj/cdYcts6C9WPW1L94glJT
X-Gm-Gg: AR+sD13huO1D8h7K6348UkNN/hZxm6B6IH7I54Y7SpaMjzq1G7QvqQRxKMSs4h1ctNY
	voQRMnDMxy2u0U5rXDqB+5XrJwIMnegNQdJ9zW/UET321fRlBGZAYPTD8Me52DbUGI+oCp8Tews
	nnlQwB9VRTIfGtFqRyZPXW1TxuJwiSRKczd1vm6cdyUK8KQkCP4QyEWJOUw6HqAZqn1+baikyEq
	wJhw6uXee1pZjxewJSe5LdpShrLaRA9YxBpbiblFnzSNzZpe/P+p6NoT9oRALhSAEz+ZI93/NMb
	ahLV85wdPlQHTGo=
X-Received: by 2002:a05:6512:2256:b0:5aa:79d6:b559 with SMTP id
 2adb3069b0e04-5b2b831579fmr41528e87.0.1784838891615; Thu, 23 Jul 2026
 13:34:51 -0700 (PDT)
MIME-Version: 1.0
References: <202606181547.617a6967-lkp@intel.com> <20260723024527.2822383-1-zhangbo56@xiaomi.com>
In-Reply-To: <20260723024527.2822383-1-zhangbo56@xiaomi.com>
From: Frederick Mayle <fmayle@google.com>
Date: Thu, 23 Jul 2026 13:34:38 -0700
X-Gm-Features: AUfX_my81u5Yiwnp3_sx2Jz9uaienneHL8ShgZjQXkoLqlzrqkAMEhV1zQf24kc
Message-ID: <CAHCxdc64d-6qNBwwSZX8mdz4-V+88No2x0wG4mex5WPXBDE9AA@mail.gmail.com>
Subject: Re: [linux-next:master] [mm] 7b32f64bc5: pts.svt-av1.Preset13.Bosphorus4K.frames_per_second
 45.8% regression
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: oliver.sang@intel.com, jack@suse.cz, akpm@linux-foundation.org, 
	david@kernel.org, kaleshsingh@google.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, lkp@intel.com, oe-lkp@lists.linux.dev, 
	surenb@google.com, willy@infradead.org, baohua@kernel.org, 
	zhangbo56 <zhangbo56@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: q3goyj6myqhate834hjujyh6qta8st6o
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6C1220006
X-HE-Tag: 1784838893-777570
X-HE-Meta: U2FsdGVkX1/18XQ8t6crKSKaLHTMOZFZ1k3pMatfRW/2XT69MohkER1jjO5PMCsxWp7bEZcMx/aMXwhVxYXYZFkUgsI3dtxdnNTNAOgmGhFL2BQvduK/XpZW9rzSat+xdD/T+aOpODg0lx6fDUu2T7LyBq4v+saNNd9XgGYX1zN5q3rj+Vk2Xq47eBiXv2ov4zOjkCnsqd9kCnFZzwvLcFnnR86wsoLFFuBo6tgNbJFzh82HXD0iqJMpF+eRXGmeLhZcRzwjoU7z8PnK4BY6f1vVXvAUWOvvUbJrqA/DdMejDcJiTVztaV0XoAxI9s6ody1qeQTbiciMoHSRLGAMTASpyGPCJGd8CwUKffos7KKxLCEnfh8zMsYq0KlgomkEOmaQZMrS9JktMIG0NyrEM/ZN/E5zGUHJdofF943oH8rf9J90jLolXAJDelS5JMOVZgbMxsOsFgTItQGw+vZ7NSjqd20YrDXTjbUdGScKlQehCRuIIARMOidxXVhth/XdTs1GswWc8g+/dxWKnTkGGGHjc/F0k7VMSjf82UrO5SUD6HEXvhUlirTz6ybJZyhCJlm+D0zbdXPi4XhVEgSA/Bbrb3umcIo5vpPYP/ROwO8Mn0MMZjmL4drYksDscrukvLVpg6UawN0UwPydpet3h4mxniw2ML+Dl82RTbvIUI9XSEsthsYDLv8uklDBS5DaHfs2JDhzEonAcarYnQsKgXyuVDJD7pNWj91EM98jIeSJWK1jMHB2Upguvh9YJxVOo0fNdv8htE0JAD1O5qeWeN/pCIUXdWEQQyG+1V0/Qtg8I38ELtcDmDeQta2CqkUN+6MGrX757BSSOkqHpase/YyEP4/yI11sY8vdNBObY9/I7Dy5tbwiv455ntCwIW8ivgi3Mt/YJxPB+1igiSwmOFSqNbmUml+a4Owaim49BYUSczfGW3JHfJ2SwfzyhWkmCMdJBsNkTTr4Al94bDb
 rgErJ1DN
 T57Mlzead8Z8duFNY3r6S5fsgItTzlrJ2nxH3V5MIk8fr8YL2CVn2nXix1dIvAWBCd3Yxt1+oNSlzMS0mSgoUfRcqDw2R87ZFq6rZXq0/d1Wvz83SY2+EVdPiQGl0L84r3T8cSAsY/k0yt3vrDcWDCT+p4P7E7d5X73ksrQXze2V/6JSZ9hfRsHzxMd9E1X5PsH4LNcDramTSSSDKzZMpl1V1IROxlBf63iNfSEQ77lGKyuN1DLylHnPenqutVprziDMnufsVJX0tbiBxY9ug2PuP8NvsEq6sVHvpGYkkWJEFKYN3R/Ffz38FCihsEDljMA4CeN5jKjmGGukpGCjrF8zUVhhy/4P3CKiVBjXzCISBWPw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 7:46=E2=80=AFPM Bo Zhang <zhangbo0325@gmail.com> wr=
ote:
>
> From: zhangbo56 <zhangbo56@xiaomi.com>
>
> On Thu 18-06-26 16:00:42, kernel test robot wrote:
> > kernel test robot noticed a 45.8% regression of
> > pts.svt-av1.Preset13.Bosphorus4K.frames_per_second on:
> >
> > commit: 7b32f64bc512b40b268776c5ac4d354b325b3197
> > ("mm: limit filemap_fault readahead to VMA boundaries")
> >
> >     169.95 +/- 6%     -45.8%      92.15 +/- 10%  pts.svt-av1.Preset13.B=
osphorus4K.frames_per_second
> >     220.57 +/- 3%    +870.9%       2141        pts.time.major_page_faul=
ts
>
> Hi Oliver,
>
> Could you help test if the below patch fixes the regression?
>
> The 870% increase in major faults suggests that readahead is being cut
> short too aggressively. The current approach unconditionally sets
> _max_index on every fault, which likely prevents readahead from
> prefetching ahead effectively for sequential access patterns.
>
> The fix: only limit readahead when the fault is close to the VMA end --
> if there are fewer pages remaining in the VMA than ra_pages, set
> _max_index. Otherwise, do nothing.
>
> For a 4MB VMA with ra_pages=3D32, only faults in the last 32 pages (128KB=
)
> trigger the limit. The other 99.9% of faults see no change at all.
>
> Similarly, only clamp the read-around start when the fault is near the
> VMA beginning.
>
> This applies on top of 7b32f64bc512 and can be applied with git am.
>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> ---
>  mm/filemap.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 97772a05a18e..9f1e1c9ea6df 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3313,8 +3313,11 @@ static struct file *do_sync_mmap_readahead(struct =
vm_fault *vmf)
>         vm_flags_t vm_flags =3D vmf->vma->vm_flags;
>         bool force_thp_readahead =3D false;
>         unsigned short mmap_miss;
> +       unsigned long vma_end_pgoff =3D vmf->vma->vm_pgoff + vma_pages(vm=
f->vma);
> +       unsigned long vma_pages_left =3D vma_end_pgoff - vmf->pgoff;
>
> -       ractl._max_index =3D vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1=
;
> +       if (vma_pages_left < ra->ra_pages)
> +               ractl._max_index =3D vma_end_pgoff - 1;
>
>         /* Use the readahead code, even if readahead is disabled */
>         if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> @@ -3398,7 +3401,8 @@ static struct file *do_sync_mmap_readahead(struct v=
m_fault *vmf)
>                  * mmap read-around
>                  */
>                 ra->start =3D max_t(long, 0, vmf->pgoff - ra->ra_pages / =
2);
> -               ra->start =3D max(ra->start, vmf->vma->vm_pgoff);
> +               if (vmf->pgoff - vmf->vma->vm_pgoff < ra->ra_pages / 2)
> +                       ra->start =3D max(ra->start, vmf->vma->vm_pgoff);
>                 ra->size =3D ra->ra_pages;
>                 ra->async_size =3D ra->ra_pages / 4;
>                 ra->order =3D 0;
> @@ -3441,7 +3445,12 @@ static struct file *do_async_mmap_readahead(struct=
 vm_fault *vmf,
>         }
>
>         if (folio_test_readahead(folio)) {
> -               ractl._max_index =3D vmf->vma->vm_pgoff + vma_pages(vmf->=
vma) - 1;
> +               unsigned long vma_end_pgoff =3D vmf->vma->vm_pgoff +
> +                                            vma_pages(vmf->vma);
> +               unsigned long vma_pages_left =3D vma_end_pgoff - vmf->pgo=
ff;
> +
> +               if (vma_pages_left < ra->ra_pages)
> +                       ractl._max_index =3D vma_end_pgoff - 1;
>                 fpin =3D maybe_unlock_mmap_for_io(vmf, fpin);
>                 page_cache_async_ra(&ractl, folio, ra->ra_pages);
>         }
> --
> 2.34.1
>

I maybe missing something subtle, but, I think you've changed it from "don'=
t
read beyond the VMA" to "if there is a chance we could read beyond the VMA,
don't read beyond the VMA", which seems like a more complex expression of t=
he
same behavior.

