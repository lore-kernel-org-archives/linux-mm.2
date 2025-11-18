Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9171CEE334
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 16:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BABCD6B0088; Tue, 18 Nov 2025 11:41:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B355A6B0089; Tue, 18 Nov 2025 11:41:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD596B008A; Tue, 18 Nov 2025 11:41:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8861C6B0088
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:41:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C77512BF67
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:41:25 +0000 (UTC)
X-FDA: 84124293330.17.D6F3264
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5F5E11C0009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:41:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CNJ72i/Q";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763484083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aXiquLfXwKlUWbT+J3yLpDvgRwQBIaSPUUcoenUgNy8=;
	b=amlMxFWDTwPUwSGLfzS9+KSy5/x5J+lz6J+G89Q0w1ABocbbordcHZWIxNmRct79IXR1El
	jv/oB4RDfPdRUcQVlMKCpPfSzMjuj0JZwOR0foa5OFM19tUrNihYzksea4AYeBNC59d/YA
	zVHhG6TnR3/yNK0qxXUGO4StRDU4Z7c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CNJ72i/Q";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763484083; a=rsa-sha256;
	cv=none;
	b=MTgXxaEMNAUJxoGx8AF98qMwjhmA3fq1elNNGqdy16l7mY5y6D+vnC67dkGyEMzXGpUx0P
	kRYSFTGLeC6OgS6SM1bROXlloqdoBFmeTTjxzWXKDeWwd0MtvZKwVmu+Db2bc+R2D4tTxV
	rqnwBwXt+iHkv2x/CfCeCW8dV5flnws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 333804059C;
	Tue, 18 Nov 2025 16:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AA5C2BC86;
	Tue, 18 Nov 2025 16:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763484082;
	bh=76iwa07E2cia9ejh4c5uPXwKmb4vHJQCgXEZEhMo7lw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CNJ72i/QYImuXjY+Pg3BNrRhfOW78dFP48BxEYM13lc4eh3d/QCk+ootmeZ6HYp6V
	 W7R6dP1va7EYMXMgF78zewkbrvEUkCMGbv3s2J500oOaooSHnnUR90xs5zs1GC5cz7
	 jKthpLZGAoPHrKj135vstQa5Zxt/kuCMsKiCTGFzT56xrpn/caKAp6Ff6uUNf0UnJk
	 8gQsBTnrG1eFiG3M/n+uAxMqtDPNa4jK0pz3codcrfDfnjZDBjsr+K6rvlnfYvjFuM
	 4R2veWbx4NRNhwDPDpRSWJr+8B6PIbCMWj0t3veCRhz1ycxHFviUvefkCSBjEc4x2l
	 22FMPgm86U8vg==
Message-ID: <007c08e4-ce70-4c30-b3b1-e25e02dfe29d@kernel.org>
Date: Tue, 18 Nov 2025 17:41:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/4] userfaultfd, guest_memfd: support userfault minor
 mode in guest_memfd
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Nikita Kalyazin <kalyazin@amazon.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251117114631.2029447-1-rppt@kernel.org>
 <20251117114631.2029447-4-rppt@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251117114631.2029447-4-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5F5E11C0009
