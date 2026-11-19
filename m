Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697E5606A333
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 18:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SXMU8n0n
Received: by kanga.kvack.org (Postfix)
	id 81A3B6B0634; Thu, 19 Nov 2026 13:23:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB226B06BB; Thu, 19 Nov 2026 13:23:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9356B0681; Thu, 19 Nov 2026 13:23:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 479C86B06C3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:23:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C71CF1604A6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:23:14 +0000 (UTC)
X-FDA: 85452690708.01.7E611CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3DE0D40009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:22:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80B5360D43;
	Thu, 19 Nov 2026 18:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA991F000C5;
	Thu, 19 Nov 2026 18:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795112574;
	bh=ZfsfFEJM82krByuOVGPOZZKv9Osma7QbzsdrPPTac/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SXMU8n0n7HXvIZMBaIH/Sj2ALikU/NZyraGWrOKCkESGWY7SJKRbHud/A4KvFVB4Q
	 SbIrRDc/P6vWCjfXMaopS3UWETKT4B6yGuhi+pwrAK8SNQHvCfylkkG1NBFmw6gvIu
	 H3bN2qXd0b/JXtif/5WkqT0iz3DHkOvjB2r7E99qPBiDguG886zzvpVAVt5VbyxTVj
	 mvOAFdaP+g0/FxNTAcjBBPTeOdxC2LqscC2wf1QFaL1OyJoBzvlXAfw305Xvet0ALF
	 Z4+TZF+DOH1qNJmzg77iUGY0b74R0BV3AqdQ7EEpvR+VrwctmUyYm024rgLCT4LAsn
	 V5LIXAAUjSKNw==
Date: Thu, 19 Nov 2026 18:22:49 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Avi Weiss <thnkslprpt@gmail.com>
Cc: david@kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	liam@infradead.org, mhocko@suse.com, surenb@google.com, vbabka@kernel.org
Subject: Re: [PATCH] mm: skip temporary folio allocation for anonymous UFFD
 missing faults
Message-ID: <av88TW3GQRvXJDwA@gremlin>
References: <20261119180015.933433-1-thnkslprpt@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119180015.933433-1-thnkslprpt@gmail.com>
X-Rspamd-Queue-Id: 3DE0D40009
X-Stat-Signature: wcm6x3cah1zfy5a4ndrnn6j68wuyfahk
X-Rspam-User: nil
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-HE-Tag: 1795112575-545862
X-HE-Meta: U2FsdGVkX195x85qoelobhUr2Px7DU2OxmMkFP5qiaCbKLUsWV13G4snzwLQPOrCmodjqh9Drgi5L71Q0oQhr6ZrMQGsclCOUdcjs+0ow1fQC8VDIJdkY6kEjFXkha+aSnxMdOg7einbu5aOT1N6NqRNIlj8uReFJjkxiZjz9OVhx/pGfTE6xKW00zey3+xvrRi/w+HWBH7F/9vAwurJq5Lybvt3nzUx2ClI1wskT/yXTB3Crfr2o4dEKGbPWLWiZzvh0oES0wbqd1ZMHRPm3JMuo3QHL6AL7wHws0v3oppfbVhLqoxw8p+Lnnb5U3gwIX95n2JW6sVE31xg79YzN5BfxZI+jXgb40R9FV5ao5d6COuHu2B97BUgFyegxZagurmY469ibqBBmd4TPoWBpksbVe8BL4Co2MGyD5bfEKavgTCOdf+70jmhay2rBgMvbWEBZebx/JhjAMBWJwMy2CoSIk7tOY+8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+cc missing.

Please just stop. You sent 7 series across 6 different subsystems over 11
hours. You(r AI) even failed to cc the right people (added).

On Thu, Nov 19, 2026 at 08:00:15PM +0200, Avi Weiss wrote:
> An anonymous write fault on a VMA registered for missing userfaultfd
> faults currently allocates, zeroes and memcg-charges a folio before
> checking the PTE and handing the fault to userspace. The folio is then
> immediately discarded without ever being mapped.
>
> Check the PTE and address-space stability under the PTE lock before
> allocating a folio when missing faults are registered. Deliver the fault
> to userfaultfd without allocating and discarding a temporary folio.
>
> In a four-boot native B/P/B/P comparison, the mean UFFD fault median
> fell from 13,997.75 ns to 13,093.55 ns (-904.2 ns, -6.46%). A guest
> allocation trace saw 256 fewer allocations in the faulting task for
> 256 registered missing faults.

A .9us delta on a _uffd_ fault (nobody in their right mind puts it on a hot
path) with no standard deviation? Seriously?

>
> Note: this changes OOM ordering. In a fixed 18 MiB memcg test, the
> baseline OOM-killed only the faulting client before delivering a UFFD
> event. With this change, the event reached an unprotected shared handler,
> and its UFFDIO_COPY allocation could trigger an additional OOM kill of the
> handler. A separate surviving client consequently lost its handler and
> failed a page-content check after the UFFD registration was released.
> The same handler-death mechanism was reproducible on the unmodified
> (mainline) kernel when memory pressure was imposed after event delivery
> but before UFFDIO_COPY, although the fixed-limit outcomes differed.

This is both unreadable word salad and alludes to you causing possibly
breaking changes for a barely-distinguishable-from-noise fault time
improvement.

>
> Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>

Please stop submitting patches, thanks.

"You are expected to understand and to be able to defend everything you
submit. If you are unable to do so, then do not submit the resulting
changes."

https://docs.kernel.org/process/generated-content.html

> ---
>  mm/memory.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 0fb676d..63b39fa 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5547,6 +5547,22 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  	ret = vmf_anon_prepare(vmf);
>  	if (ret)
>  		return ret;
> +
> +	if (unlikely(userfaultfd_missing(vma))) {
> +		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
> +				vmf->address, &vmf->ptl);
> +		if (!vmf->pte)
> +			goto unlock;
> +		if (vmf_pte_changed(vmf)) {
> +			update_mmu_tlb(vma, vmf->address, vmf->pte);
> +			goto unlock;
> +		}
> +		ret = check_stable_address_space(vma->vm_mm);
> +		if (ret)
> +			goto unlock;
> +		pte_unmap_unlock(vmf->pte, vmf->ptl);
> +		return handle_userfault(vmf, VM_UFFD_MISSING);
> +	}
>  	/* Returns NULL on OOM or ERR_PTR(-EAGAIN) if we must retry the fault */
>  	folio = alloc_anon_folio(vmf);
>  	if (IS_ERR(folio))
> @@ -5579,12 +5595,6 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  	if (ret)
>  		goto release;
>
> -	/* Deliver the page fault to userland, check inside PT lock */
> -	if (userfaultfd_missing(vma)) {
> -		pte_unmap_unlock(vmf->pte, vmf->ptl);
> -		folio_put(folio);
> -		return handle_userfault(vmf, VM_UFFD_MISSING);
> -	}
>  	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr,
>  			      vmf_orig_pte_uffd_wp(vmf));
>  unlock:
> --
> 2.43.0
>

--
Cheers, Lorenzo

