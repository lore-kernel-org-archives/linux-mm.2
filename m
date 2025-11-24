Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3688CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251BC6B0024; Mon, 24 Nov 2025 05:56:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229996B0062; Mon, 24 Nov 2025 05:56:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166B96B008C; Mon, 24 Nov 2025 05:56:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 01B3E6B0024
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:56:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 905D3C0302
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:56:52 +0000 (UTC)
X-FDA: 84145197864.25.BE0C636
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf09.hostedemail.com (Postfix) with ESMTP id D3A9D140002
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:56:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="E3yef6/S";
	spf=pass (imf09.hostedemail.com: domain of yilun.xu@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763981810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K921GUWWt6+USM+kgbOzZC7RBbZhsnM92Mx2Xq0DOTo=;
	b=psA7r7ZQGGv9roaqPjZ+xSVLJDExSjXWMOGtzYq60wGAtlRcBv58YI8xOaAVCaqNvjkJB9
	o8XBipNib7ddLHc4YhJcQQ8fvd/GXFdTQFYj3hJQGNWg3RhXf2T9Mt2ofahFTCKkenzc7C
	OWV/LV9A4hp+byhVyg6dCqskxLMgvBI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="E3yef6/S";
	spf=pass (imf09.hostedemail.com: domain of yilun.xu@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763981810; a=rsa-sha256;
	cv=none;
	b=RBirlLDwgYX0kzqwuJpMrhRBwKPJD6A+FRTG0wu6gTJUuwBiGCEffGBGskT9MW/64ou+mE
	RKKh/Dx5tK+fzFt01M06HshgNQ8elv7njL3tr273hO4NSRQ+cZeqPozOenSo1TIvItBdLc
	z4ZI64/3lEplvYaqP50DxvTqBCFdgSo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763981810; x=1795517810;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ozqoEWoU3Kf1FbVG4nlV6Tj44DWQiviD0axSH3wKX2M=;
  b=E3yef6/SNlXRh4eJYHGM7OAIKq2y2zF1IhjEuhjlEr4aOv5ggkO+g5Tt
   JcKvM80bBf2ld/UX+pdjxcWpMYS3dQDQDDMo2kFYW3/VLRksxCPSxvGG7
   fK7CEX/e9IAN4RsWnl6e8XV6aP+PMRGdA8UFxFiaeIGC9ozbG3mSGc3Ej
   HGaEkvqj4j5okx5bI3auoR2zF+ygMkT1Y2YyQogHWa7jYRz4bjUwSipH4
   iJwanc2Hf5eEVj1ZWE3W7qWiDP+DrshIIcFf9iYJfrKjzGBlFONO4e4nl
   R0bqJsioU0+9FnHnnCSRuXNQGjdJzgVjYn915wCfd+aE+VqnM+J2be3L0
   w==;
X-CSE-ConnectionGUID: 6bZxFVHASb6RpXgfKzMKrg==
X-CSE-MsgGUID: 4Scr/APcRDmVWr5g9L6KaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11622"; a="69595626"
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="69595626"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 02:56:48 -0800
X-CSE-ConnectionGUID: d5ttrlYNSTKYFXDY26Ke+Q==
X-CSE-MsgGUID: VbFlN+PqSTexeWyOMinz1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="192540319"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa008.fm.intel.com with ESMTP; 24 Nov 2025 02:56:45 -0800
Date: Mon, 24 Nov 2025 18:41:42 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH v1 08/26] x86/virt/tdx: Add tdx_enable_ext() to enable of
 TDX Module Extensions
Message-ID: <aSQ2Zl5G+j/2D/KC@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-9-yilun.xu@linux.intel.com>
 <cfcfb160-fcd2-4a75-9639-5f7f0894d14b@intel.com>
 <aRyphEW2jpB/3Ht2@yilunxu-OptiPlex-7050>
 <62bec236-4716-4326-8342-1863ad8a3f24@intel.com>
 <aR6ws2yzwQumApb9@yilunxu-OptiPlex-7050>
 <13e894a8-474f-465a-a13a-5d892efbfadb@intel.com>
 <aSBg+5rS1Y498gHx@yilunxu-OptiPlex-7050>
 <ca331aa3-6304-4e07-9ed9-94dc69726382@intel.com>
 <167d9540-2d9a-4367-bc68-b96494bc4044@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167d9540-2d9a-4367-bc68-b96494bc4044@intel.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D3A9D140002
X-Stat-Signature: gfapc9pr5ub61dy4cgryq9hnu3z7z84n
X-Rspam-User: 
X-HE-Tag: 1763981809-189686
X-HE-Meta: U2FsdGVkX1++1Zg9HZBRU4A//6rj/d4ZrJfE5+SbzoFO2lG7oYve99yupervRKcXLgAeWamZJv2vNzonrreTY+8DZWb4DHbxFE3SKi2Cir6xrxyvU2mo2DBXLrQF8JlwPobS+KuTLLbu1SPpsC0DuvhUmeOdvw4aFD76iLtlU1rxX2WVWafuFXFzfRdSyXt2D0A5GdRAp6xHgWyPG+N2uihMzDAm6s2/ZmKuP6VZmaGMnxEQqYcvawExiy45A7IE1PYpyoCgopzPZJq1Yq+5y/dezM4yoQYnSae0/Y9l9//OJ9gsT26mdKHqJqAEX8PLQm2UEgzVkrmn+ns/+U/LARssCZ8znZNsuB9q/hv32bCZvw6MkUidqd/uqG+lO+nB7CEoNr0SxdNhKqtFCwgPpgcZZE81ac1QZyfX5roUs4EytZaq/JWzdl5Cd/QOCer8ZGON8NkzNL5kM+FWDpJa330vwIDh2mZtZ7+8XyF3hfG2WNc8FmmGMzSLIlqzkauD//YAxi8VZwxBWu6piGAnLkDSMM9dmN+aeJwDqPIev7aa3ziOIYxDYw0M0htju9h/lI9BmmUm5A19sY1TGaLSBMhNAUwwwWiL71UZAMwyvccpBsi6oDeVpRAlXf9pgu+jSnVjTk1m4FvsxegSphDssOxVzB0vJ8zpf+tvO5jpehtcrwL/SHz8RB48gWKV2XMyYOMb4v8VuyXiICfjbGinEQYAIUmeTJEoN6gpkZumPK855LUHksDsF3D9IrwBOTDr6RcTKlToAP575zzTjBxZLpw1ySsIo4segZZgYbWJ3Y/pagmLMqpenK8bwfIzvYv2b87Ul9jqVK9b7f2slnxtbw1R075CZuqJ5p0OiyKScYNCB4b8ludar35B76c37r22sGB/uFwMHdtz+mKXGpMORt8cmI7huFgXX3kjSlOzUd0gTJhOwZfoPYzCCnKbJT+rM7OrCHC9C9LyhltKTfJ
 c/whkaeP
 kGumQXK+ok1Vjq/JWej8mNItnjSMdn8qgwRPaRul+HVw1YYVHaw41rt7gPSraqzlqqGqCSiEqMHt5RdPLqGT0lWL6oVOAeJk6tSXvfXdUHLUS7RO7aiUORJdS42e6VHVexsqlK9D/U6+3yxi/XhbJCy4VoovI3HFKde9Uu7BzRlveuMa7Iw9RkfEZJyZZ1GyMimnDnWevKgxIYa/QlUkHH3f3/82dawajDCRHFMMBZF6rbTon7AxhAr4eZ8qHoNt9nscOZ+rbnLPYIoFDu1qbumYwXciEWHmpufB7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 07:38:03AM -0800, Dave Hansen wrote:
> On 11/21/25 07:15, Dave Hansen wrote:
> > On 11/21/25 04:54, Xu Yilun wrote:
> > ...
> >> For now, TDX Module Extensions consume quite large amount of memory
> >> (12800 pages), print this readout value on TDX Module Extentions
> >> initialization.
> > Overall, the description is looking better, thanks!
> > 
> > A few more nits, though. Please don't talk about things in terms of
> > number of pages. Just give the usage in megabytes.
> 
> Oh, and please at least have a discussion with the memory management
> folks about consuming this amount of memory forever. I think it's quite
> possible they will prefer it be allocated in a way other than thousands
> of plain old allocations.
> 
> For example, imagine memory was fragmented and those 12800 pages came
> from 12,800 different 2M regions. Well, now you've got ~50GB of memory
> that is _permanently_ fragmented and will never be able to satisfy a 2M
> allocation.
> 
> You might get an answer that it's better to do a small number of
> max-size buddy allocations than a large number of PAGE_SIZE allocations.

Loop in mm folks.

Hi mm folks, for Intel TDX (Trust Domain Extensions) feature, there is
a requirement to donate quite a number of pages (12800 x 4K = 50MB for
now) to TDX firmware (known as TDX Module) for its initialization. These
pages will never be revoked cause the TDX Module initialization is a one
way path.

The TDX Module doesn't require these pages be physically contiguous, and
the patches [1][2] in this series [3] does PAGE_SIZE allocation. But as
mentioned by Dave, the donation may _permanently_ fragment regions, stop
them from 2M huge page allocation. In worst case, 12800 x 2MB = 25GB
memory region.

So is order based buddy allocation a better choice? I believe so.  And if
that fails, should we fall back to PAGE_SIZE allocation? Or PAGE_SIZE
allocation should be a hard no in this _permanent_ donation case?

[1]: https://lore.kernel.org/linux-coco/20251117022311.2443900-7-yilun.xu@linux.intel.com/
[2]: https://lore.kernel.org/linux-coco/20251117022311.2443900-9-yilun.xu@linux.intel.com/
[3]: https://lore.kernel.org/linux-coco/20251117022311.2443900-1-yilun.xu@linux.intel.com/

Thanks,
Yilun

