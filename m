Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3652606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MFM3BLP9
Received: by kanga.kvack.org (Postfix)
	id 1F81D6B00EF; Mon,  2 Nov 2026 01:49:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8996B05B1; Mon,  2 Nov 2026 01:49:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 097D36B05B5; Mon,  2 Nov 2026 01:49:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D52CD6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:49:47 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC31FC0BEB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:49:46 +0000 (UTC)
X-FDA: 85389253572.18.015AAE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 13080180002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:49:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFM3BLP9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793602185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHJKYoJn2rQcORF8UUmu/uUQz3K49GvOCpYRw8uJeTw=;
	b=YNaRki1oXdqkQiq+rGuwgjtWqbBFHtsB4hzofIy5yNXrEam2m+OHm2NL1fViF//Xw1HsQz
	xRZz4SESDcDNc7iNdQ1BwVNNkk8pYSanTp3lbS3KH63xJSOUWntftv0/yUGDEZ0Av5KGep
	MrN4JAge9GWEaCYPmsfDVbbh8tuQA9o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFM3BLP9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793602185;
	b=ZlwtBoFePEjDdahBAK0JQARGBg0lSMgZ1+ahEKmx4fRtH09sQpko2imIGu8FIrkqCHnQLw
	VYaOdhCm7UZTiGZA0ADRzrL+PdCDfA53w4dis4xoXMuxE1RkkqpRzocAuC4TkZG16RoJYg
	AK/sbOU5K7QnsiAvw9vinPVIvCtNxj0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF76260DD8;
	Mon,  2 Nov 2026 06:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE001F000C1;
	Mon,  2 Nov 2026 06:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793602183;
	bh=lHJKYoJn2rQcORF8UUmu/uUQz3K49GvOCpYRw8uJeTw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MFM3BLP9ClG/wpwp8m2Y+F7r9H7PumjtWx30iXhIhEEVNlaHPzMErxGkapMn919RK
	 Z7xG7RlaYy6cgJdIGKS4HA38UIGPemB51XWXP7DZlTkX5XWJJtWl6Pb3PSln1FGA9L
	 AYsg/g7O5HQyQ7r4tB7Uh4C4J2D/N1GgSUOPyPNUgp31aNc9grwPTwSwH9h8IvdLR/
	 soUnea6qM44H37EC5fbfOAovvWG8ByvoOzjLLzUpGsVIdExut6fiI97Tp0kg8nbvHJ
	 3kAkvrewtCxarSA+gIi3ipnFFLyPtVEICDKrRLUWjb2DjFmCUsAtuHuMpZlW41I14x
	 QEK0zthUAlIPQ==
Message-ID: <40a8fb84-4d76-40f8-b331-66ef94f3b17b@kernel.org>
Date: Mon, 2 Nov 2026 07:49:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: use pmdp_get() for the lockless pmd read in
 do_fault_around()
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20261102031308.66177-1-hui.zhu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261102031308.66177-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 13080180002
X-Stat-Signature: 7tiws4ecjonjo3k4qn5dseg655tjgd8g
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793602184-720634
X-HE-Meta: U2FsdGVkX18Fo+TWeykrTk5/iosbVPTuCcrV6ehJMKkOhdDdrhebPEQTiFWZ+ukOUtM2/eteIpfqnGRZhZDsKJ6IyjO2I6zhVVn4YBL6aaF9QTJ24JCKqOyA8o+wH8N0cdr3ZewaqDFnYXZEB7smhIBdamCTVfcDfWmE+oxflx2Alt/NHK979V60jtJIAEWkAxofRyS7WaWtTBjSPLDUx+mNEBmiU/oW+7YILUtuEGZI+kBunQ8oYTL4GYViFROicx2BH/SJoVOpY8GKsFu0anoSJz3U9AweVSyWimMMphl/5WVE+cW091eVHJEg1rsI1/X6Br0M5S6HmHEk6VyiBPg8KZB9NZqJi4y1LFutedWPo0Iea08r7r28H66L9F1i1AZE+/MWqFxMcnEVS5meYhKpUUIS5FTpmBuortQSIZJu3zIIufgRLz4aJdOTFMKDVCsCuoJ+ZfI9FvUxvcZKDttkL/QET6sdl6z/kCGaSERpHzmfNb5FmRTFw71ap4mXhhOfhoHPmerwqo59pvaicjCvmwBkCAmc+blxo1VyWSPHC9l78+4Sykb92ujFHoBksELUAFwQKAnAyiwZBTxfe6ac1lKE1vJdBc2t8PqVUiHlyU/UBZf7WFWbDh16+aYIxN+wAJF9Qcs36Of2SJ5zRjOEWER4veSxNu6qSaYh+N0Mjg93hkSzm7Hz6jyoS974T3yt+Qw2Nmw1jcDRp2MvKWPXNQtybo2sKy2+QTjjT0DDmHWFjZdCnPnoym73tgPUlnTJx4Iq10KVwZL3DmNCuNUdOf7+ZU33yANGo/lbcYZ58bwo+hXvAi4BPvtnkuWEPI6E+OJXmcMLJtuOhXbjJI+zxvFKnsRORsdK07LLY8QsJ7WcfcB9mAFMopMy4gDHDa131gbxez24vHp0WOOi/0T9fEQ3PbDZtRMykYA8p3J3q1WFDbbLsnFkys32rJgYQ5Y1yCF1fo48dYAHPcY
 tD6WVGvP
 3R2NfPmfx/bsvMmshSLIJB0DBwwnEoAxzS/ow1FyGdAE9xiXb8svua4Z6wtuQBqhz0NzFTOce74Gxh8P1geH5W766IBvsQgoNc1jYSOskapU56NTuBs/Di2Fyuig5RX2p3KzDbK0hr4grETrBdmCAE4zNUP8d4cNUSqI9HpxPsfD2nC+PTYdh9m7ry12nhtcDM8W9PCc0srUfUEnEp0JjemE+d1Ft6xSI8H/3z+39MmLZ5ABXhZ6C86OAcv2peVzPz+Mt1yATK0x3wMYniffRcXNui8MClvHg6QinadwuLy3Ziub7TYrrQvg/9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 04:13, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data-race in do_read_fault / pmd_install; the same code
