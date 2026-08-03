Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A903C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 02:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D056B007B; Sun,  2 Aug 2026 22:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DF66B0088; Sun,  2 Aug 2026 22:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FCF76B008A; Sun,  2 Aug 2026 22:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 138096B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 22:40:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 073981605E8
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:39:58 +0000 (UTC)
X-FDA: 85058403276.19.8EE4386
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4C12D160003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:39:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="FVpy/8Oh";
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785724796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lZyI/Zcbivmd91K0VLJCzjKzknnvAi4iuaDCsAmqSG0=;
	b=akWfelV/g4+XDNuoL+xk1hPPCRz7r3/h1AOANAGTEl6z4fH5cSD3aXdKjpSX4yQJBkyJ6U
	t29gZ7qhzVPhWNhlW9l/gYUtSPbiq9g2jwEEa1LXgX5by1bhEeXgQPwe5dNBnHxND4f+Gs
	FWCQ4vpDUHjFaTvtA/7F7c1yyjTs4Lw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="FVpy/8Oh";
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785724796;
	b=b3EYUUxnmZBtQHl9mNEY1zJr6/h2qZ9NgwTvkLnB6PaS0G89s8pGdDfgrzPnzif6uka/Xs
	+3ZcCK0tt1oN4fYCzZ7ZOTjzoOBem3Kyr5/TwTDpfmqEpAkRNCfLHU7trOlQAop3I6ukdV
	cx0TvdC8r8iarHGtrq2Uv4eUTjCiCdM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785724792; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lZyI/Zcbivmd91K0VLJCzjKzknnvAi4iuaDCsAmqSG0=;
	b=FVpy/8OhwcE+NwLRhP0sX87l2ibgxB7917pYVNKznk2DWUiDtyZUWi/8LaFRsNWq40Tm4m23AEXZnwZmBEwGh2re+ZXFCGFzMXmqkkcjMLQZzC8FflB7fkfnbJVk/ANSzH/H+cP4dF5D4pMuF+9L2rMGuTLnHHzHdR00CBKVnCw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X8DpzJ9_1785724790;
Received: from 30.74.144.148(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8DpzJ9_1785724790 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 03 Aug 2026 10:39:50 +0800
Message-ID: <0a319957-0691-43b9-bbc8-0e85ef06d176@linux.alibaba.com>
Date: Mon, 3 Aug 2026 10:39:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory: use folio's memcg inside
 __folio_split()
To: Zi Yan <ziy@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
 <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C12D160003
X-Stat-Signature: 5p1ony384su85tsmmfxmpaed15d8xsxk
X-HE-Tag: 1785724794-377736
X-HE-Meta: U2FsdGVkX194vJ2LV6yzUzkcQkT1EFovncsLPKeBy2Hqxhxw04b00iPWKAY0+tzAytVdItbfRcigBdxOhEwbTwid+Npc+c6eUlrSDqX/j+788MD4YOyFaftJIMVE45t/PfPZJShHDAEPF6pGzV138LXqfQaWA7jn5rd01qjHOCxzv8mInbMCLBmYJlxwXtqPw4mcjIjPE0c/ekvH6XzbDbEbFNeZKPwSk7kJ6Os8f0AjOLxaibVgQWNYmtG3UdAexxC796IrRfREeNMocdiS3gYDF5zx94D/r/KKCs+ftrZJ/6ueMfQ3DEaHMtY+sN7HUZGhdGyhFk6vuEbUyqBMPAvSHQGAekDZJMBLPFlKlXCJ+pdH5/tJW+b66yTpakfFVnC6m9DDeUG8oZ2VVjXID6E1mS1DnQyqvqDrZYHQzMgcGg5YG5wSxitvkaEnYv8mEj9FNNLMQOsI8dI/yPfeZP/0w7mGt2PiPuj7NWWPE3CJW8Kxbw4QGsYCnm2WEnuH8SZVLgctEHiXUrruoAuxImdDtZZTlrUFmKrhQ+yldMIwnHBj+8zC8yf4+YIMvjAZzouGqvJy1W8A8yqKg5tsDBhoijKxSNE491kvSJRzUeAa1OvA2jzI6obtK20nBfIZ8AwWC89nm7m9WP4ZmEl36TD2MlLy9cjxHSkgXzyM/3HvSazBcLpOA8F8LgSD/ZvBgi+8uQfQGLzr2FUfs/pAfDDmaJXoP8nVN6NH5hcDzY7hge4xCcHKhic4GzBrqDciqvYVhZsejdOytp/FoBGm2oEIRCcMgU4kxE3RIztUB/dyc7LRj+44/OxzseRjY+qFjMfS+JVXpPNOYBMmXmCbZ5FSaVEoCnqeqNiemRKdn9FOGjfecEQvehqxPJwHXb3jgfiYX0g3DwstUADGohwyRyguq1aUpnflMzaOCZ/T/RaXvt3WZi2ttAIQ419B+UNpCIWFs4omqAkoYceus9b
 4qOVFHUx
 lajr5cKGky8dblcmY+EnjqKnxwMCpQTDdSNDtQSq1QuJjTq7/8YgOq/78ZVM5yd7osHSH/jBeewa6wrbcpPQ5ApkelEuB0L2PgyntVSq7+gpugjve3J/hxLwAfORdzeOsC0j/D/CoyeABtf5JM7dguRCvjiXvaLjunuTy/LBWyzYJiR7vUmh1MifVQLA5hWP/BmZoZTujAXwiM7iFc0Ww2+oZQUutuLRi/oxY2yFypVlA2SiAIeHLywHzxaxQpl2kN67qKQQQwzFYMmBZAk0JsL96EJi3fBmRI/qh4Ffq3fXTsItBatOnBqW39JeGNloizGPVauaGQFVZSCJjpOJI0zM7S2PjSKJXRSsip5ynrIGHBbN/IymP4AZNq2tJBT3MBdV0m1cREMPtb6fBYQX5fNzMkdeOWNkJKsd7fgiqchPolof44oy6vLvWKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/31/26 10:18 AM, Zi Yan wrote:
> During a pagecache folio split, an xarray node allocation can happen and
> needs to charge at folio's memcg instead of folio split invoker's memcg,
> because for example folio split can happen during reclaim and reclaim's
> active memcg might not be folio's memcg. Switch to folio's memcg at the
> beginning and switch back afterwards.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

