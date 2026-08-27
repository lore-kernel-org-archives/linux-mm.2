Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89A87C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3FA6B0095; Thu, 27 Aug 2026 15:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875556B0096; Thu, 27 Aug 2026 15:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763DC6B0098; Thu, 27 Aug 2026 15:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6C26B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:08:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2B78A0180
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:08:09 +0000 (UTC)
X-FDA: 85147984698.14.5BCB08B
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id 18D1940008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:08:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N3iWbz4S;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3FouQagYKCMk7tp2yrv33v0t.r310x29C-11zAprz.36v@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3FouQagYKCMk7tp2yrv33v0t.r310x29C-11zAprz.36v@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787857688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JWGZwnfyNQRYCnM1UqJIynPGxtHIQDoEVfaq/bKW7II=;
	b=19FneKh4Z5oFrCp6SoxCUlYNpkRTAJxUMQ9BZr9Nm0gA9X/cY2XLTz+KS/TaAWWlpl4jxe
	+FwU9BMel6UBzkm4IW1GRuu0DRVNB++IFF0BNEtcCmXayM9ZszhvW9cc/0MdKZyiQ09yu+
	NjwKnvlorxToLw3aIxBF0KoR/9odkU4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787857688;
	b=JfaxPj28Yty2tho7BiuUYlBqml2abh+/uL2+llVyDVk5iiAw4nO2Ba3c89BY6ev6po3yi6
	bTWJC83J8lczUOxR6XDdH/FeDdGRR2Xbfu6Y8uwAfatAkGQrYHORr3q9w4UVfK5iMCI02+
	m9xL+jFPmQW3MdAzuWk5D9d99bmq7OQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N3iWbz4S;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3FouQagYKCMk7tp2yrv33v0t.r310x29C-11zAprz.36v@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3FouQagYKCMk7tp2yrv33v0t.r310x29C-11zAprz.36v@flex--seanjc.bounces.google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cfa55c9430so1777685ad.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787857687; x=1788462487; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JWGZwnfyNQRYCnM1UqJIynPGxtHIQDoEVfaq/bKW7II=;
        b=N3iWbz4SEQ1urgxCqL1wlFVP+DyGbWM2fKd0pVlRo3rOVKLC+nzOWTnXyPYU6pHZFo
         +KB8LioGlY4uNzhg/gVQwA9ev0qFS8ROFbAW6JE9/uFNXDbuxT5hloa0sLLvoeePi1i5
         CSifmWxYJ6NwIhjuXEePz/dTuafvgwBLGkTv+FVtYdyvbeHGDMzi1r/y/U19CEjsrTXS
         /GN6N6+uh2IQA6o+yDLO7odjyE3pc+KTzg3jyetikIMLJEaEgc6ifN2bQwgUgBzHFaWf
         Al1K/AUR7g45l55e8ld0gmczBDzDMKwZ1+ASE00JyKcsBbvLGkyaeIO7kG0QE6w0EuZ4
         m0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787857687; x=1788462487;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JWGZwnfyNQRYCnM1UqJIynPGxtHIQDoEVfaq/bKW7II=;
        b=UDFLAYSBQEoJAtXtZbaF7w+e4mMO0sDo1cpCa4YSkdAkvyVeryLOH9nSoIE7tqbyLj
         A2nsP8KVKLCGPsk2NlFWkcChDJR1K4GvZiY7VM7k1lHlzk1k9OudNoSSrqH1iZTAVheb
         mBuJzDeAt2ggIHp04b5DOZyrI7lj5C3d5n9ukqS1duo95/xCZCUBAWS1bg9s5/FW7+jZ
         j7Wx/zS9sOfkL31oA+nj8FZArIpYHhehkwYhOds2I5OmAvjL50wXOloXBjJhLrR4Gabn
         ftz70oI45n/RBBc0T1qJwOv4/E4ip5thCXJNhbPUApaqxQszAX3foWFjGuvqQmqDW4W4
         40Nw==
X-Forwarded-Encrypted: i=1; AHgh+RqkNj4CdENY7X04+wmrhI7BukSaTERdYYz0TRuKnYevgUc9i/OVHU6+pGI30jI4Li4nBtccZmfTUQ==@kvack.org
X-Gm-Message-State: AFuF++nLH0UGY5VJkcM45XFjbyheSfys/s39KHxo535UvvJVji8osY1R
	eHNiNI697LypkS7Q/9Kh2k2vEFZB0ku/tlCer2dDjmSXAC1b8p/1cSts5eSiVBLAEIKBapyqjbS
	2C+k0yg==
