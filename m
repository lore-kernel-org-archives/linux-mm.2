Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5988DD2FEDC
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29246B00A9; Tue, 27 Jan 2026 14:31:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD396B00AB; Tue, 27 Jan 2026 14:31:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E209C6B00AC; Tue, 27 Jan 2026 14:31:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD4BF6B00A9
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:31:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A18131A028A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:31:11 +0000 (UTC)
X-FDA: 84378737142.17.74A2B61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1457540005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:31:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hxCun7NY;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxZ9r2BjoEtbPBDmEi3Utu3rEJ5KFl7tG80VJfCvYyo=;
	b=yPZOee0fwG9rH1s5UOwtRN5FsQ9MwUCU6To7g7j6bDccfmFKu/TARbza/sWhlu6Awdwadx
	QdlklQbwswhRD+8Rbj7ZuXu6HEkrLhNRnrIXXOsL9JKEEx1eeq15qQ9CVTdL8zRmSlFPVa
	aruPpAGEftOOiXX8Db5e2uKyRUbvL9U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hxCun7NY;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542270; a=rsa-sha256;
	cv=none;
	b=oHOl7nJhw4UXVp31p8XV70sfYrPkNHakPXXBHZo0/36xaeI0rRtg1zNJtg8KOCLxzF1Vaa
	CBOIVbzrC840n6LCCRNzEFmAWjoM9JzpDRNBtGK05fFAEdbxIkaLBV3i05BwAY3HW/xvou
	WayiPrDNWckbAiAG9V5afRjesyPdn1o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8194160200;
	Tue, 27 Jan 2026 19:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72991C116C6;
	Tue, 27 Jan 2026 19:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542269;
	bh=+RlyxhG8wPwYaWoZfV3wHqPdgp7OwXA/s55MoAiNhJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxCun7NYeayN6IkquZNPDK6UUnd1cAbljA2eL0BVX9w58wypp6/mCfqTEe8bHxP5a
	 HG4OouTbgYoMhHWfngWLGr5c2/z/XbLR5ETtxzfmFLGLns51cPfDLBrvvSUx18cp4e
	 ndfN0qt9j/sfkyHEqyjwx8YVt5nPQE3T389NiQ0VWC92VxIiaSBx8/e+63FoGVxIWZ
	 4Zcs+7dyUpegnBUsSn5MbvHtNdkIrtfxEYCtVqLblH1y7e4cMmySJc/k11QIs8g/Uh
	 WmM/cmFVYJd2vqUFcJ9yZ5uiwJ7k1/o/TOfpz73DmNLM4l61/9gwO/XPQZdiZ3f8kT
	 v+fkzz1g90MJQ==
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
Subject: [PATCH RFC 13/17] mm: introduce VM_FAULT_UFFD_MISSING fault reason
Date: Tue, 27 Jan 2026 21:29:32 +0200
Message-ID: <20260127192936.1250096-14-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1457540005
X-Stat-Signature: zdj3ddb8efrwxzxom39g53w38fn88u4y
X-Rspam-User: 
X-HE-Tag: 1769542269-311702
X-HE-Meta: U2FsdGVkX197CswCtN7yXGqcMDH05YehjH0DcEKDYfOCl4vZd69C8aOBGF4zqf8kU/iq7OoTOdacXu4JkyefW2g+5RvfO1itUjbz1s9cjvZxVjIOdpnMlovDSwzAwIJomyfAsY9CDPEywbZKbC+AxpHUDPdAAWO/G+CixgGirNbiGc51/nnFPUED1HaL2rgFv8jqHC3pOLHRrLBQl3R7e312PHCX8MrHCmKokGnHLiNyZMDf6PnQbJlgbspkdJvSULqDEzRkIVPzc3slINCjr6xi0hE6tDiL27PTprZ7rDaiqyHGykMoyaBmsIWFkgpH0hPcA8BYbVWG4h0vhTChGW5W1tFXUaiBk6zInbpdd9C1qfGRy3bBuMT2XNJIB4cwqyBWAYyKeLTpS8U/Z0KsaenXK5dQQjfuLyFcwF7WazaZ7MIFLxe2oQhTXdbtGM75CscMQYehE27C6Q8lRRgDB29yt2BY5ZFJxnaRgP/z8LVQ+v8BtSKgdRPJWTI+hwmuozG7OjBxRS6M1O7x04duvvUAeOAV4en0SkS7TZYODmZlw5bF6nZUok3frN2ob/tyrPssy3rqtfYnkpm7IsCI+2AkUoVtB1G350qiPHFLeh+7mZ1f+FC8zRXzTVj0NvGCX8fi09FprYqGa2LpRG9Fmfo2s1zpxTGeo3bRul9p0trlc37nI3RyEH+/i8QxNWrBb7fKSoZLiO5RFGryvc1MZomOuoHWWqUIagJh8cjnqh0gALx+sazOzvZbwqNyPls9mTylsujLUMH4og5BZc/tbyiXAQszcmsX2O0lB0d/jSh+GHOIGpMQT+7wU0fr+cbXDDAgIhPpcrAKF9ME7z/o2cdKmFB0lnBFW5+XdT8dFcG760dxuRLLdjFGoh6zKGwNqr7UwzjbsGCTgYw3C4gj61HD/1tGPGyxn35k8a00WNvLJmTYJsQNWA31kAxOauliRSu6pnboOuYaEwa8LfT
 mHoz577y
 jlxVr5Dn9ea/1tKvfxgqzhhO6A/1dkRDycpkh5qSAZ8qt/Mqvy8Kd1aX07h1LvaiNkuUgt3yd9B0gdUyGp/DZfZ62xTSACUW6j4B20FUDkeCV1IpCYcMiJWlE0gXJtyeIb94HXQfiWkSLUc7KZEprhgjLDoql3wD6xshGVH+dvaTLgeFBilpUdFIEI8k/1Zh/8+sRYUabUL+vHa6Yp+pLUtp7Jsr2rZ7jvwMVPoVvvGmyweYNuFhR88kIaXLg7D4ztv73xKpm0/jP9MkAdAnP2BaWIZ7jbbzfvDUIBJpwqTbCDjqdwGZOXJcSn/fsCTNKcTopx51WUkrPgNX7eUOfOu7qyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>

