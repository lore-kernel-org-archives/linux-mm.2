Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF133C624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3EDC6B012B; Tue,  1 Sep 2026 07:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16FC6B012C; Tue,  1 Sep 2026 07:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05116B012D; Tue,  1 Sep 2026 07:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 979786B012B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:03:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 239BD4039C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:03:43 +0000 (UTC)
X-FDA: 85164907926.15.6C9A62E
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf27.hostedemail.com (Postfix) with ESMTP id E723B4000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:03:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F1as+mic;
	spf=pass (imf27.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788260621;
	b=uUlyxqlorKQMv3pVMrYeXvr1/1MppU7uCY4E2tWG5iMcI/jBbdmZSIGVRZxtwltdW9DJsU
	P6wb3OeQIz3GsqctECa3AF7imSsSrpzfU47gbcLDSgYmwtI4P21YrW9l0CVbrS987Vaju2
	2BfSKrZwAckg1cdstpUNdiQROX2oMNc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F1as+mic;
	spf=pass (imf27.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788260621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEzwgMl4iLqFrH2ADf+WPnCKB+JCnUz8GPly99SUtUY=;
	b=u3t3reJEeaJ+lCJ8pAC7R1x+grPtgl0sfxIYi6xhKvq4YUjBf93T1PQiLA9PmXXADfSx+i
	XqAot0sLcR/nO+77XKHNP7jAFXDTiFv7ID0IGs6hftq9BrXV9iZ7eejY0Abmc/QYR5mIKT
	8+dGTMQx7o1pUGN8lmG47TyLc941jg8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WyDimoZKuyTxJfpwGX971Wvc9+oQiBDBINkGgnAGP8g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788260619; v=1; x=1788865419;
 b=F1as+micvUwELvOYjiN7y9du23+ocEWuRXgk9BCSaVTfljwe38BUD4NuqcyJGLY7yWsfiEUx
 7pKUxNt4PA2fJUl/IKtQNncraBmsG0880r3NmYkY+lfmlUIZm2xUSNIrpwEDkCc3dcfKrFgP6oj
 bQ8GAh2noqUmltZE3+oo944g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ca22453309d83ace;
	Tue, 01 Sep 2026 11:03:39 +0000
X-Mizu-Trace-ID: ca22453309d83ace
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b2a8173142so4674e87.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 04:03:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByO6KqHkgamNM0ZvKJIMRNNWg1bU6dhZlFxfl6xltcdTDI9PcFQEbFhXzl2NPhShFfhggG6Hs/EGQ==@kvack.org
X-Gm-Message-State: AFuF++lDo6J66L2FRh18bQzQcRTA/PLpqGwdoS2BYNtydTCKh5MU7KMA
	JN88qw/99EtBOxUA5+j06Ya4H4YJesya8czPBK6daqQ7xiRIR4kiQmqUnUB+RkWGyR43MPtCI/L
	FQUYEOzApbFufKOuLPmLCKRP3oSvr94Hy2llXdsON
X-Received: by 2002:a05:6512:b8d:b0:5b2:8963:e5d4 with SMTP id
 2adb3069b0e04-5b600a42bd7mr115293e87.5.1788260614031; Tue, 01 Sep 2026
 04:03:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com> <20260830-gmem-inplace-conversion-v12-43-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-43-85e5fd25252a@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 12:03:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy8-Otz2NpetF=GsgZ=PQ10KHuHhGKtDmi8NG9skDZP_g@mail.gmail.com>
X-Gm-Features: AcwNN1XpQa0y8jS48DZXcNiZMD0Nb3-aLRIoorwIpEndtCPmsJSxZZnT6oLYZmg
Message-ID: <CA+EHjTy8-Otz2NpetF=GsgZ=PQ10KHuHhGKtDmi8NG9skDZP_g@mail.gmail.com>
Subject: Re: [PATCH v12 43/45] KVM: selftests: Set up page size and alignment
 independently for guest_memfd
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E723B4000A
X-Stat-Signature: ib6jiepern5713qpgsagkx6pf74zdjso
X-HE-Tag: 1788260620-653301
X-HE-Meta: U2FsdGVkX1/eXyatvVtkp7WlcVpnFwsOihTxrq61Fe5gu50hByJql7YxgaY7i4HVN21Z9AB193DqNaHHiocM7r9SsLMCeaU/1BluIEHHRbpM70PZsXsi0E0mBfQ/gns0euLxCPHgCZwqnYACiF1EAQfbruxBdP6YBHVb/l8USeoazOCbh7JkdRGUgR4r6avTMksG5bUd8ynZLaWqWf42QWNP6nlk7eGCtt/j6toIUWiXgHtXGzulmS2QAc5ufdugCNFZOLwpJ5wUXfGd7tsefN5mhPR1FLCH8kPOD1DWIhkvGKwX4/vkm0JJ70b5EdW5ES5eofYiRPyrfgsl1EGGCb66IbWdHkFbiMAY9GbyRAl7j6h4pTNWOfNjIBfRbMwmRsRsv6ytNerw+95TnOPFpL7oOGkokzSrh4U3N0LaWCQNvXdBphI3lI57cfrjX5GKYLyvEkAbgpu47mk4jcrgHiDz7k5Mk7AX89NaJKhFX8du+l7Y/GC1lJ0Bb/lrf8oi9sqABEE+GXhglAx/johdR22tB+4JciSCmWFKwAIagALV49tZI2/sF1VZIVnuGTLeuygqrOlMCNAHqTv5ANwQ/HEYQ0b2PJ2t4Rz4bFaLoBoKGaN1Hc1T22gRIS8OMs2SFpZ4+NIKZvO+871RIlL1rI34ik/3v/KdMYD1xCmSzcy+gdd8LGTsBiZYp3M1Wb5p9y9vKlTc3ARl7lHLXY/I4NOJVPZQINklnJgdXwRqrOp9uqA4KLC6ahNTPKQGRE0aT62aZM4mEmWRSdXRAuiS8wbu2mNswZpABnbd4qbzSPoxvEn68lCpOcllvILMkAgwtOSuk/Yw900sh3EPcrYzeQ0l+hlC1URhYLYqHuAp6o6Eb9ZNbrBjCGYJudCnl6BSoGR6SwFQeTmtked0wzzticLhyOVxWzo3W8eHljT7iR3mxTkurWzJJF+2m34khjEz0a1pSEornQLpFfrA7gd
 CTJ41J5I
 RXKPn9IGvUPkEjVN1FkFS3ikhqBDEBSfe+tI3Cqi3aMCU4XDCNcWmik7+ZwEySiMB8mmwYddP64j/Hr2t1kUx1WYk/vxYiaVF/6H4jeDKGgmY0jyZmBaFz/zD+hEy5osdWmOCSm0RtV0NXWgm1Is5hIjYw5cfQqziA0N8tBmdMMMdRrXIKWkIWtu+VF4vDpuqqWJo6VCtMa6YNtKNSv35G6iQEZ6I/t8H27XZSjT1YT8JgdY8McEiKpR3hO/teroGuvj2AwRp9TVRsOoQykbc6ZIL8pAnPalyY0vSjq6kGcmyuLslhmCl3D4koaZtP1O8Uzp8QeDXSQnPnIhxiHM1UTNza+SgvOSqRPf3Xg2JUL6TZ9Q=
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
> Currently, vm_mem_add derives the backing source page size, alignment
> padding, and mmap size from the backing source type upfront before checking
> if guest_memfd is being mmapped.
>
> With shared memory also mmap()-ed from guest_memfd, the alignment of the
> mmap-ed address needs to respect guest_memfd's backing page size.
>
> Refactor the backing store setup to configure the backing source page
> size, alignment, mmap flags, and mmap offset directly for guest_memfd
> when it is mmapped, ignoring the backing source type.
>
> Skip hugepage validation and anonymous memory madvise calls when mmapping
> from guest_memfd, since those are not applicable when mmapping guest_memfd.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 74 ++++++++++++++++++------------
>  1 file changed, 45 insertions(+), 29 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index cac5624e99774..3f559f207408f 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1034,11 +1034,12 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  {
>         int ret;
>         struct userspace_mem_region *region;
> -       size_t backing_src_pagesz = get_backing_src_pagesz(src_type);
> -       int mmap_flags = vm_mem_backing_src_alias(src_type)->flag;
>         size_t mem_size = npages * vm->page_size;
> -       off_t mmap_offset = 0;
> -       size_t alignment = 1;
> +       size_t backing_src_pagesz;
> +       off_t mmap_offset;
> +       bool is_gmem_mmap;
> +       size_t alignment;
> +       int mmap_flags;
>
>         TEST_REQUIRE_SET_USER_MEMORY_REGION2();
>
> @@ -1090,19 +1091,31 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>         /* Allocate and initialize new mem region structure. */
>         region = calloc(1, sizeof(*region));
>         TEST_ASSERT(region != NULL, "Insufficient Memory");
> -       region->mmap_size = mem_size;
>
> -       /*
> -        * When using THP mmap is not guaranteed to returned a hugepage aligned
> -        * address so we have to pad the mmap. Padding is not needed for HugeTLB
> -        * because mmap will always return an address aligned to the HugeTLB
> -        * page size.
> -        */
> -       if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
> -               alignment = max(backing_src_pagesz, alignment);
> +       is_gmem_mmap = (flags & KVM_MEM_GUEST_MEMFD) &&
> +                      (gmem_flags & GUEST_MEMFD_FLAG_MMAP);
> +
> +       if (is_gmem_mmap) {
> +               backing_src_pagesz = getpagesize();
> +               alignment = 1;
> +               mmap_flags = MAP_SHARED;
> +               mmap_offset = gmem_offset;
> +       } else {
> +               backing_src_pagesz = get_backing_src_pagesz(src_type);
> +               /*
> +                * When using THP mmap is not guaranteed to returned a hugepage aligned
> +                * address so we have to pad the mmap. Padding is not needed for HugeTLB
> +                * because mmap will always return an address aligned to the HugeTLB
> +                * page size.
> +                */
> +               alignment = src_type == VM_MEM_SRC_ANONYMOUS_THP ? backing_src_pagesz : 1;
> +               mmap_flags = vm_mem_backing_src_alias(src_type)->flag;
> +               mmap_offset = 0;
> +       }
>
>         TEST_ASSERT_EQ(gpa, align_up(gpa, backing_src_pagesz));
>
> +       region->mmap_size = mem_size;
>         /* Add enough memory to align up if necessary */
>         if (alignment > 1)
>                 region->mmap_size += alignment;
> @@ -1129,10 +1142,8 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>         }
>
>         region->fd = -1;
> -       if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP) {
> +       if (is_gmem_mmap) {
>                 region->fd = kvm_dup(gmem_fd);
> -               mmap_flags = MAP_SHARED;
> -               mmap_offset = gmem_offset;
>         } else if (backing_src_is_shared(src_type)) {
>                 region->fd = kvm_memfd_alloc(region->mmap_size,
>                                              src_type == VM_MEM_SRC_SHARED_HUGETLB);
> @@ -1141,22 +1152,27 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>         region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
>                                         mmap_flags, region->fd, mmap_offset);
>
> -       TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
> -                   region->mmap_start == align_ptr_up(region->mmap_start, backing_src_pagesz),
> -                   "mmap_start %p is not aligned to HugeTLB page size 0x%lx",
> -                   region->mmap_start, backing_src_pagesz);
> -
>         /* Align host address */
>         region->host_mem = align_ptr_up(region->mmap_start, alignment);
>
> -       /* As needed perform madvise */
> -       if ((src_type == VM_MEM_SRC_ANONYMOUS ||
> -            src_type == VM_MEM_SRC_ANONYMOUS_THP) && thp_configured()) {
> -               ret = madvise(region->host_mem, mem_size,
> -                             src_type == VM_MEM_SRC_ANONYMOUS ? MADV_NOHUGEPAGE : MADV_HUGEPAGE);
> -               TEST_ASSERT(ret == 0, "madvise failed, addr: %p length: 0x%lx src_type: %s",
> -                           region->host_mem, mem_size,
> -                           vm_mem_backing_src_alias(src_type)->name);
> +       if (!is_gmem_mmap) {
> +               TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
> +                           region->mmap_start ==
> +                           align_ptr_up(region->mmap_start, backing_src_pagesz),
> +                           "mmap_start %p is not aligned to HugeTLB page size 0x%lx",
> +                           region->mmap_start, backing_src_pagesz);
> +
> +               /* As needed perform madvise */
> +               if ((src_type == VM_MEM_SRC_ANONYMOUS ||
> +                    src_type == VM_MEM_SRC_ANONYMOUS_THP) && thp_configured()) {
> +                       int advice = src_type == VM_MEM_SRC_ANONYMOUS ?
> +                                    MADV_NOHUGEPAGE : MADV_HUGEPAGE;
> +
> +                       ret = madvise(region->host_mem, mem_size, advice);
> +                       TEST_ASSERT(ret == 0, "madvise failed, addr: %p length: 0x%lx src_type: %s",
> +                                   region->host_mem, mem_size,
> +                                   vm_mem_backing_src_alias(src_type)->name);
> +               }
>         }
>
>         region->backing_src_type = src_type;
>
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>

