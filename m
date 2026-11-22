Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA94606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=duxKByMB
Received: by kanga.kvack.org (Postfix)
	id 171126B00EF; Sun, 22 Nov 2026 12:55:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1493E6B05B0; Sun, 22 Nov 2026 12:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 086F86B05B1; Sun, 22 Nov 2026 12:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0F7C6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:55:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A8891A0469
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:55:33 +0000 (UTC)
X-FDA: 85463507346.12.430C187
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 71874C0007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:55:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=duxKByMB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795370131;
	b=yGn3PThLGsHbnZtBguoy9si5SWIUTmQpia393RLlXrcdfsyJHvxoc7U4t2yxMsmMvQQ+wZ
	ZYXA4J9DC3ptUXp8ErpvbbpW4czlMwXepSKP/4v/zQkVlOELWIdaTYEZ61LITFAQbx8G+Z
	Wm6k23bJNG2ljnCA2KAqK6golWoVdYc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795370131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h/5Vl306LS0GA0rcZKJVnl2ctvPVB3+FArNa0w73Yro=;
	b=CJD1rXzVxu1MyIWZYWVH402tFUh9Z0ZeTt5FtrlRaPkmoEB405SwaHI0wDFca260ebsa5X
	2nU57nSfaXMuMt5JPz4pUFurzjGf790LK4o62ccf4jOBgZp9++iIgTwqZ/gPZXAYwA7H1N
	mAPZOa03FQ28f7kdS5UI1InlptpX/zk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=duxKByMB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A26D4408B7;
	Sun, 22 Nov 2026 17:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB00D1F000C0;
	Sun, 22 Nov 2026 17:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795370130;
	bh=h/5Vl306LS0GA0rcZKJVnl2ctvPVB3+FArNa0w73Yro=;
	h=From:Subject:Date:To:Cc;
	b=duxKByMBP2+mJiLV3lYRrKPgtiowdBAgsPJIOTGZnzS3p58QFIkq1X5nGMYdJsfNM
	 evxhcz1FhYwz1khpDyo/kjMElsksWA2DAYZQuW8yjfOdJAxaqT0kTk/dgJJ3L1YxVs
	 b6bYv0n/0CSza4S099LFxlPG+mjLC99FtaqxP3vqrBOe/KvmCEPggXwrzwtj46PdmL
	 zH6u2jCXro9fXxatJHgHkzEGA/pN1yUrjpGfmhjk4zzw2xpr1FXG85n8DZwRqVtmMo
	 V+B3/ylL49xlmJ3nEPH164nYwknJC3q/uMxMWHQy9Ay2j4bmQ9J6Pw8r1EqMWgOcjr
	 75F1hXUdF5+Pg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v2 0/4] mm,drm/i915,powerpc/spufs: vm_ops->access related
 fixes
Date: Sun, 22 Nov 2026 18:55:17 +0100
Message-Id: <20261122-access_shite-v2-0-808d8d2aa700@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/3XNQQ6CMBCF4as0s6aGNtSWrryHIaaUEUZNMR0kG
 sLdDbh2+ZI/31uAMRMyeLFAxpmYxgRe6EJAHELqUVIHXoAu9VEppWWIEZkvPNCEsnOhssbUxmq
 EQsAz45XeO3dufptf7Q3jtBlbMRBPY/7sf7Pauj/0rGQpa+eCiZUtu1af7pgTPg5j7qFZ1/ULK
 L5wnLsAAAA=
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
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Felix Kuehling <felix.kuehling@amd.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1784; i=david@kernel.org;
 h=from:subject:message-id; bh=uurjwnOfWQkMhoYI4DMjJoIthu1xPIvQvDdbePa+8Rc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKZdTqylvaopj9aMl99cWW602yfrivn5ySohf55fPZ2/
 JqtOX7rO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZhIaSvDXynr1g/nX69XZbd6
 ZcFsH2J4UpZD8tdum/4+6S3KwvFF1xkZbodO7b9SyfMl4R/TSwnD7cnx3999jJ+ippmflWjJ++8
 BIwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: rzxwn4g4c9kj7e38p9az8g6j8m4jf7si
