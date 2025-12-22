Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07B30D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 06:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701A66B0088; Mon, 22 Dec 2025 01:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AF806B0089; Mon, 22 Dec 2025 01:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591636B008A; Mon, 22 Dec 2025 01:16:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 47CD46B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 01:16:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 015411A0A31
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:16:19 +0000 (UTC)
X-FDA: 84246097320.13.BBB445A
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2E510C000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:16:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4NIKJlWr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766384178; a=rsa-sha256;
	cv=none;
	b=rlSLkcjH7IX+M1yTlyf+miFAFQGyJzaUL2+/4kCySlFD3xVoZJjOINSWz83v5Brj0G92Hk
	/wkC93yAXuEuGxILdBxF2RrurkVQg7ngfZn8og80JobqO1srhmjwvXhR8CMx4/EGg2IBf0
	R4qqWAa108sMCv5BqDgASdopzClqa5w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4NIKJlWr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766384178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKlYwDKHeLnktmF0WJtLvL/mlQQWgFKsDt5lGymxEgs=;
	b=WAjot1bxQX1eZOL0u6ALHbRM+w+tsSPnAx1jIldeO7+nu84wUAPlx+vZftUz7psuHmK+Fo
	0df5KWHFwbJQPS6RefXED9M2x8SMn1DVSPUYT6C6iZZ4C/jJF7ikv8E9KRzYag6jbkYpVn
	rAJEYiaoL4PwZHjuFHrsepkLX/XI3fk=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a1462573caso462145ad.0
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766384177; x=1766988977; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sKlYwDKHeLnktmF0WJtLvL/mlQQWgFKsDt5lGymxEgs=;
        b=4NIKJlWrDJunyE5aE3Tub3SZE6YrbTF6ePL+kk9Ol9RsCTu/e8t+sL3VKYhj9tE8VC
         ljG9Vsseb2ehU8ltdYkbPGo1+y3EcTNeLgYAnhpfsKUUiSefztvCeYRiEWTciYlor1ll
         jrDeCBuwHmxdmJe9qWeXBpc3dyWWsq7u0V9EcvpyGCPm6BsASGWAxQVMM4rZ/bkiMak/
         Kh0V0jrVCiIx1gzeubkib3RVhwN+0hJL5eDAyJiZ+egrQJlCS9W7E8je8KHfPxFYVNkE
         huPFW1245Zrl4zE81z+hmJB6vGsu2TfSexNnUUbeH97Y1Br2N/N0m4+OxyIYWEKYQ0KS
         VDTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766384177; x=1766988977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sKlYwDKHeLnktmF0WJtLvL/mlQQWgFKsDt5lGymxEgs=;
        b=QBDl8uv0VjXjfudAHPA+drhXMBcUP2es7RgTNvakKDH1eU3IAJgYVb1le8Wpu10qim
         cNxV8ozweYsIlJEV7ZN1KJwJfqg5YanjUKh7NJL0zJsIozpNIUUO3eayEjN7N2jPH04b
         D1rffm8ajirMiGIF+VenRDnvGC0WVM4eDbFL7JMpbZZnGysoz9VonLqqgZn9/oTbxvst
         xrA4NR8sEqYXOaVz7rWtc/Q9SstKvdg4OgL9DNppPPuqnNC/coAqbUQse5Qwq8j8yfHG
         MNuET//MitC+deYGE6N2D6Gvwi91MwGSXkOYJ2zEnVDSyGmWu+qiCZ9NiNFnEjZUBgQP
         hDxA==
X-Gm-Message-State: AOJu0Yzxn8Evtga0PZVnUlDXjq2WfG/MpRX810UUrQ2P/NSmx1bTI9Gb
	RmLB5LqkMXWW3F83XyOhSf2SJKwDyKXHqSPhEHmgEutAPNn8EuuhwmA9+F6VJI7tOw==
