Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E27CC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008526B00AE; Sun, 30 Aug 2026 20:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFADD6B00B0; Sun, 30 Aug 2026 20:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7536B00AE; Sun, 30 Aug 2026 20:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A57B86B00AE
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E9F21A03D0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:33 +0000 (UTC)
X-FDA: 85159670946.16.A4FD6EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4786A20002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2a+e3+F;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135931;
	b=gF3AooqwetIKmyC3b/39sSvokvqPfD17jfWW+9dYEmtsRMJI/JS5wNVLqg7DuzPCLQPU06
	RXbZlVYlmnFvLagfe/7jnzjNXioOtvEQ4U7Vzz+3eFLyOem/EfGlJDCJJgdoWKNfKI9ARc
	0ouauo20RdcJ5rY2Dg9jhfyWZXX99nw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2a+e3+F;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135931;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S0euup4ZxZigvpxUH97psbIwZjWzdCOrij2JOT/oV68=;
	b=opZYFqLCir1x4ZsS6GgKm5bxnKY+cxC71i3S49icFQrs5tavEN9Wnh4vhTV1Zq9gT4RwqS
	p3L1CgpWn6o4X1h1x6EjenMZkv2QqUgXw0RBHgUa/R+RwGqatcIwUSiVpCAJDPe29bqTdi
	n12kJ+fMqnRqg4+OU4pOP4wtQK00cd4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA0884486E;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B90B9C2BCFB;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135921;
	bh=8shTrhUaGv3fKB50otzvqy15VrpXV2k9eT7uzPpO87A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=U2a+e3+Fu3IkwA9ogIkqDjTokD5Ywx6OsEmQ2dtf62zdCoCUC+CShxrFeKOox7WVo
	 QYUk1reCWg11G5xDMbfzGLtqejPe1f0T3f6GBI2dCzmzUczD9fDUf1nAb47E+FYffO
	 GR17qgNZyuRjoN5W6tnFeLHKg4RsmT7oo1GhBtgDLaIc8xobHymV3xYEBxPs3UUy5P
	 O8Z1WOItbP6G7q/T0LMvXLvPmPk2Cz4R30PJE7eNwvgiR3/3ujPgrTMUd/e0M4XUH7
	 j56lUxumT+3xRHANST2nTojscXUD/YxQgwAY6OEWsOmMSD7lyciIEhU3cOiwIdN8MW
	 ZgIE95nqdWNcQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B39C61DFD;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:22 -0700
