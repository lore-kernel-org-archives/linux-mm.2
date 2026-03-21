Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D9A109448B
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB626B00E0; Sat, 21 Mar 2026 13:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC7F6B00E1; Sat, 21 Mar 2026 13:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2506B00E2; Sat, 21 Mar 2026 13:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 037856B00E0
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:09:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99FB113B406
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:09:43 +0000 (UTC)
X-FDA: 84570707046.04.4F40ABE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id ECD6B40002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:09:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jh6SAUnq;
	spf=pass (imf04.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774112982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iJ5nZ2d9dUW7AcP3fDTFNk3xrnJ+MsaqIqJB/tfUDM=;
	b=LlC6ZsRuGeA6CLIkWz+prcq9W2eoAKCWpboN8p9Zm1b4kzUFZ1t0hmCRx3UaeAvPrFOsHk
	EPg01tmqoyGZ+rsZAz7kWvOlseA+II5lq3H4oae+sxGyI9brSGWlwRunq7URnEzO61SA6N
	cOph+PuHTcGm3Ip/I/oxWWD1s79UZDM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774112982; a=rsa-sha256;
	cv=none;
	b=okhNAT3SSxXdpvjHCeMd3DdOBm3Ovc1cSgZI+mAZZRYnsJaT7zVjnueUWCDLyRIopDpCx9
	7IB8cuQH7HRlQNwNtOam0rxlYh0ubVapFZaQ5Z/MYWY+VUmyqfhjRZY/W9tPT8HKNCKmlg
	YWt2ibjozakz6M3SczaGBSCTqPSiU74=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jh6SAUnq;
	spf=pass (imf04.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 454CB60123;
	Sat, 21 Mar 2026 17:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95077C2BCAF;
	Sat, 21 Mar 2026 17:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774112981;
	bh=mUNbMQfO4rpeYow/b0+pflkL3jP+HOd0P4GbmoKUSKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jh6SAUnqnk0iDgHuZy2XaTJ3JIukcp1PuhJStxshRX+eZKhqYz0DA3sKQ0b3LvqF0
	 xwadeNSh9TqkTttg/6m+P1pPGgD//p4W5JX/6pDdvdCnJP6Np5Q3CctH4iUzWYdxc/
	 RBgi1p9txKsPgcpRz3+E/6RXcLnPjwZw00wvXQ0Y5aVsQmHvfd0dZZ1qPCoiiImV8N
	 BDw0nxNV1fe+MJCNd7erbjuyEn4NQTBgm2Tcos0tDzSTXGYSaMbD7vyMz7YUrwxfdy
	 FMNkOwDONIvVj9fkohZr0uHGStX3h1W9JWMBL9VQnYP/5KSjvEqJ+H7WWngpcq5Bh8
	 ThMX5Tr7qRgrQ==
Date: Sat, 21 Mar 2026 10:09:37 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Joonwon Kang <joonwonkang@google.com>
Cc: tj@kernel.org, cl@gentwo.org, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: Fix hint invariant breakage
Message-ID: <ab7QClPFaFAWsxBh@palisades.local>
References: <20260320115214.143933-1-joonwonkang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320115214.143933-1-joonwonkang@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECD6B40002
X-Stat-Signature: fxio8km7yuey9jig6aurcpy9woc6cwhe
X-HE-Tag: 1774112981-224845
X-HE-Meta: U2FsdGVkX1/j6u8+Ph8jB7LLjTjSv6TscR9vXm4f/Arp9HoGKBjjKVyexyU+Xhq5TmwNwOwdj0EoRyXOVkk3g5lc3OOPsHq9LOEpkd69OZdzHtEhgb2YiRuHhNOM/QEtCHCZ9prOMe6VFPkX1V6QAqGcXv/VrM4rKcV9Hq4+az9NA0IhR1hHB+njhWkMglhe1Ya6Ex4DwxdoYPALquvBqSvTHz9gXisX5xf55/JFPTIMxVRho9VqJH3PVDsNgzfH79CTnnMG3LBSiL4a8+5zMPLomAxkrUAeGqw8IxhU3j7+xU83CpjWSO6aK/5YnejyqHINlgGNKzchDQkGki9Qd/SrV/urpwsWPI/rJoAM0ft+nGb6gGa9SHAcvJvcWLiQ3qrwMN3B2M4AHEs2tVRM/4SXKbSBDUzMCoxbzT8ItEeYLxB8oI1j5XSsWDuRx5MNIFyTOaho3mCzAdRJgg009x2xkcbSBP/lIT9s6ase3jWkh02RUjt7n17KFy0My+OUIqgYy7uye80WmcCnn7B1S+lrPbRlYrZBBsgDL7KGxam5ZhhC9979PjOY6smejORwcR+8lHLQfcz1hSOsHAVkECNFzYYkKJ6CCsrSiVrJcUhmKoTMTecGHQf8PSSvtydoNky2M4iulddkuIfCbKhAbDnbIEfJn5ChJfXnbT2sJgksJQuhpZqUe21neyWde1OGI4jnTPEs5uxnDHW28QVmUcJlBvONqYPxxCwX4TOm7ZyQSI+EnST+vlLILCSqtQT2eT8KyyRXu+3yZr9JRwmSbwL6NWaZSvL0rpBBJhc1CDErsnnBj4HxYcti8TKQ/R/jbaQA++/DM7Riud+wWjOZ5zfY2P77edkg1McVLG9i6X/b4lzSUiH8aQH6tOFQNx1y64UryfRDok7UMHW+ke71yk2TNCLvkvl9JRKanBoxUuIFxwe+iI07Du4Am2GO634DuJl1J97TbyzbYB51Stx
 ecntTK5G
 b+Talej7umksQJiesqn4Ezt1xtexLDLGwB7zqMraCoiZjq5GUgpbvbk3+Tazyu1I+sq9P6OIXsI9nlrBSuxtXTlN2ygOifAMMVCVc+OGs/3mWo0kQWk2ueIKRHqc1pHcvjS7xuto5rAe8EcdPssuc3GOkHHub21wfAUmF/r0nyqmULCqqz7aPDOdgTPJaZhoUcADHhLTTuJCdNT8vF8btfuqShTJTrnc5VxIHu/YGcAJZmR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Fri, Mar 20, 2026 at 11:52:14AM +0000, Joonwon Kang wrote:
> The invariant "scan_hint_start > contig_hint_start if and only if
> scan_hint == contig_hint" should be kept for hint management. However,
> it could be broken in some cases:
> 

First I'd just like to apologize. I spent an hour yesterday trying to
remember why the invariant exists and the reality is this code is more
clever than it needs to be.

As Andrew asked, how did you come across this? It's pretty obscure so
thank you for taking the time to look at it.


>   - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
>     scan_hint_start < new contig start) && the new contig is to become a
>     new contig_hint due to its better alignment, then scan_hint should
>     be invalidated instead of keeping it.
> 
>   - if (new contig == contig_hint > scan_hint) && (start <
>     contig_hint_start) && the new contig is not to become a new
>     contig_hint, then scan_hint should be invalidated instead of being
>     updated to the new contig.
> 
> This commit fixes this invariant breakage and also optimizes scan_hint
> by keeping it or updating it when acceptable:
> 
>   - if (new contig > contig_hint > scan_hint) && (scan_hint_start < new
>     contig start < contig_hint_start), then keep scan_hint instead of
>     invalidating it.
> 
>   - if (new contig > contig_hint == scan_hint) && (contig_hint_start <
>     new contig start < scan_hint_start), then update scan_hint to the
>     old contig_hint instead of invalidating it.
> 
>   - if (new contig == contig_hint > scan_hint) && (new contig start <
>     contig_hint_start) && the new contig is to become a new contig_hint
>     due to its better alignment, then update scan_hint to the old
>     contig_hint instead of invalidating or keeping it.
> 
> Signed-off-by: Joonwon Kang <joonwonkang@google.com>
> ---
>  mm/percpu.c | 60 ++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 39 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 81462ce5866e..a0e4f8acb7c2 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -641,19 +641,13 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
>  	if (contig > block->contig_hint) {
>  		/* promote the old contig_hint to be the new scan_hint */
>  		if (start > block->contig_hint_start) {
> -			if (block->contig_hint > block->scan_hint) {
> +			if (block->contig_hint > block->scan_hint ||
> +			    start < block->scan_hint_start) {

I think this should be <=.
Given hints as [hint_start, size].

contig_hint = [64, 64]
scan_hint = [160, 64]

Free [224, 32].

Without <=, we don't promote the contig_hint and leave the stale
scan_hint.

>  				block->scan_hint_start =
>  					block->contig_hint_start;
>  				block->scan_hint = block->contig_hint;
> -			} else if (start < block->scan_hint_start) {
> -				/*
> -				 * The old contig_hint == scan_hint.  But, the
> -				 * new contig is larger so hold the invariant
> -				 * scan_hint_start < contig_hint_start.
> -				 */
> -				block->scan_hint = 0;
>  			}
> -		} else {
> +		} else if (start < block->scan_hint_start) {

I think this too should be <=.

scan_hint = [16, 8]
contig_hint = [32, 96]

free [24, 8]

scan_hint stays [16, 8] instead of being cleared.


>  			block->scan_hint = 0;
>  		}
>  		block->contig_hint_start = start;
> @@ -662,20 +656,44 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
>  		if (block->contig_hint_start &&
>  		    (!start ||
>  		     __ffs(start) > __ffs(block->contig_hint_start))) {
> +			if (block->contig_hint > block->scan_hint) {
> +				if (start < block->contig_hint_start) {
> +					block->scan_hint = block->contig_hint;
> +					block->scan_hint_start = block->contig_hint_start;
> +				}
> +			} else if (start > block->scan_hint_start) {
> +				/*
> +				 * old contig_hint == old scan_hint == contig.
> +				 * But, the new contig is farther than the old
> +				 * scan_hint so hold the invariant
> +				 * scan_hint_start > contig_hint_start iff
> +				 * scan_hint == contig_hint.
> +				 */
> +				block->scan_hint = 0;
> +			}
> +
>  			/* start has a better alignment so use it */
>  			block->contig_hint_start = start;
> -			if (start < block->scan_hint_start &&
> -			    block->contig_hint > block->scan_hint)
> -				block->scan_hint = 0;
> -		} else if (start > block->scan_hint_start ||
> -			   block->contig_hint > block->scan_hint) {
> -			/*
> -			 * Knowing contig == contig_hint, update the scan_hint
> -			 * if it is farther than or larger than the current
> -			 * scan_hint.
> -			 */
> -			block->scan_hint_start = start;
> -			block->scan_hint = contig;
> +		} else {
> +			if (block->contig_hint > block->scan_hint) {
> +				if (start < block->contig_hint_start) {
> +					/*
> +					 * old scan_hint < contig == old
> +					 * contig_hint. But, the new contig is
> +					 * before the old contig_hint so hold
> +					 * the invariant
> +					 * scan_hint_start > contig_hint_start
> +					 * iff scan_hint == contig_hint.
> +					 */
> +					block->scan_hint = 0;
> +				} else {
> +					block->scan_hint_start = start;
> +					block->scan_hint = contig;
> +				}
> +			} else if (start > block->scan_hint_start) {
> +				block->scan_hint_start = start;
> +				block->scan_hint = contig;
> +			}
>  		}
>  	} else {
>  		/*
> -- 
> 2.53.0.1018.g2bb0e51243-goog
> 

Ultimately as I re-read this code, it might be nice to rewrite it so
that scan_hint can be kept separately. The code is a little too clever
with trying to avoid stating new_region overlaps scan_hint or
contig_hint.

I recently started shimming out the bitmap code in userspace so
hopefully I can test it for performance / correctness more rigorously.

Thanks,
Dennis

