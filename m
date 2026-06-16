Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2F8FCD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB5E6B00CE; Tue, 16 Jun 2026 17:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC766B00E2; Tue, 16 Jun 2026 17:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9BBC6B00ED; Tue, 16 Jun 2026 17:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60F6D6B00CE
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:17:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4E904013D
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:11:03 +0000 (UTC)
X-FDA: 84885962406.07.B881FD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DC6F0180012
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:11:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQaOTTvR;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781619061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0SwEZ3tknfn6psRl8TQLDqLaB5btYhZHARnB/2ZNo8=;
	b=hBPfggCJAtLk9siOIPgYmSLsD+qNP7X4qz6nBxqJ5xB7VLzSlddpDEQ7Q2J6ric3PG7Nrp
	nU4gCARK2J4i7O32SYq7yZci0EQTqGqxInSVr385/UwuAj6zaTSAK9z3BRJT6QXzLhhFIG
	iRS9ijbyaG38blJvl1o+QwNRhcNarJ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781619061;
	b=MAXx0uSv0SBAT1vnUMN9M4qN3yzCkpYRqk1YWiExAZKEOIW+HD8n6iSzgxyAdwzxDKAvYD
	YHh8x0YumDeuIr1RoK84F1g4r6XyxqEgLAWCkpv+ullA0JBbsCskxkKCoF+oMC5egxQHz4
	11yxlmrFwFPFDNRpz/5GqR2KNhVrpKM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQaOTTvR;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E8AD600AB;
	Tue, 16 Jun 2026 14:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEE51F000E9;
	Tue, 16 Jun 2026 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781619059;
	bh=P0SwEZ3tknfn6psRl8TQLDqLaB5btYhZHARnB/2ZNo8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GQaOTTvRFDrlt5jHrIBBRWfZc8cIiUzOBQ+t3bLwly1QaxZlzHO9aYxYJ3tH0E04P
	 Ro774mgT4J0aqVjuzDnwMeLv66dHXFqsolpfb9FGtULchsi5zWi69jP0OStFvMcuZE
	 vrBp8Am0cnURrdK04N1eBa8PIecvuoCzDxeCIEk5oxHXJRyQVV8P8sEFA9YTORWiQW
	 MeG4QYkBil7+owvkK0JbvWypvDNxlw4ehq8B3pQcak9ndNTDVo9xc+iBG54QUjxU/Q
	 0S5Y6odT5at6XB0bQ7dDHMn1UmWg3XYXC+9mVxqecz7Zud7/H4FnpFZFMjlsimFoIq
	 eROaMQO3wP++g==
Message-ID: <645a5246-0f9b-4b93-9483-e6bba35f037b@kernel.org>
Date: Tue, 16 Jun 2026 16:10:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/12] mm/rmap: refactor anon folio unmap in
 try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-11-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526063635.61721-11-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC6F0180012
