Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D84606A335
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mq49p9IU
Received: by kanga.kvack.org (Postfix)
	id 222306B0AC9; Wed, 25 Nov 2026 16:37:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1796B0ACB; Wed, 25 Nov 2026 16:37:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B616B0ACC; Wed, 25 Nov 2026 16:37:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C61706B0AC9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:37:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3803D1A013E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:37:53 +0000 (UTC)
X-FDA: 85474954026.10.E016778
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 899CD1C0004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:37:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mq49p9IU;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642671;
	b=uSBpPz6coUEMoi/p7DOQKms+8aac7euGfxDsLeHkwKSTR4an8UVfdAuG5/nQb1+pj7e8gI
	+d78sx0vI2tRIIIbiGWMuLTkNx4hfFVN9PhSir//+hZa95J1SfLDUOwfWE5Dk2jHpt8epS
	mWTnuO+S8I+IlOlmT5rZyrv3KftqAT0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=60kyMXIH5oxacfi0kIXucfPpSjIf0lxOoUeaDl5buic=;
	b=L0EJzTP5M5X7zwk3FZI9wk/J068ASr+5K4N6o9YYM+xfHYl/UgBmyEk5/CeR79kmvue+Yh
	tc3k0ZQ4zrDLAilGjq8y93TrQsBnSbpFqWPm9zZuv6tbaNYnZPJt1g+TSeQQ9zGUjjcWBD
	wUXzmoV09nyiieeMzOxwrLgWiCSbn1c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mq49p9IU;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E85BE60230;
	Wed, 25 Nov 2026 21:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AD41F000C6;
	Wed, 25 Nov 2026 21:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642670;
	bh=60kyMXIH5oxacfi0kIXucfPpSjIf0lxOoUeaDl5buic=;
	h=From:Subject:Date:To:Cc;
	b=Mq49p9IUviztHKgBHD0Jsq63jIlzruPhIWld2Xsc7qz+X6oTRPsKGX6N5KksA07Ny
	 CATzkgBG3Mxldfdp92CY1L+XkTNdySuhRXdbYlkZOpDvfmuZCu4DiPXDtZ5+7wx0pU
	 kwolEUhlHBDHnAEvkXaS85TJoGKYJwuUCuYzWtBHT7FJL8xQQAodvmquqJSsdZUBhy
	 YEJeL14E6/iK/Pe0R1bWfeHMJDhf2jx15+8iyp83GGVtOcZ8TbwfZe/N9akz4DZi+M
	 tYrTY9Jflg71R5j/zwYNnDGvJJXGFPhwzR8W47osHvNy1fCdHASo2o8+t6VUafAutz
	 XTNiJH6MgkJow==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Subject: [PATCH slab/for-next v2 00/14] mm/slab: mandate SLAB_MAY_ACCOUNT
 for __GFP_ACCOUNT allocations to avoid wasting memory for slab metadata
Date: Wed, 25 Nov 2026 21:37:01 +0000
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAP1UB2sC/5WOTQ6CMBCFr2Jm7Wh/kIgr72FcDDCFKramragx3
 N2CJ3D5MvO9930gcrAc4bD6QODRRutdDmq9gqYn1zHaNmdQQpVSyAJvfKNh8A3egzfYepfwSTE
 xxoFqX1+QXyk/JWopEerCVIVmU5W7PeTOe2BjX8veCWZia3xAlxk4/87xUV+4SfPmDPQ2Jh/ei
 98oF+ynouSfKqNEgaIq90IQaa3F8crB8bDxoYPzNE1fu7frgAwBAAA=
