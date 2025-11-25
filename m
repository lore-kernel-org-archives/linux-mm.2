Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C094CFD37F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 10:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0D36B000D; Tue, 25 Nov 2025 05:24:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61196B0031; Tue, 25 Nov 2025 05:24:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9E2B6B0062; Tue, 25 Nov 2025 05:24:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A915D6B000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:24:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DE79BB7CD
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:24:05 +0000 (UTC)
X-FDA: 84148744050.18.A30BA55
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id B645840014
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:24:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JnWfmxlY;
	spf=pass (imf12.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764066243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edAiJSTSGa5QPohWJcC6urhFX19eDaaNWnRGWXoJVzA=;
	b=DQdlWswmwhJIH1vum+G+TzfD0xpatMq3UR4uwqEeePf0iyuQGDfT9K3H7wfKqRxyNPWYvY
	sH+gMPKyibIFdGJ0y0PfB3tv7ix5AvmZS9eLCXxR70Ud428y5xllTjHOax2agG9/a59WzM
	QYpkt4lLyx1P4uHgZpMeujBgugK1Kug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764066243; a=rsa-sha256;
	cv=none;
	b=YnF3r8LMqpmQyorHGAP0c59e8f0p+4r478rQobp204CgXWsNN46maEqDARupCM8ad1k3n2
	A6hG3NXtSIfwtmAnxpD2f2U+nsX8vdLC/YoBm2cQN3PwXnmYn24jc5uCMGbVndvxu1RdyQ
	Kw0bIkpSvSLirsSmPG6B2AStzgXyPg8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JnWfmxlY;
	spf=pass (imf12.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764066242; x=1795602242;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=VyZt21DwQ3vPn9KNWUNLNyJdvbaxb1/cxFvzwpMVjiE=;
  b=JnWfmxlYFT2BybLNNo0hsvwmytK8lzaGua9KbyFGETKBlNbwVUquVpKC
   z99CD8ry17rRfmixmJVi51BVOawQUuu4UPpSKHX1NnfTBttGuwlllJKzi
   WecgnRquafvwHgnIDRLrlCVXhmLc0PUvERqwx4h245Uyd5r13tK2Wvihn
   9FJYMuUCDqz9ip8l7nDARgKUr3fcXFaZr4HTSCLCrrl5088PDNH9dB9Ux
   vgPQoWOJyWz5lJkXOuvAsRix+ahFcGWlKB1IYcDFqKL7zXrom/nL5vEFx
   ZlehN/vECfLEba+taRmeHUX7zJ/Ctd19wB2NwKQuzwctibRvVwWnZIuRo
   w==;
X-CSE-ConnectionGUID: 1BcW1CnQSUiyZkqzujJpZQ==
X-CSE-MsgGUID: w+5RpeKiRdiUpnFcEB20KA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="66115278"
X-IronPort-AV: E=Sophos;i="6.20,225,1758610800"; 
   d="scan'208";a="66115278"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 02:24:01 -0800
X-CSE-ConnectionGUID: RuvfkC8PSQOdWg++dunKbw==
X-CSE-MsgGUID: iaJn4sb2RBOUOVBJp1O2MQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,225,1758610800"; 
   d="scan'208";a="215953712"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost) ([10.245.244.152])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 02:23:59 -0800
Date: Tue, 25 Nov 2025 12:23:56 +0200
From: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
To: "Stamatis, Ilias" <ilstam@amazon.co.uk>
Cc: "nadav.amit@gmail.com" <nadav.amit@gmail.com>,
	"david@kernel.org" <david@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bhe@redhat.com" <bhe@redhat.com>,
	"huang.ying.caritas@gmail.com" <huang.ying.caritas@gmail.com>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>
Subject: Re: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Message-ID: <aSWDvPVZRTCCfRpV@smile.fi.intel.com>
References: <20251124165349.3377826-1-ilstam@amazon.com>
 <20251124085816.07dbf5a4ec6235b2943840a0@linux-foundation.org>
 <c7411175b332f3befb5bebb6a75c7b91f2c1dbbc.camel@amazon.co.uk>
 <aSSqIzJWKTe9hs2f@smile.fi.intel.com>
 <f3fe7efd74c6011ddb35e1f1e90eba43af864aa4.camel@amazon.co.uk>
 <aSS3kXfoBppO1a-Q@smile.fi.intel.com>
 <de5d9d0658a8966ad8e523a84185398c216726fc.camel@amazon.co.uk>
 <aSVRrEDV1hWKhRmp@smile.fi.intel.com>
 <b9f8623fb383ef21bb47e6c9716c2c389581d12d.camel@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b9f8623fb383ef21bb47e6c9716c2c389581d12d.camel@amazon.co.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Stat-Signature: u9yidryrntcxxtrxk76f4fxgcdakxash
X-Rspam-User: 
X-Rspamd-Queue-Id: B645840014
X-Rspamd-Server: rspam01
X-HE-Tag: 1764066242-218831
X-HE-Meta: U2FsdGVkX18IvlajG+CxsMOXGdP1IgfJUr6pe5VuZBk0YOlOWnqBoZXBvkro6Mcnk8ipdmjXEXvddqJY8SXFwg9LQzdwGfoyG1ZUPI2I3eyTnHY2tnNk3PxiidZqbq8NBjVqS9vr3D2PbxeU42vTfOG84cYTsDZm9eylN4XHo8A0mVHO9SFXx0wRyl3n15mGr9McVddXMHthN5hejrvSLJQJ0XcQSNIXcjAJXPX72YJ9XhdyETNzOY1ElgiVfdxLK9icBK/vdowngHiDhooBdqmz2X/Sq0S13xRP+FMgqBzNsVpJs+dpMpMIs3/oBVntaJhuKbu+sG5Se4D7BQpJuRjHlaMhRuHYGTXGWCuqpT3g3ueaBxlGmzspK9h8+DiAn6v8yWddxewcjnuGsl4Ngkah8Mgso5wkZKiENj6M5bqRjAsVT/S9RflRaeRxYRE1JQI8ACk9clFkNrnBKfrHwKe7xUYYLPLSw6Tm5tIUrsBNL8ljiN0pm6c5q9CKXYbsTXmMwN5OF+Tg7X3AZ9DWIGMbXekvtBW7xksem7ExUHEiuVFkOfqjzVIDvqe3wyx1hUOD+gtJkBKiP2tg8cScCdLEPYtAHhChrIZgC2Q9Pv0oPxNzKop03duYRkhxcAd5zILI1XlQMLr5Y4pr9gT6cJrjDUtQRE8dpeyuuX1BTa/CxP/X6CoZO22NiLEk+4la0SUP5wII981JOftbmi89jhi6L+e+kvhfj3zPGVobuxED2p+OxoMv5eecTSz5uK0SWFxwlxrhDSYtk2BKoaDm2PYd/IlJrX6uJ6J2k2tCWBZxFDeZgYMSylBmVZQqWA4TDoP8Zuxocf0WzWWzzhcG56w3PQ+zvkt9vO+FcRyxDZgJKmWVzkjUux06A439gd7DC/wM7L1xMwRoiOOqQSPORWXHxskfHkGlPq3lfgGknOcy3Wh3g0bNLyVKgM/bMSjMtAHnquAlNtUgxrz4zRJ
 Nccu+8xg
 nF5xvUs/Gj9N1jRmzQ98sK5PARL2zpt/r566qAOhdsP7P0y9OKJvcoyw9B4+YwtwfHcVLZvzk+5QuB89/ZoHOxcQj+B1o8HcqZFG9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 09:56:36AM +0000, Stamatis, Ilias wrote:
> On Tue, 2025-11-25 at 08:50 +0200, andriy.shevchenko@linux.intel.com wrote:
> > On Mon, Nov 24, 2025 at 11:30:46PM +0000, Stamatis, Ilias wrote:
> > > On Mon, 2025-11-24 at 21:52 +0200, andriy.shevchenko@linux.intel.com wrote:
> > > > On Mon, Nov 24, 2025 at 07:35:31PM +0000, Stamatis, Ilias wrote:
> > > > > On Mon, 2025-11-24 at 20:55 +0200, andriy.shevchenko@linux.intel.com wrote:
> > > > > > On Mon, Nov 24, 2025 at 06:01:35PM +0000, Stamatis, Ilias wrote:
> > > > > > > On Mon, 2025-11-24 at 08:58 -0800, Andrew Morton wrote:
> > > > > > > > On Mon, 24 Nov 2025 16:53:49 +0000 Ilias Stamatis <ilstam@amazon.com> wrote:

...

> > > > > > > > > Commit 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only
> > > > > > > > > logic") removed an optimization introduced by commit 756398750e11
> > > > > > > > > ("resource: avoid unnecessary lookups in find_next_iomem_res()"). That
> > > > > > > > > was not called out in the message of the first commit explicitly so it's
> > > > > > > > > not entirely clear whether removing the optimization happened
> > > > > > > > > inadvertently or not.
> > > > > > > > > 
> > > > > > > > > As the original commit message of the optimization explains there is no
> > > > > > > > > point considering the children of a subtree in find_next_iomem_res() if
> > > > > > > > > the top level range does not match. Reinstating the optimization results
> > > > > > > > > in significant performance improvements in systems with very large iomem
> > > > > > > > > maps when mmaping /dev/mem.
> > > > > > > > 
> > > > > > > > It would be great if we could quantify "significant performance
> > > > > > > > improvements"?
> > > > > > > 
> > > > > > > I've done my testing with older kernel versions in systems where `wc -l
> > > > > > > /proc/iomem` can return ~5k. In that environment I see mmaping parts of
> > > > > > > /dev/mem taking 700-1500μs without the optimisation and 10-50μs with the
> > > > > > > optimisation.
> > > > > > > 
> > > > > > > The real-world use case we care about is hypervisor live update where having to
> > > > > > > do lots of these mmaps() serially can significantly affect the guest downtime
> > > > > > > if the cost is 20-30x.
> > > > > > 
> > > > > > Thanks for providing this information.
> > > > > > 
> > > > > > > > It also would be good to know which exact function(s) is a bottleneck.
> > > > > > > 
> > > > > > > Perf tracing shows that ~95% of CPU time is spent in find_next_iomem_res(),
> > > > > > 
> > > > > > Have you investigated possibility to return that check directly into
> > > > > > the culprit?
> > > > > 
> > > > > I'm sorry, I don't understand this. Could you please clarify what you mean?
> > > > > What do you consider to be the culprit and which check do you refer to?
> > > > 
> > > > The mentioned patch removed the check for siblings from next_resource().
> > > > The function that your test case complains about is find_next_iomem_res().
> > > > Hence, have you tried to reinstantiate the (removed) check from next_resource()
> > > > in find_next_iomem_res() and see if it helps?
> > > 
> > > next_resource() does accept a 'skip_children' parameter in the latest kernel
> > > today which is equivalent to the 'sibling_only' parameter in the older
> > > kernels.
> > 
> > It used to be
> > 
> >        if (sibling_only)
> >                return p->sibling;
> > 
> >        if (p->child)
> >                return p->child;
> >        ...
> 
> This returns p->sibling if sibling_only == true. 
> The return value might also be NULL.
> 
> > and become (in the latest kernels)
> > 
> >        if (!skip_children && p->child)
> >                return p->child;
> >        ...
> 
> 	if (!skip_children && p->child)
> 		return p->child;
> 	while (!p->sibling && p->parent) {
> 		p = p->parent;
> 		if (p == subtree_root)
> 			return NULL;
> 	}
> 	return p->sibling;
> 
> This is the full function on the latest kernel. If skip_children == true and
> there is a sibling, it also returns p->sibling.
> 
> If p->sibling is NULL, it'll try to get the parent. In the case of
> find_next_iomem_res() the parent will be iomem_resource, in which case the if
> (p == subtree_root) path is taken and we return NULL (same as the case of 
> p->sibling being NULL above). 

Thanks for elaboration.

Please summarise this, add the performance test results and send a v2.
Seems okay to me.

> > Can you elaborate how are they interoperable?
> > 
> > TL;DR: I don't think it's an equivalent.

So, it's not a literal equivalent, but it behaves in a very similar way.

-- 
With Best Regards,
Andy Shevchenko



