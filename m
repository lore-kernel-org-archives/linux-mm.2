Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A82A606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bSWZtAuX
Received: by kanga.kvack.org (Postfix)
	id 93ACA6B05B7; Sun, 22 Nov 2026 12:56:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912A86B05B8; Sun, 22 Nov 2026 12:56:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828B96B05B9; Sun, 22 Nov 2026 12:56:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4EB6B05B7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:56:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D86DEC0743
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:56:09 +0000 (UTC)
X-FDA: 85463508858.02.C60E4D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 303CA1C0006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:56:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bSWZtAuX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795370168;
	b=qKxbXaSmoPLY+EQgGEuwcmOwXePYbnc9+1VYLz1I+vs3VHjOSSnQ4mhI3rE0a7uXB7eO1/
	nC7+uVJMFg1vch9748jkwVF4ukcQbsauke3Pp8tXGZFYCE5ePGJNo6JyK++MztD5BrEXAl
	6BA8FPFDWcVg9OD1kUnLvd9/VQYCwvM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795370168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSEMw9cBbCQhxqDi6XpTccEZBErSQpfZFqy7s79g/s8=;
	b=xMQYvIsPwM2r/Coft6TEAnI0VK/3xnLaMl1BoWl/kEA0P+XW4mNIbdMtl5P2RqZXYCgP5Q
	bKtfcu7fOU3pQ2wxVwWiaGoNauwf4sfC7asYx6qQKbJxArfslEvBfXSIuH3TXnUVTf5+J8
	+0uWOh2zrkzkelOIzl+7ScxDTxV6EEg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bSWZtAuX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BCAA361950;
	Sun, 22 Nov 2026 17:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5815B1F000D0;
	Sun, 22 Nov 2026 17:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795370167;
	bh=PSEMw9cBbCQhxqDi6XpTccEZBErSQpfZFqy7s79g/s8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bSWZtAuXbodhiYKS2QPIX1GrJfI7jYB/qr+DWwbUs1E1rZZPYKKx2bLikqtCy0nSO
	 Gn//FmQaw0wS4tTguOSLzNq2bX0WX+mxY9jkuur8avzPxs1OTR/0mQtr20nPaXCf6E
	 bZ0jtjhy3yrIUdUaWOkND45Q4sbkHD+vEbFewxalXT6mTJOLMpZPixe+57d6y5174b
	 uJN6ICTkoIeGKFnDzvEfBhL6UUc8vmjPNibMcf+KbVpuaTWJ4nuKERVjF+CWLlgagn
	 K4Z3R0NUFpYdClxtlWMnv6M8prxTtqpBn3w9aYlnD7m5PsLu4EG3CrbyiUMM+uQlnE
	 KWDfYzaY/Vbeg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 22 Nov 2026 18:55:21 +0100
Subject: [PATCH v2 4/4] mm: check permissions and bounds for vm_ops->access
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261122-access_shite-v2-4-808d8d2aa700@kernel.org>
References: <20261122-access_shite-v2-0-808d8d2aa700@kernel.org>
In-Reply-To: <20261122-access_shite-v2-0-808d8d2aa700@kernel.org>
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
 Chris Mason <mason@kernel.org>, Felix Kuehling <felix.kuehling@amd.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4049; i=david@kernel.org;
 h=from:subject:message-id; bh=SDPlENgFxyN5yl7ubJ5nBWCfOxtZ7of4RTnCk2l/ZQI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKZdTo55VPOfmTm5z/5fLKWxZ/CxsQFjBHPGmYJ+gRaM
 bGenrKyo5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIn0CzD84esXTI6vC3iXlrmJ
 u86ZlZVnVvTS5U2hwk4Bd1gkEv/cYWS4cMHoRm7Ed29mXi89zU1qL97WG2+ayKIx7fQUXoej3Im
 cAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 303CA1C0006
