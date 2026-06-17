Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE76CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39C26B0005; Wed, 17 Jun 2026 09:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E115B6B0088; Wed, 17 Jun 2026 09:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27E76B008C; Wed, 17 Jun 2026 09:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD0E66B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:51:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 387CC1C470C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:51:50 +0000 (UTC)
X-FDA: 84889542780.29.5A316C7
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2FA32A0012
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:51:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MaBFkKfc;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781704308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YIzS4bCHp9S83OoqwEMXqx1qAOUh83rabFYWqN1URrI=;
	b=8gtcemHhC1twS0E+yBPpWyN15rZSXNjBD0O6ryfDshYZf6/XfJlsrzZMrPnd9sf2zwW3Ke
	aPDtPO6sXoNLI7WInKEV+S6FD/2qgbzckyVLCMdQPBIaoVlX+kMx2ZHBXtSuEP2Qar8i2i
	B5yotC0qvv7P5LEvPEEUNaPgY04KUZ0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MaBFkKfc;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781704308;
	b=BQQDqORpYBKmfHo0hWpycLNCTXh8VRVBTTqjPEWvuh/d9W0NRFTZSnvRHEJb/j8IVicIoD
	kFrV85l0vwIRj/kuObln7jSusaVjPaImvUeUCYjIASwiTmEB3hxmscGoSrhUfk1Rb6OHXy
	mtbMn0mlJloFqiE8gUBOv619NS2IgDw=
Message-ID: <4893f184-6534-4347-af5c-efdfd255e27b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781704305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YIzS4bCHp9S83OoqwEMXqx1qAOUh83rabFYWqN1URrI=;
	b=MaBFkKfcN4lk5r4MkmdK+GZRvXI+xtusr6G5VXoo+7mIVzfBakOlg3co21OwaOst4cNLsR
	cvjbjn4fKdY5qcOxKwD3XBJ65y5ENwGybo7r18zOVCP/qLiuzg1t7fRTHHZ74AQvu2scjz
	1JRS3/CeFteR6Rrne4uEGkcT0wyInR0=
Date: Wed, 17 Jun 2026 09:51:38 -0400
MIME-Version: 1.0
Subject: Re: [RFC PATCH 2/3] mm: drop stale folio_ref_count()==1 check in
 do_swap_page reuse logic
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, jp.kobryn@linux.dev, shakeel.butt@linux.dev
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-3-baohua@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260611105124.98668-3-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2FA32A0012
X-Stat-Signature: 4hfuu41qikyhafuqbpccasgtjjm11m53
X-Rspam-User: 
X-HE-Tag: 1781704308-425375
X-HE-Meta: U2FsdGVkX1/+4Azy45iZaRVucvsnYryfPkN8AeE2c6Z6LEnoZ78mCXZmcjHaHUPkw1ZRTtiGN5VvnxGwj0DqD+P8u5+wdUjE3fT2venHntnWL5LCGREe883xGYh5N00wpVsOi3k6oVsOQRGsgEPvktQopd763UWR6ztiE9llM0Xs1JNUqlvj8I0egL59br9DQw8I6juSrReAENw8itVZBJR3LkbNZKlVC88HQ9ymeWEzi/JQ7nymmLtwlD6hA+smZtGwjPSQLgMDeuoEZ/z0aVe1CyH+hlxDAWS0ELrJS5r+/X/M2asGnV3IiwFF6kUyk2fg8Z41mr4ec/a98shGCrnqH8wHrM3CzHyWCSLRTb1TtjuiAibFJNk56bFPPvotky/a4osmHbtwr1J1FPMHLDRmj6NmJEopwj/kgIL4v9aAEWfG9v4U0f92xaXFBwZMqwADstqjaaa3YWB5oJvUbdQXedW7x+1uesxwcyOCaatYhLt7UZrOTcHf+lHEai9WLMQtiWAy8vHEDK5AWmJgPjIAEv6fJwxUU5W0BMsKxaUzuW5UOr6JFbG21k3OsXq3JD23JiMhr7kGSzJB6dcHixbHMwmIpbTG8eOzauQtRgtu7/EUt1OrL00kDGCz8BFGM7P2Hs3hSISjPV1dWIrOvMuZRYY7dMz5O7CgnokhBgO+MREr/HK1T1CNUBHQsVukoLY6du/mH+/pHmzDjlB47hDrN3sXzX69V9+w4zTodPhqsg2wqKFV/8eO4M/w/EguAt+l8C3I+6eihP7g6b+qfN5MNYo4H6Dq2BD8XdivFH3xIKv0VSsrBBcZV3aNAL0DT6LkMw0TR3LTDbtDjtGc4oqchePKi/xhJ4nBfORqTIBxhsPzLU1pq7GsbeX4mf59s0u2xmmwxFJ0vEytM9USKBXQtiJCyGyrpYsGZc0DlhT6ppScvquDme1gOQtYIkL1tV/W0yoojcOrZBYT/Q8
 Wyjf6aIe
 2SiS1/V8HP+zPR6PwUfCp4nIFOIylBhV8NKSDdjgnlYK/WRHE61AkaxyACCqEJRPhec6JHIZiczleONGp8h20I1ivqQ0u1Apt6KORiPdcZ9ptErDovCwA8qIKbvjJ5Ff9FG/GH6LjhxNDm2alKA++a7AZqTmyBO70BSCHtaNOYymGNlL+flldJOvFvZsovE3joZIuPbuhYKhQgqjdapOrp9D6Z6Uhbus44BAFe1SHJv5p5ZG3eXjJyT49H+/rOyXMQ+976rKVEXMHlMWr1WexjnP0oNlo28UnH5/fcM3KPKFc7X8GNCghPoTA4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/06/2026 11:51, Barry Song (Xiaomi) wrote:
> The "we just allocated them without exposing them to the swapcache"
> case no longer exists, as Kairui has routed synchronous I/O through
> the swapcache as well in his series "unify swapin use swap cache and
> cleanup flags"[1]. As a result, folio_ref_count() should never be 1
> in this path, since at least two references are held (base ref plus
> swapcache). Remove the folio_ref_count()==1 check and update the
> comment accordingly.
> 
> [1] https://lore.kernel.org/all/20251220-swap-table-p2-v5-0-8862a265a033@tencent.com/
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 487a34377a7b..ce8ef27e7a54 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5049,12 +5049,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  
>  	/*
>  	 * Same logic as in do_wp_page(); however, optimize for pages that are
> -	 * certainly not shared either because we just allocated them without
> -	 * exposing them to the swapcache or because the swap entry indicates
> -	 * exclusivity.
> +	 * certainly not because the swap entry indicates exclusivity.
>  	 */
> -	if (!folio_test_ksm(folio) &&
> -	    (exclusive || folio_ref_count(folio) == 1)) {
> +	if (!folio_test_ksm(folio) && exclusive) {
>  		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
>  		    !pte_needs_soft_dirty_wp(vma, pte)) {
>  			pte = pte_mkwrite(pte, vma);

Acked-by: Usama Arif <usama.arif@linux.dev>


