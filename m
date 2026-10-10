Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AC39CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 08:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AEE46B0088; Sat, 10 Oct 2026 04:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5862F6B008A; Sat, 10 Oct 2026 04:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1FB6B008C; Sat, 10 Oct 2026 04:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 250236B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:36:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B282816081A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:36:07 +0000 (UTC)
X-FDA: 85306059174.30.48CBEFC
Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	by imf12.hostedemail.com (Postfix) with ESMTP id 56EF640003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:36:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GedrZ0qo;
	spf=pass (imf12.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791621365;
	b=MJzj6DIOhgJM3MVC0SaAX0hDxZdMBzyeQ78p5FhY7lk6WMY/aDLVcKfu/N8ZszTGwW32e9
	Xlr1jSmc0f3a1ihSGPjSEabKUgzCw0z4AzcM7MK/+C78weXO3ZbxUKh7+9A90uYWxbdXZb
	qFaMEyV16I1fZknqzUhQLz8Smlh59iE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GedrZ0qo;
	spf=pass (imf12.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791621365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3b7lykj9555dzpik0CL5J8bkR3CCZMYWde74uzni1o=;
	b=GLjIPD/95/5uMfRAy3kmtV10+d90Vt9iTC1iH6vkg4t9JiylgCAcM1sSQF/5JUBMK8dCX1
	VVDh+5WYAhOyjJkluf3XjU2ze1ZtR+HOvwLNzTJLQk7LPhrJGqmKK2Sq6JmZND1ojrcGYd
	L12Vme2UfsOc/u5mikKDklB3193zrFs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/RC+izwEEYy8ZXvE6WOHCJ7ZNBYqaR8RFs6URHqTudY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791621363; v=1; x=1792226163;
 b=GedrZ0qoPV7WD3EYE661u5OPJwvgyiOKYyTTetYQDCIYrEQJAmWjG86J2Ccyn27cx8B/qK+S
 5QZUPWr1POkSxmS5F5xSQWVrZPtWWml34ngb9g2w+Wk5Oc1FzgNpVe1dUho9lSuSYcwDcGQoRP1
 q0S2Wp/1ic5OBfC9uwfokt5w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 765dd94070c37712;
	Sat, 10 Oct 2026 08:36:03 +0000
X-Mizu-Trace-ID: 765dd94070c37712
X-Migadu-Flow: FLOW_OUT
Message-ID: <331b4e40-8d0c-4333-b2b6-b81e4c4b2e17@linux.dev>
Date: Sat, 10 Oct 2026 16:35:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned
 pages
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Yuanhe Shu <xiangzao@linux.alibaba.com>, akpm@linux-foundation.org
Cc: vbabka@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 ziy@nvidia.com, ying.huang@linux.alibaba.com, wangkefeng.wang@huawei.com,
 tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
 <20260928105805.1215770-2-xiangzao@linux.alibaba.com>
 <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 56EF640003
X-Rspam-User: 
X-Stat-Signature: h8pqdo9eopdybg3orsw6rfcimeoif9ks
X-HE-Tag: 1791621365-991194
X-HE-Meta: U2FsdGVkX1/4hOl40kOXxvgEuahFK4ac0RSVCoc+l1INwNeI5T0jcbblYrRtrwKRpIqq7dfL5zuYDZCetr5xW4vSPL+XwVQZI3c3RGuo/SeNhF9jKMRfdSbhZyIeAsUR6lDgSCQhh/qSWhG5uncYFuKkwp6S01JBlnZm7gaEATmBUPia4hPmDwwrmgROuZBrlk0LoP9BrN8GlnN7qODfP2J+vjGBzv+bDGfdCzDLDRtlsXBf1G6yFI371ucv0PMQluV7s6P6l+AtRPsEa3T6rpUIUYiZBMu+dIlSqkRPdpsS+v2IfmQsDQm1DFHTHXnftWpZlxvu/9hm9sP2vjK8uAJvT6TyYHEolAHG6FHoh5A8NWxzDACgd4glzTz6S8+mrMdR+oJUWCXj49vp26L7Ay6LjOWlRlSqz2W9nvJnT6o+IrPTyWHeFhrjbgMI6KRIAAljbyMyy0Cg665aQRXKnf6BDRGH/nhuP5UaT4+0AMsLj2l9Yy+B4nia/GDIqCxLCN254J4MCVnlz6MgSYKMcC+h0QhSgfkvfX1vRxIV1Yj4p7vPZXtFfu2Edn8cZ2iAy70vER37jd3CjiBEU/yRJaht2kZOZeVDX+X+WuTa1FeKJCIXgt0SgO3x8dd3Zata7hkTbNYOwTys/ETZQ53dg2oAee8DCJLffN+4AXehQSz4jHFVWVLCMiqiRqhLV20i3O48IbVSZC5csJCeKm23hTUkWBfDja1Oa34ZAng/yZ6Vd/7QkOEEkE1678ps9ZMmxhTnrfe1Oxt/sTMBRFoCV29K88Kx0QnvHxQUeejn4EXNmcRzeA71FLYwbi6KMW4LPeLFmb5Zu8CgpPlEWZ5eat4nhp9W4pEPqEwP0e1FHbiVQWZTO6NI5kmalu+5TFWetYAmuF8SUx1F/xy8fCrPs8E5GNcTPDJVj3LM28QVRdakaD0IvTCeZVyGLDra+ygQesB/fuy7oYOd32WtPtW
 5JiPJVYB
 Z7zoNYnhSI5TyWoZ/TJCnc5yGgSQuWygerd4A8Y85fkYr1cMXXK4u600nzYVbIl4QDE1XSKVC9bZizEtRh+NTeE12HrjVKBukjhcfUG3CfeEZ7ibpKmZ6NPaM3NggLd+GC6RC7iT38F8Q5uzDEw/XV3TeVr9s03YVAHWce/JBSbY93+JFGEcdb36WP8RMIdDDTOAXnVWNyh91SkDMCpjkgGy7jg15oGa27slTDSgdgu7qswMa8i7WVuWjqyRSgzKn0RIFqZpeOuwx2kY+KKAm+rG1IJ0gV4oJrzOblY6pnBWa3I0Ihf6nPY8jNOUuwRXbQWvgS/XceZ3Vr4wson04G5SyWZq2LX2O8+/l6ZIKsE6APGy4YETdED+RDC2ZeLgvll8jWU0gzZDiNII0BY+A6YT1ntX+pB5GMl6n8LO97Fi/V6o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/28 20:12, David Hildenbrand (Arm) 写道:
> On 9/28/26 12:58, Yuanhe Shu wrote:
>> memory_failure() sets PG_hwpoison on the error page before it manages
>> to pin the folio via get_hwpoison_page().  Compaction running on
>> another CPU can isolate that same folio in the meantime, so
>> HWPoisonHandlable() then fails on !PageLRU(), the retry loop in
>> get_any_page() exhausts itself and memory_failure() gives up with
>> MF_IGNORED - while compaction still has the folio on its
>> migratepages list, flagged PG_hwpoison.
>>
>> Nothing stops compaction from migrating such a folio afterwards.
>> The corrupted data is copied into a fresh folio that carries no
>> poison marker, and no hwpoison PTE entry is installed on the way
>> back: the userspace mapping is silently redirected to the corrupted
>> copy and no SIGBUS is ever delivered.
>>
>> Note that a large folio with a PG_hwpoisoned subpage can also sit on
>> the LRU without any race at all, via the THP-split-failure path of
>> memory_failure() (kill_procs_now() + MF_MSG_UNSPLIT_THP).  Guarding
>> compaction is therefore needed regardless of how the race in
>> memory_failure() itself might be addressed.
>>
>> folio_mc_copy() does not close this hole: it only detects corruption
>> at copy time and only where ARCH_HAS_COPY_MC is implemented (x86_64
>> and PPC64; elsewhere copy_mc_highpage() degrades to a plain copy).
> 
> Then they should implement it.
> 
>> Software-injected poison - what MADV_HWPOISON and the hwpoison-inject
>> interface produce, and what tests and fuzzers exercise - never traps
>> during the copy on any architecture.  
> 
> And these are debug interfaces, why do we care?
> 
>> An isolation-time check avoids
>> the migration entirely, on all architectures and for both real and
>> simulated poison.
> 
> It's racy. See the link below.

Could we recheck PG_hwpoison on the source page after folio_mc_copy()
completes, but before the mapping is transferred, and abort migration
if the flag is set? This would prevent PG_hwpoison from being lost
after migration.

Completely closing the race window by modifying the arch-specific
copy_mc_to_kernel() implementation would presumably also require
corresponding hardware and architectural capabilities, which does
not seem very practical.

>> The check itself is two flag tests on the head page (PG_hwpoison
>> and the folio-level has_hwpoisoned marker), not a walk over
>> subpages.
>>
>> Neither page reclaim nor memory hotplug lets such a folio be
>> copied into a fresh one: reclaim unmaps the poisoned order-0 page,
>> and skips the hwpoisoned large folios it cannot safely unmap, in
>> shrink_folio_list()
>> commit 1b0449544c64 ("mm/vmscan: don't try to reclaim hwpoison folio")
>> commit 9f1e8cd0b7c4 ("mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list")
>> while memory hotplug refuses to migrate them in do_migrate_range()
>> commit 5f5ee52d4f58 ("mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper").
>> Skip them in compaction as well, for the same reason reclaim settled
>> on skipping: the UCE is rare and a race with compaction is rarer
>> still, so skipping is enough, and a later memory_failure() will
>> handle the folio if the UCE is triggered again - while a migrated
>> folio would silently propagate the corruption instead.
>>
>> Deterministic validation on v7.3-rc4-75-g62f4c998b297: order-4
>> mTHP folios were brought into the stable "large, on LRU,
>> PG_hwpoisoned subpage" state by pinning a sibling subpage with
>> vmsplice and injecting MADV_HWPOISON on another subpage, which
>> makes memory_failure() take the THP-split-failure path; after
>> triggering compaction, /proc/kpageflags shows which poisoned
>> folios moved.  The unpatched kernel migrated 16/16 poisoned
>> folios and 16/16 clean controls in the same pageblocks; with
>> this patch, 0/16 poisoned folios were migrated while their
>> controls still migrated 16/16.
> 
> 
> Was any of this written by an LLM?
> 
>>
>> Soft offline is not affected: it only sets the poison marker after
>> its own migration has succeeded.
>>
>> Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
>> ---
>>  mm/compaction.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index a049415512c6..491adcbc5313 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -1093,6 +1093,14 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>>  		if (unlikely(!folio))
>>  			goto isolate_fail;
>>  
>> +		/*
>> +		 * Migrating would copy the corrupted data into a fresh
>> +		 * folio with no poison marker; skip, as memory hotplug
>> +		 * refuses to migrate such folios for the same reason.
>> +		 */
>> +		if (folio_contain_hwpoisoned_page(folio))
>> +			goto isolate_fail_put;
>> +
>>  		/*
>>  		 * Migration will fail if an anonymous page is pinned in memory,
>>  		 * so avoid taking lru_lock and isolating it unnecessarily in an
> 
> See
> 
> https://lore.kernel.org/linux-mm/20260707090136.52904-1-kaitao.cheng@linux.dev/
> 

-- 
Thanks
Kaitao Cheng


