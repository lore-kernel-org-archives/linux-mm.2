Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E847CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C626B0005; Wed, 20 May 2026 10:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5F06B0088; Wed, 20 May 2026 10:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7566E6B008A; Wed, 20 May 2026 10:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3366B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:01:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09382120350
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:01:10 +0000 (UTC)
X-FDA: 84787959900.12.631A6B6
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 079D9C000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:01:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t3fHYjR1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779285668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AI7U3CC1NzngQuPdfdvr3Q6fVVGPJz6btgu2++gP6TU=;
	b=Dd1+66a05nxAddiR9kwfIZhkVpQa4zSgfVmFldV2O3jQ4RutpQbWztG+8lU1l63v3PffPF
	QZhd3QuytkGbt3dtnqNRszL/8jSJ9i0A9nQ9uZQg3/USq2wQUNEB97vZkGuEATmRhYgLJQ
	OIIgfiCy3H42HsRYsIcudkgsuiQrdFE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779285668; a=rsa-sha256;
	cv=pass;
	b=VFYzosnw9s8Q1NpZzhSvfb4G+1p92GbiLbWq2XSlAclCXx6sRMx6l1JJM6kSj8DTRIS4UP
	znSRDMVpIjp275dWjildBrl+8s+kRDuFwSUYHZlYbQKUDop8F4PoxIKgJzraTDEdqIeQIZ
	Up4yKWC/S9p+VIK/4fqZXPryd36h03U=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t3fHYjR1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50d864c23bdso15871cf.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 07:01:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779285667; cv=none;
        d=google.com; s=arc-20240605;
        b=aKncb1O2dNhxExrV0tTEKDnTAX3ljRFACbBkZI1RTDrcpbmLVAVvdC4Aprp9HQZsXx
         fVdLC+Vy5vpc7ESayY1IL/4UdU9hc5l7fbE/Orp68eiDrpFPuOhf/Zx/epxwzyqjo68n
         pl8FIs1iRGp5WZNwYVntcYTzHkE3TIS480DMXBknPtrX6CDl00D1XuzxejbeXyHkRHOK
         ylEyVYsHyZW5XirAqnvYM0tNzUb1m8U8XDB2PSseMCIATs+S2U8qbG1Id3uHyhfNm7U4
         FDdUGm1ZMR779CnZPvJs8AN4wif/RI/vTLOi98bWG0VT+A+h6vND82L2tBlBAe14n69d
         6mFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=AI7U3CC1NzngQuPdfdvr3Q6fVVGPJz6btgu2++gP6TU=;
        fh=spscTd0ms9myKNcEYGCOT86A/OOjLzvKTVaI+TUh1cA=;
        b=L8h7RpkrsTAObTdtLdIXU17gIz84yTT/KvSUgyVrXBmbg/t+Iix4G3l0QJhxp+DafR
         ka1tQjRZ07BGWqB1kdH35WeGNbNtEoZiKvdYUtNqdzaFrNz9dY2Xo7TLFXf+MCYFuJqu
         u/oewBxb5vlN+o3l9Xxk/Tfad0yLNfRQgMdf8u+g0w0P3m69aCAgbkp797boKpOnXrd8
         v7iyAV/QDciUc9BndW18uFJrwLbimWL1vc/25ExAYM3xKZ3iPgQiOq2bJgxEua0MOY0v
         9UeAGwbe+rmbpFiY4Jz9tiAh12BCX4hV4ek4wQ6FF96VnPtsR8en2J4r9oylvnb1wFT6
         HMhg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779285667; x=1779890467; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AI7U3CC1NzngQuPdfdvr3Q6fVVGPJz6btgu2++gP6TU=;
        b=t3fHYjR1MI5JCNTGplvnYa7Nxxn/7QorZs+tKdSuyQk5k5/GFZcXa3me3mWKFmVigy
         pD4MdQ2pe6S1k6PcuFNAkT7Iq3c5FkUyKg4x9VIlf0OmHdTvvnzh33EmZOq9HGOBidyh
         n3+IdtudTPR8yF/CgMV9s0jv4yBvC1090wY0HWW8BmVeHhAHlY4QxLheg7U6aCsYVaGY
         dfXj2T2m0y909q1xfi+KMEDdCIOyJntRw0w1EfWOw8RspsJCEhUnlgDePQ2HOAWCmewI
         VUFt4xlqkHOfy8q1fJR72UhvqwErN72SROZcRi5YMRw9Q5k5jNL1Rw0enC0Lypdeeyle
         0Dbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779285667; x=1779890467;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AI7U3CC1NzngQuPdfdvr3Q6fVVGPJz6btgu2++gP6TU=;
        b=XRKvpXCYbOSvkMbof0gX1dX5VzL67QzIzt0nM7HBKcAFcgcyJ4sWn1cjtgNaeATKVr
         IsoYpMLZSMGGKugTnmdJVm3vNTZKbpADJ9RuTxbraLHkee5TGJA++MIF5YVdO9p2V72O
         CQBaKCBvzAfF6Qhx2ZUkEmih5ls/DQJqW+DUw/LKFr2rQZj//rsomPwg2ku3Ixr2ZeMt
         bfSIm3EewohdCLe1WHAI8wo4BRtFZDaYdvV4jffNbtgsPXA9RFcOAbCRO8orJaS/v9OW
         M2RN2+OeyXOxglft6ul+eq53+C2q8Ifq8c+QfRWBOjAusIpZaO3faRbtwA+6FUqTtEhi
         oFQw==
X-Forwarded-Encrypted: i=1; AFNElJ/ST5iGxh6NI6KQ2zS7xjr/CkD3ir6goFFehfbmVwmlGSLugUXpax2lApyR2g0rhZsM4lx79sqVkA==@kvack.org
X-Gm-Message-State: AOJu0YzEjQoFs1AI+5eqUnuSZK0CrgjIdz7D8L5igySacHlTqAtm4sp/
	3YTwQYvYqqAF81y4qeDtgYMEWEDUqSCw6bYkkKlZoUuIHRNzgZuRngAICMKzsLGmJju9JLrvrDu
	M01gZBy8cnjF3CCxqlogz+vRHebnNS3MNlG8lrxwJ
X-Gm-Gg: Acq92OHLg9kNDzAQP2BEwcGBxx/4TlS7pAC1uU2rG8/uSzqr5kEq/pMdPmmxk2zEkTn
	eZ8/e6kBPs4c07VnQHTB7iFFhEFef0Jdkj7fNtHGX6dp3eolristJOaf5SES1g8yoeWV7Hyka2z
	hGWckveL4WJV0ZQ1iDE9GY5Yg49YoYyZidED8LspjRHBXk1D87cAf8ANoFYSDY6+Lb1rbjxkh1g
	fTzEC4SLomPpj1/avS0OusxPP+UEignw+Tv2h0xaAoIN3XtHg2+JLx0sZGrvavrdsWF8ZDzoHkg
	u6BjPvctNKNV77NaurE=
X-Received: by 2002:a05:622a:900e:b0:50b:8d3c:5bd7 with SMTP id
 d75a77b69052e-5167b669c3fmr39500301cf.9.1779285665976; Wed, 20 May 2026
 07:01:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-10-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-10-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 15:00:28 +0100
X-Gm-Features: AVHnY4I1xsx3pMBMFSzeQ0uJ_eCgUqjv6x_jwcWrLBSoaR3lsTGttyhku4viwLQ
Message-ID: <CA+EHjTxLXxtgTdhLnNiFwhjQWt25QWPxCqRgFRJoUBhOtSFZGA@mail.gmail.com>
Subject: Re: [PATCH v6 10/43] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 079D9C000B
X-Stat-Signature: wrwz9hk68eofpmxdge1e6j4abxusuts5
X-Rspam-User: 
X-HE-Tag: 1779285667-215424
X-HE-Meta: U2FsdGVkX1800aBPIaOYpe1FsGvTqMe7voWofbHn9PrrKEyBL6zpI+CAHqXN8Gqa4jeGdsO/fwwzTtzNf1REuSFb0jRqOnW429oLRLtOh+wooaT/hCUehJO2aypp3n7kplfw9jie5ZvJMA+jeSUGgTIv4XnIU3QzFs+Sk9+JuS9rT0K/xAFOFLGkF3lIKjXVnr4lKpCqfNSkp0VMnXC3KebFAszMsudovzWcWupY2aSirzKuhO0y0exfsSjqriEa2+RXCttcj/cMWRKO7R9vZGAkYK6o5h7tL8EFe5UAFCufmz5RAe9o/oVG2xO1BdlLzuYQsqJigyhY1qKUuv0vtrMHP/JT26ZQjw0P1i78Y7vEeWFsc9ZjjstnBoH714nGfVQWLUdjGG6BvHmuWTAzu4Ey2cJk1ozziRuD5YjSwqmaVsFH9eRfOnrRWiDjbgakCeVwvSeHIJkijtbBitEHlTu8AZfZryraQJUWRpbunrqzI+aHqe1XrG67s1kTcgZ0zrJyKIpO8Zy997wqKdRn9OXdSQF5148fTQX8PpCo0dvl69QJFZJaHVnqZgvxLqukfheikpg4Bve6nROGCCP1gZU36xUgfmB/yecSP5oHjH+X4LoocgS4vxq6k1bzD14TpcpeUGH3KwtWF0FNuGyBb67rR+iAblxq8YIz2sHomPUBPEwiBvAPnYkxrXHAuKbpLCyTAM1duLvyhFGB+jgUKssdMpxRGI19p73Dj8uWE3dN8wvwMkIEmUPT6tgVi2MukMUI4uBz9BWkDEzQE0yqxhKfOShG6viEcEau+ltnAHRw6lTniZYzxPN4vae5T9jspQ/nd2tlr0IKE0DhPE4jLC1O6KrJL241bIGe3Joa4ZBEmSVqZxBtSZr1FbXbPLAkwfmSi+MIKUL1Kyn9USsbYOsK6MsqZ2+t2keZjwXAzwrlv2QGA5PZC2B4bsskIdjX8bt1syEkx1E50I9iMzL
 yqSZpWls
 kIZnDPZzasDicKLlcRR2jEYChgYqn+3wAvxC0wdF3rEWoLvtoxQ/UjNhcHTnM8Ybz3ftE2rchilfUFZsTZJq55MpBygx9HzCcgZ+yLPdadJK8wQwS5Wv2YB2x4L8moYAT3DhFTW1gn+cna56XcmUrmohW3He91kzLJPiFvACK7C67OmROweVsDT5cwQ9hXbMeJ537QsuwIWpcxCXx9E41hJEF/Bm9I1PQDBtVStqybE9Fo9xhUSiOfNklHSfI4zXeKfgdjtA/LPftoK4Ss/sbwnEji22D5dnlG8W7CEiKJY6JgYN9BqJNMtcicZzUZF0IJ4H3VbDiHEtI0T4=
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
> Introduce base support for KVM_SET_MEMORY_ATTRIBUTES2 in guest_memfd, which
> just updates attributes tracked by guest_memfd.
>
> Validate input fields in general. Guard usage of KVM_SET_MEMORY_ATTRIBUTES2
> by making sure requested attributes are supported for this instance of kvm.
>
> A new KVM_SET_MEMORY_ATTRIBUTES2 is defined to support writes (unlike
> KVM_SET_MEMORY_ATTRIBUTES) in addition to reads so it can provide error
> details to userspace. This will be used in a later patch.
>
> The two ioctls use their corresponding structs with no overlap, but
> backward compatibility is baked in for future support of
> KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2 in the VM
> ioctl.
>
> The process of setting memory attributes is set up such that the later half
> will not fail due to allocation. Any necessary checks are performed before
> the point of no return.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Sean Christoperson <seanjc@google.com>
> Signed-off-by: Sean Christoperson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>
/fuad
> ---
>  include/uapi/linux/kvm.h |  13 ++++++
>  virt/kvm/Kconfig         |   1 +
>  virt/kvm/guest_memfd.c   | 114 +++++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      |  12 +++++
>  4 files changed, 140 insertions(+)
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6c8afa2047bf3..e6bbf68a83813 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1648,6 +1648,19 @@ struct kvm_memory_attributes {
>         __u64 flags;
>  };
>
> +#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
> +
> +struct kvm_memory_attributes2 {
> +       union {
> +               __u64 address;
> +               __u64 offset;
> +       };
> +       __u64 size;
> +       __u64 attributes;
> +       __u64 flags;
> +       __u64 reserved[12];
> +};
> +
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>
>  #define KVM_CREATE_GUEST_MEMFD _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 3fea89c45cfb4..e371e079e2c50 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -109,6 +109,7 @@ config KVM_VM_MEMORY_ATTRIBUTES
>
>  config KVM_GUEST_MEMFD
>         select XARRAY_MULTI
> +       select KVM_MEMORY_ATTRIBUTES
>         bool
>
>  config HAVE_KVM_ARCH_GMEM_PREPARE
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 4f7c4824c3a45..91e89b188f583 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -540,11 +540,125 @@ unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_memory_attributes);
>
> +/*
> + * Preallocate memory for attributes to be stored on a maple tree, pointed to
> + * by mas.  Adjacent ranges with attributes identical to the new attributes
> + * will be merged.  Also sets mas's bounds up for storing attributes.
> + *
> + * This maintains the invariant that ranges with the same attributes will
> + * always be merged.
> + */
> +static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
> +                                   pgoff_t start, size_t nr_pages)
> +{
> +       pgoff_t end = start + nr_pages;
> +       pgoff_t last = end - 1;
> +       void *entry;
> +
> +       /* Try extending range. entry is NULL on overflow/wrap-around. */
> +       mas_set(mas, end);
> +       entry = mas_find(mas, end);
> +       if (entry && xa_to_value(entry) == attributes)
> +               last = mas->last;
> +
> +       if (start > 0) {
> +               mas_set(mas, start - 1);
> +               entry = mas_find(mas, start - 1);
> +               if (entry && xa_to_value(entry) == attributes)
> +                       start = mas->index;
> +       }
> +
> +       mas_set_range(mas, start, last);
> +       return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
> +}
> +
> +static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> +                                    size_t nr_pages, uint64_t attrs)
> +{
> +       struct address_space *mapping = inode->i_mapping;
> +       struct gmem_inode *gi = GMEM_I(inode);
> +       pgoff_t end = start + nr_pages;
> +       struct maple_tree *mt;
> +       struct ma_state mas;
> +       int r;
> +
> +       mt = &gi->attributes;
> +
> +       filemap_invalidate_lock(mapping);
> +
> +       mas_init(&mas, mt, start);
> +       r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
> +       if (r)
> +               goto out;
> +
> +       /*
> +        * From this point on guest_memfd has performed necessary
> +        * checks and can proceed to do guest-breaking changes.
> +        */
> +
> +       kvm_gmem_invalidate_begin(inode, start, end);
> +       mas_store_prealloc(&mas, xa_mk_value(attrs));
> +       kvm_gmem_invalidate_end(inode, start, end);
> +out:
> +       filemap_invalidate_unlock(mapping);
> +       return r;
> +}
> +
> +static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
> +{
> +       struct gmem_file *f = file->private_data;
> +       struct inode *inode = file_inode(file);
> +       struct kvm_memory_attributes2 attrs;
> +       size_t nr_pages;
> +       pgoff_t index;
> +       int i;
> +
> +       if (copy_from_user(&attrs, argp, sizeof(attrs)))
> +               return -EFAULT;
> +
> +       if (attrs.flags)
> +               return -EINVAL;
> +       for (i = 0; i < ARRAY_SIZE(attrs.reserved); i++) {
> +               if (attrs.reserved[i])
> +                       return -EINVAL;
> +       }
> +       if (attrs.attributes & ~kvm_supported_mem_attributes(f->kvm))
> +               return -EINVAL;
> +       if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
> +               return -EINVAL;
> +       if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.size))
> +               return -EINVAL;
> +
> +       if (attrs.offset >= i_size_read(inode) ||
> +           attrs.offset + attrs.size > i_size_read(inode))
> +               return -EINVAL;
> +
> +       nr_pages = attrs.size >> PAGE_SHIFT;
> +       index = attrs.offset >> PAGE_SHIFT;
> +       return __kvm_gmem_set_attributes(inode, index, nr_pages,
> +                                        attrs.attributes);
> +}
> +
> +static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
> +                          unsigned long arg)
> +{
> +       switch (ioctl) {
> +       case KVM_SET_MEMORY_ATTRIBUTES2:
> +               if (vm_memory_attributes)
> +                       return -ENOTTY;
> +
> +               return kvm_gmem_set_attributes(file, (void __user *)arg);
> +       default:
> +               return -ENOTTY;
> +       }
> +}
> +
>  static struct file_operations kvm_gmem_fops = {
>         .mmap           = kvm_gmem_mmap,
>         .open           = generic_file_open,
>         .release        = kvm_gmem_release,
>         .fallocate      = kvm_gmem_fallocate,
> +       .unlocked_ioctl = kvm_gmem_ioctl,
>  };
>
>  static int kvm_gmem_migrate_folio(struct address_space *mapping,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ff20e63143642..4d7bf52b7b717 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -110,6 +110,18 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_TRAMP(__kvm_get_memory_attributes));
>  #endif
>
> +#define MEMORY_ATTRIBUTES_MATCH(one, two)                              \
> +       static_assert(offsetof(struct kvm_memory_attributes, one) ==    \
> +                     offsetof(struct kvm_memory_attributes2, two));    \
> +       static_assert(sizeof_field(struct kvm_memory_attributes, one) ==\
> +                     sizeof_field(struct kvm_memory_attributes2, two))
> +
> +/* Ensure the common parts of the two structs are identical. */
> +MEMORY_ATTRIBUTES_MATCH(address, address);
> +MEMORY_ATTRIBUTES_MATCH(size, size);
> +MEMORY_ATTRIBUTES_MATCH(attributes, attributes);
> +MEMORY_ATTRIBUTES_MATCH(flags, flags);
> +
>  /*
>   * Ordering of locks:
>   *
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

