Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB7FC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870616B00AF; Tue, 28 Jul 2026 20:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821B86B00AE; Tue, 28 Jul 2026 20:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715186B00B1; Tue, 28 Jul 2026 20:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44EA26B00AE
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2516120579
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:18 +0000 (UTC)
X-FDA: 85039945116.27.D3762C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B7C9E80008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fafrGgHw;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285316;
	b=Vl5aCjc/hQ8Mi1X3JQWy8POj9p6FsKMQ+EmYOiro/qfZUiFYZmao111QE1TAlzWpfMVNUd
	rzZ/Y2U+vohAt/RNU9Q/PAqutG2v+L9Ypf9cbkivvPTEv1alXQ16dIcgWUuiFwXy/JEVcg
	DCyfHJztD+0Xr3K3fOj/B/uRkjy6BKk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fafrGgHw;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285316;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D95uuzMU7YZOlwiWFvKKC+Vap4c6ItQs18ALb/p0CJs=;
	b=qy5aKddZsViT7hJ6TH812PqU2jx/qKK/kV7D5YqHxfhytk6Etrt4wEW33QGCWqkTnloInl
	ijZVii2tM3MNhML5d9FxMIejYxGLzS+7ZTEvr6sVGaALaJq0VCJ23YbiN+8ZV2dx+lXa4f
	7VB+135S10SgoVNOlmUIWeoZpmZb/Ow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC57A45147;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44058C2BCC9;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=IqnlhdFWUHpnNWtJszDcJMgyk9ygzVVopkaMMajTmcw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fafrGgHwGQ/Q8ddAuVFEygY75FEf6TRo2IG/hllgmjb80DigKd1QYzWVbTnr9bouo
	 zoIdSGPm4quTKHpYyC+AKvjMkxtwWKLoWafcxAsBUx13pAGQZ4VkoE5LEZOvRrU4qx
	 jKr8pJ/hOJ6hMFMOXCNd2oQ6AGixygPM5OuE1P6F+ygO7j/znErRsI6aRpYaZQ05t6
	 X6Pk/Z7QsT4CV8nYt/B8iE3uZCoBmzUH1esJoK8u30OtfcPfAvxjQjB5M85PTlLISo
	 TDnoH22gwRJZ7QzoSIT70CXySYMkAZIh3TJIzeO1kEId4wMvXfGGB+MroqYYzpso78
	 FVUIBqzMjy26Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DAF6C54F5C;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:17 -0700
