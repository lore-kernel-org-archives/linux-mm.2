Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2700CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 20:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1FB26B008C; Thu, 15 Oct 2026 16:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF78D6B0092; Thu, 15 Oct 2026 16:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35526B0095; Thu, 15 Oct 2026 16:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BEA96B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:10:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 20AA51A0188
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:10:37 +0000 (UTC)
X-FDA: 85325953314.15.E8371C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 684631A0009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:10:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxhkLSP1;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792095035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bm2ERFyVvwHy3KL3GkZjGCypavkWH4W9XQY9JXBOp38=;
	b=gGn6x6P+CI1gFadTjfl8RHFb1jx+8UfTiKTGY9mzyF5ISaYEm9r0YwZVu9Xhj6XvnnIggT
	JE9hEwCHrnxFEd4OgB0k7LGiQO45Nq1ZLENXuBEafKJ7rDFVJvZ3wMktkcAV+EhhjIXpz1
	Q/+w+D9NbRp1G4m8tbliUPBdHP3lLmo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxhkLSP1;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792095035;
	b=hfnxJDlymWQ33maioAf4bW1hyZKPVPqK51VLb99f0SIoido5Br8JLD8hf9FzblXT44BOlV
	2brnmoNlxSnN6cW4RD8EE7hdvJ9EUl6M8fs4m4ILMgp5a2tWieVOAwA1TTHDeRMcV03OG1
	N1e+74XXF37sdo0bbVHTzEblSr5g5RA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CC08436C8;
	Thu, 15 Oct 2026 20:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DDC1F000C4;
	Thu, 15 Oct 2026 20:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792095034;
	bh=Bm2ERFyVvwHy3KL3GkZjGCypavkWH4W9XQY9JXBOp38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gxhkLSP1ZNSGV8UU5saxrx0QHAqHeo8ZiuEPhoF5s7P570x19ZLLx/+1hYWjllG3A
	 uTfOjm2GqP2hGVC1vT2M7tc0qf0kx0D8PpllSnxKPqAFhvKYwAAR+sbFcxsQbUwkA1
	 atznjnS9TsmxwCILJJFNVTDqc6MDJF603RyAn2FK7UBYoMyRHiZmvUaDxm1N5Qn82x
	 D6GGDEuRUBNVLommG2TkyePjUjK2On7X1EYYJ19e/Oaz/Dir4OON5iBzh901RRhKmp
	 EatjIdApRPLEolKK2VkjzZlga9mhWhUyHiczizT3hcSoqezppKW7qdxB9wNnR3dckn
	 ZgHwgwKq2+uzQ==
Date: Thu, 15 Oct 2026 21:10:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Adam Litke <agl@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
	Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 06/10] mm/hugetlb: fix endless write fault on a leftover
 uffd bit
Message-ID: <atEuB27wc9Yp-_Ax@gremlin>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-6-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-urgent_fixes-v1-6-42796911043b@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 684631A0009
X-Rspam-User: 
X-Stat-Signature: 9m78ehndnbw4y8tgt8o9c733adbcpsne
X-HE-Tag: 1792095035-26075
X-HE-Meta: U2FsdGVkX1/ea29sSDq2bf1mF4+t3++lpEBPU8bVSFGy3il8evC+YCz9WaGr38sjYNbRHscpRsZ3+mGESb/oumXgEUUflcr/NszT2Eb9T4mVmG5EVjBSW2J9vl9ujxIss4onn5gwQSUJmfZmN/hE8iFIEuH9o7DdjtB5eN1mDnpH7zZJW315BW9iLjxpRNsWfRP6fupzwrxL5XwbAL5sMsOA/YeZjb4eH145oDrhzVQeCaqePHNaK4rqK0mawqcp950uLTqGPrknvCZkUKTqcMeVNelEY58MHgWfrUJpBSAoqVc0fgsXYWdppL/t+YVx69onq26fvHmoWf5AEombkT3jeYl3AhU2lTwdnj+bZK8UQq1cktzkcXGCAy4v17+9zRCZTMZFXtAgl7SER4qKjQrTfZGtUcaLntMktCm55gV+cQaEbEPnUqKGrWZJ3PQFDan4pJLNQMzkZRLBGYQY19PlFz53vhTd0Ee9Jz3Ie74R1JKQeT/ZYe9Wx8xxVh5bLWxD8rn7zkNeS+71lEFX8SJCoNyr4zP57bp3KeMLiTsMPPrAAzDxQ1tfTyzu1Wob13w+AXk1a1i1ejGAEOJKKtSw96lSyfHlhDEwyKIy/Thc5rPrGriMCrPGAfGexEb4twXkbQX3Foik89T/5nLTqp6mSI43EIJlcPz+iY8POVcyCiAzQk55Jp2h7lZJ78KWAxnJuBcH9bI4uCGz5OKGJI+q6fR7KVgJVMjpqL0Lq559c88ToaUkBUupO36qTELeX8Sj5DucUPsmaRe6T2MoUL+aGdTaHEoPnbOj0yhfPpL6u0Fweu0iJ6a7hXWjKzCyHMN/MXj7wS9Z/fsNd5Gtf68wcMTbro7SXdmMrwuDPRfHEm6hjc71Ouco0/wV5KtyBBYKR3c3OOZ5rCtOvYNhhxXeJ3ngobJIlrMytm3nnLYrrgqf38GME9+1ESTWBlqAonZEg5n3AyIQBybc1v+
 D7f5d5vj
 bj9yPw1dYwEZJ5DtuHyb1PuG7IU27dV8puZLWWYxPQPBL0rUi96Mc8EWlTBOrm6OerbrKA0b/AY8vU0N4iGyTCPmRJtjm1ovTGW0ywgcZ8G2dUMorLeghu8WtVBXDKDBTzz4MZ1gee5e4csF1mFeMNK0sn5UQi5BO8RzZGKpeKsIE6gXk+tBhGmNUVNDHpVXBwpFMQ86lwKj6KDTndmRZbNlMJIhojMTjGCdPW5fjDK257yAx2Xco7sIQwjX3fyAcor/ts78oH1AXHIwOmrvS5Cd4T7Ut52p4wZtUNTyuKJ/jwrVjoCZGaOoRYNRV+Zaa1OqV1RUqAHWhkpET+ztEOVNm4x9PuFt8WxmCz/hDCOu9YPrfoA5eS4v9Bmt8Zd6HKwXXchJ1Hw7e7rEFv5Tc0qBA/dEgDAwqyuxl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 06:07:12PM +0200, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
