Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C7A106F30F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A626E6B0005; Thu, 26 Mar 2026 05:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13096B0089; Thu, 26 Mar 2026 05:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94FFD6B008C; Thu, 26 Mar 2026 05:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 856AE6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:18:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60FC31B7F8A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:18:58 +0000 (UTC)
X-FDA: 84587664756.18.1CF6825
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A6ED610000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:18:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EGEvX/Tz";
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EGEvX/Tz";
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774516736; a=rsa-sha256;
	cv=none;
	b=tfYHKQsB/gJunASOKCmmLu0vuq+GnRLd562kizPVD2iFDAK6w0WmmhqBOnN1w4OoEaVKxx
	chcV97EdlAoIt/cxVmo08jRxsXCgjFcUG2N3p/6Rvapl2Z/4BnBbYHRxxpPYcfy4RnQbFV
	3u/PfpqrUR6bY1Iy1iawrTRZ/rHZN0Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774516736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17UQkAQxmaKfoR8W2GntqiMQ4KoFR3kHaBUv9RbbRUQ=;
	b=J9b9FYwkRdjqWnVV7DvMOYSRuPZtgAjMU6raMmSrZK/8Fnz17KRD8U0vfag3iWgnlP2+50
	ecBpNmn9vE9tgI3/fCdiijkqljmgpEQRVaP4vW1dTjy5JtNlmY7fKB8+wDhnD11JYtglwp
	OG50/JnxtkE67Ul/kt3XbprzWDElNHc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C835C418F7;
	Thu, 26 Mar 2026 09:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FB6C116C6;
	Thu, 26 Mar 2026 09:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774516735;
	bh=yUWBxeEHyviOPKRneK6j/gfx/J/uc8pAHvShiPb46kA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EGEvX/Tza/tjOvP+jwHZtAfsQ9i3c7zrE71IAVXMEBQFuXXBY8J8Q7ke9WuRoZPaA
	 Y+chvo99aGdYyVr/Ej6q7FyBK8u7WGGWRA7w0fOlldEtOkdpL64+VWh9BMNsNv3AvP
	 C24e0feiTo3fMQgLeEi0DEnVobzVj0a1HCmGQBIDe89k5m+My6w495OfsTJWLoTXTk
	 rW1jm4hUGy40vO8TEOhFBYjcPcB74lkZHpC2O6WO0jV8h/eZB2c+l21RdUfU2k8Ah1
	 Rs4/PMwca7YEl/l752V++FgB8s2oggoqcfw9t8psB+h6tVJgd7Iz5Q8Myq1/LinSjR
	 TSfqa9opHxHVg==
Date: Thu, 26 Mar 2026 09:18:53 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, 
	rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, 
	maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v5 0/6] Use killable vma write locking in most places
Message-ID: <44216135-ce6e-4c06-acf9-af09e224ddd8@lucifer.local>
References: <20260326080836.695207-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326080836.695207-1-surenb@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A6ED610000C
X-Stat-Signature: qrc3rtiniq6ujpifrh9646iwh15obt3n
X-Rspam-User: 
X-HE-Tag: 1774516736-241952
X-HE-Meta: U2FsdGVkX1/IaIhVIhU3mDnfXsavCaGcnazewKaj1RkrVS3Bfvt4UdGqW+75A6azOsNMqiQ2FgiMD7ieqDWyGOx0TXGyMqUbtJmqVCMlMzJGwoEWQr4+if8FuT6JQxmEdi9cZsBeGM6o0hpZouafThxc+A3vZCpDA0ZnSJEK7sdedYGIKqZHZ6uoj7aF2JJU8wcpdskLLVTscl+ZpCAFqpLR/8hW5F1GAWXnQrIySL2cVeim7odZeuF7fQVbRLy0ntl3RH9vJEVei0pJuD/u0ti6jo1Z44FJx09SxyBGsp1BRpcRpjfNfnJMr9d3kAyupxIEVOaG3di8PStjT/ORCWeuwQxqfxP01evhARtlRNILrKFLtswlezLhChjgd86VIVxDTOMLMMmGD/HpqeIM2tBzqOJFN2SqMt4XaZ4vQqkYAqTYzZdcfiTkxMnm6qTkU7VqpWOmTE7947Qc554Z2NNBXYvAwgAIXEJpCOnAiEGAzWb+HCocMgzv1i1spF4dbKPqT+IRWdSvmvpFQifB2B+h4rygfot6oweUouuUamDg0IyJEdMiUa6saFFk5MIu2CUGwjXHMjUhkDbAocx1dWzR3NnkgyeMBISEmeI85vISacjffdDFC0eiE7N9y6vXaX75ZlnFhwjSYLhJVjxFRUjqubUPxPo/IEcjjLam3m6K09QRpJbqyFcD9MeyfZ65Xv4VQ7KwlZYT7uDXCp/64GwEc3/hrxYfx+qF9TjYHyQZaDUjPLf6vG7ajBUdv0Woa4NI8m6xhaCPokT3HQmqG4dxP75IhwEjSfl2FJgSwZcPeUR8b0Llgq24qEubKKLlwtwwO0zHH7VY217vSRMiMxIXiKFJOx0UWSx2qRxQRYSYrZXPKrpDGL1vhH4exlQkkbKWwjfMKZ3SIoOFQ4T+M1X3PagFp/IOFYvn1Pz4CFh4Wavg25HarAt7J9BnYziBgz9WA1QvRJksFRzXuOH
 14ewixnk
 nxxDWIq90jhMP3ujREhqBWn6+y3g5tTvOxdSd73BGNa2PQ65d9mwxaALG/IGjvwUZsog7gAxz1WqGuFAakxhfr7db5p5mWv7JhszFEE/VUka6N0yrApKT7uVOGP1akJcwZLb2cAsJnraDA0cQ3jNyPn+sYkqkfGY/ftJ5ItdNMFGJ/6unEbwgIPVOthW1fYAgSLftWO7JEkvPf2eXVAtljXMZGMhJPBiMJFG8IViPiVM3WAqNwAper1g0kEueGGUImQQq3zId6fRX0ieJQyxYeQpMhdIMbyrh9BRlZYWYsdtrvsxrLfAcdRmkQ2FrEd47KKnzIbvMYKBV0hM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc old email

