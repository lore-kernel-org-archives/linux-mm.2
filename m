Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33C21CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 17:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914948E0066; Wed, 17 Sep 2025 13:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EA008E0002; Wed, 17 Sep 2025 13:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827328E0066; Wed, 17 Sep 2025 13:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7254F8E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:22:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 217A3C05D6
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:22:40 +0000 (UTC)
X-FDA: 83899411680.08.9CFD068
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 290D9A0018
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:22:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=saxIJj1U;
	spf=pass (imf25.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758129758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+E7E6CpklnGcp1ci3sPCCKWWgs8VUPg8eKk3JcOPP8=;
	b=ABYPIsQyKSxJKXoZ6lL03cftbCrTwxTUtvN7YyNZ/Y1JpVDDep6T0xRPPxDBx/HzmAyo1N
	GmA/NNCIV3EUfiU7Kgpp1McTzk59NdcgBAW5ZwD1t0BYMOjqMTw1IRzEZaUOSZ0e/CLEYB
	wyV3riwb2OUcpxr/pkd0WSsXEWjCmGs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758129758; a=rsa-sha256;
	cv=none;
	b=cOZUtvU3YVPds8MtDtNb9QRqogP+R/la+Fs4Co8aU4povWgViCJhTpwAQU6iaca8CX3tzC
	9bH0W5dTCQirVjVrA9TUx+AlCpJRFqTicK6MIW1ur1HBxPOnNqWktY0v4GPh3Fa33vqr6T
	p5H0SxbYHW4mscdFR035FoD38a1arig=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=saxIJj1U;
	spf=pass (imf25.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-265abad93bfso12205ad.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758129757; x=1758734557; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+E7E6CpklnGcp1ci3sPCCKWWgs8VUPg8eKk3JcOPP8=;
        b=saxIJj1U0QjqIxtp5aamq4Ug5+ik8xDeTZuy/Sw2VR33zGhdTCw/CadRE69eBDSpmS
         VdbPllP5G+1K5pdZiEN5jBLFKYt5Gw6C56lNEDD3z20tKxwxNMeq2n3UNtUP4L2rMuQf
         zRc+RvRI/8x1fUm9jZBRb21TeG4ba1ZXoKV+ArM20+4YD8JFhujk3yWGiEHBbcy1wDXb
         ajab4XNjETMnShRz1A09P22HnYRx8X0pmcICfrhzKGZnR+FrrR3eTOkAZLY4ePbb3wFs
         WyhFv/Wm0L12S2xi4tSvy5R6LETUS9mTk6kYcvpgR10tf2xGm5rn4SBSj/yvT/8zeW2l
         tM5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758129757; x=1758734557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r+E7E6CpklnGcp1ci3sPCCKWWgs8VUPg8eKk3JcOPP8=;
        b=haNCLosoTxmN48q57rf2bOirkFSWTBJaY3SUST+206L4uYuvEP3UWTpwhGv20bP+KX
         id2szTv+K2z96mfZGAkqvhadLWMm5NYwsB8k/HSNFbYk9RyWBh4wpgoOOt/OklFNSZoV
         RVul+j9tGqMxFdY342F+/hUnepMwNRLK8WZRmD95bKD8++8Ka6ITq/yXD9DMWhiXtQsd
         BCQixP2gGl+9J1EVQnP0+S4jf77KDRLT/4aANdQ6VV/2irp0pB04PygEoblEXk0vvemw
         QyYWsB33Td0G18DENu5yGHxsiP68I+GaOqY1mYrD/IzCmxPpNFR4ZDDOttZPiIr8o6y5
         521w==
X-Forwarded-Encrypted: i=1; AJvYcCUYT2q3rLSUC81bBHw/5k+MGXDsHl7RXKpdbBt+RzRXFSkOm7tVbKa1VDpGsSj0BwnTMmKSPM7Wgw==@kvack.org
X-Gm-Message-State: AOJu0YxsSsV/MjBjIjVM58gKRlFv8EsoUIRNekrzzUTooIOhj/gyPCwt
	fC8NO7K9lBjCDxWTKnFJ2s48D0QKM+ECoMDr5N0WrR7tMCJwEdEq2+r3wbZNH4VYNlSsXrOFTWq
	Lz5l2cZSa8U89fR9s/n7pYvaVt6SJUoD/CowirCRj
X-Gm-Gg: ASbGncsnwMBhiPIjhr5tq/GSF9i4pEev7ErrGcv4iQwcp5enBje9+wEPCB7j2cCcjAY
	dYPFHGQv0lg76HcT5lYtyDJilqknEJfR5BXQQG/6e0z6umtg6c7l6rc9BHnR1AYkbmoyYNrb1sh
	BTJSq8xC48Hqoxzb5wd+cunO3NGf2smRR9fhIQH6TQ9V2I7BwEJTykTCjHxlTfOZxaKSl1QyfiF
	SsznRpBBzqRjKi0CYgTNTtFk+ZF2cTXNF9noFrmMNn+C7OwV9F0m5Q=
X-Google-Smtp-Source: AGHT+IHeiEiZK89rCQTa9vJT7n+2u8jidRkSIY9SZNarvXZONROAFr8zQdlQ9JzID/8YZhac6C1RAxvIIaVZDc04CMY=
X-Received: by 2002:a17:902:d2c9:b0:266:b8a2:f605 with SMTP id
 d9443c01a7336-26808a2fc00mr4313065ad.3.1758129756462; Wed, 17 Sep 2025
 10:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-7-kaleshsingh@google.com> <eb7820ed-3351-4cb5-8341-d6a48ed7746f@redhat.com>
In-Reply-To: <eb7820ed-3351-4cb5-8341-d6a48ed7746f@redhat.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 17 Sep 2025 10:22:25 -0700
X-Gm-Features: AS18NWCUijB84Y15lF3r5d3C-Ej09R315cPK-C8knq1sNn05pRA_6ZbvAAxSzwc
Message-ID: <CAC_TJvctkyGEKv8mVE83D2DzCd-HiXh9co_DuZfwuF86FJoiJw@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] mm: add assertion for VMA count limit
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	kernel-team@android.com, android-mm@google.com, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, 
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 290D9A0018
X-Stat-Signature: 6a13r8ejppdmor4pkk8px6xobckwiuq3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758129757-914717
X-HE-Meta: U2FsdGVkX1/G706lLuzBjuYFiOQCRa7Dx77y72kJgRRsw/HPpXeBHtxU0uCJ8pYZ1rr2tHMb5N+oKGVgoa15Q4BWARefbV1wLkfLihMFRYQOhsa+R900qeo0y8hGpRxgnBYad5sq/s0FjJBWVgYBun6uuLlhksYZVdX+796mhW/w5JoesE2ICLdyQVlb1dsoEozVBt8+XG8ZsCxkn4YiAKzUgNknPqTYmPpkSZRqmUcB/F1va375V4uRNb0I7NbioQZg+j7s8LX2RpR9siY1XW825F0cyycj4NM+UHj2n4oaTseUWB9dECNrBWA8k8zCDbRMkSVrdJry8Tra0Xl6a/VVVXsY3CZZdEdDUqTQzEbb6/etZVM03G0QGvXYSMv6ZogJZGefd59GnOL1sQBrRsYXhKsvsK58HQ+rko4r+ofzXKVMqBRUdk/Ls2Ou0S+As/l8VW/JDClcETKHSriZzCbSPuFcvdMLhLFjAckB6eGftyfzhbX6//IihHMzHD9VwX8gZm1v97JVtbaMcHCP82Dgv++VPnmAsxpY5zATsgjrF4Fedt+u3zh1VQyckiMjtAtbH9kWAiwTmvygFCOIvSiJiyum2CUNYvGG2yGteBsWxNEiLYkn9yYFE0ir8ztPXF35GD0tvQmVchSPVFclC7H3UyFPMgNgCzjFllHz2QXg+yAeFV9UPZCYin7jwGduKo/wq89J8r534+7Q4WG3/y2T8fy3IXLkx2CTG1rvRY3Tf0awRgbTfMaMdUxf6yBFNp53tJYzyVT21fWpkcNOmCtxQpgDs8Fm27+eyFgj4IhUEuhgiKfgi+8ZUeO+MvNCYFn2/+mp41EblI8uR/T/AhLbvMrPbFKW2B5Na7d1fyOg/mNhp4ztVUyC2LAueBElCvvq0b/G77Y5rA7xH2R4rdkPC4PhPDxDa3rTm29STGk9Ife1E0C6qyMYQkXoi5WX1GP7CPZDypjaoRxr6nO
 FZp9L05V
 oluFOzr+AW4X4bqDZKW66RrbWRVQkwWdVnBfWRwF87BGg8Kyyquvh2zbYQCbO8JLl826v7JSdLHNW3G0MJOUVHofoLAsJxhhC0mQnS1EpDZp6yCxWc2Zkc5cF5R6yEVWtYzD1JFGabWfprsw0u6SAvfH9MGvUmoUjYRlopVTNOP5P//RqCZjoo1q+Nqzj0L35Pi0QU5F/4nkPH7fHRz4XHs7MElNL7SuqpdHaK8/KcxwsdrmLkE0IPNwBmQRSzmfpU3CbLF2mFAmUbXYpxOOV32lhZKHDzFW/Ia6N02wmMp6CR8OYxvx2uFKrbhYi7nDVGQoyCt9lQ/sYQpb/vdkJh9P7StMJEykG6hiBviC98JTtN0zAOVw3aREWZa6MBLtNAGQk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 6:44=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 15.09.25 18:36, Kalesh Singh wrote:
> > Building on the vma_count helpers, add a VM_WARN_ON_ONCE() to detect
> > cases where the VMA count exceeds the sysctl_max_map_count limit.
> >
> > This check will help catch future bugs or regressions where
> > the VMAs are allocated exceeding the limit.
> >
> > The warning is placed in the main vma_count_*() helpers, while the
> > internal *_nocheck variants bypass it. _nocheck helpers are used to
> > ensure that the assertion does not trigger a false positive in
> > the legitimate case of a temporary VMA increase past the limit
> > by a VMA split in munmap().
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >
> > Changes in v2:
> >    - Add assertions if exceeding max_vma_count limit, per Pedro
> >
> >   include/linux/mm.h               | 12 ++++++--
> >   mm/internal.h                    |  1 -
> >   mm/vma.c                         | 49 +++++++++++++++++++++++++------=
-
> >   tools/testing/vma/vma_internal.h |  7 ++++-
> >   4 files changed, 55 insertions(+), 14 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 8bad1454984c..3a3749d7015c 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4219,19 +4219,27 @@ static inline bool snapshot_page_is_faithful(co=
nst struct page_snapshot *ps)
> >
> >   void snapshot_page(struct page_snapshot *ps, const struct page *page)=
;
> >
> > +int vma_count_remaining(const struct mm_struct *mm);
> > +
> >   static inline void vma_count_init(struct mm_struct *mm)
> >   {
> >       ACCESS_PRIVATE(mm, __vma_count) =3D 0;
> >   }
> >
> > -static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
> > +static inline void __vma_count_add_nocheck(struct mm_struct *mm, int n=
r_vmas)
> >   {
> >       ACCESS_PRIVATE(mm, __vma_count) +=3D nr_vmas;
> >   }
> >
> > +static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
> > +{
> > +     VM_WARN_ON_ONCE(!vma_count_remaining(mm));
>
> Can't that fire when changing the max count from user space at just the
> wrong time?

You are right: technically it's possible if it was raised between the
time of checking and when the new VMA is added.

>
> I assume we'll have to tolerated that and might just want to drop this
> patch from the series.
>

It is compiled out in !CONFIG_VM_DEBUG builds, would we still want to drop =
it?

Thanks,
Kalesh

> --
> Cheers
>
> David / dhildenb
>

