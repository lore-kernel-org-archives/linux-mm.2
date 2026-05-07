Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EFC2CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63DDB6B00AD; Thu,  7 May 2026 16:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5793A6B00AE; Thu,  7 May 2026 16:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7066B00AF; Thu,  7 May 2026 16:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 306746B00AD
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E750DA0610
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:03 +0000 (UTC)
X-FDA: 84741747846.01.D64656A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B3F2A4000E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QJmU8C33;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185381;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5KgYNL+hdpL69l0XFSmxm8lOyU5dLbkmpYBCdACd180=;
	b=6g1oU3l71JH52VXsBguDfQynXm/RtQpDfmIRGleydDKH7SQJfh+uUa7D2Nd9JhfiG0kbNS
	7I+BFQxXW8tNSyzRCoKDmx5khYWMNYfzxwjbs07zTlPp6d6hrWt8uJWnC1esmnm1gxhluC
	0VdkB2pbkg6w6N/Ygw2P51vNoYHYXR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185381; a=rsa-sha256;
	cv=none;
	b=TzSeD6+XeW8nDmC1Q1nj8jIqiqKP2lkWKxfG6Crfdn3hk5r6Cx6OjkkhyyGhRTPCBNL5tK
	aTsI3DpDoUi5MajXnLxrj1duLhtBqhBCmzbdlsCgnzAy3iARJpPo7ta9nQDHp5z0QIY6Yr
	Kn/YxE0u8IFjYK/CfmO0n4duEFnFCA8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QJmU8C33;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2651A444EB;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7DE7C2BCF5;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185372;
	bh=p4qBfxGdAfMtaGGKStlHkSWVzxsaXmOgsRx/hRU32gc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QJmU8C333lVHmquMaqsdA7qgnBrs6VwS2qU1GXOpha9WlacXg7oXwkTVXM2ieSbQT
	 5qrIdVRDHC3keOOtb1YUNNC4YmobBlSTUvp/OEcsxEMKrJhEnivj3Ze/4ns9n6m75W
	 O4eLGMRnpBvBEqVtD5yRPZSbGr8x08SW1WISjDMb39JWKQPceI+XgcPW2Rtjb8n1s5
	 TRjap3CXsKh8/nJwtHlHlgMxcwabd5WhPj+wX8QdWEf59BQbjb66xxi2ba0KyQhBlr
	 7rVA9uevJHh9OY/DudbCN+2zEH/JrfCx7S1QJxFcGHJOreNI9RH4MgRGqE/YdvJ6tq
	 QvjZAYGiXxDgA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2398CD37A9;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:45 -0700
