Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995F1C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F086B00B3; Wed, 26 Aug 2026 05:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C02F6B00B4; Wed, 26 Aug 2026 05:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187A36B00B5; Wed, 26 Aug 2026 05:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E38F86B00B3
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 764D44031C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:48 +0000 (UTC)
X-FDA: 85142870736.10.AD1FE23
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf10.hostedemail.com (Postfix) with ESMTP id A00A8C000B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N59T8fHe;
	spf=pass (imf10.hostedemail.com: domain of 3dK-OagsKCGkHJRLYSLfaUNNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3dK-OagsKCGkHJRLYSLfaUNNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735926;
	b=ufll1IXwSauC9ti1d2tq625iCLdmNQ9fl6pGJ32wPSvyGE/+AMOq07N/qqHq8BJxq+RTTc
	LUJPeJzdj1oyxwWyMhT5+2FEH/11Vjn8Fd3fbrQFPXdnh07HjF59mhysDptIVqXXyo+UIZ
	ytUcNC5c1mQznlYNyP4jb2acYPn/ss4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N59T8fHe;
	spf=pass (imf10.hostedemail.com: domain of 3dK-OagsKCGkHJRLYSLfaUNNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3dK-OagsKCGkHJRLYSLfaUNNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1PoPcctCxCU9xeD6IUV2UNVUEFjzWLV4ASul8wcFVUE=;
	b=NZRc8Bl4bPbHdyc0mb+zm+dIHA58vYcZsjv1nm88ZHxr8lwag6lWCMXbt/pHiKHvwmQ73o
	4p6Q4p6YBnG7zXvjDC45JxIuWclLGJl/PVjqScDWoR/O20y9C4qtTEDP1ofoyihUNH1ysf
	7QcRIzkioGA5Mu1iguGRek6Z690jS7I=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d55d8cd938so15036485ad.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735925; x=1788340725; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1PoPcctCxCU9xeD6IUV2UNVUEFjzWLV4ASul8wcFVUE=;
        b=N59T8fHeoMMrMsY8lCy3uscb6gtTpwGjZq71tlR7i6/mOg1yduUMELwS/4XS1Tb8my
         544xTURUF4ZXXO2d0+8ZZR/DiNVKs6eaMarFbKDSz1hUefysT4GiBd/YxH6bNLE8sGwD
         vSZ0uPuEMTm8pNQmD5RGkg8JS2V5kt4TBUcL3AiFVvIg0cg1d2nNx5lN/6uNFSjUASav
         xnJfMcxwOqnkQmyVl+NqFUM0mAkEX5tIPdDoyeIvd+xcKIW4Rck6TlFsH4w1WBBLdwmt
         1nF2Tcgvx4ht3HSisIS/B1E8fhy8L9uKivdEotn7g4oI8srzl7z83henXlKT1W1lPTHS
         YrnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735925; x=1788340725;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1PoPcctCxCU9xeD6IUV2UNVUEFjzWLV4ASul8wcFVUE=;
        b=gx45Dv0nFjr2cd6y02Q60WJqm5w1oY4r94k4VXxu3FlRTkLB4peFMuHWSEfDYJ7d8K
         Vf7Lgo33oiC72Kf936w81KMtGUfygkfo2Ktwy5aihVWOh5B/Vgi8/aY9PBEIRlJDrMAo
         NMHYH3H3Li8GtUeZXYEZt4W/GX7gIk76oLDfL2HQTiP97DSsogDScVYQA5ZMw2ahN1iW
         /9uW7qLpZCoYs4JfvDce9AiDHQ9+WTTUmnKi0Ge0io1H4Ap611lkkXy3m0hbv01EErBL
         I5uq1Pfy+Jf/o/5dY+df/c2AvrWxeCmmNVegJc416hhSCx8IKs8F4e5vp8ZoE/CVLOW3
         2eUQ==
X-Forwarded-Encrypted: i=1; AHgh+RqISMC5Pof5ERi+r2wrbDkOuAEbKHWBDeXdKWhsZBzlqIoFXXjOJQf490vaNZ50udn0iczuo7QcxQ==@kvack.org
X-Gm-Message-State: AFuF++n1NAB+JurGXd5Iwn5SZ6F80n4fX5wZ3/9v1DX1IC1RBeEhxLzV
	ox5AVIVtC2Mol2Z9f53iR6CUXVm4WgHCZjGkEkP7HWlHY+LZhRekP+LvZHspZlhHqQFkHu1nHXv
	0/XyZadHh9qRl5D2i5p4mAM0YtQ==
X-Received: from plri12.prod.google.com ([2002:a17:903:32cc:b0:2cc:7709:3bc8])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1a45:b0:2cc:d6de:d597 with SMTP id d9443c01a7336-2d707a9fecbmr93422125ad.7.1787735924909;
 Wed, 26 Aug 2026 02:18:44 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:20 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=2002;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=5+fsxDOXBXvxtjSmr4LTesZGOQ7aAAqTF+3X7TBXdZA=; b=Rx5ixHeP0JEHh6BXcEuohPdB+7Rs9tkd/Cq94uHcIXinftxcsawhYkswrSTC+BPLDcx78kRwU
 vASNv9iu4SlANU6cEaBK5QarVqaCef2nf28MCtJrwSE8k7ohH/iAF11
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-22-0a15d8a799aa@google.com>
Subject: [PATCH v11 22/46] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
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
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A00A8C000B
X-Stat-Signature: uwgj44ykzhszczrbucwsojkwq7prs6ih
X-HE-Tag: 1787735926-479096
X-HE-Meta: U2FsdGVkX1/TEtSXiXomxDFzIVTMmA9pf9EpkfCsqhCsDEprKnyAQy/TxYlku1Stlvuhqu9iTMLmcN/bh9JBdF3Mewv36TsHEIPZF6qbyTn97iVzORVdsht9fM6Id6Im+KgQhC4iugdTP5joE+roUt3REkSwee3+ZX2ws2IBV4lM0Apo2SfUvrzg+JXsXniHY6teFiaqUF25eyi4Ml3DoR/klO5gWzAdon5mVEprx6Aopog8c5cZPugp8g55o4E9vHRoiCSNdb1elykMy3UJmiDXrDBwHub78+Kl7THm0cFchFJpWHNbqbNgLQnw7uiWFcU/t+F5ibQYpZsWgWsPvENpMMfzS4GfucfwR9p4X+vIYSQb2UcDMB/6bAgT1QnQCpOVNNjsE2QCc8yBMOXlCIm3NuDRnh23fm8INuucIS/dwCpyX6HzXE08/bIwFw8jgkR8e+nC/p33sKsVRRbyC1ECYe3nGTHpRS54GEShZrwD1BNDjdxNFCQoSPabyTlXKUj/JH1YVWhDWYf1z6JPVPZqa2z3R0SAAfRurPxzloO72LBblI1V8Nt4hfTCdSRT50/faWKhjoIksIDw0WZxLxAFW5ynrOxKEvSt5Qg1HC5oACaAEZktIAY5G3kCGV40CzdO6pnTjOlEJEyCWy2cyFWpA7YwBd5nrjbrUVAfyhZfUtCH9MpwpVzZ+pP6+4MW3W8osElc0V+gf2KY2RPVLBv5LLoe89osiyrtBZYY7v8gvLKt7N6VORFBG4l24blUh2NQ6OVSRge4FJUG5m9XWmGxA/++EWP9hp6oHhDav2ArkKw3SYJWOEcHGQck/kY0hfIVl5/gfdTJ7wjOvT2F8JsV6XF/j7D135lzLsr9Cle3M7JxZZ7hBW15Dn9rlAiMJYUDp8GLpw8Vsz9udzIz+9CVt4GPYystbaPc+bWnjxWM3S7R/654Z695z8Cq91QwTSLRCgWlEMS/E7cPfr0
 vDvW7ECZ
 v8XyKhNSI5WVBJLDkpoT9yxWhcwh8ab79bFzeiZl4pdV56/s6TJ7QnFdKTRribxzoBI5rWgLw8PaLTHjdbXNf+rJXYjq3qIzMBwUANvzFrdeD0ci6IcqRdQNq7hUdaOxRdAFzxZDi0hH6md7C3CA/pAk8qD27fUBDp7UoESiVuKDXpqi3h854zlFZ5MMu2fab6Iad+eTWqaSHO5VAu4YT2Ltar+zRFFeoYDXkVTX/CHRLevHoa/SQvFZFydb7T1TQMa1s3dovzkOJSZc6dAYY+FRqeJMC3ZJ3uK9jVcDH+SviqYPz9srgKVaLzulcxwsreJuTA8DtqDTibaOqud9q7+0KyhmH3kwvMbozTjMHw3pNjgHYp3ugSGVoHA+rskgWrlSs+QAyozacG+vlU49Z4zVnBQwGAzqLU6KhWZxw5RVqRbI3u+qRCQ8qvkc+IJTUKfAG4VVWQkVBvMJH0LRVJzxyq2IxHXVhEjIcOONGSINb95PfBYPuFBIahVNpmSweNGBNJNcJgWLJaiGnn+fQRUUWVkmKETaldnfm3gbDAEyRfzppccyqlFHxnydlfbTX2dJUJwrEOaDYO0dVptvRVjLo4TL2IWrV2nc7uOWWd4dU1GzZt1gdIUt8ZNi+DB9Vo33PxkxizO38+zk0UDsDS3TxzccKVbC8u5pIM5KqdFALEOpUXzzRCLi82//CtUY5iqNc3+jtHSI7J3a1JxxnP8FoGxm+HKgxzT7z3eHFEInwdUM=
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
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
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
2.55.0.887.g758fc8c411-goog


