Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA76F4368E
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 10:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499866B00D9; Fri, 17 Apr 2026 06:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470D96B00DB; Fri, 17 Apr 2026 06:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311E96B00DC; Fri, 17 Apr 2026 06:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA9E6B00D9
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:53:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5811160B91
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:53:45 +0000 (UTC)
X-FDA: 84667737210.03.D24F38C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2168918000D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:53:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kiRbc4j0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776423224; a=rsa-sha256;
	cv=none;
	b=X/0V19BIoFkSimjPjdtudtzPAgNdx9LCRpwDLQN1CbahkOflVEqc2l8Joc5CIam2rSRyZe
	foRIfQu/DfWX5LO1ZSU8ZMRT1svxi0GcFfnuV2QPNatVAN7yhgZphz6cg1U50FVqCxpkaW
	4XMuVzwFb2soEpRu+h85lQE3/L9UBiM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kiRbc4j0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776423224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pypd0oo9DjJoDB6jMQaUIrVB554KwtN2fUJtBGmKZEU=;
	b=mCJ5Bhqem1R4Uy/yxWlRYXIQ7WDbdiAAh7OP10IrJfeSfCDlQ8iRA/QkFVc9nZZVBsQLBU
	AlPrHXaKRILrcTscNJ/xqMRI8adqzYh1063sMn3+Um2MA9xnaOC4q62zRRxZ3ZYcZ4YZSn
	SAOtYnYZ0CmifC5OjZ0oFmOrSMC619s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8310660180;
	Fri, 17 Apr 2026 10:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4816AC2BCB3;
	Fri, 17 Apr 2026 10:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776423223;
	bh=Q4iAYpxOXsLj0oOnh+Wyu8n4Jy+Sax3z4g38z+Vd71Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kiRbc4j0nRxXmu6WAUKM5hJlpAnDjDep590MNd/jAnob9geMeFguPI2hM4b81LTzx
	 qHeN01mxoVcke3G0RhF5gC72xk2bp5Ur9kE/ssQFLeW06NgJL/EMJCTPaOvYoMEhpT
	 zEhOgwmKOIx7eDjuSyoM6M48g8xGniE/uNakksHOD4eC2Q8dZd4pupuiNrkSO9NuXl
	 sMqM8Zd6gc6eAUAFlk9jDKd24m9P+AYRR2124+UaMCmHiykTBMKHBjck8WlgEDM1WS
	 QvmPmgOcek9lnyUO+8SP6TK7KdbYfrudgu/nOAlDt9FRYrfYFNLtMoarD2O0dLpUWk
	 s+9YE0om4kxoA==
Message-ID: <66f67e51-819b-4c60-9f61-170db32362a2@kernel.org>
Date: Fri, 17 Apr 2026 12:53:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: prepare anon_vma before swapin rmap
To: ZhengYuan Huang <gality369@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, willy@infradead.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
 r33s3n6@gmail.com, zzzccc427@gmail.com
References: <20260417011606.1089985-1-gality369@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260417011606.1089985-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: dz45qffsxcx9qmbucn4iqbpgjkzun7rz
X-Rspam-User: 
X-Rspamd-Queue-Id: 2168918000D
X-HE-Tag: 1776423223-756349
X-HE-Meta: U2FsdGVkX1/3ZZPgf9jDVxYOP/eqYHtzWMr0N0No1iULm8K4AB4QV97BuMJ7cp1Q+yz1a1KBkDW56ydChA2SuZEyxNl7XGoW+VoK2thlP847N+br2g29KiPyzEHpsw5u7guJoo57pPjSKi+N2F7C88CFy78J9PyciX7ZY/uSzsbUg4tpRN4HCavwaf/YM+Ip9EqhCYeJqhzmrtMidMUPP/VG851FphornPzIFNZgdi5j+rwQh7eABU2nmhyu4qJ/6XA3LZcAF5teYni06Gcb/sQQabCSXqIHlcX9Ygo9qP8kCXPtl7TdU4KyhTNR3DRr4WZCl7IC5GbJGOPtGeqM3dzTqG/QUya14ip/DigPq2kGgzlT8u5YfOygGmKZAnxEk/KBv22je0S9nrdIHswv1HXQiX0XNX9fHiFVhSrwvn+mh0KaSPfFPXqEdHjJkhxOJR+G2uTZfzKtqFNE32TqNcf0vANy3FxfTZO2FL2NaKbijI+ashFyhzUces/AFv4JtphlY4a6yuGGRaDU5U6W+xzJ5SEucFTcnMzjPsAA+jqzI9z7aTUy+czCGDAmYbuaY1atzqLTJzsZksCO2vVKfr5vGcpCi3EaWB2IackElHxlxf0k+NG5DFWQl6Q30RkldPk/zkmY4tGX2LPZerjUosYGudc625yCYX3/V1FEkAjQgxTizFCrfr5Z3fk5W2A33ZfWec7qpF4JQ3Zv6IXUy026VBN2TbCHNVozaeReLgujmKZqojvi6wtEQPEMte7DDbrUlqy/uav/z7wKpde/VcBRxiU3jGKfjNFZ8uxIAafgkM9b3rDQhLRua9/eq4DhGmb4prXDW8vqkxtOTqKZD1nrrRdozEicYY9o5m/d63HhDldetGK7A/nBk87D6jQtyD6K5h0nzP2PnRagleENqMEK7rsWlxxVloGNOwmkjA1uUwhjVUEkCMZgMKTbN4jDeoYIbSlu1e74wad22Qc
 XfNH+Bxd
 /fmbrDhtYzMpQWWDotz/slmo7kJ7eddspR6s1Qd0b1R7eNCEpRn+zCUy77Suz8yrGENnEtuPiSs6HCRjyzqzd5ZuPK9bbE5kNficZKyo2iIxvrSZpxcNrsT5N6izgrQHnT55XxuvUXRMDx52Cepjt6KyYOtVv8K/ttpuW2TJQ0LK7wM3XMXk2rgRC7F6lbbYNZe8JfgCD/T4AGr+aD+VxRwzkxHrmvj+q48lxY6J7owD4jY6oIkacitTXBMorhizWAVpbyvA2HEVA2kNLBLTiz0Z8D3FJzrdmc4XRnmQK6pcP/+QnsuOj5dp22XSFIg7Z0lFHX/tw5We1nGo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/17/26 03:16, ZhengYuan Huang wrote:
> [BUG]
> madvise(MADV_HWPOISON) can fault a swap entry back in through
> get_user_pages_fast() and hit:
> 
> kernel BUG at mm/rmap.c:1364!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:__folio_set_anon mm/rmap.c:1364 [inline]
> RIP: 0010:folio_add_new_anon_rmap+0x41d/0xc10 mm/rmap.c:1553
> Call Trace:
>  do_swap_page+0x14c5/0x5c30 mm/memory.c:4963
>  handle_pte_fault mm/memory.c:6198 [inline]
>  __handle_mm_fault+0x1512/0x22f0 mm/memory.c:6336
>  handle_mm_fault+0x42f/0x820 mm/memory.c:6505
>  faultin_page mm/gup.c:1126 [inline]
>  __get_user_pages+0x4b3/0x3400 mm/gup.c:1428
>  __get_user_pages_locked mm/gup.c:1692 [inline]
>  __gup_longterm_locked+0x945/0x14b0 mm/gup.c:2476
>  gup_fast_fallback+0x8a3/0x2440 mm/gup.c:3220
>  get_user_pages_fast+0x64/0xb0 mm/gup.c:3298
>  madvise_inject_error mm/madvise.c:1456 [inline]
>  madvise_do_behavior+0x503/0x860 mm/madvise.c:1875
>  do_madvise+0x17e/0x210 mm/madvise.c:1978
>  __do_sys_madvise mm/madvise.c:1987 [inline]
>  __se_sys_madvise mm/madvise.c:1985 [inline]
>  __x64_sys_madvise+0xae/0x120 mm/madvise.c:1985
>  ...
> 
> [CAUSE]
> Commit a373baed5a9d ("mm: delay the check for a NULL anon_vma") moved
> anon_vma preparation out of the generic fault path and into the fault
> handlers that actually need to install anonymous rmap state.
> 
> do_swap_page() was left behind. It can still restore anonymous mappings
> via folio_add_new_anon_rmap() or folio_add_anon_rmap_ptes(), but it does
> not call vmf_anon_prepare() first. On a VMA-lock fault this can leave
> vma->anon_vma NULL all the way down to __folio_set_anon(), which BUG_ONs
> on that violated invariant.
> 
> [FIX]
> Prepare the faulting VMA's anon_vma once do_swap_page() has confirmed it
> is handling a real swap entry, before any swapin path can install
> anonymous rmap state.
> 
> vmf_anon_prepare() already handles the retry rules for VMA-lock faults,
> and when anon_vma is already present this stays a single likely branch in
> the swap fault hot path.
> 
> Fixes: a373baed5a9d ("mm: delay the check for a NULL anon_vma")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> I can reproduce this issue deterministically on v6.18, but I have not
> been able to reproduce it with the same setup on next-20260415.
> 
> However, I have not identified a change that clearly explains the
> difference. From code inspection, do_swap_page() still appears able to
> reach folio_add_new_anon_rmap()/folio_add_anon_rmap_ptes() without a
> prior vmf_anon_prepare()


If there is an anon page swapped out, certainly at the allocation time
of that anon folio, there would have to be a anon_rmap allocated.

During fork, the anon_rmap would have to be created as well.

Something is off here.

-- 
Cheers,

David

