Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A4ECFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 10:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0916B00AC; Sun, 23 Nov 2025 05:27:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1656B00AE; Sun, 23 Nov 2025 05:27:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B90B26B00AF; Sun, 23 Nov 2025 05:27:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A57726B00AC
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 05:27:42 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E0F5130A91
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:27:42 +0000 (UTC)
X-FDA: 84141495564.10.C20BB86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9620E40012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:27:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QYSK81Np;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763893660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dBV4asQvIyChvLY3bemMQvZu6BHbwLf+zFofVTnWLs=;
	b=fpZYoVJc83bkN7F08Vu7ola1euPcuHjZxfxMtGZBLCFd/zUESU/FiDD20J05WFJkKaPCC4
	Oe6q8vImy4CpY8sl7cb03Dzb7YsY0lgD+J/AauldQVV4e2Jj/JNwB0qiJ+Ef2Ki8QkrcgQ
	RkoBrm9Vopm0E8jPL08QHPApFnXH/Xs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QYSK81Np;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763893660; a=rsa-sha256;
	cv=none;
	b=O08LDOQnKcNd8zAnXQtEP1Qyj+BbpmnZXV1Zv2pOsjujj0nkdZ70VNZWG00eF/fmfloASD
	V+d0hNqpx7VrLqMLOZjPKuH6QBGP7T5J4DDMYSob2oc1kNb7CVEhGYXQd7koifwAxFmUYO
	e6DFh43iUoOP59yjfp0jdhldnzKikmc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A429543D3B;
	Sun, 23 Nov 2025 10:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2FEC116B1;
	Sun, 23 Nov 2025 10:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763893659;
	bh=MXDXjuuhIpZHs+XYyAm2UYANZTzUP59bGHx0lNGyMTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYSK81NpxPj/kDa8lMOmb3+46yyatrhh+rNN14oIxkrCYIRITAi/b2OTiIBwhhCAe
	 KvuIOxmtBaiOruzKv4YnQ8Yl73mtzm1ZPpgsYYNidZZRzpZs0D+EppnHN40aka2OWI
	 lEK7xsO1APEy1LR9TPhI9pp0z6QXZ7QlGR3oKwjuI9vF0HOa6cpEfDITH63MUAmuBc
	 yrxOjuoi6YB0ZUHcZt3rztmUddq1h8E7yISE3rT/5hSrsRFKEt5XBQ6rLTQIYHQjAs
	 xLUOu+eDypuj3X6zRq9GTnrVotfkjiqDbESJa6wh8+Boc/YnhARPWO+kEubD6qwfIh
	 LR7yFXyv89ZPA==
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
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 4/5] guest_memfd: add support for userfaultfd minor mode
Date: Sun, 23 Nov 2025 12:27:06 +0200
Message-ID: <20251123102707.559422-5-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251123102707.559422-1-rppt@kernel.org>
References: <20251123102707.559422-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9620E40012
X-Stat-Signature: 3c69akyea3mef7cfdnhyktdhoqqwh96t
X-Rspam-User: 
X-HE-Tag: 1763893660-77604
X-HE-Meta: U2FsdGVkX19e392PsznkFw7H7CjRLPNH9GWLSZyRnDmHnY+NchIUh07dc3jd40c0JZmusgqJeUJH5xcFqMx2Th6Y81SlVPCrvFKmoQO+TeXICIwGl1hTf1TllMNAV2l/uarXQcuJ+bE6QZ7AY5GyXDFnfFGIigvH+h9cb5DfnvII86y/to99NNnzFFOsA0DKU4xHJanXEasLa6GjJfGy6/zqnAgoZo7Ooegg0sTR1mo8EKXCClIvaZ2+7nN2rgv74sJfkwgI5O5comsX+mZXhOJG29Nxt2VIM5oMF/7/c6m0ttKLhGObJ2CnRGA3OR/VRAVZZuyofkHzrQ7zyHhAVsGlW+OOAQEvGo1iFko0e+PQwvyu4WAjCzMyDcAIZ3aGPwGmTZWUdGVPTyFr6KG1zd3H7GcBGNO6rY2vjzRynhPxaZIkhLGus2TSJbiEzTaJlusSk65eAoVrTdtep656dADlAnmFYp2Orscc1+667sRcW+YTbiVX7PHXjS2r5nImqiJL3kpjOueIejiVo9jJeKrQvfSa+r8uNu5iPuZZZmEzhASTXgFlCoR7/WuHTfj53mlxYQdFIBnczgY5OT+UVxTMeYoboU9cYuUjKaoOUdGbzRqr6ZX4jYbbLX2klK5aPF8NMTu1EdFjXanSJB+BxoPyVhRKOdXmGO6tA2qcC8EPGIPL8ij1RIjdhtMK319HuoI2RGEc2hd5uFdJGV4IRzOkqluoSpo3co9+25F6Vd576doYbuxhyzXg2ztGtMeRxvYiPXgMm3ykNu9XlbXTXLQpJUHogulq28Fyzdy235URqdssrPdZoe1N7vMLoV4DwhurGst23iVw4ecxBQln6iyPJ01CZo+l7kXG4fQEqX4G/bavK97/sy0n3eTxdutIrQmosRdHMIzpzbAto4UuZpnnZfeSzQqfKqXr8SsW2a2tC916mRkKWKHLKGKesI/+OSZ+9kRi3j6YZ4M4wsY
 +L5oWz0y
 U+QU5gVAb7t6dEPJMLvg1DXdd84HUEaKWS2ncDK3i4a5ajzLM6piu9lnQrC0Fx+orWjUzCkZnhC2kHgNmRAUCQ9b+eixpvz4elcIDg4G4M7QduIqqlIpJWV5P3ijEi75kHCqMjUlBTlwKBQjtYg9sxoHpXmGsnoPmsnD8FoonfBbeUUOmU2o71WDdcMjmnalY/qdCnNLMSVPih+nchqhddjoEXy8sCD0TfA8FQ++ZdVF3v9nsXqLfLAEFO77ArGDBdoD2XPp2Sy7x1DEJYWzFSvfECOc8hWb3ThJbzQ6qkoO1gXPSjHlpz6LNISK+dq4/3Cz7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

