Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4951C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D3D6B0099; Thu, 27 Aug 2026 13:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4EA46B009B; Thu, 27 Aug 2026 13:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D5B6B009D; Thu, 27 Aug 2026 13:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86C0A6B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:17:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13EE980112
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:17:03 +0000 (UTC)
X-FDA: 85147704726.07.00B3E10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 245364000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:17:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIAzlg3E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787851021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FMyam65/eD/ZbqglAxkrA726lGv09BnDgz9N86rBL4=;
	b=KxU+AUZkYWOJvhwVRvdfB0xdCkoNrWCz006wtI9hRS0jknBNwsyWKvRoy8jobClGf621NG
	NKODzkVmDxVN2zzUvGPF9xMkTEREST9VXdnQ4/nhoJgewYgOZWM8JKoqKwodkW8x7Oqvwj
	Tz1QRHSM72tac/GjmUueq/XxKq9+ojU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIAzlg3E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787851021;
	b=3vTum6EoRhzxY5WabtXTKPJwOCnCpb2PvsaN4RbRnx91daGxRhHHrcnMleKHjp0v0XVG3/
	/eUa89m2Do8jUBXlzExbGlg60k3ozi7jmpJbcaAFCVrtloRAG/lV82Q3GLHB4KeHMeRFJE
	Bbi8s8Ecw00cilrQJA4VMw9XB2nMN7Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3489443AE8;
	Thu, 27 Aug 2026 17:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DD21F00A3D;
	Thu, 27 Aug 2026 17:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787851020;
	bh=9FMyam65/eD/ZbqglAxkrA726lGv09BnDgz9N86rBL4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HIAzlg3ECKZVs6xzOsrw5gyORuG5PWOTZHEB/bfgLKhzYVMoKRXCKO/pDpo8BAjZ3
	 Jp/0FlG3B69eOYDMVYrFZhj0Xvnagdl4uAFY0sSQRP/HoPgTa6q7anNJ3838q5pfvr
	 jTopbnKKC5OJAtegtZwE+IB3ZvpKWgFP3y/q8fRl2IJXMPRhIGjmwwfZ4Fo4rxdbS+
	 vLhKFCtF5jTT7DEZLlviC3hnT42AxRe8vaExvYi8G94FZKTdUI2VLBNrN615wfUw76
	 o9hNxiWzIBfNXXWFSCIgEzxAWh74QdhyAivKRm6HrVgQg0rSlLTbjuQmBqajzzVrel
	 B41emjGw5sOzg==
Message-ID: <f1e51e11-3a0a-41e8-ad5f-817a4a26bc73@kernel.org>
Date: Thu, 27 Aug 2026 19:16:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/25] mm/fbatch: drain lru_add_drain() and _all()
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, JP Kobryn <jp.kobryn@linux.dev>,
 Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>,
 Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>,
 Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ww3gghaqnqph3wiyus5ewmwf97dinnc4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 245364000A
