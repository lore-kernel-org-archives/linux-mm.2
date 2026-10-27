Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E0C606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YgWQ0jUy
Received: by kanga.kvack.org (Postfix)
	id 13AD56B0618; Tue, 27 Oct 2026 04:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112BE6B0623; Tue, 27 Oct 2026 04:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FEA6B0625; Tue, 27 Oct 2026 04:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D11316B0618
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:36:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 595D41A02FA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:36:55 +0000 (UTC)
X-FDA: 85367750790.24.1B9977B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C71641C0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:36:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YgWQ0jUy;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793090213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYgcjxrZzXoy0psYU0Nq+QxW34HHCYEZSvr+g4Xkf3Q=;
	b=ehaTrv85rcs2fM1QWYeJcu+5BcT4Zi7Gp0RLlFLg063immEaCZkgliZXWcr2mdHH5Or14B
	ssHZQB/4Bcs2Zpt2QAxplGqHqP5vJmno9GJGmIKZBqzQE0HWE4u7lUSONWQH8575hg3SuJ
	pA+XiBYD9emOdGW4jWgrS6j3T5xlJzw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YgWQ0jUy;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793090213;
	b=Th9UHLECpTcE/oAt1xE0NFXmpBnG3HQSaFwiOsfnJs6NB5mqhJq0NBK5pi7hqpiCFCv/NI
	fX77QjHfOHHUr4lR+xerUQB6c3UXhyXrJEGZDbCtJyKIRmasa4Kae2Kk8g6YOhdWCIayJP
	/tBs+W2mK+QmuPwyBeXSw06x+RXhTAE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B6C6601F9;
	Tue, 27 Oct 2026 08:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0202A1F01825;
	Tue, 27 Oct 2026 08:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793090213;
	bh=yYgcjxrZzXoy0psYU0Nq+QxW34HHCYEZSvr+g4Xkf3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YgWQ0jUy2R3Rh6tVUq1cYOMph9r06iXsVVDLcV7MttnPuaU1a16q5fg+QaCk7f+Fx
	 FzVMQCYd/p+MkpgpnFyBzCzl+fi3rnW0pIlK1fRrVDOkrsTCamrF3lIKcsPE77OK+Q
	 GIcJKTG5KNfSBGz+lX+edsIgMQTXvFzfUt5kzxtbIx9RH8l3e/D3N5JbaEWymZs/AM
	 k9m2KnjFXcgH69AYMz8pQx4Dw81BFFnZ5uku8faOD0mwALYfuFExgFXDKgj/Ka6VQy
	 tuZal11vRiWnP6mU0vu9Ih1K1GdOoDAAEAdwlWfYaybPxhriIQnfLoHF5xpZXNFlOf
	 U/cWZtqdU5sAQ==
