Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9224EC5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 06:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6693B6B01F3; Thu, 13 Aug 2026 02:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619D26B01F4; Thu, 13 Aug 2026 02:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507E96B01F5; Thu, 13 Aug 2026 02:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 268E76B01F3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:56:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20B93120568
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:56:33 +0000 (UTC)
X-FDA: 85095337866.16.1D40DBB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id 42E11100003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:56:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DcUSMufw;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786604190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPLdCsfwXGp3a90I2wrRqbAmnNC6HsQWAF04k5W9l48=;
	b=bOIZYtQJ8+U0Tv7Nww0hxZoBCt1wz/dhmEG4xjnYjJxkB4l+yxHBBgCh+AAJpmPmgjPno7
	3YNYCshT+ZdTZ1qZik6STyxUCS+zQiwRjf53/B2mF38Unctil3l/NODPqDppK19DwBnGpO
	0kpivt+YGNrQuN/mppvwiJNjCieOEx4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DcUSMufw;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786604190;
	b=iCDYN3mBiUDNzY0i3uGB6vYMKQvtnj0zpYYA7O3Ku1pC5d23+3sXT/rcJeRMtgdSgY+2bE
	PoU5eUSWvWpff4y0h9IXrPoINai5CAaFitWQhuH/XW04n4jNNHEU8s5gnznwepNFbdEKte
	QSjkRt/lyVhQu77BUuMqv9/Tow7IvKc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786604190; x=1818140190;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EiRUT7eibLcdH0tOQiOYhPqjIQxyxShzLvniKf9KyN0=;
  b=DcUSMufwNz+PqSYYqon6wSY5/VjfeChHGQXmwYoKYBh8Gq/gJ7yjtmBu
   Rv4sdZFiAz4zJSUdftQx8GwX1aqM/GDbvtgp8x4f+vf4pMLn2MQoGj6ng
   WzQtELWbFYyhH23sAENDUh8rbBMidu3fV61vuFCmqKsdG2OLrOKZ0EUSy
   R2HYLu3xF01GugRrqv/sW17Xg23h5lrNiJLY0L4WdeQx8rK2twPXv5WFg
   eKDFQXY0EnLBL3TrIFKQiZiX8Yl1xhVzLjMrtyLrapazUXwo2TXx5moZy
   R9U/KyitPKRoWuXYZevkGtx9g1TF0/zsF3GPmrz/FvD7Fwwa6vLnxyLaz
   A==;
X-CSE-ConnectionGUID: 3SVuVxa0RRq6MaBH2l7qFw==
X-CSE-MsgGUID: 9c5Mfuk9TD+POeHQgk8jzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11873"; a="86290021"
X-IronPort-AV: E=Sophos;i="6.25,220,1779174000"; 
   d="scan'208";a="86290021"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 23:56:28 -0700
X-CSE-ConnectionGUID: G3H/IDqNR/ShOWEVvKkhtw==
X-CSE-MsgGUID: hHyHwXdWQJSEvzpnZYeIQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,220,1779174000"; 
   d="scan'208";a="265841672"
Received: from unknown (HELO [10.238.2.33]) ([10.238.2.33])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 23:56:14 -0700
Message-ID: <1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com>
Date: Thu, 13 Aug 2026 14:56:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 12/41] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev,
 Fuad Tabba <fuad.tabba@linux.dev>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-12-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-12-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wbth3b8hee48xpsakmeo98ytipp15hma
