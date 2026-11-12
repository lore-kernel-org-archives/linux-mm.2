Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D44C606A886
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UtSf8AS/
Received: by kanga.kvack.org (Postfix)
	id 0C7576B05DE; Thu, 12 Nov 2026 17:09:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A746B05EF; Thu, 12 Nov 2026 17:09:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5BE96B05F1; Thu, 12 Nov 2026 17:09:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B55E46B05DE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:09:16 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC71981A16
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:09:14 +0000 (UTC)
X-FDA: 85427858628.03.3634B31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 16B5440003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:09:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UtSf8AS/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794521353;
	b=ecnRb2wN2CB2Ur/vtviWJY/0sB06X/hpzG7bZtBP/HTfIcbcKc8TQJyDy2j+YQ57ZYiDHs
	5Hpi2rquIhcjfMx8dV2TC/kr/7oZ1rhg72Mf1YSdMUuVLRhxkPPRUSGV3QYsMSp758i8xD
	OJcWFZJxt9Q4M/CoCbARGHE8YmrI+GY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794521353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YdaqQU5UQrIE7jz+L18q1ofvhwJPYfk/YgBxfo4uzJ8=;
	b=hq0nsOqWWSQzY6h1VBqBZJurkjRy1w4LrEFmB80dV3rzsiNAKaRFU/nqJqDe6yS2Jda9tv
	jSZs4lztmU4Yxp1lncCazzdiCNGA40XMUIs2ryZGwlxxE2UIMnDCFJMkXodni/RQW75EUX
	NiVsp1gN8B3UiI7UPylc5eHyrBezJ3w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UtSf8AS/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D5F04115B;
	Thu, 12 Nov 2026 22:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94D01F000C4;
	Thu, 12 Nov 2026 22:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521351;
	bh=YdaqQU5UQrIE7jz+L18q1ofvhwJPYfk/YgBxfo4uzJ8=;
	h=From:Subject:Date:To:Cc;
	b=UtSf8AS/2vkBzFQsYMRwuG1chkyE3t6cf92PIU1mH6Zccmm+N7wlrDPMvoqYVIzeg
	 JaLGGZUy2+KPrln/QsrIgnjuKFaGDX8Ul4e5+R6J9wuhUlJxYqeuFzFJkhawftra1r
	 7SRhv9cNjIbSPkFZlJNY1RkXOEYclnV9rxg6sieR55Lx5ecY0vkYsZqBeGZ/uxLJlF
	 Qrc4sbjJPGk5oW5iS/G1qEymWrpXDPeK65SVHwwPX1ALJNiO4mLgB9nfDeBE6PPOAh
	 LYb0r3Ey8u0d2JvuAPbuxNQZd5+VkItHekuWndG07g9VEf+lahJlbpgVYIRfUGeslY
	 O2MPZl+vhSR0w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/5] mm,drm/i915,powerpc/spufs: vm_ops->access related
 fixes
Date: Thu, 12 Nov 2026 23:08:56 +0100
Message-Id: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPg49moC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQ0Mj3cTk5NTi4vjijMySVN0Ui0QTc1NTS1Nzo1QloJaCotS0zAqwcdG
 xEH5xaVJWanIJyAyl2loAywJpcnAAAAA=
X-Change-ID: 20261112-access_shite-d8a47559572e
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Felix Kuehling <Felix.Kuehling@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1463; i=david@kernel.org;
 h=from:subject:message-id; bh=WdwVU4D50DJi588gxgEao7aVctqzLO6VANAj2lIv6bs=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+Wfx957ddpWa78tHiMrVrJ99FeK1a/GtDtFr8v2eVG
 8tPF86K7ShlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiGw8x/JU5HnSJ1W7u5NdB
 n0Tf3ezdkWO74I2I2MJ5z7NfhK+8ermJ4b+bh3bR4pbPQQmrj9+Vd5eZuOcZt0PR6/sme6cfFHx
 xYxU/AA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 16B5440003
