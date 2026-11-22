Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13217606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E70M07Wi
Received: by kanga.kvack.org (Postfix)
	id 394F76B05B3; Sun, 22 Nov 2026 12:55:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D106B05B4; Sun, 22 Nov 2026 12:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2828C6B05B5; Sun, 22 Nov 2026 12:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CCE56B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:55:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8815F1204DB
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:55:51 +0000 (UTC)
X-FDA: 85463508102.24.E6E25C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BCFF8180006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:55:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E70M07Wi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795370149;
	b=iCpovhCLRuV0CTT4dE6ZEu7EYNp4HyZDnTxELO3SJYQNB3wUVR9AG2hRi8Pj2rpdsjTFkT
	zZJ0ssQmO24a2y6BDzJ6ICwlC5bmNQVCZFveUW4LGV8Il8EG3/sT2Rz7pe6X4ak1nT7ksx
	O9p/5AmBUie9sML51QO6+X52s5yR3jI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795370149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3xhcXsSlvYSSdBGEbF5oEiGoX8YAfT6Qkf5pEHEi5Y=;
	b=tpAE3Wf0+L6riXYR/3DonjOO33Euk7oi62OtKri7k+bbhDCS/ebQXXGfjqtpYCqEcqvAbL
	mKU50xW4ClrCknZYW3GiRQAn1YZLFjb39/ZKyl3WLdgkHexmzNUd1ddrVpEuQlYoktnsPg
	w7wo5E3oNPko1gWrBD6VfuzjpOUA79c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E70M07Wi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37F7361B0E;
	Sun, 22 Nov 2026 17:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADEB1F000E0;
	Sun, 22 Nov 2026 17:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795370148;
	bh=N3xhcXsSlvYSSdBGEbF5oEiGoX8YAfT6Qkf5pEHEi5Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=E70M07WizowpCEjLIq8EGjssWfPz6RUqSLvLQ+xGLzrxDS3gylM+UH5yHjZHVFNmJ
	 VJHhy6enxQtOEZktlriYonxPaLLMky4Erj7SqufwBWKhUmk5XNixHuTx5K2FIsPLID
	 h/J9G5EN+9SKgTEtUoQ7HI2tfGmpwEI6VUvFudX0LFcNOXoS60WTR4nlUad9HPZVDg
	 ON7Uu2mgM9pvW+MfW46A7KTeEHCyqxJGE6beJEhEEladV6jPwuyfUUHeVWAPjXd7Bl
	 pHJNJChJ9nv9ev1pTrlLvXsFFRJZddluCoYLt76x3KZladhKWxmCZbdS9ZtoK23QPJ
	 I/F1jerZy5NMA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 22 Nov 2026 18:55:19 +0100
Subject: [PATCH v2 2/4] drm/i915: consider vm_pgoff in vm_access()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261122-access_shite-v2-2-808d8d2aa700@kernel.org>
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
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1480; i=david@kernel.org;
 h=from:subject:message-id; bh=Z2XxG3ai9Ng99bmlt2CXgZf4H+3uo30xMSG9M6dIcuk=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKZdTritSS8jXWYJzwLms64t+6nzN4Ik9q9a55Wm533O
 825ncW+o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIkE8jAyfPw6Uf5P+zZnV6ng
 +Ah5mzqdqbU9Wru2Hjj5MtBl1fNzyxgZOqeKHfmkpGDtfEt/XexU9o2vfmUXOJ8tYDKv71jiUij
 CBwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BCFF8180006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1gnwkqnwmpmj3fk3kwrqxhszs3gdw9zh
