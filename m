Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87CFCEE6B66
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 23:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1AF6B0089; Fri,  6 Feb 2026 18:34:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85EF16B0092; Fri,  6 Feb 2026 18:34:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75E2C6B0093; Fri,  6 Feb 2026 18:34:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67F076B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:34:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18EB81A0354
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:34:28 +0000 (UTC)
X-FDA: 84415638216.01.2A8EAD8
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 152B780002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:34:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UfeA1jSy;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770420866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/95J67fXqSWtWPcMB6TuDp3d6eu7CAewNBLcn/8dhY=;
	b=BuMSI+uxrce7RnzW2YdQ5CW2dz/Y/08gDSae76MkOgT1sGvU3GNYSoUw6rNCqt3yeHjapp
	pgYM7SIZ2gGGXwftoqWh188SrxvAupfOXRBMP+nh4CIamFaTcrM8wH+EjWOIpNeEOl+/+e
	wcaGWB5D+xl+dvg4mgpNF9j9k6HeurU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UfeA1jSy;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770420866; a=rsa-sha256;
	cv=none;
	b=DeibMzGCN/tuIXjhKNO6a1273naDo4MjMWWiP5HajUqXvvcgAJaCP0CPLJmL1l6RfVdKOf
	HSqPCUI8/9dIn6dUyvcjuwIBir0VBe+l04BupFxq4rie+Y5Q0V/IdllwDnRolauV3PKeTt
	wQZS/0oB2YaQvZ8V7gbk7Nc1u1V/lTw=
Date: Fri, 6 Feb 2026 15:34:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770420863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A/95J67fXqSWtWPcMB6TuDp3d6eu7CAewNBLcn/8dhY=;
	b=UfeA1jSyV+OqIfwBh0CAxmexGOP9K7hGF9UiD7EqHITc68VhZE8JBYzCyE3Z1tXBTGs9m+
	tPTk66jat6OESVZQjq6oEK+ewBXmonqtlxK8P/fZm/Tr5lhiz/6l+2FHg7++359oEQDrVD
	V37sykWOiA8qulJHzJAyipLGHm06vRk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: kernel test robot <lkp@intel.com>, hannes@cmpxchg.org, 
	hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, 
	oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 24/31] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
Message-ID: <aYZ6PxkkLj3aNGuk@linux.dev>
References: <e27edb311dda624751cb41860237f290de8c16ae.1770279888.git.zhengqi.arch@bytedance.com>
 <202602052203.U8hxsh2N-lkp@intel.com>
 <cbb1ba53-134b-487f-87c0-85ca4791773e@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbb1ba53-134b-487f-87c0-85ca4791773e@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 152B780002
