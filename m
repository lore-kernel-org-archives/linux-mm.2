Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9E3DCCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F7A76B025A; Mon, 19 Oct 2026 09:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A82B6B025C; Mon, 19 Oct 2026 09:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00016B025D; Mon, 19 Oct 2026 09:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF8B36B025A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:30:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 58D951C3FD6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:30:59 +0000 (UTC)
X-FDA: 85339461438.11.71E6E2A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8DACC160007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:30:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=T0k9Nac2;
	spf=pass (imf08.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792416657;
	b=djhJSJcwhLKbZIpMmxfWWWmQSA4ACqUZbKo6vXH3kdPPAGWvB/+d6uhyNDnfW0DXZypjfi
	qi+Ut0GhUN80ZnrsYFxPG84FRC/KTRi4pb98FGM6GTlSKS+pVBJ7tF1ievbnc19jNTeFQJ
	Ds4Xh1JIlv+mv8RObuFY2PqRtb2NQjo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=T0k9Nac2;
	spf=pass (imf08.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792416657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvEW6aCBL4SWxSXxBrKgFflt8U9FzSAbaJ1OEa7Q68w=;
	b=UTF/EBq9BVwjM45uKxnPEDD9r7mb9EgecAxun3VoeszBB8GEKT1vccct5rVViOVUOSxNq/
	jN/gU6kucGjmss8tVArIkG3N0OFJ7n1rnOf9+NRBHaKnia7RClIdiP6OHV3k6inl/J2vH8
	GcIbj+3MI2uNmyIZhOiRnBNBesauU3A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792416657; x=1823952657;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uIuobwNhfyVUsj1zAuU66QsxRjheSBek0U9eSTXLQYU=;
  b=T0k9Nac2BwXdRyq74Q7a3LisUonYaCQB+fB3WHhC/1yWdedoah9aEco+
   A2VyBt4UQYcDFJyd9t8bFoLO8rVnJWGRNl2qLY0ry9K0qCFTuThytK9kZ
   SE276sE5nI+tAjEziu4wounhgZaI082Vi4UJIU/u7A8eqQ4H3zynFlImR
   Vc0SF/lynJ3D59o/V13EeZEM4ef82WYa6VWpVjl1pRSICIEys+PNG/JsU
   Js8R0Sz3cblTSWAFwhNnIJcqWUwcLMc5hLlvyngP9nKyh7+rbx5jbylFo
   NiR85gr1MxMn2NMhKZ7MO4sQZ3oi1CTTLg0QPTqqj9dC9RKSghxENIuYd
   g==;
X-CSE-ConnectionGUID: THC0CO4oTKCaao92YKSC3A==
X-CSE-MsgGUID: cb2kX6WOTDaFTwcGOQp8TQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1120355"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1120355"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 06:30:55 -0700
X-CSE-ConnectionGUID: uUwqYWYTRWeci4QHBbTswg==
X-CSE-MsgGUID: luTHl8xXRl+q/Oo2j/7j3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2424760"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.209])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 06:30:54 -0700
Date: Mon, 19 Oct 2026 16:30:51 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: kernel test robot <lkp@intel.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: __efistub_cmdline.c:undefined reference to `__efistub___ashldi3'
Message-ID: <atYbiw9a0AGySXEh@ashevche-desk.local>
References: <202610191553.uvFTO4t9-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202610191553.uvFTO4t9-lkp@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8DACC160007
X-Stat-Signature: gfcuy14b4q7on4fuc3cjmjfsmbpsrj74
X-Rspam-User: 
X-HE-Tag: 1792416656-138899
X-HE-Meta: U2FsdGVkX1+PnQXXTjRg1EsNMF/bZm0KJG7bVm5Vq0CgPkzSCsE4biIZxQNBli521RUmA4VP/PrT8LykgWlw2fV7YgI2mps8Sk4Cvc0BmA3qAWM84yHJIjS+UlDr7ldENSAfKAFBoQ3OTgNTVu3/LoXkD97ZxLjIhLd7aRjYCgDaVDdnzgzvGKOHrcq0EjdAqtK0NMAnNFFdyw6UDyt92pLOBbi2nhmAuKPiVYUfHUCYnb10sj11k0vplJjprJp91LGVDRip+Oq84tOzLU2YXvqWunUXowZ8mTBdGtciQ9S8I/YpVjoobo2oJlZc8X0yDeS1ud0ONFqKAVT6z046DRBJf1MT0nbvpzVWbEiZt6V7oq4P9/r84HNeXLvBoKWYBP+I5l2SyVf09jmrmPKHEZgJt2ZfkHsc3RpgbP5YS3cDfYzIn/E6aez6g8To8ubklT2uVpgtQSJn6mi+DCY9O5G0tZ7LArPgxwfpMd+AKm0XWLCEYaP3IvGZzDGa+6BXNK7/Q02epeFSXzI15j7Qr/dPXxgXhj+SUT2EZePEAjEc/zvfFrn905m+vQFFglEicKjenhK/utkF88fJWXytZRq5c597f9SD58MVwR1SK5x3cGoLr1Jy+C1YbBOKjmJ84EFFN5ebt3P2jHbfU3RL5XNBSWByafmtB04UrXnPA7eleJOuswuNrru61RCB6XSEmyEt893BgF6AhnxYkIoA6EUWKSBnaQDb2nQ7Qu48IkvxctM6j3DppFb6VBBvW+5746f1LDco+a3t3tOkC2GBhaDqnATTYbGZEegRC5IzafWj+P2v7NLnTqgkbLRt7GJsAl9su+Q6zP0B8xUV79kFzfI5kZIUloxgcrkJH4rsD47y5SJ+Tcv6wkL66nl2tdEqv3dyDe9pr9yNDMRIfH8+BQrWSVz+GHzBBaZPrwOjUeZbv4bAgWxOYuh1HDTgihxfPEsUkXtJaks/SL/lTFM
 2Yi6Xyq3
 ARJ6hFdRC68aCWWVgG2tuLMHJAkjAP00MeWFdeLMTQjoIjuRsIL/JjNEn9Ln8SH1wLmcJNJUzhUKGXSTiXHvI2NKaJRGe+2eWRdlDwtBUXguNgFKRi3eko3GXeR6W+L4GPsR0qi8sXJXOkJY5IFYjBckY8XqLEz1hsSclm1IAhrRBgR44u2BJ1rW4oD0+Y+NFcYPeGOoBsJD9JqHB2dwGXv1k+Qr9YQCAjeDWqgP5Cu9i4oshpOR7tR4NzgWR6V+e+8tmS1enyMDlJ4KBTtIgtYgdQ7RQby/e7WutNKq0JJguU/gMCkg/WO0+HprYDgU85lyzxI2UrhyoABjCL6GGReYRTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 03:27:47PM +0200, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   c03c1a14507dfaf8b856c2608f9ac216021fc222
> commit: 9a4580db6e9f83428813f671a79486469684069f lib: fix memparse() to handle overflow
> date:   5 months ago
> config: loongarch-randconfig-r2309-20261019 (https://download.01.org/0day-ci/archive/20261019/202610191553.uvFTO4t9-lkp@intel.com/config)
> compiler: loongarch64-linux-gcc (GCC) 16.2.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261019/202610191553.uvFTO4t9-lkp@intel.com/reproduce)

Blast from the past?

> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Fixes: 9a4580db6e9f ("lib: fix memparse() to handle overflow")
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610191553.uvFTO4t9-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    loongarch64-linux-ld: ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L47':
> >> __efistub_cmdline.c:(.init.text+0x288): undefined reference to `__efistub___ashldi3'
> >> loongarch64-linux-ld: __efistub_cmdline.c:(.init.text+0x298): undefined reference to `__efistub___lshrdi3'

-- 
With Best Regards,
Andy Shevchenko



