Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF96FC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D738900081; Wed, 13 Aug 2025 09:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF1E900044; Wed, 13 Aug 2025 09:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704A5900081; Wed, 13 Aug 2025 09:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC52900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:52:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26AAB11707A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:52:52 +0000 (UTC)
X-FDA: 83771874984.04.B868ED4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf28.hostedemail.com (Postfix) with ESMTP id D6B7BC000B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:52:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=noa04R6s;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2w842LG5sLyuoBlj94BJsB1aS1vUFuldvzv1lxd1M0=;
	b=bqk4dwSMp6Tj0L//C7X8W8UBAS0UIPJIgu7t6zsRmnybk3AqAbeiLE5RTeBYN/PMP/Z77W
	T2xFNHn6KxXoz5mtHRVL8hTlbZwBsySqD1kGpjwVmK62W7t7h9Zfjmx7fydvEPGxpAR4/p
	HT6fiystf1lG8rQXMk4BfSNd59OGQNI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=noa04R6s;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755093170; a=rsa-sha256;
	cv=none;
	b=CrtdFTHJLJAUCE09kZdRg2bT869APFLpSxuysO2EMyuWFetOtCKYtuK/6zTkwMXG8k0Ujj
	VexrIcphUGt/E+yUybnaCjkyVXrMqPfW9RISfoJDmISSC8PfUwwUDmBSGITWO+mx842hTs
	W/rCz7k3DsegVTQmTB0D9TwIu44R4Fo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755093171; x=1786629171;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yRzIBpcwo03V92Cu9B8zeqXJTartIC1MviVhaIBxQdM=;
  b=noa04R6stwUnIleEcNPZqRxi5c/JY1m6esPhnp1fkq+p2Fj6BknOaCdI
   vhGvcxgjkOoSV2/hZFv/haRhT7iYXZCHKnT9GqCWAfVzPpsTfP/cXnk19
   6RTt4O8jwo053OGTUYdI/oWQEyf0vFzik7GS60k7zQn5tGISES4jJ30DC
   TlJyTgebaDwSu6RJqacevrNXqJpnOOzDCgZzOUOZ0V4526BBesCtRJiie
   d/K2LFQjy5aQHgFPq5ariSZh3w8fezrPe/czxM65J69x4+Ok++BYQsk9G
   VUxJ8S/VYAGBKfCCu24/0qSvT8OttoeNFRFIf+MSWciE0OpD0kueb6y9p
   A==;
X-CSE-ConnectionGUID: zh4smm5SR1KeTCYKuHiGKg==
X-CSE-MsgGUID: xgV18VNhTdmUTslW2xfgTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57289143"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="57289143"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 06:52:49 -0700
X-CSE-ConnectionGUID: a6XmckWnTmOaZ0W7wn/o/A==
X-CSE-MsgGUID: 9CE9RbIqTnCtSYCj/rZ3aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="170928900"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 06:52:44 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1umBuB-00000005RqB-41aP;
	Wed, 13 Aug 2025 16:52:39 +0300
Date: Wed, 13 Aug 2025 16:52:39 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dominique Martinet via B4 Relay <devnull+asmadeus.codewreck.org@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Maximilian Bosch <maximilian@mbosch.me>,
	Ryan Lahfa <ryan@lahfa.xyz>, Christian Theune <ct@flyingcircus.io>,
	Arnout Engelen <arnout@bzzt.net>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iov_iter: iterate_folioq: fix handling of offset >=
 folio size
Message-ID: <aJyYp-3VA9kJ5YMd@smile.fi.intel.com>
References: <20250811-iot_iter_folio-v1-1-d9c223adf93c@codewreck.org>
 <202508120250.Eooq2ydr-lkp@intel.com>
 <20250813051633.GA3895812@ax162>
 <aJwj4dQ3b599qKHn@codewreck.org>
 <aJyVfWKX2eSMsfrb@black.igk.intel.com>
 <aJyW_QNI8vIdr03O@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJyW_QNI8vIdr03O@codewreck.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D6B7BC000B