X-Stat-Signature: jfdu79i6iy4xksg385gkxi3uw8dnefn9
X-Rspam-User: 
X-HE-Tag: 1770420865-830701
X-HE-Meta: U2FsdGVkX1+KY+e6p6tTf76FLWc2ZpvGxHZRYXzi6Ra4jeo/cGuV/741HS7oNKUuKWdrfPgMW1ub9m6qIzHTem/PlC0M83MTXeLQdnSZ7lu8p1c67tcL9A5NoVdXDY85EZw2oeCuOh34t36SsHVIKeOLQeaChqDiEdFRSjv42n2OvlQnxoA6VdTM9O9J71FZEkSSZikUW/yCgzyfyvHzHfWfc4krMvksPwFYScNN5b/T8sY5wY/7b40EEze1ZesIWGZ8iiQOVcGqMe+hEN7TcH9sZlHgiaWHQvwu8tENL/jkGgibhxDtWxem3xmhjffsnENSxsbQGB3IQ3gmAMuqJSpnbmzct820jftsw7E/u04MxMcqL3wpkFcRSxjztQQN4GGDwlCSqHvcXB0wY0+tsMvGG4FOO4b01Fim2QAovhpujhaqXREBveY9y5EgjdIQaOHgRD96CR9sjI5TpdIgIxm2ZikS9CfAs9Su3IW2i0K01HLEa4mmr2qPvo//YSSrRYbpIklX7OCQGODTJ9nv8NrtLbOJGEykJhEYBElEnwQkxfCBDRvWJnj9Ti+5ayQ8teCZm2EnkIp39E0Kh8d9AXNyW4lJ42PYX/N3bM7zsz5icQq7Ao+ANGOo1KmGa8egW9Z9HCOSDYGR4i7VBynQKqbOF0ygwkKun3mt/R6AFcqZ4LkDuZADtc0olfjOkogesgoBfPDpcxq3IqgcMkrGy/FF9PWobbvM///pluacoNOe02PuB8JxShHin7d4hFIHmdesm6n6o7bls8Bas4cVqAkwOIb/5JE2JONBw1JaByiIwkbJTohSGAYxuwtkziqYeiXFjmzRs06N5MgaO7YdltSxjKPgMPuI2kgUY/CSWXhmCRMorcRzxHFOrRhDEQBGTPzNb9SP4BsTCROIV4/ej2YyTdgauKZbeFFFLKlSdJhuZ1Uyp2izmKnT/3mciKxOhG3mg1QhqQBoCFa54J7
 /lOUN9wK
 +V/he1lC3Oar/h1SfK1qOcC1L8fbYtBE/O3ZVVFhfZqFKC3SzuzxKC5QqJiPn+RGN1s6cbrbYf3X6esZdYPkwr0Bf1QPuZ0HFqlur9VTOhS6O5b+ml/ijpCj4P48LwcKEM35CLxYCPmUBuF5Np6W/8M2/nDlhxrWNn65ogPBd6lIICs2VmCBpI3eO51nqFdDhntzaBbE3ETkQRW+EqjdrReNPoOnC1J4FdxZ45m7CAozDq18RQKytmi1WQqxDUrUr0Btxq2wmuBePa9js43ASorEKuuJ0Z393drRigYmfPgt1JJ+19rcmLsolF6SK7xOpwMCAr4WKTioUvpGXxwS73xPmOmQ0rrMnubkb4f0HihcjJk/vKLyvn9BChNFYQFlXB2syt9qrA2hneeo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 02:13:32PM +0800, Qi Zheng wrote:
> 
> 
> On 2/5/26 11:02 PM, kernel test robot wrote:
> > Hi Qi,
> > 
> > kernel test robot noticed the following build errors:
> > 
> > [auto build test ERROR on next-20260204]
> > [cannot apply to akpm-mm/mm-everything brauner-vfs/vfs.all trace/for-next tj-cgroup/for-next linus/master dennis-percpu/for-next v6.19-rc8 v6.19-rc7 v6.19-rc6 v6.19-rc8]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Qi-Zheng/mm-memcontrol-remove-dead-code-of-checking-parent-memory-cgroup/20260205-170812
> > base:   next-20260204
> > patch link:    https://lore.kernel.org/r/e27edb311dda624751cb41860237f290de8c16ae.1770279888.git.zhengqi.arch%40bytedance.com
> > patch subject: [PATCH v4 24/31] mm: memcontrol: prepare for reparenting LRU pages for lruvec lock
> > config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260205/202602052203.U8hxsh2N-lkp@intel.com/config)
> > compiler: nios2-linux-gcc (GCC) 11.5.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260205/202602052203.U8hxsh2N-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202602052203.U8hxsh2N-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >     nios2-linux-ld: mm/swap.o: in function `__page_cache_release.part.0':
> >     swap.c:(.text+0x4c): undefined reference to `lruvec_unlock_irqrestore'
> > > > swap.c:(.text+0x4c): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
> >     nios2-linux-ld: mm/swap.o: in function `__folio_put':
> >     swap.c:(.text+0x2ac): undefined reference to `lruvec_unlock_irqrestore'
> >     swap.c:(.text+0x2ac): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
> >     nios2-linux-ld: mm/swap.o: in function `folios_put_refs':
> >     swap.c:(.text+0x384): undefined reference to `lruvec_unlock_irqrestore'
> >     swap.c:(.text+0x384): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
> >     nios2-linux-ld: mm/swap.o: in function `folio_batch_move_lru':
> >     swap.c:(.text+0x4ac): undefined reference to `lruvec_unlock_irqrestore'
> >     swap.c:(.text+0x4ac): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
> > > > nios2-linux-ld: swap.c:(.text+0x50c): undefined reference to `lruvec_unlock_irqrestore'
> >     swap.c:(.text+0x50c): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
> >     nios2-linux-ld: mm/swap.o: in function `folio_activate':
> >     swap.c:(.text+0x21d8): undefined reference to `lruvec_unlock_irq'
> > > > swap.c:(.text+0x21d8): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
> >     nios2-linux-ld: mm/vmscan.o: in function `move_folios_to_lru':
> >     vmscan.c:(.text+0xa4c): undefined reference to `lruvec_unlock_irq'
> > > > vmscan.c:(.text+0xa4c): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
> > > > nios2-linux-ld: vmscan.c:(.text+0xaa4): undefined reference to `lruvec_unlock_irq'
> >     vmscan.c:(.text+0xaa4): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
> >     nios2-linux-ld: vmscan.c:(.text+0xcac): undefined reference to `lruvec_unlock_irq'
> >     vmscan.c:(.text+0xcac): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
> >     nios2-linux-ld: vmscan.c:(.text+0xd8c): undefined reference to `lruvec_unlock_irq'
> >     vmscan.c:(.text+0xd8c): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
> >     nios2-linux-ld: mm/vmscan.o: in function `shrink_active_list':
> >     vmscan.c:(.text+0x11e0): undefined reference to `lruvec_lock_irq'
> >     vmscan.c:(.text+0x11e0): additional relocation overflows omitted from the output
> >     nios2-linux-ld: vmscan.c:(.text+0x12a0): undefined reference to `lruvec_unlock_irq'
> > > > nios2-linux-ld: vmscan.c:(.text+0x144c): undefined reference to `lruvec_lock_irq'
> >     nios2-linux-ld: mm/vmscan.o: in function `check_move_unevictable_folios':
> >     vmscan.c:(.text+0x15d4): undefined reference to `lruvec_unlock_irq'
> >     nios2-linux-ld: vmscan.c:(.text+0x1958): undefined reference to `lruvec_unlock_irq'
> >     nios2-linux-ld: mm/vmscan.o: in function `shrink_inactive_list':
> >     vmscan.c:(.text+0x2f8c): undefined reference to `lruvec_lock_irq'
> >     nios2-linux-ld: vmscan.c:(.text+0x307c): undefined reference to `lruvec_unlock_irq'
> >     nios2-linux-ld: vmscan.c:(.text+0x31dc): undefined reference to `lruvec_lock_irq'
> >     nios2-linux-ld: mm/vmscan.o: in function `folio_isolate_lru':
> >     vmscan.c:(.text+0x48a4): undefined reference to `lruvec_unlock_irq'
> >     nios2-linux-ld: mm/mlock.o: in function `__munlock_folio':
> >     mlock.c:(.text+0x968): undefined reference to `lruvec_unlock_irq'
> >     nios2-linux-ld: mm/mlock.o: in function `__mlock_folio':
> >     mlock.c:(.text+0xe5c): undefined reference to `lruvec_unlock_irq'
> >     nios2-linux-ld: mm/mlock.o: in function `mlock_folio_batch.constprop.0':
> >     mlock.c:(.text+0x158c): undefined reference to `lruvec_unlock_irq'
> > > > nios2-linux-ld: mlock.c:(.text+0x1808): undefined reference to `lruvec_unlock_irq'
> 
> Ouch, I move lruvec_lock_irq() and its firends to memcontrol.c to fix
> the compilation errors related to __acquires/__releases, but I forgot
> that memcontrol.c will only be compiled under CONFIG_MEMCG.
> 
> Hi Shakeel, for simplicity, perhaps keeping lruvec_lock_irq() and its
> firends in memcontrol.h and drop __acquires/__releases would be a
> better option?

Yes, let's proceed with that for now. We can always improve this later.


