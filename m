Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5EFCCD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4812C6B00B0; Thu, 18 Jun 2026 20:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431E46B00B1; Thu, 18 Jun 2026 20:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3216B6B00B2; Thu, 18 Jun 2026 20:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC0406B00B0
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 452018CE17
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:59 +0000 (UTC)
X-FDA: 84894784758.27.E64687F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5080920003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPlGqjqD;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829117;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ac5UcKNS+bl9RiC1h40yydQIpG0O8w2o55SydvFXafk=;
	b=7j04FSNkWqOpFVTEC3zTDp+uXFzqITwHBgD8jxUe1/D/kkKpLKumDJ+8F2GyxB5klJVPQR
	/o+HnhtzSX5bSitcdXuCSYLF0CHgI1SgNDLIxn57Qt+NvdmUkxWSb64JXgUusLZ8A4L40M
	6yaH8jDPk4GhzFbGnlnQuTY/sjTJM/Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829117;
	b=U1zqR/YD7wH37VKukD2yn+x6goZ8PqVaKylTBA8sI4YUOEoD36XVdx4v1flmTU1lg3fL00
	yzXUTIVpB/Q2H/h9hlpKpD4dM+kgcrI29AfvnfZZThwWbsHPAMnPg6LNp5kmyn5dsHLr0D
	nZJ/62yycqc2bCggrPxEfN83oZT8Wkk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPlGqjqD;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62FBC43DBE;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36D5DC2BCB0;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829109;
	bh=fyOOtYfClGp09cjDKzYjVc3evf/urOJQVD3GzH69oRM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TPlGqjqDI/PMYxZn5xjOYwF7kCayjYwZzXjWtCvfQBBsR+o5aBUNHa8P0RtkelR5T
	 njG+iVbj5faKb06+4r5OgWAOaejxWytg8snWVAne03bxp+tLpRNRbCkYcBO6+JsB4b
	 sx7FYlXH22R/CcVl5HD0FQgB+iOmSfzyAri9iokTLLktlf53uFwjduL5zrqwUFQGHZ
	 DKf+tLgO0pNo/7Ef7mzlJu/YwiGdvp0ZdPac4shTpWs6ZrelZeV5MOqOcum8XHGTio
	 tX4UAG/oOSaEcDt409fdpNxFbxRA8VISikCTBNlkcyQEta3GyXkaMr5wuWQTEe7vrv
	 /1UoZpXReqNmQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1FDCD98FE;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:01 -0700
