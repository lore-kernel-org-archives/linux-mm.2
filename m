Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DCD60A2614
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AAx1o/KF
Received: by kanga.kvack.org (Postfix)
	id B2E7C6B05B9; Tue, 10 Nov 2026 07:48:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7C26B05BA; Tue, 10 Nov 2026 07:48:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE5F6B05BB; Tue, 10 Nov 2026 07:48:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 797286B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:48:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 205128071A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:48:39 +0000 (UTC)
X-FDA: 85419188358.28.649D073
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8BDC7A0007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:48:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AAx1o/KF";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794314917;
	b=ZozyjuuTcZd3xIKha4B3GoSoe+khsHrqIjxr6mLhp/tk0jYc5cBVepgK4RpCaGupApT0rC
	K3LZ25+xZ/krS1R0cIvuCZRR/SbL+LorYt+QTyKfLEYhS+OCaEHV07HQFUu06UrYHzWqtu
	ZvmQByFaMoatojqcMqfqafP1nq3BkEo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AAx1o/KF";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794314917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UT6I9hqZhU12+F1jokRg3E4wTJM57aYHZingagyig8Q=;
	b=w3I421x3vnOVQA+37BhPiWcxzQCeChrZgrydxtPtbscrbHcUv0j743nxCMMxOA1XuecGZ1
	C3RPZ2PFPNbOmVEmlg40ljO0OMA7QdA9N/uV7z2zjLZXtlAQeWpxqjC2rkOH8Yw6QJ/SaZ
	MGXi9RvxwqVXCukqVW6jZxMwSXpme9M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F029F6185B;
	Tue, 10 Nov 2026 12:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB9B1F0089F;
	Tue, 10 Nov 2026 12:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794314916;
	bh=UT6I9hqZhU12+F1jokRg3E4wTJM57aYHZingagyig8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AAx1o/KFG7JNNHGjjXHOpcfX2vMXAWZuDpuK0GZFrj70Oj/t2Uxmoe9rPJCBfYHXV
	 WNsvgrAbH/i6qdGNKGKqqQexkRAsxolMBA/yV9/FUIcwBjJmoAGqFyKZDH9m62qKNK
	 O6lG1z/4+UbshgPZJ7t69ACJHYtk3lo5j2xxQ2+ek8+wDQHQLhacBBZu22+xpo35fI
	 r5XCp81wfJQiE/fAeu7IGffZTpwdy4dOKIh3Cd2C/U91SiloRQ5FEsbjdqQxbN5TQj
	 A8XAeIHK8mVoDRewuJXe18vW+JzWS7aLCgv2xzAOdmg81aKTyRbVV1ZTrGO2Ia4o6J
	 EEN2Gctu5fdQA==
