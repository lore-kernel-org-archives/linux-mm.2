Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D256CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F37900099; Wed, 13 Aug 2025 10:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5205A900088; Wed, 13 Aug 2025 10:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F65900099; Wed, 13 Aug 2025 10:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 28B1C900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:48:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C21D282B13
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:48:55 +0000 (UTC)
X-FDA: 83772016230.17.7EAF160
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9BC5E180014
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:48:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of ada.coupriediaz@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ada.coupriediaz@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755096534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F7gob46kb//JpRUK0TYl19jc1ebhca+bwFhqnvAij00=;
	b=soclNzimyzl2mBiRbIvgyXjNHewDrN2VaYOTUKr79nmAqbt1y+lmRPdlBo3MtyT47EfaiP
	TQ1zTuHBQl52qzouc4d+LJhDKb9L7MTBGr0Ve7ENR4yBh8I9RvCgK1zp/WZK9KbeM5BeWU
	/AOVxG4p007zByXwgTiTd32bd9zbHzM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755096534; a=rsa-sha256;
	cv=none;
	b=DaR4qNMT0suVCbvACLqYcN1d9nuPeanaGVV3NQh+UWTHfZaw7EENhSyij8P0IbhvanPugd
	xlYtYY/LDR7MgI/qA5Ldc7eklYegcm33PXU2t6ZlRzvSVd7C+kEbqYYNSOUYysOFMNyLrO
	RDiI50Qydb6IGhuJbzJIr5spbXp4YmY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of ada.coupriediaz@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ada.coupriediaz@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4402312FC;
	Wed, 13 Aug 2025 07:48:44 -0700 (PDT)
Received: from [10.57.1.244] (unknown [10.57.1.244])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8166E3F5A1;
	Wed, 13 Aug 2025 07:48:34 -0700 (PDT)
Message-ID: <cae90aa0-9fa6-4066-bbc0-ba391f908fb2@arm.com>
Date: Wed, 13 Aug 2025 15:48:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/18] kasan: sw_tags: Support tag widths less than 8
 bits
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: nathan@kernel.org, arnd@arndb.de, broonie@kernel.org,
 Liam.Howlett@oracle.com, urezki@gmail.com, will@kernel.org,
 kaleshsingh@google.com, rppt@kernel.org, leitao@debian.org, coxu@redhat.com,
 surenb@google.com, akpm@linux-foundation.org, luto@kernel.org,
 jpoimboe@kernel.org, changyuanl@google.com, hpa@zytor.com,
 dvyukov@google.com, kas@kernel.org, corbet@lwn.net,
 vincenzo.frascino@arm.com, smostafa@google.com,
 nick.desaulniers+lkml@gmail.com, morbo@google.com, andreyknvl@gmail.com,
 alexander.shishkin@linux.intel.com, thiago.bauermann@linaro.org,
 catalin.marinas@arm.com, ryabinin.a.a@gmail.com, jan.kiszka@siemens.com,
 jbohac@suse.cz, dan.j.williams@intel.com, joel.granados@kernel.org,
 baohua@kernel.org, kevin.brodsky@arm.com, nicolas.schier@linux.dev,
 pcc@google.com, andriy.shevchenko@linux.intel.com, wei.liu@kernel.org,
 bp@alien8.de, xin@zytor.com, pankaj.gupta@amd.com, vbabka@suse.cz,
 glider@google.com, jgross@suse.com, kees@kernel.org, jhubbard@nvidia.com,
 joey.gouly@arm.com, ardb@kernel.org, thuth@redhat.com,
 pasha.tatashin@soleen.com, kristina.martsenko@arm.com,
 bigeasy@linutronix.de, lorenzo.stoakes@oracle.com, jason.andryuk@amd.com,
 david@redhat.com, graf@amazon.com, wangkefeng.wang@huawei.com,
 ziy@nvidia.com, mark.rutland@arm.com, dave.hansen@linux.intel.com,
 samuel.holland@sifive.com, kbingham@kernel.org, trintaeoitogc@gmail.com,
 scott@os.amperecomputing.com, justinstitt@google.com,
 kuan-ying.lee@canonical.com, maz@kernel.org, tglx@linutronix.de,
 samitolvanen@google.com, mhocko@suse.com, nunodasneves@linux.microsoft.com,
 brgerst@gmail.com, willy@infradead.org, ubizjak@gmail.com,
 peterz@infradead.org, mingo@redhat.com, sohil.mehta@intel.com,
 linux-mm@kvack.org, linux-kbuild@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org, llvm@lists.linux.dev,
 kasan-dev@googlegroups.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ada Couprie Diaz <ada.coupriediaz@arm.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
 <780347f3897ea97e90968de028c9dd02f466204e.1755004923.git.maciej.wieczor-retman@intel.com>
