Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 883D9C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94FF66B00B1; Wed, 26 Aug 2026 05:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9288E6B00B2; Wed, 26 Aug 2026 05:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8B46B00B3; Wed, 26 Aug 2026 05:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 588F76B00B1
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9ED58C02ED
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:46 +0000 (UTC)
X-FDA: 85142870652.22.AA3F756
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf14.hostedemail.com (Postfix) with ESMTP id C7E22100003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YOIM3Dre;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3c6-OagsKCGgGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3c6-OagsKCGgGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/MrPAwScae7SNC5gQ+AgoWAoYfkyZe7/ZGB+P6/Few=;
	b=GpBaLU/11lJ7uxChxbqiwtJSwh+gXfgr2BBBAmJDyiVCoDaTctse0hlCLvpa/8DaThyGK4
	QPt0aSG3hoDY0m8F1O3hCUOo8POFWCZqWsHYSjNV+wLECRbjDd4FR7E51AvQ++aHmv3kLU
	r6sLyqMiqWCt+p2ETYJgq4c5qwtEoEI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YOIM3Dre;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3c6-OagsKCGgGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3c6-OagsKCGgGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735924;
	b=X8AzdQO277CH5DSgtAAzP9jmePIZENAq7fa5I7nuENiXeoor1026lzAM0qAPKmGPnsOiAR
	VuSNT+MypYR0YTPvFUGv2lfMUV4WprKW0hdUoQ3Yj0lbevhDyTWqfKMCzuoTQfzldOO2LT
	aAGHYQCWeKg1KFxb/7kkwT5o3x6L0Ho=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc73f47bdcso10162545ad.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735924; x=1788340724; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w/MrPAwScae7SNC5gQ+AgoWAoYfkyZe7/ZGB+P6/Few=;
        b=YOIM3DregrALFpDD3lizoWd9PXCfjXvClGrokEnzfuPpDy891LHP9+CSXV5UQWQMHo
         Bs53OUakyLdDMTFQMkhoDRPkXud8mQBHcc5HRLtuTmGOnTF+iXmVecxlvZctJ3+pP8Cu
         YJL/5PNW63P5tRvEtMkeDXT5LO4npppqcC6KRm/OCZnXAjsvL9ZLpBqWj7EuNkE6K+5g
         WHEKJGaPO9XE25WS1IOlY4MGARpJ+4Uh9+JqwCxZzVJQSRlM7mgCMbbMttVd4NNrxiR+
         gElZbl2QV7HBHjhLmxoDrHjkMoHtVntyPxRmERZ/5vTCkkO+E66/2t7clRlPc5v1mXHa
         Wf4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735924; x=1788340724;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w/MrPAwScae7SNC5gQ+AgoWAoYfkyZe7/ZGB+P6/Few=;
        b=H+B38MnRgVcvFNd6g+f6bLy+VX48t+kuMXCxQqJYSusYXU7U6z+C69iEkB6MrQBZaw
         t9IxXZUD/GLy7LKZglbUkYJ44Xqq7nH8la6uv8V98LaUdYcjNjOvvI4YtYXx5TjNTkUN
         HDmWPK73IT34gxV35ooev49uV6Q91xNwwMUKn52r0MkK+14OpA78cdE+20l7tieLttfo
         89OuUkUBgRu3r4TG8PWarTee7nDN5sD01We6WBZlsnLDmKVjgliYG9FWDbmXAXlAl/pO
         39PvSlSCcqJhJPfIHt21e8Cb6gB4M/FeGukPIw6YDILqJ6TeLU6QTF+Lw5NTf4tKTFXk
         k1fw==
X-Forwarded-Encrypted: i=1; AHgh+RoZgfvtV/0lwbm023jb2XvNKsWVTNZMU2urlmvtUlODWJtdfv+qKuWMXngcbzB351ZGYUQ2d1dAfg==@kvack.org
X-Gm-Message-State: AFuF++keUatft0QNVFXZm0dJB6Obgvf/oBfaGg2LvZlGUGGl36kzKbWh
	zIqYak8sIFTkfyOY6hiJuZV8PSrBTy5/A4OeqWI+jpDIIiRSdaIGx+m2fz5L9n7f85MmurEzpmK
	LwQwRZGPsVEvoTl1SUvKENXc6/w==
