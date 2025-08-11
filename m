Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07307C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842388E0065; Mon, 11 Aug 2025 10:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F35F8E0060; Mon, 11 Aug 2025 10:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E1738E0065; Mon, 11 Aug 2025 10:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56FCA8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:58:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01C5552CF8
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:58:20 +0000 (UTC)
X-FDA: 83764782402.11.EF7CFF0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7CDCF80011
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:58:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=T9Y3tYvo;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754924299; a=rsa-sha256;
	cv=none;
	b=0fzROOzf0PluDDlGc8Cxr3GpY+HsEDj03/Nm1nf7kx/gzW06XQpJ8P2uiW0bAKWXQFZNAC
	+fc6z75SU6nvKNfxuo2D+gQpCcSuU/XBHXNmZx3Hd9lkAeLpnCEYcEWw9d0Yqc4syDd6AF
	Hp5eBb20AjjEddcSbFq2kdZALdcaLho=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=T9Y3tYvo;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754924299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSFMT/tBaCxzDgTCmB/lW8YrozQ9YsezEiL9WzSLP8I=;
	b=5nHvJzBDPWIe4bbtIysG1MlgO3+e4Kg5xuGV/GdWdXmniJ/ygb+25KmsBshnHMVwj8ouMO
	munbXmevf/KNcpVnaI9oAyXkGCWzl6WcKMTsI5F+hIErmdaA/zpgJfeTyo87zBr2SPtaFk
	LetApJbX2Q0c9sLV1DKJRrW01oRa0ic=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754924299; x=1786460299;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8oL/A4iP9Xx5VUsCUZqLWJ721V213TvFpSlTphoA9s8=;
  b=T9Y3tYvozczFlJx3y2bD5vIS6LulGRQ9/0wAk+Tg3o0vSVW2NKlngwzx
   yOhPeprHSWk4gG+6qrFRpV7FkxjorVz7Eo1t1s31qAP0p/DZP6TwO6HPe
   b9KcAzmGb3COKd6nJynfrKvSvGGpkxBudsERrmQtMHSy/VSsnfAKCNOUk
   YThOflpckTeUlEp42SUXJlYb0fkOuw1b9Z9Y6IEy+1wurZyekuaflBeZV
   qZGL/oWWwZD2k/w2oAIpe17ukkXcn9O0f8LRkstdWVPPiGf30l0eYphuS
   Kch0Gin3+AbtT5B5OY09w2o5vumkdBrqE4A0Y4VsMUGRFoP8eRyS8wq5z
   Q==;
X-CSE-ConnectionGUID: cJFBcs1nRdKCx9z1S65rKQ==
X-CSE-MsgGUID: Du0r81WxTr6b0A8PNHgdKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68258431"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68258431"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 07:58:15 -0700
X-CSE-ConnectionGUID: LkFdrqcETv6sIhz+lLLDCA==
X-CSE-MsgGUID: eJM2J1muSGKY/VueYjTJnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165183053"
Received: from black.igk.intel.com ([10.91.253.5])
  by orviesa010.jf.intel.com with ESMTP; 11 Aug 2025 07:58:08 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 0132894; Mon, 11 Aug 2025 16:58:06 +0200 (CEST)
Date: Mon, 11 Aug 2025 16:58:06 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Bhupesh Sharma <bhsharma@igalia.com>
Cc: kernel test robot <lkp@intel.com>, Bhupesh <bhupesh@igalia.com>,
	akpm@linux-foundation.org, oe-kbuild-all@lists.linux.dev,
	kernel-dev@igalia.com, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	oliver.sang@intel.com, laoar.shao@gmail.com, pmladek@suse.com,
	rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
	arnaldo.melo@gmail.com, alexei.starovoitov@gmail.com,
	andrii.nakryiko@gmail.com, mirq-linux@rere.qmqm.pl,
	peterz@infradead.org, willy@infradead.org, david@redhat.com,
	viro@zeniv.linux.org.uk, keescook@chromium.org,
	ebiederm@xmission.com, brauner@kernel.org, jack@suse.cz,
	mingo@redhat.com, juri.lelli@redhat.com, bsegall@google.com,
	mgorman@suse.de
