Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D33606A334
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fxlM84s3
Received: by kanga.kvack.org (Postfix)
	id B6BD66B05B0; Fri,  6 Nov 2026 02:43:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1C686B05B1; Fri,  6 Nov 2026 02:43:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0AF16B05B2; Fri,  6 Nov 2026 02:43:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 798DE6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:43:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2121D1C4773
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:43:00 +0000 (UTC)
X-FDA: 85403902920.04.0A5932E
Received: from mta0.migadu.com (out-163.mta0.migadu.com [91.218.175.163])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1EB8B180002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:42:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fxlM84s3;
	spf=pass (imf24.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.163 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793950978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6SE0s1+Cmv2tEQyGLs4E7WejNQSVW6EagB3ds9ygbQ=;
	b=YIkjudjrh3eS9NCU/04FqqHxcoWz2QdcH5rcsKd4CImfxeexYr6/O7Yu1Aeth1uuIOQ6u8
	rqaZfbMBWSme5OuDShKShKRcEJxmYZPri9BNpuMRx0cW2TBET1i7nbnkGl3W6T5/gfBom/
	zwi+mJfYlbKyD6WcRNaldpg7IDLRjbs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fxlM84s3;
	spf=pass (imf24.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.163 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793950978;
	b=yu13snKWmoIi9vcg9l164TpqzBFHv7loqOCWH6ZS4GZKLebXR8HhGpc5xxfgfRKy03i6yD
	YY/ru9S1Y913Dl96cQvn1/8/U+W3vv5D50jrkZeMhwbFR4513B5l3B1/bcUTFedm2ZrQlu
	ho4sn/82Jmft7KaQzu2zmGW20ZRAU38=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PtWTq6nqlzK8T9nMNNfK0YJy8biQ9MHHy5p7qGOpMUs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793950976; v=1; x=1794555776;
 b=fxlM84s3hCVbROs1wu/ZRrH3w7L69J3djc8r82NKL7XgHLF5bsQqxKfWQvDSAP9wYLmdAde1
 mu24woVL/EN8rZQZureXL4U5hLrUQUpSNqcu/ZfylUSqhhED8b7JJPf3XOGbxNYP4nyzo0wgtdF
 e3L8oaGdTF4l+D2Ofihjjuv4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 9c50986a3e384fa4;
	Fri, 06 Nov 2026 07:42:54 +0000
X-Mizu-Trace-ID: 9c50986a3e384fa4
X-Migadu-Flow: FLOW_OUT
Date: Fri, 6 Nov 2026 15:42:19 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Pedro Falcato <pfalcato@suse.de>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>,
	SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
	David Rientjes <rientjes@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	John Johansen <john.johansen@canonical.com>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, damon@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 06/13] mm/ksm: convert VMA flag tests to use vma_flags_t
Message-ID: <au2E2/Q3yQacg5pk@dgvxl46587.localhost.localdomain>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-6-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-late-2026-vma-flags-v1-6-0d3cd15ab75f@kernel.org>
X-Stat-Signature: r4iyow8gwzqa3ta59j1mwxhkjbttdqmd
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1EB8B180002
X-HE-Tag: 1793950977-279157
X-HE-Meta: U2FsdGVkX19lOwiAhAKsJnK+ZLtaCCvi/eYhwrhMST8XXz16Pf4U3WWZSWa5bT9EwD+qs0zlQmmImko2Br7cev201huDaZgK500VEdumJPg075BmdcSFhMtd/AJykFXgc3k20jDY1KkoBOInaAg7oBIruvfPRCyZ73xVk5qkUYs4QH+w7BiLRwYpSVe48RgKV+r+44LNwXaPzpbW80xWgq3D/9wNHrsUV4NZH/jGtwEae8vO4d9Msnq+n7Ia63RxLqMaDChfR73UfDAg/BQ2fCq9dEXmlxcZeQYKy2zsywmvwLXhJT1iIR5X95pgW3LtFcUQV/33e6bUyT7rK4FcYJ2nIxU+GN0aW3wqg57cXhmIhsXDAJq9WvIXvVVN7Iwj5129yC1Rbg/EsY8BRzm5QbFdeyAg2Ky8maziF0xDbI5Le/2x9p2rkq6JwVsJpflioukLWlAohuVDeG/kLcxGe4e0ongd6BaAXKjbIYYAc4wPnI15wqpuVxcB+t1gJRkVE3Wy4v74BPB1r1NscFFKmaXJqYn0j4DzS5xnE1c6ClG1s6cvgmoq3rQD+mLUJypTHFdAMIpwYJlsrJAezeFUme5dgDN4M6fvfWRBpqspd9DZbVQvnjAFFRGL4y7C7Vg9qpBkpKH83KQpHyFodANXyU6B73nK9g7sbR4JpNJVA7ZL1fydY/GV7COYOmzkKixAalbjUSeJipELxtBC7NywwqmxuWtWNUazAVggNo9AsmzUDhJjU71gPwXaTG3Pwqs9wRR26pcs71i/V7v3XsUqgX4/2om4EwNOEjBALnSgMpyEU3AWspstIbTai3f7cCe8O0f9lVDS+0mMEmnMuax2mTHtJNnKadf8w0Qwo51YAIpek4Wu1OdY6H/pxjVaRg8qFoVnrWNZxZCr/RPT9D8nXqzpKdbORDFXzkmF55oIODgGPSQ425YH4egM6OAuj7XSHjQVXE6eG2yFl7kxj/N
 +s4AAOm5
 Rr+JfIX7rNBrYJnEU5ioJgPZ1hZTFqgikSbko8yzIOMFCBx3Tuv/fqnZEtoov0W+eUgQWqHUO//uv+bBVvX6vhoNWZxr4iFHVqUpg+Zzy5CMxFaX+a2hJmc2XBybKt8P5GSt8uH+Azwfj32sa7KRzSQq4mSRIib4o9I5Y0pO4bGL1hgZORNN9Hr1YnLhzLRVD8BDNikkVJRymfWxEs57psE8JFtV16SU4Gykj/C4J6Uw472IJX94pFtTOli5he12Kc35IC03xBV7p4FYyT1d9BlcRlyGNMGKMMtQtH27z0LbPduB6X0owIpLZjdzS/Btm6la7Ef5DCRTLluVqHWeZ20sw6OODxboA4Xl70Vf0fjJzc4GilM0BOtfwGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:30:57PM +0000, Lorenzo Stoakes (ARM) wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values where
> KSM tests VMA flags directly.
> 
> The ksm_madvise() interface continues to take legacy flags for the time
> being.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/ksm.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

LGTM! Thanks!

Reviewed-by: Xu Xin (vivo) <xu.xin@linux.dev>

> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index d6f736a1aa2f..61b772bba229 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -779,7 +779,7 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
>  	if (ksm_test_exit(mm))
>  		return NULL;
>  	vma = vma_lookup(mm, addr);
> -	if (!vma || !(vma->vm_flags & VM_MERGEABLE) || !vma_has_anon_rmap(vma))
> +	if (!vma || !vma_test(vma, VMA_MERGEABLE_BIT) || !vma_has_anon_rmap(vma))
>  		return NULL;
>  	return vma;
>  }
> @@ -1243,7 +1243,8 @@ static int unmerge_and_remove_all_rmap_items(void)
>  			goto mm_exiting;
>  
>  		for_each_vma(vmi, vma) {
> -			if (!(vma->vm_flags & VM_MERGEABLE) || !vma_has_anon_rmap(vma))
> +			if (!vma_test(vma, VMA_MERGEABLE_BIT) ||
> +			    !vma_has_anon_rmap(vma))
>  				continue;
>  			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
>  			if (err)
> @@ -2698,7 +2699,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>  		goto no_vmas;
>  
>  	for_each_vma(vmi, vma) {
> -		if (!(vma->vm_flags & VM_MERGEABLE))
> +		if (!vma_test(vma, VMA_MERGEABLE_BIT))
>  			continue;
>  		if (ksm_scan.address < vma->vm_start)
>  			ksm_scan.address = vma->vm_start;
> @@ -2890,7 +2891,7 @@ static int __ksm_del_vma(struct vm_area_struct *vma)
>  {
>  	int err;
>  
> -	if (!(vma->vm_flags & VM_MERGEABLE))
> +	if (!vma_test(vma, VMA_MERGEABLE_BIT))
>  		return 0;
>  
>  	if (vma_has_anon_rmap(vma)) {
> @@ -3027,7 +3028,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
>  
>  	switch (advice) {
>  	case MADV_MERGEABLE:
> -		if (vma->vm_flags & VM_MERGEABLE)
> +		if (vma_test(vma, VMA_MERGEABLE_BIT))
>  			return 0;
>  		if (!vma_ksm_compatible(vma))
>  			return 0;
> @@ -3484,7 +3485,7 @@ bool ksm_process_mergeable(struct mm_struct *mm)
>  	mmap_assert_locked(mm);
>  	VMA_ITERATOR(vmi, mm, 0);
>  	for_each_vma(vmi, vma)
> -		if (vma->vm_flags & VM_MERGEABLE)
> +		if (vma_test(vma, VMA_MERGEABLE_BIT))
>  			return true;
>  
>  	return false;
> 
> -- 
> 2.56.0
> 

