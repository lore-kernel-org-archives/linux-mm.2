Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA48606A327
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=G/n0RLZ9
Received: by kanga.kvack.org (Postfix)
	id 4954C6B00EF; Wed, 28 Oct 2026 17:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F486B05B1; Wed, 28 Oct 2026 17:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF716B05B2; Wed, 28 Oct 2026 17:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0233C6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:59:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E84861A01F9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:59:37 +0000 (UTC)
X-FDA: 85373402394.13.2B142B4
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0D736140003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:59:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="G/n0RLZ9";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793224776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhxlTVYV9TLcZ/UBe1xcuRZQWn43bPmhsFTY2WYTAiQ=;
	b=NwHv3WF/bMQla4axjr3fn4GVlNMEmNte2b5Sh8sJ9QCAWtDII1YP5INZwQVlx89qtu27Qv
	l7f0711uhDJW2tTugsp8u2DeKRsVwbXvUdIN223p+d6TykA3Ce0wv2vEVTRBzCDttFT3tn
	bw5joJfW3Jzszh5HUtb6R67SsW9+UUw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="G/n0RLZ9";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793224776;
	b=58liYh+ttavkTX9oDkJ1tFeb6ZGMX9OFn3W0LWFjCVVmMx7qos9he0dBQm/zxae10Ld82W
	QTOVN8FmKUgTUsylJP6XGB8T0wAEVOIOZ3o8VVxaFIb/sUCilZ5e9Hpb+u9Ftkk/f6Wyqj
	nYtARhJ0n3zYr1EMNGtbEs7RTO0oRus=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93e7ad9f78dso161457785a.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793224775; x=1793829575; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OhxlTVYV9TLcZ/UBe1xcuRZQWn43bPmhsFTY2WYTAiQ=;
        b=G/n0RLZ9qN3kBBAZAq77bNg5fgsU9GnCzpfywzz8cWm6cQ7w7sjTHpriizAtJEyDp3
         vEt/77aYWb93UkAMeXPgCBNQLxPxVEX5w+qFJE0mORfO/QUfs9HVfaPoWuzoQiNoWR/4
         mTjpnssni9X9T7sFffD1xfEk5QEP4o+AGKqX16DW/8YWXZ15+nFZHRSUXU/AZQJk4kWx
         qF1xjStG5K8+GbFBEBRDESfzctvYVBJ39G2KcXbZOWhWY1/orXvIXXHzusancBmnGIIg
         VRwAyZfsF8sBHghBXeaE5yzW+QCkUt1ChF1N2KpFC+HfDBQ6WwzKa2DwGcxXK2DSHLQm
         yPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793224775; x=1793829575;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OhxlTVYV9TLcZ/UBe1xcuRZQWn43bPmhsFTY2WYTAiQ=;
        b=etpZWh5MWWSxYBH+ZsrCuoHCu8cqUx5mUue9xwqo5un1t5j15Ij/9C0dlSrZ0CI2of
         h0GOLG0YlMfmi8mK5YuiWCbCBn/p6tIhmSgztHTntEO53jYjHDF30itfQUUPO3gK7ZYf
         v20eolJIUGQYXvGmYELWDnFAaCoW5Qt6/TBXDpGUHn6QEPmkt15+yfgLbE0J4FKXiH1m
         1NE57bZR8vt0pRZkloj98R1A+q5xIdnzennM2CnnPzYaLT95VGm8G+gVQfDdZp+hqdTI
         kDQ3M7QL0qWVptCoUUP2gxudZ6Troja3TTgYvYLmUBxAglP6JRjR1dTRZnbICBGKf3hC
         gU0A==
X-Forwarded-Encrypted: i=1; AKwUvBx+HJtVWqMVP3fqOmSqfmWEjZypXdpjUqXj8IwuGVloRfML/VVvrbYrjnC1zjG7ULsvcHToT95uOQ==@kvack.org
X-Gm-Message-State: AFq9FYKa03G2XAEQvcQTjX0ZQJUaXiea1hz2RyipkXIp9BOzniA8RGtU
	4kR56UN6B+QzIS6ab0wesBqqFndrdBWd1w3NsxUC8AyLkG52Jwwqh5ImHJMllw4uC/Q=
X-Gm-Gg: AYBFou2p6CTVZUcdR79fdx/+bWh2XJDSMRcDBNgo3ekbs3H2MojwsPwtKiZy8DQ2JAJ
	1rvC/47UwIs2Y/haw7GqRI2JIsuxfdjS5xfRPnRbS6aSnrVcjl6vZfYUuvjcovNRo7bz9iDwflA
	GpASKelsx782hy5KqJIZPv3EPdS4YTtriVM2mzJlqHw24L2EFMqpgEm0ILGtbB+Yngs/GOtWo1k
	zjapqa4Gav0JxtcMI8WuDYonbU2wTDka1IO8meqTu5f2fk/MCnBK+bVZYj3WbH9+H+bdpr0mo8f
	CEJIFbnLCOSrTidUENbxCw81lbXeFbuwHrq/UhCJhirq57hkgnh2vWuubGxxzUfMaYlzZ7abV9R
	Ql1PreXIYKqRRuSnuTwNPpalPT7b25lCqLPkUuWlhY8XGvxaMA9ShHf6/IiNLdfDt+FMCo23wtY
	6VkTI6A2R5qaVAPRVLij8xEBHERRcMf7X2cxeALSGeyG+fEMPJZlKJ06l0DuMU0TPm2xs5anxyW
	5vhtDKPuzjtmkF5NguUkX6Oikpd0N4h5J7kbdv8xDgZ/rciFlg1CSKhdMZvEGaWKJLrn3xhwbcL
	A/spuFuQDxBQY6KJSE8CAfDu2v6rjs94jUp3bQXKJxktxOdG8PlmywC9cip1Ag8/WViL05E8Yvu
	B
