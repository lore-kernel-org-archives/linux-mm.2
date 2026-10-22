Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59785606A74F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QfDXGiwI
Received: by kanga.kvack.org (Postfix)
	id EBDD06B0A45; Thu, 22 Oct 2026 19:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E956E6B0A46; Thu, 22 Oct 2026 19:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35076B0A47; Thu, 22 Oct 2026 19:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1A926B0A45
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D37280309
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:20 +0000 (UTC)
X-FDA: 85351853160.15.73EEFA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1E2E540008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QfDXGiwI;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711698;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9Em7JiSqBxr9vQHe4Z5P+Gdy/l3yPJpaTZ+MCrLk0M=;
	b=p68AEbRU7+BVr1bVQ+u85YVzJddZGKYvhZdjhTf8gglXNYWHb6F7HxFfVguGoVWhiNlKUE
	CPg9+QMX50H/2ddCbh0Zr09QbNjyw9+YcWFsmS6yL5AFXbFVX7WCAyqVg4L0XH4ykkM8qU
	New+8Y1F/pohAXuTa8qx3VDGmCRzeS0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711698;
	b=PTVvi/gIRDcKRGvcMGz4RlHO9kLEIKr8wodCFhM1jLSiU6Erk8mPCs3s1JyiXLZizO8wMC
	MlOGEgTL/cc6q6PDEitTtLwbV2aIk/eBxgHr/qXHnPcdJxKDxmSOMnOR0sUaX56BgErH4P
	no7BTM1wMjvAixHzT+YLSdl+66nqcjY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QfDXGiwI;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3423E447E7;
	Thu, 22 Oct 2026 23:28:15 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711695;
	b=z4HGCd754ubFjhB2SXMctX5pKmanQQmL5V3liJkpuHfSUrdaHzvF6lwgHYK1+CAI9Bap
	 utLAo7kXRvQ7W8uwUP3q+fL2+JG6OsN2XZOxrcSAlr5MTaAaqBxKN0hEQmFiuCIcP7S55
	 JxVlv/GojqOitW0legOfrNb78RV4hC2Ze+oULSz02tAoHLePdiNtTkDti3HTxtsKFAsjG
	 v88V/3fl7vF2tIEMv9hsr5yZxn/xSZdTjqzTAqBQk7mJgJwBrQR/cGu5s/Udjt/DWD8F/
	 lBFqDob+YuCQuSJ9p5Nu0C40loaCzlnI0qBNtQuhn604MfYSPS0OCigMc3jIhJ+2i+A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711695;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=s9Em7JiSqBxr9vQHe4Z5P+Gdy/l3yPJpaTZ+MCrLk0M=;
	b=UIRYEe7oAY1Dulf46HPRvi8wPhv/1cS9w7ujIiaYmCY3xsEZaL+zJVa9pJX4FYth0g0K
	 y8GsT4/78OPHnfP6JiX0UPFljVOqNcDvJKIQ0p2dc0SlFnrMBnbx23S4l5o36KNdNH50C
	 ISnAm3JdEa5s4VRcr14qax9/yNXyxWBEUpgIrWlPWmlqz+SptLqackumitzqC8AIz+zE+
	 qQNddftk7y8E9DCLkjJuX/cQGwe9vdTZpBykftQJ8LmVaX2kQPxK5Jkuyy8K7gMK6aF/n
	 9NuXvLHGBEHB/T8r6Q5V1FfkFG6NK6+XXT4aTlKWpPrSQ+CVptGnGcxjErnUNtGxSlw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6645F1F011AE;
	Thu, 22 Oct 2026 23:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711695;
	bh=s9Em7JiSqBxr9vQHe4Z5P+Gdy/l3yPJpaTZ+MCrLk0M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=QfDXGiwIL2vXE1Qz6N7peoRB395dEJRZAdji98jnW3XViH0klGaA5LbehXvqrB2Yw
	 ER+SRAIhfZh14ccpKSg9nzIqY88wFq92HF5f8PUPNnUTIYQqoSJ6MAA/FmCy/FxGwm
	 j2Z0DrX9cLS40BjCYcmGiNfoqn+bt29BjN1g1c3Ogj/wnFRrK0AZrnQ4HIJJf7e3xu
	 mFRnrSKgdAFLOM78vhDpr9eHumZk7WRzRNhPcRF7wYADGFL1yarIDX4Oahf2yW0fw6
	 hCyQPv5luyZ6JHGDnE9fK7ITHLQeszbtlrS8eeQnLCGpm0KufmpbBgpVc1PLzF7xVV
	 R+bPFO1WNkkHg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 99306420B4;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:00 -0700
