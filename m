Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F60CAC58F
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 08:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9E3E8E0007; Sun, 14 Sep 2025 04:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4EFB8E0001; Sun, 14 Sep 2025 04:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A165D8E0007; Sun, 14 Sep 2025 04:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8505F8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 04:20:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A23EF13A42E
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:45:15 +0000 (UTC)
X-FDA: 83887070190.23.B81F9EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD9C620005
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:45:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fUYb7nO6;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757835914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B3fKfgQSxVo5dc7NAU590dHLDFuHIU+1zqGtL5DfsvE=;
	b=qzzs34P2gNCcyQqYkb4nqwi58oo3PM78/LacJ177NUU76ANfwVG+DTLVBlM/6aQm1GjmzB
	szzgHxZ2EspEK2WOOQNPkijrHhBNSzQCl5/A9R9eqKkMtH/0cGl3KkAGto5BlOAJsTjekH
	jsURWxiK26aF0ZlOZkyLgQS95r9G+Kw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757835914; a=rsa-sha256;
	cv=none;
	b=cxdPyZraa37uujtYTsplNKg4IxHOwlHj5qhlyZxi6f31Nuzg+ofMqpWOgyfYliDE6IoiHH
	+y4SgchRZ1rPLcWztoOXE1Oj7NMXXL09kI889oRAMgqZRx5rOb13PIyJAJDLVd1SMXw8eS
	ai3wHIexFWqo9KUrTOSbb//4Vp3d2y8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fUYb7nO6;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C96B40AD6;
	Sun, 14 Sep 2025 07:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2208C4CEF0;
	Sun, 14 Sep 2025 07:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757835912;
	bh=ll3A1mV/yYnF5rQfgiisRFaxkVuSejJaeersKDWiT7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fUYb7nO6KxjWLuQIdwhu6X1LPYHLoTJ/4cmUkEmPVpZaKrxM6SrzN31vDYyJ2XEQz
	 LedFqqqu33W2LGAtTO5UJ1M2drFT3RegKj9wb+nnQF0nopYQN7rpg2SyooKvsQ/WxG
	 X8YekHGfml2KIKwPR0AEq81x0hQhORjCBVJrEtVvp3JSDC6bfVU/EikgXRvkzvI1yL
	 8D3LuWHAlgWQlstJ8mmkdWucVHj94CCg9mTrw/ZX0xoxOR1Cpp7WtqP/Ps6cw9rNJQ
	 Hjwz0Wy8pqnyq9JFwGW3j79iP8C/ND1idBjoQMJuM2X+Yev6Io/lDeaxUuACOah7Wk
	 NnpJJe7DBniYw==
Date: Sun, 14 Sep 2025 10:44:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "Thomson, Jack" <jackabt@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>,
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
	"willy@infradead.org" <willy@infradead.org>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"alex@ghiti.fr" <alex@ghiti.fr>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>,
	"gor@linux.ibm.com" <gor@linux.ibm.com>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"trondmy@kernel.org" <trondmy@kernel.org>,
	"anna@kernel.org" <anna@kernel.org>,
	"hubcap@omnibond.com" <hubcap@omnibond.com>,
	"martin@omnibond.com" <martin@omnibond.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"jack@suse.cz" <jack@suse.cz>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>,
	"ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>,
	"song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>,
	"yuanchu@google.com" <yuanchu@google.com>,
	"weixugc@google.com" <weixugc@google.com>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"devel@lists.orangefs.org" <devel@lists.orangefs.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v6 05/11] KVM: guest_memfd: Add flag to remove from
 direct map
Message-ID: <aMZyacbUEM7HErM1@kernel.org>
References: <20250912091708.17502-1-roypat@amazon.co.uk>
 <20250912091708.17502-6-roypat@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912091708.17502-6-roypat@amazon.co.uk>
