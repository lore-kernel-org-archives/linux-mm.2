Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D34EC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509E66B00AA; Wed, 26 Aug 2026 05:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BA706B00AB; Wed, 26 Aug 2026 05:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3827B6B00AC; Wed, 26 Aug 2026 05:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A0456B00AA
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 852D81402EE
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:36 +0000 (UTC)
X-FDA: 85142870232.18.A2FC36E
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf09.hostedemail.com (Postfix) with ESMTP id A820B140004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J+eYBIa5;
	spf=pass (imf09.hostedemail.com: domain of 3aa-OagsKCF468GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3aa-OagsKCF468GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63KksNRMPLdKIK2ffHPVavSJlAIn7eLDeJF6HOKSRZE=;
	b=t3TgWAyB0005/tvYQpB43i16qeDtFGL5WL2FjPmqyBu/4lFFtne5KNVWfEKQZX70Wfpjmq
	LM54Rwja8X3trTnB/eGLBgttObBPT/f3uL+sI0JHGD6I4EUgt3aLEIPZ6rH+yDyLkhFi+x
	tCELjwfQRuEVGR2j65TqL1aLGWvJjOQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735914;
	b=XjLDozsrXjGsQBQXz4/vQpFb3J7fdpeWX3PRWxg+6M5+SVPh3HUQifigXB8vjXWqnk1M91
	14qqEkckwPuhQC51eg1Yzmi1TWFiDyxBeqZPxWdsrJcmz7ixO1hF70MWW3vBMMfgmc8VOb
	UawpmaKVyFgQsrk0v0Xr0nImRBuCdQM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J+eYBIa5;
	spf=pass (imf09.hostedemail.com: domain of 3aa-OagsKCF468GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3aa-OagsKCF468GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbb92868263so591806a12.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735913; x=1788340713; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=63KksNRMPLdKIK2ffHPVavSJlAIn7eLDeJF6HOKSRZE=;
        b=J+eYBIa5yIMv29S3MYdE7IjGzney4G3+LmDxDdLtsBuq5iDQJQSgJUO1nYvgrImeZH
         xxdbjv6vnMJkXHDvNHDXZs6ntGvIsunHZCGJ3jtXEGMX8/N9oM7L43sPOgdUac583kG/
         Q6NlQHA/cMdaPuFMqqHoJBHj5cC7oAAC578fy9ap7CoEPi2Yg6ZiCLXPM2DRWiEiJf6n
         hw/MW6808D+xEgIuKfoRcAhwlQESo7H+O/asqWbnKUgenAdXaxLkG8Fr5k1KDIQfh8MD
         wY0egPYv0V6PvVEGuJok/EA5dMqt5A3vDHTRDFaOt7gXDaioQLyWOqonP4KCz9W/bjdP
         6Gog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735913; x=1788340713;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=63KksNRMPLdKIK2ffHPVavSJlAIn7eLDeJF6HOKSRZE=;
        b=rRa9W0xcYN1xa2rjF6N3djn3KzYj1BbgKWOK5zbFSWdNX9D6wn0xm2LNpihq/IeIhl
         yxtnwZ7c+qW3fbzjuDOC1Uw/p+tgXkr0lBuFRIr1nX4knymCwX0kP61WzLd2QyOag3Lf
         Fv9lT8mc9CeBgCpA8jdmxFwsQp7Y+E+Vlb7eGkqXzX2kVf45pTTtVLgfSfkwaQ319sVB
         OyEHSVeOVCt9+QcyrhcvNpcJ7jO6Yf29DkaMuGB9/QBZx+9XZRGPHkO/qOSWnFyKzWXf
         CmTy6F8O4tJ2WPDBuJDiK8mTBWAfj+mMrlcG/QhPDvsuCOElrBnfotZis+N2x2tOTm/H
         7Mow==
X-Forwarded-Encrypted: i=1; AHgh+RrTkCLIuwrPHc+ScmubbnHeFChQqvLugTWZDetSUYU/U4e8nhyxZiJDH02H2CQEe+z8X/uiWFlTMQ==@kvack.org
X-Gm-Message-State: AFuF++n6x5eC5PnO9o5Hus95JTDFpw4ebr9XfBjOBbmH80jPvObvtzQc
	f8VdMqKuhmhUPnCFoY6HwUN2yJGKJLAaYSaiz9PX/X2/nT2QPS+SG94MmHPtFBqhj1qermGqL1O
	KY8dVuPZP62ioTWHCpJCulXqTfQ==
X-Received: from pgcz13.prod.google.com ([2002:a63:7e0d:0:b0:c86:2164:967d])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:8986:b0:3d0:868d:8ccb with SMTP id adf61e73a8af0-3d0868d974amr686524637.13.1787735913113;
 Wed, 26 Aug 2026 02:18:33 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:13 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=6544;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=cfKDOJ7DvEwyC5tuG3+q7zNHiwlxy7Kdncb8W2kXAdk=; b=MMZaGAECpxklCf2BKRBYFhvWtCwjdKJ8nlLlIDN+BD1CFA4tZxsvWwbrbFHu/A54MMIyO+isw
 yfuQGoiyfH3Bt4RFA1hwR5XmAFrKGC9Lj6QAvTwtAmzCBhMn2uA7O3f
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-15-0a15d8a799aa@google.com>
Subject: [PATCH v11 15/46] KVM: guest_memfd: Call arch make_shared callback
 for to-shared conversion
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A820B140004
X-Stat-Signature: k1fkh1f3dwh6xtbczgebpbuu1octiwfq
X-HE-Tag: 1787735914-966400
X-HE-Meta: U2FsdGVkX1/MxIFnzDoSwMQdId60Gd/vKRuE7szn14sAEvXFS0miADZMxXHcCZfqE0YpM/iFx2XbpLsoePh9aVb8XmGaJgnOAi/qbPklm8zWZI/Wwg1Pr+56AGvCUlr6eT+UqWdHzeokkWaE+wgLkt13pcVbjF3X8fG1jgOsk76XBAk0ISI920K91PIdIK7Qg9mDVGYqNuedciKnP7TrQFis3FIGGL8nOGRvOuzFybBjA2i7gwufsP8W1CuaKGgKdEfxPfd53jcObHBt4xW9KuZqFUvPRIZYuWGQzu7NOfqlu40MfVy5AbApVZNww3LrMoqLbcH0S139Fy6buVBXxW6YISxAc+XykmU3jch1LMIsa8WqmHxC+mSOSOz6sGCtOQXT+/VxI9800EQyJR6fdS7tmVTHgqk7RhzqxbwMLfg6B8NJGSzJBMV9mlNKOsnmJiST9nf1SnJy0if++kTaLKt9rFjStkTawUL9L8Dr4n9sY+agoquqfEiQiWUg/l5vtDXkrVKIn7NiQk8K8c7w0/5UFZ+o7TtEwwseDNVqK05Zho/qTCuLs70SKsX6JVdirkYkF34Y6tB2D5fqU6hhc/U7WBFB538tQ6OUuVHDqNnE4nmS2ph7h9Pi+T99qsYHvmNWLOQcKPhJm83eJWYJYAUs/iaxqDVAaFdGHawma4H4n2DG1O9/6lfN0Nn8qHlDMF7VobbioiUJVofCGjljWWgeVYyZ6WWBQFvDilj6s0vqwhtKvs/H460fYno1XpaadpXeYME6uis6/87Bbr/VabkQjQDAX8cVLf3OC/2Pfs3BIbmfiebUdqLAr8ZOBpTD83qf+Aj3NLIXg9W+G5FfyPfctvEMomRSt/Hzi4xwjQfIEmqx4PQkg6ulR0zz9fzviDOD2G09AgTgepwCEX1nALgPJItCQkgQXifqxFVzAubPl6r2eluXVbw/rQOearsoo/l6EFUhjREgtQ4iEau
 3Toc+rWx
 mkje8wTYXB/YnBk+C25nYeQaOUqftXS0gWGKyFySJ4mr10veZZYtENQ88QW9lu7sz7PLApTT1VtLAjVWQoZP7N7GrwF5rUFSyZ7tYR1CkUOooAcgvfiySCcFEoni+exhPj1zc3WrFYqhrQ5tzuJ4uftoXhhnabubnu1+wdKxL8ETjLvk5JLjN87V2FnSbncMS/FPPWYIyjP9ajEGX7UUKKMJJzsqIzrspz0eUjBLBr5sUX/e23+e+CxxuQPt7KvrPGPltezDncPNcu65hzXusxw2puVDuRf3gZvmDvJ3TMlQlhN6eMYtq+cMNDYbye/aEJL8IQkXm+7EL8bkHTkHVOn6cPVEG0VldzwskwGWl9AMPrm5IwFBJH1Kz0Id+nkDpyk8tiMGya5b4wYGm8i5W7137fnAcSAvQXO7W1V9nzjHNm6200iTdcbKjolDJ1JD47dCioA3dAnmL/GoSscEslV+xoQvWFVNV5MKvX1w6sMTkV6mPNm2Z9hDHXIB+3Yk9tC2+xhsegaRkCIrRnzXxR4zas7hHzRcNzNG+uK5ERoRh/d53xe5u/3cdtiZOehF+aozN4m+pEozJkCkb8Ajl8qXn2v+xa+8JqteLnzC7pNKG754BrvXP2QcNRJXZ8M7KU5vGRfdD5d+0pnO4CdXpYiSA01k/O99JXpXw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When memory in guest_memfd is converted from private to shared, the
platform-specific state associated with the guest-private pages must be
invalidated or cleaned up.

Iterate over the folios in the affected range and call the
kvm_arch_gmem_make_shared() hook for each PFN range. This allows
architectures to update hardware metadata or encryption states to
transition pages to the shared state.

Invoke this helper after indicating to KVM's mmu code that an invalidation
is in progress to stop in-flight page faults from succeeding. Calling the
invalidation helper also calls the arch invalidate hook. For SNP, this
kicks any vCPU with a registered VMSA within the range being converted out
of the guest. This ensures that make_shared never fails due to the VMSA
page being in-use and is important because if make_shared fails, the RMP
table would track the page as private while guest_memfd is unaware and
tracks the page as shared.

Omit support for calling the arch hook to make private, since SNP, the only
implementer of the arch make-private hook today, would actually prefer
making private only just before faulting memory into the NPTs.

Calling the make-private arch hook would require iterating both bindings
and the filemap to find the intersection of bindings and allocated
folios. On top of that, SNP would need to figure out whether to actually
make private based on whether the memory is about to be faulted, or
whether it is a conversion.

Calling the make-shared arch hook and not the make-private arch hook does
leak SNP-specific details into guest_memfd (as in, why only make-shared
during conversions but not make-private?), but the additional complexity is
not worth taking on until guest_memfd has a user actually requiring an arch
make-private call.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/x86.c                 |  5 +++++
 include/linux/kvm_host.h           |  1 +
 virt/kvm/guest_memfd.c             | 42 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e213c9ae3e301..67b43c167045b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -150,7 +150,7 @@ KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 KVM_X86_OP_OPTIONAL_RET0(gmem_make_private)
 #endif
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
+#if defined(CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT) || defined(CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM)
 KVM_X86_OP_OPTIONAL(gmem_make_shared)
 #endif
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 744c1f6ff03ed..83e26ce45fb79 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1732,7 +1732,7 @@ struct kvm_x86_ops {
 	int (*gmem_make_private)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 				 kvm_pfn_t nr_pages);
 #endif
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
+#if defined(CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT) || defined(CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM)
 	void (*gmem_make_shared)(kvm_pfn_t pfn, kvm_pfn_t nr_pages);
 #endif
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 29e41d334cedf..147b3e529cd26 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10653,6 +10653,11 @@ int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 {
 	return kvm_x86_call(gmem_make_private)(kvm, gfn, pfn, nr_pages);
 }
+
+void kvm_arch_gmem_make_shared(kvm_pfn_t pfn, kvm_pfn_t nr_pages)
+{
+	kvm_x86_call(gmem_make_shared)(pfn, nr_pages);
+}
 #endif
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab87effdd221f..485f18454eb45 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2610,6 +2610,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 
 int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 			       kvm_pfn_t nr_pages);
+void kvm_arch_gmem_make_shared(kvm_pfn_t pfn, kvm_pfn_t nr_pages);
 #ifndef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 #define kvm_arch_has_gmem_convert() false
 #endif
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e4722eb6405b6..d1134b23576e4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -575,6 +575,43 @@ static bool kvm_gmem_has_outstanding_references(struct inode *inode,
 	return has_outstanding;
 }
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	struct folio_batch fbatch;
+	pgoff_t next = start;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+			pgoff_t start_index, end_index;
+			kvm_pfn_t start_pfn;
+			kvm_pfn_t nr_pages;
+
+			start_index = max(start, folio->index);
+			end_index = min(end, folio_next_index(folio));
+			/*
+			 * end_index is either in folio or points to
+			 * the first page of the next folio. Hence,
+			 * all pages in range [start_index, end_index)
+			 * are contiguous.
+			 */
+			start_pfn = folio_file_pfn(folio, start_index);
+			nr_pages = end_index - start_index;
+
+			kvm_arch_gmem_make_shared(start_pfn, nr_pages);
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+}
+#else
+static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) {}
+#endif
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 				     size_t nr_pages, uint64_t attrs,
 				     pgoff_t *err_index)
@@ -624,7 +661,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
 	kvm_gmem_invalidate_start(inode, start, end, filter);
+
+	if (!to_private && kvm_arch_has_gmem_convert())
+		kvm_gmem_make_shared(inode, start, end);
+
 	mas_store_prealloc(&mas, xa_mk_value(attrs));
+
 	kvm_gmem_invalidate_end(inode, start, end);
 out:
 	filemap_invalidate_unlock(mapping);

-- 
2.55.0.887.g758fc8c411-goog


