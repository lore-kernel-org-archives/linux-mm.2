Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD98EC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 08:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643A26B007B; Mon, 10 Aug 2026 04:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4876B008A; Mon, 10 Aug 2026 04:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495356B008C; Mon, 10 Aug 2026 04:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 142BC6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:35:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 846D5C06BA
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:35:27 +0000 (UTC)
X-FDA: 85084700694.05.F1961E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id B952640010
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:35:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TQmWaY/e";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786350925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2FLsoZ1hEB5Du7Ei8cxJVdd7PKne1YvDU/GLmcRPOo=;
	b=Fk62hz4X+37QzqxtQHYWehXG+g6unoZGZM8FV0uSENOE2jRPpOE8sg2OfOh6lqASMOnymZ
	cdTgGR9bFm3GrLyTFrfH+N2j9BsYvWf0TTV4w/Go/LMyHYtC1F/L0LoFZ0iFa5KmNIy1gB
	AO3aOfTrhRN1YmVtW8MxUwCa6Yfvy78=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TQmWaY/e";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786350925;
	b=MGuiA2RelEDggumaFcnexQNsYiJCwMk/kA/YwxAjCNrGMqhOdt3d7yWGrmDaXuNsDR1Zk5
	11LHJ+hPtJN14XPG2JcclP11PgkeT1oPSRe3yaK+Qpi87tkUnw3BD4OSrW5cAE+tc1eArk
	Fwzx/6oOlxETIbpERjJl+xtT4ykUUS8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 404A960052;
	Mon, 10 Aug 2026 08:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901641F000E9;
	Mon, 10 Aug 2026 08:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786350925;
	bh=Y2FLsoZ1hEB5Du7Ei8cxJVdd7PKne1YvDU/GLmcRPOo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TQmWaY/eJ/3bBk6gG8TZU/y84g0uAlRWwjgXzO3uFjLziwWv6qtrOxq74w4RVQead
	 nFy1GVDQGRACN7JTwGwGV0fhqyZs6nw8zC/FE1OF1LI6hDDHqjPV6n386IOqpB6xJv
	 DJIFqitE6qS+ErJjdv0VfhVoURCZ01vn9tSqDk+BzfxmORZoiUHqsAcuMKTkLDBUM+
	 mK/qYI1NcTvDICGR11N7UctnrdUA34YJ2xIsiv37jMDFEPHxI1BQ0vXevu23qY/W5K
	 8ZIYKAw+Mn8yyAdDFIcbq8k2g4GmRWmtk9ebvuwD9PEupqgK9sCowzxWKA38MuueII
	 uw0AbLCKwziXg==
Message-ID: <98d6b8c9-4c61-41ea-8585-1bfdb3347b7d@kernel.org>
Date: Mon, 10 Aug 2026 10:35:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/41] KVM: guest_memfd: Introduce function to check
 GFN private/shared status
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
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-6-35f9aec2aed2@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260728-gmem-inplace-conversion-v9-6-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: i81nwm1hh1tzndga1yxj4zedztacr4en
X-Rspamd-Queue-Id: B952640010
X-HE-Tag: 1786350925-168911
X-HE-Meta: U2FsdGVkX18QHZ7XQgZ5EjvcFJshTJ6zG7eUZHvaYigdzzwkT9YOLo+Y0O9Y+hX3wvNvWZONIAKqhWSA+575L4fKFffAANF0AHl/2jpzlxvHr2zLN23ItazxpZON0dmyyPTVkua6t4mgQbADZOorDuzIj/lrpEmZNNtGTlHcwYjrNauwI2Pc0/d/oNDk8pbKJq+VwUpvKyv7JRHTGt/x78DUkEfeJ2CXtro0YMfwegGs5keOtmnuKqrwJECFXXhsCaCc1mQ/VYn6OMuNgw2ON2GeYeVkWAxTYWMXU74aZ744pvWQTtXvc1YBymQFycfia+e9JMb6i2N/JOD7F8zy6nnLkBMTFY/jNkwesYTrM6TUTb6h0SI4BTVVWfeMjFP6wi0JxL/cdq50E1HA9O7bTngcQpAx4QK/ZwaHj+3vVh0ArdtxBIXTKlt8lyEeNRNhz0tIDkL6VpwQcGzQRqb3Of7vksHamQTRsDo6f6TExzCGlAXtsGIdVF2KYhE3Yg8OdO8PeuwXpq0SqazFg45nmOOIe0MzT1zNldcHTXc9d60jHKE9rAf4b6na5TKbEahOCSRkM77KCoejNUGCsaYF0Gu8Z/01HpGsu93/MqGAHi0K7oVgEqdFNGCcnu2RCOeCKc4WCZPHp6d/3MEsnxftwVSV97AkOfSKIKG+KYM8oPkmigcgMAKikKjmGc8Z9yUP6Ld3PkqLLlpq9AuPWl4igys83T6i8zsXp6idmyykj79MfCKFyQ+CgPrnkJ/9R1TWAtJyYsUukL8JYZwxE37xnuJhuCWtRfa4fusEzyrwYVRQbe7AX1Z4nfvRuGGVhPsFCWB/U3yFHGAC/ME8hvrsbcetPWe1CK8pfZZ+YGIhGfYwRhSjsdIgNUd/h+Dlllc/4Q3A/jNVwIPsIIUc1NEAx62DejZlGGtGZo1oz/yoDJcn3Ga2t2JeuCa/hgpd7XXnVIOs9UYV31ghi3NoSky
 0ESkXjL8
 0FSiwQyvcGliAotuBI7ITS5GPd9w7rWatM421skJZFpYwB8fbkCvxO+oQ0kWM+qAgLLqxnkfalXAjq24pCiNE2x2til802Vsk0VdD63EB/tuElXsmb7ZiuRDNkMn9UT15zp7G7sXY86PFJJHhAFPuT4+zlFdOutWdFmpJkQAssrNz0GPO1Aw48iKSxHlk5P7V0rPqlSP1BpL977cGHWOlb+vqw4zcw6Ljhc196Q3vK9BdEBjVKfmvKDflS7ohYMAj9Blsk1+IwE7c7AR213E4QlTXG5Ut8/Or9xhO3Jdr4GlxO+Wihf/BneyINX6/L51x1YIxygnvmXA0/XQg/MxBuLGnw60HL0EOsQxJu6pQtd3aEpepBdlYjx5H+tweEt/fpOId
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 02:35, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Introduce a function for KVM to check the private/shared status of guest
> memory at a given GFN.
> 
> This will be used in a later patch.
> 
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  include/linux/kvm_host.h |  2 ++
>  virt/kvm/guest_memfd.c   | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 438567e3fa6a1..73f564b87a324 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2594,6 +2594,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  #endif /* kvm_arch_has_private_mem */
>  
>  #ifdef CONFIG_KVM_GUEST_MEMFD
> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
> +
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
>  		     int *max_order);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 8c7709a352cc7..33c9830190e2e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -474,6 +474,38 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>  	return 0;
>  }
>  
> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)

The function name makes is sound like we are testing whether a kvm_gmem instance
is private. The common code functions are

	kvm_mem_is_private

and

	kvm_vm_mem_is_private

So I would expect this here to be called

	kvm_gmem_mem_is_private


But then, it's confusing that there is

	kvm_gmem_is_private_mem()

already, which the new function calls. Maybe we have to indicate for the latter
that it works on the inode?

	kvm_gmem_inode_mem_is_private()

?

-- 
Cheers,

David

