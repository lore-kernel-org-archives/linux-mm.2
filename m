Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29BFD606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NSyrEmFs
Received: by kanga.kvack.org (Postfix)
	id 2B8A76B061D; Tue, 27 Oct 2026 04:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2907F6B061F; Tue, 27 Oct 2026 04:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A5CD6B0620; Tue, 27 Oct 2026 04:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D9F826B061D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:31:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BA1BA0958
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:31:59 +0000 (UTC)
X-FDA: 85367738358.16.51C3AEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D85C340003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:31:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NSyrEmFs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793089917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYDAxb/IKfi0ONAEetWSuyzn9W1ajE3cX6VVYTxdndk=;
	b=5+d+8L4LiO/XPAe/tnBAmYm1gLGto6w9i8W63E8mIEFdh5VlpSP3V3l+QpqKgi3A6jtlbW
	P6nqDw+oGoPAQcQAZT4+/eU+nmOKocrQ8vMQAIYa2R+tp7GZYim4m9Cmvs4aquxQq5XCqr
	YXBvNbD0sGTiPu7cYb0awZH4558VgwY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NSyrEmFs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793089917;
	b=0rmVkx0wfqBz+gaBioqgtSG9t2vMHYBXxInqQQjWxi+dnFFvq0YUZWhA6yFL0deDxa9Jh2
	OMymrvBx2sqiKJ5rlGUeyNHZceqPInuSgyR9liAWQul0cmIpoZO4954hFJkKON1S0gzXwR
	7rwLiuoCKQ5D0eU1CTtRcPZ5yGQPyT8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4547B601FB;
	Tue, 27 Oct 2026 08:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FE51F01825;
	Tue, 27 Oct 2026 08:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793089917;
	bh=JYDAxb/IKfi0ONAEetWSuyzn9W1ajE3cX6VVYTxdndk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NSyrEmFsH2/8hgo8acOSrNLr9Hp/jrECdxCZNkIUtjazyxj1KHY2Z9xTuaK1Lx/+E
	 ZlmTVVItxriaq2TTVszlyqWoslkxBKunusBgrpEBtjqe+GL7/BhgMfvr0j6wiA++no
	 F2KtES+mT9pC9lUi/ceR10V31SP1W8sTkLdb8RXB5buLAYoTKBuslgPDKXcQC7fYaC
	 tmT15Bau5bPVbn3Z1pAmnKqeU5kgzDR3je5XpPQh+1wLiPoL+vicuxqnXgb7RRv82r
	 DFUEPhtPAu/EsK33zZwLXIqaPQ96HHeqGtj52+tHWqHJBcswjRzCsbgunsrigQ97JU
	 n0Iy4vbd890bA==
Date: Tue, 27 Oct 2026 08:31:40 +0000
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
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 25/46] mm/userfaultfd: wake waiters when registration
 modes are removed
