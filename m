Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B239CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504A56B00AB; Thu,  7 May 2026 16:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCD36B00AC; Thu,  7 May 2026 16:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4191A6B00AD; Thu,  7 May 2026 16:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 28EA86B00AC
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6615BC21D1
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:01 +0000 (UTC)
X-FDA: 84741747762.19.78499BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2DA6940006
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FpFMZbWJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185379;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=taL2ecH2eEGmEbLJu7pBnvf2bCp1j67KVlkaX9XJvtM=;
	b=qzfXNCLohuiAfVaunYAF3KiUQ6wjTb9uIoMrqotBwB7TbWxZ8eazG+FV4BuaiKJ29tFD5f
	uOKHX6XQDIH0GEpyPVA9o0FQ6pk0s2pMyukYZ/tboaG61kOBIvu/Oit2cXkI8cuAh6L8kd
	nybmf1EE34+8Ytt+zf8777uUdZXC8hs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185379; a=rsa-sha256;
	cv=none;
	b=Sxo8VKrIyehl06aJpgMsmSWUSjqh23HXG23FZJJQTsGnON/Vg6ssBXG0GBvUlobXOB1ati
	i1A1DwI1eJ8W1qggeEzEsgsHnUiG5Bh3LanyiYAJYi2ROnFaLo1joIWhWtHZ8amCdXPTOj
	jReiY/+CnXGwBngR1dAhHD47CJt9P9E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FpFMZbWJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D2B6447AA;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42C2CC2BCB8;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185371;
	bh=nFU8n+EuZ2R/OHGxhfKoYQeP+YAmED3Qqv+5RmJHkGc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FpFMZbWJR1goIcO0ikjo4QWcOps1xZ3FKzP5d7/UyrIMo1tlEAVreDCPaYLQyT/xB
	 7Qank9dbc5Ixo+EUzU+t55dxw2xIRBt5LS80C/cLJrxRfb4otgKQfP/5nbIA6itHGW
	 hhRbnPb2NPUuTSQuX4tqswCS7OVkfhOAZlrKEMhq4rDD6nY0WmqixfGOHIO9CLA/5B
	 iC6r5QHRsmY1h1UvRB0vSIOOd3sFZtQ0KhnK0NfBnna5HnDriQDCjNSZXCd/wZuX6o
	 2MN1M1Q5qvRnjf0v2/5BbM19VsTOHXmlIRqjMakosozANAG1xzXFF/lrUMsqLMa1jr
	 chiPhbawusZzg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3591ECD37A9;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:41 -0700
Subject: [PATCH v6 22/43] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-22-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=2365;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=X+BIxKjksp/CBsFZk2rW5woLiJqEQFH4gejf9b1F3p0=;
 b=y/0iAwAGnMKs79qyJDEhdvdVe6EtelDi87z94s48kFQLYzRoEGRG9ip+BoZkUyS23KX+sMMfv
 uCgtDJ7wo9iCgGkElLq/NaxDw0Kc1l8Lis3w03zb26JZZqtZGCgKKQt
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DA6940006
X-Rspamd-Server: rspam04
X-Stat-Signature: istxg8t8fm3j7bf8py9sf3o3wa5t15cj
X-HE-Tag: 1778185378-130964
X-HE-Meta: U2FsdGVkX19/tFg1RrxF/8JQsY62/i4V88jAykg6sRxXYDjvnt65BxPefrlhZBAEajmbbMAN8bRHkYqVtENOtCZ9Ve9hpGno9bIV3kFp9ls/eFGyfddmZQ6Cg3P1RmS4ka5UpPXCuklzhtZVsv9PZJip47uwzc3hLisAMs3aw1gAZ9OtIbc+4GHH4bb/BxwUgUV6rwVcTytIQBLww9M6zt+4ijjOwbkbgs9AFyOYzfpVfweBkVlkvBJMnEyhuT6w+fffjxvK4GgNZOPr5MGTX1aytL7+2gibT+526hEseZ1O4xMcNffma4JSzc78WWzKIyvuM3lhoroNaHdBInm7JU8aiqwPd0W+LZf/YN7k/BcQV859O7k4Sljvc9CCNOUl1KUxMvXvf0FjH0eejQ3beBBrMdFIxILciiLBLU9ydJt31OnBKb7dMA3SAomwNp3zsPCURxCxHggKbvzYfup0lw1PRR21pPBkGvezAMbPm7ZPsqLUwcpJvKhBcom2TVsVhCjSEONotk7ByfoZOCaoOMKD5/IWky8vYowQo3eQ5NjnqrUHsPnXKa+Z1VhtpBud8IQ1dT3lyLHK06WmPVhsi7HSJtc1VljrPSWlYWrU7tf3jbkqzdb6PoQBngj3t8BbL/lRiksoQp9g0BzwJZXrpAr6dlvlowY4QJRiAeuAmI8x2BdmXuZXyO2moWmHhEjuQtmmh7RSf+zpZ3SHFrKRRDNWi/Q7WBTPvn2YqyEAFfV4oMGsIiyOuTjGWVmb6TXdJ15SmXdFkWT/I/djOwIEkhxrXkXU81JdCTgRDTO9z9L9b62z2VCkUsoLB3Oo9vk1cHIquKwR2RNvtepkhErAnKazLL/h/vty4jOshOgt7KX7INx51jvpqrhWRH3EehEWsAu2KzEdoHwHiYxc9dyNPFf4dZX46NeGy/JENmNBZzpj9jkjVSjLl8/Vfpyt6MuqcdtkZgNvK5wgvHLh35S
 zKcvDLdC
 obQ6KXoaWFrMoVpsJraXEgeePcLr/WULe3CafGn6W0CTUiZi+2WIBYCK1eyM86WgdtxXrlOaYqNgQCc2Ikvz1ji6K8pH/CLiRstHwJ15lRzj7h+Bt2NYM+NbhM+amkS63qoK4v3Kzwcwr5I6PwpVoBQF8Hng6vv106HGjBHuzHVeeltR2xZHsV5o15mgv73ZPtJHEC0sXy+CXEL+4dCPN2M41OFfe+gZMyUdeYBbDDxWwycrxWjw0acyAWu3RUDd0Xtr+fz32ljHWyWfkwMwxwO/OH62sXsoaU9fP4jQT0Q5czLINzuXXSrgoi/XmECy7zf38VmzKjYTMgjSS7jDXD+Hfl4Amw1nPkfXqzQzLdm08cKN0dSieI1VbOGdQcQiHPsr/BhehTOUO9ok9rQAix22vrvCO8t2ZBIqOQzjyl1JfZosXiWRr45Hcx+vC7YGQeR0Xxx1kMbJA0wPfNEdC9ihgGg==
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
index 04ce321ebdf39..887896e42509d 100644
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
2.54.0.563.g4f69b47b94-goog



