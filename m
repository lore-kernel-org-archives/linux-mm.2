Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 255EEE9A052
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FAC96B0005; Thu, 19 Feb 2026 12:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9236B0089; Thu, 19 Feb 2026 12:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AADE6B008A; Thu, 19 Feb 2026 12:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 594326B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:30:41 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F2AA1C702
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:30:41 +0000 (UTC)
X-FDA: 84461895882.06.73FAEE7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0428F12000A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:30:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YBCp2hay;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771522238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPRrtagnX5zJmemPrTRSAsSiTw//oCC0CpjSTG6jM5A=;
	b=h/LQnLJvtBLqE8lELRFu1IW3R2h4/9UkoRqJScZ341zRWm5NEKRDQB7oTb3SZf9h7labwT
	MN3cKhUBzBbRl8mrdiATdwMSaMgUzCZUE+RbV7vA81wRckKkW0UYeXBI3HZ/iCVCacnrrF
	rMZBHLolMhSdvXrJTG7E/kaKT/8diA8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YBCp2hay;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771522238; a=rsa-sha256;
	cv=none;
	b=5R8KflVa7VcRt22Mn1sduOvaWmZnXUOZYDAN9+eDChS8NPBEIgoooI5w+RqWHPBz0xLyXK
	diqUcqvIPPHuXIT5vAaxtqbm79w5uf3SZuUv0WvVNCFdcQnhs11p6OJ2PCtcOJQoJR/HjK
	+scb8KKpvQI6ljClKmpMWz0h/T41xXU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771522239; x=1803058239;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=50rNtqZ65CSurDEZgStPk+RW8GpDeLvz0mbV3n8oyVY=;
  b=YBCp2hayyEFE+3A1zh9syKZIfcFaWWT3dgK3OnpKFwcGg3wfPwlapsfO
   4XSACOUV7SaGbeg9LHok4nwQ1M3s8xypfHK5KJBGjstlEdQbgqssTrpGo
   6YOPaMOozJk8L0MfK18pTtWgM7LhXOtdyrBXq1nNIZnb8EXF/FSU+DJrr
   X3Mnno+QNyHdbmm0PypnbEbNDECJH2NCLpta/4W41UD3hXssKbhVpfK1N
   s/1OWhIjT3D7jNbQK1m1gge39Axg7O57bTHcPvzvI0yqKo8tKdnrjL0AE
   d2/+ecAaSVG/C/4td7gMEb0MpQPF2lBWAR6YZphZBTXs1hF7+Chvo6/aL
   g==;
