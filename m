Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C68CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 22:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5C0A6B0005; Thu, 28 May 2026 18:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0CD26B0088; Thu, 28 May 2026 18:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22BC6B008A; Thu, 28 May 2026 18:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B47EB6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:16:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58D90161EF5
	for <linux-mm@kvack.org>; Thu, 28 May 2026 22:16:22 +0000 (UTC)
X-FDA: 84818238204.04.CF93CC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A4C031C0003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 22:16:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DN6I2KP8;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780006580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLt+xHl/igW7/uoHhFaIthjEDGE139MNPnu6HA06LIU=;
	b=feiLOsjZzMlvg5BuFVrj0lm0nfP3Fs5tPWs8MiLJ1jAwftWgoB0VzLFSo7DVNrZnMCmvay
	Lm0ltOTc4ogUOvfq7goJqf1FAClH8XVAjJZITdhUSTgzlYE1K/DzEoRMjkNq9bDNfDg/Wi
	P2rvDTn3lRg7ituBRRVa7m5MW+iGmP4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DN6I2KP8;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780006580; a=rsa-sha256;
	cv=none;
	b=hj+NsvEigMa+miH/GpoKV/RfSwe9evI2xYR7touANX71dZLnnWeeaCuFyZondy/FjAQ9wn
	rxfwbhQCnoeTYoiZCAKHQlU7PMgIHpsI+7rz6Uup+tN94ZZJIiC70fpbNTq5ZVeMmyee/d
	JJ96m7KtI95jRBQ9YOB/QAeT9xx80VI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 025046020A;
	Thu, 28 May 2026 22:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB7B1F000E9;
	Thu, 28 May 2026 22:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780006579;
	bh=TLt+xHl/igW7/uoHhFaIthjEDGE139MNPnu6HA06LIU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DN6I2KP87TaWhV4j9oHEQulEmdSIIbTijdb/JUVsfocZfVpmH44cjfqgGx0PedIqz
	 lrahMH/RZxsTViyuI9balSrw9AB59WLtNgbIdz+AveEn4St2UJKk0KnMC7we0VEEgb
	 +16AvK+/Ql2ILs0DX40GGLfV2k+hdAP52r412G6U=
Date: Thu, 28 May 2026 15:16:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [akpm-mm:mm-new 429/433] mm/swap_state.c:468:19: error: call to
 undeclared function 'folio_memcg_alloc_deferred'; ISO C99 and later do not
 support implicit function declarations
