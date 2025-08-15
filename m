Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A9CCA0EDC
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 01:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443179001FF; Thu, 14 Aug 2025 21:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3BE9001D5; Thu, 14 Aug 2025 21:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332589001FF; Thu, 14 Aug 2025 21:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 228E99001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:56:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC85814080A
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:56:11 +0000 (UTC)
X-FDA: 83777326542.13.781E89E
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf23.hostedemail.com (Postfix) with ESMTP id 96A1F140005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:56:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lURjpKAA;
	spf=pass (imf23.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755222970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXdEI8668zYGp/a36im+Wgc5iWXhk6DJ+ceX7JfkERo=;
	b=cMDEyfe6bYG8HT5rBL51ibnLs2+PXvl7FwLNhMWsSyvZn/se9S7bQUu3Ye7BtAVvzX1Sia
	yT/jVuvIeKzVHk3fUtJh+Y0FlPwEHyo3nTItYotni7JYn3b+VXCZ06TXO1YKLTpQ7oP+Sr
	zYepWiZ12B8TkM0yw7ZMTsVcQxW4iFk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lURjpKAA;
	spf=pass (imf23.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755222970; a=rsa-sha256;
	cv=none;
	b=lsPiPr5t9qvc4tBdaqlduzsm9+DvrlT0NYs63p5Lx7YSRaPD6yB3+aWimRsKBinyM8LFMw
	mLkq2DH/oVfiDNxEMV91eBHU83/6djSPsRGMh8C70AAFVa+HdlRkpLqaRdBbUQF037mz1m
	qJX8DOJ17z6Q1yqQOdfHJJmXA7J0iHk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755222965; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=fXdEI8668zYGp/a36im+Wgc5iWXhk6DJ+ceX7JfkERo=;
	b=lURjpKAAhiJc/v0g1rionHyU0T0ZzX8NiUUZcIPEsYFfhhzGFVmvOyF0gzIK/K79UvmChGuoQjHmvn9/rwO6CPkTtqBcTUNDWfAkZ5QiREZ5ZK9bw9VDS9nQzLvraLs5aN9uyqupi7Z3NAzE5ecbaj7EgiQtMnYpFNTW1PJlGzs=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WlmqoOh_1755222962 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 15 Aug 2025 09:56:03 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Bharata B Rao <bharata@amd.com>
Cc: <linux-kernel@vger.kernel.org>,  <linux-mm@kvack.org>,
  <Jonathan.Cameron@huawei.com>,  <dave.hansen@intel.com>,
  <gourry@gourry.net>,  <hannes@cmpxchg.org>,
  <mgorman@techsingularity.net>,  <mingo@redhat.com>,
  <peterz@infradead.org>,  <raghavendra.kt@amd.com>,  <riel@surriel.com>,
  <rientjes@google.com>,  <sj@kernel.org>,  <weixugc@google.com>,
  <willy@infradead.org>,  <ziy@nvidia.com>,  <dave@stgolabs.net>,
  <nifan.cxl@gmail.com>,  <xuezhengchu@huawei.com>,  <yiannis@zptcorp.com>,
  <akpm@linux-foundation.org>,  <david@redhat.com>,  <byungchul@sk.com>,
  <kinseyho@google.com>,  <joshua.hahnjy@gmail.com>,  <yuanchu@google.com>,
  <balbirs@nvidia.com>
Subject: Re: [RFC PATCH v1 3/7] mm: Hot page tracking and promotion
In-Reply-To: <20250814134826.154003-4-bharata@amd.com> (Bharata B. Rao's
	message of "Thu, 14 Aug 2025 19:18:22 +0530")
References: <20250814134826.154003-1-bharata@amd.com>
	<20250814134826.154003-4-bharata@amd.com>
Date: Fri, 15 Aug 2025 09:56:01 +0800
Message-ID: <871ppde4b2.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: qhb385wjbkfccigfa67epppai3prkfyo
X-Rspam-User: 
X-Rspamd-Queue-Id: 96A1F140005
X-Rspamd-Server: rspam05
X-HE-Tag: 1755222968-464309
X-HE-Meta: U2FsdGVkX18pwylzwF/wEVeU8ct4m9ClLyd9/kXXMtIvJSe7LMaaegs2e78/XT4oR5wNLOsCNHsDExiGgxPobYlB6QJNTOeYeCWLOLfoMXLLC/bgjGwuSmiQSvPll33Nrw5olckAYNLp6cHC0cB1elp9dfEt1xKFiwtPUNdcDG9MQzGXLy89NAXshmTrMPV44ugv4ZURIePpBpX+ja67ovMRiMDR/1A0sE9MzEkrEVoWAhv66pG/ev2mvSjmiCEV1hu6QpLBS1IeXX+oOsMBfXdkw1vsQKzJJ2SMcglqLGed5RR4d/O4RLJJZntq3J2DgXrHJmPkgEBx4hTbSSRK5JyKycTnEiYGDDRHXMcMNmXGxy8YVlwP0GCkwR2DITTKywRFC9LuGymdUnukygST3T/aO72/OtInYcy/o+TbwZZyubjPFY/+FBDYPLCMBGOLvMOSNbZvUxrOZ5prEuusg5X/kF3KRD/K05loryHgCMhOopp14gWDY9Aq7v4v7TkEncAlfHCU2ae2cOcwBeEc0gjYS9HlOwpI1Hj6oe//82Iu+Na/ir0XnFVxfACEFLKzDqJFRfOAPf5kJ2WSLBDf4FSrNZQrT1r2SqAoST2olJChGkivbYIc5eu0uBqz3sjFAi1DnYEffSDECZOhXs38Vg/6X/puNMdkMf/R2Kb2FWgRTNeX9UcrI4uAWepq8iR0brgOY0wtUC2j/AYDiMEblxGnCAxht0WRAx8rGAQvcQNmH9fqL+tzZFOv4YiDAUtNrJSLFZJs8/H3qzhtJ3Mwy60oBAzR0t8+n+r79KTXpuyyhPnZx1stCZQSWLYjsKxTCIR/hyw50OCsIYQLBvzPwZsq3rqhazJVgxzqjEnl+iMFRmYFQfTk6ous4WTx/kgz9peq/GFaCBQnBp1yio+lj8aTWuGfH0Xyk68SIsLdv4R/z16+fTHivLX0lzz8ReUsQvIgjkZUZeoRcFjHUxV
 zLcT6E82
 7M74AQTXLdrFt1pVySAngfwWZqBWdt+FLwa5nxBDdhdSVPLrCHXfv4OLjxKMHqYKali2sntcWIe1JmwCSsiNqqfkK48n+QbdgVTxYifesLqeaIkVr7+UIC5qjnu9TxUejZEh5N8coX/Hq3EdjuLJRYR15UX4qYp+dicgYq4bs/ZXYvbrc38uJdc+3KxdW64QyDQncWFpfbSq2sgHR6jOfG/PwXLKKj2g+p2g+uGYz6u5XoHbjTZemzob039pOP/a5ydll4IjsR3j0z0TZZ/C5Ehe+F/cEJFWApwJITlUejRqBL1D2KoT7ydqnhMdMTLERae1kcq1Skh+dns4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bharata B Rao <bharata@amd.com> writes:

> This introduces a sub-system for collecting memory access
> information from different sources. It maintains the hotness
> information based on the access history and time of access.
>
> Additionally, it provides per-lowertier-node kernel threads
> (named kpromoted) that periodically promote the pages that
> are eligible for promotion.
>
> Sub-systems that generate hot page access info can report that
> using this API:
>
> int pghot_record_access(u64 pfn, int nid, int src,
> 			unsigned long time)
>
> @pfn: The PFN of the memory accessed
> @nid: The accessing NUMA node ID
> @src: The temperature source (sub-system) that generated the
>       access info
> @time: The access time in jiffies

How will the page hotness information gather with NUMA balancing hint
page fault be expressed with this interface?

> Some temperature sources may not provide the nid from which
> the page was accessed. This is true for sources that use
> page table scanning for PTE Accessed bit. For such sources,
> the default toptier node to which such pages should be promoted
> is hard coded.
>
> Also, the access time provided some sources may at best be
> considered approximate. This is especially true for hot pages
> detected by PTE A bit scanning.
>
> The hot PFN records are stored in hash lists hashed by PFN value.
> The PFN records that are categorized as hot enough to be promoted
> are maintained in a per-lowertier-node max heap from which
> kpromoted extracts and promotes them.
>
> Each record stores the following info:
>
> struct pghot_info {
> 	unsigned long pfn;
>
> 	unsigned long last_update; /* Most recent access time */
> 	int frequency; /* Number of accesses within current window */
> 	int nid; /* Most recent access from this node */
>
> 	struct hlist_node hnode;
> 	size_t heap_idx; /* Position in max heap for quick retreival */
> };
>
> The way in which a page is categorized as hot enough to be
> promoted is pretty primitive now.
>

[snip]

---
Best Regards,
Huang, Ying

