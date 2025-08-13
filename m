Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67C5C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5208C900077; Wed, 13 Aug 2025 09:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7D5900044; Wed, 13 Aug 2025 09:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BF46900077; Wed, 13 Aug 2025 09:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 214C1900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:39:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE17DB8DDA
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:39:17 +0000 (UTC)
X-FDA: 83771840754.07.C899798
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6F7D3C0008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:39:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="lMj9/Gvi";
	spf=pass (imf10.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5CGf20IPkVI6PZVkQXkGOe4NEzonHLIoh9N5wURCls=;
	b=g8q2CbNgPYAIKoWBtKSoskjAWC1xmUoU8UzpCHh22HiqqV7AkAkdsEyXoWUBRnq6Ao1l6Y
	51Csm5FUvJ4aKVmFhQ5v7JTzP0qz2NWkPdq53zcgZIUfzA/vAJ/JYunV3dSbpVVBpclrnp
	r54j0ePd+D/VPUDzYoa6OLJf4wKrKmA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="lMj9/Gvi";
	spf=pass (imf10.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092355; a=rsa-sha256;
	cv=none;
	b=YL9HvLRZ27jWAQbcdpffi+ggE6y3cqpoKADqzGFPp4l2CbGOVZdZJUKBQmDDqhboXW+oCC
	med/Z04kgKJcpTsJER/5MYu+7fKeVpjbf0CSxgu3C850tVVctQHj7hkw3Lvkn4/APydO6+
	+x18fUiedWLeDDnHSXymKI4nSL9kY9Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755092356; x=1786628356;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MgEKOEyyAEorH8iuoL33yXvGl8kuoAn+H2uLs0OHw6M=;
  b=lMj9/GviaHvUPpJz0AzpjbOH/tPvp2aeQ0FL73PSyodOfAsCYDHXg+wg
   KBjEJI8xOPrKVaQ8dcTw39n13UtxfUVy1Ge1PQRXS9+RtRxqV1gixA8qe
   5hK3/vGopQvtQp+VhB3Qz0wiScLpDHxq2ovX5dM34unDD8PxhSrziHP4E
   obiwTlQ+TOi6tIyWWFHkyAbKaMeFxSoF6sVzudTo3QLnlPiunAh6wfTy5
   X77QCI5GF0vodczCPBcI9x9ac20qW+cNopzTjeZk/0V5/hOICbkzZR3nK
   MOnV1n7RPnQxLNHX7Yc7E2XKJ4SGvQKN8omjUe/J1toGMyJhFcLR3z0W+
   A==;
X-CSE-ConnectionGUID: ALDrlcBzS8KzL0oSylXRdw==
X-CSE-MsgGUID: yf3zaMWCSFic0Tq9zEHJJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="44964704"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="44964704"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 06:39:14 -0700
X-CSE-ConnectionGUID: N7uaji0FRw66mKcsookEbg==
X-CSE-MsgGUID: sjsF9VtDR4iwOeSVE/y+eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="170683697"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa005.fm.intel.com with ESMTP; 13 Aug 2025 06:39:10 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 2E07F95; Wed, 13 Aug 2025 15:39:09 +0200 (CEST)
Date: Wed, 13 Aug 2025 15:39:09 +0200
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
Message-ID: <aJyVfWKX2eSMsfrb@black.igk.intel.com>
References: <20250811-iot_iter_folio-v1-1-d9c223adf93c@codewreck.org>
 <202508120250.Eooq2ydr-lkp@intel.com>
 <20250813051633.GA3895812@ax162>
 <aJwj4dQ3b599qKHn@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJwj4dQ3b599qKHn@codewreck.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6F7D3C0008
X-Stat-Signature: xttr8hzhu9z3bcntymu4zrpbjraiutre
X-Rspam-User: 
X-HE-Tag: 1755092355-828826
X-HE-Meta: U2FsdGVkX1+/vuf2GoVNwKW9MH94FQC7TB1Vx++n2tpvCdm/ewAGxvgHZQQNlkItafNsDtSGk1bugI6diMtrjQ5gV3242ks7WiT4XsaaT4J4/9Ujd19+Bq1/dFTtcmLzHV0YjcqDwFTHFJlo5TRbXcpmf9m3YRdNjOCqSGbVQWP37YMRvoUJprUlUthzw5sCsvvUew3nHEu6ULih6zIBCDKTS3aGSurouK2KxYUVYLheVz5+oDchQMUQ9HJ7esbbVE2iI7SgGABKenzK+atONuAJGXGeTjiOLzXNWfjxJZbEVawomeFPWelDWIW78WPthf8Zi6CpakksOcBDUpcFnFRttiFt4oPkphd2LU32+6Jkrl620GfdqNWuVmhNrVyBNMnTS0KODHCi4Av29Um0Sw0bvfolY9wC8CERIqSzPNTB6UDd9AgjUN0kgW98redHipDYynyF5zcDZD8BBa9Brpgb4I7PZP/tCp5RUf0e2fX75956ByCmkb2sKm0SmqiJ2yFKzajl91ekm0Fjyg5fhym1rDloZNKPK3Ks7lMocgoQA/dX95btNr88C0bWx4XpR0bI3whXuJEvuqSsk42DvnMJnxUIzZqIA3OKcSnDFFz46KISXOT7fI0jZoWAk75GQkqqUme4LODaSaen/V3Ggmz/0dgq4OZgBfPHjXG70wfTcxBHFomirLZEjD45J02EVitD0lT8zi6sCUGXMM+ShK9lHSmgOAbMT23zamwsRtIVatHGN+IZE/hfhg9V/rESOoF6T8xACL6LSa5KGgaRLObclO/fbxBu7/zbiAazaZ2Kx1b0weJe6ei8ZHZdoWR47TdyJtw+G74YBKEWsana0WR7qYTXHQuD2YzHD476YISGo3UIzOE36FsdP945joUrGkheOoE22j9n0+qMFKe7DC1JgXV4WEwAoLMtlvCebG7TdrY5BcLU6H72JNbhZjbXs3xyKn/qb+OkMlqMpbS
 eN8LmApZ
 IGLtQuqAzfDTxKkhp0vHtAxfmjYS6alGnufO7IZOHZD9/Io/fK+nZhXGacd2ontwAxszrkctOTZNmCCjdyO/K55/Ox1Ze/gsU8yHXQ7AOtJB2CVA5u2S0yV1oI0XSBsjRFvd47L1gms4uOx5LYNEXdanOy/90X40umZ2YnJVBq3xRS48Flk8lmbO+aRgJfTTYLEkwcBauTbtAVSu9QVuIbGwJfxhqVNgNH3mqbwQkFNWrBMlc0EM9JQWix1kEdrvMJU5IBJbqal/sMyeBgLX4chw3pbPtt3TAsnUrDwu1LGSLh9HOKyQ1GLfkCic1g9IudcYPQDJOXmgm9wFZ5rpgr0i3dO2wlDaQOA2VqaEwvZtSA8mBLxLZDcWoX4xCSQcMFLc+Q5PlDhOTc3g4suuGvJgimT+IA0F+bGrNJ/PAEiLEMPuZC3PyjRq9bd9dtHAker0s5fPOAREidrBVEsbWpTdVB0kf0LVQiwX8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 02:34:25PM +0900, Dominique Martinet wrote:
> Nathan Chancellor wrote on Tue, Aug 12, 2025 at 10:16:33PM -0700:
> > >    1 warning generated.
> > 
> > I see this in -next now, should remain be zero initialized or is there
> > some other fix that is needed?
> 
> A zero-initialization is fine, I sent a v2 with zero-initialization
> fixed yesterday:
> https://lkml.kernel.org/r/20250812-iot_iter_folio-v2-1-f99423309478@codewreck.org
> 
> (and I'll send a v3 with the goto replaced with a bigger if later today
> as per David's request)
> 
> I assume Andrew will pick it up eventually?

I hope this to happen sooner as it broke my builds too (I always do now `make W=1`
and suggest all developers should follow).

-- 
With Best Regards,
Andy Shevchenko