X-Rspam-User:
X-HE-Tag: 1795370149-359524
X-HE-Meta: U2FsdGVkX18ZihhGfAUz0PYTkOlSZOY5v86VVQQoVVj2rGsMhTwt7qxtUf6pCeLNFEWpyFxtXd09mVE7A1yLmJbcpCPpjkwP41HPvks5SkdtL2vUfYGgsyFBnbBb2qQAep3varY9FgodsokWxoiXP7IrOMF3BSw8wZYkTfmtOtA790jVsceY+qMBqinxMqV1U1ezNFDgtDz+dcPSn/20u+nIAEz64J+9izNirZSGbV6eHzaCzU68a9bKb8ATt+moMdQ7Yx7Dowi37Mb/dl2I9iBixQMfxX96yBWpTMra2EdMeE2l88iZXCAf3xhIPt/frz5XiPJqAt+eu02u0T5ewjCxvq7bDM8YD2Q8L8N36Y7rZWnMggDzbAmE93rKUBegOOwwZxhVwqQ4hL1jUzgyrlMW8vcOTGAqQbMZ5616RcodwjaCqYAjmFa0KM/BW3mRlD8kDhNGEg9QMsA9Q+fF63k/y1auP6mUGUUYNb6U6mJGQ4Iyzns5Gu0dwqb/Z53IdbBfk2JV4Gzo+2ULfaPK0da+yVQx33Zv54OTnTUWSHxpuC8FChPhLL9gr0m7+bzhRogk+oNrZq7Ffc7Mj5oWmHptzoZclRmLcr6NrYv64SZU4Va2d7JDhElo80ze2Cm7Zq3+V9OXn+RzGVJpEY2MmzwAA4nYcuVS8pnUnAjz5k/YWPHCSgcabuulcytCD/3f67SNc+jblX8uvUJ3Y2wvYlVCaUebz9BuWtxDHbbnwVFRYk2iRjQL1NLnHkzQFg/K7Q9RscNuZFQs3LlvTdR6E+2FmFa7Tw2e0GUs77ZhmW+VFZJdWD1gl8RmDekpyBJpf/qhFyip/LjW//e1kAoUOj04YVW5YZcLcoGH14VD/WAehbwVgEmWiVCbbN8G5pkBuyxZuovXuJbE1O3aouvm8y02OthDnfJEw8GI7TGp0tGV34fcOkkJPzshazg3tAjVFRa5KLjITtVpeVl/v6i
 BBRS5lm1
 odbH6/PXi2lYFO1hRU0hWgDA/fri4QUL6MLEAZ8+k5a0/M2vVk4ymsYQbLt+VjvtVfsDbWH8M/Qu0xlvbYcppLgf2+NT+mq18ZEnpyoTpKeut0wUXR1HuAXPE0JrImc1MjRw8KGDqo4QvsPem2OZ1jXLHm4TszrcgjZtg4UgDmJp5O95vm44Sx94+/GLsNuAkHBN5d2deE8/XlmvL+AiUm26wj/MDa2L8C1WIrkEkJL3+vKYgWGDq9eH64phl7zD+TP5wK5gOaJZmUCf+bjwhX+jTn8GHA9dRiW8a4zI+RtPvC6SoicGqIiVySiWW9ra/aOZU575aKpCz4IHmfdTK8bRM95qGUYt96z3k/phahNfUT3xMRV4Kdx78wvvNns+vLrOAa0MxeQRnvXX0onLWVx2Wy778GotDtwkGzZHdfC/hubIgtbig/ybdb6u+aGn8riYknaEwft7LQQWEYOsPrR+DjWeo/0vQVNAp4a+Wu5W1OOiU8vuIlYJumZP2dA3TzVnJE2aJK0epLZFDvHoZYzeMlIzEOWJP/DLU778GsoE+wJoVYlp2W5jGD6gRdrnq1geFDr5/B8N82oKOdatMDHsMaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vm_access() treats the start of every VMA as the beginning of the GEM
object. After a VMA split, vm_pgoff identifies a later part of the
object. Debugger reads and writes through ptrace or /proc/<pid>/mem then
access the wrong bytes.

Properly consider vm_pgoff just like the fault handlers already do.

Fixes: 9f909e215fea ("drm/i915: Implement vm_ops->access for gdb access into mmaps")
Cc: stable@vger.kernel.org
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index 6b337684dbfe8..e3b24dc8e94f5 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -511,13 +511,15 @@ vm_access(struct vm_area_struct *area, unsigned long addr,
 	struct i915_mmap_offset *mmo = area->vm_private_data;
 	struct drm_i915_gem_object *obj = mmo->obj;
 	struct i915_gem_ww_ctx ww;
+	unsigned long obj_offset;
 	void *vaddr;
 	int err = 0;
 
 	if (i915_gem_object_is_readonly(obj) && write)
 		return -EACCES;
 
-	addr -= area->vm_start;
+	obj_offset = area->vm_pgoff - drm_vma_node_start(&mmo->vma_node);
+	addr += (obj_offset << PAGE_SHIFT) - area->vm_start;
 	if (range_overflows_t(u64, addr, len, obj->base.size))
 		return -EINVAL;
 

-- 
2.56.1