X-CSE-ConnectionGUID: I3NUMn7uRoyJmqMZf/kelA==
X-CSE-MsgGUID: eUSWBLs6SbKdbcCtCzhO0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="95236764"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="95236764"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 09:30:37 -0800
X-CSE-ConnectionGUID: ZjdLsyqPTlmuBFTxRV9O0Q==
X-CSE-MsgGUID: QFi+pnYvTRmwPDu/Inp4aQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="214443602"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.110.10]) ([10.125.110.10])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 09:30:36 -0800
Message-ID: <b0c7cac9-1c3b-478d-b274-c06f4e58f356@intel.com>
Date: Thu, 19 Feb 2026 09:30:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aZcmlIF4bmG0twkp@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 0428F12000A
X-Stat-Signature: x8kdo85pczu3a884s1thjwqxubrx8ibm
X-HE-Tag: 1771522237-797137
X-HE-Meta: U2FsdGVkX1/lBCj6vUQgbp1ftWo0cuU2PxovfifK+GIXGNyPdzRxne0X1scAFNmE3yzbBsQ9m5gXwZ7bEXq1I/ChIk1Dh5O0s6ygUQnywbSwnKkHmzCWuBKr37IL2OCKpsrVVosiSEv6DPlQNt2vJClUaPZauWKVlMiAC7OmC8W2Buw8CY3ga2aaoyBKQxAxuMo8JJcTGPPncsrgs9D1k/ZqJbjZHngdAJ9As1DIjOLVG2tD/r9n999HJB0bBhsz4tJkhP3rA/RhWYcl8Orzl38yduoaMSG9nmFsz5GCegm6rAsTtwbTRyZVdY2TsbF0+05d0iQVXCc8nDYUBX39vvs/0Pkgnc0osBIYHyikcueUkxhlcYzJIgigqcihLqE9lpzOtlw4YmWd83vrNUJ98JMMi4ofPIyJL1pfzeVTjJ1CY4VjE+VJoEaQvQ3FjWxFNnqCqRNys5NiB8Sw4gFBHxhhD9b0JlxXKOi2d/IMeaAOckEM1kbrtLl10cFfVqrGXokmQsBXS33LmGpNtjjZKz5EE/39+3x5185772M5kLysHvKIOOZlFHakAWZAC8KCe9moKaARb4x+cbTGXgJfJj07YqFM+zXG4OII1ziSk2ClV0MaTh7Obl2EHQUzfJSTnyDEhHA//zPvsH+xPiSsUNAfDruVUpDtZ0zzerWDjqeBiCECcllCK0WVda7vd2XDs1Re9FSNK1ROtTnHzigS1zoOz0OMvizNk7+qekhfOOPw6s16hJSVcJp70lnPAG/yGxoHHcoM5bg9lGDnTQ3xZ3odxaldIIiwaXmjB6OXPcV3pd5fwTvxrVeBO44J2lm6qyLEDleHJ1GVFmw1HcSKHa15SNRXhN4s1a9ni7ktCGSOgA3pDPwUQ+KCFVpLBGz+pyu5EDUXL2H82HN2Lpd1c5wJvvr2Zur0FvD7JV2FqxFQjBJUOzZZne5Om8W7hkJIcBv8TJAP89/38Nj5Nc7
 WOanoZAs
 P0hEmwAc4n3QlUHPpuvP/iolbV8lcgjwsIbDDN6W1z+h7OapY5M3URaiagozf2S2C1O7rhD8iqgWSlWIzRAn1M0x5qIvnhwqe/EveKsE8428dRmXKplxrQwBCHGG/jwZpJsyS6Fgw17qhU7PMHAXoJ9W8POcDZ2twX6ayxizV4jvHCgc5aIx3/IGRDdAfej44csO0Ob9H7RjisnE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 07:08, Kiryl Shutsemau wrote:
...
> The patchset is large:
> 
>  378 files changed, 3348 insertions(+), 3102 deletions(-)

A few notes about the diffstats:

$ git diff v6.17..HEAD arch/x86 | diffstat | tail -1
 105 files changed, 874 insertions(+), 843 deletions(-)
$ git diff v6.17..HEAD mm | diffstat | tail -1
 53 files changed, 1136 insertions(+), 1069 deletions(-)

The vast, vast majority of this seems to be the renames. Stuff like:

> -               new = round_down(new, PAGE_SIZE);
> +               new = round_down(new, PTE_SIZE);

or even less worrying:

> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
> +int set_direct_map_valid_noflush(struct page *page, unsigned numpages, bool valid);

That stuff obviously needs to be audited but it's far less concerning
than the logic changes.

So just for review sanity, if you go forward with this, I'd very much
appreciate a strong separation of the purely mechanical bits from any
logic changes.

> On x86, page tables are allocated from the buddy allocator and if PG_SIZE
> is greater than 4 KB, we need a way to pack multiple page tables into a
> single page. We could use the slab allocator for this, but it would
> require relocating the page-table metadata out of struct page.

Others mentioned this, but I think this essentially gates what you are
doing behind a full tree conversion over to ptdescs.

The most useful thing we can do with this series is look at it and
decide what _other_ things need to get done before the tree could
possibly go in that direction, like ptdesc or a the disambiguation
between PTE_SIZE and PG_SIZE that you've kicked off here.

