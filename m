Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA96ECA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 09:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B9778E0027; Tue, 19 Aug 2025 05:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6915B8E0002; Tue, 19 Aug 2025 05:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE1E8E0027; Tue, 19 Aug 2025 05:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49FBB8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:35:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3AB0B92B6
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:35:15 +0000 (UTC)
X-FDA: 83792998590.07.60CBCE1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id A551E140008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:35:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755596114; a=rsa-sha256;
	cv=none;
	b=OdFsihKj/+nNrawch+hJm5PEHScmAVXQw4C9hiA2FqbAQJaFhYNvq0T6b0n4DfI74dCRpQ
	38RskSvKZRRSlC0mTINJNdfv9ORD2bH/IGbBR+0lq2fJI/A4OPKLzvt9R59e7mwuefb0eL
	SgQa2W/1iOmyQ6PoWfwyNOG7DS6ls1U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755596114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CZciOKLRsCJe6+CO8UzeOSGDAbt35EFDJxrVlWismP8=;
	b=rIIqjOUr/uMLvRWJzzaJzODHNspiWdYsNnkEQY5t83nZ/KlZOovyfHACnzkkMTIyeaEBU5
	jU/l8p2GKC9S/jRrPeaalxztIhSGxMr+BMjiG+DCWRnae4wH/QAvqZKe+t5X5z2wd7/gQx
	l4mpesuGqraOORWz0eYB/IFFQS9xBKo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CE351BD0;
	Tue, 19 Aug 2025 02:35:04 -0700 (PDT)
Received: from [10.57.56.191] (unknown [10.57.56.191])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4496B3F58B;
	Tue, 19 Aug 2025 02:35:03 -0700 (PDT)
Message-ID: <e4f546cd-67c0-4198-975d-266a7cb9807a@arm.com>
Date: Tue, 19 Aug 2025 11:35:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 13/18] mm: Map page tables with privileged pkey
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Cc: "x86@kernel.org" <x86@kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "luto@kernel.org" <luto@kernel.org>,
 "mbland@motorola.com" <mbland@motorola.com>,
 "willy@infradead.org" <willy@infradead.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "david@redhat.com" <david@redhat.com>, "rppt@kernel.org" <rppt@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "pierre.langlois@arm.com" <pierre.langlois@arm.com>,
 "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "jeffxu@chromium.org" <jeffxu@chromium.org>,
 "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "kees@kernel.org" <kees@kernel.org>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "jannh@google.com" <jannh@google.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "will@kernel.org" <will@kernel.org>,
 "qperret@google.com" <qperret@google.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "broonie@kernel.org" <broonie@kernel.org>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <20250815085512.2182322-14-kevin.brodsky@arm.com>
 <616011cf17f1654ac3ad8757f0f33425b3af1ddd.camel@intel.com>
 <b6579c2a-2262-4279-81a5-8235092bea13@arm.com>
 <c8196481fdd338e9d066376b6e9bf1dfcd6ea462.camel@intel.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <c8196481fdd338e9d066376b6e9bf1dfcd6ea462.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: A551E140008
X-Stat-Signature: qty68tfw7e41ffka1dg79xuk1zj3epiu
X-HE-Tag: 1755596113-30096
X-HE-Meta: U2FsdGVkX19o5Low+locqDiNM+e9u5DhRmmbpT2o317YUFE8WjXuwBOGo+uXOPR5WI0XHKrutSjHrLjJs5N1WIDz14NvwcXaIo6rDKRmmSVOsot+YS/875WKi7Zk6yQAwHqRdEl67yg7DG29ddE3s9BMXSnIoyu9aAQAiH+pKK9sgIpMw8NiKSiEO4apGhB72sDsyiLFTErSGl1pYQ5UW3DBs+ibkehfueFL/GkmDqzt14RhmceNrtthT5jLVTTA7beTCRUrSTokVzEiayFtRyLRN4NZqUKTYb1Et2NIa7bQQ0EoozxMy5ncY1Rnfu4Kvzl/e8KQVLcD5Hr+2yMLiPQnGY7Qo/j0dicC0wdd1hNfz8eaqN02SCJc/9SaJCLApEJpqgcE0DCis/v7J6ZJ6nDMWy8NFeTUwfaiKqOGF6raVF4NZ81ZDOAqhI3ue0MzqfE8X8efDCiWs9RLuPleLZJcnNYRT7ZxYIcvILq0snXsnTPrp2IxUK57EFptOJcTNqYTdURzJOB93/DHM+1T++I2esuFUF8Up+BwlI3Jo/3qeD641cf7CWU0zd3UIHp9Wn1LxEcxt3Vm2DJJwbHdugMjq2dUQ8LuqqzGqCXg3n6VBlMANa/gNMmI8/cfC6gvb5OQusPjOQiiI0j3xvfG1AManLKImOsKnqqim+w/oLxzav06fy+sONu8REbZsaZDw8nVBE1B8ezeZ+RJp3u0FpNJAb9mgDfgqckeu/iXfbbvsP0NztojDUtmmpji4iFOqg2os+SOt+XWtQRZb435P7sVKyWXC36DNlie/8vJxwNrlvpSkZ/XsQDmq/WwNqLlKBTiRlO435pmkoDDVcTaT8W/bh5sTjdMUAF6ea9ewcX91/Dah49KJaxbflUebbT8F2lHqkEmeXEJ6yTaLRX+L0hkE0yMl8ju7dxtcapPjURCGbD5gtRo25LeNk3tBWbUT6HZrdcySqkz6HKTYNk
 Ltu+1KcY
 C6iTc4GzjW6NoWGHe1WNd9TTh1uli6ES6QxA5isNAk31daqW6Lno0KasLXR4ZFgygKmX9bkUt08XsHQ37LMtHIU5GDTQk0pilwDzOh7D6Cn+eE29Q+qcLspcMiyJ5yt4xpXOGO+2FJSgsBD+9lRRR8w/lgcLu8/l3VEl1WeDQE0UA9HePfPB1bA1Rp9K4H1VfZPZeD0eMyTIWwXzDo5hZ1IlqCqM5yf9nYBVNPAwQcYUSt1IYsIZUb/DrPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/08/2025 19:01, Edgecombe, Rick P wrote:
> On Mon, 2025-08-18 at 18:02 +0200, Kevin Brodsky wrote:
>> The benchmarking results (see cover letter) don't seem to point to a
>> major performance hit from setting the pkey on arm64 (worth noting that
>> the linear mapping is PTE-mapped on arm64 today so no splitting should
>> occur when setting the pkey). The overhead may well be substantially
>> higher on x86.
> It's surprising to me. The batching seems to be about switching the pkey, not
> the conversion of the direct map.

Correct, there is still a set_memory_pkey() for each PTP.

>  And with batching you measured a fork
> benchmark actually sped up a tiny bit. Shouldn't it involve a pile of page table
> allocations and so extra direct map work?

It should indeed...

> I don't know if it's possible the mock implementation skipped some set_memory()
> work somehow?

In fact you're absolutely right, in the mock implementation I
benchmarked set_memory_pkey() is in fact a no-op :( This is because
patch 6 gates set_memory_pkey() on system_supports_poe(), but the mock
implementation [1] only modifies arch_kpkeys_enabled(). In other words
the numbers in the cover letter correspond to the added pkey register
switches, without touching the page tables.

I am now re-running the benchmarks with set_memory_pkey() actually
modifying the page tables. I'll reply to the cover letter with the
updated numbers.

- Kevin

[1]
https://gitlab.arm.com/linux-arm/linux-kb/-/commit/fd75b43abb354e84d06f3dfb05ce839e9fb13e08


