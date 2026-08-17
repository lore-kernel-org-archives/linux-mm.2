Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A93C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271076B00EA; Mon, 17 Aug 2026 11:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 221A56B00EB; Mon, 17 Aug 2026 11:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110706B00EC; Mon, 17 Aug 2026 11:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1C3E6B00EA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:52:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CD021407DE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:52:42 +0000 (UTC)
X-FDA: 85111204164.22.F7B859B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 77739A000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:52:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iANNWR1A;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786981960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xmAVz6xj7aLEgdSWsuJScsyd8G6EdI2tLeR0xpfNts=;
	b=no4uWOcZfKRGLXH9fgSXQEqT+O1SCILRo54j4MRRsa0QDbsqohtLrQH8aNHrW+osvOmyjl
	0Hklew9+diFYHc26qtRAd+ZT5b29P/6keiZXM8ZNgdB+XbvNLuTtlZEyU9T+Bs6rdhhxO3
	li1szMH7FynSsEbKcxqVqX6AMM/2ZXk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iANNWR1A;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786981960;
	b=ltuNJClxvKrA05ecq5UxMjnJVvU4e+I1HpCpT5hcHnAEPMJqeeqAxKMfDpG7XqvTHTkWo8
	IcYLxciSlv72DK2IZfGZWGQsi0/ZoPtvz1ivYsl2yuxtI6+S6JgPU4TI4DnVara8nNLXTU
	z7xuFDxsxLm8uqcHw9IrwZ5y81InBUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A120413ED;
	Mon, 17 Aug 2026 15:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA5A1F000E9;
	Mon, 17 Aug 2026 15:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786981959;
	bh=3xmAVz6xj7aLEgdSWsuJScsyd8G6EdI2tLeR0xpfNts=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iANNWR1AAQD0uk6PzsJnNGwuL4otB9pE/sXboIVh4RmY7yBk9vkbhvRyo1P7j54Ly
	 wtTHPl+GHBIvv2ILbyh3HPBAj68sv2f1oiUj+F3mrERGo6Yk82iY/3plgP8lbvABji
	 eF7jvGmoQAgJAsIkeuHFtX5VqPCC6lCSKkcj/Ij8EX5PIIC4oomzWp5pNfAf/1U4a5
	 CuE/ncZCnvwPCF1OGErs4mFvV9nvJvD0xzsdYAheqQn06lY9oMmLIbkj0ZXXzeYypq
	 Z9e8Bth4IKY9aAFS9J4OnSI+Zk6QX4cnC50ESKOe8nDO7LyRsK1qDRJmf6GIel8e+E
	 EdS5Bxl9GdxIg==
Message-ID: <3ae2f1e1-c784-44ed-9b2c-5edf5699d627@kernel.org>
Date: Mon, 17 Aug 2026 17:52:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: Use a folio in the softleaf_is_device_private path
To: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
References: <20260803031554.30421-1-hongfu.li@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260803031554.30421-1-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ygrbqwbna7jjgode1u37qt8hnzrpcd77
X-Rspamd-Queue-Id: 77739A000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786981960-212932
X-HE-Meta: U2FsdGVkX19AMoFLsxnVPYsi+ESWJO3HANkocH2haM/JtR8v8inDnxq1z8/L8OVOH3QCktFTYtxe9dzbCy2z97VQ3ZEPbIgXyCUxbLtOTtgVt0XItzF+PTIGarSqinAOguDvWCwhBX9iUArU3kb1CYTZ6h6mNfQMCbun5mKN0BPF9xbPwy9bMdIeeqwU7CGEYSGgCSUWcmTe/wD4I0BAUdY8VEpNXFeF9mzOfiO9JUE2sNtUNQhr1YBWl7JwwQXgXC7Z8xLNpiAB2ZkRZywFkSa7VsY+vn+S2o97HEadAAcKe3+IHQPKN4Drhk+aI+gkPnUiLacFy6dzK4KRZSkWeIT9m5iMwTq1KTrDpo6opRNVHM7mhGNxjEYRmIe5EVGLP0WAnIHxV3oLS2A2R39EdsxTfE4d8RhRAQ7vX3aOK5OK6T7ZZ70Se2s5FlOh+qf3GjFWPu7fpZQUz2e6RKhph6wvzSJckNJSwWeJ9AojVIb/ukcOp81UjNpMjJkxo7ULnryfPTsinS36tVgzJtYwubxHlN2OAQTAgwKYVN0ShyMCd24TEHtRQYgMHCuvH9YqcIe/Lu67HJKwhFeKcje32zjeS+JXOSnK7Yi12ReSR3stfeWgwyYMNNKov5cU52PGTvw4ND2h6El7G7mkY8UPjre5BrsRS96+sHDXkN8L8Td+71Tdyg3Y/IbFy8d7a2fLr4p8VTplDVcJ73WdYIUTtu4HkZd3WWdpjY6lmhCWIkbOV2YL4VPkxZkIp6lvYL5QhJIoBPposQ+51+ywpMI54Z3/d93A06iKy6+bFfT08l5X4wAf8n7OAG1rXGaPRxMUZ9as8EhPKoRIG76Se89wRWmwPnmpbX1ruEsC8Cee9On4l35SBadLCBuU+ZMdfk3EHMBVBsQ42ogF94FzdM+4j7QWd6M+eSVqXIz9YrDqXe05nMH7nMGTQYv9AGi1xdwB2CE0SnMf9Zzc2mXtiYp
 bKTo9CFe
 u68D9/q0iBQzer8p1v56KbOhzQdqyipHUpExmdBjtqcBm6OJin+iyc2RtAGcotB5+U2Rp70g2SB510KjJAxzOKinZZuFvgHBzqVCjvOBQ9pj08OlLKaJFtED280aoGndlYN6OwcyPYcDnOQDYIXHXHIccPMchVhdsn6ZHHxvIESMWk7eQHnzcZevu2Vbgz/X1rzziFCE7dYEYmmybe9zKIcs14cjMsUmJ3sLolJaooaho940tGIzLMivqhYswzE6D/ZNkaBf97KhowxhOmrH/qu6YlvEvnKnPsr7tb+LCRXXGyCSleNiHQrjU610e3gfnqdI5VwSWi/U/r1Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 05:15, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Use the folio APIs in the device_private migration path of do_swap_page(),
> replacing four calls to compound_head() with one.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> v4:
> - Drop the do_non_swap_page() extraction (patch 2/2 from v2)
> - Added Reviewed-by: Lorenzo Stoakes
> - Link to v2: https://lore.kernel.org/all/20260723030752.16979-1-hongfu.li@linux.dev/
> v3:
> - Please ignore v3.
> v2:
> - Drop fault_folio, reuse the existing folio variable instead
> - Refresh commit messages
> - Update comment to use "folio" instead of "page" in the
>   device_private path
> - Add Acked-by: David Hildenbrand
> - Add patch 2/2 to extract do_non_swap_page() from do_swap_page()
> - Link to v1: https://lore.kernel.org/all/20260721013347.65698-1-hongfu.li@linux.dev/
> ---
>  mm/memory.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 56b244552f13..bbb289ba09d3 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4873,18 +4873,19 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  				goto unlock;
>  
>  			/*
> -			 * Get a page reference while we know the page can't be
> +			 * Get a folio reference while we know the folio can't be
>  			 * freed.
>  			 */
> -			if (trylock_page(vmf->page)) {
> +			folio = page_folio(vmf->page);
> +			if (folio_trylock(folio)) {
>  				struct dev_pagemap *pgmap;
>  
> -				get_page(vmf->page);
> +				folio_get(folio);
>  				pte_unmap_unlock(vmf->pte, vmf->ptl);
>  				pgmap = page_pgmap(vmf->page);
>  				ret = pgmap->ops->migrate_to_ram(vmf);
> -				unlock_page(vmf->page);
> -				put_page(vmf->page);
> +				folio_unlock(folio);
> +				folio_put(folio);
>  			} else {
>  				pte_unmap(vmf->pte);
>  				softleaf_entry_wait_on_locked(entry, vmf->ptl);

Okay, so this breaks the HMM selftests:

# ok 30 hmm.hmm_device_private.migrate_anon_huge_fault
# #  RUN           hmm.hmm_device_private.migrate_partial_unmap_fault ...
[   14.589125] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[   14.589178] Modules linked in: test_hmm
[   14.589203] CPU: 25 UID: 0 PID: 653 Comm: hmm-tests Not tainted 7.2.0-rc5+ #14 PREEMPT 
[   14.589243] Hardware name: linux,dummy-virt (DT)
[   14.589268] pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
[   14.589300] pc : folio_unlock+0x78/0x88
[   14.589326] lr : folio_unlock+0x78/0x88
[   14.589349] sp : ffff80008284bb90
[   14.589368] x29: ffff80008284bb90 x28: ffff0000cc8ce180 x27: 0000000000000000
[   14.589406] x26: 0000000000000000 x25: ffff0000ca395dc0 x24: 0000000000000000
[   14.589447] x23: 0000000020100073 x22: ffff0000c23d35c0 x21: ffffffffbfff8000
[   14.589485] x20: ffffffffbfff8000 x19: ffff80008284bca0 x18: 0000000000000010
[   14.589523] x17: 3030303030303030 x16: 2066666666666666 x15: 6630303030303030
[   14.589562] x14: 0000000000000000 x13: 29296f696c6f6628 x12: 64656b636f6c5f74
[   14.589603] x11: fffffffffffc7100 x10: fffffffffffc70b0 x9 : ffffb0504ff88f70
[   14.589640] x8 : 3fffffffffffdfff x7 : ffff000c79b24bc0 x6 : 00000000000001a7
[   14.589680] x5 : ffff000c79b24bc0 x4 : 0000000000000000 x3 : 0000000000000000
[   14.589718] x2 : 0000000000000000 x1 : ffff0000cc8ce180 x0 : 000000000000003f
[   14.589756] Call trace:
[   14.589769]  folio_unlock+0x78/0x88 (P)
[   14.589792]  do_swap_page+0xf40/0x1580
[   14.589815]  __handle_mm_fault+0x648/0xe68
[   14.589838]  handle_mm_fault+0x9c/0x330
[   14.589858]  do_page_fault+0x268/0x7e0
[   14.589882]  do_translation_fault+0x5c/0x80
[   14.589904]  do_mem_abort+0x48/0xa0
[   14.589927]  el0_da+0x38/0xd0
[   14.589948]  el0t_64_sync_handler+0xd0/0xe8
[   14.589970]  el0t_64_sync+0x198/0x1a0
[   14.589990] Code: d65f03c0 d000eec1 913c4021 94015993 (d4210000) 

I can only speculate that we need another

	folio = page_folio(vmf->page);

after the migrate_to_ram() call.

Let me try that real quick.

-- 
Cheers,

David

