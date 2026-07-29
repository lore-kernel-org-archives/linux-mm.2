Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40FBFC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F001B6B00B0; Tue, 28 Jul 2026 20:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5036B00B1; Tue, 28 Jul 2026 20:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA01C6B00B2; Tue, 28 Jul 2026 20:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACD7B6B00B0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41C441403BD
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:19 +0000 (UTC)
X-FDA: 85039945158.23.9B59BE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4562040004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LBsykQjF;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285317;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qZz2jWNhMM9XdrPqbrs7ok2oT/WEPQShD9UKwdaADao=;
	b=Pc39zlf8dpdSTFt+DJnBU8NYoyANL9zDZZ/UOHUjS2+980xA1axPvzmzl4tX2QoC4uuEg9
	A8FOwBeIaBzCHtza7jScgqQYGrjsiUc2CRttTSUeeiiXy6EivAi9hsT3/DuI/GX9mU8SW9
	c+uoeDqm1jEVKiNKW3KCNo31iNE0Dao=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285317;
	b=t/Io/aoni6je30VlTl+yQWVK3pdbE+yBay/9s26/b9rhh0HDvLzUPP6Mbdj2LvsF5Zo7uP
	1eRUP6XuwbfW+7nrjgysCQDkwV6RkujqN3bzqFudOqhHCE1lsor3iMF9wqYa4u6cG+jnbl
	fFxX7xKH/xHt/vDpxZlk8K9EfIRU9gc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LBsykQjF;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5DD145224;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5AE27C4AF1D;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=0jBdj7Wd2DPWgi3/udC5FTxbDGqYPxdxx2SvSw/Cqfo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LBsykQjF+jL/nkCsCx2+jJ0d04kXFMQqMhK52FQjwZZjF10KbkdmDU5wBS9+mkYl9
	 Q8U5Uw4KLf2gwAQp+Kp0t6TUIv6ObVU8+p7WyGoonWLmW84h+5dQbZF70eNwWvMDwI
	 CnC1wOgQwtlwFQUhe6D+4VxxUGnkV2Em+YNk14WT+UvWhGOEKUAZCyTbIccj7a6QTs
	 WFWUH43BSu4kerbedY18tZD0nPpkpUA6bo/E0tdYiS2Q1KuEToAtg647MPODU+Z45f
	 SMs8tH8XlsglE29iEG55CCNYHK1oeN3ncWzBUhN9xAO6XdxT/cZNIpKTcQcDWRh+sd
	 RP8IU31pz/PAw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4096EC54F4D;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:18 -0700
Subject: [PATCH v9 19/41] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-19-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=1945;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=FJHG2a7vP7ngGINkS6BImiEDqifMvq5NVujuwFw/Bnc=;
 b=KiPvZAtHxx0L2xA3GgSZJl593QXMBoK10D9xBYODtqsEnwY9XY67wKNeQmL01EcqVctGzlHqE
 z3jl+hMYHPgD87QxZC1t8zx67zPaay6SYer4QVmCGvwTsBDSbLpf+/P
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4562040004
X-Stat-Signature: nunhshzt5n7zqmrofa6wwfm9ff8hbk1f
X-HE-Tag: 1785285317-741679
X-HE-Meta: U2FsdGVkX19luSMdYKTOWqF1hdAt1lrjeC0Qeu7fJ2zK5yIHUOonUSIKFw6LTyIlUoGolH9G123Zs0qS4Byiq99V5HRPXZVZZnF9nsgnS6bREPrk2OFT+CLF0yw+PS6tJaelQyBwQO5W0mDcxXkqILfgtkrlQ2N22yAx83VTscqB9xgWOCBIwTzNwuKEu4uqqB5QEt08qOVramQsjDk1Hq9PXbewEnE43oC3cFfAH2j0epw7ZjLlNqnxZ+ROnRDnkqPmsQI3MCX1N7ih2Hl0dguQ7E/HwEabcOlDj6gDSbVrR18iOGdjXA+0bMX8W0pMhy3MRioEnWqn7O2tioVSORsJQB7bVmE33zgvDKg/lrFscuRPLrSQrD/XWTjCisBvhL3hScHV9KWguj8fp6d+ZHYVoeG/9MDfffhwnc8IK/i3JMXvpK475AqXxQrO9UJpcF+AAg4kjbeSHVeVQCbEpnyvQfP8SKWDcDac+IwojXPxcteW9m/eTvs3iRaOv3LaT4uLnw+YFWO8fiv87UpIB3DQAyC3rlhFOWRfOp7FdUqDZLRB8ez9hNcLTPiAYf0ZDAsBo1lIvuIydRAAGDFyb3B7UDNiv39UJeY8b8D3GfB/eIXkKzzsTcdQSU9SEPI4u9a1LgxXaI+r1RkDCiTcuTP2NKKuEYKjV77hAgz8RTOuDZSS/LAZrN5sNY4I3q/B6wkYhVbL9rpmm5IPZfyyloyPe6jNP3gn3kQ9uO1wr9OZIZZnMmeFCaaxKFzrlex1PJkEJTonggfjV6HB05eWXeAH7ASnroM6FA8SlDnViYgqX2RKYIxJ3zed/bhyOZTdQYq/x6yRPgqiv4t7QDu+sdyS2hjtYg2mqQFKXsvCsmVJfkUP8oypYrYGLdqCwDHrXWZB3oS7aLOHDNXb9ty1E0eYecJxx6ej/n+mINhYQA3NtlCJEFBFwagpnQatAoZReONs9/2HnMMk0mD5O1y
 3B0MlWb4
 re4yfpA4Ny5ZO1zKpM11QFl0q60QtpPlCmM5lEQUpUEBt5sp3LkmlZlMNTSLXFLhW57j3sOGhQJHmAXJzFnJg8HfTGJ1cdEKzIMKpXBoNxw+eoN/zLLuGrIl0aTayl3PE8WUc+KxVNhDC4GvDe4B8GJPm7NyDVUgn/SgS27XxP92Dkn9zwYdRFolciTWsag/7GRGVd0pshAQix7GPte968b8zN3iUFMmKogZbUrqLgINJMFwL5qLnSnmDTmxvnnsECM47cfdJsqhGmryfTJat9kX5+pWjoHJr+YwpymD34RYTiULuRUtLwPaFAK1/Jd2C0ttEX01KG2Cl+YFAxcs2YO+rOB1vcFotqZpxU1eMQj1jK3EZXHUu8+d1a9f6d2tYsJSGuep/pBsOknifgCGkBP1TVto3Zd8W1ieeIRND5s6TBBabwpbO8vHParltgwBtpGiMiMflsPUFnhCxIH6mYNfNjZAqO6DoL5z7Fql9y1/l2RutUtn9Bagbcu78WoPTKLAnx1atvmdDe1o4CQpYjNEjUXLXYl14bm4I8GhhN50d0cMdfM3E/ESP4feKy7aQH2KfWo9317XiYd1f27KiChi4iA==
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
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
2.55.0.508.g3f0d502094-goog



