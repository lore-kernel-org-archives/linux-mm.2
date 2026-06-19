Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A671CD98F8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1424F6B008C; Fri, 19 Jun 2026 04:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3C76B0092; Fri, 19 Jun 2026 04:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F248B6B0093; Fri, 19 Jun 2026 04:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8B5C6B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:35:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D041A0379
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:35:38 +0000 (UTC)
X-FDA: 84896003556.07.FBE0DBD
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5E44E80004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:35:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c3z4ZbKz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of tabba@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781858136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJCNxtqxuBlYp3k8AwtzAL+0dBQBaE1Rgq6EFlCIf04=;
	b=kWkMh4Y96llrcuan9Oy2dYG8mocg4KEDF2H1TBCIzqRoXeLj2F5faDObTBl9C/dkwxr44j
	xth7zdWUHbhe8Wuo1z3ZFCgM8e5zymhbS2U8ZdsLI0guKu+i/1fiGRtF8D4zpgGh6xmLsK
	vnhxFN0CIzAsGftlA3rMQgyiOcjnMYg=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c3z4ZbKz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of tabba@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781858136;
	b=AsCmawsqS+Apti2MMOfBghLhqPF7CcKdrNacluroExP8qcXLC0msBfR04THnWgt7w1vkFw
	7P+FIsrWbWyMRWaN6///h+cQ1TUH6yiWAgto76wJppxSsn2fv0k+mrIMmJWyNbCl4yYgBS
	hx3K2NmWGqdOoQxvs4SZbSjatWwQC0w=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51765331535so124891cf.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:35:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781858135; cv=none;
        d=google.com; s=arc-20260327;
        b=BVbtx61y/2/Nph7vEa/JFginlyZDfffEwVyhnti4YHoJ7ArxiAV7AxgwuqSjxgjlaI
         mIrcL3AePb85PoQ/S14TZUEIFjljkmied1ozeBlhwxaZt5rNUyBhYlkIyyBh8KCR8fLO
         kg/lzqZb8DuE8oM+9zq2Pka/yI0twAiTzbKsQngt3FmuKOQfDpHnUr4alA7dfKI9PcxY
         OGwnssIJcQdoGJsGpz8Kqsc1s5ZRfW3csdbBBlkn9x8eI7RyM7JZ1Ax0UE9PBAhbK/EU
         FgIWu9pJLOLSki22hQV81n+FL57LNpXF6wcT90a/du+Ir6MvlHaPX1W1Do4il950ZpPH
         cnCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vJCNxtqxuBlYp3k8AwtzAL+0dBQBaE1Rgq6EFlCIf04=;
        fh=Bv62hGyAMI8JvuiKqS7ptGymA9YYz3o7ETmLnn3hY/A=;
        b=JTb5o7YGLGuahCCiC3QBAkWlSWxQLZeJTU/5CCLldpIwDPiLjfha7CI8GLymlAiH1a
         bPNYqjDqGBEazmb1C31gTPpkFqbBQhwfAZ4EWMA0cOrjfNlYLmcB46rQcgMT2Xh+YNd6
         kppU+NieYOYIcBS2nNfyG/nZIuRwBDUsl0NtQgSYOPpSp4oFfYuqygcxTh257G1MlDig
         /gRhd0m7u92xK/30r4kjR4QM21+tNQigc6/04NJ6UhobHolaBOeqIXPz00rITVpZ7IGu
         4udSftxUf+FBDKaU+Iu0ETfOtWUij+Lu5azh1jyL1uZRKEJVIdHlYptvbHCYhwWWToFe
         s6CA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781858135; x=1782462935; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vJCNxtqxuBlYp3k8AwtzAL+0dBQBaE1Rgq6EFlCIf04=;
        b=c3z4ZbKzXDgZ/A83FSDgHZCu8oDm6dUKS/A0KDjCTdDlUQpuustyUZk4X30pusW1rv
         9MzTL+sRZbqFc7UNvUScCRZZrIQqD6jig8NxgwWMTpvujewQPd5wPN0TcHZVDkBIp4OA
         bba/Uswui7YNcGmqgnR0xwbsYDwluerPP26bBuJCQpEMF331hkEc4j9QFBLTPT670BVc
         S5+FmIxsluIYc2eJuJUhLUg5Qs1/F4CvtTnh51TbsqNcCBrRfjIlToSaTJ/HVskK3cxI
         46Qg+Z9GtQY4+iy9bw57jlosIO0T5wdx4fw/9fyjCxnW7iYMVjrxT2Hl+7AplEudq3Gg
         7DSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781858135; x=1782462935;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vJCNxtqxuBlYp3k8AwtzAL+0dBQBaE1Rgq6EFlCIf04=;
        b=q4aS4oPa64QHFdAqdfqtaM4ibO4l4tUpisLtczEFmPe/wfF2qcB8vAx2ygNkzP7h8P
         oARWh1bTOXliEQvWHFC4wmik40BI31iK5FBxrDaZ/Xos+KZqEKvqYSMqaHcsi43L7qIa
         EzzNl6QDfsU6ZhwVKTVzgqPo+r3TfDajHHIV3j7EL7TGq8lmQXKs8YvUvJPjJaK/nwP/
         ktNrnkq0at8TNaxYQIQiuTAjIQuJT1NHGxREMolqHzPyAlTTeYzv/u2R0Hdp/b5FTqyw
         j1wwFS40veLUwjQlo9eoTXO6c+ph5EZdho8FaN066De69J+byC66uO8cAkpJWtmQxSB/
         W+Sg==
