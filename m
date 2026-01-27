Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34A17D2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D5E6B00AD; Tue, 27 Jan 2026 14:31:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02426B00AF; Tue, 27 Jan 2026 14:31:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24D86B00B0; Tue, 27 Jan 2026 14:31:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF13F6B00AD
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:31:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37292D345F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:31:24 +0000 (UTC)
X-FDA: 84378737688.30.64B4B55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7A199100017
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:31:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZW1wjmlE;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GK6FcCZqutIrcHddWUJKNqBG/F2MzjZiycOC39ZF6KQ=;
	b=fpU81uvxUzzCOHoIMJdK1N6aoA/pJxv9/JWBOuqV8SFnfk2PukU5mGud1RJ8qDUcQmKuV/
	8QjvdjjfrFAuebc7f0vJRh26qhIzdfeTH69c3CZfleU8hyzZcyi2ASZOgVRHjajPNYM7JD
	TCDX4XtbIxGKTjuxUHYrMuyUKdkYELM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZW1wjmlE;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542282; a=rsa-sha256;
	cv=none;
	b=FJKJEcPlPnHT9a2d7m85sit7ncSbODEhYi9K/shSsCHnW3xagF4PPVsT9aluBh7iS5Iw+e
	o2qIbg+LARVytZsLdlcyM7akKtVtUdT1hBgarpEc6qkzpj1mqqYVZSBZAZYNmj0GAjjMPH
	RSXLlmqRLSigorS0oUBN/gIaUALKYdE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F3703601E8;
	Tue, 27 Jan 2026 19:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF23CC116C6;
	Tue, 27 Jan 2026 19:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542281;
	bh=96EEwJcWySxO2R/2KP/gCzA6SPsvcN9sMFGfwSmvv8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZW1wjmlEaWOSdy5FnqJJ6HOmgWV7pu0s4MRk84xlIeo88QjzOqjdIYlrG7ljWeU0v
	 MeVT/1r5gvKQ8hwIT2RBtV0wKCMd8ov24qkrjcRy4Vfh/Y21OxTvvwPWedf28sTtpo
	 suFN5ZKjXWM1NKIUy+6Dpr+0RTJ2rjrKbQS/lNK/SjFllGnjxzucAuckujiOyB+4U9
	 ccJBVk/3++oHxXEHSESsxUT5xJTAVOyEPse6JLGhtLLEhZZ/XVVi8U9wBHMb6IXpTH
	 /5+0b26eHzpI8qMV5AnhQOxvJp1yjrHIWrURA/5Ndiprz3rlpr6hJnVNc2kD2LXCFh
	 tOhezlpGaLTpQ==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC 15/17] KVM: guest_memfd: implement userfaultfd missing mode
Date: Tue, 27 Jan 2026 21:29:34 +0200
Message-ID: <20260127192936.1250096-16-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A199100017
X-Stat-Signature: ogjp8indc3irrd5jq3p7a1t47ea36xgm
X-Rspam-User: 
X-HE-Tag: 1769542282-577075
X-HE-Meta: U2FsdGVkX18soTb9VEGd3ZCpn4IaTdlresdz05ZCVtUcETfVxw+sQgViqljXuZJfQpidSoXbxW13W+xQnECOf4j1DIB0r33sNc6Kt/q0wpC6WzStI5nF/tfAnrjM777yRC/w5MFgG1MRblYYR5mjU5WzaDkZtvo7aYv37Lh0/C82fxwAcffnW72Hr0jERb9ajgDXKB7Qy3R1AWHi9e7VkhHxwDLVzLL+A/Clj4K8KFas53y2JYGbfmsIkv/LZqWD+fuyDLars6wcVPqjv2/thyX2eV//B136X5iuAEjvY2hT99NUo1n1N7b1Yqw8lVhYa0HyiurS9YsKpIMwxQtmxJNpoc80k75fxX4/8D2XnMJnzKZ8Qq+l+O5aXndMm0ShZ1nj47bQShVTik5rWplrtCYpm5Ov9SmWVfoVB8KDRSoIjA5n8mix6L1+JrpHMjXt8FCxptzWB8Zwj8nyoAEr1kSBpdvmovfBVYEyZEiLCCE7UfLUsKZkvYqySikl0BiiKcRWvpbWg87yfV62w1JprGMy1cXWWcOjq2rpLJDMtYgVQvwll+c9TkLbInCfmOp36buTUpy/gYsX7NZOlj1e4metRHcRf39tGfKKv3DcIIInL69OxvYoe3iTuub7tIddJZP5Zu/wH78YyVMkNB2y6ngUmwUccFC7KR06zOFHvnEVHnF8awr90Z8k2vJDoM5c/BQkTNqEDoWL9vsNWFKJWzq5OZD4tMHzuRxoBoCGPk1KGtETwJUyrH62dWMiiZ4ck1cbzLFNtjnJEtfUX6eZ+oylL0PDaq1UQ1fv9WjEfq+HMJnAeD2hV9wK36hqpA94HCKlqtYbngkQ5kpZ/E0d3F8aUDDULqiB/CYsn8vNhtzZz0rCMZjlNDtMb37o3vezmUDVzOMl7Jfo5VYlJNVqJ1S/6DigV1d5m7tsCw3c3Dv+wJouWb9IpG8zATGEi6lfM+CyFyUlbZ+DKnTy6lo
 rQE/bU5a
 oKvYVbUXGxOIhiXX+OPRnvXZc0WFPo0ddX6Bte/Id6e/QnS+KQkGiKtP6vFOrVlo8T+KYEaGAjMMFk9X3dItm5eQvHj1b42sRmR3bhT7ZzALamvQg1aE7WtxCLQvE2fELJB1gLV3jSuDuUlBwOzKn4zDB5aEhnHtJrQ0b6IBMrpMbhzyQ7K6vCsY6KUKtxlaqzJEeav9Ne6qoUa0QZ9xWD2RTWxoG6ici2DvCadh+3pOYkmfXujP1JOeKdaFiJeg+iG5yLgi6CIiRIVQYhMjmoJaf7e3dBDeeN+MMXZTiYEi3xkI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>

