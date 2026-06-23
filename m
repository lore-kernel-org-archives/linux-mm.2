Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 892B4CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 07:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2213B6B008C; Tue, 23 Jun 2026 03:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3FE6B0092; Tue, 23 Jun 2026 03:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075386B0093; Tue, 23 Jun 2026 03:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFBCC6B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:39:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55C42166E2A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:39:05 +0000 (UTC)
X-FDA: 84910376250.26.45456DC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9D81A180003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:39:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JZ+8cwbm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782200343;
	b=XYT/GU0EheCC7YUoGVQsmbLZP1XBcBIwttvjnO8tlpJGKiokFY8R9NstUzZ29XX+c45kR4
	tp7T/8GpeZt24nYmTJxdVWDPJIr38D95rad69X5x7jUCV+J7GsM839H4HG5aaFY0jfDwXN
	TVtoQU6102OM5i3bIMShn4iVVOel9N4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782200343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gnja+u6ArMh5XHiHE9A2+I906UTYl93Wc4N1mIqDwrY=;
	b=GdmFcYQnWdwTuGJbS3s69P34Bop3Xr8eo2WFx9lEbrNJzpKGvYXZD+IRuHzDNAtE0Jwrqw
	9MIgJPhqQA2Up3Y9xJtYG5GdvJdPykLYdWAyyF1uuRVhVik4tTvY07cj8/rDKThsLT1B+C
	aDS42jAvTEiBKewhXKKRKYkrG3iGPsY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JZ+8cwbm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782200343; x=1813736343;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9M53Doqkm/ZxlnBoSdM7DNRi6CHdmePszrm5SmUxjlw=;
  b=JZ+8cwbmyjkCgnTlGPFlwWeWcejsSIerkiX8k+QRrVMat5cpXtFcX3zp
   y1AP6IrKoIuvL3g70I52noYdKhNK5VxHvo/TbvACiBC7tTyYd6F9m9n6x
   fkc7NA3GZOCcToCPJXCPQUTbC34+PW5x7Zxgajy6sJJ7jPDrPUXItPoya
   WS7m0e3WldDQK0FT0TxgJ0Z4ex4NbFXeaKDCmzW2m6kZ+i4WeRdg+yjVv
   r6ZBe7C+usB/NjZEZuxCs0P61/I7IcWvXTMnyeAFVoDpXR3YVOPafhqXB
   6pPrXL83vnG5UFrRCptgZJLAbWs6vp0X6PQYxfbFNdfJ3Rnx+3xDJYwR/
   Q==;
X-CSE-ConnectionGUID: 8ISALPfsR7iDFlZ+2oB+4g==
X-CSE-MsgGUID: cS8sWi8BSmCIaGfbNooL5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="93300767"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="93300767"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 00:39:01 -0700
X-CSE-ConnectionGUID: ouVIYE8qSdG+QaUlar4m7w==
X-CSE-MsgGUID: 3mQz4kUVQfKSAD4PEZxlOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="248298804"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 00:38:47 -0700
Message-ID: <ede86ac4-d560-49a6-82d6-b33ac5fc9355@linux.intel.com>
Date: Tue, 23 Jun 2026 15:38:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 13/46] KVM: guest_memfd: Add base support for
 KVM_SET_MEMORY_ATTRIBUTES2
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
 <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9D81A180003
