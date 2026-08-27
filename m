Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052B1C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1EC6B008A; Thu, 27 Aug 2026 05:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B932D6B0092; Thu, 27 Aug 2026 05:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8ED6B009B; Thu, 27 Aug 2026 05:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FEC16B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:09:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2580160356
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:09:29 +0000 (UTC)
X-FDA: 85146476058.05.055DBAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 38B34140006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:09:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZFiuJ2aK;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787821768;
	b=K0Ap+9VUwXwxhA2IrKo0cpbC+lYrkkBUxnLVjITDbdMFV8QtQwhlco4mSaui2LqqBRbl6o
	bAabu2RipmpQXxdJKrHIABDUmZ7Upq4CsA0Mnas2hFDe1FfpsQ8LvuJqBAS5REWYtoLkCg
	FzlP5vpRoLUxRsTi0GUXodwqwh6PQtg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZFiuJ2aK;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787821768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RpGiMBMHM5Gzcxil2Rgh4TexxSKnGvufNkrztx+joGU=;
	b=bjn3DabEp+45BCDzqmwVFm/fXFd8zlXe6goqeu/9MnwFPjpky/RNIBKAbeRtNWcBkaao8H
	Lk24q13B96kww+cm2KjGcHH8rrGf8kI6cjEEo0K8CGwrKLkoc4ROfdGsNGSTErZwx4hL/I
	UsLA00AwvQKQwRKTnIMxFxTOBqExHMU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1192600D0;
	Thu, 27 Aug 2026 09:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F71A1F000E9;
	Thu, 27 Aug 2026 09:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787821767;
	bh=RpGiMBMHM5Gzcxil2Rgh4TexxSKnGvufNkrztx+joGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZFiuJ2aKTkIPolcpnhdNN4ZOC0buG+VC/7mPcURAZVx/F9rT2gBbpwQJJXMWr4Nlm
	 1dgzM4NJthTfp3ZG7NLeYjCPkvVydK8hJGR/4IK8wGTlJzncBIIYNfAQLG/51lIvXC
	 WMPvsWYMUx4LbdLfjkLSrm0Mg7lcmXd/3bno4cSpOVcUV3xFXnsrjcBpI/S3A/Pk5T
	 DEI6NaSXhOUwM2JtYiy92dwxr9GQ0NxWs4OWexmA6ILGV6dkBoG25PiEh1voDngCNg
	 vcrw2JJZ9sFm7WbCEXq2CW/pdL8ShXEkZpNx2fo17ugyLZqOTIj21OCni6H+Xf2fb/
	 h1pUsqwaSmLFw==
Date: Thu, 27 Aug 2026 12:09:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] userfaultfd: decouple fault reason from VMA flags
Message-ID: <ao_-uZrrsVX9lzbz@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
 <5bb86e34-6196-4b50-b553-be2ff7c1fa32@kernel.org>
 <ao_sCh5zP0IC9H2S@kernel.org>
 <e8aaddde-0a07-4197-9874-5ca0ea8af43f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8aaddde-0a07-4197-9874-5ca0ea8af43f@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 38B34140006
X-Stat-Signature: jiex5s6xcxtkuyf3f5fosd7cdfue31s8
X-Rspam-User: 
X-HE-Tag: 1787821768-183599
X-HE-Meta: U2FsdGVkX19mEYiKD8Tv1kt/3u5yoHZXzq6HQALYR5BWd2rwQ49dShGpQHLqvYUvY4vD4gCMUMvo6OSJhHWh8Pklt0m/IYaD3tfqkelo7CE78qNAQflbRu2N6SI1PzvWzJHog4gXDpLbNKgokskdif0g4FOyrb4GFGGK4U+eAl7QGWLdToRt46Qcpd3oa7rfCx8aE6JuNER1Zw5Br5Khpp5GXhwfiNcEsfNhDXtzoES/76/h443kRH+2YEI8JT7DWZ6RiuwI/AU1Re0f/eOPex9k5LxPccorYDrvTP9SfRJ1wMlM7rlcrlRHczHCVi6W9HT2HQ5yZ/9TPTRtF5tbhw1OZQMq03wxHeto4VFjnpLcwrp5JifXAx9/SQn64Yll1R25FhjQUj6qw5zrFoEc+vcAtJKKboxx9X/zWbhqQEhUKClvwLQ2/3uk0jHokXxFnIzA56curzcK/bHpp60p1bsr8KMm8uxfh9eGMmb5BHDTaEMLT/wupbHCrGdR8rYeKh2UtkwUTLSodjhnSNvoRX0jjltBqG20wub4T5myUwTvVoFwxBN7saBcPpPsIcCzZpLj73oGouDow3rPCZ39YVBV261rRkhp3t9Mm4YS4suz8IK/XTFbkGAVReYYeouJyOAdc5h0WUf7ev4xZkfd/FQH5YvVC8p3DZyIsMpdkN5WekMa5TanTYkILx9Ws6wsyRDqBAEo+qYIHOIqTZqz0gVKmQGgH2NyIVhtoaXeDZzU18w4bcNtKr7i0StAG/EeBEIoFcbraYkT6yKZ+gbJMxQ8n6spl2G+Ijs0Sb0a4c0AJ3kyHtwnvxRk72UVaJ5f+us6A9K1sMgzaR8nVaq3NGDKl78hSpFer9iTygptu92FgxAmAPYIgqmel0J5l11jMCOvfR5pvV4zWkLf1q60LYT28JUc0tysePp6t5K8pK3WlbR2V6YOAUOnt6af9B8NB2JaXFNkTKc5LZnEMQ1
 tpqb1W58
 Pw8Lppo4nC8/sQw0O5W86AXFCyDC5/Da1eSIB27RDYKWxeEOHFus4e5teyDWB50me+55ayzf1Kh3Fmce10NDkvSuUzWFYabnwmfOASlzEv+nXijFUAJkT7qY29LRkeV8JTyNK9DUVb7XXF0WGUrS2YwwbxcbgF3XosH+NnN5odDj+nEqeC/G05DURg/D5kwm2UjkQuuL1Zk0DofcfEJbjB1Xxrdu0WINyyVMNGiseZyjQ67qY/pEWM1Udxy7U2YOhbriZf67QF4t30gHPhsjjT2ubkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 10:10:24AM +0200, David Hildenbrand (Arm) wrote:
> On 8/27/26 09:49, Mike Rapoport wrote:
> > On Mon, Aug 24, 2026 at 04:46:14PM +0200, David Hildenbrand (Arm) wrote:
> >> On 8/23/26 14:17, Mike Rapoport (Microsoft) wrote:
> >>> Introduce enum uffd_reason to define reasons for user faults rather than
> >>> overload VM_UFFD_* VMA flags for that.
> >>>
> >>> Using a dedicated enum makes the code clearer and decoupling the fault
> >>> reason from VMA flags clears the way for moving the uffd mode bits out
> >>> of VMA namespace.
> >>>
> >>> No functional change.
> >>>
> >>> Assisted-by: copilot:claude-opus-4.6
> >>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >>> ---
> >>>  include/linux/userfaultfd_k.h    | 16 ++++++++++++++--
> >>>  include/uapi/linux/userfaultfd.h |  6 +++---
> >>>  mm/huge_memory.c                 |  6 +++---
> >>>  mm/hugetlb.c                     | 10 +++++-----
> >>>  mm/memory.c                      | 10 +++++-----
> >>>  mm/shmem.c                       |  4 ++--
> >>>  mm/userfaultfd.c                 | 30 +++++++++++++++---------------
> >>>  7 files changed, 47 insertions(+), 35 deletions(-)
> >>>
> >>> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> >>> index 45355bdb4ec7..f401623f315d 100644
> >>> --- a/include/linux/userfaultfd_k.h
> >>> +++ b/include/linux/userfaultfd_k.h
> >>> @@ -9,6 +9,18 @@
> >>>  #ifndef _LINUX_USERFAULTFD_K_H
> >>>  #define _LINUX_USERFAULTFD_K_H
> >>>  
> >>> +#include <linux/bits.h>
> >>> +
> >>> +/* Fault reason #PF handler passes to handle_userfault() */
> >>> +enum uf_reason {
> >>
> >> Can we just call this "userfault_reason" or "uffd_reason" ? Maybe the latter is
> >> actually what we want?
> > 
> > userfault_reason sounds better to me.
> > 
> > It describes what kind of user fault we are handling and the 'fd' part has
> > nothing to do with it. 
> > We do use uffd as a short name for the subsystem, but still most if not all
> > userfaultfd "external" APIs use userfault_ prefix.
> > 
> > uf_ was an attempt to make it wee shorter :)
> 
> Yeah, I got that; while uffd is a known acronym, the uf_ not so much (and also I
> wouldn't suggest it to become a thing, lol :) )
> 
> I've been wondering for a while whether it really should be called
> 
> 	handle_userfault()
> 
> And not instead
> 
> 	handle_userfaultfd()

The 'fd' part here sounds really weird :)
 
> Or maybe even better
> 
> 	handle_uffd_fault()

That's somehow tautological, but maybe using uffd_ as prefix would make it
a "subsystem namespace", so tautology won't be as blunt:

	uffd_handle_fault()
 
> And then have
> 
> 	uffd_fault_reason

Could work, yes. No strong feelings between this one and userfault_reason.
 
> ... but just a thought.
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

