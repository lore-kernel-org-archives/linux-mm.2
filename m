Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 673D5C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1DCD6B00B2; Tue, 28 Jul 2026 20:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE496B00B4; Tue, 28 Jul 2026 20:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BDDE6B00B3; Tue, 28 Jul 2026 20:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8B46B00B1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED74DA1973
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:19 +0000 (UTC)
X-FDA: 85039945158.16.2C0F200
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id F1FEB160004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UPVjul0X;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285318;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGORNnHQ4No4R1wcetoytcWGscWsXOW5t3XZBhAs7fs=;
	b=ad6BymdX/dJMbd9cfNfV9uPoI1CGPJCE1nJ9YSG3dAalYukVr/YE3FUHxTarml1JoKWt8P
	XQrGl7Pk4F4IuZf0IJflULm5YeWAoPwMQRp/Vzhue0HWBrXWORQAkvD2BjA2iY/S20MYPR
	v9yiCRQKuwFBGEfncb6nobWsN1UWKuo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285318;
	b=MM5gXMZHhDBN4YCuevwZAUXPlJpKzeVaAzkqVwGdWT7+ufBItqNVWWuvV6YAg6cg2f++ms
	acNEV/a+DCMPFnmJs+rtMK/VjG+Ch4YJ/FvxEWDZI76Xto+ltVbBv27MjTV8dBG1mDLk5K
	yAinesirZ0bQzhdQVpa+02URZv25EFQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UPVjul0X;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23B5745152;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CA40C4DE0E;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=52/0Vt0dpEJnwhXlNQX3zcqGfpEYR+Me2/DktYpv8cM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UPVjul0XnKVXb0w0p/8nBc3nmi0afcCo+9Fca4oumSzLg6LfYd3rvmTl7TsPRUyqe
	 WInJVuT4kRktwFp+2dE+fVC9BIz17PWvegt47oxdB8NhJRdFVtHTCewXDxdJocYNqB
	 JxOUnDTIUKeHhO4jlnZUaCjT8fz3tCx9WiHSRGsg1dNUPet+OKQyXW4P/wDkio/+nS
	 DeU6qxzc8lBVUScfCszuEr1Gf3DOpW8ETfRgrCSQUfzYqo5xSvDFpIX+7d2q0HicRr
	 4GTGWSNuQjEh4/m6eu/yxlp7GO07aDFA8GM8offjBlVbKJtw7Or0LMlESkSdaXKUOj
	 nebQEmOdh7fpg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DBDC54F52;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:20 -0700
