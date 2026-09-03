Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC010C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 16:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8FDC6B009E; Thu,  3 Sep 2026 12:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40CA6B009F; Thu,  3 Sep 2026 12:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A581C6B00A0; Thu,  3 Sep 2026 12:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1326B009E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:54:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91EB21405BF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:44:55 +0000 (UTC)
X-FDA: 85173025350.07.661E9B3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id CBA6D40003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:44:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qIgl9ysH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788453893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SURYOZp/VXSv7xhuiebhrfoo5cA2ejsPMI8WkYJjl1Y=;
	b=BaXidoMGrFlbTlO90JrrKDXOVkN5OOSGOFQ5oqeyRj4HSICBkaIv2IcXrX8nsFgYlYMRfQ
	4LyJ6jvf3R26Jzjxbtklq//S9h+p7zmNYkkaLDVstQXLpHqsnvA+3IC2o7h7/j1xZAq7sD
	C8o3umI3q+d813bAIf5wH5vtG3SIi4s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qIgl9ysH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788453893;
	b=iC3X0VBqL1yzZ5JUdJ9wqk5Mbd6XnA5+rR5lZV6p6sCKEECgOTDrJ84P2h9Brw3114bngK
	pRFGqBlzQoogiaujXsRL+xZf/D2sDgPY+vmppbUJ8lwlHdth3V0ScgMs39zSkV2/odECBD
	Vk4QKLudwrUQS6wvVluFeydcscPleHg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C4E21596;
	Thu,  3 Sep 2026 09:44:48 -0700 (PDT)