Subject: [PATCH RFC v2 28/50] samples/kvm: Make provider files independent
 of a root pool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-28-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=14373;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=XWrssdqecvYTeKbgOR3E/4j1UfbxSbeVXECooite7yU=;
 b=i/Iy61ZCwiUC4kTb/Nd2/YuidtxPfYUDIcAa7k0EK0jeHEpNScT/4csBpKeRZOHryQhI9hDAR
 ab5BeDMRwsoDUJytRerHVs77xeigY7Ns51BLKpnAXvyE0vyMYtf0rBu
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E2E540008
X-Stat-Signature: dxwn67wgdd3r9euuqcj8pamntauuwktc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711697-675634
X-HE-Meta: U2FsdGVkX1+8AjNC/+Elc7n47OFIZHH1YzIeFeNc51cMY6yM0B/CO/kn/Htgdk6aUZTznqDtmyWaubz1/TFz0LfbGj6DTCm69zcvh+mB5h7c9cohtUKfOaefxTHPFZZMBHW1FZTr3m/yQyakjxZwOLsoDq1KSIATRMjb3haeLa5zCbXlZ+NBitlgmkAXjEJP9I9xN8ITXT94/gQu8pwvSbGNT8sGJaPSn9vToVRje1RZhkqTQoSY0YwY6QzBNRsIUgvk/lNjkUKyJf/Mf3b7/NW4+2QJC5fAG6ETa66EavFpm79SfrIOR4q9EmGq2k+s8fdk7fTGBPTI/sWTKV7QtmHoSQJThxGBkOZwEuOFwMD4x9SGmTgA4cTAv+o6VG34qPnZ1locg75QDjqaY3MQeHJ35Xk4f7lZc/pZnGUSKCLCROQV8EQHwd5RpZzDkvrModwcq7pDlB+XrOzPt1PTxgJnjhtrBl4/Zfqu01nLzVGFFxFhu27yoDbRuzEXiwo9g3etLMusY9qg30OdQY5juqzcnQenUAa4g8T0kCKV9q6NWFnDBaHynnWEFwZ/mH+EAyrjN3mWygpWMr/OfxHm7/+7/tYwauGsjZGpk+nEdHw3L6/W/vk8DcJcNPpjcTnlHbsCPQV3kS/4hL+SjU5key4RKmS+DYyarEIIcqTsf8hXxsN2qt1rDuBFCB2urGCHA1Ycr2mKTBuRHfJ1htUhd9bD30f2J2I4oy/EUb8DR2X414oc1Ackb5jyhxfF2coHR7Zl/xoXC84ph6fpFqr/ioX2m+lO7B/PFZAx3P6t1zWVrG63okat8ruGm3cDm4iahDeevb7MsO/I3/E1WyrXGWxy86h6hPyOxEZCxVkbfCxFpFdEpOImew8pPbpqz8bOPlVfE6wvP90gVLanbdapJecX1xLPFA7oI9IkxcSKiyUPH2BFYvI23JBLuA4VK/9jeXvgkJF71RetaK4x9JC
 EZGcOl21
 IoE7KbueAf9GZdeRm9wQfsfuCrRIGADr2evr0U/8V+4EumzYhR9mVkOXH3+fkOxr7cXk7Pxmx6vRL6oS7rHyiw1JBbMUH8tsv+NaFLOUjz8nD8ucfeu9PQAd71kRZmQvmc8xQz22caQ1F5ZF8cJxdPJ5drBvkL5UDNZ6sLloTMI/n+9ifVMXttr6q/NNP/trtTUTFqcktUNWPN2oMEq1+1N5A62mF8kskkhwj5TKzfi6MYGsctTrHabtntlLlNUjfh+mVlYV2PHm2DZE/NKU4jPYvWt0NFDCCaYZqRT9lrb/jm7zu4aQK+Ciu2PX+zT8xf5R8IrOXSuSy54n5fRJz6D1/CDWRbKuGLScm4nBJqcpU8LXtWIBCivmOFnf9fwdRDdzFXK3gqoXy2NH2B5XeLtF1wqoOPAJKUgsOdqMl3QyqHStnSZXUW6PPJMdw1BtivX7OL2JME+t9S2g8symZ1IM5lsTjU1UpXLkq15+iCwjU8nspVytcoo7HgydB7VAlk3r5Jd62F/aPJ/XL7Tj2p8ZazlCSPHR9iVUhhbzyMEd6VOWdWuWhNOSRLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Remove the root pool concept (mps_root) and allow each provider file to
