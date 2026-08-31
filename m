Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C61C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2B66B0099; Sun, 30 Aug 2026 20:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A41C6B009F; Sun, 30 Aug 2026 20:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA9D6B00A0; Sun, 30 Aug 2026 20:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B77E56B0099
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 177EAC0392
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:25 +0000 (UTC)
X-FDA: 85159670610.15.751194F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2EE3D20005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FlvNkwZe;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135923;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGR+X+sHJ+JOf45yLKl5jJHnB2lQfGl8OWoFqZXYNCM=;
	b=0TnhbiOjtmDz73c5U9hx/2awfl9HPX/4mRDdccVYcKpaN1nWQQbLhfZw7UGqQ2UURuZImr
	zHAOE9r01F5Xm3SB3PYaWf3BBScc67D7K8OXNlWvS7oo++okKd6Zq9jb2AzMspErJy2W/4
	0XNvXSVQNJaVW5EUsn0UHUNUIXh0FR4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135923;
	b=EX/NKmWV9oPaJzOAAEQ02p9XA9YiINFy8LqXelChtIhLki8P09bk++GZmM4crsvMaf4id7
	wMQuQ5edfyD3q+dEOkLIVv4j5KCd9OfqWnc7AXkG9NGSiJ12VuZrfx8Z359AnZYczWuLcd
	Jfa2B4Ebv1UNvxD7nlhtku3Y4Nwjb6s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FlvNkwZe;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C262E60202;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A81FC2BCC7;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135922;
	bh=a4uO0W/pGoQMRdSfY0gjr7ckE3bbyWjhBY1ZCgow1bY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FlvNkwZe/kou0Z6nlaSUIG9Njf8BCS1B2LllbA2DrlBxTwLPlV3/EpND8Y61zkBuO
	 OQbdKuqgkuR5Wr1xzBSfBQNKmDCY82e6zLamcuqPf62MLdxVggB4+fkyDwljrnPSdw
	 auyURwTzi0gmvVddR9rfGUFoDpG0j4rkUIZQt2Mka1+UcJeMEzqbuPjeuhEGIxPkqU
	 IMHNi1JWIRbhcg3eiT9ccmcIR2fhqSrudIxWHypa2SoAUM5/U2YnmyfL5HFg2yuRpC
	 qMi80c8BasGORuQJ2Xzds2UFs7xPSLf5nGxNEFAXj3QwPCOTNVtOkGEbZRN35QZp16
	 XNdd6ExYUgVZQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FDDC61DF1;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:29 -0700
