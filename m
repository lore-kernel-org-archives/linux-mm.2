Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8B31FC9ED3
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 08:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985F66B0005; Sat,  7 Mar 2026 03:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909AA6B0089; Sat,  7 Mar 2026 03:03:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1D86B008A; Sat,  7 Mar 2026 03:03:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 59E646B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 03:03:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A723C1B8A5F
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 08:03:01 +0000 (UTC)
X-FDA: 84518526162.21.763C21E
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id B2C17C000E
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 08:02:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m0sz5oSv;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772870579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtjhCeTQDdoAVsXN8dHO7TB8D+UZfktfl3sVcf19Ny0=;
	b=4fPvnKqqtnm1wLi9xNRSrY+EocuHY3gYpxvj2kvcZuxhzLkyU55t5p1JRk7lFwbvs5ri84
	rAkEceKZIx8HpWOMYfCdq0Qo0hGhc/dBOSRaS91IYPZ4aCfYndc1mvhFt8Xzoli8K5IdSq
	xP9yVGACgWPWEAw9xiX7eFcdOD1FMpQ=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m0sz5oSv;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772870579; a=rsa-sha256;
	cv=pass;
	b=L/C+B9hTv7ElezKkmamLWZg08LtFkuRs9TOxUKr4Et4wjLi+EJO7/S5qsUoxpRDLdu4Hni
	4loVLf4mKW171j7CXTnz0ftiOAe9TwdeN5BNAo7DUaxRXtRq3f2jGNKYq2waPmnkKudPnW
	EobjYKapS+RBYJvvXfYB6oV1JCIjYFY=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5062fc5d86aso88136911cf.1
        for <linux-mm@kvack.org>; Sat, 07 Mar 2026 00:02:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772870579; cv=none;
        d=google.com; s=arc-20240605;
        b=RMlgkoQHp/uwrQW1yeeZdwg1bcgd+YP9qjIiJBeO2t5nMNw4lBvBlsU+cmACH9Hpr0
         JGe7Hz3UpYigCmmmAFta+8t5HWJvN+kxyatXM/9MnU2mFwH9Vdr5yUITXpEVavpKYLdv
         vdI0XgcEKLbCdLtMh1Wgnwv9+5QNoQKsrOcc/TDNFI1DgNDN14+XJeTPQRbggT24PcYI
         hAzFvj8LvW3diXxY/qsaw5qG4zZZZL4ONoNMGgX4ZOFy6YNoNUxXDwy0vyNI83+guWen
         /ik/IMEThoVOp9vsTaBVtU6wxFSJ5zB2pXMqeUPvMbp+bJS9ORToOAHwZjByqdtWOwDv
         JR+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YtjhCeTQDdoAVsXN8dHO7TB8D+UZfktfl3sVcf19Ny0=;
        fh=jWmTozxUfbtXK1aIT+2OwHUMtnqV4zwtbFeh/N/exbo=;
        b=kqRTFZ/vFWxx/mseI83AE5CZZ02ZQAlPnsUERHqPI962QyGSq6lWMKya/TYXoCBlBq
         CA3L3SmDf1QgXOAUaUw9/RjDza5aGDf16pRAJI/wPNR/g1qky0NLoT45cpDnznnJ1F4h
         zTVugmIwjGBR48OO3JID7GYK0HqZmTRkd9SFC5EOjPEfYu/vH+DjzVIJOmdNE42S2DK2
         0HrZ67NwAsaj4TiGfQmilSL5JLRco7Pe6HivKS60gTPui5vEY6uZVWDSEQvbJj0lA6lo
         Z4Ygh4BenW5ZnlY+8P9BbwR71D4o70CKfeL06FHZsbUZx19zNJrD1NIvClcGWxYrqt4P
         LZuA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772870579; x=1773475379; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YtjhCeTQDdoAVsXN8dHO7TB8D+UZfktfl3sVcf19Ny0=;
        b=m0sz5oSvsh5p3j+s48mxbqsHO0m7zA1IXK+knLAzhUXXZAX9K8JJaTCU6aIOkoC4gD
         xYlfASaNyRSDnTmrMPuVROEISO/foZPONCCHC8YrtapleUmHmgrBNUw9oBor0PodrUn5
         cl2qlK9AThep5/aATxjrC/j59uShSRc6wuyc9zXKcX6Ixml67g9e47ptpFLIjdEGovkF
         iZIgb/Uh+OqD1ZMKsZmfUmmbHS0abEwFmLnNWxuW0CpSkDxbTJTzpF9tjFz3J/pwnXFl
         TFZbNp6KKEXKyI1WkXh+M8iu2rVWVyC1oou65AlwHkFl5DySnq8+RAP2zsr4Fusq8vMW
         QzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772870579; x=1773475379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YtjhCeTQDdoAVsXN8dHO7TB8D+UZfktfl3sVcf19Ny0=;
        b=FT1/6KGzRAOqyp14KxXz2i0vBsFJe4ouKylcChwTus1zVAbjhoUrP7oP5vynbiLKPZ
         niztQQgHbAtFy9OAt1TAfW4N8qObs3Ht2K8bbHImIBYYMoxYXd7OiC+3PxiGpCdTqApa
         YMT6UPvGLunkT+PDWdaBBWKoB9IrXrVCcjgmIZYvDd0luGHO4Gua5ys3mtBwTzhOIoDR
         foqCnVUGXXSvApFbX1Jhv/ka4thLEDf9nxZr1Lstbn7W8z9hmU+kyJ457BGTx1aIdnFD
         b5CLiGQxyqGIsqiLO2Mv32saC88OxYYmWQ+vOUoiMyh4HWBEqFoJYXkDmv2UmzDUJUgG
         rSRg==
