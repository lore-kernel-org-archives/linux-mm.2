Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DDF2FF887E
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C69E96B00CF; Tue, 28 Apr 2026 19:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F496B00D1; Tue, 28 Apr 2026 19:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B30C26B00D2; Tue, 28 Apr 2026 19:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A178F6B00CF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:29:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5087941461
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:22 +0000 (UTC)
X-FDA: 84709548084.30.A5EF1BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2F89240008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ILyLZIk7;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418720;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uGinULIohf7X1Axd8UKaE/ALxODLs/dwvxMVf3Q5YA=;
	b=UTVdRdsET5+0pEVN/13/kH9+5eGZjUlr/0B2CZPQC3w83hqccRt5IG3bq4Q6g5btgcJtL8
	07Mw+LaMzhbKuzWo76umFjJB/RWwSdnRkyLwe1WtIyZsl3Qrtb8FUaJXZIBrczzfmYhEJi
	dW/jbGZol4JDdckqI0QAshe+JpBoNEA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ILyLZIk7;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418720; a=rsa-sha256;
	cv=none;
	b=B/32Nznj64FrNnZu8NAp5m8E2I99wBfEOeHjeWcRNVtkEUzgThoYHIZisAMVB2r6p9c7/u
	KBjeJvi9C0wUu9nlbSHF5WEjZXaQCBR6deYwVjsejcqtYESlUGh2ysResW+tr1rJ/khM+K
	wy5JOeYG1A0F/PGOoIIU4MCN7qOZ6Wo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BB3360583;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F9F9C2BCB3;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418719;
	bh=O5EusdRtRRcBsbLXs41Iht6PiU+kaHavayRHgykcm70=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ILyLZIk7mLcRdFizYiNm5+SQt8Rlc0tM/h5WbkdME+trzC0BLp+ecwawGTzp7X8II
	 DyOCuQHsDjEiKr3ElyRdA9StEXtC2u0lcl+vBpq3qruQkTKF7ILo2PWH1qrxFuEUqR
	 labSI41SqA0y78nZAvZwTa4v1OSrnwqtTBEQ5gDvBOaMyjPGtUXHfk6RW10uLHEtdv
	 hMw93TrV2EjkWkIO0aa0v41/BfUU4ut4DUNRHwSOdUvcdlh6VBc1teBRCTY2afGGDV
	 UI0k7eDX5mu96a/iXr8rn5vo49LfAMB3Z+Q4qdLdrFaN6X+UpYGIFuVd0u2ubwumMc
	 WxYFtlz+uRxhA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23281FF887B;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:18 -0700
Subject: [PATCH RFC v5 23/53] KVM: x86: Support SW_PROTECTED_VM in applying
 content modes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-23-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=3447;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=9ksW1lIO9ZmZXIT5xvo0JGaOScZO9eFAx8q/FWxGah8=;
 b=Cy4xUfQRFEwNJDgZS17EsIHexFRRfCGZCJzHnrfM2HPN/NoecocgbvmuMuwK8/LWmqP1BNxCk
 G0AVsZtj4TUBD2z0PWLopI3VJCmZQUh+/Miluf8cH7GpfDGSe8Qxxx0
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2F89240008
X-Rspam-User: 
X-Stat-Signature: mbydhpzaoh3g9djpu34pjz1hghsgsb6j
X-HE-Tag: 1777418719-916618
X-HE-Meta: U2FsdGVkX19PUc4rmr2HdvcoCgk4MgrkEKVI0qs2S4gXlrRsdLe44qi2jyjrPmw12Ngf8HkXrGq6/nkvVrsCAeZqLscI/qrpQTOulAU5l5Qm8d7gKn9PRx/ANl1pkGPWRCAbNA4AU+T6TXpoZ9mzQzRchxz5qzdSV87lQpHX+SfN7tf83GYppxwMSbDgFWYkM4eIt/YdnXSitm+LpjYvbm9h9B8JHYZfMhsQYporFGUkgldGWnso+LADm3B8H/daIAI2AYJWmKIc9yZLJeIrztkRAzbUYLkP6EXPXWKq73afb8v2kWW/VCFqxvfkyBYUCTChF9S4ij2g6hc9t6k7Je0eCV6IaU5Xpf37w8AmNJ4edOCE92WClebwJWYvZdrYMguJ3gpXeUOFj+yDpIkbQQj1kPCgsCsXon7nOC4WWlNMq7MfkMzYDDouNb15RFpSqkiiALYRlujsq3uN6iepSu7byPhaSfuXnPvQU3KHNphN1vF4mfQqVNqSEw2H9NNPbMK7sFzdGWTtI3hKOuRhGNrT6g3+ukxjuwl4628QdniMBdhq65MjTxmcYS7py2OdxN45jZXzZI6/+EBmYieRh3gkgILZtRIxCDx6N4t1Gfa+iPxgIgkZRwoX9F6T96HSWlxVSSIVblRUlDPgY7A0iBmuToZ7CJm270pJQoTwZ2Nv3oyd6ITFHIuFEzLunjuzMvkX0nW+Q1Yb4WAhfYb2f2n4tC0kFSjE76s/SRoyynKjDaT6ciBQZXhsRCW/kO6X02ztsv3PiZujRktNyAspeq5jeF+j8N3kwDn0lAuR2+FHrH9jeJu+VM/JrNPVkEbzn0bRNJnzGKBKOhMN7kSSW1Zwy5ETG7ao4OZK6lp2v0k15vpgpeT4fWTYCAWxH2sO9DC008DwjvxMXPWg2wkAKl7uPgOlwYBhTSZvJP5lqtNocMjHlgCoX+pbKmjkNHql9b5a46T+CZmhBcb0gqh
 TxjqNLIu
 Gwt5FBA7tHB9CUHO4tzUIdlqIx7kAh3GV0elP9sSkEe2NSwjz9v6K+5gefwReWeg4yZDuq8UNUj6C4q80c1gZdH/Yy7yz7JriTaM9HOXAk2rxCipH8UrzxoJYxWTV1ll/8ayMzZCqKlKL5DfXWPB9rmgGB4Exeqq5aa8KeuGCB7IGnEDZhCIOl/lHE4UzpFrIE0ecUwVtWJLksjgOOVJ4k3CCBH59XN4UryhnKCGHXXyOSuV+O3Pcm6Ysh1T8iqpPTQrnMTKIeNAcF9/MAaJ8Mtdlz/tizvgPkwT/rP2KO7najH7Pui9n98KdnHb96i8MUzCVexqmsPzfGx/DCRuEFAUP8pmVN8i7BezeYdaXfBsCQlsGu2UnFhyoDySpNN6Go4fyXE1YUFSJxNUIwsmNkEaN+5KEg3wd2K+NTIHjmZqsKwnrq4RAsF+FZa0TL1z43WRvc18+uriN+6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Override the architecture-specific guest_memfd content mode functions for