X-Forwarded-Encrypted: i=1; AFNElJ8BmToKWJl4LHguIeybj0scV7HsD3nLT2ikdm2Gwt2jrC8BThbi1532OLhaxiQEIHxyOUQwgGs9SQ==@kvack.org
X-Gm-Message-State: AOJu0YyCiGuI60f1Yk08hglkljbu6omGVCLmNj0UkuOXgiiRif45+PU6
	RzIE1XbhKzCnwRGd1InQ8MUA1wjkbWXT0aRgMQO3zfVzqpvyUAOaDA0igtXwtvPBKH6RxTWTk6K
	rJV9TiPGAfMCYOmQkq8etPhbOV179JV0pKKrpAAN3
X-Gm-Gg: AfdE7cleid87eoQ0GGJYWLphpipFwSHIKSQBfStzJ7iCdevEEhyMAGXy/AulIG/Q6fC
	/uxVdSt0ktN731khc2rB1ekREWPefv6Tg906tzzFtiHITzGyRvPITzm+SUDtueaZp442VXnfsv9
	qJ+Qn10ffYWYd6MLweV67n9e+5BIRyWj4lEoWMXzBCz28SFBeZHUXCrGKbjR2fW4ymkhkAB/Eks
	NkJnqVU8gspdlnvMJb8vYfDDP0gxFsi/WK+xVr0OHMKTKcXg1wy/CIRs3QceYjEGjMMoijlNA==
X-Received: by 2002:a05:622a:8893:b0:517:99ea:ab7e with SMTP id
 d75a77b69052e-519e4a70452mr6973311cf.24.1781858134705; Fri, 19 Jun 2026
 01:35:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-10-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-10-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 09:34:57 +0100
X-Gm-Features: AVVi8Ce8UOYY3ibWf7EXz5J6tTWRIQf_RIk-gcXz8kRs-aLeFMDUqknE2c7ssDk
Message-ID: <CA+EHjTyGPo0JMsN8WFMer-2NWv6kNNUnyads+YHEXC20CwPjXQ@mail.gmail.com>
Subject: Re: [PATCH v8 10/46] KVM: guest_memfd: Wire up core private/shared
 attribute interfaces
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E44E80004
X-Stat-Signature: zdb4k94sq88zw1jy4whgdffc18iekj64
X-Rspam-User: 
X-HE-Tag: 1781858136-302437
X-HE-Meta: U2FsdGVkX1/Wyk0q+rTA1ExglJQkv2fc/1D46W1/wkyXWX9dqlIhwmLKqD9mwOFn3MWYE1yTF+Iy30dml49rQ/8eyLyj8SJJI4KGdq5HXhZ75rqA7D2+MKeXjPdWNMErVs48CcLDVc0b/LUYmuZm6+kIp5mhe16rrobw66tK7lSmUtDafLRDi9OKo4DhXz62jTnxO+SBWibyU1g06dyQdCTXu731nBwfdl06cRfKB0z4sHzt2Rol+dhC+oieS1Utr+7KIhFC4LEskh4uDJ3qduFhzNKwySgU/MnRAvXc3C4W93IQRHk93ro/XG/Wcmtoo2nU5bZ7jr0cpte90/sWytUCYrSKLjK9dZ+1aulCr23aTYUggPs7ywTz6ACVhbQG3POuCdhSCcXAqV6nYOURt0eL0/KpYWtsXEeuSMA+sGo3jdvvuTqjcSHrSVZSGtUWFnAxqV4mt9rJo2FqkDGkG9BgIF3Y0OgUAQgIg+Uq3wixlaNw2B8j/qEJ3NKLM6hxQKhcQAAfvSGgql1oiq9haOYeyTvwFycwI4NTMp8w2IdFrKvKLtCXq9UAOIRmfrPs7waUSJkTp1EIL5a2kS4uRkP3EPxCWeVldc/99hc6lj0BVvZuIJSnm2DJO5QkZKj6RHdPMUNBVC6278TV4a4nxncXGbRzwn9wHgzvayLrKITxNM49IcjM8uIRi8DI79xCzMOwO2oQ9wxzSDX7HOO1e8oQRdYfGDR5m62BDfD3k8gb2aT57sdwlNKbMJcT1Tv2YP5PmUodcX7t+CNnue5PvO0S/H5llXuTKSB3tiOc/xH3HWchb/cIWS6iXHgzEjl3XGLnwR2jHe6B7HIKaeZ4W3PSO9slXhev9YEPNO1vE7hT/Ln1MEHrJg551xcC4C3fUa1uQmME1vDG9ne6hY268yAD5cwqE415xbccUto1qWLvKwiVd2ra/EnVxYMqfVZAdBAmkcUh6kC3G3nCCL8
 wB1n9IA4
 wzknNTbOkDclWtZEQWDZrVHHijpxsaGfSjFMjjyt4ciNkZG7iQYEWUgvF+pG9RdlBBTQGXuRG6nDu5eW/ttwmckCXB1+XjhR/nwIf+kEHP2FWKts2G/hHEQcr3OpUb2nEDdIZQLMkjiUTLkif51Nx8jkIaNvGgk2d+J8Iv7Kxg8BsdsYarGKWX0u2fFCAAzHA5iAUhYmXeYZzg71rKT+FL7/HbvfksyCGz8qY+ZZCcfoi24EEimhhnuWUjRzFQMzbxUsKjYQ4e4l7JuPUutO4kARjffgzLg4MHCGRghmjFnDvy0t1+lzhKIcDn2DgJJu1zVW7ihx8I5J+hfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> With in-place conversion, guest_memfd is able to track the private/shared