From: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Content-Language: en-US
Organization: Arm Ltd.
In-Reply-To: <780347f3897ea97e90968de028c9dd02f466204e.1755004923.git.maciej.wieczor-retman@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9BC5E180014
X-Stat-Signature: 36rpyo996iqwgf45f88u6xb1z4mhto59
X-Rspam-User: 
X-HE-Tag: 1755096533-44824
X-HE-Meta: U2FsdGVkX1/S4pE+VWZLX84QvQ93QhHIyT39QjEc2KS9Z5jhrIwCt227uJ97LMmMS/JLtwJarkZ5mzoiUumjANBqLq6cloD7wGNbV5E1jVlGFl/Ukuagpv5NgE9iOLs5zcI+DiQpopjnL9K+Mgdy9Fk1zPFTS+GeT8nJ/06nerSE4fQVI9glG6+Z76/9FfZNHii2CB08uzvvd4y7ibUkItDysDhrj3BwKv0sGan0fR0vsk5QOcFmV4E8CPxXKyYB6YqvIV7l/f0epDWj0HUEl46wjmGuPTOFpIApiHpJAm2EFoe7riXWiPoY4AMI0GMn4BmsKRo/IN/SWGnwZWzbKNM3phaPmQ6rJxwt/2ekY7rjC0Ar/0gTMxXMqzh7hQ1y44QvF53NcXawbptm01pdNLBSTXWqSxXMNoDgKVWqiT9Cl0Egiu77pWlv7576LU0N6rGZ1RWXH8h2cxXbcaGWe6GYrcnTi/XVUuLUYwOhLSCloTHN8eUdaCXqXoYG3AYwn70vBdTzf4f0O1O64a21w2xWl38Vz+JxDFgFqG9qV8DzwyqjS5ljrgYCS156rQZMyKcbzGXo7lYUK3/MMrk0GI9tiBw5NbV1E0WMBRcH2Um+ikPb+sgu+wMbHBZhREIPOuOtL4NaoTO0lQLU/4vG0Lu7AM5p/M6coDU0CTOig1SdCWdt45i1MdB+8mSjau+x0dcfRb8k+HhcMsh4PDA4cwDFs0JWcL/qjX3HWCU6/oPJzfzVzXj5Fanc8okhfYkm6d32JYJ8rXvinV/7lLHe3tMIxu8yxgN91nEKS2faZKAekWLaZKU7L4uTRq4UDqgek92MUEzIyfTSJIcbjSJndr3j4e6Ezgxe17HdbSzSSc4SyFrelZwK6zuo9lF7SPVkitwimKtEA1tuish7L+ihyiotkYZRwoAEB66Qz/LR6N7D579Rn4nCXtE0C5nTVru8aQuuELXQM1fHpFHJVua
 opwPg/0G
 N3b0KWc6xJ7mE/UXDgJY/XkHbK05L1fuMxJ9xrIc4Vhe05t7hqIQWAMzg9QKt0pu3zKNXcmFvlUt0d3vxCiKTnIo6YgDO0XUPVAFUkwQLehMVv7rRCcYvLWQViI4dP9SoxzGT8iLdkfVPZwSe/WFUXXF+EBRcuZjeXxiJF4IAOIrqcguKMf6RFD6ly9f24KlXVGultLCQL1lUIuj+aupavadI+78ZOIkBkDOYwY6JLHfGBc2/2mAcc24xHHgJ0ypX7NTs/0d3BJF+Ae73t5qIfyNvzwuG5ODDaFEleaSaw5JlS1oo1C4+nJufibDVHKhIxqxA1DrFMHghpsMqYt9tsFJkZchW4wRYw0xWyEHT/e3Y7BPena6q6LWWiQJNIONXKC7qqSmhT8R3lvwGdB0wJC1SEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 12/08/2025 14:23, Maciej Wieczor-Retman wrote:
> From: Samuel Holland <samuel.holland@sifive.com>
>
> Allow architectures to override KASAN_TAG_KERNEL in asm/kasan.h. This
> is needed on RISC-V, which supports 57-bit virtual addresses and 7-bit
> pointer tags. For consistency, move the arm64 MTE definition of
> KASAN_TAG_MIN to asm/kasan.h, since it is also architecture-dependent;
> RISC-V's equivalent extension is expected to support 7-bit hardware
> memory tags.
>
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
>   arch/arm64/include/asm/kasan.h   |  6 ++++--
>   arch/arm64/include/asm/uaccess.h |  1 +
>   include/linux/kasan-tags.h       | 13 ++++++++-----
>   3 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.h
> index e1b57c13f8a4..4ab419df8b93 100644
> --- a/arch/arm64/include/asm/kasan.h
> +++ b/arch/arm64/include/asm/kasan.h
> @@ -6,8 +6,10 @@
>   
>   #include <linux/linkage.h>
>   #include <asm/memory.h>
> -#include <asm/mte-kasan.h>
> -#include <asm/pgtable-types.h>
> +
> +#ifdef CONFIG_KASAN_HW_TAGS
> +#define KASAN_TAG_MIN			0xF0 /* minimum value for random tags */
> +#endif
Building CONFIG_KASAN_HW_TAGS with -Werror on arm64 fails here
due to a warning about KASAN_TAG_MIN being redefined.

On my side the error got triggered when compiling
arch/arm64/kernel/asm-offsets.c due to the ordering of some includes :
from <asm/processor.h>, <linux/kasan-tags.h> ends up being included
(by <asm/cpufeatures.h> including <asm/sysreg.h>) before <asm/kasan.h>.
(Build trace at the end for reference)

Adding `#undef KASAN_TAG_MIN` before redefining the arch version
allows building CONFIG_KASAN_HW_TAGS on arm64 without
further issues, but I don't know if this is most appropriate fix.Thanks, 
Ada ---

   CC      arch/arm64/kernel/asm-offsets.s
In file included from ./arch/arm64/include/asm/processor.h:42,
                  from ./include/asm-generic/qrwlock.h:18,
                  from ./arch/arm64/include/generated/asm/qrwlock.h:1,
                  from ./arch/arm64/include/asm/spinlock.h:9,
                  from ./include/linux/spinlock.h:95,
                  from ./include/linux/mmzone.h:8,
                  from ./include/linux/gfp.h:7,
                  from ./include/linux/slab.h:16,
                  from ./include/linux/resource_ext.h:11,
                  from ./include/linux/acpi.h:13,
                  from ./include/acpi/apei.h:9,
                  from ./include/acpi/ghes.h:5,
                  from ./include/linux/arm_sdei.h:8,
                  from ./arch/arm64/kernel/asm-offsets.c:10:
./arch/arm64/include/asm/kasan.h:11: error: "KASAN_TAG_MIN" redefined [-Werror]
    11 | #define KASAN_TAG_MIN                   0xF0 /* minimum value for random tags */
       |
In file included from ./arch/arm64/include/asm/sysreg.h:14,
                  from ./arch/arm64/include/asm/cputype.h:250,
                  from ./arch/arm64/include/asm/cache.h:43,
                  from ./include/vdso/cache.h:5,
                  from ./include/linux/cache.h:6,
                  from ./include/linux/slab.h:15:
./include/linux/kasan-tags.h:23: note: this is the location of the previous definition
    23 | #define KASAN_TAG_MIN           0x00 /* minimum value for random tags */
       |


