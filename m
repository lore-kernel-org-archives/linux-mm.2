Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C964CAC58F
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 00:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84446B0008; Sat, 13 Sep 2025 20:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34EA6B000C; Sat, 13 Sep 2025 20:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94AD96B000D; Sat, 13 Sep 2025 20:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDA76B0008
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 20:06:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2192D84C36
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 00:06:32 +0000 (UTC)
X-FDA: 83885914224.27.D04937A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5F64C140007
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 00:06:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ANijnlqb;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757808390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bkLrK7TNTBnQ5aG/G7lCtz6abS8ltUAly85laBw94SM=;
	b=g3S9Rz8uHDPfQZR7lazvyEYX0MPTfSinwqtoTUIXC3A18c9xvavFdChWIbWILe7xVt3BIq
	bveupuXvkwTJIeVz5ijz96y94j7GiG4EmTtMW2NOTC8flG3LOCWKpc+OscrcnfbCUUBENs
	ZojdYRzxEiI+Zb3q6DltMeYPVTzyiAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757808390; a=rsa-sha256;
	cv=none;
	b=ceUKYC41m2outA6i1Xuepn3DEMgQwLohWOYSTPnBwG+j8ODqXWPNpKzo4etiSwZQTFTXzn
	i8TWnk/gLxZJIuElDIuBheabcgPrzsuJhDH5dnaa5cTEME7KFsLPTJapBPHrVWvHr7Lcyd
	GfkGnLxUnn1b0RfhlbTfnd0lQ5Nnl+U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ANijnlqb;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 86D30601F5;
	Sun, 14 Sep 2025 00:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16588C4CEEB;
	Sun, 14 Sep 2025 00:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757808389;
	bh=ouYjPInHOlfRxlwFI4BxmFmkWpQ2zHtUxhVB1TGP/10=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ANijnlqbF3kZ216A80p19N3GXncBRxeswY6ZgfMqOOs851s6H67Fkxcp7oLM1aO6H
	 uJ+qCk4CD19qDimwFNH3qyyum/QOZsGd0u0qBGW2GmJ9O2WTxtpc4lrRETYYYuyr1h
	 kAhi18OCxD+k4pdF4xazg4t+I5sgimC5ADY+Q1qM=
Date: Sat, 13 Sep 2025 17:06:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, Linux
 Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-unstable 39/428] include/linux/pgtable.h:235:36:
 error: expected expression before 'do'
Message-Id: <20250913170628.e76ed73413b58aef022aba3c@linux-foundation.org>
In-Reply-To: <b96ea27d-6e8a-40d9-8fa6-677cd8134363@nvidia.com>
References: <202509131255.x9EfvIGt-lkp@intel.com>
	<20250912230313.117341d5491a3145e7bcf311@linux-foundation.org>
	<b96ea27d-6e8a-40d9-8fa6-677cd8134363@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5F64C140007
X-Stat-Signature: 517n3uaucjkr8uazu5fkduqh48do1oeo
X-Rspam-User: 
X-HE-Tag: 1757808390-568755
X-HE-Meta: U2FsdGVkX1/ZaVrE5VZuZn34Gz77mv+vcVidBzE+DehKLB8ylANIPiTt07Cr15R367Pr4Gb38iwAFFN1Q64QrGlBxX7kOB42qV0aLaOGNuMJ07/XeTKh9ZTmei4EMkQOm95tXjN98lgcdMeMPmmOq9XUcbfE1jE7Cw6/pylfOv4Pq7bc1XjTsr/fstg2WULWPsOuKGIcGfZ6c7IqFWx8w4GealdCQ2CX2njHC43QOqPRQ3SS9tizfFEsLwb/1U68jilej9fXF8mKmofZJTxzUPtYmadht9fhD4QfjWnHkvg2YdW3HGTPBz9antOUijZ7cNKVKftXvLOzuD75YHRA9NOIMeHHV9G9y4deTrnmjAYfN73YXsqgnfewEEzg7f1ba+yOQe93iNqR8dSLRoF0/K7rR8rsuobJYsbbFEitlCtohtwczxH67nVZ/R+WgjPBXdr3GSWHheYdLp8hpzFa1fwUg9zQ2kSfLA7e3WzZDaQcMy/Cr6dN/blpdLtxgVFdrzUT64QoN9vjVHMKW7dAXmhPa5iW2ku5gh2Lhxj2ta5MpOL4wZVi0O4g8yEYbk2jw4DFLLQqYULjbb41jYA1O15Y0+3Fw7zxRY8N9ZE8BRjal3X0nE3Tpg6FEQdVC/x2J7ppzxev1GAT1BVbEl5ttYfNLWvSjVW3Bc6t9Y4BkCw4VzOWAxK0BCvMVvVzJlMheOGlnRTDiNmLKeMRmwnJ6ZdJP10NTX+WhpjoslWe1yqm1/wl8gDamwUBb0a/2kuztvEKg8ehJ3AtykVuRk9wMeDwqTQJsaGRPvw1saaZWs4MExCbwcTH0HLOvnD43xqprYNqW0/KKAenr0WyNYJhnMPZYh1wPggxGzcAaa8OtVfiQUz9IqhCCVXLSHmPpFZxXLRjuMjGlIcEt4zLU+nwjeD9WDABuRANbhL6bOd9nOftFW2rfMlI7cmlWFrwt0iKroXnqmZjYVx8N5Aj2Jz
 Rl9S2BM0
 ad9H9/26dr2gaxoBedzICT464dVvdrpIVqm9HZxPjCOgoUImyK9r4ajCQk/nOzC7vWb6ZjmJMjcN+dUUikh27HcTBm+UXBWikNzzRyTXOlbJBxgnOkg+BwVp+jFMhnnl7xVY8RK9IROXAnbXycOQULaHRt30er8Dgm94y83cNIgvzghu0jDw8Tq6dIYKqMWbxFkJn9cSxTgXYrSJCEs3IEMFUR+JPiUSLYTA+tAzqaHTZJhD2dJdDhA40qLinXDkyM16GH1lZnNSovrdrt0+ZYhTqdWCTHNBsEZHecp/atgdIDzyuibcYCVGIxRZjlvzpjbQiYIQd7if7BFRzzq7u48F1ATudzn4bSWISEIWwAPS9kuo6E//pz2X/iIkgP3xK1tMVbN79xmBndbrTDLn86bnBzax+R+BEPnxezJVIT2dIbx555WgNOIcI24HLEC6NKYK6qPTDzsYbp0dddRDYNGNolOjweqteHmuxgaWxCBGqbmo/v+0H8ukQFieTfdrDasMquJ6s4niaRrUvTxvVyBF0Tg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 14 Sep 2025 08:57:29 +1000 Balbir Singh <balbirs@nvidia.com> wrote:

