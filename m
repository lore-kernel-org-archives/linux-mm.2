Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D2A606A330
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E9US0Gnl
Received: by kanga.kvack.org (Postfix)
	id 7F7436B05BB; Mon, 23 Nov 2026 12:24:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1646B05BC; Mon, 23 Nov 2026 12:24:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E54E6B05BD; Mon, 23 Nov 2026 12:24:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49B806B05BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:24:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6E30140924
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:24:44 +0000 (UTC)
X-FDA: 85467058488.09.598ACD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 22C8314000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:24:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9US0Gnl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795454683;
	b=6BzJPl8Ty9Bie8dq8tXfPYdq77/66nsRCZ3juZt/z7jN7YCoU+rOJG546/bht2BNpJWXKV
	ztTLKZyxwqiisrMC0O6lb7g0J+NE+nwuLbw3Sy6eRI6J57JnoNhD0v1myTDQXGXFlBAgYD
	fsjchcIEJAEp4gE4R24GN96LXLbdZ4o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795454683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOBTC/Bts81uYSw4jWTx0KjcitZ5QkeYRyFe+0Yns5g=;
	b=AHJKh/5W21zNRmbfkGKd8HQDoMFTcBdo9OUKbJ2JIwDAWjvnIIBrxtuM7Yxg8rlgXGOyWN
	MkkMmtCrjkT5tGdA8OuS8vXbjQmwqMTceawr8dRkAwvGNpsNdjy7hD0XgGOGaAc2Fd47gk
	TJ907yWlxkyXZgENSSwpmn4OhsVBRmA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9US0Gnl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6B4461E7F;
	Mon, 23 Nov 2026 17:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EE41F000C0;
	Mon, 23 Nov 2026 17:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795454681;
	bh=JOBTC/Bts81uYSw4jWTx0KjcitZ5QkeYRyFe+0Yns5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E9US0Gnlbg5OPz1RjYiRKycFC5TTNqCsgbAp3Qx2QF9f1zsa32qirjMEenlHMPzg0
	 EAMc1MdUPxrrol/WFNQr+iCqYyjMDwJGoTviuRo11m7S7vYv8BNIIW3A4fTju31Ngv
	 c2Xiqq7tBwE6MV+wtHqQ2ao8FAG+nXsaycT+4TPCnkmTnYo2dBcrBRYKwuRz13Eayn
	 sYmLAzxr22Y0VNMcTc4fWjX6KHu2QP7goCb3z+aFA7q64Mrd4oIqkwxsI8QOWBgca5
	 QXAzGpRhE9Qqn+f+d9wFLD2EchacbFQKjINAD8OJQ0MJT92Y/zzAqaD/+uZPxuT9vS
	 cUZ5VjTAdvnAg==
Date: Mon, 23 Nov 2026 17:24:31 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, mhocko@suse.com, 
	pfalcato@suse.de, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v3 3/5] fs/proc/task_mmu: read the PMD once in
 smaps_pmd_entry()
