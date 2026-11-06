Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C93606A332
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCunnEIZ
Received: by kanga.kvack.org (Postfix)
	id 10C6B6B05B0; Fri,  6 Nov 2026 05:46:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF9B6B05B6; Fri,  6 Nov 2026 05:46:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC5E6B05BB; Fri,  6 Nov 2026 05:46:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDCDC6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:46:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39CFFC0D22
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:46:52 +0000 (UTC)
X-FDA: 85404366264.19.E6C14E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7BC98100005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:46:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hCunnEIZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793962010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4UXJ8D6lFItiQJcibx9Gvr2Xk0BfzjmL2Cx9RaqZ2M=;
	b=ohH/x9OHIFRTWMg5wL4OuBNXOH7GJnOwbv1y6No8qYOi6U6rSulr5+IrErbe9IZcRX6m6G
	iwkitrAZB5QUXcb5tfDPOPlL9X+Nhor7bfeahmCgHd1ix3hnXrShsnvgdvIufMmt3XJH/3
	FV3/jmsS9O6ZUHTkRycCqtNKJQED7mE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hCunnEIZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793962010;
	b=zdNORV4fnlfIOAOm3t0Xc63+f5zeY/RegOlEoF6LMWczVUvkd1al66tot59ma1FYIy6aBD
	KZi1gkXU3HD8IrkXlPs8uDITSVDcGpEgNOFdWQi7DAxud+gOwEApRDA4xfku4JMYkmTUXq
	Rw3hevuVCCj12wexoWsKEPofRY18W8E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6844843A2F;
	Fri,  6 Nov 2026 10:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0321F0089F;
	Fri,  6 Nov 2026 10:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793962009;
	bh=R4UXJ8D6lFItiQJcibx9Gvr2Xk0BfzjmL2Cx9RaqZ2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hCunnEIZfKlr6qoMUNMOsdGsxQ7IjWUgxiafHv1Z+GtVnHVIkVloNm7JSe0jucf4v
	 Be00OZ6LyBekuVn6BjvLPY9n2k+e1AmiDi7InnmDdbDQGdSnjuudqzxDjYAlNYhG2v
	 SnIHZ4gjFJUpZLBedEUDIPptonWTz9uotLA6iRgOA5X7/RHU+Qv1IOi7Qmd5Lw5GMa
	 S4EJI6CpXc1502QDo0gR7VlleOn0nXISLFq96tAGYmHD/6PzuqiHbzA0uFQN4lnX9K
	 Fvb6evOecIr4CJf2MUAMnT/LJw8xU/8SNUha42jnLM4sIhXYighfjJoCreU0/7wDnB
	 tlpx359Zg2mQQ==
Date: Fri, 6 Nov 2026 10:46:29 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, 
	jhubbard@nvidia.com, peterx@redhat.com, willy@infradead.org, jack@suse.cz, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, 
	kas@kernel.org, xu.xin@linux.dev, chengming.zhou@linux.dev, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, ritesh.list@gmail.com, 
	sshegde@linux.ibm.com, pfalcato@suse.de, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baoquan.he@linux.dev, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	leon@kernel.org, sj@kernel.org, rakie.kim@sk.com, rientjes@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, peterz@infradead.org, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	james.clark@linaro.org, mhiramat@kernel.org, oleg@redhat.com, 
	john.johansen@canonical.com, georgia.garcia@canonical.com, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, roberto.sassu@huawei.com, 
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com, wufan@kernel.org, 
	stephen.smalley.work@gmail.com, omosnacek@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, damon@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 09/13] fs/proc/task_mmu: convert VMA flag tests to use
 vma_flags_t
Message-ID: <au2tJWwPamlmx1Q4@gremlin>
References: <20261105-late-2026-vma-flags-v1-9-0d3cd15ab75f@kernel.org>
 <20261106065925.50906-1-lance.yang@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106065925.50906-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7BC98100005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6xm7gyh66juwasz1ukq9p5njipws6jj5
