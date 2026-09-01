Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 958A3C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0386B00A9; Tue,  1 Sep 2026 04:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7FA6B00AA; Tue,  1 Sep 2026 04:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7226B00AB; Tue,  1 Sep 2026 04:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 618676B00A9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:39:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDE901602D9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:39:48 +0000 (UTC)
X-FDA: 85164545256.08.CD69D6F
Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf24.hostedemail.com (Postfix) with ESMTP id 95B35180003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:39:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GU96kHCV;
	spf=pass (imf24.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788251986;
	b=XHkXIS3FgYMpVTVlZeBgfnDRqN9VGtEQMiHj0ecrecf4n6sJr9MxYifghytMtYrXsUiwU2
	eYZh+kHxdJjdierRYZX7HRlR72dnhlg8NVo1GVqnnFGPs2/P23p3AApDb5niikOCKVxWoH
	DFvnBGpEtzu6gsfRHOtGG4/BQyvnmAw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GU96kHCV;
	spf=pass (imf24.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788251986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgtknE6qg6Kh10k9Szpwwk8R+q8LE13VZh0BT8l77Bs=;
	b=W3Lz4sTU96WMtxfwxkdYMSEWvKIkR+Tv1o2H9uzW/LcVFJm/TI8m7zc8Q7gK8KylhOf0mv
	Y9EhQoyUfz9D56G5RGIr8LLE4dahE5BxefCjAnm3clmXM7SO8+pdWA0DJuCZ1I038/8d0T
	osi9FSa/EL6ZeI2XGIaDXK4Far5OAu0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MFd6QQcIiVNo4d+5OnfkjHu0LYEIxCoAHDswhin9sq8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788251985; v=1; x=1788856785;
 b=GU96kHCV+wQsmqJ41cfsYDH1NaP50ZQ60nbptuzjsvatU2nhLHmUPv0hTB7Fo7HB/wflM13Y
 /p+cYEA/ZJmXRXhIjMGu3GAZRG1O3vWi2e3Er+Jk/hNRBe/7yBWjeTtOf0oNX/OLC1MvoKudC7g
 0srLUQq4aaMKsQ4DanRHo9hg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2d558eae9499d730;
	Tue, 01 Sep 2026 08:39:45 +0000
X-Mizu-Trace-ID: 2d558eae9499d730
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so3729e87.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:39:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwufv87AKAGOwbQyEARoQw9bRvZU4jU0gl77efPkDRaRrycpSx/WJb78DtWiKqQkm7BGYGaHHtOQg==@kvack.org
X-Gm-Message-State: AFuF++kTOYSed4y4HwPxYtUKqDbqIwibuxHnZ60AxlFZKhdNk4i4kK/C
	ve4oF9vCKZDv4YAWYgImOvOPlsryq/IyFu43ZKaxyltQ/ochrsShM1YhyQlGdbUfkqV+26qba/D
	btAhylW22fE74QPaCbtrkDD1wZ3dJX31djJNvATZe
X-Received: by 2002:ac2:5689:0:b0:5b4:4c8a:abef with SMTP id
 2adb3069b0e04-5b5ff29d7ccmr116639e87.10.1788251981891; Tue, 01 Sep 2026
 01:39:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com> <20260830-gmem-inplace-conversion-v12-1-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-1-85e5fd25252a@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 09:39:05 +0100
X-Gmail-Original-Message-ID: <CA+EHjTytLWsa9-boURuumSFC8yNWDwvz_+WNN-aEz_cA9OkcdA@mail.gmail.com>
X-Gm-Features: AcwNN1XCAyPPlQdujvTs-aL1UBkQHfHgNLA1ozg5F-aaAoV8bE_sbTlT0O7ALBU
Message-ID: <CA+EHjTytLWsa9-boURuumSFC8yNWDwvz_+WNN-aEz_cA9OkcdA@mail.gmail.com>
Subject: Re: [PATCH v12 01/45] KVM: guest_memfd: Optimize away conversion
 overheads via dead-code elimination
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
X-Stat-Signature: uzx4g1zkxafobpri6dr4y7xodbrmwqpx
X-Rspamd-Queue-Id: 95B35180003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788251986-725397
X-HE-Meta: U2FsdGVkX18ZKPfP8fpKDU7uOwjvB4Hk8lEOuE/56pxkkCcvmUyGG76dT7mkYTv3P0rePcdkNJHJA7JwpkChUSZhhfbUCkcD/orVrx1lG1oPWqpGk54K+zZOYyTDuprNvxQ90NzPE5Md6JiwBcoP8cVRk1tKeFeZJFEmLBBOXKWcKx6KSX4hCwincQfyrajuZyiKHH9hL21oN2SKU4dFTkVznZRy/CMijiePbbChZsGZgax2jd1JkkVXyW1Sla+FpVJpNhYh1iuayK0jgajs8HrVXJNnR8jCcazOKwMA3L6cWt/AB7hLfdWZngDk8gcGIngkF5OOr2F0eddiyaYrhDhHhvNu6T0f77TflJPuqpBUdCUopSB3HOCFh/P3XG93MDNm7riOaC6gAipNoiBXdPRWStjawAAF/rEeJT71+EvePQ219x/HB2lWHGYcK9hYadlptqVtzW+4f5AcpdG3+gu3ipMnOq3SIp87Ed08HLB1zzZs8idLsCy4Vdi2KEaqGypASBUF4a8q9tcf9D07/BU4+NZbpK+6E0YSrcdZpwBOJNayJzYojGAMLyegb9CpjWUVVvQgUl6PQuNb4GDVM7ETrpI3PqN0XXA12ycCxjHW0RSq0Ax1XFgyi/5HLBCpQbL4oiGhYlu9Qe6mh84Z2kYkMTKCkwJgOsL6gLW3tOL3srILeQOzSYbzH7Zx2SqNE1AZbt0tDu9IdO2dzSYaRId2WEMPrdbjiEyeKldq/DStPPEDJAWVvoUvnYrZZC05izwZO2uTjz+MmdxAtucgy6W3APG3U/zyK15vsNYwYRSkr4NbcQmKV2gyqkWoQJJS6a2vNqb8XVE+0745DFNr6+dCp3M8W9smWEB9D3TMr9DwyZZYIuNi5eZVMiOqXH+6XCWoSU0nQhESI9II27hRSGvXjKFTBz5vDT8Z47LpE/AjFQJYAXcJnG3KLkJE6PACqVGiS2HSBD7Hy3IFAD9
 QkH6QWsq
 RX0+6H4uhxzZPNIjiAmlkalzYTf3H8MeguyeSTTRyu56T5PD7WuKwTKLjUT7zUKNojiqoTYY6GtD4uOoRDD3thuUq+DU3Lphqkl1WORmMcxOuCUpgT/wcjVWMj//OJ40BDRIRChe57wgxhs0enuHlyj9BST0IrLHINpLjg0ny7bzEaKibejNOYfLYYDmEkK9RwNXU7bTnn//cL2L1SnEYYWdjH/tRzvd7qLDPvGkUjz1c8e+NuNV30IikQ4J66MrzHBdlv3A4tkbKpFdb9fB81Q+TNWLgFKPmvi4NwMQ4unzQIWuXrJtVQ6IGtzGnfIz8UZXNZ5srVeuzXJnp70azzf6Y/FuMTF7FNmVtnst8dYt+Vpcn3jSs2WRk6zIhEfhU3MI3
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
> Add and use kvm_arch_has_gmem_convert() to guard guest_memfd's invocation
> of arch hooks related to converting memory between private and shared, as
> only one half of the x86 CoCo duo needs the runtime hooks (any pre-work is
> pure overhead for TDX).  At this exact moment, the overhead is negligible,
> but that will change when in-place conversion comes along, at which point
> to-shared conversions will "need" to find all affected folios prior to
> calling into arch code.  In quotes because very technically that work could
> be pushed to arch code, but that would bleed guest_memfd details into arch
> code and would be far worse than adding yet another kvm_arch_has... hook.
>
> Opportunistically provide the kvm_arch_gmem_make_private() declaration, and
> rely on dead-code elimination to eliminate the call to non-existent code
> when CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT=n.
>
> Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
> Closes: https://lore.kernel.org/all/1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com
> Suggested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  arch/x86/include/asm/kvm_host.h | 3 +++
>  include/linux/kvm_host.h        | 3 ++-
>  virt/kvm/guest_memfd.c          | 5 ++---
>  3 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 683bb8bf43a94..6beddd8a0c749 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1854,6 +1854,9 @@ enum kvm_intr_type {
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>  #endif
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> +#define kvm_arch_has_gmem_convert() (!!kvm_x86_ops.gmem_make_private)
> +#endif
>
>  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 502465119ca0c..b7516e19ef419 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2597,9 +2597,10 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  }
>  #endif /* CONFIG_KVM_GUEST_MEMFD */
>
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
>  int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>                                kvm_pfn_t nr_pages);
> +#ifndef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> +#define kvm_arch_has_gmem_convert() false
>  #endif
>
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 798d91df69537..2190e4d6b6bea 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -772,11 +772,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>                 folio_mark_uptodate(folio);
>         }
>
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> -       if (kvm_gmem_is_private_mem(file_inode(file), index))
> +       if (kvm_arch_has_gmem_convert() &&
> +           kvm_gmem_is_private_mem(file_inode(file), index))
>                 r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
>                                                (kvm_pfn_t)1 << *max_order);
> -#endif
>
>         folio_unlock(folio);
>         folio_put(folio);
>
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>

