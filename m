Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D0FA606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wv3U0m6b
Received: by kanga.kvack.org (Postfix)
	id 1D9246B0617; Tue, 27 Oct 2026 04:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0E06B0618; Tue, 27 Oct 2026 04:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8416B0619; Tue, 27 Oct 2026 04:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEA0F6B0617
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:18:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E459140932
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:18:34 +0000 (UTC)
X-FDA: 85367704548.08.B2F7188
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A761280012
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:18:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wv3U0m6b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793089112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNaIZxw7IJwq2m4pWciWh2XxN6fAoF3MaHnk6xQdZpg=;
	b=6/FpaVV3wkhT843bHBlHijmlDVdE5r8oZ77wafLsD8vhbFyFWnC77eRSAtGQVnhBrsuTWo
	I8PaLLdN3ck89Gpf4+wANRqoJ0mC2U/LqXjBktz9B/VP1p5dddMi02Q46EpizsUSCeVlEj
	l03tkGgRv1K6u2ApDZ5xvNtKx6NPOO4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wv3U0m6b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793089112;
	b=HN7d8gUiEv1sNhqzlfx/y6dxMwXw4Ut7uM5DNqmTvHtIewNstKZol0P4uT5i3mRgNpuSpJ
	ASEL6UU/Zodp8WR268OH7DKenVn+n26nWVeKMsR+BqtENUU/d+8Wq+UwiOTpTLrbJ5Oi2y
	0S05jmIYlLObnNnaaGd3ognRxHydURU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F11E6020C;
	Tue, 27 Oct 2026 08:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B831F031E2;
	Tue, 27 Oct 2026 08:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793089111;
	bh=nNaIZxw7IJwq2m4pWciWh2XxN6fAoF3MaHnk6xQdZpg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Wv3U0m6bdgC/XJfyU+UtzFda0UzsHI2oo0g4dnEd+2qDka1hYTubK9xs0MQzM9/F0
	 opyHLijkCDkmc8Mh+eubcuUH5IIQw7FQ57YIeoVk2vtL2c8SLhkAM2sEN5RrIVG82g
	 vZFgBHOItm2xTVdpXD6UR0Y2J086AC2XOHEA4tb8/7+2E4YmocW8HQMv6IqKYrsRJ6
	 5a4wR9IokX1zaLZbOiosOyesIgcRW0AKO/LM9Pil1p7dFG/hxasDfp9LqVi1nNSOA2
	 rSW6MrTJlqnaDuJa1/fKNJL/ySGmhch0vv5ME7OJAcHm2qqoxgb0HnUXS2cIi9pWA7
	 rfVDzIU9g5xaA==
Message-ID: <d53e610e-83d5-4504-a9d2-358310f69b4a@kernel.org>
Date: Tue, 27 Oct 2026 09:18:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/46] fork: take mmap_lock before copying mm_struct
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A761280012
X-Stat-Signature: wka7gecxpwenoyhsrqpd9qeyxxajwdsn
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793089112-901316
X-HE-Meta: U2FsdGVkX19hSpFq1ZCUzh0Z3vGUYumCcObRi5XsOPuP5sBPSL1E4dmaGg3CoIAqOet421Cew+nqe+YKFlh9MU18p3hCjIPH6F6G2zHvDXUe9XOPMn8pNt2ig2d7t06rNGJXChb1qgK6qmdT4pA27Y6KyRQVoVPjEayDpoxWL/t27opD8ZhpKzaDAs71b99K7fAY0kRkO8HHcgh3TmpfPBIs5Hw9XmWIxcY5mDfoGmlehkdljc3CtEtuX/OHgXAmcCqgZ39lGgJZJ2e+FeD5mh5ggKbt7ebbJAaccB+tnoYNi+ow3zZ2+cbuZPL2atPU+q5P5RdJoBGeKQAKaMFd22R3U+4zad6qbPuAOSrInudWGCezuCdbr0+PRDXdOl9JkMIfIn7+H26Aefh42rGpsFtPRXhidvrcXI3DNLMypAp8fB0NjQ3M+sioTLHEjL/254m6uJKB4zE4ZY0C2v943DqA8a4r3RE9YKABdW8w3eePeIllSQYvkTtnVuae1N1MzU6eE9lKsOyPS2krCnFcgsVRjcbto6uZgeilaPVBvrKhNkn6xtHGcjyGyISbeSJauhtJD+HgjxwK0rqI7x3zOXXXfuH9yqKclQqdn2iP3yQF48HeHU2NdhXlxBd4bW6aUtIaLu7UyIHipLI+dkvi4T2nneMJqg0xfeRez6rwo4wFZtfCLX6u/HPjdrp29uOTmdF28ZWrrwSJV6+lC3qPcdD38683xmMcL5lRu1PKHEJPqLEmacEK8Maro0uXESITbQCCQoN+sXuwNniu0r/ZCnWgKAeGYMBnr/FYhTpS2zIm0Ok1LYaT0Qkx+5xxFFt94wTTIakvbLgBJLcMUqbgxCENAK2/XVN5C3mDPwu+Dzg60tMG3Jx0xW6zEnNwwZchBtHqJqzK2SorKRo/xMyBXaY54xakLHpM1BoEOKSOhY92YQ9JvVeDCizTl+Rv7rf8Jc0ZlMAiVj/cesrY4yo
 ExN7nD00
 4SwIg3SPa8+8L0pFEMUZX9mmFtUei7R+xz5ooSG6c1nS3TAWZRPRd29N75HVqDDNrab/5A2WTlncbi+gB4b8lBj3z5tpD60PXy3FFfKb3OtYA26NJcMJHlkeEABalooMoyDcC14g4lCImJrILA2ARH/MJK55BJpX8SDrWIO2IY0MwZavplwRuVMVTSqzHg+dM9mK8Uq5EOEyhmWBNVOPzd6s34DY/t9YoX0G6alanKLhCSy2XuL/pfWK5NUGlDAkY7rdO8haCBAhq1+f6KKM5K4U5eNz1IIi8CGOVCAMMj/fDHXF3b5KLDOnCGxpsK47MYk6NiUbPLG4DdH72UxHbVJBsv0UkH4H7iEFdpKbwG/4yMRGzrwyXr0HwbZqhhT05mip0l31gaxvUln4FeFthQi15DPV+Ctonxuxe5s896DVQ1NZaxAlZSZwo7S5lJG4GFYJKGseYUiiMb4HjInyvl5v1Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 00:17, David Hildenbrand (Arm) wrote:
