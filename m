Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D1DCD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABE716B00A6; Fri, 22 May 2026 20:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9846B6B00A9; Fri, 22 May 2026 20:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D74E6B00AB; Fri, 22 May 2026 20:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 527C86B00A6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11B65161A0A
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:10 +0000 (UTC)
X-FDA: 84796772340.21.14BFFAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1AFF9120002
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jChBftNo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495488;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqUBWK5T1k4a4alEi03W7CGOsVRAoOZtYGnCQrKrmqg=;
	b=FAd76OaHwBbrhp6NQiQ3Y4hppv0wq7gmkkycAepj/h+724KpyJAytnu7d5vFevDXs4cydg
	MzQBWIgRAQzBbbbai16RDROLqjyTrFMlY4/1ojtWPdVpI284n/Ck/GKgOh96yZ8U4x4rUW
	kRNczibMOLbhgyUUF8z4wkqMkVdnM/8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jChBftNo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495488; a=rsa-sha256;
	cv=none;
	b=le0PAnlPVul9B+qYKFh6r70bUGmMgAZ8lAx7kOuH9obX8saTdTIApogDBTxEYrbf/swMFu
	h636Gt5y6j/0GMg3Cir+86wqJCakna30AKQp6axgFWMKj3xPhslwzl9ZfNos/UA2giCU1m
	6pHsEwNHjxFSdR10/ZHG/LeiRS1Kpng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 42F8A44648;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDAEDC2BCB9;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495483;
	bh=c0f+CGKARYuIRsR6prxFYb9SX4wd15NRM9c4tz63uZ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jChBftNocnbeVk1l8w6INLZoXx3M3+na86bnCfPy/HoV/1qaXhw9nb59zky6lHjDL
	 nyGQnREhM9obkZ4H9Axn5y+mCh7tOEe8tMFNUhyHuGflJhrjWbVTpWppGtKlS14WqQ
	 cCDahlzUvrDCe63hqmALEaF7b5KK63HvN0vDU7Ys6pyWnf4JqNNOcXNqAcFC8i96jo
	 KS6iBGTYZQlYGBPfwJ9eXgxIqlQ7LsgPVmk9lkQW6PaH9ldCrFs22xcCXgjAjqX7mU
	 A/V6pTsBGl660p6SFTYVmcvL96y/6ELUjP81Jwtmr5zAlhEC/zC5yGxG0IsyQZx77a
	 XrH2/T7OKzhhg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE0DCD5BB3;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:50 -0700
