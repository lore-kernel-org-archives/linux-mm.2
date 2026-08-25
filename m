Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ED88C61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23AC66B0099; Tue, 25 Aug 2026 04:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EC066B009B; Tue, 25 Aug 2026 04:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D9BD6B009D; Tue, 25 Aug 2026 04:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8C8F6B0099
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:06:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7166120395
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:06:56 +0000 (UTC)
X-FDA: 85139060832.27.34AD9A1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf11.hostedemail.com (Postfix) with ESMTP id D26B540003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:06:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WIRA0046;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787645214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8moenjG2S+q0JlVYnnvim4l53v2RnDqc7fB3LYf8T1A=;
	b=l+Cjw7OG2qwJ/AA8Be9CvZyJpJESVl3lMp/cdGoJVS+/+WDb/bMu/WWw5nzGp70KGcje3j
	Mi0jFS4y1fC/+4nESGxAX5vm32Dmxjonmq6cOXsF/LY1k9RqCXIGHrGKFAG/JoC5iWVPGv
	ne3YlonUnK9y4u8P0uN7l5YbnaUM79Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WIRA0046;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787645214;
	b=wuRZDzFgtGnOsh3EOmlnCEKWcTCtMzzHKTZcfmm6qyeBqwCdGxvLStZjmMfg7+uN59C/U0
	QcWZQ9UjN7ItLgOoOHjxAi//DqGkXMN8pFhYX0YNTxPSPNV9+64vyVEWv/oArtfB0v0Iry
	AIiF8Ar1j6vFwPzoTEa72JMKjmIM99c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787645215; x=1819181215;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=30YZPOBuBOe+Np7Wv7h084Pal631E59jEro+sbTLKVU=;
  b=WIRA0046KRGVRdCHG6f15liNN14lnW6/KD71mxJNtvXXUOhGgYABoXOQ
   8riy0LdLdx08/jjwdQHYSRLLmQeSU2TGbBZNoHaThE8Fs+T5Dk1I8lfWD
   jcP5WwLXQe9psecmaMOtuOnn9nGNKwuMieHymC5/vkNViaJQjFAMiETJr
   VTdkEzXPcaxIIHzHrMv2ZnSVOWHwbkAi4jrw92GE674XL13jIWGk1sLGd
   JgDUhY/RbYFxFtJd4fi0RHBFzquASaEnyPsuvK5WK/uSN0dXyGhj1K/4a
   j6iLkfq81P8cRC94rHqM4uGZB2Cv6wubpuydTQr5ifPGG8RzowsgKuX5M
   g==;
X-CSE-ConnectionGUID: 8f4XspiQRD2etKTIwe5cbg==
X-CSE-MsgGUID: 4cGSpsbxTFK1ZpYBTC6MHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="99628353"
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="99628353"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 01:06:53 -0700
X-CSE-ConnectionGUID: a+HswYlATkmepGAtw+t6ow==
X-CSE-MsgGUID: RDsZmMluTTORAfJvfKMcxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="305453059"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.119]) ([10.124.240.119])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 01:06:39 -0700
Message-ID: <5f7b62a1-957b-4a43-9a16-d06b3f916e84@intel.com>
Date: Tue, 25 Aug 2026 16:06:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
To: Sean Christopherson <seanjc@google.com>,
 Ackerley Tng <ackerleytng@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
 <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org>
 <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com>
 <CAEvNRgGOyQHnF_b8dk8E0d7_=CcwXtYUdU3ko7Qbep+_O7UC0Q@mail.gmail.com>
 <aoZZMQ3Uc8yQWPNA@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aoZZMQ3Uc8yQWPNA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d9f17mgi6nj4h8fnhfzzwt7bgn9eu3jw