x86 to provide support for KVM_X86_SW_PROTECTED_VM.

For software-protected VMs, specify KVM_SET_MEMORY_ATTRIBUTES2_ZERO and
KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE as supported content modes. Implement
the logic for these modes as follows:

+ ZERO: Zero out the memory using the generic guest_memfd helper.
+ PRESERVE: Maintain the existing memory content without modification.
+ UNSPECIFIED: KVM_X86_SW_PROTECTED_VM is guest_memfd's testing
  vehicle. Scramble the memory range by filling it with random bytes so
  test behavior will differ from that of PRESERVE.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/x86.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6609957ecfea3..e8abff71001eb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14194,6 +14194,99 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	kvm_x86_call(gmem_invalidate)(start, end);
 }
 #endif
+
+u64 kvm_arch_gmem_supported_content_modes(struct kvm *kvm, bool to_private)
+{
+	if (!kvm) {
+		return KVM_SET_MEMORY_ATTRIBUTES2_ZERO |
+		       KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE;
+	}
+
+	switch (kvm->arch.vm_type) {
+	case KVM_X86_SW_PROTECTED_VM:
+		return KVM_SET_MEMORY_ATTRIBUTES2_ZERO |
+		       KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE;
+	default:
+		return 0;
+	}
+}
+
+int kvm_arch_gmem_apply_content_mode_zero(struct kvm *kvm, struct inode *inode,
+					  pgoff_t start, pgoff_t end)
+{
+	switch (kvm->arch.vm_type) {
+	case KVM_X86_SW_PROTECTED_VM:
+		return kvm_gmem_apply_content_mode_zero(inode, start, end);
+	default:
+		return 0;
+	}
+}
+
+int kvm_arch_gmem_apply_content_mode_preserve(struct kvm *kvm,
+					      struct inode *inode,
+					      pgoff_t start, pgoff_t end)
+{
+	switch (kvm->arch.vm_type) {
+	case KVM_X86_SW_PROTECTED_VM:
+		/* Do nothing to preserve content. */
+		return 0;
+	default:
+		/* Not a valid content mode for other types, so do nothing. */
+		return 0;
+	}
+}
+
+static int __scramble_range(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct folio_batch fbatch;
+	struct folio *f;
+	char *kaddr;
+	int ret = 0;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (!ret && filemap_get_folios(mapping, &start, end - 1, &fbatch)) {
+		for (i = 0; !ret && i < folio_batch_count(&fbatch); ++i) {
+			f = fbatch.folios[i];
+
+			folio_lock(f);
+
+			if (folio_test_hwpoison(f)) {
+				ret = -EHWPOISON;
+			} else {
+				/*
+				 * Hard-coding range to scramble since
+				 * guest_memfd only supports PAGE_SIZE
+				 * folios now.
+				 */
+				kaddr = kmap_local_folio(f, 0);
+				get_random_bytes(kaddr, PAGE_SIZE);
+				kunmap_local(kaddr);
+			}
+
+			folio_unlock(f);
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+	return ret;
+}
+
+int kvm_arch_gmem_apply_content_mode_unspecified(struct kvm *kvm,
+						 struct inode *inode,
+						 pgoff_t start, pgoff_t end)
+{
+	switch (kvm->arch.vm_type) {
+	case KVM_X86_SW_PROTECTED_VM:
+		return __scramble_range(inode, start, end);
+	default:
+		return 0;
+	}
+}
+
 #endif
 
 int kvm_spec_ctrl_test_value(u64 value)

-- 
2.54.0.545.g6539524ca2-goog



