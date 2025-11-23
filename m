Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2BECFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 10:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B3AF6B00AA; Sun, 23 Nov 2025 05:27:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43CF16B00AC; Sun, 23 Nov 2025 05:27:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B706B00AE; Sun, 23 Nov 2025 05:27:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B41F6B00AA
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 05:27:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B186A1A0ABD
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:27:36 +0000 (UTC)
X-FDA: 84141495312.23.3B6BF95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id EA574A000F
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:27:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OBrZFSOb;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763893655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z42ezNjg6kGrmKl0vCoXeMhQFNBrntm5Z4rbLxBRjV8=;
	b=2T9xJQv8jnFF+MdvMh+000ekEQLH+gQPXBkQNjmlP5tEbGAQNPhvz4L/zgq2ttAMeIKYyD
	h9RMmNV5XXYzyvteAXcwbGnX+sTTdJ1pfaEFXv0WSvjG7YKqBaT3cy/g/wkjGg+w5cK8HB
	HkJnUwNL/lTDr6JTVvLg7ERSfKZjXlg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OBrZFSOb;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763893655; a=rsa-sha256;
	cv=none;
	b=33jMfpkFdCKLgMjSN6ELLbraDrNeByYNdeaYd2aYOlDYUTyB8MC2I1/tuzxbePduZlVw17
	lhXnlxeZUcd/4nK0XFkapSmfmqAYC0vSh/iWmJe2ey6clGympeF+SqfQnO0OdLMvthEXy3
	rZXNTQ9f4RITO4TcE6L4qOMqPOjsWMM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EEB9044344;
	Sun, 23 Nov 2025 10:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B67C113D0;
	Sun, 23 Nov 2025 10:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763893653;
	bh=TGp6vvbLTdhwYnCuBgb7XJ6N0yTp/sgeTzqO6gH5CkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBrZFSObtudrp9MGuTQx1JbCUW5/SlKmBilfqqt7cVta7+2osmrx6ZyWfiBxv7L+S
	 mv/oSxzGa9Pj5oyj6UeFbBqXqa/DnMTvwBT/sA1csuz0mHlB89qW61bP7HwGxsGmg9
	 F0BrGRGIL6+ooQN6dT1CUYLo5WiQmeqG2J4vOJ4YlPKml3KDHUbncQtw2KIOgD+gK3
	 n33A0tSjubrO9zwq2egBfRT0z9/XLeBTBTRDwuZmtjoAnb2WM7jM2hA1KBwKkJzB8+
	 tuj7yk1fsO69UQ/8E3JifeiIs6M9V5DAx1SDwyL5RS6CqOcD86pyfDzyQs5eYwe59O
	 xR3EW4IXNx/xw==
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
	linux-kselftest@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
