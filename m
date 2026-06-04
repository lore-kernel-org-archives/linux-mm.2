Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98912CD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 10:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8AC6B0088; Thu,  4 Jun 2026 06:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A286B008A; Thu,  4 Jun 2026 06:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08A36B008C; Thu,  4 Jun 2026 06:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3D986B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:59:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C0481205F8
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:59:20 +0000 (UTC)
X-FDA: 84841933680.10.606606F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id CF08C1C0012
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:59:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QrUk+Bgy;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780570758;
	b=MhQVhSAjD3TO1F0r5ovUI7x3Tx/Eyl8ojLFuMztIN43tzhpR+wmmjM9BmrA7Pf/7E7C041
	kZyxi7gVqJ++EraAdq0b4kEKEoC9uesPwMH2rfnfJ80jedzEn+VdnA5K+sJ3V1vXiimc2y
	Jnhdgk/2RC2XM4xtBYLdouAku98PS9Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QrUk+Bgy;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780570758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2ec4v9E88vZCFVppWUGEKmoCveFRHoOdqY/9bxA7aZE=;
	b=fitVEH98a5cpXg/v0a+R4tn+AirawdTCGwsQzevjXJXad+g3LZEzfPhkVPqmB65wHIqsd6
	5l1WsNWKFKiApo9GdtTygNEmxkcJRayWzpr8X2tS2/+obCluKlQZ/s/92Yn1dR4dZfVv9K
	67761tgVTDhA+sDJNeLvo0nRfFRAxTs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Description:Content-Type:
	MIME-Version:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:In-Reply-To:References;
	bh=2ec4v9E88vZCFVppWUGEKmoCveFRHoOdqY/9bxA7aZE=; b=QrUk+BgyX7yHzyD+iW5f2c64F4
	tXfeuQNQS5/jDJSHY0qag3LmRwWgO5CE2ZOIVuXJPm1TW99qNL2rzxpVVlXM0ZVppipZGGhBvJPZv
	CnL14Lz8Qf6gpbdzzriqHv0QtecwvrGkJCUTlxHBU+vVygUtiiM2dmOOUaNBsLStSood04pDn6CX/
	GEYhQB4Fv2FTyynfaSQ3XLrs0WA/ZbIFDIyNYO5zo4AF/mxoea2LCGDUu1QV9WG3dGb9GD0rT0k62
	Mu/PF3ehbsGz+k5ym0P035urNwK35NdvNVy/dvC+o3O/JkAR5WelzoE6WwZ2syjH0BVxZ81A2SSyu
	I8mWlBDg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wV5n5-004T7n-0T;
	Thu, 04 Jun 2026 10:59:11 +0000
Date: Thu, 4 Jun 2026 03:59:06 -0700
From: Breno Leitao <leitao@debian.org>
To: mst@redhat.com
Cc: mst@redhat.com, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, david@kernel.org, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: BUG: mm: VM_BUG_ON_PAGE in post_alloc_hook() via
 __ClearPagePrezeroed() on compound pages
