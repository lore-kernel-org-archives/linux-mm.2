Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B597CFD368
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 06:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87116B0012; Tue, 25 Nov 2025 01:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EC66B0022; Tue, 25 Nov 2025 01:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C076B0023; Tue, 25 Nov 2025 01:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAFF06B0012
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:50:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EF7B13BAC3
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 06:50:29 +0000 (UTC)
X-FDA: 84148205778.12.3FD85C6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8AA47140009
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 06:50:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kW3RNluc;
	spf=pass (imf26.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764053427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QS2RVGjxo/DbtOg6zznP+AGrJ/cXivQhclrCou/9ots=;
	b=kSa3ksP5ZvTpLR2s5t/Y58cyprGAec+rd3iv3nXBrr3IQhNtG7iDSOFwV0ByimmMYFj5yy
	w+CKuNlKoiKiFkHH90ShgrWOE+sE5CexrAYwGbNcxFMflTj0nxMr2++RgwkUcTDhINJhdt
	OkY3340eXcGrlFQTw/vZ+kFMCAsfLLY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kW3RNluc;
	spf=pass (imf26.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764053427; a=rsa-sha256;
	cv=none;
	b=2qZlsgjc1kVcQfOYsHxZ20LoZK1f8XMrmfWbquCvE8OIKPUJ+DhRFOlWXVdrbuJ/uS4Ff6
	F7vVLr01Ml862L1AzfGGDhsh9wF2WYn54SkCSNGgJQJhNBf6ObCQNhyxvRGyXX018hrEym
	IX2uJ03F6lxvKE/pUWJ3Fovfe4EDIGo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764053426; x=1795589426;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=GP5x2wXUEGliCLTfZ2baoJMi8TotIkX5B+6PzpiiFJQ=;
  b=kW3RNlucJPBzywMNJwQ3arViv1vZrMheiXlrH6SSkWhVFYIvlryFfSzZ
   ICwa0ypB5MJ7B4K390G11UWkduBeJ3SMm1ywMblim0hf5aku2K4PC3lwy
   OB9yN1HAsHCf41QiAmgnvQjiq078wmZJxyK9M4oStb91Ez0Cfa4dAC6JH
   j4sRWI3F/oullHon9MEqZlKxecBFeod+dPq51rxWNNidjsbGKCsSnj/5Q
   rSsGTSp2lwk1E6KBS1SsnusHeBKVYILaDxh4iPGYX1NPhn55NQWfcqCD5
   zeooBP+tSVyL5J4np45ceoZmhK9wNwzjb2SAtNu4/yeFudvPs3nLtSeUk
   Q==;
X-CSE-ConnectionGUID: 62Gu1FolSEqMSV36VoyECw==
X-CSE-MsgGUID: CH2V1sdgQY2bv0s5LcjJNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="66108068"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="66108068"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 22:50:24 -0800
X-CSE-ConnectionGUID: uP2AE0rCQQeN5wNC1WVE4Q==
X-CSE-MsgGUID: qJcQNfFvQ2iZ0DZqQwfnSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="192361094"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost) ([10.245.244.152])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 22:50:22 -0800
Date: Tue, 25 Nov 2025 08:50:20 +0200
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
Message-ID: <aSVRrEDV1hWKhRmp@smile.fi.intel.com>
References: <20251124165349.3377826-1-ilstam@amazon.com>
 <20251124085816.07dbf5a4ec6235b2943840a0@linux-foundation.org>
 <c7411175b332f3befb5bebb6a75c7b91f2c1dbbc.camel@amazon.co.uk>
 <aSSqIzJWKTe9hs2f@smile.fi.intel.com>
 <f3fe7efd74c6011ddb35e1f1e90eba43af864aa4.camel@amazon.co.uk>
 <aSS3kXfoBppO1a-Q@smile.fi.intel.com>
 <de5d9d0658a8966ad8e523a84185398c216726fc.camel@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <de5d9d0658a8966ad8e523a84185398c216726fc.camel@amazon.co.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8AA47140009
X-Stat-Signature: 1p1rwxyeko11jhyc3an4xtmha76af3og
X-Rspam-User: 
X-HE-Tag: 1764053426-98157
X-HE-Meta: U2FsdGVkX1+FUUroLTNVxRsPBtw3guEk9KNETq3mksDiFlAFECerjPTsg8PJSxhBmKs6arsfM4BWsWWCiIvRn6bY9AvXtQH69MVBK4ldnSFB1Un0V6CBzUnQlYdy7Wy+s9O4iusKMjvTonVcDFRmLVxVB0+KKV2UZ+/SHagWr4g4VW4+LRN/FmoTRTGEZhsHKVLdU8RtpP1smt0PuHvVRkuM6FvtLPZLhpfK7fzfYnR06k0MYEeqwmy3aMj8vCRR57qQlt8rSFP4aPW02foVxiSFSXpj8frwnnD2kQvtIFFza7Gv2USEKIuSHuykN/3B6wzw+Moh6s/JTunXZVoB1bUPmV1i4485XR19QXX0YTl4m82sTDI50KxCkmfJ5GI2Ktw/ld+KblTZHC7bfSf36lz5B9cdSHfXdy6fW0G+f9mR6dgltnjobkAhg0QBxTSYg99wyzv37fxYHhbufq8DXGQXUf7BSKbo5KYd1l/eOrb3sV5GbYoikJRjloQUkcATyG3QNMcIAj0KnUNk/nwT3+pnjInhWF/8C7JTwBKh5ewNpz4W80ZmGHngKhIEPN113WOsMwzSMR345Ip4CC/T6byLLmNghNqkcwdxosCFcX8OAxoELDlrvKVl08D2swkwTtVPrDfTz8O08o7r5u3QdpabNqdPRTA2QqhY/lhH/wmvRwjahxQf28LvnkbQsWJGsix9iKLVKwdhAt30zA42Q0UHGfIlgpaX/5l5Szn/18cUOLRWNiSXws41W9MGkxHGo3Fkb7isS5JC+UA8ag8GH1A7S4SqC2sotbhAcYmjIWOoPiUSji2hTULXpt7sXEwcj1T67AI08zuqA67gk8C9UyJ9RwzOdbi4gND6Qo1OVIg+d4C8COKZri9e41ZBMCQvw4kEwKs8YQ0ssrWRm/HgMSaBtt6Ya7RvgXqY6zKfLNQj5lklbrykMdcYdfhAXAA+rtAPJO08lnimEjQFbsL
 /Z7NwyuA
 c08DxxoAIHo/T5tyELnJMkPM7Q6UzgGmlqtcc/52XrI8wRNSF7LPxCc4fXJuqjBJYnyxqFLElqYea6Vjlb2I3Jpmbyt3G18XiEK+gWaDTvOOiLNKJmU1QXh2j75fj++Ig+xGxCEO7eN/75+SzGQIKUIba8jckMEF0/sTiIN5DM5MTnH72LpHQrmambkP4307GlDTPAVbTTIGj7E8EvBpXMI3p4ahqlf8OZyYe56hK1FaQhaM+VBFz2FV23kXe9b6z2pvJM157d7llotKJgDd3005AP0lHXutxoRzJAFNMsZmClya7YmyO/1sKCBQwHmxp5CKe5GsiMVVnBhZ+z3jpseMqouvt/fHuSOiaLdwIKlxYC2yoSoJzC1NC5RrMnQX0A0IvM+rmrNQAHgk+u888Sc78C+YHKt7skq74tWfrwkGm8V3eZ4PBY1F3A1bGk9XE7650LHVMiZitvrgjnStJT7gndCB7NUlolF6R3yKisBwdk9rCNXKWPTsCaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 11:30:46PM +0000, Stamatis, Ilias wrote:
> On Mon, 2025-11-24 at 21:52 +0200, andriy.shevchenko@linux.intel.com wrote:
> > On Mon, Nov 24, 2025 at 07:35:31PM +0000, Stamatis, Ilias wrote:
> > > On Mon, 2025-11-24 at 20:55 +0200, andriy.shevchenko@linux.intel.com wrote:
> > > > On Mon, Nov 24, 2025 at 06:01:35PM +0000, Stamatis, Ilias wrote:
> > > > > On Mon, 2025-11-24 at 08:58 -0800, Andrew Morton wrote:
> > > > > > On Mon, 24 Nov 2025 16:53:49 +0000 Ilias Stamatis <ilstam@amazon.com> wrote:
> > > > > > 
> > > > > > > Commit 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only
> > > > > > > logic") removed an optimization introduced by commit 756398750e11
> > > > > > > ("resource: avoid unnecessary lookups in find_next_iomem_res()"). That
> > > > > > > was not called out in the message of the first commit explicitly so it's
> > > > > > > not entirely clear whether removing the optimization happened
> > > > > > > inadvertently or not.
> > > > > > > 
> > > > > > > As the original commit message of the optimization explains there is no
> > > > > > > point considering the children of a subtree in find_next_iomem_res() if
> > > > > > > the top level range does not match. Reinstating the optimization results
> > > > > > > in significant performance improvements in systems with very large iomem
> > > > > > > maps when mmaping /dev/mem.
> > > > > > 
> > > > > > It would be great if we could quantify "significant performance
> > > > > > improvements"?
> > > > > 
> > > > > Hi Andrew and Andy,
> > > > > 
> > > > > You are right to call that out and apologies for leaving it vague.
> > > > > 
> > > > > I've done my testing with older kernel versions in systems where `wc -l
> > > > > /proc/iomem` can return ~5k. In that environment I see mmaping parts of
> > > > > /dev/mem taking 700-1500μs without the optimisation and 10-50μs with the
> > > > > optimisation.
> > > > > 
> > > > > The real-world use case we care about is hypervisor live update where having to
> > > > > do lots of these mmaps() serially can significantly affect the guest downtime
> > > > > if the cost is 20-30x.
> > > > 
> > > > Thanks for providing this information.
> > > > 
> > > > > > It also would be good to know which exact function(s) is a bottleneck.
> > > > > 
> > > > > Perf tracing shows that ~95% of CPU time is spent in find_next_iomem_res(),
> > > > 
> > > > Have you investigated possibility to return that check directly into
> > > > the culprit?
> > > 
> > > I'm sorry, I don't understand this. Could you please clarify what you mean?
> > > What do you consider to be the culprit and which check do you refer to?
> > 
> > The mentioned patch removed the check for siblings from next_resource().
> > The function that your test case complains about is find_next_iomem_res().
> > Hence, have you tried to reinstantiate the (removed) check from next_resource()
> > in find_next_iomem_res() and see if it helps?
> 
> next_resource() does accept a 'skip_children' parameter in the latest kernel
> today which is equivalent to the 'sibling_only' parameter in the older
> kernels.

It used to be

       if (sibling_only)
               return p->sibling;

       if (p->child)
               return p->child;
       ...


and become (in the latest kernels)

       if (!skip_children && p->child)
               return p->child;
       ...


Can you elaborate how are they interoperable?

TL;DR: I don't think it's an equivalent.

> And the for_each_resource() macro currently used in find_next_iomem_res()
> calls next_resource().
> 
> Hope that makes sense.

-- 
With Best Regards,
Andy Shevchenko



