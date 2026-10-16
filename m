Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C18CCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 15:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3DC96B0096; Fri, 16 Oct 2026 11:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16496B0098; Fri, 16 Oct 2026 11:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54266B0099; Fri, 16 Oct 2026 11:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A03046B0096
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:16:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EA321C3CAA
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:16:30 +0000 (UTC)
X-FDA: 85328840940.25.CD763EF
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6ADA2C0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:16:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FDCNVmSK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3yj_SagYKCO8jVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3yj_SagYKCO8jVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792163788;
	b=0iEDxBCLSXgzP0NOD89xPnhdEdnvlmtgACwsdWs8aSeAHm6uWYtWgD+OhRYJjmRuVyS3R+
	FB7F/T8IMThAIVV2oWEtwJhdvAo9vDjgG1E5cVqrdSI3beH/44xT+wZ0vM4ohXLqW+MXMe
	kKIbJVe44gkzTAW5FVbpKixhjhm1ERQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FDCNVmSK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3yj_SagYKCO8jVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3yj_SagYKCO8jVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792163788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkz9qwzhE2sRNisNmhNGoIxw2/sntbeBAljOSEpieUM=;
	b=fsBXz9HQTH0hSuQeKadsEWQ/6PNXfb8VDy9hn37GzJ2W0CcmP6QKczoVHFo89YAyCmvwzO
	eEOInzYU3/8OXwzFFZlNDQNKBigFpgFm1gBxCNYTBUnhPTIj+fhnQ0t3kkXHZx/INh9iez
	u5gAB33rwl8gMxfBte5RzKJdgsV1GiE=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3a470ead068so132502a91.3
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792163787; x=1792768587; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kkz9qwzhE2sRNisNmhNGoIxw2/sntbeBAljOSEpieUM=;
        b=FDCNVmSK5qRAAekuDJdGMplZxSGtGCC8OtGgFknBGQIhLPmpMoMgN2Gpd2AV22xcxg
         hgd5hE7wtKOe9n/hJ/mT3mmK8kqZh47sb2TI5UNgZ1+8gklE9i79aMSQEanL0Y3R6pOL
         CHZl1EWjO+exQN2AnB/FaJ9mtzgHaGZKpxtd7wIAl41ERd/zVcVrAhBalZokpa3n2Drr
         F4B/s2bh+8JH56WzNJXt2QLxM1iPqphaLM4XWlkhauj3IYhjikFoo/RfcRnaFGdHl6UH
         AAAckQZMq/Slp2A673de6cgO97LQzCNmY6VwPwk8hapsgIhqGGrfGiS4nln7KfS9gwvh
         h0AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792163787; x=1792768587;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kkz9qwzhE2sRNisNmhNGoIxw2/sntbeBAljOSEpieUM=;
        b=GCR4cJqUhaRRElkRtVLRwbxtQFg9dOtHPGUdW+89qnjwo1xysXYDRxfXcHE+azvuG5
         zhES6D2JmV20zMypbqfgCvc9pxRaRi1WGD5hcSRHBU3qljh4HtKwVgVH0QLTkGDmnl7K
         b8tMdsKoeFVf0aNCy1a+ET6ZGgu27J3E/igWTLZwo6mL4L138NDUgY11G1AsPfDcaTPG
         twzH/z2s3+ZJ/KzHCekwjeR4EL+5PRnANkf30KOHwrrY4VstEXCRvONY6tDqEImKfatE
         p7NWi3MmgDSOnlL0CtGSh6ur9t1GwDSWnHRLA2SgNPaOW4WR2PlTviThfpL58P1pmr6o
         9+3A==
X-Forwarded-Encrypted: i=1; AKwUvBxUz60T4uxkwW7dMMghWdn/+NmYS2n4l9f0fKJ0HGXyCvlo6rIPywoN9LtsbwFqVnOHsi+rEuureg==@kvack.org
X-Gm-Message-State: AFq9FYLyUd/EIw9k0vC5JZHf8qOGPzuSKyplenGMZh0KDqyYMyi+9i+I
	TZskRD6XLtxSl8OzAefL58jFhRe3q+6FBZkn7ssC7HOHoySDzuL4iMLecd4tH4w5yG1H00Cf4UN
	qMia0/Q==
X-Received: from pjyp8.prod.google.com ([2002:a17:90a:e708:b0:3a8:8e16:d986])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b90:b0:3a7:9045:fe29
 with SMTP id 98e67ed59e1d1-3acee2796e7mr161252a91.4.1792163786755; Fri, 16
 Oct 2026 08:16:26 -0700 (PDT)
Date: Fri, 16 Oct 2026 08:16:26 -0700
In-Reply-To: <20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
Mime-Version: 1.0
References: <asP5xK4axiUk7jun@pcnci.linuxbox.cz> <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
 <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local> <20261009090042.39ba9c06@pumpkin>
 <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz> <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
 <20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
 <20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local> <20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
 <20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