When a VMA is registered with userfaulfd in missing mode, its ->fault()
method should check if a folio exists in the page cache and if no
->fault() should call handle_userfault(VM_UFFD_MISSING).

Instead of calling handle_userfault() directly from a specific ->fault()
implementation introduce new fault reason VM_FAULT_UFFD_MISSING that
will notify the core page fault handler that it should call
handle_userfaultfd(VM_UFFD_MISSING) to complete a page fault.

Replace a call to handle_userfault(VM_UFFD_MISSING) in shmem and use the
new VM_FAULT_UFFD_MISSING there instead.

For configurations that don't enable CONFIG_USERFAULTFD,
VM_FAULT_UFFD_MISSING is set to 0.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm_types.h | 7 ++++++-
 mm/memory.c              | 5 ++++-
 mm/shmem.c               | 2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b25ac322bfbf..a061c43e835b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1557,6 +1557,8 @@ typedef __bitwise unsigned int vm_fault_t;
  * @VM_FAULT_COMPLETED:		->fault completed, meanwhile mmap lock released
  * @VM_FAULT_UFFD_MINOR:	->fault did not modify page tables and needs
  *				handle_userfault(VM_UFFD_MINOR) to complete
+ * @VM_FAULT_UFFD_MISSING:	->fault did not modify page tables and needs
+ *				handle_userfault(VM_UFFD_MISSING) to complete
  * @VM_FAULT_HINDEX_MASK:	mask HINDEX value
  *
  */
@@ -1576,8 +1578,10 @@ enum vm_fault_reason {
 	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
 #ifdef CONFIG_USERFAULTFD
 	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x008000,
+	VM_FAULT_UFFD_MISSING	= (__force vm_fault_t)0x010000,
 #else
 	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x000000,
+	VM_FAULT_UFFD_MISSING	= (__force vm_fault_t)0x000000,
 #endif
 	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
 };
@@ -1604,7 +1608,8 @@ enum vm_fault_reason {
 	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
 	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
 	{ VM_FAULT_COMPLETED,           "COMPLETED" },	\
-	{ VM_FAULT_UFFD_MINOR,		"UFFD_MINOR" }
+	{ VM_FAULT_UFFD_MINOR,		"UFFD_MINOR" }, \
+	{ VM_FAULT_UFFD_MISSING,	"UFFD_MISSING" }
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
diff --git a/mm/memory.c b/mm/memory.c
index fcb3e0c3113e..f72e69a43b68 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5319,9 +5319,12 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 
 	ret = vma->vm_ops->fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
-			    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR))) {
+			    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR |
+			    VM_FAULT_UFFD_MISSING))) {
 		if (ret & VM_FAULT_UFFD_MINOR)
 			return handle_userfault(vmf, VM_UFFD_MINOR);
+		if (ret & VM_FAULT_UFFD_MISSING)
+			return handle_userfault(vmf, VM_UFFD_MISSING);
 		return ret;
 	}
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 6aa905147c0c..1bc544cab2a8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2530,7 +2530,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	 */
 
 	if (vma && userfaultfd_missing(vma)) {
-		*fault_type = handle_userfault(vmf, VM_UFFD_MISSING);
+		*fault_type = VM_FAULT_UFFD_MISSING;
 		return 0;
 	}
 
-- 
2.51.0


