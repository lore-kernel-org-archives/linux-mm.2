Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D719606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 04:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=paCSqT1f
Received: by kanga.kvack.org (Postfix)
	id 2365A6B00EF; Sun,  1 Nov 2026 23:17:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 198946B05B1; Sun,  1 Nov 2026 23:17:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF036B05B2; Sun,  1 Nov 2026 23:17:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE9756B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:17:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 667BB40C2D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:17:03 +0000 (UTC)
X-FDA: 85388868726.23.67882C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8CEC340004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:17:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=paCSqT1f;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793593021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qOu9Fz9Gkmb2JiqjJVcPJoJv0zAbcsEJa7ZIZ1WjgX0=;
	b=0uNyM0/YpzNwG5ctgLEoVT2FFQIU/XqevnAdGixGGf5c4FzzFyUFpbEtSHcSqrk9xUB7hH
	0xpuo3u0hs2JXrkjpsBcw9ItKkDHwW8KYTCjwKRJ8YzUBgdHSK3JN9IFZwzTLs5JFr+B+I
	njzh83HztVINsKTo80jIEbwxGFxUk28=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=paCSqT1f;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793593021;
	b=TnRVrHPLVnZd/RVgzuEUU+Pqp6TXQVZGFX50Alj9Ev4BsPDIZCIdDVz0nDlJKpFQE59eF8
	wIYWWJHKMbRkmVJ6xYoowFP0ycHaH/2LT1IyesuhOgvU23F9V59PmuyhdCCu2hz5KV4RBM
	UtOQH6654AwdE6VvSPGxSuPvNsyHQBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A69E340DC8;
	Mon,  2 Nov 2026 04:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBBA1F000C1;
	Mon,  2 Nov 2026 04:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793593020;
	bh=qOu9Fz9Gkmb2JiqjJVcPJoJv0zAbcsEJa7ZIZ1WjgX0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=paCSqT1fgOnLEfJUGav25R0/AtwIZs9BYBXFB5RJU8b8grNZosAb9BQ6xq77QJlna
	 uJUIAEHdWv7y7E1C90pAD07AcMsPBf+hbdyGV+nKkXn6bWw9BBolMehYZCY0SBKdFR
	 J/Lv3+8dkfSSRfw/KoM0+AKZS6oWOP2axTr9Z7ZQ=
Date: Sun, 1 Nov 2026 20:16:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin
 <npiggin@gmail.com>, Shubhang Kaushik <shubhang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmalloc: reject overflowing vm_map_ram page
 counts
