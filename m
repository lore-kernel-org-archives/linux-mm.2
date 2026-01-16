Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B472D4A613
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 08:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3756B0092; Fri, 16 Jan 2026 03:50:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691BC6B0095; Fri, 16 Jan 2026 03:50:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DA26B0096; Fri, 16 Jan 2026 03:50:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 436C36B0092
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:50:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC8611A05A1
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:50:41 +0000 (UTC)
X-FDA: 84337206282.06.E90946F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf09.hostedemail.com (Postfix) with ESMTP id C276314000B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:50:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ijhMraSk;
	spf=pass (imf09.hostedemail.com: domain of zhao1.liu@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768553440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7x/bK4DOGdlxgjjbUtNSp/6xcgnalFIPscEM8p+Q0y8=;
	b=nfJlKiNZGBYlJnrfJM4Pb86D6dXpVkAf2f0q252gW9vCoFSLkqElJmpeNSpyKFxWnLnXws
	piTpAfzN583dOyZVGz0uZIMCD7EM41guJKF74HONMdvhszQ9WLpD6EroVRNiD2sMAYA25R
	rUh9GXhOqNZgyD/aoiMO1629zVY4j6g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ijhMraSk;
	spf=pass (imf09.hostedemail.com: domain of zhao1.liu@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768553440; a=rsa-sha256;
	cv=none;
	b=lkDOypSQObjQsKs0jI7EQ9W8zCsi3sg7eyoYO9rte2HV/FFlIKmC+Gl3zkNCxRDwsetsRg
	8wNFqxHSvqT5rzJMTBx8FP5601NVAg2IO3Rz6XA6/bvWOAT36+OarCkLlgyncEM2tzovYd
	D+9JgLWy5SP8SqAjaeCcI8wOKk9uE7c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768553440; x=1800089440;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EtJIRZ5kQM1AmV3qKOu/PRnKgcwSV4sCMrjqXb0Xq4s=;
  b=ijhMraSkU7SnbNwgxgrirxDR4j13SbpUeA2Qzce+1IKcHqxYXs0bstYj
   2X2U7dkT5gWIateRYT4qqQcBfwmVL4cVS4h7AlXRRW8005M1KOKzuR3o7
   kX4sU/kGGdfq1kcPLsOXkoV+Dy/4XuTEqB4kSBtYAqrIQVtuGtRiut+6N
   SsvemIOdzM2TC+lQS/ZfjVxI7IiXYJQhgFuVbZZ6znmyJEoRrGOEBk973
   NoIbl/4Htbo+TFk197rqkYK6uTHMqKZzYTgrUuDQYvelwd5Sage080PeQ
   eYeG6qwga7axzMtjeCs9d/QH7R5hFtw2ESga6qJ8q2jXw15HQBTcrd+KI
   Q==;
X-CSE-ConnectionGUID: qsHhLQ3wRQWUjFHNzWRtww==
X-CSE-MsgGUID: QO5mMHIhRxW81Aq2EdokZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="80982147"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="80982147"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 00:50:39 -0800
X-CSE-ConnectionGUID: USy2ZwdtTxuAED8Xk6nV2A==
X-CSE-MsgGUID: BgdxI1+TTcCzp1xlNG4FLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="242741334"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 16 Jan 2026 00:50:33 -0800
Date: Fri, 16 Jan 2026 17:16:03 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Hao Li <haolee.swjtu@gmail.com>,
	akpm@linux-foundation.org, harry.yoo@oracle.com, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, tim.c.chen@intel.com,
	yu.c.chen@intel.com, zhao1.liu@intel.com
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Message-ID: <aWoB0/RxDZeK6LU0@intel.com>
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
 <aWi9nAbIkTfYFoMM@intel.com>
 <3foece42fc3wj3wgcnibi7cn2be73ancyjgrzdqfjeqvjtwkhj@lzqd572wfpvz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3foece42fc3wj3wgcnibi7cn2be73ancyjgrzdqfjeqvjtwkhj@lzqd572wfpvz>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C276314000B
X-Stat-Signature: 54u94wer5bgsgz8os96fac5bgq7wh7pm
X-HE-Tag: 1768553439-482505
X-HE-Meta: U2FsdGVkX1+lq/pzDVk5LLnHT53wX9q+d0Nl/feP2o3xeiQby1AIUw9Djp8o7ne8GxMgoNyU8EkKG94ALBZJ1QDRJHBsaEcZdkUToQy5j8OLB2iAMwkZKHDRk4wLzglesK9w8oehFFzlu5f/zr8kjhxL3nLVTrZ/EtiaimpjgbuAEMnbasbz0xve8hfjhDNdh619IocUC0YGvrU9fRF70TRCF7J303E3jFp3DZJVZhWI3lGGkOGi/EhrlyapgORuKqN8BK3hqShc4nLf2C79GIZeLUO3WAWlExh3GR9ymd9d/8ra16Zo9FIRtKBLIcALvdGt9WjyqTVVDYVuqbnLOblHqp70aL32KKqwqpCihvFoFnHocfGuyU9L4lsWNPWLiE8sB5Z8aCqXIFFuTJ17ogdMq1oDQT1SvX+dFSDzXkgh2K0MAQGoO3ne9gzsb4eYlWva25zjg8xqG06QeTE/cJ8pTZk9F+nePIpYCd5Ze4ftAsrovnk6BYqiZkx1a0JRqPShP0HN3euz60t3kh+GO0aalFlvtVTmEgWKAT4AStwSJIasxSYYp9bvGZKMiDZlBhfBsZ0LKT9qGBKb0KSKpxgmQq4vyzesfvu1Pr3Wrf1sS+X3gwInXMRWAAGHj6RX0kQwo/m05i9W/9pOWJMHWZY7/pGxWLshFcWHMW51oXm91bWj/4f+xt3tMadPlKvDVYtklZ1pahEmdsZBLyLIdvOX2/EylQEmIVBlALbXucYolw7fOlbrpcZ9mN3YBC7Vil8ucfjKOqTOOWCZPhZeEj3+YYCCmCw3b26LjBh1MPfKLNMLv+NAr1ZDcHb9w6X8DJDPPBBMKEDXKDtBkbdg6qmapYQwhdpde5vqYFsonPZ3Mizob9bJJ5MsdJJpdG+EXh/3G6o5liwZSd1uykQ81ANlqjSTb01rNwyOf316uoiLES0/m//48Q6KeEBYjxB/PXt6E8oBq/P3GvKybw0
 YvTvc1yr
 Bn4iJ5Nj9Qj4OzByGLmaEGBDbw+1ls05+62kAJCgWHGqoswhbUifQN+TpyApJtUwOKlHZqzRvAIaTj1ZNrLbwg9EJxAzYNHJ3eLT6mPhRcYW2oFJBXsLQOtASE9Sxb5NueziglxDhPQPWAURy2YbiF1d2NT7eBihJkBojncmjpjveNExD3iRz95/SJy9+8fiSVSAn4w9CmyJqpZZeoe6TaELCwVrVpGUn2is5Y22s68aB+15fBkJSjMOQ7pLvCgLbkjoEu/psfEJcvMuJqqbH7cKnSSC/lAf+zIpGJwTponToPDyD4u0HMLiU+qsa81dMBunrydGUeURb+G3JnwqmvcYYyBuAyuPcQ0nMdDy06Zor3idXz+KomPxAvbw1q5AL6bFZbid6eJKUv3vChbuSxY9hU9TK8GmIwS3FDC5oP8iSXZDZ0xDIcTwLRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I'd like to dig a bit deeper to confirm whether the "256 tasks" result is truly
> a regression.

The "256" seems align closely with the NUMA topology on my machine, so
I'm unsure how it will perform on other machines.

> Could you please share the original full report, or let me know
> which test case under will-it-scale/ you used?

I mainly followed Suneeth's steps [*]:

1) git clone https://github.com/antonblanchard/will-it-scale.git
2) git clone https://github.com/intel/lkp-tests.git
3) cd will-it-scale && git apply 
lkp-tests/programs/will-it-scale/pkg/will-it-scale.patch
4) make
5) python3 runtest.py mmap2 25 process 0 0 1 8 64 128 192 256

[*]: https://lore.kernel.org/all/262c742f-dc0c-4adc-b23c-047cd3298a5e@amd.com/

Sine the raw perf.data files are too big to be blocked, if you need to
see any specific part of the content, I can paste the info for you.

Regards,
Zhao


