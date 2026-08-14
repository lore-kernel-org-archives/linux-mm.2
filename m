Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE4D0C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 05:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4566B0616; Fri, 14 Aug 2026 01:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664326B0617; Fri, 14 Aug 2026 01:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54EC56B0618; Fri, 14 Aug 2026 01:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA446B0616
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:18:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7386712034A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:18:38 +0000 (UTC)
X-FDA: 85098719916.26.1CC6954
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78F67C0002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:18:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fq9xTO1w;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786684716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nh/q1cVILIwClSOSvbH2tQ1Kqv8X4RdrCPcUQHn8eSQ=;
	b=JGyUGdX2EZZ/bl6vw0MtHJI7wlUTBBNFsgNrIR+SwljgTnjnjHskOxoHncUBq/WQ0jk1gV
	qID7Lz9xCK+Dxusg9ayBXO2/1XPiyUQZOlUzDxw4BMiBZqSoihZ76m3KOGakggTQJWpXbL
	rsh4DGCnefLinR7+lx7X57CAv+w/3n8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fq9xTO1w;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786684716;
	b=TsaIHkmZklOEOoQ2VvOyLNYoEt8fejtHbptsJfIjiZa5aG+DPiBIuCISL56chHxnTRHo1/
	Oll5s819Ux70/6rFgR4PrhPcp+p4yKa8Md+HR/Z5XDNZ2Nrt8xI6yXrZJnEWmz2F1K3AZx
	4FUk3xLWt24VsQcxhpQFz0R1muudccg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786684716; x=1818220716;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+MUxfRWOkqREAuoekA780+CfxxKTEqlm5E/NKiwihFE=;
  b=Fq9xTO1wCx35Me5CWZnvAlS89GF8MFIiJGoH3Z2f5OrsOzPFfnrjylTo
   ZWuB/sVjw2sL9XkPx8Er8cS6QBOLluXwh+RWDK0yZG4t6H5wzRcyhhDi8
   /LUxL+qvy1Se31i+47SBDqz3WUJFZMnc1ZgfDt1IcOleuruaJQxX0Zolr
   M15lVzggyhPltKXsTJg4xS+Dago3c1w9+DLSUorx3k22U0OumWE0oQxJV
   G/zYOPLG/ge6vJA32hC7SMM4/9lDDP0U3prP6V7ZLuQRu4+CTUm7fBu1V
   iyR3wHY9KhOOeoYbrbawXoBNp/O7DWZuXkjxcIXl4M70ydJtWlOUExiIp
   Q==;
