Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E31C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABD9C6B008C; Wed,  9 Sep 2026 09:24:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6DE36B0093; Wed,  9 Sep 2026 09:24:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938056B0095; Wed,  9 Sep 2026 09:24:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACFD6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:24:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF0A014011C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:24:35 +0000 (UTC)
X-FDA: 85194293310.25.5DEF694
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1E1F0160013
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:24:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CmQNemKi;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960274;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kW02xwwfobHDqKYd5wNAbqTLVNekBz/ryWW+HAKscjY=;
	b=r7xwxXJ9eqwkaPWcCSlE55sK3f4lXR11h8/i15xpfc4a+MhOhYK4WfPFhq39mrSp/cQlm+
	h7QXBKHmaaDdPIw1W57Hrg/Tk+3AqbTkpT3UFG259AISyrRJzagUavfZuBJ7Lv3Mx75fGg
	FKldvAZI+ZTGv7cs/OK9gLSc0W7qKzY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CmQNemKi;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960274;
	b=QxOXS0Qidprq+UEHEj3qCxzsPXDSrAZiZHl0G42cbdmiuNm+pyEMdCB5duCc+mn+4xUdAk
	PUn8sJ8VOqEnbhccnXvdsO82iq5lO+Qfu4DM8Nc9QKDBJjAcZwn00GBZaXK6WOx5ci2ehx
	Eyq9X+X9NrWhj5OJ/epUrHzSZlhVTSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D15060218;
	Wed,  9 Sep 2026 13:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB011F00AC4;
	Wed,  9 Sep 2026 13:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960273;
	bh=kW02xwwfobHDqKYd5wNAbqTLVNekBz/ryWW+HAKscjY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CmQNemKiITSt5nne5crT7mydGU7xhK9xTOk7q+T6HnPql9JlKKWyL5CvBtlHWJrAx
	 aVS7QTXQoqMOPGt1mRzZAhLwsC7jVG0puSWSK75HdmvNeXVQFDxXRCUGhZZM1I+Ppf
	 Z2tY2gTsyt05FwizpIgaJk9SkISj64mPMHO8LpSI1u6pkxo44CK1P1G9JynYiLTR3j
	 WbPPu/+qE6afFvaL1BWw5Px6eEhxh9oeOp2ALXeFcbVc3BuedKvqb3rAJ+FfsQmtRy
	 65kAdWnDh0YY640IIVbu179iMcNccfiv3R8yJjdGWO4OZ4JncR+2+pMLBbnnAnxoqY
	 /MGQH+zjBIqVw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 5/5] mm/memory-failure: keep inherited poisoned
 frames out of the buddy allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Liam R. Howlett" <liam@infradead.org>, "Michal Hocko" <mhocko@suse.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, kas@kernel.org, "David Hildenbrand" <david@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Thomas Gleixner" <tglx@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Zi Yan" <ziy@nvidia.com>, "Breno
 Leitao" <leitao@debian.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, "Mike Rapoport" <rppt@kernel.org>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Suren Baghdasaryan" <surenb@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, x86@kernel.org, "Ard
 Biesheuvel" <ardb@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Borislav
 Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: riel@surriel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, rmikey@meta.com, harry@kernel.org, kernel-team@meta.com, kexec@lists.infradead.org
