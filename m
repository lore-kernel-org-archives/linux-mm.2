Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 968C9C61DC4
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 19:44:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D916B0088; Wed, 26 Aug 2026 15:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BED66B008A; Wed, 26 Aug 2026 15:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ADEB6B008C; Wed, 26 Aug 2026 15:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 145C06B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:44:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE13C1C0F35
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 19:44:44 +0000 (UTC)
X-FDA: 85144448088.19.B65C083
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3F81DC000E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 19:44:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VgYV5cZh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3KUKPagYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3KUKPagYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787773483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kAAUyb+BT/S16pFGAm4l7OAoO0iSt3CMmhZez+eRZtg=;
	b=lihcJyZw91UId0ERb823S2U/NGBYCsNIkfQQYEs9/uICiq3kHPZZlp9GbSYL68Azr3+YbW
	bFGWczZFZsDf7DT2CWQI/APKNXOl40keYQSdUw/DKwKaDlAgCRGJFuwgw7gH9XoAv1HJuJ
	wC0Z/u8G/plTRvrZSut/jwwRAiaX/ao=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VgYV5cZh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3KUKPagYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3KUKPagYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787773483;
	b=QmufbOzHanhjvSNBbvQjxK2vvqNbntRMM752Phynn+qyflR4aFazPSBnrf3YxxB6QUml+W
	pXFxpjOqTwJaIO7fAv2nlqfnLwQ/EvCiKT0L0uWNTVk7aKWNKWPP/nGhmyAAaa1fLzR5X+
	Tv6nGnmDpWBkdtWLb0GVjoBKCCbIxzE=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbb20f82a0eso970207a12.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787773482; x=1788378282; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kAAUyb+BT/S16pFGAm4l7OAoO0iSt3CMmhZez+eRZtg=;
        b=VgYV5cZh39ekT8Clt1zImsPD6fm6k47hG4tEhfSOqzRqJjOanczmPmpUssx53/3VSi
         himQ4MH7PtP22drA2zhHBulKLTO4ZpHV0D5oUdefCNT2PTSj0fI/GXFmKKx5XdPAwNRB
         GwQCjcIQIUB8qItASZZfM/y1tg+XkR/rcKFz63v6NPV6d7m9FvFJsgCHVyjJ7RqhbL4i
         q6K6pqbAxJ/p6Fnuy5OUsSUVM0WHq+OkJy9b8zwwitCHnOyM4Hh/9ZLkROvmA8oMZGQX
         R4CXZCrxFloofGBiHHuuF2ZMNzbNw6ZYrEtBwe6JM5/5NPX0YRKNu3DcpwT+NnR7jlgk
         dG3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787773482; x=1788378282;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kAAUyb+BT/S16pFGAm4l7OAoO0iSt3CMmhZez+eRZtg=;
        b=VheGM1JjOIAVqtOw1EWOY1WwjQ5CxK5FJSXG+fn5DnSRrqticj/Z4OYij4EMYkN2CQ
         +stVVn4b/ndcgIZeM5c+2s5nHlG8m83W8K3QJsWtP2yrSh3qqcrJXP7wzkZa5MfRSE7d
         gXm92+RsXM/OJt5bk7uFAtlDCJnfW8qwDM7ddb7gI553dVPGUSyeNGI2ljhGxyiMAt4L
         TOX1VcMjxis3IYpZUISRX0GNwIhQShvem9zPWUAlas00EMRTeYFM92FKKwDSW5tyDt3l
         lXenklQ12MufQMwkOwcHIj4BsCkg+hdGvgX5J0WeqzrwHL6ybdfxE7vSFHkIM85BkNvK
         mg6w==
X-Forwarded-Encrypted: i=1; AHgh+RpvO2NQ+S5t6rjtYH2xkPZHKlcDO6eM/g+xxUnAiMD8Q7ginbgz8tQpAowrkyUw8+NN+y7motsT/w==@kvack.org
X-Gm-Message-State: AFuF++lcnG0qcgbPeUbbiKn6UvAD46YvSLceaG+MqSnL1YVBE9tU+4/Q
	g0T8uYJOVn36QUQAPycCLWNlS1Ls+l/3//WJsQt3C+LNcsIjJ8boHWQaDQzeNydDvNx166Y9XvT
	pXFTG0Q==
X-Received: from pgak6.prod.google.com ([2002:a05:6a02:6746:b0:cbe:9e80:c394])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3216:b0:3c0:b943:f984
 with SMTP id adf61e73a8af0-3cf76286193mr19120390637.3.1787773481481; Wed, 26
 Aug 2026 12:44:41 -0700 (PDT)
