Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835A3D111A8
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 11:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7AAB6B0022; Sun, 30 Nov 2025 06:18:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03CD6B0023; Sun, 30 Nov 2025 06:18:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5226B0024; Sun, 30 Nov 2025 06:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A67E76B0022
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 06:18:46 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E2DD160568
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:18:46 +0000 (UTC)
X-FDA: 84167025852.03.BAA7925
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D131616000E
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:18:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ha1VpMPt;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764501525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HezHt5S4HiSPcqkkgK5MvMd46JoHZhOJ7y7yKHUM0lk=;
	b=U6SfRQpmOrbCq3PwmvHittNXrYkSy22M3p3sSy6I37dRqEQgbApxp08vs1Fk8xGFuNg6yN
	EWbD8xLl4XlkV1YrmNBBGIgQWUmjcIr97j4suuKow1okwgSrHqTuAlMkfLQU4xXqJFdnTh
	WsXHHpOxG3EDXBcYZhOxD/iH3ikhHQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764501525; a=rsa-sha256;
	cv=none;
	b=igDKREF0pKykoZiexmASgslum+pGq7NKAH9zhHNwrVW3EZubSnmlLNd8P69tMCRm4jFCtr
	REEx18TYZ4ElY4WM7DRN1I1AFz9quXbWLyGhF2siN1HOnMjVrEb+ePMMytsN6WcFyfqeAt
	a3wrTuV+6d5hJMWMqVHby289+sJZRzs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ha1VpMPt;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EA6E40602;
	Sun, 30 Nov 2025 11:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8BCC116B1;
	Sun, 30 Nov 2025 11:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764501523;
	bh=02TV+J21aRh8Y7GHD/quPCqz9iq/kEt5UBYeya9wXbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ha1VpMPtHwMP3wcPEvYjsA/TXMScV1CPNuo/cC5Lu3DHFteFKJfHohkZUPQKy0KVH
	 Jz15kY7NsoNnb2ifdGn0TVWvzfZyhLUyxG/9gwIiLivBDv2L+6NlrOm5HO7uAQ94VQ
	 W43OZVat768mPtgYQldsGVGP+DmrQ8p0eWovjw7NXQrngRyeR+P0y9W6NokDg6dW8c
	 WIecaNNGhqHcEWomX9JH4q2tcK5gXHSoUMT8n5MUCD6/p4ACgXX3jGubo4z7Y/nL96
	 nIZjMnQQSlLbYLMkRCy4SeLc/cuF1vSR8fRe2LRWKD8ko4jltWC0qCn1GUXPbYN46g
	 CtYKcNVHiSLtg==
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
Subject: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor mode
Date: Sun, 30 Nov 2025 13:18:11 +0200
Message-ID: <20251130111812.699259-5-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251130111812.699259-1-rppt@kernel.org>
References: <20251130111812.699259-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D131616000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: gfm7hznhrmyzkwz9fgaw5k19mmpyxbuf
X-HE-Tag: 1764501524-781345
X-HE-Meta: U2FsdGVkX1+XFhO9BrWgdMJZS8MI36eTWrmvzCosiDoTh4zrHqbhZzm4mlawIC+knzQnriKSDHw5NLEAujx4olDEiBjntwO69yFSaxXkmFB/3BSfKXYQ3qSrWBxk9qzEvt39cn4Vbxb4MT/ovsblHBcsBZZVzTeLDrp3JCh6mO0F0RPLG9dFmQt1tTY07fjtdeplUzkyHANfLwRqRStAZ9kS0sxo/yHpQkF9OkAewwm7Mw5RoKL6spmyzRrze7aBdtNsuhfYvUDTAuM6STZmD4KOVkQitirYEc3+J5HAgzdQlvK0iQSLF1GY0A4qEtJwlJ5ZM2F7WMEsZtqy62l/VEi9N92tsjcNSyDVROjKOVYK4zfYz6ZLleddTn4l0LbzfC9yS19FXvnp2i8qHXYSj6/Q4ptLDWkJ2Wie8Rvc45xJ2bWrQ308TJJ+qnkTiGdh4Q7OzY9+A7L4lZVJFbKwfNb3Q/TRCCzEXH91E6sEawyeKcGPjwhizmEmBm8I1qVoiW6qf7J6pgBmYUklGnP8d1hnmaaB1AxtGyGtDr1JmXuyUv9fqmFt9zQOecEIsc2AAReOWnrCR5tMG+i++y1Be2tP+QGD29euLtpoDf4tfp9cSMgip46QdfTMBISf1BZkk6Ax0gxJVQzer4J21oyo+TfYHnnEx9/XfnWkokHKpg6Y4ZVhyYN8tjWBt45xDpCPM6E5MXiDfkKTdIzHbbmK/RJnl27G4P67iRCMTtwGCjA1jJKpCMK9ohGluEq+8/76Ku9TzKc0mnVHnoY16qqtRahhHs1mWJHQt5TSVvYjCGeN65XTzIcI1asLxSP8wdYk0nCW3MpkEXXF9r7RXIFcr3LRneY4ZIzSMjO28AmOPdYLcPuzYVbngVaZZQcmd1ICMz/w1sM2Db+zfpeo+y3TOOd5Gh5InlCVEcuiEgQuKX1oGcYp0U5GD4EGQe8hZQ8FXym0VU4mddnsNphnn4/
 tWp2qAVk
 i15SZcp4Ib9mapHp2CLhp1LX+S8Glf+p/gy9xex87ldU1Yref90jcJutUbEnbm714R81CxlBT6wz9RDqshp4wBLCLTSbJIA7M8I5WEqRG5y1LHWWnPGFcPWnF9Zsz6MvuE06jBZQN79ahlEKaGBJwXwBJmwLTFSGtPj3b1qWJvvsx4bF8Y4tncb+nE5DpIq4dKazOZKzVV/gS1FdDjrx3eq5MXlVL7puFBadDoajwQ4cWY7u2IzEHuI35oujTlpCLcpTCNzcut0p1RQBMCyQXDTNIgkRFIBTBLu9P3YiHumDx2xqh3IT/0ZHJBA==
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
complete and add implementation of ->get_folio_noalloc() to guest_memfd
vm_ops.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 virt/kvm/guest_memfd.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ffadc5ee8e04..dca6e373937b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -4,6 +4,7 @@
 #include <linux/kvm_host.h>
 #include <linux/pagemap.h>
 #include <linux/anon_inodes.h>
+#include <linux/userfaultfd_k.h>
 
 #include "kvm_mm.h"
 
@@ -359,7 +360,15 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED))
 		return VM_FAULT_SIGBUS;
 
-	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
+	folio = filemap_lock_folio(inode->i_mapping, vmf->pgoff);
+	if (!IS_ERR_OR_NULL(folio) && userfaultfd_minor(vmf->vma)) {
+		ret = VM_FAULT_UFFD_MINOR;
+		goto out_folio;
+	}
+
+	if (PTR_ERR(folio) == -ENOENT)
+		folio = kvm_gmem_get_folio(inode, vmf->pgoff);
+
 	if (IS_ERR(folio)) {
 		int err = PTR_ERR(folio);
 
@@ -390,8 +399,30 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	return ret;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static struct folio *kvm_gmem_get_folio_noalloc(struct inode *inode,
+						pgoff_t pgoff)
+{
+	struct folio *folio;
+
+	folio = filemap_lock_folio(inode->i_mapping, pgoff);
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
+	.get_folio_noalloc	= kvm_gmem_get_folio_noalloc,
+#endif
 };
 
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
-- 
2.51.0


