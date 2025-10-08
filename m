Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5213FCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 16:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40D968E0044; Wed,  8 Oct 2025 12:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4938E0002; Wed,  8 Oct 2025 12:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3218A8E0044; Wed,  8 Oct 2025 12:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC208E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:18:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5CCB160675
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:18:02 +0000 (UTC)
X-FDA: 83975453604.03.BB50A77
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 229BB80015
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:18:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VrGcwYCL;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759940281; a=rsa-sha256;
	cv=none;
	b=keuT4Hj/lyBgR+ZIss7xHIX4y2diQCJCM2Jmq1wLhwxHnjFfA/9DrCoKSDww1qMpzCgACm
	eI0iaBgRGN+zaQphJ9MmC61VShMc3fsKM4+/XesTYOdw3oa7dZZgIRk5rVa0Vx9lOoPDzI
	Lm04PkOSiJfPxFwX4NkoGYserTC+GQI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VrGcwYCL;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759940281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I6aq5SwqQxzUQvtsSeg2YfAbu8H4ci5QlEizppPzgCA=;
	b=uXXKMEJ2hXb+eHaOL/rI3w9g6mLRaj0f6pw8n0HhVR9Edt65rYIcePTnKDNNM5hAhka1ID
	Yssaz4ZSHPmyu+/8/59hwPO71RuwfBBQo6bQpAPpmotUTwq5hbWEWAnEhB5MPGBMgsu7ba
	NdTQ+U2+l6gRs6sBIuF3s/v7u0wmy1g=
Date: Wed, 8 Oct 2025 09:17:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759940279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I6aq5SwqQxzUQvtsSeg2YfAbu8H4ci5QlEizppPzgCA=;
	b=VrGcwYCLWpAJ2NulmMTuWCkvfMN/ckxDBVcdI0JkZMWibwGNfNcSz/5/hPzNCk+XrhbUe1
	myi6ilVzSrQ7r6HM3rqz3YYyDmKybND1HHfKj1m4t9PDNTaLX/mGmlHEPJwWjzKzNRJx+l
	cpzd1/qjHqNrKn+W568iUpWpU4HjwYc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, hughd@google.com, yangge1116@126.com, 
	david@redhat.com
Subject: Re: [PATCH v2] mm: skip folio_activate() for mlocked folios
Message-ID: <ltvv3v4vibvlglpch6urayotenavpzxc7klbcyowjb4wrv3e7z@pzovtvtbmnsp>
References: <aOPDRmk2Zd20qxfk@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOPDRmk2Zd20qxfk@shell.ilvokhin.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: id7uaw6ptjai6stk498tqci3oo4hsqq9
X-Rspamd-Queue-Id: 229BB80015
X-Rspamd-Server: rspam09
X-HE-Tag: 1759940280-762605
X-HE-Meta: U2FsdGVkX1+OrLtWuEbAWR2+gqhT1vMQyyNSg2TCs9DjEzBmvALhjg3K5KVzgQTi5bOydJso6Wm2Lequp3Df1amRxRugFG+x70M9Dk4pQeq9Ugfh2XSYzKcr6vpYQBS32nxRrJ42H1KqPBwHVTbNlc3TPYL+5m+r1gyQKvlaW4BbfJEidHsnNhxw+YwwmPuFcdff/xk7h8cBZ1CaEHl0GKcjO4OpGr3Mnj00R/mTs/kwNqSzzOKqOu+MJP9fkd75W/xPYnT2ReK5y0T5YhVzMHeKKKDywCWexe7KlIjmsyic/YGoHtO3et5t3AgWvV1/gjHlN/UrjJFvYPLCPQ/KC9pcilDLgwmH3pcB40VjdZW+hF/8LXIXwivtV/n+vX7fAeOK2CE4whzsEBasgr6Og2VDPv70GuJIpOu1VyJ6uthOopwNS+YSks22aL5J6AR5+eHZytyyd+WfD4z2jDoMZpIup2jfz/8ugHUT5aYTOZxzwyX3W+TAiz1qWzCee8oRhtvf7nwg+x1l5/pmz1nuTKowY9RzF2JIT/1+ILOzJchcsdQU5ZEX7Y5tDXQuMbh+ajOLfi544Urlua2pnvF8IVYuRr7v/BTgEVlSkRsNulI8A3xdNYM7eZWTyb9A+vPoG5OWYIki1Xx7Wa8q/8F7bfbgqoCe0u5jZv3Lean1Wj9oc4fo9INOQ459BG5IbDrMcQyjF9zBUOSUeUHRhtT5wI4plZYqQT7mVCFH0e2qieQvvNZZp1U/nGDZfR7MzCPqOOqOvIywwmV7KqRdaVLkeXUluspLo3nStlPTWik+uDRc06m+q4Is8x2dsBSqFm2TAt2aETeKyWFaFZP2LCNXH6q0nTpMm3v8jL9eDeO+8sQq7Zw9LejGTZRWm9v9/eYt8PsH6zV5p/r7Af6FLcCnOeeVItZmZG19RGo1YyG87O62k3vTflOiulD4VjwYreSGVxVfoeaKlO0SRpCYKZi
 SJwEbLHS
 PFPNpvM8n+M5IwpUnlVP9imOM4eAKs9YA/T4btVIo3SHyM8x+MdZzzWFwYc+8a3YT+Ep17+2m2NDUIcyiteHrbCMBoKoyvSAOdbIxe3E/UFy03rmgfD+ueeM76JBrXy/8Em2gSOq4Pb4NgU4u4Txs1PWSVA8wKmZoZOqvu+ZzlOzXJ1hPITdyXrJAfXUpNGLkg0FP7dRz77P5vU78tOR/q9rC/iekI0q67xcDdeDXSIld7ixqpwqTvCTxyfCM7oZ0HRe5DR5jgjijsILtIh6vlMYlO1H6R2fb3NqeP7LXcQtyJOQhW0UzXOqrTToqk8wCLKtob0nnb8cvChy3RLS42Lg2uOdX6AKZLkAWxL7Yi6l1crhNfVNrV+QuNXi9ciJo6Luse/2BerNEfMYbTowiKkRIkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Somehow I messed up the subject, so resending]