X-CSE-ConnectionGUID: CBtRoOWfS0mkc+kZJV71pA==
X-CSE-MsgGUID: tIkHBGYXScmaJlCdm/6glg==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="87481117"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="87481117"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 22:18:34 -0700
X-CSE-ConnectionGUID: IN/b0L//SVCz/TGsloL3PQ==
X-CSE-MsgGUID: VWlRvfb+T1OqDKsfu60fhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="266117899"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.245.162]) ([10.124.245.162])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 22:18:20 -0700
Message-ID: <645af2bd-2791-473a-9441-40db01f58913@linux.intel.com>
Date: Fri, 14 Aug 2026 13:18:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 16/41] KVM: guest_memfd: Zero page while getting pfn
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
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-16-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-16-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 78F67C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: nmc9i7kjqpeaztxmx7goryckcda18gi7
X-HE-Tag: 1786684715-526985
X-HE-Meta: U2FsdGVkX1/hHQdxdKZInD26vWD4tmtCgyH7bihsfUJom1sBjirJrrG0S2i5LD+V4npFcld6nUukkIsMhfQgXBvPmbgBbt7s+88q5m25IIGlBxXR29sDoT0RELvn3TS1bE2g+32bbzlGA3T3w2Sg9RcT1pPbZF9P1zAtCvdOMYY7QoNDrXHwL8A/+Uk7ONuBNqu1fIavvcktYp/lHGaC+/EEW1gd+5HSQX3vHY0McvBp/OKL0D8tOh1on9DuZ0qxy20vzY5r3ukfj/6pSiwjE0ueaA5bNA12LRNvG9pDWu88K4LmYye63rHwtRKfsidUQNw+jAn2bmWSxYm8HRjn8RukKzzSG/YdUEwkPanhgJ+wLTkCKGBZh2JRuRUSHVf5H4z6ob3yCsLVsjVYuemTrG/1KvNWTAV5Ti5ATUUpVY8eXNDKk9nfIu8O4QeOxg0TLcxIS1gCQnZAYkO73PrECbMrB3RWiPIwLSKMVlih7Cg+Px9Gz9n1L49wHfZHN++iDPX3CB9/QsdtS3kmJauTOhA9bPSLeHVJhfV5tWjgqoUd1sdMyDaMUqkwZdgzzthiWKHrc1l/5bHSJUL/EVEnqhS07vJtqfQBB0JWbEQ7/fPp+EYVzPBt4Q7IygCiE1Nw9dV3sFDHQswm3yUHGsdGXMXOyBli/w5W9iL+hcTqBP6mxnGtCNP/F2Bi3ggw+UOIFxFWfPUceUyySzg3hKnRC8VnyNE0QfZvJsAJnMWevjBebwwqKweZPu0ZKZ7tKhlB6a3C17zrnUM4fcs0i99gzkF0/bbekaByRyN1tV4Uk6FPATAi7gqMZ7QdozwGeE5Ad5WpEXRFJ9aNsVtiQTubD8nKeuDWodGfJJIQceirEMlUSFsPO4cszdqF+RJtd1Jr6jTpUkh4+zCHGLz1lsR63p98B8DjDJchoXl04RCrHYVo7gZavFTZLgefUh7/5p+ueKlLzM5RkbiRIWYivKN
 z2eJFj7W
 QXxp1+7hD396lfh3Wc6yDqguaDh7c6dyP99VpjjFFwPipKzI+NxM7JbJMVeaX7KMhRQuYJ5X3wvNRBsI5wKJjBxXzCL9rA2j7LC4YvxtcyfdrplmzYs+tup4pBtc2bwth6rDbbCv/1lR2H5YGHR+EyAJoTp9UZ0SjxhXrPhwlLouN5NBcY36MCs1xGcvekBX89ZKYnBIY2zhkSCq9WCb37o46Sz3uPdQ26Qs1Ea3h2YLsN0BPBX+dG3I2nujTPpTWmJUmp9nj35T8Sjz98czhncqgD3n/Cfgoa5NEZWXd5QilprTlZd6LmICTnSNwzw9DA1n9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Move the folio initialization logic from kvm_gmem_get_pfn() into
> __kvm_gmem_get_pfn() to also zero pages if the page is to be used in
> kvm_gmem_populate().
> 
> With in-place conversion, the existing data in a guest_memfd page can be
> populated into guest memory through platform-specific ioctls.
> 
> Without first zeroing the page obtained using __kvm_gmem_get_pfn(), it
> might contain uninitialized host memory, which would leak to the guest if
> the populate completes.
> 
> guest_memfd pages are zeroed at most once in the page's entire lifetime
> with guest_memfd, and that is tracked using the uptodate flag.
> 
> Zeroing the page in __kvm_gmem_get_pfn() is chosen over zeroing in
> kvm_gmem_get_folio() since other flows, such as a future write() syscall,
> can get a page, write to the page and then set page uptodate without
> zeroing.
> 
> This aligns with the concept of zeroing before first use - the other place
> where zeroing happens is in kvm_gmem_fault_user_mapping().
> 
> Don't mark the page uptodate again after populating, since the page would
> already be marked uptodate before the post_populate() call.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>  virt/kvm/guest_memfd.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 030af0855f8b0..41950c8105b5d 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -1079,6 +1079,11 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  		return ERR_PTR(-EHWPOISON);
>  	}
>  
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		folio_mark_uptodate(folio);
> +	}
> +
>  	*pfn = folio_file_pfn(folio, index);
>  	if (max_order)
>  		*max_order = 0;
> @@ -1108,11 +1113,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		goto out;
>  	}
>  
> -	if (!folio_test_uptodate(folio)) {
> -		clear_highpage(folio_page(folio, 0));
> -		folio_mark_uptodate(folio);
> -	}
> -
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
>  	if (kvm_gmem_is_private_mem(file_inode(file), index))
>  		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
> @@ -1159,8 +1159,6 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	}
>  
>  	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
> -	if (!ret)
> -		folio_mark_uptodate(folio);
>  
>  out_put_folio:
>  	folio_put(folio);
> 