X-Gm-Gg: AY/fxX600V2PWyZ0OyU+Uiv2qI1DwkB1ycE2Syj/2fiUgFhP+Y++Y6O/gsRZN5xRHii
	OlBwWFvHUtL09mCyjOeQq9WPDymfypLxjzp/l+2N2ZqT6R7jTtWPY0lbTvUBnj0b6Es56Cxc+8R
	dHvK3IoL6dZ/uejj3yoVkWI5hlGCxZY6oE8AUUpSJvMUCnFqFzS9/9iZNXWOudL/9y4G2pL7/18
	e33VSORGqC893c96O78uVlJuoPysXOw3Iduzxk8ZMH8VXCCr7Ewg52rUQ/6kU4qtRVlOll7hZ+X
	g//QBWp9L6SbgS9WFUuMzR65QHFzy7Fclg0/jPY0jHjFDIoOwlrl/6ixBzgDEJtKkay2JmI/YXk
	82YzayO03ryJn8NLw2nS/fggG4Qy3RgNKWWMxilHolsGqtCstD7DQXJKJqeXFEDpNWpmVksKzR7
	DiZty1I7KKS+jrBEnbiwhQrdlOvKfuzixMCmzpR6YRWv2D4UtmaIXy
X-Google-Smtp-Source: AGHT+IHOweUx0BGgzRR3Uc5xIVtiHnSb9Bezh6rOocQ9AsReM27o8TisrBOm2xsLcgOS2vYsn/Ffgg==
X-Received: by 2002:a17:902:ef47:b0:2a1:3cdc:7720 with SMTP id d9443c01a7336-2a3142e92d0mr2719085ad.21.1766384176711;
        Sun, 21 Dec 2025 22:16:16 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e48f258sm9029528b3a.47.2025.12.21.22.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 22:16:16 -0800 (PST)
Date: Mon, 22 Dec 2025 06:16:10 +0000
From: Bing Jiao <bingjiao@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, gourry@gourry.net, Waiman Long <longman@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	 Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: respect mems_effective in demote_folio_list()
Message-ID: <aUjiKmlLEitn2oHU@google.com>
References: <20251220061022.2726028-1-bingjiao@google.com>
 <20251220112044.ee858d2160f819e181598ce1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220112044.ee858d2160f819e181598ce1@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E510C000B
