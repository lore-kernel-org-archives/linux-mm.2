Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A29CC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049F16B00C3; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6EA6B00C5; Thu, 10 Sep 2026 19:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDABC6B00C6; Thu, 10 Sep 2026 19:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC6B6B00C3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B72A5160595
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:48 +0000 (UTC)
X-FDA: 85199512776.08.E526CB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B51C240002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d08CBpAt;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084546;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RY+98VB1dNFWEinehUTkXY71iqHT7ESyZw6wCN936DM=;
	b=6K3NnivzM0CY02D0rutblSxUrv7B5dryljXWOpO8Z5Dw/dwfq2VvMoS7IRMzXCRY68hgO7
	G4+9fU3DQXKGwA+fhE+UxAzC5MKmomB39k522ymRw0KJuMtqw3yHawx/LjCu8zyEbDCj42
	bqzplC2Qy6W5lpZROb/F7hQ6SAAimMs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084546;
	b=mlSMFGlW7cMGkZSUdIdSu2RMY0BSQnQK824nxsTXxL1oTZmkYCQCHCdsFsOE45HoL+E2lV
	nXQULcsKdenLhNCyFQS3jLXv6g7zB6h8cQ8apts9EaT96ELwoxV5VEFzHB33bheIhhObCE
	CdZpzYGR4iGGqLRjs34WUSqrS2ldAYw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d08CBpAt;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 193BE447ED;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFB85C2BCFC;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084539;
	bh=CfzAMfx4GHgjOXxmP7PfT00JqMeHfxuBkQgvrZljmQg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=d08CBpAtBmNP2BlwJkVAbHHv95WDPJ8uLnxrAxIYUd1/FhNMoHhC3aPVhm4oGqsEi
	 GxtuMnHU7R+zq91o/xbFD5Ilc9mPfD0skg5SfGGkqqg/uYuwV6F4iJrQyUIeQP18G7
	 u7tnZX4DvB4nLLnEoeNC5w54xNqwUkGOiR8ZfbVoF2TfDKWmgreb/6bSaWo1Ec17zp
	 ZK5Th0RoAAzbi+mQ4/mT3ovmb0/lJPxx0n8KJrp+jp5X3mB3t8ju6tgohx6vriYE6G
	 Ecl6kWXuiyq1AlEkTUCSM/wPN/pKxzDLCo1CeobopPtQgxX1NxM5l49hxCKFvuQ/cp
	 QhzdGJ2oVdDaA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD363C88E4C;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:46 -0700
Subject: [PATCH v13 20/44] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-20-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=3572;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=QQ75a+Dh+O5Bb+yAv7Loxc+5XdxMsQNqVi7/35Q15Qo=;
 b=akjC0UBBPebJpT/w6V0xNLQG0NczdDLezEKp4n0ly9NWVBSIXvgnLyF3dz99sbMsN70U0JSq0
 DIlboWrv3dfBdxOeSw5hFgdrjCYir0bZ8HNby5/4rjpmJ5PxF3AuXAx
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B51C240002
X-Stat-Signature: jo9shxazstzscdsyxojhjmjt5mxqfgiq
X-Rspam-User: 
X-HE-Tag: 1789084546-301130
X-HE-Meta: U2FsdGVkX1/WhcvNvsOmo9Quo7si7LnswXrbGhxO9IAlmQrlOJDeGlBEErE5xdM5pgBd+3VPlODJFhTxm7AznVbdAfmgIyNVrmg20y3ssLd735EfL12w8vcDB0XPL63q2/1xOFgkIn4mCgyIzf4ZfzVsNfx1YWVUnWw7Zb67OJNjBMABjNz56qux93bILi4L/XMlnCbASDuj9ax202b/tvQ+ZioB4YW/aFY4v72vJnJBV03eN1/BjLM9SLMPsstCgj11KaBSM5xZE0vGjKXlqbQDF04dVxcXuofwHMrI+qZcBgjU2DSlGLhc1NV4AD1DJwaqCMfAAPwiYFngGE54w4RNQINZuPgp1/7ze+XIfGyfVJiG+R9vSohEahIxYHogD6aDIzsvnPVbXwWNBCbP+alzblOb9xYXc2XD3O2N6p1Og11PiiSxqakkicZJKNDssNKcykvWNhmEAwZEd6KI2lR+tfbBwcFYhAVZaOqYp9a5375NlJLIq6dqEQcInbRuiuz8RHnyr7CQA9WayybiIisehlrc00qM3glgtOFq/FDlpXjfZf8jTvq+PkZQEez9Lhas4xWh3MH8dSnkm1oAWOC64AARA0N8dccr9oSL1NF2Okg/SO4RDEz3EqUxSr3jT7BWNBAVygmvO3dk1OrnklQ0SguV6/66KZ3TfpZ/L7DShE0e1lj8VLbZK/pYaeLHPzitbQU4XMQRJqbEjJrmqxUfRLgkY+ZIdba9EblEGl7kbLYuWlafzmotgaesKqs4ODCOHQCu3UvEq6JI17YV/tpbwlXRG0Z76wnOwDHSLzXelL2mZbytznaTwkltec33PzkvVC3jDFInm8+oq8EkQCUXsOKoRcpce2c/+8Eg6SQQMbrTSBIcQrS1KdBdGluXCnzDL9op/GJ0u3d3eZpMV+4v+bZ4vF1PSVjtwpX0PKNFv/iTUr3jGJhzdE3Mj4f3iNUSaHlgd+wAzl1TXTT
 z2PEOYfm
 3bZ/C8aCgh2cQJmUoaYETeKNegtyHGOFdHwXp1uzhtsW/5uSZR5QUk8g8WDEV/xVzaaSbph6bn9yiUMROkrDElIjXd0ekNQaFtQRELp6JTQJFbM5Gxalp/Sk1qde3Iqr9kxEfkvWT5QNQrBtbD9vQ4i/zJv6Q+MAYjWrh03Oi8hv/StJtNswaT1O/jONUZrxGmYeXDkNi7RES+XTP1/w7Ydqr7ZEgh322wHLf79xOi8c+BM3+ZLGLYw6cpLlFljNCdtU9Dn1AABcN/gMSn1aBY8KGaUxNNiLX9hJHyeX1W22F7BRIk3o2yxJ2C+mCCwCefdsiV1uB4gfVSkXlKL9glDKGOQ3cSuwMnPTUMLHIofW1tJF4vR9ff6DrwV7ti82fsgxLdshpdwZvyR4KFcFtyXmjPiesIBrDp7w9SxUUcQSLjPTJaTyYcwLm7OHcXZnSZv05gmXs+ls4by5X2trbjjKyask101Ju2tAjkY/1qM+GM2M1pQbcJKKsqqJ2yxld5CG47AqlJRKxHjkH6U1YEiRjMCouUEl3mMMzbTq0sszELko=
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
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
2.55.0.1007.g17ff1f9808-goog



