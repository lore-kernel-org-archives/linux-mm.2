Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 849CACD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4556B0092; Tue,  9 Jun 2026 06:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9BA96B0093; Tue,  9 Jun 2026 06:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1D46B0095; Tue,  9 Jun 2026 06:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA1CF6B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:26:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DD181404E2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:26:27 +0000 (UTC)
X-FDA: 84859994814.29.DBAC724
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id BC1C71C0007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:26:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lYANH0J+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781000785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F064lp4RYUWIWEZrBtaLhHrfLe3DbUKK7LrCz+/mRa8=;
	b=VzCeeuBYUx7osGKoyiIRPSZ8zTBdEIPvjMDK/1dkhR2o6HYg6aEkSfbhKKxuXWuth/hZaZ
	IHuv/as9QnGzvj7YauOl7ZWKTspHethdzLh1ShVpoRmB83YEpBOzxF5bUvHgcmUvBOZnUj
	JWKjYY4QtZdXbUtDHC9hhJZx7GN3qYg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lYANH0J+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781000785;
	b=V0JGtAF94KxSZVB3F/qpLi6QUUYWpi3/iXaUlfeg1gX7ScJHi4c/hMeNusxKuQX54NzpIt
	E4eLRJ5MWKuC4TnTPUx1OgH+u/s2AlzQh79nOxlhcRDZO+osTMHox2FCILKjU3g3a/c3Re
	MKs+LsclXhYs1WHqUdnew9pa1xayRrY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C179341957;
	Tue,  9 Jun 2026 10:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96BB1F00899;
	Tue,  9 Jun 2026 10:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781000784;
	bh=F064lp4RYUWIWEZrBtaLhHrfLe3DbUKK7LrCz+/mRa8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lYANH0J+A6FqcKRF8IJmXs6TNG5G0he/x2pCGMgSpNd2SDCBWAYHI03bu29BBF/XH
	 v1cpvR12px8orZTlNsHl8XmzW8teDMkoOo1TNwyy5Yfp0LVfOBbV76cbuDm/mGuxFY
	 ztyGRa3N2a46wNGE3h4sWIh+g/rX7bPMIzwSRUN9NBq+jTzklZeso5jR83XffRa1y2
	 4/i84sgeCriZc8yuZBVFpIIDwkfxxQbOVHuKk8jvwb0pePJDiMerKWyAObOg/o01VH
	 LGuVEsQG6tySfAmcgZe/tHkvSU+maiEFcO1lSeQ6j+ajihE4LMUMCuUo3gXVT8MOZW
	 oYDkFmaflXxjA==
Message-ID: <d4636be2-d9fe-4464-99d7-b0b9902e6b52@kernel.org>
Date: Tue, 9 Jun 2026 12:26:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm/khugepaged: use slab cache instead of normal
 kmalloc
Content-Language: en-US
To: Luka Bai <lukafocus@icloud.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
 Luka Bai <lukabai@tencent.com>
References: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
 <20260531-thp_collapse_hint-v1-2-e7f8c2035621@tencent.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260531-thp_collapse_hint-v1-2-e7f8c2035621@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BC1C71C0007
X-Stat-Signature: 4te6ykb1c399wfd91gnb74rpx7pqoms3
X-Rspam-User: 
X-HE-Tag: 1781000785-835871
X-HE-Meta: U2FsdGVkX1+gTveiqqQJYUw85gZDvc8d0sPX7LZvlbCG3q0hkdpdOOoL6PQWavD/0GwYdP8OCiRzMNYQp2j7dOZaZk54KErnWd7OLztPfDOBpIhJ7HYK+7Kvf51bbCamEC3sLoGo3pX0cdahgcMta0qGprQazrkCC8sMS935aZI20o7o+sgh73Ue4j5GZdL72xD05hMqC/3PCY7JcstlrbaKsQ5cxioZfIWnKC8WcXFeY36Ykj8vXSWyBfH32MlAxM7D85ut3MC/1uHTK6QbrE5OFq3FHKsyi6y74dGdlcFjMEF4YLPAbQ4zRG3uwz3dznMj4nEClUlv5NczhV3wY8wqPHkWkrmKbi7WcoytD1q6B+tcY4XXqwKP56l2phk3TLdFT+9QE1WyTRsdL+XoxKQ6U6V/a8SxgBvxCnDjnby0UciR52d+zS7P4pDTY9i/blCihpBnjtXmYxTQDscrIYHDQkx1qaNF7ondyu14omo8D3/FQFLjev62cKLLAdSRzN2n6YZk1tCH0XLPC6Un+0ev6v0hCGvf0C29iWt0vVRT0SLlD8/aaubHPUt3hDHRJ4P3/M/Rgkv4Q4puLHVOCaItnNRW1m76bXN9SNhHRxzCYWpHvord3UaDS3PQmf+xVAr9qy+7GoTOv6tVWUDvBG9aA61tGy9CLg1rMS73JUgTafNOzIN3T5rA6vQbvlB50xOgSo8rFiYaDcUj/xyD42vmQzhfpwkKL7Z/rESj+sZyTAFOTjV5ulfFKGuJ357mazH0aK4bZFK8b+YhhJdnZ9QxwD7so/l8OYnExJnglYwM3W3hdgmsPeRUcw0yYhagNkhcjCvkvdbiHsE6YRpluQje4+JT+UVuZxzOetEL6IcqE1euIJJ9meKO2DdjCbdzMDOacbuK/BleAyluow1BjIvOyw/xs3G9dmxmA4CkkMVZiIBcEfAnaey5XFXbuM1ZS/XuQedtqn3Ck63pGUA
 MxvJ9JyW
 wsnJxqLPy9m8yA6ZTUyi1FnUo9O7LrSwuqw+3PpJYnjMjnFLmhCzRQDoIHHazD5u4kSHBs7wt+fEaECH5Crs9XXOelsopg4cBXrjIDDpf5Vy3oe4Apr0v7NHFXA9NzQ0Tl+qq1Ue5F+BpOHJtcTGTGhlKlJBP7118uniL4+gyt5pmJTrUvCrNbjMspz8FZe7N193t36SsqHvP8BUWEUZjPO5uMYRawPLx1nNH5wml+8PhbCdVbuWbGKnXQOHNZq9eAP2Itrq6vKrYsVrC1y5rJQUqKxGgDeFW2aMz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/31/26 06:23, Luka Bai wrote:
> From: Luka Bai <lukabai@tencent.com>
> 
> We added a kmem slab cached called collapse_hint_cache for
> khugepaged collapse hint, to improve the performance in allocation
> and freeing for the hint structs.
> 
> Signed-off-by: Luka Bai <lukabai@tencent.com>

Khugepaged isn't exactly a hotpath? Adding own cache comes with memory
overhead, so this doesn't seem like a sufficient reason to do that.