X-Rspamd-Queue-Id: DD9C620005
X-Stat-Signature: 4gcm5trnhrqujox5sbg4cweykg98xkqk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757835913-983191
X-HE-Meta: U2FsdGVkX19XDn9eV6EHeny4BYF1r4ftZQv1eg12aYwfF3GBPNSBhhCFR3YVDlR7wFcdNO3M7S33mW0+cDl//GZ6JL726SivTqqksLBdCav/C1+kj6IuBpt9cW8Qiz1msQG5jQTiDhHNRz8xga/PRKKQUZftvBanU6DwI5ic1B1BGwgWSMrOBSjBU6JmeeOz5jsQcNeq567LiHGGxhe17GIqam/mubn7o0V112isnkK4h5oRYqSwdVZ4qLhjo2gp5FQNTUulVRyLZYEAmrS3sIW5y5A7C6RRImWgMNfK3v/uO4mO2Ha2ZElyzTCIayZit+Abas6mvkPdXvdXtO9H+FAPh5GynekZHgpTEUXtOkc/L4+zfaDql+bSQhgYCLdcFihZMfxss6cdVN9y13flt5eOWE6Vl5/ZVC0syuTVvsoL3DY2rzDF6nXzK5jBUID6z9+H/grtB1NDSN0MqwrtXOlPqqsSIxJGWpCrXNwKL7FM38tWpxmkaj6aGJE066YLbMCnueKuY29znYQKhlKLuA1tKLxoJY6KEFye7HQw1FlKJ8qzWiGJuTyN9lPKestg7OhOtKM7F/KxNpSx3jmcCn8usv8dUHdvY8rPU1jkBW8z1z2g1x7FbKtAH/7d1ND9KAMRRiJ7GnI0kNvwfm2nlJcMHqtL5k6F7TmcD7pl/UMAp+xhPdAItXcpH841Wde6di5vhv95Q4ZHNZMoiz8nlghKBb2OS5wt5PjUJuhOpiq9zPftsBJjBeP1LnES1rUd7gip+zv8QjUn47CW5PUUVlyiZMCa61uKdgoCL/y6vTvVIbnfflW9Kjdfzmez4qXfhbNdbE90or9mXRd5kMUq9oyxqO1JoLJzOXb8LmqXhSHhvp9rrQdCe7UxfqsXvMMIJXA1eM43SvMCVe+QHesFG+2UqZ8pPZi7V634bDO3PSQ2GhbTG23LPkWAXk9TIvcDKlgYt5MbBKCyQqXQaVb
 +otbZKn0
 vzHJEo57ZKWw2OwfrUV/dd6r5XB3GNVTQJpGb9dvZm2/9BLlzN3ZAprEi4OpV3f091dHBuKTokrdtOLlGs4SLAVKvTj/imUjsaP9MPlWTxZcg5FiPSXkMqVx8gFCFXBFYgJ5MujTbh3KNaRZ1t5m4Y9xEkMq86KySAXRfscxcZs9mcVrd97NeoMB6FwXMYtBhEY4xYp/SZnvwfQmmncscgLto5Xpj8+Sbt18gp/tyI0Ga4n2AfMuwZmf6FpAJg558EoW5D7tZd1EQ0xdntIXolAigJ2cKDXR2yX9nc8LEhqgnmnPt82tx3xEz6oAJOMYF3nB80obOiQysBUCI4HhwEWncljqCwvl4H5jNup22XqlZnDtDJcbnxsAWfpHizDahtTAtRSrWEomJ/2GUbFgE+ZJnmtW3It5i4L/7qleXCLJe6s7kHT5akoVX9DDxW+yzQgcenCbmvd/GrCc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 09:17:37AM +0000, Roy, Patrick wrote:
> Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
> ioctl. When set, guest_memfd folios will be removed from the direct map
> after preparation, with direct map entries only restored when the folios
> are freed.
> 
> To ensure these folios do not end up in places where the kernel cannot
> deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
> address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
> 
> Add KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP to let userspace discover whether
> guest_memfd supports GUEST_MEMFD_FLAG_NO_DIRECT_MAP. Support depends on
> guest_memfd itself being supported, but also on whether linux supports
> manipulatomg the direct map at page granularity at all (possible most of
> the time, outliers being arm64 where its impossible if the direct map
> has been setup using hugepages, as arm64 cannot break these apart due to
> break-before-make semantics, and powerpc, which does not select
> ARCH_HAS_SET_DIRECT_MAP, which also doesn't support guest_memfd anyway
> though).
> 
> Note that this flag causes removal of direct map entries for all
> guest_memfd folios independent of whether they are "shared" or "private"
> (although current guest_memfd only supports either all folios in the
> "shared" state, or all folios in the "private" state if
> GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
> entries of also the shared parts of guest_memfd are a special type of
> non-CoCo VM where, host userspace is trusted to have access to all of
> guest memory, but where Spectre-style transient execution attacks
> through the host kernel's direct map should still be mitigated.  In this
> setup, KVM retains access to guest memory via userspace mappings of
> guest_memfd, which are reflected back into KVM's memslots via
> userspace_addr. This is needed for things like MMIO emulation on x86_64
> to work.
> 
> Do not perform TLB flushes after direct map manipulations. This is
> because TLB flushes resulted in a up to 40x elongation of page faults in
> guest_memfd (scaling with the number of CPU cores), or a 5x elongation
> of memory population. TLB flushes are not needed for functional
> correctness (the virt->phys mapping technically stays "correct",  the
> kernel should simply not use it for a while). On the other hand, it means
> that the desired protection from Spectre-style attacks is not perfect,
> as an attacker could try to prevent a stale TLB entry from getting
> evicted, keeping it alive until the page it refers to is used by the
> guest for some sensitive data, and then targeting it using a
> spectre-gadget.
> 
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>

With a few nits below

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  Documentation/virt/kvm/api.rst    |  5 ++++
>  arch/arm64/include/asm/kvm_host.h | 12 ++++++++
>  include/linux/kvm_host.h          |  7 +++++
>  include/uapi/linux/kvm.h          |  2 ++
>  virt/kvm/guest_memfd.c            | 49 +++++++++++++++++++++++++++----
>  virt/kvm/kvm_main.c               |  5 ++++
>  6 files changed, 75 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c17a87a0a5ac..b52c14d58798 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6418,6 +6418,11 @@ When the capability KVM_CAP_GUEST_MEMFD_MMAP is supported, the 'flags' field
>  supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation
>  enables mmap() and faulting of guest_memfd memory to host userspace.
>  
> +When the capability KVM_CAP_GMEM_NO_DIRECT_MAP is supported, the 'flags' field
> +supports GUEST_MEMFG_FLAG_NO_DIRECT_MAP. Setting this flag makes the guest_memfd
> +instance behave similarly to memfd_secret, and unmaps the memory backing it from
> +the kernel's address space after allocation.
> +
>  When the KVM MMU performs a PFN lookup to service a guest fault and the backing
>  guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
>  consumed from guest_memfd, regardless of whether it is a shared or a private
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2f2394cce24e..0bfd8e5fd9de 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -19,6 +19,7 @@
>  #include <linux/maple_tree.h>
>  #include <linux/percpu.h>
>  #include <linux/psci.h>
> +#include <linux/set_memory.h>
>  #include <asm/arch_gicv3.h>
>  #include <asm/barrier.h>
>  #include <asm/cpufeature.h>
> @@ -1706,5 +1707,16 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
>  void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
>  void check_feature_map(void);
>  
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +static inline bool kvm_arch_gmem_supports_no_direct_map(void)
> +{
> +	/*
> +	 * Without FWB, direct map access is needed in kvm_pgtable_stage2_map(),
> +	 * as it calls dcache_clean_inval_poc().
> +	 */
> +	return can_set_direct_map() && cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);
> +}
> +#define kvm_arch_gmem_supports_no_direct_map kvm_arch_gmem_supports_no_direct_map
> +#endif /* CONFIG_KVM_GUEST_MEMFD */
>  
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1d0585616aa3..a9468bce55f2 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -36,6 +36,7 @@
>  #include <linux/rbtree.h>
>  #include <linux/xarray.h>
>  #include <asm/signal.h>
> +#include <linux/set_memory.h>

The set_memory APIs are not used in the header, no need to include it here.

