Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E84B5CD98F0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 04:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649E86B0088; Tue, 23 Jun 2026 00:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA9C6B008A; Tue, 23 Jun 2026 00:56:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5119A6B008C; Tue, 23 Jun 2026 00:56:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29FC36B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:56:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66AD6C1BD7
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:56:10 +0000 (UTC)
X-FDA: 84909965700.07.85B6931
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf02.hostedemail.com (Postfix) with ESMTP id 89F648000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:56:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JeLpdj0r;
	spf=pass (imf02.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782190568;
	b=tVrB2hbkrHYEIcdfjcq1RWsPekQDnwaHmMRSymQsiQO9UjggtyvhRJA1HtQQ8fI994MDNy
	tBVdd99pRzrGXrR4a8W60Zvvwncva3ye5pdJRlonvjbgnVvYo7mwHUn80uZ06E3Rp/nVbU
	IBeZy0uEw800yM/BqyBwdiLJkF7WNwg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782190568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCxgb9TBTAaOv44HyknQqoIQjeSMoMIu2T3NjWWWjFs=;
	b=4e/6vd5mYWaHZR3NHSG8+yq/93ZdMcLJnWLPdBA0MbyL6mjBd5QnKkJf+JhPocZcaOSj8H
	qcY4X0Xu45En/8CGLRJdDRey1Xv4qxqAopkRWPpFZ5IRMSlmWYkYhO/NxSrCbj3L32VoM3
	eAR/jGl5YcV240aI8/FrmAwt5SN242w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JeLpdj0r;
	spf=pass (imf02.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782190568; x=1813726568;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TLs0cQbV4zQ3otfUmbOc+g0UN+QoGh4qUf1p9MrAKU0=;
  b=JeLpdj0rOFVagdjx+OIcJ/AiF5pipug6g0rWPOzdkB3GNiIvY0qQx0y8
   bglNaMVzfjp77syCHsqpsimoa5kl3JzXn3NKukTcfCXNF6EXQeRLH3R5C
   RNN4jhuvkjqb6WJKQM0dRNtoEV0fuu4Ese98fcFSxFVQKxafrfIFnL62V
   +6Z0e8zQJUJvxaAd2eGlYdRNqQ+/Jx76riAHNmwp3aouKDMJ8+LF9Wrgx
   3rr1ZZ3ttpXlGDRPp+W867gKqI4zpp9j5Bsn4mV6lz3W+NYPW71azVJIc
   X5DaZvd4z/JxVJC45HM6t4QQtTvWMGkaVf81xal7rzsLj0r76p9P6qNKe
   A==;
X-CSE-ConnectionGUID: iJeXJE7zShqE5Ga+uC5oxg==
X-CSE-MsgGUID: P2Vnv4c+R/yZYzV1xUa7SQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="82696361"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="82696361"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 21:56:06 -0700
X-CSE-ConnectionGUID: 4Bxv4k3BSX6J0pVhhllv2Q==
X-CSE-MsgGUID: yXIM0ueyQAGYNRhCF5FN7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="248527637"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 21:55:52 -0700
Message-ID: <96fb369d-dbff-4ed6-b1f9-0ce63d7d4ed0@linux.intel.com>
Date: Tue, 23 Jun 2026 12:55:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/46] KVM: Rename memory attribute APIs to prepare for
 in-place gmem conversion
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
 <20260618-gmem-inplace-conversion-v8-7-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-7-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bgnqngjcww96roxo5n8kjznee5945gcn
X-Rspam-User: 
X-Rspamd-Queue-Id: 89F648000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1782190567-873636
X-HE-Meta: U2FsdGVkX18mMAVoT+7kYLt3yW0AbG6he2r3gqIkHZnWra5G+Z+840pvGbu3vql4A+Axd1oYSE5UXcWcN4WqUA3zHmR+bMxY4YblrBYX1F1dHpyqx3L5x4Of7aKTtPQRcT7FM+adK+gDXvleJJbAP0WPOfyKrb3OeadiDg/1HyN2jx6D4h+zJPdJvov9YyZJj1YbzoloOu26wjuFIyJZ+fdfBQ7VYcUlTGswpO8B5wxZRdshTaq2U97rqL5CwyvwHmyLvZs0pm0bhLshn9d+E90ap6K8s8gG62PwOi7Cbz7gF7/szmvKHv/z3gyG05ot69iBbIrxoDXc7j02g+r37abtVwMG5qSQqVz3uubwCbIEN1iGDE3/TvKhZvrNUpHX1o5I0mDFUvr4PHPZouUQQbGuMgk/Ompwz6MY1XaT+fT5sbseDiJCGieKsmH3Ht+hbRdTS8vJzdGmVVBWxsNxyE4IRjTDwbS4rBmG6/ra5b1mR1S5yCi1pHkelh01toUMZ1cKPFrSI+uNUw2jv0hVrPn9m2trj72GHKsVy4q49o7abNGnWjCrLbRLyAD5S5yFx1hCUQ64+2tlP8x7K5UJK3z6hCXy3P6lE+n95nFhNzLYpWlnOXSBJHt/9L9x17Ym/q2U0QpzsW6KJ5Gt7f/CFcoebKbTFWkYyqqeZqpsrQm/W61sMrGLuASL0Vf9X4rdt5oRBv2afADGOJs6dyeJf8SQGny7rmsOplXvEl+51DLG2v4LkT2CZkoH0AoG4JaB4KfvRVI39EOY19FLSA4x+p/egke5+vJA5WTJ+8Qc7QQeR97Bhy9s/oCqlj+PSzqTD4cGZ39DneFWHkDFblN3A4Q3rV3BH21mGLGdm8H5TynonfAQ9zr9w11ZIVjx1xS2Kcns5Yp4kZTU+wd6g3cJRyhVRpabVF6xU0buVdmNMGEUoI2hdg/xWjexotRM6IsHIREpTzLWyzvX3Lz8QqU
 BB6JMa4U
 IUEiBE+IJdhU01BMb4e0eZSxed2SQNePjBXbWLThEzu96Ju6xVPJReWP0/YltNbdXt1eMRoIUyXr8YVR2nbH3ypeBth5q31JaoL7L0lANsFNx2Wt7wcbt+s3nTaSKmJ3liTPFY63zRMhpDm1Tc5mfpXjOU8cF8JlrWI448dqeZNCU9ucqTGTDhYV2QE1lUX4K7qdoiED6xJcjT3C9Kqni1ibnEgfrjs/KECybUD1dItHfcDA//wJ1CvIc2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d370e834d619e..eb26d4ea8945a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2534,13 +2534,13 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
>  }
>  
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> -static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> +static inline unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
>  {
>  	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
>  }
>  
> -bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> -				     unsigned long mask, unsigned long attrs);
> +bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> +					unsigned long mask, unsigned long attrs);
>  bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>  					struct kvm_gfn_range *range);
>  bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> @@ -2548,7 +2548,14 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>  
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
> -	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +	return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +}
> +static inline bool kvm_mem_range_is_private(struct kvm *kvm, gfn_t start,
> +					    gfn_t end)
> +{
> +	return kvm_range_has_vm_memory_attributes(kvm, start, end,
> +						  KVM_MEMORY_ATTRIBUTE_PRIVATE,
> +						  KVM_MEMORY_ATTRIBUTE_PRIVATE);
>  }

This function is added, but never used in this patch series.
Is it intended to be called only when CONFIG_KVM_VM_MEMORY_ATTRIBUTES is
enabled?



>  #else
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)

