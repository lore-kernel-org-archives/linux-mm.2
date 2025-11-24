Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 074E3CFD34D
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 18:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE1446B000D; Mon, 24 Nov 2025 13:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D922F6B0027; Mon, 24 Nov 2025 13:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCF436B0028; Mon, 24 Nov 2025 13:55:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B92C06B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:55:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7624B130965
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:55:40 +0000 (UTC)
X-FDA: 84146404440.25.A6707EC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf04.hostedemail.com (Postfix) with ESMTP id A70D140013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:55:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nBm5f1U1;
	spf=pass (imf04.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764010538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F14CVMhl/5alGcvF2OzICTuBVrUrhvErRXTXtYinCFk=;
	b=XRG4QUrq0i/DnSPuQ9zW0bHB4p6EesBwyIFMw6Cm+7srx+gd6iOxlfp/6AlPGYTlogzCeb
	hx6HokzIyiIkSszNAN14bEEQ0e+OVe1J/NCWbBH9cnIVdliGvOsG2rMeVpRM2ApjHsGONQ
	281JMQcm9XdqG6+P4CFwfLlOP42zIT4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nBm5f1U1;
	spf=pass (imf04.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764010538; a=rsa-sha256;
	cv=none;
	b=sLZR3pvdw6sJkM203obB3pNH/q6MrmRTkW+W/HfAa2+E63kWvaCl2UEQgRAIWt8rEmCXZg
	0Pi2ds3sqiynJ+69s/VDgF6ijsHiSD6W3A+t3QS+sZgwMgvvWppaX0uyXnbvNJO0NcB9tl
	tzzqyr9Lp329t6DSCS8AYp4PEIkDFJ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010537; x=1795546537;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=3SE0/Et2OPNoa15k/OwfzwLXqIFiCevqJfyTaPRhQ9c=;
  b=nBm5f1U1fAEE7LDHUu6HyGpuAa0hQ0RoMUhZ7X1RLoExjaR1kXdnLAPg
   aVryqIaj/1jjxRg5/nuEHLuRJUHceuRooDnClvowMS5bbTwD74wMs2nsX
   14AO4I/pnITB2mnV7ycUcv8FuAVuOoibnoDAsBdaXdUK/vsFkKeTdJyWr
   mrj/hAzatphpUVeYWKgMIdeOsawna51xnh1VS4a1aic/4teRYMxCFia5u
   WWRtrA+ELzj6pi0JUatyRzPGG7WLyx59+f76Spiw2IDGZVtfS4Gi7BExP
   +KAHj+11FIOb3k47q8zEp0WUk44DpC24Zo52HEpOPKEoB1z1icsJtDLuQ
   w==;
X-CSE-ConnectionGUID: v/IhINgRRj22TLk+KxA6dw==
X-CSE-MsgGUID: ZnE+Qt5xQfm96P9h8jPVvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="66058546"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="66058546"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:55:36 -0800
X-CSE-ConnectionGUID: G4rRd8piQeig9kvf1h1sEQ==
X-CSE-MsgGUID: 7GI5Jl49QNujECSNvV7rRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="191676686"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO localhost) ([10.245.244.5])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:55:34 -0800
Date: Mon, 24 Nov 2025 20:55:31 +0200
From: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
To: "Stamatis, Ilias" <ilstam@amazon.co.uk>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"nadav.amit@gmail.com" <nadav.amit@gmail.com>,
	"david@kernel.org" <david@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"huang.ying.caritas@gmail.com" <huang.ying.caritas@gmail.com>,
	"bhe@redhat.com" <bhe@redhat.com>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>
Subject: Re: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Message-ID: <aSSqIzJWKTe9hs2f@smile.fi.intel.com>
References: <20251124165349.3377826-1-ilstam@amazon.com>
 <20251124085816.07dbf5a4ec6235b2943840a0@linux-foundation.org>
 <c7411175b332f3befb5bebb6a75c7b91f2c1dbbc.camel@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c7411175b332f3befb5bebb6a75c7b91f2c1dbbc.camel@amazon.co.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A70D140013
X-Stat-Signature: uq6hec34nt7ao5kg5sxjgzx989e5xjna
X-Rspam-User: 
X-HE-Tag: 1764010537-838746
X-HE-Meta: U2FsdGVkX19d8fRDgC+Z6FUgPh0Hnv/yQDIBwBxJst6hOOVuXpBtL/SEmP4mUfPZIFkrhFeiMIiaiLO8XERaJB2ydwnoipNU1L9ax/gxkAD196l2h5MJSXed+LMUvsr2W8+0H1z/iUwpQCdaZBTMyCxpooxcMHYQbqnpw2phbNDvoqCKH+aGP/IkGePeaVX5cTxFZZSEqjIkixSedRSZ3IVdM2D2toexcQ2jBz13vAF5nJhUlsD+yQ9sILVJWlaHTVCfmcC6XahersiP4Uyzf5cYuYUwypfGuGG55nIOXCZFPAha4ifF/TS8cQS642IYGv9iENdFwoPUCnMktgW0YkKsJ6yYBZ+IO5ps6hWjWZNp/Uw/4NiTBnDdaQ36sMbny+UQxnAGL9FkuHzJKWTzrkrkGbE2Vd7Lf3HnnIQNVXZqoen62IH6YE+AcuhGtulh0WepoGIexLtMlu5r0kMw/Yz8l1gyWyT5+K+8f2FyI45ldeqFiCQPEEk1xv/GvqTwB2WW8XCR4pS3totEVLrICeCWzms6TOaUN0uLtrPmDq/tm6mgOVOV7xGonmHxKEh+fYnCejEwcJMk6Xj3mZ3ASgi+WLsmy6+AxhlPAVeEjwfWLC5r5ZQOJKY3V4iy/0K4WEcniVnd42zz8vuYbb8ocFMJ+maqi1iNg4tHDBTnzwMGoyX3hZzRBuImMWvDgqm7fjUEU9ihTJto4MuK5kpx6xIkOFQ4PfAv4/VHSv+PhNZByH048Vq0FHX7S8vWvSRvN7HT0YF0DCAesNYWo72MolQipEBT8nMOduWH/hWBnjBTnAcMtN3WmiwN5YW2ZPX40AJt23tYO/aQmWkNtmt+Qzqnhc1lcIhXMPLk2PaKPvAjeGPfwa1Ua+2hBgdsBuPcvWxUVuqG7DlZ/1QC51vASnbjNba7tWQmyE/2M90M3Ta0e3gGF4X/diX0fhTMXcKVJ+V9kcWjmW8k85lnopN
 Wqc54HlI
 vQaihF3EiUoqaPQolVTPYga6gnlJfnYnysCX/RWHXBdL2bkFTdK/v5fvuRQfju/qqU3+GTiqJ6lvs8WNMg9Tbm8ER18JfLkc384OYFS+neGpLduOnnlA+YEM04FF/M0Hh2zMPP+PWCirfEKjWoMcGbbixI/7nOVmB4l6lZAM2pm8DdNPGJ8NFbiWkcyzF9/ep5JzpNsIZYUZalE5qzasOt0hjPWoYQIzIwW1BqXA3EukGVObCPQJrtZoLTFMyaHSa6Bm+9zwhi5Kzy/0hNAsnbADVzBTG+1d27hwSlxvwfgGlenU2gZ6kRr6m1pWRAQjSZlT6XFyGqqXqcwlC8tRiWjhR9pVnd2+yFxixG/euLTRfh/kRj+T/XcHOf2LKp63fmtRgYlkrZw7QSl4DZHRE1ZzdhlwMbyqo/n80x5qAsDhYyi+qMeImbcSz+4IursGuyal+V98yb6xhYscPcMo1+RC9u+t0Bkidde6w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 06:01:35PM +0000, Stamatis, Ilias wrote:
> On Mon, 2025-11-24 at 08:58 -0800, Andrew Morton wrote:
> > On Mon, 24 Nov 2025 16:53:49 +0000 Ilias Stamatis <ilstam@amazon.com> wrote:
> > 
> > > Commit 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only
> > > logic") removed an optimization introduced by commit 756398750e11
> > > ("resource: avoid unnecessary lookups in find_next_iomem_res()"). That
> > > was not called out in the message of the first commit explicitly so it's
> > > not entirely clear whether removing the optimization happened
> > > inadvertently or not.
> > > 
> > > As the original commit message of the optimization explains there is no
> > > point considering the children of a subtree in find_next_iomem_res() if
> > > the top level range does not match. Reinstating the optimization results
> > > in significant performance improvements in systems with very large iomem
> > > maps when mmaping /dev/mem.
> > 
> > It would be great if we could quantify "significant performance
> > improvements"?
> 
> Hi Andrew and Andy,
> 
> You are right to call that out and apologies for leaving it vague.
> 
> I've done my testing with older kernel versions in systems where `wc -l
> /proc/iomem` can return ~5k. In that environment I see mmaping parts of
> /dev/mem taking 700-1500μs without the optimisation and 10-50μs with the
> optimisation.
> 
> The real-world use case we care about is hypervisor live update where having to
> do lots of these mmaps() serially can significantly affect the guest downtime
> if the cost is 20-30x.

Thanks for providing this information.

> > It also would be good to know which exact function(s) is a bottleneck.
> 
> Perf tracing shows that ~95% of CPU time is spent in find_next_iomem_res(),

Have you investigated possibility to return that check directly into
the culprit?

> the full call stack being:
> 
>   find_next_iomem_res+0x3b ([kernel.kallsyms])
>   walk_system_ram_range+0x98 ([kernel.kallsyms])
>   pat_pagerange_is_ram+0x6e ([kernel.kallsyms])
>   reserve_pfn_range+0x47 ([kernel.kallsyms])
>   track_pfn_remap+0xb6 ([kernel.kallsyms])
>   remap_pfn_range+0x3b ([kernel.kallsyms])
>   mmap_mem+0x9e ([kernel.kallsyms])
>   mm_struct_mmap_region+0x1f3 ([kernel.kallsyms])
>   mmap_region+0xa3 ([kernel.kallsyms])

-- 
With Best Regards,
Andy Shevchenko



