Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB340C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 18:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF5E6B00B9; Wed, 22 Jul 2026 14:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0326B00BA; Wed, 22 Jul 2026 14:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8520D6B00BB; Wed, 22 Jul 2026 14:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5392E6B00B9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:52:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C285F1C0270
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:52:44 +0000 (UTC)
X-FDA: 85017309048.19.A1539AF
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id E38FDC0007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:52:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n0E2j3J1;
	spf=pass (imf28.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784746362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uym772qkEh9LOk/iL6aKk1xWDH0j1Tlr0rPbsmQanS4=;
	b=KtfL1pQVVWaLfDQiJuUGNjzedQZHrHYYpaL7qYSDs6Z2Rt3g3uqM3eTyez0lvDSrBbm0qZ
	UR3vBa1Vvny+buuiumaMY4ceWW0OwxHIi+HfR/ZuJtvN90f3Omb4dUJdzXYd+fOKoKmvp2
	kk4tYHvpHn1SfhlWgDiUMAXunyX/kME=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784746362;
	b=WgLBPek/s8og7fKc5A+2LXTwsj6ctPArPtnNMZWwFODA/UlVItTgp26v5dEKrMscGTZ9fT
	gwvOLNroW/7wHqD66lpPa/9vh1k+1orLCyBhzNybu+pz7XrbgWaGveN2gfADVOL88D6Tfa
	Cnv+U963lIihBzCNepOXC5sUylRpfhA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n0E2j3J1;
	spf=pass (imf28.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2caea3f742bso154510455ad.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784746362; x=1785351162; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Uym772qkEh9LOk/iL6aKk1xWDH0j1Tlr0rPbsmQanS4=;
        b=n0E2j3J1b9cIyjXeurQAsRs/EWk/E7qaThf6tvmcv2OPc0Mnmpg/DT4Pd37MBVh0Gx
         XP5VgZkHFqT/F1CEJ/flzOohek9y+FmIrQvbArG4AclwlTCzMBE+gVV8pOSQOlKOCkEc
         Do5B8PUPIDLEKPygNQGfbZpqYBnV0oVj/FolNN7thMCUrPpzHSRbsjB8vkkGYxDUY+Nl
         go/z/tg7Z5cFAc1rHO4fP6gvikpNhe0jw1f6uNC4+kBu2XJDcMK7AlYSRRjfOiBI42sx
         Vi4wsGvZ942NiHUaKa6BN6AJznrWXi03DglylCHoQakBzzNzPJfLnic1cF68NvmVPJ5F
         zzpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746362; x=1785351162;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uym772qkEh9LOk/iL6aKk1xWDH0j1Tlr0rPbsmQanS4=;
        b=G/hmH323U7J/pHJNS/C7U+IkZypQUd/BzH0Nf765+HMlQD4m6zDGRvQHrWVi6kbxUr
         pYIVAfzTeOo165ZIi6TjahPl7yL3fnYTZayN+63gaW++CexTYyTYP8P/p64hd4gjSwUO
         SMgkgCeKrFZH55QJc9A2yEL967vc5MWq/jIr4bnmzwrKSZJKipLFlUFlJRK6hJWnfQyg
         gxDGgA0VqN/RX6/uGuR88rvRUYbllPJ2/T1KUAyNycwStHoZurjb97ZE1bibUbDZCBbg
         VrdQ4FcM4pNK/mS0VYzRZ4lF6ts+tVtfLm8Nf+XKUfAt2HRQIlWnza7QHPYmcUeQEGXL
         sbmg==
X-Forwarded-Encrypted: i=1; AHgh+Rpy3boxyY0rnnk7hnByRFFmoQYDwAdF1nP5MJjf29HddbsY/dLdV74YZUSSgIwYtMfOyWbtoyAjVQ==@kvack.org
X-Gm-Message-State: AOJu0Yxar+Cj49ygR07Paxf21kYxuGdTNb3bBHUDSZCklpmddO3ZFGjJ
	K5BJNF/hJmIzbEL0yJe1M56qY/j5D80CkBOTn7NyEJG/oqSN2iRv12Ax
X-Gm-Gg: AR+sD12zswLl1AcqyiS2u90Vxta7c1tmXwaAjGwdIa8QPL3W02i05vLLsaB8YgCfl+Q
	aa2ZrQxRW/GTJbGiwnTYWhfzi5bWZfHNMW6eY45Be5Ge/WHjbDYLnq3lKiK5Rzofx5NEUNw6Nzt
	q7vjWhizLGRhX5Qhs1uH01KGCyWOiYE+hUhgsDgbxoHxCCUy6nwUuG5Sh/iinpgjOEavW9rGvP9
	pENPxjHkG48bklzfzKzWw3UazcQC6ZG+HwyteIXmKZp1bFOD3xY/OqDGOsA25S0pm8Bcw/+jOHe
	uYDrlP4RliEDZA0YnUIRYXNugs8ANEXkmzKBuyUkyVTfE50UfPaxMiB4a2b5++GF9KygEAx1xWF
	7uPKnn97M8kQxu90QnlPl9EaA4OnXk+bkzi4ChpPX1K7za7bcQ4CH4JdG1SrlBaJBSh++I5pGBX
	gTzYelqxp9aZEtd3t2eIGi45Gz/psM5Vg1PJvQfKiQkQeKxyD3JgAFsAE=
X-Received: by 2002:a17:902:da8b:b0:2cc:7e4a:bcc5 with SMTP id d9443c01a7336-2cfa71aa7demr1018275ad.32.1784746361700;
        Wed, 22 Jul 2026 11:52:41 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efde5cfsm19378335ad.31.2026.07.22.11.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:52:41 -0700 (PDT)
Date: Wed, 22 Jul 2026 11:52:38 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, jgg@ziepe.ca,
	kees@kernel.org, kys@microsoft.com, leon@kernel.org,
	liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
	longli@microsoft.com, lyude@redhat.com,
	maarten.lankhorst@linux.intel.com, mamin506@gmail.com,
	mhocko@suse.com, mripard@kernel.org, nouveau@lists.freedesktop.org,
	ogabbay@kernel.org, oleg@redhat.com, rppt@kernel.org,
	shuah@kernel.org, simona@ffwll.ch, skhan@linuxfoundation.org,
	surenb@google.com, tzimmermann@suse.de, vbabka@kernel.org,
	wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v9 8/8] drm/gpusvm: Use
 hmm_range_fault_unlocked_timeout() for range faults
Message-ID: <amERdq2X5l5vHfJo@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
 <178413941236.1155966.14485211391150425997.stgit@skinsburskii>
 <al7CGPdJGM+asOFK@gsse-cloud1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al7CGPdJGM+asOFK@gsse-cloud1.jf.intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E38FDC0007
X-Stat-Signature: 5k5pjm8n8zmsxggj8jjdjf3mr9ejr5ct
X-HE-Tag: 1784746362-867128
X-HE-Meta: U2FsdGVkX1+F0DdQiytVqYExt85q1tXqAMenPhiLru4cE4+CeE5arpyGl0LXffvErw5OphWv4Xr4SB/x87TAOAqMp9cj0hw+7ap2XLfzYC7VJv9eVhia4WzHp1Avg069Ds1FHUyG7h/1lWG3Qxq5rO8TkNdn9cCsx+QVCnSZNICX8bqZcVrpN+DSD5BZNGqsTjE9yz1fXm7HASAeXb8Daw4dlT2Hdk2UavpVzS7flGEk2wdriWwA13OsWp3vrOsmuztala//IPtlAG6YyY2axNJw7OZA8mlM3b0AWmoL3x2XGPeY+HgVnAykl1rtbvwts09psAYE3JkpDWCEBug7KFW2KcwIGH4e3H3F9C9MsPpczMuNvQFOtL9o4iKUw0C+gQqLcN4j8RguUqOEAxEcbx3JJJcHPNyu4IZrWLFtYTcLOuSnofAyUf86Z6y3Zppw3i8lvanYFqwoVP7SH9t0oajBLoY9l8J0Rqe5bzAJ5VETAQF7jJVoAQjVLAGoFIs5EE7bZDsV0atK+VBz1s7npuiTR4aMz40ItY2pNe3iPIwzZOq2UCA+v3PN7lyjACbdDkQmTujEzCVAyvW3gqbiDVcsVBUhOnCBS5xg9VrMLnvell5y+gLcc0KsnClWUggKnndMUuT+57BSh4EEwd/1/fOp58sMyXJgsMscj+r8Q5GmYc8ILGH+8qWYMurCPneumovx3E4k4/XKG0FM1cZrCTY9he1UCIDtn+dFAXqPLko5YwOr4D6QNP7HDZCpKRVrRj3AaFZu3aQBqCHsfbGYHNgur6q5oYE8FRGlFPhU0ov+IRcm2eT5t7ZVMrel7PeoDzbfStmnYygqnn/6sH+UNy73JKKt6qFI6zHQ9MDHBqQv6O3JrGS8TXx7a8lcp2TT1LSWx7fi7GDWZdTISHGtGBVsFbtzIbUJ+3wBjDssaFt+6+1KVzRi9DbyE368Ma+6ecPo3VqrHsVNxqJKE6K
 AE4zIXF7
 xyrZK5ZCM7GT6X5VnBRKoBCNnJK9toBOmg5XuY33ZvyqPVG+4JWqFQmtq9pDrBC2tAFG9MlK5FjustbOg9k0uyWoIxjDvnG7/LdAp++cZjnZm1qzqYhGoBMcXjLnePfMdZQAz4UszM6i7UtXFcHrP8NT8JGCt5Bxw//lrwBHNegd/okvNyjqizqqQPdu/rbhpiw8DsxKPuNQtK1T1bbf+VcCQyRnwoHHygn2UWUxfoL28jfT98aGtGdP7QEuQ2AGw6WoI5rsjddp5pDUF5gV0stCpLnAMHj71Lo+EEH3XKCvbauFZ/4Vr8tjyqdAsobN7sAPfecvQw2RUTxZbYJpEVjP6g8SxN2P9sl6KgzMV6m6gPxvJVP7icOpqtevBC2TdFdCsrwGsAkmGWGAnjwvRDh3Gf0WT7a7hKOWX29YfOCm9weJJVIXIKmUg4k3Bzf7RMTrbzlBjRLx0BddgCP7rzU2I3WwPcx0HbXyRVYFicRO1V1L1RylOXZh8mRdj4tbAs/OQ5ADsAfYleq36eKRY79nVmwojKJjpNppbxUgmE+qG9J0KBAUY/jWY3kj+q1ZGf9nY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 05:49:28PM -0700, Matthew Brost wrote:
> On Wed, Jul 15, 2026 at 11:16:52AM -0700, Stanislav Kinsburskii wrote:
> > Several GPU SVM paths take mmap_read_lock() only to call hmm_range_fault()
> > and open-code mmu interval sequence setup before each HMM walk. They also
> > retry -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires.
> > 
> > Use hmm_range_fault_unlocked_timeout() for those faults. The HMM helper now
> > owns mmap_lock acquisition and refreshes range->notifier_seq for its
> > internal retries, while GPU SVM keeps its existing driver-lock validation
> > with mmu_interval_read_retry() after a successful fault.
> > 
> > Pass HMM_RANGE_DEFAULT_TIMEOUT as the helper retry budget for each HMM
> > fault attempt. This scopes the timeout to repeated HMM notifier retries
> > while preserving the outer retry loops that restart when the interval is
> > invalidated before GPU SVM updates or consumes the mapping state.
> > 
> 
> This part doesn't seem right for get_pages(), see below.
> 
> > Leave drm_gpusvm_check_pages() on hmm_range_fault() because that path is
> > called with the mmap lock already held by its caller.
> > 
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> > ---
> >  drivers/gpu/drm/drm_gpusvm.c |   61 +++++-------------------------------------
> >  1 file changed, 7 insertions(+), 54 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
> > index 958cb605aedd..de5bbfe58ee9 100644
> > --- a/drivers/gpu/drm/drm_gpusvm.c
> > +++ b/drivers/gpu/drm/drm_gpusvm.c
> > @@ -773,8 +773,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
> >  		.end = end,
> >  		.dev_private_owner = dev_private_owner,
> >  	};
> > -	unsigned long timeout =
> > -		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> > +	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> >  	enum drm_gpusvm_scan_result state = DRM_GPUSVM_SCAN_UNPOPULATED, new_state;
> >  	unsigned long *pfns;
> >  	unsigned long npages = npages_in_range(start, end);
> > @@ -788,22 +787,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
> >  	hmm_range.hmm_pfns = pfns;
> >  
> >  retry:
> > -	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
> > -	mmap_read_lock(range->gpusvm->mm);
> > -
> > -	while (true) {
> > -		err = hmm_range_fault(&hmm_range);
> > -		if (err == -EBUSY) {
> > -			if (time_after(jiffies, timeout))
> > -				break;
> > -
> > -			hmm_range.notifier_seq =
> > -				mmu_interval_read_begin(notifier);
> > -			continue;
> > -		}
> > -		break;
> > -	}
> > -	mmap_read_unlock(range->gpusvm->mm);
> > +	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
> >  	if (err)
> >  		goto err_free;
> >  
> > @@ -1406,8 +1390,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
> >  		.dev_private_owner = ctx->device_private_page_owner,
> >  	};
> >  	void *zdd;
> > -	unsigned long timeout =
> > -		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> > +	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> >  	unsigned long i, j;
> >  	unsigned long npages = npages_in_range(pages_start, pages_end);
> >  	unsigned long num_dma_mapped;
> > @@ -1422,9 +1405,6 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
> >  	struct dma_iova_state *state = &svm_pages->state;
> >  
> >  retry:
> > -	if (time_after(jiffies, timeout))
> > -		return -EBUSY;
> > -
> 
> I think that by deleting the code above, you have changed this function's
> semantics by removing the hard cap of HMM_RANGE_DEFAULT_TIMEOUT. This
> code was added because, on some non-production platforms, the timing in
> this function could cause it to livelock.
> 
> Is there any reason this was remove aside from timeout variable not
> being a deadline now? You likely should add the deadline back in.
> 

