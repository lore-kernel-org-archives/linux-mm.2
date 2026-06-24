Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C0F9CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 293DF6B008A; Wed, 24 Jun 2026 09:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2462A6B008C; Wed, 24 Jun 2026 09:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181EB6B0092; Wed, 24 Jun 2026 09:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E56C86B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:54:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FC171C27BD
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:54:47 +0000 (UTC)
X-FDA: 84914951814.29.3A2C7F8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf16.hostedemail.com (Postfix) with ESMTP id CCC8118000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:54:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fKcQYEs6;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782309285;
	b=H3Dc6LL1emNRIDgLM+G1yP49sIL/DkleeWlYu25EIaxl3Fh/3FmT9JORrgCXNAtd4U4s5z
	20v79MiQlDKBoz0ICviXlxNotkBsac1Q0hefhU2ktHZeCQwMwDRTTi1nv1YuJrlbWHyDc2
	aAn/yW6U8nIy3AhbRQpx1Ox+rVBTw1E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782309285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BORChunGwjMVHXOWkNqzep/vxyFcJs5ZopGHC5zTQy8=;
	b=DzdnlIP/zGgy4cbgMhmY61DmmUP3EUdpU83oRXPm8R8B6mK06QuYKuSSjCqkX9s+9kn7BZ
	4twn4cDg2Wzw5M5IftmKKvgf9+ONbWBGn6ESQJtJUPrRcYTzsXyrPXWhTBDpMIpNli8JQ4
	oEqXFAHFlpaksZsDeZnWbwoaaw0DCVE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fKcQYEs6;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782309284; x=1813845284;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9WPO8F+MfDL6GPhatE/1nwlxUrjLgRGJ9OdS53iuvkk=;
  b=fKcQYEs6fy0Xp33FcmityPvG/0Io10WYMCAbp/KK1YyRIVphtLtgHZ0F
   +6RyUDX96yjd22o37XNiRdalCzSnBfh7Gkx2oj6kN0QJPVs1bJCp8K+D9
   HH/Gy/W2FXD4x9to07kOXkvQKHxJIk2eWt1lRv6NOO4lgYGESDV/ynB6n
   ctZtZ0fO7VLK1msIVvXgrN4m98pevYSHvmh7beIEnsWyfGp+iCSBm2B+z
   0X8PrHjk2wIuAn7F7CSPrh7WPGl7+DQS11oBTIBveuvZXd3oTcM5ZIY++
   ZereZe61fniMU9UUqv9gpserQOd7l4fY+PVHP6K2k9QxqzXp4W6eZXYBw
   Q==;
X-CSE-ConnectionGUID: hNpjriDDSYS8eiFQS/1xxQ==
X-CSE-MsgGUID: HI2DcV6ZSemJxtZ+VF09Ew==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="100497600"
X-IronPort-AV: E=Sophos;i="6.24,222,1774335600"; 
   d="scan'208";a="100497600"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 06:54:43 -0700
X-CSE-ConnectionGUID: hW+jkOYbQOaeHqYROJEtXw==
X-CSE-MsgGUID: Dbri+AwDTMSuueYoOmjeeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,222,1774335600"; 
   d="scan'208";a="245522157"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 24 Jun 2026 06:54:40 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wcO3o-000000003Ob-35gD;
	Wed, 24 Jun 2026 13:54:36 +0000
