Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFDAF60A2606
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qZPqylz3
Received: by kanga.kvack.org (Postfix)
	id AC1A36B05CA; Tue, 10 Nov 2026 06:34:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89D06B05CB; Tue, 10 Nov 2026 06:34:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9873E6B05CC; Tue, 10 Nov 2026 06:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 714916B05CA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:34:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C795FC0294
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:34:37 +0000 (UTC)
X-FDA: 85419001794.09.02A5045
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4720100006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:34:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qZPqylz3;
	spf=pass (imf14.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794310476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2a1TDsS3iUxIM92pLHqfLDtktPZ6Hk3khSHvckjZDU=;
	b=cPWy7h6isaizbKtJLFwsmUZgJU9yjmn+0szBbaf+fnQvcSvZQ4HeoBPXsgEuHlpckmJR0D
	+g6MONA4A6IsAobmP9+wqQQ/z7SEqws7koAYCXsTeXQJiQpkGhyB5w3Vq5yHIoboncKaQT
	I+0emyzo0Gwz29W99kWbhvKEaMErR50=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794310476;
	b=uP5vkN55ShiXQDwXZ+EN/AfWpweEAS+BZTNmidVwJGqI/8F91V7nYMT3mezwgNjB1Zulzk
	2T98QMg1RH9+CnzOuN1aoeHne/E+880l6Yh0nDIdfLG0UlRl/HmPvu6cCBaCGhsAyBb7qn
	PpLr3+JS37/DjDJuQi5YbsRUbazU++0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qZPqylz3;
	spf=pass (imf14.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sx7YNgEU9+H0zh4XLdzTGH7bAYCesjUaRhN37pRVeCo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794310474; v=1; x=1794915274;
 b=qZPqylz30aZ3e2BfZqsTlDRz+1A5BGW9qBCxc3KAgoelfm0jerbLRA5Mf59vl44Y4zV6fsTz
 I3Grq8ySLHtOt8IhhKwwnmYkw0eLgOyUZSDb/nVE9HYSLcWzf1/h9RUK0RhrHwMkYAjeU8wm6zz
 lU+CKzCBZOJ7GsPG8EUt6gB0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8d782ae6a49889d8;
	Tue, 10 Nov 2026 11:34:34 +0000
X-Mizu-Trace-ID: 8d782ae6a49889d8
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 19:34:21 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Qiliang Yuan <odys.yuan@gmail.com>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Huan Yang <link@vivo.com>,
	Wang Xiao <xiao.wang@vivo.com>
Subject: Re: [PATCH v2 0/4] KSM: introduce only_merge_zero_pages
Message-ID: <avMBPaBPMpQ75odi@dgvxl46587.localhost.localdomain>
References: <20261110074312.219847-1-xu.xin@linux.dev>
 <avLsbZz0S7sRYIL9@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avLsbZz0S7sRYIL9@gremlin>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: jhndwde6f1w4hzs65ac4xrgt6kjt6stm
X-Rspamd-Queue-Id: C4720100006
X-Rspam-User: 
X-HE-Tag: 1794310475-475699
X-HE-Meta: U2FsdGVkX1/IjXJXLD1N7J8okRT1NfzhuhpzYVbC0qhfZD/jwxCn4skz/6wCrC+k1C1/eKESn2/uBlvzkV4hrX33kOddMEfZebAfnzLLnPhfnW0xoB6aeUvByCVZK4NJYFjY7FKjsye3cjWATcVy10qBze5RIsCDKN2//m6KVIyvPS+iilZNq7jW2kIFj2N/2nJ14glNS3pLLhEwUN4LBt/m1C332sa+MCaGOUxB+vpBpWwFN2Uivu5UMQKbY0Xxn58yHZhLAUge7XW2gXwRqVxmhEni00WcCuRBf3f82tvsZGa9y/LzlHlq69Y4sEMreRJ56q5WrTaFhO5gGEccjPnt/HFdiVqBIKuZJIaRFRxkL6DZ3rlTZhNIVVoV1kdlATKRFBwH0tg4vY/EQEWa+Fv66t7kopkkxZDwaFLqhbgUgMnglv7jWikEfbeYIx1CNzm8KkjxPs5zmPSqNUnIoUPnUFKu5nVBSvwOBaF5mO3H7qKInKZ9Th+8N0jmpoaK5ezR1hNVNbfo7Z1Co1O/zLGS+3wm9is4qwCqkJPcu4UB6+7pyg/hwkE+1ZKIFp+5AgoVHSFZoZDb2ncEwOXSIgAfbyy+rN01piuGVWZnjQmvtig4nCQdUPt+YJOOLqe4DEfA7uAJs5idX5vvvcXwuhmUgyqymw3yO2/3vykVKSjKW3IMokJz2pA7pU32hoR+jmnd4jZJSoW9nQKKX/ZSo4+J9IovnIuP+1LGxXTHzMkAvfjqh5QRnQWsKCBvEEym47jY/WugP/91btjJPICjLGOCDEY5EkA4c+vNwcBHZVX8MmIAi8uE95oEV1Eym6+DWwnr3XIpXI/meSgcw2n92/8wLrdfrJgt5KuRHv2/KIBs0MR/bIuQwVMSHBe1M6d9/uABqsTOROLVczGweheLKZEzINXA8Rc2pSX8sZYBUHEaCwoRZBq+lMF/rukc+hsPoaVZgyk8V5eLEuepF6Q
 J0OaXVPZ
 mom+OsjJrYmT1gBsxUCu/4fgD3BKhs4xELXZWToDgGblahGJ83JhY2C/sr5nbnUPwO/F7F0oUxQll/LsvYzGi7JRSnG56Du8vF6VTllyIO5gUlHmdy2aaQxma4D6tvHvFTys34V5mflPOTCkjflF0/nKjXffkEGEpb9YhE/3uZro/fXwvfacP8hqybE25K9M4fPvW4F927Y/rG9SSOAwkIOyP3tESBXKtyS0BBZboGV5EaNQoS96bG6k17oCBYbaba6RmH2FOlJVi/CCwyQmiY8eRWUwM5MxWQMwQfqBfaVBVy0lNl9c2nQs8j7ysN/RQgLrRRFVOmCHTlR3vB7ZMqrD0ritAs04bu7FGuGz+N/Eh/zVeHxh6VtjH4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:08:00AM +0000, Lorenzo Stoakes (ARM) wrote:
> All-in-all this seems to be adding more complexity to a current major AI bugfix
> target, in a cycle where we're not really looking for significant new
> functionality.
> 
> So given [0] I wonder if this could be deferred to the next cycle? David, what
> do you think?
> 
> In any case the code is pretty rough from a scan (I reviewed one of the commits
> to have a mini-dig) and looks very LLM-generated.
> 
> It needs _human_ polishing before we could take it regardless.

I don't mind deferring this to the next cycle.

Also, the patches themselves are all written by Jinjiang and me; some of the
descriptions may have been translated or generated with LLM, which helps improve
efficiency for non-native English speakers like me. If you don't like that style,
I'll try to avoid it and write the commit messages manually.

Thanks.
> 
> And additionally, you are shoving yet more logic into already horribly massive
> functions in dire need of rework.
> 
> Sorry but the technical debt does have to be paid at some point, so I think this
> would need some initial patches doing something about that before the rest of it
> anyway.

Fine, I'll try but it's not that easy to refactor scan_get_next_rmap_item().

> 
> [0]:https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org/
> 
> --
> Cheers, Lorenzo

