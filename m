Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D31C3F3C262
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A4D6B0088; Mon,  9 Mar 2026 09:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8C76B0089; Mon,  9 Mar 2026 09:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B906B008A; Mon,  9 Mar 2026 09:41:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF68C6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:41:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64EF71A0194
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:41:58 +0000 (UTC)
X-FDA: 84526637916.26.82A813A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A5F55A000D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:41:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SS3qFN7Q;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GLUDDBgVxepWfAs2Z57KYNMaqAUDpdP/rkJm6W1Yc8=;
	b=x9uTyFdej7umF9pYFxXQYKwUVY9/f066jElui/RbU/Zbd5m/jJOwADfJodB83PVJfZgWJ9
	kO7KJid8l6SoDaxqDK8na8SAHRFc/e/S0I7Jf9gPg7LJgE6P5YA7g29FEpa9oTbJ1anHoj
	zjVrkau7/vTcyuC/5ToNbfxJchbcH5E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SS3qFN7Q;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063716; a=rsa-sha256;
	cv=none;
	b=edN9uE/cSHoog0dk9kwuEMC2RTX1bx71l5+ibfqsSP2asBotRNO3VCj6I7sV95oCwO/gmm
	q8T4yw+YIAwXUQqaf+r87G4fzOFOWdDCYS7fuHemcLzqvkB60U1uFyiL5PdRQxLH5yS8ti
	+TUwdpTDtSqTKUQNoPiKnNC+8fECPJs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13F0960130;
	Mon,  9 Mar 2026 13:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A309C4CEF7;
	Mon,  9 Mar 2026 13:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773063715;
	bh=UoUbL95Q4+tSbCtlerVmISNzgIu9HYD6KL01bp1lHXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SS3qFN7Q0Vb6c7hMStjg2G4fQsxATczuRLFp2+E9luZ8z3HUWiFITLQ/PcT9t3nti
	 vrdM9DoYVbqdenkvgAePk4EimHqj8r0simCmFNk8jX202vhWStXUCx/YleD75oJ4lr
	 rCAS0QYc1ocxeaClYLtp2UyBbon6K5QUlwm3AauPOBCiXALALNcMlyi2d1Nf/b7Kfw
	 X/asaAXJSjtc6q9voMpnwngtqxaS/vOZCCbx7h2NqqiqsEwfA8Pn8UVjonEK6OwA7C
	 2G5z0gNjgvypfYcWHuJOfjaWpRsuWl5WLN+9OVlxB6yZ2469XVPHZIYL97BIOqzI1C
	 Fb2vKUPO8JBxg==
Date: Mon, 9 Mar 2026 13:41:51 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 1/4] mm: move vma_kernel_pagesize() from hugetlb to
 mm.h
Message-ID: <d8cdf99b-3139-49b5-bc4f-dda139856021@lucifer.local>
References: <20260306101600.57355-1-david@kernel.org>
 <20260306101600.57355-2-david@kernel.org>
 <833950ef-e01d-4914-b5f9-bc1f6261b184@lucifer.local>
 <729e14d4-6949-4d46-9380-12331b5ad363@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <729e14d4-6949-4d46-9380-12331b5ad363@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A5F55A000D
