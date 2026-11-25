Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB6E606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kka7V0z3
Received: by kanga.kvack.org (Postfix)
	id E021F6B0995; Wed, 25 Nov 2026 05:17:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB27E6B0997; Wed, 25 Nov 2026 05:17:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8EB6B0998; Wed, 25 Nov 2026 05:17:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2FE86B0995
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:17:45 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0DE9AA0E57
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:17:45 +0000 (UTC)
X-FDA: 85473240090.06.E7D5610
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 550B84000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:17:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kka7V0z3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795601863;
	b=eqsAI5eCa9XgRb6HsLh/nOpAc6vjnHCjGTxrUEHkgbNU/PbmbKY+k11c02XUiKnE0smgKJ
	fcEojYEKMYDhQmWRYqvW54EV5I21XR73DQOTFxYK/+DJCZFPaVqNpwQUjIE1lNXNHg8h5v
	DONIa07chyG9nqxCyGFM1a0Dvb/J7pY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795601863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVpSybBRP0s0J8L4gfkBHiRSvBKROD3zUxXIUAM8HhA=;
	b=hEropbd/sDaFEDhiIa55Da23z4ILBl4opb9iDWP2uBXq2WjRK4wx2dmN/CxsU6CXR3cQPE
	CKioaW+KkwBtQKNXfLfUh7b0muWyzhx5GOcSRIVqVaHwqMr1dlKL2V+eu7gr7pW/sLqqJo
	xDEcy8yacQ2AMinIFE58jqvQ5ZwTyvA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kka7V0z3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C912B60D13;
	Wed, 25 Nov 2026 10:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521A21F000D0;
	Wed, 25 Nov 2026 10:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795601862;
	bh=MVpSybBRP0s0J8L4gfkBHiRSvBKROD3zUxXIUAM8HhA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kka7V0z3rAN2myWRWUJ7Onlql/wheMihA7nbgFyaVm1BMatCAYHP0qX/KUiaqp7xS
	 wLL8DPzN2vyqWkZbm50OyTrAeRDGS/uWROQbMr04QqVwiXXwaaOSJlP3lIVNxUSBnL
	 baazwmqsbZ8BoEUyRXPuSgvLJnIQzG5unm3ZB7xa9FZtWATUTvSP3TsZXsAiptJpN/
	 m7zoI+FonBW6LTpOS8CM55qrkns+g7qwaVuv0/gszNJFEmUskBP8mIgJizSQBKWt+l
	 JFC2nQ4ayt+sS6gOQ4/ePJkENKDTf8g4TYbEz6EVsh34z6BAmvyc99wucVvbtB5q1H
	 Z8fpZY/SVzKrg==
Message-ID: <1b88fc30-a3d9-473c-92b7-701cc563be1c@kernel.org>
Date: Wed, 25 Nov 2026 11:17:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 17/18] mm/mglru: folio LRU refs based active/inactive
 number accounting
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang
 <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>, Ridong Chen <ridong.chen@linux.dev>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-17-8ffea39934a6@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261124-mglru-fg-v6-17-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: xg753kcjdi3tzxy4cq5rtmm653rfs3o7
