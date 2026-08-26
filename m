Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB28C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13436B008A; Wed, 26 Aug 2026 05:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999736B008C; Wed, 26 Aug 2026 05:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83CDD6B0092; Wed, 26 Aug 2026 05:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EFC26B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD979802E1
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:12 +0000 (UTC)
X-FDA: 85142869224.28.36D448A
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD336100008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gfD0t+AE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3UK-OagsKCEUhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3UK-OagsKCEUhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JT2WmuQLq+zfNeKl7/c56AfNeqFR+S/et95W/1dj6Uo=;
	b=jhCeq0Z+ohlbh4Wc4s8Bf8QJWrsh6OydamEt2cpsoP4q1Pixo19+Q7pdrG/UFb0MK/q4hh
	DWtlXRDG5HikEi0FLZuYWYvUjd5FEX386OLXiMU57kQhNZyEE07DpTV8H9xCHVAn+nK+oW
	9p7FGquNXpwWr17Je/hbIryTPQz6nZA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gfD0t+AE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3UK-OagsKCEUhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3UK-OagsKCEUhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735890;
	b=wSvnUtMFfx5g4r7yvL1oy6vXap9keosL1VczP9Rx6mlMkoztC1lA8cVZAYEJCOqDsEjarn
	GPF41VPkRvKb2ZW8HFMX286+N//J6VJJ55QEXsnqpq9tfY6r1Gft9avf0p2q1U43DIJST2
	nbG2kGV44w5Zx7Hod74aVe3b3Ta0xJA=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cec4226c70so10266075ad.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735890; x=1788340690; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JT2WmuQLq+zfNeKl7/c56AfNeqFR+S/et95W/1dj6Uo=;
        b=gfD0t+AEaA7C8TAZQfpoUArz2/7qPCHpTTjBNNE0rGEXcdnjC6rXN/LiRxyeSYaShR
         Wvt/WFxBS4bnFKKwWy+PEPP/ARMCuUA1fEGkKWneD4LUw+7s7a8qs47u9AQbzBuVBFCp
         E8ghD+gs2lvwBWt7ztq1rB9y9TE5xa0WnoK85lquvTXgsjLrbWAIcBAcMVB3P5XoW43k
         MRkc508ZRRvmESvLhBPItBvLiRsjxCe11wDv38L1Nk5uNIBOknWRhTxDF8D84OLTim8m
         2H5IczfPYNrTeiOTqSP1g/Wrcwaaqk9pfqdFW3ga2Q3616Tqfq8+twBbQd0nJlvc3L/d
         0Dsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735890; x=1788340690;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JT2WmuQLq+zfNeKl7/c56AfNeqFR+S/et95W/1dj6Uo=;
        b=crWtX91bhElZCkLU/Fflm39VZJy6O+Pfs5Tyf+l1LB6zh582E7+It9QuEmOdxoZJyH
         3Z8gjIS+NZeqZcsttN4kVK/peI3Hgtgf43RRHzFgU3XzNCuYv+jKqPOMSNfSYSvZB27J
         /wW9Pl3jLx2tj3drd5q5C+nLaXpdKkTzVaZtR57IA7AmogPiUSNgjKe095C03GykL3Fz
         y+8l0ny9TIESkMuaktOr4KIzAScbZEgDQHLergwpTia4rDRZcQRzuc7C3h+U4JdPbm+L
         tNtIBU935o11FR1ugSLLsGRfCh7EBExNuxtu9eabxzui6LYVWoZy9FwpeNktAmVqIzdh
         4wHQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro/EBYTpcHE23quGCcm2ftmN1VqSjfNkB8Rnl8WEz6960yVTbSAccnzFFJuKzqswEHPG5x3iixkow==@kvack.org
X-Gm-Message-State: AFuF++lfF8rKHfJZNi5lH6nZJxJooR+OrKDv46WZz9glQkfXeRo/P/7M
	wRtz6jRH4ILoQQ1tJ8CL5QyjYhlDOZSF04DLcylBrQmIZrVHDULckXUjAyHXoKuDljqvijven38
	FKOnjlLrGeJ61jy4toQ0pzSjpww==
X-Received: from plcq19.prod.google.com ([2002:a17:902:e313:b0:2cb:97da:d8ed])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e550:b0:2ca:1479:d9dc with SMTP id d9443c01a7336-2d707b64aecmr84939595ad.12.1787735888790;
 Wed, 26 Aug 2026 02:18:08 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:17:59 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=3210;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=MbWJTengbpxG0xzwuz0lf3xMYAKXqHxm3CvrNeYe0yg=; b=hid3XaxmgWKMsVpycO2R5BnX6MEajs6GC6HPVzfM1VFvQ2hq+z9XIlxbkBtBsD30MHilmtY3L
 IRzNTIuPyMqBQVP+ooVX/F9ukdcP/AjeJNSyeQCltEtrfkmjmdgb3Nr
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-1-0a15d8a799aa@google.com>
Subject: [PATCH v11 01/46] KVM: guest_memfd: Optimize away conversion
 overheads via dead-code elimination
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
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tezd49x9itbj446mbyweu8i9a19a56q6
X-Rspamd-Queue-Id: DD336100008
X-HE-Tag: 1787735890-258287
X-HE-Meta: U2FsdGVkX1+e8hGth/WEO9F8kG+OTapRkNTzJBBWnDmal/7DL/bli7G8QvxrxHpu/20ktjqx/9u/X24VH1qwIK04OPmMfvV+SdlnqNsRa7tU20vt5AkxZDd5OzJK9068yMbJspF2eg3aGsrUBxpfQ51mC5/EHxRLtqhjke9lAV0KNupNpcD+PvfL9Mm43NEgHJ9T1vNuJYga87Llqgjosb9UpVzpvt4AxCKIRhLBq/H/cuYNZpFJkKvVjKukEFhqWY2/PAbET1Aa7h74+zDLhhmvY5gmphyCR9ZChnHUF4VP3zQOgAdQUW3jAqj5wILulyWl4O0klFG+jjXMkvzGHvEEvS9Ak87Yz8m/n+t32lZV9Jz9sVDSGVdWIRj4fkJCzJua8qUevmLsyubp1CXPVXedl0tLUpjzPdZ5Tq6IxWQd8vFi4HuMXtmhH+BBloIjkfaAMCRaJwSBuUAeF8ulPWim4aR+zjWxYOns5qnoITVkCAPMXz3g+llcPcTOR+8qMhZoXOiNIVH4PLSBXMTvwjk4eO0uzsxFcAek+1Zq4cT/9Ndlje9loNoXu064DW3Bo/oaQdHTanfN9ra1duD6ZWcWEmpxLnSzH6OclkPbUaI/yW8IwG8V0iM7aBNg4aN+7gRrZTqCDoP2l+lEP/QbZezawYcOit/b1qdJQCGrqu5qsEqAJs7+Q4a36G8GlLMJVTzsMg1vrv3s4QwYRQCITV3frdhJgBC3AhYxE0trUegy1ql++/Nhfwf14wMfzQaPaYIrlxAek6/524EmZ0hhfphC36VW69y38E7oWvCFR5js+jnX+z+gydCJvz1hnZkIxfVS+iWwjh8dINj75Mtwh+mWC9cufbM/SrvByICyPHbc2DU2myKxP8Irk1GcE/1I1pkVDlLeT6nlObxX4QnkLVWT6Av4D1YYcrfsmGl8ZsTv7z+EtY/NTXstq1Xk2sj0in7oC6BhDPA/C+lXMjk
 Wbuk9JNN
 UQ5zo+gIeg1ORJBTdU8xKWLe1tg74J0WEQ+jhiYnqpSUaxJomKH1bAtg3PROUAeVnO0+sVbb4tL47ZAQD2ftbxgkhytKmyY6STMeNw3Pc4zCYyRujz4BwViucLTJ7jjJnO/V/W8XdzVGQgaWyU7sndF+m7fwJhCSKXw6LH71L4AJagF+0ta02n8YBkYOmeJOCqrT+gz4mI6oiQ5qHXkFGNRqLd1oA73Ls6FgvGNIw65ZsbTwNYhPgCODyWX/9RPOZlJ7jodw2zRv0tWhisSkxQIqkGLhGDYeLQDd2I1aCM/+wW+b0WpBaLhudtQ0iZk0OdbDmgY/W3sAbpYtgTGF+5LNPmtF1LtI5byM1V37ipcvSbqb2W2WCgntMcCLdNfY18LlIsa1ezha6y1Sq461fPBojF6vOF0XMLDcF+g3guOYQAtXob9ozU4ugiLQacE7IUL93weWWLkxVUnMfYxj9vyLH/ju+7VoO6aQsqjYWGKzGyMpWgxNeaiaoh0JtJMEuMREZYTgeSpTIlQ34CtzhpRlhH9C4woE4/nKblvuynIQOBj/F7S7Sx8oG/sqmtl0xFeNADIgmpxt2oESsT3M6jnRfjLmQxZWY1qDTxR2K8nc0D+gatZ2wwx71oKqe3W+arW8j35QhxodnbHA0L1MEE6gIQP+8ITZE0DxOL22AgiwzSVR79J32voib6zePjXReomIGnYd6XSAT79PYD12FIXojGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add and use kvm_arch_has_gmem_convert() to guard guest_memfd's invocation
of arch hooks related to converting memory between private and shared, as
only one half of the x86 CoCo duo needs the runtime hooks (any pre-work is
pure overhead for TDX).  At this exact moment, the overhead is negligible,
but that will change when in-place conversion comes along, at which point
to-shared conversions will "need" to find all affected folios prior to
calling into arch code.  In quotes because very technically that work could
be pushed to arch code, but that would bleed guest_memfd details into arch
code and would be far worse than adding yet another kvm_arch_has... hook.

Opportunistically provide the kvm_arch_gmem_make_private() declaration, and
rely on dead-code elimination to eliminate the call to non-existent code
when CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT=n.

Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
Closes: https://lore.kernel.org/all/1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com
Suggested-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 include/linux/kvm_host.h        | 3 ++-
 virt/kvm/guest_memfd.c          | 5 ++---
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 683bb8bf43a94..6beddd8a0c749 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1854,6 +1854,9 @@ enum kvm_intr_type {
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+#define kvm_arch_has_gmem_convert() (!!kvm_x86_ops.gmem_make_private)
+#endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 502465119ca0c..b7516e19ef419 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2597,9 +2597,10 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GUEST_MEMFD */
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 			       kvm_pfn_t nr_pages);
+#ifndef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+#define kvm_arch_has_gmem_convert() false
 #endif
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 589762140c3ef..8f8e5b6b70134 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -772,11 +772,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_mark_uptodate(folio);
 	}
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
-	if (kvm_gmem_is_private_mem(file_inode(file), index))
+	if (kvm_arch_has_gmem_convert() &&
+	    kvm_gmem_is_private_mem(file_inode(file), index))
 		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
 					       (kvm_pfn_t)1 << *max_order);
-#endif
 
 	folio_unlock(folio);
 	folio_put(folio);

-- 
2.55.0.887.g758fc8c411-goog


