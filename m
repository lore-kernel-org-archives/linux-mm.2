Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6045FCCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 06:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A42D6B0088; Sun, 18 Oct 2026 02:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C146B008C; Sun, 18 Oct 2026 02:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4B86B0092; Sun, 18 Oct 2026 02:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E70C96B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:43:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82AD11C31D7
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:43:16 +0000 (UTC)
X-FDA: 85334805192.18.7BC4482
Received: from mta1.migadu.com (out-79.mta1.migadu.com [95.215.58.79])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6AA6980006
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:43:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wzQtTrpD;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.79 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792305794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wA2VfSgT+l6m0gq7FAZkuPU5HqwtXahbLtkAOUs1vEA=;
	b=VqySSqD3wGYHXdl1gMsnNsZlaMMqJ29S+t1S6fqjS0IzhXHFsl2UjCFFliKpoG9uLQSGEU
	ppoh89VIT9gINwMfzoj0IrEyinXeaIyyhAcm9Lf2BJybMQDRc+sfe9FZzyCa+E3QS2XCYX
	yMFGYdXOObSWDz+H/wBMo4pHo0jTapc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wzQtTrpD;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.79 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792305794;
	b=lLs8pdnL6CWDJUTOrDOylDo0tBKpnSx7B9GZvfNY+yUrXVR/Z8hXO938B0lBUsyd7K2tMT
	xb5SMioaHwdStyRMxFagM/Kfz+arq+fApN3tbg2CgHWAgZNVJEALwrgfd6SZO1HV+2KHbT
	/R4rdWMl4OVxyON3qy6C2WnOiWdN9Eg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Uw0YIVaZtfH6o8cYYNicP3BPPfnY5BFJtNnGIlhTWb4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792305791; v=1; x=1792910591;
 b=wzQtTrpDmaMrrqBaJyyLJamCuw7QHX2tgQT3VnVCIYmoDpc8KhryI/vrM+dr4djjC7+qDXLu
 4QPBmwW5RFy2jMn+4Z9tGAN9OlHmRPTzGY/1HmxfkQvHzSo+vCADmFthl0XkHPjEkWK8cprJG6W
 IfPw3eZuxm5jhw8R6ApeP3sU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0bd3a34f4381111f;
	Sun, 18 Oct 2026 06:43:10 +0000
X-Mizu-Trace-ID: 0bd3a34f4381111f
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	muchun.song@linux.dev,
	osalvador@suse.de,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	agl@us.ibm.com,
	mel@csn.ul.ie,
	riel@surriel.com,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	josef@toxicpanda.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	mason@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 04/10] mm/hugetlb: unmap the page where the other VMA maps it
Date: Sun, 18 Oct 2026 14:43:04 +0800
Message-ID: <20261018064304.17357-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261015-urgent_fixes-v1-4-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-4-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 98fak3issquqydnm3kif7ckj9zgiryw6
X-Rspamd-Queue-Id: 6AA6980006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792305794-63533
X-HE-Meta: U2FsdGVkX1/kRjsPH+JYU38IAgY3rpXKOjnilI4k4PfUZbjHmNNxL341k6eQ748aGksf4kusCY3Xwoqn287VVYSvAAwToMuA090K69QM1rQOufE4viLbfK+S+qyLF/vsXdPqH272grHh8DzY/BSBK+JRLn1OZBTSJ8Mp70fhEiqhMWBX90ywfBWe1tZA8LBlqZrfVSDZnkF/n4k3B8JMmo3CBi/7FNxFFLOiLIQWo9TIFBtkgQtPFiq9XEIpqBXUi21is3quxS5P8tWLrqn71zdQJd7yI9TK4ZB9Bu3aK4i/LXcPn697kVQ62w+QKrddk9hmTTEQfkSsyzqWBnGgHMFmhX9MCwfx20UL2iXw9Xb9ekI8zvO/2EFIXrew3XIoabvmHePam+d/VHnUouFJOWa8Rzbcwx4nWbeBqRPIx5dpa3Llfn5rzBogFPRDfhXOLKQl4BcgbLiKzrD4QZk1ooKXh56dmpJIUOnmQ0IMeyRYjhexbkBi2wFYA0uaYC9UFThCW0jlTwD6yKf1FDtfmVfNPkLIgHZJbCJCM/FhcwH84KUIcm2WEhsGJHaIULW0SUI04PUz3iCUcALT8A8YvDvNq0oSWGOFvDE0s/0XPR1yFCH2eBZHWyaUkrmI8i8TU3K29njoEvWHjE5DuUv8gOmSiM15+odol1CVwfum5CPh6hoK+T4lIx+366J7nJqxiAEQgFYQ8po6strDw/5qXeU4UCIMQmwZTCl6JRmEu238lh1LaxdwO5A2cLk1iSwng4qsVtAAi6d5ypfgXNGAqs7cXS4Pc0I0Qb3FG/gR5wueLiRYnvVQQPVUYhsXmY7U1ug4VR/i0YwDVJC18/YWZuBiJUvuudrmMfoTDFshpKsW+4HcHt+uwv1YI2yaikdefR8T3/BuAGsOHP5tKAee4b3Gm/S1yV1LzuOWU1YYSCSDTyPEvDJazt8Y9GUxmgno7MBtpWZPupFRc5FrXNp
 nsEcX1SY
 8m7lciK3VS1ZZDpp8MEhigsjdG9+GNVBha2vB1ugc8bC/Dwh0gJ3QCbdas4MuR9VxKcCPPmwLZOWWjPaoZZrLmZ/sDJtmI16J74z/6+qxHP/AnXz6JaHvvvRHlFmZsGkoMlyb1cEW9fSKS1I6takbu/YxlODSbzTkjI/cZDHof12SyknVq0JZynQ9aMhYrs1llKML5bXavY+JCjYDMyGxc6yTycGueNcYy4F8Rq5Hkd0LMYzrwDWc/+cqBtI3Z6Q2AnuYbIZ0iaxu1gEjSAAyUCkUqKE4pykZgCkgcM3pOd2sTlTE/Pd2lhXl9k4vJ4darRIegj8A1V6WpPOr6h6gSoarCyXZQvjJsFuegfpmcrehygvQnAyRxEGAs9xzREopuQvWakYpcPpklK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Oct 15, 2026 at 06:07:10PM +0200, David Hildenbrand (Arm) wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>If the owner of a MAP_PRIVATE hugetlb mapping fails to allocate a page
