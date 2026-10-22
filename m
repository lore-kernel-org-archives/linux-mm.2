Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC45606A753
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lN0x9ppN
Received: by kanga.kvack.org (Postfix)
	id 017466B02F3; Thu, 22 Oct 2026 19:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30C56B02F4; Thu, 22 Oct 2026 19:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21616B02F8; Thu, 22 Oct 2026 19:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B042A6B02F3
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34E5D160351
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:24 +0000 (UTC)
X-FDA: 85351853328.02.A9919E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2830F1C0002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lN0x9ppN;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711702;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQV3qQ3k9uCjoMdvwJYY0xKD7Do9569EVepxRPPnbCc=;
	b=qLldXZsakmrO8rmXL9zK/RMIrEum11zBE5nGeBV+1U4ReH1u+42MiiHsUIB80r01nxguS2
	NWfiURqQoAuoTqYgz1K5X/VSjVysTXhDqczA5AIeQ+6xDJWlzi/+S6uoHcAPDNXf1QjX2i
	P73VZtapM4frWZrVSUfqVdta+wdWk2I=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lN0x9ppN;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711702;
	b=xbfnxMVodLqLFVMC+j/nTs+xvHfvsym8Lb62KMYaC6ofe3N+/v/4Vr4pGLx6+5NSOndZat
	fshKMxO4B23xHOIEk2/puFTjW901c816Q3n7IIN63mVOKGk45PPvuaZ/j80FcXHFaBLnyR
	npDy2wLjmanQajMpXzQSWH0KxWlVAXw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE8F160DAE;
	Thu, 22 Oct 2026 23:28:21 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711701;
	b=BQZabtI2ZET+iUXjaDtrRzn26GfKmQPO/N2J+gKIocNpc+FI0Yn9byyeD/ZOoCYws06l
	 y+tqrmQtvp+qlRnyfI1CVv9xkLghtGNUEfQCORmhYUR0IZC/OO+NVepq1tUNDc3osA6l/
	 dQtICKAMjgMf4yIflCTvi5rghPBM6Qywou9hzoy4qvO+EKL0nsVSlgF4wIYQYlO/9Myai
	 r79zu8ilQTPXsLwevX2O+IQXCSi3FK4/WHXVP59lpBg93xdPSUqnmLGEgyBBUWYjYE+G0
	 HFelUmHgMwSF+a6KzWZquRroIBX//4W8EQ7hpDnUuvrOcEsDXacrONaAsx7Umxs+H2g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711701;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=wQV3qQ3k9uCjoMdvwJYY0xKD7Do9569EVepxRPPnbCc=;
	b=ybqmtpsqyxJtm9vPfcza55mVhuD2ib4pJT8JJFrex2U6lM9q896T0Uw+rGquPOX0Z31R
	 uu/B/nPd5VhV30oO+N5sBmmQUuc8Jlgix3KxQAWfgeStM5HJdV6ZHpPasuqA2sOEcKnPj
	 7jXZVWxXb/Q0pk8QuVyCW4dQ3uYYkBIkZCF2oCcXMm1YC5aMGPMSbZesfdSA45yRkAf86
	 2WtgdIc5eJyRiLlVupukx+hl/0gOJTpftICmmkg6qmW437cZ1tY+PUfxx78MDCz7Kf8R+
	 0pKwjf7fOs8AZ7qFfrp0mEqk2oHCOnSy51FfWq8VvlvHbwVH2dwgGz5VziSVj+0P4hQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8FC461F011BD;
	Thu, 22 Oct 2026 23:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711701;
	bh=wQV3qQ3k9uCjoMdvwJYY0xKD7Do9569EVepxRPPnbCc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=lN0x9ppNPS44uy+ho+SdOpER4/D1FSzCTpjESm1KrU0LKAltU6hxv/854A00vrQEa
	 NCRfwcQFu3qiksEBhbd+RRaC2nhiTkKwzOPy87lWWFAdghkxLRMguk5i+oFmS1homG
	 5SygOBk5wb6j802l/cnsvlyrmEnK/IemHgJ71S26gFeCMAPWHxcIellK5VVrauQ+9j
	 upIR2kCwu2NXVX3h8PCyAgcWB/ljNWe+6nK39o6gPaHQsHaoSTsR4TR5AofE3jWIUi
	 eua0g7icM3KC1wmrkTFCLhef2S7rIQcHcp6/o10peO0q/47BHCYef6UwLSga80sNip
	 SinU2y5mNbxgw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D6DCC420C8;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:05 -0700
