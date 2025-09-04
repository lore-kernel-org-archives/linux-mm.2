Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F25E8CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 13:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A548E0006; Thu,  4 Sep 2025 09:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A9B8E0001; Thu,  4 Sep 2025 09:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387438E0006; Thu,  4 Sep 2025 09:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 285378E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:54:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7E911401F7
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:54:28 +0000 (UTC)
X-FDA: 83851712616.20.24FD09D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B7AC40007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:54:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EYvyuNkk;
	spf=none (imf27.hostedemail.com: domain of andriy.shevchenko@linux.intel.com has no SPF policy when checking 192.198.163.10) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756994066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QD6cqQmlluElg9i5qrWnM0jOc5rGX0AEw5ovOxBgCaw=;
	b=jdxrrD//QmGB1vBGFJKRX5lxr4x75m2asUv2Kkk+V/U+PFFp7XTKJFRNT8kMaiTPJlx21c
	tYnkKhQIMMRYHBlHg//mAoXLTADU+80bNUQi5KHRCuwJmncy+hA29nmM6qDB8HJVmqBLau
	YwCwvLBvYeB/F0OvAhnM+YUIjIRl5yc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EYvyuNkk;
	spf=none (imf27.hostedemail.com: domain of andriy.shevchenko@linux.intel.com has no SPF policy when checking 192.198.163.10) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756994066; a=rsa-sha256;
	cv=none;
	b=75LxSnBsafAie782ycT8E4BK4wfB2Yl3DYrHIBvqIIWoBdD7MSr9P50SkBVBFjFR2GvbeJ
	+R6IOIhw+NOfZLFetP8LJhOxxTbSMHZe6OYh1o0dMbVXIeDkJBpLmKj1yiRUoNQueG6vBB
	3Hjf8deBPqsDTV07ZhYiNiT+AGLwksM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756994066; x=1788530066;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=DGzj4IT6gOWl+LiwKXrtJj9tKvLVQbiy+t44g7t3csM=;
  b=EYvyuNkkr7zOmosri+HlB3nBNYU7ObBuSGpNG4PTKEsNAx1YD3CRNZ35
   YXfk18uUHpmAG+bSHwbsxvOyVp9/xLUVKgKIgMVflXXJaIk5TNV3/Z6wn
   N4H3gaVea3G31lcWUkHYOxswO8RjKbsrJHb6GZVVdN8AxW80ypGCnxHXt
   bfkqJEBj9UOBFel1nxeeXabPmi5jtnpxNLxX7DbXg83vLVXEqtijJuGgN
   F64XyqimJjFTJEZN6UvK4V+z2v+2B1foj4XDDY6MbAcEtTRjstWM+016T
   PT6VTKlEDbq6MLtfAra2TEMtVcqENOjW7SAPEIOmnWeP5SphrXHSOY4MS
   A==;
X-CSE-ConnectionGUID: kDptRy0BTaiB8rIIJBssQQ==
X-CSE-MsgGUID: E4JiF4J/TQSFxdPftuZ0fA==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="70707028"
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="70707028"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 06:54:25 -0700
X-CSE-ConnectionGUID: fPncoDVhS0mrqzHATDjJSg==
X-CSE-MsgGUID: fmrYChGiTGW38lsOSDUzqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="209074799"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 06:54:21 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1uuAPp-0000000BHfS-3EOK;
	Thu, 04 Sep 2025 16:54:17 +0300
Date: Thu, 4 Sep 2025 16:54:17 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	linux-mm@kvack.org, llvm@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH v1 1/1] mapple_tree: Fix build error (`make W=1`)
Message-ID: <aLmaCY9TAbLSb45o@smile.fi.intel.com>
References: <20250904090423.2293933-1-andriy.shevchenko@linux.intel.com>
 <6nk7wvp2vbsc5myxnx4mfohpq4yk4ixazkvif4hntilpuz7jtw@a2q2if4nc7kn>
 <aLmWF3V8ILOkL8W2@smile.fi.intel.com>
 <2ts445ufkl7mhtdd3ucs2c6lsp7fxbx6b5tqmu2tdecxprok55@fdr2dwppnoks>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ts445ufkl7mhtdd3ucs2c6lsp7fxbx6b5tqmu2tdecxprok55@fdr2dwppnoks>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: 4B7AC40007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: e9mbooeecstm5sndzmpkc394nmm8s3i4
