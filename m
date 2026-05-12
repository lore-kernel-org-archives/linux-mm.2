Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF68CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D492A6B009E; Tue, 12 May 2026 12:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9F56B00A1; Tue, 12 May 2026 12:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C101C6B00A2; Tue, 12 May 2026 12:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA0DC6B009E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:18:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2165EA054D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:18:51 +0000 (UTC)
X-FDA: 84759276462.30.6D380A5
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 426D4140017
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:18:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=KWQck597;
	spf=pass (imf09.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778602729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uf3CnoeoD1JaJ9/DXoxz1jb7GBmNLqY9irHzO+pPh0g=;
	b=0E1Yvt5VS03EwP2JNrVPno/yAopjem+lR253whK/j6Os4aLGKxecQHnoYKrfoPyHnQClhi
	TcLbMqZDTUDt/RWIU605rNwVWFEzDMxDgCQ6aUL+nDBRjvGftDGsl7vR7XPPzpsMw8KCZR
	zYWiVrb7QvoOHcIQ9jZdV8lXupBRtVU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=KWQck597;
	spf=pass (imf09.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778602729; a=rsa-sha256;
	cv=none;
	b=j1xfild88dSSyUH9TbsFLOpkvv7OiIsBcKLtz3b9ckkNxxs/iYcxz8Lvg39npKh4RkTm2H
	AB9/UhUQwL3dY4WYTi+6dTewVJRYgCmuHvwFQGEGFadds3wz4Hj7WRZAGDW96S9jmqssHl
	2IT1g3b4C+KK7nkwGjKyr+dFc/nUIpw=
Received: from skinsburskii.localdomain (c-98-225-44-182.hsd1.wa.comcast.net [98.225.44.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5B64120B7166;
	Tue, 12 May 2026 09:18:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5B64120B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1778602722;
	bh=Uf3CnoeoD1JaJ9/DXoxz1jb7GBmNLqY9irHzO+pPh0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KWQck597/eyja/NgCMAmkLC3+bWL5hWVU+Y66nu66N5UekfOjtVOB6GjKYNXVyVjD
	 ufyi56nCuI23ffrZ1mDNNNacGzY8zvU7I+bAkw7ZuMQgMgaNmaUNxKHaeWaIr2+dyr
	 J4TNJtiDGtT4mGb4Wzvblbe2M6QKyghCab8lT9Fk=
Date: Tue, 12 May 2026 09:18:42 -0700
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: kys@microsoft.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	decui@microsoft.com, haiyangz@microsoft.com, jgg@ziepe.ca,
	corbet@lwn.net, leon@kernel.org, longli@microsoft.com,
	ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, shuah@kernel.org,
	skhan@linuxfoundation.org, surenb@google.com, vbabka@kernel.org,
	wei.liu@kernel.org, linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm/hmm: Add hmm_range_fault_unlockable() for mmap
 lock-drop support
Message-ID: <agNS4llNtAHBkMA2@skinsburskii.localdomain>
References: <177759835313.221039.2807391868456411507.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
 <177759840859.221039.13065406062747296947.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
 <563bb216-c270-4711-adda-b91484af40dc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <563bb216-c270-4711-adda-b91484af40dc@kernel.org>
X-Stat-Signature: n15zp1f1xidymnwoydqnxfn7cyqe81ru
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 426D4140017
X-Rspam-User: 
X-HE-Tag: 1778602729-986392
X-HE-Meta: U2FsdGVkX1+frJeyBwPELFCpo1ASqzQ+VgoWCJotfPF5SJ+s3LvnRSrJypkDEJ/P3B0ZA6xoGg/pdj/CnLi3Ilh7fR96CRK5CbcBEqMxpF7Igq8PRbnn43WlBKY/NOezW1VpOi77d6iliczQdftsrS3Fe1+zvea3MGYWkX7gq5N51VlEiaqLT4uLoz5J1RdM3JNQYc2rKN3xADfW/JDrArLUPLxAlGQHxksGWRnMG0TVqsaKxR/mr9tOXJjr+rbpnWc7Urt4V+wNxkHV1xoDaqv+UvRzNh1WK607A+Xa3UoHM3En/h8HYTNiXykZ7nlTzeMh2YEG8ybV/OcDAkQ4NAfCpJ2kZKMVeiBXT0a1hMMkiNcditwlhqmDEfL6z+s3DOB03mpNfeWo+d+x06x/xTtwOKmEvsJ9xS6Kh3eav2e+yCYW47MH8fEYyOQIECI5B+NEwyHfkqaHL+l4RVK3PmAiTkv3zdPQgScpbaVlWw9hedqyOViJKvqLGUkX6KSk8mxvsWwBQCGzJ/Faa27xaUwXuTxHpR59fyTgSDIVQtdxpfFMYM6Qq3sK5Wv8JXom9rM13uvP3ubzdTz8R5O11Q6xXmAIzAHxCPV1pilhEHp3U5nNp0Fs44fjEzc0dSCZPG9GR3MweO7mQTuBFbL6MGfohXBGSXYEgsomNMYT0BkeBdsdTrMSm3vciD8ATAuVYbh3fEWX6Crc3t+4CuCnBCHRKS/mxtHHdwQ5Eoiol+T00kkrf2jEYX74fBnG0Hl65NdPR/vs7mgKUwHbfIyHgk6O/rqLBv4zdKmb+ECoBD9xZUkLL2+PiM5+yqvtkN4uFJO70ZSxozKLLxfC4oS1yhzJWdehCzXfgaoMiac89Hnm7L539F9OXDLguCyCQlNq5jZP3OtlQ1vXdXEXaJ2YOU2og2JnKKkK36N1A35cNI6R0NFDCZo75b5NavYwRgw6qAhUjBEbeGjk6qe+eLK
 zhqaA6WS
 OIlQHrFOvJK8FOk1KZKep7cYfLdKdqqj3LW0wDYJEaVOjXYJ5smCFn+qhPyrkOOwNjlMsPYOBqtgBBnZnTuLeEXCOtd+u36ixkEVKsKm67qKc5ybCJjzrzcq9lZmEN0vgjc5TD3f5q7MQp/StPyQGsZkLc3ez/T9963cBkY0gFyIhUPmbGNpiGRbqGaOseXi1N9F+I8CdK3+fjWcILH1SrTnBfKBBUDOIbZ5TrX0V2of6C/8mmrZS8jY6Cj+AOrX5XCwAMUhT860y9/9QfAxnlc4lUmvUZwMIFCRZ6fPRQqZQhLY+d1v5D2zD1j6Ke/bVUP9p8NW3WULMKxTMDvfHLSqQ/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 10:42:14AM +0200, David Hildenbrand (Arm) wrote:
> 
> > +	for (; addr < end; addr += PAGE_SIZE) {
> > +		vm_fault_t ret;
> > +
> > +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
> > +
> > +		if (ret & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)) {
> > +			/*
> > +			 * The mmap lock has been dropped by the fault handler.
> > +			 * Record the failing address and signal lock-drop to
> > +			 * the caller.
> > +			 */
> > +			*hmm_vma_walk->locked = 0;
> > +			hmm_vma_walk->last = addr;
> > +			return -EAGAIN;
> 
> 
> Okay, so we'll return straight from hmm_vma_fault() to
> hmm_vma_handle_pte()/hmm_vma_walk_pmd() -> walk_page_range() machinery.
> 
> Hopefully we don't refer to the MM/VMA on any path there? It would be nicer if
> the hmm_vma_fault() could be called by the caller of walk_page_range(), but
> that's tricky I guess, as hmm_vma_fault() consumes the walk structure and
> requires the vma in there.
> 

It looks like a caller can provide a post_vma callback in mm_walk_ops. I
missed that case here. This callback cannot be supported by this change.
I will update the patch.

> 
> Note: am I wrong, or is hmm_vma_fault() really always called with
> required_fault=true?
> 

No, hmm_pte_need_fault can return false.

> > +		}
> > +
> > +		if (ret & VM_FAULT_ERROR)
> >  			return -EFAULT;
> > +	}
> >  	return -EBUSY;
> >  }
> >  
> > @@ -566,6 +585,17 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned long hmask,
> >  	if (required_fault) {
> >  		int ret;
> >  
> > +		/*
> > +		 * Faulting hugetlb pages on the unlockable path is not
> > +		 * supported. The walk framework holds hugetlb_vma_lock_read
> > +		 * which must be dropped before handle_mm_fault, but if the
> > +		 * mmap lock is also dropped (VM_FAULT_RETRY), the vma may
> > +		 * be freed and the walk framework's unconditional unlock
> > +		 * becomes a use-after-free.
> > +		 */
> > +		if (hmm_vma_walk->locked)
> > +			return -EFAULT;
> 
> Just because it's unlockable doesn't mean that you must unlock. Can't this be
> kept working as is, just simulating here as if it would not be unlockable?
> 

I’m not sure how to implement this. The walk_page_range code expects the
hugetlb VMA to still be read-locked when we return from
hmm_vma_walk_hugetlb_entry. How can we guarantee that if the VMA might
be gone?

I added a note in the docs. Whoever tackles this will likely need to
either rework `walk_page_range` to handle the case where the VMA is
gone, or use a different approach.

Do you have any other suggestions on how to implement it?

Thanks,
Stanislav

> 
> -- 
> Cheers,
> 
> David

