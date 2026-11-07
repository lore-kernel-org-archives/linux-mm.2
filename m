Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3890E6085D7B
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YJ0Qo6jN
Received: by kanga.kvack.org (Postfix)
	id 1441F6B05C7; Fri,  6 Nov 2026 19:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C2F6B05C9; Fri,  6 Nov 2026 19:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00BC66B05C8; Fri,  6 Nov 2026 19:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C01E56B05C9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F9191C3083
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:08 +0000 (UTC)
X-FDA: 85406458536.25.1E99360
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 48266120006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YJ0Qo6jN;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011826;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jyih/ZWZhrRU6GcpifC/ctZB9GVVxtxj6yL2+TCX50=;
	b=5FqUmpnqIApZmyZpsLe+9yp6uNAEqlSc3SjGSmvI3dNA7R/lQJxaTWOtko4A/YCK0pH+Cf
	09ibUxHgPqPEP0EOI5B2eUVOtpWtyTq7xnvQnkgKppoejErqciho+c7GHC49JAUOlU/dQT
	2to7kNuj73qs8vGhGwei46JAqDx0tR4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011826;
	b=Bc/tn+w5UHwfIywdYpmrVvCm4B/yY/gH+bsDNvdEYmcB0af5OZ6qQoSx9nub/BFgbak3Gq
	3Tp/XuC1uW6TdS8op+4mCNimqbYnkpDD6KJSRwhLlwdULw4eTEqFzAR1YoiZXSZN70rkcD
	XDMl+9zL1zVlyEPpOryHcV+cFz6QKjk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YJ0Qo6jN;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 981234322C;
	Sat,  7 Nov 2026 00:37:05 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011825;
	b=ewNOAhQVaOJd4siFJzBY8GcVN2CvNpGxyYx1oe3K8DIgjLu5mI6Ee8RDetk17w4Gwidw
	 VRw3JqLHFd9RImfwmqx74zn/SyCXP5417G++gAWdtSvQf1p5VfaJS+ViLtw3W2tnhRqY2
	 NXPmafnm2p1IKHUNb75r0OCQRkdQ6cTodo4i9WxpcvfuYLO48qeMNgOIsVYF040EFk/tm
	 lpAxIWJCp9kCrimwvEJu7MNaQm/cQwLqrkjUeC/6Ot+UscAET1rFJQDvHOkBQJ5cPj00j
	 9b/LGDMBOJEYcyzay123XnizVGfcyZZRRN3DcFO1+7Qe8iTS3uIjWZjdwLFl4mooPFw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011825;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7jyih/ZWZhrRU6GcpifC/ctZB9GVVxtxj6yL2+TCX50=;
	b=zxeBR7J22JNNfKUi6a/eB+wlijcGujOJT4m38NmkkI7sSZJ6N3lYxngjkbmFUFzpv2Y5
	 j5QFuoNx80SPBgfX1UY8QBxsOM68paug0LL65HVmucM7DU4LFPJnG+nQ6sXwq2ggmB6qC
	 KXeJgI/d4yf523NqvSq+A+J+eMypirNWOvtbE8DgEoxTAdmDbCQE4BaZ7r7yWfJMnBYzz
	 ujqfao2+QrM0RnVPKbx3YKJ6g31W0RBQRnf7R3XQjoSvuAf0rJ21+NHXgng6dVfmmxA4z
	 LlUhq38MzfpDgqving4vdfJgXl2obYlU+it+4Y8exTe86Pzx3jNfqTcIdHxxGmz6F9g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3EC421F00935;
	Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011825;
	bh=7jyih/ZWZhrRU6GcpifC/ctZB9GVVxtxj6yL2+TCX50=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=YJ0Qo6jNfTzFoj6mVl0zDhylpwBaFlD/OlOhXGoXZIsU0jUXlqchzAvJ2ATcXk8St
	 SnHAswlThfrMhrV9n9VGgu3ws0GS2y23yNtIZlrlvRt5dKDiqC5NFMcWlXhv8xuW3P
	 gDRL1FKNnZ23loSt7fupwpnkh20z4WzTOsxlj1nxofp1V+zm7mTdk13qW1kMyjFgLi
	 TgLsEUqeFHQLkABtg57RFWZlWbK94cI0xu7S4s0O1zwz27db9QbVLBNGMYQLMQkMGf
	 GtrXTV2ZqIdYNduroGKG/RBRkPj+3TaI4qP12Do6h5G4nrWajOGPPBgE+eSydU/ddt
	 auX71iruaSjCw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 049624798A;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:04 -0800