Message-Id: <20260528151618.7aa255415825c8d1de6ca437@linux-foundation.org>
In-Reply-To: <202605281620.lc3rtkBm-lkp@intel.com>
References: <202605281620.lc3rtkBm-lkp@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A4C031C0003
X-Stat-Signature: x5e51rgbx7bhiaankwjx6zsrmd6s8ono
X-Rspam-User: 
X-HE-Tag: 1780006580-714079
X-HE-Meta: U2FsdGVkX1/JFx3lrqQHvf7PTwFixEjem1tzIfE1EDoFiTxDHDQSjiGOdEPjO9B11/OsuZEQqHA6ychMgIihG3ESOGkKe5tsUAgBLpYg/kFdE1fx8crQgQ4z5AtcMkOYvxAm8sQJfBLS5hwkdny2Nfy5rT+Mo7zY4kahfBd/DR7YkNIuXG+17tCzfiyhR3Krv4M3aXWtAWbjMcybdI8btqYzMwryNrcGCARdVTEK4mkLB4SbXZAWxb4hp3lzGGbQxH15BGA5JvScWRQxQn2if3xQZ5sIIbkN/JFLiK3u3WQUcDgMFod2uzGoRehjGejGrbFqqMA/Sbs7vVGPH4PX+FX6oZxU+q1FZ0bx0QbQhTX2xkLXYxDOuowQsYY7c1tHqEorOwH213a4q6BM4j3M1sLqwIolQFxF/y8eVOoubhF08EmmwS2eT/LRaySpWgu9Op+IweM+ZnbT+nuyKE9gvN7bTD6PGSk55sK4PkBUEsUYB0L5K9qwDk9o1/KebrUDMHHY1foZtjQRgLpMBrn6VoyesYYmTl3O+Triow+iurExfNODTv3hE5GGj8IynITtlP4R19tubT2eSbAJMwI4JheT710C3RWT9f6SGTAerZVFhuBy/YE048U7K54T8W6nbyteyh+HJ24mLWNFzcRNJ16LjK1zT4j/9pHXZwU2O9WxWLHGOzyn3wNS5wIS2X34s6lomHibOJ8pQzVwuB8boJlBiIuy2joEcrKlKMx6MWkFQADNh01OSDl4gWi90vsUCIPDqsLn82fXUFjhMg2ZTUJLeUXS9/GEfLCdd8hiuQabZ6gPON7Uij5L3m3w4qkxRR1cNm7x2xWDkC7Lhv7rkWPZcaN6fOaPlE+SXqrepYab6hYA2B3K51ed/8QxAwhJ/9iDQv+rhb+u7YC38PEu4BCD4um+qk2cZP+XTGgdQX/hPQeVPsb7r8I1tOX5hg1lKV65BVMckMapP9++Yqx
 /iRqAIen
 jqzIkedDgwOpFgKWsek9+btgzSupTvAs64VTKMcELb886rPa7RILLVpfGbzKeO3Wr2m5LFF4Uyq7EW1vhJqi2b/2j0avcUcnMes7LOauJt+0f3uMr8yxiXTF4SxSaB1s4Rh72ptyJ7+G8L2oihNAbEoPypu30tnS8IQp+RCFC5dysZjrLmsYbfdXFrmwOVx/Lx+nMxeVkJzYOEHl1sGdMxKxeizaiCHy3zrhOC4AFqOHBz/qEtpN85H4mpmO0TwlEniLU3B22081BwmUrqR0toCIWD5nhpGDJDIrpxdKeN/yp1qQRcvuwhKOCo0+uqw4R80IQn9oLyGO/Fbc8Ig0ld2+kALXkMCCNdMnS64nq2FWytKdRCKVVt1LRSje1buXbBe6PoAP+WMm9ZyL/ublP6w9P4zTeJ3kq+MELKUYHC307xAHkfbnWjGQfzOB18JltHVRxkPRsXX6mb13S/g437tsgGGDoy8hRuBlT576FPneXwSgICb1eR05OrFuCXfc5nVJGVPbP7ozVaOii85p8ujiUDCC3o1OLNYV3YnRgHYB2L57MSEwKhvg4cZxyBo+q4Wv8vrXP8LsrQJ0LPdU68wSltTHzt+hoBJMDKZQqmbmhvJLckU/Hc0/m3d6/L4tKM7SiNQ5Ui9agAseS1GjU/9xsssldZwW/TO3tSTqJfG7JuwC0eiBbDLAOeGlCd80CatbAZoPJ5vC70TjGZKw1iNSSfylmKLYEm+DENDd1tamHj1oe6fJot/i32j8SvkzVPJuW6O40xQ/z2AmKCRg9WJE87ER/0QqNpHvVq72lwuGueLgGXfmxo10wV93NRf0ylI++
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 16:15:31 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   d7d405cc33d6e3eeba2d6ec8f0b595da2a5c600a
> commit: a5e62d9e00dac6f96174c397a82da30e7ae53064 [429/433] mm: switch deferred split shrinker to list_lru
> config: hexagon-defconfig (https://download.01.org/0day-ci/archive/20260528/202605281620.lc3rtkBm-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281620.lc3rtkBm-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605281620.lc3rtkBm-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> mm/swap_state.c:468:19: error: call to undeclared function 'folio_memcg_alloc_deferred'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      468 |         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>          |                          ^
>    1 error generated.

Thanks.  How does this look?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-switch-deferred-split-shrinker-to-list_lru-fix
Date: Thu May 28 03:12:45 PM PDT 2026

fix build with CONFIG_TRANSPARENT_HUGEPAGE=n

| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605281620.lc3rtkBm-lkp@intel.com/
Link: https://lore.kernel.org/202605281620.lc3rtkBm-lkp@intel.com
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/include/linux/huge_mm.h~mm-switch-deferred-split-shrinker-to-list_lru-fix
+++ a/include/linux/huge_mm.h
@@ -663,7 +663,15 @@ static inline int folio_split(struct fol
 	return -EINVAL;
 }
 
-static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
+static inline int folio_memcg_alloc_deferred(struct folio *folio)
+{
+	return 0;
+}
+
+static inline void deferred_split_folio(struct folio *folio, bool partially_mapped)
+{
+}
+
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
_


