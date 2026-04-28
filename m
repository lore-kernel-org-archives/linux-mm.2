Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D7CFF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86D7D6B00B0; Tue, 28 Apr 2026 19:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845146B00B4; Tue, 28 Apr 2026 19:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7340B6B00B5; Tue, 28 Apr 2026 19:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6243D6B00B0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:26:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E80168C439
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:24 +0000 (UTC)
X-FDA: 84709548168.18.EFA6B22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B515214000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M7HrdDQJ;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418722;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DZk2H1We+VRxFHAKTpAAchNyNKPX7Vi6izgtdxoncM=;
	b=GCgmoQo1IqZsQ3L7pL3nBnARV5+yh4XLfC8gUwq4kWoSUw+GYrNvznYY2GcKKGf9QVO6MM
	OELoe/ca/1VrnOG5dM4nmgfyqcXa/zWl8VL28mf/BSyk7hLMEaktU7IuynSuy/dDLepojv
	TgBHTmxORIx1/peTOwYTqV7sJoC7Sa4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M7HrdDQJ;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418722; a=rsa-sha256;
	cv=none;
	b=bwUeCj3I3jJ36eA4LBqeuInf7CpGePrsqQzAgRgjWpHT1Oz17+vUUKJGW5u+IuGG37y/tQ
	vmvcOMoCz8xJUE0fJt2r8rdrowAzExiT5JPBskn+xecOSGCzpz6gnUb2ieD9OzZcK0CMJB
	6cVAT6umbzWcV6RN9vV4YBrCbpBfa7o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F11F447E6;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDA0AC2BCB3;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418718;
	bh=dtwLZrTCdtYF0WQJCPjTeRznnhw4wbsEzLijM5CfNpA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=M7HrdDQJgrj6wn/nqCeEtM3jwZ8uRtVpe11dcn00jDyymdi5JFoyuhWxLJCq4cCWA
	 6SZ8NXmePy8Xai7MWS/Ln3/9Gt0p5Bcus+tbisKZsxVrb5C4rI0C6kTCVDCLPDJkAr
	 GPNnqdUr+3+FwOcDJsAMxHpKMkpxPqCgTxQnZa6nPDlWOaITLCjzDObCNWmyS349AE
	 PAMRWhoWyOjRXraWSFHaACsI2Sth1AdkzxtgsNenxzYl5SdVLbRH9D3ma+kf5ublqv
	 RiyRyY91Lxta40wZvT0LdyywlqCPtH4RgHURiO7TpSNzoim6y0C3zdJvAoKS+NbSVv
	 3t+FUs6IXrznA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3DBFF887C;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:04 -0700
Subject: [PATCH RFC v5 09/53] KVM: Move kvm_supported_mem_attributes() to
 kvm_host.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-9-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1904;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KgLAU6noveUvf5fI6bj1R5BsJhhYvScuPPA/BlOKlOk=;
 b=k2Xf4rmjwdl/N8GqDeRUZeG+vf5oIPyQCq1XNAC4f6MtoL0TdhL4DVBhgoajGopGFq4FETryr
 jbKaEXhTk8cADW9GiGhS1xOa3Dxz4QcX3WkmF+6dbj+4WQxORlleMO8
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B515214000B
X-Stat-Signature: g79wwm7mdgjtc4taj6afay8me5bw9gkt
X-HE-Tag: 1777418722-289539
X-HE-Meta: U2FsdGVkX1+XU9QlCtPDybFyiV8oyW8DFv1SIWVUHjKMJTp/iNAvC4gfNlOKukY0JSwSd1cnihOIe3sthMr4we/+B/MGJytrgYt8JrNFK8hazr6THuPpkWSJtw8RRfBmKI2zTz9dXpvLwaYoZFI/SQ66j/9Nrt96tTU0g+fD9qLspUqNPvWLCsV4UwMJ+JW9I5F2GawZN/1awzGR9A7QiE2TP1gAaJYc2dzfUdCESJB+Vl4t9fpMRcrNyH3Rt6AvEPM3Prl+uGbiyGoGZFvKnZUousMN+Pc+Om2heHbNf6Rf41Vgu21qDNOOy69ETEP3B7czMHX4j9apO7ktICnbHEZ2b6B9vvBsu8mHC4TBrAvofHFjPlLPPBCYFFZ4EtDIQFL0hNZEGdOBvdlMmnVHkeElL5sEImF43lMgV5Kou8i3LbVkdWjS6ESMufiV20AFwljevODBLoYZIi4qtWIVlWTH+h8oav4SYwl8erofJ+9e9BZ9fJIYw0qTnL2ZwwRJDTgr2APzLXZIKKt6D65FfqI7hL5s9F4swVsaLAu16wb66H7Kf7Cw+zLkrrDfvs9OBnmI5g3rk7zMqU+Jef5xuFI7Wf0ktoXJNCZevN/ZP/7QsstZRaOwq9ZjUT949yl5ROWsl6/ANC49X+BkT1wh5AixSqtrJf7Cw/Spa6zMBSFuB2rW6BaRWH0x3apTzt25VeEkzeQM1+ZNEirPVJFTxiF6Z9wqVf5M+dMz+mu1D65mKyO2wO9AAMKCSWsDfA0pZMtp5RnECX3GwkUKiPsR6XthaUoOLj3ucweERlqt1Wx4rw1j3nuPM7i8oL54CKUBu/OgcJ1kLhm/1dmG/mQ76K6jUlO1+os4XftmX1UHN4Fu6WmJRn0HikBnYh5csBpZ5fzejmfdO7pIMQ0/ca0QiEWuyg8MMiwKqbeWt6dRoc9SupNzNsJj/ESt3X+s8KwhKgnFVYOLvRfO0D89vwh
 5d4RsMSC
 NQ9vCifOFqHsEqBFYYRAAVHVXFmazLmBQIA3XXrgFYNbRk8UDl7yvSlRG6reB13O2aUXuye5LzVkEiI04aucW8LjexYlMJrNUDTDuLnyq0+ZI1HCFoqoEDtAuvm+D8CFbUgXrhjAdt3R6sxsx6BXHJ7gmE2uSumLW9TeP3DwRfEvTns9qJUmgbHRRnADl+am2snYCCld//SpOzhMBa85hqsrOAxAr4hzA10Tkcx67O+QkeOs+xNj2cRIKH63Ft7EiGEcAw33eFzE4En6pSvgZVhXJkxU0jsYLAhZRiEs+kZvOisj/khBbn1H8b5hzhyTvpC9CtJP3V6jtIJlR0oPKArWCeIDvWSLXyIkr6f3JU8j5VSnAeBJMYlk/7QP1inGfMi9LHoQQE7BEgujGAO+zg7XQDTODKJ7MnfiVkRvpK7aKDxqt69uFGdotTaCr3iEY5DCX7+U1UAMDo5g=
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

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 10 ++++++++++
 virt/kvm/kvm_main.c      | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1deab76dc0a2c..f9ea95e33d050 100644
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
2.54.0.545.g6539524ca2-goog