> dup_mm() copies the parent's mm_struct before dup_mmap() takes the
> mmap_lock. A concurrent brk() can leave the child with a stale mm->brk
> and newer heap mappings, causing later brk() requests to fail.
> 
> Other operations (e.g., PR_SET_MM) on the parent's mm_struct can similarly
> cause inconsistencies.
> 
> As a simple and robust fix, grab the parent's mmap_lock earlier. This
> way we don't need to update individual mm fields in dup_mmap() and
> keep missing ones. Stop updating the 4 existing members (total_vm, data_vm,
> exec_vm, stack_vm), as that is now no longer required.
> 
> Keep releasing the parent's mmap_lock in dup_mmap(), before
> userfaultfd completion, to avoid moving the userfaultfd handling into the
> caller. This should get cleaned up later.
> 
> Move uprobe_start_dup_mmap() to preserve the lock ordering.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  kernel/fork.c | 20 ++++++++++++++------
>  mm/mmap.c     |  8 +-------
>  mm/nommu.c    |  2 +-
>  3 files changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 22eaf5fb844d0..c8948cadccf71 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1532,12 +1532,19 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
>  	if (!mm)
>  		goto fail_nomem;
>  
> +	uprobe_start_dup_mmap();
> +	if (mmap_write_lock_killable(oldmm)) {
> +		free_mm(mm);
> +		goto fail_uprobe;
> +	}
> +
>  	memcpy(mm, oldmm, sizeof(*mm));
>  
> -	if (!mm_init(mm, tsk))
> -		goto fail_nomem;
> +	if (!mm_init(mm, tsk)) {
> +		mmap_write_unlock(oldmm);
> +		goto fail_uprobe;
> +	}
>  
> -	uprobe_start_dup_mmap();
>  	err = dup_mmap(mm, oldmm);
>  	if (err)
>  		goto free_pt;
> @@ -1556,9 +1563,10 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
>  	mm->binfmt = NULL;
>  	mm_init_owner(mm, NULL);
>  	mmput(mm);
> -	if (err)
> -		uprobe_end_dup_mmap();
> -
> +	if (!err)
> +		return NULL;
> +fail_uprobe:
> +	uprobe_end_dup_mmap();
>  fail_nomem:
>  	return NULL;
>  }
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 148ba01c03739..7618e72766a52 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1713,8 +1713,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  	LIST_HEAD(uf);
>  	VMA_ITERATOR(vmi, mm, 0);
>  
> -	if (mmap_write_lock_killable(oldmm))
> -		return -EINTR;
> +	mmap_assert_write_locked(oldmm);
>  	flush_cache_dup_mm(oldmm);
>  	uprobe_dup_mmap(oldmm, mm);
>  	/*
> @@ -1725,11 +1724,6 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  	/* No ordering required: file already has been exposed. */
>  	dup_mm_exe_file(mm, oldmm);
>  
> -	mm->total_vm = oldmm->total_vm;
> -	mm->data_vm = oldmm->data_vm;
> -	mm->exec_vm = oldmm->exec_vm;
> -	mm->stack_vm = oldmm->stack_vm;
> -
>  	/* Use __mt_dup() to efficiently build an identical maple tree. */
>  	retval = __mt_dup(&oldmm->mm_mt, &mm->mm_mt, GFP_KERNEL);
>  	if (unlikely(retval))
> diff --git a/mm/nommu.c b/mm/nommu.c
> index ed44510e37707..6e0f9c7da2364 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1926,7 +1926,7 @@ subsys_initcall(init_admin_reserve);
>  
>  int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  {
> -	mmap_write_lock(oldmm);
> +	mmap_assert_write_locked(oldmm);
>  	dup_mm_exe_file(mm, oldmm);
>  	mmap_write_unlock(oldmm);
>  	return 0;
> 


