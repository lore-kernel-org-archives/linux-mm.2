Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C91C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 03:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406326B008C; Thu,  9 Jul 2026 23:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7906B0093; Thu,  9 Jul 2026 23:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CDD06B0095; Thu,  9 Jul 2026 23:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6816B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:22:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 86E631A033E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:22:51 +0000 (UTC)
X-FDA: 84971420142.21.C6FCC40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B6E0E1C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:22:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WN5SsAby;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783653769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFQO9/52qB1fORdUBg+bh7H1Rn2Vz3vYSgSrxS39etU=;
	b=3GFajBlRrbSI/bARexcfv3JVCl1f7fly4BD2w9GH6AfJwyFYSjMp+oetDswbSEhnhDdfiz
	gG1Ndea7hEFtGOKGW8Zv5rFgkIRC/3A9aRgbNgIiWhjeD/e9Yam0+uXiE54MsrHLrkM+gb
	xgKRbup6TabAsG9+/59iGN+YnSm/yww=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WN5SsAby;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783653769;
	b=jmrqUQFw+MbShV9aAS5RPqhx+MyCjUUPO55vD7WTMW0T2s+O6x4Xek48/Pn7eeu8tGanWd
	QV3olLalRzLEwGHwqweaoYbIqE5ILjskTqeQhGbyOPtPyeLuQoDWbe8lj10G5ox1olPszx
	be8QxqVh1Y11e4YcxU+nFeDt+aUMoiA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6EED439CE;
	Fri, 10 Jul 2026 03:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1915B1F000E9;
	Fri, 10 Jul 2026 03:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783653768;
	bh=ZFQO9/52qB1fORdUBg+bh7H1Rn2Vz3vYSgSrxS39etU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WN5SsAbyLtwDIDnw94+8JMcpio5fmYtyV1rsC+LIw3GGmEJx9oUyXOeQFts5+soJF
	 JkSbPNDvFV05oYsBb9hX3kyDqUX4GzaMjz2bs1eOWb38wRxzaPiqjM6yuscXdEdi/c
	 7rpKGXGqprSDtlQ2vPE1Fx5XmHMn6qwEOdTy4ErI=
Date: Thu, 9 Jul 2026 20:22:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Altan Hacigumus <ahacigu.linux@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jiayuan Chen
 <jiayuan.chen@shopee.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: clear hopeless kswapd when global direct
 reclaim makes progress
Message-Id: <20260709202247.8cf6d7ab840f3a45c7eac409@linux-foundation.org>
In-Reply-To: <20260710024429.70923-1-ahacigu.linux@gmail.com>
References: <20260710024429.70923-1-ahacigu.linux@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ga4ewq4c5qod48wkzg7eoktf5ty556rs
X-Rspamd-Queue-Id: B6E0E1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783653769-588765
X-HE-Meta: U2FsdGVkX18dd2QV3xDC/tdAp8apj1oHcAuF/7m2Zl0lfnHiP6eGvSpEZbp1heVAfAnm/25bKvJ8c08BAky0H7b4gAB0DFNutcnJ6vXm87xTGnAPq3Jkd7Bu9/A10IG67M5fAgTRhpU1lFXK2hjcaOZWlLe21LUHbNiQpiIk6G/5FsS3OPsbA7pMu3mj8saEo+w/6wtxu0qG4i6aSI9XUnoKhzyarUaQIPSY4LGrpsHCUerTVSSt4zruPOwj23WxcmOpqQF+7Bm5x3oUppYmMJX86m9OaUWgWzwa5hgks1qMofJzhOwdE9qsr05OvJv7EC/B2ZnBN4mcWeo0mhqeXGgloq9tA4UgonpVofk6zp4AiyFgiupHq5L2zfmBkFC+PS9baYkyC6aGKypvcIgFCGZX9c73WWcjc4XJpJ2JZkc4pjFLICEbackKJoqRtH8VI4OhNgbB+CW1vPAyTxXxvjELd+arnsKulg4zdArVjqdmpvsKVmXEMT80X5nIdSqk3gqjl8drwj71w9sOP/rX7M4asGX8IYPp2W+MuCkY/USv5Dw1NQir/2E+1t5i+HTtVZBN5PVyanlM9aHExosMSCWy5klrilOeBLozKDnf+gdIpqIeYKTSly2z5iiUYziw8mqCc6hfpZW1AdMuNeokY28MHy322eyeJAXcD7rbLpzey5d1zjXsbFxvcFNtaJ3cQD+vwJEysMgBKUh0ZxbrtLkBMO/KaB8t7Q4Fuj9TPW5sXqlYR26KqOfizlZP+nVwl2IK8/JP49VpYfyLQQmHYMGjpQlOGjgVW/6HK7ncjdNIBmnL6JqgAb5C8VW8fy7FPwzeZGxnZl3Wwnt+mJhyXkT2F//PHrAWmQYUTHmMyIUh8apM5K+t19DXHDWRs3RyYJC/6jVMp3A934yHI1EYdcogoinWtOpYijWY9b5SMBRVlMvaGWW/lMUmx6qn3SE8v8xv8jxP1LEorcmiquZ
 Hv6ut3Iy
 811paz0b8lm7IL4E++PF0nDRjcARZuQA9ctomWrDbYZGJ3LRKmp0bIeuU+tl865g9WG4XHI4pzG0ZWz65dkqGkkqliqcqmxM1gNQmzgi9EWsMh63+tj4sClTJC0XUTA37uLAMuHICZHp8LCtIOy/xWFFWjhCdY922HE2RqeMG7TcG0lwkOnBmlcxfLC6LUbn/1fr6/5zr6d8H4/t72S/529aBzvC0CV3zbuLeOeDX3O0dmaA5TRGankgdNy8mPT1PBLNKrgb6Z1OUAPhAEZ92yYjcdA1bGUR957bTarWCesVE/Q9YIrHItz68A9lt4A/eNv9/DPyOkfRMqFs4FkykjHPMdclJcd2CSR/d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 19:44:29 -0700 Altan Hacigumus <ahacigu.linux@gmail.com> wrote:

> Direct reclaim clears the hopeless kswapd state only once the node
> becomes balanced. This avoids cgroup memory.high reclaim repeatedly
> reviving a kswapd that cannot balance the node.
> 
> However, it also prevents global direct reclaim from reviving kswapd.
> Under sustained memory pressure, global direct reclaim may continue
> making progress without the node ever reaching the high watermark,
> leaving reclaim to allocating tasks.
> 
> Unlike memcg reclaim, global direct reclaim follows the same node-wide
> reclaim path as kswapd. Clear the hopeless state when global direct
> reclaim makes progress, while continuing to require a balanced node for
> memcg reclaim. kswapd_try_clear_hopeless() becomes static since struct
> scan_control is private to vmscan.c.
> 
> On a workload with most memory mlocked and the remainder under sustained
> churn, with swap enabled, comparing the same 60s window:
>                               base       patched
>   allocstall (all zones)    413441          6532
>   pgsteal_direct          15889552        255619
>   pgsteal_kswapd                 0      26079382
>   PSI memory full avg60     13.10%         9.37%
> 
> Direct reclaim was already reclaiming many pages in the baseline;
> this change lets kswapd resume doing that work asynchronously.

Does this change have any user-visible effect?  If so, please describe
in elaborate detail.

If not then that's OK - we make such changes all the time, but they're
less fun.


