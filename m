Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67615C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1828E0009; Wed, 23 Jul 2025 06:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C198E0001; Wed, 23 Jul 2025 06:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B436D8E0009; Wed, 23 Jul 2025 06:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 995578E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D6A7BA616
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:24 +0000 (UTC)
X-FDA: 83695202808.11.2C3439D
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 79609120009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oKYIqfWz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3ub2AaAUKCIIzghhgmuumrk.iusrot03-ssq1giq.uxm@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3ub2AaAUKCIIzghhgmuumrk.iusrot03-ssq1giq.uxm@flex--tabba.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/EfkVqSo0L6Rdk58U73h5TjcIQ3MjP9XCkSYx8G0ggk=;
	b=OSt91kPHHB48XrDF4Lswbj98MbOBqu7Zk48Q87a/kiER9Y4/spZVTSHTZiwNAB/KCQZ4NM
	fHvwVmatup8r0OMqGzKIaBMyClTXLo1yxqjrAwRQDd9SJLgdq9u0F78yUYSLXMmvwwjRlA
	jXx6e56RIosD/daCudg1bJK4yG0uJOg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267642; a=rsa-sha256;
	cv=none;
	b=NorH46nEDsq7KCBsXo5XSvWmwU43BSNwyqVhZQCHnhpg4R4FwOg7OoPR6a6cOFJ/PV0qLy
	z+PB9CgLT+XiskOZx9isNNYGPtrsbkaQ1ExmU9PlhfWW8oZ3k9eHIKjNSuILQLK8KPpzhN
	HCoFn8Sw2iuLmQ5yWTsFQGO7SKimWqw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oKYIqfWz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3ub2AaAUKCIIzghhgmuumrk.iusrot03-ssq1giq.uxm@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3ub2AaAUKCIIzghhgmuumrk.iusrot03-ssq1giq.uxm@flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4561611dc2aso57324625e9.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267641; x=1753872441; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/EfkVqSo0L6Rdk58U73h5TjcIQ3MjP9XCkSYx8G0ggk=;
        b=oKYIqfWzUd2iST3eIG+lj4hnzbHsN2nkuN+4OB6xsyuvK3ra+PYQ6dEOg+BEPSE8eU
         tSV84Hh/WVbwzhn8Wi16E1QN6wJZBB4SXDgjLC0AcmcjKMfJmuwekaYKBtWdxgaElfKi
         shpWyHIpfqP9WVIuGHWBhzYW7RvLMEHsBEZ29HYIj1LRlg3MXL0Mzvfj6FOi9CCz4Mtu
         S/zvK+GMVvJRwLRg5i14YUNCjJH/4Q4zokYkYRmsWqlezrIm8FOAvGQ9WCM/CSmENdB6
         a0IDxNwjDidSIJ8LZPZmFNtOuYCd0ejqJb5RMZU8x7O+qsDvDZVinW9WmWvOENT7SO5T
         xY7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267641; x=1753872441;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/EfkVqSo0L6Rdk58U73h5TjcIQ3MjP9XCkSYx8G0ggk=;
        b=pePwJ7IVzr7E9NLMu5Hg+cunkIe+bdy0hAhmgmgqOJwC85zjzg1pKtVvtONfHQscqj
         1Q6femlQZxwzqeV8o22O1vcQIzdItTn8MIkq5GuNtn+Vm9p/CS+hHRG0eSbP1mvWPyxg
         lTcQR5L/i63pM4PB47JsPwTozV+5VeqK9FQSsCZNAbbnDlQBMcFXubMSNwlczyWWV9OC
         S0nVckubSzfaLTGKR3r4n82fBB2Z+1kxbuTqZn56sJbvBfZThGfcpiqsLjhO76heu4J7
         h9AzM7isjrvONKM2YuvA7m89ak9tfYOiQw7pl5qGG3ikj0cOObDKkkoe3NL6bWnAEblk
         Jr9A==
