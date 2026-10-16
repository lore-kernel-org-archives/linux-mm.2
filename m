Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD3ECC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 01:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668766B0095; Thu, 15 Oct 2026 21:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618576B0096; Thu, 15 Oct 2026 21:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52EFF6B0098; Thu, 15 Oct 2026 21:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBD86B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:40:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9781B1C21CB
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:40:18 +0000 (UTC)
X-FDA: 85326784116.24.EC0B90A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B7B841C0006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:40:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uheqztBX;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792114817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OqA+IMC6CUvEx2INsJZJI6SA5Kzqwelaql3bEKHklyk=;
	b=7PLtnkMw9acbrL78A1CQaOxoCZ31enGml78cXba+zCpRHaPjAKykwGOjBf6Qrg++KeHKPi
	52n7zfifq+YAWUiVlTmD3If1eedQ87RDXjeBLl/ZCMKRFhIpvOE8PK7thSun1AvCPKasJ+
	lYvmqhOo84VfX35S/XeHpZFIA0ersmw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792114817;
	b=6A8WlecqRgfaISjQIYKiqbIzYyMpgy/+4twj1EV3kaUeZ80bXC4ovCU9gho7X0inb4Wgcb
	NLNpVEknuBm8q+81nAnSk3f8nN5RjgG7MjhVqvbhsCHpf1xRRzO09W29JxbNqzL348r8VU
	uU7jZqDgP9LOx6c63L24utqPV44bJkk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uheqztBX;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68494447D7;
	Fri, 16 Oct 2026 01:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ACD1F000C4;
	Fri, 16 Oct 2026 01:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792114815;
	bh=OqA+IMC6CUvEx2INsJZJI6SA5Kzqwelaql3bEKHklyk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uheqztBXAXmG9qw9vDm3YiF69UyyJRc8UyD8oZ/QJCGiWUlESf3T5A6EZIGVHIl3v
	 xIyts3pqh187rqqiyrQMYwSn96WnREf9JT70qJEtQxry1kL8gmoIIFmIjfIHAIcUf5
	 59w11rC4mmi44ykUtuRfqBlUBIYtzcdUOX7xWA5o=
Date: Thu, 15 Oct 2026 18:40:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, Chris Li
 <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/swap: fix swap_cache_get_folio() returning a folio
 that left the swap cache
Message-Id: <20261015184014.715dcdd3a25e18fd4df49e95@linux-foundation.org>
In-Reply-To: <20261015060528.302634-1-jiayuan.chen@linux.dev>
References: <20261015060528.302634-1-jiayuan.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B7B841C0006
X-Stat-Signature: 4goibyzki996n63ac156wbt5u8ejd8dm
X-HE-Tag: 1792114816-826919
X-HE-Meta: U2FsdGVkX19ap5x5PfvgWKGu4hK21txjklxRpexeQF3/Yh8FT3VN02Wq3uYVC5KB1lLLT0188nP4IwAw8Gm1wA8C5QUmtz+dOTb58YyQ/ZM/qdw3zP0vAm6CDZrYKnr6qiN9waqSt+yv+A1NhWjaeun98YAgu05H0DlnydXxD4RAVcKARr1HgXZbdLKRbQRHEfIn+s2twS3JIQbcVuHHRCqCbLzCMnWlSWk6rDjr3BQ6SeHGcSItp5b5xe4QSdfyIpxLCK0lF4SyPfutpiQo8hHoGmSPrKrBo0vqQ5gAfDE603C5HYxlgqDnqpnccDrjGKELZl51aHCkIQf7HhxuRvcgap6MTeI5/6pydEOVCQKDnLHlC9qwoCEIqg9+ISKINwo7u3cneU57YqbhSB0hbJdVAam/9fyxqIDec8q36iDQIudX4RckJSMCxFElJ/WXCTexQxu8jvBoOzxjjjr6S0lBeDQ/kR/xCAP2g7xwOcGZ29j7Iyyq+iqa76gwWQTQLpYnL7fBsX1D6hKtkF0gMZAKdV9UFb8YE46TrVPC7URQnIw3DL+RiYe3Wj4lubtxBEmcIMOycTYTjXcOiXk5T1r1QZYoVZzcN1s7AvmWdmrcC08CisuzwTF2sWdJX4fIe24nmOpUXkN7wY/0+n56APmSo6J+Wc1lLYlKoN6qnPUvBIiskHtx/M/vnyj4tZQuGRVyIe5Onw5pwI5L5LxDXVTXtVnFEuYmTzDROMUiXSzmQUkbC79e8AOcgnvskBMZ/l4I4zLwwP1jR1puoASvU9k3psZv2pKxZ4J8QZyehWYk4OpaunG2dl0xzM/utubCEATO1TtT+P7Z7enSXMiv/P5zS6EbNvx2HNLZHG6p2DEz/JYQt91FONDMynxcLnrU0RwGch7QjNP+lg9PSxGtmuZ+ILI4Qr/KUr356FdH6bfikxSL/uzRoorLEnQlgL07rfX7WEX1votP0C8APvo
 m2qQGyn+
 af+cFrcl2UyL4KIGzYB2pmqNsLx2H4isM2jFzbGCHSXnofP4ATF6tQPPOCRC1hoppNcEv/4IAxLRN63fCVnn5lM0JzgMGfUX5HAFpQp5rRWj+qTalobSJA0eQbM4C1QkQ1Qs7SVnu53LmWqP52dEZOaqnAaL/KaF65q9wkIm/YGRDih4hKoQ0nnsQC4/yCTqTFmDAWhcimGyGF/cPcIWxHE2spVJYjKj6K236vCIT9UU6yBzxYfal3DXaOtDrOnauMg4h5xg3LGCv/Y/HpGHlvpHi0GWTYj7W2jwKXK1h0ZcNrxKF8UesFb+xcjldEC4h9kwbOkc9Bmu9a6GFXMsOVfrlvLJGHkrx5ba7fvAFwsBhkGh/+haOyIM2poalpfFoqvQwPNYySNt6uSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 14:05:27 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> swap_cache_get_folio() reads the folio from the swap table and takes a
