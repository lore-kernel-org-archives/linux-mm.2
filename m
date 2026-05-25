Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E6E6CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 18:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B5A6B0005; Mon, 25 May 2026 14:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901A66B0088; Mon, 25 May 2026 14:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E666B008A; Mon, 25 May 2026 14:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71AB36B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:58:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC2A8160A2A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:58:10 +0000 (UTC)
X-FDA: 84806852340.17.7318214
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1DCC81C0003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:58:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=u2w2gr0Y;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779735489; a=rsa-sha256;
	cv=none;
	b=tsL18asSdreKNgp6u4qMWBx8jmQ2CbfJ+xKoja9BAkY6ad6XJUsHOIlBPtid53y45SRjFB
	lp4lta+qoQIUbeupOPlJTfQiV1jG0iHmuZWM1nncwa6gJMNp69AuEqttfyrcEEYeLiqeCL
	q1CWbf+GE2VvwD7Zas1namZgDdnw+Nc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=u2w2gr0Y;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779735489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5h0W9zXzP3LFNcoEiplpRZRXlPDTTCik1KUxrC76J+k=;
	b=q3PUEASeOkkj69RBz85lquWJOHN2j95rm3cqJd5Nt8aEz0tVPruBAcVwzxrL/TGtK/cW9a
	k+hyr8SOs5AJNoejf1x42O89vOg02LZHrFaOTSDirWXRsU000KrqbHlgiS7oOc1N4uxpt7
	gtgxVeYJRCBsRd8XPyQwhg1wRG4ha5o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 71A0560008;
	Mon, 25 May 2026 18:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892C61F000E9;
	Mon, 25 May 2026 18:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779735488;
	bh=5h0W9zXzP3LFNcoEiplpRZRXlPDTTCik1KUxrC76J+k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=u2w2gr0YGcHnt9X/m+yRa0iAOu2xjQP3QaGLS7+kOpjoQt9aXLflVESz1avgMeY8O
	 J40y+Hdlu1CbOIxP6Z/l03uL9wDAdSkpoJqsjGZCbpmRowzpfnPrKCbuFW+oMpOIvE
	 9Wj2D6Ko6aBx2M2RceQuFaqxq2m6eunySfPYjU/g=
Date: Mon, 25 May 2026 11:58:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Peng <zippermonkey@icloud.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Barry Song
 <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, Zhang Peng
 <bruzzhang@tencent.com>
Subject: Re: [PATCH v4 0/5] mm: batch TLB flushing for dirty folios in
 vmscan
Message-Id: <20260525115807.9655b788356bde7a9899f9f5@linux-foundation.org>
In-Reply-To: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
References: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1DCC81C0003
X-Stat-Signature: 8nu4hy1ynj7u1igqmpk673hpowncpru7
X-HE-Tag: 1779735488-308079
X-HE-Meta: U2FsdGVkX18fXr56tROQglUYBOvkqs+k2Omr6mj2F32B+Xhygf9QFdHysjouR2h+tBqqsKPtp1ZKROyV5KKdNp4WRLLx1+5fUe+AIW12OoTx3DeHXqDeDimGO4H0e0GOlQIVm9meV2TpxdyRhWUOsb3LRrLoJmbrehHROS9gKCSjLMRNe/WVTphjoR7Bwc6vspLBXkWnPWxWCujPH1mRZqmPQt0xAK3kWoAojcPUmjvpItSbdiCDI9w1LOPQj6uG7QFUx0x7s06zXhtMJPffQAhwcgHg0ZM/Mym7WMdWvtF4j29KOGLhHcPKZjt0ZpR4FOmS78pUWKjqzrmPsfRjzg5Sg5KKzWh3acPT582hAUudrz99eyyWv34MQSsNwkOruENSdRHXb7aawQ6697le5JYMtU7L1eSwq83CcO+z4juJKjdJql4OG/ghDaGkVOR1Hz7JB0DHA9OSP+VLBngYIA2jgl71u8GSTyWayVK+LlNroe5LOIRn+CsvaciO39veAYMCjRmFQClvcIqELYgWyvAnP6/l1wr6Wc+/g9gQVZyy6G9W6McNEo8073ZzIbXmfCm8JanKhMy6sXbp1rJUceKynhzdFUwBTIIpCNO084cZiJbXUItGdNmMUf5GAS8xnB6g7WUm8vgj+j8txyKJLNwXvDHPGfFgNrjLm/UcND01inu0S2XlfqbLVkEN/a186fW67PKFc02P+qb+DKXDuWEVNAaDQv9JghjV992dgpbo5B8W6Nu+ruVMjagF0rJHE0roCOoQ8iIVL+h94ektdx9PVHhQLvf2Pc2H4HJZsUYPMHB2V1UigZ8SEmKcpxK0TwoKv7oBX6X3KKTCPGUjTrmRzGd3VbDjR57/cmJj6Mk7QXUxKThFtriAkqv1662bGV85CzQc3cXtiADFqfpl7JB/o9G+fZWYIqrqCqAI4/h4suzMACvk6z/EER7khNSto8Kw6AXjXNxyPF45Fce
 tzyQ4OHq
 M//BGJ7M/lnggBn+bCCt1DZyPmrBQhhjufQLfW1+J6ftvFcO7sDXd0dmALszgtFPMjApkk36Ud/iAy7ntzuPhoYWrv/IAOtcNvYQWnGi6IJ2l68dOgf/n855RK4/3fXBNPHFQTsCgIPUyu6k8/fOCGVDXgTD8ibB5gWlA1NNmkW5//N6uHH/0dFV4tYSflj/KsyluP7VPMQypHecLhXTN6Sm5EgYu4rh4V5u9pOnKJzuajt9e7mGwFqbX7rph45kpDn5wEaMaSo0vtmltPUbxvRJaj8kPAkhppmUhcOR+nn+gbmYH5Iu4yZtSb6hDDfxqLlIx7QBQO2L+MAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 22:57:16 +0800 Zhang Peng <zippermonkey@icloud.com> wrote:

> This series introduces batch TLB flushing optimization for dirty folios
> during memory reclaim, aiming to reduce IPI overhead on multi-core systems.

So often we see such good results from batching things.

> ...
> 
> Testing
> -------
> The benchmark script uses stress-ng to compare TLB shootdown behavior before and
> after this patch. It constrains a stress-ng workload via memcg to force reclaim
> through shrink_folio_list(), reporting TLB shootdowns and IPIs.
> 
> Core benchmark command: stress-ng --vm 16 --vm-bytes 2G --vm-keep --timeout 60
> 
> ==========================================================================
>                  batch_dirty_tlb_flush Benchmark Results
> ==========================================================================
>   Kernel: 7.0.0-rc1+   CPUs: 16
>   MemTotal: 31834M   SwapTotal: 8191M
>   memcg limit: 512M   alloc: 2G   workers: 16   duration: 60s
> --------------------------------------------------------------------------
> Metric                 Before        After             Delta (abs / %)
> --------------------------------------------------------------------------
> bogo ops/s             28238.63      35833.97          +7595.34 (+26.9%)
> TLB shootdowns         55428953      17621697          -37807256 (-68.2%)
> Function call IPIs     34073695      14498768          -19574927 (-57.4%)
> pgscan_anon (pages)    52856224      60252894          7396670 (+14.0%)
> pgsteal_anon (pages)   29004962      34054753          5049791 (+17.4%)
> --------------------------------------------------------------------------

Nice.

AI review asked a few things:
	https://sashiko.dev/#/patchset/20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com

Thanks.  I'll take no action at this time - there's no review yet and we're at
-rc5.

