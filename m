Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C76A606A326
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 08:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=B7jiD3pR
Received: by kanga.kvack.org (Postfix)
	id 2B01F6B05B0; Thu, 26 Nov 2026 03:28:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260FD6B05B1; Thu, 26 Nov 2026 03:28:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1510F6B05B2; Thu, 26 Nov 2026 03:28:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A802C6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 03:28:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4082A160330
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:28:08 +0000 (UTC)
X-FDA: 85476592656.23.537074C
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id EFCB9120005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:28:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=B7jiD3pR;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of nik.borisov@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nik.borisov@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795681686;
	b=NOUT7H96DmZHislCA2HmG03TuH+wY83SLKbF8BDpK8IuaTaEMChnK0hJL5fOBiKI+pBh3x
	ULC4iHXg9m9fFGSrMRVkxGsscM8nh01Z6B5BCXRPgFfHUcMG44VFStceMPHlAZi1jlQ64x
	iZBssKSrPFYGYJVJFM0B8AL0nbz7Uz0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795681686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ziK1uxgT0N4pJKr51qdZ7M3Xl/fHtbiRKWKZVIb+tYU=;
	b=0+Ypm3RU5rzDD/9KWGEEQKF+rCDMpaTYfMFurcQh2c+ZGmQbknZCjWrcjMsqoIa7y2hkOK
	pZ//CcLJe/WUTBq/RhbFMWl8nA4Z5miEdmzZ4EiV3vTC2bB0G65Ey9UrEv9AbpQC6ulWjt
	PB4nYaNm2pyXm8aMvQgPbT+sh59Uvyo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=B7jiD3pR;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of nik.borisov@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nik.borisov@suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso5871548f8f.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795681684; x=1796286484; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ziK1uxgT0N4pJKr51qdZ7M3Xl/fHtbiRKWKZVIb+tYU=;
        b=B7jiD3pRa+lntKS5/ti0UvSHX3+bcP/BPXUoiraSh6Y/Pi2jJAPYEvvbLJOKdWBA57
         1kroEebNvtWPdcUEIwm9TbazyuzHb5FrCg8McLVRQANbbvUGR3yfo2H5QT3P45ty1rUM
         /ZvrnRsGeJUfYdy/8xMFpmg73CscCotXMvATq76C1GMtPDaQ24/oVbxHVedKCncmz2X4
         YqIQNT3jhPqdWMfX0fPgtDMQeV8DkMcMjlIwogOkIEg4MQmQQr8lbtZVg/ojA2UwS75/
         xl3Xa1hebM3CUt7ooa+P1p1lM4MsY1Rz3WP6cyviwkgpfx3tzCkbRtwjQDFr6K0HOM9Z
         c/TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795681684; x=1796286484;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ziK1uxgT0N4pJKr51qdZ7M3Xl/fHtbiRKWKZVIb+tYU=;
        b=tywE3DmBGk9VoTA/P8B42/K8A0xzahQGsiW1UCm8zogK7M9fOFm8c++q6RH4cbI298
         GcPFFPIK38YtwfQMLqpWK8GPMcjyEass9WG3FkYUVybgUo1BBIYx4ljRZeXbErhRVnt4
         j6Rtco4pblEtPWg74LN7NyV913peIL6PjkJwuOytPhKYFqX8afou+Hq8yOKTnET5yAXt
         behMWZoFr7vH2RrGeNwiN+LrNqvJMmbcW1WSMisp5V9p2KXdjY3i3aI95mH2WQLzg4sl
         vLuRBpQ7pRllyehM88geap1yyxFg2NAZWogm137xINpIxz7i9/fZim7shyRe1UoTkIdZ
         4MuA==
X-Forwarded-Encrypted: i=1; AL+hErGPUW2plwm7mfStorSHZl3uM3PxWBlK9VDBYNxpDTIhsQrsH+WRVQI1eoFjlvZt3L3f5vMEAi/1rQ==@kvack.org
X-Gm-Message-State: APuU4Z+iAz+zcTPO9s42dl/xQilr4Uz+5vovv+tm1SVPILdtWC2AgViq
	uD636WIHP1kqZKvKUw3CQBadh9eOTG5/dq3vYqVZCVbqM/erY5bHew3IbQXo4ypqL2Y=
