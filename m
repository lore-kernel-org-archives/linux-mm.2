Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC51CFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 17:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA1006B0007; Mon, 24 Nov 2025 12:05:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78CA6B000C; Mon, 24 Nov 2025 12:05:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9676F6B000E; Mon, 24 Nov 2025 12:05:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83A306B0007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:05:42 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31DBD13081E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:05:42 +0000 (UTC)
X-FDA: 84146127324.10.ACB135C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8250E14000F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:05:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hlZ3oPVI;
	spf=pass (imf26.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764003940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNTSPeM5VeCu4nRwYJ+51EAnkkPcSG9+sTLAdLqmTw4=;
	b=dEvHLOt8TpcTo3DAAV3nbUa9PR/1aGvDKyW0sMligXVAABDBRlXW1Ciz2LwCmPmmGGbOCe
	Kf61IC9H0xtNX6rchglbbPVkc5ohhjdMzy9OtJ3W5asPtYAafeQEXwMMxH0dLfG7BcEJ06
	64zvm2iimQIvnFFgGuOqQGjz7pSKVaU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hlZ3oPVI;
	spf=pass (imf26.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764003940; a=rsa-sha256;
	cv=none;
	b=Xsfj189F6kGSuxLN3mpxONa6Lge5Sg8JxG+B4klGL2wH/RFU+4iaKtKHMYRqeFFTUdxMWH
	ELTei6PsyaL6peKX1zd8adtamT0ZiVM8ny3H/GeTx3z3zemBxmNZ+MDo98oV0NH43DoCCy
	0YKfpkgZL6w6ovKD7+tWUgeRHCmxR7Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764003939; x=1795539939;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BFRGsh/G57/nCp02zG4DAl7w2UHEdFTFhg0Ep2EJJrI=;
  b=hlZ3oPVIyayG4W5PCrckM24RrSISO9/SLLPeQ+ubmYZtgYHkN89VSO1Q
   TjFC4E3dgLjaleYAVkzHJVAGIX9v1SyvZ0VfrWPWXyXAGUlcfo17bSuP7
   fK4ZT3pL3gHUoiUMGCMTEOAPL9bsLFzu+bVu/0F2vgetWhNC51EPLcXKD
   vhBHEvZNAKbSGb1S7ZqvDCyHoX6KS0RmbcSiUL4q0AWYXMBzyfF7NGVYY
   Lxg42dvKcevdklMr6P99MK4N6QoPVv1DUYgCRhZK88Ezdx8jQCwVuoIAu
   Gvi2hxPRdUyAvdGVtr9Sz7Q/Qkhmylf00ijEI0JOGKoS4Tq+UXecSJlJP
   w==;
X-CSE-ConnectionGUID: vZYl20q6SGOko0wYbkePiQ==
X-CSE-MsgGUID: yhfzBrd/QkG7F2qwygPOrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="69864643"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="69864643"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 09:05:37 -0800
X-CSE-ConnectionGUID: LNeMYZhaSq6aHIS5tAfYCg==
X-CSE-MsgGUID: b4i3KSt9S1mZxtRZe0tx4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="196545997"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO localhost) ([10.245.244.5])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 09:05:35 -0800
Date: Mon, 24 Nov 2025 19:05:32 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ilias Stamatis <ilstam@amazon.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, david@kernel.org, nadav.amit@gmail.com,
	huang.ying.caritas@gmail.com, bhe@redhat.com,
	nh-open-source@amazon.com
Subject: Re: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Message-ID: <aSSQXPz0f1A_Vb6Z@smile.fi.intel.com>
References: <20251124165349.3377826-1-ilstam@amazon.com>
 <20251124085816.07dbf5a4ec6235b2943840a0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124085816.07dbf5a4ec6235b2943840a0@linux-foundation.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: 8250E14000F
X-Stat-Signature: ofk7ihknz1p56dc1qsowyw5ber1wt49t
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1764003939-64862
X-HE-Meta: U2FsdGVkX19AoVmSocUZTgKDvNdO3a/KJrBs4Niu8+9ILmBfuzn0UTs+1kEQUxefE7zyYPKSMBfDBVNq6Xfp5PXCkIs22aRnThzxi1uqVJ3zFbL24zRwZW9abtkR4fNJIpFdz7lXvVraH/Sw4I9CTHdb0Vbl0IQnu+cKcBH8dktXyJICqemY/O5MYndT7U1WAqyOccAFwnv73j017lwG8fzcWJy0GkUvm4TZKj3uvu4iGq0lZHukBIxE7zRjHpviQ92sGwoqIpn/6ILeCHILYy5vXBbzuIPu8jCTx0G6DxFZCSAa5ekKbnOvMSRjxTEU4cheJW/uEe5K3FdM5qTrVWVdQiFlRA4eEKJj5aGCWcpsWHRsv1EKdImBFPKp3NeWZqsAHNbZZnK+EArd2R6a377LJqcRjQvyrsnmKRmNQkTs9j1jZrwVZApJJQe4pi6XhWypnHGHFWJVpVizj03xENPv5axHMmi51XxQBB2gMOF3NuTIVn1woNuTPx22Q5zA1VXs0+5ZJgiMy1UtqL8Su+3wBpTGKXAge7VhCKu6nOWwWOsZM93PCrutGYw62s/Y7BRfzbB+b8eThuMefDCwkgW4RM+889ujGYLeMJd7hpyuiRN2PAiFZXbxSnIna4mWQm2FaEM2sPNVBwZ4sOUMZOtf9hni9XwjX6XXagE5AiPxAJS5Pzj4w1c6cPI2VGTMSBCFs80UofXeK58pCem4ZKFhVdqe3nE6/Z9u9dWJajLHAvBaQVBsbGvtMM36O8o9wX76wu7yoi6CnLLTuK4h9dPkvy/m0IoTMCVBVeanG3oh1ct4qXK4+uRI+Z5e1zF6yyX/NsGn6oFHWl2ErlFc0Q4KtNsTdAj26LTF5L8AonXbqzVSs9FP1dNjKowq1N8nQMritOiWnX5RJsg0HrcIe+XC5r1j3D1wOfvi1LoG0Ymg1XhM3ESzSyWcXvFpHoZOe4RM0rEpabyP0b1iJi5
 PUd+v6v8
 a4TqckSNlB0Vl6fIck2nuBlFc4kjGE0gAgAwq1Qa+TdCWEHtbKizsivdNhEUqIWa6FMYqZtxjBibmKvm8cyHLtGdNd0g02zk5qmXjBu21MoO47npO7AQzMCtGDY6EsggtOUMYIQuebPztM+biOYN7mICZ2RQvERyE/2U0U+Zu/uGntHSpO8VIKSYGIrxmiHYi/DtX/uYtSvMIZK7qaTm2KeKGlm8St0BHGa8mYMQPHJWy79fzmi89iEOJcT40xNoBCIHgQstJLgoVUV/7oEQrTZAQh1DEpgBfX7tfScWN3QJ+mOTKolgg+h5lqKJkg7ONOxKDoL84Gb294znLoTUE/JDmkrnPboDg8f3o1MjEU+0mFQryyoN7hlk4qgyK1+q3bcRU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 08:58:16AM -0800, Andrew Morton wrote:
> On Mon, 24 Nov 2025 16:53:49 +0000 Ilias Stamatis <ilstam@amazon.com> wrote:
> 
> > Commit 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only
> > logic") removed an optimization introduced by commit 756398750e11
> > ("resource: avoid unnecessary lookups in find_next_iomem_res()"). That
> > was not called out in the message of the first commit explicitly so it's
> > not entirely clear whether removing the optimization happened
> > inadvertently or not.
> > 
> > As the original commit message of the optimization explains there is no
> > point considering the children of a subtree in find_next_iomem_res() if
> > the top level range does not match. Reinstating the optimization results
> > in significant performance improvements in systems with very large iomem
> > maps when mmaping /dev/mem.
> 
> It would be great if we could quantify "significant performance
> improvements"?

+1. It also would be good to know which exact function(s) is a bottleneck.
The mentioned change updated a handful of them.

-- 
With Best Regards,
Andy Shevchenko



