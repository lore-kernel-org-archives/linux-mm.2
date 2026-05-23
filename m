Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC86CD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01A806B0098; Fri, 22 May 2026 20:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92A76B009D; Fri, 22 May 2026 20:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCCE46B0099; Fri, 22 May 2026 20:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7E156B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CDCB92B7E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:07 +0000 (UTC)
X-FDA: 84796772214.19.FDD3F24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7AE7D140005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+9CYYYC;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495485; a=rsa-sha256;
	cv=none;
	b=cf/QVSRmRaZFF9UVScA/bu9BVkCvvMOaGOQYSEaPrc0UHtzIwPr56PP+FrCzYcts5GMKDG
	oE6NiiJGGIanQSIf6K101gnvGMp/O7GZWLMqJFTA9mE9vttFW6mE107j3SaDiNfTQmIoOq
	ZCAyegTY2pRMnzRl7YkE48y3aFH5HZE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+9CYYYC;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495485;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CadP0tKtX8MozY6Yp20G8SaMQXTzGYzOSYtPap3/Rv4=;
	b=5ay8Aw1JfIPRiVv3gq3K9ZYQ8MY/dyGxTW3J9RpeyWMLuZoNMDPMNUHmdn901WmaqYKqgb
	X7vDjjW+iTSBk6S+f04KqnMBebq9EW275u1Rvp88TeRowm4F8+vLwtoG7FoeY/5Dv1Z8U8
	V0jQFR+k0qDmTY0mRIXBeyySrMvhfyc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2F96445FC;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5DA9AC2BCF5;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495483;
	bh=z0QAq9t3s2RiAZ84UlhJsLG+UdFN1VXDl0SsgHlKwbo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=R+9CYYYC3EQKRyDRSABqmsfc5EosogpDgXztBQthb4FVsEFxcO+7uxBNfgFqbxYoI
	 FnbimENx23f6vsc5YiL2Lc6G+2L4SHRfCf0MnB/nlEk0oLuzJ8lJTnK3UWXQVL3PCH
	 EeFpu72spbAkkFlV1ggvYSGkyln/rsvCUAd3VSzQqX5v7G+RVS2v6azh26NWxPYfaH
	 1E9MC7ZURzvXsMrP3ubb6olZ+YKU0t8O28sLqNq82kRZBAzBPyQdapDorhuNoIv/Wb
	 YTZcD0rcf3GdW2ioIEAcKVuDcoyXPiIG1nyEICNUJWGvN23w2OUZstp/xLW0xMqeBY
	 JAu0jXSjtAacw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD69CD5BB3;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:45 -0700
Subject: [PATCH v7 03/42] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-3-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=1835;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=I9xW+NNDdXyRw8cQmwAmq6HLPVcmsBCaOnFmhphvyFg=;
 b=PEpl7fWcpKP4DDYa9jEB5zhEbwWwEg5E+JKDNVBjoaawwUh2wUVJtzZVnCoLx1LJwSYvqrIC5
 Q1/5bY67gZ4BtfG8Q+lEZZHG5PLarp2bqWbORMScwW5xtDaxLovCsqZ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AE7D140005
X-Rspamd-Server: rspam03
X-Stat-Signature: 58sj8pzeoq75su3jybqoua84tpiczbsd
X-HE-Tag: 1779495485-14302
X-HE-Meta: U2FsdGVkX189GLXhj1J9yBZgwLnWt7zecCe1KyOVYdKOfOI1uAnDdAulPFf8Rv4DPHiF2vPZFjfGjgNLG//RTX0uey40zOlDKaB5xG4P0GXmZmxNGe5irND5fMvOLnmZddZH8n9cE+p3VXbWkgfi8MrhGWrLo0O3OwF88QDaMeyhHrb5GakfqaoS3uWUEV4AC9GTKfauHDNgeCDhMZ+tkE6HmdTiuqlLKK0+0BfQwpYJJOnE7RNjahgbbSwRUbZYwiQKSiIFVIvmPJXyWjpJ/QEyvUKvKh1M+XQDlGGFjDAQxsnluBEP0GBQ6gpfMrZ0A/pxqhgJ8blN8GAkERIszolOOq+owtsxWm9Lhnl/mderdv9zW3nj+EfHxIymfdZ0bG3+v0zYdPJax6KJJtdLe53Nau8TyZRgh10jQ5FH1g7evIOJRBBM931OWn/OtEph0V1RRZJwXWFhGXkxRO3eeprDqNMcurCLuQaQun0/e93dQGXLBvhGbi3VKBFSfza08tvNU+rec+7bBOIepjTAaSV4mT15LgrVCZuIXjUE62k3SY2Nwq2Glg0d4ykQixQvTwTPZBeKEPIYXDZYDxA/l/vOf7WGh+/B+9bLrQRhljV7A4/iTFXx3e62OKFenWp60cD2zUXCW1LZVWSX7fQgxdW03L4D3uaGoZJ9rFlFMcOhuijihWHHy0Tx8BZbO8CViNCGt9EXv9qAlT5GCwwKvsdRarLFRSWK1iBV+Ek+Fix5gpeoEfnasWC5S6fMy0QGZupUwSEFrrozSY4l5/uO8sEFNDkqx+TLASKQeItv63f2xXHmdU3wQwhQBVScl8EQUbOGi7a+6NPzNeaOWFn7bp4pS1Wou5FVU+Iqd3QsEPR1mtGhoagqPhpcPKepqTOUHQ3Ush8DHjGhoMQukQPiviYg8nEofMlSwttwFz5dQXLNLtTQn+9oeqidtwHrTHTAhFXrccAk1S7l005zmE/
 7oC603pk
 Ej/3yXdlGwAe+YmnuNZA0NNmhmsiD3LHsJVn/OZuUoRjY1h5R7lPRsp2e37j60lEt8Y9zWQnsde28ZUORun8rIwpjv4k3ucngyzY3ecOyqfALeAW/uRxN0tSWcTmUdP9orAUUOFBBFF7OccxewdLN2Gex43yB6i4RwBVB45fs761ZpGIZP+dRQd8I7lZ0YGhPS7kxYup+jqVYfxxEvYYZGx84/3VqXoIcbHWajB0TB+qhHKU7Se1PgZx3HAFQwBMhdwz3crQMeAjM5wh6fkL46MvJyNyL8/XIGMjWqghSi7Lh2cI5K7qPYEbe9LcpDMPB9lUUDoERUtd3OhbUEoZGpgLhw+v05hxVO0YMfvuMWJcFeKobHPZYXiyu1Q+qsuHiDE2dZcFy6N9vh/HBWPYLTYsjTPY2CMODbeyQGoKYDevGmJLjjxaCKqjghuv+5mrj2N+0wCsv9T3vYzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
on kvm_arch_has_private_mem being #defined in anticipation of decoupling
kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
guest_memfd support for memory attributes will be unconditional to avoid
yet more macros (all architectures that support guest_memfd are expected to
use per-gmem attributes at some point), at which point enumerating support
KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
supported _somewhere_ would result in KVM over-reporting support on arm64.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 091f201251159..68142bc962953 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifndef kvm_arch_has_private_mem
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 306153abbafa5..abb9cfa3eb04d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2421,8 +2421,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
+#ifdef kvm_arch_has_private_mem
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+#endif
 
 	return 0;
 }

-- 
2.54.0.794.g4f17f83d09-goog



