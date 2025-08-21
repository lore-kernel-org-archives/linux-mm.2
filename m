Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96F5ACA0EFC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC72B8E000B; Thu, 21 Aug 2025 12:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76A38E0001; Thu, 21 Aug 2025 12:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3F38E000B; Thu, 21 Aug 2025 12:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB5A18E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:19:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E015B9895
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:19:27 +0000 (UTC)
X-FDA: 83801274774.18.13572A0
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf21.hostedemail.com (Postfix) with ESMTP id D14171C000D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:19:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OiZDOg5D;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755793166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9U9sHMnRN2PHre+DKxM/ny5WG9bUK7rj+7eoB/DEi5w=;
	b=gTen/j4GnwN2rQzfq6tzkmJQsQ3Ohx53qc46Yge/2YhMWEFX3ftdrpLct5bQK4T4WBr6Rp
	M50MpXFUmXh5iUAr0fXbPv96IcOBC+kYtKa5ihNFEAaURzzONvKXiXPdYOw441Jj2mRQWA
	Rc7l1dc4N+VS8iQn9cfD/F8eL9VnF9M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OiZDOg5D;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755793166; a=rsa-sha256;
	cv=none;
	b=QbW9sFkf2vqqf3ibL6q4MZCfIfAQleopSg+O0Mp5jJ9rrbEBMvbxiIfu7aEJRPtFZEZj2T
	/kpbsrZA8hDaUtb1UtvT2Vl1CKhbcyl4Tgozsk/MaG0P8hRw40GJ5tbScJKGw1s938iZpr
	O7rlOJ7pIZI3T/jc6yzaCkLrL8QIdfQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 4950EA58501;
	Thu, 21 Aug 2025 16:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5423C4CEEB;
	Thu, 21 Aug 2025 16:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755793164;
	bh=1QmruyZo3DKu0eWoZjVlLIS1lofS9SNdP9MW4v2BJPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiZDOg5DCZOotIQ1qrB3ymxLpRQ1nTSlEa0a7kwnwwtcvUtivowpB6GodOP8XymS7
	 4oxf7aFl2oTTi9wKxzHLmjXeQGpYi0fJ6xQ8OyA1aTHo98gTUmG8UGdG0tPxS9zhqg
	 7sStSsp96QotS1iDrZlV3rGiTzyr4pY5GbE6o41XPG7k0LnTniZ4EVZvpYdwPYlOCR
	 m74IZP/AaqkgNDfpysFhPIiNrecTEQz28Uea0lqUOBccTT5CtjGa21wQ+7iE4NZpCK
	 cG9ZRhRUbm5HGpp8OG3QPCZyz3YvMlPk3kIjX+0DKCo4sBP3xYjcy2yBBCgeHwemtY
	 nMBy0IGZvuarw==
From: SeongJae Park <sj@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [linux-next:master 3382/3950] mm/zswap.c:48:15: sparse: sparse: symbol 'zswap_stored_incompressible_pages' was not declared. Should it be static?
Date: Thu, 21 Aug 2025 09:19:22 -0700
Message-Id: <20250821161922.78301-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <202508211706.DnJPQQMn-lkp@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D14171C000D
X-Rspam-User: 
X-Stat-Signature: 5zw3z5g8t784ytzsfmoxetd6zp5wrzqq
X-Rspamd-Server: rspam09
X-HE-Tag: 1755793165-103696
X-HE-Meta: U2FsdGVkX1/+qwghdfJABhOBrGZsXoptEjRD49PtJVdg+OntmMC5rpODbjLfe/s5PRm4cnff7etekZf64H+TxGkTHpd6ZYCrkebE3Mkoav87hUYFIlu7TSzQFAPU807XwrjMaskTsJ6AszM5ghmBMFww6NzZYvSGSJeVUdn+q2+Or/foz4NVKPYw0hkLqnGgKbPtwy35DGDWNZStwnA7WuO8aOH3OJ3LqZW0gm1dP+V9fLAy3xTlLEtzv99WPC5DSnXWoM31bDeywFWoHZ7LgGX6JgONB1Ke3WFIkL5B7bqiBi72BA6bXuM7eLOEx/3PX0zSj6Me00ci2I83fpN6z3vz16E0cu7K/PpQVc+w6zuLTYFJOfeCy/79nnX65rGcBpOwzRyxoj8GMsxJrY7FL4ft0Qismf6jxHW1EAu0oBF+MX3DJawshY3XMCDKr3A+HVHakEvW37+V6KoEDVAbJ50PeRBVDzQtj27nTk2jEEgtG8C0ULCrUgSbnrqcMAB1SgWIb7Ft/tktTmjHdkaZSZU4aAHo5MuXoplL9Ch+vPGpN+c1uJjNLXzMSoSWD6fNN7dy3nZFADr4q3mYlfBnXIavmV7b2DBfyFmB6FDsB62PLmhFuNlbZnbg0bg7rIDSY9267JO0H6HYH5P3Z+VdKS2Ng4jAYbDIhBAFLEKZn5Na60mi6AtzQKNbkGEAKRZ0jsvfp3HycVRAAhksMUFUnVLY9T0EgVQvj7/eLkQdd5p80pWBBeMTnCp0wKWG6bKYPEqOgqLVaeIFGJ/aIjJ4JjL2hDrrxh8W7fmTApKMJCTj3oyHmxQPvwUyXOog6Wd0lDHwElVlGjZUm+m2giYywDMn9rN6ufD4XmKkfL7JN75Tsw0/LXq5e6NPfgyrUrURXup16BZ+Wpj0R0pTmEGJi4P+qU3MQgnLmtXBOV4IRewAnDyzdgZSPEpxhqApT5sZyFdBi1YN9BRclz0cP8t
 fEwG9NKD
 5wnzM309tVLHNUriIPYa7D9gfMYLxQuyUFSkQu6wZZ6RRCwMEgRVBeuduupvYYFUTUAmYxYAcJyLRtIqJyxXBoeaK/TZwFmeeKT5fw2iX9HNVJX/H68YR0Jv7ZZ7gwvPgQFDPE/HYX0mztNvaAfQdLk7XdAUzrFTeB+CWaHbR1SAlzBmmOEXfP192PoSJBIl/aYJbFJAdV/OnK605th1XfsvSU2sAh0lp+K5a4RIy7UarQEMZKLFWn/lhsd3fB57LVd7tTIVyH9X5nhqkRq/DaQNoQ63KY3Jiqb3fq9J3L+zdPn8pGJCKIZ71AxWQZ4FBxnEZ23VRUE5MM+52v9KN/lg6v8lWksKo9jet48OXrAOoMg/cRp0iV4nySvZTlGPytCOkWd/riN4Q5pOjM+XFgdrHW7GZ4aTd4hg1z0Kp3BUOLd5MW2fwrm7R4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 17:43:16 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   7fa4d8dc380fbd81a9d702a855c50690c9c6442c
> commit: 6d522abd7b4fc78d51934e6c9a53d8e2349f5d3e [3382/3950] mm/zswap: store <PAGE_SIZE compression failed page as-is
> config: arc-randconfig-r123-20250821 (https://download.01.org/0day-ci/archive/20250821/202508211706.DnJPQQMn-lkp@intel.com/config)
> compiler: arc-linux-gcc (GCC) 13.4.0
> reproduce: (https://download.01.org/0day-ci/archive/20250821/202508211706.DnJPQQMn-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508211706.DnJPQQMn-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
>    mm/zswap.c: note: in included file (through arch/arc/include/asm/cacheflush.h, include/linux/cacheflush.h, include/linux/highmem.h):
>    include/linux/mm.h:80:9: sparse: sparse: preprocessor token PAGES_TO_MB redefined
>    mm/zswap.c: note: in included file (through arch/arc/include/asm/irqflags-compact.h, arch/arc/include/asm/irqflags.h, include/linux/irqflags.h, ...):
>    arch/arc/include/asm/arcregs.h:155:9: sparse: this was the original definition
> >> mm/zswap.c:48:15: sparse: sparse: symbol 'zswap_stored_incompressible_pages' was not declared. Should it be static?
>    mm/zswap.c:1250:23: sparse: sparse: context imbalance in 'shrink_memcg_cb' - unexpected unlock
> 
> vim +/zswap_stored_incompressible_pages +48 mm/zswap.c
> 
>     41	
>     42	/*********************************
>     43	* statistics
>     44	**********************************/
>     45	/* The number of pages currently stored in zswap */
>     46	atomic_long_t zswap_stored_pages = ATOMIC_LONG_INIT(0);
>     47	/* The number of incompressible pages currently stored in zswap */
>   > 48	atomic_long_t zswap_stored_incompressible_pages = ATOMIC_LONG_INIT(0);
>     49	

Thank you for this report!  I just sent a fixup patch:
https://lore.kernel.org/20250821161750.78192-1-sj@kernel.org


Thanks,
SJ

[...]

