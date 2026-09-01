Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1164C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 10:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3486B0113; Tue,  1 Sep 2026 06:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D6B6B0114; Tue,  1 Sep 2026 06:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0148B6B0115; Tue,  1 Sep 2026 06:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C07F56B0113
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:13:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 473841A039A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:13:54 +0000 (UTC)
X-FDA: 85164782388.18.C1F2267
Received: from mta1.migadu.com (out-246.mta1.migadu.com [95.215.58.246])
	by imf04.hostedemail.com (Postfix) with ESMTP id 09E8F40004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:13:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PG1qq73J;
	spf=pass (imf04.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788257632;
	b=eUKuvHhJ/m02EruGbHSOQZu3fTmAdzHE/pJuS0GAQP6imDflyOD94Ne8n50RdA/BXLEhTN
	lBpPi19aWlO7kBWiKgPchNRntepgCyksydnZDVRoN3CA5frs/sVVeERrnwMCn27AgQBDj+
	ftYSX99HHtKGNxx/Qxk1BrjCMe+Ryvw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PG1qq73J;
	spf=pass (imf04.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788257632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9I9racrnTD3fpjaUblLIskhLJSwIiGVV1BuJmxrJ6M=;
	b=v6li6lvF/CEV90pZ7xiS0oWj4It30tQJUQKab+OnONzTnG0FZ3zuAA2i9Ds3lV3XbQCsnE
	ks6EZBs5cz/+f01DzaUD6KPJa7RH/Jf2JW9NJ7ljM0TtdDeubYzqOozAbtxzv45wB57VdU
	EN1AOWhvDX1wynaFvLn0Q3WhJkfQ/nI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AVdE0MD+h6o2Np6u6CwnfB0M91U/Y/LHHzhpZ1Tty+I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788257630; v=1; x=1788862430;
 b=PG1qq73J/gbFs2XAVqm2eIa3SXXB8e9HswXoJCBJUTWfzCUxMR81+m8pPiKsrZM6SVWOr1wv
 8sEFzyz/mpZCgDKMbp1Tkl23K4/o1A/gJebCLQM394no3n7trkE5uj9/r1mmyvP11smM2r4RW0f
 8bJVz/zJ25Qyh5RKjpJ18o3Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9236ed423ac78f34;
	Tue, 01 Sep 2026 10:13:50 +0000
X-Mizu-Trace-ID: 9236ed423ac78f34
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so6493e87.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 03:13:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByb/2P0GR25ah9tRl4APOuCnyyXQnoPWNcmyZrbGvTej/6DrKtu2zTBDQ9UU6UW2Aa2LDjm8M+AwQ==@kvack.org
X-Gm-Message-State: AFuF++mc/VXBgFJ/T5Yx9jk28Q3zJ0lRe8krK32iwOETI3dGXdwss1pu
	3N6r5WTyfS3QvEVL3lGCUVtl/dZaaTCdTSgwY6TMtpQcB4LQME1U5bB5avdf2x44r1L1ULrgEPX
	EAvKSPJpdt/FDI7Ieka5MZ9vlj3UKcpI+eOG2wgbJ
X-Received: by 2002:a05:6512:3e0c:b0:5b2:a5e9:3aba with SMTP id
 2adb3069b0e04-5b5ff28cff6mr137091e87.6.1788257629010; Tue, 01 Sep 2026
 03:13:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com> <20260830-gmem-inplace-conversion-v12-12-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-12-85e5fd25252a@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 11:13:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz5phoUdE9W_FY846p9hUSu+dGtnz4JMUFN3eRxpjVQGQ@mail.gmail.com>
X-Gm-Features: AcwNN1VxSYWT9NZrhIzgE-QIHtarTDbXrfKaWL85aQCa702UGFBp2Nv9VWlrElc
Message-ID: <CA+EHjTz5phoUdE9W_FY846p9hUSu+dGtnz4JMUFN3eRxpjVQGQ@mail.gmail.com>
Subject: Re: [PATCH v12 12/45] KVM: guest_memfd: Always fault from guest_memfd
 if in-place conversion is enabled
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
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 5j4qsceuy5t8yhzyijst7rktizjc56xf
X-Rspamd-Queue-Id: 09E8F40004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788257631-407125
X-HE-Meta: U2FsdGVkX194YsdVk9AYrGSJ6V9xXeAv9sxVUyzbXBOr52N45DqhEShBQ92SghqXKI2cq0Qkd13IZv11ZVuDgm6QDAap4cqL/c6zebaf9QmHBwuh+k5jOQLPazDb8izZS/x3N5oGksMPGpYUiEemTcUlVq6ZmV1L+hO+sSeRGzjHN+IVMxbsxiyq9GgwDNIjldo37lw276sWJmXA8StJ12BfXP6wT5TMeeoYEI4WAtBfnoJieWabEDwDhntJXcQ2P9WvWCcnoWEcNic/5E7aqZV+7eTYQITSE55hqLJi9TOvZHdhLsp16leeA97XfMO6s53vvu+n8ySIItXcpsyUqw2PSxGqun/eTaXoGU2D+UUvcPNrUsdyqK9uKUr/xb/n6m1Y2/i5dscWJBZp50j1m+1ADCt2IhG8M7mjKhUFBJvJUTC1IsD3H9vptSZX2grrhKy+C1l401FRPHSRaZiirff1jagD+b9rACuFbVD3IBzMsVduiN05AZ9UsMnZTaOrQJiIH/xOdmFQIv0PJStSrk2GCB2gQPV4ZtgQznqLYfbjrn2/pXUxbXVPZgWZwcloRWuu0GNsa0tHqc9i0FydysFnQk0HNB/y2WnyN1zsvOVIuyiAwPbDztUCT001y6nd7qIWfncDTOup/9LxoCvMxdwhaNy3yh/lorCrleHC8Vw8ilFPILnFkFD6OClzbga8xa75N48NRZnf7+rjNJLZxCB7gEZrNKUrLCwIFbtUR5uaZ5XMPznciCVNtCOtfPAeExPpmZ/Vz0QgY6RHfK4pwr1vlSQmhfks36r6+Me+snSjZs0QsUfkPnvyXvWIMEMTpHn4gofTcf13/2HYdi42JqreGulFCN4EVsTFsyoecJeux0zjMEcAzcyz6vmc/PorHbg015HwLuvnBHeaUx9Hsq4j1qrFr0Y0KAnlgzvzHloSoR3Qa//W8B8xoFv0LjusWweHhQhwatVkEOdOoqS
 by8CRHAh
 MnwpBfeocsO32IcjZ1YV+tcxHzrWhsjWC143T1NqBneu/DAvMLT/V2ND4vJOqgnx8DuiH4joi+5MyKuNbsp4JoY7pGtGsvDutbUtROtzz5ODAfryuds9hwX8Kw7WWZnFJcYbC/aVXC1cAyG1zDYbUORb3QUhpks0kiWGxUn+gcMCZ+T0ssS7NAlPvcaeoVLOc7w9u3zeufMSc+BrjkzLLhwThM1vfYPP8tWNBaR1O59lFXhPWOeNt9q2+Z6iB5OFifbb3nIb0UJY0K9xZePXVHiFH2dU3/LlR80TsmXYM41t7bIK9/NqAlJWITqDKyNncmgjxULh8hkbXqwwWhCpj5aY2YtU9r64eS1bdw9lLUagohLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> If a guest_memfd memslot is created but the guest_memfd does not have the
> GUEST_MEMFD_FLAG_MMAP set, KVM still fulfils guest faults by looking up the
> memslot's userspace_addr.
>
> Set KVM_MEMSLOT_GMEM_ONLY if in-place conversion is enabled so that the
> guest_memfd's memory will be used for both shared and private memory. With
> in-place conversion, guest_memfd will be the only backing memory for the
> memslot.
>
> No validation is performed to require userspace_addr to be a mapping from
> the associated guest_memfd because even after validation, userspace is free
> to remap something else at the provided userspace_addr.
>
> userspace_addr will still be used by functions like kvm_read_guest(), and
> if userspace_addr does not match up with the corresponding memory in the
> memslot's guest_memfd (whether userspace_addr points to the wrong offset or
> some non-guest_memfd memory, etc), that is a user error.
>
> Requiring both shared and private memory to come from the only associated
> guest_memfd simplifies invalidation in stage 2 page tables. On a PUNCH_HOLE
> operation on a guest_memfd, the invalidation is now guaranteed to be
> invalidating only memory mapped from the given guest_memfd.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  Documentation/virt/kvm/api.rst | 22 ++++++++++++++--------
>  virt/kvm/guest_memfd.c         |  2 +-
>  2 files changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 90a29424c54c8..668886f50024d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6381,10 +6381,16 @@ mapping for userspace_addr is not required to be valid/populated at the time of
>  KVM_SET_USER_MEMORY_REGION2, e.g. shared memory can be lazily mapped/allocated
>  on-demand.
>
> -When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
> -userspace_addr vs. guest_memfd, based on the state in guest_memfd, which is the
> -sole authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD`
> -to find out more about the creation-time shared/private status.
> +When mapping a gfn into the guest, guest faults are always serviced from
> +guest_memfd regardless of whether memory is shared or private.  KVM determines
> +shared vs. private based on the state in guest_memfd, which is the sole
> +authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD` to
> +find out more about the creation-time shared/private status.
> +
> +userspace_addr is expected to be the mmap()-ed address corresponding to the
> +right offset within the guest_memfd. Any mismatch between userspace_addr and
> +guest_memfd is not validated and is a user error. userspace_addr is only used
> +for host-side guest accesses such as kvm_read_guest().
>
>  If in-place conversion is disabled, KVM selects shared vs. private, i.e consumes
>  userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
> @@ -6490,10 +6496,10 @@ specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
>                                 page tables. Private memory cannot.
>    ============================ ================================================
>
> -When the KVM MMU performs a PFN lookup to service a guest fault and the backing
> -guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
> -consumed from guest_memfd, regardless of whether it is a shared or a private
> -fault.
> +When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
> +always be consumed from guest_memfd, regardless of whether it is a shared or a
> +private fault (unless in-place conversion is disabled and the backing
> +guest_memfd does not have the GUEST_MEMFD_FLAG_MMAP flag set).
>
>  See KVM_SET_USER_MEMORY_REGION2 for additional details.
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 0afe1468d2d9d..e41802944756b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -746,7 +746,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>          */
>         WRITE_ONCE(slot->gmem.file, file);
>         slot->gmem.pgoff = start;
> -       if (kvm_gmem_supports_mmap(inode))
> +       if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
>                 slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
>
>         xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);
>
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>