Message-Id: <20261101201659.c6c07375429df81081ce8b0f@linux-foundation.org>
In-Reply-To: <20261022-vmalloc-reject-overflow-v2-1-0db7a20c53f0@gentwo.org>
References: <20261022-vmalloc-reject-overflow-v2-1-0db7a20c53f0@gentwo.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8CEC340004
X-Stat-Signature: ohqqcfxz9ohs4i6ubqu1eg7ond4fw9i7
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793593021-402534
X-HE-Meta: U2FsdGVkX19VfFdL25NNvfyX9awcHycIHlYwM3yfGGgz5ynqu0TnunjnmeDrMqUNPr5k0MIT0o25cRocssG69Amo7JmAAzjEQYXTck9kGpSISf7wwTPysWBYx1JJNxPC1u5DpizerdQ6qEmQDjnixx+Kv+MLbbOrOUyki2DO1q/MlQRDa1wc9o0XKV8/1lgQfvzTODOTHeUQ1yLB0Q2IYER/IDJTiEjfw3a97ZVYrrldrTYJYYQgW7e9++UBBDMBiULyc0wdW3cVM+/WBeT7/cw1TQxLigNbeaizduPhn4z73H84EzVM5MErTLYLDKCgspjyX4TrOfo1kWMtlaCj2n4+RawntK5LvVK+YFcclHCGhz5UBZYodHaq2VlQ8mBut+E9eNv6PpQAI3mKg8nY+1elbiSyMaHxEv02iYds27ed2Jv0ksO7h8h+dEbi+MVxD6pSVNAMWswsAH+P8kovjLIZtop2hyIF7rt8NQ25D3Cip2EbmIIteVrWYX/U1v311y29XMFiA9kwuH1J8709t6Q9JuwGmI5vno143IuOgBKZ9+HxR5GRk2Rd4okHcUXzxjTaBjYlPAUdWC9FreDu+pn/4neT0Tr2aVe/Jug+R3545bev9yySBONBLiy8MGOwfZuC3i0CGD/R1ON22l602yjAigolAgNZwyqbMv9h8ML0JLQ66QS+8Axbf3I62rxaUxZiloVsuxm/3tGKRtenjH3+b4ZbsY4Mk5XZN7Ny93n7AaMGwZgYWkBMK/cHgJ54bF7Uv/8b51j65UyObQC5Ak++EngI1UtwPgjGE14JGxk03WNNDdKHqDTH2GeQ+GZy0LjIGBz+uPbpUD1Ae8q/2xgubSNxt4lnFGOjc0mVA4HfXoNtp15IgGRRrYFtUJg3G3L3Kt2tU7Yf1dFadOnVhBzrFE635znMwpi8sWYd06Mbc0Wx7iYEAtbC3j9rR+mWgt0hPCkquM+ESQ9w66Q
 31AArcWB
 MOqX7CW9UI/BqhqZ1ih56UWJ+f4lN5l/B3pz/vGpjJ+CkOOubroYeBkzlcgDNUDoCuLMeMx/X2fp8TlYXg3LaVJBs529HY8FT253kY+kxr95paHmNjvnBBSqhoLhaVY8KceQKUqF6AxvvNZXqg4v6NtRXyuDtgvdiSb0+4nmGmFisBQBAes/LCJT58YuvF34xuVw1+Mf83fx1z/zxTK1iR8mx1hdIHK6/pR2CtiZCzAPOPjs8QNAJD+DL2SCyhF7d9VtXb8OYWi+BHjfnX1Wm5upYLGtvpdB9jCe2Sn3UJDz2/uHdsGGQlqDAOxJOHYdpBRnkV5LEyLGvBBn7dDx3wonhSLnQwN8tuEil
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 22 Oct 2026 23:43:47 -0700 "Shubhang Kaushik (Ampere)" <sh@gentwo.org> wrote:

> vm_map_ram() accepts a page count and must either map that many pages or
> fail. It currently converts the count to a byte size with:
> 
>         (unsigned long)count << PAGE_SHIFT
> 
> On 32-bit kernels, this conversion overflows when count is greater than
> ULONG_MAX >> PAGE_SHIFT. vm_map_ram() then allocates and maps only the
> wrapped byte size, but returns a non-NULL address to its caller.
> 
> For example, with 4 KiB pages, a count of 1048577 wraps to PAGE_SIZE.
> vm_map_ram() therefore returns a mapping containing one page instead of
> the requested 1048577 pages.
> 
> If a caller uses the successful result as a mapping of all requested
> pages, it can access beyond the allocated mapping. Such an access can
> fault. If the accessed virtual address is occupied by another vmalloc
> mapping, it can instead access and corrupt unrelated kernel memory. In a
> userspace-reachable call path, this can result in a failed operation, a
> kernel oops or panic, or the effects of corrupted kernel data.
> 
> Return NULL before allocating or mapping anything when count * PAGE_SIZE
> cannot be represented in an unsigned long.

Thanks.

Is there a case where userspace can actually hit this, or is it a
theoretical case which can't actually be encountered, or something else?

> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3083,10 +3083,13 @@ EXPORT_SYMBOL(vm_unmap_ram);
>   */
>  void *vm_map_ram(struct page **pages, unsigned int count, int node)
>  {
> -	unsigned long size = (unsigned long)count << PAGE_SHIFT;
> +	unsigned long size;
>  	unsigned long addr;
>  	void *mem;
>  
> +	if (check_mul_overflow((unsigned long)count, PAGE_SIZE, &size))
> +		return NULL;
> +
>  	if (likely(count <= VMAP_MAX_ALLOC)) {
>  		mem = vb_alloc(size, GFP_KERNEL);
>  		if (IS_ERR(mem))
> 


