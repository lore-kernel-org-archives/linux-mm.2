Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E364CC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 14:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD5B6B0093; Thu, 31 Jul 2025 10:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584DA6B0096; Thu, 31 Jul 2025 10:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A906B0098; Thu, 31 Jul 2025 10:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36EA56B0093
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:00:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4D165B6F1
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:00:49 +0000 (UTC)
X-FDA: 83724720618.26.5983F72
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 982F24001A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:00:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ze6OLrBh;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753970447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1dXZWgj+fot6VQlsiFsqWy8IxRr4ctPcghfLIk+tT8=;
	b=ZNzMLWIFX/cEZ+IHj0VHU5V/BhBJhsyQl5cFWyBthYtwLdY13mVEm0++5YjBw/iSxPfY6B
	Lgw0PsS3D/MtbZUwSxqR70irbK4UbmRnJNxKPBVKrYBx2YdTGec+Wwu/Igs9EKxM0fcOx8
	a7AKGHiuSACYonix6BzSv3cmBP14pzc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ze6OLrBh;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753970447; a=rsa-sha256;
	cv=none;
	b=1dIZpuqrwcGtLFyLtYJeBeHBuTKC+dlFcxi5qsGi6kQ7zNjIqOLKCYQX4MURJhQW9W7/Z/
	LVt2Xh7cAvAFKZ95DdcsJlLgIPP/v5UvByXx7jT7WPwTMEO0BvnCxROydJJ7JA8HEfs2hj
	0FJAW4vceWsRa+GDvh24vfbPzUGWcvs=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4aef56cea5bso171181cf.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753970447; x=1754575247; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G1dXZWgj+fot6VQlsiFsqWy8IxRr4ctPcghfLIk+tT8=;
        b=ze6OLrBhr0EjDdrkgn6oJL3Yrske8pc8q+CLJJqJL7EKZneW7XqUnL5Vynqp+5a03e
         hpAghDRV97ePL4/2uzJAGTnkILxdtBrSYfuTnCJHJLfOGKra92lvyV/swj1BkCzobgtM
         WFOcm7SccE6W8s3djk1TmDzf9Da+5WSPQlyW99wxId7SGH7wHlrE8vvw2Zt398DitZJ4
         Snz0uOAkR108D/08QBxPZPgXRYRtgZ9SUgPacL4EeD8OEf4IIRSAMqvLLnMzoyp1ovs7
         Hwr6FLYmCWV1/8RC5M1sDaTWNjs7LxBdnJDG+3/P5535UeulNSdkdPQN55H/+4UJbA0n
         5Zlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753970447; x=1754575247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G1dXZWgj+fot6VQlsiFsqWy8IxRr4ctPcghfLIk+tT8=;
        b=EDvFtyQDn/YuLiLTbHtzCF1dCDIEVq9tniD3KZ8I6Or2XW4FtCq0wLNmRJP+EwOCfm
         0WOd4AdOsTqTpgWp55BIRkTGO+9LAa0hgkYvarLCuLgT/IE2YTBxIk5tHVyZQlNNY8j/
         eEXaq98baM8pkzABMH6qlh+SXIkfoDeL84Kk1KvvSwF2YD4pI262j2WSekKgsFT5RRrZ
         ACpOsWse71LnQ7AHWCwQhIlsmLMhC1y9CXAlHko9paX8Xqm+JqHKVymYliEIwyvNfCub
         lsxmUBfW3R0EZTCrys9pIqHrw4SeB0JjTP+qzkD4xmwPq5YVWbClTm4mL+dXwDxSKDIi
         nA6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTFkUT4XdzXfTm/r3+eDQ2iQnS1vcm2Nw4UQ96WMHQ5nxMlqKOAwFS/xof1Nccy5UHh0um76O6gA==@kvack.org
X-Gm-Message-State: AOJu0YwYQiz0g6CxFmG+m1CW9LyuPkF157D8QKGBYMhnGbTtuSVvm28i
	anncFugpSS6u4pQb1Qdj9luiylU5XGbxZPd333YUEToHs6Ic8cvbmTg4RBGULWpmmLfcANLIQgh
	LCi00jgs4fKBCV5DRaHhjG4M4JchNb3gt6A5+W6QG
X-Gm-Gg: ASbGnct7n/M6HP+r3UJ87mFthmDKKtnrOkBZGa0AtA893IQ7DjJZBSr9u7Z7lBswAT/
	bssGOSsWLoNT9hgisxGRBs+AHOo7FQre0ykgrpUyo1BTtqw0osHqQekNCg7mAnntxIRWxurYeJW
	g8ySbPbVMjqgSm9hsHt5hVhuJ48Aa5q89bFHdn0POIGunoSkQohBGDc/EejKwL+SDE/G6T4NxY5
	4yG5Eh1Rs5C3Xylmhq48HkeGZ5Ql2507OABhA==
