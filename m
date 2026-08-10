Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E28A9C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B111A6B0092; Mon, 10 Aug 2026 05:30:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99FE6B0095; Mon, 10 Aug 2026 05:30:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C6E6B0096; Mon, 10 Aug 2026 05:30:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5721A6B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:30:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B79171606ED
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:30:52 +0000 (UTC)
X-FDA: 85084840344.15.D880B79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0972340006
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:30:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bohlnxP3;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786354251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2my6VqSN1Pi6OPxK0/5FmAellJIX3EJ4Czc065zjm4=;
	b=WuaNTd1mGbu6zuGqXXZAeupKsxKL20oRBy/yHLxYrlNDL1ohaLfwizzsox2g6LMU6jNBYM
	n2fw8fppuKkBQhtW6zsSBBfcBFtrWD333/hFuu2T/dxzUClgMaifUuEkaYkHI5iWtwlrl1
	sJirhAW1Bb+iVX6JEo9cXY/2kqGapIc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786354251;
	b=j71ABzmeXxVHfpicuS4PIkT+jyVcocTMBUQWt1xFXghaLNubZZBTDV+JWYYUAfPotvEmHn
	1Dby0EpgOOWYD4S/5yM+R/hiByWuP0ykmVK3hLFBNoHnoBMfQljGFfN5IgwS1iJF1bcvSd
	EeJ25YM8TslFW9G4wPXv+f3+VZKPVp8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bohlnxP3;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8617860A5C;
	Mon, 10 Aug 2026 09:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10BE1F000E9;
	Mon, 10 Aug 2026 09:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786354250;
	bh=l2my6VqSN1Pi6OPxK0/5FmAellJIX3EJ4Czc065zjm4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bohlnxP3jBpV1WhsLd9bskHbEHKnYQzLSBniquP2TI1eoX9xUZkhF6o4QCGeexn9I
	 eIcYh4ZZt9g5AoC91V4GVEDjgaiFPnNwuUPdyYGwgYOXOy25mXQv2j60thszqnLr8T
	 ecFbv0GHwaNwhLeQstEov/iTQWIdVq2h8eDuKRc4TlNUmKk2INXLZIZy0HB+1F3JWA
	 xzmccK5095T+EepC03FnWQCvmvzYl/VqbOakMLBMAuLFYP61issA2uA8g7TuNQoh1O
	 oXJl7l3BW5Eb4kwXsPNYzzBpHdF/RtbsGptzlyJ1kBQGQSEe493MF8azC9K8Nyt5in
	 svnE5Oj2krolQ==
Message-ID: <dd9ebd52-7171-4353-8c83-9363019d55b8@kernel.org>
Date: Mon, 10 Aug 2026 11:30:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 16/41] KVM: guest_memfd: Zero page while getting pfn
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
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
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-16-2fc18ee6d3ba@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260807-gmem-inplace-conversion-v10-16-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0972340006
X-Stat-Signature: x9bba4briedokcseu61uhs6s8nbdibnr
X-Rspam-User: 
X-HE-Tag: 1786354250-630941
X-HE-Meta: U2FsdGVkX19uvJgQeSfsf9Vy+toRl5etS+A2Q2OJ3GSlXhV7QqmXPP4xYk8jgRnLTqKcGIwZtTlA+kwGUC5Zobh8awfM6XEVFDTsnQcNazFmEE/PmzSuOnP9C1w1fcciVP291kwyYgSURwrfLKXtfahrJnUvRf2XUpRv+hjQFZWOfA7H8Qn0/VLz+pMEGmYtgkJ78MOnP5gs9lIVgMfwdq9Oqp62ECfL3tPTrNHQSkNK02vD69FKPawigFBm256ahLXkdsWn1sOFY4FQ4Qfn1eqO8Av6aKxZ2oBOJ4SpLVjVadblH+47TYUkQX0+N6FER7266N1qObaSrk4rp47Z0V4ushOxZ3xudZ2e6cEnuHeyNxjHlrQPdKrw5GhoYsLAf7Ow9lIKVHk+JtWeiO1vznYI+OUA9zZ6TdtYYGuFhs1rfbgc8ym8lrRfU3T0Gcp2JrSG41qLn849cFX81oggNinAIBiqrASIQgFlMaLRzaeCF3TQirnFghvYOhRIqh+WRlqknAtAZBn1+DzrvCcPzhbSsFcIsbuNXVBza2S6wvqsXfs59kklfsbLrqOEDQYQQBcMsqj894CrJM417ELahKEZbM3zeXyMSo6R2HDh1NuBpZYAXr3SHdYhaSu8Msy6VWerC3af4tusYMILVZN/1JDkVIaElLAhOANdQ0dFOVoGmw0TEQT0Eie/Hln38GdF0uXNS1reHiiVdKu0NgzscKFu1D5Y7yGc/s6mo1tzXx7aI21fQIbvKbn5IpIYE+aPwDFUHRA1JQjHD3znpSyQzxEr1zCyJJjnnVxjRKcXb3A+AfjY2JjW2BlVrgFEXovPZRJNpGaWr5LevB0yZUVVhGMgNiDV/H2o2bOSqH5GbiXE7SHAxlHGAp6VE5HDigWRtmpv2PY8BZuNczIWha/Lb21PfMjHNF+ap/vOG8g/anRoQ0SiIJX8TnDd3yQZ8eRfQ4lCND13i38ySXU6deo
 5WCFcs6T
 AltzPwnZoURvnUW8shKhlmRsVowELBEXaRnsfDciruZa+2YgxFN3TZcF8U2wtnRwnx9KylWOdV4X4PONIDirqKtGe1K52nUiiHLd2qXeywvQUf2QuNgib/qW9p3YFGih0HAtmab6vhGOQV0FMHmH+34MD46zxQZto9n2bBU/Wi6cRZfPUP0zjniG0krHev4M5P1snSBupYnSJr6KJFcM45UY507jei5CNN7H2tVc6CZjeRkv3wXrA3K3W7YqeZQs06yKM5mW4MRNsK7A34j96HhpiruP6ODla5RRlKQfodvgRgrua2Xn3JnM3f7nWB2Oz64PZedjD3p4xqwpAMa0cZhMTh/K+ob2X322es5QuxhDHmu6JWAemUcHXGUy99wi1RK8L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
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

The downside is that __kvm_gmem_populate() will now zero+write. I assume we
don't care about possible performance impacts?

Worth spelling that out.

> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
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

In case post-populate failed, do we want to re-zero the pages?

-- 
Cheers,

David

