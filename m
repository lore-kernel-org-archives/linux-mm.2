Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 915ADC55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 08:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC746B009E; Fri, 31 Jul 2026 04:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3B46B00A0; Fri, 31 Jul 2026 04:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3A46B00A2; Fri, 31 Jul 2026 04:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 558DC6B009E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:50:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE174C0377
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:50:32 +0000 (UTC)
X-FDA: 85048450704.26.78105DC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6343F4000D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:50:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NCP0riZe;
	spf=pass (imf17.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785487830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+69VZMVbl/yQVs0GjfqzyTWaZgP4D89e5cRDhKv0i5Q=;
	b=BO3plT+DTVZcDtTxJN9+g+nxjP20JmueKt8Y+liLjq8syqom4jXOBcCdyrw2q1DmJVxHwn
	uzUVY3H/5WUMzHxHEpuvDwCyNxZL+oe6N+tJYGTHXIDsvQ5N6hUdXVN53xj2xHm4Pff4c4
	mxywJVNIpBdkeyrec7BNYy/ymhqOFtY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785487830;
	b=p668oel0RF49imImC7/acwIPJO3vJuccNaCNX/eGr64hJ7Ww8Lc11iYGtaUFPuTe9j7E+g
	Lv4gl1e0eV6ULZhv2eMl74x4/jpMNBBN6vSTQdAAfuGTDf4IcJtLKW+zJlc+VOZIvFNbbB
	O3ot+0PpxuTxU0J6CczmETTwmlFt2Hw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NCP0riZe;
	spf=pass (imf17.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785487831; x=1817023831;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Vv/Cn/5d+0Kxx85L2VsjAbjj1pHoGsVQxFQjE4JSdWI=;
  b=NCP0riZewqxgW3ic/LErKLz07cfQn+Rux3lyXUU+Jrb5j0PjE4ezW0Cl
   oWEWddQo81WD19uc0sf9SBFHvaGkuqJSeKnC/VRNP71tyxeXmy9yM7kcW
   QamnZXTb9Da9ZLiATwor77vYuDP6vASgV2i4joR0/abcdKLMM0c3ywJVp
   F8N/eisXkqG/dvPAiQfmw4AcLz1NZZDTEP6UMy71ZH982GDkyYkMJ+9x9
   O095T6yUfnWsbmzgCfud4HGJl6CuIb9XL37fqDMqo9qV9hSme0zLbcrHW
   zva53UVeLtAb8ejo92fTL++4qFpJSkDNOTFgGvVJbsbC3B45d/fzlUVF2
   A==;
X-CSE-ConnectionGUID: 1YY4nF+sTA6BeFyNgsYDMQ==
X-CSE-MsgGUID: wUPQhFHmTi2rpOFBuuFjbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="86063057"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="86063057"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 01:50:17 -0700
X-CSE-ConnectionGUID: A4HFO+S5Tmuuqd/nni8mzQ==
X-CSE-MsgGUID: Rw54lWB3T+uC2VIA7y6DHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="262491702"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.248]) ([10.124.240.248])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 01:49:57 -0700
Message-ID: <9ef8179d-f79d-429c-b841-d23c1e0a0bff@intel.com>
Date: Fri, 31 Jul 2026 16:49:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 16/41] KVM: guest_memfd: Zero page while getting pfn
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-16-35f9aec2aed2@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-16-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6343F4000D
X-Stat-Signature: bhgcmu7ixb1qnwnswmppj9ku74nejo7y
X-HE-Tag: 1785487830-252039
X-HE-Meta: U2FsdGVkX18xr3w/mET6yyASpp1VXwOE4yf7LtW1H4Y8xBBn1RYdQc5nPxyI/4tOo/axTMzWygXtTA/GAmacoVbOMQ1werQpmHidbtyVPlW/IR/hDyKEkMyiRK9uf0/1z3X3RC484nYDMCqq256BEttYFeMwXNvckK1VCpp4s6feOPAHzuZR40gdFK4W2wBK+Cb1zdXYJ3G2Pv8088vGKzkV99s5VWTpfqQ6hFeTBWHBjxJ3pIO4fpIDkcdr5mQ1KiYkduaFPrgks7hFKBQlHCG0HyUo2Yvvq4036hHm5YAfpEod1727iizwD7pzbC0IwFPuzdeVJUfgTgYsCacMQBqxn3nS8ckaKjdQwvYJ3AumOPuqtJDPtNfQuSuwL9uK2HBlZa1hMp6xpcMVx094JAjNVBB3kQi/dKfL8YAdFmAQk4b3mD/EESXKaTa7ZHXfx6awJgf5XQxpYd3evKAiS7VjOhF+w4UB4gh27AGzm+Np6qHpe4XkHRUzlyEVR6b53afAsY5RbOx2cgIVJ8WSDPEakeuRbumMOdK1Bi7WU9uk9ajnlsNM3Hf81wPKQyNW5z4uxlc3YOAvZsZmzGVCbcxzzLABsTyQFQCc31kk9jCKHYR1GM4nYnae0N5S+z+lvo+mI3bzrRW7qgJEr4Y0j0QNC85z7OTdS3DuhiyUKEnpIei+ARWdMBtvijkP3sRhjLFkvHxylpTrCimNVP3uEiaIWYWEYg5iZIqNqRATYeZVOeA0NVt67DqEOBV/KplxY27Rvm4gUhhSu7SOZJWxEjv98T3oKdOx463X/024tIhzNmQWYqejLopy/GhcQyr0pxHP3JkjEQdij/bl3ek4O6xSPFt8y21+rfpQ5hJLvl4S+8UbCCnWXe9NZmEAyU8zWrh9zjR64Yr+BRPL3q5JKnRHfVEQS0UZAxPsZiDAlRh2TQzhu+FRhya4DpIqYhEEOHXPxQUWwbtAAJK5Hmy
 KbnGzM6B
 HLoTIppFE+kHXNROfVB2Kqtd63cf9qBE9kqU0YISyaBg1CSJEQ3ECXsbh5dVIozxAlydzX53gpZG0coAIPa1A0H/0I2j8iC6zu9oXQEj+Ywb34mrDhITzWDmjA1YIf7Fky/8EZS41TPnRhj+FMExBViYKq87TV7CC1gvzjh0228mK4c0Hx0WVrTMOowVjFan/+bm8rxQO+8MCYPUnQTiKsEil2lT+WQE9KzeKCD/nv9AeF68iEftgqdFQmu9uCfWYqv8a0XjOjeGpkDx8grdXnxxhrnSF1UUN1YZ24Kw4k9Q80qbWNnhXIyIxqPTROAupfvpD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
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
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   virt/kvm/guest_memfd.c | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 505bb6747620b..ea2752989f8bd 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -1078,6 +1078,11 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>   		return ERR_PTR(-EHWPOISON);
>   	}
>   
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		folio_mark_uptodate(folio);
> +	}
> +
>   	*pfn = folio_file_pfn(folio, index);
>   	if (max_order)
>   		*max_order = 0;
> @@ -1107,11 +1112,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   		goto out;
>   	}
>   
> -	if (!folio_test_uptodate(folio)) {
> -		clear_highpage(folio_page(folio, 0));
> -		folio_mark_uptodate(folio);
> -	}
> -
>   #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
>   	if (kvm_gmem_is_private_mem(file_inode(file), index))
>   		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
> @@ -1171,8 +1171,6 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>   	}
>   
>   	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
> -	if (!ret)
> -		folio_mark_uptodate(folio);
>   
>   out_put_folio:
>   	folio_put(folio);
> 


