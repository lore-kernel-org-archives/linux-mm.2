Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEFE6C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC7F6B008A; Thu, 24 Sep 2026 16:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CABDD6B008C; Thu, 24 Sep 2026 16:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1D36B0092; Thu, 24 Sep 2026 16:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9598F6B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:37:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2160280479
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:37:34 +0000 (UTC)
X-FDA: 85249816428.12.AB5C06F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 538A52000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:37:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QAkIFUYo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790282252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpeHbRQ1znqHhUUbc+Gddj3IasWA4/PoIh6Zvf/98So=;
	b=a3+fnRkO0qW/v09NeNegPnwjUG9/2SarNl0+skgTlgyxVgXL5c3IUKr0t9blMBmnIJYQxM
	VGT/Q9yBhHnn6u4FIzFu8XLSFYeA6nxkOmz1u1Tgg8Z87qAAVdxOYUAgp9BcDCSaiTwJ4/
	qkPRP3NHyl4s4HXdNxbjI7Hju9P0Le0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QAkIFUYo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790282252;
	b=sZfH6h6i3qhXBtznrphG8Ah50C47iIs5v7BdJmLyVL3ZpZLDDraTeWCP3Wx5LrGt+USrfY
	tLKJMikJMsXZZ4j8zn1aPi9r+X/5mHka5F30AMc7dBIbsZNh7j1GSQFjpI1RBkpwbijrkt
	lsnsxOP3VLcLO+U4TIqsxjLBvLcF/+o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D99ED601FE;
	Thu, 24 Sep 2026 20:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061A01F000FF;
	Thu, 24 Sep 2026 20:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790282251;
	bh=dpeHbRQ1znqHhUUbc+Gddj3IasWA4/PoIh6Zvf/98So=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QAkIFUYo2hlRmbyMtubPihbWhr6yGHr32Swvuat9vFy0548gpm86YeFkR+FCOfnvF
	 ZoEcJa/Wp38T8lEo/rUn+xio3cFqTm77qWPGWZ6OUji7Hd0ZwlSTgI6DGpB/7zgAf4
	 shaP3Reh8vNvZGnLYRcVKL7cVBzr55HmYH1absv5+SMJBATtA05BFYoxBEaTq07+si
	 ujASbM2NpLcn4InvbQ3HhxCsOVAAf3d8YoICji3HKCFbiAx42x+ba9bzPIHO0q4s6u
	 ZLjk8cbLPKxp9wZYNgy8QzjAz225/8+OTXzHpKPpIlGC9ZL5f55KFUaGJerk8UjFFe
	 hH70f+9yglwZg==
