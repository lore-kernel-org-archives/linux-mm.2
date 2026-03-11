Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 637C4FD88D8
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 01:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34ACA6B0088; Tue, 10 Mar 2026 21:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9B36B0089; Tue, 10 Mar 2026 21:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2054E6B008A; Tue, 10 Mar 2026 21:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EE13A6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:37:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A7F3B9CD7
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:37:47 +0000 (UTC)
X-FDA: 84532070574.29.21ACB2E
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id C1B4020005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:37:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="K6y/0sGS";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773193065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgU6nTqZrRU2uknMVZdkalSe93rsrUBZvBhDOt8pxv4=;
	b=uiD8tD4F9/+GE4LaBf7pFphgRiPVHdkdM+Sj/s1dxTB/3q+3a0NgkMvTq21AR4B0xm0dp7
	rtzokrFCpwK1qoDfOJlQIy3X/Aj5lCDTcEHUxXCX4ix4RwBf+cMSI5LPDSqm2FEq2Saqr2
	2DT7Vj2r4SImXxsKriHYPHTEg5rjxaE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="K6y/0sGS";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773193065; a=rsa-sha256;
	cv=none;
	b=7QKh3k4RI/+JdrphmY+wShuT6qls227yA4kdzvKdeu6yTFatWVGtmV9fBzAxkmkGYbrylq
	6je7YiwtflJJLoleesIGbikT2k5TnvMQtrIGG0Z++WaDZ6rRUjVhZyfFvcOrc56puev0pq
	Q17QSC/ef1wIsrMgzYGEUCdDp+Zc/9g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773193060; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OgU6nTqZrRU2uknMVZdkalSe93rsrUBZvBhDOt8pxv4=;
	b=K6y/0sGSPvzF0Cg7pSDoanEZqM7dZa3eC39aoUT3vE+u+WeG5D265q4cF3BFOJ0MHJNSPE/jFEUqOx3DFrT2COQOlu/CgtUdbA0Ah53p6dkavt1t/TUqMD/GCLu4apboFGM3Z3mD8WJkvpoyQ4vGr9wHzSQ7kT2qavuvna/4Wto=
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-hom3e_1773193058 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Mar 2026 09:37:39 +0800
Message-ID: <1b33c5ce-99c2-41f0-8064-c1da5834cff7@linux.alibaba.com>
Date: Wed, 11 Mar 2026 09:37:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
 <20260310-thp_logs-v5-2-686099175bf6@debian.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260310-thp_logs-v5-2-686099175bf6@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C1B4020005
X-Stat-Signature: puohy6e5ddqoj7eykek1suhyrpqmqrg9
X-Rspam-User: 
X-HE-Tag: 1773193063-489022
X-HE-Meta: U2FsdGVkX1/SoR95kqYRxdQkKSvWmUUj/wEmWxOM+2buR0QPuhOAOMvtGB97pEA7D478fa5WLScxpQYDUFFHvRO3BO06Z6FNb/7zPut9A/ozswhg7yLxUFxiLQ1oEM5ajtA6P9PHAcAFS+WanSIR77wpnVjEOrYMMEJn6xCC8TnAJm3ewh+hq7B3jg9UJLwo5oEdTty1A6K/64mDfApdYN5BX0aptNT9BXRe6OTvOhP6Ie39Koaaah/pTBGIYIzZI4/nJEB9Y8nQLiWGGKgaD+BUxouSReuZGrv/kTu5xVz5HvpEmlCmirVC986SNS6yw/2I7l3Rn03C1+2oAn2AWrh5eRsZvCmbsOTDqjQ0JYOur53YY2TE8NiA54W4rmWDn3KVJgQaP1m8w+jBfJtf3khJbS7E0T5GqXp4DrN+5a/Tu+K3xVvQl2/GoORCCloRbbTVPnbfRDFJkgPKvf/HyR4gRDvJ2+YAtnJpiVe/R7cPdZyRJK1JFkUzXB/WPUTCLlMqukxPIAwuBBYWPfpiKcS9fZW4ls+4czcjFDqpWP8pTwoB7vKKQcJFhWKYZ0MG5oolr7t33eVV4Wj0Yp4FYbNVwfSFBaFm3GO2ATHb5//pDAkRoJNY11iuTOYJh39yJbKdA/m6QD5inMshFery3lNA5ikgRSM3w+x3t4TcCQlpGUEDpot5Wx7tTxsnbjoCxoMiaNG1RbKKonGT5uakZboQ/1FaXQrFvqY8CryIcyDZvzpR5fOXmy4FSWjzhbhqlgClWdWrqFZUz18igpdoTCcftwqpkZ0+v3eOVKVERKejrDRLuCQc2K09912dh2Sdl2JeaPnRsFzzl9edCnx4tPS+3IR3w8VYkvIV1/pCq4qhHCbSJlvcVSb/UhVTs+ykjI7A6pI1s5WImowDSZ8xHan61T67jXhQf5LmYrOUJnrjUCJsXrOlGCIwMH6vS9IPPq7Kn4ANPEvMK8rOlkU
 ep76k0q8
 LHYQGZgxJO6WhxxWRXAzTbWsPjhiLuCKWteb2vLcSHce83KJYThda8aCatzKgLTgvkXVxygGjBFdHjWwf8KU/0Vmnx7EcMeoGOeSiEuYmhe18+je1xkxwY9aEOKM0r694ZSxul7pKBo7h9jq4YdEOYQKi/eg5/sOz2QRviuq9h3kkD7ROM0mhxYu/HmGOmOuZ2iFvVwYXj/LDPx5mPCQYt8Be353qbIasRmKf0mz5+Emb3l/Kuk4fQE8C8e3uT8b1PV6El4LGGUtmI/DmjWWMaITKe3bzbG8suX1a/+qbUE7tn4G+AlE12vz01X3CYzPpVkOA0OVM3M2l9QIEpZ13g4WSdkJX8dOnX9n8M+Kj/ADD1TmSy5zbkHNLQUROxsKXYSLuh5VJCBcKICg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/11/26 1:57 AM, Breno Leitao wrote:
> Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
> anon_enabled_store() into a new change_anon_orders() helper that
> loops over an orders[] array, setting the bit for the selected mode
> and clearing the others.
> 
> Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
> for the per-order anon THP setting.
> 
> Use sysfs_match_string() with the anon_enabled_mode_strings[] table
> to replace the if/else chain of sysfs_streq() calls.
> 
> The helper uses test_and_set_bit()/test_and_clear_bit() to track
> whether the state actually changed, so start_stop_khugepaged() is
> only called when needed. When the mode is unchanged,
> set_recommended_min_free_kbytes() is called directly to preserve
> the watermark recalculation behavior of the original code.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

