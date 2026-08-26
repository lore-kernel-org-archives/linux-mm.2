Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C502FC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 22:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E1A6B0088; Wed, 26 Aug 2026 18:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF9E6B008A; Wed, 26 Aug 2026 18:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD906B008C; Wed, 26 Aug 2026 18:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B46C6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:33:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8F9A1A0286
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:33:47 +0000 (UTC)
X-FDA: 85144874094.20.0858071
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3CB3D1A0008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:33:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Zy/0oyLn";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3yGmPagYKCDUjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3yGmPagYKCDUjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787783626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IpUANZHm7Ku5ncYu7RPUYz8NQSkFG4aKOc/nSfGf9bs=;
	b=MGhXQ4dlrG4XNdP3zzLaKxE2z9APAl8gR2qjo3U0Ks3pDUCjc1uCB6tJlMTYvxjk246SBY
	whePDt1JcpPvGLNLCiEmelxmuWu2sKWkmk83awlhXDctfseg9BjU0+kbYlD2DbF1uS5zS2
	6ByK4GIrArO3e6dGBINL9WSFoP7qOvw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Zy/0oyLn";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3yGmPagYKCDUjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3yGmPagYKCDUjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787783626;
	b=D6lloBAfI5sJxx0Ysmeccm1HHiuWhPZQr5E3nqrCg16Ix34t7ov5hn63lYaAThuZ8IKNFV
	MeFGYo+MLOh07Oq6D0YyPwtUvgvCfv+fNbrdJwWv8WedkYcEGVkUKKhYz0YilzoTUdNoy+
	1CrZkTFcpKTYUsHPHf8yWFtb+H7eUmc=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c89704da8c7so149872a12.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787783625; x=1788388425; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IpUANZHm7Ku5ncYu7RPUYz8NQSkFG4aKOc/nSfGf9bs=;
        b=Zy/0oyLn7p0QkzjflHH1WdkGqkFgqP5jIoDdvMAB/BICJrzxLZd8US0C6gZde16CR9
         MNUpRpcOILkRGBEQwjZYs0BA0GNuxtXmnQ3juUmN9ZIvw4y1mkNDAaZgMaF5XFhIA7a4
         7TdoxVQYws36Q1uwp2M0TPHEJBndpba8cPNme8C/0NQJoaBCF6h8/W2ZQSTLBGOvy8Nf
         VV39aFXhWkAPihAt3lXrmCK/qVt3axG0YeZLC8GwzJ7K6H1HsxVMxgi61tx3BU4S/5p3
         TGfwdyo6lOv7HP/XD40cIiZ3DEjNnj3GJSlaGx2Azse9RWbU0RF7ejIClqfts5LiE2ug
         MEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787783625; x=1788388425;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IpUANZHm7Ku5ncYu7RPUYz8NQSkFG4aKOc/nSfGf9bs=;
        b=aurTjf8wmqFGOsZDEDP/6l4re9uREt3tYnFy13uC9UgE6HA8i247oiQbHEMX5td/iN
         Rp1mKL3S1JqGL1EDk/9bgCym0jYFK95yDOA+G3TkZQ+NkFgSvLdfc4Pgys7KaxavzjrI
         mKwWiD38aR6lg4Ge1PH0e6G7Yo3Wr7ZKy7lXg4dK+gRl725D56l57/WO/n6oDGtOa4sz
         Cyzj2AvkR9zEemCFdLICqQPEz/lroK4hilaIfnhMs5C/DtSgKmMqH1sh23nKgeotlJK3
         2zk9/97xaAVzGXYafNNPjL4K0dX1vOHG8vezgaefdqjXtUSrNzF/etCCVhQU0YVY8TxY
         YKog==
X-Forwarded-Encrypted: i=1; AHgh+RqZysmam2RUp+RU4iyzdVa68dKqbF6j59sooNhoQ768/3z684JNNHRC3uAY9aXwdevWUx8YAABSyw==@kvack.org
X-Gm-Message-State: AFuF++kClDf5NE5xaXaBh57hsjgWuloSNH9FNeGEGh+V8qBH8e4rf46h
	R04te6whibTqt1mPn4ugJD+118HTauqXR1ptkizElOTJCnk36LHoFfSdH4H63a+D7aYBIBgFVXj
	aItWZiw==
