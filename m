Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F065610AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735C56B0005; Thu, 26 Mar 2026 18:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70E1F6B00BC; Thu, 26 Mar 2026 18:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624E16B00BE; Thu, 26 Mar 2026 18:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4984A6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C96E160DC7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:11 +0000 (UTC)
X-FDA: 84589646022.08.337B86D
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id 32536C0010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l4E85I7p;
	spf=pass (imf10.hostedemail.com: domain of 3Q7LFaQsKCBQuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Q7LFaQsKCBQuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owzrYdfkye/YERaKc5lVrVSnV0ZRCiFrjdhCMOA3vqA=;
	b=WT1ChWzdArRFd/+8ZaSh/qGuOeYZf/d4Ok/TIqGE2czCsDljrL/tTcrRH49QMw+NChCboZ
	khEDlYePbDIH4z5kdMvSXtQV+UAVcuXupDbH/DNDpMi64nRzPG+DS1k9DbNt5eMn+YuQKb
	6kiWI1NhxKTpFf7KjObdLu+ZQVm7/Ag=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l4E85I7p;
	spf=pass (imf10.hostedemail.com: domain of 3Q7LFaQsKCBQuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Q7LFaQsKCBQuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563909; a=rsa-sha256;
	cv=none;
	b=0hU74u3kEPvdDw4ibF8+x2zkmQuesvjr2oEXvQ4UgO7oB69GcYbHqi8HjLdz7QSOSRTFOi
	vJzzA9ytsZXzFxjw9rjQ9Ox3D0uS36mnOozhktdnQhEq4/L32RyZloePitcdFrMxZHLtGP
	6sKqsiZ0n58WZpwvSarO1raDRBbz9uY=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35c10c2d890so2142639a91.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563908; x=1775168708; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=owzrYdfkye/YERaKc5lVrVSnV0ZRCiFrjdhCMOA3vqA=;
        b=l4E85I7p1MSSG5Xeu3GnyXp6QugtMg/kF2nH4baXuaTDeh+1V+L2U02G/qNIXSyjP1
         Al9mFpLHK4dFYW6EJT5O8MzQBKUCanD3f6pKeckYUj6cHVK2yb7iqiwPREm2DcqK5/IH
         KN0cSGzOXZdvT1Iba553Yhsm0UnMJ3t31qlNy0X5sOdTu/FCdRHa4zG5CDZ3l/CFr+J7
         yvYl6edoSjt+EZmQI0DOx68XNSdwWiY+SO9DWWkOnNe3w+E2Qlp/l43F6bwJEICGgGRk
         jAkkrnqsr6VkHuXrwcXAxFcUfbK3b7kzvq1vGloJXn1lNcqZoMc1/ZdwhW0skFXOOAxT
         gqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563908; x=1775168708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=owzrYdfkye/YERaKc5lVrVSnV0ZRCiFrjdhCMOA3vqA=;
        b=ibKS1NQNFfDeV3R7WH7EMblN31CqW4gjlkYMXP2zTQ9hIuco+Ct3MdaalRjN8H7pDi
         5jlBYnaA9TTbxZRCZijGzqfppMs8ksZo2zlgETe7FcqQ6cbU7UpR0joYNA38wnYAax59
         En4wKFgKC8GehVXbNjqQ5gyrlDtLfhOn48k1rsCPKNy4/TcC48IfJsL7OdYZBXpgAJ1G
         PWDxc4Ez4HhJjrTl452uXO3mGSzfPLLXIHusCdMc3BokrqTSvRc9ECsNu+ogjnpazZxe
         1ra2Rb82g7/l/hBWW/ToTkJ3LIJBB4eYTJfR7MTKgBLAJeG1avRIRlQP6doWnM4+FPiA
         wKCw==
X-Forwarded-Encrypted: i=1; AJvYcCWLgf9AAvjWc6G/ynLOCizAWVk4d+uoyzUSDT9UYQNgsNBH8bIU1wy9tp4sKvPVbAr+d5ljDuJi0Q==@kvack.org
X-Gm-Message-State: AOJu0Ywm3xGGyGHciQPn+aJ98RW4S1AnkY5hVZL+7lX5FnkCo2dmkXwQ
	0j/Lc+n6HNRAUIxrKn+y7/MTgnXBpPPfC4nKZ7qH2W0JDKTy6ydyYdlr3yhi5e6W5otiEwqlVd6
	fItAlDz7Sk9SY7yfwStI/nzni3g==
X-Received: from pjbil12.prod.google.com ([2002:a17:90b:164c:b0:35b:9d0e:7821])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:17cd:b0:35b:e594:503a with SMTP id 98e67ed59e1d1-35c2ffd0ebbmr200447a91.9.1774563907528;
 Thu, 26 Mar 2026 15:25:07 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:30 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=2424;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=SPrXtBzhAZ8kM/S0wIFvUys1KOsEIn60uKsPIVirly4=; b=Pb2Ke7FYWhiSBLICKGMsXf4XmOQ7g9IKaopuyp04/7PZlASOeNyYFutPu026ZSgYzfo3iSfAk
 84jt/X+M0iCCjjNze4tzM8Q5uhhhTW0IjXQ1s4Nh16h/Gz+oHiW+LZG
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-21-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 21/44] KVM: selftests: Add selftests global for guest
 memory attributes capability
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 32536C0010
X-Stat-Signature: xyexmn9qt1wxuanmieyzeptxhooe3hrm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774563908-90061
X-HE-Meta: U2FsdGVkX18J1xzKvR89UMc37V70qo5hs02Cb3KTrKaXeF4XfhR4v/n323Sh+4p8GFE4Rsq7qsB0bFzd0MVGQiW9rBG8RxDv48b+XZqIRoCHpSyZX8NMd/QdScYX3Q/5570PjP2bzm3Rx7XzPA8UaJ+/xYO+IsfpIzK8akhch67D2JlRSbhgTXzcfDl3bN/RvtZP+tABw10oC6kQJOxzLeMEA5Jy8GLCAIyC0Fv2Yy+bbBcb+4NfCCfKY7xjp+hHawgAp6TkDK7CYWYsyTeKDuD66DV6U/Aou1bgcW/yUXGe374Uin72KV9MCLEWGYS2LGO6VxC2pu2dStFgEOJPMUw7wWFdHeLZx4XGt2z5bLAH7hvIKBI2m/fNDeBFODvx4Q2uEVzQWR0qh0pNGEyL7a/OanfZjMXk+Fys9f+IIek2tdhz4WqMY4yTUZ1MDH7KfqQvd5MxI+tF7iGFHlt+oARX+Zsjytw+UNi5Dg4RkRGi5yCqVSXl0EzjJvahtrD5xulODX1HIiSUDH8cQlh7OKOh6HmlB8u1O+8BReVZ6HjGf+pkVOC+GEWudwfqTR/yhp8Ty4AvBRJ4VgP7NZNYNz0aOHLkkWHT3gvEZPcRRc/dKisM7zlUA8oWKgvkB6Y3pUpG3ccLWVc/BrdS6TDJPJMYUEwBIYcuJzodOcL1h1+Vihb+ci7WGWY8/LwJ8yN89WltjyfaN6r9MewKCBEwqCB/T34mgWS7c6sFB3LW4X7r8NUQZuRcLjNoLGhASPBV3hanmr8D+m1TMbHMWquMiXyr88rYejbkK07QtJruuY7sRbSHMJyarkYquyhXXV2knA3S914s+b7te/2xfgixLEypJWZ32pnF6iuCdeKGw0FU2riNpA5YZdggMuMt3XWZyxFkhZFynP+NgeoPBj1jbVoooQqBjDS9hw/rfMrh3i727IWJSBtrWy6UWKa0a/6HuiWZq4y0pzAs1eR25+r
 mg6h4j7i
 hbu/y52NLcronHwh2DBY/A3ELq7UgtywckySJk89Y7B8I00NzehAXcTAJGElBAiHdxMDBE3G1o84vscoNXOWydyykSCym9pM1zrlUmX1gNjDZ3WvOxmvq7TFZxvtAoepU2im92Fi9UL33fs9efCEVlfQH+od0RF0V2ROp0+5zg4ltVpLoUF2CQ6OVeUndcotD6yJcWMUp1Ceesp5Y8Q3Vdj5UEJ55qsZIiKLpkjx2VCAViHS7s8HKQGteKV0Sk+ZP1b7aIjxSIIviX+fMT/YSiE3fmXZ1QLRqlgRr0FZP2fnmJ5Tu+B1KsJmhllyx7EufmqDk/nKC9BP7gwrTNe0n9zT80fGU/gvxV6jpYnRiU/qH1VzrOGqoAGCNdz3Uuz29e7aDQviiKjoETFFenVyvMrIs7caVcLnk4c8DzNl3eyPAh0SaM2R9OVevUNGQIlVF3iIOMe05bHsfAmW4PTzZrdM/YVSR4+T795cZi1RewokEwQLUd4BOBk+u/XeHKkmQ7Ue6bkx2SghE8qK0FCcdRGPMmAKPyefXCYB3irDStZhwNnNM94wznE0nr7MpYBXROyy9pzmMTONa6nNVMlEE862ABfA2dVAe/+1HYMolYEyKyido/aMlAxqnApaBLFVxSI/iOJQdhNpo4efD5uvld36Ultlx2LEBBLYo
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
index b4872ba8ed124..2871a42928471 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -113,6 +113,8 @@ struct guest_random_state {
 extern uint32_t guest_random_seed;
 extern struct guest_random_state guest_rng;
 
+extern bool kvm_has_gmem_attributes;
+
 struct guest_random_state new_guest_random_state(uint32_t seed);
 uint32_t guest_random_u32(struct guest_random_state *state);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 82d6945efa29a..404efb5318f09 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -24,6 +24,8 @@ uint32_t guest_random_seed;
 struct guest_random_state guest_rng;
 static uint32_t last_guest_seed;
 
+bool kvm_has_gmem_attributes;
+
 static size_t vcpu_mmap_sz(void);
 
 int __open_path_or_exit(const char *path, int flags, const char *enoent_help)
@@ -521,6 +523,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 	}
 	guest_rng = new_guest_random_state(guest_random_seed);
 	sync_global_to_guest(vm, guest_rng);
+	sync_global_to_guest(vm, kvm_has_gmem_attributes);
 
 	kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
 
@@ -2365,6 +2368,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	guest_random_seed = last_guest_seed = random();
 	pr_info("Random seed: 0x%x\n", guest_random_seed);
 
+	kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
+
 	kvm_selftest_arch_init();
 }
 

-- 
2.53.0.1018.g2bb0e51243-goog


