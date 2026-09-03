Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5957C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6F26B0088; Thu,  3 Sep 2026 11:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7786B008A; Thu,  3 Sep 2026 11:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABDAA6B008C; Thu,  3 Sep 2026 11:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 884E46B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:05:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BE5F80537
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:05:57 +0000 (UTC)
X-FDA: 85172775954.04.D779266
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf30.hostedemail.com (Postfix) with ESMTP id 67AD58000C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:05:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TYi3yTuy;
	spf=pass (imf30.hostedemail.com: domain of yilun.xu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788447955;
	b=IcgWMFXK9kVuah9XAN2TbxOufua4iQo2/7ENT+kFkge8B5pKa3NMhr83qkm2EGu/8/6ozt
	EJuih5j0b/P8YTpBfahdOvgc0rtEsXGpgyuXQ7XsQchYggDi5E20GhZ0NcQdCLnScT83nZ
	SMoZrU4QPReBUmhR5Ar93XeK/MnaHb4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TYi3yTuy;
	spf=pass (imf30.hostedemail.com: domain of yilun.xu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788447955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOWrXMyQR+s1CO4lfKjtXBqGw4sLktRyQvuomc9YJXI=;
	b=7NdFTqXqCqfpbjoud47Ma8Z4qxKrQVZefwDtzNOKg5vd3xZbs80730TZUfHEgWgvzuXMdw
	ztiAhk7ftlJDewfNXurQorl+RNG9mdG6VDwIfP1GM5u91b8DMdj31ryF38MU7XMDeNVmvs
	drkvYzHon76kQne8pL2pD5zuZluhWuU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788447954; x=1819983954;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eazYFU1WdrM+maaWAMQSZUR5F1W/1naSEK3ISWsJw9g=;
  b=TYi3yTuyrSGNoiMd2JmL+OmraN8fypOEM6SYjPEGqABX4kJ+KB1Zyo2+
   ReENEGTCDpz7eAf0bv5Xoe9JXx5DZqzuQ7DY03ZB9ZI1j0H5khiDDp7+n
   XJsQeAeqXCmjh/EiXEeh5AMRGS31hIP1hcngBsp2DO+jRF1xeKLfwyGP1
   NsE9laWv4ByUHmUEVfq9KWEuQD+nkEA8a+PuCLccSWTS0QtLb8bFMatY8
   KJ9QxcXMmZvJ41ghu/vj0RoIh2ChVhvbTm2IpS+pdQJa2mJCWAp92F/hq
   NKWAWD7UHTj1OsfXvRXABfHzbu3z7I3K2r4NDNceTiN0zAF5HMGmdITOG
   w==;
X-CSE-ConnectionGUID: tgBlJKrUSV675kC/neQxnw==
X-CSE-MsgGUID: eO3wa9mpS4u+poE5y3aRCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="91444125"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="91444125"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 08:05:52 -0700
X-CSE-ConnectionGUID: b9clsSjjR3Sg112bFYiWDg==
X-CSE-MsgGUID: AFsP3Y7ZSLW+/Fjlausx/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="268443987"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.47.46])
  by orviesa010.jf.intel.com with ESMTP; 03 Sep 2026 08:05:48 -0700
Date: Thu, 3 Sep 2026 23:05:47 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: david@kernel.org, linux-mm@kvack.org, x86@kernel.org,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com, yilun.xu@intel.com,
	xiaoyao.li@intel.com, sohil.mehta@intel.com,
	adrian.hunter@intel.com, kishen.maloor@intel.com,
	tony.lindgren@linux.intel.com, peter.fang@intel.com,
	baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	chao.gao@intel.com, artem.bityutskiy@linux.intel.com,
	kvm@vger.kernel.org
Subject: Re: [PATCH 4/6] x86/virt/tdx: Add extra memory to TDX module for the
 extensions
Message-ID: <apmMy9610sunPJeE@yilunxu-OptiPlex-7050>
References: <20260821032920.256225-1-yilun.xu@linux.intel.com>
 <20260821032920.256225-5-yilun.xu@linux.intel.com>
 <aohvlMO7ehqcVW96@thinkstation>
 <aowMYbHKK4b0O5P6@yilunxu-OptiPlex-7050>
 <apE8yHrGx/bfifV9@yilunxu-OptiPlex-7050>
 <apf6WFKun8z4ejG8@thinkstation>
 <aplOhHWvaxqUJDqu@yilunxu-OptiPlex-7050>
 <aplSf00ESix5s6Ak@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aplSf00ESix5s6Ak@thinkstation>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 67AD58000C
