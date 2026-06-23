Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC1B5CD98F0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 05:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C316B0088; Tue, 23 Jun 2026 01:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663D46B008A; Tue, 23 Jun 2026 01:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1F76B008C; Tue, 23 Jun 2026 01:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 312326B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:25:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A57F403AB
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:25:44 +0000 (UTC)
X-FDA: 84910040208.17.CC9C6EF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf04.hostedemail.com (Postfix) with ESMTP id 06B7940004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:25:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GY2qYVPz;
	spf=pass (imf04.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782192342;
	b=3AzZIAhEdoVBvq0sxa7usvTDVm47G8JXq0bHrWI0xaKNflyVyiJRZhssrk2TRJzum0bj1l
	eKGZNR+WdH3EW255DNiNCWoHINTjDxSpxSxEiBnfFYkDJH1WARiBna1Rjp/XAwa9YmK5gV
	M0TogIq5y5Ej9MlXm9VSh4jMGezKyYM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782192342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=az9AnmbU0tfo9WkNcNBFtwgFqkgPKplErKcM1gOmM8Y=;
	b=d3if2a7Ev86eTyxuqK6X39FMuydYAaiQHBr0ibe6Dnpm9ebIxCaBLvpUrYchvJtL9r7pO7
	uFQjys2H9inbsfdkNxQxXVOqMDt4Jspki+4Q7BATMFZuo7OPemH/cVSWoUKc7YFDD7YfgT
	6pzb7ao+6OwaH+RrLxow3hHAypiaS7Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GY2qYVPz;
	spf=pass (imf04.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782192342; x=1813728342;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Uq5PeCcyAK+bL5pMg1ybj6yxp4BAEe7DhiVVYVptiko=;
  b=GY2qYVPzYYjVugCv8vl7y/3OV4QgFLM8xxfXiQhmvUi43bTOLjNpIlhO
   Hf4NO762I6kh294RdIkKa+LyecSMTsDYNHCu55j2xrQci3tAWPirQi+67
   tXB8xK8FAK5UWd8H0aamBRx1H01YqgNM+SJ8TQilwy0Qo2RwortEGjAIZ
   P7Z28ek20C+Zhg7VMy+hhfVsgOCKcVD3H69lAC5Ty5lm7XSvSIvi3dQnk
   LYQp8KaRGKF/yg/vFIB8OZX180RM+x1V3NI8GnxJzml+sausXkrDD0AV0
   tCMwr2+tJeS74Om6OLFtMDfUOIN/ZywolCaoXoM5vCuCevZDLcFJQdGJX
   A==;
X-CSE-ConnectionGUID: li8TxzWDS9SXkK0cmyzxXw==
X-CSE-MsgGUID: OEACJAtNSqienhz4hSi4SA==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="86834042"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="86834042"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 22:25:40 -0700
X-CSE-ConnectionGUID: +QKs7F9+Ru2ErBNCyvGNzg==
X-CSE-MsgGUID: MlbtBeXQTPSGpda7Y/yfxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="245058541"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 22:25:26 -0700
Message-ID: <1b59fec2-a464-4429-8532-880394912af5@linux.intel.com>
Date: Tue, 23 Jun 2026 13:25:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/46] KVM: guest_memfd: Introduce function to check
 GFN private/shared status
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
 <20260618-gmem-inplace-conversion-v8-9-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-9-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 06B7940004
X-Stat-Signature: hw86k9kp7178qc1kd6o85ec119uu1hng
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782192341-273088
X-HE-Meta: U2FsdGVkX1+Xbmo0MKQjvheXBWixxqZ2P3REzl4c5hrO4SQcItrE/88JuSueN3oYy/9oOnmjUT1lfKge/w10zMkNKrNMOPshNpZDn+fHqsTqePPJ5cEKPKdlozaV2+3fa7yYFlqiddPgIHcbbfhQjNvAK0pr5nlQQ3pyDllCK1QGACLutHKAYhFYDeYGkyH/JNPz7a3o9xQnlmhZUP2o8gBOTykg+hLWLvZ05LMZy4UNNrv0t9nv2bWKqqob9wnTxtyDWrJAhQoC/M4hG4toSgPMj6EG8ayGnvUlOEh4aLSSyYUUgpcq8YcdB7iyxoSRv2ro+UNGi8RdfgHvgGy/K2zeG+jlNt5bH1EiziNCZm15u2FDt31i0UZJvm8PUiW2bNTMKhsmCOVxBVH0ydtfC+3qM3b11bCnO8YiLOFYfE/hVSHSv3LGC9Tpy2lVPICRf8X9WYL66NPFdcZvrq2t7jKJYL4or2KTOKX4TosKn/5HXb3CYOE5vqE+MsyFftCLWEPRaqs1xUMftanHLiGeo01vtkXN5EvilvM3LQ3gmSo9AiLUWKEb1/A4BwSA1G9fbhuTzLpGVkrC5Q0cQ52CEKhMaC12f9/f2v0nBaXFonTDjT7D9KxaXSUhzNlPTdrXAsQ6yXXfOxJ+cwiTY6C3VT58wdqLp9PStaqBhby1GoAr3JKzPWFqysNHiSxZQeMqY9y24ek6X4xdGkETfoqJFl3rb9uNIrlb35VaJUxogcw+vboeBsxjBniv9lzgC4xkZ6pDq1jMg4JQJ92TobQ8T7DOo1F7YM/sOXTyQa2QjTBao28qjg3qPcEz7Ov7i4RDW/JFKFVAf5ytsFCZpj0fMHlnnmc1MkWq06GwULc/nqP6ikdfpo05A6B644pDf7hPXGpdwZzScke8AXCBs8KWt0BITDoEzJ20SFH0PE1aI4Y+RDHSosnGI0ZadoOB+mNLvBAQGPiBrUf7Nj6tndn
 /DONvrVO
 og0i96o1yziI4OJtAF+lBEJkfmJhcISUyjQToemYQ9WyJS3aUVz9sEuaw4kUBqL7XCHz0RU50WQF8cqmJ5Uc5hkWAmC5pLfGRRoNgUXkcbuy0pLglyvmVixLfAYPnM+WcbfbKh5ZSyBvrRvgSuLrbVqReSw+IqtPvRZj9OSoKmIWGV15cI2eeeU2BhLImxSn/bPcW6jGQmIHfyUYvGFfZYIZb0rb4dsiMPq3SADWg9irn5FNw54ej+2n36l5I0UC8p7rL8nxI5YWGkraU2E/kEHeWfO2ffHf2+YjElHztzFzAPz+qDmyyOkdB20mH1Mzp+F4/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Introduce function for KVM to check the private/shared status of guest
           ^
Nit:       a
 > memory at a given GFN.
> 
> This will be used in a later patch.

[...]

>  
> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
> +{
> +	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> +	struct inode *inode;
> +
> +	/*
> +	 * If this gfn has no associated memslot, there's no chance of the gfn
> +	 * being backed by private memory, since guest_memfd must be used for
> +	 * private memory,

"guest_memfd must be used for private memory" is a bit confusing to me.


> and guest_memfd must be associated with some memslot.
> +	 */
> +	if (!slot)
> +		return 0;
> +
> +	CLASS(gmem_get_file, file)(slot);
> +	if (!file)
> +		return 0;
> +
> +	inode = file_inode(file);
> +
> +	/*
> +	 * Rely on the maple tree's internal RCU lock to ensure a
> +	 * stable result. This result can become stale as soon as the
> +	 * lock is dropped, so the caller _must_ still protect
> +	 * consumption of private vs. shared by checking
> +	 * mmu_invalidate_retry_gfn() under mmu_lock to serialize
> +	 * against ongoing attribute updates.
> +	 */
> +	return kvm_gmem_is_private_mem(inode, kvm_gmem_get_index(slot, gfn));
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
> +
>  static struct file_operations kvm_gmem_fops = {
>  	.mmap		= kvm_gmem_mmap,
>  	.open		= generic_file_open,
> 


