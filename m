Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25803C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E5C6B00CC; Wed, 26 Aug 2026 05:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8266B00CD; Wed, 26 Aug 2026 05:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581046B00CE; Wed, 26 Aug 2026 05:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2496A6B00CC
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D9A5A02E6
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:24 +0000 (UTC)
X-FDA: 85142872248.15.31FAC8D
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf27.hostedemail.com (Postfix) with ESMTP id 93C964000D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XyI6ph6t;
	spf=pass (imf27.hostedemail.com: domain of 3mK-OagsKCI0rt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3mK-OagsKCI0rt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXWpWryZ0kD4G5nvWBMzBSxCtH4Le24D342gsqcLpvE=;
	b=6Qx3uRIUffDRSHvHwrGX/3Lm8yoCVaNpmcr1CNhxixZ14X1F7WVSBV2CBYyj6LYfqbr5KV
	aJCDXhqsmXGOL/8+keaGSK5QR05EKf3rTTDvCe7n/cj6HhuZih4S7tPi7lhl76K18hVJXI
	yHw60elJaxwyuHbpj4u4j/FGlEhoK50=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XyI6ph6t;
	spf=pass (imf27.hostedemail.com: domain of 3mK-OagsKCI0rt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3mK-OagsKCI0rt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735962;
	b=SJ6cHZpZUsnXH99v+ZWrJ0GUeqDOYfj2mW+D4fyngAd6yX/Ux5MVeTdRvHuAVJqKhpjIJb
	MJRvPmRztzmGAz4bdpNYH0RPbxNdEgci7ZfFedEDfb9cIGglxldLeLrj7jvt8Po6e38iQJ
	Rh63HVua8m0npjFJ9a8Bov0KnUtMiBs=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d6df0a1e18so9996055ad.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735961; x=1788340761; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AXWpWryZ0kD4G5nvWBMzBSxCtH4Le24D342gsqcLpvE=;
        b=XyI6ph6tidM1G53LEfvkL5NvQ1lszfh2Me7/G+XlVGnqePYEdx+jUSEAKbZI6YAV8h
         51WMamkL1Lp8FJMbq+FnuXGfymrDP+VDb2sV2DnZuF5fRkuduSV5vDdzoTk+KYuYrMDz
         xnuRUTcXQceNooE+OmZVcXW7PBdAUU8jH8Vyd3h9laCD047YBvU/CeDAOKsofRmXB3yc
         x+hEFQ7OY3l7oblewzpUDrY1mGh0wjWxRAsfhhz7Qk/qKEcw5W4VgEH0L6dVSvI6OWYh
         0LcwuzcQ64cGD+db/AR5OBug41l/mI7ZFoA+1LM2sqRBBcM/v95/ZpF4Wc6PLh6Tn4Y3
         iAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735961; x=1788340761;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AXWpWryZ0kD4G5nvWBMzBSxCtH4Le24D342gsqcLpvE=;
        b=LeR8GZHI9Ftfh00BnVPOWJdcxgWLX0f81tqh+29TOQPfv2hiVF1lMDPsrkN+uQ2+UU
         70EItneKwz+1F5DnldZBBVNTivqiBGnGMQl+Py1W2lhzL3BFkAX7IX2KDuLU1N3zzyMj
         jjl1AwrsahFbGWBISIvutSTlOxTtMNoIKKZS4lQfopGapHneMdpzOKeMjrKOlNMPbpua
         sD7aUzo4f99r8l7Hc0cRfO6LpPnHFyQOKjC8+ZWm+lsVr9Nhqdyiuoj8newWt4sqlUCr
         Q+VIHmzXrMms6Z6J2AcVNxBc7Az1PfghjEQvQvPKMbnJS8v8mAl8MV/5ks2BrTA37BOU
         0L0g==
X-Forwarded-Encrypted: i=1; AHgh+RqWzxkNQ+xNNBiw21JDxppH6M5mhS6yLtWQvo+H7A4FnU9+neq1E5xsdDkWOBUhzUjk+z2GRHM0Qg==@kvack.org
X-Gm-Message-State: AFuF++kN2KW+gXv2xYSOVB2w8vDrQfVpooA/13txFISoTS0jgSRCZqvv
	0RkiPddvKYd7oIGj5K0Zho5DX5ruqKN0HoXLFbX2OCGTAGoxBHUV2UtZ8Qecb35vPyUFl2I96UC
	u1XIweVmSn4GhnMTP8EsI4W38JQ==
X-Received: from plda6.prod.google.com ([2002:a17:902:ee86:b0:2d6:6745:22e7])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:22ca:b0:2d6:fd55:3a9d with SMTP id d9443c01a7336-2d707a55a21mr87469675ad.3.1787735960956;
 Wed, 26 Aug 2026 02:19:20 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:41 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=2538;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Fuuvvm9TGdHzuyGqmCG/7y25PwPAioa9a5TcO7RLGpo=; b=+J4GD33/HdpdrEFr5MrH+KM1LHa2vckCr8RaWwO2SO5eEYH0A5e7TGCzVEy+C6S/XAfzoI+YF
 gewtvjSJTvnBccflyC8pq4jmTvD+cMIRcYwK2FB6Bp6gHJiHCOw27HK
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-43-0a15d8a799aa@google.com>
Subject: [PATCH v11 43/46] KVM: selftests: Support guest_memfd attributes in private_mem_conversions_test
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
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 5i8n4jbdujugis86r5cagikhw7ndxpg5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93C964000D
X-Rspam-User: 
X-HE-Tag: 1787735962-230284
X-HE-Meta: U2FsdGVkX1+/0AYMWEtJURtoRsOlJm7FaeTXWQ3OaiKT9moqAh1BEO/HD0MUYfEE+nfFeCkfbJZwKKoWqah1CH2wTqbmWZBtl/qRsZ4NiEmfFL0yEtrZh+aSMnw10w6n88whqwb+DRp8U/s0g9i+3Yu3lMQgUAVJGfMHIu0K4NfKhLxIHxOXtUyUMG+19+6SEriUWL8KoFI/uguUqw2J4E9IU+M+gwOUE0lNCE8Lwp/vFFNMcKswXrDib+fWeD4b2YfQw2qU0N6DA1x9oX07VY4EitOA+zJkZg6NqFxQe1wTgd2f+d5stnQtWeNbiHyUDcAWDSof3GcblJjljRFnohzYD8oubGEuZl3WVJvYf7qOrZUY5onpkFSbQGpQQ9iKwfVRo2oKgbij2jqUFdpRuEAn5DhAuAkJS3C153EBnSsJP1jlJsYdjYleJJmrYaJ2iagQljZVXpvVXcS9aJQyzyHX8Fej/4gHaqlNlR0wKKHIBbBsluZDCoIfpqtLuDI0pG+46JuLYlNFUssMya+JJEkCPFbQ2E6d2hekdsOe6t4PB48yp4F8etB/11S0EcfFHdZFfslZErvJBkYuGonZ/ur7aiH0sMKK9PhQhA2oSzO3ydYWlxCi16dOTvvkL7f6ET3UhM8tdDyyS2FxhSa9StLqbErdiK7MzaDRO5ndjlKiLK67RAvU0MbX1nDIolLrOY9yXiYQAvFSSm5GFk9BiARFKD3UzamuWaVVO803waBcKxQvHO7OEs5ujgUns8rJw3BcxaBLhy9UWIIYhaJXNfQMz2/vmWzdzfo9o9+ZZGGmOlZ30QBskx9Ve3F3FnkNUUoQicf6XF+Si0yQBZzB5J10tdj6ZuWaGtTQP9LtUF/KtIuf1gbLZ3Kq1Tm88fxGZwYi8Rl+og8GgkKHndVLd6fJa7Hz2WIWq6RpPIEdho924KN56eeDjRAroQuwyt5aSKX0IGuvzife1/3ixow
 MOWEuQ9s
 Ts/afKNYtge/6zVkgkJB+U30uhzP3iXKYuMhURxz9DmHNMNQgjE+MIUt4eGzowdIBDGwD8mMpKgOQ4o/iKe/SKPnH5iAR+kPifckI+/9wiLz9tb5tlQ/pSUHsNB2GYDi53fEnUR6zpjaEGC/s7LW67y6RtuenxUv48LaiOXjc6fFc8fHgHYHe7d8XsqFDmaFlMnbonELX37kmmtW40iOzKt34sXholCWtEo7xhTpf7YUNSTDK4svwIBHvmyvJ5dbkshMtrq3bjxnf0mXE7vVatDxkLTpGEAglQMWjMkA2DiLqzDe597tVoy2dFfNiEbnSEZhrfGmFes9PI3VgTDfeA2E857D3+cVXOQCgzuWkvXKbtgPPAaoDywiVXXhPoXymvkbh+hkWMDcYD+jlKAR+5mlMYuemMfdFe71ip5Z2Cc3MKgx5Ai85n+/GdMxHOHAw0sF5npMhsLRF8ME7ys1+3a6IgOudRKZAEak9t/Po6TbAfxm41AqNAI439TxAWNwH3zuuSiUhWhWO48xN8YcTaum+Ryyx48gCYWgOJyHmAuc37vcoa1wDn2Lx4txEtgb3jCKg0QNU3GYugjE2QiyUs2pi2r4i2Dn9YlgF71RFTOsF8cfQALv9BLYkYJhiPS+0J2sBk+TmuWITHkPMoR5hBX2O8DHHMYU7YDwokQjopvIFZXtnfk32prpnnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update private_mem_conversions_test to support environments where
guest_memfd tracks memory attributes.

At guest_memfd setup time, initialize the guest_memfd as shared to align
with how memory would default to shared when shared/private state was
tracked at the VM level.

When handling a hypercall to set attributes, use
vm_mem_set_memory_attributes() to send the ioctl to the guest_memfd instead
of the VM.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/private_mem_conversions_test.c   | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index cf50e9a332c5b..0c94e36575a5e 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -306,9 +306,12 @@ static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
 	if (do_fallocate)
 		vm_guest_mem_fallocate(vm, gpa, size, map_shared);
 
-	if (set_attributes)
-		vm_set_memory_attributes(vm, gpa, size,
-					 map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE);
+	if (set_attributes) {
+		u64 attrs = map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
+
+		vm_mem_set_memory_attributes(vm, gpa, size, attrs);
+	}
+
 	run->hypercall.ret = 0;
 }
 
@@ -383,6 +386,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	pthread_t threads[KVM_MAX_VCPUS];
 	struct kvm_vm *vm;
+	u64 gmem_flags;
 	int memfd, i;
 
 	const struct vm_shape shape = {
@@ -397,12 +401,16 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));
 
-	memfd = vm_create_guest_memfd(vm, memfd_size, 0);
+	gmem_flags = 0;
+	if (kvm_has_gmem_attributes)
+		gmem_flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+
+	memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
 
 	for (i = 0; i < nr_memslots; i++)
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
 			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
-			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
+			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, gmem_flags);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		gpa_t gpa =  BASE_DATA_GPA + i * per_cpu_size;

-- 
2.55.0.887.g758fc8c411-goog


