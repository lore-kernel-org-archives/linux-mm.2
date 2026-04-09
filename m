Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D79A6EA3C55
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 11:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04DE56B0005; Thu,  9 Apr 2026 07:50:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025816B0088; Thu,  9 Apr 2026 07:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4986B008A; Thu,  9 Apr 2026 07:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAD026B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:50:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 824DA5A421
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:50:23 +0000 (UTC)
X-FDA: 84638849526.07.D65F5D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AEC9080004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:50:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RmYJuWe2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775735421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zad1zy3mnz8QuK5dO9LxMLEL/K0TsvR650Cl8FuWPGk=;
	b=TOEko8geccofEGHrEVkZsHzHHvsro6byPjW6MPMOUZQQYXsf5D5JwwPE0CO/aoHMHISzLS
	TSepBXf/FvXpNxxCM174v+ywLQkGBKtcWEF24gQTCmg4dih2bWaVdb598yaIWorBfqjYMi
	uW4q6nnGTDHuBHsO6y8f+vM0eMukHLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775735421; a=rsa-sha256;
	cv=none;
	b=zsEQLUxrqzkcSBo08vJ1AAacIl2jCLC63d9vqABiH7Q9gNBZqP6r1Fr5quTRFN7GehDv5e
	aaIADe79BZOMLAP7o8IRjNKmJmt0UjYXGBmDTqCU1uQZIKSLB+a+I7je0fuYgmKdQOZ8xt
	glxXt99sFfc1A+n6hN9MBGCdIMc7rxs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RmYJuWe2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 90FCC44428;
	Thu,  9 Apr 2026 11:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65794C4CEF7;
	Thu,  9 Apr 2026 11:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775735420;
	bh=Mp6RwckuLl4IhCOSbAcDzWGzKF26msw1bEgZICRtzsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RmYJuWe26QucjVeBfEJK64d0300yIFY4sVeYJz0y2S9j10vPr1gURgmRS8Ra6DVQn
	 ERFOwCI2JbX/w68vXuPOqFaCiPoPYMyXFAZG/ihCG3Rll/8pXDACP+1pmL9vZIMXpl
	 QorYsC/2W7S6sHU8M089LtYemTBnvmBmxrqS9fCP01V/uO3NQCZvIdxV7qCfvQB/Bt
	 z5pkAPxv2by7LKYPskTxZu1Jso5dGDLuapoHcpTFbqadFQyKMVi2BeZ+ygdKRuN5q/
	 G9vghTxT7RFWLEH9Z9q27/eLcfDgOphJtEeVheijmCwkTnV5IACKrEHWY9FjjayVYU
	 gvPchPW2O1lcQ==
Date: Thu, 9 Apr 2026 14:50:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 13/15] KVM: guest_memfd: implement userfaultfd
 operations
Message-ID: <adeScX-HVYeYufCm@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
 <20260402041156.1377214-14-rppt@kernel.org>
 <ac7oE_1j6gxf8OKT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac7oE_1j6gxf8OKT@google.com>
X-Rspamd-Queue-Id: AEC9080004
X-Stat-Signature: rdrk8yootyirh3jcz6zsikb1697tzb7z
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775735421-870983
X-HE-Meta: U2FsdGVkX1+VeA33k1gslbxOBcoj27h9P+hKFtoYxYUw4FTJPdk+mmauXrNvSRRe/O3MyegJRCffFgk7oN+2DPhjWAbnYk3PN2tsid569QDDNyc1wwAJZ8QbdueDb/L8WwuVA23YS0h4umv7y4UbIkacvNp1po9ax/Zm40fLnF6s0mq7G2QloZAkPgJeSiSSxu17EIBS7ta7eRcdpKqZdW6siAGidv1pd9CrkLKC2WF5QJbVHtXx2XBcb0bdZGxQu65yA6qlx3mHl5ti5qsjlDfH6e916TApn3WfElKguQQ+QraHNgbrDyvJrpknn7ZWj/KdNBdVjqfnnVecc1q3KxwhaNlEXLv/92OKVA+3EQoUhdmLtpa7fdR5DYSXous4Eoc/fiP3xTmToMHgoetd+yRWCrS3LZ2nWYPMiCEmwIJFy2bEaoObmsHkG/opQU8Y0aEUGRkyFDKES4bo11OlncRWyyS15zWjKYbcdm9z07eppzJeXAHC9p3GOpLLWhvT2IeeJm+xBN7crOduMXzDhaUB4kzrFJWX9lT6HBegKmiRzMo+vT5bmconSybTU5dboScCE4A8vCOTYKdJy2GhizINTuXsRKvvqJsWFOvhDV2oc5wOwThiQ87xN4l058CpY2PSF+jTuiQ9ws9DJ/s2pVxdl5kbDNSWqA+l2U6QBKbMnzwnW98YKahSvhb2xinf8mjfiLa8XXd+aSaOAekqchSQRVpzgHSD+j78qBTdRJ/0oIt6gCD7zYknga2as1YKP53u11qHSBi4bS6RqBN8f5fBD2sv+UKoragk8GgA7S6h3CBzT8nhfrKmpcuuuFoIw72KHSlgmyoGi+Fk7l9fIM9gx7zEbrgkCWxdLund1l1sk9ivZ0DsQw9ZEOHO7gHde90tbSBkUIsCpKSdELEfkdF+HhzqaTtlw0jFyiI+epy+III7Zo6MBLkVC6JbSSG68ZpsJZMCnVQ/jmnV1+w
 kxKdYbiW
 JK+dfm5ghWCYLFSBkPeNpEJOZ/+3Bggr5R7/VbG4+LXAFu0uKpZkZ8RDrEqoobh6PJry5+kkiaET5RuSXAjOb7dsvioIs+CgrI2hGHqCJqXFJwfF/Z8Ac0gfJnCL0w3BaM6ALvrdE7bKl8ffzCFCFfY2gyUue6Cn65Ob5iH+7K99lOOnNjdTsO3ubG7DReaeRSLciSYLA1t3zWKZPgIP85q/y65WblzXaN90mUfkf8kHNuRCKvA1CJ+OY77rRVwHylzPFczAOTT1xKPgCOHBSietqI5RiFdp9dJSqW0NisqP1Ih8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sean,