X-Forwarded-Encrypted: i=1; AJvYcCW35Hlo24kZGrxhljRNN16bn/gMyrB7r4mwdLUrNz1P02Tuz+h+8tZfEXnALpoLiZeLV+oVjsBS+w==@kvack.org
X-Gm-Message-State: AOJu0Yy195tQs/I54DJ3u4ra6DfAbzvGETvTswq1zLNJzXEUkM7Ht+Z0
	Ww8UOoyv40wQeZ378gFiZfgidHIg4TqMHIcg4r5xAYUyRGXqrahN7kolhDDzuRZ4quFbbwJ22j3
	XhA==
X-Google-Smtp-Source: AGHT+IHbYm26Fr0SOOXc2m5vFYxAEfzMRdiV4s0vBHNenyrjREhBQuQ50qvhM897skkPfLicv6oO4tIntw==
X-Received: from wmbhh14.prod.google.com ([2002:a05:600c:530e:b0:455:76a8:b3a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e4e:b0:456:eab:633e
 with SMTP id 5b1f17b1804b1-45868d361a4mr22285285e9.17.1753267641083; Wed, 23
 Jul 2025 03:47:21 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:58 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-7-tabba@google.com>
Subject: [PATCH v16 06/22] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
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
X-Stat-Signature: be5e8ajzedmi4miqz5mzw1y3atu5h8ox
X-Rspamd-Queue-Id: 79609120009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753267642-641967
X-HE-Meta: U2FsdGVkX1/vSRdxFeqehRN4w5+3WHxr0o6Zon7rlDybRJLnRoVcXGBqZNpHs3KCg2cSTPsTHsBq6ckwSZwd0RsZad57QG1O7CD2qcEYny7d1EqM5HY3RAZaG5HUrXHz4pF3SaWBSE6HQisK5PUI6XGmPMOOSMr7AAIJJQhkzvbAkY10k/sdng1TJ6160vArvhV8CJivRGVHbchIh4Ocl/WYTflTeMmKI3I2ge4ik4k1f9r14XdiiBJntgsN/maW82CoJNNa5UX+50FE6kOvdkAneAreDMUX1u1ijhNH3ioaPR5QrLdCtJtZt6XuytRzHVh3v9umCj0jsjL8RUncLXHT9r2zboKA7DgxDQnCAue+Alah5FgQGMaXQp5PTvInvY9Cc+xiDe6bv9ZIMgdjk8eYbeISOGNe7x2SeqcEcf/ALhnNti80eHyyUEby9fZqzlivc/2lQUEjkahtsMXSKI91mUz3TBhnoZP02S7mLZQ3FMf+jo1OXBKV3lx07Fl9vqyXVs/mrUl//oSinJSJIiXYFA+Ns216kq2d6c99X+qpdFlKvIv5Q7/PtqpHnD1VuxuGiOTOp4hhcHe6sBjxNwJ6/ag+whe2zK0g3rD0aAKrvMB7FcGqTwnw2+3rN3YghjVRqQCBm4luxUV1Mj/QSoxUsmqX5baDM09ucX1RGZT8RsbF02YcIWjyXYjZe9tzfM/3oQCharDiBV3hmqjgCKEneJczP40M5LN1cZI7d9sykOLHUGEunH+Z/FLxARHgnzSfEzSQKmUVfzTegLK14zUXlSv0GYaOygN6ISkwTJXI2EF6+P6VDCKIcn9gVkoYq2OUSJFLfqI2A2/DkZUdB2scpbO+KYsv1/7haXczPrawzkx7NNOnf518uSA6yhJsfi3gWEpCrz/HqJ0AiQfbuhB1M7HTQrJ+9sNfQdtAHc17qkBkrNsJbBj06tVBr8NuzzA7EltJ7mHjhhqF/Zv
 xNdatPFG
 lHtfWFGdHeQLYWuuuBMHBe0XIrPZoik/KIW5k3HmeT+ri2wKTUEczu91ebfX5bInf2pVl+/DfbLOMC47A5tCh3KYCNkofu3HuB8L27hBieZzfopslgjniaGjqIzUxEV6hEJ/48RK9pL5fdwZfmkKGW/qPER1mrSDsdKugMsogFxn1GgYQs3noG13ZBKpK4D6brovE6BBVYldKjCmH7TikdPKWTVPwv5SnxIBpJfAqqSuMSmLdPdS4EkhyLunvp56zXAfcmJpBNitYbQlBnC9VZG2pxRjAUFRlL+aROKWtUjKs1HuHS0uLdNcENcgOqaPMLDdfUm6W3+oaDzH761OjhQUyFYaBH8HWpPfxkcVsxJpsOHOU41MWJmtKr9DjAI5CKvv7Sr9Bkq/7bqP0Ver0T1wszaYlApCC9E8SuDIPRRkk2N8EzuOUgow25EbaledVtxFOHb1aQI3TeO5v4RmJaWxMqEGFMgVnXakAAMMnP2hGb/JwlpNLCXWrZnpZwoY5at49lXK05WoqGfpeOPqY2NF6AWzuRTcFru4NFE3O3vTGm++rBsredYxsbao1yGioOj5v068nqfumALMiq6TGe2yeyWmIfQCoRmRyGuAcKrYB04yA2W0UiLoZMj5QRbFnwSmeRjA5cyMgNfC+xrOQsFdYmDjHgLtnICIReQsgT29E5vdNpP1g3gQwkYqLolqorWgTl3e6MlSJg6N2gQmpUsTu6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename kvm_slot_can_be_private() to kvm_slot_has_gmem() to improve
clarity and accurately reflect its purpose.

The function kvm_slot_can_be_private() was previously used to check if a
given kvm_memory_slot is backed by guest_memfd. However, its name
implied that the memory in such a slot was exclusively "private".

As guest_memfd support expands to include non-private memory (e.g.,
shared host mappings), it's important to remove this association. The
new name, kvm_slot_has_gmem(), states that the slot is backed by
guest_memfd without making assumptions about the memory's privacy
attributes.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 4 ++--
 arch/x86/kvm/svm/sev.c   | 4 ++--
 include/linux/kvm_host.h | 2 +-
 virt/kvm/guest_memfd.c   | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6e838cb6c9e1..fdc2824755ee 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3312,7 +3312,7 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	bool is_private = kvm_slot_can_be_private(slot) &&
+	bool is_private = kvm_slot_has_gmem(slot) &&
 			  kvm_mem_is_private(kvm, gfn);
 
 	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
@@ -4551,7 +4551,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 {
 	int max_order, r;
 
-	if (!kvm_slot_can_be_private(fault->slot)) {
+	if (!kvm_slot_has_gmem(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fbdebf79fbb..7744c210f947 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2365,7 +2365,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	mutex_lock(&kvm->slots_lock);
 
 	memslot = gfn_to_memslot(kvm, params.gfn_start);
-	if (!kvm_slot_can_be_private(memslot)) {
+	if (!kvm_slot_has_gmem(memslot)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4719,7 +4719,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	}
 
 	slot = gfn_to_memslot(kvm, gfn);
-	if (!kvm_slot_can_be_private(slot)) {
+	if (!kvm_slot_has_gmem(slot)) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-private slot for GPA 0x%llx\n",
 				    gpa);
 		return;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ddfb6cfe20a6..4c5e0a898652 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -615,7 +615,7 @@ struct kvm_memory_slot {
 #endif
 };
 
-static inline bool kvm_slot_can_be_private(const struct kvm_memory_slot *slot)
+static inline bool kvm_slot_has_gmem(const struct kvm_memory_slot *slot)
 {
 	return slot && (slot->flags & KVM_MEM_GUEST_MEMFD);
 }
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b2b50560e80e..a99e11b8b77f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -643,7 +643,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		return -EINVAL;
 
 	slot = gfn_to_memslot(kvm, start_gfn);
-	if (!kvm_slot_can_be_private(slot))
+	if (!kvm_slot_has_gmem(slot))
 		return -EINVAL;
 
 	file = kvm_gmem_get_file(slot);
-- 
2.50.1.470.g6ba607880d-goog