X-Stat-Signature: xhr51ybn1fz4t1hhgbs8kpsgyjmn49h1
X-Rspam-User: 
X-HE-Tag: 1755093169-408984
X-HE-Meta: U2FsdGVkX1+d4dQkipGOpBVLB74i7otP+mSzQ0/fXFfVrSpq9gftUtQN+HixfOxYARDDjHEvFgistHzEl64SQSrGoWePonTLzS7tMxCWQoHM7KEY3McqUb4sUqxkmVGu56jCU8VhuK3IYY4WHLDUrbCAOhy7w5SpNkrcwQGeChgzjJGtOn92gWVcvgjjm/e1yiKR6EpzHeKwU0l0YW1H1rQiKv7WLsuTN0l5ZwQZuzJB6swc517QUyMj08B8u9cR3Og3Im3/Zl/o4GlAuJAOWk9SSCUyaN1XlN7YsOIhvC2L66/uPeUEuC42eMT2fF9FjM4CClrEo9Lt8zWQUFv4HlQWHqroT8aHUOr3epCKCdJDx9J4ekUrVrY2BoWuogf4LvHdV2ln8Nej51cUEtZB/7TSFXhUdHuCIe02xFBMg4mt3ui+7ATum66BxSmhrY7waIGchJ9WqGkYbPy5P5Z2zeOW3UG9OBV8ERW1E1Gya5PhXvCGoFdAS5WVdMJAnWnj5Won4Hxt/CwDbq6HuHgiElBIaPK/hpVRuUkb2t+Prsg3yYH6i7w7XPlNOPelaCg/yapiO2i8mX1SGs/hZ9NjAu/BCkRRv46cJRgzZL5J5ZEZs3D8CFx52EUMmyl8gk3Uzg4h3ORoDs+0XZTbqOTx3AKGeJntkP20t2ffS+oSSMnAHdycKSbseFekE8lI5/pHNW6A1Ra4tQ+qAT4fqMaCmkdniWGvnNV/0wx/wWXQToXheJ1U6DLc36b2P8jogLL4vjCopulfG/gV+HmaTytaBlyH5HJ9cCWVXi5vyxDYvMcBKk2CdIKkeBRQmLxqXGZD1CHXRil21e/wqlbaSFtmV32oAzll6cHb1TLoO0I/GM5L8XxgD1UGa8waIB1eKaLAT1Et1Hj8/fliNd6pqdAuMs/aMCqnJoP/MdDGJWC536MuPFTwO9I+0fQg5I+VS1ZevCTYYJPbOEWNvg3S3i1
 EPsCfwIf
 gnk/k2mOEchyeVfaZOAeo5ZHvs+76Un10FzXiJ9FdXLrPYOID+ml7dBYVFnNYC9G7Urd0Fe8SfG6Tu22OizDOaPAix22KB2SFo1+cAVGkRND8XSLZClok1fZYa55JMa66Y91xsdUSq60AApU5uLU20ar6YWMFEc0Y9+mzfmS/tCl06CBSCG7UvrQyBMTtpRNvY+HqxRV42L0IYDdEPbV9aFrBuSaQsOMZNHBc/QuDEMP74IU8k4SpQrkEseldotqWtdjsEkQeXOp2d9ssDDEaYli14ibfQ3cq5aMSIJT9swMUd3rMY8iB7uFl/bSwnAFeDRb/gxfi0BB/35/Cykzbnl+ntqHdqF4eCz1fz6GBqr+14QFBk5Ah5sB4Y9sSbKAdKTM33557e89A4dE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 10:45:33PM +0900, Dominique Martinet wrote:
> Andy Shevchenko wrote on Wed, Aug 13, 2025 at 03:39:09PM +0200:
> > > I assume Andrew will pick it up eventually?
> > 
> > I hope this to happen sooner as it broke my builds too (I always do now `make W=1`
> > and suggest all developers should follow).
> 
> I actually test with W=1 too, but somehow this warning doesn't show up
> in my build, I'm not quite sure why :/
> (even if I try clang like the test robot... But there's plenty of
> other warnings all around everywhere else, so I agree this is all way
> too manual)

Depends on your config, last few releases I was specifically targetting x86
defconfigs (32- and 64-bit) to be build with `make W=1`. There are a couple of
changes that are still pending, but otherwise it builds with GCC and clang.

-- 
With Best Regards,
Andy Shevchenko



