Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EBFA10ED65C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 11:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5BBC6B0099; Fri, 27 Mar 2026 07:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33326B009B; Fri, 27 Mar 2026 07:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49606B009D; Fri, 27 Mar 2026 07:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2D7A6B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:47:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E1565E44E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:47:53 +0000 (UTC)
X-FDA: 84591668826.07.FA84661
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 80D33140003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:47:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JVtPQC1Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774612071; a=rsa-sha256;
	cv=none;
	b=vIV2HpQ4gsE+eUpksSWDtswHZMlHO81VLchRFRcCT/BdjP3/UHwIAv7AlkSRZRDGTefjMd
	2k2wYQZRrLMvJ03gJT8C5QhdHzmXEpfqLPOIXmXdBaRiQm93sJOk/DSieI/r2xC6a6+GEW
	4XclZURjPvlhr0y+66otWx9Z893qWgA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JVtPQC1Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774612071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKqzFvwXzhS8nRjgbnuxOzJWWJ8T36EDhYbO8NRaYcI=;
	b=H/CLIOyFB5LyrMQiZRLk7rRY4PqSfuM/6rsaggDJGRdo+R77MhiHPI3zBpi3COoVgyzZlv
	xZ+MmoN2Zwd1pa9jL+UkVGqw04Ew0PyYJ/POZdLyNzF+geqNG0Qf4qhyZlHpkfIXgh7x9M
	//V2BpU9mz2sZK5Ak/K+dUYBpscY4tc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E17776133B;
	Fri, 27 Mar 2026 11:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307D5C19423;
	Fri, 27 Mar 2026 11:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774612070;
	bh=UWqo7y+v96VP3ho6z6Rwh/7HEqf87P4hquLIZgzv6Dk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JVtPQC1QKmz6DnjLXtwlTrh2b0p+bEwQvHTZifkPYXVY/sul5MEIRGg0gtTzzhmIg
	 SOGSODY42KxI6xrUOZWneQwo0/9fFNjxWkE0iVbvA6fq5vezKgPyEbTg0E+ho+FxCQ
	 Ju7kEjh/hXS8KNnmOQF5JsaiLpwCeotJWliIg3fmEtBuDtZ6Bi4wuYNaHw1plsOYGk
	 gaHo6F+0A96bzW5HbCtHSIeyk+hMcweQG1/EkAB/+41G0jGn/pXRA198KEdiR6PdaM
	 ncKwKOZMVRHgjWWikiYYWKcmcRoZARR2HT3hEgLKKACDsECDeL+MWwTyuNLOkavVsV
	 6r+o+bsgkDZrg==
Date: Fri, 27 Mar 2026 14:47:39 +0300
From: Mike Rapoport <rppt@kernel.org>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: Re: [PATCH v2 13/15] KVM: guest_memfd: implement userfaultfd
 operations
Message-ID: <acZuW7_7yBdVsJqK@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
 <20260306171815.3160826-14-rppt@kernel.org>
 <CADrL8HViJ_GaRUd-k9MyM0S8b7sz3whGJHNwvFfCk+pw0+kRgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADrL8HViJ_GaRUd-k9MyM0S8b7sz3whGJHNwvFfCk+pw0+kRgA@mail.gmail.com>