X-Gm-Gg: AZFdTZdnMpoobnwLXVMllDJU7yH76ZoLH/cgeRMXFd6IMGtRE0d4c5RTZvvCmOu341U
	hwBn7bMuQjItTsobdppgH3WQ2FGJa59DZLD6eA55cvqK/rwBEfbZ0ckL1InGFjWfk7NNAmjB0pZ
	XXhTFu49/e+kAwErbJlBs5VuQ7pF2d6IOKydAHeKpYsQAijWJxexm4LAKYjgs5jVOmUdE/+A3qx
	VXMBpgmMF4lCMTkoVKmVxJPbOV/Z3FM8cYUzLFn93ooMVJCBsNO31dTqUrQx5YyO2gUswptjqvD
	+Dw2o6gi4hmF/jwfOveU2g4aP9x/Fcuf81bc1I2OLVXtdqsLIqsvbtmTcRjgCP0hVYIQGf/sHMs
	/DCrBehEGs1LvkpLtgLN0FQXQM1fUD30c+O/JtrHV5riQcZuEvo4UVIRuBP2kA0hg/dod90o39C
	fBaFX8t1HEgvRl/D0zeTzJzjuoU8s3e84MEl0puCwLvC+zWFdOMuNgdg2GHGfUjMCgY3UcHI6Ct
	rFtRNj03BjWpHy5k7fYSY2+2tLyDKVZWBROcypC/c1OKTXbojuhjiEvX+1NvWd8ykEo9yumlsQC
	RHLFmVKRtky7tRFBjFphu5CBx7BSBj6H
X-Received: by 2002:a05:6000:2c13:b0:4aa:874c:a1c7 with SMTP id ffacd0b85a97d-4abb86ed79amr37999532f8f.43.1795681684336;
        Thu, 26 Nov 2026 00:28:04 -0800 (PST)
