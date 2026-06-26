Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77595C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6519C6B0096; Fri, 26 Jun 2026 10:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6292E6B0098; Fri, 26 Jun 2026 10:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518316B0099; Fri, 26 Jun 2026 10:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 233316B0096
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:22:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 952EA167560
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:22:52 +0000 (UTC)
X-FDA: 84922280184.30.D296430
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7D5CD140018
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:22:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cmbGKR+a;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782483770;
	b=lZO6PUXvAZQa5Kf134PST8wu8VagYMRbi3xHCWE9VQ1kkqRGPB46w56ZYUGj1qcS0r0Nd3
	jvyMKkhsr8Z+vCaFjvFxty+dnsSFiy3D7vj50wS01nhUQaoy+WN7DwY7IpTWdQKRxFc7Bo
	ae5rafwF1tEI9uZrPRfS20YS8sCWtJE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782483770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXG8afNs3yklXPbprHmJENAjnx3o20Btd5uIVU420b8=;
	b=bwCXpBELUmA68ZvL9/1ERuCunSDv/nlipFXeSsu1B9+YADrXVRMRN7kSYlu5EkKKwbuEDd
	nMV48t4AP8gZBzGk81FG7CI7gQhEjkI3ufIiCqO5OhdCvMp2kA1h+uF9im+E3Q6SBWkuX1
	jWtoGYBNJ8goJHr5lBSeDLwRAvE/bpY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cmbGKR+a;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782483765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sXG8afNs3yklXPbprHmJENAjnx3o20Btd5uIVU420b8=;
	b=cmbGKR+aou02UPg0yNfg6EUU0La0FotxxR6hFPLMLLx0i5lyy0uaFlAgbddgfY7BgaEqsZ
	Avp7TJZOyigFd/b6E8iMjLcwLrplB8eRe2p1FXE6V2RLxfwUhMhmUh4RVdZbwmBV1PhoSu
	DO+3c0Hx0lG9DdahENlsDEcvPZ/2SDM=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:22:35 +0000
Message-Id: <DJJ1R8VB5H31.1XJ69GVCYMB87@linux.dev>
Subject: Re: [PATCH v12 13/16] KVM: selftests: Add guest_memfd based
 vm_mem_backing_src_types
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
 <kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
 <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
 <oupton@kernel.org>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
 <yuzenghui@huawei.com>, "catalin.marinas@arm.com"
 <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "tglx@kernel.org"
 <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
 <bp@alien8.de>, "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
 "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org"
 <willy@infradead.org>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org"
 <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
 <kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
 "haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
 <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
 <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
 "jannh@google.com" <jannh@google.com>, "pfalcato@suse.de"
 <pfalcato@suse.de>, "skhan@linuxfoundation.org"
 <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com"
 <jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org"
 <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com"
 <tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
 "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com"
 <jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>,
 "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "alex@ghiti.fr"
 <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
 "gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com"
 <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "pjw@kernel.org" <pjw@kernel.org>, "shijie@os.amperecomputing.com"
 <shijie@os.amperecomputing.com>, "svens@linux.ibm.com"
 <svens@linux.ibm.com>, "thuth@redhat.com" <thuth@redhat.com>,
 "yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com"
 <urezki@gmail.com>, "zhengqi.arch@bytedance.com"
 <zhengqi.arch@bytedance.com>, "gerald.schaefer@linux.ibm.com"
 <gerald.schaefer@linux.ibm.com>, "jiayuan.chen@shopee.com"
 <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>,
 "pavel@kernel.org" <pavel@kernel.org>, "rafael@kernel.org"
 <rafael@kernel.org>, "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
 "vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
 <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>
References: <20260410151746.61150-1-kalyazin@amazon.com>
 <20260410151746.61150-14-kalyazin@amazon.com>
