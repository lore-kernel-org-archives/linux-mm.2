Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0672CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 10:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9FF8E010E; Fri, 31 Oct 2025 06:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1FE8E0042; Fri, 31 Oct 2025 06:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1178E010E; Fri, 31 Oct 2025 06:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08A4C8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:35:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADDF012B068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:35:55 +0000 (UTC)
X-FDA: 84058053870.10.798F0BB
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 903ED40009
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:35:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BqMBzjxb;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761906953; a=rsa-sha256;
	cv=none;
	b=Plopj6gfUpe2KhmKeVxtIqT9BdcHYkekms6J0S6uHvb/Z6QMMCbiPKlyyajAApHqvGWxKI
	pWWhH/ujtAPoRobQEl02vMAZ1lE4Xf/gXIBcgbMLkXGeS+xfgmKWcmH2yXy/CXY4P9kIgn
	TVKrQAcituh5fuvpMhpCV+wHaXG56ec=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BqMBzjxb;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761906953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzZMIk02Nqu6V1427BR/J6vEzSH1QrB2vBKOtaJmgIs=;
	b=1AlLihk9UwIV8+PKj264CkUa+4Js31UakklnBcYa+KWlhhKWnK8ZX9gu75EkBthxtUjwrc
	UsPcVu3C0hp2qp94UG+dAFTsmEikGZo7PpUKj6pHyPHDLJxIa5zaqB/hMAhEopAnE6oVbN
	umyBe7E95PTIuVG+NmkUkTAN/RDDa+4=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47112a73785so15206945e9.3
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 03:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761906952; x=1762511752; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HzZMIk02Nqu6V1427BR/J6vEzSH1QrB2vBKOtaJmgIs=;
        b=BqMBzjxbDhlt2eyPTXL5/KrjPULlv8KHJJj6YHR6+uCjPLBjheD2qTi+GX4ghEv3LG
         MQo1y4irzrL71AGYQBfEV6gAY9vWxJm1hh6z600heCFWFS9uc1J+4hS7ObHqXXnQJX9p
         bkPwbYX5d1/bw62s52PUL6UJZmcTk2kYIb6eqv+85iOIvAkFcMnfPXUaVQeInMkqZnKy
         I90ELEPSoqMvz+A4tTXeJYllYrP/UZB9rztGcpFkFEQYPEtelPed4q6bLaEgZbG6tqAf
         469QXb9ZVIDc5jaBYZY1Wrek2KSdnvuYgsw7K32O8gkzxrohi2ZbwSyGKn2PxfmC1H5W
         cJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761906952; x=1762511752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HzZMIk02Nqu6V1427BR/J6vEzSH1QrB2vBKOtaJmgIs=;
        b=Id/7WrK81pDBJxOFeaXh+NQBfqSbRWYh6iWqTZiDgsvWQo1hLEjZ8ax405rs5dPfII
         KV2ezfQTCP+j2ejglsSooQB0a9fzy5qsPM5KCEz2bHND0Z/FlPo7BeuxJUDwv6sw9l95
         ASn6B/4ic6uwyo096hryaOwbBiTmb/apYk+LGwRMgr+aPMsQAWyIf/JHRX3BcDvlzAPJ
         TEa1YjFe6ntZjxt+lOMuJRJyXmC1FMPL4bLoCC+D4oocCOuMDO2OSd2t2sqL74ECFkqE
         frr23XBnoggWb74+93qPlGofqYMKTJU45wqyWFD0JjEl8quP0vkM+5TrQkh3NWh42zOu
         UK2A==
X-Forwarded-Encrypted: i=1; AJvYcCXOdyvRe10YwLXJMP6HbaqWFCpdfMzLL+3fMzbyfaxjqO7RsCK1I3p5sDddqdjwE0H6+rDI8bfzeg==@kvack.org
X-Gm-Message-State: AOJu0YyTNC6FpvjChC4dXyKFjWquaos3BOBvzbXELrCgAfxOrLCKQnpy
	U7YNAgK3L6ivDnEZkGOlz2Gz2+pHyYta5JBQHZkn7Meqhr+ksqN63i0rgVK0c2nwhqI=