X-Change-ID: 20261014-memalloc-prof-dont-waste-slabobj-ext-metadata-34f943ef9658
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Amir Goldstein <amir73il@gmail.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Eric Dumazet <edumazet@kernel.org>, maple-tree@lists.infradead.org, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Jason Xing <kerneljasonxing@gmail.com>, 
 Willem de Bruijn <willemb@google.com>, 
 Mina Almasry <almasrymina@google.com>, 
 =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, 
 linux-arm-kernel@lists.infradead.org, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 linuxppc-dev@lists.ozlabs.org, Niklas Schnelle <schnelle@linux.ibm.com>, 
 Matthew Rosato <mjrosato@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Chen-Yu Tsai <wens@kernel.org>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
 Samuel Holland <samuel@sholland.org>, iommu@lists.linux.dev, 
 linux-s390@vger.kernel.org, linux-sunxi@lists.linux.dev, 
 linux-um@lists.infradead.org, cgroups@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 899CD1C0004
X-Rspam-User:
X-Stat-Signature: 76nzc3qek7guz57wh6ptenx5kr7q94qf
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795642671-538278
X-HE-Meta: U2FsdGVkX19OUHhjKYh2aqbIam9mwRTNNytvR/b3gPzoKGaCinMu5+JAX4+pBZPEDT5NSuo3IHD/ZQAyLkHPd9vN8gtlq9uja2DN1cmyOgOokk07NKT+94QI7OKVKcRWlEI4ibk7Opc++OJROtbP1gcDWzEYVIjg3sxJDW73aVnKZW7nkQh8tAAMYwMTmk0Sg7rukxpPFlkE46ixaVOY3Dua5ofKD4XETCG7uib2kRI1+1oKncnH9OvC+mmk5aCIc3HilpvdyE/eUGawd6e26iaE4VN013bqIBnpAisRRd/7sWc5eHeVt/wlAsIRhBV3PWRtf83zKgl73cDLiP75Q3MJ5oHBNO0MJxkndT9IilGVSUkMefVt4UjP3kKhWTXELyJxsy7r9dWZY+BjN4WThLoCTZMHqKnpqzPFCxi5u7sUKnvtE4x2nWXIDsJqX9cttdVOC+Od/RRnviPFXyr3T7NKbinZu8rhaxsbM32oZaRlaw4sLvYIO6L4/2myikqoDyaReEa0kNFEyTxsiHSlI3+VoYOa6vrYlRWPk/sJSzMQ0yBlW6lhvQCkK70JZh4GqWxEkPU6O33D5EZN0puRQp+G5jy8eatkfi41DnNveeWam8quofQd/xmkM80ojkMh+aYSNXbM7aC0+VEr+NiNsSCAkQtPa4lCAAmH178hAVqwbktEPfiNrFCSOKYqjN9jx5shSM5q601cPWj4dVlyINALkVSzKQmH1BWP+QYY8Mop6oaPENZ0W3hEDZMT/so2yMJw4G2sEj8aQQfh8uoO86kTbQwVk7MMsDzWQXa1YlwturIRjMXHqtp9jn0pFl3cKGmxKMZrSq7487fotlkaQ8udKAUvDCFo/aKXhQgiGdY425emXK0ZQ1HWqx1JBwmM/Eu1VjJQiIquAZIGEqCeFwm+Oii3saWwVONnC8mUeeYhb0heWO/Uf/5QmCoi/2lpOQtC8s2JYtqUDoXHVrh
 9lV8Wj2v
 7sceu5hEPtMKcEGn9JepG75KZDmKwNa4qvccSKA8l69Kb1RA4mTdV9GeWBcPld7qf7PXbTn+XfWztKMoC8zjTD0dA8uEfPQ3P6UZoXQnkCKMXOeMqSzi9RchNEvvh/TbPDWyn6O5i+lZV498jsFHHnjVZuS9RAc2azq0lsCAfe18pF930XzCrr6mqi3+1fj3rTPeMohQyKmYPysonUjPyzsoamgx5u8M4loxjUF5lHRzsQMvI3S3TyG24bCHyRvcTMlGPvsepyIrgyseGCGScx5ffsYCII++/MO3e0CFQ5dIwiD16eTKNl8EaA6WhDdzeVR3k9SwNbqVEWBswLGN1vYKgvNrzXiqzQU3ygbiXlOFx57xUP3VEW65barfkpLZrO1CJ7JBiw+Tw+igOBDa0Y9LEuhJfUFNKZiUuGR9mCocQBH4a4nt1nyDajHiJ6phg7lcAu58UWZrkRzVmgrAdDaGaRCjse2c2yh7hV/eGFGRCsoC0AMZjcrczatxEF9vrwRn8tnFYrTSi+oDdPb1VLbqvrkyZuwcr6cfzD3EHvA5nS4oIdZdpOzmh09DHyWJ27onTjfag6t2YHW2af8MFcEb/7kzlyJMA2ACZ2r+dzJ4zDNrfsSFh9bVF50U1FjL9li4clv8S8ZJr68+JkXI0zbHh8/m2fn79JNydTcH9Ik0VSEeLrFseR4azFP+BnkQ6RD1NeP0Sml/h2KuEHgFSvB8POAe7VXEebTUTaRne7fHftIQoi0BFAYSXzqWJfqrhtJSQNL0kewvQZIosXo/C6jSEXCvY+44nHagxo4XQkrNAmtpkT1tLbTL79esMs3xvetnnwOXHUgPEbnAxvNzFzBrGGBR527TlHBIA8LRjNJT1dWm4Jq+37Wb5Dd4Cr1XM9uT4wJ1aZzJXQVdW2q8z5EhJyWyrWnUA6ps2qkljORRrlc4mss+F+0nu7ZhV52GMoBKokukah94579R7TzdFx/5t8NhG
 R2Gi/tLc
 9jBaLUNH1/IaprerwJuCx3egwBJxr9ny1VKKc/3sbt5u9JFSMK/s1iNJM750Izj9rKYNRVti0hIrsk6DyE/4GIhVVg+rMz6abiIRIb7O5LhPsvThw+mzOJ7e6BPR5BVtOfGwT1iItItfQmyz8AR7AqOW6IjrOP+XN22JAKDa/nDo8o1kh8XHnfb39MjDbPc4Oah/6Oh9Q36giS2FDQmfA56nC3pjCzCqSNV8IcvaBA0iy208+vBMS36x/YuQdCjfIlHD1mefbW+oksh2PNuYLY9QeUEPlH1X54YvA7kw49yzDUe9gZMXYEGenK/A7rVAw1iigY9GtQpg2D+sNoq1J4NbCt6/RA6fT+NCIM33udKYKoZoa0BFns4N+QKojgNIGa5P/QqKI8Cen/XQ0sI/9kxr34VWED68EddsK97iMlg9dZM1Z+FH8aKCaV10/+lzp+qShXtcPkubxIkpFe9xnmnAC7XZft4U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

