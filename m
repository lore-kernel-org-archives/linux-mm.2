Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FBECCA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 09:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AEC26B0088; Tue, 29 Sep 2026 05:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738216B008A; Tue, 29 Sep 2026 05:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FE946B008C; Tue, 29 Sep 2026 05:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3509E6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:49:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEB0A40497
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:49:46 +0000 (UTC)
X-FDA: 85266327972.25.CA5E0CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 16C981C0009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:49:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MJEDp5k6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of naveen@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=naveen@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790675385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EGzsamnE7S9zSPfntnKu9/cfo1q7r+TWTQ73npLdn0=;
	b=3hlmdoBCg5wBskQyWjgoDvf3CrxPXozhT7aAILcp+xv8En9iojyYyidZGnieonlZ1kZ5DX
	eFlaIkRRuQ7wqkNx4UHmuaZTKY6GQ13SP+Kk6VNSyobWEwxKuAouULYkl5Z654P/WwKVH4
	eXz3bWJv0TAWVnIOAY6TFmok0+CqyxA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MJEDp5k6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of naveen@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=naveen@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790675385;
	b=QbwLYOmdGa1pyjbB41K3lVdk904BcDzAjnQc6RYHey7nELI5U1AkAoCYJ17eILyldZWyQS
	y45AqdIwM6S472po9Y0vv12d7/652juMrnRSulhqWDw6YfqG+5U0XvOF6siMdeWhXfsZNT
	F8Ivd/aK8NI4Ntnk9rVBoJz9xW7j+zo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A10D60218;
	Tue, 29 Sep 2026 09:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDD31F000FF;
	Tue, 29 Sep 2026 09:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790675383;
	bh=4EGzsamnE7S9zSPfntnKu9/cfo1q7r+TWTQ73npLdn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MJEDp5k6Ucc8s3Ifyqwotl+EOWiB4VH4kDYItmut6mgr4p1E/fmdMvwOHJTXukLeB
	 lShwNXpwS3GAq/BhUEwLMKlSNEdSOMbXvC5r4cSpQP4Nok6AvIHRvKixxlTMTjyjiF
	 luhwn9msVSLEZnDoSn/SY/pi2BvbgXSp7DyFh8mXZr5MoN+Vjd+aeUjDzmRpDqR0Bw
	 v/UfiISJWwrUkNbctv0c4I4elnCaOY2RS1qLupTGasgl7rPeeTH2FOZOnOC4xe9Sfq
	 mCx6OtB50a0+nCo0u9eENpuVd9OFkoY+mf655PeiHb5T0eykMekeRKD1wnk4BKG39T
	 T2TaAKHdE6XNA==
Date: Tue, 29 Sep 2026 15:10:41 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, steven.price@arm.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v11 15/46] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
Message-ID: <art6ARechyK0iytK@blrnaveerao1>
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
 <20260826-gmem-inplace-conversion-v11-15-0a15d8a799aa@google.com>
 <ao9CKMXAX-hScRSa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao9CKMXAX-hScRSa@google.com>
X-Stat-Signature: r7pr9fftkq9cj87m3kjfn3n1nd5ttbsb
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 16C981C0009
X-HE-Tag: 1790675384-618531
X-HE-Meta: U2FsdGVkX1+88Yle+9JDZksGcJX90DrUKw2W2N/ASWBXAFG1llfNktXhIrosmQs1MzbdjMCntjoj1OkKq1pq3ADt0p+d401S84BL0r8AHhaB0RcmTtuqZH93RupAxu+uGcZQGLAGHRRYst2GV2TG7QGFbfEVlX8RXbrxWip5jv02DjmLvIQdCr05OPr9UTWXdu/6o9Qdt4lTVBPBdvw1A5VH6eFTJJ1IvDE3mJlDXn8SGS9jnVmcrfvbiZnRYPrXYcvqvI+nMP6yyVvQXnhn6Wv3Uc5at4zFJ3GsNIy2nLH4LDKDWZJ8wfXWmpvhSfqcCKgDqJWY07RT7IF6Peld8PnNVsDGMNVhYRGHmO8AgEhOjQVDKhE1kbf0c4MTQ0fBObR2J18iA9rXJfoQJQjAGA28CrdMtdpQm5poe4BNnss8vLF7zqe7gdkc5TsJ9kpXPFe2GZqZDzOoKWxb3Z7oee7F3Jk+Z6F5iYmQ/BrJlNgJoeYBbVekyk5cWPT/UsCyTMe7ciZQuKrOH3KZ24Im5JeQcXM6NShwCLQ/+28ieWSSPtIAj4uGrlwVeruL/V1he5HzwU8wqVcfa7MGhO+7mZQ/yd91fJWs33AcGqvQnyf+hgbjJKl+WtbJbwDFEcZ+ktv4C1+vJPHM+9pv9sPZGeBeKdhMtj2G6oRWTJZQuvMkuyAN5ZLRwQJgiIfrQx73y5cxoTEG9XhYHV/b6NwqHFYGn5FLiGxbOM6672zl8Vn4GZejUaQ+nYJD4WEhgbIPaZeB3AhClVEldHw5FQMdZIcfEUfdpfQbgsE+MZajztooyzU6ojEedk5fp8O6mBo/YdWtsVaWPMy+NZeooC1vyPKnFsVkJ/l3CP6lXoQWYlpj4pngmtVrsgHdpSSfyJ0WFpyrYXsHOGH+bYZ+pwjibEf40bKcl6R/rSObJjcEZhe7fm00PZz+ggUAIUhr06hPo/NOrOZjBkyJBQSDgqR
 fzecCbEk
 IWqXKMz8aKlV+vWqzYHJVKYclaN2GffkxJSGL3VwhfahIE3HvTkThHIJYZYJpJ4QscfktikvngU8TUT7mR8tcm3MukKHrxdnvY7k/w2ru9uwvRgH5BAn0uqQbwI6aXdTuq3O2XyX3bSTfgdxM3QjNXLQ8CLJ2J4WmEcLV7AZ61k+EJ2Ur6UaUF9xEZD2oE11+n8VtBbjieWUnqvjkdOG/gmpnYvPFJrnhhT/Py6pDUWS4DJHiBWfMcJ7kQmek2f4wluulbH+P99kqAQuIhakdwlaS7nAxFvoCS08UgRgTocevlSw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 12:44:40PM -0700, Sean Christopherson wrote:
> On Wed, Aug 26, 2026, Ackerley Tng wrote:
> > +
> >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >  				     size_t nr_pages, uint64_t attrs,
> >  				     pgoff_t *err_index)
> > @@ -624,7 +661,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >  
> >  	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
> >  	kvm_gmem_invalidate_start(inode, start, end, filter);
> > +
> > +	if (!to_private && kvm_arch_has_gmem_convert())
> > +		kvm_gmem_make_shared(inode, start, end);
> > +
> >  	mas_store_prealloc(&mas, xa_mk_value(attrs));
> > +
> >  	kvm_gmem_invalidate_end(inode, start, end);
> 
> The real reason I responded...
> 
> Thinking about the Secure AVIC mess made me realize zapping NPTs for SNP VMs isn't
> strictly necessary in this path.  The PFN isn't changing, just the attributes, and
> that's (obviously) tracked in the RMP.  KVM doesn't need to zap SPTEs to induce a
> fault, because the mismatched C-bit vs. RMP status will cause an #NPF(RMP), and
> AFAICT kvm_mmu_page_fault() will do the right thing.  A misbehaving guest could
> continue to access the shared data (assuming we stick with lazy conversions), but
> that should be fine?  E.g. it's not really any different than implicit conversions.

Brilliant idea!

> 
> In other words, couldn't we do this (as an on-top optimization)?  The only wrinkle
> I can think of is that it could delay reconstituion of a hugepage, especially if
> we opted for eager conversion (because the guest wouldn't hit #NPFs to trigger the
> hugepage promotion).
> 
> diff --git arch/x86/kvm/mmu/mmu.c arch/x86/kvm/mmu/mmu.c
> index 62f751952ad8..61f3e270ab61 100644
> --- arch/x86/kvm/mmu/mmu.c
> +++ arch/x86/kvm/mmu/mmu.c
> @@ -1670,6 +1670,7 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
>  
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
> +       unsigned long shared_private =  KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
>         bool flush = false;
>  
>         /*
> @@ -1683,6 +1684,10 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>         lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
>                             lockdep_is_held(&kvm->slots_lock));
>  
> +       if (gmem_in_place_conversion && !kvm_has_mirrored_tdp(kvm) &&
> +           ((range->attr_filter & shared_private) != shared_private))
> +               return false;
> +
>         if (kvm_memslots_have_rmaps(kvm))
>                 flush = __kvm_rmap_zap_gfn_range(kvm, range->slot,
>                                                  range->start, range->end,

Can this be a problem with gmem hugepages? Not sure how that is going to 
look like, so this may be covered in other ways.

But, as it exists today, if the guest converts part of a 2M page to 
shared, then this skips zapping the SPTEs from the call in 
kvm_gmem_invalidate_start(). sev_gmem_make_shared() then issues PSMASH 
to convert RMP entry to 4k entries and we end up with 2M NPT+4K RMP. If 
the guest then writes to any private page in that range, 
page_fault_can_be_fast() returns true, fast_page_fault() only checks 
permissions with spte_permission_fault() and does not do anything.  
sev_handle_rmp_fault() also does not issue a zap since it finds that the 
RMP entry is already 4k, and we end up in a loop.


- Naveen


