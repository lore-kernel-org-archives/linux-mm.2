Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C646CC43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBFC06B00A6; Wed,  1 Jul 2026 03:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70876B00A8; Wed,  1 Jul 2026 03:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F816B00A9; Wed,  1 Jul 2026 03:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 773076B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:02:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 011BEA025C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:02:14 +0000 (UTC)
X-FDA: 84939313788.08.63719AA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2A1244000D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:02:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BsZxu9in;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782889333;
	b=2eenqYxGJ5ce9d7B5t0SKoupXIWlx3y9ri6u753WXT7h6nisKsNGGsF4SJrlAFl/5kIp0v
	3zAu++0M2zn1yntj5n1pxWGRqurFyevojB/pOZsNUhMNyoBH64ogXJslGfkDjHfNnOXEzK
	7gI5A5yehEhI8/9fKza8KTzDHgUjRoE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782889333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ots+B0NdDwQ9ftIp5q6RtA1+ilGtoCJvyJYKmvWrsUE=;
	b=6lSsD6trVEpszVWxGRSfv44l7Npa3t8X4AETBxBqmLVKPgZ+UHbYVdlRwGvqZ+D7e5YmP1
	ETdrFM18OFC8PskioSmixg8jabWO2fTBIuZe5a+5lkMei4s3fHHrpqhEcsqBR8rlzCrz1r
	7j598eDV+Ihal5V+dRYQeAZEdNEYsew=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BsZxu9in;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782889332; x=1814425332;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uTemCS9hJuZwaBtUWAiWvpe3nJ0DnwAEJpllNENNMkc=;
  b=BsZxu9inLJyO6hlBjk+JmUAqD7xGtSvRyNfHKsI/QE1xmwSDjJpZiEoT
   /AxOz6NWKW2Y2ybAphGGoyBRYDO8eN36V81zzLHkukAjqbit35Nl6WG7+
   7eIGJ5zACZJc1fuEtFzkwJSYVTaOhjPX5LbByr/u2fr3g5kd72BXXoPVj
   579v6TzS8Re53L1Uo7x2S11U2uLxo0CczUA/djVJ73F5zHsNyX2/zoHIo
   KJjaTmUu28JOWlcQC++i1qvFNW7lQBi/pIfu9SNLfs/7hFZZERwlbxc5G
   VwSbs6A+IS7ygR72cyh+HaUP9QDjEupaSx1c01W2kPc3Qu8z0+KQ12ZuG
   A==;
X-CSE-ConnectionGUID: KVkufQNcTdW4vtLFD3HR1A==
X-CSE-MsgGUID: ydylE0IDQrK26kpz5JpyGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="82728609"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="82728609"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 00:02:11 -0700
X-CSE-ConnectionGUID: IOyXLa5dSF2JqjSse/2n1w==
X-CSE-MsgGUID: JbKqh+eBRZqdMAtXHVxILg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="275705575"
Received: from unknown (HELO [10.239.158.49]) ([10.239.158.49])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 00:01:53 -0700
Message-ID: <e5876e41-a11a-4d5e-958f-9e247c19d387@intel.com>
Date: Wed, 1 Jul 2026 15:01:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/46] KVM: Rename memory attribute APIs to prepare for
 in-place gmem conversion
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-7-9d2959357853@google.com>
 <a1b06afb-af6e-4666-8c7d-990e7fa150fa@intel.com>
 <akP9Qv_IPVEh7GAB@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <akP9Qv_IPVEh7GAB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A1244000D