X-Received: from pgvi12.prod.google.com ([2002:a65:61ac:0:b0:cbe:e0a7:536b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c786:b0:3c3:b57b:627d
 with SMTP id adf61e73a8af0-3cf84c5a493mr23198540637.12.1787783624481; Wed, 26
 Aug 2026 15:33:44 -0700 (PDT)
Date: Wed, 26 Aug 2026 15:33:43 -0700
In-Reply-To: <mtbqvvvpwbzybgy6z47lwui6ag53kyubub3hkczui7u72zxesl@lnwsglrgwl5p>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
 <20260826-gmem-inplace-conversion-v11-15-0a15d8a799aa@google.com>
 <ao9CKMXAX-hScRSa@google.com> <mtbqvvvpwbzybgy6z47lwui6ag53kyubub3hkczui7u72zxesl@lnwsglrgwl5p>
Message-ID: <ao9px1j7CLYXMiGP@google.com>
Subject: Re: [PATCH v11 15/46] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
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
X-Stat-Signature: 5jqsjryjo3qtu1e5dkj9j4dqjth1csk4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3CB3D1A0008
X-Rspam-User: 
X-HE-Tag: 1787783626-555170
X-HE-Meta: U2FsdGVkX1/Z3f5tn8j4EqgYPeiHzaulm7kMYZvtKFiLQSwAuv8t115sRoJGnCuY2hyG2I13c275CdnC4ySTHC+CgAQ2uOuR36npK6eW4etN7A5ZquuyQXV9nVeu2Db7qzrVk7ixU25JeEomqFFBa4HERdKk77iiia5q51232hyYN1J06bnkRaXehim6WhJEvxXOzchnwjri/55s+E4i0Telfq+a8NqQ/79woiqWtKtyGKKjgbxDQgwyXWTqSntQl//puCj5Cay/FKCC0SwSaIYw8Rfci4NFKzhVgA3XpOmmRe1gQJZbv2ZjeA9HFycfs0F+RNBWz/EvfJwylIkl1tp69KfsJ4X+059XWPcR16R91pXPkd6nDh6yNhsACUMgUfXwVOqGLrHC8LliMdrTGfHaJVlPKutbZr3F1rb+dX+mRbS4Rz35z/jlgCI16VlFgvY7sefqNv/PQ9ECyVui+Ltd16SJwfeMDcAEg91Mn0zWGXcj9IMIHLuo+mVxY1bAtHDxL5m4df+PmRtXXSSkBXBJfVqcdGE8Jx1sHJIOOZkSurl9ie305O4Sruz/4YiL4m2bhjdHjH0H1AQs3UL/kYUAQiI/hQpEQnz227uR51rQGY2BHN6yiZ8oizPct0WUyfdDDVxNZtv1KE5YBCMEqnPJgjKmjuzXfiGKaRHDS6BKNm+AC9hqBNSJHOPrV3uZNEpCEiiEcSwWpj7EB+eUlSNpgxP9t6i3hEIsriZJngEzgZroBqr4PJ6s/D2fMuWFa4cLGvVFAMruUsuXtkz8RqMSU9Pg0F2xBSH/7PLNNbNjfZPhJEtsbkQX6GrBZyNJmGjHUK7y+EiPTe6DIbEMlyPHOs/s/dl0VS3RBGVy/TsfGeHu5lZ+w4i3fXp810oWNuIWGYh6zy2+UPQMDMlvKpWlI3jAUbQ9ki//q8YkY9dgiVF5n0R8w4LxrrYoz1xwXHcjHmU1ON5PYw8wvku
 h5Z6FByL
 3pg5I1sPmjTghi+CkmlD3fY7IkO4teC6/NYp0Mtd//jzdaw2+2VE54bxnsaUonr6dhxUaTmt8vv1L+VGdElloA6aAnw9uingPrQt2TtFKlRaQcTQia62gcKutI7+ndPpY+8ltjvsfhjiGUR9gRfnEl4lIiPtVql6AYH89dVJ4+9SBp4LJNWgrUXB9EL7biOeuI6J7G9CdrvCiHci0h91WjILe0Hfw9Z0jR7bgBgAGTKlYJeo9mULm+cSsoP4rGgfOMpPvlKfdAzIVaNRFdLYsop6txZQ8/5Na/tnlGqsjVEZEXZMTs4GH5SkK8FpyYhXiAsv7R5yltlkuu/k/eHTjyqaQnqMKtU18gIGTyBG/c8rNZ0QNhIyLGimQ/jR6zgG1vx0sVcof5jNCfKdLY9zmVj5wfcfnoa2xzID0LPL+dGWP2TBqoyaGLE0n4l5OPnDh3rKX1ewY5J2CatF/WzCvyo7ncwvGEDs8qEsWlXRTVDno7RoNb+wNiBEyfk6yr8O/xJAdrn+4+d2o0j/02E4C/hWJg/gVD9JemeonVTkQyE6KodMa2G7jypxTRtzCOd/5Lg3p1Se4e5holk9yh+qsLx1OFssV7fI2rzPzJFzcMogZ8FD4dYCnMPkmjDtMg+cVdJ/iAIxzldkaTZZI88hPNYwy17Gv+ZaqkbaHJ/438XtXIgU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026, Michael Roth wrote:
> On Wed, Aug 26, 2026 at 12:44:40PM -0700, Sean Christopherson wrote:
> > On Wed, Aug 26, 2026, Ackerley Tng wrote:
> > > Omit support for calling the arch hook to make private, since SNP, the only
> > > implementer of the arch make-private hook today, would actually prefer
> > > making private only just before faulting memory into the NPTs.
> > > 
> > > Calling the make-private arch hook would require iterating both bindings
> > > and the filemap to find the intersection of bindings and allocated
> > > folios.
> > 
> > Why would KVM need to iterate over the bindings?  Only the RMP needs to be updated,
> > whether or not the RMP is currently reachable is irrelevant, no?
> > 
> > Subsequent calls to kvm_arch_gmem_make_private() from kvm_gmem_get_pfn() would be
> > superfluous, but that's already possible, e.g. if an NPT mappings is removed for
> > whatever reason.
> > 
> > > On top of that, SNP would need to figure out whether to actually
> > > make private based on whether the memory is about to be faulted, or
> > > whether it is a conversion.
> > 
> > This is a non-issue, no?  As above, sev_gmem_make_private() already bails early
> > if the page is already assigned in the RMP.
> > 
> > I don't care terribly about how SNP handles this, but I do want accurate reasoning
> > and justification so that if/when we revisit any of this in the future, we can make
> > informed decisions.  Because unless I'm missing something, this is an optimization
> > choice (eager vs. lazy to-private conversions), not a complexity tradeoff, and it's
> > not clear to me how we decided the lazy approach would provide better performance.
> 
> I'm not sure it was discussed in this context, but there was some past
> discussion around preallocation (i.e. "should we call make-private arch
> hooks at allocation time to allow for faster boot for prealloc guests"
> and then that ran into the TDX side of things where that would
> necessarily entail pre-mapping into the sEPT as well, so
> KVM_PRE_FAULT_MEMORY ended up being the interface we adopted for this
> purpose.
> 
> Since then, KVM_PRE_FAULT_MEMORY was added on the QEMU side and gets
> called after all conversions for both SNP/TDX, and even without
> preallocation it's a decent performance boost to SNP. If we were to
> switch to pre-calling the make-private arch hook then the
> KVM_PRE_FAULT_MEMORY call because partly redundant and in practice we'd
> probably see a small performance loss.
> 
> So there's real performance differences here but it's sort of been
> addressed through a solution that offers additional performance
> benefits on top so there's no longer as much to be gained here I think.

Or another way to look at it, eager conversion would allow QEMU to drop its
workaround.

To be clear, I'm a-ok with the code as-is, I just want to make sure we document
exactly why we're choosing this implementation.

> But I guess that's a moot point...
> 
> > 
> > > Calling the make-shared arch hook and not the make-private arch hook does
> > > leak SNP-specific details into guest_memfd (as in, why only make-shared
> > > during conversions but not make-private?), but the additional complexity is
> > > not worth taking on until guest_memfd has a user actually requiring an arch
> > > make-private call.
> > 
> > ...
> > 
> > > +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> > > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
> > > +{
> > > +	struct folio_batch fbatch;
> > > +	pgoff_t next = start;
> > > +	int i;
> > > +
> > > +	folio_batch_init(&fbatch);
> > > +	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> > > +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> > > +			struct folio *folio = fbatch.folios[i];
> > > +			pgoff_t start_index, end_index;
> > > +			kvm_pfn_t start_pfn;
> > > +			kvm_pfn_t nr_pages;
> > > +
> > > +			start_index = max(start, folio->index);
> > > +			end_index = min(end, folio_next_index(folio));
> > > +			/*
> > > +			 * end_index is either in folio or points to
> > > +			 * the first page of the next folio. Hence,
> > > +			 * all pages in range [start_index, end_index)
> > > +			 * are contiguous.
> > > +			 */
> > > +			start_pfn = folio_file_pfn(folio, start_index);
> > > +			nr_pages = end_index - start_index;
> > > +
> > > +			kvm_arch_gmem_make_shared(start_pfn, nr_pages);
> > > +		}
> > > +
> > > +		folio_batch_release(&fbatch);
> > > +		cond_resched();
> > > +	}
> > > +}
> > > +#else
> > > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) {}
> > > +#endif
> > > +
> > >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> > >  				     size_t nr_pages, uint64_t attrs,
> > >  				     pgoff_t *err_index)
> > > @@ -624,7 +661,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> > >  
> > >  	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
> > >  	kvm_gmem_invalidate_start(inode, start, end, filter);
> > > +
> > > +	if (!to_private && kvm_arch_has_gmem_convert())
> > > +		kvm_gmem_make_shared(inode, start, end);
> > > +
> > >  	mas_store_prealloc(&mas, xa_mk_value(attrs));
> > > +
> > >  	kvm_gmem_invalidate_end(inode, start, end);
> > 
> > The real reason I responded...
> > 
> > Thinking about the Secure AVIC mess made me realize zapping NPTs for SNP VMs isn't
> > strictly necessary in this path.  The PFN isn't changing, just the attributes, and
> > that's (obviously) tracked in the RMP.  KVM doesn't need to zap SPTEs to induce a
> > fault, because the mismatched C-bit vs. RMP status will cause an #NPF(RMP), and
> > AFAICT kvm_mmu_page_fault() will do the right thing.  A misbehaving guest could
> > continue to access the shared data (assuming we stick with lazy conversions), but
> > that should be fine?  E.g. it's not really any different than implicit conversions.
> 
> I think this should work in theory...
> 
> zapping NPTs means the vCPUs will keep retrying until they get the page first
> vCPU that faulted is trying to grab from gmem. If we don't zap, then they will
> instead be racing with the first vCPU, and if they lose they will be
> generating implicit page faults that trigger conversions back to shared,

