Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 405BECCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61428E0023; Fri, 17 Oct 2025 16:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12928E0006; Fri, 17 Oct 2025 16:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B171F8E0023; Fri, 17 Oct 2025 16:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90B2F8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C342B7FF9
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:40 +0000 (UTC)
X-FDA: 84008704080.12.BB431A9
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 76D2320004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m8oHArIn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3NaPyaAsKCJQy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3NaPyaAsKCJQy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731958; a=rsa-sha256;
	cv=none;
	b=s42pWW0RtzH/RBCjT/dBu+XMBEyX7oZip6Jnvb5KE6GWjxIIeTuXdbqFnwuDSAX6+e6vkl
	2XjbHRTVP5/sZSm0Pr/ZBE8K8VEJgpZgdS5RqrQpNNuHa0DF5EgmbJetA6gNDme/GEyLfz
	1hQYTZhKD4ZksmJ77jfD8supoARKGxk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m8oHArIn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3NaPyaAsKCJQy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3NaPyaAsKCJQy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlCNqACOdtYs3iSi7DDE5wuxUUy0M1CfmngZZRUKmxM=;
	b=L0nFT0ym1TbVcDaE6h5hQkZO3436KlD+F1c0px4mFgFqASW5VsXxvIVtdclFGKSt6Q7D3J
	TbGDqA6v+DVMwL3fcNQbPu1GMcUQZq5pTLYEU3Xn2Gr5Gu6QWLTi1bx8jaYaBNUCJVd6d5
	vsvLKU6UmsmNL9L3RJU8PUNjSvpCumE=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befc08so4999377a91.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731957; x=1761336757; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XlCNqACOdtYs3iSi7DDE5wuxUUy0M1CfmngZZRUKmxM=;
        b=m8oHArIn969aGheu0G6Ejsy36QetGmuR8yfDTzDslmieJUmFNRWribhL+tW+QkPAXk
         f/OFQtIckwmoQwNISGEN36lxaujlT+lHKItS4NjZ7EHyzWZKCzvK9RWuGjDRlXACkTFV
         BiL//2vXE0FaQsTB7q2bMj2HCqNa/vCSHUzKAl9PQqWInSknGTD49cHwes/sltsufmJ1
         V3Z9yQygwyfcbHuDVGrY32tld2IHcS/ITfHPgPYJJ69/9u5wf5iopNyM8qen9koUfXGm
         0BMN749ATbacS+ml5R8pS9iMxcTFapWPhZkkEFFhHcKKaaCOIRotKBXfPBZTm9w8rDqr
         9LwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731957; x=1761336757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XlCNqACOdtYs3iSi7DDE5wuxUUy0M1CfmngZZRUKmxM=;
        b=RCxRLc93VuDDym4865EV5cLwoNOsOz+VGk3nRafrP7So8cNDk5U0rYiZcr/pNcRbtb
         ATPAyvkcHw6B/d9NPHz3SX3Nn5VbC7H0O3T7/nJ2nXhsbhF7raKxgzR1DWCFAr3n2Jr+
         OCVzjJ6C+MZa+GrlWOYWaAMivHev9Lt5RkkOsBuQjEVszI3KcLqxzcn+BKH58lpWHbzX
         2SSqlD4S9VTMa1DM7aknTMv3qEhf97g/eHf502QiByy59HSL2qtmZTiqxK6Xm2R19obz
         L0iRNLhH1g5rjM/V4LfB8yDpi6HTAby1vO6PN2FivJvoJ96PhcxvwhZZetSv8hfpYMHX
         0gRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxOnZTyBQjsdp9JrWPFrLjduRUZz5iBNcnOnx8ecYPlQ07LMhRu/UE3CXaIrhONAmfwG0j1w3j+A==@kvack.org
X-Gm-Message-State: AOJu0YzXwt8iJvy9n2sf+cRVFenpmp7WXC2DMNlbTfr6sqXt3R/9t4mx
	M9DyW17+x3BlFhOd8qvPAghQXjWkUyJzz1barMV3fInMWKWX1kMWC+L4pLqsNN5Z71N9KueN5BO
	s0IJ9T3xEiy6WHYcYBp8Dna5kqg==
X-Google-Smtp-Source: AGHT+IFfRugl5BuOK85KCSPRCTyguqsgSWCpXisujchuXiQdVcSPjeXkXDq3mUoTdLxoDsm9D4/TSAuMpmtTbZ9t0Q==
X-Received: from pjbrv22.prod.google.com ([2002:a17:90b:2c16:b0:329:6ac4:ea2e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3e43:b0:32e:7270:9499 with SMTP id 98e67ed59e1d1-33bcec297c9mr5833670a91.0.1760731957035;
 Fri, 17 Oct 2025 13:12:37 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:46 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 05/37] KVM: guest_memfd: Wire up kvm_get_memory_attributes()
 to per-gmem attributes
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: kd15kfnc3juebz4ejasox8wsgqr99jko
X-Rspamd-Queue-Id: 76D2320004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760731958-705780
X-HE-Meta: U2FsdGVkX18g0tJY7dzisVVrbGCbSKLqNcrq6GwfTa8DX19mOtmvYhBy2t91GyiCIYu+mNJUaz4Uar9XnKaBNMuND8QMYeDpHdckaYju+wKVldiARNonN0AbN6f+9m6Yd13myP8DJLmYzKA0/plkTE00C6Ar7XWmDCF4amj0083fgKZbwu06kiikzRQSnbrVTFuzWNPJyHtME9Gl+vRUdRJz8gQcJPe7Gt+fy54oN0F+UmPnrHszKwNr2Ayed9PLI6She7oZ4SCbssas7l71uhFu1iAQToYL4+ahJtRBbrjlqAby5G85mmEOtCK9WbEidTKZRQ4X0TuKZxkMg0PR/vhovdfoYgBhiXekk4aYpBR8fFOeZ7Zp3BRXmXyrHKsXPmIeUF0sTyzvizVz9AptaFXp/3E/2kqQTVMnxmMoA7BojQag8imrqqPiVUPq21upmoL7TBs+ct0h6/R1UKlMTvGN4skAfk4YwW2U6ubExOvm/VVCOShs9oDqV6rH25HCM8SAuUTelhmvuVs6gmBe2yeejdIjP+ZEQ2JnBxO9KoyAvfbofC7gtmt/36TSyv2tLaM3uLgwEsyw0mQVh+RpQ+azcJHmsPgTHakt0pHX1BQk0hheI/rIJeiOsOSlcW6S+xhb3z20cg40eHQ38Ca09S76vhZsKez2k7HHynnHeLjvn/gD7vdjh2Eb5j8hV9IIXwyCOXATJIh03ZJG10Dfa+96wTjgl2tAqhy+kie32EsL4rYd7Z5tXmZOCFK19UdxclCUS7XZkeW1vfX+/sCawF4SVzxZGffR2hqR3lvhg4K7qWCzeij1IP0nzS6kRtHRxZAua22mvHvBBLgIo9/4h/FMG297i2c7zp5ZxWD9DKwvh41t+hZTtWlNtIMLEDw0SkBKDkU8GIcPF1LVKh1Wf2T/tE4Oq4x1xXgWBBPs3A1Tk19QDTQgdcTBcGcW6UPFonZwIKv8cCqvyTJsqB2
 ccF531Zb
 w/aK3uwIXRpcIzX3AMQJc7CPrd+FwlPBXJs/F5mwlyF3+mFXMrIaJWicKr7ueEdfcoyQc6OCslpyf3nBV1TCq2UkJHMPLvsm5n/uhKqy7/YNX58+uesVA9f7bESh4qUxAGHj0ciA3AgqMIyoPcUaFU6FlKwofxG75UkkIMG2duVK5skso7xpBu9zQ4+nLwqJcc10P6ywK7pxVo1P5OgHwuRRWSOP3iAROGfpjsASZSV2lFWQXAkctx+mAQRFBny7wHXx9tZgEZKPlNRf3k1hrRD38fy4iWJ5Ifa9lJGVVUFoFaLCa+pJFXU8LfqP0WXNcUaUC/iMJRkrQZUSvoM6MMyPZ8Yn3ofuX5XoyvSqXrCGrttywZW/p0nfGXn1vIIDbAbJoDXFB3cNSRUKlYsPkP7TrxYorYZGAy+2me8Layi7l75SKC7UKlAOaYnpGF4Nf++2cOIrt3NluifnidGgkkHyaIEaXYebQQhYpRfrb8SS4eEwoA85fXXDOYUrVojBb+SfUOasxoVse2sIrfPHrDh+/NtKx6McKK7SISZHbR7hUJ9gVnn+ddegS9FLm78T7icz6ICJCbe/erAVOaTdfwqRdEjQQmHegLAfyBI/B9sGc5dWO+l6lDZWjClaDRcy2DFXuMmfR/584K0yuKqq1uYf0DarP+UxpL/fO9bqqEU9LWcXBD8NguVu/5rfA9ZhdB6WKPoE136eyB7novGkwwvN8y6bEhY4RXPIThK+IsFt7OMgC2TnWJ8quoeyqnjf3nsMJDSMvypJWhP0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Implement kvm_gmem_get_memory_attributes() for guest_memfd to allow the KVM
core and architecture code to query per-GFN memory attributes.

kvm_gmem_get_memory_attributes() finds the memory slot for a given GFN and
queries the guest_memfd file's to determine if the page is marked as
private.

If vm_memory_attributes is not enabled, there is no shared/private tracking
at the VM level. Install the guest_memfd implementation as long as
guest_memfd is enabled to give guest_memfd a chance to respond on
attributes.

guest_memfd should look up attributes regardless of whether this memslot is
gmem-only since attributes are now tracked by gmem regardless of whether
mmap() is enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/guest_memfd.c   | 29 +++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |  3 +++
 3 files changed, 34 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 512febf47c265..b8418cc5851f1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2543,6 +2543,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					 struct kvm_gfn_range *range);
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
 
+unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn);
+
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 26cec833766c3..f62facc3ab776 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -518,6 +518,35 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+
+	/*
+	 * If this gfn has no associated memslot, there's no chance of the gfn
+	 * being backed by private memory, since guest_memfd must be used for
+	 * private memory, and guest_memfd must be associated with some memslot.
+	 */
+	if (!slot)
+		return 0;
+
+	CLASS(gmem_get_file, file)(slot);
+	if (!file)
+		return false;
+
+	/*
+	 * Don't take the filemap invalidation lock, as temporarily acquiring
+	 * that lock wouldn't provide any meaningful protection.  The caller
+	 * _must_ protect consumption of private vs. shared by checking
+	 * mmu_invalidate_retry_gfn() under mmu_lock.
+	 */
+	guard(rcu)();
+
+	return kvm_gmem_get_attributes(file_inode(file),
+				       kvm_gmem_get_index(slot, gfn));
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_get_memory_attributes);
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c29770dfa7c8..c73ebdb73070e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2660,6 +2660,9 @@ static void kvm_init_memory_attributes(void)
 	if (vm_memory_attributes)
 		static_call_update(__kvm_get_memory_attributes,
 				   kvm_get_vm_memory_attributes);
+	else if (IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
+		static_call_update(__kvm_get_memory_attributes,
+				   kvm_gmem_get_memory_attributes);
 	else
 		static_call_update(__kvm_get_memory_attributes,
 				   (void *)__static_call_return0);
-- 
2.51.0.858.gf9c4a03a3a-goog


