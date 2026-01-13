Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207F0D30CDB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 23:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 538DF6B0088; Tue, 13 Jan 2026 18:00:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0A36B0089; Tue, 13 Jan 2026 18:00:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392666B008A; Tue, 13 Jan 2026 18:00:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27D0D6B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:00:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C67AD58370
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:00:56 +0000 (UTC)
X-FDA: 84328462512.21.1E89804
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf24.hostedemail.com (Postfix) with ESMTP id E1CB318001E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:00:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KicXc1Jt;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768345254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ph17RAhls0QzxienN/47Ko1qZYbpkO6egcHlTNcUJK0=;
	b=chcBid8HDr0WBZoaTs9XHOngYK3asEP9UarBFSO+c3GVRfmp5eJuqFlk6P/zCKPYbkMRp1
	Df4bY5Fvq77JHDBAChRbzRqMvOJbl2tO1s2NQJ1QGn9tGxJGkD9BZpJPvBwfPlWvRuKORB
	C3naii9uS3VyMVrfFvT6ctap7ZQxWM8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KicXc1Jt;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768345254; a=rsa-sha256;
	cv=none;
	b=nDwUpR8PBYTxZ7BMWWNaiU+pN+44EveSToxbb6tAOMgZp2suihN3/olWt8yFPRjy5eesRZ
	/dml8nXfRGth04c2hrtZ0Fw7L2Ac4bOGg2jzIOFY7F79XRhdTxUmwyWL42gcMA3nysvlfr
	mNiz8p6yPQb8j/VyqENdGrgpEqZ51DQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768345254; x=1799881254;
  h=date:from:to:cc:subject:message-id;
  bh=/w1uwaUGJ02kmN6Edi+GVSlxzkTVq1B9zz0xvjg+xVw=;
  b=KicXc1JtoQ7HlvHQp4WC6yW02pMb1TEDnXsSTuYjIcjLMy048wT0ArW9
   Ol6hwoLjLcErn1Xp0puuwBgcyRlG2qY0WB8TZHyVPaISssR0hdWiC4gSq
   nu0G5Ae9XeFK8sS3za6qZPjoRwDXr025R17/Cod4Q2e3XfXDtWlsjOjns
   Oq7HE6auaxFOhJvZBE/nuWWV2ByTRMBGc4bCmeHZgB9i7UFCURjTsfa6X
   19HvPrJ43QdpbBIr5wb7uxvu7LnOeCzq9vV0ZqQjs9i0vphrt88tZiyuq
   +SmzigVQQis8MI/VrwCTKA4Cq7ShAwVN6VXtXNP1xAVvukFV3FWtvX8d8
   A==;
X-CSE-ConnectionGUID: bRX3GTuwTTCS+pY8GtxiLw==
X-CSE-MsgGUID: H1T1TEpBRCmyeNLhZFUyLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="92310895"
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="92310895"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 15:00:52 -0800
X-CSE-ConnectionGUID: UincIv1zSg6nz+zfLHdQ2A==
X-CSE-MsgGUID: lX7U5I5LRningC0siRgpQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="204399098"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 13 Jan 2026 15:00:51 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfnNY-00000000FT2-1h5l;
	Tue, 13 Jan 2026 23:00:48 +0000
Date: Wed, 14 Jan 2026 07:00:18 +0800
From: kernel test robot <lkp@intel.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
 Vlastimil Babka <vbabka@suse.cz>
Subject: [vbabka-slab:slab/for-7.0/obj_metadata 9/10] Warning:
 mm/slub.c:7013 function parameter 'objp' not described in 'ksize'
Message-ID: <202601140605.GNpnpgLF-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: wm79nc4gho6bymxfng7bw8zykz47n6ih
X-Rspamd-Queue-Id: E1CB318001E
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768345253-297375
X-HE-Meta: U2FsdGVkX18RHzQ6um0OcAfyNKE3Yy0UraRso1K863xBkmckVUAws4vYIuQE/biisMI1z7y5qIdXbnX8JTIegp/5G6i+b0+mNqbbdxBTtBWk2wzXeE0YR+f/rnJHJgWfK/c9Z3wQr7DBlZJbKy/U/Y7cG7ZLgYPvLip5yhUjgK/cid12uTrMQFPH4EaMSrHvzLPOEm1t69T8ra13zmIvBpmRdkrezUZMoVe7YpahoeCplQqWCh1h8NOhJYXvOB2SIWMTpsJWeTzD+9HOgRfN2WYFXb1PV044gZBztsFemzKiLGVZYpDr8tNfpP5wwKsE3uiOYu82xIxkyGzFdxPGBgTYkDQhvWB/XTtXLfB3+Rxz3tnoUUU2Dg3TBqq84UIWKzYosF6YPIAuaZX3w6sjUfACs/36adIzKb2Z7Pw2BGp3xdY7pVcQvJ9YrpAJ9Z7OppYmBCI+NHVTwDF3LH6/f8+0hMz7YyamPyz2dI3ylpdJU+G35yTccSTcR3bfmg7sT6q/awH6oYfNSep5YpHy5n6sIaTNAVvyF2kNKnrmYs3GZ7YlZ4caGI1bRCdRx5/OgLEDfVja3E1gRc9PS9Djfc3gV6QUZ6mKKjxuOUIHpkMYMy1adj84KZ97bG5hbefyEDDcOtZGBbyG2uFKgy2uTHIJvAd2TYVkKqHNJ16ff4rmqCBxQW4JWRmngJtsRULQpwg1f/GobbsvzMxwyp5/rDEOXDsC+HGYNO47fs2rtb0O0ZoA/aIayID0cB7F8SEN4WDcbKnVYhghamCUzlcJOyZ3828kwU00etAppMCw6lPsZB2k4CHGgyU2mcTfZOq+F6AM3H8nEwMLikCehqKyUnAgIfC3KA29/zajh+GRyXOW13fNm8BioVoXUg7wiVQfl0yRgARMukwawTXASvAwkFObN8y7GAd/dBpRhfwXHGU3MVqfs09claHTvug7ZdbFasiEcBoIZMCVBx7exrQ
 LzT3ab96
 PILrcSlnF3JeyBo116f00dgGYDNQ0Ykb2m4FqqS7UfV89vzZpZblCQsBpH5HeShdbOxPxfXpuv4Zcjqoo77uhay5huiR723GQ8EQ4kJ2QEMEyYbxfqya0MmmF2LjhoCoOgD6WmxFPKAkWK84Cw/7+OgvvkUVq6BJdjbFLe9ltXqk/pPoi7EvBpBdz1y3p0Vj3d7/ur60j7MHd8Vf2SJcH6afjUbXnhloJF3ngT2+WK99+ox2X/vfB39Tqcw6XMri2aoMMgI8VjKQ+i2se09+q2tkH8s/2ZLUuR1qe/Hlleidyyvp7wb7HUQSYLclx81vyrMo568cIkqdrGzjshE2d6WZPe3YXW6/Cxyo4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git slab/for-7.0/obj_metadata
head:   a4e5702b7bb846cf50d2917cadf2289c25720812
commit: 1e8eb4117f27366855b192104098330a2f290f26 [9/10] mm/slab: move [__]ksize and slab_ksize() to mm/slub.c
config: x86_64-rhel-9.4-bpf (https://download.01.org/0day-ci/archive/20260114/202601140605.GNpnpgLF-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140605.GNpnpgLF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601140605.GNpnpgLF-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: mm/slub.c:7013 function parameter 'objp' not described in 'ksize'
>> Warning: mm/slub.c:7013 function parameter 'objp' not described in 'ksize'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

