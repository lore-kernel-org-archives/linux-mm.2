Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D086EC53219
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 23:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FDE66B0096; Sun, 26 Jul 2026 19:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28CD06B0098; Sun, 26 Jul 2026 19:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152E56B0099; Sun, 26 Jul 2026 19:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE8A46B0096
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 19:51:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12ECFA060F
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 23:51:03 +0000 (UTC)
X-FDA: 85032576006.01.955DE9A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf17.hostedemail.com (Postfix) with ESMTP id 224574000A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 23:50:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dx50iURe;
	spf=pass (imf17.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785109861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKrQXmpvjz9SFofb4TcIOuHvF+LZMosLOA8BgOsxruc=;
	b=E+1jqAuFXV6Rh4ICURhyt7fmfmU7x4TJqZKkxQ1YxVd25a2thTgh95/UKN0KpLGRXtYpcK
	wLftGtq34qqhnX/IlkRbQTEUpVo4LabMWk26XXD1zxEyvtl4ZhYXAcYvxOsZUmVvKfaLrN
	fp5uvO3B8q2lfnWsf4BOKtZpOpJjr+s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dx50iURe;
	spf=pass (imf17.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785109861;
	b=gOgMOEbBIrCdvofaudx1Ba9kTNr69kNi8nX/br8zWQVhe2rpV4I+tqA+oUM1H4/3aE+h+y
	7SO5AdxCrt+PASDlNwJwbmlbMTatMPgpz8NEQH+mArWqHFueId3M5qyQRIyScOTfQOiG8c
	Uj/JRCz3E2zL0NZLmBQokYluUVXEl+c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785109860; x=1816645860;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=w3YBSvvfVz5JF33QARLRRJQqjXjDJFyb9uG/iZgc4mc=;
  b=Dx50iURefosGNEGQJr8wK56AztzyXr1F0SBHZUuxtl+ztG3WO9MXnkp7
   efG50NAmlN8IB8c/hmMbHgc+gEuYCMAeWRFyLaDQeUyCBzRAsrEa8/LfI
   cvLqiGKDrLrl2P/5my+uncd2M4/dq8NaNSzZCTXmAgfo3lSW13+uNQjxr
   WU0b88M1l3xTY36QAuPvsaYMrSpqmUso8nkqqEk+C8W1hU1eGZEJmBBWl
   ivl9A8lP3G1lt7k+pobs3SVymZcP5IK2NXDn7cjzdUhqpDgm6AHIB6Lw4
   cMfpE6XZ6vM5PyEyxSZvCOCFAIcWtJyzFrqiYP4uBvejnvBKfWEsSUST0
   Q==;
X-CSE-ConnectionGUID: pMwB5FVfThuCMWBM+jAEYw==
X-CSE-MsgGUID: 8aa7ODilTj6Yg5Nusm7tnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11857"; a="85865821"
X-IronPort-AV: E=Sophos;i="6.25,187,1779174000"; 
   d="scan'208";a="85865821"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2026 16:50:58 -0700
X-CSE-ConnectionGUID: agLzIQEmTc6jL3Ev+0bsew==
X-CSE-MsgGUID: agHlASBAQU66Z+XbiSxRcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,187,1779174000"; 
   d="scan'208";a="282588009"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.238.208.132]) ([10.238.208.132])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2026 16:50:45 -0700
Message-ID: <5692db20-9428-4d88-a358-b90668b930e3@intel.com>
Date: Mon, 27 Jul 2026 07:50:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 17/46] KVM: guest_memfd: Advertise
 KVM_SET_MEMORY_ATTRIBUTES2 ioctl
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com,
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-17-9d2959357853@google.com>
 <584a8f9a-1538-4f8b-b576-75ef0fa961c7@intel.com>
 <akU7uAKb5E_Tklx-@google.com>
 <c0e2df0a-19b2-4234-b0f7-41e010452b06@intel.com>
 <CAEvNRgHmhpP=Re-RzojAp7E3E-TsdoUPhtZ6eSW4bf+5RVbzew@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CAEvNRgHmhpP=Re-RzojAp7E3E-TsdoUPhtZ6eSW4bf+5RVbzew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 224574000A