TL;DR
-----

The purpose of this series is to convert existing slab users that
specify __GFP_ACCOUNT on allocations to specify SLAB_MAY_ACCOUNT on
cache creation, to reduce memory waste for slab metadata with
CONFIG_MEMCG=y && CONFIG_MEM_ALLOC_PROFILING=y.

Longer version of the cover letter
----------------------------------

Currently, there are two ways to charge slab objects to memory
cgroups: 1) specify SLAB_ACCOUNT during cache creation, or 2) specify
__GFP_ACCOUNT on allocation. The latter method made it impossible to
assume that certain slab caches are never charged to memory cgroups.

Since commit d4404b0f5b8b ("mm/slab: stop allocating objcg pointers when
unnecessary"), slabobj_ext allocates the space for the objcg pointer
only for caches with SLAB_MAY_ACCOUNT. However, kmem_cache_create() sets
the flag on every cache, because any cache may be used with
__GFP_ACCOUNT.

As a result, sizeof(struct obj_cgroup *) bytes are wasted for each
unaccounted slab object when both memalloc profiling and memcg are
enabled. This is suboptimal when memalloc profiling is used to
profile memory allocations on production.

So, let's make memcg charging opt-in and stop wasting memory!

New rule for slab users: a cache must specify SLAB_MAY_ACCOUNT
(explicitly or implied by SLAB_ACCOUNT) for its objects to be charged
to a memcg. Otherwise __GFP_ACCOUNT is ignored and triggers a warning on
debug kernels (CONFIG_DEBUG_VM=y).

The approach is quite straightforward, but converting all caches that
may pass __GFP_ACCOUNT without SLAB_ACCOUNT at once is not.
As a best-effort approach, I swept the whole tree (with help of an
LLM) for paths that pass __GFP_ACCOUNT into slab allocations either
directly or indirectly.

While I tried to make sure the sweep is exhaustive, there can be a
missing conversion. However that is not a correctness problem:
the objects are just no longer charged to memcgs. Patch 13 adds
VM_WARN_ON_ONCE in __memcg_slab_post_alloc_hook() to catch such a
missing conversion.

Patch 1 allows passing SLAB_MAY_ACCOUNT to kmem_cache_create(),
patches 2-12 specify SLAB_MAY_ACCOUNT for the caches found by
the sweep, and patch 14 stops setting SLAB_MAY_ACCOUNT on all caches.

Memory savings and testing
--------------------------

On an idle x86 VM with both memalloc profiling and memcg enabled,
slabobj_ext memory (the alloc_slab_obj_exts entry in /proc/allocinfo)
drops from 1,280KB to 910KB (-29%) after boot. The savings are expected
to be larger on real workloads, which allocate far more unaccounted slab
objects (8 bytes per unaccounted slab object).

Each tested cache was verified with the warning in patch 13:
I confirmed that 1) the warning is triggered without the conversion,
and 2) specifying SLAB_MAY_ACCOUNT resolves it. However I could not test
io-pgtable_armv7s_l2 and sun50i's pt_pool caches due to lack of the
hardware and emulation support. So they are compile-tested only.

  cache                  tested  environment
  ---------------------  ------  -----------------------
  radix_tree_node        yes     x86
  maple_node             yes     x86
  buffer_head            yes     x86
  skbuff_head_cache      yes     x86
  fanotify_*_event       yes     x86
  smack_rule             yes     x86
  io-pgtable_armv7s_l2   no      compile-tested only
  thread_stack           yes     ppc64le (64K pages)
  pgd_cache (arm64)      yes     arm64 (64K pages)
  PGT_CACHE (powerpc)    yes     ppc64le
  PCI_DMA_*_tables       yes     s390x (zPCI + vfio)
  hostfs_inode_cache     yes     UML
  sun50i pt_pool         no      compile-tested only

Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
Changes in v2:
- Rebased onto the latest slab/for-next.
- Collected Acked-by from Jakub and Reviewed-by from Casey. Thanks!
- Patch 1
  - Resolve "sysfs: cannot create duplicate filename" warning by
    encoding SLAB_MAY_ACCOUNT in create_unique_id() (kernel test robot,
    Sashiko).
  - Define SLAB_MAY_ACCOUNT in tools/include/linux/slab.h to fix
    the build of tools/testing/{radix-tree,vma} (Mike, Sashiko).
