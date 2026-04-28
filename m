Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC085FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429436B00BC; Tue, 28 Apr 2026 19:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401666B00BD; Tue, 28 Apr 2026 19:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319686B00BE; Tue, 28 Apr 2026 19:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 205216B00BC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:27:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43780140D14
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:36 +0000 (UTC)
X-FDA: 84709548672.08.62CE1BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1BC5F20014
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LnWviBTQ;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418734;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bByB8Z4aWEkdjc2XcH3rSX6gFGeqc3CDK+Go1KD2PAk=;
	b=30czmv2nikXumm/wdRnlZ14/N5/9s88bvHv9k3+v76wf71NKscZgK6F6wzftYVmFKWQzbC
	sTYZ/h8BnY+gvPSp5rUyhFvTowayuAs/tTJzKD9D94xg0UNHrxkFu8JGy0+NY0JbtpukAo
	3+AL3orX4JhtzBrh9PDgLEccJsdb/Xo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LnWviBTQ;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418734; a=rsa-sha256;
	cv=none;
	b=A9m6htSbEJWUPUNyseCrxFVPl2pzXXORu6qPHaXRzULCPgRmd8TooqJkUTulzcej4Euq8/
	C7ZypkTCgT9GI5OYfFbHkfs3xtL2o8A5QOSEfQXxIG22ylElNM6obYQaIJgXD42vZmRO23
	h7f991kt1IfP5rp9ibHA2A4V0N9GbyA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 270D244AA6;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E19AFC2BCC9;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418720;
	bh=EiXf6DqQD5zsnxzrND8waxhcXvPTpKL8zj2zCcRqJ6Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LnWviBTQGjkDZ5UKjcZ8QOAmhjtMojkRLlTk7urUwb+I/Pu/GohXHADPThvvc9UAF
	 tMbt/qP/fq9y5dxGNATOvXIcDSGMTDXTuhwwQqOQK64YESERXs2bGRFp5269CqdsS3
	 eiwVVwn8UOe8qZGHwcIUvSvQ0y5LSyMNEyFez/hKZr/1r61V0pYB8+vHUwNE8zFLSR
	 m/IAPaa73Zq/Q4+I3EzhP0V59LM6N6q+3yizgPj4UeVwnlS3yRe0p7BNLHUCWb09iT
	 DNnjIM9pAT29GqPrC4A9hmR9pZq+LAfTqmeDyj5d6ldQSpPuqy/wm/7NQgoHQSriwq
	 7xXaycy8n+gAA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8725FF8877;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:27 -0700
Subject: [PATCH RFC v5 32/53] KVM: selftests: Add selftests global for
 guest memory attributes capability
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-32-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=2393;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=2uZTwd9pQETPqyenjKlFdMpmnrOuCmY+atU10nYWJ9E=;
 b=CMaZi1qcTo34olAF8ct+1XgvZcaQuemV2QFt9hlP3ghfeKhnQ//+kuPM3BpNu42zCM4/LlqwF
 dkfI+RbwmAPBA3KVsmD38J7HNp21dzxElcdQd2x9IXroc7aoac8NxaE
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BC5F20014
X-Rspamd-Server: rspam06
X-Stat-Signature: xr816znw5m5y91ytybgdt1hrua7zfsip
X-HE-Tag: 1777418733-661106
X-HE-Meta: U2FsdGVkX1/AYNEMFFs4iZjun96MoezubDGQs3kXTwV7uo6vgHH8r8bJ/kBmwAe/Vl/wa7e04Zffp/lVqit0vbfe0S+VweQ/gxWh4ciPsn4MITd7uxLc5vrgsP7ygmS5HoG2ON+7+R94d+FtauTsjnAn1aKBTCfO1wB/zN+LwKE2dHSuPETlikvto6Q5F81LBhYuHyesfGGGLf0E7FJaUMh5+yWi1pDb5Pb/rpaG7DP06Mlv4xOovrOeXAbT3rQPMd9jpUvmqEJGEiNii0i71vxiw0KoLp57lzgUA4dWb/Uv/E9W+1vWNR4mURGUCCiULBsHS6+6LZSYrcJgEE2/R0+hzDDbnt4Dj1fmryphd5nP7fyvdCSWtPpIElwotFzkXR0fLrAAcYbKkMX6DXfxFgMM3VfkGqDqeBI6bczEGbYA2hpzN2QexuyITUgNPQ+glhPZqp9HvMkOs2YEcm0hkH25yMM5JlXgWZbbReXn9iTkXkvQhkP3QrxbchJUorXhB9YbaWMmMIoD/rGZi0WjYem7m+u6qOdd1TeNaj7EMUDnXJ0Rhk01sHTgwgzccK8QB6iTv4DMCZWiUvLlnfHY9Mvf/vXVuFjg+1XdLM1EkC0ydMh6qHS9o4sZxAPpTmy3gq9crptP53sQBGCF7U6NZ8+FoRp/kOtwo2S2ZjBlp3C2Ej5+um1IrFIVX/BMiuP5Fv34JAh/lakOuZzZoA3mZA8nhjzwmgX6XFZWJsCGrJ2MA5amU7tZPeryuqkrwtwfZDIt0rI+gslLZyj/836QjKvluhShgxdAFdhLP+U1KmhGERb1OR0WcBsx7Ps1BRgxNqPhd0XT8ZUDm2aE/SPwTwNor0HP/O2wUG6TL1G6Qt49IKUQe5aS7O4JNfhjRFTFDE9Ul/O6f8JwJJrws2zHBgP0lrO1uZ+TDO2o78firuD6LG+Z3SRtadTEOXfArnNsiGaylJbrJgygKRFqTRh
 L37EYp0F
 y7ipBOzrBrtzaeVgdpcK9RdZNfoh2kESe8yASSb+U0pSmWorBbMHIw60OMI2VhIvYP99kklg+jWcNdbNu1G4IJ1oTmPTwxs6bqgUa6FPJC1rEGVowQr/tMu5Ra74hDFnXXGPDOFcVEwBluKjlH/tNCnWdBOCukr15+neWGdBz5/McO8ljhQMTpUEm2NytGJ3yPE99ZuQcQRBa121S93l8jMQXxPXHrR7VHWWVZpuMCe5qTwlBVB9kb9aYjgvb5waAM1gTB6gg++bxikx/aZMSHEqr+I6he56BAya4FMylMuje6jLbEwtVxKglZ9BnylseSQo6sD1UNTNtCG7pLcOvHRv73OV0ZIgwzdYRXVlGJLCq2+KWfGky8tDMsUYpcSJDbKXD+KqCM7qw5X76+9UBm6zc+hrgr94Al1eiCK+jJDDNpQpKKCoUDJnP7Jt4uxIVuhZE0T/97+tKbivaJMOLyFK0DA==
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
2.54.0.545.g6539524ca2-goog



