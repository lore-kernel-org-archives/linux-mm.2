Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0D25E9410D
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 04:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67DE6B0088; Tue, 30 Dec 2025 23:26:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C159A6B0089; Tue, 30 Dec 2025 23:26:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B224A6B008A; Tue, 30 Dec 2025 23:26:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A37446B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 23:26:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C389160494
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:26:34 +0000 (UTC)
X-FDA: 84278479908.23.D2D3FD9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf08.hostedemail.com (Postfix) with ESMTP id 53393160006
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:26:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AuGgc/KF";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767155192; a=rsa-sha256;
	cv=none;
	b=ibAxCeR/LycqYQFCP23gk+VD5tyvG3M+lPtZGPXFvtU+DxZKvlRweVrN3HtbT5zo7ZA9Df
	t4ifqM4cbXGlB4zC2G855TY0i5+ZQJcMa/8+pQJlxEGLO9MWM+pwUa4ACK0Di6rS2z7P7D
	XAfvHVtjlcQiHCYtvNuuYtr2GoNwqiA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AuGgc/KF";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767155192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5eEMb1r5SYPWRo3e4xJYtVpBh/B6B3RK2Kc5iZB6NZY=;
	b=sseoWpmn1RCOet4uxval5MICwty76Onm0q1gWZy5RQ6PaM3/HlShC09OB9b8AphokdYcfy
	73Qo2kCk8mlRu9Q8OFycBIziqrkgVsUP4PfnKwncmHBlbT6FfyCYVbkmuuPAsCRhlrBI1v
	NL0aYoNk37++Y8W9XsZBQg4VW1q7LAM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767155192; x=1798691192;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5eEMb1r5SYPWRo3e4xJYtVpBh/B6B3RK2Kc5iZB6NZY=;
  b=AuGgc/KFhVikQBykAYNK2ekOXvH0/uRR6rrF7ydgPxJL5cE4ijShE35z
   KV+Z4VHYRHTSDRpRuSR39+NH8afUzBJa3TXvo4/FkRLn+pnt0fsKyVYJ8
   JgOHXdPwdwCgJi+DtYksEWYKiFGwOKxG8T8PJEMUL5mNSjRKUuHOsK+ES
   h2hsw+++o3Rmuazkkz7jkH6GSGqysLMR4ivKlKQdDsJ7uBwIII8PSxGX0
   PJuD4hqxF/7iRRicOjE/tKbT/7Q5KDip7OHuhmvm2IjP3UeBzas3dq8P9
   KkgQz4pvcf0UcfxL+7CQxJLXoQbrI4m8l9N8VsxuKweIp8Mv1+WLrqk2x
   w==;
X-CSE-ConnectionGUID: FlRXX8cyT3qFjoHK7R9RpA==
X-CSE-MsgGUID: YukmpJBxR9CLlyKfMk9h0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11657"; a="68801069"
X-IronPort-AV: E=Sophos;i="6.21,190,1763452800"; 
   d="scan'208";a="68801069"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 20:26:29 -0800
X-CSE-ConnectionGUID: LHHybNlXRt64i4qWKHas1w==
X-CSE-MsgGUID: yjyt4zTpSAWybuHlebdsFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,190,1763452800"; 
   d="scan'208";a="201107951"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.108.167]) ([10.125.108.167])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 20:26:28 -0800
Message-ID: <f81b98e5-87c0-4c21-9a75-ad5f9b6af6aa@intel.com>
Date: Tue, 30 Dec 2025 20:26:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] skip redundant TLB sync IPIs
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, shy828301@gmail.com, riel@surriel.com,
 jannh@google.com, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251229145245.85452-1-lance.yang@linux.dev>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251229145245.85452-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 53393160006
X-Stat-Signature: zgks6cwapq93rzu13tk6548hm14q8czc
X-Rspam-User: 
X-HE-Tag: 1767155191-456820
X-HE-Meta: U2FsdGVkX19ir3umrugUw/MuxbVuPr+x6vW3tUQJwIZNuLQWPzlRikc1TZrl3Gci0/OcqwuxU7QN5Wg61fNBzCNPB4d+nO62M4h6jqjrRK07xd7LpSGdUTyABsz2G40OGp7OOS0vAqzBkZtvklcJ8nphDibHVdT6gmKyV7yfRREBjcwU/tJedXLrJa9MbOORN/XV5oesfEyyYMZjl/a2XmqGwk+b4NQ+C/UjGy+MhV66/l6G83Es2zOZgXfytqOYVW3LPhQ9xv2NENoGTAGQIHUpK5DC9/4qppHeXqU4fhwwig7PobD0hQe+5acQOVrBX4DJZwmFx2iDzLZM7C2Mg54lM0tW9BpU14v6Vz6c6KcoIjfuD20iJMtYzwOxa27mHero+gpbg21y0fMboZgqjPN8zVgR7hGKFowpC1vfRqnPK0w0YsouYPIISjMPrTua8ZxisdgBYIE/0Ov9BWaNCIExvWkALsXTxEJbgIIdbaebX3D1eAKYgcjMjHKxIizL3s8osVY3XMeI/XfKdzKc6pruKFADTkH7v3uTBF1RoX/+EWVGPmgOmqrWDuBv8PrA3KqhKyG0K8VmzKE5CEPOczgFqjgeECWVFul/u4YdbQQ1n3GKa7sawaK1yX/FFVUtRvXDGvQHSlKq9wYptG3TMDDqxmUxuGbPE6YoDfmhYUW+d+OalHErxd3TglmKf8bOhZ9n6aeJuaECBOePBqQDBTuFlI4xYlNv425CdaUSVbYXWag3AimVGP9mWpyVLoYok9nNTmSd3tkjaiTPvOgbZvz9f0sYjiFDA+g7ms2JQ5ObhWtfizqkKJexVHBAdy/uJSPQXlN9+fhCAqKmB0IIPfBfopNOyiGH6lKTqVbKIq+nIHntKe6NUyhKW19PltRy7ZhZCpQXzdBcjrrSWzDKxYnk9gziuS6BxGr6XX7Of5v5eP+dz3pxo9n/dfNaPbapiDi1nkjSnbiE5bnVEEe
 OBdzx8Uu
 lSLCEi5d+tyzv/K2dxIc3ecTp56m91EJczoOFvuf5FXnqPsd80ZJa1677U8EenFoZ6i6xhv51D6t9n0pq9V7MGYNYx40zPlKzs/R7Pp7UWNRibgM07v0ZRy9qk3IV6gBLwLURB7JQMH1j203EwJRpC6WTqLWI1qGeGdSRVA66PcifcqY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/29/25 06:52, Lance Yang wrote:
...
> This series introduces a way for architectures to indicate their TLB flush
> already provides full synchronization, allowing the redundant IPI to be
> skipped. For now, the optimization is implemented for x86 first and applied
> to all page table operations that free or unshare tables.

I really don't like all the complexity here. Even on x86, there are
three or more ways of deriving this. Having the pv_ops check the value
of another pv op is also a bit unsettling.

That said, complexity can be worth it with sufficient demonstrated
gains. But:

> When unsharing hugetlb PMD page tables or collapsing pages in khugepaged,
> we send two IPIs: one for TLB invalidation, and another to synchronize
> with concurrent GUP-fast walkers.

Those aren't exactly hot paths. khugepaged is fundamentally rate
limited. I don't think unsharing hugetlb PMD page tables just is all
that common either.

What kind of end user benefit is there to justify the complexity?