Subject: [PATCH v9 18/41] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-18-35f9aec2aed2@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2732;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=u/tBFqV24Co3+T+1PQk77gbYdRZ2mN/NwHMVCuvTZes=;
 b=kYU9jorsj7ilMhDtf6dVa9SShPLBh3fLjuBuW3zW6XSEpNrLdYBWIry/G/7lWIatGxZ1Yorl0
 iDbhWofLj1nCWk1/f08pNwGlvPexDgipuzGdgcW3s4A/CdGkjkwbrJq
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 1tuph8xwkghxm9bposjwgshama14tiic
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B7C9E80008
X-Rspam-User: 
X-HE-Tag: 1785285316-222240
X-HE-Meta: U2FsdGVkX19S8p9ZnOAEk/GxIalubq3XVz5tcz/sHdkhFLDeZUa6+5rXSuLDgrhYy8zEtuX/1Bjme1Huung3Fz+JJjXnZZih7jGlgIqP9v01I8HHzBrLCxoLUe7tePnTWFocUGwrgjRIo/fhRBT7bgQBZ0+vqEzrCBzDDWUK2iqB77vjRlrpoKt7zVrDIoL0eYQsreA+8zYrm45UWsRsrmxj18Ve74pZpRQPBw64Uqd4isYCFmZAmJ5O2EdETlUi/jcaMb4t54kvaj2iULPV2r38mE7x/2QV+Za1I9D+XwFKLjliQ/Axwx1KFTvMrVoh7zQfLiRlC41ES+qDYWjlSfpAKmB11rg3YjvYr6WytC9aWTPl5Gf7Ag8HdLDT12COw1EUN15D89VXEkAp42v7C9kjiZVlYrbMOn+Z43W4kF+4PykgdtGqOrqygqcl92FN1N08dZb925+bRCHOwQJhFIek7vNIQaBUTEO0a3Krd/NwxDk1ZQRPJaRCurwbzPTjB+FXSonbGQjcMN0X5MWmjJ840Ppk5HbxR7BRqn3VdGDPFOF5SF3xfJ8RpKyhhiHvTx4JhQAD9XtouX+VtYJZJPjY661ffewNhRjvqu/Zml9drHtuBKmLjFzrLplaEWwnpr7NFi2671NFW9WKzYyNNDZVaLLYAKigdLYKPZ3BQErYOGJrNunYwide/vnow3SQ0mpg7XoT1Tbfh5hiZwIOH1AwiJ2p4ZfhjPYuBOJqrvsH069ym4UFEYcJTWqRbNhydf/rJUG5T5xo76Z0GGiTdMq6Bfx0hwMuO/RUXVOPRxIJPoIpYdgKLWmzZczA5sztiRiKcYN8mKFGBPjF6yCd6PK4YmWxNPe0d8COgTLC9ITbr/JMLm/ChsqxxbbqUeyB9Sn1YGJeOtqyVT70hQfzm/rcm/2qMgTSqszPLzGjChRlo07TTnDF/LcJnb8nec86l0mWCw7AU3hW26lEkfq
 gwsbs2b7
 //aK6Jfkf5uU6MD2rARZO7inqfsCdzl1bzkWRUxKXiim4fA2Rh58CRPqSDfwfuHYbUzmBovo6QFgBRWWJyINCFCoYTHFY+ThWPJsVBXlD4gRg2aCXCD3/5JvVQ5j5mLdnc4FcVTagJEb+16CmwFXa9Z5rIRo8XKtBtqNptJqtCYK4TEnYpz6Tg+SI9B9xMJxSuZb99djCOEjKpQhjEvACmUSsVLSZAPSFGvr++TNfyVrDzZkhnbYqg+IYB+uHENpLyU+4QJ7/xr9IqOmpMublgANfeCjeerkhcBj38LT+s2Fbga4sjEifqCIsCDGi5lU8FhlGwlwoDQr+zAh/p4zAYmg3MBrnXrQG/pGVB1r4qHcqZ72tIJLtsdnaEgUBCN4ELmuJCYFBvC7khRtD3JK5iUyk8tHg2F+JUtcn8KFmJezEy/qF3p2tPtnKdPWmF2KKL4ZlQhCtnM83bPQ6/hVqkddunqA9Rab9TmAKcOl9UeVWnqrntlXzh0DcRIs/ngxhZ8yrxq/H3I0P12uUVn9fpOdymkCLci2zjxA583Wg44EM0Ze/UytxbRkOWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Update tdx_gmem_post_populate() to handle cases where userspace requests
"no source page". To handle "no source page", populate (perform
TDH.MEM.PAGE.ADD) using memory in-place at the target PFN.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/x86/intel-tdx.rst | 4 ++++
 arch/x86/kvm/vmx/tdx.c                   | 8 +++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index 6a222e9d09541..d8d9409120e61 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
 Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
 provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
 
+If guest_memfd in-place conversion is enabled, pass 0 for @source_addr
+to represent "no source page". A source page is required if in-place
+conversion is not enabled or not supported.
+
 Note, before calling this sub command, memory attribute of the range
 [gpa, gpa + nr_pages] needs to be private.  Userspace can use
 KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d1af0a752e97e..e890da5f18aed 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3192,7 +3192,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
 		return -EIO;
 
-	kvm_tdx->page_add_src = src_page;
+	kvm_tdx->page_add_src = src_page ?: pfn_to_page(pfn);
 	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
 	kvm_tdx->page_add_src = NULL;
 
@@ -3238,7 +3238,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 	if (copy_from_user(&region, u64_to_user_ptr(cmd->data), sizeof(region)))
 		return -EFAULT;
 
-	if (!PAGE_ALIGNED(region.source_addr) || !region.source_addr ||
+	if (!PAGE_ALIGNED(region.source_addr) ||
+	    (!gmem_in_place_conversion && !region.source_addr) ||
 	    !PAGE_ALIGNED(region.gpa) || !region.nr_pages ||
 	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
 	    !vt_is_tdx_private_gpa(kvm, region.gpa) ||
@@ -3269,7 +3270,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 			break;
 		}
 
-		region.source_addr += PAGE_SIZE;
+		if (region.source_addr)
+			region.source_addr += PAGE_SIZE;
 		region.gpa += PAGE_SIZE;
 		region.nr_pages--;
 

-- 
2.55.0.508.g3f0d502094-goog



