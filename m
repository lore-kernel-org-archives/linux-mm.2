Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04095C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E337F6B00A4; Wed,  5 Aug 2026 04:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD886B00A7; Wed,  5 Aug 2026 04:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37606B00AB; Wed,  5 Aug 2026 04:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8935D6B00A4
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:51:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1437A1603B5
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:51:37 +0000 (UTC)
X-FDA: 85066597434.07.B749A67
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id 90D5D4000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:51:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cr0lv+pF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785919895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+TgnqklNYX6qyw6xZG6d0tGTpOD/f7yI8qXmavWbms=;
	b=z+8QmxoPLCL0e6dQh3aSI4SMStLJZEm4tuYJC+ul0nU8VuyMTV0tcStRmk6J/xE2AZXiha
	W8zA8GhmEXCSrG/JElOeuwFGyO6Tgs8kJkMPK1WCJJt8YR/JrvUGJZhy7zLbc4fcc1QIlc
	miE0vACvm2gYNpL1bfC77ov4TSPAeow=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cr0lv+pF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785919895;
	b=nM3xRtjU9nsidiw1oJWIdHh07yQ0H0P6Ba90RC2bzwRWeqSVdnrsV4miaYynHMKhTjO6lJ
	WMxOZ4tqIBcee4JMmoNafmyoGiYrWOfMlBOOJbkGldvn3JX4gd0UnuuAYWhjCOeJV9J21Z
	9FT5dCjA7WBzOBUIuRlPJITIeTbcYws=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785919894; x=1817455894;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=906UFDydbGu9lslP/ICAwTRGBdF+G9rFbkPozEz0hlg=;
  b=cr0lv+pF8TskTx5KYHXoUeJGJl0ayuhqSz9foeb28s+63tkilyj7A7M6
   jMFQLPO3S0gq+rURG91UUHqTcwLPHtU1XFxdWKQk3w77lLY0MYXxd8GTA
   M07MvdGK2vl7wv0KHZP8Y+zZEAjsnMHIhugjqoFgu1OYvGhSNKOPydp5C
   3CpDQPstgjgfclFDUKpAaCvWK5cVGCTaeSQ4SOjeSw/l02Jo+zTbKo33p
   CW8+2j1TOQA7V2QpJK+Iv74zXBq5n6h6KIBaWOc/y2zS4ntK4EQIZVF9I
   bRY9shvlhTS+RZUD3nakEAc+26SfVThI1hS5jDP5OL9h5ghS1mxNjdqse
   w==;
X-CSE-ConnectionGUID: fVIE0s0tQHSlTZJB7qJ2+Q==
X-CSE-MsgGUID: eB6CM/StT8Sp5+Dx1sZOcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="86603471"
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="86603471"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 01:51:32 -0700
X-CSE-ConnectionGUID: xl8+sgnqTkGG1UwygjFcIw==
X-CSE-MsgGUID: MdQoRWnhTqKbstjwpzVllg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="259988166"
Received: from fuxiaogu-mobl1.ccr.corp.intel.com (HELO [10.238.208.47]) ([10.238.208.47])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 01:51:20 -0700
Message-ID: <b9ad1a1d-c167-4adb-980b-90096515a363@intel.com>
Date: Wed, 5 Aug 2026 16:51:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/41] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
To: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-3-35f9aec2aed2@google.com>
 <7dafaa90-f3d4-4be4-a5cc-472163f18040@intel.com>
 <CAEvNRgG3qXrG2ix2MEcyVo0GXaen-Pte4gFAwEN+9AY=VtGU5w@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CAEvNRgG3qXrG2ix2MEcyVo0GXaen-Pte4gFAwEN+9AY=VtGU5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 90D5D4000A
