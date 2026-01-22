Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F581C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 05:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96D46B00E3; Thu, 22 Jan 2026 00:55:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40E06B00E6; Thu, 22 Jan 2026 00:55:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70CC6B00E5; Thu, 22 Jan 2026 00:55:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B87076B00DF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:55:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4758A1AEC99
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:55:27 +0000 (UTC)
X-FDA: 84358537494.02.5F39E06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 79326180007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:55:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TcEcwJDX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769061325; a=rsa-sha256;
	cv=none;
	b=ozXxLR6lndrQBaIOvMnVGHB7JzJ5zY/SIW/XX5EJ9e1wMbUiE23o0wHBL4aZMr5GmoeEaA
	Mq7fFjl0vGthbue/aXJkyIMNRpXky4hNxY+db+vPLBjLYqMd728+WwSzoV4gKDjCrU9bMt
	ZmwkCtKXUi8obT7WtVr7shO2ZsKlneM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TcEcwJDX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769061325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U2g6M0TcXJuKi6w/uBsBkarXCdawUqZDpWCRQ/XVDEA=;
	b=Kcsi0d669mRAcrqbWhQ7Hy1yrNls7a/Jan4gaWsNZjQiIeJdJiTPxHjMrcVMovFz6J5Znx
	PNBQ/4W8PtxuKixqBwHusrlqoPWrHh+Z7o7L7Q2fAA5a8OYQWxg14N9MdI7sgyvN3o8OLA
	tSngKLMJtTntNCLVrkN7SQdxJMzED3E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B855415B7;
	Thu, 22 Jan 2026 05:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E14C116C6;
	Thu, 22 Jan 2026 05:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769061324;
	bh=FsEJ1i25ofqDLPMurKEIlGqdbxcvgVKLAQsTjORZPc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcEcwJDXuD62OY3g9lhU7gz5/Zw9IHOEcGPmHAXTJVWb09JQJ7c7xkfD8uuIJuoL4
	 o1/eH1CJVchZ8eWCXIFo2aINCvfIAtlr84MiTtufkyBRP7hWKbMDPIFQtHhAccdjgE
	 5VMx7TwU4ugt9PkrX88BAMmi3GyLh4c0/zHMz32l3ocOWfkYQKzMM55XF0/sSBMtKy
	 N3uZ6l5LJxMjq4pXqMCugY1TMA2Hij+sZCdn+lvzHcA90t1PEtnaXSMpZw7j363ZAN
	 YEHmQvDcFizzvsDoRGrrsE6ADlYSHjmOH4qzAZp2RWBeZyLZYy8AqaTuf+obf9A6tY
	 X5isCwHhTOVGg==
From: SeongJae Park <sj@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	maple-tree@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alice Ryhl <aliceryhl@google.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH v2 17/29] maple_tree: Start using maple copy node for destination
Date: Wed, 21 Jan 2026 21:55:15 -0800
Message-ID: <20260122055516.69335-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <202601220811.ac3t5OuP-lkp@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 79326180007
X-Stat-Signature: np9itooospzzdoqbu4q1faiohfiby6qf
X-HE-Tag: 1769061325-27098
X-HE-Meta: U2FsdGVkX1+n//u15W7nAc+pISUmBU4qA8IlUiVk7edVX97m9dyUPXbnXoU5/HqxvSbA4A3RwnJbiO58IQEMakzeaBmNx7QbXt5sa+4A5I8TIZOLuS9Zz+qFuqW7Bnm54QLJFUoifr8Cd0zgvvHzTFZiGYq3NzrUPQx0NfJaY7qwaCjihyVjTvm8KVLEcxdkoJMCzLO6W6xigNqjruGxvu4e2PVxCbW1tw0lYCtD54y158rlcw0ti6KSo19EeCuldLrfC8CYhYcjVhVAhxwMcM9JBpIc5uAb08SExNozOYEUJ5Y2rAA5e/vCOiKTr51uBKGHJa4D8CAvuc9xvaxxuWRWkX1FaJv4HQojIfuR+6Rj2KWNRidMmBHaSjT1nvuBHxDnc72LdvXnw+Q7DD17EWqCFcVQx8vxiDxa5Jg6xIcxFTC4/y6qqjOE9XDPBt2qxkrUTv5y4Vbfi/vclZEU/U2/esIfhMbB1H1dQuMF4KV7DQ+F3fTmrEpqOAJf6tOGkm/5B0OL/Uk5z4EnLP/TV+RlUohT8Tx1QcRCpVc5j3XIIyGF8b7WNtOJ2aO6Hc2z17y9ju0WQXYBnKI5YGmcVC1vKkKOEwhGlIQ0DpEB+EDyj9E47jl6ZOmGg7Y0EDzZOaKUJmr+FTzDXwaik33TyhK4nrZz5IoOud8zu/dUb5fA/ixpxu0jHbH/zza1KoEkxGcROk5P0fGNOJ9fSwIJej597evVsPhGDY2a8iH+7Ufax/1zxpnVSBw8xNSSxt6SobBje7gwY0At4vF3m+noEUe4IdwJR6F6DSn9CdbnbZXjRrtkZUJOnn4LQbwul/F0GGLZgUt3+ja+s2g/Fa1mSpaI16ZKvBLWDXK90Gq4Gpo499u6yd4bcy4JgqvOgiFnG103LDyxLl3GW4Di2nVbNBkDJrlICqm5wz27OExHt/bm63dFHsnJU4pwvLIvhNwz0lTayIsVyC1ZZFujtUe
 Y4T7NRz5
 wknsmekoYqIuMMlNOng2iAlHnv0XrEzhem5fl/dAW83j8z6WJvhHsnlUgk/5Pr/L0QoUuJpSaQF0ZzDlEX9bvnpgeD8juWJaJUyZspzQs1iCM6IP9ACifTLJUhASxb8caPW41J/6yR2HiEpIzvx9cPeoK/tCkkjRUSeKDA3d/kobx604mP6mpR2iViCVoifiOBzDfp9WPnCYqNzncLF1eL/PKFPHqk6aV7z4oa+OAymjXabHkytDOZdgN6prgLZioJD1TEJP6WPLUAWL+IhhUPKZZxI7U+pR7MxXFrhr/1KSKXVfnPGOWpBddlA1HNSnoxerzmpY3pXCcNTz2t6WaBje8zKiJRy4rp3Ovu1oS//pq5JFcm2uDdtPS5YFFwJkB3YZwSiXsBTkDkvA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 09:44:37 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi Liam,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on akpm-mm/mm-everything]