In-Reply-To: <20260909-hwpoison-kho-v4-5-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-5-359313564495@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 13:24:31 +0000
Message-Id: <20260909132431.7CB011F00AC4@smtp.kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E1F0160013
X-Stat-Signature: deck5dmhhf9y8pcmycmha7gks4aswz4d
X-Rspam-User: 
X-HE-Tag: 1788960273-982871
X-HE-Meta: U2FsdGVkX19dln0eo6lQFFUfZQPQA9795W9Uiz7guURnne2HKV8a/TLbMbUU9wTCcFfNJwnYBUKmEbNUAL4K+McZhPc+S3kGT3lRocQIAbkybs6NTsVU3aOMLnOKYkAQhJabx/mqxlK+B0/9rALay4t0cYsNAUumPKgRxZ6mcczNdUz6r5IcxPLIq+BceiB/OP9Rm4UGDJs0qtwL9DIQ1VKAgMGrRMM5owYzZvdRo5uVYSvFKW1fkq1iDTPvKXRWEdrNVYiaRlB63qy9GA8P+r3P7zDAjTGOuDIqStjOjNuQetXa4XTdGDVEqZEMB+LKHjd+QP3uoYGnc1FAA02VVNjmqI07sWPGADv05yBktViYs1VCPzK6rlNKVYKdyml2X7wJf07ZV6u+/VP9ce5DQfpaAL/wZVCZJqDlUNLknvLejjyjPQyC3fb1bO+t3owttMTTqEt+cOjXfjQ5pclI7XvPDP5Tb+PSIFOdZ0PROzTIRskJihCmW19o+DKjivRb65a0nynRVueJSA4sBQZ1vZJG62Cae+zzFI8Cqu5hjgvwU7ylxentUurdis5ewOty75zW1dhqLDdahJPcFc1vMJXyYsVphLc035AgoLSeZSKjZRxpxwWKhzoe6EGAoZlTRctcefq7FkxEQ1ns9VaO1epDDkJHjGgLALHnMuHP6d8vxW+plU7rEkowzho5DV1HP0evMUZgYwxKor9ebb/FkanMvxkFRZK5wyq3jUOsHFXb9tv6lVXwiwLL+qlG7j44Acta2p575UqbDJC/iFr3S5tS4LERYO9n1Ua2EG2hY5CDynahpHNckWDD3aVg/tcy/vowRUtbJjL+myIjAonuc6n/At3lcd8EbAYluiRjcuQnVx0p2/N/GveO+qA6seSi50s9h4/kt806HLtzH9/3Hh6KKaGt5ILjC42sDVW4zvzBu4nnPWID2G5Mz0Sb5cM52MMHS3nosW5ncywOfew
 7vPavkuy
 Qp2RK0kOmjGqIZQh7q88W0OgvhhZIs2XfSI3McvN7lgdT+pv21YkJGOCvYHZYf6mp8rz8qS+cV7mRbXrnC5FolZnWM5KheJOuirqDeaRWuhdU8v/DVZGDoOPLjTUKlN/pQlYt0RJFCHXCpW+01hGCsYVG7i/U6WAMQFrkfCB4Z13DjQ3zjtFelca77Eu+MguednvgqmrP96FC4l218QZHChVVqRkJVL1d2jfnWeOpB6PTmbUac8oLqPtdezpHRnJ5JvtKCcZe8PfGb/2xxOBDLEtJtz9i9/FxvkydEUBBs/NhVHVgJbABwlQ3NdwJ9PaPzhGHx9LRnmrvnc1QHZ5nMogyju1+L7Oq1X8chnxdjGe4a0RCDav8KO++7c9P2qNhEfsBx39G34sEZu6qYR82hlsC7rn+A0EFkMMMs6qa5Q/1YO4hurwROUqDRYBlGKm3QsZgrgKONBDUq4/0H4d7ySr9PA5gFPR+5yr+Rx2dcyuku+hfcPDwApLFcen1F03cPBaqFuoB8YDQjrMtffX9Bx3HELTshLUCLiI6F5r8Q62iyCZYWA6ASOFxzuSXvHGdFb6J8siRfgU7tUpa2Zhd3nAEKc9tGZXdhgbJf6ShZXj8/AFSM+wUPXLxcfWJbqAavP53QPIYZNFmpajDP/Cb7txi/FqVkldTOPVP1b5d7BYJ3jU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Healthy pages within a memory block containing a poisoned page are=
 completely leaked, preventing memory offlining.
- [Medium] Concurrent non-atomic updates to per-node memory failure statist=
ics (mf_stats) cause lost updates and corrupted counters.
- [Medium] Memory block poison accounting is skipped during memory hotplug,=
 breaking block-level poison tracking and causing global counter leaks.
