Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2F3260A260B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZkPeK3S
Received: by kanga.kvack.org (Postfix)
	id EE5686B05C6; Tue, 10 Nov 2026 09:46:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBD136B05C7; Tue, 10 Nov 2026 09:46:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDEC36B05C8; Tue, 10 Nov 2026 09:46:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B902E6B05C6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:46:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 534DCA8603
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:46:54 +0000 (UTC)
X-FDA: 85419486348.29.A43FC3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 95155A0002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:46:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZkPeK3S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794322012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1KVmT/jAeHggYSDMy5XhsiWoFkhNbvG+TBe6IcrseP8=;
	b=bfsD8ntSfMMn9umCsmqy8UA4/5sU8sbHkYzkCccrlUr7CfJgRgtCQe7r4iVEcUmCzKdkj4
	cEmPiVvmooketbgJtysMCt82e5tA/IgJ2h/vrFiyLK3KUKJEGIr30tYUUeGg+naLLGIva6
	NeqMoIlIywKsZW6gxdf2s47lwaaUXm4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794322012;
	b=kL9QlqBNlp19mrvkkssvWoEk08eb4Ef3CgiyrVJI3UzD422+6LXkpClx2bkyXllyyL0igK
	r1UVTZ0x9hY8QP+IqfIOJk+/JQvB/XIqp45hhgMox7hYz57qVayC1ek+W6iycNMp09NjR+
	ggC2HKwOuayM1e0KyBr1c8cgYI+GpSk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZkPeK3S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC0C0447FD;
	Tue, 10 Nov 2026 14:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DED81F008BD;
	Tue, 10 Nov 2026 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794322011;
	bh=1KVmT/jAeHggYSDMy5XhsiWoFkhNbvG+TBe6IcrseP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OZkPeK3SJPZwzex0XvhopNw0+zo4i+WiKBEzj82AQHInnkKWB4VBeieUMz8ofOoCp
	 +u3bP35JvUZM/d+xteqYk81GWQCPplHbdF38AWss8uamUw4RxeueKzSsp7F/Q761Hm
	 /7q8F/gQdNlw1zJMCMPLOrqBuSh4o9Tj0eNrtEjh/Wg0llY+DWmNRzaiasmXpMGG2X
	 5mR0TUWRd2iNLGv5DYodgTkjsonUyYL3CrmxgqxmOkR3vOJPnqHSzzywV+s4KxwM+T
	 l2S1SJmtgsPgAZ87jfcOY/BM7y4Q4/jqF/GNGCqGWvQfVRrgYyTTbvbCXlyBqiIo/L
	 XGCOQVUbV2tkQ==
Date: Tue, 10 Nov 2026 15:46:49 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 00/10] replace CONFIG_SLUB_TINY with a slab_tiny boot
 parameter