X-Rspam-User: 
X-HE-Tag: 1787851021-848054
X-HE-Meta: U2FsdGVkX18EafH6sIRnItVMqjkAokfMy2aR9wRQDI/leEy3N8jVs08XmQBDuJRy1DIkj8M5ec5m/WPwQsXhsQmqLcZjs5xT5z7m/8pZ4D+PHo0BE9tJteryZCYWjK0WSEO3kF9n9gtOfZCqnFKBVObpkXQRCqKKH4FcfHy2V8Nq0n6CwQack0Ln8vgqI+q95tJLxpXFXUVv98YzAkeWmJtcsvTGKjlylay80ABJxFPMQmQC5FuHP8tgh9fSgv5lPbFcSV//E/Hvcv2IIWIyBmZRkoFs+kmi7jBI+4WETa4Jd/tKcxObWn53qVWP1kgeBHyo1fbxZ4ShBR2SuScrhKZpoFjgZCNfgIEePrHWHjJeZCbVv/nWsC82TuuKahxt1qTSsCsIQZH/vjSzAuNdGGS+ekdKylvqcUAF2/q005hMFM/RKXvcrToIC8b8yRBCX5YAdgamIwa6Cle0hZctKW0IuX5SEvubLojRmjgldW3BhL05ster0Ijn5+fpjesyjUaDt/CzV1FimXFymyhtEEjcxqRcdOB24Y1si1Rw7TW0TESK36TTL5T+ksAndEbcOFGZHsHM3YR7bzxGKFvyG/XoDiu+eekegCkzBgvWTqpCuJr1KGaRhZVGbc7BsYQv9GvL//t3Dj6xYeKtd04Vvlp0RfpDKMs5a82Wu01iCHgaO+qonr4FyZdlQIQm2J3WQ+4Y/UvOidSBsjeT9+7VE6pTSfHslViGpeS8Os9/hNIpOAtlE/bTG+q5HE5wCNJPLvAYFCpp3bE4Jb4enVvqANOi7Fera7opkK9blF0Viap8pBsYWnpACGi2WjoE/f6oH1pD3SkAjAt3qSdB0dx5E/WGMDuwpXVxV9Kp6zK58QH7YvkBCwNZ4xNYbIOvQhtDcl1ppU/yYxwlqbzhqEarlo2E+pf8WOj8BfTC4C6wwhxszYpM44cMocwq29zHyoekrQWkDMBqYx07yFabqY4
 rA6SJy7J
 YSM3sCoL1hHo9pzmiGt3n02V6Nn5HTtZX+oSTDw6rtpAxcFlQcPjHMktuGxIE3wH0kRA4SMC0EhYpLm+uKIRfhrdB94aKbD3OxWYKiqGTbCpbNuR2cDgTYD8G/LVk6bjlm6DUPlFe0fEy+/uL3cLNf8olGQ1wzVa7fvsaq3zMybglRssjvA9Q4clqJ8i/HtTnpnCjXpiU7DtRK7HkupYjwaEzPPwZzK92URjWgQ26edc10E4JeB/xJOfjDk52FbHCdeLiibGLJkFZdlZJ+ReUwnnUzaK8mIHkIzrcKFPw0xWRlrkvfPxkoLG5vyFJiFeYvmnKV5YWEnikuo28TYlMzekiAhXotNgnthej5b6ASaANgkz4lV/7Uf87k1+sMxAo/S1C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 15:49, Hugh Dickins wrote:
> This series was prompted by lru_add_drain_all() appearing in watchdog
> backtraces: not to blame, but blocked on an unresponsive CPU to run
> its workqueue. lru_add_drain_all() is a heavyweight operation, which
> we often hope to avoid by a much lighter lru_add_drain(); but even
> those local drains can aggravate the lruvec lock contention which
> per-cpu fbatches are intended to ease.
> 
> Now let the folios on the lru_add and other per-cpu fbatches remain
> there, isolatable, with PG_lru set and refcount unraised, just like
> when on an actual LRU. Then many calls to lru_add_drain() and _all()
> can be removed.
> 
> It's something I've wanted to do for years, tried several times, but
> only hit on a good way to do it a few weeks ago: now it's uncomfortable
> to watch others wrestling with the drainage, while I'm sitting on this.
> 
> The key idea came from the "if (!folio_test_clear_lru(folio)) continue;".
> If we don't mind missing to take an action on rare occasions, then maybe
> we won't mind taking an action on the wrong folio on rare occasions, so
> long as it is a folio consenting to PG_lru rules.
> 
> No new locking, but relies on folio_try_get() and  folio_test_clear_lru()
> even on the lru_add fbatch; with use of bits not set in aligned pointers,
> and some try_cmpxchg()ing.  Speculative references to folios are already
> accepted: this adds another source of them.

Sounds very interesting. Thanks for looking into that, LRU caches are a big pain.

> 
> Performance? You (and the bots) tell me. I'm considering this as a
> cleanup, to make life easier for developers. I expect that some loads
> will show improvement, but also expect some disappointments (perhaps
> I go too far against lru_cache_disable()? or not far enough).
> 
> The timing is not so good: middle of a merge window is not a great
> time to present new work; but I hope to be taking three weeks off in
> two weeks time, so best to get this out in the open early, while I can
> respond.

I'll be out myself next week. And I'm sure my inbox will be even more of a mess
than it is right now when I return.

> If it's welcome in principle for 7.4, but too many changes
> are demanded, maybe someone else can step up to shepherd it through.
I'm certainly interested, my workload is the limiting factor ;)

-- 
Cheers,

David