Subject: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the
 default
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=3290;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=PRIZz/MUEDcYpJgxuI5DJhHZ5hfaG9jP2sr46JVINBY=;
 b=RxWU2Nn3vTjbe31iLWemaFC4u3fW67LS6mTsCASZGW43syFeZcJruijQ/SaPumweB4lztWXkR
 KKo4Y/vgPRQCh4wCRuGDPhwjndAdVzR8opSq/5IR4MMrz5c5YObQXT4
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 5080920003
X-Stat-Signature: uz3bmg7c4644uwuin1s179x71rdseuao
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781829117-729746
X-HE-Meta: U2FsdGVkX19PRph+fh8JK5e+wgdh0KDYPJ40H0cw5/y6LyiApO1eFlZKsAk3pYoac/rtG48E1QoLKnf5Vq7jyGcEbtqZPCwuP5zErjuYn/0O4YJJrNTERuJO/0+WHoTxvWqFl61tYMIReUh4V/ES5pHFvO/KjNNRFQLklVLBAMRKG1YT8v5/45e/MGPu5tzRX6dTop4Cl85qo5zNH5P1LCEoICIl15pinZIasYVsxBHuuFYC3U/Nd4i9SXt0tcwv8oEbmGPqU8kCZ1/gYoBHrQIDPb0zTlXupiCJ8yHhNIGgThZcZg3HGzU07UB3yzeIKFTIUKPGFiP1LLBt0p9v8XuCdcfEBGV9E3jqxYmZdvC/XO5u2fHUEmYQbNKpfzzDjAhI9r6vF6762fnlNfrRUZBg4O9ZWtScAvUnWPBM5p/tvGhob7vTXVFBwMSON9LySL/7biORpTJraNK1R32b6mspQmvjN0wQjVWRPZH7n2QhrTRUNEv+3A20PICww+koDLsx3pDeDzdIhzXmfI5swiDETZgeY3Q6DqaTG5EMZ/xTlFoXUXfpau/jiQUmAdMxREtAUDGy8k6sa46w4KIgH0ieDKaCt1e7WCl1NVYwlMcOoDjZSkfGDoKpVB4igJvp0bDI8P1KQ/kEwIlZXahv1nmpP592/opStCpuF63ri5yoDAMRCcLIKmratcOeMvllChUHRxPfoHy7yi63kR3w5/LYWhyC1spAnd4Hi+Frnw/0C69EErHt5yhC3ilfdzbSrpkA0t1hHxzsZyVKDAiRD2xUN67+iEaRHXm3nhgtOdtJB0dwbgzXH01O1aDGvpMbo1UpQjmSZTRQ2ju1DD97eQQHeW64Ywi5EUDDF5ZFh2htKianE5F8Y2dbvPInQjCP/SR9uExe5LjSKt1/adaZOg1Sef9WTqRpa5Y7SoQh+/XFDmrh8J5fwd15COO3IU6SXIqoNEep+LiO2/Bh5hK
 TyP1nWxg
 AYPCyQEuRn1DXz+ABMALaE0BvtQ2de0PsOBc7YdDqKKnycQFiGVwlzbV6ML5uYYJpxQN/x06Tntei+euEDOLumHWRv739ziKUBKS/Cflxw7qVsXCtSq3JhLCJITUdnUIh9/2TwYwLfjmtvLTjRjN9byx2VC5V41X43tApMNMwipE8Yy4YpzxAwULuyljkqPWAQVBZgcfgFnGJhdx6iLD/BT76G4k6MXJuVwMt3bSZOzMtT4slrFU7Z+Cp5I1fkRPoQvK/5UTyhjTA384tN4oYWMION3dE3VLpQozMP4Vly0JE9e8JtjaGntWDVKaVi5qL5lQUikYayKpsn7UzffnJ0Z9f1SB5d9x34g/2i3AIjTqUiZM8gif/wreHEVOFOnSa0tqk2jUuRy5gC500vWvsOTUwFNZLdHrcGgIJ7KW3di4Rmy5RfUAoKBYy6nxvz6EbtgVVoEh6BX4w8ZCZt90iKDaKGOW+vvbb6+y0+N7wVrQZwTrGFDGdvGq1Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Make in-place conversion the default if the arch has private mem.

The default can be overridden at compile type by enabling
CONFIG_KVM_VM_MEMORY_ATTRIBUTES, or at KVM load time through a module
parameter.

In-place conversion also implies tracking a guest's private/shared state in
guest_memfd. To avoid inconsistencies in the way memory attributes are
tracked between the per-VM or by guest_memfd, make the module_param
read-only (0444).

Document that using per-VM attributes for tracking private/shared state of
guest memory is deprecated in favor of tracking in guest_memfd.

Warn if the admin sets gmem_in_place_conversion as false when
CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not enabled. Add warning in the code
path where guest memory is populated for a CoCo VM, since that's the
earliest point in a CoCo VM's lifecycle where memory attributes are
queried. Unlike other query sites, this site is exclusively used by CoCo
VMs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig   | 7 ++++++-
 virt/kvm/guest_memfd.c | 5 +++++
 virt/kvm/kvm_main.c    | 3 ++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index c28393dc664eb..a3c189d765150 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -85,7 +85,12 @@ config KVM_VM_MEMORY_ATTRIBUTES
 	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
 	help
 	  Enable support for tracking PRIVATE vs. SHARED memory using per-VM
-	  memory attributes.
+	  memory attributes.  Using per-VM attributes are deprecated in favor
+	  of tracking PRIVATE state in guest_memfd.  Select this if you need
+	  to run CoCo VMs using a VMM that doesn't support guest_memfd memory
+	  attributes.
+
+	  If unsure, say N.
 
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 86c9f5b0863cb..5cb73543c03c8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1193,10 +1193,15 @@ static bool kvm_gmem_range_is_private(struct file *file, pgoff_t index,
 {
 	struct maple_tree *mt = &GMEM_I(file_inode(file))->attributes;
 
+#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 	if (!gmem_in_place_conversion)
 		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
 							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
 							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
+#else
+	if (WARN_ON_ONCE(!gmem_in_place_conversion))
+		return false;
+#endif
 
 	return kvm_gmem_range_has_attributes(mt, index, nr_pages,
 					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dd1d18a1d2f68..46e92b5dc3804 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,7 +102,8 @@ static bool __ro_after_init allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
 #ifdef kvm_arch_has_private_mem
-bool __ro_after_init gmem_in_place_conversion = false;
+bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
+module_param(gmem_in_place_conversion, bool, 0444);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
 #endif
 

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