Date: Tue, 10 Nov 2026 12:48:30 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Shivank Garg <shivankg@amd.com>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove unused clear_flush_young_ptes_notify()
Message-ID: <avMSmWU4JYReUAB9@gremlin>
References: <20261109-clear-flush-young-notify-v1-1-b37fbafa2686@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109-clear-flush-young-notify-v1-1-b37fbafa2686@amd.com>
X-Stat-Signature: 66jrmtctsrofbmox1k5a7h7tkoig5691
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8BDC7A0007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794314917-682256
X-HE-Meta: U2FsdGVkX1/0hnlUvcdHmtSUCUr+ck2y3M9i/ZJdqtK3LMaJ/bzNEijrOEf0NqsDB/eGvG/PI2MCp9A5kvlc9zdjRTmNnQ9m9u5z89jXDQ095xuiF08SnR3bMbjjlS4CUUgzOcfEFhiXC4Klg0RW32+YCvruka0m5c7BNHPpO4INTorQMcy/MBxkwff9sOY4KqgfZ2GX7+8BvGdeBqhdgZd/7yAAO+Hhkn3mMy9O7YGUQ93dWDqwpKLoF09j5pD/5LVcZbt2tMko2191c/2jVZ8gUAK1KWYNxiSU2AJrmXzUlYeexkb7asHu6lfSC0A3ao/XoQsLJhdhWp9ujed/ds7nYRggqWxApd0xS9j9Yc9dmFaubRDWlhsrsBeWws9diuG+fBoOiCj+N497KOlEZHTDNY4DzjKnMNC+YenUed8VvelhjriKL4XGnUFRBXFK8okdeHAnkjqmljUOofXtpaklPwCrXW4X3u0TNzVH8hhrvCMIxiAQP1Bb/MBzFHULg3S2t+oANwHh3ecOZaegcDEMvl7Q4ulCVeiBoweltXGactN0NEiETotoAzjJWcWnao1nDUTxADH0G2Wyr1SLm0n9HNB6u/3UkRQs8zMYaHJO+Pr/ctYogFMYsTs3dtX6GHtKb6idDBxlYEX8w1469GDv+5tht7AvkFyHxaoLaVANJpv90756LIlIme+g7diqz5PIcZ7rpNw8uBbeyapfpc7cEvjd3yWDG18ps5iSPNL5HWmYRmEBq/oYH3kpJ7Zx5rl/QCO0PBjUHFewxyfNQnzr+RBd6D3ifJWlwE72QUBKplJ9HKIZZkoMs8fS5tjRHBi104pwfEKWdVhhwlNJHCDTXCV0bUTRfR9C2259JZAVog0j/klbowZPOb/WH1UEKPprguot5R70lDbdSdtU6oKAC1Uqnq5K/A1x6/33yL/PNDGeK6UXORGb6VctjZXPbvnGbMWl6fwOS0Ecclh
 fydFHPm9
 dY0owPq5dlNlvghYMkWSgMxfChmF1+Y+CK4unHAfN1StrdJqQLqmMbhAnD296KS54zIjDDZwNTAN8LBLiHiH8/xIusOhlAvQjrFv6vttaVUwd/3fGNFjb5oOioZ7jGdyASBsxtV2HYY2/j+dpP22P54Ysk8wnDGftY5/SsX5V5kZ5pRBBQV3iMu9PMB3g6QqbMLWh/gHb7pmMseZIfgTAnvQFM3Fr19+duJ4+vcBnsX5ILbHU9+rswELfoi92eLtIw3hgHXjpFOJ/1xktDmbPvDNZPeZw9GCdNk6vSa7F5AZu7oy1RYxkvSW9Sa1REuozCiRX44ychZ8RVHu6hCYSd1Exlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 06:41:55PM +0000, Shivank Garg wrote:
> clear_flush_young_ptes_notify()'s last user was removed in
> commit f3c493d2f42b ("mm/rmap: handle device-exclusive entries in
> folio_referenced_one()"), which open-codes clear_flush_young_ptes()
> and mmu_notifier_clear_flush_young() in folio_referenced_one().
>
> Remove both the CONFIG_MMU_NOTIFIER definition and the
> !CONFIG_MMU_NOTIFIER alias.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

LGTM

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Applies cleanly on mm/core.git/for-next.
> ---
>  mm/internal.h | 12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index b129510b92e2..b1f3a1a59bc0 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1598,17 +1598,6 @@ static inline void maybe_rmap_unlock_action(struct vm_area_struct *vma,
>  }
>
>  #ifdef CONFIG_MMU_NOTIFIER
> -static inline bool clear_flush_young_ptes_notify(struct vm_area_struct *vma,
> -		unsigned long addr, pte_t *ptep, unsigned int nr)
> -{
> -	bool young;
> -
> -	young = clear_flush_young_ptes(vma, addr, ptep, nr);
> -	young |= mmu_notifier_clear_flush_young(vma->vm_mm, addr,
> -						addr + nr * PAGE_SIZE);
> -	return young;
> -}
> -
>  static inline bool pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
>  		unsigned long addr, pmd_t *pmdp)
>  {
> @@ -1641,7 +1630,6 @@ static inline bool pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
>
>  #else /* CONFIG_MMU_NOTIFIER */
>
> -#define clear_flush_young_ptes_notify	clear_flush_young_ptes
>  #define pmdp_clear_flush_young_notify	pmdp_clear_flush_young
>  #define test_and_clear_young_ptes_notify	test_and_clear_young_ptes
>  #define pmdp_test_and_clear_young_notify	pmdp_test_and_clear_young
>
> ---
> base-commit: 2683df3b7eac1d91380194955ad0c9751454610c
> change-id: 20261109-clear-flush-young-notify-dac8b5496ec4
>
> Best regards,
> --
> Shivank Garg <shivankg@amd.com>
>

--
Cheers, Lorenzo

