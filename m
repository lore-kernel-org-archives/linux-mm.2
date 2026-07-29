Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F86C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D05FF6B00A3; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB69D6B00A7; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F656B00A5; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDB56B00A3
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18A9E40575
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:15 +0000 (UTC)
X-FDA: 85039944990.09.04876A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1330D4000D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FGpDGQbV;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285313;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8X4A3B5ONCsUBq+glYvkEeKRXOlZZ31bo1RA1xlHLmo=;
	b=8H9fcgHKZxT/ySDstzWSaCM8J3VVj8TO+GmqI43XDXn6W05WbYA4QRArotBJLMz1fsFBJP
	xzqIebiR8dg0jsQvC7p9QQUGihpfgzk/GOd80EEv6cbkFmv0HOl7fvLQ6pVe61WEHlc1rz
	DHbQ3E0tQlqG/30ddu8kl/t5t+gIWA4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285313;
	b=JAAtQQipcf0cBcoQ68LOVz+vq8BTQEzd3rKLcKS2Sqyf/ellyenZgXHkDc1gUYr+Lk7Zq0
	pIhtptjhhe+TqZJRV6+aZd10gLzHN9DAu89rLRDFeHccFZ+OFoRvwkB7HI3jh2bGUbwuKc
	dRfEgZ8D5pjshoVT0xkJVPxEDplxJzo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FGpDGQbV;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E747645184;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E58CC2BD00;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285308;
	bh=96HqI9Y5vsPcrIKhQu/+mj6K+oouZGOVbPxi/4lcf0o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FGpDGQbVZwGe1pqcEMGrsy7hVcK/X6DrPY8TrIrKui2BZLyKkULT8upmxSHNEp6+P
	 60/fY2Qq1H5oygah/4jqjovm9et62agJYQiwl/zvtRlyk/jJECKXQe/NJ3peD1uYvU
	 77M8rq2pzfsb8uTF3ukV1n59jnqC6XRaAPtViIUPH8dVbxdPijJGFBGU4sNhWR5Xrk
	 bmhFdgJ34mhhzQWUera2ZbegvRanZ+SPRy7zWuUkL4vAqmAfRUuPv+YVyp1AFRB7mn
	 PmdiKtIyYpUF3rDPl8gUnD8j43EMf8wVhLdzfaJtZc2vvPRZv9MBh6xE+Ek4HGCjGv
	 zbYiOMP6Dj+CA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D931C54F5D;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:07 -0700
