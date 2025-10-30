Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF1CFCCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 01:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A1C8E01AA; Wed, 29 Oct 2025 21:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352148E0106; Wed, 29 Oct 2025 21:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2670C8E01AA; Wed, 29 Oct 2025 21:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1139C8E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:06:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E56F14097B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:06:08 +0000 (UTC)
X-FDA: 84052989216.18.AD95481
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id BE2D8C0009
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:06:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i0vRL+NO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761786366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YeisVXfwZ0KrQFCLeQpidsEhsQ07SALEwA1Kf0DOiTM=;
	b=enyCSSh+6f+6wBtyXfz+ldjC1OADWKpawXMLWcaGOfDNnHid9F74CiVSwm3aelNWRjjhXw
	Zfer22vGqXPF7t4NKVCtp5vZwJMV9PEeg0mNjMOelmRNti7TuFNJWVXjXWqyHXFmD8O5b/
	Rnf0szrRpR0E3aJhqD2gDIox30ItHnE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761786366; a=rsa-sha256;
	cv=none;
	b=dm0OJ4aP8RtED8DgFLCquDDHtMqTpVlY0yv+gA5L1wdyYlYUy3DHJ/BYFfbG0f9t+6W2jI
	O9ObzeIQyOOPP69hvtgnMztSfPFDj2qUPPbmgq/QoPOefL0cBpPSmra7odooNQNl2dnUoc
	erWSseRqDAn2Giy6IKbh17VulE90L+A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i0vRL+NO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ecfafb92bcso93281cf.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761786366; x=1762391166; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YeisVXfwZ0KrQFCLeQpidsEhsQ07SALEwA1Kf0DOiTM=;
        b=i0vRL+NOJOyPGdo726hHI5wieDwlRc2gK3weOQwW7e07PbnT0BgUz+Y7NuGmJopwdy
         JpiVo4+bBO3WEMShHSdPJx6OLO4LB+Oas5oUqax4L52fPHWveKkW22tXq896hvE6Co1V
         MfKgnF1RGXQZMOy0Ra8Aoecg6ylF/VmTysXW+1r37Gdp7GZTlAMfopw+YQSZbjiznKuW
         8fWfP09BzjLK7I8MavToY3Nj+gB3wGSLXGxFJ0Tq0nbQn3EaDMDaCpQwnR4ZPH2WuT6e
         FdM+9WWL31cj18ccpAaSaHwl5mQhTNvBvW7plNtVZWom7eHSgwT0CApcGapmG4feW71q
         iy5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761786366; x=1762391166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YeisVXfwZ0KrQFCLeQpidsEhsQ07SALEwA1Kf0DOiTM=;
        b=cW5j+h3+oFtnrMu6F3W9tEOGJ6pM3pyd9ZfBsB8eYn3jWED+NRykllr1bY0+xPI1JB
         Mf+8lWciE7+5+Hu+XpbgaZXXZIgT21IkFhuS/QwZvqtTpDbu4978uEwOj7Iw+ls7ff9G
         uPjEKxWh5lQOBw7D7a7aZ46OyYdiamB63JnNhxy9Vb/y6wS0tANDrwC9eEh/z2I4/DUU
         jfoGSxK/frRe+GAopvD5uToTn1KacZNB92hiHisUVTMwS6jsbXjG1cCOzNpd01uhej+X
         kZ85DYoXV5nMT7BMPyLP3FG+Uos480lrG76myVbss56tKnt6f4aeG/M20mLXFCb6902R
         uQVg==
X-Forwarded-Encrypted: i=1; AJvYcCVMDxGap61WquuCdSTcqixFURmm0P5OYQIUZEzQhq+rgMb7C61cJFNjaIoY6WDzROdV365afiUfEA==@kvack.org
X-Gm-Message-State: AOJu0YxFsjk02xgC3Wta1NM/Vd9dMjO7Yw54/W+DMgOwRtaaE69yBRzR
	M5RVYQ1Czt4xj1tI02dTTkmwwDMeQxNP+qvFhD1fk01z9DErTWJVCLBM3OnqGKCqCith3eVBoZo
	8vRMu9oNoc6O/P/iGbbv508PrCCnYHRKq7/F9Ghzv