X-Google-Smtp-Source: AGHT+IEk4aTDVkOyuIOYsxQ+gdUR7gaQ2ViekFoFAWyX3GuYzKuvzqeg9L9gsG9Ro8y5GeaGz79xs2o9try+V3OViYw=
X-Received: by 2002:a05:622a:8e:b0:4ae:df79:840c with SMTP id
 d75a77b69052e-4aeef75aedcmr4234871cf.0.1753970445923; Thu, 31 Jul 2025
 07:00:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250630031958.1225651-1-sashal@kernel.org> <20250630175746.e52af129fd2d88deecc25169@linux-foundation.org>
 <a4d8b292-154a-4d14-90e4-6c822acf1cfb@redhat.com> <aG06QBVeBJgluSqP@lappy>
 <a8f863b1-ea06-4396-b4da-4dca41e3d9a5@redhat.com> <aItjffoR7molh3QF@lappy> <214e78a0-7774-4b1e-8d85-9a66d2384744@redhat.com>
In-Reply-To: <214e78a0-7774-4b1e-8d85-9a66d2384744@redhat.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 31 Jul 2025 07:00:34 -0700
X-Gm-Features: Ac12FXyFwnVib7u8j59VKulDZYOzHHYnGyXScEgOwOvFCgoc4uSiWy98L6DGLZA
Message-ID: <CAJuCfpGiNve3SnGW5EDrZk5pUAqZbrv0MLaQ-Pzt+Y40U=7iAg@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix missing PTE unmap for non-migration entries
To: David Hildenbrand <david@redhat.com>
Cc: Sasha Levin <sashal@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com, 
	aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7qqmx8t81w7fumd5ismgkaxjfg9dn5st
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 982F24001A
X-Rspam-User: 
X-HE-Tag: 1753970447-839564
X-HE-Meta: U2FsdGVkX1+dyuMSMMFu37jlp4/vh2ghYM+BypNSyhGmp2q8HYNrXp9kMl+zEpS9cmPx4QsRCjhAaDxj2V3AdUBLre8AMqtDy+bAudbAWA7ycBV4SLimrmgD2g9fIKluHUEYKUyxlql5mm3pL3xLtmmTe/JDWXFRz7zfNZ3aML3pNoW3rgtFgnfUxCWw1qbqbuXT+JWGc+lRj/uruQgdFghArenllJRnl/JLdrGTtgQ58DGTzAWVkM8dvWyRKui3UsooPB/gnXYzu1J0LSQorI8sSRACZv7Wpi37wmxJv2mKeB1HqZPbZaqcQjWLt6BJ91XoKohPOtXWmU51squYBDsLpKq0QHOtHeO7Dx5IuEL43Wv4TyotnN+U9pG0+tH+p2QQWBRnZYDR0rTvXePYGRnZVdBcqZUQ8+Xz28Hqy8IW6WcGC+srFO/97c3deaZ7Zz0Cii/KTb9wHveQwJgwcPWa3YqGQPNDfcgKIW73JNh7tE+1HNss0kkX25aorpc1bpvuDs/8kF/dUEr8Oo704VI+y5RhbOcPynoVx/AQht9qG2dC7bmdY4dcyIGMlY4z3PgHYEYulQ1GzQM8g04WY65IqH3FWs5ku361tHTEw3xnYEX79iWHmpYu/tRMtIphX75qiVE/L5W/BdORqpMj9lFH72vM5QUzOVRMAEHEg3auLNPu8M40EsGJ7B3CAJkSrD97Z/5ToSmmPToVFJ5BKdS9Dn5vLfajtEKiigyjjsKeEDyaPtL4QTHkurBle6zuigRzj9Yoy/Vah2+wgdHLB3dPJWWkAWtw/oYQIRASu7GmFTAUkVo8Zk6ZP54OopVBpYv5pNxyFt+qohv5y1jyTdefJzcBSEWNvtwIaga6vKrq8+Ddt2zYQrcN57fSrsXe2KSVgiVPGfXse/NHtHUH8guVbkywkj3bWquGgJwQrrKf2zbUuvUIkQS9y2gi1TzUnrmce3n6/OKNsxQXU+3
 SnnV1tXj
 RqdcmoTzkMB+YoAKhzV8CMD6ST/I432qhMjCTBV3WSqyK03VoJADB9JYj/5znVfV0OEHKOzUV3+iCfRKy8QT8cGJUu/oocKKekdZw4fro1/7pxZzjfdJKL3LJsThqE2J0YkgxqwTaCdiiKa7KAlltoMDGmTy65P88Vu/6hpuXiimJe5P9+xKM9gQTfpc3Tvt2Cw0Hg9OkcA/frZXyPFHLMNdqq9yd2CfyVCaBXikAmH3/S6qudbDaT84W4NPgWf2L6Bh8J4kY625663A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 5:56=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 31.07.25 14:37, Sasha Levin wrote:
> > On Tue, Jul 08, 2025 at 05:42:16PM +0200, David Hildenbrand wrote:
> >> On 08.07.25 17:33, Sasha Levin wrote:
> >>> On Tue, Jul 08, 2025 at 05:10:44PM +0200, David Hildenbrand wrote:
> >>>> On 01.07.25 02:57, Andrew Morton wrote:
> >>>>> On Sun, 29 Jun 2025 23:19:58 -0400 Sasha Levin <sashal@kernel.org> =
wrote:
> >>>>>
> >>>>>> When handling non-swap entries in move_pages_pte(), the error hand=
ling
> >>>>>> for entries that are NOT migration entries fails to unmap the page=
 table
> >>>>>> entries before jumping to the error handling label.
> >>>>>>
> >>>>>> This results in a kmap/kunmap imbalance which on CONFIG_HIGHPTE sy=
stems
> >>>>>> triggers a WARNING in kunmap_local_indexed() because the kmap stac=
k is
> >>>>>> corrupted.
> >>>>>>
> >>>>>> Example call trace on ARM32 (CONFIG_HIGHPTE enabled):
> >>>>>>    WARNING: CPU: 1 PID: 633 at mm/highmem.c:622 kunmap_local_index=
ed+0x178/0x17c
> >>>>>>    Call trace:
> >>>>>>      kunmap_local_indexed from move_pages+0x964/0x19f4
> >>>>>>      move_pages from userfaultfd_ioctl+0x129c/0x2144
> >>>>>>      userfaultfd_ioctl from sys_ioctl+0x558/0xd24
> >>>>>>
> >>>>>> The issue was introduced with the UFFDIO_MOVE feature but became m=
ore
> >>>>>> frequent with the addition of guard pages (commit 7c53dfbdb024 ("m=
m: add
> >>>>>> PTE_MARKER_GUARD PTE marker")) which made the non-migration entry =
code
> >>>>>> path more commonly executed during userfaultfd operations.
> >>>>>>
> >>>>>> Fix this by ensuring PTEs are properly unmapped in all non-swap en=
try
> >>>>>> paths before jumping to the error handling label, not just for mig=
ration
> >>>>>> entries.
> >>>>>
> >>>>> I don't get it.
> >>>>>
> >>>>>> --- a/mm/userfaultfd.c
> >>>>>> +++ b/mm/userfaultfd.c
> >>>>>> @@ -1384,14 +1384,15 @@ static int move_pages_pte(struct mm_struct=
 *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
> >>>>>>                  entry =3D pte_to_swp_entry(orig_src_pte);
> >>>>>>                  if (non_swap_entry(entry)) {
> >>>>>> +                        pte_unmap(src_pte);
> >>>>>> +                        pte_unmap(dst_pte);
> >>>>>> +                        src_pte =3D dst_pte =3D NULL;
> >>>>>>                          if (is_migration_entry(entry)) {
> >>>>>> -                                pte_unmap(src_pte);
> >>>>>> -                                pte_unmap(dst_pte);
> >>>>>> -                                src_pte =3D dst_pte =3D NULL;
> >>>>>>                                  migration_entry_wait(mm, src_pmd,=
 src_addr);
> >>>>>>                                  err =3D -EAGAIN;
> >>>>>> -                        } else
> >>>>>> +                        } else {
> >>>>>>                                  err =3D -EFAULT;
> >>>>>> +                        }
> >>>>>>                          goto out;
> >>>>>
> >>>>> where we have
> >>>>>
> >>>>> out:
> >>>>>   ...
> >>>>>   if (dst_pte)
> >>>>>           pte_unmap(dst_pte);
> >>>>>   if (src_pte)
> >>>>>           pte_unmap(src_pte);
> >>>>
> >>>> AI slop?
> >>>
> >>> Nah, this one is sadly all me :(
> >>
> >> Haha, sorry :P
> >
> > So as I was getting nowhere with this, I asked AI to help me :)
> >
> > If you're not interested in reading LLM generated code, feel free to
> > stop reading now...
> >
> > After it went over the logs, and a few prompts to point it the right
> > way, it ended up generating a patch (below) that made sense, and fixed
> > the warning that LKFT was being able to trigger.
> >
> > If anyone who's more familiar with the code than me (and the AI) agrees
> > with the patch and ways to throw their Reviewed-by, I'll send out the
> > patch.
>
> Seems to check out for me. In particular, out pte_unmap() everywhere
> else in that function (and mremap.c:move_ptes) are ordered properly.
>
> Even if it would not fix the issue, it would be a cleanup :)
>
> Acked-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks for the fix!

>
> --
> Cheers,
>
> David / dhildenb
>

