Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E36CD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173716B0088; Fri,  5 Jun 2026 05:07:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A506B008A; Fri,  5 Jun 2026 05:07:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060906B008C; Fri,  5 Jun 2026 05:07:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBB6C6B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:07:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84D74120B70
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:07:14 +0000 (UTC)
X-FDA: 84845279988.16.54C6567
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 91C7B4000E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:07:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gjxPbq2p;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780650432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnVWfAMxq6xUxR7+SuxEhlDr90WMH6wyWQJMLtR/xG4=;
	b=rhl+e5xKRYC4vky6IBJ1kAkt9oe5QWX9khTsidpXoASW3Gy/XwBlMsr/2MznMyxwaqN6qY
	K0Lcd12OZrEVRlMTY+xI+oFu4gUtVDz6ZMWynUI2Ep4xMplh2BOjrSWLvN/cEzUhzW/B6e
	SsMjfKkEtmUSo7N0p9KbQIVhB88LTb4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gjxPbq2p;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780650432;
	b=wijr7JYNs5PEF81CKHX6lKVj2Pk52rPmeu5lyU41PzD9TyxSDQsxQJOtHLAqSFt/BOo/xy
	BNPrjY9xoyoULa/BVk+16iIy8qd6fNzqBHpEc8KJVweG6aCRlGS5yTzHV4/xJePxQnU03b
	4CI0qN+i2aNoNuY1ax+BvLMYWBrsvnU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99EFD4CE7;
	Fri,  5 Jun 2026 02:07:06 -0700 (PDT)
Received: from [10.57.92.75] (unknown [10.57.92.75])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 891843F86F;
	Fri,  5 Jun 2026 02:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780650431; bh=UXE7DC5dr6M+k24qAaywn7yvVqkTrb7vSLr7g8HR+1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gjxPbq2pHkOfACoMFtOdYFETh8vR9siYUcniNUVttHwVYajSgtBX2fT7r8/6nEQVU
	 3U+mruFBjhkJwoh7yfUyp4HzYXblvxOs58WoMrl+NRHN430tFwRzHI5G6iytvzgqmP
	 jhilsf5wSLNEWJnWJVKRp1qhWyGeYwpuFX4LwbOQ=
Message-ID: <85b8c177-b566-4e26-884c-9122e2455316@arm.com>
Date: Fri, 5 Jun 2026 10:06:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 20/42] KVM: SEV: Make 'uaddr' parameter optional for
 KVM_SEV_SNP_LAUNCH_UPDATE
Content-Language: en-GB
To: Michael Roth <michael.roth@amd.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, ira.weiny@intel.com, jmattson@google.com,
 jthoughton@google.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-20-2f0fae496530@google.com>
 <9d15479e-e36b-4865-804c-7d93eb339e4e@arm.com>
 <4muegrza5iyyhqx6wevdlssnb6wvlc4m4wmuz5hmd3xikkftc4@3e2lpuq6tjgr>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <4muegrza5iyyhqx6wevdlssnb6wvlc4m4wmuz5hmd3xikkftc4@3e2lpuq6tjgr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 91C7B4000E
X-Rspam-User: 
X-Stat-Signature: n6rdoogfaub758uf6xs4wg58dz58kyex
X-Rspamd-Server: rspam09
X-HE-Tag: 1780650432-154695
X-HE-Meta: U2FsdGVkX1+xOUtzDT1odaLH3cVHC/ptIfW6wTmKQpEdNsumpEbtQUz/cPkDQkrLu8y6SaAQzBUiE1v+3q0K5P1C9LARQoP7IB1jCSDoXEnjguWiQbS9o4x6+VC2fTnXuZX9CihSonxMM1WetXaxYA+YrSAkbfWAjmFXlwxIVMYykrzvM2fxaqM76hYmdicOpj3aho39NbGuJzpHIE3dIUvhk7PQziRz64ESSbwuMPY+A/O27tIlw9IoIuwrt5z+HLx50hlXdwm08SBWxm947GdCwK6UvuWxCMoEMPc6IY/Kjr9gz84pt/skd9HUkQjf4RC4tPpRZEircf71rAT1sOLckbaqNWjYLI5Lz9uoI65VR5hHuGwTL1Oxrv2IarxHjz0FtqX5kwrQeH23eIWViHc9QQSWVgrOhOxvkMcN++pal/LSBfgZEmPL8b2SQmttQCkMKcIBnFUj4fI2w7m3nN5femqrS/umcjR2hwi0oVYoJipNIpLviJCluK6wMRKGc6i4K7gOcP6jJsxB+NMKSkB0+3/EVe3j6ninLXd5F50u6X1KWTWWegpKqI00TpAUHN9nuakqVfn3b0z0uUlxc7nJkoZj09i5e9eXih4PN4R+4NCNWwc2tevGhXDOo+xjVFq/9KqcknYc5RU4FNJsv/Tn6rYR+ZsqTa6MWkaryJreGYwePPUQQo9wDdhhBZSyceUltir2thX2amZq6vTmQ9Nop/mVdLK6+idB0Z1qRDcyWP5utOSRGERokZxQJEcEO5UZRbpgIpKhIzPxrOgrmEp2ebEOx2q33F7DQWETHEaIax+QJAX2tGLS0VStl4vnRc7XcMaRRekvIA/zQS34tkKQ9ojRFqSHzIWPF52FNQmD4SgjtA0+nC6Mq6pptMteJ9DrbPD1GAtsVc/dChH/xt8k1CihXvG0Jlbq1dO+ptR6jMHWa6vkJNnpYB1Jl811YFzvpJdzaweNAjQdjjW
 WRnaJdxy
 HLcsUccKZ1jl3ihRYSDa0SOUQFYKo4cj3VQ3G2LQ+hPjek/LDnMvFC0l1ssFjKuIGuenFy9/edzmtcDFz/S5KtAih0lpK+EvkyiDK/qkFp/w8X+7JzQ2In2HfW5oYwJfg6x7z8gPlCgDrqIspdmkRiFQXnUgZ/kowjDzFjmak4ADXEJVXCbs+6QQKa7wb78FPzagVT/Xyx7JhLdG+sovcFg9cZR2T4qJzP883pG4L4atsl30tc5eKmx23TrixqrZT4mdmmmze0nnvNWvicwBjeN8jFssBq1T654d1Wye74yHeLjqwSXLtAgEtryODBI4WGAQkyHyA2CcW6s4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/06/2026 21:11, Michael Roth wrote:
> On Thu, Jun 04, 2026 at 04:29:19PM +0100, Suzuki K Poulose wrote:
>> On 23/05/2026 01:18, Ackerley Tng via B4 Relay wrote:
>>> From: Michael Roth <michael.roth@amd.com>
>>>
>>> For vm_memory_attributes=1, in-place conversion/population is not
>>> supported, so the initial contents necessarily must need to come
>>> from a separate src address, which is enforced by the current
>>> implementation. However, for vm_memory_attributes=0, it is possible for
>>> guest memory to be initialized directly from userspace by mmap()'ing the
>>> guest_memfd and writing to it while the corresponding GPA ranges are in
>>> a 'shared' state before converting them to the 'private' state expected
>>> by KVM_SEV_SNP_LAUNCH_UPDATE.
>>>
>>> Update the handling/documentation for KVM_SEV_SNP_LAUNCH_UPDATE to allow
>>> for 'uaddr' to be set to NULL when vm_memory_attributes=0, which
>>> SNP_LAUNCH_UPDATE will then use to determine when it should/shouldn't
>>> copy in data from a separate memory location. Continue to enforce
>>> non-NULL for the original vm_memory_attributes=1 case.
>>>
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>> [Added src_page check in error handling path when the firmware command fails]
>>> [Dropped ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES]
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>
>>
>>
>>
>>> ---
>>>    Documentation/virt/kvm/x86/amd-memory-encryption.rst | 15 +++++++++++----
>>>    arch/x86/kvm/svm/sev.c                               | 18 +++++++++++++-----
>>>    virt/kvm/kvm_main.c                                  |  1 +
>>>    3 files changed, 25 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>>> index b2395dd4769de..43085f65b2d85 100644
>>> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>>> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>>> @@ -503,7 +503,8 @@ secrets.
>>>    It is required that the GPA ranges initialized by this command have had the
>>>    KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentation
>>> -for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
>>> +for KVM_SET_MEMORY_ATTRIBUTES/KVM_SET_MEMORY_ATTRIBUTES2 for more details on
>>> +this aspect.
>>>    Upon success, this command is not guaranteed to have processed the entire
>>>    range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
>>> @@ -511,9 +512,15 @@ range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
>>>    remaining range that has yet to be processed. The caller should continue
>>>    calling this command until those fields indicate the entire range has been
>>>    processed, e.g. ``len`` is 0, ``gfn_start`` is equal to the last GFN in the
>>> -range plus 1, and ``uaddr`` is the last byte of the userspace-provided source
>>> -buffer address plus 1. In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO,
>>> -``uaddr`` will be ignored completely.
>>> +range plus 1, and ``uaddr`` (if specified) is the last byte of the
>>> +userspace-provided source buffer address plus 1.
>>> +
>>> +In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO, ``uaddr`` will be
>>> +ignored completely. Otherwise, ``uaddr`` is required if
>>> +kvm.vm_memory_attributes=1 and optional if kvm.vm_memory_attributes=0, since
>>> +in the latter case guest memory can be initialized directly from userspace
>>> +prior to converting it to private and passing the GPA range on to this
>>> +interface.
>>
>> Just to confirm, so the sev_gmem_prepare doesn't destroy the contents in the
>> process of making it "private" ? i.e., the contents of a SNP shared
>> page are preserved while transitioning to "SNP Private" (via RMP
>> update).
> 
> sev_gmem_prepare() does sort of destroy contents since it finalizes the
> shared->private conversion which puts the page in an unusable state
> until the guest 'accepts' it as private memory and re-initializes the
> contents.
> 
> But that's run-time, when the guest is doing conversions. The
> documentation here is relating to initialization time when we are
> setting up the initial pre-encrypted/pre-measured guest memory image,
> via SNP_LAUNCH_UPDATE. That path calls into kvm_gmem_populate(), and it
> is then sev_gmem_post_populate() callback that actually finalizes the
> shared->private conversion. The sev_gmem_prepare() hook doesn't get used
> in this flow (kvm_gmem_populate() calls __kvm_gmem_get_pfn() which skips
> preparation).

Thanks, thats the bit I was missing. Skipping the prepare path, with 
__kvm_gmem_get_pfn(). I was under the assumption that 
kvm_arch_gmem_prepare() was called for all PFNs allocated from gmem
and how SNP was handling this populate case.


Thanks
Suzuki


> 
> -Mike
> 
>>
>> Suzuki
>>
>>