Subject: [PATCH v9 21/41] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-21-35f9aec2aed2@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=1641;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xqYH05bSCEd1Bk1hXIslSXCmEIZh87KnzlPOeglC0VM=;
 b=bL9eALDZa5rrVw3e+oDoxAYk2lxBzN9/H13NtfJOfT/y/F4v9X0ogrXYkcZ82AmmYuS5rPP89
 NZtt7tORv17DBB8S6dcZfZB7MvYLXrBe7t6xg7XcoiTHiOvXZz1Okf1
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F1FEB160004
X-Stat-Signature: e8877wx36xt5o5t9cjm3b6jpdindoqms
X-Rspam-User: 
X-HE-Tag: 1785285317-857413
X-HE-Meta: U2FsdGVkX1/qv7euLEz3PnR5s+45zoobVKmzSxuiBze13NOCnAoOnDw8FsVssdlcda2m0XZgB9TEDfnmrKuksMIZu+dRufPVUBMPycsV5rN5Na1L90XEox5C5rKVkPsGpMQQZTIlk8oInUJbjSZJbzfOUywsJiSpBZg4D8zOCDOE5taCQzdHPwlKKhbN1d9JVyeDC7ohkbXHMz7RRuDqc1p7RDoHK9HLOGhhyuBpTum9Xqt27ufjHXLORQJXzuS0n5tWrPRCxwV8tzicMiTXtfvvs5/mntoe6qWudkxPNSGUFYX235czQkJq189QjnfyYugraupp57A7hZCI+TP7yHLxH0afNj54wCB++O1dANks3q6hhbzGTqjbieVElqOhkeuHEo9f2/EHCIqat3z0+FbwVkC7RdcljCQSAGdwsYiuPoLAE813xumpGKCLJcAou4CtGeBykP29uIIx4PasOqLWX9l+zvUoaHHVDhdW3vmKRNj/whxTZv6xTpEVhjGruESNBt4BluK6cbrECAk9JA6CtZQu+4nEeSFOflPlo8ytBSZPFGSSCVAB2hovFi4XM/rlOkioB10ByMyh4VScj+9gJ/SIR9q5B4X38bVoOAr+61XkiScklZTJh7P9BUviTzYVgc0l69hyjpC36az/0PGMTiV/OresvHXQoMUEU3LL5Fx/XIJTqVEk4x/6r+Ekfjbxqfxw3oNO6gHXvXm6OMe/hSLmQWYesSpYzljG9aVZzmf+v+ZMWzb2PIYf7meYguIc9f0FBMK8jHcgbmsRKn3bYr0H/mZBNZPYJfDligsaCqH4wV6+DWCYAtSiUEP2IBmifBmNs47R12yBiwgh7rksU2MHcWd4WxxPDnI17g1+hPxVDU0LUpTk60nj2h8lSyNrbaJZpLPVauXg+9swWebHPVbfouN0cmSoEJBbE6RbzCdGgm8tZvSVjVPWOOsbTVqai9ALd+ycrhsFjxk
 DE8XLctc
 CMLwGIgWNxMDhZ/Lz0vLk3NGukRGAblWm+pkx4ZZKun4ECCIaUOf4NSx6jJU48u7BZpp0a//q/tFpI2td2kXTiqiDeQxHlOImrIjO+DlN6R4iOij+mlhv7QBNRoZ+xNimQZ5J8fY1TQ3yXYnk6HbaF1it5JTogbiy359kAPppcaKkwxXMASZMwpSE9ePlOxn40RBNdQYDNixU1vm3KYjuGQTIS9DGTv2Bwe90G1ZuA0+klifDG8uCdAkOmcq7vOd1cb0ScWqjw3X3642uhJu91RNbLCO2MQYLFL6C97WYAlx6Ub0J+Glp8eLdKlLkelG5cTdGdTK7oripxBDdtuV5N+lfA0ElgPz0+4rNnHKnT90hwY3M6mdqCo5nWUk9xucOwo5XnQXy0jG8C+LgVzc4CEjTGCV3zTlvv4PvlulEKirzmS94EnbrXdR+LA+CcDahVRLbh5b/xzX+cEuDh6bPN0nknkv8z77KhnHO2NMUObVOrNTM2UAK+yx2MFDWtYLD2idewPCwTsw6zUmWuhxipuTFbyiUFc5AIJgdpLCbKie0hYghBWHKWEWa7t2H1NBkbG8gtNebJitr0ImRPN8OQPCqrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Now that guest_memfd supports tracking private vs. shared within gmem
itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
for x86 Confidential Computing (CoCo) VMs, so long as in-place conversion
is enabled, i.e. when it's actually possible for a guest_memfd instance to
contain shared memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/x86.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 52de3ec7c7f73..79538dedfad68 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10623,14 +10623,15 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-/*
- * KVM doesn't yet support initializing guest_memfd memory as shared for VMs
- * with private memory (the private vs. shared tracking needs to be moved into
- * guest_memfd).
- */
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 {
-	return !kvm_arch_has_private_mem(kvm);
+	/*
+	 * INIT_SHARED is supported if in-place conversion is enabled, or if
+	 * the VM doesn't support private memory.  If the VM has private memory
+	 * and in-place conversion is disabled, then guest_memfd can _only_ be
+	 * used for private memory.
+	 */
+	return gmem_in_place_conversion || !kvm_arch_has_private_mem(kvm);
 }
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT

-- 
2.55.0.508.g3f0d502094-goog



