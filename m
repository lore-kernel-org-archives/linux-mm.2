Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B37D1CDC6
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 10:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400686B0005; Sun,  7 Dec 2025 05:17:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7D16B0006; Sun,  7 Dec 2025 05:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314656B0008; Sun,  7 Dec 2025 05:17:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 207F96B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 05:17:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7086A5AD32
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 10:17:43 +0000 (UTC)
X-FDA: 84192273606.29.E5D0B5D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf30.hostedemail.com (Postfix) with ESMTP id CEF6F80007
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 10:17:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=e0Ag1vWK;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765102661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/FsuuJCcZoCb22S9JB86X0uGzLpM2EDTQg6Y65RI0s=;
	b=OpV58XhzLlvskrjnXtdXUV0OqVSc14IGELcIsKxiJrSqh3knj7TfBTXf9FXYxCKh2IslMx
	Cz1H7+VfFkZIEM4kSlcaiLq0bcQ5zQlDflQJ5XuqEFTkFehhjte0+Gf/xXa51fMq2TTIU4
	YIVplizhT7WPL75J+xXVUSVLbh57tIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765102661; a=rsa-sha256;
	cv=none;
	b=gy+kpdomi6bwjs17OTrJ6F1eF2Mxfjj/HybsyXxU2ta0pIGAEeZ8fsZuE+XCBjj41l0kB3
	r1KS/GfSu8H9syQx3djIYbcm7eqzjVckbcQ9YSKCY7mNKZs+X//DOSrSUfnXHlGzNLBptN
	481rLLIZmSNxW4CPTq81zJdLJpINTEg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=e0Ag1vWK;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765102661; x=1796638661;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4OTCbyhf1L0NfU0vkTZn3R2TLNYI5fcz4Hk48AVEa4E=;
  b=e0Ag1vWKNRFtUJZVkMIzW0lvRYqfgQS8keDGOkf6bSuGWF1Z65mr4uK7
   oOIjDUuE0N9Tk75Y4zM5ZMP6AF3Gc6Ox7E8lFUMuQ/ysLx3lLyyFMingR
   2p6Qa3BR3wBV82bEFiMtB2c/vfXw1Q4oNpXr5Yp1j5KL1EPHLJKk8vIm0
   VjgED6c+kFTD7T+fd+NREEdNsV63hu7T7XMCK1qLnZf7AWsmWm1hJasRU
   /zfE+6NHuZf4fq5GNKD3b7j/OtwSOuOR2RiaoJ2/DeN8Sl6nij+wI8SDG
   g+IezRT70szyhj5aKzp1gPp13mnP/oa+h2fFbmnkj2tMHOyBlOvBbmiLi
   Q==;
X-CSE-ConnectionGUID: Dcw5kQ15SbefBuz1kQzYkg==
X-CSE-MsgGUID: wWi74U1WRiW72ECYYXTi1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11634"; a="67109552"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="67109552"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2025 02:17:39 -0800
X-CSE-ConnectionGUID: 3NrRWvoXSoeo1ZFpbg7u6w==
X-CSE-MsgGUID: bPLbiwQdRHiVnvJBbk6kVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="226345264"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 07 Dec 2025 02:17:37 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSBpe-00000000JBd-01z4;
	Sun, 07 Dec 2025 10:17:34 +0000
Date: Sun, 7 Dec 2025 18:16:37 +0800
From: kernel test robot <lkp@intel.com>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: Re: [PATCH] mm/memory_hotplug: Cache auto_movable stats to optimize
 online check
