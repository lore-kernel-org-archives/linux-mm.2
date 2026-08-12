Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14798C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D9B6B0153; Wed, 12 Aug 2026 09:36:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EEA46B0157; Wed, 12 Aug 2026 09:36:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9186B015A; Wed, 12 Aug 2026 09:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCE796B0153
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:36:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EE931A0392
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:36:21 +0000 (UTC)
X-FDA: 85092716562.06.005E7FC
Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	by imf12.hostedemail.com (Postfix) with ESMTP id DC42540005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:36:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d2vRHB9z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=luX0G3MTORNnDJwp2U7vofbU/y/NLsiMigr2adkX5I8=;
	b=0RTGgj1R1iGgTbYh8OwfYIrIi/2cEPOJYeOaCyyCa/BnuQOuAGJEJ5nolymZoyx87bG2w1
	s5XAGOKiZRyxO8LbA53ndjAdKJaNTnjL9FR6SveU5C83IWUQ9upvga/YvKUba7HMmMEjYC
	muWUiPWMzWNXdXdJ60lqxr1qar0stiw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d2vRHB9z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541779;
	b=xWiu9XFaIl0yTEanfqaYJDvxIwTajb46D4mH+SO86KdLIQdE4BKmYS2biUncqRlIYW2veX
	fopYgVrIBjAe8PuYgID4wBq4IGij1uY8fkQ7laaBcQNVf9Kx+CQTRRRBmwWppG1zJNJbZj
	fE6aynznqiUKo1c1OvjRM2XrgRrPEhI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f598xMR7eSmimv3MnxLaUT+Gq6HxuH8K0zv25XFAJhA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786541774; v=1; x=1787146574;
 b=d2vRHB9zBT7i10peHkepGoOeL8VEDzwRU7lsIlICTR/PVfF5rMYHuuzrUKxQSWV0VuluugQ4
 /8a7uMqQ0QPYQP0cNXepj9XZDanBfSsgNZDeza76CwWF/s5XYc9dDnj9VP0g7zscWzPlnrptaVW
 KGdJna0mj1yQS+CNHLywGKxg=
X-Envelope-To: linux-mm@kvack.org
Received: from mail-qt1-f181.google.com (209.85.160.181)
	by smtp.migadu.com with ESMTPS id 6f8fb3919c433644;
	Wed, 12 Aug 2026 13:36:10 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c15a5b265so228681cf.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:36:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrFtVsIhYuS4ddcde3LXRXJ9EJOWSzbNoIf3M8BRGaXAZWqI/0lSstK6Z9qDxfsV/Hbu3EYy9yjuQ==@kvack.org
X-Gm-Message-State: AOJu0YzU+UZdxj0UWqF3PS8TgwAe4/3Cwpwwna6yIaspmxt7i//upuF0
	0ZVo+1mwAtSa5GfDO4lxkr65nzMWPM40kgjShQ9ZCZB3dFUbJJ2nYbrguu9d34nZ9beoxM6zJ+p
	TlczhzqwClSiigQKsm4WcBiF4J1TSeK5tNleVeqL+
X-Received: by 2002:a05:622a:40cd:b0:52b:4ec6:52ba with SMTP id
 d75a77b69052e-52d61f23159mr20505891cf.6.1786541765008; Wed, 12 Aug 2026
 06:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com> <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 12 Aug 2026 15:35:27 +0200
