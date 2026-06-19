Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD091CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C225B6B00AF; Thu, 18 Jun 2026 20:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFAAA6B00B0; Thu, 18 Jun 2026 20:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B10286B00B1; Thu, 18 Jun 2026 20:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE806B00AF
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB2431A02DA
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:58 +0000 (UTC)
X-FDA: 84894784716.06.12E5548
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E9FC21C0002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XD0QovI5;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829117;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwHey5gT80xvCmEEqI2xtlMMpe5SUS3f2FpIcBKQwr4=;
	b=wDI8MgUdr51Ya4RXpxme8WhsrjKTqrpjOu75uWzjLFgARb/OARG0jJCMTd1cd8M7Xpd3BD
	Z4sTV8fUAU/1qqx5L3SYn0xkvs99mOlcqgbll7qo8lJsbI/854uj3ircHlJUclYam8FPje
	BiqcY43hIUdWAlY8PyiD4peLLeAhauU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829117;
	b=lBRsaKIQ/NmQXuYkomwZrhRO+1+QJkGUqf62C4FnaseeOH6ebwaP0xDRJxUOZcRkcPgU+4
	oJwOvyQh/qe3l7CuVqeBOzNnSRLAQ17+07OJLpfQLtsOpSYYFI7gh5E85nI9AysHElTG28
	yw8x7OnHWsKvyShiYI2WkSPV2yvVRdk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XD0QovI5;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5538A43E7A;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22BD2C2BCFA;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829109;
	bh=p7va5w5xNlE2a7hJ5+XUW7iLe6UB6a3YXdu1OK//7D0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XD0QovI5brTZP9KxvTpTkkRT5a8GZQi8+O+AmG6nwNYagbexhMipZoxaPVYF8YqBH
	 5mdSIpolauPmW/3b+Yc8Rx5VeLebfb5fhl3zh42KpwbCfUTRxxoYrVBWe0lRoyz1g2
	 bWrUDzW3yobMTuQjA9u9UVkvXzoap5oqKjg6h2X2zpwZJqpj+4VF5jQisdP/dCVug/
	 m53mHGpbA9kZ6u9+FnS34U3lZORwUeSSjLgN1dSRqRh0m+61q6mCXqmZy+GXH9/0Vc
	 mrw/z9Fsv5Mo1bX41zj5QWOaJswbQAvW6UmduCN5K/UbLwUdNMubIPtin7VI0yICPj
	 y+Q2J2pOt8qZQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15399CDB461;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:00 -0700
