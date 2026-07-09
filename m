Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1F9BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CFDF6B009D; Thu,  9 Jul 2026 02:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981B86B009E; Thu,  9 Jul 2026 02:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8497A6B009F; Thu,  9 Jul 2026 02:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FAF96B009D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:27:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3C5D1C3522
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:27:18 +0000 (UTC)
X-FDA: 84968256156.12.B45994E
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3045840002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:27:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MaLwDGfs;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783578437;
	b=AhCnGS1PI2ve7zxzJhawoKFHDjT9fs2hktgqZ8F5Xe+cXVyBneeCjLRnTttGzNl2Dg72uV
	iEBS6Vg+i/BqIFLbaWD/ygm/G8ZIvhmgGGj5gTRuvKpedxBIIfBasEwCqsu8OjpRrny97P
	MUylhYgWe2gCEa6gTsd8Yefg+uonO74=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MaLwDGfs;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783578437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CkD2tiWn+pr0tZo+GQDvfH+2NUFzkCHzNiGBy7j67/Y=;
	b=4eUH2R28Uf4sHj/V9nVmLdxx6o3lFpbb0Hdrm2LrdPM9Tl8+rltSOmZbpYSrdRB8ZsU6TP
	s7OF1DXQENNpCoq6KyD6FEhtU315x/nONenbOl3y5a3u+sut6e5O4rBvR3XHrJt4Ogcl2P
	7DdW4mPoV0+qOYmgo/2nMPwyCnrmbCc=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783578434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CkD2tiWn+pr0tZo+GQDvfH+2NUFzkCHzNiGBy7j67/Y=;
	b=MaLwDGfsMHrr6WI9nZ80gg6uKittEzAonTv5k+i1wS2JaU2OYnWRayeIT6DPvKYy06LvsW
	mg8DPbPD+0CKavxmh6NZa2DRv0fi9cNzzx+6ZAMcKJoPJRTA7yf1EWYjRIA7npMJohJHrH
	ns0XCYMx5HwNfbDBR6OJGbUKobMiXY0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 09/10] mm/sparse: remove bootmem_info.h include
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260708-bootmem_info_part2-v1-9-156ce4986598@kernel.org>
Date: Thu, 9 Jul 2026 14:26:36 +0800
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-s390@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <1E36E995-7F30-4782-9225-9909D9AB9BFD@linux.dev>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
 <20260708-bootmem_info_part2-v1-9-156ce4986598@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3045840002
X-Stat-Signature: 9ozng45yrpiw7tggehfbow1ktc1nqhdp
X-HE-Tag: 1783578437-470157
X-HE-Meta: U2FsdGVkX19U9g5xZYjPvglIHneti/qDfvEDtmRRswRipDA+6nUHfNN4BPhqAxO5SwtAXbimxy38FtghrDUJtnguA6RbIR2otNvAPhKZjGoebAjW6BOxxx0qVb4ZrM0qo8YQ3OrDMt6iWeFiGYVi6QnsZX///JgDEIGYlyYPUCRIu48DMTPf4e5Z9WYTeaqTtvSTwaxEO96NZsmp1icFEeWhL6UicmnPB1UV8NEDcrzwoShmVok5aXE3E3PKeN4Y+6utxD+gIHy8oYuPm8gQW6B43bFrtWL8Wuh0j27AaSwrlMi24FN+25IPKpK/9kAMAODtIjPECeyV/UVxg2cfx2aNgAFdDloHBf5hjsvRpZMSHjf0UovhFkQaSIo7hmDdmGs51trezg16kY/dnEuDnrHqUL8PJJEqUk7/aNiqSaqiduEU3vFPQEW+NYm2yN1Ts91vFQuBjc1z0Bfuw4R7htt+l18tdMXPmgnrkS54pzo9vuKc7fW4Rv41vqJXYgcDmtK4iSOBk/izkIVXbUwMSJNQPjWYZxkfdF1JtPOgQ94mamGTA74/knRdSQWyiszuc4vNM+fzDsB5aCwL1CH/RKVxvhT9Dyj0MBJnGTNdVQYyDxHeiyeVfoU3in+yTTGeCNJ/yYY0uTtXrAAEXwqk7i3s7kLo+ElO1a05fThOo9TU4MzhNtmA3UbdDjktAwrQBwINcLxlwN9FLB3slLAIVIQWEi+INo0LTB6yOhYZIWdsFfSHDb8y7Yfdo6XVHI/3f4DYgRn3K63BzH3S0fOkTL/Vvz7Y3SuBdOAMbwcdav8Mf751AsspXsMwtpnvutJkov1QoykmiZky3iz/MoR7hXlT6bT97ikl9Hgf8LZ3gAJn7a9PptfNC8MYC5Ifd9XBKmMPlYKM8ep0lAwWK5oKIm9qy8e2k8f5nBBVHg1nzogS22u7piYBhDxQLPF5bpoRkxes5bxPZfQYo7+IPQI
 /amA6hQp
 r8mKuucEMZhXS5/OlhWUM0vtgPUblZyGQ7I/9DO/4dFtHm9qC1Dvc2j9uE2g9+pR9lc07/RFinxAzKBx0mBmy+mdFhR1Zq+Y3BoemFTOqMee6W+uFnWSgVh+q/CxFMcteglmC7xyLmUIlxZeT54GCvM67AviMWM4eiLh8cd7CTkyj9AM7luS2XaRQTZUAXP+oeOTD0ZoInuvdZAOMkeNG4peRvE8xfsbb8UHBlQF4ZHNDuXm+RqQtdVDgN2Omqkw3nC4asBvIgZQmBiL73pwu2RymsItLe3+OT7rUS5ZpczSBHZaEUKlbsFRqlkln8s0PIS+bkGclzNCdFPw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 8, 2026, at 22:11, David Hildenbrand (Arm) <david@kernel.org> wrote:
> 
> No longer required, so let's remove it.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


