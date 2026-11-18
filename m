Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB87E606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 06:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=npP161yt
Received: by kanga.kvack.org (Postfix)
	id D48876B05B2; Wed, 18 Nov 2026 01:42:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8CF6B05B3; Wed, 18 Nov 2026 01:42:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E7C6B05B4; Wed, 18 Nov 2026 01:42:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 895186B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:42:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6FAB240389
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:42:45 +0000 (UTC)
X-FDA: 85447296690.01.8E987B7
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9E94520002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:42:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=npP161yt;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf13.hostedemail.com: domain of namjain@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=namjain@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794984163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhLiqpRhYR+jbB7aXfZbX1GKQMokOJpkHTiOlAJk1JI=;
	b=tEe10A4Sxmx5pY2ojso/28RgCV6ghVVNUuxZ0K1Bac8RP3dQYophi+sywQR+HOJUmuB7HE
	mSE1tBJ/z58mk/7qI3+K38VJopqdXfnkjJ3H2gdXCalgdb/FUNgAkkp4xHxGyCuVzo0uZP
	PlgNMScYATe6qlyXmSPPCyu3L4fOsJE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=npP161yt;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf13.hostedemail.com: domain of namjain@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=namjain@linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794984163;
	b=B0fOc/ZKJSZiVUmhUbNZZue2n2ASEI6L/8r2slOka/PjjmgPQ4sOCdDteLumeqwXW8D0Xn
	ibY7OrH6KmgnLtZNfGvocugIt47czVnvHu7b9l7tf23+q/E1L2aI7qAIOrSmItVRO0/5L9
	WX00tawJWsSI8q2T4lFvUjW5pUnpNhs=
Received: from [192.168.1.70] (unknown [4.194.122.136])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5762B20B7169;
	Tue, 17 Nov 2026 22:42:34 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5762B20B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794984161;
	bh=NhLiqpRhYR+jbB7aXfZbX1GKQMokOJpkHTiOlAJk1JI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=npP161yt+2NqKpdXWKorUJL7rANBYxWfjlN+h2ZbAyLjzQjgrjBc8bK7FKPd4cdZJ
	 rIfGZpG4BEXgsWY4PZbmQpQTNfsy6RLgBXQVFrZUO9MbyosSoz9Ynb6Czw9ucNI+6q
	 p6Dhyso0ZZNTaFoYDykV1L4ZmO1DiMEPmP23Q0Z4=
