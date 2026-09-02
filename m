Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCB09C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2ABD6B0088; Wed,  2 Sep 2026 01:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3BF6B0092; Wed,  2 Sep 2026 01:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3036B00A0; Wed,  2 Sep 2026 01:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 958C96B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:56:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E84B416068E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:56:26 +0000 (UTC)
X-FDA: 85167762372.02.7A814A5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1A9DE140008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:56:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CEZKfKVm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Ehg0Oa1BsM5PVDw89WgrapJAC/tq5B8u6R10Skrhj4=;
	b=GLcwGAmmeygPQaR0XRTvhgW4/0TOpSypJYYP4NGTv53b0ZMPEXl0hH26S3bqKZtd3EB5s6
	nbPwyBJuih/g+yOkmPd8O3QTOGHMsYO0361nH/htV8kcv2W9qxi98TKu2qTzr9rMvE8DSM
	rm1MMDOWvXprPwuLmqCcv1MxHV8oebA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328584;
	b=ikD28WpCbgQHyh3aXv1NrG4q7AGECuCXmP0Jz5T4YG8n1xquHahnJKlWk+JYH+TCu7n1LO
	2lPEtpPj+z/kiPyua/8/0lXSoUKy8fWV5S2TYb7equhdLNrFsSaLX6lffWn/vBGweYDVeZ
	zyy68pq2J7lFKF1QtGoiB6rbVb2Ui7E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CEZKfKVm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788328583; x=1819864583;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NAYW1On/VkYGYqw0erKARmYKHyJS6na03C92eWmMvkY=;
  b=CEZKfKVmp5UAjoESIKX4lp2dvMw/w4WVaOE5ILkhjWaGqj7V4d/i0S0n
   s0fSmd6I33QyKu11S/utqE2gPUyVZFT9c/RxgJi032Of5gWFMb/lIU4kL
   EVNbqzGLSo+t8dvzKssmHED+J0yToZwIQDz2cQlJwcpMK8XJ297FbT7Mt
   V1VHCJKC4PVPfPaOa9PTRdeJYsnom81B8r1YP8wvjg4oI+DgnqsWwFDSM
   a6S6LndTHkjFIwt9fokepKLXFeMmVNvIfBnujQvYNdsUTZd/19TbL4F+p
   +7J+TgVFX5IUMqCLWY3AdoM5EejlIJIvFdBr2ZMHvWVKO+AZ5WNhpVEwg
   g==;
X-CSE-ConnectionGUID: GBgOIUDeR5iYV7Q9G6K3HQ==
X-CSE-MsgGUID: am2E//U2QSW/BdoCGDlH6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="91286634"
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="91286634"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 22:56:21 -0700
X-CSE-ConnectionGUID: TKdU4rLOTfitm42CraiH0Q==
X-CSE-MsgGUID: F4dTuqYWTCK6sK9qyDwvcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="294139596"
Received: from unknown (HELO [10.238.2.33]) ([10.238.2.33])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 22:56:08 -0700
Message-ID: <33431813-fc94-48fb-9042-5cfc68af05b8@linux.intel.com>
Date: Wed, 2 Sep 2026 13:56:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 23/45] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, willy@infradead.org, wyihan@google.com,
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-23-85e5fd25252a@google.com>
 <CA+EHjTzALzghuG5J-LFuG5pXJ4WgEfrMHgwkMHnq1U-D6yS7Pg@mail.gmail.com>
 <apcY5b2o5k04XffH@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <apcY5b2o5k04XffH@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A9DE140008