X-Received: from plgl2.prod.google.com ([2002:a17:902:f682:b0:2ce:fc90:1592])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:4b24:b0:2c9:9a2e:dab0 with SMTP id d9443c01a7336-2d707954e7amr92849785ad.3.1787735923219;
 Wed, 26 Aug 2026 02:18:43 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:19 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=3571;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=PO2MNunZb9HZwBl22ORYDFq+/h4PeNVf9wLGFZFf2Dk=; b=COR7GFzGLu/psgq6NvdCH71Xw562i7ft3V4TM/YczzmbWiVB3kTpG3bS8GYlAlyMnzKrTQKrs
 8XWKHarrzHICgz5dCrSpg3pNIwENjmrLkU/Y5GeRNUx1eSb93bTXP7P
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-21-0a15d8a799aa@google.com>
Subject: [PATCH v11 21/46] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: gaoqqz8335ufm8je8pm4gtcfji75w1pn
X-Rspamd-Queue-Id: C7E22100003
X-HE-Tag: 1787735924-309352
X-HE-Meta: U2FsdGVkX18hCGA7dl/mh7sQn7o/OQOVkDzcjDMzKzi/mC1VTEfxNiNAWlgWhLZrj5x52sxgz6REYbWZQPzIP1cqlDP1+CxGKo4vsJ7b25yFkZMzpxBW1XH5bipvQ4c2f7eE1YL2+OuBJiHse5Hacu+HW0rcicBP/Q3WgmftlKHOfq4lwNghN9Go6NumXo5tobSCiPqb4r6+cIidppNvsjTT/ENChMg6VqUCtgNMrjMuSnaMUg96fdfT6uTIzOlIKqb4wvQTB2Nlt+Ca0XaS+EF6u2K0WfZ90mxW8Vyqm9zSK/G8IpfwReoUS/82OvGBgizRXsMz1QTKQe3PWkSR1EDzvQAwyAj/uQIHUH9N8s7pAdb6ik/E5AUptRp1ZoIFQym+DivjVP8YogcqSs5TRYStLvWHO0GgIkGq2K/b/CG3X8JWrJC2Oa7znJxvMkgJUBjTbM8TpZZEHHptUyaEwwHw60WJkp/elLDeBMCM2SHJC9GHpz5OzotGfkL9ZP1O1EWit7DkCflC5jTlpYI/JdMmUZmm3wJ4Rnip1i2+bAYlhg/T64HHm+pRCmQ4mGmcLblbNvlaQiI9989Pd+tRmdmARFHwgYn0l9RxAYy3rb0Xn9aFX4UDMOGA44JeILRVXrlmpajeMvvq8OSWVLUocMLUMNtp49fK0I7a1nlZr+6km/zy1IHgnBx/AvH0FUnGiD5/M0boj8UantBoyzhfE6LqKJiHMTLbfYASAoLwU2fDblsgYW3ZTJ51Cnp8+DemHq6x8yx7hAWfQz6e8Xd3RuRHsqGHw1qsCfq0FWUWRu0gF9zf37ig0zj6sMd7pHX4bnqBHUvJigolkUAMjQaNMyYWQV3/gbT1aK5K5YXQ+cp7SV1WzFT2kha6FAAPzm2aWFKUPjfgFEI0lMYTV1SQtymefhfSamOPMR0vNBS9kQC0i88ObBuYKeezIAvguD5Eb1QvKcZYSply1VFqFR7
 fSAdEFnJ
 8QpvaiIbULwVu6UQcPJGZJ7CKzAvSQzhr3AA40Zlm8MXqegJOEGlX+AjJ4M4lsG0mSmuTYHfwO7SCgd3NAnFIdW3A7nDGfiEW4Btoxx0RHLV3cxz/lArm6a0/wx/cBeFMKNw8eIiA735zYaO/rw0jKaFQQAQusD7IsO7Jnj9rvlqeUndRVWxj8ilJNv+CssU5U+A6+Tcch262C5/W8uO2vfuBVPAwzxhpWEGIpofHNR15PObGTHxLF24kf1STDronNi9OO1xSYfKdA7EyNjBagcEUKXTAOaRbP1EN4FtUGuaybbp5fLOEvzHbKpeQ67rkIEf5jLepDe1Qu1VGckvZ2r4aE1Iy2eBl9H7YHZk83uyV47QQdjElljrhlydmZkKelnZbKA7nGboD1FYazO0E4Pa/bZpEU/oZ/7kgPoiWHR/uG1Uxrrio6m4NRBbF+zijzOJSK6eAx5EIQfd7c9rtgnB9TwvfOpLrsc0do7Hv9hcvUcJXMcpLlNLqyCQQ63gv5zoVPruaGu3kf0vW6oXw0pLvBZhnH6vU65Y64Vlcg+XiK6Ay8xoo58/q3OP6JB3l8paAiOKuH3/uowjK3+p/2ypMfrmlTwfqmKnm+SmcuSconQGGlxNk9TXqIR0ZvOeZx8oq6YC0IcLIHGtk4lerGQO8bsuTwhd1aoziEowkQgk2hrWsCWWahkFMIcpU8wTyu/PK5DuZvleo7vmaXa2GmteOig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
2.55.0.887.g758fc8c411-goog


