Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1C2C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578C88E0016; Wed, 23 Jul 2025 06:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528AD8E0001; Wed, 23 Jul 2025 06:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9438E0016; Wed, 23 Jul 2025 06:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 276358E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E687F140658
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:38 +0000 (UTC)
X-FDA: 83695203396.21.475E80B
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1CAAE1C000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HwjjCNxi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3x72AaAUKCJADuvvu08805y.w86527EH-664Fuw4.8B0@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3x72AaAUKCJADuvvu08805y.w86527EH-664Fuw4.8B0@flex--tabba.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlxcNDM8GfkNbLw4o3YWN94YEp3XYisy/OehMz9D7Lg=;
	b=lw1fnEaJeskBwV0R106dXe3hXxeDOcLQuujMZko0kjWzzyYl/6GuUxZZtCNCAjTYd8c46H
	iZ6m8SMSwhbTOH2wlYYDk06Qu7grHSbNFYPIWfZjEu6A9nODghkSCSEIjHHbgCNffbxWr6
	sO+L8eoBBmVLLAh3Yvrz+0gyXUMhyAA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267657; a=rsa-sha256;
	cv=none;
	b=e/SF3rwvkBoBZifIZcPyakihNKnyZth6Rg7DhvnGrDtGDkR/sAVuPVX8bpfK4uCYUst+rb
	p9l/3teqRsgDIWySJPNyEc3a7B08RYcUQ+KS8nPtRrVPbmlkDOnDwAeavDHTfUYEpt++Ar
	0DSpaMUI74HJqcsdDxmIyjBt3mPdE5g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HwjjCNxi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3x72AaAUKCJADuvvu08805y.w86527EH-664Fuw4.8B0@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3x72AaAUKCJADuvvu08805y.w86527EH-664Fuw4.8B0@flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b61e53eea3so2901471f8f.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267656; x=1753872456; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KlxcNDM8GfkNbLw4o3YWN94YEp3XYisy/OehMz9D7Lg=;
        b=HwjjCNxi0jI07zaj5V5+ti/06lTKogCI7BJjh3yNFUf+iztMzeMGdL5T3wRwo6Y61V
         8pI7AtW8PoS5zw8PsozPoaaETIzWpSnJw7p5+4Ap6r0Yvn3aLQkgFsr8MWBLFCPibIC1
         t+XySn1LCVD3sT2gCD0uBluSN4LrHHL4tUOAs7nMylosGFpqcjTf3JDCE/B4kHslIXzw
         oyc+BzY/D4KBFZ5CYBaPtQ24fdefRpNMS1bd5OFtHgNpy5HCUwiW8MhqCx+k350wgMVX
         pvdUZ90t/ktUt1EqsDRKm5i/JbMF+EJcrPOhGvBlFHF1hcF9jYrM2bKz/DE8QJcNT5//
         8P1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267656; x=1753872456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KlxcNDM8GfkNbLw4o3YWN94YEp3XYisy/OehMz9D7Lg=;
        b=ohIec3x5xouYUBs1msPeHlsGsI1a+RuoFkveM8w/J6cqCCT0gqay2KQ/feGszL2kdq
         AB5FvvBPfIzP5hyqlW3g/Vc4FFa4XvKaL57QlPnQaOJQgybI9juN880CvcyR6ksIJtSG
         s/MPyKAMNRSVaTqFaT+oDIrQs72TvJJnFI8l8qL4VrM9pyDwtE4WZBQTHOvzgnokRLeW
         5yo2dkBfjwOOfMiplu3pUPFIVr5MD14UQ9D9X2QgwlZ6zmrHN4DOwthEKwBnKiv9yVx7
         VfyyRcfwlXmQTxSlDTZnC2gi5JCAdV4hFis1/AdREJIpEWRvwky/aKG3DDUlXQSCb7hL
         kGnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTcq1VVhwmgSLTEc70685ROO+qPL5/FZFwh597dyozcnU/yHCVhbAuRKQndXx/nrEGt5jarNoeQg==@kvack.org
X-Gm-Message-State: AOJu0YxDG5mq11y75KX3B4wzbh9QQ534LmiVB/0jaAah1MhVr581QsBi
	AV0CKJTbDi5umHY0OaGlGB1TH/syFCzNAukJfhCHGDsg2+SQ7MAqKIKPRYojyhABtNFlHLaSkzE
	Rzw==
X-Google-Smtp-Source: AGHT+IGyaKsC329OBN9V1qxHlr9H7PRQZ93BDS0adc/MtT4FbbSuIMkwbSVam8vf8SbmIv3tftcMpfJ1jQ==
X-Received: from wrbcg16.prod.google.com ([2002:a5d:5cd0:0:b0:3a4:e199:883b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4201:b0:3b4:9dbd:eee9
 with SMTP id ffacd0b85a97d-3b768ef951bmr1536942f8f.36.1753267655654; Wed, 23
 Jul 2025 03:47:35 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:11 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-20-tabba@google.com>
Subject: [PATCH v16 19/22] KVM: arm64: Enable support for guest_memfd backed memory
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: crdxdw4ma9qw4qi64xb3di1ncxmfgf8c
X-Rspamd-Queue-Id: 1CAAE1C000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753267656-971907
X-HE-Meta: U2FsdGVkX19aXL/d0LaIsm6rT/HdZ/0RiLFCfnCeexxWN7xl75EwPTa4D5r4J5JmvDQz2q7S/4v0GsMNq5UH9K9BQP1dF+jYbQxu9APEBG6ezMURPJmYh4QoXvhnj9qV4cSBhYQzRguqlqEF1qMwj4UbKZv3Ma7ZAztSCEbhK3RN1xK6+SNnDtr0TL2VfRaO+WKmcOvBuE7b3wUfzunvA6emKIpoxkuFJawNvRAHNo8F81OjneixZLbVyEiauTfEyKRAHWDllnRWx34WyMGBWQ/omXcKkn8nmXVK1A7f+ajG37QdWZ0acwL/mvfEB/3d6mPEC/r+s/iDtDtcIx+uXlZmuvzIQjyiwhDjCQng4ECueV4rt5XLd64rqQsN+uuDhieqG6o7pW7GvN1Kqy1O2zszKpeWDMeHrU120XAyu0TiJENd+TdeHDynTXitac0QYRw/vTcK5VBagbixN41HnJwKlHU3+Igjr9gYdrUHP7XDgp6tvBrNJXb7PeKs8vtJz7jhhLEAMngy7oL8KqO62CbrNnVnRyfutpDwsDrjPAGmu+wPHYvxlXL1LI3LBugy4hljdGqbUAZ9kePJArui4bi1XXxdIpJlfwJTQyKzGSsgKG5E+HzyJahqxso/3kLSwvFS42pqEI8tiOFWwPuh51hlmG0BmMfT8fWJSS3RHaSBJJ3Xgz5+9RVGLovjs2J+HD+N8yAsUDiJm65LIeLk4R3LlLnwEIiakZzhWRjDnvJH1UWwqim2FeeEYRu18nVB5FsalX4ANlWLngWmNuEcDnwqn0Ds3E0E2XZP2P3g1IRa3G0W1SxYHG8SuXGSaOm56PbS/xLVh+UoIKk91NWgw2PIZT4c6OV6Zqi/vSS2lWqfIalWJ2/MO32ehbzaCq0StYMXFcrnEFj8GxbKDoExxDxWSNKNth8AVuY9ZmQihh4kGCS6PtdmRQOZ/ALk3doJhbnJDpBH5O4MM5XlilC
 DJNLQt54
 Ky1Xfre6fJ4zpZXUY0BNcOhJYdaM2V8fI+thlze+iHq40IgSggYZ4FnMbXxd/2anWrMn5czD1iRitYHY+pSPN2j9PTinMMgT5V/UR99+hxEzJf9tn+A5i3d4rRTJdhowU/S57QKX3lY1g3kM+te7DalvrU9veuTSMoOkieF4d5yjA6isC1AwmfpFAW09aDkPZEv7dCtsOeYbx10U686UJqvpA9Kl9WrmMIuxnAQZdSgi1qVAVapuv6qKF5G2tVBKJsum35TmjewrguGJ+gpHVqQQs7TczTcS2X2vN/zw/0lyXzhzW5txQA6ifAKFrgJoz1dUReuUbaOfhGI1VY/29UQW4ux2jKmbeqt0/EKsIZhOSvnxoj2zQEBo3UYLn9VWJ345OZ5bdrA+edWfAx9hMDb6dTLMfuz5rDtFCI/bmA9Uc6BjXghrOuwOcliENyG84eUbSd4mcgx2tn3QcqoqYKvy70Pc89x3IAIub4mPqjyqkGfQEZyopOZdSUoTuuTrlhfqAk8Tawr/8t520sWnuneMpGFwG4KpNYlsvkxhKcuSB9ErJIBZU8RUp7TgWPxCAfWIYT/AZ2ZcKlrMqrg+q9wIxGIkYcjWTFFZRTpVHpbtVg8KZEtzILWRbnemBgj94ab79vSDYg/2pHDS5zZuhtvlqzcVlW7S3GBglykBEBs/2kylI0NcH9PL0la+uzAKoVbnL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the infrastructure is in place, enable guest_memfd for arm64.

* Select CONFIG_KVM_GUEST_MEMFD in KVM/arm64 Kconfig.

* Enforce KVM_MEMSLOT_GMEM_ONLY for guest_memfd on arm64: Ensure that
  guest_memfd-backed memory slots on arm64 are only supported if they
  are intended for shared memory use cases (i.e.,
  kvm_memslot_is_gmem_only() is true). This design reflects the current
  arm64 KVM ecosystem where guest_memfd is primarily being introduced
  for VMs that support shared memory.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/Kconfig | 1 +
 arch/arm64/kvm/mmu.c   | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 713248f240e0..bff62e75d681 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GUEST_MEMFD
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8c82df80a835..85559b8a0845 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2276,6 +2276,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
 		return -EFAULT;
 
+	/*
+	 * Only support guest_memfd backed memslots with mappable memory, since
+	 * there aren't any CoCo VMs that support only private memory on arm64.
+	 */
+	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
+		return -EINVAL;
+
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
-- 
2.50.1.470.g6ba607880d-goog


