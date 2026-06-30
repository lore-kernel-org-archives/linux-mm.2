Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D27B7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A8C6B00B7; Tue, 30 Jun 2026 05:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22A36B00B8; Tue, 30 Jun 2026 05:16:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39226B00B9; Tue, 30 Jun 2026 05:16:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1C0E6B00B7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:16:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 218538DCF3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:16:44 +0000 (UTC)
X-FDA: 84936023928.29.E80398B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id DB48EC0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:16:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OhlBURWG;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782811002;
	b=TcXeYEGQ4AV6DubfohmF2nIrAdAxSobydZ+odqitZA6N5JJfd1uZvRX0Dy4kbkgTT4G3Xo
	2xW68KLBGJJmd/GCqkoiq8CyPnXAGvIs0RaiMC9OLh/IiDaKI030RaGPnBJw3rFQoaO+jd
	eO6iHBgy2RYFcWpyJPA8X/OWeNLNILg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782811002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aBg35UbhV6mbQWeCQ9pQpDL4bAnyZsscC2WQYIptGg4=;
	b=NVbdNg35i1XR81F63PtfkDtJ3V/WTjuw5lW79KDCi3S31ANGTwegMAeGDzI/JM8Hpyyde+
	baDeCkPzA7PoYih9AsfmwE9COKuO0Hmp0HuxFP7g+ChuCWfR6KPzokkPUwps8FFesHGFWt
	gK2crLc8MPM13woXq0oOR90JKta/Yqc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OhlBURWG;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68EE12C1C;
	Tue, 30 Jun 2026 02:16:36 -0700 (PDT)
Received: from [10.57.81.132] (unknown [10.57.81.132])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F30143FAFB;
	Tue, 30 Jun 2026 02:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782811000; bh=pOGqr+6YjRRrGfqyTm37l0BuFHy9XPuCtkGh7B9Kr+0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OhlBURWGxQqcbV6J2ZjbPLWqe0+OO9mHDyY8RjjqBPKuIiYpX91UGBHlnRLA2voBR
	 ZGfe8UhEF+CVHnpiOUhkK+Si+HmROlqhNQzZWseJfpnlDEHoIShP9UCusiuqoiShd4
	 QVu9mycDBfqeZmeTAPiDcXgKfSZGryWFP031nXt4=
Message-ID: <e4f98e9d-9f02-46d3-90ff-22ec711ba85b@arm.com>
Date: Tue, 30 Jun 2026 11:16:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8 05/24] arm64: Implement asm/kpkeys.h using POE
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
 <20260526-kpkeys-v8-5-eaaacdacc67c@arm.com>
 <f8507ad6-761c-4073-85ae-bddb2a07d660@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <f8507ad6-761c-4073-85ae-bddb2a07d660@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB48EC0003
X-Stat-Signature: t8x9wioedpquh8c9xm9s1qwsqx9rtw79
X-HE-Tag: 1782811001-748916
X-HE-Meta: U2FsdGVkX18uEeQfGFLaTc7fO2eRJFsHwVzCblXFlYwXI2pp6VnIVkUACgUxM0s0zF2H3JDaY3s4Bo1FNW8YCFuLoXKDGIVXGKcecuu9U6g+Qe6ZmwhADyZEOnLtWWSGIzgwvu7gCVfK/FRxuUaZg53W+CgRHfdXUYE/j55it+zxR992s0n6JXl7InzyD4cmsnh8d8S/zZkNgq7hm7EuefjcR2lI30fxWzLB5/KT2q6KDGRojYOsEJZX3E1PrInyw632fGrox0CYLvII6Ga6Yjv+OXdtf+jBPJUUNIYN3bskLu11Pq91SR+mExRQO8/yqhhQwcz6RC7mtWyZ3OkKgS0xhpyOzifHnIWCSEMCVuhMm8Y30FR11tUnwo3hbLAyXUkB+bIiWnWN0SGIiARD4BMiMg9pUuTe7ssAr6I4Hg4eUSLcvzy1qxDMrBoZgiN42P3KP98RMK6k2fysrluqSsMCJ1FHrEWNbH1qMEv1XKCRdnZbVaVKxrWDq64f+LSqbjA7Xi7VuLNHh8BmGUc4fZwfCz4Ehr5FQR0E4NoDUgEJh0psBZeVB20/KJN4G599BAjWT+49hwDpmN5ExAZhe+b9hjHEv14BGThSBlhP0ycch8MPeyejfM0SyZS+EIfYChdfiZOB4Cpzz8WrfQmqCkhn6B0Vg7vjCbcpU77yptP9GtTM5ZKBxITJ3VsoUxBQ7wJhtSoqArqr9nzv0W2mITYIXxJtIWA8kvZIw3WbHH14YkIJ7j9BfqQd9UdS0WczMKh4a992VxOvBT07/x8bgF9vR2v3W6litlMH1fm53uV/OfglZktozI8NuP53Qkagd64Utsqw/CtTKWfBv245qoVDm+hy7wSLoP+0feWE3PqJVjgajLIQnhOiiX/YU0srU5zIm8R4K0oFpjPY5iK5p4NGbhqL3qs9P8TiVoUVRh0Z2Zjzdup2iWAHT2EFhimro27gyF1m/Z6WxYpmwsm
 OA5thoeR
 rrGE5dzMaB5jUSXCq27PguNLfDB3DVA70n2QLW4CWGt/3u6FAPMDWxygjZNkNS3hBIDEkYpooNggGQu1ZF0+rjXElgxLU796qsPGFRXDMP0YAdZ9YsGqQgW7bicF/+0FWax+efLYpWZU+xBLKbsRqZaEr6/x6vg9Aje8bSy0tVea40Pbqe/rkl7kpSDREVxPopOvzhmfbY0Cb9kjoi1ySq9Hqc0FBxjqm1z3wBoaNPbV9Kq3xnUukT8wBKFTzncJ9R/4WcN4ykm/Ezs/14iFk5DFlMKjmmvBt2GNGpKYjGRx9RJyqvW/e0KI9lr46skBEQNDyem2H/NVnmy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/06/2026 15:35, David Hildenbrand (Arm) wrote:
> On 5/26/26 13:15, Kevin Brodsky wrote:
>> Implement the kpkeys interface if CONFIG_ARM64_POE is enabled.
>> The permissions for KPKEYS_PKEY_DEFAULT (pkey 0) are set to RWX as
>> this pkey is also used for code mappings.
>>
>> To allow <asm/kpkeys.h> to be included from assembly, also add
>> appropriate #ifdef's to <asm/por.h>.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  arch/arm64/include/asm/kpkeys.h | 59 +++++++++++++++++++++++++++++++++++++++++
>>  arch/arm64/include/asm/por.h    |  4 +++
>>  2 files changed, 63 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
>> new file mode 100644
>> index 000000000000..4dbfeb3dfcfe
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kpkeys.h
>> @@ -0,0 +1,59 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +#ifndef __ASM_KPKEYS_H
>> +#define __ASM_KPKEYS_H
>> +
>> +#include <asm/barrier.h>
>> +#include <asm/cpufeature.h>
>> +#include <asm/por.h>
>> +
>> +#include <asm-generic/kpkeys.h>
>> +
>> +/*
>> + * Equivalent to por_set_kpkeys_context(0, KPKEYS_CTX_DEFAULT), but can also be
>> + * used in assembly.
>> + */
>> +#define POR_EL1_INIT	POR_ELx_PERM_PREP(KPKEYS_PKEY_DEFAULT, POE_RWX)
> Okay, this matches
>
> #define POR_EL0_INIT		POR_ELx_PERM_PREP(0, POE_RWX)
>
> Is there a good reason we need KPKEYS_PKEY_DEFAULT at all (and not similarly
> just hardcode it to 0)?

I did wonder about that. As per the discussion on patch 1 I don't see
that value ever changing, so I'm fine with hardcoding 0 if that feels
more consistent/intuitive.

> Just wondering, because apparently we didn't care about adding an indicator for
> user space pkey 0.

It's never too late to add a constant for userspace as well, but of
course since it's been ABI for so long the value isn't going to change.

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
>> +static inline u64 por_set_kpkeys_context(u64 por, int ctx)
>> +{
>> +	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_DEFAULT, POE_RWX);
>> +
>> +	return por;
> Why not
>
> return por_elx_set_pkey_perms(por, KPKEYS_PKEY_DEFAULT, POE_RWX);
>
> ?

Because of patch 17, I wanted to minimise the diff. Happy to change it
if that feels less surprising.

> In light of API discussions, it would be nicer if arch_kpkeys_set_context()
> would just return the old context. But that would mean that restoring the
> context would require another read_sysreg_s(SYS_POR_EL1);

Correct, that's what I wanted to avoid.

> So instead of returning magic register values, that should be wrapped in some
> arch state struct as mentioned as reply to a previous patch.

Agreed.

>> +}
>> +
>> +static __always_inline void __kpkeys_set_pkey_reg_nosync(u64 pkey_reg)
>> +{
>> +	write_sysreg_s(pkey_reg, SYS_POR_EL1);
>> +}
>> +
>> +static __always_inline u64 arch_kpkeys_set_context(int ctx)
>> +{
>> +	u64 prev_por = read_sysreg_s(SYS_POR_EL1);
>> +	u64 new_por = por_set_kpkeys_context(prev_por, ctx);
> Both can be const.

Sure.

> But maybe you just use a single "por" variable.

Not sure how? prev_por is returned and new_por is based on its value.

>> +
>> +	__kpkeys_set_pkey_reg_nosync(new_por);
>> +	isb();
>> +
>> +	return prev_por;
>> +}
>> +
>> +static __always_inline void arch_kpkeys_restore_pkey_reg(u64 pkey_reg)
>> +{
>> +	__kpkeys_set_pkey_reg_nosync(pkey_reg);
>> +	isb();
> Why is that isb() for both callers outside of the function? Do you expect
> another user that doesn't need the isb?

Outside of __kpkeys_set_pkey_reg_nosync() that is? That function is also
used by patch 22, which doesn't want the ISB because we already have an
ISB somewhere else. The naming follows that of __set_pte_nosync().

- Kevin