X-Forwarded-Encrypted: i=1; AJvYcCXE39Dv5gUmTwRs1loZWgVX61dgcovrcbJc6EqfbAcBh+5hiw4OQePgzfae5ImxRwjHo99VWwqDPw==@kvack.org
X-Gm-Message-State: AOJu0Yw0PB11axi9sPZbzETXDIKsOU7FXgbLegmT414XDsOa6CPdDsmx
	fnIfC8pj2J6irrPCrcxnL4r451/fTo1OT4+hYRAeifS3dKO3ogaDPuEXDU7/g+jYVD5aEnOh15D
	vwAhDP3chUBYCddNenWLURiJVeeQI/Ts=
X-Gm-Gg: ATEYQzxtmvxk48Yci945Zz2CdN+GGIFzXydrPNMjvdB9UTG5tGEX8bhdkYYo08QLHtJ
	nkqDJEjLbENdh2avx4iB/MITXcUp+eK04VTuoMsILn1eZ0fjpSD4USTeNrKBWhriaraNDTfa7Vx
	6M+xTQXDjz66DmddPM+F+Wh06KVtEYNX7ImJd/ZZHreVolR9qMSJHTl9CSqX9rGiy0WOQhop+/S
	QRZUCQwL1c/yCY+F5Tg841c7U1dO+c6aMrmbUqUiWV4CzfHmItPj0zUN7Wps8Pl1VZ9pvLhqIi/
	HEZRpg==
X-Received: by 2002:a05:622a:34b:b0:4ed:65d9:162a with SMTP id
 d75a77b69052e-508f491cfe5mr61359861cf.34.1772870578464; Sat, 07 Mar 2026
 00:02:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com> <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
