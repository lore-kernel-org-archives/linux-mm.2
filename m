Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 167F6CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 13:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80E186B0005; Wed, 20 May 2026 09:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E59D6B0088; Wed, 20 May 2026 09:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB1C6B0095; Wed, 20 May 2026 09:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8116B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:52:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F3D81A0302
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:52:22 +0000 (UTC)
X-FDA: 84787937724.10.12906CE
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 22AB1C0008
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:52:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oQz6QIuH;
	spf=pass (imf28.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779285140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Worh2JLSPSAyI17eyly2xWvvXK0uXozd+nOzIiXznLs=;
	b=lwcsvBDVmKxjieqovRcyxHzYv3K+Ck8+0IiRVcmqBOjZrjElBcPzfUQ0Omlpb4pwsgfWk9
	ai+G4W6BYKBkUIPWNVDNx3ebL6jzkX3od3SUUZ6wv3PSoe9vLA8D9XeEUgiN0krsotO8XZ
	xvkNZN1+z+GBRR/uo/ACPd6aXksPjS4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779285140; a=rsa-sha256;
	cv=pass;
	b=r4nymgSJ5E7QAYs09aMzZeqDBRah0tCcRL5vQ0uiSVgkOK/f6/NuuWCSy4pZxcKOtTSxDg
	IIGvfPJA/8cx9+YnmpHvP761RgvgsB2i8K594cRJ/2OgWxYxsBAuvMId0FvU0SLGDhElwX
	MV7HY+VUOsxp/dQrB9vJrLG3i5bPA90=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oQz6QIuH;
	spf=pass (imf28.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-515548f390fso16021cf.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 06:52:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779285139; cv=none;
        d=google.com; s=arc-20240605;
        b=FwRHxuRckKxz9dzmtuC9Agny7JZ7ZsGzhZmo0e27N5rt3Dfkx0Gb6q9QnSajwSVOxH
         IOHOW1paygMaA+qA4WcJBLUkzAYs4Af33SIKHVpLfzrD8vpg1hCJghGCM9QZoL/YCQ8J
         2Ld4biPlw9AZNw9iL47ShIlGZBXtew2ntwEspqxY2nfMeFpNYu9Z4ac48CSG3C2thSXL
         2hS6fHFE6BpEn9EG6jZFg0kuyXU6QsDQO2EAprtm/MKonPbC7ZlKWhTDPQtfSJSlQCIh
         j5F68rIHbVRwBdDutw3L2PRO2HviC8L6MhU0Pq8pXZvj5de3E5kJILWg5pSunlczvRE+
         5Gzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Worh2JLSPSAyI17eyly2xWvvXK0uXozd+nOzIiXznLs=;
        fh=xPoAESI6JtD5kZCDhLXrULANp9DWCl3cQEBk5wYlGvo=;
        b=MaPyEZnxAPpyERa/WxI87jDz0xlQj6DV97o2ZbgluyGzCNQ/5Z3Y28I9M09gNvs/As
         OsJRIPms11t2zEc6f6PyujccRx2Aj6drHX7rUen/nOC0JOU0V8JDzmwTw7MsabTCQmr9
         /k6hYmvv3OhFoupTU4ganvJ9Txd30HSAZpEfYDd18Y2F+7Q5+2BPAuEUneURKt3hZUOk
         o6TSZmb1rLoOaBRah1C9CR/WZQaT2iYo0fGirSXbMvbMkvhT1+yTpYIES9r6aSa+0Wdf
         zDmmAAxicPZgT1E9AfjwYoNnoAXqqjgEZ26H+H6GkM7kznrLYPbrk/5b1VtHmT7TLpQl
         f0Hw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779285139; x=1779889939; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Worh2JLSPSAyI17eyly2xWvvXK0uXozd+nOzIiXznLs=;
        b=oQz6QIuHQ8mg+QodPnCLCAAHUmd2AscxlKjNI89P1UY3YF9QwBSZ60mG+jQScQBovP
         fCnBWkM2KLPM+QV0+vFOmdnrAL19U0nvAgOagdDIX+QyPpm/6IDRBxKFHbiEJJEKL6Rv
         LH66ceDPvd/GRuVLPpliTq6s+g683jE+JJPIZGDdEc2FhTETXUXUNbYO9tQW4IgBOl0e
         rR8Vah0bbVFvAJ7cJnNiPBEbSC8UZxw2FqWG9gON0ULE5IvHqzpcWfpu7wkJ0cLBYcf+
         x6Pv8BClnsSrZ+rBpYt30KlaPU6NOenx3vWvGOyYvgLKnKyg1ElApJLqJ53RqIc22WDu
         u+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779285139; x=1779889939;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Worh2JLSPSAyI17eyly2xWvvXK0uXozd+nOzIiXznLs=;
        b=QKSy4c3Zj1UGnD8Ujv3NpMb7Gq945gW/9yINhkFFGd8tiyazBcwejzRAjnsJrxrFTU
         H8LjRVl0uCPXwmFyX1YlDJipavElcGx4OCdjl/7Lrp1yqdLaZZRYp5sib5dHNlkGrDLa
         CLiddkiDC6xu0uVE8cEqG9QI2af3xL1KjibkcJQlIoO/mdYqXFo2YZUkBSKxf0FihQs+
         S0Bb9Oz9xH/GbA6ehU6Chcc+KxeEJI1e1uaqzOIFu2p6KgbJ9VeOrfHjOPeCwREcgiq1
         Hwf9popqgADkiaqRZyIFdM8wiyyocchZYxMm3V4NPUsDffkIosW7nhHbFAQzypF4N7m8
         4Qmw==
X-Forwarded-Encrypted: i=1; AFNElJ8dGoamfdYnIlrLSrV3kykabIRfKjZcsBv4PLinHTUVKRPq7icEWA58rZ3fIhVhJl+12ZsCsfSKLA==@kvack.org
X-Gm-Message-State: AOJu0YzDg5pRqXq4gu5xksXQtW2K2ezazAsS5TAzdc3brXe2X8M0KaZU
	R1DvU8jeFasW4L441g4Ofm87En/Ix7pHefhwOpjRbmm3xMtACbR6ec4DS9ULUXaBtXrhuYkcQyi
	IIJjlgvQJwFykX7JSWYJu+EWZyg85hfl5tOE2j1Mc
X-Gm-Gg: Acq92OHCsjoL11XxANg3xfrhl17EtC9hz30V6nt1/rEVVnrN3i2zm1Jf1hxs7KxUpJg
	R/kqmjMLddZlK1Jt6V7CwxjqxfuhSrPZQijkD8hjatsyfBFnuFtsHtR+L4UNmWDdW8v3vctV4qN
	mB+Gh9d8ttysHkpi1vvA1p8r17QbpXNQ6cgpUNwAvDCsGteeBtoCoNYp+bSzyKNPycmylzR+tO6
	KB7Whlies6XXLYrD4qkPuJ0FmDoLDFvhAcWpqFT/v8v7pjgDDAf7+cTssuU5b0PT7KT35IK8ES4
	Yo6/mBpIJiBHOGkbLSI=
X-Received: by 2002:a05:622a:5d4:b0:516:4197:361 with SMTP id
 d75a77b69052e-5167937f111mr19778701cf.4.1779285137735; Wed, 20 May 2026
 06:52:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-8-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-8-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 14:51:41 +0100
X-Gm-Features: AVHnY4J85RRb6CNplqSCM30M3DMf1Y3bV7iG1C3rTvm3LWaftfTfmZz57_1_-Dw
Message-ID: <CA+EHjTx+WbsKB66_0_1a3=vBkEdoeqJG9QOfZcUTuT8MYc=TtA@mail.gmail.com>
Subject: Re: [PATCH v6 08/43] KVM: guest_memfd: Only prepare folios for
 private pages
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 22AB1C0008
X-Stat-Signature: cd8stkrmghxggcdjff54pix8o36diyzs
X-Rspam-User: 
X-HE-Tag: 1779285140-985051
X-HE-Meta: U2FsdGVkX18iAFyW65bzKY883RddJ9A0LlTfH7HwHuDUwkJOFUJ3p9CEqzWYh/cFNRht694Q5dYBBdb6lVM4xBjVvBfVyhDXoJydbeaQIUr/tnbCKjZHTZWNMtnFBtbWqIxeBlfvAOClXOb7Vn8z789BkIjxpf0SDQdlHri2U0wh0Yog9QF/l1bclnvFaJJ4GmVv9QbUNR3V3NeNxN9gPkO+w5eJc3Wap8YVxO024+7rZebwWoRhZksmaprHjXWxopKzQj5Ff+3MQ3QCMSkg+2kKBvS3w07lmsrKl43RlZ9MtQag6atjLvF5C/+qI9QjlhQvITLHBIUMCzzO09U2lQr28QqYClSr2cWbOWzXhnDLYk/ysyXqcgKX1x+mny+Q88hGVj6OZqpHEWQekJVzrpcJlbG1KDrnp9SLbGN6DXCJKyBWeDaTs8416RyyF6qgLJpFJyrTKQWwKHSqNuL4xqD42La/DMMqYzdi8y0ymRO+YkDrhqhzqJZWZZSFZhdDNObBfYQGe5KJJJxG7wI2mV/PHTzaLffdAWlc9Ys8xjGx6NhODGXoieRUUN3lsfeJEaOHUNJMYUfj9/ygjhKr3kVphNo2dRTKFq7CPxs59K2A75Cna1ATTX3kfBmo6vSEI6ukxjtFLiuVkIRe4QVNqCpVeTnmUYoO7AJcXPyjc+kNemE9RrVuiIulJual5uwoEzolptxRgKQK9qO46E4XfmUEbaVAA7Xz4iIGQnMMLIGCU9utJGP7prug9KM3PLY+1ZRs2ls9Jddm+7MIn/9sstszPgKGMRYIS/lG8xGaq1APsCyrzgPg5dRul6gRr9zwV4OSXTz6yHMG8O6IO1jqQHYvdR5koQrBjtcn3JKNGEOJEzrsCDtwXc6CCu9HgCnRsnMORG70ANZompRFYQEHIW5DWvyhopp8hbwCAPgXbFYOJ3lD5ZXoGB6nGtV4RNU/E8MV6LTeFcAKDYX2cWv
 Kq1FQCzU
 EBeHAcwiR6PlACdgmQ1aOj1NPrQkDAEwjB/ItpwBYOG17g625GrP4zve4jDOf4N/uiRnZqWVccFBBlFJNkZmqedko3BwtsYBoMLyOEkiBjoWmMn7Cp4oW5KlqZBvbGPSZei7iTW93biZxlIXBJ06VM66U+gCqjFlf1cummR3CZ32QtDZ5s63CRqzMJN2L003kKRO5ZSmQr+fnGJ8s1JwS31+Vde6qJu/8jCEtaZw2DNvJte8iNaLsWH3b57273nhvuyeBWrsk0EM70NW5OtvpDYySW8o6RhKZO+aBR332SaTjgJCcpMXBGz4qwpPvUUh/DGh1s/b5e7MsXq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> All-shared guest_memfd used to be only supported for non-CoCo VMs where
> preparation doesn't apply. INIT_SHARED is about to be supported for
> non-CoCo VMs in a later patch in this series.
>
> In addition, KVM_SET_MEMORY_ATTRIBUTES2 is about to be supported in
> guest_memfd in a later patch in this series.
>
> This means that the kvm fault handler may now call kvm_gmem_get_pfn() on a
> shared folio for a CoCo VM where preparation applies.
>
> Add a check to make sure that preparation is only performed for private
> folios.
>
> Preparation will be undone on freeing (see kvm_gmem_free_folio()) and on
> conversion to shared.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  virt/kvm/guest_memfd.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9d025f518c025..4f7c4824c3a45 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -888,6 +888,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>                      int *max_order)
>  {
>         pgoff_t index = kvm_gmem_get_index(slot, gfn);
> +       struct inode *inode;
>         struct folio *folio;
>         int r = 0;
>
> @@ -895,7 +896,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>         if (!file)
>                 return -EFAULT;
>
> -       filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
> +       inode = file_inode(file);
> +       filemap_invalidate_lock_shared(inode->i_mapping);
>
>         folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
>         if (IS_ERR(folio)) {
> @@ -908,7 +910,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>                 folio_mark_uptodate(folio);
>         }
>
> -       r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> +       if (kvm_gmem_is_private_mem(inode, index))
> +               r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>
>         folio_unlock(folio);
>
> @@ -918,7 +921,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>                 folio_put(folio);
>
>  out:
> -       filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
> +       filemap_invalidate_unlock_shared(inode->i_mapping);
>         return r;
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