Subject: [PATCH v7 08/42] KVM: Move kvm_supported_mem_attributes() to
 kvm_host.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-8-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=1948;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=efw6NUHcHLRdRk3uPvWSSZaXmjqUPOR/HwNza8dJmHY=;
 b=B5lunaP9bPm36pOBF1WpXomZpQHYcSiiA3pF7kR7bYZ+1X60uYHWizr+JKmDOu0UPCYEqw5j/
 qRmSJ+EXwocBeQEXU4B9jDFBeR7D4lyVv3+zIN3h3yBNjoSA6FXUDNq
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: qtk4o73rqno5s1aqiy5awpd58jwhiio6
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1AFF9120002
X-Rspam-User: 
X-HE-Tag: 1779495487-57693
X-HE-Meta: U2FsdGVkX1+9MUdUMVDDisdHerVxYABt+P5DoWcxklRreEWBMFU7w3aWvq7Kpfq0z4EtWXOTc42E4gF8ZAYGuXRfxRuY/UTUxIRAX8Rg9Za2mudbeqAvZMCHFvezgVQAml3I6FcF/deIgQ5/DP/57ue7jZjYlSO34+/jjuPDvBuv69FJswFK9i7y1Y6wgsdFcVLm0U+Z4oOBtTrFMpE2dXXvJqiHNNzf2S5yila3u31ldZuBu/ZTjpGxKR55TCzNpGghZOyES9hLfiYt1XQg8UuNEZi3gr2lfloYiuNvSXp42maixfaU18L2x9pt3lM7/mhQbtZxTYGaztg/jlaSJgJPyBBTZ5cYWg20RVOZwudlIvBCdYWwd9leEv4Wrbf0yqwvWTh/oU9lcluoto3r+DJm1XbFP5XpRi1jvm3c8RuR1OrNFWQA+nEewXYwkJcH1f4MLJvBbFMRR4uC4cOGYYRo8K1vsvy6PDbZwl7e7/7/RzkMBr+hisV/UlE0+aZjL1EoVmCENJVmClmtR+rYaeKrM1xTHncpuIERHZaPG/PDaSPaPnv+xJFlMsfoPk7LL5oWvvZEVyw6iTgEXXI2ULAA/1aj4n+lcmvnfDvfCSYlyjDDvEhVr5qmfpOn7jtkvlIoGigAtNfDCtq9DlZW1lRxRNky3e4w5IZgYu0/ycJqDZpdsN0/7qzV8UnJ43rEY7je/M89XrnjcDhcsSRU/ozDuLHz9JL2X9igpZvHuubczkZuRJBsMOEsjqLRtLUIV6RK1UJgOqrpgPZ4Fg7hvaydmG34jOI/leyza4amMH2ta1mkBXMBJB3XIG90RdlU2eu1aHpp/ANtYIOf0Bkj7uxkzyQJdFOIKsx6YIu/MLK4SqiKP0Wyp8HGSyWydvY1+h2XKtix1I220M1g537Y4d3QFs/FmxqtLsG0w8W0U517HEdv9wyv0ddaWXuNu/ObyT+QIGXkPemy1hXTwB/
 2LgHxeys
 2Fb2nE0YM2VFJIHhiK0Ib2xwQk18gKpJ4xdt7g1FuSn9VhyY9+i/TSVaOgO8izBIlKxUA/08CM++M9pR09SXHTxbpa7j3/DrVGDSX0cy4V8UIuIGX8cRPDA1SzVgSfPFvTnVrDBCaMHVvM04GWo/OzJKONwkgOllNWomMX1jQbQfT7nQWoCp5vm8AVwp/HFc3uunADo6WKWowrJhure06fb6E6zQr0TBpMKyRqNeZlTzY64aR9KBE1aV6m/LiAcaViwLRMzO4Q36j3otp4pw5mfXjZtmbPPLwsei8Mk3/c7eBtgeS060ANPQ01EOrrxu7wWQksedjn4daOTYSnUNd+5aXZ7x1SpfXhUnu0bFDewZfaeouSScH5bA4JVC8VH5tLUoH3fj1/kaKXsZobca3neOSLQiZK1n7yAWKi0KZk93fdGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Move kvm_supported_mem_attributes() from kvm_main.c to kvm_host.h and
make it a static inline function. This allows the helper to be used in
other parts of the KVM subsystem outside of kvm_main.c. This helper will be
used later by guest_memfd.

No functional change intended.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 10 ++++++++++
 virt/kvm/kvm_main.c      | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3039b291e4b09..b67e7b308d280 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2529,6 +2529,16 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 }
 
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
+static inline u64 kvm_supported_mem_attributes(struct kvm *kvm)
+{
+#ifdef kvm_arch_has_private_mem
+	if (!kvm || kvm_arch_has_private_mem(kvm))
+		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+#endif
+
+	return 0;
+}
+
 typedef unsigned long (kvm_get_memory_attributes_t)(struct kvm *kvm, gfn_t gfn);
 DECLARE_STATIC_CALL(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0a4024948711a..ff20e63143642 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2428,16 +2428,6 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
-static u64 kvm_supported_mem_attributes(struct kvm *kvm)
-{
-#ifdef kvm_arch_has_private_mem
-	if (!kvm || kvm_arch_has_private_mem(kvm))
-		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
-#endif
-
-	return 0;
-}
-
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {

-- 
2.54.0.794.g4f17f83d09-goog



