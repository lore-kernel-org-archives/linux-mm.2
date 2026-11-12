Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E97E1606A899
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FvnwKqpc
Received: by kanga.kvack.org (Postfix)
	id 18C166B05FA; Thu, 12 Nov 2026 17:09:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13D026B05FC; Thu, 12 Nov 2026 17:09:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051916B05FD; Thu, 12 Nov 2026 17:09:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE6736B05FA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:09:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5007141CAF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:09:52 +0000 (UTC)
X-FDA: 85427860224.12.B1E7F53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id F1BB3180002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:09:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FvnwKqpc;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794521391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gsRbuJEJwCTcibbrdQQs2WldoOZg99Pqbz3RTzOTVo=;
	b=d5vjQ7tZjhtA0se43MA8yZvk90QYS+8eO7E4yT/CCPS6Im35yhnMH5qi+SJgc2AZlVyQjR
	MAtwe1QqHCjEZdGHeQssiu4+yQgcqSHV4PJ0QFuka7ogVdvLfANzRQ0a0v1PtSWkqBETSI
	BXss9MChzva7vMSKH0o4t3PfsZjcGV0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794521391;
	b=2b3HWlELEI6CLAQEEqspXmtbImlqWTcXrGDgGTn8n/Bui16e9r+dX/YjqGfIC7ZbHl4j8m
	APqMWxH/9n/DDV5Z5uVy7qV2RrhvqfTvGVFLWI/hOEyKrlondrXnmsTABJgZUewIxFzNyK
	zB7qhbFVWW6NNexKDJRm1it375ROgpA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FvnwKqpc;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 460904642C;
	Thu, 12 Nov 2026 22:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365FB1F000C7;
	Thu, 12 Nov 2026 22:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521390;
	bh=8gsRbuJEJwCTcibbrdQQs2WldoOZg99Pqbz3RTzOTVo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FvnwKqpcKcEmQoEVSAantOP8U3nowBSKBswXy/Vr/QSEPlk1X0ZZdZLar0FQ88wsw
	 KDlF+Bz5dPMWSERxJ1zqJ10doktkm+0dbYjflp67dUutw1XEHjbllq+cSkwDBm6sEM
	 0f9kE/pM1lhAY7MHRP57/G2xZA1ZMLn7vR3Q1Fy7j/f94jocRIuv8SzIKm+kDNAVIH
	 W2AbY9cNRdpRMxwKO9wfnL7LPiHd0Lfnf+zzrN21K7bD4jjn3mVXuzvlDeqWRAuPf+
	 rSrIP3Wf/U16flzgKesDUi9UCP67ABHRto7bKZsh6V5Nav+ALWhllSRvdH23vWJ9fK
	 //489VV0Jz70w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Nov 2026 23:09:01 +0100
Subject: [PATCH 5/5] mm: check permissions and bounds for vm_ops->access
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261112-access_shite-v1-5-988a5c470db2@kernel.org>
References: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
In-Reply-To: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Willy Tarreau <w@1wt.eu>, Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>, 
 Matthew Auld <matthew.auld@intel.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Rik van Riel <riel@redhat.com>, 
 Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3284; i=david@kernel.org;
 h=from:subject:message-id; bh=rMQFgIk3QDIpBHKVD0wAYIXGnRD6cxdJbOe6QfU1m24=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+WfyXWNI/bfusvAaWxGWvQhmcd6d/KfNWsdG4HKLxR
 53BMNy5o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIkoaTD8z+FZYK9gU7Xpzhff
 ncV3j5ZUmdun3LVefrx8vvRLHoYgFYbf7JOuhR7dwn5p26sZIjbvf4QH6rQu3+/Df+hmeXU32/4
 iZgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam06