X-Stat-Signature: wfz35opi9cjr6r8gkhma4san68ccmaxr
X-Rspam-User: 
X-HE-Tag: 1773063716-921686
X-HE-Meta: U2FsdGVkX1+LMvZS1ppL+BRPSHhNbDqo18C9yYFrqZ7/YR5KCZtxSD03Mu4fvyyhRxB2/E6Ywxt40H9nbi1/4JoXUgJbricqP2PNqIsnoiaOyTUn+VUoMvhr7OqwpHQQaHDwd+B2LgPGOPsSFHjeCPsALToOK18pMnh1ZFkh+IWWzNNPXMOYTPK7NurdjFADR3UpgosoQVZdoI8jzcNl2aaKNuQYKNYtHV44TBFy+W1BnfVacHd8sXuW5T3JTNewWMeWgWayhpb//suA8Ts6yjXZxdNUqUG+8TsofaGxPJMXpWj8L83KVK3j0QjBTaDlGBJPpRL5tbJc25nNsqO44ZwCPIyvfbdZY5D3u513R4EZn8QoArit1juZqUj4w1NG8P16JDeWNKc+Ks5T+mN5K8hsYs5E1eO240cGBzeUPKNvpL/K7SVYrbdRHjuBhzkfiLFzBH2z4qg3hFbMIFrF114bw889EJ9c8BYHKt9dCnMOLmUmdd+u/0L8zdJ4MyaBdgVvGCaoTdbpzd9vD56T3CVTCQ9RYuztJ58U5SliwsDqIolGTgY1IkNfc/7FYDie+t0Ca4AO9/fne7aTUZ8ca9qSFtdYdVZdnHuAJRTBxR/ZUkNORIAn6uIQ6Tlz2VlM842SBEUCE2hqu5rKA8pcUhTxg8tDtizac6uuTHF1mQhDPIglKtW93KDT3caaDf9PgU+LfXzL0PT2RYNtLjiEX21NiA7yiACNtS0uTdO66KraR9KNBij/iavmD/tvXsaF0zOiZLa9PxdTI0NOkS36CzUP4Tn+ucm2cJIKK8EbWxz7x9llZL9A2Ah3GTaZ4lTkMijFj9XfAHt129p7YLM5jieV6ZVVEqVqC/OFnChF+qzlnvFupa2fvqghoO2r+KCayFKQk/17JauSTi4wJVOwF54nDw2Fo9ucyMdrkLczSCBRagODWUDX841wC4OHe2dJ7Ifq2neh5Ecc/YPcN7m
 +T5jbmOr
 rOHmNCK2FReshddoF99jNLF3B4M9kE/BB9AK7vLFUM1f5f0SWlajxvjNuPMc4TkIxTAtaYnTYmlnCLD+KQTvN40DclO8QoxE57a601RAcaMguI1ahTqtERKuYplTVTxd3WoxDCUWJtsSYocEDm/Syfj71jp+ZRDXufE02urjyFBfZU0fw5CCGPkMvT7w1SUw6dYQcEWonsU/PWEVNZ2LXA8f/JOqu+YMehWhzYwQAAqZWrAoinVCxz68q9j8JEin3y4kRMacLwBuwc1rLVmc9KHQ5Q1CN5eOLSj6/2MktqFecy8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 02:25:51PM +0100, David Hildenbrand (Arm) wrote:
> On 3/6/26 12:07, Lorenzo Stoakes (Oracle) wrote:
> > On Fri, Mar 06, 2026 at 11:15:57AM +0100, David Hildenbrand (Arm) wrote:
> >> In the past, only hugetlb had special "vma_kernel_pagesize()"
> >> requirements, so it provided its own implementation.
> >>
> >> In commit 05ea88608d4e ("mm, hugetlbfs: introduce ->pagesize() to
> >> vm_operations_struct") we generalized that approach by providing a
> >> vm_ops->pagesize() callback to be used by device-dax.
> >>
> >> Once device-dax started using that callback in commit c1d53b92b95c
> >> ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
> >> it was missed that CONFIG_DEV_DAX does not depend on hugetlb support.
> >>
> >> So building a kernel with CONFIG_DEV_DAX but without CONFIG_HUGETLBFS
> >> would not pick up that value.
> >>
> >> Fix it by moving vma_kernel_pagesize() to mm.h, providing only a single
> >> implementation. While at it, improve the kerneldoc a bit.
> >>
> >> Ideally, we'd move vma_mmu_pagesize() as well to the header. However,
> >> its __weak symbol might be overwritten by a PPC variant in hugetlb code.
> >> So let's leave it in there for now, as it really only matters for some
> >> hugetlb oddities.
> >>
> >> This was found by code inspection.
> >>
> >> Fixes: c1d53b92b95c ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
> >> Cc: Dan Williams <dan.j.williams@intel.com>
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > LGTM, but you need to fix up VMA tests, I attach a patch below to do this. Will
> > this resolved:
>
> Thanks!
>
> I assume that should go into patch #2 instead?
>
> >
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
>
> [...]
>
> > ---
> >  tools/testing/vma/include/dup.h | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> > index 3078ff1487d3..65b1030a7fdf 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -1318,3 +1318,10 @@ static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
> >  	swap(vma->vm_file, file);
> >  	fput(file);
> >  }
> > +
> > +static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
> > +{
> > +	if (unlikely(vma->vm_ops && vma->vm_ops->pagesize))
> > +		return vma->vm_ops->pagesize(vma);
> > +	return PAGE_SIZE;
>
> Should we just KIS and use PAGE_SIZE for the test?

Yeah that's fine, but then should go in tools/testing/vma/include/custom.h :>)

I tidied things up there to make it easier to understand WTH is going on with
the headers used by VMA tests.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

