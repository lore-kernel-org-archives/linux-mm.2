Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5002AC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 19:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6506B0708; Fri, 14 Aug 2026 15:28:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5236B0709; Fri, 14 Aug 2026 15:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30D1B6B070A; Fri, 14 Aug 2026 15:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F286C6B0708
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:28:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 854D1C021B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:28:11 +0000 (UTC)
X-FDA: 85100860782.13.851853F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1219810000B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:28:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EwanUvhE;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786735689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nb5Jn8BO1MyJkEy11Sdc5e760mQpIvoE3uCfUx41+BU=;
	b=UeZFoFpcInmnTYRwKgcreFmq2J0QZuXZbBXBZeQS4JJZI5vy1PRMVC20atYMqq3f6kulvy
	I/CASffVVW9J06JzHJfd+biS2a1/h6mz+6En0HonJzOOpvZQVOZbzqln8tv9WQ/vjwOzNs
	cuK//8BZV8LzhoAyPDg5vk9Qb9rVyP4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EwanUvhE;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786735689;
	b=fVRdysdKbitKtKXjUlz0Cws7Hl2OlQUovsprGgtcZgR9jZ7YcQ/U2zKFQ6Gl+ywBZ6+xfs
	vucGUh3rxyO70+uHSJ3RyMyhYrNLBqbBFbUxbHUwk3eRkZYqagB7DdTtT6GSLky9/EC2gd
	xpD3kkRxL9iX+gACZ2RIc92r4dP9wEs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786735688; x=1818271688;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SSYQsbj6ZEE7A8qSrmzJSebTXjoAlcHbG+fX1kbjcus=;
  b=EwanUvhEncZ8xtYoPmpC94hzxYEYBQsZ/GmhKbZUUgS/jtY+dFltjiBZ
   A+ywF/t+P+DpITQyNHatf/GJFNdG0I0njik6yga7aLtiStSKALk2SXTFr
   q/4bh336OtMzhg1pt+O5PFJeMhiRLFq+rTxH1CG/gQq8hRcQaoVUjA+Ff
   PEVgYNQRk4+U1J93L2pU7OOlH/hW97/Mr09uaxGdBzIgLe2APBvwYcw0o
   SAZreOA9c6JL6rVfohg3YML2rhtsa6vF21irNH87chjHlg6NgWlsViGGJ
   gq3jSJ7IberCPTj/NUuLnEuOiBQZ8DeEKs67g4Ha+bqXcMui0MmpjdCYO
   g==;
X-CSE-ConnectionGUID: JAXiwnHdS5uSScyuKzyzAQ==
X-CSE-MsgGUID: kx6jKnDmS9eYpth6tebxpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="87242108"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="87242108"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 12:28:06 -0700
X-CSE-ConnectionGUID: OMexIP8XSU6gEBTmQA43ew==
X-CSE-MsgGUID: AVHscax6R4+PYxKolsurZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="260066757"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 14 Aug 2026 12:28:03 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wuxZQ-00000000Zwg-2PaZ;
	Fri, 14 Aug 2026 19:28:00 +0000
Date: Sat, 15 Aug 2026 03:27:38 +0800
From: kernel test robot <lkp@intel.com>
To: quanyeyang via B4 Relay <devnull+quanyemostima.gmail.com@kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	NeilBrown <neilb@suse.com>, "David S. Miller" <davem@davemloft.net>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com,
	quanyeyang <quanyemostima@gmail.com>
Subject: Re: [PATCH] rhashtable: use per-init-site lockdep classes for bucket
 locks
