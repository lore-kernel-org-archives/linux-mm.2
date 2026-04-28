Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB627FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232956B00DB; Tue, 28 Apr 2026 19:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A086B00DE; Tue, 28 Apr 2026 19:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1481B6B00DF; Tue, 28 Apr 2026 19:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04BA36B00DB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:30:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73098C1D5A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:22 +0000 (UTC)
X-FDA: 84709548084.16.C24122B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5E2F914000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iqzkNOfj;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418720;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRN8xLFiSihNP/m/OQnh06YP6zbQ+pmTG2PJRF96Cjo=;
	b=oQJW+3Qhby87dCQ15HVQLPmdqsdhe4whNQgVgHvqBsTGU0HMybgWR+vjpI5QgFmdKLAXy8
	x+DlA1JIJE15gLknBfWz33wfAQFWSOOq/4n72LqN8eB5too6KJPyHnHqYwXMZNZ4CJ4+D7
	iJxWlo3ZCPlWkOq3o1+9yUNH8XWhC+U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iqzkNOfj;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418720; a=rsa-sha256;
	cv=none;
	b=y5SNPrm4u3/47wcKV25PRyadskdg8G2osO/zNk6N8nnw1sikcBxCIe3WtEo+879pkSwu2H
	2kfWqAKIlnDD4x0t9jHqlTuCIs9evinM9/GppZTrh3QpqZFJb/S7ISAzEhp6L9om9jaeoR
	pl2enQUuFzVm0rpIyaiCslmnyxIa+jI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9844D6111B;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 541E1C2BCFB;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418719;
	bh=yIQ1qb/5thBEPl1WW7+A4KzPierGynmKhGiUR/3Ml6c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iqzkNOfjetQv0OkOlMI4tZoTh+sRABN+hK+ANmOFw/Y0SQPFWkuEL1h8joP+JXUaw
	 holJDjTe6B+rq4XlfKj3mAaSD488WXovSxw7VjFVbkk31MlIsZriCcQAUobgbbS5+4
	 U3vufYnU831eYzE7hnJgsAplr2Sf/lQetR74SIaW6TYCvLC9TnTHOVdX1yhvunNxmR
	 sAZhmVuNPo8Ha+M+kQdBEXi3e+yI+rAc5yHBoH4kzECyKbbnVWSU33aaWelmlFVaur
	 YvVc8MESc7z18FYFcuPypzKc/GC7Ywh8zipYDdvDfBE6GhtkEphZ+kVUEtljAgqH/I
	 bH4JGvvE8VGtw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B007FF8875;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:20 -0700
Subject: [PATCH RFC v5 25/53] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-25-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=2077;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ZUVil0lCIwc17luhnyQSnbr0drwWGJzhuW+VIyBKAEE=;
 b=7+JgXh5IsJ8zEo/B+5TkhpuCJ+LAfF3PUrxanugOqLUqBAxiPXjz3BKUNbVG/YL3JTPBaLNVM
 Arrpar2DOqaCNzQACmKnSm35p43EbE0LBLcBBsBuSJO2Q79UgEO9KPL
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E2F914000D
X-Rspam-User: 
X-Stat-Signature: tsnfddd6fa79omrjtfxsh3oj1cnmwjeu
X-HE-Tag: 1777418720-176474
X-HE-Meta: U2FsdGVkX19WWAG5O4A+zn7tHrV2HXNkUPy/Om/F/cdipFzvUS3vrhu6x4LYB883EoIyldiQMSOSvzVnWxgjJdH8sGPUmZ3MSktEhZ2+gKOhAcjWuFYo4LDbp5qdmi/mXmL8totR9fbf95/aEgAd9n1/0IpgVw3FC+eQZ5LeVo3LkFa+/JZF01UG/INr3izROAA17HVBdeYCWK7VtcjJ6n0ToruxM+/eBZfFrGRgw2R6OVqKZ4qTKjlpO42C/rCcWJlaRqd00ra+v93BqavC/LxWkA0kwSZAkqsSDgSwP3Ss4dr92UYWNaIIQQO3qrY7V+wn3SWROogK2pkL+5ApQutttzM9XAkFYXjN3lRlltFoXze6FfSKuuY2oc1eb8MM8pEOWB9/vE5uNyy7FIliF7HVGvFoEu/t2MGajhf9IbQ94BldLM7GzRzJv4Jjel5OD5743Fimks/vIXw5UF+M5264gimsPTiXujF7Hw/AffNn65516TfFJ3EeIYDJa77QrbwUx/rn0+T2hWXM89rmyPwG5P53U9GICcGZ2sxMJU82JokKyS0As8LfM9aBzQQcZ8yQQgUtI4ukhSaDZWxyU/eSdTIgufCDgXLuQX3dWR0MDhVtZEasqGb03c6EwECkzKvW9GhdsCS7CV8flD3U6qONnmv/+1Nz5oeVkWGjEt53S2pm5KpRAbmIRCKtjJTReu9sdmaL2KNMYizfVVIuxxO68GPJzy2sJngr/sX61S/gy8gFN6w4+96xwviKvATBq+rZVvH7bdLTeW98HrXWJ8cYzVy/389EHExKRsWOU811TarPmOVzv0HPnSbo6078msOtLRIgAHAHHOjPTE8HAXIEAGtXOpjVa2f65p0BE4jbNHAWNWarHjSzMYH1+Xi0WtVjKN15nYS6fkXPD31e48EAFvBaqc27wBifw6+CZyh0a5PFuh9j5E8vQd/zNKOl8irSSDsu/l1jYHc4Flb
 2G0bsGWu
 KOR7E1UKXnd18BqB5fTelVzO91b1JzHJa8Lmd3ADyF1zXagIZZW4Uw6mMzUKNOiMtjwduAEzsCZ3JcLPFarIhWPkog/VMr2HSObXsBKFJz/TR5AI5FFnATn3vHQzup2GdYX4jNPLlBw0FtzvLKz6aAZOYVjC14/oUqxzRfdbZ2Gt0aDYcYhU+QklnpSCsKJCsbv/37td9/gkw1YZAY6bkGh9zvCiqDisATQ6wacZSRDk9wu2LL8lPgQ4uByyhCHGYPNPS2vWcWP4qAxxdjCHR3wUeStfU/atTCbSPG6WypiTozo0KDDCcmayTuS7n3N9ZYYEBrQxeRumfdIspJBu0MkALHUR0pGgOu0/eHMbmzWrmiicpPZo8bJnK9u2N2UfqQ8hfj0Kco4EifdCxx9WSorJPc5Kn9RA2vv8KcMfCukdVxIFeK0A5a3/7aZF0DlhpFhoLoWmwm0oa67vHPwH2Qfs/Gw==
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
 Documentation/virt/kvm/x86/intel-tdx.rst | 4 ++++
 arch/x86/kvm/vmx/tdx.c                   | 8 ++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

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
index 04ce321ebdf39..10373e606242a 100644
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

-- 
2.54.0.545.g6539524ca2-goog



