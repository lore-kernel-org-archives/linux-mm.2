Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D776081E63
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U2a/JriD
Received: by kanga.kvack.org (Postfix)
	id 1444A6B05C5; Fri,  6 Nov 2026 19:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5A16B05C6; Fri,  6 Nov 2026 19:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F262B6B05C7; Fri,  6 Nov 2026 19:37:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD9756B05C5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 620F0A0276
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
X-FDA: 85406458494.04.2714A39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 445E0180003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U2a/JriD";
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011825;
	b=qH5RxqaFllSVBn+wmPhC/omXv/jO6N/E7lx6pNnt7zRjhp/bORCnJh9GE7umiKcdU2W32Z
	Bm0QOU1zc2B5663mvC7SlmB3vS8qrQWtEQOINk2OtlXpaAl/++hP5ACbTA963IB/560P4b
	ydtPXswl3/bciRF5F18GwBLFZ5lPbvY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U2a/JriD";
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011825;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZexpTI9NCkfxTl2+zcrGYej44u/dsyRYTkwcPEgAIK4=;
	b=Z5zcT1FaCtg6kdQ0T57kmsWlbYmcOjozjaNVYhLDtRXoeaLdMimQ/9HRI9s7t7wncX7/3z
	JG1PhDl10oZoMPKNSUxVrxt1qa1caJp0LRkGYuJE02AkiXXD22AImz9cqSyER4gsQz8hPP
	uiC0Udl+qLRnIZzyZNMlni5LuME1xlM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F863419E1;
	Sat,  7 Nov 2026 00:37:05 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011824;
	b=n2JBcqPFPglIt/KtST6lDWUQiFUgelLZaDe2WcSiJBrV5cY2OzpIIYt8ZfBd/XnfpTv3
	 Ot8m5KQbMJlAoGH3waz/8kzpTCu8kr34aVDszDfn2ZYi6BHwg59JLBKtWORRX9EhN6FHB
	 N8sUU7Tow0of0PoqIbzkvKfRMLTQFOfLsvJs2WCUPetpFlI4mBSH+rL7Y8NV/VtU7t+CP
	 5HSMTyhlAeaNt0v6IePMKSzrpu478vnpOVvaB92hT3UIgZ2lSPZJLWGF7TdoD+9/aJOrz
	 7UGasbuWq+C5gZg/H4jaFc82zJwsbiAg37/WiF+Uu9/tjg3B5OBbLjk34m6XrzqRs0A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011824;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ZexpTI9NCkfxTl2+zcrGYej44u/dsyRYTkwcPEgAIK4=;
	b=2eCEbqMbpZ/rLjlCnMfZgwQj3e8KYSEglBbtARJrKM/bAdGmYMZC5FazaG1mnopD/jMs
	 +4hJ2Go45wY2dVADdUVF7ED9djTQ6+wJnIxPXSf+X/vAOOx8k0KgkIPZtcojwalLJAzNB
	 2nTg/c6G5A4XcYyG0liwcoQ4xvUZ8xKU/LvDHowXKdtxuHmuBm+0rPoWLP9ZoyuaywpPH
	 ivT3DS9f/0ixHLO+Qc4xKvZoF1MI8GJ0Fr446Fb37EuEM0ak4qMENffysiX8uPdpA5qkB
	 ZcZ96/5bkWZeBzOXA4rs3AuFHcsmExoPY9ptOOXwYla2W9HgSo0M24D+oBPgbLKC7ew==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 88E421F00929;
	Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011824;
	bh=ZexpTI9NCkfxTl2+zcrGYej44u/dsyRYTkwcPEgAIK4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=U2a/JriDuhd2uKeFAPf2f07kDJg0uavmyiYcaTQpo9ICmNZW99AYdxwcE3Gt1y5Vc
	 X4HCSiHqDNLQjmy8V2U05jZOxTa8Pz7/5uvHbBR61rbSRl+IEt6q8O08m8y4OmZfWC
	 6wqaHI4SNsBksLRXtOpsauaYE2tKcgqw9UQQ1OtNifP3ppXFHweC/hFBSilnzJ5OMO
	 c/DEE0OwB016TeFike16q+BpqrpvsDaJyOlANSj3xZhfMDVZfUD3hBF7eTWOUL7teJ
	 rTwo2+yx7KJt8enYB9jrLWYVHWJv7hNWfxDljf0lg+iInTFldiGL+DqysTkofady4d
	 Qy/acbsBMl5cQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 255D947992;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:06 -0800