In-Reply-To: <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 7 Mar 2026 16:02:47 +0800
X-Gm-Features: AaiRm51Igc6ecK3xB2tUcUl4HRL0_fGlACMYx6lVkSr1t0qRUoao4ymxCbT83sk
Message-ID: <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B2C17C000E
X-Stat-Signature: w5hrb89fr9hd35jkegq14qyrw9u6o6ib
X-Rspam-User: 
X-HE-Tag: 1772870579-241688
X-HE-Meta: U2FsdGVkX18Q4cDyvrRKTpH6HWhwctbn3ka5TOJ/OJgzqCekrlnArBQaoZwBK8Yzfa0dr2zvZ49z3h6iagA19w98uWoIXOqU2yBZaDhy+nsW2UznNZGCNW+BC4oZrWsG/udhOKJofDL9VNSy8hZoLD5c7ieDkIKDUMXz7Q8KuCFbkgy7pcC2ATm4oC+x8lgGj0JMsihCmzV7T8eMnpgXj5SgIpeDvEekO3NYzzhOAFuQjmGn20dLyPIcJtjlMQ1rDpnQZ4lKXQ+Rci4pToukHcC61Wa8FYY/UbX2Pz2RjL+L/gvtSV4ye62d/BG7h2EcpVSBEBiZ2QEsMaexyRxdwqHZje2rEDAO1VIy1PeAMqmfEo1jKKiSsUXYQ6r4Dj1vCuyNpb38V3KnFZt+xZZq8OJ0uLHUgCHuKutJ9OQsVlRPfEKL0ZAeTYP6FVhXAkjuv5aPwmlywjmN3PJmNHqtJBSa6+X22bRKoqJ+n7TU2L8a5cjjo3r0P/bRLuHWOIZXWpsQ1RvgO5BY77jip4chRSl3MWdLJPwiBwTupT6LEW7YbhftOCdvXpyNsUkFdWCNzeVlmYswS8hLbx2RSiTCn2YQnRMAhsC/+92wrJlxrgMGaFZFKA3+O25moPlS4Vi5TMN9UZXD+GIbcsehL/JIEAo4hAWTrwlKjlzhSrpImisq4lkBq+5c2SJmJFFuSUIzjiAsdrm34po2MjgSkyW6gZEqEXDfthJAk6q2ZedemPH3JpzQstQBq+BaufYz7H03gK/w/eRXJuxaUGjH4QXUM+slvRZj9nAmIBoky8tvbLY/j9M2RV9GRwDwYCLmDSGDUnDSt0ToOj2hfKpYBvTKLWvp3wxtOuukymmhDvPyMsashUWCSkg2ecyRqYgTw9S3Il8sYgajgWjwWCACshonFXxgTU2263y8EGEYAu+TYk9KzvZ/7gYrGTHh4l/ib1ygJytPX4v0Ag0Jgcf+XEJ
 yig6YfC1
 QafXVJTnosO0gfgFPX+5eirsZ6x1u51/P9ANLYMwoNl07sYDFMqLHhluNLHx2zBiexVN2Nweh34d8uSd/XM7sDIoJpLtVNUewIqByBpGxp/PugznFGYsWY4QhnfctUa/ZGIdfF4K+DSQWhc8puT7RjFFtGvo8xOVoKJCa7INxo4wvJ4KRAcR5w1JnLTLfb/iKs7zI1xKsE2TnnSKOTr2+1cb8ArvTlVHnA9JD7B7raLNdCjDtZVVUJpn6VlmhV2eFX6GWigRIMBcX5US9jgEK6VT0bl45Z8a/tepTINYLVxqN+8vfkeVfHlyQAAUKsPcVO8w/itfFzc7sszGWVGLYGaaDOimUCiGmS2q1kpFDu7gZ+TnN+aihJ1UCvtfEYQYlifIgzqqRgEEnkcqsot78Y5LRy/IlYS1hugiE0FPlvjhv6A+sh9JT74T80HNinquXvbqlIcViLC40K3yh6myrEdAALZhCtiFXNzowIDnKFhjh7HVe6nwYFU3Lwdj8pYwfpjutgYZruZO1gCvkiYclj+HBX06jlI9dcECrozmtXs1ZYifU3luQIzgB/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 7, 2026 at 10:22=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 3/7/26 5:07 AM, Barry Song wrote:
> > On Mon, Feb 9, 2026 at 10:07=E2=80=AFPM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >>
> >> Currently, folio_referenced_one() always checks the young flag for eac=
h PTE
> >> sequentially, which is inefficient for large folios. This inefficiency=
 is
> >> especially noticeable when reclaiming clean file-backed large folios, =
where
> >> folio_referenced() is observed as a significant performance hotspot.
> >>
> >> Moreover, on Arm64 architecture, which supports contiguous PTEs, there=
 is already
> >> an optimization to clear the young flags for PTEs within a contiguous =
range.
> >> However, this is not sufficient. We can extend this to perform batched=
 operations
> >> for the entire large folio (which might exceed the contiguous range: C=
ONT_PTE_SIZE).
> >>
> >> Introduce a new API: clear_flush_young_ptes() to facilitate batched ch=
ecking
> >> of the young flags and flushing TLB entries, thereby improving perform=
ance
> >> during large folio reclamation. And it will be overridden by the archi=
tecture
> >> that implements a more efficient batch operation in the following patc=
hes.
> >>
> >> While we are at it, rename ptep_clear_flush_young_notify() to
> >> clear_flush_young_ptes_notify() to indicate that this is a batch opera=
tion.
> >>
> >> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> >> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> >> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >
> > LGTM,
> >
> > Reviewed-by: Barry Song <baohua@kernel.org>
>
> Thanks.
>
> >> ---
> >>   include/linux/mmu_notifier.h |  9 +++++----
> >>   include/linux/pgtable.h      | 35 ++++++++++++++++++++++++++++++++++=
+
> >>   mm/rmap.c                    | 28 +++++++++++++++++++++++++---
> >>   3 files changed, 65 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier=
.h
> >> index d1094c2d5fb6..07a2bbaf86e9 100644
> >> --- a/include/linux/mmu_notifier.h
> >> +++ b/include/linux/mmu_notifier.h
> >> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner=
(
> >>          range->owner =3D owner;
> >>   }
> >>
> >> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)      =
          \
> >> +#define clear_flush_young_ptes_notify(__vma, __address, __ptep, __nr)=
  \
