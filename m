Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D7BF9EDF6
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 14:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98126B0088; Wed, 22 Apr 2026 10:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48E96B008A; Wed, 22 Apr 2026 10:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5ED26B008C; Wed, 22 Apr 2026 10:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B11D26B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:59:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 11A83E33ED
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:59:40 +0000 (UTC)
X-FDA: 84686500920.29.AF6B7B8
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id F2B05180007
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:59:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=Lmj0lKMd;
	spf=pass (imf06.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776869978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzwgEI2rAv+UuV/ojSZXA8oFHB9gGr87UynDh8gLwD4=;
	b=H2+mzXnUuF1taJPJfYaXjGlbTV998l/AImwmnltOaa0YkoudFKLJfhCWLsEnAGnlTFpATl
	ofi1Dc2on9I8twUhhfNOm6V7YpOOsV02ps0UhWawmXxdtn0bTJqcqDKOks1Jy6s2u+fJs6
	6RdESt78kUxxOUS4mx8XhQx17RbT7+M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=Lmj0lKMd;
	spf=pass (imf06.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776869978; a=rsa-sha256;
	cv=none;
	b=j89Wn0TFvCkg45yng+RIynrjaqPcvvOGCkcIk/w+NjlV6tmkfFSfBshrMmpQgYs1ibRY5J
	F/LkGxcJPcOyUTQas60mzU/HwSSjc1D6AxNqyCGGqqWExLwZCbK734IjZB3yVdXNjbYrIi
	BrhZXPYL5kvFfyG8i/S8/4pS256CqGU=
Received: from skinsburskii.localdomain (unknown [52.148.171.5])
	by linux.microsoft.com (Postfix) with ESMTPSA id 92DE820B6F01;
	Wed, 22 Apr 2026 07:59:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 92DE820B6F01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1776869976;
	bh=NzwgEI2rAv+UuV/ojSZXA8oFHB9gGr87UynDh8gLwD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lmj0lKMdOpIvnPWyIU2lay0uxLVXRJAWkzClONs2kePd9jlsTLs0Hw9wiqnAU/EGz
	 vPw/n/EcdruQyJMOt7CK19NJSxXdkCNzq0HzSzXh9Oe+OVRtKdMqvIW4D5Aa3YdQ/Y
	 BXJz9mfVb/jbjHxmlXSSlCk4/y+tndrd2saWochw=
Date: Wed, 22 Apr 2026 07:59:35 -0700
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/hmm: Add userfaultfd support to fault handling
Message-ID: <aejiV8rQIOgrlCkh@skinsburskii.localdomain>
References: <177499585916.169073.8313365481186071940.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
 <286425bc-e2a2-4e29-abdf-666e798e6cf4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <286425bc-e2a2-4e29-abdf-666e798e6cf4@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2B05180007
X-Stat-Signature: htgyuxedyht8qe7tc8hapb98yqd6c3es
X-Rspam-User: 
X-HE-Tag: 1776869977-52458
X-HE-Meta: U2FsdGVkX1/aatNNluDjgyEyPQMmz7VrowZy50ID4lBM28qxpckCGK2WX+CxcykHhTjD5r5qFvGFDy+mld/M9MUyw/THQwX5ttXTvSwT8vAntd2Ri+/nwyj4OVLfspVXdePNhnXkrIIFRKZUsBpUvtvuZaRcdMxiMSECcA5mUBcI53OAhDN2ofqqQCJGFeGChwrsO6AP1fzUwS88wo1os5Wi61QWQ+2R53o88WQgvA96R1lXrp7tfG7qGfwZndEos/VR/4mHFEJTruBc6ISX9Zl4OEkYwrPwW/lUT2QuhgoFtmlhEYB88XliVRe7wb+ahpxT3RaTG+vEdKK4TTIxB5IQ/Bu4CRZ5EHBSSAAzss+HzjORvjVgsOcftsAgKVDAu0JpcQf8caTAwUU2PnPNNKfiUwGjXLsjHG6bRMeqsx3jy28Jo1DdqRUSI6E/82WuofiUul4kZ24vhiJgFL6zNaUG5wH4qv2upUuvG8BmZvmdnqsWw34xAGvAB8Eso+LXzsvSnHVellAPsmsIQN9PC8bTwCpRlC+C4R4OdDjNyLNfeidp4nweaMljxWYQOJxD5Bt5fxA66HGudDhxzfZ9viQhcxuCopJKOAN1Dq/pQMLYgYlPsJHBr39lTkPLlpspHjKLUjGcqZ3hZoWFAHIbmGDDN2mikMkw/zwGZ2erKiHaMay5dDm9IKBkfDWoONTkZ7XYG78Fe+PeTjz0T1F3+DgW4gjcXtI4Kdpy2KlscVPPDlk4K9UxE57enI2Ky7xWLQih+WOK1FTNibW07xhDqLA7naL2jkpLzw8AdiFEsWENdhTEFa9iTnPvf7Y9L21HBSsW7s4INbJvrn3TxLKGfWcZfpT3vQ44TouZCojHpHyQRJOoGQe43rV9YKHZS+cR5M6umxJr2MWnw3kGgy+osDTJC3uol4rYB2tMMbXL14FzAMBbe3EhJQIrBhq+b4/ZFDRdM9aa+IbNPOSgEwO
 6KJsDlkl
 q4qkEMv8JIkUApFFZP40LFdpgbLdV3Lbc9OWG6/P7TyLse1L6eILH96l50jm62XfbOgVWOh2dkptiXGuHYc8YMp7u2j3BoOAjayf0f+dIGPv+1lfDvFYkeaUX3vIo+zv1Yt1X+GdXoRBSUKDJYen7YT0FwxvcpDtTgFftiGvcNHuLVx0eA+LDfwwRE+Q+LbaLBLYl36NgD78b7doS1Gb16vNCQLZZwG+y6ZOprRiTpPAFjKA/D3RwrfMD3jM+okIoG6BUjqjrPr3jkAcA3++f9VZLnqqykxXyQKhsMQjc5qQL/YE7TCOMWIahZTAbkjVQcVMBor3rkAmRwGHrNfwB4U9KoAyI7QUndcgL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 09:27:44AM +0200, David Hildenbrand (Arm) wrote:
> On 4/1/26 00:24, Stanislav Kinsburskii wrote:
> > Add support for userfaultfd-enabled VMAs to the HMM framework.
> > 
> > Extract fault handling logic into hmm_handle_mm_fault() to handle both
> > regular and userfaultfd-backed mappings. The implementation follows
> > fixup_user_fault() for handling VM_FAULT_RETRY and VM_FAULT_COMPLETED, with
> > a key difference: instead of retrying or moving forward respectively,
> > return -EBUSY after reacquiring mmap_read_lock. Since the lock was
> > released, the VMA could have changed, so defer retry logic to the caller.
> > 
> > This approach is inefficient for userfaultfd-backed VMAs, as HMM can only
> > populate one page at a time, but keeps the framework simple by avoiding
> > complex retry logic within HMM itself.
> > 
> > Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
> > ---
> >  mm/hmm.c |   40 ++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 36 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/hmm.c b/mm/hmm.c
> > index f6c4ddff4bd6..d04d68e21473 100644
> > --- a/mm/hmm.c
> > +++ b/mm/hmm.c
> > @@ -59,6 +59,35 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
> >  	return 0;
> >  }
> >  
> > +static int hmm_handle_mm_fault(struct vm_area_struct *vma,
> > +			       unsigned long addr,
> > +			       unsigned int fault_flags)
> > +{
> > +	int ret;
> > +
> > +	if (userfaultfd_missing(vma)) {
> > +		struct mm_struct *mm = vma->vm_mm;
> > +
> > +		fault_flags |= FAULT_FLAG_ALLOW_RETRY |
> > +			       FAULT_FLAG_USER;
> > +
> > +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
> > +
> > +		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
> > +			mmap_read_lock(mm);
> > +			return -EBUSY;
> > +		}
> > +
> > +		if (ret & VM_FAULT_ERROR)
> > +			return vm_fault_to_errno(ret, 0);
> > +	} else {
> > +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
> > +		if (ret & VM_FAULT_ERROR)
> > +			return vm_fault_to_errno(ret, 0);
> > +	}
> 
> I'm surprised that there is userfaultfd_missing() logic required here at
> all.
> 
> What prevents us from always calling handle_mm_fault() in a way +
> handling return values, such that we will just do the right thing
> independent of userfaultfd_missing()?
> 

Essentially, the main issue with the current HMM framework is that
handle_mm_fault() with FAULT_FLAG_ALLOW_RETRY (needed for userfaultfd)
can drop the mm lock. The framework does not expect or support that yet.
That is why I had to add the branching.

The worst part is that handle_mm_fault() can unlock via
mm_read_unlock(), while svm_range_restore_work() takes the mm write
lock and this RFC patch doesn't address this problem.

The main question where I’d like feedback is: should userfaultfd be
supported in the HMM framework at all, given the complexity around
unlocking and retry handling (similar to other gup helpers) or should
this complexity be offloaded to the caller side?

If it should be suported, then I see two ways to implement this:

1. Introduce a new HMM_NEED_USER_FAULT flag to tell the framework that
   the caller needs userfaultfd support, and extend the framework
   accordingly. This is not intrusive to existing code. But if we want lazy
   migration for GPU state in the future (and we likely do), GPU drivers
   will have to be updated to set this flag later. The only real user of
   this feature right now is the MSHV driver and I'd extend it to set
   this flag right away and leave GPU HMM users for later.

2. Add retry logic to hmm_handle_mm_fault() to handle VM_FAULT_RETRY and
   VM_FAULT_COMPLETED, as required for userfaultfd support. This would be
   transparent to users. But it would require significant changes: mm
   relocking, VMA lookup, and other parts. Also, before doing that, the
   kfd_svm driver would need to be changed to downgrade the mm lock to
   read.

Thanks,
Stanislav

> -- 
> Cheers,
> 
> David

