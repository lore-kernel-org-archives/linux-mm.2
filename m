Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5CFDD2F352
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 17:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD7B6B0005; Tue, 13 Jan 2026 12:59:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B266B0089; Tue, 13 Jan 2026 12:59:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198966B008A; Tue, 13 Jan 2026 12:59:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05D876B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:59:40 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6CB31A0266
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:59:39 +0000 (UTC)
X-FDA: 84327703278.13.FAF8D04
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf26.hostedemail.com (Postfix) with ESMTP id 41889140005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:59:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="KpRr3/RL";
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768327177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=EUGSFjZSiyF/fyf21FKxsB74FdISWVgVYPE1wZrqS3E=;
	b=Jo4f0b35ZhMq+5alCGgqqsr+fBe0mV709QSYqg0NTvDejlH4/DYnRnpcT0slSRqEhC0N/x
	QwiQYGQzn0uoJYOBOGt5EIp0oWkvhWcC/NAs8ArJ5TdF/QtoVyjmakz+uTStlZqfrDjaLW
	+y5TjWBe5xl2c5WzKcJxEi2ehOjXZdA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768327177; a=rsa-sha256;
	cv=none;
	b=ganzgXJAwk/s2nTrD1FOCkPv8kJ649EWXRfuF3lO5TvtHHmRQxaC7+VHdkGDIoMAGnAXmL
	dWHve1KGzih8hTTfuyJy1ezY8RFdJhiRY/mslL+CSCo+cWP64Cqq7W0GeMjrkkoIfIqqsX
	vkoiISLKS4lVI4MaGr/j8QEcAbcBiJo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="KpRr3/RL";
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768327178; x=1799863178;
  h=date:from:to:cc:subject:message-id;
  bh=rhIZYEAl+JRIQvDcuAP0PNpNBp/AW54b8oE4VbiUYyE=;
  b=KpRr3/RLgg2uZMarRjVsF3yy5f+lNPGwa9jasxlTiII423ZU1/Mw0lrx
   zumTjS+Luh/Fq1mW0pK6d4s9tvWUueprCtvpSYjI5yISDectjg88rFy/0
   r+dJ8k1OZN6j19/J5bm4CNn74mH1bcKiDtQreAY9YXLJFJkuUd8Oo+VAl
   Ky1n5uvajwAJw0A0l4aKCn67KJ7eD860vVrWQMNs7wufi3M9viG+mBCgB
   688lFTVuquxCXWx25p7lBKHXXnCfmgBDGUbdRKN+X+rMltdOU83zBCnIv
   Yc9tLLK4tOMh8EK8m5j3X1BOgWKN2mgJu8wsSUJyCMOuPctXpgfoD6jrB
   g==;
X-CSE-ConnectionGUID: +Jw8RwavTTmqdHNkbI675A==
X-CSE-MsgGUID: tnsfqW/zTYaI+sCXwzw5ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="69674745"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="69674745"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 09:59:36 -0800
X-CSE-ConnectionGUID: RdTw7pP7TaiRWPvyE9g9Ug==
X-CSE-MsgGUID: V0tJ+HjBSzC+MGzaTBRt/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="235168979"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 13 Jan 2026 09:59:33 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfifz-00000000FCk-0r3R;
	Tue, 13 Jan 2026 17:59:31 +0000
