Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE0A6606A334
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 20:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDueje2g
Received: by kanga.kvack.org (Postfix)
	id 10F906B00EF; Mon,  9 Nov 2026 15:50:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0036B05B0; Mon,  9 Nov 2026 15:50:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECAE46B05B1; Mon,  9 Nov 2026 15:50:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2C316B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:50:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D0C8807EB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:50:14 +0000 (UTC)
X-FDA: 85416773148.22.255EE9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78F12180007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:50:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDueje2g;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794257412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+OMth3PG85AL4kECknkxpCnD4PaCA8VlkmtQ0uA4Vxo=;
	b=vi8LELzCHz29QqQWY6uLzHVogPR/ebaH08c3zEx+tqnbl8SkIF8wdNmO/79KBekQFRsqmc
	qzxiwQHuDs4cbGiU3at+9yz3nsS2zczrWxLJxgg0PDEmqFE/fsopWNyViCD2PPuCuNTscG
	OdiAMbdLwCQ9nsRiFq4gjPqezC2qFms=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794257412;
	b=WynvwZxxGlUb2PAfCTUt4Yw/jZRq3cCbghcdwocqKZ1rnjX9qYoD3gCW9MfZY+QjX1aLJY
	GqMS2P/7+mWqpdDgXDBLmKqHPOm97l+5IJLsRJ4SeFHhCuYQyK9aOw6CUhn61CIXKTbTSt
	cpGgrUcunycWwziIWBUzQstiSN1ZeKY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDueje2g;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 944C443830;
	Mon,  9 Nov 2026 20:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D582A1F0089F;
	Mon,  9 Nov 2026 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794257411;
	bh=+OMth3PG85AL4kECknkxpCnD4PaCA8VlkmtQ0uA4Vxo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iDueje2gQCdXWNWbQrEXkn7wfOtQOBvJF3tKjNmoFN8dXBstJSwWREDHMX31AFHrK
	 p/DKtQ6xOt3M5j/yTG6JT/oQyWiVzcQ94QuqgaEdoMAg5gyKl5ROwTiG4LLOB3vppg
	 TyEWwcISD4aDsGU70Xupw18WZwQZM+kpYZ9yDIeXl2oFwS170JQo2tM9vGvMZfeQbh
	 wnU6Mceyqr3y5/cLUWyKuV0v2pn0q2GMkl3nYGpu2FT9PdLKWn2bybPHFliWXlRpJe
	 ZE+4IJeguIrIz5A1bc+7HK9FOAiBJFWHnIl+blYZoDCCQeHlgUc9/OxDiyEXoGPQKI
	 nrf8U6+N/0keg==
Message-ID: <e0374a55-a7ea-4ac9-a6d3-95ac9526be9b@kernel.org>
Date: Mon, 9 Nov 2026 21:50:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove unused clear_flush_young_ptes_notify()
To: Shivank Garg <shivankg@amd.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261109-clear-flush-young-notify-v1-1-b37fbafa2686@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261109-clear-flush-young-notify-v1-1-b37fbafa2686@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: a7dcafuy9z939gk7c1339zkst5o9nxky
X-Rspamd-Queue-Id: 78F12180007
X-Rspam-User: 
X-HE-Tag: 1794257412-339415
X-HE-Meta: U2FsdGVkX18rRAYYRKt6v0wIxubnXxoejdw8rfD0cwBvVVbZw2xWsJ2Qc3S/RuPpSELp8SBfjZpeyFvV0D+9cphBZLVWPUG8el3ujhrLd9Sb2Z4dZee2n2IjKfMOMVsg8yJS606dfOvhTZY6v9oTWHyA0U/tgythDitrldLPa9Thi9RiWKIZCuV+XRpOD0oZ+/ddAoWOWPNLDRuE87PPdKmWfU2YMDCEXR18NG4gUFXXBH4UZN2qefHrzM8p8HKFt/wUiZi7WqvR+m9oJUPLD2Ft1WBAReNL8s2aLff9KveDmQrV1m+JA8H5njymDv70lMXOqNuyRGS+l04f7rlw73BkyHLB+DlcZIFh3ZrzrCMcDDxD5MTx50WCJ8rhIG7q01M5OttIhDjXBLhNlCJ+r2EUKQHC97d6+0rEuEC9UZEMzifbTkIxM3Wl0DG9lZAHTSvLGXQzmlnvbPZiEyr7ZtW2Nuvnrf/mLS3Pp7uWRjpFbPUCGRBf57HM/Y+C+Bs3Ju4Z4wb6gm+HDDOVOFWVmxHUBNwJoDs7GD7s5xT1DHsb9EtqwDgBrmZAyVmxXGhlS4TS8gXvq/1BJNzGgTCVY6KxJd5O9aTWfn06VX8zzNoFH9832NcTp4+BJHhkNmyiZGiSZqL41bnAfw6oB2b/Wrl85WxMk4+h8chgrTlxsb8rXyRSjXcmFA0LOmS8tB79LhLJ024I5seCo+2Jb7g23qXH48X6vpftKF+hUzd41T7S/87L6MuomJiAfeIR3Lmqm/r+/31Qwezo55+3HkGhLWVhQkmCI5bsqLUyoH1RHJ0m/yRL2+wn/zSDuH7I5YeqE6Cw0pME4BZPM9xb2M4UbR1tVecf19+lejYLp3jOw7zc03F9XFvAT+e+flb2zJ0Ef+UNmY88K2xUBPjnoJKK7I0aY2MbkAzkNu61z1ibebXRo55JF3hyQ7gQR5Rw/Nh7XDgo6D2aGteAf32acXH
 1ukTtRiX
 mndk2gumlyanLDIGvZj4+4PU0WdMQkU5PB19kdE6uCobJlsMsvD+6gvzPwrhNCGej3mG/3uh0Vc+3+Jxys4BuGKA9MMz59iJagSxsW4bDRunnXiTzUm7lTM8kC3uZDq0cFLi8MLzL4l/8003nKOeluHTnd6zmqYwcdQWJEJWyVsuuLIRqRHp/ts0w1iyaO6TL2FxQfqjD7R9InyqEbuNfwOlJ34X5oqNDS+OiI4fvLydzzwrCE8WqPTzCdJvTj7z3/vwTMfqfo2wXscKtFhb59krn1Hjfe1gvQTYe9wcXf/dxQerrUA6KhaTxMsTS8nMYaw66dKloItEdj/sGWDlBVYufPRGGMTg2ucYd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 19:41, Shivank Garg wrote:
> clear_flush_young_ptes_notify()'s last user was removed in
> commit f3c493d2f42b ("mm/rmap: handle device-exclusive entries in
> folio_referenced_one()"), which open-codes clear_flush_young_ptes()
> and mmu_notifier_clear_flush_young() in folio_referenced_one().
> 
> Remove both the CONFIG_MMU_NOTIFIER definition and the
> !CONFIG_MMU_NOTIFIER alias.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
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

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

I'll wait a bit and will then queue this.

-- 
Cheers,

David

