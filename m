Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E96A3E8784E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 206B16B00A8; Tue,  3 Feb 2026 12:17:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DDA46B00AA; Tue,  3 Feb 2026 12:17:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE0C6B00AB; Tue,  3 Feb 2026 12:17:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F12296B00A8
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:17:53 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8339216032C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:17:53 +0000 (UTC)
X-FDA: 84403802826.13.8ECE327
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0989D1C0011
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:17:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gesjHoji;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770139071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NS0E6bgKyqTLFJJmkBS+9m2uVKsOfGKpeowXk4rUFgs=;
	b=7YYA6UGYhf/A96swf7kT1Jr7d+VO5hDe+SkNnCZ0sggEJ9w7t7huQtPMJKoPtSdIpDaZO7
	n657bve8lDBdG/RdYzqUQrhOb3QALKOkr6L6rj1QeZmG8j/SgDFW4sZffInkNBAno37851
	Co4UQjvf4IzqNV2QwvoRvpMK613MTTk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770139071; a=rsa-sha256;
	cv=none;
	b=CmG9jfXPX3LEN7n7EJ+5s711Q4iYAQKGD9Ked+8s7Gy5AGMC16Xe+v3bmWEVhjZBdh+WN7
	ZRFTPg2adhwx8cq13ZJddf6C/KXA3arCpLHNk7EoeNGD6Fvf6vErG5of+T9YHB9ihYuWTp
	gWZ5d1DtqAqiO+n3z0AmrKtDszlUHU4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gesjHoji;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770139071; x=1801675071;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v0lDm9YgstKw6NIqXo1gHAVbHj1ebjoVADNi9DqILIA=;
  b=gesjHojijbZWQeZak5LT1E6TZIMNchNGFlOlACAnxxGgqDu0YFfX6VuW
   WLwKrdjChxHaQKjH6i8ToCC9G3MFGQqoSKelVn7gwPKSSvGd+5WMIdXk7
   DRMhazmP3HkqGTlVECo6VE4BqCsnxIQkVS0CQFf5JWC2JVN0OTKCCZBGl
   HH+vDie9lM1cuKvZXLl1DJREppjxXIPdSRcVv/tVmlhv9l4+Hb1RyAzgH
   7/v6b/K5e5/Kk79TaRFEabi7AHE8q5ZMtRYnVHamw+Mw0Myr22tBCwZ1L
   qPmJte8Uy8DSxC5BsvWOANjwLAHc4s45Qa0EJtXJ47QpUiR+zSexLBZys
   g==;
X-CSE-ConnectionGUID: I0eegEHOSPKoyGe0bOSvWA==
X-CSE-MsgGUID: VQ32HcUvR66j83c94JHZdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71221773"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="71221773"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 09:17:48 -0800
X-CSE-ConnectionGUID: eFiBkPDwTYek2C7bzla/Yg==
X-CSE-MsgGUID: ifUYzvaAT5KqOvbUgYsovw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="240590627"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.99])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 09:17:44 -0800
Date: Tue, 3 Feb 2026 19:17:41 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kernel test robot <lkp@intel.com>, Arnd Bergmann <arnd@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Simon Horman <horms@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Yury Norov <ynorov@nvidia.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: remove __printf() attribute on
 __ftrace_vbprintk()
Message-ID: <aYIttabs_YsTiibd@smile.fi.intel.com>
References: <20260202095834.1328352-1-arnd@kernel.org>
 <202602032036.FQK7gJvV-lkp@intel.com>
 <aYINAPJS9zXlUGCw@smile.fi.intel.com>
 <d777a8f0-41ab-48f8-93db-268f493ac656@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d777a8f0-41ab-48f8-93db-268f493ac656@app.fastmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: 0989D1C0011
