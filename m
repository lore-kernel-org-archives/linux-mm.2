Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1092B606A8A2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PLhRjYTp
Received: by kanga.kvack.org (Postfix)
	id 2C3D06B05F3; Thu, 12 Nov 2026 17:09:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29BC16B05F5; Thu, 12 Nov 2026 17:09:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189586B05F6; Thu, 12 Nov 2026 17:09:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECE4A6B05F3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:09:29 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C30C41D59
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:09:29 +0000 (UTC)
X-FDA: 85427859258.27.494C298
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id ADE5212000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:09:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLhRjYTp;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794521367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=930N6QEOjUHirsduFLhsvXWNKJmMCsCwncwdA/i9tec=;
	b=waby7vC5+GPmEBagWBkYb/8J+aMfn21f2/ALDPMDh5q89tTQep3rvmdcxQ/XSkvfZCkIBY
	RgCMlze44pH43X5JHZILaQDQvjijBKfhNtHQo2X1PUcquMJw1jz20rcErkZQ9outdKyT3p
	G8LKFK/mwrvjBqCIqY95ZLbPx/ZOlKI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794521367;
	b=5R2WC9spgTfpr2XEo+1/EEDFiCznyFz3cTP6odYwELsUIFWsp1Lz+bXUXxEom8rIV2VhUB
	OgROzKWPvqduss1M1GTc0E4GRlGWLqx/Elm+UAIPZu6jZcM4Hb7qE9Q2iHSAYC8D53tsmm
	NE1nFQPQ2RXZU6abn0gMkLJ5gyCxw+o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLhRjYTp;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEA8043AAA;
	Thu, 12 Nov 2026 22:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BE11F000C4;
	Thu, 12 Nov 2026 22:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521366;
	bh=930N6QEOjUHirsduFLhsvXWNKJmMCsCwncwdA/i9tec=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PLhRjYTpuVCEwDtQeQbEtcsKdTDD4Sr++WJShgqRPkO8U08CqZ+HAAAC1BKtceEex
	 +ShABf3NSFxi4EA6/i9nO14MOuL3QYZK4jNWj4pB4ivxpkNeAIEdvLVkUSiVC22SRS
	 HAPkNG60I9FMyz6ojt1gqm35PE5pYqb8siXMDA0df7NnSUIA4ZusDSdoAwhqNcyatw
	 KOakc8sMlWUc40XT7CnNd4OzM8pVL7XSfTE6f+BgfiH7WZ9S195dJ35iHDfRiD5oiM
	 MztehWcbZk5EMfmofYeuH1mGMoGM1KD+V45D9dNOEXxNIqLZyVKGmwpaahIp+Lf2x8
	 7/EMJQgtaFlNA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Nov 2026 23:08:58 +0100
Subject: [PATCH 2/5] drm/i915: consider vm_pgoff in vm_access()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-access_shite-v1-2-988a5c470db2@kernel.org>
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
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1430; i=david@kernel.org;
 h=from:subject:message-id; bh=732UbEwrVg9H6cBI5IEtEOpt8rsKtwsfjrtc/ksVv/s=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+WfwzFui7teDAdzGvmXXhs2YtOLerfuOEw82X/n+3K
 FgXz3xZv6OUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJTDRl+MO/pni27aQmQ5eM
 pjlcVpMMTh34tWiC9fsE8y17/pglmGQxMtzhnMYyW1mtOJO778z5SumEjPXhzB949iW6cz/dLxn
 zggMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: o4m14xfjsnswixgcbps17dsjkmqmusen
X-Rspamd-Queue-Id: ADE5212000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794521367-913396
X-HE-Meta: U2FsdGVkX18RO7MqbuKPjUenS/J0Vk9PejPnloislOwhD7qMDAAmovJsprhsQf4sQ6/V0Yh8wctzrZ4z74Z/2OKAiDxffIwSa8SPeJSh6KsscoYJv3Vr7W5pjjSkKdCkzzxitzBA6DkWRla6fKFkhHVL2bl5s9iTveH1zLS1F1SbJ1SNaXRQR7ZV+Icp+jvSmRgSHvz6l0fKh0I0s5jrVCxrdVZjXZf5k5upt+3NvrRMG8wpJehzQpa/SPqgFjulqauGm/rnE64hN1KAR0scTw4Ppxts1ROF1HiNAa6leEmdKzzDHwDZQCOuMjMn9r/SRrRJIpuX9Bxv42NgLrEM0yryEdvDRpJYQujdjXE7iV9rEMpQv5I27RNYCM8jTCyNtILdgg9OwjzoNylUHDJSlP1eJRlHVsDvbGm+MvHYQ0wiGSkPeTcMpsLkv7Zjpe9E3WMzspNrjG4TK6osqa8ofAStFEz029Aife7CP5q5Mo/G+u3Jlbwt8djlrGYswJo3OEeRLAK9pa4zX7rWY4ZOQl+JdvrGIlU9CCc9hP8Ttdh4nk2cQc5bu9/9wyTOPgVPelzbXEBnQWjtayRWAO+yZhE5ItkJAU3QsHA7JOuARwf4DtLKfTjn4Bwh1aUzyn2neOVCx0VV7YtECy0mSyRetLmSVTP9uYaLZRHJ7Oa/4OEeRZvRe5suEfTXXk/HE53wO59FdBJTjyu6hvWm6Ey6MNg2EEnv38GAoCpb4wVwvSzQgFt1plODDLEiXT0euQQaFq0tMYgRMAJ02A1pLT2+DvHG2iDJOp2J3z6j5o1YMXsA54H7CUMCwAlmnG3ysnGptniaQtq8Yk7YpCuetwxf6ThCrUoOgJ8ni7YMl2l7bJ/IYwB9SdH61xHeJAq005SzHO8aj0znDWO3ot23lTYKyreqV2ib0cyJXwRcpDjrHFhg0DLFudeBT6W1ow2xn71rOxGUB8gU1MvD9gLUThX
 9rcmn4c7
 s/MCdLVbSXxHuxk97FDDsOfQQ8nc8UjwaPXqCZNz725CnHcCu7GHoKsTIFM0X2exrijs5i+6Cyl/qJIvCNyz0PZIsXYy9jzDrYW8/nqzMSCEsjFMzCn6ZrKODKToZGlcONkd2CeD4bSYoA2ecQu0Vccd4qjM8hPZmYUHCgcozVbkRJrkylFsCEGXR3y10AP6vZrlsoIi0sgGnTOypQ6QypyhHc+wokhsXhChMSBl3BmANcn1BqNYWz1LqKFAbaZIzTFT1r8VmiiT/sXI4JEQofNdzZq0DIUnV+SIHf5RYsESKKcVVzfxJh3gTJ7ofHKvYRRR+32g97n4ZQf+iOGamn/0VN1vm8T+TWVhQfwXmREatwYXOvR3bKDEB1g==
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
2.43.0