Received: from [10.57.6.2] (unknown [10.57.6.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 429933F673;
	Thu,  3 Sep 2026 09:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788453891; bh=qA4rheoJ8iR3/4lpM2DeCPTFOTeS21vpg0tV0VvZcRc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qIgl9ysHs8hvncgspgnHk7Jv77nImxk2SGegbvNrK97CXnpxi9vobsmMSzL/LvImn
	 K0dm/YLZgvYpz9RvrbRvwnzj4fSHcOcs2jBEr6vGKJwcSylRaMzhQDk1QhduhRmQkA
	 Nszi3HADTMiq4LAhhn3xgLeLgNQbqjcLeP5t0UTg=
Message-ID: <1334b43b-249b-4b30-b31e-72a4ac30670e@arm.com>
Date: Thu, 3 Sep 2026 18:44:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 05/25] arm64: Implement asm/kpkeys.h using POE
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
 <20260818-kpkeys-v9-5-743ad31b2c8f@arm.com>
 <apblxUah9EcQox-Y@a079125.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <apblxUah9EcQox-Y@a079125.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: sgygzz5q5hc8j3mstp5qnbhqig5845dq
X-Rspamd-Queue-Id: CBA6D40003
X-HE-Tag: 1788453893-224957
X-HE-Meta: U2FsdGVkX1/+Yf387tLxBTh9wNgjVQTe2nTswC0G0YKMYXZPz8AO7hdAHPLGCUsSN/zD7OtQpRYv+g+zeEl2ZLK3sizVMbMRkO9J7e+kz4QfTZhxM0gWk0mvq79DDKM+0rXQYh/sCdBY844mUgYW9MlYvfEfvperv8lg7JR7Bkmuoxc4liYJnX8cg6zfl6MERhSAHMD1+AFuqESa4nIOG1OMRigwMETzvnhGE/RgT1f9y+9PTLXcmCBijyud+Gg4a0o81NNYkhEvXCT7xqjdaEMa2Nw/tVBc+gFe3/9TOijdHOkk8EGU0E4zNqIaN5Ke/13U88tcDu+7ePTGUzECDynkBxP4eKKkw5OFyZRNTzbuR5dn0jffIhN133U/KUJ99RWam6TOvI67eDBiie1c33P4jq/aMoOATamWUR9PReXwtUG5JZmL2mPiHu1COhYpWJZ7eEvozY56js5Gs+LT3zP2FpL4hJ0gcXMXJHwEe3w591EPopajtHMe6STAOtnqzZ8bm8EgUJgt3zLvu9ybdfHh4xoT9foDiSS4WIopIJHYVG4rkq4ED6d5MC+1Q9XViwLIwQGszEBmsMk77Xt8S2hir9CyNDp88eDuktmSTt3wvcS3JEp87ttqFJ7F5mAqcwc6Kivj1KXdd+fNoGpRui3PZ6H0NeGG+5+hEZBMOkiOr+JdWl68lPS2o2QxxQAL9n342PcFSyzxdTt69TXEPRnVbP9NZdrXLhfz/PY9hM5tWB8Tuc24qpsPwhHzGMACb9s7QguvtFO+VbsqeMNbLP15q9kaUqFgPO9PY+tlHUm2W1yOgl9JlAh0MSSXs6FgODUCEWdjFk+ACak7gpKxPWPSSAJmP/oQe3IebCmFJaKuBZ6LPee2EGk0erz2jq2SNOiRXHo/7etVsOsZEfQkKM/aRClOfv0Y4fSgAD9Xb11IzeauiQ9KkcQgfJuECiCduQ9iCcb6QvVdlEmmvP5
 pIxrSbXc
 gYCufrud9Sfy9cO0/0vG8fYywI3yBRHZOWuDy9jv0LZUcVPdhzg1PYewTgnCwfI2KMLo315WsHHQwo7FR5bMSPoen1rROwLptRnsOUMuwGUKsJ65x5RezU4AnHRndMIiqrmJRyJKJlqOV+rtz5ALn3aLE1tebTNXdm+FWkK8/GGARN5t8Kes4vdYJzpE+gJMCOBB4nPCSLoT31ult8/sv7tvbbKX/IEyVzTyfsTCYawse0pwsVvuqFdS2YgXFuhUl4bSDdsmyenbDnLr7Tbybs3NcUfi4ixR2zv5thpO8ZG6Tikmj7X0rHfIQD8W4hekUxszEmRW7j9Hp9iI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/09/2026 16:48, Linu Cherian wrote:
> Kevin,
>
> On Tue, Aug 18, 2026 at 03:08:47PM +0100, Kevin Brodsky wrote:
>> Implement the kpkeys interface if CONFIG_ARM64_POE is enabled.
>> The permissions for pkey 0 are set to RWX as this pkey is also used
>> for code mappings. POR_EL1 is left untouched if we have already
>> entered the requested context.
>>
>> To allow <asm/kpkeys.h> to be included from assembly, also add
>> appropriate #ifdef's to <asm/por.h>.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  arch/arm64/include/asm/kpkeys.h       | 67 +++++++++++++++++++++++++++++++++++
>>  arch/arm64/include/asm/kpkeys_types.h | 15 ++++++++
>>  arch/arm64/include/asm/por.h          |  4 +++
>>  3 files changed, 86 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
>> new file mode 100644
>> index 000000000000..09fd5a849cb0
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kpkeys.h
>> @@ -0,0 +1,67 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +#ifndef __ASM_KPKEYS_H
>> +#define __ASM_KPKEYS_H
>> +
>> +#include <linux/kpkeys_types.h>
>> +
>> +#include <asm/barrier.h>
>> +#include <asm/cpufeature.h>
>> +#include <asm/por.h>
>> +
>> +/*
>> + * Equivalent to por_set_kpkeys_context(0, KPKEYS_CTX_DEFAULT), but can also be
>> + * used in assembly.
>> + */
>> +#define POR_EL1_INIT	POR_ELx_PERM_PREP(0, POE_RWX)
> IMHO, moving this macro defintion to "arm64: Enable kpkeys" , would be better as
> this patch is about implementing arch helpers.

But this macro is used in patch 7, 8, 9 so it should be defined before
patch 7, right?
>> +
>> +#ifndef __ASSEMBLY__
>> +
>> +static inline bool arch_supports_kpkeys(void)
>> +{
>> +	return system_supports_poe();
>> +}
>> +
>> +#ifdef CONFIG_ARM64_POE
>> +
>> +static inline u64 por_set_kpkeys_context(u64 por, enum kpkeys_ctx ctx)
>> +{
>> +	por = por_elx_set_pkey_perms(por, 0, POE_RWX);
> Guess, we would want to set the pkey index 0 only when,
> ctx == KPKEYS_CTX_DEFAULT and it need to be set only once.
> IIUC, we wouldnt want to deal with that every time we set a new
> context. ie. update only what is relevant.

Conceptually a context is a set of permissions for all the pkeys. This
function must set permissions for all pkeys managed by kpkeys. In this
series it happens that the two contexts both use RWX for pkey 0, but it
does not have to be this way in general.

- Kevin

