Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF32C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 16:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9BF66B0099; Thu,  3 Sep 2026 12:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CAB6B009B; Thu,  3 Sep 2026 12:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A956B009D; Thu,  3 Sep 2026 12:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ACEE6B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:49:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61FD31405C8
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:42:10 +0000 (UTC)
X-FDA: 85173018420.16.5882F30
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 59BDD80009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:42:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="jS2Asm/U";
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788453728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8pQRfh31VGnGXGPzZ2t/4UaiVIHP0r6rObZCl6Q+iY=;
	b=nxDgSTUobVpnL2kvdJ+NTcYG1iwkxk6Y5Jvo4/2/Mq5JQPqXWtdkTa4US/T6u3Q0p4UaL6
	WTFhGP0MTv7/Jqj7/WX71mbPPcpRJUwzA0m9498alcS6pArtQgobhqKeQdGmRCnZ4gfgMG
	AXbRZgVHbXQLn0iRhhUAclq0ON4dhN0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788453728;
	b=RLDwwnHM+zP89r1jkiE+YYG16YAiJGkYQofc1sf3MJmLVPHWjMKuMEQf5xCSKJ5BBUab4p
	+OrQpm8eHFPmkC2lhSJLO1EPqv4comIcbc3swu724p89RtEdDklBlbbRjgvgsUIWY57hBx
	LEbI+hFLzzcEH8g2+SYNVOUolEfdwPk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="jS2Asm/U";
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEC7E1596;
	Thu,  3 Sep 2026 09:42:03 -0700 (PDT)
Received: from [10.57.6.2] (unknown [10.57.6.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F24943F673;
	Thu,  3 Sep 2026 09:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788453727; bh=hpWgr2ZJY3qJKLttzHDS9l/xybICdRKBZ0Vb9KipRwA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jS2Asm/UwfhzBaNFvf9emw9gKWsaUHT9+Ly9ueyblpJtMszHw0BiQrvZPl/Bzqq5c
	 ROwk1AuUKsBRjDM/KXiD2FJZeqlNkN/NkAdAbAKu5SuquX6KDjPQzQ8pgcjEcU7WYq
	 AOJfjrL3ylui6l8L/lkx7tW8ReJG/FtIsmjp6kbU=
Message-ID: <91154245-af39-4e93-bf2f-dd878f86c9a0@arm.com>
Date: Thu, 3 Sep 2026 18:41:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 03/25] arm64: mm: Enable overlays for all EL1
 indirect permissions
To: Linu Cherian <linu.cherian@arm.com>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
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
 <20260818-kpkeys-v9-3-743ad31b2c8f@arm.com>
 <apbjpkTgtdXZQ9Sm@a079125.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <apbjpkTgtdXZQ9Sm@a079125.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: noah3ymz9se8djwcwd9w4ukafhhrk5ta
X-Rspamd-Queue-Id: 59BDD80009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788453728-545722
X-HE-Meta: U2FsdGVkX1+K95IIyg66voxbJQYsTDvcX5Z0NNpppUsZNOhB/GkPbPZu5ooEqTNgtJbtrr5FxX3y68CTbjFRvAfdjlqC3cPR4H87XA97GN6TWBWfzKrH/hlel6sz58OyMvDvXm+5cJ4u62o5Kaj8VvcTUNuo9NCQBsTo4mzNoQOiUeMZVqNlmK9xEltwpfGv80pv42ve4eHO82Ub7y8+JmZ4ocIgEpGVlirrnBbLK/W818BlPGTWPeFP0xXKKSfKuq9AT5JImlgsuvWkKkDubS4m5oD6PLcE3sYodukCTvuTaQuVW9glbAGjPdsWmwgW2c4VrkvcTaP4H7h8ZBborQ1nPwJOimAPxV7GfbGae6sgLjtFDoTRvHehlnWfuoutHy1GLBOi8wTa6BhvTU6VdZUEmt1uBNZp1bym5RYP0aQluydOs70i0N7spBbwNO5mCb8P5UEnZ3ToNV8cstGLb1yaM0kUawycw+5ZmMQuHSVfE4/mQsEABjjHwvCwr96WZCQTCDsvYRMe58Ffj5CMZgUbi6mB2eipCZdiJL233DXM/bxyrTbK2lvvncDzSAiyZzZMH4om2sb8RTcD++dG6MS462NoZKkhGq7/xao9NijnbW/bdM8N87BRKgZFlZOotkjd9TmlUagq9EeC+/BEXzZ/Tc8jcbgbt0aRh4bBzHgRgN78r/CQXvLpV8dDB9BVLJTrkkr8HfJ6/gwbR8eHN5IiTiZPW1Dn1K/q5TsRuP6A/OiV4i0nXkRf+GV+0RrVGa1julZgAiNFMM3F9A9HacXFhiS74XlZO+KpdvxglhjqC9SK5rVanJvLIglqaNewSJnpvA9h8Fj5uDwLq4Tsm4c79QoYY3gB0d2G/lAsxA0ck/V5x8/6vEq8Tr5bxUj0XmdpIxMKnVEeMf4hc9CcPzAdR9bQtv0FWxXXwb9+RTrCfxfzUdduYxwYOzxuocsXoKLwwd+UD4hdqUkf7TF
 FY7/dUmG
 86JZVAaEGAFfwIUwu1H/oz5tsNzC5/PQuMrBP79XjJCAexxb49z28gxEVsQR6npSDXLMHsmqDtRGF/T6VISFiYu2aRFHt76g+mcXVhzy1HEcVoYsxloepe2xsCMW31fyWEeNMJJ3EWYiU3AslebchjXKWCh/DafrrBf+LoSEP9RdOKYjbavRKDWzrJaXH2IU5L8uZqiaWgbZkE/rSRObNw2c3uXXYTzwxkwVVbOIh7Y6ArJMoTbPPkxR65pDLBK+zR5H4Ilm3y6z3uMffsqkN4RsZrdVc01jLG1p9pammZfBBP94vId1F+fn+nTxvIl/3LVSL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/09/2026 16:39, Linu Cherian wrote:
> Kevin,
>
> On Tue, Aug 18, 2026 at 03:08:45PM +0100, Kevin Brodsky wrote:
>> In preparation of using POE inside the kernel, enable "Overlay
>> applied" for kernel memory types in PIR_EL1. This ensures that the
>> permissions set in POR_EL1 affect all kernel mappings.
>>
>> User memory types must be left untouched (overlays not applied)
>> because any privileged access to user memory (e.g. futex atomic
>> without FEAT_LSUI) would then be mistakenly checked against POR_EL1.
>>
>> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  arch/arm64/include/asm/pgtable-prot.h | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
>> index 212ce1b02e15..d4d45ab86a5a 100644
>> --- a/arch/arm64/include/asm/pgtable-prot.h
>> +++ b/arch/arm64/include/asm/pgtable-prot.h
>> @@ -183,9 +183,9 @@ static inline bool __pure lpa2_is_enabled(void)
>>  	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RW)     | \
>>  	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_READONLY),      PIE_R)      | \
>>  	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED),        PIE_RW)     | \
>> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX)     | \
>> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX)    | \
>> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R)      | \
>> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW))
>> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX_O)   | \
>> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX_O)  | \
>> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R_O)    | \
>> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW_O))
>>  
>>  #endif /* __ASM_PGTABLE_PROT_H */
> IMHO its better to have this patch just before, "arm64: Enable kpkeys" for
> easier review. Otherwise,

Sure, I'll move it.

> Reviewed-by: Linu Cherian <linu.cherian@arm.com>

Thanks!

- Kevin

