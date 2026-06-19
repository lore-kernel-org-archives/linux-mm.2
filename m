Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33ADACD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E1B26B00B6; Thu, 18 Jun 2026 20:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B99A6B00B7; Thu, 18 Jun 2026 20:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45AEB6B00B8; Thu, 18 Jun 2026 20:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E80E76B00B6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 545331202DC
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:02 +0000 (UTC)
X-FDA: 84894784884.21.FC04109
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 62DF120002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2xqz28G;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829120;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZPUna3BKzpjzVGHsIG+8AU87a667AEU3lxfv1ea1tE=;
	b=CEAusnecLAmWDK+xIUQaylrI4p0310zYJmlHB2FOe6Rq3jclsDJg6yZ8L6ObuvU+qEzFNa
	btZ4BNYr16OmGao83CDYpH+ZGjWjAZK1VY9tMWVquFZ8VTBtecaUryh7pgr1Q60k8BOC/z
	8AHlzBFpufOnOHXSUgrmLCc508drpR0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829120;
	b=eR5NIwpSrbo/Cwdwz1cgq+zr2UqlqxxGfNIsZYoob7+bGVMK8Y4Q01dQ9X0+m6tTgv3SsT
	/7H72boyoyKVXnJw/dE64yu26GT4jgzOYbnvSbTl71YhJ2osfBj52EP+X2KufaEuvAelQ0
	YrUhxkvXRWXid28cBocTEPjdVTbWoCI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2xqz28G;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0040D409EE;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C975BC2BCB0;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829109;
	bh=bJN+UFjKUl2OzBiITskwOW0VMnIK8KJ0ShzIAlJgpf8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=s2xqz28GPf+TMs+8Yl1fiMhRim2bWQwzdjvCNl3cqtQfFBzDK+7BRaB13e9k3IqOS
	 apcxNllsAY49m5ttigxFq13JtvbsrNuFbBGZOa3siWyA/F9dIgmnSFZQPOqQQ1gANC
	 lVC1VVnEAjxP8v+MmQh7JA4+0JBajCxVO47tSDK+z1qxNEQJ4nDs/sd8vSDtcyEp46
	 iu2R68od+1+DDKwxAfVoXTiCc8ZE6lYj5+T8C9oEDxIu0wfhAmTPb+p3aklgTJki1L
	 vhJusqOUf/whynokfLbApR/GWxWC7UAZ/SDVDdz+AuAXXaclwEOGwPVYLsHyvupMNL
	 prfJVZ2tzkdQw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAE9CDB463;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:06 -0700
Subject: [PATCH v8 29/46] KVM: selftests: Add selftests global for guest
 memory attributes capability
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-29-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=2397;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=7MS/3FsSTySm4s1PTqsvFp4qWJmf6Xu6PkzEjOtQzj8=;
 b=ERn7HZA9xYQyS0VygeCX8gsanAs6LdjljkhsA0uKfLDRgCVI8T2Ml9hiekN8jTDPj2CYq1YdL
 fD5G93Gx9FgBbnu3HPZ5vAUj/4wod/OSNkouTLTdHKasIwPx9LZ8WHm
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 62DF120002
X-Stat-Signature: ne1e1648cgtamwka46nuea19tt8s4zwe
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781829120-784894
X-HE-Meta: U2FsdGVkX18nn58RxaUZJmuOptKiADpx87nP1NxqukyVNZj6q6lokiDb/p+Ad6zKsE1UEN26A1MH4H+mJHScbE1jmsa6IXtQlF7OqzBMawF9icV0IZg57NniwleGem43+M3BaeUIAGjcriF5j5XwYyE+If7HyYW+KBKMgJl/KTu+y9wAJFXdLNzXOdI4IqMzf3LB4AyQoZs8AO95JS2u8J6lS/qq+QNNV15uYeO4B8PWmAWkV83kmvNF1qtk1MAcjFmenUfdK0MVoMvPl69ctL4B99vpm+C9/5wcfo0zJFalUUc84tKd/uwf/63dPq2nNkfGKbNJiPSz4YXl+QyV6cpVIqMS9PxI4VZWw93w3YNF9vlfALKocHdWbD3N057cucxh9kPHBWG4jrH5nwzvtWj4PG5690lMaI/Ni+4i5wL2Vdfvzi/IRSoompsODAxhqUNon3SY179MXTnGgS7HujfeFrn4yff2yMzjbw0TxA5Y4SolwpyJIVGy6mE5QECUftFtVlM4+onm3+Ixe51jymIzJoNcgzqMRA8Ukjx6SGsUiqcS+pwTSfvrub/h9E7LxoGXYgTLvWqM+3v/I/1P4eDcYY5EKG0D7g7CQjxQTVSlrk5VmiWz8HoxhEIbwzFlV0aYYBNk1yG3EMnQwDhbgfpQseeLzglrU0tRaDxIE6Lf3VzsmETUUuDj4h/3WvheM/my/9AkNeue+rquvRwgvGWPiXgTj/KPyha0gL9vwBfjRmKJG2YqghYWzhoCJEYZTyOXj6BIL6NQxMLOvPRpNSBY9/eSOK8Liwg1bDlbxMa/xb32Y311bUlafN8UYhMofv5tLt2138N02Otg6DpcrOxouPelJ1xKOV524UDTejfQm1EL5+4JGAhAb5TrymsBMaJ2rjlLzg+8sQvzu0KUCCiqz9S2YPexlAudwZXDWPFaKyPFoiPtja5nmxVOEqSodg3rTQwJLtY23Fu9lzC
 KCBnfGRc
 8biXXhwRz3/PC+Z0urXlzTLrYGgFe//dv6lVQKlwThdorgukcgma15UFy4YgO45+Uy1rjU6uFK1cNn4fYcs153UPsPFU/0OM/NfAv4lIkT90OPQ7VxtEEPnNxutUDeMFzpDK/Yd5t/zG0yI9GHg8+If24cfiDlKv4euHEUVjNeTp66Y8o8n4OonI1zmEATCosOy0bwRgrH+3p1QNKgg9WETGatObY8VwQwutv8gHRHUO4dlzJmRBU+HOpb+8GCjfhodrnA8HLJR6kD/dvLHx0JQthVm9vyMPfrEt/YBRy4xTamohdDCcP6CuxtT8liDpa63BWzCylgiklRzQhBuXnHiY5Db6VNgeZlHuACqsRxiIEdk4KdbxZ1D3uFw0JnjGX5OwIZmRclcn7pzQbB/EmncM3wVceH96+/KiO8SbfaT7hPoSWibwfOOUeoZQ8t/eUZP6JcQ+qpBavPDI=
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
index a56271c237ae9..51287fac8138a 100644
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
index d5bbc80b2bf1c..b73817f7bc803 100644
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
 
@@ -2286,6 +2289,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	guest_random_seed = last_guest_seed = random();
 	pr_info("Random seed: 0x%x\n", guest_random_seed);
 
+	kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
+
 	kvm_selftest_arch_init();
 }
 

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