Message-ID: <atI_yuCc4BiweBQP@google.com>
Subject: Re: hunting memory corruption bug in 6.18.x
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>, 
	David Laight <david.laight.linux@gmail.com>, Rik van Riel <riel@surriel.com>, ljs@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@kernel.org, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>, luizcap@redhat.com, 
	pbonzini@redhat.com, Tal Zussman <tz2294@columbia.edu>, 
	Matt Fleming <matt@readmodwrite.com>
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: 1znbaomtdzow8n8t9qsoik7ke4s6anfy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6ADA2C0004
X-HE-Tag: 1792163788-527718
X-HE-Meta: U2FsdGVkX1/mNj+/5EGi3W+Ae6+k9PVMBtZnkJrYQHiS0RG7+x0K7KKFdiQLCXr1CLUUxvrrFTk7eZf4rGWqFrJNcK0W/65DUP9/UO1/hhQorI9PiN7BZHyov+DyJtnnZOgfULI2yLvlki9ngkKZpDOOPSABF5zBke0nT1CdVMLImauVTBlcFf0w93ZQFGSBVtV87qiAM61FvxSAevdYOxKDYwSi7HzcB+JZtMxWldsef0uDmD3J9sbpXhEfGrfqUH3SpOMTbIsG6TFSEqCy9DrLL6yIvCJZx+5mrG+hPo/3A6onejZvKUpAzF1thor9TsrDF+XQzC8vZNNYALBT74H4bYN5190VMPIYSCLPQ4KJJwjkfyfZsnLOo4C93jTEyeCvDZqUxO7G6rGRbz/HgDrLmBQwhiNsOrzcbvye6Cy6kJCwY/51JbtiCNVrdfDH/gKY+2+y+ZkhHZHz7er9cW4Oc2kXV9aRrjZ2XShHCy9uzQryV0PL6Le7X8O9ybjAolKFiHJvyQjYD7l8CS53It2VoXOWqm4jpEHqadicBiByAx5pesANL9LZQY8s/1PCbKVSp3scEMvvRwoZK7fcplsumdXRDcFqcQiCHfe4pT8Nv56rH6Up448CFt6Rt4fOX3tq5ryvasTDn08CJm8QSBce8jou91ggRdAEm6Ptpuhs+gn+HpUlMAUWq8+BHELuLubCGvWwut9ffDZhpyWVaNSFITQ27oKR40iRmohfhymW3ji5cuBEGLrZikrHq/KEV4nwoWo9JmrpoVakPMknm78Qf+85r7KPdO++JKodm9k3wT4i++2pP5jsZqvP9mfvfdVB1+DbHeeW9WbrXhEfbOJ3ut4r7kqZFUq/jnPJ33JiFwfZAyA0r8Yli6xDVWK4pKMvE8uwgCr6mnWWFk64KSfuGvLR+vR9TVr6GHrUiL5YDONL8z9X6XX2NObHnvXHSbSI7P7cBEeMPWX2fC4
 6+I9C1WW
 4Jtqu/U2cervgHXuHCqgZayONt6wR5EFWaSHn3EfZc0Qda0DIGyi4mhUf2LcTZD2P8Bv6eV/+uWzoBjlD5aZklXoWJPMV7sjjDyHbB0d/HV4AOK5FSm3P68Kk1IalHHpz/uOpqglTFLeS1tVlgwDelLsFmdN/HPqRpJrTGqoetei96uX6excwt+aP20U3UHkLCbomlk053hmOEjb3EBzuZ9r1ANG4JeL13CxIqmESwTMZci24Myi0DqDZk5tlUQwliJW6r+nGPnrwny24QxTk4N1bo5qaAdfez1qvU3dXXjyetArzvAuvVS+w2SinGRltJCJEKLsNfjfCvy9VU7ZxYSTMfr4mSkGpP7CPjOvqGwpwHaJN1bZUlclO8gqTQg4daZ3BOcTypkTYorI38PN2bPQu3IWNA6ogHUWwrZS7TByNACP4KDH95kUp/qBr1gf0B4zGfdPlYbukqcKThZkFhNurKXYYEhJKo+dVu31xaznuVGgtGEGhaUbWIQrfvVsRku62sRNvzXZBKPaQPCOg3FaNwQatJfjjPraDMSO6nTpEeJbG+wJnXi9MNsIfz4znuxJJ8dlXPIsQgPMO/JTVlWW1KviH12e2hYx/pRXNomKRNgcusX8xeO8Aq/LDMu2U6OO/hPTG5Rk58MAs489BPBbwd+vaq5Sh2vQp8Kqq8OqUjwY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026, Borislav Petkov wrote:
> On Thu, Oct 15, 2026 at 09:18:32PM -0700, Andrew Morton wrote:
> > The corruption patterns strongly resemble AMD VMCB state, particularly
> > FS/GS segment data appearing at the expected VMCB offsets in unrelated
> > host memory.
> 
> Aha, ok.
> 
> > This suggests that a VMSAVE operation may have written to
> > an incorrect physical address.  Ordinary KVM performs VMLOAD/VMSAVE
> > without nested virtualization, so Boris's objection doesn't eliminate
> > this possibility.  However, the relevant assembly is essentially
> > unchanged between 6.18.55 and 7.3-rc6, and I haven't identified a newer
> > commit that convincingly explains why the corruption apparently stopped
> > reproducing.  The earlier candidate 55780d8a1dcc remains poorly
> > motivated without evidence of nested virtualization.
> > 
> > Two investigations look worthwhile.  First, test 6.18.55 with both the
> > KVM TLB-flush fix (26505e1b5b54)
> 
> Pff, we've been looking at that one recently too, trying to figure out whether
> it was really necessary.
> 
> > and tlbi=ipi;
> 
> Yeah, we checked that, it ain't that.
> 
> > the existing results don't conclusively establish whether that combination
> > was tested.  Second, examine the vmcore to determine whether the corrupted
> > host pages contain complete FS/GS state matching a legitimate VMCB, rather
> > than merely a few matching values.  If they do, inspect the VMCB's
> > VMLOAD/VMSAVE interception and virtualization-enable bits.  That could
> > establish whether a hardware VMSAVE was allowed to write to an unintended
> > physical page.  The successful 7.3-rc6/rc7 testing is encouraging, but it
> > doesn't yet prove that all the reported corruption symptoms share one cause
> > or have been fixed.
> 
> Hmm. I guess looking at and around VMSAVE handling wouldn't hurt...

@Nikola, as very long long-shot, can you try running with the below?  I don't
expect it to help or flag anything, but this is eerily similar to a known bug[*]
where KVM writes to user memory in the wrong address space (wrong process) when
tearing down a VM after migrating the VM.  But that bug (well, bugs) only affects
Intel, and I don't see any similar patterns on the AMD side.

