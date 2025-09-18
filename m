Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A09D0CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 10:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056EF8E00E7; Thu, 18 Sep 2025 06:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22DA8E0093; Thu, 18 Sep 2025 06:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38E08E00E7; Thu, 18 Sep 2025 06:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CEC598E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:13:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93B9E1DFD5B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:13:18 +0000 (UTC)
X-FDA: 83901958476.13.B55AC95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1BC1E1C0007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:13:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758190397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xxs58C2WtFJ0KGp6PCanbZVXzvtIrGauHJD1iwcYKoI=;
	b=qvzrTduVTmDBuJEukpFeeF/xKnf2hl/gnnA6TYXKS8g+UK9/SH1tM5QfdhFplm8mD8Fnps
	dBS3X7blLWQnrAnfg+rKaX7mv3cPENwKjGNX8jSMmDp5c252cAXIxIgZEav6PHzuu0sk1K
	MSgVgKBFyDqewKBe4uowmi09PNMEyO8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758190397; a=rsa-sha256;
	cv=none;
	b=Efo8RTx3xTwKXUAHfAyLKu1rqrcsO/imHPrw74xccehGND8oMerCQ60eDzaxCTpeKY9IcD
	66Y3jeK5v+JThfkXGJ5RzxEYaRVgEzg5Y5w491hu43QvC+5iiB43AwJY2NfgpKckmyCwmj
	ZOxzAb5oCOClkikIqUDdtH1EPBn4Fcg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E9726020B;
	Thu, 18 Sep 2025 10:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86177C4CEE7;
	Thu, 18 Sep 2025 10:13:12 +0000 (UTC)
Date: Thu, 18 Sep 2025 11:13:10 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
Message-ID: <aMvbNvCsSxQjA2rq@arm.com>
References: <20250915032946.33203-1-ying.huang@linux.alibaba.com>
 <20250915032946.33203-3-ying.huang@linux.alibaba.com>
 <46dcddec-88a9-4b22-920c-8a3edeb2f027@arm.com>
 <87o6r833li.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o6r833li.fsf@DESKTOP-5N7EMDA>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1BC1E1C0007
X-Stat-Signature: ixqb8mfr39sah5kdpw3fnuaomxu7z1mj
X-Rspam-User: 
X-HE-Tag: 1758190396-118252
X-HE-Meta: U2FsdGVkX1/fwEJUju7Xk2c2rmo/hk25Hd5uqHedLgFkgAEnSWiy9Vqo7GkfY7RdjiAy95o4OshHAAwf53A/kF+720IN0lnnmZTZZtd1HGGw+wPjbi3LdHmQlj5K7rO05amiIKcgVZB6awFyBYth/KLVKBKWPN6VuqF9BT1rwDwRLmx5SwRL8V5qQGyjbM2RNaLf9Nu4V6iQYCI2G9omn/dSnvSAUOLt0w8L+mUEAydv1+gSjcdrdmnagirQbdJdaMhHrtBYnEbvIBsExYRfg2uRk51Sg5WV5zqpwSRdz/YWr2ddkzbNjtk2gD7kR9+6aSi5PXecVevF2KpIYSVsk0jNRnxvuGIItI9erB19MiTFCiBKGl2goK9Z8iLt3nb2ax26Nm0Ug6dRWMJE/ISHaiilq6YCXYo0DgkuXTNz9ZtBtET6KQuwSFEMKZARjYNub8s7al2L0wQlSiHEf6QQB1YOmIwpD4kx4WrRWYfemvvWh/QW8Cl9c98bgxf2PJD64ttWwJCGC4ebg1tTnExKtTrZqpjACfDI8eYoofyEnFlNgwzO+LrOnHJHa0jCG0dRXMUQL2N0GidmGOg6HqH/zaFBgbcObJ6wrh1P+mbw9GF7UZ/NheIdnR1f30A8IbjlzEb79Rl0CyUsj78zHskypkthAxVORqmk9J/RUmilUzWVv+aiAYiYuD5Am1qs3oSMKMoL20dvOcyHOrZGqXGcXXOOx8fOo+OgfCtRv0/4AoToGMqzaj7k9qk0TDx0vC9HQmLFDIgtp1dpHjaNNbAPp97YTp/8jXnBrs0r0MIoEFSG4qSjrOuPaYW1Sq2Fu08ZQAbb1/wQ4uLLkN9G6hQFRQHRG/dEX8uoU7YlmjHu6AUSgQTbE30o155reDouP356AQVUzKQxnFACQMZjtmbbPtMbIxbpUECV4RD6KNTX4VvY1KCCrtL7liMNk3q1jZJSRY/yxH3y8TG24hAhnPN
 fVDt8DcF
 4xMLX3RiV+rl6b/urHBtby03aKAs+Z8qZy1aguslijD0v3hyVKn76ySo1eIHws4N32M243e4zXwglHL757ZbOb8STbCfoouyx72ahqXbX+uyo8gXReSEt4bjkJUSjvhz3Cxp45+oRi1yRKb79j+ezV4ZTiPWGTqi2dxd+/vHbdw+dHW9rJaTJBkoEMpI6VKN8NMDbPL+kyPoUr9f3WAqT4KgIy1w1KO15KNJ2RLKUfyhARtvGqc4wrolRGyKB48yPl6EhWpW023BUSvTqs7o+W+715br/O32ErRH1OUKtnZWTVoyGHvf5aG+mP/kRvnQtraZQH6X+N/IQc3a4OkI3xEL9PD+Y5vbigPHN/NzDF8OJSZLlCxiMPvUVEhFsoISOuqrHPj0gMMEufRXJgEGoA46KSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 10:18:49AM +0800, Huang, Ying wrote:
> Ryan Roberts <ryan.roberts@arm.com> writes:
> > contpte_ptep_set_access_flags() currently does a (broadcast) __flush_tlb_range()
> > on the (pte_write(orig_pte) == pte_write(entry)) path. I think that should be
> > changed to a local range invalidation to be consistent with this change.
> 
> Yes.  This should be changed too.  However, it means we need a local
> variant of __flush_tlb_range() and flush_tlb_mm().  Is it OK to
> introduce them first and tidy up later?

If it's just for contpte, we'd never take the flush_tlb_mm() path. So we
could instead add a specific local_flush_tlb_contpte_range().

-- 
Catalin