X-HE-Tag: 1793962010-285169
X-HE-Meta: U2FsdGVkX1+97RxeYwTLBX8OXPGY13+LlSpXCQ5sMtydqBQjGdjrlDH+OJ2o2Ywfk7jx2/hGTujZQxxwApc9fNa5ibaPqh3Q6cS3Sbx69eHfujakxYkCtlugkr0Oie3xKWXFchu10TEh7fPqV4x/hfRmjZmCw2L82/2ifJcSl4VHV49v9ZDhgx5faLI1+N88CqHyQwbqqqfrDUxsLoQEfSA4kx/aIWFqfctBwgwx+6HnPsy5/UDOENOTRg75H4NfvqegG+mie4eYLp1FaIWftUIlNumdmcwFkUk8n5Z36MYg9JUZIeq94LUORAA4CcNLFbgpBqTFvMS74K7Al/VdKlabjkzV3XLl+4QllkS5q+ljEbVTu+x/iuNg1Q9TJRzedRlwFu8cjDjOlI7Ur1M+8HzmPL6NXPm408WT1GnCHraCyW484xxBEVRIHR+4wOhmJensT4Uw6TY8snNvFFO7lZ4qwUf/LQzKEl0K1P1X0d6HmfMsRzVCh/4i/aw8wfZUXfF3wTbLuXzByv0lA9tzFQUdxQW6hoExRNtlP8gFxEzSYRRJx1OmEZGR68UAhYUkbqkuu5x6EbI0HqeqEHEi3+qoA+mTmai4tkfpsEX09hm+cz9/k4XldeN5sLm05ufE3wSbIIRzeua4jSBWLjF+L/f268VsOPts8UiEecW24wuRHLG1ylIo5wUaIayalb/KI5WbOtPnftHGs39D9Og0bBgW50TCnVNbScJmvoaHEIzKmX0NsPTJh3j2AYuRHtlo6emfRubJmH/bOmt6boLprRCIyvCBr4EoPDXknLSUZ84KVJGDMZMjoBHDAeFqW2Bv5ogNpQMGLa0+VP+z7+CVn01Sy0gdUO0sRUq2eZxJvCKoESA2QH9UltZlrzBqn6Kmey8b8izBNHMnAyTAujtQ93UFtYCdnvFdV7Co2XYZlQOPqIG1jNOnketr+0AxLaEd6B8W52bg2qY2M8zPdFG
 S4BCuq/M
 wKj61l9dsGZwZ/zb2FEMNx6Gp1u/V5kmI/02LQsrauAV/HMcCbulJh4RzdNGNNF/gkxSbFlcEWofptVDFCR9c/aQ12sCyKZoMGV0rcvXWu/q/7q1rq/HLHekXvcpvDFNxX+F/du4rg068akfOa5avIbJ47eYGe4fWkrQFeRfZHpXsf8OnO0TYsln14C7r4kVxm5rRmhuualKmJTNCcy7hVa7eAqcXfQF5SzRNZhrM167aXYL6q6QlNfmIWCO5+kBQW2d+mAWqI74PhP7YNSKp2ofy0z8JhsKKMaNiuL/pi8rX8hPFc/4XpobVcUAA7ERuYKxgOpFl9ENpetoz09xvZP0McSlBmGARYMA38g0jt99oZeGHYNy0On0LWVBxw3L6zAxyFIlwC5GJUUAogIKaP9hb9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 02:59:25PM +0800, Lance Yang wrote:
>
> On Thu, Nov 05, 2026 at 09:31:00PM +0000, Lorenzo Stoakes (ARM) wrote:
> >Replace use of the legacy vm_flags_t flags with vma_flags_t values where
> >VMA flags are tested directly in /proc/$pid/[s]maps, pagemap, clear_refs
> >and PROCMAP_QUERY.
> >
> >In replacing vm_flags_clear() (which takes the VMA write lock) with
> >vma_clear_flags() (which does not) in clear_refs_write(), we explicitly
> >write lock the VMA. The mmap write lock is already held at this point.
> >
> >The show_vma_header_prefix() and show_smap_vma_flags() output functions and
> >the thp_vma_allowable_orders() call continue to use legacy flags for the
> >time being.
> >
> >No functional change intended.
> >
> >Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >---
> > fs/proc/task_mmu.c | 43 ++++++++++++++++++++++---------------------
> > 1 file changed, 22 insertions(+), 21 deletions(-)
> >
> >diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> >index 22361607020d..b6e8ef15e40e 100644
> >--- a/fs/proc/task_mmu.c
> >+++ b/fs/proc/task_mmu.c
> >@@ -569,18 +569,18 @@ static struct vm_area_struct *query_matching_vma(struct proc_maps_locking_ctx *l
> >
> > 	/* VMA permissions should satisfy query flags */
> > 	if (flags & PROCMAP_QUERY_VMA_FLAGS) {
> >-		u32 perm = 0;
> >+		vma_flags_t perm = EMPTY_VMA_FLAGS;
> >
> > 		if (flags & PROCMAP_QUERY_VMA_READABLE)
> >-			perm |= VM_READ;
> >+			vma_flags_set(&perm, VMA_READ_BIT);
> > 		if (flags & PROCMAP_QUERY_VMA_WRITABLE)
> >-			perm |= VM_WRITE;
> >+			vma_flags_set(&perm, VMA_WRITE_BIT);
> > 		if (flags & PROCMAP_QUERY_VMA_EXECUTABLE)
> >-			perm |= VM_EXEC;
> >+			vma_flags_set(&perm, VMA_EXEC_BIT);
> > 		if (flags & PROCMAP_QUERY_VMA_SHARED)
> >-			perm |= VM_MAYSHARE;
> >+			vma_flags_set(&perm, VMA_MAYSHARE_BIT);
> >
> >-		if ((vma->vm_flags & perm) != perm)
> >+		if (!vma_test_all_mask(vma, perm))
> > 			goto skip_vma;
> > 	}
> >
> >@@ -647,13 +647,13 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
> > 	karg.vma_end = vma->vm_end;
> >
> > 	karg.vma_flags = 0;
> >-	if (vma->vm_flags & VM_READ)
> >+	if (vma_test(vma, VMA_READ_BIT))
> > 		karg.vma_flags |= PROCMAP_QUERY_VMA_READABLE;
> >-	if (vma->vm_flags & VM_WRITE)
> >+	if (vma_test(vma, VMA_WRITE_BIT))
> > 		karg.vma_flags |= PROCMAP_QUERY_VMA_WRITABLE;
> >-	if (vma->vm_flags & VM_EXEC)
> >+	if (vma_test(vma, VMA_EXEC_BIT))
> > 		karg.vma_flags |= PROCMAP_QUERY_VMA_EXECUTABLE;
> >-	if (vma->vm_flags & VM_MAYSHARE)
> >+	if (vma_test(vma, VMA_MAYSHARE_BIT))
> > 		karg.vma_flags |= PROCMAP_QUERY_VMA_SHARED;
> >
> > 	karg.vma_page_size = vma_kernel_pagesize(vma);
> >@@ -970,7 +970,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
> > {
> > 	struct mem_size_stats *mss = walk->private;
> > 	struct vm_area_struct *vma = walk->vma;
> >-	bool locked = !!(vma->vm_flags & VM_LOCKED);
> >+	bool locked = vma_test(vma, VMA_LOCKED_BIT);
> > 	struct page *page = NULL;
> > 	bool present = false, young = false, dirty = false;
> > 	pte_t ptent = ptep_get(pte);
> >@@ -1017,7 +1017,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
> > {
> > 	struct mem_size_stats *mss = walk->private;
> > 	struct vm_area_struct *vma = walk->vma;
> >-	bool locked = !!(vma->vm_flags & VM_LOCKED);
> >+	bool locked = vma_test(vma, VMA_LOCKED_BIT);
> > 	struct page *page = NULL;
> > 	bool present = false;
> > 	struct folio *folio;
> >@@ -1728,7 +1728,7 @@ static int clear_refs_test_walk(unsigned long start, unsigned long end,
> > 	struct clear_refs_private *cp = walk->private;
> > 	struct vm_area_struct *vma = walk->vma;
> >
> >-	if (vma->vm_flags & VM_PFNMAP)
> >+	if (vma_test(vma, VMA_PFNMAP_BIT))
> > 		return 1;
> >
> > 	/*
> >@@ -1798,9 +1798,10 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> >
> > 		if (type == CLEAR_REFS_SOFT_DIRTY) {
> > 			for_each_vma(vmi, vma) {
> >-				if (!(vma->vm_flags & VM_SOFTDIRTY))
> >+				if (!vma_test(vma, VMA_SOFTDIRTY_BIT))
> > 					continue;
> >-				vm_flags_clear(vma, VM_SOFTDIRTY);
>
> vm_flags_clear() still warns on VM_SOFTDIRTY when pgtable_supports_soft_dirty()
> is false. Did you mean to drop that?

Yep it's silly. Checking every single operation with VMA_SOFTDIRTY_BIT for
whether CONFIG_MEM_SOFT_DIRTY is enabled, which is not done for literally any
other VMA flag, is ludicrous frankly :)

>
> (Vaguely recall you weren't too keen on that warn, though I could be wrong.)
>
> Otherwise, LGTM!
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Thanks!

--
Cheers, Lorenzo