Received: from [192.168.0.20] ([212.21.133.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6baa3882sm38604004f8f.49.2026.11.26.00.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 00:28:03 -0800 (PST)
Message-ID: <8e8bda1f-dbcc-4f24-bc75-0b68bcc1a40c@suse.com>
Date: Thu, 26 Nov 2026 10:28:02 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH] x86/devmem: Drop /dev/mem access for confidential
 guests
To: x86@kernel.org
Cc: mhocko@suse.com, kas@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Kirill Shutemov <kirill.shutemov@linux.intel.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "Naveen N Rao (AMD)" <naveen@kernel.org>, Pedro Falcato <pfalcato@suse.de>
References: <20261124160025.738362-2-nik.borisov@suse.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20261124160025.738362-2-nik.borisov@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ossqrq7knysztrud7hwjhfoxg1ztb6bq
X-Rspamd-Queue-Id: EFCB9120005
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795681685-386423
X-HE-Meta: U2FsdGVkX19ihZGmXev8yVgkZGYykrmpR3XtbiWKB6EnKWHMPTOl0pyaq8yPJBrmTrDYA1UlGuW4HuuQSNWb6GlJyaR0QX3Y8JG7XfFKrjUy2vPZ2cj8vGp3y1SU1rFt7EEEwQ8obJlSDVYQ9ZbOqsrBihMJcR1SckD/+jNd2D42hkZXZxe4go4CqncgjHHUynnOvyhG931W7dIkfXO6OD4gGpW0rCzlgkWT4Jnz5SAtC8rF5yMHZxcTH9YMTJ6C8xpE0j2Xbr0PJ7G9prQCBM6AjNDursFdwK7Q0sR166Ztyc8gp52K32LFn1qwFECqnrQtaGdPDuxNTz4WXuSwqV7nKEbU2FcJp5mKLXPVA46Xw+yX8jmr8GqOdy9RCDGBBSKdkGikzCMcKWriGxVrdtfGwi9yTz+44JKlXlFqOS1PM2jKqAEF1VLRDoJ1oZToGiGHC/BILGSzsO6wE3MfV2XInH/CwArEWJmFGHD9EUQf9pSyHmlv/gNI16cDM5PT6ISze7FCa1QRMrTH9rtBSxzdtnic2sYOel0TgxSEt/+BGJGJa5ihj/pguUe/fjWC5TMFpk1vJzMWfZ+VNs+KybE+eP0zn4pqf9LjiRuMZL8VITsMrPVKsusJzNzvXN8x+ci/Y3IwvFKBBaAbKMrIZFzjAoM7UOO3T0foO2VsL3k3r0wuWgmZQLkNQc2x7yQShUqPcC+dXwODpFHlGy/tWhxFy4cb4MR0De70cYF0QRYO3OKt/5EX4wKt9REG8Vn9zl7BRiVoI8MByx9QlMnaCWXusqo0+Z+NOAEU58MaR0KSlsFkG3l42Tl0eubGzEFj1OtuW4CMG6hBLrZ+yzxDsfyLJmQ+Lnqvq72JAeCpHh7HfnQovmKBSFsWakej8PbIPsDmxxdeMnvavxQpUI4f34jomzRt5lSrwmTQuKSvF5xYScLDbFH4zYPo31CX0oAN4jueUPKW/SinR+dvWCQ
 oBzp+2pN
 aVZMkUtylbC5ZZgmAmu3xXvhdHgi4NsinIcH2UxtyZiv0DkAghpT2bGWafQ1DidjGON5Gyk2gFQmCDo7HSzpQ7bzP9EtEkRxaEzPmocyUnxeoXSTgjxU2zVvMCAzKjPIM/q3ZXnK32o4sdT9aHWHxE6LZGrTU1FeRSPMnn9RVH+S7gVkeMOfR/VM5qOLRbEbGJIxPdteFboTxrQUyxtMZCz+xlsv5573EsnFSVtXjYYSvTNJZvk4tcNN/9STv2vfP2BpHU5ryTTe/KYrEbLQ1DSXEzL65h9ccSrA4DnVja52q3+EiUu/pv0zWEaP0dfnzxH9wir9vBDpdRSF1AMYkqWN0y7FSon+95HhYP7Ha6bghwq/zKUhzErcu1OpxkR6snbRbW9bacExDQb83J28j0Asy5teLhyJPIHebXhmP6oEQNF3XyI5cXXktnlqthF9aIpcR5Dzqd/ecf0kPoDmoKiWpa6AtHOordn+z7yJIbgVoHc4XKZvWycTPZZZ0m9sGuX3rnUz4WT+iv+hqifeNiUk+Gq/i1EDMBsyRG0L8p/4ieX8AqTBh9LTBeWu/CJPupbDWtgpZH5CPt26Xq1PYlYQtmuePP/4sme12FaEY9OVRhH9qwskm201FFJmEvccfdVYyzjfZvhP0/98pgT1I3Fu90GpMzws0+df0kw58QFlHWBDWaG55UsBUYrBMWHP/8bNsaGrkciH/CqrCyuC5TJXG/fkgUsQD4njAfP603kU1KL+lJbqAiVq3mZAR5KwO+XMErEMqOIvGnPYMhtzcBri4+PNbncBy13uMv80MOT4ShGn9Y1IIqFdVxtJqhrJcJRLiPUJvhtdM2H0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 24.11.26 г. 18:00 ч., Nikolay Borisov wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Nikolay reports that accessing BIOS data (first 1MB of the physical
> address space) via /dev/mem results in a "crash" / terminated VM
> (unhandled SEPT violation). See report [1] for details.
> 
> The cause is ioremap() (via xlate_dev_mem_ptr()) establishes an
> unencrypted mapping where the kernel had established an encrypted
> mapping previously. The CPU enforces mapping consistency with a fault
> upon detecting a mismatch. A similar situation arises with devmem access
> to "unaccepted" confidential memory. In summary, it is fraught to allow
> uncoordinated userspace mapping of confidential memory.
> 
> While there is an existing mitigation to simulate and redirect access to
> the BIOS data area with STRICT_DEVMEM=y, it is insufficient.
> Specifically, STRICT_DEVMEM=y traps read(2) access to the BIOS data
> area, and returns a zeroed buffer.  However, it turns out the kernel
> fails to enforce the same via mmap(2), and a direct mapping is
> established. This is a hole, and unfortunately userspace has learned to
> exploit it [2].
> 
> This means the kernel either needs: a mechanism to ensure consistent
> plus accepted "encrypted" mappings of this /dev/mem mmap() hole, close
> the hole by mapping the zero page in the mmap(2) path, block only BIOS
> data access and let typical STRICT_DEVMEM protect the rest, or disable
> /dev/mem altogether.
> 
> The simplest option for now is arrange for /dev/mem to always behave as
> if lockdown is enabled for confidential guests. Require confidential
> guest userspace to jettison legacy dependencies on /dev/mem similar to
> how other legacy mechanisms are jettisoned for confidential operation.
> Recall that modern methods for BIOS data access are available like
> /sys/firmware/dmi/tables.
> 
> Now, this begs the question what to do with PCI sysfs which allows
> userspace mappings of confidential MMIO with similar mapping consistency
> and acceptance expectations? Here, the existing mitigation of
> IO_STRICT_DEVMEM is likely sufficient. The kernel is expected to use
> request_mem_region() when toggling the state of MMIO. With
> IO_STRICT_DEVMEM that enforces kernel-exclusive access until
> release_mem_region(), i.e. mapping conflicts are prevented.
> 
> Cc: x86@kernel.org
> Cc: Kees Cook <kees@kernel.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Link: https://sources.debian.org/src/libdebian-installer/0.125/src/system/subarch-x86-linux.c/?hl=113#L93 [2]
> Reported-by: Nikolay Borisov <nik.borisov@suse.com>
> Closes: http://lore.kernel.org/20250318113604.297726-1-nik.borisov@suse.com [1]
> Fixes: 9aa6ea69852c ("x86/tdx: Make pages shared in ioremap()")
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>
> Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
> ---
> 
> Resending this with the hope of either getting it accepted or arriving at a consensus
> what exactly is missing so that I can take it from there and eventually get something
> merged. As previously mentioned this results in real problems for confidential
> guests both on TDX as well as SEV-SNP.
> 
>   arch/x86/Kconfig |  4 ++++
>   mm/char-mem.c    | 10 ++++++++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 3159852fd6b3..1490e0019c71 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -901,6 +901,8 @@ config INTEL_TDX_GUEST
>   	depends on X86_X2APIC
>   	depends on EFI_STUB
>   	depends on PARAVIRT
> +	select STRICT_DEVMEM
> +	select IO_STRICT_DEVMEM
>   	select ARCH_HAS_CC_PLATFORM
>   	select X86_MEM_ENCRYPT
>   	select X86_MCE
> @@ -1490,6 +1492,8 @@ config AMD_MEM_ENCRYPT
>   	bool "AMD Secure Memory Encryption (SME) support"
>   	depends on X86_64 && CPU_SUP_AMD
>   	depends on EFI_STUB
> +	select STRICT_DEVMEM
> +	select IO_STRICT_DEVMEM
>   	select DMA_COHERENT_POOL
>   	select ARCH_USE_MEMREMAP_PROT
>   	select INSTRUCTION_DECODER
> diff --git a/mm/char-mem.c b/mm/char-mem.c
> index c5761ddedbd7..5d383befd87d 100644
> --- a/mm/char-mem.c
> +++ b/mm/char-mem.c
> @@ -30,6 +30,7 @@
>   #include <linux/uio.h>
>   #include <linux/uaccess.h>
>   #include <linux/security.h>
> +#include <linux/cc_platform.h>
>   
>   #include "internal.h"
>   
> @@ -609,6 +610,15 @@ static int open_port(struct inode *inode, struct file *filp)
>   	if (rc)
>   		return rc;
>   
> +	/*
> +	 * Enforce encrypted mapping consistency and avoid unaccepted
> +	 * memory conflicts, "lockdown" /dev/mem for confidential
> +	 * guests.
> +	 */
> +	if (IS_ENABLED(CONFIG_STRICT_DEVMEM) &&
> +	    cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
> +		return -EPERM;
> +
>   	if (iminor(inode) != DEVMEM_MINOR)
>   		return 0;
>   

Having taken a 2nd look I think a consensus solution would be if this 
check is moved inside devmem_is_allowed() for x86. That way /dev/mem 
could be opened but reads will simply return -EPERM. That way 
x86-specific checks don't leak into the generic mm code.

> --
> 2.56.0
> 