X-Gm-Gg: ASbGncuSejuxhxbeGE2GRCrBrq9P5yZzscoiZLbhZIy1WimNcuc4As/8o0CV3eTcMnc
	uPcHX0gzieL+TEC0HvpZIMK73jdBg8+2URjhTWwdSjcQk8wgOez/C6ditgU9+iB5kyxIQN7DjWf
	tJLhqaImL5AtjdbJrSPPJjH0nPE5nAOVp53OSVKCgGLOMwKdfNcb5cmqdtkF4MDNz/ZeVc2nwQT
	v95+3pVFEh+R/Cxqfs/IYQSHdjAHuewL3B6YGLPeHbfua3GKfnyUY0beOg=
X-Google-Smtp-Source: AGHT+IEXE/t7QfqvUm8ZaTuQf2esMJpzDPElyDqBGV0RGdjV360thSADyS4N9hyRQjOYV3uhrbmzYlXY5QHiRxHN85o=
X-Received: by 2002:ac8:59cd:0:b0:4e8:85ac:f7a7 with SMTP id
 d75a77b69052e-4ed23bf1436mr1717491cf.9.1761786365282; Wed, 29 Oct 2025
 18:06:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1761756437.git.lorenzo.stoakes@oracle.com> <7de40603015dee82970f5d37332a6d5af7532063.1761756437.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <7de40603015dee82970f5d37332a6d5af7532063.1761756437.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 29 Oct 2025 18:05:54 -0700
X-Gm-Features: AWmQ_blocebJr4y0y6DBwQJ-I85ZwTlE3oPMzhX8CLpjz_qVxCW5kze5g7B-HN8
Message-ID: <CAJuCfpEefC1nAQ6TgKcq7osX4Zyr_dLhiR5W0So=CReed+LSuw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: introduce VM_MAYBE_GUARD and make visible for
 guard regions
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Andrei Vagin <avagin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: 9qy6bx3uybjza54fcwaygdts3zy6jsb8
X-Rspam-User: 
X-Rspamd-Queue-Id: BE2D8C0009
X-HE-Tag: 1761786366-591663
X-HE-Meta: U2FsdGVkX182UlRKseTrEhjVck2gAvEvsss3NKLiCdcH3BygNEYObjNRl6u5hE1TZZ/TbE492dspw3eiM09uITttf3xgl4Dw8dxael3kC8wF7na4AP6zuBFNUBnFb1i9MR8Wc8YvWfPttodGLXrhzYuQ9Hi6BXSe0nY4edRxlJbf7LAoDZRm8OBluUYLIU9qQIYvSqYvsaUumWtwKbU4X62l3s1ISEBI3pZ736SSaK87i5EQOY5B9YztM5kP/nDP8K2+/62b6FC0z/W2302qmtdqTm3SVFvUwHfA3fMYx33tmNdpYUWrwpYsmBHqgVpW6AP2PQ9Lohble9FySvp5zkQO1vkZyKNQgb7YFWwKI7uf0FtyxMpGjSE4sNEYX8M+dofdAa1ziuQjQRyV9VyNPQjLnkhD3btelw7KFDM3Ro945kit56lQS73g9coJVAXaLle2TqaqBHCb4aYvQsy5696kg+y2/polEPPEv9fMr03f1drNuWNHPyT1Q+JyNyL6LZPlLyD6LkRalt2QM3PCf1Y12mV3+ZM6IVS7mCRyxvhNZRAFmD55H/iSaxNyzxM7USWpWtMFpMfoyHNMsyZ2oxjdcFGaC5mk/tw5jslxv9kUWsbsj2nnGSKGUTIyVKtLamL3DP6RCV/hF+hALjtIqZ0VFsl9hsY0xcEeUvnnxGahoj324kyOPK6GTa5vhf5g3A8uZdrr/rHMwSCgRRp07kv2zutnzJbSrQvv3w/0+++kK2VzFfM6abLwTy+UzcvHDEP3axnA5TVveA//n/zQbSq03SI8DTusZ0DlZf3UIbW28pBqeRKIhQPqfBuqVyT9HDfwFPgKOs2q9w1u89zsbrPRviBI9ZQuSBgX0Ds4YLHhdWtWz0MtiGdMIw/PhweCZmvjPxni3g0QdnIbQECHfAo/4+WSySIfER84mNce3ZmxRdPXqSs9FWVvXx8c2UYxb/z+kA3fn0MxubGlQDU
 440uaOhb
 D7tikldHSmLnkSOyIIch+bILx8YH1H/1mcvTEp0yrCiDqIPyPRqea87Fqv8hVCxK+NDd1ACohGaHW+jcTNu8UJKYMyBVAJ4vAvaGwghlLVCLYKGnletEA9QNA2LQ03tEVx1GQGECu7oSeF4mcpnoYC27Kv49/eYSrKDo7xTczY8Sg+3EJ+RjNGGuXpwzzo5QnlGaiwdqVFmtlqyNqy/V0iSkdWF6BGcuG9rZaFq7JCJfZIIyW7WIdjyCaVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 9:51=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Currently, if a user needs to determine if guard regions are present in a
