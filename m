Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 136F7CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1176B0098; Mon, 28 Sep 2026 08:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8F06B0099; Mon, 28 Sep 2026 08:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BFC46B009D; Mon, 28 Sep 2026 08:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D79356B0098
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:12:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 703A5A4544
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:12:54 +0000 (UTC)
X-FDA: 85263059868.12.C73A8C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A028BC0008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:12:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EM2ykc2s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbUJiBdpcS0GzzmqNyFIkdeNdQt2pSr1lbMMC4G4AE4=;
	b=buI0pVw9oot7rkC+G/o6xQq4j9p592DmQIkhLfzDOHK4Dmf5RwQImAHOtyCpzZuduPkviN
	9vMYsdBihhZaeUxfFjjWO7XgvllOv98iveJ1Lg6qTVRhtdz5L0y7aypTSJ37wxwNTpfP7e
	112CRuz11r6AATZ5PdfL7c7ErmwTYC0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EM2ykc2s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597572;
	b=nKARkxwLeLNfeBf5bxOuEBvxD9yioI1/SrzBK8m1SsrSIATfpu7V0t5vvZaYlR0iqKTKce
	dHMdz6/0hPutvvC+26JbhuhfpEeEuYcvdZ2cY3eCq1rWYCtt3me4IaroUEF9oz2TdM9G+8
	KP7QGsSR+03MwXkFRVl8w9vNM/Ye1p0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFB6443A3B;
	Mon, 28 Sep 2026 12:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03C81F000FF;
	Mon, 28 Sep 2026 12:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790597571;
	bh=NbUJiBdpcS0GzzmqNyFIkdeNdQt2pSr1lbMMC4G4AE4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EM2ykc2sM19KUh3ECVkSBtjYmF1T/YD422txRparDWpIGchUyfu0bytpEKHETTBr5
	 yUYEcTH1X3HLe+PqbcVI/+dICbEoRpmgiPWApitwbfuBy5hXFbYulC0VAXVJIy1Yi4
	 ChJaV9rq33xfDxawCarfPUAEmeYUekEgN2kvUBjhOm4lQF0f6p+BAl0Q+WLbNdbNf/
	 JPqIKWyFFZDCtb9qgI6o5h0tLF8FEKyLWtRMAlFanVX0Bg2OS0WWwL4vjgbJ4uB8as
	 Zl/isFqpW7Z6FL3tOqgju/5R6d752QxK/jZ8kZhxr0mo1AhZumzVGMPIK1dU/M/UpW
	 KIsD3dKSupsVg==
Message-ID: <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
Date: Mon, 28 Sep 2026 14:12:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned
 pages
To: Yuanhe Shu <xiangzao@linux.alibaba.com>, akpm@linux-foundation.org
Cc: vbabka@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 ziy@nvidia.com, ying.huang@linux.alibaba.com, wangkefeng.wang@huawei.com,
 tujinjiang@huawei.com, mgorman@techsingularity.net, kaitao.cheng@linux.dev,
 chengkaitao@kylinos.cn, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
 <20260928105805.1215770-2-xiangzao@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260928105805.1215770-2-xiangzao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6h1jcdikkocxtkqhfwn9b7myzkhbucz6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A028BC0008
X-HE-Tag: 1790597572-415546
X-HE-Meta: U2FsdGVkX18wJIyKiN6WnGo7y8OgfPhlmgLlX3KHNM1GYyISwv9s6PP3ABU8muDUM94go3NCPfl4/elrOeivpr0TEkmJs6T4YPC0xoW9+2pZCwrz5GI5c0sm9/HSRRo7M72LVSKz8tV5btE3wGtDqACQEWebdGzZayCWxt48U0zoEeNyW0VejL6phtEgjH4SL96iBYjjVZQXol8XDrgeJ3x+oHYpWjg2tvhcdGEWtu9eFfk6MIQXtrrQFfP5kKHHcLlRDyQRRgiVR5tGAPc/eDw5SMBgD1Yby9Hp8INnc9e2FrEojhtBfI7kXnyhUisWLgBQ+nZHQ1RYUyjSCADPd1dge+qFLo2lTXor0cxACS6Nit4VdJZm7VU/sZYKY1QZ2acGwUT2Fd2wSFVUuDz+XGRzbTEwOaZYiX1kJ077iWn6uyZKUMc37gUBFaV/x30JGFME6bjezmwpaYR2OBeZQt52xVnrQFtK0JBUR6m5nYavXLTwcsNQtdehRrMKiQzbIuWN2QjaMR5U9uYZlTvzyVxVAIUXGxVjMkZPVMCd1vzvEHdhIAcHSVAXbkA0miJGSmaYpXrOZIvAA/Ou9KUbHq0TXZxrLCVeRxeAEZVViEwrFETR0rUYqcbPZBJMAUD3eOjSf7B6nJiMlSuwrq856FQLx2qd9XIILU/tGtcMPLUuVN9sL1YBSbuAOymuRl1LxHbxQhnvhpZfVcbFdLPrWSL1YPXNunNwgY85iZ8ia7bmaUEaDPkkRaliA2VM5GEpl+L1b7ARFKrz7GP4ayNCAZ0FCMVR+44HquzAhF7ohQ2L+YBbmM+MAb/pIYqY9WFr8kaDbDemQ4NTaZKaDqoo1IG+hSLrAzqnVgq7WKNdfO+CXTLg6hhLZIwMt5p1ov4qUFrhSPrCh7C6/xU9gy8W450kREFFdcJrE7HmVluM77td2dgmTZYrS9dghEam1aEAN+yvfF4gn269xn6YmD5
 fHKxbh2U
 bkJ0Ej3d7lo+3rq3nPukqpj29ae3+O99VKRMJWQ7HyHdAcrofv0bfaYzd8+aHq5E9uF4H2RnUIptnbQ4fkaCQtqRfye/lg48kt8Un6e4HkMvwKc5QTi7VX/PnlEo/58OXzTFEe4D1DJJUzOo2jAdtzH2W/FsvO2oOG0OdjwpaCX5wSG2Jua2szMQ49j+I8SzVQ1f/OlipQiJi2iB5VXKqKDP2dca9qfqfLkmR1+EePqy465dubuY7M8K27mZR1R32QY3ILQrniQRl/yGQAfvvEqUOq/ro0szaQvZM+U2hcxqcYq7CnZHXsXwoqXzmYarYnsjivetyBWrLMdFVgVG4FWXrHyD/xD3fhdvyKTYA2NfvrVBZpbTHkFc+ASRWtwRVYwdf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 12:58, Yuanhe Shu wrote:
> memory_failure() sets PG_hwpoison on the error page before it manages
> to pin the folio via get_hwpoison_page().  Compaction running on
> another CPU can isolate that same folio in the meantime, so
> HWPoisonHandlable() then fails on !PageLRU(), the retry loop in
> get_any_page() exhausts itself and memory_failure() gives up with
> MF_IGNORED - while compaction still has the folio on its
> migratepages list, flagged PG_hwpoison.
> 
> Nothing stops compaction from migrating such a folio afterwards.
> The corrupted data is copied into a fresh folio that carries no
> poison marker, and no hwpoison PTE entry is installed on the way
> back: the userspace mapping is silently redirected to the corrupted
> copy and no SIGBUS is ever delivered.
> 
> Note that a large folio with a PG_hwpoisoned subpage can also sit on
> the LRU without any race at all, via the THP-split-failure path of
> memory_failure() (kill_procs_now() + MF_MSG_UNSPLIT_THP).  Guarding
> compaction is therefore needed regardless of how the race in
> memory_failure() itself might be addressed.
> 
> folio_mc_copy() does not close this hole: it only detects corruption
> at copy time and only where ARCH_HAS_COPY_MC is implemented (x86_64
> and PPC64; elsewhere copy_mc_highpage() degrades to a plain copy).

Then they should implement it.

> Software-injected poison - what MADV_HWPOISON and the hwpoison-inject
> interface produce, and what tests and fuzzers exercise - never traps
> during the copy on any architecture.  

And these are debug interfaces, why do we care?

> An isolation-time check avoids
> the migration entirely, on all architectures and for both real and
> simulated poison.

It's racy. See the link below.

> The check itself is two flag tests on the head page (PG_hwpoison
> and the folio-level has_hwpoisoned marker), not a walk over
> subpages.
> 
> Neither page reclaim nor memory hotplug lets such a folio be
> copied into a fresh one: reclaim unmaps the poisoned order-0 page,
> and skips the hwpoisoned large folios it cannot safely unmap, in
> shrink_folio_list()
> commit 1b0449544c64 ("mm/vmscan: don't try to reclaim hwpoison folio")
> commit 9f1e8cd0b7c4 ("mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list")
> while memory hotplug refuses to migrate them in do_migrate_range()
> commit 5f5ee52d4f58 ("mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper").
> Skip them in compaction as well, for the same reason reclaim settled
> on skipping: the UCE is rare and a race with compaction is rarer
> still, so skipping is enough, and a later memory_failure() will
> handle the folio if the UCE is triggered again - while a migrated
> folio would silently propagate the corruption instead.
> 
> Deterministic validation on v7.3-rc4-75-g62f4c998b297: order-4
> mTHP folios were brought into the stable "large, on LRU,
> PG_hwpoisoned subpage" state by pinning a sibling subpage with
> vmsplice and injecting MADV_HWPOISON on another subpage, which
> makes memory_failure() take the THP-split-failure path; after
> triggering compaction, /proc/kpageflags shows which poisoned
> folios moved.  The unpatched kernel migrated 16/16 poisoned
> folios and 16/16 clean controls in the same pageblocks; with
> this patch, 0/16 poisoned folios were migrated while their
> controls still migrated 16/16.


Was any of this written by an LLM?

> 
> Soft offline is not affected: it only sets the poison marker after
> its own migration has succeeded.
> 
> Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
> ---
>  mm/compaction.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index a049415512c6..491adcbc5313 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1093,6 +1093,14 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  		if (unlikely(!folio))
>  			goto isolate_fail;
>  
> +		/*
> +		 * Migrating would copy the corrupted data into a fresh
> +		 * folio with no poison marker; skip, as memory hotplug
> +		 * refuses to migrate such folios for the same reason.
> +		 */
> +		if (folio_contain_hwpoisoned_page(folio))
> +			goto isolate_fail_put;
> +
>  		/*
>  		 * Migration will fail if an anonymous page is pinned in memory,
>  		 * so avoid taking lru_lock and isolating it unnecessarily in an

See

https://lore.kernel.org/linux-mm/20260707090136.52904-1-kaitao.cheng@linux.dev/

-- 
Cheers,

David

