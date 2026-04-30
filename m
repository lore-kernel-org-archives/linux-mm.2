Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23016CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AE166B0088; Thu, 30 Apr 2026 04:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885956B008A; Thu, 30 Apr 2026 04:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2846B008C; Thu, 30 Apr 2026 04:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 692ED6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:12:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01E538BD69
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:12:31 +0000 (UTC)
X-FDA: 84714505344.29.CEA521C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 492421C000F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:12:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cQ5k6350;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777536750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzSuJUZ4ZZywHQ2pmdLZbzodHrA1GO4bwapeaRwk62E=;
	b=rP5pElPBTdQqR/19snVAGs7pomK+4STNgfalR0A98ZEZ9cUG74bB35baoI55tK3fQtWM6n
	D6W6ZUCsS5H7OiACDAqNLAg1Lhscl0ysdsX4LTR2IpDO0E3Gq1wz4bvamc4v9xyzZI7TCp
	73jGqXo8g9zXLposOMooJJLz6GYALdk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cQ5k6350;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777536750; a=rsa-sha256;
	cv=none;
	b=s/psR460Goxwc272bAhN1RxKR9TDQyuIsSfuxATRLqqef9D0XvMX8dLQZ9kWwkGr5XU0F6
	EUchJ7O3GYX8fZ53kdIn7IkevxB5LYQffii7D94enJxmbKvpTilQW0tsmyKtfnYb1ImGvq
	zcys4we8Dyz+4A/cPVAVEsaY5PHdAVY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 750BD416FD;
	Thu, 30 Apr 2026 08:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EC7C2BCB3;
	Thu, 30 Apr 2026 08:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777536749;
	bh=3r6FBCLfdTgQTcHvUWCboigdXt/17gWJ3pz4WmvT4F0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cQ5k6350RzMg8kHS1Inf0QbqtrRUZXu1nY9DeE2O1HjdOgku3DiC1kynfGZFCeUcY
	 2zACY7QRY5slN7PQfFSYfq4iJ5jSA5C0AjU4jTeIlHdv5Zod+7o3/eS+oqJGja4Gm1
	 oST/OXsQq22r+oE5X1J6bh5Z0dIDF37CXb09Rp7nHm2TiF1dg5+QJ7vuXeE22saKfU
	 +pasgaJ5qLQo/rmcBuZRhNJoCwC2KII34S/ecr7CZBIjEJo350pKpNi5W7Rj+W+2x5
	 u5SCShru7JgaHmM5ImsPkW4K/Pvtlj7Ryih04qID2fekYwNtXOQAsycTnLJQdQq+Z/
	 GZkTTe3c/peww==
Date: Thu, 30 Apr 2026 17:12:27 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: Shengming Hu <hu.shengming@zte.com.cn>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm/slub]  8952728641:
 BUG_kmem_cache:Freepointer_corrupt
Message-ID: <4sw3gj2ugc4v5ek3jv4h3da2r5lnrsio44kcpqf5cw7ncjeofu@wqyp5tavlq3w>
References: <202604301428.e2b8d3dd-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202604301428.e2b8d3dd-lkp@intel.com>
X-Stat-Signature: 55u71mk8hkjrmtqkkmus88yrhkf1gatx
X-Rspamd-Queue-Id: 492421C000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777536750-960205
X-HE-Meta: U2FsdGVkX1+g2+3oaqiBvsD6NMemfVrPx0yrzBCttVoodXLgCsrx7d2zLqdHjJjoNhXugQeW2119nJPZP1S9T89aNDMxuxiG6hpT3ldo0LBL4/GZOYH7vQ7tEakQhe/fAZxNhg2bWpytWvRVxgTa7IFjfF2PnPvDNNyYnUt+PYHaBuYtp6ksDgoIrF/RnJPRxY98vz6qgWF/z4x2v+058aZGqu1rNpoAf5+8uuYrrEYheysgpFNoZg0FmS+5tBA5Bkegq8C6S0S+HSrJ+ci5e7iAe7MifOPGODDwQhEAi0ZQANXZOCZvLuWkjUGJMlYMiQijdlCaCIn4rtjFWy4uzB6w8Z5Ky9O7hCJlypuq/JGCcsHzFNSJkf4vSd2OHw1mShuqmWrvtV4Bit8q7To/BZVPDHKYD+MAUapaMa3qSxvFBH1r6qqmPZ9AVMYabCP8SzYlSLu1q33wIEwBtYthrprFdkUCG0kFcSBBkSYHUeCBO2BxWN8l7yXJtl26Pu1VN8xn+Twx1ExZ3bIJtT51P9bJ/n/Fe24gCTRV9MP//HuwVQfNuGjShxspIGLP141L7RJRXeVjAX5n5l8SxGN6kgF8CzVqOQvBG2GnXEOWahHBiT31PzO11CjvQ4HrAoqkwwXetx7S51Ckkw0xe6m+E8Tvx9Uv2tqqcILEcl06Gn2IVTYdSmdiu7oj50N8vLIuOFbuDfmygeWt4nHP0Q7bQ1jPtChLap23SHQxfHDrHlLiNps1znaCW+uXYw59CnSdP86rB5qA/ioJrnYLGcebRSywwAZPeI6kZJqBxEKH5HGaxVWUT3brk8WPkPyOuZDOpbxBt3Cn2P7x7O0pZ3e2ZgFQKNdLFZUhH8CJ18e1Q8sw4xh546TE+AwEO0hIrSOgG+ctQ1MGzQtIVWT5wEJfKM6VNFDRs66yLJo0UZku88grR8GgDXFOjiP9TdfkXEIeXiF957bvl9FDcZaNuB+
 sYJljI9n
 j92wEB3Ld1Y5xaB+nj9I5eW0L+t+2lZBeDg7VQ/kDn5pgAimxxUy4Xsoxz2+LqorFUp9eUrGuROrAU5xhIVAnb1MIPa/xevums0Ozf7dEGuKVDrPJ55Ul9jkclllqqMunObfadYECZNxkYYNJzFWNys0fa2wpVnqFqJEymgTOrz+lrlJdqTIL7k1ii0VlUtoXiaUdIvvr5hXODHHsi1/iUrGuoytc9halrmkimu1T1yJUcTYLfbKShkhdB6uUAogBz5EkDx0cvcniJNleEsOeKFnC/WEgeZswSLHALL2msixp3zHaLvHkBfnN0ZxXDQ/BtTiAxe0ZkiMPAVhBcbfK1P4v4ljshPSggAQf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Taking a quick look...

On Thu, Apr 30, 2026 at 02:16:37PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "BUG_kmem_cache:Freepointer_corrupt" on:
> 
> commit: 8952728641305ebcd03e80f79b8d31bb41d6d95f ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master 9974969c14031a097d6b45bcb7a06bb4aa525c40]
> 
> in testcase: boot
> 
> config: x86_64-randconfig-001-20251114
> compiler: gcc-14
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)

[...]

> [   53.929047][    T0] =============================================================================
> [   53.931786][    T0] BUG kmem_cache (Tainted: G                T  ): Freepointer corrupt
> [   53.934858][    T0] -----------------------------------------------------------------------------
> [   53.934858][    T0] 
> [   53.934858][    T0] -----------------------------------------------------------------------------
> [   53.934858][    T0] 
> [   53.939608][    T0] Slab 0xffffea0004001040 objects=9 used=1 fp=0xffff888100041200 flags=0x4000000000000000(zone=2)
> [   53.944008][    T0] Object 0xffff888100041040 @offset=64 fp=0x64ae22a70baa83ae
> [   53.944008][    T0] 
> [   53.944008][    T0] Object 0xffff888100041040 @offset=64 fp=0x64ae22a70baa83ae
> [   53.944008][    T0] 
> [   53.950913][    T0] Redzone  ffff888100041000: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> [   53.954703][    T0] Redzone  ffff888100041010: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> [   53.957662][    T0] Redzone  ffff888100041020: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> [   53.960527][    T0] Redzone  ffff888100041030: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> [   53.963607][    T0] Object   ffff888100041040: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   53.966785][    T0] Object   ffff888100041050: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   53.969753][    T0] Object   ffff888100041060: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   53.972621][    T0] Object   ffff888100041070: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   53.975559][    T0] Object   ffff888100041080: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   53.978756][    T0] Object   ffff888100041090: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   53.981898][    T0] Object   ffff8881000410a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   53.985140][    T0] Object   ffff8881000410b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   53.988289][    T0] Object   ffff8881000410c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   53.991279][    T0] Object   ffff8881000410d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   53.993987][    T0] Object   ffff8881000410e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   53.996539][    T0] Object   ffff8881000410f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   53.999493][    T0] Object   ffff888100041100: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [   54.002253][    T0] Object   ffff888100041110: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
> [   54.005170][    T0] Redzone  ffff888100041120: bb bb bb bb bb bb bb bb                          ........
> [   54.007879][    T0] Padding  ffff888100041180: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> [   54.010661][    T0] Padding  ffff888100041190: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> [   54.013403][    T0] Padding  ffff8881000411a0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> [   54.016151][    T0] Padding  ffff8881000411b0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ

the object content has 0x6b (POISON_FREE) and there is no free pointer
because we skipped it when allocating objects from a new slab.

> [   54.019282][    T0] Disabling lock debugging due to kernel taint
> [   54.021208][    T0] ------------[ cut here ]------------
> [   54.022797][    T0] WARNING: mm/slub.c:1231 at object_err+0x6c/0x7f, CPU#0: swapper/0
> [   54.077963][    T0]  <TASK>
> [   54.079139][    T0]  check_object.cold+0x4b/0x50
> [   54.080583][    T0]  alloc_debug_processing+0x9b/0x180

But alloc_debug_processing() always expect a valid free pointer (within
the slab or NULL.

I think it can be fixed by initializing the free pointer in
before calling alloc_debug_processing() in alloc_single_from_new_slab().
(with a comment explaining why)

Could you respin the patch with the issue addressed, Shengming?

> [   54.082495][    T0]  alloc_single_from_new_slab+0x82/0x200
> [   54.084323][    T0]  ? alloc_slab_obj_exts_early+0x5/0x2c0
> [   54.086455][    T0]  ? allocate_slab+0x11b/0x380
> [   54.087892][    T0]  ___slab_alloc+0x1ad/0x340
> [   54.089129][    T0]  ? bootstrap+0x20/0xb0
> [   54.090520][    T0]  kmem_cache_alloc_noprof+0x30b/0x540
> [   54.092010][    T0]  ? bootstrap+0x20/0xb0
> [   54.093328][    T0]  bootstrap+0x20/0xb0
> [   54.094484][    T0]  kmem_cache_init+0xbb/0x330
> [   54.095786][    T0]  ? preallocate_vmalloc_pages+0x1a4/0x2b0
> [   54.097485][    T0]  mm_core_init+0x12b/0x170
> [   54.098935][    T0]  start_kernel+0x173/0x370
> [   54.100291][    T0]  x86_64_start_reservations+0x28/0x30
> [   54.101912][    T0]  x86_64_start_kernel+0x131/0x140
> [   54.103325][    T0]  common_startup_64+0xbd/0xc8
> [   54.131853][    T0] FIX kmem_cache: Marking all objects used

-- 
Cheers,
Harry / Hyeonggon

