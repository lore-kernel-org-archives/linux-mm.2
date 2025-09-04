Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 169D9CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 13:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BF5F6B000C; Thu,  4 Sep 2025 09:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697106B000E; Thu,  4 Sep 2025 09:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ACEE6B0011; Thu,  4 Sep 2025 09:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE856B000C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:37:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E966184D63
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:37:37 +0000 (UTC)
X-FDA: 83851670154.10.B624B12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf24.hostedemail.com (Postfix) with ESMTP id 34889180003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:37:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LKjq9eg6;
	spf=none (imf24.hostedemail.com: domain of andriy.shevchenko@linux.intel.com has no SPF policy when checking 192.198.163.15) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756993055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ue5hcLtyaEEJTYDce2zB7pA8WAIXEXnLPjh3GyCuysY=;
	b=ldWrQzXZMqVMKQPQVygu/BNxnVd2AI0KXglriH/bYrrU7ZpYN/lGi9SKsK6+FxADTpHVqr
	e22tdGLAouAFagjERj2mCbP8EYMNlj8lATakq2EkIm4LlDbSLUWOBcwZkLL32ACYYC+IbU
	BkkC4iwYKpntPjv2zuVaVAOG3gs+J4k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LKjq9eg6;
	spf=none (imf24.hostedemail.com: domain of andriy.shevchenko@linux.intel.com has no SPF policy when checking 192.198.163.15) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756993055; a=rsa-sha256;
	cv=none;
	b=PPdRWdcZm+tgWBl7SgluvqJIY5BTI5GxwBj8CDfvAReAbhE2rHLmzJxWAvyAkijSak77CG
	x6yslyP3y6yGxjs8OH43PjOxRcLbruVdjCBKhqF476GfjEgynMTr4B0I9vJD5wIA23vJUo
	MuPXuCCCyqGBlCNZMDSmEDcvirBKT3A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756993055; x=1788529055;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=WU6tQpzrmdXl89ghGhurVpS7C+6D5xA5aYEdzDaTZ8A=;
  b=LKjq9eg66L304XgJQULdwglxIMLXv6sUfQsStM76gXT8l0WT+3eDx19x
   DlN1Sdb1JDHWu2TpdW8lyaBwtKjR3XpUtrY196Cm894bbv7/pKgQl+YiE
   h/BJQynddbgRKsxSJpgrSpaA9hSSMf8YkOhp9Cm6Xr4ouMHoPy+qxRnC9
   yRaa7xdFQNgbEbpOZgxT3Jv5cCw1A6jYlq6mSXe75EryWW2POuRHcCT+N
   vd1j87of3e2Pp+4EtxsJmvXVxa9KPvR3dpk7omtuL5N7cM2lH9La9g17o
   Mv+SmLadqeYMw3OF/0d4ERpISBeK19ueqR7s/GF3lDDTOWBDtMuEVCNK3
   Q==;
X-CSE-ConnectionGUID: kClkv+akStWK9htLNe4Xlw==
X-CSE-MsgGUID: Nb3+OhKLT1C8IWAY0Eu+Qw==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="59441411"
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="59441411"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 06:37:33 -0700
X-CSE-ConnectionGUID: u/UrqEt+SSiYqp+ytxt0Sg==
X-CSE-MsgGUID: bYfeoYc6SOO31hSDk0Ef6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="172001622"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 06:37:31 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1uuA9X-0000000BHSP-2wRg;
	Thu, 04 Sep 2025 16:37:27 +0300
Date: Thu, 4 Sep 2025 16:37:27 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	linux-mm@kvack.org, llvm@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH v1 1/1] mapple_tree: Fix build error (`make W=1`)
Message-ID: <aLmWF3V8ILOkL8W2@smile.fi.intel.com>
References: <20250904090423.2293933-1-andriy.shevchenko@linux.intel.com>
 <6nk7wvp2vbsc5myxnx4mfohpq4yk4ixazkvif4hntilpuz7jtw@a2q2if4nc7kn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6nk7wvp2vbsc5myxnx4mfohpq4yk4ixazkvif4hntilpuz7jtw@a2q2if4nc7kn>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 34889180003
