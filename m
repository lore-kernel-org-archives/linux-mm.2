Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B09CCC982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 16:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F6C56B008C; Sun, 20 Sep 2026 12:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F7E6B0092; Sun, 20 Sep 2026 12:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6960E6B0093; Sun, 20 Sep 2026 12:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32A366B008C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:20:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D45998040C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 16:20:27 +0000 (UTC)
X-FDA: 85234653294.09.DAFE73C
Received: from mta1.migadu.com (out-253.mta1.migadu.com [95.215.58.253])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9988214000E
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 16:20:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mrDUKMSZ;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.253 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789921226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvcEOp408aNNs8/B9XL+OQIPGO1k0kTB/zjVTm7MS8Q=;
	b=ECZHD8dwBjJLO87EqblErQQiW+JaLdr7j4uRisK3QEIeP6iARCvc32ZFcGwAFWaYJ7efgY
	9RnTxYqLqLkLesVycWiYt+jz54U/EjlJ01OV/Zvr1uEkGHjcqGHUGgj6I8HHjH12BOYWDE
	GH1WYUpfI7npMK8VhQqooIScJhVNDSE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789921226;
	b=I2JOalbSKTewDWbiM8CjOeHBr8EhsJ/J91Zx9YgmwkzmUQhV6fXgZWCeBCpb08eJTk6n86
	8DCrxTAa/PdyoGb2vM47SWhQ8KDbJzwHBB0dJni4UaUGthNm/EB9ItXTgwa4DqhstaBOBE
	74ZaRUgEzplSZUVdFYIr4raf9OQqBP8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mrDUKMSZ;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.253 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Jh/ec3K3ukDzMq3WWhq6Yn5uDQDCxRHuqgPolHVXoKM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789921223; v=1; x=1790526023;
 b=mrDUKMSZ+ZVHaA8XTFlz6Mb/CSoMYkAYWYEcb1dk+oSygLeIYKAS30phHTkBZ57xd0qt+02P
 2BlYtbam1jbStiytkNi6cDsXon7whf/lkrj41YSNyV3FjjcLlJQb27BptaWS6RpP8YTGNq1SmKE
 8LoLeZNlzwmBtX8qIe49MHRM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 53e8bc01651a3597;
	Sun, 20 Sep 2026 16:20:23 +0000
X-Mizu-Trace-ID: 53e8bc01651a3597
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: joannelkoong@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	usama.arif@linux.dev,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
Date: Mon, 21 Sep 2026 00:20:14 +0800
Message-ID: <20260920162014.4479-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260916224437.1164512-1-joannelkoong@gmail.com>
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ar4pg4oon45dp1gbsxfrxtua9wiq47xn
X-Rspam-User: 
X-Rspamd-Queue-Id: 9988214000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1789921225-318363
X-HE-Meta: U2FsdGVkX1+n8y7EuPjP/QNd9axSYoOUwCgIWNFwzNexDN/jt1o68gWThsoNJuzP82kNlcaVubwfPd6vrqpYGve/ns6Hw2DKO0h4TdMLTxuGYrn5gLFPvi24yE8cexPs2A/137jBEh+N3m6OTrXOJ3TCpaYHY6CDlF4iO1fhHoxAIzPIOwjbMOr6pwzKNU8mneouBnN4/5yW1xThrPCSikLm7s2UESpwsA5yWP34cMDUrzbW0iMxUrBiDELDllE2pLyZK7HYx5epUvWuYb5LWmHfCoWDQV1AyZ6vkeNlpuK7iieAhWslRb800V2kkSvtnYZW5f9RtERQVMpsCGljeU4UTLWZexoYBQwlvZmcidfCuQEDgaA119WDR4MUGaOdxWfjlQeLZDuFfoW6ljt+Kd6g28JKlMhUIF3OMXs7yVxGqQezukN2nXZxBpTP9tHFq+bHICKoebM+ScRRARi4tGNPhzKcVjnQpdDn7u9phXIyZLOXsixWpnRm7x0guomBOK347YTHhHM3G5MJ1CQ7zuAn3ZrMTJzY1jEar8nnMvTKy4nqiviRswSgvtAhwHbHUPfVs52yLeq/SDyMHj8KJKN+3uLaDWA0dfJc/VLpfZx+EODUb+/49+WvjOLrkojlsMRVGzjF8zdHfDL736apJM3N8UNckBexzSXgmOagmit4ACTIT40gRzozQLbk45On2V2wDXjQ1u67mwc7gnkXj74fnGQDZ2pvqV2gh1dHAAuvhOBpZKOaoyyAj63+HcMMPQj8BNg0xoYf9Kjfii1JVOZUR7cJl7dlWSErQLAgVplbIN1pO8OiLVkTPJowe2W8bJpwRHbtSlDDiHEUmhiH06Kq1c5ivXNfNsIsFq/fDB+EQdDK2BcM7YAZ48phbLJsuWHVynuY6VUq3pM4VCOKHfP695a/WDh2zy7wLY+F9vRxMEUuc6I1fQ614HOdQPmeiRy3Owm0iW3sw5NJyPt
 DMmX7bwO
 dPwfSMCxEAy+7lWTcIvw/EPGTRaceF5K/0mUPVZ3PrRIg8TgdCZZYGx6Ln2g5i8E8d63qbb8L5rRw0mVmA72h93Y2GE0ecepQ2jKvDa5HGGbRGcBMCw2BixYW1Ye7Ff7Kwj/Qi8w3p+25HLvJLeALZ1RiXX9PUU+bVWrbQECnzHSI3X9Zw7gzpsUno1IHknpwPPm1ZWbnOSU4dwqYbilVpu4sDjCXMFUMnJDz/7qQcOq4ix6dIq26TYGsBzOwUEGY2vXtkgEBn3sM1DLV5hqDMDtmaSlrq8lm3nbJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Sep 16, 2026 at 03:44:34PM -0700, Joanne Koong wrote:
>PMD-sized THPs that are mostly zero-filled are reclaimed under memory
>pressure by the deferred split shrinker, but this is not done for mTHP
>folios. At Meta we would like to deploy 2M THP=always on arm64 with 64k
>base pages, as 2M provides the contpte benefits while the PMD size there
>(512M) is too big to use. However, 2M THP=always causes memory regressions
>unless the unused portions of those folios can be broken down and
>reclaimed.
>
>v1 did two things. It scaled khugepaged_max_ptes_none down per folio order and
>it queued every anonymous mTHP folio. David objected to the scaling since
>collapse had already rejected proportional scaling as either letting the memory
>footprint creep or being confusing to reason about. David and Barry separately
>objected to the queuing, which adds list_lru lock contention on every anonymous
>fault, and hurts lower-order use cases such as Android's order-2-only
>configuration. Johannes suggested keeping khugepaged_max_ptes_none absolute and
>simply not queuing folios that could never exceed it, which addresses both.
>
>Read as an absolute count, khugepaged_max_ptes_none also implies the
>smallest folio that takes part in underused splitting. A 2M folio on 64k
>base pages is 32 pages, so the knob has to be set below 32 for those to
>be queued at all, and any folio with no more pages than the value stays off
>the queue entirely.

Em ... I'm not sure max_ptes_none should also become the mTHP underused
threshold ...

Say we're on arm64 with 64K pages and set it to 16. Khugepaged PMD
collapse uses 16, while mTHP collapse turns the same value into 0. With
this series, an order-5 (2 MiB) mTHP enters the deferred split queue
because it has 32 pages, and is considered underused once more than 16
pages are zero-filled. So the same knob means 16, 0, and 16 depending on
where it is used ... That's a bit odd ... no?

Would a per-order value make more sense here?

An unset value could preserve the current behavior, while an explicit
value could control both mTHP collapse and underused splitting. That
would also give us a way to leave max_ptes_none as the legacy fallback
instead of adding more meaning to it :)

Cheers, Lance

>Patch 1 makes thp_underused() folio-size aware. Today it only ever sees
>PMD-sized folios, so it assumes HPAGE_PMD_NR pages throughout. Patch 3
>breaks that assumption, so patch 1 generalizes it first. No functional
>changes are introduced.
>
>Patch 2 keeps folios that can never be found underused off the deferred
>split queue, as suggested by Johannes. This changes/optimizes existing
>behavior. With the default khugepaged/max_ptes_none, PMD folios are queued
>today and then dropped again by the first scan without ever having been
>splittable. After this patch they are not queued at all.
>
>Patch 3 queues anonymous mTHP folios from map_anon_folio_pte_nopf(),
>mirroring what map_anon_folio_pmd_nopf() already does for PMD folios. This
>covers both the fault path and the khugepaged mTHP collapse path.
>
>One consequence of keeping the knob absolute is that it is shared with
>collapse. A value low enough to be useful for 2M mTHP is a tiny
>fraction of a 512M PMD, so khugepaged will only collapse to PMD order
>when the region is almost fully populated. That is fine for the deployment
>this series targets, which does not use PMD THP on arm64, but anyone wanting
>both PMD THP and 2M mTHP on 64k pages should be aware of it.
>
>Thanks,
>Joanne
>
>Changelog
>---------
>v1: https://lore.kernel.org/linux-mm/20260707201735.4113107-1-joannelkoong@gmail.com/
>
>Changes since v1:
>* Drop the per-order scaling of khugepaged_max_ptes_none. Keep it
>  absolute, matching collapse (David, Johannes)
>* New patch 2 (suggested by Johannes): don't queue folios that can never
>  be underused, which both bounds what patch 3 adds and stops queuing PMD
>  folios under default settings (Johannes, David, Barry)
>* Fix the thp_underused() early exit to scale to the folio's own size
>
>Joanne Koong (3):
>  mm/huge_memory: make thp_underused() work for mTHP folios
>  mm/huge_memory: don't queue folios that can never be underused
>  mm/memory: add anonymous mTHP folios to the deferred split list
>
> mm/huge_memory.c | 45 +++++++++++++++++++++++++++++++++++++--------
> mm/memory.c      |  2 ++
> 2 files changed, 39 insertions(+), 8 deletions(-)
>
>-- 
>2.52.0
>
>
>