userfaultfd missing mode allows populating guest memory with the content
supplied by userspace on demand.

Extend guest_memfd implementation of vm_uffd_ops to support MISSING
mode.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 virt/kvm/guest_memfd.c | 60 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 087e7632bf70..14cca057fc0e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -431,6 +431,14 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 			ret = VM_FAULT_UFFD_MINOR;
 			goto out_folio;
 		}
+
+		/*
+		 * Check if userfaultfd is registered in missing mode. If so,
+		 * check if a folio exists in the page cache. If not, return
+		 * VM_FAULT_UFFD_MISSING to trigger the userfaultfd handler.
+		 */
+		if (userfaultfd_missing(vmf->vma) && IS_ERR_OR_NULL(folio))
+			return VM_FAULT_UFFD_MISSING;
 	}
 
 	/* folio not in the pagecache, try to allocate */
@@ -507,9 +515,59 @@ static bool kvm_gmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_fla
 	return true;
 }
 
+static struct folio *kvm_gmem_folio_alloc(struct vm_area_struct *vma,
+					  unsigned long addr)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	pgoff_t pgoff = linear_page_index(vma, addr);
+	struct mempolicy *mpol;
+	struct folio *folio;
+	gfp_t gfp;
+
+	if (unlikely(pgoff >= (i_size_read(inode) >> PAGE_SHIFT)))
+		return NULL;
+
+	gfp = mapping_gfp_mask(inode->i_mapping);
+	mpol = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff);
+	mpol = mpol ?: get_task_policy(current);
+	folio = folio_alloc_mpol(gfp, 0, mpol, pgoff, numa_node_id());
+	mpol_cond_put(mpol);
+
+	return folio;
+}
+
+static int kvm_gmem_filemap_add(struct folio *folio,
+				struct vm_area_struct *vma,
+				unsigned long addr)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t pgoff = linear_page_index(vma, addr);
+	int err;
+
+	__folio_set_locked(folio);
+	err = filemap_add_folio(mapping, folio, pgoff, GFP_KERNEL);
+	if (err) {
+		folio_unlock(folio);
+		return err;
+	}
+
+	return 0;
+}
+
+static void kvm_gmem_filemap_remove(struct folio *folio,
+				    struct vm_area_struct *vma)
+{
+	filemap_remove_folio(folio);
+	folio_unlock(folio);
+}
+
 static const struct vm_uffd_ops kvm_gmem_uffd_ops = {
-	.can_userfault = kvm_gmem_can_userfault,
+	.can_userfault     = kvm_gmem_can_userfault,
 	.get_folio_noalloc = kvm_gmem_get_folio_noalloc,
+	.alloc_folio       = kvm_gmem_folio_alloc,
+	.filemap_add       = kvm_gmem_filemap_add,
+	.filemap_remove    = kvm_gmem_filemap_remove,
 };
 #endif /* CONFIG_USERFAULTFD */
 
-- 
2.51.0


