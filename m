Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56E2ACD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0A06B008A; Tue, 12 May 2026 02:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760AA6B0092; Tue, 12 May 2026 02:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F0E6B0093; Tue, 12 May 2026 02:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6516B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:51:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD5A21A0386
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:51:56 +0000 (UTC)
X-FDA: 84757847832.22.5736B36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F62814000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:51:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iy9X4nJL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778568715; a=rsa-sha256;
	cv=none;
	b=w9YtMQAGKo02wcPtLLrHOXCpqrV+XL9AP+TnctugMj1fJq7MetzJu5dC7p6mQKDwOKdJFO
	vI/wy3W7/wsLL4lwTxkRt4ZWwjnk0jUMBA9Hbe5Et32r4jLGhTmwsBx7AN71P9B2jEfYAU
	DLEyeNgVVUwZvpN+g77GKC5dWbKFqjY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iy9X4nJL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778568715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nts3d11hQEbWfK9I61sLETdJHahMN5gMF0KYY0lf5cQ=;
	b=Sd9tIsgl0QKJetkiUH21FWd4ncOhNBGlh9TGKvAcTvHMhU3aOFqiWUptD0M920adGslK/1
	HH0Ql/lfBxBo5Clp3o3cCvqgZ03VULjPhIriyc5V1blxnMM5HkcZGvP27LwSjaaB89cnyT
	+6vJ4IwpO+ZL76XWsSn2rqy2+5T+F98=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CAFC438DA;
	Tue, 12 May 2026 06:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BACC2BCB0;
	Tue, 12 May 2026 06:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778568714;
	bh=JrQbMHAIUgObA1+mKB9cmwyGVWli0GV/3xeXEfKec+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iy9X4nJLqbWsnvDt8maKE5p+Nu099G37eshBismCInFuhZUp0yS0mHJRGNOCYas3Z
	 Ptisd0du9040+8gjOTnEODmTYnmAgnmQR2ks9AC63/6/+Cx5tWjISj+mj4QDivKrWP
	 eiAExqCh7de66jSYTZAAcA2sff0U9HMTGo1yLPIZJRtEoBpeKwJA2DRVWe8+GkJuzl
	 KZZ4pqd6K+LF8Yc7wqZ0/SWrEW6flO9Gw7x5jg/bnfAthyENKsc4+9CVAk9CxbHBel
	 CYfiaFBj3tSQNgvexfXGwBg9CQjLGmUFhZcDMuS5hpWrRf3mFLvbVMoACa2QMBSAPe
	 rQf21poTG03oA==
Date: Tue, 12 May 2026 09:51:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] kho: return virtual address of mem_map
Message-ID: <agLOAtdL0rXL1HJ2@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-12-pratyush@kernel.org>
 <agHHzJS7bLPHk1GJ@kernel.org>
 <2vxza4u5c2oq.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxza4u5c2oq.fsf@kernel.org>
X-Stat-Signature: n8gaj3qwc3gznthfrozp5rmb1k7cpbhc
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F62814000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1778568714-50399
X-HE-Meta: U2FsdGVkX1/z3ED9J6BgyM7B+jtTGHlYme8WPTh5HWoByfKJhd1sVOLjHTqkSvQBHAvztS2EP05wKg2OET7Rtk6pfykkOSwuY7nvoHksK7NyxIbvqniYb3QzJL/GNo6ky0issPSWB+lCQ+cl3A9i1ir9nPuATNiZKxM3xJZLfSD9HsVXb5Vct/VAd180blkeO60t/6cSLnvYVVVxwQCz8HSBAMkgSMRERxRsiB87VROFqLJfFKdNtqZ6QuhgHfjiIbC60/7AbG1U9T2bMPUPZhkeFYFmUDrH0flhCbpHMgmcDbtwhi93TUpvCVxsW9alViu0dDM1paIuOOPU386lX8nBp5xcwcz/DaTaIpK/rzp2Cf3q2ViAAEwexVMWb5o/PxcemDnX9f9wk+2qwXCEhtu7YED4R7gGcGsr3MMBb0TKw9MUnth9jOVKj/MC7cIGiAa7AWcGkpJay+HzVFRJxZiLqK/iUDgqm16E7zFrxNJwnLuR5lsnOg/8nhwCquCUdthElyqdLb8PIPpWmEDjb12sUjaQIxJTi+JbwtW3itpqw0VX4drKdusUbMEFFJzdSwqWb9dDG0awRS3QN9uddosrOIN92NGSw95eQx/B0Wua+RlcxJg6YNp+9xpwc9SnFmGvZZciOLeIQcYipIIq4l3IGGU6CzBBzwTLH4IhjujrvkfGWbNugSB/gwn0sng+bszNG2N1VecyvM14tFnhBy7hL3aBFv1pXWC/LFPtXAbrsGnahhr+nwyiYPUjZT33vGJgpYWFJ20uoYSgkBGW55qAwqx6Gsdvo+DiL+BBs2T0L4tNwJRjsqk4Fw60ZWoA5spfW0dhs1GIrExRL97DrxuXyub4a+l2aGNxY2FxJ0f9r2CBBGJOgVO1pfcS4/fp5bLRZZHXjQcvu2DA+o4KmPF3PqAwCV55Q55w5mHz8smDjx8ZCvJh/RVOYBpgBJqsQboxBvFEtlxGqqbsP+p
 01IjgXuZ
 n7/0RtAmiBqACmF6UmdHd3SHI31owEo6qRrMeJ0BtOJ9uDV2FvBdZ1GmLazZc1zXMhG64l+4CUPqXHuk7FOmGG2DyNDKvW/bPruXaqmrpkSxV/bpwmxRkdk5E1oAnvxehqaYJms9PJiK989IB5apdDhaDY4W4fn1PzZcMcRspYNLvsPtnx9XmW6S+98ENxhR0JyGK3jIcg8X5wIBd2H4jQD9wXoTQHEl4OY8tqZwuBkPCxubvmkiXVx0SjsruhBYVI7hK3aMkcoDxZCGSlhkp5ryAvcCG8Tw5rj8axiuPwxodcEJ1vWeEZJMtMWF8fF5473hTbrPvE6s7EOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 06:48:37PM +0200, Pratyush Yadav wrote:
> On Mon, May 11 2026, Mike Rapoport wrote:
> 
> > On Wed, Apr 29, 2026 at 03:39:13PM +0200, Pratyush Yadav wrote:
> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> >> 
> >> There are currently 3 callers of kho_get_mem_map_phys(). Two of them,
> >> kho_mem_retrieve() and kho_extend_scratch() need the virtual address.
> >> The third, kho_populate() doesn't care. Make things simpler by
> >> directly returning the virtual address. Rename kho_get_mem_map_phys() to
> >> kho_get_mem_map() to accurately reflect what it returns.
> >
> > This should be moved earlier, before replacing open-coded get_mem_map()
> > with a call to kho_get_mem_map_phys().
> 
> Do you mean move it before patch 2 "kho: store incoming radix tree in
> kho_in"?

Yes.
 
> I can do that. I did it this way to show a clear need for this function,
> but I don't mind doing it as a preparatory step.

With the usual "it will be used in the upcoming changes" text in the log
it's fine :)
 
> >  
> >> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> >> ---
> >>  kernel/liveupdate/kexec_handover.c | 28 +++++++++++++++-------------
> >>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

