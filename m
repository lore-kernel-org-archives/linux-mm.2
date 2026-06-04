Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9302BCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 15:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C796B0005; Thu,  4 Jun 2026 11:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D2D6B0088; Thu,  4 Jun 2026 11:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BFA6B008A; Thu,  4 Jun 2026 11:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90EC86B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:29:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 348E914015F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:29:42 +0000 (UTC)
X-FDA: 84842615004.07.A8A31D7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id C32CA2001E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:29:32 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780586973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAOEYCeVLuk0MxXqfEEyYdHUVyxutQs3EwBq/h1/vek=;
	b=x7iNFhu4I83S0XLTstZ8MelWuMDdSjaWryTkI6e5hJyZNIcJwZkwn4sziu/tjOSQEIJWjH
	3a8uz/Fn8jd4vyyKe2kkYiHzR042cwGJ/4eqVG6NHgXE881tJvL6Dlyn+vwkmj1SJ5H2iA
	UjK9yhEbWearnGrfLoNUvYbLXczxQ4o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780586973;
	b=rHxcmrjhXkQq0m78Ozvam/XIo0kh/TddrBEM7daZQSqgF3AGNIOG2kNrM5ba+mCt6L5Kkj
	Rjw04wIOQZA1n6tl0OpzAFiEdO2spiN7FGMsw/sBNh/bOejGImnns7nEjhFIoYesy/ghVw
	2Br/+6LolwLoZQ6/gojuPyrGE1NyMzU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=u5tYSEK0;
	spf=pass (imf13.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2EB21516;
	Thu,  4 Jun 2026 08:29:26 -0700 (PDT)
Received: from [10.57.95.39] (unknown [10.57.95.39])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA02C3F86F;
	Thu,  4 Jun 2026 08:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780586971; bh=bsr5b2gpdP7Z02h1Njek9qwNAkWcpQjmCyE6Te0xtUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u5tYSEK0WD6FzVygVZ2inUsRE7KPNU6aiooHb7WFFytVH7MwdY+o3iH91d3sWJQym
	 G77ajQTrso6CQR5994wgSjTDCEuz6fiiAdnuNQFgcq6pkYJfcMWf+6whcM46UC6c2z
	 1s46Od/7JFr/FBCHQRzYdrTjrodXGQYEF9NX3838=
Message-ID: <9d15479e-e36b-4865-804c-7d93eb339e4e@arm.com>
Date: Thu, 4 Jun 2026 16:29:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 20/42] KVM: SEV: Make 'uaddr' parameter optional for
 KVM_SEV_SNP_LAUNCH_UPDATE
Content-Language: en-GB
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, ira.weiny@intel.com, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-20-2f0fae496530@google.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-20-2f0fae496530@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HE-Tag: 1780586972-957611
X-HE-Meta: U2FsdGVkX1+1RN6phsHq8G/U2yYsxwJtLnw4ovxM3sNW7xPkeSKhioEPi1tQmRzZBeXo8S3NJ9ZYDYjIk2IrNU/ubSJQ5ho3zq5f/cAP4Usp9XYDoItjVJBFEakWFJC4c8ZontdhcDCZdopzOiEdZ7suD3HPjnfGa5HsyYwDSOeLmzTVVAyRfJ51VQrZzCe2Phbm21baKPd88vi5jQqEdHVEjOXeDoJwmd/Di0cIcaOEXwQS5T5lvRZgbkhnkpV1d4GeN7+qcMhUsLb5NlTOR2tyxbYIbP7p2zt4uaoe7yQTcExkptmAz0OUCOXQ015SRvL2lLy5HRtTUVkPt92AghVuSiFO1OwGtewPrUJvU86hifHLQHF3U8HRvK/n1eO2xcP6/dZr2d+bIwCLFvaNEYD5spn0JfYv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/05/2026 01:18, Ackerley Tng via B4 Relay wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> For vm_memory_attributes=1, in-place conversion/population is not
> supported, so the initial contents necessarily must need to come
> from a separate src address, which is enforced by the current
> implementation. However, for vm_memory_attributes=0, it is possible for
> guest memory to be initialized directly from userspace by mmap()'ing the
> guest_memfd and writing to it while the corresponding GPA ranges are in
> a 'shared' state before converting them to the 'private' state expected
> by KVM_SEV_SNP_LAUNCH_UPDATE.
> 
> Update the handling/documentation for KVM_SEV_SNP_LAUNCH_UPDATE to allow
> for 'uaddr' to be set to NULL when vm_memory_attributes=0, which
> SNP_LAUNCH_UPDATE will then use to determine when it should/shouldn't
> copy in data from a separate memory location. Continue to enforce
> non-NULL for the original vm_memory_attributes=1 case.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> [Added src_page check in error handling path when the firmware command fails]
> [Dropped ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES]
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>




