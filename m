Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD3CC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5984D6B0096; Thu, 10 Sep 2026 09:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549126B0098; Thu, 10 Sep 2026 09:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45FB36B0099; Thu, 10 Sep 2026 09:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18EA36B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:49:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48A791C244C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:49:30 +0000 (UTC)
X-FDA: 85197984900.06.9F9F8E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A29F0180004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:49:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VcbMv5HU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789048168;
	b=FXjKUApd39T9MCcEscyy7zkzQeLsqjXh8Sz6KjB7sJXWxX6WzkRYRCQgmfZ8nbbfdpAKlq
	En7byTolIx192gvHCLmg/dHBlMT+dyYaUt2oA8oc46/qRPaTzItggKFnGCsJN3hkHW9LQx
	lZldtRxaV1+9Gre4Ty+nydMW66SQv6g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VcbMv5HU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789048168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5eiED4lktihRCka1cpBIZQtpj9dVf8rEIp3TOrCkPJw=;
	b=0ndMYBfKHqpfA5vB6IaJ9Bl51uK82slMy9+9OdaPGG5b719VPyel+juc94o+TqsJI1qC+P
	Z17FCu5UVe21DSaEqft5b42F7+mempu7P043HsVe0k2L5I5aOcuZkK7YnCmHy0IlLSrYz6
	HfNT7c9BbBo6FkmxRn0xlpphmHu1w4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C439541738;
	Thu, 10 Sep 2026 13:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641111F000FF;
	Thu, 10 Sep 2026 13:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789048167;
	bh=5eiED4lktihRCka1cpBIZQtpj9dVf8rEIp3TOrCkPJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VcbMv5HULK77wKP10az3KO1TW0kA3G3vAfTUVtHNR03Hdoa7haoUf4pCR3cFXhWrE
	 4j+uXc1G+57DHUNYWzgfdEXQJOpolS7qzy+zwne9JC1Mejgowo2KM9PI37pqNUojCU
	 dwhB8Ini6jeGGeOX1J+8L8X9n05gUoqJuXj+p6vvKuj4Eg3sdXlCoxwSqDwca1/pvO
	 x377dWI82QkTiIUApht+mf1wUio10voVaQ0MyaldZtat05gWSvJ/QkogBrb48c6pL0
	 cTLY/SGEQ03uBmmNz9tZge9yeWyAZYZvXferAgQnnjYrsoPCtMN7pbcq+yWO/p8ajp
	 Kio/7QXCPzuJw==
Date: Thu, 10 Sep 2026 14:49:17 +0100
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
Subject: Re: [PATCH 06/12] mm/sparse: rename __highest_present_section_nr to
 __highest_used_section_nr
Message-ID: <aqK08thev5LJYQnX@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-6-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-6-008fc8d579fe@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A29F0180004
X-Stat-Signature: 1j313ksw61brtnz9r7dq5f6ngz9ze1rs
X-HE-Tag: 1789048168-672583
X-HE-Meta: U2FsdGVkX187fVPvANenktXHbB3HjcEe6NcMejsSYDTFCbUHqKEG3zc53q1diDHxhb2D5KQulGOELxihdEQtjtoO1TlNJwpVMK3bO95W93xdC092IK/iZudvfL37s6ghM1OFnj34QwAghS0o/+LO+9EY4Z5K+LNVzC9lGLfvdrPwZgI+mFsLm0/V4FIz4m1keu9zgQ834VMX9i3AvdAKSQXWj1ptsXloc7jc1Vyr2n38pBVqAyQ7vHMDePjJDZgw3zXrKWiAHjA7YjLaV1L9SGikdwu0H1gN0fXDY1LI3DVgfV+LhHFA9j7jcPjprMBwds2ddsn9p8jBcDEmF4oRDJuqpkYF9h9JEBMhZkGkifdDJVGae8AfRy4i8U+IncxHQbH+1PhNirmPpLjiXUZFydog4hALGDoADhCVlSrsvXlb1U+EU5rg8yZ5FA7QL0I1x5paOcl9Is/WdLA7h16fVg+7Qz3T3WTkOSC49IUuc1B3ZUDLls6BwfgTvA2XgP5JI2RY9EY9TYpud/MvcdeRze5qUNxCFnLa3m3F6rDd3YMD2nIvmSZdXFKySLQZ6y4iWmqjGhOTVI9Ds4Tx/oPpS1fK9IvQVRyvtNp3RXH9/m5GLU9Qp8LfRNW7tvDJKmHdb7RZ0PlTlHbvnYEH63HI6GEn7QcUOzkTQxZnHFb2v4wvnvlRQefS0hSRBxXlT6sZ5ckFkeRgLrqmMFc0UL7cWnXd+UVhUrKNeTjf3JlTDloMMNYFOimRGfMCOpEZ4ajhyyrQSeb+p4AGhOxOoJUK/OJoT5/Rnux9BKzYQuXU8y0m7i6suqnwPvyJTai8d0Szjjabx05ZMJurRVl7Uf+XJBSruZH6aNasx79IOpwe/9Wuy+/iZW80fhztLhANWa/C+nb8RZxRK9qLtA8TVQUwYqqKeLp+r1BaFOsp2xk0qSgmTt0dc5SQLBMNfvYasbl92/J45mnrn7c7/SNs9Cm
 E8Lrkk6j
 m1yOswahiBQFUKtDi3bMYizFtVRr18riu7BmLYV7nv071fjSCJ/YFPj/X4iPH+GUl4fVY2B707F4C8zIfCgAnlekbs2a6T3Ij+P0HHaoTIZGWQpk+bnZuxl3G6idhuKxK2OHWkRvHOOw7+NFNqwXeRjHEp2J7A28EHjd8UYNt2i5OWwNzj5ZI867aXrPC7yszcPWrsBDuAbw+INSlYP9RIPEwgzg3oTk2tPU9rvf0lxtybYf8SjzdFsPKxK3bOc3rC7ZFRX7qRyaNvJr7Kp9crymRYG6I/tduM2NXwq4WseIXe6ry+iddB1t4YuzXavNyzPZP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:32:59PM +0200, David Hildenbrand (Arm) wrote:
> In preparation for getting rid of SECTION_MARKED_PRESENT, rename
> __highest_present_section_nr and clarify the comment.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Seems reasonable so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/mmzone.h |  6 +++---
>  mm/compaction.c        |  2 +-
>  mm/sparse.c            | 12 ++++--------
>  mm/sparse.h            |  4 ++--
>  4 files changed, 10 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index c9ae7991a8b20..19296e8ef44f8 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2170,7 +2170,7 @@ static inline struct mem_section *__pfn_to_section(unsigned long pfn)
>  	return __nr_to_section(pfn_to_section_nr(pfn));
>  }
>
> -extern unsigned long __highest_present_section_nr;
> +extern unsigned long __highest_used_section_nr;
>
>  static inline int subsection_map_index(unsigned long pfn)
>  {
> @@ -2269,7 +2269,7 @@ static inline unsigned long first_valid_pfn(unsigned long pfn, unsigned long end
>
>  	rcu_read_lock_sched();
>
> -	while (nr <= __highest_present_section_nr && pfn < end_pfn) {
> +	while (nr <= __highest_used_section_nr && pfn < end_pfn) {
>  		struct mem_section *ms = __pfn_to_section(pfn);
>
>  		if (valid_section(ms) &&
> @@ -2324,7 +2324,7 @@ static inline int pfn_in_present_section(unsigned long pfn)
>
>  static inline unsigned long next_present_section_nr(unsigned long section_nr)
>  {
> -	while (++section_nr <= __highest_present_section_nr) {
> +	while (++section_nr <= __highest_used_section_nr) {
>  		if (present_section_nr(section_nr))
>  			return section_nr;
>  	}
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 4994e200bbecd..f1b2060eb2016 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -216,7 +216,7 @@ static unsigned long skip_offline_sections(unsigned long start_pfn)
>  	if (online_section_nr(start_nr))
>  		return 0;
>
> -	while (++start_nr <= __highest_present_section_nr) {
> +	while (++start_nr <= __highest_used_section_nr) {
>  		if (online_section_nr(start_nr))
>  			return section_nr_to_pfn(start_nr);
>  	}
> diff --git a/mm/sparse.c b/mm/sparse.c
> index f84bfceb53060..2b41ae36f20b8 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -164,15 +164,11 @@ static void __init mminit_validate_memmodel_limits(unsigned long *start_pfn,
>  }
>
>  /*
> - * There are a number of times that we loop over NR_MEM_SECTIONS,
> - * looking for section_present() on each.  But, when we have very
> - * large physical address spaces, NR_MEM_SECTIONS can also be
> - * very large which makes the loops quite long.
> - *
> - * Keeping track of this gives us an easy way to break out of
> - * those loops early.
> + * Looping over all memory sections is expensive, especially if NR_MEM_SECTIONS
> + * is large but only a fraction is actually used. Keep track of the highest
> + * section number we ever used.
>   */
> -unsigned long __highest_present_section_nr;
> +unsigned long __highest_used_section_nr;
>
>  static inline unsigned long first_present_section_nr(void)
>  {
> diff --git a/mm/sparse.h b/mm/sparse.h
> index 744ae29002f5e..7c5d82ceb7142 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -114,8 +114,8 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>  static inline void __section_mark_present(struct mem_section *ms,
>  		unsigned long section_nr)
>  {
> -	if (section_nr > __highest_present_section_nr)
> -		__highest_present_section_nr = section_nr;
> +	if (section_nr > __highest_used_section_nr)
> +		__highest_used_section_nr = section_nr;
>
>  	ms->section_mem_map |= SECTION_MARKED_PRESENT;
>  }
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