X-Stat-Signature: igk54xpna4cixhmdd5176zw73hpqfwap
X-Rspam-User: 
X-HE-Tag: 1788328583-822329
X-HE-Meta: U2FsdGVkX1/ffApYgLNBkua9HMv8bSDgvqyrqye7kyR6aFItO45JW+Wa0Ku+6LYPELDP9HYz1YVGxBKhr3UBQatqI3KEa+kzu4vRaSjcbp1ZZyqg9D/uVs60WFN6JmiA3OPWAYhoyDBubG/s/e/ojqEnvGvpKXYHJrUTFxtU7sxdAHfspLEmrkcbHomwhrf02YEAMUvs+GyGewfxW+v7j3UGdtCedsqZ9ym5YTWjOjUX43zPHV90+qq5tW+GI1d4gkkD5TGbo2VbHnaQ8kovwpLUHz8RWaDW1Suc1C/5PqtQARE4F/ZVfy7rJPWx+4sT2TDu9yQgJPggMVxWhTKFaUJNIvP4Ioug22iCJk8CtF/+ccxuWBwUqocAVJxMC5ePEIq05F8CZM/OajuQbNGWhsw7y/kYfE1BXac2gNJKyv+XFi5lIDi1/Hee6a7nnr4PKAwhUsxoWR3vgyaQN8zDv61Hih1gyHS56fLDTKPcfmRjCXiVUfgFv//GxPgVVg3bqBpPzb1KvYivd0d8GlphhZnPF81pGzo7eLLk5uVrcQiwmwSQzM4kt5ZykNT6zVaWauMUZgDkEHasDXr5YAJPM0USfbeqTzeWtRHYFeXeI9it5nzZeicH6ZKWI+vL+5KGFigGrztNYDyZN9FMJrPOioO1JlwH5isvLym2EceORP6IODRRkjB6G3jO6MfzYuFyE7tAPJ1rBQueUZ3pbGhsr70RzahHhksgNiGON3JLA9PSQf4/0Q2CtkQtnnODHEH50JTJXPbJj9UtELBo/TpM7iakpKpIsaE1c6EJS37y5uMQ9wx5o2VlU4EkzExiiLf+OIRT8HEK90Fr9uJI//e4AV2TZUqA1Ljkqz1WQ2+zG6RUBmAsPRPOC4da11K45QVDxnP/tQVzYNRdkzZRw6a42JuH9cV8tQeQ3gjsn3MTbxH0Y/WQ/DMyS+6K9zkmnzXxRkaNQREghHWRevszGwI
 0UHkRw32
 38L45GNGmIsHUW/yyzUqnu7KN+25imYGD6covp7uMhHeN36wWs4Z8wimwDH4Ua1XNCXL/32dNgsjNcsS2LvXpEV/xOBCJ9GePQ4Y6H9zFcoYrsF7yXWLUOVKJVm2sEBb88x+EsPtqBBtSHBamFc5GnWepAO/p8XhDc88ylMz3n2IZlun8faVk4H4Q57QGpbIl0O5eXxhXu2zgOQYK84CTps7dHgso0KNN89ZuwIEQwduNU93tBQJaAbqFKl6TNvREDcV0LjO6XDj2lpg9FbMcNdzn2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/2026 2:26 AM, Sean Christopherson wrote:
> On Tue, Sep 01, 2026, Fuad Tabba wrote:
>> Hi Sean, Ackerley,
>>
>> On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
>> <devnull+ackerleytng.google.com@kernel.org> wrote:
>> ...
>>> +       kvm.gmem_in_place_conversion=
>>> +                       [KVM] Controls whether KVM enables in-place conversion
>>> +                       support for guest_memfd and tracks the private/shared
>>> +                       state of memory per guest_memfd instead of per VM.
>>> +
>>> +                       If enabled, KVM enables the KVM_SET_MEMORY_ATTRIBUTES2
>>> +                       ioctl on guest_memfd file descriptors and disables the
>>> +                       legacy VM-scoped KVM_SET_MEMORY_ATTRIBUTES ioctl for
>>> +                       private memory state tracking. Only the
>>> +                       KVM_MEMORY_ATTRIBUTE_PRIVATE attribute moves to
>>> +                       per-guest_memfd tracking; other attributes remain
>>> +                       per-VM.
>>> +
>>> +                       This parameter toggles KVM's in-place conversion
>>> +                       capability support. Whether a VMM uses separate backends
>>> +                       or out-of-place memory management is determined by
>>> +                       userspace VMM design.
>>> +
>>> +                       Note, this parameter is only available when
>>> +                       CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y. When
>>> +                       CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set, in-place
>>> +                       conversion is unconditionally enabled.
>>> +
>>> +                       Default is Y (on).
>>
>> The parameter is only settable when CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y, and
>> in that config gmem_in_place_conversion initialises to
>> !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES), i.e. N, not Y. Is the doc line
>> wrong, or is N-by-default not what was intended here?
> 
> The doc is wrong.  The intent is to maintain backwards compatibility with existing
> deployments if KVM_VM_MEMORY_ATTRIBUTES=y.
> 

Will it result in the situation that kernel builds with CONFIG_KVM_VM_MEMORY_ATTRIBUTES
enabled by default for backwards compatibility, which requires users to explicitly enable 
gmem_in_place_conversion by the kernel option? Then it effectively disables
gmem_in_place_conversion by default.

But I guess it's OK for CSPs since they know what they want.


>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index 05c518c9b8078..929fd3e1a01e6 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -103,7 +103,10 @@ static bool __ro_after_init allow_unsafe_mappings;
>>>  module_param(allow_unsafe_mappings, bool, 0444);
>>>
>>>  #ifdef kvm_arch_has_private_mem
>>> -bool __ro_after_init gmem_in_place_conversion = false;
>>> +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
>>> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>>> +module_param(gmem_in_place_conversion, bool, 0444);
>>> +#endif
>>>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
>>>  #endif
> 