Subject: [PATCH v12 28/45] KVM: selftests: Add selftests global for guest
 memory attributes capability
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-28-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=2380;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=dHYrti6WIKjQ1dgvMw4UrVKAOHIaicLWAJZOdnwzNRo=;
 b=KzmA7WFfRXK+LXae5PyPGG+GqegEtvr1HPmpjZT4XD1quEgpK87wCsvWyJBbU8jr8Cn7M8q4B
 Hdxr/I/Cz+sCpDZSxn3ftblb0bY/0WQRM5qX//OjyEOF3venXcUNAhm
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: ojxmr4z3surneyoxmt6b1rt3x16pw95u
X-Rspamd-Queue-Id: 2EE3D20005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135923-420556
X-HE-Meta: U2FsdGVkX181uvW14T2M90kQYH/u9rcqW3L1pReuwtImC4vyj4vjp3AJDA+TwK3xNfjGHNH5bauwAPXowC/L0kJ2cceO8DMfBpxyN0bXENgkqbVfnkvmPfq2yBa9QAe0PhOH4FYNbW/5ZqRnW/RSwlOwahJsfyxBjYrFd15InFKPtT4+mXVVd/TiKadCN/QRx1xMoBadSfhMtP+9xRTT0fcQWKfnNpJDgNggie5y+J6WqFelA1ezr/QqhHkZqI/qEfFibkcT5Zed030EzaAT5L1RjHrFWKi51GENXb8JyhbgB4cI73Rq1fW9OGgCBRh5Gc2vXxPPuqLXWC9XAVdp5+sCABjUd6jF8/GWhPYMPx4h1bWeKOM1q1poX6oHmAu2mGtY5IdaH+v3mJ55gNH+jhCv6bzudtYXHaU2MlbjQ4VjbEDNNlovQuJyR2W4uMNyswIESrTjTtszWyFipHIJZgmxbAjGFQ5q1qujngu+mwghd7fpyRpUvoOw8a2Nkd49YtRH0sq6rqMAsDVn//H4KUeaeo6AS6H65vlLYFNB1XjuzB2o/BvdNoPJgCoYyCm/vxC1Z9bxrmj4nZO9NXuLPanffGPAGoQk67lKCr5fCq0ONJMR0IdGBeC2SxiizAijbMMBb3/uFj1g0VMevd1WpLi07EjCFa62Lh4T0okd8uHuAd/dNiywKzdukqKPcS7DOBrmfSBu4yjDSWq3UNIDYIKkBEHcQR3Z0YgFqhilB6RZhf952To/LsUZEshsVyZW3ghQAoK1AFQrJuOwOe2qyyQVOu2eHEDgADfPkw/Abnfifnso26kD3o5tg01q8A1maSjpUtZDbPZwND24OCc5NIA/QkCKjvbesunCGxGQURJq2pIu941Fje7L+KQQfaDbvDd2xwxZkvI+CkvIGZ6FmawYIvGKCKViL3wSVkcNuQqsdRBfIcMLQbGLEXaGZamCL8MPfodwsBStdhI4UWU
 ws/7kdOO
 SbV5slDIPrOnkNVnCNON13IqCvJQQNZTKWJH0NRYhvWBQBgSw9K/e6aFv9NuVHH4sAg0IQ1BckxgxPzYC57fvTyvxXob3hcjH0zeKVep1V7Q3TztRnu/AmfbxOsjsBvBcBxm2H4TRXLHfbveHaCr5JmrSAm4YcVPlWGamhirG10bupGT3YoO0K62OKDd0a9k5HwcdQjHIdgfXgcV1NPYrQhX4oWDRPnvj2Fu2MbhZHISKaTs4ORZqC5trvhmdwV0CmzMaVlyl/KQdPMpN8mBQgTeiGnwCs0RHUCSsCleJGG+l8MDphAlhy8zbnyjGuWkrRPqhpWdaaydSwzc5eiKyztYkR2V91gGyJ49dd7Lwuy5liWw7iYvqaijdlyZnOSSShzM0CfKva9+M9WgN1YjEX1DKWr9WYB51aHnBDIqOaC6P4Jqa0H8uLwanHGo06zcqbAgUp8vYT/tVdw89HkmudE1gRPwSNI3OoYD9
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c      | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index a6a3e16578959..d5825211f2727 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -116,6 +116,8 @@ struct kvm_random_state {
 extern u32 kvm_random_seed;
 extern struct kvm_random_state kvm_rng;
 
+extern bool kvm_has_gmem_attributes;
+
 struct kvm_random_state new_kvm_random_state(u32 seed);
 u32 kvm_random_u32(struct kvm_random_state *state);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 08d0bbcd421ea..cd468b2bb8343 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -32,6 +32,8 @@ static void kvm_seed_rng(u32 seed)
 	kvm_rng = new_kvm_random_state(kvm_random_seed);
 }
 
+bool kvm_has_gmem_attributes;
+
 static size_t vcpu_mmap_sz(void);
 
 int __open_path_or_exit(const char *path, int flags, const char *enoent_help)
@@ -527,6 +529,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 		kvm_seed_rng(kvm_random_seed);
 
 	sync_global_to_guest(vm, kvm_rng);
+	sync_global_to_guest(vm, kvm_has_gmem_attributes);
 
 	kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
 
@@ -2311,6 +2314,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	srandom(time(0));
 	kvm_seed_rng(random());
 
+	kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
+
 	kvm_selftest_arch_init();
 }
 

-- 
2.55.0.897.gb25b4bd76c-goog



