Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2F43D0EE13
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AF336B00AC; Tue, 25 Nov 2025 13:30:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F786B00AE; Tue, 25 Nov 2025 13:30:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A376B00B4; Tue, 25 Nov 2025 13:30:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D33DA6B00AC
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:30:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FB6389538
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:30:35 +0000 (UTC)
X-FDA: 84149970030.30.7620457
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf05.hostedemail.com (Postfix) with ESMTP id BEA24100018
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:30:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="TJu4/ld/";
	spf=pass (imf05.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764095433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPBrH/9qk4A+nmQTJsSj5jEIcwSTVvKo+U8W1QOH8rg=;
	b=oBnlU8E8RmdT6OAND7LfR/TIwZ55hb6+URei6T8upAgVG4eGbsgWV0rVgJH9tVdp0DAAUj
	GspLRx3YcF5nA25xn2z4rDEFD12P7Ax0rbL8DF34WlfN+XivLNPEAGNj491AS5stRMQulX
	La0AQDpK47FIrTym6PoQKnJNJgMuPkE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="TJu4/ld/";
	spf=pass (imf05.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764095433; a=rsa-sha256;
	cv=none;
	b=rMXjDMJ5YSynu4RA/En0GxWH2JRaxcBQM3FqBE5KyXHWrD49bQ2o960shKqoKOGMbRqksc
	csQTI/cmRk88gsUAUzUd2oztZFgoVXhQFwPm/ihFnGlYIc4leESmkeHYbmBWptAGsOlh6Z
	y1meooy10IVTarbwzcys3RtLFIOkDXE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764095433; x=1795631433;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=NUvziSnwUsI+BlkSFwglbw1GmZ09Ymmocff6QMzrKcg=;
  b=TJu4/ld/ZtT3aul5WORvdHSmpHE/HPk/rIGGMUh+dWI4gbLHyoSQI+E1
   y/8MUe7EKsq8kdM1GUK25vTowkag7QqOWMg/NoVTg06c5ad7tvqZ8NDRf
   E3TVGbbq6F3eDETl22ZOjlOnnUILgP4oCNC0kJD33d7W672yH066shdsj
   zMedLm2DYyGkb/XbonvpWb7NzwoWFIf5qc/WLlKIQNxsJrl2h0goAXPOb
   Wo7IEN98UtzHQ6P/+umXitz1GUMWIrZoEaF3hlczPgKK6mNf99Z2+90zV
   IFH6bWMl3phEpIlu6Ki9bDCkgUoRxlJOAcVsEwDxPmD7+d2wLyY2ja4Z2
   w==;
X-CSE-ConnectionGUID: MV2kATlPRRKNzDru0VX+2A==
X-CSE-MsgGUID: CMTQeOnkSRi5k8E3dZm1jw==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="76807633"
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="76807633"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 10:30:31 -0800
X-CSE-ConnectionGUID: tN75m1bSRkS2URnnqoiRiw==
X-CSE-MsgGUID: unu7x+RiQCuE8AgZ4GThDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="197818542"
Received: from ncintean-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.22])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 10:30:29 -0800
Date: Tue, 25 Nov 2025 20:30:26 +0200
From: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
To: "Stamatis, Ilias" <ilstam@amazon.co.uk>
Cc: "nadav.amit@gmail.com" <nadav.amit@gmail.com>,
	"david@kernel.org" <david@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"huang.ying.caritas@gmail.com" <huang.ying.caritas@gmail.com>,
	"bhe@redhat.com" <bhe@redhat.com>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>
Subject: Re: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Message-ID: <aSX1wgqlCj9UBzCR@smile.fi.intel.com>
References: <20251124085816.07dbf5a4ec6235b2943840a0@linux-foundation.org>
 <c7411175b332f3befb5bebb6a75c7b91f2c1dbbc.camel@amazon.co.uk>
 <aSSqIzJWKTe9hs2f@smile.fi.intel.com>
 <f3fe7efd74c6011ddb35e1f1e90eba43af864aa4.camel@amazon.co.uk>
 <aSS3kXfoBppO1a-Q@smile.fi.intel.com>
 <de5d9d0658a8966ad8e523a84185398c216726fc.camel@amazon.co.uk>
 <aSVRrEDV1hWKhRmp@smile.fi.intel.com>
 <b9f8623fb383ef21bb47e6c9716c2c389581d12d.camel@amazon.co.uk>
 <aSWDvPVZRTCCfRpV@smile.fi.intel.com>
 <265028eb24f60ce45725d7887e93f76a3e86f897.camel@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <265028eb24f60ce45725d7887e93f76a3e86f897.camel@amazon.co.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: BEA24100018
