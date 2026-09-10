Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB47C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 21:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39A7A6B008A; Thu, 10 Sep 2026 17:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370976B008C; Thu, 10 Sep 2026 17:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286396B0092; Thu, 10 Sep 2026 17:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D134A6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:05:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8342405FE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:05:43 +0000 (UTC)
X-FDA: 85199084166.07.26AD5E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DAEE480003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:05:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eMVAdsjn;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789074342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLToX4EccLVtnhGx2Vc8M3u3T1qH7yOvY6cF4At7RK8=;
	b=64J4/paqntO+CKG2t5TqkVm4Gq1ZXjUAs3gZyu7puT0URxTi4k34XaGhcqRqgJG665im/i
	uvonEMilLffcYqQeUpwtoyRYqnljfJMxMd8MUI6bS8FGG4h5eH/tGj4jRnUMyfXc+ip072
	a6h+YUk9GXAQHRCFJKRIglCiJ021p/c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789074342;
	b=PfzpLWFf+M8hlbLocKiZcFqlrHochTQ26mABAqXOrecnyXD4Ci5bURLGygeDOVGHHWafeK
	u1YSPv3+wKxi5HMzjgRDSuVmilZam96EHsPCz93kaie00DdC7IOXv1KbfahXrQm2UWwtIl
	jBpZtgSWRf3VjDqUdrz1kKkoGztoYDU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eMVAdsjn;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5816F601F0;
	Thu, 10 Sep 2026 21:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7871F000FF;
	Thu, 10 Sep 2026 21:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789074340;
	bh=oLToX4EccLVtnhGx2Vc8M3u3T1qH7yOvY6cF4At7RK8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eMVAdsjnlliyWhH3OpkdXujTtNiigDS8c7DRnRcnAIebH2lnzAUn7CGlqjl3uXz0y
	 s2ALMDFWBA/vymMAewgJcnnCue0nseOnWxIoiAGhV8fE786DdvJmyBvb+zHWePs8XR
	 lF/fYrIuN9UJhL60bT5x2Fq9bJDI+mVu/yT4u1aXPqPqPf5DzIjhHhHx9SZoh9LVLO
	 S79uttERoeDeu/vjm/SUOuF4gL0pYXMFFDStZZWSzMhfzYBwpaUD2hX0SAa/cZ2G43
	 X2y+psFM3rUo/eSavsDm38Ea70SOZJE5rt1/C6Z/69h1i0oG2cTvy1Dclr70hq/j/E
	 qu/datkRNcZ7w==
Message-ID: <ce1e07aa-5600-46c1-b35a-d7df09a84521@kernel.org>
Date: Thu, 10 Sep 2026 23:05:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/26] mm/fbatch: restore mlock+munlock batching,
 without extra ref
Content-Language: en-US
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>,
 JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Yang Shi <yang@os.amperecomputing.com>,
 Yu Zhao <yuzhao@google.com>, Zach O'Keefe <zokeefe@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
 <69ba633c-8fd5-1f4b-2e1e-b9b15b8946be@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <69ba633c-8fd5-1f4b-2e1e-b9b15b8946be@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jwx5m8wczqupdq9sr4c3x8xkyesqwer9
