Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A99BBCD5BB1
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CA96B008C; Thu, 21 May 2026 09:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D326B0092; Thu, 21 May 2026 09:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0236A6B0093; Thu, 21 May 2026 09:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E87106B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:21:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5D9E1611E8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:21:53 +0000 (UTC)
X-FDA: 84791489706.16.FB3F806
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id E006E140011
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:21:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JpD3ARNU;
	spf=pass (imf23.hostedemail.com: domain of 37gYPagYKCI8Bxt62vz77z4x.v75416DG-553Etv3.7Az@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=37gYPagYKCI8Bxt62vz77z4x.v75416DG-553Etv3.7Az@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779369712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIrwVyrI6nQx/ALkh7jG2SEyqSQ/V8q8plyAwbOOpCU=;
	b=bfBDsdywmSy9lL6SHzY20CCX9+bx2UbmKGrR6t95Y7r5/l3SR+KDYbtDRWOyefqKIykE+3
	bTfcfMVnZiVDltuj/bH43nyau2412A2+VHCVJXldYXy6TsGhZW1NkZO/4tj4kd2EUKdili
	zLBGJlPnaYRzBNkcyFfYdXDrdjEPBwI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JpD3ARNU;
	spf=pass (imf23.hostedemail.com: domain of 37gYPagYKCI8Bxt62vz77z4x.v75416DG-553Etv3.7Az@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=37gYPagYKCI8Bxt62vz77z4x.v75416DG-553Etv3.7Az@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779369712; a=rsa-sha256;
	cv=none;
	b=fu+7hDW5HZkwgpItKcROsvgsrezjgbweuBTHyNWEYDG5sS8ilv/j3rfNmWtJs79Yc8w7QC
	NasvBMFRjte/jBvg97080VZ0C56+0oZAwNF5cxTBa/fazukbyrOBxOQ5kZsfz+Fwn4ptB4
	VbKigQ5LecXrEYGtlIJ3yFjAT3qzUBM=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82fa366fb79so8320240b3a.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 06:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779369710; x=1779974510; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iIrwVyrI6nQx/ALkh7jG2SEyqSQ/V8q8plyAwbOOpCU=;
        b=JpD3ARNUTiW0LHN5L5l1ox1GYlOsl9R1YLpjNzl1P1u1Hft7v3WWTZW7JxjSEZvOLs
         OUheAf+AoDBMQhU6uYLviUBMxfPGjS14hj720pHHKbHfJovcOzhd5Jw+n90krKH4IHij
         p4Jk3eELcbrUv0/OeY+i/Veh+4St462zb8wN+KN1TQXSb3ub6so7ini2fPDMHTbQhQxT
         N67Y++h3UpwH51DtE7aTn8YjmMWZX/ELVxPgB7vpGRP49yIeST5YMQqbsyg+lEqtnyOK
         AJKLuytJwqwMjYQuXtxnMVmCIabM+9MSzxZKgro0MMw60qWrTFFeFKYHYpyqbJpI+gPJ
         +EHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779369710; x=1779974510;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iIrwVyrI6nQx/ALkh7jG2SEyqSQ/V8q8plyAwbOOpCU=;
        b=ZWzdNhPMoATUpzgZ3Wdrmyb6pcQaizrH+nbAyBITBUqxCmVJgvnt25BKZgqAsYtg8t
         DJGk8Oo1LkSRbEBPawzTgEz6f5acCl4Ucquf/4CbSYWG1tPauwOo3n2CG7hma3d4pC3j
         oJ3bVT+FUeWf3fLCFykI3OAUltg+Uj/AvSP2dXkusXE8qeG1PNScoAUMKFSUHGt1TpWt
         Fw5Rkkt2usRAEmLBKQ3DijJuDTZMF/LPqe6+/oADdoRYMiMFYvtyoFvGMPejHav5jL2c
         WimTgIHNoHPjvwDLQMAMp0ir2QiQRxYDFiRtFhCocklybyWK/IQMDiluOcKt3mXW5cjg
         DA5A==
X-Forwarded-Encrypted: i=1; AFNElJ+72KUjC3CuHrQR0dsfcLS1ldBVGdS2IZcPlLnw5x9cxIaaDTfG258aucheas6fWYPElgCuG19p6Q==@kvack.org
X-Gm-Message-State: AOJu0YxnfDAwmGWhxCLaeIrAkVL9RK8LdmaxSCzsAMxXyqm9PNj9o0WG
	cRdl9cFgoseKQixvUv3lLHU85Pf5QdlT+SVH+TVW7HVcczhuzveovOCINTd0iPcSavMASQGqCb2
	VRNOE5w==
X-Received: from pfbmb13.prod.google.com ([2002:a05:6a00:760d:b0:82f:4abd:a354])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2793:b0:835:cc47:6fe7
 with SMTP id d2e1a72fcca58-8414adf7c0emr2878031b3a.30.1779369710072; Thu, 21
 May 2026 06:21:50 -0700 (PDT)
Date: Thu, 21 May 2026 06:21:49 -0700
In-Reply-To: <CA+EHjTwrygfMrZZSw4y7-ry8fidW2x0C7iuF2Q=dnPNHUmNtUg@mail.gmail.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-21-91ab5a8b19a4@google.com> <CA+EHjTwrygfMrZZSw4y7-ry8fidW2x0C7iuF2Q=dnPNHUmNtUg@mail.gmail.com>
Message-ID: <ag8G7Wq5PbEdKloG@google.com>
Subject: Re: [PATCH v6 21/43] KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: E006E140011
X-Stat-Signature: ob6kj5q81aaaq4cpf9ayo6mymudbbigp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779369711-350087
X-HE-Meta: U2FsdGVkX1+/tsAs/Rr5MbBfWmAYizidKLhVz925+KSgu1UGJ8wXU/TGI17c/c7R1TymuDPTT4kV5p6xFd5eZekMeAPtlKcpcNV8IA357X+mbT88uqSYrT1KHeU+fzaQPngGN4deioLNEKFq8DT9yiX/ebVGALZb6gi2retifilwzIihqnUc0cA6tt5BZjkCNmhIPNOM5SkM1a/EwHXb3pBveraUoUKlqtNbaqewJ7mJWYUp0tt2WlU4XdIDxKTX0lR+iGtsbkJ2hxOYj9Ax/RSebESffEJlJ7PQ6/veBOTCWwb3xQJltL3XQCq4J7GN7QeXGUpyVyDJP/q94M8iugj7dnhEgiuLuD6fjjpyh+042to5BDKb+HHI0TLQhBtUQNETr3sI9fPL2AGwwA8Ur12c+COtpNPO35mEaWyQSVskAEIt+VWDxYz34vFSAC3E3m19feSoIsCvad9qJpYRqBpc5PbTKE+Qjvn8shW07GzMkhCQr6T3VvaivgjxhafwcFDAzqOWhmN7wDLOtKF/wzPaUtJZ1LcnEZKBf4kdRcMg25wqB/8FoQBGjDUssnRToTFXQd3Qi5EY2qjujTRCN9lZYsumHXLe2dlD9XX6NHDMAVXWvrul+l3SeuHXMVRRgGlo/PJl97PL/Da+Dj5MPUn4NO9HuAFnfD/DWJvBot8tXUHakGdPDxcyUTPfhFgpWiQ3Chl72YJTrUdxTpjaoiVYnjUKMgV1iHCNnpEXi/DsYt+epf2Inx1CqvCqmiP0wh1Jnszm8kUGIGR1jaVRG7xSRgMxW7cvWPfaqoOEywqHzY4OESnGII51L5WJL5xKq144Ta6l39O3w0xL+ddVT+0FOcjtK7xBXdfoNNyxG9YXl8cKHIIwkU5huS12Iw6Qg8mFoe+1e/Jshxu5CwdHcqyGbaVqhbYngFZsloV0bixD0LTbEZ3jVk/XJj6qk+itvkJPg6A/TXXhYSyLRS9
 LAIyEdBn
 QsYbGxf+hABO2aED/OlWE9ntnEeEOg9Pfw4mV6TK3juOsQMa08qSOr6RAbkLUmj6ZJhRVphlUbARw0KP/9U54G1Su/kqNkfDVGsS2DtLPgjQmXiO/CRLLIAVCs7K+UKYJuWgatJsIml5IyauJvdZoEJWW/1rEAr3fxnyqSJgPmB3KZFWNQ6JJVzZ8YXHE9pieYFBaMEOVv2WysJZhEnRC42Tjshhgqjf/YpLNzOwfIAB3wjl4r93mTw14i3S59qbwiWzwgBSbUMoZ1NpHs05/fN+qECIJ29UDs81ENCU0XR9sIbdksNn+P2EP+mNIxm6aDr3ckiLemPoPSWDa26V+SWsKLVmJKL8zmlyMDIye9UoBzeB2QCXDrO89RArybjFGqJqHipHz5xtjtV0P9YJcQb7dbBmJke1L4D40N6KU9dyrB02e8Hgs50ivd4ByXPNx7PVyhUTfgztJZ+NNEAX0KH+ERh0KSZjqKV6NRm8CdATZHi0yYMsSx4Q9Er9HpZP2ykgK4+wV2Zq27u7aVS7D4IIOxF9c2jd4DWi7oZ2d7myvyKVSUDBk6q+8V4eVnhmvkvpfBdzKY9TlpVKfM7oNGWtIjmIhZ6mNKR9cE5+n01+FeYTQP9wkR+8NsQ0Pc3JukhKk3z/dhEV5ITFARlMM3R8BoyY71lhLJTwhfLpy0CkHcN8Ile6qdgjRLw+HPABzfPv1jC+UeBhJhG3sFCQJ07neyQqbSVImdk3pwH7C3bGTDRokGEQ0ji9T5igEcn5+ZySs/ad8y1GlUJ7MYeSOsiKtLUaF6FHGuY8NlqnvZInLgrsDOz6M5+tG6tD62aga/ug0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026, Fuad Tabba wrote:
> Hi,
> 
> On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
> <devnull+ackerleytng.google.com@kernel.org> wrote:
> >
> > From: Michael Roth <michael.roth@amd.com>
> >
> > For vm_memory_attributes=1, in-place conversion/population is not
> > supported, so the initial contents necessarily must need to come
> > from a separate src address, which is enforced by the current
> > implementation. However, for vm_memory_attributes=0, it is possible for
> > guest memory to be initialized directly from userspace by mmap()'ing the
> > guest_memfd and writing to it while the corresponding GPA ranges are in
> > a 'shared' state before converting them to the 'private' state expected
> > by KVM_SEV_SNP_LAUNCH_UPDATE.
> >
> > Update the handling/documentation for KVM_SEV_SNP_LAUNCH_UPDATE to allow
> > for 'uaddr' to be set to NULL when vm_memory_attributes=0, which
> > SNP_LAUNCH_UPDATE will then use to determine when it should/shouldn't
> > copy in data from a separate memory location. Continue to enforce
> > non-NULL for the original vm_memory_attributes=1 case.
> >
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > [Added src_page check in error handling path when the firmware command fails]
> > [Dropped ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES]
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> 
> I'm not very familiar with the SEV-SNP populate flows, but it looks
> like Sashiko is on to something:
> https://sashiko.dev/#/patchset/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4%40google.com?part=21
> 
> - a potential read-only page overwrite, because src_page is acquired
> via get_user_pages_fast() without the FOLL_WRITE flag, but is then
> overwritten via memcpy

Oof, yeah, that's bad.  Adding FOLL_WRITE to kvm_gmem_populate() feels wrong, and
could break uABI, but doing gup() in SNP code would reintroduce the AB-BA issue
with filemap_invalidate_lock().

Aha!  Not if we use get_user_page_fast_only().  Ugh, but then we'd have to plumb
the userspace address into the post-populated callback.

Hrm.  Given that no one has yelled about overwriting their CPUID page, and given
that the CPUID page is likely dynamically created and thus is unlikely to be a
read-only mapping (e.g. versus the initial image), maybe this?

diff --git arch/x86/kvm/svm/sev.c arch/x86/kvm/svm/sev.c
index 37d4cfa5d980..c73c028d72c1 100644
--- arch/x86/kvm/svm/sev.c
+++ arch/x86/kvm/svm/sev.c
@@ -2456,6 +2456,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
        sev_populate_args.type = params.type;
 
        count = kvm_gmem_populate(kvm, params.gfn_start, src, npages,
+                                 params.type == KVM_SEV_SNP_PAGE_TYPE_CPUID,
                                  sev_gmem_post_populate, &sev_populate_args);
        if (count < 0) {
                argp->error = sev_populate_args.fw_error;
diff --git arch/x86/kvm/vmx/tdx.c arch/x86/kvm/vmx/tdx.c
index f97bcf580e6d..33f35be4455b 100644
--- arch/x86/kvm/vmx/tdx.c
+++ arch/x86/kvm/vmx/tdx.c
@@ -3188,7 +3188,7 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
                };
                gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
                                             u64_to_user_ptr(region.source_addr),
-                                            1, tdx_gmem_post_populate, &arg);
+                                            1, false, tdx_gmem_post_populate, &arg);
                if (gmem_ret < 0) {
                        ret = gmem_ret;
                        break;
diff --git include/linux/kvm_host.h include/linux/kvm_host.h
index 61a3430957f2..b83cda2870ba 100644
--- include/linux/kvm_host.h
+++ include/linux/kvm_host.h
@@ -2596,7 +2596,8 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
 typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
                                    struct page *page, void *opaque);
 
-long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
+long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src,
+                      long npages, bool writable,
                       kvm_gmem_populate_cb post_populate, void *opaque);
 #endif
 
diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
index a35a55571a2d..6553d4e032ce 100644
--- virt/kvm/guest_memfd.c
+++ virt/kvm/guest_memfd.c
@@ -858,7 +858,8 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
        return ret;
 }
 
-long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
+long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src,
+                      long npages, bool writable,
                       kvm_gmem_populate_cb post_populate, void *opaque)
 {
        struct kvm_memory_slot *slot;
@@ -892,8 +893,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 
                if (src) {
                        unsigned long uaddr = (unsigned long)src + i * PAGE_SIZE;
+                       unsigned int flags = writable ? FOLL_WRITE : 0;
 
-                       ret = get_user_pages_fast(uaddr, 1, 0, &src_page);
+                       ret = get_user_pages_fast(uaddr, 1, flags, &src_page);
                        if (ret < 0)
                                break;
                        if (ret != 1) {

> - an ordering violation with the kunmap_local() calls

Yeesh, that's a new one for me.  Thankfully this is 64-bit only, so it's not an
issue.

> These predate this patch series and are just being touched by the
> 'src_page' addition, but if Sashiko's right, these should probably be
> fixed sooner rather than later.

Yeah, ditto with the offset wrapping case.

