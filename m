Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF85C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B496B0005; Fri, 10 Jul 2026 12:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC6A6B0088; Fri, 10 Jul 2026 12:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5406B008A; Fri, 10 Jul 2026 12:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E21B86B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:26:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61B651C8B6F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:26:54 +0000 (UTC)
X-FDA: 84973395948.17.ECA1235
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf21.hostedemail.com (Postfix) with ESMTP id C68301C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:26:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EuzeeqSo;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783700812;
	b=bnUlEw/NGk7ErVJc7xwf4SXwmsybhSDHzz6nLBfyEDQ0CoPCv/eTyxyVa5zxaIGs/wxy2D
	pQhAIBqmrhaKdTzTOtTN0gjrVE3eYj5geMpRYejn3inpsvo493rShMlNPYu6u406he7Ytt
	AmSCq98NL9nOxi3IhvKh9AysuX9Sbng=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EuzeeqSo;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783700812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZSR4JA0DJ6MtWA51lInWtrVJ8s+cd3p9BFdyy9Ih/4=;
	b=vaG6xA/0YV90q6U50kMfb0EeWr7eZreh+dPuLQ6ZMhb5JhvXmJ5S7bNxjbdGUORZpLc9k/
	5aCx5D0ZC7DNSr8WI6z5dawBiCSnC74ITM2dqrbpCrWyD85qWvslqwDwbv9pJ+B2EqYetL
	AFfwTWBgCnb/cUb0+Vd0tE8gcl2kFp4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783700810; x=1815236810;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+s0ZPcndBl+o2igU7pe64a8opX6QJ32QnPIg93N/eb4=;
  b=EuzeeqSoB1+MVkRZWW+jgY0fzeDgODV3IsRINQcaKQS63GG/iULoCCO6
   tqo7IuTvRytt1prDyrHTBh9NiP1QfYBrmch3nQYr0p5JMPuEjGlRVflo9
   FxTzfN394PjU/HYzTCzRHb/tf8zh4ZWidqKvpIpILNRX2NFFs1vGICUml
   epfPtcwpIwTFQgRxXZ9ABpLKIOOOyMx8LV5ujvi5P1MmPMqvsf8yXGkua
   h63C6fzHU0ycFfSI3f0BYFsJZlfceb3f0A2yPSN43qP63hpaJ1nW+hbPH
   mUfoh8AscCvKpE59n9t7wa8Vk8iMac/6TCR/dGUOhi9dYEm7msoL/1cxI
   w==;
X-CSE-ConnectionGUID: fr573S+LR/2TjhNwUJbVLg==
X-CSE-MsgGUID: M/1txkLZR4eLqGXXSuPK/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84281224"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84281224"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 09:26:49 -0700
X-CSE-ConnectionGUID: CkOkBgw8ReKAnD3cCXISxQ==
X-CSE-MsgGUID: tBS2iAC0RLmjQqQ6q1/k5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="250937338"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.199]) ([10.125.111.199])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 09:26:49 -0700
Message-ID: <529e37eb-ad4c-4b0f-8ba3-c5608aa7a893@intel.com>
Date: Fri, 10 Jul 2026 09:26:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm/pat: acquire mmap lock on page table free to avoid
 ptdump UAF