X-HE-Tag: 1756994066-369232
X-HE-Meta: U2FsdGVkX18SHZ/tG9GiHzHcMijGk7K5Ypzo7JfjbgMyyR0I+c/s9XjDwuT4PVU4QZbvBZMYijGYVifrDCMSYOx4hsctNsrknzRauVG9gcvgq6uTF6MOumSK/R/y1nTcwndMGvvkJGiG2lmk+/Auy5Lt3XjAHT5M5OvWmnxsKdhVig98LpqLpDKQsQtyN8YdkJTpfYkHqOGD3gP0eSXpcVfLnwR7b6BSj9Hh1cBb8eSPG4DxX8QMK0+4wXnkAF5+iBrFhFdJAMO8xUn4j979xmzeJl2GBw1a390PZN8GhZ6WCpoU42NvE4mlxYZHWI81tOiaIRVvfZ7FWhSKfrRkbtqGYL3e0aWTN7lfWnEcd+wai2Z0yzRNEyfL1AwaZnxcuuwfj15E1I23+1mUpxhxjcufsVTY1wLxyGeOCSSnkGKkJf6w/KkExn1dLGoaFO3EPyvWn6fD0+VmFYiYQiBWjCDmk+5DQ4bMg+xiookqQ7DwRMBsYXMDLRK5PPq9k7zuL/vcbMEe8Gpu0CCPVq/tnqSm5AQKBfXUmU0rGvlafRTn1QtlOzZXj1TqxYld0r4ikwbQpvd9mVoki968+woTy4pKnh50xjDzWmpXKqovRZoq/nXPiXT5KrJW/i6PU+D4ylnk3Jb6K0DOrznjbdzj0bg5HAzjRfKkQgPyJ67nn/gpQYr/FnahClFCdSEcohYio0PX0EemZ2lAv575GwWV5101MvGaXHd06WT5HD60GEqwHudD8DTPakiBRQ+/SDcpYIGEx8CRQLqnUYFTNCelwjj4xL8LMLUBmRA4An9H2eHRpkHGyCTVyvGPI88eUpo8h14qJCHo2isPDpVNZ2XrOpyTcLtjOqiFBhGSMqi5dGhvfizoMCX+ZowyjzIEW1ljbXQdI3HEbn0WMZJhSlAoceVxPAgAJq2rK8ngXmPADK3YNBOAgwintJHxk7ia6mJXeCdLnY4zKNJYAfrwGMf
 sHsUYXmc
 phw/nQD/AAZwL7qkNCcPA4ScEHzNnvUH+26umDTgmhd2k3IB1oDc8fCo8TTWIGq/qyX1L3TiDagioDsliWh4wfeJYbezgEOGaS/PTaKKNChY2ypu0EfYZr2D0Yi21xvpmnGouzF+8ZXEzm5MG3lMIE6Vt09RMn+UkKd6f0IpuHxZlRvuXHqaX8b4W6nU6RuQxaO2l9bPBeFZh1eh6SgsT7aQP6C/a9/Ord5RlT5kdRiOH7F68tSsT4/qkg7HPmhTuSB0LQ96Z1nWMdcF+X+Z0rSXBjUT8b20niISmp30tFG4ceAXGGZaciIneq0i7Oszz7Xch0qEzckxvUsOrG0tlHrHuJ8+nvDP+RATF/8N+2GOOyjDKHR8FZcZYAZ760FPiNauUL8ETLeGnpqreIisuTNmggg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 09:42:53AM -0400, Liam R. Howlett wrote:
> * Andy Shevchenko <andriy.shevchenko@linux.intel.com> [250904 09:37]:
> > On Thu, Sep 04, 2025 at 09:32:52AM -0400, Liam R. Howlett wrote:
> > > * Andy Shevchenko <andriy.shevchenko@linux.intel.com> [250904 05:04]:
> > > > clang complains about unused function:
> > > > 
> > > > lib/maple_tree.c:179:19: error: unused function 'mt_alloc_bulk' [-Werror,-Wunused-function]
> > > > 
> > > > Fix this by removing unused code.
> > > > 
> > > > Fixes: a48d52b2d21b ("maple_tree: Convert forking to use the sheaf interface")
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > 
> > > Thanks.  This should be squashed into the patch listed in the fixes tag
> > > since it's not a stable commit yet.
> > 
> > I fine with any solution, I just want this to be fixes rather sooner. So, please go ahead!
> 
> Sounds good.  I've added Vlastimil to the email as it went through his
> branch.
> 
> Can you please Cc the SoB people next time?

I will try to remember. I used get_maintainers.pl. If it's not enough,
can we got this documented somehow? Or if it's already documented,
can you point out to it?

-- 
With Best Regards,
Andy Shevchenko