Message-ID: <202512071758.SKaL9BlQ-lkp@intel.com>
References: <20251206212507.135503-1-swarajgaikwad1925@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206212507.135503-1-swarajgaikwad1925@gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CEF6F80007
X-Stat-Signature: rnndq9f3wdrsjszp79mqgfbux8ccniss
X-Rspam-User: 
X-HE-Tag: 1765102660-896226
X-HE-Meta: U2FsdGVkX19duy+tE4xWOPfOThocNe9ysMjn0rlE8MSrTh06iO4hwGXd5Pq748iYVoyZYzyuIIc+2856qXzVNDxvT6C6wty/UdpDFTVOZP/1zv9Ha3HWZiWz+egq4ZTRgAKJwkhAnwyiLy2n8BoLYGAYfPxVyQTVxuK63wCPcnN+z4hhvayrulp8bQQbuLXm5uvqjuUxmL+zTHn8iC20SN39u2AV5wZ1VRYcTc5blzGYOVHboPH7ncFkpoP09w+K7mcdyenwsCh44M7wwrK1EB+w/AzCgqkSjCZ4ucEWiH6X2QZN66X1aZPGQM2mWSYdSHpON2D/yn87i7HJUy/1C8HV6XoNMqcVoX+uWCJP9HHFh+MOUfjlzeDEA+6stGJEnkE7baHfk+sqyR7CTkrDS1hRoWfJrRsPXlAmcm7pHtzfv4d7/rlNOlPYRUqeGtVgAicYGn6xylG9y391q3m7/AuTQAZ/VXdTekcG4AkS74QvnIfzTdfTlv4WImy/L8V6tnrc0VQ+bBtm1xIuM4+Iqt9tKkoM+spl/cBCrHS8onjnTBvXsKvQAnur9RJJ0cAs17QwJxKzD4o+3JFB11dC0TJTlnU7zXAHeomDuhqbv99+LkppwXWNgtAxyee2Iw43BcbrbFusmOrQFWk+Qz2LvXcRB1mDWjEb4IbTqiSbRT6xppbGy2L5UZkdEpfjm5ljKkR1OUMxG0iLXAaoxEItUml1sa+WFNPqFkTrx1xxs0NtK1sxUGxzak4Rl9dZbT0PIYSRbyMtVqFuoAYXR+sTnEv+XUCunRwAhWGSnZ6ytu9T30pZV9du9LCkQq2Rmx9QT7jxqgxnioovnNpxqRDFBWkV69GJ+pXaqHxb+v15HEuRmzFRHlt02eNattu0dpn1iyxSOINmYUbO6ikvqrGbt+knmfPnZEgpvpN/x6RLGmJZa25Rt+37I0BasQyxAs202zmblM9V1Pn+hGAHIyw
 tp+aVyYQ
 jmmjmbZ2mkPaW34sc1zzLSGOig7kNEQCk8RfyItlYcK0XnuJnQDT8PENVzZZ6y/TuFlzcNuSHniKXtQXfp4h6ZYghNRP5NLO5+A3Hvm1CuwNNcAOfC6OGVYm+z5HMdaexC1DF5iNjiKOlBj2bqYMbtVQDARnkI6dbjDHQLIqUiM/TaNrsB9IhrCexDCHaNGQEzLVIdrD2xeq1wSi+4Y2OR7Oe2+UP7tEZobh/QQkEmqSFN+g+w9ED7V+J27UG4b+0bW6PYBV109jE9SIAf+N6WgPmYl5bq/T3dIktq9yYChZVb7eY3sd9J73yAfGzvd7VpD6rcV9B9p8xkOry5E8JeG1EmQ9CW/BVW76O4maQhddB9sDzRftD7yYD85Gqt5kVf8BP6kcd6fuaobIvLjYvAznq7Jn/gaG1kXFeRCXX8t7Mc8oIVgupNG9kJOpVbeR+J//ePPEbVHS0p2vNfgZbdFrh6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Swaraj,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 3cfeff1d2304237b1c14628d695a6df44daff48f]

url:    https://github.com/intel-lab-lkp/linux/commits/Swaraj-Gaikwad/mm-memory_hotplug-Cache-auto_movable-stats-to-optimize-online-check/20251206-235737
base:   3cfeff1d2304237b1c14628d695a6df44daff48f
patch link:    https://lore.kernel.org/r/20251206212507.135503-1-swarajgaikwad1925%40gmail.com
patch subject: [PATCH] mm/memory_hotplug: Cache auto_movable stats to optimize online check
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251207/202512071758.SKaL9BlQ-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251207/202512071758.SKaL9BlQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512071758.SKaL9BlQ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/memory_hotplug.c:53:34: warning: tentative definition of variable with internal linkage has incomplete non-array type 'struct auto_movable_stats' [-Wtentative-definition-incomplete-type]
      53 | static struct auto_movable_stats global_auto_movable_stats;
         |                                  ^
   mm/memory_hotplug.c:53:15: note: forward declaration of 'struct auto_movable_stats'
      53 | static struct auto_movable_stats global_auto_movable_stats;
         |               ^
   1 warning generated.


vim +53 mm/memory_hotplug.c

    52	
  > 53	static struct auto_movable_stats global_auto_movable_stats;
    54	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

