Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA58DCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 21:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122E48E00A2; Thu, 30 Oct 2025 17:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA8A8E009F; Thu, 30 Oct 2025 17:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00FB28E00A2; Thu, 30 Oct 2025 17:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E365B8E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:33:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86E79B7D6B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:33:41 +0000 (UTC)
X-FDA: 84056082642.15.C1BF67B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3AF901A000A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:33:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SKdSg+fn;
	spf=pass (imf19.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761860019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6BTjF9iBAr+SXjRmdiLA1R0VxivfZSdqF5XNYnvvpZY=;
	b=DfTI/HrS1YF8LWj35SXL/EqUQfQUptJLl1gZGEyAEVfHx93CrF0aN960PNEh1pIeI7CADO
	y+wAP72mZYJSEebQRqofpRJqJa+UtLKXf4srofuQzC4SQumWsu74C9tuDfTKaBAmS21pIy
	uHLDWzcllfsggDMcokCJc6VPohtwi3o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SKdSg+fn;
	spf=pass (imf19.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761860019; a=rsa-sha256;
	cv=none;
	b=sDJWGV/i/Gm4Ujac1LPL2HW/2mT/FV/Km90hg+D0Q1DOI4XYC3loyYbD20iHr3PxZEDV6M
	pP3go6XTea9eFS/G4e1/rXzdEl96SjkXkIZ/BQtSQEBhzUMIsIcP0jQzt2p1a3sKIVjQzE
	aSrN4zl7clMr1QDZQA+wVmlVt8MIDlw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761860018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6BTjF9iBAr+SXjRmdiLA1R0VxivfZSdqF5XNYnvvpZY=;
	b=SKdSg+fn7B51EEMyDpUHD38+ohtsedzZiTj0UAvwGbQyl5k8izgycNE++2Qw03VxZ+ZHnB
	9IoxmxoRl7lSu/4E4Rp7OCvs7qcOxvHkDnV3lssAA0Ppm1NewGGZcG/OkWdbGZSCGLsNb/
	1sbb5leR642+wFRcu4XuQeFTlK0gLAs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-jwmCwU1QMtS6NxX_fwS3RA-1; Thu, 30 Oct 2025 17:33:35 -0400
X-MC-Unique: jwmCwU1QMtS6NxX_fwS3RA-1
X-Mimecast-MFC-AGG-ID: jwmCwU1QMtS6NxX_fwS3RA_1761860015
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8a3f828c9bdso426827385a.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761860015; x=1762464815;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6BTjF9iBAr+SXjRmdiLA1R0VxivfZSdqF5XNYnvvpZY=;
        b=qd7ADqXqxVJsANMKGnJepUqYqwMv2noqo2MgqDzEBVjqcOlmMdPOR/rUAUi9+b52T1
         2+XFzsRaeHu7nZARtKFNJpJLQ7WkMehKuDCNBJB9kkqCosiYhUYV7cuq/10d8mtXLzzr
         kAw1XQV1+E36kXviV5QaFeWTsaRzA8iDUZSG/54XgQHVJQMmlVY4yiaX8NBYvst4qJkY
         w7AmDNqwwRbn8h9prGCLVzeEOFhVCgtVV5kuyb5aLh67eUIgGZuh2cOXqT3yjU3a+RcU
         s0tVp/SOKe1m3AQVVwtQ8CT7hAi3r4th1IA1FVw2lcrDqAJHIFuWvynn4am2nYWzDULG
         kYJw==
X-Forwarded-Encrypted: i=1; AJvYcCUwHXLUnENQueCoK6dLw++Kpfa+TpTeS4U3gZoqI+4m1VdPvkAKT0BMF9HlJqL+7gslFLQiW6ESew==@kvack.org
X-Gm-Message-State: AOJu0Yx0EhWZqglHNoEQkIb9vW46HA12jfB+sOmyZubkLxhPMf2QaTwu
	b027zebL4yk0Wp9uxGgNY9XkCkqpkfEL/5Pw8jV9dJJg+5uplyK8VDuH5UtSQTq+27AhjurrdDj
	1uNNkPE+F/0bKpxe4tbagwIgFRSCqr12njJ7xmKjmopKMYaNujh8J
X-Gm-Gg: ASbGncsnXXziR5Z80zY/gjg1p/mqc6QCkZXtMkIbhYUef/S36dS7xfxMtcNxjV9XedM
	/WJzY3C+zA1TOILGEdRoI3bMcbyBL2GH733TCHD8PVCDEVD0iuHU2RYF+rguyRYLRh0+4E6IVCy
	F4dpQToQYSgchMh9ogFSJICp2ps13eeNCLdruYtoUdEqp5LlDJHK8rONNUH+hTiGdab+fa/Y6Ug
	tVh971MQr5ew26U2TYlXksPWdKySn+KDPslP1rYJ8zAHiXETQC6EYG4pfaquXqrE42zJLc/ji+S
	Pp8nvSxmS4vuAJJBM3aVUm8V1QgAvZRPBL5jkrM1givUWPJcl5gk27I5qRFxjmB59Gw=
X-Received: by 2002:a05:620a:470a:b0:866:1327:82e9 with SMTP id af79cd13be357-8ab990ab101mr149325185a.16.1761860015174;
        Thu, 30 Oct 2025 14:33:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFM7NW4gQYEH6hfXUiyF8LoUjp9QHHlpvIxudEkcHo2wWKq5Ki71GgmZpXDDbqRu5pp+Hlprg==
X-Received: by 2002:a05:620a:470a:b0:866:1327:82e9 with SMTP id af79cd13be357-8ab990ab101mr149320985a.16.1761860014633;
        Thu, 30 Oct 2025 14:33:34 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f252ad31dsm1324211985a.27.2025.10.30.14.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 14:33:33 -0700 (PDT)
Date: Thu, 30 Oct 2025 17:33:31 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aQPZqyUUVjexKWaJ@x1.local>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local>
 <aQPCwFZqNd_ZlZ0S@x1.local>
 <bx3pshg4iwcgbzihgsoxmpubbsecgm5r2x37g3sfriloke7fk3@kbyponznh3sl>
MIME-Version: 1.0
In-Reply-To: <bx3pshg4iwcgbzihgsoxmpubbsecgm5r2x37g3sfriloke7fk3@kbyponznh3sl>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oX3_Hy75C8P5EuE02udiKsGlLDqDWtO4h4sA92pPalo_1761860015
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3AF901A000A
X-Stat-Signature: wmyueqwyywucw8we4wot3aymz9d7ziif
X-Rspam-User: 
X-HE-Tag: 1761860019-710365
X-HE-Meta: U2FsdGVkX1/XnMxTbWV7R/4GjIFpQF8xwGeOAFM7lknzBAbl1k6IFPaDXTNEFVwSUxhrzxqo94wolv3r/y18AtQP/MSX6vPBImWF3UrWpyZRpW8RbLdPw6/4wm1tC3c8NjbvCUMM9A/Qi3Hl7y04C3XOfJFK99Q+1TCgIgAkQuahhfdTHtr9ZTCqLOLYZTdTIist3SsaaGCktPAsYBOtXAr6rdVp/IHNghRIM9CC+7FklNHGjQY7lMLhm4nsc3aLM5i386YwVTwDvCecFPa5B/9+hxFKpCrAcMirbifPFKVjdLEYyNzJmailcn8OEsuBlajIYXzk2S2elniF7lCqMa7Z0bU7lkDzoM+7ee3Uu1qYx0Zw6q9SYC7kQ9q2QHislVrpdM5XVVpQSd+o0mh4P80Sqca+rqWJEK7k+E2nJQcoWvA1Z/OWiFPtLlFKWd8nAVRdWAiEaCyjIKfLFP5WqOVjrLFTgfTmgam7acB9npspTKeN/8LLNSb3DPWji8Dvma32BNbMhXnNdrwVgJ12s0YwGvcZ+JdgMyZ8oaOsdJhGNf9eJQ5arrqMLoY1BwinW/ujvFhueBvFfchIABuM2rG+O71elqMQ5JhM4kiwwkHBO/6P2XW+HrhlWcLOS6vDtaiR62BJAqbgdza/g/GpuicG2TCfswzD44JGQ5q954Jh0IeIeEmatMUifCJD5Smbfp+1qjCf95g9CE+TU5iUDGWoJ01mnCJ0t7WSyRolmHe+dzY8UTr/R1D0CF0kA9iv2mMG6O589geAlhBFGkPOkPAwTDVYysoAG8DUXXKCjR+MKGHFXzsIJgXfa4TKuw6Hb0H+nv5otcFIBZGlgUhAMbt4KXdbMRjKsMVxeqYO9+25OmkHwh3DOFv7iT1gNG7FA5cw06i8N+WxKYNXlBIFQ7lyENRwqc78ihxx6AFqkF8HsFXfweUTB65osa5HaPYdi60Wyf427w6hHZGm/5E
 GiTLhyGg
 qjf8RaZsSDmvAlBOzz988xjp6bFPsedKSlSnn4+sevAFJJ1Uk7HXxCfIEOpHsTKT1eNemLCUeQ0UI+8hwVS9M94r9cWzKf2fEpaa1tnhH69lswTMzM2prgbZ31dLkhxp6fIF9GamOv7RO8w4EdOifGSziCZEc4s3bCzNXc0c9wDCoGZM3W4KLqR3RH8AO1uw8jJxzBQi4ITWODWcZQ1e76kZH5cHRw6otVYhRnThoLuL/TrnUr4JgGggwWmLyZYwwGR+4jJK5GRuXgx3Q8u7mnYq1mqbkNNlS2fL3k+2cw/cIWBIpnO1P1eyvP92ElCKCvEfc6MwZOeA6II7I9QLGWD3UXl1itBBHpEGaUrcC3Zc26ceoSFPSQ+SwgDNB2Wr14XXEgbD3yCRPbc5/fV0oyFpwxgptQtrGWVKAV3SNNJPpQfu9sVy9H34daPt8usmQBLizTv2gh/BF5fk7yHhtogyFnDizWdFhqfpHocMwgGXyk/c6eqsNj2F7ZuoBxYjesecaDAAbsUNle3clL1HMCEEX6BV3fYPqsgQlLU21cledfsxJCI2vclEw5rSCkjj5+/SW9iL58jiQQjg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 04:52:26PM -0400, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [251030 15:56]:
> > On Thu, Oct 30, 2025 at 03:07:18PM -0400, Peter Xu wrote:
> > > > Patches are here:
> > > > 
> > > > https://git.infradead.org/?p=users/jedix/linux-maple.git;a=shortlog;h=refs/heads/modularized_mem
> > > 
> > > Great!  Finally we have something solid to discuss on top.
> > > 
> > > Yes, I'm extremely happy to see whatever code there is, I'm happy to review
> > > it.  I'm happy to see it rolling.  If it is better, we can adopt it.
> > 
> > So here is a summary of why I think my proposal is better:
> > 
> > - Much less code
> > 
> >   I think this is crystal clear..  I'm pasting once more in this summary
> >   email on what your proposal touches:
> > 
> >  fs/userfaultfd.c              |  14 +--
> >  include/linux/hugetlb.h       |  21 ----
> >  include/linux/mm.h            |  11 ++
> >  include/linux/shmem_fs.h      |  14 ---
> >  include/linux/userfaultfd_k.h | 108 ++++++++++------
> >  mm/hugetlb.c                  | 359 +++++++++++++++++++++++++++++++++++++++++++++--------
> >  mm/shmem.c                    | 245 ++++++++++++++++++++++++------------
> >  mm/userfaultfd.c              | 869 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------
> >  8 files changed, 962 insertions(+), 679 deletions(-)
> 
> Including the following highlights:
>  -#include <linux/hugetlb.h>
> 
> and
> 
>  -typedef unsigned int __bitwise uffd_flags_t;

So you spent ~1000 LOC for these as highlights..  It's ok, I'll wait for a
second opinion.

> 
> 
> > 
> > - Much less future code
> > 
> >   The new proposal needs at least 6 APIs to implement even minor fault..
> >   One of the API needs to be implemented with uffd_info* which further
> >   includes 10+ fields to process.  It means we'll have a bunch of
> >   duplicated code in the future if new things pop up, so it's not only
> >   about what we merge.
> 
> You can reuse existing functions if there is no change.
> 
> > 
> > - Much less exported functions to modules
> 
> I haven't exported anything.  You asked for code and I provided it.
> This doesn't do what guest_memfd needs as it is.  This is all clean up
> you wouldn't do.
> 
> > 
> >   My solution, after exposing vm_uffd_ops, doesn't need to export any
> >   function.
> > 
> >   Your solution needs to export a lot of new functions to modules.  I
> >   didn't pay a lot of attention but the list should at least include these
> >   10 functions:
> >   
> >         void uffd_complete_register(struct vm_area_struct *vma);
> >         unsigned int uffd_page_shift(struct vm_area_struct *vma);
> >         int uffd_writeprotect(struct uffd_info *info);
> >         ssize_t uffd_failed_do_unlock(struct uffd_info *info);
> >         int uffd_atomic_pte_copy(struct folio *folio, unsigned long src_addr);
> >         unsigned long mfill_size(struct vm_area_struct *vma)
> >         int mfill_atomic_pte_poison(struct uffd_info *info);
> >         int mfill_atomic_pte_copy(struct uffd_info *info);
> >         int mfill_atomic_pte_zeropage(struct uffd_info *info);
> >         ssize_t uffd_get_dst_pmd(struct vm_area_struct *dst_vma, unsigned long dst_addr,pmd_t **dst_pmd);
> > 
> >   It's simply unnecessary.
> 
> Maybe we don't export any of them.  Maybe there's another function
> pointer that could be checked or overwritten?  We can do that without a
> flag or setting or wahtever the name you used for your flag was.

You need to export them when guest-memfd will be involved, am I right?

> 
> > 
> > - Less error prone
> > 
> >   At least to support minor fault, my solution only needs one hook fetching
> >   page cache, then set the CONTINUE ioctl in the supported_ioctls.
> 
> Your code just adds more junk to uffd, and fails to modularize anything
> beyond getting a folio.  And you only support certain types and places.

So would CoC accepts "junk" in this context?

> 
> > 
> > - Safer
> > 
> >   Your code allows to operate on pmd* in a module??? That's too risky and
> >   mm can explode!  Isn't it?
> 
> Again. I didn't export anything.
> 
> > 
> > - Do not build new codes on top of hugetlbfs
> > 
> >   AFAICT, more than half of your solution's API is trying to service
> >   hugetlbfs.  IMHO that's the wrong way to go.  I explained to you multiple
> >   times.  We should either keep hugetlbfs alone, or having hugetlbfs adopt
> >   mm APIs instead.  We shouldn't build any new code only trying to service
> >   hugetlbfsv1 but nobody else.  We shouldn't introduce new mm API only to
> >   service hugetlbfs.
> 
> Ignoring hugetlb exists is a problem.  I have removed the hugetlb from
> being included in uffd while you have left it in its own loop.  This
> doesn't build new things on hugetlb, it moves the code for hugetlb out
> of mm/userfaultfd.c - how is it building on hugetlb?

The APIs you introduced is building for hugetlb.  If without hugetlb, more
than half of the API is not needed.

> 
> Believe it or not, hugetlb is a memory type.
> 
> Certainly smaller changes are inherently less bug prone.  I honestly
> think all of what I have here needs to be done, regardless of memfd
> support.  I cannot believe that things were allowed to be pushed this
> far.  I do not think they should be allowed to go further.
> 
> > 
> > - Much less risk of breaking things
> > 
> >   I'm pretty sure my code introduce zero or very little bug, if there's
> >   one, I'll fix it, but really, likely not, because the changes are
> >   straightforward.
> > 
> >   Your changes are huge.  I would not be surprised you break things here
> >   and there.  I hope at least you will be around fixing them when it
> >   happens, even if we're not sure the benefits of most of the changes.
> 
> I have always been prompt in fixing my issues and have taken
> responsibility for anything I've written.  I maintain the maple tree and
> other areas of mm.  I have no plans of leaving Linux and I hope not to
> die.
> 
> I can maintain mm/userfaultfd.c, if that helps.  I didn't feel like I
> knew the area enough before, but I'm learning a lot doing this.

I'm not maintainer of userfaultfd, I'm a reviewer.  I was almost just
trying to help, in reality that is also true that obviously I don't make
decisions.

I definitely think you can at least propose add yourself as a reviewer if
you like to start looking after userfaultfds, or even M if Andrew likes it.

You're already listed as core mm R so I don't see much difference if it's
only a R addition.

-- 
Peter Xu


