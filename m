Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E07CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0875C6B00B1; Wed,  1 Jul 2026 12:55:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037CE6B00B5; Wed,  1 Jul 2026 12:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E910A6B00B7; Wed,  1 Jul 2026 12:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A85096B00B1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:55:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 057938D105
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:55:04 +0000 (UTC)
X-FDA: 84940807728.08.F53A2F0
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4FD7C160006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:55:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ooqJPIuF;
	spf=pass (imf08.hostedemail.com: domain of 3ZEZFagYKCF8PB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3ZEZFagYKCF8PB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782924902;
	b=C4NtUoB27cHld3GY7XIRnkl+Cfqk2gGGl3CAi6fZumMnQgC/E+I1U5/17MKBniHHBHNNff
	Gvc6h65wJYw5oWPGHsb1rWRPkj8xLTrOUWD7oEvse1QFt81S1povkrsCsDh4dxRSWhYWSs
	bqH9byVc+6RgbYZdjo6k9PDXAn03joI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782924902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbVYdv7/FNdOOvrw/bcfsmdKoQ369BNbAkiBiKDICVU=;
	b=p2MzU2iSL9SFdvmQuCDvYozqNs7FpPtbEbs0VMq1VT+N9JJyEcNbNHR2GxqdjdVS6t6Kmf
	wAz1Mf90XPwYzqthYZetZ4qzehMNINSwoar8xcRXzsa4iYi84vj5BgjvGhVjZHvYsBFRVq
	ERxdqTTCCi0hv2XqS7nxnkVI5S/mjVo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ooqJPIuF;
	spf=pass (imf08.hostedemail.com: domain of 3ZEZFagYKCF8PB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3ZEZFagYKCF8PB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c890bac374eso909579a12.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 09:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782924901; x=1783529701; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lbVYdv7/FNdOOvrw/bcfsmdKoQ369BNbAkiBiKDICVU=;
        b=ooqJPIuFOFCQ2qGpBJ6y0bBgwPiH3Xlq0WmtNul+/Sq+PxhsEJeK4PJVbkIrU+t2Bs
         ymVbFTWIx5H8udgbCJxepIf84kb5X2Je8AfyWyvEC2K5RIGhqOp7uI29ezL+UxE6NoWh
         0Q5+PtV+nd4OEZF/foGajguAY2DICoHx0w3i96zJM5rvXjo5H2EZmlmMeoZCAPVK+XVh
         g13evJkbyO4sPGvEBpve0LwIshzGaKYblhPejw0MgaMC50BLnU1/8hg9tdqWYKr5L+YY
         Iy+qR1D6YN7nZlRUtIr2YXKVoEBXFoXBXD0dZ1XOwxSf/JqPAO5IZaS7t83jJsGSUXmJ
         u7lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782924901; x=1783529701;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lbVYdv7/FNdOOvrw/bcfsmdKoQ369BNbAkiBiKDICVU=;
        b=RuTeYTaWKASx/uLcR3q1Z9w7zI0xRa4KH1OV4PKr4U0Urn3UFODdH9txgQVUNNNDFL
         A6aujs1m8BcBqHzNMAVysEP/USdGw2qmBdTAgL75YxRl1fKPStnXtKSIH8eUyV1mRfHi
         EetkCooSZwBTICiFPbopdh2DwWT/BFRBW8uncJ46UWPBwe8KeDUQJnYnYtqEwl9YssbH
         PzHH+btCz/vOrdn49/jr05Cp0RE7WD6P4AdhuC/SLNJheHkxo8zMG50ZU3Pqe3oYF7Hm
         MNNvK+SPCZ492yepW2DG6IWlYOQd5Ck0Vd1npZwrPDaCV9AmQLM9O/BnBpd+ehyknpOP
         BUPw==
X-Forwarded-Encrypted: i=1; AFNElJ+hGvM/OMnz6Ue6W/o5MfoIJBKQmtI06ydw5M6YGfJRvNSU9dtUUyHwo1+9PkymE6Lqxk8Ukvosig==@kvack.org
X-Gm-Message-State: AOJu0Yz3NTuz3RSxsg6rN2Lcg+nD9e+irPqFkewOWuyLP/hNkN+KnDLC
	2dJ1zpSgRv6+OMTR9gfvU5O2q6PesbN7nbGcBE8rQ9dDTqj45q4XBtBtxqAvs/Z9yj5dbRa6vax
	UHcRDaw==
X-Received: from pgja21.prod.google.com ([2002:a63:cd55:0:b0:c82:7761:9936])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a49:b0:3b3:bf95:f7e3
 with SMTP id adf61e73a8af0-3bfed477967mr2785820637.43.1782924900819; Wed, 01
 Jul 2026 09:55:00 -0700 (PDT)
Date: Wed, 1 Jul 2026 09:55:00 -0700
In-Reply-To: <739e6834-40b3-405b-ada4-d31c38d8416a@intel.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-6-9d2959357853@google.com> <739e6834-40b3-405b-ada4-d31c38d8416a@intel.com>
Message-ID: <akVGZOeR1ytfkamK@google.com>
Subject: Re: [PATCH v8 06/46] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: r7o93omqur1whrjh19j5cudidpaerzq4
X-Rspamd-Queue-Id: 4FD7C160006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782924902-645111
X-HE-Meta: U2FsdGVkX1/AtM8CQ2cESfXKCICk/5rk0zaSuHj5H5Y3X0h4pbH7//Wx0zHSOAg7GehgIlwu95np6GKlkXOgHu5beQxUwsG7nTYTHBdXdb7nsmfKDu0ax+zpzldTqSNQ7TfROHOptWmZzBBCwxj3uevUzZfXkWDme7a2Ftv9BdiY7WGdmE3A4v9ZtjxehNcQmPw685/1M7SGZpEeJaShgYll9mwt2rsnaDgks2FuHwiULw6LBz2y0sMOCFIVdSOKkAWM64lw2JU6+D/VgnDbPWxBKxfrZ0hlTZsTA8gII0GyKuSwmgJO/D8xJVCgJhr1a10LkZtr2AX6S2re9GoYj2EKKgwJIyZqEop7SM+S4tEDJHMPk0AJousjF3ODrewLn68Dp81ieneRwZaLCEWmickRWteNJJ6i1Yzo+q47TulHU6ZiOCPVHrgwsQy1ZGEZeh3ddRz85ByY0IWmJpCMr5KXBOpIIYxzQr5IMACNxo122vQSCe4U8TOt3kQpWKEbEQ0ip0lWKNdCptF6Eec21YqArrtrZWSJNMrpWz0xPk0mIFG+edLXDkWLF7iZb1VlGUDuywY2Vr7BiTZUGdxIJBg5ktmZXGRUMyVUIYzWkEGWPlggl61Oj3hqNZP8l8QY12RXYBZ5p0hDbkJZFCjAg/aOHV5ie98CT0MJ0LbUg/XdeMi0/pwTN0ITp0Jwo/F//DmY1bw3aKGFcyyj3mSrem/pJe5yxSbXRnxJGPH54yx5lhoIXbaDuC1EyABvNcUdK+LWyCVP8cl/V2Ft8aEg8ibHWHa9x3OH6K8kXR/YcV34yDrKSqZQFmbmTmG4J1gF58OC367Zaaz57RDscMLMxRqxX1ExT4pd7JtWmPVGyNBf7jc+ios7GgxRJkVitVlRQSrjLt59IeWPuMV0xRiPv5+0119H+6hDzFb1fUT9l+1nb27PE5aZiP5KVJexBwxCQh5sFxqlJ5B7PA09hbj
 /CIqkArN
 f4sU42MLId0l4oelmjurx83dAD09BuNLAUJsMnFbAf49Bg3GqyiwewnfGc84DYeFZeESxoQXTKNogubJAXA6BDPX/bcU0hvq5m0A5B+06ojBRzirJe9Mb0r69VWIkDEqIqg2SVlIInuua/ON2h5IX9XjkoCdSkxfxanFofYhn5UTSTmIkGjRd9oXY6rCyNIPG2WkUYB+lTHXG+xQ1KkfhaxszoLwjHXLrODuh4lQrtscqCiF469G31ZLs7sF38YNj689mtyleiyHjCSyFFMDIyOxJPxztq3a47McbYzbGGxrJbeI3NKPA15FNVAqBCPHTgnnbWegSDVZDgMSP6mQ4ruN/WCHht+KmA2RUmT6uAcCPUoA2owVDC5qST540gxQyFu4ag7HuGtlIUTRQvsG3V02N6Ql1MG0OoIRnAk73NItFOfKGgMzSp4SP2d0ddDaZ6eJcPAOMEYVeJN1qV5ocXty34z77LSNl6MqbvECFFzOHzL2n7EJnX+A+PF8dAZeT3lFqVSi7Qprkae3bXU15S//GQ8U2PanUQwD35bWzIbcoyKrnt4opOgmQkk1vOpKoNnEvq0Eh/hSt+RIYGQCReqfe4M8a/kxgNdt2QhmkKHSGCTxUTFmUTS1dbgzSIETiyJBblLuLUvvTKmQyCFapClP61UCmRFR6E/ioxv8zPV85kjg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026, Xiaoyao Li wrote:
> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> > 
> > Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
> > on kvm_arch_has_private_mem being #defined in anticipation of decoupling
> > kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> 
> Well, after this series, kvm_supported_mem_attributes() is renamed to
> kvm_supported_vm_mem_attributes(), and it's still under
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> 
> > guest_memfd support for memory attributes will be unconditional to avoid
> > yet more macros (all architectures that support guest_memfd are expected to
> > use per-gmem attributes at some point), at which point enumerating support
> > KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
> > supported _somewhere_ would result in KVM over-reporting support on arm64.
> 
> I don't understand it. This patch only changes the behavior of
> kvm_supported_mem_attributes(), the usage of which is guarded by
> CONFIG_KVM_VM_MEMORY_ATTRIBUTESq. This is config is only visible to x86 due
> to patch 03. How does it affect arm64?

Hrm, yeah, this is messed up.  Ahh, I think Ackerley shuffled things around and
"broke" stuff in the process.  In v7[1] and earlier, the diff was this:

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 091f201251159..68142bc962953 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifndef kvm_arch_has_private_mem
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 306153abbafa5..abb9cfa3eb04d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2421,8 +2421,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
+#ifdef kvm_arch_has_private_mem
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+#endif
 
 	return 0;
 }

which makes a *lot* more sense given the changelog (and IMO for the ordering in
general).  In v8 here, Ackerley combined part of a change[2] (that I provided
off-list) with part of this commit, to create patch 4, "KVM: Decouple
kvm_has_arch_private_mem from CONFIG_KVM_VM_MEMORY_ATTRIBUTESthe".

Ackerley, the cover letter says:

  + Reshuffled the earlier commits that deal with preparing KVM to stop
    seeing VM memory attributes as the only source of attributes.

but there's no explanation for *why* the reshuffling was done.  Reorganizing
code like this at v8 of a series this size is a big "no-no" unless there's a
*really* good reason to do so.  In addition to the resulting confusion, changes
like this invalidate Fuad's Reviewed-by.  And since it's obviously quite difficult
to tease out exactly what changed, it's not realistic to re-review things without
doing a deep audit of the series, which no one wants to do for a series that is/was
so close to being fully ready.  And without such an audit, I can't accept the
patches, because I can't trust that what I am accepting is what I and others have
reviewed.

So, except where there is/was a *need* to shuffle things around relative to v7,
I think we should revert back to the v7 ordering for v9.  And where there is a
need to rework things, each and every one of those needs to be explicitly
documented, because "Reshuffled the earlier commits" is grossly insufficient.

[1] https://lore.kernel.org/all/20260522-gmem-inplace-conversion-v7-3-2f0fae496530@google.com
[2] https://github.com/sean-jc/linux/commit/8a475b1bcf89f1cf776ed9ce7d6bb587aab0d421