X-Rspamd-Queue-Id: 71874C0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795370131-564296
X-HE-Meta: U2FsdGVkX19jNTuF/B/bVzxvtRnK5EtAQp1tafksluDhGSnwQ7PZTHQ240CJGPlEDG6o7jgNum+gy7YxxgxqYtsMFO1y15lz9RgDr8Z7STVTRlKYdlSg8LUvfoAhkPArCSkGMu0hACct7MjlJZcxJxlowLhl5VV8HO5VId95f2W27H+6tzA7troCHwb36SSkXQxCvdxZgsfKs8zopI0wg0dzpJ2BUbbJa6Ku9Xl+wEW12mX/8re4PI4VAJWxI8+htl/gV1uCRJqXjoWa5ZjHhU/fs8YTP8eJnUXVWVOXha26JMi+WZlj5Np/fe9x5phUBsuo8m3n6HmQeUjuSU2lir4DcXKfuahs8gRn3+pq0hdxtGZ9L6O3v7AFna/VLxQHFEiPlxTsu2JD845W6Wt6UkgFQ+eQdebYMZNkmz3HjqQ6J+R/iEIyReIOcyikCzM3PA5sN/MbV8APASGi8WwEMo6Q8kogH2NEgW2ESAk3q2RKKolFZ0nTMQ/7t5qJhCMOsugvNdxh4dgZIMxhSZFJy+8TncXjsGSK17U9ECc2VT+f1lQCoVdx6ysEqSEYur1PzRJzrRcKpP1fVZ3BgafpnkmchMrGYkJ2J2I9p/gdaXtTr0+HBG616cr8vhfsUG/Dy2VDEf66erwMFzL1I4wLFAM0MyiHGIpinpideGL1/wbHUQTmMqgbAkgsXMTBv9Ds7OY4IEpCWb4ic95nudC1RA7fDT3Kt4OCcGhKxbAw8K5CysWzyHASfGF3On5WcAREvQ0Bewt2GLY8t3QrX6G+8Im3NPRqaT8tYFMRpZTEbV35ixyFEya3XDymzKVDtOwW/4lxcMfcl4PKM8cNXX1JhewBtHL73GAzNT8+ExPtVhvqC0OWIQ4PLupOaNn/C7jimABerSq8uN9cMn6WcvAl79CUmD6i+ubOnoWVtpBwzv74xoPCNRRsKo+JilUbwQXdGDnjuFvat1unNmPAjy4
 V7q+X59v
 L30jMTjSANW3Qahf6WpDbv8r2DgcM8AxpELt6ApUwaaPq/RMJlTmxcqr49rQzT0xe6InRjVxWYI7/Nc7jdUxEMJzhF+vVyu7wfneGYVw6EA7tCoFCrrPdPMbJE+eqAhHVn6yt9aGQmTwDvNQnUADT5uw1Jn6f2pGt9fy4YWsn9mxwwP57aGCUUh945wBwdytoUYPVBz8YRgJaXHx2bR7B7bOjNUF5Cs48yBHm6LhoPBS5j4J2N3hMfbto+Gq5tCnu5Lcx2oZIE8KwOUhsV36GDH7eZy5s1evumUh8xiA/RE3bHzL/AH0KnJIReE+i0EWUUUsvGQ3bmwmTATbd+v0uVh9iD+0AZHJ14hSCD2NFfJV4xT5zyejr39bwxkBTljXmzkw/j3u5yqYgDSeFFbYJnRbAIIX1eZGVzz2ZOkd5EWffsiVq827ge+tQAtx2G8WRkvePFkPKuoW5hcCng+ho8wjq0FQSNCzOldvQol0d4wLlbKOKeuBXaBeEmwstY3xzveqEaxUN1yan0JWVfYNERliCUqiMXt4UlWsZiil1GEaP8ULS5NUUreZFyIpVml+mq+vfj2uq5ZVsBsLj9bERxZVbneIcuOo2bhrpGnW15HcUdmro3i6pAA3Vte3pYvykgkLerztbGtiBBDizYzQFNPc+8qafsFOgOv0UHqjiA5ctpCM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

While working on vm_ops->access related fixes in core code for FOLL_ANON
and VMA access permission + size handling, I stumbled over two driver
issues.

Fixing it all in this series, because it's all intertwined. Only allow
FOLL_FORCE to bypass VMA permissions, similar to what GUP does for other
VMAs.

In patch #4 we break a debugging use case for older ROCm versions, and
forced writes to mappings of read-only files (e.g., DMA-bufs). Current
ROCm no longer relies on it, but old setups (e.g., MI100 with old
userspace) might break when updating the kernel.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- Drop "drm/i915/selftests: request read access for mmap access tests"
- "mm: check permissions and bounds for vm_ops->access"
 - Allow reads of write-only mappings, as we historically did
 - Combine the permission check comments into one
 - Mention breaking forced writes to read-only files
 - Extend patch description
- Pick up tags
- Link to v1: https://patch.msgid.link/20261112-access_shite-v1-0-988a5c470db2@kernel.org

---
Chris Mason (1):
      mm: do not call vm_ops->access with FOLL_ANON

David Hildenbrand (Arm) (3):
      drm/i915: consider vm_pgoff in vm_access()
      powerpc/spufs: consider vm_pgoff in spufs_mem_mmap_access()
      mm: check permissions and bounds for vm_ops->access

 arch/powerpc/platforms/cell/spufs/file.c |  3 ++-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c |  4 +++-
 mm/memory.c                              | 29 +++++++++++++++++++++++++++--
 3 files changed, 32 insertions(+), 4 deletions(-)
---
base-commit: 76d96c9641d0c1c0d0e92013a30bd887f8d2dbfe
change-id: 20261112-access_shite-d8a47559572e

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


