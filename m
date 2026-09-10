Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFAD1C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722C36B0099; Thu, 10 Sep 2026 10:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8056B009E; Thu, 10 Sep 2026 10:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610AD6B009F; Thu, 10 Sep 2026 10:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1926F6B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:51:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 742354050B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:51:53 +0000 (UTC)
X-FDA: 85198142106.10.F2F6C61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D58B2A0008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:51:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4IeR6K4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789051911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKA3SAsCwTPWb3dPRkQeAzxCc+HHNUR0nyN0zBxrxTk=;
	b=dY+N/Lw8/xbrLVvsTkCf2GaaMrj7NY7bY02lBlOWy+TqBOrjcULWpewIjpW8iTJRBbw7hx
	gdAkQzlo6cX+dTYXjGjob3siI8uinuLfrd8NHA2enhL6Y11CL+hhVAN1rk2LJRtJgjb+yW
	UTDv/6lmIToxTjWQShtJoQtyyw0DFzI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789051911;
	b=AUcrKRvs5g07x36UQEJsPF2WVphIWHMqvhMB75GS2l7xJpJW9lHt2oK4NlS4t1A08/ErqY
	qZvn3HfF860uLpqyRZio4jF34nfGA9QUZ04YnMp+uakNCkWvHA6RiY4BmyR70ZWkviWWDf
	ypi6UtSgwgQ+Q8eCjORTrrYMyg+QQvg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4IeR6K4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63E89600E2;
	Thu, 10 Sep 2026 14:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C8C1F000FF;
	Thu, 10 Sep 2026 14:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789051911;
	bh=QKA3SAsCwTPWb3dPRkQeAzxCc+HHNUR0nyN0zBxrxTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e4IeR6K4gUKeSBAujGH+MKT4fOWNEz9VqQPkSMplHJzxLh8B4iN0Y4MJCwaMAdPBf
	 PACby5HC1tL9sC+aAj+zHjq64Uc+Ur3UaZVjsdf351gH42WQGsE1gq5a2m+Kc9B9hJ
	 HRLWDcq3k6QjkB1R4B8rs0PnBWFmHojkspiFP9qB1h2QFqpq6x7D5pdv+HIEcm7K4d
	 rJ7PdbLawcU2QLlzV7zRv6vmIAJgSFrNattw1dWdaOxuuhIH1UB8hiXtVwl/xBw1BD
	 8VA6MGaaWC4pzOo1ZDHyEk648RbYscoFea2/LnKpo/xXjOrNIBea1+VxcFF4APx0EN
	 ghr+JA8aupWZA==
Date: Thu, 10 Sep 2026 15:51:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/12] mm/sparse: move __highest_used_section_nr handling
Message-ID: <aqLDR2jbBVdupryZ@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
 <aqK2_RpAlMbVYcuN@gremlin>
 <c72f7358-cb6c-448d-9ce9-c17b425964bf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c72f7358-cb6c-448d-9ce9-c17b425964bf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D58B2A0008
X-Stat-Signature: w3qfk6ewp9wzrq9a6hdpfrtrzf145r6y
X-HE-Tag: 1789051911-253387
X-HE-Meta: U2FsdGVkX1/AGnXi/Ovz6oG4wUcTOEmCWssRRHfaCdGqxdUZQ0xthQ5MQ6WWw7+iP4Je4KKmwbupGQnV1mtdpan13hWIf1CBABT2tMUhakCE39sSh0mhsX/W9I35tqwvKd0OSEpl7EGCukoU1iODKhbk5MVbhkvQ7iejOMNumGfCLM0wHPQwODvaUfQiliyVafZp/I6AzS710cdWoGq+dXK60mbShygyCdZOOzrgLry72Wtp4Ljewixqij/A8Zq5Uef0QxvdwAApEmTnVYG1bcBnC5u8CcgIkEFFoQh9kLvh+zEqICXDy2hXZuwvUQtxg7S0JvZ/dFaSFwAS9vwyTPRNy+MxQvczjVBlAbCdmRDukZPGzacDkrvEpofphV49oZfWkg3qSnu8ZfENPTHXHdu7FkaT3xuMyoE46JiJ3hAzy4AjohsDt7nan1103CgGD6k+tsf2LKMCiC2eFPGEjzwn0kqN5XA+QniZ0Jq6vMeughTqpQysbuGDCBwfJFiShPjg6dOSq/hcMQgAb7WkfB7kXFK97JjoxdVtct0gF6A4a+PGn9sfWhebkT486S7EQerxO3v+jMx9Xn4SkaC5MQPlQG+YfxSduocGZB1Aw/JZPudRWQUupAbKlz2ObfHGg6+5wW3q0lbT/f+XtRAVYKk9lwhV/zuWwnzvtTNfxq2FcwX0dgooBri1/VPMdS+QUT3NFvxDq8wpEQhuYuyoi1CyBoYRzndKrbl4Zgf9NLcX1Zx4rMMuj1jdzWr7cKeQ+fwiqDvBqQVTyRpGHl/u3wiBcxdjDqeEDYrf1kMgMDbQHY+9d8gMTLQ2L1ZLV2EqQaLd9rD/V428wqV/o+Kyp8n3mN1Wkh2Ygm71ohkfLuGbeCXScJ2jJmtdZv25sDatCdEGIPlr5Ybmd8rvTyb7bLN4z/g9MFexa0gi2xUqOOE34GJhOcJxEzCrrb2ae1aVZp0d8JZS5l3tCc8/2xJ
 yPSvgpr7
 0WVFGqYv2INy228L1vaejDusqgRNVSnvFeiTWZT4Fnxaq/v6xIorW15nQGp7LCBXgUocypO52DRa5ulKvmhAImtIoBNtTDjFel9CQyvv9J0jD7aLc9eEX6GnTBcu7xWacbEoBiOCPq2gVO/DSYeKqEAbqUSFesSKKBD7ZhJ033lQghQ8FgGdKZUKPhpCmCW4jEV+YsTp4n7MXjltJBGoe5Y3fMQWmXbJFJ93P6R8Nph+0fEH7xRZjc135COBxjJ/HAHPecqo2wyVFnaHTTeTCg3mdnjQQ6V4/Fo3oqlUE18k50ddnUXH6DuUkHw0WVgu3TOaW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 04:29:06PM +0200, David Hildenbrand (Arm) wrote:
> On 9/10/26 16:16, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Sep 09, 2026 at 03:33:01PM +0200, David Hildenbrand (Arm) wrote:
> >> Let's move it to sparse_init_one_section(). However, to keep early
> >> boot processing working, we also have to initialize it in
> >> sparse_sections_init().
> >
> > A why might be nice :)
>
> Agreed, I'll mention that.
>
> >
> > I guess preparing for removal of __section_mark_present()?
> >
>
> Right intuition :)
>
> > Also good to have arguments as to why this is equivalent of previous
> > behaviour.
> >
> > E.g. higher pfn = higher section nr so naturally the highest is the one you
> > end up wtih at the end of sparse_sections_init()?
>
> We go over all sections, just earlier.
>
> >
> >>
> >> Should we use READ_ONCE/WRITE_ONCE with __highest_used_section_nr?
> >> Probably, something for another day.
> >
> > It might be worth expanding this a bit. Do multiple threads read/write this
> > concurrently?
>
> Hah, I'll probably just drop it. I was just stumbling over readers vs.
> concurrent updates and thought "that looks suspicious".

Ack. KCSAN will bring our sins back to bear if they matter anyway :>)

>
> >
> > No functional change intended here or is one intended? :)
> >
>
> Certainly no change intended ;)
>
> > Before it was:
> >
> > mm_core_init_early() -> sparse_sections_init() -> __section_mark_present()
> >                           sparse_add_section() -> __section_mark_present()
> >
> > Now:
> >
> >                                                  mm_core_init_early() -> sparse_sections_init() [early]
> >                                                  sparse_add_section() -> sparse_init_one_section()
> >
> > But also called from mm_core_init_early():
> >
> > sparse_init() -> sparse_metadata_init() -> sparse_metadata_init_nid() -> sparse_init_one_section()
> >
> > Are both required?
>
> sparse_metadata_init() relies on __highest_used_section_nr in the
> for_each_early_section_nr / for_each_present_section_nr, so it is required.

Ahh yeah, makes sense. Worth spelling that out :)

>
> I could probable move the update on the hotplug side into sparse_add_section()
> instead!

Ack yeah would separate things out a bit between the two!

>
> >
> >
> >>
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >> ---
> >>  mm/sparse.c | 5 +++--
> >>  mm/sparse.h | 6 +++---
> >>  2 files changed, 6 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/mm/sparse.c b/mm/sparse.c
> >> index 2b41ae36f20b8..2d0f2db34f4cf 100644
> >> --- a/mm/sparse.c
> >> +++ b/mm/sparse.c
> >> @@ -177,7 +177,7 @@ static inline unsigned long first_present_section_nr(void)
> >>
> >>  void __init sparse_sections_init(void)
> >>  {
> >> -	unsigned long pfn, start_pfn, end_pfn;
> >> +	unsigned long pfn, start_pfn, end_pfn, section_nr;
> >>  	int i, nid;
> >>
> >>  	sparse_extreme_init();
> >> @@ -187,9 +187,9 @@ void __init sparse_sections_init(void)
> >>  		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
> >>
> >>  		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> >> -			unsigned long section_nr = pfn_to_section_nr(pfn);
> >>  			struct mem_section *ms;
> >>
> >> +			section_nr = pfn_to_section_nr(pfn);
> >>  			sparse_index_init(section_nr, nid);
> >>  			ms = __nr_to_section(section_nr);
> >>  			if (ms->section_mem_map)
> >> @@ -201,6 +201,7 @@ void __init sparse_sections_init(void)
> >>  			__section_mark_present(ms, section_nr);
> >>  		}
> >>  	}
> >> +	__highest_used_section_nr = section_nr;
> >>  }
> >>
> >>  #ifndef CONFIG_SPARSEMEM_VMEMMAP
> >> diff --git a/mm/sparse.h b/mm/sparse.h
> >> index 7c5d82ceb7142..a3af4967fd5c5 100644
> >> --- a/mm/sparse.h
> >> +++ b/mm/sparse.h
> >> @@ -97,6 +97,9 @@ static inline void sparse_init_one_section(struct mem_section *ms,
> >>
> >>  	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
> >>
> >> +	if (section_nr > __highest_used_section_nr)
> >> +		__highest_used_section_nr = section_nr;
> >> +
> >
> > Could also be:
> >
> > 	section_nr = max(section_nr, __highest_used_section_nr);
>
> Ack!
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

