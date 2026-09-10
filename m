Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D73C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32796B00C2; Thu, 10 Sep 2026 19:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD1F6B00C5; Thu, 10 Sep 2026 19:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8850E6B00C4; Thu, 10 Sep 2026 19:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0336B00C2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B87440606
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:48 +0000 (UTC)
X-FDA: 85199512776.19.ADA827A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 56E6714000E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=upCDQn6Y;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084546;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gudMaviZRilcEQWfNQR2w1jOw1KIMh1sEbwkNV49r3M=;
	b=r9qsAzrLeJIU7ucZz4W2rUJEVutdcJCXj5rDZFFnoC/Exk3dZk+zPFwflAqa6nMPMsSNGd
	xc7Qkrjrp1LfZGGmkzxJ2QufJL5fK4KALysoyUDwSUPpv5l//bk+AQ1DfiFcwsaiqk+O0h
	yvpsCCaxPy4FWdtG5axIlBfJ1ZuRd98=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=upCDQn6Y;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084546;
	b=BBUuvA/XiRMpZdpO6PfuPrtxcLmqEL0FN3XFlCCVrC8qQlEz1/27Q6cMPSh72F3aEG3KhJ
	/WtFiFM+XnFnc0V0Lc4iBc/4w8uevigzRKvpUw/rXNZtfJGTEFlUJUWwJvFxtJoz6lPfyb
	Iq2HLDkg6DWMPGt50KuBPYJn8BDqtQw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09E78447A6;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8B35C4AF18;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084538;
	bh=h7D/8Me8sGfm86q8bmgayrfPNsi8v6fyA6MB3KloRt8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=upCDQn6YYSciMdUVs/lh5z3KIM+OAn5p3TMK3QnQAW5t51mZv3YA10EiQiG8enj27
	 VUK+V9Pp1YGGcGpbCelMsbo4++HXZTPgVXiDziHTd5/3zncnyeWp7H70tojAVr7oz6
	 miPpf0S/p3uA/+yiujcD2rdCBeV6gcAl+TPf7GaLUadKHH//MQq87DixIHlmmlCPhH
	 eezyvlbwlAHhLlx2skLxXLv6cGuMndJIWiuRvyYbp5C+0JNqAKiyB4PswQBx64M+im
	 RcHhDqpRYi/QLyK2v3I0OcPcK4WeXFp4j2b22y7iX5PrX+OyP/rx9yLCHjOReS2HNy
	 HdKueLI+SA2UQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38EFC88E41;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:47 -0700