> reference with folio_try_get(), without any lock. If the folio is
> removed from the swap cache and freed in between, and its memory gets
> reused, folio_try_get() still succeeds and we return a page that has
> nothing to do with the swap entry:
> 
>   CPU 0                                  CPU 1
>   do_swap_page()
>     swap_cache_get_folio()
>       swp_tb = swap_table_get()
>       folio = swp_tb_to_folio(swp_tb)
>                                          madvise(MADV_DONTNEED)
>                                            zap_nonpresent_ptes()
>                                              swap_put_entries_direct()
>                                                swap_put_entries_cluster()
>                                                  __try_to_reclaim_swap()
>                                                    swap_cache_del_folio()
>                                                    folio_put()   <- freed
>                                          page reused, e.g. as an anon
>                                          folio of another task
>       folio_try_get(folio)               <- succeeds
>       return folio
>     swap_update_readahead()              <- may clear PG_readahead on it
>     folio_lock_or_retry()                <- locks it
>     folio_matches_swap_entry() fails, unlock and put
> 
> filemap_get_entry() does the same lockless lookup for the page cache,
> and after folio_try_get() it rechecks the xarray, because the folio may
> have been freed and reused in between. swap_cache_get_folio() lost
> that recheck when the swap cache moved to the swap table.
> 
> So CPU 0 writes to a folio it doesn't own: it may clear PG_readahead and
> takes the folio lock of someone else's page, before
> folio_matches_swap_entry() finds out the folio is not ours.
> 
> Recheck the slot after folio_try_get() and retry if it no longer holds
> this folio.

Thanks.

As always, when fixing a bug please fully describe the worst-case
userspace-visible runtime effects of that bug.

I asked $LLM for this and was told

: When the race occurs, a swap fault can acquire a reference to a
: physical page that has been freed and reused for an unrelated purpose,
: potentially by another process.  The fault handler may then clear that
: page's PG_readahead/PG_reclaim flag, wait on or acquire its folio lock,
: and potentially attempt to remove it from an unrelated swap cache.
: 
: These operations can interfere with unrelated workloads and may cause
: unexpected stalls, impaired reclaim or writeback, and potentially
: system hangs.  The subsequent swap-entry validation normally prevents
: the wrong folio from being mapped into the faulting process, and
: neither data corruption nor a kernel crash has been demonstrated.

Do you agree with this?  OK with me adding this to your changelog?

> Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")

Given the above, I suggest adding cc:stable.

Do you and maintainers agree?