Message-ID: <e375b500-be0c-4ad2-b59c-ce1d4d58bb10@kernel.org>
Date: Thu, 24 Sep 2026 22:37:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 15/29] fs/proc: account PMD swap entries in smaps
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-16-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914122950.3283997-16-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 538A52000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wby4dk79ai73d9qjyif3rqde34dq4i8g
X-HE-Tag: 1790282252-442698
X-HE-Meta: U2FsdGVkX18Kke7QK7tryd36UtfdZoYXMf8VEsGNxPOnVy6xdO+/LJ0s5mxCEiYYGg8pExCQBteqLeZyfDB1zijZ7FL0M2Dqc5bCBSNhjitDU9OiRdO/VxgHc9fgouFoQtqGMBhLwXB3DSmRyv+rduvjUltL/D9/3Qiphx2n3uch11tFBragVY73+D7rGVBRZSrjTci5oJW99I4aKIaGbYSMCH6bkLbIwShM1QtKEE6XjodrnnK+jbU/eRcEeLP/MsCw2aBrlImog3K2kKHUFPatWiAhUkWGOg3upcBuZqds1fNt/LnlflwHku8nZ7KpGDNm0SN0brFDUC2YK+YsHO5IOJ/JY2uJoUIApHvbxjgQ90Uj0bANqZL/mLb0V3y0twXNZVnVhsvAmbyD2eHY1pfPn3EbXYO43/wnwDw0fN1RfKcVF9RhzI24N7+YVrH0q4GhajbfpBgcR54fNAF6DobXJ1GNGxOuX7ZtFBphRKrU74dgPOprEE+skk4QRTWFx1dJiu/aHC+5BapXPVmqSgusECFVbhgnWmH8O3T+O6yQ7+733ongubJ5pkLdXuRbJoqo25qJ33iVyUYLtWrmAsm5G575U+58nwnnDyRofi4241ZXOpAYlTwN8ye6fkP2ouqLSzDxvCmtiejMZCy8YG6DxKz5zs3H7i26YXtjEvfcjuanlf9B3wKD8bC2pUinpd9az2mnUIE3PxGh+SbqNPLpml6YKPIA2KmSdMP6r4NbehREVBtGAbgMbqHrnELxH5S9FNzEvoKLupKNY0rI66KOYzZ28bEd+prbGJLkpaiTZ25AGy/dlpkW85W2t27cl46asLYKdLzJw4xjIF2xf8Rlm+dXEmgQRTBWqpzPkIuDJZh4IPR2oxBFB5Vhs8ZqzkJvx63hRMZ37EijnwBrut23rGEwUTyi7VJuVSHZXkEm4u/qrMtskekCnSY/jvDJB6lwoCnrYm68Ff7Nsvd
 r7Oj7TWn
 B5KTq5GSvjXHkkD9ERhYk1CnLND/OVzXdhsAgJWnAfX4Hsdfr73opY5VJgS8ZT1SiRr7JCqsD9YnmzTYj00wP181C0aMWZJxAoIhCcfs5nehgeN1Q8Pn9F84g39i11iFBuR1euG0P1JqmqYDsgqBw0D8LzYvlxLZXhS3HNLvaistqnAS59BODLE5wT+Z0Tj/qHytKfdL7K+0G5AGMYY317+CHh1g0P9aDNO5jT1uZjuYr/27ituJmx70uDCB8VTSz8iWV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 14:28, Usama Arif wrote:
> smaps_pmd_entry() derives a page from a non-present PMD and gives up if it
> cannot. A PMD swap entry carries no PFN, so a swapped-out THP is accounted
> nowhere: its bytes show up in neither Swap nor SwapPss, and VmSwap silently
> loses them.
> 
> The slots of a PMD swap entry can have different swap reference counts, so
> SwapPss has to be computed one slot at a time rather than divided once.
> Factor that loop out of smaps_pte_entry() and call it from both levels,
> then return early: a swapped-out THP is not resident and must not be added
> to AnonHugePages or Rss.
> 
> pagemap needs no equivalent change - it already emits PM_SWAP and
> type | offset+idx for a PFN-less softleaf entry - but its
> thp_migration_supported() gate answers a different question than the decode
> requires, so use pmd_is_valid_softleaf() there instead.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  fs/proc/task_mmu.c | 42 ++++++++++++++++++++++++++++--------------
>  1 file changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 24425e2308951..aa3f4d54a8580 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -957,6 +957,27 @@ static void smaps_pte_hole_lookup(unsigned long addr, struct mm_walk *walk)
>  #endif
>  }
>  
> +static void smaps_account_swap(struct mem_size_stats *mss,
> +			       softleaf_t entry, unsigned long size)

Wouldn't consuming nr_pages be more consistent with other functions that consume
swap entry ranges?

> +{
> +	unsigned long nr_pages = size >> PAGE_SHIFT;
> +
> +	mss->swap += size;
> +	do {
> +		int mapcount = swp_swapcount(entry);

While at it, can you please call that swapcount?

> +
> +		if (mapcount >= 2) {
> +			u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
> +
> +			do_div(pss_delta, mapcount);
> +			mss->swap_pss += pss_delta;
> +		} else {
> +			mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
> +		}
> +		entry.val++;
> +	} while (--nr_pages);
> +}


[...]

> @@ -2000,7 +2014,7 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
>  			flags |= PM_UFFD_WP;
>  		if (pm->show_pfn)
>  			frame = pmd_pfn(pmd) + idx;
> -	} else if (thp_migration_supported()) {
> +	} else if (pmd_is_valid_softleaf(pmd)) {
>  		const softleaf_t entry = softleaf_from_pmd(pmd);
>  		unsigned long offset;
>  

Interesting, the function already seems to do what we want. Weird that we
indicate PM_SWAP for migration entries ...

Also, are device_private PMD's handled correctly? *doubt*

[maybe there were patches, not sure]

-- 
Cheers,

David

