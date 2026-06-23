Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1690CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBD3D6B0088; Tue, 23 Jun 2026 05:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E396B008C; Tue, 23 Jun 2026 05:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FA26B0092; Tue, 23 Jun 2026 05:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EBFB6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:14:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA0A814016D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:14:37 +0000 (UTC)
X-FDA: 84910616994.16.B9ACE61
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf01.hostedemail.com (Postfix) with ESMTP id D177540009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:14:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B1HYBTv5;
	spf=pass (imf01.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782206075;
	b=HlvkMvCDUTpBDy+9dXWg8F4sfKgyQQgXPiwXK8kFr+V/YQt5MZ2rn8dd7a/WyCp/0Y1lKf
	hDrtBrv3JP66ljTgI0+VVV21G0uUoxOmwk35lI5fIY9NSVcVS0bKFy2Do/U2MZlZf9cU0/
	kdFHNLXFiEoBXn4ItNTJ86UW2B/v2b0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782206075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VOSX14L+NRB8icjtT2cnsav3cWq5z8qOwezpbJDOBXM=;
	b=GFQjlA18/6XxYRNCiy4huKcEoIyQ5W0P7cTzZrmgZPONFujjHkK2CF/zpnjEP72Imbmh/i
	9qgkt8zgCEevCfv1lBTDRsAlLCYr92BhwEzYsqwrAjEARetKcvhc93cy31CKwEqW+NPXli
	31M+HDDBPft5+NjvKuW4FV5m1fdRDKY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B1HYBTv5;
	spf=pass (imf01.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782206074; x=1813742074;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Jrc3/1n6ncWF3VtGjXxG0cjpZMrkrKJOMwZImn13ef8=;
  b=B1HYBTv5zCc1yg03wjf7qw0TL8Nk5byljL4eqNNuyWCrmUSoYniENJ1M
   P1qUfgrPDhA+6rqxYza4LpljJxYeLBizrFdKu3LZAVu/R0Q/vxjZF+oHW
   +RpQTFwwBxd2mVtc4ftAcAluETznR6jsKhSdMnMLv5E3cII9BakePN6Ab
   YDox8bHtwc91R8RsG3M0PtOHe3JV4AsPl+urx70D5Xy5LoQjqF7Y3ApaE
   JKn3LeTgswUXffP6d0vl1KwJebY5VcNRUlS9/QeiF7WrysdqAu4eBa1YT
   f0gJWYilaK6F3cBw1uwr3pfvqSN5mCIEAV/vyahuOK5stqVWornyHhpZ/
   A==;
X-CSE-ConnectionGUID: tI8PVzDeTim3nM3nEX0nbw==
X-CSE-MsgGUID: WFi70M/QRs6OAP+B9BNdMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="83035936"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="83035936"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 02:14:33 -0700
X-CSE-ConnectionGUID: yDliffaBQUauzjb87+herA==
X-CSE-MsgGUID: hc/L1AFkR22qU5djSHzk5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="245328315"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 02:14:20 -0700
Message-ID: <058d1f8c-b718-47fe-a7c4-f13828993189@linux.intel.com>
Date: Tue, 23 Jun 2026 17:14:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 17/46] KVM: guest_memfd: Advertise
 KVM_SET_MEMORY_ATTRIBUTES2 ioctl
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-17-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-17-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D177540009
X-Stat-Signature: pxwmzw1tpxsewbh3uhopedxdh65pso6w
X-HE-Tag: 1782206074-186885
X-HE-Meta: U2FsdGVkX1+YG532y/8QE3BoMJ3QKHxXx55LwxcpLAkuUPgYfDSqpswfiPmi2qoe+JcC3JTJVp8nzsQhYMP+JVIhzLFIcpHFttFHzV6fBQT0iD+iVLmvxj1xJLpOfEpCn+ctFN4E9+97JY9iwWcyf1MMoVOySyUeSFLcJ6pEF9Q+kPTgV3BEIGrzAZyinN8xlMzwu3VNJzbcQSWJu3uWi7uZ4V4GF2dJ3ne8OSVOdiT8aBKrb+eKKP3sfllGKYZ8G5bOb5fy4xVOur5ne8yGGU8Ibf4g7U2KuQtQgHAOxVr5kNGBFaBsc/YkNDUk2Q1oCRh0qW9vOnfjHabXFlIZu1gb41mIWVT9PPtmvSVH0EssTZxsA2HIMZGJIlY6+tuQms1PSOyZLFZgKXrWgDgDIl/khe+D3YwTx+qw4fwcSqhT8PdmJQIjRPLGb90+oBu7grPOR2xUQ57i7zlo2rBeiGWsLjLu8GsxQQ/UzzAkVbFr2xqv7VgsCB2zBWKwpoZ2Y8TG9ShkvuWI4+uW5cjeiqk6s64tX7SkoVPAtW9EtuFdNWRc7JtKfX1q3Tt3Ctjn5KxDzioB70AG0IEA0HEnm6EeOVnHK7lPGoxrD6DEhMbynSySBEFd2TqJ73gGqK37Ttpdkkb1G28goyxO57yr4kBt6uT4KckW2r4jqYxmds3+SdXE+WFMA2gcEh5dVYvw0mOwn7rijh1KvX8kuWwYWgyEXnI7t4XMSRp2ooCR5/k57zO8fRsRD5ZvJqkHiFSkt48SqP+AQQaA6sY/Z1RDlQoJrDbiLhxogLQtjhQkXJm6KnbArrGnHIdv7KnS7W/pplMddXlCVGMveH0nzV+//tBush7ntXXmgVYFLiGO42KCDJTgxR2SffpYhGTk0e9AKDtBFne4m6QserXk8rvEK0E68yyjwrlot30sPxofxhZbuYSe3h/jKYGU+562IL/8+DJbB5jV7umCbM9Ge+F
 u7x+maQt
 f/ZP7kIDPDZ7WAVfGJZqm8hNqV+ekvCUc1ph3b7h0tNK3tvNo0tKq+aC3b3KXLP8aZADLQzALh6VUX2/xbyNX6Es6WLU2fldq7ObDN3pvXs5IhHNJkmQqx/rTnHZuVkkfs9mxr7KxmjRlvMk22CRhY0oXBEGKnAX7UFnUnGxH+oeGK9/ekqcy9eRTrC7CwJ7r/S5I8dybldOsn67rfxyOT39FzBKy5McRee43w+1eUdHyw/yh9sIDziQwvNPToGqV3vgPiKtr3IgHenqfb3S/ATh5WMEzjzJ02x7Dsw2ZaLqExjqkTcDYgAsy2CF0ypl3j0/0vTnIVqZOibAFM4KISjkAb8oBIAntNwwjck6cNZqPj4GG8LgAa30pTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Introduce KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES to advertise the
> availability of the KVM_SET_MEMORY_ATTRIBUTES2 ioctl.
> 
> KVM_SET_MEMORY_ATTRIBUTES2 is a guest_memfd-scoped version of the existing
> KVM_SET_MEMORY_ATTRIBUTES VM ioctl. It allows userspace to manage memory
> attributes, such as KVM_MEMORY_ATTRIBUTE_PRIVATE, directly on a guest_memfd
> file descriptor.
> 
> This new version uses struct kvm_memory_attributes2, which adds an
> error_offset field to the output. This allows KVM to return the specific
> offset that triggered an error, which is especially useful for handling
> EAGAIN results caused by transient page reference counts during attribute
> conversions.
> 
> Update the KVM API documentation to define the new ioctl and its behavior,
> and add the necessary UAPI definitions and capability checks.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

Two nits below.


>  
> +4.145 KVM_SET_MEMORY_ATTRIBUTES2
> +---------------------------------
> +
> +:Capability: KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
> +:Architectures: all
> +:Type: guest_memfd ioctl
> +:Parameters: struct kvm_memory_attributes2 (in/out)
> +:Returns: 0 on success, <0 on error
> +
> +Errors:
> +
> +  ========== ===============================================================
> +  EINVAL     The specified `offset` or `size` were invalid (e.g. not
                                                   ^
                                                 was
 > +             page aligned, causes an overflow, or size is zero).
> +  EFAULT     The parameter address was invalid.
> +  EAGAIN     Some page within requested range had unexpected refcounts. The
> +             offset of the page will be returned in `error_offset`.
> +  ENOMEM     Ran out of memory trying to track private/shared state
> +  ========== ===============================================================

[...]

> +
> +Set attributes for a range of offsets within a guest_memfd to
> +KVM_MEMORY_ATTRIBUTE_PRIVATE to limit the specified guest_memfd backed
> +memory range for guest_use. Even if KVM_CAP_GUEST_MEMFD_MMAP is
                         ^
                    guest use

> +supported, after a successful call to set
> +KVM_MEMORY_ATTRIBUTE_PRIVATE, the requested range will not be mappable
> +into host userspace and will only be mappable by the guest.
> +