X-Rspam-User: 
X-Stat-Signature: nayymymkk3ufng6gwp74nddfmsp4w18w
X-HE-Tag: 1782200342-556715
X-HE-Meta: U2FsdGVkX18x/3spcgBcdr1mXWRBt4iPJc7FWK9UelnEFpNT0u7Y5Yh3V8VllX3WkNR/6CSnmnoa30eBhgaqX4zLJocIuxqulfqxEKUxikg6I2YIg+xK9TttpQo5XlEK8YbOtaXjNkAL3HKyFu0zxercv9Exyq/Ba7oqWXaNDo8E8hI/H8XwGzUgLZs+rJbw98oXIdXS2AYSkViE2zQ1KZFxckaSPebFuyjfMz6eEqlitwecWFVr4Kt1n3PAp96jBPPQtpYh/YqIrz2sDrAb0Fe28/MQ7n1ZzL+w8AhLGs63jKtZxb3pAmZV8ifwAqJIBZ5464SqwJWbkI6JVJCCvKkJVkxPGhH3QM4a7UXpwqmur+MT/Kr6XRbkIooP9y4top1cG/3yX39VmS1lo0pblDYC4+xhJoTCi6YwtTGbmeO1exylmwdk5ghcJdiZw88wgWp8dGPH3sil5p6fTLUXm2Gm0ZQQZ1VALqdOTbGSIh4MlK2+DW2rjleiBWJxNNvidjhlS96NsLBQSEOnzfbJxuLtuda10iEgB0LC1QYfJNR0VRWIyWWddnbVAWzM+VpHxozPwUftLUvpdLXDOUuyu1r25/tjVFKoI/CdElzkXJ4t2k9+AeDaURZFFBqUckB91r3CNghmE4+rpOLIxt6vxbJEoOtXbgEKMlZgUHCXRQ4KY+2rqdnYe2fM2Xx853e0RKYK0olji8InwaZpGGmB8NQ5PSgox93hssfeV1+tgWAlv4eFcFK1PQRtkgzLZkuPMSvSoEQM/GoevP2mbrU6CkEPOIulTyUL6RCOlsFO9xIFpwGT2uYV6A4cBLMi17DUoljd7eZvoJd2Z5kBSxPNLdEk3Q63flXkq20xMc54q/nRAnDx6iDI8GYn9x0dcZFr+YTvU4gZe4LrC4QzBm5kF8Vyka0ELlXgT2mlpVdPfKW4fSO0XhtK9k/oqTxT6fo5iKU1N2VggpuwwlocSqZ
 fpqMKEZg
 UQnGuAb76pmgGLd7IIO8SjudlT4i4ItagltWL2j62zCiJINWaMlt951zmIAQ7EQNrpKcJDsG86GC1JyfjHnl8p0phbKQcSyYdnvcU9Ydnh31+zqW8FUV9h5JzyTxlqve3TJObGSvZHLR5sHGNyA028xZhOxq3Pb4qKi12CCKkxVdIS6gsbzBcz4YwuBkirMc9y0dZ0koLOOOve+AcraQdww11Lw67ArOOm5fUWRxFFG+8hMcxHTSRvywGAmcMMItJkmbUTxcNgWzTp68z7qcFjCZzpPcn1VuWKUIZgVT0jmY2pIUk7lmzg8zKv5R8KMk7E+kYa3DCSupFiRDnF7KgsHpAUSMZWrA+NL0LHxepoa+qqc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Introduce base support for KVM_SET_MEMORY_ATTRIBUTES2 in guest_memfd, which
> just updates attributes tracked by guest_memfd.
> 
> Validate input fields in general. Guard usage of KVM_SET_MEMORY_ATTRIBUTES2
> by making sure requested attributes are supported for this instance of kvm.
> 
> A new KVM_SET_MEMORY_ATTRIBUTES2 is defined to support writes (unlike
> KVM_SET_MEMORY_ATTRIBUTES) in addition to reads so it can provide error
> details to userspace. This will be used in a later patch.
> 
> The two ioctls use their corresponding structs with no overlap, but
> backward compatibility is baked in for future support of
> KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2 in the VM
> ioctl.
> 
> The process of setting memory attributes is set up such that the later half
> will not fail due to allocation. Any necessary checks are performed before
> the point of no return.
> 
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Sean Christoperson <seanjc@google.com>
> Signed-off-by: Sean Christoperson <seanjc@google.com>

s/Christoperson /Christopherson

> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  include/uapi/linux/kvm.h |  13 ++++++
>  virt/kvm/Kconfig         |   1 +
>  virt/kvm/guest_memfd.c   | 116 +++++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      |  12 +++++
>  4 files changed, 142 insertions(+)
> 
>

[...]

> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 297e4399fbd49..cfa2c78ba5fb9 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -102,6 +102,7 @@ config KVM_MMU_LOCKLESS_AGING
>  
>  config KVM_GUEST_MEMFD
>         select XARRAY_MULTI
> +       select KVM_MEMORY_ATTRIBUTES

What's this?
This config is gone.

>         bool
>  