userfaultfd notifications about minor page faults used for live migration
and snapshotting of VMs with memory backed by shared hugetlbfs or tmpfs
mappings as described in detail in commit 7677f7fd8be7 ("userfaultfd: add
minor fault registration mode").

To use the same mechanism for VMs that use guest_memfd to map their memory,
guest_memfd should support userfaultfd minor mode.

Extend ->fault() method of guest_memfd with ability to notify core page
fault handler that a page fault requires handle_userfault(VM_UFFD_MINOR) to
complete and add implementation of ->get_shared_folio() to guest_memfd
vm_ops.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 virt/kvm/guest_memfd.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ffadc5ee8e04..bc8337f104ce 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -4,6 +4,7 @@
 #include <linux/kvm_host.h>
 #include <linux/pagemap.h>
 #include <linux/anon_inodes.h>
+#include <linux/userfaultfd_k.h>
 
 #include "kvm_mm.h"
 
@@ -369,6 +370,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 		return vmf_error(err);
 	}
 
+	if (userfaultfd_minor(vmf->vma)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return VM_FAULT_UFFD_MINOR;
+	}
+
 	if (WARN_ON_ONCE(folio_test_large(folio))) {
 		ret = VM_FAULT_SIGBUS;
 		goto out_folio;
@@ -390,8 +397,30 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	return ret;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static struct folio *kvm_gmem_get_shared_folio(struct inode *inode,
+					       pgoff_t pgoff)
+{
+	struct folio *folio;
+
+	folio = kvm_gmem_get_folio(inode, pgoff);
+	if (IS_ERR_OR_NULL(folio))
+		return folio;
+
+	if (!folio_test_uptodate(folio)) {
+		clear_highpage(folio_page(folio, 0));
+		kvm_gmem_mark_prepared(folio);
+	}
+
+	return folio;
+}
+#endif
+
 static const struct vm_operations_struct kvm_gmem_vm_ops = {
 	.fault = kvm_gmem_fault_user_mapping,
+#ifdef CONFIG_USERFAULTFD
+	.get_shared_folio	= kvm_gmem_get_shared_folio,
+#endif
 };
 
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
-- 
2.50.1