- [Medium] Boot-poisoned pages lack the MAGIC_HWPOISON marker, breaking unp=
oison_memory() logic and causing a memory leak on unpoison.
- [Medium] TOCTOU race when setting the HWPoison flag during memory hotplug=
, potentially causing double accounting of memory failure stats.
--

commit 804f678a0cc93ac88d9e22aff45a011384c3ac87
Author: Breno Leitao <leitao@debian.org>

mm/memory-failure: keep inherited poisoned frames out of the buddy allocator

This commit checks if pages being given to the allocator are poisoned and m=
arks
them accordingly. It hooks into __free_pages_core() so poisoned frames never
enter the buddy allocator. A new function hwpoison_boot_page() is used to s=
et
the appropriate state for these pages.

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index d9b8be696aac3..f6afdb2a89a94 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c

[ ... ]

> +static void update_per_node_mf_stats(unsigned long pfn, enum mf_result r=
esult);
> +
> +/* Not num_poisoned_pages_inc(): its per block half divides by zero this=
 early. */
> +void __meminit hwpoison_boot_page(struct page *page)
> +{
> +	if (PageHWPoison(page))
> +		return;
> +
> +	SetPageHWPoison(page);

[Severity: Medium]
Could a concurrent hardware MCE race with hwpoison_boot_page() here? During
memory hotplug, this path checks PageHWPoison(page) and then non-atomically
calls SetPageHWPoison(page). This might lead to both paths setting the flag
and double accounting in both global and per-node memory failure statistics.

> +	set_page_count(page, 1);
> +	/* The page has been completely isolated =3D=3D MF_RECOVERED */

[Severity: Medium]
Does this code need to call SetPageHWPoisonTakenOff(page) here? Without the
MAGIC_HWPOISON marker, if unpoison_memory() is called on a boot-poisoned
page, it might not properly recognize the page as having been taken off the
buddy allocator, potentially causing a permanent memory leak on unpoison.

> +	update_per_node_mf_stats(page_to_pfn(page), MF_RECOVERED);

[Severity: Medium]
Are the non-atomic increments inside update_per_node_mf_stats() safe when
called concurrently during boot? Since __free_pages_core() can be executed
concurrently by multiple kthreads, the unprotected non-atomic increments li=
ke
++mf_stats->recovered might lead to corrupted per-node memory failure
statistics.

> +	atomic_long_inc(&num_poisoned_pages);

[Severity: Medium]
Does bypassing num_poisoned_pages_inc() here break memory hot-remove
accounting? By calling atomic_long_inc(&num_poisoned_pages) instead of
num_poisoned_pages_inc(), the hotplug memory block's nr_hwpoison counter is
left at 0. If the block is later hot-removed, the global num_poisoned_pages
counter would not be decremented properly.

> +}
> +
>  /**
>   * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.

[ ... ]

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 404896b53003e..9e2ce833fd409 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c

[ ... ]

> @@ -1613,6 +1626,18 @@ void __meminit __free_pages_core(struct page *page=
, unsigned int order,
>  		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
>  	}
> =20
> +	/* First: a block parked by __free_unaccepted() never returns here. */
> +	if (range_contains_poisoned_memory(page_to_phys(page),
> +					   PAGE_SIZE << order)) {
> +		poison_block(page, order);
> +		/*
> +		 * TODO: free the frames in the block that are not poisoned.
> +		 * They stay out of the allocator and still count in
> +		 * managed_pages, so a unit costs up to a block.
> +		 */
> +		return;
> +	}

[Severity: High]
Does this early return completely leak the unpoisoned pages within the memo=
ry
block? By returning early and bypassing __free_pages_ok(), the healthy pages
in the block are not returned to the buddy allocator. Since these leaked
pages lack PageBuddy, PageOffline, or PageHWPoison, memory offlining
(test_pages_isolated) might permanently fail with -EBUSY for this block.

> +
>  	if (page_contains_unaccepted(page, order)) {
>  		if (order =3D=3D MAX_PAGE_ORDER && __free_unaccepted(page))
>  			return;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-hwpoison-k=
ho-v4-0-359313564495@debian.org?part=3D5