Subject: Re: [PATCH v7 3/4] treewide: Replace 'get_task_comm()' with
 'strscpy_pad()'
Message-ID: <aJoE_tzAGE4krB5y@black.igk.intel.com>
References: <20250811064609.918593-4-bhupesh@igalia.com>
 <202508111835.JFL8DgKY-lkp@intel.com>
 <6b5c92c4-2170-8ce9-3c9f-45c0e1893e03@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b5c92c4-2170-8ce9-3c9f-45c0e1893e03@igalia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Stat-Signature: wqzebm6mtz1kfn51iiy35r9g6shriazq
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CDCF80011
X-Rspamd-Server: rspam02
X-HE-Tag: 1754924298-589428
X-HE-Meta: U2FsdGVkX1/yfq8ndfET1KxO2XO1VxbXdDW3uDPrXQtfFBpcds6LfzLYd5hLCClVSwx7alLpfx5QnohGvmnBZd5g98F1q7m++B7AIMtCiejjz0u960FNunV7u033uhs8uL/q5pqtEeFus4JChHSc9CGopTKZf8c/yu/Z1nrAhB8VjBL7qObShyMmCed9dy2h0iezhkhJnIVLTesTaaPf5IeXCOlx/uRIGQjPY4Ij/W8LAJYLOIRQNnqo/HKKoedXFFS3BkZQGu1kSvdCZLVRqkl4jMQoCRU6QoaVly8Ly6BWXZqHkdIcH4pLPThiEN3TUrjOSj7Ul7TDE1vJPIUsey42ZcKxD+msh0vP/9pJDRgKuFjqf/wF49wJvTB9OOzwtUVjEoWB0OY6qrIqIt/sS5njWIZheytNQ5aBcPpgU3U0nUbt4wts/iVDVC+U+h9rPXO+HYivb/fZaigTdaUr6ZwgJFIL2QWjqRV6VrmVd99z1B3F3+krobJZH5BgSS3lLAHkCaxNsw3HDqbwQFhvyun9VdT4+pH7txeQYzRM0Y/zGdzpvW1iWeMTuuO5gq6rE+XHi5UXR0axsP2ACT58V39AqXbw7DR1sgnv9QfRjhbcqEdh7F3tR40kNKRd+8WuY6b2gCxfc68M4JZygbgqUuDBIzjUZVOu4Z/Xn9cYSn6WV7/sNS7/Id4j1Ia+83ZjTtaFLjoXl86p2Jt7BrhupFx9g/eb4yAnM1m6aD74koBeVCYicMxWUzxIgKilTg9eULBrOu/drb4h+KVGR3kKkgN2mRvAWI/9gvSnsHpOdSpC4kfArcavDgVuPZ5mdq60R/WI9SdfFP2uexFSI9nKf1tgACWS0ODWCmJjkB6nrFSEwOlXQIpG0Yq5dRHfxpSRDPMMwZSkNamyreCp99bxTAfQu2hDZweDtqIyh9p7wGfjibFGbKwwqLPTWD8qAB1m2gpwtNplU8V/BYiM/5W
 bBQA0l+K
 eOjmJlZmTEjkUv8vBKQK/JBMjx+aUrWyjbSkASOgpCVZOdU4yl78auLTXjl9M4x07g2AL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 08:19:08PM +0530, Bhupesh Sharma wrote:
> On 8/11/25 4:55 PM, kernel test robot wrote:

> As mentioned in the accompanying cover letter, this patchset is based on
> 'linux-next/master' (the exact sha-id used for rebase is:
> b1549501188cc9eba732c25b033df7a53ccc341f ).

Instead of getting false positive reports and this rather unneeded reply from
you, use --base parameter when formatting patch series. It will help all,
including CIs and bots.

-- 
With Best Regards,
Andy Shevchenko



