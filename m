Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2397BF364A3
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 17:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571FA6B0005; Thu,  9 Apr 2026 13:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522BF6B0088; Thu,  9 Apr 2026 13:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA566B008A; Thu,  9 Apr 2026 13:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CF856B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:19:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0173C2AB6
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:19:12 +0000 (UTC)
X-FDA: 84639678144.10.E92D456
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D15B840005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:19:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TANCjvkw;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775755151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grHbRatBeQQy256OvZuKHDLVyKgjZm55I2/EOqWEDPo=;
	b=F70WUpRrh2cE7VFk5khAzcsOaRkqk7XbatKg+SXoVIs1Dc1D3pJMJ7v5zlhBXQlJ/CLMYL
	wIKvddzNZsRSyKpDele1yw7hKpOsSom1HWP+xSQtim/EO1aG+185BZwSvY3oki+jZ65pW1
	WZV2h5TlyoKL5BfotfzLZuxvmVRs2bI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775755151; a=rsa-sha256;
	cv=none;
	b=BA/UrfFR8Igzw+nEFwxMtRHYINEbE1EZkLkOlyMcVVAXja4xax/JEKx5fdfo23JPOheSny
	f/Llq+QR4k1O545U17jjwsSJSEIze50UJtduFABHcmjQ/1I7M2IxHY73jnYJHrNo2clCRv
	tTu4m0kleBmgoi2gzGjQgELh+Xn4rLc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TANCjvkw;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A933D43D4A;
	Thu,  9 Apr 2026 17:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338ACC4CEF7;
	Thu,  9 Apr 2026 17:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775755149;
	bh=cGMLUPOtx8qaZqawYKdm2oqkNFYMjpc+BvWqDcnrHmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TANCjvkwBh0HGfxUlaqhwxG1wASBAqCJhrHR+iNTurVIvK7eDEUwCeDqx+t4TlRol
	 AgdDj8kwm6Vk3GekEV/tztKEH2omKNhV816obK929+XIO7HpukmwN1iiFr8cymvieU
	 njkaq1E3/Sa5xZ/MitYIofrgWeZ0jhhXzJVakyzoNvEFhnQrK5DfMlp+AiOm1lgCB8
	 BTQicRTFbKOgnCpDMGjf6/mDFFkPQH3EtMWoGjxGyMebiHPNnTvROup6Xxn1vZDVak
	 dYrfOgpFh2ictQjcE7u6Kn4eZDIdwVV5RAyvgwIpubxVyMxTe4pQWuHa1RllwfEXUC
	 URTq/JMPoPSpw==
Date: Thu, 9 Apr 2026 20:18:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 07/15] userfaultfd: introduce vm_uffd_ops
Message-ID: <adffgfM5ANxtPIEF@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
 <20260402041156.1377214-8-rppt@kernel.org>
 <6a171abc-ebd2-4ddf-8c36-34c66ca42043@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a171abc-ebd2-4ddf-8c36-34c66ca42043@columbia.edu>