X-Rspam-User: 
X-Stat-Signature: sswmn8p5aabsjawh6bfkknji37jegxt1
X-Rspamd-Server: rspam04
X-HE-Tag: 1785109859-812891
X-HE-Meta: U2FsdGVkX1+aASenq9cmJ0T4/vF34KSYQCvuDmkRY+X8e0jTS+p1YG3GjeWSSBl1mn2wX+O/bOXteC1eqQ7pda6CauI67/BMnncJQfiINHwI23+7oKIdOv4Nu3hBCvcbchJDEqznNzU1u86fMqSyf7DezKFPG456k/nbesYCedidFjgfsFSG7l2K+q/b9cKohJ9FsvfEGxh/1A/s1Sm3yZWRgBK667btffL5zsRV1A0U0f7Wnpaf2nlVuTvhKrBFcecTHFAte762oYK7kvCYMaOrhG3DV/0llDF85eUGmCBUuHe1HOxRebN12Cr+nIFC2X9tKcI0Aci6noiKG50j5pgvQeAIdbhnLF3kKf4vE2vRiaU2d4Lwi3abAcaWuVujzkvVj7lj55RcRWUMvHdQtdADB1C35Dx3JGE8PaZ3hkcj+j2J26S2jjd49Qnx1RVsRXtlegGxQXQW7L4qEBHYkvlUTkier/rdbQFGz6ytPcg64InLMhib2F+kXnj/h8dLel4pSGin6CXJ1UtVPDDt6e9tTFmzuDeg+fjagBP9EvXQ0gzevr9NY/SD28uLj9dM14A+p17f7+LVJKFy+4v+2ZNtaBZ83XHXvHDoOlVGI03eyBxRU7sqEy3iDMNs7uBm0HHJitxhNa/cgt7qXSa/yGvzlZabM9lTvmegX7Y+oXbFJ7KOIVoE73O7c8WzCFUvw6Wh/JkouoaDnrZIXBSqo9gEuuqw6MPMExs/IzjGFtGiwp5ayo5MhuoccD0/HDaP6BqMj4ZluLWHRR1Fv3kM5riQtx3gDt8e2kpyXDcsd7pn/fR29CythDqK6/gDvE0S7NjYIK1g8G3ZPI+G16hJAeHBgnixznoKWfp60odruTbAYplSEVxrlJU1rd0sho7YyAciBz4wnvYRf0nES+ZuWvni7y7Zq/kZYFZ8CkHswASux4v0FfvVsWJRZOE+ZZqL3gPUes1AKfvBnzjn+bN
 4w2o7R+8
 0AZvsHLXE/MkUkPTeZ3d/5JRBdvH27vVJ2MlingI7GA6lQEql/ck2WxGyX8LJXxEOI50HCg++7+FDowKn/TSDMFmottpbHBBHaqYaMhNccrSKaThgnWxyAyhpdBtO1PcBN3YdqRXfBvorDjoJVIQ8c6APjOX2fVOtgq4bY4k5uF9seXlkreuDEXbzbo+MTrC0yThfZg3Fl3xHieyVtuAB1AGXceDsTcqPCuRd05wDmaWt7Sx+WbXjdKKIEy7M3d1gCJAPd/OmUXairREallkVaMO6Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/2026 4:26 AM, Ackerley Tng wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 7/2/2026 12:09 AM, Sean Christopherson wrote:
>>> On Wed, Jul 01, 2026, Xiaoyao Li wrote:
>>>> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
>>>>> @@ -4969,6 +4973,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>>>>>     		return 1;
>>>>>     	case KVM_CAP_GUEST_MEMFD_FLAGS:
>>>>>     		return kvm_gmem_get_supported_flags(kvm);
>>>>> +	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
>>>>> +		if (!gmem_in_place_conversion || !kvm_supports_private_mem(kvm))
>>>>> +			return 0;
>>>>> +
>>>>> +		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
>>>>>     #endif
>>>>>     	default:
>>>>>     		break;
>>>>
>>>> this looks inconsistent with the
>>>>
>>>> 	case KVM_SET_MEMORY_ATTRIBUTES2:
>>>> 		if (!gmem_in_place_conversion)
>>>> 			return -ENOTTY;
>>>>
>>>> Well, the check of
>>>>
>>>> 	if (!kvm_arch_has_private_mem(f->kvm))
>>>> 		return -EINVAL;
>>>>
>>>> is buried in the following kvm_gmem_set_attributes(). How about moving of
>>>> kvm_arch_has_private_mem() check to put it along with
>>>> gmem_in_place_conversion check in kvm_gmem_ioctl() in Patch 13?
>>>
>>> Me confused, patch 13 already adds the kvm_arch_has_private_mem() in
>>> kvm_gmem_set_attributes().
>>
>> I wanted to make the check in KVM_SET_MEMORY_ATTRIBUTES2 in Patch 13
>> like something below:
>>
>> 	case KVM_SET_MEMORY_ATTRIBUTES2:
>> 		if (!gmem_in_place_conversion || !kvm_arch_has_private_mem(f->kvm))
>> 		return -EXXX;
>>
>> and finally, with the introduction of kvm_supports_private_mem() in this
>> patch, it becomes:
>>
>> 	case KVM_SET_MEMORY_ATTRIBUTES2:
>> 		if (!gmem_in_place_conversion || !kvm_supports_private_mem(f->kvm))
>> 		return -EXXX;
>>
> 
> Is the request here to make KVM_SET_MEMORY_ATTRIBUTES2 return -ENOTTY
> instead of -EINVAL? kvm_gmem_set_attributes() also checks for
> !kvm_arch_has_private_mem() and returns -EINVAL.

Not really.

I want both "KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES" and 
"KVM_SET_MEMORY_ATTRIBUTES2 on gmem" to check gmem_in_place_conversion 
and kvm_supports_private_mem() in the same if(), or side by side if two 
different return code is desired.

Because the current code somewhat confused me on why 
KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES checks two conditions while 
KVM_SET_MEMORY_ATTRIBUTES2 on gmem only checks gmem_in_place_conversion. 
Only later did I realize that KVM_SET_MEMORY_ATTRIBUTES2 on gmem also 
checks kvm_supports_private_mem(), but buried in the following handling.

> I'm about to post v9, which squashes the patches as Sean
> suggested. Please review v9 instead to see if this concern is already
> addressed :)

sure.