X-Rspamd-Server: rspam12
X-Stat-Signature: 96rwt5mba6q441dbu7jcpxnw7sbuknub
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794521352-654079
X-HE-Meta: U2FsdGVkX1+vNnGTiTd3lHZFskZz0J5+mOFbgncRiIizhrAt/5DBxZ+U2RQATnb+3cNJbDYVl4Nm/+0Zj7BEjrT4tjrAqafDgjUH9a/SlGsQVWQQlQr9DxyXOwnUnFMB0l+Q5IG2PGf4vvSuVCs6l5g5/6LTEmG5Xn6NziikX240Pqw3ebpsQqlPGtElKaTWkbTJ0GOk3haUbFtRyHvuQutsjvaG96T75EZd+ePBjsDLJOYhVs8eQmw7ARyA3UFrXnuz16i8g27QynlWIkZ1U7kzC16X64myMI++JQJj+Vad16eoAfR1U2EcujMgbVtNpb5auhK6nPmjpa5Hqjo3tXY1dq3jyd83hKAaiCIPCZGWiAbUmWOtl+f0webmEyYIjWczQLJgdFLQVvOQZIKUrq/I6Mst6VmV0nzXCKdK3hrdoHastLzmoSoL4LlxE5IMSE3wJcNObxDKDvd3CLsYTGhPepev7O9dJd91F+FQIo6QmwpZO3KCJ4QAWfPYfi0Q4ax4XQf6RT2xlAwy4j8/SyjZJFHwv0KoXN89hZlfO/nUomcOswETHUtdKSQVIulouJDiGLFfutqIBkdGDCxhCrMK9kiTOuQTjoQo4NdMj3CUzNgO/3p5pmRtoxaA0lMbT6UNFu/HEmdBss28Th0W4h0jTbTwShvsmm94eKCVOMQZsy1JYZ0sGk5qoD5XGdKxJBVPiC1o2oSUMfLOYTWnpHetm+NBBbDrS5bjS05lrsiHNimLc2wyWfibl4xTV4BUgN7AEESr4QhY/ajUGh2A768rhil1b2NEVMfqBBZ+7asxNAhTQa6RLpsjD/mqm861lr9ziVFbaSoK7BlfymlUX05CoGBjouqJvKQZySqfTBCFtXWFP1YNV7b5dA3PwMNEaG9ypuLc/jzPoeYByN0R+C6CExyZkY3W1UDRwudDedAvi2tFV3wge7XkafvNdGRmCNKt1Q30vNORcJYcWSY
 iBoR3vBj
 7oALB42irTq1QeJngCuswYYLjH53KRXY+gfyVNd40Ai28R1GpOfAa3tHxyv7EZFkmxMV0r+zvEjtydXIg6SpcZjwdvzxq1rcZ4hfIIZ6O197Da8wQDPH6tH3QCXxamWv1o6qAbzTV0nMNSBKDCsNlRuyu9W4RdECWZIdUbmMS+8bYmJyEep47t+AXuG4tmh2E9+SLfRRcPnUMQ0NYd0ZxbJGtb9VKbrrkYZMcmNSsejxwDYYcdmmU+rhAk7F7vtrof/DRZ55wW7QtwmfR6HnZlCdQ8bA6oJhe5doNT2yZXkPTVpLBGRHVgEfHVKQNrUWOA3hHftLpsd6wWtnky7EgdvWrO9OWWolkze2+JfirJ7lmDO/OnYbfdIxCrEBIYbvmnOwzpYRChdushibp1xBuar+spKlcGwJrLp9heFAc5UQfRO42sdAwwIVMSViHtkm/eu8DOCBkHgy7xKhr6VMNSxwnFIIKCciEYZ9CcKmG2B8nVXMNQAg1FVkB1nuKxF3QvxgqLWnDEgS5qnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

While working on vm_ops->access related fixes in core code for FOLL_ANON
and VMA access permission + size handling, I stumbled over two driver
issues. Also, I have to update one selftest that specifies PROT_WRITE
but actually wants read-access.

Fixing it all in this series, because it's all intertwined.

In patch #5 we break a debugging use case for older ROCm versions, where
the amdgpu driver hacked around it by exploiting broken access checks in
core-mm.

Tested as good as I can with selftests. I cannot really test the
i915 and powerpc/spufs stuff on real hardware.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Chris Mason (1):
      mm: do not call vm_ops->access with FOLL_ANON

David Hildenbrand (Arm) (4):
      drm/i915: consider vm_pgoff in vm_access()
      drm/i915/selftests: request read access for mmap access tests
      powerpc/spufs: consider vm_pgoff in spufs_mem_mmap_access()
      mm: check permissions and bounds for vm_ops->access

 arch/powerpc/platforms/cell/spufs/file.c           |  3 ++-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |  4 +++-
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |  3 ++-
 mm/memory.c                                        | 28 ++++++++++++++++++++--
 4 files changed, 33 insertions(+), 5 deletions(-)

---

base-commit: cc06c90c164a389d51444a7df5056a8460d26d5b

change-id: 20261112-access_shite-d8a47559572e

--

Cheers,

David


