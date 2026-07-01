Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C2DCC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 648F06B00A6; Wed,  1 Jul 2026 11:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9E36B00AD; Wed,  1 Jul 2026 11:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49CCB6B00B0; Wed,  1 Jul 2026 11:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 142196B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:36:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8CD17168395
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:36:00 +0000 (UTC)
X-FDA: 84940608480.11.7EAFA6E
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id CCCF6160012
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:35:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mYJ+46dL;
	spf=pass (imf08.hostedemail.com: domain of 33DNFagYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=33DNFagYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782920158;
	b=3W8bXfUxCQWc3OB/XS2t1SoAiwFfFHbaIE3wEliRYfIh2HPwOPYYQi6DCZ6Ha2ZdbCgiCQ
	0ndvRHcDsLmNLvdG3ineOrvPBniBfI7L7kyWegk5VXNH4geRVz8yGtb9E90MefUaJtEaZu
	8L1FUO4Eq/v3yp78F3bt8vncmW41dfY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782920158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dm8qbEauKVXJhYGr90L/dxzQTMgwF1P0y0BSIo+cWM=;
	b=VRFYywtBi02FUZjlLtqATXjt4IUniH07J9jCZv/tHWEilSjuySM1yqpUX5/qqCuWHZfO+7
	fdqpso5OQi+0gqxcSnOBmBZ1CZi2x3UxnycH1tV55I5GfICksK0yGjZvd2JoPOqIy4vYzn
	ietE61VOFvSl89unSOe5U5keBV8BJqw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mYJ+46dL;
	spf=pass (imf08.hostedemail.com: domain of 33DNFagYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=33DNFagYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c9b1b608e2so9597315ad.3
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 08:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782920158; x=1783524958; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/dm8qbEauKVXJhYGr90L/dxzQTMgwF1P0y0BSIo+cWM=;
        b=mYJ+46dLZvKooCVclSfAiFxDbEPDRIVBoegDrmiSzqtN55lOAayMfwmAds9WT7XUfT
         2fpklO6SBgX6SokVoIE6q6Blq5chWVo3Y8ys7Hd5GgfuODO1+JeN77HuLcikYx/pkeXg
         azFOjbWme1k4au1BbectNTlSY1cteGdMQ8RvKiQbgdFLNvyyJK6v/Gjd42THk08Bm6+o
         2CLeFXFFsj4bIsQzfHNIO8FjUwz5uN8o4vB8ZF5GXQqZURPL6o/zM2soU/KapBnSGLZQ
         V9ubrUBe8ye13AT89lDzAbLWcjCo0wMEbHwOmPyw0qEv5BP5DVUHrY/25vxYZlPcK/vL
         B78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782920158; x=1783524958;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/dm8qbEauKVXJhYGr90L/dxzQTMgwF1P0y0BSIo+cWM=;
        b=d2xNayOJjiDgmJ6QOpTlpJrBH3drDKGwH4E/3xjt6rVuEZP5OO9Gn5afRG4ApwLjnr
         p5srqfAiJaXqykOHF5KtZBKfIQ14XjzlVrMV2dej25v4Z1iOrsRPeuIG+nUUYATs4F3j
         FA1+yhE20O0JfcSNeQg1wkbdb1+3hdiOPh0ftQG1Ya5IaxWGBbAU2jFwsFJA+jmKQ3oG
         Ixk1++Dh8oTDsezwEF6K9954r2wPcqgU3FfSFfvTH9Lpq9pYkXkjjT2PCOk0RIk3RtS/
         gD9sie1Kg9gdGtVrjtESlSai5oaZs8IFQLVbKUyQYYNj7WzUO0zzQxRcENOxk0j+GM51
         +iOg==
X-Forwarded-Encrypted: i=1; AHgh+RroiQPOCDrHEi9cuMhrB8S2FyH+o4NIT/A9hGzhvAWcMPg/5RhfT52LcpkW/b5/QfZGU1cd17frUQ==@kvack.org
X-Gm-Message-State: AOJu0YzeLdcWRJS8gXuc7X0P0Q8UpIQF7Ap+TxYkhuuF5Spf612sosTx
	NRJIMIKZ9fFjgRWr9C1X2Y5bOr/L1o3kmzzsCp8IGJ6QriWeDKbdsRUVnhpchgDxl5CwRoV4gjU
	rAfFonw==
X-Received: from plbkr11.prod.google.com ([2002:a17:903:80b:b0:2c7:3d65:ed18])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecc6:b0:2c9:fa31:84f9
 with SMTP id d9443c01a7336-2ca7e682af0mr20521695ad.5.1782920156755; Wed, 01
 Jul 2026 08:35:56 -0700 (PDT)
Date: Wed, 1 Jul 2026 08:35:56 -0700
In-Reply-To: <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com>
Message-ID: <akUz3M5Z2vnioB72@google.com>
Subject: Re: [PATCH v8 13/46] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: nggw5ip79k9f4yqthmi3ncki8g3q9x4x
X-Rspamd-Queue-Id: CCCF6160012
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782920158-317163
X-HE-Meta: U2FsdGVkX186EjmAqFTdBOjxtqIqcnQb09bTvJT42dzeZUCDa7rDJPBPZ2N3IjgYYzvaQDp4qT2ClFhk0GrgfwMzw8t9msWRj3ypJQVU7ob3Y3FgPz6eGwL8mp7qwGgho3qL8tCV5wkRgkNSjhAhGzu1XyMekBbjRieTU7X+efJAZIZ1Gj55o1uI8/pSHSpEt8H8FHbS1YfX4BODLRSkZwcKi7ek0oB7HcSUNaCTDTRbPbBDdDXMuDrQbTqClGnE9uzX0ndtbcI9d1c/r8Lmf86hL5vLCbvuudVcWciREL5O0kLEXHKUffO7o60rbnWSoCITcw381XbROR6J4kxdMLuZyuFUlBuCVy7OUtOZPZD/aa6t9FTHh3WRI/YqR/zJgCY4MFHuX6uh4BtZdByC9tGWWIgQ8Ypb2+WVOrXuctczBT9njuJ/plpg5cCXbX2ferlRVSObpKzCfGtLvANdLeUDdhU0shX6Nl+6OzZ7zHX/aKZPsk5BEWTJe80TLcwGKVRqpsZjtQTd8bhVQ0J8w25eUIMPoFCCfsh3vhbtj08AVyuHPGpeDpFIYhEAuLEq+S1NgfUhe6jLnS6XfFm86EoFsAwnXjWZD1lfT7eVOSc9lmGTHW8IySvUSYIPuki38xkKTr6sdUsGaoun3woKI5/W3obKgzzWQJQbr2gWF9rQp9/4G+wnt0eBDOeOEOn2ymt/ULGksh2Daw7r9NAkptsFBXUTcu2jl/WcaXSjmDlCFCdBPGdbey05Pjg3EYYdwyvzoPUqtsL/l9e+UpWyLOUBEFy+87Icc9Y9eA608oul7KHhn6StsW2Rv/1qUkmT9ffSl+5utY+XB8SYrYAGFG5nBBWTnPpr/ad8CBfzz3Z/NJM9M5AQ6A9YO6F5hS4YSiSAi+Sl5CSPEgbSOgmuQ/L0AftKIC9kfeJarJ9WUopDdOBD7BoWAXzZgvRcm5wNWK1I0jipgXu0Rs8K10f
 NwV1Ckir
 dHKhQhpqbcPN+c19IFTDyEdLbEXC1roFVVe241U2K5EIRe3mG0jevy0/rnnPw9rxBGq0u6aCnaRxoRrB5qr/eQr/gA/K+OSxU1Ryn422O4uXMD3szeE3AyGy31T61ym/tYzbZmZ77TAKMdcI44Y1tOi8PQ2WxCsfhrt1L7s7i59WezMJJG1qdSWGJTpMUEGwzD625RuwboJSSddQwPPmIsshKKIrzHxt8HJAnWbdo8ewSN16HGfXzGXHsZRLIacTGHNFXh01o5DgouJ7e1PsdAaDPEn0qYgOd2BuzYGz0FMXooNoSSSGzqPBrhdhcaJKd6Owg8dt4xTrHAoNVVFeeuDkw86hAo99RLH4yx1IxcrvqcwNfynBh9C0KdyaoOhrrbw7XfH8T4ZpRFY8Cwt0yNt2d9dvkB1E7/xRJuC1HM7PWrSjP170u8YO0ITJHVAKhqHyo7O/BNgRuIyFZtoMrFlH8bYqeGAr6/0bm1kTq4HHCEqeMIOuYS55mFgfPqDPk19F2gqc1alBaqJrqQ3EjoUgxzHG9p13u+LQRipo55OXKL4ijfHK2zOSIb2+uDJqmBkmAjHa3iDaWd054lxA2g4DBIbXmy3XFTy7J6BLyoHo/JcomQfuhkOkxOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026, Ackerley Tng wrote:
> Introduce base support for KVM_SET_MEMORY_ATTRIBUTES2 in guest_memfd, which
> just updates attributes tracked by guest_memfd.
> 
> Validate input fields in general. Guard usage of KVM_SET_MEMORY_ATTRIBUTES2
> by making sure requested attributes are supported for this instance of kvm.
> 
> A new KVM_SET_MEMORY_ATTRIBUTES2 is defined to support writes (unlike

Phrase this as a command using imperative mood.  The wording is also weird,
because "support writes" makes it sound like it allows controlling WRITE attributes,
whereas what you mean by "support writes" is "allowing KVM to write back error
information to the struct without technically violating the semantics embedded
in the ioctl".  It's doubly confusing because the macros use a different polarity:
IOW means userspace is writing, but this implicitly refers to IOW as "reads".

> KVM_SET_MEMORY_ATTRIBUTES) in addition to reads so it can provide error
> details to userspace. This will be used in a later patch.
> 
> The two ioctls use their corresponding structs with no overlap, but
> backward compatibility is baked in for future support of
> KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2 in the VM
> ioctl.

I don't understand what this paragraph is trying to say with respect to backwards
compatibility.  It's a new ioctl and struct, there's no compatibility in sight.

E.g.

  Add a new ioctl (and matching struct), KVM_SET_MEMORY_ATTRIBUTES2, using
  the same base ioctl number (0xd2), but with R/W semantics for the kernel
  instead of just read semantics.  "Officially" documenting that KVM writes
  to the payload will allow KVM to support partial/incremental conversions,
  instead of all-or-nothing updates (which requires complex unwinding), by
  recording the failing offset if an error occurs.

  Opportunistically add a new struct as well, even though KVM could squeeze
  the error offset into "struct kvm_memory_attributes", as there's no cost
  to doing so in practice.  Pad the struct with a pile of extra space to try
  and avoid ending up with "struct kvm_memory_attributes3" in the future.
  Use the same layout for the fields that common to version 1 of the struct,
  e.g. to ease upgrading userspace, and to provide flexibility in KVM ever
  adds support for KVM_SET_MEMORY_ATTRIBUTES2 at VM scope.

> The process of setting memory attributes is set up such that the later half
> will not fail due to allocation. Any necessary checks are performed before
> the point of no return.

Explain *why*.  Readers can usually understand the "what" by reading the code,
but it's much harder to discern *why* things were done a certain way.  Some things
go without saying, e.g. "validate input fields", but in that case, just drop the
changelog blurb (if we _weren't_ validating input, *that* would be interesting and
worth calling out).

> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Sean Christoperson <seanjc@google.com>
> Signed-off-by: Sean Christoperson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  include/uapi/linux/kvm.h |  13 ++++++
>  virt/kvm/Kconfig         |   1 +
>  virt/kvm/guest_memfd.c   | 116 +++++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      |  12 +++++
>  4 files changed, 142 insertions(+)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 419011097fa8e..956877a6aab05 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1649,6 +1649,19 @@ struct kvm_memory_attributes {
>  	__u64 flags;
>  };
>  
> +#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
> +
> +struct kvm_memory_attributes2 {
> +	union {
> +		__u64 address;
> +		__u64 offset;
> +	};
> +	__u64 size;
> +	__u64 attributes;
> +	__u64 flags;
> +	__u64 reserved[12];
> +};
> +
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>  
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 297e4399fbd49..cfa2c78ba5fb9 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -102,6 +102,7 @@ config KVM_MMU_LOCKLESS_AGING
>  
>  config KVM_GUEST_MEMFD
>         select XARRAY_MULTI
> +       select KVM_MEMORY_ATTRIBUTES
>         bool
>  
>  config HAVE_KVM_ARCH_GMEM_PREPARE
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 65ce795c090d9..0d14548c1ed22 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -541,11 +541,127 @@ bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
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
> +				    pgoff_t start, size_t nr_pages)
> +{
> +	pgoff_t end = start + nr_pages;
> +	pgoff_t last = end - 1;
> +	void *entry;
> +
> +	/* Try extending range. entry is NULL on overflow/wrap-around. */
> +	mas_set(mas, end);
> +	entry = mas_find(mas, end);
> +	if (entry && xa_to_value(entry) == attributes)
> +		last = mas->last;
> +
> +	if (start > 0) {
> +		mas_set(mas, start - 1);
> +		entry = mas_find(mas, start - 1);
> +		if (entry && xa_to_value(entry) == attributes)
> +			start = mas->index;
> +	}
> +
> +	mas_set_range(mas, start, last);
> +	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
> +}
> +
> +static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> +				     size_t nr_pages, uint64_t attrs)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	struct gmem_inode *gi = GMEM_I(inode);
> +	pgoff_t end = start + nr_pages;
> +	struct maple_tree *mt;
> +	struct ma_state mas;
> +	int r;
> +
> +	mt = &gi->attributes;
> +
> +	filemap_invalidate_lock(mapping);
> +
> +	mas_init(&mas, mt, start);
> +	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
> +	if (r)
> +		goto out;
> +
> +	/*
> +	 * From this point on guest_memfd has performed necessary
> +	 * checks and can proceed to do guest-breaking changes.
> +	 */
> +
> +	kvm_gmem_invalidate_start(inode, start, end);
> +	mas_store_prealloc(&mas, xa_mk_value(attrs));
> +	kvm_gmem_invalidate_end(inode, start, end);
> +out:
> +	filemap_invalidate_unlock(mapping);
> +	return r;
> +}
> +
> +static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
> +{
> +	struct gmem_file *f = file->private_data;
> +	struct inode *inode = file_inode(file);
> +	struct kvm_memory_attributes2 attrs;
> +	size_t nr_pages;
> +	pgoff_t index;
> +	int i;
> +
> +	if (copy_from_user(&attrs, argp, sizeof(attrs)))
> +		return -EFAULT;
> +
> +	if (attrs.flags)
> +		return -EINVAL;
> +	for (i = 0; i < ARRAY_SIZE(attrs.reserved); i++) {
> +		if (attrs.reserved[i])
> +			return -EINVAL;
> +	}
> +	if (!kvm_arch_has_private_mem(f->kvm))
> +		return -EINVAL;
> +	if (attrs.attributes & ~KVM_MEMORY_ATTRIBUTE_PRIVATE)
> +		return -EINVAL;
> +	if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
> +		return -EINVAL;
> +	if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.size))
> +		return -EINVAL;
> +
> +	if (attrs.offset >= i_size_read(inode) ||
> +	    attrs.offset + attrs.size > i_size_read(inode))
> +		return -EINVAL;
> +
> +	nr_pages = attrs.size >> PAGE_SHIFT;
> +	index = attrs.offset >> PAGE_SHIFT;
> +	return __kvm_gmem_set_attributes(inode, index, nr_pages,
> +					 attrs.attributes);
> +}
> +
> +static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
> +			   unsigned long arg)
> +{
> +	switch (ioctl) {
> +	case KVM_SET_MEMORY_ATTRIBUTES2:
> +		if (!gmem_in_place_conversion)
> +			return -ENOTTY;
> +
> +		return kvm_gmem_set_attributes(file, (void __user *)arg);
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
>  static struct file_operations kvm_gmem_fops = {
>  	.mmap		= kvm_gmem_mmap,
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,
> +	.unlocked_ioctl	= kvm_gmem_ioctl,
>  };
>  
>  static int kvm_gmem_migrate_folio(struct address_space *mapping,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 01761f6e25d25..a08b518cdb175 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -105,6 +105,18 @@ module_param(allow_unsafe_mappings, bool, 0444);
>  bool __ro_after_init gmem_in_place_conversion = false;
>  #endif
>  
> +#define MEMORY_ATTRIBUTES_MATCH(one, two)				\

Use the same terminology as the memory region asserts, i.e.
SANITY_CHECK_MEM_ATTRIBUTES_FIELD.  MEMORY_ATTRIBUTES_MATCH() reads like a helper
that checks if the two objects have the same attributes.

And put the checks where it actually matters, i.e. in the case-statement for
KVM_SET_MEMORY_ATTRIBUTES (again, same as KVM_SET_USER_MEMORY_REGION).  Because
the only reason it matters for KVM is if we want to add VM-scoped support for
KVM_SET_MEMORY_ATTRIBUTES2 in the future, at which point we'll want to use the
same overlay shenanigans that we did for KVM_SET_USER_MEMORY_REGION2.

> +	static_assert(offsetof(struct kvm_memory_attributes, one) ==	\
> +		      offsetof(struct kvm_memory_attributes2, two));	\

And then once these are landed in function scope, use BUILD_BUG_ON() with a
do { ... } while (0).

> +	static_assert(sizeof_field(struct kvm_memory_attributes, one) ==\
> +		      sizeof_field(struct kvm_memory_attributes2, two))
> +
> +/* Ensure the common parts of the two structs are identical. */
> +MEMORY_ATTRIBUTES_MATCH(address, address);
> +MEMORY_ATTRIBUTES_MATCH(size, size);
> +MEMORY_ATTRIBUTES_MATCH(attributes, attributes);
> +MEMORY_ATTRIBUTES_MATCH(flags, flags);

Please put these asserts in the location where the overlay matters.  Actually, I
don't think we need to enforce this?