X-Stat-Signature: 1kqhaxcg8efasu44wjea88gs93mwqhia
X-HE-Tag: 1795370168-46822
X-HE-Meta: U2FsdGVkX19PTbnCpEzYdnkegVHcZv8q6ryc0Oz0nGiLAoNmBuTS54r4wXjOuZZR6cYb2pjpWiP8Ly4TM9XM3GnxnVfzTWi+tvXmn5LY3i2drfbxE3NIBOZoTvSc8McHqiQVne3h7DJM+ubX0nB6lwz4eF2fPKo25s+3DZNAvHe2yBo8YWnDnHYV2Uqcb2Pikjbr61bS8kN8kjcWO3JFdjfedXvDIn41DL9cnE4shtP+4a/+q+1rdfxxa5Hec8Mc7nFDuK2MYWsTs4K4PaaFPjO1R+0X3z8ADhsn8b7676Befp34JOdH7MyjretDKiPZO5gYu3Zy/ywiCqX25UMvYtZPtn50+OMiTZ9PJ8/6qPsGC+0aSI2aBXdPkI0AqqS15dfY4WjdfJgz0tXCZGFhYUcz2X+n8JAY4gz0dVtawEhq6/rmfFG/B/yQWN6TZ0VmJ28Y8BEo70KXu32XETy1qO1EX4/j4iAwh/eIvUWyLFU8BpeFPO57Ed9R0ffmeSM2myc/VYpTTOfSar/l9F6jNZwtd6HrQnzYd5AVBQQboBysJrmIptj6jzvw3Kn+eUd+yP5Qn0clMibQdKiQbErK+mjMNABchWIScr/4stofmTr0oEe8aJJaSI4fEWfcaC9Yixf8HLlMSbEPWWzgfESAM8wWqSf6PKyPhWC1QbLqhVRcHpLmP7d9kKlV2EmzuTHucZ1lE5Tc3floReZgtpa4yk266RJOHFRzyHJ/lWFb3T1g2WlvyDFZU4DaSTmcErfb4ckk478mZLXEFV7bvCF33czYwM9rTmpORbuc2ARywGJaQD0SgxEQdKf1W+7o9x6p6ruPhBJsl1G4286KsGJ1hedRTeVeQgDpubCXPaotoAnj5vj0efNhyBQ0+00lfYsxA21sY1gXEiOscUEooOqbATlo9/c3lhRphZzimKPHkJYF11nLD1TVsQjCoKVH1O+R6jhDlZSfT1O2bo41X0t
 KnqQ2lyZ
 nJPtowSpFeR/uLjCmlLsFg9wMN/orFi5GLs9nibgE/URsXax5KOa2CHjKVZ7AaclNYTUfdGifssr0JLbvwEtGOTFNVIBxVig1LO5c8Rm+CiEkQQpvhNG/arUx6lMqsPw+QT4daBr/dC00HqEo8F0Php3VwMv9rEPTzCZmTIQiTostCaHgpOLvs/w81CdH4gBr8D1f0TJvI3PiuZ+q73E9fGCWSQjJy8mwQmLGDUkbdikaME07CN7AR2izxcLou0m8nOuVnHo5eE0K4gIfw0hVdqcZv76O0t08WMIxR6AbRww5PiZP/H187Wh0TYjThDeGCzYFXvE1gtxKUHE2CSAUCq1L0w3s8/DHZR4k7qiochTjDk6PQUIwqpkJ+stVjgktilxwPmhcYyT1XqDonEV59K4MB4s0NJ1lMlWXh43V6ItyIhUnrBSpu7dnNrkxDqDM3fzjYBF1WatUq5jBS97AGj5Vh7RRArXV37EJjdMIMMbC2g5On8qtr6Lo0nkvyZQXoLBHLDMdEFS2fkuBTWIRoWwEq6CFp1GWNZ21zRUGpDiVmEtigTPk0nzHl4OsomqPCJeeOjcDgg/H65u/cA8ZfTabXDk2z1UfiF+kdSv6MPmSIh8ord7crNnJHgc8kISVRyyLH2cyRP+AOrgYuaFerINOWNNHMQnYDZqt
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
the current VMA. Implement access permission checks similar to GUP,
however:

 (1) Reject writes to CoW mappings because the callbacks access backing
     memory directly and cannot handle CoW.
 (2) Allow forced writes to non-CoW mappings with VM_MAYWRITE.
 (3) Allow reads of write-only mappings, as we historically did. Most
     architectures cannot express write-only mappings in page tables
     anyway, and i915 selftests rely on it.

This intentionally breaks forced writes through legacy amdgpu PROT_NONE,
MAP_PRIVATE debugger mappings. The workaround in commit fa5239f2af98
("drm/amdgpu: workaround failed COW checks for Thunk VMAs") cleared
VM_MAYWRITE to avoid CoW, but debugger writes still succeeded by
exploiting the missing access-permission checks fixed here. Reads remain
supported. Userspace must use MAP_SHARED instead; ROCm 5.5.0, released
in May 2023, already does so.

Similarly, forced writes to MAP_SHARED mappings of files opened read-only
(e.g., read-only DMA-bufs) no longer succeed, as VM_MAYWRITE is not set.
Writing to read-only files through ptrace was never intended to work,
and would usually be a security bug.

If this turns out to break real users that cannot easily satisfy their
debugging needs differently, we can figure out how to handle that.

Link: https://github.com/ROCm/ROCT-Thunk-Interface/commit/fea44fab6e84eda52fcf6b419b35600c18f4c022
Fixes: 272ddc8b3735 ("proc: don't use FOLL_FORCE for reading cmdline and environment")
Cc: stable@vger.kernel.org
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Simona Vetter <simona@ffwll.ch>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 5d0d58aeff3cb..d43837623a063 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7412,6 +7412,7 @@ EXPORT_SYMBOL_GPL(generic_access_phys);
 static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 			      void *buf, int len, unsigned int gup_flags)
 {
+	const bool force = gup_flags & FOLL_FORCE;
 	void *old_buf = buf;
 	int write = gup_flags & FOLL_WRITE;
 
@@ -7451,15 +7452,36 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 			if (gup_flags & FOLL_ANON)
 				break;
 
+			/*
+			 * In contrast to GUP, we historically allowed
+			 * FOLL_FORCE write access to non-CoW mappings and
+			 * read access to write-only mappings. However, we
+			 * must always reject writes to CoW mappings as we
+			 * cannot CoW here.
+			 */
+			if (write) {
+				if (!vma_test(vma, VMA_MAYWRITE_BIT))
+					break;
+				if (!vma_test(vma, VMA_WRITE_BIT) && !force)
+					break;
+				if (vma_is_cow_mapping(vma))
+					break;
+			} else if (!vma_test_any(vma, VMA_READ_BIT, VMA_WRITE_BIT)) {
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
2.56.1


