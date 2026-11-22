Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 543AF606A333
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fnQSCvxH
Received: by kanga.kvack.org (Postfix)
	id 801926B05B1; Sun, 22 Nov 2026 12:55:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8B46B05B2; Sun, 22 Nov 2026 12:55:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716266B05B3; Sun, 22 Nov 2026 12:55:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 535DA6B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:55:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAFA81204DB
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:55:42 +0000 (UTC)
X-FDA: 85463507724.11.532941D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 11EBC40002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:55:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fnQSCvxH;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795370141;
	b=BwPLH+g53qjSUBiMe5itsaZgXYvHOp59cqLP5qcpAiSVGagoopan41scMpePq3tTRRor3T
	cJ8hoCCEr+qqp+qXzcEas/37Gg34vpYa+zQAjfGvVEqaZVLjx1C0gpXXJiXYC6QMNabkaB
	gAe7HEi2BX3GsjEmhiUR6BbziAskgE4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795370141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UAlvlm6XIkjF3CVGuekihGQ4derGbHtU5YfuFOl41qQ=;
	b=SoQJbhCy8bfcwL3PCbtxeUVpBdKAalFSt9X+katTqEXa5A2Ipq2svu32my9Gh0EsiT0eNP
	nZYs/iw3HO8/sAvgr2K1H60YUuIzrnpbbVprM80IOBYeovPaUGpGOBD8o15HRYl/MZFpXe
	zUv0UlZLuFy+j/+vSwspyoPQudV8T5M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fnQSCvxH;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CF80408F8;
	Sun, 22 Nov 2026 17:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0B71F000CA;
	Sun, 22 Nov 2026 17:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795370139;
	bh=UAlvlm6XIkjF3CVGuekihGQ4derGbHtU5YfuFOl41qQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fnQSCvxHNo6ERlskR5pyD0RirUHJHoMwYscn8zEwfhOm9qyM/LS5q0it778nXObyH
	 SFAoOYjlOjFY5vXKOdLIVVvhXhoGFLbxI9dKLWclz9Y+vELX6BSItyyKQCjZEhh73b
	 10FztGFeJtlA7TjtRykt5PquRo8ffQfsvW8vgg5YPWh1gTjYgtRk/9zBWoMaOYQyYK
	 +EWwSmhu5H9+l5Ov8IJ+BxLNt/hV2vqgTdn9JMlKNSM85QVslyyH4cAPWwT/+J4LZO
	 8VjJz3ZemsMNeHxwk3c/4OJET3WCmIek09eFjsE5DOZpRMzhb6ZRllFEB3+qtHYI5V
	 pz0ICmqsjK+7A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 22 Nov 2026 18:55:18 +0100
Subject: [PATCH v2 1/4] mm: do not call vm_ops->access with FOLL_ANON
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261122-access_shite-v2-1-808d8d2aa700@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1410; i=david@kernel.org;
 h=from:subject:message-id; bh=lBTEaJm0bEVMUkiJfmMuzjRSMI6nwi0rCciXc1cDdUU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKZdToqLJWbiudm15yqnu0Qrr+968s6pakJN3untk3iS
 p1okT6to5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIn4hDP8FTc+nBUYp1uw+alk
 Y2JYAP/y+/9uzzzC9WG/Zv2nxLKg4wz/65dyaF1cE7M41Uy+dOqfLXMCLrAu2vmRMTRvgXD485Z
 0TgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 11EBC40002
