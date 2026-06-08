Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C9C2CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B436B0005; Mon,  8 Jun 2026 12:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC1F6B0088; Mon,  8 Jun 2026 12:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2786B008A; Mon,  8 Jun 2026 12:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5078F6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:07:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED6C0C02B7
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:07:04 +0000 (UTC)
X-FDA: 84857224368.30.C58DD90
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 10F76A001A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:07:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="xQbe/Ssd";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780934823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXQzeZbKTFVTTpfiVd3SFhRp8gvKbhszT3P2b4EaKwU=;
	b=P1rD5FdCUs89n1ufZLwwBcr3aLO0qst+0XXEJvhlQtJO27fvQSYkNy7KIRZqnSR0MO6Hqm
	KjGlJcoGsA89KZdXe1hTWhIx3HZkqKkvleQpVwEtgGt+swg7CZIru2VSfL2VBSs0D52H1w
	DuOyl4V8vfRhnL77E714vl6yB6Z118M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="xQbe/Ssd";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780934823;
	b=jklbmmsn2weZuRB+y2keATwF/Oz2g+gBrqgUXLqGtFUO1dwk2jFqJy5K1XMjlBy6W3bujG
	47aP9gBwkpURG+wLsh414CAbWD2MGp31eAMu4nOFwTkXOB6+OS8YjcOrN9+9h1lOrKIu7n
	A+mMR6Pw3Zq+4e/1k835zpJMEfJwWiM=
Date: Mon, 8 Jun 2026 09:06:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780934820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rXQzeZbKTFVTTpfiVd3SFhRp8gvKbhszT3P2b4EaKwU=;
	b=xQbe/SsdERdt9owUyf4KPyXwbqz6rpEZgWeG0I/KJNrxxyDSUd+TdL7gfeXgLxvkLhYOS8
	VFS6kN9WBpN3STneGSq/QSVIKCSNbDC2yUuzXkDF9Zlj4DmS8N0rM9R55tnDBsVo1uhO1h
	J4Nq53n2wTeCK6YHqzsjOovKkot5I3k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, riel@surriel.com, 
	david@kernel.org, baohua@kernel.org, baoquan.he@linux.dev, chrisl@kernel.org, 
	kasong@tencent.com, linux-mm@kvack.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, inwardvessel@gmail.com
Subject: Re: [PATCH] mm/swap_state: remove unnecessary lru_add_drain() from
 readahead