Cc Hugh, yangge, David

On Mon, Oct 06, 2025 at 01:25:26PM +0000, Dmitry Ilvokhin wrote:
> __mlock_folio() does not move folio to unevicable LRU, when
> folio_activate() removes folio from LRU.
> 
> To prevent this case also check for folio_test_mlocked() in
> folio_mark_accessed(). If folio is not yet marked as unevictable, but
> already marked as mlocked, then skip folio_activate() call to allow
> __mlock_folio() to make all necessary updates. It should be safe to skip
> folio_activate() here, because mlocked folio should end up in
> unevictable LRU eventually anyway.
> 
> To observe the problem mmap() and mlock() big file and check Unevictable
> and Mlocked values from /proc/meminfo. On freshly booted system without
> any other mlocked memory we expect them to match or be quite close.
> 
> See below for more detailed reproduction steps. Source code of stat.c is
> available at [1].
> 
>   $ head -c 8G < /dev/urandom > /tmp/random.bin
> 
>   $ cc -pedantic -Wall -std=c99 stat.c -O3 -o /tmp/stat
>   $ /tmp/stat
>   Unevictable:     8389668 kB
>   Mlocked:         8389700 kB
> 
>   Need to run binary twice. Problem does not reproduce on the first run,
>   but always reproduces on the second run.
> 
>   $ /tmp/stat
>   Unevictable:     5374676 kB
>   Mlocked:         8389332 kB
> 
> [1]: https://gist.github.com/ilvokhin/e50c3d2ff5d9f70dcbb378c6695386dd
> 
> Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Usama Arif <usamaarif642@gmail.com>
> ---
> Changes in v2:
>   - Rephrase commit message: frame it in terms of unevicable LRU, not stat
>     accounting.
> 
>  mm/swap.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 2260dcd2775e..f682f070160b 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -469,6 +469,16 @@ void folio_mark_accessed(struct folio *folio)
>  		 * this list is never rotated or maintained, so marking an
>  		 * unevictable page accessed has no effect.
>  		 */
> +	} else if (folio_test_mlocked(folio)) {
> +		/*
> +		 * Pages that are mlocked, but not yet on unevictable LRU.
> +		 * They might be still in mlock_fbatch waiting to be processed
> +		 * and activating it here might interfere with
> +		 * mlock_folio_batch(). __mlock_folio() will fail
> +		 * folio_test_clear_lru() check and give up. It happens because
> +		 * __folio_batch_add_and_move() clears LRU flag, when adding
> +		 * folio to activate batch.
> +		 */

This makes sense as activating an mlocked folio should be a noop but I
am wondering why we are seeing this now. By this, I mean mlock()ed
memory being delayed to get to unevictable LRU. Also I remember Hugh
recently [1] removed the difference betwen mlock percpu cache and other
percpu caches of clearing LRU bit on entry. Does you repro work even
with Hugh's changes or without it?

[1] https://lore.kernel.org/all/05905d7b-ed14-68b1-79d8-bdec30367eba@google.com/

