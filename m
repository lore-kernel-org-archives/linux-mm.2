Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FD4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A123C6B00EF; Tue, 30 Jun 2026 11:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9DF6B00F3; Tue, 30 Jun 2026 11:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C9B6B00F7; Tue, 30 Jun 2026 11:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 614976B00EF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:23:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D315A167544
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:23:11 +0000 (UTC)
X-FDA: 84936947382.23.15DCD29
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id E4591140002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:23:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PljmnIZ6;
	spf=pass (imf23.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782832989;
	b=njAGJYgz3u1RyOkOMbMvwZZCmYNuXHRi2d/Rbs1rbPAIHbycT3+FJkVfCPBKCGFClDwEqt
	g1HU7Y2RSeXlbwbTPTD3yHbCfNFt/rzVYU4/68iSnUY1j2V0847ErdOI54HvG7z/9qTDiY
	yvxgx+CecKzvxDmACUjXCLln1r1SDPM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782832989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeVsLjX+CY+8QuH2II8zRBn524xhjH+jday/+k6P4os=;
	b=PqDAJp7dPHJPjvKDmnFUHxIQjA/CRRcn6Vr62mP++ruaH1zVOxpdCQZzcVkn+XH28giiaB
	0NySG69RlIl3GT9zmGLHHB/n2LQExlbFq71hijOuZ9eiFos+cZKusCKxcSfKhVDvOPECk9
	UjALRHmECF6T3S9jyRqcAeiBzxLNpZ0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PljmnIZ6;
	spf=pass (imf23.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782832989; x=1814368989;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mnhOZlEbmNxq5YsCTla36EPa18OakR+bG+jTvbDU7EM=;
  b=PljmnIZ6oNJK/zFmmr8y+dFBNVZtaouorY0pJ/5IVpa2P8MW8uGGkb/s
   gzptdNvPb5xBssfce58PQqzHFHNpYB6GBoSWGC9QAOWbTKx1pFsfOOWSj
   EmjbvkVd7fwh1gVgxFL90ltJhaKu6QVXD1lfFZb0x7hyTDTynSnjZGXqO
   4gIgqOYpNuTAPlDeq/JoIU2vL4QDSVCdFhQG5UgkPIrTDVHJZ3qjRuzw4
   YqffIF//hkiOlPKRePZPjN27ncchZj6uxQROlWbNj5v8muOwU0UrnWC6D
   Npdb33KyKsufdr9wRHt/ASsEPkJs3uYjWNO+/LXM+B4UtVBIqazMCF2//
   A==;
X-CSE-ConnectionGUID: taIPqLseQZ6pi4StRL6BWA==
X-CSE-MsgGUID: ZrM0cJRdQV6QxnGZjsZFrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="94933106"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="94933106"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 08:23:07 -0700
X-CSE-ConnectionGUID: koRW/7MOQAWk92/0rXPmZQ==
X-CSE-MsgGUID: uXiMTSzqQL6ITT9qU5pf5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="254200312"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.232.239]) ([10.124.232.239])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 08:22:54 -0700
Message-ID: <a1b06afb-af6e-4666-8c7d-990e7fa150fa@intel.com>
Date: Tue, 30 Jun 2026 23:22:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/46] KVM: Rename memory attribute APIs to prepare for
 in-place gmem conversion
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-7-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-7-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E4591140002
X-Stat-Signature: mrk9x599g6h8bxdnj41ig99yra1xp11y
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782832988-127489
X-HE-Meta: U2FsdGVkX1+VHKrS4GEQpsHNpwSgGehcoy1XNG2uOQ6MrtK1LiaCG0y44NoPlGGXp3koIsfcDTStR3Vt+WZ48incjGwaiuw7D0Am1NoX67H8IipsnZt8cxxlBuT35BoKS2cFPhMR3wMXtA51wT2K13jb+ogCUA2z56z6sC7UNNUMoNxZOq9mnvgKZm7lyd+9IRaoI8h7A7ouiOvG7bd10VdxcGINbCmkMpuB9GK2L/Pvjbfv2kKwBoi4VbvNkDM/+f/+9MTLa5Yoj0ezPcY7VT5ObfX8tXj669JXfejivbia/xRBzuVb+oSOSG4t0SVj9YRpduZ66WyqJptfQFEz+ZHDnTHKonSWxW0s1LKEsxlx+L+Lj+tVvUyjjv1a4top45QlIYoeh2YzA7/eCRTRDoB6Jz+YrAozN6mkfySm0Nn+3TIRZS8n9oix/EunbUNWjNHjmZdxjlPakVfCPipY16yiusK44sAssyRPY2Kfva74xZHH9GG2i2CrTyRRLlsPBzjFtuYVlh6j0TsJkuVFVccWHScVt3ricRFyRYkqHIfZ86XXUAjv/ijYyGiqwpcbgHDzI/3JN03FFhBHky+842bomnDEwkr6VsRUAqqKCLwO8UsLnMrhUT53an2WSqdU6p2vRLeJl0wOR/w9bfNpgrPiGgfglT88gMkUgV1ZfY3kDxRWBre+yDNBK+uF89vGhcMebNEN7yqQY7uTNOhs4mKHyeMlW/6VzcWfZUeO+POFxJxvRTPgqYhoQKEcCfsRJZKY19T+5lqqinDDqkz7I4FA1WTIpcaOw1pafMXOCtOXFw2Auvj7pnwKWc6nBjiJBwp5PBfb3/AgqEE0cAQOrdgiJRxqBWRKXuMTsnKI/LWNDb5MqsjBNIipUZkRpo9R5GCXIsf02xkBkA7p3kHEg825j8ogc7IyfEcG6DkiDGuXEScJab9zN/GTBdbVJJwEgZgtDTtCqKi9RezQVHF
 ZboeS93Z
 A1csYznfwle6H4ktKhR98xl8byTjvaRDCOh5gnT8wAXadX06NYwZI3kH5VjgaaDPEgRyVcP5aAqu6JA37FcgkYT3ruq9M85nmtLOArCt0aYP0tygo7GUw6nQ/d7Yh1WbKsdPjeQhoz1RdrNKTjafQTuRu/DIgV0tGSiOZBDpadMDbYxVd9ji2YcLeRPbeGM4zvjjiZ0SoSPAnoBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> -bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> -				     unsigned long mask, unsigned long attrs);
> +bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> +					unsigned long mask, unsigned long attrs);
>   bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>   					struct kvm_gfn_range *range);
>   bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,

We have

  - kvm_pre_set_memory_attributes()
  - kvm_arch_pre_set_memory_attributes()
  - kvm_arch_post_set_memory_attributes()

left, do they need to be renamed as well?

then the interesting one is kvm_vm_set_mem_attributes(), which contains 
"vm" already while it means "vm ioctl". Do we need to rename it to
kvm_vm_set_vm_mem_attributes()?