> >>   ({                                                                  =
   \
> >>          int __young;                                                 =
   \
> >>          struct vm_area_struct *___vma =3D __vma;                     =
     \
> >>          unsigned long ___address =3D __address;                      =
     \
> >> -       __young =3D ptep_clear_flush_young(___vma, ___address, __ptep)=
;   \
> >> +       unsigned int ___nr =3D __nr;                                  =
    \
> >> +       __young =3D clear_flush_young_ptes(___vma, ___address, __ptep,=
 ___nr);    \
> >>          __young |=3D mmu_notifier_clear_flush_young(___vma->vm_mm,   =
     \
> >>                                                    ___address,        =
   \
> >>                                                    ___address +       =
   \
> >> -                                                       PAGE_SIZE);   =
  \
> >> +                                                 ___nr * PAGE_SIZE); =
  \
> >>          __young;                                                     =
   \
> >>   })
> >>
> >> @@ -650,7 +651,7 @@ static inline void mmu_notifier_subscriptions_dest=
roy(struct mm_struct *mm)
> >>
> >>   #define mmu_notifier_range_update_to_read_only(r) false
> >>
> >> -#define ptep_clear_flush_young_notify ptep_clear_flush_young
> >> +#define clear_flush_young_ptes_notify clear_flush_young_ptes
> >>   #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
> >>   #define ptep_clear_young_notify ptep_test_and_clear_young
> >>   #define pmdp_clear_young_notify pmdp_test_and_clear_young
> >> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> >> index 21b67d937555..a50df42a893f 100644
> >> --- a/include/linux/pgtable.h
> >> +++ b/include/linux/pgtable.h
> >> @@ -1068,6 +1068,41 @@ static inline void wrprotect_ptes(struct mm_str=
uct *mm, unsigned long addr,
> >>   }
> >>   #endif
> >>
> >> +#ifndef clear_flush_young_ptes
> >> +/**
> >> + * clear_flush_young_ptes - Mark PTEs that map consecutive pages of t=
he same
> >> + *                         folio as old and flush the TLB.
> >> + * @vma: The virtual memory area the pages are mapped into.
> >> + * @addr: Address the first page is mapped at.
> >> + * @ptep: Page table pointer for the first entry.
> >> + * @nr: Number of entries to clear access bit.
> >> + *
> >> + * May be overridden by the architecture; otherwise, implemented as a=
 simple
> >> + * loop over ptep_clear_flush_young().
> >> + *
> >> + * Note that PTE bits in the PTE range besides the PFN can differ. Fo=
r example,
> >> + * some PTEs might be write-protected.
> >> + *
> >> + * Context: The caller holds the page table lock.  The PTEs map conse=
cutive
> >> + * pages that belong to the same folio.  The PTEs are all in the same=
 PMD.
> >> + */
> >> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> >> +               unsigned long addr, pte_t *ptep, unsigned int nr)
> >> +{
> >> +       int young =3D 0;
> >> +
> >> +       for (;;) {
> >> +               young |=3D ptep_clear_flush_young(vma, addr, ptep);
> >> +               if (--nr =3D=3D 0)
> >> +                       break;
> >> +               ptep++;
> >> +               addr +=3D PAGE_SIZE;
> >> +       }
> >> +
> >> +       return young;
> >> +}
> >> +#endif
> >
> > We might have an opportunity to batch the TLB synchronization,
> > using flush_tlb_range() instead of calling flush_tlb_page()
> > one by one. Not sure the benefit would be significant though,
> > especially if only one entry among nr has the young bit set.
>
> Yes. In addition, this will involve many architectures=E2=80=99 implement=
ations
> and their differing TLB flush mechanisms, so it=E2=80=99s difficult to ma=
ke a
> reasonable per-architecture measurement. If any architecture has a more
> efficient flush method, I=E2=80=99d prefer to implement an architecture=
=E2=80=91specific
> clear_flush_young_ptes().

Right! Since TLBI is usually quite expensive, I wonder if a generic
implementation for architectures lacking clear_flush_young_ptes()
might benefit from something like the below (just a very rough idea):

int clear_flush_young_ptes(struct vm_area_struct *vma,
                unsigned long addr, pte_t *ptep, unsigned int nr)
{
        unsigned long curr_addr =3D addr;
        int young =3D 0;

        while (nr--) {
                young |=3D ptep_test_and_clear_young(vma, curr_addr, ptep);
                ptep++;
                curr_addr +=3D PAGE_SIZE;
        }

        if (young)
                flush_tlb_range(vma, addr, curr_addr);
        return young;
}

Thanks
Barry

