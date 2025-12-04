Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56EC1D2CDE0
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 22:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26216B00AB; Thu,  4 Dec 2025 17:21:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD66A6B00AE; Thu,  4 Dec 2025 17:21:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CAB96B00AB; Thu,  4 Dec 2025 17:21:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF136B00AB
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:21:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21C91B74F1
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:21:16 +0000 (UTC)
X-FDA: 84183210552.30.54035B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6755440006
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:21:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=a1dLCnLF;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764886874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95nZyTX0fEu9Dl1Mbw8dMRShkCl8bUTc5udqACUtJrM=;
	b=NH/OXdCS96c59tynEJG/aehW2l2WXuFKrAc8MkYCAjHyoKw8kmS5FBNpgT9LIEeAKta3Oo
	3coW0Mujs6c0r4JtSgqmPzNnRSdSoqaSwGJdeufEazV1YQ9gs879fSi+J66jFePcAVgM3V
	KxRso1UTZvHhCljbO0TVrtIRTQDZ07Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=a1dLCnLF;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764886874; a=rsa-sha256;
	cv=none;
	b=JiYgNj2PMCO8X4+vvV6SopT/Wwqn+Q2mKMOJkoCTnRIXZQABfyBcdfBPhJkruX/SU0s9zz
	4lrtM+ieKQHw+dNs795Soa3Ry/Ul07ejpy1HjNlc21P9o9xaVR7DDUWlG+uYVObrA7BtLl
	Z4RaspD3bK4wKy9JaJGN57ZGr5AdakA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B99342A88;
	Thu,  4 Dec 2025 22:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C36DC4CEFB;
	Thu,  4 Dec 2025 22:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764886873;
	bh=E9kU9K15m0c4TR8zQYJBzXXq5HteRA6ZiMCkK6LALds=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a1dLCnLFfBn3I5uPKXWweozUcblfouKKNowmzlOYs+V4nqM7KHTRxgTSf+QB0HP4E
	 XmRmT3/5wQMNV8rGRNjcGlgjT+NMPNZ4LA3OvkCenC6iX2RI4fX4U9xA9A07PdMP/S
	 V4EUeGrL8otU7t8USYGCKGhOhZ6MOrF0gFQK/5k8=
Date: Thu, 4 Dec 2025 14:21:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: urezki@gmail.com, dakr@kernel.org, vincenzo.frascino@arm.com,
 ryabinin.a.a@gmail.com, andreyknvl@gmail.com, kees@kernel.org,
 elver@google.com, glider@google.com, dvyukov@google.com,
 jiayuan.chen@linux.dev, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] kasan: vmalloc: Fixes for the percpu allocator
 and vrealloc
Message-Id: <20251204142112.fc11c55e46bd0017c41b49e1@linux-foundation.org>
In-Reply-To: <cover.1764874575.git.m.wieczorretman@pm.me>
References: <cover.1764874575.git.m.wieczorretman@pm.me>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6755440006
X-Rspamd-Server: rspam02
X-Stat-Signature: 5oboc8ttonsnq56d38347jp1poqfn81d
X-Rspam-User: 
X-HE-Tag: 1764886874-621298
X-HE-Meta: U2FsdGVkX1+wfue9ptRmraHnIrIpEctkvoGtELvh/XWgdBqTPR6aXARAti2n5KBX2LPRnJd3nDDQb16uOodfE3Eu4EXaseofaqCYNLYEHro+MBxpoBYvKXirHgHGgvl1GTwc/QKUVQrgxhHrWFAGx5+Pucqat+/1MGQQsxWhckOgI7Z0kbixhsNlyjriBKyJKpHYyIlHEsqkGbqQIsiT7yEsBJMgToZ4pnxP0iZgKStB92snMdTVJ1W67Rnuk0oRv3XYFfewK2Ze7p80rTxEU4HYRGWQeRuq7WgXqcpMgNvjqhDUpG13TMDzGiz9hN16YwvyVSRvrh9g8iJsSfxe8Tyv5hGLIskjDAp0qqaWLR96Ma0VvbAuDF4OxBiJRYoUxjum98NUFbukZl0XOlBz4wGRjmTHjnZCn9hN9act/FTSO/uaSrlrOb+sHG6rx6P+q/XCyXb+3gbHunYmoIn2aWaFJv7ErRrNhR3CDDrGp2MGd7s1PprtwHONLYjntrH5eDiBpwKWbhVeOiE45Vj6SsQ0wqfR+N8En6GJz2jRncuTUor5UBJY8jtOIT228dUaIi4+hG4FOWS61WidWfT5avlfVNOnh6TWfqPXtEOivV+B+ntcywK+j++JW1fsoRNNR8t48WjKx2t5qWfDJy9W4qp8AX14ICWlkBwrAqgKdJARM7Pg2KPPVL4f+CcAgkHT1Hl27raAtyFdHTOcz8WitIIS98c+CV6eNqbX+xQg1n4fpiemvkFIHYm5pCW8i6pPniLyUmi7t+iI8YKtCSfzi7dX9Qvztmj2xft2jypIFhuFRi1xETDqRa1bGF8zH5UkU2SN3EpmFgOEmMiw+lpVl45KGyGSuXreofzvoToYZpL/w5IgouN74cWX1GMzvMrn/3wNGVtgthrk9JaRmtqKz1ZeYkBHuOk0OR5j5KXjUgijp8PZx1T2vLNsye9eTO985DKn/NHQoA2h/gnJtK7
 H3QaDd85
 z3EnqLaGrq7fHYpu0YntcgaqxI0wobeLKNuX6K/Rwkkxz4bCcZJ4aOL5auTvNPSBsMRl0Gi0KgP/6rek7OMuRn4G24oYm5Xdg2rGUVZKo+pRpAf989D1PuFJfwlanmzanTYJRT57oIyFsJ2liUfsgvfo6DZ3TtFXf5ulF6/JJVSCfv8/L/iOw1/VeBSnRZXkb7U4lqNebC8HyCAZFMWcUyJTx+WEMwuSpcVFd8J49fUIT+ev3yFncSnV2XrDk9APogxUBSpkbaxkf94+HOhyGyg7JCkqkeQQBgWvd/w4ZgOi6jGjA7+bg1GUIWk8qZu5IhBQm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 04 Dec 2025 18:57:44 +0000 Maciej Wieczor-Retman <m.wieczorretman@pm.me> wrote:

> Patches fix two issues related to KASAN and vmalloc.
> 
> The first one, a KASAN tag mismatch, possibly resulting in a kernel
> panic, can be observed on systems with a tag-based KASAN enabled and
> with multiple NUMA nodes. Initially it was only noticed on x86 [1] but
> later a similar issue was also reported on arm64 [2].
>
> ...
>

I added cc:stable to [1/3], unless its omission was intentional?

