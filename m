Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8952C606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O0VAwbxv
Received: by kanga.kvack.org (Postfix)
	id 9E2A86B05B2; Tue, 17 Nov 2026 04:41:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B9C6B05B3; Tue, 17 Nov 2026 04:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85C2B6B05B6; Tue, 17 Nov 2026 04:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66FE56B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:41:08 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9C42160396
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:41:07 +0000 (UTC)
X-FDA: 85444117374.24.A2D2974
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3C137C0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:41:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O0VAwbxv;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794908466;
	b=aSngJ0LnFadfqw81qA6NP4FVgW5CEa3Uiuik5fnDqRGs3mcqZNVjFwimXyUlrEkG/DwDaB
	fdqop9V3HRaaL25ZjkQg6AacdsLqGEV0bG68N9SorDcHeRKetGdlotteJtoPHkqyUpt2EW
	D0N6j63HGJLabtBQ/5BtrpdTNOoJBNE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O0VAwbxv;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794908466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3iFdC4kvUX11Us3pNRfwEgLX6l6dmfhvWxrnpKmb54=;
	b=hTuldn8Z4KgRM0kNL7v4l3nnjUOnEu+dTa1fLKnZO8pDDY+Qv+Mw68SVuR1d1JMtOLEd6+
	PSI66atKUrlluhVj8hEpdt9KR/hWnEt3K8Y8vb1OpaOYkq+rXAe0izNNcykotcP2kt+KR2
	jQKP5mH9tRcEsjOu8QXDVlbW1OpC9R4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7017840449;
	Tue, 17 Nov 2026 09:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEDB1F000C4;
	Tue, 17 Nov 2026 09:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794908465;
	bh=b3iFdC4kvUX11Us3pNRfwEgLX6l6dmfhvWxrnpKmb54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O0VAwbxvvdV/COcwnjk9DUI1gzqKmA5WOW6yybIKHp7iL1VZs0zyxDA8bU0Ax+SDz
	 a5/x+uOnG73FmZfXWfFDvUTBmbc/Gsxc3qHa+EfcYchf2gO2o/ZMqdNDgtseFRtXDI
	 JXrGvOD/S5KgB3czpgF9hF1S7VenW37S5aIX1ZUnkOZBGPumAunw4H9od/rVQGuSSE
	 zIXcVmc9fCg0VV0PdjHNH4VqJlxh73WMqxF8VXUDBNPWmRqOKLkwWyzJUYAyKrj1ka
	 e7IjzRiS7ROcUCXVixjLwRQjs4JadJsIIMW4j43IMa3kQhgObLgpLv7uxQ7TtUvSnp
	 cJG9oNXGFA8pw==
Date: Tue, 17 Nov 2026 09:40:59 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Nico Pache <nico.pache@linux.dev>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	Daniel Wade <danjwade95@gmail.com>
Subject: Re: [PATCH] mm/khugepaged: mark ptes dirty and soft-dirty on mTHP
 collapse
Message-ID: <avwhJHQN_w5nUbzj@gremlin>
References: <20261117-khugepaged_mthp_dirty-v1-1-024e4a12c2fa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-khugepaged_mthp_dirty-v1-1-024e4a12c2fa@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C137C0006
X-Stat-Signature: wbaozfdjwwm6q9wbzdu56c5tjteyatbz
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794908466-604413
X-HE-Meta: U2FsdGVkX1+T0fmyEciG78oRJEgeTOo/XTJwG8r2EkcuXeT77j6nFQT6d+cEs31Fq8rFKFVjOPdgRbjSXmBL2nlxCxcNxdp7C6K6SIV5lfYsfIs172vl6VCMRc7jBB0h5Hna4hd0bxX0R7F2BCc3e3QhP7I76d79YsITFVR6v/woXkTd6tkh2i/dtAtve/CwUOMlEQJCMbYebUiRJxsEfdjgrMjhj48USW5xgnJiT5UGrUtrdf8N4dy03occOYWr3QEVdMFqChLkyB/4fYX5fnIAXX8uGOMQ+YfUEFeCNCIowZDLc3Lgh5qG9ixRjdxjtpGRcVhpBMHEyVIZcoErFhDDlXej29lboatXFRLLpXie27I0lOB6JNmVDg8RwKQGhVKT+L31EjJ/LTdBq1V5TguhFBAb0Fnmr/TivX4BPxYkPG+x/IPjoqBWsKPF68iyj/q6equgInCklZOG6g8siOC/3QAqwD5Fng5qZSxzCGtws3SZHUF1/XUvyx4Fy9xjV3ftE9PuYFTPi1Uf4xlp1w7Vfu4CnogdaLw/nN1w7A8rjUJRYOrnX3tK0N4frp6x7GGfqZoZVCrurPkICYENgitwBizIqh7mp8KosNsQhn8SWvyCnSNmsIcH8EOGtrk82LxBu/CrCSbog1tXP4rCB0pMWrayh0a62LWATxTVFcz9wpiR6xyVQsUSJt8Zo+IfgV50ItL3dGd2C6N0HLBIYPRzl2MuxeX6+PAwKIhRr0jwGBkeqxEV0yFr0+jxjwmXWcvDVjSf+5wS2pjS8TcnmUKWIj7PtXgscmypRcF/0ikWIbm9EDQQ6QcyaWEQX0rlATjjX6q/fZCQA+aAJmCGkb8chsychKTAD3eHj3IfmVweruWfDLUPrvQrGnUJ9mGE5v+c6cRC28+PudI0iVaQVBgmQ/5lEfoUmKH1Q622Mf4cDnUfIqEMdJSzgDXKV/bxm28J0QwAo48zGIifidO
 4w4AVrem
 dH6HZexMGmr6pcn7SXH91Zi8/T7EeVBy+vW+XR35e7r9BvlvFMS1X9h2Cr/6YStPKGjQ6jqvHIORLPC0gVDCxDvdz2KhhuBhkRAbWIOJ5F23JbjXcbSwdDhJ8RHNJegNKqjSXh725Vwi0fZgq73IQ0K3XAuLOWxo3SjW7c6/d86oIkRDL3nZuAqnX+a/T+nOMKzTj5LiFv0ZM1BENWozCOggoAp+173/sytPflTCLM2p4ujREsVrMrGcnHCBeM3TJkAiou7A7fg1yU0fEynzd53DTBtEciOF0W4U99KWQxUtadAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 10:28:18AM +0100, David Hildenbrand (Arm) wrote:
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
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Reported-by: Daniel Wade <danjwade95@gmail.com>
> Closes: https://lore.kernel.org/all/20261117075246.61336-1-danjwade95@gmail.com/
> Reviewed-by: Daniel Wade <danjwade95@gmail.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memory.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index d2f48d78b0d7b..45875d1d3b3df 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5522,8 +5522,7 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>
>  	entry = pte_sw_mkyoung(entry);
>
> -	if (vma->vm_flags & VM_WRITE)
> -		entry = pte_mkwrite(pte_mkdirty(entry), vma);
> +	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>  	if (uffd_wp)
>  		entry = pte_mkuffd(entry);
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
>

--
Cheers, Lorenzo