Subject: [PATCH RFC v3 30/88] KVM: guest_memfd: Refactor error handling in
 kvm_gmem_fault_user_mapping
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-30-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=1832;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=VKBzbTSyM8v25pj2OERwLhVUhvmGhWqrRwXpLizcOTo=;
 b=TNHQGkfJIKvSrJmsMJhLzh4Zf2IlSWb1GaDzeKt8ZF6I4gcbCyM3w70nbNY2BGZBmWj+BSlaL
 RGs8UwVSrcNDrzLDRtCrZvXA3lfyBNeELOimwZhBiqgNYheS6HmLA9N
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: n7ke9g85bi7fqpwe3xmzu48689u1dync
X-Rspamd-Queue-Id: 48266120006
X-Rspam-User: 
X-HE-Tag: 1794011826-613069
X-HE-Meta: U2FsdGVkX1+hhAWBWu+KIKkq6R8+gtgsCJ3keYYs1lMe+d3WCyrBtBEpAlYmFFASm9aIRwJElX/qOLFZoNsGnsEKenerBZOLlqPeSPy84D2XuEqcwUa7OEaQbb7CsJwoQZNHv+5kx2rR9tPCdEv1v3GnJLUZbxreTmhCrvMrP8jEPgHg/pdDcpJeXLysyYV1d7BsMJtIJpOl7Eoq34tEEvTaE/hKjX7yhB1PkSw/apGxy6BrEq+lUO1yAaE/mvHbK6Ltf1+Qp5kiI48KjTZ0JUaSHEzz44RJXlkCOMpGF2E2T94bR4wj/3EH0YN61DhqGtCGZi+Dp8vRJoM4ahsCh4Bt9aciEpapgdU0DPCVQYBhsVuDAmKDYDsJ+UpoaTJ3KiwKgVFmMdTa6l48PYcSW8ZZM64+Py5cY3PJq152kZOD/Fd3L2SUY1J2+1zTWin2MwHqNjMFUEPnm1oVP+6uEmn6cpoHn/+ENoNS1T5sD+M3sKQ+i1YJZ008Ph0LUXJTgorVMCYpOHErhduv6+xzY5PcX+rsgyUnropjFd7WOWgtpqrdZybpDYtlUKinuXhneMEdz8KDbZZ8ghLOpWQePvWl54jlU2n5qREJb2KbbZoYlTudNK22fsbCnnjt+mzV2Jb7zezGcuXngWSdUeWl4DJhEkqVpqHooedyJRk3GIZzvI/u3kW6LyWzzskkJm4OttORDYuTMQcEEJTN8J4uAzPtFFbGVgLuaUsFAjxJufX1EllqCh4UQV3VWDaA1xnaMti++BnoiewQOSWDhXU1GMsiHd5MmPBxMsCwd4wlb2kiwJ5IkKn8HW4gGlwaAimWxLa8xANMEMryiX4/ZKtBBFhONXWAWEvxdNpkKliZGrTJ86UvVmP095C6K7IsY59wd3bRV07ujrhNh8J1LUeOiK/1DumGDpyB7qGV9ASfTfyR64c5plUR012bn2X4WwLwQkhq5Af6mQFR3AuD7l/
 kI0eB7xS
 fARsnsxsW4d6PxOh8ThCxiT9vHwPlVB7dNmRJwKrTo8dZZ+vRnfalwG/Yb7ATJJgMTWDildEKinCUE+nDKcZaGaT3Zl3fR5QegFTJ97PCabYnA85FO7vbII5vPEocoHuelogO9PVGNYCkweDZTHBH0rmSf2gn1JbKfoOAjaKJNNxwpmlNLyirdK1jcdgZLqmwDdXkIgP3ny2L+2NQ4aqusc5Se6vOL0ORl7X+GsmxJ+7T2Rgn+HAUqqQR1Yx/lp1yTHZkK2DeU1m7W9pMx+mO5bHPhIHq2McyhMek/40NtlI1EnI7CqiBsjYQ/ZRWufn3kqveL3R5IrZi6ynIdD7DSVUXuFmKZLFAXe5FtT0a9h/+kWUplWYs2KY0zTDaAqigGPtWmZ/EOkTwH5Xcm7L7F70ZlO7IImRm4J4GsfICvB2CObRgKLCKNeOrkk1XflQu7Z1qg5AcC7ESVUNrdfEGu2U5xRGGvPpJb9hEKgU+BKGz824R/QNJaZmegF0DZX/GcXiZjH/WcIqk6pz7EixJOkiZw00taxxSBWFnYI2iDEToRsfsXeHhDiCuLLnIy63XqJ2qV8tw6vSbnVGtKma6MHN+5rvy3to2g+G1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Track the status of kvm_gmem_fault_user_mapping() using an explicit error
code rather than encoding errors into the folio pointer.

This moves away from relying on the folio pointer holding error states,
such as synthesizing ERR_PTR(-EACCES) when memory is not shared only to
extract PTR_ERR afterwards, and prepares kvm_gmem_fault_user_mapping() for
PFN mode in the next commit, where no folio is returned on success.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index eedf03df12c55..180418c65a1ae 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -568,24 +568,28 @@ static bool kvm_gmem_supports_mmap(struct inode *inode)
 static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
-	struct folio *folio;
 	vm_fault_t ret = VM_FAULT_LOCKED;
+	struct folio *folio = NULL;
+	int r = 0;
 
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;
 
 	filemap_invalidate_lock_shared(inode->i_mapping);
-	if (kvm_gmem_is_shared_mem(inode, vmf->pgoff))
+	if (!kvm_gmem_is_shared_mem(inode, vmf->pgoff)) {
+		r = -EACCES;
+	} else {
 		folio = kvm_gmem_get_folio(inode, vmf->pgoff);
-	else
-		folio = ERR_PTR(-EACCES);
+		if (IS_ERR(folio))
+			r = PTR_ERR(folio);
+	}
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 
-	if (IS_ERR(folio)) {
-		if (PTR_ERR(folio) == -EAGAIN)
+	if (r) {
+		if (r == -EAGAIN)
 			return VM_FAULT_RETRY;
 
-		return vmf_error(PTR_ERR(folio));
+		return vmf_error(r);
 	}
 
 	if (WARN_ON_ONCE(folio_test_large(folio))) {

-- 
2.56.0.455.g6c5a503b38-goog



