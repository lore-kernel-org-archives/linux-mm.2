Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A5FC624CE
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 01:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0D16B008C; Mon, 31 Aug 2026 21:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81FB6B0092; Mon, 31 Aug 2026 21:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98016B0095; Mon, 31 Aug 2026 21:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A82B76B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:38:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC3C6140331
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:38:40 +0000 (UTC)
X-FDA: 85163484000.10.9F05713
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1F1A920002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:38:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nm8vlbs+;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788226719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ycy4OKk1KlIEFG7HzpEc7ZUQeBgOA/LNvRw8vb5tr30=;
	b=ezl7Mz1E8Vp0rUKDCj3aRx/C9w7MoRkb+4CrB5vy4PJIkrYiGwskjlEoEkVdLDY1+MwYCP
	HHesUBGQVQlYSSMW1QH0nI1kacBc+RalPJC9x7ax5o2Zqp+wa+GUO2nlWdcEiKnNeL0thL
	wMR3/nVXBKVwRPP3w46uRpamIuQjxYI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nm8vlbs+;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788226719;
	b=R3FGxl8itK+myc0dfQCzcZdUxt6hk2jekxJIZFJ9ZZLigFRiPcePxGSQDXglN315bh9PnW
	Aue2pJA77rdqr3eRjTJuMoD3SuVJorX1+eX+2q9mT9tr2DOE0gmnYKSkU8Vsb2ArFaKO9+
	OVgiJDkMDhCOP7eYwYz5hlX/SZrDtfM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788226714; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Ycy4OKk1KlIEFG7HzpEc7ZUQeBgOA/LNvRw8vb5tr30=;
	b=nm8vlbs+hRscix7wzIKxnAyL2gp1Wyy5cppuySE0joun2JM69lHJOnEDzPEAWEiOaZN22Cf1qnRKepbVyWyZFVYge2HFQcaAI+q9/bXP8ezEJm6jMvLDQssNnYpk3Xya/FKxQoexb7dXYdV0fHYSgeEWJzn5JaQp9a4JZg7CI1c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XA0icNh_1788226712;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XA0icNh_1788226712 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 09:38:32 +0800
