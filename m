Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B03B7606EA5F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzfK7/nF
Received: by kanga.kvack.org (Postfix)
	id CD5006B05B8; Thu,  5 Nov 2026 14:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAB7C6B05B9; Thu,  5 Nov 2026 14:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3196B05BB; Thu,  5 Nov 2026 14:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91A1C6B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:43:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6F49A8B19
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:35 +0000 (UTC)
X-FDA: 85402089990.10.06B7834
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A470100005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gzfK7/nF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTMunOvWx9vfj4dikKtc63lykbDUpZcV5Bu+Cvs6i4Q=;
	b=HhkqxuNP2eLvnxMtKKfiKsFhVU4kCTFmPc3pBGINJgCKY8u6cUNw8FLoNxjctc94d1xpn/
	A2Iu22TIgdpmPxgCpeyLxhQ3B9Ty/7WAq86tM2zAowPJmgn/r8mCNMB2CSQTX4Fv0oDsX8
	ivZGQzkjYqr3CHlQxLxRDI48NZV91b8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gzfK7/nF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907814;
	b=5qWk4NieCfHVp/PDb2z36JM1fmX9567CLDH2fFvdgNdKk2SzhimfC9sTTXXRKspQ3lWvs1
	3LfzzDfI9BisV32g17VCHnvVcLYd8knffgFT++2qmo7LmeOM3K9gzMWZNDQrAOf4p2l0Eo
	50CiILJeNY/pz1uuDVLIn/yt61Tngo8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A0AB60147;
	Thu,  5 Nov 2026 19:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE29F1F008A1;
	Thu,  5 Nov 2026 19:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907813;
	bh=dTMunOvWx9vfj4dikKtc63lykbDUpZcV5Bu+Cvs6i4Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gzfK7/nFuPPtB7TuaDe3+Fc+p0bNF+u4OzPhpYnN6Pgry/ETk5WJw/bk6pxBpNtXo
	 VakeLxhOZEHtnMaMA/tBF8ufO9+3k+q73OIS4DvkuLPDyKlT0XPBcxLnwnFQgGVYT6
	 iR5Ow3jhrstIzdB1yLOnqInMkHBiz6HeSWPrVT+6K396fgBqDeSDUbRl+mfkzr5Sf7
	 lQkvd+zApBq4+NcjVkx12fZytmu2Yg5o6q730thrkMasxcit1lT3Ddk8nk1Md+QKsO
	 Am85USGObzeUurcYRcqOFtoGLhaGBp9Ox5CAXaSD+iylDf4nZrPOtjeu8rcQYYVov5
	 kHczTEJKgsa2w==
Message-ID: <8c11d322-5b30-43ef-8d8f-1baab4a90332@kernel.org>
Date: Thu, 5 Nov 2026 20:43:26 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/swapfile: drop a large unmapped swap-in folio in
 unuse_pte()
