Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB684C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 09:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B616B008C; Fri,  8 Aug 2025 05:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3086B0093; Fri,  8 Aug 2025 05:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2676B0095; Fri,  8 Aug 2025 05:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF6D6B008C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:56:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EADE6141841
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:56:08 +0000 (UTC)
X-FDA: 83753134416.18.CA28DEF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6486F12000A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:56:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kWTVHSBC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="CJa74u/r";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kWTVHSBC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="CJa74u/r";
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754646966; a=rsa-sha256;
	cv=none;
	b=gg18frtzzcU+pw7G2jltfUS7YF/9EyB2lqJr7Q+ew0sK8kuK6RPukuUk1BAvuQIzoLYjWi
	CG7BklQDME0nWYQhwsMf9vV0A3ArVlCQKe88m6ytUHKFMbYP1w8MmYuSiC86cd6Hb63MUU
	VqNjeiQQ6jINu1FdPans4tN2Cw81xzc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kWTVHSBC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="CJa74u/r";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kWTVHSBC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="CJa74u/r";
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754646966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtMe2pzANcCv923DR4DGNj4wwpKFAlvPFXGuh7j582g=;
	b=ISHI6Ahgd/XlZj1jS2tNMrpiCvCW+49tPwotIUiulMgClkFv6IJCUDs93N79L2TcRDPmfS
	eAKP0tFCujuq6wrc2e55IFGEGnui1SMP+lUJ+aCR9BHggg5xoBEVsbEdMPYGe5Dm48NawF
	A1Tbl0i8ReS57VYBJm4ua7UDcYpTq2s=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8108933E26;
	Fri,  8 Aug 2025 09:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754646964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xtMe2pzANcCv923DR4DGNj4wwpKFAlvPFXGuh7j582g=;
	b=kWTVHSBC5JiOxSvpPw6E8uI1t5OEYf9sjGN+1GjiD472HhJLwh6vaY0gUwhzPLJtpGMxPG
	SsHmu7eLB9kBrhqCBzdV891o+NN3mW8kR7VNlgrnH8SgLHiwO5OEs1L2RL5ZZiWlIBpDF6
	ZonrFeDAeDTb00pBn41K1i9jI5iU3eg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754646964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xtMe2pzANcCv923DR4DGNj4wwpKFAlvPFXGuh7j582g=;
	b=CJa74u/rK3wE2u0Ipz9zWnG8bXBavMr3aD39umQSPPYw/IwjXY2qpEcYcWGbtPfPN7NzFv
	1LbEYj8jn2TeBbDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754646964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xtMe2pzANcCv923DR4DGNj4wwpKFAlvPFXGuh7j582g=;
	b=kWTVHSBC5JiOxSvpPw6E8uI1t5OEYf9sjGN+1GjiD472HhJLwh6vaY0gUwhzPLJtpGMxPG
	SsHmu7eLB9kBrhqCBzdV891o+NN3mW8kR7VNlgrnH8SgLHiwO5OEs1L2RL5ZZiWlIBpDF6
	ZonrFeDAeDTb00pBn41K1i9jI5iU3eg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754646964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xtMe2pzANcCv923DR4DGNj4wwpKFAlvPFXGuh7j582g=;
	b=CJa74u/rK3wE2u0Ipz9zWnG8bXBavMr3aD39umQSPPYw/IwjXY2qpEcYcWGbtPfPN7NzFv
	1LbEYj8jn2TeBbDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DB971392A;
	Fri,  8 Aug 2025 09:56:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gNGMFrTJlWixXQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 08 Aug 2025 09:56:04 +0000
