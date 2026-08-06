Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DDEDC55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2246B00B6; Wed,  5 Aug 2026 21:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9656B00B9; Wed,  5 Aug 2026 21:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D06B6B00BB; Wed,  5 Aug 2026 21:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3F226B00B6
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:41:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDB7D1C1060
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:41:20 +0000 (UTC)
X-FDA: 85069141920.26.CE345C7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id 396CD14000F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:41:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D5j5Aeba;
	spf=pass (imf23.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785980479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDuCm2CEySCnP1TC7W9rO26YBr5si2qv0RsEeXaZK9w=;
	b=5DMvCuiD9lSk2F3rGBbsrmxLnpASDNutKNsV/fjrUkUgmc5iGNNKUeS23xf8ewkZqrBw2F
	5aZMspsvXkCCg/WlnlnLI3BgTauB9fKpkRPYpK+0OjC9B7KbC2Am5h7/LodmlMHDotg2LV
	bKmJLvUYmuX2SJ87j+L1EkqbjQS2wNw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785980479;
	b=bRDnGmtP2MNoLY/aYqhoJMLCfapaYTPs8Uvzg0d0nQ9rEnQ9C2/1ObiUSO6QCcA0h53tlf
	NqtGXLUHc36Eiw6e9UxkkwWLarlK0tan8rb169czqUn3wC9ulQr6h6PIXlJoekZRXWO3da
	UlrgCYBtSddQYrDh40TUkI9/0L491/E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D5j5Aeba;
	spf=pass (imf23.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785980478; x=1817516478;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZnLZ/DOQZzlu7P9MJedwhIePtxgeG0zn9ITPXcqWNF8=;
  b=D5j5Aebag8HKlmRcdiBQ5r8Efr0ofB4iJk8x3Dd2nYQAaN3uOJloA2hr
   iiHS5/Y8Kv/hObg2iX6Y/731w6L5EjZoLxpc2jeoHNL0AFf5hEy6ArsCZ
   tutsbF91giKg/2uH0KSG/RNEj7/DwmLVjD/ksvzWj9NKLUC9vbghFu64B
   3VYrNBbwX/7cpTA9n2SLYq99/eVcqew06iVuesp2HVPMhRHi1Clt5n5QS
   vbkLtTEPPZZRoTvwpM8MNdHoNoT/LS0cfzVeOMLHq5xZavucq5ggvxebF
   KRGOFlxfm4S5ItsdUdaeeQFE+Cdc7v3skEDw5bn0z0TtR56nn1SWg0Y48
   g==;
X-CSE-ConnectionGUID: sWJ4VUm4S4eqy+Glz5JkTQ==
X-CSE-MsgGUID: nLmW+nz/SHOeph227Z/yqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="85691173"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="85691173"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 18:41:16 -0700
X-CSE-ConnectionGUID: 5oIPZ2NyTCqHZV8yl6Tp9w==
X-CSE-MsgGUID: x7bSvlzdSNGXBVIWi4OGbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="260186253"
Received: from fuxiaogu-mobl1.ccr.corp.intel.com (HELO [10.238.208.47]) ([10.238.208.47])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 18:41:01 -0700
Message-ID: <fda26964-721d-4a8c-9225-46ca3a5b2785@intel.com>
Date: Thu, 6 Aug 2026 09:40:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/41] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-3-35f9aec2aed2@google.com>
 <7dafaa90-f3d4-4be4-a5cc-472163f18040@intel.com>
 <CAEvNRgG3qXrG2ix2MEcyVo0GXaen-Pte4gFAwEN+9AY=VtGU5w@mail.gmail.com>
 <b9ad1a1d-c167-4adb-980b-90096515a363@intel.com>
 <anPYxp-LMWaLDbMk@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <anPYxp-LMWaLDbMk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 396CD14000F
X-Stat-Signature: x7i5gcnz8udikbctarkjr1hjeukqs3ss
X-HE-Tag: 1785980477-551685
X-HE-Meta: U2FsdGVkX181T4NAXLygCSnttKCxdgBtXItFh1zNkYZ47L+rUZNnQ8bZFb/OQFQSvNQGrlDNK5u5uXmQvNLvu3phCiYILDZ4RMh4K09aGpBMuzLDyVp4X3NF4qZU1RUQfg7h7siNoiImflwb1ZCjlEPbP/KMhMsluhd0k8zphnsDNArjuWizDncGI2n2rBHTA7qsyDGqDHS8zvuT1zuMuQ9v5EOK85v888vBgJVzE/55xWwUn69V5DESrio72e7Jog8dpJi+LoWq62GW68mArrZWHAfwkgy007IkYBAX1N0KXhtfCWVLVSc71utpgXK4XmMzvJnVdsJu8e3SL0i6BbxGT9gFlHrFynNhqPT+/z5LgVCvGs5qXlGMlqJs33Kp1QsRocuXSMe9ZLEICbQaDXWPtGl8ueuuHggxj4oDvReogRdl83yQR3kfGcnkBMQ9pvWHdH6Ki2RsFEx+POnp2VE41M+8Yzqu09KKlV+HP0q0YKOE31lMUrPuZB4cSfk9vYsVHP+FizNkswsFWMHqxLyUH9ZaOV+MH9Vixw7tUdJzd4+p4AC8bvhAkmHzLPWxyeo3GVKboRXU9C2EULo5EYhzeWl3j7Eh9GOuCxUcGrvPSjpDB5ztY7O2liw2qAjaZQmnozwP90Wg9TbnbRUiocs7vRA1/akBB7xvr18P//HrV+wUMS+iFL4sMt4blAC9jc6N8vMUoDiQc6801o81X0cwUYJGzwh15x/oPcqedID4KcZLhcfVlevzEG7+ezRPjGAkzNpmlaVY2SlXC4lD5LdYgZxBX9mW/v11tlI8P5BlHyNRmVU3+9CKmRouTYzYt6tnGGoLtslxG3h8I7KcW7gWdVoadcfxH3cGlmg8Yh+gdDV1ljlGvMSvS7cpp83eD8wvehHju7ISFv8eZ5qvj0ZnAi+fHhbbjcNYsZTZGZ89RXqDXosqDvvSMkutgEL3WYLRj+3iGP7gIIX0+iB
 8KVY3jKg
 xsioXw+NR6tC8Bm7t9U3cS4RLJKGb0jnMuiLf0f9wTD8AhLJy16qwr6F389Ys3/7N0wRluQk3g3rdQTTQkeFMeUn3RVtW6Zuic4jCpnL6pJssZzNjOf2QNwjTRxtoMWZxofyAmznS+D1cXJrFBJExhfur2izDaRyvNQclCAykNvO5tBUDKLZEH9GpJcrA639uyuIC0dKcMsyDuNJgX4+63uRRunKDKp8mkxvfjq8soYO4S9kotP8YEEr9K7DL01A/QAjr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/2026 8:43 AM, Sean Christopherson wrote:
> On Wed, Aug 05, 2026, Xiaoyao Li wrote:
>> On 7/31/2026 4:34 AM, Ackerley Tng wrote:
>>> I think another way to phrase this is that if we don't make this change,
>>> say, on the foo architecture where there's no CoCo and no private mem
>>> support, kvm_supported_mem_attributes() would return true for the !kvm
>>> case, which is over-reporting.
>>
>> Under the condition that the foo architecture enables
>> CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
>>
>>> How about this, replacing the entire changelog paragraph above:
>>>
>>>     Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE
>>>     based on kvm_arch_has_private_mem being #defined. This improves
>>>     reporting accuracy by not reporting support for
>>>     KVM_MEMORY_ATTRIBUTE_PRIVATE when kvm_supported_mem_attributes() is
>>>     called with kvm == NULL.
>>
>> It doesn't help for the case where kvm == NULL, but help for the case where
>> CONFIG_KVM_VM_MEMORY_ATTRIBUTES is defined but kvm_arch_has_private_mem not.
>>
>> sorry for being picky. I think we can say
>>
>> This improves the reporting accuracy by avoiding the case where
>> KVM_MEMORY_ATTRIBUTE_PRIVATE is reported when kvm == null even without
>> kvm_arch_has_private_mem being #defined.
> 
> How about this?
> 
> Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
> on kvm_arch_has_private_mem being #defined in anticipation of tracking
> PRIVATE vs. SHARED state per-guest_memfd, not per-VM (to allow in-place
> conversion).

Sorry, maybe I'm stupid. I still don't understand how to connect it to 
tracking PRIVATE vs. SHARED state per-guest_memfd.

There are two diffs in this patch, and we are talking about the second 
diff, right?

If the kvm_supported_mem_attributes() will be used by gmem, I can buy 
the justification. But it won't. At least, it won't after this series.

> guest_memfd support for memory attributes is expected to be unconditional
> to avoid yet more macros (all architectures that support guest_memfd are
> expected to use per-gmem attributes at some point), at which point
> enumerating support KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory
> attributes being supported by KVM at-large would result in a system-scope

s/memory attributes/CONFIG_KVM_VM_MEMORY_ATTRIBUTES/ ?

> check (NULL @kvm) over-reporting support on arm64.

I think arm64 won't define CONFIG_KVM_VM_MEMORY_ATTRIBUTES? So it seems 
to have nothing to do with arm64.

It matters for x86. After patch 20, CONFIG_KVM_VM_MEMORY_ATTRIBUTES is 
user-configurable. At that time, people can disable 
CONFIG_KVM_SW_PROTECTED_VM, CONFIG_KVM_INTEL_TDX and CONFIG_KVM_AMD_SEV, 
but enable CONFIG_KVM_VM_MEMORY_ATTRIBUTES on x86. In this case, 
kvm_supported_mem_attributes() reports KVM_MEMORY_ATTRIBUTE_PRIVATE for 
system-scope query which is totally wrong. I think this is the case we 
want to prevent not something won't happen for arm64?

>>
>>>     Give architectures full control over overriding the default definition
>>>     of kvm_arch_has_private_mem() by removing the coupling with
>>>     CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
>>>
>>>     In a later patch, kvm_arch_has_private_mem() will be defined based on
>>>     whether architectural features are compiled in, and made orthogonal to
>>>     CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
>>