X-Rspamd-Queue-Id: D26B540003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787645213-47307
X-HE-Meta: U2FsdGVkX18Xe1e49HtIrRmgbi10mYvsomeVi0mdNVqSOpblet/N47LUXzY18z7mWmp5UC6OpnniJ9hLahNIijbF5p8gEFeoh8wMm6BGnvQ07PE98wX6GPf3KNkSKJMniBgI+ut+uYi7EaJAUC8ltuD6QlDar3bv/L4zvLhgY7rXfXlt4sy4rbZEp0oETjaahxPeY78oiNwg0KMtLqdiF7i6Hf+9MVpvaB62hVxc+8DmIoRd5xvviP8hdM6gH0RXLX+a9HwiDczqZ8yY2LZtjNmsr/szr+yT5e+QfnXAZ33pfK3n7+1HkMwrWq40B25qvojwrWq/dLmmaya68VAQKo/D6fIMtYgHVPvG0/X1OOBMmvuamaxlafNTrQ6I6VeZaIjhpeR01aeSeeyNbKaWR8nM2Wo4TL/ub2dhz+7xnnTzDB46vZfD0q+8NM87PMESQPAjkLYTgVWw1mY/Sk+IFXu4S4u5//qAYONNLL3zoCH00SswYL5K0GDXLHgDlSywmpO1VzDGUU/+EnkOpZGHBDCQ/GQn0qTjpCF+qbjeJJBcMu8lr4yo12SeJooVfBL4pn7jU886RN5f9XwBH1Jvg1DmKfvF73fAMvpGKeFIKYqnfpqO5KTIcc8R2iDcOp6OnQrurxXpZzJ5L3TIUR3ftIbjM0XkAle1OK+yMqe/EvjI9FTgURQZqFBSQAhniSJFAIQ2D90H6zkT6UnioDTsVeY0rOHxzULC4/mZUuZgLO0ZTdRZL4Mu9vSOgo/mc83XWMVSJVZslli68C1jBuQvWShi6c2kTrABTt/1UlEbx/pxtY8Fifgy4TyFq1Cu+vbVsp9i/qKRt/N2ZBsJBS6K9DO8uhyEJTJKjv1+HFgoE7Ib1PpMepO10SlIh/OdNHZVNyBNupC/iNsaXP2div7DAbU2OnS+9HNWC0sE4yN7QD6ZsNwh9YNmVtWT83rSK09DNUGke9nNRKwJjNMVxwo
 PJQqpIU5
 P1UIUe69On3uLmeAtGg4rzj7KTHcU+PY68VdaImoHtefW1DAIaCxHiLHi575sZN5lHOFw3w5VDF8Qly3xDzq/oc6VJUo26bvEj46PbFTePZZPTsHKmwxJLwujI452Oivhv148qu7nN7i+Nat+LkFMDxoCpYDlKx7JIKNE2zHJjt/C9o5SjbeITTLR2wlkDXk5asY01OSbV4VakMoIA37EwEY/8qr8w+ygLTjw3mwc6kRYw0c7PuYH9FImhaYSFGfyo6OUCzaT0cVUKMbUDtBUNOR/wQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/2026 9:32 AM, Sean Christopherson wrote:
> On Mon, Aug 10, 2026, Ackerley Tng wrote:
>> Sean, do you know if looking up attributes in gmem to feed the KVM MMU
>> the smallest set of pages to zap will improve performance significantly?
>> Or if there's any other reason to do this lookup (more complexity in
>> gmem)?
> 
> While working through this with Ackerley, I realized this patch is buggy.  When
> in-place conversion is NOT supported, then as evidenced by the current code,
> invalidations are guaranteed to only affect one of SHARED vs. PRIVATE.  And if
> we change that to zap both, we risk overzapping.  I.e. it's not just the cost of
> the extra MMU walk, it could also be a functional bug.
> 
> Specifically, if KVM zaps both when SHARED vs. PRIVATE is tracked per-VM, then a
> PUNCH_HOLE operation on a PRIVATE guest_memfd will incorrectly zap SHARED mappings
> that have nothing to do with that gmem instance (because they're mapped via a VMA,
> not a gmem fd).  And vice versa, a PUNCH_HOLE on a SHARED gmem (if userspace is
> using an INIT_SHARED gmem for the shared branch of a memslot) could invalidate the
> PRIVATE mappings (of a different gmem instance).
> 
> That latter case in particular would be a functional bug, as spuriously zapping
> PRIVATE SPTEs is fatal to TDX (destroys the memory contents).
> 
> So, for the initial change, we want this (full patch below):
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 75979c885e03..8ff2ec148614 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -138,6 +138,9 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>   
>   static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
>   {
> +	if (gmem_in_place_conversion)
> +		return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
> +
>   	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
>   		return KVM_FILTER_SHARED;
>   
> 
> And then in the main in-place conversion patch, have the conversion flow to only
> zap tap the "previous" types (with prep work as needed).  Ideally, that would be
> done *after* the main conversion patch, i.e. as an optimization, so that we get a
> nice bisection point if it's somehow buggy.  However, Ackerley pointed out that the
> conversion flow invalidates the entire range if the attributes of any gfn within
> the range is changing.  Addressing that would be rather annoying, e.g. there would
> need to be multiple invalidation ranges to deal with interpolated conversions,
> so going straight to a "zap only the previous" is probably the least awful option.
> 
> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 19 Aug 2026 18:06:38 -0700
> Subject: [PATCH] KVM: guest_memfd: Invalidate both SHARED and PRIVATE mappings
>   for in-place conversions
> 
> When removing one or more folios from a guest_memfd instance, invalidate
> both SHARED and PRIVATE mappings if in-place conversion is enabled, because
> stating the obvious, KVM needs to ensure that all mappings to the folio(s)
> are dropped.
> 
> Opportunistically rename the helper to capture that it returns the a filter
> for all gfns in anticipation of zapping only the previous mapping types on
> conversion.  I.e. when doing in-place conversion to PRIVATE, only SHARED
> mappings need to be zapped (ignoring that KVM would ideally not invalidate
> ranges whose attributes aren't changing in the first place).
> 
> Note, precisely zapping only the possible mapping types when in-place
> conversion is disabled is important for functional correctness, not just
> for performance.  Specifically, if KVM zaps both when SHARED vs. PRIVATE is
> tracked per-VM, then a PUNCH_HOLE operation on a PRIVATE guest_memfd will
> incorrectly zap SHARED mappings that have nothing to do with that gmem
> instance (because they're mapped via a VMA, not a gmem fd).  And vice versa,
> a PUNCH_HOLE on a SHARED gmem (if userspace is using an INIT_SHARED gmem
> for the shared branch of a memslot) could invalidate the PRIVATE mappings
> of a different gmem instance.  The latter case in particular would be a
> functional bug, as spuriously zapping PRIVATE SPTEs is fatal to TDX, as
> doing so destroys the contents of the memory.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/guest_memfd.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 75979c885e03..7ae05ce3cd14 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -136,8 +136,11 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>   	return folio;
>   }
>   
> -static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
> +static enum kvm_gfn_range_filter kvm_gmem_get_all_gfns_filter(struct inode *inode)
>   {
> +	if (gmem_in_place_conversion)
> +		return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;

If I understand correctly, above diff is dead code and will change 
according to

   And then in the main in-place conversion patch, have the conversion
   flow to only zap tap the "previous" types (with prep work as needed).

If so, why bother adding the change?

>   	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
>   		return KVM_FILTER_SHARED;
>   
> @@ -188,11 +191,9 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
>   static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
>   				      pgoff_t end)
>   {
> -	enum kvm_gfn_range_filter attr_filter;
> +	enum kvm_gfn_range_filter attr_filter  = kvm_gmem_get_all_gfns_filter(inode);
>   	struct gmem_file *f;
>   
> -	attr_filter = kvm_gmem_get_invalidate_filter(inode);
> -
>   	kvm_gmem_for_each_file(f, inode)
>   		__kvm_gmem_invalidate_start(f, start, end, attr_filter);
>   }
> @@ -344,7 +345,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>   	 * memory, as its lifetime is associated with the inode, not the file.
>   	 */
>   	__kvm_gmem_invalidate_start(f, 0, -1ul,
> -				    kvm_gmem_get_invalidate_filter(inode));
> +				    kvm_gmem_get_all_gfns_filter(inode));
>   	__kvm_gmem_invalidate_end(f, 0, -1ul);
>   
>   	list_del(&f->entry);
> 
> base-commit: 620f8362aaec3848ee8f465949a0701175fe0896
> --


