Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27318606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WzfqTN9d
Received: by kanga.kvack.org (Postfix)
	id 25C5D6B0628; Tue, 27 Oct 2026 04:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20AE06B0629; Tue, 27 Oct 2026 04:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4FE6B062A; Tue, 27 Oct 2026 04:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D22C06B0628
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:43:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C17EA09A5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:43:34 +0000 (UTC)
X-FDA: 85367767548.14.B5DC839
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id AAF48140005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:43:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WzfqTN9d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793090612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHr232roZz4zxvNcr7fz7EZ96bBQfhBelI7N1e6dtIg=;
	b=ibt+Z2yiLcTgB4k75c2iMA3R+mGc3scAv1zy1eNIzIkw3nLiZGgt/1TuEy/S7vBdmpjux1
	U2JaCSsdSpKrQ4Yh30BFH+G5lJWqouAyU/27B/E+I77OMerZcUWzLz4ZR6WDnGHoGYgPkP
	K6PMdJG51dLoO1toguqIMdh5zJ3NZmI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WzfqTN9d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793090612;
	b=wBlz3+PbTHKAU/VNBj1iTsXFLnsyJAWpyiZlkTWcZLVhb8BI7NSGTkjJWfQBKIGn+V8qqL
	V7aHL5yREDyighCTBGJ1oUaO5ilVo+XDwc68MgfJOWhPW5NJAJfBmC3MsABI8cmGFDUpY0
	eTGYhlwmiB0FBpiF73jCCJ9q5cswolQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36E81601FE;
	Tue, 27 Oct 2026 08:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9500B1F01829;
	Tue, 27 Oct 2026 08:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793090611;
	bh=dHr232roZz4zxvNcr7fz7EZ96bBQfhBelI7N1e6dtIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WzfqTN9dybqeLWoA8oUAZ1tXSG8xyenSoildQDFUPskrIwuh0Om8GmkGOBhQ5FsqX
	 3B6I40g9wmGk8NCIIhxhAbDqi/ZMQNeLz88bXgkLZL9wp3hp24AVldencxxNOmO56E
	 4Dk/LyzP9i6+CjPNOmovIvMvgBMfOCP5ftzi7ttPrA1HXuEw+YPYQEt8JuPCPhU9Qh
	 FTU2I/BXKFE66SYqvBcFQdHZeCq08jT60hhxAZK8vNRyQ92PVr8LzDAXu2OR6KFYh4
	 ggHTOX/ZZnJQfYnUIldz4DBR8skhm8PsS7DC9s4XnGtCHDusD1BrLy77dRYwXUQQzN
	 YEpV0CA1ETDaQ==
Date: Tue, 27 Oct 2026 08:43:14 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 23/46] mm/userfaultfd: write-lock the VMA before waking
 waiters when unregistering
