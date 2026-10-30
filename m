Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18CA5606A324
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Z4K6iNgA
Received: by kanga.kvack.org (Postfix)
	id 3C0076B00EF; Fri, 30 Oct 2026 06:12:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342636B05B1; Fri, 30 Oct 2026 06:12:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20A6B6B05B2; Fri, 30 Oct 2026 06:12:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7CEF6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:12:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1EBB214060B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:12:08 +0000 (UTC)
X-FDA: 85378877136.15.8DECC36
Received: from mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7942E180007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:12:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z4K6iNgA;
	spf=pass (imf06.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793355126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTBQskGF0pRfZtCmZB2evU3aYqcLsQnaOI3cIHml41Q=;
	b=1AOhHbZc3q9Tt9xLwuTlWXYMeEzA1zwTNLjxPo51ltMcM512scjmaMyhKV94fw5BZiYMqt
	y7SSfe9YJT/wQsEsz2RxI2XPlBFifjazHXTLqphiucGhVsKyPBmMle9qf6IEY1FAGuz96a
	xXlNX5Hlj4q+sGUXtNyz3wfT98C7Bx0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z4K6iNgA;
	spf=pass (imf06.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793355126;
	b=bUkut9App/BafjM9FKbsfmmGnd2U7YdDTNFqwfdpzB+ZuRrFTiuohFQOjd7E7S6tGN+YCe
	neBM+MG89hNxwJIpGyqMU+FJ0jEDn3gLaMn7wnyU+FdHqq3B123oO2nmRoRk3xfVP9mcFr
	iFM4XK3BJmw7UgOv+VkYAyen5XpMEoo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zVJUTxa87d/kLUCCODvqIoVfNUNdZFqklj/vKt8Altw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793355121; v=1; x=1793959921;
 b=Z4K6iNgAXgt3aRc6YYkkY0fxOQHM6AKCB7VSMV12z+8xps3oRbY6R6XCXjh9fWeSTAAUW7m4
 GzTnfaVWr9vCSiVsjqkKWhz8l/a2nurVGfUbqC6itkneIFNftchCLQMY8R9bcmeE6jBXiAVr44P
 EURN/BFFNLKyuePDXHIxayZc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 230bc242ec33716c;
	Fri, 30 Oct 2026 10:12:01 +0000
X-Mizu-Trace-ID: 230bc242ec33716c
X-Migadu-Flow: FLOW_OUT
Message-ID: <23a3fa60-9489-48ff-ab0e-38a865d6bde7@linux.dev>
Date: Fri, 30 Oct 2026 18:11:51 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/swap: fix swap_cache_get_folio() returning a folio
 that left the swap cache
To: linux-mm@kvack.org, Kairui Song <ryncsn@gmail.com>,
 Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 linux-kernel@vger.kernel.org
References: <20261015060528.302634-1-jiayuan.chen@linux.dev>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20261015060528.302634-1-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7942E180007
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 7du1rtsxqwsbty87fcg4abat1xab813n
X-HE-Tag: 1793355124-447131
X-HE-Meta: U2FsdGVkX1/T+md5IsI4fo+M3p8Sse/OAWbKL03wnEMTDu3Iv3xCc+jrh35mdy0DWKv6/b8LVpMTB5G00Yr+mvTD8nKmM7oO0Vuatwp8TQJ5Ku8fFNBvVmNeDHg650Kv7Hz9UVCsXFPBY5wN99l8nOrgurJN+GMtNc3o5CFZGk8XVBDEnp7+qS4r8gSFMoispnDMhqqG0vnzwwJib4riU8GA0oclqbeZTlLpRs4PQxzNs0kQES/KkSMS0ydHHj1VDCnSPZEMPJKqaVSMq9914rc2rW8i0s2SC3WQ2WjdIO4EibUWY2Dh5TmWyDsURZkEX+zr9MvODpICCztxSZFOmM3rcawEYgHDY+p5ALJb31R1x2kBoVeWoM4OPIjp6mnPDNeZwWVzK3nNWPKLeC1FZS9mtRBe+3HN/3W95m143wk353nkWNGu5wXSYlIH8wbmRU+oWVA71ilC+rJkcDndn6KT4bWnpFtSJIYzXGuTRrcAW6YQdk5VdosmvtJCiH0UGj9eXxwmQdOOJ13nGfZ0wg6sqPIXpC91CP3dYDraayGWiSraOWlrwogV2sozTBa2UBa9j2CqFCFUvk0y7B7zgHNOorXjFMOb3EgrwCgmRpcxCsQRgoxMxBYkrGSHld6rBOQWWSOLlOjwQ8GzzPgomzOv1ZWhnF+ieoxU+5LEUdsMkrVe68+d5XBa2xcNw0XOEk1qvb1/Cg+TUD0+Ip/v6YkSQAvfLllGa8WsHXnKlvZiH9OGz8CSSxi3mUHdLHRet7IeG8rO3upmjN8uYJrJ7DX1hwbUF/jMVh7tLLtJ4ptMBTEkoxdtJ/3CGQtaOSw9ljXbHZVW6BA3EDlQ6nI3M73/2LyGL9FNfi7LJJHgLECd8kjL5e78Vrukd4VXk2UVSsBG6uV9CL/7NYDj3v7srPiZfajXp4wMrAkU36wqB1gf9JHVG40W419xdw5JAYC4aaap5GzkKCXGAf0VpQe
 Cfo4jVIW
 pYtcToOFOSqSvmMQKBI0Cjkp+YZHopMrgzCf1I1Tr2GgZBpgXRbrJyPk3/sLB5oBeFtUUBFmO3ScqweCoh7DOCzeW1XIVUBp4yh+Fg+RGIG2jBJ75E6ODQn0ov4m3e5l8NE28VuKtxGfV1MLaXzAvmQXyyLV6J866ElXKnYnnaKgFgiDHivasswT3yz6hPFe2mTgW9yv3IqlvYJYCicHU99iYKqewNRkMn7QpROtvyICEH6i0ay7+CEG854Nfng3qmies6Q/SxFPX3Lh9bfyvK5goQiv0oRXRSHYlCH8xZYJbCcEJNQZ6o/7Z5rBGgPglsg4L/20GyAO3dTuCiaBGVy91ywhVSmySXniwODxh24v+lV9qN5mAX+cph7EmAOB7Ysh1QTTPMx0b22LsVGrYGEIeIowKDO6FUru5O5ySPP97mPDYgBKCLA2DHDc4utMkQi9FKhpmWwm8CNmTdr3WWAdl1KAzQR1z0Mrirtpv0/ekwI2uMEfhwA39LTp/scszYQJB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 10/15/26 2:05 PM, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>
> swap_cache_get_folio() reads the folio from the swap table and takes a
> reference with folio_try_get(), without any lock. If the folio is
> removed from the swap cache and freed in between, and its memory gets
> reused, folio_try_get() still succeeds and we return a page that has
> nothing to do with the swap entry:
>
>    CPU 0                                  CPU 1
>    do_swap_page()
>      swap_cache_get_folio()
>        swp_tb = swap_table_get()
>        folio = swp_tb_to_folio(swp_tb)
>                                           madvise(MADV_DONTNEED)
>                                             zap_nonpresent_ptes()
>                                               swap_put_entries_direct()
>                                                 swap_put_entries_cluster()
>                                                   __try_to_reclaim_swap()
>                                                     swap_cache_del_folio()
>                                                     folio_put()   <- freed
>                                           page reused, e.g. as an anon
>                                           folio of another task
>        folio_try_get(folio)               <- succeeds
>        return folio
>      swap_update_readahead()              <- may clear PG_readahead on it
>      folio_lock_or_retry()                <- locks it
>      folio_matches_swap_entry() fails, unlock and put
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
>
> Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
> https://sashiko.dev/#/patchset/20261014090821.227366-1-jiayuan.chen@linux.dev
> ---
>   mm/swap_state.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index ebef568cd62e..d9e36c505398 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -92,17 +92,27 @@ void show_swap_cache_info(void)
>    */
>   struct folio *swap_cache_get_folio(swp_entry_t entry)
>   {
> +	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
> +	unsigned int ci_off = swp_cluster_offset(entry);
>   	unsigned long swp_tb;
>   	struct folio *folio;
>   
>   	for (;;) {
> -		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
> -					swp_cluster_offset(entry));
> +		swp_tb = swap_table_get(ci, ci_off);
>   		if (!swp_tb_is_folio(swp_tb))
>   			return NULL;
>   		folio = swp_tb_to_folio(swp_tb);
> -		if (likely(folio_try_get(folio)))
> +		if (!folio_try_get(folio))
> +			continue;
> +		/*
> +		 * The folio may have been freed and its memory reused before
> +		 * we got the reference. Make sure it is still in the slot.
> +		 */
> +		swp_tb = swap_table_get(ci, ci_off);
> +		if (likely(swp_tb_is_folio(swp_tb) &&
> +			   swp_tb_to_folio(swp_tb) == folio))
>   			return folio;
> +		folio_put(folio);
>   	}
>   
>   	return NULL;




I spent some more time on this and I'm not happy with any of the
options I have. Advice welcome.

   1. Trigger the worker where the zap gives up (this patch). On the
      swap entry side that works, __try_to_reclaim_swap() has the si.
      On the present PTE side it doesn't: free_swap_cache() lost the
      trylock, so it can't read folio->swap to find the si, as Kairui
      pointed out. And that trylock-and-give-up is not in one place,
      free_swap_cache(), do_wp_page() and __uprobe_write() all have
      their own copy. Chasing every one of them doesn't feel right.

   2. Clean up at memcg offline. Doesn't cover the root cgroup or a
      cgroup that stays alive, and on mm-new the folios are reparented
      at offline anyway, so there is nothing left to find there.

   3. A swapon flag, say --clean-cache, that enables the cleanup.
      Pro: covers everything, and the cleanup can live in its own
      function without touching the existing paths. Con: we know to
      turn it on because we hit this, others won't. Needs util-linux
      too.

   4. A per-device worker that walks the device on its own, say 1024
      clusters per second, backing off when a pass finds nothing.
      Pro: same as 3, and nothing to turn on. Con: a worker that wakes
      up on its own for this, I expect objections.

   5. A sysctl (or a drop_caches bit) to kick the cleanup by hand.
      Pro: same as 4, all in the worker. Con: same as 3, someone has
      to know to poke it.

4 is the one I'd pick if nobody objects. Thoughts?