Date: Wed, 26 Aug 2026 12:44:40 -0700
In-Reply-To: <20260826-gmem-inplace-conversion-v11-15-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com> <20260826-gmem-inplace-conversion-v11-15-0a15d8a799aa@google.com>
Message-ID: <ao9CKMXAX-hScRSa@google.com>
Subject: Re: [PATCH v11 15/46] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3F81DC000E
X-Stat-Signature: z9kcep476aeg8m7rz6imp8h9tyjnid6n
X-Rspam-User: 
X-HE-Tag: 1787773483-627350
X-HE-Meta: U2FsdGVkX1+sahWfwlmt0EqBQepyvx6FOjkbLSHsu3jw8dtMrmg1BZ8rfp10gZ66p2JLa0NWoClQCjas6LpoEi342ZHRR+72Wzu+Ls77xeaPowxovuhF3/510FVhVar26CZ3o8MZwR/gQOELuUG/qrwbBJwCAPJBZOkR/CcFu1gDwaUjSxPHKBUD8N69PMLYnIpObBzMB1OQE0zGrd8MPVr44J22kbisSVTjMz+kH6ItH9a1kSrfKx81A81C+LllhU+bgR5IuPFrXLjnTCixELUJxA57gEv1ob0j+IXDoc7W+NG8H1g+9POjbbFxsqWGCylL2Hg6ZQbxP7jworM1SBfP0jbx1wYZmRjOSbZxu7FSLL5VgENvCN4DNd2sgK1mYuWf/nslE0NckfjmL2M9J8RCow/36KbjKgEkq5byIN+RFpW/Fr5o6m2MRZAUlM+It1tnfRbaXFFK4b9/2UK3OYwxIik+e2L6h7lL4+mPav/pPMxGvRvASMj+6Rtyx/DguZ2WOjfGatv3QijUiXhVM4TlIeVqjmezr3xzzwJfAS5WeB1YKItEHibA6lo8W3i4sMSgCIu3Kqsfy5gAxRlokUyeMy20CBSKQIsM/Du/UF2diYd9xmEnAFEEnRPCYdxI9aABzHVWCkFg2OXoIDAEAoVBCSogE8p0w9Sq3gH+cLmp0E+Ix3nN5HaYiQUBuiQlp4rECTGS1lMUENl8lttsKW4hqlouYUfug/qvzuSW+1JR8ASz0G+7ncKGVL3BVPV+3TroGeU8aCSNgFkGDVPbgVJnHEqaIeFJmajBci9U1ahi601hpchHR+N5tvddi3eA9Mr4iIV7Ww2rSPqTu3H/BklQJvmUSdh0eiUmsf0CYb1rtQwNaZx5ozKXy8Ss+Xlu/rMjsE8Bfs+cgQ5c7z1lnE2m1LFHoStE157oFRe0z4D579bDm50fG0mdLez5op1fe///7qX3bCi7fsnSRDd
 x9xwhim3
 7OTOKdjmN0CQubJFarNzjGdEk3NJ+XZtIXm5lSgKbpeg161xYavFLoqWIqtiXSWuUEgGmgrQ8oXYvNrkNOoJp9dqi4P2pHOG6qlACcpCK2lXviyqOmqM+4DN4QOutMnWJj/9S3SbU7QeyEtcueHrISnjTGTDoEwoZjnwrqoaqBVTR8GmlurR6jXYxjbucx+N0hIHMZkpfW8SEiR6MBJqLVK22p5+Uu8FOBLXJnPs6p4mPKHz3vmap9T+RXX1IxXKjnxsPKdRzvbB6QS91buikjNawpT6aFEjYxLHmw/ZXHzgxK4gEuC7LJ1XJvhFH8kplrzKtRXVqDuJ3gCcOVcvQZ2qUo4HXhYh3my5bCtLvIHLS4VkfS0pnVQ76dkyfPfuvnoJaEIhhSM7WyOJEoUIkIJHPZwIL2qQAJjX72TDYAcovpLMTxrJMEfCaPq9GeySAXG/FNpKHWvKimlg89wA7LYmxJ1/cfK93zFGI+TADxPiNRrTm8gvgG+Zr+Dd+g2INGaudLI7OpWENu3RQV2Cu8u5omwA6L6a2S3o+ITJvXSilpZZec28teJBwkx7OCHepikFfa5h4jzJszZy6ELyqUmBC8VL5mWau9AjQGQQ30033qah1ZjmpE9dgAc/p28S9Dd5IUq0GVvsXAcPdFvmPYpWnu6EHbLI61IcuWV/oCmHO8JY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026, Ackerley Tng wrote:
> Omit support for calling the arch hook to make private, since SNP, the only
> implementer of the arch make-private hook today, would actually prefer
> making private only just before faulting memory into the NPTs.
> 
> Calling the make-private arch hook would require iterating both bindings
> and the filemap to find the intersection of bindings and allocated
> folios.

Why would KVM need to iterate over the bindings?  Only the RMP needs to be updated,
whether or not the RMP is currently reachable is irrelevant, no?

Subsequent calls to kvm_arch_gmem_make_private() from kvm_gmem_get_pfn() would be
superfluous, but that's already possible, e.g. if an NPT mappings is removed for
whatever reason.

> On top of that, SNP would need to figure out whether to actually
> make private based on whether the memory is about to be faulted, or
> whether it is a conversion.

This is a non-issue, no?  As above, sev_gmem_make_private() already bails early
if the page is already assigned in the RMP.

I don't care terribly about how SNP handles this, but I do want accurate reasoning
and justification so that if/when we revisit any of this in the future, we can make
informed decisions.  Because unless I'm missing something, this is an optimization
choice (eager vs. lazy to-private conversions), not a complexity tradeoff, and it's
not clear to me how we decided the lazy approach would provide better performance.

> Calling the make-shared arch hook and not the make-private arch hook does
> leak SNP-specific details into guest_memfd (as in, why only make-shared
> during conversions but not make-private?), but the additional complexity is
> not worth taking on until guest_memfd has a user actually requiring an arch
> make-private call.

...

> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
> +{
> +	struct folio_batch fbatch;
> +	pgoff_t next = start;
> +	int i;
> +
> +	folio_batch_init(&fbatch);
> +	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +			struct folio *folio = fbatch.folios[i];
> +			pgoff_t start_index, end_index;
> +			kvm_pfn_t start_pfn;
> +			kvm_pfn_t nr_pages;
> +
> +			start_index = max(start, folio->index);
> +			end_index = min(end, folio_next_index(folio));
> +			/*
> +			 * end_index is either in folio or points to
> +			 * the first page of the next folio. Hence,
> +			 * all pages in range [start_index, end_index)
> +			 * are contiguous.
> +			 */
> +			start_pfn = folio_file_pfn(folio, start_index);
> +			nr_pages = end_index - start_index;
> +
> +			kvm_arch_gmem_make_shared(start_pfn, nr_pages);
> +		}
> +
> +		folio_batch_release(&fbatch);
> +		cond_resched();
> +	}
> +}
> +#else
> +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) {}
> +#endif
> +
>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>  				     size_t nr_pages, uint64_t attrs,
>  				     pgoff_t *err_index)
> @@ -624,7 +661,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>  
>  	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
>  	kvm_gmem_invalidate_start(inode, start, end, filter);
> +
> +	if (!to_private && kvm_arch_has_gmem_convert())
> +		kvm_gmem_make_shared(inode, start, end);
> +
>  	mas_store_prealloc(&mas, xa_mk_value(attrs));
> +
>  	kvm_gmem_invalidate_end(inode, start, end);

The real reason I responded...

Thinking about the Secure AVIC mess made me realize zapping NPTs for SNP VMs isn't
strictly necessary in this path.  The PFN isn't changing, just the attributes, and
that's (obviously) tracked in the RMP.  KVM doesn't need to zap SPTEs to induce a
fault, because the mismatched C-bit vs. RMP status will cause an #NPF(RMP), and
AFAICT kvm_mmu_page_fault() will do the right thing.  A misbehaving guest could
continue to access the shared data (assuming we stick with lazy conversions), but
that should be fine?  E.g. it's not really any different than implicit conversions.

In other words, couldn't we do this (as an on-top optimization)?  The only wrinkle
I can think of is that it could delay reconstituion of a hugepage, especially if
we opted for eager conversion (because the guest wouldn't hit #NPFs to trigger the
hugepage promotion).

diff --git arch/x86/kvm/mmu/mmu.c arch/x86/kvm/mmu/mmu.c
index 62f751952ad8..61f3e270ab61 100644
--- arch/x86/kvm/mmu/mmu.c
+++ arch/x86/kvm/mmu/mmu.c
@@ -1670,6 +1670,7 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+       unsigned long shared_private =  KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
        bool flush = false;
 
        /*
@@ -1683,6 +1684,10 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
        lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
                            lockdep_is_held(&kvm->slots_lock));
 
+       if (gmem_in_place_conversion && !kvm_has_mirrored_tdp(kvm) &&
+           ((range->attr_filter & shared_private) != shared_private))
+               return false;
+
        if (kvm_memslots_have_rmaps(kvm))
                flush = __kvm_rmap_zap_gfn_range(kvm, range->slot,
                                                 range->start, range->end,