Message-ID: <aiblCPXfBYtJT2Fb@linux.dev>
References: <20260608143242.2869392-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608143242.2869392-1-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 10F76A001A
X-Stat-Signature: x6ab5dm9gjk9wcnxfdxjtr58fu9a9rfq
X-Rspam-User: 
X-HE-Tag: 1780934822-163646
X-HE-Meta: U2FsdGVkX1+MomAtvXe1EwQZBVr73GHgjBB0avurjdzlwZcMSPdR3911ZZt4QT8rEr+jGrlHgPkcthXR6mIUjJ0CyXn2NNw9dQ7O3JpRZ4x+mSPCIw3mQrUgAtL8UvYMBMMz397NemUpQqkg7mIOqsneCNxu3/bX9tMiQCCTJC1UmrfAemo6b+e0OlKdZhji6HgkfpdxHs6l2czKpt09xu24cNRht+pSS1B8mz9gohBoOkx3K8/bt1tGVaubEEVnCXIwzDfClU5VSP9olHpcKp89Y7+1Ni0iZjy2x9YV/Y7j9a5EHE7+xt+3e1UyFmQfqGFp+dsD9tFVIatB7P8/+xlePKsvjEfL+O0dQMzUZ/4P7qMs3SIHoq+Cc9OCRiI2Vt2yPMB9YNOCt0R1WsCFkU5o9CayAMdB7DCwC7s5Aca/PU5hPq5JzmWD2As9Af5nApTQ25y0JQpfxAYlEHyBqRKwNsM5Dcs/puTw5lWRHRuuW6Z6iz9ABIpyw3JnL/q2NH2jDhakW3lmNiNuQZaUGtptp8vj+sKJpF4l6BgN1IhKT0MzR8Xr4JhcQ/sRzWNwfr99/OpiE+rT3KQylsMXSDCGKLOogI8ZRWxElQFCkR1Oh2+YcFSrt0P0/DWye7tF1+kUIPssQHOJ1uMtFpKauab9Uax3Au15XAZGxS+Pr8QF2H/LRQuiJJbOJafmQ/ajb6I1xjvtObixZxBj3I4TQVTu3inllB2WZvSDgQmbNrxtNP87tKlV0ZlN8iFWFgZ+wUTjGXcUk3EPVXC7vSWen6IIlZg7SnkFdbIJ0hYVxmxtMYx7EMc3fBE9zSw/Mfj+7lzKyVnpp4qUHIwNSO03WfcOzzLjyuuHNDNj/rytwzDUY4cUFgbnc5Jr4TTzs4W9pMSwBX0qgCQRNgaC/J3nHtNRNyppdOBVEBrwiXgdfhP+YqVo6FOwLUUktRRWzGeo8RUzkuTRLd07WMGg2Vm
 bfvnRhPM
 hp4n1QrZvxcsxHDSkIvcsz2WJZkyhGty75Im95fwSiDG7RTJoCWXIs+G06xcW99GOWyy8Bmwa24ZupDOs/YhPkXgK8JzI6tlVQ2YlVv0UzFKDIKDEL0/OVxVpzJu+10+CHsZWKrtXmXsrqhDyndUncvdLKZg250XODgnjKhzOZtaNU3Bne+k7Y74LwVlh4FfMMuc992xcmQaV19x3PrXBU/J9tCVn0GBYG+RgHcJJmFIu6/EKGzm8/cvm6HNraEbLBlusPNyuk6UP6FmYN+Msltsgbi2drnTDZ26xHRve9kHSDmc884pMqHq6RFwF9FjXBRiNph5Cr1LuF4k4GCmUL7fNQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 07:32:42AM -0700, Usama Arif wrote:
> swap_cluster_readahead() and swap_vma_readahead() end the readahead
> loop with an explicit lru_add_drain() call. That drain is a leftover
> from 2.6.12 era code and serves no functional purpose for the callers:
> 
> - do_swap_page() ignores LRU residency for the readahead folios;
>   it only needs the target folio it called swapin_readahead() for,
>   and if the write-fault path needs the target folio on the LRU to count
>   references accurately, it runs its own lru_add_drain() at the
>   wp_can_reuse_anon_folio() and do_swap_page() sites.
> 
> - shmem_swapin_cluster() immediately locks the  returned folio, waits
>   for writeback, then operates on it - LRU residency of either the target
>   or the readahead folios is irrelevant.
> 
> - try_to_unuse() likewise locks the folio and calls unuse_pte() without
>   depending on LRU presence.
> 
> Folios newly added to the swap cache by the readahead loop sit in
> the per-CPU LRU folio_batch and will be drained naturally as the
> batch fills (FOLIO_BATCH_SIZE),by the next reclaim/compaction
> lru_add_drain_all() and so on.  The unconditional drain only
> synchronously flushes a partial batch and forces contention on
> lruvec_lock.
> 
> On a 176-CPU production host running a memory-pressured workload, this
> path was observed to call folio_batch_move_lru() from
> swap_cluster_readahead() ~28K/min, a very large source of LRU lock
> traffic.
> 
> This is a direct continuation of the cleanup started in commit
> 1aa43598c03b ("mm: remove unnecessary calls to lru_add_drain") which
> removed the equivalent drain from free_pages_and_swap_cache() with
> the same rationale. A detailed reasoning for this is present in [1].
> 
> Remove both drains.
> 
> [1] https://lore.kernel.org/all/dca2824e8e88e826c6b260a831d79089b5b9c79d.camel@surriel.com/T/#u
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks for pushing this. JP was also looking into LRU lock contention sources.
Particularly we lack visibiluty into the lru_add_drain_all() callers. The idea
was to add tracepoints to tracks such callers. (Just nudging you towards it :P)