Indeed, this one can be called from a kernel thread context as well.
I'll revert the change in the next revision.

Thanks,
Stanislav


> Matt
> 
> >  	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
> >  	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
> >  		goto set_seqno;
> > @@ -1439,21 +1419,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
> >  	}
> >  
> >  	hmm_range.hmm_pfns = pfns;
> > -	while (true) {
> > -		mmap_read_lock(mm);
> > -		err = hmm_range_fault(&hmm_range);
> > -		mmap_read_unlock(mm);
> > -
> > -		if (err == -EBUSY) {
> > -			if (time_after(jiffies, timeout))
> > -				break;
> > -
> > -			hmm_range.notifier_seq =
> > -				mmu_interval_read_begin(notifier);
> > -			continue;
> > -		}
> > -		break;
> > -	}
> > +	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
> >  	mmput(mm);
> >  	if (err)
> >  		goto err_free;
> > @@ -1720,8 +1686,7 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
> >  		.end = drm_gpusvm_range_end(range),
> >  		.dev_private_owner = NULL,
> >  	};
> > -	unsigned long timeout =
> > -		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> > +	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> >  	unsigned long *pfns;
> >  	unsigned long npages = npages_in_range(drm_gpusvm_range_start(range),
> >  					       drm_gpusvm_range_end(range));
> > @@ -1736,24 +1701,12 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
> >  		return -ENOMEM;
> >  
> >  	hmm_range.hmm_pfns = pfns;
> > -	while (!time_after(jiffies, timeout)) {
> > -		hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
> > -		if (time_after(jiffies, timeout)) {
> > -			err = -ETIME;
> > -			break;
> > -		}
> > -
> > -		mmap_read_lock(mm);
> > -		err = hmm_range_fault(&hmm_range);
> > -		mmap_read_unlock(mm);
> > -		if (err != -EBUSY)
> > -			break;
> > -	}
> > +	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
> >  
> >  	kvfree(pfns);
> >  	mmput(mm);
> >  
> > -	return err;
> > +	return err == -EBUSY ? -ETIME : err;
> >  }
> >  EXPORT_SYMBOL_GPL(drm_gpusvm_range_evict);
> >  
> > 
> > 