X-Rspamd-Server: rspam12
X-Stat-Signature: bntw83hux46pfkhrtj53yucmqmwqpdns
X-Rspamd-Queue-Id: D15B840005
X-Rspam-User: 
X-HE-Tag: 1775755150-254274
X-HE-Meta: U2FsdGVkX18zG6gsPi8UdVnd0+jwd09FEcU+5Zu1SQ9NlVPOvEuoQv82Lbnta+zMYFC0JSMwwD58AgSfFf5fUN7wf2uPFyYBeTP3RjP1cXHeIYkbLGRSqVoYm89H6EJHFbsPoFmkGEqtOKRmtq++sqHN/6iYz+wW//f893Gvzd0axg3zSDh7hSE12s1cHRXusizpN8eRLb2+WOBfLfcS2uFq2QFNfgOnJELSUEWIQaktnY0gq3Ad7zGFZkRniGp07vU1Z8jydsQvgH9i7xKR9s8Deu+Nu2sqa4GfmfTIAzOp3LBwyZZp+a8jrU+uAftbt/KKPHY3BTab+NZAsiX1fliO8SviMW1meKoar9OJgTYlMwq1EObf4A7tlfOCGcjJ8h2FMUBxFF1qTcHLtmdZPbf/7LUq8W7b9dVDEamA4AY1iTjoTKjHf+8wF0v/I030JAwzShEhRIc/2N7vfPC6UPedS+xcd1AkLclc6iFz2OqW+jG5mrZQHoD4ldEuifVLvkT1ianFZp0d/rSGCsO8wCXUMQvGtLzWr/IWipAvhle0tIxMfBSyZfusGPSkgXPs4013Qbvbz3h5RwF9DoOVRIaHWCR+z/a4ypKobDEj9D9CnfMxaXj8ZBUyd4XhtO18fTQ82wtHyJv0brCH1YMRYdwCVCYP2I2JITdC0/JIWKKahBPwFNHkhsqU2AL7La4Vev31GMeaMHaExJQVcS9PEOVOgiCnDeCeTSdVE6dw0+IYDamQCCSrtcdlQM+7c/vPRExFhg+eKWUkKUsod9pV6tfLqfvLdZYCFopZsIzUZav3PWHFlRq5o8jv5rVjyuGt0aumlCzjqjll12u+ibZvUfhOBteGuonOczDKxUl7P5Ao1VLYyQJDtQgCoSji43Hq5JR/0yETzifi+RwJS480iWGwpk5pyyiDHp8PXOGJKlDkt+UmIbmm6twuum3Vs0TL8e4Btd980N1XFV9hWOg
 YpC165WH
 hh4ACa7Jn7BpTeSf1h52fQYiCLt0QI40JQjul+TSfKOqVMXdf4sgcX74brQRANLnNhSAkesDvYLvimOwem0bV+rIzvaX3KIQGTnu/BeEqZMUZQ1izOcd9aYRYQD98HsZmCK8G6jypG1VT625jTcC3fbcH3rym+gFYPnmQG75qie5wE9nYi2dVdSY6ggSjacyPio6lzDYMpLoStrXclh6tdEFEDag+D4pYW5acBwEecKJQQTCaZlDGmixP0rM8+XtoF/9M5oRVJeuJmb+UOe3ZGmTIR79cIvnXaXImFPA06VTRQIl8DR3niJe68g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 03:32:58PM -0400, Tal Zussman wrote:
> Hi Mike,
> 
> On 4/2/26 12:11 AM, Mike Rapoport wrote:
> > @@ -2021,34 +2040,33 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
> >  bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
> >  		       bool wp_async)
> >  {
> > -	vm_flags &= __VM_UFFD_FLAGS;
> > +	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> >  
> > -	if (vma->vm_flags & VM_DROPPABLE)
> > -		return false;
> > -
> > -	if ((vm_flags & VM_UFFD_MINOR) &&
> > -	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
> > -		return false;
> > +	vm_flags &= __VM_UFFD_FLAGS;
> >  
> >  	/*
> > -	 * If wp async enabled, and WP is the only mode enabled, allow any
> > +	 * If WP is the only mode enabled and context is wp async, allow any
> >  	 * memory type.
> >  	 */
> >  	if (wp_async && (vm_flags == VM_UFFD_WP))
> >  		return true;
> >  
> > +	/* For any other mode reject VMAs that don't implement vm_uffd_ops */
> > +	if (!ops)
> > +		return false;
> > +
> > +	if (vma->vm_flags & VM_DROPPABLE)
> > +		return false;
> > +
> 
> Doesn't moving the VM_DROPPABLE check after the wp_async early return make
> the issue David raised in [1] possible again (i.e. moving swapbacked pages
> into a droppable region using UFFDIO_MOVE)? With this change, VM_DROPPABLE
> pages can now be registered with uffd under wp_async, which allows
> UFFDIO_MOVE.
> 
> I think the VM_DROPPABLE check should go right before the wp_async check.
> And it would probably benefit from a comment...

You are right.

Andrew, if it's not too late can you please add this fixup:

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index f1828106484b..75290483ffc7 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2019,6 +2019,9 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
+	if (vma->vm_flags & VM_DROPPABLE)
+		return false;
+
 	vm_flags &= __VM_UFFD_FLAGS;
 
 	/*
@@ -2032,9 +2035,6 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 	if (!ops)
 		return false;
 
-	if (vma->vm_flags & VM_DROPPABLE)
-		return false;
-
 	/*
 	 * If user requested uffd-wp but not enabled pte markers for
 	 * uffd-wp, then only anonymous memory is supported

 
> Thanks,
> Tal

-- 
Sincerely yours,
Mike.

