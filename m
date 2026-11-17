Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C642606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IfpL3SzR
Received: by kanga.kvack.org (Postfix)
	id 1972B6B00EF; Tue, 17 Nov 2026 11:34:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E2B6B05B0; Tue, 17 Nov 2026 11:34:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085666B05B4; Tue, 17 Nov 2026 11:34:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCA286B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:34:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 782A91604C6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:34:35 +0000 (UTC)
X-FDA: 85445159310.06.54FAD2C
Received: from mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 263A9C0012
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:34:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IfpL3SzR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794933273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEEmq1dY81wdbCeTX7SttAeKu8NSqyPmmLobfOaFWuo=;
	b=Uzdl9ReVCBjt/Os9ph8K4BU2Akw3LJ+wB8RVICYOG7FVQTP4LnwcBSfgASaSfVjuKQA4Uu
	mihJfzdzdlrMIzyfHELn7Hu58PoyQrRvvhqFUebiczP+giTAek0x71Z88lN1KMviFjyPmr
	6T+86xr4CsInSRls8KBCS3UzliDr9V8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IfpL3SzR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794933273;
	b=dnNfSha22U+P97Ldl37vpAdnGsUaxVKVG1Zg8yI9M1rXCXTLnmq8qFOT/UUSanvuuB6BQU
	4EmIt+U9+jjQINrohfa+Mrt0Y7N2sRz1xNzVikjYYHAP1rH+/cF27DezUFOEPOuN9W+Zox
	hrFvrirxWCTSmIOswk6ZKkOg4nsC3nk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RJgmEkz4jSKky+L1Q1MlhqmjHI4xCv6x+BFHapl0q5g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794933271; v=1; x=1795538071;
 b=IfpL3SzR7Nvihq9US39Oqm3zkEnRicLRID6CM6pD9965dMcj8R+v8Pg6U6oppvPgNyt/bCoO
 4ao82qHM39cCYvBWukc+QdjG4GgGFyXkLMMzDeysMwKkJyNztktyJfXVGjV+hiqRWDIN/3rlE59
 dUdRes882EQpHe6tLSNPhUH0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 60d8652a3546647f;
	Tue, 17 Nov 2026 16:34:31 +0000
X-Mizu-Trace-ID: 60d8652a3546647f
X-Migadu-Flow: FLOW_OUT
Message-ID: <a852dce9-4ece-4508-8e07-89768cf6713e@linux.dev>
Date: Tue, 17 Nov 2026 09:34:23 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: mark ptes dirty and soft-dirty on mTHP
 collapse
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>, Daniel Wade <danjwade95@gmail.com>
References: <20261117-khugepaged_mthp_dirty-v1-1-024e4a12c2fa@kernel.org>
Content-Language: en-US
From: Nico Pache <nico.pache@linux.dev>
In-Reply-To: <20261117-khugepaged_mthp_dirty-v1-1-024e4a12c2fa@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 263A9C0012
X-Rspam-User: 
X-Stat-Signature: 37bi5nh7mp1irdpawbtngb71iqoe48cq
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794933272-361991
X-HE-Meta: U2FsdGVkX1/hHb4sVyZXAn/98r9L2ChsabpJWC4Wf6C0yXIStDMyFOqbsH8EpqRBVa2Cy84fd0qbBPhQXs92/djdIYxDbqvpchhwXyCeqW1SREMAawLrmT5qpp50nkD4t4iOkU6k7lSdJCw81freRrf78XpMdeNU6JBMR1kJjxNviUv+xXDnP06xh+tj447/fm8kxjMgieQY9sZICd5Ii/u9gRaY6EDDCUkJxedJVwYxvvquXGId1JwQKewLEob2euGp5aVx4Bqed6To2MVxEkj66EQ6fv7FE55SzyuIB3gZD/3gjcyTYbCtOG3e04G7AigYFshMtBEViZXbLdQbNeFu5fMqf6jhmAQIgT8qqBgPn9hP80WT0uDv4uORDHZmdcJlTEefLJZEiJJDFOuGPY4koOHa/6WTe+m1TOgm5BdEQMWPfEEmAjf0B1Fa/PL5SlVNWiSuCLlpwUwSFQJyS0Blggpbl9+6ceguftcJKipznUu/MXkm1oM1eVVpkic/bzaVgyYfkMwRtU+VMg783ujYdrKFonJ76xGUqn6xVkP/ccqrq0NyjTVvuZOpXHd79388jY01/TZHo987IuM+J2LcpXiJcSr/cRmYgsaEXVCck0rJoU8MHPG/qRiv0kk11wbgmJcC2c7RavDZcKlM6OorUfsbUf1Cz3H6lqwKVMTm8tpybYXSNavEa9fl85385yxZTCrANMukxE6uwdQkpB6OLS5Y7YA0XeVTYCuTd1kvraihL37u1i5pdmgRQjRU4Px812c+R378Z7taujFm+n0P61OSjEWVE4668ylJlis4tPD/EXcaa7ixohYdSaLbqZNTXhyeiGuCl4QpbPqVKs0LOUppRkKV0m7wlhCipKlHlh8JexYszZ5rvItxrzSR/A+VR4oN3z2Xf3Uf4gMR1wF2AVqHLN6bHOWtmtuwy11eTN9ILU9k/cICnAu8KsTC8W/478G1M1ABK8eXMEh
 TIcHE2Ha
 LOKPURiGzkKXo11Pz4ZciMSw/z/sAysgsbvq2VzOA04ny2CH9TNShQVZ0Gu6fHQyZMUPAtndcQ1LpONiodDQn0M7/KqXIDETiUIJphISu6eZwONLowHql5wywjVVt14GFfYt2ko9i0zbvxbRsMxMAhi8o9U1Ze8FteI4FqEpMOcR2B2nfo8Keo8lFCtvbr4Vc9Fv/NwvOSiTlEBydind7EwRWEbSKLIYspHEWpwAmpJlVmMOYsbGPnLficNjerKUVEQnwP0PWHWgQmiAABCCA1qfyxYo9O3nc4ifEOJjFIfZmKY34nCdsT4U1MQ2ai+4RsO6Rbtqg9xBf2Wk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/17/26 2:28 AM, David Hildenbrand (Arm) wrote:
> An mTHP collapse can lose soft-dirty PTE bits if pages were written and
> the VMA was then made read-only, and not setting the PTE dirty in
> VMAs without VM_WRITE can interact with a later MADV_FREE on a COW-shared
> page such that all processes lose the data even though a single process
> MADV_FREE'ed it.
> 
> Collapse does not preserve the soft-dirty bits of the old PTEs, so the
> new entries must be marked soft-dirty. map_anon_folio_pte_nopf() relies
> on pte_mkdirty() to do that, but only calls it if the VMA has VM_WRITE.
> 
> Further, after CoW-sharing such collapsed folios later, all PTEs will be
> clean and the folios will be clean. One process doing a MADV_FREE can mark
> the folios as lazyfree and result in all processes sharing it losing the
> data once memory reclaim zaps it.
> 
> In map_anon_folio_pte_nopf(), call pte_mkdirty() unconditionally, just
> like map_anon_folio_pmd_nopf() already does with pmd_mkdirty().
> 
> Consequently, we always mark these PTEs dirty (including soft-dirty) but
> only set them writable if the VMA has VM_WRITE.
> 
> This essentially reverts Hugh's commit 1ac0cb5d0e22 ("mm: fix anonymous
> dirtying") that back then touched do_anonymous_page() to avoid forcing
> clean anonymous pages through swap instead of discarding them. This no
> longer applies as shrink_folio_list() allocates swap for ordinary
> anonymous folios and unconditionally marks them dirty before unmapping,
> regardless of PTE dirty state. Keeping their PTEs clean does not make
> them discardable.
> 
> This now also marks fresh anonymous PTEs dirty and soft-dirty in read-only
> VMAs when page faults allocate real pages.
> 
> This has low urgency.
> 
> Fixes: e22f2fe72c74 ("mm/khugepaged: generalize collapse_huge_page for mTHP collapse")

I was just thinking yesterday: "Im happy the mTHP collapse stuff 
survived this AI wave". I guess I spoke a day too soon ;P

LGTM!

Reviewed-by: Nico Pache <nico.pache@linux.dev>

> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Reported-by: Daniel Wade <danjwade95@gmail.com>
> Closes: https://lore.kernel.org/all/20261117075246.61336-1-danjwade95@gmail.com/
> Reviewed-by: Daniel Wade <danjwade95@gmail.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   mm/memory.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index d2f48d78b0d7b..45875d1d3b3df 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5522,8 +5522,7 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>   
>   	entry = pte_sw_mkyoung(entry);
>   
> -	if (vma->vm_flags & VM_WRITE)
> -		entry = pte_mkwrite(pte_mkdirty(entry), vma);
> +	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>   	if (uffd_wp)
>   		entry = pte_mkuffd(entry);
>   
> 
> ---
> 
> base-commit: 1c2962a57377c9878cbefb747488324d4e678982
> 
> change-id: 20261117-khugepaged_mthp_dirty-067f734d38aa
> 
> --
> 
> Cheers,
> 
> David