Date: Wed, 24 Jun 2026 21:54:09 +0800
From: kernel test robot <lkp@intel.com>
To: Xuewen Wang <wangxuewen@kylinos.cn>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Xuewen Wang <wangxuewen@kylinos.cn>
Subject: Re: [PATCH v1] mm: fix data-race in folio_batch_count()
Message-ID: <202606242115.DmNPrSkD-lkp@intel.com>
References: <20260624092606.1083449-1-wangxuewen@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624092606.1083449-1-wangxuewen@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CCC8118000A
X-Stat-Signature: nhdc3d9iigxhki6hiq113phhw7ia1zts
X-HE-Tag: 1782309283-209953
X-HE-Meta: U2FsdGVkX18ZN65EnX6svJ69V0L4UxkRjOBK+hYkQGWqlaV5OTuoFPMtph3qeh/whzTtfMYu2W6NxAnSjNoeKhcFmQADqPBjh2bvhVZBxH/i+MKFcK5BWQSB5zqyNjFct22gI1Iz4n6B+iau39Gi6uOAjUIb7GLhUWIujIpVV2t9rNg/Yq9F1FNPVy69oYl8yk8qY2F/8daDgilyHkwT3WmR0srH91lMKiXLaX+MJZrpHwJU/+AvNao/YQHKcccpQOQn+oHuqGq+r+gB69ksNoSC+KTyz77otSiSkeyDFdP3jJ2vCbG9tX73wbpzoMtasgZVcouzMfnK3zd2mdKOf26YwrBA9Ljm2DV4yijVY5aoVJFal5lXwQK3fM5OnXwuMPoP1UkSkzek5rJLR/cx2gQjTWIz935/CczxQBGwOjZdcZr/7+EalseRPvGDb40vhspjSvyDs86QR6akUeO/Rr6qKYzyE+bQMCsPCFxalk3oCRUrouRciI44/enY90Vjv4Q59gUZC+VMSTpem32A7uiunIthQA4IAi5vqkoFPd2AZierMt46Rg7j+hn/1Kd7cKVvJ4m5+xjOH5f4yM+5bfvIoDQfb+RZUgbnrvmDy1EhzrpS1aw5Kb0gs28oQjRoapOGa2pCCjESpT+njW4NI8Bd4L17SkwEvfFsW1DaWika9CTmy3BJA5TGsGuL0pLKuF4zoZXXi2UVOjxsH8w+HdWkGoxkTYKWfcFN8w2N9lDtvgjnGMh1JuN4D4sobDy1qwiCuCjQHJKAS5iMAXMBG+Tvj9tdN3tooIzHJVSZCcziny+nTM+bkOypftAegeOOr1ythpZYyyG2iMjofkwMICv2xzbJl/KD6bLw+W6y6gP3xWcAQsn7b2vHgqF30mxETeXYEkAHYbIRfKDcawHINOWhDHzL4SuAKcHBOMU0LRosiCKleMNZD6ZjtegmdAgX2uXJEOOZ3mocQGk6LLH
 Dbq9RRDh
 qiVc6YJ6QHhtVSI/TZk063E1+5sgy+l/OpGtv558FyrcPlybuM5zB/bWvSDDPKr65dya6gZd7H7IOjFNxThDop81T1uiKnniXPkzV2//95fcZAJl3Ytvrht/hkP3Jnt/y529wyuI3hygzc8OF0BLX9qmk2G8kZKhwTghdBdbmzWCE9vxW+aWFpquQSYpCmVLQROU+PbCkKnLXcg10u7zrxk2oj265/UqFK9gqEZaZyICeAgDzyqD7tJkATYHXnENgnZ4vr99oH/aX/tP2xagO1MRDSB8a39ycrN371Hnz7TeapVWnuEKtgZnL2j5yg8vSRU5EPbfaprkQTS+NU5W3t2tKWSjlMYWiXRUyq+6CNBJQz5Jro9ZuNge/gipSS7Vkz7XU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Xuewen,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Xuewen-Wang/mm-fix-data-race-in-folio_batch_count/20260624-172724
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260624092606.1083449-1-wangxuewen%40kylinos.cn
patch subject: [PATCH v1] mm: fix data-race in folio_batch_count()
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20260624/202606242115.DmNPrSkD-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260624/202606242115.DmNPrSkD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606242115.DmNPrSkD-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/gpu/drm/i915/gem/i915_gem_shmem.c:6:
   include/linux/folio_batch.h: In function 'folio_batch_count':
>> include/linux/folio_batch.h:56:16: error: implicit declaration of function 'READ_ONCE' [-Wimplicit-function-declaration]
      56 |         return READ_ONCE(fbatch->nr);
         |                ^~~~~~~~~


vim +/READ_ONCE +56 include/linux/folio_batch.h

    53	
    54	static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
    55	{
  > 56		return READ_ONCE(fbatch->nr);
    57	}
    58	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