>  #include <linux/kvm.h>
>  #include <linux/kvm_para.h>
> @@ -731,6 +732,12 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
>  #endif
>  
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +#ifndef kvm_arch_gmem_supports_no_direct_map
> +#define kvm_arch_gmem_supports_no_direct_map can_set_direct_map
> +#endif
> +#endif /* CONFIG_KVM_GUEST_MEMFD */
> +
>  #ifndef kvm_arch_has_readonly_mem
>  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>  {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6efa98a57ec1..33c8e8946019 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -963,6 +963,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_RISCV_MP_STATE_RESET 242
>  #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
>  #define KVM_CAP_GUEST_MEMFD_MMAP 244
> +#define KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP 245
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> @@ -1600,6 +1601,7 @@ struct kvm_memory_attributes {
>  
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
>  #define GUEST_MEMFD_FLAG_MMAP	(1ULL << 0)
> +#define GUEST_MEMFD_FLAG_NO_DIRECT_MAP (1ULL << 1)
>  
>  struct kvm_create_guest_memfd {
>  	__u64 size;
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 81028984ff89..3c64099fc98a 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -4,6 +4,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/pagemap.h>
>  #include <linux/anon_inodes.h>
> +#include <linux/set_memory.h>
>  
>  #include "kvm_mm.h"
>  
> @@ -42,9 +43,24 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>  	return 0;
>  }
>  
> -static inline void kvm_gmem_mark_prepared(struct folio *folio)
> +static bool kvm_gmem_test_no_direct_map(struct inode *inode)
>  {
> -	folio_mark_uptodate(folio);
> +	return ((unsigned long) inode->i_private) & GUEST_MEMFD_FLAG_NO_DIRECT_MAP;
> +}
> +
> +static inline int kvm_gmem_mark_prepared(struct folio *folio)
> +{
> +	struct inode *inode = folio_inode(folio);
> +	int r = 0;
> +
> +	if (kvm_gmem_test_no_direct_map(inode))
> +		r = set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(folio),
> +						 false);
> +
> +	if (!r)
> +		folio_mark_uptodate(folio);
> +
> +	return r;
>  }
>  
>  /*
> @@ -82,7 +98,7 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	index = ALIGN_DOWN(index, 1 << folio_order(folio));
>  	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>  	if (!r)
> -		kvm_gmem_mark_prepared(folio);
> +		r = kvm_gmem_mark_prepared(folio);

If this fails, shouldn't we undo __kvm_gmem_prepare_folio()?

>  
>  	return r;
>  }
> @@ -344,8 +360,15 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  	}
>  
>  	if (!folio_test_uptodate(folio)) {
> +		int err = 0;
> +
>  		clear_highpage(folio_page(folio, 0));
> -		kvm_gmem_mark_prepared(folio);
> +		err = kvm_gmem_mark_prepared(folio);
> +
> +		if (err) {
> +			ret = vmf_error(err);
> +			goto out_folio;
> +		}
>  	}
>  
>  	vmf->page = folio_file_page(folio, vmf->pgoff);
> @@ -436,6 +459,16 @@ static void kvm_gmem_free_folio(struct address_space *mapping,
>  	kvm_pfn_t pfn = page_to_pfn(page);
>  	int order = folio_order(folio);
>  
> +	/*
> +	 * Direct map restoration cannot fail, as the only error condition
> +	 * for direct map manipulation is failure to allocate page tables
> +	 * when splitting huge pages, but this split would have already
> +	 * happened in set_direct_map_invalid_noflush() in kvm_gmem_mark_prepared().
> +	 * Thus set_direct_map_valid_noflush() here only updates prot bits.
> +	 */
> +	if (kvm_gmem_test_no_direct_map(mapping->host))
> +		set_direct_map_valid_noflush(page, folio_nr_pages(folio), true);
> +
>  	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
>  }
>  
> @@ -500,6 +533,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	/* Unmovable mappings are supposed to be marked unevictable as well. */
>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>  
> +	if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
> +		mapping_set_no_direct_map(inode->i_mapping);
> +
>  	kvm_get_kvm(kvm);
>  	gmem->kvm = kvm;
>  	xa_init(&gmem->bindings);
> @@ -524,6 +560,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  	if (kvm_arch_supports_gmem_mmap(kvm))
>  		valid_flags |= GUEST_MEMFD_FLAG_MMAP;
>  
> +	if (kvm_arch_gmem_supports_no_direct_map())
> +		valid_flags |= GUEST_MEMFD_FLAG_NO_DIRECT_MAP;
> +
>  	if (flags & ~valid_flags)
>  		return -EINVAL;
>  
> @@ -768,7 +807,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  		p = src ? src + i * PAGE_SIZE : NULL;
>  		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
>  		if (!ret)
> -			kvm_gmem_mark_prepared(folio);
> +			ret = kvm_gmem_mark_prepared(folio);
>  
>  put_folio_and_exit:
>  		folio_put(folio);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 18f29ef93543..b5e702d95230 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -65,6 +65,7 @@
>  #include <trace/events/kvm.h>
>  
>  #include <linux/kvm_dirty_ring.h>
> +#include <linux/set_memory.h>
>  
>  
>  /* Worst case buffer size needed for holding an integer. */
> @@ -4916,6 +4917,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  		return kvm_supported_mem_attributes(kvm);
>  #endif
>  #ifdef CONFIG_KVM_GUEST_MEMFD
> +	case KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP:
> +		if (!kvm_arch_gmem_supports_no_direct_map())
> +			return 0;
> +		fallthrough;
>  	case KVM_CAP_GUEST_MEMFD:
>  		return 1;
>  	case KVM_CAP_GUEST_MEMFD_MMAP:
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