X-Rspamd-Queue-Id: 550B84000B
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795601863-667490
X-HE-Meta: U2FsdGVkX18tQLbB4t9ruUp61vZ1/olnfmEjBgTiUVlB8/XpFvPvOkgzvVm08YqUFGz6tOAMCNFHoy74fd1Qsbzwi+9W8iOd3/E2wx4EsnyLCVfV4uz5qPYgSiX4ec4m6PtRGRoIoJA+51rrJ8GGOuGJbLSopskBRGOZjbY9v0U7so8VycCAhkWKAKFIa5/sHBdhkmbHETRsDUh4AszH4t79hoHr2yn+DIDWZ0ri3B7cMgfyod4fXkH3OZkzuIThayjLyetyPMMqJaMaDzk4cLe+UxPXT0VvA6o4stdsCUaxo/7L1aZmQrhEd+Mb7TfvF8Fb8syzukbTsJ7h4VmDnCntYvv7RZ2iy92AN6Ox0fNxO4zhNo2CYr6m+RVuyetUR7SY5refV7yFlBqFsR9ubHL2R8kEmJUF82aQ+/kZCgwgjj6CnyYSsEliSGELxG9/v1Cd3YlYbagXg2WXqV1Hk59pwmF6orZTDINc+ukEy/SOtIbKZ5QArHOIjt/0ck5TLnRAUqmMexxvVWqAh/YZUXzvcOTKCEgEOoRx18r4IYIeXiHl4fg1xCmyWbu6Yz4OKtOW8b27yrgMLs+mzT3GYrw4LDuR+RjiLG7bQy0wGo2LzGEu+6Me8GZmdRe3u+xwKxtQxURn3mjQV3+nCaLW1jgtDvo6ioIvjyFBssUP5++RIhq7/TDrzLS7LLIw/NypWCDPw8T2yIMy9g7ZT2R9HxU5oaVM/qrrtLQXX4YptMyIBkPtNKK4EFcR2kqCWoxT46wdKHwRhWBq9UIjBCCObUrMS50RyiL41l494PY+NYNyMt1Hs4UeCsWUTVanrZYn3cKsCL5pOGxuW2v+koURQSbk5K3aXTohUMuaukhyQJmbE4WIvKUUecFzXkyYRMOhovn4Wx8K/YWaSPvEWzc+X7kxkhuvSZlhw3BRedD1iBqoD+qEazOSGN1GcOanr4S7gIPtKRlcB7xg4+R6kQf
 hO0tODvZ
 5gj0eo9KOtcSb/JpAwIGYHclbeEA0byUrkfLsy3StFaVqHAlAZ7Jwrn9PZO90ezOZA6Ek1d1sTJUYPNsyWGxVxfxCDCWYUWnW8qzkTfk19BkawtQGBVXKFqz2xT52MrugaHqfTkCI7kI1CvkrN4lqUzwgahT9uiwxL4q7WoZYfVsCxLvIpG8sLLUrISThuzfl/lIcmzGnIBqgHKEWS7qXxdzgwL4bs4xvcr0VDnFBMA/PjXVs3+JDjKY/xR5YzuyhK1Xefuz+KVOwPuqyULkJzVyY+8RLtZOjDhQxEOTFclgngErrDrm7gn9uWiTt5ySjrgV63kneku0VKiO05xWX325gmToUgVQuRNcaXJHcsZ1UhohUO78JSKsBmMo0VPpucKVfs1ovFXA3setb4gg4MiNeFhtx9h1/SzDKxRFXIzEozJcW6FlgyY58UHRAv0tPWi/s9yv4khGQGyO0Q0N2FDwfmX5GNluYWtTA2bko2M0svRltm16falPtv8QVYi/IvGtD/GcOi91XsTeg6AmM8B4UVzK8ZzgU7dErOUdrRyTawz0Kw+r+1XD4nGQkiMB1ryX1SqX1/w5CZlyx4kvKgXlmvG210Rfj/E9D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Currently the active/inactive LRU sizes exported through /proc/vmstat
> and memory.stat are derived from the generation window: folios in the
> two newest generations are accounted as active, the rest as inactive.
> This causes several problems:
> 
> - Unmapped file folios can stay in older gens despite repeated use,
>   so active files can be under-reported, unlike classical LRU.
> 
> - The reading is jumpy: on aging, the second-newest gen, previously
>   active, becomes inactive all at once, causing a huge drop of active
>   folios without any change in use.
> 
> - The reading is reversed on swapless machines. When swapping is
>   disabled or unavailable, MGLRU ages anon by moving the gens directly
>   without walking or touching any folio, to reduce the overhead. So
>   inactive anon folios can suddenly count as active, or vice versa,
>   despite no change in their hotness.
> 
> With frequency guided promotion, hotness is already tracked per folio by
> its referenced count, so we can do folio level accounting instead: a
> folio is active once its refs reach LRU_REFS_ACTIVATED (currently
> LRU_REFS_PROTECTED).
> 
> On reaching this threshold, folios are accounted to the active part.
> On forced per-folio aging or PID protection, refs are capped at
> LRU_REFS_WORKINGSET, dropping active folios to the inactive part.
> Note that on swapless machines anon refs are not reset by aging (the
> shortcut skips the per-folio walk), but the counts no longer oscillate
> as the generation indices wrap.
> 
> The accounting is now per folio and lruvec independent, so no size
> adjustment is needed when reparenting a dying memcg: the hierarchical
> stats keep the counts in the parent automatically.
> 
> folio_migrate_lru_refs() also gains off-LRU VM_WARN_ON_ONCE checks and
> __folio_set_lru_refs() leaves a folio that is still on a gen list alone,
> as its refs are already in the active/inactive counters.
> 
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  Documentation/admin-guide/mm/multigen_lru.rst |   4 +-
>  include/linux/mm_inline.h                     | 100 ++++++-----

Another clear indication that this should go into a separate header. Maybe
mglru.h or vmscan.h ... or both.

-- 
Cheers,

David