> ---
>   Documentation/virt/kvm/x86/amd-memory-encryption.rst | 15 +++++++++++----
>   arch/x86/kvm/svm/sev.c                               | 18 +++++++++++++-----
>   virt/kvm/kvm_main.c                                  |  1 +
>   3 files changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index b2395dd4769de..43085f65b2d85 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -503,7 +503,8 @@ secrets.
>   
>   It is required that the GPA ranges initialized by this command have had the
>   KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentation
> -for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
> +for KVM_SET_MEMORY_ATTRIBUTES/KVM_SET_MEMORY_ATTRIBUTES2 for more details on
> +this aspect.
>   
>   Upon success, this command is not guaranteed to have processed the entire
>   range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
> @@ -511,9 +512,15 @@ range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
>   remaining range that has yet to be processed. The caller should continue
>   calling this command until those fields indicate the entire range has been
>   processed, e.g. ``len`` is 0, ``gfn_start`` is equal to the last GFN in the
> -range plus 1, and ``uaddr`` is the last byte of the userspace-provided source
> -buffer address plus 1. In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO,
> -``uaddr`` will be ignored completely.
> +range plus 1, and ``uaddr`` (if specified) is the last byte of the
> +userspace-provided source buffer address plus 1.
> +
> +In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO, ``uaddr`` will be
> +ignored completely. Otherwise, ``uaddr`` is required if
> +kvm.vm_memory_attributes=1 and optional if kvm.vm_memory_attributes=0, since
> +in the latter case guest memory can be initialized directly from userspace
> +prior to converting it to private and passing the GPA range on to this
> +interface.

Just to confirm, so the sev_gmem_prepare doesn't destroy the contents in 
the process of making it "private" ? i.e., the contents of a SNP shared
page are preserved while transitioning to "SNP Private" (via RMP
update).

Suzuki



>   
>   Parameters (in): struct  kvm_sev_snp_launch_update
>   
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1a361f08c7a3d..e1dbc827c2807 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2343,7 +2343,15 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>   	int level;
>   	int ret;
>   
> -	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page))
> +	/*
> +	 * For vm_memory_attributes=1, in-place conversion/population is not
> +	 * supported, so the initial contents necessarily need to come from a
> +	 * separate src address. For vm_memory_attributes=0, this isn't
> +	 * necessarily the case, since the pages may have been populated
> +	 * directly from userspace before calling KVM_SEV_SNP_LAUNCH_UPDATE.
> +	 */
> +	if (vm_memory_attributes &&
> +	    sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page)
>   		return -EINVAL;
>   
>   	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
> @@ -2390,7 +2398,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>   	 */
>   	if (ret && !snp_page_reclaim(kvm, pfn) &&
>   	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
> -	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> +	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM && src_page) {
>   		void *src_vaddr = kmap_local_page(src_page);
>   		void *dst_vaddr = kmap_local_pfn(pfn);
>   
> @@ -2423,8 +2431,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
>   		return -EFAULT;
>   
> -	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
> -		 params.gfn_start, params.len, params.type, params.flags);
> +	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d src %llx\n", __func__,
> +		 params.gfn_start, params.len, params.type, params.flags, params.uaddr);
>   
>   	if (!params.len || !PAGE_ALIGNED(params.len) || params.flags ||
>   	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
> @@ -2481,7 +2489,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   	params.gfn_start += count;
>   	params.len -= count * PAGE_SIZE;
> -	if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
> +	if (src && params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
>   		params.uaddr += count * PAGE_SIZE;
>   
>   	if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ba195bb239aaa..3bf212fd99193 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -105,6 +105,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
>   #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>   bool vm_memory_attributes = true;
>   module_param(vm_memory_attributes, bool, 0444);
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(vm_memory_attributes);
>   #endif
>   DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
>   EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
> 


