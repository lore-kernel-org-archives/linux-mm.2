Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A684C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B1C6B00A6; Tue,  1 Sep 2026 05:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC4C6B00F0; Tue,  1 Sep 2026 05:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D2C6B00F3; Tue,  1 Sep 2026 05:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C323B6B00A6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:11:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BBF1C02DC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:11:30 +0000 (UTC)
X-FDA: 85164625140.02.3D57CCA
Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	by imf07.hostedemail.com (Postfix) with ESMTP id D691B40009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:11:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CCj8aMgM;
	spf=pass (imf07.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788253888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2Kv7QK0kyPV3WXu0OlOV2VBoMn3bi+t0HWUzeFYLhA=;
	b=zNinO/hr0NTcfzGdQ60wK4NRMGXAs3qx4cA7PgyJTDil8L8YOw1dJ31rQWTAaLn1ysjdOw
	wkVZSPm1dUr2/kBMzA6fXxORvrKRzjgGaJE/b+qIaJHQ8CsSO1BI9cvAemJfkclwsoMTH6
	i7Uo0fY1ramQwuUopDuxtn3E4rMbX58=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788253888;
	b=renOMqYe8ENbjAL8G0Fskkz8PqRZiPZqb23Vjan4F47SgKQiVd2/1qbD2BRZAwN76sVhgG
	8J/1mooyW2W7bfEHo8KdySG9W5PeQg7ghwiIn26GEn2iWIlsXdUu4mrdz3yoSIZnVkqKSQ
	GF3Z31Mi8/63cWdkxBuXkPs7ZiHjGas=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CCj8aMgM;
	spf=pass (imf07.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ME/aZcaXqImZ67gDzlYdShBgA2J/tOz88/5XcEiSBwk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788253886; v=1; x=1788858686;
 b=CCj8aMgMt3OcXQUgRt8SDTqDg2+Y/y+2q79zdTBjfVtLVWbHKjFuVWjwx8Kc1SCXGEb0yFnG
 WHAHR0unxTwUIYW63O8rRRwg6pKhiWq+6G5+CezE/3oFGWzbqq3SG6EUSFsCaRXTGpirhmbKVr/
 DYlLt8A7TeYYVndBE+wjMS08=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dd30de1fac62022c;
	Tue, 01 Sep 2026 09:11:26 +0000
X-Mizu-Trace-ID: dd30de1fac62022c
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b5e5aaf7deso6283e87.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 02:11:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByFW2XY3DqHWio8yevF1WrPIVEz8sApb/796gb4ghOIJJFIv5ksbApHd7TlmLm4AB70qr584WeunA==@kvack.org
X-Gm-Message-State: AFuF++li2xot4V8XRrLkIN5N1SpbvR1MvBSGUe9hAGoWHb72VHTX7/P7
	GuEaIXW6WhmNXtgtueFNj1fZerRSBfVIebifkriXLU4A39w67FdF5L+kLiY0skBAUrPkVgDe9iy
	04IOwUyDVXCvMoIl400LLo6YiUj+F0brcuSo6zfZm
X-Received: by 2002:a05:6512:3993:b0:5b4:9dba:4ecf with SMTP id
 2adb3069b0e04-5b600a4e61cmr98369e87.13.1788253884152; Tue, 01 Sep 2026
 02:11:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com> <20260830-gmem-inplace-conversion-v12-9-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-9-85e5fd25252a@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 10:10:47 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwd507PaNQN9uHCgwftqSiVfhKhxSA7QnZVsNGqpNfGKg@mail.gmail.com>
X-Gm-Features: AcwNN1XJVfII0wEJT_6-zHDSSBrs5LG5QpKVzgnh0CqKXLcS-fmuDvdFlehw5YE
Message-ID: <CA+EHjTwd507PaNQN9uHCgwftqSiVfhKhxSA7QnZVsNGqpNfGKg@mail.gmail.com>
Subject: Re: [PATCH v12 09/45] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8iqoyfucemyx45n39eb7mk7ze81c5cda
X-Rspamd-Queue-Id: D691B40009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788253887-364692
X-HE-Meta: U2FsdGVkX186bAQ2aTgC9pGqFyhJz1xL1w2qK0BoFC8lsTRM7SQhke42ZM8GPQr/KUsnxEOHsUP8qE4EpTvOLZUSF2rUrr2sUBuVqWQCS3z0mU7oh7yWVxooReE9uKXrrkuHQmfwWtDYyEP7Sk0E26nHYRmh3RUjNtxGvygQu7Mn9A7DzuGeFZSD5vBTxXxF/d30ktEEoN5p1i5bshPwjZqbQF0Uk7L/FffxTCsYKaAApCiYALgNbwEyN+QggLyNStT032lRnner0j85Mh5hqO9pLNyw9scD0yqUwjbQTzV/kYsAUIFRp2rBl75c/u6h8au6bfMq3M7P8fmBCRQR/Qt6fpz8CJ24Gf5A6dcjts+QyFXP0FWtkl6d6RkhCCoYl465OWnknv0amsBfCn2Xytw52ITDyIuaka/3h3jgHZ7SkhazXfs0hefLYmAQjMjsNGnO5aeqaH1pvnMT2H6FM6bSYAYxn86k7ZfWDD0jZv8qAfDWYQilQkdgKkNVxT89hn3CTaAAC+L2zbN4jSELpn8I54q8KE0W1x97aC0Fp0ahN3qDnXSWju+9g8pf9i5VGCLpEeRr/UyKxr40PWcAB+oiB3Xl8LF/qs7YvmkFbPHFYkOtmLm/W7ODPzL3ZZXO/UmGQnVnRq6dIMJT3LIRDeW770eVap5SFOgMAyBDRdJRAfm7NDvs5Ygm2Qc4wlh0JF0CeG7GW7ao563+wNcViq3thVOiiO6K6V1H/8QNIKIM55hQp0ceBHkgVgw3h3dcXhYEjL73omU8xTA+4Pgj+/2XqPt6dyOy5HI2vUwJ2crM3aOjNyVAMtm6yQFadij1ORYuOyEerv7vV7kGV9TTrwvIUeDHNUDl/N8PecELIKXIsogLAEd14cpKIpzl0RFtOHMeN4qGSt43AB9Kx4JgIL+JCuUTQADbUz28T5uwII95G1pgSWrzHZlmoqFzz32mxn8aqxcos1SZ9SUkIHE
 juCx/CvO
 MGac6qqUfrubPVbcJXa55CPKq1a/Jr4zi+XJuecQ5sPojRe8Nnfl+COmcX429c02rs4qpX4DUOlQd9m+mZ1blGVmM8xLzzEIQs9a1k2mPicKyOAK/ApPEEEsCdExOeYvs78BGzMQ64THi91r9bKr5Niq4vIGfpUm+07pJ0RxgZYc7Y/k1xl2UEFLDz2VcOcoVO9ilWjXyv6A22NKSDyhTS0W5SxuuBa1W4cIhmt9sMCGsJrNBsbeuHLiROTTKk492Cm2cLLSRYE9kZulGu+ZrGF/tRw7rlFqe+mInkaP2+g9N5/sZ/+TDNR3yBlIuyuHwpN/wqGeLmS46rdQOc8ct7ELRdNQjO6+zn+zmwY9J7I2JeZnLTb+rYj2ZahzqKNDs9xPy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Stub in global variable to enable in-place guest_memfd private<=>shared
> memory conversion, which will eventually be exposed to userspace via a
> module param, and wire up the __kvm_is_private_gfn() static call to the
> guest_memfd version when in-place conversion is enabled, i.e. when gmem is
> the sole authority on private vs. shared memory.
>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  Documentation/virt/kvm/api.rst |  7 +++++++
>  include/linux/kvm_host.h       |  6 ++++++
>  virt/kvm/guest_memfd.c         | 26 ++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c            | 12 +++++++++++-
>  4 files changed, 50 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index e0430cc750c9e..90a29424c54c8 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6382,6 +6382,11 @@ KVM_SET_USER_MEMORY_REGION2, e.g. shared memory can be lazily mapped/allocated
>  on-demand.
>
>  When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
> +userspace_addr vs. guest_memfd, based on the state in guest_memfd, which is the
> +sole authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD`
> +to find out more about the creation-time shared/private status.
> +
> +If in-place conversion is disabled, KVM selects shared vs. private, i.e consumes
>  userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
>  state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
>  is '0' for all gfns.  Userspace can control whether memory is shared/private by
> @@ -6429,6 +6434,8 @@ the state of a gfn/page as needed.
>
>  The "flags" field is reserved for future extensions and must be '0'.
>
> +.. _KVM_CREATE_GUEST_MEMFD:
> +
>  4.142 KVM_CREATE_GUEST_MEMFD
>  ----------------------------
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3579feb631775..b0110143d2ff8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2580,6 +2580,8 @@ static inline bool kvm_vm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
>  #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>
>  #ifdef kvm_arch_has_private_mem
> +extern bool gmem_in_place_conversion;
> +
>  typedef bool (kvm_is_private_gfn_t)(struct kvm *kvm, gfn_t gfn);
>  DECLARE_STATIC_CALL(__kvm_is_private_gfn, kvm_is_private_gfn_t);
>
> @@ -2588,6 +2590,8 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
>         return static_call(__kvm_is_private_gfn)(kvm, gfn);
>  }
>  #else
> +#define gmem_in_place_conversion false
> +
>  static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
>  {
>         return false;
> @@ -2595,6 +2599,8 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
>  #endif /* kvm_arch_has_private_mem */
>
>  #ifdef CONFIG_KVM_GUEST_MEMFD
> +bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
> +
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>                      gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
>  #else
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index ce5efcacda36e..cd966eef45b69 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -478,6 +478,32 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>         return 0;
>  }
>
> +bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn)
> +{
> +       struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> +       struct inode *inode;
> +
> +       if (!slot)
> +               return 0;
> +
> +       CLASS(gmem_get_file, file)(slot);
> +       if (!file)
> +               return 0;
> +
> +       inode = file_inode(file);
> +
> +       /*
> +        * Rely on the maple tree's internal RCU lock to ensure a stable result.
> +        * This result can become stale as soon as the lock is dropped, so the
> +        * caller _must_ protect consumption of private vs. shared either by
> +        * holding guest_memfd's invalidate lock for the entire duration, or by
> +        * checking mmu_invalidate_retry_gfn() under mmu_lock to serialize
> +        * against concurrent attribute updates.
> +        */
> +       return kvm_gmem_is_private_mem(inode, kvm_gmem_get_index(slot, gfn));
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private_gfn);
> +
>  static struct file_operations kvm_gmem_fops = {
>         .mmap           = kvm_gmem_mmap,
>         .open           = generic_file_open,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 78278730b2ae4..46d2e123448c2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -102,6 +102,10 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
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
> @@ -2423,6 +2427,9 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>  static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
>  {
>  #ifdef kvm_arch_has_private_mem
> +       if (gmem_in_place_conversion)
> +               return 0;
> +
>         if (!kvm || kvm_arch_has_private_mem(kvm))
>                 return KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  #endif
> @@ -2634,8 +2641,11 @@ EXPORT_STATIC_CALL_GPL(__kvm_is_private_gfn);
>
>  static void kvm_init_memory_attributes(void)
>  {
> +       if (gmem_in_place_conversion)
> +               static_call_update(__kvm_is_private_gfn, kvm_gmem_is_private_gfn);
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> -       static_call_update(__kvm_is_private_gfn, kvm_vm_is_private_gfn);
> +       else
> +               static_call_update(__kvm_is_private_gfn, kvm_vm_is_private_gfn);
>  #endif
>  }
>  #else
>
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>