Subject: [PATCH v9 08/41] KVM: Consolidate private memory and guest_memfd
 ifdeffery in kvm_host.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-8-35f9aec2aed2@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2484;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jf1MrROhoP5qsrz4rONmHUTa8uA5GgSOK5Apv/HKLRQ=;
 b=ebjZZEIpnDXm6bkL5ycZGNe/duoabjbHBRcQK4qA0l35X4QuZLpVrsbF4MGu5/pV+t29I/PrP
 5WUNvFqPB/6CeK2tiMBD+PnkiJczv5IPASifuReI+THlO6IlLsqJT0O
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1330D4000D
X-Stat-Signature: ssc1tppzubphhfwroyss4jqi5a5u1fhd
X-Rspam-User: 
X-HE-Tag: 1785285312-486410
X-HE-Meta: U2FsdGVkX19nZKhAGAxAL9eh/O5MIFZ89GNFqACx+SGXP0Iapt8sdZG9J2OL7ALKaIAzLSp57GQZenaRwPq/aua0snKHQresSZYXFSFPtd84J2V93dtxBKfUBzVFVdaGGXWbq85zIXIZ/eSBkcspaVvczdHkZkpybruZwXk94QA+XAidTgT4CDF//h0W0oXGgQR4C9Y7RfpvSUoK0CvcPsc+pPelcCW1xDudmubH3VcVU1/Ar2FiTbFoRtZZV5UqTVmmBH3vAJG4AOOG+KsrEuqS+KUepuoTRGKKCsg8fZgFih3gRMchvJyV8iWX93FLzBLZ+38rdcf/9mNh0aZggZs+x++8CbRlfJH14fcVW2fNaElc8hI+TtjBEMEpkZTiF5naAl9sRZUgeXeXLeMzEZl1M45wTEDzi37PZS+mO5QHKvbct8ofkIo90mG/vBMpIxpBZEG0A+6Fl/bZjJVP6oNFrshxBzTLWQslqp0IhkWNGodeCH3hfe3YQybfNBgIdvu5z4rkmTmeLYRM9mmrw2jyd5WEGjaEA30xfhMriMZkY9BjXdYTwCRaxhLN9DzLGvqLCRGIo+WZ5h48+eF/y0jTLmdsNP1qI0eyotpFgFTAhNS4V0SF/DVlth5CPpbn6q9BnohGMPA+qAO/MZ0BHpwUCL0t2YrVROQrEqENXYZJ+i/Mjpm3tt6REyataKjDfTOTf69SLK5M0QP1+o/iyWXfGzWWKkm2au5JHnp2kNykUhvPP6ozJdQulD2sT+y0yJB6LZ/JDu3YyhftzrN4l2As2JOB1KQg6WJwbWH889IFJiazMm2Prb4dNdj1t9ROJbysKniSDSQnkcwHv2Fdha0seU2rsytMBbDMzPHHOI+Wca/CGLigziu849CyGIMFVXjcyCRy0owOMMoIY83ddFJ8ohR5zK658dxnkVU7mcTX9in0tbTSqrNZMh6FvjtOnJ+NjTXGPTsKOByDn+b
 5sK6YknT
 R+KPKkg6oIhbhX2tCAqOa29kV3PQQYWE0wdctFjBhSRG7dIP8vm8EjL3tmfqleClrCDyzM4/5TKCe1sdK6o1eVP6OcqtyWMAtVUtb250oiUQBtUqPrwL3Pz2dTg67iCGt4yj/ZtWuMXmWZI2bzHJsFGJqqtkjjpmqQ7NLtiImaCFn+8Jv2O4yNQqiaGS3NG1gBzGb1ZEGJ7VmVN93aYyBMwxN6gYq5YoBCZrnunk2PH/k2kejaJN9Z9EEZ4whO7XHrtmLiHYeGcjgXvfqUUQ7sW4h0tsNZwyWQbO5Este4SoegJyG1N1xW4ejSCm7N8MSWYzxg5wCDs9f9C+ut2xJKHjS+oDOYhYM9neIV5Zaqkla2W4AKj3Ep4CvhQgHRmVCFjGxvc0QIqYp86OBkUSpxfj5+m3n2dptqlZry1ALXRQCBDXTeF7Y668LAiuDNWydyUoFXqOxuqIQL6240wFm+hZHH3OuzvgZ8liDEKlO03f2J2GMpdWQNQy+ja/rd/VmGVm7L43JsufeAqMjY9N32CyjkaI+NNRxxOE6cSzkEiEa9DDOQNfPpD8fgCnZgmarVWPRP/d3a8/D1RyJT1oPFSdU/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Move the kvm_arch_has_private_mem() stub and a few guest_memfd function
definitions/declarations "down" in kvm_host.h to utilize existing #ifdefs,
and so that related code is clustered together.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a913dd57ae622..f408746d315f7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,27 +722,6 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef kvm_arch_has_private_mem
-static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
-{
-	return false;
-}
-#endif
-
-#ifdef CONFIG_KVM_GUEST_MEMFD
-bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
-
-static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
-{
-	u64 flags = GUEST_MEMFD_FLAG_MMAP;
-
-	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
-		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
-
-	return flags;
-}
-#endif
-
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
@@ -2591,6 +2570,11 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #else
 #define gmem_in_place_conversion false
 
+static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
+{
+	return false;
+}
+
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
@@ -2599,6 +2583,17 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
+bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
+
+static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
+{
+	u64 flags = GUEST_MEMFD_FLAG_MMAP;
+
+	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
+		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+
+	return flags;
+}
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,

-- 
2.55.0.508.g3f0d502094-goog