Subject: [PATCH RFC v2 33/50] KVM: guest_memfd: Support mmap and user fault
 handling in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-33-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=3706;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=elLIGBYw0BUJ9IbNw0ScjqZOWht3JZnml1/BafVIxxA=;
 b=VW4cbdmPxp6Pao5q+UBf9fgRtR76zuJjTkAk5Ko45CrogkVItmv81as/Lvua8wCNXiykVR6H/
 c7oDGQMzSZXBixMwnUcjgTlSfcnS1H0bfnLQ5pnFxQgPtZqsEOfFJds
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2830F1C0002
X-Stat-Signature: x1zfsiat7qi3cjginodu31dsmrixoapn
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711702-641642
X-HE-Meta: U2FsdGVkX1/JhRaTGYBewKPC9Gl9yxoeuZFxiWvonuyyHShrThB4FAJ7y+pKL3jBvjDCmfriHG63Z8MN+zL70jYL8nXHBUFJqhp6AKznRqaIUq7xvyK9EPl5QK5ZXJcCpD7jC5O3c13YH+ID2ImArYjatfIquboq88K4SEFipVR5vh/Gb8Wq5ewmAPP8qsXOLskuClc2a6dopOcmYYwsfX0r5vB5uWJtqW3DGM+4nuBE15QM7xiduTcF9K//XXQ2PNGExOXPnTxGebtqGh4Wyv9fpHP5QlnNb27bpEt9EwW1a2rtIHy5o/tUhMG3z2qv3clkMuNULZVm0AO3i8A6L8yVzyIj029K0xiyGcPALF7ZfoVUD5qfubedp6PKqF1vqe4qUVUWq3jFJTW6aEvxI66hbHMx/kWYveWoSJ1ASXKT1v7HZ+mYdb75wuPC/zf5W8vgzaUGDDqkti2MNzT+5s9x0FsvAb+/Fu3tRlm1g0n/K7kCsmW2bLLliPe70uzLHWd/+p5yf5qbEw32glSNIQ1rCOCvS9e2l6p4v7Fq3KIf3svLvMiZwRxjVzomF8Qj7VhZ+s8XQSGkvmiQKkaOTyjDiuuOOb7/qGpDR+mRAIOyDfYvCHQfN+p0iKMVCY+F9xTUSskNo5LHZpj3ijO0RSAQy/4Wj4WdBuEX770EvU7o5deiGJsvvPQuLXxaGFhXrTA/FU+uMg+RRZpX88VuKLiFeXucLFkYDuWoVf6M1dj/qyDNsASbhFOakdFMM6MbbyMEfGLMDA2ACvPd+IWqewe4YIW+AXp8J7ff3ahBe1WZrjXQhOI6sVZFAGuWYQmCSZUi3rPkcVIG8ek10LcTHjk596TqGYtRUp5BFsPDIqIj4EjI8AFjPSheB6pnsBskPwfNy8ud9unA6KFE5SUznST0IN9ZrocyNdC6mWCvmhkVphdlblwNY7O6k8MzpimbJ6pVM+PK6LGYsgbJCiF
 qzMCdP4G
 eVuI6N9b+rV6OU/xbc5KztIkzT6ScE/TUirhy5tmft6GxZUAJh1rIfbuQyFQpNKKnmgnHGCXfXSvsKlqdbvz2z8Acu3uO2nRwaVcPgxSjCU67QMPR+s2aEcXSVmGZkrZy42lz4evVfK41kfWQMcTAhDYo+NkD0rQneahJE1N6kj2IGWUgFQ/1vJUx/M/CVnAT0jikCbQLDryNP3ln70ZuIGT/mfhb4mIs7a3i4zkm/x76uHdJaBsdgkPrMumxiBtA++HYXyoyq5tDfkw3gwCrbn6nQl1tMFh2C6L313+q5dChpVRA+BP9lbK92DPtDFGZkH6Vf3sfc+Pa1kldIEHRbX/zHVL5tg1oxQVFg1d321yBQxNrkmV0EfsZYmnaNvYVUByzCxJny2FN4mJPG8PsgZTuV88mT5BOlrqbwArJUpojRF3e0335X3HrkFKd4gR46BwT30NTlM8l7TqMq79IL5sTqFEH3BmvlnTqwX1MG6UzJ8Q87g+D9FYKDV7jGZRzC2pEgt/yBdRUj/sDc0ym9vW4ge72jtu9nOHLChCYyR7BLAzcBhnz2qCGKmkpWmX8T6AXcgeLhvpgoIXxdkOMFl1rVG3gru+jXfGVihS3vtq9/3A=
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

