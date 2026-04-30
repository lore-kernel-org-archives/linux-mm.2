Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 593A9FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 17:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF336B0088; Thu, 30 Apr 2026 13:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0186B008A; Thu, 30 Apr 2026 13:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5C76B008C; Thu, 30 Apr 2026 13:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF7E6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:36:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2782BC1437
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:36:43 +0000 (UTC)
X-FDA: 84715927086.25.9B399A9
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 164211C0012
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:36:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=byLqBcKY;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf21.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777570601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M87BuBBT+GOb5gsFg9FHG50Qk98PK6FnYSz2TxEGyCI=;
	b=DZiKFV5RUciv4JlrfZe0CaTGvuE0vEHNKzICTTiDaplJNh6p2v++XO7BtaBXwuxbcviR6L
	7mBLC6e0tWpPKQJHMLwBqI002skp4uBWlphKa1eARqskB9EeWLd40Y0IAKPHPf/EGhwVTz
	prVU+9REmSDcro9Xj3H3GRJcvoxyM2U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777570601; a=rsa-sha256;
	cv=none;
	b=KT3sKnZ/8zDit5zHWjXkhpjl/XuyWYNUlgDzb0WJ0344X+i01rIXNhLIoB4fRZrld6v/Bu
	fYVvcJpxXIzgmjRMgvRRgvyqAUqpECuVFWPpgLB2uzlggkiF7GBYIhtx9xcpu/V0HHnO/y
	2RO+BWSM8hCs2vpcB9+n2Wrs9lbuQ6k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=byLqBcKY;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf21.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com
Received: from skinsburskii.localdomain (unknown [52.148.138.235])
	by linux.microsoft.com (Postfix) with ESMTPSA id A3F4420B716C;
	Thu, 30 Apr 2026 10:36:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A3F4420B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777570599;
	bh=M87BuBBT+GOb5gsFg9FHG50Qk98PK6FnYSz2TxEGyCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=byLqBcKYoVKc3oxInI/UMEjLBzY6gk+cFj2l6pVB/DjIvLDDIThbEQotnsa8YGNje
	 qhwfzfmwdrgFSn63PuaKmBqCQ9wtdBLrqPWA9EL/xd+ynm1QVNfGuo95ISzgD3de0D
	 EMVoORpXs9Wu21gXbDFgS/OZotE/BD7WsTIqpQic=
Date: Thu, 30 Apr 2026 10:36:38 -0700
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/hmm: Add userfaultfd support to fault handling
Message-ID: <afOTJml4Ia776G4Y@skinsburskii.localdomain>
References: <177499585916.169073.8313365481186071940.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
 <286425bc-e2a2-4e29-abdf-666e798e6cf4@kernel.org>
 <aejiV8rQIOgrlCkh@skinsburskii.localdomain>
 <b47ba580-2443-482f-8a92-558af82d13f2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b47ba580-2443-482f-8a92-558af82d13f2@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 164211C0012
