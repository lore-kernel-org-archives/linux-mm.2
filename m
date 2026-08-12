Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C161CC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B155F6B00BE; Wed, 12 Aug 2026 04:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5726B00BF; Wed, 12 Aug 2026 04:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B65A6B00C0; Wed, 12 Aug 2026 04:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79BAB6B00BE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:16:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0CD611A0339
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:16:48 +0000 (UTC)
X-FDA: 85091911296.06.95B9C8F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1B3AE1A000D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:16:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=di0bMehT;
	spf=pass (imf19.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786522606;
	b=bviBWGApzHCwqlR09PscTETMtWCgPmpY6aS1gZk2WWOKSiZalxWTJcks+9GHkwhN/BhwdP
	+m87AU3DQeI+eEnrl/gHdEbPV0Kk4xyqjXlTd7JWjFqnOE1b7+/YYMhYj65z3bvKY0p6kk
	m6Kd7KzCUX33l/nE2lpSrVyyCm5IugQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=di0bMehT;
	spf=pass (imf19.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786522606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNZ2txdKQ/GmdIKsLrIjH36//ButieQhWIQNdUJQQ/c=;
	b=11HmUbKeSH8+3R37vp3G9ydQJfIR7SJc2xuw+cJtEknRUQ+49hvPLp+27pP0zJPsOeQSNk
	9QFo5vTAeqUIn6D9mbiKFoqmnMDx+G30Qd5vh1qCpydCQwSuKfIazKTBHRyxk9LeHPFhD7
	rjR4jJcICoFtEYVt3aHHlYrBbpOM8IQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786522605; x=1818058605;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JSuQnVhQTnRB2r+8uupOQXcxSlYbUTdL6DRqoze9JUU=;
  b=di0bMehTrEAfb5QKDN3ebOlWLemI1arSukF+GVOJ9LZP17o2cR5AiQZx
   uWeZ6tDjUHF7gfPf12+VqOh4BSMDkRzmcdsfbWiMYgAvsM7PnOpRZeqqZ
   xFaJJ/zYxBrN3Xd9HaewrPg62sHoAlwTsnjheSjQ9nBKr77JNwCDTZGr9
   JxDvUH+5MAmBQvIKKTDXsgYFEqDyFHOuV2dUqnb4DifudZZ3T8m3XKx2U
   o1c6AeUx54js6Z7A2Ntc9P9wKbMz2ySUFZFiZbvsJqtxLIUKw20zGiY4b
   97DZ7aGmxSAClFIlgo/My/sQfE5lx3bghVE1aZSG/vMmxrGrzmY3E+yxZ
   w==;
X-CSE-ConnectionGUID: KQjDlDvyTk6XiNrlgeEdXA==
X-CSE-MsgGUID: 7z54jXXTTO6GpJDpfheAdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="97414142"
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="97414142"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 01:16:43 -0700
X-CSE-ConnectionGUID: BL1IvoWBSoi/4zQSJDcW7A==
X-CSE-MsgGUID: BLvW57sVSIqi8lRVaUvP2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="257378842"
Received: from unknown (HELO [10.238.208.98]) ([10.238.208.98])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 01:16:30 -0700
Message-ID: <84ad91f5-1006-410b-94a4-01e7dcc6fcbd@intel.com>
Date: Wed, 12 Aug 2026 16:16:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 01/41] KVM: guest_memfd: Use kvm_mem_is_private() when
 populating guest_memfd memory
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-1-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-1-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1B3AE1A000D
X-Rspam-User: 
X-Stat-Signature: o8ck9iysctfpjaiqf6zaczi8utjn3g1p
X-Rspamd-Server: rspam06
X-HE-Tag: 1786522604-209321
X-HE-Meta: U2FsdGVkX186M/4Xggom6MxVCfPW/ZGVDmQt5OKuHkoi7okxk//PcqSIHUH4aXnPJEdhz2H6VVEn6lHLXgWZElwjahDFCUaw364FCYiTs1YOK5OJvPTlp8ozyYAQqOju8LVCY7BJxJg74AVBzc5SiyXQ6XTRsKqbWqqoPbji4yaPU4efTjE3b2jp1otrPajUlzfZUiFrmXjnjHtyguOIvsuN8NWuKJ/uKYW9VIEPKrtFEiyQy/IjUGUDkq5Fve9WzlFs3M5G1PHZMJ2u5nl1090z1/h65A74RmDpUoOks46zudg31hc//FHkYALU3z2u5TPZ6nI1kyGbeH0phzdt9HuoDcnxfADONa3Y6lTRrRIizgMhlRGr4cZtrJXc5eJVpcDw/N/CjYrQmEx46FkojQ3HnZ7el7KmmU5XmRKp2BfsbZ5dyd/1cev3rXoz3YaY5c9CQunZwpTKjljfeRWG+nEFhjOdoOVdbUTNqYfm9M7wdNhgUSjeyf2A5XHT08p2bRzRuySQ+aVVHAtSzSygfw/EV8KS1NU5wHyQkROFh6yD9Gi6a5YdzN87vIq0XRQp82voUgxohUDvVexeWjkbXhqVWx9tAZ+ynQcmNWqA8bREswJMKJ99Iedu4jRh+akWz5lCY/j44PUPXjesBm4+Hv0X0W8amDoQ8HiqIC4jsfAQdjbL8NkQ3g0qGi+4pQ6aqwXH3EQmOQbdXZxR5prv+WPiB7JPl4UDEvnWI0aCbiHYA/3QGZ/nPAF5stxnCAmntN8f5DTlfQd/Pz2lgxegQhtdaiqiUF8cIEXh/YM6n+0xiWjBktkxuZL7OuUfgmG35Qz+XVmfEKVaPzFgjSEF3umdLmoeh7J6vfZSWx5pme9o27CGSqnZk+SQ3ycVQ+NdE5HGev1ruPhQwzsGZTaPLj6ICNI83qVKQ13XUbpA8rI8RDB5ha8nfyOvV3LiuRlbAWdQsSgEdS6dmB4m/f1
 PMyG83c6
 MFwAHRcG41wuD98V1HWAyma9GnA0cZ1WcWL5ciyI5+TktqvEePMJM/Se5T0aswgWJ+BNaJ/DQOcmLER1IGC+BhQc1vj6+GbwhXzVMn8Dp9CvsCPB9DsjZEAdFuuZSgHjhGbiS9CoVBeyxIybL1vZI7YyO1pTWY2R5/M2FM4X+OBAT6Tk+AwbNJJlbjuJh2n2JftfcZh6KCTgLwfkMlASXQ4H4zXZqMppXa+CQmMEbuGXa58e9ki43laSzhINt/wePfWGoMPgLLjROxFTiugm2xMMmgCJfnpMqmzZFH51pCbuur2M+AUN60f2JRHLZcz3p/4xmrYqufCax2PwnTLrw6dOl2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Using kvm_mem_is_private() when populating guest_memfd instead of using an
> open coded equivalent.  In addition to simplifying the populate code *now*,
> this avoids the need to provide a range-based gmem lookup API in the future
> as well.
> 
> No functional change intended.
> 
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   virt/kvm/guest_memfd.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b596486d184ca..a11cf6dc785da 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -811,9 +811,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>   
>   	folio_unlock(folio);
>   
> -	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> -					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
> -					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> +	if (!kvm_mem_is_private(kvm, gfn)) {
>   		ret = -EINVAL;
>   		goto out_put_folio;
>   	}
> 


