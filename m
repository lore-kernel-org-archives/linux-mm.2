Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E6ED2F7EE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 13:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265DF6B0155; Fri,  5 Dec 2025 08:00:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216996B0156; Fri,  5 Dec 2025 08:00:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105516B0157; Fri,  5 Dec 2025 08:00:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA6936B0155
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 08:00:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93D1C137DDB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:00:52 +0000 (UTC)
X-FDA: 84185427144.28.9974C57
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id DDE68100018
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:00:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764939651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O/A7vZpgIBnKA8LnxsqL7KkP6nyGfOKKNJo36CMVlRE=;
	b=EBXyw5u1NT6mTAvEGi7/GQs92ZfoLXLPS3GwI8h1d4DILet/Ew2YBI7GHHE5CG/GIMhAxr
	VyflB4OU90xhAAeLNDC6QkzFPqn3IwrL6K+0HGb5D6YVPAosvXuKLTzx/P+HNi3/5y34BP
	eXX9UG1UX0wQzRaVmV1Udbnb0L6UV7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764939651; a=rsa-sha256;
	cv=none;
	b=ehu4+YmOO9UCQa9W6O6Y9KtyEHWAvUPxyZ4MyCk1HUlM4mS5susQsRnOURWYvNz7cTgXN4
	+5rSHBKhqT1NXeuj8XeYAKogokp+t6uvRqJ5NLLVwGdrLnnCK1MH8kqqPdn6/ulYkI1P9a
	nDyjoC0T/Ega+qRBaVylMXSnPHpAouA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A482F19F6;
	Fri,  5 Dec 2025 05:00:42 -0800 (PST)
Received: from [10.44.160.68] (e126510-lin.lund.arm.com [10.44.160.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 164973F59E;
	Fri,  5 Dec 2025 05:00:39 -0800 (PST)
Message-ID: <f07f5f70-eb4c-4e45-b7d6-96c8455255d2@arm.com>
Date: Fri, 5 Dec 2025 14:00:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/12] Nesting support for lazy MMU mode
To: Venkat <venkat88@linux.ibm.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org,
 linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <94889730-1AEF-458F-B623-04092C0D6819@linux.ibm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <94889730-1AEF-458F-B623-04092C0D6819@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: DDE68100018
X-Stat-Signature: wj5q9xtbpio5nmca3xrjfo9sac7w3idi
X-HE-Tag: 1764939650-716807
X-HE-Meta: U2FsdGVkX19RL6+C+X+OACOfcMZ0rKvjJsmj6b0L/WCHZo0Cm3V5rWOi+QWjgCaA246sCOP/hpbD4zSsYFbYNQUoMbLJbCAg4IjcqtucwsaEOpgbHd1c4dtwuem9xNWTZlgoW3TOA60YkqmoqDjfidx3A9y6vWckv2BqVo0QTtqVU1QlrRQreeIE3pNPWek8mW43Vc+bo+e9wVDRDQTZo4gBCp03SCw01i0+17VC+kCjzEYnK8oZVok0I68e6fLwyT8xXsiXw3ZZrjzppjWa2+pjwkzvpW1Fx5LM0k9fsJgF3ATk3j1LZQvamraoc8gslUzcD3UUvragAMmxAbzqCF/IGR2tMipat6vls9axYpEBsqxb+pu8+FF3P94oyGHdHrwT2ZyE+L/GXFZyphAwzyef97Px55cF0Ai20wNKA3zOaJMrId3QA1rvhjW1j1bUw+qfGuXADHjKChhghaQiSQbIUxyeaG94snytrNnmyhBZeRFOyy0q5c9OHAbptPuQE86w8NPgKDg21Q70Gtf3dDQqpQJWAk+Z3lSW5zbchey6qyanGCwk02KYLmQJgE/o7efyB40XMJkwF2qAN2OpVWqgv51UNJafF6usO8c+NT9TXU5RVJjF5+N9GhSlymNSsdaLsNovQZEMX2kCoU9H0zcilADBRywCkeeVj6+3NU8myLZ3HT49LBAhFPP146E6vTf6EQ+BAxeMvIAqko8hc327ulIpj46S+wWK4aWBgoacw9uVZun/ypU/JTyJe8DhHfGKnMA/qV9yZ47NpPQnC35ywbBsIYzKZ8fJSaiOl7RWgSKB5S8MYXTNwaeRoZhaWzdh1c3BoxyydeV6vqGDnTN/jg8QQvLV8Q3pxyOd5SCTksamp8TXiE3wqSIUrr0rbwSBWoqb6Bwc9QTkxkqdooY76Lx6fNSS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/12/2025 17:08, Venkat wrote:
> [...]
> Tested this patch series by applying on top of mm-unstable, on both HASH and RADIX MMU, and all tests are passed on both MMU’s.
>
> Ran: cache_shape, copyloops, mm from linux source, selftests/powerpc/ and ran memory-hotplug from selftests/. Also ran below tests from avocado misc-test repo.
>
> Link to repo: https://github.com/avocado-framework-tests/avocado-misc-tests
>
> avocado-misc-tests/memory/stutter.py
> avocado-misc-tests/memory/eatmemory.py
> avocado-misc-tests/memory/hugepage_sanity.py
> avocado-misc-tests/memory/fork_mem.py
> avocado-misc-tests/memory/memory_api.py
> avocado-misc-tests/memory/mprotect.py
> avocado-misc-tests/memory/vatest.py avocado-misc-tests/memory/vatest.py.data/vatest.yaml
> avocado-misc-tests/memory/transparent_hugepages.py
> avocado-misc-tests/memory/transparent_hugepages_swapping.py
> avocado-misc-tests/memory/transparent_hugepages_defrag.py
> avocado-misc-tests/memory/ksm_poison.py
>
> If its good enough, please add below tag for PowerPC changes.
>
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>

Many thanks for the testing! Will add your tag to patch 1, 3 and 10.

- Kevin