X-Stat-Signature: nq3on3hnq1is7nrgyrtigmkeojkihfjd
X-HE-Tag: 1766384177-460461
X-HE-Meta: U2FsdGVkX19W7KizMfKHSd+3KAh0hkTrZh8cP7tUdno1oSlsS0RvSoerqWZ8gwVJcj85aFhh+IlVUmnU0rjwdb+4HX8aEZ8PbA/hSQDkuKHanTomFvodSKcl/10IXVUee/8khulPEHg7Fk32Uab2DqFcP8d4pG2zHs7N/w1pZpfKrULVjm88RKD6P9DvERXOCMoKThNPUmSVOJtRQxpxxuwwXJyPwrxN1ek5pDAZwcXvLQmeClulF37lExme4D2mQhH0pSfgRICkq1/yytez79jTKgj9UZcEBapwEsniltlwnezTRPHiOjGKNja3lXd7BblJqM0BRYU35cvqVNkiSCCr74h1zUb8BrngJrTkZGKM8fZi/+Io6URd2gSnibx9Q7+YuQ1QlI2eXqTWURGGAOQLAzBibzj45AYeVMjRFi5UInde92ZWeWt8sefmoY+tCKE4JyutOHVzOgeERRbWCPsQ6dt1bEyBZ+Jj3MrbCKjYqZ66opHk4ntypmeEjyqLmEnRMPivqPJqFNANqNzpG2f27R3yDfVxtCacUlaWADlRMV0hCeKuM3LczJ1e3gxqEWIsOA1hOw4bSpKU6DdZRI9zTwkPRnd9qJTI5odJRzh8vPBLNsvz5YtIugkuO1yzpsgfg+odqKInS+ewQHKoABRfnmWgID112P2QHeotixaeuxGgAVOQ0feIZdwNSb5hlPOojSv17W8EH+U6pWxxyQj/KmcoC4EelX8fqaRMM6ieN0uEygQrPJvbt1p3mO4Ei4gTCexnijvyKwpoxwAYqhDMqUv9N9hgojdKcR5XM8WhAEbPeLKW9rCVWe2jr8e0ph1gEfGSFapBsvrP/GKM4MJNPNL2ZU1flju2mjyd/otntVnTMqKDYrWcs0OnszL2zWS31fR3xy3SiP7n0j99uYgKoCYSqE6mgZlHa8ynMdb+tywEUFQWTnz47uk07G76HwwEDmutIZ2Y+CS2M8X
 bX/dzjF5
 AhJ9ypSKfezSszpfgvvoJZ4lMfDqoz+QG/3ksJmRsSVn508Gr2I14Nv0sJolwJNNUGd13H7Ht7TF0outXDOZW+B+Op01T8Zc4S8HU5EGkXJM1KIgUfy4TLsozbYURhtiJAOGNdEVBfYlc33YGx82JlWQY7xEl7Ib3Opc5QKkRXPzqDTqzs0kxJmAfnPe9lj8at0Wtwlaay40oEys97C5WCWCLak/nmkwk0eftFxywPAJzUFz8RTmlqn79LO5LGAYpace0Dl0kG5IFL9yffHd6Zfaqf4UqPeRzoqeMGQsIlLhCzsExi3Ln1yx9rgLvm4j1X7MeZvn7qVaYr6Q5q3c7fQhUQJbvHFQm3n9rYipnMO+PkgkL2jWb8DVOMjqtPUCvV9U2xAjWUUjOqp6gHyGAZPo4X2Rh2BmtCVR/pFugdryUOV4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 20, 2025 at 11:20:44AM -0800, Andrew Morton wrote:
> On Sat, 20 Dec 2025 06:10:21 +0000 Bing Jiao <bingjiao@google.com> wrote:
>
> > Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> > introduces the cpuset.mems_effective check and applies it to
> > can_demote().
>
> So we'll want
>
> 	Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
>
> in the changelog.
>
> > However, it does not apply this check in
> > demote_folio_list(), which leads to situations where pages are demoted
> > to nodes that are explicitly excluded from the task's cpuset.mems.
> >
> > To address the issue that demotion targets do not respect
> > cpuset.mem_effective in demote_folio_list(), implement a new function
> > get_demotion_targets(), which returns a preferred demotion target
> > and all allowed (fallback) nodes against mems_effective,
> > and update demote_folio_list() and can_demote() accordingly to
> > use get_demotion_targets().
>
> 7d709f49babc fist appeared in 6.16, so we must decide whether to
> backport this fix into -stable kernels, via a Cc:
> <stable@vger.kernel.org>.
>
> To make this decision it's best to have a clear understanding of the
> userspace visible impact of the bug.  Putting pages into improper nodes
> is undesirable, but how much does it affect real-world workloads?
> Please include in the changelog some words about this to help others
> understand why we should backport the fix.
>
> > Furthermore, update some supporting functions:
> >   - Add a parameter for next_demotion_node() to return a copy of
> >     node_demotion[]->preferred, allowing get_demotion_targets()
> >     to select the next-best node for demotion.
> >   - Change the parameters for cpuset_node_allowed() and
> >     mem_cgroup_node_allowed() from nid to nodemask * to allow
> >     for direct logic-and operations with mems_effective.
>
> If we do decide to backport the fix into earlier kernels then it's best
> to keep the patch as small and as simple as possible.  So non-bugfix
> changes such as these are best made via a second followup patch which
> can be merged via the normal -rc staging process.
>
Hi Andrew, thank you for the review and suggestions.

I hvae sent a patch v2 for the backport. However, I forgot to add
the CC:stable line. I will fix it in v3.

Best,
Bing

