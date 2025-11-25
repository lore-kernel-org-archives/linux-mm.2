Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E170D0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9972F6B00B7; Tue, 25 Nov 2025 13:39:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96E986B00B8; Tue, 25 Nov 2025 13:39:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ABFD6B00B9; Tue, 25 Nov 2025 13:39:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF936B00B7
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:39:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A88A1A038F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:39:15 +0000 (UTC)
X-FDA: 84149991870.11.0D55655
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DF06814000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:39:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qm3Cjfzj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764095953; a=rsa-sha256;
	cv=none;
	b=PTe65nA8hGmTMEPwPWixgq9T8fD6yEDlh+bUG+EWqntvOfhTjMqrBebkjEkB7oQGqLt8JW
	mWkPUxTjUO93G90D63PvYCOwvVMSPhUi11Fxt1YIHGPJ/uax2F4g5Ldcie/ox4WcWrC9R7
	P17UrskyN0P0aC2NnvbtgyBMY8l92fk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qm3Cjfzj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764095953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mgy6gt5zg7GA8YdwAXQdPBWLuCvbH5+eNAkztS79dgI=;
	b=EjJZuEcXay9sKKQKhYmv8H35p0z5eQ11cF+ipEjyxO2AQnWL6gebhq3Fbvbea1QSc+C2/g
	3l1OAGa7J86Y/DNByqKIg5AWLuCRZshIpNW+mQD/JQLQhaoR59NLmr5bjc4Xm+rZXl4QdN
	GsvPktIn9nbARK03uprVdAU/zGR3rTg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E1BC6014F;
	Tue, 25 Nov 2025 18:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56CAC19421;
	Tue, 25 Nov 2025 18:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764095953;
	bh=jqifh5t0Rt8qTazlUsu/nX1gF506d7+nFIH7n1shvtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qm3Cjfzj8WChKet9OWJqezTAxzJgADW07+5ssosubSVDSSkVlspT+QzKiUOojaYGg
	 FrjtWZQZHpHKNQlvk5EDdMKuYhjXa/XF0HB+RQPd8t5xxrxsnJsUYgIP+2L4Q0PsxJ
	 3m0YGyHYvUThDC6vLoGXEAGbJVwa6nAkS3DVXWEnngznaYYWOnh+dcM9QG/rp7Dpdu
	 ihtCaL4elNO4E6DfA0X0jEqlk49d463z3baxRPuNTeSwECc5kJ85YBT+JkwCgOQnxT
	 erUYVbOv9PDEjlFyFJeXak/iZqoaV8LqMDeGchQ/r22Zoow3a2UAuqeZ8Ausudg3DV
	 VmIvT0E8NJP6w==
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
Subject: [PATCH v2 4/5] guest_memfd: add support for userfaultfd minor mode
Date: Tue, 25 Nov 2025 20:38:39 +0200
Message-ID: <20251125183840.2368510-5-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251125183840.2368510-1-rppt@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF06814000B
X-Stat-Signature: frp15rui3uioq5b89ojwx13gq4oo9f96
X-Rspam-User: 
X-HE-Tag: 1764095953-89505
X-HE-Meta: U2FsdGVkX1981qC1Ief8m20gs1qxLvKsoLl8nSEHp7TEdiIzO8DA60eLtwiMIuBmNqThycSJPA7yia8h4cP/4XjryX94JHDqLzcag1yhqMI4ZrEbAhUqzaCcxXGt9c5nr93NQgcCnhhb7OMs87TMSk5m0e2gjdD5otwqR1FYKBH6EPAtVS2aLjQMxzGDQYABbs38qChDHZtWTVk00PPHlYYDqlRrSx6svfNuExKYSrbTpedCSMS1NYmRFFPCra1lMDbMwFs9F+8bACv8H43IlJKfAXP8HMUwnuhF7tonQ5ba8o+p6HzuOzckdxM/J5x0F08zipk9V30LP89YpxUFbAmnbaG9R07qxAR4jL8HdOxRuw6B0KIdFkWNNOCedV/MsCgSEd1O9rdaTJoFu9UVuUbmgDC7/lUcH1sW5qs2ci7vGR78kDv8dOujjRA2sO13IKcQji6exSsiAMBTpdnblo4SD4EC08h9vW8MaXGN0+FY1u9gMTLk1mpLUCEoY8L21d18n+SPmGg2XgBDhm3Jhr3PCeIywSsYbJU5nveydAhQDwkR63AaRZ+8+1j2E/WnkGpfEEgY/5Yjjdz/ee30LcWgpKsVjtrEjk2xef9tlxu3MBbfSCvYAwE4ao5mQ90oghwBRYjvbinr+tYnHlrMOdtrZuhUYLNYCX7mSzlhXSnWOaomy8EvOvjxW99a3E3z5zYJADQPKs6eqe7qy8fCbJG7InzVWJVRXLB/AWdPN2yv/C0hm6DIVe+crC2XwsK3UXcEIiZAhHIvI91Phdi4YtsIHigBTnZAN7ZXwcVwL0gwPV1zHTdwaHAHKgPxKbb8qZD+89WsVMQXdVeJAWuivcLfWnWEXMAsigvAp/QQP9ddPwY1EvfUY1naw+ATqSfwn+L+gBU6a4oM0viYF+p5bSEW1j6v4A9qBAsKq5aoeYGHZNDHIHqNOVjEwa4laH8zVVvgnY4NdxSdFQx71gZ
 h0NvlFfe
 au7MV
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
 virt/kvm/guest_memfd.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ffadc5ee8e04..2a2b076293f9 100644
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
@@ -390,8 +397,29 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	return ret;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t pgoff)
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
+	.get_folio	= kvm_gmem_get_folio,
+#endif
 };
 
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
-- 
2.50.1


