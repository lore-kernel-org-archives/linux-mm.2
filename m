Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F6EC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396A36B009E; Mon,  7 Sep 2026 09:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347666B009F; Mon,  7 Sep 2026 09:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DCC6B00A0; Mon,  7 Sep 2026 09:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F16CB6B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:48:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EF4FA35A9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:48:29 +0000 (UTC)
X-FDA: 85187095938.09.8048611
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A649820002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:48:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CiavmS91;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788788907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5Sb5qERZJvW54tBhlgjobR1+hnd79QPkfb2XhBE6Dc=;
	b=65C3ajrRELcHe02akIG4OZY1pTUJMC6qsTa/XWUxGWhIGSh29TOxgt26n45m1JaQYvVr3M
	87CZx6iNlHlrOV05Cc4qZ6x1IFUv+t8PHy/CHiv2tULmk2IQ2pkzIX+zH3bSplbTwf3+Uc
	sHx3t9owyyAf1wME0+QEqmbkJFYlXVo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CiavmS91;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788788907;
	b=56pgWP4TgDayFpaQJrJEbXdt2hEKKu5IXYIOjVXTGWYFLjVrcBhovBTjPHfhrU4zxoXINq
	k7BrYivqBoDcAiBbSkw8py4/2ZPN8ktPom0wnS1dI1ZUBNGR33uzYroHFkKSBiNuzq3Ota
	lDKEGgbyDpOQDNSrp64oIsKWN7YMgOM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D12D641487;
	Mon,  7 Sep 2026 13:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293F61F00A3A;
	Mon,  7 Sep 2026 13:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788788906;
	bh=j5Sb5qERZJvW54tBhlgjobR1+hnd79QPkfb2XhBE6Dc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CiavmS911DInJ74DVkXRLrW9SLVwTuAZ4qk6H0/Tn4FYAfwg0DXscwmHSHp3bftH0
	 QajgYDGFeWru4s99Hjwu0ziahN10DVli0avm8Ifs3F88Q2VeB1wiJTNnks1K5o20Pv
	 WNqrIkNDf7yGZfhmDNZRCyGfz7ZZXuYRaYlCFPCVwKLseu4mwTtf87amLeNMmqZStJ
	 aYV6DFu19BIZ8zXVZHADlw+TmibOeSzBHG1HqQSFaG7/ImLDHvmLnM+8cgce5RaZAA
	 YAXLAMzhcLMrQlvNf3P+fb0THc8/CsXvL6IOEH5TQl6V9BONalTh6/xXxZE2hS7Va8
	 TrCflNjG2Emkg==
Message-ID: <e0ccb602-28ce-4803-8963-246161cac60e@kernel.org>
Date: Mon, 7 Sep 2026 15:48:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory: do not touch frozen folios in
 deferred_split_isolate()
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 ljs@kernel.org, hannes@cmpxchg.org, usama.arif@linux.dev
Cc: lance.yang@linux.dev, ziy@nvidia.com, kasong@tencent.com,
 hughd@google.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, balbirs@nvidia.com, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260831091514.1879786-1-kirill@shutemov.name>
 <20260831091514.1879786-2-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260831091514.1879786-2-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fkk3wzijpkwxqsdtwpxk7xf3bb156sjd
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A649820002
X-Rspam-User: 
X-HE-Tag: 1788788907-931594
X-HE-Meta: U2FsdGVkX182B8iCJv/WcFCoayfW7xAr0akQJuNgRRukIzDIjDqbP1dJlaBR66NDlHlsOejHa5A9jEnz0VN3apaAmsf+DLl1+AcwReVmvRTbtD/eIKcMmW6lEuLYefswhpqoqND2Z/zus7qBSdHRq99FH+YCWFfglFoGzaSxvOgK5CFSAEjgo3DAwXQAMm+vlMKHqv853R1TW1m7PIuFp1MLooYKZuIkQHFznZ/4RovGSiC6iXTFkGbr2mmUE7L76BbTm6aka7Rw6r4esQeQhe9dmJ1Im6KfLp8p+yBZ/oDaCoEG/oBCVGRQlC2MVd61ZpvSozsnbCM59JKhKjXvuF0TzgADY9/wkTWU+p0horSwjymrIV746PXmbvVSjQdO/efGrghEk5LQajLOlL595xIt6r7pxxZyyZZJMFCO85D/ZbKKBJ5ElGvGz6czK61p3Hh6ZofFWlTV/4eXb6TeNCXUXK8hdEfNiWI+P0JiuL2ggu35csUYT68A+GPTU92G0+Rgzp9lUYjhRe6FDB7SKZW0wdwVocXKGCoqbT+o8KMMAv2t+YkuAX+7Huk3uOUe1G9tFvprmSWIwlTc6MkYbsjxTQlKfKUrAqmtgXIoD40PhTfXshCw14hIUPRHqQCt1If4tVfXYW51xzrnCC8ZO/jcF3ju26B0MzKTaCrbJVO7kzYlXHgRxtk4Xn1t/kEZ70KVGxHQFYWvlgwFGf6350TOxdq2GPQqh+Gw3hCj7XlkIbsCpEvxHC2elWwOSA1YNVXAZbBvYIrIV9j2ycUf6d1iw/x0a32c3v4KbpLEp2BI5EsVs+qCMcl2MI50lgfa+lJ/tKAsYSyhPOR0UZKFk4/G2f11m1fhqtBAS/s0cQtLCECWimkGtJ2TMwqJth7GgMaDKp2dJrhPrMe2pJuwclgYzlxgALq/AhJEmluakAGOJzInhvyrSR5bNYJ8A10VA/t5PW3mn4/ru844m/O
 ussmH57c
 EsGOjpPL1NJcLxV6vJTYlfsp9incMSiOs260Gcv9adXIUcl6yAqhn6XoXR0BWq7BKCFC41Y1tHT3//7/UVu/gY4tAraVmsBYQHZZHwtvW3xY4/qX0N1h2r3W8fZYd8UsTeFxfLJTzqROuEXswEAh2eKhEnKpWp7q3gvgd+ADJnCnjN9wmRP+5NmJ0TF91ViUyAeP7aJbK/k0NqZzwpwHfle7yORlIqxyRsHnmmejH7auRikxax3mIjq31Ij4Y1eoyXg/nZTYDfoevP4EuN51mntmaykKMCDzHxU9sfJyp6op/q+wCFfUJLrA59RFQsND00MaTZPvhIkXewsdVsCFOcBujcw6xLO6iRLspnrTz4CcMrxMkbwE4Eic9WmSjsGGsPXqSSKGu+0hnk/t/LackpyolmlHUmf3MsCvz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 11:15, Kiryl Shutsemau wrote:
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
>     CPU 0                            CPU 1
>     ---------------------------      ------------------------------
>     freeze a mapped folio            deferred_split_scan()
>       folio_ref_freeze()               folio_try_get() fails
>                                        folio_clear_partially_mapped()
>                                        NR_ANON_PARTIALLY_MAPPED--
>                                        folio off the queue
>     give up, put it back
>       folio_ref_unfreeze()
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
>     __folio_put(), folios_put_refs()   mm/folio.c
>     __folio_migrate_mapping()          mm/migrate.c
>     shrink_folio_list()                mm/vmscan.c
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

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

