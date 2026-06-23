Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26FCDCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 01:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB416B008A; Mon, 22 Jun 2026 21:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8BD16B0092; Mon, 22 Jun 2026 21:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54EB6B0093; Mon, 22 Jun 2026 21:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4766B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:22:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D561340340
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:22:49 +0000 (UTC)
X-FDA: 84909428058.26.CA29E17
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id 221D318000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:22:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E6U6cErH;
	spf=pass (imf16.hostedemail.com: domain of 35t85agYKCOUZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=35t85agYKCOUZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782177768;
	b=Hc+s9pmgOFn5KAceqNtMA7CaabW20KnIAnn/xljFhGN6X+eRLOx2AqGy+fuyNJNz96dww1
	YTcPrOBULp33DrcKrS65lUeI6ea1Qh1+Wp0CNOkuScKZX8XWbOwRNCsyUlCmGCvXbDV4O2
	vX1KMK5KZhHoc+cBV7WToMjZ9GVISpo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782177768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZV3uH/IPwxj9lEYe1ZUXoqPM2qjMTtjeMRmC3XTGao=;
	b=WGkWMjR6Glv8yOyCpBYHPSa4d0RUHLdqEpqxrPFQBxjaIWeIfghCFbfnIcVQsh1kjyZ2dk
	gAf0/LPJTilanHZjK/WBydPz1XeWZD2uLZAmCa1i5kUdCECyRLdJQHMh6VwSxo1QmVdjKq
	d9urusf4qAJomi/SSPMfk6Mdyt+xyuo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E6U6cErH;
	spf=pass (imf16.hostedemail.com: domain of 35t85agYKCOUZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=35t85agYKCOUZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c889d1eedcdso3414595a12.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782177767; x=1782782567; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QZV3uH/IPwxj9lEYe1ZUXoqPM2qjMTtjeMRmC3XTGao=;
        b=E6U6cErHe6NkcyBQOUxINaeHe+75tIYbLl9VE3ebK9tKTwZRuiSt8PMFJSikeanJ5R
         at+2BHX7Y7XDl8HqUfMzERGpwO3oC153a3IGC7MbO0IZRnCYUQL96GZDxQ4DUi6SXRVr
         Gv7bmMLjj63+8MZb8GGugVsBrQM3M1rHtWlC/I0HLJ3z8ZqHxWxMcnHJg0CeUNgCI7iz
         n86FquveXnOpBidxSrTwMbJZhcpoxUtA3BVswBREfjAeLtSOKDVfYqVnwU9vvTbj3I1Z
         rPABrxQxKVI7NInZY839EJKvuxifut1aXTfCytcN2I96bndLuMwXsNctZzL3KpS16LUM
         zTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782177767; x=1782782567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QZV3uH/IPwxj9lEYe1ZUXoqPM2qjMTtjeMRmC3XTGao=;
        b=JBd7+aUF2cV7tGcjNpQ4wLtDy3FNKG1s2G478326+DIqJlyD3oELLJLhZxcxSXvwp5
         qxoTA948VaYQZyCJW1iplHeTqZGTuqyvkB7r/JgvsXXqSA/Nc7F3FyHO5lji9ZQZ1CHw
         7sAlGxa8UQIRVmLkibTt61bfdJH+GGYhUzOj1Z7CJr2z93vmzj9iJbYtaBI1gPzVUunr
         CP8LzhwQa7eT3jyjG7TJWovLYC2LTK2PCkxv1klEPeYyskTO9Jva6HwCdm3BI8SY9Cxo
         3qM/gnhVYYiKTJwzT5txsTTJXdAXA4/Wr6lmDkem7fF8UzFagwLoHBppvTWQjT10qP8a
         JSDg==
X-Forwarded-Encrypted: i=1; AFNElJ+P7lnYGEck6cPXiZVfNs9IaB4BQtVg5eAAgaTanTw6AigsS4dvsNHb0n7+w4/8m5wrsGU2WCVsow==@kvack.org
X-Gm-Message-State: AOJu0YwKDfp5/FTymxS7ZXytvMbGKdQgugBygRjWdtf05ShnvfjOPoEf
	+g2voNSowCdcUn2zrK5uwZncIXDv6G0pRX9NrrHX3Z3ZjACwRVh2zHJkyqfbBz12dApsGzCyK6V
	fLw3Z7A==
X-Received: from pgbck12.prod.google.com ([2002:a05:6a02:90c:b0:c8a:b173:5516])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d045:b0:3b4:904f:c9cd
 with SMTP id adf61e73a8af0-3bc5181907emr14837899637.6.1782177766311; Mon, 22
 Jun 2026 18:22:46 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:22:45 -0700
In-Reply-To: <ajjc0hw8PjGw69e9@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com> <ajjc0hw8PjGw69e9@yzhao56-desk.sh.intel.com>
Message-ID: <ajnf5Z9nWZxoLS4x@google.com>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: pn9ebwjkmquwd6a874q7uajdhwt4wg9m
X-Rspamd-Queue-Id: 221D318000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782177767-8677
X-HE-Meta: U2FsdGVkX1/H3snACOtWN6NIk1wyayl3xqRWdb+Bes1IuCUtC5u92PBlcU6lnsWTKwqc1fKzudwqzkZMpqckwuay75vM9m6MMrADWA+e6M3fK0bHbAvWW25pF7XXc1+73kPbFcdi3Ds571BnBUr0EPPpbDN0nmeE88J5lWTBSFTJrcjbrv5YYD21OYY5boR4bgu/kBUErIMuLGAr+a9W25XyKRXxjAB1A6gMVUpwlfWaAUklhLIP7jwNtJ0OU4JGQfBv2fNNDwXOWxoOsFxRC0w3Uu13k0MCx+ARTM2hb+CW/quClgVx3deFFyCJWZRgFLyulSbQb/aK8jGA9NccBpdkTxjvj5n+chPDwTez2blxAy+7s9m+GkmKSKtMoDznqPPz10RTh6Z+b0Gs72PrHa+1HgIDZrus7lsVJcg8W3tusuMGJti27/DhmCsuPN9PBuDLz52wIAw3S6+euPfJZqP2dx6ol78l0THK8xnD+qcAETZhrAFfpeR6C97ZGzSMTq9aCscSPSlFM5pKuBnCOTr7oFQoUXkiWJuPZYIwwP2l6GEWye2LicuQIpm16HksGY+CGdP+SIzx6P5RNYGALh2V7wiFnTlj2tOEiqdZCo+eo1tZza4f4qJ8kbHmZIyXuWPPxDWgPepDsZpy5Sqdbl78n2iZgviqJ/OyVMqAFCRtr1Fi2CCoB4L3O3eG5bc/ZF5qQiNS5c0s4R3D4GJGeHTULYnySY2vENAFQEvoUffV2mC9gGS45ZnpGJRW1Tb4XDXn2fSNtXqDyerAyC5ioS5NCVzKoQrFOI10YhGL2Egh/ji+7nvUM7fAGXgyw0GWF+D/S5jvWrvN6aGtjCgYCcW75XVjidIE14XLfwh2AezFl5T52w14WRDuFcuPRfmL2U+S/SkxglGWfIqADXFLcdJhkk0aBsxMjIC9ZsLWbHehSl99nl7QR861oazB98aKvjx+1cV0QdAN22UqIv6
 LVRHgrIA
 OFu9yqdnSLZfXoHpSbeGFEPTSx3ODNnPadr2uu8JIORXl7KpGW5z04URfgM52bBEiRUThRZMgiFrhgHtgO/fbGdPIQjee5b2yvl/aysrLO9btX8EW+qW6xLoe8eG+HkRa8PaEAu5PKgASY8dMmmD60CKSAEQnm4Es5UhqwYxXdccJTUPWTECRqNtFIRjjgx08AWr5wpOp+vX1EWz1P1hiBp0W9hFJ9xJcYaFRtIYkehKBDHnpONm+V0G5TR32bNq7K6dGLesan6xKQt8QBwAG8aomZOqKCQyQe39/IIM77AormN8lhrodmL2UP8//u83f/laihsrU036qN2wlRAAj9BUFA8Gvct5H3Ftcr5f/xWjvEOp7zRiqKzaN3o0Abc7G0Qef9tCAQMtEZDQDS1eSDlh2HAOAhGLR+zeFp/FF8HYpn4XhQJM5V0Dg21A/PE2WE9CZj6wT3WcgyohZkrFwPUrRwj1CDnGZ2YLkmnJ/HyeS4S+tuR1dMv/Lvb6PI/MU7h5Sv4AZwlEO4LfsLd24Yw+5Nd4EDDjAI6E3Ntna9RXlBcVayGpZYMKoC2Ay3V4ryO1ZeL9mIEVlQYgBo2bKp0UgOvVuXss/gjjGIBjlhpvzCAPdZ/jgtJKdHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026, Yan Zhao wrote:
> On Thu, Jun 18, 2026 at 05:32:00PM -0700, Ackerley Tng via B4 Relay wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> > 
> > Update tdx_gmem_post_populate() to handle cases where a source page is
> > not explicitly provided. Instead of returning -EOPNOTSUPP when src_page
> > is NULL, default to using the page associated with the destination PFN.
> > 
> > This change allows for in-place memory conversion where the data is
> > already present in the target PFN, ensuring the TDX module has a valid
> > source page reference for the TDH.MEM.PAGE.ADD operation.
> > 
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  Documentation/virt/kvm/x86/intel-tdx.rst |  4 ++++
> >  arch/x86/kvm/vmx/tdx.c                   | 11 ++++++++---
> >  2 files changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> > index 6a222e9d09541..74357fe87f9ec 100644
> > --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> > +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> > @@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
> >  Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
> >  provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
> >  
> > +If guest_memfd in-place conversion is enabled, pass NULL for @source_addr to
> > +initialize the memory region using memory contents already populated in
> > +guest_memfd memory.
> > +
> >  Note, before calling this sub command, memory attribute of the range
> >  [gpa, gpa + nr_pages] needs to be private.  Userspace can use
> >  KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index ffe9d0db58c59..56d10333c61a7 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -3198,8 +3198,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
> >  		return -EIO;
> >  
> > -	if (!src_page)
> > -		return -EOPNOTSUPP;
> > +	if (!src_page) {
> > +		if (!gmem_in_place_conversion)
> When userspace turns on gmem_in_place_conversion while creating guest_memfd
> without the MMAP flag, the absence of src_page should still be treated as an
> error.

Why MMAP?  Shouldn't this be a general "if (!src_page && !up-to-date)"?  Just
because userspace _can_ mmap() the memory doesn't mean userspace _has_ mmap()'d
and written memory.  And when write() lands, MMAP wouldn't be necessary to
initialize the memory.

> Additionally, to properly enable in-place copying for the TDX initial memory
> region, userspace must not only specify source_addr to NULL, but also follow
> a specific sequence (where steps 1/2/3/7 are required only for in-place copy):
> 1. create guest_memfd with MMAP flag
> 2. mmap the guest_memfd.
> 3. convert the initial memory range to shared.
> 4. copy initial content to the source page.
> 5. convert the initial memory range to private
> 6. invoke ioctl KVM_TDX_INIT_MEM_REGION.
> 7. do not unmap the source backend.
> 
> So, would it be reasonable to introduce a dedicated flag that allows userspace
> to explicitly opt into the in-place copy functionality? e.g.,

Why?  It's userspace's responsibility to get the above right.  If userspace fails
to provide a src_page when it doesn't want in-place copy, that's a userspace bug.