Subject: [PATCH RFC v3 32/88] KVM: guest_memfd: Support user fault handling
 in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-32-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=4803;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=BHfl6wvLdeD6eD5eILiiO6y1oWReh7OD+qFN9r31eZY=;
 b=PheuT7ywy0hAO/mjTx3YVz658XWJPOjzwi+5Hkdw/rJUyuN13z+94s/e15qbngjBlOTdHHYJA
 gCPlAhTinKMAkcCG8fDXSpq+8UE96qNxdU+ZortX7X5Tdcsqh23gX1A
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y5icu8m7kkd3hy4j49hpedptynwaiin3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 445E0180003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011825-391641
X-HE-Meta: U2FsdGVkX1+c4X6YVTE1xvlNDurAo4IyNB16vnigp5VXP4ojv9eyA2VXwVwfSnRk+ZHdHLQXwZaCjn8VJtGmOA5OJqjERINdiChj2YAm9W+W0MejMh/HkMM7EgPtgCNOChgdYCqh8hQZidXP1kgbGeDn9We3IRgAMFKz+fqwZKeCBcqvwRunlXSgr+aTsfFmsRU64fQe23bevI57jX4puLwMDidYn5NZV8Qhu2uCwPyyWKU7kzzvKaAzDik252ZrEsyhfJQ7xlRVzAOhz5G1N8zQ1nAkyNfF/06ciY2jviQ56xWfgNoeOAEfRJ/dNKZhnAdmICqdG+Tbr7XdJM5DywFTN4i3wMe2yWAW/AXn1ZdZy1VVpLJaffhBtrF+/MCHMXsz7yg2Z7kr/lb63k6mD9sKOI8n6x435eijjVUv2qYpCfgH/ouHR2psz0uOH8HT8oNCwxVcC0jA/2j4htPByHD+e8+8xJte+qWBK/IAspVwk6tDtDg69k5ZrYoR19ilo4BkrvaRxQpuZG5se79sU0DpqVa30rCJ0Z1eNk8K0NfIPjkvjcPN7WIupqQ9L3pyHx04j/rHwsg1hxiVUolFgvf3L3tPrkPH2mLErH60kfQpANwiVx6SruSf4Y5OUadxZsZ2KM/qYRNVJ6Avesu+28kN56y/jbtXHC5sc3zj1rHg08dKDUK/XxDUd5x+AK7/O2eTqwit7I1F84Eapbm5qKpSP5llMoF4y1/iFTFH6q+L/xkqrK81x8PA5woh1N4rixVVNTvlcJmzAtFWL0Bhq+F+cu256kl024R6Ffbt2dzI22saIto4wuUSeOvlLGxrsHESSKI+QCJmhnqL+/xNFxpASv3DIxqysjA29Klu7rBbSs5RgMjRt3KL/1/XV5plFUwubAzEZEFntaisAvteTYGdelFHgci/vJrHCqnRiUhD52pF287X4EF99xbUZ1Od9daXHth4VbIgjhRrt+V
 WMtwSeCW
 3iFCf9tZsH22WOH/spx12IfSudFDGesjCD7O0SP4xQxwxuVHsSNin8TwEkyP6ByJiGXcW+g3aJWKZiaIzzo8LYAPYPzTq39nCo4WHDWlFqIoFKgBRxLzLa8Qy/9eJ8LHNT2WsnoFyrQUJ74bN43fxxJ8c8h+N5XZFel5ZMsqFxONjd9s2OfGVMx2HRkKTlBDufKXpCi91BRAOvPo3MOvt5T++8qJFxY7V0aHuN4oI2pkBZCO3d/zEtuhNNiiTIzbkns1+MUS4B9ldM7CziGZlE2TJnOUK0UtaUEA16PMJzvYkmgQEgZpbBGzuTeu85Jlxi5fa8mXHz/v0/d/ZKL9FL742S4/IsJukJ3oDzwVtgceAt1TeRoN6y11eWhw3JrkEbJWIGgnUm16yPPeRLDJ8UncCPMX1ONeyNPUvEO8/ouw1I3bTPJ9JT6nXzxH/obgIjmwjcEmxUEXYIsN8o7wRq9MD295f1s7kzGCyJDPuWHZSxu9N69LEua03cDEYFN+wg2fpdepHEYj3aL1hzn5vJHi8rx2hlPbaKQ5PfDeLGzK6N2Qj956H5E3MLMLrTK+loYKuOpEToO7KGVaTMh9B3tES63CBdmwKXwL7gEWlJaOnFSofmO4IXlf+3DpJ49+bmYh4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

In PFN mode, guest_memfd memory is backed by raw PFNs rather than
page-cache folios.

When inserting the PFN into the user page tables during fault handling,
constrain the inserted protection by stripping write permissions if the
provider reports a read-only PFN attribute, and fail immediate write faults
on read-only frames with VM_FAULT_SIGBUS.