X-Stat-Signature: 3fyfw7yokggpubnwsyypdq31ppq3bawn
X-Rspam-User: 
X-HE-Tag: 1756993055-318301
X-HE-Meta: U2FsdGVkX1/3Eut405HrrzagqC0o8qJEQfs+n9OcJSpLljAaDf0DqAnPYA8Tp5RuyGD3uufJaIBOE+IdqifbVwulMAXLYh80RlWyiaqz0yjtXgAOuA/vbcClcoET0kyJbf/wqo01A0IqXK+6GXUdp3Brhmv0TRFA1xmO4x7HprAPE1xVHj/F+Ck9xuDncRa8SPhO+9AADVp7mgrDM59zqDcTEJ4YuBN5QgDjqs0TjZdnbeN4lvmmDd8/57C9k0N8se5Hyn/TpY7aOtMeSRQsDHtSNQLU+wl+cX+znrMzU32Jlz1qLZ88k+xPdeqANqriLIhWMzJZvioX/chzWSMDitBIDqRhmBKWDm64/WUOMfkvIBifQkdoUuJW1Bn3lO/HBOMXjLY/92eFSNHgg9qAJcCP9V20hBBXysGvEewwdGVGWtiNwoZRWbQ78ANeOIfmz5hq8J6u6RWPs94Etym12Z/zApBCBpaYebxaEoM4vCaVo0QpcQ7jUGAhdDhQaUunIch3dorGBR4qFmfZrbk9BpA/B1ubf54Mippsd7rCrrgxMWa2zo5wNXxxbMgNi4maVfSgVj9ct3DwZavc6JLtz6uieVaMEX8SkX6fMrgkp2tVd3HzKiOcaYO7sHae0eMyLbi9Hc0/fN0/zo0sEIES1m93xSijGkNUI5fJZ2YiMkS3lDScbOh0n/0pl58cKuWwuO2XbmJB2DcCGdBLMg5k3nlKsOqvaXf9Iixc9sKr5Uf+yO9M1HLiahltb1EoHJuS7ZSpTR6v9+oBmX+ktwfl7U24jXk0pMrV4Y99d/8p5z3wevTbK1LKFscFVkmzMWUFqaW9P2QqaHJdq0hHbISL8EgzllRpImgWo03YHWeP2a2USfZLfGkbntMHuJ9N/fpbVLwheqIwh8BKW2r0LYBF70CXUx5pWq637Xo0wgKzbt29x+5x2pHEwtLX5xtl515B4HD2P2IccHmLKlyyhPj
 tDikpW1K
 NmTuMfhIXnl8J4r+xVC7+mFAcjB96lj02H5KZl83V+7yyS+g455K4XGFzcn9866W0x3hGwKZfIO3YwUx9pq1QalNoR0xGX08qOfjJBGt6pVkcpSutdNPp+f8GWqCul+qD1yo/VQT9sMgDzSL1rZvRqif21BsO7+QKlr0xE6BMhBmv5jgP5GbNdKTP1NnJyOmywzIWKRGKa3nnGEf9BguKap865J1KLP0+rQROvx26TZ+1HN0D4HOJkbNgO5SqgHr6/Y89TizdMvxIB2vlEMRgfTjdE29LFSbVGz5rD+Vh5WlL4qgL+W+Pez4cxUG43QF9kl4itFrlwmYheonBxhL7dyj12Ha3gj8egH14R65qLw7KAbTo8hfDdu7ThA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 09:32:52AM -0400, Liam R. Howlett wrote:
> * Andy Shevchenko <andriy.shevchenko@linux.intel.com> [250904 05:04]:
> > clang complains about unused function:
> > 
> > lib/maple_tree.c:179:19: error: unused function 'mt_alloc_bulk' [-Werror,-Wunused-function]
> > 
> > Fix this by removing unused code.
> > 
> > Fixes: a48d52b2d21b ("maple_tree: Convert forking to use the sheaf interface")
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Thanks.  This should be squashed into the patch listed in the fixes tag
> since it's not a stable commit yet.

I fine with any solution, I just want this to be fixes rather sooner. So, please go ahead!

-- 
With Best Regards,
Andy Shevchenko