Subject: [PATCH v13 21/44] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-21-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=2003;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=y3cwX+3vXmgYUGfcRGwaNb/tJ4ixUshTbk+qybG1h/8=;
 b=SqwjPJSmbz47o8sihDUVjcircCakbfPtKeAkoXn53t1We2SX3axVFLwobN1RaCAQ9FSpLQAkH
 vsiNpB2dQtHD3rZ5dmBiEVywX7GHE/e8AFh1bzTyZmN6On8QtxjR5mx
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 56E6714000E
X-Stat-Signature: 8zo7m8dt4bbqb5i3xqab5id716m4d1fq
X-Rspam-User: 
X-HE-Tag: 1789084546-842964
X-HE-Meta: U2FsdGVkX18vQrRYp3gkHuYOfMYCbvgHvN/bX3wXF9XCWCIiEG5KBI7Gv2hMpQvCUtSi/suhWF6vr8qiNGwe9evxN132EamnZ9EquWaUj9n5VIPKwfgmLbdJlf93jKWNAOHi+di12W5YfG9wzQNest4o6FF2ZIZ9qZUU0RumO7rH5xeZKAo3sjRCre9TFsaspuxU9yVQqBNQ08LJW9lk6BdvDE6bxE26pFpV9GJZtUZ4lzK0WHv7h/PuhQgpIkmmYChplVRIRaUmiBI+BatNSJ9lJLcVdFGe6ZTRbVlYio5Z1wex3216TvhYPG+GEK4gWJJRhNSIUbQB2dPR/LzooRjFsRmCJJL3T1c181jJWncVULK/a4nCeFE8LElgFs0pJMnuVjfUTZ5Dr97URHjJyorg+mTyRmRGUtbYMkDX+gBdpazqH3/3IvTyHj84yBkRadNq4TRgpnfeS1P3Ctz16g+aY/5KZBRySqLtPCOV8m0RDFV7aavq9o68RN3R5vxzKwXWW3BsrVbsJSPIFDSoKFRXRth3Cb0ocbk+Fo9q/xSoZ09oNnCxauV1YmjJnWmNFEo0mBQ0F91Fdc2agru7BlR01hoqp2a4FMnpmJuBtmNaNs5O+/Ho+oCS+yd3ZQ7+cyq+1JmLzfLSvOdpV4RIfiuMxCGFUa8qOwDdAgVOUrqTuhtWDoGYznjahZzZYPY2GxofQ5+yX5U59jh8Aug1dr1tUCwCl4mkG1T1wuvBYEBqhgRG57rzG4HZ8ntjNkVZiFgl+PLTlNmNj6vq8AZ4bVqYpHJPUEFO8qmsTWQgu4mqocU0f+ZsdD9s/sfmIAHm1rF5+6+jPllC56erSEQk8MQlri6rA4mfS5FwXO9IgcUo/bXH1EXVk33tq2AR/hE8JPvOQOTldPeqgwRbxRYDbIqkHwduf4HW4sUq3x+SgqZso2imwtJW+lj6Zg5rgCMIHicvfg0lTEGs8CKkr3H
 frIrK4F0
 r0OMMcg7zSFBLXM3e78E7kBn0UAG4T/fzW92fzyFtRaq9tJnlJpCvNr2uZZ1p/Nd+d/qxm+1B1f7Vs1/yHJhHRYszjs2bR3Bzqi3ZZH2dRs7lV4CxUEf0msKouTeLnd0omaTdAEFCxcFpZ5Y9A22eCtV1xlYquyDLkHLzDMLTeds53kZEuVavlPg1XLHn06gMo5CYZ3SjOBMt9KrFq1H8Jg5nuWOLijVWx52hBaEGQwMR3eaVVCAdygHEKxMl+10x7UOlggxUNeZvRmN8hWDRGJtEo3n0oDC5Ft35Wy2OPWHZaut7qC39g97Kqy5Xu2KsIprUwkgHbAi79/gE0zVGGPXu774zsPNqMo7LnmFzbqaMCSblMHTQCQoXfODLrznTnyWQkaYUpEr2G9B7n2nij57w/zyIx0obbT9QMfN8BHEOSXbEHwcegm7ScEHFgDNT7N3iE/7xUdeqXOlx6EU/qlNh1gzzTi+4UUMKuPBKhRUAkDQnQnG5qio25GD+2vzvlJcbDS3yMsi3dXWNAANibkkhzIXkHkoGuhNo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Bury KVM_VM_MEMORY_ATTRIBUTES in x86 to discourage other architectures
from adding support for per-VM memory attributes, because tracking private
vs. shared memory on a per-VM basis is now deprecated in favor of tracking
on a per-guest_memfd basis, and while RWX memory attributes are on the
horizon, they too are expected to be x86-only.

This will also allow modifying KVM_VM_MEMORY_ATTRIBUTES to be
user-selectable (in x86) without creating weirdness in KVM's Kconfigs.
Now that guest_memfd supports in-place conversions, it's entirely possible
to run x86 CoCo VMs without support for KVM_VM_MEMORY_ATTRIBUTES.

Leave the code itself in common KVM so that it's trivial to undo this
change if new per-VM attributes do come along.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/x86/kvm/Kconfig | 3 +++
 virt/kvm/Kconfig     | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2f8e1b5a8a72c..abb108886733a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -80,6 +80,9 @@ config KVM_WERROR
 
 	  If in doubt, say "N".
 
+config KVM_VM_MEMORY_ATTRIBUTES
+	bool
+
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index df575449d97b5..a0678ef8ee3f5 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -100,9 +100,6 @@ config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
 config KVM_MMU_LOCKLESS_AGING
        bool
 
-config KVM_VM_MEMORY_ATTRIBUTES
-       bool
-
 config KVM_GUEST_MEMFD
        select XARRAY_MULTI
        bool

-- 
2.55.0.1007.g17ff1f9808-goog