>
> hugetlb_fault() resolves the uffd bit on a write fault only if the VMA is
> registered for userfaultfd write protection, and hugetlb_wp() bails out
> for any entry with the uffd bit set assuming hugetlb_fault() has already
> resolved it.
>
> When a read-only hugetlb entry with the uffd bit set is mapped in a VMA
> that is not registered for uffd-wp, a write fault to it never makes
> progress. If the access comes from the kernel, e.g. read(2) from
> /dev/zero into such page, the task spins in the page fault handler,
> ignores SIGKILL and keeps holding the locks taken by the system call.
>
> Such entries should not exist, but an unprivileged user can create them,
> for example with MADV_DONTNEED of a page protected with UFFDIO_RWPROTECT
> or with UFFDIO_COPY in MODE_WP racing with UFFDIO_UNREGISTER.

Ugh yuck. Uffd is another gift that keeps giving...

>
> Clear the uffd bit when the VMA is not registered for uffd-wp and let the
> fault proceed to hugetlb_wp(), like do_wp_page() does for regular pages.
>
> Note that a FOLL_FORCE write to a page protected with UFFDIO_RWPROTECT in
> a private VMA that was made PROT_NONE now drops the RWP protection of
> that page.
>
> Original fix generated by an LLM and sent in private by Josef.
>
> Fixes: 60d5b473d61b ("mm/hugetlb: fix uffd wr-protection for CoW optimization path")
> Reported-by: Chris Mason <mason@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [rppt: massage commit message]
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> [ david: convert comment into a TODO ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Looks sensible to me so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/hugetlb.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f8ad2efd472cb..c3823f1958568 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6184,15 +6184,19 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		goto out_ptl;
>
>  	/* Handle userfault-wp first, before trying to lock more pages */
> -	if (userfaultfd_wp(vma) && huge_pte_uffd(huge_ptep_get(mm, vmf.address, vmf.pte)) &&
> +	if (huge_pte_uffd(huge_ptep_get(mm, vmf.address, vmf.pte)) &&
>  	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(vmf.orig_pte)) {
> -		if (!userfaultfd_wp_async(vma)) {
> +		if (userfaultfd_wp(vma) && !userfaultfd_wp_async(vma)) {
>  			spin_unlock(vmf.ptl);
>  			hugetlb_vma_unlock_read(vma);
>  			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
>  			return handle_userfault(&vmf, VM_UFFD_WP);
>  		}
>
> +		/*
> +		 * TODO: fix all cases where uffd PTE bits remain in VMAs that
> +		 * are no longer registered with uffd.
> +		 */
>  		vmf.orig_pte = huge_pte_clear_uffd(vmf.orig_pte);
>  		set_huge_pte_at(mm, vmf.address, vmf.pte, vmf.orig_pte,
>  				huge_page_size(hstate_vma(vma)));
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