Date: Wed, 14 Jan 2026 01:59:24 +0800
From: kernel test robot <lkp@intel.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Nicolas Pitre <npitre@baylibre.com>
Subject: mips64-linux-ld: div64.c:undefined reference to `__multi3'
Message-ID: <202601140146.hMLODc6v-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41889140005
X-Rspam-User: 
X-Stat-Signature: pio67jz73o3hgdbd9qk4sg5bwqgdrdz1
X-HE-Tag: 1768327177-855502
X-HE-Meta: U2FsdGVkX199BDJWb24zKWmK0OcC/By1skXMp96nCHhnxkYfvmKTbE8SxwOnTNNTxwEAwuAxGANZ8W8bEuLSYKfRUYJTcAg6dDzYABZusT9N+0V3i6/LB+2RyuUWoTzGskTyo4lRjn9lrj1Ler98HamHa/CnQnR93RTd+WJEHhlVcaSfefcQmXyoM4uasC9UNvxEJRM9n09o6/OL9R2eaC19s7TS3UJThVMBgjIbmKwYrvfoQ0vfQzXgeMaQftmByMf8ifUMl/vIQqoHzTUTliUkzyRup/93wId5C0/k2Akg6lKkt7E68uIfbbL+scvE+OSXFEhQeg1QfuotK3Rw/WpYlLAf1tOOOKS3MasTuXz1oh+nMkaMAI1wBnDB2ZpBrG+1nRO+UYt805pFfrA8/1Hu+Gy4pvZsDr6OVOkGlA6Q3+6MYEfOUV/MhfjdMkU5ShvwJ0bHAoY3B1qbgkPrveLWC+bgGTfK10QlC9ybvFqSgiKWhU6bFyA/OtXidFQKMvBuO9IIbTwCyph5SoJkwGGjpWWDPE3m2kCLk2OIlgWVuOc0K6y1XMJQszS0wpcO15Wbm9PGUiwTEBEERm1Pka85Aj1yB2AEJtAqmddUqX8eVudvipAe3WFPnoAWYb5jaRhESCpObAvZMV7abKIgi/GNvOd6LP2lGC+epg2lQ+Q2DUtTPTqSiPE5RJOzcAkPRcyzebSbGINWRCtZ8feLQ09P+LOI0ywXFVuUPgvn7CBRYOfZXiA832R7bFqresXYokdiVhW0gnMGoZ2iz95jcA4nIOJp+R2DwO62PePULjMCAIJTaiQ6QDpGDHHaiGC6vIdhV62UrzvUovpBVn+lxteXXuMB4HIwsn51hMk8qd9navp1UihpasW4biY4GMh9zhKHCS+pyHqxN3OXz1TIN35VZZ4A93TB8gqtSbx2KP1wOfJd9Sbxu7v7yK73HCUDsZKFHI0zqdtHHCIb5km
 i62E5Wug
 FLloMMjZ7BbgF2+bVJIpCtYsGbL1tZnYHdJNX5I92xMbjE9P+hXetob5dhY7kyyShwVC/8qybPaTHoMhNoHNTWP24dtBA4JnbYk80+XNW6lADtVyHflmzp1lQkXJI01nFofzrqvg4kkm7WkJphZhI28vwvw/r2sh2ymbZRbX4LpkaR7YKoDPy8yyXOMz/zPrxK8Fxy7iTvEIB9BaGcqE5jICoo8KIPnVlQY6LOe+/qjsKb5MaA+oymW8TPYZR7m9/t/zmamdqd+iTUkrcamPeaETj2OMkeofPJunk808zDpXMGkMIXGBOvkE7Q3tKGMh+kRPs+iTS8K0Q1ppK82AlUq+LvEeXgix1W4sZx2bcxp2fiQY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   b71e635feefc852405b14620a7fc58c4c80c0f73
commit: d10bb374c41e4c4dced04ae7d2fe2d782a5858a0 lib: mul_u64_u64_div_u64(): optimise the divide code
date:   8 weeks ago
config: mips-randconfig-r113-20260113 (https://download.01.org/0day-ci/archive/20260114/202601140146.hMLODc6v-lkp@intel.com/config)
compiler: mips64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140146.hMLODc6v-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601140146.hMLODc6v-lkp@intel.com/

All errors (new ones prefixed by >>):

   mips64-linux-ld: lib/math/div64.o: in function `mul_u64_add_u64_div_u64':
   div64.c:(.text+0x84): undefined reference to `__multi3'
>> mips64-linux-ld: div64.c:(.text+0x11c): undefined reference to `__multi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