directly allocate its own contiguous memory range from alloc_contig_pages.

Because children are effectively independent and no longer share or
transfer ownership of memory regions, managing a global root pool is
unnecessary and adds artificial restrictions.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/kvm/mem_provider_sample.c | 264 ++++++++++----------------------------
 samples/kvm/mem_provider_sample.h |  37 ++----
 2 files changed, 77 insertions(+), 224 deletions(-)

diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 294b2d65fc29d..a8d40f3c631ed 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -2,12 +2,12 @@
 /*
  * mem_provider_sample - a sample memory provider.
  *
- * The module owns a region of physical memory and lends it through child
- * files.
+ * The module provides physical memory through provider files.
  *
- * The control device /dev/mem_provider_sample creates child files.
- * NEW_CHILD carves part of the region into a child file. A page can also
- * be taken away. See mem_provider_sample.h.
+ * The control device /dev/mem_provider_sample creates provider files.
+ * Each file allocates its own contiguous memory from alloc_contig_pages().
+ * Pages can be dynamically marked present or absent.
+ * See mem_provider_sample.h.
  *
  * Confidential VMs are not supported.
  */
@@ -27,43 +27,18 @@
 #include "mem_provider_sample.h"
 
 /*
- * One child file.
- *
- * Lock order: mps_root.lock, then mps_info.lock.
+ * One provider file.
  */
 struct mps_info {
 	struct mutex lock;		/* the bitmaps */
 
 	unsigned long base_pfn;
 	unsigned long npages;
-	struct page *cma_pages;		/* from alloc_contig_pages(), or NULL */
+	struct page *cma_pages;		/* from alloc_contig_pages() */
 
 	unsigned long *absent;		/* taken away by CTL_SET_PRESENT */
-
-	/*
-	 * A child of the root: its first page in the root, and whether it
-	 * was carved out from the root (is_child).
-	 */
-	unsigned long root_index;
-	bool is_child;
-	struct list_head root_link;	/* mps_root.children, mps_root.lock */
 };
 
-/*
- * The root region, owned by the control device.  Changes of ownership run
- * under @lock, which is taken before any child's lock.
- */
-static struct mps_root {
-	struct mutex lock;		/* everything below */
-	unsigned long base_pfn;
-	unsigned long npages;
-	struct page *cma_pages;
-	unsigned long *allocated;	/* pages allocated to a child */
-	struct list_head children;
-} mps_root;
-
-/* ---- Child file --------------------------------------------------------- */
-
 /* Byte range [offset, offset + len) of @info as page indices. */
 static int mps_range(struct mps_info *info, u64 offset, u64 len,
 		     unsigned long *start, unsigned long *end)
@@ -93,8 +68,7 @@ static long mps_get_stats(struct mps_info *info, void __user *uarg)
 	struct mps_stats st = {};
 
 	mutex_lock(&info->lock);
-	st.region_offset = (u64)info->root_index << PAGE_SHIFT;
-	st.region_len = (u64)info->npages << PAGE_SHIFT;
+	st.size = (u64)info->npages << PAGE_SHIFT;
 	st.absent_pages = bitmap_weight(info->absent, info->npages);
 	mutex_unlock(&info->lock);
 
@@ -102,9 +76,8 @@ static long mps_get_stats(struct mps_info *info, void __user *uarg)
 }
 
 /*
- * A child fd is read-only to its holder: only GET_STATS.  The owner changes a
- * child's pages through the control device (MPS_CTL_SET_PRESENT), so a VMM
- * that holds a child cannot.
+ * A provider fd is read-only to its holder: only GET_STATS. The owner changes
+ * a file's pages through the control device (MPS_CTL_SET_PRESENT).
  */
 static long mps_file_ioctl(struct file *file, unsigned int cmd,
 			   unsigned long arg)
@@ -117,18 +90,10 @@ static long mps_file_ioctl(struct file *file, unsigned int cmd,
 	return -ENOTTY;
 }
 
