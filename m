Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9C1C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4826B0088; Mon, 31 Aug 2026 11:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67CB16B008A; Mon, 31 Aug 2026 11:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8F26B008C; Mon, 31 Aug 2026 11:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 319216B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:28:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A1F07120118
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:28:41 +0000 (UTC)
X-FDA: 85161946842.04.4973AD1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 92F46C000E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:28:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CREezQe4;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788190119;
	b=EdZLfr3UXdpK8CO6aiz7UaEvn3fJtGpcEPWz0Kxh8kenVAheXfnPBoIITdaLOo9CHlbJ84
	mz3c/bOnOLB5Jj8d/foZYMTwJsrZGr75Knwf98Y1ygTtMaTbAeI5RJcUixEF4ohleFOW/6
	xrKxkJY6zDCAJa/Q3ZTG2FuY4otQqic=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CREezQe4;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788190119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuDeWaf7WgpqHSI1yoOLmbbz1EkZzpYkobKoVll1c/k=;
	b=T2DHOsWpQd/rNmlDYQWlLlzCw5COImaezLZk8nGNPbMULqqPq5rIedzJZS/q+PM62U/81o
	lUlLLDUtEW3x3q5bQSWai5PvKMiMv6UdUpLSo5nEp18DLQIHM5/aAhYLz71JhJADXjMZ6f
	Yo7ZyCET028YmlIeQWUmJjaL/HJg7js=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B49A14BF;
	Mon, 31 Aug 2026 08:28:34 -0700 (PDT)