On Thu, Apr 02, 2026 at 03:05:07PM -0700, Sean Christopherson wrote:
> On Thu, Apr 02, 2026, Mike Rapoport wrote:
>
> > +#ifdef CONFIG_USERFAULTFD
> > +static bool kvm_gmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
> > +{
> > +	struct inode *inode = file_inode(vma->vm_file);
> > +
> > +	/*
> > +	 * Only support userfaultfd for guest_memfd with INIT_SHARED flag.
> > +	 * This ensures the memory can be mapped to userspace.
> > +	 */
> > +	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
> > +		return false;
> 
> I'm not comfortable with this change.  It works for now, but it's going to be
> wildly wrong when in-place conversion comes along.  While I agree with the "Let's
> solve each problem in it's time :)"[*], the time for in-place conversion is now.
> In-place conversion isn't landing this cycle or next, but it's been in development
> for longer than UFFD support, and I'm not willing to punt solvable problems to
> that series, because it's plenty fat as is.

I'm not against solving it as a part of uffd support, but since we are very
close to the merge window, for now I asked Andrew to drop drop guest_memfd
patches from the set and only move forward with the refactoring of uffd and
shmem that has value on its own.
 
> Happily, IIUC, this is an easy problem to solve, and will have a nice side effect
> for the common UFFD code.
> 
> My objection to an early, global "can_userfault()" check is that it's guaranteed
> to cause TOCTOU issues.  E.g. for VM_UFFD_MISSING and VM_UFFD_MINOR, the check on
> whether or not a given address can be faulted in needs to happen in __do_userfault(),
> not broadly when VM_UFFD_MINOR is added to a VMA.  Conceptually, that also better
> aligns the code with the "normal" user fault path in kvm_gmem_fault_user_mapping().
>
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 6f33307c2780..8a2d0625ffa3 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -82,8 +82,8 @@ extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
>  
>  /* VMA userfaultfd operations */
>  struct vm_uffd_ops {
> -       /* Checks if a VMA can support userfaultfd */
> -       bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
> +       /* What UFFD flags/modes are supported. */
> +       const vm_flags_t supported_uffd_flags;

VMA maintainers really didn't like a fields flag in vm_uffd_ops when it was
proposed earlier, but an indirect call may work.

>         /*
>          * Called to resolve UFFDIO_CONTINUE request.
>          * Should return the folio found at pgoff in the VMA's pagecache if it
> 
> with usage like:
> 
> static const struct vm_uffd_ops shmem_uffd_ops = {
> 	.supported_uffd_flags	= __VM_UFFD_FLAGS,
> 	.get_folio_noalloc	= shmem_get_folio_noalloc,
> 	.alloc_folio		= shmem_mfill_folio_alloc,
> 	.filemap_add		= shmem_mfill_filemap_add,
> 	.filemap_remove		= shmem_mfill_filemap_remove,
> };
> 
> All in all, somelike like so (completely untested):
> 
> ---
>  include/linux/userfaultfd_k.h |  4 +-
>  mm/filemap.c                  |  1 +
>  mm/hugetlb.c                  |  8 +---
>  mm/shmem.c                    |  7 +--
>  mm/userfaultfd.c              |  6 +--
>  virt/kvm/guest_memfd.c        | 80 ++++++++++++++++++++++++++++++++++-
>  6 files changed, 87 insertions(+), 19 deletions(-)

Let's revisit after -rc1 :)

-- 
Sincerely yours,
Mike.