X-Rspamd-Server: rspam02
X-Stat-Signature: pjy3jkpb1tjddjmg1yogz5j35wruynyw
X-Rspam-User: 
X-HE-Tag: 1764095432-589249
X-HE-Meta: U2FsdGVkX193eqRDkt3nL2s1v0X1MO0k+pDGPy6Izom5F0Gx7VYW4zTk/Rck8LkMzPVZv8WXvCIfQF8MWQTPQPIokJixrdSeZwrGtPXlgEwVt4kxPYPhKg0w4eB3HSIjUvEPgwTH7+YehOzhQgw5bux8WpHTPXJi4PCRuenediUSQLGocCnIeAeXkhhux0BMuLoFYXtyGYitp3Nl0B8I6ENxy8b6ICPH7aRGYtGzg4x0Qm0T1rFfFbVzghwra5tswxGUZIEBEOSayxt5eyjRULHdGP9Pono6OoEgVyqRH4Vuz79vjUopqy4DX/fwL9m35vrPCTVWYwBgJ7tXXlduIQu+uOUID4q7dh0TFxeTRND2tfV4XKRoy1QsxJ4RQCf7ZKlwwoauFPE3SD7F7rZl2J1KKBa0/xzgw2Zdnx40Z0c3Gy8nSYRIV2PMresABjihph7f9RdN/0WmKs/m23+BegJddTrikGVgfLsJMRtbvDqJAENbJ5BmLOs65LGgzYkLg2oSJUU3x1NDhMbSIgsnWZBmbxyWzbFr6+Ga+F2ucOOlcfu3nuCsW6ZCJjiC5LoEzqk6V0l19mqwzDXkRYDiKTZQccy4W6Q145e861UNbcK7HTDOUUC/tHRsWWSoys6GipH5wpHBOtTJyTGTkkjvHeQCwQuUWBRn1ujPPrzD00TiPOMrd+Gy4i6wyZMjbU2bj7alGjwb/ZWNXbakeJ+Bd41EWPBK1noP7d/2aKpAU3t+thgEgDRk3GFcNt/fJY21kR7jePu+mRdGis9qDIyjzqpiPLn3cv+xprooGei3zqX4ty5wywWy3wlDo3YwXroMkfzjAjq0TewSIFdAEJZ6IUJBzeMD4BezXWHY7i1Mz6zkX8eQN/qVC5/9D8VuzHoFzr215/P0mb3OCzQybTkmGYWygQbqPAw1F/0fOluherRnlR+4n9C1K0YtfxhE9kwJyk9+9DxswKakB+bweGb
 dQGiGmJM
 d7NhTpuV4rgY/Fz+MNo3f6SOOUhW4cZ7JR09Yaj33RiHa5LLBEGdkQqnRDYn7itTIxcCCpVtTs4hHIV3imrbjbB7kspoKCX6LnTQfNhVdJKJGy8k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 02:23:38PM +0000, Stamatis, Ilias wrote:
> On Tue, 2025-11-25 at 12:23 +0200, andriy.shevchenko@linux.intel.com wrote:
> > Thanks for elaboration.
> > 
> > Please summarise this, add the performance test results and send a v2.
> > Seems okay to me.
> 
> How does this look?
> 
> No code change, but happy to send a v2 if that makes things easier for merging.

Yes, please do.

> Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"

resource: Reinstate "avoid unnecessary lookups in find_next_iomem_res()"

(always keep leading prefix).

> Commit 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only
> logic") removed an optimization introduced by commit 756398750e11
> ("resource: avoid unnecessary lookups in find_next_iomem_res()"). That
> was not called out in the message of the first commit explicitly so it's
> not entirely clear whether removing the optimization happened
> inadvertently or not.
> 
> As the original commit message of the optimization explains there is no
> point considering the children of a subtree in find_next_iomem_res() if
> the top level range does not match.
> 
> Reinstating the optimization results in performance improvements in
> systems where /proc/iomem is ~5k lines long. Calling mmap() on /dev/mem
> in such platforms takes 700-1500μs without the optimisation and 10-50μs
> with the optimisation.
> 
> Note that even though commit 97523a4edb7b removed the 'sibling_only'
> parameter from next_resource(), newer kernels have basically reinstated
> it under the name 'skip_children'.
> 
> Link: https://lore.kernel.org/all/20251124165349.3377826-1-ilstam@amazon.com/T/#u
> Fixes: 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only logic")
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

The rest LGTM.

Also, if required, make a comment in the code aligned with this new commit
message.

-- 
With Best Regards,
Andy Shevchenko



