Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 777F5CE7B0A
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C09A28E002D; Fri, 14 Nov 2025 14:18:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE1BE8E0023; Fri, 14 Nov 2025 14:18:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8788E002D; Fri, 14 Nov 2025 14:18:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BFDE8E0023
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:18:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 426E9C04BF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:18:25 +0000 (UTC)
X-FDA: 84110173770.29.A89BBCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7CDA640018
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:18:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jy0Sphxk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763147903; a=rsa-sha256;
	cv=none;
	b=uDq9qbw/f/9Ul314lbY8hXHJdcApE3bn3zvHmIYrmGJ7g4cYAZ/OJ/XWOSptiIKipe02dB
	Frfk4OFN5AaqbrgzJEVAIvuxAnGxqaF3BYxZPT4emaF812iqI1yRZ81LfEE4LIzbEVnWl8
	f69J7UadvBP2YrxEk/keE2G4QnBLa9w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jy0Sphxk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763147903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLyi/+2zqDnVdY9Cq47xGNcqDCx9T5B3TdTVzF1jVRQ=;
	b=T6ZTOl/qZgqcu5p2Wgs8dzmaENfqGvifab0vfp3Retv308bnykf29j/vI3/BUiYypB44wD
	av0W0G4glKtk3MGnM9TV0RkPUP/7VCPo247sOWtbouZuXH2Xr5GYF8HF5zLeSPzinJA3XD
	6QXceRwxpE06zb0cgXJQLfMpQbf0rHg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CEB943C7B;
	Fri, 14 Nov 2025 19:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED921C116B1;
	Fri, 14 Nov 2025 19:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763147902;
	bh=q1olEHlGpuigXtFzJVBaSoMshU+v/j0ueFTcAUs+I9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jy0Sphxk9WR3dz6SBtNjAI3Ag2YV7/GuKr7/FFWOwTamKuZCdqFwcjOXh/hJ3+Ian
	 gArB2pLXfsGjcZhJMAGERlegHCumDDyuUoBmj1JyqZ+TcSSwkqcOWRcSjZEaHruHTr
	 HrsNXqOWkf0E1Ev/PpDXMacfc/DKQHo/itZwh/vqf5IJwgh0wYXAnbIPfEdYnlk/Og
	 UuqFZX3EZTPpv5YL1A2XaeykoteoPNQk+uMRFmWUutc8D8qK9T0JtawgKlAsQ14Fvo
	 3H2TJ1HaqAsNxl3ZCl+UIskhnYGaee2i1MaTooLgDSAmlPF0YPtnNKeV90KBT10itb
	 baNAz/2G9utJw==
Date: Fri, 14 Nov 2025 12:18:17 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: kernel test robot <lkp@intel.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linuxppc-dev@lists.ozlabs.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [akpm-mm:mm-unstable 36/283] mm/hugetlb.c:4753:18: warning:
 implicit conversion from 'unsigned long long' to 'unsigned long' changes
 value from 17179869184 to 0
Message-ID: <20251114191817.GA1089438@ax162>
References: <202511141140.LrrRrtIv-lkp@intel.com>
 <20251114182956.GD2566209@ax162>
 <aRd69_c1pULRoKOU@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRd69_c1pULRoKOU@casper.infradead.org>
X-Rspamd-Queue-Id: 7CDA640018
X-Rspamd-Server: rspam07
X-Stat-Signature: h59ii6e5bp98qm4yytntqay8ommt9s9g
X-Rspam-User: 
X-HE-Tag: 1763147903-125156
X-HE-Meta: U2FsdGVkX19IsTNgGaKQCF3ECcFLDgCrVbmaZur2JDWBDyEf+IA4yIN/O0wqC9SNp2avlSPu1vCAFeiJuxhVCkdJmOLH5XipPJ+WbO7CHnUaZ8XjO2fh+j5tVmjy50gj15TFxJNeBCGCdxM+Be+q4BKwq3jU/g0lHIT5dwxoVEPZXKEz1GW0K6D6qVQ3QUpCyFX44kWqII0hDHITocAnv17GOn6S9tc2c/b3214hIqdrsVB7IpHuB+JDVfB3u/W0MF4HPTMgFVpwZ8ftnMEnzqp0R6PDoC7iXwkUUxaY6O9d1cjbqpFL0DpATGMm3ev9JR6e9T04TLjkXREeVcoEPraG6VtO7xtumEc+YJSlGV8nlqEs7cc1aTLJ4QcB21Ww4xBPphTjmS5oc8BQNxDPjM+v1MgKO+n5OH9o+5hwpBLTCv6+zkeQNCGl0Uy8kqH6HdcUauTuZnWIf1Vpz5WrQOQ0p+h8j0ykjWKbrywlqCAICs0lU65aLIv0YSBao8iPyCZM7yGNi2wTqwbX63LbNHSUgv5Agu4HwjEm4+YedVPBv8znwsjD2KKMmMs9ViH3D07elI4XnRhtBlGBz8EVTNzLgqbxeFO1X2SmhfWlPVBd5MAUaxVhLgwYc+rFaowQSPFHGNjbFDVmZOnn5t0l4HGqUiWSp9KYH/hH0/Qpdu6PJ7fpOfzLiHx17IJc8whdWrZtOqYhX3XZiK8YluyvDeLtij7sSkJqFgJCXnOqxl2JTrL6VNYoazFvA1GPTMM63e692pWfQ1aiJuS92xmvE/68Z8f4vWnMOvFQJOAj1XlS3CX/IJ8ZFdmN9N0JKqSaRtkeyKNw4hsbOOfgKHzv98sw8rC3ySE4MWGWjpHUqRJrP9vcsWaqqyiZbM2xPwZ5ILjPgkBbfkvUaZNga7AzQp/7RnM6x1Fu78qZ1KSfqrJDPJlVCzBQ/XOnrbBtgfslTLA85J6ZJUVW6VQBSrY
 2paZCPJv
 FL2Vj1YJbidgAZqTMDphbdV/AiCL6PlPhB6SwyWm/tM/ky9zJ4b/x+/VxgPyM8FH1dudYvcZBeX5Xhl36UEC9Ow4UsWs7WxTRBu7LDW9HDMr021rt9JslIwD+1efN7MJhZKg1z+eEdHLfznmfKbBndIYKkmNXHA836g3eAyOeelvzQcLjhPaGIdzpzYwFjbM5yTd7eEPpJSA/Fuwaz5hTFFTD5J5pn0EpVuZcIDVmlc0ZXZPueBSFItfrqkOmlnoLq3GoY054bMla5N09iWng7bD9rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 06:54:47PM +0000, Matthew Wilcox wrote:
> On Fri, Nov 14, 2025 at 11:29:56AM -0700, Nathan Chancellor wrote:
> > > >> mm/util.c:1263:16: warning: implicit conversion from 'unsigned long long' to 'unsigned long' changes value from 17179869184 to 0 [-Wconstant-conversion]
> > >     1263 |         if (ps->idx < MAX_FOLIO_NR_PAGES) {
> > >          |                       ^~~~~~~~~~~~~~~~~~
> > >    include/linux/mm.h:2104:36: note: expanded from macro 'MAX_FOLIO_NR_PAGES'
> > >     2104 | #define MAX_FOLIO_NR_PAGES      (1UL << MAX_FOLIO_ORDER)
> > >          |                                         ^~~~~~~~~~~~~~~
> > >    include/linux/mm.h:2095:36: note: expanded from macro 'MAX_FOLIO_ORDER'
> > >     2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
> > >          |                                 ~~~~~~~~~ ^~~~~~
> > >    include/linux/sizes.h:56:19: note: expanded from macro 'SZ_16G'
> > >       56 | #define SZ_16G                          _AC(0x400000000, ULL)
> > >          |                                         ^~~~~~~~~~~~~~~~~~~~~
> 
> Clearly this is a 32-bit build, since otherwise a conversion from
> "unsigned long long" to "unsigned long" is a NOP.  But 32-bit cannot
> support 16GB folios!
> 
> I say this is a bug in powerpc32's config.
> 
> #if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
> #define MAX_FOLIO_ORDER         MAX_PAGE_ORDER
> ...
> #else
> #define MAX_FOLIO_ORDER         PUD_ORDER
> 
> (PUD_ORDER is 16GB, so I think this will be what's being picked up)
> 
> but the only place the mentions ARCH_HAS_GIGANTIC_PAGE is pretty
> clearly dependent on 64bit ...
> 
> config PPC_RADIX_MMU
>         bool "Radix MMU Support"
>         depends on PPC_BOOK3S_64
>         select ARCH_HAS_GIGANTIC_PAGE
> 
> so I'm a bit stuck about how this comes to be.  Adding the PPC people
> for thoughts.

Note that the original report is against mm-unstable and flags

  https://git.kernel.org/akpm/mm/c/c3f81a41ba6f93693d208edde08ce2b0da21c645
  https://lore.kernel.org/20251112145632.508687-1-david@kernel.org/

in mm-hotfixes-unstable as the problematic change. This configuration ends up
with

  $ rg -N 'HAVE_GIGANTIC|HUGETLB|PPC_8xx' .config
  # CONFIG_CGROUP_HUGETLB is not set
  CONFIG_PPC_8xx=y
  CONFIG_HAVE_GIGANTIC_FOLIOS=y
  CONFIG_ARCH_SUPPORTS_HUGETLBFS=y
  CONFIG_HUGETLBFS=y
  CONFIG_HUGETLB_PAGE=y

  config PPC_8xx
      bool "Freescale 8xx"
      select ARCH_SUPPORTS_HUGETLBFS
      select FSL_SOC
      select PPC_KUEP
      select HAVE_ARCH_VMAP_STACK
      select HUGETLBFS

which may indicate a bug in either selecting ARCH_HAS_GIGANTIC_PAGE in
this case or the logic of HAVE_GIGANTIC_FOLIOS in that change?

Cheers,
Nathan