Date: Tue, 27 Oct 2026 08:36:36 +0000
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
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 24/46] mm/userfaultfd: wake all waiters on unregister
Message-ID: <auBiimQ9PuT9wXIB@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-24-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-24-6f74bec9a5bb@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C71641C0005
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: 5z54ywzhrz9r8q183qapx7wsmr19zxpu
X-HE-Tag: 1793090213-530189
X-HE-Meta: U2FsdGVkX18aA3uIMMUQyr2hqtyB2aS4yXvXrXGpeoVOsPKiNt+ngdSV/riByjR1Ve9I8p4UbaP3apRi54iLLPnFI1vSxK3CdI3WfC+SRTwCPzGYRnanhdi38aHqg1Jul7Gbq4b+C85kxRWCXm3LecnrWM/wohbibU31+CKqVKd9M2S81J6c0ovHkVKdkxu/32EByLfQQh/4Qb9kSaRo6BRaBeH0ZbWKMHvOFkj0VvEQVJcXJ2uOMQRMVki9ocsMjA3o0ynVbUyhIN1zAOEkQt+mJF82m4S65ltS7ZMo0BUAf7W4ZwrDjubD3u1GTTAdYFanlMUYW6/JqooWNk1DGsw7iG28JpRlAkIs+UqMxrGCUg3epkYsbtRdeKdUNEE3vskRmwuep9geXTnHUODqwEVjH0aK2BRzW7eGXt4RRMzuuUL5knKWE9jY9zvNjup2A52Fplpy+vc6hayjaRkBXPhxDp9aXzyjsrIOzGrzHgQG7E8Hm7F+Axnakkn9e4WXrLte1+rZcPsx9+v0T7T+bLS0rwQspz7j5qUssgwjMwEBhEIPKVM5vTfGkSMB8lDzkopb3w4PSdWteMhExuZWiK+1pHcRjZY8s+GmXb9aGRbslmcA/YWM05lylXKGDRzV19t8fqoBodT+jY/1qR5mALLpBUFxMN+VtL/XFFgCJrerN3I6d7bOHlPhuYBnrfTtVhNbA5tG7zQSO+cUHLSrFc5ZBjv7pa3d6/+/GjsbWbcYGE2ahCKe6mfFfijwvy+f7yIzHSwXM5g1QLOc8CHTil4GG2kZvSKeeZodGhZCGYTImWQnp7vdxc+/kXXiq/3FmX5jKS9Jed+dmQH9hf6mq8Cwtbxn63ITIxNmoyfjlo2raYc8Bpl9VAOSWENPqkp/Wc4oMCLXQ6JtVcGNtRe6J6u++agmCe7NBde2gLfiCLafOemOhOGFUDlSFqH3iwMayxcbYsDUESUUPRitEET
 T3r7OKGy
 MGogZ1nuBZyRv7htzjW/hz9uSZNJfuNxyZxa1WPvwM1zNePbVjJtP/Jdr75L7YxAY+8DoxoynhtrxTotvHnWvdZgPSFvk4GAi8UiMPvaWkZGfVriZg/vVMRUMM6Of9gozkA12MbLRIilzBGYvjVEYHHqC9c7aqc5YFR4mHugXVS7yqvTc56SA+dx7too7F1uZUudVMB3ySc9jDh3a9RRToHCvZudfDyc3N1MDS53sJ/Ye+sWHzatKqQ+Q8YJaUU2Gx5Hs0UbPWruLLVzwAGLLgEZ/Fc9Mx/lG5ZMWde2EtejWfMPvMKI6Oq55OEl2gM/hWiH8uwtENtsjO+jl6dn9PjdjcBcdiaxOG5jLpxOKmN7ylCdZbW5nCsIkWf94w74l/uxtJ7hY1F6mmMS/r9CiNqzuGbuf9hFUf2Fv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:44AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
>
> UFFDIO_UNREGISTER only wakes pending faults if VM_UFFD_MISSING is set.
> Threads waiting on write-protect, minor or RWP faults can therefore remain
> asleep after unregistering a range that does not track missing faults.
>
> Wake pending faults regardless of the registration mode so they can retry
> without an explicit UFFDIO_WAKE or closing the userfaultfd. This matches
> the existing behavior for missing faults, including removing unread fault
> messages for the woken waiters.
>
> Fix generated by an LLM and sent by Josef Bacik in private.
>
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: rebase; simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/userfaultfd.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 7e30b5ff17be1..2122676c4220f 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -3977,6 +3977,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>
>  	ret = 0;
>  	for_each_vma_range(vmi, vma, end) {
> +		struct userfaultfd_wake_range range;
> +
>  		cond_resched();
>
>  		/* VMA not registered with userfaultfd. */
> @@ -3994,18 +3996,14 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  		/* Prevent new userfaults from being queued after the wakeup. */
>  		vma_start_write(vma);
>
> -		if (userfaultfd_missing(vma)) {
> -			/*
> -			 * Wake any concurrent pending userfault while
> -			 * we unregister, so they will not hang
> -			 * permanently and it avoids userland to call
> -			 * UFFDIO_WAKE explicitly.
> -			 */
> -			struct userfaultfd_wake_range range;
> -			range.start = start;
> -			range.len = vma_end - start;
> -			wake_userfault(vma->vm_userfaultfd_ctx.ctx, &range);
> -		}
> +		/*
> +		 * Wake any concurrent pending userfault while we unregister,
> +		 * so they will not hang permanently and it avoids userland to
> +		 * call UFFDIO_WAKE explicitly.
> +		 */
> +		range.start = start;
> +		range.len = vma_end - start;
> +		wake_userfault(ctx, &range);
>
>  		vma = userfaultfd_clear_vma(&vmi, prev, vma,
>  					    start, vma_end);
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

