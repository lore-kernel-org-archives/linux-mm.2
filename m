Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34259C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF506B0096; Thu, 27 Aug 2026 03:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0804A6B0099; Thu, 27 Aug 2026 03:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0AF6B0096; Thu, 27 Aug 2026 03:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFE1A6B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:34:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA42D1C1B14
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:34:09 +0000 (UTC)
X-FDA: 85146235818.28.AF9DDD4
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf04.hostedemail.com (Postfix) with ESMTP id 10D6240004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:34:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EulLblZo;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787816048;
	b=W04uIATY/Jfx2tytFynK8nTfG0qCrSOP/c+YWQBSChScDeQsjbrqfkcYSalIEvphVh91qq
	bDumIOBlrKHcthct+kzHE0fA/mZOm/qGzyPRbq11o/npQ8GkaeQzojbFL3UtL7Q9fqeeb3
	aUubWNuEWbxUQiQ8bQ4Y6NOUuiSRucE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EulLblZo;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787816048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0D4/pZY+ymvH1WHGZfWDEIPydoo5F42QzbhSUiRWkQE=;
	b=roPBgLSQFyYIHGa8g5vSkkQF62VzDz5QHFU4O/mvxB/hbPCyabGQzzXy/RhJgil0XZYV2Y
	A5+XfETdkJR/yrPwm+jYAjt7PH8qgp7NJzzDDoK3wZc5kDdpTvmR3dKZZgFHVE0ttPIaeW
	I49tFns47AakBpvbbLp81q7FdC2ZRrw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787816040; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0D4/pZY+ymvH1WHGZfWDEIPydoo5F42QzbhSUiRWkQE=;
	b=EulLblZo0jAHikegzBOQR+R7qnuVgufV255MfynYDLlDDe2cMjrxbk5oZdLLbrabv663mz9RQAJs17mPGfFzJ9Wff2XTqcVVC7duvlC8HFOLXSlkoMBRstRv/hrwmIN5kDLC027LzDAWpiQDEj9PPoqEG2I4+Ryel6+OT7Z3XAM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X9j1CkR_1787816037;
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9j1CkR_1787816037 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Aug 2026 15:33:58 +0800
Message-ID: <c8406629-0bb0-4f79-a015-70e39037b8e1@linux.alibaba.com>
Date: Thu, 27 Aug 2026 15:33:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm/migrate: copy all referenced state via
 folio_migrate_lru_refs
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 10D6240004
X-Stat-Signature: u5f1g9a6ux3z1xw4h1fbzq4iktxejm4d
X-HE-Tag: 1787816045-330846
X-HE-Meta: U2FsdGVkX18yZAWg6xX7PE931TSiKf+XwQ59kxRHHzb/bWQ/QnCByM0nRRGWoKC3TxY3l2CqW5gULs1rYwgYzIUhMRtUzZ4o4hjKV1GsDfwPk8M06UBngJIQTzpWMPUAQ2MoZj8r8yNhZ0l8WeBMl3+kyGBJuSGgKCrAbAODdwvYKspulGzJsvgwfU7xeJvHj7p4FB/xMcnkVvnBs7oZAWiW1RcNMGqFk/T3Q4Uo7SDKnJVRK+qYwBVnaOoBGUbtFxQASN/5qIVDjcHrKtmeRtNEPfPRSa1WjJ+qvscYmGVt67L+9u8/M+2GBnUuFQ+YfT3i7SlPz3LVfDCgtOnCRJyyMosrzBpnvKakaPm1P3ZRp9sl+Z6OacATPafgvE3wboSz14Q9pcEb0ZWZA4Yq0JBHbzV1Dq/HRxW9vf2AHyM1PFznVPthOcmgFF6RvwSKLDwaLhUXADPHHtaHydTzASEQOqlyU47reU7JU8NMyvbNCJ5n+7rd1T/eXHERo3XlCdyO5aJnKeTm/1xPCileOlWZ4JbvaL29jKuWwX2SfwdRaxVOmEHJ/LBMdXqgqu/3O9kf6oXQkLKbnKpCJcVv+AN/sqAAsrnLsD7jRQCZktx7XDJvt6AFBnASzKnEwTCppps1p2jm8kEIMt433Vzxm0O4DowYG210JcSIvkck70TmJAJwiMhJpbx2kj09I82XZxBAfWjW2oZS0hcFUxG365x5rPGY0/E3HOZpE2oPnWw1J2IgXveI4ADrfAz2/46rQnURv6OYQ8wRMRApXZFV4NgjHNQKTXjLSA649yZjrgaz2x9xKubbajQTifJhP1WexLSshPMCL23/wNJX2P/tsUyULeYVhF+zmhPk9IHnXCSkB2can6ZksdjoS9SU7pDJG4P3MWYXt6Q2IvZ6smdV4Paft9pSNOyuf3SyWcnwmOjGkHSJe7mmbHosWldevygHlNYVh8o8GpLb20pFFHM
 iy4Effu4
 eojJXFrEvVkR1u9w/Ta6ztor1g0YMmYFhTuc7jhcTqAL4GCWCxc7J0psC1j/NXgYvmEOKinGVFY9nGtRxmG0zhzQj1x4uin4FEUj3zRxK0p6wz5dHchoVPwa15k63YARDL7jQSxOCLA+sUP9cDMmIN0s38cFe2D27QgkgEzZSgg8nhJJf8BLXWBhZv50nejbbZtOb5Ddwbin/y91PioXHB+wvKtSHNROErVvsweuhgSfIl5QgoIji8pzcB8GVF8BnAjMiAkJym1t0rvCC5+S2zJwkG+oHnmwha8CsyGWoknGQnQxjrtrLysQv2f2/BJEs202k1yhDuuQw3/CQpdaB7jUPjg/FUo+S+dCg+RF5XraUNCHGClHR//j9GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/26 1:53 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> folio_migrate_flags() copies PG_referenced separately from the MGLRU
> refs counter, which folio_migrate_refs() transfers. Yet under MGLRU,
> PG_referenced and the refs counter bits together describe the
> referenced status of a folio.
> 
> Consolidate the two: rename folio_migrate_refs() to
> folio_migrate_lru_refs() and let it copy the complete referenced
> status, i.e., the MGLRU refs count including PG_referenced, or just
> PG_referenced for the active/inactive LRU. Drop the open-coded
> PG_referenced copy so the referenced status is transferred in one
> place. No behavior change is intended: under the active/inactive LRU
> the extra bits are unused, so operating on them is a noop.
> 
> Transfer the reference state first, before the destination folio is
> marked uptodate, so a concurrent lockless reader cannot have its
> reference update overwritten by the copy.
> 
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