> is in mainline:
> 
>   write (marked) to 0xffff8d52a75fb810 of 8 bytes by task 27487 on cpu 5:
>    native_set_pmd arch/x86/include/asm/pgtable_64.h:83 [inline]
>    pmd_populate arch/x86/include/asm/pgalloc.h:84 [inline]
>    pmd_install+0xe0/0x120 mm/memory.c:444
>    finish_fault+0x5bc/0xb00 mm/memory.c:5204
>    do_cow_fault mm/memory.c:5432 [inline]
>    do_fault+0x5d0/0x6e0 mm/memory.c:5526
>    handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>    __mm_populate+0x144/0x270 mm/gup.c:2207
>    __do_sys_mlockall+0x2cd/0x380 mm/mlock.c:764
> 
>   read to 0xffff8d52a75fb810 of 8 bytes by task 27527 on cpu 9:
>    do_fault_around mm/memory.c:5341 [inline]
>    do_read_fault+0x162/0x670 mm/memory.c:5381
>    do_fault+0x31a/0x6e0 mm/memory.c:5524
>    handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>    faultin_page_range+0x227/0x530 mm/gup.c:2156
>    __x64_sys_madvise+0x67/0x80 mm/madvise.c:1479
> 
>   value changed: 0x0000000000000000 -> 0x000000001386c067
> 
> do_fault_around() reads vmf->pmd without the pmd lock to decide whether
> ->map_pages() needs a preallocated PTE page, while pmd_install() publishes
> the entry with WRITE_ONCE() under the pmd lock.  Both paths above only hold
> mmap_lock for read, so they can fault into the same VMA concurrently.
> 
> The race is benign.  The pmd is a naturally aligned 8 byte object, the
> store is a single WRITE_ONCE() and pmd_none() only tests the low word, so
> no torn value is possible.  A stale none pmd only allocates an extra
> prealloc_pte, which pmd_install() leaves unused because it rechecks
> pmd_none() under the pmd lock, and do_fault() frees it on the error path.
> A pmd already seen as populated makes ->map_pages() find no PTE, and
> do_read_fault() then falls back to __do_fault() and finish_fault(), which
> allocate the page table properly.
> 
> Read the entry with pmdp_get() so that the load becomes a READ_ONCE()
> pairing with the WRITE_ONCE() in pmd_install().
> 
> No functional change intended.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/memory.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 0fb676dd2bd63..90afbd124d503 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6017,7 +6017,11 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
>  	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
>  		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
>  
> -	if (pmd_none(*vmf->pmd)) {
> +	/*
> +	 * Lockless hint: pmd_install() may populate this pmd concurrently and
> +	 * rechecks it under the pmd lock, so a stale value is harmless.
> +	 */
> +	if (pmd_none(pmdp_get(vmf->pmd))) {
>  		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
>  		if (!vmf->prealloc_pte)
>  			return VM_FAULT_OOM;

If it's an lockless access, shouldn't we be using pmdp_get_lockless()?

-- 
Cheers,

David

