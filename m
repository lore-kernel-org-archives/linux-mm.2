Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD26CD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD18C6B00B2; Fri, 22 May 2026 20:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B39196B00B4; Fri, 22 May 2026 20:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E96E6B00B3; Fri, 22 May 2026 20:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 730066B00B0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D25D92F1C
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:14 +0000 (UTC)
X-FDA: 84796772508.01.58AA7F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 40E6520009
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V986EZEQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495492;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JLx9oBo83xjLTEr2FX7REIHFvNoS+URFdhQQG+Nb1/Y=;
	b=T/DHJZwfNx0OQX9d8qH6FVcZfaCIBxndX3wusRl1MnFlOI/Svama34X3Xm3Za6ts5CXW80
	xOJwrbyGDtpGlXtrk3VWCLe2/I3Wyhj1L+OOK4A9gHFpwMUKStm3O/Ai+4Wmn9osQPEi61
	IT4nDX7snK0CDQ3fydeOSNU9r9MRP20=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V986EZEQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495492; a=rsa-sha256;
	cv=none;
	b=BXUGjibb26QJmCDuBZc8/WGfyLx0z6REVD3FnKX1E18jNXuejpEJhP8Ci+1ueoj5zHnlik
	XhtFBA60PednZOde13mrYCOXN0ktzng0cY/f7j4NUZq7wEWds1oxhzsgMfM3/+npZi/kjD
	4thEZopqXG7XrDoTGsMQ1QB7yvOSvJY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88473446F6;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 223DDC4E673;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495485;
	bh=ogWoFJG1xqOVuNn5At8aLCzY3s9x+4aiDZLPoOXtj54=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=V986EZEQYXm3rx8tOFs0dfC7rSmpTd2pAR8MwjiyGZYa3Jlh3D9cEkI4v4SQNe21+
	 k4nmxgS71+chx2X/iVBPR7OX67wrJ0LiAKMgDxtNcdEhcli8xKllZl//si3YeqbnOy
	 c+a0uzSGFmoZs26tFYYGYbpcMn9xlJ0g/XCXJe5CJo+i/GMMGpL+J0/3YjwfAPqP14
	 MHsuq+/5T2CjiiJUK7iAxsmfP7DojHFX6vHtv9eggnCryVPxbVFhm3nTm79xQ6PisA
	 qEoRJMDyKX5SvhN4AONTl2s2OnG9QfyF3hq/JlRfVsA5Ei9aP1IdV6wrYcG9iGyZgD
	 Ux7HJNSk2OMuw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0349ACD5BBF;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:03 -0700