X-Stat-Signature: easr9b6esr5gt1h47es89t6zp7it1bhh
X-Rspam-User: 
X-HE-Tag: 1785919893-289190
X-HE-Meta: U2FsdGVkX1/lQS1TlGlCUtnUDr2putgz0RaSvjDjbMeI/WEXzIZlq/eR9oHtuJGv5RkCv5tJqcHab8xIXyl+EQk9UmjYxIld0EFiGJSzgFc595SU7kKtNXrtXKgbnk3nfCuHFDQ26usEiOXHV1PBxm/dOhX4EQaTFP5Oeu5co7CDHQunMgerxSXacVhgECGaGtzUrRiG7YtLLvfmAhxKHkhZiWHefsJjKV8myiuiKV1NlOnKZOnW/GvzIpw0eJesFz7i2YHZPMf60HUpIYMqHhPCUVzF08VdvRl1u4POphvoDATOhg0XlCH/3rA2JQH6GBxICR7PgI02IUF5GIXRWc1q645vfzv7XvypjraVrQMUy4iYjkZKf+UHY2TSuJD7K3cCHN/drUdH6fkbFwWrxPLU0evwA9jA8DBbNeCpJi+Ypw1Eyd2el7L6KuktF3vufVIjH7DBp3VjbwTgPYxgxDhx+jRoPhcNqABpBirANRnwi9sSxxGSYvnoifisB4dAg7WXEF8c7q0bmeUvAPix+0StJZFqIvmlgdGSxPU4RydY7LBS0JnfY2i7KmhwADJQRTgDDHTgIN1ymurHKoIO9h0FzLdkF03q+XebbRhLj0lJ7oedDX55mMIOW3Mpme+705lqPM0JD+w7++C5xRr6yjcvBZymVFB4/ZatmTHq3ZwdqEf/9tHB1QYa/8fyKx1BjmqZHsF54xFWbxpO00iT9hwZaLTCVDsuoDeAbZJyt/PmYz2AzYKqmalmnsjpS858aqYd5RijzUV2M4fcSn4pjlCo/Fi5uBHakHnS7eW+GI8X/rAL2ngCX+D6FsekDMajRHfL9OrSmXKX3G3Knu10r1Ajt+LNwrNd1oaq+6twHarKmr/OrBxAQezff8Wn8AxQ7pKuF3Ot0tkAVgmpJzmZJMAs/epqPV0Tk3mEZq4IPkR21Ta1AaGUIl7pc6to1gh++yqUMf3LEl1+Kp1nMCh
 KU8Tck43
 KeYkOb42Y/5ZRm3cJ6JPD+VsZ2C0YiXIC7tzp3djr0HhL7PKN5yFKcYX8KuqSLfyTxNTkIIKT5CrUJoJZpVK+Cf4D54BppBS2S9dGvhcg0ebtR4GV2yozevX4bsDVHDazU14sbz8X8NIuvGeEsrtfvSWgWNvgv3sNo1oIf2sahlg/vB4mcTvH8kWuMA9GFXoGgsniKjQpc8cafrDYhE2kyh1LlhlcVdwJwZ2dBfvujuCcufXSoBHy2d/AipYWVpqDtjeX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/2026 4:34 AM, Ackerley Tng wrote:
> I think another way to phrase this is that if we don't make this change,
> say, on the foo architecture where there's no CoCo and no private mem
> support, kvm_supported_mem_attributes() would return true for the !kvm
> case, which is over-reporting.

Under the condition that the foo architecture enables 
CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

> How about this, replacing the entire changelog paragraph above:
> 
>    Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE
>    based on kvm_arch_has_private_mem being #defined. This improves
>    reporting accuracy by not reporting support for
>    KVM_MEMORY_ATTRIBUTE_PRIVATE when kvm_supported_mem_attributes() is
>    called with kvm == NULL.

It doesn't help for the case where kvm == NULL, but help for the case 
where CONFIG_KVM_VM_MEMORY_ATTRIBUTES is defined but 
kvm_arch_has_private_mem not.

sorry for being picky. I think we can say

This improves the reporting accuracy by avoiding the case where 
KVM_MEMORY_ATTRIBUTE_PRIVATE is reported when kvm == null even without 
kvm_arch_has_private_mem being #defined.

>    Give architectures full control over overriding the default definition
>    of kvm_arch_has_private_mem() by removing the coupling with
>    CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> 
>    In a later patch, kvm_arch_has_private_mem() will be defined based on
>    whether architectural features are compiled in, and made orthogonal to
>    CONFIG_KVM_VM_MEMORY_ATTRIBUTES.