X-Stat-Signature: 68qmxpc81yz79eu5nmowjfngkayqzbm7
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763484083-675679
X-HE-Meta: U2FsdGVkX19IWdkJOKVLthl3a6pQPNQlf8UW7LVpmtE6PcvM/fF+Znouv9WH386rY3rW6zV850ObbUganNGq3FmKmsQGpczOMma2o7Q/nk2HjZMDKOQVnGFluwWS3w5ogfjzC9UhMkitv6yuMQMBUyNRZhUxgTs7GSKRKhhXU8FuVXBL9gO1u4TCCbK10VdW5sF2d95OGwulZ4HRyhjMQzbfFNf3e+1gDPKGMEeqQt+G3SqnmDXUUnTv0MGKTuKKmJexl4CPkMiDGMhbM52atsa0yAPOSAnuHevV4ECZix/V5R7+mtLpVCeQADDZ5cVJX0Z9E2YLoc66nlPgPMDe3Dqh+Sy+28wj1b3IiJ8MJkbdOky8ufv6gzPBoS5dGGOOdxeCRcvFMJM1fx8heLQirD3WNZuvJF0mOFhz7xxkMzrgnpe7VuH6vTQnPJ/ILtTdWzd43NBxDnl6C6Uw3kSA/PDCsW2TkLVorpJ0OXn54udvX+Figgvb874C2JTTuNpkSJ1iUfrr8soWP/PzKmik5gEkRaK8y/DYZjS+0LGAe28DNStbjLEMPZdmSyIPwM5sAdpLVvHJA7hzpKrPM24AFe0BgJafl5gIhqAFpy2TOBJur6MlRkJCpV++2HR3CZUQOxXvDwgmbWf9g8fC1VKE+lAdeJtIz89MJcJJTBFM7YUxIEYatJqKXYsW2AMivCN7MeSQKWmVq45uXhI+W7kxFozFlVfi7RvIxcxZ3W8DJI1cvCC66GHBJ8K5UW0Y5SdzXDcp0VI+4+Y1F5SdV2+j+WSB5Kq4/nrXkBeRYO8a5FDV7fb4C91zJGQ7Jc+SkdzMrRNK4xQADSqGHUfDOUUXPNBaZ2tWlPJds3RCMkPvEPVWxzg7jTSGOHuuD21EZp6HPn5TsO5lzINTzUq2lNyv3qnfwGvcGYY98jYDvpeTpcpvQBpe9+z2zrXAfhoBMfLFSbe1uTS4sF/p9c5ye+m
 kXLZ0S4/
 xxF4aEQ8dTkIGeB7ah6dL0n+9Pk6sElmIK1fLQcrLFrXTuLqxZl/8t8QBY2Lp3h7rubUAfcJ940TKcV6Z4WlmrbiIf7qVnQYezrOZa/Wpn8j9/EUZMAIEpFvBTiFR09wrETmfzk9u/mjb+n9jW2bP7OnvoEJadg7YH0bSEh2uuzxdWMb3XngXSsATSMH6InCsw9rj3CBq8vipULLnQiNb60na2rxl+ntj5HzsxkFhODWqC6BIoN8RkPAhzKrUPr2/M0NbbE1HuHTGtx3KGkKjmWkECTIrfoy3ZpHTCTu5jAeu+WoGNfv0ZJ2NGIp0gVPU00liqqMqaaUgQpQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.11.25 12:46, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> * Export handle_userfault() for KVM module so that fault() handler in
