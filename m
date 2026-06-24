Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2467DCDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 18:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13946B0092; Wed, 24 Jun 2026 14:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3B96B0093; Wed, 24 Jun 2026 14:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D649C6B0095; Wed, 24 Jun 2026 14:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC89C6B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36DC540466
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:58:09 +0000 (UTC)
X-FDA: 84915716298.14.1E6958B
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id 453EF180017
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:58:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CmoNXtPy;
	spf=pass (imf16.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782327487;
	b=cmQr7+cCaLwOdrnd5ehwNvxkv36qsdLTpHv7vSRzEjNB1cPlrLGzj6pVU0iwGDGQOk/cga
	KrRfWZZCjC+/AM3I3f1pA+Tthm/mnEPfa6VUc2khdkfy/dqKuyQ36lN0bEnqb30AnewRpO
	EkKIgEyTM9CukiDbsH4zfHM3SdNL0Bk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782327487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYP2MIWClSeA6+M0aw+ZhWTqj4KB8PioFvb0d+sMqRU=;
	b=oRP02ycCR/27mhvcyWMiF1Jf1Uf5RSP4nLhqv78K0pWL+ygQPou1FSNw+jh8sTuwvoXt25
	R+cr+lOz7ecTmqxb9g1hSb2evym4Hs0exMxBRjDC9sRQ8Nmzpmm1B3jL0PmZtslXN1bERl
	+3O9D1ZFiCaz4c0dAfxMNuiEE9QIp2Y=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CmoNXtPy;
	spf=pass (imf16.hostedemail.com: domain of tabba@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51765531803so36681cf.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:58:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782327486; cv=none;
        d=google.com; s=arc-20260327;
        b=Y7dsv2PLOweMZGaJEdePZb7S1FET6ZgjqmkprXuLBgMmLrRWwlxe2LkMiDLXBdVMpX
         XNa5rRs5z0qFkvLbrXWrOxPBdjAqt/BvqxHXsIJoc/KKve2v7dA+RJ22wZXNK6FLy2vq
         4WoVRNsGPLr+2ia9vh+FcHssxdRx/vOxGY/Dze/TdQvj2Nln/5tGLuJRG+WxPvtZWU8p
         wFt6wRUVE2nCDDlJf0jU6gUP8c6ozNNR9MRprsLcva1Qdjhkc7qQtbHuoYIvDZ/Bvr/0
         oA0c69DmwfrMKO8NclCYaH6QOFR4dDso3wzaixrCCGHlCzDVzBwb7F9HmsGKaTHiPQFI
         7h6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lYP2MIWClSeA6+M0aw+ZhWTqj4KB8PioFvb0d+sMqRU=;
        fh=8xf02sAqoec9qj9BDlfykuScJHv7hcmiCukr/nsp3SU=;
        b=UcMLoJXhI1OZxxC8Tg9s1Ya5TOqI0IBClsFm1txeiWUsYUQajB5LaFqcQcvmO4hO7Q
         WJzU7rSmPsB7HTcoRQ7Yxk9ZahfknB8v2bPI/iUy+GIQ2yHOKHMFrCxYs1a3he6fmYyo
         tgA/ot3bY383CkWd4mWUu2Wyf8zI+U4oW0DZrspw412Iew0i70xtm6lf5TSeGOmQfLbn
         /2cPURH3GqNys4p6EB/OEovjvDxU5bLd8WPYXbMdXeje2yegx9XN1asFX4lX5dfAljYM
         Rn23xgvQI+Eobo7muMl3FYGpOML91cvLJJFMLjGwEdMlTW8lWpnEMhYdHnttyHhT25D8
         4Xmw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782327486; x=1782932286; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lYP2MIWClSeA6+M0aw+ZhWTqj4KB8PioFvb0d+sMqRU=;
        b=CmoNXtPyeke/jrS8bgdTOS430U29Gsr6OZ+AzZfXPqYRoYXCaoQiG2EJ5+SDB14Wj8
         3nklhrUWKVrH0d8eUgxrm3HeZrGh1OsAjGqC70DTxd9QNeGNcskd0gmF2Up91tfxDILX
         eN6XyZ4m93Go/XKIJoAIPNLrV9+FsU8K0FmYx97GL/kz6B6GLWX2kpqcIOp0E0SKkVZS
         5sg71+U8VtNwRewRR9HAqFfLwCKV0ET4jaPvWD2D1g4kwv1O+IjvHLVOZPtTed0M4e55
         J05LSKKl+IdcIl1Sm5OePp4Cf2mOTCvAPfApuZX5Qx8AqNiiwCQIY8ItnBp49OIAxsUj
         dbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782327486; x=1782932286;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lYP2MIWClSeA6+M0aw+ZhWTqj4KB8PioFvb0d+sMqRU=;
        b=cWG6NsVauP2LKI4FgRkvo3azLcRFLaD7vkQOluFqy6WtSMZwJ+WGUjY/zBvpEDgyjI
         x0HrGr/X4KP9Dbo61nl5cVqD3M3BoyeYu6gpq42ky+xhywzggT06IJQk6l0BDaaU8OTd
         meNWXG6njngGRU8tzEwDWLvQ5QVowGoGK0sJcdEv+MfZ1diunO5oPJe4ZQxPolKBKEUg
         6YwvIY7GDAAOgp0DxC9g1UJx85UOqnbC4iIw5cHECiSwpXDXDprZuko2J++Re3/+d4Ph
         FRdYBB93+zXaBFWke35cHSNVAWNph7PyQdC3Ot5i+pDBMOqUNAtmzAuga9FrPC5c3Gt9
         TuRQ==
X-Forwarded-Encrypted: i=1; AFNElJ8tSHX3Dv2exx0PzVGIEp6Up6kodUvY7NngL7W9smWYA/i+66VVvyqs+gwa1tEbrw8pPJiOIRWG7g==@kvack.org
X-Gm-Message-State: AOJu0Yw9IFSMDJjYXrvKgsYXZT3r1zaWc4B+2Tfb3TuD3K/uOvIoms+/
	2Qyuf4QQLmQrExWh7wqZ8H1kMTI5Xy6C9FMlQBeO29okfuADyX9UkyJHcQfNnYuj/luzQ3KPu7Z
	cMDr5rf5cCrxntep6yvjGDCtakU7dnV3gh5k4/JRh
X-Gm-Gg: AfdE7cm0Fjn4FN8yAShsn40qqVaXz9FtNsWBqSvyn1hZ7hRMpPmD83lbte16sNeR17X
	lfnLL+k1G1YxivSmEbkexadjyvnygSNdK3mUbSgE9ysI1gdeYQJP3iBmhFfpw8OVFIGesXWas9m
	gnfFuZnSv2kWf7q2j13Wgb6D4HKNl8sqrc43DVjvla+5Dhuqectl3ls2Nq463OmT6BhvzOs9e+z
	d0cBaOVGa/RD4VfkG27GquDxJr0yj84oulmdpOBbhZqYmYE0eFFaLP7gQHyG71ucWkvO9CX8bEu
	5f6d+Bvy
X-Received: by 2002:ac8:7f51:0:b0:517:5ac7:332e with SMTP id
 d75a77b69052e-51a6e99e871mr1220721cf.6.1782327485393; Wed, 24 Jun 2026
 11:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 24 Jun 2026 19:57:28 +0100
X-Gm-Features: AVVi8CeYyqolczp9quGS2mTDT-o2xHvKCexfoBhgu9RXIzSIPhnTHlePhYz9Iw8
Message-ID: <CA+EHjTxUeGt1XR=7MEsGnHC7agndtN2O+N=4+4iQ+a48vPWP8Q@mail.gmail.com>
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the default
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 453EF180017
X-Rspam-User: 
X-Stat-Signature: mpw9ipmrbqwu51aza4xhqwoihe11w5et
X-HE-Tag: 1782327487-531224
X-HE-Meta: U2FsdGVkX18QjgCSNcro7ah2GcvxjYrqU0Dmc44rBv2JWdHfPCwlMflAcsHFJUwCKmywg6gcDBcu50XAhNW1yMfRzQiuJEA+Z/wM4KCN/iWUUZcxIf+KV6QxS+9gOjjtW7GfC/7IUddfSNgbL81fRmlULXs4PVAGjQ3FHb9GxjH+3jRd9B9eiDfEg/6HKP1FwlZL69QJp0aoG3rCa8NblTYpQTpHvmjhfYCv+HPGMyLmNdeZydOnyTWt4PMqcLpyZ7BXMAOfRGMf9yLrAK93I27NJiJu6dgGZmYg0QsRYQk9dJ0cWi0Cih51I6baWtNQcMMqM4YJe7ehf7tStQ3YPBHxUcNkncSSI6C6NXnDltvnMX7/ArTzJLYnxbeYMHs4X4yfz16/VYfiXognr368qpEIFVU7YE14tksN3QzGtX3QDmu2W8OYHA3M7IPBA8TXAY0NiFfjjKGO9aElACFG+d0da3EJIR0csbbb0sBmNMZsAuuEMZOiBqKamBFSYKuhaZ6Y9bquGIpt5ik3nE+Y/kpQl9tWW3JjetWU5r/sa5bJD6Y/IWE0vgZdwvrWm4sVhVBky69FLi9568AeXXXDtJNjTo0K9zR7tCo1KLRevepshqDKKyZjFd8bk9mKs85yWNIwH3mFUSJFSzf0sJtBcTsHoCsRmtbiMwIDljasAwNV7CoAhRte6oktfR5h7NkYLP+3KZ1b5Yt+oemuoxt0NHGtF3GL9keCrX21j1d0V4AvUzsYifQUv70MYJ6+8jzorNuCew3UbkubBKLpZIfbBfMQ9Ft8/jJfE924qIO0vTbwLaNcQSC5xUZSvbmiVhe9DO87RXQ9FosC+YebtOP63cBN/vlIIYd4nV2DGFmRf+aR8K06SehDojTXAaxi+tUIbaLpmOWNKvHAvSJgbF6H8wKFHtNozTIhCiV4zETXvfdElFGeVhFFLdQ8GkijhRZ6B3mzPZ0KKk50z7kGRuW
 0/0EBRZf
 eWfxV9nI91c5Be1LhVbV9SHF+z1RJb3M7CGCEG80hTST/7hTkSRrVxCbgI3saZIsZPMP06nr0O1mLqWt+yxwhLXKQw32Or0I7COK0YaQ/SEC91SHB/jyHhaHEVgC3ov1I+j27e9Qat/KvOxpXl/JenuuFckWkLRvhj7xH63NSEqH2MwjuQn3S2up+FSZENWrp/WEcAtoRDiGjeDr3nhbCwMaHLhaBucN8k10U+/kIk6SDYeX6lGnSYQ8xN8or5GFq+4HvJoijZFApOAUEOvgp06y8HqU2LCcXdI1jYrlj21O4YgNc/KR3W+hED1yGKwhfaKv5PWjqKceV3i0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Make in-place conversion the default if the arch has private mem.
>
> The default can be overridden at compile type by enabling

compile _time_

> CONFIG_KVM_VM_MEMORY_ATTRIBUTES, or at KVM load time through a module
> parameter.
>
> In-place conversion also implies tracking a guest's private/shared state in
> guest_memfd. To avoid inconsistencies in the way memory attributes are
> tracked between the per-VM or by guest_memfd, make the module_param
> read-only (0444).
>
> Document that using per-VM attributes for tracking private/shared state of
> guest memory is deprecated in favor of tracking in guest_memfd.
>
> Warn if the admin sets gmem_in_place_conversion as false when
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not enabled. Add warning in the code
> path where guest memory is populated for a CoCo VM, since that's the
> earliest point in a CoCo VM's lifecycle where memory attributes are
> queried. Unlike other query sites, this site is exclusively used by CoCo
> VMs.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

> ---
>  arch/x86/kvm/Kconfig   | 7 ++++++-
>  virt/kvm/guest_memfd.c | 5 +++++
>  virt/kvm/kvm_main.c    | 3 ++-
>  3 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index c28393dc664eb..a3c189d765150 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -85,7 +85,12 @@ config KVM_VM_MEMORY_ATTRIBUTES
>         bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
>         help
>           Enable support for tracking PRIVATE vs. SHARED memory using per-VM
> -         memory attributes.
> +         memory attributes.  Using per-VM attributes are deprecated in favor

nit:
are->is

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad





> +         of tracking PRIVATE state in guest_memfd.  Select this if you need
> +         to run CoCo VMs using a VMM that doesn't support guest_memfd memory
> +         attributes.
> +
> +         If unsure, say N.
>
>  config KVM_SW_PROTECTED_VM
>         bool "Enable support for KVM software-protected VMs"
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 86c9f5b0863cb..5cb73543c03c8 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -1193,10 +1193,15 @@ static bool kvm_gmem_range_is_private(struct file *file, pgoff_t index,
>  {
>         struct maple_tree *mt = &GMEM_I(file_inode(file))->attributes;
>
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>         if (!gmem_in_place_conversion)
>                 return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
>                                                           KVM_MEMORY_ATTRIBUTE_PRIVATE,
>                                                           KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +#else
> +       if (WARN_ON_ONCE(!gmem_in_place_conversion))
> +               return false;
> +#endif
>
>         return kvm_gmem_range_has_attributes(mt, index, nr_pages,
>                                              KVM_MEMORY_ATTRIBUTE_PRIVATE);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index dd1d18a1d2f68..46e92b5dc3804 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -102,7 +102,8 @@ static bool __ro_after_init allow_unsafe_mappings;
>  module_param(allow_unsafe_mappings, bool, 0444);
>
>  #ifdef kvm_arch_has_private_mem
> -bool __ro_after_init gmem_in_place_conversion = false;
> +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
> +module_param(gmem_in_place_conversion, bool, 0444);
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
>  #endif
>
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