X-Stat-Signature: fxfdnrsin4fza3y7acmt5e7qmgqzxoen
X-Rspamd-Queue-Id: 80D33140003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774612071-416926
X-HE-Meta: U2FsdGVkX18ZUsAb2FWRPx1IF3pXdfFEkwYgg2HXCWOYBjheuYkvT2ZhmEsTWL1IG8nos5khPyz5C5dvnZs5NteZyHVHAYwVOqjYXa93Ww8ad8+hWIy0EtuGv9FgxW9fDHsUNp0ERJ/BKr1ooh2QB3NwihbEr7d9h7OfMgKcZZNCLkOsYAotAJ+xPuejrUPoaKOqVkkf3G9WNQIlu1IAmV82iz3+bNXdmIpuLpYr+2SkUkz5Nef5emSLwz0Lq2LfFqbsuTPBt3zKRvgmZ5O7rC65HCabtpE+j644sPUv08xK+zKH6nmMSxehmFWBBV0Z8miqTJPqo7NMkoQXGRAsZPVI46dpQ9ZammH6cI+8zRlIurzTP6aEPDkjTvtaGKuwq8Jj+Nm90X5SK3SyzMu2VnW6AaJOeEgbBLz2yeFM2wYlWNec5qy0EAbEVb/y0XtNxQbnBbpH9nkM3X8yYjKNK9/YCzlzUaspWg2sCDpS7Dq9YYRxiGmJPEfcggaqbmns1tPtMNx5eGc6sxzgE0JPWqcv7Y3Ozm+p+B9EU3qwZEWx/nPZUxjGkkBeOM6sjhecB79qCgEmxUoU/ItrOezd/+mUfu7yaXCigpRVJfTGe4AiySLdGD8tgO00FUVPclwdxeG7fo2lHB2+VsDdLkqSqIYJqKNGrtrp0ZcntBaXThyaIaLCk5X9DmcnPTulrhfoynLHy//8N8M6LRl6efLRKbMBLdJDQi0NyhPh0rWxSDfUZE533iqB5umxr73vM2ACORMFATAZP2+Fz93OlRu5sBnCRJ0H3FrGz3vV6P26LF6jpBjYBhUBp/JBlYdjAM3wcL4LDdQ26gtLlj3T8+NcPPf1EKU4uumxq/1UZ5xYV6w+GVwdrPx4zwWecmt6JVhBznXDWjEiV7OAbkrHDa8DShgTMyEaJJqyIY+b3Ate+xdt/yos3VLzuAV1O93KXxfRTyV0FixvPAfdbxKbeUr
 FHYDT/FB
 P2Wfi885V5FoHC0DNSb0Q4muCFfQ02L1neemds4XZYIdYUfIwk5E2TfKSleDqJqYtv5fYC8j2Ou6jQi3+ro/8r0ptILPBlAg2mOvA3/7RJzH6CUeFIvKjwunDDipUj67zrSQHoaPKtTyMTQIDwJ5LD4vOwi71LUjp6y09gowoE/lfpszjtKWimkDfCRENFWPKl9pQkREFNnbbTgS/tAr+Gi9G8XO/MhAmSlvP2t1NnZDa2raAUjDpAzcPUcjoLbmRXO1ujmVdMwmRxPuKRnP5IINY5S5MTjHu1cPEtA0c8eZ0vaKxIdzYDwR38EmE2whUbKn0TuFjfyZbqeC9QFFnD+aBK2Q8GbYarzeUvurujF1ymG+D/0R7S3KMmufNc7EyO9sF5HBNQUkPb+naxFxhWSGXzUbnEHTVnRbCE1SqZpS7Sb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 07:33:03PM -0700, James Houghton wrote:
> On Fri, Mar 6, 2026 at 9:19 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > From: Nikita Kalyazin <kalyazin@amazon.com>
> >
> > userfaultfd notifications about page faults used for live migration
> > and snapshotting of VMs.
> >
> > MISSING mode allows post-copy live migration and MINOR mode allows
> > optimization for post-copy live migration for VMs backed with shared
> > hugetlbfs or tmpfs mappings as described in detail in commit
> > 7677f7fd8be7 ("userfaultfd: add minor fault registration mode").
> >
> > To use the same mechanisms for VMs that use guest_memfd to map their
> > memory, guest_memfd should support userfaultfd operations.
> >
> > Add implementation of vm_uffd_ops to guest_memfd.
> >
> > Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> > Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Overall looks fine to me, but I am slightly concerned about in-place
> conversion[1], and I think you're going to want to implement a
> kvm_gmem_folio_present() op or something (like I was saying on the
> previous patch[2]).

Let's solve each problem in it's time :)
 
> [1]: https://lore.kernel.org/kvm/20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com/
> [2]: https://lore.kernel.org/linux-mm/CADrL8HVUJ5FL97d9ytxp2WXos6HS+U+ycpsi5VxffsW9vacr9Q@mail.gmail.com/
> 
> Some in-line comments below.
> 
> > ---
> >  mm/filemap.c           |  1 +
> >  virt/kvm/guest_memfd.c | 84 +++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 83 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 6cd7974d4ada..19dfcebcd23f 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -107,6 +108,12 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >         return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> >  }
> >
> > +static struct folio *kvm_gmem_get_folio_noalloc(struct inode *inode, pgoff_t pgoff)
> > +{
> > +       return __filemap_get_folio(inode->i_mapping, pgoff,
> > +                                  FGP_LOCK | FGP_ACCESSED, 0);
> > +}
> 
> When in-place conversion is supported, I wonder what the semantics
> should be for when we get userfaults.
> 
> Upon a userspace access to a file offset that is populated but
> private, should we get a userfault or a SIGBUS?
> 
> I guess getting a userfault is strictly more useful for userspace, but
> I'm not sure which choice is more correct.
 
Me neither :)

We can deliver userfault, but just block UFFDIO_COPY, can't we?

> > +static int kvm_gmem_filemap_add(struct folio *folio,
> > +                               struct vm_area_struct *vma,
> > +                               unsigned long addr)
> > +{
> > +       struct inode *inode = file_inode(vma->vm_file);
> > +       struct address_space *mapping = inode->i_mapping;
> > +       pgoff_t pgoff = linear_page_index(vma, addr);
> > +       int err;
> > +
> > +       __folio_set_locked(folio);
> > +       err = filemap_add_folio(mapping, folio, pgoff, GFP_KERNEL);
> 
> This is going to get more interesting with in-place conversion. I'm
> not really sure how to synchronize with it, but we'll probably need to
> take the invalidate lock for reading. And then we'll need a separate
> uffd_op to drop it after we install the PTE... I think.

I think we can start simple and then move on along with the in-place
conversion work. If there will be a need for a new uffd_ops callback we can
add it then.
 
-- 
Sincerely yours,
Mike.