Message-ID: <4b5a8f77-a5c8-4751-b60d-0c748460167b@linux.alibaba.com>
Date: Tue, 1 Sep 2026 09:38:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory: do not touch frozen folios in
 deferred_split_isolate()
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, hannes@cmpxchg.org, usama.arif@linux.dev
Cc: lance.yang@linux.dev, ziy@nvidia.com, kasong@tencent.com,
 hughd@google.com, baohua@kernel.org, liam@infradead.org,
 nico.pache@linux.dev, dev.jain@arm.com, ryan.roberts@arm.com,
 balbirs@nvidia.com, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260831091514.1879786-1-kirill@shutemov.name>
 <20260831091514.1879786-2-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260831091514.1879786-2-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3fns6p88831knjhu5t36sqq5soggnzsy
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1F1A920002
X-Rspam-User: 
X-HE-Tag: 1788226716-625062
X-HE-Meta: U2FsdGVkX1+G9DiywZ3aPUths8MvhRI/QMfX2l0y0a8k6e5VzpTvbx7rgvDYkP85FLDvhLw02rUlBn1R6j4ZpKsImzr5jrgRRAif1uWqFgSnkIkLVQQ8MpGnhtdFLN8NYu9kNvQJc8ai5a+f5Rh11mU2mdF2kTGFzn4+P7ubyMaLZEfZ7zw7w9xXjmDh60KDmfKUy4NiclucKfy6jHPcfDpLbdo7y6fEz6SgYPN0qf/3/i2B7GMf9bn/Dc7cajEub0Dw+Kb9B8FY/1GZIDYQklQSxVGzsrObzAPcZ5W3IiRy3NX7U9Tp56EwHFDbh9ZWsqxnmsLBCZDX6MMtUHW42k+ULEsJ89X1fgvROe91MvG/I6YHnXs7naCIFykQ6B0+dTjw9afMIqhCLsMb7+UMKXZ0fb4giMksgnnJV/nA3oKCnbwdfWHQNXmasDBFkLr3AM1jL87iM78/xL/agI9+UyO4IdMhI1JkI/lWpcosa6NyDyjOrlGJHz8UcWaEO/rCi82tCvmNamiIosjePl55eWqFlSQpkD43utjh2tVByWU/bKuPvuflp/acUeVKFPB1mdmTuiXauL0PwIS2qhnAxSFTbXZUEqR7X/4xKG9o5azWBcAbbmoOSTcroxmhOD4wcJmhu11u//LejejElm0t1Cfg7WY3sDI+HA1WvMHM89nZSYIBkjZgZOeA0IUECNCTSRcZzU5cMWKLZnXO/QliztAfUJUnsO/iVWcJEAz/yTIoY2yFAFVO9S3BJ8XLM+gpd7F4NUZKlshyVs9JaSTGilN4aprEjbz7QAkbNYstNNY7smXSDE3uSwo+/BfJHohk/k+JJ2d7LblcgPwWqhVZOWIaORtYVJDp4OvaraUl2br+a+vZ/sbxJjpHNZQ2Vc/h/QLhjEIVuv2V6c6gU+nSNpqL9ihqtzQo/OKCwZcqf3gAMdUgDUMDRr9QDBk1Y29u9wmHKbQHr7MEq10gQxE
 QPjDhU5h
 gxKzeGNmDGoD6BeNnpMq1knTuABNkq6AyfIS7A3vw2v8MmzShqdSDanG+OWQcKOt878UxrInjmfC0QDtHomvgDrox1mo/vv82mVQ1IoH3296875fcOgcpJxU9b/b+3MyGDdwlnqOHZvEiyYfgo5GGroROlOKPSFEHkfXyOBJMIIa/1IPQhafdF1rKn2R/MsxzCYCkrTkU+EetE99mcB/T6Uf/A7HK87eP+f0/9ml1YyV8fqCEMFffDMNuM3+D+ycnoSl3A8Jkqco5gw5bsANiecY422Ug0+6gAhczWom70lqk/roZ9GIKZcQfd4fnS/IVFJNp0f8EBY8TZ3DbgLbfsh0DwJtM41gCIRabOPE3jH/C8+MfgsvFsU4KVZMmzJYtGZTmXcnSzTh6NaLiy9k9+f08Z2zzI+cGO4Fx8hF4C5PgNAcqMa8NoBMqF7NZ9gjLaokEvnbXUTRwKck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/31/26 5:15 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> deferred_split_isolate() probes each queued folio with folio_try_get().
> folio_try_get() failure is treated as a lost race with folio_put(): clear
> PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take
> the folio off the queue.
> 
> The folio_put() race is the most common case for !folio_try_get(), but
> it is not the only option. Another scenario is folio_ref_freeze().
> 
> A zero refcount in such cases does not mean the folio is going away.  It
> means "don't touch me" and current deferred_split_isolate() doesn't
> respect it. It can lead to unqueueing folios from the deferred list for
> no reason:
> 
>      CPU 0                            CPU 1
>      ---------------------------      ------------------------------
>      freeze a mapped folio            deferred_split_scan()
>        folio_ref_freeze()               folio_try_get() fails
>                                         folio_clear_partially_mapped()
>                                         NR_ANON_PARTIALLY_MAPPED--
>                                         folio off the queue
>      give up, put it back
>        folio_ref_unfreeze()
> 
> The folio is still partially mapped, but it is no longer a split candidate.
> Nothing queues it again until part of it is unmapped once more.
> 
> Skip the folio instead: whoever freezes the folio, owns it and owner is
> responsible for its fate. It also covers the folio_put() case:
> __folio_put() unqueues the folio via folio_unqueue_deferred_split().
> 
> Nothing is lost by skipping.  Everything that frees a queued folio
> unqueues it first, and folio_unqueue_deferred_split() clears
> PG_partially_mapped and brings MTHP_STAT_NR_ANON_PARTIALLY_MAPPED down
> on the way:
> 
>      __folio_put(), folios_put_refs()   mm/folio.c
>      __folio_migrate_mapping()          mm/migrate.c
>      shrink_folio_list()                mm/vmscan.c
> 
> __folio_freeze_and_split_unmapped() does the same by hand, under the
> list_lru lock it holds across the freeze.  A freeze that ends in
> folio_ref_unfreeze() leaves a folio that is still partially mapped and
> still belongs on the queue.
> 
> Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Closes: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