X-Gmail-Original-Message-ID: <CA+EHjTwn6oyf1vBb+pkBZ5dRgB0EJdSww=sfx2C3t5G-9f_uAQ@mail.gmail.com>
X-Gm-Features: AUfX_mxpAhCLdhwrsOspZt2G9laal9BYruBiB6OcXXxYLlQN_oMXjpKU5WvMAb8
Message-ID: <CA+EHjTwn6oyf1vBb+pkBZ5dRgB0EJdSww=sfx2C3t5G-9f_uAQ@mail.gmail.com>
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7w99kbbjj4h6izeansdgf3ehkytbqwmn
X-Rspamd-Queue-Id: DC42540005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786541775-717456
X-HE-Meta: U2FsdGVkX197MZuU2aT3YUGFW2LYhJm8GY9bpm4N0OgjRCOtx5D/n1JhkNem1GNXTIjzJfn1oCWHyqaByqoB8vOnnLzOnMBtpkFZYHajC8MOHbIzACaoiTpSVTrWElT/JspB3Pu+tdAEXRaWzQsQUTZa4e1MM5IUvVoeTNeE601drkB88qXkl99t/DCkkfhkKsSTVwg8odCE1uEZu9GCmBLksxI1hjdDz2sJgh6bBe5WFFJGdZOAnnj9ly0BxQejRlSdCULOafGak3e7Qud649KsjCpTPBVITFyBrYf92WrZs+G7OZ8A2yNfdgOOljL1PH+oQvzHjj47j2vHBvKsbTPLA+gE4x2qGJAoCTIWNhNIWG3ewmpT/J/GRfjYMubOhgpEPPPrmKc+Vq8FR/xNTzBvDATx2yd+FoNq70wwGIOE58Vjj8BzIMCAczWUDv6B73WMDAeQuVHOLhPxT10i6bkfI8c//cc09znNFWgFRd5PQSrNWaNtkNcSxtIWKkKin4X3UNrmtVwtJwvJodUos/S2pq3bu5iHUJBdTEQGhhX8GvhcjYl1qeNpBpabRQdEC22+2NlOGU9dsMdBDkPO5OrjKgN0lTcZB4221op6DjlgP8y6A6s+vhcxvGZvepeZwJrM1NPNOFxuMsbgjWVI82xP7K4tVrvFuml/D4KB1aaIFWBkPklfXUUuF8G+ppOZuCYIEaVFDw4/GRfxFCsxFiHl21QREO4hAX/yrcdY3UmjGG+D2us86naJNvpWrsgpl7lxo/anwqBBD4uE/H7EPT4vSjPnpmCnICR6Wsii057Hs3iibM2dnBS1Ds9eJ4VH66+qZLlVZmNzbar/9G9mBPdx8yIId8bXSfs6hn1Jdwy2mJMAH49P91y/PuycdrVrhqlYid92xvFLrWLqgolDz1hl391Fvp0vn5OoU9ZbnxYUDwx6b5uB9MbKmygaYMhExlxoqUfjj9GASPpiWCw
 JIp750DO
 jxw5yLPEhJHLG1qdumEnfpz38aQSdeizFMZnIuZHePgN7T3jWMtFZ+amnbdQ0zT8Nmbfy2EuqsoSqNUgo7gFDiG7XImmiTWGGl0ldoSGAZ9hgWDlHRXJwrhuh8MyXC5XwGbLIw+lPSAXmdrk6BGnqhDS7PGS5x+oTb2zGeTRDdB+mln/4l9S1vH3fGNRdAg/82sUDq/FG7TSGcjGKhqUCsah2hVdgHw0KlkT29ESFPM1z5KA4jOUZNjgE82iRucZKqg/JcguRkugDn21Vv+XtbnnG8vkUODAZG7q48JW5/RwBz4+gPT5asuxBanjJy46IKQ9VckFgveD2hjbv41XT6Au3+fuVxmLEIdY0fCaOz7qZecRc+fofEQ+nfJ5sTWFXb5vq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 7 Aug 2026 at 23:52, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Stub in global variable to enable in-place guest_memfd private<=>shared
> memory conversion, which will eventually be exposed to userspace via a
> module param, and wire up the __kvm_mem_is_private() static call to the
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
>  include/linux/kvm_host.h |  6 ++++++
>  virt/kvm/guest_memfd.c   | 26 ++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      | 12 +++++++++++-
>  3 files changed, 43 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 65fbce46b63f4..9477ecebbbced 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2580,6 +2580,8 @@ static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>
>  #ifdef kvm_arch_has_private_mem
> +extern bool gmem_in_place_conversion;
> +
>  typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
>  DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
>
> @@ -2588,6 +2590,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>         return static_call(__kvm_mem_is_private)(kvm, gfn);
>  }
>  #else
> +#define gmem_in_place_conversion false
> +
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
>         return false;
> @@ -2595,6 +2599,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  #endif /* kvm_arch_has_private_mem */
>
>  #ifdef CONFIG_KVM_GUEST_MEMFD
> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
> +
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>                      gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
>                      int *max_order);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 1f1ae61b4878b..75979c885e030 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -475,6 +475,32 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>         return 0;
>  }
>
> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
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
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
> +
>  static struct file_operations kvm_gmem_fops = {
>         .mmap           = kvm_gmem_mmap,
>         .open           = generic_file_open,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a01d336eab18b..0a5a1bee8de0f 100644
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
> @@ -2634,8 +2641,11 @@ EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
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
> 2.55.0.654.g21b8a5bc05-goog
>
>

