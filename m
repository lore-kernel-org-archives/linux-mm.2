Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B0F60A2611
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fG1jKWsE
Received: by kanga.kvack.org (Postfix)
	id 9CFF16B05B1; Thu, 12 Nov 2026 02:16:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A626B05B2; Thu, 12 Nov 2026 02:16:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8222D6B05B3; Thu, 12 Nov 2026 02:16:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 556E76B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:16:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AEF851604A4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:16:42 +0000 (UTC)
X-FDA: 85425609444.25.90D340A
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf11.hostedemail.com (Postfix) with ESMTP id D428B40003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:16:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fG1jKWsE;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794467801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQI6EwSlsPtuclLjJZxJ5CXmReWwBQ7kHNHZwvtFiGU=;
	b=XJygRxfoky+jASTsZkiXlgsCBFglL+5kYA22NyMAEp96Wv5tNv/JX4xoaeqowZkQwt0A6b
	WozVSZ+EIsEYDXvN98tXqvhN0PMfif1ZMZuMSTeFZ4TSXiv4mceS7KaL7ivG7HplbxhYPq
	QOhZ0XsoSq/9f2tvdY8fkkQZDGw4s/0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794467801;
	b=bYKeeQOWud77P31WzGBN8M/QWfsiomKMy262QDtM4mg4Jo3JQ1IYvREqoUC49eYO/s7sC0
	VpCPo3HssGbmqJXyuAjM2MHNdbwCoYib3YjbeD1TwWFOhJW35iG51Skmhz+G2WoQmDVSHJ
	QeJ1VjIYRiRD1cfff/XhqQjUt6iePMc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fG1jKWsE;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794467794; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JQI6EwSlsPtuclLjJZxJ5CXmReWwBQ7kHNHZwvtFiGU=;
	b=fG1jKWsEH6ROduFjFpZE9YWL9sntAdQfRWUCRrcT8lqj5R7nxKBunaYD4ukC2OhUg3dvXzfeV46gshrT5ic0coBnbFnByBhGTwwatsNUqQUN1uxHtJB1g4/kODb4Mr77yHlk5V0B3T5fISWmxim43+dQbtP9RjNFG/yipwQSxdU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XEbBZGA_1794467792;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEbBZGA_1794467792 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 15:16:33 +0800
Message-ID: <08ae2f1d-964e-4f20-a66c-d2ce3460220b@linux.alibaba.com>
Date: Thu, 12 Nov 2026 15:16:31 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/rmap: fix PTE table overruns during batched unmap
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Lokesh Gidra <lokeshgidra@google.com>, Barry Song <baohua@kernel.org>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
 <20261111-pte_table_clamped_end-v1-2-2dbe339c487a@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261111-pte_table_clamped_end-v1-2-2dbe339c487a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: owpmagmycf81wy7tdebc4a6u9pwzzkzp
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D428B40003
X-Rspam-User: 
X-HE-Tag: 1794467798-640764
X-HE-Meta: U2FsdGVkX18mHfgvbVxEX3/ER5jiUD4hYgyLmn3jWTi2VxXHI9nz5EiKK62avDF7Ei7/VENXh9LyWI4QSaygC4am50GBklbG2vA8O/8V/DHu0aoUfMY7SbisnneMPxBVPszCfa2Q+QUFhfd8WO9R5RdhwETSL5sicjeFD4ZWT95VZB8G9MYqEPgK3Bfg76UV7VmeyNZTt4+ghuv6hqu+pDjhM3GZtSX1jf7nXa0l0Cv9T509wnrka2Y6UJixrELGvhEkvTLOcWGJ4UX0gEKBAncqUIc9iD+j1eM5dZ0mutxrjB9Ffi7UxiXaAY2QIRCPruMR1UbAq3HinEqjOce9p+Sy/ZuHlJ/fzEhfPMIX78xf/GfaTJFusCKKaZc0VcV8CRutsDzu/eeV44mR7WqPBIdayZxo7mii+5YJado9zC3wM5A3P3x302j0uh884nT5AFx2qFh7fO8HTd8rv+PcupQsSoEbSLIDcHfV41xvLAWE8mbCbazmgXBh4hv6vMxc6C8O5eUQfkXJZV2CIRJkMxMLZAlzqi7fw2EnpXxUXJi7zZcQVrQBgu2uTUjb5oBvyMdDT0PWWZHidcUaVmMZCAKJshMptVdvsrNSRTi5BEiLoayMYe3G0OSHGAI294WdMeJE+CHJ4oWpiclkZ2NnEXhIQKStyOmaiGieJCjSABQwC1Huxpli7TjLkcdgCoIWWqnWNgkEvF2DJV0D79DQyHSqqos23NCNIPTD7BIRJmS0hYccx44z0CFV+ulnz3PRW2sZfN6aAWHTT9AHv8SVJZN/7t3cuFL2S/TZSL6k4n47UXYBNzB29VRO0fYNBstXJ9Gt7Uo9/t2rVMGh0m7qCzx6JZrX8fX/BX1tgcI9zxX6Y92sEeQn3xwOGs7zg5p0VOmOwbtUOPD9w05KXj54nAlGEsqx3+eY9megihryKmkik116SraucoiaQxGw7bvsdSAQB03p3JkeZFzl4RS
 d6IgciYY
 qeD/BwrUE/MbXprZ/SU4rwyY+J2kCgZaACzOqPQrkhxpqmsoeKSN0fm56Q2G5HkhsuPMg7dfYAxShZRD9KrLi2kZhllUN6gfaglkagX9AUUvWOm0eqA7PsuSIi/E6WybLyT50FYW6pEaSAYuw7eu5GNeKYDskarqByaBWL6t5hyU4ASHMtqYPYzAA16+JAPvopS21gI9nsqcKUAn0wlhjsycCLLiz1Z0Tx6ahcenlNTzbtSpTveww9IBSpO+WohYAoO42FHqgyiNlQJKtzmoG207bOAYYdRzYkHLXqDO3fKvHPg1ztDfyEhsO4gdXT3tCGUDreFXutdcXBfE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 6:00 AM, David Hildenbrand (Arm) wrote:
> With a folded PMD, pmd_addr_end() simply returns the supplied end.
> folio_unmap_pte_batch() can therefore walk past the PTE table when
> unmapping a large folio.
> 
> Folded PMDs are uncommon, but can occur even on arm64, for example
> with 64K pages and a 42-bit virtual address space.
> 
> Use pte_table_clamped_end() to clamp the range to the PTE table and
> VMA boundaries.
> 
> Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

