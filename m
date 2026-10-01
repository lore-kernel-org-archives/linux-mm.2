Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E19BCA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 10:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464776B0092; Thu,  1 Oct 2026 06:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43FBC6B0093; Thu,  1 Oct 2026 06:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B956B0095; Thu,  1 Oct 2026 06:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DFD46B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:34:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F25F2A037B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:34:53 +0000 (UTC)
X-FDA: 85273699266.28.29F2C3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 35CFCC000A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:34:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cl+T3eCi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790850892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpnAERfwWcpJPCQJOiMYKzskczfBLAmXZOfaiGrPW9s=;
	b=CGRAz7wb8bEfBDZh0DUkW92fcFg/WdZXiJU7/Rl7GJsWIU81u5djdGEjdXo0Ufc4hUxwNK
	D+Cl2PaBP748bcCRdBvFJxVyV/VIEOJS/aRpylSou2zRlsjq4QRcgQ3eGD4k+iyDtw4nnh
	zEpMxQECSRHNLTHb1YQEg7OYIun2u/Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cl+T3eCi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790850892;
	b=VPM3dzv7ni98HXZCbowlrXK9NbeceVvond4IXUdgOjS8layZQ3R8onXJ8ZInaOIKpFVfp2
	oq/VIqcXU6CiE1jfpRoF4Zp+jYta0aIUVLldb32rXBhOTRcBJGEmZbzdW/eCyvN4FTIz4P
	AgfFF7O3Puwvx4CUU7aH7p+5T7qDOyE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BA4241A5A;
	Thu,  1 Oct 2026 10:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5504D1F000FF;
	Thu,  1 Oct 2026 10:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790850891;
	bh=cpnAERfwWcpJPCQJOiMYKzskczfBLAmXZOfaiGrPW9s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cl+T3eCizG7WiIcmVcH8Ez5A4rlX6y7uy2BLgB7lq20a7ulfYXUm64BsNtPmRr2N0
	 s7bjBo1ykwKVoa9BSdZDoo2u9ZLi9Fvaa07bk4xm6dPjwvMPSD0rIvkA1TIBMp27F5
	 +iIyy+4G+tcskX6T38MAAkG49ESye8v7pq/44dmtKP1rvHXDkTucSE+AqAwnXEbaJR
	 oXkNbB92rXh4v+4m/kxJLN6zOrnEoNo7gSIey1ZgVh/GGbNq0LGvlY5brF3GLA+7Y2
	 8atinXm/CykmIiPli6VB37IBghZQBo2QIDfWdgSVCmHNlFV1YhodM0lQdLmnWVMRLL
	 zOKG92U7/DmNA==
Message-ID: <742ced29-d490-4b33-8fff-d6d503c0ee95@kernel.org>
Date: Thu, 1 Oct 2026 12:34:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] sched/numa: scan read-only file mappings in
 tiering mode
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, matthew.brost@intel.com, byungchul@sk.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, osalvador@suse.de, raghavendra.kt@amd.com,
 stable@vger.kernel.org
References: <20260930112206.205083-1-gourry@gourry.net>
 <20260930112206.205083-4-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260930112206.205083-4-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zrdu7njuzpfxyyo8icqt16xtb1tfkj8b
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35CFCC000A
X-HE-Tag: 1790850892-697344
X-HE-Meta: U2FsdGVkX19yekTT8WJlrkhI8qRP1+nSAo0XUutVYERsAoLOvg5mLfkvK+FdeCD1spjRNDFz+RhJnVG3x8Dpa+sDdGE1EgOKP++I0pEduAHCN55oo/2CksUBkx4igwyAc0Wo3e4TvYB0ln1ZwLzG6kQSxPqeW9g1o1SQTTnYHLvzXjXKfOMJvQbOop0r1bCjBJuVCJijsI40ybZXQhKcpElx/VgIpNAhhJsdBvUuhBspJgSwIndtgwDa5KNiuvnHCmVA46F5+nZ+TLsEP4m04AQGWUf9oD2fylVLYGlee37nXphKTCmi1zHUMpzYgu598/VpZ5q2VjZk+s0HwSnodoxTNdK2XvhOtVrvWFwcJGNfmdO1MgI7+i27/3/gRQl+lFrlj2zGiqc89v1EFAEyrGxDDo2sPznMxdiKbUhaPkoJz10y6mgwO1z4Ab5YXLWh/6AioenB+Qorj3m0IjNHnHBDiz8lRWgtQEaFwihiqzaNHTANOhfYXMzWSmqWGm7VvupjCWH5CacPeVhnmMsVoJG8dPXy0n32QlkbTPMt6rY2ZVYJy1ZO68ytuHjcqtuRSeZ9ftV+yjdiAcHeAVV8FJhzY3ugEFitcI6gj35CnEfusW+FjQUkVu2q5ZGVmYTKXKC3RnUlghRF2tRoPPPNQlf317ZttjJyRfnEybstMGthjVvRF3HYV3Ci0ZxHKvexhew9zzEn2qX00v8SHW8/7Dio4JMC5HSC4H0qmEU8EJ1MV7TgMuOuTJfjjmd0eeFOeGL63KGJYbCbq4VNM8Nkqu96P9v0xE6uVjrxtusD5LJupuO13stpBB3EloVj0BOBeofWaH41Weva9JxJhHvp6dWNCykOauEtvye2nz8ajG8CyvzGmnpeVafrewg9DPZLCh8jaOAsJdSPjf4/y43LP4yjdBNLxbG5pqvH4FJqIF1M+IZ7uDBsanOJbQR8oCNjgaZ/hy9Ll82v0CGWObY
 VPstoU/I
 eOgxpACZZhud7/ZF/jHVYsbOxHDYNuUnhNcl3tGllEBr385C2+TDfqYDEjxI58EWIPGJUnYy2NFMckzoeqLNVu9Z34MgCxGUsaTcaB8IqatHGhpwAX9oqIPULWoDGOEBoFYfJqEztTAsSAy2W2/gkM/txiPZSs6ybJ38lCAWoSsUGWoWnPgWUyWl2yxtG8dMR+CBveULKwnYRLLoBIVQFa5xWtJjSoEn2eUlpp1nlpQN/RAaq06bh18owsGFupPOC6zOSoEFWAjR4pM97C+FRe1C6vKlf6nt1EHCXnPpLdfFUt46aZ+uM1IA2rD23kXuV1vNufPJVlFZEMDxSLbRx3VqBFK/0d9EBz7u54K2Gkk24Fse7JetY4n4QmWCgEa8w0oZl1oMNr8jWaEIJPsV+uSjMrlt5VxXaOKXR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 13:22, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> Commit 4591ce4f2d22 ("sched/numa: Do not trap hinting faults for
> shared libraries") excludes file-backed read-only VMAs from NUMA
> hint faulting to prevent east-west placement bouncing.
> 
> This filter hides hot file folios on slow memory from promotion.
> 
> Scan those VMAs when tiering is enabled, but make their scans promotion
> only to retain the existing restriction. Keep the historical VMA
> predicate unchanged for backport-ability.
> 
> Decide the walk type for each VMA from the balancing-mode snapshot
> taken in task_numa_work(). A VMA gets a placement scan only when normal
> balancing is enabled and it is not a read-only file mapping. Otherwise
> the walk is promotion-only, and without tiering the VMA is skipped as
> before.
> 
> On a host with 768 GB of DRAM and 256 GB of CXL memory running two
> database services using ~430GB each, 169 MB of their shared 185 MB
> main binary accumulated on CXL and was permanently stuck there.
> 
> With the change, the binary tier residency tracks its runtime hotness.
> 
> Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

