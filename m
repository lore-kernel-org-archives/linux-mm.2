Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73DE0CFC267
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 11:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8526B0031; Fri, 21 Nov 2025 06:52:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAFD76B0088; Fri, 21 Nov 2025 06:52:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED296B009E; Fri, 21 Nov 2025 06:52:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE1B6B0031
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:52:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49A5F13B3C7
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:52:51 +0000 (UTC)
X-FDA: 84134452542.26.EDD5100
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id AAD5320002
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:52:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MJWq0rI0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763725969; a=rsa-sha256;
	cv=none;
	b=GkwYp4yuOVhwy2CoHtNWfvNwttl5+n54ynlP5sPVa5aSI/4xZJwfnphA7Di2DyQaWMPdGM
	UZilKQz+8iCLUikQ/kCpgoM7zMjShJkXkspQTq6ZywHOA2PLDoIIPjRrKliWlcxIw82+a2
	t4uymKC7i0rS00122GnoorZWpLJ9ArU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MJWq0rI0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763725969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e1yHjJv2J4jIHN3cL1Xk4Busjwx0PCm9jwATyAnaqkc=;
	b=OWj5elttkyQNyNCkeg9xqsKnmr381tH3gXycMGeUNMKqM5uuEIuEAYANmmwLZlDKJbodWU
	OQyy3EyK+S+YypVKt8N8UADm7xNvT2TKIX804h4w3FyMO9JNvtYpY68t5DVFNBon4xI9RP
	bFc2nyjne1pDnvXYUVduQtPeNC+KeC4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A3F060222;
	Fri, 21 Nov 2025 11:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14656C116C6;
	Fri, 21 Nov 2025 11:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763725968;
	bh=tLDp/5SKdP86hRJlKh1UsL4Iwokqsb7SJ7UfEJPXDKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MJWq0rI0IQnmD92gczmb0l8dlsvdJ9CWfbgS24/eqNYSbiEK6uVcO3F6a/sMWMiAO
	 4rYWBjkOX+HEzmZIwIK1Cyrzq+GtBuEmiXT5G3IZ4S/buX6xmzXFziRk7rA28d1BXw
	 qMHYa02ZrHgnO/9cPFPt6OdLDQQY8TGq66S0XVdH7G8GlQ2O4m8C1Te+7tqMAxgj9t
	 qI5/f4m6LXLWcvopoA8PFWHCUVx2eJV11WDLrjz3Tuwo0UieaNjEPr9Myv8Tz299i/
	 vlxOC+v45bFxKAGu9QX8nByI48z4/pxlT/kQ7mn6FlqDrVMfp1UkLiJcZVe3JQvf44
	 T+nJUudqlLLxg==
Date: Fri, 21 Nov 2025 13:52:39 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] userfaultfd, shmem: use a VMA callback to handle
 UFFDIO_CONTINUE
Message-ID: <aSBSh39-ih3rk0Ab@kernel.org>
References: <20251117114631.2029447-1-rppt@kernel.org>
 <20251117114631.2029447-3-rppt@kernel.org>
 <94fcc32f-574a-4934-b7a9-1ed8bd32a97f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94fcc32f-574a-4934-b7a9-1ed8bd32a97f@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AAD5320002
X-Stat-Signature: z8dxf5ze7zpfpqsdawhijgrbyps1osdf
X-HE-Tag: 1763725969-681833
X-HE-Meta: U2FsdGVkX18UtObzgtmm+28Kb7RMGO2F/TpvxklDVcf45DcHAa7s08f+xWpspA4xfmvXHJ1MkY39OwDBUqaA4DWHtFEBlq5vpdkeAnabinOX4UGcuAYbYIBcSW7jWq04mdghhOCM+BE3GYKvORY0tjPNsnMzfNFuuWuz+uLY6uc2s5XTidrbMRX38DmylfmTHCmT7C3TYxB2lZiOUR7KCSKwUr+0pCtIHiEqSlV5rIB3kaaIHShELw47GtYsI6H0wId892N5XeCv+rH1Q+kU28jrks+GgYycKoEpqyk8741LQPUdDGbCZ6ZF7RSBPgJFv9+y9y2kuCMY9Ea45iuJ6FudNcwAgdxw3ycHh8ONnDxcptCMANVePh+a3lD9L2fDmHfC82Wm5O+p/5dG2J5oHFVXJZpbLuJzWj9sBg1q+duCGMU+FuZBZpI9IIcfdKrxk5Q7uDebNEP6fAlR/u2EGhrPncoVzpepWoVBvtGwwkcyqS1qllrlImYZrKWpsew2LHB+WtJbSgVpinF3W+dBPUrZi2/3AXFtCn2eGreagQYpQwPA7WQgz4ZI9YR6QAwNgxftIB4eRg9/Ue5bTySpFhM2SsV1Yz4oHaHnyOhQrjfsOk9If/LGs4o5IWdXciMU+enoeuH47bEKTiLoc06IX2xW4ytxbrS2gmWELocOqHRQVRmmYsmwj6YqzTJMl9NtvWJQ0Q92LzVrBw+CkIT9fthY5PVIYcMO98kFdMNiPvOe2N/k2Tx9kHQUVkWbAKjbZcCjnWaLcvuR9LISLJF4sIcY7177GD/h8AOKdKAUtxv2zRfCDK/d1Ac1km2bjUl2PpjY+KsxeVB5waE+bzGuuuuvq5DzdT0z/EvCRGaqTuYA9Y6TE+jvryhkhvbOyXLgD6MaxTviPNaHKG6djcg+2tm7y3ghwcfA5IuS/sxycvOAR1Vv4Um6u+v7THbP7f2YsxnbeWdfT1GkPnmOSBI
 2e7EDLi8
 4K1MDtZN12pfLR1Z6wlhGQrU4jPp+Xn1Hj9CqdFtC3iXFnDNthhtMQCMRl2N7ts5HJVqLn2sbzsYXA/QGZDyiibQ2oCUx0x6mCSpYuHxcM41JakIVSV0ssTjdCPSkWZ/DKj0SDI1aABDZHGClf/r3r0bfZfXd9gCffiOM3knYkt9lH7gD4xb67ab3V4jPS2Yz7NLeJRkPXC3luaxaR1R4IrzWgTr61w2G7hPqQe1xdmZ/d6mJTcL2CoPp6anuP7j0iwGgcWLSAejrakZgOpN1JlGSVX+Aa4cphaJvQzr1Bm8bhZtGHIJfvWN9C+fZ7EBLUDjNuENvUrAX3risrvNByR6RbGX2r9WSnxaqvTI/tWxWINo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 06:08:57PM +0100, David Hildenbrand (Red Hat) wrote:
> On 17.11.25 12:46, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
> > it needs to get a folio that already exists in the pagecache backing
> > that VMA.
> > 
> > Instead of using shmem_get_folio() for that, add a get_pagecache_folio()
> > method to 'struct vm_operations_struct' that will return a folio if it
> > exists in the VMA's pagecache at given pgoff.
> > 
> > Implement get_pagecache_folio() method for shmem and slightly refactor
> > userfaultfd's mfill_atomic() and mfill_atomic_pte_continue() to support
> > this new API.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   include/linux/mm.h |  9 +++++++
> >   mm/shmem.c         | 20 ++++++++++++++++
> >   mm/userfaultfd.c   | 60 ++++++++++++++++++++++++++++++----------------
> >   3 files changed, 69 insertions(+), 20 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index d16b33bacc32..c35c1e1ac4dd 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -690,6 +690,15 @@ struct vm_operations_struct {
> >   	struct page *(*find_normal_page)(struct vm_area_struct *vma,
> >   					 unsigned long addr);
> >   #endif /* CONFIG_FIND_NORMAL_PAGE */
> > +#ifdef CONFIG_USERFAULTFD
> > +	/*
> > +	 * Called by userfault to resolve UFFDIO_CONTINUE request.
> > +	 * Should return the folio found at pgoff in the VMA's pagecache if it
> > +	 * exists or ERR_PTR otherwise.
> > +	 */
> 
> What are the locking +refcount rules? Without looking at the code, I would
> assume we return with a folio reference held and the folio locked?

Right, will add it to the comment
 
> > +	struct folio *(*get_pagecache_folio)(struct vm_area_struct *vma,
> > +					     pgoff_t pgoff);
> 
> 
> The combination of VMA + pgoff looks weird at first. Would vma + addr or
> vma+vma_offset into vma be better?

Copied from map_pages() :)
 
> But it also makes me wonder if the callback would ever even require the VMA,
> or actually only vma->vm_file?

It's actually inode, I'm going to pass that instead of vma.
 
> Thinking out loud, I wonder if one could just call that "get_folio" or
> "get_shared_folio" (IOW, never an anon folio in a MAP_PRIVATE mapping).

Naming is hard :)

get_shared_folio() sounds good to me so unless there other suggestions I'll
stick with it.
 
> > +#endif
> >   };
> >   #ifdef CONFIG_NUMA_BALANCING

...

> > +static __always_inline bool vma_can_mfill_atomic(struct vm_area_struct *vma,
> > +						 uffd_flags_t flags)
> > +{
> > +	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE)) {
> > +		if (vma->vm_ops && vma->vm_ops->get_pagecache_folio)
> > +			return true;
> > +		else
> > +			return false;
> 
> Probably easier to read is
> 
> 	return vma->vm_ops && vma->vm_ops->get_pagecache_folio;
> 
> > +	}
> > +
> > +	if (vma_is_anonymous(vma) || vma_is_shmem(vma))
> > +		return true;
> > +
> > +	return false;
> 
> 
> Could also be simplified to:
> 
> return vma_is_anonymous(vma) || vma_is_shmem(vma);

Agree with for both of them. 
 
> -- 
> Cheers
> 
> David

-- 
Sincerely yours,
Mike.

