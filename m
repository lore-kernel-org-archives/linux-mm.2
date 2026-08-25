Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8EA6C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1FFD6B00C7; Tue, 25 Aug 2026 06:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF7326B00CF; Tue, 25 Aug 2026 06:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5AA6B00D1; Tue, 25 Aug 2026 06:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C20D6B00C7
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:54:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B8671403AE
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:54:25 +0000 (UTC)
X-FDA: 85139482890.20.7B2E86B
Received: from mta1.migadu.com (out-64.mta1.migadu.com [95.215.58.64])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A11EA000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:54:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="a/Ku+VeZ";
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.64 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787655263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nTUZ8sLbFFVD3/cktIa3yTf+WRlvhShTIOBMSL++VXM=;
	b=rJhsbJctW21Lq0eFmUb4hwcV8cJtx5lNUtqIZYzjMWUx254p4cbpNmod3nxjdYf4/MEqx6
	T7TXbkxz7NvIC/87ZWB9qp4ty6AM/BQraImZsCbI+x4AhhFG5rBA2iubs2jELXiQkHRQvT
	7ZRYQoRtRtveWSHbBKcb1bpAlEsmBV8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="a/Ku+VeZ";
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.64 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787655263;
	b=Xa8l0qre5wcl4GOTPyHiKshEjrUbBwlhuv7hEvSesE1FPfLcnbxNZkb7QoBwnYYGuiwfeB
	whhhHDaa14j4hrJNLoIcTm3F1rJ0hUR0xd0cWkHU9QD4WCZJ9IBWlzcCXgJUPQYw4WhhG5
	YnpFouWlei6XWihDBNfvS/JnKU/5Cb0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=k+zE5wZ+j7NLnUUbdJbjWlgOvh60en9e43cI6lQENok=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787655262; v=1; x=1788260062;
 b=a/Ku+VeZPJie7WUaxZa27i4hbtJmm2aacl1TA60x7ndVyeg7KSFdROMQqt7EOVOzxzjjIN5j
 O9dc/9RJbruymsotQqQUJDwTrATQczbneJ/HRIdEZe8B+zmZHR+BwEnZLq0ugEvA0CaPs3gw1jv
 0VG0MjKS1DAD3iip14F8X7mY=
X-Envelope-To: linux-mm@kvack.org
Received: from [100.82.85.74] (101.71.133.200)
	by smtp.migadu.com with ESMTPS id 8df06239c78ed4c4;
	Tue, 25 Aug 2026 10:54:21 +0000
X-Mizu-Trace-ID: 8df06239c78ed4c4
X-Migadu-Flow: FLOW_OUT
Message-ID: <433b2245-6060-4f57-89da-c77d8425a0e0@linux.dev>
Date: Tue, 25 Aug 2026 18:54:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/17] mm/sparse-vmemmap: move helpers ahead of future
 callers
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
 <20260825084608.47437-8-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-8-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6A11EA000A
X-Stat-Signature: k9sny4b9hp7g5zeexmk81yxcqd7z96uy
X-Rspam-User: 
X-HE-Tag: 1787655263-620396
X-HE-Meta: U2FsdGVkX191ry8bazQqXMtpRdVmR5DpajfjOnKCwxghfO9vNRklgaDJ6QTU5VBML1hBEJOdHcBWf5OVoSvxuAjXzryMXSZhrtiSVtgnskg6iKLQEos7vgTTwKZoEVWtWrzaqBKSQR1WFhzxwCxuM+hhWrLjHrMkJTHFUOi0hGQx76nnihno+2a10QpH9rx+gVPJhFUBksjc1/OyFmElzh7xgMG7tPSkx6vhoEenhPUeDib76pnL4uzRaFmlFsweJDusVTPULZn9MvX8VkYocIxCs3TVCbmkNkzIji/YNF2NySqaWEq48rEM/39qu83p14Hqlomnqgw4rKpGoz2TFMwY+ISxQHwiS5o5Vmic68l6InTHRVYv7Owf8k6ungndeVKSsYtuG/BDpBEGm08o9G9lcp56yEUpg3hc0U1qtZGn/hHd6fVnABoWYsGod37ihpZyiV0Md2rx6DQKpLItARllAKpz+igawl4X9yoe6BauiwIUexG7Bn434qZt/jmfokLIHmPGLcwSxA0RI4vCA8JzUVnZdVXkbZoJW5DD3CxR6kRPMjmDo1nLXRffrnU8uXpbiubZc5oLpiuV1Omog6xfUcRLo33ta2S+kdjGPv8wi87gd8kyeEtrtHISnzq507ldJ64ylDTtBNA+QMcs2FStfPtikqEciucmeCGy/3eGm8xbRYecMRq0bbdahwwpoPxcN3YcbTn0apaTLIY9FTxc0IYZ+ujkY9pGc7b/nPV01YAiziBifZ2WXxL43lLFa2VifmRit2spo+DTujGr0L6Qlo1CDCmUBIhZYkCsjCMawslVO2TjzAj11MLq/PEk0tJf23PDzKgq+IZcv+Tbck55XBWkugcPUvdWM8wIijjDu85m8g3+gW23r9vfexQ/DUz2bwMweFFKVFocWHpEcoVmLVUze1p3A1k+X8jo5c1vWQQ6NgA+lG9Q4Kr6EjJ2DTBwKlBwZUJXu8Z7k1k
 aVGM7e/r
 fsAWWst9fqIoQtHB+KV3Mw0/O1wSTStgB0ceGVRWHavXUJD7qT7HHe0C9glJrb08y3E4q+C73pw6GBENW62a0vDZK97gXtOMtCjhbr8yc0GlHr6lgMxTKHYIYDdRil9LClMLL0CdWlR/6GGOmLAUca9aRAuhGup62oSUlLcZ3pD4p8BnFr7i8457elMjWqsDo/5LYMv0+QP98L+jZ2YKTIknyVECwxlxccO8/c36oSyOJ+WK0nl/GEQpc8/dNyMnDHAmChH+SvJEDgv96FNY27F9VrGpqwVmoMKdFnM31+Io2FdVeRycdyu8zEV6U9VNjsR3UqLFu+DLOj5skuYQE5QK6xWgM9JyfV7GLgASRe4YbyiSCLi9ajhozyGgpK8Rix99DTCylv9PIUPeIq3WsZWfwlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:45 PM, Muchun Song wrote:
> Prepare for section-based vmemmap optimization by moving helpers that
> follow-up changes will use. vmemmap_get_tail() will be called from the PTE
> population path. section_nr_vmemmap_pages() will be made visible outside
> the memory hotplug code and called from sparse_init_nid().
> 
> Move vmemmap_alloc_block_zero() together with vmemmap_get_tail(), since
> the tail helper depends on it. Move section_nr_vmemmap_pages() earlier
> into its own CONFIG_MEMORY_HOTPLUG block. That lets the later patch change
> its visibility and callers without also moving the function body.
> 
> No functional change is intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi



