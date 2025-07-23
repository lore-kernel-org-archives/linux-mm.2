Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F40C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3478E0015; Wed, 23 Jul 2025 06:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354EB8E0001; Wed, 23 Jul 2025 06:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095668E0015; Wed, 23 Jul 2025 06:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E98878E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC980140658
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:37 +0000 (UTC)
X-FDA: 83695203354.13.D6AD9ED
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 16C36180002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hrwdmof8;
	spf=pass (imf06.hostedemail.com: domain of 3xr2AaAUKCI8Ctuutz77z4x.v75416DG-553Etv3.7Az@flex--tabba.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3xr2AaAUKCI8Ctuutz77z4x.v75416DG-553Etv3.7Az@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXopSo3A/Iyt2jZoa3DRKyyiuLot/i5BO7eQNmUe+bo=;
	b=Un6Vl16W7P8LRR3clHnjaGvCFnpoAFCsI4r2D6lJheyIAS0qNSOPllzMGYeNv1C4CGsXco
	kfnByXuVL8rt8Aj0ioJTEqO7YsFbfoIq8gUYUzBrWx3Oi7ex0NU5+FNNl9FPCV0oigHhL6
	LWid38ERS7mJZ3182AGh5FYCetaUumo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267656; a=rsa-sha256;
	cv=none;
	b=kRB/1HkduTCU4BjekmTqdIeoYF+p6KgEoAop2HBA9HZJoZwH5wdOGiYJ+raxI/9uyoEH6k
	3HLBtWPOKr1aJ9aRuyeadNsxZbZJYy4fkUn4o/carvMtdPy41XXasrYFIIoHQ3n5rNunGB
	KEpMywOKD7Q6+V1jV6bLVLn+GkBnTFU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hrwdmof8;
	spf=pass (imf06.hostedemail.com: domain of 3xr2AaAUKCI8Ctuutz77z4x.v75416DG-553Etv3.7Az@flex--tabba.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3xr2AaAUKCI8Ctuutz77z4x.v75416DG-553Etv3.7Az@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45867ac308dso4605675e9.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267655; x=1753872455; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nXopSo3A/Iyt2jZoa3DRKyyiuLot/i5BO7eQNmUe+bo=;
        b=hrwdmof8hY7o2EAG7W1lx53A9VKQpmn7TM6KPFw4zLrUFt/gtVjJk7jRlq77fT/9aE
         mTITJozPiq0JI4TuBZqI60mHm1JfxBhg7nRc0+nZKj0utip7A2O8nxuS5g0YhUaRMVI4
         2ts6iw5uUaCUGhfiP3LPo4D/PxW1ZHTuHEJQlXY2b0p+YfeOSH+IexrCCQKg+5mnYBSF
         WQUQcDYxm5A65n71UWBoIIzo1cXqQ9LReWhb9VPVoOdGXW3BgEZR7MfuPIQjLzuSXVqa
         0elqNUiUGGH+Ne1U8MnZoLEgSA6y6uu00isLzeMpk1bCufM7SisBp5hFl9o88aIHk13K
         UTJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267655; x=1753872455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nXopSo3A/Iyt2jZoa3DRKyyiuLot/i5BO7eQNmUe+bo=;
        b=vF8ZxHCZI36JVBwI/oSG/uA3Lfxj31/kT1jOeA9PZa3vysitaI3ZmesocZv+l5QUAa
         50za046ZhZ5DdPgamIGk0DGf45n0xrOJW5AveVbXyxNGRjk/ATAzRl6JozWloaQ6732h
         Q79Wz9KvkjIin9/CqCBQUD9veuHn7XUBlF9oUBbNKqZgVwdLaJX0IksSzknH8xT86gH7
         xhT74GDTbxZxqGAwIJ7dZTEkhf63IDYKoNQLFbOJYZwZb+0J8OdtnUEzrTFQNK4HhyDQ
         qs5NpYPEmeyA2HzS9xc96eAYryIz+/pUXgif6d6hpLpfIN/3ayN2hLzv8w7urSnZimOg
         Vhaw==
X-Forwarded-Encrypted: i=1; AJvYcCV2GYc7kQmMCmNYMb9WyXATPR6o0xyaEjF8nwsuYqOA9llWC5ip4qsATawXeEBUau1D6vfHwciH1A==@kvack.org
X-Gm-Message-State: AOJu0YyVm/qGD8FAzXeqpc4hY/dIpyQjOXXsbNJnZm4w420dmLPgupa6
	0Sj8j3gYFiapHmLlyNCvsT+uInFwBxm3XkB7iK1qJS8s6VCb6RZRULf8VGS5SwTMMiUquh6APUu
	bsQ==
X-Google-Smtp-Source: AGHT+IF7LN4zz7H7kl5hmHOJM2RWeLy8eWEca0zN52GnDIcb6JpxZKh2nX+K8PpdE1V0cGZIooZEsfLT5w==
X-Received: from wmbdv17.prod.google.com ([2002:a05:600c:6211:b0:442:ea0c:c453])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3107:b0:456:1752:2b44
 with SMTP id 5b1f17b1804b1-45868d2fe87mr17408105e9.23.1753267654654; Wed, 23
 Jul 2025 03:47:34 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:10 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-19-tabba@google.com>
Subject: [PATCH v16 18/22] KVM: arm64: nv: Handle VNCR_EL2-triggered faults
 backed by guest_memfd
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16C36180002
X-Stat-Signature: 59yqqpttqrhutqr9c1oucrj4xmu8fsz1
X-Rspam-User: 
X-HE-Tag: 1753267655-924601
X-HE-Meta: U2FsdGVkX19bOQJeVYrGmvCEvnJ5yqPpYUQHn/yd/CDFhKkd64++H8YKFfaWznVpO+v37VOtC6fxmDSoa3rFmg1om65DAL2FWpcafbRjl4yEa78E5LAWzRgJsRX6owbXg8QXBdlYVnsXwGopoteN6oWAsqdtsfbv9dQKVzRpa1f3zbRr/xaVrfOwX4irzaBTB2b3Wxh3PoZFC+JXVBS4NreASjJLw95pLrzeU6b18teY0Y2x7kUgxcgN2vGGi4kZJKkCSBkTgLBTthnIT/dueFyxeEkWCPHvcX0UCvbPti357SidyC8OeJYumz6wLaSgHL8bGs4JuPQnOGYtcHHbj0OshXNtwv2Xb9U1tRUX6FjJDSgns0A1ESl/1qpiehkKm+ph6uIo0/939lJOrnUwy1rK0zVsnME478ISgRk1POD65Ell3FvPZmbi04WJt689WAPeoigdHGsWbOa95E1stiNDdVDr9EWCUqGYDkUseIDD1GkeKGU8c6iUlPEgcq6U1mJkBuFO6YmPu1grKasvf/awDmXBHUvaxv5lRDgzCNYWnB/u/N4bl9tH2JEqdol5nb6E7bbtde1obgv2aOYHSfydJPXTPchR3PgjtI6h3pvBgQ6OHVyaVdsjymIEh0JLnlleMn5s7RTivqQHhbpOCntBEubgh2K2TgeEiETQforWCalNe9mc+aMxcoO36FDs5xpPRZ5qRKDc1+IfsTXFvb2K6x+tqVxZErogb3ffGsN2wrV3mbII7X5DAyeUK8S8IigB5p/D/HzDuh/Tzgz2BixQU5xfeMb8pdGjl127VXeMsBZGXGL8xobYCYwWj5h7nwJSrLCNszP9EgqzyNeW6Lr9hd8Q+1quGUAaQCVHhuyW/iD5ai7gJjFb6BEvNZVxSBEa7XexGdNkFBVUQy6VHznmXWO1XQc0xjMSZ1jHHdAuVdIspv837zCI6/ZTJFck55lKX1rl4u9wU4xvLON
 2mDbVXkT
 SVRcp3DpJglPPMJNKq07kzqXbi31nkLjtgwkpO8RtGpGe86F3qrCxM4CzUdFA1RgFQcibnUS+l5KYK2xp4qRSvt+4ttOaTZ4BTrNh41yrC2bRvTzD/MbLLZ6QUG4f4+0t0G0HPGo9E99j94VJaNmr/ljjT5MgD6FAFVYsV/Scu8FLukr9TLzDVp2EyCvRP4up178F3L/mwBLEF5+mF51sBUWPS+22gKf4Aa9iqHSVAUH2ef0b6dvwSvbJxXb318eTf0UTWjAi/9lWY8SDaNYZOFxuNHwax6q+/hK1Q1MS5OZAoBZziijdaKWiAZp1qibxAG6m8W9NPQDEv/T4m2058wzSZkvl690cQyjtuk1DWmm8MDU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Handle faults for memslots backed by guest_memfd in arm64 nested
virtualization triggered by VNCR_EL2.

* Introduce is_gmem output parameter to kvm_translate_vncr(), indicating
  whether the faulted memory slot is backed by guest_memfd.

* Dispatch faults backed by guest_memfd to kvm_gmem_get_pfn().

* Update kvm_handle_vncr_abort() to handle potential guest_memfd errors.
  Some of the guest_memfd errors need to be handled by userspace instead
  of attempting to (implicitly) retry by returning to the guest.

Suggested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/nested.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dc1d26559bfa..b3edd7f7c8cd 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1172,8 +1172,9 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
 	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
 }
 
-static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
+static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 {
+	struct kvm_memory_slot *memslot;
 	bool write_fault, writable;
 	unsigned long mmu_seq;
 	struct vncr_tlb *vt;
@@ -1216,10 +1217,25 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
 	smp_rmb();
 
 	gfn = vt->wr.pa >> PAGE_SHIFT;
-	pfn = kvm_faultin_pfn(vcpu, gfn, write_fault, &writable, &page);
-	if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!memslot)
 		return -EFAULT;
 
+	*is_gmem = kvm_slot_has_gmem(memslot);
+	if (!*is_gmem) {
+		pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
+					&writable, &page);
+		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
+			return -EFAULT;
+	} else {
+		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
+		if (ret) {
+			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
+					      write_fault, false, false);
+			return ret;
+		}
+	}
+
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
 		if (mmu_invalidate_retry(vcpu->kvm, mmu_seq))
 			return -EAGAIN;
@@ -1292,23 +1308,36 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 	if (esr_fsc_is_permission_fault(esr)) {
 		inject_vncr_perm(vcpu);
 	} else if (esr_fsc_is_translation_fault(esr)) {
-		bool valid;
+		bool valid, is_gmem = false;
 		int ret;
 
 		scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
 			valid = kvm_vncr_tlb_lookup(vcpu);
 
 		if (!valid)
-			ret = kvm_translate_vncr(vcpu);
+			ret = kvm_translate_vncr(vcpu, &is_gmem);
 		else
 			ret = -EPERM;
 
 		switch (ret) {
 		case -EAGAIN:
-		case -ENOMEM:
 			/* Let's try again... */
 			break;
+		case -ENOMEM:
+			/*
+			 * For guest_memfd, this indicates that it failed to
+			 * create a folio to back the memory. Inform userspace.
+			 */
+			if (is_gmem)
+				return 0;
+			/* Otherwise, let's try again... */
+			break;
 		case -EFAULT:
+		case -EIO:
+		case -EHWPOISON:
+			if (is_gmem)
+				return 0;
+			fallthrough;
 		case -EINVAL:
 		case -ENOENT:
 		case -EACCES:
-- 
2.50.1.470.g6ba607880d-goog