> range, they have to scan all VMAs (or have knowledge of which ones might
> have guard regions).
>
> Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
> pagemap") and the related commit a516403787e0 ("fs/proc: extend the
> PAGEMAP_SCAN ioctl to report guard regions"), users can use either
> /proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
> operation at a virtual address level.
>
> This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
> that guard regions exist in ranges.
>
> This patch remedies the situation by establishing a new VMA flag,
> VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
> uncertain because we cannot reasonably determine whether a
> MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
> additionally VMAs may change across merge/split).

nit: I know I suck at naming but I think VM_MAY_HAVE_GUARDS would
better represent the meaning.

>
> We utilise 0x800 for this flag which makes it available to 32-bit
> architectures also, a flag that was previously used by VM_DENYWRITE, whic=
h
> was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
> bee reused yet.

s/bee/been
but I'm not even sure the above paragraph has to be included in the
changelog. It's a technical detail IMHO.

>
> The MADV_GUARD_INSTALL madvise() operation now must take an mmap write
> lock (and also VMA write lock) whereas previously it did not, but this
> seems a reasonable overhead.

I guess this is because it is modifying vm_flags now?

>
> We also update the smaps logic and documentation to identify these VMAs.
>
> Another major use of this functionality is that we can use it to identify
> that we ought to copy page tables on fork.
>
> For anonymous mappings this is inherent, however since commit f807123d578=
d
>  ("mm: allow guard regions in file-backed and read-only mappings") which
>  allowed file-backed guard regions, we have unfortunately had to enforce
> this behaviour by settings vma->anon_vma to force page table copying.
>
> The existence of this flag removes the need for this, so we simply update
> vma_needs_copy() to check for this flag instead.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Overall, makes sense to me and I think we could use it.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

It would be nice to have a way for userspace to reset this flag if it
confirms that the VMA does not really have any guards (using say
PAGEMAP_SCAN) but I think such an API can be abused.