> [also build test ERROR on next-20260121]
> [cannot apply to akpm-mm/mm-nonmm-unstable soc/for-next linus/master v6.19-rc6]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/maple_tree-Fix-mas_dup_alloc-sparse-warning/20260122-023746
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20260121164526.2093265-18-Liam.Howlett%40oracle.com
> patch subject: [PATCH v2 17/29] maple_tree: Start using maple copy node for destination
> config: sparc-randconfig-002-20260122 (https://download.01.org/0day-ci/archive/20260122/202601220811.ac3t5OuP-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601220811.ac3t5OuP-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601220811.ac3t5OuP-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from ./arch/sparc/include/generated/asm/rwonce.h:1,
>                     from include/linux/compiler.h:380,
>                     from include/linux/array_size.h:5,
>                     from include/linux/kernel.h:16,
>                     from include/linux/maple_tree.h:11,
>                     from lib/maple_tree.c:56:
>    lib/maple_tree.c: In function 'cp_dst_to_slots':
> >> include/linux/rcupdate.h:555:36: error: dereferencing pointer to incomplete type 'struct maple_enode'
>     #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
>                                        ^~~~
>    include/asm-generic/rwonce.h:55:33: note: in definition of macro '__WRITE_ONCE'
>      *(volatile typeof(x) *)&(x) = (val);    \
>                                     ^~~
>    include/linux/rcupdate.h:1046:3: note: in expansion of macro 'WRITE_ONCE'
>       WRITE_ONCE(p, RCU_INITIALIZER(v)); \
>       ^~~~~~~~~~
>    include/linux/rcupdate.h:1046:17: note: in expansion of macro 'RCU_INITIALIZER'
>       WRITE_ONCE(p, RCU_INITIALIZER(v)); \
>                     ^~~~~~~~~~~~~~~
>    lib/maple_tree.c:3155:3: note: in expansion of macro 'RCU_INIT_POINTER'
>       RCU_INIT_POINTER(cp->slot[d], mt_mk_node(mn, mt));
>       ^~~~~~~~~~~~~~~~

Seems this issue depends on compiler version.  I got similar error on my build
test, which uses gcc 8.1.0.  After increasing the version to 14.2.0, I don't
get the build error.

I also confirmed below simple change fixes the build error on my setup, and
added to my tree as a temporal fix.  I'm not familiar with maple tree code or
clearly understanding exactly what gcc change caused the issue, so I'm unsure
if my fix is a right one.  I'm sharing that only for a reference, as anyway I
have to make it and add to my tree as a temporal fix.


Thanks,
SJ

[...]
=== >8 ===
From 6b0051e419cc5129133f8eb94db7f44afd8170fa Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 21 Jan 2026 21:24:08 -0800
Subject: [PATCH] temporal build fix

Link: https://lore.kernel.org/202601220811.ac3t5OuP-lkp@intel.com
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 lib/maple_tree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 2d840b9a360f8..7aafcec45c6f2 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3152,7 +3152,7 @@ static inline void cp_dst_to_slots(struct maple_copy *cp, unsigned long min,
 		 * read-side operations that can view them until they are
 		 * inserted into the tree after an rcu_assign_pointer() call.
 		 */
-		RCU_INIT_POINTER(cp->slot[d], mt_mk_node(mn, mt));
+		RCU_INIT_POINTER(cp->slot[d], (void *)mt_mk_node(mn, mt));
 		cp->pivot[d] = slot_max;
 		if (mt_is_alloc(mas->tree)) {
 			if (ma_is_leaf(mt)) {
@@ -3375,7 +3375,8 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 			 * the tree after an rcu_assign_pointer() call.
 			 */
 			RCU_INIT_POINTER(cp->slot[0],
-					 mt_mk_node(cp->dst[0].node, mt));
+					 (void *)mt_mk_node(
+						 cp->dst[0].node, mt));
 			cp->height++;
 		}
 		WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
-- 
2.47.3


