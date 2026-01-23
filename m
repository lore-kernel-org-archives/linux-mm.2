Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4941ED72347
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A592B6B0457; Fri, 23 Jan 2026 03:46:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A311C6B0458; Fri, 23 Jan 2026 03:46:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A206B0459; Fri, 23 Jan 2026 03:46:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 831046B0457
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:46:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F093C1AFE
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:46:49 +0000 (UTC)
X-FDA: 84362598138.18.82D3D82
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7259B20003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:46:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JaV05bai;
	spf=pass (imf13.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAY8O7YOi+dEDxNM++qodOcwNRnUwrN2mf04X/KuRWE=;
	b=JwHbEnQk35gPf83hdlIqEhgI59gCnZcNKSk71aDcnuevr6h54zDv3nAM2BIZmYfdl/c12B
	nDP1hMDpIrSPGl6Zk1+ov7vpUY7PyI9NFwmHWqyFkkeDjvxqHyMjuGK7iVOgdKArPTd1x1
	YfGaRE1GedA8NqUBy3LofAn1D6Oc9nA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JaV05bai;
	spf=pass (imf13.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158007; a=rsa-sha256;
	cv=none;
	b=uhuP4kUpb/n+s0shDgRXhHRugzHVSL/oRNAqUUZB4vXF1hTdC4F+HqnQNiNiR0iiMG4A3w
	ZYmERH2y2W/++zUrdUxPQkpbgklCxf3bR20i0LbNFiLtTVXoZeG6n862HMP3ad5wJ1Debp
	2gvhOGDZEc+cV3bSa1Y6v4sfDm0sIKI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769158006; x=1800694006;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yxLPZsI3BlaCXSYy3VRdvRI8ej/dhsqIiU79HyiDkSY=;
  b=JaV05bai+se7RdmD9c7IRcNcv19b6AkcUVDPVT2NelJbbZ0XCex79+WL
   dBZuNpixrHqp2O/mIlFk4t7vw/iQRqLwWn0C7h54mnumktprnKBmTNRfW
   FXNTfIJT4P/MJj4PkVD51RLzjTysztnAw6njs6d6LHSHb+lSB6DY1Oj2d
   zgj9LzrFZk8PgAt00E4JBL26WovUnVQATlxtBwBgjPMbIRZQFarEAo9gy
   gUU6EyXaKG2kcYmbqkKUC/L14jijGLthZKKyOky9jJJvNmvWyTVWcXJ/M
   M9kN3sjb5njdUBczVeKvsw2ULR8qbRgK8RE1uJhb/q79i/NggDIturZ4b
   w==;
X-CSE-ConnectionGUID: gS3KI0/JSWC5vQWx5jUd8Q==
X-CSE-MsgGUID: jBmQa5h1TzmaqT2jUm9EnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="70310704"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70310704"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 00:46:45 -0800
X-CSE-ConnectionGUID: I0uBEMeHRLq8+KZyIRqqfA==
X-CSE-MsgGUID: fUlz+CFyRPexsZDcn7SC4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237621745"
Received: from rvuia-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.112])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 00:46:40 -0800
Date: Fri, 23 Jan 2026 10:46:37 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vincent Mailhol <mailhol@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Chris Li <sparse@chrisli.org>,
	Philip Li <philip.li@intel.com>,
	David Laight <david.laight.linux@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH next 11/14] bit: Strengthen compile-time tests in
 GENMASK() and BIT()
Message-ID: <aXM1bWepP2sVy9qA@smile.fi.intel.com>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
 <202601221237.soiAkwkN-lkp@intel.com>
 <20260122103337.26473d1c@pumpkin>
 <aXIzpC6wpdv47cSH@smile.fi.intel.com>
 <aXLOELiIG8MHKcIO@rli9-mobl>
 <b49c9993-7676-4d33-a2d6-9f6b77b0fd34@kernel.org>
 <aXMtJ_JurQjvN4tU@smile.fi.intel.com>
 <20260123082027.GJ3183987@ZenIV>
 <aXMwIcH7Zh-1yNq3@smile.fi.intel.com>
 <f9fcd1c6-373c-4345-b413-9bb6c1cd2d3a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9fcd1c6-373c-4345-b413-9bb6c1cd2d3a@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspam-User: 