X-Received: by 2002:a05:620a:460f:b0:93e:ce12:aadd with SMTP id af79cd13be357-94408db358bmr587757585a.58.1793224775119;
        Wed, 28 Oct 2026 14:59:35 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f078ba99sm1374978985a.32.2026.10.28.14.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:59:34 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 32/46] mm/memory_hotplug: avoid races in
 pfn_to_online_page() with dying pgmap
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
In-Reply-To: <20261027-fixes_core-v1-32-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-32-6f74bec9a5bb@kernel.org>
Date: Wed, 28 Oct 2026 17:59:33 -0400
Message-Id: <179322477323.1935969.10540673116963281867.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 0D736140003
X-Stat-Signature: 8woc45g8wh4oqzxpmk441xerasd7mdru
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793224775-539880
X-HE-Meta: U2FsdGVkX18zZI5S3EPUaSBLiE6n6MrkSbj3i+qRnwaeRIEvdCSx6S3XhQ2gD9pKiXol+KUL3kWtBVdKt9uSE++jpbCogsh9KWTF0ie5zDRjDj9/HIPKDA88sKQfanHseK/wnW4D6R35P/7INEtZIvyCIWggt0rSgTkrFYlYoq1NhNlAoUettG3AZvJSOyiM8HHADQ5BpaAWhPUNU13e09VkKZ1/iPnntKoki8GaLCxTRQfZkhBCArs7LZBXAGfmE6sYldQRzuI9x1A96xA+kd27grRqucJWPor5DdXQvCXfBCgixEVX6VA5BCXOnqkn3lFAV1hgvmFUkHNfjJV3EmuRel6lXDrnB7il4YWhCKKxwZOzTOJgcxif5lm+7X/5PowvP0MV/V3Y2/aTiyug+mx3jCJSk+nc/iF90c14D0KSBsQmJoU2wjjOCprfo5gPCJ8WyceZQoORAxSXBVGyZh8awya/QwN1ga5vfp8sJHvsvvcftItKFDcz+LOIHMvh4OFdEAbOi5LXRxPTSHvQjjF4rDzQ1C3sCqJDf6pwi6H3EbhK4FobtXIlrlJ3bSMSlKNkJTNTBe4QGDkOf8zGeY1wlTc42U+3naG03PRMHDVHQ+/IO6JhQCEEn1TkTaFbnHEtYQFJ3SjhaUdkc1Cdxbtu22C3v15yfO5ltpGsLc92LKwEbjDd8JAESaRNL1s0BkjAybr1S9j6MTHNDnYfyvXI8B34xV8G4tYxrTt41TI67gmHQp2dyQ5IxEDy2rVmo8kDRB7Ip62v8Wm7G38/jtpthXeLiTrZ82NIeXQQE7s7QilbpsvW+jwhP1YY2PUOPZWFL2vxvAuXu+m2SI0louxhKnMgUOsiD8Vpm5+vYM0kR9stge2Vn246iKuZ3CCqChS7ZvSmBsgtTOiOHLDlw0yfBm1tHlKSTw0Uk+275QNG5GHPylLYY+4ej3914K4b/LjDz5VIpXC9C5JYL4H
 GfvXyRGW
 utAEWa+3eMv7XfQj9CLKonXdC+xouRmO5FNdB8zmkposzNqp8aZiG6G3p3f+cpEfqUd9x8msqqPGRSkdtqzhDvW19g7cDvh18aO1Ji89CAZmPnnuKTzHGLJxaiWo+IBjv8dWjafEmazLVytPNAyICv7GfNG5ldPDnAwQ767kYMy14SoL6WFYikkPpNnp3XUaBKW7oLOea7bzM55o+YGpTDfDsYsM4wXRfRcwUnZDrj0YN3s+abxGo2mL26YowOVDnomgxydheV/2hgnEKYj4zIulkS9cUZzbpk5xgLi9HGq/hCwIWcPdo/KrlZeOBfHrTGmYXPOZZhU1pN4PUGk7f5QWv+fZC4Ao715V7a8rz4WPtTvKHP5MpwJFdIinzQgkAspVR9kwGUdX92KmZakaHy3K6cRejXlVUwOroe0hXoUI2xkYhBGgG/6BwxQw+3ceDyDgrWWFmJeCQ3kvhmnv8oUa6YD3ytPh7SjdrbyaiaiteV12FIsHHIELXzbw/OXIn1TpNuQfpDkJGPB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 00:17 +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> If ZONE_DEVICE memory shares a memory section with ordinary memory, the
> section is online and the pfns of the device are valid.
> pfn_to_online_page() tells them apart by asking get_dev_pagemap() whether
> the pfn belongs to a dev_pagemap.
> 
> get_dev_pagemap() only returns a dev_pagemap whose reference is alive.
> memunmap_pages() kills the reference first, waits until all pages are
> idle, and then removes the memmap. During all that time the function
> finds nothing, and pfn_to_online_page() hands out the struct pages of the
> device as if they were online memory. A pfn walker reads them while they
> are poisoned and freed.
> 
> The entry in pgmap_array is only deleted after the pages have been
> removed. Look at that instead of trying to get a reference.
> 
> This is probably not worth CCing stable.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 1f90a3477df3 ("mm: teach pfn_to_online_page() about ZONE_DEVICE section collisions")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

More zone device pfn-walk brittleness :\

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


