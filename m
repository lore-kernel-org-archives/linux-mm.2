Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3278BCCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 05:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670A88E000C; Thu, 13 Nov 2025 00:47:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621BF8E0003; Thu, 13 Nov 2025 00:47:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5102F8E000C; Thu, 13 Nov 2025 00:47:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4248E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:47:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E14DB4D17E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:47:34 +0000 (UTC)
X-FDA: 84104501628.17.8A7F703
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2530340002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:47:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QW1M3Roj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763012853; a=rsa-sha256;
	cv=none;
	b=mU2R2i7C61eVB6UBuH/KMWfSBqJ2CSjvpln2h0v1IRsrtDUszFgq0k+Oq/VbXC2NKS0LQ1
	UL0pUYI6ssyOWl34d7YNnqQy7J8Xx8zQX2ktJZRCCyeatB9LN2FJGmVT23AYVnFIyuZJFt
	SU+yVCdDTaOt8GSBrucHP616azlsPh8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QW1M3Roj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763012853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMIpkLf+xD1Mc0agqjkJt7aE1fhoIkeOo6UUcn6faR4=;
	b=CFHsAaNind5q26x8TpOYFTc/IZCPXkGDbYcIN/p2rKFZ5sfZGu+87/yHdsxYUL9xG48Zq+
	/s+qDpAMKsI3i8WjTOfOvsQoFXt7zxV62i1ahj0LY8fT+lnu1j7tLYCzku5jNPfYSSU+aj
	AfVJen5TDLdAqChRM9zHkXmYaD5HqZs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763012852; x=1794548852;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tYTHNNf+YGbTSSvqqxsTBUg/KkDpiG6hdbKFlnGdIzE=;
  b=QW1M3Roj/itA+usVSkGhEIvetCOsmJI8itaeHbG5bInNJ6w6Gwx0PmNa
   mMRra88CXrVXPS8t3uvRxi4Au8HnV1MhpDKDlbHgaiA1ecKeggIw188BH
   l9XT4BCh9zUufOgn5N4KuvgaWmdxtya/b+C37W3RmSLgLZd22lOOECLAI
   o94FPx0qfXBeoU7KrwbDAlRLL5nFfek8KnjkZsJBSXwIr1/8by2ZY5/LA
   IhyiQAkpUIBPlxsqZ0jG8/Woit3oX8Nc0LufvkGMqQqzOS9Z6s4R+QaqS
   VhHsQQkpX+mgQLqw+ed4l6d5exLnLQ/xR2rnuMnkOfeKNnm0ehuPH1WTY
   g==;
X-CSE-ConnectionGUID: xHvRFhSfR8+wDJsz5Q6vIw==
X-CSE-MsgGUID: PYlDFFfSQU6HwR74LAnxHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65011345"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65011345"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 21:47:30 -0800
X-CSE-ConnectionGUID: LZMRPt/QQRmtXvbcDjngVg==
X-CSE-MsgGUID: uhQmO3RJRcaWuElWg0Lv/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="189689750"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 12 Nov 2025 21:47:25 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJQB1-0004wl-2L;
	Thu, 13 Nov 2025 05:47:23 +0000
