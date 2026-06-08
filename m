Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0456CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 17:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5A436B0005; Mon,  8 Jun 2026 13:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0B386B0088; Mon,  8 Jun 2026 13:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20C46B008A; Mon,  8 Jun 2026 13:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCDA36B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:39:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56E4F16145A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:39:51 +0000 (UTC)
X-FDA: 84857458182.11.F5C864B
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf31.hostedemail.com (Postfix) with ESMTP id 097BE2000B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:39:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UUjZic9D;
	spf=pass (imf31.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780940388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yTj6Gbu49i3sY8rfakxka1MWJqqVniwSsgHpt4ReIM=;
	b=OTvFhqzexCwaAjeilHuvOiDeaKj5/wsDMfjFVvL39l/VHvuhoeAuooUq2kP0nVMcufc40w
	qzYJv/ngo+VLblEySUmgVoUgVB9JzyKJTa3qiRa1D+kXW4IPlOYshaw5E4BjLkoX+2Oept
	p9779wMGTnKalo0nS8IAcQ6bFsF2KCE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UUjZic9D;
	spf=pass (imf31.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780940388;
	b=pFdI8kDMbSM3S03nuoYiV91aF1G2UqZ+J2JsLA7zG9ANrSXJjEezPgd9+xduxY64CWrbm7
	JOYz0RlW4ocAooaFt5wgFMYlMg/bKeDaqSQBTYZJPqhK3Fn9IJNlxX67mwPQ5WyUlD/vSa
	F4QqA8k7OjaGAi8ek5A39aMcu5dIMxs=
Message-ID: <00cb36cb-e7df-4638-8137-504e27c5509b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780940382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yTj6Gbu49i3sY8rfakxka1MWJqqVniwSsgHpt4ReIM=;
	b=UUjZic9DHfyrCHdrXQmwJHWMcbj+tp7KYQvlZL8t+gZYovAAXCOKRjqxrVVeFmbcjzLoDr
	QEG386kqBSxW16pUfFqnnU2fPuQ9IgDZLXLwTy0Q45Zq6pHlareP/UFmbFu9JYxME3BZLV
	PQV606tjtw/vW7vHpuPkfINFJmtTW9U=
Date: Mon, 8 Jun 2026 10:39:22 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/swap_state: remove unnecessary lru_add_drain() from
 readahead
To: Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, riel@surriel.com,
 david@kernel.org, baohua@kernel.org, baoquan.he@linux.dev,
 chrisl@kernel.org, kasong@tencent.com, linux-mm@kvack.org,
 hannes@cmpxchg.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 youngjun.park@lge.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260608143242.2869392-1-usama.arif@linux.dev>
 <aiblCPXfBYtJT2Fb@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <aiblCPXfBYtJT2Fb@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 097BE2000B
X-Stat-Signature: du9uzjhe3fm14gaoi8k7qemsgndmz7gr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780940387-57822
X-HE-Meta: U2FsdGVkX18wyHJl/xa1g/usY+Ixqdgs1k6GH0swAjVqKEmo5g5FCRMc02k6l6ZrKKH1E60sZa718WbOINVEGKyGhQWkst4IK16ptbAA0m6Ke9ARwJNlaH+ekGta9bNuA1wHAicIMtdppBtf5S2EiF3YPoRE83qcFRWtP/0vEolsbkqN5aEVrGznDnmNJDMqbmOOmrTwvDcd0bJP0Q8mx5BVb1M43YQn8DLRBLkRilHnWK6whVos3tr6rdr+2/yGqYFTTO5l6pDLhLUaPf/+DbxTxyfWrEBlYGS10hnY2ZcEepM4FmIlodzS4Ot/Voq6y1DO3SEnlZvwlzmJBll67GncCnGg3hCFiS0nzajyvg/Zf4dMBUGwETmUwoZZpxZ2ugi9Vp70HInrUxBlXl7SLjVMjOcOFNYiYcYaP0ZuXtcxcDS+X0VI5LFzOwgcAwkM147f59TxzbFFpOXdQkgSNmstduO5gHDMAWtphRsUtRu2XoFtalMZZY882Ge1W0iQBIMizXhOaw5vxSbZ8f8PZM7rSqlAOiPCgCGFlaq8I5i4XTS5hJhurURC1U0us6p3qN4DCJI7ZHwS8cKVB2SjVZPW/u5GjZ+mURDJzLXwJB6ErN9BsDQgdnkXc5BbNLIjgdQNpQ7rjUC6rPymAmOb9dWk9ioI0y2iwBQGGcwkJunIOK//vW80sMB4lruA1fzTZAHbxgLSboTeS3q+SpZTH4KkrdksFNvURH/dC/55BVUu3w/GeyvCOu7OS0dFGlkIOPMdcAJKj6jYNJr9/R39e4H1HsgY2zkif3F5v9TSt1WoGcTe7HJr/h/B1JHnm15qiibzIl/ccCTB19jzm0NdAxy8hEjkOuVD53IVtuqqu01nxZ1YBTAPZcbiTJqfH7w+qL6YrQ0tYfNmUfy2ghkBJl7RtB9JNJZMY8NL3twfxWO021OtaprxbBX09aiq3/3Of3BWlheHESB96+FI/uf
 I7v9cYtl
 TVYlsOYNdELgt5ni7r7+BaZr/dYh8LIYrhcJxlf/TJ6D2FLBo6DNwrNNUUvP8ce+4NNtJWhnLK8oyug1uZojB5yf79mOgwq30bjg2/YSeaSfUhmFXlrfOerUwxywewJiXAribCAKEACE7IMjjl/eoiLgrEr+sIC1md/sqyXsP4x3z1j1slcg0GUNGN2lsTv+149B2F8iOvav/mQoCNoiVDOWTO31SCxrDDf15ueO5Ay+vTbPlpwVB2LSQu8EsrgtgtNVM0P7TVnlZR0nwSLm598pbK31gaqlaE+0LKbOiPe13PaMilMZd2OU0iS7ZHWbPD6s7P8e45YsG/bfbKhDDwbia6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 9:06 AM, Shakeel Butt wrote:
> On Mon, Jun 08, 2026 at 07:32:42AM -0700, Usama Arif wrote:
>> swap_cluster_readahead() and swap_vma_readahead() end the readahead
>> loop with an explicit lru_add_drain() call. That drain is a leftover
>> from 2.6.12 era code and serves no functional purpose for the callers:
>>
>> - do_swap_page() ignores LRU residency for the readahead folios;
>>   it only needs the target folio it called swapin_readahead() for,
>>   and if the write-fault path needs the target folio on the LRU to count
>>   references accurately, it runs its own lru_add_drain() at the
>>   wp_can_reuse_anon_folio() and do_swap_page() sites.
>>
>> - shmem_swapin_cluster() immediately locks the  returned folio, waits
>>   for writeback, then operates on it - LRU residency of either the target
>>   or the readahead folios is irrelevant.
>>
>> - try_to_unuse() likewise locks the folio and calls unuse_pte() without
>>   depending on LRU presence.
>>
>> Folios newly added to the swap cache by the readahead loop sit in
>> the per-CPU LRU folio_batch and will be drained naturally as the
>> batch fills (FOLIO_BATCH_SIZE),by the next reclaim/compaction
>> lru_add_drain_all() and so on.  The unconditional drain only
>> synchronously flushes a partial batch and forces contention on
>> lruvec_lock.
>>
>> On a 176-CPU production host running a memory-pressured workload, this
>> path was observed to call folio_batch_move_lru() from
>> swap_cluster_readahead() ~28K/min, a very large source of LRU lock
>> traffic.
>>
>> This is a direct continuation of the cleanup started in commit
>> 1aa43598c03b ("mm: remove unnecessary calls to lru_add_drain") which
>> removed the equivalent drain from free_pages_and_swap_cache() with
>> the same rationale. A detailed reasoning for this is present in [1].
>>
>> Remove both drains.
>>
>> [1] https://lore.kernel.org/all/dca2824e8e88e826c6b260a831d79089b5b9c79d.camel@surriel.com/T/#u
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Thanks for pushing this. JP was also looking into LRU lock contention sources.
> Particularly we lack visibiluty into the lru_add_drain_all() callers. The idea
> was to add tracepoints to tracks such callers. (Just nudging you towards it :P)

Yup, I'll send a patch for that one.