Subject: [PATCH v12 21/45] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-21-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=3571;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=njc9wPSBjD6tmKwt2PhlMiU1O1S+4eQ2KtODaEWL4xY=;
 b=xet/UHJxW/icBX2JrNtGGU28LtYGzpL8u5/A2zHQu7TLEnsVz5ggJjGJpERO2fdfgD7Fxr51C
 ip40S/BlqIICNfbuaM0UoGpRZF7btZdQpGjyeJFTBr9EgNvYJ9H3K1t
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4786A20002
X-Stat-Signature: ii5rjok9ydkff7oq3r1gu1xj3c1batwo
X-HE-Tag: 1788135931-793815
X-HE-Meta: U2FsdGVkX19I+MtsFSylrduHqhwvLBjYs/ubAzv+HkyzrCFW1bOpUsbzk4lIwwRJo3fOWTaYx03N9jsx8N8bP29Y5eMBmbqbY60bHPhmi71djFtZk4yr4l4rRuAzmsYsjqKpDS5WN36b67N01bg1HaUEEuKFUhpejJPnfjojw3LWf+ZVbJsp49DjzWQtLBLMpodXm1QAdSPNH4p6FW5wxmdeTWSh7xAX9s0e366pvhCvQuGS+ZROZx+dxf3vo9wSVyI1CCo6+PrvdhzPK3d03m01EHzESKUJrI+ifFKTok364yIamWtVNeL0PV2iSZ9s9UgJ9XP0v/YooxIoTwkSvtA9dzT0P1MHp/b28fRuyd7obUjoQWgIPViRzm8xgvc4i4iMlh9mR+YdR1Y/pr88uJhYjLS4tpLhxI5MvvAcQQL8GNW3NYCKQAB4irknJ3roLrzzARBFO1hSPbC0kJm+USUgpRHTEV2H/mmfRlimefHMMxbCyV/do8UnbHqlhGQy+p+RO/IQFME+MH2xm7jUVI+jcqFbt2AW8n9KmB21DuPviHdwIxHdLXgxwtm5CDfqF9KryXFJuB2jsbIbHmoC9IekZtaRJkl3p72XrPOKAhPUh6iCXJcIsXcgUEJRSjmSJ0Ia/S3DS98bm3n/HUkbGvLKDecjQuysqlCBYy4hP1D09W+5vXSZarHS1TgWToHZG/lIEskY0viwmCeOnhiDkOW3Mjc0R8vH9urN5y1NutRBEfvRYGAqmZ84zkBzsjgFzTO276eBb1NJ87wPf2JTzaH8/HNqgj3oiLaVPFYwAomRRq5+g9Lg9FgvKATbP49j92VsgXAzwJh0XKXfYazj/I7FQkHGgXSSzXcLcqSvRtnW+ZHAIFgTahmVkS+7NmKeqfmPwgz11Q/RoOMAeIvRS0K23mimqTv8bnqO1xD4s+EZghtmSWFYl2Vx0+1z2SH4NhavhJu/5aGp1WTC22P
 nIYjDKvE
 o2iBO9Ds1oxY8ZjoQehZ9WANaB7grJTVvU3EWOWZfwwZJX0AMarIHH/WqLJmUwhGHmmdOZR416iQRBWRI/K0mXDUBDfBIBU+PchBau7+cslEmUZAtNDle849b1eNIXWL6y37ggLw6D/hB5kE64NgCIFLwkUMEi2JW17dLWshBYZuJ4f1sRhJUZCRvRStxtnvYguBj/rrFeg6PQl2VA9PIz3A2KuvI7jNs+7cAZCmZqcoISCj0gvXLb59bYasvdh7uL/H++RpddpI0vlvRfHZ9qxPU8ByiexKoLGBKvF8hxiZlHngeXl/ZMNgsmCLxXwGvDKzXxFZbuisOc9ANcT6WjHEkQ32MjbaXc7ZBv8RRJYW6WKtbnNeUFrHfXbZ8bBFgcYwsbeV7JttnIJwjGwC07+YWvCxDzV8vh5Pm4xZ82GCznHaUYsQQgXz34jxoBgAXWHE3mLENKqQUImyNpxxycWqf8Q7TyvPUcr6XH7ndIlOLNF25FAFrXO8YEMNXbO+caLGWoyN/dtQA1xrSOAuIk+ILS012128IKfJYTg1ehpEskg8=
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

Allow "no source page" only when gmem_in_place_conversion is enabled,
because retroactively adding support for out-of-place conversion would mean
requiring a userspace update for a feature that's being deprecated.

Also, KVM supporting "no source page" without in-place conversion would
effectively be an obscure zero-page optimization that relies on the page
being zeroed when it is allocated by guest_memfd.

Rejecting "no source page" without in-place conversion scenario is valuable
for KVM developers since it helps newcomers understand what exactly is and
isn't possible.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
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
index b272c20586a74..7654a9f5fa128 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3189,7 +3189,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
 		return -EIO;
 
-	kvm_tdx->page_add_src = src_page;
+	kvm_tdx->page_add_src = src_page ?: pfn_to_page(pfn);
 	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
 	kvm_tdx->page_add_src = NULL;
 
@@ -3235,7 +3235,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 	if (copy_from_user(&region, u64_to_user_ptr(cmd->data), sizeof(region)))
 		return -EFAULT;
 
-	if (!PAGE_ALIGNED(region.source_addr) || !region.source_addr ||
+	if (!PAGE_ALIGNED(region.source_addr) ||
+	    (!gmem_in_place_conversion && !region.source_addr) ||
 	    !PAGE_ALIGNED(region.gpa) || !region.nr_pages ||
 	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
 	    !vt_is_tdx_private_gpa(kvm, region.gpa) ||
@@ -3266,7 +3267,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 			break;
 		}
 
-		region.source_addr += PAGE_SIZE;
+		if (region.source_addr)
+			region.source_addr += PAGE_SIZE;
 		region.gpa += PAGE_SIZE;
 		region.nr_pages--;
 

-- 
2.55.0.897.gb25b4bd76c-goog



