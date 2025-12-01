Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E10D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1086B007B; Mon,  1 Dec 2025 04:19:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178436B0089; Mon,  1 Dec 2025 04:19:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5F76B008A; Mon,  1 Dec 2025 04:19:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F29A76B007B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:19:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C669613A8C8
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:19:52 +0000 (UTC)
X-FDA: 84170355024.07.53A93CA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9915712000F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:19:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764580791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zhri/WaHFa2qtxgCVf5jXmZptcXeLm7jc4tOelOK/Uw=;
	b=5gnJOQN8THSgRq2wgGJguqkCiGmVesuYRp4gUueVNXVVMJmUNDSDRZEfpJaxA+rzUx9WVn
	3GOHThCFo6tMuuIiSuGdWYAhBa5UIMBXu75IUfk1ymb7ldegs6zMHjhbO3S7qnT5Il0WQV
	sukS8r2QHGK7jj/4OMJAGpefsnbT/N4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764580791; a=rsa-sha256;
	cv=none;
	b=jn2ZaFTbu6MC6prKZXj3+ihu/B4k49Y36qJ+SgB3aOYM6Az89OC7CbCMEAlDEoAIHj3yZ3
	wqGHXNiaLUhlKGvz7xWmYy4qQx/NNbmi272EUWV+n44CJ4Jr4531JAA4IcJPSSoVWdBATp
	X2QyQng6FjdFFTrLacRx4QKPkWeAqjc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25C10497;
	Mon,  1 Dec 2025 01:19:42 -0800 (PST)
Received: from [10.57.43.170] (unknown [10.57.43.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC6FF3F73B;
	Mon,  1 Dec 2025 01:19:43 -0800 (PST)
Message-ID: <c1226873-c790-49bd-876d-4539f95b4caf@arm.com>
Date: Mon, 1 Dec 2025 10:19:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 11/18] mm: Introduce kpkeys_hardened_pgtables
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <20250815085512.2182322-12-kevin.brodsky@arm.com>
 <aSnRVJwuRWPmPxqN@e129823.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <aSnRVJwuRWPmPxqN@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9915712000F
X-Stat-Signature: gen351tutc894nh9infr7zyr1jfyzgux
X-Rspam-User: 
X-HE-Tag: 1764580790-119720
X-HE-Meta: U2FsdGVkX1+K+nPkyI6KjLIhRAEP5eyT8yqMoIVoPZf/mjo/gQW7bdUoZY+aRZhnvL4qbHinBSqupkwX4o/99AmFbIJlIiJM7YgU88XvvS6i90QsKXlQwGyWoKOWG48RUTxoQJq6xVsmlqXGzDTxNS0o23PHzgbBk+JZqFSM/HdtrdBkz6yXAxNH95Z1c3/rC+1L/caACFRGSQ0HJRHT+86BUvhl+rUIBlzwuPuRPl1WcgU8b8F9bVx1ERsw88QHRc0EXUzctMrO8ekprKTgpwZ57hzmygM2t2neSQzBXP2tD8JdrzNC0hAN63gKd/YDh4gsqC5oK6ONs2TFqurgTCDbMXyi0ZJ+JzDVNIJIR3NO8BlTE2irNUOmyhrBYCakodZfNMA4hKNx6cy6uooHJWbNJHYs4dJ7oVam3UwPU67fzbJ6WVoFL//oR8OrS+1Fg95uLjMb6xzSpCfTE67R1hrVysY/kNSvocT2X20qqBrBsv2a38bwjDhGiuWOhklCV+ustheO1lk/HfGnNKr56G7WjwrpjbxZgJ0juD/zuQznSYSP3mXEmYsOh2wYBOBSzdEkY0Zg9MyHrT1jJus6K49Ja8DK2PnmzWpTERN2Sqjg7cIWjLpclM1BGWw0dPpUn/xlMORfcLkR8Y/k0yyEGdfYaH4rux1aM6FdxVStDKPZY4OHCxwY2gR3csKuGUcCuIbwhzawgKvKFaxjIcUnC0K8ihNvy3oYAgJDenRjNC1Vy0b3P4Q2+yzVTTa/KZjOmVOQN0oaKyHoo62LWiAjJddzoAecWnzilg2zDcnRcOYohsSAZkk4HYaw5sMF6KEcfy1USx2Yzb3/x+SLqKEsJzCyvlF9JcnMoK1mku3eM1WLnMrQ0QTXKgTYuqAe2ocW88Rqpo2yNlkYdezMbIlzTHC3IJYuV2RrdpqYLj7Y759Tou3do2+bWGUpZgRWnlA0C2iKiE5/CVDF3pQ0FTh
 mbzIltjP
 ig+T/ifNQf+KwOTSJaEXVBNaV/MK4jyGf6841f5+LLATtQjrykWgCuv6QZmshNKA97bLwUWJ0j4/sm55h8q+2VI4UqumDuGGxPr5M9VlagmSw16zLQ+uzslQIjgaqqZ8N7GdGwxlw7g8/7jn8friSsAT7p8MEzBhbfeNQsU+e/gc5DIvxn+fVo/V/eWI3xdrJKeAR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28/11/2025 17:44, Yeoreum Yun wrote:
>> +int kpkeys_protect_pgtable_memory(struct folio *folio)
>> +{
>> +	unsigned long addr = (unsigned long)folio_address(folio);
> I think it might need to use untagged_addr()?

I've never seen untagged_addr() used on folio_address()/page_address()
(see for instance set_direct_map_valid_noflush() and
__kernel_map_pages() in arch/arm64/mm/pageattr.c).

It does seem that page_to_virt() sets the tag if KASAN is enabled
though... I'm not sure what to think, is there a wider issue here? We
might just be lucky and the sort of pages that these functions are
called on don't have their KASAN tag set.

- Kevin