Introduce kvm_gmem_pfn_vm_ops with a .pfn_mkwrite callback that returns
VM_FAULT_SIGBUS to block subsequent write attempts or upgrades to read-only
PFN mappings. Without this, core MM would have marked the PTE writable and
the write would have succeeded.

There is no need to do another .get_pfn() call since the contract with the
provider requires the attributes to be kept constant until memory is
revoked, at which time the user page tables would have been zapped.

In folio mode, the fault handler obtains a locked folio under the shared
filemap invalidation lock and returns with the folio still locked so the
core fault handler installs the PTE before unlocking the folio. Any
concurrent truncation or invalidation must wait on the folio lock before
unmapping and removing the folio.

In PFN mode, there is no folio lock to bridge the gap after dropping the
shared filemap invalidation lock. Hold the shared filemap invalidation lock
across PFN insertion to prevent races with revocation.

Co-developed-by: Fred Griffoul <fgriffo@amazon.co.uk>
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 183e15775523f..e94f2359b7c9a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -565,11 +565,40 @@ static bool kvm_gmem_supports_mmap(struct inode *inode)
 	return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
 }
 
+/*
+ * In PFN mode, physical frame attributes are constant for the lifetime of the
+ * mapping. If a page was inserted read-only, it was because the provider
+ * reported a read-only PFN attribute, and write upgrades are never permitted.
+ * Write faults on such pages must fail with SIGBUS.
+ */
+static vm_fault_t kvm_gmem_pfn_mkwrite(struct vm_fault *vmf)
+{
+	return VM_FAULT_SIGBUS;
+}
+
+static vm_fault_t gmem_insert_pfn(struct vm_fault *vmf, kvm_pfn_t pfn,
+				 u64 pfn_attrs)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	vm_flags_t flags = vma->vm_flags;
+
+	if (pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY)
+		flags &= ~VM_WRITE;
+
+	if ((vmf->flags & FAULT_FLAG_WRITE) && !(flags & VM_WRITE))
+		return VM_FAULT_SIGBUS;
+
+	return vmf_insert_pfn_prot(vma, vmf->address, pfn,
+				   vm_get_page_prot(flags));
+}
+
 static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct gmem_inode *gi = GMEM_I(inode);
 	vm_fault_t ret = VM_FAULT_LOCKED;
 	struct folio *folio = NULL;
+	kvm_pfn_t pfn;
 	int r = 0;
 
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
@@ -578,6 +607,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	filemap_invalidate_lock_shared(inode->i_mapping);
 	if (!kvm_gmem_is_shared_mem(inode, vmf->pgoff)) {
 		r = -EACCES;
+	} else if (kvm_gmem_is_pfn_mode(gi)) {
+		u64 pfn_attrs;
+
+		r = gmem_provider_get_pfn(gi, vmf->pgoff, &pfn, NULL, &pfn_attrs);
+		if (!r)
+			ret = gmem_insert_pfn(vmf, pfn, pfn_attrs);
 	} else {
 		folio = kvm_gmem_get_folio(inode, vmf->pgoff);
 		if (IS_ERR(folio))
@@ -592,6 +627,9 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 		return vmf_error(r);
 	}
 
+	if (kvm_gmem_is_pfn_mode(gi))
+		return ret;
+
 	if (WARN_ON_ONCE(folio_test_large(folio))) {
 		ret = VM_FAULT_SIGBUS;
 		goto out_folio;
@@ -650,6 +688,15 @@ static const struct vm_operations_struct kvm_gmem_vm_ops = {
 #endif
 };
 
+static const struct vm_operations_struct kvm_gmem_pfn_vm_ops = {
+	.fault		= kvm_gmem_fault_user_mapping,
+	.pfn_mkwrite	= kvm_gmem_pfn_mkwrite,
+#ifdef CONFIG_NUMA
+	.get_policy	= kvm_gmem_get_policy,
+	.set_policy	= kvm_gmem_set_policy,
+#endif
+};
+
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct gmem_inode *gi = GMEM_I(file_inode(file));
@@ -665,7 +712,10 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 	if (kvm_gmem_is_pfn_mode(gi))
 		vm_flags_set(vma, VM_PFNMAP);
 
-	vma->vm_ops = &kvm_gmem_vm_ops;
+	if (kvm_gmem_is_pfn_mode(gi))
+		vma->vm_ops = &kvm_gmem_pfn_vm_ops;
+	else
+		vma->vm_ops = &kvm_gmem_vm_ops;
 
 	return 0;
 }

-- 
2.56.0.455.g6c5a503b38-goog