X-Stat-Signature: akyxxouc4puhdh8y95hzwaszzuf91fp9
X-Rspam-User:
X-HE-Tag: 1795370140-544874
X-HE-Meta: U2FsdGVkX1/lYfS4BJxyDaajQbpLeTclpoWuVUHpIbdcIzXxCgKNosvBLjBpuTA6DQs/rOKAJq31N6mAI735JRjjoSejSdfx6z+VTzZooSMeHB0tpA2gYdpd52W89DO+rMhZCRyRgy06/QUuwVVohdOM4fBXrX6yaerhgLycdSTSiF+e46o6iYgXIRpEjfsX+DY92mVnJj9duuslnMlQkB514X2lvUKQ/pemmRH2oc6CyN3/dXJB6S8AIDBMjOJT6Wlgzay4ez3zXxeDnSQy1atnhgmOxLEl+pPb8z0AeCL56paSMdFu97GvMNzzFZxq3IGMLmwS6hUqr7/z4cy2szyYJ7PA7b+Vwii/FRBCDrDi20po9iZJ+f7CAgWjCoJ2FRqPUQi3p8o/Kn7y3kEKAzj0Hp/dmF3x/8XkL3EKPHs3sHqbBKzqySgzK76dKgogHEBOvh6mGrQz8FTQHTAYV7ILm7yI1EYbR1F5VcyliM/iWPa6kNaFsg6c1BipV2oZ84fy6rajcZmoirNzhfCL2EmCxtbdmk1Y8+pQt6Md9Tn0IYSwCzk5arMEc/gOuBeEJZ0q407DI+a0pJ1K/VmOHipjnmXg4TRV+drfwYLYjTn3m1vA8A7+L6k8GYbjDI8KmqMwJ5c9V05iGZBaP61o8ae9TqeKCEZ94NWl8etvtUeIre4fq55WLEeUUG3otimfAfb66Jkm+StgMXYe5eBlxkPJGdDKQNEwXBzBhlSpVTWi85U7pYfvp8TM66qzDBDxN05cMRLT0QCT2pp+YtxtRXV9s/ONxm7XoNdNO5wum5OmpFlnx2agDolm2AX/vpWqOmM42SpQgI2kCsBg6xkP/Z4oHJTFJHiit9b0cNYOahN5+L5CsBAOQs2Fdo0mi+SlmjkfYjUr/S5XQM8YK9NnTO4rjd9zhMzC/5KjTLE7LpYdOBfrsX6Q2bXJCd3UAHTy9tFOOHvY3ZuTTFD+iVA
 REnNw5wl
 FY+ZmXM8VeVQEe27+nYi0ehOx4aJoA5c2ohg9NJYkwOBe2shG1nRDU+DYIxJGOXZF0iIZiOV0lvfq9+dM/JihSO7pSk6dTU42jTBT2QBZqLMbIp6U0hPaNJUBzJCBdQp0sULv3H3y+jGnXQls5Wjg7R68w1XY5YgBBSryWGw+t9jmEdWnRi8ckHJOQhqKBu4YXAecBN1JrGts4QwBvArI7sQYLyUPyljv4XXfkl64FZRVeHK38KWy98KN9thVAtD2mD/XdYGk0GNi2g9QC33eP1kvcqV/U+DKFFiuSpN+DKvH9MvJ2Ig8rvq+S801quvIu9tzLgP2a6fawLQVpHjH92Ae1te4MoNkcg722kxK/qeuevqlIlZT59NPj+EZnzXba7tx3IM0bcOPXmBfCpMSnjm7nTZh4y15/mtlh7kQQVsKAUlpjJuroDwOZPtLvr6RB/YLJhBDU6VaYp3dEDpLdbmCyUcpL3qtV5mPdr7JX6oxjYR8o55g7xusmitD7sWfPYmrqpak6LCb3+tqy6GoXYcfLxkEUL8DrXOUksDQY+uMGB498IjMiMa5Y8TEFkTPnv67G7PBVomW/S4EJ7KlNb403/Nibfr1odTqY1CSqxA0o8MAmTpwzPnRIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

Reading /proc/<pid>/cmdline or /proc/<pid>/environ can block in a device
driver, or read device memory, if the virtual addresses point at a device
mapping.

Ever since commit 7f7ccc2ccc2e ("proc: do not access cmdline nor environ
from file-backed areas") we use FOLL_ANON to only read from anonymous
memory. While GUP properly handles FOLL_ANON, __access_remote_vm()
will fall back on GUP errors to vma->vm_ops->access() without similarly
considering the flag.

Fix it by not calling vm_ops->access if FOLL_ANON was specified, to
truly limit it to anonymous memory only.

Fixes: 7f7ccc2ccc2e ("proc: do not access cmdline nor environ from file-backed areas")
Signed-off-by: Chris Mason <mason@kernel.org>
Cc: stable@vger.kernel.org
[ david: simplify description; slightly rework implementation ]
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 6a23198c1c67f..5d0d58aeff3cb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7448,6 +7448,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 				continue;
 			}
 
+			if (gup_flags & FOLL_ANON)
+				break;
+
 			/*
 			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
 			 * we can access using slightly different code.

-- 
2.56.1


