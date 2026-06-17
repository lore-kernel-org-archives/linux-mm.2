Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD0DCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 08:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19B166B0005; Wed, 17 Jun 2026 04:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D036B0088; Wed, 17 Jun 2026 04:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061C16B008A; Wed, 17 Jun 2026 04:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3ADE6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:53:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62D861401F0
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:53:03 +0000 (UTC)
X-FDA: 84888789846.14.BB59BB8
Received: from mail-m2493.xmail.ntesmail.com (mail-m2493.xmail.ntesmail.com [45.195.24.93])
	by imf23.hostedemail.com (Postfix) with ESMTP id 29522140003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:52:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf23.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.93 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781686381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cVIOAXMwEqT3z2kZkNd/8ZkIcTKoDXKr+pLVqTdg6U8=;
	b=H2RHtVDMzfmN5XHkih72XvwwiJVk4HRWolkvLNcbb6eUaUp12yTceVq/FhpijTuxyJ/ruU
	qteLZDD1Eu2f8m7Z3umCtUqhXEJwudK5if0XQ6o7UpK1KJXQGHw+lVci/Np6YTzYDx5juj
	fsB0HSoAIWjs5UVxd1adWGDPFYBu7zo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf23.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.93 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781686381;
	b=J7RKKnZwDuJQg08KCQ7Ywu4vCh/nDM/j23Q3lo+xTGx1K5SsPUJliSIbaO6ip5OWxtJz06
	GiqXSZMHLGM+sGQ4B+pB4jywHZZ2v33uLL006eSQmfRpCTMEooqRib0sak4p2djHvx6zwc
	XhaM32zZSIUrnz7nzSI6AgQkiMvzYFk=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1b8eaee8a;
	Wed, 17 Jun 2026 16:52:53 +0800 (GMT+08:00)
Message-ID: <5ef656db-c6b6-4a2c-b6be-628e5214952f@easystack.cn>
Date: Wed, 17 Jun 2026 16:52:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260525081652.2210206-1-zhen.ni@easystack.cn>
 <20260525125819.1857f215bc56b26a0727bedc@linux-foundation.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260525125819.1857f215bc56b26a0727bedc@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ed4c88a4a0229kunm6cbe07ca9d54e
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCQkIfVkgaQkpNTx1CT04YGVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Queue-Id: 29522140003
X-Stat-Signature: 8wr1zt9qak474xnpefdbpof6xsygfqio
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781686379-698253
X-HE-Meta: U2FsdGVkX185UnPXlnf2IgIHV/fybN/h+DwEL160cbgt2zs28Nr2hPwNjYYCM3TfyUNrXb/J78FaP2yyfkgi9FtR4rh4sVoTnwZoKqVrQNTEzkEIIaK+7eZJUpFveoIno6r2LoEyTWMP/+wTByJEaN042QfOMvdH00QJ2oMKSzL+Ng8dnAgR1TI69S9oxF47lNNP9GX6E5eYrbc7q+lbQ93xB+dFYGEkmp0ajFvYd7A3i+htl34Xknr1HuERni07CfsxyGJeUZ+ZwNs2/2DCZUGdR8wKAZVik38rR76dLY3/bqvEYOClVdf9STuHUDp4wCDBFRtDS5+JhE+y6l+ue7zdIeKnDYesjG5WvUAlVShCntKzkJ6JUiGYxO4GuqIUvRLvbkFr9+nFLEFmRRoIIES5JYQfEvCIogLMKbvJGxpeZ16+22FTZudM3stbbE92NOwg3Xq5t3JztP7dWRBoXrTZFcY0FxLPgElrd7I1hMk/Rqx04RehcadNRY8tXKTMwbDij68zJMeOZmS3iyhGlX2ugG//3U3NfnnE0pu5KG699tQWgrwKmMDjcptu4IBxGdfNbbFq8sCMuZnznZ/Pli0s1MWdOL3uH2yfGyXq4wio7lOOIQcfUYNpaSxdEGPolHAas+mKFygOcuEcONOfl0uh89zpcOLZFD2Hi1uuC0JVyT8n7qJbSDuAfMM9kDVdUzaFCN4dxZ75nPOs6E+smZiZ4xh7FyQv0DlIEl89ZGm3DYnF8ZFF17ULSxFARAUGBJeGAcBJOxKoj2owo6ctvJjOS9FsUACa3Me05KBJMCpLZv9my3jk7leOM25lQHKL4+xTuA7qiuyhPhIyQ/UI+KgZiQ1KTxuis2hUk1uhrhmFhJVO5A8XMOVtXEB/P7tuWWRyL/P0i/G+T6wSyu5mn42VVm9Vaj0xMIUgZFwJZyt7mCqlXtmuqrxTOPvt6eqUpxuKSsR5x8Qizm3lXuY
 1SyMZJuf
 qIeg1JvTXBu6csQBvMBp6Mci8Mr7ESjrwGcFGkmLuTPhPLOncwIgbdaxn/AI6kbkyKvneTHBburoorLLblawOYxRT46C6V0oWbSDGlKAEKgdnkSUnz4a/ASTDE/I8wLOiVqgBlP421K3HltAocCeUT7Erj4NZlMNK50rFqv53WPxBuwarZtBrfDadNEQQhVr+pqEuEVHo22H0GMXL60kG/kBMRMm9b60wlhFgknRGjOHYWU+mF/4DnjucWawbCKmLqkLpqKMTSztd0eUL3Q7+BSJcvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/26 03:58, Andrew Morton 写道:
> On Mon, 25 May 2026 16:16:48 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> This patch series introduces per-file-descriptor filtering capabilities to the
>> page_owner feature.
> 
> Thanks again.  AI review has found a bunch of new things to get worried
> about:
> 	https://sashiko.dev/#/patchset/20260525081652.2210206-1-zhen.ni@easystack.cn
> 
> 
Hi,

Can this lead to an out-of-bounds memory read?

The NUMA filter in page_owner (mm/page_owner.c:790-798) bypasses
PF_POISONED_CHECK() to avoid triggering VM_BUG_ON during concurrent page
allocation/free:

     int page_nid = memdesc_nid(page->flags);

When NODE_NOT_IN_PAGE_FLAGS is defined, memdesc_nid() performs unchecked
array access:

     int memdesc_nid(memdesc_flags_t mdf)
     {
         return section_to_node_table[memdesc_section(mdf)];
     }

If page->flags is poisoned, memdesc_section() can return a garbage
section_nr that causes out-of-bounds access.

## Lockless Access Safety Principle

The page_owner iterator runs without locks, meaning pages can be 
allocated or freed concurrently. The fundamental design principle should be:

"It's acceptable to skip a small number of abnormal pages, but panics 
must be prevented."

In lockless iteration, TOCTOU is unavoidable - even with reference
counting or RCU, page->flags can still be modified concurrently during
access. Zone locks prevent this but are prohibitively expensive.

## Proposed Solution: Add nid to struct page_owner

Record nid at allocation time when page state is stable, eliminating the
need to extract it from page->flags during iteration:

### 1. Modify struct page_owner

     struct page_owner {
         unsigned short order;
         short last_migrate_reason;
         ...
         pid_t tgid;
         pid_t free_pid;
         pid_t free_tgid;
         int nid;  // NEW
     };

### 2. Record nid during allocation

     static inline void __update_page_owner_handle(struct page *page, ...)
     {
         int nid = page_to_nid(page);  // Safe in allocation context

         for_each_page_ext(page, 1 << order, page_ext, iter) {
             page_owner = get_page_owner(page_ext);
             page_owner->nid = nid;
             // ... other fields ...
         }
     }

### 3. Use saved nid in NUMA filter

     if (state->nid_filter_enabled) {
         int page_nid = page_owner->nid;  // Direct read, safe

         if (!node_isset(page_nid, state->nid_filter)) {
             spin_unlock_irqrestore(&state->lock, flags);
             goto ext_put_continue;
         }
     }

### 4. Update nid on page migration

     // In split_page_owner() when page migrates
     page_owner->nid = page_to_nid(&newfolio->page);


The remaining two issues can also be improved. If there are no 
additional comments, I will proceed with sending v10.


Thanks,
Zhen