Message-ID: <06849b87-ccca-4dbc-8b35-a537bb6a9859@suse.cz>
Date: Fri, 8 Aug 2025 11:56:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6486F12000A
X-Stat-Signature: ibm3zde7sgpui5oe4hunnbrsg1gt1uxe
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754646966-419560
X-HE-Meta: U2FsdGVkX18HKcHCfcuOQwx4trUgiTE0WOGMOelMS8jyJ+vscCTR5iFtrtSIIyaCJO7iwb0pz5ji9+MwwIuoZAj5j7CMR5DdVBtAUV6X031HBTAVMqkDwN3Y1GRQLR1eE4YMNuhfLcLxxAI0hM5gBZOSjSdLFMr+HRgzvqFscG3rzXgFHLt5xnwEHeDt4xjVkAOzBm+SYanvrpE1HLudQT5EykMI0t9uEQ5zBfLZo+FfcN9wG7/sPSC3phuZqLKBRfayPJxunrDAisKLcb6OqGm/0VLN7ytp6YE6zcgSaBi6IgtpC/9upUfBvE4vwjr8kzCuAAZcCp/HlIA/eu6G7Kn6/GXhCCAsaNHqF44wDDmc8rlh10kcSTZXsP0aAVLidKhZ4IFnmdOJKo+YiARY+wIvAJ3y74iL5EEuk0YYLEWuUrdRxXdbZOkPoBXtkBoL8ItYuFW6HOYv3EIq0Mq85shjUyy/vFKKYrrCqP3YbGJDitT2TMkrSFkx6zt/ICncVzvyJjWdxZ0zNQjduKBbkFs75jB/0epEHsfXPBM90YNdR7qjduJfdLwDOWGfu7ui3ABVPwDKaDYYzLLIpC3CTU8AhfkouzQXoHEET8YveBbqilEC/HCvcXHN1H9vbktkuH7IeIbxYd8wj49Xbvr8tY9ktP0qBYmbPKTRP+0UZVVvSlUxilqGMiT9BFrYEapGOFgUpOCPQfqsk64knzOSvvEusUzrEX3VxmpDkwMIe3vRrtxyx1LIEHVTSfQIfpEErsYe6X84ZaygNqlu7PRQxQZppWkV/eQG2150Tk+62CfWc1uEUs0QLKyWnJI1RKKFna17zmskgT/HDijzfBFbILu30qBtP8eyydQxIMoTDdVSW17ROS+E7Zyl4ZpoOHoJ7jGD1eK2cCCERupSSeDi1UhE3MEwUQc/0jyjvvcq9NVwOIZdz/t7tUUtIH85cdJgPvXjf9JMwM3bTaiA+0M
 CnAXpY/r
 9cf004piWZgddac3oZO6ke52W+a82UmKw38R9/xtJzyvsy7BNJeJdtrBA6RVAh5+mIdGO9YyVXojECEfqdrZgdY78GdOfDOobuDHuLxPYz3t3x6ozvfwwvbDUmus4XG+8xzErFA+n5FkClWVJZ6Nh6sQsPAoSTSXpgrLwUS+AfIs4DgEQZbS94GDkHYU29e4VXxZ6pV9/2N5izKU/OACtCMlNMZ/aZablIWJ9yEwpdFQJ8mzss5l6cUhOKzVPYBEiKcX1LyFBZEt2y2OFncl/yptOUBym1cQnJDFBgnhZA2ept+HYsjSaeWN9Z/2a5l950hIzQcS+o+jZEDtbsml+Pdf2XYdyjx27Ai2qFSNWziwPxYg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/25 20:58, Lorenzo Stoakes wrote:
> It was discovered in the attached report that commit f822a9a81a31 ("mm:
> optimize mremap() by PTE batching") introduced a significant performance
> regression on a number of metrics on x86-64, most notably
> stress-ng.bigheap.realloc_calls_per_sec - indicating a 37.3% regression in
> number of mremap() calls per second.
> 
> I was able to reproduce this locally on an intel x86-64 raptor lake system,
> noting an average of 143,857 realloc calls/sec (with a stddev of 4,531 or
> 3.1%) prior to this patch being applied, and 81,503 afterwards (stddev of
> 2,131 or 2.6%) - a 43.3% regression.
> 
> During testing I was able to determine that there was no meaningful
> difference in efforts to optimise the folio_pte_batch() operation, nor
> checking folio_test_large().
> 
> This is within expectation, as a regression this large is likely to
> indicate we are accessing memory that is not yet in a cache line (and
> perhaps may even cause a main memory fetch).
> 
> The expectation by those discussing this from the start was that
> vm_normal_folio() (invoked by mremap_folio_pte_batch()) would likely be the
> culprit due to having to retrieve memory from the vmemmap (which mremap()
> page table moves does not otherwise do, meaning this is inevitably cold
> memory).
> 
> I was able to definitively determine that this theory is indeed correct and
> the cause of the issue.
> 
> The solution is to restore part of an approach previously discarded on
> review, that is to invoke pte_batch_hint() which explicitly determines,
> through reference to the PTE alone (thus no vmemmap lookup), what the PTE
> batch size may be.
> 
> On platforms other than arm64 this is currently hardcoded to return 1, so
> this naturally resolves the issue for x86-64, and for arm64 introduces
> little to no overhead as the pte cache line will be hot.
> 
> With this patch applied, we move from 81,503 realloc calls/sec to
> 138,701 (stddev of 496.1 or 0.4%), which is a -3.6% regression, however
> accounting for the variance in the original result, this is broadly
> restoring performance to its prior state.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202508071609.4e743d7c-lkp@intel.com
> Fixes: f822a9a81a31 ("mm: optimize mremap() by PTE batching")
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Sadly, the improvement will be far from 3888.9% :(

> ---
>  mm/mremap.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 677a4d744df9..9afa8cd524f5 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -179,6 +179,10 @@ static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr
>  	if (max_nr == 1)
>  		return 1;
> 
> +	/* Avoid expensive folio lookup if we stand no chance of benefit. */
> +	if (pte_batch_hint(ptep, pte) == 1)
> +		return 1;
> +
>  	folio = vm_normal_folio(vma, addr, pte);
>  	if (!folio || !folio_test_large(folio))
>  		return 1;
> --
> 2.50.1