> On 9/13/25 16:03, Andrew Morton wrote:
> > On Sat, 13 Sep 2025 12:53:27 +0800 kernel test robot <lkp@intel.com> wrote:
> > 
> >> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> >> head:   8ded915c4409a5190b1c9c57c172d62ab5534274
> >> commit: f6748cc302fdca7c486c6098f315bd4174f5c614 [39/428] kasan: Fix warnings caused by use of arch_enter_lazy_mmu_mode()
> >> config: s390-randconfig-002-20250913 (https://download.01.org/0day-ci/archive/20250913/202509131255.x9EfvIGt-lkp@intel.com/config)
> >> compiler: s390-linux-gcc (GCC) 8.5.0
> >> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250913/202509131255.x9EfvIGt-lkp@intel.com/reproduce)
> >>
> >> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> >> the same patch/commit), kindly add following tags
> >> | Reported-by: kernel test robot <lkp@intel.com>
> >> | Closes: https://lore.kernel.org/oe-kbuild-all/202509131255.x9EfvIGt-lkp@intel.com/
> >>
> >> All errors (new ones prefixed by >>):
> >>
> >>    In file included from include/linux/kasan.h:37,
> >>                     from mm/kasan/shadow.c:14:
> >>    mm/kasan/shadow.c: In function 'kasan_populate_vmalloc_pte':
> >>>> include/linux/pgtable.h:235:36: error: expected expression before 'do'
> >>     #define arch_enter_lazy_mmu_mode() do {} while (0)
> >>                                        ^~
> >>    mm/kasan/shadow.c:322:8: note: in expansion of macro 'arch_enter_lazy_mmu_mode'
> >>      (void)arch_enter_lazy_mmu_mode();
> >>            ^~~~~~~~~~~~~~~~~~~~~~~~
> >>    mm/kasan/shadow.c: In function 'kasan_depopulate_vmalloc_pte':
> >>>> include/linux/pgtable.h:235:36: error: expected expression before 'do'
> >>     #define arch_enter_lazy_mmu_mode() do {} while (0)
> >>                                     ^~
> > 
> > Huh, thanks.  Another reason why static inlines are better than macros.
> > 
> >>    mm/kasan/shadow.c:497:8: note: in expansion of macro 'arch_enter_lazy_mmu_mode'
> >>      (void)arch_enter_lazy_mmu_mode();
> >>            ^~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > You can't do that with them!
> > 
> 
> [...]
> 
> AFAICT, The issue I saw and fixed only occurs on top of 
> 
> commit 116191f326bce79aefa0ed540caade5a55fbd33f
> Author: Kevin Brodsky <kevin.brodsky@arm.com>
> Date:   Mon Sep 8 08:39:26 2025 +0100
> 
>     mm: introduce local state for lazy_mmu sections
> 
> Which changes the definition of arch_*_lazy_mmu_mode
> 
> -#define arch_enter_lazy_mmu_mode()     do {} while (0)
> -#define arch_leave_lazy_mmu_mode()     do {} while (0)
> +typedef int lazy_mmu_state_t;
> +
> +#define arch_enter_lazy_mmu_mode()     (LAZY_MMU_DEFAULT)
> +#define arch_leave_lazy_mmu_mode(state)        ((void)(state))
> 

No, this error happens on maainline + this-patch


#define arch_enter_lazy_mmu_mode()	do {} while (0)

plus

	(void)arch_enter_lazy_mmu_mode();

expands to

	(void)do {} while (0)

which is nonsensical.



In fact let's do this:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and friends to static inlines
Date: Sat Sep 13 05:03:39 PM PDT 2025

For all the usual reasons, plus a new one.  Calling

	(void)arch_enter_lazy_mmu_mode();

deservedly blows up.

Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/pgtable.h~include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines
+++ a/include/linux/pgtable.h
@@ -232,9 +232,9 @@ static inline int pmd_dirty(pmd_t pmd)
  * and the mode cannot be used in interrupt context.
  */
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
+static inline void arch_enter_lazy_mmu_mode(void) {}
+static inline void arch_leave_lazy_mmu_mode(void) {}
+static inline void arch_flush_lazy_mmu_mode(void) {}
 #endif
 
 #ifndef pte_batch_hint
_


