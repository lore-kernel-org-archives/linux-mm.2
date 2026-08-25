Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC6EC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD876B00AB; Tue, 25 Aug 2026 09:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D996B00AD; Tue, 25 Aug 2026 09:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93E16B00AE; Tue, 25 Aug 2026 09:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 842C86B00AB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:40:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F29E120414
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:40:36 +0000 (UTC)
X-FDA: 85139901672.15.114D78D
Received: from mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1510710000C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:40:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QIJi4YWi;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787665234;
	b=hFU1LErLmJP2nrua+qyuAmGmv8/PHw6jv2isb2oucQOIIGViCONJ+s9eAgLFRIuUoQEwQ0
	tbMVEar3ex7SF60zzbPEht8L95boMvGg0vpahMpYcND7LyZaoiuZ/ofbz2OokRr0DJE9Z9
	Ppn/Yvl6HVX+aQbdNEEEsLSN0uTfwWk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QIJi4YWi;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787665234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5+f7/VZeBnmjMMG/j87eFYyiez7Mmr/7O8LsWFBxAw=;
	b=liF4O3JZUWboT9QWqo+DlSWf2h729Clx6spWYqjlWjxDeP8hRmZrB6hKywV+mLfJg3lQw/
	9l103JulTP8/7N4cRM+3pCU4H8gp5Czfgv5R1Xu7ZmojyNNSQQlOBSf+DTOTUf9Vm/MCHi
	8/0qtG0ZasMr9JiU9/sg21HZB/C3oq0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0A3Ji21+yf4EPW8I2x+QmKHNXnWo8d4jWhEB3lqoREs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787665232; v=1; x=1788270032;
 b=QIJi4YWipiH/JWYaQAGC/0pR5+wRdnaR0LYs91IUcHZoLCfGDExVUoWaB1Ig4e8axjQSDeQN
 W5hR2mBQajsppiefyN5OKsec51GQ9wTf923yqBm6p8xyZP6Lve8XdEozPUz52BnCqIgNjRH1nAF
 PH7RyMPGcpyu9+MVQm4+SSg4=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.254.116.35] (101.126.56.83)
	by smtp.migadu.com with ESMTPS id 09d1a17ef30c8715;
	Tue, 25 Aug 2026 13:40:32 +0000
X-Mizu-Trace-ID: 09d1a17ef30c8715
X-Migadu-Flow: FLOW_OUT
Message-ID: <0d300afb-cc12-498b-a350-77fde67d85f3@linux.dev>
Date: Tue, 25 Aug 2026 21:40:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/17] mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-18-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-18-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1510710000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 1o4qcxfoea7hz9kxm6fzmkd15w6es765
X-HE-Tag: 1787665233-322909
X-HE-Meta: U2FsdGVkX1//WHaDbLWE4uHqZFYcnVZDM6FmRHvnKSF34NZ1ziY0nKue2bzhgQK5Q3X6FbaK+8vaIS7N51VYXrHVl7V5UqW/nCzR/KtrFeFFa672VzV2yPUnjQdph64CrdW5fGMDRxsGw/sBmI9N0yLyc9lmfTpsSDnMyebneP1uy19/AYG2Tf1egrM8dRGMdm5ogMkPXL1HbSUzUJrCvYC6SsY6WzXVPGOYQaBKfT7surUKwIRKl/dMIQ7wZgFLgUYeXjQOBdYIjIYukVMPnthjyQd+r0uagtCLVU1+jdMCpMB7CT+TkBUgbZ7KgeZFixRK9zRVAuggyH2QM6ShsepiJQ9cty46SFgXLS1dbUeXD6tvuCF0dixyPBKWVVifRsjrjl+7CG3a1fMQ88o9Jf4Gl3J8MS2pC5U6OYolNBRtHxUGVdVW+vGqn4kFK841mx5sQxxzdMHW8yNHM3vBVtwS7mfAufPgGsrOtuDspnylzOZ2hUhYsnWWvecjxZILyyxsEJ0VzhQJLEJ55F/ZzjHGJlm9XV4pzg3M3gXURqzwHyXQryEqVBXUIBdIhmwAlmK4ngzG4Jw7e/+Tcbr9WtUGrMefplNmJ1uwCZQtF4PwBnTfbq/AinmLHDJXf3JAvH3GTBJ8vSKiKpdgvj7or6g6ka6R7+LMHnKDKrsUbhCQidNWbqhzzEemnHcg97TVVbu62g+pgeFwgJlQ9NeudyYDefPVfQ4WcHnTP3FWdE2SuADZ5an0TVh+2QkiLAJ4AT2gcbbxSEVhfQmjtxjW8KPLKm8wfTyhT2u5nKk5xob3MejyTl5gA0ABFsnTQNhHG2KIT/tsGHQCrDOISdBDXpsxCCfwzpy3B1AS00+ycxZKwu/xSzmbyTEojjq49NDzSKOI53E7RB1J0o2QZqFgwuVmJXlxGDOMNugiiSyWBRjPeUcq3m/Zw9K9X0vQWm1gEWQMk72C4tZgDMKAi5g
 qzT0QPju
 XGMOXS+iGGuAPTsy3uoZ8qIe5dZxSWnLXKjEt2cBGJF2Fvh185uAr7Z5HlFb+KoXkLpe9/iZCS+1WYS9ZZnnRMUuMpUsZxOo9zR9N2/4gBl43nN6aDa/xbcjfNp7UoPSa2KxDpyKC4VrOQf+5/5D6kBCVg/CKuRtSapqIoAU05UtXDCl9DWLpKUnsSJWEt/SMNzOyZObA7ZjuvhSieSiXe01be5dyMa6doI2dHzCWHG8BU53AZHJYgXzswW4hq0uDOb/hDzKj66tGkuTv2Y6+mOFs7L5yyyHu5zNN1V8kUCnWxOfqUd9eT+FjHAYPT6uJeAYx/y+EJ/trae/KVLa0ra35hKVJm9AW68w8pvRIk/aUVzbXmtPAaXwoy6+p2txQLuZr2T66qvqEfoEQxpZh4MjZCmARFr37vpg6Fln7Fh9GpIp7FOjMDXSVdiuDlbvqIZqx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:46 PM, Muchun Song wrote:
> HUGE_BOOTMEM_ZONES_VALID is only used by the huge_bootmem_page flag
> handling in mm/hugetlb.c. Keep the definition next to that private data
> structure instead of exposing it through the public hugetlb header.
> 
> No functional change is intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v2:
> - Collect Acked-by from Mike Rapoport
> ---
>   include/linux/hugetlb.h | 2 --
>   mm/hugetlb.c            | 2 ++
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