To: Lorenzo Stoakes <ljs@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>, Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Carlier <devnexen@gmail.com>, Vlastimil Babka <vbabka@kernel.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, stable@vger.kernel.org
References: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C68301C0003
X-Stat-Signature: e95nj9a9xb9komto8cz8digqz1ipbiqb
X-HE-Tag: 1783700810-286927
X-HE-Meta: U2FsdGVkX1+YJMwdsIpKP1A+wav9BqwGJOc+Ngpd9EX8qvlRHEV3UYcoXoulpfP2JqPizf8GNMAurgbEqCiQ8OUGVRG5YYF4F+UoE2gwXlBxINKrkZtqrifgNJ1anIsFDaIplKfPYs9NOs+RCGJKO8fFnRggT2RpCafaxMk3404PzLH6DDWeQc051BQ9KtFr+1u2YTqRE6uEmeyy8juENr9FleyJOIUJwKqceX4A1OWKzQOr6Y8vYsNQI7RFAWDoizod3wReI/qRey+1S7xLicVP2hgZ5ptRy4a3hMji4rojVesLYhjkcTyT8WAVK+q+3NehyasdghYVl5z5r5rGXd4AOoEZXs7OHeubVscngwTRPRcfcBImfa9sukT8uW5baZnmNg5JkqDT08nBRu+Fg96rz0IED7/mJAOzTwRlkXoQ41vN8vQ7fo9q0kYIVQSiUsCI6UROrtaK9udQ7HC+rrIVbXgo9+PPRvUlR/R3oRyjJHXciFqh/dyhlz5bk4IzCuakN0LKS8dvoUt6ePRonKwA7vBe1mSP2mQSw9+yoCJcVPqLuNs6F5TGBaNmQzHAEXGyqfoKNCiTiURu2eGbbNRo4NrSiz6SHBFTIhLRjt7X/6ZrWln4uWkBGj0kqNdHl/AzNQShDJ6efGjXZBIg2NnRMTJnzAH7l1h18645D08Nq5acv2RFEKIy0VHLDa+cCQopIpEw64NCsc2r5ZNW1bK3rTocR+NgAurA4iGJF5caozjhx/BjW0wzZQWHIorZX1XRye4IE3NuLn+m8MOVXi3tjxfpparpO0BfqQkQc9VIGz3XCn+7D2pBkBpgajA5eQpur0LydbHEHNrl6+txFhtYrHJWxSxweIy4swFaMF1S1OvseFoklmHqc4jN/zH8zlTPeFc2k0Rx2/q0eHjDNGSIOzbl++VcHAxk5b7HbaOizHmkwf0ksWjrPpdF3868rfihS1lH7j3CpgTwrGg
 Vjdbj3uB
 tOebLwjmh3ePPSXKN1dh+hQSTbnpH9pT+tqSPdj7sqIhCWlzgNK6Sa4WrSfzY2WIW5hz4YHxstr4aPkg3Ir7xvrqmGqBIXtadVumnNWlCSCiT1h7E0zbgsf6OKymQCkwskhVdMGdXcylqyeHgyOILWhLW8BdohoBJAlVUYy7/FbO+6KMmtDNvlLGiJbJdUdpAIvRQVmxa6UqbpXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 04:56, Lorenzo Stoakes wrote:
> This patch resolves the issue by acquiring the mmap read lock on init_mm to
> provide mutual exclusion against ptdump, which acquires the init_mm write
> lock.

Hey Lorenzo,

Thanks for looking at this!

This isn't wrong per-se. ptdump does _sometimes_ acquire the init_mm
write lock.

But the fun comes when ptdump_curknl_show() passes current->mm in to the
ptdump code. In that case, there's no init_mm locking. I think the
'efi_mm' code has the same issue since it shares some of the kernel page
tables.

Is that your read on it too?

In the end, I think the issue is that there's not even *a* correct mmap
lock to take. The userspace half of the address space needs the
current->mm mmap lock and the kernel half needs the init_mm mmap lock.

The naming here doesn't help because the "current_kernel" file doesn't
dump the current kernel page tables, it dumps the whole kernel *copy*
(the only copy with PTI off) which includes userspace.

(Note: maybe we should hide "current_user" when PTI is off at runtime)

So what do we do?

1. We could just bite the bullet and have separate ptdump files for the
   top and bottom of the address space:
	current_kernel_top
	current_kernel_bottom
	current_user_top
	current_user_bottom
	etc..
   Then the lock you take is dictated by the file.
2. We could always take both init_mm and current->mm locks. That seems
   icky.
3. We could have ptdump_walk_pgd() take a different lock for each
   'range'. Logically:

	if (range->start < PAGE_OFFSET)
		mmap_write_lock(mm);
	else
		mmap_write_lock(&init_mm);

   That's icky too and it means a range can't cross PAGE_OFFSET, but
   that doesn't seem too bad (it could also WARN() if it sees bad
   ranges).
4. We do something fancier with the free like RCU (I think this may have
   been discussed already).

I'm kinda leaning toward #3.