> ---
>  Documentation/filesystems/proc.rst |  1 +
>  fs/proc/task_mmu.c                 |  1 +
>  include/linux/mm.h                 |  1 +
>  include/trace/events/mmflags.h     |  1 +
>  mm/madvise.c                       | 22 ++++++++++++++--------
>  mm/memory.c                        |  4 ++++
>  tools/testing/vma/vma_internal.h   |  1 +
>  7 files changed, 23 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesyste=
ms/proc.rst
> index 0b86a8022fa1..b8a423ca590a 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -591,6 +591,7 @@ encoded manner. The codes are the following:
>      sl    sealed
>      lf    lock on fault pages
>      dp    always lazily freeable mapping
> +    gu    maybe contains guard regions (if not set, definitely doesn't)
>      =3D=3D    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  Note that there is no guarantee that every flag and associated mnemonic =
will
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index fc35a0543f01..db16ed91c269 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1146,6 +1146,7 @@ static void show_smap_vma_flags(struct seq_file *m,=
 struct vm_area_struct *vma)
>                 [ilog2(VM_MAYSHARE)]    =3D "ms",
>                 [ilog2(VM_GROWSDOWN)]   =3D "gd",
>                 [ilog2(VM_PFNMAP)]      =3D "pf",
> +               [ilog2(VM_MAYBE_GUARD)] =3D "gu",
>                 [ilog2(VM_LOCKED)]      =3D "lo",
>                 [ilog2(VM_IO)]          =3D "io",
>                 [ilog2(VM_SEQ_READ)]    =3D "sr",
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index aada935c4950..f963afa1b9de 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -296,6 +296,7 @@ extern unsigned int kobjsize(const void *objp);
>  #define VM_UFFD_MISSING        0
>  #endif /* CONFIG_MMU */
>  #define VM_PFNMAP      0x00000400      /* Page-ranges managed without "s=
truct page", just pure PFN */
> +#define VM_MAYBE_GUARD 0x00000800      /* The VMA maybe contains guard r=
egions. */
>  #define VM_UFFD_WP     0x00001000      /* wrprotect pages tracking */
>
>  #define VM_LOCKED      0x00002000
> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflag=
s.h
> index aa441f593e9a..a6e5a44c9b42 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -213,6 +213,7 @@ IF_HAVE_PG_ARCH_3(arch_3)
>         {VM_UFFD_MISSING,               "uffd_missing"  },              \
>  IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,      "uffd_minor"    )               \
>         {VM_PFNMAP,                     "pfnmap"        },              \
> +       {VM_MAYBE_GUARD,                "maybe_guard"   },              \
>         {VM_UFFD_WP,                    "uffd_wp"       },              \
>         {VM_LOCKED,                     "locked"        },              \
>         {VM_IO,                         "io"            },              \
> diff --git a/mm/madvise.c b/mm/madvise.c
> index fb1c86e630b6..216ae6ed344e 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1141,15 +1141,22 @@ static long madvise_guard_install(struct madvise_=
behavior *madv_behavior)
>                 return -EINVAL;
>
>         /*
> -        * If we install guard markers, then the range is no longer
> -        * empty from a page table perspective and therefore it's
> -        * appropriate to have an anon_vma.
> +        * It would be confusing for anonymous mappings to have page tabl=
e
> +        * entries but no anon_vma established, so ensure that it is.
> +        */
> +       if (vma_is_anonymous(vma))
> +               anon_vma_prepare(vma);
> +
> +       /*
> +        * Indicate that the VMA may contain guard regions, making it vis=
ible to
> +        * the user that a VMA may contain these, narrowing down the rang=
e which
> +        * must be scanned in order to detect them.
>          *
> -        * This ensures that on fork, we copy page tables correctly.
> +        * This additionally causes page tables to be copied on fork rega=
rdless
> +        * of whether the VMA is anonymous or not, correctly preserving t=
he
> +        * guard region page table entries.
>          */
> -       err =3D anon_vma_prepare(vma);
> -       if (err)
> -               return err;
> +       vm_flags_set(vma, VM_MAYBE_GUARD);
>
>         /*
>          * Optimistically try to install the guard marker pages first. If=
 any
> @@ -1709,7 +1716,6 @@ static enum madvise_lock_mode get_lock_mode(struct =
madvise_behavior *madv_behavi
>         case MADV_POPULATE_READ:
>         case MADV_POPULATE_WRITE:
>         case MADV_COLLAPSE:
> -       case MADV_GUARD_INSTALL:
>         case MADV_GUARD_REMOVE:
>                 return MADVISE_MMAP_READ_LOCK;
>         case MADV_DONTNEED:
> diff --git a/mm/memory.c b/mm/memory.c
> index 4c3a7e09a159..a2c79ee43d68 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1478,6 +1478,10 @@ vma_needs_copy(struct vm_area_struct *dst_vma, str=
uct vm_area_struct *src_vma)
>         if (src_vma->anon_vma)
>                 return true;
>
> +       /* Guard regions have momdified page tables that require copying.=
 */
> +       if (src_vma->vm_flags & VM_MAYBE_GUARD)
> +               return true;
> +
>         /*
>          * Don't copy ptes where a page fault will fill them correctly.  =
Fork
>          * becomes much lighter when there are big shared or private read=
only
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_int=
ernal.h
> index d873667704e8..e40c93edc5a7 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -56,6 +56,7 @@ extern unsigned long dac_mmap_min_addr;
>  #define VM_MAYEXEC     0x00000040
>  #define VM_GROWSDOWN   0x00000100
>  #define VM_PFNMAP      0x00000400
> +#define VM_MAYBE_GUARD 0x00000800
>  #define VM_LOCKED      0x00002000
>  #define VM_IO           0x00004000
>  #define VM_SEQ_READ    0x00008000      /* App will access data sequentia=
lly */
> --
> 2.51.0
>