X-Gm-Gg: ASbGnctQR2Dm4U5f2kGV5uXzVFU8FFYAJQAQeMhPv2IeHsn+Qu9Tn1eOaye/cX8CaWg
	zbUpwSKcRfKhWBUV4A81NY2a57zldmPptuc/JBzbZ9wCk50M/X6gzl5LoJ/3ob9umyDQWqnsSWG
	og2QYm7CA/2cPGn5psByBuARdQeq/D5nDpdTc5RlGr1m9+UEWOVuFfQDQMQIm+Y2lJNXPRQU7Eb
	8vBApiCVdXNLu53+N1Oz3G8J7DOCvo+2szT3IDcbMwMz7b5ohHWWUpR0XfQhk6XFbZgwo9go2uA
	dHqW1gp4cBtmNfPYXMcUJLT/Xt1JzEpbw3PLKVKTIodxQv/iGLZfCjm/WtZKonA4m0UFfxKBDvE
	B76EOAQgrbujIZP/iob9QnIGmBizdiKbbORwOnXElB+JQkwSlQBbQ/bIZj3moepFC1BOTou+W5w
	L4wApnN9YH0Jd+wg==
X-Google-Smtp-Source: AGHT+IG7O9Y6l9WMooa1HgoKgieD6/ZhET+Ll2xATp5EvgMTaFPocp0XktS42l0peKgogXQ+h4nHIw==
X-Received: by 2002:a05:600c:4f0b:b0:45d:d353:a491 with SMTP id 5b1f17b1804b1-47730797bbfmr22646085e9.1.1761906951752;
        Fri, 31 Oct 2025 03:35:51 -0700 (PDT)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47732ddff0csm26082275e9.8.2025.10.31.03.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 03:35:51 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:35:50 +0100
From: Michal Hocko <mhocko@suse.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@redhat.com,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v1 00/26] Eliminate Dying Memory Cgroup
Message-ID: <aQSRBjdhdMR8iD6n@tiehlicka>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <aQHIDWDx3puT5XZd@tiehlicka>
 <8edf2f49-54f6-4604-8d01-42751234bee9@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8edf2f49-54f6-4604-8d01-42751234bee9@linux.dev>
X-Stat-Signature: r5s6fqhgb3kyzg33481nzgry91ezc3ux
X-Rspamd-Queue-Id: 903ED40009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761906953-589367
X-HE-Meta: U2FsdGVkX18vY4FDADoV7O1gOTAIUJssOIAFVuJRtUvO7DLn2up+4s5EHgo7XUI9zcOarpEBuzLNL5udAZUilitYqSN7D6E2+P8KarhgKRKj7uRcAwSOigFcB99W6kpOsJcM7oSCnYfi+z4LrG9OQ+BzruzBIPPbGQHeG8H6QmF78dKvKHqttbcZ8FQRU6ZfykjwHBJxzy1bn6Vi4kq52JKs10S59+TX9TXW1kj9i6K4TEhPB+mZ8J8dCfMYMvKzw6yxjtExy2/bIeZux/8fjfc3Ho49M1fY8/lTmdfiooXIZQzl3xJ5shyFaL49miEw8skij/v9GaijL+VqllyVPEPNCGbM/zTJ3lzBqjRKTD4xbgFr9j+830HbSA245UQgW8LXybI3t3WUZBv6q+O4n31unMejxxNbzGIyfRzZWfT2nWc3A3l+cOPEEba36wmpenNMhr5n5TEstO3PQcQu3q25sMEp2/9z9ZZGoKqEGm8ztWMVwni4SbeO5XQaFG1uC2LyIGWeqd2Wz6fY6Eh2Oa+BihS7knmhWS9re4KSr97F8gvi/HDEQ9dxhxIGuvGUEHGjNRcW4Pi+VsS+eqwNQt40XFuaMlCCJp6oEOBZoVRSfEW6UBULJvpcDShAXq0o1E5UTh4jGiCKBgCpWMWF3mNMLv1S0RPROGl8EyjPI6IuljzjP9zU54JlsqjV8UGdmn50ukOiuYkH5vMnP4xqsiIqT6HjKGPrd6rPnovSvkZtqdoEnaFTli7UyAIddoYOBg6IKrnrjud7QdB0TRgm6GtyUo4BV/WQUUNb4oUvmW4qp98C18fyLkOvKSYDmGgjm767PANYveOcvDAvSbhehmu3HFcU3WVcmJjCaeJUITRc+oG1eP3+0Hw1v7fosa739dzp4grLZq4l/jabZjGhj5R8Wq3vMdgIA0jxZp2cDOxOnJ3kxTrAnZeEranccg/T31RnMfIQyEuqb+MNta2
 qucmKCc1
 ZupoVs+9qGAxIaA4RDvIXvv7Q5MaQBY+R8C75DcEJCvgZxg606wPKRly66Z5o3lxhRus18O28KXvpCvaxv0YPBDceUBN+TdG2+XbIyJ2Fv6bBRGq4oVXGqGOoDoyHQpI71WgW2kJDjBSn4y0Lz0EKC+ouNV5flCj2GH5gFTOyyrsuOUOfLlfQL+q7CjEzfLPSrfgGQA1Rkr+e2xS9TsxEfRhPKBQc1vgFCQHCIIpuLT/HuBFeKwYHO4QwXFBKLPlEG8mMQuiSpIJAcfatcCmny+wNo0kMONNI1AyhsLqPCBIUBO/zJx/Dl9z4FYwubPZlt3Gv5qnfzhp91JcOmwYKlM+Lnr3Mnt7wl/cKBQexApI8AVrzJ9lwAbg7H78RflGrOai6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 29-10-25 16:05:16, Qi Zheng wrote:
> Hi Michal,
> 
> On 10/29/25 3:53 PM, Michal Hocko wrote:
> > On Tue 28-10-25 21:58:13, Qi Zheng wrote:
> > > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > > 
> > > Hi all,
> > > 
> > > This series aims to eliminate the problem of dying memory cgroup. It completes
> > > the adaptation to the MGLRU scenarios based on the Muchun Song's patchset[1].
> > 
> > I high level summary and main design decisions should be describe in the
> > cover letter.
> 
> Got it. Will add it in the next version.
> 
> I've pasted the contents of Muchun Song's cover letter below:
> 
> ```
> ## Introduction
> 
> This patchset is intended to transfer the LRU pages to the object cgroup
> without holding a reference to the original memory cgroup in order to
> address the issue of the dying memory cgroup. A consensus has already been
> reached regarding this approach recently [1].

Could you add those referenced links as well please?

> ## Background
> 
> The issue of a dying memory cgroup refers to a situation where a memory
> cgroup is no longer being used by users, but memory (the metadata
> associated with memory cgroups) remains allocated to it. This situation
> may potentially result in memory leaks or inefficiencies in memory
> reclamation and has persisted as an issue for several years. Any memory
> allocation that endures longer than the lifespan (from the users'
> perspective) of a memory cgroup can lead to the issue of dying memory
> cgroup. We have exerted greater efforts to tackle this problem by
> introducing the infrastructure of object cgroup [2].
> 
> Presently, numerous types of objects (slab objects, non-slab kernel
> allocations, per-CPU objects) are charged to the object cgroup without
> holding a reference to the original memory cgroup. The final allocations
> for LRU pages (anonymous pages and file pages) are charged at allocation
> time and continues to hold a reference to the original memory cgroup
> until reclaimed.
> 
> File pages are more complex than anonymous pages as they can be shared
> among different memory cgroups and may persist beyond the lifespan of
> the memory cgroup. The long-term pinning of file pages to memory cgroups
> is a widespread issue that causes recurring problems in practical
> scenarios [3]. File pages remain unreclaimed for extended periods.
> Additionally, they are accessed by successive instances (second, third,
> fourth, etc.) of the same job, which is restarted into a new cgroup each
> time. As a result, unreclaimable dying memory cgroups accumulate,
> leading to memory wastage and significantly reducing the efficiency
> of page reclamation.

Very useful introduction to the problem. Thanks!

> ## Fundamentals
> 
> A folio will no longer pin its corresponding memory cgroup. It is necessary
> to ensure that the memory cgroup or the lruvec associated with the memory
> cgroup is not released when a user obtains a pointer to the memory cgroup
> or lruvec returned by folio_memcg() or folio_lruvec(). Users are required
> to hold the RCU read lock or acquire a reference to the memory cgroup
> associated with the folio to prevent its release if they are not concerned
> about the binding stability between the folio and its corresponding memory
> cgroup. However, some users of folio_lruvec() (i.e., the lruvec lock)
> desire a stable binding between the folio and its corresponding memory
> cgroup. An approach is needed to ensure the stability of the binding while
> the lruvec lock is held, and to detect the situation of holding the
> incorrect lruvec lock when there is a race condition during memory cgroup
> reparenting. The following four steps are taken to achieve these goals.
> 
> 1. The first step  to be taken is to identify all users of both functions
>    (folio_memcg() and folio_lruvec()) who are not concerned about binding
>    stability and implement appropriate measures (such as holding a RCU read
>    lock or temporarily obtaining a reference to the memory cgroup for a
>    brief period) to prevent the release of the memory cgroup.
> 
> 2. Secondly, the following refactoring of folio_lruvec_lock() demonstrates
>    how to ensure the binding stability from the user's perspective of
>    folio_lruvec().
> 
>    struct lruvec *folio_lruvec_lock(struct folio *folio)
>    {
>            struct lruvec *lruvec;
> 
>            rcu_read_lock();
>    retry:
>            lruvec = folio_lruvec(folio);
>            spin_lock(&lruvec->lru_lock);
>            if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
>                    spin_unlock(&lruvec->lru_lock);
>                    goto retry;
>            }
> 
>            return lruvec;
>    }
> 
>    From the perspective of memory cgroup removal, the entire reparenting
>    process (altering the binding relationship between folio and its memory
>    cgroup and moving the LRU lists to its parental memory cgroup) should be
>    carried out under both the lruvec lock of the memory cgroup being removed
>    and the lruvec lock of its parent.
> 
> 3. Thirdly, another lock that requires the same approach is the split-queue
>    lock of THP.
> 
> 4. Finally, transfer the LRU pages to the object cgroup without holding a
>    reference to the original memory cgroup.
> ```
> 
> And the details of the adaptation are below:
> 
> ```
> Similar to traditional LRU folios, in order to solve the dying memcg
> problem, we also need to reparenting MGLRU folios to the parent memcg when
> memcg offline.
> 
> However, there are the following challenges:
> 
> 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
>    number of generations of the parent and child memcg may be different,
>    so we cannot simply transfer MGLRU folios in the child memcg to the
>    parent memcg as we did for traditional LRU folios.
> 2. The generation information is stored in folio->flags, but we cannot
>    traverse these folios while holding the lru lock, otherwise it may
>    cause softlockup.
> 3. In walk_update_folio(), the gen of folio and corresponding lru size
>    may be updated, but the folio is not immediately moved to the
>    corresponding lru list. Therefore, there may be folios of different
>    generations on an LRU list.
> 4. In lru_gen_del_folio(), the generation to which the folio belongs is
>    found based on the generation information in folio->flags, and the
>    corresponding LRU size will be updated. Therefore, we need to update
>    the lru size correctly during reparenting, otherwise the lru size may
>    be updated incorrectly in lru_gen_del_folio().
> 
> Finally, this patch chose a compromise method, which is to splice the lru
> list in the child memcg to the lru list of the same generation in the
> parent memcg during reparenting. And in order to ensure that the parent
> memcg has the same generation, we need to increase the generations in the
> parent memcg to the MAX_NR_GENS before reparenting.
> 
> Of course, the same generation has different meanings in the parent and
> child memcg, this will cause confusion in the hot and cold information of
> folios. But other than that, this method is simple enough, the lru size
> is correct, and there is no need to consider some concurrency issues (such
> as lru_gen_del_folio()).
> ```

Thanks you this is very useful.

A high level overview on how the patch series (of this size) would be
appreaciate as well.
-- 
Michal Hocko
SUSE Labs