Date: Thu, 13 Nov 2025 13:46:28 +0800
From: kernel test robot <lkp@intel.com>
To: Samuel Holland <samuel.holland@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
Message-ID: <202511131118.UUi1EVXL-lkp@intel.com>
References: <20251113014656.2605447-7-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113014656.2605447-7-samuel.holland@sifive.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2530340002
X-Stat-Signature: eayeteydmou3ht3y9uq9w5uuphagngch
X-HE-Tag: 1763012851-634114
X-HE-Meta: U2FsdGVkX1/2mj481tIsRpNX0RR/QcT7HaxrPEeLFkDwF1109nvHPZVNeVRXL3GegdKUIgB2kDQm2m9ici0IS4S8p+ijwyEWKBMa1Iqa/8ycx6lCl88Is15t2M3OLYBK2MQzViicj7tA3twjbwfy/Gf/oxqBVM206qXG7jU1iB8B/SvVDthO73wI1F8goidwRiSnSAzCTAdFO3HTiv7/8ijZQITlfOC86njcdTBt5e+CN1eYg4RFaUGVgJu01xaVqLH3jEYvd1dceQNRc6FRG68l6xD2y8lNa/m2jJFzFmRj0WhH7/sF/F+3Cj/72ArsaqiaVInDPaZpi24W0NClHIbMw9yNusMn4Kg1VGrYN6K47RQudyQrcFLQ8U4424VAzXAJBAVfzyuKYFZmrysbk3UFNrA3z8j9bAUCakTU0O9agyTLgZKPwvVbIKRJX8H6rHkufqvaE38HHv7af2jLAKhUTnnbkfmXUeAFPLKd/LxNV24RpsUmk56A9vWq1Rsg5xI4QVdDTkVn/xAQNwK680+JavcsREnFXLN0609xMMCivfpxwr3n3aPUWHVia2kyCLkiHW+XOGGSIC/3YwPcPZ0kuRBZGDDZd+FdaX470Aj+ArayZravkXuP56XfJXiojWnWUQAi/2thQGnL/BOMzqOv6vySrCQHaBnv76EcSSdXGkISz4CP72pqn6BX+wUGB5hfaCe95GBZaD38B53qbssPCWcyjv1BO3vqmYf+0fg/NqnWXfgruVQ06m8cAZZRr95KpsyxwYkB+HXij7TUSZlDf/aexg7iXjwzWEY832SKpRTb9duiBc1nehzJwU7LO9itSg26baoyY21UIC5Q3uawandQRTHyNmpHo0RAJnOFr/Tp0x8f8vIvTXnNvECzNZo2/OmSol+ba9MRilL3/CYTrUU7lJBcZ9LorV6x7ktnojQu3sh/UJuHVVPgsRDtGgbCDPwA6U+LOI4sq7a
 2782kZ7d
 oPQ4qj9VjyvhX+HYpl+hladlpz+ZjtfMPisnhOjLa9+86KeZZZYJFgCxxo9PdmIHs0RrKSSDjOYv9o8a0FAo3wS3XN8MsCZqGyq9sId5xFNrofJCJnXcqTulOMl+c4MY6pzm4HNgJ5x8cuNWTKIRtNKNh+/RiCnOT1T+HVKPB6DHlhO+3yGCvB4SG2rrS8mo9g+5jLOtl8oJdZ2LVjH5VRNMZq9ec2a9n6JzSCmMUWPuzl7l4wVllX/0Thn5ChPx35phYwBcthJ3tCpDdy6HiprrGfG2Sj1EvWjzcftjJzFQmQUGfKSyqA/b/s5rIUXEr09wezovXyzmR9RaFM5OwdMybyV2cUPxwoGlpCCMIXW8+oNbCJQjgnL+3Xw+54SFoR0AU/Q0Axn+kZ7RfLmwtfeUCwgDQ7G9wBQcwhiwOsEpCut4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Samuel,

kernel test robot noticed the following build errors:

[auto build test ERROR on 24172e0d79900908cf5ebf366600616d29c9b417]

url:    https://github.com/intel-lab-lkp/linux/commits/Samuel-Holland/mm-ptdump-replace-READ_ONCE-with-standard-page-table-accessors/20251113-095117
base:   24172e0d79900908cf5ebf366600616d29c9b417
patch link:    https://lore.kernel.org/r/20251113014656.2605447-7-samuel.holland%40sifive.com
patch subject: [PATCH v3 06/22] mm: Always use page table accessor functions
config: powerpc-allnoconfig (https://download.01.org/0day-ci/archive/20251113/202511131118.UUi1EVXL-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251113/202511131118.UUi1EVXL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511131118.UUi1EVXL-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/madvise.c: In function 'guard_install_set_pte':
>> mm/madvise.c:1119:9: error: implicit declaration of function 'set_pte'; did you mean 'set_ptes'? [-Wimplicit-function-declaration]
    1119 |         set_pte(ptep, make_pte_marker(PTE_MARKER_GUARD));
         |         ^~~~~~~
         |         set_ptes


vim +1119 mm/madvise.c

  1112	
  1113	static int guard_install_set_pte(unsigned long addr, unsigned long next,
  1114					 pte_t *ptep, struct mm_walk *walk)
  1115	{
  1116		unsigned long *nr_pages = (unsigned long *)walk->private;
  1117	
  1118		/* Simply install a PTE marker, this causes segfault on access. */
> 1119		set_pte(ptep, make_pte_marker(PTE_MARKER_GUARD));
  1120		(*nr_pages)++;
  1121	
  1122		return 0;
  1123	}
  1124	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

