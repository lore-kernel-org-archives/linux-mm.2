Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FC01F436B4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 15:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7DB16B012B; Fri, 17 Apr 2026 11:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C550B6B012D; Fri, 17 Apr 2026 11:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6AA56B012E; Fri, 17 Apr 2026 11:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A48EE6B012B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:59:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A54456772
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:59:39 +0000 (UTC)
X-FDA: 84668508078.20.0BADE49
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 167DB40007
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:59:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dKqzTM+j;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776441577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8FO8PzF0PieyWhQwCeTDRN7VIBMniarhO6pmXOcNmE=;
	b=mCC2vDknWhvWlRRDuQEnhEYghkRzt7uty/bGzRG3nKGraEFjqOjM9NsRYdvLjqtpx5wLhx
	U7Kz8uMTemM7/f+loEVAMf6UioWFL/BgfXLNqYuZbu/PscdCEIGdsefffZp/iVmXaNOGLA
	ne9vnIU41Fb2NO6l0Uc2gLF9+E3zVxw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dKqzTM+j;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776441577; a=rsa-sha256;
	cv=none;
	b=LLYvKzpYQk5lc4yzFIMWMsK98EfvEu1MjkIkdZVmIrrsRx/LN4Wm3GJ8B8nbsMgV/2N/Ai
	bdkHtFisTJh6BVY+VSc5ZfVla3Muev3GA9LOxo1u4+hhSzo7gey4QQ6JbCspHFiL+TgONJ
	tYnJLrkf6QXCUUZclC36M2LvXQ6DNlE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B11D1DB5;
	Fri, 17 Apr 2026 08:59:30 -0700 (PDT)
