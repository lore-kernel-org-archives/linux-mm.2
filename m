Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 433CEC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 20:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DAE66B008C; Thu, 23 Jul 2026 16:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4642E6B0099; Thu, 23 Jul 2026 16:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32EC36B009B; Thu, 23 Jul 2026 16:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 112326B008C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:35:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 993DA1C00BD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:35:53 +0000 (UTC)
X-FDA: 85021197786.05.DF07BE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 70ED420009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:35:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0XxJV5UF;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784838952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nac04wlAP2t3HqF9mb3TQViUemoTPGuh6MRheYC0KBE=;
	b=J8y+p+1ZR4qXaig8OtVJyAoCzx/NbCMirgRuxBSseWQ7Gzuik31AI4BCOde87EX/17Em13
	qpQt22z9RyzK5jXzUyK1pY0nd5TfHS5gXAdOR2L8D9AiNTL0WQYKcXZYEojlMR1cjMI/Gm
	8n3K/2O9CzZWLhjx/VYpzW7ivo4PIiQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0XxJV5UF;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784838952;
	b=DWN7MdGjJfh1oeHGbZvQc1MlPNOasu3wEKJ6yQspALlzpm8ou4Z3FlWHt1sC6gKRkzqENM
	0V9lcyHFh1yAa5+ZNm+fgM9E6O8BehUsGOrsALPKTRtfVsJA8ZpDonoL27F7lnyAKbqa54
	xalO83r3/cVdLydBjvjIrubglh2rPaU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BD41600AD;
	Thu, 23 Jul 2026 20:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A6C1F000E9;
	Thu, 23 Jul 2026 20:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784838950;
	bh=Nac04wlAP2t3HqF9mb3TQViUemoTPGuh6MRheYC0KBE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0XxJV5UFLXYx3mOBaBVQS6f3P98xfPPk/e8U3/q0wpyVtYOnr/68ZMpaEz20HeB3N
	 XXHt3Mz84hugaUifCCWikxxzLzdoUZvsYIx38HhALzbY5oT5oUaipF1Rao4U2KrIFg
	 kMrjJye3gTwtjQZsXxkNVhIaFEufIEd4VxrAComg=
Date: Thu, 23 Jul 2026 13:35:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, chrisl@kernel.org,
 nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com,
 hannes@cmpxchg.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v4 0/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-Id: <20260723133548.2e12b638bd629ef63b935113@linux-foundation.org>