Message-ID: <ba47e0f4-d076-4680-93e2-df4d673f742b@linux.microsoft.com>
Date: Wed, 18 Nov 2026 12:12:32 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/huge_memory: only compare PFNs of huge entries on
 huge fault insert
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-3-537605643f6f@kernel.org>
Content-Language: en-US
From: Naman Jain <namjain@linux.microsoft.com>
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-3-537605643f6f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Rspamd-Queue-Id: 9E94520002
X-Rspam-User: 
X-Stat-Signature: s7ynfgchx1qeot178pn81q44kse1z1f9
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794984163-772733
X-HE-Meta: U2FsdGVkX18O+1Zq3Y5aIUtKVMdd+8CvOr615Az2NPdcvcRd5fp7Hd5RtBSJq1hYYmXuTU2tU2cEjMH7LPrugrvTJ2lNpyUHdpZ+K7Vwj4ajg9zG52S9vmzO5CHJqIgfHKJQPuWWu1hKH7+iiC1ESd52DxLdAs28XUV6aF/AOzz0MQmb06QZKLcYHdwszuhZmA83rVmefLRu/hSZ/orSaUdZC/96KVIj1AMtCzsahr7npiI7NVKr+P6Rb/ibg22WyCK2w5ccb6CcLBrJZtbiWN3P6CTdfonvPie4C02KVztM6xUNwM02P2CfVCdWXkKMDnibhv3I06Xykpa710u3Umxvb4IpRriZ67P4SfzkgXtaYjk5Uz7pmQhqF5dr+0FboKqv5kZsC8y0L1AJ1hmgulShG3GNl72pHaZ9GXKRsxUhiyp+NTf6xbOJKeeJN6ki4/QMd00UfZtmF4LYQyfICuua173fulNHGwEPDTbXWQpSkLkTJlgGRJ9PZ9nmhQFmdpTMH09MG8LE0iorSW4nR0ui66K7LdwiQsUIg6FVLS1qx9n4BhCgMFEc8gVzz3+P+c5e5YB/ZLDrbQG9j7gGCxXERRXU/vclm5vO8LG2BKNoVN/s1m1M15RPJG1Rh1lWt897jIAdzzDmkCInXWasBL6wybpFm4kf9ABr/F8wquQOaiPD59tANYWCRewDpIkQMHdYW30BAj2SiR+WtH2wuP3cW2bdHkxvq4QqCvo+v9VeZ5Gr4UsOleJEY1bo8bDsKxFU3wdEosKs4K6vRTs9lvEfk5XYM6JYI9njGRWmej5/BBdSb5x+8sZLCkHnGmZ0SnrjrTx+JSW/h+YVDIoVW5s4G4ztKL8i7W+GYfW4lFsPc4qQcnBYl59w92YSOH62F/x4Sf1+RuWV2ObVQP5v84xSeM/blcaOSt/IWx7iKijgo5Yr509eP0cMXS5rLqmJ9eTajvQ/OXBi0RPnDAN
 nE1MMDFT
 xDQofV80fWvryPPNjwOhX4wfH6qFe1iidI4bHk3LfbDSn725aS9CNjzBiNZOBO6Lkfv9GLxEeyT0Bt50WcZzatSzijpSavDuHODtWTO4lDaqYU8ZXjYdCDRSp7frYgRz9z2xt5+iJq4zhvmMqhnkiYuUDl6LzH+3wzzwH9OjYVGf5ljZK5dJVr1sX4HXxtyGzdFYKR6TqxQIx7MfQ3jY7rWOdxeXxk9smV7AMpyfHve91NwIb5qvfH74Yx1Owg2x86LAeNFgxzME5LwCVW4qsfJwb7uHox9WQBua+1+m87vx6Lu2v3vUsYcqlwCo8TVnSMLThvDExAqdRpvARMbw+Odr3JnDy+lEgrRJYUHcwSAjdLxGfViLz/srATuRWhSzPR3+c8qA8rwybtNPVhrWWuJpW3jJzHbHO1nt4+Yy5JblUEfGx5W9t994+xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>



On 11/16/2026 2:28 AM, Lorenzo Stoakes (ARM) wrote:
> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.
> 
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
> 
> insert_pmd() and insert_pud() have issues with this as they both assume
> that, if the page table entry being populated is not empty, it must a
> present huge entry.
> 
> This is problematic as if it is a write fault, it compares its PFN against
> the one being inserted, warning if they differ, on the assumption that the
> entry is a huge leaf.
> 
> Since the entry may be a page table, this is invalid and can result in
> spurious warnings.
> 
> Equally, the entry might be non-present. Nothing can install such an entry
> in the VMAs that reach this code today, but there is no reason to rely upon
> that.
> 
> Therefore only examine the PFN if the entry is both present and huge, and
> otherwise simply return VM_FAULT_NOPAGE so the fault is retried and handled
> at the appropriate level.
> 
> This is what already happens for a read fault, for which the existing entry
> is not examined at all.
> 
> Target the commit which introduced the first driver which both mixes fault
> orders and passes the write flag for the fix (since this commit, both
> drm_gem_shmem and panthor are prey to this issue).
> 
> Reported-by: Eliav Farber <farbere@amazon.com>
> Closes: https://lore.kernel.org/all/20261112051440.16140-4-farbere@amazon.com/
> Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>   mm/huge_memory.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0d589be136d2..da632c3e834b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1643,6 +1643,10 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
>   		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
>   					  fop.pfn;
>   
> +		/* We may have raced a fault which installed a page table. */
> +		if (!pmd_present(*pmd) || !pmd_trans_huge(*pmd))
> +			goto out_unlock;
> +
>   		if (write) {
>   			if (pmd_pfn(*pmd) != pfn) {
>   				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
> @@ -1770,6 +1774,10 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
>   		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
>   					  fop.pfn;
>   
> +		/* We may have raced a fault which installed a page table. */
> +		if (!pud_present(*pud) || !pud_trans_huge(*pud))
> +			goto out_unlock;
> +
>   		if (write) {
>   			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
>   				goto out_unlock;
> 

Acked-by: Naman Jain <namjain@linux.microsoft.com>

Regards,
Naman Jain