Message-ID: <avMspQZD7fyg4i2x@thinkstation>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
X-Stat-Signature: 1x5q5psx44r5qjfasityz6w7zakhebwi
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 95155A0002
X-HE-Tag: 1794322012-799926
X-HE-Meta: U2FsdGVkX19OW+dGneYDm625W+tDmA+hJOgycZ6PJHU06QNrSjtC9bPxy3bDaxxs9htLa4GfTlv5SOBT2ITEARH5jhWEWuxDK0PQofxLwSWdjobeF65QtGDuMoYgDgpQrcq06KiCXTtGybRVasnvVQApg9EQpyOd9qCYmpDllrFyIbb8xp+eE83BHS/ugpIE7KBgApIOc7Ovj5YB0tbq95Q9Ian+9KiN37abThyQ2K2QFKhGNWj0rxzirf2OWI32FoD0qEBbwIY10eW4dICkcgR5WTtbS8TzkfZAmGxBT3sbmXRxZkQrJ7k/2kE6YHZnz0/k8DYpj1FiDshttklONZlaT8jN4lQBVHzPnWtkTZGxpgTE3OHJnlTDjOCJRnmDDScYvRxr1ie/6eekLE7FxiD+JiCsWKKIni8ris8kWnXe9QS8HCLmc2Rdlk/VZFaam6Ct+HuDXlbL4IyE8j9fA+DJGa6LJHzqt/oCuJfsAPeLpGz8ePHmMj5T5fWLTnDfxZSNkigzemJsnUZYopMwdk1IZLLQPafFGvnrc1rCJLc7gm4TKnxUxNwkmFy3V4WIGFwLomng/AenKgj9j4MIRz8LkaS2mHZyGnkKvwuAPQAnubiEof2bDqJM3lvCKYCm6SMpvb06WlYTIoZljqqYaqm+z4MiQN8vVd/9F1wXtgTSh+j6M36BeHRC5xKpSbRoMLtr2lHjFF2RO/fXhgeGEtsBEeJqEhabZoDSeJIGi1W5j9CgM4O+LyW+gS6AVjP2NnRA6GkG9u0SYkILTGVeLz8NuArB7lXWyzGOWt8CgZIHC6oJOrGw4gk4nKuqe5Goqg7ofNi8q2xyiBwQdSFZhHN+FUwKSH52U+7PlMsCYoRK9RGNozE8WXpi7Ma+xvl+OKD+loZAlehIfqHNtYFaWi5MGU5IFxaOFYNHPWsa/uHt6yHRDWej0VvfYdqtkd+w/H+urmDc2rZSgLF9sDR
 5UOmKF8y
 wc9sJyLT54oMj9tyB/oPEvmeHvxb10hdYODVRL0eF57dlGpQ1kIX6OBE2KZrdA3NFCQ7CvVgvC+htt1A26mEArnpcO55ca3vHEYVhQLaNLpOCnYXrD3QZ5iwLkhSJ3b5EzzNpCG9cGiBER9hbNSSbzulF5r96wEFzKjoZYOKkw7WrIRbgcT+9dzbNCFvTf4qh41P0F+WZWS8eEbUL/YC3GolwMC+j+5cbfhjNg/f+p2r6SLnsKF00sVHQ0mAuhTk/ABc95DTpu7atnaVplmQJXYSC30LUVr6RWHAMmv4efU/+i2M9JTUFu/QJRWoiRbfjq2OtQonsAeDYoKGkcobOz59pl9shWFx0pQSYnv0SnqptE/5dNV3misMEaaCCO7Tym22rORnjx5pFYfREJgTaCeM8Q6GpxmB31uzhP3GCED1q9uElQnBHWvqGdVxXO9XQAxMl8wWHTeMWtU4byrW4DdwLe1ucb8/7QSyx+/bxr7fOu5yuVU3S3iU5egrhPL2JsZaM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thanks. I think it'll be ready once the issues on patch 2 and 4 are
addressed. Could you please adjust in v4 and respin?

Also I think it's worth measuring impact on memory footprint of this
(SLUB_TINY before this series vs. slab_tiny after this series)
and put that in the cover letter.