Message-ID: <auBityGTDQjXURWg@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-23-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-23-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: AAF48140005
X-Stat-Signature: 1dtn4co5zm7kjnxt8g6ppo9ipm4m1w1s
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793090612-380959
X-HE-Meta: U2FsdGVkX18JpDmwAjujCFMQz7YNVBt/OcXwf8EZnVKEDLvXSUBCGhaCiXTGjXProFZLUZdno78JBu8B5Wc7iYS53rxcS0QFkaq1Cu6/WC63hb6RjahaogpXuwbGWcFh4vGpbmWwb7vCRP3HLZiXWQ413UDey5VOc5pjqiWsR8TF4DduddHOVMC1KUBGaeA5BKHySwrC2Y/z28fV8KYlQfp04Uxoj+DBoq3KqCVNj/DHoWQ92Q+UMCGRX3gLWr0cc4aMQcnTcKQw3h5i42lojKkHMIKB+pkXZSrXsw5XYrDcMqxR/fzUF7uHDSZZnXt6+enS74O2Rl2FzXVEmRWYIgwscWJNrW3GxSz25E6ujE7cPdLmOPvIDQjxgd/ZV+ixqv4//wXE+7FvM1Rux3Ma+Nj64JttVgIqyNvyZ9Mi697hJ6CJo0xyQKuknrCD7OsGnae6+RuUv85MEJSBe5AchcHc7NuByUmIDMUiHQbTK+Fb+/K5aTVweEVhB7MtThPhFdsdPFuXzf+d/dIE3CdcbXrt4eD118kDVtXmhjOj8z/J2lsrswj20lwbzJMhiT3qHuPxfCN7v+/bzJrob84lh0gALvUn+Q9J10i+GXuN7XilhSuvaq6hqZogkwm+2SFBBGl6GpAdXJ+dieTHpkuwWj5E8uWbAkkeE8MYIjl/Wc3cqnbmiyQVOXm2hnZkVdyhp4PplPpyceNXoYjcJnhM7nQbtQaMMZbHwl5mT8I+JDbjCEZkBsV6cbQaWDDvIo4EsfjWhwqq2pItkrB0JW0C+lpdklGKno6R0pEKDeoyipi/JkvC+6LdjLjNg61D1xS+IBnKbT0kwvd03L/zr9+aEmBMtYOHhevZ9FiN8CeUCm1NMzCNN9C/rqPcIU3E9tZ75Mx+eSO2e2fvirj9bLRlA7sUhDRrn2SzU1lQiRA+/Z0Hkh/sNnsg+xNt9WIZGP+RHdovXyD7486KNGkA391
 Jm9WQAxJ
 IFvaS94tA62PmjZH/XW0y7nSXVbsRM+ahGEl4OnMXy8jk2AD9E4StRHubGoZoMQqGTgT+QX90ouMIbZnfKKM+kqeoL/XQCfFbQQMPuBY2F56ICazyYim9/xEQZ5gGuBtNaw0m5Ih/peZN8FJn6CTckEKvX5HoTkhTfWC+UqjXFEDIqnTXHehBXux+Qt9KBRQSiLRyASLnnJaXto2HQ4j5aaB44m45eSWMiH8qQRBeftBg8e9v9/TCZteIGEx/3rmfpsASrDr/URwRJxcphbajmGG2hj458vNMCKjEhE5WDRs4OTsBht8h1TOZji694Xmh1JJFoCyfwXwq/8Hd/fzw8BaH0eglg+KH2knjDcJ8IXwN1SDkNsGRBMg5YZfkKIjtOV+PSb5lbGZ8OUZ2bINOjmu/9Xg+PAwT5XC0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:43AM +0100, David Hildenbrand (Arm) wrote:
> userfaultfd_unregister() wakes pending missing faults before clearing the
> VMA's userfaultfd registration. With per-VMA fault locking, holding
> mmap_lock for write does not prevent another fault from queuing after
> the wakeup but before userfaultfd_clear_vma() write-locks the VMA. That
> waiter can then remain asleep indefinitely.

Oof.

I guess userfaultfd_clear_vma() only implicitly takes the VMA write lock via
vma_modify_flags_uffd().

>
> Call vma_start_write() before waking waiters. Existing fault handlers
> queue themselves before dropping the VMA read lock, and new readers are
> excluded until mmap_write_unlock().

Clearly an oversight from the VMA locks work. I guess was always a Herculean
task to catch every single point at which there is an implicit assumption that
mmap write lock ~ readers (esp. faults) excluded.

>
> Fixes: 29a22b9e08d7 ("mm: handle userfaults under VMA lock")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/userfaultfd.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 669f71d485d02..7e30b5ff17be1 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -3991,6 +3991,9 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  			start = vma->vm_start;
>  		vma_end = min(end, vma->vm_end);
>
> +		/* Prevent new userfaults from being queued after the wakeup. */
> +		vma_start_write(vma);
> +
>  		if (userfaultfd_missing(vma)) {
>  			/*
>  			 * Wake any concurrent pending userfault while
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