- Swept the tree again on the new base. No new cache needs
  SLAB_MAY_ACCOUNT.
- Re-tested all the conversions on the new base.
- Link to v1: https://patch.msgid.link/20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org

Range-diff against v1:

 1:  f749199b4fde !  1:  31425f1e4a92 mm/slab: allow passing SLAB_MAY_ACCOUNT to kmem_cache_create()
    @@ Commit message
         Callers will specify SLAB_MAY_ACCOUNT for caches whose objects may be
         allocated with __GFP_ACCOUNT. Accept the flag in SLAB_CORE_FLAGS.
     
    +    SLAB_MAY_ACCOUNT prevents merging but is not part of the sysfs ID. This
    +    was fine while all mergeable caches had the flag. Now that callers may
    +    specify it, encode it in create_unique_id() to keep the ID unique.
    +
    +    Define the flag in tools/ as well to avoid breaking the userspace tests.
    +
         Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
     
      ## mm/slab.h ##
    @@ mm/slab.h: void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
      			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
      
      #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
    +
    + ## mm/slub.c ##
    +@@ mm/slub.c: static char *create_unique_id(struct kmem_cache *s)
    + 		*p++ = 'a';
    + 	if (s->flags & SLAB_ACCOUNT)
    + 		*p++ = 'A';
    ++	if (s->flags & SLAB_MAY_ACCOUNT)
    ++		*p++ = 'M';
    + 	if (s->flags & SLAB_DEBUG_NOOP)
    + 		*p++ = 'N';
    + 	if (p != name + 1)
    +
    + ## tools/include/linux/slab.h ##
    +@@ tools/include/linux/slab.h: enum _slab_flag_bits {
    + 	_SLAB_PANIC,
    + 	_SLAB_TYPESAFE_BY_RCU,
    + 	_SLAB_ACCOUNT,
    ++	_SLAB_MAY_ACCOUNT,
    + 	_SLAB_FLAGS_LAST_BIT
    + };
    + 
    +@@ tools/include/linux/slab.h: enum _slab_flag_bits {
    + #define SLAB_TYPESAFE_BY_RCU	__SLAB_FLAG_BIT(_SLAB_TYPESAFE_BY_RCU)
    + #ifdef CONFIG_MEMCG
    + # define SLAB_ACCOUNT		__SLAB_FLAG_BIT(_SLAB_ACCOUNT)
    ++# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_BIT(_SLAB_MAY_ACCOUNT)
    + #else
    + # define SLAB_ACCOUNT		__SLAB_FLAG_UNUSED
    ++# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_UNUSED
    + #endif
    + 
    + void *kmalloc(size_t size, gfp_t gfp);
 2:  7bde3ab6533f !  2:  9323ceca452f lib/maple_tree: specify SLAB_MAY_ACCOUNT for maple_node cache
    @@ Commit message
         Path: mtree_insert_range(GFP_KERNEL_ACCOUNT) -> mas_nomem()
           -> mas_alloc_nodes() -> kmem_cache_alloc(maple_node_cache)
     
    -    Assisted-by: LLM
         Cc: "Liam R. Howlett" <liam@infradead.org>
         Cc: Alice Ryhl <aliceryhl@google.com>
         Cc: Andrew Ballance <andrewjballance@gmail.com>
 3:  1c34ea46a76e !  3:  0558bdf4936a lib/xarray: specify SLAB_MAY_ACCOUNT for radix_tree_node cache
    @@ Commit message
           -> xas_store() -> xas_alloc() (gfp |= __GFP_ACCOUNT)
           -> kmem_cache_alloc_lru(radix_tree_node_cachep)
     
    -    Assisted-by: LLM
         Cc: Matthew Wilcox <willy@infradead.org>
         Cc: linux-fsdevel@vger.kernel.org
         Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
 4:  d9e638c3320d !  4:  96f41e2fa6db fs/buffer: specify SLAB_MAY_ACCOUNT for buffer_head cache
    @@ Commit message
         Path: ext4_getblk() -> folio_alloc_buffers(GFP_NOFS | __GFP_ACCOUNT)
           -> alloc_buffer_head() -> kmem_cache_zalloc(bh_cachep)
     
    -    Assisted-by: LLM
         Cc: Alexander Viro <viro@zeniv.linux.org.uk>
         Cc: Christian Brauner <brauner@kernel.org>
         Cc: Jan Kara <jack@suse.cz>
 5:  c986fd19aacd !  5:  4f6b86b850c7 net: skbuff: specify SLAB_MAY_ACCOUNT for skbuff_head_cache
    @@ Commit message
           -> alloc_skb_with_frags() -> __alloc_skb()
           -> kmem_cache_alloc_node(skbuff_head_cache)
     
    -    Assisted-by: LLM
         Cc: "David S. Miller" <davem@davemloft.net>
         Cc: Eric Dumazet <edumazet@google.com>
         Cc: Jakub Kicinski <kuba@kernel.org>
    @@ Commit message
         Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
         Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
         Cc: netdev@vger.kernel.org
    +    Acked-by: Jakub Kicinski <kuba@kernel.org>
         Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
     
      ## net/core/skbuff.c ##
 6:  c86eb6c221f7 !  6:  c6f61c47e801 kernel/fork: specify SLAB_MAY_ACCOUNT for thread_stack cache
    @@ Commit message
           -> dup_task_struct() -> alloc_thread_stack_node()
           -> kmem_cache_alloc_node(thread_stack_cache, THREADINFO_GFP)
     
    -    Assisted-by: LLM
         Cc: Kees Cook <kees@kernel.org>
         Cc: David Hildenbrand <david@kernel.org>
         Cc: Lorenzo Stoakes <ljs@kernel.org>
 7:  a37935e9f1d8 !  7:  7c448f3688f4 arm64/mm: specify SLAB_MAY_ACCOUNT for pgd_cache
    @@ Commit message
         Path (e.g. 64K pages): copy_process() -> mm_init() -> pgd_alloc()
           -> kmem_cache_alloc(pgd_cache, GFP_PGTABLE_USER)
     
    -    Assisted-by: LLM
         Cc: Catalin Marinas <catalin.marinas@arm.com>
         Cc: Will Deacon <will@kernel.org>
         Cc: Mark Rutland <mark.rutland@arm.com>
 8:  948c9aa21dbf !  8:  8d5c29a8d6d6 powerpc/mm: specify SLAB_MAY_ACCOUNT for pgtable caches
    @@ Commit message
           -> kmem_cache_alloc(PGT_CACHE(PGD_INDEX_SIZE),
                               pgtable_gfp_flags(mm, GFP_KERNEL))
     
    -    Assisted-by: LLM
         Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
         Cc: Michael Ellerman <mpe@ellerman.id.au>
         Cc: Nicholas Piggin <npiggin@gmail.com>
 9:  0b2d6a632aeb !  9:  9e68e442c86b iommu: specify SLAB_MAY_ACCOUNT for slab-backed page table caches
    @@ Commit message
           iommu_map(GFP_KERNEL_ACCOUNT) -> sun50i_iommu_map()
             -> sun50i_dte_get_page_table() -> kmem_cache_zalloc(iommu->pt_pool)
     
    -    Assisted-by: LLM
         Cc: Will Deacon <will@kernel.org>
         Cc: Robin Murphy <robin.murphy@arm.com>
         Cc: "Joerg Roedel (AMD)" <joro@8bytes.org>
10:  df629ca9f8a3 ! 10:  0fb6578f9d32 fanotify: specify SLAB_MAY_ACCOUNT for event caches
    @@ Commit message
           -> fanotify_alloc_event(GFP_KERNEL_ACCOUNT)
           -> kmem_cache_alloc(fanotify_{fid,path,perm,mnt}_event_cachep)
     
    -    Assisted-by: LLM
         Cc: Jan Kara <jack@suse.cz>
         Cc: Amir Goldstein <amir73il@gmail.com>
         Cc: linux-fsdevel@vger.kernel.org
11:  d3fd8833b207 ! 11:  cd123bafe26d smack: specify SLAB_MAY_ACCOUNT for smack_rule cache
    @@ Commit message
           -> security_prepare_creds(GFP_KERNEL_ACCOUNT) -> smack_cred_prepare()
           -> smk_copy_rules() -> kmem_cache_zalloc(smack_rule_cache)
     
    -    Assisted-by: LLM
         Cc: Casey Schaufler <casey@schaufler-ca.com>
         Cc: Paul Moore <paul@paul-moore.com>
         Cc: James Morris <jmorris@namei.org>
         Cc: "Serge E. Hallyn" <serge@hallyn.com>
         Cc: linux-security-module@vger.kernel.org
    +    Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
         Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
     
      ## security/smack/smack_lsm.c ##
12:  e491d907f0da ! 12:  33a8d0abf54e hostfs: specify SLAB_MAY_ACCOUNT for inode cache
    @@ Commit message
         Path: lookup -> hostfs_iget() -> hostfs_alloc_inode()
           -> alloc_inode_sb(sb, hostfs_inode_cache, GFP_KERNEL_ACCOUNT)
     
    -    Assisted-by: LLM
         Cc: Richard Weinberger <richard@nod.at>
         Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
         Cc: Johannes Berg <johannes@sipsolutions.net>
13:  495470a3e8c2 ! 13:  3dd416de21c1 mm/memcontrol: do not allow charging objects without SLAB_MAY_ACCOUNT
    @@ Commit message
         is never charged does not access the objcg slot again, and the free
         path already skips such caches via slab_needs_objcg().
     
    -    Assisted-by: LLM # Changelog
         Cc: Johannes Weiner <hannes@cmpxchg.org>
         Cc: Michal Hocko <mhocko@kernel.org>
         Cc: Shakeel Butt <shakeel.butt@linux.dev>
14:  84b9be2d2d42 ! 14:  533a72d59074 mm/slab: do not set SLAB_MAY_ACCOUNT for all caches
    @@ Commit message
         the objcg slot in slabobj_ext for caches that are never charged to a
         memcg.
     
    -    Assisted-by: LLM # Changelog
         Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
     
      ## include/linux/slab.h ##

---
Harry Yoo (Meta) (14):
      mm/slab: allow passing SLAB_MAY_ACCOUNT to kmem_cache_create()
      lib/maple_tree: specify SLAB_MAY_ACCOUNT for maple_node cache
      lib/xarray: specify SLAB_MAY_ACCOUNT for radix_tree_node cache
      fs/buffer: specify SLAB_MAY_ACCOUNT for buffer_head cache
      net: skbuff: specify SLAB_MAY_ACCOUNT for skbuff_head_cache
      kernel/fork: specify SLAB_MAY_ACCOUNT for thread_stack cache
      arm64/mm: specify SLAB_MAY_ACCOUNT for pgd_cache
      powerpc/mm: specify SLAB_MAY_ACCOUNT for pgtable caches
      iommu: specify SLAB_MAY_ACCOUNT for slab-backed page table caches
      fanotify: specify SLAB_MAY_ACCOUNT for event caches
      smack: specify SLAB_MAY_ACCOUNT for smack_rule cache
      hostfs: specify SLAB_MAY_ACCOUNT for inode cache
      mm/memcontrol: do not allow charging objects without SLAB_MAY_ACCOUNT
      mm/slab: do not set SLAB_MAY_ACCOUNT for all caches

 arch/arm64/mm/pgd.c                |  2 +-
 arch/powerpc/mm/init-common.c      |  3 ++-
 drivers/iommu/io-pgtable-arm-v7s.c |  2 +-
 drivers/iommu/s390-iommu.c         |  4 ++--
 drivers/iommu/sun50i-iommu.c       |  3 ++-
 fs/buffer.c                        |  2 +-
 fs/hostfs/hostfs_kern.c            |  2 +-
 fs/notify/fanotify/fanotify_user.c | 10 ++++++----
 include/linux/slab.h               | 16 +++++++++++++---
 kernel/fork.c                      |  3 ++-
 lib/maple_tree.c                   |  2 +-
 lib/radix-tree.c                   |  2 +-
 mm/memcontrol.c                    |  6 ++++++
 mm/slab.h                          |  2 +-
 mm/slab_common.c                   |  8 +++-----
 mm/slub.c                          |  2 ++
 net/core/skbuff.c                  |  2 +-
 security/smack/smack_lsm.c         |  2 +-
 tools/include/linux/slab.h         |  3 +++
 19 files changed, 50 insertions(+), 26 deletions(-)
---
base-commit: 0b0985aeb9979c5fa5c3b872cecdf97ed4ed2b3e
change-id: 20261014-memalloc-prof-dont-waste-slabobj-ext-metadata-34f943ef9658

Best regards,
--  
Cheers,
Harry / Hyeonggon