Message-ID: <awR2bZl4CvSuInmk@gremlin>
References: <20261123163301.1568240-1-usama.arif@linux.dev>
 <20261123163301.1568240-4-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123163301.1568240-4-usama.arif@linux.dev>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 341zqrs38cpehimhy1ctfmijwknemhnu
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 22C8314000B
X-Rspam-User:
X-HE-Tag: 1795454682-774072
X-HE-Meta: U2FsdGVkX18mCibB2H/4foU4XCbgQSosg5Dq/GzV5iLRAtfdQ7VoPu9D/AFiV4INKGtr3oDUQShwdwvT74yD+HJFzShX7wDv1E7KGO22+vuAuDVBxRanGzMlVFqUQspwNJpElEbL7W4CVdTi1QenYkI4LHTWFJwP2sGeFjfXzkyN2RhoXjHIBXmTfIEacRy542Ef3xycueEtVgFzV/KIYB5iUDryfAanDAoCvuXl+wQ9X/n2e2wUDBm9w/Lnu9ZJUfVlfcoCXUf/Szjy8/QjYDa1df1dmKQaYaIcWGinh8+CzUTjEzHbruKgeuINlyqZKBEnCq0h1VA2Kjo1zGERmb1wGWmpT+0q4+vv/CQX8YTIhS7rDB2cn4t0esVH5MsOWbqqHVW9N0GPQ5UCQNCuLmONu/ejbIGuXc0B2jtSsMx5z61qFHOX8ZLFtG2TAYMpWbeXNkc9ygaTbmu3D+FgYPDPxMXeN4ulOfsveOkynXLvSviTGRxuX3GfqJ3qAK3P1Z1rtxoxamaATSv+7WUJqe6ERBUYZFYBuN6NkpjjXSUF/v2ZaSbkp1XQezmT03vvLI3wkU/bFADwOWPatWPD8pepmVOx7OzypfQ++Hs3heeGRSDtEq0cFMElV9lf+HVOHmHotAIc7UPt7YP0ppFmjyZXCIu04ZiDkEVhnrALmF1iv2i48/ZaW/qMc/s96x5ChavmKFCwUBpSQAphiEaAMm4UAJJ6/u+lj3SWVJvjd4Igw9IrsDfu+jYjLRlt4eLHbw95Opv1cbIjaACUsYsyf88MDZ0yM91QmdgN/tKbIC/KSZI8jdVBY2ow/Eiwi8NgOHe6LwlNx9P8A0HnWMQn68AmMwSiEBMCDprYsn2vupGLRC5XZTsr8Zr3EpsMKjnYhqaS6QFHtUis0A3hubz1xz/MQc+qTx9ButzfLiQ4OZtfb4uRXGichiLsnf2TgJmrZm7IlzwXBSiaM3S284k
 wKv3CbQS
 m153GbJf0/9dMa9FBRFUSWTkfRJ8up6Tr4yquQn3l4dE2n1W9w1harosrRtO7RfWDcnR49SAcvd9BS3KSqLo151RPRjQsceqoqJe8lCqzakrZN43bsq22F2+jcDgUfNI5SQ7Vo5BjfIbJlBo529raZOk/DHaXwzH6/pvq8ToGM5LHsU/W/HGs7eYecBYsY3+8aVEr16azFIV3UaC5uyeeV/cKK5P/OS50rucP6NqJcJ/XfX7Kl9ac52h3PiosbiH9hakFSrDAHP70gP4Q4tZVOhW6y0DOSJwDGHkVJDyp523CL0oNyGsnofKO9Jqtpox19d5y5oEgxKgfktIhVFFRPo5ZSAphgsjWOIXOPGh7OkPniV3fZi5gGufogG3mv5uyZ8bLXmZlPWlhzqhAATRmd2cm8fwEqGZ4tHJTWbdZdJRn8Lr28RPvHYZ+Rg7n8nkhl4RztPxlvpy+/DNt2W40xckCMsLACgsYv5bs2ZyGgbOJ+eW7wX2vISdgcPl4pVXZVrW7r9BPvxqSJxPrLs2knzUEXA6wUr1FCuFLnt/8qVafIf2ahb4cHb8rgAv/wGO1pNlBhu6Q0xM9xesql/C+DBkmxZjhzz3T57NtebPgeo8OPQB5f8P14Tubtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 08:32:09AM -0800, Usama Arif wrote:
> smaps_pmd_entry() dereferences the pmd pointer six times. Read it once
> into a local with pmdp_get(), the way smaps_pte_entry() already does
> with ptep_get(), so that every test sees the same value.
>
> No functional change intended.
>
> Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 540c936aad4714..105c4998eef48f 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1022,14 +1022,15 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
>  	struct page *page = NULL;
>  	bool present = false;
>  	struct folio *folio;
> +	pmd_t pmdval = pmdp_get(pmd);

NIT: Can this be const or are the helpers not safe for it?

>
> -	if (pmd_none(*pmd))
> +	if (pmd_none(pmdval))
>  		return;
> -	if (pmd_present(*pmd)) {
> -		page = vm_normal_page_pmd(vma, addr, *pmd);
> +	if (pmd_present(pmdval)) {
> +		page = vm_normal_page_pmd(vma, addr, pmdval);
>  		present = true;
>  	} else if (unlikely(thp_migration_supported())) {
> -		const softleaf_t entry = softleaf_from_pmd(*pmd);
> +		const softleaf_t entry = softleaf_from_pmd(pmdval);
>
>  		if (softleaf_has_pfn(entry))
>  			page = softleaf_to_page(entry);
> @@ -1046,7 +1047,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
>  	else
>  		mss->file_thp += HPAGE_PMD_SIZE;
>
> -	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
> +	smaps_account(mss, page, true, pmd_young(pmdval), pmd_dirty(pmdval),
>  		      locked, present);
>  }
>  #else
> --
> 2.53.1-Meta
>

--
Cheers, Lorenzo

