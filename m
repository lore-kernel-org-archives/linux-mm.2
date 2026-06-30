Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C4EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D0BA6B00D0; Mon, 29 Jun 2026 21:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480CA6B00D1; Mon, 29 Jun 2026 21:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3707A6B00D2; Mon, 29 Jun 2026 21:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CDF76B00D0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:32:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D8A5166938
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:32:17 +0000 (UTC)
X-FDA: 84934853514.21.5C70858
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf05.hostedemail.com (Postfix) with ESMTP id 448E7100005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:32:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TwYQJBuw;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782783135;
	b=7zhnr9eKWPPpKwsBRvgOt9XxuKiM3WtejHvZa7a6s3N5aBU+ojVjA6b0vLfXIo8ghpFpce
	8JWZaq7r7xAYHq2WBOCIZti1VdmERVlpQowk3pZbvT+FzrpU8Ayc0C+HHwI/DhDV3tdKLM
	FYke8XLzkHsM6ZOaAlgUwgdXjMam2O8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782783135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/S/BIvky4ogkwc9B+8A9zZA9Y76XlrdAYcVHdo+9Qk=;
	b=BrPTJkOPEsdTfAWBVEPk6hdEGqN8BSjh+uR+u/ombEUsUZW28TLdXNLGtkyzwEzNtTSmzC
	Z03u/mfgLGKA0lC6+he4jcHmAlZIA82u7hG1JtrF+ajn9ZQBAN7ELr7UZ8stq01XhLIxp3
	+sHEu/INALYI1ZHDHaft7BZZ2KA5Lo0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TwYQJBuw;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782783129; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=f/S/BIvky4ogkwc9B+8A9zZA9Y76XlrdAYcVHdo+9Qk=;
	b=TwYQJBuwUzT9yJmsvyUEXqK8En2t0HggSFDl4u0tKHtR4JkR/Dat5xHTTz4y/6VjYYyX0OZiWP/4LukEzl9nu99SUBm6P870z5Fu//qto1ECPQtZ9NOH6m8V46ki4be9AkWANSVLWf938GEbbd14/x40SJJ+3A37Mc+jVYeQUXM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X5z0nPo_1782783127;
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X5z0nPo_1782783127 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 30 Jun 2026 09:32:07 +0800
Message-ID: <4154c23d-faac-4d84-990e-a9a0aec5ed46@linux.alibaba.com>
Date: Tue, 30 Jun 2026 09:32:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm/compaction: stop recording free page order in
 page->private
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
 <20260628-keep-subpage-private-zero-at-free-v1-1-f4ce3930d10f@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260628-keep-subpage-private-zero-at-free-v1-1-f4ce3930d10f@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: g39xpwkm851pwnbfqc8b8ut698ydmykw
X-Rspamd-Queue-Id: 448E7100005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782783133-562740
X-HE-Meta: U2FsdGVkX1+Ualgsaj4ItkGSXuYr0/EQbwrwrgXFXhdnXZi5ZvTmK3N7UWAO35FR29/dsOIrFoRmhdS/Ow1MhWhXOKZY//aItYSi7kZMUPXQY12k6+iMmkBY/+xvaU3TLqgYnhFu7NQU3iJ140TON2px95UgPXvaZlFwUezx1AfpPuXygjcrF2yV6Qyw0Nvb+RgNsw07bhBQQNt/9AkB8i0tThdMdhPK/d1naRpcC4PxUI6oD+07Sim4Rwfs+2hq8DZDYv42FPCo8PfZ+rLrWTHyfCJ2HwFVLuR9YsZ58PtEPrqeAVnrz6tgtuZTNdvLR3iwfRsYbHYkwFYtKkRXQNGcHHuDHmQKS6TEoWYOAvJeR9Php4WakwUZYum+Emdytyqm4fn0OJXXCCKeW2YBol0ffWrQRHbhD0sRe9J/Fg8px/HY+OF634dRprFHQAttHo02nBYkf7sXybK252hj3wE9FGOtG9lKRu0EtRueJp8ay0hW4t5Pow+gJHJG0OIW09GnIwTqZW77rluVTQn16EC1LyQh6A33Y9Ir2OpyeuJcYDlAsDEKjFZqWZoYHeNOURmMOPw0L+13PbE+HtWK2V2dDgIPNcD5Tvt/245NE64Yzy2Rae5TlgN+uBBRewNqGJXTHHSJseWHnnjB/zdhfLcdWzbodO8RxuTPZ69SSfjkbT85z5XVT7lz1YtxutZe9S+dG9lJIVwx2uZOt/1pNkNUepXROSGi+1XIAqDz21eN75lHbOyraZ9yl3/z3cDmfCHidk9/Wrt8n5bbbthkXaLaD8vM/UuR9Imqd9B8Ov4RyMsJmrpvVNRJkUEuIVsQNUOfKoPKC+0ZOmDHzBFZsNGNugcJ8XVH8ujkJ/56Bl6nf615O37uLql82UXr+ruJ/453xLF4Vrr0umESKMTmhzSlTTNsyWrP1O0mIYCUMw3LnB1KHSMo2muyePcQLZRwFUt6qW3uTVZu36GxvrS
 ThV+BAmH
 3Gjk8TjZDICC05bxTNwXSzk6f+ULbr2FK6tjPPTQxLEEidZpMWuvyJ7o24Tl5isj2AuknlrOo0IJXZ3gyQC2sJZjbcOcJoo0w3UFE2eGgYqvBle/b1HfWELgu/iea+4kzKyGOvr7B5UJR5GAhonwIYHnulo6owVK1jn6Ws4SgnI05fyk+6zBnSFdVoPDM4xhdm6eMCu6pb2Ty0Ye9yAgUDUBM9xQ7y6LN4J0P/BJL4sawWSPvtfaeGNJDBshexrdefB/Cn1SOdLFdNTz5xaAZ2+EJ0lViIUelrwT0aTVNjHk12MrGC2ry3c8Bfsv5xZH9Q2+93dZmoIpdQak3HiYCUK90oS7peBFKaCvZhgw+zIwkaBcFaw+LOTMUPaSqozqkpKoMWgbk0yfu2Jucm0jOb66HyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/29/26 10:56 AM, Zi Yan wrote:
> Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
> memory compaction.") stores isolated free pages in an array indexed by free
> page orders, it is no longer needed to store the order in each page's
> ->private field. And there is no code using the stored order. Stop doing
> that.
> 
> It also prepares for an upcoming change that ensures subpage->private is

I noticed that people tend to avoid using the term "subpage" now, though 
I understand what you mean by it here. :)

[1] https://lore.kernel.org/all/20260623125723.2503832-1-dev.jain@arm.com/

> zero at page free time and the removal of set_page_private(0) from
> prep_compound_tail(). In alloc_contig_frozen_range_noprof(),
> isolate_freepages_range() is used to grab free pages from buddy allocator
> and it leaves the aforementioned page->private set until
> either split_free_frozen_pages() or prep_new_page() is called. That
> triggers the upcoming subpage->private nonzero check along once
> set_page_private(0) is removed from prep_compound_tail(), which is called
> via prep_new_page().
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