> status of memory. Use a global flag to toggle between tracking
> private/shared status per-vm or within guest_memfd.
>
> When queried for supported vm memory attributes, return 0 if attributes are
> tracked in guest_memfd.
>
> When querying for memory attributes over a range, look up memory attributes
> based on the flag's state at query time.
>
> For per-GFN memory attribute queries, choosing an implementation (VM or
> guest_memfd lookup) at KVM load time.
>
> The flag is always false for now and will be made toggle-able after all
> in-place conversion features are added in subsequent patches.
>
> If/since the flag is false, if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is also not
> selected, the per-GFN memory attribute query defaults to returning
> 0 (false/not private).
>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  include/linux/kvm_host.h |  4 ++++
>  virt/kvm/guest_memfd.c   | 22 +++++++++++++++++++---
>  virt/kvm/kvm_main.c      | 12 +++++++++++-
>  3 files changed, 34 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 27687fb9d5201..acb552745b428 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2560,6 +2560,8 @@ static inline bool kvm_mem_range_is_private(struct kvm *kvm, gfn_t start,
>  #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>
>  #ifdef kvm_arch_has_private_mem
> +extern bool gmem_in_place_conversion;
> +
>  typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
>  DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
>
> @@ -2568,6 +2570,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>         return static_call(__kvm_mem_is_private)(kvm, gfn);
>  }
>  #else
> +#define gmem_in_place_conversion false
> +
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
>         return false;
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index bca912db5be6e..e0e544ef47d69 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -926,6 +926,24 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> +static bool kvm_gmem_range_is_private(struct file *file, pgoff_t index,
> +                                     size_t nr_pages, struct kvm *kvm, gfn_t gfn)
> +{
> +       struct maple_tree *mt = &GMEM_I(file_inode(file))->attributes;
> +       pgoff_t end = index + nr_pages - 1;
> +       void *entry;
> +
> +       if (!gmem_in_place_conversion)
> +               return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
> +                                                         KVM_MEMORY_ATTRIBUTE_PRIVATE,
> +                                                         KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +
> +       mt_for_each(mt, entry, index, end) {
> +               if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
> +                       return false;
> +       }
> +       return true;
> +}
>
>  static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>                                 struct file *file, gfn_t gfn, struct page *src_page,
> @@ -946,9 +964,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>
>         folio_unlock(folio);
>
> -       if (!kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + 1,
> -                                               KVM_MEMORY_ATTRIBUTE_PRIVATE,
> -                                               KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> +       if (!kvm_gmem_range_is_private(file, index, 1, kvm, gfn)) {
>                 ret = -EINVAL;
>                 goto out_put_folio;
>         }
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8b238e461b854..01761f6e25d25 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -101,6 +101,10 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
>  static bool __ro_after_init allow_unsafe_mappings;
>  module_param(allow_unsafe_mappings, bool, 0444);
>
> +#ifdef kvm_arch_has_private_mem
> +bool __ro_after_init gmem_in_place_conversion = false;
> +#endif
> +
>  /*
>   * Ordering of locks:
>   *
> @@ -2422,6 +2426,9 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>  static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
>  {
>  #ifdef kvm_arch_has_private_mem
> +       if (gmem_in_place_conversion)
> +               return 0;
> +
>         if (!kvm || kvm_arch_has_private_mem(kvm))
>                 return KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  #endif
> @@ -2633,8 +2640,11 @@ EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
>
>  static void kvm_init_memory_attributes(void)
>  {
> +       if (gmem_in_place_conversion)
> +               static_call_update(__kvm_mem_is_private, kvm_gmem_is_private);
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> -       static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
> +       else
> +               static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
>  #endif
>  }
>  #else
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