X-Stat-Signature: 66qkhwb6s38eixk75hu1twdpsxx94xzw
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F1BB3180002
X-Rspam-User: 
X-HE-Tag: 1794521390-307895
X-HE-Meta: U2FsdGVkX18q3wvHEZ/woU/6413JLHUrR1Ny+g3tClGoy/KlDS0jhsQrZLbJjtUui976l70hB1l1bEpgQbH+bKc2CVRDNRbQW5u0qlMXzYzV+KKrC3ZU7UA4/Xyyu9Ct7gziNsC+H1huJzqbCexGeWarYoz66CQx9YPgT/2EUI6y1ninFEX0+PYsm1M3BSbbYkgm0K2W0CaD/KUO+f6B/CBpc2Rc9YCVopRcKYIoBjhpm5Vzstnlbz8MvmLtzGPU4j6jjFxCWql31LaCWU+io8JfFkkV+/AWp7G92qCgy8pDbumf6jMIWbwIBn2uZCOr0qsHsZRACNnV2KqyXDMhA4RN8vHzcyxO0/LvM8o9eZd5UL9FW2RO+2U2UBetlgwIricjjagfC/yZS51W4vNrEUiFR+26+w7DgdSiA0I+zDKXnsJ04jq3kgRJs5GdXaBAyhhUFDWnKUxj7971HCZofl/Xv20tamq0SzokoEZHtPrOsOWdUlTAZyioSImpckwBcKMzE+BDa8GtW2hWyq58DzEAvVt3kuvElYXT/BSda54vPfhqKuv1TXTZhiNotM3omdfBEZ01KtJeqSOT/tudnFqIYVjRVGYqmTXcgjlFt/+dYGXPIoWBJk4qVJLHjRj50fnTMGGdOJKqUKrxHG9im3r2LUDYinBL1CLfVdotcnxsCxsw8Jmq+ZivNtBHO044JKSOf+0dJUbFBsVsp9Cn/IGsSHnIneJKkJipmZkai7Ne7qgwxe0tKhJQ695VKsRZBxgJUStfSpFZmoSQXf+dwmpozIMyqfCUKMK5LhnfUg4vCx2kX/hu/eO35OCsXnFVGLxVu/8zXL3euAIShiqEs58kvjOntHKjFqLDnxXFgeRA774qzDzZuoaHXI4Q0Ni5ALgzFqBocwHDLFCfM3IY9V46JSYd9CmLN3q1BXEupR9FMzG8wHHcWhwiAmMBd7+Z4HUgkszU4lxO46FzaoH
 gsZrkulg
 7tGdvr+XncRibJGaNjGy4qq4QEPSlbZz73ZiF93RORR1HFoArUKI8JitW8E1iazpcATcgK0q06vSuiurtH8TCLyuEIV3BGm6dQVYkwZXmhoaNYAkHd6w03ZyjPbcY1OfzIQ/6CdpGpTYolywd67zPwYlbFcr6hy1SLo0JK1EAfWKlIJEGLcSfipKROT1rpKaJY1bnKK/tWYtHaGiJ31pAmPsU2Ef3bdZqjWMrbZdqnyvpjCz4KaQZMp1/BQO1NT6v+9779jbODeSQErboWF/+WPUcvpgMmlerzol/tLb+gaNP6E3f01s9mGfPvWVlASJfzmytzd7stG7qJry7mHmOE2jdg3/1LszgBsHbZKPRn8/sL6zvXqY+29tVvxgiD3LEjb29cUOfStCl62ec0u6TURU59KHIqhjQeO0+HxckxhpELhjXw+KM7ag9lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

GUP rejects VM_IO and VM_PFNMAP mappings early. __access_remote_vm() then
falls back to vm_ops->access without checking VMA permissions and without
limiting the request to the VMA size.

Consequently, /proc/<pid>/mem can bypass protections even without
FOLL_FORCE, or cross into another mapping without checking its
permissions.

Check VMA permissions before calling ->access and limit each request to
the current VMA. Implement similar access permission checks as GUP,
however:
 (1) Reject writes to CoW mappings because the callbacks access backing
     memory directly and cannot handle CoW.
 (2) Allow forced writes to non-CoW mappings with VM_MAYWRITE.

This intentionally breaks forced writes through legacy amdgpu PROT_NONE,
MAP_PRIVATE debugger mappings. The workaround in commit fa5239f2af98
("drm/amdgpu: workaround failed COW checks for Thunk VMAs") cleared
VM_MAYWRITE to avoid CoW, but debugger writes still succeeded by
exploiting the missing access-permission checks fixed here. Reads remain
supported. Userspace must use MAP_SHARED instead; ROCm 5.5.0, released
in May 2023, already does so.

Link: https://github.com/ROCm/ROCT-Thunk-Interface/commit/fea44fab6e84eda52fcf6b419b35600c18f4c022
Fixes: 272ddc8b3735 ("proc: don't use FOLL_FORCE for reading cmdline and environment")
Cc: stable@vger.kernel.org
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Simona Vetter <simona@ffwll.ch>
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d4370c1b331c9..9872f289c1e49 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7362,6 +7362,7 @@ EXPORT_SYMBOL_GPL(generic_access_phys);
 static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 			      void *buf, int len, unsigned int gup_flags)
 {
+	const bool force = gup_flags & FOLL_FORCE;
 	void *old_buf = buf;
 	int write = gup_flags & FOLL_WRITE;
 
@@ -7401,15 +7402,35 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 			if (gup_flags & FOLL_ANON)
 				break;
 
+			if (write) {
+				if (!vma_test(vma, VMA_MAYWRITE_BIT))
+					break;
+				if (!vma_test(vma, VMA_WRITE_BIT) && !force)
+					break;
+				/*
+				 * In contrast to GUP, we historically allowed
+				 * FOLL_FORCE write access to non-CoW mappings.
+				 * However, we must always reject CoW mappings
+				 * as we cannot CoW here.
+				 */
+				if (vma_is_cow_mapping(vma))
+					break;
+			} else if (!vma_test(vma, VMA_READ_BIT)) {
+				if (!force || !vma_test(vma, VMA_MAYREAD_BIT))
+					break;
+			}
+
 			/*
 			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
 			 * we can access using slightly different code.
 			 */
 			bytes = 0;
 #ifdef CONFIG_HAVE_IOREMAP_PROT
-			if (vma->vm_ops && vma->vm_ops->access)
+			if (vma->vm_ops && vma->vm_ops->access) {
+				bytes = min_t(unsigned long, len, vma->vm_end - addr);
 				bytes = vma->vm_ops->access(vma, addr, buf,
-							    len, write);
+							    bytes, write);
+			}
 #endif
 			if (bytes <= 0)
 				break;

-- 
2.43.0


