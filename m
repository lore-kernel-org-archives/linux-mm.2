Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C68C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4356B00A2; Fri, 31 Jul 2026 13:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C306B00A3; Fri, 31 Jul 2026 13:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A436B00A5; Fri, 31 Jul 2026 13:44:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1686B00A2
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:44:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1681F16048A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:26:34 +0000 (UTC)
X-FDA: 85049599908.30.90B3793
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6DEDC1C000C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:26:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="JFeWexf/";
	spf=pass (imf20.hostedemail.com: domain of 3tsxsagYKCF0N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3tsxsagYKCF0N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785515192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICGNWuPesT/hzVX75ShCk7Kt8oQvWLyQi/M5mp0efms=;
	b=BdLeV7tINGxlLJA+HPzcUCyd5t5M6IV2WX3e1oH+lzVd7lGy46sxEq8meF/YJdGQCSDjT2
	tfSuTMUBd0XXlljsDvM6yRmppuecRq6HCbvifvibu8zj7I24R/iBqiKI1Xulw+oNkVc+JR
	Lx7pgRYxpKZCHiZk+u6IgfnUMaFW8CI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785515192;
	b=b9DZ8iXuDTfEirrBBCpmL2Sj5HxHx/GhiLsV7bvj1PKMGEuleyeBbhF9SYQn/2uui5IXFm
	l6esuKezjRQ20klTOwq9NmMG1QSxxeBRDyXgVhIJIhFZZFuAFTTQJkCsnkhn3vF/H1dbCf
	iHiihnBcoLnmEcl/1qM5oTwKiHf8orw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="JFeWexf/";
	spf=pass (imf20.hostedemail.com: domain of 3tsxsagYKCF0N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3tsxsagYKCF0N95IE7BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cea6a46766so19162375ad.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785515191; x=1786119991; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ICGNWuPesT/hzVX75ShCk7Kt8oQvWLyQi/M5mp0efms=;
        b=JFeWexf/OBsBvfuvSeW9RNKIUCV/CdVZMttEco9jbpyZdIdM3L1/QU7y6KpPftQoGM
         bFQKPuViLpmQNwsmYGsJFsZGeg7R6m7XuI2Tn3EfYBonUBBCpZtXPHfHshhAt2VJU01w
         NfQK6IZO6zzvOe1NblE8CidpwJlkfUoV64SCMokJsitpoK/iN5NeKl+9X9nDCxyBfB3k
         ViDszDaBFszJqdZlMIe6ET30HRdK4lf+BnZ3c+LNzwLVrmh73CXvXSWLzc1PcqLFDPWR
         Z6jjV3EzHqTxZEYvKCubH6QUktpL2Obljhh6gk67aWJVt1Sbv4WldIFF+4VLeXrUPZ/d
         Kk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785515191; x=1786119991;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ICGNWuPesT/hzVX75ShCk7Kt8oQvWLyQi/M5mp0efms=;
        b=oTbefxpYwXeKJIhSTakFFs26BxdqcsdK48u+UBrDvm5Mkwh9DSfekwHcr7zCgR1fVB
         VMFKxtZzGNVrO29o8ww0+RdACgVbI1k1Txm01jmgjUsGKI8jT3iQkzdXJQx8E0gSn2zX
         MakRDVP5rHoK67/XMe32KHdyy7FuZAOdtz1uybBU/b2VyDd7a03JXRPQAcfzqigJ4Lh0
         rb5HLwX2UY4z0amhB5yEccaCTKRb5h7WL76Ddr+fI9TAiUAip+Osrm61b5PJiTcpCykr
         edjeLW8NtcHIRslXPS+hIkWcDEuKwubqQqd7rGHP1QFxHg2/96KlvGeMtbfb6Q6WHNGq
         zRYQ==
X-Forwarded-Encrypted: i=1; AHgh+RrMS5OlvF6qYXr5TWHE/8JyvnbyCrB9sEvVYOqU+50LfkSuLPCxi6ZVPn5D1ZI9D3eQImPrNSMiHw==@kvack.org
X-Gm-Message-State: AOJu0YyKq20U4FFPYi4FBdM0RP8qi+bM1ZicSkTgD492VF/78IWE00gV
	NEnK4hpmyJCW3/dMfCu7hPd1bSTemu17sDdZzPVb90it8yY/Ozz+TuHUJVU28XR61FY7KOgTanb
	k1gvq1Q==
X-Received: from plhi11.prod.google.com ([2002:a17:903:2ecb:b0:2cc:5fd1:2d93])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3b8e:b0:2ce:b096:e517
 with SMTP id d9443c01a7336-2d0521cda4dmr6567475ad.5.1785515190881; Fri, 31
 Jul 2026 09:26:30 -0700 (PDT)
Date: Fri, 31 Jul 2026 09:26:30 -0700
In-Reply-To: <dd4201f2-3660-46ad-958f-c70feb1ab1c3@intel.com>
Mime-Version: 1.0
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-7-35f9aec2aed2@google.com>
 <60d19013-d6d7-4eec-827a-2622e22cec98@intel.com> <CAEvNRgF0SxmoMtqq69tUih54A9K7j_wcMFRrq=r9w6TnAGAUQQ@mail.gmail.com>
 <dd4201f2-3660-46ad-958f-c70feb1ab1c3@intel.com>
Message-ID: <amzMtg4K6qEEsudx@google.com>
Subject: Re: [PATCH v9 07/41] KVM: guest_memfd: Wire up core private/shared
 attribute interfaces
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 6DEDC1C000C
X-Stat-Signature: k1dshgxh9n37y3iymtmj3maxs99mxpwg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785515192-456271
X-HE-Meta: U2FsdGVkX180+qtMY8N53UZNfanVE32x/GD56EMmSEHhLJC8F5zTm/ZBji9g2I32Yk1XnP/Z4jeG4bEXoFpr0VlloroKnPEMSGVmPOUqsVxvjGrzeCNz2CgjuJikANar+GNntTjE89QujelpJ4WDSo6yYTE3JdihKqCLNqLYPFf+9YUzF6eDqredHnntjU1M+jzUf6+TLbLNXNfBjlIcai8Q5BvXESnGKIlPICh79aD0ZBpW7CvbsYwwJiKaADqRFo5YZONF+WOv2PdcCr0yM9W2Rjj6kPOkEGWZiwfsfkcbU0xiuRc5h4sDtsxQDcommdgrKN9Zs3JwojXfAinePywVCDeXkFkF4emRUlJMoVWpWxFTu+fFSwfnLWO1T1B2PnTNIdN0MzkSx4MzydiLN4hJfYksaUO5c//5dXU81IclgVdjj4mNDycCeauhadrFOal6vOLgrzhde5ksInC5W+xZodOw8iPcUU3rkPPehFlUYJZG5c/qrVe1rKrbSeg0QR0YZ44aFY7bwTz8a3UGGzvuFXf2ORYVBBolu4A9tNyPWXRQ0+Pk3cGBjL1rxNMuvRH//GXhnXUnlCyxLIJ8/SSBFzIvuK2P78CdSVeY9TyTEkZJqIxF5/pZ6ir6ecwzOBY8XNtOOfUguDQlMJ9zMzL4dSMa6cp9x68BP0b2NNJR99zDcQjjPwV6CcxzQ2lC7RNpyOUdMo+vc5TQgn/1HeY+8F+Al0IYGcC7tozQKH4CXs/EvAwcgyonVWmXeQMDSlNfr5BD3sC2uGrEWt2Su1ezcAhRspOFWuFKPJDY+kq76t1bZRHq62igT94HJVOYiWmsR6avqJEg2YKV3N7nrkrbudA9PKG6n3O/wIKTbkhXlO4oZUCgEERVtPBC8i+cmjG6P8DrVfr6H+VIltaZIUz5bpPLrcwX6mncCqvgo5csW4x3pJUQ6K9HWua+fp4JEtFsIoHA7e9cmjPAZZw
 Btx8LO5v
 aTP+NQUTo9pKEc6CHzfIKJWzTxSlpJnvAOHqAGWWMVEniXO/S7jByH6Ytn/LIlbzJZnhYlUVZaNGsOXZMzZx9VmuHnt17cQVokzIag+OKgpvlCdkzK9LVKma1RzNB8kAgmGnyCYudsWwXzZDdT1NjOX50/sD8dF3wmHcFXzVvA67JfQEv+FTEIT1mDdmU2kVrq8cvIhl08JTjpdD8JDBvupoNwR2/4EkyVg1H8rqSmLd90XAfBkzckTvDdFpImstxs6juqnGtbH6fbF4MuQEyGbfq0kCzbIzqsYPzxo6XZ6HlPAfuhMFycbt5HNo3j7A9XjPXLo/i15NhSV1211wxqIIe8QDXSXZI75ulcHzOEG4SbWMPrufP8RyMoe48/4dsSfuATCjrqhfbj2+hyYgB+W1NPGvA8+uPa0VFaqfibkezLMHynGzHziOFSxJFCVa1DHTcRCcLHWl39tIZl2Yel1he/yoDWpvS3PIZake/fgFk2zwq4BqbpYc6Bk/PYQMSLwgH8/QRtkr5GYHPEHy/OJzsEOAR8s66nefa/smdkbU+gMqrghMngb7SHuYzq46p8JKNU8jMHaWgl/Ywkhp0KeHeX/TDX9/mdOjUIFa3ypHFq1c3wkEn0lzJ85AnnQjwv/nffkvnWA+jn5qSIXZVvmc4TAYFkBciOIE0Vs6Yz8SNrUuhbJUy0p82AAOcms8uNZ0B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026, Xiaoyao Li wrote:
> On 7/31/2026 4:42 AM, Ackerley Tng wrote:
> > Xiaoyao Li <xiaoyao.li@intel.com> writes:
> > 
> > > On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
> > > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > > index 33c9830190e2e..89cf922232920 100644
> > > > --- a/virt/kvm/guest_memfd.c
> > > > +++ b/virt/kvm/guest_memfd.c
> > > > @@ -893,6 +893,27 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > >    EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
> > > > 
> > > >    #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> > > > +static bool kvm_range_is_private(struct file *file, pgoff_t index,
> > > > +				 size_t nr_pages, struct kvm *kvm, gfn_t gfn)
> > > > +{
> > > > +	struct inode *inode = file_inode(file);
> > > > +	pgoff_t last = index + nr_pages - 1;
> > > > +	struct maple_tree *mt;
> > > > +	void *entry;
> > > > +
> > > > +	if (!gmem_in_place_conversion)
> > > > +		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
> > > > +							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
> > > > +							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
> > > > +
> > > > +	mt = &GMEM_I(inode)->attributes;
> > > > +	mt_for_each(mt, entry, index, last) {
> > > > +		if (kvm_gmem_interpret_entry(inode, entry) !=
> > > > +		    KVM_MEMORY_ATTRIBUTE_PRIVATE)
> > > > +			return false;
> > > > +	}
> > > > +	return true;
> > > > +}
> > > > 
> > > >    static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > >    				struct file *file, gfn_t gfn, struct page *src_page,
> > > > @@ -913,9 +934,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > > 
> > > >    	folio_unlock(folio);
> > > > 
> > > > -	if (!kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + 1,
> > > > -						KVM_MEMORY_ATTRIBUTE_PRIVATE,
> > > > -						KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> > > > +	if (!kvm_range_is_private(file, index, 1, kvm, gfn)) {
> > > 
> > > It's checking if a single gfn is private.
> > > 
> > 
> > But with huge page support we'd need to check a range of gfns... I guess
> > there's the argument of not keeping complexity for the future, but in
> > this case it's undoing functionality for this series and probably adding
> > it back later.
> 
> let's leave the work for huge page support in the future.

It's not just for hugepage support, the core functionality is used in this series
by __kvm_gmem_set_attributes() in:

  KVM: guest_memfd: Return early if range already has requested attributes

> > > We can just use kvm_mem_is_private()? And it seems can be a separate patch.
> > > 
> > 
> > Do you mean that this refactoring could be a separate patch? I could
> > refactor out kvm_range_is_private() in a separate patch, then put in the
> > mt_for_each() check in this patch together as part of all the rest of
> > the "wiring".
> > 
> > I considered that but it seemed like the refactoring was too small to
> > separate out into another patch when the mt_for_each() part is going to
> > be in this patch anyway.
> > 
> > Or, I could add an earlier patch to first replace the call to
> > kvm_range_has_vm_memory_attributes() with a call to check just 1 gfn,
> > then this wiring patch would be simpler.
> > 
> 
> This is what I meant. An earlier patch to just replace
> kvm_range_has_vm_memory_attributes() with kvm_mem_is_private(). Then we can
> drop this 'big' diff in this patch.
> 
> If kvm_range_is_private() is useful/required by huge page support, then let
> the huge page series to introduce it. It has nothing to do with the in-place
> conversion series.

If it weren't for the fact that the range-based search is used later in this
series, I would 100% agree with Xiaoyao.  But since the core logic is used and
needed elsewhere, and because kvm_range_has_vm_memory_attributes() takes a range,
my vote is to provide the plumbing now, even though a small portion of it isn't
strictly necessary.