>    guest_memfd would be able to notify userspace about page faults in its
>    address space.
> * Implement get_pagecache_folio() for guest_memfd.
> * And finally, introduce UFFD_FEATURE_MINOR_GENERIC that will allow
>    using userfaultfd minor mode with memory types other than shmem and
>    hugetlb provided they are allowed to call handle_userfault() and
>    implement get_pagecache_folio().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   fs/userfaultfd.c                 |  4 +++-
>   include/uapi/linux/userfaultfd.h |  8 +++++++-
>   virt/kvm/guest_memfd.c           | 30 ++++++++++++++++++++++++++++++
>   3 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 54c6cc7fe9c6..964fa2662d5c 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -537,6 +537,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
>   out:
>   	return ret;
>   }
> +EXPORT_SYMBOL_FOR_MODULES(handle_userfault, "kvm");
>   
>   static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
>   					      struct userfaultfd_wait_queue *ewq)
> @@ -1978,7 +1979,8 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
>   	uffdio_api.features = UFFD_API_FEATURES;
>   #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
>   	uffdio_api.features &=
> -		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM);
> +		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM |
> +		  UFFD_FEATURE_MINOR_GENERIC);
>   #endif
>   #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
>   	uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
> diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
> index 2841e4ea8f2c..c5cbd4a5a26e 100644
> --- a/include/uapi/linux/userfaultfd.h
> +++ b/include/uapi/linux/userfaultfd.h
> @@ -42,7 +42,8 @@
>   			   UFFD_FEATURE_WP_UNPOPULATED |	\
>   			   UFFD_FEATURE_POISON |		\
>   			   UFFD_FEATURE_WP_ASYNC |		\
> -			   UFFD_FEATURE_MOVE)
> +			   UFFD_FEATURE_MOVE |			\
> +			   UFFD_FEATURE_MINOR_GENERIC)
>   #define UFFD_API_IOCTLS				\
>   	((__u64)1 << _UFFDIO_REGISTER |		\
>   	 (__u64)1 << _UFFDIO_UNREGISTER |	\
> @@ -210,6 +211,10 @@ struct uffdio_api {
>   	 * UFFD_FEATURE_MINOR_SHMEM indicates the same support as
>   	 * UFFD_FEATURE_MINOR_HUGETLBFS, but for shmem-backed pages instead.
>   	 *
> +	 * UFFD_FEATURE_MINOR_GENERIC indicates that minor faults can be
> +	 * intercepted for file-backed memory in case subsystem backing this
> +	 * memory supports it.
> +	 *
>   	 * UFFD_FEATURE_EXACT_ADDRESS indicates that the exact address of page
>   	 * faults would be provided and the offset within the page would not be
>   	 * masked.
> @@ -248,6 +253,7 @@ struct uffdio_api {
>   #define UFFD_FEATURE_POISON			(1<<14)
>   #define UFFD_FEATURE_WP_ASYNC			(1<<15)
>   #define UFFD_FEATURE_MOVE			(1<<16)
> +#define UFFD_FEATURE_MINOR_GENERIC		(1<<17)
>   	__u64 features;
>   
>   	__u64 ioctls;
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fbca8c0972da..5e3c63307fdf 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -4,6 +4,7 @@
>   #include <linux/kvm_host.h>
>   #include <linux/pagemap.h>
>   #include <linux/anon_inodes.h>
> +#include <linux/userfaultfd_k.h>
>   
>   #include "kvm_mm.h"
>   
> @@ -369,6 +370,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>   		return vmf_error(err);
>   	}
>   
> +	if (userfaultfd_minor(vmf->vma)) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		return handle_userfault(vmf, VM_UFFD_MINOR);
> +	}

Staring at things like VM_FAULT_NEEDDSYNC, I'm wondering whether we could have a
new return value from ->fault that would indicate that
handle_userfault(vmf, VM_UFFD_MINOR) should be called.

Maybe some VM_FAULT_UFFD_MINOR or simply VM_FAULT_USERFAULTFD and we
can just derive that it is VM_UFFD_MINOR.


diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 4f66a3206a63c..2cf17da880f0e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1601,6 +1601,8 @@ typedef __bitwise unsigned int vm_fault_t;
   *                             fsync() to complete (for synchronous page faults
   *                             in DAX)
   * @VM_FAULT_COMPLETED:                ->fault completed, meanwhile mmap lock released
+ * @VM_FAULT_USERFAULTFD:      ->fault did not modify page tables and needs
+ *                             handle_userfault() to complete
   * @VM_FAULT_HINDEX_MASK:      mask HINDEX value
   *
   */
@@ -1618,6 +1620,7 @@ enum vm_fault_reason {
         VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
         VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
         VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
+       VM_FAULT_USERFAULTFD    = (__force vm_fault_t)0x006000,
         VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
  };
  
@@ -1642,6 +1645,7 @@ enum vm_fault_reason {
         { VM_FAULT_FALLBACK,            "FALLBACK" },   \
         { VM_FAULT_DONE_COW,            "DONE_COW" },   \
         { VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },  \
+       { VM_FAULT_USERFAULTFD,         "USERFAULTFD" },\
         { VM_FAULT_COMPLETED,           "COMPLETED" }
  
  struct vm_special_mapping {


IIUC, we have exactly two invocations of ->fault(vmf) in memory.c where
we would have to handle it IIUC. And the return value would never leave
the core.

That way, we wouldn't have to export handle_userfault().

Just a thought ...

-- 
Cheers

David