>for CoW, unmap_ref_private() unmaps the old page from all other private
>VMAs that have no reservation of their own.  It finds them by the offset
>in the file, but then zaps each of them at the address of the faulting
>VMA.  Nothing says that another VMA maps the offset at that address: a
>child can have moved its copy of the VMA with mremap(), and a second
>mapping of the file is wherever mmap() has put it.
>
>So __unmap_hugepage_range() walks the page tables of the other mm at an
>address outside of iter_vma, where i_mmap_rwsem of this file protects
>nothing and where anything can be mapped, and the page stays mapped where
>it really is.
>
>All of the following was seen on v7.3-rc6+ (g6c377d19d4a5) in KVM guests,
>as a user without any privilege.  It takes a pool of 2 MiB pages with no
>free page that is not reserved, so that the allocation fails: the user
>can take or reserve what is free itself.
>
> - The child moves its VMA away.  The page is never unmapped, the
>   mapcount stays 2, and the owner goes round retry_avoidcopy in
>   hugetlb_wp() until the child is gone or a page becomes free.  SIGKILL
>   to the owner does not end it.  5 of 5 runs.
>
> - The owner's mm has a second private mapping of the offset, made with
>   MAP_NORESERVE.  The owner zaps its own entry and reads zeroes where
>   its data was.  5 of 5 runs.
>
> - The child moves its VMA away and maps a 1 GiB hugetlb page at the old
>   address, so this one takes a pool with a 1 GiB page as well.
>   huge_pte_offset() for the 2 MiB size steps through the PUD
>   leaf, so the "PMD table" is the 1 GiB page itself and its "page table
>   lock" is folio->private of that page, which holds 2.  Kernels with
>   lock debugging oops in __unmap_hugepage_range(), 7 of 7 runs.  Others
>   spin on that word for ever with preemption disabled, 5 of 5 runs:
>
>     watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [u_det3:130]
>     RIP: 0010:queued_spin_lock_slowpath+0x8a/0x290
>     RAX: 0000000000000002 RBX: ffffea0001000028
>     Call Trace:
>      __unmap_hugepage_range+0x154/0x6d0
>      unmap_hugepage_range+0xc1/0x140
>      hugetlb_wp+0x55c/0x700
>      hugetlb_fault+0x5f3/0x8f0
>
>   RCU stalls follow, and killing all tasks of the user changes nothing.
>   Four such owners, whose children share a single 1 GiB page, took down
>   the whole guest with its four CPUs, 2 of 2 runs: one reported soft
>   lockups on all four, the other gave no sign of life any more.
>
>   i_mmap_rwsem stays write locked.  With a MAP_PRIVATE mapping of a
>   hugetlbfs file that belongs to another user, and that the attacker
>   can only read, the next mmap() of that file by its owner sleeps
>   uninterruptibly in __mmap_region(), 4 of 4 runs.
>
>Compute the address from the offset for each VMA.  The tree walk returns
>only VMAs that cover pgoff, and vm_start, vm_end and vm_pgoff of a hugetlb
>VMA are aligned to the huge page size, as pgoff is, so the whole range
>lies inside iter_vma.  Its page tables can not go away there, since the
>VMA is unlinked from the file under i_mmap_rwsem first.
>
>With the right address the page is unmapped from all VMAs but the
>owner's, so the retry in hugetlb_wp() finds a mapcount of 1 and reuses the
>page.
>
>A child that has moved its copy of the VMA now loses the page, and gets
>SIGBUS when it faults on a missing page of that VMA.  That is what the
>comment above the function has always promised to those who do not own
>the reservation, and what already happens to a child that has left the
>VMA in place.
>
>The address has been wrong from the start, and the second case needs
>only mmap() and fork().  mremap() of hugetlb VMAs, which the other cases
>use, came with commit 550a7d60bd5e ("mm, hugepages: add mremap() support
>for hugepage backed vma") in v5.16.
>
>Original fix generated by an LLM and sent in private by Josef.
>
>Fixes: 04f2cbe35699 ("hugetlb: guarantee that COW faults for a process that called mmap(MAP_PRIVATE) on hugetlbfs will succeed")
>Reported-by: Chris Mason <mason@kernel.org>
>Cc: stable@vger.kernel.org
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>[ david: switch to vma_filebacked_address, add VM_WARN_ON_ONCE, refine comments]
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Good catch1

Reviewed-by: Lance Yang <lance.yang@linux.dev>