-/* Every consumer has detached: each one holds a reference to the file. */
 static int mps_file_release(struct inode *inode, struct file *file)
 {
 	struct mps_info *info = file->private_data;
 
-	/* A child gives the pages it has back to the root. */
-	if (info->is_child) {
-		mutex_lock(&mps_root.lock);
-		list_del(&info->root_link);
-		bitmap_clear(mps_root.allocated, info->root_index, info->npages);
-		mutex_unlock(&mps_root.lock);
-	}
 	if (info->cma_pages)
 		free_contig_range(info->base_pfn, info->npages);
 	bitmap_free(info->absent);
@@ -143,124 +108,13 @@ static const struct file_operations mps_file_fops = {
 	.compat_ioctl	= compat_ptr_ioctl,
 };
 
-/*
- * Make a provider file over [base_pfn, base_pfn + npages).  The fd is
- * reserved but not installed, so that the caller can finish setting up
- * @info before another thread can reach it.
- */
-static int mps_new_file(unsigned long base_pfn, unsigned long npages,
-			u32 flags, struct mps_info **infop,
-			 struct file **filep)
-{
-	struct mps_info *info;
-	struct file *file;
-	int fd, ret;
-
-	info = kzalloc_obj(*info);
-	if (!info)
-		return -ENOMEM;
-	info->base_pfn = base_pfn;
-	info->npages = npages;
-	info->absent = bitmap_zalloc(npages, GFP_KERNEL);
-	if (!info->absent) {
-		ret = -ENOMEM;
-		goto err_free;
-	}
-	mutex_init(&info->lock);
-	INIT_LIST_HEAD(&info->root_link);
-
-	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (fd < 0) {
-		ret = fd;
-		goto err_free;
-	}
-	file = anon_inode_getfile("[mem-provider-sample]", &mps_file_fops,
-				  info, O_RDWR);
-	if (IS_ERR(file)) {
-		put_unused_fd(fd);
-		ret = PTR_ERR(file);
-		goto err_free;
-	}
-	*infop = info;
-	*filep = file;
-	return fd;
-
-err_free:
-	bitmap_free(info->absent);
-	kfree(info);
-	return ret;
-}
-
-static struct page *mps_alloc_region(unsigned long npages)
-{
-	struct page *pages;
-
-	pages = alloc_contig_pages(npages, GFP_KERNEL | __GFP_ZERO,
-				   numa_node_id(), NULL);
-	return pages;
-}
-
-/* ---- Root and children -------------------------------------------------- */
-
-/* Create the root on the first NEW_CHILD of @size. */
-static int mps_root_ensure(u64 size)
-{
-	struct page *pages;
-	unsigned long npages;
-
-	lockdep_assert_held(&mps_root.lock);
-	if (mps_root.npages)
-		return 0;
-
-	if (!size || !PAGE_ALIGNED(size))
-		return -EINVAL;
-	npages = size >> PAGE_SHIFT;
-	pages = mps_alloc_region(npages);
-	if (!pages)
-		return -ENOMEM;
-	mps_root.base_pfn = page_to_pfn(pages);
-	mps_root.allocated = bitmap_zalloc(npages, GFP_KERNEL);
-	if (!mps_root.allocated) {
-		free_contig_range(page_to_pfn(pages), npages);
-		return -ENOMEM;
-	}
-	mps_root.cma_pages = pages;
-	mps_root.npages = npages;
-	return 0;
-}
-
-static void mps_root_teardown(void)
-{
-	if (!mps_root.npages)
-		return;
-	WARN_ON(!list_empty(&mps_root.children));
-	if (mps_root.cma_pages)
-		free_contig_range(mps_root.base_pfn, mps_root.npages);
-	bitmap_free(mps_root.allocated);
-}
-
-/* A page-aligned byte range of the root as page indices [first, last). */
-static int mps_root_range(u64 offset, u64 length, unsigned long *first,
-			  unsigned long *last)
-{
-	if (!length || !PAGE_ALIGNED(offset) || !PAGE_ALIGNED(length))
-		return -EINVAL;
-	*first = offset >> PAGE_SHIFT;
-	*last = *first + (length >> PAGE_SHIFT);
-	if (*last <= *first || *last > mps_root.npages)
-		return -EINVAL;
-	return 0;
-}
-
-/* Return a referenced child file made by NEW_CHILD. */
-static struct file *mps_get_child(int fd, struct mps_info **infop)
+static struct file *mps_get_file(int fd, struct mps_info **infop)
 {
 	struct file *file = fget(fd);
 
 	if (!file)
 		return ERR_PTR(-EBADF);
-	if (file->f_op != &mps_file_fops ||
-	    !((struct mps_info *)file->private_data)->is_child) {
+	if (file->f_op != &mps_file_fops) {
 		fput(file);
 		return ERR_PTR(-EINVAL);
 	}
@@ -268,55 +122,76 @@ static struct file *mps_get_child(int fd, struct mps_info **infop)
 	return file;
 }
 
-static long mps_ctl_new_child(void __user *uarg)
+static long mps_ctl_new_file(void __user *uarg)
 {
-	struct mps_new_child nc;
-	unsigned long first, last;
+	struct mps_new_file nf;
 	struct mps_info *info;
+	struct page *pages;
 	struct file *file;
+	unsigned long npages;
 	int fd, ret;
 
-	if (copy_from_user(&nc, uarg, sizeof(nc)))
+	if (copy_from_user(&nf, uarg, sizeof(nf)))
 		return -EFAULT;
-	if (nc.flags || nc.pad)
+	if (nf.flags || nf.pad)
+		return -EINVAL;
+	if (!nf.size || !PAGE_ALIGNED(nf.size))
+		return -EINVAL;
+
+	npages = nf.size >> PAGE_SHIFT;
+	if (npages > KMALLOC_MAX_SIZE * BITS_PER_BYTE)
 		return -EINVAL;
 
-	mutex_lock(&mps_root.lock);
-	ret = mps_root_ensure(nc.offset + nc.len);
-	if (ret)
-		goto out_unlock;
-	ret = mps_root_range(nc.offset, nc.len, &first, &last);
-	if (ret)
-		goto out_unlock;
-
-	if (find_next_bit(mps_root.allocated, last, first) < last) {
-		ret = -EBUSY;
-		goto out_unlock;
+	info = kzalloc_obj(*info);
+	if (!info)
+		return -ENOMEM;
+
+	info->absent = bitmap_zalloc(npages, GFP_KERNEL);
+	if (!info->absent) {
+		ret = -ENOMEM;
+		goto err_free_info;
 	}
 
-	fd = mps_new_file(mps_root.base_pfn + first, last - first, nc.flags,
-			  &info, &file);
+	pages = alloc_contig_pages(npages, GFP_KERNEL | __GFP_ZERO,
+				   numa_node_id(), NULL);
+	if (!pages) {
+		ret = -ENOMEM;
+		goto err_free_absent;
+	}
+
+	info->cma_pages = pages;
+	info->base_pfn = page_to_pfn(pages);
+	info->npages = npages;
+	mutex_init(&info->lock);
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
 	if (fd < 0) {
 		ret = fd;
-		goto out_unlock;
+		goto err_free_pages;
+	}
+
+	file = anon_inode_getfile("[mem-provider-sample]", &mps_file_fops,
+				  info, O_RDWR);
+	if (IS_ERR(file)) {
+		put_unused_fd(fd);
+		ret = PTR_ERR(file);
+		goto err_free_pages;
 	}
 
-	bitmap_set(mps_root.allocated, first, last - first);
-	info->is_child = true;
-	info->root_index = first;
-	list_add(&info->root_link, &mps_root.children);
-	mutex_unlock(&mps_root.lock);
 	fd_install(fd, file);
 	return fd;
 
-out_unlock:
-	mutex_unlock(&mps_root.lock);
+err_free_pages:
+	free_contig_range(page_to_pfn(pages), npages);
+err_free_absent:
+	bitmap_free(info->absent);
+err_free_info:
+	kfree(info);
 	return ret;
 }
 
 /*
- * CTL_SET_PRESENT changes a child's pages, by the owner on the control device.
- * A VMM that holds the child fd cannot, so it cannot undo them.
+ * CTL_SET_PRESENT changes a file's pages, by the owner on the control device.
  */
 static long mps_ctl_set_present(void __user *uarg)
 {
@@ -330,7 +205,7 @@ static long mps_ctl_set_present(void __user *uarg)
 		return -EFAULT;
 	if (cr.value > 1)
 		return -EINVAL;
-	file = mps_get_child(cr.fd, &info);
+	file = mps_get_file(cr.fd, &info);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 	ret = mps_range(info, cr.offset, cr.len, &start, &end);
@@ -346,8 +221,8 @@ static long mps_ctl_ioctl(struct file *file, unsigned int cmd,
 	void __user *uarg = (void __user *)arg;
 
 	switch (cmd) {
-	case MPS_NEW_CHILD:
-		return mps_ctl_new_child(uarg);
+	case MPS_NEW_FILE:
+		return mps_ctl_new_file(uarg);
 	case MPS_CTL_SET_PRESENT:
 		return mps_ctl_set_present(uarg);
 	default:
@@ -369,22 +244,13 @@ static struct miscdevice mps_dev = {
 
 static int __init mps_init(void)
 {
-	int ret;
-
-	mutex_init(&mps_root.lock);
-	INIT_LIST_HEAD(&mps_root.children);
-
-	ret = misc_register(&mps_dev);
-	if (ret)
-		return ret;
-	return 0;
+	return misc_register(&mps_dev);
 }
 module_init(mps_init);
 
 static void __exit mps_exit(void)
 {
 	misc_deregister(&mps_dev);
-	mps_root_teardown();
 }
 module_exit(mps_exit);
 
diff --git a/samples/kvm/mem_provider_sample.h b/samples/kvm/mem_provider_sample.h
index b520b49e56f60..c4cb10b4aadeb 100644
--- a/samples/kvm/mem_provider_sample.h
+++ b/samples/kvm/mem_provider_sample.h
@@ -8,41 +8,28 @@
 /*
  * A sample memory provider.
  *
- * Every fd that this module returns is a child file. Pass it to
+ * Every fd that this module returns is a provider file. Pass it to
  * KVM_CREATE_GUEST_MEMFD.
  */
 
 #define MPS_IOCTL_BASE		'P'
 
 /*
- * ---- A tree of owners --------------------------------------------------
- *
- * The control device owns one region, the root.  NEW_CHILD carves part of
- * it into a new provider fd for one VM.
- *
- * The owner changes a child's pages through the control device
- * (CTL_SET_PRESENT).  A child fd is read-only to its holder: a VMM can
- * only GET_STATS, never change the memory.
- */
-
-/*
- * ioctl on /dev/mem_provider_sample: carve [@offset, @offset + @len) of the
- * root into a new child fd. Returns the child fd.
+ * ioctl on /dev/mem_provider_sample: create a new provider fd of @size.
+ * Returns the provider fd.
  */
-struct mps_new_child {
+struct mps_new_file {
 	__u32 flags;	/* Reserved, must be 0 */
 	__u32 pad;
-	__u64 offset;	/* bytes into the root, page aligned */
-	__u64 len;	/* bytes, page aligned */
+	__u64 size;	/* bytes, page aligned */
 };
 
-#define MPS_NEW_CHILD \
-	_IOW(MPS_IOCTL_BASE, 5, struct mps_new_child)
+#define MPS_NEW_FILE \
+	_IOW(MPS_IOCTL_BASE, 5, struct mps_new_file)
 
-/* ioctl on a child fd: read the child's state, for tests. */
+/* ioctl on a provider fd: read the file's state, for tests. */
 struct mps_stats {
-	__u64 region_offset;	/* the child's range in the root */
-	__u64 region_len;
+	__u64 size;
 	__u64 absent_pages;	/* pages taken away by CTL_SET_PRESENT */
 };
 
@@ -50,14 +37,14 @@ struct mps_stats {
 	_IOR(MPS_IOCTL_BASE, 10, struct mps_stats)
 
 /*
- * ioctl on /dev/mem_provider_sample: CTL_SET_PRESENT on child @fd, by the
+ * ioctl on /dev/mem_provider_sample: CTL_SET_PRESENT on file @fd, by the
  * owner. @value is the present value (1 = present, 0 = absent), and @offset
- * and @len are a byte range within the child, page aligned.
+ * and @len are a byte range within the file, page aligned.
  */
 struct mps_ctl_range {
 	__s32 fd;
 	__u32 value;
-	__u64 offset;	/* bytes into the child, page aligned */
+	__u64 offset;	/* bytes into the file, page aligned */
 	__u64 len;	/* bytes, page aligned */
 };
 

-- 
2.56.0.257.gf7497c7d27-goog