Message-ID: <aiFZeSKzb4HLfjFm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Description: avid@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Stephen
Content-Disposition: inline
X-Debian-User: leitao
X-Rspamd-Queue-Id: CF08C1C0012
X-Stat-Signature: cw9odh3qsgjj97ema1drdftu19qhrbyr
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780570758-350401
X-HE-Meta: U2FsdGVkX19i+Y4ZjSlqgzKRrdDMnLryyb86XB9tGZfcOlssydpF7L6YvxSyqW/WthYjy6diy79MmWyEcuiEVJHwQ1v/pPx8YciIK4/wMSBHa3J2XiVntAFBKeo+PcGMUuHJxV58FxA0yh/rcIS9wt+MStA3O7AW1if0oGrtr5aPFFGJcE0kU9D5SkqEgvQK+D7ioyXmDrXBGKwELTMP38+pcI6+G8F/g440z4jDOQCFgSicBBJF4jl7mMf7pfYJhOBI2PMCQFE+7S4YYjH2aadXZTRnc2CaWrxo8kBWyck2zZaYeUrZdSeYGiav2jVlMHWHJZiE/1oTWbwIzwKAWTkwqEePKh2W0mN5Z3EsX+XqS6V2CsZGeQfjhUw7/yJasx06HuOFTB0t9l811mdLyYPbBS7pI8dh30KCqhqaU/li066PBo7CLq+D6ZxiVtjLgVyPtDsuKW9ll+gJiY037ATQwnXhk4CtMt4qe7r7OjJfaG5TXTpJNCmNDdZmFwB9R4dB8E9CexacY25zL99cC7XsA75RiEO3xZfLI1wqCFpdHbe6sACgGdAA3SlbwtupJIKVpvH0PeatZ3vnL2fUBEa1SSdDpf8bYR09G3tseuDx5lqYARkEzmemLWvSbfKiTGmHYvUEJOrqbw2bcnJ/7UA85bWHoTIEcNUso9HL3FfxOQMO7bh5uKbv0S2Jr1XMkWKAE5buYpsG1115LoeOmwf9dCjXQYTq5Y8nX90y0Ugv2VtNfau3JLT9YrWqtZUdGiz/YrnaWd+k5dM0oyJ37KvmQGETy9wSIgiJBfZ/huJmZBW88YR/IGXDiWD2PzCZsrqokSBgMVwDBmR9hDkakf+Q4GIHA4yAbyqWpKII/FaZ3N3ElGE8Cdx7VLreg6u5VfQURYeHrPtfzrkgwIEvHEZ3gIxou3N2w0GRt7ovbl8hd72SdT5gRh1AAUwTEasxR+jLmT67LkHLImfmCzX
 R5WBxdce
 qHu25OX61P/T5g0pF0ec4nXD3b1cxZdB+U4eP13TzDJAi2CPvyFbfTJaTFIT/vEz7g686POtrGqz8Up07pTPQlm+QM3u3DNFKCKsq4fsneuOawYxXsCbGQX5XChS4s00PGniWZMBNlJugcunhvze7oA3qgL2JCObTPvq+enT9FcwS4xci6Ur3gEpeFm1GUzfxP67K4U4+oL+Nw1AKdae88zq33zhKJrBGmqoizeQQ+aH+Qz/Uc2NiIZQNdO6PPtnbeTnG2GTrrHEVjeP1Fjk6Z/VsgL5SUI5n8ffYuny44STDUS6bntjKlBROjCFP5zATZURtFKV/it67gNbXHlhzr2q3Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michael,

Booting next-20260603 (a225caacc365) on arm64 with CONFIG_DEBUG_VM=y
panics in start_kernel() during kmem_cache_init():

  page dumped because: VM_BUG_ON_PAGE(1 && PageCompound(page))
  kernel BUG at ./include/linux/page-flags.h:682!
  Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
  CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.1.0-rc6-next-20260603
  Hardware name: linux,dummy-virt (DT)
  pc : post_alloc_hook+0x224/0x2b8
  Call trace:
   post_alloc_hook+0x224/0x2b8 (P)
   get_page_from_freelist+0x18a4/0x1b18
   __alloc_frozen_pages_noprof+0x1b0/0x2068
   __alloc_pages_mpol+0x130/0x2d0
   alloc_frozen_pages_noprof+0x64/0xe8
   alloc_slab_page+0x88/0x140
   new_slab+0x11c/0x680
   ___slab_alloc+0x18c/0x7f0
   __kmalloc_noprof+0x534/0x938
   do_kmem_cache_create+0x724/0x890
   create_boot_cache+0xc8/0x148
   create_kmalloc_cache+0x5c/0xc8
   new_kmalloc_cache+0x274/0x438
   create_kmalloc_caches+0x2c/0x88
   kmem_cache_init+0x228/0x2e0
   mm_core_init+0x74/0xa0
   start_kernel+0x1cc/0x4d0

Bisected (by inspection) to:

  504f40f6bda6 ("mm: page_reporting: skip redundant zeroing of host-zeroed
                 reported pages")

Reproducer:
  - linux-next 20260603, arm64 defconfig + DEBUG_VM=y (any debug-heavy
    config will do; mine also has PROVE_LOCKING/DEBUG_LOCK_ALLOC, but
    those are not required to trip the BUG once an order>0 __GFP_COMP
    allocation hits prep_new_page).
  - Boot under qemu-system-aarch64 -M virt with earlycon enabled.

I've tested something like the following and  I was able to boot the host:

  --- a/include/linux/page-flags.h
  +++ b/include/linux/page-flags.h
  @@ -679,7 +679,7 @@ FOLIO_FLAG_FALSE(idle)
    * PagePrezeroed() tracks pages known to be zero.  The allocator
    * uses this to skip redundant zeroing in post_alloc_hook().
    */
  -__PAGEFLAG(Prezeroed, prezeroed, PF_NO_COMPOUND)
  +__PAGEFLAG(Prezeroed, prezeroed, PF_ANY)

With that change the lockdep+DEBUG_VM kernel boots all the way through
SMP init and hands off to PID 1 on arm64.

Happy to test a follow-up patch if you'd prefer a different shape.

Thanks,
--breno