X-Stat-Signature: sfrur6z7jo1i9qy4hfkhgbcajkdwdkj4
X-Rspam-User: 
X-HE-Tag: 1777570600-616893
X-HE-Meta: U2FsdGVkX18nEmAsNZyHt/YsC9s4jPwmq+01uJSvR8jionxxMA40sJpRXL+aXJ6t/qSOdjDcIcQuCTmUPAVi0FKWaY43Upc1aa3uLNpegpcnHijkGNmOd5Yw33EpFhfZzk8a/lGysVnePnmSFyR4sXNJhqzR9FSb0VVEp2IJBwRuQeyIqUIfNfp8180SCggz/0TuqBkXwSlyFGgPFu9t2cMHidxOXstuJWrLJ/Bx2mQAA2mvKl34l9mqBlewMgSAzDsFl2/KsK0VjEeGkGG8/g3fimQbwXy5OneAq1wJUq58PzYJCJzlQA7aEsHXK2R11nyowNFTMmiST1tYaCJj/tppbIxAPOwFLDR2x0srESfW6RAn1WcquihUgE2mlrsNkUAPIqfvUy2n4S1IvN9TmYSwg3UpJhnyFUXjPLbyIeo6iUcE6nea22Adz2pubyN7m2tdgrORwKlN41kvx/Cdf7TtB9JxnFVXBmnmXXXu+KpBe4sBPme+bCb+phZQZg7Wtk3dQQFoZErxWSkoYcLHD9/iOz4i3EWjy3T/CW0FyORjbTRhh91dFwyincnV2/bCQi4iNOw0Jb+EWRuN/8sFCWW4dlCH3GyUnBNpey3qg765AC6bwAHoa/8gttF/qV9uMKQCQD1fosTZ5Zx0f14yz/Z5ziIlDfHll/y5mvLsC00olTZpSQMThV0KENkcThBDzX9FKAhmauf4ZzCyNT9To80njOJddSC+nwu8vvIIhe/WQblfXby752tGOjnvF+s6k+s9obCtQk2HROtWlSGHgEqYYOHnhD8HMB6uLqS6EffWcpCUXkV8ylmwcF5akd7rVgNevZlkWl+SIDdrbbwOCMdYIPrIqc91bnn38mTsnYY1jmRfrx1vj/F/S9VPZ2WfmTHee8bYMpxl8QmzErhFX2sDIXKPTPVm5uN9ATt9SYuv1fhrXiXbVQ29azDzndTCgCS3MaQZzUaH2WNSHYB
 LobOis52
 5tUKC/QCrbi/Ub4ZCws+aVRTCV893FQLhY9J8rrKMpYwZ1GSU2PhYommdix60udJoMBcF6b67f59+YcUS+IZLmc5fqTG+0ewlnP/65bsI7/kPvE12dKiwp3q2QcA2Ob1r0PGUshiOW0SKWH0vQxZw+sE4phh7qxHUjbiqDhC5oqFLOtIqhBQcv73PY2RTO0eUsGyl4+77iTPXfQmkhGn9fae3B/oLdNChxs9WAZa0x9RZq0YY6yOMqRYGD86WB/ukGrJQi0T45wK1+pLUYa4AWrOYrR7esxTF0KYUnVOH3s+8T1soSUiY0//d1zPeXRPq5weF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 08:14:24PM +0200, David Hildenbrand (Arm) wrote:
> On 4/22/26 16:59, Stanislav Kinsburskii wrote:
> > On Wed, Apr 22, 2026 at 09:27:44AM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/1/26 00:24, Stanislav Kinsburskii wrote:
> >>> Add support for userfaultfd-enabled VMAs to the HMM framework.
> >>>
> >>> Extract fault handling logic into hmm_handle_mm_fault() to handle both
> >>> regular and userfaultfd-backed mappings. The implementation follows
> >>> fixup_user_fault() for handling VM_FAULT_RETRY and VM_FAULT_COMPLETED, with
> >>> a key difference: instead of retrying or moving forward respectively,
> >>> return -EBUSY after reacquiring mmap_read_lock. Since the lock was
> >>> released, the VMA could have changed, so defer retry logic to the caller.
> >>>
> >>> This approach is inefficient for userfaultfd-backed VMAs, as HMM can only
> >>> populate one page at a time, but keeps the framework simple by avoiding
> >>> complex retry logic within HMM itself.
> >>>
> >>> Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
> >>> ---
> >>>  mm/hmm.c |   40 ++++++++++++++++++++++++++++++++++++----
> >>>  1 file changed, 36 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/mm/hmm.c b/mm/hmm.c
> >>> index f6c4ddff4bd6..d04d68e21473 100644
> >>> --- a/mm/hmm.c
> >>> +++ b/mm/hmm.c
> >>> @@ -59,6 +59,35 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
> >>>  	return 0;
> >>>  }
> >>>  
> >>> +static int hmm_handle_mm_fault(struct vm_area_struct *vma,
> >>> +			       unsigned long addr,
> >>> +			       unsigned int fault_flags)
> >>> +{
> >>> +	int ret;
> >>> +
> >>> +	if (userfaultfd_missing(vma)) {
> >>> +		struct mm_struct *mm = vma->vm_mm;
> >>> +
> >>> +		fault_flags |= FAULT_FLAG_ALLOW_RETRY |
> >>> +			       FAULT_FLAG_USER;
> >>> +
> >>> +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
> >>> +
> >>> +		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
> >>> +			mmap_read_lock(mm);
> >>> +			return -EBUSY;
> >>> +		}
> >>> +
> >>> +		if (ret & VM_FAULT_ERROR)
> >>> +			return vm_fault_to_errno(ret, 0);
> >>> +	} else {
> >>> +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
> >>> +		if (ret & VM_FAULT_ERROR)
> >>> +			return vm_fault_to_errno(ret, 0);
> >>> +	}
> >>
> >> I'm surprised that there is userfaultfd_missing() logic required here at
> >> all.
> >>
> >> What prevents us from always calling handle_mm_fault() in a way +
> >> handling return values, such that we will just do the right thing
> >> independent of userfaultfd_missing()?
> >>
> > 
> > Essentially, the main issue with the current HMM framework is that
> > handle_mm_fault() with FAULT_FLAG_ALLOW_RETRY (needed for userfaultfd)
> > can drop the mm lock. The framework does not expect or support that yet.
> > That is why I had to add the branching.
> > 
> > The worst part is that handle_mm_fault() can unlock via
> > mm_read_unlock(), while svm_range_restore_work() takes the mm write
> > lock and this RFC patch doesn't address this problem.
> > 
> > The main question where I’d like feedback is: should userfaultfd be
> > supported in the HMM framework at all, given the complexity around
> > unlocking and retry handling (similar to other gup helpers) or should
> > this complexity be offloaded to the caller side?
> > 
> > If it should be suported, then I see two ways to implement this:
> > 
> > 1. Introduce a new HMM_NEED_USER_FAULT flag to tell the framework that
> >    the caller needs userfaultfd support, and extend the framework
> >    accordingly. This is not intrusive to existing code. But if we want lazy
> >    migration for GPU state in the future (and we likely do), GPU drivers
> >    will have to be updated to set this flag later. The only real user of
> >    this feature right now is the MSHV driver and I'd extend it to set
> >    this flag right away and leave GPU HMM users for later.
> > 
> > 2. Add retry logic to hmm_handle_mm_fault() to handle VM_FAULT_RETRY and
> >    VM_FAULT_COMPLETED, as required for userfaultfd support. This would be
> >    transparent to users. But it would require significant changes: mm
> >    relocking, VMA lookup, and other parts. Also, before doing that, the
> >    kfd_svm driver would need to be changed to downgrade the mm lock to
> >    read.
> 
> Exactly this. If we want this, it should be done the proper way, by teaching
> calling code that the lock was dropped etc.
> 
> There should not be userfaultfd special-casing anywhere, it's just a matter of
> teaching the code that we might get the mmap lock dropped.
> 
> Now, that might be a bit of work :)
> 
> What we do in mm/gup.c, is letting callers opt-in whether they can handle
> getting the mmap lock dropped -- not opting in to userfaultfd.
> 
> See FOLL_UNLOCKABLE. Such an approach enables a step-wise implementation.
> But note that FOLL_UNLOCKABLE is an internal flag. We set it automatically when
> someone passes us a "locked" variable, indicating that they can deal with it.
> 
> 
> See populate_vma_page_range() as one example.
> 

Okay. So, here is how I underestand what you propose: I should introduce
a new hmm helper function, hmm_range_fault_unlockable(), that would
accept an additional argument, "locked", to indicate whether the caller
can handle the mm lock being dropped. This function would implement the
retry logic for VM_FAULT_RETRY and VM_FAULT_COMPLETED, and the existing
hmm_range_fault() would call hmm_range_fault_unlockable() with
locked=false, while the MSHV driver would call it with locked=true. This
way, we can keep the userfaultfd logic within the hmm framework, while
allowing for a step-wise implementation.

Does this sound reasonable to you?

Thanks,
Stanislav

> -- 
> Cheers,
> 
> David