Date: Sun, 23 Nov 2025 12:27:05 +0200
Message-ID: <20251123102707.559422-4-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251123102707.559422-1-rppt@kernel.org>
References: <20251123102707.559422-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EA574A000F
X-Stat-Signature: t3do8s8dx87wd98ebdnc7yy1hpgpceqa
X-Rspam-User: 
X-HE-Tag: 1763893654-731611
X-HE-Meta: U2FsdGVkX1/inu1NaZKP9cVTEybUgYXfxgogirYahceW3Kinfx7gqprvd7BOw84GPzbkhJvEtSQPxkJhABWgEF086nNvBI+TUFO510OmyCDdHu8toZxXS0Iei7lp4jEX1imFGL4AhiQIkL7TdIx0mQQCZhkbc0Sh389EQZyrr4uhG9Yrcs0NNlYPGeMKx5plCoLeIf4rj0rbAC1g/Hg/d5FhQmnG/1OgVHf06VXzXmGA0yMCq+e9APw+YjlrdoArzmZiluEii7+WSrwrqOTye77sutba1JN8TKBoZT8Co1Sfx9CduvVIotli4Bv3FhZ74SjKAGCWPoWBR5IkWWAyMz/MYfUtJigQ5kIptJhC190FXvaWiPblCIR57x9YULsKYUrdLxMAfTlR9BjHioDLx4dbSNMNuPWKvVnrelrwP7lxWjd4jlsA7Hk+Tc0GrAlBlU2tkX7oCQAiZb+XHejQQVXOjYUpqmstDqmuLZGvQWhMUUjJNarMYqusnG1xKPhNAkCBg28aStywXBYd6/rHfZkGtVroa+Mv1BEgwFFak/v7/OLRHRXg9XvAm9nrDQUKKbLx3faWGmrthiXBadAyX5Cor4GEBo9xtSAahCDVF1xK3obz0HVuqiIPU5NcDsKnPGXnw/DwXoSjsLGzq8ot803bEs/bgArjxaFYmJh7k40rH/9x6CgbhqLzgrm2pfFQVbC1E9JZrwYndifNYUJN1RnYavyUeGooyeQU6vbj9IO1nI2w3VHUuLwrbEbWFazGmbnW9fJN75ucWO2HP994uBlMG8WSiIYlIcj7T4tnJtiRylwtGGwmNu6lblMMvwxHWp/oAmWf1iQvNXiJfVwfIH/i42gXptMzNVTWB7r0LjSIWA+IT41PaXX4r6jsdIRqYYnuq58R3V8fQMEDb/6nYWc2AoSB8m++IBkAi6LDynClgRANjXtYK2mVyJbPXtZz6HqkF6bb8c+7pmh3KW9
 qDQRE/rI
 +12Vr75iEUBkikBVe+7xIFMYVMtOTpMZ5URmntlOW2qq+/ThyhMJAwaZD8NXkbcPpQgIThD8pwqd4p0iPCwZnzbxCrrtX2dNnIxA0Vs/PmCIT3fcRzIO6GpUCgDj+56sWd/ajYWBnlhRdyVikW3qmxkDNGri5kTUhPK3FXMnf3gwZBnO1S8Kun+PIsFrYHehP8uTolVyWOsdDnk2M8HXE/9ZKFNl9pVhTgm/xVoytyEpvXfhniLOZ9H3juhIDdBn2Y2t3kANeg872kSt8vHf629cq62fuuxjPlOXZ3+/Y+YA+WwzwoxtySD3/HTTN9nXWXHmm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When a VMA is registered with userfaulfd in minor mode, its ->fault()
method should check if a folio exists in the page cache and if yes
->fault() should call handle_userfault(VM_UFFD_MISSING).

Instead of calling handle_userfault() directly from a specific ->fault()
implementation introduce new fault reason VM_FAULT_UFFD_MINOR that will
notify the core page fault handler that it should call
handle_userfaultfd(VM_UFFD_MISSING) to complete a page fault.

Replace a call to handle_userfault(VM_UFFD_MISSING) in shmem and use the
new VM_FAULT_UFFD_MINOR there instead.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm_types.h | 3 +++
 mm/memory.c              | 2 ++
 mm/shmem.c               | 2 +-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 90e5790c318f..eb135369940f 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1523,6 +1523,8 @@ typedef __bitwise unsigned int vm_fault_t;
  *				fsync() to complete (for synchronous page faults
  *				in DAX)
  * @VM_FAULT_COMPLETED:		->fault completed, meanwhile mmap lock released
+ * @VM_FAULT_UFFD_MINOR:	->fault did not modify page tables and needs
+ *				handle_userfault(VM_UFFD_MINOR) to complete
  * @VM_FAULT_HINDEX_MASK:	mask HINDEX value
  *
  */
@@ -1540,6 +1542,7 @@ enum vm_fault_reason {
 	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
 	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
 	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
+	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x008000,
 	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
 };
 
diff --git a/mm/memory.c b/mm/memory.c
index b59ae7ce42eb..94acbac8cefb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5279,6 +5279,8 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
 	}
 
 	ret = vma->vm_ops->fault(vmf);
+	if (unlikely(ret & VM_FAULT_UFFD_MINOR))
+		return handle_userfault(vmf, VM_UFFD_MINOR);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
 			    VM_FAULT_DONE_COW)))
 		return ret;
diff --git a/mm/shmem.c b/mm/shmem.c
index aaa21bb60f51..6dcb73b52bcc 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2461,7 +2461,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	if (folio && vma && userfaultfd_minor(vma)) {
 		if (!xa_is_value(folio))
 			folio_put(folio);
-		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
+		*fault_type = VM_FAULT_UFFD_MINOR;
 		return 0;
 	}
 
-- 
2.50.1