Why would they trigger conversions back to shared?  Assuming the guest isn't
being silly and accessing the memory with C-bit=0, the #NPF will be tagged ENC
and KVM will treat it as a private access.

	if (is_sev_snp_guest(vcpu) && (error_code & PFERR_GUEST_ENC_MASK))
		error_code |= PFERR_PRIVATE_ACCESS;

kvm_mmu_faultin_pfn() will see "fault->is_private == kvm_is_private_gfn()" as
true, i.e. won't kick out to userspace.  Same for __kvm_mmu_faultin_pfn(), which
will call into kvm_mmu_faultin_pfn_gmem() => kvm_gmem_get_pfn(), see that the
gfn is private, and call kvm_arch_gmem_make_private() as needed.

I don't see how #NPFs due to the RMP being SHARED would be handled differently
than !PRESENT #NPFs.

> and most likely the first vCPU will re-trigger an implicit shared->private
> conversion when it does PVALIDATE. Worst case, the guest fails PVALIDATE
> due to racing with itself.
> 
> It's a bit chaotic, but it shouldn't break anything other than the guest, and
> it's only something we'd generally expect for buggy/malicious guests anyway.
> 
> However...
> 
> > 
> > In other words, couldn't we do this (as an on-top optimization)?  The only wrinkle
> > I can think of is that it could delay reconstituion of a hugepage, especially if
> > we opted for eager conversion (because the guest wouldn't hit #NPFs to trigger the
> > hugepage promotion).
> > 
> > diff --git arch/x86/kvm/mmu/mmu.c arch/x86/kvm/mmu/mmu.c
> > index 62f751952ad8..61f3e270ab61 100644
> > --- arch/x86/kvm/mmu/mmu.c
> > +++ arch/x86/kvm/mmu/mmu.c
> > @@ -1670,6 +1670,7 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
> >  
> >  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> >  {
> > +       unsigned long shared_private =  KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
> >         bool flush = false;
> >  
> >         /*
> > @@ -1683,6 +1684,10 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> >         lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
> >                             lockdep_is_held(&kvm->slots_lock));
> >  
> > +       if (gmem_in_place_conversion && !kvm_has_mirrored_tdp(kvm) &&
> > +           ((range->attr_filter & shared_private) != shared_private))
> > +               return false;
> > +
> 
> This path would also trigger for hole-punching, where we would want to
> zap the NPT entries. So we might need to adjust the logic for more than
> just shared vs. private to account for that.

No, because PUNCH_HOLE uses kvm_gmem_get_all_gfns_filter(), which does:

	if (gmem_in_place_conversion)
		return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;

i.e. won't get short-circuited.  Though I agree with the implication that this
is super fragile/subtle.