X-Stat-Signature: umsq8k4f94z8td965m3hs4eyzmetnfdm
X-HE-Tag: 1781619061-570605
X-HE-Meta: U2FsdGVkX18swYoXGLq8vKSuPKdnzgdWIQY8/zbTcHae00MgyXikPvSTvnBGPsVCO6irWf0IPECi7Vs3iwaEYizk+eDbTkMcH3QkyCoP6TMnPlHJwI9p8ieeYau4gZu4UJyh0tvq8oMiG74d4ghsVg/xpQvE7oeoto0sQMk0CPptLxTYCYW/0Cwz0h4TGWwVWajjd4UKcb7u1rUs8b06tKL5lExRYqDtfV0RCTkJZtJPYOnhETlXbZcU8x65okme/4YiN2ySGKR3GHDXQE3GycoJFQj7gwE2oC+Ip4QaMIF0/sMhFaLU3oOQd9FVnhUKT9JbMV/uo2G+ShU0RoeBZWpG1/y/3Vu3BBJXlUYZPw59tUyINzZc7fdOGfu/04cHpU42llbgZNOSoXKkt8X191mZHhVrXec7+B1RiyfvP7tZlh6MvVNx2GBmaqB80cS5PX28JrHWaTdxsTrdCPu7j77z5Ax8JARYBIGTaWpQhgNybF/Zo/DFHOLyxayS3CHq+9BLxp3axmkT3lFshl+b+7ILzWhqCTTjdiHqHQiNAK79RmkrHI9Uh7CqsxJ/zUVRt3axfGU+JhE3AS16cwh0ogPsid05GQJUZ5iRpoXW4yLYrcqlHKukcgKQsCvSRK7n1t4KfcFr9kZhp1myNY+cKPan0MQXVZYRMGGP9b3h4EzzFj7Z3zInsm61mnQOaiYYmcpUWWUkgE76pXRw5r3eCh9lCbFrHrscVdi7f97F43Gj+nNOUP5/y+zHGx8af2nQiPayKM1NGsRcTSVjDIEl46Nm1MVR1ao/GKdapZpAS+tC8POspWyKZJVof5+JV0tXOro/37FE5M7VRvUGRg+u+tCwCZWRekCDhjHDxbYSzCaZKDCWG+EJhYtNawstLMlkNvtMYQ1sqDstaD0PQylK6ndS55aHXvK8K1TxbM46sQQLahYv2TJG0GcA1/AMwgLi1acbAP8xy92TbrSz9MV
 HBENZVfv
 o8IfmM1orrJAfUGVwXKOXm2h+COn8oYfF2O8Zcaibj4kIqo3afEdBt9SIr8rnV2ncffyVLWKkQfqQJtG212JPjsb800tEhR+hs8CG56E5VhktV2cNkKIrwtWNt+jiHCu2CzaTCRpKyBqUwl4m/HeQ0G5RI7adAUQsrhp66fnlvgUAMhqv92zTA6gXSg73hgLCL1IImY2g6Fc5xPXH/mqSD1D6ib6dCcukrmRlFqOMSRsqpXkTCuZbEeRDgVI1jyktrkbc2NqMSaYevKYvco3f8r407gP1zxM5K+8n9FFB+QiMCd2bkOZUh/N/hyr7B/vA/kUuAHHfZULgDqiZr4jELpIUwcpKWaSowLrjDEdyx4SGWgY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 08:36, Dev Jain wrote:
> Refactor anonymous folio unmap to ttu_anon_folio.

Given that the !folio_test_swapbacked() case remains in the caller, should we
make it clearer and call it

	ttu_anon_swapbacked_folio()

Or alternatively, factor complete anon folio handling out (incl. lazyfree handling)?

> 
> No functional change intended.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 116 ++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 68 insertions(+), 48 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index c0e385882f562..b1639bad8e27f 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2136,6 +2136,70 @@ static inline bool ttu_lazyfree_folio(struct vm_area_struct *vma,
>  	return true;
>  }
>  
> +static inline void set_swp_pte_at(struct mm_struct *mm, unsigned long address,
> +		pte_t *ptep, swp_entry_t entry, pte_t pteval, bool anon_exclusive)
> +{
> +	pte_t swp_pte = swp_entry_to_pte(entry);
> +
> +	if (anon_exclusive)
> +		swp_pte = pte_swp_mkexclusive(swp_pte);
> +
> +	if (likely(pte_present(pteval))) {
> +		if (pte_soft_dirty(pteval))
> +			swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +		if (pte_uffd_wp(pteval))
> +			swp_pte = pte_swp_mkuffd_wp(swp_pte);
> +	} else {
> +		/* Device-exclusive entry */
> +		if (pte_swp_soft_dirty(pteval))
> +			swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +		if (pte_swp_uffd_wp(pteval))
> +			swp_pte = pte_swp_mkuffd_wp(swp_pte);
> +	}
> +
> +	set_pte_at(mm, address, ptep, swp_pte);
> +}
> +
> +static inline bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
> +		struct page *subpage, unsigned long address, pte_t *ptep,
> +		pte_t pteval)
> +{
> +	bool anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(subpage);

"subpage" ;)

Can be const.

[...]

>  		} else {
>  			/*
>  			 * This is a locked file-backed folio,

Happy to see that function shrink a bit ...

-- 
Cheers,

David