Received: from [10.57.63.31] (unknown [10.57.63.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 338A23F7D8;
	Fri, 17 Apr 2026 08:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776441575; bh=j8FO8PzF0PieyWhQwCeTDRN7VIBMniarhO6pmXOcNmE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dKqzTM+j4F58kIlpCMfJfslXRAvTIV63Jvs8XKtFPmTHYNKP2Hv8L1yPWqACikmRb
	 b+TajA/SlxbTw4g2mMiYjf5eL8R/K3voQJzpqhOA7XvIo434idPxeQ4QAJe9tq+kr2
	 S45xgvtee1/IiZZgthWVd5FLYan71Tu1mwyJ2OjU=
Message-ID: <913002a5-e002-4001-ad19-037102d1f97d@arm.com>
Date: Fri, 17 Apr 2026 17:59:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/30] mm: Introduce kpkeys
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
 <20260227175518.3728055-2-kevin.brodsky@arm.com>
 <00b24db8-0063-48d6-8bc4-e8b670d8f0d5@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <00b24db8-0063-48d6-8bc4-e8b670d8f0d5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xcehk88mn43so76xifogfdb1s1b7awni
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 167DB40007
X-HE-Tag: 1776441576-672101
X-HE-Meta: U2FsdGVkX1+llR6XE5lV3d/Mk+jkCCGzeurirhjx/nRSdATzQ2gp1KcDL6y3VcFoCp1u4rDeg04RghvR+QcHY3HIXhicYw2NenuO84hY0Y6/p48JYJUkGwQLZRX/nN+C2uw/rbUmPAFo6X+697yYw6ah4/PopgatWG7Z7SXZS0NT/jLiEtX1WIT7X/K1O8TA587GzzzbWVi5PgklkLhPEYFMZk1Ksl5eGZ5ESEegqAKpwwUP0IwpVyd4QjPcdzKIJ8n9oz+WV+UGbRqCmAePGn8Ec4zYSH6bIyEThRT7Uj8jzJc2ZRifaPklMvoKMJL10yDkZhTVUYHd2+QW/Sjvfwtl/fe9LjEsYb+yas0R/YR4EdvWmfyR1qhHHaLi2oCR2++XqqHUvoDv78oxr4+sZtytM6NifOpjUY3TcEZCHcrkaIdyF7KDXPdyAmhtWGT/OjYyeNuA7b3v2k66y5adumczZLFcAnYFWCfuKZ2iDv70YkH7y705h6XjRgfxx5ff1FWiNjF/EI9IqiTpvTbQhrOJ/WDlEaciaOWgVlJZVgPgmHbY9+hUWgGW+eBBdrrncUQhmpHRI3dMGfwb5W7ryaTvbQM0pxuGkA8TiRFP2Duw58FtbwMTZm+ey4kE0WZ5dXvCcd60oW1opNccRt8eegfrY6Q4AWarPO4GKP5NZUgGTJQQ8AnHa8vT9F9AwDu3yMN5Mt8GLUCoRMZSY99oOA3xbfBQ/OhXMYxdVEfZ9c4QZqLTDHylaRd09dAOlRRZu/1ju8spv/ZVGCws3yu5bVTX9Ncv92MxxJlwWrj3AoIj/OjX5RhsfsHHk63cZdYpoeym4N72uw+OuM73+2z+8/adLxyLsKS/tCHPsJ2FrrL3UbBb8n2LDAoFSuTwRT5rSzQCfD63xJIfnok0uZuidDrEAw6G/q1S0ycrAhxip0eO7EA+cM642KEzS/dY7eOJ2RAKhs0q6gh6Sk7TRcr
 zT4+RN6w
 VF1nc+O1FTpuLHkm1M6JTpMpbz1INDaG0F5LdhWG0GlVNHGzroH+0Koe+0WH9hfF2K6IBaob8eQBSVER64x9KxZPcKHFNBRMTroucwrA6XuNCWDBqh4BPmHmcUIb2mXg1Ug5SEGRzw+CYvIWIpR5RFJmNBgd7rSGaYbQsEPcduPyJBNBqubWvn71qJgCRKGecp8cXmiWYSEaCHO60Rr4hdUF99ilNyuKpDh0nuioAjFKwvxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/04/2026 16:37, David Hildenbrand (Arm) wrote:
> On 2/27/26 18:54, Kevin Brodsky wrote:
>> kpkeys is a simple framework to enable the use of protection keys
>> (pkeys) to harden the kernel itself. This patch introduces the basic
>> API in <linux/kpkeys.h>: a couple of functions to set and restore
>> the pkey register and macros to define guard objects.
>>
>> kpkeys introduces a new concept on top of pkeys: the kpkeys level.
>> Each level is associated to a set of permissions for the pkeys
>> managed by the kpkeys framework. kpkeys_set_level(lvl) sets those
>> permissions according to lvl, and returns the original pkey
>> register, to be later restored by kpkeys_restore_pkey_reg(). To
>> start with, only KPKEYS_LVL_DEFAULT is available, which is meant
>> to grant RW access to KPKEYS_PKEY_DEFAULT (i.e. all memory since
>> this is the only available pkey for now).
>>
>> Because each architecture implementing pkeys uses a different
>> representation for the pkey register, and may reserve certain pkeys
>> for specific uses, support for kpkeys must be explicitly indicated
>> by selecting ARCH_HAS_KPKEYS and defining the following functions in
>> <asm/kpkeys.h>, in addition to the macros provided in
>> <asm-generic/kpkeys.h>:
>>
>> - arch_kpkeys_set_level()
>> - arch_kpkeys_restore_pkey_reg()
>> - arch_kpkeys_enabled()
> Another thing: why not simply drop the "arch_" stuff from these helpers?

The first two are not meant to be directly called, they're the
arch-specific implementation of kpkeys_set_level() and
kpkeys_restore_pkey_reg(), and those generic functions handle some
generic logic.

arch_kpkeys_enabled() is directly used in generic code, so I suppose it
could be renamed to kpkeys_enabled()? It's actually implemented in an
arch header so I wasn't too sure about it.

- Kevin