X-Stat-Signature: 9q3wgpg1n66jfkne43ssanet1g5a4ytj
X-HE-Tag: 1782889331-847095
X-HE-Meta: U2FsdGVkX18ch1LHl90CKny8hDULVrGduT9RUGBNGpE+tAONwtLeAFZiaN9DhuddKGpUxhk1j4ndriFaqTna2gb/y5KhbN34cTJ6EdoT/l1uqcBOidJJvpjDiNkS7/Ufe49dZFjnwTR26fV3a6eg+wgZipEDEXIMT98EviLnUhaxMfN8GmGoVxnLDVwh2SkIP+mBTiVjuZJ9DbVnWsSm44XBbmp1XZj2pJ7ocRcBw3rTYmmE+THUKPwKw17+A/K5bf8O04VHwAwkpZJ29q0V+6EGPwz/f6brXnBEkHR41Z8XlnMRyUKdS14saq3owghMp7/5KLIK2xemnGD7ioFINygVNiiaqvlUVcnM7rpBG5rQIb09uvVcZxzbltR3v7NRgzcxlPmS6MZdJuxxePMZ54HZnuHB0iQ2Es0nbsKKwYCzkIWyrOBVu5KwshwauektqyLCOqKeIVB7k/Crwu6pCjwh4/fMsIVGSAVEo1B9B/98DlBJIx3R9zMXjmpUj2rJ6TsGDd2SYrhlr3wjt76EytNGHV8qODIhrBMhm3ZW5gl3obkr8OYfJb6blcaXwyywVvDFZYYB8TBYc6aY+/WBm+mETkb0ot1OyR25ch/M3JnDI5rDGSqCSSua1rkOgic5m7e3hidcdHAvGc4ec8+3H5VQ3/K3h9Cir5MjlUGNftTzKVYte1PQfEXlD1gBIWEVMqcF4raIV0YHcK0A3HJ4wXKw0DWmnH6Lwv9rcakTBb9ZJqce89chbVKOsrusNfD3NsgSu8mPqpbPC/gWZ6Ei6QrOdXCLhv4GKXTAjVgkOxiUAB/d8jbb4K86vFSCO6ma2b/0Vi6AJL+P/a6J+/hVlun8aWArguNtF6RPJoqxlG48btGV6AHZZi850TYlodfc+95X9eDw9FEPjzcQD3jPHnsxTCdP7GLQLxBKpaC/GiZBB4fqJ4JKOZqv0Qal3FIPOa50fyQXRdLpJUei9zD
 iYhvXWB6
 pyu2erHMfQqRHOAZFDWPAWNltGizsoiI70OUXnC/4dJ89HIrbynp7YBEE0mr5zRGuPEF2/0FVtMGPLIUmKhqa1KOJIAUu1azTl7tqjIjACZD64fGlkL+dvgRqacV7KUYkuCI/cbuXh+Xmm2a8A/DkS0s+dJwXvYS3diW0LPkHixtKVMdF1Tr/Siv/lZz069H3/W5mn806kn6wtIEXpV6OV4OB0tUWDTwQY9vpI42/KztaQIh5IcjGEL4Hhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/2026 1:30 AM, Sean Christopherson wrote:
> On Tue, Jun 30, 2026, Xiaoyao Li wrote:
>> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
>>> -bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>>> -				     unsigned long mask, unsigned long attrs);
>>> +bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>>> +					unsigned long mask, unsigned long attrs);
>>>    bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>>>    					struct kvm_gfn_range *range);
>>>    bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>>
>> We have
>>
>>   - kvm_pre_set_memory_attributes()
>>   - kvm_arch_pre_set_memory_attributes()
>>   - kvm_arch_post_set_memory_attributes()
> 
> Yeah, that's probably for the best.
> 
>> left, do they need to be renamed as well?
>>
>> then the interesting one is kvm_vm_set_mem_attributes(), which contains "vm"
>> already while it means "vm ioctl". Do we need to rename it to
>> kvm_vm_set_vm_mem_attributes()?
> 
> I say "no" on this last one, the fact that the function is scoped to a VM ioctl
> is enough to communicate that it applies to per-VM attributes.
> 
> Actually, since it's a local helper, we could go with kvm_set_vm_mem_attributes()
> to be consistent with the other functions.  That just leaves
> kvm_vm_ioctl_set_mem_attributes(), which I think it appropriately scoped.

If we finally choose to rename kvm_vm_set_mem_attributes() to 
kvm_set_vm_mem_attributes(), I think the trace 
trace_kvm_vm_set_mem_attributes() needs to be renamed to keep it consistent?

