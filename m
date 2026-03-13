Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E701106ACFE
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B900F6B0096; Thu, 12 Mar 2026 20:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7ACA6B0098; Thu, 12 Mar 2026 20:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87816B009B; Thu, 12 Mar 2026 20:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95E246B0096
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:16:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6362F1604B8
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:16:41 +0000 (UTC)
X-FDA: 84539123802.01.5DC030F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id F227A100015
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:16:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kojrPeUx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773361000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tC3uGvGJPEnpsX9fu4r5utdb74ZxgUvYA/kbvnL1nZA=;
	b=4OWk11xg/uyPsmUG3ykGvNIO+iZ8JvcyqB3qf27C438Puelx10jlu3kcjbXQa6v6KsVpM0
	HmhRLG3ty1fG8Xu7+HfFYe8HeW+Wi4t6JzKBle/7wl7RDd7/tACPjGGcHGj5/r5t6b2rXs
	WqakVsJAzY+ArNylh37/6BUajOwWB6Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kojrPeUx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773361000; a=rsa-sha256;
	cv=none;
	b=zRfQmB6bk3AZsiBsHGwWDD8Hy3RWsSy5TO2iniamGhRlNjjmJDR23IeqHc46745/cZlqMF
	9l730OFSU4ALV7b4RFtY6h0AFW1DjnfVdDwYojxJ9ieQ0AVJPxdk7q1ZLrx0Y6uD1hCzeC
	AVtAQ7Q28ims6/v/wPdFOF7ubmJmrEw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DC2261334;
	Fri, 13 Mar 2026 00:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72F6C4CEF7;
	Fri, 13 Mar 2026 00:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773360999;
	bh=kxl9iEtW6aK2kkcioT9fyhzhn0YAaFkzT5zpiNmeZjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kojrPeUxA17rgHtPYsXoyrZJG3a9/hQhygq5TnTfpxEgTYl6FZ6TDmQh1SE7cmgaZ
	 +JJbLl0hePVs4amoZQLuFgekaROkwmF+nBK5VM15NFdfvMWZzcPuZn21hTAqHKiw5m
	 pYJqy400PqsDBUV/2D3JTvbLDcqUvFRAO7BqSU+4qW5T3wCQVInSqoCpLwB03gSHFY
	 cjE10PuULCEUuD0AFdeNQu7AV76ddG9L3E1MxjSao1uPevwuTzpt6LxSjvRofrbenN
	 TuvuxRmIIn/bHJrZJRd4MwAWEFrggaboRPPuuQMNIThCVHPOCKP9RbK+AE4JIIHLnH
	 5CdmRXqNuzMDA==
From: SeongJae Park <sj@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	npache@redhat.com,
	david@kernel.org,
	ziy@nvidia.com,
	willy@infradead.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	hannes@cmpxchg.org,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	richard.weiyang@gmail.com
Subject: Re: [PATCH v3] mm: migrate: requeue destination folio on deferred split queue
Date: Thu, 12 Mar 2026 17:16:30 -0700
Message-ID: <20260313001630.80081-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260312104723.1351321-1-usama.arif@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F227A100015
X-Stat-Signature: r7po4cji548me3pkpknm8ucrfpx94n5p
X-Rspam-User: 
X-HE-Tag: 1773360999-626818
X-HE-Meta: U2FsdGVkX1/pjeMNP0EuykCyI9g1d7D57smiDoSC3aIHmD7b8y4GqznB61IEjOEQeZ9glArWUgiS1CzbapA8Gu40skONHxv273ac/7pimjGdXS5FOk5wsogbVwvMYeVe9unh+mN6BsX4SpiMxMEZu4wULZ0qAPmdDAMnm/csNOlWbBHV9CPQWPFSkseu857np+Og4C/gBxBA3iKSq5okKW9t0td/UbT56tK6KPHL0ogkh93KN9R+/NNwfE16gFSyRppAFiXJRaBp+dVY5/B0EktpbMQpgBPPJ5OWJImwbBq7JNmuebC89BuPnR1WcO4rCbj/EvzbJolT3E85y/BRkBNfcDLIQOKxoEbv+Ki9la9x71VGStKUcA5HifOGuFHZEE5n8x3hwsETYZO1jTa5sHNouYQTLtU9R7j45owSV4Qmcajrbouw7Ba+p4qb22Y6PexIKwdOphuuqmbq2yhlg1MaIB7RYpnXI9AUpPwKarGNHZzMJS6IMjcFMhfRZOYTCSuYETps4LZdRkrXXDCecz3iHewUfdEdcowigpQ1WaBmZQ0FTA0mh13c3wciqDxyS1HW+TP1Kb0fXldBLWCyZKcBldpVC3MpehyixF/mLAueEeJJsdwSbqZGO180NRe2/i23euOmB6FXt2vnlOAAvTCs2bXjP+5QC/QShhsJFzkY+4n53ntyj/cXskgoYIB1snN1E64aCsQtqtyUrtGiZTzV24Gt55EV3Od3AznjreN6YGnDhqPjFskwJMTfzHYjrCVBIQ/SY/WKCRL1gDJHg4PG/Eu5LKpIaCFjLroVQ4/lGbfs831AuWRJumPnTXAaxCNfLgTrPVflPNuM/pX7JBZm2EdDxttRuwT8hhW7gp9/49C6n0WDr28pNXEao5OrjE/gg3OcMuA/l8UQA6KyI2xV/dP+fzYxuxdx9AFAS6tpcy/Dtvg9Rhuk+6zio5tO4tUqOd7ns6+Ll7bBMyy
 dTSc0NQn
 W6M2Dn/1M7poVz5vYMGJmL4MAhDnemjanmhSK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 03:47:23 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> During folio migration, __folio_migrate_mapping() removes the source
> folio from the deferred split queue, but the destination folio is never
> re-queued.  This causes underutilized THPs to escape the shrinker after
> NUMA migration, since they silently drop off the deferred split list.
> 
> Fix this by recording whether the source folio was on the deferred split
> queue and its partially mapped state before move_to_new_folio() unqueues
> it, and re-queuing the destination folio after a successful migration if
> it was.
> 
> By the time migrate_folio_move() runs, partially mapped folios without a
> pin have already been split by migrate_pages_batch().  So only two cases
> remain on the deferred list at this point:
>   1. Partially mapped folios with a pin (split failed).
>   2. Fully mapped but potentially underused folios.
> The recorded partially_mapped state is forwarded to deferred_split_folio()
> so that the destination folio is correctly re-queued in both cases.
> 
> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> Fixes: dafff3f4c850 ("mm: split underused THPs")

Seems the commit is merged in 6.12.  And I assume the user impact on
THP-shrinker enabled systems is visible.  If so, should we Cc stable@ ?

> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

