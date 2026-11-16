Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF622606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hSPHJGL+
Received: by kanga.kvack.org (Postfix)
	id D406F6B05BC; Mon, 16 Nov 2026 11:02:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17156B05BD; Mon, 16 Nov 2026 11:02:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D9C6B05BE; Mon, 16 Nov 2026 11:02:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92F936B05BC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:02:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29BD91C20A9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:02:07 +0000 (UTC)
X-FDA: 85441448694.24.FB05755
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 489AF180011
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:02:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hSPHJGL+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794844924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RsEOXhiUKoPHgrMBzJx7X6tWd/DKn2RJ2I5J/16MaEg=;
	b=AbPEaya48EWO3fn0XMCS28dGkN5tatZQMAoxMwLipS892QUYF8N/bz1ardhMSehE5wQpes
	gZPCY36ysbNbvJpVYk2FWF7iZ1IVw4CvezQ+f3l+C4k+pITi1dUWoc+3yGjF7HRtoxzY1A
	6DkXS0b3fMwK4I8hC15uQbqkitNBgnU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hSPHJGL+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794844924;
	b=8e2WrXmDtRKPlWj1dhMACvgqHuzQ/Q8ho1XyDg+aQ2K7gWmjsGDWIgXMAUoUIEIw0psObI
	X0JOryuDyXS77qRNoEFIRTRqkKODnuymab6wCZ0CYKP2lIqbgj4Dwc5LgaJEJ/CFRB+V5y
	twq7uvqcYDu6IdL2YjBAc8kjMJ8AN+4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9D8662DB2;
	Mon, 16 Nov 2026 16:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77E21F000C4;
	Mon, 16 Nov 2026 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794844923;
	bh=RsEOXhiUKoPHgrMBzJx7X6tWd/DKn2RJ2I5J/16MaEg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hSPHJGL+7GNjwx9dyoMxStvj2YRWJR2dkfYi1h7JeqBGNmKR/DawM67cqLNEfa+lb
	 iC4jTyFaNm6skppRGfL+dTtoi0pVhkucwkPtrKnyd0LUeHr9g1k17Src3UNoCBstoc
	 lpMAkZmn6Dsy6qzTW+DKFYXQ2ScFxy/5wqWCAmBSwmWBTOYUpysDrn5ZujkXzQYCHj
	 4n4L0xv+YeG7khAfIfHfLGAJkCku/5dlyqUTmxAxNaqQtVNJzH+JihNUQk1hJOCFo3
	 TtzVl1EPLCOn7lQNQ9Ue8CqtCL9y/mxayPAJNkQVnXawbpZLzYKTQHT0aK/jlLRxRs
	 MCEhmqdO1Z56w==
Message-ID: <e13044a0-871b-4033-8a79-22cb9653b6b1@kernel.org>
Date: Mon, 16 Nov 2026 17:01:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/huge_memory: only compare PFNs of huge entries on
 huge fault insert
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
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
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-3-537605643f6f@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-3-537605643f6f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 489AF180011
X-Stat-Signature: udwbsw7xtkabjwpruhafybk69f4d8yue
X-Rspam-User: 
X-HE-Tag: 1794844924-272909
X-HE-Meta: U2FsdGVkX19TbNjzw8EGE8HlOfqib54n7voMBS+aA95UfqI9I9ZwLhhwpYwbfABXztOohZUdklJ92HVjgrB0nh518Jw+dQIaMu5TWNpKOuaBYxs6pc7WtsqAp6+LoGTzI+9hgwQdh5APg/QJKTBTw69WkAOLIyqrhqSJMDIlIv8vRrdjer7fzejy2GV7WD0swbLM3WDV4q3DxzNY3jDyRfiWlExBUCoVL49RVZIfW7wQq3s2m97h4ORTJcIuF/4ncR/H92E8PvwGV6bff/+r6++LfaZBuJ+stqxU/KFpBjHKS2ByAbMP+NMF5Y3trOsYCBqgP89QAvl1Ij4p341GUMrQIgx9Mh+3k7ygYOpyCf7HrYmougY4KMdjh5DYZcdKE+w0TegtWDFiUKlSMHMrrWx7nZ2/Iis+uF4z2HXQ5V3DyqbT30H465Sw/UH/+g9fo2aE6X2/KLLv2iKYnu2ZG6YXzIO6nA05BE31VsXHUXvLbZNg6jbl5DovINcJm4Hw2tOA36Uci3tVF3GPZ8MNbewBrSt41U+lAAD0JBP/yDJE2ayu552BBhPdNPKkjqKweMTwuy5+Q1UC11vhfXrbHYyKiUGtQdJ41Qfg/i0Oozm3DoL16y1JsKZfZkiZiVVvkqwUeHK9HGTDYeUx6i82Ew01DE3MOIjRX2fSGz755DBNXDPuNMd+vTZwULhBe29tXfi9ybXush8c8Q7fh+d5odZe8BRqw3TursRtYnXVmC0Oh/SgsT/ypOJrv9UO53evV1XwqzaEastFeyU4Y5fUWAbsTcEtyOqNjd4dL1YRZHhoK/zG8FSj/RHJ+hroUGFSgS9xeZ7ZDkkBf4FQXUjX2mpFvzDzUkwH7zISNE5XaWrswCG/+WdrF6Y43xxthBxCJLFhFg4khxqF9Qs0YD3F7vbI6EOXf7OkypquC9sX4TwASOJrGgRJY4/v8J7iJVDttfw+7VzuUcn7OD9UtcL
 Vzj7N0r4
 KX0gGtFj8eNrjcyG9mtdG67CPT+k8+9LQqBYvQTSg4QSvqfhsA/G1ylvvOI/atbf/zJLM47eAKOh4dMC7gU2VZHh5XLSiIRN035M9+MA+HhYWdNQZ9WWv4vrfqOqeLsgagLTdlgOgLqYl13DtCkhXjegWvyEWJ14fzf1VGd1pBlK8WhT7aS/HYJO60vhSiiHHBe4MbWcsoO88bjTorlaVtYu9eMeBNwWLtn+d5EgcmtyVTIQfnVIv0VtPGpF8NU+4SKSA3tSooWXg6bkN2uuU5lv0FKvMmrlm0XVMJXddvAYbMum9s2LECWO+h+3VuQ2KyqY3WFs3tcm0zjM5XYBl86hWRgydCtzhGXsc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 21:58, Lorenzo Stoakes (ARM) wrote:
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
>  mm/huge_memory.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0d589be136d2..da632c3e834b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1643,6 +1643,10 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
>  		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
>  					  fop.pfn;
>  
> +		/* We may have raced a fault which installed a page table. */
> +		if (!pmd_present(*pmd) || !pmd_trans_huge(*pmd))

Ok, we hold the PMD lock, so that cannot change concurrently.

Given that we are in THP code, I wonder if we could just test for pmd_leaf()
instead.

Same below for PUDs.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