X-Stat-Signature: ofbc7hzhz3k5fxsoyxcy8i9aos1per3s
X-Rspam-User: 
X-HE-Tag: 1788447954-287817
X-HE-Meta: U2FsdGVkX19G5/XwX6MDAVTkXkzR97Z0qE/OyprB4gIkDjPxAaRx7HfcgKh2YM+YC/1bfRfKRgH07IVh+XOTFHeC0EyOreW/Dpv/paf4koEMRwWkPfPXrzKlSydVmKWkt3EqEEGI9+aFI5XMVcfNz35H0t1FKzZufAyGUwWwzzqWu7Yby2OS+1tk50U/bQ2/4pCFN/DFdaGGAs5TguFYR/9CRQPLhUYHE6lMqUchGPT/0SxJb43KBI9x3EOBp0RnTIZ7y7iD5E73v3kQYn/e9DvNcti+QRq0S4bAWfe3MEdAmhOGdvIE+9NLKr6f5W7Q2rYTW8R7mBpq1I91lg1N9W3pU1WBZKyS97hGVPUTsSRijr8BTqfBlNT/PKy9QAoBy1h3RA2fx1Cv/dcG/gVMnbwL2Ht/J133u1Vt9RyvkbvShzTjHEKjH9vlhwfH8BAW+qW1gw93g9LeRtoxF6lmMhntXlNLR3MO9Kf49B1XiHMcrlLyVa8kaYDdPrSNrRj46TJsmGhgN1a2ht+EanFGtbM1wxPA+7TlvHxOXgMWHxP4VQijoivTz2XbDpuyDP9N/XZ3z2ywYbusn4eS9ntlUM2Af04JypvUZEM3+XergK8rBV5Iuh55jKlGn0ufTWGtEWjl7DhjlPaYZ2XIpb619nJukidiQ9bp1La5e5HitdgQlBNXJgEe0JovwvrhxCWf75Oiz3EQpRAuR8OUzDuqC3DKzGAGNWYzwkUvM1sn0POWkQdlBjUERq0hxvHp8CeeuimQwOFwCjoHINRLFCakRhY3voOn7j0SLys5E6yP+ywIZIKA94E0dmN9prr7eyZ8HL/0TbRvs2vKRlv1lxoU1q7ZSOIsBmeQBHIWvoay4BpYAe/F/0ogXqy1KJY8AitB7ni1YszBQF4DsRh3Wzngl7KmTLfwco+mXnRHgok55N8yQNbxmok73WNsobagI48z4chyKrNIJ0uCDNJlIXP
 oQw10zX7
 NxQWMyoAaW27CMKYPAejF0Y6eS8LKCaThzAnHuQ1kQWy439oSUdBLXxsiruFKtm3zR8g3+NYxrtfzQMlRRqeCk2urw25RtQTXET7P2LVRvcA7xPjjgnwS4aVRlNJkfzR8cZ+5yeSGHaVkdav/MGoOmzeTYnPp/k4hMHyEU4y3AZryCPwEZcTp1CYB547lD7cB0+2hqo3JXXup4pHh0tpE5+hmSdsYo4ER9zsWs0xtsp0Rb9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > What matters for fragmentation is not contiguity, it is how many
> > > pageblocks are left partially occupied by unmovable pages that are never
> > > freed.
> > > 
> > > So you can ask one pageblock at a time with
> > > 
> > > 	page = alloc_pages(GFP_KERNEL | __GFP_NOWARN, order);
> > > 
> > > with fallback to lower order if you must.
> > > 
> > > It also fits the ABI: pageblock_order is 9 on x86, i.e. 512 pages, which
> > > is exactly TDX_HPA_LIST_MAX_NR_PAGES. One allocation is one full HPA list
> > > is one TDH.EXT.MEM.ADD, so the allocation loop and the chunking loop
> > > become the same loop.
> > > 
> > > But alloc_contig_pages() might be a good enough approximation for
> > > per-pageblock allocation if we do it during the boot when fragmentation
> > > is low.
> > 
> > IIUC, you mean alloc_contig_pages() also gives good de-fragmentation
> > that we need. But it would be slightly easier to fail cause it requires
> > extra contiguity that we don't need.
> 
> alloc_contig_pages() can be more expensive than needed (or fail) since
> you ask for the full allocation size to be contiguous, where you should
> be okay with a set of pageblocks regardless where they are relative to
> each other.

I see.

> 
> > Multiple alloc_pages(order-9) meets our requirement exactly but the
> > falling back to lower order may create more fragments. And we can do
> > this because of the ABI definition - an HPA_LIST could happen to hold
> > an entire pageblock.
> > 
> > If I have to choose, I prefer alloc_contig_pages(). It doesn't have to
> > depend on HPA_LIST ABI details.
> 
> As I said before, as long as you do it once during the boot, it should
> be good enough.

Yes. Thanks for your detailed explanation!

> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