In-Reply-To: <20260720164207.450685-1-usama.arif@linux.dev>
References: <20260720164207.450685-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 70ED420009
X-Stat-Signature: 6hjh9twyjusy8dp4ugc6pg5ip4n5s317
X-HE-Tag: 1784838951-50174
X-HE-Meta: U2FsdGVkX19LO9ryuDeNElKyvxoYC0yV/nnZMI1b0S/K0kcxC9FLWa5z6lc9s/vLBihHwePP6asIKxk37eqJPVWng2YdwqNVu/NTxMzYo2o/IqcZoGrv7bXw1JdCVD5zfjv67HGajshMS0KA75ELrN5ofKKLeM/B1rlfh4Gs00bKhadQbYxRBO4D5XKeFLez4t76NvlnqxX0ycohJh76TyDB5RvhVz5W69dcfvLxdA3qQnHqXbIYee9E9q16DUcwnTwhzxzmolGb6BNVIi1rn9g0TJlGCe3svUk7AiaYdKryj72L7ZQSOF965hOSL/bpkOIWQqLy5yjpGaVaOgrWM3rJR8KKOwe/7uSUCv0Pb7eyIF4s2dnibGMQqsWAsrGwissPD3t1I5bHpr2Gq0zxO4rvU/uTutTDeNZuRWZj1RjmXpvnbIUWeQpQYqFHA4LPtAYqVPrOVcgmtFhDC2buaEhbzLEbIPfKlEEcgb33ITVWDsv8cX/qsvndx0ozWfO0EtT2VpPaok2DI4ilPpsXvtguoVQSlSYQr2X2shmwFkM5ho5Jjf8/NLI34sBKNy9JmnNuEJLTYmHPjNRVL+PNuX8zriaSmQt34Uid+vSDOg6pjrsD4SLePfDrBzC1gPkmkNKEz1UeZc+NwOIlvEk9SVebZWdv3srdwMjfuhA+CzZNq6EuvrITOsnWJiJV6u4Fl+NHNvd0zeD8GytW40RYvdVnl6IjW/O4jEuVZXNLgGg1cTA7kXwvAvSB0Qp49/nP2hUxWkJ7ydZ9QbgOSI5HUaXRJQK0EbkHQOIJ/wzSYNCsk2E30g35UQClInUziOLYBS9jij0nSMhbIsd5zaJ7V029Y7+TI+zcp24z7zyCgbzQu5To3kQ0/G+OlYIVtt5GazrI/WNx/OzW1eDcqb3d8hKc2cUXC5VHMsNd1pTmFn0Xi3D/R7d1xFhr3a0xxQvoPaR4VxPN+tB829xbjaj
 UGJpROW4
 YcAAVBVpLpRb8ZSKXyaPMDONUEO2OJ8ZndjBmnId2cEB/ylmqUqrJ/qwrSGsP465N/kyg0Oe5E/Uk+OQ8abtLCVhJWCmpNmtNqXyIEVCjx+osYvXB1oXkLYQk1LSvJiNuFhjL16e/LjDwLqqVtsbOaLDj9BQXT2/AV3ByPEX4HfrQdM0klbl4TD14uoRLJzS4rVTPD4ZK49k+Myzrs0ctaMpmQrm2SAuJZ7zE07fF99DD5VakYYJ64MYqqOBjgY4S/tHuunO8Jc643CLQ861IU78fcd+3MIaNGDevUawJxOjoTKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 09:41:21 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> The anon/file scan balance heuristic in get_scan_count() is fed by two
> scalars in struct lruvec (anon_cost, file_cost) that every reclaim
> producer updates under lruvec->lru_lock. The cost-recording work
> itself is trivial, but it both contends for and contributes to
> contention on lru_lock - which is often a contention point on
> memory-pressured workloads. Specifically:
> 
> - shrink_inactive_list() re-acquires lru_lock at function exit just
>   to call lru_note_cost_unlock_irq().
> - shrink_active_list() does the same after rotation accounting.
> - workingset_refault() takes folio_lruvec_lock_irq() purely to
>   record the refault cost.
> - prepare_scan_control() snapshots anon_cost/file_cost under
>   lru_lock.
> - lru_note_cost_unlock_irq() itself walks parent_lruvec() and
>   re-acquires lru_lock on every ancestor, multiplying the cost
>   of every update by memcg-hierarchy depth.
> 
> This series removes those producer-side acquisitions entirely.

Thanks.  We're still awaiting review of [2/2].  I'll get this under
test in order to parallelize things.

> Measurement is a 30 s `perf lock record -a` window
> over otherwise-idle hardware.
> 
> Workload rates are identical on both kernels (the bench drives the
> same memory pressure):
> 
>                           baseline    patched      delta
>   pgscan_direct  / s      172,662     171,817      ~0%
>   pgsteal_direct / s       67,162      66,306      ~0%
>   workingset_refault_anon / s
>                            40,696      39,830      ~0%
> 
> perf lock contention (total wait per 30 s window):
> 
>   Lock Name                Before      After     % change
>   shrink_lruvec+0x770     722.84 ms    0         -100% (eliminated)
>         (= lru_note_cost_unlock_irq)
>   workingset_refault+0x167 385.26 ms   0         -100% (eliminated)
>         (= lru_note_cost_refault)
>   shrink_node+0x4ad       689.43 ms    26.95 ms  -96%
>   shrink_active_list      208.34 ms    15.97 ms  -92%
>   lru_add_drain_cpu+0x34    1.96 s    917.71 ms  -53%
> 
>   Total LRU lock wait      ~4.23 s     ~1.66 s   -61%

So it saves 2.5 seconds out of 30 seconds?