Subject: [PATCH v8 23/46] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=2428;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6rJv+YHW4nePLyJloC3HGpZyQ/li1FsOfmT6QCoGH2w=;
 b=dPwihyJ9f1Zrfqr5UrPyia+NCoVbxh+ZhEJEUZk/ws1dG42djTf0stcCVHk9S6mztwSEzUDyl
 WZJ5rKkdCk9Ahgl7uhYq6eajZfudNOd+vQnZIRHPB8jlpnUrLA4YpdR
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E9FC21C0002
X-Stat-Signature: diz9khg5bjqhjri5fqbqappmes5c9p1n
X-HE-Tag: 1781829116-464019
X-HE-Meta: U2FsdGVkX1/QUMN81POz4EO9M9tJAIKiLvm6Q7c9NjDSbtDlSPV1Zh6oQFv/9TQeXPPg3NQpRkMYUWCEL+JgJceUJ7sep51E66btUR68fKLYQwxBa6w3u2Rc0jjiotonaWSXTftssxCEVWCGCKTQyOdRp5LB/AHFB0AClpXvlTM5Vzq6JZaEz923gQNCnq1BvM1L7Q5m2FClrmUgV+ZenzDeMZJxD2jAvrLt9yS9Fj/O7K/wr1j+SCM2+cM66cr1rbC0cBW9bvYYhUxlAgXC/eFGzGa2jxvoqFlOfDhHrNc2aRfOhwZucqx8F2FwwTfvHc9KH9H3Ycr3IOwihKPbsFV9sn9lM2t3mNbaW1jL2X7/+uQL39SFSaTzuEnJ7iqv5OHs0pjiKjgS+++rdhElwhJ0zQ/xaPWMDQzwL6GHPwOwlCOsx9gyaFdO/65qsxvCuvj7Ew/7A7oJJLe2vKwaXoMW7SAnPvj9hz2czDZK9LuHlYgZD1RKYVSACS2V0XyzuBqMXv1ITvQHtp4y1TvFnWAahDZ0nKRWZyQfJmhKGcGURdSWSUFW++kKdjYrrWt7KTeunvpshAsETF8j3q4DpZHnrJ3hU4tpkYQG5lVIhEfA22BIrqyj5iDWBe2L9XqXQy39aA1JGJ1FlsZZLfvKc+KDrsXEHKZWDah1QtSl6NTLTfmhcJaTkHkejA8S+Vjt9LQQE0IL0keeZB0ertn/drCbTihgNbon+D112HpYAiUIGXvkGWWk67F9J4MCZ2ciZcS0ZmDhsLZ8Jwzz5ROyHKrsympX9ZweK5/y2ymo8lJcPsJQhGx6OKHtEf/FRILIo/0D7jgtF4KzwEQv3Qm76JZTSP2uAYxvYQmthaWDWQHeqBpqCb/Fho31/a36JsxyXur6gsARy/NoL7zxK143bW/MtFXjZ0FYICFSXwX4it0or8aF4JtgIEh2b6BKq9SrhBosh2eAYew+xIc5aPx
 p6SeifzR
 4tToE2rc95CVNwSn/a7fT0BSzgf3DJthwVNstwNhWr/SMb7LRFcDCA6WcJ2VXzT6dVtBC/PylcVU/fe+96vCf0bh2xFVd7C3N5fzGLDyGpxa9Nw4eye8Uqdwtyx9chwMezAFucg3e8C0n4mQV7X6daojsshUvT9UGSwim7OxssKrJE9BVgi/wzAW1svc0VGPk9IEPsBjtELH4wKgNazvg6B2SsQmA5ZN9n5rbs950Z2NSg8JyFnX2bW9U3EHM6EzdM9cdtzD4obGevF3eOQWQdBBXnm3UEb7cEOxpe4YcoknwjM0LKCohdPB+rOJmouewjLKPCK5aZSaOebgbv66DKGBwpM5QvFVWqsgYd90fxkn0+jT53YLFgHhYjMLa0F819upD7f6n7qJIPLeWaKR+/RH3j9rRkYJIZn/I2aAVSj6TBF1DoEqJR3VMefgyycO/IWowOMVUOfonBstGUz10R4zqRbsImNiBA84Avx7V13zmIuqOgSGSIel5/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Update tdx_gmem_post_populate() to handle cases where a source page is
not explicitly provided. Instead of returning -EOPNOTSUPP when src_page
is NULL, default to using the page associated with the destination PFN.

This change allows for in-place memory conversion where the data is
already present in the target PFN, ensuring the TDX module has a valid
source page reference for the TDH.MEM.PAGE.ADD operation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/x86/intel-tdx.rst |  4 ++++
 arch/x86/kvm/vmx/tdx.c                   | 11 ++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index 6a222e9d09541..74357fe87f9ec 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
 Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
 provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
 
+If guest_memfd in-place conversion is enabled, pass NULL for @source_addr to
+initialize the memory region using memory contents already populated in
+guest_memfd memory.
+
 Note, before calling this sub command, memory attribute of the range
 [gpa, gpa + nr_pages] needs to be private.  Userspace can use
 KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ffe9d0db58c59..56d10333c61a7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3198,8 +3198,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
 		return -EIO;
 
-	if (!src_page)
-		return -EOPNOTSUPP;
+	if (!src_page) {
+		if (!gmem_in_place_conversion)
+			return -EOPNOTSUPP;
+
+		src_page = pfn_to_page(pfn);
+	}
 
 	kvm_tdx->page_add_src = src_page;
 	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
@@ -3278,7 +3282,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 			break;
 		}
 
-		region.source_addr += PAGE_SIZE;
+		if (region.source_addr)
+			region.source_addr += PAGE_SIZE;
 		region.gpa += PAGE_SIZE;
 		region.nr_pages--;
 

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