X-Rspamd-Queue-Id: 7259B20003
X-Rspamd-Server: rspam07
X-Stat-Signature: kiqb99shao6tbxuqd9gswjg5q7ax31kt
X-HE-Tag: 1769158006-96745
X-HE-Meta: U2FsdGVkX1/UZ6NyFS8kvN4E+gdf1k565DO5F+aPhB01Lc8/2FUqtEg+8Xt7eMlI1sgXd5qTJMggO3hkm1dPigOQePW+RuoD5dbgoFeZScJM8kxA2/+hD2piVizognm/epbtKIHKRw3xqAU1kNXzJuayb0uWkpLDVo/mnrGosDEhHoEUuIdJEHCIL5C5t/r+u4Ka+llNN/rRL3w9aHYDUojupVZJzx6zFnZ943BNIT/mRzUp1RKYryAN85XM2O5+/2pmp5t9CbH2QO5hnbekeNANNkUBKsGwMvCtlM87aTdhPasblyB1802u1a4QoCXa+UVt/ATrkuakTzbWANdIXLg+f1pkJ7PKQIfF6HlvF/blbviQnHC0AwAYIFGrLOfnXmGSOOQszWjbV3P0tpQwkrpg4QRXpEUPxNIDVQLq/WEVvUFkuR9P1sQheT0L2A5+I/1MSfYHTewcmBKeS+K3BHDFqI3blLHwKhaTkw1Gx0F1h4PsTmZR2amZZKGpAsogo9I4qObZc0DZDE7OpvlvxrQ6cYCcrXsCbmhUa/z/PTvs4obKsBSdvdXBqPa/3Rev+/i3hnHDg+dRMhgnUi3KJleEx0XGWwweQ7QM9gTz9q3a+SKlBAAUD1q4Op2T/NofYfYPWU0ISd+cuR5RzKYKF9Oc/vu0FjbxYbD9cgonsTVwEkQWwSZ6UGwtddDFU5z9PGodOX1pY0iYN5Cn4x6frxnnxE59vOLJoYklpmY2SAFVCaIbE5cpEjc4OEixkDcerIVOTW1NrKKf5QM2U6oEuOpSDiKlM//xOcnBcx/EboUju7JwDH1RfjsXiovEiKXQm7uI0b05ImqFkYya3y4KelGSBmuIXAyKoOHdM7HdhFyX/tJxP3xDNSNYX+FKrRymdJj9Powr69J2AVhm+i7Yhs2xdVnkbCaQCFLjHwkXrtxE+2cki8FtZeDGDAvuMCV+AFCFG6sAKrkMjrBlbx8
 W1k6kBJH
 TT8lyt2/jTwQdQvRHUz01UqWkV2nMkc9DrE67Y6H6YwBT9aOWWsNKel8GLEq0T1QagFO8tPTdnD5HyIgx6vs0HpUbk8tkBKtFf/Jau/JZRAiuFv4AREU3SfzthRyST7pE1JxxwxiNatLeLYdHehCniZ03zYwBLsv0dYFw4vEDPDjdjwarkLjOdCw9mmRt1hhcVE6BiZb9chdnQ9sBcom0m2zQ8q/ccmK6G8tysgETI1qTCem6wEqoNjfreuLZ40wopHJm7z0c55gt1dW4PnEXmDPh2xxTNzMYga0zKaPJQJqA1RdPP4NdYy7kZ/YSM99GgCgCjkp9Y+yv8ANuBmv3SFU3MZCAptErHG7/qYHlJCPb3oWctjx+Dmb4Il/845FuekXx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 09:32:39AM +0100, Vincent Mailhol wrote:
> On 23/01/2026 at 09:24, Andy Shevchenko wrote:
> > On Fri, Jan 23, 2026 at 08:20:27AM +0000, Al Viro wrote:
> >> On Fri, Jan 23, 2026 at 10:11:19AM +0200, Andy Shevchenko wrote:

...

> >>>> Al Viro's fork just adds 8 commit on top of the upstream sparse repo.
> >>>> Wouldn't it be possible to just merge those?
> >>>
> >>> Ideally yes, but you also should kick the distro's asses to update it, and
> >>> the sparse should bump its version...
> >>>
> >>>> That would be much less confusing.
> >>>
> >>> Seems Al become a sparse maintainer de facto :-)
> >>
> >> Huh?  What happened to Chris?
> 
> After the project hiatus, I can imagine that there is some confusion :)
> 
> But Chris is back in his role of maintainer since September 2025. See:
> 
>   - https://lore.kernel.org/linux-sparse/CACePvbXDO1ZybDu3RaFhED9D-9gC6LTMpWrxoh5xD+ZO5SLdzA@mail.gmail.com/
>   - https://git.kernel.org/pub/scm/devel/sparse/sparse.git/commit/?id=67f0a03cee4637e495151c48a02be642a158cbbb
> 
> > I don't know, but upstream sparse haven't applied any solution for
> > MODULE*("FOO") stuff, nor reaction on my ping in that discussion
> > (I did it like week or so ago).

My ping: https://lore.kernel.org/all/aV9vo7_turBr84bs@black.igk.intel.com/
But now I realised that there was another version of the series, and Chris
seems active there.
https://lore.kernel.org/all/CACePvbU5Pqo=bw_j8arOq16o1JBOSwPtuMZBVozy4FV7YsSLGw@mail.gmail.com/

> I am out of context here, but were the correct people CCed?

I dunno.

-- 
With Best Regards,
Andy Shevchenko