Subject: [PATCH v7 21/42] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-21-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=2365;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=qEh0ecCMb3AtWBwHsBoDwlnjw7N0xSkCrtG8wLVz2oM=;
 b=wxVMOV4LQFR6IuShk6BvYMeA+aIOjFgxfoyY1Bj9fMQrdswrooNt3z4OVuWOY1PuEjk9DhYnC
 Eo89wKHhcY0CTMuHtS5FDVWu9cx9a+bkJKhR/bMgAEqQmn0JjLXWUfS
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: tugwkzxqm44zk68576s66qup6djakc7m
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 40E6520009
X-Rspam-User: 
X-HE-Tag: 1779495492-4680
X-HE-Meta: U2FsdGVkX1/eBXpNVm5W5ghPui5wcKed2R1HfpD3Ka0YPSnvPs2p9JWNL16dtuw7y+nwi/LqiokB09g5GyWxnTH+82PLCYqTzgYT22hMVSloVCarjupfLRg4fPRh91ZmgwlfKNAKuaId7cn+tnPoflcMt54jZcsNQawAaq3+K4cCRQHsyanu9GQsPmZsochrl7N7J2cB3bR7BV8XN69fi66e2VzIwMRgHIp21ikVpCxCbTziUBlVQBoFeY0Sh0lGgMyAAfBVPYc7nmpjrCRZWWHy1gMwkUyymAf8+c9w4JG8zhSbvaWihgY2QetB810+f3GtPB/U6yq3jEInkqPOMstYF3jtkLO52doX/A/yzwZOfvbBoCxLJOGir/xPy0Uzl9xr6ejZbUcKwTMjGxketLWuvkWwo18AvheNlGIszE7+taFSnS/2HfcHhBGu6kG7++v8u5pG2plzPqpV0TI2EfdHZv+OaP3N5tBfa2w9VJjpl+ruK7Gqx4Q/BA/W8pjEtKa+dABVYOlMJN6eGGJc3VH8G7acyve81LbqYIVBSYjVFSEhHkXJx6PeaI9pHNS7MXgEeL1eAJmwY5jDN1kaHN9aTi6oYfhEgEt9CAxafwC8V9BwURHyQDyQRfB/PUM8YNb016IN+P/6XDQ1IYSJ/W5ql7Ei6Hcl3oXRKn7vuIIe2ezDt0N9rHTyGVbEZOt4YjxhHbrIpgmBje8GHiVRGz4y6c6wyBH2hj56czBx/++f6c8DqbJEj+MUSnpUY0L29hCTX3zU0Ua1MPc5nxeDrn5rmHCrIrWLMavQ4LLpsKG1u5UiG2ty5+yumHhcqNcLTin96gTu2CRZw6LXGTYQQNk5ybAFbYXiddtyA/FKMXaYpbG/sfarkaGGTbZHS0ETqlJfthrJryEyGy8oWCJiZpFbi99TePtBpHJlCjY/eIM/0dfGXAEOykU24dKTYgSZ8Xjd8h87ASYtQuHxKhI
 3nVXNV2k
 kbAS2l7jPvtRnSRw/0CNnNUV4IB6oi5UjaAIGs56/Eh8WoqVV59LyC7vp+ZvltvFdD/NUMNSzVlp5TGWRYYZvZROxkTRCNNsobnXJla3+21jfcO/ank6IC2YDrCjDf4KeyYqF061caEdhpZZ55tjxE3oZO5IyRu0aH429aTKqCZXQrriWKmaTrBGZqtOuMXtL06ZsmOwjoIsrhYrgMUbpmJXtmt4oW8nj9Vo9vOqkxMnm9buE0AZwOFgIZwHvubsgbpPG+5Y6EEPuyX0PnusqDVE23MLgksnHMXyZE9JtaAHgJDLMImMvZx2y2pbOqpu72fQhuT6NaV3nLYiFE0pCjVXqukNKZDJIel8fysoFBun6ccllckjWpQQV0Q0f15XtvnI0hZo7sSCL9M0FybEgmBFzytDqPVsP+JE+ngITPyP5C60xWX62R6WRzvw+c3/jdM4kTNiu2HfvVSnAelamLNWSWA==
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
---
 Documentation/virt/kvm/x86/intel-tdx.rst |  4 ++++
 arch/x86/kvm/vmx/tdx.c                   | 11 ++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index 6a222e9d09541..fbc0f179dc750 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
 Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
 provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
 
+If memory attributes are tracked in guest_memfd, pass NULL for
+@source_addr to initialize the memory region using memory contents
+already populated in guest_memfd memory.
+
 Note, before calling this sub command, memory attribute of the range
 [gpa, gpa + nr_pages] needs to be private.  Userspace can use
 KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 00dcfcbc47f68..63c6ba30f05b2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3116,8 +3116,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
 		return -EIO;
 
-	if (!src_page)
-		return -EOPNOTSUPP;
+	if (!src_page) {
+		if (vm_memory_attributes)
+			return -EOPNOTSUPP;
+
+		src_page = pfn_to_page(pfn);
+	}
 
 	kvm_tdx->page_add_src = src_page;
 	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
@@ -3196,7 +3200,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 			break;
 		}
 
-		region.source_addr += PAGE_SIZE;
+		if (region.source_addr)
+			region.source_addr += PAGE_SIZE;
 		region.gpa += PAGE_SIZE;
 		region.nr_pages--;
 

-- 
2.54.0.794.g4f17f83d09-goog