[*] https://lore.kernel.org/all/20261001202234.3794060-1-seanjc@google.com

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index df1d0cf769475..fc0ae4727793b 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -63,7 +63,7 @@ static void sgx_handle_emulation_failure(struct kvm_vcpu *vcpu, u64 addr,
 static int sgx_read_hva(struct kvm_vcpu *vcpu, unsigned long hva, void *data,
 			unsigned int size)
 {
-	if (__copy_from_user(data, (void __user *)hva, size)) {
+	if (kvm_copy_from_user(vcpu->kvm, data, (void __user *)hva, size)) {
 		sgx_handle_emulation_failure(vcpu, hva, size);
 		return -EFAULT;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f65081330c8a4..2dec1463b596c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3902,16 +3902,16 @@ static int init_rmode_tss(struct kvm *kvm, void __user *ua)
 	int i;
 
 	for (i = 0; i < 3; i++) {
-		if (__copy_to_user(ua + PAGE_SIZE * i, zero_page, PAGE_SIZE))
+		if (kvm_copy_to_user(kvm, ua + PAGE_SIZE * i, zero_page, PAGE_SIZE))
 			return -EFAULT;
 	}
 
 	data = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
-	if (__copy_to_user(ua + TSS_IOPB_BASE_OFFSET, &data, sizeof(u16)))
+	if (kvm_copy_to_user(kvm, ua + TSS_IOPB_BASE_OFFSET, &data, sizeof(u16)))
 		return -EFAULT;
 
 	data = ~0;
-	if (__copy_to_user(ua + RMODE_TSS_SIZE - 1, &data, sizeof(u8)))
+	if (kvm_copy_to_user(kvm, ua + RMODE_TSS_SIZE - 1, &data, sizeof(u8)))
 		return -EFAULT;
 
 	return 0;
@@ -3946,7 +3946,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
 	for (i = 0; i < (PAGE_SIZE / sizeof(tmp)); i++) {
 		tmp = (i << 22) + (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |
 			_PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_PSE);
-		if (__copy_to_user(uaddr + i * sizeof(tmp), &tmp, sizeof(tmp))) {
+		if (kvm_copy_to_user(kvm, uaddr + i * sizeof(tmp), &tmp, sizeof(tmp))) {
 			r = -EFAULT;
 			goto out;
 		}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3c4e2401de072..13f44961e6e7d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1341,13 +1341,35 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			      gpa_t gpa, unsigned long len);
 
+static __always_inline __must_check bool kvm_can_do_uaccess(struct kvm *kvm)
+{
+	return !WARN_ON_ONCE(current->mm != kvm->mm ||
+			     !refcount_read(&kvm->users_count));
+}
+
+#define BUILD_KVM_COPY_USER_WRAPPER(fn, to_user, from_user)				\
+static __always_inline __must_check unsigned long kvm_##fn(struct kvm *kvm,		\
+							   void to_user *to,		\
+							   const void from_user *from,	\
+							   unsigned long n)		\
+{											\
+	if (!kvm_can_do_uaccess(kvm))							\
+		return n;								\
+											\
+	return __##fn(to, from, n);							\
+}
+BUILD_KVM_COPY_USER_WRAPPER(copy_from_user, , __user)
+BUILD_KVM_COPY_USER_WRAPPER(copy_from_user_inatomic, , __user)
+BUILD_KVM_COPY_USER_WRAPPER(copy_to_user, __user, )
+BUILD_KVM_COPY_USER_WRAPPER(copy_to_user_inatomic, __user, )
+
 #define __kvm_get_guest(kvm, gfn, offset, v)				\
 ({									\
 	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
 	typeof(v) __user *__uaddr = (typeof(__uaddr))(__addr + offset);	\
 	int __ret = -EFAULT;						\
 									\
-	if (!kvm_is_error_hva(__addr))					\
+	if (!kvm_is_error_hva(__addr) && kvm_can_do_uaccess(kvm))	\
 		__ret = get_user(v, __uaddr);				\
 	__ret;								\
 })
@@ -1367,7 +1389,7 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	typeof(v) __user *__uaddr = (typeof(__uaddr))(__addr + offset);	\
 	int __ret = -EFAULT;						\
 									\
-	if (!kvm_is_error_hva(__addr))					\
+	if (!kvm_is_error_hva(__addr) && kvm_can_do_uaccess(kvm))	\
 		__ret = put_user(v, __uaddr);				\
 	if (!__ret)							\
 		mark_page_dirty(kvm, gfn);				\
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ba09b1dabc4b7..aa1564d41e7ff 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3207,8 +3207,8 @@ static int next_segment(unsigned long len, int offset)
 }
 
 /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
-static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
-				 void *data, int offset, int len)
+static int __kvm_read_guest_page(struct kvm *kvm, struct kvm_memory_slot *slot,
+				 gfn_t gfn, void *data, int offset, int len)
 {
 	int r;
 	unsigned long addr;
@@ -3219,7 +3219,7 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	r = __copy_from_user(data, (void __user *)addr + offset, len);
+	r = kvm_copy_from_user(kvm, data, (void __user *)addr + offset, len);
 	if (r)
 		return -EFAULT;
 	return 0;
@@ -3230,7 +3230,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_read_guest_page);
 
@@ -3239,7 +3239,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_read_guest_page);
 
@@ -3283,8 +3283,8 @@ int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa, void *data, unsigned l
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_read_guest);
 
-static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			           void *data, int offset, unsigned long len)
+static int __kvm_read_guest_atomic(struct kvm *kvm, struct kvm_memory_slot *slot,
+				   gfn_t gfn, void *data, int offset, unsigned long len)
 {
 	int r;
 	unsigned long addr;
@@ -3296,7 +3296,7 @@ static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	pagefault_disable();
-	r = __copy_from_user_inatomic(data, (void __user *)addr + offset, len);
+	r = kvm_copy_from_user_inatomic(kvm, data, (void __user *)addr + offset, len);
 	pagefault_enable();
 	if (r)
 		return -EFAULT;
@@ -3310,7 +3310,7 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	int offset = offset_in_page(gpa);
 
-	return __kvm_read_guest_atomic(slot, gfn, data, offset, len);
+	return __kvm_read_guest_atomic(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_read_guest_atomic);
 
@@ -3328,7 +3328,7 @@ static int __kvm_write_guest_page(struct kvm *kvm,
 	addr = gfn_to_hva_memslot(memslot, gfn);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	r = __copy_to_user((void __user *)addr + offset, data, len);
+	r = kvm_copy_to_user(kvm, (void __user *)addr + offset, data, len);
 	if (r)
 		return -EFAULT;
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
@@ -3466,7 +3466,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	if (unlikely(!ghc->memslot))
 		return kvm_write_guest(kvm, gpa, data, len);
 
-	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
+	r = kvm_copy_to_user(kvm, (void __user *)ghc->hva + offset, data, len);
 	if (r)
 		return -EFAULT;
 	mark_page_dirty_in_slot(kvm, ghc->memslot, gpa >> PAGE_SHIFT);
@@ -3504,7 +3504,7 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	if (unlikely(!ghc->memslot))
 		return kvm_read_guest(kvm, gpa, data, len);
 
-	r = __copy_from_user(data, (void __user *)ghc->hva + offset, len);
+	r = kvm_copy_from_user(kvm, data, (void __user *)ghc->hva + offset, len);
 	if (r)
 		return -EFAULT;