Message-ID: <202608150357.9LheVOQg-lkp@intel.com>
References: <20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1219810000B
X-Stat-Signature: t886rdtqkayw93fwx9azmuah55r8wjec
X-Rspam-User: 
X-HE-Tag: 1786735687-344931
X-HE-Meta: U2FsdGVkX18Oq8RsQ8netJSnS146pEXhchUWoSef1hIMk/SZo+h87YTeusnp07hLWSLMqhO//y0NdKckpQcCRT0ObFuo+C9zOn3WjM/m9Hnnr74N7WgqkEq6nWf5KE6wKVQEHMMzO2C3/M9RU/5aWikHB3MtwOswgTS5YvPTga163/cUtvbHkZ78mRgKwp74n5FO0vPBToGkI6yO0i0f4MxBLPtLZ4ynmZsLdREsorwn6Oaqc0ZD3gYkcs/UZqTub6JenrI5oQM4si86nJBmRl4EBbQfEcARRsIzZKBEWpOSL/OWrtkXfMawB8lFHaon12UEKfl00T7lfebZvR9QPOAFJvmMT63vunv1UlNV/FT6EZ3AtThLejr2V865Yx7mbjazuyjraqHDSmqweNNmbeZDMmFymeW629wVZ2cgFZ/Nic36PKZTBoTas2hFCnFcnXSs8MLviiV2YrnaMlCXMBzLzPdL6IsTTstJwkW1zcYeBsxXXhePMy6IFHRlh2AzANW6H2hf3d6XiB9so9DQM7bJg/F9+U6Ri6+qLN5istkUxuEdK+zN8alLV2yAnTS6XhgfAn5tGB/8u4p5gn4DvYw3SYbSflG4UGhct7GqEcD24mQl/9Pz/AQpKMfpE5XfaFJ2JVK5uUyLRpXlD+sD32Bb/X/z6HUUB5qadEdlUTMm7Yp99IY0R6BZ5qIh21oKUILkvBhIFnIlDxvlbR4THHWiUVtz8vv3m81KYtjuz5O5dCH1Ma7TRm84luwJdqDbCQwW2Ydh4dWqjLyw+0TMiKInmyssEkXb5ZTxM+IouWvepqME503yjm3lXY2RpUWG+T9MAMEEqH7E8F4dtSjfGjhbyGWTTEhOVi0UO9/7ah0oKYmMMrDik3UBZoqRP8u/JyKOkd4wn6mvSLcxyL7ya7LXcqU+dpsbjnlcqtpTFhf9EuYUhK27T+atY8DJ3u2BwjSHEZmH322u2XrwXzz
 cIkLZnVo
 AcXIKZXg+43IrcxXC6mxGFLqUTC8jcntJD+OSXjeJqFzXr6W1FAN9OfZW9UT3BgtPwE/cfQDV1UNImbUyqMWrDuA8Zo456KisbBV7HgHzfkqUNQKFvJrVnYlnP2WF1I8IHkSbIx7Gwy2rZpw/+R2si40a02Ldh0/twFKdW+Rc5wjFwJVKgv0/bOiS+mxWhYFxcb/Sr20KtPht2QcVowlVJ9njxiwINzT/JBHLnKM/wpvnIoxa2ntMxLmA/4ov6ggHJCR964asVXHeS+VFFXvSHOs+GTmtmnKSvnFuXeAwHIo45F7Bvfxh+8xYGt2SLsxxYu67rYKEkDiPEu/NDqajjqqOGPEB13YhNoaLqA/ReRW+5z7g7Ecj2UCihiq+9PaBD4N3vblsscfhLN/7CThxvpi7/6hq9Wmxdaqgnu8UTLmao5DE7JWBzwYj0LzFoxQPi5u7xDFACpI5JQabvhliMLt+aDWMYmhIYihRnjUi2S3zxjqDBQI9VJUiCpwn3dGgkmLsAvlRUQYJA2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi quanyeyang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 0131b508c0e2489eac6e121135988f6eeb716f19]

url:    https://github.com/intel-lab-lkp/linux/commits/quanyeyang-via-B4-Relay/rhashtable-use-per-init-site-lockdep-classes-for-bucket-locks/20260815-014140
base:   0131b508c0e2489eac6e121135988f6eeb716f19
patch link:    https://lore.kernel.org/r/20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c%40gmail.com
patch subject: [PATCH] rhashtable: use per-init-site lockdep classes for bucket locks
config: alpha-allmodconfig (https://download.01.org/0day-ci/archive/20260815/202608150357.9LheVOQg-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260815/202608150357.9LheVOQg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608150357.9LheVOQg-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: lib/rhashtable.c:1170 function parameter 'mutex_key' not described in '__rhashtable_init'
>> Warning: lib/rhashtable.c:1170 function parameter 'bucket_key' not described in '__rhashtable_init'
   Warning: lib/rhashtable.c:1170 expecting prototype for rhashtable_init(). Prototype was for __rhashtable_init() instead
>> Warning: lib/rhashtable.c:1247 function parameter 'mutex_key' not described in '__rhltable_init'
>> Warning: lib/rhashtable.c:1247 function parameter 'bucket_key' not described in '__rhltable_init'
   Warning: lib/rhashtable.c:1247 expecting prototype for rhltable_init(). Prototype was for __rhltable_init() instead

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