To: mt4022@columbia.edu, Andrew Morton <akpm@linux-foundation.org>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org
References: <20261105-swapin-large-unmapped-v3-1-d5906e4cf18d@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105-swapin-large-unmapped-v3-1-d5906e4cf18d@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0A470100005
X-Stat-Signature: rz61oi7ii3i1mh5uff4zmiebgx1horqz
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793907813-294262
X-HE-Meta: U2FsdGVkX18fFt1YhvHV2/fJe9K1yOb+z8F9kc3XoN1CYTmeqgSosIc+nrtZE2TU+hnRfcUzhiKkUZjebiu8BnrkuUujQhgAUyDCH8O2whhucU8VwXovIdDz9UlVfNyeqkkbbncijPz16D8cgh9HiVZSUYxuUAbxU4zMU2jfJXNrBWSYzcSGhRz1PF8EROgZ37BP7bwEm+0qVRKv8LSgLFYxJH/V9iHi5WgC2LkBX0BIJDx22IOANao8bw7nPo/r7wnlzI7ln1W5M3mjxHZw5/vwsbbMzR0kV/Z9Ws/ixedp5fDU/3UGMzhY2iFxkd6TWmTv9WlVw3kU4nWN9OgXNOHkgcEU7pKtU34trd4qPRH85BYs4j8B+hij2lG/YXyphI9f4awN/9Hhwcczts5LIvY6NhWzsYN+zcKXESZr1n1jRx0Z4XOrnb9bfp0OUUkKku50O5APhoEAQx26iVX8CXwXpP3x8UJ6t0ncfnwJ99N2Z0vKW9srM+3YUudTq7mDbRy7dXdzbHkku+NhSw4UaxLXNW3oZmbkRcm5Qlcmbz9hh6tB0vBYdQEv3HF89agNXtPf0LmHFxzgFHvvyFxLBEXHodH4hkCPZR6WSim3yttzKGM2ujTfRrhA+9EYPZ7HGu6hM76sMmU5V/v246SnrdxTiURrWkWHzObvNRoyDYBMye7ilVeF+WCqrZOieIGCW+7/k4XZMcZsNGs1MT+h7eIFo5miRG4TSAf/51mjX1pzoEFiSthuEE2JyJpS1I5rlxza926v5uMrWvRR696zADc0FacYXEAa+Mjz3aLCEU1gwm+P3dtmOvnKwEY8PQ2xs5YHFWyq7/ABVS9y4TNwG76/FV577rgzgZg9LOE37J5p11dVRfeIw7s8jDD1bGm/BR0g/xu7xLRcly9LtRb4sjzJNG48yPa8Lw8hY2CVvGzPt8dLveMHcnOl5ITg6goNDUhn6oPVFDudDQCHJNX
 znbK6j/+
 5tId+Agz5/+kWDl/LuHq1wQNlLYIVdqytUIENlGiTMJ023uFfO70oHy5lig4MXYxWZsPyEnOmdSwdkB7HSYOI7Jx20w9A94tgZmUsTtlP8F4rnzUMK76W/PTyif8qIo8MOoSVp/wmACjy4Mr/Ox2+3YnOX2KRa/RosgBvKRF3pvYPjH/1xX6qJv8CypyW2hSZs/DazYgGQNySWjsST7ewGXWgS40HE0YMntBVQmz5niiYa8w5VtK3SsXUU7pHib3x/IK1ctKYTDGw/0ZM6nheAazPmTUNr6Dhf5PJGb13B6sKRiOV0W0hK28hMOdIXmVcGgjHLGzfQPKIpZn0EEzpkx6efU4PxcvPKCD5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 18:19, Mani Tofigh via B4 Relay wrote:
> From: Mani Tofigh <mt4022@columbia.edu>
> 
> Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
> for SWP_SYNCHRONOUS_IO"), a fault can read a swapped-out mTHP range into
> one large folio in the swap cache.  The folio only becomes anon once
> do_swap_page() maps all of it, so if the faulting PTE changes in the
> meantime the folio stays in the swap cache while not being mapped or
> anon:
> 
>   Task A (fault)                       Task B
>   do_swap_page()
>     /* swaps in large folio F */
>                                        madvise(MADV_DONTNEED)
>                                          /* zaps the faulting PTE */
>     /* PTE changed (F not mapped) */
> 
> swapoff then maps it, which marks all of its pages as mapped and
> exclusive, and the next fault on one of the other PTEs crashes in
> do_swap_page():
> 
>   [    6.424485] kernel BUG at mm/memory.c:5195!
>   [    6.424503] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>   [    6.427654] CPU: 0 UID: 0 PID: 67 Comm: swapmthp Tainted: G        W            7.3.0-17087-gd865f2677c44 #1 PREEMPT
>   [    6.432665] RIP: 0010:do_swap_page+0x24eb/0x2fa0
>   [    6.451035] Call Trace:
>   [    6.451567]  <TASK>
>   [    6.453841]  __handle_mm_fault+0x13b5/0x3b40
>   [    6.458525]  handle_mm_fault+0x16f/0x480
>   [    6.461143]  do_user_addr_fault+0x312/0xa30
>   [    6.462044]  exc_page_fault+0x66/0xc0
>   [    6.462846]  asm_exc_page_fault+0x26/0x30
>   [    6.476708]  </TASK>
> 
> do_swap_page() already drops such a folio from the swap cache when it
> can't map all of it.  We move that check into a helper and use it in
> unuse_pte() too, so swapoff drops the folio and swaps the entries in
> again as small folios.  With the fix, the next fault doesn't crash
> anymore.
> 
> This bug was identified and confirmed with the help of a deterministic
> hypervisor currently under development.  The C reproducer below however
> hits it within about 1s.
> 
> Fixes: f1879e8a0c60 ("mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO")
> Cc: stable@vger.kernel.org
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