X-Rspamd-Queue-Id: 42E11100003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786604190-244820
X-HE-Meta: U2FsdGVkX1+zqfIohF7eAl9RylpxbE+43sHNDnpZWj5Rz61nSZlnuVzLeFVCBkix8prLe7WUDMqyWmCkNIFIVet7wtVrBbrHs9lLAUeFDBEuL8K1EY8l7ap8G7QdQRzpjxVIol5HrfCc1ICgOgKxe4XKIS+rGN+V4H16KKUEiKYKVL2YpNG0100xXTlvD3lsQRoiUl7RALMsuunz4i1WNZcyL2VNJjy29AE3m3AMPnSzpzLfhftE5Cw+xYjCzxoD/Ln8UdPx++ChPVLPIxkBKfOowmzCE11It0D4wBfwu8cumTP+slYA0hLB40Ggw2anf3SLhucQN/y9TAmRRywD8PZIlbMkBVAO/6C5lQmYBMm9OCEF1jQk/7Kd/VQFkQWG3mCcZJRVTGaL1QLvK7TdCjuc8KxFxWdPUiqvugf4z6kJimet68uYbBJAxAbM7cuMow7GAxxtISN2hV2WpEOqGn2G6M8LQ5bqHJSW428bUWZPdIIV8aEineKuWj9hwzmebmBbNgC3m07IipQtcMwFKTy9QDpFSbQjbZUG3xzSaXkipE7u4VaIy/CuIL5bVX1LlGdfgGn7biA6bgUUAhUisik4RPEQ58B+ksx1NY3i2yr9L2JlXqnklqZLGeJyfXSb+nE5Ed905E5w1bBLdSKMHOjCYm7/3zXddsxCyG3rkRqWtDyz9ajc8U4VPCrHY+lIGzLFKVhG1KokRjsaPZxyxHr57CdURrF+x5oGT0QFHc5ttG/4DRDFkqFbRJ6SsHhaCycKBLdzhC35CYEngleghB4WTtiC44OtKZgYAvHOGRfmdI2ZiF9MXIefGSOZB+LNhwPAJvrAykjuMCfHc58YzWDI2Ivzt+lS2u1ESPFZhHbQeFmrL0OU8QAL0gFRjadWB71h9XdBptvo/p8etyoNkSFsM1sFk6oBHm1uxyY1TzikoVqyxNLYFSsgvi9clpWRvGcfZkwK9Iumx2C6cfv
 3677tpVv
 5xoxBIfxtl2OnYOJi4qxjP4xwQALpXdddnhpga8tDNWQzS/P3EyOdl0jLR5zoKFgX7Wbso6tnCtbUKjWwEqAJpokoneQw8KK1o1zqUnkCUisN3T1euILGQRGn744mVoK2XyoAd9DTlGtLbv8+i6PzvB4t1DNtXwjyudaOOaMBXsXE/TGkWi7QVBFTleUkyTtiZHSGcf2T8/a+HRi1/ES/KK1Uu0sPCdWWpjgwFK3xFvIVYpFPniYqqATs+f2FP9vg0OyoHi6UY/4O4FUpEBps8s2gQF/ZcSIcePiMWBmyi/ChRp2bC1yNMZXdjYJ4Vr1EE9K4lQNufBrnH4F4icbcbLIT7kZSmsmHz57I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> When memory in guest_memfd is converted from private to shared, the
> platform-specific state associated with the guest-private pages must be
> invalidated or cleaned up.
> 
> Iterate over the folios in the affected range and call the
> kvm_arch_gmem_make_shared() hook for each PFN range. This allows
> architectures to update hardware metadata or encryption states to
> transition pages to the shared state.
> 
> Invoke this helper after indicating to KVM's mmu code that an invalidation
> is in progress to stop in-flight page faults from succeeding.
> 
> Omit support for calling the arch hook to make private, since SNP, the only
> implementer of the arch make-private hook today, would actually prefer
> making private only just before faulting memory into the NPTs.
> 
> Calling the make-private arch hook would require iterating both bindings
> and the filemap to find the intersection of bindings and allocated
> folios. On top of that, SNP would need to figure out whether to actually
> make private based on whether the memory is about the be faulted, or
                                                     ^
the -> to?

> whether it is a conversion.
> 

[...]

>  
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
> +{
> +	struct folio_batch fbatch;
> +	pgoff_t next = start;
> +	int i;
> +
> +	folio_batch_init(&fbatch);
> +	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +			struct folio *folio = fbatch.folios[i];
> +			pgoff_t start_index, end_index;
> +			kvm_pfn_t start_pfn;
> +			kvm_pfn_t nr_pages;
> +
> +			start_index = max(start, folio->index);
> +			end_index = min(end, folio_next_index(folio));
> +			/*
> +			 * end_index is either in folio or points to
> +			 * the first page of the next folio. Hence,
> +			 * all pages in range [start_index, end_index)
> +			 * are contiguous.
> +			 */
> +			start_pfn = folio_file_pfn(folio, start_index);
> +			nr_pages = end_index - start_index;
> +
> +			kvm_arch_gmem_make_shared(start_pfn, nr_pages);
> +		}
> +
> +		folio_batch_release(&fbatch);
> +		cond_resched();
> +	}
> +}
> +#else
> +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) {}
> +#endif
> +
>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>  				     size_t nr_pages, uint64_t attrs,
>  				     pgoff_t *err_index)
> @@ -599,7 +636,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>  
>  	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
>  	kvm_gmem_invalidate_start(inode, start, end, filter);
> +
> +	if (!to_private)
> +		kvm_gmem_make_shared(inode, start, end);

If both KVM_AMD_SEV and KVM_INTEL_TDX are enabled, HAVE_KVM_ARCH_GMEM_CONVERT
will be enabled and the logic in kvm_gmem_make_shared() introduces unnecessary
overhead for TDX.
Not sure about CSPs, but in a standard distribution kernel, it's very likely
that both are enabled, right？ Should kvm_gmem_make_shared() do some
optimization or the overhead is relative small in the conversion to shared
path so that the optimization is not worth it? 


> +
>  	mas_store_prealloc(&mas, xa_mk_value(attrs));
> +
>  	kvm_gmem_invalidate_end(inode, start, end);
>  out:
>  	filemap_invalidate_unlock(mapping);
> 


