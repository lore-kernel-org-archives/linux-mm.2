Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E2BC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69CCE6B0111; Tue,  1 Sep 2026 05:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674826B0112; Tue,  1 Sep 2026 05:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A6A6B0113; Tue,  1 Sep 2026 05:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3668B6B0111
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:47:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A90048029F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:47:58 +0000 (UTC)
X-FDA: 85164717036.29.B1130D8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf10.hostedemail.com (Postfix) with ESMTP id B2CB8C0002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:47:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IPtnMNmE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788256076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5faeiUjG+aBYB6yU4jsR9ESYZk3tOaOf1AhG4DhtK8=;
	b=oc51ZxLAjRGpcfCuHmynIqh3Lh9bXVcBF+57tgRW3aCUtc5m+aglKx2F37xVa+WbdWgG6m
	DYqmr9Bpbjsp4cnzATpbt0ZJljnnCWjMunPrYRkRNYHk7KwbAtDFPf647tEn3d1+/aNc0W
	P/7e6l9bM9oDHqV5s4RoGr05PonNRlY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788256076;
	b=hTgxQtyciMn6I7IvjxqZhzYt/ToChQf20w3JZHhGEW4TG6JNT1jN3NnLg0oBrd2DElRgcT
	bTyRDZdlza/cTI+gSQ+na5+m/DyrhAQvOqW6OB1HEEr+ECtKdwo7Xlyy/TlFI29hiHYRsp
	eaFjjDrDk3FXNELaR5WNqXfBYX07lVk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IPtnMNmE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788256076; x=1819792076;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PqWpX5qzfJy+A/rydNLTfBbEMaehm3F4tTQxb73Ubm0=;
  b=IPtnMNmERpOYan1GIQ0aFoihWxjM3PDlQM6DdxjRSFBxq3eoxIVfeE8V
   gO8o75npcz96Diy0aZRrOd2tptG9dBI/Ep2XuCHMmaP4BCGz+M9OUQngN
   vXUU3ZhlnAQi0QKI3kTMr3Dvdl/KcArsjQKGKuDGfC6VdVHmsZnszVeu/
   WZ8uCxwzafLyh5QOl4RFMxD4H5vtipCpnTlN43ojhu/mFbVYRtT/0tpSt
   uEeeT0MLuIOfxQBMAs1mwFY4j57COiurdpFCjIkVFIRF59ZTCGmjN1aRo
   7irLY4pQrJHjt7Wdf5G/iOJxj/+Prb/LTY7ReZ+nf2FpaDn9nvFkLTFLY
   w==;
X-CSE-ConnectionGUID: vaUuFdQ6RjOQ4lkRSGic4g==
X-CSE-MsgGUID: ki3Xcx5SSdKcVLxPIU6KCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92546902"
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="92546902"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 02:47:54 -0700
X-CSE-ConnectionGUID: fV2Zhz8TSAW2Arb2x6ej0w==
X-CSE-MsgGUID: 2maLF6D4Rr6e+knV4AZ/ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="307263818"
Received: from unknown (HELO [10.238.2.33]) ([10.238.2.33])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 02:47:40 -0700
Message-ID: <b5b02db8-2bd8-4952-8d35-5c0ecb664206@linux.intel.com>
Date: Tue, 1 Sep 2026 17:47:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 09/45] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-9-85e5fd25252a@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-9-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B2CB8C0002
X-Stat-Signature: t1yfc6zs8u5rcnajty331uka3tu4wemt
X-Rspam-User: 
X-HE-Tag: 1788256075-522945
X-HE-Meta: U2FsdGVkX19A0zt49w6GAJmI7mc2ttz9m4RU45yDrQ6TmBiXoG5rhkxN/k2mlcynlnm4PsBx5sS8s0W3UbNqJ5PXg34ixLwy7a8g3eYEzj6knRTHstYoAyq0q6RVCOlzlDWsHZIFtbMioBSYuqdZHwEPMQNYqwpXElqTqtx0cNLJRM7oAZhalmX76eLIx9Jnl08+LWq11/g9o3/hu4j3EMC/oisUzRFs9kS51qXHsE/0HJuF+ckpJxkmgIOtM25+dgk8RH60H1lCUrSdXmEhECScaxG7La+AXNKcpfg4G1phTUq1iyLwuePKsvE0GdLdcu+NxgIrrDx9YVf+c3kyMYHYjXTBO62b3nj/+613S/KQvaXl0BzydECnz3nJ/n3syDL7BqEYPT7wUNnoDZZ6JWfWWgLrbbIGt44OUdThnmhV64yr3hwtRMKygKRxcTLDKNHkIaWUP0Uz1d80Qizi2XkLP10VGTAD/FVH6FNW93/O4osnEcry3s3fOlY3Z6/c7LdWAeOLXC+XEpAe1w0Ci9sqImavojgWXjosCcndCz3C8CdNYXIjDPSpyVOyNXKLJhV26yJQ4EH8fmYm+X9J6PyGPLJKxMQqc+ND3Rw98dROE8f6Tqo07MJU05YYOZl5Qb6s1esjB9iUEsH8j6Cv6R3oEHFJtfZ9wfEiD/EHIL3cxvA+O28nrgDG0540c/Coqi7tfQ5OQy5mcnicvbmJKuob5xs53gGHAPWrHa3rVomZHl+km6FdmiEPkjrz49EYj7DhySqB1saUAu/U+1WQ0Eg7Dk5nG0AOBWx9bAyAeQhZ78nGLJJaPw/GOYri9BCW0VCfZhp6WhixfO4HGBoXJ00F7fN4jn/rM4tq8P93aranID+lYlOFjWxU+1DsUscXG1Qr6ZAcetI42XbVxjqtsP4Jtg/6maHX/T3U6z9JX4xyNps2f5A0cyhMyzSgjE0BWwvXE+wkcIP9OLVpeXw
 sgDDLkgB
 xkG6UDXlRzdFUHgGiFY24AdvhPa3UflSYh7xbuNWClG/Km7SaJaSq4yr0GKAqcwN8f1ug8GZK9KFqCmUEu6bGudzZAF5rzQVC8aBe/0SeifqhQQrS+h44yECGxUCYDSvaD8x0/FPcz6uBVH4VtO7EJkXZeRPQ3PKjo8xBlhyI3MuuWzcSJWxUq0/avA0mmJk6eesiYiu2IjOqJs1zPsTH09eURiYvYtC0e4AVZm8ZgttpOczLzDa/jku4EiPnhFeExLuwYNbeiz6LQ8r3OApvAoXlxLOubWd5nQ+oGXaAKPjo655jydTOvA1r/wBsFPwX+M5nT09WLw25/Nwr9ezHqQHf7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/2026 8:25 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Stub in global variable to enable in-place guest_memfd private<=>shared
> memory conversion, which will eventually be exposed to userspace via a
> module param, and wire up the __kvm_is_private_gfn() static call to the
> guest_memfd version when in-place conversion is enabled, i.e. when gmem is
> the sole authority on private vs. shared memory.
> 
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

> ---
>  Documentation/virt/kvm/api.rst |  7 +++++++
>  include/linux/kvm_host.h       |  6 ++++++
>  virt/kvm/guest_memfd.c         | 26 ++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c            | 12 +++++++++++-
>  4 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index e0430cc750c9e..90a29424c54c8 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6382,6 +6382,11 @@ KVM_SET_USER_MEMORY_REGION2, e.g. shared memory can be lazily mapped/allocated
>  on-demand.
>  
>  When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
> +userspace_addr vs. guest_memfd, based on the state in guest_memfd, which is the
> +sole authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD`
> +to find out more about the creation-time shared/private status.
> +
> +If in-place conversion is disabled, KVM selects shared vs. private, i.e consumes

Nit: i.e -> i.e.
>  userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
>  state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
>  is '0' for all gfns.  Userspace can control whether memory is shared/private by
> @@ -6429,6 +6434,8 @@ the state of a gfn/page as needed.
>  