X-Stat-Signature: a5owftbiz8euohqhu5akmt7bq91dcpuk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770139070-182525
X-HE-Meta: U2FsdGVkX19K3lUBrXDCDfk/nlx8TmvYEX7XfS8h30cCmkUEg+A2pqM9EIl2+mnTVOiUySi2mcClftVo4LhyPpyl0eJd4RDsxENtguDYpVUTBf5ZSOnZ9HLxaiaC6Yu1CH650+fv95HS2JHOBrqpEtvuz3Yllci+3Yjkcu7A/fEfnLC70lvbYktoiiA2PtIiQtqn26v9hZJV+EcJ/AUSzQSicdegOmOg8sV2DjsalXn5Pq2w+epSvByizXNM1wHhdaUTKH1oI36JTLX/U5Ozmrbd1cca6Tnhuq1x/LrIsWQYIZBlV1Ufib/GDpN2rR3r0jP1xXhZYWGTdoUYdaUUMJW/+WFLKR0Z8VnktL4NbeTQKj0oezGIKZO0aioe6ZbXeFfdh7Qdk7oBbEJywkwZzcluEKdHSTRD2yonOptvawiM1QdjjhZrSwlBrwBTSvc+IA4Nads8wKUs47cp5vptGdFx4r1VxYh6mGPCBcrKcHHmg1AD7gptLe18KdD6iYY5bj7j5Fkjq2ijIcMhtpkR3iH0m1DD+Ghg+FjRZpLY21BmtPS5b986MrfoEvs7qRqwSgFe6hMJqyOzgKODYFragyB1ncE7OTSP+gGpUCZnQJm1EjvzQFMezL0rWCFOy9kKvo5gp5YPo8WiMioqQZZpZoLgCqw+UPKZSnoDrjkuovp3exkJLGFnCUIGiZr16trZZHLnKykMoGbWnQVjj7MSS+n4wPj3ac5GeAPXY+HmPo+YWjih9Rn/wuTXXc4UgX8vvu9xMt0W3fOk6mde/cVI+syN6TYzq3xbQTLE1CcKdmGgH8OoqKNz1qkYVafo0fEMjeos1gIyhPrfIcE0lnmkCV6NDNm60E66EMfCyO39uRapj7+KLcJVG98sh+5hK7OVMa8paJcipexyr20rO5tgbPKRbPS4yUejvJGFp4qXq5ctlR54aEbNE598aeQYGlFAstvbLEzTAicg0JBzwvV
 llvjGb5O
 isYW+XIv3GZidXqUeVV55BgzayybOBaT2y+ZVUix50+izVAMLsR2tsNowLkgF5IKBsyOfBG8FRDhO4A1fSxUylRHj5yzCB3xA/lv91pAo1usSSq3cGd1ze+Wu5depYerFxeB/Nfb51YKus6N9sgzNq6NS8PDdAfBMREDgv9Boeu1H2VeK6gIqhcbLvhtjb/gfeW5BQazQzb3PLpPmAPgrZd2CErb5gW7Xm2t/BxlG0/NZzP35XNdzVpIPw2DEM/0X+r9zBZc8uAkY4ZEcDjQ3AhGQVakjTzeSZtMh5aKOYk37GUr0/chTAkTtZ733rp98gYDdyXPKngQrjQK853L+c+z/gbS75EdwePd5/s/U8LPwwcNQ5FK8Z6cRyjEVFQIwyllXT/u4/soOiiM7Hu8lm1hWvUEBhK6BXjrna4qrFcwfGFA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 04:56:03PM +0100, Arnd Bergmann wrote:
> On Tue, Feb 3, 2026, at 15:58, Andy Shevchenko wrote:
> > On Tue, Feb 03, 2026 at 08:12:57PM +0800, kernel test robot wrote:
> >
> >> kernel test robot noticed the following build warnings:
> >
> > Yeah, you need to go for the full stack of these calls and mark the 
> > bottom one with __diag() to avoid these warnings. That's my understanding
> > and what BPF people required. Chasing this one-by-one would produce
> > unneeded churn.
> 
> From what I can tell, I can just move the printf attribute
> to the __ftrace_vbprintk() definition to make this bit work.

Ah, that's cool!

...

> There are unrelated warnings for BPF that I managed to
> shut up the same way, doing

BPF rejected such an approach, see lore discussions in the past
(patches from me). Here some pointers (but not all of them):

20251208141618.2805983-1-andriy.shevchenko@linux.intel.com
202512090407.VxRO6xAS-lkp@intel.com
20251210131234.3185985-1-andriy.shevchenko@linux.intel.com
20251216122514.7ee70d5f@canb.auug.org.au
20251215202430.c35c2d29c4f9ff614d2ab534@linux-foundation.org

-- 
With Best Regards,
Andy Shevchenko