X-Rspamd-Queue-Id: DAEE480003
X-HE-Tag: 1789074341-801134
X-HE-Meta: U2FsdGVkX1/eousHzc6avV8NVNt+c7T8E0KIfwG1Hsmm3bFQLbYYvwK3c1WTlBhhkjpSKCQwhk4TttpaUiJQKyK53lTTy4dkIBckdz4wfFGsIZggPYjYtUqvw2kcuUe0oKoRe/k6vldO/nE2f5IxDGEFChdHfVmFxi3ma/xvi04Brch+WFdNxlSvu+v7ys/AwAfAgOXjypTUAvHgvZZ3m+fmLyaV1VJUAIQ5vdQiQl4Z2/vMtTzuFbVtOl7rXXrttieXGO/8cxXAB6SsrUuYAmHd5Xum4uwqN4tBkFiCeYnlzE1XLYCjPalJkllwyBZTiYKyQT0TPt9N4PjjiN6dS92H1QjTEPN/G5emj0Lpln7a2uKSG9H/5qHiPZvoQ2axjSva3ItRZaR5B3M/+cTuI9pqybODVFyiNeB1LIxIhXsLpyZMpC0NIXx8KQoKW73tjlp3oS2QIcHL94NQEAcp0ovjthrH65CDrtotSxL7k9+EOB5JwrFDYO+OaVVnCGJrsaYZY2cnTNP+I9QP8Rvq3wgEGAy7RdD/Td/D1MSGRhcciIEsFls4p/+0aIDclPp2KX5TY6ziEkL/ni+5+PpvJlN2lquiSJSGGk1I9R26xKN2vZ58pLDW1r4aps84D5atLdO6YwXnVvSJ+Xi+86y9K0ObwMeKGCcWAN0uUj+UpLRLBKGi6ikNaLS1P1HU9LLTYNCN6SrSffiQVBCdz70Fx++icMqPwnp6Ty42aIqJMHPRU2Azr98HzLOWkZxruzZUuuodyoyI++IE9QDTdk/yg8sMWawvLfprPEQU3Ppmi3lWtH4himKiiTRV6QN4qkjmIPX8VJq44A/g5J5mE1b61Zct1bKV8Q2/erLorUDsDqAeg8r0peIKreaJOFmUDhKz8XeikS37c4X/pDzu9AQvEpMz20NQw9VG3OvwWn/Zrhx26w67JfEuDf+hcUNLiRa3iNeYuq+3FX8EOozO9qb
 vqWa2iXg
 shIiroh4F020R5Bauj93DFDZ/NskuQkSVZeGXQTg6aajBH/j8SFUR7pf7NMccWaLZv9KJRInv7kulu6sPl/JVl0Wdteww4ny5J+za52QByTE5FNw1UnL1+2lGbtAjVPS4lmK2EqKSzjG/4wHhdnRTgMAShI0O9aOC69oHdoyGt3y/rbFFL7KLBUlGUsAYVEPUqDi+XIa99WbdPGeW3YBPJ12zPfCzIwEMn3FP5nZPZvHtiub+2/jkDj6d8160ENbyhosLVn+RMW4nlvSa3BElrAFZgpWV61q26kLwGclGqWrgRMn+YYznAqz/gz2t0+eMme/OluQ1cKZlPijkJLAfQ7BM1EErCgXm/yBaXpmH+039CI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 11:59, Hugh Dickins wrote:
> Update mlock_folio(), munlock_folio() and their fbatch callouts and
> helpers, to do folio_try_get()s at batch processing time, instead of
> holding a folio reference all the while in mlock_fbatch: as in folio.c.
> 
> But more interesting is the use of mod_mlock_count(), using try_cmpxchg()
> to update folio->mlock_count safely when possible (now when on lru_add
> fbatch as well as when unevictable). While __mlock_folio() is as hard to
> think about as before, __munlock_folio() simpler because munlock_folio()
> can adjust mlock_count itself without clear_lru() or lruvec lock, and so
> do the folio_test_clear_mlocked() immediately for itself (without which
> unevictable_pgs_cleared was likely to appear high, when it should be 0
> or low to indicate good mlock health).
> 
> __munlock_folio() is safe for use even when the unreferenced folio has
> been freed and reused. It appears that __mlock_folio() could affect a
> folio which has been freed and reused, but only if it is reused as an
> mlocked folio, in which case its mlock_count is spuriously incremented
> (but usually a spurious munlock decrement will follow).  How grave is
> this? If unevictable_pgs_cleared remains low, not so bad.
> 
> I've gone back and forth on whether to move mlock_fbatch and these
> functions into mm/folio.c: for now they stay here in mm/mlock.c.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
>  mm/mlock.c | 147 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 86 insertions(+), 61 deletions(-)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 2c690f18031e..1050010bbe0b 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -58,6 +58,20 @@ EXPORT_SYMBOL(can_do_mlock);
>   * indicate the unevictable state.
>   */
>  
> +static long mod_mlock_count(struct folio *folio, long incdec)
> +{
> +	long mlock_count = READ_ONCE(folio->mlock_count);
> +
> +	while (mlock_count & MLOCK_COUNT_0) {
> +		if (mlock_count + incdec < MLOCK_COUNT_0)
> +			return MLOCK_COUNT_0;
> +		if (try_cmpxchg(&folio->mlock_count, &mlock_count,
> +				mlock_count + incdec))
> +			return mlock_count + incdec;
> +	}

This never rereads folio->mlock_count to mlock_count inside the loop, so it
can spin forever?

(too late here for me to understand the rest today)

> +	return 0;
> +}
> +