Received: from [10.57.6.141] (unknown [10.57.6.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3BBE3F882;
	Mon, 31 Aug 2026 08:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788190118; bh=SuDeWaf7WgpqHSI1yoOLmbbz1EkZzpYkobKoVll1c/k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CREezQe4GnXa4C8RGGDKvHVjF22t/L5J5b6UfZ5AXfZ4spJQ1gMP8m1du77D9yAnj
	 xflZERFG8KqRDlopy1LEHijk2M/I09pIur66mG5W1QsRPHMLbWbvd2DFbNAL2icWhg
	 drjXdEdwODQ0wCXxFG7WTRhQtDzhabUMNmya4Kds=
Message-ID: <7af32e98-f2ab-4961-9e3c-72b8a21416c0@arm.com>
Date: Mon, 31 Aug 2026 17:28:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 13/25] mm: kpkeys: Introduce early page table
 allocator
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-13-743ad31b2c8f@arm.com>
 <1dc8739e-4eb6-4a71-9534-e03a15afd620@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <1dc8739e-4eb6-4a71-9534-e03a15afd620@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 92F46C000E
X-Stat-Signature: trgr1f1ooqkct395cfohda85zdgata4r
X-Rspam-User: 
X-HE-Tag: 1788190119-403841
X-HE-Meta: U2FsdGVkX19618mxcO6A5SAjaFy3qZmwSZn+Tq7aDVZ2ZWuNBpf9LaD4hov9Whv/RQ4nqqGZ3YYYRABv5JA3I+tAi89gt9gp8Q0vjh+XEWZclka43grZiFxN96KtNjXjIRIasl4JxtGkrmL62idSddSKCA8CgjnVK9XvglcgpjbKVXco5CsiPwjjgnSuFPb2BheNJuHjjl9xUIn4Nvo07CWFkRw/gAFsSkHfAGaFK6buheq0VZBvGUmKTADEoeczg9IWJLP7CKhr0pDMKYQqLDseeXG62yUUCg3iRgTsSIP/eHjk3OeLzoquj6bTQ4wuLhb79f5dQsDJLwzvhAmdwWnffkx8W+h4FiMRpXkt0MA7pEa9+a2wwJ/lACJszxARV9NSV5usKNAsZWcvgly8i/cXwvRmHn/AFKgLZbJXjSmsV0dWvdEXmt/k0VAPWGFmuDGSCcHhvL+8R4xshrtGxcDxKb0oZoHz9S+SRUOWAUudyoSfvSLO76GB94/pFZnDJbyHYGNPVZI9dRpNQD0gbvreChz3lHDSDvAh7uBVulBoOvnXO6g1bVCDWd4gH86KjHabGzbGAplNtsCAW9HzHfIvpQGZuTWk56MaZ7nTEbxiECORdo9rVze/wRzJEzAFRyFEzBExO7Zk8gJSn5VnjOoc//daQBqMUGq/tXIptn+wR2R0uZuLdCqaZpO1clN/wAqDExyJjIfeIuSVzq9ug2uVFy2zXbr+fiPWNgpIGnCPCQT+aY2DhGInKyEwL8XA4GhUTeOz+vUzRSG9B/cNdPOH0fN6J6Q+ZZ8D8aKMyelpzrN01lAHSD8dXp3nu93B/hXya7FbEWO9dumypKFukQoFBKHQznVinq/4TaexYauE9RziHNzV5ZId9+LmgyBlgsWH02xQ7BMx76asPsVrGt99RWJAq1caFJk3sFiUtYlCiii6Gg9wkALX15dH50Kde8EJd32BglPc16TD2IG
 iOlHsB1B
 J15B8xy7h6qud1VfvuFs64XbXpLnt16hDL/KMKI9ouTA8NlbnMe8iEFYNOzBQV6dbqedFDjTjMe2O2qnj90Eycka2wAv1hjXTSVHTg4GnaryBR/hGWLB76Q0tE3ASN3P7a7OGW1Z162t2Wg3hdNfW6Z6coAznD2C9T2WQjBtppUgns8dwqIS4hfSx4sD8vpiQWPC/24J7DYcCiGAwYzZg6ouuTccjRfaUSYcURY1/WhHUcP2Bc5apHyY6hyKlndyjGeXV8vg9f5QRLQfeP0HBUu4MjLHqnHzuPtKxeY6VGXsUlJgD/bIw5CoD273JU9W2qdva
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/08/2026 20:08, David Hildenbrand (Arm) wrote:
> On 8/18/26 16:08, Kevin Brodsky wrote:
>> The kpkeys_hardened_pgtables feature aims to protect all page table
>> pages (PTPs) by mapping them with a privileged pkey. This is primarily
>> handled by kpkeys_pgtable_alloc(), called from pagetable_alloc().
>> However, this does not cover PTPs allocated early, before the
>> buddy allocator is available. These PTPs are allocated by architecture
>> code, either 1. from static pools or 2. using the memblock allocator,
>> and should also be protected.
>>
>> This patch addresses the second category: PTPs allocated via memblock.
>> Such PTPs are notably used to create the linear map. Protecting them as
>> soon as they are allocated would require modifying the linear map while
>> it is being created, which seems at best difficult. Instead, a
>> simple allocator is introduced, obtaining pages from memblock and
>> keeping track of all allocated ranges to set their pkey once it is
>> safe to do so. PTPs allocated at that stage are not freed, so there
>> is no need to manage a free list.
> I'm think of ways to avoid remembering these ranges. I guess we get called that
> early that we don't even have a ptdesc where we could just link the pages.

Correct, in both the direct map and (early) vmemmap cases we can't rely
on struct page as storage.

> If only page tables would be linked in some datastructure where we could find
> them all ... ;)
>
> ... why can't we just scan the page table hierarchy to find all page tables that
> need protection?

It makes sense doesn't it :) In fact this is exactly what RFC v5 did [1]
(a year ago already...). Then in RFC v6 I attempted to support block
mappings, and things got a lot more complicated. In that case there are
(at least) two issues with protecting the early page tables by walking them:

1. On arm64 with BBML3 we cannot split blocks in the direct map until
all secondary cores are up. This makes locking pretty difficult if we're
to walk all page tables at that later stage.

2. Without modifying the allocation strategy, early page tables may not
be contiguous and setting their pkey would generate fragmentation.

Naturally neither of these issues is relevant to the present series,
where we force page granularity in the direct map. I still kept the same
approach as in RFC v6 though, as the goal remains to support block
mappings eventually.

That said, as discussed offline it may be sensible to revert to the
"walk early page tables" approach to start with, even if we would
probably need to change it later. This allows us to drop quite a few
patches, since init_pg_dir no longer needs to be explicitly protected.

One caveat is that in RFC v5, any page table page installed after
smp_prepare_boot_cpu() is called, and allocated using memblock (or
anything else but the buddy allocator), won't be protected. Codex can't
find any such case though so we should be good for now.

- Kevin

[1]
https://lore.kernel.org/linux-hardening/20250815085512.2182322-11-kevin.brodsky@arm.com/