Subject: [PATCH v6 26/43] KVM: selftests: Add selftests global for guest
 memory attributes capability
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-26-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=2393;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=IJ9ygQg2i33wnaaQVE2Mc6MqL5xTgBpcwYj9G+DyWUc=;
 b=VeIaOFh0QRNAhx7ITZjihhQCCPoaq56XsfynZgfAf40728nb0JQWZ3qa791FOBSgVrLiHp3Sr
 Wqf2l87sWQqBA/pJ9RB1dMLcqLJrAdcw0v3vXSyeN9vO6E5r6VhfNQ8
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B3F2A4000E
X-Stat-Signature: nod9sf3pw7omnqo9ixardwcgdf6xfdz9
X-Rspam-User: 
X-HE-Tag: 1778185381-47122
X-HE-Meta: U2FsdGVkX1+xXhTb9ogLYtv0NFhJ3efP55hlIIC8zITCihbQcBDv28LK38wbN2v70OsYwb3pcCl7bG8FM0rXA0DO7tdxz/szohS17qZtEc+f7r9t5Z6fhHgsZpqQ0TvkQA+jJev6RJd91alKSHQq1w4LlcvhPUR/DqQKI+IIOpH38P0p2DehFlAeytv3dQxmhP9I9LGEsXQ/c9h3IjzQqNUAZNGs4vjDDlcRLDK1fTBaAH1UUO6op8YUQc99DTG/xcQLSxGdF8hDhiQKf/HUSbqTpSsHE0vh3PxFBqrZNIyQsNp7wo5sZMGwvDXjdf4yrj9ziIXhP2kZcOiU6CWoIpUdbbHteODnH32Lis+f4S1V3f5Bs5KOMzi351ogzA9pNP7JZ9Z3R/ndNBL8v8RJiDcpZQEhkMbgPhgvgenpiR5qPfHbYh+0mnLsGl33RYmNjaFztZUexpRc/9xRCCom+L+lyaU95QgSqoiV7vfIaNjjbi2+aXOWX6A3+92d77qjnpEhZUmVZ7Oux7n0FCz7KK+Ff9cWfGXnxfpHeg7sx7MmIcT5rvsa/bMR76VyIQb8vCnfp4CA3F7bCT51f8sRM+4/nt68oebiVLhd2C/uIzPbDR3xphEo+EDLRNws7bMFBtGCGCnXZtCRPHhorEyNeKVBhVcZAIOsYaSYAvv7dBfhvYvfbzvhBxdEMDR8xZX8tt02/hrHJZPHC9eD/pSu6q1SWbmJajymZu8hwwrZIyLllKJ64SMC2Jws022KPi7JBguUTkg0La9JwseWfK5VKzpanPZul54UFL05VWd1/2WtWxjiWuUD2xoiyqUiX3/UOLoTFun5rwx/9Pm7s01c4rOgC3bHJW98JZikxi66eujyPtpu1eZVWP391gerqAt0tWeNzMkQ4RcZbD10b2CFq/3+kJ8FIeChf6UC8EAT7BfeeZIxJAnrylIMZQ4QGKfKUzeGCgVq/PkMhc9aXL+
 Tf/ShYF6
 eS2e6+hMlJ/3mqV6vBlf2lC1VAPOqSeo20e2yA97CmJEXCyz5KaWfrgwyWdbD8QyY2domMPiLsLkKY26Yu56UjmtZ9qqiwkGh6Nr6AWyEoZWeSZjPm6Y3CpAdbjbPbGQp72Gy5Cx1fAb1Jr6J6Y9zOBl702EZnWAtfxE70+7GjORlmY1ASloB5pS+wlguv91VlQUFdfdaPbiDI/rK7lXkfIXqHZnl8bU/SrNrkZaATXUreY+F+lQ4sb0kyb5+74wkDCj/INLCbTDiqiT+IyOn85Suo66I5InaSaYO8T66WXQ2r10PBNlyUW9oJvC5IvSHuGkay9mKnNRJHJRnQoKJ1SxSCk8nsBUA953S5zBsRfDfGSpqX4WGDD8TbAHffvcGumPFbP/0O6KY96/uHfsWz15SrOdYdTguryOh7SBc7lmQHrSTHy5vTMMCK+7xHWXVVTdcoFjHwPsYeiB6oYMglokRxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add a global variable, kvm_has_gmem_attributes, to make the result of
checking for KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES available to all tests.

kvm_has_gmem_attributes is true if guest_memfd tracks memory attributes, as
opposed to VM-level tracking.

This global variable is synced to the guest for testing convenience, to
avoid introducing subtle bugs when host/guest state is desynced.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c      | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index d9b433b834f1b..c280c3233f502 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -115,6 +115,8 @@ struct guest_random_state {
 extern u32 guest_random_seed;
 extern struct guest_random_state guest_rng;
 
+extern bool kvm_has_gmem_attributes;
+
 struct guest_random_state new_guest_random_state(u32 seed);
 u32 guest_random_u32(struct guest_random_state *state);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ff301e7c22b2f..5e34593ad79c4 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -24,6 +24,8 @@ u32 guest_random_seed;
 struct guest_random_state guest_rng;
 static u32 last_guest_seed;
 
+bool kvm_has_gmem_attributes;
+
 static size_t vcpu_mmap_sz(void);
 
 int __open_path_or_exit(const char *path, int flags, const char *enoent_help)
@@ -521,6 +523,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 	}
 	guest_rng = new_guest_random_state(guest_random_seed);
 	sync_global_to_guest(vm, guest_rng);
+	sync_global_to_guest(vm, kvm_has_gmem_attributes);
 
 	kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
 
@@ -2287,6 +2290,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	guest_random_seed = last_guest_seed = random();
 	pr_info("Random seed: 0x%x\n", guest_random_seed);
 
+	kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
+
 	kvm_selftest_arch_init();
 }
 

-- 
2.54.0.563.g4f69b47b94-goog



