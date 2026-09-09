Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCCEC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 21:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938776B0095; Wed,  9 Sep 2026 17:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F656B0096; Wed,  9 Sep 2026 17:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D75A6B0098; Wed,  9 Sep 2026 17:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56EC66B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:02:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC5A61C2096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:02:33 +0000 (UTC)
X-FDA: 85195447386.20.EC93BB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 15B65140015
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:02:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsYAfxu1;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788987752;
	b=vOH44bK93vX6U5uoF1vNVbpiL9yyZ0aQTaFneV3wVAAOezBsUKPOqnX+1nYxdZe918PZfT
	ukd78MplOi5i0/NSMyrlIcKsGhyH1N2BKV+Ug9IdIrUAYIcmg/qhUCaTOvdUv6YP3k6GyB
	hjHeX1M5/9av55T4XmM4rLg+tZSuc5U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsYAfxu1;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788987752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PbffVcQI+xFo5ygFA6oW/7Qdqg1wmtzoef67UMGLgVQ=;
	b=upXaua5yIJPyRyqCmpi4ZufvAfwuvCVeXqRyot8ZYslBQyswaQFnQJX6ReZ3YOma0LKmtN
	UlwVgpwD8X2tODDT2p3O//mH+o4fdx4tT7RKckDtwjAvdS1OZI3rD7g2FkyVWaSfmwsGe/
	4klkU5P7vE6ggRxZLzt5YaeNisgvL8E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C2F943B30;
	Wed,  9 Sep 2026 21:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789511F000FF;
	Wed,  9 Sep 2026 21:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788987750;
	bh=PbffVcQI+xFo5ygFA6oW/7Qdqg1wmtzoef67UMGLgVQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JsYAfxu1gchV4emYg7c9RhVMIwWcOiYtQtWTqkhBqovirS1d/uM8eJhtCgV5mkD/B
	 jtdUTfyMVT8JPIyYjU0PgQKT3kn1UEWfrK/t7D8v5T+wL4VVeP9LCUTjkQyo0iRuPW
	 tJGJmJxjFa5s9bTzqCZxWc67j+EruBLxBXg24TMB/cJB9eKUXiQjWU6z5UwU6i/8Up
	 ZsV/uTeK8KLQ7vftbOlBB1bVJLObXp4qt0MB1MWnwOqiShKhZslRW7RL/35/mXLhFF
	 /7kKUA8EMixpQNc8Xbzhlaby4o3v55KOFjm9VkNEoiiyoXbMQBe4he6nGJqqdzxj5M
	 bH0IH0Wbjd9hw==
Message-ID: <ac4fedf1-168f-4166-8059-353f2cbf04ae@kernel.org>
Date: Wed, 9 Sep 2026 23:02:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/26] mm/fbatch: fbatch_drain_lazyfree(onstack fbatch)
 before ptl unlock
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
 <17e1a6c3-525b-1cc3-0731-349f0850e3ea@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <17e1a6c3-525b-1cc3-0731-349f0850e3ea@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15B65140015
X-Stat-Signature: sd7yt1dmr5wnsiwsfy67s9kiss5z311j
X-Rspam-User: 
X-HE-Tag: 1788987751-695568
X-HE-Meta: U2FsdGVkX1/1WBBDlUh6Uem+/YaISzFa7OH8BR4vh2M9aqEGGGT7pf7T3tXVtCVGgXgPPaY5ClCDK8S9sTi+XXimhrxn5a6nv4bKge6WTn1hAwCGoPV0BvLr5rBNXXDctLIgM1SOX6CshiGQaD/uhH5CpgTmvqLy6z8GdkoxfWFG3JMnZe5ws3KMiPd4x+vVGnRBkxH5u1Q+/3uVVuZ9Mc8NfIaxLqA6h0/tfvRnPTSMWsyenYV9f3bZICSGrmOD+XOuUGpgtbn0ewT119QKsJcW/kHK0ix/vdCwD9AzfU33nsA4riWSaFNj/pANB3Lr+0KG4X4OBUe+y9KZYflBdpCK+JBgQdi5RCnP4p+p2p8WUJbCmI2Bkto/zIHPwGaog+Hl1BDaYRjTzMzW7ystNamcLMxRDeHhaq3cSEvb/44mZn3iK00NxA7ShRSlQtXAlzHgCMwnBwHXPdNY6OHG7ZUdFigaIjuIThGSwVh4icEIL+dDH03saGgfvtGvrUMyOZZmOtoUj1Cd5h/wHO9gmCdIMwCZGdczLxNpSd33XU+fp2mKIhjZm2Yf5vzGTNKI1rjd/emoR/nNFV4jNZmFTZPjcuqDzUOKI8Ae2Kx3vyfDTH3larJxfiKIPl0FmBlmN0nVkJ4XzjXygnSW1knbkESEhxDFoGbzJwYW+DHJTC6ru0S29tg2Nvj3QF8pXgoLzwAfXOj0Zi0uSJqpjAQLetOTyr45jjm8QYV74xzoIjD3Gkn3QcP0u0/fn+eXCTQW9nIzF9QfSyfi0nny7AuNBvHzSPpyD2x1mGX7Z3V7rQKg1baxhz4tPFScr1OidZcx9oJuO2WZZ3bPwf/itZkIRolHX5uqd/eTdd4TyJG+0m0WVPLnjfzaALACMIt+Rccrt9+MWCFMx5XI1X2p9mIFOkQQsXYj8h1MASvbfFIUkcJOP/Czdi3fV3aoVXMlSiffRx2Rn8jJUQ1xoxRVPv5
 PHqtdur4
 W0i4NHjDHURNwO5R48PS274DDnKrVu1CEWHn5wObVGt9adBKlvFiIGJ/gtgmaaUgX+aldCHQ6sqeP3cBwqF267SQCSls94WaZgZ8MUL1xev5lVAAFw/IjP4Uahki/5iMFhYpWmewyV5DPyGUabu1v5cA12Qn3dj4mfJF7qvJ/9vWRhMuLhNY8l9o0ExnbLw4xnmWJAjn/4H1521irWZ0ZnoXJTMF3Bb9hIX8W21kCJwgmkTVm3/tMSU53j+nPiR58nCr2HHjysUBOUsS+kEE8fIyQd5Fa2+ygfQAGMtaS8LBpMZbg+Dw3cwQk7Mhzq3qOJ0SvfcuSESXutFlcKZokzawgbM7hJ+UHq15wCphqa9shggeVntpRVWPph2/mZM5axOzIvP9ylV3zVpJWLb9zgRPQ0FxbEEllO293JyK9Ug54BMs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 11:53, Hugh Dickins wrote:
> Re-enable lazyfree batching for MADV_FREE. But it's not safe now to leave
> potentially stale (then reused) folios in a per-cpu fbatch for lazyfree.
> Instead, madvise_free_pte_range() keep an fbatch on its stack, and drain
> it each time before dropping pagetable lock, while the folios are secure.
> 
> Ignore folio_may_be_lru_cached() and lru_cache_disabled(): limitations
> irrelevant to this fbatch drained under spinlock (even if RT); though
> in practice madvise_free_huge_pmd() does have to drain every time.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

It seems correct to me, so:

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Might be that something regresses performance though. Guess we'll see.

Also seems to me that if this patch was preparatory, the batching wouldn't
have to be temporarily disabled. Doesn't matter ultimately though.