Mark the VMA with VM_PFNMAP when setting up the VMA in PFN mode, and
insert the PFN into the user page tables during fault handling.

In folio mode, the fault handler obtains a locked folio under the
shared filemap invalidation lock and returns with the folio still
locked so the core fault handler installs the PTE before unlocking the
folio. Any concurrent truncation or invalidation must wait on the
folio lock before unmapping and removing the folio.

In PFN mode, there is no folio lock to bridge the gap after dropping
the shared filemap invalidation lock. If the lock were dropped before
inserting the PFN into the page tables, a concurrent hole punch or
provider-driven revocation could acquire the exclusive filemap
invalidation lock, unmap existing mappings (missing the not-yet-mapped
PTE), and reclaim the backing memory, only for the fault handler to
subsequently install a stale PTE pointing to the revoked PFN.

Keep the shared filemap invalidation lock held across PFN insertion so
that obtaining the PFN and installing the PTE are atomic with respect
to operations holding the exclusive filemap invalidation lock. For
provider-driven revocation to safely tear down mappings without races,
the provider must first mark the range unavailable so new faults fail,
and then invoke revocation, which acquires the exclusive filemap
invalidation lock to wait for any in-flight faults to finish installing
their PTEs before unmapping them. This also requires providers not to
hold any lock across revocation that is also acquired during PFN
lookup.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8588912cb0b82..50031e191968b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -562,8 +562,10 @@ static bool kvm_gmem_supports_mmap(struct inode *inode)
 static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct gmem_inode *gi = GMEM_I(inode);
 	vm_fault_t ret = VM_FAULT_LOCKED;
 	struct folio *folio = NULL;
+	kvm_pfn_t pfn;
 	int r = 0;
 
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
@@ -572,6 +574,10 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	filemap_invalidate_lock_shared(inode->i_mapping);
 	if (!kvm_gmem_is_shared_mem(inode, vmf->pgoff)) {
 		r = -EACCES;
+	} else if (kvm_gmem_is_pfn_mode(gi)) {
+		r = gmem_provider_get_pfn(gi, vmf->pgoff, &pfn, NULL);
+		if (!r)
+			ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
 	} else {
 		folio = kvm_gmem_get_folio(inode, vmf->pgoff);
 		if (IS_ERR(folio))
@@ -586,6 +592,9 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 		return vmf_error(r);
 	}
 
+	if (kvm_gmem_is_pfn_mode(gi))
+		return ret;
+
 	if (WARN_ON_ONCE(folio_test_large(folio))) {
 		ret = VM_FAULT_SIGBUS;
 		goto out_folio;
@@ -646,6 +655,8 @@ static const struct vm_operations_struct kvm_gmem_vm_ops = {
 
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct gmem_inode *gi = GMEM_I(file_inode(file));
+
 	if (!kvm_gmem_supports_mmap(file_inode(file)))
 		return -ENODEV;
 
@@ -654,6 +665,9 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
+	if (kvm_gmem_is_pfn_mode(gi))
+		vm_flags_set(vma, VM_PFNMAP);
+
 	vma->vm_ops = &kvm_gmem_vm_ops;
 
 	return 0;

-- 
2.56.0.257.gf7497c7d27-goog