On Thu, Nov 05, 2026 at 09:43:49AM +0100, Vlastimil Babka (SUSE) wrote:
> CONFIG_SLUB_TINY was introduced to help tiny systems migrate away from
> the SLOB implementation so it could be removed. Its main purpose has
> been to disable all forms of percpu object caching (cpu slabs back then,
> now sheaves), and being a compile-time config option, some extra minor
> saving were achieved by code elimination or more agressive merging of
> caches with reclaimable and non-reclaimable objects (keeping those
> separate helps reduce high-order page fragmentation but not memory
> footprint.
> 
> However being a config option brings issues such as incompatibility with
> other options that has caused troubles in the past and Linus argued for
> removing it [1]. Moreover, there is a use case for having full-blown
> scalable implementation enabled and being able to disable it with a
> boot-time rather than compile-time decision. That ise base is the kdump
> kernel which shares the same vmlinux but wants to minimize the memory
> overhead (which has to be pre-reserved from the production kernel) and
> does not mind reduced scalability.
> 
> Thus this series reworks the CONFIG_SLUB_TINY to be controlled by a
> variable set by a boot-time parameter. The config option itself is
> deprecated and only sets the default value of the variable, and all its
> interactions with other config options are removed.
> 
> The conversion builds mainly on the fact that most SLUB_TINY specific
> paths to avoiding percpu object caching are shared with slab_debug
> handling, except doing any actual debugging checks.
> 
> Thus introduce slab_debug=N (for No-op) option to allow using the
> slab_debug checks directly, and extract the underlying static key
> handling from CONFIG_SLUB_DEBUG only scope. The decision to create
> separate kmalloc-rcl caches is also made to be boot-time.
> 
> The parts of CONFIG_SLUB_TINY that can't be transformed to a boot-time
> decision are related to dead code elimination and fast path inlining,
> merging of non-kmalloc reclaimable and unreclaimable caches, an
> ignoring SLAB_NO_MERGE for performance purposes (currently used in
> networking). Those lost memory saving should be all relatively minor
> compared to the savings from avoiding percpu caching.
> 
> To sum up, after this series:
> 
> - CONFIG_SLUB_TINY is a deprecated option that has no interaction with
>   other options and only controls the default behavior.
> 
> - New slab_tiny boot parameter controls the functionality (and can
>   override CONFIG_SLUB_TINY in both directions).
> 
> - slab_debug=N can effectively achieve most of slab_tiny and on a
>   per-cache basic
> 
> - the implementation is simpler with many ifdefs removed
> 
> [1] https://lore.kernel.org/all/CAHk-=wh-k04MsoEC0SGKff2Snm6bBF_e+0pHOKwaWv4umZ_SnQ@mail.gmail.com/
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>
> Changes in v3:
> - Rebase to v7.4-rc1
> - Add SLAB_DEBUG_NOOP to SLAB_MERGE_SAME (sashiko)
> - Prevent premature slab free in slab and kasan kunit tests by new
>   patches 1 and 2 (sashiko)
> - Link to v2: https://patch.msgid.link/20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org
> 
> Changes in v2:
> - Rebase to current mainline (with slab/for-7.4 merged)
> - Stop triggering nohash pointers due to slab_debug=N (Harry)
> - Stop preventing slab merging dues to SLAB_DEBUG_NOOP (Harry)
> - Link to v1: https://patch.msgid.link/20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org
> 
> ---
> Vlastimil Babka (SUSE) (10):
>       slab, kunit: pin test slabs by an extra allocation
>       kasan, kunit: pin test slabs by an extra allocation
>       mm, slab: refactor slab_min/max_order handling
>       mm, slab: introduce slab_debug=N
>       mm, slab: rework KMALLOC_RECLAIM handling of SLUB_TINY
>       mm, slab: make SLUB_TINY handling dynamic for sizing decisions
>       mm, slab: convert CONFIG_SLUB_TINY checks to kmem_cache_debug()
>       mm, slab: remove remaining compile-time checks for CONFIG_SLUB_TINY
>       mm, slab: add slab_tiny boot param
>       mm, slab: deprecate CONFIG_SLUB_TINY and reduce its Kconfig effects
> 
>  Documentation/admin-guide/kernel-parameters.txt |   4 +
>  Documentation/admin-guide/mm/slab.rst           |  18 ++-
>  include/linux/slab.h                            |  17 +--
>  lib/Kconfig.kasan                               |   2 +-
>  lib/tests/slub_kunit.c                          |  36 ++++-
>  mm/Kconfig                                      |  16 +--
>  mm/Kconfig.debug                                |   2 +-
>  mm/kasan/kasan_test_c.c                         |  24 +++-
>  mm/slab.h                                       |  32 ++---
>  mm/slab_common.c                                |  21 +--
>  mm/slub.c                                       | 167 ++++++++++++------------
>  11 files changed, 195 insertions(+), 144 deletions(-)
> ---
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> change-id: 20260911-slub_tiny_rework-8f2634dd17a7
> 

-- 
Cheers,
Harry / Hyeonggon

