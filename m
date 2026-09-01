Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F231C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451C76B00DA; Tue,  1 Sep 2026 00:38:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4299F6B00FD; Tue,  1 Sep 2026 00:38:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3661F6B00FF; Tue,  1 Sep 2026 00:38:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17D786B00DA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:38:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A9F64402F3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:38:17 +0000 (UTC)
X-FDA: 85163936634.18.28B28E5
Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 439A340002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:38:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kLD7F0a0;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4LyNxM1ioxMtWyuP3NFb5HBrb6ZGSUzcqWtnnBW0OA=;
	b=ycrOvWLYQg1fk98Tr15VJNFx+MBZ/inIK47/c+Rrb5oBAI7icoGGLbXD3Jj9QspBQJtT4e
	c/Ivben0by8WpiYMFpHSOWzF3wv4PUI7q/uLbgPOsuXqoTvp5xOByzSTd3JLYcHW7d4Wg6
	IeI0wOjqaCx6zIAGmND50XhjMZuUJhY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kLD7F0a0;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237494;
	b=fHF1eLD8FOA+WEK8yvbd8Ano0eFxmvnisqWBcn1VBW6DzUy5UcXm4/RneEYcBuTAlGZ8qy
	7uVTcstpcpNUHKuTDZhHBES9dwfIxrMp/Ar13JNUTNiNIOrkO80+WFG5RKY/9stjblb2fI
	Zap41L04vAgqpTgaCcaQfaRBnoR9u7E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TJG98YKiXILgUM5yXGikDrQSHVcylHnt0O0nBzmY7eQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788237491; v=1; x=1788842291;
 b=kLD7F0a0QGTb7I+CbdUUzo4q9cGsV7xb3XktvjRyCsc71MdWym+MmWs95MAAqj9JidlMxWoZ
 DqR8KvBhbBkYDwX8ufxhK9LMp+29++KE8ZtmVZpF2z/EVAVSQ2b++aEWZDvJF3QApthaQWdD6zL
 jIbArI6/TSxEf896kNoCLU+o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8dd80eb52778aac0;
	Tue, 01 Sep 2026 04:38:11 +0000
X-Mizu-Trace-ID: 8dd80eb52778aac0
X-Migadu-Flow: FLOW_OUT
Date: Mon, 31 Aug 2026 21:38:09 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v4 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
Message-ID: <apZVe8UHZ1CNo4r1@linux.dev>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-1-2d15dde0d7ee@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831-mglru-flags-cleanup-v4-1-2d15dde0d7ee@tencent.com>
X-Stat-Signature: tx3jin7bex7u16ijge3k4j4d5zczcwg9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 439A340002
X-Rspam-User: 
X-HE-Tag: 1788237494-156645
X-HE-Meta: U2FsdGVkX1/kvKcG44wxlfoHDB+dgdyynk/hI6cGBU3VrEYG8ZLHJrx33+jBJg+5Jrm8aKo1HYWdf6Xaky5hjFxorsu/SVae0Op+vKtLWCjvJM1ui9GIm317f707EYDoeG4JcnRFcxQukd9B1cM9fblcVjiXQNufZ3OZEg000+UOmQFPIokBrYUhcKcRJZABIAQIM6iZ0zs6xAt5t+qvom22nPu0PvcaxxsRZQEn2CYJYlUWPsen4hFw0mp6yMCeQcgJAGBrSQG8SBACF4v6SbxZ+azOyp78BUKfmBzsml/qibA3+znQdiW7tSMZfYwYHlZ2NfiDJ+GBNol3BLliNjKVDfJine4MEGkYKwKgSX8VFWG0WGhW0rHAoNYnEGLtmCl0vaBd8fuIaQiAfVZTTKstZtTGmQ77+8h4jFiSbIDNawsTwr25b41JcuZutq21xHQPjZKp39qe8bBtkMsa359y3hwUX3v3yUqmP90p2+sOE83ZgkLlwp2t4VAVcJHx7/b8Z+8MTmSWjbQYDsXEcQG0ZpoXPpa3RVSqG5Ejq4QYBW6TmJRi/jY7MNIr7WXfemp0G1DyazMIlNqPmqv/2SLmJ2kjL1j7BGRUWcCBu5fSruDbQaDiNIgPaRY+3wDbNWOmGL+0t0jlvTygmEUxtKfeDtu6rkyUoTI/0gG0AurDUCRexe0ZCm1No0W279DwXxS6ORCb5pwgbTsoETwhqsN6wy3eXYTY5Sc+fFiGzYN+9S0xO2BFgYunSNob6pCzZ3mvVJ5vWxCfx6Q4yX+AcTnd7c/df4/PqBjh9xz3TQBPyKF5WS8+4fP8PL0zvWNyZD9vh6WtXbzM9sRiKeBNUe/4G2FzFyGZI6Ie6kRXLasyme1+dXEf+zOMWXCioPIe+T3kFvBawc786k0Jai6mtrdst6Tw7+Nx4GkU5Vx9HbXzCjBABII0A4rV/DG27u5CPjhNv+ln5TWRigDb3kR
 5CsKW85X
 t9fK2h8sbYK9epTiZTrtMHM6LrhdOqJuVcItfpYSgULxVjlxzwEMbEkd+cErriQkZsX6LRoPcs7GtAiy1M+dgIfBn9cXrSS1jMSvmGYJhICk0sVvMtlrgNb/1dK4g4xua/jkNl+NpXY2nGU2csrsCHlx0Lt7Q4wH6lpaPGMLsgTrAnBidqz8ZJzMTf6YyKkjGEP1Er3XcRAbArA0JT3RGe/o4urgFOm+LvnBPsruooZA87At/0TFznD4Sy0kF5Tnvu8iK63aZZX1yqjl9w0j1tVitC9oM0Px2VnQB7ITaY066bukc2yr09+SVq4KrSckVMs51jxFZOs5RtVDwR8WjulVgRhpMBhMZZbbYlZfd9hSvDmdAIpYr2YefmamEK4koMzrVTgqf3DjeR/beWAjAoYv7cQ+VUANT366G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 02:43:31AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> introduced a sanity check to catch memcg counter underflow, which was
> more of a workaround for another bug: lru_zone_size is unsigned, so
> underflow wraps it around and returns an enormously large number, then
> the memcg shrinker loops almost forever as the calculated number of
> folios to shrink is huge. That commit also checked if a zero value
> matches the empty LRU list, so we have to hold the LRU lock, and
> handle the positive and negative deltas separately.
> 
> But later commit b4536f0c829c ("mm, memcg: fix the active list aging
> for lowmem requests when memcg is enabled") already removed the LRU
> emptiness check, so handling the deltas separately is no longer
> needed. And if we just turn it into an atomic long, underflow isn't a
> big issue either,

Why atomic long and not just long?

> and can be checked at the reader side, which is
> called much less frequently than the updater.
> 
> So let's turn the counter into an atomic long and check at the reader
> side instead, which has a smaller overhead. The underflow correction
> is removed: a massive leak of the LRU size counter would indicate
> that something else has gone very wrong, and one should fix that
> leaking site instead. Besides, the updater-side sanity check is
> unlikely to catch the leaking site anyway: if a folio was removed
> without updating the counter while other folios remain on the LRU,
> the WARN only triggers much later, from a likely innocent callsite.

Do you have any data to support your claim that updater-side sanity check is not
that useful? Also can you explain the motivation to move the check from the
update side to reader side?