(Gentle reminder to please send all new stuff to ljs@kernel.org - at some
point I'm going to set a rule to ignore kernel mail sent to the old address
so, if you need a response you should send to the new :)


On Thu, Mar 26, 2026 at 01:08:30AM -0700, Suren Baghdasaryan wrote:
> Now that we have vma_start_write_killable() we can replace most of the
> vma_start_write() calls with it, improving reaction time to the kill
> signal.
>
> There are several places which are left untouched by this patchset:
>
> 1. free_pgtables() because function should free page tables even if a
> fatal signal is pending.
>
> 2. userfaultd code, where some paths calling vma_start_write() can
> handle EINTR and some can't without a deeper code refactoring.
>
> 3. mpol_rebind_mm() which is used by cpusset controller for migrations
> and operates on a remote mm. Incomplete operations here would result
> in an inconsistent cgroup state.
>
> 4. vm_flags_{set|mod|clear} require refactoring that involves moving
> vma_start_write() out of these functions and replacing it with
> vma_assert_write_locked(), then callers of these functions should
> lock the vma themselves using vma_start_write_killable() whenever
> possible.
>
> Changes since v4 [1]:
> - added Reviewed-by, per Barry Song and Lorenzo Stoakes (wherever the code
> stayed the same)
> - split patch 2 into 3 parts, per Lorenzo Stoakes
> - converted vma_start_write() in mseal_apply(), per Sashiko
> - changed vma_start_write_killable() error handling in
> set_mempolicy_home_node(), per Lorenzo Stoakes
> - added comment why mm->locked_vm is fine even when we exit early,
> per Sashiko
> - moved vma locking before vrm_calc_charge() in move_vma(), per Sashiko
> and Lorenzo Stoakes
> - set give_up_on_oom on error in vma_merge_existing_range() to propagate
> the error, per Lorenzo Stoakes
> - moved validate_mm() out of the error path in expand_upwards(),
> per Lorenzo Stoakes
> - dropped the patch changing S390 error handling, per Sashiko and
> Lorenzo Stoakes
> - reworked error handling in clear_refs_write(), per Lorenzo Stoakes
> - uninlined process_vma_walk_lock() while changing its return type,
> per Lorenzo Stoakes
>
> [1] https://lore.kernel.org/all/20260322054309.898214-1-surenb@google.com/
>
> Suren Baghdasaryan (6):
>   mm/vma: cleanup error handling path in vma_expand()
>   mm: use vma_start_write_killable() in mm syscalls
>   mm/khugepaged: use vma_start_write_killable() in collapse_huge_page()
>   mm/vma: use vma_start_write_killable() in vma operations
>   mm: use vma_start_write_killable() in process_vma_walk_lock()
>   KVM: PPC: use vma_start_write_killable() in
>     kvmppc_memslot_page_merge()
>
>  arch/powerpc/kvm/book3s_hv_uvmem.c |   5 +-
>  fs/proc/task_mmu.c                 |  12 +--
>  mm/khugepaged.c                    |   5 +-
>  mm/madvise.c                       |   4 +-
>  mm/memory.c                        |   2 +
>  mm/mempolicy.c                     |  12 ++-
>  mm/mlock.c                         |  28 ++++--
>  mm/mprotect.c                      |   5 +-
>  mm/mremap.c                        |   8 +-
>  mm/mseal.c                         |   5 +-
>  mm/pagewalk.c                      |  22 +++--
>  mm/vma.c                           | 146 +++++++++++++++++++++--------
>  mm/vma_exec.c                      |   6 +-
>  13 files changed, 190 insertions(+), 70 deletions(-)
>
>
> base-commit: e53c9040ab1b738dd2c83b57558f141902caaf4f
> --
> 2.53.0.1018.g2bb0e51243-goog
>