Message-ID: <auBgr8OO0UIJ5-in@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-25-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-25-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: D85C340003
X-Stat-Signature: p9yzzpbgrgxbse666nw536h6r7zuu4by
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793089917-127708
X-HE-Meta: U2FsdGVkX19eiTFiFB8/Nt7RQWCv+h32CVAQrhiUe1LeUIEZ/kzJbS2w7/028ipUM3KvmWDPgMfrvXoX9lYytVz/8oR9+uEjI7RMIbUGVCW0TTeNWHeruy+7R1F1UQsjH6KLZTlkRErQP7zpxQthvF4FbW046w6QxMb1LrYbLfBpvFXIwz1USbZ7Zwy1wJd6SzKuklHC81CrrXMeWMFVmEQizXcv563/Zptyq0pPtHfjkaywECTSlUk4PUKGejkia17W6GwmOAafSDMOXHDrZOjllVg4EyQcbjcUlyB9UJSIRGXhLRj4d3l9t/cZ/2MqXq13VN1Co4cpBBRxctBDfjYc4qtiq50tZpK7jYySKZrTBGlss+AM4dh+ItoQpophJfBY/iUfiSR7Yt5ylkH7DworwivGVx1eEzQWw41XBTqaxtOJdEo0EuO0SWSNZIU3dZTxH9q5kMhaMew2Rd3jhzZRj7A710TJZJpjaAz6bbukbrM8wnssoyYiaqOHucttcLlHx6/4sX6bD8zaIUpjYFSTNoQ/uMoWTm4vsjaPInQQMonIO2AnSSPFaA6zJsKmAafjRL2YLrcH693G8VfZal4AMbX1aoEPMKEOp+yS2nBPOxL4hFPt8mLbesx3Z1GKJzuz0cQKp7ImorbbOkVoFGFw5ldPFrI7W875fsvSxpo5Um3mJGdt8djxzqi0QBcu1ZXADgFyVy2CzgroMo87ob40kLygwc6dmyI4DxgbIQt3Wf7FYmwf/LpXkD2b3/MHaZ7tSjuJrwfwkSBjFGP6/ULG8t+d3RY6idaol+pPV+mpGquaRnQYE4CsxMKn9wckyOj5wJP2WMGkBwVdXW0w49uQ+bMdM6A8UIXm93SP7NIJzfvBiJvzd7a59RZLcxhyMTfXb3WDiwKBG/IUWNOn67xezCdevF+frDEYTmAiJWAIRAld0EUbzcVF7rcLsZ6xruzF9WnMzsIf3t2APkN
 F7X8YkaS
 zs2J0lZwCgGS/HmytpVp30A/6ERea4GRaukykult+qNET7CDq5mSFiHcZvpcsEF9uxL1KiF2V+d3JqdTxK/3EkKK+R+tdaxSudKRNSFhkTocDBKiP43r+wZussBOd1l9MGXREKAbkctC4b1zfb29kWdPxycrgP5ItEC0980dzaKbAsOfzRXI00on/lanaJoYzet+n1zE+Ce89eaGOAop9CFLfZJG8efJXc99A68vVeAt01Xv7X2hMLwbQa0EOgCmUG53bEbRupiUWW2NhkXoYHR2E7YK/8Ih2lffpt5jFFrD4Hx8Qp3dBa05eGLK7hDNBIg7jgUyLO4CKlpdJId7D5gTb3EPSMOQpAOEd4drIxNmnCh9rw+GaqzoZDoQfDgvC3bWhsllgOF4P/1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:45AM +0100, David Hildenbrand (Arm) wrote:
> UFFDIO_REGISTER can replace MISSING or MINOR tracking without waking
> faults that are already queued. For example, switching an anonymous
> range from MISSING to WP leaves a missing-fault waiter asleep until
> userspace explicitly wakes it.

I assume this is something people basically never do because you'd think it'd be
a pretty obvious bug report right?

>
> When a registration change removes a UFFD mode, wake waiters in the
> affected interval after updating the VMA. The VMA is write-locked at
> this point, so no new faults can queue under the old modes and woken
> threads cannot retry until mmap_write_unlock(). Waiters for retained
> modes in the same interval may also wake and refault.

Oh good lord.

>
> The hang reproduces for MISSING-to-WP and MINOR-to-MISSING transitions,
> with both read and unread fault events.
>
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

In the words of Metallica, the more I see, the less, the less I believe...

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/userfaultfd.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 2122676c4220f..710e913c73bfa 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2270,6 +2270,9 @@ static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
>  	return ret;
>  }
>
> +static void wake_userfault_range(struct userfaultfd_ctx *ctx,
> +		unsigned long start, unsigned long end);
> +
>  /* Assumes mmap write lock taken, and mm_struct pinned. */
>  static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  			       struct vm_area_struct *vma,
> @@ -2287,6 +2290,8 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  		prev = vma;
>
>  	for_each_vma_range(vmi, vma, end) {
> +		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
> +
>  		cond_resched();
>
>  		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vm_flags, wp_async));
> @@ -2332,6 +2337,10 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  		 */
>  		userfaultfd_set_ctx(vma, ctx, vm_flags);
>
> +		/* Retry faults for removed modes while the VMA is write-locked. */
> +		if (any_mode_removed)
> +			wake_userfault_range(ctx, start, vma_end);
> +
>  		if (vma_is_hugetlb(vma) && uffd_disable_huge_pmd_share(vma))
>  			hugetlb_unshare_all_pmds(vma);
>
> @@ -3648,6 +3657,17 @@ static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
>  		__wake_userfault(ctx, range);
>  }
>
> +static void wake_userfault_range(struct userfaultfd_ctx *ctx,
> +		unsigned long start, unsigned long end)
> +{
> +	struct userfaultfd_wake_range range = {
> +		.start = start,
> +		.len = end - start,
> +	};
> +
> +	wake_userfault(ctx, &range);
> +}
> +
>  static __always_inline int validate_unaligned_range(
>  	struct mm_struct *mm, __u64 start, __u64 len)
>  {
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

