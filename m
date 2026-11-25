Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D281606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dMvGTc3g
Received: by kanga.kvack.org (Postfix)
	id 9B66B6B09A6; Wed, 25 Nov 2026 05:32:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98DD76B09A7; Wed, 25 Nov 2026 05:32:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4256B09A8; Wed, 25 Nov 2026 05:32:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 681586B09A6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:32:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F085E160D52
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:32:46 +0000 (UTC)
X-FDA: 85473277932.28.9D3B9D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2EB0780007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:32:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dMvGTc3g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795602765;
	b=YUcQjrrLt27I64oxPgseqaqr8t9+pFSJ3dSLe648cW49sSLUvBSwYcKIzQuJgXzJ7eICNN
	Zxt+Y2lg6eXPzPaCHz9cKjFTEwHSK7ifkJpDdH2FwJXg5NAj3OmCTPR4ExbB8TZ/KzxegE
	Qta5RO+BSM8KxvpPrLPGMd9b3gLrQPY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795602765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXCkUOXDF3I36axi5vCtjoemJxQ/NJLR6K6kMo135mY=;
	b=LVJ1GYSG2DzsPt0IGO+d9pkjYyCn8MC2YqQ/HJxDUHJZxx5MKACgP3ePSn7MHsP6MaoC3K
	ZJ79x1TyumPKGxAH7T4Ke9bhugvOTAwRaOVLpXF6I5LQqAtzAIuc+Shy+fbsGedI4yXtIv
	cMm9KvJoq9xwCNarBCffvPbWyEGrTKI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dMvGTc3g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6708041FEF;
	Wed, 25 Nov 2026 10:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061D51F000C0;
	Wed, 25 Nov 2026 10:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795602763;
	bh=TXCkUOXDF3I36axi5vCtjoemJxQ/NJLR6K6kMo135mY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dMvGTc3g91I7s+GClN+r5DJOUK7vt/3ZP3Ee5JXCT5uyb7zD8tIxpDIXDY5nQFVjf
	 xILdDYJUp4DF2mkplQ5Q6rfoFS7/+wICChtkV+bGRod3o3AozgaG9oPliOO2eWdjPN
	 oXoMAyEmxqEcEvx2aYqN6FNjYElM87maQ41FTp4GWWjqX7pL4syqb7RqCx3Pfu4BT+
	 PZbTilhA4sq0cB+dRZlqBDlBp+HTiZ6TMAaYeVTYvc4+ZxVqZLgBSKoS1o+MJ2ptTY
	 oBkbjX9txmy2XXoO2Ft45LfQdRcyfjhT7av8DrXBE1dZCvqjKEUxI5hUzJcaewjNGo
	 Jbypigy2xTSTQ==
Message-ID: <1d53b4e0-a442-4964-af3b-b10f8cfb1210@kernel.org>
Date: Wed, 25 Nov 2026 11:32:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm/ksm: do not inherit ksm_zero_pages counter or
 PTE markers on fork
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
 donettom@linux.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, Karl Mehltretter <kmehltretter@gmail.com>
References: <20261124130143.128411-1-xu.xin@linux.dev>
 <20261124130310.131140-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261124130310.131140-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2EB0780007
X-Stat-Signature: k69ixiwk1prymp7nej73gin98ue5nw1e
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795602765-316156
X-HE-Meta: U2FsdGVkX18GqGjQk0UfdiVHnuwvMjuMP41GqfkF2PO2m1IODxrVcxSUoS/J6EsAAm5PcFmqdzE9Ma8QaE7C1iI33uj9FgGW3Vw6ffA2PUZYtLvo2nUkXUR6YQprXmbVU9sqf+ufbXbxNiawjdL5/5LbpjFDBbihPHrJobePKZtX57ij4zswpJeVd/OPmeciaXOePGiE1g5mmSRYQY37psp/m54OtjM7PoaemejXdO4BKkNt8/RKLDeDbzKr9oTYz6y6FYb6bidCEfRXSyZoMmIm5OGzdwNSXiOPhAx3QkB+KlRrnVLL83ZsGqsAbtiogpVCWBEEosgbsQVl+CUym0ca6I+EO4vzPkWVz+rZ2h6Sty3p38ZfpEMV2TQYvOrbNEYJGOM24ZyFrBTcOFmsinIqVP36EYpS+rfUre6wzxRK0daLObXzEYqVGiZcWaJAthTImaf3oKnflrbsratd7UMe+StAn7y4jGMNODYUFUTTHgG7eXtB7tpITdyIGzSIHVQgFXLaF9xohc25B++5ZtTjuGOgpAogeoLO3z07bv0HTrAw1FbS0NMIH2H2rEayKgMtF4uVWrjj02iG2Nrk1HEp/3gJ+zm2ea7XpuikBbzV3osmXHZspk6x2a9PQ+WtdhowAIAZlL5sqgLfQCvtzJDAk6/iYyPtlRG3mMCwiTMTDulv5cICtV3smjmxcg3QxVClk0mU3OKtTuLY09IzZxJRWFxfppu7T1e2hJWaAQdkwMHNvvRBnFqHyyyoSxEwLqvMs7BpdIJBv0HL5RCWlLZJko0R3beYqY9LdA5/LvBJreC3//jM+BvCopEXnhCZ/6nfJg/TWv95ar6mVW23o9jMp99UWskBUpmc3fmirGQcHwDFbvGXrm7kgmAKa3QkRilF3CEg4utxbaI/F+WxEdkIDm+p11yapjhBBUzSPC4YvhucS+TvwEsgvc5lyyqhz1/n2+X0TmB3O/vpNFC
 QsYQ3E1O
 UOj5nwTd3SLHYsBipyep5x8KAc0ANoqeOzpjct73LrMapvZ6hNr/DEmI55hfPvKHqoZszP8pB8NWhNlAG5UUIx9HOStQsoPiQSFt+66dp3Jv/HXeLIUFe4ena1hb5u3Jx9YPVVATOrRChX/IA8cBJeHI7xwwIalxVnpN+zf5aetp4G8G+sxTQnejdWRXc7Hq0stFUuQ0x5fycpSeEj02WKtrCaPW5b+6/Emu3NfHb8Mj9AD9CDBRG/RGjI2e38IaPOtHvvAJNp9W8r8HLWXd7hPEoTEna8w2WUIeuTgcijQZs3PSdUJXePnjNt2+hNEYKfJ1gHxnuj3OEG61EoVEKsOT2YuP8vvP5XK5QVIt3qZIsoDh4XvjpFy19ydVm3Wct9WqobQwV0kdTanO4s0V01BJEoge6q2axll7Hh5YrFuvDW2id+/JtHE6ZNhNkELra3IZvAs3DiGA4n7vjsY90t64dwhSUvFCXt+T/jjSMvh7vZsY7j8OIU3fNS/JdShyuUVzFS+73wfCs+koNFvrY5TTOU5lebslMb7WaajIM2JwYTGR0CPUmvoL24SYBcQvvukyBSzES+Q3AqPHI5/szkPwDHSbkT9S1Cuy3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 14:03, Xu Xin (vivo) wrote:
> As documented in Documentation/admin-guide/mm/ksm.rst, ksm_zero_pages
> accounts only for zero pages actually placed by KSM.  However, the
> current implementation wrongly accounts for forked zero-page PTEs as
> KSM's contribution, inflating both the child's per-mm counter and the
> global ksm_zero_pages counter.
> 
> Originally, commit e2942062e01d ("ksm: count all zero pages placed by
> KSM") marked KSM-placed zero-page PTEs with the dirty bit for unmap
> accounting, but forgot to clear this marker during fork().  Later, to
> prevent ksm_might_unmap_zero_page() from underflowing the counters on
> child exit[1], commit 4d6fc29f3634 ("mm/ksm: fix incorrect KSM counter
> handling in mm_struct during fork") kept the child's inherited per-mm
> counter and added it to the global counter.
> 
> Instead of inflating the counters, fix the root cause by resetting the
> child's mm->ksm_zero_pages to 0 in ksm_fork() and clearing the KSM
> zero-page marker via ksm_fork_pte() when copying present PTEs in
> copy_present_ptes().  With the marker cleared,
> ksm_might_unmap_zero_page() will not decrement the counters on child
> exit, MADV_UNMERGEABLE in the child will not unnecessarily unshare
> inherited zero pages, and the global counter remains untouched.
> 
> [1] https://lore.kernel.org/all/53a7bf3d-843d-4e19-b0a3-cc6852fe72c1@redhat.com/
> 
> Fixes: 4d6fc29f3634 ("mm/ksm: fix incorrect KSM counter handling in mm_struct during fork")
> Cc: stable@vger.kernel.org
> Tested-by: Karl Mehltretter <kmehltretter@gmail.com>
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> ---
> Changes in v4:
> - Replace the comments of ksm_fork_pte() with what David suggested.
> 
>  Documentation/admin-guide/mm/ksm.rst |  7 ++++++-
>  include/linux/ksm.h                  | 24 +++++++++++++++++++++---
>  mm/memory.c                          |  5 ++++-
>  3 files changed, 31 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
> index c329ca747b8c..8968ae3f55c0 100644
> --- a/Documentation/admin-guide/mm/ksm.rst
> +++ b/Documentation/admin-guide/mm/ksm.rst
> @@ -214,7 +214,12 @@ stable_node_dups
>          number of duplicated KSM pages
>  ksm_zero_pages
>          how many zero pages that are still mapped into processes were mapped by
> -        KSM when deduplicating.
> +        KSM when deduplicating. Note: on fork(), the child process does not
> +        inherit the ``ksm_zero_pages`` counter, and any inherited KSM-placed
> +        zero-page mappings are converted into ordinary shared zero-page
> +        mappings. Consequently, these mappings are neither accounted for in
> +        the child's counter nor unshared when ``MADV_UNMERGEABLE`` is called
> +        in the child.
>  
>  When ``use_zero_pages`` is/was enabled, the sum of ``pages_sharing`` +
>  ``ksm_zero_pages`` represents the actual number of pages saved by KSM.
> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
> index 596c04ca7326..276bee5af80a 100644
> --- a/include/linux/ksm.h
> +++ b/include/linux/ksm.h
> @@ -32,6 +32,16 @@ void __ksm_exit(struct mm_struct *mm);
>   */
>  #define is_ksm_zero_pte(pte)	(is_zero_pfn(pte_pfn(pte)) && pte_dirty(pte))
>  
> +/*
> + * Strip KSM information from the PTE for the child to simplify
> + * ksm_zero_pages accounting, and to indicate each deduplicated zeropage
> + * only once towards the user.
> + */
> +static inline pte_t ksm_fork_pte(pte_t pte)

One nit: this should be called ksm_fork_zero_pte().

I can fixup when applying.

With that

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

