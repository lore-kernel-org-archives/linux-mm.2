Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CADB1CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CB4D8E000D; Fri,  5 Sep 2025 15:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255F08E0006; Fri,  5 Sep 2025 15:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D4C8E000D; Fri,  5 Sep 2025 15:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDE3D8E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:44:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8768CC024F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:44:05 +0000 (UTC)
X-FDA: 83856222450.28.AF794BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id AF4EE1C0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:44:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gb25GASt;
	spf=pass (imf20.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757101444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJpJiNSsEqw1lbSRsS9Ty6CbbjAd0v4LviNPJ+0RPTI=;
	b=1ypJB2A5IyZvszZ/i8xH5hjlKnPKQjb3pChICXN9Tp7CWSdmA2KljRd50r6o9rszvb3HvT
	1z/9Wi3hrIPUiqlAMVXsxWtQCrMRh/I0gKkmI745inYkJYUvKpXr+IXJX6d+cbqw/V4PSi
	Z8ldRjiWYLzA6K+Mr+xqLLJwDQpHTTI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757101444; a=rsa-sha256;
	cv=none;
	b=5CNJIFsk3ajsWtxVaVlB1kJI+t/4x8C8chJEetiJaWUaPUk3EJEfvnrjLca0LmD5K2UiNE
	uqlh0Db+tUSPkc/exLsmfaZ0uQlSRq4V+4TbfBmGbVUHGNnrzssFsDrdNBndO5caBejHW9
	oxhk2PFL3OFmRp0kLKF0kLu1bo05TEQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gb25GASt;
	spf=pass (imf20.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B1E644721;
	Fri,  5 Sep 2025 19:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895DBC4CEF1;
	Fri,  5 Sep 2025 19:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757101442;
	bh=qj5NWqYmLfQgUNyQbHqhOAioJ4HtjEhlRLgfXr/ggm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gb25GAStY7PK4KWfMQC7rtd4cff2Ft31RumZ/kNKywLAXwUdYfICHHIJhBPjrZ6j7
	 o7iHpATbrIqVl1AYu1jaVpoUr8IlvHC34mB3TyehId4+9gUdLyyv/gHHn98jalOtC0
	 MX2S360mJGGFkZmz2ogHqkD/MgCf/035PnB2I9Wq5ZfXBWK5fpwd1RbY1MXhtqJPld
	 H5GqrWgLYTQargRJ06fYCqqcMjdxQlMgkFIz1Gqzc+2aRDBKLVXuNsb4wASbw6IEl6
	 597PZCICEO+V0BK33bDDozHnZlGhmt7NvXrmXSlYdy89LJVzrbcrFORdWilzQ/GPWA
	 8B6Fa0HYYbdnA==
Date: Fri, 5 Sep 2025 12:43:59 -0700
From: Minchan Kim <minchan@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, kernel-team@android.com,
	android-mm@google.com, David Hildenbrand <david@redhat.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
Message-ID: <aLs9f9WjxIOrE3Sr@google.com>
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <qa7b7pvrycejnn6pjytxysu57xckhexupjrzefmk4j5hlaxka3@ayeg2vzpfe3r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qa7b7pvrycejnn6pjytxysu57xckhexupjrzefmk4j5hlaxka3@ayeg2vzpfe3r>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AF4EE1C0005
X-Stat-Signature: 8t38y4kr6c8i3yexfpqip64uhyuhswcc
X-Rspam-User: 
X-HE-Tag: 1757101443-950951
X-HE-Meta: U2FsdGVkX18fRwhJc0z1CGVFniwfADKgpwwEpCsnXbtKDKvFuOziouoK8H3OITRJFhYOI7e9iZ2+7xDUy/Fos4DYWe3h3DZ5By4HRPkoOD72SDr+g2NRhHMmCLaPYHRIkF2EDFWRybWgzcL0fhjvGIz7LjrikSfSby/btqy36xs8efAK5rhcwmIQOFRK63FEVBRtdfiLXJU2R5OhmYAKNjOqJb1hnH52BNcVa9HyU9E1gBl6rjtMYkjb/UJq0sPgBoNRW0yl/zFrSZPeimPyqSxlGzhELObnjUpT99n8i0MkHNYX4aqsIIIBVz2fx1pJAP4TufP0fCUcqyI1nIwG71t319LwZvU/mg5FO4tlKzrCsL6WhQLyjLjUf++7oN/pUIMgfrZTPWhznS+j268PQCC+I1gbqY1iSFjL/ENmiIDlp/tMCDyNc4SohlwmtigHBF1pBI40UpRbwfGiSzj57zMeuGHfwzUgZqmg9rIulh3BBMlgHWFiv9rsNwSwyJdUE2RWkNkymlcjVFwXxDKZ2esiK+rKOwxvlLoAFnXp9DU1vzjV/HMcPpevjjFTn6yKcbGGlGwtfwvlxF9PtpbeHeSYslAb/sIjlvKYMkUkpq2j64jzNbaFdGxM01bwOOtAgRxsqF8xIPc4WmWIzHkr10sKBFZnQSzQtBTsn/JhnzrW6I7HwgaulaZZVhjMDOpxVcNTMRyRVRDMu3Ua7Ywdg+o5GUk5zSsOhbBIweJEGBEeWxG7AwUBwIi0QS9o/BDovpksRC2vDZ48Q43rkQzTQfB0GPwEHOYLUXS+vscmqxMJ1uAkIN5IIgOg39FdeuG3gnUpjMRPb1eDDe3n6uuqvmim1FAsBeTvaFF0h/WyFBdasQzj1O0U3TOIVRqNcAxHdM1oIXF/PA6n8XVhNMj0EIlDOjXz2VERiOI6MzQNHr3qJoKuHN9jqdcizo74ZHZu46eI/mdCROD4f+4v6g9
 nN6k811p
 NMNpKwu7Drz0zrqr4rXCAfvpkrNCzdowpCv4MILzkxAP6za45XqCgTbEcAU5+KQ9yMD64z7c1Cs59c159MlpVSeEU/c/bvE6MoEZhZsdbFHE/CRxTLHY0y5VcVPKoF5hGyVzP8mFtL8y8Mjq326ZdH684fnnyATIG4ZMOUaO2G1MuVqHMUY4wKXtLoqFwD0GlNdfHVB95IdRVfM5DEF3yGjyBcttwHJ2ZRQ8VAnPYIyWWsHHTMy2op4ofdIuNdkn2fyyYxIE2gG/f9ix70lWL4I1OrAkA2UG50wM0AEGatnfgYEcFk44tSAASMdvZ6sJZ9UiGpOEG76tclh2+jIIE/BjrZhhq77APrKpcqoNAIMxD8/ErKMbchkuJNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 12:46:34AM +0100, Pedro Falcato wrote:
> On Wed, Sep 03, 2025 at 04:24:35PM -0700, Kalesh Singh wrote:
> > The check against the max map count (sysctl_max_map_count) was
> > open-coded in several places. This led to inconsistent enforcement
> > and subtle bugs where the limit could be exceeded.
> > 
> > For example, some paths would check map_count > sysctl_max_map_count
> > before allocating a new VMA and incrementing the count, allowing the
> > process to reach sysctl_max_map_count + 1:
> > 
> >     int do_brk_flags(...)
> >     {
> >         if (mm->map_count > sysctl_max_map_count)
> >             return -ENOMEM;
> > 
> >         /* We can get here with mm->map_count == sysctl_max_map_count */
> > 
> >         vma = vm_area_alloc(mm);
> >         ...
> >         mm->map_count++   /* We've now exceeded the threshold. */
> >     }
> 
> I think this should be fixed separately, and sent for stable.
> 
> > 
> > To fix this and unify the logic, introduce a new function,
> > exceeds_max_map_count(), to consolidate the check. All open-coded
> > checks are replaced with calls to this new function, ensuring the
> > limit is applied uniformly and correctly.
> 
> Thanks! In general I like the idea.
> 
> > 
> > To improve encapsulation, sysctl_max_map_count is now static to
> > mm/mmap.c. The new helper also adds a rate-limited warning to make
> > debugging applications that exhaust their VMA limit easier.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  include/linux/mm.h | 11 ++++++++++-
> >  mm/mmap.c          | 15 ++++++++++++++-
> >  mm/mremap.c        |  7 ++++---
> >  mm/nommu.c         |  2 +-
> >  mm/util.c          |  1 -
> >  mm/vma.c           |  6 +++---
> >  6 files changed, 32 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1ae97a0b8ec7..d4e64e6a9814 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -192,7 +192,16 @@ static inline void __mm_zero_struct_page(struct page *page)
> >  #define MAPCOUNT_ELF_CORE_MARGIN	(5)
> >  #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
> >  
> > -extern int sysctl_max_map_count;
> > +/**
> > + * exceeds_max_map_count - check if a VMA operation would exceed max_map_count
> > + * @mm: The memory descriptor for the process.
> > + * @new_vmas: The number of new VMAs the operation will create.
> > + *
> > + * Returns true if the operation would cause the number of VMAs to exceed
> > + * the sysctl_max_map_count limit, false otherwise. A rate-limited warning
> > + * is logged if the limit is exceeded.
> > + */
> > +extern bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas);
> 
> No new "extern" in func declarations please.
> 
> >  
> >  extern unsigned long sysctl_user_reserve_kbytes;
> >  extern unsigned long sysctl_admin_reserve_kbytes;
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 7306253cc3b5..693a0105e6a5 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
> >  		return -EOVERFLOW;
> >  
> >  	/* Too many mappings? */
> > -	if (mm->map_count > sysctl_max_map_count)
> > +	if (exceeds_max_map_count(mm, 0))
> >  		return -ENOMEM;
> 
> If the brk example is incorrect, isn't this also wrong? /me is confused
> >  
> >  	/*
> > @@ -1504,6 +1504,19 @@ struct vm_area_struct *_install_special_mapping(
> >  int sysctl_legacy_va_layout;
> >  #endif
> >  
> > +static int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
> > +
> > +bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas)
> > +{
> > +	if (unlikely(mm->map_count + new_vmas > sysctl_max_map_count)) {
> > +		pr_warn_ratelimited("%s (%d): Map count limit %u exceeded\n",
> > +				    current->comm, current->pid,
> > +				    sysctl_max_map_count);
> 
> I'm not entirely sold on the map count warn, even if it's rate limited. It
> sounds like something you can hit in nasty edge cases and nevertheless flood
> your dmesg (more frustrating if you can't fix the damn program).

How about dynamic_debug?

a1394bddf9b6, mm: page_alloc: dump migrate-failed pages

