Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C431C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 12:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44C56B008C; Wed, 23 Sep 2026 08:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5F56B0092; Wed, 23 Sep 2026 08:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A676B0093; Wed, 23 Sep 2026 08:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 869186B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:50:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FCD1A080F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:50:41 +0000 (UTC)
X-FDA: 85245011082.26.6F966C7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 23E8F40009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:50:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ol1t6jJC;
	spf=pass (imf07.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790167839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZA++Tvj9hJMIA5FBVjp4MmA1vHg81Quk3OB7rK0L/A=;
	b=OBm2lVW+V1FmJpCn6djRLbLnQCT8RfqP8pSgQGZeuInAEagaVIK7H4sJFDAN8k3xpgZSBQ
	GHRRAJuN7ECpMgOnWh1LcWY+hCi6H/05ephrzdoO2soSlxVpMg87pYy9N0sUaW+9oFLOO5
	aVBljrfOHQ0N3JKMX5LsFnhE//itMNc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ol1t6jJC;
	spf=pass (imf07.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790167839;
	b=vEyWw4tCpKiPzBqfJ/6Vesxnbrf1KceJ63ic7DBmuuaSrJycwY2SRgloOF5AKtXaryzFIp
	GE3TfW2rXoEh7MH+2mPtHz6OtvllL6/c4OeXdJ2vemvBKakYg8NhfCtIloB3G1EPV+n7fA
	xQ9m3mQKT5YU+Z5dpg1XE1wcdwo/Kuw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF16F1570;
	Wed, 23 Sep 2026 05:50:34 -0700 (PDT)
Received: from [10.0.138.135] (XHFQ2J9959-5.cambridge.arm.com [10.0.138.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8CB23F86C;
	Wed, 23 Sep 2026 05:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790167838; bh=z+yS/SoyIg7hhvgkUwal0qH2INlM/SI5Zl/XhrLUvFw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ol1t6jJCfzd6c8OpXVDodMTpqQmF63+NHtsFlKE4TQ375JHm/yI33ZZjp29fKkWf+
	 RfgLJJn28pc11PBO2a1AUz1svJeHdUebBJjxIokAlwBdwxnw8Lb76bFd3HRoK8JQ38
	 OrITSANkn63YEis81/z4L/rZwU7gTdMwO7FNk4hg=
Message-ID: <e852a2db-c15a-4e9f-b92e-ffd5740498cc@arm.com>
Date: Wed, 23 Sep 2026 13:50:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/4] arm64/mm: Use pmdp_get() for PMD accesses
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Mark Rtland <mark.rtland@arm.com>,
 linx-arm-kernel@lists.infradead.org, linx-kernel@vger.kernel.org,
 kasan-dev@googlegrops.com
References: <20260922061638.3967467-1-anshuman.khandual@arm.com>
 <20260922061638.3967467-2-anshuman.khandual@arm.com>
 <212067fe-1b16-4b87-87a7-4ce50847eb24@arm.com>
 <m72rpspdg5cv7xptent4tglgd25zehx462nfmcx5uyjwi2ag7p@bc6hvhosgtfb>
 <bce043cc-0f69-4297-8f31-92dcfbc0061d@arm.com>
 <7dn5t2m2fzuwxj2anuycz245hnctqc5mgaj5vdx7ybfql7arwv@6ac363txw3ff>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <7dn5t2m2fzuwxj2anuycz245hnctqc5mgaj5vdx7ybfql7arwv@6ac363txw3ff>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 23E8F40009
X-Stat-Signature: bfppgpx5xb5hawm6ajjdfuxxrmq9pjdr
X-Rspam-User: 
X-HE-Tag: 1790167838-858738
X-HE-Meta: U2FsdGVkX1/wAH08oWEWVQ7VUPuwO1USk8O6DwMWfpBA94jHDfUX5rpfh9Q1AMBjHvz1lnNDv8p0/CRduIvcX4q5WM8a9LTEI3iZcc14InkyJdQkV+ZeyxOM7jSz3+H1NythvG6uJuArZNCFUj3JRcBpv1vXbKUDtyvRBkc+cj3B6LQP/AQ4oCcdTdhR0keHvHyQJiW3SE/F4ffhbBtpIiIXB2BO1Qy+6DaSbqCZheIc6Opk9T1WYtaE2ngxb0ihU4BWjvZJ430cA/cdLl6m/IKXU/0i8c35L9/5eS2ayJOjJ473urvXVC1bt5KQL7bFK913FPsnYd/b6rLQfmthXSab/5lNujQNjp8N+33d3Zau2sY17/+ZhuF6WBNettofORPdtvnvONtacj4ggdtktOAnRLvclF3NKbI3zAwT8VNGtF1Htq+JB7PV786SVPCAPDopka+RvOkMesT3a5zOelSKqxUggQye/DX9qfnXju0DvIWW7kRx+w7CXGPH+BUo4jBvVRnHs3jYo2QfDgXn+eXQSVWFlQ81mfkEl22WXmzfSmM5h6fqRYJvhjqebhQbEaRENHif2G+Xl/6IRwGwCngNxvIA9dMllrbuHZullDL6IneXRqcc3gmLiOnlXE0dy57CzoSAT0evEYUEk+v8nnVn6+PQIbJO9w9C3VOAEJYUVZstG3P/JgxSnDkzYmcFsxTIyxoO5hcsC8nO+jrxjqiKANqeTkesyad5ltMS+zWZIe4WvNUbH7R6Db65OTmLzp9Qa71yJK9ZMeQoBZlvbRhWyPRHwpLRuNTHVFhQIMdOeoH8GMlxSijeyQsVOOL6OgJ9L3tEGB2KvJ59NB3Chiz1lWWggoDbXQYWWv+IVaLwuSsxlu7hFAQjJxdggB03kPbI9b0R3I+Va8GbiVOWkLZus9TN8D4Sp1qBrW0jim3hN6AXE9KccD+eHkK6DwB1fWrmfnTWZJzxBPTbUKw
 el7gVfAu
 btLNE1DjB90CfBrfUjd4sVU8UFoFUKXdKQg1Seucz9aedOfFvjD9U741DBmeE8IJrII2Lusr5xuUZg5Og8r9osFXT/KZ9lpye/u5IodEZTHh+YAdhI9d9g+V6zoilNFu9C7XaNx0luDrxx/3zV5BoGytKSemmD1paE5WjlO062Z+gYhSH44KafMkqSOlsRM64qYtXdVq1cPEi84Wbdx/8JvhNCXpeCMTWUGHRN7XWaghz9e458wKMLDaJCr7IlR8nTKz3Ro9lijB3Jm/FrskIr/AHKXOLK2+8HhQanNZFUyeb76dGV/Urt6J1REjOoKUjVOaTtHJ7+aVyommDrYwznzwuI3tr0BiREiHyaORzn9BcUkI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/09/2026 13:22, Anshuman Khandual wrote:
> On Wed, Sep 23, 2026 at 12:31:42PM +0100, Ryan Roberts wrote:
>> On 23/09/2026 12:01, Anshuman Khandual wrote:
>>> On Wed, Sep 23, 2026 at 09:32:17AM +0100, Ryan Roberts wrote:
>>>> On 22/09/2026 07:16, Anshuman Khandual wrote:
>>>>> Replace READ_ONCE() with pmdp_get() for PMD accesses in preparation for
>>>>> supporting both D64 and D128 translation table formats.
>>>>>
>>>>> READ_ONCE() cannot currently be used for 128-bit page table entries on
>>>>> arm64 because it does not provide the required 128-bit single-copy
>>>>> atomicity, causing builds to fail for accesses wider than 64 bits.
>>>>>
>>>>> Although LDP/STP provide the required atomicity when FEAT_LSE is
>>>>> available (as required by FEAT_D128), extending READ_ONCE() to support
>>>>> 128-bit accesses is undesirable. READ_ONCE() is a general-purpose API,
>>>>> so doing so could encourage other 128-bit users that would either fail
>>>>> to build in configurations without D128 support or, if D128 becomes a
>>>>> runtime option, silently permit tearing on systems without the required
>>>>> hardware support.
>>>>>
>>>>> Instead, standardize PMD accesses on the existing page-table helpers.
>>>>> These can be overridden on arm64 to provide 128-bit single-copy
>>>>> atomicity when required. No functional change intended.
>>>>
>>>> I notice you have an unconverted READ_ONCE(*pmdp) in
>>>> pmdp_test_and_clear_young(). Is that intentional?
>>>
>>> Converting the above READ_ONCE() instances as pmdp_get() cuases a build
>>> failure as pmpd_get() which is defined in generic pgtable header is not
>>> visible inside platform specific pgtable header, even with a forward
>>> declaration.

I was wondering why the forward declaration doesn't work, but looks like some c
files include asm/pgtable.h directly, which explains it. Let's assume there are
good reasons and unpicking it so that only linux/pgtable.h includes
asm/pgtable.h is not practical.

>>>
>>> In D128 V2 series these conversions were performed later in the series,
>>> when platform specific pxdp_get() overrides were added via ptval_get(). 
>>>
>>> But to avoid this, we could just move pmdp_test_and_clear_young() inside
>>> arch/arm64/mm/mmu.c file instead. Folding in the following change builds.
>>
>> I'm not sure if/how this might affect performance? Probably not significant
>> since they are for higher levels, so not called as frequently as pte helpers.
> 
> Right, should not have much performance impact.
> 
>>
>> Another option would be to implement arm64-specific pxdp_get() helpers in
>> asm/pgtable.h to override the generic versions?
> 
> For now those will still be based on READ_ONCE() just like the default ones.
> Although trying to drop similar redundancies from other platforms :)
> 
> https://lore.kernel.org/linux-mm/20260923043226.331880-1-anshuman.khandual@arm.com/
> 
> But given D128 is going to define pxdp_get() anyway it might make sense to
> define them now and withdraw the above series :) Seems like s390 platform
> also has similar situation.

Given the desired end state is that arm64 defines it's own pxdp_get() helpers, I
think the best approach is just to define them now (as READ_ONCE()).

Thanks,
Ryan