In-Reply-To: <20260410151746.61150-14-kalyazin@amazon.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D5CD140018
X-Rspam-User: 
X-Stat-Signature: 974rpyc5aybykd6cnju5ojq9zqdk3n8a
X-HE-Tag: 1782483770-686345
X-HE-Meta: U2FsdGVkX18nsjtEEFdjLI3b7JpuF5p4uSAyH7Q/BUjth5WxWGX0hHF4KldkTwZufalZYtssijLawi4/asPI5Oq00T2NeqZ7N02lO61ju9lSQEZ+yC8A7KfRvyuAOROuyk1pcVO8ogLDdRpFfQ6QblX6soMXQU+2UyqaErg3A+v+SdQbcDKrEkvZ4R30SqAFuP8adK7PSLXBBVvTgoNV0g5ik3poWONKV7Xl0tjasPNiCgD0B8k9qfCxkIb7XP6CHvumeqsnUORTesOl8FDR03HyyCkzyIF0BzwRAhjLKfXojFrVn+J4y4N/M7vjlLXl66kAj0FgtxcUb5+I8VfZEOFvu/1UwlHn2jzoTXqzL7SX5GET45to8EYREqHfJLfnhUN7IqwqtKyjqEN+EOcOEghhLswD1AzBODPm20QP+3SAdKjni07dS8v7ESuzGMerj8yCBd3VwtqL+tgBQLHv8cFzWxn3c8barOl774+fIP8/Bb3U6u9NvqFOSbcnq++VKA8KC9XVP1G6lDJMwfg0eYwsuEhP8XBb1tHQYSarIv7KVOlnOY0/Y0lLWx/b/ytU7/xJHG6MMEbGfWzna7ribfaeCL7MGR6lMkeRBh6QDqs87omqB8lnUgMJjXnLqsAxaEa7ieUxcEmRzlN5pesw+sf9mYILjpcBZSeDL9K+rQ8gO2e0EOZ39qzIsAkSN23Taqlm6nEpBXiYchmkDplTdq3jjd/ZcSgar/AJ80qaSw6ezjRVF3ONu06jnTbPCPueEixLeOy0N8mwav5BFF9pwv+w+fIdIv25dAfuvrBE1r0caIW++D3XbXGh3UVxTYR3IwS9GoS0HpxBA+DRPRaI1rXqg4SDgWgXQaB2yzxj2SLhbq6vmyKarGWGGEg0mkhQURmlqVBN5/T12+sqm/yBOlw54lbn0nsHv70sq/C5bjkXSY5OPXaDieEgIwZX1Wab8SQ+8OjRrLpCJkSYKmk
 dP3C7pty
 Z8hCfM2HikW1qPGzbZQsHG8PPNLS/ZvMu/VE+TdqjgDx+C5Ydkbu4n1j4uk37XvmXcf9ZJ1Dd7osdgCrk7TbyvHHHRLg2KfaqmiB0/YPyYa2kJg2rKsd0xJ8zgHdn1+yRCzRRbxy3p8BQanimprK+HBoWpuFOy4YTLMAGaRnUHvxaG+/zA/KzfECBD39juql5sQDLdI20Bd+/OSj2ajqChmWoq5s1brLTP0bMZ+4k1v9iQM0gouwI1n534ER7QCpMUraqtX7TMG9RcODAK6tAjQQoWkAHmdj/c/bRyAHwF16J/GagN4GXx6K+xHsSsHA1VTY9ERPtXeKdiI9fzsJm5ehPauNaBrPpq5pVpC3zkuTcm2T1TRlqg/W4LQ8/YM+40/XOCY5Cu0ME47hFHQLcSFHLtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Apr 10, 2026 at 3:20 PM UTC, Nikita Kalyazin wrote:
> From: Patrick Roy <patrick.roy@linux.dev>
>
> Allow selftests to configure their memslots such that userspace_addr is
> set to a MAP_SHARED mapping of the guest_memfd that's associated with
> the memslot. This setup is the configuration for non-CoCo VMs, where all
> guest memory is backed by a guest_memfd whose folios are all marked
> shared, but KVM is still able to access guest memory to provide
> functionality such as MMIO emulation on x86.
>
> Add backing types for normal guest_memfd, as well as direct map removed
> guest_memfd.
>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 18 ++++++
>  .../testing/selftests/kvm/include/test_util.h |  7 +++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 61 ++++++++++---------
>  tools/testing/selftests/kvm/lib/test_util.c   |  8 +++
>  4 files changed, 65 insertions(+), 29 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
> index 8b39cb919f4f..056a003a63c0 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -664,6 +664,24 @@ static inline bool is_smt_on(void)
> =20
>  void vm_create_irqchip(struct kvm_vm *vm);
> =20
> +static inline uint32_t backing_src_guest_memfd_flags(enum vm_mem_backing=
_src_type t)
> +{
> +	uint32_t flags =3D 0;
> +
> +	switch (t) {
> +	case VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP:
> +		flags |=3D GUEST_MEMFD_FLAG_NO_DIRECT_MAP;
> +		fallthrough;
> +	case VM_MEM_SRC_GUEST_MEMFD:
> +		flags |=3D GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return flags;
> +}
> +
>  static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t si=
ze,
>  					uint64_t flags)
>  {
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/test=
ing/selftests/kvm/include/test_util.h
> index 8140e59b59e5..ea6de20ce8ef 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -152,6 +152,8 @@ enum vm_mem_backing_src_type {
>  	VM_MEM_SRC_ANONYMOUS_HUGETLB_16GB,
>  	VM_MEM_SRC_SHMEM,
>  	VM_MEM_SRC_SHARED_HUGETLB,
> +	VM_MEM_SRC_GUEST_MEMFD,
> +	VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP,
>  	NUM_SRC_TYPES,
>  };
> =20
> @@ -184,6 +186,11 @@ static inline bool backing_src_is_shared(enum vm_mem=
_backing_src_type t)
>  	return vm_mem_backing_src_alias(t)->flag & MAP_SHARED;
>  }
> =20
> +static inline bool backing_src_is_guest_memfd(enum vm_mem_backing_src_ty=
pe t)
> +{
> +	return t =3D=3D VM_MEM_SRC_GUEST_MEMFD || t =3D=3D VM_MEM_SRC_GUEST_MEM=
FD_NO_DIRECT_MAP;
> +}
> +
>  static inline bool backing_src_can_be_huge(enum vm_mem_backing_src_type =
t)
>  {
>  	return t !=3D VM_MEM_SRC_ANONYMOUS && t !=3D VM_MEM_SRC_SHMEM;
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 5b0865683047..fa4a2fc236fe 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1046,6 +1046,33 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_bac=
king_src_type src_type,
>  	alignment =3D 1;
>  #endif
> =20
> +	if (guest_memfd < 0) {
> +		if ((flags & KVM_MEM_GUEST_MEMFD) || backing_src_is_guest_memfd(src_ty=
pe)) {
> +			uint32_t guest_memfd_flags =3D backing_src_guest_memfd_flags(src_type=
);
> +
> +			TEST_ASSERT(!guest_memfd_offset,
> +				    "Offset must be zero when creating new guest_memfd");
> +			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags=
);
> +		}
> +	} else {
> +		/*
> +		 * Install a unique fd for each memslot so that the fd
> +		 * can be closed when the region is deleted without
> +		 * needing to track if the fd is owned by the framework
> +		 * or by the caller.
> +		 */
> +		guest_memfd =3D kvm_dup(guest_memfd);
> +	}
> +
> +	if (guest_memfd >=3D 0) {
> +		flags |=3D KVM_MEM_GUEST_MEMFD;
> +
> +		region->region.guest_memfd =3D guest_memfd;
> +		region->region.guest_memfd_offset =3D guest_memfd_offset;
> +	} else {
> +		region->region.guest_memfd =3D -1;
> +	}
> +
>  	/*
>  	 * When using THP mmap is not guaranteed to returned a hugepage aligned
>  	 * address so we have to pad the mmap. Padding is not needed for HugeTL=
B
> @@ -1061,10 +1088,13 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_ba=
cking_src_type src_type,
>  	if (alignment > 1)
>  		region->mmap_size +=3D alignment;
> =20
> -	region->fd =3D -1;
> -	if (backing_src_is_shared(src_type))
> +	if (backing_src_is_guest_memfd(src_type))
> +		region->fd =3D guest_memfd;

This seems to cause a double-close in __vm_mem_region_delete() - it was
fine when this patch was written but now we have kvm_free_fd() which
crashes the test when this happens.

AFAICS it's easy to fix we just need to enlighten
__vm_mem_region_delete() that they might be the same FD.

