Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE3A0C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 02:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83ED76B009E; Sun,  5 Jul 2026 22:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF216B009F; Sun,  5 Jul 2026 22:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705646B00A0; Sun,  5 Jul 2026 22:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 243386B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 22:41:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EC75C1739
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:41:31 +0000 (UTC)
X-FDA: 84956800782.14.582891D
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8F330160003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:41:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6kW0tTks;
	spf=pass (imf08.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783305689;
	b=lQXOsYx6ROLakc94Kvnoo3MHH7uTpB4Vv3VJZPymIKdi8LpiOjrAzGLz4e/6fQXlscXOj5
	V426tYniCBHx1gtNOwc+MX+TInn17SXWVTcfO5jH+HFsiz2A3dVaq+w1T0ncdgMhyBisEW
	pqv10UtWhqc1+Fvva9Qb8G62vc0MmzU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6kW0tTks;
	spf=pass (imf08.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783305689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLzU64zcWCpCqtKqdJfi72+8jOLqHwm6rAX9TlEnpBE=;
	b=v/HPv0sjjIn6Kgni/SMYZ6CMcxzwNQLCN0vDMiVRg0KZJu7ZoIGkwoV/i0IKlhiEwwo3EO
	XF4f6qI4nsy7Utfsoh/1EBH6Mmp8fPn593o+lFuWXuMVnUdlERHoaCSLGE5P+a2KWvIQds
	DxfdtLI7ISUFDAZWHyTgUaU1D/efcdM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tLzU64zcWCpCqtKqdJfi72+8jOLqHwm6rAX9TlEnpBE=;
	b=6kW0tTks7I4JJHDfBVjF8dEaDL2J766PtNvpdA6LbQQFpMfTqMznvyBNQeh9wxbc/IYSzn3ZU
	f2djYQecToR3moTosPPfqQapkuoiHKQieMFK0sbmqWZPM62GXgOZ9REO2UonKr5TBLANxucel3h
	3onSIAA/PUlP2PaW4QIuLbU=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gtpKR1VVJzRhVJ;
	Mon,  6 Jul 2026 10:32:11 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 836134057A;
	Mon,  6 Jul 2026 10:41:22 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jul 2026 10:41:17 +0800
Message-ID: <e53b3d1f-c9fe-428c-bf1c-6505b3bcb894@huawei.com>
Date: Mon, 6 Jul 2026 10:41:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 01/18] seccomp: Convert __secure_computing() to return
 boolean
To: Ada Couprie Diaz <ada.coupriediaz@arm.com>
CC: <oleg@redhat.com>, <richard.henderson@linaro.org>, <mattst88@gmail.com>,
	<linmag7@gmail.com>, <linux@armlinux.org.uk>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <kees@kernel.org>, <guoren@kernel.org>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <geert@linux-m68k.org>,
	<tsbogend@alpha.franken.de>, <James.Bottomley@HansenPartnership.com>,
	<deller@gmx.de>, <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
	<npiggin@gmail.com>, <chleroy@kernel.org>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<hca@linux.ibm.com>, <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
	<borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
	<ysato@users.sourceforge.jp>, <dalias@libc.org>,
	<glaubitz@physik.fu-berlin.de>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<luto@kernel.org>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <chris@zankel.net>,
	<jcmvbkbc@gmail.com>, <peterz@infradead.org>, <wad@chromium.org>,
	<thuth@redhat.com>, <mark.rutland@arm.com>, <kevin.brodsky@arm.com>,
	<linusw@kernel.org>, <yeoreum.yun@arm.com>, <song@kernel.org>,
	<james.morse@arm.com>, <anshuman.khandual@arm.com>, <broonie@kernel.org>,
	<liqiang01@kylinos.cn>, <pengcan@kylinos.cn>, <ryan.roberts@arm.com>,
	<yangtiezhu@loongson.cn>, <sshegde@linux.ibm.com>, <mchauras@linux.ibm.com>,
	<austin.kim@lge.com>, <jchrist@linux.ibm.com>, <arnd@arndb.de>,
	<thomas.weissschuh@linutronix.de>, <sohil.mehta@intel.com>,
	<andrew.cooper3@citrix.com>, <jgross@suse.com>, <kas@kernel.org>,
	<x86@kernel.org>, <linux-alpha@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-csky@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linux-m68k@lists.linux-m68k.org>,
	<linux-mips@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-riscv@lists.infradead.org>,
	<linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
	<linux-um@lists.infradead.org>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-2-ruanjinjie@huawei.com>
 <b8f3b5cd-8d8a-4396-ba0c-011a83234dd9@arm.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <b8f3b5cd-8d8a-4396-ba0c-011a83234dd9@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F330160003
X-Stat-Signature: con76cfonn8wy4z6umb37qje6aiqo66g
X-HE-Tag: 1783305687-306870
X-HE-Meta: U2FsdGVkX1/y8pL6lJwWneOvW9eVhPDUPST75fBLpKWJNpxhaYxKoVPCLg5kVHqMPgRpK3kAO0WyAO1BkPzX+rKkyXDKaqrAAx00pWcWJN/PGr2nFGMYoWxq62U7YCyI/eHbP+vrinUdXnZCH+RycFQd7kV84e+2n4wxGnAR2t5UprTawcRnhG+cZan+qIVZzNqnBMJgnYGm9741utPzepxtl44icnXyAk/Czf83MNUMd/ATcWdLUC+nlS2KfsyAQ039kByD0ouFONPGBFKebRkMc3QXKl2fz4kF/Y7ByFOnsC/znl3PJQZ1mA38x6YhI2BS1sQHL0kmXb9g8cUX6uUG5kEziLQ34soQsVJ2E1owPKB9FbJB/sqDvF2vvGNqJdmesKGpOGc8sd4geD4UVLZmHh5nwdHFCxqMWUAAkHDxKt8rUHqL/VBsNT7zP3ioAagCuN0aVN6EBq9T2rNS/YHaO+lQXgEDGzKTQirLv5E5XP1bTjoHKx4yMjBYWbhn19Agayrt/alOHkgtcUu3xArGgrYjqNsfeFt4KRtbV8Tg4xRgiMKd4LHFDNRqcIxIci7EEX2ZHhxTo+8rUqjagXnpAzzI3lomgoxoCuEzLlUJi4qoV9WCAKhiiAQiirHcDgWLMVrVJNoYHfDn2MLfs3EdkLAqnoUwK1txZNY83xh30UhDZ1mak42hgIVUKXDHtkseHIaTK3XQ+cRDVX3m9gliRGMzAraxHC5WXe1MHXjPuVKre8HrclcB91BOZrjJ9z9XekUUW2l/AA2yFqW8Q54nZVZMdhSg7JGimUViWpRN0U4LrhIGSarIehv2Wn5KG+jUxK+ZzFbFW6Aak8jLBLDmiwWX0Jp4AznosB86MDUnvVat7kQEZr7RTgRTSWqYLlcD5AK2/H1+tn+Z2YHCp4umPsS/OEo3Oisyy1/j/4l4dwl+AmCjtlRJP1yk/Is7L12Yzb+pOSXuhoX6jml
 G9bkGejg
 +pHg8ZZ5rkvxWthEor/va8FzXrO7N+ID2b/ytuNrgobmX84aTpfmKkPU5EwvN+UPgC8ZsLDhzf7Q1/itIVOKLOC0da88IpBFxdLEWAZGrY/IBWHK3rhtlpWPHTv4GttPmA+khkgq4VFAwthzSOmz/ARpS76rMCitciJmUK1OFKaV59OxYhumFNBHN14HFiXLDAijG2kOrwi9GzI1d+dp/XkMMKFHQ+b0DE4nwml1j/uMSU2daCg6G0QapilRRnvK9Kx9LRwbXj2o/XN3ayYWQU2GiUboaT+m+TwzbvscyZXnyav68b7KkmSlvU7maj5mg9sJihbS2p0VZYSDhegny1tFWF9tP0e0MktmBuLePct9lip6w55H08OY0kgaWqP9sztgDIUmfctwROcWF/fxqrdWosPHgFCN0wSJC8Z8jHoZ+rOg1xSsa6luV1cx0FimELzLkMLv44nhAtqgJZTy90LwBW+8rRsA7hUePJJJSH0/L0DkzjMq7Yg1mVnaTFcFK9pN/q9/qF56bVA2AajOieo0N8nz0RxaGjYO6NbcsnUfCTh7JN0xq8/UweT2D8UlyoQZ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/1/2026 12:37 AM, Ada Couprie Diaz wrote:
> Hi Jinjie,
> 
> On 29/06/2026 14:05, Jinjie Ruan wrote:
>> The return value of __secure_computing() currently uses 0 to indicate
>> that a system call should be allowed, and -1 to indicate that it should
>> be blocked/killed. This 0/-1 pattern is non-intuitive for a security
>> check function and makes the control flow at the call sites less
>> readable.
>>
>> Furthermore, any potential future changes to these return values would
>> require a high-risk, error-prone audit of all its users across different
>> architectures.
>>
>> Sanitize this logic by converting the return type of __secure_computing()
>> to a proper boolean, where 'true' explicitly means 'allow' and 'false'
>> means 'fail/deny'.
>>
>> Update all the two dozen or so call sites across the tree to align with
>> this new boolean semantic. No functional changes are intended, as the
>> callers still return -1 to the lower-level assembly entry code upon
>> seccomp denial.
> Would it be relevant to mention that this fixes the unsound return value of
> `syscall_trace_enter()` in generic entry, which motivated the patch
> initially[0] ?

That's a very good point. It's definitely worth mentioning

>> Suggested-by: Thomas Gleixner <tglx@kernel.org>
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>> ---
>>   arch/alpha/kernel/ptrace.c            |  2 +-
>>   arch/arm/kernel/ptrace.c              |  2 +-
>>   arch/arm64/kernel/ptrace.c            |  2 +-
>>   arch/csky/kernel/ptrace.c             |  2 +-
>>   arch/m68k/kernel/ptrace.c             |  2 +-
>>   arch/mips/kernel/ptrace.c             |  2 +-
>>   arch/parisc/kernel/ptrace.c           |  2 +-
>>   arch/sh/kernel/ptrace_32.c            |  2 +-
>>   arch/um/kernel/skas/syscall.c         |  2 +-
>>   arch/x86/entry/vsyscall/vsyscall_64.c |  2 +-
>>   arch/xtensa/kernel/ptrace.c           |  3 +--
>>   include/linux/entry-common.h          |  7 +++---
>>   include/linux/seccomp.h               | 10 ++++----
>>   kernel/seccomp.c                      | 34 +++++++++++++--------------
>>   14 files changed, 36 insertions(+), 38 deletions(-)
> 
> This is missing an update to the Kconfig documentation, a possible
> suggestion :

Will update it.

> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index fa7507ac8e13..9e3d40088afb 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -637,7 +637,7 @@ config HAVE_ARCH_SECCOMP_FILTER
>           - syscall_set_return_value()
>           - SIGSYS siginfo_t support
>           - secure_computing is called from a ptrace_event()-safe context
> -         - secure_computing return value is checked and a return value
> of -1
> +         - secure_computing return value is checked and if false
>             results in the system call being skipped immediately.
>           - seccomp syscall wired up
>           - if !HAVE_SPARSE_SYSCALL_NR, have SECCOMP_ARCH_NATIVE,
> 
>> [...]
>> diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
>> index 416a3352261f..3f66320e46d3 100644
>> --- a/include/linux/entry-common.h
>> +++ b/include/linux/entry-common.h
>> @@ -100,9 +100,8 @@ static __always_inline long
>> syscall_trace_enter(struct pt_regs *regs, unsigned l
>>         /* Do seccomp after ptrace, to catch any tracer changes. */
>>       if (work & SYSCALL_WORK_SECCOMP) {
>> -        ret = __secure_computing();
>> -        if (ret == -1L)
>> -            return ret;
>> +        if (!__secure_computing())
>> +            return -1L;
>>       }
>>         /* Either of the above might have changed the syscall number */
>> @@ -113,7 +112,7 @@ static __always_inline long
>> syscall_trace_enter(struct pt_regs *regs, unsigned l
>>         syscall_enter_audit(regs, syscall);
>>   -    return ret ? : syscall;
>> +    return syscall;
>>   }
>> [...]
> 
> Otherwise this feels like a more appropriate change with regards to
> "safeguarding against new `secure_computing()` return value" !
> 
> With the updated Kconfig :
> Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
> 
> Thanks,
> Ada
> 
> [0]: https://lore.kernel.org/r/20260511092103.1974980-2-
> ruanjinjie@huawei.com
> 
> 