X-Received: from plblq15.prod.google.com ([2002:a17:903:144f:b0:2d6:e58f:8e81])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:15cf:b0:2d7:1aeb:739
 with SMTP id d9443c01a7336-2d74e1295c2mr19606415ad.13.1787857686248; Thu, 27
 Aug 2026 12:08:06 -0700 (PDT)
Date: Thu, 27 Aug 2026 12:08:05 -0700
In-Reply-To: <a151b52d-0afb-4b32-a871-4da67210f416@intel.com>
Mime-Version: 1.0
References: <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com> <CAEvNRgGOyQHnF_b8dk8E0d7_=CcwXtYUdU3ko7Qbep+_O7UC0Q@mail.gmail.com>
 <aoZZMQ3Uc8yQWPNA@google.com> <7eba513d-cdae-4832-abac-038dcdd88517@intel.com>
 <meww2a2uf3yeevsfpicyrlg3hch2x4bsdqv2lsv3vfjxg4qzes@co5eogmhkxrk>
 <ao3lOu8-wpGTs2wd@google.com> <ba8d0441-b52f-4357-b2e7-1e352aa385a2@intel.com>
 <CAEvNRgFXJbV78ktsg=b4srFp1OFjtQWQGuNPjr_MmWD-wOvjgw@mail.gmail.com>
 <ao7vwx3nMqCjCHZU@google.com> <a151b52d-0afb-4b32-a871-4da67210f416@intel.com>
Message-ID: <apCLFSbj8sq2biJp@google.com>
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Michael Roth <michael.roth@amd.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, aneesh.kumar@kernel.org, liam@infradead.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 18D1940008
X-Stat-Signature: q9xdgo5qem4i65twezitp5idmwd9d4tj
X-Rspam-User: 
X-HE-Tag: 1787857687-136461
X-HE-Meta: U2FsdGVkX1+Wk1RgQ6bdViQ47QOjvcJFFBNDabOa9vs/e+WsJ2W+Cpjq5hPePykbMb9W6qBxAxLoMda71wbQ8SvpozBsFCM1vDOk9rw5A6cDQZ2oj6o5gtjE199+XwJxWLqzhSxJaNAwJ+RSpk3L9JLWRM7nQGHiOPi7URgb4/ITbl4ivit3NIxfwnk5kwc1KsUkGdG4ztHriXBgawGDEjDdklOnkH2vFpXhIIOxDBYxXqbyLvC4zw+weZLnmA7VNWkAACSP84Di3OiAq8lIOsMJAVGaweRQY9hHxFlZcSJEuk2AeEOHBlqeNx4nlThfAHnTvkdcerdXx/smKWNt/MlQgOQQN1vzmHqErqGHanOR5aEJEzmh+fupTh5JfPijeXR2k0el51dZgS6iVLrPHgbKOGv+2FUGrueDzqGNHDn0OsE15nUC2M8nDDuytb8HKRjdZ6NmRHWaxo5NLwgabiacGAPF45j3/NOhbmvAdyoa88wZBwa7Hd+UZwFoMm/Z/IxDyb+s2wU4hPmXwswMoZrWoiA9k0xydtNBTM2LpcoCntzf2VGdCa8LJF08gKezil37uUyYANE0CLyXj/njtkntPWCGfOa6cPN7kChPOeg+r1m+N8oM2+ZiQH663izC3Ziy08spBfdlSdQx6fPmcgNjeo0zw+MZRkjZtQPWIFkshNjDfVRT3wwe1CC76H/UbfGhCq2i9nQI2+CHxTAopUQoh2I8JYhAMEswuyEF+MrRluvoLKW0auZPNyTpLJUT3V4tXsW+zRyxCwNsbd9Yert8bwuJ0sJYEZYJZwnBNVv0mkskbcJU3FK07ZPJt5GNH4+ssIAT6urpBlIHogDXswxK+SGPLfTtg96nf5OgsFROEfxj8IE4Lwyq/TMRhadMX0q+orW6sp+sQiWvn4+LzjWFOAspdYnHwCj9ePRq1UIffakVsztoQvxg/kBPjanJrNmjw3xBGlLxZX9U+ek
 9sYTCkk5
 c5y0EXKMkfpOm2uDHgVrWZm6SK/3hHmcqi6ZiwxFc3LZWsMUxNo9awyJPMaMUvKcSIb8OvGg1SMD9iqM3BdsfpU5ryWda/b0ReCUaO5U4QwXV1Cq9Jc3to06tO17XwxzzUJXyhj4dWnafoO4MTIyQ2nfRZ9rtF7rnAibewwNnBvcH5pZUq//jrK5z3CvlCDv9k+BzJrpSpVIe1/87Fzu6LkH1Kl/q2fT8PmVgH2CW9ybbTzUSzE9j3UT/Jen86R5LDMZb2xDoae63CJBJFeWrDLW7WVPP+DCkQL89Gte3eqDEc0EPx0ACIKGS7yFlUsNrTZgOg/wwG51h8pjcrFajO5TXpQwnikxSS3SRFFfPPU+TpKhYXlDHzRlo+dlnzY0VMD+NxqKSVVtthP2WBVNrPKE/f9U6LdiauFXgSip0hqQhm6oE3+IXEBja7/UgKf5tME7g746xonpghxgmpY89oLLhgy4UJo27BHO49L2hX44mxC5L73s+lOzx+nVPpdJRJPVKHunXOEF36FXyMzsXXQ0gTI6Fj3RoiCeeJNhGgKcFCdEwsRoh2cq1GtQqrg2SYzyum28g6a00Iki4dgxKiQEE/yYgPkyVZfFWwqoWJRcTA9ZS2pFHWub2DQEP/myLVVcpwcqwu2w0PKhejjzTpT7pgqAR8HHLgx5WDkXwI4QITaQ+f+EGt5H63Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026, Xiaoyao Li wrote:
> On 8/26/2026 9:53 PM, Sean Christopherson wrote:
> <snip>
> > > Is this just a case of user error? That with gmem_in_place_conversion,
> > > userspace should not use userspace_addr from something other than the
> > > gmem for the same memslot?
> > 
> > Yes.  It's not just invalidations that will go sideways,
> 
> > KVM accesses to guest
> > memory won't hit the same physical page as actual guest accesses.
> 
> Side topic.
> 
> If KVM enforces KVM_MEMSLOT_GMEM_ONLY when gmem_in_place_conversion is true
> like below proposal, should we update KVM's guest memory accessors to access
> gmem directly?

No, because routing KVM accesses through uaccess means we just have to ensure
PRIVATE memory isn't mapped into userspace, which we already have to do anyways.

Now, that doesn't preclude future work from optimizing certain flows to avoid
GUP, or to harden KVM in other ways.  But as a first step, bypassing uaccess is
actively dangerous.

> If still use the existing code of accessing userspace_addr of the memslot, I
> think KVM needs to document clearly that when
> KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES is enumerated, if configuring the
> guest_memfd for a memslot, the userspace_addr passed in needs to be the
> mmaped address of the guest_memfd.

Ya.

> > Huh.  But that isn't strictly guaranteed, because userspace could bind to a
> > memslot that isn't configured with GUEST_MEMFD_FLAG_MMAP, in which case SHARED
> > faults will go through the VMA, not kvm_mmu_faultin_pfn_gmem().  It's a bit early
> > in the morning, but off the top of my head, I can't think of any reason we need
> > to support such a setup.  If userspace really, really wants to use a separate
> > mapping, they could DELETE+CREATE an equivalent memslot without the guest_memfd
> > file descriptor.
> > 
> > So I think we should do this?
> > 
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 9c2d52bdf25e..86f53e53a136 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -1013,7 +1013,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> >   	 */
> >   	WRITE_ONCE(slot->gmem.file, file);
> >   	slot->gmem.pgoff = start;
> > -	if (kvm_gmem_supports_mmap(inode))
> > +	if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
> >   		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
> 
> I like this idea. It makes gmem_in_place_conversion a step closer to what
> its name implies, though in-place conversion is not truly 100%
> guaranteed[*].
> 
> [*] https://lore.kernel.org/all/akUbz_kJvYulaboo@google.com

