Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C37BACFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 11:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4386B0007; Sun, 30 Nov 2025 06:05:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8555F6B0008; Sun, 30 Nov 2025 06:05:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76B8E6B000A; Sun, 30 Nov 2025 06:05:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6575D6B0007
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 06:05:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F1A4A513D9
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:05:17 +0000 (UTC)
X-FDA: 84166991874.24.8E1593F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 50A741C0006
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:05:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BTGISrlJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764500716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXzDtQHq1QmYkxZjR/2BVH+fGh10lNCKERVT70PZXc8=;
	b=wUE+btLRhoA1VNN6ziDD2cyHnCb008fB2AOUV6joRZHEs4JWG7s1sqDyiocxarQhfXhJQo
	fCbWwzn+ARZvyeUDslhy4eNhyj7jSTtA9G9M7iANbCwnrEqKchi+RAfvXAEoJqghfxZpKQ
	TiTNus5e9SGXLzNXkaBh3ONoJ4L9rfY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BTGISrlJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764500716; a=rsa-sha256;
	cv=none;
	b=GLnIT9PXsz1Jw+1biXg2xObj4OBgHvd0+hxWy89WYK0G4PByu6IpdFFmWUCmzdfZi3u1d4
	H9M3+OwewQSQD+tcOU3K/ugcVeezeaqdYROKHoEW+fWDswPqssa5jC5teHQhfAQ00VrP0V
	e4NAhYg4jgUOnimU6nm8lE1UYQk584A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14954404A2;
	Sun, 30 Nov 2025 11:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2718C4CEF8;
	Sun, 30 Nov 2025 11:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764500714;
	bh=WgF209hVGnuhzCWEOErtx6btmHGTsEcP7tri0M2RCX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BTGISrlJ0lGzN7zs3GC7hlj8AU+zkROh5RBFD2dy9dKebTpAxzlGMxMFOPBSIaPc4
	 m1iH9EYA5JkkCr+RLJKhgtF0R8Ku+BHjMP8sEulJDHVGYL1IWaZLxmBl4zHvYOE+Rv
	 1l50sLIlMgdXYqaVooXB3EhlUMY8VgKqKzlXy/kgHjnMhBjSfy1QatN6CaF4c5FlVf
	 viwMzE7w1Wvyo38nJ3Djrc+BfCyX8sJvB1wmqREVXwUigN0CpHRsby7Am+hiAbJS+A
	 8SqzUXKncccjYNK7DYX/ZjnZAs+cd/6Q4Nr5P7HSa50WSyTg0RIxQMgX4q01fmIFos
	 l4Hz5zEDcRLGA==
Date: Sun, 30 Nov 2025 13:05:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH v2 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
Message-ID: <aSwk4IGY7zdb0cwd@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-4-rppt@kernel.org>
 <aSYBrH_xfMfs6yDW@x1.local>
 <aSgzcpFP1qBda5ef@kernel.org>
 <aShb8J18BaRrsA-u@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aShb8J18BaRrsA-u@x1.local>
X-Rspam-User: 
X-Rspamd-Queue-Id: 50A741C0006
X-Rspamd-Server: rspam11
X-Stat-Signature: 97h9m96eaksnbh56rfi3eyi3wjr9wiy7
X-HE-Tag: 1764500716-258010
X-HE-Meta: U2FsdGVkX182yUNWzaAyzTKJuNiH/Fs8PHfCWbxSjfzhO3xX6IYMl7k009Me4pKKd3fS5rpUiufY1UUKVqN/WtYiEO3MCjiE4JXZTRuj0yc9eU0NogDwbvFBcCDDPsZ2DgROlESnrK+mfamhShcVH9cr3c1wC4gSgfaYLzbMzvFF2brvGe+3bItZ3HhI34e8mKhnVuoK8YIPga3yZDoUkjE70VwfDwugCFnk171+Mv6rptR6lDUW++gYGak1Qz5QI9AVH9+XyFteYapsmAEHE5tnnEosYPPSIbXPJecD+hRGDpfMGHrBUtFzOnpExiau3DqEmGZZFpvvj3usxrHMXHorBsywJUxjFphOZs6KeSKVUIL07zT6y0RRDxU5F2yxc7cpCKSSgvhOKmkAM7/DJSXdfH5WtCDCKYydBfvPbzMF91NJHUlhZ5NuXw9J9KcppQciTGT+zIlwtb+J48nOTukGgp1ROrfM4KsS0BIJ1cClEB6vuYQzpo3XblOOhv2vUzfxtO3ojWcKvxq/R2Qq0SJhtEK+2mUPX+SGBQtfDUOutTw1UEc/ZWUlO/jOzMbfhpwbJGT1OLmafyKmbzs+bh87mC5XaonxFSu06bDpwxNkSCbl5m/lR5xsdWDJPc4Yq3mjFiBAR0S4qnBqI0ZuMRKiesW7fNEXJEuvLF7tKD04fv65huvBFxBPs3vlSHeGZcIXtUdOjjhS1kSNMLWvAYd4yakMvqvWDizQG4NVu7x++YDQWze0LAp36IZTgSywIkwpRa4+FDvgOw6K24ZivhNdYnEeqAkWVEDjvGWhvn13FMywF9VLdypKkeQYjYbxNlARU2HcyqjnrGtm04NP5i4ewKLAy4bLkKprApVnB0nTSuVUMaKempLFJKUoEosFCOxao9daXM4l5S8MJfqmiy+m2FJm0JH8E69+dEWwXX57WR0nTMQ5bRsrLLnmRfV9OQ3i5PRXLC5oQ6nKlXG
 i8K8t6Cq
 /kS+u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 09:10:56AM -0500, Peter Xu wrote:
> On Thu, Nov 27, 2025 at 01:18:10PM +0200, Mike Rapoport wrote:
> > On Tue, Nov 25, 2025 at 02:21:16PM -0500, Peter Xu wrote:
> > > Hi, Mike,
> > > 
> > > On Tue, Nov 25, 2025 at 08:38:38PM +0200, Mike Rapoport wrote:
> > > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > > 
> > > > When a VMA is registered with userfaulfd in minor mode, its ->fault()
> > > > method should check if a folio exists in the page cache and if yes
> > > > ->fault() should call handle_userfault(VM_UFFD_MISSING).
> > > 
> > > s/MISSING/MINOR/
> > 
> > Thanks, fixed. 
> > 
> > > > new VM_FAULT_UFFD_MINOR there instead.
> > > 
> > > Personally I'd keep the fault path as simple as possible, because that's
> > > the more frequently used path (rather than when userfaultfd is armed). I
> > > also see it slightly a pity that even with flags introduced, it only solves
> > > the MINOR problem, not MISSING.
> > 
> > With David's suggestion the likely path remains unchanged.
> 
> It is not about the likely, it's about introducing flags into core path
> that makes the core path harder to follow, when it's not strictly required.
 
	ret = vma->vm_ops->fault(vmf);
	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
			    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR))) {
		if (ret & VM_FAULT_UFFD_MINOR)
			return handle_userfault(vmf, VM_UFFD_MINOR);
		return ret;
	}

isn't hard to follow and it's cleaner than adding EXPORT_SYMBOL that is not
strictly required.

> Meanwhile, personally I'm also not sure if we should have "unlikely" here..
> My gut feeling is in reality we will only have two major use cases:
> 
>   (a) when userfaultfd minor isn't in the picture
> 
>   (b) when userfaultfd minor registered and actively being used (e.g. in a
>       postcopy process)
> 
> Then without likely, IIUC the hardware should optimize path selected hence
> both a+b performs almost equally well.

unlikely() adds a branch that hardware will predict correctly if
UFFD_MINOR is actively used.

But even misspredicted branch is nothing compared to putting a task on a
wait queue and waiting for userspace to react to the fault notification
before handle_userfault() returns the control to the fault handler.
 
> Just to mention, if we want, I think we have at least one more option to do
> the same thing, but without even introducing a new flag to ->fault()
> retval.
> 
> That is, when we have get_folio() around, we can essentially do two faults
> in sequence, one lighter then the real one, only for minor vmas, something
> like (I didn't think deeper, so only a rough idea shown):
> 
> __do_fault():
>   if (uffd_minor(vma)) {
>     ...
>     folio = vma->get_folio(...);
>     if (folio)
>        return handle_userfault(vmf, VM_UFFD_MINOR);
>     // fallthrough, which imply a cache miss
>   }
>   ret = vma->vm_ops->fault(vmf);

That's something to consider for the future, especially if we'd be able to
pull out MISSING handling as well from ->fault() handlers.

> Thanks,
> -- 
> Peter Xu

-- 
Sincerely yours,
Mike.

